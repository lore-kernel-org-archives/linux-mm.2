Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21852CA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 734806B00BA; Fri,  2 Oct 2026 05:57:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 697266B00BB; Fri,  2 Oct 2026 05:57:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55EFF6B00BC; Fri,  2 Oct 2026 05:57:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 32B0A6B00BA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:57:09 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C33CE806CD
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:08 +0000 (UTC)
X-FDA: 85277232936.20.4E836EF
Received: from mta1.migadu.com (out-127.mta1.migadu.com [95.215.58.127])
	by imf29.hostedemail.com (Postfix) with ESMTP id D878C120004
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:57:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NyGAMC+C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.127 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790935027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6jByMVr03QXqW/+zfBLn/bRhcMEPJMASd0ZFFF1jJpc=;
	b=qCtr3UPsGtdhccfA8pgdECwxxpRj8LXFpYfVvT6n3Na8rc+cWMJuhwn3cpPvq3yZtJm2/k
	an5l1wRHdwPQHuzK8Lc1xNA6Vbmo7nCc1zZFhkqDSPUwmrGRxNVv6grpWm5efzkfq2QoyG
	vk78VRMafdJwm+aPF0xbxlA5VMZ6g9U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=NyGAMC+C;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.127 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790935027;
	b=zY9C7+XDcq7vuV7t7k4PNT6UOqPFniD4PlizgwADd55X0a5hgI1U65X4WVK7ILImwSXItI
	i7/sLmk9d6Fx8LUxVaIHLjzhbjSpl6meSAp4wnVaU2KbsQrJzg1OfIxcmGkS+/QUOEoHuP
	LKavbzK8k2X96eoWQajH5qk0ABpZUyc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=52my7Ds1LJ1DHVTSsdRA7MBIeNU6HZuTroAZD3VRoTc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790935025; v=1; x=1791539825;
 b=NyGAMC+C0kwl0LTQZIMLdnUwpgA71T3523RECt3plnkz+GHhILGxsu21S4X2C551mnrJgmUC
 KtqV0zImrlNewecPGGhEGr/ebcVxa0AD24dzyLzwQiVxObRPtFH9SjGKvRs63Xo4kxqhzCPtfF4
 SDlZGSNtuZJWwD6CfIWjq6Hs=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 97a2097a84c32ae4;
	Fri, 02 Oct 2026 09:57:05 +0000
X-Mizu-Trace-ID: 97a2097a84c32ae4
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: ying.huang@linux.alibaba.com,
	Baoquan He <baoquan.he@linux.dev>,
	willy@infradead.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	riel@surriel.com,
	shakeel.butt@linux.dev,
	alex@ghiti.fr,
	kas@kernel.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	Nico Pache <nico.pache@linux.dev>,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	yosry@kernel.org,
	qi.zheng@linux.dev,
	luizcap@redhat.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH v8 19/30] mm: free PMD swap entries in zap_huge_pmd()
Date: Fri,  2 Oct 2026 02:52:33 -0700
Message-ID: <20261002095503.3585565-20-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D878C120004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: si7dwbnfo6a5f3m6hwubbqeaqsoebbsn
X-HE-Tag: 1790935026-569821
X-HE-Meta: U2FsdGVkX1944VLWH3brz1mKyslK7l7M++2Jf7y/CxVJS6ndJ8AsGhXH1la10AoF11j+8tlWG/PsEE/4JSDPIhMMUvrtSYb1uJ3ihsVZb0EjUF4sCQUaq2GJWp2QvxWzIHA4wVDZX8306+EQpJBLmuSAtbc3KsiE0LM/va7wFiNwQaPDvVcNovNCJNKIe+9IKO4R93HDPBAfEZrZ8Z09czq1rsxqgJwRr8ihwkzNu9qGm7hzrlMo7K5DE4Ffzb8PwyQ1PGpxMOqMNLHq5oLOSg1KLDrP3demnfjhB4BG9/jKLpk1HIg/vZg8Y1jA5hMMMvw5i4R6GpmL+ntBMq1Iw2DA9ujwROBotJmj+47/1mFgGhWqJyFVXE1FQYZy01IfPmjLbPtTNrBRl9NG5p5zG88VgATHL3HiLA7v43i1KZi0mV32agUuLoZOIh3VRZObvAHXBdzsdQogPXkdxr7r9OM6mc/pc4UKAf1x3D8ufOWUcYXiFqZNgjRBjFwnukNQ4OPXgpzg5AOZ2Mq589MyN78XUvvSfPTxd9ycqcIQ5RuFMd+ykJHyTpzjJznpmWz1c2dIsLGGQID2/qkvnsW3ApbD8E/9M3+l5E5b5Tli3kF+xD/N+1AQZWZbV+KUintoW6vDr4jgPy9wEe6JPkGi88S6YZgUlbEI5Qq5TSx85zPiAKDLg9Nehh8htA0Ee7sjG1E9Na1VPv1wA6umZE6Wcf9pT6vvFPlg7XbgzftuEfhYvcfQ/gu8seLR1jj2efaIGAKeMcalz77YsXropbfjZS34fbDlT/JV0QFBA+DDDbAmmY4MNP41DV6dn/RqBO7T/FKqf21n32KAPPYsj6EHGCKAWbpffiPBEmyIwa89+9UM54VO5mSoGuHCE5WI9u32ZUykeW0fqcg3ptClJFvar7g7b8Z07KKe5r67UduMconEhrRUqNKmRVSU+3P7CrJ8wkYMGaUxEru1/tTeT1Y
 0B50wG6P
 rVwqWhfn9OIerr59gjI0mlNt86aaHctxS5/R9/s3XIM6Kio6OKvsGBXoVyJ5+rx770I1d+jr3ukC/plDN6Pcp/Op0/le322e822oIP9kTUFkAL+YEE00EyHP/qjfE6q/83Zvv3Dp/N79eUm8vRamkbJfktzx/KsodqZYP+ScDdPlN4H137ktv8Sl0W2XLOLOTtipgd5rSz2J4NA2w3B3oah/QUAWCVsLnf59TX2VA5FbU+Y3qHp1CIKisepgwv3Ah3rfH6bPcsb32WDEGPQBBugEwtg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zap_huge_pmd() assumes any non-present PMD it clears references a folio, so
a PMD swap entry would reach normal_or_softleaf_folio_pmd() and warn.
Worse, nothing would release the slots it points at: unmapping a
swapped-out THP would leak the whole PMD's worth of swap.

Handle it before the folio lookup, as zap_pte_range() already does for a
PTE swap entry.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 56eb87fa98376..9cf7c4747cac9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2605,6 +2605,16 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 
+	if (pmd_is_swap_entry(orig_pmd)) {
+		softleaf_t entry = softleaf_from_pmd(orig_pmd);
+
+		zap_deposited_table(mm, pmd);
+		spin_unlock(ptl);
+		swap_put_entries_direct(entry, HPAGE_PMD_NR);
+		add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+		return true;
+	}
+
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
-- 
2.53.0-Meta


