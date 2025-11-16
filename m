Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCBB4CCD19A
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2669C8E001B; Sun, 16 Nov 2025 13:12:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216E68E0005; Sun, 16 Nov 2025 13:12:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105F78E001B; Sun, 16 Nov 2025 13:12:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F0DD28E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3D83B9931
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:38 +0000 (UTC)
X-FDA: 84117265596.20.F248BDB
Received: from mail-qk1-f172.google.com (mail-qk1-f172.google.com [209.85.222.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id B739340012
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:36 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c8W/uVy1";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316756; a=rsa-sha256;
	cv=none;
	b=cu01i8xiqrvRH5vCnWWfKjBpJUs+dsNl28DZE7FJHqJYWZry8ctc+0W2mO3Ubazkr5dpTL
	tRLk7WWYCFQ5F5OKF0SRfruXI/FHcmFFm4EE8TqxFbFsf8mxgdET9Bd/NXVzSYtiwy3ur2
	OOVjh1J2UxcDPgTIRMeBQnPlyJKZSCA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="c8W/uVy1";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.172 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NNujllloQjbVXvXsSLn+SsAVbWylG5jsrz1jM3eZHak=;
	b=FX5Olhc2Omty7XAukO6vsZs/Z0Iu87eyrZUcpJ/Xn48ujQX8Vf5aGAZMWqQS/+DgnrAgqX
	OWh42fo4tY2JqX+PWoiVDetGZOnXScWhg4URwOidSlcRUbgsdhLPmxaV9AvPslxxOYths5
	CBwXtLhZrn9kgle62YQdamvJLZ+npfA=
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-8b23b6d9f11so359125385a.3
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316756; x=1763921556; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NNujllloQjbVXvXsSLn+SsAVbWylG5jsrz1jM3eZHak=;
        b=c8W/uVy1zqSJvDIPhADYE1pIh1VnWNbeil8FKkL5vfnvXeu0ZYxvFPl12yjYnEepZY
         FLXgqYW10C0HUhba3rbfzA/Hw90GiRMT9Ba7i/j8TMnshH7sO/eSGYPQ77Qwqq4ClQzB
         7tkOWHoDYeU1tswxTm1Hc1d/xRT3fGC1l0oaBY1idU0yLr/I+CJ6QsDhOEyGV/MVslXF
         o8xc4eQvAgH7JI21MrDqq7qNuq6K8GQuZngZix1pzVhTnB98gqdaub5mBCGJYMUBf/HS
         H4WGtyeLvHWZaBY3DLlGOALvM7m4JPrJhxbFLkQcv65ybgerGuWkmlC1pRIIU0mwYGUT
         EHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316756; x=1763921556;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=NNujllloQjbVXvXsSLn+SsAVbWylG5jsrz1jM3eZHak=;
        b=f7jViW8j7tVteiZgZafSks+uuuhqDwrAQR1zM+rg4Nu4NSlK5kcvBM/HStYgz1grPg
         0pM2Q+T2Ico605XvekLusgtTIWmb3VQvsy8YTLMSgi+6Ge5Roiouqj8fXU7XT7Pjwy0R
         dGEJxk4rUsc9+l3eJCPqBfaDZevQMiezl3b099Be6eOegBECe+4IN0vbM1z1snaNKM7I
         jcP/hvWzx8wwdOV7BJXLencpK0qgr/TGwqe2bGJ8D6CUY7xhM0sfT73sQRqO4avEFztD
         gULu+YjV54RPRSG5m3f44zW1uU7uOSYu3E5adZWb74OD4N+HP/dLYKHrVVw7WRn7elxF
         jjcA==
X-Gm-Message-State: AOJu0Yyq10cbG8bb3Cg+sSML16RxfGnRiexfCSczVKqRaiqddKLqhkac
	+utvF+dJGUllJR+qgQoXIMjGslvk+p/ziSm42uaBlhi1A5HelLdALn5J
X-Gm-Gg: ASbGncvlFyTwbMhErpkzhWeulNAp7Es4Olwkgs11DQJoodyW2WAGdP75PswnPiY6GoB
	43a2ojKXrDuwq6G0Qutahk1PW9mJZXs+SNEnqSiQ8DJO5C9m5wb3Wx1SR1FYOo55yNFLRkeGHy3
	wdTybsVLW8k2U+HuOJEGW5xBQAywv/13pzavPx5tkGw6PlNy28ziUDu9MpDI2yzRSsQmaLM6LZi
	WLgyzp8kHzFugq/3V+hwPwY9puqxyROqTX+ydpMEuJf1FAthgqwLdPe0a2BuSw9EycNjHeg31zK
	0LoIBDMzrdhOfbyoPeAN8FCsMJCDzeDj+kjJ/7snXTk+xSJDAIyXIsWWTuMvR8snCDFO93BN6s0
	fK4Ti1zqtW7DkeU24anEmvprg29y8dfnk68safhSzLhJB4Wznout5nzITGap9SrXZ8C6Lx1nm/n
	Jq/bkf3OjXuBkRnIkvPMGn7Al1w9Ywlf8ThFQtbQnCm2wb+RZIitl4
X-Google-Smtp-Source: AGHT+IFBHwKki63O9ZEooguIYvPxGgh6LHO5HKXPWrs1r7j2lrhxsDaVOFKFEdD+jVmLK9V7yU1m4g==
X-Received: by 2002:a05:620a:4003:b0:7fd:50bd:193b with SMTP id af79cd13be357-8b2c31306c7mr1217791885a.14.1763316755663;
        Sun, 16 Nov 2025 10:12:35 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:35 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:47 +0800
Subject: [PATCH v2 06/19] mm, swap: free the swap cache after folio is
 mapped
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-6-37730e6ea6d5@tencent.com>
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
In-Reply-To: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
 Barry Song <baohua@kernel.org>, Chris Li <chrisl@kernel.org>, 
 Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=2699;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=HEaEGHmPSVwIYafbKFzg3TdTU/AWpN5SLIcfoADgF+k=;
 b=rOTAx2cwYpJO5/jLxllc/HUaQOchTua/fMcbMU4PSzUf/z0sYlbdLmmKo57P+f48bdG+uzgae
 MIysZK9BagGBmrvlbWD6/S76/u62ShcYaULdXWDmf8sUKpLLz7U2u95
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: B739340012
X-Stat-Signature: ntwd834dm3zow1yjuuth1htfcdmhe3jf
X-Rspam-User: 
X-HE-Tag: 1763316756-317574
X-HE-Meta: U2FsdGVkX1+w4wwvC0HAVPIQEJZei0X8RjWYL4vILL49+t6gJW0oUIwVnavzKhFCPZQvvmyAjjpeNGlnRLrAd69lDTd1nzNq2bZ7gqKPhCzCqi3UhMurNaxEUW89nlrf/W59SX3JzpMTJS72XmXaykVWxJ5f1X1iSUZ8uKWmJ/C/jEgLu9eQjHrHdjcJ5BpeMSKoD0h3sVQIRaHcmALFVjsJGVAMRSDKbbqR8miQ2vbbzuDUufmEvQEQ//v+8S1jHDjqCQpJ2o2kHn306sMNQZn7VUN6i335x2iJYsBuqi21yrO3FpSRkKxQYfxYJw8g6oDHTqvoVHkr+xxRM0TAtZpbXdG2RqcM8Kahy4SDPEgzPXp+p6x5pA3JgCSeCLwxdqyTptsGD6E76pg2kxNNxgOJbizC1QbUJkgCKQJBE9UcfdS01pbaHtDOLa2tkrnN2lor0+ajwg+Gy3m176x3m4DaDCSa8/xifRQCc1LaFN0ydcDrqpqJZcOo/+zJTetcG+sNJgmemWmZmcUJG6w1BzlT+2g6HiYqK6ukok6ZWB66QsnZ5Kn5lVQsflVZS597m/DyVWHVjNdq9kzk11RVd2rjPbU6QJ1+cwR+IT1ouSmtUzeA/e+cJVNakZpQKXjTn+/AddpJHHKmsEf8aZTijtzp4ymktS8zQsYQV1B/8Y1Bo7f3Xam4uGLP8gjuMNm2jzj81DumPdBrZTm99WLaYYLTT2KaJZ0arwVuXAIfgqoJsYuLOhRKreIMCL2JtjMUuztfZGk62vwzfMlJeTxkkVQ3itnejWSohL1ZKseJQB5W9UHCg3wqWaWYzxYA8ZkIcOzJEE57n9gcaygeQuo/hjpPeFGpw3nVNbB7PkTPTCoQCdOImz+HPBEs++OVY7isNLDmnYyaSyxZL0uUEyzA1io8HG1sfZNxajXund6HtVZB4oEZitIC25itPd4wRXlhgyv3j3nyZ9dyxhIMqpc
 KoKax4Se
 ki8E790mjsfUX9qhb4l/M6g6hT9lbDi1BafDGo/z/s8KQXTsM8v7OqsB+E3lekqQvuNfC8PyjLF4P/k0iDUIJm4pirWW72pxlthq8EtwLB/SrI3oMeDswJMp5u0U5NixAteu8tAgJeiOF2ggfXPRTaIxr/0p1qtnjXU2AslDaiKDzJ1fFLAMTIVK+meISa4lOTIAPmqrFgZkZLsA217t3N+fYj0bsFE6iBE898URRZB2eGRB8n9GL1c1RJL5AQkeZDAuwmU+isLQC7Yomx98ld+kdlKmXV5UB9bsHOP75adMRfzy0IxMeicXtY2z3jKLlbC+gaP7B4pkBzPANY0vyKYBV+0ht60hmJ+S7ciNjZIe9Vu3xjLkc7OxYOZcPyoR0XVL6LIae5wBKzcfQFihmuXKDuBS4kU2ByRMoYIQYSJBU8lgf64Bx8W7t8fMb8j8u+ck5uuELjJKHpTvI3cArGPYRwA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

To reduce repeated faults due to parallel swapins of the same PTE,
remove the folio from the swap cache after it is mapped. So new faults
from the swap PTE will be much more likely to see the folio in the swap
cache and wait on it. This does not eliminate all swapin races: an
ongoing swapin fault may still see an empty swap cache. That's harmless,
as the PTE is changed before the swap cache is cleared, so it will just
return and not trigger any repeated faults.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 5bd417ae7f26..022ba4596fd5 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4360,6 +4360,7 @@ static vm_fault_t remove_device_exclusive_entry(struct vm_fault *vmf)
 static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 					   struct folio *folio,
 					   struct vm_area_struct *vma,
+					   unsigned int extra_refs,
 					   unsigned int fault_flags)
 {
 	if (!folio_test_swapcache(folio))
@@ -4382,7 +4383,7 @@ static inline bool should_try_to_free_swap(struct swap_info_struct *si,
 	 * reference only in case it's likely that we'll be the exclusive user.
 	 */
 	return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(folio) &&
-		folio_ref_count(folio) == (1 + folio_nr_pages(folio));
+		folio_ref_count(folio) == (extra_refs + folio_nr_pages(folio));
 }
 
 static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
@@ -4933,15 +4934,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	 */
 	arch_swap_restore(folio_swap(entry, folio), folio);
 
-	/*
-	 * Remove the swap entry and conditionally try to free up the swapcache.
-	 * We're already holding a reference on the page but haven't mapped it
-	 * yet.
-	 */
-	swap_free_nr(entry, nr_pages);
-	if (should_try_to_free_swap(si, folio, vma, vmf->flags))
-		folio_free_swap(folio);
-
 	add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
 	add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
 	pte = mk_pte(page, vma->vm_page_prot);
@@ -4995,6 +4987,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	arch_do_swap_page_nr(vma->vm_mm, vma, address,
 			pte, pte, nr_pages);
 
+	/*
+	 * Remove the swap entry and conditionally try to free up the swapcache.
+	 * Do it after mapping, so raced page faults will likely see the folio
+	 * in swap cache and wait on the folio lock.
+	 */
+	swap_free_nr(entry, nr_pages);
+	if (should_try_to_free_swap(si, folio, vma, nr_pages, vmf->flags))
+		folio_free_swap(folio);
+
 	folio_unlock(folio);
 	if (unlikely(folio != swapcache)) {
 		/*

-- 
2.51.2


