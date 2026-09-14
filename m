Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBAE4C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC66F6B0098; Mon, 14 Sep 2026 07:43:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D76206B009B; Mon, 14 Sep 2026 07:43:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEF9B6B0099; Mon, 14 Sep 2026 07:43:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2496B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:43:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D7D92160349
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:40 +0000 (UTC)
X-FDA: 85212183000.29.EA05C80
Received: from mta0.migadu.com (out-17.mta0.migadu.com [91.218.175.17])
	by imf16.hostedemail.com (Postfix) with ESMTP id D68C8180003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Htl9P3e+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.17 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386219;
	b=aZnu6FN6Xrv5HiDk6SqmwkAlGSpxMT/9LDup5Ith/1wYrGj1EN1K/y9E7Hlqr2usx2/8W0
	miOSyajD2UUF1ojox5D/+oC9RpIRP0i8WiHkPPzo/cnamRmiUSE1/OEBBrt5IPGBH8h0NM
	vSaRWf0jPVpBjfoJOprVcHO2aDf8u7k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Htl9P3e+;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.17 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdVA0eGNXuRt1yxuFyNyAv08OCeJaRw455a3UVpySG0=;
	b=3RuThq1MOdfPJQcA6s297MVU+ZPIlrA0rdmpTH7V7HLORaLON/KtRR9IHMJdu98z6zsCIx
	WdMBWiwdapR/90ynFPI7rqoBNrPaYIog/iCen3kqMJMDiEvaBJLicKk9QiW+NMwTCz4OPT
	njP2oMfVjUG2DHjHchEGN3+KrN3e1PY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=owEO/GVV8kpSqjtX6z75OJu1GLQvZh0Qa08KVOaicH4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386217; v=1; x=1789991017;
 b=Htl9P3e+0/K+6ub78n+GAx5gYVw4V2l37PdDTbqemYbpHDS9VAETxAkMHOMvVjDpLoZn4Z7u
 O7SpLO8gX0UCj9o/pcNgIbPSSffOh7kR65bpsLODbSope1EXDEL3BVI7DoTruKwiFDJOA+ktHCH
 aCdoKMz3VZ9WvIW6C7p669VU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e21318cd8487db57;
	Mon, 14 Sep 2026 11:43:37 +0000
X-Mizu-Trace-ID: e21318cd8487db57
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH v7 02/29] arm64: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 04:41:54 -0700
Message-ID: <20260914114320.12988-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D68C8180003
X-Stat-Signature: wzaeu7f7rermjishy1t3wnpur3bcfcjd
X-HE-Tag: 1789386218-102344
X-HE-Meta: U2FsdGVkX19wg0sC/cDSxKD6TF717YXRx4xK6I+h3H0c7VfK89r/TzuzcIekQABKr/l4wovNH5f5PQ9lA5UAct+KaFEIafsw4iDesIv93MzS+LeTvpFX9MofnBFj7+aa2tkVwcKWknv8SaNmu3G9RVUMyoGse+3r8d1YvT5mfp/vv7ZrN3Vhl0b+FKpACMixI72Q8uYL2rPFrL6an+qOxQ+EFPGCgSDNQDtmyftPwcZ+RWldcUHs8BSrpEuISZL6K9t5g5PHEayPjSKJ+Q/XDEEp6IuN6i7PEyA4JeoBuVsZ6PHK2ZzpyoWMsxyVTsJXQdrfls75GDzOvmkGdqzIJw5v50/3/WrJsjQvRFZb2mDo0C79ygPywD3zzhAmFM0Tf+Wy1Q7lIo8mzONOKPDepAupBaE/zllbT7ypMEKGgRq4FCabFkJ5c+wC1SCJOxUihLjfRbeCLltLlGxpjSnn3T7zPaUf/Vd3ZYaoWTZWHWVX0XMSRUKgZd650L13kitu5XHfwEmuiY0P5WJjRQY0WcoD2HySIDKPT7BTJVrmuQTfhu44RI/LD9Lhv0vRfKfz+9aDhiIvSHsUXmBbpZ0WMGFqrslTnmPxU+BdEhwD4WlhVD4ff42F5/zf+ceCkbX4ut38qXW9kp6jnx+6AYNGS2OdMsbA1dRpuy3CgQT5qZFt5g0Ve9U9ChKDOu2LlHFf6muoGvsQIhiEGNjxVmQvlKdO7PNwjZdLzmu/Hjr6kECBe0U5waQOu2PmYFGxmrzIiQMqjBeAencOijtGZph18GHMFd1x3XR5v8Klj02o4ZK1AJQgEuCWsl5Imn+z+zZii11rNq4RGojG5qrCd56lW47ey0wxgtuqWDqtHVlheLiqBWDlnR5pYAcu+D+7uVYxOomK7Nj+NaaQolctAbiSNwH6VkuL+8r+BrZef5Ax4xDdpaLhM+XAe5uevbUAk+cxuYSuuIa9JbgQcKzU8zP
 aw707IPW
 lwiXlbaZvqpLNACIL8u+hgWDfsPhUn8Wad2mqjk2yGsoJv8YUSpdQIqPAlb6dWuGYO/tl0VM/qHTrPl/v22KBtKUepxUJkxsU2KrMmAXwibRFgY/phuwfUU/N73EGksdo0GOTvrIIXg9ijdUMmVJ+CZURL/uBRngTDpaCL0zho91B9RFhSix/Z9z8BdPiM/KCx0tDg4K5maeR4o06013oxeHnt66/olYLOzPnx2A7ImycG2EFSMeVxVE2oloOsFt584sE0X6Rj+erR3vfwfOKif4KysDNLVyhE9+TwGf4t3Xw33/WIYAElfD4lQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

arm64 encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
the PTE ones and reuse PTE_SWP_EXCLUSIVE.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/pgtable.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index e89ec5f4787b4..d3f53a601aed3 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -599,6 +599,12 @@ static inline int pmd_protnone(pmd_t pmd)
 #define pmd_swp_clear_uffd(pmd) \
 				pte_pmd(pte_swp_clear_uffd(pmd_pte(pmd)))
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_WP */
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+#define pmd_swp_exclusive(pmd)	pte_swp_exclusive(pmd_pte(pmd))
+#define pmd_swp_mkexclusive(pmd)	pte_pmd(pte_swp_mkexclusive(pmd_pte(pmd)))
+#define pmd_swp_clear_exclusive(pmd) \
+				pte_pmd(pte_swp_clear_exclusive(pmd_pte(pmd)))
+#endif
 
 #define pmd_write(pmd)		pte_write(pmd_pte(pmd))
 
-- 
2.53.0-Meta


