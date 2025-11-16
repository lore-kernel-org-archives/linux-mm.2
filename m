Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15D00CEBF61
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 11:51:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EFC58E0009; Sun, 16 Nov 2025 06:51:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99EA88E0005; Sun, 16 Nov 2025 06:51:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B3ED8E0009; Sun, 16 Nov 2025 06:51:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 667798E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 06:51:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC76D14098A
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 11:51:30 +0000 (UTC)
X-FDA: 84116305140.11.4333CAD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1AD23A0006
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 11:51:27 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tR5be4N8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763293889; a=rsa-sha256;
	cv=none;
	b=sr7kSXVF6jTSEE16iLNykTKPi+857SsFHNVls2iQ8Uqw3UVWhIRR4NYLxqSgskwc2wFoQk
	06zL1hmfbbBiHrsxuSeex5y+g94sV2cjSoaHBIOoBxBLtBWjja/o1Q1CUZJOBFPUqKwpTO
	FIuJkDtfQtasTSINl2nL+HHD54Mhqps=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=tR5be4N8;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763293889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pz4BJwDyaALcHK3BMUpJeAT6g0IIQz8aJIQbynT13Jc=;
	b=pdLNNOAJQJHai51FGEF7Tn8FhzVBUQ2PsPwUqV/PbgtAq3dC/0PxSj+px0Km5Ldm5CodPx
	3qtqt7OUcEFS9reXhM6Qz1qIaTTIHRYbiryC6DKzV2Xtnpj+He8pnDcmKJObDFU4BObN93
	1HSqxWXLB1mmJRhC3Dw446OINvw6vJw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pz4BJwDyaALcHK3BMUpJeAT6g0IIQz8aJIQbynT13Jc=; b=tR5be4N8jR/gONcUW9m+u85yKY
	BoyXLT7+NeCHca4j1SubH/JuFKIaLjhZxsrI8BoJy2o2hDKtAokJLs0hJunMQi/8BWXQbc1rtzweZ
	XQ7FiMEJogdOLNTQ6k/9nrqq0KDP3FdA3JoojqeLQuOfCVJapf7Dwg+z+axpYn7ZwFAheBDRDrBxn
	J54Ydo5HI0vJDaU/8mc1seP/vC5w557HnjAMRalYiJrIs9apje2KaL2TaXEZu4r7l1NTdhn4Ssfln
	xJ8Pzcf4t2lHZoGNuhkLIA6AfYs8Em2bcEn+SNo1lP6Ev8VfJupnHGk5B1RT+pE7JmMErU1JhpIOC
	5EC8ZXGA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vKbHm-0000000CFKM-15FF;
	Sun, 16 Nov 2025 11:51:14 +0000
Date: Sun, 16 Nov 2025 11:51:14 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: nao.horiguchi@gmail.com, linmiaohe@huawei.com, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	william.roche@oracle.com, harry.yoo@oracle.com, tony.luck@intel.com,
	wangkefeng.wang@huawei.com, jane.chu@oracle.com,
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce
 uniform_split_unmapped_folio_to_zero_order
Message-ID: <aRm6shtKizyrq_TA@casper.infradead.org>
References: <20251116014721.1561456-1-jiaqiyan@google.com>
 <20251116014721.1561456-2-jiaqiyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251116014721.1561456-2-jiaqiyan@google.com>
