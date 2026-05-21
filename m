Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE9ACD5BA4
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 09:39:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91976B008A; Thu, 21 May 2026 05:39:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C431E6B008C; Thu, 21 May 2026 05:39:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59466B0092; Thu, 21 May 2026 05:39:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0C066B008A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 05:39:45 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 565628D863
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:39:45 +0000 (UTC)
X-FDA: 84790929930.21.0468B16
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id A7003140010
	for <linux-mm@kvack.org>; Thu, 21 May 2026 09:39:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNMSiboc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779356383;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zfwp4PpwL9D+jnoLOXIbwxG21F+nlkYoKpWMPOJkxso=;
	b=LkSVF4JSa13lpgasDvmwyYJDWRecia36N2dUPirBE/MYBlR+U4U/FLloplFKfTVny7Z9vI
	4qfwpj6VY691NrzJvPeyu96Ke0Lv2CGAe4n//XI1jnPjpeS1wk1al8CRaEfkqo/YWrqxeK
	c/cHddeCYJupRm4CWF0ygrRDJwhkb6c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779356383; a=rsa-sha256;
	cv=none;
	b=JYKpzfOQibHX3bHwxEp/kR/WnTphcgybsiAREnCkES4+zysiwi/4gV37zsjtQiN0fQz73x
	ir+5QCap16cz7WA6DCYBCAl0Uml3ZisKu5EsTOgiz8wQ4K2p5a2DavMdd+MRLvIpOYsCyc
	VcRMBkXA4m7IQsPU6Rh3p3vDqL8LWUA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNMSiboc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B7755405D2;
	Thu, 21 May 2026 09:39:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48F161F000E9;
	Thu, 21 May 2026 09:39:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779356382;
	bh=zfwp4PpwL9D+jnoLOXIbwxG21F+nlkYoKpWMPOJkxso=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=KNMSibocozxsOEboPUh9RzwdH6/04r2b9CNhhHRp61mEbqeBdpDKtdBsxnR29HH2p
	 T8NW7atvdWqQcoP61SdwHnZT0VOORIr3HYAfhHJ4efdT1pTPfZBLgmncH4/5Dt9Yc/
	 GvrIS5FzN/06GoXdVwbt6N4WOjXb+JVDHPSD57HGdw1TxMAiMD8QmnSsBibY6ovo7p
	 kpS7MkkiTOdGclxIQtQmQocIIUYsK/ytq/NF7+zx4AL5KE7hnaATQfZ6ZseC9F44kL
	 RdHlmxG70wrFrqXrWUhBoJy4KPvb0XIYMt2tc2aHSRRjULaL6TVJ+gMPSpMaGGmm4n
	 Pc1E1+kRsoF3g==
Date: Thu, 21 May 2026 11:39:36 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: yizhang089@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, david@redhat.com,
	william.kucharski@linux.dev, karol.wachowski@linux.intel.com,
	yi.zhang@huawei.com, yi.zhang@huaweicloud.com,
	liuyongqiang13@huawei.com, wangkefeng.wang@huawei.com,
	yangerkun@huawei.com
Subject: Re: [PATCH v3] mm: do not install PMD mappings when handling a COW
 fault
