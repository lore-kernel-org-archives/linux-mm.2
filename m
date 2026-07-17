Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 937BFC4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 17:27:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C8546B0092; Fri, 17 Jul 2026 13:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7522E6B00C7; Fri, 17 Jul 2026 13:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640846B00C8; Fri, 17 Jul 2026 13:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2878C6B0092
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:27:38 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9E0AF401E6
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:37 +0000 (UTC)
X-FDA: 84998950554.04.518B9E4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0398100011
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 17:27:35 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpEOJsk2;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784309255;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=22AOIFpaEY/MXo5bsXfXAlnPYUw1Afv74uPUeSMlE9s=;
	b=n0rr8GWWoTbERsku920wrzi+isdxfYCwV+VMB8k1hUIgD5XnXZyJfQBykocDdZp+AiZJeo
	z96PiEyBpeGlAglWtWg/odTHh98zIGlqqcGtWdPUFmaUdW0HOY4NS/xDoQbjKERI3NOxpr
	Lb0COXTPGv3SmSVSRzLNsh4BAP2aTd4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IpEOJsk2;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784309255;
	b=yOQomoPOos81u9r2TIBAiJGyHJlHoxjxOl4lggz+bK1Fnl2avYhGUv0UWuSakME5ud/LBb
	vIgQ/IfTRX08JixBbk+2WvxvyaD+gEpHwaGVaHjsSujx08A3w9s1HhBKJhMOb3L6BodXAG
	4bEzQC9Q/xfhs6J2XRsoHpdPp+QjLZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3094942E10;
	Fri, 17 Jul 2026 17:27:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D4261F00A3A;
	Fri, 17 Jul 2026 17:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784309255;
	bh=22AOIFpaEY/MXo5bsXfXAlnPYUw1Afv74uPUeSMlE9s=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=IpEOJsk2frc8eyhvJm4BcPXFLrXxsdBkHqL19fZg1vnPXC+48dHkloZxVht2sgCIn
	 3Bu+5pASl13J+//bgdKiwEZ1UCxEPTW7XzhSqO7JHRrO3u0okpezfFpsJBdKHsmBy5
	 EPAyRmjuTtojLouYKrO6iHtMhB10PfCaLnwL92/CYOErIFgfYGr6MyPpthqKOWeaMt
	 zhlDu3S2Gs+yoi0BUvk4ne/FRV9hPc8kS2qu/AtOYTlA9Obkr8jD7Yc/fniXStQsqb
	 lDN0Ai0KQGHrwbbhW1nTPx2BZrJf0538sghQwnu04NAKOGdDvChp6D27opKGXs9n4j
	 19AdIWrDlBsiA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 17 Jul 2026 18:27:09 +0100
Subject: [PATCH v2 1/3] mm/mseal: remove superfluous comments, fix
 confusion around mm
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260717-mseal-fixups-v2-1-0daa0014b813@kernel.org>
References: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
In-Reply-To: <20260717-mseal-fixups-v2-0-0daa0014b813@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=3558; i=ljs@kernel.org;
 h=from:subject:message-id; bh=yUQSFiVMSo4TV1a3z7ol+UBtUlj0DW3ZdJam6kMHRng=;
 b=kA0DAAoWz53NioHifxQByyZiAGpaZfSgorz2kS+U4gg7UETrRRwkLBS0VyFbGJotbwMb7eS9K
 4h1BAAWCgAdFiEE5/QXv1IUVp6J0E9Gz53NioHifxQFAmpaZfQACgkQz53NioHifxR//wEAupG9
 sJD43zKwgDi1oGAHZDvCDYERsMWdIkTPWSz+/1IA/jTXq4+KsWA2XeJowvtlFH/SxE5JTMDwG6n
 7bP8c41gC
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: D0398100011
X-Stat-Signature: tz4aafnwn6pwx3wandgghq8oy18z8nzp
X-HE-Tag: 1784309255-384924
X-HE-Meta: U2FsdGVkX1/W53G1FfqlltSj7SggmDUjSVJN9a7juadjVg1Y7VegA9Z+a/utaa+HUvwjD99QYBhv4QRhKIhxpohk3B5mjJgrQJrK49HAj57GDh4UgX+eZpwnj3jTIY2UHzbQLSVrjT0S6222s0MRLrBo7NsOU6l4Y+g2NbquaBcoTwa8YQBeOX+VDPWPpP9oGkuo/tUH1idY/6tAroSGEzrcVK06GBXriQP7qNqdqHwdEnOQHeuXueHOKaSvuBcGmhd3ukwzZD3o8Kltgcz2xS29J5ZtGxmtcL80NLHUF9nctIb4sYTYfxcuTqNC1ReNvUcx/AWDUyvt6JIyJ8EW8t6bpCgPNYVKGtbN6YJgDk7MpIZDiJNWZFkbMfHyN+kAci2tmTk9DaYCJR0CTCKriU5FPDmR0pOBT+aG5NXv8xerfqSELMTDSF/rGsZZCSYnML+SSwq5RwhaueY85ilOzIYA2i+g1EeHkbSVZ2cKonf7EfWalgxl2a8siSaoOtY5ZfH5BjdRvQOmzRoWyKp35tCwcmL9FsmqWFKzSMhLB8nRM2sB3IQI9JWGVigpjhkrbEDGXiFkBDevM0YkT8lVmYbKrkuTjUifeZ3qOJOC5Hw8BttgBOPvHvoR9STqqEgXgQOlYSJs81mzW1hAE6RvKK347ntCZO6lNhSekJEwXlwvCFsA6CczC9+04ZjpDyc4vMF60M2WdbtVnoKF6WEcW+NVl92Gcz1bYy2lws04L5VUgBsvd9E7/G/0H0NGjD7wrv6pTpGYul9vxfO9aiUSCYKcwzKISRneZwkw0ft906cudRat/nFnY7cBk7KaXiz6ZRq4FZNzFHhWTV9VF7ELrLK6FlRMHdYsMwqoV1HIoKLY80OrzvvPrkp40U6S830I/mdgWw/f2BNwYRQ8m82GLD0gGjETfTYtH3NJt+Na1e9P+0Cy/Y/O9F9KrcVmLu0RE5o47dVVML+dtatI6SK
 lKJfjElD
 htyuQmCYyN1abhKdHdfaM3KIjFtQ8hFIqcBPd8KomSUas69NpruD1KDtqka+iXqv1sAMW+/Vvu/bkCuX+tnp/e4HeBbOn8Zkmft6991hO+XjzjWJ66kiz9gLnHrW/ZBiqcsVNFeJcUu0EsGPetWVuqcVgwYFnzAtcmyAvKiVYMTB5X79f77E+Wu5PMclDpV2Uz5URJCF6/M0SNfNb0AERPmSBFSDZNNw41vlt0IgP/2PX61f7Z73cH5q9/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Remove comment blocks that don't add value and eliminate any confusion
