Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0DEFC55179
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:22:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D5856B0098; Mon,  3 Aug 2026 09:22:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AC5F6B00A3; Mon,  3 Aug 2026 09:22:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 79BC96B00AC; Mon,  3 Aug 2026 09:22:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 444BB6B0098
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:22:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9CD731C11AB
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:05:52 +0000 (UTC)
X-FDA: 85059829344.14.60A6153
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 5A72A40007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:05:50 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qR6eKlKw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BZAiIMkw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eLdxZkJc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vGVVMShC;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785758750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=0b6pLNC6cmY9udDk3eX0Bcha6fcL8i95fhE9fEN7/iG4rAnlTOpam6we5EReS+WS9g4ezj
	wji5pQCICbpNCktVKf8tokmijjX8QrOvGJxQFifMuGHbZ8brRAO0ryM+VOQqQAIM88fB8R
	mUWIeNuOQsk+2ZDbxbJfoo37HND6qAA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785758750;
	b=YKV2Tb/R9mT0wmUbtBY8la9FNsFUILSx2yz+8qnz0buvHBUB5wH7GE1SARY0Ur73cvzTBk
	ycc9vTPN8fz+e9/A7yGgkG4y+2ofyyYTD8n13C2r222ldGJgGiCMfAHubt9YlRpnI8L7kv
	jaQDDFFneQnX2cWBC1Y3cBUlP1MNm4g=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=qR6eKlKw;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=BZAiIMkw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=eLdxZkJc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=vGVVMShC;
	spf=pass (imf07.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8199D7F0A0;
	Mon,  3 Aug 2026 12:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758744; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=qR6eKlKwsVqJ2fBOlPW1CERKuW5dfE+bdWJIPXJpRCetRMTFRTSgZMIpcvOMg55PYQ0+6b
	uaTtErYcQ+XDggYDyWZznr7UMOefcejeHS31EAM4Ynm3Ysd8CCkXF+qTmB8kBzQQx4/nYn
	Y5n4T1zJLJR6EF3F07uY1ldMe4K4Ii8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758744;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=BZAiIMkwuhb/qHEtkW6r/ImNKzfl8pHpLKDer45EvsQZCeUvE8iP2gMB+KVkYVentFzyB8
	akCTrXS1lYZW4EBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758740; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=eLdxZkJcyym2hya8zcTwZUAt93qjx2KZ+287tbxat+dgcMMYVUceXOJ4YfIR4HaDvHj5xM
	IN8MU0c/aH5LFUOH6HcJMQ/+RkeDsyk+elIfR9LjFuJI+X3Qd20N/8ZXxCI1731sptJ8Nm
	V0Sco1KxyiapNkmQT6/Und2Qpatb7OM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758740;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8XrW9jPvYLT+yJolHSZeV1xbelIgml749r9l2fLqeHI=;
	b=vGVVMShCSxEqBi+PBGqchTq5etMt0X1X5CpcTAnY7JNa+Bh/UW3yFjkw9oQw9XtWB3cMaK
	P2x7U7WPKmFP9GAw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76A1F779C1;
	Mon,  3 Aug 2026 12:05:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 5BXxHBSEcGruNAAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 12:05:40 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 1B061A13A4; Mon, 03 Aug 2026 14:05:36 +0200 (CEST)
Date: Mon, 3 Aug 2026 14:05:36 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Laurent Vivier <laurent@vivier.eu>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 1/3] ovl: don't warn when the mount is completed from
 another user namespace
Message-ID: <s47cadp2vvo4ybfbivknswng3ze3fvldlcspm7mygzkmxo3aas@tivvzq4d2f6k>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
 <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-work-fill_super-warn-v1-1-4e987911a39a@kernel.org>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5A72A40007
