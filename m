Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CD8CC87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 00:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DADF58E0003; Tue, 29 Jul 2025 20:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D57598E0001; Tue, 29 Jul 2025 20:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C45D88E0003; Tue, 29 Jul 2025 20:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B1C0A8E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 20:58:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 76A521DA0BA
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:58:45 +0000 (UTC)
X-FDA: 83719121010.15.3EBCDF3
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf06.hostedemail.com (Postfix) with ESMTP id 90C2A180002
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 00:58:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nXRLVSsB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3Qm6JaA4KCI81Bttv5t62tAAxBz77z4x.v75416DG-553Etv3.7Az@flex--isaacmanjarres.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Qm6JaA4KCI81Bttv5t62tAAxBz77z4x.v75416DG-553Etv3.7Az@flex--isaacmanjarres.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753837123;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WHML0fVTZol4DLLRqimo4jzJSjhp3AKS45z0vIHCf/Y=;
	b=n+/7AMZgGheYmrlf42ht7jzyTfdwwTecTMIpfMatSevSvuJlJVZNjcd00juH3KHp5BPPAs
	PsHqmQOdYYvrN30gDvGpxY7K7SrKtyU0N6oJdIyH0FBkWHrpWUyIFdPAq754vqYPdCTbzE
	0sUP0uKV6D7P+6X/2VXtLIueQjU4ab4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753837123; a=rsa-sha256;
	cv=none;
	b=dLLMVwp53Aj4FpKTLgilGy75fpdnLK2yr95PelAjUY5Z/gVdhfqRhXGIkDuBwxyWkoFo4s
	3ZVCkwyKgS0DHi9OWJVx8h90V1PVmxF8XRM50qCnU7I7GLuXJK7HtZTcLHxqkWlfmEAQ+2
	GN9K3pU+NlyGlOBRtlRIbgV2677w4f0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nXRLVSsB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 3Qm6JaA4KCI81Bttv5t62tAAxBz77z4x.v75416DG-553Etv3.7Az@flex--isaacmanjarres.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3Qm6JaA4KCI81Bttv5t62tAAxBz77z4x.v75416DG-553Etv3.7Az@flex--isaacmanjarres.bounces.google.com
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b2c36d3f884so4611681a12.2
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 17:58:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753837122; x=1754441922; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=WHML0fVTZol4DLLRqimo4jzJSjhp3AKS45z0vIHCf/Y=;
        b=nXRLVSsByLcgXeC+jOrRrzr6E53JsGgRtW+3kwVlt4oBbrtyp9aIu+O33stIK9jlUT
         inrndiNKs4OfHn0UZvkG2Z3ZHuRY6KSyl4gyccvMcwWgkAQVwMYbXj6Ay8ezXMfX+xzt
         qogaxSAq5UXh8g3nG9CJiTdPeEZpboltCK8SUWre0QPhiExyHojNpOMvhGIbFsSmozNt
         PXKreekjNmBBFnaHkVdPMaIIuk16tU1aQGEKg6NfNK8TUnMcOPxx0A4LolD8y6AeEFLk
         LhsUha+vWUvdJQYiWMgAQibVkOi45Z2Sqq66MHmAcaDWlzHWXuwo3hxrQjOttiCwmFrf
         xAcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753837122; x=1754441922;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WHML0fVTZol4DLLRqimo4jzJSjhp3AKS45z0vIHCf/Y=;
        b=mgpr5te00vdJczeRZax8/mWZcrirSlGtVG4nyg6hb6fn1TBY9yywc/IDfbaAlIRkEj
         kmoRI+0NwjYTOe6M17ylmmJ+qyEzn77uDrjLBMOSphsIShbq2tOXXaoMgJVsWipkTZ6B
         AzWY6dwqnSJO4Liz51ERwWHseNP6pbEH5fPpg2mBUqqkTQ93Erid+97RgSex2A9U9OUL
         nyIxz1aFuJYAEGCCQ4vEoXwje5DENRXnT/WuIb6rgUF5FwBnL5KN8PWStLI3cjMA3slQ
         8wBV6la2k2EfSauv3QcRaihT0R4Y9OAVUBKMxPPHmqLeATwq5hJKJ0jUYYFg95HZ5JjQ
         L79A==
