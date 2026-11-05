Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9E44606A334
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hsjBpTsA
Received: by kanga.kvack.org (Postfix)
	id 64BD76B05B7; Thu,  5 Nov 2026 13:40:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CF116B05B9; Thu,  5 Nov 2026 13:40:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BB166B05B7; Thu,  5 Nov 2026 13:40:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2811F6B05B7
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:40:06 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C43DF140BD6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:05 +0000 (UTC)
X-FDA: 85401929970.25.3810C23
Received: from mta1.migadu.com (out-210.mta1.migadu.com [95.215.58.210])
	by imf30.hostedemail.com (Postfix) with ESMTP id B26A280005
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hsjBpTsA;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TAssQInwTzZeF9VmFhLMiXUuVNp0io3xxOUzWahhLeo=;
	b=aitEg7AcmU6yqtKZmkQBvIo3ViQvQk3OlBtZIQhdlfpoGIVGmCYjuvXuYnuquxB4VK500Z
	Egnb5c7+10EchAnE9z+MBLis9pR0UK1N1DJVLPEbEKJpn95V8hk5E+KP2l7RtKuinO2SYx
	U/XJj42rrKNnH8rhnlp0y/DZAmA6UAs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hsjBpTsA;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.210 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904004;
	b=jtMh+mLfmybVMwQdDOkc/oiLy+9mLatNhpg6GLK+sMU6SxFqr4Tv7LE3OsJWRRuZYd6Udg
	fWlAew3XXnIZVPg2Cg2DOH+uN0+f26r3huAG6uS1XK2Cs6tWUA01G5jkSuA4da7fj8HLO7
	ijjsmJn1IxZ9nfhFwF4DGN318md1CnM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pqwePApOX37WLHzM+DYHEdjaAYjW4/j8D/dxxSnSyeY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904002; v=1; x=1794508802;
 b=hsjBpTsA1b8T3E6G+CH41uzbmsMp6UZuSzNDvlj7V6vDVMQVoU5oSScyC2DUJEylL4IZhaWI
 wALdDBV+ioiaOI2egvPkJ11ePZDEhcU3/FassEqsankhX1haVYf995j+mVJ4KyCIqYQQyc9Mx/h
 p2pNtTtV9Tt7ADYyziiA3Gbw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 1f78b343f3c7b01b;
	Thu, 05 Nov 2026 18:40:02 +0000
X-Mizu-Trace-ID: 1f78b343f3c7b01b
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
	loongarch@lists.linux.dev
Subject: [PATCH v9 03/32] loongarch: mm: add PMD swap-exclusive helpers
Date: Thu,  5 Nov 2026 10:38:47 -0800
Message-ID: <20261105183940.2236717-4-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yqyq8e79bzjfg6f49p4kes4z9htxpa9x
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B26A280005
X-HE-Tag: 1793904003-945386
X-HE-Meta: U2FsdGVkX18WynZAcpgFZ7slA1uVptUkbMDbQEtth07ptE8S9ZHdgfvcXJ3jIte9GKSZC6gJoIAkWJDEwKScs6iRb+k8bi4SxUeuPxDT/8aHv6eR77lGL0BzpcALQNA8fVtTeflgj5QEjE9/EemKKxW1Wr/sidTcZJnzFgRMdNzaqdPVo8yac9XAIhFhuTh87hc7GeW/nXYSoiS4wPeJESTp+llEPatI2x9YgdaZnBwBBrBhfOrC02NVFsy0X11UMr8JWlH8ffozFxpzs14ByaTBO8KaIjskH3///1qPI+PQz1+QqxPxoizzMj7tY61M2huHQzwxkAbb41RNg0gxkZa39e/ydef7mXsJrh2QfEmmcW/rZC4Xia+PTRwCzi5e3YVVMJRSH/+KV7VKJ6Ts5JeO3ZMxBgqZJHDggni0tuX7KsKYw2E2f0wXyMrdX+KF6JaU3RPYOWlhfvrEtLHyYiMmDMKM5t7hyQYoLXF9Lh2Y5Z3WWoceVkRgOJAGQkG5KYDruduB2ZfNa3LJrh3TMVr0n7ifnL+2Qcf+ZF5vq3ZXwUesy6fndB1HlMh+a2D1Jrj96+NV7bET8pjIXcD+kFHiurN1QXyO25jO6jbk/wztfvDs38tmISkHkEgmH0Z7bvzJYk4LZM6UOupXVC5H8AVnPcn4dTbMqr5ZluA8ikzWPoC/DiizoNTW5/A6DNAJVxYBrfJuneMrhllXgsxzHn4aRRWEaYOtyiti4XhO4LOQQRGQlbBxYsKNsDowrfjnlYjTRvTebVuWumKZ4WJiZlv5R8UK603mLIs1yFKdQchExjBrw40HRGzshmnpnW8ODbcxj2ppu9vqKB06xgi089a5KcTCOVk7NEvSxeqixF4aeKsrzddFXdVMwjhw51SDW8nLs8K5EJ7XIT4CyY5Ct2dSse7PmRzPNQ4y0x0vV3hpwxHBLvE4I6YD4Bu0VIFJg6cvQ4V5FWXein7SFEV
 YcXtZbMU
 v+WdiMcWI9df4cfSh3kGWp2TyR2P2PISxEKlc34DQwqFkvs/PVMu4zx6hppfoCP8sEwxtiQabzVPKl3q+Dt1S/J8eYjy/UkVEUcRHxPeE0KtujaKdJiVN16tvx8fhKSDFUIrEv73qHJlTmkHxaK2pBToI4Yqfw89a9YgJzOXPk0YGkB/nqm4mSbKoTWHvijnYX3nh63ZR5vu07NphkdyFvumni7DjLhZx1R0+UVs0AOaXa7QMXyR+4osGH5ydzbyCDJBvGIOqFo9eQxqQWDaPLltknA==
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

A LoongArch swap PMD is the swap PTE value plus _PAGE_HUGE, and
_PAGE_SWP_EXCLUSIVE sits outside both the type and the offset field, so the
PMD helpers can use the same bit.

Cc: Huacai Chen <chenhuacai@kernel.org>
Cc: loongarch@lists.linux.dev
Signed-off-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
---
 arch/loongarch/include/asm/pgtable.h | 19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

diff --git a/arch/loongarch/include/asm/pgtable.h b/arch/loongarch/include/asm/pgtable.h
index f876031351319..30a256a99bfcf 100644
--- a/arch/loongarch/include/asm/pgtable.h
+++ b/arch/loongarch/include/asm/pgtable.h
@@ -352,6 +352,25 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return pte;
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _PAGE_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	pmd_val(pmd) |= _PAGE_SWP_EXCLUSIVE;
+	return pmd;
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


