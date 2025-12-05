Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D3C4D374A9
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 21:36:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADFB16B02EE; Fri,  5 Dec 2025 16:36:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A263C6B02F6; Fri,  5 Dec 2025 16:36:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A0276B02F4; Fri,  5 Dec 2025 16:36:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 61B446B00E7
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 16:36:09 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 099FDC0326
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:36:09 +0000 (UTC)
X-FDA: 84186725658.14.AC82053
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5E7291C000E
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 21:36:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6gXd2v5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764970567;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=XGiv3We14BJLmRbphPGhrv8Kx39gqocOroynlyNGD8w=;
	b=8dMzQd6ycgt0ShVjyOmLbL9W/b2D20CNvzUZbx4JxCzqmKT6XIstSslCmbcJhJeX16B9CF
	tQ0UEerpECt6UOlANSPJzEuPINZhpW1ZVuxQOmw4U46iYGCkWfnjCIMWfi6AXE9wN4f/8N
	LscYCiM670st7RdTLwoiN6Ep1nTBXaM=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=J6gXd2v5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764970567; a=rsa-sha256;
	cv=none;
	b=b+ymW4Bc6DhrXLmfK0cMFLEgL+qcvOMzDloepsQ3bw3y3DLCGrPb48q3EPi9vKS0SFx+QO
	a7uMlIL87+VJEAPIqMswNKlIcR/h8HgicDNUNE+qEV8c6+t5KwKJFiE77sEAXUgQgakcRo
	0Db//M3lz9uDr+hzI3sVv9F4d+v0aB4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4B273402CC;
	Fri,  5 Dec 2025 21:36:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3A5C4CEF1;
	Fri,  5 Dec 2025 21:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764970566;
	bh=SmK7Ck94rcMb/nZuAfr0WquYmOB6LidxVqvFllEvbKw=;
	h=From:To:Cc:Subject:Date:From;
	b=J6gXd2v5B95kbT7ObYEcdKRqlGCikeYA9no1qt/38gWKs34tiE2Ulspg1f7qNmYFB
	 yqTVfyyn4J6w6IsS81ljM5Zy6H4Sm/VkQRLVa2gDIXq04ra5T16HH/eXCLZXuPt6cC
	 dSjF2zZqiyzDA2J39z1tZi/AD45qd/uYDw+cwfX0EvkCZwqRXbm8edHNCyHJ5yYFye
	 B4B24/JC/loo+lLWryssWPAWsREo0NvaVi2ODAy1bNUnQGF/YRf367FP6G0JQtJe1H
	 8yG/95N3q+jyS87oeAl7+uB7vsbos2bSB/LLS5lzN/zoY5QYZgxDBqn6k9iqQxkV6G
	 6FhB2KpLl55iw==
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	linux-mm@kvack.org,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	Will Deacon <will@kernel.org>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nick Piggin <npiggin@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry.yoo@oracle.com>,
	Laurence Oberman <loberman@redhat.com>,
	Prakash Sangappa <prakash.sangappa@oracle.com>,
	Nadav Amit <nadav.amit@gmail.com>
