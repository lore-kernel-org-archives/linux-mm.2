Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F06E7606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 20:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SzDkf1fO
Received: by kanga.kvack.org (Postfix)
	id 0009F6B0858; Tue, 24 Nov 2026 15:30:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1B0F6B0859; Tue, 24 Nov 2026 15:30:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30416B085A; Tue, 24 Nov 2026 15:30:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B5E716B0858
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 15:30:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 499E3140B8C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:30:10 +0000 (UTC)
X-FDA: 85471154580.08.DED896C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6BAC6180007
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:30:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzDkf1fO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795552208;
	b=Mi26LhNygmFgHQ1ldWRqObaLrFDrl0yfYSLhR0XHMN32XjanVm5arUFbozWcRGYOgAS6hQ
	yKSttjPNZxLy6bm0bSlpWYl9kJ/aBabJ1PX8pJFAegcDxG9zUNUZqQ1n3PZAuMk3hvi9CS
	P+kF98Krj0+NSSDoXu1LqTs7IWWaLJ0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795552208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=xnyGmrj10J5RwBUAZceA435lNcAGn9y5CnMDripWj1Y=;
	b=LPacnEcTVKRa3wfQtVkvEYBnEp3BSAjIgvc7eJ78oMbDulr20QOfOVCU+OkCZ8HMEzWQZE
	6lP9IZh6xTq95Gh4W/L0LdcBJPmei5B54VMpYHVuVzkyR78LAXMaJdl5+EZdiXOHm+fXvA
	Uh95RsybG3ZzVXbVcQuQgsqbSR2grxs=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SzDkf1fO;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of brauner@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=brauner@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DAFB54409E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 20:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66DA11F000C6;
	Tue, 24 Nov 2026 20:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795552206;
	bh=xnyGmrj10J5RwBUAZceA435lNcAGn9y5CnMDripWj1Y=;
	h=From:Date:Subject:To:Cc;
	b=SzDkf1fOX+vDOKMcqHW9L3tvttsu1t8y3fiYRmJ+P/ebCuKXSRk+OvhssnbiieMo/
	 XKyjFV69ejz99n0GjOb6sJRYnLU5DIttUaTa5rw2f89dqm1H8ElARXo15HOCYcvy2n
	 KrP0sGg+PTvEtVz38/98Gj1y7+WHZz9mEiInCqGvj+ubG/k6QI/SlBt8YhJiUVuTMm
	 MBH6Qvd6bi1XBCe4DCLV9SmCOngdfKCLv7Vrap0Q0W2RHpqCSiwznPv8Vl7MAJGVhF
	 zSZkcSGkvye4G5kxFgpH8WnrwkLq/VU9TdYbGcr4daG+Bqxg4gADEP7CTkbYPt23F+
	 Dh6DaT2iqxJVQ==
From: Christian Brauner <brauner@kernel.org>
Date: Tue, 24 Nov 2026 21:29:47 +0100
Subject: [PATCH] acct: don't take the mmap lock to get the size of the mm
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-work-acct-mmap_lock-v1-1-e054cc1ac082@kernel.org>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z3M3QrCMAyG4VsZOTbFFKfDW5EhbcxcnWtHO39g7
 N5tFTx8w5dngSTRSYJjtUCUp0su+By0qYB746+C7pIb9FbvifQOXyEOaJhnHEczne+BBySua9s
 dqCHTQP6conTu/VVP7a/Tw96E50KVhTVJ0EbjuS+ngqqCqj+qygTW9QOLlSrVogAAAA==
X-Change-ID: 20261124-work-acct-mmap_lock-1c55bf7181a8
To: linux-mm@kvack.org, David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, 
 "Christian Brauner (Amutable)" <brauner@kernel.org>
