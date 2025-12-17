Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45380D6406C
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 02:46:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEA5D6B0089; Tue, 16 Dec 2025 21:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A94816B008A; Tue, 16 Dec 2025 21:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C16B6B008C; Tue, 16 Dec 2025 21:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA846B0089
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:46:48 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3381A160864
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:46:48 +0000 (UTC)
X-FDA: 84227425296.12.110BC8F
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf27.hostedemail.com (Postfix) with ESMTP id 748DE40004
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:46:46 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLXG9Mp2;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765939606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dOCeQ2/1UDHoRUqDaLGh7h4kZSar+aVQ1WmFANL0cuk=;
	b=iHJHrs8fO5nJzp7U8O/0WCPCQm3itIccTCrW8++Cr5Ip9PDfXIUSvlrrfRfbMkS8jpQoaq
	flLv/7Gqn2Q40AKN6Wh5HakJ4y+Hf3iqAASyrH0AGlVLl1RfNf0IuS5D4Jc3Wisb6xgXzh
	8AzgoIEF1L1soQZ8xvTTndMQhEiRudI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765939606; a=rsa-sha256;
	cv=none;
	b=jqCIbh7WnfV6UtfuhyUwxsF9Gulj2P8fqwcd+gUd1Xniik8jRCKkwmemzpiTf5ebdVVX8l
	rJ0sQcGoPdhoypkhRwYPO3XRTRy8ot/AxRyRDljIn7nFCspkldjMVxd2QnVxsqhgk52HiM
	FjBu8Ru0HwetkWNfSffxfNGHUy1s0EE=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WLXG9Mp2;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765939599;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dOCeQ2/1UDHoRUqDaLGh7h4kZSar+aVQ1WmFANL0cuk=;
	b=WLXG9Mp2YgedbWVMHE24r4hv3aK6pqQoQxnz5iZlbyq40/oHuhMvei8u2KrBbCshdpo0J1
	mOrS0vLso3Q309KKR0cr1jmqEAFYtQE4OsEJJcoq37ooNxJLvgLsGz127VX4OanFfSO/+q
	/CEiB/qFV4SLCV5UJDwVsEQZvhrVyj0=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.200.81.1.6\))
Subject: Re: [PATCH v4 3/6] mm: cma: add __cma_release()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20251216114844.2126250-4-wangkefeng.wang@huawei.com>
Date: Wed, 17 Dec 2025 10:46:05 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>,
 Oscar Salvador <osalvador@suse.de>,
 linux-mm@kvack.org,
 sidhartha.kumar@oracle.com,
 jane.chu@oracle.com,
 Zi Yan <ziy@nvidia.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Matthew Wilcox <willy@infradead.org>,
 David Hildenbrand <david@kernel.org>
Content-Transfer-Encoding: 7bit
Message-Id: <499AC3D4-4C80-40BE-A303-6FC78CFCA624@linux.dev>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
 <20251216114844.2126250-4-wangkefeng.wang@huawei.com>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: jbbn5uibdq86agn91c3qd617f3ncnm9j
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 748DE40004
X-Rspam-User: 
X-HE-Tag: 1765939606-56176
X-HE-Meta: U2FsdGVkX1/vBCtpO+nyd1qj8SesYOFJtcJvsa2x65R+dY/d72fs2lnaLdwGLTqLOyUA7Fb8Ug76lHqdPYdy0I2BbRHv9aa/BSFVSsv4XXkMHU7QO1mf08FTeB1Br8xWft0OSC9jgD0aEM1J9vi7EZ97bMY5EnILhBM+sF7y3fPGPOecSFiC2senKeJx3KlJ0aIOx0PdBvB8kQk7GI8mCPlYpCPdwWR9LRJhHAxtyBHbv2x1GP/FnTo9kzsg/cy6yyl0Y3WXHWEP9HGcjdwKrPYifKwuJ6ebqaQeVfgtscKFTZCLdZ9y/lA2avYUro4Hqj1c/1xTYGGKFbQYn38W+nyzJEe+E1v1p4bfoB8cIpF8HUrw1m6vE8JwqtmiwXKYu4B3uFsYdiI81ZTYsMB4k+bI+KjRge5gA5HvMndl/XUAWnzkUjvj/FsnqRur8OrbrArWGqibS5fZTdM8l+zu7LZYLAtqW0FhMiEmDQHUvxKVyb4QFvAeFItcXpwTQZwe88V3CWvfDWWlS+jy9rkQ8a7P9W9KdYZWhOo74r36dP8h4fJmlTgXRIJviKdPffh32pWIneTjfmmHbGo7cI5DETuGQWTd6HV2ehwMVUReVz+d3+Jd3W8qfulKQMVECyrwGz8j/K23Et3moAuFXa4UgbJ/E2PMWJPPT7vA6gz68rqhoOO16dXGBJ5NUJOJVY5VyuKfpQ+7XSiKfEtnVYOyKTkgv8btKWKTjQcgoSGaPuB8BjurH+i+ZOMXceGR+3U16vbJ0JEpu6FYM6Lx08ku8dqSvu4mtbiuwkPydwKDpA0mOwJZFpBH8WN5esEz+8my0a2Ktp/lrjP9rJzku6Wta82jTUzF95t/uy7xdHkitFDKj5ogpUfNlpQl/Qql8tYyP1BJ0psGerEDTyBw7G70fLzO08cb4m1SIWhyoYSGpOdFLXCr1bNOBa0aMIR/Qa89XwA3HjxTBEiCoHPRPkm
 Z8vGO37b
 o2zjtAx2ET47lc4verTAdGepaM7V/n6oE5nW3mR1cYHm9hHUDFiA6imgGWZPCXZGdmtasM4gprJ3NQdhbn8y94t+JSFJidZR201VlFWHFUgZjuRF/j3oCbIFyq2JdIDp4I717o+d+DEC0OQTsJMvIA90qBIIP2hXiOiI0IHbzgf59AyTVOw5iSal2utJaQsCA2jWbzarsd8W23sZG+E8zs9VZSynMMrmm+zD5jZJSKlCC/h/56QODeKkg5aiJuInVN7+eDZGM0OYo9E0WZ/EhFesjh61G6AvdCHMc222rhOc6fhagdatfe2IBbh0d8QFxT87d1bUcke2Afzlbs+pNTph0Dv8X/8emx7/FTxLZRIJWJpLK7zj1TZ/1Wyfw3/43r8dX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Dec 16, 2025, at 19:48, Kefeng Wang <wangkefeng.wang@huawei.com> wrote:
> 
> Kill cma_pages_valid() which only used in cma_release(), also
> cleanup code duplication between cma pages valid checking and
> cma memrange finding, add __cma_release() helper to prepare for
> the upcoming frozen page release.
> 
> Reviewed-by: Jane Chu <jane.chu@oracle.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


