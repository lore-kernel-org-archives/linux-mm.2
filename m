Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDACFCD8CBD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 08:46:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E05E6B008C; Tue,  9 Jun 2026 04:46:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4693F6B0092; Tue,  9 Jun 2026 04:46:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37FA26B0093; Tue,  9 Jun 2026 04:46:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2752B6B008C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 04:46:54 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E1B991A0422
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:46:53 +0000 (UTC)
X-FDA: 84859743906.14.A9DE422
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf14.hostedemail.com (Postfix) with ESMTP id AEA0B100002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 08:46:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Vx/BEscr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=spO2gcbj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Vx/BEscr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=spO2gcbj;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780994811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GSQxH6p+aBDmmgKYN3VNQI6BF8H04zVBQYzVTpTNZQo=;
	b=oDT+8XmD4tN98K8tVVwx0gGVgh47nges9vqvkPDRJXjWy4F/z52m4LMljN/TN7/voWOyqk
	DMOMvC1TE1v5o5aiRROoijxac1xKmuXJZ3z0dONNMwtChTzJN1zK/rEsa5fDYtB7zrScBN
	bKc9Rn/6ywfpRqJ2hWYAPPGiW/W6cGM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Vx/BEscr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=spO2gcbj;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b="Vx/BEscr";
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=spO2gcbj;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780994811;
	b=cBn/QDcXqpkMBB9r04DplqCgSH+Dz7g0ey3f6Iqq7k0/1nzUGnkSM9MDamYQDkP/UUBecv
	5nyBjo7D/JHg/jyIVsJv3XYjy9P+w0POzCI6rN4m3mVgdf3QY2f4vNcG4CqHVU6eYgDe5i
	81hHNt7SGw1BGZHj7yWPRzdQiRLoYWg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 4801C6A8A5;
	Tue,  9 Jun 2026 08:46:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780994810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GSQxH6p+aBDmmgKYN3VNQI6BF8H04zVBQYzVTpTNZQo=;
	b=Vx/BEscri+0r67xy3avOveRmQ30LzU24dPEtk4qjekhhW9jO6kGIOJyQmLwDG7x25ePCR2
	Xlaz8xVatdyRqM5Tfoywojl7q8hfbYvbK/V4xCBXi2oum35WHUs+sUA73IFM2FQGMlMDS9
	CBNOerN+mnmdoXzGGnP0+SurjemtxMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780994810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GSQxH6p+aBDmmgKYN3VNQI6BF8H04zVBQYzVTpTNZQo=;
	b=spO2gcbj47UyJGxrqj93wVAFhcKrlTrh9cZYY+iwZ3P7HvrM5hIZjhXqrvAaHZxWZhA2vd
	J365xzS9oAiV3PAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1780994810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GSQxH6p+aBDmmgKYN3VNQI6BF8H04zVBQYzVTpTNZQo=;
	b=Vx/BEscri+0r67xy3avOveRmQ30LzU24dPEtk4qjekhhW9jO6kGIOJyQmLwDG7x25ePCR2
	Xlaz8xVatdyRqM5Tfoywojl7q8hfbYvbK/V4xCBXi2oum35WHUs+sUA73IFM2FQGMlMDS9
	CBNOerN+mnmdoXzGGnP0+SurjemtxMQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1780994810;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GSQxH6p+aBDmmgKYN3VNQI6BF8H04zVBQYzVTpTNZQo=;
	b=spO2gcbj47UyJGxrqj93wVAFhcKrlTrh9cZYY+iwZ3P7HvrM5hIZjhXqrvAaHZxWZhA2vd
	J365xzS9oAiV3PAA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 373B9779A7;
	Tue,  9 Jun 2026 08:46:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aXV3DfrSJ2oadgAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 09 Jun 2026 08:46:50 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id E0D69A0A90; Tue, 09 Jun 2026 10:46:49 +0200 (CEST)
Date: Tue, 9 Jun 2026 10:46:49 +0200
From: Jan Kara <jack@suse.cz>
To: John Hubbard <jhubbard@nvidia.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>, 
	Kees Cook <kees@kernel.org>, Cong Wang <xiyou.wangcong@gmail.com>, 
	Chia-Lin Kao <acelan.kao@canonical.com>, Benjamin LaHaise <bcrl@kvack.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
	Paolo Bonzini <pbonzini@redhat.com>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org, 
	linux-aio@kvack.org, linux-mm@kvack.org, kvm@vger.kernel.org, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 2/2] libfs: drop redundant SB_I_NOEXEC/SB_I_NODEV in
 init_pseudo() callers
