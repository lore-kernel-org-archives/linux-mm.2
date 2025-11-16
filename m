Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83C5CCD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 18:12:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD83F8E001A; Sun, 16 Nov 2025 13:12:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAF248E0005; Sun, 16 Nov 2025 13:12:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E8E8E001A; Sun, 16 Nov 2025 13:12:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7F6A8E0005
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 13:12:32 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 77A278A047
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:32 +0000 (UTC)
X-FDA: 84117265344.19.50B7205
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6632640003
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 18:12:30 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hPEZp6LA;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763316750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l5EyM9JLLcI0p9xQ+9GuOSt7RQAmk5ALAj7+tQKQk5U=;
	b=Dx4/Q+yh5d5Wlela2U3b0w524T0JamxsOQ2tP0T53Ban4KfnHqZ/bz2Cu1qwFs68bvZhFb
	+tf2avqUHTN4dIfu3I1HrySmpJ1WGe/wuougYOhe92PlSB7uVpqI8ZOyRzFUap7f/+WHGA
	UjT7ctoGmV645KR/ikvTAWD1yzcX9uw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763316750; a=rsa-sha256;
	cv=none;
	b=lNmiw/uFOzlbYj2dFYq8cO0kUwH5Jf26ROedMSsL6x4jYPT5BsXOBtQP8n3phqmXQ5oPjC
	5QK6bOD/6eTAMhCUdSzpIZfYiLZOsvIEV7hiKbCb6RaS4xXYSjVvgAJJ///D3QGrqw0RqC
	NGuzZ42LHOm4PM+HovIBx5keSrkIOms=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hPEZp6LA;
	spf=pass (imf07.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.222.181 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-8b144ec3aa8so373966585a.2
        for <linux-mm@kvack.org>; Sun, 16 Nov 2025 10:12:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763316749; x=1763921549; darn=kvack.org;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l5EyM9JLLcI0p9xQ+9GuOSt7RQAmk5ALAj7+tQKQk5U=;
        b=hPEZp6LAKf0qAF11Z7OXkc4nhkb5XqE7A5KJ6hz88P07V/0E6Rvl+jQXItlFXItSll
         O14sVxHvqDcExyX1BDJoniqDbGFZIMT60373/FMotBKVCb4xumlAJWC+Yb2DrFB9xZAQ
         fAO5H6Q+uAIIsRm+oa1EPQPKcdMFHF9X1V1is9sZyWMzbbX5//XyPn0sW57f4F2A20tG
         UrgmdOp+pNQRcf46dpz6d1ItmyQd1QYAyL55sxRUZbLSBs9RmdLrY+68zXWJq6mqCYuJ
         srH1V3+jagLCBM3HRRaXrPzvj223FV2k+6CnyRXTnOmU6lgWwOire/TvdwVzJMNCVo4z
         HSQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763316749; x=1763921549;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=l5EyM9JLLcI0p9xQ+9GuOSt7RQAmk5ALAj7+tQKQk5U=;
        b=uP3T8LiTAXM8Cs4LDkyCO2cpmXXqDmZIzUGEO8vAoL6LUI9vR7Myu3gauIcGIlLurP
         +6UR5BiQiJSdkn6tGgMj8Pa7MeViSkPlDv9PZcBMHOxG6E2+TUUfkC6wgliedRiPRxDV
         qwxZag+ycIpbCVK7fJn3CyFLts7RRsvVh8YGzgef054JQAnnbCBWHwLgIRGr8B/ziEnK
         Igi63x7PZfgOcBY9WyCBcsRj3QMuR7irZjstO6HM3M+O9TC1/h5GXSMWPVNFEETt1cE1
         LJ0i4kWTwRknNi8wAmLXQ5wTB4AcYfW7rLX1y4ozYqjypiL6tW7c8XkcjlyBWP23tTxh
         hpnw==
X-Gm-Message-State: AOJu0YxmKdllzXrV/SktVLJ9jW3x+YjR8N+Zl/Wrdn/wxzDy4tj0ne/w
	C6RnjhFHp5I+2m0S5kLx/n2sdlnk7c8KpG0fLOQ/mKxZc0n/nQxKjvpG
X-Gm-Gg: ASbGncupNhHRLUEhYGv07UrRyC6xuNaOs/683R8KP3om9TRgRpmQI87TovP1YEPGjgf
	m1/HutqdGAukH0i6DUzuWeSSwx2ej8KvHtoYlU6v4qlx2xk8mASob6+5bRhjlRJsbgpPh6Ed7PB
	NrnJJcSstCbo+sw8Hx0PHZr8OPCh9vqZprc5DV+01raxnvIKlCW0xy4IXb4Z+gRiM+gcmb9EvNj
	9n7j21U66ToKSYWHKUhDs0A7MhuB1Mv7IHfUlXfT5R+yZHKJIgi3HSUBqw+y6TJCe2f026SzsQD
	qAqLjcKpRZEVzD8ZJ7utOXnn+bnKZ9UdvO8SYLmCNO13DiR/Fk0e33Efs00U0DzTXBc7IF+Av/O
	K4hemVFb0HRFnPLObFYsW0GYcC1pvxBnNFKJ0oe7Pi0/VIoS57wO0u3fg/hZZU56hrVYWHACD77
	1deQwpI5+nvF+xUdbbqkbA0qHKneQ2ouUD8GngreGIHQ==
X-Google-Smtp-Source: AGHT+IHQefRN+bjbWKY5VFWpotsL1pk/rclBTOsKTXipe0p4DuCnqbmJXiAmeZ/BgoYkjWuCZaWcOw==
X-Received: by 2002:a05:620a:4869:b0:8b2:d72d:e41b with SMTP id af79cd13be357-8b2d72de8cdmr564625085a.44.1763316749357;
        Sun, 16 Nov 2025 10:12:29 -0800 (PST)
Received: from [127.0.0.1] ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b2e089b436sm305447785a.45.2025.11.16.10.12.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Nov 2025 10:12:28 -0800 (PST)
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 17 Nov 2025 02:11:46 +0800
Subject: [PATCH v2 05/19] mm, swap: simplify the code and reduce indention
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251117-swap-table-p2-v2-5-37730e6ea6d5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1763316712; l=4358;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=QCdSC5PjiK2CWn/AsMjUxzckDwd8J5J9QJFfp6q+46o=;
 b=iiHdIRbhcVHWdIq1mWA1h3WXak5y8YHl+lUzc9z4u5wBGAUQWUbwTFLzc+gzwvCBtApe3qrJ4
 nY10gTrDhgbD8kAqxN4kBibudSouwodTDBa9h4EjPaSxrXDwhCVcc2x
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6632640003
X-Stat-Signature: xzwhypozadr6jxsjeb7pb594rcdsqeto
X-Rspam-User: 
X-HE-Tag: 1763316750-607128
X-HE-Meta: U2FsdGVkX1+e7H8khM3DgiWIRe8urh/nWvPCMQMwZfbCdy9IgoinxSrZ8m+iuli3wu3GDiIku/UvLQLDDozsBOBLkg7JCLbpDyn0GTHEEBuCSNpBCZFJEem4W+7dauyG2wBYvUnssqpRuzTmTFsUjVKtn/4o1LlO1dFcYV2aE/qmpCfNlyP8/QpqePKflFSnbqz4+jtk8TdJcC1kv1zGqgr7osZQKZLfaI65GXOCgXtesqrTasVUMksYkA5rYP6TAJpP9I1Mud2V1ChcxFA3P952i1ah+FAbH3FVsTeJkORJSoPPC7pr7+F4lQSedreJqpDsXLMwQb5pA1VCaR1KhKBehxjDlypOsX2jnPfQv0xuPLInhTkPNPiZb7/NMrYEWoEHvlzvf1OB2oxcaMqvpm+ZhmalzwhCriAamApnU8ZeBRvPRur1H5BcD4ZKPYuvxOHgQyYWekS7fM/icQhVa3gv3/HnGbJfII06ReR4FilTVWTrl2WbqHT9h+SZbFxIbrOEoRPQctRcD1BRPm8HGYwLBENJ8y6Q5TZdIQFL9hAGUtsU3Ub8keKRgWUOEKQS/ekAgXgAmyUIsNc5N8JweTTyWJunP3Bf7rlseSY0Wig65fAUS1V1xQ7GCjVhB6wkYFdngQ9FhUIvoQYniEyWl6EBRW3r/EdvShuLuQT7yH+ZdGLKwCJD8Ykr3wG4Fm6ApzVqGWGtlReWcElL4d+Y69TxfiI5FaoWBwP3dK7zm1ig7IihTZmbfkh5VyaleqTfPE0DohegEBZiAAzlG8CCMGGr52Hvjthy3F+mKSerPSIG1sn+Cp2GRyq4smm18fIje1sllxYMhxOlqbty4h6kG2q5z8pN76LCqRsVtu8HuJjxVPB2CqSdZFbPvsTpprgzCFgLi2XYY8NwfZZsqWfAkX2oSIWUSTZ86K92K1BX1IVFZTjbOezVvfd9PgYKyQzMTrqErmBXr1f1c0DKZNB
 t751G/W2
 h4I+JZBTN2gpd1PrOqfT+UM5KIfKn5vbn2Y5+dBpUyKMVMCBUC2JW0KU/3c3nSmuQGCPkjYBkX5+bGIk25Ucq1zrieZ5Fy8hanGc0LDU5lw+EyIjsH4LyI5on4vGECHRjC20rkFH5HhNt0x6mJFlqM5Y/YPFlJ7qs1qp5YLlBvuLTiriC0A7jdjHCCAV0RHfVNqVWBszskzaikkBFoz9nbszW6WTODwD873sNhp6rQHSqN4UEOYWPstlnMmUQnGsOY0Zxg8eutVYvpKjgXhXDEDppNCiyiyPYoPEKvm32hKBt7Nu6sKIxRvthAbZ6TBkY+8O7AwDmv9NIwRcB79KnAyfMgIMtTq05Hno5bJdcdg7tZAf/F0UKSbHC8uNB6gyoW+LZo/Ro4BqjZoU=
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
index 806becd6bad5..5bd417ae7f26 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4761,55 +4761,52 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
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
@@ -4999,7 +4996,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 			pte, pte, nr_pages);
 
 	folio_unlock(folio);
-	if (folio != swapcache && swapcache) {
+	if (unlikely(folio != swapcache)) {
 		/*
 		 * Hold the lock to avoid the swap entry to be reused
 		 * until we take the PT lock for the pte_same() check
@@ -5037,7 +5034,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 	folio_unlock(folio);
 out_release:
 	folio_put(folio);
-	if (folio != swapcache && swapcache) {
+	if (folio != swapcache) {
 		folio_unlock(swapcache);
 		folio_put(swapcache);
 	}

-- 
2.51.2


