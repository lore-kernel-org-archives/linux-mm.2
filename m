Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 539E160A383E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:58:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xph88wH+;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3cVo9nCM;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=xph88wH+;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3cVo9nCM
Received: by kanga.kvack.org (Postfix)
	id 5E2866B05CF; Tue, 10 Nov 2026 07:58:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B9CC6B05D1; Tue, 10 Nov 2026 07:58:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CF7B6B05D2; Tue, 10 Nov 2026 07:58:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1EC336B05CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:58:02 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A873E1206F0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:58:01 +0000 (UTC)
X-FDA: 85419211962.13.24D57E2
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9CE0BA0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:57:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xph88wH+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3cVo9nCM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xph88wH+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3cVo9nCM;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7u2HJ+t6im2/188SWjC78CxpZGXhauj6sAa+Bj5Q2xU=;
	b=q3L3WuR6cXJZnovdF4JxDLVgf0IPDwi697MvDalDjwAWuCB+jcxZ+YzHFhNz6Ei+TGQMmE
	dk97z4C9DnrmmKF2GDaVAtkrxgiCDCd0CsI9ufx+lGWzytMxamZ0DH8Rc/eSxIEI2Dobkm
	/6UBWYHNjHjgYKkXxiHk/F6xGUyZW1A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315479;
	b=e7+GRTITQdvquy7IRE77duquTLO0PmzPL3QncbwFSD76BtzfNITn1a8dr/B5jNgpzyzNfT
	rZWFf+tSZanUtCrhl37H02tqRA+hdqKRz05EOCgI6TzoMwzxbpeerBkjkXE5PRomQwYpyk
	rohqzFE09U94zf1TbmCA5OpJuWqOvfs=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xph88wH+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3cVo9nCM;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xph88wH+;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=3cVo9nCM;
	spf=pass (imf25.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9B25E1F387;
	Tue, 10 Nov 2026 12:57:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7u2HJ+t6im2/188SWjC78CxpZGXhauj6sAa+Bj5Q2xU=;
	b=xph88wH+Cy4MXPY3pDS5PKcSUzHmc+SEQP8d3AyFmCy2YYggWiv8xaF2611c3F4yHIaS3n
	dOTrXXIx6QtAs+h+dq6T4SaRrTqgpHek+kx6gSsXXKEhEsdSk6oTrIEhb22EzUz/Ph4jEi
	GJqUWg2KgmeP3xzrUh4+nn9lwCWSLr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7u2HJ+t6im2/188SWjC78CxpZGXhauj6sAa+Bj5Q2xU=;
	b=3cVo9nCMZ1HraZx1ANnHnRX3eVA0FntbrI5ij7LYl/xiVKi3TDwJJMtHtmc9R005dJKVoZ
	492ApFvso7WI9fDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315478; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7u2HJ+t6im2/188SWjC78CxpZGXhauj6sAa+Bj5Q2xU=;
	b=xph88wH+Cy4MXPY3pDS5PKcSUzHmc+SEQP8d3AyFmCy2YYggWiv8xaF2611c3F4yHIaS3n
	dOTrXXIx6QtAs+h+dq6T4SaRrTqgpHek+kx6gSsXXKEhEsdSk6oTrIEhb22EzUz/Ph4jEi
	GJqUWg2KgmeP3xzrUh4+nn9lwCWSLr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315478;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7u2HJ+t6im2/188SWjC78CxpZGXhauj6sAa+Bj5Q2xU=;
	b=3cVo9nCMZ1HraZx1ANnHnRX3eVA0FntbrI5ij7LYl/xiVKi3TDwJJMtHtmc9R005dJKVoZ
	492ApFvso7WI9fDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6FF141339F;
	Tue, 10 Nov 2026 12:57:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id FK6SEtYU82qxRQAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:57:58 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 15B65224ED; Tue, 10 Nov 2026 13:57:58 +0100 (CET)
Date: Tue, 10 Nov 2026 13:57:58 +0100
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
Subject: Re: [PATCH RFC 10/41] nullfs: use fc_init_pseudo()
Message-ID: <josp5gwkmm4f6pk572b564xfjk77wz7jk24pajp5pr3qfdtljh@ihi2c3w4mpp4>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-10-4c998976c6c7@kernel.org>
X-Spam-Level: 
X-Spam-Score: -16.80
X-Rspamd-Server: rspam06
X-Stat-Signature: zas45miyo7arjecdxkkhq1ehoup11i67
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 9CE0BA0003
X-Rspam-User: 
X-HE-Tag: 1794315479-48765
X-HE-Meta: U2FsdGVkX19si3wMIYN+r3wAnlPxxE9jDoLya93MnuIqmfRryHfjd21T+lNkkWEfs6CRxNwgQgEMAxIeg2kvAXR7Fi3EF+XERgUl5ro/aO06jHIlDnP8CNtwlDWFAeUFBwek1N99+aKRntQIuM6CPgpEP5BvWTNGiVgUUuD3huf3R81078a4NCDmoBcpWG8LPinjbgf6SBpogZbOQbL24T6Gq29hxU4v9CoXhTu+eGKxTmflQ+9kIV4wl0N+ANp+kZjCb16eStyARtBWztxvErksjgOebrXMpaNlxJWEkUW2WlcfOZPeDHA+DFZ91bdhpsNva74gmYO5mDSqau1SdNi7LMqmTNV6OBmbLDTkrZNaGWnDl34q3yjRayLZQ4DOjOR1D0LiQciy+sZyyNQp24jr10TvWr5awu6gjyxr8Vqv+p4FS4n5two3O2I5fwPpdKV0LH5vKuxnpTk4LxwDQqxwvJrwwQ6HNpX5W2a165xQUQLYl3iDOJqLfI4KKZ44H4QexE+ID9DtF7blYltzi+lyg3biCYyTP0f3lgz4I1ZG4nP2mOnut5jWqX8RtkyDOiOCNmedvirn2iJRbZxunrDGzlthR5YnHsXRhoRva8ABuxwJLx2+RkKgo00ZkL4r7UOw9eK7JdxZeMGMzQq1iY8+O8MqXfY15co02f7f8OUuwUfNCxRqgyb48HHbsP4mXth+yglzLC/AI60XwJUsBJe47G2tuJQMtsYCCIX5dHJEERx58JRSB5sz/mRhF/jptlfPplJkta3qos8QZHpGj3Vq165NMOhi3SMwfqdziMdC3npNvjKV09vCt7LtbMmZsbCtGxZ5/YF6Jtpl1lE+DalPGMgtmyqSVyPNtUVEGfhaUkcrz75P3j05o2H/NljLLtKLgymeVIkc6a60M62Pbr/IGUNnD6qnogbt68p/+M8MClKk8IZRJIcdYHVkuTs6sbfTMlWnYTrpnpRhJBV
 OEWuJAMz
 /kN2dan39FdzEJGmIqxsMiTSyTu2gzS9/diErswPxUnmmhvHpq46El9gvQroYXAYyMqPWv/K1Pd0NjyANJnVpZgeK12hbLwLvK+GJKY395OWXrWQ7dp4Ite9wZxyjf2llYnQnSdU7kWqKxOIiMSOqpEFaCe/TAtK1ZP4q8D/DkCbXadiMrXcv81fDFWvFLWNYUMEsmSQfkcqarOuQ7qQSCsGy5up6j/KTZ/a0pjVYup66Wp2+KrS9cFWAjlNbUSXx0MeFl2ltxUOUfGIYe9wqaDBQ9S/7NuO0BuSP1kGOWRhBY1b/2NvQmk8NStXqsTncV5+WZG/9GdDyHciWQ8CHNEP/vL3BRrb/odnxldu1VZN5CcwOVTdTtV0QRhgXTZWNz3FoutD9DBU3UYUv0Hh2g0GVtBpZwl+auvYT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:26, Christian Brauner wrote:
> Initialize nullfs as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/nullfs.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/nullfs.c b/fs/nullfs.c
> index 319c2f5c5a67..2fe24cb97160 100644
> --- a/fs/nullfs.c
> +++ b/fs/nullfs.c
> @@ -2,6 +2,7 @@
>  /* Copyright (c) 2026 Christian Brauner <brauner@kernel.org> */
>  #include <linux/fs/super_types.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/magic.h>
>  #include <linux/splice.h>
>  #include <linux/uio.h>
> @@ -174,7 +175,7 @@ static int nullfs_init_fs_context(struct fs_context *fc)
>  {
>  	fc->ops		= &nullfs_fs_context_ops;
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

