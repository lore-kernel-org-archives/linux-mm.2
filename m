Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C8CEFC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 03:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F76F6B0088; Sun, 19 Jul 2026 23:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8596B008A; Sun, 19 Jul 2026 23:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BDE56B0093; Sun, 19 Jul 2026 23:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A3126B0088
	for <linux-mm@kvack.org>; Sun, 19 Jul 2026 23:35:05 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C8BA4C0665
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:35:04 +0000 (UTC)
X-FDA: 85007738928.25.A94A878
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8BB2B20005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:35:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=agYQBBVl;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784518503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f2bP+bUhNIo7yhxzRHd509jBvMfe8gZ7euA6b6kD2xg=;
	b=J06AorYj4XC0wonHMVfHUbSly39CCf+i2Ak3mgqSM7GLmY4UKAANXfGKfToSzDOQXJjhUp
	YQOxuifvtZubv3rHuKE96qzPFG7UYXMPMj/ZLrtg+ULx4u0tXdMwpWH4tThYrsa8QPJckN
	te1RHgoQtP/ZeUcm4dJp4qSPJWWbzW4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=agYQBBVl;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784518503;
	b=0OZEREgXXYAh2wI/FnzqOrozMmrjEMAemUDv5tcOzzn7GI1i678lz4m3B5ePd+5fEldD6Q
	vhLsuugkAr+I3Y1U+ItsfIBsGcCssPg+eLSJBrrRw63Lnpy2bTJzJlgU1uevJaJSH0JRF0
	0kZTYKGnfUxDTmoU0rLjqqcEIPq+rTs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=f2bP+bUhNIo7yhxzRHd509jBvMfe8gZ7euA6b6kD2xg=; b=agYQBBVlNRJnYUiMEWq22PZtYA
	FbrME6UYB/Hh4v6tnwhw26BbMaIN1s0PpetJvnOFa6P81uo/0u6ZiEr9bmu9DB+SGrFkVGGJrNJed
	5N+QDWWHzWnLNwLpkSNyAvA2phocWOspIe5/XQwPcoVhPfyf31U4zQfz5Vzk3e6d9/dVDRTq4ka4n
	GKIsiNSu9pxumiPOjjvbVlYZqc1mL3Ifx26jDC8I/yjfJvVMW28vAN1vts8Q85HJyT4WgHpXsO2yU
	590YLRlm+jl+eEg/5q/+orZ0nJc04VJG19l8zo7zOHKImIwWwMcnd1c0oLBoizU9JDtTJGgPNRS/b
	W7wsVm4Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wlem5-0000000A4lY-1EOT;
	Mon, 20 Jul 2026 03:34:37 +0000
Date: Mon, 20 Jul 2026 04:34:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kiryl Shutsemau <kirill@shutemov.name>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Hao Zhang <zhanghao1@kylinos.cn>,
	Hao Zhang <hao_zhang_kdev@163.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>, stable@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v3] mm/huge_memory: unlock i_mmap_rwsem before releasing
 after-split folios
Message-ID: <al2XTQLWB12sJQG5@casper.infradead.org>
References: <20260716095424.471052-1-kirill@shutemov.name>
 <20260717195851.609269e143b4b9eb857f2a6a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260717195851.609269e143b4b9eb857f2a6a@linux-foundation.org>
X-Stat-Signature: 56hbd9rfo5xtz6q6dbfxx5ogop15ddg5
X-Rspamd-Queue-Id: 8BB2B20005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784518502-939540
X-HE-Meta: U2FsdGVkX19mDNwn4J9m3GTNgJ4mJJ9TgGJmy9DNb6YHmRjxAgRpykaWDr3RDL/u0q9kNqZGpmTqJWJlkEDfsjkq4ikQzGwLIcx7/1cZHKvQ2t2UrOqWteaUQRJGxIZQ5fcrXCgW3+xenN2egiDVTe+OXIjY244Qz4qztginkJYpFXJRxzhI/HJ7JWEsQJyHvvEd/FshAl+xy3fx6KOiqNOg2UXonW27/TYZuITHu33e3WDi3NlnfwGUbuSBnG4BDFNGVxu6GdWRaK2Cnl1mRR+bh5K7hs/TY2dxpm5PxnSPO6OxWy8qTYcNhaOitRz0IRQ1Ghad+GSbzZSnQrzrC2ymOOT6s3DVrce/tsbnKfX2RCYy8WAIwzAi/PiXIA6qciGR+75cBfgxuJ/dN5nGzGKw+r6uaa0F0oOIilW6YsIYn+wUS8HXTodU0xfXyI1OLIro3qsXNESg/dCE3WuIbE+KXDI1bwjHiUVe5MVF63hu+6/Zt34rFeQzpLVkstnTXom1LwjajGEM5FWFhb10t1BqsPGYYu5eiZbi1wcfR8/NVAPVdG9GxmCfK1TxJpPGwknt5KMpFJtSeqUmKYyhlUEuOyrqo5ahnhwZmA0MuUX0A7Lt6IpguI/g422imV1+d68hMOdDiZjYRFFQVEEB4OucuIb/IwhpZmg+E9OvExeadPmagNkCf3WUnDr/a2YNGd9Lz+/GgjoqyHbLBYBTyZWQQWjpawsOEFWv4Y9i7SeheHmCP+OBnOZgDL1bXq5uH71cUVNSy450iMdxIVGxf32WjucaldnIqQnBKCuC1H83yqEiH932GRjL8hxeFgEMIlcaAm/5uDtTW+A7/UuV6RwWu0ecD8yCCgtq0MbTLNOJ8xBTG7JYOQ6DWB3CzwbccZYTHHaX1QU+D1Tyt9Wv4KrwTKS5X7Z6Ry7heOz7JQqnyfJ1GTgkhlXsAhf10jWElkidnjfvBdsxrgSquQE
 mUIIUXLy
 rVqbsPN91WHrZQ4MluyKUXK03WQ+ShSi1W9IkvkaRSUJzKGJu2jmCPvUipGMeR4xQYwmBANbP1D6HwG+g11w+JxPgH0IApp4e/ejWy7LE4cU1Kj3WIuGfyBsN/lPyvMDXPsaYIaznDyi5EvUOLLgdR0re+gyXdZNCrzwXRTVB2N/yXRvDXT3wWSQpRi7EehG0nEosISEA9akGEwbs2HRKrh3rncK75Q6AB7mRVpXRNhwYLZDkWEFbR6o/N1Pq7J/+sMp4toIHjN6V7Vir9sUGFSSzP8kDLPsbX8t+C34a9v7Oqmpn0omtyO/jJ6kTyQ39o6jzDVi5PraLVW3dekpgejkLYUxECWnKdeGWtUxJ6EycBerRtmt2Tkk8UHq/6nZfgjsYZNI4rq+B3J0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 07:58:51PM -0700, Andrew Morton wrote:
> (why is mapping_set_update() a) a macro and b) undocumented?)

commit 62e72d2cf702

    So make madvise(..., MADV_COLLAPSE) also call xas_set_lru() to pass the
    list_lru which we may want to insert xa_node into later.  And move
    mapping_set_update to mm/internal.h, and turn into a macro to avoid
    including extra headers in mm/internal.h.

Take it up with Kairui.  And whoever it was added that patch to
linux-mm.

