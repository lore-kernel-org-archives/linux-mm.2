Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D62CE7AE0
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:30:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5ECA98E0007; Fri, 14 Nov 2025 06:30:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5C4A78E0002; Fri, 14 Nov 2025 06:30:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DAD78E0007; Fri, 14 Nov 2025 06:30:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 394548E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:30:10 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AAAC712DE64
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:30:09 +0000 (UTC)
X-FDA: 84108993738.19.E695145
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3FC63A0022
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:30:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Akk7h6Hl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763119808; a=rsa-sha256;
	cv=none;
	b=YL081KtGV3NP006DLC59FaNK1Nm+/+3e2SZ0S8dVGhKrEUWZ1jsjJxAgFpWu+LL17tEU0o
	I+jA/OU2839fC/aO45hOnvxpePEFsRUk5Fl3OVkb0zNkyPYidXFEm4ZTPYtBGqT49+JB9J
	AdJZis1yMt2bRfOCnznUbgNSvOsT6HQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Akk7h6Hl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763119808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bTjQugeHQ7S+XBq2uDiuMPr2+GkW9aWsDNl+wZ54pv0=;
	b=EtLlr7ZIiAIm/0R1l496Xv+IoVf+Zne1xjydZ5JWLSmSSV0VEIqmtXTHpAM+VI2F88ADhJ
	bekD1fKsvSfXMqmQdjuFwEAVRsbf9zgY2N+ORzUt/N73+aVXiYYxJLnnDcd1nYSzA3H86x
	1DNEP+iTkHMTeFgyWMK6nVzWhF5t9S8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BE386015D;
	Fri, 14 Nov 2025 11:30:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6503CC4CEF1;
	Fri, 14 Nov 2025 11:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763119807;
	bh=nWQdNFwkseMe3m11T//I7TjOchkTxc0f6sD/wvtcMU0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Akk7h6HlDkGyGgeCHZX5VqCq5N2nSt0CHf09pDVbnqBORphhI2YOmYWQy1u7s7HXC
	 vk2eR2lL3RSSszzGR9ZhrQ9QHgg7YrLsh+41vhXoLLGIoUvW4UsruI26iGVeGzAPcP
	 84LrN6UJauCgG0t0GQcvjzAMnlfsFZghOoVZaAboWw1so/FBVYjxsoCOb/82AQtq2Z
	 0NtCLvZKWHuVI1yWzfUj922GUd6PeRI52oxjC49q5F9N+wj9XWPMdbCNqC7iekpi2w
	 awEJbNAXVGPvsWxl0F2algphSwaLFV5Rgvd/Ls4Ffdpt7rW/ve1asAz7IG+BKt3CL0
	 RK6yYv8fID0kA==
Date: Fri, 14 Nov 2025 13:29:41 +0200
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
	anna.schumaker@oracle.com, song@kernel.org, zhangguopeng@kylinos.cn,
	linux@weissschuh.net, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-mm@kvack.org,
	gregkh@linuxfoundation.org, tglx@linutronix.de, mingo@redhat.com,
	bp@alien8.de, dave.hansen@linux.intel.com, x86@kernel.org,
	hpa@zytor.com, rafael@kernel.org, dakr@kernel.org,
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
Subject: Re: [PATCH v5 02/22] liveupdate: luo_core: integrate with KHO
Message-ID: <aRcSpbwBabFjeYe3@kernel.org>
References: <20251107210526.257742-1-pasha.tatashin@soleen.com>
 <20251107210526.257742-3-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251107210526.257742-3-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3FC63A0022
