Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD1C0606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 16:03:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YS1mv0Zd
Received: by kanga.kvack.org (Postfix)
	id D3A456B05B3; Sat, 21 Nov 2026 11:03:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D117F6B05B4; Sat, 21 Nov 2026 11:03:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C003C6B05B5; Sat, 21 Nov 2026 11:03:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 88B226B05B3
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 11:03:21 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B66311A0536
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:20 +0000 (UTC)
X-FDA: 85459595760.04.0517089
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id E235540003
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 16:03:18 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YS1mv0Zd;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795276999;
	b=qYErRXZGzpgDkGGQ8NVxPt9genc+kvBCA0ODzbX+uU4D30dEt7FeY7eRq4ylwQpmgWzXDF
	4p7RVzqP8n+2OHITUnjrux+R9gFr9JjM5RSesQtKgV7+X8x42tbMh7sdoPuJTDzOyk4iDo
	ho833pdl5hoK5PJRooS2waPVvCtvddo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795276999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kQtR/PmrOPe+b32IwJ53yV0sN7VuoVDU7/08bj0Hnhk=;
	b=lWCQ7PBvfCWN40pyNGch6U4mJfwP0AVNqsNi2teHb/9EXCSuRdbS0hRNg3cFQTno//1v4m
	NWu+OkDOlpI3IYH1bcA6aaXZEAA1G6aGh/Y2dQCER5Opc+Xosen9bVwa2RjDrogm1EbLsf
	xSZVjweyU2FRSDMPo+aL2jNhLC+glQU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YS1mv0Zd;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FDD3611B8;
	Sat, 21 Nov 2026 16:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A73921F000CA;
	Sat, 21 Nov 2026 16:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795276997;
	bh=kQtR/PmrOPe+b32IwJ53yV0sN7VuoVDU7/08bj0Hnhk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YS1mv0ZdGcWiRFfMStIUvrZh479IvpEBJ+qvvuZSLk3Ft1Tu3sV9xUII0/od9Li7x
	 IW/UVTcAwjr8v2YRO2IyWXI3b7vQb0rO4C6w2iXu20Tfbx/Ce0C6WmM3eXEuNnrhGB
	 4+3W3AoUKudpInzxiGGZFSfLFb7kRM9DLULE0XuK36tY+DH2BnozSq09JTLZebS6mz
	 OUkoFaF0bVPF1KcsrRb4o/PZnWc2vB7nb37gTubrevKQmsM0MVD5xdI+VwnOjclonr
	 ZWBXySKoBxZPjMSeoFp2RT/Q7EQSdzodWNyTyMfXZDR/0tckf/sexKWsa5xXkzhIz3
	 YcwompBGiE1xQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Sat, 21 Nov 2026 16:02:27 +0000
Subject: [PATCH 1/7] mm/vma: error out on invalid bounds in
 unmapped_area_topdown()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261121-some-more-ai-fixes-v1-1-236e925d9b64@kernel.org>
References: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
In-Reply-To: <20261121-some-more-ai-fixes-v1-0-236e925d9b64@kernel.org>
To: "Liam R. Howlett" <liam@infradead.org>, 
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Kees Cook <kees@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, 
 Ollie Wild <aaw@google.com>, Adrian Bunk <bunk@stusta.de>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, Joey Gouly <joey.gouly@arm.com>, 
 Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-mm@kvack.org, Chris Mason <mason@kernel.org>, 
 Josef Bacik <josef@toxicpanda.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4829; i=ljs@kernel.org;
 h=from:subject:message-id; bh=+4kE7CdMswTMuf4/1YP3lHCd+R2WBN1rK5h5dCacX84=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLIZD2zPlJS15juidKU60Phw59Yj3sHiL977RD16K3Tqy
 ubC8vQFHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZjIn2qG/545Zsfz1eNMDAP4
 fdf8m8fCVfal7tXl35M90gI0jPTX6DH8d7R/cP5hF7+E2en6mGYJs0PTw285Ny18eGKn0LqjUw9
 MZQQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Queue-Id: E235540003
