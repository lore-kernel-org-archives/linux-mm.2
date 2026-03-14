Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F4CC105F7B0
	for <linux-mm@archiver.kernel.org>; Sat, 14 Mar 2026 09:06:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DEEFB6B0088; Sat, 14 Mar 2026 05:06:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D9C456B0089; Sat, 14 Mar 2026 05:06:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9E806B008A; Sat, 14 Mar 2026 05:06:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BC6CA6B0088
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 05:06:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 600841D0DB
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:06:09 +0000 (UTC)
X-FDA: 84544086858.08.198D217
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id A6EB01A0015
	for <linux-mm@kvack.org>; Sat, 14 Mar 2026 09:06:07 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0vYIYNN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773479167;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QkCimjeh/vtI6FJp+wpJJIqG3YJuOd+Kn2bwa/KyLEI=;
	b=RP+ZQZMOVNLk0S5trcPAcAjPZ5V6cVH+AkKfVgVfY+zFvDSx/oTH0R2bpwG/Z8nlDUVoOJ
	xzADajR/zP/xubQChwmLUD8WE3iDuayUU392v3Lk04JaJBuLqAYDVsSXVl8e8x8IfdM1Ig
	P2zKJTDg5wYJgmwyG8my/LxUdM+/ybE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k0vYIYNN;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773479167; a=rsa-sha256;
	cv=none;
	b=j7e6LQhjFi/cgrq6qjyrV3EwhraDbCDN6XkjTf4qdem4NYQh15aNnRV4fM2zEyQz3Xvjxq
	z/0SU9tnTxzroXOnDEZ/4YisQek7NCHYkC7NwZoXxYsEmQ9nM1jouXETipiRCwEbsvGAdm
	170yH7ZCbhdr2wH6OM2hnS3QoaI0kjE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 03CD46132E;
	Sat, 14 Mar 2026 09:06:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A7966C19423;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773479166;
	bh=k7MxutspFB0C8aBYZ+Cn6E/z5wK6f9LqrZ6dx5IdwE4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=k0vYIYNNUZszXtEF3c7cYvaTfOPFdhfJnGhWlah7FR6LcTBSE3Copuw1Ghl5mNgiT
	 BHLje0y3QWpPBe8L/hxpHHQnx2v7QokXelxssmVQs7+INzIdYkDe01L/+XpWHV6nZ8
	 GQXjQqDN1W+rek69CgY3TdkUyFCND5eDGdrqHQSYuyGgypuG3LxnkVbI5tLTYC6JU9
	 CLFJ+q0wi6gjlMJh/XO+21hNv0Mk/Lk4vmb5DzFqcIyR78CFIm3XDe+yO3ztXCPAqR
	 jIManz8ibGa2fCMBZyVgExYgmsJKaXviz2ZReZJHHJD0glahLI44bsfGAAlI8v20kL
	 nH2vdPBpgx7Qw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96A8B106ACF9;
	Sat, 14 Mar 2026 09:06:06 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 14 Mar 2026 14:34:13 +0530
