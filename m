Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0F80CD8C92
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 114566B0005; Tue,  9 Jun 2026 09:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C56F6B0088; Tue,  9 Jun 2026 09:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1D306B008A; Tue,  9 Jun 2026 09:06:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E01566B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:06:43 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8758EA058D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:06:43 +0000 (UTC)
X-FDA: 84860398686.19.70C3C99
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf26.hostedemail.com (Postfix) with ESMTP id 108F0140005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:06:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SvSH4jPB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781010401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o4G/6dMhsGhQ3xyO1huMA/GT5WeZwLaeB/f24JGzosc=;
	b=QAIeg+/xPXe/LS8G1bgSktoOZ6odAeWuO1WYyBYX6KIsF4IWOfSOXqFHXVlBEEcxKxBFOD
	lCA0MDFgxpWymRM17dL32+OYAwr5om8tw+BLI6z3QeFOXwsgyCM51lZS9gsRyYG6E2lqTr
	tdlJpxul6nlOMPyzPULSuFQpeF1BbDA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SvSH4jPB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781010401;
	b=jY9GXKWeWWt4EedvN24KXG7H4Xk3iObXnK+l3RjJ77OcX3wq8TQCpZiq1QowV7MmEF3CEL
	Qj028RJPIBvkfUqR6Wn2M1/cXQDla8aSquT4bJxvA8YRgC5d2WNIb9OLfiSzMKCsIENtLB
	5W6E4LhLPWcZrHUqrTzt1d7LL3k0Sjg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781010396;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=o4G/6dMhsGhQ3xyO1huMA/GT5WeZwLaeB/f24JGzosc=;
	b=SvSH4jPBiZx6/u4w919Lh0Jyx4oZWxts5ve2CAID2ba5LW0tFiephKSfNbvlxjweGeHQAf
	sUsCReJH8CKpTisYRwn/XYlbH/9Xk9t8oRAigvun9R4XcrvGG8JBopJ2CrHsAvLuv6ZZ/K
	wQLXqnYumkQau3eEaV6aVnpkB5jwAX0=
From: Lance Yang <lance.yang@linux.dev>
To: xu.xin16@zte.com.cn
Cc: npache@redhat.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	usamaarif642@gmail.com,
	yuzhao@google.com,
	aarcange@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com
Subject: Re: [PATCH mm-unstable v1 2/3] mm/migrate.c: Prevent folio splitting from interacting with KSM
Date: Tue,  9 Jun 2026 21:06:11 +0800
Message-Id: <20260609130611.88058-1-lance.yang@linux.dev>
In-Reply-To: <20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn>
References: <20260609201202615oT6yd_LtIoKkGLksFaCha@zte.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 108F0140005
X-Stat-Signature: ortx48xuy4sgpofiyajpbe4b63tyjru5
X-Rspam-User: 
X-HE-Tag: 1781010399-191358
X-HE-Meta: U2FsdGVkX1/XndM8TuVs6ojqphk17smS0R8b1RfwzYZ4uTCvGcNobz0B9JZqClOohw1hZQHDWSqJ5rIozgyO4j+abeoAO+UKwWG0TMjb5cBq4GjGQILWcBDYNcDFFjMUgYY+h2q7UdQGmPRNuMmlPMJQRC/e6B0nTR/5kwhhHwkOsbAsyqRq0EA12blpOeUe9a05XQZFgGmU4vtWdNfVsxz4/FBftgWl2880yXMNvkodNmYIB2548AX8wpY4Zdr3kWyPX/5eC6xzzOVqeVhlbVWXC5iXUhGcEmBo6BHp1XnSq9rYymKyJCVLNKoV73jI2gjsOpoqDfZsiG/kzlTlPUZTDtvx5VlrDjbTGQcaN4KJsuxlZe2DFGMdIoCCCUXA9Xv8L6TsHd2ALNvu7lZF7fLf5Cf2tBIdDe1FpAIDXjfQhRRd2ch41c9esAMWlxOnjLmnbiBpupxf9ovasm0Ei/0axOfobt4Jw6hBA5SvG+IYzUJ13ufbPBGq6nyCfIXlJRWUMmigXG2BxpiUPPFhYfp4ADfZqQglOwubWK4B8R/VFOV2DKk8DnxSc4BpVH9QcuP8mmmbx00YboMkz9kSi4v32SKsPB/OBNsvrYv732Q5Xo66lFQtZ4UQEhbUoJapfjjLNPez5FijOliIcl4hchiFfcWVwux6HDgUJlN/yzHvjevLjF+P93lgR02o1TgBi2KY67YKsZNh7182FD/80/3gKZECGpIrBH7chTcbornXUmyDVnhoqeM3A1z1n7OUvnWV5SI8+6jI1lUOd9bfSSernHp7rIjW4EkyT8mnGBYVg3fUHp3gGOuBVPqRxrG+7r5QXKvJKXA6AWCtpbSfoIPZJk9Rjc5ZY9an5ygo8s17ySA3y4A8miyE0NJk474ugjIZTeQZox8QN9j8M8v23YSZYowOlE/MUqu5Fm4vwSlbc+zAOBJjzbtH0Xxiw5X7rviLVqlzISYZxdcQszp
 PoGFwpBu
 Xfw/m6bMq05gEI3r1uM3B0l2v1W+O3tI2koHckY8N+2d2ZMsMHMuWcWqPRdA9cGFf2j+r2eYAM1fGDMF/Fse6Ql5W1vdcsPczDFZoIGD/ko/n4TR1RuniLXxLF3yWlZXCnzmib7qTzJbNis0I54R8lX8KPfg+QFthq9dPoqmeoRcUg9Bri4k7ln98MPuqK4YSJJOa8+mYtoKf8aHKTuBK1SRgpTtMv5nnArEuB/YKSxspsK4BBpksKxO8zBJWSBz3KkrSK14qok9YfD/TsPdb/l8pJNyFQk3ohqhxW2WZRA/AAzwu9VBPcfpCy/OTRmn8uMuKB74O7Not00a4qwqAkWlHCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Jun 09, 2026 at 08:12:02PM +0800, xu.xin16@zte.com.cn wrote:
