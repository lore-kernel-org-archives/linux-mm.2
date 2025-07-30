Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F96CC87FC9
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 00:59:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C209C8E0005; Tue, 29 Jul 2025 20:59:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD16A8E0001; Tue, 29 Jul 2025 20:59:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC0628E0005; Tue, 29 Jul 2025 20:59:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9CD4F8E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:59:01 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 39ACD140265
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:59:01 +0000 (UTC)
X-FDA: 83719121682.04.45E41CC
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf14.hostedemail.com (Postfix) with ESMTP id 8BC40100002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:58:59 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0v0B7Bab;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3Um6JaA4KCJ8HR99BL9MI9QQDRFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--isaacmanjarres.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Um6JaA4KCJ8HR99BL9MI9QQDRFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--isaacmanjarres.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753837139; a=rsa-sha256;
	cv=none;
	b=zz+wtKRm08+ipwqawcAxS9KsrnNlaUqonsIycXGcaEQKkbKC2taXkXKy+UFJSehJ+6Mijd
	dS2k3s2OQmaoqMaH5eA9e7BsoyQL6WFQuQS5Y6iUwY6WY0RP5zvCak4d6Ok0DgI2AyAwb/
	1Srm6UZDL9+XvodnVN9Os2icV2JJfVE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=0v0B7Bab;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of 3Um6JaA4KCJ8HR99BL9MI9QQDRFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--isaacmanjarres.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Um6JaA4KCJ8HR99BL9MI9QQDRFNNFKD.BNLKHMTW-LLJU9BJ.NQF@flex--isaacmanjarres.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753837139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jDQwseaUqKXgQMG0PL1emMIiquT/LrlyEZB+aSduFZ4=;
	b=X6XccvN8wB9+Cxr1cmZPLKvKd48P2IAYZbGOA+vM+ir2AqAhuZOYkCbjEcp4H8mHKqBLoN
	FBjxA5ntCNbOQlOLZl5/zlTWAQFL6l97Wsx9h1e97/ydiPjVmM2oOjfv+DgTKSFOM3U1sn
	iQCAjhj+Gt15wrgTElH1QL2Oo1wZ7gw=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-31f3cfdd3d3so1067036a91.3
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753837138; x=1754441938; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=jDQwseaUqKXgQMG0PL1emMIiquT/LrlyEZB+aSduFZ4=;
        b=0v0B7Baba3TeyIf/uAUAaowQ7bMHhwvoo8CRs7vxo6DNTZ4lQCYndu/BF0T6Rnm5ZC
         VIN2qrgwF09FDhtmKjYpGqh0tewzYgV6ppmWKpMdVy5nUlt/vsTNfVY2QuZNdqacFyRV
         HDxyaKXPRIEzlaty7T+ownORPi4oPVipFtMxrOeDbY2rj9JYa87nuOSd1vZgDjGlcM7R
         Id5+siHbvpXgRsYmCaxyiRuJUz+UlHwANoP8TRoRZYQr7xjANitVhxNZ77ghi1sv+EwH
         UTh8NWf/k7CJFmvPHIWM6Ry4i6xiFuavjTx4wHAjCAT3UvArKWH1QEnZzBG0S0wJhw/P
         byCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753837138; x=1754441938;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jDQwseaUqKXgQMG0PL1emMIiquT/LrlyEZB+aSduFZ4=;
        b=Xh5TAcHzgCMtdFgQje/OwvUkrMyYF/88MBFwJU/2JVCdpZvenmfH4IZLCeeQyxVoGu
         /DIlonb9IxCoNgA6e+yoOM9IQ9mZOtrJjY5J+VqaAfRoay0nZbqD5sPvVBnvBa0fM2e5
         yZinbNJsiaa7Uba95Cku9lmZUkGF+8GXmdS7Um1d6HqceN9PegDqNO2zRssUZvzj+wTf
         9zGya+QZzEBO70dJJkVBRYEw61OYCFsrJxi37zbN6jCC6IxWmXcRnPUNUur7yZm2WFhg
         BUixQdYxQyW0yTXSqK19HfDYSYnDGsmdPwrxnzlIq10hRAGQWixIzdyW0TZo8CyZlExy
         6cQg==
