Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DBCCC87FCA
	for <linux-mm@archiver.kernel.org>; Wed, 30 Jul 2025 01:54:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D5888E0005; Tue, 29 Jul 2025 21:54:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3AD9F8E0001; Tue, 29 Jul 2025 21:54:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EB6B8E0005; Tue, 29 Jul 2025 21:54:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D9458E0001
	for <linux-mm@kvack.org>; Tue, 29 Jul 2025 21:54:21 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DC98A12F8DF
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:54:20 +0000 (UTC)
X-FDA: 83719261080.26.2E52488
Received: from mail-pg1-f201.google.com (mail-pg1-f201.google.com [209.85.215.201])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0D390180007
	for <linux-mm@kvack.org>; Wed, 30 Jul 2025 01:54:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1/YWhTlH";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3SXuJaA4KCLAYiQQScQdZQhhUiWeeWbU.SecbYdkn-ccalQSa.ehW@flex--isaacmanjarres.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3SXuJaA4KCLAYiQQScQdZQhhUiWeeWbU.SecbYdkn-ccalQSa.ehW@flex--isaacmanjarres.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753840459; a=rsa-sha256;
	cv=none;
	b=m7Onbg01rBeHX7dmBMqfs3ZYrm+LzsSquoOmcmnqPrjM3BAzhDpXcgoeEegk42Psz7A5cX
	34grJHh76PZuwXk5SNvqfsJ2Yib0qtuTgdjGrzzrt7R6LEJY6NHHAYHS7fx2QsBm40McBD
	hdsCGczjjSGRBZxrMRm2en/cYE5B2wk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="1/YWhTlH";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf16.hostedemail.com: domain of 3SXuJaA4KCLAYiQQScQdZQhhUiWeeWbU.SecbYdkn-ccalQSa.ehW@flex--isaacmanjarres.bounces.google.com designates 209.85.215.201 as permitted sender) smtp.mailfrom=3SXuJaA4KCLAYiQQScQdZQhhUiWeeWbU.SecbYdkn-ccalQSa.ehW@flex--isaacmanjarres.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753840459;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VXg5VQlsYRDQOn4qX1CEGd3+KGbAxIhXk1wybEg/0Gs=;
	b=ND8V6RN1AoEPzH26hJv7eyOpKMaAaquJrgXS5OEQBRFpJL0aIgZAXc0aW49ss4R5BS5bI2
	k/gXyW8Y8lktXQq59i/pvZcnAqNbQusnbCQaaTUTOxsQ8lMYURpC13r5ESywbtAfy8Yo/P
	tkgFK9NIQV9Q7aviEzXFCRXdIH2BCNY=
Received: by mail-pg1-f201.google.com with SMTP id 41be03b00d2f7-b3f33295703so8167897a12.1
        for <linux-mm@kvack.org>; Tue, 29 Jul 2025 18:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753840458; x=1754445258; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=VXg5VQlsYRDQOn4qX1CEGd3+KGbAxIhXk1wybEg/0Gs=;
        b=1/YWhTlHpQOf+bHLdICMRpUIXfQYGkkxIlLMjxqY9c2QE5Ers+Jc83I6jkWXDE5qB7
         kYCKRNA1Ab5sE33qyn2j2y7KLkIQ9uLRCgiX166/SvZg4MUX3Acb6UIrvTo9f1MK6cEC
         nQ+3yatAjglbUXRAhdvKX10hbMl8TbTUPYN4fWdSVFCAtPIs+lAxuhUyipawYXR2rXCR
         WhM0KEMow0yKcvpA8bJ2WvQD8Tl68Wuw0pT0AtNlCzWskmCzFH3L/oE41m8vwPJK+v69
         Vwr0rrLVGmjL7iJYjYsgOvxnORPcAN8IMZz7AcOTMBBv38S0JW8/ud6oDoHWX10G0+4m
         Dkpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753840458; x=1754445258;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VXg5VQlsYRDQOn4qX1CEGd3+KGbAxIhXk1wybEg/0Gs=;
        b=b+QRUkB1w8vSLdWbCvy5wFciQ+qTw+xYFqKLq/IgmjsoDoLTxl/EnW/1/ScPw34XDv
         eDZ5bAKWaMV2tCbHxiJ+wCwX/6v2uLBVtPPBqqJKug/yyy4qy0935tpANElks8f249LP
         AMuuaPc2i1SvYNLxdC/4Q2wUvYaOfUHAKZcdRvZnPewF5vOLdGLCctZkDLNQNS7kY1B1
         fTwt9LKYK5mIwvwBFMFJTtNSknnOiGrukDguT2kIQkWiiMN9+aG7gh5qiNgJgjMqWLDB
         2o0hI/9NiRDDZ0PRGerMlVrms2N4MXk2w04QdDY4vjUhTL6NKgsi6s7OpvhNO9dN2/zu
         y3vQ==
