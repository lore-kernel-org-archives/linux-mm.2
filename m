Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34080CEACEF
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F80C8E001B; Mon, 17 Nov 2025 05:08:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CF958E0002; Mon, 17 Nov 2025 05:08:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 80CAB8E001B; Mon, 17 Nov 2025 05:08:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DF528E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:08:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3558F12F77F
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:08:37 +0000 (UTC)
X-FDA: 84119674674.21.724D017
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9BD4840003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:08:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pyjp8I30;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763374115; a=rsa-sha256;
	cv=none;
	b=qK8x7aTEoLiWv/SAc+xENAOnow7UJBiCqk+2nAkCDYRSNoRVUg9G5Hyw5j3obtZ9+KM58v
	OdLrquBatFkJILgklTUvlh+2KlgpTMOubMMzcp2+iHC3z3TAJoaLcIV0TzrvTSr2ixkfaD
	u4/Bqhb89xfRfuKB65LmfXINiO7f9To=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pyjp8I30;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763374115;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pi4GezqaMjDFJo0KlZmi+2MIbiBBIiefktr23wD9G64=;
	b=EDbnbQsIDsqWFbK1hGvOhOoUUB2mI8rv+3NNTaP2x1P729jdBzu4C+8s6NJLqzVI3AaJYA
	ROsTKB0XOOqfsoT70MCRikWzlK+8/1bYfJWiGhWWV7aU63MX83XbPbCt5508s28Wm5VBMW
	L7msKm6WkwUlCedeZ5y7VQ5yoyRUt0c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6325D409CA;
	Mon, 17 Nov 2025 10:08:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7080FC4CEF1;
	Mon, 17 Nov 2025 10:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763374114;
	bh=NfEctPhiqLwKM7Al5ilCJVKY/ooOPtorS0nazjY5qF8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pyjp8I30CMsVwAFn9pOiUTamRKt1uRSpOdE7O2jvI4OTBEvKMg4uqklLdOpQB0cTB
	 7hHYlDan0L0oNCir7r5ZwY4Ze1MUR+Tc6/AcZxyTGFksM/YJQ2xzH4ukZrQxGbhIce
	 YTJJly5hrZOjWrGCfHCEpIzoGzNCIx8ezeXHddI6w0fZSg1Y/j/jY3eHHyIEI/6J4q
	 Jxtx9gkWqj7xCl8h+ggjG83fdiZ34qLZTR2P9DcFpD1W5m5qelmcIP6t9o6dcb8Prv
	 kmHR3mG7h1z19hn9UOwxRdhQdpnkKDudEOZxRksOyz+oRXe8F0db8Dio3oOjHY3CML
	 zQVyCqEEoWARg==
Date: Mon, 17 Nov 2025 12:08:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: pratyush@kernel.org, jasonmiu@google.com, graf@amazon.com,
	dmatlack@google.com, rientjes@google.com, corbet@lwn.net,
	rdunlap@infradead.org, ilpo.jarvinen@linux.intel.com,
	kanie@linux.alibaba.com, ojeda@kernel.org, aliceryhl@google.com,
	masahiroy@kernel.org, akpm@linux-foundation.org, tj@kernel.org,
	yoann.congal@smile.fr, mmaurer@google.com, roman.gushchin@linux.dev,
	chenridong@huawei.com, axboe@kernel.dk, mark.rutland@arm.com,
	jannh@google.com, vincent.guittot@linaro.org, hannes@cmpxchg.org,
	dan.j.williams@intel.com, david@redhat.com,
	joel.granados@kernel.org, rostedt@goodmis.org,
	anna.schumaker@oracle.com, song@kernel.org, linux@weissschuh.net,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-mm@kvack.org, gregkh@linuxfoundation.org, tglx@linutronix.de,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
	bartosz.golaszewski@linaro.org, cw00.choi@samsung.com,
	myungjoo.ham@samsung.com, yesanishhere@gmail.com,
	Jonathan.Cameron@huawei.com, quic_zijuhu@quicinc.com,
	aleksander.lobakin@intel.com, ira.weiny@intel.com,
	andriy.shevchenko@linux.intel.com, leon@kernel.org, lukas@wunner.de,
	bhelgaas@google.com, wagi@kernel.org, djeffery@redhat.com,
	stuart.w.hayes@gmail.com, ptyadav@amazon.de, lennart@poettering.net,
	brauner@kernel.org, linux-api@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, saeedm@nvidia.com,
	ajayachandra@nvidia.com, jgg@nvidia.com, parav@nvidia.com,
	leonro@nvidia.com, witu@nvidia.com, hughd@google.com,
	skhawaja@google.com, chrisl@kernel.org
