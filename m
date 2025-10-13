Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE6AACCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 23:56:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 371E38E00B2; Mon, 13 Oct 2025 19:56:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D4728E0024; Mon, 13 Oct 2025 19:56:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C3D38E00B2; Mon, 13 Oct 2025 19:56:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 05A088E0024
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 19:56:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A3E4C14067C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:56:12 +0000 (UTC)
X-FDA: 83994752184.15.ED0A494
Received: from mail-pl1-f201.google.com (mail-pl1-f201.google.com [209.85.214.201])
	by imf19.hostedemail.com (Postfix) with ESMTP id C5D421A000E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 23:56:10 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xA69B2GM;
	spf=pass (imf19.hostedemail.com: domain of 3mZHtaAsKCMAqgrkynyotmnmuumrk.iusrot03-ssq1giq.uxm@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3mZHtaAsKCMAqgrkynyotmnmuumrk.iusrot03-ssq1giq.uxm@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760399770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWS8JbZTybY/HgwtmvUUAsgUoQtqFfjRM6A15QtRFtc=;
	b=kNB25CyeLRZF8NY57dQjlzpTmbsBAlkzsSUBLlMRFNMjsbxe/1T23O6q6UQbQfHsAagLUc
	bAkqTZTroCncw5piKTgmTN8NcYRMJ4JLe211XAL8DnBYsnuXuDH4ICS/lxHHnrvvu+ynV0
	zwT8iav5fVk/K9ZQNNAoGZhOjLt+hPw=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=xA69B2GM;
	spf=pass (imf19.hostedemail.com: domain of 3mZHtaAsKCMAqgrkynyotmnmuumrk.iusrot03-ssq1giq.uxm@flex--kaleshsingh.bounces.google.com designates 209.85.214.201 as permitted sender) smtp.mailfrom=3mZHtaAsKCMAqgrkynyotmnmuumrk.iusrot03-ssq1giq.uxm@flex--kaleshsingh.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760399770; a=rsa-sha256;
	cv=none;
	b=iRRCinfzvwCFRzGx6k1g1ojog1cQN9Tl74acob6Hko0qLEMQpuXJp5ljqbiQ5g/pTa/AEf
	A9O5jXz+8QgYL6xF4dGJRr2EKIis5EJ23dTfLXP67zDKpLjdkduf44snZjBvzy8euXR1UC
	Ve8ObI7zdePKOvmWrP7Zf0K5ehOoruY=
Received: by mail-pl1-f201.google.com with SMTP id d9443c01a7336-269af520712so92128715ad.2
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 16:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760399769; x=1761004569; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=dWS8JbZTybY/HgwtmvUUAsgUoQtqFfjRM6A15QtRFtc=;
        b=xA69B2GMY3IndqXiJmsaPRT99KldiVTy+bAHHojhP4R4yInutP/k+QKv+r06P+LPq7
         JJeTPAA0I8tnamRUxl0Rj4AMXqv1Zkg+3sVpbs7FW7o4p89nwmWGcIjti69bh0+ZjaD0
         mZIygVQ/HJsHiJF3TWINCW63ZuvHZU9xx9IHYsSAhgxBEeoc12Ky29Mq8iQ+O6AuNWOk
         ubu6IIBYHiP9WAD423zc/d2Hk+6J/qeypvdEfPobXJ708ajENbywkFZX8XeDvpHz1AkA
         8K8y/HRO6TRRuyKUOpIgMaHhej98QlWDvAj9SlW4BZgbR2ojhIk4+H4HxRwqR9UxJ1n0
         uD0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760399769; x=1761004569;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dWS8JbZTybY/HgwtmvUUAsgUoQtqFfjRM6A15QtRFtc=;
        b=c6bS3BWLYC9PCDIk2JxInBwcH4o8xb8QYqRmXE70/YE9uZYQ7GO6PQ/g0Ybwx4LUOk
         2IliCNUMWunSDvKrcjgfgQnTJQakYRXlJWZxOoLtpFqTyX1IxV3ae53tMJIpIsVO8xba
         hv8qxsXgNM5SwJ3m8y1/SejnQUv5inc4SwcxxGP3iG0XN1uJ8kcjmpPRz0sCdm/zJ3e5
         zYwANPjYu2TSI4kKfnx18eyt1JvdqUMvW+lE+kBW2w0gqyssHU80Uzy+QnEiISRgaREE
         CLjx8h0KpasRwMB9MxXVvrGayy4vEsVXohXWwK65rL2tJM0w7zVSlJsFJEdEeuybJX3r
         Vwfw==
X-Forwarded-Encrypted: i=1; AJvYcCUu6cDDrAinSnt7GIr4COGosCYfJVufQO1p4+EnRCz/t++nxTifFpY2BXYT0UTE8qoYx5rxW55t5g==@kvack.org
X-Gm-Message-State: AOJu0YyDPbgP3kY9VYRKccqsLQQXKAWFTo5Ks8XoxXFF6zYK0YTiQyTk
	r+D7easAYtgJymbjkTLpBpG4uy6TaK9J3gsxFajhjBCoF0dLPWpzoOC3eYj2p/OfI/w2mbpA+Gp
	CPnOzL8USGT/pWoBcoen9wB5GOQ==
X-Google-Smtp-Source: AGHT+IGz7Acs955+JHt6jWBnGAVlrb2i9ZFcEZvLhMTomk5H/KJdcpKZNG2gPSwMMx7169I77mG09nPrtox3WC7DAA==
X-Received: from plsd3.prod.google.com ([2002:a17:902:b703:b0:27d:6f45:42ec])
 (user=kaleshsingh job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:903:3c2c:b0:24e:81d2:cfda with SMTP id d9443c01a7336-290272500c7mr257234325ad.0.1760399769577;
 Mon, 13 Oct 2025 16:56:09 -0700 (PDT)
Date: Mon, 13 Oct 2025 16:51:54 -0700
In-Reply-To: <20251013235259.589015-1-kaleshsingh@google.com>
Mime-Version: 1.0
References: <20251013235259.589015-1-kaleshsingh@google.com>
X-Mailer: git-send-email 2.51.0.760.g7b8bcc2412-goog
Message-ID: <20251013235259.589015-4-kaleshsingh@google.com>
Subject: [PATCH v3 3/5] mm: introduce vma_count_remaining()
From: Kalesh Singh <kaleshsingh@google.com>
To: akpm@linux-foundation.org, minchan@kernel.org, lorenzo.stoakes@oracle.com, 
	david@redhat.com, Liam.Howlett@oracle.com, rppt@kernel.org, pfalcato@suse.de
Cc: kernel-team@android.com, android-mm@google.com, 
	Kalesh Singh <kaleshsingh@google.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Kees Cook <kees@kernel.org>, 
	Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, 
	Dietmar Eggemann <dietmar.eggemann@arm.com>, Ben Segall <bsegall@google.com>, 
	Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, Shuah Khan <shuah@kernel.org>, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: soahznodwdzgthzmfkfqqchrgibd477b
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C5D421A000E
X-HE-Tag: 1760399770-327516
X-HE-Meta: U2FsdGVkX188tRuQQIlGCkXFmh60g1Mng/qMfV5xnZ2z189P2fXg9rXJqTaatDRaF/vRKiEc1OkerDQF566q2VnhwEQbd1aF0Yz7gc8okSXkGmJFltfoWIfkpwC+bJZ+4plxSC0vKOD+BCFNW/+N6cp9fnpJbXwqtBhG2uOzCCXVDomNDe0AsFuQDxX2tj+1ldfF6Pi6BykRSww3OUKsHM4u0EDCmPSRGI0AXNMA6VDuZOcZJtLBcWkqmCKo6YgIQBIvu69oCw1tOjMcL4Spiz7S+SyGrASnU0PbgQhHNqsaF4CyH5zFSO2j2oVJMxZ2Jl/5tk5eYdt0XZCNn1/w8KOXFM0dfcFeMSnc4m4Kc0XtOBCcCLdjp/BxqgbSFuUCxxaf4AN3CBmgzRX9+9mPdDvZpos1R5BTg1qxl93RbD0RUIeJOCqsTBSkNcsFf2hr4rFKhpU5ksjPmINHT4I1dFZtD+kc6SQp84cQnJ6ubco+4Yvb31Apm/txzixTJ3l6u/3oH9NxO7c7GqWNVwXKlMZFLaTcSz92cUh5JVSFAKBY0phzWTCQ7/CAlrcjO52E8AGfz7DALJcBCVcZAAsinn76ciHd7G4icGgvZQAguXGzNK9UFznn1T0NraVl21918nlMKfg+GO77iizgPEodKdz4Cmm6c73MTO0emxXZiXV/xygxZjBcK0apvMFn0TVOnAAWDL31k9ZY3R1U3+X1MLd3FIt2Gm8r5Gi5W2/BMhJUEIh/wu/rpcjJ07D6h3UUN6LEPruDc0uWQ7Z96qKE6y+GFO096RIZKKkORdl/0mWvAmECjQLDgH0cjuFYu2fB+/snE5IVIHImqoTuTDILsTxNfEe+uaEhgxSdhjK/mEmqlY/J4Xg94Xd88hO6IWAWEJZZWI4KNkWPklHobU1aRSkKnp7o1TSEH6p53UKsDVhHvkeh8w8KX0UrRVEcEXT08E2jrdeT7gU03VtqqUM
 CsB0tijQ
 6KyMBD9PQdISGztg47x3uJIK2awWR+XFs1eH+b2JqbyHTA4yuyFpbeADlr4JIDZkzt4Djxn9RCU/YHHEHpaX4JvsqRgdhjWdB/tVx0Or6G2wO5FXJAHitWYQx3pvikyboQv5xvwOdyL+FZDI4/9xgrDk7IQlfh6Fw8KMheK7GeaD5b6YgOYUK0coVyT8+RwNEYV6uBhAT+a2vr0xYlTFypxXP+RhbzAmITcwnbWcsTHXWf+UG0lUs9faHteBhGb657uSpmCXno+FThg0k/xocZUnsqBw25YW/pGQtkl9MFU8hu5Pb6ousPq2cmFYO9zI5qvSNGKjyCxp4wX5UZwnZLUhNnQgga73IUi0jflv4Plr4g/WG6HLDZOqDxQp15po9+M+Qo+lHY9BRhIG79u09AoJ/3OAwaG+cDkhWv2cIDpfCP8AG3enjVBgfkYSjykB26AJOrQHPd8uioI5wlOoyheMz0RU9ay+NYTSj+VbAZmUdStoRSqDkMQYtZyincFNngRlNN0Ufs4lSGFjw41QuBl/HPd0OIbSWZsWEjog8F2Fy8pwPtkDHNA20bfG0zd7TfgTLnWiZPcjW4bW4B42mvc9wHUeyUMP1+N07fcH4/yqiH2kszgHSBiAKMP8905uEwlxMN3n0k+aa05K0eBLdp2xQ2SSaSmnej744+M4F41Bqn2y1jYsZf9nQzAMG83o5+ccMiswxX2E1wImsv9Rf6VBKDYW6+lCZeAMtdzu8E8HbqPKDC7Xr1vL8moZDMj5axV/zYwOfj0WLXczbZZgbjb/UG/FQe0+9r/c6
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
available for a given mm.

The most common case of checking for a single new VMA can be done with
the convenience helper has_vma_count_remaining():

    if (!vma_count_remaining(mm))

And the complex checks in mremap.c become clearer by expressing the
required capacity directly:

    if (vma_count_remaining(mm) < 4)

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

Changes in v3:
 - Move vma_count_remaining() out of #if CONFIG_SYSCTL to fix build 
   failure
 - Use READ_ONCE() for sysclt_max_map_count, per David, Lorenzo
 - Remove use of ternary op in vma_count_remaining, per Lorenzo
 - Rebase on mm-new to fix conflicts in vma_internal.h and
   mm/internal.h

 include/linux/mm.h               |  2 --
 mm/internal.h                    |  3 +++
 mm/mmap.c                        | 24 +++++++++++++++++++++++-
 mm/mremap.c                      |  7 ++++---
 mm/nommu.c                       |  2 +-
 mm/util.c                        |  1 -
 mm/vma.c                         | 10 +++++-----
 tools/testing/vma/vma_internal.h |  9 +++++++++
 8 files changed, 45 insertions(+), 13 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 5c01c4b59ca6..72ff386ef772 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -203,8 +203,6 @@ static inline void __mm_zero_struct_page(struct page *page)
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
-extern int sysctl_max_map_count;
-
 extern unsigned long sysctl_user_reserve_kbytes;
 extern unsigned long sysctl_admin_reserve_kbytes;
 
diff --git a/mm/internal.h b/mm/internal.h
index a2555be247e5..289aca3bdb6c 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -1682,4 +1682,7 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
 	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
 }
 
+/* mmap.c */
+int vma_count_remaining(const struct mm_struct *mm);
+
 #endif	/* __MM_INTERNAL_H */
diff --git a/mm/mmap.c b/mm/mmap.c
index da2cbdc0f87b..d9ea029cd018 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -374,7 +374,7 @@ unsigned long do_mmap(struct file *file, unsigned long addr,
 		return -EOVERFLOW;
 
 	/* Too many mappings? */
-	if (mm->map_count >= sysctl_max_map_count)
+	if (!vma_count_remaining(mm))
 		return -ENOMEM;
 
 	/*
@@ -1495,6 +1495,28 @@ struct vm_area_struct *_install_special_mapping(
 					&special_mapping_vmops);
 }
 
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
+	const int max_count = READ_ONCE(sysctl_max_map_count);
+
+	if (map_count >= max_count)
+		return 0;
+
+	return max_count - map_count;
+}
+
 #ifdef CONFIG_SYSCTL
 #if defined(HAVE_ARCH_PICK_MMAP_LAYOUT) || \
 		defined(CONFIG_ARCH_WANT_DEFAULT_TOPDOWN_MMAP_LAYOUT)
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
index c3a23b082adb..22e55e7c69c4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1317,7 +1317,7 @@ static int split_vma(struct vma_iterator *vmi, struct vm_area_struct *vma,
 		return -ENOMEM;
 
 	mm = vma->vm_mm;
-	if (mm->map_count >= sysctl_max_map_count)
+	if (!vma_count_remaining(mm))
 		return -ENOMEM;
 
 	region = kmem_cache_alloc(vm_region_jar, GFP_KERNEL);
diff --git a/mm/util.c b/mm/util.c
index 088e1f8edcf5..3315e1136c69 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -752,7 +752,6 @@ EXPORT_SYMBOL(folio_mc_copy);
 int sysctl_overcommit_memory __read_mostly = OVERCOMMIT_GUESS;
 static int sysctl_overcommit_ratio __read_mostly = 50;
 static unsigned long sysctl_overcommit_kbytes __read_mostly;
-int sysctl_max_map_count __read_mostly = DEFAULT_MAX_MAP_COUNT;
 unsigned long sysctl_user_reserve_kbytes __read_mostly = 1UL << 17; /* 128MB */
 unsigned long sysctl_admin_reserve_kbytes __read_mostly = 1UL << 13; /* 8MB */
 
diff --git a/mm/vma.c b/mm/vma.c
index fba68f13e628..96ba37721002 100644
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
@@ -2797,7 +2797,7 @@ int do_brk_flags(struct vma_iterator *vmi, struct vm_area_struct *vma,
 	if (!may_expand_vm(mm, vm_flags, len >> PAGE_SHIFT))
 		return -ENOMEM;
 
-	if (mm->map_count >= sysctl_max_map_count)
+	if (!vma_count_remaining(mm))
 		return -ENOMEM;
 
 	if (security_vm_enough_memory_mm(mm, len >> PAGE_SHIFT))
diff --git a/tools/testing/vma/vma_internal.h b/tools/testing/vma/vma_internal.h
index 3525f5c15e1b..70f11163ab72 100644
--- a/tools/testing/vma/vma_internal.h
+++ b/tools/testing/vma/vma_internal.h
@@ -1484,4 +1484,13 @@ static inline int do_munmap(struct mm_struct *, unsigned long, size_t,
 	return 0;
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
2.51.0.760.g7b8bcc2412-goog


