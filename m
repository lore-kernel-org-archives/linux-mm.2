Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CFE09CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 11:39:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F882900144; Thu, 14 Aug 2025 07:39:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A8BE900121; Thu, 14 Aug 2025 07:39:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59810900144; Thu, 14 Aug 2025 07:39:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 479CD900121
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 07:39:26 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EA69659AEB
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:25 +0000 (UTC)
X-FDA: 83775167490.24.BBB1607
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1356840006
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 11:39:23 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lEL73pky;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755171564;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5S/wbudKTnM1T6npVhn1wngAeRtwE5me48Cxy8uTATc=;
	b=HuuxElU3ily1hoCOYyawVSf/c+8QnizutIWLq31dvj7S9uCCWYDO4B9jR+BhkZ8XZzJLbC
	Pi7Ky+geRemCdiRl6aYVWXtpX61Sroo9DLhvQBi2Mt75ZEohIeWdVYDI4GinEjFiW2Akof
	QuA9+mGebvqxV2N+kH+PR4X8ecsPJMc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755171564; a=rsa-sha256;
	cv=none;
	b=xLc3hgecamoVZAbu6m3LjZumjN2iO6R9fGM3tKj4D2B0iEqmeOUlAn9gf/Y9gRNOKtr1mI
	v1oxhwgNacUPwQKjouwYjEneUbV3Uu2p+bwI1He5vFw5rZ+o+TMEFkwFgr7TPsauc8ZeBA
	N34zbDa/CpyhnJ3H4SbcZ+5l7ZPonNc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lEL73pky;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4716fb73c7so803342a12.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 04:39:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755171563; x=1755776363; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5S/wbudKTnM1T6npVhn1wngAeRtwE5me48Cxy8uTATc=;
        b=lEL73pkyuiSDOAKY1gqgvVkjyj3tHC8Y4Ps4wpGdbqmpvNCaco/jPC0xssMXcvcw4i
         aK43/Xc+XmJCRbiagv0S7R1/8r+EBNJ4MTGJxPyvmBYsaBfE5xFtvtp4l9GG+3zRPd8/
         CQB1DCAB6OCfiD/LfKNdtSiLInnGVw2rr7Ow9OdstPjSuRCAX7C08Fe2ShZyuSJjzELq
         EzRX7WrHUgsQLmeblClK1VJol14XDmY/mgsMW/9wQlLHMSYlA9pyvmz3Gt+ReoGC3KOR
         A7jJKtXAlwkzwXyCvrgf+pC9rHnnL3q5v6qieC9q1PdoDQOzEWbKaJGwJp4P3qlpPagA
         RFXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755171563; x=1755776363;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5S/wbudKTnM1T6npVhn1wngAeRtwE5me48Cxy8uTATc=;
        b=r4xUFwMY4tX6xaRfhBMzsJYzD/U6r4YngmvK3Y+leyQ2xrYoaHm9/fy4+yYuB0fk2h
         M3Tw7tudWd4gf2ZRTzNakMYNBt/LAPu+ANoL2QgQzvfPR3UVJwg2x34XdXB5mnG8mpdH
         FfZI2feMZmgx9kQ1X7cuM8Cq/JVsqAFhAjYNDIHgH6TGXqhNkjNyR554CF9CNrrZ5AmN
         JOlKUkclA+mt+n6UWzWZitgRnHolWn4vjsSvSx7Q9rhxMGSDa8OenKwE67zeECv9QFC7
         CyoCkGawUBYAcFg7Ffd1LWiD3W35yokYBsFBohuWjB1X6J5kPVua+jfmlF7j/2bgc5Ft
         Zm/w==
X-Gm-Message-State: AOJu0YxjdBUBLBo662FIR+bZexixG6On9vo58dq0W/l9QO+g3OQAEhMn
	C5AFgkwJ+UCNd2t6qWkonQPpWqyk4bKHm1uPDAV1n7Tt2+1Er8mlCnAF
