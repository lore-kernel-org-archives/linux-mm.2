Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D10DACA5FC4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:55:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5386B0098; Fri,  2 Oct 2026 05:55:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3EF56B009B; Fri,  2 Oct 2026 05:55:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 892186B009D; Fri,  2 Oct 2026 05:55:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5E1416B0098
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:55:58 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CF1AEA754B
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:55:57 +0000 (UTC)
X-FDA: 85277229954.27.048E1DA
Received: from mta0.migadu.com (out-225.mta0.migadu.com [91.218.175.225])
	by imf14.hostedemail.com (Postfix) with ESMTP id EA4EF100008
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:55:55 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bU6xgKc4;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z+fA0feZcQw7e1bRkyvBEF+SLeuRVPzqVCpfmbyiCoE=;
	b=4dCiIcPlmSVaox4J3By4oE9shQQ1B/URrXzmrVCVf5/lf8JwUAyE7NgpmRfLGJcEOxzzlu
	EbOKp2cfNF5pM2Irk3Q18LQZWZGLqLqPMRRNsOk/yRnSjGJ+UerCYYHO9n8lAUJ6pUM6JZ
	EIGijwtdD1Rk5t4TFK/C6m658g22K5A=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934956;
	b=gk3/et/12SteStMer//Fy6u4aut0l4xObeuNm8hw1sfwXoTsIx1RJ0Ok0+cryR7ykBTugj
	0Frbe/f+kepFP2i6MSKNXcS7i5+rmHJoBTjomvVmdeEnBuam4iZZEZm6UxsjaJP8oxfh6v
	DdDAQzzaa2EcdSb+0pWlx6LIzoLUBbI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bU6xgKc4;
	spf=pass (imf14.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.225 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EKokArehgD8rZsdXiQ8lLAgAY9hoxZ0T6UO2qk4aEM8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934954; v=1; x=1791539754;
 b=bU6xgKc4hljxUD51YvP2A6T9VpDHaA1AzjNvzUwvG+5dr7AvTrySKMRwFoc1plLaD11lNLiA
 PhXrTn0mv2+XN26XCXQ3r3zjVulRmJ6NOnIXMz1YapvBJ7IaBX02y9oPEj6oEIopkZykPtCSAPe
 jAwZV49d2+jKEyIhDKZYFfgA=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 69e3887844b5b59c;
	Fri, 02 Oct 2026 09:55:54 +0000
X-Mizu-Trace-ID: 69e3887844b5b59c
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
Subject: [PATCH v8 03/30] loongarch: mm: add PMD swap-exclusive helpers
Date: Fri,  2 Oct 2026 02:52:17 -0700
Message-ID: <20261002095503.3585565-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EA4EF100008
X-Stat-Signature: 11ri3mq9i68ur83crh16kxiqus3me5gj
X-Rspam-User: 
X-HE-Tag: 1790934955-337691
X-HE-Meta: U2FsdGVkX19Plq3Y9rC4w70AR25LM8XRnSWiNgot5R6YDvazqolAzSIpjOBXp6Ia4LS609FtRxkuRr2/H7Bbf5fHtyiblflvNHOROrlF9d8IO1pd7/XafxZEWRd9wTfSm/RisdRXjIvtkk1Ug4r/sS7iNPLnRDH4xhiE8fyWq1I1Jbce7a6qWZKmjphtNvC9YhrKFI8N4DXZD3G03FHDhZE8n2xfyx1ezIZ2uJOHnH3wo2UWeDucHZNoRu/85O+80UTDHpkw69bAmzy7S2cN/jP1ChDvTKZWkyMWsQ6oQw3Aq+oi5nB7rayCQ13sxO9PXvOR8Uic0DmcvxDftctEwE0iygyZnkJo9N8/+DWVTfEy2D+Ut18CEyJljtNkWvopv+BwKR5SO3QANCZMqZrtAqa+Bel2bOgjsddD2I6XVArrmhDNjyE82p1aQpf+Pd5xYdr3adJYxSmjIVu9VwqgyPDCDGkP073vFIgoiF3nfMrR/X2Wv34g84QqTmC4PrwMijgWriYZl1ybuVPWygloVb4/bBFaOHEzEcz81U9JjxaDPUEcRyyPnTJsdDm6YDp2cdB6klnUUDnpeTPCriheDxMV/J47aZEaRR9bo1MjiKly39Q5PDNIwgCMnMIk8lKfjkq9bE6/1M45o1qKNG2IgOohl+2x0C7jFw/WqFl25by6MymiXOct5gQfwNUYsNTSxoET6b1sfYmcts5LUMOidJvfhbFW4V7Lwa4zXvge/qTt36jyLZCA28/CkopCWFiDrc7NjekVEmxjtLMtMAvPlXlEmCN6jQeAOm+pAsLPBdb4kVquYLMgUE6QcwNFK2fUIsclcFjhla11Ptz/WT9YlSRP/hliol1JD3Xb+GrNLmwa3i6FW4ywMdfBF2yjBxNCZnxBpuLytN4yLGKX4O+F1Cn3i1WtpRMRkfK3zZYmx63tTfsNyR9bjhHk0p/KYYFD5Qg24bc4UvlWavXA/mG
 S+7JPZkf
 RgFpURjU6KhgD7hW2yeK48HU0DsPb6a1JiFRTAJ4R2DR/E3LIqxcvVT5GYkSLuz2NZotP7XKzLxFAXE8ZP5FbUH4uMvN7llh2jIey/XMQzlgy9ZnfuJCI7102u9Ga9PqTb5S2EhWERms8dVT+/DS396ZxAqxx+LppFio7optsMHeavIyMrm6sT9LEAo4YyomYMSa5gOqZX3X0W40bG1XfMkCSyB2qjoF26p+EGH0+SPqJ6K9Nu85tFSyx34pg7XzANxczZx61ncCrQH2sKNYGfR8rDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, which makes PG_anon_exclusive have to survive in a swap
PMD and not just in a swap PTE.

A LoongArch swap PMD is the swap PTE value plus _PAGE_HUGE, and
_PAGE_SWP_EXCLUSIVE sits outside both the type and the offset field, so the
PMD helpers can use the same bit.

Cc: Huacai Chen <chenhuacai@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
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


