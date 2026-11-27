Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 54EF9606A31F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ayy9Q0Mu
Received: by kanga.kvack.org (Postfix)
	id 128F26B05B8; Fri, 27 Nov 2026 14:46:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D90F6B05B9; Fri, 27 Nov 2026 14:46:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4D26B05BA; Fri, 27 Nov 2026 14:46:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 645726B05B8
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:46:27 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA22C1204B0
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:46:26 +0000 (UTC)
X-FDA: 85481930772.25.EC93FBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0DF532000B
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:46:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ayy9Q0Mu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795808785;
	b=DVzdJMDyssCWc3Ll6c1U0Gqwq5VJjmEHSuyVNOPVZHjowq9l2zto6GhBzqLQdffsa/V5iy
	23v1fhNifPAALs5Z21END2qeoK10Q4Ji89xoJW8bQbwKFP6712r5JiaiK5Xi/LA3Gp0hmV
	UTlEnKVWtkkutIenZYvUlarKBuId5ZI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795808785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k3mLM1wyRXEsg+PNLXtW45Wd/AVD4xoxhnOqafugdiQ=;
	b=6BROP4e0pboJGN551/+fhAH7R6pHjlc9yaHVjvMXJedQDIfzgZwZVRj3N+bSVleunkV7J9
	88UL5eTc2kJHHq/Q2qSrowwpUzy0nL+EZDyt0fSWA148YBOjvnCBlFRt1/gdGNAmaPZozn
	yWdg5K3SOC3MdCxn+kWDPo9y455sWgs=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ayy9Q0Mu;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9BD5D61F83;
	Fri, 27 Nov 2026 19:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C03D1F00924;
	Fri, 27 Nov 2026 19:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795808784;
	bh=k3mLM1wyRXEsg+PNLXtW45Wd/AVD4xoxhnOqafugdiQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=ayy9Q0MuJnX7YhI1XdSAFEYJ6S2e28R4qby8PzluI4BQ0YFOhYr0KTv7fbVo97Im/
	 mSRkHq3NiQJIY1xJ1pJPkRdUNk8scBCJe8/NqAjuttTECCKLhmFBDkv+1h3Y6Sax2X
	 sTdQp8UYr5Or8RVpRWODiqTpxeNi9Lp+znszkSItlz4OCutmyhO3ZRcpaaY+cPtcmc
	 PAx2Ab/mrzHAanNJHrfhBsUQ4AK8OceqKgDMfzfsBeT6nSHZCpuqxMTeofF19u08av
	 JkZ5N/kNKCccI0t6D4kzSwSCbwBMJ4BQ/12C49t1v67J6o4wso0UzU3uTTKHiLridj
	 GbMl9w5ZdETFQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 27 Nov 2026 19:45:43 +0000