X-Gm-Gg: ASbGncsTye4i85DEIo095LKPpuA5uScToFW9xUEyAP8Iug7pDQB3G4uPt7+mx9ofiWR
	fB198jO8OOoi0US8IK/d8jewboeaGOpjD1FZnW2KsV0J4f6bqI66gCu4Hp4zRV9RJ1Yjc3RrJQ9
	KDks1wE2cHxLS5DJgyvxK0nlDatmOMFlWnLhrUHMeK04GFJy2JUNSNrHdIQMuo6mjWtl9mHPlTX
	T2tBLb/ZD/hYFfv9hE/nhXRxUD7qT/7EkLJ5El9Vj6I6gGvqqFkX+KaQk5KickD77Z1HAZtJQTa
	7IEwHIDr1cHWlwncjlLfa+mA19EK4Cl/v4TbzlZcfei/DTi+FUn3x1o2EKPX0nyGaNFv/sWyKlu
	DHnqrgeK0dR4S8wq/V9so6Lwjkc0=
X-Google-Smtp-Source: AGHT+IGVVDY6YF0iFXGx9rxPT0RHXIjGTXS1QnyoEHSXENjqhvk8/dMyaowNtiofWxGv8HLLiNbYAw==
X-Received: by 2002:a17:903:3c46:b0:240:5c38:7544 with SMTP id d9443c01a7336-244586f68f0mr35474285ad.50.1755171562842;
        Thu, 14 Aug 2025 04:39:22 -0700 (PDT)
Received: from vernon-laptop ([114.232.195.227])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2430b53d504sm49046215ad.87.2025.08.14.04.39.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 04:39:22 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	glider@google.com,
	elver@google.com,
	dvyukov@google.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	osalvador@suse.de,
	shuah@kernel.org,
	richardcochran@gmail.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.or,
	Vernon Yang <vernon2gm@gmail.com>
Subject: [RFC PATCH 1/7] mm: memory: replace single-operation with multi-operation in wp
Date: Thu, 14 Aug 2025 19:38:07 +0800
Message-ID: <20250814113813.4533-2-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814113813.4533-1-vernon2gm@gmail.com>
References: <20250814113813.4533-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1356840006
X-Stat-Signature: 76o5m4iuzek71qmfy6h1e3xfjry4qat1
X-HE-Tag: 1755171563-186339
X-HE-Meta: U2FsdGVkX19yFF86nfqYAxaLlo7k1InQH9vzT5egKVH/0+e4XVOph8cFspM8SPswaVNqXUa3YYaYma2s9dcXWPcMGS8ieM2hQMFoX8FCByMOYENXDiVm4mIu9XjJyfdbbTHj49eraCgkuDsmRFF59m9B/D79IDoquuizzNNZKTe6MMp/xTjG2STrhTG4S4xiDMZTa0tpa9jNubMFMKAqPKGTLa13XIZ9F0md23LzsAKgceuejL904BQFEOBokE79l1eL5aGmlJwY9G3JVM1MPha+whHszqZkTAydIuNGiMwYsRFHUM5Tqu8x9mqPUpombMCLNq6C3aHqSq3NSjEZ0eTAv1YWQ/MA8+lH/kHFkG0mRQ0vH5SCix2WSSQUfpH9IQFLyHza/ZErJo2KM/e/1GIP92ENjwDM1SEP80uP0YOAYRiQsCzNIJvrS78jMEtxRlNb1rEFtUwWRx4bwdNpMvCy/F7FvSnJEQ13csPodoRz6hDF6Z+cSq43+Xx2dDSwI6fzAy97A6BNH5HvEDsFjvMxBpDNcYl5qDdcJjMBWrlPA7Yf3YEFZcNO7/ufkri2ssQ/DXccSV8PNv74GNruV0d8HfcxudSCdZfbg91YkjMvH5+rtjjQ3I3VqB2UQLdT57RoaqwRn1tK6IvxAVngn/vQh+tBzEpN28RwlAzZCMIUl/2kbUwVCXiw73dmBHLnL57NSlHjWB3X4VtBNlsJ5gyZlZQIaKelEDNGKXByAb9gPch4aqFDOlgZAzhOpbxE+FgfWbIqa3MdjhH8IZ1WEgUl3U/n10FXgVYuLFm1+x0VRRHbT9dWaXDu63qTocpvdTuNe5Sdh7lGO//p7usOHsMzygH522LSGvyHWZlUlQ0VJJ0srQBYCjMKqhcjV/7uV2QunIXaY+AdX1L41qpXxP29cvIn2uozQSf69SNqDxWDQFC+FnTwPauF9XksEPCTZCr8kUHB8zMoIuVzw/Y
 g/ne+ldq
 3Y//P+jp3K7jT6XXSZw/c4mVwaXUSzujFBn2Z7APLT618QkWjVRtYJlic7zQkKD74oUrbZbLkUOu41GVVQJAg4Sh9SBJA9kOorWsBmHR3kK6VaU5kDq29qeoyhzxYmKg8pZQdtJohEiQ4iQJ9gvtNgY9d+OBfqc7pknFyG1OlhY7hha3euAsL2o3x5MtVi9qpioEMcfTmhoQpVhteCvn+ed2rdG/4FfQmz1DwC2LuEfd6/T++pmymgXN/o0Df8Kh2P2AcJI07IKKLOhjK+q8+Ui1F2Qm6IKU0zPkpgd4ufdy9N57Yhld3HW29RymLCwhT1s1TX2oebKSOkKuvtkV/aCqxBkyNkADyoB9GkHIlPy9whcrYV/afNZzGd3KFZ4Vgvr2JE9wGyoSX66eqINTW6YoDnXuFV3BJlIkdrnGYYb57KLQ4DR8/ozOLgRrD4sX+v65u4aGGDXHLvHFrYeqzsQGKEa6AM2dl9PySlNdKGSJC7N026zmFZYN6LI5naxniXzKD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In preparation for wp to support mthp, the single-page operation
