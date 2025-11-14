Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F073CE8D5F
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 17:46:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 938328E0016; Fri, 14 Nov 2025 12:46:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E8948E0010; Fri, 14 Nov 2025 12:46:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D7598E0016; Fri, 14 Nov 2025 12:46:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6847D8E0010
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 12:46:00 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1A059C044A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:46:00 +0000 (UTC)
X-FDA: 84109940880.21.3D10143
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 779824000F
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 17:45:58 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtaHtAXM;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763142358;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qwjgF6s764EzS3wI/iHDEvAFk/om7nDcQRXdQNuY20c=;
	b=o44ITSRYxsQ5B/1wwilHZA62UKLR0wmI+W9oPcAwRwUt+QCwyece93a/c0UuLetQg+zl5N
	edRtp1O23DP7oJNEIvOx9VExVGOA2pcuEcRgzXJVfcZ9GMLLGO14TjafeH7oDy2OoXPBY8
	ztaLEcLtqmykf2oV3+iIVgrNJHpYKb0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763142358; a=rsa-sha256;
	cv=none;
	b=w3ae02tPNrkLPETs1sF0Tz96viPEF+daXDUOx8fsBcbedVFbi8XobeaMuDqEadIlx/5dbv
	qHxdOIER/WzgPnxUblnoU+LF4fV/htS6rzs3QdRnqBV1z2wVxvoOfg4FD58kuCaVCfLMiZ
	Gw958yn4iwfbA+5Kn963MQPqNfqr9Dc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TtaHtAXM;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7430B42A33;
	Fri, 14 Nov 2025 17:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727A6C19422;
	Fri, 14 Nov 2025 17:45:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763142357;
	bh=ozDxBmPfrFtagqwIh7x/8xt7ppkbKkHg3TCmX0I0wQg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=TtaHtAXMQ/2sQIvDT4alfLUFdNYNzPGW+uauKrMPzKSM+0FH/I87nYoLJbk0LhHWy
	 XZ53G2XTZ35PIVxUrzHaRs3hWEbNcK3g8Sx0OUM4lrDRf/aNZqEZ4OgTfE+J5/twuZ
	 K5e0W1eHWPaBMUEcrlL00CxiyQaQ9gvylwrkAAIeM3GT7GZF51G5fCm6DoRW81pr5X
	 mV5ClXuKGxuwzNbmgiZ6D7Wp8zXAubW9qyPwgBYCsZvUrreBharqgX7bMDmikkxzF7
	 vuVTUOfaQl5HrDagVU7kLar+jXJWbHP+YqBOCVyfHmkvAAHkPvWE5WeMAcXkA8b/y6
	 QWFjON4XCexgQ==
From: Pratyush Yadav <pratyush@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org,  bhe@redhat.com,  rppt@kernel.org,
  jasonmiu@google.com,  arnd@arndb.de,  coxu@redhat.com,
  dave@vasilevsky.ca,  ebiggers@google.com,  graf@amazon.com,
  kees@kernel.org,  linux-kernel@vger.kernel.org,
  kexec@lists.infradead.org,  linux-mm@kvack.org
