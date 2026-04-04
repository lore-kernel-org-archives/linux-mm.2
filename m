Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E646AE88D8F
	for <linux-mm@archiver.kernel.org>; Sat,  4 Apr 2026 08:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A70676B0005; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F12F6B0092; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86A8A6B008A; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 67E316B0089
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 04:37:19 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2A84A140818
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:19 +0000 (UTC)
X-FDA: 84620218998.05.CE5F4F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1B52D40008
	for <linux-mm@kvack.org>; Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HOIEi3IQ;
	spf=pass (imf11.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775291837;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmD1qHfEXD5YSH0YNPyYAJe/x2iOX8MY2YqXIEBxF7w=;
	b=vJpOMcNlcWKSC/ia9BBXLTAuWAk/KOcb67e901moq+nPbeMcc5JoM2HF/nMtsSm98BBUKg
	zxNKBYNyrRkJkVB4LcGfTz0KpuOTtdxDARdAnAJNob4N0fYRJnAdgaOpIwNuG8u3gpef3W
	UGwiqXig3CWOhCjYrrNRUwis1nh651w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775291837; a=rsa-sha256;
	cv=none;
	b=E1/v9t4WRcy4oXISpPqM04ixQs/Qclsrw8vZxpCaZPDM62/uGgFpeavgeb5tAmw1atV8TZ
	t8GcrFpEcsjWh2Uxt7jRPZmHzhIW5H0B7dLfKv9ggkqWyum/LtGDlKj141J1w9sWBCkU28
	5RB/SePgOFZ/I9Km35mq6K0IN1qx85I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HOIEi3IQ;
	spf=pass (imf11.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 06D6C4349C;
	Sat,  4 Apr 2026 08:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D2A40C19425;
	Sat,  4 Apr 2026 08:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775291835;
	bh=16rkqI0szlH/LFm5GEEQXbW6/vo6EV3zeZslKn4GxMw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=HOIEi3IQDZJ3QaHo0xfDBufFrmxxYyl4st7eaxg7Fi7tVi4tuJ0BIOQEy2P25tcXp
	 RaEjO88jKIhSMCywmyZ9ujyiL7BlR2bcXZMdJtqI0Zt1HBpPdG6uXG++FHwVm4O+KF
	 pZ3joprrM9cIR8iQ396N/cGWCH1NC93aWNbNfx3oZKjH7zmk3iqeWahqbkOGdwPKio
	 QJvG5D+9qu350tMSHYiyiLQWwN9JfyWbnICj2p0pNBHvTKlbjgAChw2AqUTFvNDyqI
	 Vbvkr15+4/Qa1Mc5QNQU8wBTO9AW4EATPRjc5gO4NvBUBsBve+7ohXs5NIZlPbZQpt
	 bkUkkbKpwMFRg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C14C1E88D8F;
	Sat,  4 Apr 2026 08:37:15 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Sat, 04 Apr 2026 14:06:57 +0530
Subject: [PATCH v10 1/4] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260404-vmalloc-shrink-v10-1-335759165dfa@zohomail.in>
References: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
In-Reply-To: <20260404-vmalloc-shrink-v10-0-335759165dfa@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1775291829; l=2828;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=pPxio16sTZmRdQnFJiC4z+Co3PLVcVoIySf6x2/MXmo=;
 b=h1QBFXl+j95owXc6zAb1hldqce0tKV3luXhiWMIzcDI39Tj65UEqoVIriqEqgi/XZx8nVxDbW
 qsiV7AnmE+jBQaHWluQjOueqWKM8ZPxO37k9opPAdhZ+l6MXyhGNf19
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 1B52D40008
X-Stat-Signature: 3apxs5opwrzrxk8ybuw5xretodtdqz3g
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775291836-755584
X-HE-Meta: U2FsdGVkX1+8lVyLcGKc5kiAgSG6fdhWNZHY1CgN/+KW7LYzCtsPvEJp62YkaSr+AJAWPUN0SRlisCsl1C/e04fl+2yS3vG0gfhNYWY06y6Io9a5bMfhO2CtjZklE3uGEq/UqpBiBipxkGRtqwZ8Nv1zjSB08BsxUNM7WjV+PGldb/VYM5tl9L69/9aVoaGv5KQfp/OHRMvpZpy/VOSMnsk5LKUC0V+I5MBoB8ysqYcz5nfp1AxdU6QhmjxssegYLfsqDF0+oY0XofQCSkuFqCL4hd67hyh1udpLa7j+VBiJj50erxr5RNSmbPNuTmvRZk/whoir6CwyCPo2D2LlMitSWpH4cn8e8d7noaL3BlMpavFdiTGzeBJ1nk18GvS4Y6xgLO8ljZa/bzgkJsqckj7suMrjNbO4bSvztbD/jfFaNFGbDBO1Cqfe/YjRp/18ONjtppUkCVyqwzSowbuucNIsqSEvjnqg3m2JAzG/07Iu4KhxR4LM6Cw6BtlWAOlvC0xYa0QSBZKY+0NCgSiHn39dsCQuAfmZK8P0gJ5nNloWNFc1VWB9KxBg7N3wX01Xj1wzNj8IEH9pBESHIzFFplOcQA/ndVEqhEiGQyVitCghf/WRBmLfSGNeo3Ik36mAddFZa+paFyHIbK+ZlfT/dTUnMaULuj6wMRSdbBPrifo+IYvNk+tD8hH5H9Li3bzh5XbA9bB/bP6K1dHry2TTKKn2O8eHVeJ5fjLVoCJofK2pJDhMc+JiWXC26EZdFHHgzSAMsrtcLp8BJ1xsF4MDkJCloulXj+HenXPQM0esSCIvqzWAtmz4qSqlv2Ou/1oi+ePVQlLiMBJQYgshSqRvuDZO8fM86T7bcRnssYfhFyTT033AWFTTadCHE/jdpDnzYoChCK/PhlmvDuQf57WQSe93e6qO3WpEKV6RT45IpcfZiTuuwsSHq8LV/jNJ1u40pn/Qu/F0qw52IMKAFTH
 mISXEXFO
 VcTPFkadiKFfMR4zOk3Qjlng8qQOoSEWaSZxnW3Z1Um6v5TqOV2r6Y9VaLOhII4h5sIEYkYh6Kc6pSqSIUPCgdn+FNQmrkQK/k5gk4Y3a4gX1uLPOgxUcPhYT8VGgXYlbJIW26jK8uc6g8i9Gy1YN9S40qvD3kpC0Zna2J1YrYmNZEqLqGth8WK+M+q5v5mJzSOYr1uW2orMpDUsTS15hrSGl/WxXdYsKZtH2l8UFWuOFC9+idMlA8S6SMnRWaqJik2MPHv1jeGd49t8SUhxJHqmNwOjp6AN9jvQjeoCgN82Dk2sZgNtLw+RX3xyoW9m42oQgllqpt4A9be5KuwguY+Vvyq9bg5NQd+FFvdjNx6ChS001oo/2dN13uf+39v6ieKGEkJAO0YLa6PdSVO40GIHokh1jOzBkzyu0hLpNcMHntHo5xp36g0Yw9a4XUx7RRuP9eR9kpJijZtk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract the page-freeing loop and NR_VMALLOC stat accounting from
vfree() into a reusable vm_area_free_pages() helper. The helper operates
on a range [start_idx, end_idx) of pages from a vm_struct, making it
suitable for both full free (vfree) and partial free (upcoming vrealloc
shrink).

Freed page pointers in vm->pages[] are set to NULL to prevent stale
references when the vm_struct outlives the free (as in vrealloc shrink).

Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 47 +++++++++++++++++++++++++++++++++--------------
 1 file changed, 33 insertions(+), 14 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b31b208f6ecb..8dd7df79c5c5 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,38 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * vm_area_free_pages - free a range of pages from a vmalloc allocation
+ * @vm: the vm_struct containing the pages
+ * @start_idx: first page index to free (inclusive)
+ * @end_idx: last page index to free (exclusive)
+ *
+ * Free pages [start_idx, end_idx) updating NR_VMALLOC stat accounting.
+ * Freed vm->pages[] entries are set to NULL.
+ * Caller is responsible for unmapping (vunmap_range) and KASAN
+ * poisoning before calling this.
+ */
+static void vm_area_free_pages(struct vm_struct *vm, unsigned int start_idx,
+			       unsigned int end_idx)
+{
+	unsigned int i;
+
+	for (i = start_idx; i < end_idx; i++) {
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



