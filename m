Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D5BBC87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 06:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB0D6B007B; Sun, 27 Jul 2025 02:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32706B0088; Sun, 27 Jul 2025 02:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA6E6B0089; Sun, 27 Jul 2025 02:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BC9166B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 02:30:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7491E1142F5
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 06:30:35 +0000 (UTC)
X-FDA: 83709070830.07.8E811CB
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf23.hostedemail.com (Postfix) with ESMTP id DE25C140007
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 06:30:33 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O08zmCcV;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753597833;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jjfcCyoAyA6p4trAoq7FoBBrNSgnRiG/tjvLuL/5Dpk=;
	b=57QnVDVzjLWfeeGHcqguV6R6L9rAiMlAHv0cKIH+f3m5D6MDiVkCifiFTvt1s+zPMDzCmg
	ZAFccWc9nQBhXbPV/yNijURxU4+JdY5aZfMfyGgMkff4ekZ8WG51rBu4NW5H/Rdjev2pBm
	AeHRVmRzHTL9NR67SgJqd8h5WSfh5lw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753597833; a=rsa-sha256;
	cv=none;
	b=L52fjaM7mMpNz/PWozy7fFGof42ouDeD6SlhfqRRdXagYRc9E7UK72Bdns1Y9jO16+UxNo
	iXhjDHqO1jEWD04G6q/Pp6g3sosk8ctaPhmlJN+35nPehDskUghYENh7NNJezZ65IzA0XK
	IRN2+zNSsyke9cGkisL5y2kqaMzf7fM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=O08zmCcV;
	spf=pass (imf23.hostedemail.com: domain of leon@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=leon@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id F2F99A53E7D;
	Sun, 27 Jul 2025 06:30:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8F2C4CEEB;
	Sun, 27 Jul 2025 06:30:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753597832;
	bh=JJ+HLI2Xg1lbocAOdaQhvUAP42x5alyGCI2q27jF8yc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=O08zmCcVnVLnA+ZHOWb+eSajAvE6pm7DaQ8NMn+fNKRDLa2pRo5BX8aW+a83tPDqU
	 GgXaGRHEjqMTQaTSEwiTq+LZsr8fgXvxAZupxxQHihlRCEGeKRTYN9ZBvXGeZH5v6l
	 cNbEkyR0f0fisjYOpU+PgL5jY4ZNEON7FnZKH71NVsw/KoC5dN6YmBpvTPLR3GvZbC
	 q9K5qaRFyq+a0yKXV5afTeXYdwYrJheYw2Wafv+rq71uOtdWWY/B2IP14x5XV0q/f0
	 7brS93dUX/SVOI+l3RFg45/NhN//8bCTqZoEMGjszephsi3GB/4IZrVBAlBjvQt1f+
	 qDDzVvsJtuDAA==
Date: Sun, 27 Jul 2025 09:30:28 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
	Christoph Hellwig <hch@lst.de>, Jonathan Corbet <corbet@lwn.net>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Joerg Roedel <joro@8bytes.org>, Will Deacon <will@kernel.org>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>,
	Eugenio =?iso-8859-1?Q?P=E9rez?= <eperezma@redhat.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	=?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, iommu@lists.linux.dev,
	virtualization@lists.linux.dev, kasan-dev@googlegroups.com,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 6/8] dma-mapping: fail early if physical address is
 mapped through platform callback
Message-ID: <20250727063028.GX402218@unreal>
References: <cover.1750854543.git.leon@kernel.org>
 <5fc1f0ca52a85834b3e978c5d6a3171d7dd3c194.1750854543.git.leon@kernel.org>
 <02240cf7-c4d4-4296-9b1e-87b4231874a1@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <02240cf7-c4d4-4296-9b1e-87b4231874a1@arm.com>
