Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D441606D80C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 18:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=xiFtTF+U
Received: by kanga.kvack.org (Postfix)
	id 116946B05BD; Thu,  5 Nov 2026 13:40:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE736B05BE; Thu,  5 Nov 2026 13:40:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004466B05BF; Thu,  5 Nov 2026 13:40:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CDF5B6B05BD
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 13:40:41 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3BC1380BA2
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:41 +0000 (UTC)
X-FDA: 85401931482.08.413007A
Received: from mta1.migadu.com (out-29.mta1.migadu.com [95.215.58.29])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4489D1A0006
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 18:40:39 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xiFtTF+U;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793904039;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BW1nQsutnrZitd0IEzC284qt4pUoWTmeWnhpOQZQ17M=;
	b=IbKqSVzw3sY1aI9YQgNBgMiNRHH7U01Ic+EzoNTTw/8QshNVJtJtDn7hVEkTaaY8SSM91S
	viDwab5xuMCJx3xyBJop1XJHwy2ehG0YIR7c77GrUOgN9lMW1x9/4U5PN9fIRxYtybNf4h
	8kyei+GEF0clsEmM6wiPHGCTGMClP20=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793904039;
	b=JCeC6wqxJa4T/3HI/Cy4bjmD/2DX2gva8G1kyP6eVt6kQe+FVHBKGSLmgaJK2CgBoTiS8A
	U7zeJYCRti0AropCIrJrF/zPwIw7h0ZJxQ3mZsMYelTeGtszxFOTzIrCdguMfU8JiW6z6L
	jSZAADKomIbBG3iB6jHkEywe5A+ohTs=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xiFtTF+U;
	spf=pass (imf19.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.29 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=wz3IjU8MmdepamXobqBOtTMChOSj7PBIYvSm39xyfBE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793904038; v=1; x=1794508838;
 b=xiFtTF+Ui1yW1hheZjC/GYAEq7qkv2Pn/Ap+dIotL/UKmFuuwNaxgA3PGhI3gWuvk1j+kRDt
 7UaK0xTSrhxeGop6VjjFG822+hZlOJmPTT9Jwf+C8kYCgXbyourH4IYuvppWPO35RAeLBzxJTf+
 ZN25/Xwwi/rO8Y9VuKrFZ0w0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 50c412d95539fb94;
	Thu, 05 Nov 2026 18:40:37 +0000
X-Mizu-Trace-ID: 50c412d95539fb94
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
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	linux-s390@vger.kernel.org
Subject: [PATCH v9 06/32] s390: mm: add PMD swap-exclusive helpers
Date: Thu,  5 Nov 2026 10:38:50 -0800
Message-ID: <20261105183940.2236717-7-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261105183940.2236717-1-usama.arif@linux.dev>
References: <20261105183940.2236717-1-usama.arif@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 7fm19p8wtu51eyn8oo159gdbjhy48wce
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 4489D1A0006
X-Rspam-User: 
X-HE-Tag: 1793904039-182673
X-HE-Meta: U2FsdGVkX1+w6DR5Ds5pamBDthWSOts6DMVjqpu06X9b9dryOQcMwwMw+tXMfhmA+KPkWRnJk8z/Wn8DXuqYzmHsUAfD0YvFnWrEth5MVUbMIJ2gRc7r/d60YmwqL7A0C4GfNUVMOrFBsqsfmOZMx5eIV5LwLsqaWm54DQQxmnOM0uxN82oefDyy6/27lkl+4GiOz4RDQaHrA/mdnjt1TNkMacQqV8M2I3ddg4tZpOby/YjVul8NCIbY9mLd7WlCEe4565s1B08yJjP8iqIL2JGViN7lADX6l9LZnqO7hWVqTs5zXxW66eMkTlQ7fQiN84HXrNeGcuhuXLJxAMAB6+MdFMlY10pbncir4paApXF87w9oKU1BisUKQqUXdQfD7m1fb2DzxcLuV9Po0M7kwQqJenUjkFRSypGRqB4vTip9Rlb/sQyBN4YiXSMJYSSwEw7P0ghiJkaYriZr+WGqxmBHtZB8Zow2go+mxhICoTxFHR0HArWYbSLBzNMubV58/69zZSNya2Vwjqub729pcgM8XF8bo5Zg1V0itTlngwZF0JNYrkqPeGGba9xNAXt5EquvYhc+oaGAMSuvsldxkQ5zPKbyHOY7tgK4V4IIMvWxzT8ZK8QaOe66uLHzu5sZSJy0I8IXztirUehyhJ6awt4Vp6CwWRfiln33aXz/G4/IGQAjOlUEdlVPe7LkW6TEPkELxDgVjnkRyn8JbjxKMXv+mfY0KLVC4EGB/gAiJXi7GXy5tXaQgkTacrP+YDdDltZKhnjcAfAeHwHrNzg+JKMkenBb9IjufKgB0F6kug/2gx5qDixmGTTUZj5JQezY+vSBT3LA8XYeEllRhwHbShhZvj4l9LNlh3XipiT1d2SrlvslQIdaZtMn/KmeCqe4XS7su1irFCFW9cqK7Tg9QUqYF3xMH0MkflbdMiDK4G3zdZArcW27+92CKBToROm0lddUQ2e+6ZjaYebHE7O
 ZZxtMe8w
 XtkbmjwfWow1qcaQ5I5PLufdN4PSxil1b6L77yBH3dxACY+4etAzC6le/g7YI2ooIPws7eOEpQms4DYorEapG70qQJt9vVIBBO6ulUYWC4kHcsbFhW0ykZ6E9G04lq4frkolCOlcqpPzvOObxpBHAeOl48cKmR7RplA241l/KYbJZFQ39+n2LWhHL84abZD8oea+07V+GhA+bq3rBedgzfgyV1MmoFe8Ua5aHhXxJAo6YOKVdxp57fWt8nZ/Y0pcrvhH+6CncAhQcfu5Woc7Py0sDmQ==
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

s390 is the one architecture where a swap PMD is not a swap PTE in
disguise: it is an RSTE with its own layout, converted to a fake PTE swap
entry for the common code. Give it its own exclusive bit rather than
borrowing the PTE-format macro, and document it in the RSTE swap layout,
where bit 52 was listed as unused.

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/s390/include/asm/pgtable.h | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2d5c2ab06de98..2c6b5205ee3bc 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -333,6 +333,7 @@ void setup_protection_map(void);
 /* Common bits in region and segment table entries, for swap entries */
 #define _RST_ENTRY_COMM		0x0010	/* Common-Region/Segment, marks swap entry */
 #define _RST_ENTRY_INVALID	0x0020	/* invalid region/segment table entry */
+#define _RST_ENTRY_SWP_EXCLUSIVE 0x0800	/* SW exclusive swap bit, see mk_swap_rste() */
 
 #define _CRST_ENTRIES	2048	/* number of region/segment table entries */
 #define _PAGE_ENTRIES	256	/* number of page table entries	*/
@@ -893,6 +894,21 @@ static inline pmd_t pmd_clear_soft_dirty(pmd_t pmd)
 }
 
 #ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _RST_ENTRY_SWP_EXCLUSIVE;