X-Stat-Signature: qycb6fwb69gfkukhgkhobcs4rato17dc
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795276998-24647
X-HE-Meta: U2FsdGVkX19nqrPPDD33p0fuAaBHZPLyM8OFf1U0YiwXGCrOarJWdeY1TqCyqRmc444kf/tj6qElI1vzrOvY/yHBfcPhMnQYCEK8OF4zD+SqjwOmEIS8wUFxvUzSOHlTDrrP8fjC5A76KESBo1HXYDCewEOe8FuDFP6Dpu27gS0md2a6V2dT2wtddC5+HC0jg9tlGoTAwimst5e/3zpT+qAgQyoDMsEfW0wXLbAkcAq9Vai1ZgSz34axyJ22lbsD6r1/EtRAQjsHKzGUEJT4acTJ4ENZnwAirzRWkVwWn38kjah5Fv17+G+3ctC5vChTNZ9mN3yLAuafzeM6AQZsPcOCZwkQmN+/PspcMHEoSJ0XvTUnZH3QoKg+zRzRFPV6UsQjRB3jEfIjYfNDnfSZgGtHdfXuzz75YU3i8zS2vE2X9GJcSHUK3jZvJxAq/oa9v+T3fPoEofhR2cEVuNFxzLjZLE4SA2XoZiG+vkKGGgEfbqG68nEHi/4Ax7iSTs/kpdQzrykxEH4hV6LSKz+QP2ImKvBC5KTSjmENYs0tkfTR4F22bd3MKYOKVlN7AarZlrfypEpdmY996bmpIP5rM8ECcDxG/jC1n3YIbay3FC7gK8AYylAvJ7ApgRLqH0bY9MesmFXNJv2i7f+whj1ZUM3ldpWeQEcUHfwv4w39jaVIwVzFReK1n04a9sp4Du/vvYLo/Rw24IyIcIJDyF9nw3p87IhkjjPrSXPOMqRxSe1khL2O/u4fIbyB1A74uuTjW8DMa6x++F3URDGIuFYKRBT37hqlZ3k32sTL8ZOPJKcxheUO7+/6HoPE829h50HYhKE7afn4ufhA9wbS2Om394cld15aY3WLxc1G/50Sqgcq8GV68tGLDBJfGnMecrAbNXpfJADHgqd9zWHDX/QrwrRs/0wKUi4d2mwF9JAMfL9ipUL1PyZNvI1Vt3Q/9inFLO8/TMxfGbtgB7OMIt6
 kUQdeWZu
 oq3Q4KMY0ZnDvyCeXDD90Z8CVQtmmcjF7hi5XLUIGbq7x6cnXLmGNJjA8VEPhNz1zFZrsFv/TWndP2Q7sZvLyvoqJ2tgsQvtrLJlU7oEhmoVeg4f1f579UIw8xIjSB2HVDVCyYqZhcqvxSQSQBOJF6wGm3sXMlhMUCmwBuj6QKuEp/Sa/qmB8KVfLOnZj3RmuF9lzuIyhZ3HwBO1+yVNXwQWpOoDe4sUwwWQvZyFY0CXZ4pRzwX6KxDIryzDTGb8d1gHDbeOCvOtQgd9d0f3ByeWmwHpbPkcFoHURu+Uxk+lhXdgtoWCbArIjRcggIoP+ePDqSiet8laWrEdcb4lT0Pr3HO1+A2dYczci0vdFamG9IUqhO6R3gtqTOiAxOJGnLNEoawrG89w6XN/uc5Ed9NZ4qsvVTzRxUgErSIZ4zLfKWtyuq1mM+yKgx3e+aR6eV5Fa+75tHfNLZwIflCieDHiDVxGhH+newISE6SeIyOond5ChU7cnvUpFlOO0YPjY5YE6++zYSDL5V9U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

unmapped_area_topdown() suffers from a class of bug arising from a mismatch
between how maple tree functions and VMA iterator functions express ranges
- the former inclusively, the latter exclusively.

This is problematic with an exclusive upper bound of 0, as it translates
to an inclusive upper bound of ULONG_MAX, that is a range which extends to
the end of the address space, and start < end or equivalent comparisons
evaluate false in a situation where in fact the expression should evaluate
true.

unmapped_area_topdown() calls vma_iter_area_highest() to position the VMA
iterator into the next highest empty range spanning [low_limit,
high_limit), iteratively reducing high_limit without checking whether it
has reached 0.