about whether or not we permit mseal()'ing of remote mm's by not passing
through an mm parameter but rather referencing current->mm in each
function.

Also while we're here, avoid an ugly goto by using an else branch, and move
local parameters declarations into reverse xmas tree order.

No functional change intended.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mseal.c | 53 +++++++++++------------------------------------------
 1 file changed, 11 insertions(+), 42 deletions(-)

diff --git a/mm/mseal.c b/mm/mseal.c
index 9781647483d1..430a252a6da4 100644
--- a/mm/mseal.c
+++ b/mm/mseal.c
@@ -16,32 +16,11 @@
 #include <linux/sched.h>
 #include "internal.h"
 
-/*
- * mseal() disallows an input range which contain unmapped ranges (VMA holes).
- *
- * It disallows unmapped regions from start to end whether they exist at the
- * start, in the middle, or at the end of the range, or any combination thereof.
- *
- * This is because after sealing a range, there's nothing to stop memory mapping
- * of ranges in the remaining gaps later, meaning that the user might then
- * wrongly consider the entirety of the mseal()'d range to be sealed when it
- * in fact isn't.
- */
-
-/*
- * Does the [start, end) range contain any unmapped memory?
- *
- * We ensure that:
- * - start is part of a valid VMA.
- * - end is part of a valid VMA.
- * - no gap (unallocated memory) exists between start and end.
- */
-static bool range_contains_unmapped(struct mm_struct *mm,
-		unsigned long start, unsigned long end)
+static bool range_contains_unmapped(unsigned long start, unsigned long end)
 {
-	struct vm_area_struct *vma;
-	unsigned long prev_end = start;
 	VMA_ITERATOR(vmi, current->mm, start);
+	unsigned long prev_end = start;
+	struct vm_area_struct *vma;
 
 	for_each_vma_range(vmi, vma, end) {
 		if (vma->vm_start > prev_end)
@@ -53,11 +32,10 @@ static bool range_contains_unmapped(struct mm_struct *mm,
 	return prev_end < end;
 }
 
-static int mseal_apply(struct mm_struct *mm,
-		unsigned long start, unsigned long end)
+static int mseal_apply(unsigned long start, unsigned long end)
 {
+	VMA_ITERATOR(vmi, current->mm, start);
 	struct vm_area_struct *vma, *prev;
-	VMA_ITERATOR(vmi, mm, start);
 
 	/* We know there are no gaps so this will be non-NULL. */
 	vma = vma_iter_load(&vmi);
@@ -142,10 +120,10 @@ static int mseal_apply(struct mm_struct *mm,
  */
 int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 {
-	size_t len;
-	int ret = 0;
-	unsigned long end;
 	struct mm_struct *mm = current->mm;
+	unsigned long end;
+	int ret = 0;
+	size_t len;
 
 	/* Verify flags not set. */
 	if (flags)
@@ -170,20 +148,11 @@ int do_mseal(unsigned long start, size_t len_in, unsigned long flags)
 	if (mmap_write_lock_killable(mm))
 		return -EINTR;
 
-	if (range_contains_unmapped(mm, start, end)) {
+	if (range_contains_unmapped(start, end))
 		ret = -ENOMEM;
-		goto out;
-	}
-
-	/*
-	 * Second pass, this should success, unless there are errors
-	 * from vma_modify_flags, e.g. merge/split error, or process
-	 * reaching the max supported VMAs, however, those cases shall
-	 * be rare.
-	 */
-	ret = mseal_apply(mm, start, end);
+	else
+		ret = mseal_apply(start, end);
 
-out:
 	mmap_write_unlock(mm);
 	return ret;
 }

-- 
2.55.0


