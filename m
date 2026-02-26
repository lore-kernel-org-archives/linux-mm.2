Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70B82FC5930
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 11:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D39776B0095; Thu, 26 Feb 2026 06:33:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1B6B6B0096; Thu, 26 Feb 2026 06:33:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C27936B0098; Thu, 26 Feb 2026 06:33:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id AF1236B0095
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 06:33:28 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 74442140B2E
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:28 +0000 (UTC)
X-FDA: 84486397296.17.FADBD24
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id BF1D7A0016
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:33:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WHP1wfJE;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772105606;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=38HBryh3cdm+ftgRS5GbtNG5HBrHnG2TSvjgBx98jPU=;
	b=gARwfjNzKqpE8dQcQSa5wd1HAPkimmbtoh2h0qKiDlMqpuYJYX6Y/aQAeJOZtqd5eE3lqr
	rq4USLHtMlG3GBLUTvf2nzZv2zj+i55N0irJ3ZW2HEdxVrrxmSbJnYld/ni/pkpjuGkbn/
	BJZhMNuVxuHy7rh0aeoCgJ5p1nLM8Oc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772105606; a=rsa-sha256;
	cv=none;
	b=ydgJp+Gqn8gNFfixnpeVIBPfzzBLZQNg2z9U82LU6/PKGeQLmdgpQK3vlsDHWgmF7dPojv
	BEknXeiCBlaiyGxZZxjYQdXYa8kHwRA07E/fyMUJN6EyGVUc3a4b/g64TbQ87BruaMrx+r
	jrQLbouB8Tftx+++mQGu4jSlAcK3Tx8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WHP1wfJE;
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772105605;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=38HBryh3cdm+ftgRS5GbtNG5HBrHnG2TSvjgBx98jPU=;
	b=WHP1wfJEjiIuo805/CDPw1ZEpoyAmOLPJew54t/Qv6FjvLJsRZl6KQ9zw/ResskmnYgraa
	1InmrX9KSZwqmCAV2swDPkNm4ZtR9ljeMBHNos7fGqBRB8m2acYEuuIZAd9e5c3HR9DorB
	QqjH5/b9k2rgaJpkswdULdkEDYIRqsQ=
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
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	linuxppc-dev@lists.ozlabs.org,
	hca@linux.ibm.com,
	gor@linux.ibm.com,
	agordeev@linux.ibm.com,
	borntraeger@linux.ibm.com,
	svens@linux.ibm.com,
	linux-s390@vger.kernel.org,
	Usama Arif <usama.arif@linux.dev>
Subject: [RFC v2 04/21] mm: thp: handle split failure in do_huge_pmd_wp_page()
Date: Thu, 26 Feb 2026 03:23:33 -0800
Message-ID: <20260226113233.3987674-5-usama.arif@linux.dev>
In-Reply-To: <20260226113233.3987674-1-usama.arif@linux.dev>
References: <20260226113233.3987674-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam09
X-Stat-Signature: 8rcsm6apc3uw3cqgu4o98c5uwz18qc4g
X-Rspamd-Queue-Id: BF1D7A0016
X-Rspam-User: 
X-HE-Tag: 1772105606-239186
X-HE-Meta: U2FsdGVkX19c3ar6PfHy5B3abipr2RMyPq5wJ+Jk7Q0rsKWA8h1pGTCYPAFwmA+FroJS/p3UDbGhZyj3Ex4nDnjx753pKiRCyIf4UUtZtgW1ilpiPkQ8Dtvono6rDcKifxcngGo6hA1QUjVH4P1CZR86PTktCVEgt5t3mYrVy9M+F1A1Zfsurj1ASX8F/Gu0muadcak/Gf6klu2Uwr8Q1HIX2CFBIW5SMdQgwRp/CKd570bFGo6ecZ033PcX/yrOKZa0v1j3dB50yKgd410houLz+0y7/WANPIp34Qp3Q1WyHQG3XH6flXTvGIYBNPimGMSO84owUHUW0rLu9rP5dJnsVT7TvM4Jc/AdQpBjYAJ2bxyK+QvDOa6hoFV0WJsjEZLpHa1NFscQIpejzSvofRfF/mrEwn/DY3Jhc4kK51SoezBgFMKf/S2iAKC9ljcwrVymNBUvOY2IKg8WUcjFYM00zsSumH1oy6a8Y4Evze/To14D5azVD8BLZSR86EbCZZ/K+sfPAuAR2XQC8pcDp4ZqpUBBVF+GzoRIZpYdO4KG+FZfHw4s3VhsxK+FqJr/zYrcNREjnCg7k4QNmCU2Lt3e/g3BzNybNZ9pQEQQ7559+1N+F/zdRmxxn412rPORaKf5uMlPKaXqG5lb2smH2I0Pmd+kQJbq7Hw1qGtq7pl7xguhyO5PgbCNVR+e3B+UFtPAzWiyBiL4DrwJtx/wJBfY7LVFu11uPC1Bw02YkYLiqF+PBY/YNOlCPpa6yNO4Bs+xQtrTA0XCRrR7hO6EQj1UYLJ6PPELJSgs8Us93Nfr3ZMgGi14OYLPLo4JTnMX2yzJLkppTNa98KnPE7gV87BywFCG7fQ/RspfWqikvMF7X4vOwC11MajYQImH3Akl4AG9ymLRHx11QsGj1FiTOv1QixO+hOWgmYsKIBNBSOPCWksn4TAY3bg/T/BypBSkOXzHCfFZwE4mrL37CjF
 +kSW6vzq
 ft1dEzcI6NoCsDOVVF7UYYSzZ7c3T9fAHhWAx4rOlRNJKtRc58NYZ9xa/cwJd9H6CPMzc4q160HIlvdC2kl+v1P1LvZLRjGTrzJHINjUn6+hbpfNGPSzDUcpb6ygY7WvRTI5CQqbh2Cb2cAdxcDUEcXR2uKiPgjPvwYIPZHWedzLHs4/azevGXJb2nhsN2ol1MCCiCSMNTMmxlgvdYoJ5fiGDiJzFN7nOUZScu9NmXxtRvvbyF1PTAYwQCM+D60h24175xroR6IhaagzpK2157mgkDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

do_huge_pmd_wp_page() splits the PMD when a COW of the entire huge page
fails (e.g., can't allocate a new folio or the folio is pinned).  It then
returns VM_FAULT_FALLBACK so the fault can be retried at PTE granularity.

If the split fails, the PMD is still huge.  Returning VM_FAULT_FALLBACK
would re-enter the PTE fault path, which expects a PTE page table at the
PMD entry — not a huge PMD.

Return VM_FAULT_OOM on split failure, which signals the fault handler to
invoke the OOM killer or return -ENOMEM to userspace.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d9fb5875fa59e..e82b8435a0b7f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2153,7 +2153,13 @@ vm_fault_t do_huge_pmd_wp_page(struct vm_fault *vmf)
 	folio_unlock(folio);
 	spin_unlock(vmf->ptl);
 fallback:
-	__split_huge_pmd(vma, vmf->pmd, vmf->address, false);
+	/*
+	 * Split failure means the PMD is still huge; returning
+	 * VM_FAULT_FALLBACK would re-enter the PTE path with a
+	 * huge PMD, causing incorrect behavior.
+	 */
+	if (__split_huge_pmd(vma, vmf->pmd, vmf->address, false))
+		return VM_FAULT_OOM;
 	return VM_FAULT_FALLBACK;
 }
 
-- 
2.47.3


