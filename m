Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 806BDCFA46B
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 15:29:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 813896B0011; Sun, 23 Nov 2025 10:29:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EB2A6B0024; Sun, 23 Nov 2025 10:29:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 727D46B00B0; Sun, 23 Nov 2025 10:29:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 604176B0011
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 10:29:38 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E614016073E
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:29:37 +0000 (UTC)
X-FDA: 84142256394.18.12A4812
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3F22CC000C
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 15:29:36 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k8qOsmK0;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763911776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9gfx3y9GMsNCiKJNpX7xy5vczWZ/JO16hpl/OkcCs8=;
	b=VYThDKNRWIiFtIEcEZc0Y8bL5Cuf2+Rd0DPG4igfrws7PVNbISwBMGM9NFJRz4ri+F1g+w
	ySSd41Sm8UZAF/E2OCk2nRrtb77ccVxqQH0JKSFLPjCDtcIT2vPu7gvWGsMiKMIE183AuS
	ZpE5L/6X6SbkLklgwvuKkVsRzmMCHPk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763911776; a=rsa-sha256;
	cv=none;
	b=6J0ZedSSyKTrFkzMLdX43e4MeetdNRqPHguHrpfCJ5LNcW05YFaqu6KF4k1ufXiGUUxR5L
	xsv1JSBhP0lNq9cJ1BJnKkvyMfrqJLkfqN1yAOwu3UM42dWQteLxtGiqXgfuLxlkVm+cum
	kRXJcqotsHw5kv7k1tAqEL++jQUcvaQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k8qOsmK0;
	spf=pass (imf28.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9645843598;
	Sun, 23 Nov 2025 15:29:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 919A4C113D0;
	Sun, 23 Nov 2025 15:29:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763911774;
	bh=KJ7T2gPWZjYh1cz0HfYyKYPb/10E/Fx5BaTXqTs2/Eo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k8qOsmK0MFixaOE+ur9RDYKjJNzgQETCBx4Oa3wWC/9H1PoxgtrNQNX7/5A4GpW/U
	 v0JV7rkpnvyJL1rYx6chzjbZgoupm4vdk57fliNPi39btz2xk1F5FCee4m+Rr8Cqe1
	 E9l6XiQcA2IWOIwOMkCEhjEqnPIJml2n1VV2Eze/Ydq0SxT4eVjeex+rOaqjxgNVxe
	 53QRcV94fUWhBLEk/49eJ3jbINePYq/OtvXRBht1s5jNKnMBp3RxBxQ8lxoVUsjDPB
	 tQkNIka36Z6rQKVe/hymFXQ83s2NhHD4on6LZ3syqdlujrr7+PFw2Mcordkbsq1LyH
	 /sCwFTOTSrNUQ==
Date: Sun, 23 Nov 2025 17:29:09 +0200
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
Subject: Re: [PATCH v7 11/22] mm: shmem: allow freezing inode mapping
Message-ID: <aSMoRRtanMkHo9Tr@kernel.org>
References: <20251122222351.1059049-1-pasha.tatashin@soleen.com>
 <20251122222351.1059049-12-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251122222351.1059049-12-pasha.tatashin@soleen.com>
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 3F22CC000C
X-Stat-Signature: bpenj9jwuud97an7dppthhib9ki7oemj
X-HE-Tag: 1763911776-655669
X-HE-Meta: U2FsdGVkX1+Fm/SY3aKFEv/NSA43VDPW/MAdnwUoOYPVzydufA3ke7BGFMQQobaLGWGUCqiYe/rqbfdy+LZmb0t4ujBhslpAaXjlDmPUSXZYLqSAXpV+YiBpKYbx/Et7gQqoNFPWbBb0Cd/F0MvRYeJhFO6E9DnGxOO6qOGyfkKDKJ7+oKv7UUGk0xRVs0u3/C7vdFkHc3GTKWO7p9wpZvIl1mkMjGoA3o8f4VFZhb2G9WCGyOkxtSSbHEI3CAUvfLM+hUDRPJL3YjC27OLHFMjzKniU1vZVug1BifiOVPAJ8soqXVYLitH+CoxfSBr9h/1pEfh8FfFMfU4DPYL1qiNZhBmI5coR96NBtoukDNx6JrmQRfq9kGV9jNLb4iN8xJUoYQije5fny9/7zeTDnLlmWl1FBCAaZnXJN0o/gDTA5qYmsPY0obKfWvSGHrMCX5UvtvfkFO6BsvVKD5JK3D9cgMrOWkBUGpVX4DZLnpdTqGedRsWhpidtZ7CzF3ya1VxGjCSf14znM5D8b16gLqhkw/kFpXeou1YpJMLd6Y6VEMVWKpqqb3c7GMOGFu1D2PRF/kr/fm0kQhiQF0i+aCTpGT11N8rcWEalwk3LWuiBwX1tDAKf6ZTFDftKqBOynys5jW/4Vi3NJTnE0boLIOQ2QKYDyxGYWMjGNUj4+omwFv3oKvDVsPjgUQoXLQQORpJ1K835e+SVMupOm1EpK47oeL8lDudYUt4Ycj4iO9zDyaNW8dFIKqWLR1AgN9wnBKpbc3r2eVDrOWiiUrbveNLC5dqSy8ILYDRNGGgrOMJMfMGhFDBdEVFaEp35zttykNFRQZUCtre1SrAtL+Hsdko4oFy0ibjaIc6EdkIRe48A/h7OKoHCEOqa3foQfJlQ5uhEXAAjWc5Qg8nPuS2KpXTyygG/K8oZVeZQaxTYy6oAk/PfguEjP+0ukeBXUj2OpnI6nklwN1/+IbLKp21
 fH+E70M5
 eljbsvUgsKIdbJNaeG28rKZwpZT7CNhAirC9VxeApYsHpXG1KTHSUuQigSp2o7vQZu3iPweHtrmauhu4GiOVUQQczO85CFA2l+3puZOeDOH75GkEDtsDz5e7grIWPL43JSuchonkwzHnekcNuUYB/iibPo69JdYh/Y9lTp7FF60boBnbH03EQTijyUCcygDUJ5dVmG2F5RCgCvOSqJDXKsNDJ3Z1QfILPqcPfNdDnD+lyolksyMdf6ktJojz24p7nCoAHrXrmtWIzOj3pSup/ZYVu2g+B87XDHrIvLdOl4p+dmS2RbeoJMmAg939GecDRuFqBCJYXKhTIshOIdbl12EO7nm4ZwHEX9RWXv0Ti/QTnoXBLpfrhSSv10+ole7aLnpQPg4MxX54T+GWXfuyR9D+ZwQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 22, 2025 at 05:23:38PM -0500, Pasha Tatashin wrote:
> From: Pratyush Yadav <ptyadav@amazon.de>
> 
> To prepare a shmem inode for live update, its index -> folio mappings
> must be serialized. Once the mappings are serialized, they cannot change
> since it would cause the serialized data to become inconsistent. This
> can be done by pinning the folios to avoid migration, and by making sure
> no folios can be added to or removed from the inode.
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
>  mm/shmem.c               | 19 ++++++++++++++++---
>  2 files changed, 33 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/shmem_fs.h b/include/linux/shmem_fs.h
> index 650874b400b5..d34a64eafe60 100644
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
> +static inline void shmem_freeze(struct inode *inode, bool freeze)
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
> index 1d5036dec08a..cb74a5d202ac 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1292,9 +1292,13 @@ static int shmem_setattr(struct mnt_idmap *idmap,
>  		loff_t newsize = attr->ia_size;
>  
>  		/* protected by i_rwsem */
> -		if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
> -		    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
> -			return -EPERM;
> +		if (newsize != oldsize) {
> +			if (info->flags & SHMEM_F_MAPPING_FROZEN)
> +				return -EPERM;
> +			if ((newsize < oldsize && (info->seals & F_SEAL_SHRINK)) ||
> +			    (newsize > oldsize && (info->seals & F_SEAL_GROW)))
> +				return -EPERM;
> +		}
>  
>  		if (newsize != oldsize) {

I'd stick 

			if (info->flags & SHMEM_F_MAPPING_FROZEN)
				return -EPERM;

here and leave the seals check alone.

Other than than

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