Message-ID: <md6vxgeg4h2cs2p7jfgjy6ybgiysbl7fprulimdcxhhiwsv3le@5zgf6mbprh4w>
References: <20260604025315.245910-1-jhubbard@nvidia.com>
 <20260604025315.245910-3-jhubbard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260604025315.245910-3-jhubbard@nvidia.com>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: AEA0B100002
X-Rspam-User: 
X-Stat-Signature: msgw1i3ctg9maw4hp9eoe95sdgk5c9bf
X-Rspamd-Server: rspam09
X-HE-Tag: 1780994811-126388
X-HE-Meta: U2FsdGVkX18hj10hEJ4awsUYkEKUceQUc8mxyZpjILjO08rda5oCW8+eE2AWdMV9KqUHS+i4YBFkbbreY3fj4yvMbqilkvwhBbKirHdQsfvz8gnEpgCpEaJNZMrrToETYrxekAVXU13wof4Fd2t562Tbm9ZmaIR7zAKukA+TnOhiITxMbvd81QAKPAqWUhLuSj6JlGT7Vgm1v5Gm/zS3rHO+9P/H9c9Txg3q8dn+b+vc35EdZndj8MsX1y5F0OfPeHyOHrQxmKB+s1H+ombAbEMS5besI0zkiksXSWzNfMoIfyljgKKugmz1wzlYf9ViAbASN6swvk9tc0RLbICVkyNPjLtBg26dVRvCXMiT9MZPeKq5owYVZf9EfrTwgTrP+zpW6m2BGxp5c4xkloq3xuSUXP+O6yKUTJRZek+FovyWc/r9ZFsmx7zHWkdUhQYNBj/nv3Lz1CkkFhsEE1V8zMeyStYe4MyrpO5CE6mnrTHB4SNbWMcpp5P5lR9sYQfYv0fHO000ZWgHNj4+vb+/81kaAZj7haVROC4+bVVkToNnlzJGE4oh653ysXFIj437GDfBRFEZ3ixwSrCMF+y0xdyLlfi8x8HknTgrh7Xl2b9fyBorLNHj7zlpd9V9Liqwk3yOStbEVmhHbBZsvQSwcwiF/16CuTfU48nVhe76K3wya/zHaOoBGH8Fi//7CEb5DP0S4zzrvMN3Xmu625pA7OsN54whT5rTA+AbOnYVDvZ/6W5GqsxDEiLCHsIU+mRrPs3sMKkt7EeoyohkKiLkgX1afTFJoY1TlJqV1H7M9be4PwsHQORwjq0ILWU8eNrou5N6nTmgbLdYSa7uQcfxP6XdGuXmSKxy73r+ym9X3XXX+/oPclHhfmOyjXCsBYViUjbllQ8Zbmp14FUdVZpEX6cD4kAMJoJFh3KgrbNiMu5NqhFHJWVIMPidQ6Qc1QGYEy4Zmq8Q8zMeQvr/yh7
 jpczpLGR
 shYidbMgjsBOTTLyOwK3GrJ4J99pcPEzA1uW+sLonPxylzSpExIuSq1tAkBFgZjM3YO/1flVtcs2xagIDYjxGGmEliVCgfV/Vq2IYyha4MNRD2S91wz+4AAmcgNkMPwWWCST8vUxxxxz+aO7Dp05qdj3vzKthfpI26NiBv7VLZf9/Ubeod4ds636cgMWqiUVpLXIQIxo4a2WvpEwq8PvzSDzsRsaNIvU0l1tzjvpkWMpRWThF5K67fUyQPplFNiBhBH7hF9EHvtaIUr9F5doOLU4hDuDJAAMzb7pMou8kOt42UAB4ZbMf46/zbvWM+BIrC9UCR8WRUKnqF2T+vv7mkVDiZe/Uv6862Cw01xC9sEbAN5nYJ87L/XTOkJw6N2YUJ/D2Yumeg4Xl+dYn40oj9wBF8rz67zOQK8bxzYjru9t+h7iuh1LQnK+Q+a9hOmcduGTgyQnf1pVq4Nqc9nBneGYlhCnOf9Nc+3RkBofP6Z6rHAU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed 03-06-26 19:53:15, John Hubbard wrote:
