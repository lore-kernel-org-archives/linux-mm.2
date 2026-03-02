Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A6AEA4E04
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 13:57:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9A3B6B008A; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4D546B0089; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4F866B0092; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A58E66B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6C4341B6BD8
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:57:40 +0000 (UTC)
X-FDA: 84501275880.12.9F3AD26
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 5F3FC2000D
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:57:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OVT6eiUl;
	spf=pass (imf13.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772459858;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fNlVsgObTwZBUgq90FFSfYVDvAgRtMA6jbnDHhobKIE=;
	b=bt+RWb10O4+WNhzMDtzNwHPZ9WXfpNtFIXiw/RiRTvbhfYPr2d4oHjZkvesn0OwyP4KHiR
	p9O/PcdAtJv1MXLUw9GDXolsh6d/bqzz7/+NSGiLwRh5xEeNTJJQLIfAP0VfW6o+dgdZXX
	ZB2HL7lOZTLoojCB3WotalwS7AojYJQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OVT6eiUl;
	spf=pass (imf13.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772459858; a=rsa-sha256;
	cv=none;
	b=LHj2wJkRHc/43Ji5VjXc97po7MyBl2RD5A5TMolm1bnbBQgywqKO0CMgR3RzYCKvuMLjiU
	ZG89q5goJbg74E2Bs7THGB4dsXzwjgOywi+A24J7HOzP4xcoDzzIM4FDtZTN5SBzh/1NEd
	ahP9wRp1IwGJJh22zjrP8jn0W/dqUtk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AD2B43408;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A41DC2BC87;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772459857;
	bh=SGZI8pDW0epe37A1Z7dyf0Tg/40E/cxPxi86tx3hh/A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=OVT6eiUl3Oy/gfAiLymmF7YVs/tm6NZ6ASwXX2fWqmL7s+zWKjd549IuLenZGbrSo
	 YLo/esTjH/fAigYX47zwplJr7Kdkt+wFmX5f/2vUGcC7N8XIaIYjNWjkDupUwKB0O9
	 tZvWSgdM5X7mLGNPrrdbaWqAnpKi4N4g+pDjVCMgb5qWmmY6nmgPaVKQ5x0jjrwNtW
	 34xn9ZGmuggpZyC9OVd9nMh0jcR7xXGk2i3pxaVv9S1WlelmUIw610+DzqOlJ+ijbv
	 3j9QNiJ0FfOFRL4wMooYRumNLqYe+5diTiTmRg3AShzkInFJLHG2H8uX0FeokyDLc1
	 wgQVz0UgjqMVQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 263F3EA4E04;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 02 Mar 2026 19:27:11 +0530
Subject: [PATCH 1/2] mm/vmalloc: extract vmalloc_free_pages() helper from
 vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-vmalloc-shrink-v1-1-46deff465b7e@zohomail.in>
References: <20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in>
In-Reply-To: <20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772459853; l=2751;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=0JaRY63WuGpryYiSzUoBhSyJJKl7JuNe9P31f6tdjtc=;
 b=hWTwNZvKyvuYQpyWQFxgnjJGMxbWDPnuQ7m7FkLTfXN+BeWu1g4CHLZFsNnvu45DMMwYVa3qT
 pWbsHO4Vr70APHUiO3ECVzEapWycFN5r8gTidioHz35BeGbPDDGK3E2
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Stat-Signature: 917y9mgpnfiwjrza9c31amk5ybyx39z7
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 5F3FC2000D
X-HE-Tag: 1772459858-600275
X-HE-Meta: U2FsdGVkX18bL8v6EkRhyC46D5qKU0Vpi4m4WYvcqWu9XS9Kw+wQaZcLDPht7gsVlQpKkHBWbiFiuQ8yvHH1micIyIYgybQl3WR13ljxcbaX7a5QP7TG2ZRc5wvwAFpg5mleRf3uHaW9Db5sMb8gs3Vwl+1v9DJ4T4yMjZ4xgEfaBMf28HLWl/2NkEbtq0BbwWx1b9QIk2lT7M1/dXcLh6JWac+5R567IS/3rK8FFycqpJO9jsiezVRD3z52klfr1DXvGstOncyJa43L/q7vYUfbhpkQlUQWGyqip4jLgW4GwM0D3EqVslZ/lnhAhca3DLiOjEr4iMNc18uSIqOY97HCYYUUZeYT978LAzbgqAioynUBJMmEWu5O/JL3YhgnlOnRtl6l9UOWg0k5QBExopfNpdSguABILKlWyt2OJpyRH3cp/OYUrSqxQX/ZLHcruqH/4Sf+LnQ8kSftGTbOWhCbvp5A1Q+BVfsczkb7KAq86ajTEzrAiul4RGNy0yyaSizQ1J3Y4kbkyzg6ciLFSOccS0HwtcVEfUOQ3xg2z4cCIpz3jaPRHa47+JVUSi8A1s/ppBFAjb+prwwB2m8FIG5CwEvfcp2aMG/ghufxRrJqOHfDDePKQ2xwk0vhVNv37/3Y/x1BBc+g2j5m0FzuWYOzLktVTRiuOt0jp7QE4whzRkUDUvAgveVJ8JJZ6Q74S0KQSOVYLseWWhLFX9fLBwcf3aJAeMPZu+oYIsSe5md/TTigxXcy+DFwDodqFTXSgrNsfrOfLs7d9PhZEJAQJx2g3rsOs6Ulk8kgWOnNwo2PTRmgG3JsynXeHRnYe5lw5ipGIP86BltK94jVMIlwcVqT75ozMHwAxgZotA6iDHqF4C8yXRFDwqsCrsCK3JBkAT4LqgFvAki0+1bEYaSx4iRsxnKlEWj4KeMPj3eOIr6qwn+CiSdTTC/hFWsunFlkBxMxnOqBho61eh3um9B
 7zRu2OuF
 B3izsIHxhflCB5KG73UKiBTzVBkikrTp+a/cSzpmoL7LhXzLzSDbIUBMnT8dRYiqQSucsirKvl+7dh53Ytd9WfahwLhbvS01JM/S1bgfEKwiRN1E8ZRT/lE/3AqPJgdA45yZdX3kRC4nwr513t09VMdTiY4sOj22oDi75xzm6qFNvsIvObj/BPwz16807ZbXjy1yP7FRUuHSqhbFAUjd7FbzUZoNCg8Qb1n6JnRuz+rYAVjCYJQjkR79ScKegXFRrwweJib8w7dSDWtiPd3tvyVeykQrTuKw/QR78zkzGwZYpQD0xclzIVE7kgvS7awL28WgdpUWPKMfSWEj9FYLU/7VJtVjUOR/EA2eUXlP4mGuswfJxKmQnX5I1OIFio56FV99CTMZa5VjMXe3Loc4/EnR3yQcvXBgaQ9gj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract the page-freeing loop, memcg accounting, and nr_vmalloc_pages
update from vfree() into a reusable vmalloc_free_pages() helper. The
helper operates on a range [start, end) of pages from a vm_struct,
making it suitable for both full free (vfree) and partial free (upcoming
vrealloc shrink).

No functional change.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 48 +++++++++++++++++++++++++++++++-----------------
 1 file changed, 31 insertions(+), 17 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 628f96e83b118..54e76a47e9957 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3409,6 +3409,35 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * vmalloc_free_pages - free a range of pages from a vmalloc allocation
+ * @vm: the vm_struct containing the pages
+ * @start: first page index to free (inclusive)
+ * @end: last page index to free (exclusive)
+ *
+ * Free pages [start, end) updating memcg accounting and the global
+ * nr_vmalloc_pages counter. Caller is responsible for unmapping
+ * (vunmap_range) and KASAN poisoning before calling this.
+ */
+static void vmalloc_free_pages(struct vm_struct *vm,
+			       unsigned int start, unsigned int end)
+{
+	unsigned int i;
+	unsigned int nr = end - start;
+
+	if (!(vm->flags & VM_MAP_PUT_PAGES))
+		mod_memcg_page_state(vm->pages[start], MEMCG_VMALLOC, -nr);
+
+	for (i = start; i < end; i++) {
+		BUG_ON(!vm->pages[i]);
+		__free_page(vm->pages[i]);
+		cond_resched();
+	}
+
+	if (!(vm->flags & VM_MAP_PUT_PAGES))
+		atomic_long_sub(nr, &nr_vmalloc_pages);
+}
+
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -3429,7 +3458,6 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3452,22 +3480,8 @@ void vfree(const void *addr)
 
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
-	/* All pages of vm should be charged to same memcg, so use first one. */
-	if (vm->nr_pages && !(vm->flags & VM_MAP_PUT_PAGES))
-		mod_memcg_page_state(vm->pages[0], MEMCG_VMALLOC, -vm->nr_pages);
-	for (i = 0; i < vm->nr_pages; i++) {
-		struct page *page = vm->pages[i];
-
-		BUG_ON(!page);
-		/*
-		 * High-order allocs for huge vmallocs are split, so
-		 * can be freed as an array of order-0 allocations
-		 */
-		__free_page(page);
-		cond_resched();
-	}
-	if (!(vm->flags & VM_MAP_PUT_PAGES))
-		atomic_long_sub(vm->nr_pages, &nr_vmalloc_pages);
+	if (vm->nr_pages)
+		vmalloc_free_pages(vm, 0, vm->nr_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }

-- 
2.43.0



