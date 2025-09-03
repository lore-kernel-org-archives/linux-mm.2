Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E0E1CA1010
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 23:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99968E000A; Wed,  3 Sep 2025 19:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4C808E0009; Wed,  3 Sep 2025 19:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61078E000A; Wed,  3 Sep 2025 19:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9590B8E0009
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 19:24:48 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2555A1A08ED
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:24:48 +0000 (UTC)
X-FDA: 83849521056.07.066095E
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 501AC40002
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 23:24:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="LlKKm/Kp";
	spf=pass (imf07.hostedemail.com: domain of 3Pc64aAsKCAoukvo2r2sxqrqyyqvo.mywvsx47-wwu5kmu.y1q@flex--kaleshsingh.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Pc64aAsKCAoukvo2r2sxqrqyyqvo.mywvsx47-wwu5kmu.y1q@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756941886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=JgPTVCi/fpzUuEvg9xD+jIRme2pJE3B6Yq7rj7B3nZY=;
	b=mlLLyp59lg3OJR41BtscEPlg1traxR1SxbL/awsWYLvQNuSVL2C54iOoSqkWtypOI/A57Q
	x8TUm95uHzJC2SjhPJzofoBGQwT4mR1fzNupdxSo+gZ5F0C9A9IL8iMmhiCyy62IqKykl7
	TwCbvTH/gljkDLHnomIb30e5DAFcf6Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="LlKKm/Kp";
	spf=pass (imf07.hostedemail.com: domain of 3Pc64aAsKCAoukvo2r2sxqrqyyqvo.mywvsx47-wwu5kmu.y1q@flex--kaleshsingh.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=3Pc64aAsKCAoukvo2r2sxqrqyyqvo.mywvsx47-wwu5kmu.y1q@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756941886; a=rsa-sha256;
	cv=none;
	b=BqpS8pRrfeoN0KZtDfcNf0fjU2QDXajdPEMNwaXrDvBoh5yAlWkl5g/9Ok66B1EJSV+xuw
	bbYJtlIrhEiQCNLDDqk+MUIM5PhtNmlCmU/ohYa8nmqOuBs4ooNk1/UcXoKO8Sgf7/oksV
	XAKDNLluH7sPjW9JTB7bImOMCcs9UJE=
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-3280d0d4d11so467569a91.2
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 16:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756941885; x=1757546685; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=JgPTVCi/fpzUuEvg9xD+jIRme2pJE3B6Yq7rj7B3nZY=;
        b=LlKKm/KpIJqhvI3RxkUNtYGvfZnS2F4AYq4o+JUPKdBDskfwnkgRjnr2AI2Wbzv+xj
         QT1jkp7irOv9e3heTQHFP/vROLnaIItALZmN1YK7eY/2rwMfxl1L6sJGusJcq7t80Ywp
         GRHdxYURCC8veIZ35ilrFQELj1yM/RtpLYXMKiS9ipSyOhUGfMDzM+2gaAB+bQeypqQc
         Fyauht4PIm44CozmwRFNjgxE/7Xc9peXO2jnrU3vRWio8PEShWcn4JitwjN5BZR8Gran
         hmnki+rDkYHcB8g54aATDckPbB5s4Ho14yGwNgNPtP6vqaCZX37W7iuRitUC59O0frlg
         NIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756941885; x=1757546685;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JgPTVCi/fpzUuEvg9xD+jIRme2pJE3B6Yq7rj7B3nZY=;
        b=GYsB/9peEUDeVjZsHYchIZvoSTKPId6n3oGkhgT0uuMlnDd7z5ZWIt/0axDbVDBpuZ
         mAxYw+2LQBVqi4r88659ukZgoLsR51KQm6QUDZ4cP3Fhc64bN15w5DaxPOHxdeT7rQG6
         JULnrzq8o0mn3rdQmcOxEma5uiULqkBdKIi3/zMw3GxST7sB9rTi5L5+m3+k/BvQaznR
         0YGpTEyo6zfHa5oQrHe1XVQC604TUx0CBkR1mO1xcy+RcUaDo1vG4r9vxp4GMpTwfKLf
         OIbWBtPuGfZX4O3NsJ+xVOR8lK2lX0yh3DdgbGW6krCrhGiv/Xubl+7jgQYKXtiPT8Kd
         ysfg==
X-Forwarded-Encrypted: i=1; AJvYcCVnk6YOk6iXBKBMeI2aWD5ZNQSUOVd8UVnNJCqLMNEPY1yJ+wbq/Xljfz82dB6x/r/dc2dyRh4vyg==@kvack.org
X-Gm-Message-State: AOJu0YzRu3Cpf5SON6TayQ4/ULdI/lkB2UeX7L7zvQ4A0BWd0bttSeTz
	crKXGKMiNOZnEW7ShiDahip3ymPlqRAtKEedfxGCU7GGr+TnSeEs3KNz4B2jwTQofknw8hKfxA8
	4Ex0FMMMKLNdS3BxR5mWyjNvL+g==
X-Google-Smtp-Source: AGHT+IE847aFywtv64trKEqJQS4xk/rRzoYt8J98LejVPNK+qtP1XoLxGjxJLrG9gDKIj8QvnnA8vG+EvTtsf7QD3Q==
X-Received: from pjbst8.prod.google.com ([2002:a17:90b:1fc8:b0:312:ea08:fa64])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:c105:b0:32b:9506:1780 with SMTP id 98e67ed59e1d1-32b95061914mr549097a91.9.1756941885037;
 Wed, 03 Sep 2025 16:24:45 -0700 (PDT)
Date: Wed,  3 Sep 2025 16:24:35 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.338.gd7d06c2dae-goog
Message-ID: <20250903232437.1454293-1-kaleshsingh@google.com>
Subject: [PATCH] mm: centralize and fix max map count limit checking
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, David Hildenbrand <david@redhat.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 501AC40002
X-Stat-Signature: 7nm5iqhrk7hkeoc1xtzaba7phxtxeuyz
X-Rspam-User: 
X-HE-Tag: 1756941886-618231
X-HE-Meta: U2FsdGVkX1+mz/K8zqjR1+WLYagPb9EWF2hrB+n8S/xKzNS+FQ8ksbvgchK2FmWY7idfG9gz/UT457EbtNvdniUM5KUK1rBEg1GtCQJWM3uDFf4dx+SK5YsRxv4EfvG0Z5PQ2Flq+pA/JWWhJkuTf1Jps8HI312BIPiIov3uMY9Khs7OR/J+KOxEUpk2kGCorcCN/TNxsuqbnwjiucr7EMFmdZYEfJFAexYYMcnf7rpojSQQ/TpOywx/tKeiKm5zQl+i0d6qq+csovGo+wQD6R1WzzAY8zs/5GzZiEMJSCSTAg2YVTX0YdwFX3fVnEC/7r137i/jYA4f7qcNUHY/5doOiipR63QCy9ujJQkeXJ+9otcf1JpGaqnzXfd98JnCSJvIRLIPMKrznY23jWsUeYWhqXl/dwLp61y5p/S/j8AMo3x5rUEUiBDT3Ljn28ZoHzoDHTvYqUbAg4XTBA/PQTO1GHID5/GkongNzCordxszDIcbcqkePW4juehkdo0Vx0/pnmX8zaSIdNLUSh9yqPLfwj6HBqpMldwQqduRJbdp0GeNh7zQ5eMSRHB4G4hvsQzksvfQmVkMqloq9zNdjdUJbAu09H5OPBRNon0vVhq3DVY3tCuMeWOUCaGzGIYE5Kh00/8ZOD6ga34WlVTHpqb68lCjyrz+Wl+eTSXH52ZzWPLDQlRJ8zdEQMfir4I12lDJa1DWpjKPC7CvgCP0zVP0rDpKC4FsaOt/mSvCjiFeCCsVnMJA1nLCjqNPwErrk/dqqajNBIpFPbapI7LyYaZKY0kuUJV+7n3KPcqhF/PYtpQT1M/Jv6vUSAtBenVZm1iGkSRx6WoBgatKtDxflDAxOcqrEG5Js9C+Ri3FKyi+CLNV937nX3jwXbbBsTy5HZWXPXaqWWlk8iwhle7KTY6y1O9obwrNCFdUKeA004WIHn2mJBYOh2Cd8dzuT3x+W6N40udzdqgD7eJvVEN
 T3BhvcbD
 Yss6KgCpmWEmardl/cGnWoR4lqecNVZRii9DvPj0+m4XNwXi1p/GBFZZxYFD4X8UzU7Xljglg1zt7GRE3/kF5WkRyFp9gKY5p7mjE2G+mEBkEfUSBuEPR891HbRM5BhS6p0xu0srDm6qCPKf/CeWf6GPeYsm5HMhVp6dbGmBL9hm/AW6H3IoZLAUFLdKucWZGYRGAqUWAHD+mD83QmJq9UpGLkahiIZURCmrNvzW+UG3ywj6DDEJmpbBYOsZRJduWPajV344ir6IbQge1GVfnnpiHUoKdfcCgFKBQ+0AODoZhTf0gRZ9XAWYTV2VK1t5tCEIMTFgz2yDU1ECeP9ATt9a5Y/+wsCQdI+4R17a+a3EBX/1UVwxQnDUv4CMuALqpVUwskXY9gvp9nBpLOYp2vIz9iKXbdhch1XeH1VpLduFRfWdWWlM0uETw2Daxfsykltf32SLsj+xWv/86PRc0ybixfPIqiZa+F5Qa4IizmBa4Gy67/kSwilhm8LqM3xcH83GOoEDC1BhA/zSa0Bf/DvStcQDrZ4lV/97duPb7y4CyenlTAU1xr+3NinaSmvbdQBRQahe25rUB166/Y/RKRofjTTTkSC5z6uAfPGOU4HFrFxhb6Ymy8p/VZhS0lxQUnBQIcPW2dcOKZ5g5zWDmKsGVBpzgNqBoHpA5YCMoB9XHkOB4mqkQVbFC+JC5+qz4lkJ73Fg0+Z0ondTjUl9YL7wR5g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The check against the max map count (sysctl_max_map_count) was
open-coded in several places. This led to inconsistent enforcement
and subtle bugs where the limit could be exceeded.

For example, some paths would check map_count > sysctl_max_map_count
before allocating a new VMA and incrementing the count, allowing the
process to reach sysctl_max_map_count + 1:

    int do_brk_flags(...)
    {
        if (mm->map_count > sysctl_max_map_count)
            return -ENOMEM;

        /* We can get here with mm->map_count == sysctl_max_map_count */

        vma = vm_area_alloc(mm);
        ...
        mm->map_count++   /* We've now exceeded the threshold. */
    }

To fix this and unify the logic, introduce a new function,
exceeds_max_map_count(), to consolidate the check. All open-coded
checks are replaced with calls to this new function, ensuring the
limit is applied uniformly and correctly.

To improve encapsulation, sysctl_max_map_count is now static to
mm/mmap.c. The new helper also adds a rate-limited warning to make
debugging applications that exhaust their VMA limit easier.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---
 include/linux/mm.h | 11 ++++++++++-
 mm/mmap.c          | 15 ++++++++++++++-
 mm/mremap.c        |  7 ++++---
 mm/nommu.c         |  2 +-
 mm/util.c          |  1 -
 mm/vma.c           |  6 +++---
 6 files changed, 32 insertions(+), 10 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..d4e64e6a9814 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -192,7 +192,16 @@ static inline void __mm_zero_struct_page(struct page *page)
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
-extern int sysctl_max_map_count;
+/**
+ * exceeds_max_map_count - check if a VMA operation would exceed max_map_count
+ * @mm: The memory descriptor for the process.
+ * @new_vmas: The number of new VMAs the operation will create.
+ *
+ * Returns true if the operation would cause the number of VMAs to exceed
+ * the sysctl_max_map_count limit, false otherwise. A rate-limited warning
+ * is logged if the limit is exceeded.
+ */
+extern bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas);
 
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
diff --git a/mm/mmap.c b/mm/mmap.c
index 7306253cc3b5..693a0105e6a5 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count > sysctl_max_map_count)
+	if (exceeds_max_map_count(mm, 0))
 		return -ENOMEM;
 
 	/*
@@ -1504,6 +1504,19 @@ struct vm_area_struct *_install_special_mapping(
 int sysctl_legacy_va_layout;
 #endif
 
+static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+
+bool exceeds_max_map_count(struct mm_struct *mm, unsigned int new_vmas)
+{
+	if (unlikely(mm->map_count + new_vmas > sysctl_max_map_count)) {
+		pr_warn_ratelimited("%s (%d): Map count limit %u exceeded\n",
+				    current->comm, current->pid,
+				    sysctl_max_map_count);
+		return true;
+	}
+	return false;
+}
+
 static const struct ctl_table mmap_table[] = {
 		{
 				.procname       = "max_map_count",
diff --git a/mm/mremap.c b/mm/mremap.c
index e618a706aff5..793fad58302c 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	 * We'd prefer to avoid failure later on in do_munmap:
 	 * which may split one vma into three before unmapping.
 	 */