X-Forwarded-Encrypted: i=1; AJvYcCUzUw24Lf3D9//4uEcn+uoX9yHFu8I1VHZpP5a/9Vh/DJ1MtNXNrannIoa01/QGh7lMpSjVLwtdNA==@kvack.org
X-Gm-Message-State: AOJu0YyCBhCFdcv2dTIboOEIpxrh1CKGvlZ2NYNv+lmY5QDCLwUV3Ham
	oC0FeCN33hOG3PyWheSxrKvSflkc8Mj+eM0UKzbW7oRJIymV4fUTYdcabolzxHc6ZYlJNYoCks8
	ajsbZA72n4Z7kVM6bXTYzrN9NDQ/+o9sUSVuXzA==
X-Google-Smtp-Source: AGHT+IFNWTjX24exOZOPvPnWYCkq5geMIPulZn3Ba9ouy0INNk3MDuxRkhn6Gb1zf4XS83ACMv3zIQsDLx8mU8pDfF2f+w==
X-Received: from pluo8.prod.google.com ([2002:a17:903:4b08:b0:240:3f51:abcf])
 (user=isaacmanjarres job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:d2cd:b0:240:92f9:7b75 with SMTP id d9443c01a7336-24096a4f806mr21813325ad.2.1753840457907;
 Tue, 29 Jul 2025 18:54:17 -0700 (PDT)
Date: Tue, 29 Jul 2025 18:54:00 -0700
In-Reply-To: <20250730015406.32569-1-isaacmanjarres@google.com>
Mime-Version: 1.0
References: <20250730015406.32569-1-isaacmanjarres@google.com>
X-Mailer: git-send-email 2.50.1.552.g942d659e1b-goog
Message-ID: <20250730015406.32569-3-isaacmanjarres@google.com>
Subject: [PATCH 5.10.y 2/4] mm: update memfd seal write check to include F_SEAL_WRITE
From: "Isaac J. Manjarres" <isaacmanjarres@google.com>
To: lorenzo.stoakes@oracle.com, gregkh@linuxfoundation.org, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: aliceryhl@google.com, stable@vger.kernel.org, 
	"Isaac J. Manjarres" <isaacmanjarres@google.com>, kernel-team@android.com, 
	Lorenzo Stoakes <lstoakes@gmail.com>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Andy Lutomirski <luto@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 0D390180007
X-Stat-Signature: cmts7g8beopa9jtp4y3ow7n9ka8buy39
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1753840458-292317
X-HE-Meta: U2FsdGVkX1+ku2GSeiwP0FMeG9yDKLf1O0EVMqKyhKdk1j1lRXZoPbTFQp6yFgYdHBgaatDmOMG0JB+s1j7YZwt2hF4Z0vTCoswhWUat+mJIBdKQa1ZAYs6vsnbqCWfVTxguGVT1M4I95EHGn9UrBQvxC+2ls/3zWZm4q2OxqpHlwBk1LONylf/Lgsl/O5atbCT7iBaC98KtvLJD2D42rFPV3K3XLcHlyyCgHKxEUQEngopHFVDJK2abL0SXYzXujlAKAh2fJ4d4JhNk0JeRGiS/OZtVHdLg1dRPjG5vcSYepw5QKmqKO7LEhp+PvwngIVtmBiEPGU6e31bkJS/sDJ478vFXBNS6deldIXUHE5h92lpXOn7J6v4AnlgpV6PO5p886GeLubf0SWJbN+inj/CCvaSnHhm7uRQzENsRZCJg4Zxr6wqlCC+SYIwctFF8IIDVjBI6hMoaz8L41Dhm/HM48NAVzJDioxuXpD6H8DYH0g1jwGgLeTL5/bS7MS6GSFJB6L/4Kg+dXZWIYfeNcieZeu5mln83AefgLExMX04+Ld9yhv/rZktDhOZ6Gjcb7fPSJCG4ZOiaOOBPGSBNVrCa9/4KVBON3kLj2z8eOtmGXjGnGgxhmGhbGVbfzYfVG9m5mnD6rg8nvLSFiiVS+5TAyB3xf8I3bA26OhAZ73wMK9DWKfVCNBfVVft6GI+2FSHrbSPzgVIbdbF41xvPtw6vClquqsb2hGbG1ehxSsw2ZBo5jwrG8gGDNziFwkWmrUqLVRQVF+wPT/jLf0+bbagXDSMBn1DWdz16ikTQHJvuI2Vq73IMTloo5P3s+bWwW09V7rDm4vc0lKpAcKJBU3IimYBrnRkU9HyXxHaOyP9dNUBfFuzXihUw8uWqWQMmik7i4I5FYmIkmzkj0ddEYXV2dRWAuLy0B8S9J1yfxFerIQmx454DLy/RsXuBzK3bfbIf61qx6nzC5IwEEEx
 tWIgpKAA
 2hZO/IFktAcoe2/lZSdd6S2keJgWDHVkdGfoTIUqhR3f8nGY8dELawnljYrB8mdHSYrR97f98wnQh89bq0jO/Y3LD/tDyhUfiH9fcjy9oxGL4P0+RmG71edHv20VO5+sgoTCeWB/wSNSggs3TTgdVmm5tKuGOLYZ4rgbcDbXYhHwqwo8CWmZMEkD70r8sQfY7uaw0OtKzk+qMiEeecpI6o/OSSDai7EpycaHLDSczHhdLF3Qbw5iWOD0J3Pb9G6sY0Ci0RhzAaUEWbsozYke4U2ZiZ2Nnk1POPVM6/HJg8b127M8kWwjMbJbqdep40QeKRI6cQCznGykckzJmhP67CHat1KXxyypqav5MxiLz2mKVYnIR1z3e1hpR6uDVcjb6R7eXcTiWE98RYlUWlIbl0Kq6bBrizHpeUwJYj1PMHFuzeKYn6ZA8KZNptAZ+/bwYDswr9/8v6ad0diLbO4eKyEoEwbeMKSqnpFjW81Q7dRMCelAHGBJ4tF6USllsSkYxT2hRiCSG0kT4QH+wXEYaMBdBoIWR2F1b68Dw0waKDM5J0/wJWxuGtpnUWq+2wCXBRnx6ZCgjTBf97qk1anWpcI1i++tW6aQtV5m1lxYfT6SC9jmhOby3SuKo2OpxI1YFExHigI9XNhbXx817EzwFwM/knYEz1Y6Cn/poS0Pj1UpR9FhgMVaUcSoVPzmvbBJB5kUhCbNxF3tx6FHCfU++PoYepyQsnbLbz3m1IsYVRCDlhIA9aqIfpsmIz/LaHxJ0c3BPg//mUTfW7JUWf9MwFZde1DR9XJP8IdigrjqIh+RKG9df6AZ62EwRssJqeKAH6T0+yssrX39nVv1TV9HmCCZT6t738Xye8UxXEEy01QqFYhD10XsZZmncO3KILbMyRKz8bkJRzzS6I1+V0dHNlnwLiUUhZKtg+ksTl7V5dmhKjEg=
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
index bf3cda498962..6e97a54ffda1 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -148,7 +148,7 @@ static int hugetlbfs_file_mmap(struct file *file, struct vm_area_struct *vma)
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 2bedc9940c47..130d53f0bd66 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -3201,25 +3201,26 @@ unsigned long wp_shared_mapping_range(struct address_space *mapping,
 extern int sysctl_nr_trim_pages;
 
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
index 6666114ed53b..5f8d8899bd0e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2263,7 +2263,7 @@ static int shmem_mmap(struct file *file, struct vm_area_struct *vma)
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
-- 
2.50.1.552.g942d659e1b-goog


