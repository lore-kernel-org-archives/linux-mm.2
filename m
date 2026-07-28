Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 979B4C54F4C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 14:21:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FBD66B007B; Tue, 28 Jul 2026 10:21:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D3B86B0088; Tue, 28 Jul 2026 10:21:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C5A66B008A; Tue, 28 Jul 2026 10:21:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D3BEC6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 10:21:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4105D403B8
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:21:23 +0000 (UTC)
X-FDA: 85038398046.28.AAA6829
Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8B3D040011
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:21:20 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="Uv0l70G/";
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785248481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZcNWBxahuwKCE/IvTx/lMrMdjhnO/GCiW5lbVkdZ3aM=;
	b=jQuY7rY+mjHScilwhjatJCbhMXe5YRahhPtAyy3PbnXt0kUu/OYfDLz1qY1Xc3I6eH+Hf8
	aP6knYHeKzBuz9cTG9EVSQ3yOcNwsCID7zI60VUc5SJ0Ve4t2eUclL+SMuWfVSIjqKmqgo
	zftDaIWGQl1M4Nv8vuXj4Pz7TfbT3vE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=desiato.20200630 header.b="Uv0l70G/";
	spf=pass (imf07.hostedemail.com: domain of peterz@infradead.org designates 90.155.92.199 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785248481;
	b=QfJZhZVBnAUNR3zdmcK4CtaF4hj398EqU8DGEU9ZDMXUaaEvN/d5CrF5CiY54UXgIT6WA8
	/ZmMXkD73Y0ijU9rbXtqlP7WqI8SOF/+DcJnIMAtjtVGUFXIqA424izgGZ90aJWriOK6Hc
	89ac3ODUWL/rbPI7F2xw5i8QgrrhnEY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=ZcNWBxahuwKCE/IvTx/lMrMdjhnO/GCiW5lbVkdZ3aM=; b=Uv0l70G/RQc8iY7YKLRhWWcAgH
	egIjbftZ8rc+/7md8Xpm9oA6zpCBifwIpPHNbC6vAniqiaKMB6qQrapfPZTfi3sEttrWrCs/EPuVm
	YBXFYu+3Z9CIiO0z6G0UIVDB79aXzzt/yGQmdhaF0C3qNu4JscW4jK5nkuPyVWLC375tCt12IM1hq
	o6dRYDya2SvFaJq5ea5696WbU8d/R2dHOMrRZJCq89sd6hmxGQdDV3YXY5QQ+CR1F1HnyrVfCypjb
	9+OvYZg91bL6FrTW+xe3BN8luztvJ06ph6hsyw/MagpQWCHvuY/1ThxQX/Zeo7pn+SQ5qVo2KKH19
	FoThB4sA==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.2 #2 (Red Hat Linux))
	id 1woigA-000000050iu-0Nvt;
	Tue, 28 Jul 2026 14:21:10 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id E5EFD300969; Tue, 28 Jul 2026 16:21:08 +0200 (CEST)
Date: Tue, 28 Jul 2026 16:21:08 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <20260728142108.GW751831@noisy.programming.kicks-ass.net>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8B3D040011
X-Stat-Signature: n95n3oekg8punjx9kjig68t1p3ownjy3
X-HE-Tag: 1785248480-238461
X-HE-Meta: U2FsdGVkX19HjTOs3GByZFpV+qyjJ6BBguUUaV/EpUFEDt+WhxjYCIGgfgR3HvODXa1a6qD6h3nPXtDyXjvRTzjQG2LVHSBDq4WYlw1fN8DSFxOuI8oXmi9ECutu5xHEnKc/vbjMYf9fz9gbzP1VEJ26ruhFjT0QuQ8Pqey3/lpHd5p7qYCV43x1rrWKCNijttyZxosvRRSOGr75UZKisp4RZnRFAsq341q+LZU4c7e52Mwk5dPKHdEeTnc3UJETqgiztacIFNDuXYI1DsotXJi6ZJQkUiN8hziaPITVHSD6vPNK+XfeF7hSWN4y9dbHSedhT3+nrHAUPMC/SqBXy1beqE6cE+Yb6/xVlbdC2UZEvm5f1Ec4BStPMBn7LzP6F/VYnS7hzD6QBCT0lHt7jvJ6fazl2EGuGjz9pydxDM9AM/hItjubpCTNxKoWnkH7xILvPyPyncjxf1m/W0D8XyW9H9dHFk/2mjBk+GTNOD4EkpUWE0dCXp3ZtfFE6bwkkr8U9CGya7jtrpdhSEakAuQgLdU4zizHpbCmR/+BUicixgBujO7GGpH12Qc4aHv+SwyiSFxNc2e5Ew//MuqM04pOhOP3BKBc4NI76Klf3KWKxOuClbCgMzIL7Mz1C9HpJYxweoeq8WD2BtHcZw/2hvWs37mkj53Fylue5fe7Zx1xLi4WiRUBb4IXmfzFpauGGvnSA6u9pXh6o6h3hAlvJ5PcgfmQ4unzzXMW4ZdfgUzVurhujt+XhsksXwRRSiBJmDMKfovfy9OFAz1i7ZUtzdVMmZZkas/VKFeI0jfR4ca8uHzry49GsnFrWhxFWgo6KeD/J9cONPcC3f2msZFsElRyxbt6v5jj0esDEhcRXNc0C1kwwKAu5LxfPDPiPraSWXMafWIYNkp1SzMrP1f76WZRXCgLd5JHU7q27jyz+4OJHZfISMfiCZ0pD1M9dE5FfEn3rpz03KHLZyBuRzr
 UZ8L0XVK
 rHTaWi0RNI9HqIfWqec44XggADKDANl8ZnjFYMVxd2nKYJLNGGDB7m6/gXy0LsNcce3wSKEUyvC1G6x0KrN+jXwBS+6QW67JIGUqGKK5TnjaVCAcMX3i+3nrspc/J42fyaxpJrav5pfIfwrFNbaToefFrrHCBtekvLtulaGRUxh8UlDB6ajoJpYSt6pgqXyw33T1iVevnXvnO7OFp69knvUwyAnjjXYRt99AxXjeT/9ZH5XS31UCmLusUd/0EexaYAm41R+8/a8BNpluV4OFz1mFs31CvpR9XQV4X7ZYxu89HxX06c2ddujbG+gLtrIWds+SFkCFDM52Awcmf9IT5MocjpnrtSU4IA0r41WDw+hxx5WlXWNLy9suPz9+WvwhHQt/j
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:07:44PM +0300, Mike Rapoport (Microsoft) wrote:
> The splitting and merging of kernel page table mappings between small and
> large is protected by cpa_lock.
> 
> Commit 5fce67641a3e ("x86/mm/pat: Don't gate cpa_lock on
> debug_pagealloc_enabled()") disabled gatig of cpa_lock on
> debug_pagealloc_enabled() to simplify the code presuming that skipping
> the lock when debug_pagealloc_enabled() was an optimization.
> 
> However Lorenzo Stoakes notes that:
> 
>   __kernel_map_pages() can be called from irq context:
> 
>   < GFP_ATOMIC context >
>   kfree() or whatever
>   -> ...
>   -> __free_pages_prepare()
>   -> debug_pagealloc_unmap_pages()
>   -> __kernel_map_pages()
>   -> __change_page_attr_set_clr()
>   -> cpa_lock spins [irqs off]
> 
>   So you're spin locking in irq context here, which is probably not a
>   good idea.
> 
> It would be possible to unconditionally use spin_lock_irqsave() and
> spin_unlock_irqrestore() but that would complicate locking rules even
> more.
> 
> Restore gating of cpa_lock of debug_pagealloc_enabled(), but instead of
> putting the open-coded condition
> 
> 	if (debug_pagealloc_enabled())
> 
> before every lock and unlock operation, wrap the condition and the
> locking operation into cpa_lock() and cpa_unlock() helpers.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
>  arch/x86/mm/pat/set_memory.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index b1e780a465b5..4c8922695fd3 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -65,8 +65,25 @@ static const int cpa_warn_level = CPA_PROTECT;
>   * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
>   * stale large tlb entries, to change the page attribute in parallel to some
>   * other cpu splitting a large page entry along with changing the attribute.
> + *
> + * When debug_pagealloc_enabled(), page attributes could be changed in atomic
> + * context that would warrant disabling IRQs. But since debug_pagealloc always
> + * uses 4k pages in the direct map there are no races for splits and collapses
> + * and locking can be just skipped altogether.
>   */
> -static DEFINE_SPINLOCK(cpa_lock);
> +static DEFINE_SPINLOCK(_cpa_lock);
> +
> +static inline void cpa_lock(void)
> +{
> +	if (!debug_pagealloc_enabled())
> +		spin_lock(&_cpa_lock);
> +}
> +
> +static inline void cpa_unlock(void)
> +{
> +	if (!debug_pagealloc_enabled())
> +		spin_unlock(&_cpa_lock);
> +}

There was already a patch merged that removed the shole debug_pagealloc
exception. Is that not better?