Subject: [PATCH v1 0/4] mm/hugetlb: fixes for PMD table sharing (incl. using mmu_gather)
Date: Fri,  5 Dec 2025 22:35:54 +0100
Message-ID: <20251205213558.2980480-1-david@kernel.org>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ecc1w7473mr9mcjpa9jagq6noncer1er
X-Rspamd-Queue-Id: 5E7291C000E
X-Rspamd-Server: rspam06
X-HE-Tag: 1764970567-440906
X-HE-Meta: U2FsdGVkX19bEC8THsOg/TU9yvgwFaZEDMZNtPO6esq8mZlOp+TV3MUOcPRi0fti2ZFJGIhNjopDYtAAcEihS6pRwn1WRsw6+PX9WlNTYuchnt8cA0wD9HL/KuGqMPJEBKLw0YT2E/oT6RioBsVes2JwnS+/55EnZJt5CtNjOZZrDJc8YH427brgH6NcCbZbhF6ZG2tDDYaj4kzdO6ghIeH5nudyGhR6FejcBKiyE6r8ClW4lV2wZcbYYmxBoh7tF/SbaLd+dCk+VvbMUjMhL7yljxhGHE3m5LhHe55ZES6EvqtSWmYIYqfSE0RkQz7xGC8VonhWMXtwz0bNjW+FV0f2Y7j3yXWaBkabA8smn3S3ZfJl+kJtdJq3Wkc8uuBWaaV6jiY49K/ekhQ8hrZOcL9IvJUFMcUnkVHAS6aLzpEyQt4Kds1rbhMTk0iLvfF/mGhNTL73vlQ10IrxT0OFUzjG0NTsPG9s8GxeA3541U3ewjKJ0VUdqvcMQ/MuhfsF5XpTaKmT4TSZjWV35MJcfePaE+skGBBa+ISu+gHu4Cz+L9wySg6Ulm4jh5rxebFVy+4bp3BPvmyyOscKcGKCYNvebJhBossKaEva0hjT8aT14nzDPOfNnRUH0OiR4+PCtiIUZ7OwxkUxqYWzLg6PX/xPnN8HzsOupfGkDEA2zYC5hf31C6qgtgQPAdPnAY7B+7TF5c3WFbn4U0XifgS1UwjHKxu5Yzu/U/rNwlC5qpEw7JYxGbEjqUDoRtVN09rLzNBdxpBnpR1dX7DBb6v9E5YmdQXrtVyZATNAd6D9Ixjr2PJfcpk6ypdcXi/+7zdmGYSzmm2FGCsfZg4OGa0+e3QgnyyyLI+FYET3dwXks+c+lR/r/EM0v3zXBoNwkRHww4NoFDzZqOIT3JZyGwUsChQNn5mEq1nYlm+UzR4aWj/Wj+tJ0/n0Kyw7lTGj15UgCJ1vapOzxHNZQIA8JN0
 Hzfd4Zqj
 vkoKvdkRv2b22e3CiztBmvdCRV6QvscgkUn//+gWqwbU+6ENYr0AzQxZCqeSLArqgNLUDK9+j5Mg0SsgCSIjJNQ4BomxmBii7jsUtzqGR2SvzT5414Ih74FDBliQzGr50s6gtr+8aZavVoDDjzSE4NtgP9jZ8m++q/Pn2mrfL/4+tkk3RtS368Mhra+awHSGY6z3gtEC2Px1OkIfKpVg+CBAKIeE2pQMPrECQeaczw7/YcPsfvUFmPo7zMC51kBux4zYJRpMy3PCXfxXTPb1WpYUCRYZpwiaoRSdktIWqJmLesBMEkt4y0rNt8O4K0Ojf0Hogx6zHaC3EMBtGA1xNsByzQVcznzgxT4jBNljv29weGzWP4chj3uVyqtGKukhuwBqBlaohBLEZuUbBGuRGke9mNpueWJzsvEDBGMh4Pfl1pg2lZ00jQFp4bbDNwdLt9xvHLIaAUOEH0FPHyQ0hr+WfKEbxyxuvaPssSCGxVCFhTvVTOSSC6skW9WUxSe5U9WN8bbg6bYdaCjA6lu/QQfKO5O/f13ie7kmCzDXCBYlRW3fC1sLqCT+piFjxeGf9DgnnPinEeoUVU6mbA5UcEhRqTxYqGwWhIt/EnRftXGGKRPzledgOSsqMcQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

One functional fix, one performance regression fix, and two related
comment fixes.

I cleaned up my prototype I recently shared [1] for the performance fix,
deferring most of the cleanups I had in the prototype to a later point.
While doing that I identified the other things.

The goal of this patch set is to be backported to stable trees "fairly"
easily. At least patch #1 and #4.

Patch #1 fixes hugetlb_pmd_shared() not detecting any sharing
Patch #2 + #3 are simple comment fixes that patch #4 interacts with.
Patch #4 is a fix for the reported performance regression due to excessive
IPI broadcasts during fork()+exit().

The last patch is all about TLB flushes, IPIs and mmu_gather.
Read: complicated

I added as much comments + description that I possibly could, and I am
hoping for review from Jann.

There are plenty of cleanups in the future to be had + one reasonable
optimization on x86. But that's all out of scope for this series.

Compile tested on plenty of architectures.

Runtime tested, with a focus on fixing the performance regression using
the original reproducer [2] on x86.

I'm still busy with more testing (making sure that my TLB flushing changes
are good), but sending this out already so people can test and review
while I am soon heading for LPC.

[1] https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/
[2] https://lore.kernel.org/all/8cab934d-4a56-44aa-b641-bfd7e23bd673@kernel.org/

Cc: Will Deacon <will@kernel.org>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Nick Piggin <npiggin@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Rik van Riel <riel@surriel.com>
Cc: Harry Yoo <harry.yoo@oracle.com>
Cc: Uschakow, Stanislav" <suschako@amazon.de>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Prakash Sangappa <prakash.sangappa@oracle.com>
Cc: Nadav Amit <nadav.amit@gmail.com>

David Hildenbrand (Red Hat) (4):
  mm/hugetlb: fix hugetlb_pmd_shared()
  mm/hugetlb: fix two comments related to huge_pmd_unshare()
  mm/rmap: fix two comments related to huge_pmd_unshare()
  mm/hugetlb: fix excessive IPI broadcasts when unsharing PMD tables
    using mmu_gather

 include/asm-generic/tlb.h |  69 +++++++++++++++++++-
 include/linux/hugetlb.h   |  21 ++++---
 mm/hugetlb.c              | 129 ++++++++++++++++++++------------------
 mm/mmu_gather.c           |   6 ++
 mm/mprotect.c             |   2 +-
 mm/rmap.c                 |  45 +++++++------
 6 files changed, 178 insertions(+), 94 deletions(-)

-- 
2.52.0


