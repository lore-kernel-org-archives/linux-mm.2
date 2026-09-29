Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0157CA5FA7
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:54:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FBEC6B00A7; Tue, 29 Sep 2026 17:53:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AD8A6B00A9; Tue, 29 Sep 2026 17:53:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09B556B00AA; Tue, 29 Sep 2026 17:53:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CB7676B00A7
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:43 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 58FC7140618
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:43 +0000 (UTC)
X-FDA: 85268152326.20.C1EAA03
Received: from mail-dy1-f199.google.com (mail-dy1-f199.google.com [74.125.82.199])
	by imf20.hostedemail.com (Postfix) with ESMTP id 9C95E1C0009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YQNO/7Go";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3ZDO8agoKCBkC7AzNKz7H65DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--nilayvaish.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3ZDO8agoKCBkC7AzNKz7H65DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--nilayvaish.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718821;
	b=trmAgsngqE994+o88AeFTYsw82T1cvJLs869RNvqfNKMTj25HmiqIgkuTEkXsZiBQ5lLBc
	4jHq44aIFpX/iGn8orVpHk4lS9DAdRzEj+5PgfbdRYwjlgrxUSrNPmvM7X2cJRm8tp/UDM
	3GmbyWoB9K570N75w6L7KevkLYHxD9s=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="YQNO/7Go";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3ZDO8agoKCBkC7AzNKz7H65DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--nilayvaish.bounces.google.com designates 74.125.82.199 as permitted sender) smtp.mailfrom=3ZDO8agoKCBkC7AzNKz7H65DD5A3.1DBA7CJM-BB9Kz19.DG5@flex--nilayvaish.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RTMNyUVrpYZfptNKYYBniRNX5aVC7vTVEHYl81wiTKQ=;
	b=k8jRjXF3wsal75Zkf11Kxgqp2oVc8YNEaru9ZKDKs1ruRLf/4bi99gBhrNEKsAunU0AaKD
	4f04mC2IdfOQhfvwtaHrlF8hza+c7B/rjGNyOyU3SIajRl+L395dP/D8Ivm5o/sCocpPje
	BpZ1np8FTnjj0clpsj3dvbb7vBzRCOA=
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-34316295d86so8076333eec.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718820; x=1791323620; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RTMNyUVrpYZfptNKYYBniRNX5aVC7vTVEHYl81wiTKQ=;
        b=YQNO/7GoHuBnJmmcMlHKKLN9Fm4BytBz4AWmc5aWM5onDlGXG8fMmN7MnGOKOqWMBU
         fkVQR9NXxmubEYjG16sDWZncKn/8zw4cdGfCK2g9uxGutg/dOwYZccv8LVJJr9ttCOsY
         oqpGcN3wszDqtaPivHbfyzK1Ya9YZ/9FvO3WSoUXYNmUai9eIpHd4CrfCefJiY/Xtbc2
         1zOlMdXRCcgzG7YiCYWcC2tF6+npmVVmN7VQu7EuDSX5r/L8xnH53QzQR7KVeD/br7wz
         XHyELH2B7Qr4SI0W7WFy3KBWg+FQXnkCtovfNiGHSXHTIxameq5hq15c527tOEIPx/vr
         7NHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718820; x=1791323620;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RTMNyUVrpYZfptNKYYBniRNX5aVC7vTVEHYl81wiTKQ=;
        b=Y1M9Gbk7Jp1QPlkETsdVQimYF65pSYmrVaQKzEAYFzAI4b4HFb2pYa9Nh2/+ITMAkj
         Zrg/m4P+OOebGvDYXNEhaxQVTT0iekbOT8qtdf4TIVg0Lzx4NMpTYaCsS+MmbIaZQBan
         ReUQ44heLFWYMWWXAC+nMVH2+oW2hkh3L5Pyp+YBKO7NqY1obqBPPx9eys+vPN7ohyKo
         XzTu8V7xsZU9Ux0UIfZ+C9uRIJrVPFk4XCL9n/sCWNkLvT7Bo1mOxRygG7wi9AxsZvDK
         z5L+ofqwTY2W+1qy6JNetFbvrlcHwa46Ebp9x1ggQm/wvX2EHC+tC5UgPDwFdh3RA+MM
         PTmw==
