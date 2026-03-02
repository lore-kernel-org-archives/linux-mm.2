Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1990EA4E08
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 13:57:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9AD46B0089; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF06B6B0093; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD15E6B008C; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A654C6B008A
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 08:57:40 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 50BB7140129
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:57:40 +0000 (UTC)
X-FDA: 84501275880.18.6D54696
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 50A7FA0009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 13:57:38 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AhpV3jtf;
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772459858;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h1N6hzTV/UASbYFObjUBkXQ6fOWORBmxBDNKB3ZoplE=;
	b=Mv3sYwijIbsmfE54auD5Tg0QeeKQxMlmT2mosLTLQcDDpFVmJNSTcX6MnjKm36jmembR3h
	8J7y/JFbeaoSRLe9fjEEj3ZcTdJCbVnUs8S6NqGXAFp/MP4Iz6O5gSgfUIOUkXDWFY6ePG
	xpF04sXHKusY9fSV76zVDGwGZ7AwqcA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772459858; a=rsa-sha256;
	cv=none;
	b=WHoqCmPUqI3aJZoxFMezI86AypmIY2MK/GnU90L0mj0KARan5AtlcWTn+yJHmRL6svOCTg
	Zo1P4ypbZQw/RY+jEGeKNAypQsQ3npMjWOohiQfXWq6tVu/DeQgKD34ailDEQAiO7z3mbN
	ml0i9jgbXBNJIUwOaGq2t2vtMZB5eKc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AhpV3jtf;
	spf=pass (imf15.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6342443499;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4380EC2BCAF;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772459857;
	bh=uLsMOF44rMJZ/TvDeYiLPdJwJ5UTQPAzG+OJCt0sUVY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=AhpV3jtf90t9D0MsqAvUADUen8OxXt6WiK3KhJ18SP77E8jxYR52DQkHAg7xqGcAc
	 2R0BFW9YpjA2vC9etB8EwizVIBQe6qNdm1ixriVQWTCSaqVuOez2HrlrcTuTULAixy
	 g9yVUG0UfuITDZVQ3J02VYnJD0VrsHyvNF1bGoCfPG90sefCYyXZRAN/vwyxPMh42M
	 2x8X7EVv0+7mmxOz/wbDi7gz5Srr6p0PSx/LvZsPWHZdnrrQtVfsCqoLhDUdph/OyM
	 C1YXNrEDarMJzPap0SsvckVawqXl2qo8U/EBWesZ5myvN3DYUhyd3OTEyT6ZVllvbg
	 VoEdx+eDmNLLQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 399C6EA4E09;
	Mon,  2 Mar 2026 13:57:37 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Mon, 02 Mar 2026 19:27:12 +0530
Subject: [PATCH 2/2] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260302-vmalloc-shrink-v1-2-46deff465b7e@zohomail.in>
References: <20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in>
In-Reply-To: <20260302-vmalloc-shrink-v1-0-46deff465b7e@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772459853; l=2712;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=1erzrKM7o2q1ZdLZf3ysmYhvkVLpMZRusvoIpirIWHk=;
 b=s8dCbDyuolYo1EwgvZlaLveGaiqIPpn8jL2D/pue+DAQCoZWL5qLQQu2bmpearqaj1v9tgV41
 Z9VRutTIjuiBZHd/CR4Mhuj2rKwBIB21N2vcFieESoQCCZb6iesAsmH
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 50A7FA0009
X-Stat-Signature: pciu5ki8bd5nipy9tkhdqf1fpty8dh8f
X-HE-Tag: 1772459858-532995
X-HE-Meta: U2FsdGVkX18tdOO8QtEEg2eJ3e9mNxddVeCqrmcTzojZ7SItiNqvLBFE4XNT3St8VHvzjkWYeL26L7Vk4oCaYK/r4YI+zK4ntbA9Q3Kb4s9A02XePZ8uTROFbivyODTjqC63nF6wD/EDR+MSvxJ9Nu9mgoTkC5cNFOyp4Ic9c/Kn8y77Sqh+qbyCe3XeiG7h+vMoZiaLE6NCDs9A8BGN4Aj4vM42UKfZ7WhEmNHAnOe9DqIWiT6GnD+PqXQCTtMHUcp72Yq8cKlJ/yrqkqimyqsDEgTOWWGWNBbSNJ0s0wRQNehlWe9OjoAGPsQwfD52W0PPXD6PHtECwfLSTk+4nvi4HropXb4pMdJZHp+TsyDsbJ9zWhqmd9Wr1rCnQB+0qmUBYfzoF2KoLYpLKrBXQioAelFf0E3xUfrpY8sC1suVecxv1Gjo5gg4eZe/NqzuGT6hh9lKWh4gWcot0HRs9k6q6h2zYyUAPFHH7cjBr5QdU9FXNwGvXKunXpzUm/jKu4iaXJkiS2WqG1hoExxDD+VhyV0Hh7r+L76UVz9u+1dpPHhngnp7O3xz3pWFJ0Zji12xT4+rcg92AeDM7r/jYWzf/3d11FeEQSNh+/Qt8bovgmfmja4i7NmuAVFtaY4I8LTlxpuBQxctR+m0DX/VOLuldyOU1iLVAYa3BHza9/9Q2NL4aSfYxU0wtEIJ9w9n30FvGNxfX0NiMuBlMvXeXDN77YGWh2WBkzl3B7+v/11Fm7Kj7DvLn8hJVLE0lcuglFnSaZSqhY0MvYWFsXwgRg5iUjzBNq9+Dz60FYggWcVwVL4m3o4lq4jHqaPkO/y/plbscOTDPApksrg/h6scrbrc3YPsaLHKmDxgA9TMwMh9BIi1rhXD0Hk8STUkMLTnLuFGdFVR9QF4rSmLdZfcl14NgS5IR+1JL51ibTFNWUTWQFh3mb+9HDtn1/vesAp7i/3MaKbYwEfJH91SYCq
 qMJ0Jw/C
 cfgL76cTQYroMzIV+E8KuHZaM0GyyMYQgJBt4HoY8mM2PInMWc9dlJ/GPAHIcWcpSA2IYM2NS9FSLiEi5nFZ4Puubq1Tm8W/S+dZFSI+Ki4y7UgA0kImIE+GPUm2BK9zMiHSP8F13jJLsuBlvzr8Pr+mWHAl9ohMPb867vC2+d4ec5en3FYNi0dgrOynFo4En2872DtCBeSjBor9Z0hV3jSIlp6BMkCjZxm1zWqMgno8hD73usy0DEcZOEhTzBRnHnGbMWfEPa/dVdSbPILvARyzE7bTvDCLuBPqCxwelijRGvaE0AN9bFrkNNqIMQhiMsaT2gGFEuNzzSxSBOGdw4Q1y31XVPSD2BcygiJU+VV8/gqk=
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
freeing would require splitting.

The virtual address reservation (vm->size / vmap_area) is intentionally
kept unchanged, preserving the address for potential future grow-in-place
support.

Fix the grow-in-place check to compare against vm->nr_pages rather than
get_vm_area_size(), since the latter reflects the virtual reservation
which does not shrink. Without this fix, a grow after shrink would
access freed pages.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 25 ++++++++++++++++++++-----
 1 file changed, 20 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 54e76a47e995..7a4c59422638 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4327,14 +4327,29 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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
+		if (new_nr_pages < vm->nr_pages &&
+		    !vm_area_page_order(vm)) {
+			unsigned long addr = (unsigned long)p;
+
+			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
+				     addr + (vm->nr_pages << PAGE_SHIFT));
+
+			kasan_poison_vmalloc(
+				(void *)(addr + (new_nr_pages << PAGE_SHIFT)),
+				(vm->nr_pages - new_nr_pages) << PAGE_SHIFT);
+
+			vmalloc_free_pages(vm, new_nr_pages, vm->nr_pages);
+			vm->nr_pages = new_nr_pages;
+		}
+
 		vm->requested_size = size;
 		kasan_poison_vmalloc(p + size, old_size - size);
 		return (void *)p;
@@ -4343,7 +4358,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
 	/*
 	 * We already have the bytes available in the allocation; use them.
 	 */
-	if (size <= alloced_size) {
+	if (size <= (size_t)vm->nr_pages << PAGE_SHIFT) {
 		kasan_unpoison_vmalloc(p + old_size, size - old_size,
 				       KASAN_VMALLOC_PROT_NORMAL |
 				       KASAN_VMALLOC_VM_ALLOC |

-- 
2.43.0



