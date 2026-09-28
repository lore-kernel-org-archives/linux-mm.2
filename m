Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEC09C9833E
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 10:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15DFE6B00A5; Mon, 28 Sep 2026 06:07:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137C76B00A6; Mon, 28 Sep 2026 06:07:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 024FC6B00A7; Mon, 28 Sep 2026 06:06:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CCCC26B00A5
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 06:06:59 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FC374016C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:59 +0000 (UTC)
X-FDA: 85262742558.14.9F30A35
Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6FD74140005
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 10:06:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="T eLn1FH";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ULUMbbwg;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790590017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mHXoaw754rGVYU2IJZQxYw6TN8b+9WaFAkvTQR5NjYE=;
	b=FKvWJpgkZZ9m7RMXQP9iFM5akeh0nDe42mlLXjUam4MOxDHhUH9V1C4H9EXkAMcRY7h/Jz
	+mgmvikrO5ayKi0GoqRf5iJP/XE+0wOz8j8Eb0U9F9eGcTkoO7k/R/NOV43ylO/ne/Cxhm
	5blwflk6vjjIb1CRG3iuvsXJ7grUXOY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790590017;
	b=Q2p1pJzwKt+1bh2n78xBCGeIuTtxFnFLbd7lIWBzFjXCdD9cZE0EPs/dXX/ee8kjjvUWo7
	dOWpUxh12nCNLhG8Ndegcr1OaP0MVn8N8Qr+zWUz48rNhlut96BuFE2qjCPLg9WYnjzBaR
	lKew+DxgrKER7CwA5TyDHOu6v4n+UD0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="T eLn1FH";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=ULUMbbwg;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.145 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfout.phl.internal (Postfix) with ESMTP id 04556EC0102;
	Mon, 28 Sep 2026 06:06:57 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-12.internal (MEProxy); Mon, 28 Sep 2026 06:06:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1790590017; x=
	1790676417; bh=mHXoaw754rGVYU2IJZQxYw6TN8b+9WaFAkvTQR5NjYE=; b=T
	eLn1FH7Q80BIKNtF1OfgQ7HpLy+0Z4GrKiFI24uj0w1lpOHKjNJ9pIR3gIbSF1/j
	6JS/LY6BfF3XuheL6oIvo58X2iO4SRcxE8MWcWQhRnIt0qjEJ9Mx2AtD/N1Pe+ng
	icwor4q5zDpdTodecjeS3pnkom1ANuqlF61OweB+fqudjCdy+Qg78Q7cfJDtFwvG
	ewMyKhVBpJAZofSSa2YWxVWruKuCDkN/cblQe2oGaMVwKAfNqDG0RqcALafuEgeP
	n9SqAp9Yi37zWcaili2ZV94bIqudWiQlMIedAXo5yhMz7UPFtxB04fbGgSmdxj+e
	sR+AiZaI9yNfIsIXwLwFw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1790590017; x=1790676417; bh=m
	HXoaw754rGVYU2IJZQxYw6TN8b+9WaFAkvTQR5NjYE=; b=ULUMbbwg/+tWuPXG7
	Au5XLzxD8ggeArgso2OXZq5OlvdDr/fpD3MBHwXiSuwKcfttsukqUaT+GKCUO0JB
	fxjMkcPuFGjJYYlsSu78dXNpe4hr3V6DgsklTUMGKiPBlwyNkN2cTqvqThnLmEp7
	J0/1BVuCMPBOb7M7Qzi6OZyyl5pdoQEOm8UmsBbRwksUXqwc7yXlwMabSqNHjjTg
	5eTBTIwPB0ZP/m/g2M+WPBM9J8ISUUYgUGiMnqa7sgs1t+kAb+BUgiEEdwImQzQp
	1ykNIgNhBAFC7RjIihP7gaeVDxmY3EpoRdiUGk3w51rkKnX16+s+j1B/LowCmhLM
	ogvfQ==
