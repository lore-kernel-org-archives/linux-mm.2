Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8835DC88E66
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC11D6B009E; Mon, 14 Sep 2026 08:31:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A70356B009F; Mon, 14 Sep 2026 08:31:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9AF506B00A0; Mon, 14 Sep 2026 08:31:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A0796B009E
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1D26D803EC
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:04 +0000 (UTC)
X-FDA: 85212302448.18.D0473BC
Received: from mta0.migadu.com (out-176.mta0.migadu.com [91.218.175.176])
	by imf31.hostedemail.com (Postfix) with ESMTP id 14C312000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:01 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xsshYLyb;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389062;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dxd7w3+K7CWhW6UE7lMWw7tamjlBh1hX00dEb06Z6H0=;
	b=z6/bRZUJXgv4uZUMc9nMyPfolkNqLxwMgO9kHJIgx1wCtwIWbwf7J0J1CuKh+1aLaXhrzd
	6lgNr5NNSTvGM2bfSTjRsPbvzYcq7NgiP6lcu0LQiRnQuyUs+zSuVGmVvnjLPoiM+5LJGI
	kRF6QLtNDQQWXPy/zWA55qplyoFpTyU=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=xsshYLyb;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.176 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389062;
	b=yVK8VVcPbLgpzgM2W3dnpaivtRuDanzKt/xKuvp3I6W85tzAjGAbHD7pUiRADBvTsjH8la
	G9bgOKYIXpX6PEx8GCpwW5tXhyi726bX9qbXfGLPGTDs/6Cl2kmAtZQlPyhwwnr1EnJAAa
	L4Fn7LOKBVa/FNwLHv5gFIitkj724kw=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N+dRbJAiKiCxpTGr27ho63g/6orT5YaFsO8QYoCGDoE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389060; v=1; x=1789993860;
 b=xsshYLyb7yw87oCEK62zbNZcv//TVBLxEepVmEoW0YB7QmLIypzANdkvMPRjVIXWWWjxiYNK
 UivxatneTWdGrNfxO8AspBkSS6a3BqCVv9s+3yIXSja40/jjFR0hT91pUGe8Gok4Cu+3o6/wwNl
 VbAA7xil+5NUO23i9i8RP2Ak=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id ffd5ef34c1221106;
	Mon, 14 Sep 2026 12:31:00 +0000
X-Mizu-Trace-ID: ffd5ef34c1221106
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
Subject: [RESEND v7 06/29] s390: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 05:27:56 -0700
Message-ID: <20260914122950.3283997-7-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: nsa6fiiofiqm38gr8awmth9ixw6znc8f
X-Rspamd-Queue-Id: 14C312000D
X-Rspamd-Server: rspam07
X-HE-Tag: 1789389061-175633
X-HE-Meta: U2FsdGVkX19WqeVrxF3Z/c0AeXMsID5pOBHnGtXLj5t5JsMSSjQFWDxQfd0AZ5KGhZtsxOxa6JSKPSPhfB+RF3BI0y9PCND7yMCnJWmyL5+8+R+tgbQ74m6zMZpAfqKojz7xhkvGQlfWvLObjEoZEa9HIds8Rr5QCTHTpnglpA3VsMktvrmrdgr9JGGYcEd9dUO7XdkDtbfYN+4XU2YhXv1JUdmxDmAOZvyxWlWQjJchSdQy9ogGFo7nRoK4eSnpkVo1HuMZAFuUtw3TpfMu9RaFqo2raFuJw7JV7UFRm/jQQNhQWobgfXFt/YeAWyToM9Yed9MBUD3pRMczjglEYIk2kzV8HtiHEI0PcVRJUyleKJKBAhLk9OWhm/Addyv/tpPVGYtaY6Z9YexKgCtpXFkpgB8AwtOTi5VISHKx0ZO39d+OGCvfym/W2F5eR2tb6fD/aSWeswN1stA+6puWMTGn5G9guZRgDdDkxTFHl4Mmb4fOOVO3RmnguQWpHV/prsQG2Xw2EEJkKvcpYyf+/DfBS7NF6PW9sexAzaXp6F3dCH0qwuVgPgXMwOHLkB04IFsv/3KSMgD14R6t9XHyfEi+vJkXzW5rfciNTD781tt1GKxMLc/4LzYgyZtRk63eP1yuyjCak1vrPi9KtXj7LmPWGyMl9DvtD0E5Q4O3r4Zazgcj2oF4z7r7IbczWF/whunxW6N9NLo60iWrJYtGvIkqt3hIPYUh++2a1pFL0ICMxIDIOH6xeCwQJUxJWAYwDuJ7/D69YhDo1algBNV7Kxxhz4WIUvZ/fJYsGhgE/FD7RSw6OUz13Esid/RKtxFU6yBUonbpCgbIF0GCZhJOPj3xAasMB+/p2AKWYhCAh5M+nmVUtjFd3aJ6i7JnDwe7d2gznQ/OSBhDAynEkpasDMsIA9RwufJenuehbnQ0syBx19g0+7fBkjHvfL5bJJ5Ub982wimgKP+ubsd5iZj
 +3ajRwY0
 cJlr9k3C4l9tV8/4kC/hT78nb4jA9HTFa7euixgiTu34IhJKbdfCBws8EBH4jexMebnt7UEoClbexGinHD0WOMOn0MykfI962YclREc3zZZ+JXLolcGe5GTQrr4ScYv3saJ8Eq6NhowDYby0360Tz5t2blmnpqPY5ri+G9nISawQPjwYW+3zCCiVJWwN/QjuR+DM/2tm45nfRXNvUkciqqk5K75rINeqkvBtJaO+enfIzBNoIBjlT96Klpv6uEnap2Sav
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A later patch keeps a PMD-mapped anonymous THP mapped by a PMD across the
swap round-trip, so PG_anon_exclusive now has to survive in a swap PMD and
not just in a swap PTE.