X-Forwarded-Encrypted: i=1; AKwUvBxVCq0IuNsoFeIsf3hjUN9AkhqYXP8MaaWUR/FTOiFinAwEgT+aCYUnvt/Xbutkl8MPtQSS+/+80Q==@kvack.org
X-Gm-Message-State: AFuF++mt3+t84eRi60bhpqKc8CmJCHKhLv2y+DpWVVvhmr0KHlderBnW
	opUaCKy1ikJ9S55lyeZuRRnzYiyuB+3dX1WuXRcvcgEmj5olctlsXtDiZpJmWan3S+caA6ysI80
	aTc1a6yo3wFSZ44SvvKLVeg==
X-Received: from dlbem11.prod.google.com ([2002:a05:7022:100b:b0:14b:4891:4b9b])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701a:c909:b0:14a:725b:7b40 with SMTP id a92af1059eb24-14ca02946f6mr560218c88.44.1790718820169;
 Tue, 29 Sep 2026 14:53:40 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:52:06 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-16-nilayvaish@google.com>
Subject: [PATCH 15/15] mm: replace remaining &folio->page uses with
 folio_page() and helpers
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam06
X-Stat-Signature: j8uzifh8q3f14ufyikx3mrdkj5j1wg5h
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C95E1C0009
X-HE-Tag: 1790718821-571262
X-HE-Meta: U2FsdGVkX1+afX4TzCLdib/db9SpNmQ3xlFrZPGA2a1uV2/p+P3ShDlO+46WCHhCrnJ2AB29nPq3cpm696t1rIE17/SNlyKGdfjtE+dpdSXvdySkNU8oNHzAHz4p86YyIc7icatLMma2dTwrzVe8FrLp+a2YrzEt2tHf+irZa6QmTo05ifDF/MjF8eiI7ZNNyv97kZI5pr6CqVZejpYSxsgPLor5tZ1JCJNzRAryyJN1XGnFTtj47uVV3KZE7sFFcvhnOBexW2X6BUZfG+q0O1aLAaFoOm2tgBS0WKv+wJbvkN2m7kDgSV2gMwp6v06l7AH4yvcE7YJAWRUS3O3/ERYpDO/bjbkfj2Wj514+mVV5RsOssvjXBO6vUrDpP83Kc2wI5XonxyIINn5p4t39fHtXEJ2+5Ti+jpNdbN6BdpzyxF0zfLO59O/d9f262WcxHBtX8sdONsuegyNIRLd2KhTeTls5MK+MjKw4OZuynyCJo0b4IOASTJS1sXHEXxcdlyb+0Ys/jO18qOPqCxG6ovx90XU108EVs9A8iAObe6PfxNf+nc77wJ7Wnmvi+gyr27TMuJoxVSYs50+N2YqQHWeu2DJ+E0T0BK8bD+sfa8BIOnm06sHWKn7veCPPVyM/NucWmO1CTyNxIXwpfI7KisPBw9BVxRCPESvbt5sGlgYoFYtEZPOpFGtgefRuUYdLuKO9tOov9Jr2/S0ENoHspNBw7zZMzrc9WbMr3slz8KL6wCLK948MOo8PKQwYPt7O2WKwxKh74zrujT6Q9YI8NONAJWc9o9k71mkTywZ3KwxheqyYP+iCz4xDIS9UEISe3LOY/Bp7tBXtswtbFZqAhfMF5rtRbc+W1IAqqZ5ewNur6HNvItNZJjOm/l76Apjfy5i/sNYMrr6AyIOjmPgwIvc2CDQdAqk8cZUV8/1RA7hbC/Hh4q4VWVKLIKBRjj1zOPzUKFzmQAVaXyy1HEB
 pwey4xod
 Cdk8Nx8paH2SxQc3WLsMbtJTN5hTyEDzIZeVEc6ow3yOIpoTxOyPazafZU4x1A214hNFJ75ErmwTfdIZnseYHojGERcP2Eywn5eAZcGdU0bAN4sB5T94qK+7yXC4FsCbok0x8OrqCWZoZs0uPifwc/G+n3nrxPvCDv7GoGbvtV/K1hw7bNoJ+w81tRQM3qFM0oppcowBSsdpCG43/7ttU9wtCR8znf/Srh6yaHx+/SGfXS13kxBSj+gEUToBZrbStlXEjTWJq2RusEUv2f3lXnsEaeqCOOW7US2qQboW9lU9uiTS4lqeceohV1cGqAb4DTgkiktWuNhYvha/R3Fz3upfu/5R4IWdSLylUbp1kzgq3TLU7CvuODi5xchau5IQ3bu5LaA6A5Iidcpq3l+MxZ+aqBYbgsdu51SYQ/bLCQuHOfSYHHlTBV+uTZRZ+vVOhGhRYeJgGHy+d/dJZkzdDdltd3vX/5k/xWeMCQrvk0JAayzQV3vprq3koIOUOxQHFKBwqwsEE2sG2uLQHRK3xyQ6j/BPh20UxNjxHStqYyiehGXyikfRn7Jkohjutnc/a6+HHjhZE+5c6m3N2uJOvcF9uooSGYLqaagijlFD8vrHdzZeg3y6dN39prSPA0xIV5bnVSUcg67er9MR6+pQbEcF9IA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Convert the remaining &folio->page uses in mm/memory-failure.c,
