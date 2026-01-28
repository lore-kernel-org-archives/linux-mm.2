Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A376BD25B57
	for <linux-mm@archiver.kernel.org>; Wed, 28 Jan 2026 12:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA3086B0088; Wed, 28 Jan 2026 07:59:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A1E6B0089; Wed, 28 Jan 2026 07:59:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B86656B008A; Wed, 28 Jan 2026 07:59:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A5F206B0088
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 07:59:38 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 366C9D3ADC
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:59:38 +0000 (UTC)
X-FDA: 84381379236.22.91DF1DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 445741C0011
	for <linux-mm@kvack.org>; Wed, 28 Jan 2026 12:59:36 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NBTfHOg/";
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769605176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fImupnOL4b9i7QQRjTlfrJ3H6d1grCKQ4x8Gc/Btkvo=;
	b=WeNaFUYQL4wBGIVawokq9qO6cmHbPdcVmBER8pOj4rD4uTypqYgVCCap2UqRiEpyI8aWrH
	44xJtKNoQb3a0XB6a8PZdCJh4JyPJq2nQ2KNWg29EdVtqlv/0vn4BFa2pbBVd48zxDIqDi
	qiwsMGus2/e91GvF0IZDMikd+4DKKx4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="NBTfHOg/";
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769605176; a=rsa-sha256;
	cv=none;
	b=taZ0tvht5OiSa/wYysxF2bUDiAPRvsGAOaeDkwoKSGSAPGpnVmBgf3qv2tieiUyooqPYN8
	+MaSPTHbkCeMDMMNA4ujO3zbxR/6MH2kqHQyAQiHkmxwO05HPrN7B0i7LqpirjUDZDzJDo
	smHvqLF6VMwKtoO4cJCOt7bJHLz66rc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 92A616012B;
	Wed, 28 Jan 2026 12:59:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD59C4CEF1;
	Wed, 28 Jan 2026 12:59:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769605175;
	bh=MWbIAfBchoyoNYFkExtCSdFr3OpWnWDSLBb7n5YyyiM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NBTfHOg/whqQDUteF39OH1O7ZJV51aj1KWZNMqn2BlAwriZqvU9IoZ/jZGACQeOOs
	 RY7LMe0UJOen4cmLwQBNrDcMDy56MPDWJ7np7Ikasy4kHva3n0BUX8hR6aL9EOi9YE
	 mlXIwUdNS4qAm74KUFZ20w3K6tOlCi4sVloSu+xt0crpAue8ir9NQbWD8IwuLWwc+h
	 YMBsDW8aw/h+cIyR4oLjLbBpX7mBlzGfiasa67G+soyR4d3nNiMo977M0sdrh3WSiy
	 yj6QsWFFsFGfkkF0mMHShiviwCxiDvGQSKWEm2oUnrF5vN+s9IOjnJboogs7pY7RaV
	 DiaYPOiCYs61w==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id BCE41F40077;
	Wed, 28 Jan 2026 07:59:33 -0500 (EST)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-05.internal (MEProxy); Wed, 28 Jan 2026 07:59:33 -0500
X-ME-Sender: <xms:NQh6afJ7LEqqoM5OQSBBhs1ZhRV5cTf9wzuYgk14848G84yEUL4JXg>
    <xme:NQh6aehQo8l2ezJmorIdL7M6yzV1beZOHBIYpcHHCn0MjO6m28O33o2rlRu4WKY-g
    BGFt2JyJ-htIcu3PBsrEpT6BkAbnyKg3-y_Cf0KpHY90_DvZIxNBg>
