Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8F364CA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 09:56:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C766B00A1; Fri,  2 Oct 2026 05:56:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92CFE6B00A2; Fri,  2 Oct 2026 05:56:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F4A26B00A4; Fri,  2 Oct 2026 05:56:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4FF6D6B00A1
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 05:56:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B21AA1206DA
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:18 +0000 (UTC)
X-FDA: 85277230836.25.9A9B215
Received: from mta0.migadu.com (out-252.mta0.migadu.com [91.218.175.252])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB378120003
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 09:56:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sL4Zr/EP";
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790934977;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Xn1SGo8J8REQZzR0xAZ/atIMt/biPZsgy33Qr8jMNN4=;
	b=RgP9ET32VnNrSse4+mWmhb8UtbF2j/aV6MXL28ADtXQnVcKKd4LNP9ziEXKnSxdUZuuTq9
	o/8m940ieLECTsbB/Kzo3IVSJZyjlbsh1uTmWSxKoSCbao4wsH61w1bnqtzMkCQ4r9KL+5
	RHklTwBzZBO2mljyBo2drFrgkk9/HYA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790934977;
	b=3WgL8cPc2s3UL7hDGj0/WzY+G4/T1sRk3Q7t0iORC0xsO+vXGzal/mfP7sw8bb/gf30NXg
	VtoPyOMsdZ0tlGoZY+yK97YQYsPuXCfGthnimfWirCcOLZKfNU4aXQiPD8tLjs30ameaoB
	nT75uU4eXYyTeUMax8pItIGcaNlSRAM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="sL4Zr/EP";
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.252 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=SkgwF13s5EnjFfE2w6anFKj/c3HQiyeMzlP/C9PzmRQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790934975; v=1; x=1791539775;
 b=sL4Zr/EP1xHJNYllyKZFF0kpN/pQjNc3olsbbTdBvDtwHx9zFoQQlmhrkAN7cSNyQIeBjOQx
 rhXlxOR+OuuJ2LatePN/Mn9KBjmckqzGWP1gWeY7yAHu1yXHYQHXls4xvdUHge70X9Y1X11Mi9R
 EYYd7erpVZHIGyn7lsV58oOM=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a7de3ec2297c0b41;
	Fri, 02 Oct 2026 09:56:15 +0000
X-Mizu-Trace-ID: a7de3ec2297c0b41
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
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v8 06/30] s390: mm: add PMD swap-exclusive helpers
Date: Fri,  2 Oct 2026 02:52:20 -0700
Message-ID: <20261002095503.3585565-7-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261002095503.3585565-1-usama.arif@linux.dev>
References: <20261002095503.3585565-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB378120003
X-Stat-Signature: gbkzy13b54ayfobsrxtb6qfazq7bh9nb
X-Rspam-User: 
X-HE-Tag: 1790934976-279720
X-HE-Meta: U2FsdGVkX18uf4e3IV1CvEKenpy62KQhoX0o5DAVZwQRBX+AuoeTh9jw9Q6BzBrOmjIcOVJxBUP7GIyAcW/bB7N/5zIXorMNleCp1ph5TjCaEQLZRKHUxaFQl4gdcW3MlSgKUxmrDNJ10vEj441p25yMtT5L4bQa37FLTALZ9sb062PU+oRwVqQcnXjbBmlcKXSblAJxOWqw3psa5EjuhmZTRt0louwqdXiFksSX3eoHIqdkOLj455ZaAPWc0Q3bmq34tkKNZipstYc8UHetiov72Y7+K/TLbk/xawNUCx9FWl1nVjJ7pvlzlZc+KnQ9Dtuhwq1tKUMpozzOv9q8PHIkklhy8xsVNoUUoKnwzMCZC04PuniTYmdIRDsb9TdfstG02unifQf5QDCV+UejT/K1NHNvnwmBX2OSw3wK23SUVdsj7u6E7NltuOAiTU08a0RJ0DfvA5qgxx45DhN5apJof3JfQR5cTvNFQjDALUJmntUOQMFOpziY5GHKco5jGLa19gJcUP78jnIjINAL3pCITAqNecsuQ5zPMk2/A4adGm3G9O/QDDwR6Yp2yAyFzGO9b0HExWnBU0dGEd/5lAHTMyoaMs/eyybqjT0BTPm0rNhzHLPOXOZP/rkdzGtubwsI3EkklYbnWxamQcmsyTr9dVrG9iyVgAxYbQ8xmMfcm+7J3uw4cSh82ZhhX/zDlaE3KMw55vLSI+CDdWMbjLrFaugs0YrRuBeIsP5PbSQT+rIlIBj+B2zR+YM43rgml4g5eXWKnMaU/0Lxr5V7fpnnEiBoGbXoD5mFdLe2fnrkQpyvFMSPCrNkBTIqtBUs4Z7LAQL6M8PrSQfzjl1CeJekHATCAo4SMhqo7mEiRUQDRf2F3JyXpKEqOh5QGvwpAE3M3UOIoEQV+gdiVarjAGYdJcIa4jCW3nJuKGlSZc8D+nDHjV2CYs/aK4LK8qKFaNQpNKfQ1jfpIDHA9Sv
 VvlI8sv6
 gaz3Hlnj30HBoVbLzXD24NGCOObJQQ8Fv2hyD9dW/xSh+lLLr1/G88SKvcKzaOr9D0cSgKzahLjKlXodBEuNLC9ON8EC0ikVD3KRWoPPcoSndwdUmnMA6l/4GrQZthgrYO6wG59g5IWfoWuurP2x/qa7DaHzYV7PZ5n/OgHG+E0607taw1ztPIll8ZwkOsk+EUVyrdcs/2wys9t5nL84x/GqoVE1lGoRX8WqIbV4D3FOzXu9joU/gwaUtlFQXgexXP+rC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/s390/include/asm/pgtable.h | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2d5c2ab06de98..afd886edf0594 100644
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
+static inline pmd_t pmd_swp_mkexclusive(pmd_t pmd)
+{
+	return set_pmd_bit(pmd, __pgprot(_RST_ENTRY_SWP_EXCLUSIVE));
+}
+
+static inline bool pmd_swp_exclusive(pmd_t pmd)
+{
+	return pmd_val(pmd) & _RST_ENTRY_SWP_EXCLUSIVE;
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


