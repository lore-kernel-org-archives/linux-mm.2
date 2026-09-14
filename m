Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ADE1C88E50
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 12:31:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A03646B00B1; Mon, 14 Sep 2026 08:31:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D29F6B00B2; Mon, 14 Sep 2026 08:31:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8ED7B6B00B3; Mon, 14 Sep 2026 08:31:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 700436B00B1
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 08:31:49 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A546540384
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:48 +0000 (UTC)
X-FDA: 85212304296.09.9F1B778
Received: from mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf29.hostedemail.com (Postfix) with ESMTP id C582312000D
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 12:31:46 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cUeMcohk;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789389107;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8DfEuMnDdiaQOe0byM3OiL0at6IqDBDnaJpEqVz4P9Q=;
	b=KQCaWOHC239nuibBb8SFCYNfXaiEc0tV/hlw5atDttH/GVzas5SYGX5zpJRuaumi2DNLdz
	EvwJ5JxOYlXRptW7k0ugQnK5pvyr/Wu0JNiBUhmsLPQm3Q0IAwXrA4w2JHkf6S+rjWik8u
	5InBT7JnW+OWD5wdh8xqrxQwZoWprGM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cUeMcohk;
	spf=pass (imf29.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789389107;
	b=SJt4LP/6xxWLQRDu4J07cy899a+YUugYbSTj5IcHjQQ3qYaxzlSxy2gqFQA3trG3jQqh+N
	qEuhOLzYnqSgN7zRN8AQZtyGeDAWMWOR0UV5CWquSLoc/t80MvKNRkjsGhbfPBRnK7ba6I
	NEkCybeS7vTLRxMTz6zJ/2wOcipjOuY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0pxvz2tA8d/MqnhA+ARBMVfrRyK0IVtO3kcKq5jVvyM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789389105; v=1; x=1789993905;
 b=cUeMcohkP1jsBtxE6fis2Pimxgeg45wvpSINk23Rh9u406i7JrWBmjRGOU3FLpGJil5tQs34
 Y27hM6JDd30TjiXdkGpgQR2wCV/TAZjVMnElrtxK+mKnmfvZQax78mkl+4MNh4kAKDzHPp8pMWQ
 LVFNKoDG/PvexTPaz3c7SExU=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id a8f2f31ac8e52b34;
	Mon, 14 Sep 2026 12:31:45 +0000
X-Mizu-Trace-ID: a8f2f31ac8e52b34
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
	Usama Arif <usama.arif@linux.dev>
Subject: [RESEND v7 18/29] mm: free PMD swap entries in zap_huge_pmd()
Date: Mon, 14 Sep 2026 05:28:08 -0700
Message-ID: <20260914122950.3283997-19-usama.arif@linux.dev>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260914122950.3283997-1-usama.arif@linux.dev>
References: <20260914122950.3283997-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C582312000D
X-Stat-Signature: nut9k3nwh4h3ccbfeq8pnsdz81ozghji
X-Rspam-User: 
X-HE-Tag: 1789389106-835
X-HE-Meta: U2FsdGVkX18YUCfUZdy7jS38maFLYhZG3AE45lsHQHHwt5y2D4Estn43aEFDEbof4znwmFh6sxwmK5e7nj68zItIlz+Q83XuFIWyCNDhCYKlCpTuG5yUNxwN+OsNVZuKSAtqgJDsbw4TK4tW0igVtVEqvvZwr1XGX4Hw9UVgtZCmLn8e48uTDWJ5ZrvLfRsSiz6Bf9ZDcEiKpdcownC4XAWEZ4RQ7tVainlyhCoRZ93r7LT2dU4t2d0XWMp+742FuYpdslQTzF2PWz64pjF3NEWXKXB+eG0k2L54TpewpPrGgqP71nN0TALmxCJfnHp5B4LmvidnLgFvbtXol5tqDFOnXbxlpiGYHYQWEEEMeatsK5gG5wZRpbDokR2bV/fXxv1neVDWve9avANHMGx+L+khDEA192LEWPzV4dITWg6h8n21CH19AzAwRs5JUTchQjrUOLC8VgqNIBmbQqZdmC0XYA34fn9c2TTZxEmyvigijHbTXjBPwGpLcQo8hgk9lEuskMUEN8Ufm02NKc0E4gmORNdYjeGV71KquR7FLNI7JEGg6ph0gEsFB8kvv4KCin7VSmvd/zsHWB2l5T3CvhAP/FXVwk7UtSZ3yniOTVVrxfnquFZTMABZZ2JGgMKFFSpGEFdKp0+nLJ7rAJEG2YRr+0RM//V8t6zoZnzYuyDSAt8O3V8Z/l7H3HLBMWoAs/acOgIXJFw3T/41yXMj0/5SIlKW/zo7CuE/jP3YxWkkMnIkACorPT6DX76GIJX8WlKkLeBav1GRiTfDp3aQztM3THmKfukanl+dz4YhHigEmQsEFYQzzP8SvpTjqa06JcEG3fJHltigqUZMCqmtStyS33tLnsOaP9WHG5u5xanKRCQ/nLDmLq5fMQpdCWp3mJpdsNVYrlcDHdy2Yy5c52q8TCR/Rjg9e/4fE7dufeZm/sfdCQXmg85cxtmlKYEjw0QFINqzRiKaCymFiCN
 6XAftwqD
 yeHD3R4/4x0A74cZk2Zxwb9SAcRCc71Y1C2YWrRNuLVejosHuF7NsNFTz28wrhQ4d8C9CMMpw+x7UwVjO85auxA19lLZWQ+JJY2jlb22r8lpqtHwOOZPNnTjySZ5/BkoQ+wUIRfQbpwmU+IrpWLjzT8ZUtB0REXY32tMoMgDYnwtGm4qx6A+007NtXm/hqCf0ZwkpCqvt6YYwvZvMt0fH9XlfZbo2A33/2Z/gA9ki7zFPju62GynLg9D9w4n/+bPjKGdNUajk6E/tD8lYHVnApodyDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zap_huge_pmd() assumes any non-present PMD it clears references a folio, so
a PMD swap entry would reach normal_or_softleaf_folio_pmd() and warn.
Worse, nothing would release the slots it points at: unmapping a
swapped-out THP would leak the whole PMD's worth of swap.

Handle it before the folio lookup, as zap_pte_range() already does for a
PTE swap entry.

Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/huge_memory.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d3d0fec9a5ff3..689a1f4286471 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2628,6 +2628,16 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 	arch_check_zapped_pmd(vma, orig_pmd);
 	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
 
+	if (pmd_is_swap_entry(orig_pmd)) {
+		softleaf_t entry = softleaf_from_pmd(orig_pmd);
+
+		zap_deposited_table(mm, pmd);
+		spin_unlock(ptl);
+		swap_put_entries_direct(entry, HPAGE_PMD_NR);
+		add_mm_counter(mm, MM_SWAPENTS, -HPAGE_PMD_NR);
+		return true;
+	}
+
 	is_present = pmd_present(orig_pmd);
 	folio = normal_or_softleaf_folio_pmd(vma, addr, orig_pmd, is_present);
 	has_deposit = has_deposited_pgtable(vma, orig_pmd, folio);
-- 
2.53.0-Meta