Subject: [PATCH 4/4] fs/proc/task_mmu: write-protect only with ptrace
 attach
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-mlock-madvise-mprotect-ai-fixes-v1-4-e46b2b1eb435@kernel.org>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
To: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Rheinsberg <david@readahead.eu>, Hugh Dickins <hughd@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Alex Shi <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
 Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: codalist@coda.cs.cmu.edu, linux-mm@kvack.org, 
 Andrei Vagin <avagin@gmail.com>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Chris Mason <mason@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=5134; i=ljs@kernel.org;
 h=from:subject:message-id; bh=LDwlOoGL+Fn5OvyHg2RGXRShc7rrh/h1bpGPWGzw/QM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI5776UnsqgY2scx+B02GzrzbLIuS/0wj8LnUzS7Hh9e
 HK8XWZjRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACZypI7hf/EOM55TOmyXlYO2
 mCz+6t6xb5rhWeZHN9WPx2Qfz3gWcp+R4aPbRvGwTVnn478uz2ZXvLlzb9jsRaJ/pTZ4bTV5ckw
 xiBsA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User:
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0DF532000B
X-Stat-Signature: 4ceupgcwa7ss6xorcfkfbousmzdhzjdm
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795808784-169384
X-HE-Meta: U2FsdGVkX1/jknomXBqBQg3vpeh87tJApZ1ys8wR1VUJdol+fTXQ4LvPnN3KLfw7UuOh3qiTrRpLD7Zcbsz3ojtXen5oioyT7z/SL7bIb14bJdABju1Vs7FTrbu38UbB58A0AAYIHboe0aAZNZ//IgMbfiknjSQwel4yG9qIC6QQ5BZB7AQZLeS+4FGfa/i/126jtFoPhvn7HncK2giQXU57hBPEBc/EqdFLQtYbgX76g+7xr3NxJBkQcoDsRGTmL/X7u181Y2iN9aqBjE8wiaCvcLcGPhCYXbXhTjPb/pdLJTC+lI9aHSBRt9slBkFzHN4VuhJg76bq/Kc20FXABvzEQrd8mtDgAts63IQfnAtdPc6ATKcqEMkcOQuui6lRmdVnvcp4AhcBSZEdgVk1l2tg/AcN0XEO/hETyKmC5BMaR9/toPGDbK7XuBIH6R1a+bb005TfaGaZKXkir5Xh5/PP7JReduNYbjBQnLeo9YCh/g251ecMbna2wmXHA+3bnrRnpu8d3Cl1W12P62hHIiwFvHjjcdagi57bifMNn4yeMhE+QbIGImduXAAeLa0dlLNGDKktsrdCT9i/fzOagOWc8bpCGbVyjYIzGs2RcAGSzU8hSeW/v3sFeQgkrIrN/1lfRckd50PKLYykLw9CeGBZq1L6H63CkKvvQ8k4TfptJwPt0pmgG/rbIrbRiUukNUYzJRuibm89ykZ2AAGDofoBbEtyRj+IZgAAL/mBXYJpIoUy1EHl7T7QpPJn+RReC28mJXs/avU3hpTINt5vwhwe18AFx6W+04/f+wyNweWS0oEU7Kv53Bwwo+ik5uYIUmNgtZwur2Bgc4kj9mKAzV39G5Ly/j2qTOBx4KL0aSMHK9uv00R7CxBFtwbwAlx4cHOvrWFasrockzTtM/FpBP2KhMROWQZM0/LvzY6apSqQUoDk87Hg56OsmbsCl5+rzKk4yGZwi28kAhQcBB4
 2NresBc6
 STDr77GrJoNXv/MeNd0X8jedAygiF/k3bgsjqHYCn+8Wo2RaqL4q0KY2XWE49khlOf3SnkSgPd5cfrlbT28YuCVd+UHyZsrWDZN5Neg9VEE/h17hf2IWih21GxWmBx2siDi18wiO1RMdH+qUBZsCYEoLSQXFuHtJBu3vgFBZ/t8bWA5+dz6VoG1DmUh69k1Pg/fcTt1+0HYRrMedlMq/KG+Vei8LDOF+oAmvSdondYHVs+ISEdFs+fnAnQJ8sZCLzWY34xfk4XnHt1SNWjWHQsGHhyLRlD6GSinHRwScIP6mBNUwS57d3UfOcVf1996X/fRrOzAtKDqXDCmfopikurEbSRERDh4z5oKSSAAHSWh0qnKuPi40jlt5+NFwv1nLYIV0LWrdELR9VmnRfJ5VnsDYx7sx33dcF3hoGPiHgIJHL1X8GQyWAmtvVFvVuxR5tesajWt+emylJOVk7APUmH2S0Wr3xnEF4gdfx8aTnhEgNN8ZShcdixLZRkWf1hiy2XdOvMzHxkq+gMKo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The abomination known as PM_SCAN_WP_MATCHING, which makes PAGEMAP_SCAN not
scan but mutate for eldritch uffd-wp purposes, also lacks a permission
check when scanning the mm of another process.

It defaults to PTRACE_MODE_READ, which is insufficient for this accursed
operation.

Therefore actually check for permissions correctly, and also make sure the
mm is as expected when doing so.

As it stands, a task may currently manipulate page tables of the remote
process, write-protecting uffd-wp marked pages, allocating page tables and
splitting THP, and invoking MMU notifiers as needed.

The check is made at the time of the ioctl against its caller, as
lock_trace() does for other /proc files, rather than at open.

A tracker which passes READ but not ATTACH on another process now gets
EACCES for PM_SCAN_WP_MATCHING, whether it opened the pagemap file itself
or was handed the descriptor.

Also update the pagemap documentation to reflect the change.

Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
Reported-by: Chris Mason <mason@kernel.org>
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 Documentation/admin-guide/mm/pagemap.rst |  4 ++-
 fs/proc/task_mmu.c                       | 47 ++++++++++++++++++++++++++++----
 2 files changed, 44 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/mm/pagemap.rst b/Documentation/admin-guide/mm/pagemap.rst