X-Forwarded-Encrypted: i=1; AJvYcCVjde0Ycktdg6y9kT22LKVwiFstBOwCbnITvTCDhpygCOiwq65SxigQDpfLlMiiBRUFezUeprbxzA==@kvack.org
X-Gm-Message-State: AOJu0YyR5lh2lQ2MdKnqYDdfCheBHoxd5PMITl93V4EB8ppiswySWA7c
	XYndquhVnt5EbimKKKOOQUEBaO5FwHOs2AKKs6AJBgxMGpOCI4TFuUk1KP7yMDIWiTfFT1VdtgB
	WoLB57La7zDkeHesOWTKr2xKCK4tHwAWmMYcaRA==
X-Google-Smtp-Source: AGHT+IEGVoBAYELfdRdZ8xP5oRpoU0bK+jZlnzB/TmwUAobgxp21zhLfsqJQJKUf5/TTCLpNwHYxnC3kjLaDYc3GnzINcA==
X-Received: from pjbpm8.prod.google.com ([2002:a17:90b:3c48:b0:31e:a865:8b32])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90b:4b83:b0:31c:3872:9411 with SMTP id 98e67ed59e1d1-31f5de63c28mr2092662a91.33.1753837138329;
 Tue, 29 Jul 2025 17:58:58 -0700 (PDT)
Date: Tue, 29 Jul 2025 17:58:08 -0700
In-Reply-To: <20250730005818.2793577-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730005818.2793577-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730005818.2793577-4-isaacmanjarres@google.com>
Subject: [PATCH 5.4.y 3/3] mm: perform the mapping_map_writable() check after call_mmap()
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jann Horn <jannh@google.com>, 
	Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Lorenzo Stoakes <lstoakes@gmail.com>, Andy Lutomirski <luto@kernel.org>, 
	Mike Kravetz <mike.kravetz@oracle.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 8BC40100002
X-Stat-Signature: 8m6tkx47ic6rwq9tny687bwbcdowqksj
X-HE-Tag: 1753837139-14094
X-HE-Meta: U2FsdGVkX1/VdXY0CNXC5u3LbSC+IOo68SIrAEiACZyYmOkQDOucSSUHfFrmF7kWEHxo7hi46az0e6tQO1x26OOVnydOovRPOfgAzwnhGPd6bA/xbv6XnfU4uvJJFAhSvG89kvGGVd2oA6wEjsut+HUpXHGDvu+emD3cfMtMtg6jxyHveqETS6/j1GHrQvJSLMcGqCzu3Em/qM6M37Jy0zw1wtdqZOXVsOwLgteH71EqgUJHpVSTDxHym/DDEcCCcZFioNiwFM9HFAMnIvj2ztJ3scBTEavzB6G06RVnzXKknaKol+Qv17K0PbCpCUu+8zVIgtPAONRudCoxRmWgYqF31kz001U7z21G2F0u0vLwwnH3QwOJf8s9cUQ33y1KRpprW5Tj6oTZB7Kdr+vEUxS+JhmWlUlvaps4nh3INqb9vh5TZ2UTEnRNcUzMWIV08tjqJyyuE/Pl5Ti7qjaKBOb9ScMOfpJ6/GsZsCqCsptWj5gFpM0lIqgbe2SDytg7+JwerAA3NWmvuuKRw3lu8IXiVwWs55F+ZX0qzIyRTRoLw0nrI160WHlzRrS5RHZ+dr21lyDvldEZZegApL+xq1oBVVDvD1f2+MZyVG3fg7QfbZGyrWf4PWKgnBeLjficcaT8IzafuMTF03YUe2AxMaL9r4lq2uml78wpoZA6jfG6h+f4Z1QpSRSrVR0NO+Dy6VRVzvyY9ZteRyA/iGSyQ6FNtGjhA3hYJE+OdfJF9IUAOld887xysPiMAeaRn+OEwWPDV/mftPEEex1sQrIkO0U0u9J3NMttXAL63V4aLtIJhj5MacQ2zfXcgxUZ1OttLJv1ytq1VENEz1MapEUqU6aTGCJoPYr7ZkHNcvmEjsP1MpOs3N4lp3O185P/fE4T20gfw8SUrPBjup+svibWWrC397MY+2vAYTL2T7vFjbNjkRXy2z5yBku1WLE1UoRkRpUSyFw3fZ25jU8o/DB
 peDhDrhY
 UU1uAzrhZSdjN5RtmVVFTFLfost40qtSHCIjnoZAlR+LWwvuFscHmbDRP6K8JL6J2/QzQe/4HppVDBr0Z4TjbwAaCNx7vh5uyUhWwwen8qgDHvEuPXcYT+YlZEP+13wuqSE+i5UGA3R/qephrSzLFEfSSenNVq/G0MhuEhX2WdN958Q9d9KZWxbXBNdBGZFV0T0ipT/1QTywEGHLFAEWoIcet++SVnglviGFSaUkqyYrL2Sq4wlcsstAyalrgKvpu1cmv7tsPeGwGhTiITkwFdPaKFUhVg9LBUf4itTvUaLqX+XMvqq2UXlNjvAQpPTrzO+n1h1MPpFjJhCnrf7ivX+Eovn1Pmixh8gejdLgbtfPBOQJNKsKVlXDhPP+tmdYNJa0jY9njA3CX8iJNxU5wFfLRpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 158978945f3173b8c1a88f8c5684a629736a57ac ]

