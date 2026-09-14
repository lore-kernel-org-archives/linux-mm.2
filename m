Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F25C88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:30:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D31786B0098; Mon, 14 Sep 2026 08:30:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBB336B0099; Mon, 14 Sep 2026 08:30:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF8B86B009B; Mon, 14 Sep 2026 08:30:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A49F66B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:30:55 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DE2271203FC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:54 +0000 (UTC)
X-FDA: 85212302028.29.DC4A7D2
Received: from mta0.migadu.com (out-134.mta0.migadu.com [91.218.175.134])
	by imf22.hostedemail.com (Postfix) with ESMTP id CEAC4C0005
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:52 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O26aFq95;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389053;
	b=dx78b0rzU479GngrHH77NFnyD3+cZ3ImxkISV2kQnzIAR1NQtX96zcn0r7J6IT4lCdiIp/
	qi5ZBVRpy7GFWwBOvHt7kdObnD4cKky5yCVEGaRm7rveQ1z0EpsYNy4p16zGWAJYUgv86b
	OdbLsmYifg87N5ThLxxMYe2mut/2Qfg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=O26aFq95;
	spf=pass (imf22.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.134 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YuZk/VnWGjK0mkaqRncTg/54L8rsEeJ9QQmj2aCz3iY=;
	b=o53lWkszLWj/8109gE74QZR/0Y03GYSuLCDtxQA04FecGQReLbjaM7fWkIYBvwhM8BDc8r
	hu+Kmz7OArDBgMJaFgqf+WIYdstXls+H1F3F2SnV+keFzT1d1vG9im8cpR/TusIOHYVjiJ
	8iAgpbZc5L91zd/UqyNwNgMR1NHyqSM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BtQeHE2SZzfUtIrg0bS6PVLMNQTg1JxKJHlqS6nP29w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389051; v=1; x=1789993851;
 b=O26aFq95QqbDPrrBZZAJN+/i5U6vyG752FUsZzaW5Iryt3TedNZY+Z49E+ceOAAKWNmiThEE
 4xuXBjMLRG0W1o7P7M4qV3aUdHIlCHJmMztB2anIptP/bFVK/zpY98AhGcOR9b+k/FKqlBEHhLx
 W4ICbweYO7LQYxDCPSnNtC0I=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 6a02ba748b326016;
	Mon, 14 Sep 2026 12:30:51 +0000
X-Mizu-Trace-ID: 6a02ba748b326016
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
Subject: [RESEND v7 04/29] powerpc: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 05:27:54 -0700
Message-ID: <20260914122950.3283997-5-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CEAC4C0005
X-Stat-Signature: jghpbsi6obakijz4bquxby1cide439zo
X-Rspam-User: 
X-HE-Tag: 1789389052-337466
X-HE-Meta: U2FsdGVkX1+0MByLTxledPMxzAqjrYkqDbbB1eNHHNCWw2OSQ8oocDGo/MRlnFpbO3GJSHK8VFnFZE0l6DdeDKxy7naVv+JJLW8hH8ODfryDKaEkUGckgl8BZj8gJf3ww/fQLgYhBoVwDnJ697eqNfbzsLxwTd8UQ4Fz+idpzBY4Ry+jw3Ltj/bTsfgFCf22l0ac8YqgS/UspUkArGN4+9//EC8dZWDj+AYR5P8vnHpXA4wl2DLD+5RrEIY7GLAUdxL/0NmBj9exwOcKwwfcfzFD0uAhxiYvZhHlkuleV9kviNzX97tWZAkVCxSWbv57Fb4gHEqpuk4KpsmXM1c5EdpTjyo9/l0FP4xjRNacn6bEJhfPLx7kfDFwMNBy0/xyWCFuZF+979ph0KpunpDcUVT1l5tLD0o3lPZkT7z7TeoUZi858C/tg9wMUzbyZVMPbAIDo+dhDP+UUGpyiVyl+qRSti0Eked5QT3X98wM1KOOo7c4yyCf6WfXGbrWdcN3ZroKCQLSh8uNxD2PrwqgviQo4Rmye17xmCsrtwDZEGcbo9HlwTSFs++LvgPeoL7UIYRpuibfzBZqEXtepQeTQhbBYKdOGzRZpvdWIKREI6MeDi9HhjvR6+VcxG37CBdVRv3HSkgQtPNHKB6LMA/CAbjK2XmAv80zxe0iyvhpHm2pLNlBai5qcipxzvV3OEHmj6QG+Zo2NyJmguJPtYwsMwgl6o9yHX6ssdL/obmoI0/e4NNvj0Iwkx1Z/v1Kl1AwJe/WtV44VX1Oy6jK60iYeYnt+N7or5Eun9cEjDChBcgW1K1eel9wCvbBCMd/2OnE65yCPVVTMuh8kYNeXpTuwGmdVBxqiGH40CztGy4qt3omEqMWOl7BVNBCMlCX0XjfndnYN2EUW8V/YdN6FHj760xZc8qVdF2aTmS2yQlGgNWYk3p0/VgipWDfkIcGmvb6FBTevd5Ea2Nusu9JPPF
 VGTa6qsY
 N+Xdmdir4xwae8lqSJdeZ2xJjj39VtDI225bTuu9sQJjQ3F9+ZEHPmNvZfIKs5pHs4Y9fiCuir0fTDbTGU+w3vz5gIMzvwwufRRgtbsjj0Tl6icgnDVeFD0QVfoaN/wuvMjS0KFNK4zyUkmPJ0UO5UUiMxJc2XIaNwKSMNKHdN3NEp14APP2Y/Sy2o5zDygiOpm/QuOGkfumv0IrBSCXaaFWf0Ytvswi60R7Tn3xOVe3AGmW8njmw1wnghiVrl8KUmqtM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

book3s64 builds a swap PMD by running the PTE encoding over pmd_pte(), so
the PMD helpers use the same _PAGE_SWP_EXCLUSIVE bit. It is also the only
powerpc variant that selects ARCH_HAS_PMD_SOFTLEAVES, via PPC_THP.

Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/powerpc/include/asm/book3s/64/pgtable.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
index dff8790a047db..28943ef3c1c80 100644
--- a/arch/powerpc/include/asm/book3s/64/pgtable.h
+++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
@@ -699,6 +699,23 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return __pte_raw(pte_raw(pte) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return __pmd_raw(pmd_raw(pmd) | cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return !!(pmd_raw(pmd) & cpu_to_be64(_PAGE_SWP_EXCLUSIVE));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return __pmd_raw(pmd_raw(pmd) & cpu_to_be64(~_PAGE_SWP_EXCLUSIVE));
+}
+#endif
+
 static inline bool check_pte_access(unsigned long access, unsigned long ptev)
 {
 	/*
-- 
2.53.0-Meta


