Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C6B3FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 20:24:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 162366B008C; Mon, 27 Apr 2026 16:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 024956B0088; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D6A3D6B0088; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A83A86B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 16:24:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A4DF1B8BD1
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:29 +0000 (UTC)
X-FDA: 84705463458.29.621BE78
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 2E2B5180005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 20:24:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8Jc8bTb;
	spf=pass (imf24.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777321467;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3+3svjDsioMu9nE0DzYqXJ0Q5nKVTgwBVsuqyfg/rs0=;
	b=LWTnRuBmFCsVkhjPzZSqb/AvYFv3RKK9JPD4ofol1pOvJPb3Sz2/rv0Bk692+bxaMz8sIA
	TDNQGgO66EbUYhLObEH9rOC30zoFJZCtZsXOvExgv5FdrcIBZ4jhJwdl47mcicxGFsYWq2
	dE+LsJltNgB5+hM1lp6AvCVN8d5mRwI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=m8Jc8bTb;
	spf=pass (imf24.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777321467; a=rsa-sha256;
	cv=none;
	b=QJ1x6LMzHLie4+AdiRlJuiVJNYyJvWQdZO+QvWHW/SimDZ/PLjqDK08zaxLI/rmEHDqP7U
	N6lLfKTpTGqMQixwT+Cfib4LrPIbwOvVi3c0bhGFhMcNYg5P0gfkkGi4jV01/pFyQXU0gw
	T+hAb/nYReyqcQKKVit/caWV0wA2C5w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3C69160138;
	Mon, 27 Apr 2026 20:24:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2140C2BCB5;
	Mon, 27 Apr 2026 20:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777321465;
	bh=8VhyCSBWNt3i7bjVVa9tmZQb09bkp/mb65vyqxOzAO4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=m8Jc8bTbKj43oqaFWYInpU2kAnpvpNC1S66mrquw1uRWdS73FTTzbjmGtCJynLqlq
	 FgtxLlQ3njNvac7Hq3PIA+I/U2MXq4Uu1XS1U7LuQYQ72OC2+5eE24Or+ndulHcHLW
	 wq6xfMNxRsR7LOpoEOsiNrWG3Gy2lduUPArBs7991G+31z5Xy2XILxc9UX/Xzu+BDX
	 Bmkq5tT8W3QGF1gZxQzcUGQ4mWI5rg8whLt6826FFs48a96cqTGXh/GCEN/qM4KGTG
	 qob1Zhquc7ITnDNplwy/2Okta/LfW1R9sxnpbLYjNShytxtmYChi6H1ZuBQCu07XQx
	 AClqUX/L3lTqw==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D00BAFF8867;
	Mon, 27 Apr 2026 20:24:25 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 28 Apr 2026 01:54:16 +0530
Subject: [PATCH v12 1/5] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260428-vmalloc-shrink-v12-1-3c18c9172eb1@zohomail.in>
References: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
In-Reply-To: <20260428-vmalloc-shrink-v12-0-3c18c9172eb1@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1777321463; l=2413;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=p0TbLs1fXk9LoPaeNtoH0gYLWzCHadOSjVu2hcSyOWs=;
 b=2DQ3j8HZ9+xH7S202jUyFt7bDNj1UAxPd873RQEa5Z03BRcnL/ZSyntKmpnYUrytZGaVc3Apo
 eULk1FOnUdzAWS3jc5R2vXRsjce8Qyjn9sIOXaXuHMqO6hMYBF231NZ
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2E2B5180005
X-Stat-Signature: sjwdocwzggch7ppbgw5so6f7i8zmu3kg
X-HE-Tag: 1777321467-105972
X-HE-Meta: U2FsdGVkX1+ssheSJLxmzAuW2iTZ5c7T9HvAWnhe6cggf7Ku2A/5lpfnlRYqtxzW/jCkOQKTCl70/lmwmzpARYFD5BLt5JTWuRwUQ0jv5yPOjxOi9TO0fHHJcdWoltepoIpC/I0FrUcRbchCHuKW9fUkqpxxY2RU7dnKDd1Fo+1zGl9DD5ulepszM3f4gITxNmAKxv2HsZNz8vUIrOEsEtS9QHBL+l5j2Qq+ne7YL/k1c7ulaHteSg8icrj1H1INrUnS3F7s9vkPr/5+rB4rCSsV3w5j+KsUzBa8ag3TF7pr7WjHYJo87CePCoUDhrZ1+D43denxSMBdt3r+3SCIeEvl9Ho2M+xLgPRH/anOcYJmgg432kBdg7nXfHrwMPlNlK33qZLwwg2oYs40TD5CzN2ZiraJMmDAeOz46dM4hrw5VOH6qgnqBBQm2Gen3w2LKmnWzERtKXfjPEX/8nLOCO12FuSm+QiDkvPoLZxg7xLNTxWF7pTf+exnRqlz0h3+c+9qniqdBLJFLIGmvKijQDlNCAm2CYeU5I5FX8FWkffIqsFCa+V5OPBRsLJvPCLxb/oDRNepRRf2xLejzSj/IB7iIj3unlUMvEescRa67hxDGZBxSKB3e+fD+5kBtlozhiyEz2KDKSIrz44ldjwvN87koV7tl39a7MXdwnqJsxlbVMnapPQXLXdvvItTrk2UM7mUu9gdml1tPraC2wTM/GxoxQ12KKi8qSQmQQClLlal2cw15MCngRygJ4jCWYyCaCo47pTuC6I0vndm7clKcAZalkbkr8JT/oVxOuWjRfEPCSaowSEqM5qfwjaxv26hDbgcbGCky6cSURv6I7TjNIvoaeXx2wCVC7ysyUVjSC1X8P8ZgOBUoMTWYnjn23XGKeHS7iOnFF+WleRdNHgUnf/bovvW2Weg3T+zrSYuGkwKJOOzmeDO+3xFe797J2Id4xviQ//6xJdSrVDcJXW
 9aPD7cA0
 OXOgaBV8HdlqNNMJPHiHmBdiIEcyskAaP55ROUZn/8bF+KignuWNqQLaIQWiKfe56qKBr+zv73uIZhV0KeQ0aPmwn+HPq/oQkDorrO23HqKXZvP0SjpYWbZvTeIFVNa1IxjcdTX4pS9AQqC0ZkmQpdZfAdlnVHApTcLnQgOStYCaCPSb2NOsv6Ty+0TOwkJRD+b9/YqsaIEBlzdOlVmK/yGHL+6DI1qtF9bem5p5hyGgv493QdmpfKQv5YHwHt/QHFkO/a28v+EvDVS7zUqOMBlYF7WfbD5yNTqqmc4Zdv+QSM6Z0JfyJbIzq0D4LpDHYqRg8fPsI82fmcUnNdoh2DH+tpGdvjegdFI16HedLbZX24s2kocw9pW4oHwm/J0U4BnDSjaK2Vvr3dRGfXyVd5OmOFXQbGz1TQtDYy1B7mLf9qNadNX576h046BnwI23XWX0e
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

Extract page freeing and NR_VMALLOC stat accounting from
vfree() into a reusable vm_area_free_pages() helper.
The helper operates on a range [start_idx, end_idx) of pages
from a vm_struct, making it suitable for both full free (vfree)
and partial free (upcoming vrealloc shrink).

Freed page pointers in vm->pages[] are set to NULL
to prevent stale references when the vm_struct outlives the
free (as in vrealloc shrink).

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 878c5b7bf837..1073abb6094e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3416,6 +3416,32 @@ void vfree_atomic(const void *addr)
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
+	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
+		for (i = start_idx; i < end_idx; i++)
+			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
+	}
+	free_pages_bulk(vm->pages + start_idx, end_idx - start_idx);
+
+	for (i = start_idx; i < end_idx; i++)
+		vm->pages[i] = NULL;
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
@@ -3460,12 +3485,7 @@ void vfree(const void *addr)
 	if (unlikely(vm->flags & VM_FLUSH_RESET_PERMS))
 		vm_reset_perms(vm);
 
-	if (!(vm->flags & VM_MAP_PUT_PAGES)) {
-		for (i = 0; i < vm->nr_pages; i++)
-			mod_lruvec_page_state(vm->pages[i], NR_VMALLOC, -1);
-	}
-	free_pages_bulk(vm->pages, vm->nr_pages);
-
+	vm_area_free_pages(vm, 0, vm->nr_pages);
 	kvfree(vm->pages);
 	kfree(vm);
 }

-- 
2.43.0



