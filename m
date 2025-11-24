Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1B9F2CFD348
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 19:16:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6726A6B0030; Mon, 24 Nov 2025 14:16:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64A286B0031; Mon, 24 Nov 2025 14:16:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539336B0032; Mon, 24 Nov 2025 14:16:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 41DCA6B0030
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 14:16:05 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 04BF81309B5
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:04 +0000 (UTC)
X-FDA: 84146455890.04.B61D60C
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0BD8B1A0014
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 19:16:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wk+LvzCm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764011763; a=rsa-sha256;
	cv=none;
	b=deL052d6QjFauMxzii3XbeUB8slRf/9v4A/VrdIcCYd3AufMsavSb2SD1douOk6RjAivK3
	jttpKyjzNvXH+Czn/1EBvnuO4lGiC30fTDr2SVXvCw8yWfUanH80f3TUCAd3pGL2zOj8eF
	yq2kUv6LWjDkWPLkU4H37pVNU3T2QRQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Wk+LvzCm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764011763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uX9WKXwPMUhDf2nsEW9hz+YtSdKaTQoicE44/0zqUlg=;
	b=cTsvnnXGPeZ7aOvMIbi0BolTk74d+4gt/0kXCtgRu3EFy4hEoDgDvc3Vb7nL7O5vyTLGOi
	MAYxhzPZmdxkJyzHNzU9z1U9dtuPqMOXzW0GRdrdbAy0Y1SnON1wvBnb44LKM1ZN6FgHhS
	7OjCtbU3UhUktRpc9wmiWVZZfOsDAQw=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-297f35be2ffso70523005ad.2
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 11:16:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764011762; x=1764616562; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uX9WKXwPMUhDf2nsEW9hz+YtSdKaTQoicE44/0zqUlg=;
        b=Wk+LvzCmH76ebsIAchthZxadH8BlfBkGupHwc4MNaQWGdzkJg0You6256J+552SUaO
         uyny2c5iSW20AYaud5X9ua7w5K2evLbt/jADuhlHD2aB7l9+HofLh3GjmiHRv7V+DsOG
         8zzJ5W/yAuQ5UezOgNNQEtcWDunxBgY978K2FBhG/LTVqQt7rh2E5n0UF9j+5AFd6oud
         XvC/LIaDWCPpBoA2Q+AWFRH2n4L5MvUFiU9uUilg/Q2KqFCeXJHX5VouppUOv3yAQSyQ
         8WPT7Fb0UBRCY6GmVpSkjaK5z63JQuxjwdtuVW99yIYVq0VIOlC3K/0clx98RBArSgnp
         vQTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764011762; x=1764616562;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=uX9WKXwPMUhDf2nsEW9hz+YtSdKaTQoicE44/0zqUlg=;
        b=M8svskLXoxazkvvTmWXg9tyAvBgN6XhzhPSQSD1RcwPFM8aeIxSLx5yaz8mSdkzHU8
         UhJ2eoAjD/oJV8QTnx9kFErAsHGIccKZG9/FCSTDf9P6B7S9ZBu0E1WGPT3M5Z8/NNk4
         lCR9Vd1jxgPuucyYJjrO7vX2mVgVuGzP4prKJQOTC7Q4/a+Buaz2LyXfbM2seUIq35nr
         YvVzL/4tsCQFCFJlrOo5jjzCQZWwYOPfjmJuOx8Sh/0+dYWBLhS6hVglUFheqGXLm0EQ
         o5KLJzcX9YveTJnDRG1Jokz7RAWwa4hBVHDPv9t5VFkye4VY+g8w0byMPWTjY40XbEbX
         CNoA==
X-Gm-Message-State: AOJu0Yxt4f8+rKq6+SVkoNGG7jGzauOA6fQu7o2+exB+7MYNpkk0dNg9
	AtH908ujTu46mPcuO66F5ofA2OhOITsZtKIUMtAH1Jd1e89UYb/zzcFl
X-Gm-Gg: ASbGnct010huM0ff5B276JEA0+Xfy/EJRClUg8YwHS92jHe5FvduEvps1+d8iDe/+7p
	DvocNfTlLHJlIJGavs77Om4upcbZ6xN7FzWUgG21NPPa6PvN29NrKvZ1iVyED5RJED3USI/WhcR
	VZitDQi8ntZQSihp5h0ZflpOz/6wwOnf3p+80wRdtMdvntF+5f2pc+RQylBKGAI1RalacqN1J5S
	7zq6e18LmwMWbZDxjKmaHv+wr6dog8uztqjCvXRCwWmQRegys2jaZuvDrMAmlFDP+07JSadmOyd
	3q8fPpniG8DuXJw7uUr+kAZb51419oGHD4m82zT08wc3ziZDm7h6Hs0nXIGrURfBl1DqhzXOyVA
	c9S4QfjcPtkneHQEM0A2MvjhO0xOVpkvHCR0N1gszMdejsGbuEwPeeXi0norISmcPkiurWLLRgS
	Jr8omLCBAGwH8mqsLxdJPwO9w7Uj/kQibK2sqK/VewfWR6U8BI
