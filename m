Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EC79C43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:53:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 844CD6B00C0; Tue,  7 Jul 2026 09:53:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F55A6B00C2; Tue,  7 Jul 2026 09:53:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E72B6B00C4; Tue,  7 Jul 2026 09:53:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 461D96B00C0
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:53:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D33D9A037E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:53:10 +0000 (UTC)
X-FDA: 84962122140.02.58DDBDF
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2F235C0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:53:09 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HHp5WcPc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432389;
	b=htOtJ5HseQBT/50a9LHKdhgk6+TXC1RVc2NHJdMwkS7YdhBdGpCnAHaM/MO7IL7Sro4UuT
	KUfEHVmvGxfR6nxuMxXg9PetB+/1ytsZxAMCmtTEBevy35Qyxa2aKoepu+/cjr1HOQ9wsC
	G3hwYgE8yaQkjB39AiVFNgHlyDY1M2M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HHp5WcPc;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=QHrvCBDIqc3E1FZYa+jpIBEplfGugDRdYB4bBJbLc/E=;
	b=x8Q4HWAMq02p1HMCEO3B2FzDLNcXs6qVRNIo1H74Xc8XQ/jkIBFzMsMFtQWt96k1r2SUfb
	uQZFpAeEcBTA/vjrnCkPB+eajp9LA8dAPulr7/E5IQR/0/hW8shKAu4QRppctApvqxzcti
	dxw0LcB6UusE+q7ny2+GYFCiDW1x5Pg=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783432386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=QHrvCBDIqc3E1FZYa+jpIBEplfGugDRdYB4bBJbLc/E=;
	b=HHp5WcPcftn7/we8jv3iWrulSaQUrvHAaRpXFsX1MKn8IOqSbM5dRaB0LBIzeu+u1EEfwv
	XszoZPgZOG1xXYQZAuzUKHpBJaB0+SeXJriZ73WV9avGYA5oH8PZykt2DOkfCMHIiuSjOY
	vQu5IroVVeJcUDHlh7V/Mmk4uZ8tv5A=
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	apopple@nvidia.com,
	baohua@kernel.org,
	baolin.wang@linux.alibaba.com,
	byungchul@sk.com,
	david@kernel.org,
	dev.jain@arm.com,
	gourry@gourry.net,
	jannh@google.com,
	joshua.hahnjy@gmail.com,
	lance.yang@linux.dev,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	matthew.brost@intel.com,
	npache@redhat.com,
	rakie.kim@sk.com,
	ryan.roberts@arm.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	ying.huang@linux.alibaba.com,
	ziy@nvidia.com,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org
Subject: [PATCH 0/3] mm: handle device-private PMDs in walk callbacks
Date: Tue,  7 Jul 2026 06:45:06 -0700
Message-ID: <20260707135255.292870-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 2F235C0004
X-Rspam-User: 
X-Stat-Signature: ajcyi396yhxgnpx4rm1pwrsktr6jf3iy
X-Rspamd-Server: rspam03
X-HE-Tag: 1783432389-98637
X-HE-Meta: U2FsdGVkX195Q5VSFz4ccEnXhU6BqC1POK9YJLo6NeKsWyoODdBqQNIgpqofETgGl6aG2Lcv9yPN1V+X4+9A8hV9C7AoCmPz56KB2pdaOT0xD1i5C/omeEkwJtoMWpnn7hAR75ymTxzGf11edzbc4eDkHyDIKf+6gyJkGy+hhnijSGedjKr3AgkSURtwaDiTXWxy0d4CWsyIOIakk6efmVuOFjqZUlj2rbo2zeAM//GrtEywnQw4eCck9Nm+xS9hZHZuOQGSANciFH2AdcYeqiMSc3StB4jTmndZTBZolGWb1HZCh+FGpCd4K5SPYGBgmU5R/uswVbm8XlsuGvyOD1sJydMT9UpaESohkSDyBivCoS8tzsjt8ISwLye2S6DFRWqRe7RREWcO6907Rhql0cEZr2qJ3o9VrzW9fss2x14G+95HPFmTG87JMzLjVFbB7G7DySJv53g7AdTQdJJBTudhv5vIP7i/7nHl0yusbIXlfvfE8O1ZRPQExE0fMsnQKQAtCNpebSHsh7aipqre+BE5Mg5cNpcGji/HCjX19uDTa2GiDl2zkX8mF0fNmWKOUS/K79WbxT+7YNiQTr4QDetph+TcR4XKJe/v8x5HNjANeeGUClajxh4bNnmrEnuT7rE/Obuk3iTzE2yIvL/+iH8KTKZs0PRHMHJBkU6so6uYGPzhzBmIhQYWcpfmW3gXhlA1SEcjFr2KAxC7pEDM3uy8YdNFEYp3x0HShmzq5LBGaONOgf44blQN24RYDQSi0as3rWu1Q3OMCgQNNgyR4+yWMTqb8Preti0vuUgXfr/3Q2foZdTJbjSDrcaLpUSSBvHrM57a9JY7Ugoi7uJBOh9q0k6y6pyEPFojmyVm32lUQjQeELi7gWiKxXUTUhsQNuoKDpj77HkY/33Ijz4DeD/Cxk1IJnFnLQ/9thKjk9kAEf9kJfIBqYCEXWyK3kEI2C8Wu/9Tr9tox27oq0j
 zUPMmzTX
 P9QT0CY60sYZKJq4h3a2035lQ/5D94e8CklhP5O1hbsMYGC9I7s0bDwmGEWkbpk7Yq4T62GE3/394RYSNy15EeYTsuQnBglqD6/O5T6RgYayCVFpMBCxWVmsbHor3jatsjkKiY3aws05koxFds6rjtmG7mXJpMnTfeAubkHDjKTMt0yW0av2IMg0UP3SrDNtMO69EEyCPGC34cNuA1D0XZZsYzNafdfdLgoxGENJvkPrYL2CctR88oIsz7RBU98bTHOvd0prOk4G6svej5Fo8AOp7DF/dQADVItFnksz0hToYLJWiGvz/uik6hYjatGEaFwl0e2M/Lri6djo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 368076f52ebe ("mm/huge_memory: add device-private THP support
to PMD operations") a PMD may hold a device-private swap entry whenever
an HMM-based GPU driver migrates an anonymous THP folio to device memory
via migrate_vma_pages().

pmd_trans_huge_lock() succeeds for such PMDs (pmd_is_huge() returns true
for any non-present, non-none huge PMD), so several MM walk callbacks
that used to assume present THP or migration entry are now reachable with
a device-private PMD. The results range from a VM_BUG_ON() firing on debug
kernels, to an oops on a bogus vmemmap dereference, to silently isolating
an unrelated live folio from LRU in the aliasing case.

The first 2 fixes were reported as pre-existing issues by sashiko in my
PMD swap entry series [1]. Hopefully sashiko won't point these out
in the next PMD swap entry series :)

[1] https://sashiko.dev/#/patchset/20260703173903.3789516-1-usama.arif%40linux.dev?part=6
 
Usama Arif (3):
  mm/mempolicy: skip device-private PMDs when queueing folios
  mm/madvise: skip device-private PMDs in cold and pageout walks
  mm/huge_memory: skip device-private PMDs in madvise_free_huge_pmd

 mm/huge_memory.c | 3 +++
 mm/madvise.c     | 3 +++
 mm/mempolicy.c   | 2 ++
 3 files changed, 8 insertions(+)

-- 
2.53.0-Meta


