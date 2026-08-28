Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBFB8C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 06:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B5B86B0095; Fri, 28 Aug 2026 02:00:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 066FB6B0096; Fri, 28 Aug 2026 02:00:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E98636B0098; Fri, 28 Aug 2026 02:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4AB36B0095
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 02:00:01 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CD15401F6
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 06:00:01 +0000 (UTC)
X-FDA: 85149627402.29.1A456FA
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 5B180100007
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 05:59:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bpBJf9QV;
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787896799;
	b=d1YiEgW2Xs8L6F7KuEfCYrNQsuLIgqjdKHcXAZtjRYYQRQh6QqE/2CbIU+ClmeV6q5XRlP
	+MYKayudayc5kACFSS0dXo2P5mR75YaLQCS+vVg5/WGed+jsmF6hCrZY/eShCgFxvs0/j+
	6/Xiz0M/1a4tBiTqdUN+pxJnn6IPeeA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787896799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v7VK6Qr7VyOU0DiKXFkET6z2QkJwdvjQa2S5pL5XscY=;
	b=cEYEubxVxRYvymXS58WBqiLGkRYLr4Lm66aeINCqKlDK9PK096VdAdzCQXugBT5s20PCUU
	5ICeJ7bOTNXx+56NMWZx77uvS1voqHvEGNR80QanwRvwd0SmJVk203LbzL4EHmibfi4TgK
	avoBnqYjpeunziOCE3u9O/lQmcMYneE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bpBJf9QV;
	spf=pass (imf05.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-383b4a3755fso882191a91.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 22:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787896798; x=1788501598; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v7VK6Qr7VyOU0DiKXFkET6z2QkJwdvjQa2S5pL5XscY=;
        b=bpBJf9QV/ptprMQJYpLHF671RM0Sde4c0BMWqfaPLvOTcG37FrULH0UdtxeYSX4T+z
         ECwtWOHs8txQBezjElFtyHMPGLHIBz3x4fe0M0czxLPpm+/zvFnY3E6UHUJI6uMmXaCW
         bEMaSPGfwgqHplM1Ji9YR+Hu+lFJWv9vTrXTW6Djt6Yt9F2NcAzorCOEa0RRuHBE/BBs
         jWy0owvrkSHoUc1iElt4y5iZ93rt8ZkVf60XjUWc9+/PIsdec8RgzRPjq/ERn9I9AJx6
         DeT/4sWXU1n4K2UH4u3ifryCKBpTpy5kuaIfjzjAFREU6A1d22LxsVKZ4gMZl4KyUoWb
         LW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787896798; x=1788501598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v7VK6Qr7VyOU0DiKXFkET6z2QkJwdvjQa2S5pL5XscY=;
        b=R+Ii2H7rrIm4IQzVIMQjUWdee9u/FZeNO4uKOJrG+NMReVEUmSOjhesnk3ToxyQYkK
         autjNezeYQMDrwxAVwgk72CkVA40pO38jit2MygcHv9DPDJ0TQFP1j43yIZG48c/mU/8
         ZwdDd+0F0LtLgazrIU9itdVSjkY4SL/Xr9Rigzz815WrYsBBMysWI0d9VfFald3N8Zab
         oTJ4j0U/trpxJI6v/URJ33xVBafwcXLQwXlbhEIhPNmJyGiY0eVbARcKvYB7pE0Pe0by
         INAsyXhivrDj7+yRXd9SYrqN0M6yeEHif7fMt3q7gkNwkegEKixAjq3fKhs7zTXSNxgb
         3xZg==
X-Forwarded-Encrypted: i=1; AHgh+RoRc0WJzAndV+qvATBsUU2nzGzvXsbGZCUFEWzLDqT1EG53wc16H4h1cRZbf2vr1MgCpIfKW8NiZg==@kvack.org
X-Gm-Message-State: AFuF++mI39v+BAG3WAunvgXpujC9/RQuVOY6UYf+NWtLk6jS3oXaVl+W
	uUKhfavQJmqr/V0jfw8jspj3H3gw0l7+Zh8gRsEBnDXAZMIHMoFgAs4GEiYFZEZf
X-Gm-Gg: AR+sD12VOxHAGz78l4FomoDVMhv0qVKEsMHDnnfuzLYuhYxBL1T9qJe3im2yfIOaCJb
	8YixcrTEfZ3hFh3G5aGvJ7I9/G0pTMoNcd7GS+wiS8Ylci6286DOOpl69OjZKCSdCHScQW8V/V3
	l8rEoRTgmKBqUab0iCeHLrNLJWp2cOBJNrGYlFRquhR0OATvihk5AbtKwsz5iWV4y/+ab6fggF4
	D3VTwAUAxP4fNl3J4nOSQu36LKJ/18ashNLGWUsAseqthiMQtphDLTqmSYW74NDjkcxxL+LS77M
	qlr7c1mLovAmya+Tn/CVTaIC5YmBdGQ3+tmlY5fTeTNUvQZ6B2ORIAAINtCc7KYn+Lp19edqVF+
	jaJnjpp87LjAfNGc2NRSU/ICzPHvIrL2zXC7xhxjw0iWZHETjINBmZ/MAFnCHDDA/tBe949b4G4
	/4hmte317pwMf/de9FwZmeaIlSSfjKXdb6fUFzi3tvu+LEvgYecPwd4t5RtgFa0gUq7kXxkYLNI
	0So
X-Received: by 2002:a17:90b:51d2:b0:38f:26c7:165e with SMTP id 98e67ed59e1d1-396d0f8ffdamr9816307a91.9.1787896798256;
        Thu, 27 Aug 2026 22:59:58 -0700 (PDT)
Received: from localhost.localdomain ([240e:b8f:1df9:a600:c693:b19f:ada0:748])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396b0ea808csm5826241a91.2.2026.08.27.22.59.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 22:59:57 -0700 (PDT)
From: Vernon Yang <vernon2gm@gmail.com>
To: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org
Cc: nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	zokeefe@google.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH v4 2/3] mm: khugepaged: fix folio is used after pte_unmap_unlock()
Date: Fri, 28 Aug 2026 13:59:25 +0800
Message-ID: <20260828055926.346744-3-vernon2gm@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260828055926.346744-1-vernon2gm@gmail.com>
References: <20260828055926.346744-1-vernon2gm@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 5B180100007
X-Stat-Signature: uobjcy5dx1ium1fke3n3p8qzyxj6hrfo
X-HE-Tag: 1787896799-735244
X-HE-Meta: U2FsdGVkX18EiQGmY5Qe93zfJ17H2Zw2LucTQc9b9Jw3q3I+8PFT+W6NqtodTU/HHq+D3au+dF53fBG4sDPonpL/zDccb5oqOvQJwTH95VDCWuLdP6w7p4/x9IXNOyU3bCHXZmSPuLQCEp8lR7O2rZJiG1fMZzcbDr3Dk0qTm+8uSFVSrN5uPkkx27pLdps3MPYHFDazM/d/Jk6Aa+4mlbqtAk5x2spjkuDZIDOckerDC6ie+sjQeMjdbB0cx0QvZuoPEx4CIq2NGogGfv511OJ3aIx6dtAvYhyURthJeMob3qA4KneCM5K1TX3RVDuUO5jw4n5FcKn3EFicWO6moGhCRgxdRzpOsek1no9+ONs0sooUNGAkNk6LK8O7oHVzpmjL6b4TEGLgWHNh43Cm42koPBqIpJfD9BXtqjEIadSjkPk3j2/n37+ro+NO+wyVrzlV3GTS7Rxa7sBPSLEJH9MvFXz6R9YF1A2WIC+gbgI7jPnZhcDOWEckAskkRqhjUBeCPANsK/t15b9B5prBLczrbsZy7CRKmv0Gm4oK7yx61IeJOK/lyc27fv8BakOXuQjZ0hQvkQnJx69chun9sVLNuBxYEm9drTZKkSnwDWcv7Mlhpe4tMLKeMToF84PKuVaOJjmrmWKGbueurSmt4ZJN3kih5ShI1VcvjPTRnXYGqRGraztVz/q3xYDx938TcUYkofnN5QunyZi/zF1wD8RwZ9NGT7BCHxylmGaE8MWHKTizgUMO0coroK3oi0RJ40yaCAy5VPW9UmvHorXjLG8bukj7BMbulD12wXfrXEa6JAyr/1TSVszQtkKL4pzEDS9v2NIKT51u0L+WWZqfPN724HmpuMSesgwDtSv9v4zY0cc21+LJ7sBPpNbDW7ubqY6e/2/NIO/+sHMkMFYOEOFmsZdd2uUWwZETu5giFg8jM7y0RDblvQmVeWk5Rc+I1UD2F8jKZOftqi/7fVb
 q9QXgJBk
 ikZLvvBj5beOOQGNuXVucJRoLRA+kVQODvuXi+zZz7YBqm0y/Pk1XCQfJ21/hshLlKImr2M7Vrcw2+pP5nOxVZgMSrMQLHqx40YYmWR5+ax17mfsRP89tpCb6ID0/iqvRi5SHbzVGsSEZtxiuNV9h5aGHDMtyo0lklaBkLk1pWDIJ1lOLvxTNFQHu5iq6XXHTxIBihh73FJGP7DFTYlZiFaNcQmg4s6u3mYh2RrY63N7MbzSTI6UqaUQdBctGHsee9Lua1ca9iIIeb23dpeM2f/rInRy8yLDUvBN2i0kQ8zIq5EvNCyn4naidKrWaDi3xZa4sWjLbBfsBeqjLr1gPeMGdwvOYMxAlOaZwscGotREe2VuTg0A2oKV5Vnoq+meeocwSH8P43rlfdl1m0wIW/kna1D1CdfK8YDhzcfn2+TA+7RLY2Evitnlwzv6bIvWWlbnBqquzhBol4YyLjUqf8UwXwPAMRgLuSBAEDLEtulKkLbpuHSZhBB/zqBdez1aHyB/Y
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Vernon Yang <yanglincheng@kylinos.cn>

