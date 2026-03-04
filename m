Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29538EF8FF5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 14:53:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C0D36B008C; Wed,  4 Mar 2026 09:53:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 338046B0092; Wed,  4 Mar 2026 09:53:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17A486B0095; Wed,  4 Mar 2026 09:53:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E7BC46B008C
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:53:32 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B4ACF1A0385
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:53:32 +0000 (UTC)
X-FDA: 84508674264.12.3A88684
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 992C514000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 14:53:30 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Im4hCNPI;
	spf=pass (imf23.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772636010;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KA1AKaf/MEUOvKkretLwD/OR/qMNkvPLn56Q2ubwNJE=;
	b=QfO6bdg7y3QpMx3egVarezjYkdDySQ+b5YAuoSVIddISOslf+7TZhz7/1/K1YHc78vQUlG
	H46YDF6dpAknDvF39aNLR8cIMaiACf3LgyfqoPwalFjSDheHqMpwsWCuuYuxwfcSLitltg
	8ji9y2FKfT5cYHywPZrbanhCeHtnMHM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Im4hCNPI;
	spf=pass (imf23.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772636010; a=rsa-sha256;
	cv=none;
	b=E2OdGxdwZZJNZwG1VHG2kLBQwNZdoTDmrM26nAIFP2KRDDwJTGesyO+s8ZbAB3gpV1Lk4y
	qtexNQljW8VABgt/viYzAf6++TtLCVEApDa0jVhh//CGQguKZdAndp8/AVtip2KPMs/nEz
	wxrcRSY2C2zVL1JWtsToj4WiPzDggGQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AD5414172E;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 88F79C2BC9E;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772636009;
	bh=obzS9P6ZNeJAxn5nItDpGm+ktrhNRXvYN4TD1fyB2FU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=Im4hCNPIosrXVQBGxE8Ipsea7tdG4rpM+qk85retlt2KiOKccGzRdu3+pAw9dMYXm
	 +ZW9ZBRcatAzi6hTwksmnvsHx8RrvWW8fMqgBrPOrW7r6N/WBOUyrbog5b3rN6BcjS
	 QOrq1XW8T1SnvDo9AjlMve2hFwnoJSgsF0UwzXs1YjYb9TShUuiApiQUL0Gm7H7H8v
	 O4Ep4XwnCVaBkBy0fQQDEZnocobohWIFwvZSN/SRdGY9+1ea03FdC3uIk/6r81ASh7
	 Nrkps7DkZVSrZYwL7V8jRaGwRcd3/BOW/IO1acL0IqaTJBY5F0MhddYz26GFTz+8/e
	 63SxP1kXEDN8Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CA5CEF8FF3;
	Wed,  4 Mar 2026 14:53:29 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Wed, 04 Mar 2026 20:23:16 +0530
Subject: [PATCH v2 2/2] mm/vmalloc: free unused pages on vrealloc() shrink
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-vmalloc-shrink-v2-2-28c291d60100@zohomail.in>
References: <20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in>
In-Reply-To: <20260304-vmalloc-shrink-v2-0-28c291d60100@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772636006; l=2543;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=OKQH3IWxL4ounbCE+6VgaXMjPoT4ux/8tD8AGU1gTJo=;
 b=XNA3+LeXRJL7O5ATYcsa+KLREiMcLDVQS5J9AI3I7lUZGevOoDDdscBLtWr+7Zg0rAx2tNSCN
 h50igQWgwQOD+lDRnPxcaWkq3mCXBLTeE2qV6mz8HTdO/zdrWXnwTgZ
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspam-User: 
X-Rspamd-Queue-Id: 992C514000A
X-Rspamd-Server: rspam08
X-Stat-Signature: 9p4tgwsfjp8fj1cbgdaafjektx1s6m6a
X-HE-Tag: 1772636010-767035
X-HE-Meta: U2FsdGVkX19dwbKTN1suEAEDMDjP1Qm3+o1KoevB7lUNvAIN8gRaPZbahh+MdFh8Pxh5ZTU4os2VkjyHaKp0ZfONOiEG8WlI6C9Q7ZiMQzz15dgXO9JmOnu5pSAjf3ri8gb9/F7aQmvu9NC3NB1MmEflExBsIu4VGxXwnDll6puAPixjmldwPzXacmog0r2N0aaIcN/tz3EtDkAdMZwsU/aWG18hJ3CEZadaFmIYAUWjaK1xO4RIzG4q2COpJdWFTu9DgjC1vozVLWIVaMRPAX2bC2PBm9kP/cnVHNsI0ZmWIFbVh667vTC2q8XI3L3X4PTMJfzU4V/Q3h4gZfR5X4S+8Qo9Gl16mm6+mkCrYK6qrhOJSZdpD4ln9d+iC8SSHSOFrS6oI9IbdjIM+ylSSbgkGKjNTe13zxpzyJkF6IlV14dXlQoM78LEIo4YSXurh44Ej63tHZJWJS8xe/IT0v7eA8oxssHMchfjQI85F9zA52S7ZRiD1eMzAkM6ntgNN5sjEfxUtVQs+/HjCrj/xDkhOFW693FKdHGqameYP9BdyixglIsM45QoDl1jt6Lf3qyP6B87QHo4HnIOEZ5J0og6VUyMMeLEedSt/YuFPisgpUd2yibpdont0+UepB6TflG7nu3vt97tu6+llMDnEeJhH4ZcxY+BV/KRFDn1uXOcZhrQApHq/OdSafAP0f1nl7Kx0un1yhUQjl0u6bSYEomLu6CSEYuQAYW6aoeICT+GE1IRlxNZSbxLukP5dekUNgfv5VDf+DM6ojCwwVGqgqaGm8hT073yuxoGGWTtIb7Yx+nr4cjJhjPK+uAN0dpCfZ/TDX0/UnPMg1Q1c31CbqKqEUN/56klc18xaRRnM1OGCuWzjMlhft+BZeVRSXiL1PDQYHDqBjcoWAcRtk0FjGvSRSto+gP1/ubXdU95sg0ohnADPT0jU8MyuwKkv64g7WxwE8ANqN/LLpabSOX
 U+9lYJGl
 UgJuTRSF8W5FiE5eGZolhtGrf/loE73EK5Hguon+U2d2/xqPbnQuTRO5kaaEga5asLJn8iKl9UAkh+wRGyXr08dPN5DMOgq0xQAflzk/2hFQn7pcwXjHzLebTAsgxfBEtjWwbvSB9GPW8aFLVeUkAcy2iPtypPRP3nSM8+1Y5USrrc0vusirzvPoAzYKz2dGbIFPNahTzcRDtSjbElUfnWLGS9kOrF0trw3BJE4ZuuI7gKFkkFBUh+g/MJggCm3ZQuWc7xwpJRa0EaE/2ZtDCXrEaq8Zfn/YI7Sb9FFJ7gwS+Ab8IdnGv7LNT//yGl7BpXd0V8N9pug9B+7fSsCW2FWEpb1n7SMHI6LvqwwOPiTeioz8=
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
 mm/vmalloc.c | 19 ++++++++++++++-----
 1 file changed, 14 insertions(+), 5 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index e2aef0a79f2e..1a59afb94ba4 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -4340,14 +4340,23 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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
+		if (new_nr_pages < vm->nr_pages && !vm_area_page_order(vm)) {
+			unsigned long addr = (unsigned long)p;
+
+			vunmap_range(addr + (new_nr_pages << PAGE_SHIFT),
+				     addr + (vm->nr_pages << PAGE_SHIFT));
+
+			vmalloc_free_pages(vm, new_nr_pages, vm->nr_pages);
+			vm->nr_pages = new_nr_pages;
+		}
 		vm->requested_size = size;
 		kasan_vrealloc(p, old_size, size);
 		return (void *)p;
@@ -4356,7 +4365,7 @@ void *vrealloc_node_align_noprof(const void *p, size_t size, unsigned long align
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