In order for a F_SEAL_WRITE sealed memfd mapping to have an opportunity to
clear VM_MAYWRITE, we must be able to invoke the appropriate
vm_ops->mmap() handler to do so.  We would otherwise fail the
mapping_map_writable() check before we had the opportunity to avoid it.

This patch moves this check after the call_mmap() invocation.  Only memfd
actively denies write access causing a potential failure here (in
memfd_add_seals()), so there should be no impact on non-memfd cases.

This patch makes the userland-visible change that MAP_SHARED, PROT_READ
mappings of an F_SEAL_WRITE sealed memfd mapping will now succeed.

There is a delicate situation with cleanup paths assuming that a writable
mapping must have occurred in circumstances where it may now not have.  In
order to ensure we do not accidentally mark a writable file unwritable by
mistake, we explicitly track whether we have a writable mapping and unmap
only if we do.

[lstoakes@gmail.com: do not set writable_file_mapping in inappropriate case]
  Link: https://lkml.kernel.org/r/c9eb4cc6-7db4-4c2b-838d-43a0b319a4f0@lucifer.local
Link: https://bugzilla.kernel.org/show_bug.cgi?id=217238
Link: https://lkml.kernel.org/r/55e413d20678a1bb4c7cce889062bbb07b0df892.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
[isaacmanjarres: added error handling to cleanup the work done by the
mmap() callback and removed unused label.]
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 mm/mmap.c | 22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

diff --git a/mm/mmap.c b/mm/mmap.c
index cb712ae731cd..e591a82a26a8 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1718,6 +1718,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 {
 	struct mm_struct *mm = current->mm;
 	struct vm_area_struct *vma, *prev;
+	bool writable_file_mapping = false;
 	int error;
 	struct rb_node **rb_link, *rb_parent;
 	unsigned long charged = 0;
@@ -1785,11 +1786,6 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 			if (error)
 				goto free_vma;
 		}
-		if (is_shared_maywrite(vm_flags)) {
-			error = mapping_map_writable(file->f_mapping);
-			if (error)
-				goto allow_write_and_free_vma;
-		}
 
 		/* ->mmap() can change vma->vm_file, but must guarantee that
 		 * vma_link() below can deny write-access if VM_DENYWRITE is set
@@ -1801,6 +1797,14 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 		if (error)
 			goto unmap_and_free_vma;
 
+		if (vma_is_shared_maywrite(vma)) {
+			error = mapping_map_writable(file->f_mapping);
+			if (error)
+				goto close_and_free_vma;
+
+			writable_file_mapping = true;
+		}
+
 		/* Can addr have changed??
 		 *
 		 * Answer: Yes, several device drivers can do it in their
@@ -1823,7 +1827,7 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 	vma_link(mm, vma, prev, rb_link, rb_parent);
 	/* Once vma denies write, undo our temporary denial count */
 	if (file) {
-		if (is_shared_maywrite(vm_flags))
+		if (writable_file_mapping)
 			mapping_unmap_writable(file->f_mapping);
 		if (vm_flags & VM_DENYWRITE)
 			allow_write_access(file);
@@ -1858,15 +1862,17 @@ unsigned long mmap_region(struct file *file, unsigned long addr,
 
 	return addr;
 
+close_and_free_vma:
+	if (vma->vm_ops && vma->vm_ops->close)
+		vma->vm_ops->close(vma);
 unmap_and_free_vma:
 	vma->vm_file = NULL;
 	fput(file);
 
 	/* Undo any partial mapping done by a device driver. */
 	unmap_region(mm, vma, prev, vma->vm_start, vma->vm_end);
-	if (is_shared_maywrite(vm_flags))
+	if (writable_file_mapping)
 		mapping_unmap_writable(file->f_mapping);
-allow_write_and_free_vma:
 	if (vm_flags & VM_DENYWRITE)
 		allow_write_access(file);
 free_vma:
-- 
2.50.1.552.g942d659e1b-goog