After the page table lock has dropped, the folio can be freed
concurrently. The trace_mm_khugepaged_scan_pmd() is left with
a dangling folio pointer.

So using the folio_pfn() before dropping the page table lock, closing
use-after-free window.

And other pre-existing bug, When the `for (i = 0; i < HPAGE_PMD_NR; i++)`
iteration to terminate and the folio operation preceding is normal, but
pfn will be incorrect. so we really only trace the PFN if it really was
problematic.

About calling the respective trace_xxx() functions separately on success
and failure, refer to [1].

[1] https://lore.kernel.org/linux-mm/ao6jVbVHLUmuY2UA@gremlin/

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Fixes: 7d2eba0557c1 ("mm: add tracepoint for scanning pages")
Cc: stable@vger.kernel.org
Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 include/trace/events/huge_memory.h |  6 +++---
 mm/khugepaged.c                    | 17 ++++++++++++++---
 2 files changed, 17 insertions(+), 6 deletions(-)

diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
index 7b526528f85b..fa828967e1fb 100644
--- a/include/trace/events/huge_memory.h
+++ b/include/trace/events/huge_memory.h
@@ -55,10 +55,10 @@ SCAN_STATUS
 
 TRACE_EVENT(mm_khugepaged_scan_pmd,
 
-	TP_PROTO(struct mm_struct *mm, struct folio *folio,
+	TP_PROTO(struct mm_struct *mm, unsigned long pfn,
 		 int referenced, int none_or_zero, int status, int unmapped),
 
-	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
+	TP_ARGS(mm, pfn, referenced, none_or_zero, status, unmapped),
 
 	TP_STRUCT__entry(
 		__field(struct mm_struct *, mm)
@@ -71,7 +71,7 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
 
 	TP_fast_assign(
 		__entry->mm = mm;
-		__entry->pfn = folio ? folio_pfn(folio) : -1;
+		__entry->pfn = pfn;
 		__entry->referenced = referenced;
 		__entry->none_or_zero = none_or_zero;
 		__entry->status = status;
diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index b597a3e68606..4d360ae87769 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1612,6 +1612,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 	enum scan_result result = SCAN_FAIL;
 	struct page *page = NULL;
 	struct folio *folio = NULL;
+	unsigned long failed_pfn = -1;
 	unsigned long addr;
 	unsigned long enabled_orders;
 	spinlock_t *ptl;
@@ -1706,11 +1707,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (cc->is_khugepaged && !(vma->vm_flags & VM_DROPPABLE) &&
 		    folio_test_lazyfree(folio) && !pte_dirty(pteval)) {
 			result = SCAN_PAGE_LAZYFREE;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
 		if (!folio_test_anon(folio)) {
 			result = SCAN_PAGE_ANON;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1721,6 +1724,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		if (folio_maybe_mapped_shared(folio)) {
 			if (++shared > max_ptes_shared) {
 				result = SCAN_EXCEED_SHARED_PTE;
+				failed_pfn = folio_pfn(folio);
 				count_collapse_event(HPAGE_PMD_ORDER, THP_SCAN_EXCEED_SHARED_PTE,
 						     MTHP_STAT_COLLAPSE_EXCEED_SHARED);
 				goto out_unmap;
@@ -1738,15 +1742,18 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 		cc->node_load[node]++;
 		if (!folio_test_lru(folio)) {
 			result = SCAN_PAGE_LRU;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 		if (folio_test_locked(folio)) {
 			result = SCAN_PAGE_LOCK;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1759,6 +1766,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		 */
 		if (folio_expected_ref_count(folio) != folio_ref_count(folio)) {
 			result = SCAN_PAGE_COUNT;
+			failed_pfn = folio_pfn(folio);
 			goto out_unmap;
 		}
 
@@ -1782,10 +1790,13 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 				       unmapped, cc, enabled_orders);
 		/* mmap_lock was released above, set lock_dropped */
 		*lock_dropped = true;
-	}
+		trace_mm_khugepaged_scan_pmd(mm, -1, referenced, none_or_zero,
+					     SCAN_SUCCEED, unmapped);
+	} else {
 out:
-	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
-				     none_or_zero, result, unmapped);
+		trace_mm_khugepaged_scan_pmd(mm, failed_pfn, referenced,
+					     none_or_zero, result, unmapped);
+	}
 	return result;
 }
 
-- 
2.53.0