X-Google-Smtp-Source: AGHT+IGXvjF9/EgUklxEzQMKZ0EM1T6fsSlpBa15IzV2WahRfwiKSOTO8fwKtjP/5+JY2RbSjWFmqQ==
X-Received: by 2002:a17:902:ccc4:b0:295:54cd:d2dc with SMTP id d9443c01a7336-29b6c4047efmr127444105ad.16.1764011761818;
        Mon, 24 Nov 2025 11:16:01 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-bd75def75ffsm14327479a12.3.2025.11.24.11.15.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Nov 2025 11:16:01 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 25 Nov 2025 03:13:48 +0800
Subject: [PATCH v3 05/19] mm, swap: simplify the code and reduce indention
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-swap-table-p2-v3-5-33f54f707a5c@tencent.com>
References: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
In-Reply-To: <20251125-swap-table-p2-v3-0-33f54f707a5c@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1764011730; l=4358;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=7VD9T4L1mbbNr1WJIIQ0GVUukfOHNZ1e5OxrzJG+X+g=;
 b=3D4v+AHG9s/wpBznpCDKMKaj1xP0A5A9yd1yAPXPCdUuinASQIZYf+USPDHHk9oX1eM8vgTDp
 oKHMS9i28MkCiqWOdiw0b9Zlmvf5RPt/9oH8ixBpJyKiqLhNlQxOXEh
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Queue-Id: 0BD8B1A0014
X-Rspamd-Server: rspam07
X-Stat-Signature: j6a4pa4ar4j5i7rydi7kx78ropokwcfx
X-Rspam-User: 
X-HE-Tag: 1764011762-593127
X-HE-Meta: U2FsdGVkX1+IpxORyInnT2WanXeHwNdcW5oP49uwenxh+AtYg/Us+HT2SCJaPoM1Dyi/aFT+eu8dpKM/NbPp1NekPTEM/iS8KMOHmUyPj2buEJ6x5oAs5/eQT//9c+opYzOR+79EFTbw8TTwhsWQqX5MUYDY9PsykdG0RZj66pYvulxek+c+fPPAMbCaP56d1QSxYpEeAecudDAyV3oraIVR80QX117SeDYT8Q3BS3n4AiVMmUP7Eu96Y5FnNWNu7UXMfHO/bZHnUe5jw4MvXjOvFcqD8YUclUhT3sDfFCBkzFNB/4EirSS88psGEzBjZO17Nn3Kkgx+E11vtKTDSNNRvcLdcMSjEuYNra9GYA8fq9lZIi0b4WnFNjSE4JPiBloyXCRph6CUhOsSrlDaz2ehN5iM75HGn2hmkdO7vDDGRnCnrX5+zQmzoRv29NxoUnQpYj0Gx8epl7ycvHmAm/oo06ndYlJXkh9VlCtR0qyuYfaF64QoTXjcH7Xus6kARJkHCYch0cRYvvQmQyj3dfFRVGzJNuTJQc1ANkS+V31gk9Vv66w1OPGeI19SC3ZnsovhVFt1O8D3HUIByDHNzdn1KXdESA7Xu3Tvu8jxHjm1UmH03GCdBA9ta9W79dMkAW8s2L57VsczF7YGwT7qVgYpkr6TtdAvpHkLMgBcxRPYjnM4ZCFQiMMw+4nBRYuEmj64ua/EVkog4UyFvkQ63KhhXjXfpr0y07QZ2bL08GBpB/mUgGt+2lodPP4CfWoSIp+uvAMbo7rUAm67EsGwpZ5tHbyHr+M/G4nbGbdCpBsOs4310QWN3fXWXHTT/rEbaNFoopfxecVqMLTFQww+HkE0W4cjLo7U0FLJTQPK4ciz5d3Kp9z8TtMN3gqUWopHUieticJhqzLdd9tGQMok3pelJdmkJz3Wqyu27u9nDSDW22PITzUAvgf9ttFUrWfgW0OVN+nX7al4qTTFTNe
 mL/Z95wh
 tCrXeCfxmY2zo3DV2xCyRxhCpYzuZEOA3456roWFpc5wbuetpCu0dgt7LZck/8/cRoWCMEDm5BbTLhZ4Y011W9bmwXDWbquaxU4p9E+SLH8UXkM5MwD+bmFEntQ8fEH3t3/ANkqah1w49KzdILMVq41ZyBHlhtrM+bA3PQL1BjZosVtsI5jgYsU7qhoZ6uIgb7aaihD4hkc2N4CklgK/vR0keXK4q5zIuq1DLJextD+Nvogjf9DX41mtdKhwMFlZpanKsx2EfUE7iE5WNIU3JrCBiTAjOvXv/p/dedHH6qvNAl1CJI8S87APSkB3z0k64HHOpII4rQ63bXoQX7lbv+i5JQ5NsX3dgInRaNtuS2jisF11NDNSUoscn9DxqmdhROiJWrXQnuc2w6GJyJ9szIMLimr9Jjo1YWoxjKDoEg387MkmER6Sx8BbS2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Now swap cache is always used, multiple swap cache checks are no longer
