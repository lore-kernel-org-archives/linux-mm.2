Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97B0ECAC597
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 16:46:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 038EF8E0017; Mon, 15 Sep 2025 12:46:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00FF68E0008; Mon, 15 Sep 2025 12:46:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E67F98E0017; Mon, 15 Sep 2025 12:46:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D35F88E0008
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 12:46:26 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7F5E2C06E7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:46:26 +0000 (UTC)
X-FDA: 83892062772.17.F42B081
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf07.hostedemail.com (Postfix) with ESMTP id 95D3A40014
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 16:46:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BC6X4smj;
	spf=pass (imf07.hostedemail.com: domain of 330LIaAsKCNI8y92G5G6B454CC492.0CA96BIL-AA8Jy08.CF4@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=330LIaAsKCNI8y92G5G6B454CC492.0CA96BIL-AA8Jy08.CF4@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757954784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kvhIc5Qwm2MSlXgaqDt0tPsJi6Fn6VtZiCytLA6TTWs=;
	b=LW35ojm5YIJHQTF1j0QL+g2FAvaam1THcRA+CCYL8txA1yn1X2rXwKjpXgkhjj6xkh2Yoy
	NAtCTWe6C5X4obG70IX6/MB/tRCMJzZ7kYGSOwkYX9lGFwY8JZI2MqdvZHrope+IFvR7Bd
	hDhAhemJ8Rz6BSYgz+nFT0SIuz8ov5I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BC6X4smj;
	spf=pass (imf07.hostedemail.com: domain of 330LIaAsKCNI8y92G5G6B454CC492.0CA96BIL-AA8Jy08.CF4@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=330LIaAsKCNI8y92G5G6B454CC492.0CA96BIL-AA8Jy08.CF4@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757954784; a=rsa-sha256;
	cv=none;
	b=KSNwZ7sXHe6yMDyLw+3OVeekfFoQ++iNQNSFrbZD6QcrK8iHhIoHMHhlevP1rWx2PUloiL
	hwpfLMkiA2TREj3WpjCT/kiuXTvRdWmHpiSP+fHwv84VzHPhq6xcBV2mLlQeJGlpfnBqnn
	0kbVs0xhRjl3Gva0lO0Vtgwg1dDcD1E=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-2445806b18aso42150495ad.1
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 09:46:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757954783; x=1758559583; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kvhIc5Qwm2MSlXgaqDt0tPsJi6Fn6VtZiCytLA6TTWs=;
        b=BC6X4smjBkRMdBNnhWte1AzvqKuNgvLMQEvwVd9URqWzU9zJtWyvPyLpbL9odxK0jj
         Fx4gjKq00rwH6ms8FdH73+VBP+/433az7M0z9E+K5zidJaYDIPcvdDeEl6ez879Ocs32
         p/MF5kzN0497DhEXRqeR1qCS7oUpPASfH4+ZuIWmuUw1nz1djIN4YGEYmaQuzWRqsEOq
         XvFCMlRID8S56o/CR+xU4UBf9Jj0sZ1NioPH5B6biHwzrFePvDogQwU56cMHo/xb8/ia
         O/vC/vI9bQcT+nhOREPpCUj6/MDB9Hyl94Fwz/IrYkQATiPF24eJPeCIuzGmegJZjD9d
         s76w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757954783; x=1758559583;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kvhIc5Qwm2MSlXgaqDt0tPsJi6Fn6VtZiCytLA6TTWs=;
        b=oCLN8MkUAFbCZO+9FBnq1vKWT0LQpav0/aBx856nB+wRbz1ToQlVOA40W+LPA3eJ5H
         10sqnvgR4B4QLbSrRw9uoQGe7iZxRSL5qzoOuIejEGI1L+hzefgF7t8utaiOY2V+50Jf
         Zeb/zz7q5vGd891/Zc5BdnUngtG78wUNj3FV0NAxcTPwqFdhMJQhIQMJtnTzd0wd8Gx1
         yYteTmvlk4cNjOV8lJfcy6TAUKu51ccl0reIbEP+Tw3wTVj7xAyJXqxn3i2zc1s+fN3f
         RXwi4/SQqMXVo5K8JBe7oSdWbhOQ0er9UrD4UxliM5ekNSRYLQadp4fbXknBsyCicQim
         NaCw==
X-Forwarded-Encrypted: i=1; AJvYcCUevMDPuVcvkw13jPcqqp6PcciqJSMG8hr2aHMtUNfVTxEMFPunlSJCwyQaUHPzCsSLCCUzVG7/yw==@kvack.org
X-Gm-Message-State: AOJu0Yy7pI/IbZgWJylzuoacLXSeA0jRRfdItqn1OB1cH08uLAVXqfKQ
	DkOtbzRn2cCPDzOr+p6G2QV91uINcFd1D9KZ7tAU7FX4mvC3jUBw2KPQuVa9taosDlwyqn0J4nc
	Ov4sxsfE/QGJOke+MKFv65Ppbhg==
X-Google-Smtp-Source: AGHT+IETjSAgl4Bq7YGi4NHOQLEhA++l/mjHETWNYuPpSZDm1ovOxLN6UFeAYtoyBJbEGZn5mcnKagruLzvaK22crw==
X-Received: from plap12.prod.google.com ([2002:a17:902:f08c:b0:264:3c1f:6385])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:240c:b0:24e:3cf2:2450 with SMTP id d9443c01a7336-25d23e13c87mr190358195ad.2.1757954783437;
 Mon, 15 Sep 2025 09:46:23 -0700 (PDT)
Date: Mon, 15 Sep 2025 09:36:34 -0700
In-Reply-To: <20250915163838.631445-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20250915163838.631445-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.384.g4c02a37b29-goog
Message-ID: <20250915163838.631445-4-kaleshsingh@google.com>
Subject: [PATCH v2 3/7] mm: introduce vma_count_remaining()
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jann Horn <jannh@google.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 95D3A40014
X-Stat-Signature: njbupys6xqj1xsyj1gs8e16gxucz9xdg
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757954784-682009
X-HE-Meta: U2FsdGVkX1+tHSGy1e3kwG/fdmDBvSIVBr1mhEXJF2rwNr5kfwuVOBgmqJc3X1UCfqAym1j7PFzduI1hHfz9ASxAGPyRvparybD+xi0ix+zlYSLBZtE5yHynGk0eU9lzRpVifvRVXhGg9SaivI9aeq9ciDJx+7CbG1VHx90bksOZQXR8zgH+kRTzk+UZjXY3BvRS3U7QlMoWmie0MG9KNkEG+EpAp4dEtk4AO5VFL43UXYman8uEpHcPF4+YTfvy0N0nOlGZAgZBKTr6TlfwJC1p8BErXeUATBJ2ATcdud8QkB9XboGLEwu7ZcQrlOC2+wtn+tefJgPl9YVXFmywN/d7wcLs6Hh07Iqwtp9Tu85x1cqQJE5saCHhzUkaCCifqcHIvCPM36DvQbigYtlg89cLkjUhwVMtlF9yXCoLTjkTdaqYbRNJOTsS0L/bqPDdZS46ijgukY7Ck8IW8TALl7KCYTdXLdC22hvLlTLD90aGsbnjAt5yBeAjiKRn0ZjfLMo+2WfTalA2B3vMKIdxVdZaoRsRuhzIxKKDlHhIwH9swr4SRmBuv4dF3dIXUuQQz49+zc0DW+DtfmDdiKi0mJkmSTmf8H0zgZRGdhiwpaVuvZCyYYazD9y+8PkWU1linCuepNCVaDtzJc+khDEmYcmkBojNV9YDfl6n+3AvmjrBgrMZV8ekL3/uv334k9X9C4DXoLjuFOKhMEgmzXOd+94umWoOYyu983KpK+QQO3c9Kf7a7jq40jSKTBMbaN7OVCqAPKEtwa1SQiXLLM7tJJvEVcnL6pXp7mMgGKODY+ohv6xg/fmSRzXiLkOLHNl3kDLoqpOMuKpYZ6+HOtH+WeLmIA+CGVtpK/v6tVbQExpYuWAbOx4PoOJkMSWvc/PMleo3oU/mMwoDftkLFW62FamExWDYg556doroel1YFY5vc3J1mSkjgWO3VUg8NBrcZfNIa9O6e5XQVQ4rHfN
 LkUvBpy5
 25iirCpfUjgfMK1bcNodtV4b4ObH/yAGREsN241m1wrYwzrm+Le4EJ3VgFKLfBCGX+ZZlU6cqh76gQQZfEGV1L+N3QvbhAPfazGL44SMrP2C+Z/inNuQkb9SppfAYIcmOg2C85c67eu67yaZF6LPsnQ8PmxxIWn10Q2Yvf2GSz2k9soX94gV7DhJ71pSadHe0K0Njc/gH7CkFHDQGtvNd1DoIr+c97RmhSvGQuGuhGDlB4LiHOgYlQvZTPIfRw51084n24aZKVMHmXQFwlxT/aVaui9xLoT0p1wqPF3Vmx/8mmIQt3RJlassmw6USuQ/Mw561QvN1Gx+SsDcb6ChJv3Akl1wqdqcDBXi0Qyt3/T6wBWWC4JZ43pfypSTo/N21egxEaB2Kw8QGL4yCk1rj5GoOkPJQzsR/ELsWBT77xyXYO2gXmdN0pIh8PLoraY1NfUmnt69oyqcpASrO3g3FRzPFVNMF+rXYSKULcFDZ3sR285OGrllhi56ZX4Rn7ELay2qZPUQUCKoH5MVEi0hmMiVuvjuIx1HCiHJcBluAB8jDMgdBgkTrBlT00J0EwNMR7LQg62DH9oqgBVRMKSQEvZRnUi2BmEKPs9hUSsWCXuThRhVS8oXAEuL+aiweGiRCe8g/OZZBnUFJuIGmHcYS3CheZe7QpuJaBV9QokL9MxBxLKHSXkuDhVJ5E1cVPLBCreFTAcCGm4bjD5DWnSCquiiGk1j0MiyhgeKGjelHXU+0KbGh8EaCe8YatONa//e+rUZOH4xBwt6U9cUUXsX83L0yxRO5mI8PAReV
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The checks against sysctl_max_map_count are open-coded in multiple
places. While simple checks are manageable, the logic in places like
mremap.c involves arithmetic with magic numbers that can be difficult
to reason about. e.g. ... >= sysctl_max_map_count - 3

To improve readability and centralize the logic, introduce a new helper,
vma_count_remaining(). This function returns the VMA count headroom
available for a givine process.

The most common case of checking for a single new VMA can be done with
the convenience helper has_vma_count_remaining():

    if (!vma_count_remaining(mm))

And the complex checks in mremap.c become clearer by expressing the
required capacity directly:

    if (vma_count_remaining(mm) <  4)

While a capacity-based function could be misused (e.g., with an
incorrect '<' vs '<=' comparison), the improved readability at the call
sites makes such errors less likely than with the previous open-coded
arithmetic.

As part of this change, sysctl_max_map_count is made static to
mm/mmap.c to improve encapsulation.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@redhat.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Pedro Falcato <pfalcato@suse.de>
Signed-off-by: Kalesh Singh <kaleshsingh@google.com>
---

Changes in v2:
  - Fix documentation comment for vma_count_remaining(), per Mike
  - Remove extern in header, per Mike and Pedro
  - Move declaration to mm/internal.h, per Mike
  - Replace exceeds_max_map_count() with capacity-based vma_count_remaining(),
       per Lorenzo.
  - Fix tools/testing/vma, per Lorenzo.

 include/linux/mm.h               |  2 --
 mm/internal.h                    |  2 ++
 mm/mmap.c                        | 21 ++++++++++++++++++++-
 mm/mremap.c                      |  7 ++++---
 mm/nommu.c                       |  2 +-
 mm/util.c                        |  1 -
 mm/vma.c                         | 10 +++++-----
 tools/testing/vma/vma_internal.h |  9 +++++++++
 8 files changed, 41 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 1ae97a0b8ec7..138bab2988f8 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -192,8 +192,6 @@ static inline void __mm_zero_struct_page(struct page *page)
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
-extern int sysctl_max_map_count;
-
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc03..39f1c9535ae5 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1661,4 +1661,6 @@ static inline bool reclaim_pt_is_enabled(unsigned long start, unsigned long end,
 void dup_mm_exe_file(struct mm_struct *mm, struct mm_struct *oldmm);
 int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm);
 
+int vma_count_remaining(const struct mm_struct *mm);
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index e5370e7fcd8f..af88ce1fbb5f 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count >= sysctl_max_map_count)
+	if (!vma_count_remaining(mm))
 		return -ENOMEM;
 
 	/*
@@ -1504,6 +1504,25 @@ struct vm_area_struct *_install_special_mapping(
 int sysctl_legacy_va_layout;
 #endif
 
+static int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
+
+/**
+ * vma_count_remaining - Determine available VMA slots
+ * @mm: The memory descriptor for the process.
+ *
+ * Check how many more VMAs can be created for the given @mm
+ * before hitting the sysctl_max_map_count limit.
+ *
+ * Return: The number of new VMAs the process can accommodate.
+ */
+int vma_count_remaining(const struct mm_struct *mm)
+{
+	const int map_count = mm->map_count;
+	const int max_count = sysctl_max_map_count;
+
+	return (max_count > map_count) ? (max_count - map_count) : 0;
+}
+
 static const struct ctl_table mmap_table[] = {
 		{
 				.procname       = "max_map_count",
diff --git a/mm/mremap.c b/mm/mremap.c
index 35de0a7b910e..14d35d87e89b 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -1040,7 +1040,7 @@ static unsigned long prep_move_vma(struct vma_remap_struct *vrm)
 	 * We'd prefer to avoid failure later on in do_munmap:
 	 * which may split one vma into three before unmapping.
 	 */
-	if (current->mm->map_count >= sysctl_max_map_count - 3)
+	if (vma_count_remaining(current->mm) < 4)
 		return -ENOMEM;
 
 	if (vma->vm_ops && vma->vm_ops->may_split) {
@@ -1814,9 +1814,10 @@ static unsigned long check_mremap_params(struct vma_remap_struct *vrm)
 	 * split in 3 before unmapping it.
 	 * That means 2 more maps (1 for each) to the ones we already hold.
 	 * Check whether current map count plus 2 still leads us to 4 maps below
-	 * the threshold, otherwise return -ENOMEM here to be more safe.
+	 * the threshold. In other words, is the current map count + 6 at or
+	 * below the threshold? Otherwise return -ENOMEM here to be more safe.
 	 */
-	if ((current->mm->map_count + 2) >= sysctl_max_map_count - 3)
+	if (vma_count_remaining(current->mm) < 6)
 		return -ENOMEM;
 
 	return 0;
diff --git a/mm/nommu.c b/mm/nommu.c
index 8b819fafd57b..dd75f2334812 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1316,7 +1316,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
-	if (mm->map_count >= sysctl_max_map_count)
+	if (!vma_count_remaining(mm))
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
index 033a388bc4b1..df0e8409f63d 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -491,8 +491,8 @@ void unmap_region(struct ma_state *mas, struct vm_area_struct *vma,
 }
 
 /*
- * __split_vma() bypasses sysctl_max_map_count checking.  We use this where it
- * has already been checked or doesn't make sense to fail.
+ * __split_vma() bypasses vma_count_remaining() checks. We use this where
+ * it has already been checked or doesn't make sense to fail.
  * VMA Iterator will point to the original VMA.
  */
 static __must_check int
@@ -592,7 +592,7 @@ __split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		     unsigned long addr, int new_below)
 {
-	if (vma->vm_mm->map_count >= sysctl_max_map_count)
+	if (!vma_count_remaining(vma->vm_mm))
 		return -ENOMEM;
 
 	return __split_vma(vmi, vma, addr, new_below);
@@ -1345,7 +1345,7 @@ static int vms_gather_munmap_vmas(struct vma_munmap_struct *vms,
 		 * its limit temporarily, to help free resources as expected.
 		 */
 		if (vms->end < vms->vma->vm_end &&
-		    vms->vma->vm_mm->map_count >= sysctl_max_map_count) {
+		    !vma_count_remaining(vms->vma->vm_mm)) {
 			error = -ENOMEM;
 			goto map_count_exceeded;
 		}
@@ -2772,7 +2772,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count >= sysctl_max_map_count)
+	if (!vma_count_remaining(mm))
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 3639aa8dd2b0..52cd7ddc73f4 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1517,4 +1517,13 @@ static inline vm_flags_t ksm_vma_flags(const struct mm_struct *, const struct fi
 	return vm_flags;
 }
 
+/* Helper to get VMA count capacity */
+static int vma_count_remaining(const struct mm_struct *mm)
+{
+	const int map_count = mm->map_count;
+	const int max_count = sysctl_max_map_count;
+
+	return (max_count > map_count) ? (max_count - map_count) : 0;
+}
+
 #endif	/* __MM_VMA_INTERNAL_H */
-- 
2.51.0.384.g4c02a37b29-goog