X-ME-Received: <xmr:NQh6aRHpyody9eTimhv_gyGyZe_jgAV4SdZQpmXiadWipdjHg7ntDgmQQtOrEg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdduieefgeefucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggugfgjsehtkeertddttdejnecuhfhrohhmpefmihhrhihl
    ucfuhhhuthhsvghmrghuuceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeigfdvtdekveejhfehtdduueeuieekjeekvdfggfdtkeegieevjedvgeetvdeh
    gfenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkih
    hrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieeh
    hedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovh
    drnhgrmhgvpdhnsggprhgtphhtthhopeefkedpmhhouggvpehsmhhtphhouhhtpdhrtghp
    thhtohepmhhutghhuhhnrdhsohhngheslhhinhhugidruggvvhdprhgtphhtthhopehosh
    grlhhvrgguohhrsehsuhhsvgdruggvpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdr
    ohhrghdprhgtphhtthhopehvsggrsghkrgesshhushgvrdgtiidprhgtphhtthhopehloh
    hrvghniihordhsthhorghkvghssehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihih
    sehnvhhiughirgdrtghomhdprhgtphhtthhopegshhgvsehrvgguhhgrthdrtghomhdprh
    gtphhtthhopehmhhhotghkohesshhushgvrdgtohhmpdhrtghpthhtohephhgrnhhnvghs
    segtmhhpgigthhhgrdhorhhg
X-ME-Proxy: <xmx:NQh6aQLK4Svpd37QFpMIaymOrWp1qX2ZTSoVI1al2iVT_IfrNGYaTQ>
    <xmx:NQh6aR-6IYa0nfLGKvBuinoM9HaZ1f-cbZ_w4jpQlSYZA0loNeZtCw>
    <xmx:NQh6aSdDjX6urIZ_w9RfeIvmxqcCdOAVohyQ46LpJhQWyc_Q0uqfmg>
    <xmx:NQh6aelrkE7J2Oj3AEWTG9Sesr0fqbLAaX-QIFQtaGLKQVLLHSqMcg>
    <xmx:NQh6aeGioZD_gZGiZgG1YG8MLXwUDabCbuNEzFIW8SNHV1PjIH2Lh723>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 28 Jan 2026 07:59:32 -0500 (EST)
Date: Wed, 28 Jan 2026 12:59:26 +0000
From: Kiryl Shutsemau <kas@kernel.org>
To: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, kernel-team@meta.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Frank van der Linden <fvdl@google.com>
Subject: Re: [PATCHv4 09/14] mm/hugetlb: Remove fake head pages
Message-ID: <aXoHb5fYfZNQxmMe@thinkstation>
References: <20260121162253.2216580-1-kas@kernel.org>
 <20260121162253.2216580-10-kas@kernel.org>
 <ffe9811b-d7f8-4924-9ad6-96057a16b693@linux.dev>
 <aXjPf_fIWX74YVWD@thinkstation>
 <25C01EB2-FC77-43A5-A737-7BD3D2D98EDE@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <25C01EB2-FC77-43A5-A737-7BD3D2D98EDE@linux.dev>
X-Stat-Signature: mjwpweitmss689ag7dppxpmq81gjsaxe
X-Rspamd-Queue-Id: 445741C0011
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769605176-50667
X-HE-Meta: U2FsdGVkX18ZAhNnoiEVfHJhSy1DoSm6WxbJvJItFjfl6+2cbSxYu6tPWyLN7KE/DETqTVz34B1naPSASA3U+sDIlNEjqMmkqt2PLD+LSH/jkHMFHsfW5kXvXpNtH4TJqXmyEEWFhuWU+RTMFxULDpwGcLXe89DyAKAcgPWve3/TVXQ6wMokIY84gr/oE1hS9lTBxPzokRBzkK3sekTt5e77kVtjnxgW9Z+WDoxQkju5FQkdJ1LqfT1+p7H86kfzNVqQ9ZQt64F0QPQE/zWjxS1OIdFgJbP9hMcXHEIo+39KPeL7hMgdMFfDLpCywP5++9ZUuhVyiZqv6lxWNhGnS+hG2MX43scqLH+nT23cGYGDeO+tEL/vPvaNe0c9YydM9ex2/X/oneydSg4j6lpAsGvRYx9waw3dJ+CerEc46NJCgsOwfHrUhoV+7T+zXeMsYvMcSCwKROFS513yp5Rz+khAy4bl5u4bX2kFOGO06BjOe6Sy/z7bCosFD1wosW/CaA4p3N1CYOJy/JIihekdh07vToYv1mGZqMnNAcIWLCHlcwO2APxEGkHdLiFn55bdg+2Qdl2nq3gfdnvAKtCpaMa36r4H+HVVbmAXH98BcmETfOSH7ZDHmaoIEGlNAcaYh1GP2cmqvRLjyJdGli0vcdeG6cKJlK1N+K7AVZKz3Wqngy3bjGdfTAYxVX2hrCqydXBd+UBsZ26EltCwYXwg81oY/ur2Kh4P0V07YwD9eUj/bQ1vkAuuCE6e1R9USkyIZMozxMPrugMLdeEA4XgmAndXIlx6RV1MhsXlVxeMX86LM7tsljRQk01rnNDHgtNFcr2C1w8UOG3p29pq3mVmJFCxSGhI2q2vUoomQJO85ZA2DhQp+btgNWJi6TAOdbIdo+0ROdgKHdveg7EBQQxRAAI9/EDHHXQHAF7fYBNN5HSvbIP0hUf7+4Asqu+F/1gFtiTBoIKiAsD8OYP7txq
 ce3K3tOp
 hPfcE67kybumUjHHh1CfXbzsPLFxAo4af9RbRjvfJp2UwZnS4JB8SeV9WLHhaHYUZd80f5AISqivLHpzdtymHspiNxEu14qb73DWuSmNio28GnhGEDAxH991scCky5qTVSQqHKmqV8NxaSN/s8qoJr9eg8NsA3B5khkvB6rFQLPyQ4otfaTOZiJ1hj+baB6ktYTUZxt4ebrdmfhAhNyYVB3TyxeR52scg3soU+dZ/nFp1QbjMdWr7BnyyotXQvLTkj15SQJynhz1v25IGIPRwrd+dnOdGXSRDCVSHTRSVlwwgNGdgfK2x1vpb31fIqpq41t5O4QbTmX9DsB8gEh4aP9Fe384Lpd6xwJlRd0TR4nOfbpk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 28, 2026 at 10:43:13AM +0800, Muchun Song wrote:
> 
> 
> > On Jan 27, 2026, at 22:51, Kiryl Shutsemau <kas@kernel.org> wrote:
> > 
> > On Thu, Jan 22, 2026 at 03:00:03PM +0800, Muchun Song wrote:
> >>> + if (pfn)
> >>> + 	return pfn_to_page(pfn);
> >>> +
> >>> + tail = alloc_pages_node(node, GFP_KERNEL | __GFP_ZERO, 0);
> >>> + if (!tail)
> >>> + 	return NULL;
> >>> +
> >>> + p = page_to_virt(tail);
> >>> + for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> >>> + 	prep_compound_tail(p + i, NULL, order);
> >>> +
> >>> + spin_lock(&hugetlb_lock);
> >> 
> >> hugetlb_lock is considered a contended lock, better not to abuse it.
> >> cmpxchg() is enought in this case.
> > 
> > We hit the lock once per node (excluding races). Its contribution to the
> > lock contention is negligible. spin_lock() is easier to follow. I will
> > keep it.
> 
> I don't think cmpxchg() is hard to follow. It’s precisely because of
> your abuse that interrupts still have to be disabled here—hugetlb_lock
> must be an irq-off lock. Are you really going to use spin_lock_irq just
> because “it feels simpler” to you?

I looked again at it and reconsidered. I will use cmpxchg(), but mostly
because hugetlb_lock is a bad fit to protect anything in pg_data_t.
vmemmap_tails can be used by code outside hugetlb.

Here's the fixup.

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 29e9bbb43178..63e7ca85c8c9 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -512,18 +512,11 @@ static struct page *vmemmap_get_tail(unsigned int order, int node)
 	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
 		prep_compound_tail(p + i, NULL, order);
 
-	spin_lock(&hugetlb_lock);
-	if (!NODE_DATA(node)->vmemmap_tails[idx]) {
-		pfn = PHYS_PFN(virt_to_phys(p));
-		NODE_DATA(node)->vmemmap_tails[idx] = pfn;
-		tail = NULL;
-	} else {
-		pfn = NODE_DATA(node)->vmemmap_tails[idx];
-	}
-	spin_unlock(&hugetlb_lock);
-
-	if (tail)
+	pfn = PHYS_PFN(virt_to_phys(p));
+	if (cmpxchg(&NODE_DATA(node)->vmemmap_tails[idx], 0, pfn)) {
 		__free_page(tail);
+		pfn = READ_ONCE(NODE_DATA(node)->vmemmap_tails[idx]);
+	}
 
 	return pfn_to_page(pfn);
 }
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

