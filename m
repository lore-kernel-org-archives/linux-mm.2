Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 33652606A326
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:40:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AQ3Ee0zm
Received: by kanga.kvack.org (Postfix)
	id 4E5766B05B6; Thu,  5 Nov 2026 13:40:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496096B05B7; Thu,  5 Nov 2026 13:40:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABB86B05B8; Thu,  5 Nov 2026 13:40:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3B16B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:40:05 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 25E381C4498
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:03 +0000 (UTC)
X-FDA: 85401929886.16.E97CFBC
Received: from mta1.migadu.com (out-203.mta1.migadu.com [95.215.58.203])
	by imf19.hostedemail.com (Postfix) with ESMTP id 23B041A0007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:00 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AQ3Ee0zm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.203 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYBFuxLfjxEha3Zx3xH+M3FFSL5fyPFntbBy1o8Jggo=;
	b=PjKlyexFXDI1UKQsqMKDCTMBlpg3c/mkNYtxlwbrT2n2vSlrrF+koIbgPNxu9o/aHZ0byK
	jGePB3cDAn2k+BiUprDl+yGDoSSoiqkGFewXXEx0i3XL4EQ1Kds1O86k4BupE5GfgSSWUj
	mvTLKJcGsAlFt7dxMLA7GBtIyTImsr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904001;
	b=dXy2HY0RVPKiE92JTNyQbfNvHWdWyhe1U7o08szcXFbXxbEctwcDO7Wc/hh+ZOctqJqFIl
	3NjlV+bg7rw2SMmBjh5aEx9TU+0OpjPAELgM4JiOGsNWmudu+s+shDaPU3exa0g2p1wECP
	micpKwAP7W27uY77Rd2HL0AFjjFlBQg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AQ3Ee0zm;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.203 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=XRcso4PQ7v/i8n+ltndwCCW38yTYyFOtjhZRQfQOu3s=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793903999; v=1; x=1794508799;
 b=AQ3Ee0zmoGLIrzFiqbNwH2X6z4iaE4E+ceCi77tS0EPnX4dETtsMFXi2XkALaPbkF5CBGMMy
 Kdn7kPwMRZDlQSnK7ZZE3U30X8kBunbwyKCdhgzdzRqW1CENcx+pkRvpuoHq84DRccjbVL7mVny
 VBCbRoF4lj6cxAjAaJn3j8cQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 2158ee7e6f7dbbd2;
	Thu, 05 Nov 2026 18:39:59 +0000
X-Mizu-Trace-ID: 2158ee7e6f7dbbd2
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
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH v9 02/32] arm64: mm: add PMD swap-exclusive helpers
Date: Thu,  5 Nov 2026 10:38:46 -0800
Message-ID: <20261105183940.2236717-3-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: uq1tcgksryr74n5u7hjj6a3nw58xfboa
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 23B041A0007
X-HE-Tag: 1793904000-70028
X-HE-Meta: U2FsdGVkX1+CIIUvochztumlddxmTRLX69VSVkObVt+142v2bhIOXEGqwNh3QgWTdw+siybX+V0AASve4UXgelIHcYLNwvIhlCIxbmXO0Wj3FMFz/ABune5PtJvWjpmY2Cbyn8wUgwLTyl13WEPxpUcy0r31VjSxXGmKy6/3Pxq+FWSWUCXY0UVm5TDR18/I/teL5tfRoQpX3VAX+CTBQtWgLLkyxl/CklF1FC4G8UoaHJmaxMjoOkUYqPAZeJIN3laCglewEtYT6yn2u7I3qeL37LaBQkApa4pswWYxiCLv2DzGS7/XB9qOZ8/POliwrCbOvp/opSikW3d+QLX03nO0lO8H3p/qMQyfXU6Zr9tsOCIXbBNl3QZr0LqLIhG6f4O0pUsoBgbA1RKcq+STJgzlwpJJjtVNY9pd8avYOQaI+NKXMvRu1XFnPSx62xdqaiwxQ4q2khRQZRGY3K1PoyiLp2nso/Bo4pTaVHrayfswP7muKvjDSknUUz/UXIF4NNUMQirXx/H1b3mN3ftU/5fe1vg282eqIj0n9GAfgpmLKfqqZQC/7qRxHbE7IGXAE5s7O8jf178EBVHERMY5PkmR8ZUmrK31NOM+TW+fxB459lg9Z9KMh2EMJRDx8Jsq3Uvm5q4HE1TJWiavTCQbVN75nIWlXkT1eVxgWOX65GmboWMS0sC6cEqZKcskmLe8g6qVJX7dDmNAn0mf+rnEJAfgugqA4pInTTf0+nod3U9JFEnnroYkn46x6eoUMddz7sq7qPM46FLZ29l5SSZFoAevt8DsqOEvZ/k5j7dGzpxuhWMWcBonpVIvdpukrUDay6TEO1qkyBJ87cuFH9ejQopQmc6UNWmn2HkS1d30+P+PkTj1U/ncBnmZJhpWooOwlEwcNkWKwJgP/TFhX1Bnj7V3TZCknM8Hq1d0qoJ2r9ApBD/LKXD+4EHLnjhneha8xhpuDfBTg5yVqQFCRd7
 S9n/0/Dv
 BiuYA2/d2uPUcb2x112h9XRuc2xri3/2KrlwsPCS/nmcq8mRGRJZnVuWub2hqSEdFNu8xtI972bvZE243Fq5JpPoVI+BYPpNJzgvkzyQ224n94LKZxyj/OakEdJx4tiaxn+rK3+z0WVTsOF/lb4V049bqfUo1n2Oht5EcjBtyEvkOs5AXCbYdOV8Qbp7CRZ2Hxxdrl40+XAVcBfQpd2UoA3zZ1ertzzhg9NvpaYEciOEDVrccaRdvtEbgx3SIyaN+/5zhRsmZKM6cyOz01RCGOFOCUC+PzYELLnLAaU8wlnMI5jZhCBHTfJmtC9SyE45bJsx+yiMtBMwEdWmMcaCw9PUPHLv2uyV5EUnX0K69DYSaBYsSoQb9VJaYiQ==
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

arm64 encodes a swap PMD exactly like a swap PTE, so the new helpers wrap
the PTE ones and reuse PTE_SWP_EXCLUSIVE.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/arm64/include/asm/pgtable.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a474c9fb485ad..dfcb4b9e66f39 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -560,6 +560,12 @@ static inline int pmd_protnone(pmd_t pmd)
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