This can result in a [low_limit, 0) pair being passed to
vma_iter_area_highest() and thus unexpected underflow. Consider:

    vm_start        = 0x30000
    stack_guard_gap = 0x100000
    info->length    = 0x1000
    high_limit      = vm_start_gap() = 0
    high_limit - 1  = ULONG_MAX
    window          = [low_limit, ULONG_MAX]
    vma_iter_end()  = ULONG_MAX + 1 = 0
    gap             = 0 - info->length = 0xfffffffffffff000

The result is page aligned and below the IS_ERR_VALUE() range, so it
does not look like an error. What follows depends on the caller:

 - mmap() with no hint can fail with -ENOMEM while space is free. The
   bottom-up fallback is skipped, and __get_unmapped_area() refuses the
   address as above TASK_SIZE.
 - On x86-64, find_nearest_trampoline() can pick the address for the
   uprobe trampoline. _install_special_mapping() then inserts a VMA
   whose vm_end is 0, and exit_mmap() frees kernel page tables that
   every mm shares.
 - On powerpc64 with the hash MMU, slice_get_unmapped_area() can pass
   the address to alloc_extended_context(), which then writes out of
   bounds of mm->context.extended_id[].

mmap() can succeed with an address from the wrapped window where the
range above TASK_SIZE is too short for the request and its alignment
padding. On s390 that range is one page, so this takes no more than the
default stack_guard_gap.

Fix the issue by converting the loop into one that explicitly tests
low_limit < high_limit.

Additionally, simplify the logic by declaring the VMA iterator in the
loop (it is reset on each iteration anyway) and exiting with the correct
output value on success rather than performing a goto when an iteration is
required.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 58c5d0d6d522 ("mm/mmap: regression fix for unmapped_area{_topdown}")
Cc: <stable@vger.kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/vma.c | 42 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 22 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index c82e9306b11a..09bbcdb4971b 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3369,8 +3369,6 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 {
 	unsigned long length, gap, gap_end;
 	unsigned long low_limit, high_limit;
-	struct vm_area_struct *tmp;
-	VMA_ITERATOR(vmi, current->mm, 0);
 
 	/* Adjust search length to account for worst case alignment overhead */
 	length = info->length + info->align_mask + info->start_gap;
@@ -3381,31 +3379,31 @@ unsigned long unmapped_area_topdown(struct vm_unmapped_area_info *info)
 	if (low_limit < mmap_min_addr)
 		low_limit = mmap_min_addr;
 	high_limit = info->high_limit;
-retry:
-	if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
-		return -ENOMEM;
 
-	gap = vma_iter_end(&vmi) - info->length;
-	gap -= (gap - info->align_offset) & info->align_mask;
-	gap_end = vma_iter_end(&vmi);
-	tmp = vma_next(&vmi);
-	 /* Avoid prev check if possible */
-	if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
-		if (vm_start_gap(tmp) < gap_end) {
+	while (low_limit < high_limit) {
+		VMA_ITERATOR(vmi, current->mm, 0);
+		struct vm_area_struct *tmp;
+
+		if (vma_iter_area_highest(&vmi, low_limit, high_limit, length))
+			break;
+
+		gap = vma_iter_end(&vmi) - info->length;
+		gap -= (gap - info->align_offset) & info->align_mask;
+		gap_end = vma_iter_end(&vmi);
+		tmp = vma_next(&vmi);
+		/* Avoid prev check if possible */
+		if (tmp && vma_test_any_mask(tmp, VMA_STARTGAP_FLAGS)) {
+			if (vm_start_gap(tmp) >= gap_end)
+				return gap;
 			high_limit = vm_start_gap(tmp);
-			vma_iter_reset(&vmi);
-			goto retry;
-		}
-	} else {
-		tmp = vma_prev(&vmi);
-		if (tmp && vm_end_gap(tmp) > gap) {
+		} else {
+			tmp = vma_prev(&vmi);
+			if (!tmp || vm_end_gap(tmp) <= gap)
+				return gap;
 			high_limit = tmp->vm_start;
-			vma_iter_reset(&vmi);
-			goto retry;
 		}
 	}
-
-	return gap;
+	return -ENOMEM;
 }
 
 /*

-- 
2.56.0


