Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 326F9CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AFA66B009D; Fri,  2 Oct 2026 05:56:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3600A6B009E; Fri,  2 Oct 2026 05:56:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2500E6B009F; Fri,  2 Oct 2026 05:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F27396B009D
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:05 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65E83C06CA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:05 +0000 (UTC)
X-FDA: 85277230290.04.EA2F4F7
Received: from mta1.migadu.com (out-89.mta1.migadu.com [95.215.58.89])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8A305A0006
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:03 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="do/z2PmR";
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Grj2ep1GgK3MbSL8jCTCk3Cib7ESutMoENs54KPGJPk=;
	b=mNOk+j2Phr6jaaMIzGrdVGN54cZx7MGtKOFWLIuX8fpE4kHFZN/V+iYrpqR9lbu5Q8b3NH
	lBOYPDfqgN/+XikEyHT/EUqNKN26zpmgAK1UST3L5EHT0IEi3vDCyLLpoaRL5gA7FDFun4
	bUwf0bicpIPRa4rb/Yeh1UyCLBdGegU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="do/z2PmR";
	spf=pass (imf15.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.89 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934963;
	b=CF/2Bttb8V3GEpYJRmT+oIrQN5spIlhPkTFT+27Jf0RXfhr6A68iDpJDI7pPDept13uB58
	gfprpDIeHYY7Px9RtnR7Shiq6gAFSa769zgyAcEPWI+fgoV2l2yZOhrY7HGDFKdidLjv6x
	89gD4jrQsiuaTGHqYTH1PQgF2ndsh6I=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=+539FMbDWr/qpvdIvQSVHv0n+KmhLVFRnsglmFqW/I0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934962; v=1; x=1791539762;
 b=do/z2PmRkJ7t40I/oAiYXZRXQCdMDu0jJ/kg+x5NyNb25IjzyCqaSZUx8pUJoKPpASMbG7h8
 OwxcZGlIK0yevjzstUNGsgYrg2FCyUJHeyBixroGbpCJCL8i5vHBWV8zIIu7R4QO8i78/5vzVC9
 uN1Fj9Ecvom4k/FFsXNLJIzo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 9ba74d8f9c205fbe;
	Fri, 02 Oct 2026 09:56:01 +0000
X-Mizu-Trace-ID: 9ba74d8f9c205fbe
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
	Usama Arif <usama.arif@linux.dev>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH v8 04/30] powerpc: mm: add PMD swap-exclusive helpers
Date: Fri,  2 Oct 2026 02:52:18 -0700
Message-ID: <20261002095503.3585565-5-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8A305A0006
X-Stat-Signature: epbpxskm3175ji9bzcs8ae8xgxo5scph
X-Rspam-User: 
X-HE-Tag: 1790934963-332714
X-HE-Meta: U2FsdGVkX19Kf+qCX0gD53IjoHJ2ixmXmFsEsSgTyJW3yFh8FINN177Fut4n/ISRw7UMJiilcbOV9lLjrb1lmY3NyFpxhJdpSIRKeHrLekQBzKpxv1gCyTJpzzMfU7BiLV9JljY7zsDbayDuYBXQ+uSGpdWfJ1Odr0hxfseZdB/Md9vLbLjt5ugqupAl+c+uySvb7XSeJI5nm+MMs5IhJMOLxrqCt6O5VJyPae+4+pKSZLFtHHT4ot03/4i37476HrCybrborv2Dthr5OCGqSSLrN1DEUYO/tbe3I9GCla+6R9l1jXV3nImmsgtnRVvHXSCaJKBYA2ynBkqSWIlEXPdM7dqtfnla4ZmdoLCQ8xVIKIZpy4hXK2S8FahITU1gLAqzU6QO50ptp4BBpS3mqoec6akIlTeY0Sbi94gw/pvXffTEpDQXR4+px+jLPwT0K4wGB9YUe/MJnem588/VfX/8y2EY3sAssG2xysREG2IgebhWyoQoSGeWMJ2OvJ29+TBWSWUNwSAqGfPuOrNqWWZSZJRkT2ndigWdejPoQ2gEWYMVchvWr69GnLJti8NVHlOaurMNlHYxZh9OO5HlKHP0Bo/Y75bBNrzQQTrs70StNIvc8Ce/9b/FWSiQCkiZQaiHKQZGk/C4YVseFC0I9ACAAEidpMEHIQSugYcI7A4VajU0QzLsZGkWmYRPuBaQSnTG0mB0C77E03VsYAnwAb+VBfcZ0grWQVN74q/nkMkw6D88klMCuVd0bW58x6iUbidaAF24JbYbeqquQPMbTnBwx31y1t7VD+x6yScYrgJHKJTBpoz+sAti2QVH4R20sxm1t7PYS0nsMAkykjh2fOpUufePZ/pkEo1btD2WWdFpJnMMYdrM2Dh4QR+Hrx4zbV+mFIX/rzFwo8w9OERAVQGeyKp81SAX+aFtCh3mE3bWkVZ+aBrTGArey6WDqh/Cbejs3qAXqX7I+sL5TMO
 PxsE9fsw
 rphxR/kuC7caCk/Yp1M1MhCH8qbwZMakwnWKPuygGMTXdUgMTR/SD9BgPo4jLaf7E17elJ2+MJLdjaIRtY3SNqk939ftT8POTWBEt8nmluGyQx0+nMmQ5cTKB7mQ3AsZwfKHsLMu/T9dJ9ty6j/yLJSw21OBSYRDIJshWp0iFaWevEx2lghBayzBaSF7roXfhkCnCdHf18nEjk3tMZxuBWROFM985dR0pkPymuZUrji2w1VBsqTE/PhAJEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, which makes PG_anon_exclusive have to survive in a swap
PMD and not just in a swap PTE.

book3s64 builds a swap PMD by running the PTE encoding over pmd_pte(), so
the PMD helpers wrap the PTE ones and reuse _PAGE_SWP_EXCLUSIVE, exactly
as the soft-dirty PMD helpers next to them do. It is also the only powerpc
variant that selects ARCH_HAS_PMD_SOFTLEAVES, via PPC_THP.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index dff8790a047db..458c85cebfa65 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -1060,6 +1060,12 @@ static inline pte_t *pmdp_ptep(pmd_t *pmd)
 #endif
 #endif /* CONFIG_HAVE_ARCH_SOFT_DIRTY */
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
+#define pmd_swp_exclusive(pmd)		pte_swp_exclusive(pmd_pte(pmd))
+#define pmd_swp_clear_exclusive(pmd)	pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
+#endif
+
 #ifdef CONFIG_ARCH_HAS_PTE_PROTNONE
 static inline int pmd_protnone(pmd_t pmd)
 {
-- 
2.53.0-Meta


