Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67647EF8FEE
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 14:53:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B3D136B0093; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0F956B008A; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C47C6B008A; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8BF9D6B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2DF9F1A0385
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:53:32 +0000 (UTC)
X-FDA: 84508674264.20.753532A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4A6504000E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:53:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2f1NtDH;
	spf=pass (imf04.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772636010;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=geD5pFedE+XojrU9Qz+TnAtPxuCGSr7PiZpl+rc3xlE=;
	b=ARR36KolgQiaJBtjbDVbbngS4vpOp+WDg7PP61r8Y9olG9Hsyko4Bc9yLFGZV6a5lYEJOX
	ZusPki/nG2MhU8Gxp17OwzVYchShy7I4kgZW3XGEROVbevRey9uHIwzYvTRRLOS2dJ4H3S
	QvaC5aflLQgtCvxEst1G9mPs7AeA6RY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772636010; a=rsa-sha256;
	cv=none;
	b=IDvzHObwgjLiXV7TbNUL/ydLx9+O281v4cGHkEHe9ypziZz3ivyTQOucniplczdIabtRfc
	ngJkmG84i4DbSZLbhk+I/ae/okM61oRRvEm0MKL19jt45X82fByEwG7byRmg5W0h4a0W1W
	prQsWb1lTl8fn4Z2dMKYbh+js8uBfu0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L2f1NtDH;
	spf=pass (imf04.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B2B6F6013C;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 62D1FC2BC87;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772636009;
	bh=Wa4JBE1IYU7JKwjDkn6HXyP6M9ZwBaG9oz9xsBPZiG8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=L2f1NtDHhUjG3fDL1nzaEkzX7Gn1pIidsT4YvlLNlDf/p/aVluQUS0kpY+okMw9ly
	 1MBMyjbOyJU3JfYBa6AL+MPGXeZUbIc21Rbnfpr1MakG8uDszXERGm+vSSZdKeCVHK
	 Q9Hjm+zHSuF11VmoAkQ/0Uw9sNhHHWpmBXTjJ8TW95clSv2gN+0r9XWsi74osJDkfX
	 Yr/0W68yeey2k8O0koD4tCsu5w2HHa1ZX3o/55OqWlTulVJUsa9/lDeCxJm9jhkfu+
	 dpQ0DhA8VrwISyKfuZCqUwU1QkBWy3aK4Lv4qgqQBVnGK0i7V8y8BnYYXCjaDG9puM
	 aRAqI0agxs1SQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F25CEF8FEE;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Wed, 04 Mar 2026 20:23:15 +0530
Subject: [PATCH v2 1/2] mm/vmalloc: extract vmalloc_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-vmalloc-shrink-v2-1-28c291d60100@zohomail.in>
References: <20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in>
In-Reply-To: <20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772636006; l=2379;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=ylDdrWHdpgAIPnTMbUkuZf3YssBZgAmCXof5K8bWIJQ=;
 b=Cc1LRtSDOXj7IWYWNC3yabvfhCMK2bqJRbdVi4kWl/10umyvVSpnr2BPzyCG79sYsIj4j9yzJ
 cdwhX88SsHnDL55LPD8VYSLaL5a3QqWyOmKCG0ky4d8TOq5mXOyK8k6
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A6504000E
X-Stat-Signature: 34pp5c33e6rqnzjwsybah68pmo5ooqqq
X-HE-Tag: 1772636010-685709
X-HE-Meta: U2FsdGVkX1915aJ8IuCVVT/6NNwmHw714eTYa4pcn+Dcbyw4n5JeH/aFNt1MhOCZzDCl79aQrkqTEc5cZYHZxXivuw+atZPwCB0KzdszGWEhoxdN1Nipb/NYMHZbK1nAK5z1Y11a4n+RpU5oP3dqD+05W3g17LZXt5njPodOdVHyK2lfR7WPtkmd1m2+M+pBMKqxTsmrXIsUYGGldpby9aUA8xALqWVymNjoO2ehkimzp/jVo0WgKGCOIWjmukEF6RX3zmBVxX+V3no82JiBJC1D3y3KBfGsbArPUtsrj7PUzIwP7vj16uwwR+8ZH2gV1+Qv1FEQD1+a/YXxzo1i9KuR8MfGSPDfYmtrTheBQafmEqSRMVVrVMQW1Vda7xV8VH87HPtycHWnnte2jotC/xUWbxrkZPNFNjyPp5VjFWKQvE9bGNmsmQgNpiOh+98kSEg5pPKQbblCu1/SOu6a1S9KAc3KMXbiChToQRk0N0lrOL1cdFWuG8Fie34Kqtw7jkXvYdTn1cLLnKhee0+bPivvEWaXsICaiGqzrz/A5PxbsgZCcw/oo9184+WfNCrqnLE1zLoE8E6eSiAHz4xiOCzpoYX9rfYm8jRd1ObFuWR5JmFQaExIyAlVgJx76O+XLOy3RBhB5HVQEntT/aXr2LNCMuAGxetVGOinrkCOw43+X7mGrOhTL5XLIEC4dOjQZkMwZzWktRysawZzR5YCmAQz+3oE2ZTHnnkqVQV4uiGT5n715W7kIwMBHy2aiWWym2WCYQTBcPk7drXLNdNQUURIj9HRVIMo0d4mqEutNcW8+U4LZTAcDd/Ze/t2N+VpequYORDJWFp6oCHgiVXozuL1euPAv6FC8gFpAP1yfkTCf5e0lwkITW474Zzo6e1sNzeHHKRnc8kUFCtpjEH6DgfvCdkWXigJMoJoYDJoCP7WpVyzxwQou2fPMEck2lrsWou3RuwYb0ATsgwzHN5
 xS/y0r1L
 h8yIak1UjfIL4gK7TLeLKcpNJS8zZB+Mv57zPCc4i2g2AarifUvOjw4AtSVf1/zVkzCXAvVVa9oy/d9U8A51zKPiVG2gPi3Z+6UwPxaqAEpizfzzGGiewVS5mvh93xFuPPQidBCtKlQBw/p6ICQigVXBRw8CGoaCot5J3rn1lLvDbptzy1j4ByIxvQD6STf7uhrngyHW1cqWtTYbI10aOSGRzzFTzxsGdQtRpBVNs+jecO/Wfzdej6jfJ7V6FpZc3WBo/S25DUqztjJP2wFK877PDsCDEdqY1Op9Jpuf6X6svpNdcm1hrWvKGKqudFn+RSqZsoO9dfmPj6dqkyl0YfsPi7aGTOU/BCQHwgLePYjbwI4yjA4zSlw4j0PNidJSYhWJRvChynQ/6ozgMaP9lz2qS7OjjQUkbud38dHRcZT9XkKWh3TgK+YShHKqybLjIkiSJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract the page-freeing loop and NR_VMALLOC stat accounting from
vfree() into a reusable vmalloc_free_pages() helper. The helper operates
on a range [start, end) of pages from a vm_struct, making it suitable
for both full free (vfree) and partial free (upcoming vrealloc shrink).

No functional change.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 42 ++++++++++++++++++++++++++++--------------
 1 file changed, 28 insertions(+), 14 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index c607307c657a..e2aef0a79f2e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,32 @@ void vfree_atomic(const void *addr)
 		schedule_work(&p->wq);
 }
 
+/*
+ * vmalloc_free_pages - free a range of pages from a vmalloc allocation
+ * @vm: the vm_struct containing the pages
+ * @start: first page index to free (inclusive)
+ * @end: last page index to free (exclusive)
+ *
+ * Free pages [start, end) updating NR_VMALLOC stat accounting.
+ * Caller is responsible for unmapping (vunmap_range) and KASAN
+ * poisoning before calling this.
+ */
+static void vmalloc_free_pages(struct vm_struct *vm, unsigned int start,
+			       unsigned int end)
+{
+	unsigned int i;
+
+	for (i = start; i < end; i++) {
+		struct page *page = vm->pages[i];
+
+		BUG_ON(!page);
+		if (!(vm->flags & VM_MAP_PUT_PAGES))
+			mod_lruvec_page_state(page, NR_VMALLOC, -1);
+		__free_page(page);
+		cond_resched();
+	}
+}
+
 /**
  * vfree - Release memory allocated by vmalloc()
  * @addr:  Memory base address
@@ -3436,7 +3462,6 @@ void vfree_atomic(const void *addr)
 void vfree(const void *addr)
 {
 	struct vm_struct *vm;
-	int i;
 
 	if (unlikely(in_interrupt())) {
 		vfree_atomic(addr);
@@ -3459,19 +3484,8 @@ void vfree(const void *addr)
 
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
+	if (vm->nr_pages)
+		vmalloc_free_pages(vm, 0, vm->nr_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }

-- 
2.43.0



