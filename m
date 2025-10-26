Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11EA4CCD1A5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 16:23:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A8C98E0171; Sun, 26 Oct 2025 12:23:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 359848E0150; Sun, 26 Oct 2025 12:23:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26FDF8E0171; Sun, 26 Oct 2025 12:23:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 12E548E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 12:23:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ACC9112A1FF
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:23:46 +0000 (UTC)
X-FDA: 84040786452.21.94C5759
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 236BD40009
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 16:23:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ED82mNNR;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761495825; a=rsa-sha256;
	cv=none;
	b=My7Oeo8nANUHiy9HGvMoB64imDqZu7R7bnmArA5h8wNJLQSsLVRj80sdmKT/y9iXIfE0UE
	Cetad7mCXpujhaVxqSCM5yBFHgx1QCZMYQrAI1onn00t6m9o/YrhIRSur+qq4waAlmLQEl
	9u50Q1uydawQ0EZsDSBhNZujSmcTwYY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ED82mNNR;
	spf=pass (imf27.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761495825;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xdotdwfiDsf0XBSSRErv+cEaOocplU74nYYkd5arT8o=;
	b=feg016SN+//mW9yfTnbwN23WcVVI0l2WlXOyF6jh3jIWJDQXtpQjweOExm30vDi3VZptwa
	Xu6cOBOLBhy4+sWYscPHRHdS8z+6rwB8y2hhHBOZ9euDLoAznMVZh7pWdSlHT7T70sqTJP
	by1ryo0UN8vwmGgmxE0eGm2qw7rcbsw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6849B60306;
	Sun, 26 Oct 2025 16:23:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EC36C4CEE7;
	Sun, 26 Oct 2025 16:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761495824;
	bh=IzIryL5ZzSIK5IAADXW8ppRRMG5QdtE1U1LqyYCn2mI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ED82mNNRqJ3jL9ehZj1qNyPphPq68PfaTZpFEelfjITAU4qGtuUKf/8h/2qFQbOTb
	 z1KR9ENADYHkDYhyQE6kcTPvpTGMdCXLpadop2cSDHl4+GXDg4PBoicMiNEMm93lql
	 VoiWY85vHidBbxkYTZ70BhkP/e8UPe+czQAAmn+DX+aBVknZC79AHLEzoG9ha0j+am
	 SCP54gQMgxT+XKxQYhkvv9+OywRKrIOC1wzvIFNuysd/RhrPoFyZJm2dOHpUU+R+w8
	 WeoTskL6dViCKt7nP6rDJodk39ucVwwiAZWczO/dN0uXB6SZ4GcR2uXwwiAVO5IZ5L
	 DXoHwdlQ8sxxg==
Date: Sun, 26 Oct 2025 18:23:35 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: akpm@linux-foundation.org, brauner@kernel.org, corbet@lwn.net,
	graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org,
	masahiroy@kernel.org, ojeda@kernel.org, pratyush@kernel.org,
	rdunlap@infradead.org, tj@kernel.org
Subject: Re: [PATCH v8 3/8] kho: drop notifiers
Message-ID: <aP5LB5NQ4lhhAA6Y@kernel.org>
References: <20251024161002.747372-1-pasha.tatashin@soleen.com>
 <20251024161002.747372-4-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251024161002.747372-4-pasha.tatashin@soleen.com>
X-Rspam-User: 
X-Stat-Signature: thw67fgy6c63x9hjrbgq99k1edmry7xc
X-Rspamd-Queue-Id: 236BD40009
X-Rspamd-Server: rspam09
X-HE-Tag: 1761495824-74003
X-HE-Meta: U2FsdGVkX1+wsI8rZFGz/XaM3/9fiTUINRrrqxhVFhM8gKOUmMEVcaw9zN8HSEPKsT5fRvvpNJ2+en5rWUVKHNwpRcf8LYpyduE4J/B20zbSkBstOpTOAmk50OQf1iRRQtZc3W+R5ZQ1SOhVRcB7vjWg+Q/Qjrt+mpDlrZIoy0T4tkugYj+JR3IOzc3r87q6KeRQkvb3M9LpLmvBGbXSzeKt+CFwIAmDerHWYqhIXzDuzSxWstZQIeVFLQzo/IoRTzDNNqeKkbjDJRGzQKG02rI0wkSRWMTlzOfoDFI3CphL6yR5J6X/qjnKrJBLNYnQ5cnkkI5rG+ow+22Xoe73l5YK4GhqBze7i3/+n/q4UZMygmHhZg2Xt688VJmjXvYgHXL6n/UCUpIF8vZwKwHEO96x2yOh6Gq/8/GaILqvIT3Jcn2twWBBZM5HI04wYH0CusoestkBfo4+GPq0uJv5p7nkhdAzAwVehsfch25S2P9XoAOaRjPA8EqUlbdtTbSNK8uNl5k9PHnHE6VvHTI87mJZUhbiJltSTd8qgflO0TV6hJK+4IVrTRTnE+F6OzwgOilRpZh1jHu8mu82IB/1DMCj1n6Z3CJ9DO1OXEE6Fg3jk4ZM5N83eEsrKoaglcmKzOmaLpG4w2DHRMPXRZigPk6jMSAHbpKtxDvPg1ibCiWZRZltYnmcQ83etsKPCs8B2H3teCHOwy94S6RtLMEzmVFxJx32koqpZ50cmrWoLQbQ/qAeqvZ7d+1ugzPAgnomD9EiS5Izb7Up3hdDmICP+XoW22fzIu3wE4DYpRGu1cOoz+sAkJ4VYA+yFO6qG3xVG8fgZo91LUCDUr83Z1q8YtfEeTqtzJaousDkBTnU0wtRdbl5RzMhx5COtfOBxDj0N5DOm1soadNVJRXbNsW0ZoJ6uyBjR7zbrjToyi4q7cF/klfmhdvNPWAmFImIzQNMCF16HoU4MryB32uRoJw
 DLfmiOi5
 C7yvtKnKrsBHyY2hbcmryN9E3NPtNcwJloEL0PEOciGc+hnIjFZsqNXRtdZ9LN75cRpdH+csbu//BK24sc4bZjB4lgJocqDaPe9LvtY4YAlN1lahAOQHUg+6lFk5WjRBrDDflUPtIUWPH9mNL3Rf3Cdyn9Y3t7PaaI9Ta3XSWNqYg+FTJ/exrM0ExUzN10DrUY+jiNRPUFdrJKte4zEm8gxZE/Om3kiROREQMfKwKiW7vPLJ9ln+YuN8055o6fOioMMEssVwRKpWOizd+mNBfgtuzcDi/oGTUdmEC2JkwXIYehnM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 12:09:57PM -0400, Pasha Tatashin wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> 
> The KHO framework uses a notifier chain as the mechanism for clients to
> participate in the finalization process. While this works for a single,
> central state machine, it is too restrictive for kernel-internal
> components like pstore/reserve_mem or IMA. These components need a
> simpler, direct way to register their state for preservation (e.g.,
> during their initcall) without being part of a complex,
> shutdown-time notifier sequence. The notifier model forces all
> participants into a single finalization flow and makes direct
> preservation from an arbitrary context difficult.
> This patch refactors the client participation model by removing the
> notifier chain and introducing a direct API for managing FDT subtrees.
> 
> The core kho_finalize() and kho_abort() state machine remains, but
> clients now register their data with KHO beforehand.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Co-developed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> ---
>  include/linux/kexec_handover.h   |  28 +-----
>  kernel/kexec_handover.c          | 166 +++++++++++++++++--------------
>  kernel/kexec_handover_debugfs.c  |  17 ++--
>  kernel/kexec_handover_internal.h |   5 +-
>  lib/test_kho.c                   |  33 +-----
>  mm/memblock.c                    |  62 +++---------
>  6 files changed, 126 insertions(+), 185 deletions(-)

> diff --git a/lib/test_kho.c b/lib/test_kho.c
> index 60cd899ea745..1c6c4ce83666 100644
> --- a/lib/test_kho.c
> +++ b/lib/test_kho.c
> @@ -120,6 +93,7 @@ static int kho_test_prepare_fdt(struct kho_test_state *state)
>  
>  	fdt = folio_address(state->fdt);
>  
> +	err |= kho_preserve_folio(state->fdt);

We should bail out here, no point creating an fdt if it won't be preserved.

>  	err |= fdt_create(fdt, fdt_size);
>  	err |= fdt_finish_reservemap(fdt);
>  
> @@ -131,6 +105,7 @@ static int kho_test_prepare_fdt(struct kho_test_state *state)
>  
>  	err |= fdt_finish(fdt);
>  
> +	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));
>  	if (err)
>  		folio_put(state->fdt);
>  
> @@ -203,7 +178,7 @@ static int kho_test_save(void)
>  	if (err)
>  		goto err_free_folios;
>  
> -	err = register_kho_notifier(&kho_test_nb);
> +	err = kho_add_subtree(KHO_TEST_FDT, folio_address(state->fdt));

