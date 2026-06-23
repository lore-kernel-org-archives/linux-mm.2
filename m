Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D219CDB479
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 23:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D81636B0092; Tue, 23 Jun 2026 19:16:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C955D6B0093; Tue, 23 Jun 2026 19:16:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B366D6B0095; Tue, 23 Jun 2026 19:16:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 834EA6B0092
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 19:16:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E886314019D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:16:54 +0000 (UTC)
X-FDA: 84912739548.05.C31EFB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 601D7180006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 23:16:53 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxraI1LU;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782256613;
	b=KBrFpzj7S9g91ezJOhOPYsln2k8tRixb8TCAkGvZNvo21qb9Xc+HQCo9QldtFZxVgRCm80
	yqIKynMi4uTb/NwYgyzNVzBw1AH6rlOXi33cbw4FBteQH32pJEt8GmTDUlA/P0igm/MNOJ
	iYr7UEe/sLncGtGOKY3tShJ2OIBT3Qc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782256613;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WYdK6sbj2tbaU6r5yGrNuJWJq/EwTAP2KOlRZqmz/6s=;
	b=D1yPnjWYjl5Rw8jVfgh6o69vPzEquNGJn5TKENLo75wlrmc7sY63SZTbLWIzN54BpEdh0w
	BTF/LV4gwVH/w9ZAWjVbH03wKe4RoQfUlLwqjIJR7pVmCNP8BUUldoQvD3oN/Gh6WElrK7
	OY2PXb4/R49sAR20fQTEbwJRZm8AfNc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CxraI1LU;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 004EF60125;
	Tue, 23 Jun 2026 23:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AE0C1F000E9;
	Tue, 23 Jun 2026 23:16:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782256612;
	bh=WYdK6sbj2tbaU6r5yGrNuJWJq/EwTAP2KOlRZqmz/6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CxraI1LUvFrK6wEz24Oe7ikK4UTNccyvnZayxVeY6vh/ClkmuKHn1XP7fvobJum/y
	 l2P6tQki5T7bdI7OVkkNpr+ry5bUc5gX0yfqFGOpdwelA8C2JfEAfDGTt+iUxIrofr
	 mZNJL+OjWGaXx518VIH8dYPviLI6UZmEdkP9pbnh/lHFr3yiOQVfkJXCGg8Y7kyoOS
	 F4K0nQRQVoXw+D1n2RgkqjXcXrttnAPkS7IJM6ZFwG9xo9WHKw6qqxMkB1OTsngKG1
	 acoK62IvadUTzv0nlZ3G2q0zHF26sYIpYQyZ6zW2SDLJ1fvqtWLnihRsBUJbDngyPB
	 7mFWCf5AbEdOQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: baoquan.he@linux.dev,
	chrisl@kernel.org,
	david@kernel.org,
	jp.kobryn@linux.dev,
	kasong@tencent.com,
	liam@infradead.org,
	linux-kernel@vger.kernel.org,
	ljs@kernel.org,
	mhocko@suse.com,
	nphamcs@gmail.com,
	rppt@kernel.org,
	shakeel.butt@linux.dev,
	shikemeng@huaweicloud.com,
	surenb@google.com,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	youngjun.park@lge.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v2 2/4] mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