X-Stat-Signature: akdczuay8zeo8oebfprd4wi1j31a7sxf
X-Rspam-User: 
X-HE-Tag: 1785758750-96267
X-HE-Meta: U2FsdGVkX1+pnKzr1WLBeR7cPr/Kq5S0chZLB7zy6s4cRPq4BPgsuJ0IvQdHxvd6L/8FS3+Mcb59mXDkkE8/8YU2ZrmEf0khd/da97voWa02eDzyslUCTbtAbdKpGnZsqmDd6G7O0zIAGOzLvCzLjPejYg6K35FUHUE1A62LfqfJY85xQo5saspqqWig7SaP16Kic9D3nHdnWnJIQIJ9+XVWCzjoGcdZmui4TQe+L05Evm5DkDDpUUFEhnsORvdxFfT0jwThpuGMSj0jpunFowXxIo9gDxW002QxS1Bp3hQrgmy83/7h0rtjJB/yRAsNM550WW7U3b0fXzCB/1KtQbFVwqZ3eahOPKEFSULGX6t+jSxc2XjAPtYyS0dzpdK2DWR+mH9KXjn52l1DlILckdq6E1Hb+uCFOUhesrvR//9eJWJfbNT65P9c9R/6AbR0RDC6yy9dUP43kldIbYoLPvfh9HWioMgIrY2ounS0n5NvSD3MpXLr7rAnZK7NQYcQSH8xB1oRkQA7GLH3pAI+F/AV9l+YVGl9/ogpZi8SAjrxOJCXKpFRec4/nFtW4++yREp+YC/6w4HDOpq7mlwf9zkqSE1tc8zUPbXhI/2wCDv7vVN/oQLGIykIgcaAQXTRRF2jbqgBnI1v6210qC8DE0iHb7LVIA8O/lut8950GU5SgcRS+ZUHs0GN/W1Cf9Jg5lCZPcnP8Mu0M4qS4LeuTDv3d6Q8Jq3fdSZmZa4Q3rk4mJR9IS81iCitb8roUTGOs+q8To5Ik1qAoYRiiA3dWaYPgcfRdfbFDfKtZD86GRH9X8VCShdWuRrrzmVRb9JRA5/mwZaZ2boBP5FLJ1H4+ykRfW9OvGZWudZBtziBXZwVqF4hL4d5/scT88J6k8TtGyXYnb17uN6jdD5XMS81m79iZbqpbOIdca0e0ywXwSy5bJdrELirqKyKmwBXRqAe8Xl+YFRw1fKUNn/8cL4
 biHlG3vs
 gDVCR+Yf35KX4ucVJER82T7oVnTTbe/t0S6tBaJjIjqtpLysH2nPBNQl2N1Jb2IeYrvTosPvj2hmtR8qVFYbDJtLawiYdB/QFvnvpO96S4m5hTxqE/xCaFkf2TAQun6m8UPS2LZ/yB7rXQUvhXD2kpzdv3vLpLv0EHwKTNKs2Tzvhr5jpHCk9Wccm3TA06zkS7ZF7PVJNuM495++IiWAPDFq5i0ibYEottWIaB5lZuWb2/72aRcTc8poUiietatmzB8qjVp8O1IvQhlJDAUd4jT7U7zcWc67d/J0BUhdlsdSgYPYF98yexc6B7YNG5GJmiewDQ+0UAZVmA0yj2F8xpJw2JbNwmwHnpP8CeWNxFg4GXTPov6AQrWUDkVB+IVmd7fnS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 02-08-26 20:00:43, Christian Brauner wrote:
> fsopen() records the caller's user namespace in fc->user_ns and hands
> back an ordinary file descriptor. Nothing ties the task that calls
> fsconfig(FSCONFIG_CMD_CREATE) to the task that created the context. The
> fd is inherited across fork() and exec() and it can be passed over a
> unix socket.
> 
> Completing a context from another user namespace is allowed on purpose.
> vfs_cmd_create() authorizes the create with mount_capable(), which for
> FS_USERNS_MOUNT checks ns_capable(fc->user_ns, CAP_SYS_ADMIN), and that
> succeeds for a task holding CAP_SYS_ADMIN in an ancestor of fc->user_ns.
> So an unprivileged task can reach the WARN_ON() in ovl_fill_super():
> create a user and a mount namespace in a child, call fsopen("overlay")
> there, send the fscontext fd to the parent and let the parent issue
> FSCONFIG_CMD_CREATE. Both namespaces come from a plain unshare(1) and no
> capability is needed anywhere:
> 
>   WARNING: fs/overlayfs/super.c:1551 at ovl_fill_super+0x7b9/0x1e20 [overlay]
>   CPU: 3 UID: 1000 PID: 3243376 Comm: fswarn
>   Call Trace:
>    get_tree_nodev+0x71/0xa0
>    ovl_get_tree+0x15/0x20 [overlay]
>    vfs_get_tree+0x2a/0x100
>    vfs_cmd_create+0x60/0xf0
>    __do_sys_fsconfig+0x4b2/0x500
> 
> The child needs the mount namespace because fsopen() itself gates on
> may_mount(), which asks for CAP_SYS_ADMIN in the user namespace owning
> the caller's mount namespace. fsconfig() doesn't repeat that check.
> 
> It is a WARN_ON() and not a WARN_ON_ONCE(), so the condition can be
> raised in a loop to taint the kernel and flood the log, and it panics a
> kernel booted with panic_on_warn.
> 
> Keep refusing the mount and stop warning about it. ovl_parse_param()
> already spells a user namespace check this way for Opt_override_creds.
> 
> Fixes: 1784fbc2ed9c ("ovl: port to new mount api")
> Cc: stable@vger.kernel.org # v6.5+
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Obvious enough :). Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/overlayfs/super.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 60f0b7ceef0a..60b808b85fc4 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1544,7 +1544,8 @@ int ovl_fill_super(struct super_block *sb, struct fs_context *fc)
>  	int err;
>  
>  	err = -EIO;
> -	if (WARN_ON(fc->user_ns != current_user_ns()))
> +	/* The fscontext fd may have been passed to another user namespace. */
> +	if (fc->user_ns != current_user_ns())
>  		goto out_err;
>  
>  	ovl_set_d_op(sb);
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