X-ME-Sender: <xms:QDy6ajAfi3Zc_LYOILkPLJ_zH4yheff7w7qJcyiTDKxXFg9lk632DQ>
    <xme:QDy6alcmxiDw6y6fSTdk9fQBW2Dwkwtwncfy9EZBeybfbR2TPvKo-yAElBWN2BFZN
    2J43e6MnvBDDFj0HvS6DLj1inCcpEu_gpF5G7CJjrS4nFRllpPAfxXA>
X-ME-Received: <xmr:QDy6aksZ5oeZO_I0Sk-NMf2DUI_L110LQ8tARYO9f2NommO_qZuHhGlo6QQ>
X-ME-Proxy-Cause: dmFkZTF8+FzWl2kPFFw+2+MUnNndpG3Es29zlM3W8MqBD0QW9993JqL27RjsdWHL5iQTuv
    8LHkef+10EFcRNyu6aMfBJblGtUMhigK1wvWUg5pa/T2F4HZOycwBRl+2S+z7tqw2cJfHU
    gdsF/P6BOMqpKS9LZRm0d8oBtyKEEqCXwj8zji6pXjSixGW9yMDmevXCSXRhMug+RBOuj6
    H/TPGEbj0UBxBpkklI8Q2dk1KPN1FfxQ05T6kAzB+fcPQyWzSSafNh6004OlOqdREfhbRG
    BHI+j7BDMASDclZuapGmxVrXolh8JlQnm8Hn+THchpsYHB/1yAmWKg/yew9Ltzw86nEqdQ
    itHIkZvVWnWEr+RnAYzdrqHkGz2ydB4oi1K9THvlwx3gkxPNyypX+MIZW58Z9GOtNwCUmO
    24ylgS2Ek/b565hbhN7t68u1V671/wg60WBPUWNVZPMKzJkILI227NJcKU8H56jorf9Q0L
    ZwmZPPJq8Ba0pz5hdtzMrEaAHg3WvMY60w4ygLT52Ea2lEf2yKqMwQgsPfoSlpeYz1fViH
    eXaNCvW0mAb3ZhVKsGxhNoex7pYPK73E9UOtP5lTh5L4tZLIq7VwD8WvIo5Rlc2mo0zAHF
    vbmkrxXy6jmf/OcCL6Rzj5+1vL/hrt5lgqE+mIaYFtbn8dX8PdoMLF2ylR6Q
X-ME-Proxy: <xmx:QDy6asL_exXQSEOlGSEE6P10P6zQ5FiciojVfsHVi_7Rmjn_N54OOg>
    <xmx:QDy6ambkK52Yxnnn6EY5NhZwwRR9P2udHA4BiVcSKyxxz-r8gc4gYQ>
    <xmx:QDy6aiJ_FPqW2ZilbW4kLyQWt3P5KuJ13-xeEnuYElL-3Esan0yNRg>
    <xmx:QDy6avrM6d7EjSW-hBpKuTn-r2Ssig2RkkOBbQZBd3-truoIV28J_A>
    <xmx:QTy6aiC3S6ebawPwjTWNlTTUOAIrMt2VQeWPTi6GrwiEyZnv3mAb8Wos>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 28 Sep 2026 06:06:56 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v4 12/13] mm/collapse: declare the collapse interface in collapse.h