X-Rspamd-Queue-Id: 1AD23A0006
X-Rspamd-Server: rspam07
X-Stat-Signature: otoiyxeu86s6xqwezkqdy1rr6hqukkxw
X-Rspam-User: 
X-HE-Tag: 1763293887-525848
X-HE-Meta: U2FsdGVkX1/XBVnBsf/Mu/HYlH1SiVSwUgV+pPZUnm24kLLy0iAnCIR6N12XdqQUeVpsgR/xQPAj6c/SgQ225M1CRserO8b2ZjNL7uBnOYW8MbAZOfRNE9rMkh3UHlHsfYgRrOzU5X9gmR7BdOGJxOM/NtWqZSV4lZLMS4ouhS7cJWpbJ9eDbFeF42ui+BHAONZvRV6ImIfQH4jrwPIcqrznqZVTxRB5A5JdNZ2/b7vZbKOWIg6qUG9gTHWnSfGQBlrUnFqhPsGakuFif8pXZhhq9+Ce/kXNUYTzXupKO0rKR/1iByDMK7apd4zIkKhmoNJRq07pgwu5L5AKuAMb1aMljQTqqxes08GHwkX4j89n2opkakUxCgAr8c1fFiKY1lQs0yYljdYBlvOx7OfBXMD0o9w2H+DJOCdf0gNIQrEqkg9QlwZXmhBORIGldzgvFr1udhPNGfx+UEd5PX0eAeA34TB8Y7wpCoF57jAAxoRVggemyLLUPjgc8sTBvW+GVsDZfZWEKado1ocnKkmOcWNmEYvFB1a0QiH2eoLlT24VZ2jzXbA7VWSH/sOmj0jOpdm+3UiltOKkZHoeJEnBgeEQ1b7jgziYbQLb7zxgpL1m3/OCz8/66TE8ulNgPHkDgf75cA2IPd8ft6sTgasR23jqKNSy2z1MYvh9eiZXmLDuNlQxvYrm0D69hRAoMJOuBq6Vf/+fuSreh2QnRNvVZOewWjMBpv9VAErNhE6ERAUwLBVetKgWp5rdQRd1fW/3eP+s7G66xf+5ODN+PkacW7d7V380B/pbREc624BjMS4dgv9AfMglIg4ksoLwOXcHp67A3LIrsdd63S6Pu3nV9HrEizsIZBPGJsjR4cfajpW3oj0rUCn8HoHXd4+2Z05A/3NawZSXEO5TmkCuEUJkc8/2uKkU60WoTvLKc5XJjnNpTp6W0JL8Pt787sHspgV64rlUS87FlCPV3IbtA5s
 R/3dm84y
 p6F05/CpaTZ0S4SOPtDlMsCNzrT9ruxmohHKmjBv2rzM8qqvbUQAg6HOFvk2atAgJjdcrdWWvXWWXKM/VHqYyxBHRvc8JKhsOJu4TocqYwaqHuUZy89a1ABmi2Uj74qGmBnglzUy3ZoD1ox2phSHyAJKKWFuF/j956Wfg8Tbvr7sNwSFEM95zZHZuLKnF8sEixBq8d6iWXuKN4q0W+iS61QrBuF4HRfTNYZkol1SAGnedQwsne06QKJmt+zikJawZX78Zcu0RHxlWmmt6puaEj4gHtNXn6bTyPozEEGvYZRDp8osWHX8Yz64a4OFTQRpExDtqKq3FnFl3MndDz1VFYBNnLT2pAWS9XN+AvfRl3fGV52JO6H3cl9sv8g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 16, 2025 at 01:47:20AM +0000, Jiaqi Yan wrote:
> Introduce uniform_split_unmapped_folio_to_zero_order, a wrapper
> to the existing __split_unmapped_folio. Caller can use it to
> uniformly split an unmapped high-order folio into 0-order folios.

Please don't make this function exist.  I appreciate what you're trying
to do, but let's try to do it differently?

When we have struct folio separately allocated from struct page,
splitting a folio will mean allocating new struct folios for every
new folio created.  I anticipate an order-0 folio will be about 80 or
96 bytes.  So if we create 512 * 512 folios in a single go, that'll be
an allocation of 20MB.

This is why I asked Zi Yan to create the asymmetrical folio split, so we
only end up creating log() of this.  In the case of a single hwpoison page
in an order-18 hugetlb, that'd be 19 allocations totallying 1520 bytes.

But since we're only doing this on free, we won't need to do folio
allocations at all; we'll just be able to release the good pages to the
page allocator and sequester the hwpoison pages.

