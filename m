Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 316B5606A321
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:55:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=u1B+HDke;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s5Vry7Gw;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=u1B+HDke;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=s5Vry7Gw
Received: by kanga.kvack.org (Postfix)
	id 47DC06B05C3; Tue, 10 Nov 2026 07:55:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 455506B05C4; Tue, 10 Nov 2026 07:55:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36B186B05C5; Tue, 10 Nov 2026 07:55:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DAD46B05C3
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:55:30 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A91E407A7
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:55:29 +0000 (UTC)
X-FDA: 85419205578.21.DDE9F22
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 710F840006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:55:27 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u1B+HDke;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5Vry7Gw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u1B+HDke;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5Vry7Gw;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315327;
	b=sAzxXmyzOdEhhGPz7nrAna5p158d3Vx73T9t3AX1HpsVem67iZrSxlIEmBw47mG4ViZvyv
	QxwxJnfUocFUPkQx91hyE/MJkm4MVp04ClO3n3H/+MzD8lbGvD0bc5e5NQK5Y49uFgsb36
	LZswSygp0SjvEvvyF7yQpEoz8PLMzKE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315327;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=8RnLSCZ18gfm/3aICbNEuSFGS6v/XNHSym4odzF3iFNHi5oc8VX0PzbUD7bNh3am7To5Ol
	vbsKGekFPX+Sb6dNJPg9VXeVkTQYGOB1IMPjilP5029JYKVc0SjuKsulq9qSI3wrrOQgHb
	w9gib86qiQKHfdfP5MzmvRUTQAHi25s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u1B+HDke;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5Vry7Gw;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=u1B+HDke;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=s5Vry7Gw;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 433A51F7E1;
	Tue, 10 Nov 2026 12:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=u1B+HDke0hpMTlvQS4vtx71OgG/jW66cq5t3mKyddBwSs3IYmIVxUedNECKYU2Wn3gjDNT
	XUqmAOVAzpAAoCLHSQwmjBDhumXbbOHNTsIcqDMxum8byZPrO4ABQMzvGZfY065Bc2x/zH
	mOiuGvCf5UFir5w37V75pl3/j+OZOdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=s5Vry7GwYW6iUbLBXO4qDI4lvuxved+sj/wAa+gp1aCB2Ie0NTZRQTOaGDvuboGj3hVbu8
	2o09Y6CHNOgJe5BQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1794315326; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=u1B+HDke0hpMTlvQS4vtx71OgG/jW66cq5t3mKyddBwSs3IYmIVxUedNECKYU2Wn3gjDNT
	XUqmAOVAzpAAoCLHSQwmjBDhumXbbOHNTsIcqDMxum8byZPrO4ABQMzvGZfY065Bc2x/zH
	mOiuGvCf5UFir5w37V75pl3/j+OZOdo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1794315326;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tdoiUJdd+iiYf5DPNh/N+wqKlHvGCKXVkvS18tLeyxA=;
	b=s5Vry7GwYW6iUbLBXO4qDI4lvuxved+sj/wAa+gp1aCB2Ie0NTZRQTOaGDvuboGj3hVbu8
	2o09Y6CHNOgJe5BQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 188A2134F4;
	Tue, 10 Nov 2026 12:55:26 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id bVLYOj0U82rFQgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 10 Nov 2026 12:55:26 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id B1F3D224DE; Tue, 10 Nov 2026 13:55:21 +0100 (CET)
Date: Tue, 10 Nov 2026 13:55:21 +0100
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
Subject: Re: [PATCH RFC 04/41] fs: add SB_I_PSEUDO
Message-ID: <mdy4v37mrp7rfwt3bwiiu63ztgdlcqtahyiqj6vw66zo2dl3cz@rd3m2b6sf77x>
References: <20261110-work-loop-pseudo-v1-0-4c998976c6c7@kernel.org>
 <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261110-work-loop-pseudo-v1-4-4c998976c6c7@kernel.org>
