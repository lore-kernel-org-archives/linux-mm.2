Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84A01D2ECF7
	for <linux-mm@archiver.kernel.org>; Tue, 20 Jan 2026 13:03:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D859F6B03E9; Tue, 20 Jan 2026 08:03:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D33266B03EA; Tue, 20 Jan 2026 08:03:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69986B03EB; Tue, 20 Jan 2026 08:03:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B3B5D6B03E9
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 08:03:57 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 59E101AE4FE
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:03:57 +0000 (UTC)
X-FDA: 84352359714.16.84FD8E3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id AF58FC000B
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 13:03:55 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IjSYQTxZ;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768914235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6HK2XDqvr0szkHQ7whJ4JBYHd5Ew9QIOfMDRmAhXuEc=;
	b=PhmSw3YvVcwuG5airrFw1J00nSht02LqDz35B7W7eMZc4SmKZliCgJlYKNifau6F7EJXG1
	O+JiB6HYX405Lk1lhLiJmO6I42iQ/1OSpWHp9H01ZcHl/qYBM0gS14IraMq0ZPl2a8Kr/m
	pKD+ihuojmvjw2tDD8QPYx/AAD2Zmyk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768914235; a=rsa-sha256;
	cv=none;
	b=5xultNP2FswRje5/lzpw7h3dnX7DKRBAErPuco/WqdYw1AE+ewp2glPQgiHjA04R+e2Z4t
	wPtJycasvIWXxsnJ7ECvAecZ4tivzYffYYFyHgjzaj2CCt2SlMlxU4jnO99YdxtdQ94jlw
	PpbrgMqO1M+dNJFZSnC2GyXwCB2s3Ys=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IjSYQTxZ;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D49AE60018;
	Tue, 20 Jan 2026 13:03:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8C6FC16AAE;
	Tue, 20 Jan 2026 13:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768914234;
	bh=VjNsk+rGW49szc0ZaDC/PxUEhkP0A5D50M/kBU1Njlc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=IjSYQTxZO9zOdD8dgFokigXt6el1iimLLAw18aUnWCJHji5YWJKX+76HBlEkC0+nm
	 shaw36qPYg7q8aymOeUc3lZgVkWU+ZuL3raurQsht2qGETyMlHKnqwl1f/1l2xOSE7
	 iiEEMdG7DRfOK6PIa5SEklmz+dMki95fKZ3WxKkzgQ9ShoxwBZ4bDZveME7VZL4SoY
	 OgiNyNxxlSRXkBaBmCB5/xXtUVHl/OrU5jFCwY1TWAblP/9hShU2Xm5skNyRpr0Aa9
	 6aK5NAYPw03LVj7OBXyWXzxMYZ1YG7auxZS7kGxuTX3RoBC9pZ7UpoE/YXaPqlD1pQ
	 aEr2k0DRRsGLg==
Date: Tue, 20 Jan 2026 15:03:48 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Suren Baghdasaryan <surenb@google.com>
Subject: Re: [PATCH v2 1/2] kho: use unsigned long for nr_pages
Message-ID: <aW99NEjHAZ8n-uwW@kernel.org>
References: <20260116112217.915803-1-pratyush@kernel.org>
 <20260116112217.915803-2-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260116112217.915803-2-pratyush@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AF58FC000B
X-Rspam-User: 
X-Stat-Signature: 6g8fzg1cny56f1g5ufoq9afhdfx3noj3
X-HE-Tag: 1768914235-530790
X-HE-Meta: U2FsdGVkX19B9RoNR+e1RWg0/HPeheqRblK+d1upFuh2icwq2SwoMooAqflaJKkqqq46yAiASqgsxNIeA+/YhaImaHJzVnYoKlxnnhjFetycQ8Zggb3mm8yUNwJevHG4WHbLOHoGD2LpFnBtkqtu3E4O5WCM8vwu3gZrmHEfV/fPQ4b+ysbdOTwDrViduyQ89e5C9jxqxlcwp6pzjujqwz/WcVlluCtze3A7Vu6NIZi1hepGQwP2kkCBLOcyv45mRkwli4NfZTIXB5cxUDE2rNzt+Xd0ksekseIA0IPOhr9GXzKBYk3Ft/yYF0jvhJu77Vh3kM8tAM2g5s6dKp+6oReSKaPQfonIGn/vXTHP67swonfQcmkn5EiZVV4WVn0PtIb5Tw7wyaY+srB/3D1ccFidxIfXk1KRlneZJ4NsGSE0FyemplYh8+76xV5jbeD6BGbsMvOBJTYpHHYPVHqX8ReeB0skN245sni3fPv5t6haNTqXPGhjOBOlj4dRYgWEhmxXcugmLG0UJjZgpdDUgLsPrxptUwbk6EToi97yotMXsoEjGUrhE25Q84qmr+peCtQyHutQE7aYITOiitNbV9Gk7p2iN0iZXZwJ5dhv5aLiCDDUafflT6Zr4a+lMW8EpRqO9+vu8QR8P2mXlOHkemaA95wgJ0E3EI1uiNKXP9oCnKCWqCsLdrKTrglKOHQSdY+DHLk1uHCHIR4cFWUthUn/fY9/k5qIugXV9RsE0VIOtSv/4vDJENv4Hvv2Ra6F3IdKWWHsVw/UzY2Ev6Zz/Eq6BmWaZFtywPxYuX7LedpaY1Yai2l8xYRGlYwtFhrvk2tI+H4SpLnGBfl0f02Q73IBECEqNW/qVeCxpKuLgtBi8cxQWAVKiW7yB+jyJiMxlykbzAfApau6kU5ingUauP92xKTQaFc6CETiYNaGlug60cyrZeB8gbqo6MzD4jQNAQn+UWtHEkAZ0YPBi6z
 GmtmneWD
 quqRCvQx/pAp6co0JnC4NesJ7qwD8npTaBHbbdo5hwSJBss/8YooRBExWTdCMpvKWg6ZqeiQrayC4C/5PCrXUlkEwaw5KHYtZ9iQDvsAwx9fuD7w+w97rmIYwHxihjD/p4MNqxg8v1k/77TN8gSMFHYFlq22LdqjBsNGdeb2VNYk3uPOERgyRhTDznk3nMXkh5mU9tAlTmgX0FxVck3MJWVrhofVqpTsIdwYO73CESPY8+67/344jcekd7IWkM3Gi4Jz1vPTYORXp/QW/n6OEStaNrsFxL/5uXfm65R1DJu9nSFDoyMo0raVrGn7zpUueSZP/+ir9J9JTDE445yGtsd5OSkSAkbcNKsRz7PwrCDx9QcviM5xpBuH4j9+6yfmT0DGQ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 16, 2026 at 11:22:14AM +0000, Pratyush Yadav wrote:
> With 4k pages, a 32-bit nr_pages can span up to 16 TiB. While it is a
> lot, there exist systems with terabytes of RAM. gup is also moving to
> using long for nr_pages. Use unsigned long and make KHO future-proof.
> 
> Suggested-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> Signed-off-by: Pratyush Yadav <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> 
> Changes in v2:
> - New in v2.
> 
>  include/linux/kexec_handover.h     |  6 +++---
>  kernel/liveupdate/kexec_handover.c | 11 ++++++-----
>  2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/include/linux/kexec_handover.h b/include/linux/kexec_handover.h
> index 5f7b9de97e8d..81814aa92370 100644
> --- a/include/linux/kexec_handover.h
> +++ b/include/linux/kexec_handover.h
> @@ -45,15 +45,15 @@ bool is_kho_boot(void);
>  
>  int kho_preserve_folio(struct folio *folio);
>  void kho_unpreserve_folio(struct folio *folio);
> -int kho_preserve_pages(struct page *page, unsigned int nr_pages);
> -void kho_unpreserve_pages(struct page *page, unsigned int nr_pages);
> +int kho_preserve_pages(struct page *page, unsigned long nr_pages);
> +void kho_unpreserve_pages(struct page *page, unsigned long nr_pages);
>  int kho_preserve_vmalloc(void *ptr, struct kho_vmalloc *preservation);
>  void kho_unpreserve_vmalloc(struct kho_vmalloc *preservation);
>  void *kho_alloc_preserve(size_t size);
>  void kho_unpreserve_free(void *mem);
>  void kho_restore_free(void *mem);
>  struct folio *kho_restore_folio(phys_addr_t phys);
> -struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages);
> +struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages);
>  void *kho_restore_vmalloc(const struct kho_vmalloc *preservation);
>  int kho_add_subtree(const char *name, void *fdt);
>  void kho_remove_subtree(void *fdt);
> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
> index 9dc51fab604f..709484fbf9fd 100644
> --- a/kernel/liveupdate/kexec_handover.c
> +++ b/kernel/liveupdate/kexec_handover.c
> @@ -222,7 +222,8 @@ static int __kho_preserve_order(struct kho_mem_track *track, unsigned long pfn,
>  static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  {
>  	struct page *page = pfn_to_online_page(PHYS_PFN(phys));
> -	unsigned int nr_pages, ref_cnt;
> +	unsigned long nr_pages;
> +	unsigned int ref_cnt;
>  	union kho_page_info info;
>  
>  	if (!page)
> @@ -249,7 +250,7 @@ static struct page *kho_restore_page(phys_addr_t phys, bool is_folio)
>  	 * count of 1
>  	 */
>  	ref_cnt = is_folio ? 0 : 1;
> -	for (unsigned int i = 1; i < nr_pages; i++)
> +	for (unsigned long i = 1; i < nr_pages; i++)
>  		set_page_count(page + i, ref_cnt);
>  
>  	if (is_folio && info.order)
> @@ -283,7 +284,7 @@ EXPORT_SYMBOL_GPL(kho_restore_folio);
>   *
>   * Return: 0 on success, error code on failure
>   */
> -struct page *kho_restore_pages(phys_addr_t phys, unsigned int nr_pages)
> +struct page *kho_restore_pages(phys_addr_t phys, unsigned long nr_pages)
>  {
>  	const unsigned long start_pfn = PHYS_PFN(phys);
>  	const unsigned long end_pfn = start_pfn + nr_pages;
> @@ -829,7 +830,7 @@ EXPORT_SYMBOL_GPL(kho_unpreserve_folio);
>   *
>   * Return: 0 on success, error code on failure
>   */
> -int kho_preserve_pages(struct page *page, unsigned int nr_pages)
> +int kho_preserve_pages(struct page *page, unsigned long nr_pages)
>  {
>  	struct kho_mem_track *track = &kho_out.track;
>  	const unsigned long start_pfn = page_to_pfn(page);
> @@ -873,7 +874,7 @@ EXPORT_SYMBOL_GPL(kho_preserve_pages);
>   * kho_preserve_pages() call. Unpreserving arbitrary sub-ranges of larger
>   * preserved blocks is not supported.
>   */
> -void kho_unpreserve_pages(struct page *page, unsigned int nr_pages)
> +void kho_unpreserve_pages(struct page *page, unsigned long nr_pages)
>  {
>  	struct kho_mem_track *track = &kho_out.track;
>  	const unsigned long start_pfn = page_to_pfn(page);
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

