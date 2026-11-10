Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A53D860A5BE2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tSFQYWyR;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=V1tJ5Byu;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=tSFQYWyR;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=V1tJ5Byu
Received: by kanga.kvack.org (Postfix)
	id C50776B05CC; Tue, 10 Nov 2026 07:57:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1FB96B05CD; Tue, 10 Nov 2026 07:57:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B0F4A6B05CE; Tue, 10 Nov 2026 07:57:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 888126B05CC
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:57:00 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2B399A854D
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:57:00 +0000 (UTC)
X-FDA: 85419209400.18.B7561CC
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id 24EFE100002
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:56:57 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tSFQYWyR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V1tJ5Byu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tSFQYWyR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V1tJ5Byu;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315418;
	b=DMxGxp+82/G1S3iWBRfbjL8zIY7qFhantOtToQsIaQVADL/LjIhgv+y9pNYLJ2ncc3xBC/
	d/3YVoykvkzY30w7P2fq9ZIqF7F5xhwkx+whHi7IMWYe2YgUXr49UkdlxNlSRDFGvVODuU
	FJfms443DM3QsrqGpQ4j0VIDlaYQvgc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tSFQYWyR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V1tJ5Byu;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=tSFQYWyR;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=V1tJ5Byu;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315418;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8ydl7Tmlsy6sB/5DKTtOnjnkkw2YCPYFk9bjL7BuvBI=;
	b=11fFxHy7vEerp7EqC55OFMbCdAo2QwbG6LWWboU4R8/jhl/l0nnkalN8zSPpXd2AqaxZO4
	rghkYI9b+kKjZUGtncJRTRNF9Onjh7BqS+DtiAOoQQcmcQElqEh4FlP6eRbgFKC2KCJNAu
	uqic76K4vbcxHsAudv44AIMT8Y5Mh/w=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 10FD721F68;
	Tue, 10 Nov 2026 12:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ydl7Tmlsy6sB/5DKTtOnjnkkw2YCPYFk9bjL7BuvBI=;
	b=tSFQYWyRwwv+kHYE8YhpOGU4Ki3HgKpsjkr+3bnlJF4cyRVZi+z6dmRnLVspPlNWBQ97T6
	CjWhI8INKAvD/P6E+SsUzIAB++2Mfn4yUQshTJILp/aD0y+vMUsCGK8B/SvT9SJxrm+lD6
	OfAmAtDkJMnT/TjtT42JjMJHwAmLTYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ydl7Tmlsy6sB/5DKTtOnjnkkw2YCPYFk9bjL7BuvBI=;
	b=V1tJ5Byu2B6p1tefK4YDbMgOvwybp9VjU+aSU5c9lZUhOg8WFHNH3DAT2n59zkgMTRqYSW
	vjk8sfZwK3dN1ECg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315417; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ydl7Tmlsy6sB/5DKTtOnjnkkw2YCPYFk9bjL7BuvBI=;
	b=tSFQYWyRwwv+kHYE8YhpOGU4Ki3HgKpsjkr+3bnlJF4cyRVZi+z6dmRnLVspPlNWBQ97T6
	CjWhI8INKAvD/P6E+SsUzIAB++2Mfn4yUQshTJILp/aD0y+vMUsCGK8B/SvT9SJxrm+lD6
	OfAmAtDkJMnT/TjtT42JjMJHwAmLTYA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315417;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8ydl7Tmlsy6sB/5DKTtOnjnkkw2YCPYFk9bjL7BuvBI=;
	b=V1tJ5Byu2B6p1tefK4YDbMgOvwybp9VjU+aSU5c9lZUhOg8WFHNH3DAT2n59zkgMTRqYSW
	vjk8sfZwK3dN1ECg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E25DE1339F;
	Tue, 10 Nov 2026 12:56:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 6y7vMJgU82poRAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:56:56 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 8D370224E9; Tue, 10 Nov 2026 13:56:56 +0100 (CET)
