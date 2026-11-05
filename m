Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D34FC606A331
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:40:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEE196B05BF; Thu,  5 Nov 2026 13:40:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC36F6B05C0; Thu,  5 Nov 2026 13:40:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB956B05C1; Thu,  5 Nov 2026 13:40:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 860D36B05BF
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:40:53 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 275D5160B5C
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:53 +0000 (UTC)
X-FDA: 85401931986.25.E239570
Received: from mta1.migadu.com (out-69.mta1.migadu.com [95.215.58.69])
	by imf05.hostedemail.com (Postfix) with ESMTP id 433DA10000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904051;
	b=Dyn3IvTT8PKne+dlzcI05GeNEDkz5WNU1R0fSpGggnGAw6NMYMIPoOzs9mi/lcrqAStboR
	iuiLZOmZRRQEBDjcgY4xPFeR537ouWyI5rWoopovS5Cc/WRGUgMyJVgMnbi995U7bjqpiY
	pgt2aOKrccHvIcSO5HTQsBPLzLYP2r8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.69 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904051;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Nc3YPnJRwzfEYdDYZsDx/eGvT25xHUbuaxqftb/2MH8=;
	b=nLHL7Nr546hrOGepPRh1ChBWvV/N+1A4Wcv8IQyzqnLylLRyKW50LvC1wM6ygx9ZzQVHto
	ZjBGroVKJMLSPyhMInI0XRPp7MT1ug/eb3nFWx0cq08F0vy68g7DqwChBNgiYm+mEwnseJ
	litgMk3sUrrzgv4TVPYJ0F3JA3x5fXg=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 054e15d9c411ead7;
	Thu, 05 Nov 2026 18:40:44 +0000
X-Mizu-Trace-ID: 054e15d9c411ead7
X-Migadu-Flow: FLOW_OUT
From: Usama Arif <usama.arif@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	ljs@kernel.org,
	ziy@nvidia.com,
	linux-mm@kvack.org
Cc: chenhuacai@kernel.org,
	ying.huang@linux.alibaba.com,
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
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org
Subject: [PATCH v9 07/32] x86: mm: add PMD swap-exclusive helpers
Date: Thu,  5 Nov 2026 10:38:51 -0800
Message-ID: <20261105183940.2236717-8-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yahf4e6au9jwn664yxjzto56poh9mmdr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 433DA10000D
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793904051-415004
X-HE-Meta: U2FsdGVkX1++J28RQX/6hYdARvbvc1yGh61YDPLSB+Tbjs+0T2K2LaZ2Tfo/x4C+pdKpjJ2oTKvhtduHOW/fgN86ztmJwTYsefDt2U5bzwiu48AkygraXT1aHKJsttnOL9eHI5JgyuT6oYgMSP4Givo9oksUi5sEsBpjOvV6FVr49gn0znUfBr+VFdxyecaqBVkidCRN8YxWXVBBBp0Weu2eOVk4b2TdX2ZbDRG4NFZ9ua89GJayep3XpZkHUhWjhg9AVRkospW0ERhuissWoO6OVKFUer/MGKO57DhVS1qKZPC0c0gnLnkY40oLdQu+gY5z8hbOXH2G4wvbgf3liKnDDeymuqXCMAo91g+n+eTfWEwle1DGCE7e/0k3igMXLsIZzy4+V8P6h7Vx1KYXua3/gpRkY/Klb6WihCny0AEltSEPFMV6Q2ebjivlgKCvnx/PVBMmKnShd+7bP/NOtCUe5egHl2h/chGC5V56NoXNIJbtt7uCTrm8iUC8BNlTdEBjn1hbBqmFnMh+kdtG3wn/X1d3VF8e0YKDtEswUB1GbNZCKLj478EyJY6K/eo9l3APSd4FXT5uL1J/TZ4A6/OUZtqX6nd05NXUUiqEdVYz+GOXkGlxHmN4BZUXs4F7ox6v5m/AbuP5Gp0Z1+zzwuYEfaLvBIaQKpJwY4LQ+5/VQ3DM5XNXVXS8Q0q3GgyI+LRmmKKAlUeCdwuLza3h1MsXtRk9sIf/dt2jOUKe8pKd0pYPQbOHfu0ZOxjHY4Hvq6lsSTrNv+SIdrzE5gTC6FeM1HXND3CUSTKokgULkp+873jJFyC6InAeM2LFAbBlOoi1dMtbtB+0jMwk54qE5z33mbdolznluqA9dZxtup9WiuDHz1KvuZrXjHCLB/h/qk/mEZVm7HoZjtH3CiWSE0mBYMltRrUOhOHgoq+cx76KVo5WZEZok9g0rH6SNgHfACy+OV7qYBZZlF/QMji
 3xpjN8uj
 XIwaeGklMb6brfq7DaeQxNJrfd9uG27/k+sXASai1iCo5EM3vU2mY19YDs8c9PqPnqnSrmm54iXGq2b7qQWgPXGB25Not4G3PlGLY7jmBFJR4GcvrPNBgPuss3ZOtRq8wTTWCb0qtNixbkoqqhW4bfIlbBkLh8naJbppSIni9plypTsJWJarhQyWnplHxnw+Dl6VB33NGVEvZ5TSSCTwB5lKbRiNd8NRs3Wcg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Prepare for keeping a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, which makes PG_anon_exclusive have to survive in a swap
PMD and not just in a swap PTE.

x86-64 encodes a swap PMD exactly like a swap PTE, so the new helpers reuse
_PAGE_SWP_EXCLUSIVE, bit 3, which the swap-entry layout already reserves
for PG_anon_exclusive. 32-bit x86 aliases that bit to _PAGE_PSE and does
not select ARCH_HAS_PMD_SOFTLEAVES; assert that, because an exclusive swap
PMD would otherwise be pmd_present().

Cc: Thomas Gleixner <tglx@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: x86@kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
---
 arch/x86/include/asm/pgtable.h | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 000fc6c1ca37c..22cf9b57a135b 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -1529,6 +1529,29 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte_clear_flags(pte, _PAGE_SWP_EXCLUSIVE);
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+/*
+ * _PAGE_SWP_EXCLUSIVE must not alias _PAGE_PSE, which would make an
+ * exclusive swap PMD present.
+ */
+static_assert(_PAGE_SWP_EXCLUSIVE != _PAGE_PSE);
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return pmd_set_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_flags(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return pmd_clear_flags(pmd, _PAGE_SWP_EXCLUSIVE);
+}
+#endif
+
 #ifdef CONFIG_HAVE_ARCH_SOFT_DIRTY
 static inline pte_t pte_swp_mksoft_dirty(pte_t pte)
 {
-- 
2.53.0-Meta


