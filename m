Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE29CD59D99
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 09:06:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 632B06B000E; Mon, 15 Dec 2025 04:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A706B0010; Mon, 15 Dec 2025 04:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 520FD6B0011; Mon, 15 Dec 2025 04:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 415C66B000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 04:06:24 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E1F66140E9A
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:06:23 +0000 (UTC)
X-FDA: 84221124246.13.6DC134B
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id EB7BE40004
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:06:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OmK2QN53;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765789582; a=rsa-sha256;
	cv=none;
	b=OdzUsG9FPK/7sYyT/WnIXX9HTr2j77Gk6TNu9I0Yk2VyksXdml9XveYYry/bOx6/ZP5K56
	wDV6lQDWHqKeJGhx0UAoWSLnmEzzNeJhYZMoJFMRoCNk/O8vNO9Zgh3mgAAxZYMicPhVKM
	4kqMK1zp+npiWFFtPZQ1785lJGgF3to=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OmK2QN53;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765789582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLnvhMv7algfkSEFPStrT4JgGd0qCSqLUxdZxB3OeXc=;
	b=6AfVKVSnpWP+7SAbBj9wkHKb8geYldMatGS6mFhqR16reXQvBjz4lMyk7asZRypXkP8plL
	1GPjlpRyqjROb+CV8D4lbmSWU0RFhEBsg5U2y7skX+uyVZXxLWOchkHTrUSs6hVfoAC8ZG
	A8sU3oc+9n9M18zdAV1vyozVP15miho=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7b9c17dd591so2564558b3a.3
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 01:06:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765789581; x=1766394381; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nLnvhMv7algfkSEFPStrT4JgGd0qCSqLUxdZxB3OeXc=;
        b=OmK2QN53x/dyXMCXb6g8BUfJL4InvjFDWUhhwTxYRM1Zv1rhAlDfz9GJKK9Su41Q2/
         Ic8WLqylDb6BkRswJFVIKp0uN1Wkrn6PpfE/Z+68KCiVo7y8aQfqgYTcIZtVQnINnx9d
         g1LMAUJh+P4Uf0LGWoE/6eYVWaX0WSb36j3Dl6V1xn7yueCzgnh3ahFYoEgWK/zwJglQ
         Ks/+cYcIKshG9MEJZmtzSZ5gBCjE2eu8lN4R5ZwOg6gdU6a6ygN8sC9XSH9kMewp41PE
         +w7vccoJU8qiuQe9KRJurhXtCXqE0md4knx4zpbTjyZ9VwGqYD4jFtTHBlLQxLcG+6QZ
         feIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765789581; x=1766394381;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nLnvhMv7algfkSEFPStrT4JgGd0qCSqLUxdZxB3OeXc=;
        b=HKA3GHUgK6p0zJFgGYm+nA/OuiByz3iTCKcvGkCtrIeAU+vBPUnMjr3SRQZVHpBcrO
         f5e3MKYpa/kcjyo8dO4moT//WC5TNxESaJB0/FfpLaI8de8CLYQ/FBBgzdZTgh2mFNi9
         bQ3u4LJHnw61i40C5lzhP5jDMoOxfFLpiHmrOpXRqwK4Wo8PcsCkfvm7uMnfFcKPp/bK
         5YJUrKBlJF3xiDB0J5C5CWBlFnuVyb+uFB+QflJ1oVcP5oCRZmmy8nv6IF1OAHLrfwvq
         ASah06bjLaCBk6lcXr2YFfeBlOq37YERhJcOoZ6X3uk5/7wH2zJ5CJ5c17SXoUz9y31N
         VD1w==
X-Forwarded-Encrypted: i=1; AJvYcCWz75/2i8B6fkC5Z41jwcrHxCCT0pbX7+LvT62z1VqQ6HPvCDPvedLBQvvzuZ5THZLXNvhnqgzg4Q==@kvack.org
X-Gm-Message-State: AOJu0YzMDxd9q6etR68u1R5dPxf+R7Hzn0MGG8NnA6dF5r/u2forJUhd
	FEldYxlR+eTyhek2gpRtJ618vyvx0jZpWOGetFapLqgpfU1qmYT722L6
X-Gm-Gg: AY/fxX7HWPisk4hnnzIqreG2xreXaFFLaVzIwVcvjMl+CpjcIBjksG4FjwwYir7Dso6
	6i6wguLCzXSbmof3BKbKE4ZrADisz0+iN4MLVwsaWc+jMRtnPEV+w04953EG+E0cdxhr2T428Xw
	E7Oe2b1YIDAQFsgV3A2bWejOrGJH/03jXd49gDLI/aDv6+egV3/DI40+HiO5ToLTaUXMNrdGFmB
	UPvo+e5QHKTOdLMx1Qe6vG2wX7XWXW0o5MhoxzCj5ZFSqb9SWVS0vTQpAQgw4IoxvnC312oFQ+K
	NZE86737PaCBF1e9SS4n9hof1S3MXYj6v5NAskVU6ynkAFuy1YCQOv4s9QORVf64ik8Qvc0oHPQ
	w46Y6nHN7K+roQptOdmHnOWYMAh0TxbL9uvJpBYFNOept2MGnX+XrfZmt+xynn/2OeKsi/w0nEe
	20Q46rNoJkHbwi6c04Vh8fvmn67wheuw==
