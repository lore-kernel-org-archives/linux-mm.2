Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7562FCD98F2
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 15:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88FF36B009B; Mon, 22 Jun 2026 11:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 81A2B6B009D; Mon, 22 Jun 2026 11:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E2216B009E; Mon, 22 Jun 2026 11:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 408BE6B009B
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 11:23:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC7801C44B5
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:23:37 +0000 (UTC)
X-FDA: 84907918074.08.128E6CF
Received: from out-176.mta1.migadu.com (out-176.mta1.migadu.com [95.215.58.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id C0B41180003
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 15:23:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hLlnHs9Y;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782141816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PmakUKuILXFzmTyxIL7saKNm9RNkS5X44mNmXMdfUyc=;
	b=jM2blPzIm/tnfN1Wu1Lz0MNS2aFbDgV8HH3VqC1hbECg2lkg2jr8KEvAgvgDp2TIINffgB
	wqzPTOVtFHjMYQDVModGAeR4puDWNkzOXKyPMtcjWE/E3UdJfzU2tvnglekRGKUrGY49it
	QOPiPd6Qk/LZH2nzbWAmbKOu6LAh+Qo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hLlnHs9Y;
	spf=pass (imf06.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.176 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782141816;
	b=fCyjkZaSe/jrLN6uT3lg79xoW+c3LpGptw5Ewx+bRDn8I5xWFCT2DbQ2awtCxqcLH0VqqD
	8ufyzrZPIz6PAatTGMFAmygJK5MiRGT5gGYonceZZST0jeIbJkeQpjBwp3/R3niVT5o82P
	fvbR9UOj3ocpj8dQ27d8YzZGQcnW6ts=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782141813;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PmakUKuILXFzmTyxIL7saKNm9RNkS5X44mNmXMdfUyc=;
	b=hLlnHs9YEk9awhob5sNYldC/+Ensz4LNwFAgu6OQ8A6KPUane3W+/raLNH5o+NgXUUNyr9
	+C0fLltMVFPdoi/pR9tFsa/DeJ//2IErta0aUnaZhcBHL9h+yOw8/psS3JQLy5Q9yaxomx
	XBoKYqEBrrDM990wgPik3NLztendpEo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: init tails before init_migratetype
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260622101901.223961-1-mclapinski@google.com>
Date: Mon, 22 Jun 2026 23:22:40 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
 Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <73F7E404-4E8A-494C-8574-8C6723EB50A7@linux.dev>
References: <20260622101901.223961-1-mclapinski@google.com>
To: Michal Clapinski <mclapinski@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C0B41180003
X-Rspam-User: 
X-Stat-Signature: n3tjnx79x31crkt1wreei1y66gm7h137
X-HE-Tag: 1782141815-462427
X-HE-Meta: U2FsdGVkX1/4xNIZ3RwGKJHmi7i9pwObEeVxC587sK66GikhSBukwW7iRm+XCErhTrbQSQ3Zi+P0cW2AIZL+kFg4KvZLK1nVMK8mp7XA7BsnApBoRq1rSFCnVJ6Ry/PXk86UYVGPqRZyLLv0/A8mil8C6TH5O45Uv6Co08v4ipZYFN65MI2bN24/cdyI8j5tphLQRQKKNXog1hj7BKd4K4sYdb9ehryCXy7TCx4GiFWvDW2zmuqims5Fhn6M3Dvz9h9xH09VSJcTbAb29bcodGi72rWUj1QfDrBdT3vwioyjDtGvGoNL6Rkj4BQb3s1SptXdLEQjr7HDae+JKxVLGRpwjuD1WUaCnd5GvQ2HRM7KWQQM4IvJSpR9XituESQWa1w7iL/NfSVXNR+0MvNlkAVMhm1jw4FR9YHSz5nuBOJAUj5B+vJ6LV3IapexMM+DT0CXkC7ROSFZHsycXm1e5lyBb31enNnf54QSVD8yTorgIc7uwXie5a8BGnJdIMopFEfO44osbutDYtAfxKYcxw1/LiCCpgdZhEJZMY+99qGHS49BySYS0SU7Y3ja4dorRUP6tCD0gvfdzUBmfI3uHRioqoHTwpGPHDBMiRpmAeVgPJBKEAy4nNum6zYU92yv7qEz5h21zTOALo10WUW0HwCdsH4Vc9vV75qwXedlq7axcUsaWeOQlxZ7u8eE6NwmgVEKZL4oXnZ9fm7ICtFWJypTT4kEOklG2pc5M4ymIgfvFl0RHxUkRwiudDlsQWyMFNe32GlcutrKzW5kibzFogQOsLE51hAgc2WAC/I3GkvmBkiE9hTMIMeeMVme7al4NgTIVnw0Bw9D+RtWsMBMrCWG2/nWCNksUrAdNRfviGFCts6LmrziPVVVM7zT90IgxEEcFt0ga4j5aC7TVHh5zLwgYlVwuEWoCSbTujkXNejJJEMPx8kmoQMg5RTbr7defjnpt0cU/4YImsVsMCf
 MwGiqWDV
 gIe426iy57SSrIpwhFgwZV/jJfcrpUMrPpCv7/qM88mNlX/wtv01ECJmnnLX0zTVQsqVKX/Xr62g4D1l+ja8h+fePRgb9kIC+kXq/nP6HlmpYfB1Nqntt03TvPbklmBmnVVbNwxZ1bgj3HjAzsH+lAegQPIPPAHZF9Lo+0hj9DpdJx4/XgkgDKDeC5HGQ/4EieWF6wKeUOUMcw2LoOczQly7dYUNxF57K6e8e7x606p1kzrDyoYvzR0ky0GOatxz+6nK6Lq4o+7XF59OxyGCkUFQUGNo3BYHK5QJhAGld8PTYUrhAeDT+TZVI5PNQKo5hzm4i+lsEgtTS9TPGtUk91RbdXjOgmoK02ltO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 22, 2026, at 18:19, Michal Clapinski <mclapinski@google.com> =
wrote:
>=20
> Currently, if you enable HVO, DEFERRED_STRUCT_PAGE_INIT and VM_DEBUG
> the kernel will crash with the following stack trace
>=20
> get_pfnblock_bitmap_bitidx
> __set_pfnblock_flags_mask
> hugetlb_bootmem_init_migratetype
> prep_and_add_bootmem_folios
> gather_bootmem_prealloc_node
> gather_bootmem_prealloc_parallel
> padata_do_multithreaded
> gather_bootmem_prealloc
> hugetlb_init
>=20
> on this code
>=20
> VM_BUG_ON_PAGE(!zone_spans_pfn(page_zone(page), pfn), page);
>=20
> This code looks inside the struct page which will be uninitialized
> for hugetlb tail pages, which will cause a false positive.
>=20
> So let's initialize the tail pages before this happens.
>=20
> Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
> Signed-off-by: Michal Clapinski <mclapinski@google.com>

Thanks for catching this! Your fix is perfectly correct and addresses
a real issue. I just wanted to let you know that a similar fix was
actually submitted a few days ago in patch [1].

[1] =
https://lore.kernel.org/linux-mm/20260612035903.2468601-2-songmuchun@byted=
ance.com/

Muchun,
Thanks.