X-Stat-Signature: e1p4dcd59uk6er1cc674sebhmsb9uwy3
X-HE-Tag: 1763119808-773271
X-HE-Meta: U2FsdGVkX1/ukBapvrZqaQA6IGl/ZYcCRlEPHzeKolaNiAQ+gAvIBJqTr5kjXxKpGnhuqIhowQB6KU3sBqvYKMJUcf6wmYpDKXqdroBK2+Moz7HPEIZxsKH5gvJWMnljmPQUiV2u1OOIUHuos+RB5h898P1iJk1hfmG55/jJovfdRv1nL9uFJWLq2OLjy/Tj1O0AdbU1C+AlPPW8zYIQKe+ZenKokuIjdbf510sJWCCg1XtG3Oq6/8ksy/UF8VdriG35AxoHGOOulHfOYIdFWAICmmR8E+CdQH3K+7YpWaKZGWCOAE/ZeNJJOlugZM2cy9A5G3CbK/bN272/IdJ9+iUPI9emJ5HsERrMFVNUj1HTVPbSQPCQ5oCNGTQTB0WWy0b0+0SHwsTmOEXnCSjr8yxowH924o9F0Q2i15hAUbq1IsAVZJ3x+ZD7eocbCDK3nBH/suTfpI7+cJW0ClFg59un7NI0QZ0kDLS9mpkkpelPWDLHzjjmpiZQ+LQ0BxgJ++egzXwy7bQv2Ga2J63acaFhGCYEKlJVKZdWWN22c1uOyFBkW1Fgf2lidUXbK+Vti1GwOGFn8ODQ+asXCEPnM3ZX7Kxb3BWuUPkax7rlhXod3cyint8ripEmjPZWyw5a4nb6NBe0pinQ+VSvgd772zrpMQ3EGXslQTicV+hZkZ8O8PnMq5JXuMVCaQz3lbn/eKFaV56vrO9UisQDqZkSa/QE2YawYzYXw51pnEK+uI71yV/Nxf9OXW2AnLGuQh2EHGtn4ASk9PSwSjT1bTXCM6rY8S8aX1TgStW6fx84uK0xdATVE56hUjWUB/5/n1HMAD+Y331AC7sF8IbHay194yPwZW7qy3pMZFqrVfPa8OM8J0+bFqwr8mVpxMLlDGczBCWNaS+RxMsGyDStYjr97kWqAmxhk5f8bgiO7TF9O5oTzq39+2sH/5qp2jNU3T8qy0kHEYMYuDEmV6bYJZH
 bTpsp9OX
 J8/1rEvOPuxGAVyDeoFaP1vyBY7Xc2q3L0320rnHeZVUz02EIhTIfgF9pqYnoRe302/ZX5fW0zC9gvhU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 04:03:00PM -0500, Pasha Tatashin wrote:
> Integrate the LUO with the KHO framework to enable passing LUO state
> across a kexec reboot.
> 
> When LUO is transitioned to a "prepared" state, it tells KHO to
> finalize, so all memory segments that were added to KHO preservation
> list are getting preserved. After "Prepared" state no new segments
> can be preserved. If LUO is canceled, it also tells KHO to cancel the
> serialization, and therefore, later LUO can go back into the prepared
> state.
> 
> This patch introduces the following changes:
> - During the KHO finalization phase allocate FDT blob.
> - Populate this FDT with a LUO compatibility string ("luo-v1").
> 
> LUO now depends on `CONFIG_KEXEC_HANDOVER`. The core state transition
> logic (`luo_do_*_calls`) remains unimplemented in this patch.
> 
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/liveupdate.h         |   6 +
>  include/linux/liveupdate/abi/luo.h |  54 +++++++
>  kernel/liveupdate/luo_core.c       | 243 ++++++++++++++++++++++++++++-
>  kernel/liveupdate/luo_internal.h   |  17 ++
>  mm/mm_init.c                       |   4 +
>  5 files changed, 323 insertions(+), 1 deletion(-)
>  create mode 100644 include/linux/liveupdate/abi/luo.h
>  create mode 100644 kernel/liveupdate/luo_internal.h
> 
> diff --git a/include/linux/liveupdate.h b/include/linux/liveupdate.h
> index 730b76625fec..0be8804fc42a 100644
> --- a/include/linux/liveupdate.h
> +++ b/include/linux/liveupdate.h
> @@ -13,6 +13,8 @@
>  
>  #ifdef CONFIG_LIVEUPDATE
>  
> +void __init liveupdate_init(void);
> +
>  /* Return true if live update orchestrator is enabled */
>  bool liveupdate_enabled(void);
>  
> @@ -21,6 +23,10 @@ int liveupdate_reboot(void);
>  
>  #else /* CONFIG_LIVEUPDATE */
>  
> +static inline void liveupdate_init(void)
> +{
> +}