>>Since commit b1f202060afe ("mm: remap unused subpages to shared zeropage
>>when splitting isolated thp"), splitting an anonymous THP remaps all
>>zero-filled subpages to the shared zeropage via TTU_USE_SHARED_ZEROPAGE.
>>This flag is set unconditionally for every anonymous folio split,
>>including splits triggered by KSM.
>>
>>When KSM is enabled with THP=always, this causes two regressions:
>>
>>1. use_zero_pages=1: KSM calls try_to_merge_one_page() which triggers
>>   split_huge_page(). The split remaps all 512 zero-filled subpages to
>>   the shared zeropage at once, freeing the entire 2MB THP when KSM only
>>   intended to process a single 4KB page. This bypasses KSM's
>>   pages_to_scan rate limiting, causing ~1GB to be freed almost
>>   instantly.
>>
>
>Why do you see it as regressions?
>
>AFAIU, KSM and THP do often conflict with each other. THP tries hard to collapse
>a huge page (which may contain many zero pages). If KSM is enabled and part of
>that huge page is mergeable, it can easily be split by KSM, rendering THP's
>efforts futile.
>
>Therefore, in our actual production environment, we typically avoid making the
>same region both KSM mergeable and THP always.

Right, some setups may choose to avoid using KSM and THP always on the
same region. But that is not something the kernel can assume :)

David noted in the RFC that QEMU may use both MADV_HUGEPAGE and
MADV_MERGEABLE, while KSM can be enabled later system-wide.

And I think Nico means something different from KSM spliting THPs in
general.

KSM has been able to split THP before. the new part from b1f202060afe is
that a KSM-triggered split can also remap zero-filled subpages to the
shared zeropage, outside KSM's own use_zero_pages/pages_to_scan controls.

Maybe the changelog could spell that out :)

>
>>2. use_zero_pages=0: The same split side-effect occurs through the
>>   stable/unstable tree merge paths. Each pages_to_scan iteration
>>   triggers an expensive split_huge_page() that silently frees 2MB,
>>   while the scanner wastes cycles on tree searches for zero-filled
>>   pages that were already freed as a side-effect.
>>
>>Fix this by restricting TTU_USE_SHARED_ZEROPAGE being set in the case that
>>KSM is running and the VMA has VM_MERGEABLE.
>

