Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D24B4E63C8E
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 12:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 01CFF6B0005; Sun, 25 Jan 2026 07:03:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F0CEC6B0088; Sun, 25 Jan 2026 07:03:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEED86B0089; Sun, 25 Jan 2026 07:03:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CF53A6B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 07:03:40 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0AE4C160572
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:03:40 +0000 (UTC)
X-FDA: 84370351800.02.B4CD2B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4E0921A0008
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 12:03:38 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X4kzUMsF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769342618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iqNzYgcK682OGBzEU/mbNTmwKAsTKy2bpCfAaVM9lTw=;
	b=Xu65suzaeF69bjQYfuQV0hrvzwJj1hi+fTluTdEuZJturAmtOCCwaHefdwCjvWdF5s4mqU
	zz5dVFOkrqA3VYPEyHFc4JczzMRDCmpw6FcZU6IT+ENaVJysrgUD8KYX/4ogKBEsNTYs2L
	/H6ntZ37x8mcKIPKllo0Mp14+YxYpt8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769342618; a=rsa-sha256;
	cv=none;
	b=2eqosY4eQJrlhaw0zTDnFNN/TZ/2mP3weELCW7IenNz0SaNVyVejvhEwEockBhhl55Yr/w
	sTca3gQa4y92FxAKorWY+s9n/Y5qUhhwdbgz/Z6QzWULg4IewT47S2JMHCYbeqDN1WQHyP
	JyX8/8YNwoTIVFnnQwlB4LKsLS4h4yE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=X4kzUMsF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 49EF242BB2;
	Sun, 25 Jan 2026 12:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4209AC4CEF1;
	Sun, 25 Jan 2026 12:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769342617;
	bh=VgoxmZlbv0mSVt43gxyu4AMX9q5s+p+eQWF9sR0Ddes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=X4kzUMsFpCh/ex88C06+BH3I+aBZEdkYLS8o7XjZ7xGsN0h4N0RX6P76iOt2kl2vI
	 d0qIEYPI+bPyahOl9Y5rMTOzV4tk4scT80WhLCzBvK0IAytDzkk3piase1AAB3Q7YY
	 NSqGHdrlU6VItCS5c+sQwlkX2UCaAm6WDS4t8do5WQHuK1VDCr+cOVwP2ZgesTR+jf
	 QXWvdXxiKx+I6tlaqA2y8o9hmK5xn4BuHND6zQC/5JDluqBaffrJ4CPDctaSYm8e9t
	 tvl8SnaPQwhURaMNc6uD1DKZ+Ww3uY8qP8mpYksXUfxX/55ZiB9d8VR6hNxIQdLdMA
	 9Jy3wZK1W56oQ==
Date: Sun, 25 Jan 2026 14:03:29 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm: memfd_luo: preserve file seals
Message-ID: <aXYGkb-QtYNaWYw4@kernel.org>
References: <20260123095854.535058-1-pratyush@kernel.org>
 <20260123095854.535058-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260123095854.535058-3-pratyush@kernel.org>