Subject: [PATCH v4 1/3] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260314-vmalloc-shrink-v4-1-c1e2e0bb5455@zohomail.in>
References: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
In-Reply-To: <20260314-vmalloc-shrink-v4-0-c1e2e0bb5455@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773479164; l=2682;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=Y7LaORkgehK4lKdbYmYreDeAD1S2R1PpyepoUGhj4EQ=;
 b=xQ9l8MuWzhTsdTNLyNVGABBwcIWNRVDpsUQH14mvklMOUh9yd46JjQO6KBF9FtlZ6okPsu0kW
 czUwPJswlxfB04TFAQkB2OrJh05VSSHcWuhq0GVTrJEWsO/lg77OPZ8
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A6EB01A0015
X-Stat-Signature: utfmeow1pop5t8ym77mr4yzir3wiefi9
X-Rspam-User: 
X-HE-Tag: 1773479167-885250
X-HE-Meta: U2FsdGVkX1+6MPjQELVnL9s3QmTzQ5Ha2XCXulcEIVnBGdbEJZR/ntTgjF3HzOWqW5N3rp4V1w4UbDAg5dD49RM504DXO/+MwTLFioZdOrcP38eWqJa0HpHxN3Vwwzrz6QEMx1+0z8GKOMsgHqNAgBCT0DFTFQDmJ7+S52kx+8Xf1mMp359h2QyFz+JuVm4weq5vWbN+D+j09fk5GltOhQufyk4sXksrE45rrQoK+rtPDBLqSaDLEnpcItkvmrCR9sn9ppyvT5UE/FsXoRM1IKzWW/aGkAmrf6XKyTeHv4btFpWvigEYMSVkXPq6t6GWthAk6neN8x+kslXgnNRt1hZugcYGIZaTBJChEx5cxbbFXgs01cfgbrfUCzsu3/pw0Ufv8ERQQyLmuH/mC8XDusiC2JObfYIkHBzOt42cqyCXvQwIR3551+t0jLw3Lrth/+kTsG7VvlQPluDJ9ZZFi3119Y0OGxcjyZX2XOfN6SgVUMScs4LOuqGUpbCAfGDWmoZinbKkojJuyk1fNf94kY6Gn2oNfzcclCbPk/DGUubu40LGwqeCRiZKDgaQD2zZzod37apZkqjMngm3VBh0S/E/RmobpK85v/A91mPFGp8My0bKa40THwHMAUbmSRGXpd1IDTUcj21ux4NJeJzl0W3YLhhzgiqYSTCV+o6KLUQe2ltYom2n1RS2urqrFkRKziC0E17d8ElqMpVmV3GmKUHbu7SBczC/rcnoOHROfkFAOdn/D7gn17vPgbj0RXdGhP41vIWRLcLb9T26S1oqZp6rvjDsY9lDOjk6AhoNPu4mQIBgtuITVY4Sq6y0NCKZKieLAnjzQRwVyheZhKih6u4Il83fvJL0fQ42xTKAqRKLZ3lXFI3EbAJOhh7zWoAYZAf5C0vAhMPSJ3rHSqAWiv00fxAS9T/ADQtdsjRb/CO1AFfI4Yjmpz71rvccZrGuxcl84q58rOqba9koyzC
 lnv/k683
 LujmqmaH8eboEMUCieZtUW7vN5VExKT14yUnQk3KhloYHk0v5d0QtB/U+QzkeurebrS5SMzavvehmoUaEK9dILZzc4Sj/HfZQwwrmS3FxuWgxRf4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract the page-freeing loop and NR_VMALLOC stat accounting from
vfree() into a reusable vm_area_free_pages() helper. The helper operates
on a range [start, end) of pages from a vm_struct, making it suitable
for both full free (vfree) and partial free (upcoming vrealloc shrink).

Freed page pointers in vm->pages[] are set to NULL to prevent stale
references when the vm_struct outlives the free (as in vrealloc shrink).

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a..b29bf58c0e3f 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,38 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * vm_area_free_pages - free a range of pages from a vmalloc allocation
+ * @vm: the vm_struct containing the pages
+ * @start: first page index to free (inclusive)
+ * @end: last page index to free (exclusive)
+ *
+ * Free pages [start, end) updating NR_VMALLOC stat accounting.
+ * Freed vm->pages[] entries are set to NULL.
+ * Caller is responsible for unmapping (vunmap_range) and KASAN
+ * poisoning before calling this.
+ */
+static void vm_area_free_pages(struct vm_struct *vm, unsigned int start,
+			       unsigned int end)
+{
+	unsigned int i;
+
+	for (i = start; i < end; i++) {
+		struct page *page = vm->pages[i];
+
+		BUG_ON(!page);
+		/*
+		 * High-order allocs for huge vmallocs are split, so
+		 * can be freed as an array of order-0 allocations
+		 */
+		if (!(vm->flags & VM_MAP_PUT_PAGES))
+			mod_lruvec_page_state(page, NR_VMALLOC, -1);
+		__free_page(page);
+		vm->pages[i] = NULL;
+		cond_resched();
+	}
+}
+
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -3436,7 +3468,6 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3459,19 +3490,7 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	for (i = 0; i < vm->nr_pages; i++) {
-		struct page *page = vm->pages[i];
-
-		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		if (!(vm->flags & VM_MAP_PUT_PAGES))
-			mod_lruvec_page_state(page, NR_VMALLOC, -1);
-		__free_page(page);
-		cond_resched();
-	}
+	vm_area_free_pages(vm, 0, vm->nr_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }

-- 
2.43.0



