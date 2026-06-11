Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77CCACD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 03:20:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D47C96B008C; Wed, 10 Jun 2026 23:20:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1F766B0095; Wed, 10 Jun 2026 23:20:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C357D6B0096; Wed, 10 Jun 2026 23:20:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE8536B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 23:20:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5B81840468
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:20:01 +0000 (UTC)
X-FDA: 84866177802.17.DA5A49B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6BC18160002
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:19:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nicAYYUw;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781147999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HfR+7RqO5pf/6TMxfeDgb+hxnKTwl+gKyahhAXFJyao=;
	b=G5hQjCkYRtSQ6ji/PGSAkFjjhhqbpo7EUouwaIiUdgBr98+SJ/smwiPzEKHqJ6orNOjYdU
	XesxKJLhbBBWkNryMVPIyqFeNgQC8/0Q4bSSDZ3UHSCQGRsiaBNePTtUwb6x0l58jpwp6Y
	OZnebDA5tWHEjsDyWAXwlhX0k4puMG4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nicAYYUw;
	spf=pass (imf08.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781147999;
	b=x2A1ZC8c8H9FtRE3F83I8jwHrxAh8o9RpY1ENSi9hp995+8pkb++JNcuH+fBuMvU+cHZkQ
	yNe6wOn6/CvtSp7iYKNauirA6m5JMdh+EzFigucv4PYvRvO814Hp8pAz7bYRfJf0c8/GpM
	LROFsUrFx34WsU6uw/Lhslh9g3i5EOc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6C02140BB8
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:19:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509411F00899
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 03:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781147998;
	bh=HfR+7RqO5pf/6TMxfeDgb+hxnKTwl+gKyahhAXFJyao=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nicAYYUwVDdQjj4oIETPxekiJV714+jEoGXAA1shKElivHE4ps9dFlzfSBnuQ8bQX
	 jUpLZeUrVh7e4FEh0irFpjN68U3lG0GXYE7MptJTHIfwYgTPGTiAEB47jvGqNAgBTZ
	 VLsMipl4xoUuUqXQCjrd+yKN3w75lMSDP14srS6z4J/Dx3U4nnYiiTc1FlccFbR6iC
	 al29Zpnq5RHwj8kcbu2cR/gaiWNRg32DzJC5fEoBLGDdrJ4kYb47NR/nRkDpkZdwM3
	 ekDY7Nqa2DQ/lYySX31hANMXIDin5HQVwFabOLo7T+0rvpQijLEFhUGLqMHXLU+5vc
	 IisFITgBm4nYg==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6611689dc10so4980483d50.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:19:58 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ81OU2S4kITY8AfV6IxIqrm1GxrRnXZ6lZkSl3ZYfQKVM3bSlj+rSRrPzNpkQ2+14e0cPrliAT9fA==@kvack.org
X-Gm-Message-State: AOJu0YyDg2C6nh6B6u2k03fdxFhTBtB/5k0PsJIzyxleM84W5GQQ+Bin
	EXN1p2gruDsPcCGa1uDfUaYfRCPXvqmrmSwEpNyCwdmIYDr/1ShYH2oUGLMh0elKXT8Hb7hS5iq
	Pl/93eaAHYzcNTF68ESyTr3nvhpjIdNKdLbd7Kkg9kg==
X-Received: by 2002:a05:690e:134a:b0:65d:7db3:5587 with SMTP id
 956f58d0204a3-662695f4460mr788219d50.4.1781147997590; Wed, 10 Jun 2026
 20:19:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260601113449.3464734-1-hch@lst.de> <20260601113449.3464734-2-hch@lst.de>
In-Reply-To: <20260601113449.3464734-2-hch@lst.de>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 10 Jun 2026 20:19:45 -0700
X-Gmail-Original-Message-ID: <CACePvbV3ZSpfKAiP+oafcreEB3avCRp8i6oCkSVzcW4rWWXeMg@mail.gmail.com>
X-Gm-Features: AVVi8CdSWr0z4Is3M0zrGqPxIr8w7xpJzyaA5pQ60hGYDIjh20VpXKEEFdQSS3Y
Message-ID: <CACePvbV3ZSpfKAiP+oafcreEB3avCRp8i6oCkSVzcW4rWWXeMg@mail.gmail.com>
Subject: Re: [PATCH 1/8] shmem: provide a shmem_write_folio wrapper
To: Christoph Hellwig <hch@lst.de>
Cc: baoquan.he@linux.dev, akpm@linux-foundation.org, usama.arif@linux.dev, 
	kasong@tencent.com, nphamcs@gmail.com, shikemeng@huaweicloud.com, 
	youngjun.park@lge.com, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6BC18160002
X-Stat-Signature: uqzncutwsutjk3heet1zozzdqmcgti5f
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1781147999-945608
X-HE-Meta: U2FsdGVkX1/QKaZDBSNXCFQZ4+lKJ+3ysD7R8Oq3OPPg0soKuHX/5vUlKokMLcmyIqxyhvhdW7tpGMx8ViOEDOZ3uGZbn+dFn1ZdKFOI/OMGuvrEN9B9VUtSuxiDeYumNhUyO6DWgv4VndfMnwdfBnM5SA+9oDn0YhbYsLRq33WmuEevquSnk0sAb+fQGCT9PAIvOCHeia6OzEGH/4qboNX1LI7q49IPuBKTbHQjilIBWHUc0kVsub8rlsyurPzmaEKE/mUy7XeYnZFfFDrrWHVox2cLFVEaXkcIgdnT6/fi/MtUN/MDpGHsH2NZupREqqfBZl+t0yF0n4RZZ9XKryS2hj9sFWZwjf8e5mHpUvcWucQp/GVK6mw6h5KPQlKSdf0JXDklJaTZ+fXS6ux5ICYtZ5P+H6vNGfSwL12DSHW8+JDxTrX3NeTIkx7Bt0v57OHNDSojqRA+xegfEkZVjXuXgvAIBpW9RCij/LsE3a1wC8wg0jpA0wKpskqedKq0bRFIf+5Z7J29Ae70ujdRhxV1kzgeAAn/ucbiHV1WRQgPRaN1/0ClC7gQhH+CfZgY/kYd5NBIojmJgyi0Ucx9IPspd1KkPsTUXDcjKqNk9gedvK8az+M1dDm8s9VoHuUTmul5haVvR99RdKmk0shPUqSF7UlE50QEaaQ8WLS0GEggLq9674X7aYFKCGhNJE7zfMZ3J2bwRaABi20SOQGgaA4P6Dohdysagvk6sVADKwzvhUfT6ZHg5WJ78X5aJkoUZELU9Pm71PnapXHerMI5xUBFsSd24JR1rGfnQUKlXMQYWRQwSlodxg+MIEDNIFk1QkX4GTnd3qslo99W6nvmwx7opNg2i3iZZMbbYPuYHqe3SNllpCONSXwBy6y/svJV749LgRjwP3t/G8JWm9k9OBIqYEthcRtejleXmArtg3heb6tXcTezbzF6oa+MgUc9VyaZ7MLCBJ44YhChf4A
 Yfxn9+Qp
 CFzcxGmWVl1bK1VPI0Tc4dMAFqEFOG1Zp/LYP1zQW0DGz0Ax46So19wxmTBAVFgorda8xsKoq7froLKWNNLyOy/L78f4Gc3L4nuyhTAeQmjw7u9nW6grFWKqBXz7hsFoW/GpwQpvLaAXzEp2MLvQ+hBWy6IJ/hjdxVCvu5hwsQ38DFvqtGIAMnon2D+sZ2Ysht0waA83scqOTU2R/88E5QJ+yUorlD2AmWeLP/A/irPR5+mynK6qRjYboOIIbOige2DySDKQjJjBzYIIiUhnsmw/VTBwrVbLZqyT6UJQY+vZL6jZ96ED0swpDae4TTVt7tQBJW1p7YkOwpCv6qOTfiRlm84wAs1pnd76tv0TiI/sB/pJLg6EIpUgMmcssFuK2B2fe
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 1, 2026 at 4:35=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrote=
:
>
> Provide a wrapper for the shmem abuses in drm to preparare for swap I/O
> refactoring by keepin swap_iocb handling entirely contained in mm/.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Chris Li <chrisl@kernel.org>

Chris

> ---
>  drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
>  drivers/gpu/drm/ttm/ttm_backup.c          | 2 +-
>  include/linux/shmem_fs.h                  | 5 +----
>  mm/shmem.c                                | 7 ++++++-
>  mm/swap.h                                 | 4 ++++
>  5 files changed, 13 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/=
i915/gem/i915_gem_shmem.c
> index 06543ae60706..ef9440166295 100644
> --- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> +++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
> @@ -325,7 +325,7 @@ void __shmem_writeback(size_t size, struct address_sp=
ace *mapping)
>                 if (folio_mapped(folio))
>                         folio_redirty_for_writepage(&wbc, folio);
>                 else
> -                       error =3D shmem_writeout(folio, NULL, NULL);
> +                       error =3D shmem_write_folio(folio);
>         }
>  }
>
> diff --git a/drivers/gpu/drm/ttm/ttm_backup.c b/drivers/gpu/drm/ttm/ttm_b=
ackup.c
> index 81df4cb5606b..c5b813a563e7 100644
> --- a/drivers/gpu/drm/ttm/ttm_backup.c
> +++ b/drivers/gpu/drm/ttm/ttm_backup.c
> @@ -117,7 +117,7 @@ ttm_backup_backup_page(struct file *backup, struct pa=
ge *page,
>         if (writeback && !folio_mapped(to_folio) &&
>             folio_clear_dirty_for_io(to_folio)) {
>                 folio_set_reclaim(to_folio);
> -               ret =3D shmem_writeout(to_folio, NULL, NULL);
> +               ret =3D shmem_write_folio(to_folio);
>                 if (!folio_test_writeback(to_folio))
>                         folio_clear_reclaim(to_folio);
>                 /*
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index acb8dd961b45..f35c752f27af 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -12,8 +12,6 @@
>  #include <linux/userfaultfd_k.h>
>  #include <linux/bits.h>
>
> -struct swap_iocb;
> -
>  /* inode in-kernel data */
>
>  #ifdef CONFIG_TMPFS_QUOTA
> @@ -122,8 +120,7 @@ static inline bool shmem_mapping(const struct address=
_space *mapping)
>  void shmem_unlock_mapping(struct address_space *mapping);
>  struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
>                                         pgoff_t index, gfp_t gfp_mask);
> -int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> -               struct list_head *folio_list);
> +int shmem_write_folio(struct folio *folio);
>  void shmem_truncate_range(struct inode *inode, loff_t start, uoff_t end)=
;
>  int shmem_unuse(unsigned int type);
>
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 56c23a7b15c7..d10735e49b25 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1738,7 +1738,12 @@ int shmem_writeout(struct folio *folio, struct swa=
p_iocb **plug,
>         folio_mark_dirty(folio);
>         return AOP_WRITEPAGE_ACTIVATE;  /* Return with folio locked */
>  }
> -EXPORT_SYMBOL_GPL(shmem_writeout);
> +
> +int shmem_write_folio(struct folio *folio)
> +{
> +       return shmem_writeout(folio, NULL, NULL);
> +}
> +EXPORT_SYMBOL_GPL(shmem_write_folio);
>
>  #if defined(CONFIG_NUMA) && defined(CONFIG_TMPFS)
>  static void shmem_show_mpol(struct seq_file *seq, struct mempolicy *mpol=
)
> diff --git a/mm/swap.h b/mm/swap.h
> index 77d2d14eda42..4f86ef338a60 100644
> --- a/mm/swap.h
> +++ b/mm/swap.h
> @@ -473,4 +473,8 @@ static inline unsigned int folio_swap_flags(struct fo=
lio *folio)
>  }
>
>  #endif /* CONFIG_SWAP */
> +
> +int shmem_writeout(struct folio *folio, struct swap_iocb **plug,
> +               struct list_head *folio_list);
> +
>  #endif /* _MM_SWAP_H */
> --
> 2.53.0
>

