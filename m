Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48A8CC88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C8B56B0095; Mon, 14 Sep 2026 08:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 69F216B0096; Mon, 14 Sep 2026 08:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DD6A6B0098; Mon, 14 Sep 2026 08:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 40D396B0095
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:30:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6BE161A03EF
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:49 +0000 (UTC)
X-FDA: 85212301818.20.A6D3F88
Received: from mta0.migadu.com (out-99.mta0.migadu.com [91.218.175.99])
	by imf28.hostedemail.com (Postfix) with ESMTP id 7648CC0006
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:30:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=isnHcp9w;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.99 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389047;
	b=F+oNOBWuIf/zCF3CDrlxyabVz76neLFynuQ776+xJOwqDHYKcKlyNH7jJKGPByL98Pjv8D
	xInZKOLkR6Z7bJFr+wo76NKxvPyrZ++V3/As3ucymKPAX917e74ZksabLuHqxCbnwpYY+a
	9AYMYqlGBXXg/dYv9kUKm3S2y1ujtV4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=isnHcp9w;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.99 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gdVA0eGNXuRt1yxuFyNyAv08OCeJaRw455a3UVpySG0=;
	b=VjiWqfsLQ5tJLPWFVFWazWGg+YW1BHl2H6l2J9gd1CNCHJ8NeU5vmAI6nJizDDPBiA1TMg
	xQ3v2+9hkT5+Zk/TFTk0sUgRk5yMq2+qIlkZHNb98Q+Womj9xoZNGXoDUP87cEU/xIL7t7
	MNNV2KKePdlHAAD8LuDTI94A/EdehM8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=owEO/GVV8kpSqjtX6z75OJu1GLQvZh0Qa08KVOaicH4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389046; v=1; x=1789993846;
 b=isnHcp9w4G5qacNcvS5Mi2mZmyThOkjHOVouC8pU6qeH1NSF/4NNT1AjSPqvT2kBoal/Bl36
 PpumCHIC/3aZbzZR8durkmpjgBuFwOyZtHY8FpN7SL6Dim1DUqq+wrUtM9tO+K/Z5xtgbj5daHa
 M8TnSIR9IYEB/oZefNVYqUZ4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 64381a4a761f26a4;
	Mon, 14 Sep 2026 12:30:46 +0000
X-Mizu-Trace-ID: 64381a4a761f26a4
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
Subject: [RESEND v7 02/29] arm64: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 05:27:52 -0700
Message-ID: <20260914122950.3283997-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 7648CC0006
X-Stat-Signature: 8m4ntmffze99u5egph1mmcy4hkobiwm5
X-Rspam-User: 
X-HE-Tag: 1789389047-143924
X-HE-Meta: U2FsdGVkX19XX9A91mJieraUS++VOy8PH28hYadJvclXUasCFlL+30AG7GAVYxUkHrIGgQCBzr7oCUojM47FTSqNl0NK40Mn6ApK/tjZy+7+7YPmXD3gwQN9Dpk3EhkQNFEG6jgRzv2Bx5EAIKYHAMFMnZhXyxfDk0IGiLKos1wdbErD3blsHQY4GaYb8BFJPaeQJbsOJ17G06+ukphl69yc20dVbpRix9pwFhblKy+BW+uUKvbFB9QZRY201AfweXrzo3I4D4l74ZL8DDd0S+NK6MeUDCBGmW/o/VWt2oTq0GdDxUnU9iEbYLzEEhZdIBJteYr00nolF6YndA/cSpaSh657F9zRmDBwdmVth5y+hkFDLJ3XUIKlbVKoZvzVsDv1FblQfoVS5A4ULYZbUfgFk1XYskFU2cXGHEnb+YFzx0IN1ZHz0trxB2EPz345F3fuHnwqbAKXTnjhwCfMHD2tdcQJWd7Aw52IMfJJXjv349cyG9QVH+Z9OYA4UcoOPj40bh8JXPxdDcjDAiY9Pr6+ur8r7GBgdNuvFJMHh50NNJX1Az2Gc1lkqKDPd/Z9Icu6J1J5yRQ8T12I0h9+5pnISfLify7Pkypp2P8WEKjWWT2P7AlB08qWCOLksdu1m5Hf5fZv60JO1eGfk5vxQn7CF51pzMIZ9bEr11wCiilcVBplQfWtMfr/hEz1FzdhrBU/6JVa4f2oMKo3g2iNZLhKQTDeU+Oow8qVgvGkPUQeWha97EHQxbLzq3JZKTyMJ6V6jrvNkzc2d0xAK0QqhKSJP99m/NmIH+R4bZ1R8M6fybgUi2uUoxhw3KDY0gjfgBzKHX3nbj84u0UPHZlrUyf9wkeoa8CKNlS7yCPqRegFr3pdLJFoOebsZ3g610jT52+nesR3B668pl4eouBZBUV207Ff2wGUq8dnd1hUPfs6LlNyf79P1MWQVcqNK4Teq/1UBCz8WXq9KYsXM0o
 EVHAwk0G
 ErFa5lANmywY/ZrBLz4yirJB37/8J6B3ZkG84ZlX8qS7ROdOp0MeOqo0YJQKuPBUXrGGwqfEOdRmXSHI8kr02zsURv1SuAIj4ugnv0ARl72QjSBav0biHFMPVFS53wJZUjvnlzDjwte5WmDWSZhZ+G4CSwziBtBUvbqs0Jz+UdST7l47GiT/GKMeKV/t1MHVTHL7VPIhyx/RNKhJP5K2HGrFCRgYfAGSOubAoKTvHwl2yfxPzl0tT3NzPEZCbOyrXPP+Ir+RPYv2bMpj3O0BnasWOa8Okfr8XfnCc8zrywZR2x1it+eAMbkqYyw==
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