X-Forwarded-Encrypted: i=1; AJvYcCWEuB5zwIb1tCQ2GSKH6NYVQEVxadg2otAW+9/Mr2scpNIBTYfn7RFyTkVUC0pz50K330H7Z183yQ==@kvack.org
X-Gm-Message-State: AOJu0YzfskEuglU8aQx7IsanVFu6/RzsSCfKT0o6Oj6ajFmHWUD0LtDt
	WZkkJfbpCSQ3/gGHuAQe3WFMf0f2sbF1tGyeizy3o/+e5LU17JvnJBUkdlstqyFTO1nIKX0zb+w
	BkQW67Y+9JAZ2P0k+m/Fk5tR3W7rXC30SIrNfjA==
X-Google-Smtp-Source: AGHT+IGKKEl35BJsLTBrUz3LPVkFRFj381DprHeoXqPOiIsnE2zVrxKnAt1I6K+wzrAviCs9wMxmhgog+ERuVKqxrX5d2w==
X-Received: from pfbbw8.prod.google.com ([2002:a05:6a00:4088:b0:741:8e1a:2d09])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a21:32a6:b0:21d:a9d:ba3b with SMTP id adf61e73a8af0-23dc10a54edmr1953340637.39.1753837122323;
 Tue, 29 Jul 2025 17:58:42 -0700 (PDT)
Date: Tue, 29 Jul 2025 17:58:07 -0700
In-Reply-To: <20250730005818.2793577-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730005818.2793577-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730005818.2793577-3-isaacmanjarres@google.com>
Subject: [PATCH 5.4.y 2/3] mm: update memfd seal write check to include F_SEAL_WRITE
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
X-Rspamd-Queue-Id: 90C2A180002
X-Stat-Signature: gzmwg7gsasrnnehhya4u9uu7ypzgfh8a
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1753837123-918867
X-HE-Meta: U2FsdGVkX19+8hTsUAdyEySyZ4Zn9uf0MQ2o+OjeDAulgAy3OOcXs5gK0w1bVlIAwB3CberZaC8rVGvqE67m3g79gxhLU81aDPwSAuMhv3pqqNRv3cOUzUhMH8tv45UXdKCKmFoBP5Uagm9yCtAkrdkxsrrY8jTBFMuOIZ1CvWX085iOKNcCUBDovRSehH0PqASY60oLPMY0Fdb1QfFY+HO/A/48MiU11tgOqOPRr9MtgYSkYhCxo862fEZSgR0Swn254GHN310aAdu3vSMsU1JQHbz+DS2J/RkGqpUnElprTwVUlPhA0HeKTo19DL8LLEHi4xCv80i9IaXq37+MqchLW1oDu9mMwnbCTBTc5HnGetT97VIB0ckvAQ07hvrQKPw50uQdYX1Suceyg3GL/uVJRARJISiE1uahrDHiDMIXcNZFwN5667jxUGsP+HijJV4Dur2KGKs6wd0SxMD09r7X+jpi0XyFNQxkXjTCQGCmV1lq6HmDjyo0szh5sa9aGeXtcq4jV+/A7UuOqj/W/5WlI31qJRnyx9cfOPhRlh41QR+7kSOcO+MpGzhF5M0VShFtEh1tvTqtF1x8j4y6LJL98B5bXFtAC7lKtVurL8FjnqtpfNDL/oKYpZIDpgt8hRJZUWbcGdggN8wnNG8URCEFpeXuybbG6ODHzLBTFVW2fm57gPfJ2JIzmeFl0mM7E5oAlIdd5R1x+iqcIf+C1vgT0+m00+nuOltmYgwHyCTRS0/DrQmrU3mbZhr+DrTzr5vqq1OgfU0KsU2yO9k8Be7z/8IjfYGQquJ95AJgUmW66ELLxtAEKzILy0YUGP9V6ArPbPTcZBZ4DshJlYfeCmbJE88CX05zVeVd1OrZkDG+T5sPCI8pYQMKZGstktdY9yhTMyYxuWIH0L9NtH/nFItGClQqjTZP5QbJmdHe+E0flya4x7rwAWsaxAr8UhPjWt9DwuSwkFSpq58xHuL
 84HL8exd
 iJgHXp+onoe7QD6OymqYeDkKpp0cAK4Gzukairdmy7biaz3azTExpWaC+Uht6395KHetChr6jF6yaFGtDQNbsXkgFJCjXSMXzpMK0e8qGweUEkM0o6kAuXdrEXlj8xnBeM/BGRWxTToe2v+aVXLjyPHSRsGVT95DFKVsSD0sp0/ChwWeBPC+d3aJdaagBsbmZevZ0Zh2sr1b+6Sl42iHJ+uIPY9ob48YkDe5H/IDnwesTx1J8XUh0WvSuQGmhxe61cgJMJWc+HpuYHLRb8jnFtAUOrQP5P3oFPKaDgOR6h5UWUPefjhy+IveVPMDXeXkzCD0T+lXOxQ9o2hzQjU/QGU8m4T/AWfgUnSg6tEjdpviVYAZjxVV2IOv0RpQNI51vEJzLnYfTzrT7oaQhV2NXKlqbl/5EGYT4kXx5wdlAvPNYpxUuaaEbm8mgag3Jtj4HW/pw00nwOu51idk7kL/9kD6nUI0Ok7cS53aFnsUrUiH5QbsbooVBtps0lHkx0jGcx2Fc2mSI7mtEiSbWLI4TOS2bGtYoDwI2bbbD2OszEv7xyqcZYEjXbNaLRUTyNbOeN5aDxWeE7p9oPAeDSHB9OQEPdpNiEhhYYGd+CcoHnYRMFDinGPyrM1pQYsXJqzlMnWYacnhJrxhrJZRgOT7Yt03AGTeJmSPo17vqnXcjlDDY7VmkkfoCIevAzdExEVp2Bk6tFZE/QyWODg9spjY6DXyv9SIRk17XILp54OvtE2QMD89KJ4SgTSACajPOVw3OjXsoo8LCEJFK5vLeKd2XrgMpjAo2KwJbfp80B3M/pBIdrtBam5/ni0gL+22205rCEJcE6Yc+uI9WynsNoFncGGXWt6CSzB/9Ckwcf2cdYZiGoLHRQVq96hwV/BIUqhW+8FYC1w2jAotI0Kv8M3jASr+D1ReBvDwkpPfuFfTLoCEh/rc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 28464bbb2ddc199433383994bcb9600c8034afa1 ]

