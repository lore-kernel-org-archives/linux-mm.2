Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB30BF3380F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 08:17:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD6536B008A; Tue, 17 Mar 2026 04:17:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB4926B008C; Tue, 17 Mar 2026 04:17:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9056B0092; Tue, 17 Mar 2026 04:17:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 777766B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 04:17:43 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 473B28BEF0
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:17:43 +0000 (UTC)
X-FDA: 84554851206.11.9DF91B3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1E25640010
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:17:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IW3jln2N;
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773735460;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=owEN78PfObGBNZSxCtX1dUlEuW4Ejyx550rHZNSxopQ=;
	b=LCK1gbKW93huP8fB5aaswucr4rL9kJDW01AUmxUIkSKCF+yfijLgJ1UHduANGzy0dkAxeN
	Wt2uczMY7RYorAyeU7nH159b4FQ4sknaf4LlGUa7lJmuMU3/GSOnqvJJjAbOFXHmGpQb88
	2DE4nOWNBVNBFdTrwuEvI08vVj3T9mA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773735460; a=rsa-sha256;
	cv=none;
	b=OlLEzeViMVHwFXdojXtUvAKDDtqhDaKRkzuFT3yRueDb7l6Rv2jgT7F9lm1d3dJydgcEUn
	tS+7wuThFB3XLOGR10uNOC/1Qje6Hhun9ZQeL+cuvJ9c8sZbEoIsSmOb5rbv45eGm3xSpQ
	TYZCjuhBI986AYaBGgZKqFobAa5BNK4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IW3jln2N;
	spf=pass (imf17.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D902943F2A;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2A15C2BCB0;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773735458;
	bh=jBYCjJmBms2DTTsjPA/t+ysWQ3lvt2urtM5GKlMCmk4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IW3jln2NTRcvpUk+O1SS+2AT+d3HJQmMcE2yZoLKg8TW/d5AAd3Hazu6dSo5WOIMZ
	 t7QueaTTXzVcfqJQOEpp4WrifSUUjakH0fTXe6q3QgRNNOkbeiLfiCRhYWYKLIvoi3
	 urovkdAI93Kdg6/JvBiHsJz+JE3em718uN5gRabTNjP+Jl0MmJdELBj/9cZOOuRd5m
	 bolb+wvIf8/OHuqNHpa31gRR0AXznAzRhAkVeo+8vOpAeGZdnVrI+KqAyhaIoNFxnI
	 nhlHtuNqp+cgO5HFhLIuUh2C6/O3Btymk+mS4SCjk5NgX5cX+HcpESfjohkSx5ZdiO
	 x/yz10+Qiyx2w==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4F11F3380E;
	Tue, 17 Mar 2026 08:17:38 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Tue, 17 Mar 2026 13:47:34 +0530
Subject: [PATCH v5 2/3] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260317-vmalloc-shrink-v5-2-bbfbf54c5265@zohomail.in>
References: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
In-Reply-To: <20260317-vmalloc-shrink-v5-0-bbfbf54c5265@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1773735454; l=2798;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=AcrwNUcas9eCuK1NFOLlNfncYjEO6WE6bt7Rp71YBEE=;
 b=lHMbWjW2Nez8n6V3NFUQo5wXOvs640kPXAiMbokRB7o+nYf/wCqWNYVkn8b1HLh8PKar7Ksl0
 IDffUeDyhMFDbr5kNiV2yW0swOvB/QXZTFpWH7ZNOOCfKLplDGKUkpK
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Stat-Signature: yagksshdto83gyugq11atfhptbmuhoba
X-Rspamd-Queue-Id: 1E25640010
X-Rspamd-Server: rspam03
X-HE-Tag: 1773735459-245173
X-HE-Meta: U2FsdGVkX1+4F/3MeHt+cmdAWkER1Gj5Sp3tF+9Vw6oNF7tYByjjM+nLOZrKnZjOi+5EZsE44Dfac/vkLKObzD43PoLu5oOt8NZ+6NSiZpbt/hdhz63permIOpE3K8SfYycHTqzW+qNTFIjRtIcTZ5RIUYSd+OReuvr6PmnzrK5hrOSNu76Vj6ZjEscV5sg7Mn/rgoAW1ggwTGGY6sJU0r9Ei5k+39Kdvk6U2VzesvpXnsavG7iBlbfQiwbDl1jedSpTTAWA/RdEiffvgkvtFsLR0AnRYF8Sb0ll9E6RWh9ovXfLNgDhKXBoy54XxzmB5v5ZhPd7opdN46rVIIyVWXdneQM/iAHkdxZHV6CqTWYzruNgl7jcq7GcG7BjGkvo8IsXxsWMOEEzmvga/dmUSD5ncZB8M4gQWGQrJ2pitlGfdfjQRVJdJcr2xhcVhU+AltOCi4IhjBw0WWo816K8JKyaPfSoetsENhEtr/0xjhgXkyK7mnV5+Kgyo1cgwV6q4wBj5BcQ2kLMuhJtjRcPXzg5CCE+fnIel5DL2+H7zsHHEQ7ArAQT858eFBGJdlP67XeVmveTg6aEPaw1JVYAWmOEx6O6srxIJvZ06+/dY9WGLfBXlom6wJSsmJsopeePkRoXJzqEFA8KvHSsgXHFKCBj+yr17ajYl8P7eY7PbtddN71tA6mCqTgWN2XzmlE4uFGIhw42Bi9kuarwNd2Ivg5yXQhCY2Ecl63qcyJOV3+QrtU4mZeZg6N1l2Y7/2NHGGDDZbG1JOXhWUds591t39i+lNfVsckTBGdCt5WbVt7TBTLZ7EgXekrDsyzNtyHKwzAh3vCw+YWtE76X+FFuwrHzZ3YfaTtnK2mQgbs9KAgdwdhgyo1epXbgwxMMFX57O9S8aNsxQfwT9BUEA8oMBNuVUrLhrvdrWzSDoZD2HaLoqA7ExHHeE0sDex+xWrxFvOiILbVM8jAS5zcK3Xb
 QCkxMwaW
 ojKY2z71HlUAHZP7pNW90AwjLLpEGe1yGB5jGTHJLjeH5IMJHqtgvzz4erYq/Fqi/CZz9FlpV6ISL07CFYcnvp7JIxP4U6ZTj2OwNX5qIRIcTaALx/fPRs8tsDr0TczCamVrXLwZxWY0rQdmkKtDL3E3wJ8pgGiaCnD/NPTcdzgklBxY8+t2aMqbZDtM33KjV6SN/QuCHzBiLX7e4mbSwn4y7o+y//SKhRxG/MGTspTM2eKI1kN5ijhQv+v9YYygWJePnTGJmXnOfJqJ2zR/vUJD/wy9cVwSwCEJ8TWHpPK0lo+9YCYoyptMxiJljZhOSCobBgVntidMTzrC2bAslnJV9rCI/9kx28SyjvgWbTPMgC3I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

When vrealloc() shrinks an allocation and the new size crosses a page
boundary, unmap and free the tail pages that are no longer needed. This
reclaims physical memory that was previously wasted for the lifetime
of the allocation.

The heuristic is simple: always free when at least one full page becomes
unused. Huge page allocations (page_order > 0) are skipped, as partial
freeing would require splitting. Allocations with VM_FLUSH_RESET_PERMS
are also skipped, as their direct-map permissions must be reset before
pages are returned to the page allocator, which is handled by
vm_reset_perms() during vfree().

The virtual address reservation (vm->size / vmap_area) is intentionally
kept unchanged, preserving the address for potential future grow-in-place
support.

Fix the grow-in-place check to compare against vm->nr_pages rather than
get_vm_area_size(), since the latter reflects the virtual reservation
which does not shrink. Without this fix, a grow after shrink would
access freed pages.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index b29bf58c0e3f..f3820c6712c1 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4345,14 +4345,24 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 			goto need_realloc;
 	}
 
-	/*
-	 * TODO: Shrink the vm_area, i.e. unmap and free unused pages. What
-	 * would be a good heuristic for when to shrink the vm_area?
-	 */
 	if (size <= old_size) {
+		unsigned int new_nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
+
 		/* Zero out "freed" memory, potentially for future realloc. */
 		if (want_init_on_free() || want_init_on_alloc(flags))
 			memset((void *)p + size, 0, old_size - size);
+
+		/* Free tail pages when shrink crosses a page boundary. */
+		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm) &&
+		    !(vm->flags & VM_FLUSH_RESET_PERMS)) {
+			unsigned long addr = (unsigned long)p;
+
+			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
+				     addr + (vm->nr_pages << PAGE_SHIFT));
+
+			vm_area_free_pages(vm, new_nr_pages, vm->nr_pages);
+			vm->nr_pages = new_nr_pages;
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
@@ -4361,7 +4371,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
 		/*
 		 * No need to zero memory here, as unused memory will have
 		 * already been zeroed at initial allocation time or during

-- 
2.43.0