X-Mailer: b4 0.17-dev-04696
X-Developer-Signature: v=1; a=openpgp-sha256; l=3174; i=brauner@kernel.org;
 h=from:subject:message-id; bh=Y8qOCFZPncHQCacMit2UrGvUoJ8IyiyW5prp746fCkM=;
 b=owGbwMvMwCU28Zj0gdSKO4sYT6slMWSzfj41VzNze31j5g6p3lssrfzPGRLeWPEsi1/6ZaGKk
 oDYlXNvOkpZGMS4GGTFFFkc2k3C5ZbzVGw2ytSAmcPKBDKEgYtTACai8oPhv/91v1Nii+a65Eze
 o3B4G/vMRydeHJIqsiiJifedoVnfps3IcGya/a7s2hX2/DLZb3J4K14H7Nu8Q3Dbnz0rzXg9z0V
 +ZgEA
X-Developer-Key: i=brauner@kernel.org; a=openpgp;
 fpr=4880B8C9BD0E5106FC070F4F7B3C391EFEA93624
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6BAC6180007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: dfmh3d38idtfjawfnt3thhkwh89j55xg
X-HE-Tag: 1795552208-450408
X-HE-Meta: U2FsdGVkX1/Ra4ZLSZ7IZahekmgRSce6IgHMmKwlCCgks/1jXs8bgLTpOlBWH4DYSlUCS89l8HJ5WTZWMC2zVojgSJTbpBrvYmjS6lS0gTR1yjDiiYAiCTc4fVoCptPjwnr4M/vG+ZHf9GQ8eD+FiYki7xb7INe9PZ/1GOCTX2y+bzkQyc+AN5MqLb4kHvpkBFQoI00ft4BnXDzA/ALAOgGHDXnZ8a6kT6uuby8N2TX1vyA/rCPd6VM3pi9Um/dLviMKrvUGEu86DxE/9BqVYcHw77ODNuoa9hRqRvl3ptiVMS5FrTUo7MTfhCGiaR/RgDwU1XtxDm0yiaDM0NYb6qir2x7wqvb+SnF/VMjK0svpwXaaxr4liYqbS1pg7H/r95puvrYEouzg7SetYpR5rafzr9V9v7X6ICdW0UVSdQP22SmqqzFtNvvIIE8TjwQbmGD+2lhm2yZA+XBW2EYSMutke0H8yvJNHYLvEGbahTm2sX4+puovkAOoXTj++zzXUIaRpXHafPd0xf5Z6Aq2OylJ6DZ9gqqCp0pvhlAemGQrx5/cGCFOZ/5zLh7VSTFXxgbWqhqQecIqJRgMWCWumNV1kxWqv7sN1NU46W+jseUppR0+yAgQyFosL4j2X4p+0O3YMdATNNW2g97bpw2NmJJhQ8SjJo3Yk932LBFqNUE6NH/1AeW1pkOKjaZ7u/FYO6r8xp9RJ2KC/FJEQB4e74sH+sKC45TZA8KfoIurZDFh5havry2yVAamrNeak76rayzCy15dalF2gXSP4Paxbrs3k6G8MSvviG5CWYUe1B4h+mxtCje+uS4DV3pAyHxJKPhSf92xlQ7vB7SUFdZxTxlScVVjW4PGEIbaig7pQUeg/ERdM7/tqXoTYjPjWVk24cyISABOy8osob0xCfcnt3wSJ+ZdgWZGA2yWeYGXBYrLrfInQMBvSI9ThXSuvHKdoHj9xb0T3mvOZGLnjOK
 RcaJeAIn
 UGsR02exMXvPZyIlJ6hkRQdjN32C955o5yq9nnxubMlnGPx+9XvpEZ0luA5od72YPsbE6ao8pHG3qrZL6yEQKwzCoDijE4wHxTgy+O6qgo+AtEz1fjatmfBWVoy0dvM5bikv7+H4EiF3yc9aN6TLYID9TtD9orJElBPRe/wrNEi4SUSqliFJEGAAhEwuTW8m73jeakSpNAjImN5IQ3D5ZYWTdf23IlxOuxI3fyeBjrOceOBTGhoHGhXKhHNtMJhwxD98wM1AwvbfqN88p9UK0B9nIgb9Gc8OEh6lcj5dyUWwbAkvfhluVR7TVkKjttRRE2r0rG7q6enQM5T82OMmMlaJGe2MZb0fLBCqdPb007w3NKuC642mK2WuGK+25AbuPOumVSvO9B/OPkPqjylbhJonPtJ5eFhrv7wP6RJAuTq2knLk/fCFWMsVv6ANB9zSSby/96Zlzi4WZTM8sUS8wodIQXvBF2ZB6mzkP+FENopKbzVkJJKOJcAUDN2D38hsonB2QT+8gsz2x6LTSHks+s0HtoyiYKNVJdlkRD1ZJaH+rDSqaKHKAqNqhUA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

