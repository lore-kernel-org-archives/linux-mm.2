Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 463D4606B2C8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=nxW9z78u;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=btbulXTV;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=LMpP+dRN;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=W/imUFHl
Received: by kanga.kvack.org (Postfix)
	id 592DC6B05B1; Tue, 10 Nov 2026 07:57:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 543A96B05CE; Tue, 10 Nov 2026 07:57:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 435316B05CF; Tue, 10 Nov 2026 07:57:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2106D6B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:57:53 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B4CD2406AE
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:57:52 +0000 (UTC)
X-FDA: 85419211584.03.7042A9A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8E5E018000B
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:57:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nxW9z78u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=btbulXTV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LMpP+dRN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="W/imUFHl";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u56kU65NdCHiYegRSOw5kHXRrJdKNRGx+HB56p2MoEM=;
	b=CXrb7uQBA2c/ywgDrRDkmCpUSStTnz6l1/TIwKY/2qiRxoBDEGI2kzz0O2Y8iwAKPjfg+q
	MZDPMqACeboCc7m8b42dlTfcfKGmh3iJzM1aB0wHMOdw1ZUqx1uc5ga8LVb8AS4i1/loZR
	zze/f/GyjBmOnhTG6tPCw7H60zT4xfk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315470;
	b=XX7ev+IrWakWJujj2wB8pJRp7nsZrU7byaPFHU+Nn1biEKa/ScjpRxF75q3CzWMoipvOu1
	1ReI/gVDBTTvkVOr4NSfFQ3X5sOllgK80tHbIfTBZh7eD4LNS7S0Bm+5qf9WTFQIMtq8zS
	eXSZmphhtG5/gzfLumSgR1dOS3H65h8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=nxW9z78u;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=btbulXTV;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=LMpP+dRN;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="W/imUFHl";
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3789B21F51;
	Tue, 10 Nov 2026 12:57:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315469; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u56kU65NdCHiYegRSOw5kHXRrJdKNRGx+HB56p2MoEM=;
	b=nxW9z78uWUgap8irqzft109tSowLMr4YxqMMElh/zotIXCZ4+lW6MJlBctgHBukJBaQMMw
	ruD5MFSAU2ytX9FM/2qdEFvkpAcqNmAdUGNJD859ctCBZZLYcnYQHvqxWygDJTqWEgBDuN
	FRSUFGrVUz2FcxpKnFAjouAxPqqJRpc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315469;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u56kU65NdCHiYegRSOw5kHXRrJdKNRGx+HB56p2MoEM=;
	b=btbulXTVqM14e5L5WNYafj3Z3UHSl0sJl18esve+b0N+Z+BVeu5oPzl1tx4K7dsDrr9EMi
	JJdXqRlU4e+MyABQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u56kU65NdCHiYegRSOw5kHXRrJdKNRGx+HB56p2MoEM=;
	b=LMpP+dRNJB15/+GrMldJ9R0BwUcS6G1xXtY1rDaihJtNTBETdDBJaAkh8hGhqQCH7s6YB0
	tFcDW/P4aBjmQ6sQnmuWmvu+3kpvCZtt1W8F7c1sfRRo8cumiNUEJxWWvUWMt2wNi8Ask8
	DFOS+l52XWT5AOjw7COTdCQRmgpJV0o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315468;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u56kU65NdCHiYegRSOw5kHXRrJdKNRGx+HB56p2MoEM=;
	b=W/imUFHlH+e4RBFsF2pDXOIMFciuYHtCAibGY2upuW+rQlngot6TeK5i3IQ7jmUQis2+gk
	3YyFbxpDCdXcg8Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 0A06F1339F;
	Tue, 10 Nov 2026 12:57:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id RbAzNssU82qoRQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:57:48 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id A6FC2224EB; Tue, 10 Nov 2026 13:57:47 +0100 (CET)