s390 is the one architecture where a swap PMD is not a swap PTE in
disguise: it is an RSTE with its own layout, converted to a fake PTE swap
entry for the common code. Give it its own exclusive bit rather than
borrowing the PTE-format macro. The two happen to have the same value, but
that is a coincidence. Bit 52 was documented as unused; document what it
is now.

Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 arch/s390/include/asm/pgtable.h | 28 ++++++++++++++++++++++++++--
 1 file changed, 26 insertions(+), 2 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index 2d5c2ab06de98..0790a0884cfab 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -333,6 +333,7 @@ void setup_protection_map(void);
 /* Common bits in region and segment table entries, for swap entries */
 #define _RST_ENTRY_COMM		0x0010	/* Common-Region/Segment, marks swap entry */
 #define _RST_ENTRY_INVALID	0x0020	/* invalid region/segment table entry */
+#define _RST_ENTRY_SWP_EXCLUSIVE 0x0800	/* SW exclusive swap bit, see mk_swap_rste() */
 
 #define _CRST_ENTRIES	2048	/* number of region/segment table entries */
 #define _PAGE_ENTRIES	256	/* number of page table entries	*/
@@ -859,6 +860,28 @@ static inline pte_t pte_swp_clear_exclusive(pte_t pte)
 	return clear_pte_bit(pte, __pgprot(_PAGE_SWP_EXCLUSIVE));
 }
 
+#ifdef CONFIG_ARCH_HAS_PMD_SOFTLEAVES
+/*
+ * A PMD swap entry is an RSTE, not a PTE, so it needs its own exclusive bit
+ * rather than the PTE-format _PAGE_SWP_EXCLUSIVE.  The two happen to have the
+ * same value; see the RSTE swap layout above mk_swap_rste().
+ */
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
+#endif
+
 static inline int pte_soft_dirty(pte_t pte)
 {
 	return pte_val(pte) & _PAGE_SOFT_DIRTY;
@@ -1900,15 +1923,16 @@ static inline swp_entry_t __swp_entry(unsigned long type, unsigned long offset)
  * Bits 59 and 63 are used to indicate the swap entry. Bit 58 marks the rste
  * as invalid.
  * A swap entry is indicated by bit pattern (rste & 0x011) == 0x010
- * |			  offset			|Xtype |11TT|S0|
+ * |			  offset			|Etype |11TT|S0|
  * |0000000000111111111122222222223333333333444444444455|555555|5566|66|
  * |0123456789012345678901234567890123456789012345678901|234567|8901|23|
  *
  * Bits 0-51 store the offset.
+ * Bit 52 (E) is used to remember PG_anon_exclusive
+ * (_RST_ENTRY_SWP_EXCLUSIVE), mirroring bit 52 of a swap pte.
  * Bits 53-57 store the type.
  * Bit 62 (S) is used for softdirty tracking.
  * Bits 60-61 (TT) indicate the table type: 0x01 for REGION3 and 0x00 for SEGMENT.
- * Bit 52 (X) is unused.
  */
 
 #define __SWP_OFFSET_MASK_RSTE	((1UL << 52) - 1)
-- 
2.53.0-Meta