Subject: Re: [PATCH v6 12/20] mm: shmem: allow freezing inode mapping
Message-ID: <aRr0CQsV16usRW1J@kernel.org>
References: <20251115233409.768044-1-pasha.tatashin@soleen.com>
 <20251115233409.768044-13-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251115233409.768044-13-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9BD4840003
X-Stat-Signature: r1hpejfasou1r73hccrtcsz99mcza9a1
X-Rspam-User: 
X-HE-Tag: 1763374115-434899
X-HE-Meta: U2FsdGVkX19S2KfU1wO8GkJZJN8nbOVCkr5Sc9MgenNgpD9muaivixAeIrblvzgE5laYAJL10ERCtCZhB4to5PQALw8e0tywdS2fRNZS5/ebTlEgX4sSkeIovgDJBb0V/KveqCmD8esfchkomRULofl13p6vIPWGjvrm2AHo4sHWvKVppVoISGbBboJhzHj8aMy+bu25aTqEcGoHIIluhNSZV7QqHXh19U4EM5/CpQQVmfiVHRboRqlN5k6tKO4n4phD1CrBiXqJA9YPYRzh2HEEdekURm9iiFSgZziHMamER/qUeRBDObpHEuUzWIrkGmmUUO5Oew+q7HqqptfJC2LZ3Z9YmbvSTWLdABEiXpMdIkNfUqew6TFhdR2+rK45j/COFviWHiBksFuOUtnc+WgFm8UG6L/EyZyN4c3pKC25u2RWZxS21aL1hMXdW0EBoh8tkGb9enQRLfXSWY8HT+qC0Az9TajjiEWXpHiLA5shRoeGEoUzrPtFMoExUCqPp+jzqchr1vie882xrB4RCRxuuFkusSvJ1haus2ICLx5E7my4HqKEK7X5jcVViG/a8dxKmcDmCL2Ccz2UjbruUSzZUFCcsJpRsfJvLxsOStNxDPG4PQjI6/mpolJbaWD4eR9bZPKtn29eFRP9MNP45palYA59eafWUVlQre24vPjEgAoYWvCDGEjsHZ0nEKvUfX6th22B64+NfgNq8zgemiqGas66oCh8/4yKajISYiWHOfZ5PpM1UKkMhH3nqbhnn3nYpCbyZh18C0zYVykTFPbIVexx0HXEoKnm1ZNYwkpMMZV8ParLF8Os3R7xfi+8Uzmv3ZBtwaI+EXUECa7W6ukVKi+9cpetoSoKgOfn152eD7kK65lh9bb1McxTJ7hgmeEBVvMQGGUDgKOhWwkc37c2JXM2lBPN9XNms5sev03vEcW+45jRN6CXynSAwBBX07dUZT2LUgmPhZENCSN
 XkieIpvb
 tBehq2o+uuwN5CSNKZ/cxM5NVOg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 06:33:58PM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> To prepare a shmem inode for live update via the Live Update
