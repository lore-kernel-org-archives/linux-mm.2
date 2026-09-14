Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C46B3C88E70
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 11:44:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4CE6B009F; Mon, 14 Sep 2026 07:44:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C65AC6B00A1; Mon, 14 Sep 2026 07:44:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B50286B009F; Mon, 14 Sep 2026 07:44:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8AC406B009F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 07:44:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AC05516034C
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:44:00 +0000 (UTC)
X-FDA: 85212183840.05.8D33E7A
Received: from mta0.migadu.com (out-113.mta0.migadu.com [91.218.175.113])
	by imf13.hostedemail.com (Postfix) with ESMTP id BFD6620003
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 11:43:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kjmzxUBU;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789386239;
	b=08TRN1tt1mOAU2TiZSOXvHD9ZKoHfYD+jc/wxdPl+SUuP3NpHmKFTdmqAWSlD/lnkBr2kl
	UTyDszFVe0AIIfN4Q2JEH/FBZ5K6PEUw8vOwuKhBEq4rgs/yQuwNmVR487c0id5XtU8W2O
	7CcxACxaKYV6V/e2SMBDebnyHsfXBJ0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kjmzxUBU;
	spf=pass (imf13.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.113 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789386239;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dxd7w3+K7CWhW6UE7lMWw7tamjlBh1hX00dEb06Z6H0=;
	b=x0RDCQQBDSY4xtPoUy68oEs8HPEWKHfm+VfbT5n1VMoAiqSFBtJ9blgzyaQZB6Lk6M2Xtt
	gP8A27hr+HAfn3sn/nCZMaK6kCOc1BF3Z/3phiSE65RtH3t02ehVv8VaEb6cwnBh+loe+G
	hAng4v9/mVsHRDsPrN8hMjb7FRqZH24=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=N+dRbJAiKiCxpTGr27ho63g/6orT5YaFsO8QYoCGDoE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789386237; v=1; x=1789991037;
 b=kjmzxUBU2iQUdeBTLej9Kb4RLRkXidKFp3pWrExf0h6c79YFxSK3fURyNvl3mghBFZFcHF71
 XO8AUH7boJ/6zlGsbsxL2vd24ctXbuUmBoQk+ARlkV0I/G+wWl/7kxhIKKJEBQUIWRaq10oh53k
 4/+ugpPudakdr66jNpzwaskQ=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 8319a445ae2ffcea;
	Mon, 14 Sep 2026 11:43:57 +0000
X-Mizu-Trace-ID: 8319a445ae2ffcea
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
Subject: [PATCH v7 06/29] s390: mm: add PMD swap-exclusive helpers
Date: Mon, 14 Sep 2026 04:41:58 -0700
Message-ID: <20260914114320.12988-7-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914114320.12988-1-usama.arif@linux.dev>
References: <20260914114320.12988-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BFD6620003
X-Stat-Signature: 3gn3eiq34hxsir4hhf111xabpmopocmj
X-Rspam-User: 
X-HE-Tag: 1789386238-606548
X-HE-Meta: U2FsdGVkX18nTqz6NK1fMaHBNqZiN7/M3bnKUIp2lEf/oOLSSTiTRtEarhBbSJHMwMBRfdPRVU9pSTKrfMRCUR7SN806m0RhHsQNcBi7CU8H7J8+3zTYZ6t0vh1NKWbcohjWtfDY7sBindBXUBB8YpNwaY33szSrHV0QTd93H3i8srU9Uvv8J8mDLFHF9zYiWxyDbMtUaHOz9umf4vytBhpqBINlGQgapCadG1chBRKYOb+avdOuaTXVgnyqdtgjgODnv8tdVU+Sg7eRXlHsdx2o95xRP10qXrVDjB+/lq4uRng4Kg/zKNkT1W+28R6FBn93GrdUvbB8ShZT2pIdJeXEZdLKcnlDJLAH0jRNmmlRAvY7sP5Q0hG19ng9POQ52QF9PDiWBmNpXLXXZg+nS+T0uM8MA6HoSSBECfmV+CqvtxNyIXkamFn9lyFwSPysmtJfrVC30vLRyrlYlWoRYMh2WS0sNgV2s1uBM5mjTIiuhEJHZX2icl4+1lsAA5RXqqit8yvPo+EV8ApIq2GnxF40k7xkdmDhGGobR51RbnLwvDDJNN/zZSvidOSqZUcubpEjrL7Fa68g67SR55L8UemwrKgwUyIlmC3h2uXCZ9A1FfIWW1BFLvikCfNbDqgVP5kYteyTq4bQWNGb8ARbwPeRZcnMbIEc9fw3yegxCD9Dlpq8DBnlPUcSQa0H/fDPs46zyHGo9UA4qngl0oDm5zrTSpBMCnAgLrEhtY6zOCIYaB3PsXaXdNlTcyXFW6wcUOu34wD5PV7ZY13+yP0w2ONleZTrqQRPkN6HnHM7fO+5xtD5sB9/ZhSEkftyV3a+myROsgK1NCXHtBv2NLfuDEnRwDkPnQAKmk1F6/WBfA3m73einlhdwhmyiL1dOjrkDS+SsaffddlWR0rG4r5vZDzRWRW7t0PX/GNG45weaGEcR12nkEp6qkqwLfttZBKC/Zz+AKTitut/F/QUTps
 9uyeSehO
 uzhfrCeLJ9DuIp4I/ezYiR/dXQUfvnIeVYWxQvee+t0+duOwoEr6e9AGSpZKlWVsDJOpaG056UmKxplak+NRHjsYmmz9xYI+4knY+AGdR+vZQbmADWaQ2Tp11Cf/ORNMPDNV2hl2FJBUHdKXx70zbqAcqvbPcj7bO9RXlEEFEHW9No5Ie06Aumb53dxkBHll1wcvF1ArukeOybMIuJ3qCl8qrs/mjyKAAXXDnfymy/96KXkZdi/69Bbw7W/rgc5jWZrWT
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