function is replaced with a multi-page operation function, without
any functional changes.

Signed-off-by: Vernon Yang <vernon2gm@gmail.com>
---
 include/linux/mm.h |  7 +++++++
 mm/memory.c        | 12 ++++++------
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index fa538feaa8d9..80c6673f419e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2589,6 +2589,13 @@ static inline void inc_mm_counter(struct mm_struct *mm, int member)
 	mm_trace_rss_stat(mm, member);
 }
 
+static inline void sub_mm_counter(struct mm_struct *mm, int member, long value)
+{
+	percpu_counter_sub(&mm->rss_stat[member], value);
+
+	mm_trace_rss_stat(mm, member);
+}
+
 static inline void dec_mm_counter(struct mm_struct *mm, int member)
 {
 	percpu_counter_dec(&mm->rss_stat[member]);
diff --git a/mm/memory.c b/mm/memory.c
index b0cda5aab398..a6bc1db22387 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3606,14 +3606,14 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	if (likely(vmf->pte && pte_same(ptep_get(vmf->pte), vmf->orig_pte))) {
 		if (old_folio) {
 			if (!folio_test_anon(old_folio)) {
-				dec_mm_counter(mm, mm_counter_file(old_folio));
-				inc_mm_counter(mm, MM_ANONPAGES);
+				sub_mm_counter(mm, mm_counter_file(old_folio), 1);
+				add_mm_counter(mm, MM_ANONPAGES, 1);
 			}
 		} else {
 			ksm_might_unmap_zero_page(mm, vmf->orig_pte);
 			inc_mm_counter(mm, MM_ANONPAGES);
 		}
-		flush_cache_page(vma, vmf->address, pte_pfn(vmf->orig_pte));
+		flush_cache_range(vma, vmf->address, vmf->address + PAGE_SIZE);
 		entry = folio_mk_pte(new_folio, vma->vm_page_prot);
 		entry = pte_sw_mkyoung(entry);
 		if (unlikely(unshare)) {
@@ -3636,7 +3636,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 		folio_add_new_anon_rmap(new_folio, vma, vmf->address, RMAP_EXCLUSIVE);
 		folio_add_lru_vma(new_folio, vma);
 		BUG_ON(unshare && pte_write(entry));
-		set_pte_at(mm, vmf->address, vmf->pte, entry);
+		set_ptes(mm, vmf->address, vmf->pte, entry, 1);
 		update_mmu_cache_range(vmf, vma, vmf->address, vmf->pte, 1);
 		if (old_folio) {
 			/*
@@ -3661,7 +3661,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 			 * mapcount is visible. So transitively, TLBs to
 			 * old page will be flushed before it can be reused.
 			 */
-			folio_remove_rmap_pte(old_folio, vmf->page, vma);
+			folio_remove_rmap_ptes(old_folio, vmf->page, 1, vma);
 		}
 
 		/* Free the old page.. */
@@ -3676,7 +3676,7 @@ static vm_fault_t wp_page_copy(struct vm_fault *vmf)
 	mmu_notifier_invalidate_range_end(&range);
 
 	if (new_folio)
-		folio_put(new_folio);
+		folio_put_refs(new_folio, 1);
 	if (old_folio) {
 		if (page_copied)
 			free_swap_cache(old_folio);
-- 
2.50.1


