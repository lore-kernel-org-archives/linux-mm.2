Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC327C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 329376B00B2; Tue, 30 Jun 2026 12:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 300D36B00B5; Tue, 30 Jun 2026 12:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2167B6B00DE; Tue, 30 Jun 2026 12:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C9AA86B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:42:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5508AA05A9
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:04 +0000 (UTC)
X-FDA: 84937146168.23.CEF0CE9
Received: from out-182.mta1.migadu.com (out-182.mta1.migadu.com [95.215.58.182])
	by imf28.hostedemail.com (Postfix) with ESMTP id 94F55C0007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:42:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mPFNTcWz;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782837722;
	b=gr5sOkZNw2n933d06cIxmVDWDxvzeZCP8DWl7QIO7mYTb8unHPZff5YHRJ3AaPbrJWfJv/
	b7uOYyd82Jdbd1zUdg+6wtmAS9919KNeaH3oBz2nE2r23Sc3Zx7SYDi7Ymd5mHRJPKXjti
	RT55VhUAn9NiAm9nbKSllLgNhLds0r8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782837722;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dm/Q0vl+Jef7oke5kamArSkmTxJJXCXfSpDT8d+sjq0=;
	b=FOVDKVXwyo3Z3tVMRcIiO2nqwDY80YnofluVO3u+LReepJH8dpHjtzrgBo5nvcUj64nQLr
	oAUnP1Y9QDwrK94XsT/g9JhpIDHq9MOe9iY+OpwVQCOB7bQns1A6GWI7KsmsrHmMCMb+uP
	Bzz1vNX7pv6D2BWo23Zn6YPCxlHnNzY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mPFNTcWz;
	spf=pass (imf28.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.182 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782837720;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=dm/Q0vl+Jef7oke5kamArSkmTxJJXCXfSpDT8d+sjq0=;
	b=mPFNTcWzZSHn/PcWPgG3c6u7Lg3fp2fM06WKGAs0Q6QcKaADPIJd31gkac6kAdA0II9mD/
	OV1h5L+8k/a86V6xjV4TImEGF2yYUWsyP77m3CRR7qZhD/EbA6iosAcm2KQ4nAKmi7V647
	DkHLM5ooy8g/cZGlI+6Sj4tNY2MqH14=
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
	npache@redhat.com,
	Liam R. Howlett <liam@infradead.org>,
	ryan.roberts@arm.com,
	Vlastimil Babka <vbabka@kernel.org>,
	lance.yang@linux.dev,
	linux-kernel@vger.kernel.org,
	nphamcs@gmail.com,
	shikemeng@huaweicloud.com,
	kernel-team@meta.com,
	Usama Arif <usama.arif@linux.dev>
Subject: [PATCH 2/6] mm: extract mm_prepare_for_swap_entries() helper
Date: Tue, 30 Jun 2026 09:34:39 -0700
Message-ID: <20260630164143.1595669-3-usama.arif@linux.dev>
In-Reply-To: <20260630164143.1595669-1-usama.arif@linux.dev>
References: <20260630164143.1595669-1-usama.arif@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ze3hs75pg6br5micmb4sairkspmwhau4
X-Rspam-User: 
X-Rspamd-Queue-Id: 94F55C0007
X-Rspamd-Server: rspam02
X-HE-Tag: 1782837722-115001
X-HE-Meta: U2FsdGVkX18My2e/E6rHuVAvFXe5CqtAkaDTtsO6iMGKRTxBTto1Hb3fuefN3vJdYNs5Wqgg+p72+2ngK+jz+mUQDgiwGQ5KX5ivJQfWK905TVQgOpJYPX9NcyRqWDAgXcVTq/xTf1EfriKDFY65kh5LmyPmwWsdDlJhJSQ2wcpA/AsDdx93o9li+AkUT+B/cZW0XmufXptDzz/CMdVDx+w3dbiT7EzDbITe5SQTSMMjUrPyPUYVF7kCI2Y1Tk22RWvq+xO9AJmrDn/K7Utr81Sq1S6rxdsiamU1eUNgV9seTLtfMuRv+QnnnsCcZyiTO3t4l/fQzY+9lH89QIxfoU1W68FQyImDsO+U0172u4FhcIimiycEAO71E2JptU3y+Y13sSdFrGhkQiOZqDylPJvi8f6cRwHpbNKtNNsxm7uoRzykvRVVqOiN92r6n8v0xRHeH2wIvfvPewFS5POQpzF3eOE+f+ASskcOzXn5+ZDtjCc6CuRqHBhlY3qid/Hj428+k7tgX7PAcIP4qpMNBNN7xqGd3X7W8UmnMfV6eCGr4ib3c2wpiG7p1cfrRWmxJnWZrtwGz6oDQi7Yn+xKENqd1QKm/I6wmDeFYLQdjGEj1jCrnuT8vMdFofM82vLYKqvUqUOaayXs82DbJc4bmLDGmCc4lQ6ySg/Ylg1lbkqGARua0KS6G3yZa4ijXAziUje/VJQuJgMRAjQx4Iirjn88uQI8nw3UDp0vrQ3VG7F7bVlbH1GKrQsDacvYU+f/y+TE3gQcNazeIORw3up8rqACr7Ya1FxoJYLwGbgzQ6gGXGkYaPOt80LvUoH9mm/T+89Hp1CEE90B6PLa59e7mBrRm4BKVGLzbajaBHSOckWUECDjBqn+Iu/bhmoIe4tYewk+vHnUsES2rFQ/So6+xhYQMQ7bGMkACiX6aZjK0grsFdSaTFzCxOBGwDu2Nbw49JTqHtTaHhboRu1y87v
 kg+FGgg0
 0xhjICWMwuTkjhwVge19f0AgbKLhEJQjTGnT2RqG14dG/7eTOnctHLCpUuajF/VfbMqC5YJxBx+BsWJle2GvPGB++KWRjsZNAmkfemlUnKDKHUVLiTDkRpqk/sEo6LeWQ5Tg6EeTmnxq2lBYHap4tqoR0weGPGjyz809gyYER85GqAkfXY6SeuYoXeQ4RlaK2EkPkSkMKv2ImKUxd/XepCAPkyhpsB5xPLdQv0ogb7vBBFokibVL09jEn5NOO1sK88p6ax4WQaWfVV6+dNS8V1O1NseDbfNsb/z5RBiUYM65Z1xp6lThoG9noBg98s8y9a4oHvn07q3B0HKc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When a swap entry is installed in a page table, the mm must be added
to init_mm.mmlist so that swapoff can find and unuse its swap entries.
This double-checked locking pattern is currently open-coded in
try_to_unmap_one() and copy_nonpresent_pte().

Move it into mm_prepare_for_swap_entries() in mm/internal.h and convert
both callers so it can be reused by upcoming PMD-level swap entry code
paths that also need to register the mm with swapoff.

copy_nonpresent_pte() previously inserted into &src_mm->mmlist rather
than &init_mm.mmlist, but the insertion point is irrelevant, mmlist
is a circular list and swapoff walks it entirely from init_mm.mmlist,
so only membership matters, not position.

Reviewed-by: Dev Jain <dev.jain@arm.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Usama Arif <usama.arif@linux.dev>
---
 mm/internal.h | 13 +++++++++++++
 mm/memory.c   |  9 +--------
 mm/rmap.c     |  7 +------
 3 files changed, 15 insertions(+), 14 deletions(-)

diff --git a/mm/internal.h b/mm/internal.h
index 8e0df3d1c6f9..0e3db9451e5c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1956,4 +1956,17 @@ static inline int get_sysctl_max_map_count(void)
 bool may_expand_vm(struct mm_struct *mm, const vma_flags_t *vma_flags,
 		   unsigned long npages);
 
+/*
+ * Ensure @mm is on the init_mm.mmlist so swapoff can find it.
+ */
+static inline void mm_prepare_for_swap_entries(struct mm_struct *mm)
+{
+	if (list_empty(&mm->mmlist)) {
+		spin_lock(&mmlist_lock);
+		if (list_empty(&mm->mmlist))
+			list_add(&mm->mmlist, &init_mm.mmlist);
+		spin_unlock(&mmlist_lock);
+	}
+}
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/memory.c b/mm/memory.c
index a3fcaf8cfe8f..6637c5b13c9b 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -953,14 +953,7 @@ copy_nonpresent_pte(struct mm_struct *dst_mm, struct mm_struct *src_mm,
 		if (swap_dup_entry_direct(entry) < 0)
 			return -EIO;
 
-		/* make sure dst_mm is on swapoff's mmlist. */
-		if (unlikely(list_empty(&dst_mm->mmlist))) {
-			spin_lock(&mmlist_lock);
-			if (list_empty(&dst_mm->mmlist))
-				list_add(&dst_mm->mmlist,
-						&src_mm->mmlist);
-			spin_unlock(&mmlist_lock);
-		}
+		mm_prepare_for_swap_entries(dst_mm);
 		/* Mark the swap entry as shared. */
 		if (pte_swp_exclusive(orig_pte)) {
 			pte = pte_swp_clear_exclusive(orig_pte);
diff --git a/mm/rmap.c b/mm/rmap.c
index 1c77d5dc06e9..b93caabd186f 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -2304,12 +2304,7 @@ static bool try_to_unmap_one(struct folio *folio, struct vm_area_struct *vma,
 				set_pte_at(mm, address, pvmw.pte, pteval);
 				goto walk_abort;
 			}
-			if (list_empty(&mm->mmlist)) {
-				spin_lock(&mmlist_lock);
-				if (list_empty(&mm->mmlist))
-					list_add(&mm->mmlist, &init_mm.mmlist);
-				spin_unlock(&mmlist_lock);
-			}
+			mm_prepare_for_swap_entries(mm);
 			dec_mm_counter(mm, MM_ANONPAGES);
 			inc_mm_counter(mm, MM_SWAPENTS);
 			swp_pte = swp_entry_to_pte(entry);
-- 
2.53.0-Meta


