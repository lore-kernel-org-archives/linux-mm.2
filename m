Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B069E9E301
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 12:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B65C6B0005; Wed, 11 Feb 2026 07:55:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 164696B0089; Wed, 11 Feb 2026 07:55:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 046316B008A; Wed, 11 Feb 2026 07:55:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E86196B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 07:55:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 79FE4B89E4
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:55:23 +0000 (UTC)
X-FDA: 84432171726.14.9875E8F
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 933F480007
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 12:55:21 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWq7b2JH;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770814522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=+YanjR3U4weMG4VW1vewWJqflQleiBR1ZTIDoCsnaFE=;
	b=YSR+uvG0tTkAs2dwUOQj+rxYoYlAWEr5ZjIZoJbnbpgXRQyYFBiVr+4n3IJdWWaHf7CA9c
	DK6H21mnHGokvEq3JzLkEeME0983vrhP82YRc1YLgVO0r6Ip1vtiuAjNiPhfuXJKuR47Aa
	8MPpxyUvPzNRFMJjh3vetz7lgohFzU8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SWq7b2JH;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770814522; a=rsa-sha256;
	cv=none;
	b=FG5ZD+po1fpVPhbSml6kT8FwlzJvrF7nXOl/9aF5isU1IyqUQRiPECZIzWeHkx6jtsntHZ
	Y63ym6053IEQlmcE+8YS1NFRs3Y+qAp8spOyaIkzDGXZRspeIr8pXFS+8PyNMcCF+Byj/L
	Dhcs7J8lpNDND+S4cyJg+gjwroRMKmQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770814519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=+YanjR3U4weMG4VW1vewWJqflQleiBR1ZTIDoCsnaFE=;
	b=SWq7b2JH1CPOwxMheZnHimW9HJpL8AZg6obmI0m2dIL+Pom0a96tDKGXBlm8ruKKKsFrn+
	TnH/GuegF2B4bovwZO9eQapE+u5h2PEERC2fOJL4Wx93p3PofpYC/8qjmJhDNI7R61Z2sX
	OwEvT520XSi/SJcKyf0n2epz/VtjbD0=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	willy@infradead.org,
	linux-mm@kvack.org
Cc: fvdl@google.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC 0/2] mm: thp: split time allocation of page table for THPs
Date: Wed, 11 Feb 2026 04:49:44 -0800
Message-ID: <20260211125507.4175026-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Stat-Signature: 6fnd544whfqe6dyc6pnf1kjyny4dr19z
X-Rspam-User: 
X-Rspamd-Queue-Id: 933F480007
X-HE-Tag: 1770814521-950610
X-HE-Meta: U2FsdGVkX19laRw1RZieeQAUuk0ahcIaEVRTsp1x3pVsxPqYVRCCOY9Vx5+ml0S7JDtyHGwUdWYQvFt0yzv1KsHVn2wHMU+h1Zl6fYS1FUE7eKFOUY23qHPMtSMxylcRWw5Yj4l4vc+DOBuEOhLUFoCTBo7AJKdWUaFOp2T3X4YswDNtj99gywNyu4A94t7qc47jHxRAhXLbK6V7RAsvqXnHE7FmZYpZfzhs0ydo6Y9dngOixv2PUqvAT/Hn1sI0jyvgn8ySuXpTIqD5pmqDmN4Ahjg9IayC6n3mZNun7kDzKLCyGLsqHJ8VMaV49ktVtSSRpet4lcgP//UVmmvLfZM77rP8q3LT5Xf2OrhoCxUWddCTflJarXeFjjvj0Acnc6Bf/ZyE2jsIju6bdSdLVRXJLMMj1AhJjxpI9x3S8LGTvxF05h1IAOow3rI7os1h30lEo2y6xVOwX6tzZLPiFoiZyspiEQ6gq6TYEUC6NveCysUXE32GgvMGV7PYjFDFwKFeoKDdy/vXDaAFlwRefMLnMKlzPzSRotJGdDYaF2Kpv2kZUq2U9K07z3ZhCfpei92KbcGhLAS9i6ikRpbKLGR0+6UwW/A4zhuyzxhLK/KKeQ1I+ZpDZGcaFFvjInzu11/LAPM7FeAladAXkmiXXdCedKtTBzFqvojkMyxQMwizH9Q3SQ8KYj+J1aoiwSwZrbcsUAySF3EPDXywIydZdTOVy5pqYoOhUsnpcSmaYMrlaLxWekJ6qEpNxp1/cAlfPMY1JSAHbSJs6lk+GdxiDjSS9CtN0MsUvv5sk3aF+u18hIEe9VFgFOnR52aaltDuuAQ5itKU4iRmFpZz/cwGWyUR0ge/cxWanUaUzpvjv3qzU1STRJwZh/8OJlLD3FVNT819mnauWS9uSQ89DCMACrRA8gGRnvUh7jTc2gdbp4pAXjHqc7/UpO1RGKOvJIgG1eiO9mU+G6SyykLnY6I
 6H+MFe1+
 NV83DOIMVMVJKkhNEIBrnBZF0ZC3e95RvYikDrJI1zpHssR2rco9c9QEeYllTbSS9Ppsp4mgPKgfGSfCLNCU5aPHgsnGq1A/UZ9iBupoBSRfyPj8Z5C2M/Qmc5CpnH8O3s5qrZvPCqbnKO15u2dQ5wyQNEH13VQOW14n7ejklH3VW+3U4+hFiUK3Xx4Oxtu3mTdKO0vzZv9W8bdGsEQaN4V14HHw+SG+jUm4h
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is an RFC patch to allocate the PTE page table at split time only
and not do pre-deposit for THPs as suggested by David [1].
The core patch is the first one. The second one is not needed and its
just vmstat counters I used to show that split doesn't fail. Its going to be
0 all the time and won't include it in future revisions.

It would have been ideal if all pre-deposit code was removed but its not
possible due to PowerPC. The rationale and further details are covered
in the commit message of the first patch, including why the patch is safe.

[1] https://lore.kernel.org/all/ee5bd77f-87ad-4640-a974-304b488e4c64@kernel.org/
 
Usama Arif (2):
  mm: thp: allocate PTE page tables lazily at split time
  mm: thp: add THP_SPLIT_PMD_PTE_ALLOC_FAILED counter

 include/linux/huge_mm.h       |   4 +-
 include/linux/vm_event_item.h |   1 +
 mm/huge_memory.c              | 145 ++++++++++++++++++++++++----------
 mm/khugepaged.c               |   7 +-
 mm/migrate_device.c           |  15 ++--
 mm/rmap.c                     |  42 +++++++++-
 mm/vmstat.c                   |   1 +
 7 files changed, 162 insertions(+), 53 deletions(-)

-- 
2.47.3


