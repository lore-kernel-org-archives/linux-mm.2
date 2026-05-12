Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 927F3CD4846
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 01:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 04DD76B0005; Mon, 11 May 2026 21:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F40DB6B0088; Mon, 11 May 2026 21:31:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E56286B008A; Mon, 11 May 2026 21:31:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D8AD06B0005
	for <linux-mm@kvack.org>; Mon, 11 May 2026 21:31:22 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7504A1C0D0E
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:31:22 +0000 (UTC)
X-FDA: 84757040004.07.291AE41
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 99CD040002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:31:20 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bUFTzikz;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778549480;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2s3DmGTPcyE7UTkkv6Q76s5ddvz4N23RVr1DzkExic4=;
	b=FoHLZ4YQVWyrifzAy5y5h+j1hz4lkxanhqZwVNglCUWWq61emx47F166km+4aJNZwi6zQr
	szs+60YIo/UYicZnCwljQqjkuG/h2KK/w+EovVjIL1wNxGHUHJ5lq2saQgbhtpjglVpmHR
	ywR2HV3IdGY94jkn5GS8B/OIZYfiNZc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bUFTzikz;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778549480; a=rsa-sha256;
	cv=none;
	b=Cgx3/UFvTvXzCTwU9ZL/iDySe4vKQq92TGPzuKqBlKxhGhFYNyLIXFG4l9mv//ImJhOcbx
	5DeW5f5InNJ6ftwyI1cXsPTT3kjQgNBHwZpmiwe/NRme35vnDFq5UJmaud+Qy37N8tL90D
	85dRFV9wjlTGetNhCBK3WCRjzkkLwYc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3BAA4171E;
	Tue, 12 May 2026 01:31:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5664DC2BCB0;
	Tue, 12 May 2026 01:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778549479;
	bh=LwUaYMXJHdUhH6+TL9aRCB1P0uKI2mUXjW0mb49u3oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bUFTzikzItrtUlko3n6C3LvCjx/JvnCMWkKLdlem/PpTyZE/FGS+Nq2o5AY3rDAaa
	 NgBo0S5Ih821wBlAQ5L4oaL5YIDF1i6kg4l2I/3K1EDCatj7I95X6A/FAo2ubM3hoH
	 CbD/zhbR7PNelKLBIPEFyzZ8Rgylqp0pK+eTMB768ZxsTNRDM9pubG2GRDg6d9juRP
	 IhZmXgQDFj4ojcYW1b68Z7OBPjVZ5fNKM//OTGpvLcRWVkScwvFxVJ7SR/A+vqKA67
	 B1n8xt2jxqKbMtUYsOhRjeFjcivub1YFVotx3p8udVAqMOLeR66IuhxYW7nDYShuSu
	 KpeJ2ZZvtoZAg==
From: SeongJae Park <sj@kernel.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	sunnanyong@huawei.com
Subject: Re: [PATCH] mm/damon/vaddr: attempt per-vma lock during page table walk
Date: Mon, 11 May 2026 18:31:15 -0700
Message-ID: <20260512013116.80435-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260511132546.1973270-1-wangkefeng.wang@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 44z9gi1fixwashfi1584hizo3m3nw1iw
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 99CD040002
X-Rspam-User: 
X-HE-Tag: 1778549480-285343
X-HE-Meta: U2FsdGVkX1/I6Gb7YoSvGnXfWfrAqspSqNjaejJENRvNwSmNpIEAIlbGuEkCzqEDtk0fYmOZIJWfRvbV8xm4vP5l03oWb4ghHj9JzNDjKRJmtz3nEjsT0E+jjRIp9rkr8ZLGnmNTIdDKHuwyp2Cq82wRunY0/EeqPqm6QsJikj8GOjumYoWtNisH0oqqrtdH2+THh0QbhHNtolSJ32uIB8lOHiA++Eo/0f8sr9jmflwTaWGaYr6QscTf/KfrH46rozTmJBXESUWVp/ceU1qEvyTu9BB6lwgpBpXKDinCWNHsojc94iFpqVUf9oPqB4g1GweFdfz2VYoUvBxDGHpk02bL+/meIlp62gUZR88Y1kRkcBPvbjbVxvuAfyMHh/u8G25FNnqkLfhBRODQpxSL55SnQZWpadquILmTMXlWjlfwOz3EfiVGxwZDWiknxRrZTLfp/oBZeGHqEY3vs1a9eOjIFAnUiSy2osfAQhpO5NEHGKLvBBNS9v4oVwcIFf6A1i6m+knXlYXgIFOYEkCzKVIafQwgtCB2Xi29BX649fxmofAW/a5iOb1ifK6X3jtR09Un4oHa5H/OzfLo7p1x8mNRdRj2+3McRNNwJBaKOvWuoO7d8oAzkdG94PoAVrH4IgrJX+Mw1ZEH+n8bO6/ibBJw2gC7+eRqFI1fDPNQak3gYEmkmASgAdXIZF+VXfgrWCthrJZhnaZi4EFkY9uRk9+xU0ONsLwLj8dTFBWrxvmeqiii0mMRd0E/OLPVugC7ww+2ochw+coM6eHQnB8mZFXdGwgtT6+B5eg7DtbCJkrEIg6ifGzRX1Wvh72JtEvCBcqW7tYnewlFeCJTRRdiBY1EadS7WPEdmcDt+EWB0a0HQnYZ5pFnEvZLTvi6VKT3Jdq185TJ98YwK2+QfR0vnJjqe6bPj6LsBkN3+wWeZ4pndS9b3vZoOZrHRVsHhEH0nGfigO0ONyRSWxKz3+1
 qsPB4kB/
 47mpLNqM0UpYA97lMvc1czgFmw1rkRR06W9Bv0FOyZ35az4G6gXymiAQrpv/iGW5gzTqSjAJgUrce05i+uVB3H4Mk06paZ5+VEWm4jo0xySugtB5+3hZvPQ3CKRY+NHTd7FJwB22rm+XDTCNxnOOrD5448dV2YTNqsqve7ZgzqsMS3hsRGYoynh/Vfj9IjrFS859OKMiRfFgkEe+atmMmUd4jYWQS+1fbCzeu7yeMhBtKM7c=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 11 May 2026 21:25:46 +0800 Kefeng Wang <wangkefeng.wang@huawei.com> wrote:

> Currently, DAMON virtual address operations use mmap_read_lock
> during page table walks, which can cause unnecessary contention
> under high concurrency.
> 
> Introduce damon_va_walk_page_range() to first attempt acquiring a
> per-vma lock. If the VMA is found and the range is fully contained
> within it, the page table walk proceeds with the per-vma lock
> instead of mmap_read_lock.
> 
> This optimization is particularly effective for damon_va_young()
> and damon_va_mkold(), which are frequently called and typically
> operate within a single VMA.

Makes sense.  Do you have some measurements?

> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Looks good to me.  Nonetheless, because I'm not familiar with per-vma locking,
I'd like to wait for Sashiko review.


Thanks,
SJ

[...]