Date: Mon, 28 Sep 2026 11:06:26 +0100
Message-ID: <20260928100630.21870-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260928100630.21870-1-kirill@shutemov.name>
References: <20260928100630.21870-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 89qjn918xu9smarbujjrhii588ooz97g
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6FD74140005
X-HE-Tag: 1790590017-57164
X-HE-Meta: U2FsdGVkX19i/l88OH/pvgGbN60S0wp9WCBrohZQVmtynnYaAK7pvTbnHe4jSksi1REoPnz/gJcbgpYpNAdXD5toIX51At8siTryR5MHMwE6Tl+LoFQFTmKbzPUWGme7WgrZQzWwkfn1lzphSFJGEPusY7jSo0mkxeA1MjDgL4Y8gSC8zVTDUtDODLKqMzgVnElHJMiBQRLffUSE2z+bJEKvU5x+TsiUhYk0MjfcY/eipWSnCVhUxjkYv0FHZXSH/dDq/hFmEH0+Sm34O64yfsFi/4eCpzCoe9Jb/DXcZB/DDVtFLR6RtRaqL+gjUhf58I/Jz4Azw+E8dSaU/apsmQiTc722/M/thUDsypAmFKllX/rWv0gfh38TRzEsrjAMq/bi/8OiZD5GG3veS+9H+Wd6ioVilQ6gPMxherzpLUlLhkI6tokv8pJSFpIRfAd3RuWO6r/AAbAbiVevHVIu7XdXO+el4IVwtwHkKFWquwSz3PtP+sqyga/VDclt7k+TodHoI8/jLp9tDMHMjicgVOaRBxzRiuutITtygZKrhqnW0HsoRfJ9FBUZMzJ1CqPChsnYH9TCfhjyPY7A9bR/vyNXeOYvvpl4rvNyUKMfY8qc12OQJNBSfvc57eMYekh81pMictAPSW7iBlTEmQ3s5jt+4mTZbhUaAzaYDctg5swuDcJQYsbwSIDS8SYkYxRfONzZnZ2sJ2SylDpxeYromLFb7Eeea3JdDVOXhAwDju83arLZcgwVkWvmO6gUEGKE75/Sf6VQDVLuUxLfqIDJjJCr03AhGtfHtr78X7YJLhQj0gSl9bBJIWdqxe/evZDzsmhobpX2/hZ5jVgdWfLgtteuw+JgJa/BJifHM0bhOYoOtLdgV/IozSHgCrmPjX4/NhHTR+nl/GCT+9VLH2nXhJt6dHoZjHpTS5mRzWFvCcjbFhQcu5BASNNhY8PG8Rybj8UdBhAj3AJ6nh0FmqJ
 N4+0wVPa
 sU6JxgYtoQ2Lt7w+MIkHY/+HpgtOX1dAqpS8poOTNL0Do9xLyfLq6YDUgD9NxLu4MQ26h8g/hH2aFTZ+q6qmaCOraNo3NTaCrlqKeq6bFlbqaW1woHIHTEGkx3ySNNGY/f6jsyFpGBsZb4v2Wi+ZTJmJNByad37vB/A3Hn0KRJHuGd3RZ25wBDPq6FzMtW5v4V99SVbVBgK4HYY3mUCh3+1BDFmtDKuIJdWDlXP1KyIBmjTS7uoI9ZFuZYfeK1O+8CEt5qzE5klaCpfzlNwrX8M4CjORS3WlDSExvHwS78/lNakfQfTUaOUM2wiX8pg0SSwPCtqt8TTfSsWta8sS1b9+qx8nvM6bTz2oKPZ85FC0JFsEhbegt3DKzhJhQKiOgJpfXlZD/5Vs5tLBrDPrvln/WzBouFwLYyyb00zj86JSXr4cffnNGOaNr13B5eyh5q6fmrnmMHUtsvDo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

A collapse takes three calls:

  - collapse_control_init() - set up the control a caller carries;
  - collapse_scan_pmd() - scan one PTE table, under mmap_lock;
  - collapse_run_pmd() - collapse what the scan found, no mmap_lock.

All three are static in khugepaged.c, as are collapse_possible_orders(),
which says what a VMA allows, and the revalidate a caller needs once a
collapse has given the mmap_lock up.  No other file can ask for a collapse
without them.

Declare them in collapse.h, with a comment stating the order they are
called in and who holds the lock over each step.  Each function gets a
kerneldoc comment where it is defined: what it takes, what it does, and
the lock state on entry and exit.

hugepage_vma_revalidate() becomes collapse_vma_revalidate(): it is part of
what a collapse offers now, not a helper of the daemon.

Preparation for implementing MADV_COLLAPSE in madvise.c.

No functional change.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/collapse.h   | 45 ++++++++++++++++++++++++++
 mm/khugepaged.c | 86 ++++++++++++++++++++++++++++++++++++++++---------
 2 files changed, 115 insertions(+), 16 deletions(-)