Date: Tue, 10 Nov 2026 13:57:47 +0100
From: Jan Kara <jack@suse.cz>
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Jann Horn <jannh@google.com>, 
	Chris Mason <mason@kernel.org>, Josef Bacik <josef@toxicpanda.com>, 
	Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-nvme@lists.infradead.org, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Jan Kara <jack@suse.cz>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, 
	driver-core@lists.linux.dev, linux-mm@kvack.org, bpf@vger.kernel.org, 
	linux-security-module@vger.kernel.org, selinux@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-nfs@vger.kernel.org, netdev@vger.kernel.org, fuse-devel@lists.linux.dev, 
	linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, ocfs2-devel@lists.linux.dev, 
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, linux-usb@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, linux-erofs@lists.ozlabs.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH RFC 11/41] failfs: use fc_init_pseudo()
Message-ID: <inlny744cisamb7juafdkmq2lxdgbzcx7npwt7uekflfzqufjh@wkhlpwlorxew>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-11-4c998976c6c7@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.01
X-Stat-Signature: inxw7z1epoaaifhaysbo51qkodyd8c9p
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8E5E018000B
X-HE-Tag: 1794315470-356478
X-HE-Meta: U2FsdGVkX18FBOGkMYQbtWu9ilEwvC1grEjDtXYTiBZ9Oi15A5+Ojq7LMync2OabdczEPKZdCib1a94hfUsg5IAHdhLzvRRJv0G6WtejEtPbBA/S5jyUSj9AzjEff/UYMi41KeGRbtOt8WupgF3TNzMLtczxXMLq0/f+pJJYZspUv6Z3XYmvW9rjZhJ7PeEK2JfV7WwQxDRWGikqq2m24yCxORlboxEZNp3EI6QZR3GMe6c1nLvb4J/nwEwyqtPacF6reZhWkwz4h2ktNyb+L7BKKQN84e22123MDDQOKIgxfOluK4iac2oXndnVOzE3xu/ULVBYj1b9RakTLAgfFwceLgTjjPlqbiHoEQWxGmgMXnG1UVblIaNKSAo9VZUp5LaJg0BcvuIKd+7V48tvyiH9ufsDFIVMJBnE5Eu+hqmI6rdjpfZjuCzT5qKsAOHJzQnMYMapPXfjiyLHk3jiFbBx7Iidw++c9SnQYp47TXm1nTxDNtrg/UDrFyLHKjTxeAlVPnDRqC8cevNsyvcJ7TmGf/mdWQ9Ay7VS1dpMeilKahSPNLs1jqGd66abRaghsM7l0s//1QA3Hu9tVSRdgo5mQFgn4zjnmeEeN+TEGfSWaTY5qaas9OiP4x+tHcLUMDVe0iiV5hcaBnqO+9XjyyWsLN2AfsHNKEtAEUTINcSJWW3lpOlfX20MTEoMrGUSHgeYbrt+gdmh/M5Mv/Ns6Ys3MUxztOQlRugS0UfoNF+jwEnS9hHE3IXpKbzUmpekSeBuECJwB06UtpJybHMN0dUk8257U/5a3PK25dsyhwUscgLiMiPcFU12qqbrjYB8iDwej+an6TjPAKrVC7V6Xsch6VBlWqJ/OyXZKRAslZm+2Q5OolBVRCIXZ8b2g9VGoYm5jZWmrPHSGHEvRm02J1jZML+/n7Si/20SyBaPFXqprcS5QXOAZO+p0lOBU5tEIDnV7/QiVDXWxwOlz0f
 +pHhNHvI
 0MLhzQhZB92i7Wj8Ami6f2CqzQGasPEz9TGWItHHPI+OncQogD6WBmrTdjq4qK/onHgQkUt0ySnL3ufgn622FzHT//622xkVOkxsqV3t7YC0CZhBCQQwXU355cA7yQ+vBmDG6Clr5PeRklny9qZIeUlqBr8FoxezB8mxeVquu9+y4p0pv6yBaM9zlmcctRgDcj1LwIDZyWVWrP8sI9XwfkkZxnQ3+8AmwDCrZVBJheF9lZ2SUpNURwsslIHKE/z4lu1JG1DFekOzONAaBkpjdYiB5SkQKFhBtA9q2sRxd5LjqHM/jGlVORBQyKno47CvT2T3Kxim7taAwxeaI0mzdLukM3cRRXeygmDVW+qHde24NGh/bjSMjPPmiZXwjD0hqEPXmwKb5bfgZ70gUgoIhvoAMUq6rtsJTSMDp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:27, Christian Brauner wrote:
> Initialize failfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/failfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/failfs.c b/fs/failfs.c
> index 437cdc981c2d..f03334f361c0 100644
> --- a/fs/failfs.c
> +++ b/fs/failfs.c
> @@ -3,6 +3,7 @@
>  #include <linux/fs.h>
>  #include <linux/fs/super_types.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/fs_struct.h>
>  #include <linux/magic.h>
>  #include <linux/mount.h>
> @@ -132,7 +133,7 @@ static int failfs_init_fs_context(struct fs_context *fc)
>  	fc->ops		= &failfs_context_ops;
>  	fc->global	= true;
>  	fc->sb_flags	|= SB_NOUSER;
> -	fc->s_iflags	|= SB_I_NOEXEC | SB_I_NODEV;
> +	fc_init_pseudo(fc);
>  	return 0;
>  }
>  
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