X-Spam-Score: -12.80
X-Spam-Level: 
X-Rspamd-Queue-Id: 710F840006
X-Rspamd-Server: rspam12
X-Stat-Signature: 47ntcim6fuaidesnajh71gf6s553cyir
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794315327-528159
X-HE-Meta: U2FsdGVkX18MDrEAxCYE5guqjveuwEm9+Us/j9OW/IkVmqisJT57n0KO35skeeALyBlNVqQTWKqjFa/+jW/pLFuEJByRnmyK89+QxRkzvcajDU+gLfxj0yG3cQ0mwFSdrZ4UEgtxxpL0dPPBCX8UUhwgUUODWtXkmHI7Jc20W/zfmGty16DGV4adTcvnAAtoSKSFJq6iT1j7O+653fponir4pPrdXPGJ7sWQ+/lmHkgN4fRAItZMR2emEczfWbgFpJ3vhVjyUn2W8CXFcnadftk2+3D6Tun06CD3UxLkn6ReEJI8crXthezMnnUUM/nDJmbbCvH1IWzH4Qv7AwTzyHWceOilbnyCuZCPynk5ergHimMm117hbG4ACTl0CqBHj5ScZUtp2eHTWSvM6uxhKnQboilGEoh6308e4TPdY9wx5I1OHrz6f6Be/Dd1Gtnhyvn9hmEFT9NdcB21U7Y0QjklMfTLj0lkO1pHFuyFRgVLohlVKYm4ZGZ20vLAoNBmhUJe1duZbe9F6GR2ZAo2c6hZtEK5hEpGIDcZjHCloxTsc2+bmu9LXnDrJt+bIpOEpoJrt4HhxHX+a7ioj6q8YsOSZAuLvr4DfZ8tOhlbkkAdNoRvnUziJL+4vpRtponLlkXhLzh2g5CXcdV8U91By6vwztlnzApTEwjiGQ6s4zDl00uRObeBaSxW2o4HwPdpmANNhgHbt/tXaVxNBvDhjBHha4cYc7AtjIBSqoXQ1m3Prirl+5ILUxtx9C8C7phDtzenAFwQCScUAfxvV501HPsjt9U1yTsgTyZeKkkkmyq7u6TTg4GIX4M5d+7ZpAkUS3NT2acDsNalWNJkfkR4ANB3GXPcomrN49NwHlK8kebhuPbXOPVrcxg3GtwlSWuPehAxYwq/yUoIVfoBjabxPn0Sc/qA8emEt2FTuyan1VdSTCn1+GNKwJP/73dtlG/nseudTEy3O8aNPb4ceZj
 SEcR/hY9
 +SRUTJ7gtTTVB9JX/dAAmyEFphrG+aD/PlcCbjajOy2FXMyGOA4wVCtlmmWlwTl1QpQoO6NZmqWBrwVVdVE4Tv4AvqTsZFCWUcMrfXQNg9Ue83og7tQDw4R3YavsgEErIJ17v6yz4zc9bLMymfoNgQM+5yK+DWu3WR35liqZorjmnKD8wJL/wp+OM/3+O5mHFLVvhNRjEWmYR9Ac8VrU2/MH2EF5x1Xlw3CXU3PYb7HDSFNhrirYRqFVsiwOiyzKmMzJu9d4SwHnPDmbL0caDCWjpuwmOLzRLduwg2gF0co/gcqKAzMIJFhgynu+JKHVhTGfMUU6PI+nx7QbujspCZ0XvWd466VGnNqK2v3qyqe1XwnhNKkWfxoZ6fjkp+3FJYl8lCcnBiUsQ7G92hUc3WY2b4eja9qgZbZ3ssvTkv4LgZhadUn9XAJQrLvBauUgvS9giEXxWPLPcxxh5RIIAiRbLBRJRwxUnMwpIbs375nFhPiq/yoGD2ReJof9SDtu8Hx25GoEPoxSy30M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 10-11-26 10:14:20, Christian Brauner wrote:
> Currently, there's no way to tell whether the files of a filesystem
> store data or whether they are kernel interfaces. Files on pseudo
> filesystems such as procfs or sysfs generate their contents when they're
> read and writes to them are commands to the kernel.
> 
> But a few places in the kernel take an arbitrary file and use it as
> storage: loop, zloop, the nvme target's file backend, the scsi target's
> fileio backend, fuse passthrough, the usb mass storage gadget and erofs
> file-backed mounts. At most they check the file type and whether the
> file implements ->read_iter() and ->write_iter(). That's not enough.
> kernfs provides both for every sysfs attribute for example.
> 
> Add SB_I_PSEUDO so a filesystem can state that its regular files are
> kernel interfaces and must not be used as storage.
> 
> Pseudo filesystems also never hold executables or device nodes. But
> currently each of them decides on its own whether to raise SB_I_NOEXEC
> and SB_I_NODEV. Some do, most don't. Add fc_init_pseudo() as the common
> initialization point for all pseudo filesystems that raises all three
> flags and switch init_pseudo() over to it. The following patches
> convert the mountable pseudo filesystems.
> 
> Nothing checks SB_I_PSEUDO yet so no functional changes.
> 
> Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/libfs.c                     |  2 +-
>  include/linux/fs/super_types.h |  1 +
>  include/linux/pseudo_fs.h      | 11 +++++++++++
>  3 files changed, 13 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/libfs.c b/fs/libfs.c
> index 96a6e9b1535f..8c8789489fdf 100644
> --- a/fs/libfs.c
> +++ b/fs/libfs.c
> @@ -735,7 +735,7 @@ struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
>  		fc->fs_private = ctx;
>  		fc->ops = &pseudo_fs_context_ops;
>  		fc->sb_flags |= SB_NOUSER;
> -		fc->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
> +		fc_init_pseudo(fc);
>  		fc->global = true;
>  	}
>  	return ctx;
> diff --git a/include/linux/fs/super_types.h b/include/linux/fs/super_types.h
> index 72f4288e16c5..472200bdf081 100644
> --- a/include/linux/fs/super_types.h
> +++ b/include/linux/fs/super_types.h
> @@ -359,5 +359,6 @@ struct super_block {
>  #define SB_I_NOIDMAP	0x00002000	/* No idmapped mounts on this superblock */
>  #define SB_I_ALLOW_HSM	0x00004000	/* Allow HSM events on this superblock */
>  #define SB_I_NO_DATA_INTEGRITY	0x00008000 /* fs cannot guarantee data persistence on sync */
> +#define SB_I_PSEUDO	0x00010000	/* regular files are kernel interfaces, not storage */
>  
>  #endif /* _LINUX_FS_SUPER_TYPES_H */
> diff --git a/include/linux/pseudo_fs.h b/include/linux/pseudo_fs.h
> index a651e60d9410..0ca408aa60af 100644
> --- a/include/linux/pseudo_fs.h
> +++ b/include/linux/pseudo_fs.h
> @@ -2,6 +2,7 @@
>  #define __LINUX_PSEUDO_FS__
>  
>  #include <linux/fs_context.h>
> +#include <linux/fs/super_types.h>
>  
>  struct pseudo_fs_context {
>  	const struct super_operations *ops;
> @@ -15,4 +16,14 @@ struct pseudo_fs_context {
>  struct pseudo_fs_context *init_pseudo(struct fs_context *fc,
>  				      unsigned long magic);
>  
> +/*
> + * Common initialization for all pseudo filesystems, mountable or not. Their
> + * regular files are kernel interfaces. They don't store data and pseudo
> + * filesystems never hold executables or device nodes.
> + */
> +static inline void fc_init_pseudo(struct fs_context *fc)
> +{
> +	fc->s_iflags |= SB_I_PSEUDO | SB_I_NOEXEC | SB_I_NODEV;
> +}
> +
>  #endif
> 
> -- 
> 2.53.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