mm/hwpoison-inject.c, mm/filemap.c, mm/gup_test.c, mm/memory_hotplug.c,
and mm/memremap.c to folio_page(folio, 0) (and folio_set_hwpoison() in
mf_generic_kill_procs()), and use ERR_CAST(folio) when returning an
error pointer as struct page * in do_read_cache_page() and
shmem_read_mapping_page_gfp().

In free_zone_device_folio() (mm/memremap.c), passing folio_page(folio, 0)
to wake_up_var() ensures the wake-up key continues to match the struct
page address that fs/dax.c waits on via ___wait_var_event(page, ...)
once struct folio is separated from struct page.

No functional change intended while struct folio overlays struct page.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/filemap.c         | 6 +++---
 mm/gup_test.c        | 6 ++++--
 mm/hwpoison-inject.c | 2 +-
 mm/memory-failure.c  | 8 ++++----
 mm/memory_hotplug.c  | 2 +-
 mm/memremap.c        | 2 +-
 mm/shmem.c           | 2 +-
 7 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index b74bc1e5015c..02e0c2af594c 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -156,7 +156,7 @@ static void filemap_unaccount_folio(struct address_space *mapping,
 	if (!IS_ENABLED(CONFIG_DEBUG_VM) && unlikely(folio_mapped(folio))) {
 		pr_alert("BUG: Bad page cache in process %s  pfn:%05lx\n",
 			 current->comm, folio_pfn(folio));
-		dump_page(&folio->page, "still mapped when deleted");
+		dump_page(folio_page(folio, 0), "still mapped when deleted");
 		dump_stack();
 		add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
 
@@ -3888,7 +3888,7 @@ static vm_fault_t filemap_map_order0_folio(struct vm_fault *vmf,
 		unsigned long *rss)
 {
 	vm_fault_t ret = 0;
-	struct page *page = &folio->page;
+	struct page *page = folio_page(folio, 0);
 
 	if (PageHWPoison(page))
 		goto out;
@@ -4239,7 +4239,7 @@ static struct page *do_read_cache_page(struct address_space *mapping,
 
 	folio = do_read_cache_folio(mapping, index, filler, file, gfp);
 	if (IS_ERR(folio))
-		return &folio->page;
+		return ERR_CAST(folio);
 	return folio_file_page(folio, index);
 }
 
diff --git a/mm/gup_test.c b/mm/gup_test.c
index ba74bf3f4104..337b58221c79 100644
--- a/mm/gup_test.c
+++ b/mm/gup_test.c
@@ -59,13 +59,15 @@ static void verify_dma_pinned(unsigned int cmd, struct page **pages,
 			if (WARN(!folio_maybe_dma_pinned(folio),
 				 "pages[%lu] is NOT dma-pinned\n", i)) {
 
-				dump_page(&folio->page, "gup_test failure");
+				dump_page(folio_page(folio, 0),
+					  "gup_test failure");
 				break;
 			} else if (cmd == PIN_LONGTERM_BENCHMARK &&
 				WARN(!folio_is_longterm_pinnable(folio),
 				     "pages[%lu] is NOT pinnable but pinned\n",
 				     i)) {
-				dump_page(&folio->page, "gup_test failure");
+				dump_page(folio_page(folio, 0),
+					  "gup_test failure");
 				break;
 			}
 		}
diff --git a/mm/hwpoison-inject.c b/mm/hwpoison-inject.c
index a11222572f97..127e5d75aa0d 100644
--- a/mm/hwpoison-inject.c
+++ b/mm/hwpoison-inject.c
@@ -131,7 +131,7 @@ static int hwpoison_inject(void *data, u64 val)
 	 * the targeted owner (or on a free page).
 	 * memory_failure() will redo the check reliably inside page lock.
 	 */
-	err = hwpoison_filter(&folio->page);
+	err = hwpoison_filter(folio_page(folio, 0));
 	if (err)
 		return 0;
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index 0c96eb511997..771a75eb5505 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -1400,7 +1400,7 @@ static int __get_hwpoison_page(struct page *page, unsigned long flags)
 	 * unsupported type of folio in order to reduce the risk of unexpected
 	 * races caused by taking a folio refcount.
 	 */
-	if (!HWPoisonHandlable(&folio->page, flags))
+	if (!HWPoisonHandlable(folio_page(folio, 0), flags))
 		return -EBUSY;
 
 	if (folio_try_get(folio)) {
@@ -1777,7 +1777,7 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	if (!cookie)
 		return -EBUSY;
 
-	if (hwpoison_filter(&folio->page)) {
+	if (hwpoison_filter(folio_page(folio, 0))) {
 		rc = -EOPNOTSUPP;
 		goto unlock;
 	}
@@ -1799,7 +1799,7 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	 * Use this flag as an indication that the dax page has been
 	 * remapped UC to prevent speculative consumption of poison.
 	 */
-	SetPageHWPoison(&folio->page);
+	folio_set_hwpoison(folio);
 
 	/*
 	 * Unlike System-RAM there is no possibility to swap in a
@@ -1808,7 +1808,7 @@ static int mf_generic_kill_procs(unsigned long long pfn, int flags,
 	 * SIGBUS (i.e. MF_MUST_KILL)
 	 */
 	flags |= MF_ACTION_REQUIRED | MF_MUST_KILL;
-	collect_procs(folio, &folio->page, &to_kill, true);
+	collect_procs(folio, folio_page(folio, 0), &to_kill, true);
 
 	unmap_and_kill(&to_kill, pfn, folio->mapping, folio->index, flags);
 unlock:
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 796af1028ee2..47bf3b5d3ff2 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -1952,7 +1952,7 @@ static void do_migrate_range(unsigned long start_pfn, unsigned long end_pfn)
 				if (__ratelimit(&migrate_rs)) {
 					pr_warn("migrating pfn %lx failed ret:%d\n",
 						folio_pfn(folio), ret);
-					dump_page(&folio->page,
+					dump_page(folio_page(folio, 0),
 						  "migration failure");
 				}
 			}
diff --git a/mm/memremap.c b/mm/memremap.c
index accba23aef28..70cfd3f05a25 100644
--- a/mm/memremap.c
+++ b/mm/memremap.c
@@ -467,7 +467,7 @@ void free_zone_device_folio(struct folio *folio)
 		break;
 
 	case MEMORY_DEVICE_FS_DAX:
-		wake_up_var(&folio->page);
+		wake_up_var(folio_page(folio, 0));
 		break;
 
 	case MEMORY_DEVICE_PCI_P2PDMA:
diff --git a/mm/shmem.c b/mm/shmem.c
index 07b2855dfb7b..1dca70978ac9 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -6195,7 +6195,7 @@ struct page *shmem_read_mapping_page_gfp(struct address_space *mapping,
 	struct page *page;
 
 	if (IS_ERR(folio))
-		return &folio->page;
+		return ERR_CAST(folio);
 
 	page = folio_file_page(folio, index);
 	if (PageHWPoison(page)) {
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