The common practice is to place brackets at the same line with function
declaration.

...

> +static int __init luo_early_startup(void)
> +{
> +	phys_addr_t fdt_phys;
> +	int err, ln_size;
> +	const void *ptr;
> +
> +	if (!kho_is_enabled()) {
> +		if (liveupdate_enabled())
> +			pr_warn("Disabling liveupdate because KHO is disabled\n");
> +		luo_global.enabled = false;
> +		return 0;
> +	}
> +
> +	/* Retrieve LUO subtree, and verify its format. */
> +	err = kho_retrieve_subtree(LUO_FDT_KHO_ENTRY_NAME, &fdt_phys);
> +	if (err) {
> +		if (err != -ENOENT) {
> +			pr_err("failed to retrieve FDT '%s' from KHO: %pe\n",
> +			       LUO_FDT_KHO_ENTRY_NAME, ERR_PTR(err));
> +			return err;
> +		}
> +
> +		return 0;
> +	}
> +
> +	luo_global.fdt_in = __va(fdt_phys);

phys_to_virt is clearer, isn't it?

> +	err = fdt_node_check_compatible(luo_global.fdt_in, 0,
> +					LUO_FDT_COMPATIBLE);

...

> +void __init liveupdate_init(void)
> +{
> +	int err;
> +
> +	err = luo_early_startup();
> +	if (err) {
> +		pr_err("The incoming tree failed to initialize properly [%pe], disabling live update\n",
> +		       ERR_PTR(err));
> +		luo_global.enabled = false;
> +	}
> +}
> +
> +/* Called during boot to create LUO fdt tree */

			 ^ create outgoing

> +static int __init luo_late_startup(void)
> +{
> +	int err;
> +
> +	if (!liveupdate_enabled())
> +		return 0;
> +
> +	err = luo_fdt_setup();
> +	if (err)
> +		luo_global.enabled = false;
> +
> +	return err;
> +}
> +late_initcall(luo_late_startup);

It would be nice to have a comment explaining why late_initcall() is fine
and why there's no need to initialize the outgoing fdt earlier.

> +/**
> + * luo_alloc_preserve - Allocate, zero, and preserve memory.

I think this and the "free" counterparts would be useful for any KHO users,
even those that don't need LUO.

> + * @size: The number of bytes to allocate.
> + *
> + * Allocates a physically contiguous block of zeroed pages that is large
> + * enough to hold @size bytes. The allocated memory is then registered with
> + * KHO for preservation across a kexec.
> + *
> + * Note: The actual allocated size will be rounded up to the nearest
> + * power-of-two page boundary.
> + *
> + * @return A virtual pointer to the allocated and preserved memory on success,
> + * or an ERR_PTR() encoded error on failure.
> + */
> +void *luo_alloc_preserve(size_t size)
> +{
> +	struct folio *folio;
> +	int order, ret;
> +
> +	if (!size)
> +		return ERR_PTR(-EINVAL);
> +
> +	order = get_order(size);
> +	if (order > MAX_PAGE_ORDER)
> +		return ERR_PTR(-E2BIG);

High order allocations would likely fail or at least cause a heavy reclaim.
For now it seems that we won't be needing really large contiguous chunks so
maybe limiting this to PAGE_ALLOC_COSTLY_ORDER?

Later if we'd need higher order allocations we can try to allocate with
__GFP_NORETRY or __GFP_RETRY_MAYFAIL with a fallback to vmalloc.

> +
> +	folio = folio_alloc(GFP_KERNEL | __GFP_ZERO, order);
> +	if (!folio)
> +		return ERR_PTR(-ENOMEM);
> +
> +	ret = kho_preserve_folio(folio);
> +	if (ret) {
> +		folio_put(folio);
> +		return ERR_PTR(ret);
> +	}
> +
> +	return folio_address(folio);
> +}
> +

-- 
Sincerely yours,
Mike.