X-Google-Smtp-Source: AGHT+IEkFdpSwAU2QsBWc557vGo0xZJBtCJJz+ChzCFKRe5nKXPyONEwNRKDwuLsgqdT0E+Gsu59gg==
X-Received: by 2002:a05:6a00:1d0a:b0:7bf:1a4b:1665 with SMTP id d2e1a72fcca58-7f667a2ba24mr8638059b3a.15.1765789580815;
        Mon, 15 Dec 2025 01:06:20 -0800 (PST)
Received: from localhost.localdomain ([114.231.217.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7f4c5093a40sm11993160b3a.46.2025.12.15.01.06.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Dec 2025 01:06:20 -0800 (PST)
From: Vernon Yang <vernon2gm@gmail.com>
X-Google-Original-From: Vernon Yang <yanglincheng@kylinos.cn>
To: akpm@linux-foundation.org,
	david@kernel.org,
	lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com,
	npache@redhat.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vernon Yang <yanglincheng@kylinos.cn>
Subject: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been collapsed
Date: Mon, 15 Dec 2025 17:04:17 +0800
Message-ID: <20251215090419.174418-3-yanglincheng@kylinos.cn>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251215090419.174418-1-yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EB7BE40004
X-Stat-Signature: nh8nobgqo819q81nek6d4h37icxjften
X-Rspam-User: 
X-HE-Tag: 1765789581-389397
X-HE-Meta: U2FsdGVkX1/mpg8ChZq+Dw/5Xi2bxU/4cjflXoBCn1fVgnKNXIV4E40BgULQjLJDE8wM5m0pVHoEfDK7LNmQcbu1s+B1e7Zx6ijQ2gyDutbNqSxt3oz3nfbnJcWAWl8b74ifXfbk+DT/CiVHtnlHMeN3/gbuSzPZZnG8D3yDxqb3TUvDhZb3LiapmwHFy2AFKKjmDzQoGMJ2jMfUdkI6yQ+vLEL23gybKj/3b8DbO0GVCgPUONtpHdTbdPb+XZvQt5dmjdvT2LPZwwpdTdEFV9vEEXttsTVCp6X08ulQJ3+kxxIs8e0o+SVh5BZdErWO9N++qSCjvB1LGPCCQTf89AP0rrM7po0XpBzJep+DGKiCshUxKV/6I8dXenzbYWRZ10RTDlBc8KTzLhqGKaBjAI5yYylNM4keyr1taQhQMcKD1GSZBTQ9NBsQKAw75fikc48vqWF0vV880lJT78BBP01ygAWipoLqWzyFTWsU46WeK2M9yfXSPy+WvEQ8Q9ON2a4J7M9SG8ZM8Y6QLl6ohFizn97Otc8WIse7+m5uiAxc+UHA9WE5cZeSuEflKRkDTRf659FdJFTxQtKIk2adcL3MbhkdoxXn1FlnN1GfdfzzV9nsoPGkjvVxSp818/lE0LVkDsbFBKcJnF70oE4lR4Fj6zYuqsXuP2v548He5bcKrHvzscAuyFn8Yi4B6y8hv1zhRuZEe6h1G1Zz1UhYu6KWUjaC2zzP1wrIvtYwIfH48KEq4O0KCvf8nJXVhL9WKfDl4WCgMFdD1QFZCiLoFg7STw9gqcDuzXDB8LogcR5MeICuksdwk0LNzF83ut/VoCUrCM3NAMgZ0XaTAuV/rAZrv9EIwVOD4I2TuBI9vd3vqD2uPzF//SAdKk4y6tgqYKW9A8pDDrri23OLYzuFNg2MHSuser+s55kRYdkDXbOrZAZ+nyp82BwiGm9s2p2aG0ohhezU+32MIyhH3X3
 g+VQyMHR
 ojHLkTXTc9f5PAtKQWHFvNpTiuWg59xy4UuvDENNRU6ZvbMZ1aiOfNZBDj3omzJ+lkrscj0noHMdVssNFZDWgSbtXi8VhFZt32sKkLICkINO/zb/bm3ypbyvSFfU9ALevMs6kzVsjXORviyGIBLcQlU5LKXnB49S++g1+lnSPBhwUz3CI2Gn6T0gE/81zo6bvIFkzZH3SlB3CymQtAQ6z1WaVosG4luPubkxtBkm+KovCcJXOk6516bQseO/3t8qSchdzguWJ+Ds3fhaHrOQGyEJLRTkAEO2fIT7btA51g3I3IFvoEgmjSR9yi51Q3JK0Q9i9X90LEPvfFaRgWX4Bd/zPnJJWFl0T2zXEfPj3lxzp5PjEpan/60QEFBMkWo0pUpAtl/C9fJWMnfeR8nCeXf2jCxeqd/Dkdv9qaU34AKjzhVAe7KzRuL3h8sO5+RZE/eDk
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The following data is traced by bpftrace on a desktop system. After
the system has been left idle for 10 minutes upon booting, a lot of
SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
khugepaged.

@scan_pmd_status[1]: 1           ## SCAN_SUCCEED
@scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
@scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
total progress size: 701 MB
Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs

The khugepaged_scan list save all task that support collapse into hugepage,
as long as the take is not destroyed, khugepaged will not remove it from
the khugepaged_scan list. This exist a phenomenon where task has already
collapsed all memory regions into hugepage, but khugepaged continues to
scan it, which wastes CPU time and invalid, and due to
khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
scanning a large number of invalid task, so scanning really valid task
is later.

After applying this patch, when all memory is either SCAN_PMD_MAPPED or
SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
list. If the page fault or MADV_HUGEPAGE again, it is added back to
khugepaged.

Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
---
 mm/khugepaged.c | 35 +++++++++++++++++++++++++----------
 1 file changed, 25 insertions(+), 10 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 0598a19a98cc..1ec1af5be3c8 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -115,6 +115,7 @@ struct khugepaged_scan {
 	struct list_head mm_head;
 	struct mm_slot *mm_slot;
 	unsigned long address;
+	bool maybe_collapse;
 };
 
 static struct khugepaged_scan khugepaged_scan = {
@@ -1420,22 +1421,19 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
 	return result;
 }
 
-static void collect_mm_slot(struct mm_slot *slot)
+static void collect_mm_slot(struct mm_slot *slot, bool maybe_collapse)
 {
 	struct mm_struct *mm = slot->mm;
 
 	lockdep_assert_held(&khugepaged_mm_lock);
 
-	if (hpage_collapse_test_exit(mm)) {
+	if (hpage_collapse_test_exit(mm) || !maybe_collapse) {
 		/* free mm_slot */
 		hash_del(&slot->hash);
 		list_del(&slot->mm_node);
 
-		/*
-		 * Not strictly needed because the mm exited already.
-		 *
-		 * mm_flags_clear(MMF_VM_HUGEPAGE, mm);
-		 */
+		if (!maybe_collapse)
+			mm_flags_clear(MMF_VM_HUGEPAGE, mm);
 
 		/* khugepaged_mm_lock actually not necessary for the below */
 		mm_slot_free(mm_slot_cache, slot);
@@ -2397,6 +2395,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 				     struct mm_slot, mm_node);
 		khugepaged_scan.address = 0;
 		khugepaged_scan.mm_slot = slot;
+		khugepaged_scan.maybe_collapse = false;
 	}
 	spin_unlock(&khugepaged_mm_lock);
 
@@ -2470,8 +2469,18 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 					khugepaged_scan.address, &mmap_locked, cc);
 			}
 
-			if (*result == SCAN_SUCCEED)
+			switch (*result) {
+			case SCAN_PMD_NULL:
+			case SCAN_PMD_NONE:
+			case SCAN_PMD_MAPPED:
+			case SCAN_PTE_MAPPED_HUGEPAGE:
+				break;
+			case SCAN_SUCCEED:
 				++khugepaged_pages_collapsed;
+				fallthrough;
+			default:
+				khugepaged_scan.maybe_collapse = true;
+			}
 
 			/* move to next address */
 			khugepaged_scan.address += HPAGE_PMD_SIZE;
@@ -2500,6 +2509,11 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 	 * if we scanned all vmas of this mm.
 	 */
 	if (hpage_collapse_test_exit(mm) || !vma) {
+		bool maybe_collapse = khugepaged_scan.maybe_collapse;
+
+		if (mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm))
+			maybe_collapse = true;
+
 		/*
 		 * Make sure that if mm_users is reaching zero while
 		 * khugepaged runs here, khugepaged_exit will find
@@ -2508,12 +2522,13 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
 		if (!list_is_last(&slot->mm_node, &khugepaged_scan.mm_head)) {
 			khugepaged_scan.mm_slot = list_next_entry(slot, mm_node);
 			khugepaged_scan.address = 0;
+			khugepaged_scan.maybe_collapse = false;
 		} else {
 			khugepaged_scan.mm_slot = NULL;
 			khugepaged_full_scans++;
 		}
 
-		collect_mm_slot(slot);
+		collect_mm_slot(slot, maybe_collapse);
 	}
 
 	trace_mm_khugepaged_scan(mm, progress, khugepaged_scan.mm_slot == NULL);
@@ -2616,7 +2631,7 @@ static int khugepaged(void *none)
 	slot = khugepaged_scan.mm_slot;
 	khugepaged_scan.mm_slot = NULL;
 	if (slot)
-		collect_mm_slot(slot);
+		collect_mm_slot(slot, true);
 	spin_unlock(&khugepaged_mm_lock);
 	return 0;
 }
-- 
2.51.0