Date: Tue, 10 Nov 2026 13:56:56 +0100
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
Subject: Re: [PATCH RFC 07/41] binfmt_misc: use fc_init_pseudo()
Message-ID: <pgygyhsa4yghzrnta5qgeqehqixklm4tzdjz76ro7j6zy5r5ib@2xq25urai24i>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-7-4c998976c6c7@kernel.org>
X-Spam-Level: 
X-Spam-Score: -16.80
X-Stat-Signature: n5fe9daunbdnezr8hizfeuycr3zzm3m9
X-Rspamd-Queue-Id: 24EFE100002
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794315417-930977
X-HE-Meta: U2FsdGVkX1/pqZd4IOsf5fWHEA5HhSHGm7BJdpENn5x1/mKkIyb7LG309MY1Vdu44AG3jZCp3bNh80HmJs8pFWFb002qhll9HqJF1eJ6RZxD+YSdU50Zq5UqCxIkE7VDJkoA5wT9R5YM2eUje2YL65x3k0s9mhJPCGw0b+LmSG0ilgBeo08vZok3tOV+L216SrlVDw7TRCiN+b1q5+cBDnSQXSII2QPoRjp8ZVmp4yR3mthMc7MaCRiMi9qTpVrIcE/jEP2wfqdC7SIMdSyLzkPfxpBbZi++sZm/I8kyK0Q75MAm4ALiO6qv6TA3fGqWxRr9LBp/Inkf9miNnE5k/RR2H8+Bt2tHWDs07TQ4Byqm2ocjUym02YPMyVbnOmCUL4Vj0MttypL86xArVlIoIadxeyJ1HzRUqZyC50vSaRwUfOgCX+AVaEuE+Ooh90xiuozwBL5yrSefmH5UkWd8jH3+dXYEKRPqfjHjL7AD8b8afqx/ZflcmeKhu37RrmeakN3YoiNBvZtNyuup4M+PGDUDRcg4ovAVXLm8TrbWQ+whrNWxn2Ypkl94pzmkqQ5qbaPUrZxmRf7eA7HuqePf2haeHoVyFoKbeP/+/+Foo5LfulpK5AH0Ph04GvNcctPJAgXyC9FsWdjoeIS08dsWCKdB/xL1qLNY0kuYs5qht2DGr8KNjIu3Y5/aec6spZA/D5AbHY8i0XAfguzq3hXkbfWeX5k/9/ADKHDSdHYl22QvmIN4Rs3ZNvN3tSjkuqJWnHYpWy/xGILuLZlQssvmb7SrvjS9rU+546qqGZMwop9vQRlopm4S89Bcx4rQJ4ekIwizrJPigpwmKkYdBfZYtYSYiYbHKgE/ZWDtj+kXMoNu8KX+D86OnaVLN/nQjLHlDhrRhpcN5WbhVPWIop1rwDTMUvET+4ueQrTH+KsARJOoIM32YHJq3DZRoNo4zd1MOdIUosTRo9p/KuIfYyi
 r8S6uQEP
 1NLC/HW/eJnWUIB6b27iCLuXB2NNekiAFvJbMo+fSASc+tgpg8CtEnfthkrqXvT1TXN0o3iiPaYsL6mtar5jc5DsBQA2B3wWndTjSR4nAI5T2ezOoUw+MGS+SnRP3FlSBkVmebuuTJN2EFCO6CmwibzxKIw4uO1JR1ZAYbcYA/qtO66csEVwjFekoVyMIwfyiN0gRO8OPZNbZ2jjUH0Dv5hZmPoPKoBKdSxPMsFSWLGNo5aQUtE6QuU+aUlC0nXoCmcrtT0rVtzp1i7dOXHVCsuMuctRnzinUQWr4q+toaB06/o3acfpKTNVfgECzsNAo1Ar0PMSrKCSoNOZ6CLZytMKDgzYUk4KRlqhUA9f/NEGkDPRMFb5DIXgaDlFONUDJkM6N1x3m3kUbk2iH1quZC97ugv6650/faQaS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:23, Christian Brauner wrote:
> Initialize binfmt_misc as a pseudo filesystem instead of raising
> SB_I_NOEXEC and SB_I_NODEV by hand. This adds SB_I_PSEUDO.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

OK. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/binfmt_misc.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/binfmt_misc.c b/fs/binfmt_misc.c
> index d945b4f6e158..7dc233becd98 100644
> --- a/fs/binfmt_misc.c
> +++ b/fs/binfmt_misc.c
> @@ -22,6 +22,7 @@
>  #include <linux/file.h>
>  #include <linux/fs.h>
>  #include <linux/fs_context.h>
> +#include <linux/pseudo_fs.h>
>  #include <linux/init.h>
>  #include <linux/kstrtox.h>
>  #include <linux/limits.h>
> @@ -1575,8 +1576,7 @@ static int bm_fill_super(struct super_block *sb, struct fs_context *fc)
>  	if (user_ns != current_user_ns())
>  		return -EINVAL;
>  
> -	/* Never exec off this instance and never let anything stack on it. */
> -	sb->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
> +	/* Never let anything stack on this instance. */
>  	sb->s_stack_depth = FILESYSTEM_MAX_STACK_DEPTH;
>  
>  	/*
> @@ -1660,6 +1660,7 @@ static void bm_kill_sb(struct super_block *sb)
>  
>  static int bm_init_fs_context(struct fs_context *fc)
>  {
> +	fc_init_pseudo(fc);
>  	fc->ops = &bm_context_ops;
>  	return 0;
>  }
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