Message-ID: <ag7S2OLQ6LSTwc9W@localhost.localdomain>
References: <20260520151624.78370-1-yizhang089@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260520151624.78370-1-yizhang089@gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: A7003140010
X-Rspamd-Server: rspam04
X-Stat-Signature: fmrkwsutji4titgmwunifrx4sjpxym9y
X-HE-Tag: 1779356383-117429
X-HE-Meta: U2FsdGVkX1942a5Gfsn3BtP/jpg4y3a/Zq7TwhmDIInTaTn9BXZ50CELx3TxVN+4dYblgp/H7iq32J2uzVxlpCaaHBnNDPoOaHLKUvFGUaLLKTAsUtFJ/ggzb8MVpaThyuW+MjuRZlK9LBh79oqnEphkWqTjE68rnE58nPOAExt9evfPOIHg+bmzIRf6393uOqon8EGveelcBzRKbgnh9zlj/Zh4E/3g5fNfet1Q8MCNb7iBASJ+fag2Qty7x8cIFNNhlDxSSp9wlQWoQDI9I3RRkIfZJqPyaYE1NX9WZE3KzjSSP19xwxnlKD/4YpVejCwY+bLs7iqSEi1QgJhpBICzIDk5Mj9YKSZsCYCb0SPmIYqU7Xtno1ockqvahlmUYK9GEIgBQxVm3InDASdoh3wvJSxn8hiZnCESJAFdjA5eahCCW0nwIbrQm9mC2neJgT1ghNCeOj8NaO6b2Ni16ZbQFN/OZYZ0HHpEnEWCBITG0nF9S3Kf+KMEHhnT5d8Zk+gBPO5w2BYM60P6btvT3JwGlGX4WwI2PvV13ZVmOM8ojbivLg60VZuKs1LDfAV857SC/sN0Zc4tgDLdsKRPd0IxIwx6NakHSMfA75xzh0uw38wEez9mmPzxomn31NioSHQRUmO8shVLMcVOMpg8uD+S8YUElsAVxvZuswAReiejR4+Cxc3FPcYUfkNFPeF1/ceMPCdQy8N4JEV8aPx9f/9Ap87M8RRpfwpg9/0zIh738JfmF8yKS69OBhV2NWHbkFW8VPpwDEumKeIhhj3BhDPN3OcdbTKYXo9Vo5KMRUpkpk9Znt8dVSa4MTw1ztp3BjAXZXEza1kUU6IBFFY+XMpyzvPHad4TXW2ZTM9CoIV0wqqj4DgzOgwF8hKgGz+wbURqdUkyBollIxH002EOI7n7/x+pNROehkm0Ws6SxnV6bm6OCB1BfY7g2DQFIFmnnColPaQrhNwsLIshW2/
 egg8hS+a
 DdsPi6sV9ecIftzuER6eSJSo0t+7eye425jHAkDN/xwj9chQ5scqcoVgqZQ5ZGnr1PC1fl+fyvclqEqUrx3z8o88lIJArhrL4lknBhRy7srMyoxxzGL8SPW4Oj6/mP3ngVHH2+Z8adgiXMM0HCVJwYlIP+p6mOJI3npm2Nvj9q8oP0x23LD59rue6eEhA/b7253mckHBR/A2rp3LQ6+1dH54msExSQBIKMziwi3M6G9h1kdK7Yfa5P98OAX5HOUHdks5Fib7obUHNIQ7QW529xUWWwMDgyLqPoOTEfrMB507rWOGyOM7AC/QvdYTvwh7eaqrgvgydrmyP4YY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 11:16:24AM -0400, yizhang089@gmail.com wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When pinning a page with FOLL_LONGTERM in a CoW VMA and a PMD-aligned
> (2MB on x86) large folio follow_page_mask() failed to obtain a valid
> anonymous page, resulting in an infinite loop issue. The specific
> triggering process is as follows:
> 
> 1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
>    has a 2MB large folio installed in the page cache.
> 
>    addr = mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, 0);
> 
> 2. The kernel driver pass this mapped address to pin_user_pages_fast()
>    in FOLL_LONGTERM mode.
> 
>    pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);
> 
>   ->  pin_user_pages_fast()
>   |   gup_fast_fallback()
>   |    __gup_longterm_locked()
>   |     __get_user_pages_locked()
>   |      __get_user_pages()
>   |       follow_page_mask()
>   |        follow_p4d_mask()
>   |         follow_pud_mask()
>   |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
>   |                            //huge PMD is installed. This is normal
>   |                            //in the first round, but it shouldn't
>   |                            //happen in the second round.
>   |           follow_huge_pmd() //require an anonymous page
>   |            return -EMLINK;
>   |   faultin_page()
>   |    handle_mm_fault()
>   |     wp_huge_pmd() //remove PMD and fall back to PTE
>   |     handle_pte_fault()
>   |      do_pte_missing()
>   |       do_fault()
>   |        do_read_fault() //FAULT_FLAG_WRITE is not set
>   |         finish_fault()
>   |          do_set_pmd() //install a huge PMD again, this is wrong!!!
>   |      do_wp_page() //create private anonymous pages
>   <-    goto retry;
> 
> Due to an incorrectly large PMD set in do_read_fault(),
> follow_pmd_mask() always returns -EMLINK, causing an infinite loop.
> 
> David pointed out that we can preallocate a page table and remap the PMD
> to be mapped by a PTE table in wp_huge_pmd() in the future. But now we
> can avoid this issue by not installing PMD mappings when handling a COW
> and unshare fault in do_set_pmd().
> 
> Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page")
> Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
> Closes: https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@linux.intel.com/
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Acked-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

