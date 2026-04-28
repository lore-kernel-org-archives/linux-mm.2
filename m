Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5C1DFF8868
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 13:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169A46B0088; Tue, 28 Apr 2026 09:01:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11ACE6B008A; Tue, 28 Apr 2026 09:01:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0307C6B008C; Tue, 28 Apr 2026 09:01:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E827F6B0088
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 09:01:20 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7EC3040175
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:01:20 +0000 (UTC)
X-FDA: 84707975520.23.C27B764
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id A5A0510000C
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:01:17 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MCUblZv4;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777381277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=negfwoNXDI6U05SEcotaWCxTz8Wg+EbKFaqytch1ifo=;
	b=p2CVdJm4ARi34vVbqaCd9+P8rzM1XwULWw5vVGShvKo9mcwDSnF/3mQg+usMa05F1QQkNS
	8tQkVHMzhcYOPyBx27U8STYKvb10zEPD+EvEpW3qGgMnGv8AZumQXapVvnryQj0l7Wyiur
	6aVygqBZadVQeh/9MCpVnKX8iTnhX5U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777381277; a=rsa-sha256;
	cv=none;
	b=usdch9xnB39p1KuxKBfBYBNZ9mrpfSfSe+K3UU81DoYeO6txoCL4+6uuSUpI5MhAgqe+TM
	bhGjMdN+xdeEq1R3KZa/2cylw5OFST1Jc9TLrC20UINuYHN54+oze+2b90yiDM6qTvxj6/
	6Z2qmDKGS074UeAFqbEXrP+U2Ikm67c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MCUblZv4;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D703361145;
	Tue, 28 Apr 2026 13:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AFD7C2BCAF;
	Tue, 28 Apr 2026 13:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777381276;
	bh=6dJQUEH+z2Cv8SxLL12FE1CYpvHAqBF/SiN0HelMoMk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MCUblZv43krP5yOYUlym9kKM7eTJ5bM8xgcUnmrf1e9hT8R8Bn/t1OZnZ/vyj/tHX
	 qwop6mchfCVpVdrA8PpHsAdRbvRISNb5eGGyEux6i3i6U0LbuAEpNiSXiN8D8b3DB4
	 NjTcwk0sXA65Gaw+pQV0yYrQhQfkoiMccPfmjB5Y=
Date: Tue, 28 Apr 2026 06:01:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan
 <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain
 <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Chris Li
 <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Youngjun Park <youngjun.park@lge.com>
Subject: Re: [PATCH] mm/huge_memory: Fix outdated comment about freeing
 subpages in __folio_split
Message-Id: <20260428060115.84c55bcf72315c01b86e0c90@linux-foundation.org>
In-Reply-To: <CAGsJ_4xvXZVRO0-mXAWM7mH9pVH+DAYggDBG1+2x5iQ9mfDDDA@mail.gmail.com>
References: <20260423034917.8234-1-baohua@kernel.org>
	<ec08f25f-1049-4fbd-8a87-0df135a867be@kernel.org>
	<CAGsJ_4wn=o5ZCNPGguCCk=19iYZr1V9Jup0NdRUKXySsKfD_4g@mail.gmail.com>
	<17a3bc38-0d97-4316-b2fb-02a91202c504@kernel.org>
	<CAGsJ_4y6_G5BPZKs3Mg3s2ygxGh1o22GX_3wEsM5hs7WX_cOhQ@mail.gmail.com>
	<efcdb62c-54e9-4806-87a2-5729e3c1506d@kernel.org>
	<CAGsJ_4xvXZVRO0-mXAWM7mH9pVH+DAYggDBG1+2x5iQ9mfDDDA@mail.gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A5A0510000C