This is the second time we add the same subtree, isn't it?

>  	if (err)
>  		goto err_free_fdt;
>  
> @@ -326,7 +301,7 @@ static void kho_test_cleanup(void)
>  
>  static void __exit kho_test_exit(void)
>  {
> -	unregister_kho_notifier(&kho_test_nb);
> +	kho_remove_subtree(folio_address(kho_test_state.fdt));
>  	kho_test_cleanup();
>  }
>  module_exit(kho_test_exit);
> diff --git a/mm/memblock.c b/mm/memblock.c
> index e23e16618e9b..e3bef9b35d63 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
>  static int __init prepare_kho_fdt(void)
>  {
>  	int err = 0, i;
> +	struct page *fdt_page;
>  	void *fdt;
>  
> -	kho_fdt = alloc_page(GFP_KERNEL);
> -	if (!kho_fdt)
> +	fdt_page = alloc_page(GFP_KERNEL);
> +	if (!fdt_page)
>  		return -ENOMEM;
>  
> -	fdt = page_to_virt(kho_fdt);
> +	fdt = page_to_virt(fdt_page);
>  
>  	err |= fdt_create(fdt, PAGE_SIZE);
>  	err |= fdt_finish_reservemap(fdt);
> @@ -2499,7 +2464,10 @@ static int __init prepare_kho_fdt(void)
>  	err |= fdt_property_string(fdt, "compatible", MEMBLOCK_KHO_NODE_COMPATIBLE);
>  	for (i = 0; i < reserved_mem_count; i++) {
>  		struct reserve_mem_table *map = &reserved_mem_table[i];
> +		struct page *page = phys_to_page(map->start);
> +		unsigned int nr_pages = map->size >> PAGE_SHIFT;
>  
> +		err |= kho_preserve_pages(page, nr_pages);
>  		err |= fdt_begin_node(fdt, map->name);
>  		err |= fdt_property_string(fdt, "compatible", RESERVE_MEM_KHO_NODE_COMPATIBLE);
>  		err |= fdt_property(fdt, "start", &map->start, sizeof(map->start));
> @@ -2507,13 +2475,16 @@ static int __init prepare_kho_fdt(void)
>  		err |= fdt_end_node(fdt);
>  	}
>  	err |= fdt_end_node(fdt);
> -
>  	err |= fdt_finish(fdt);
>  
> +	err |= kho_preserve_folio(page_folio(fdt_page));

When looking at the end result after patch 8 it becomes a total mess.
Let's move this right after the allocation and make it

	err = kho_preserve_folio(page_folio(fdt_page);
	if (err)
		goto err_free_fdt;

> +
> +	if (!err)
> +		err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);

and replace this pattern with usual kernel

	if (err)
		goto err_free_fdt;

	err = kho_add_subtree(MEMBLOCK_KHO_FDT, fdt);
	if (err)
		goto err_free_fdt;

so that only fdt operations will be a part of 

	err |= fdt_<function> 

sequence.

>  	if (err) {
>  		pr_err("failed to prepare memblock FDT for KHO: %d\n", err);
> -		put_page(kho_fdt);
> -		kho_fdt = NULL;
> +		put_page(fdt_page);
>  	}
>  
>  	return err;
> @@ -2529,13 +2500,6 @@ static int __init reserve_mem_init(void)
>  	err = prepare_kho_fdt();
>  	if (err)
>  		return err;
> -
> -	err = register_kho_notifier(&reserve_mem_kho_nb);
> -	if (err) {
> -		put_page(kho_fdt);
> -		kho_fdt = NULL;
> -	}
> -
>  	return err;
>  }
>  late_initcall(reserve_mem_init);
> -- 
> 2.51.1.821.gb6fe4d2222-goog
> 
> 

-- 
Sincerely yours,
Mike.

