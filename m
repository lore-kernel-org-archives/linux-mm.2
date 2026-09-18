Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71C5CC982D9
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 10:50:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24A186B008A; Fri, 18 Sep 2026 06:50:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FA926B008C; Fri, 18 Sep 2026 06:50:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111556B0092; Fri, 18 Sep 2026 06:50:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DE50E6B008A
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 06:50:18 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 59299802F6
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:50:18 +0000 (UTC)
X-FDA: 85226563716.21.E355478
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id 90949A0002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 10:50:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=jSHDxFpw;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QIBQIYei;
	spf=pass (imf15.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789728616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=x+AK/cyAK7BD5zWC00AErf3bb31h0dns5sqtSU4SO8Q=;
	b=lc2rDmLs9QecsOb5RkvujVg5V8jBYsT5Zi1rglEIFVZ6si7/bi9QI5YPkSC/ODengpCZEr
	c8EJ1h5WeQ3gumVCNYjI6jmEffXYoAqJpBzM4NkViM8x0OZRbqh7+KvhW0dSRxf4ntuuPy
	V9Ygi9TtBtLkmOGk8D+YIX5JMsI9VUw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789728616;
	b=a+DEc9B3+kJ5WONRKlhi7rKYXMAuqjuQGCbDigAJ0eLVYdNSneCUTSVLft9yjLKt32mwZ0
	iBCUFPjtuYIDOMg4PxjFKFA05ti/06lSG9kv6TZko1CimW5CyZs9tJ231WshK7v3mbkBE5
	DtU3KyHhqMROTP6+WL0z3gABgiMQmgs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=jSHDxFpw;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=QIBQIYei;
	spf=pass (imf15.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Fri, 18 Sep 2026 12:50:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1789728614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=x+AK/cyAK7BD5zWC00AErf3bb31h0dns5sqtSU4SO8Q=;
	b=jSHDxFpw5GuPTQptjaLsDxARR4cMBxiLiuhj9Pt05U8JBzgqTJ980ZWmCskaXAi/6mxNAh
	mUfnzpxAWXK50l/Bua1DbHTHKAi4AxyECOFJleWoqT9pFjskJrhb6aKtOCZdi4SpxzvBwx
	vKHgjlOQPxpMPqobZr5REZgwVO02NLI/W3NJUiw9or2Wm8JbxTjIDtTDqDl4mtCDkNfPQC
	6StHwxGYH7aIXjH9rxCYE6dNbYYHnwai154abRtS9DwNH1e2ujihncwKKrtQIglH7oBK7+
	MKB0XuW27DPSK0/fROUiJ7fziv9wkFHT5sVMbE6cNRL3kf3NdQchoZAkDlKdKw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1789728614;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=x+AK/cyAK7BD5zWC00AErf3bb31h0dns5sqtSU4SO8Q=;
	b=QIBQIYeiLUEWArAAPK9ly0AV1ZjOYvoAP0oVWgXdLrbb1wt7bu+3lbWBobzhPaWiMz4IDL
	L3IPTiHsUSE4kCDQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH] mm/vmalloc: Use %p for pointer formatting
Message-ID: <20260918105013.UpdykT6j@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qbzfaweaqyuku34zn4gawxaemxefucgz
X-Rspamd-Queue-Id: 90949A0002
X-HE-Tag: 1789728616-231907
X-HE-Meta: U2FsdGVkX19qo1Tpz82XSwEsNtfi8nZoh6z4PxI4mx7XwvLdzsemLTxGONR3CcCU9lk6LqLX/jr+MgmdEsBWYQFb5cWkcwANdjM45WzM6PnZjJ5K9+DFnW+lC52tz8Dldofp25m+mp7IO4d1SiOtk9g/Z/3deDWd/DJEgo92z+xIPKrwIRUWr/OjT9cXjQ3nk0UMfBn/chZ/o02uJ7NFoq4onX7f7cD6Y0LrnPl38o8ntU7Dc2DifUNSWW0Fs2xCzB5jO57MYtvmMfBz8R5Jv8ArdnfLY1wMGm/WvKKHNVV4BAmXOhKltioI8+yTKpk8BTwYnsrG7chjp4NLRjRrTlX5PM98yRuA1zPKuzgImyMo6A1OoTgaDhU6di0gqAwRoRZVZr/dOmDo+j339LYJ6N/4mVSadU+iulQe7o5pk/75mzMlfhUwyBnMMpuvONaG07ktvnghDZMdoneskU0ueIh2zARGHSdEiwSgVz3Gatw53XbgnmPIDdy0UTJndTiL+uho/mSeh6gRjxFb+0FHNomCVAIG7cMff9rdVGla1knCQmhCJ6i1u5r18RyqKrLgsbHM23eruLYcHsuAopOl+yy5fakmOWz6Z8dyKCD0+GOPap8CTEbGt9D0n0SoBYgpuxmlpcynosXGD1YP2jZ5lhNehszlH6NCPfbtMf/l6S3LWiIvnTmFJrwBHVUhYgjgUUjwtrUoRmGWQMGGAo0BffxYCZPN7qLzqWKpdLR2EyMT3RNZLo6dIFANzl+/CkLutTgiekF3wRsUboI5mNkajsSlVcup9gSJSt+s/aB5nJNZ3W5RmDp11tBwCq5yOtG8klGuZbhFNVTZP9ef35fQBzqK6SsGJXgwHsM0olg3Kpyca92CMSD7p1W2rsYI+D3Nu4rPWTSTmsB6zwyOpEv/S8+US6O+8Ct8hd7rrqIz0QRg5642HlZNsfMxdhEq8ThcmDOkbfQpsyU5O4DVF2e
 mtUCwAHa
 60gTzXS656ASivIejEnd9pJxJFOjfFNM6T7buN2mwkdfz+MgANh1Ly8j71o8FoTFDpXUBizz3GluMXFYtN3DfwjqI/8BC3symDX7d8TjR+QA90wbLmQyV3s/aFgUnT4mYAse80+tAmeF/cYwvCAlbGNGjwvRwEOzCw1bPSXyUYNL0ehEO/nX7j/sMpzCCXQsTtxal
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit 45ec16908e84e ("mm: use %pK for /proc/vmallocinfo") introduced
the %pK in order not to leak kernel pointers.
Since commit ad67b74d2469d ("printk: hash addresses printed with
%p") pointers are hashed by default and the behaviour can be controller
by `hash_pointers' boot argument.
The policy on %p is to not introduce new ones.
Removing %pK makes it possible to remove its handling from the library.

Looking at the output, having the pointer in the output makes it
possible to distinguish the individual entries.

Use %p instead %pK.

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 mm/vmalloc.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index bea9f76ed7e74..6461336f899bc 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5308,7 +5308,7 @@ static void show_purge_info(struct seq_file *m)
 	for_each_vmap_node(vn) {
 		spin_lock(&vn->lazy.lock);
 		list_for_each_entry(va, &vn->lazy.head, list) {
-			seq_printf(m, "0x%pK-0x%pK %7ld unpurged vm_area\n",
+			seq_printf(m, "0x%p-0x%p %7ld unpurged vm_area\n",
 				(void *)va->va_start, (void *)va->va_end,
 				va_size(va));
 		}
@@ -5331,7 +5331,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 		list_for_each_entry(va, &vn->busy.head, list) {
 			if (!va->vm) {
 				if (va->flags & VMAP_RAM)
-					seq_printf(m, "0x%pK-0x%pK %7ld vm_map_ram\n",
+					seq_printf(m, "0x%p-0x%p %7ld vm_map_ram\n",
 						(void *)va->va_start, (void *)va->va_end,
 						va_size(va));
 
@@ -5345,7 +5345,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 			/* Pair with smp_wmb() in clear_vm_uninitialized_flag() */
 			smp_rmb();
 
-			seq_printf(m, "0x%pK-0x%pK %7ld",
+			seq_printf(m, "0x%p-0x%p %7ld",
 				v->addr, v->addr + v->size, v->size);
 
 			if (v->caller)
-- 
2.55.0


