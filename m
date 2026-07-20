Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74BC7C44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 16:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2426B008C; Mon, 20 Jul 2026 12:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4935B6B0093; Mon, 20 Jul 2026 12:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B53F6B0098; Mon, 20 Jul 2026 12:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CE2E6B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:57:28 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8C1631C0210
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:57:27 +0000 (UTC)
X-FDA: 85009760934.07.94CCFA0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id CFD8714000A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:57:25 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kyHApj0d;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784566645;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nzgvdGaBXPxbJtRAgq9ARlle9808crpesqVqNAEMGi8=;
	b=RFK4uNXjcATbzWkf4vBdlair2bHpgTX6BFh1BaG0fILcDiZtix6tI0IpUrZ5mjGv9Q9NzW
	b43SQiPWcQAtFTmTZtJnk+PNFu5HjjSUAoxHfCsyjaFbbngg9VacNikpq/MO+5GPj4hQfx
	mG3tiTdPu65QOg+C1F5nBXkaFVKhlRo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784566645;
	b=IWIavhS0RHrg1oisAuaycui4/s0bOiLk3EmSnKT7qnV8uysZUcOn+gt+1pmgkZ9xBmdNO3
	5f7gPi4eX+r/ZT7gwlXrGr4ZGFbvQEGGg2iApHMRaQwgyPP/HvIVL49Wx+M9bmvHxELxM5
	Z/q3e7DzJ1v8umEd4+rx85j8rFXMneA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kyHApj0d;
	spf=pass (imf23.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BA583438CA;
	Mon, 20 Jul 2026 16:57:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5402C1F000E9;
	Mon, 20 Jul 2026 16:57:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784566644;
	bh=nzgvdGaBXPxbJtRAgq9ARlle9808crpesqVqNAEMGi8=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=kyHApj0dUNBqwBC58GbBTZLUb4b4dcFlgiNJZR2Te6/T04N1HJDmajqDNUHSQQ+vs
	 V3qzHdcvj/B+1Rg4ZYNYn/xYejq5pyqykcOAaenZ6N+xOSmjXycxZl2yB4TNOGQe4R
	 xkY/2GWfR/t2f1qyssFWXiDmZ7HfU1ej64mFuA7G5Wc28h0ezEMRjWF3j98Txi5j6u
	 dyrnKVeViNjML3XQYHToDSb58x9g5ckHkvH6xCWhkgD6TWlDoPdk7ieRFLSacZMmqJ
	 ntBWJMpu0/Ahm42Q7lyZJcSwpSHloo85X28s0ZFrQRds7NclUZaMPmZo4324Y8faVV
	 WDsUk2+oKPzoQ==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [RFC PATCH v2 2/2] kho: Introduce preserve/restore APIs for
 unsplit pages
From: Mike Rapoport <rppt@kernel.org>
To: Pranjal Shrivastava <praan@google.com>
Cc: Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260713204935.3069000-3-praan@google.com>
References: <20260713204935.3069000-1-praan@google.com>
 <20260713204935.3069000-3-praan@google.com>
Date: Mon, 20 Jul 2026 19:57:15 +0300
Message-Id: <178456663513.143128.14871307686052703561.b4-review@b4>
X-Mailer: b4 0.16-dev
X-Stat-Signature: qe9nqyeb64wgtuq1xf8qimre4spixtm7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CFD8714000A
X-HE-Tag: 1784566645-850198
X-HE-Meta: U2FsdGVkX1+KyUyMLsLrJ6V0k2tlcZSyn67yHHWOhxO9rJ7OUeZjC2CcWsFcqNAtOFpCY62ltx+km8fK12BJz3y2DWIQz5kjOeuZCMtepTdEr4w3PRKcY78OO/i98PE0OBCK3MGcnpVkqrR6TfOY+sG2/kR7PLj5sy7ckQu2cSN7lMrSW6TF3ondbrDebsudprjV3TNcoGEbaZfX7DKq90ExkSD4bLjMkL9SBWxvPeGSBS1JcujR5byQZHFGtsJK5zu0iqfIQfpOfzEabPdsiOcbQhXhqCdonEyi1s2ERG90bLhlv4WoHpi2TISTldwrk2W7hto3mpMrNY96DMaQkJQdHzh/fBZuIGBlDCNMVtOiLi0dZ6Pt7SVLJppuF7AH2zRkpI1qTZk05iSoOeJr2ukSqiDGXxNX+fzNQmZvAK/x5HFPGD4D4fY77frMKQEQI3YMcJCNttlthriiGqiS7YNRivZH1oyHwZwWFDRVF9QQhT5SELYQf2CTQbo3vxxyaZCWd0Aii0WX6SyAJK5iprcLjiDGYsY75bsUKOg9XaXTGxpOrNE1rI3Nae/Z3lDp9wP+aFa3tRgeXHWse+HrI4R8vsl6ezwfCh5KA/9P9t2tmViCBt2u/6BnJAHpPNLYmiXdGEF6pbv1GUfBylvQ8fpicQfR0nRvQv1sTbgRP6Obhk54t8pE5k+wgCRw/B66T/xghVoRzypcKfHaq/Ak5jyX9OQ8QB2/Bbwf/DRfOdypaXg3W1NjaQtzple1GT5/B3/Zmn0du6+BkKaedx2R1AjfyJozN8YO2umunPfNZSNBsiUZhMFmI+IK5sXIe/GtauhaVbZtCCBbnGvIBvlma9oo8SqMrs23elrFg/boNu885CO8XqZtnZyNKjvhsbfGhpqNQ7e84zT1BIgxcfOv/cZrWa5KekCfIk9mkKRfcUpH86URObce/HIJLIAnGIuWnZzEw/BDlDl6HlW2WeJ
 lzmEy/UD
 xmcEGDuaIxUrnYVV1FHc1lbzjm5G17J2ect7Z0gmKqSJ11TYQgojOnAjoeNXq5MlGgz6DA+OKTUX5XsSSZmen5r62ewqJc98aytp+njZmCogFTIns8e0APqq9pXbY6XNPEfaRO1AvNHEB1yjjphf6Fua7uExovj1ZA0jh83XQW5MJ/Gc/rJe1uI0TirWtm9JOfJ2k3+HEeHkbMW7ho6i5UsgH7/Hw5IUHhdbwgddbqavuratQc/sbANqFJA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> The current KHO page preservation APIs (e.g. kho_preserve_pages) assume
> that multi-page blocks are split into independent 4KB pages during
> restoration. This is incompatible with high-order non-compound pages,
> such as DMA buffers, which must be restored with tail pages having a
> zero reference count.
> 
> Introduce explicit preserve and restore APIs for unsplit pages,

                                 high-order non-compound ^

> which preserve and restore a high-order page block as a single unit,
> applying a refcount of 1 to the head page while leaving tail pages at 0.
> Rename the existing internal helper to __kho_restore_page().
> 
> Signed-off-by: Pranjal Shrivastava <praan@google.com>
>
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 8968c56d2d73e..6e2c75b16209c 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -22,6 +22,8 @@ bool is_kho_boot(void);
>  
>  int kho_preserve_folio(struct folio *folio);
>  void kho_unpreserve_folio(struct folio *folio);
> +int kho_preserve_page(struct page *page, unsigned int order);
> +void kho_unpreserve_page(struct page *page, unsigned int order);
>  int kho_preserve_pages(struct page *page, unsigned long nr_pages);
>  void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
>  int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
> @@ -30,6 +32,7 @@ void *kho_alloc_preserve(size_t size);
>  void kho_unpreserve_free(void *mem);
>  void kho_restore_free(void *mem);
>  struct folio *kho_restore_folio(phys_addr_t phys);
> +struct page *kho_restore_page(phys_addr_t phys);
>  struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
>  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
>  int kho_add_subtree(const char *name, void *blob, size_t size);
> @@ -65,6 +68,13 @@ static inline int kho_preserve_pages(struct page *page, unsigned int nr_pages)
>  
>  static inline void kho_unpreserve_pages(struct page *page, unsigned int nr_pages) { }
>  
> +static inline int kho_preserve_page(struct page *page, unsigned int order)
> +{
> +	return -EOPNOTSUPP;
> +}
> +
> +static inline void kho_unpreserve_page(struct page *page, unsigned int order) { }
> +
>  static inline int kho_preserve_vmalloc(void *ptr,
>  				       struct kho_vmalloc *preservation)
>  {
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 07f6f453cd69d..43ae3e2de5da2 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -393,7 +393,7 @@ static void kho_init_folio(struct page *page, unsigned int order)
>  		prep_compound_page(page, order);
>  }
>  
> -static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
> +static struct page *__kho_restore_page(phys_addr_t phys, bool is_folio)
>  {
>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
>  	unsigned long nr_pages;
> @@ -432,12 +432,44 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>   */
>  struct folio *kho_restore_folio(phys_addr_t phys)
>  {
> -	struct page *page = kho_restore_page(phys, true);
> +	struct page *page = __kho_restore_page(phys, true);
>  
>  	return page ? page_folio(page) : NULL;
>  }
>  EXPORT_SYMBOL_GPL(kho_restore_folio);
>  
> +/**
> + * kho_restore_page - restore a higher-order unsplit page block.
> + * @phys: physical address of the first page.
> + *
> + * Restore a higher-order unsplit page block that was preserved with
> + * kho_preserve_page().
> + *
> + * Return: the head page on success, NULL on failure.
> + */
> +struct page *kho_restore_page(phys_addr_t phys)
> +{
> +	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> +	unsigned long nr_pages;
> +	union kho_page_info info;
> +
> +	if (!page)
> +		return NULL;
> +
> +	info.page_private = page->private;
> +	if (WARN_ON_ONCE(info.magic != KHO_PAGE_MAGIC))
> +		return NULL;
> +
> +	nr_pages = (1UL << info.order);
> +	page->private = 0;
> +
> +	kho_init_unsplit_pages(page, info.order);
> +	adjust_managed_page_count(page, nr_pages);
> +
> +	return page;

Hmm, it copies a lot from __kho_init_page().
We should keep the common part of order-0 page/folio/high-order page
initialization in a single place.

-- 
Sincerely yours,
Mike.


