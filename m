Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CC7FC55182
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 13:24:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F79A6B00A5; Mon,  3 Aug 2026 09:24:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CEBB6B00AB; Mon,  3 Aug 2026 09:24:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BDE26B00AF; Mon,  3 Aug 2026 09:24:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 025716B00A5
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 09:24:37 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 08CE7C06E7
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:06:02 +0000 (UTC)
X-FDA: 85059829764.25.378A3CB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id E724720007
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 12:05:59 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oOx541gt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FLE+1tID;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Drjhk3Pq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/OcfPZS";
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785758760;
	b=qScF6i8F4DgJhEWio7Eh5jHt8Kn2smPwlLs2+7geIFuRwsG2NxCqZ2Iti+/+15Tc4Q/UdP
	XCKRzNcpdLWc5RodiCjPsC0nSCNVTaWLeR3AU7v4QsJ8wc1K9/MjPMzNh8QrDmF4ArgfN9
	VzDExAxR50qA6fFGEYu0QX8ro1U8pto=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=oOx541gt;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FLE+1tID;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Drjhk3Pq;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="V/OcfPZS";
	spf=pass (imf31.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785758760;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=13O1GFMNxKQnB0hhDQgm+sE8ozvEF6ODAJVpfplXthHLJtuV7BgxPQdGzPaYlk6Lh9IipZ
	tIdDEddnoZqGfVB5VRHbnF9Gqhce8DvTLHZNH5R3A3YH7FF17O1vPe9jIULZzr8kaKjp9w
	t4HteTYkixNUzZCbObv93+Etbh9glpI=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A6D07F0AA;
	Mon,  3 Aug 2026 12:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758754; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=oOx541gt22lq0QRWXu05uXqeeieN9svZv+KvcMIQRImXrRzMOUwVLTZdNErb5NtrdYGB/z
	8Zhm5/2jSj3eKXit14/TXb38D7L5/mlfpE+wJ65q6TNL8KfGt93bxn7YlMHX9m1gmizD78
	9M8x8WUVGODr0S/CnGaQqkFLQZO6ZYo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758754;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=FLE+1tID/Wg9Wvs7Ii4sUKFfMXzWF6OgwZ1IPgy2Y6hEnkjXmLVf/iCseBI+2F6DnN5h2R
	4XwjEl47MmhbQbBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785758750; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=Drjhk3Pq9Sl/s+EUwvpzBJ0Qfz33eMwIckfN+kal47jxKyxzyxY7SoSg5mfiVtJFkhtD1Z
	QUtvxkO0/KxvPqx4wYOgqzrTCIcHapmvPHARtlZCIpTN8EYAlE9yOYyJv2qpuT7Y7hqP9m
	RzVA9a3m88BVWyS39jBZ7rzohJB1tjM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785758750;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2k/812Bz06aoM1Nozk9NLcznOhQ34rc/L2cEjcJolMw=;
	b=V/OcfPZSDwBwcZJAnrKc7JHCc1svX0Q0GGpuWlRO1F1ux2MiWqrbUx/ffnzWldyufmkJRj
	vYbE+01VEWYc7GCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 907AB779A1;
	Mon,  3 Aug 2026 12:05:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id B1tGIx6EcGp+NQAAD6G6ig
	(envelope-from <jack@suse.cz>); Mon, 03 Aug 2026 12:05:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 4EC94A13A4; Mon, 03 Aug 2026 14:05:50 +0200 (CEST)
Date: Mon, 3 Aug 2026 14:05:50 +0200
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: Amir Goldstein <amir73il@gmail.com>, 
	Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Laurent Vivier <laurent@vivier.eu>, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	stable@vger.kernel.org
Subject: Re: [PATCH 2/3] binfmt_misc: don't warn when the mount is completed
 from another user namespace
Message-ID: <lp42anrqt3khwf4fyp56odomifxeuitf4ejxahhxns7ze7nyha@dblztvmz4ocj>
References: <20260802-work-fill_super-warn-v1-0-4e987911a39a@kernel.org>
 <20260802-work-fill_super-warn-v1-2-4e987911a39a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260802-work-fill_super-warn-v1-2-4e987911a39a@kernel.org>
X-Rspamd-Action: no action
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E724720007
X-Stat-Signature: if1w3k6ndr8dqmp1kouao3dnymyarf9s
X-Rspam-User: 
X-HE-Tag: 1785758759-476167
X-HE-Meta: U2FsdGVkX1/QJOoTJyh1jo/jUHUwUg7ve6dmahccWo0hm8tKbaUZIzDVRMHALIDPeid04LP/cCfi25Ui8m5X49fKOYZHjlGu10mXFOdEeuepq7WyakXiV9+KoHAqVY1LnU8iEbcfKXJZlh5Oq/oW9ruvk2ed5gNYd1OpyJunMwcVtUPt4r11LoYhJVUrmdDOP2960f2hyNzEOPRuMSl4sUOufyjVY8slYiEZOL6wiHPWDhv3tHGXt7ne3GSqeC/qB/C6hgsH5GLIIPrRndMqMU+CyfyohOpI44KY+EGt9F7dxiDXYDjvZBcDs1+pAKe8GR7voGD20Oqqd3+h8C7qoA0eswr9Szk8rMIeo5+9n92nzFB7Zyt1TRk8uPZXRfPDSuK3FVtsuR9Gl06kB42AinWg32c3NckUv97Pa8ld5+zhCQ8Geb4jaR0+wfcpRTZ/ixa1ekXMvYDYD4YIMl4/iC7U8V00D5awkhOBTM9WfKot9SQInxwEE4DQipcFk2wQNO0ccuiMMiOhSBuK25gOj6fPhAJn7gNXiMGSW4FsZJTAu3GK7lMfBJFZ+qzBnfQyxav4DTZnhhFBJrd7RV2vP+b5z63i/SKrSbnE6nAhIaLYe3DrsKb2VTLk9hATg9GsMFj0Ron5LXXhfF/sAtn2mg6lnxmXH9o1vShhPj5fX1D5ExJ0PI/n+ZxqVYutL+yHSmR53S+XwGptI6giXZrGEGw6ulrzc55U7TJc2q2HXLUZHAcnbf/S+5fdraDAAazgwaSVX5m5hWy+f9au1HfU5f3m9FgvTjRsrZTa1CQzrO1XgBxa7zw+jeipodMtHDkz//laLIeOlN+8IlXC3CygS3FiesnfKkmsgvz3g5mIYoegPdYY0JsIM9BxvIKAXQB/I/F4YrmxkCEq38LyZ5tGyfrwfstpfaiPV8FdnG6nOSClrQFXuEK1WDSpGm9Dx+AFUWKRnZcHqeTW8x+0P0n
 yAAd7CxK
 CK9CvXlAFtWPsqdXExzlaBnJ0K53t4RCEa793czI4DMYJVJWAcKT2cAHfsX7HKQZJEQLqVvSRN+DbkIy1CP3cUTQDoJMFNN9h2s1LXHdKg3hMNzBw/mvZn60slzrIFfC0d45VnlEQDOqiNfoIAtcDsVgxO5Hw9pGr61GOjBllCiGdV4sbECgJ9pgNV6WBRQ9y3iRidWapbYazn4tU5XLLiqxjKOFTlZDpHpMxV/8uxz1klcYs43X55MUY5pdM4ZmPcaiE0e96BN6HYdqA2w2ApVIzTIq1Pu5sZQhjc78z1zhk76DQQA2ElVnGqaZ8rkkK64KzKx/9pa7cJzmZAy0skXDdlkOS37VsIS204nyojpAM76a2rV0mhLEDfP8j7CgALZp5G6Tkr5jZiRyFsyEJXI59qGvdWgJSfT6vL9iF3g1SCQdu1Cx6mm/A7Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun 02-08-26 20:00:44, Christian Brauner wrote:
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
> So an unprivileged task can reach the WARN_ON() in bm_fill_super():
> create a user and a mount namespace in a child, call
> fsopen("binfmt_misc") there, send the fscontext fd to the parent and let
> the parent issue FSCONFIG_CMD_CREATE. Both namespaces come from a plain
> unshare(1) and no capability is needed anywhere:
> 
>   WARNING: fs/binfmt_misc.c:938 at bm_fill_super+0xa2/0xc0 [binfmt_misc]
>   CPU: 15 UID: 1000 PID: 3243382 Comm: fswarn
>   Call Trace:
>    get_tree_keyed+0x7d/0xb0
>    bm_get_tree+0x34/0x90 [binfmt_misc]
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
> Keep refusing the mount and stop warning about it. Nothing in
> bm_fill_super() depends on the two namespaces matching, it derives
> everything from sb->s_user_ns.
> 
> Fixes: 21ca59b365c0 ("binfmt_misc: enable sandboxed mounts")
> Cc: stable@vger.kernel.org # v6.7+
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

This one as well. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/binfmt_misc.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index c97f10b48b5b..613dd28e3f1a 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -937,7 +937,8 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  		/* last one */ {""}
>  	};
>  
> -	if (WARN_ON(user_ns != current_user_ns()))
> +	/* The fscontext fd may have been passed to another user namespace. */
> +	if (user_ns != current_user_ns())
>  		return -EINVAL;
>  
>  	/* Never exec off this instance and never let anything stack on it. */
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