X-Rspamd-Queue-Id: 4E0921A0008
X-Stat-Signature: 78of5gimgfc6xmj7r5mxbunpqnwrsjyi
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769342618-455995
X-HE-Meta: U2FsdGVkX1+Jmn8aquvZ4njMUQIqm37FKhiAnvhPQMX+yrV3datrwGfWmHQdoAF8D2ZIHf68Dl654RFUqFaVOxP43MtY5apxOm/GyyccqPlus0qOBmbFQUJ1UroPLUejcr9Z/eyeJ+VF8zKYk+5ErZhYRTgSvVYAF+P0xnUdgbSjwY66blqqQoS5J+sfo/9t9Qg5+kFmiNUPtqcRRR+l39qPo16fLR80p0BrBaHmG4KZ4CX3wpc2w1EdYnc0DrOYlMtk8PuLMFFLpwsaOUVhgS0v0Ws8vAYCeK14Fm5Hkkkin6ZVjAfR3WMxhleK3TLG1xH+2BBRfJ0XE+a1HPXirpMCmVF2NET22m0UH4Fn9OU4PxjoVqXitNVwMvWIvQm/3yfQPDsfcWbd0CFpTdGK6EqndAN/airV8mdA06N8OvuuVGgZd0I0QMlnNh4RZ6zDWQQeVT9wQv8PvELZxAfhq9WSKDb6b/1I6B3+HU6Gje8ZF9jI6IqKKEa9xa/Vr970EyNfG2wmwVNWgHdurmby2fLZTEFVsmc73yWs4xgMud0dDXjlNtIbfDof1EWWDoSGQoG2EJj6yXs3AFBSVk4uj+LUlc4jTiBCmAFp7SEpkzPXgQZNda1X7uZYUu4TYUP7341MMluvyMVz8LSfT7U5EI37Sn18F4lwq+uxlt5FckcMm0Onpl020Fnx9PPZpFQBpHC/gT95JHPqoWIN7KuyHDvjAuBJHYXQB7YmESin023ZcREmGGbjtGamXjUkoIuUoTUr0s+hgCT5xs4sInFtUiouu/uKLrKz0mgQ0Y2t13eG7JpP+4TcxH6/j6kKhvVQJ4ncMs64f0RSWvMWww328bTD1IpiGB7IDcyCo5F/73FYEe5vPFEE2rffTSI5gzUVpWA7jd1I76CNmGQRXlHSsribdtuvKppKQBNgkONGAqrR/LVgoiXZpM8hdiZHj/nbLjIDfBrnypNH+jfeEQt
 Qc166sY7
 RB9Q8EcGVdX5O9l+ArJ/rgYVJmoIAh10XdtD5oniXIBGjV5Un63cpoIHONlMfOOzYP1bN0WIRQ2Y4TwEh60UKWaXXoqJEW5Mc0kthrPrbvDCS/Yxi92CYfuGxmBHHnMCdLnf3OacwBpgcYC6pEufFAM6p9pV1CgjiX/at91klK+lN253wFc2NC60jL/KOUcGgASq/X0NbW9lBPd6wQ54fvaxrHv5ooj9jX+uEHBU63VtkDTfSSqSkl7ZZiQfVIVE3bz+XgDgrlH3ufVKyFPRmRR6IVCAuxpg7Lqv61IH6P6Ry/MHb649JM82fXcSy1EZ1El0NMs3mdcE03g1TQjI6HweI8LdHnzls6dsV3kke2fiAcJI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 23, 2026 at 10:58:51AM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> File seals are used on memfd for making shared memory communication with