Subject: Re: [PATCH v1 13/13] kho: Introduce high-level memory allocation API
In-Reply-To: <20251114155358.2884014-14-pasha.tatashin@soleen.com> (Pasha
	Tatashin's message of "Fri, 14 Nov 2025 10:53:58 -0500")
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
	<20251114155358.2884014-14-pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 18:45:54 +0100
Message-ID: <mafs0qzu05wz1.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 779824000F
X-Stat-Signature: dexj8f1yunqrjouigng99hy4p8r66xc8
X-HE-Tag: 1763142358-344232
X-HE-Meta: U2FsdGVkX1/BVgHWElklnGQldhFDhr3uz3nyavJivwzoVak2esI7i2J8zX+sLJ9LL6xfeV2kzTlDYoyr0L28xs8ILFQ8NAHzNQtn1/WclQ8ZaV8BtmeRBdSAvkJyqTfgMvcIVJmx3JjcqJI/DVKbns+hrJrcxqdi+PXWb1SCd/yU3ZgRfocYbOi0hVzJdWCA7s+50Yua89kFrwlMIRkmk5r4lYJY1LahGyIU8ep5z9KgoMLQFvofzmxMNX6I4PfqM9IuzMukXt7mw8+kHOD89A1R7t/tZ4S4Rs9Z/H2HfknIEzvogsUwtAuQvaKXT8MiXc1ElRl82/3vSam1ZrZkBoZuB1NZr5PDU0rJXQJbqD2hSjIef8Sf+VObKRGKHTshRv7+qIaYxJin19+TgqBQ1xWxGrI8/38nKw4L3PyKtiLvQHJaPigHTJ7t2Tx0kXNswgXFm9gIGy6MsNcqyJ0eO+/1P9QV/s/rgQT2BDCAeyK7mgr+8zTUe5vcqHfpDN67zCn8BwNjU0fLCOwhJqybJd3/AZI4Vw76BKeWqR5/eop0aaY8pu75KnxxZGlX5tQ0EULLFvBfETQWRF0G8PxnGv6oKiIgHpC2gj632e/O3ndtkdUqTG11wVeDGrS/3pSpIpqd+EARrBo25hRMHajlZFJHR9MuWwRKihejdoGw/5Si0RIdUerSvoGtANNeicBu3RcsTdRW+ZPb+dE1k6wBBZ/Kx7sKv6UvagDbcguN9M505wm9L1j/7PRJOA/Erxa9odJi9dsOkKpQQnIg+/jvz8tyez0RZUT6XwQBxCDY+onlCkXyTVBuL/U3VyotfarqE9hCLV87c3aaxXX6tXu4H1Ic4AxWbhJ0U7C4nPzB4CzsPIJbEKbw1tpuq9/vO/p0wKnsqy04yc6iuJqxtMw8mA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14 2025, Pasha Tatashin wrote:

> Currently, clients of KHO must manually allocate memory (e.g., via
> alloc_pages), calculate the page order, and explicitly call
> kho_preserve_folio(). Similarly, cleanup requires separate calls to
> unpreserve and free the memory.
>
> Introduce a high-level API to streamline this common pattern:
>
> - kho_alloc_preserve(size): Allocates physically contiguous, zeroed
>   memory and immediately marks it for preservation.
> - kho_free_unpreserve(ptr, size): Unpreserves and frees the memory
>   in the current kernel.
> - kho_free_restore(ptr, size): Restores the struct page state of
>   preserved memory in the new kernel and immediately frees it to the
>   page allocator.

Nit: kho_unpreserve_free() and kho_restore_free() make more sense to me
since that is the order of operations. Having them the other way round
is kind of confusing.

Also, why do the free functions need size? They can get the order from
folio_order(). This would save users of the API from having to store the
size somewhere and make things simpler.

>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kexec_handover.h     |  22 +++++--
>  kernel/liveupdate/kexec_handover.c | 101 +++++++++++++++++++++++++++++
>  2 files changed, 116 insertions(+), 7 deletions(-)
>
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 80ece4232617..76c496e01877 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -2,8 +2,9 @@
>  #ifndef LINUX_KEXEC_HANDOVER_H
>  #define LINUX_KEXEC_HANDOVER_H
>  
> -#include <linux/types.h>
> +#include <linux/err.h>
>  #include <linux/errno.h>
> +#include <linux/types.h>
>  
>  struct kho_scratch {
>  	phys_addr_t addr;
> @@ -48,6 +49,9 @@ int kho_preserve_pages(struct page *page, unsigned int nr_pages);
>  int kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
>  int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
>  int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
> +void *kho_alloc_preserve(size_t size);
> +void kho_free_unpreserve(void *mem, size_t size);
> +void kho_free_restore(void *mem, size_t size);
>  struct folio *kho_restore_folio(phys_addr_t phys);
>  struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
>  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
> @@ -101,6 +105,14 @@ static inline int kho_unpreserve_vmalloc(struct kho_vmalloc *preservation)
>  	return -EOPNOTSUPP;
>  }
>  
> +void *kho_alloc_preserve(size_t size)
> +{
> +	return ERR_PTR(-EOPNOTSUPP);
> +}
> +
> +void kho_free_unpreserve(void *mem, size_t size) { }
> +void kho_free_restore(void *mem, size_t size) { }
> +
>  static inline struct folio *kho_restore_folio(phys_addr_t phys)
>  {
>  	return NULL;
> @@ -122,18 +134,14 @@ static inline int kho_add_subtree(const char *name, void *fdt)
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline void kho_remove_subtree(void *fdt)
> -{
> -}
> +static inline void kho_remove_subtree(void *fdt) { }
>  
>  static inline int kho_retrieve_subtree(const char *name, phys_addr_t *phys)
>  {
>  	return -EOPNOTSUPP;
>  }
>  
> -static inline void kho_memory_init(void)
> -{
> -}
> +static inline void kho_memory_init(void) { }
>  
>  static inline void kho_populate(phys_addr_t fdt_phys, u64 fdt_len,
>  				phys_addr_t scratch_phys, u64 scratch_len)
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index a905bccf5f65..9f05849fd68e 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -4,6 +4,7 @@
>   * Copyright (C) 2023 Alexander Graf <graf@amazon.com>
>   * Copyright (C) 2025 Microsoft Corporation, Mike Rapoport <rppt@kernel.org>
>   * Copyright (C) 2025 Google LLC, Changyuan Lyu <changyuanl@google.com>
> + * Copyright (C) 2025 Pasha Tatashin <pasha.tatashin@soleen.com>
>   */
>  
>  #define pr_fmt(fmt) "KHO: " fmt
> @@ -1151,6 +1152,106 @@ void *kho_restore_vmalloc(const struct kho_vmalloc *preservation)
>  }
>  EXPORT_SYMBOL_GPL(kho_restore_vmalloc);
>  
> +/**
> + * kho_alloc_preserve - Allocate, zero, and preserve memory.
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
> +void *kho_alloc_preserve(size_t size)
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
> +EXPORT_SYMBOL_GPL(kho_alloc_preserve);
> +
> +/**
> + * kho_free_unpreserve - Unpreserve and free memory.
> + * @mem:  Pointer to the memory allocated by kho_alloc_preserve().
> + * @size: The original size requested during allocation. This is used to
> + *        recalculate the correct order for freeing the pages.
> + *
> + * Unregisters the memory from KHO preservation and frees the underlying
> + * pages back to the system. This function should be called to clean up
> + * memory allocated with kho_alloc_preserve().
> + */
> +void kho_free_unpreserve(void *mem, size_t size)
> +{
> +	struct folio *folio;
> +	unsigned int order;
> +
> +	if (!mem || !size)
> +		return;
> +
> +	order = get_order(size);
> +	if (WARN_ON_ONCE(order > MAX_PAGE_ORDER))
> +		return;
> +
> +	folio = virt_to_folio(mem);
> +	WARN_ON_ONCE(kho_unpreserve_folio(folio));

This is what I meant in my reply to the previous patch.
kho_unpreserve_folio() can be void now, so the WARN_ON_ONCE() is not
needed.

> +	folio_put(folio);
> +}
> +EXPORT_SYMBOL_GPL(kho_free_unpreserve);
> +
> +/**
> + * kho_free_restore - Restore and free memory after kexec.
> + * @mem:  Pointer to the memory (in the new kernel's address space)
> + * that was allocated by the old kernel.
> + * @size: The original size requested during allocation. This is used to
> + * recalculate the correct order for freeing the pages.
> + *
> + * This function is intended to be called in the new kernel (post-kexec)
> + * to take ownership of and free a memory region that was preserved by the
> + * old kernel using kho_alloc_preserve().
> + *
> + * It first restores the pages from KHO (using their physical address)
> + * and then frees the pages back to the new kernel's page allocator.
> + */
> +void kho_free_restore(void *mem, size_t size)

On restore side, callers are already using the phys addr directly. So do
kho_restore_folio() and kho_restore_pages() for example. This should
follow suit for uniformity. Would also save the callers a __va() call
and this function the __pa() call.

> +{
> +	struct folio *folio;
> +	unsigned int order;
> +
> +	if (!mem || !size)
> +		return;
> +
> +	order = get_order(size);
> +	if (WARN_ON_ONCE(order > MAX_PAGE_ORDER))
> +		return;
> +
> +	folio = kho_restore_folio(__pa(mem));
> +	if (!WARN_ON(!folio))

kho_restore_folio() already WARNs on failure. So the WARN_ON() here can
be skipped I think.

> +		free_pages((unsigned long)mem, order);

folio_put() here makes more sense since we just restored a folio.

> +}
> +EXPORT_SYMBOL_GPL(kho_free_restore);
> +
>  int kho_finalize(void)
>  {
>  	int ret;

-- 
Regards,
Pratyush Yadav

