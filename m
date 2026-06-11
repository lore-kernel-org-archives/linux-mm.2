Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BC2CCD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 10:51:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF0756B0092; Thu, 11 Jun 2026 06:51:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA0FB6B0093; Thu, 11 Jun 2026 06:51:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C69136B0095; Thu, 11 Jun 2026 06:51:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B15456B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:51:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7BB101653F1
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:51:45 +0000 (UTC)
X-FDA: 84867316170.17.F8B42D7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id D7D7A40004
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:51:43 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WgZEtF18;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781175103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0xz7/1XNa5r8BniD/2N866DuyfD32Z4NZK3CokcixYU=;
	b=OLQ33ywWRd+hu+FxBS3oxPYypuUFkGmYxy633CSv+b3QybLXtoIRQ6AIGXKHioaXHzXNH0
	jEfJJGjgVPaFijE+fEB6dFcgsBzsjceWGXwU9BhGO+Qyn+w5bj3rxI+RNFE4HYzccuNOd6
	XD3Q6uVmh8fI8TFElCjAEY83jrecoqY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=WgZEtF18;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781175103;
	b=kX6vAkX39r5Q0Xxrx2NtTLM8/QYUI7XreNYxrrZSGQjdUQGSZUkMRWozbq4hqCDKnJhsx5
	BfQBtffdA7YgSIcSKA4eJ6g4Bgvw/rGeAwCzj0pN8EFJlipMbZ2mu9xz1TEhGfYDJ4zQYV
	p83RMupAxuKICCWB/QITXxcJczxaFmA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B850C40143;
	Thu, 11 Jun 2026 10:51:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F4E1F00893;
	Thu, 11 Jun 2026 10:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781175102;
	bh=0xz7/1XNa5r8BniD/2N866DuyfD32Z4NZK3CokcixYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WgZEtF18f1MnI0Xd+bo2kF+iWwLij9SaxuFHznIM8SypLV1RU6RW2p0NLy81G9ZB0
	 Q3AZao7w7PbbsTMlMSMUakc8vIk5NW9snO6/QZV+/wKXX0Z/kdItHWoocB6ygmU8nl
	 jDbiF02hKKG0DryqLCdEH5fvy1xgwaKxi+PmLcaHoaMzvajDZYrSIg1F97aBrwJjqL
	 ayAO1TBN0JjCXmY2S0DyTa6+JwY/eYrmXbwDPEYd85U5uRgPPipuV6eig+3Zj6/iY2
	 +I3fa5U8uVBEcvniTqtDI7j1BCQdlPqCw0VKUsO2BfeQGhKmP7ucf8gqi2Pjr25HcI
	 53BnIOUKnFiqg==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	youngjun.park@lge.com,
	jp.kobryn@linux.dev,
	usama.arif@linux.dev,
	shakeel.butt@linux.dev,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 2/3] mm: drop stale folio_ref_count()==1 check in do_swap_page reuse logic
Date: Thu, 11 Jun 2026 18:51:23 +0800
Message-Id: <20260611105124.98668-3-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260611105124.98668-1-baohua@kernel.org>
References: <20260611105124.98668-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 3akmc1iq4txgepfao98p9cducn7w4ryg
X-Rspamd-Queue-Id: D7D7A40004
X-HE-Tag: 1781175103-635278
X-HE-Meta: U2FsdGVkX1+W73E4epLqskgYlrqe6VljeW3Lvxkw8Emg32UqpIhEPt4d79yggQk6V1sLZv4whS/haw0iywy32518chnk/koNjYwgdwQ5HPC3GW4P9c8Jqcg/4n351OqfEq754X/mDKxX4/pEynDfDMAa6ruOu0jKE2Y5DGEmrC1yXuoCmdNPMMhPvzMDUBiSZyXxNNlKDX/hPpzXlZw9Kk3Cd/Jke6sSksl0izzKTEfB4/69Id+LBZx2AnEE/U7vnid5bb/ZmrOmtVjAuKz6A+06mCafAp4j5a1FjyEK0kooqw5Ru9P061bk3Mq0rjGX0GQVo4e2KIvjSg525+oA3P3XH9nO+6NfGos7UAptqZsXHyOl8CXv6JRqPL7zB0GGmM8vVSv+GrNAdGJxpHNyrRVzKykEUE4DZPgp0aT7iSMws4PY3pg8Jigo2iINP3qs75kunDEFsubbEDrrdbKEZ418Y8qGqtapS7I6P3WVhdMUGe+tJcFdlgzeGm9pnpB15mgUIXPu/4eZih7L40W9RFGW0hJKUZvm/5F14r38hQn/DFgCCi8JKgQzg52WeN/xRyvNLPf3LIju4oxyXjU4CYA/8NKkmeiZmLVB5Qcvacy9Wabbcuk7icNEzYEt/uh2YAD5dXDjQN4QpqCbV/EE/Z1zhW4BPJsFx59iFfHXvUYZGn9X8RmW6WB4X9Smltb0b5aJ6Lg1Ab8Ri5XqdLC3S7Zq5VjXVe1+miJNRqr0B5AY1f9dYuXu9ZHuByqwGbGpXTOg6B8E1cDlbvkJFA14YG1BQ39dT4cEuIKBebtVZGxOZII4BuGAdJNlQvNU9vz48MAeSB1k6tZvc93ii/iIdWdp0r36cnO+eCEhyFcTAfjWJkflN+NNM0CYJUkLIaSYRjDEaAbTi9luz0PS4XuQv8mPKCqH6kCxbGEwiEkbvyQwiDvIaD618WQyPHX3vCEkQTb/pKeAj1XDCeiBP0U
 SR5K7XMc
 ErcBqG9Muxlp8TfbGqwVyggZ1pZ+6DRtSPxJt50QhwLwYvbWLWhlqKFBJC8QMAbnSu+dknjDWuunCP+3DL+MVupDgcCJprmNpmbVI6Q0Y8ebIM/y0XSe805aKqMvDDqFLO6o8erZvfQnVE9Sc4uavJzPOiNnUOFciDRZqDc1svC6TlEdmYmy8HLaHW039fGxSL+CnpFjJsna/4RjYLaeKJNk/OZrAU7JtMRS5Qh+X3popfV/a+hss/iXpygdysDzaav48vLs2fNRyK3WUYXih9qayETjHkK9s77QWFvK8I8AqYLBGimev2Lfh6Q==
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
Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/memory.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 487a34377a7b..ce8ef27e7a54 100644
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


