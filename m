Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9093CD3427
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 08:17:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 71A426B0093; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C1D16B0095; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4502A6B008A; Mon, 11 May 2026 04:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 304516B0095
	for <linux-mm@kvack.org>; Mon, 11 May 2026 04:17:43 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C2A4A140623
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:42 +0000 (UTC)
X-FDA: 84754435164.18.2A1EB30
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id CDB6A1A0004
	for <linux-mm@kvack.org>; Mon, 11 May 2026 08:17:40 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ph7scNI8;
	spf=pass (imf19.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778487461;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7MhgZ52RPVLFkxctXqwdKRJRLWLtJrs8riggTWVqK84=;
	b=MUjQ9VPUTGspTDZokSyMcQwemLxUc5UUHS6RR+WCX08ZZ/m16l8kCF4nCOFF6n2UOmNsTm
	hVmc+nPkpHt6Ede/LmZzz3OMVffR7GdLwLUuKwXJ/TlNVSOb0aFZjwOLme+53PScIbhkVZ
	YCk/B6mfI0PH1sFZqCssufeiRRi4B1Q=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ph7scNI8;
	spf=pass (imf19.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778487461; a=rsa-sha256;
	cv=none;
	b=m/FJGI6jLkO3xBqolIOUm5ftF78J6Dm/vd0cApoYMlXuVC3+yy1mhLCBTVnZaESAGpRfCg
	Fwc0nC0XuMhDDSak7dEFArqlL+Cu03pDBem13liQ68nD4sXM3k5N1e1/7e7EPcEyFs3Nu5
	GoJPCd3rb7KEyieYG+Fn52dnjgxnNsk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C363C43C6C;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A564EC2BCF5;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778487459;
	bh=Yuu5418MZenraO1cEJhij9RE3E8satvpwxl3d6qiHac=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Ph7scNI86bC4VGTy2uoY2f7ulGwX7+Z0je7yEI9robBIJAoHbKOsfsWI4nXWSE/eB
	 //9W7la3o39/K+0ZqqTnixnTuFzLjR7Yrc57u4vmFGlcqlbT4WY+Mwddu+TlRMqw5R
	 sTXw/Bx+Vfe+kxBrQdlCEkXw/FknwvGA5Qt3mjBCtz/iU37zdarT/GkrxMJY0cYlz/
	 qTRU3f3Cyep8A8JPe4ZQTgabAXGMznT1xleTJsMo6NTK8tTMkyCGlGRJRoJnyGGZB9
	 3i06VTqHREv0Bb6dPZtz+4SVXG5RU70BqcQ5eQF94Jx6ZXPkPuyyYqRrfle6fcGSZF
	 jJs+PXug0BkJA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FBA4CD37AC;
	Mon, 11 May 2026 08:17:39 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 11 May 2026 13:47:29 +0530
Subject: [PATCH v13 1/5] mm/vmalloc: extract vm_area_free_pages() helper
 from vfree()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260511-vmalloc-shrink-v13-1-643b7ec277a9@zohomail.in>
References: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
In-Reply-To: <20260511-vmalloc-shrink-v13-0-643b7ec277a9@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778487457; l=2470;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=g8lqMk/sZRbF3gcdhaoXiAZumYYOTY4cCcb8pTUlYtU=;
 b=yTI5v4v022BkUsxgF/ATbU7cWVQWSCdz6ULdUZZYrurBnocjrT3VhfJT8S1YJIAB1TaEvo+7W
 fiO4ZjiJPrSAs65M19Bw+nn3MbIyt5cV3QPt9SRaL3oj2/fIv/QgxZ2
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Queue-Id: CDB6A1A0004
X-Rspamd-Server: rspam06
X-Stat-Signature: o7eu3w9jnifb69rycrjzhxhhmzyca1r1
X-HE-Tag: 1778487460-958342
X-HE-Meta: U2FsdGVkX19cH21Qe5K25htevyi1mVuq6qi3BLUAYGeTsQiUcQTkHFvQybPeDe67tg31E1quShJ55F1OGWvNR04q6bD2+qwkDrvsfHxYPErctUI2wab/VZp5R73omSJHKHd/7ing5cZxT99n/8izMXzU6/QYgtoMvF9Lm6V7SyHOmAnMZooK7ANnbPI6wLjxB895IFLyiAe4jouEurzmKWP+QeDiB6egStMOoIvQVshXxJlvfJ66ctxWKfXX/GtQ6LR28DX1zCiJmDwkInUPbA/PN62l3O3dg/s7qf3ZSa+qyJWAUtu9MuUsFENUfEIhsvq0lpBE21BpF4Ld2WBuosDhBdXZ+JAws74oexal8D1VLFWku9i70cKLGDm9ygSDs+mxTxvJp8CRvjfTmgbX7ujAuLhzGQxdszMqXYPIpk/+G6c5FJeE9zC4pPN2XcJc/BlRN5o+m6EskKLeNgm/+lyizFDSlg/T5VfEMEy8vF2Xa+qa1PkSZfLOWN0mcnQ+eGGWZObim9rUr1owX+1YNA8DPXF08YBQZNjEoGGL/EVSL3zegoF6nx4/cgqPv7RgPGHWaIpdB0sXydM+SpJIWMK3wear5JZuVR1eb3ZXCSKRuDRLPhNNI6cSqzvuDLcYSz1ShWLFafDpGwSfa7aQLDb0Ob9p1Xh/M5oDksvyQqEw39G8AIBGyyhf/MGAZ7Ywf0jER0bMdSK2bIFmnBSB8Wolkmw5pjClLKMmXZmE/hN2+RXo0nOVXd0gc/De4soB6LWbIhKfSAGcQFkomuBzUTQxp+ZzCik35TYn+wGX3/4K5ZFJWOwKmjvo0QUHZP6PKxVg6+tDJxcMcUX4aL2k38gnBwrgCG3Zg9iUNddPt8MQEkFQeF92hVeaMoGqbSgUOVZtmAG/gdNTkIy0JOszqsplrbptTXYuYRwcVMK4NqvkMIH+ME8IfkZIulV/RwKR2FuNNrikiddTsX92F+U
 uTrwaMGD
 eEbLiw0yYrXGKZ1cji/2C+M5VTh4JL7AiXKHll+OqVNY7YRpI8xMXXybm+rpXSAQLek4QrNmANlz/guRJVZQmAw8ArZTmw8ivamEtQflQV1VmWKmH9Rtn+XnSrdibA48+jqon/t2gR1238PGFpxPPbrPcvX+yfQWddSi9kvEnRj3U0tMztfLCrf5aogiU+vTMUNdzyd1B+YRZLoEESBglMRvooTnmIwvi6ZB6VbOLPHN+aE16/Yoa+iVeMPLBNTGJoPm5fCYObvwVGpHbtUnWr0RR4IL5y6xDsM/a1NhS8z1sR/UC3CRr/HcUQFuZht8XKyPtlrxCMJLKBgb0dKavADLujZ91PZMVrhHxgTVe++ppiYhJIW1k8WzTS1ZGS0BsBTsiU5MYyGkUvox+VgdlAgw9l7OjCD+kEzPo50j/ej8XGbJ38mA4Gga7Nzh2LqIsgJYyJWdI9h3K0ad+3G0ya9rl1gswrBoa+a3EG6ztDYcp+YFTyEmP+7x7Nw==
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

Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 34 +++++++++++++++++++++++++++-------
 1 file changed, 27 insertions(+), 7 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 3e9e5156f43e..19a16e6f4014 100644
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