+}
+
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return set_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
+}
+
+static inline pmd_t pmd_swp_clear_exclusive(pmd_t pmd)
+{
+	return clear_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
+}
+
 #define pmd_swp_soft_dirty(pmd)		pmd_soft_dirty(pmd)
 #define pmd_swp_mksoft_dirty(pmd)	pmd_mksoft_dirty(pmd)
 #define pmd_swp_clear_soft_dirty(pmd)	pmd_clear_soft_dirty(pmd)
@@ -1900,15 +1916,15 @@ static inline swp_entry_t __swp_entry(unsigned long type, unsigned long offset)
  * Bits 59 and 63 are used to indicate the swap entry. Bit 58 marks the rste
  * as invalid.
  * A swap entry is indicated by bit pattern (rste & 0x011) == 0x010
- * |			  offset			|Xtype |11TT|S0|
+ * |			  offset			|Etype |11TT|S0|
  * |0000000000111111111122222222223333333333444444444455|555555|5566|66|
  * |0123456789012345678901234567890123456789012345678901|234567|8901|23|
  *
  * Bits 0-51 store the offset.
+ * Bit 52 (E) is used to remember PG_anon_exclusive (_RST_ENTRY_SWP_EXCLUSIVE).
  * Bits 53-57 store the type.
  * Bit 62 (S) is used for softdirty tracking.
  * Bits 60-61 (TT) indicate the table type: 0x01 for REGION3 and 0x00 for SEGMENT.
- * Bit 52 (X) is unused.
  */
 
 #define __SWP_OFFSET_MASK_RSTE	((1UL << 52) - 1)
-- 
2.53.0-Meta