diff --git a/mm/collapse.h b/mm/collapse.h
index ca7b367c89cb..b19351fbe19b 100644
--- a/mm/collapse.h
+++ b/mm/collapse.h
@@ -114,4 +114,49 @@ struct collapse_control {
 	pgoff_t scan_pgoff;
 };
 
+/* Which orders a VMA may collapse to, zero when it may not collapse at all */
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+		vm_flags_t vm_flags, enum tva_type tva_flags);
+
+/*
+ * A caller states what it allows in cc->policy and then hands over one PTE
+ * table's worth of a VMA at a time:
+ *
+ *     collapse_control_init(cc)              once, before the first table
+ *     collapse_scan_pmd(vma, addr, ...)      per table
+ *     collapse_run_pmd(mm, addr, result, cc) when a scan found work
+ *
+ * The caller holds mmap_lock for reading over the scan and passes an address
+ * within @vma, aligned to the PTE table to scan.
+ *
+ * The scan returns with that lock still held.  Almost every table it is
+ * offered has nothing to collapse, so a caller walks a whole VMA under the one
+ * lock it took to get there.  SCAN_SUCCEED means there is
+ * something to collapse.  SCAN_PTE_MAPPED_HUGEPAGE means the page cache
+ * already holds the PMD folio and only the PTE table is left to retract.
+ * Both are work for the run, which is handed what the scan returned; anything
+ * else is why there is nothing to do.
+ *
+ * The run is called without the lock and returns without it, taking what it
+ * needs in between: what it does -- allocate, isolate, copy, flush -- is slow
+ * enough that a writer would wait behind it.  The caller gives the lock up
+ * first, and with it @vma and anything derived under it, so a caller carrying
+ * on has to look up again with collapse_vma_revalidate().  The run revalidates
+ * for itself rather than trusting what the scan saw.
+ *
+ * A scan that found something has to be run: the file side takes a reference on
+ * the file while it still has the VMA to take it from, and the run is what
+ * gives it back.
+ */
+void collapse_control_init(struct collapse_control *cc);
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+		unsigned long addr, struct collapse_control *cc,
+		unsigned long orders);
+enum scan_result collapse_run_pmd(struct mm_struct *mm, unsigned long addr,
+		enum scan_result result, struct collapse_control *cc);
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm,
+		unsigned long address, bool expect_anon,
+		struct vm_area_struct **vmap, struct collapse_control *cc,
+		unsigned int order);
+
 #endif	/* __MM_COLLAPSE_H */
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index ed74d3268698..f79ba6d1bf49 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -476,11 +476,18 @@ void __khugepaged_enter(struct mm_struct *mm)
 		wake_up_interruptible(&khugepaged_wait);
 }
 
-/*
- * Check what orders are possible based on the vma and collapse type.
- * This is used to determine if mTHP collapse is a viable option.
+/**
+ * collapse_possible_orders - which orders a VMA may collapse to
+ * @vma: the VMA
+ * @vm_flags: its flags, passed separately where they are about to change
+ * @tva_flags: who is asking, as thp_vma_allowable_orders() spells it
+ *
+ * khugepaged may collapse anonymous memory to any enabled order; everything
+ * else collapses to PMD order only.
+ *
+ * Return: the orders as a bitmask, zero when the VMA may not collapse at all.
  */