> Orchestrator (LUO), its index -> folio mappings must be serialized. Once
> the mappings are serialized, they cannot change since it would cause the
> serialized data to become inconsistent. This can be done by pinning the
> folios to avoid migration, and by making sure no folios can be added to
> or removed from the inode.
> 
> While mechanisms to pin folios already exist, the only way to stop
> folios being added or removed are the grow and shrink file seals. But
> file seals come with their own semantics, one of which is that they
> can't be removed. This doesn't work with liveupdate since it can be
> cancelled or error out, which would need the seals to be removed and the
> file's normal functionality to be restored.
> 
> Introduce SHMEM_F_MAPPING_FROZEN to indicate this instead. It is
> internal to shmem and is not directly exposed to userspace. It functions
> similar to F_SEAL_GROW | F_SEAL_SHRINK, but additionally disallows hole
> punching, and can be removed.
> 
> Signed-off-by: Pratyush Yadav <ptyadav@amazon.de>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/shmem_fs.h | 17 +++++++++++++++++
>  mm/shmem.c               | 12 +++++++++++-
>  2 files changed, 28 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 650874b400b5..a9f5db472a39 100644
> --- a/include/linux/shmem_fs.h
> +++ b/include/linux/shmem_fs.h
> @@ -24,6 +24,14 @@ struct swap_iocb;
>  #define SHMEM_F_NORESERVE	BIT(0)
>  /* Disallow swapping. */
>  #define SHMEM_F_LOCKED		BIT(1)
> +/*
> + * Disallow growing, shrinking, or hole punching in the inode. Combined with
> + * folio pinning, makes sure the inode's mapping stays fixed.
> + *
> + * In some ways similar to F_SEAL_GROW | F_SEAL_SHRINK, but can be removed and
> + * isn't directly visible to userspace.
> + */
> +#define SHMEM_F_MAPPING_FROZEN	BIT(2)
>  
>  struct shmem_inode_info {
>  	spinlock_t		lock;
> @@ -186,6 +194,15 @@ static inline bool shmem_file(struct file *file)
>  	return shmem_mapping(file->f_mapping);
>  }
>  
> +/* Must be called with inode lock taken exclusive. */
> +static inline void shmem_i_mapping_freeze(struct inode *inode, bool freeze)

_mapping usually refers to operations on struct address_space.
It seems that all shmem methods that take inode are just shmem_<operation>,
so shmem_freeze() looks more appropriate.

> +{
> +	if (freeze)
> +		SHMEM_I(inode)->flags |= SHMEM_F_MAPPING_FROZEN;
> +	else
> +		SHMEM_I(inode)->flags &= ~SHMEM_F_MAPPING_FROZEN;
> +}
> +
>  /*
>   * If fallocate(FALLOC_FL_KEEP_SIZE) has been used, there may be pages
>   * beyond i_size's notion of EOF, which fallocate has committed to reserving:
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 1d5036dec08a..05c3db840257 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1292,7 +1292,8 @@ static int shmem_setattr(struct mnt_idmap *idmap,
>  		loff_t newsize = attr->ia_size;
>  
>  		/* protected by i_rwsem */
> -		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
> +		if ((info->flags & SHMEM_F_MAPPING_FROZEN) ||

A corner case: if newsize == oldsize this will be a false positive

> +		    (newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
>  		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
>  			return -EPERM;
>  
> @@ -3289,6 +3290,10 @@ shmem_write_begin(const struct kiocb *iocb, struct address_space *mapping,
>  			return -EPERM;
>  	}
>  
> +	if (unlikely((info->flags & SHMEM_F_MAPPING_FROZEN) &&
> +		     pos + len > inode->i_size))
> +		return -EPERM;
> +
>  	ret = shmem_get_folio(inode, index, pos + len, &folio, SGP_WRITE);
>  	if (ret)
>  		return ret;
> @@ -3662,6 +3667,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>  
>  	inode_lock(inode);
>  
> +	if (info->flags & SHMEM_F_MAPPING_FROZEN) {
> +		error = -EPERM;
> +		goto out;
> +	}
> +
>  	if (mode & FALLOC_FL_PUNCH_HOLE) {
>  		struct address_space *mapping = file->f_mapping;
>  		loff_t unmap_start = round_up(offset, PAGE_SIZE);
> -- 
> 2.52.0.rc1.455.g30608eb744-goog
> 

-- 
Sincerely yours,
Mike.