index 77447c454632..f000296e5ab3 100644
--- a/Documentation/admin-guide/mm/pagemap.rst
+++ b/Documentation/admin-guide/mm/pagemap.rst
@@ -240,7 +240,9 @@ in this IOCTL:
 - Write-protect the pages. The ``PM_SCAN_WP_MATCHING`` is used to write-protect
   the pages of interest. The ``PM_SCAN_CHECK_WPASYNC`` aborts the operation if
   non-Async Write Protected pages are found. The ``PM_SCAN_WP_MATCHING`` can be
-  used with or without ``PM_SCAN_CHECK_WPASYNC``.
+  used with or without ``PM_SCAN_CHECK_WPASYNC``. On the pagemap file of another
+  process, ``PM_SCAN_WP_MATCHING`` requires that the caller is allowed to attach
+  to that process with ptrace. Otherwise the IOCTL fails with ``EACCES``.
 - Both of those operations can be combined into one atomic operation where we can
   get and write protect the pages as well.
 
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e3d894ed2b91..19acdddd4b23 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -3120,11 +3120,41 @@ static long pagemap_scan_flush_buffer(struct pagemap_scan_private *p)
 	return n;
 }
 
-static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
+/*
+ * Ensure the caller has PTRACE_MODE_ATTACH_FSCREDS permission for wp scan, and
+ * that the file's mm still matches the process's.
+ */
+static int pagemap_scan_check_wp(struct file *file, struct mm_struct *mm)
+{
+	struct task_struct *task;
+	struct mm_struct *task_mm;
+	bool same_mm;
+
+	if (mm == current->mm)
+		return 0;
+
+	task = get_proc_task(file_inode(file));
+	if (!task)
+		return -ESRCH;
+
+	task_mm = mm_access(task, PTRACE_MODE_ATTACH_FSCREDS);
+	put_task_struct(task);
+	if (IS_ERR(task_mm))
+		return PTR_ERR(task_mm);
+
+	same_mm = task_mm == mm;
+	mmput(task_mm);
+
+	return same_mm ? 0 : -EACCES;
+}
+
+static long do_pagemap_scan(struct file *file, unsigned long uarg)
 {
 	struct pagemap_scan_private p = {0};
+	struct mm_struct *mm = file->private_data;
 	unsigned long walk_start;
 	size_t n_ranges_out = 0;
+	bool scan_wp;
 	int ret;
 
 	if (!mmget_not_zero(mm))
@@ -3134,6 +3164,13 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 	if (ret)
 		goto out_mmput;
 
+	scan_wp = p.arg.flags & PM_SCAN_WP_MATCHING;
+	if (scan_wp) {
+		ret = pagemap_scan_check_wp(file, mm);
+		if (ret)
+			goto out_mmput;
+	}
+
 	p.masks_of_interest = p.arg.category_mask | p.arg.category_anyof_mask |
 			      p.arg.return_mask;
 	ret = pagemap_scan_init_bounce_buffer(&p);
@@ -3155,7 +3192,7 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 			break;
 
 		/* Protection change for the range is going to happen. */
-		if (p.arg.flags & PM_SCAN_WP_MATCHING) {
+		if (scan_wp) {
 			mmu_notifier_range_init(&range, MMU_NOTIFY_PROTECTION_VMA, 0,
 						mm, walk_start, p.arg.end);
 			mmu_notifier_invalidate_range_start(&range);
@@ -3164,7 +3201,7 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 		ret = walk_page_range(mm, walk_start, p.arg.end,
 				      &pagemap_scan_ops, &p);
 
-		if (p.arg.flags & PM_SCAN_WP_MATCHING)
+		if (scan_wp)
 			mmu_notifier_invalidate_range_end(&range);
 
 		mmap_read_unlock(mm);
@@ -3201,11 +3238,9 @@ static long do_pagemap_scan(struct mm_struct *mm, unsigned long uarg)
 static long do_pagemap_cmd(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
-	struct mm_struct *mm = file->private_data;
-
 	switch (cmd) {
 	case PAGEMAP_SCAN:
-		return do_pagemap_scan(mm, arg);
+		return do_pagemap_scan(file, arg);
 
 	default:
 		return -ENOIOCTLCMD;

-- 
2.56.1