-static unsigned long collapse_possible_orders(struct vm_area_struct *vma,
+unsigned long collapse_possible_orders(struct vm_area_struct *vma,
 		vm_flags_t vm_flags, enum tva_type tva_flags)
 {
 	unsigned long orders;
@@ -1008,13 +1015,22 @@ static int collapse_find_target_node(struct collapse_control *cc)
 }
 #endif
 
-/*
- * If mmap_lock temporarily dropped, revalidate vma
- * after taking the mmap_lock again.
- * Returns enum scan_result value.
+/**
+ * collapse_vma_revalidate - look a VMA up again after mmap_lock was dropped
+ * @mm: the mm
+ * @address: an address within the PTE table being collapsed
+ * @expect_anon: the collapse started on an anonymous VMA
+ * @vmap: the VMA found, if any
+ * @cc: the control, for the policy that says who is asking
+ * @order: the order the collapse is going for
+ *
+ * Called with mmap_lock held, for reading or writing, once it has been given up
+ * and taken back.  The VMA has to span the whole PMD whatever @order is; with
+ * @expect_anon it also has to be anonymous and have an anon_vma.
+ *
+ * Return: SCAN_SUCCEED, or why a collapse of @order at @address is off.
  */
-
-static enum scan_result hugepage_vma_revalidate(struct mm_struct *mm, unsigned long address,
+enum scan_result collapse_vma_revalidate(struct mm_struct *mm, unsigned long address,
 		bool expect_anon, struct vm_area_struct **vmap,
 		struct collapse_control *cc, unsigned int order)
 {
@@ -1262,7 +1278,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
 	}
 
 	mmap_read_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED) {
 		mmap_read_unlock(mm);
@@ -1297,7 +1313,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm,
 	 * mmap_lock.
 	 */
 	mmap_write_lock(mm);
-	result = hugepage_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
+	result = collapse_vma_revalidate(mm, pmd_addr, /*expect_anon=*/ true,
 					 &vma, cc, order);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
@@ -2739,13 +2755,36 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 	return result;
 }
 
-static void collapse_control_init(struct collapse_control *cc)
+/**
+ * collapse_control_init - set up a control before its first scan
+ * @cc: the control the caller carries across its scans
+ *
+ * cc->policy is the caller's to fill.
+ */
+void collapse_control_init(struct collapse_control *cc)
 {
 	cc->progress = 0;
 	cc->scan_file = NULL;
 }
 
-static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
+/**
+ * collapse_scan_pmd - scan one PTE table for a collapse candidate
+ * @vma: the VMA the table belongs to
+ * @addr: start of the table, PMD aligned
+ * @cc: the caller's control
+ * @orders: the orders the caller allows for @vma
+ *
+ * Called with mmap_lock held for reading and returns with it still held.
+ * Almost every table it is offered has nothing to collapse, so a caller walks
+ * a whole VMA under the one lock it took to get there.
+ *
+ * Return: SCAN_SUCCEED when there is something to collapse;
+ * SCAN_PTE_MAPPED_HUGEPAGE when the page cache already holds the PMD folio and
+ * only the PTE table is left to retract.  Both are work for collapse_run_pmd(),
+ * which is handed what the scan returned.  Anything else is why there is
+ * nothing to do.
+ */
+enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 		unsigned long addr, struct collapse_control *cc,
 		unsigned long orders)
 {
@@ -2780,7 +2819,22 @@ static enum scan_result collapse_scan_pmd(struct vm_area_struct *vma,
 	return result;
 }
 
-static enum scan_result collapse_run_pmd(struct mm_struct *mm,
+/**
+ * collapse_run_pmd - collapse the table a scan found work in
+ * @mm: the mm
+ * @addr: start of the table, as given to the scan
+ * @result: what the scan returned
+ * @cc: the control the scan ran with
+ *
+ * Called without mmap_lock and returns without it, taking what it needs in
+ * between: what it does -- allocate, isolate, copy, flush -- is slow enough
+ * that a writer would wait behind it.  The caller gives the lock up first,
+ * and with it the VMA and anything derived under it.  The run revalidates for
+ * itself rather than trusting what the scan saw.
+ *
+ * Return: what the collapse made of the table.
+ */
+enum scan_result collapse_run_pmd(struct mm_struct *mm,
 		unsigned long addr, enum scan_result result,
 		struct collapse_control *cc)
 {
@@ -3230,7 +3284,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
 		if (!vma) {
 			cond_resched();
 			mmap_read_lock(mm);
-			result = hugepage_vma_revalidate(mm, addr, false, &found,
+			result = collapse_vma_revalidate(mm, addr, false, &found,
 							 cc, HPAGE_PMD_ORDER);
 			if (result != SCAN_SUCCEED) {
 				last_fail = result;
-- 
2.54.0


