Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD89CD10F51
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 13:50:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C45D6B0022; Wed, 26 Nov 2025 08:50:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274766B0023; Wed, 26 Nov 2025 08:50:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1636C6B0024; Wed, 26 Nov 2025 08:50:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F2DFF6B0022
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 08:50:09 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD908594CA
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:50:09 +0000 (UTC)
X-FDA: 84152892138.13.6F8EC97
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf07.hostedemail.com (Postfix) with ESMTP id 653B540014
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:50:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=NhWivFtX;
	spf=pass (imf07.hostedemail.com: domain of alok.rathore@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=alok.rathore@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764165007;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nYJjotrkxNwVzA+wabEwI8W6n2EiGBbBw3Ldq8jIFmo=;
	b=PRJq9U9p/exPmWdq2dLP1R9LNQSq6PVSrkFurpz7tC9TzL4FB6qxLzooM1pM4uAW+cebg3
	u3OsTNi1bcdM/LtNAZ9uWDmpGQIWzc8uz6yR/9LzeNpFk8gz/IFiLiqqXLA8xIXG6/aotg
	dP/RQ9X0ZoV1SoRKVJugr2b6ul4Tshk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=NhWivFtX;
	spf=pass (imf07.hostedemail.com: domain of alok.rathore@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=alok.rathore@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764165007; a=rsa-sha256;
	cv=none;
	b=61BAQh3C1UJkLvyCLXkcIThIWbgiZp2ZL0+lxFXOTV93xTKviOtRbaO/UoG4IquZW/PFvh
	7fhd+cC8CL3JTA9vIYa51vvO3MYeEji6KHuQglzdT9VlQZSMibeRPAvRy9OCapzhn0OGty
	ootk6KTi3Vq3ITIzVQEdwwVT6nJrE4I=
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251126135002epoutp034e56f3c8c3837b2c6e9f068ef0b07ce3~7krkTehOE0906809068epoutp03e
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 13:50:02 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251126135002epoutp034e56f3c8c3837b2c6e9f068ef0b07ce3~7krkTehOE0906809068epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1764165002;
	bh=nYJjotrkxNwVzA+wabEwI8W6n2EiGBbBw3Ldq8jIFmo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NhWivFtX1O5ygsumaPnKKDcK+AhAVWYBJY5gwrDWZ/yKl80rFlrVSPAF3ztr9cVNR
	 hTpbGQ4V4bwHFOsEtVQLi7bWKMv/o/8WMvvLvMAX9Ky/GQwkVIMBDcUDMDoEZcq9/p
	 hJ1LyvPpO25MUKzOIUJ4FjEGZfbi1HsucZHSRBqI=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251126135001epcas5p3880f9faacc98aa0e9555392b5e99def7~7krje6F7a2648726487epcas5p3E;
	Wed, 26 Nov 2025 13:50:01 +0000 (GMT)
Received: from epcpadp1new (unknown [182.195.40.141]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dGgt15Djkz3hhT4; Wed, 26 Nov
	2025 13:50:01 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20251126132450epcas5p123220533572f40d70799294cd3ca4819~7kVkYPkAO2180121801epcas5p1O;
	Wed, 26 Nov 2025 13:24:50 +0000 (GMT)
Received: from test-PowerEdge-R740xd (unknown [107.99.41.79]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20251126132443epsmtip1690557373ad981c299b65525802e4e32~7kVdmwiMw0381303813epsmtip1w;
	Wed, 26 Nov 2025 13:24:43 +0000 (GMT)
Date: Wed, 26 Nov 2025 18:54:35 +0530
From: Alok Rathore <alok.rathore@samsung.com>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com, gourry@gourry.net,
	mgorman@techsingularity.net, mingo@redhat.com, peterz@infradead.org,
	raghavendra.kt@amd.com, riel@surriel.com, rientjes@google.com,
	sj@kernel.org, weixugc@google.com, willy@infradead.org,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@redhat.com, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, shivankg@amd.com, alokrathore20@gmail.com,
	cpgs@samsung.com
Subject: Re: [RFC PATCH v3 3/8] mm: Hot page tracking and promotion
Message-ID: <1983025922.01764165001727.JavaMail.epsvc@epcpadp1new>
MIME-Version: 1.0
In-Reply-To: <20251110052343.208768-4-bharata@amd.com>
X-CMS-MailID: 20251126132450epcas5p123220533572f40d70799294cd3ca4819
X-Msg-Generator: CA
Content-Type: multipart/mixed;
	boundary="----on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_35b0b_"
CMS-TYPE: 105P
X-CPGSPASS: Y
X-Hop-Count: 3
X-CMS-RootMailID: 20251126132450epcas5p123220533572f40d70799294cd3ca4819
References: <20251110052343.208768-1-bharata@amd.com>
	<20251110052343.208768-4-bharata@amd.com>
	<CGME20251126132450epcas5p123220533572f40d70799294cd3ca4819@epcas5p1.samsung.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 653B540014
X-Stat-Signature: 7pck5mnx3my8x9ingn1pg16bq599auw5
X-Rspam-User: 
X-HE-Tag: 1764165006-909983
X-HE-Meta: U2FsdGVkX1/5CsaHvcYYhQg22VgVs6AwUE5I2NrOqqh8x9IyxPFuQ3bAc6eLMXRunucWm9Nlv4RrdYx3NtTajZTi6Qjz0gwuZOGzjqJBzcrUyZRU92zwz2l679QcoyjBfggoVhiM+85YDDVM60FI2A8l47axWcHvo0qTBkozdB7MPwk/5tS9Lvic9CmdC9frVKOyWYaq4w1OV2fYKNgz98OzXSXQp206odALSsblplpwNcF8m0igMJu13ci5bWZzKwBh3miPD+n2sRLKso5NdGIEsA/xsbt5vyxwzZ/vzunzDtkBV3rH4ucLtYZGsNLKotZe9+EgU9jJKFG99+RkEVbUU7aNPJO2DUsXLUckAawOb8iPRUd9RkdjB/Op0H0/2A4lLFZUOyIJYduXNdJqYrOSN1++pOb0XmPsSuYOZDMvxpANl1hQ0tGkegrDBw78YYtRNW7lKDUeDCbOyqvzbh8sT29ERy1s/royttdel7CTys88Fvbcy74wnem2JhWsBLXFss/2Gw9clvulfo9wNXQwIQx7T9ZRAk7qrptsW/dYziC+V1zs0N2xaSllnu0wus2JdaaPvIZTLx14NRsromhesnhImeUUJ5uedqiIK1yC+TbPLY/Gmu3O/k2yVunZuenIcjYajrepLAj7lIlgzqUgJuHRfv5xMZQVkIQMMRsFL/DFwNIWPIV1yx3WoPbaTPr+LYHBTDcGRszezG24p340TZV9yPyJU0lLO0qbHRGD+yQKzCftfKwSbW90nF/mA+PIVfRoY51WjRjs8d4UVQ1d44lTcVC11QygWbwfmhz6ca6tiktio/iZyoJptmeUlfT/4BZ8YA7eTjl/860pqTAKzkrvzPxcIvCZERrO7iI8IOJliuUCulaJtGPkQw4uXc4IYAHZJ51dnf5G9R7op8ZkK0WBEec1blB71h//cJH03J3QaXjFM8rhW/F6nOQvBNbbRtUbctfO5r5jP52
 Fb86nlwQ
 91AqJA77jFL+1JxVn9Qx1ENXUez3s3TDkyLtjZCxJIcs5KlyRTCbYnIznmMX/IBNw+GUdoMvy3xR7ADl4pSK6hA+eeOzFWhQJ/nS3AQcESN1YtEQimSqSxwrZI3nHe5cUoAHEOh5evjbEY7G3QGnE6sDkD0rkLoqq8VdqyCvE4ukAlQuAf2pfHrrMN++2SAmTS+osDdzbsEXxzlilgQknMPBsxd+JPdxJUaUz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_35b0b_
Content-Type: text/plain; charset="utf-8"; format="flowed"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

On 10/11/25 10:53AM, Bharata B Rao wrote:
>This introduces a sub-system for collecting memory access
>information from different sources. It maintains the hotness
>information based on the access history and time of access.
>
>Additionally, it provides per-lowertier-node kernel threads
>(named kmigrated) that periodically promote the pages that
>are eligible for promotion.
>
>Sub-systems that generate hot page access info can report that
>using this API:
>
>int pghot_record_access(unsigned long pfn, int nid, int src,
>                        unsigned long time)
>
>@pfn: The PFN of the memory accessed
>@nid: The accessing NUMA node ID
>@src: The temperature source (sub-system) that generated the
>      access info
>@time: The access time in jiffies
>
>Some temperature sources may not provide the nid from which
>the page was accessed. This is true for sources that use
>page table scanning for PTE Accessed bit. For such sources,
>the default toptier node to which such pages should be promoted
>is hard coded.
>
>Also, the access time provided some sources may at best be
>considered approximate. This is especially true for hot pages
>detected by PTE A bit scanning.
>
>The hotness information is stored for every page of lower
>tier memory in an unsigned long variable that is part of
>mem_section data structure.
>
>kmigrated is a per-lowertier-node kernel thread that migrates
>the folios marked for migration in batches. Each kmigrated
>thread walks the PFN range spanning its node and checks
>for potential migration candidates.
>
>Signed-off-by: Bharata B Rao <bharata@amd.com>
>---
> include/linux/mmzone.h        |  14 ++
> include/linux/pghot.h         |  52 ++++
> include/linux/vm_event_item.h |   4 +
> mm/Kconfig                    |  11 +
> mm/Makefile                   |   1 +
> mm/mm_init.c                  |  10 +
> mm/page_ext.c                 |  11 +
> mm/pghot.c                    | 446 ++++++++++++++++++++++++++++++++++
> mm/vmstat.c                   |   4 +
> 9 files changed, 553 insertions(+)
> create mode 100644 include/linux/pghot.h
> create mode 100644 mm/pghot.c
>
>+

<snip>

>+/*
>+ * Walks the PFNs of the zone, isolates and migrates them in batches.
>+ */
>+static void kmigrated_walk_zone(unsigned long start_pfn, unsigned long end_pfn,
>+				int src_nid)
>+{
>+	int cur_nid = NUMA_NO_NODE;
>+	LIST_HEAD(migrate_list);
>+	int batch_count = 0;
>+	struct folio *folio;
>+	struct page *page;
>+	unsigned long pfn;
>+
>+	pfn = start_pfn;
>+	do {
>+		unsigned long nid = NUMA_NO_NODE, freq = 0, time = 0, nr = 1;
>+
>+		if (!pfn_valid(pfn))
>+			goto out_next;
>+
>+		page = pfn_to_online_page(pfn);
>+		if (!page)
>+			goto out_next;
>+
>+		folio = page_folio(page);
>+		nr = folio_nr_pages(folio);
>+		if (folio_nid(folio) != src_nid)
>+			goto out_next;
>+
>+		if (!folio_test_lru(folio))
>+			goto out_next;
>+
>+		if (pghot_get_hotness(pfn, &nid, &freq, &time))

Better to remove freq value, it’s not used later.

Regards,
Alok Rathore

------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_35b0b_
Content-Type: text/plain; charset="utf-8"


------on9-joxjuqL8vLZJsXK9p6vuNy0FCcc_Bo-VMubfWYorGk78=_35b0b_--