X-Stat-Signature: mo8iakoxha4wcz45jqaskz34cjzk1o63
X-Rspam-User: 
X-HE-Tag: 1777381277-465682
X-HE-Meta: U2FsdGVkX1/8Jk2IdpwURi0uO1pWUJf0wM1ZUhYQbZUnrKTxSBZ4fqRLw87GvR7KL5FVAlWyF2RZLjjkTFol5FsI581L/L8nEGBzLox3Lgn4wSQ36vvwE/enOwsnwaZ1x2Hj+DzpZb2or4N526jweRgC7QhjSMn2J5RebWku5rI5tq5qQI9RJhKmfBtc7SO86Eob4slylMSZ6KLSX1xJ7TP38v67GBF1O8DQ4ALRVRFc+13ke3d/or94+r1oej7i9whrc3g2Zx2Go9r35gtxpI7I+fwIVWac2XO6KPS2nUEAs+lKOZBjM58pYrQfFKIN4oplTtR5c8mmuXfWwsu2fxI7yxn+xsz0LwAZGSkc7eaRpale6qpkxfZOfnfdDj1kPemOj9Ftf1MfdIp2mImegZ6jlFwLpVpeXFYbfnKnSuIeUdBBVr7e8HgTnGitWti53V+EtMWhfXaYsrIaSssVnziIFhf1QwuTIyS4zwIjmPO7GuYI3GY4dFTW9WPPoHyZjbs+ZD0rtSelt+hRZ1g0J26+NdCnRsirAv2iPsaiPQsnJFArSY1OcAigBa4D+NreEAHB6n5F1LnQw1/0kymELsfSiWf5u4wMSAQroFAZF5m9WV/jC3BUcB7uGt92SF5cGQjdi5vyiq/RIbpdvmymyQXezzL8Uy149XZFQWwei0j8OJjI0FLTVty5VwaEH5iBzsiLSxx1UaVKW2yvwmgVoksYsgdgRUs1eVpt3deStBe7s43/Jw3KC57o+6jNErWIurVJWoehYbFI+fSBg7feQa+iFbKNnXstEcAjqJbyVwd0V+jIaB4jRkNlMW+eIDHGQcTOJSazslVs01KcIqyZWYMmH+S73ME5pcPQbDR6xFT3qH7ThcOq/PU/U3nfJlu0VQdyRyZV3NLjmw5lmmMP514k3d++BdD9N+GEmt+8zzXUCCfkDKQeZDWG8bUr8W5dlAfGYUezpJPyB+XRNci
 PWJsR26o
 ps/lthPo6NvDzW02tPjRA/GPsahZ4EDLl/gF2TPo4FcDF4Bea6/AKSNg4LHTJh2PLWSpDkLbVOTkqzFtoDISjpVTR+NMC6lJLAr3g2kKnz2HVfgdzDrLAEi1VfpgL5baJyHz9j+g8GItENWFqJ9g9kdbPCYP5o4dJWNBrN7teWvEDuyQCVSI/w/jBP9mv7A4XyfdnSKLKTx52N5IY9l7NZ6CSPPEVDMaJFGQ8dzQHmH7B4p84bOZLo6MQ6qbjoXgwzVJz+TCIeM9aF19MDw5lSZS9v9MKYQ6M6ITAZ17DjTwrEYHsQ9cK6vSpq+wVCsaanEGwHotXxUxTgRILAwGb7qC4gITmsUUtPZdOpph1mdKfFICjIHENNq65efAicaODx3S6QBAayO7HppAIEK+s6hCKKlfVjeUK/tkUsP8XcNqe6EZcsViafXE3kO8KL6yhZDNYU0pnW88B9l1IINxRaVpSxo1OxZ32l48w49GWwy2rQMxu7oZKoyf6KuGyDVd1BUPA9eQCEU/mbAAtKXLJtRUw1h4AhO4KtGTh3XgHpFDz701JAip4JwK9Jis0YbxiZ7M4447xKlBuebERxbQ4VZhGtgc32bEy/SsVISal9CpmsKW0XqCe7c0AseoRrYAJWWUmQPmAcYNiROKVnqq5Af31iAJBrDLH6vk12vvZedqph/ikzJz0DXQ1lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Apr 2026 18:32:40 +0800 Barry Song <baohua@kernel.org> wrote:

> On Tue, Apr 28, 2026 at 6:08 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 4/28/26 12:05, Barry Song wrote:
> > > On Mon, Apr 27, 2026 at 3:42 PM David Hildenbrand (Arm)
> > > <david@kernel.org> wrote:
> > >>
> > >> On 4/26/26 22:42, Barry Song wrote:
> > >>> On Thu, Apr 23, 2026 at 8:36 PM David Hildenbrand (Arm)
> > >>> <david@kernel.org> wrote:
> > >>>
> > >>> Thanks, david! would it make more sense to add “when
> > >>> CONFIG_PAGE_MAPCOUNT is enabled” at the end of the
> > >>> sentence?
> > >>
> > >> Better to phrase it in a way that doesn't even require these details :)
> > >>
> > >> Do we even need this detail in the patch description?
> > >
> > > What about:
> > >
> > > The comment appears to be outdated. add_to_swap() no longer exists,
> > > and the explanation of why we need to call put_page() after
> > > splitting could be made more general.
> >
> > Jup :)
> 
> Thanks!
> Hi Andrew, would you like to make the change in the
> changelog, or would you prefer that I send a new version?

This?

From: "Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: mm/huge_memory: fix outdated comment about freeing subpages in __folio_split
Date: Thu, 23 Apr 2026 11:49:17 +0800

The comment appears to be outdated.  add_to_swap() no longer exists,
and the explanation of why we need to call put_page() after splitting
could be made more general.

Link: https://lore.kernel.org/20260423034917.8234-1-baohua@kernel.org
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Lance Yang <lance.yang@linux.dev>
Cc: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <kasong@tencent.com>
Cc: Kemeng Shi <shikemeng@huaweicloud.com>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Youngjun Park <youngjun.park@lge.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/huge_memory.c |    9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

--- a/mm/huge_memory.c~mm-huge_memory-fix-outdated-comment-about-freeing-subpages-in-__folio_split
+++ a/mm/huge_memory.c
@@ -4190,11 +4190,10 @@ fail:
 
 		folio_unlock(new_folio);
 		/*
-		 * Subpages may be freed if there wasn't any mapping
-		 * like if add_to_swap() is running on a lru page that
-		 * had its mapping zapped. And freeing these pages
-		 * requires taking the lru_lock so we do the put_page
-		 * of the tail pages after the split is complete.
+		 * Subpages whose mapping has been zapped may be freed
+		 * earlier, but freeing them requires taking the
+		 * lru_lock, so we defer put_page() on tail pages until
+		 * after the split completes.
 		 */
 		free_folio_and_swap_cache(new_folio);
 	}
_