The seal_check_future_write() function is called by shmem_mmap() or
hugetlbfs_file_mmap() to disallow any future writable mappings of an memfd
sealed this way.

The F_SEAL_WRITE flag is not checked here, as that is handled via the
mapping->i_mmap_writable mechanism and so any attempt at a mapping would
fail before this could be run.

However we intend to change this, meaning this check can be performed for
F_SEAL_WRITE mappings also.

The logic here is equally applicable to both flags, so update this
function to accommodate both and rename it accordingly.

Link: https://lkml.kernel.org/r/913628168ce6cce77df7d13a63970bae06a526e0.1697116581.git.lstoakes@gmail.com
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
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
---
 fs/hugetlbfs/inode.c |  2 +-
 include/linux/mm.h   | 15 ++++++++-------
 mm/shmem.c           |  2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 47b292f9b4f8..c18a47a86e8b 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -152,7 +152,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 47d56c96447a..57cba6e4fdcd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2946,25 +2946,26 @@ static inline int pages_identical(struct page *page1, struct page *page2)
 }
 
 /**
- * seal_check_future_write - Check for F_SEAL_FUTURE_WRITE flag and handle it
+ * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
+ *                    handle them.
  * @seals: the seals to check
  * @vma: the vma to operate on
  *
- * Check whether F_SEAL_FUTURE_WRITE is set; if so, do proper check/handling on
- * the vma flags.  Return 0 if check pass, or <0 for errors.
+ * Check whether F_SEAL_WRITE or F_SEAL_FUTURE_WRITE are set; if so, do proper
+ * check/handling on the vma flags.  Return 0 if check pass, or <0 for errors.
  */
-static inline int seal_check_future_write(int seals, struct vm_area_struct *vma)
+static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & F_SEAL_FUTURE_WRITE) {
+	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 		/*
 		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * "future write" seal active.
+		 * write seals are active.
 		 */
 		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
 			return -EPERM;
 
 		/*
-		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
+		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
 		 * MAP_SHARED and read-only, take care to not allow mprotect to
 		 * revert protections on such mappings. Do this only for shared
 		 * mappings. For private mappings, don't need to mask
diff --git a/mm/shmem.c b/mm/shmem.c
index 264229680ad7..8475d56f5977 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2215,7 +2215,7 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
-- 
2.50.1.552.g942d659e1b-goog