Date: Wed, 24 Jun 2026 07:16:33 +0800
Message-Id: <20260623231635.43086-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260623231635.43086-1-baohua@kernel.org>
References: <20260623231635.43086-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ow1wabdzy5o1ntagcatf7dxx7gjqrhez
X-Rspamd-Queue-Id: 601D7180006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782256613-504168
X-HE-Meta: U2FsdGVkX1/XOjRyNGy8/T9+n3JCdPTXDi+Cg4RwFbGfTNjlUjVfCvI71I6i9BCtVs0jBFjo5sSJwdcOZicfNfv+VMFaOBhpsCoMhMNj5raj/YCjanfunDTu+9fvcp7k8Fhj7WqMlJWzYAUlsfJ8Ml4xD14gM+h3KbbKd0/vD8edU8HsY3B8toVTa85A9ipFCG3iTYyOkY1QXCQwnE8mRndvyX8k0hQkgtPNA360uXG9xH0imf7B8FpBO4/89YOs3Cm1tTYIK9ZgGqDbZoKYyyy0cXJIUJjDOEnM9vPi8HUSwW9SZIxpWI+LaOzWa6ajS/nP5DPm8xsLqUtfF503EXHIEYcPndOVGXfq0HGUKVsk3jf8DCpqdlYUMMffGpDvVIlchVBJvDDe5D1INZGYBspQLHUu68CL10yrWPdPz1tp45rPBMYqYtupTkpSvLYfNFFlZCzAJtIWLMLf8O1VtK3y06TPFM+xnzHU12glSr1LSbVtiS9QQ+UAOYrrpyjM7vGo95DgUmzr/osaqUQB5orgtf7Y/a/d4OjJewPifa7khaAQwsUGXvHMZZ25brvmBVeCczYf7YrVCwwu5iig0QaEFsLwLaqxIRgprvuyygKGgAsSi0KvUaWG58W9QIIFALNucDtTR6tAgWXM5wfu5hkJ5vsJyuZlv1rkhyKC9Ik9X/6kP7iBvMAwkj0p7VqXegkaQsUGgKjOEKkatl1jgsbQcUljLq5xpO0trlK9g3eymBL/nnnkvc3qeKMmNXtNm84Sl+Hc3V8TuRKDdWptl1P++FFY5l4RPsaDqblj/s9JbeXfe/878gLQtHVVdpym+VDgd8+jnJzXVqwm7DbW+NNhqmfJ8vS+7XgT26QT5ss9awbfYD365XUComz1ZO0AjFbsx8EzoVP0oKSU1fxPn0JAGUltI6K9zfuX+1Y0fgrwL7d7nExYhy0vS8MBPQGXrC+YTn4DVaGPZavWPHr
 hDHL3/XO
 mCn14oQNiD4UUZgfkfschP7kSnuzL6BDHzNG/do/RAfCXsXcoB0Xu2zONc7Flu6Ien/Ij6cl839R48fo0yeGx/a3XB0qwCmhp77jGaKjLgLif46kavPsKxmkbaSlt6Ba65PTMrsA5rA9HxewDFkTSd7i8kMq/HpK5ZSa1waDqtcTz6ggC6hwCjXNGUbMvfNfR+l2JtVlUXKTzIphXGdvwVL7GY/UnW4s02kRIxmNKnCffxZQqZm1vRQyPRV0A6MSIRH6gr9gWNmYXsENJ1ld02CsW2RNtgek3bykmS+YdTyFFwoANC6NqBXRV/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The "we just allocated them without exposing them to the swapcache"
case no longer exists, as Kairui has routed synchronous I/O through
the swapcache as well in his series "unify swapin use swap cache and
cleanup flags"[1]. As a result, folio_ref_count() should never be 1
in this path, since at least two references are held (base ref plus
swapcache). Remove the folio_ref_count()==1 check and update the
comment accordingly.

[1] https://lore.kernel.org/all/20251220-swap-table-p2-v5-0-8862a265a033@tencent.com/

Acked-by: Usama Arif <usama.arif@linux.dev>
Reviewed-by: Kairui Song <kasong@tencent.com>
Reviewed-by: Baoquan He <baoquan.he@linux.dev>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index f6848f4234a6..abd0adcf65f0 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5049,12 +5049,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
 
 	/*
 	 * Same logic as in do_wp_page(); however, optimize for pages that are
-	 * certainly not shared either because we just allocated them without
-	 * exposing them to the swapcache or because the swap entry indicates
-	 * exclusivity.
+	 * certainly not because the swap entry indicates exclusivity.
 	 */
-	if (!folio_test_ksm(folio) &&
-	    (exclusive || folio_ref_count(folio) == 1)) {
+	if (!folio_test_ksm(folio) && exclusive) {
 		if ((vma->vm_flags & VM_WRITE) && !userfaultfd_pte_wp(vma, pte) &&
 		    !pte_needs_soft_dirty_wp(vma, pte)) {
 			pte = pte_mkwrite(pte, vma);
-- 
2.39.3 (Apple Git-146)