X-Rspamd-Queue-Id: DE25C140007
X-Stat-Signature: uhj46tbpg9s8uwiauxbtdsez3ydsyhfm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753597833-57070
X-HE-Meta: U2FsdGVkX1+GksHcdoOROQ5rUIkCW+pQkPPWmjoh+nK4KWZTfGIgHgPJ982vL1dWR44Eqt3E2mIkZ1YurDvDyYnB14N5ag5TChQ6N5y+qx1/bdcEeuT8m3Nw25WC7lC3A5eMzvGk9BY1wnEbjPlCPE1H7QcnqpY6Y9WHv/vew6R9Y+Fk3cCwt5joddQehW8Kc2oNNoDLzMT6kmzWSQLnVFOVqmeLZta5qY1LjbLS8FWK5z0IVf/GPyw9IFIH4BPtiF3NYUkiqmbqyVBeHGaqW20O0g1o0Q4RQp0vwbWGOQSIuqVmkOvMTQPlInCC7cihNmbF2YE4dq7vTwubmj8sWRjEGxS5Tz5jQanp4biMw6m6bBceUhWvE34wQict01svWVO0+A9Py95v2Ha8QuRwOHgelBGJk58+mThnHB9rKjTxknXUNpCZjTWEnMlUjRFfIPrw0LA9d/VlLi/wYYquJYWAQ8HNBhuykKFP51iztJPyX+6WLHRExfU68DrTNOYkpTkZm79hHkLZgzUMJ65B0oD7Xp7jKu4IP3cz9b7PlGvjV7V326xwZXcPmwICjFSFM1DUqItyQfvrjkSrP7jClJG+4jTm5USyAXix2wzYYD9dS7lfl1UvCzSN1PU5MpyiTITaZ2xq8PXsHI6DvTsnHKqYuqJBmzOpUcMHsbgevm5sFMhnLBMRco0PFzXWRLye5WLpiTcknoVSIsW2RFdQMGO/JJbjrcWhCoA1DwRliF7odasfvBm1modEk/G0kQZyXIXo8hkas9ffTXQNcQfzzdQ9R5Psoxh5t7ljw9VykG3uqXeHpWViMmk0rvoNgNZmXNl4C/OnXkXUOJtgWpAETLlcOMariEcL5BUtgdhTngAX08ihInzMwiWkZI2HRG4DdTdlOwYXz6IsH76+qq7VVxaHO49lT1GMYasR6Vnb3laIh7qjbzdZTItFKcDPLmLGyWRKfiSa6ZEYb3U0cpf
 fDTUT/l7
 uQCAPp52uL/+iDRb3/XFCqTGiN53Jn4fd94BnO2hmZRaASfvBlzT1tHPyC9nIuNCen9gRAaec77xRaDK9jMH6XLCdrzzKzBoBWr1bJT34N5etftvn3s0JVahuPjYfu2HSOkraJn52nef1Aq7j8e12gYPYK3Aa0HimrFknQzwSKIlqBD+lA02jIg5XSQX7HLUObbukwRDvf26nKtwT8p8eVzuiBcxh6euW8oIPuerjCvOdCtlUfywRlFUFzg0oww9cqjG81Hi3Kuab+h9O2a8VZfOLpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 25, 2025 at 09:04:50PM +0100, Robin Murphy wrote:
> On 2025-06-25 2:19 pm, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro@nvidia.com>
> > 
> > All platforms which implement map_page interface don't support physical
> > addresses without real struct page. Add condition to check it.
> 
> As-is, the condition also needs to cover iommu-dma, because that also still
> doesn't support non-page-backed addresses. You can't just do a simple
> s/page/phys/ rename and hope it's OK because you happen to get away with it
> for coherent, 64-bit, trusted devices.

It needs to be follow up patch. Is this what you envision? 

diff --git a/kernel/dma/mapping.c b/kernel/dma/mapping.c
index e1586eb52ab34..31214fde88124 100644
--- a/kernel/dma/mapping.c
+++ b/kernel/dma/mapping.c
@@ -167,6 +167,12 @@ dma_addr_t dma_map_phys(struct device *dev, phys_addr_t phys, size_t size,
            arch_dma_map_phys_direct(dev, phys + size))
                addr = dma_direct_map_phys(dev, phys, size, dir, attrs);
        else if (use_dma_iommu(dev))
+               if (IS_ENABLED(CONFIG_DMA_API_DEBUG) &&
+                   !(attrs & DMA_ATTR_SKIP_CPU_SYNC))
+                       is_pfn_valid = pfn_valid(PHYS_PFN(phys));
+
+               if (unlikely(!is_pfn_valid))
+                       return DMA_MAPPING_ERROR;
                addr = iommu_dma_map_phys(dev, phys, size, dir, attrs);
        else {
                struct page *page = phys_to_page(phys);
~
~
~

Thanks