acct_collect() takes the mmap lock of the mm for the last thread of a
process and walks all of its vmas to add up their sizes. It does that
for every process that exits on a kernel with CONFIG_BSD_PROCESS_ACCT
whether anyone accounts or not.

The mmap lock is taken with mmap_read_lock(). So a task that exits waits
unkillably (violatin all kinds of grammar here probably) for a writer of
its mm in acct_collect().

I'm decluttering the exec path and moving all kinds of crap that people
do under exec_update_lock out of it and shrinking it's very annoying
existence.

Note that ac_mem can now be off by a mapping if the mm is shared with
another process that maps or unmaps something right then.

Luckily, acct() is deprecated and the mm keeps the sum of the sizes of
its vmas in mm->total_vm. That's what /proc/<pid>/stat reports as the
size of the mm and it doesn't take the mmap lock for it. So use it.

And fsck acct() and nommu, degrade it and use mm->total_vm there as
well. The total_vm is never lowered when a mapping goes away but who the
fsck uses acct() on nommu. And if they do, again, this is a deprecated
api.

Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
---
The quest to reduce the amount of unnecessary stalling that happens to
the exec codepath continues. Next victim, acct(). It has no maintainers
and b4 gives me zilch when to Cc so I'll just take the patch.

This makes acct_collect() get the size of the mm without taking the mmap
lock. A task that exits waits for that lock on every kernel with
CONFIG_BSD_PROCESS_ACCT whether anyone accounts or not and it can't be
killed there.

This degrades acct() but it's deprecated so let's do it.
---
 kernel/acct.c | 20 +++++++++-----------
 1 file changed, 9 insertions(+), 11 deletions(-)

diff --git a/kernel/acct.c b/kernel/acct.c
index c440d43479ca5..9b99313bcb619 100644
--- a/kernel/acct.c
+++ b/kernel/acct.c
@@ -549,6 +549,12 @@ static void do_acct_process(struct bsd_acct_struct *acct)
 	current->signal->rlim[RLIMIT_FSIZE].rlim_cur = flim;
 }
 
+/* The size of the mm in kB. */
+static unsigned long acct_vsize(struct mm_struct *mm)
+{
+	return READ_ONCE(mm->total_vm) << (PAGE_SHIFT - 10);
+}
+
 /**
  * acct_collect - collect accounting information into pacct_struct
  * @exitcode: task exit code
@@ -560,20 +566,12 @@ void acct_collect(long exitcode, int group_dead)
 	u64 utime, stime;
 	unsigned long vsize = 0;
 
-	if (group_dead && current->mm) {
-		struct mm_struct *mm = current->mm;
-		VMA_ITERATOR(vmi, mm, 0);
-		struct vm_area_struct *vma;
-
-		mmap_read_lock(mm);
-		for_each_vma(vmi, vma)
-			vsize += vma->vm_end - vma->vm_start;
-		mmap_read_unlock(mm);
-	}
+	if (group_dead && current->mm)
+		vsize = acct_vsize(current->mm);
 
 	spin_lock_irq(&current->sighand->siglock);
 	if (group_dead)
-		pacct->ac_mem = vsize / 1024;
+		pacct->ac_mem = vsize;
 	if (thread_group_leader(current)) {
 		pacct->ac_exitcode = exitcode;
 		if (current->flags & PF_FORKNOEXEC)

---
base-commit: 666539eecdf4db623f5e3c3e55cf9f2dfad24aa4
change-id: 20261124-work-acct-mmap_lock-1c55bf7181a8