-	if (current->mm->map_count >= sysctl_max_map_count - 3)
+	if (exceeds_max_map_count(current->mm, 4))
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1811,9 +1811,10 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	 * split in 3 before unmapping it.
 	 * That means 2 more maps (1 for each) to the ones we already hold.
 	 * Check whether current map count plus 2 still leads us to 4 maps below
-	 * the threshold, otherwise return -ENOMEM here to be more safe.
+	 * the threshold. In other words, is the current map count + 6 at or
+	 * below the threshold? Otherwise return -ENOMEM here to be more safe.
 	 */
-	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
+	if (exceeds_max_map_count(current->mm, 6))
 		return -ENOMEM;
 
 	return 0;
diff --git a/mm/nommu.c b/mm/nommu.c
index 8b819fafd57b..0533e1e3b266 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1316,7 +1316,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
-	if (mm->map_count >= sysctl_max_map_count)
+	if (exceeds_max_map_count(mm, 1))
 		return -ENOMEM;
 
 	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
diff --git a/mm/util.c b/mm/util.c
index f814e6a59ab1..b6e83922cafe 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -751,7 +751,6 @@ EXPORT_SYMBOL(folio_mc_copy);
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;
-int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
 unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
 
diff --git a/mm/vma.c b/mm/vma.c
index 3b12c7579831..f804c8ac8fbb 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -592,7 +592,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (vma->vm_mm->map_count >= sysctl_max_map_count)
+	if (exceeds_max_map_count(vma->vm_mm, 1))
 		return -ENOMEM;
 
 	return __split_vma(vmi, vma, addr, new_below);
@@ -1345,7 +1345,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
+		    exceeds_max_map_count(vms->vma->vm_mm, 1)) {
 			error = -ENOMEM;
 			goto map_count_exceeded;
 		}
@@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count > sysctl_max_map_count)
+	if (exceeds_max_map_count(mm, 1))
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
-- 
2.51.0.338.gd7d06c2dae-goog