useful, remove them and reduce the code indention.

No behavior change.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/memory.c | 89 +++++++++++++++++++++++++++++--------------------------------
 1 file changed, 43 insertions(+), 46 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9fb2032772f2..3f707275d540 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4764,55 +4764,52 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 		goto out_release;
 
 	page = folio_file_page(folio, swp_offset(entry));
-	if (swapcache) {
-		/*
-		 * Make sure folio_free_swap() or swapoff did not release the
-		 * swapcache from under us.  The page pin, and pte_same test
-		 * below, are not enough to exclude that.  Even if it is still
-		 * swapcache, we need to check that the page's swap has not
-		 * changed.
-		 */
-		if (unlikely(!folio_matches_swap_entry(folio, entry)))
-			goto out_page;
-
-		if (unlikely(PageHWPoison(page))) {
-			/*
-			 * hwpoisoned dirty swapcache pages are kept for killing
-			 * owner processes (which may be unknown at hwpoison time)
-			 */
-			ret = VM_FAULT_HWPOISON;
-			goto out_page;
-		}
-
-		/*
-		 * KSM sometimes has to copy on read faults, for example, if
-		 * folio->index of non-ksm folios would be nonlinear inside the
-		 * anon VMA -- the ksm flag is lost on actual swapout.
-		 */
-		folio = ksm_might_need_to_copy(folio, vma, vmf->address);
-		if (unlikely(!folio)) {
-			ret = VM_FAULT_OOM;
-			folio = swapcache;
-			goto out_page;
-		} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
-			ret = VM_FAULT_HWPOISON;
-			folio = swapcache;
-			goto out_page;
-		}
-		if (folio != swapcache)
-			page = folio_page(folio, 0);
+	/*
+	 * Make sure folio_free_swap() or swapoff did not release the
+	 * swapcache from under us.  The page pin, and pte_same test
+	 * below, are not enough to exclude that.  Even if it is still
+	 * swapcache, we need to check that the page's swap has not
+	 * changed.
+	 */
+	if (unlikely(!folio_matches_swap_entry(folio, entry)))
+		goto out_page;
 
+	if (unlikely(PageHWPoison(page))) {
 		/*
-		 * If we want to map a page that's in the swapcache writable, we
-		 * have to detect via the refcount if we're really the exclusive
-		 * owner. Try removing the extra reference from the local LRU
-		 * caches if required.
+		 * hwpoisoned dirty swapcache pages are kept for killing
+		 * owner processes (which may be unknown at hwpoison time)
 		 */
-		if ((vmf->flags & FAULT_FLAG_WRITE) && folio == swapcache &&
-		    !folio_test_ksm(folio) && !folio_test_lru(folio))
-			lru_add_drain();
+		ret = VM_FAULT_HWPOISON;
+		goto out_page;
 	}
 
+	/*
+	 * KSM sometimes has to copy on read faults, for example, if
+	 * folio->index of non-ksm folios would be nonlinear inside the
+	 * anon VMA -- the ksm flag is lost on actual swapout.
+	 */
+	folio = ksm_might_need_to_copy(folio, vma, vmf->address);
+	if (unlikely(!folio)) {
+		ret = VM_FAULT_OOM;
+		folio = swapcache;
+		goto out_page;
+	} else if (unlikely(folio == ERR_PTR(-EHWPOISON))) {
+		ret = VM_FAULT_HWPOISON;
+		folio = swapcache;
+		goto out_page;
+	} else if (folio != swapcache)
+		page = folio_page(folio, 0);
+
+	/*
+	 * If we want to map a page that's in the swapcache writable, we
+	 * have to detect via the refcount if we're really the exclusive
+	 * owner. Try removing the extra reference from the local LRU
+	 * caches if required.
+	 */
+	if ((vmf->flags & FAULT_FLAG_WRITE) &&
+	    !folio_test_ksm(folio) && !folio_test_lru(folio))
+		lru_add_drain();
+
 	folio_throttle_swaprate(folio, GFP_KERNEL);
 
 	/*
@@ -5002,7 +4999,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			pte, pte, nr_pages);
 
 	folio_unlock(folio);
-	if (folio != swapcache && swapcache) {
+	if (unlikely(folio != swapcache)) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -5040,7 +5037,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
-	if (folio != swapcache && swapcache) {
+	if (folio != swapcache) {
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}

-- 
2.52.0