> untrusted peers safer and simpler. Seals provide a guarantee that
> certain operations won't be allowed on the file such as writes or
> truncations. Maintaining these guarantees across a live update will help
> keeping such use cases secure.
> 
> These guarantees will also be needed for IOMMUFD preservation with LUO.
> Normally when IOMMUFD maps a memfd, it pins all its pages to make sure
> any truncation operations on the memfd don't lead to IOMMUFD using freed
> memory. This doesn't work with LUO since the preserved memfd might have
> completely different pages after a live update, and mapping them back to
> the IOMMUFD will cause all sorts of problems. Using and preserving the
> seals allows IOMMUFD preservation logic to trust the memfd.
> 
> Preserve the seals by introducing a new 8-bit-wide bitfield. There are
> currently only 6 possible seals but 2 extra bits are used to provide
> room for future expansion. Since the seals are UAPI, it is safe to use
> them directly in the ABI.
> 
> Back the 8-bit field with a u64, leaving 56 unused bits. This is done to
> keep the struct nice and aligned. The unused bits can be used to add new
> flags later, potentially without even needing to bump the version
> number.
> 
> Since the serialization structure is changed, bump the version number to
> "memfd-v2".
> 
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>
> ---
>  include/linux/kho/abi/memfd.h |  9 ++++++++-
>  mm/memfd_luo.c                | 23 +++++++++++++++++++++--
>  2 files changed, 29 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/kho/abi/memfd.h b/include/linux/kho/abi/memfd.h
> index 68cb6303b846..bd549c81f1d2 100644
> --- a/include/linux/kho/abi/memfd.h
> +++ b/include/linux/kho/abi/memfd.h
> @@ -60,6 +60,11 @@ struct memfd_luo_folio_ser {
>   * struct memfd_luo_ser - Main serialization structure for a memfd.
>   * @pos:       The file's current position (f_pos).
>   * @size:      The total size of the file in bytes (i_size).
> + * @seals:     The seals present on the memfd. The seals are UAPI so it is safe
> + *             to directly use them in the ABI. Note: currently there are 6
> + *             seals possible but this field is 8 bits to leave room for future
> + *             expansion.
> + * @__reserved: Reserved bits. May be used later to add more flags.
>   * @nr_folios: Number of folios in the folios array.
>   * @folios:    KHO vmalloc descriptor pointing to the array of
>   *             struct memfd_luo_folio_ser.
> @@ -67,11 +72,13 @@ struct memfd_luo_folio_ser {
>  struct memfd_luo_ser {
>  	u64 pos;
>  	u64 size;
> +	u64 seals:8;

Kernel uABI defines seals as unsigned int, I think we can spare u32 for
them and reserve a u32 flags for other memfd flags (MFD_CLOEXEC,
MFD_HUGETLB etc).

> +	u64 __reserved:56;
>  	u64 nr_folios;
>  	struct kho_vmalloc folios;
>  } __packed;
>  
>  /* The compatibility string for memfd file handler */
> -#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v1"
> +#define MEMFD_LUO_FH_COMPATIBLE	"memfd-v2"
>  
>  #endif /* _LINUX_KHO_ABI_MEMFD_H */
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index a34fccc23b6a..eb68e0b5457f 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -79,6 +79,8 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/vmalloc.h>
>  #include <linux/memfd.h>
> +#include <uapi/linux/memfd.h>
> +
>  #include "internal.h"
>  
>  static int memfd_luo_preserve_folios(struct file *file,
> @@ -222,7 +224,7 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  	struct memfd_luo_folio_ser *folios_ser;
>  	struct memfd_luo_ser *ser;
>  	u64 nr_folios;
> -	int err = 0;
> +	int err = 0, seals;
>  
>  	inode_lock(inode);
>  	shmem_freeze(inode, true);
> @@ -234,8 +236,15 @@ static int memfd_luo_preserve(struct liveupdate_file_op_args *args)
>  		goto err_unlock;
>  	}
>  
> +	seals = memfd_get_seals(args->file);
> +	if (seals < 0) {
> +		err = seals;
> +		goto err_free_ser;
> +	}
> +
>  	ser->pos = args->file->f_pos;
>  	ser->size = i_size_read(inode);
> +	ser->seals = seals;
>  
>  	err = memfd_luo_preserve_folios(args->file, &ser->folios,
>  					&folios_ser, &nr_folios);
> @@ -444,13 +453,23 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  	if (!ser)
>  		return -EINVAL;
>  
> -	file = memfd_alloc_file("", 0);
> +	/*
> +	 * The seals are preserved. Allow sealing here so they can be added
> +	 * later.
> +	 */
> +	file = memfd_alloc_file("", MFD_ALLOW_SEALING);

I think we should select flags passed to memfd_alloc_file() based on
ser->seals (and later based on ser->seals and ser->flags).

>  	if (IS_ERR(file)) {
>  		pr_err("failed to setup file: %pe\n", file);
>  		err = PTR_ERR(file);
>  		goto free_ser;
>  	}
>  
> +	err = memfd_add_seals(file, ser->seals);

I'm not sure using MFD_ALLOW_SEALING is enough if there was F_SEAL_EXEC in
seals.

> +	if (err) {
> +		pr_err("failed to add seals: %pe\n", ERR_PTR(err));
> +		goto put_file;
> +	}
> +
>  	vfs_setpos(file, ser->pos, MAX_LFS_FILESIZE);
>  	file->f_inode->i_size = ser->size;
>  
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

