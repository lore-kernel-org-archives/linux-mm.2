Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BCA0C88E64
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:43:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9DE66B009B; Mon, 14 Sep 2026 07:43:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D75D66B009D; Mon, 14 Sep 2026 07:43:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB4366B009E; Mon, 14 Sep 2026 07:43:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AC5E66B009B
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:43:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 75316A0362
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:43 +0000 (UTC)
X-FDA: 85212183126.15.25F8A31
Received: from mta0.migadu.com (out-39.mta0.migadu.com [91.218.175.39])
	by imf25.hostedemail.com (Postfix) with ESMTP id 919CFA0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P85yRrgl;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2ngq0F7L/BeBqokcJ/7tksYoJGvu3lD1oc2u82chsQc=;
	b=CViT6Q6p1k5hdTZ+s4UFTW5jInkucnIJVyKRykYdOIv9xEOsoiC5T02rprzLx7YGOLAa8m
	Qgg6jIIp5559e/Q+qGz1xflPXXQSsfKFfCCjARv0TQwuHpRtokof7BlPdoc7CeD97XJnaS
	LpOoVS9QgjaopQTa0HBlgkaVbWtKVa8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386221;
	b=CXKT5mTvDx3SwIJq8SkWEd4gC8BZMGpE15ck9nBCGVsisfOrdBRHjoxb4fqh3PNCcHfiKd
	jAqMwwLlAQLk1elYIrTMk9T8kiF46IXnt1gy/NSKTnnDlmO0rw5GQc/DxDiH46lTfLZm18
	jh2yM14BgMZKZxWIPBEYz3ljX161t7g=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=P85yRrgl;
	spf=pass (imf25.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.39 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QiAy/7wN1ydZlsQx7DI1Vjrn3FeWZdoFpSxlDD4vX6A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386220; v=1; x=1789991020;
 b=P85yRrgl2KvMA5oLRULp1rHFMnJ2wcMYd8kZsnmO8Y5VAK/uerU8Csx86gMbD6FioT/C9T6m
 bvwRBM2gA+oFl0weyNHfpAp8Ncc4VbAN8+KM35CasYkt4EMaZjMu9RKpquOIcyuc43vIqJBkwfz
 Pe5pch1RkWIktGwVrcdniHjE=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 44564c864b555350;
	Mon, 14 Sep 2026 11:43:40 +0000
X-Mizu-Trace-ID: 44564c864b555350
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
	Huacai Chen <chenhuacai@kernel.org>
Subject: [PATCH v7 03/29] loongarch: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 04:41:55 -0700
Message-ID: <20260914114320.12988-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ery75szjnwcm8zpcd1int9ms9b8pu9cs
X-Rspam-User: 
X-Rspamd-Queue-Id: 919CFA0004
X-Rspamd-Server: rspam03
X-HE-Tag: 1789386221-82195
X-HE-Meta: U2FsdGVkX1/D072W8rm85qewBxMEyfTzbV9MOCxdGTZL658ltkFZ73BNzRhrAjeXEpOjNJpEGd4Y6oltwmQa5V0DhdDPimuLm4mGxS6LLs2b6Q1Q/1ykcA5hwOkjfkDntMWT/3Z2RLrPewfUVpeJ/vHfxr3MbPHaO0137DAsEbaNEkHU8k2t9XtPaN8SxCq9kYPxdhwrTaAbpkvqL93COnhpe2NHTP9Df2UW7gUu4sRVyvl+0MqOROg6JOCBcySp1TljRgIG3NZREBnSWA+mBS85RXCNptd8XZOKX//EfPcR3gNQsZH+YFxyHQ7197txsqsBxWshLxsOoB+N0OnuC3sTk5Zb0EXcB8kWh+ppcPI3xyDkxiR02uKaQEKIwB/M/UfgDbVPFgIoqq4vuBp/8AovsBe0UkYTntqInTBACy/TiceY2Y3yqn3LUv1eWRdQNfrMDPR2yZpG4MptgXKa2Hi+Gj+XbWke/ByR8uWhDelZFSEm1lWyWfJF7px+PecSHeZfigIR37QufSveGERtMVM8akK8KSYlB0vAxURUgiqS4TDQ9wbpujh4IBPIXv4PY3Qwj9ddjAehdlZ45oIBZuHRp3ajgfYj4s3i0CIeBLuzSAJVoFGw+3HCLs0if3DBhZ6g/30svD+w5zIXNIlB5j5LxM+P2tMQxZIzdMMzPm369Iy9SuZ1YiFXxC1NKM+nG+3hBrPt1VP+sZrVsFlVUUxU1nGLdDBB3pLAXBB4NNPu4+Dd0d/Lip0F+PGlOOAs1rn/adiSRsDbyq9D4b7d2Wp14jV7K84mvXYWBiX/QEwaYbSxNsSGZWuRSHfNdaqjZg0K0y9mevJYFc+BWRWm9d9p2iPx0PgXnA/3QXsPfJsH96NEQbTbprJnZnF10dqhMQGTiA309R569evBbkiyXxAgSP12tqen1Ky1IyIoG6yE7hkCoySOMTF/4Dnad0w+tT7ks/heDzHhUYpnTAT
 4gAGG+dE
 n4H1iuT/i8NC7My+XK5XYGafRUvWwWqjP3iRuk/Y+nkhCfmdfldUM2ov1oaZ55ybG+Vn0gia4mG05L2enkbynFupS+VP3To7kuJGUl/bLvm3uPaUx72uA2Tk9uZwcUs1YlIAXMh1HxPcvJdfm3khNVolhev9fbxsd0z6PpIju1c5VTUoPXtID5JUlqygaKHPoXMnp+7gJ2bDhmXpkmygSD+HVygSBx4+8PUWOb04HhR7Y94jU7o4H7Jz8GznafTqAtTwx/atBCf2c+BLEwgUTVALjNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

A LoongArch swap PMD is the swap PTE value plus _PAGE_HUGE, and
_PAGE_SWP_EXCLUSIVE sits outside both the type and the offset field, so the
PMD helpers can use the same bit.

Cc: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/loongarch/include/asm/pgtable.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index cf29a4c8ac593..87fecc3a51001 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -351,6 +351,25 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	pmd_val(pmd) |= _PAGE_SWP_EXCLUSIVE;
+	return pmd;
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	pmd_val(pmd) &= ~_PAGE_SWP_EXCLUSIVE;
+	return pmd;
+}
+#endif
+
 #define pte_none(pte)		(!(pte_val(pte) & ~_PAGE_GLOBAL))
 #define pte_present(pte)	(pte_val(pte) & (_PAGE_PRESENT | _PAGE_PROTNONE))
 #define pte_no_exec(pte)	(pte_val(pte) & _PAGE_NO_EXEC)
-- 
2.53.0-Meta