> init_pseudo() now sets SB_I_NOEXEC and SB_I_NODEV by default, so the
> per-caller assignments are redundant. Drop them.
> 
> Signed-off-by: John Hubbard <jhubbard@nvidia.com>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/aio.c               | 1 -
>  fs/anon_inodes.c       | 2 --
>  fs/nsfs.c              | 1 -
>  fs/pidfs.c             | 2 --
>  mm/secretmem.c         | 2 --
>  virt/kvm/guest_memfd.c | 2 --
>  6 files changed, 10 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index 722476560848..f57fa21a2503 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -318,7 +318,6 @@ static int aio_init_fs_context(struct fs_context *fc)
>  	pfc = init_pseudo(fc, AIO_RING_MAGIC);
>  	if (!pfc)
>  		return -ENOMEM;
> -	fc->s_iflags |= SB_I_NOEXEC;
>  	pfc->ops = &aio_super_operations;
>  	return 0;
>  }
> diff --git a/fs/anon_inodes.c b/fs/anon_inodes.c
> index b8381c7fb636..a7b9b948e33d 100644
> --- a/fs/anon_inodes.c
> +++ b/fs/anon_inodes.c
> @@ -86,8 +86,6 @@ static int anon_inodefs_init_fs_context(struct fs_context *fc)
>  	struct pseudo_fs_context *ctx = init_pseudo(fc, ANON_INODE_FS_MAGIC);
>  	if (!ctx)
>  		return -ENOMEM;
> -	fc->s_iflags |= SB_I_NOEXEC;
> -	fc->s_iflags |= SB_I_NODEV;
>  	ctx->dops = &anon_inodefs_dentry_operations;
>  	return 0;
>  }
> diff --git a/fs/nsfs.c b/fs/nsfs.c
> index 160018c4fb36..c3b6ae76594a 100644
> --- a/fs/nsfs.c
> +++ b/fs/nsfs.c
> @@ -664,7 +664,6 @@ static int nsfs_init_fs_context(struct fs_context *fc)
>  	struct pseudo_fs_context *ctx = init_pseudo(fc, NSFS_MAGIC);
>  	if (!ctx)
>  		return -ENOMEM;
> -	fc->s_iflags |= SB_I_NOEXEC | SB_I_NODEV;
>  	ctx->s_d_flags |= DCACHE_DONTCACHE;
>  	ctx->ops = &nsfs_ops;
>  	ctx->eops = &nsfs_export_operations;
> diff --git a/fs/pidfs.c b/fs/pidfs.c
> index 1cce4f34a051..c363416766f1 100644
> --- a/fs/pidfs.c
> +++ b/fs/pidfs.c
> @@ -1115,8 +1115,6 @@ static int pidfs_init_fs_context(struct fs_context *fc)
>  	if (!ctx)
>  		return -ENOMEM;
>  
> -	fc->s_iflags |= SB_I_NOEXEC;
> -	fc->s_iflags |= SB_I_NODEV;
>  	ctx->s_d_flags |= DCACHE_DONTCACHE;
>  	ctx->ops = &pidfs_sops;
>  	ctx->eops = &pidfs_export_operations;
> diff --git a/mm/secretmem.c b/mm/secretmem.c
> index 5f57ac4720d3..4877c262cb1f 100644
> --- a/mm/secretmem.c
> +++ b/mm/secretmem.c
> @@ -245,8 +245,6 @@ static int secretmem_init_fs_context(struct fs_context *fc)
>  	if (!ctx)
>  		return -ENOMEM;
>  
> -	fc->s_iflags |= SB_I_NOEXEC;
> -	fc->s_iflags |= SB_I_NODEV;
>  	return 0;
>  }
>  
> diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
> index 69c9d6d546b2..80f201035d77 100644
> --- a/virt/kvm/guest_memfd.c
> +++ b/virt/kvm/guest_memfd.c
> @@ -973,8 +973,6 @@ static int kvm_gmem_init_fs_context(struct fs_context *fc)
>  	if (!init_pseudo(fc, GUEST_MEMFD_MAGIC))
>  		return -ENOMEM;
>  
> -	fc->s_iflags |= SB_I_NOEXEC;
> -	fc->s_iflags |= SB_I_NODEV;
>  	ctx = fc->fs_private;
>  	ctx->ops = &kvm_gmem_super_operations;
>  
> -- 
> 2.54.0
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

