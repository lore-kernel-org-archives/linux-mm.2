Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74D50FF8875
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 13:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE7036B0098; Wed, 29 Apr 2026 09:15:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBDDD6B0099; Wed, 29 Apr 2026 09:15:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CADAC6B009B; Wed, 29 Apr 2026 09:15:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B7BCF6B0098
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 09:15:31 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 56DF040248
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:15:31 +0000 (UTC)
X-FDA: 84711640062.05.061C351
Received: from alln-iport-3.cisco.com (alln-iport-3.cisco.com [173.37.142.90])
	by imf19.hostedemail.com (Postfix) with ESMTP id ECA861A0004
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 13:15:26 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cisco.com header.s=iport01 header.b=Kx1KdbZw;
	spf=pass (imf19.hostedemail.com: domain of dtominac@cisco.com designates 173.37.142.90 as permitted sender) smtp.mailfrom=dtominac@cisco.com;
	dmarc=pass (policy=reject) header.from=cisco.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777468527;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=MzqT9uZB946TR2CRO0Exvqdeomed2JY37QjyuIWHr4w=;
	b=RrvEJVX5uODzn/ZP7Fk+nUudQwKIbsI8mB1IvYEMVAYAthn37wb0ZdAXHDziXpyINF71W8
	3NQBjSztb8tkychAZw8A6WmryUAIj8AIWiptX5r9vm8rnMj38/glWa7oEfavXoTtysWYnU
	QfZwuz1F4oz1AoMN6oZeCAjEKSxzZl0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cisco.com header.s=iport01 header.b=Kx1KdbZw;
	spf=pass (imf19.hostedemail.com: domain of dtominac@cisco.com designates 173.37.142.90 as permitted sender) smtp.mailfrom=dtominac@cisco.com;
	dmarc=pass (policy=reject) header.from=cisco.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777468527; a=rsa-sha256;
	cv=none;
	b=OxaAJZva9huDsuiSJYCLo2xfHQfRS33vJSudr3yozdAEpk5c4aX7DMbjWN3I8gGrwLJeGe
	jRLVEd+O1Ev7ytDQ7/JegHNjjPLRweDAsFMwvywqjyxH6YrvtsZoYpuCGlNqfUmTn7ElTc
	4Tzvf26DvPed4fx2lK19Bc5jHV2aVD0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=10963; q=dns/txt;
  s=iport01; t=1777468527; x=1778678127;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MzqT9uZB946TR2CRO0Exvqdeomed2JY37QjyuIWHr4w=;
  b=Kx1KdbZwXFNln3SK+SHiuKSc9e0l/DRSbBYT7IWRzNAAvdk1elPpop0V
   X3LMsoAIqd634d7ZsKXrjRcDQb8SFiACEfCNS7RzS1sJ1/zN9X73f/kAk
   okuWp2VJ3Jhlk9c+CFkekuTmkdW8jw0NQq8a36bEOA0TvDmc240vyv5Xn
   46LKTHlIy6Hu5H0xCwGQgxa0/qPqTVhRDqUSfiNtSZTiKuZ/jbnJzIjxm
   J/pCkdvbg2oHdisGOcSougI7FZbGl+XOceZltBKZAAJLeA6ySzUl/pUxR
   LcKkrZ6MkVTHchWh+Vj2zvOw2T11H8lhM/nh1TJIbn6DafU9ca8yisZfO
   A==;
X-CSE-ConnectionGUID: 8RcsoiOKRiiF8CeWlcfmxg==
X-CSE-MsgGUID: YIC/ySI+TDqfkeya0FKoag==
X-IPAS-Result: =?us-ascii?q?A0BKCAC4A/Jp/5X/Ja1aHgEBCxIMgWsQDwuCU4FLBENJl?=
 =?us-ascii?q?kugHA8BAQEPUQQBAYISgnSNMwImNwYOAQIEAQEBAQMCAwEBAQEBAQEBAQEBA?=
 =?us-ascii?q?QoBAQUBAQECAQcFgQ4ThlyGXSsLAUYpgRQBEoMCgnQDsmyBeTOBAbgigWQBC?=
 =?us-ascii?q?xQBgTiNW4VuJxuBSUSEB3aLBwSCIoEOhBOKcEiBHgNZLAFVEw0KCwcFgTMzA?=
 =?us-ascii?q?yAKCxISGBUCFBwBEg8EFjIdcAwnEiwXgQwbBwWBS4MQbRRWgQaEXngjLANMA?=
 =?us-ascii?q?wsYDUgRLDcGDhsEPm4HijkeD4E9LEYBPBYoEwGBMBMILGARC5J1JgGzSoQmo?=
 =?us-ascii?q?VgaM4QElBWSUQEumFgiqR+BfiaBWTMaCBsVgyJTGQ+OLRaTHQG2ZEQyPQIHA?=
 =?us-ascii?q?gcNAwuTZQEB?=
IronPort-Data: A9a23:2GmUpqraeSMP00ANvpiVg6shnDFeBmKSZRIvgKrLsJaIsI4StFCzt
 garIBnUM/iIZzOke410PI+18kNU78WEzIJlHQJk/39kHyoRoOPIVI+TRqvS04x+DSFioGZPt
 Zh2hgzodZhsJpPkjk7zdOWn9T8ghf/gqoPUUIbsIjp2SRJvVBAvgBdin/9RqoNziLBVOSvV0
 T/Ji5OZYgTNNwJcaDpOtfrf8kI34JwehRtB1rAATaET1LPhvyF94KI3fcmZM3b+S49IKe+2L
 86rIGaRpz6xE78FU7tJo56jGqE4aue60Tum1hK6b5Ofbi1q/UTe5EqU2M00Mi+7gx3R9zx4J
 U4kWZaYEW/FNYWU8AgRvoUx/yxWZcV7FLH7zXeX4faY1ErHVFjWwvRAXGo7AokT9ONnDjQbn
 RAYAGhlghGrnem6xve/D+JrnMlmdZOtN4IEsXYmxjbcZRokacmcGOORupkCgWp235wfdRrdT
 5JxhT5HYAjHZhxJM1w/A5Mll+DujX76G9FdgA3J+/JsvDCDkGSd1pDcEfGSa+erBvl5h0ibq
 3PPp0raBRgVYYn3JT2ttyjEavX0tSbyQoFUDqCk8vdsjHWa3GlVAxoTPXO6u/62h1Slc91YL
 EMQ92wlqq1a3E6iSN/9dxK/p3GAs1gXXN84O/U39AyX2ILV5QiDD2QJRzIHb8Yp3Oc/SSYr3
 1nPn87vGTF1mLyTVX+ZsLyTqFuaMCMQIEcBaDUCQA9D5MPsyKk/hwzOQv5gHbSzg9mzHiv/q
 xiIqywljp0QgNQN2qH9+krI6xqopIPhTQMv4AjTGGW/4WtRYY6kfYWt4ETz7vtaKoudCF6bs
 xAsncGb7PETC56llyGXRugJWraz6J6tLjfVi11mN5os7TKg/zikZ484yDV/Ilp5d8MBUTz3a
 UTQ/wRL6/d7PnKvYLQxaIa4EccCyanmHM7iEPfOYbJma5tpcSeD/SdzdQue2H3rnEEwkKY5f
 5CBfq6EBHIXGa1hwDesAfwd0KQrxSE47WfSQ43riRWhzbeaInWSTN8tFFqHa6YZ67yArRnJ2
 9FFPsCOxlNUV+iWSizW94EUBUoHIXgyGdb9rMk/XumHLwVOAmwtC/bNh7gmfuRNm6VTi/eN/
 XynXEJc4ETwiGeBKgiQbH1nLrT1Uv5XqXM9IDxpJVuy1T0+eou1948BeJYtO7oq7upuybhzV
 fZtU8GBBOlfDyjd8j8QKJrwtopvcDy1ig+UeSmoej4ye9hnXQOhxzP/VhHk+C9LCm+8stEz5
 uT6kAjaWpEEAQ9lCa46dc6S8r94hlBF8MoaYqcCCoA7lJnEmGSyFxHMsw==
IronPort-HdrOrdr: A9a23:tc1+4KPlWvlwrcBcTvWjsMiBIKoaSvp037Dk7SxMoHtuA66lfq
 +V8sjzuSWftN9zYgBCpTn/Asi9qBrnnPYf3WB7B9iftWfd1VdAVLsD0aLShxv9Bib56ulRkY
 1kc6R4FZnMKGISt7ee3OF9eOxQp+VuN8uT9IPj80s=
X-Talos-CUID: =?us-ascii?q?9a23=3A481b4mkEt6YZIYe4zVGTE9R3havXOS3nx2zXImi?=
 =?us-ascii?q?bM2doZu2+RGCU861hg8U7zg=3D=3D?=
X-Talos-MUID: =?us-ascii?q?9a23=3AVI0kXw7J5ByHvjePaYysSCCUxoxZwo/pGXss0qk?=
 =?us-ascii?q?qoseHOD15Yxm+iz24F9o=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.23,206,1770595200"; 
   d="scan'208";a="746037084"
Received: from rcdn-l-core-12.cisco.com ([173.37.255.149])
  by alln-iport-3.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 29 Apr 2026 13:15:25 +0000
Received: from sjc-ads-9313.cisco.com (sjc-ads-9313.cisco.com [10.30.212.77])
	by rcdn-l-core-12.cisco.com (Postfix) with ESMTP id D97ED180001CA;
	Wed, 29 Apr 2026 13:15:23 +0000 (GMT)
From: Darko Tominac <dtominac@cisco.com>
To: Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Adrian Hunter <adrian.hunter@intel.com>,
	James Clark <james.clark@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Cc: xe-linux-external@cisco.com,
	danielwa@cisco.com,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/madvise: preserve uprobe breakpoints across MADV_DONTNEED
Date: Wed, 29 Apr 2026 15:15:18 +0200
Message-Id: <20260429131522.4049054-1-dtominac@cisco.com>
X-Mailer: git-send-email 2.35.6
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: NONE;sjc-ads-9313.cisco.com [10.30.212.77]
X-Outbound-SMTP-Client: 10.30.212.77, sjc-ads-9313.cisco.com
X-Outbound-Node: rcdn-l-core-12.cisco.com
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: ECA861A0004
X-Stat-Signature: hmrmizhsorqfoetmqx7y5zisbdqyjzxt
X-HE-Tag: 1777468526-372021
X-HE-Meta: U2FsdGVkX1/cuJmJH+m6JMZUYh7y1wx/LH0Ri3sQDU7EQHAQzqTipDSAI64gDf07OwB/vZjR+z5/3iHu2mM5q1p0NwwiNsrIDDbfHBez6OyIt7YF+U9wqfS2CdKYLXSfe9yeOk76K5MHfLyh3ARIy866DUvtq0SgGeYFg8P5hgtjl6c29/QTF2sQpy9b8fP0127XG/sy6axI5CBSlt06hjwJ2CEpjL/YR9z2NzBuRV2RhEpAR5ejeEjfieHC5jP//6l8K5JX81xUaSR/s/r4HvygfjIGTBtG34fBtNyCqqzRnWuGGgwacjJL1mVI3mDJZo+IpxYXdjzg0kB3zaYqK1Z0U4E0fpeimD7jJ/tB93djOwR2ZuUJbl0WJILOBF1TA+bKSwI5zb3VBweh1zhIRkYDcNbCy5y6DOPXQqAcUaTZrwZiWAY4Ysf7VitZLKwvmiI7N6HeUJZlKA+hSCR/d0pdbf8ME5PQhUdq+MfLWnLyfdXrjfW8Cki1NN3QalL6saD3Lk9msbqzfE3WmLaS0uGT6N+nS2ubPcv0TW9C4N2c+w0YTtU9qL/boXjnO8UGutB4uvaBC+TQDgdY/T87Fixx1tsf7j7qHqrMqpByz9OWKBJbJmfnPOyUVBBEJjTylfi8+ITk5FHJ2cY3JhW1w75hwIAJWYjd1DtFz2gAqP1NY4+XT1jHPtjx6EV0A2WQ//SHBrtpOrrWRfu5YitqO9dqoNIJZTgJLMGFKaczWwScDvA+aVgUh9bxhDLYFsCrhy753vqWvxfqczFlqIBI47UsEArlyvfSDRDxNuaFOXwKGxwsCTY2ecCG60noT9br/qqmPc1JrB967iAaXt97836RgKtJ4w7mCvUZujpHwRco/U6JXzpx2DZc4+WHgKXcXv30yHntx1hf7A6ubfSu9g9ekS4YuV4trHXlxnEGx2iF9b4qwrl5N29Pm8H+KsBd75Xf95Ghh788RWzr49i
 ewgGLs9o
 PAET6ekG7CTgPvOjW2qt49UOEMI6RKEWpEpzzj+o8XTVhiwu0v5Rl0zuGri7/h4Tqd2uHO11knQOiTbkOvuMmIjERRtGPIYWQjzLVGKYA+ZUnr7XErcW6Z1SRf3PBwn1tVYxYC6MTBGaVVYWuUpg9am1gjTq4eQluSfFmUXOZogSyvDb6IazhHy0iVeyKMVCNyJ1FYX0ub6vv2fEkabJkRMn2qqV+wzIDaCje/uMpPb7MNcI0zm8P754A82G2EAJRq8K4kkjD5HGTbkTkdXrzWFmWc9g8MGnr/dCs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When uprobes are active, MADV_DONTNEED can discard file-backed pages
that contain uprobe software breakpoint instructions.  Because the
uprobe infrastructure does not re-instrument pages on individual page
faults (uprobe_mmap() is only called during VMA creation, not on
page-in), the breakpoints are silently lost once the discarded pages are
re-read from the backing file.  The probes stop firing with no error
indication, and the only recovery is to unregister and re-register the
affected uprobes.

Note that MADV_FREE is not affected: it only operates on anonymous VMAs
(madvise_free_single_vma() rejects non-anonymous VMAs with -EINVAL),
while uprobes only instrument file-backed mappings, so the two can never
overlap.

A concrete example is a userspace memory reclamation subsystem that
periodically calls madvise(MADV_DONTNEED) on file-backed text pages to
release memory.  This silently clears uprobe breakpoints placed by
eBPF-based security and tracing tools that use uprobes to attach eBPF
programs to user-space functions, causing those tools to stop
functioning within seconds of the first reclamation pass.

Add a check in madvise_dontneed_free(), which handles MADV_DONTNEED,
MADV_DONTNEED_LOCKED and MADV_FREE, that when CONFIG_UPROBES is enabled
detects whether the target range contains active uprobes:

  - Fast path: if no uprobes are registered system-wide, or the VMA is
    not file-backed (uprobes only instrument file-backed mappings, so
    anonymous VMAs -- including MADV_FREE targets -- can never contain
    breakpoints), or no uprobes are present in the VMA range, proceed
    with the discard as before.
  - Slow path: when uprobes are detected in the range, use
    vma_first_uprobe_addr() to jump directly to each uprobe page via
    the rbtree, zapping the clean ranges between them.  This is
    O(M * log N) where M is the number of uprobes in the range and
    N is the total uprobe count, rather than O(pages).  madvise()
    still returns success, consistent with the advisory nature of
    MADV_DONTNEED.

When CONFIG_UPROBES is not configured, the original behaviour is
preserved with no overhead.

To support the above, export vma_has_uprobes() and add new helpers
any_uprobes_registered() and vma_first_uprobe_addr() in the uprobes
subsystem.  vma_first_uprobe_addr() returns the page-aligned virtual
address of the lowest-offset uprobe in a given VMA range by leveraging
the (inode, offset)-sorted global rbtree.

Cc: xe-linux-external@cisco.com
Cc: danielwa@cisco.com
Signed-off-by: Darko Tominac <dtominac@cisco.com>
---
 include/linux/uprobes.h | 21 +++++++++++
 kernel/events/uprobes.c | 79 +++++++++++++++++++++++++++++++++++++++--
 mm/madvise.c            | 73 +++++++++++++++++++++++++++++++++----
 3 files changed, 164 insertions(+), 9 deletions(-)

diff --git a/include/linux/uprobes.h b/include/linux/uprobes.h
index f548fea2adec..9ce5c46fd2e9 100644
--- a/include/linux/uprobes.h
+++ b/include/linux/uprobes.h
@@ -212,6 +212,11 @@ extern void uprobe_unregister_nosync(struct uprobe *uprobe, struct uprobe_consum
 extern void uprobe_unregister_sync(void);
 extern int uprobe_mmap(struct vm_area_struct *vma);
 extern void uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end);
+extern bool vma_has_uprobes(struct vm_area_struct *vma, unsigned long start, unsigned long end);
+extern unsigned long vma_first_uprobe_addr(struct vm_area_struct *vma,
+					   unsigned long start,
+					   unsigned long end);
+extern bool any_uprobes_registered(void);
 extern void uprobe_start_dup_mmap(void);
 extern void uprobe_end_dup_mmap(void);
 extern void uprobe_dup_mmap(struct mm_struct *oldmm, struct mm_struct *newmm);
@@ -278,6 +283,22 @@ static inline void
 uprobe_munmap(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
 }
+static inline bool
+vma_has_uprobes(struct vm_area_struct *vma, unsigned long start,
+		unsigned long end)
+{
+	return false;
+}
+static inline unsigned long
+vma_first_uprobe_addr(struct vm_area_struct *vma, unsigned long start,
+		      unsigned long end)
+{
+	return 0;
+}
+static inline bool any_uprobes_registered(void)
+{
+	return false;
+}
 static inline void uprobe_start_dup_mmap(void)
 {
 }
diff --git a/kernel/events/uprobes.c b/kernel/events/uprobes.c
index 4084e926e284..0f8aea99b96f 100644
--- a/kernel/events/uprobes.c
+++ b/kernel/events/uprobes.c
@@ -152,6 +152,19 @@ static loff_t vaddr_to_offset(struct vm_area_struct *vma, unsigned long vaddr)
 	return ((loff_t)vma->vm_pgoff << PAGE_SHIFT) + (vaddr - vma->vm_start);
 }
 
+/**
+ * any_uprobes_registered - check if any uprobes are currently registered
+ *
+ * Check whether the global uprobe rbtree has any entries, indicating
+ * that at least one uprobe is currently active in the system.
+ *
+ * Return: true if one or more uprobes are registered, false otherwise.
+ */
+bool any_uprobes_registered(void)
+{
+	return !no_uprobe_events();
+}
+
 /**
  * is_swbp_insn - check if instruction is breakpoint instruction.
  * @insn: instruction to be checked.
@@ -1635,8 +1648,16 @@ int uprobe_mmap(struct vm_area_struct *vma)
 	return 0;
 }
 
-static bool
-vma_has_uprobes(struct vm_area_struct *vma, unsigned long start, unsigned long end)
+/**
+ * vma_has_uprobes - check whether a vma range contains any uprobes.
+ * @vma: the vma to search.
+ * @start: start address of the range (inclusive).
+ * @end: end address of the range (exclusive).
+ *
+ * Return: true if at least one uprobe is registered in [@start, @end),
+ * false otherwise.
+ */
+bool vma_has_uprobes(struct vm_area_struct *vma, unsigned long start, unsigned long end)
 {
 	loff_t min, max;
 	struct inode *inode;
@@ -1654,6 +1675,60 @@ vma_has_uprobes(struct vm_area_struct *vma, unsigned long start, unsigned long e
 	return !!n;
 }
 
+/**
+ * vma_first_uprobe_addr - find first uprobe in a vma range.
+ * @vma: the vma to search.
+ * @start: start address of the range (inclusive).
+ * @end: end address of the range (exclusive).
+ *
+ * Used by madvise to skip directly to uprobe pages.
+ *
+ * Return: the page-aligned virtual address of the first uprobe in
+ * [@start, @end), or 0 if none exists.
+ */
+unsigned long vma_first_uprobe_addr(struct vm_area_struct *vma,
+				    unsigned long start, unsigned long end)
+{
+	loff_t min, max, first_offset;
+	struct inode *inode;
+	struct rb_node *n, *t;
+	struct uprobe *u;
+
+	/* No uprobes possible on anonymous mappings */
+	if (!vma->vm_file)
+		return 0;
+
+	/* Empty range -- nothing to search */
+	if (start >= end)
+		return 0;
+
+	inode = file_inode(vma->vm_file);
+
+	min = vaddr_to_offset(vma, start);
+	max = min + (end - start) - 1;
+
+	read_lock(&uprobes_treelock);
+	n = find_node_in_range(inode, min, max);
+	if (!n) {
+		read_unlock(&uprobes_treelock);
+		return 0;
+	}
+
+	/* Walk left to find the lowest offset in range */
+	u = rb_entry(n, struct uprobe, rb_node);
+	first_offset = u->offset;
+	for (t = rb_prev(n); t; t = rb_prev(t)) {
+		u = rb_entry(t, struct uprobe, rb_node);
+		if (u->inode != inode || u->offset < min)
+			break;
+		first_offset = u->offset;
+	}
+	read_unlock(&uprobes_treelock);
+
+	/* Return page-aligned vaddr containing this uprobe */
+	return PAGE_ALIGN_DOWN(offset_to_vaddr(vma, first_offset));
+}
+
 /*
  * Called in context of a munmap of a vma.
  */
diff --git a/mm/madvise.c b/mm/madvise.c
index 69708e953cf5..c73f1131224b 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -32,6 +32,7 @@
 #include <linux/leafops.h>
 #include <linux/shmem_fs.h>
 #include <linux/mmu_notifier.h>
+#include <linux/uprobes.h>
 
 #include <asm/tlb.h>
 
@@ -862,6 +863,30 @@ static long madvise_dontneed_single_vma(struct madvise_behavior *madv_behavior)
 	return 0;
 }
 
+static long madvise_dontneed_free_range(struct madvise_behavior *madv_behavior,
+					unsigned long start, unsigned long end)
+{
+	struct madvise_behavior_range *range = &madv_behavior->range;
+	unsigned long saved_start = range->start;
+	unsigned long saved_end = range->end;
+	int behavior = madv_behavior->behavior;
+	long ret;
+
+	range->start = start;
+	range->end = end;
+
+	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)
+		ret = madvise_dontneed_single_vma(madv_behavior);
+	else if (behavior == MADV_FREE)
+		ret = madvise_free_single_vma(madv_behavior);
+	else
+		ret = -EINVAL;
+
+	range->start = saved_start;
+	range->end = saved_end;
+	return ret;
+}
+
 static
 bool madvise_dontneed_free_valid_vma(struct madvise_behavior *madv_behavior)
 {
@@ -898,7 +923,7 @@ static long madvise_dontneed_free(struct madvise_behavior *madv_behavior)
 {
 	struct mm_struct *mm = madv_behavior->mm;
 	struct madvise_behavior_range *range = &madv_behavior->range;
-	int behavior = madv_behavior->behavior;
+	unsigned long cur, end, uprobe_addr;
 
 	if (!madvise_dontneed_free_valid_vma(madv_behavior))
 		return -EINVAL;
@@ -947,12 +972,46 @@ static long madvise_dontneed_free(struct madvise_behavior *madv_behavior)
 		VM_WARN_ON(range->start > range->end);
 	}
 
-	if (behavior == MADV_DONTNEED || behavior == MADV_DONTNEED_LOCKED)
-		return madvise_dontneed_single_vma(madv_behavior);
-	else if (behavior == MADV_FREE)
-		return madvise_free_single_vma(madv_behavior);
-	else
-		return -EINVAL;
+	/*
+	 * Preserve uprobes: if any uprobes are active in this VMA range,
+	 * avoid discarding pages that contain active breakpoints.
+	 *
+	 * Fast path: if no uprobes are registered system-wide, or the VMA
+	 * is not file-backed (uprobes only instrument file-backed mappings,
+	 * so anonymous VMAs can never contain breakpoints), or no uprobes
+	 * are present in this VMA range, proceed with the full operation.
+	 */
+	if (likely(!any_uprobes_registered()) ||
+	    !madv_behavior->vma->vm_file ||
+	    !vma_has_uprobes(madv_behavior->vma, range->start, range->end))
+		return madvise_dontneed_free_range(madv_behavior,
+						   range->start, range->end);
+
+	/*
+	 * Slow path: jump from uprobe to uprobe via rbtree lookup, zapping
+	 * the clean range before each uprobe page. This is O(M * log N)
+	 * where M is the number of uprobes in the range and N is the total
+	 * uprobe count, versus O(pages) for a page-by-page scan. 'cur'
+	 * tracks the beginning of the current clean range.
+	 */
+	cur = range->start;
+	end = range->end;
+	while (cur < end) {
+		uprobe_addr = vma_first_uprobe_addr(madv_behavior->vma,
+						    cur, end);
+		if (!uprobe_addr) {
+			/* No more uprobes - zap the rest */
+			madvise_dontneed_free_range(madv_behavior, cur, end);
+			break;
+		}
+		/* Zap the clean range before the uprobe page */
+		if (cur < uprobe_addr)
+			madvise_dontneed_free_range(madv_behavior, cur,
+						    uprobe_addr);
+		/* Skip past the uprobe page */
+		cur = uprobe_addr + PAGE_SIZE;
+	}
+	return 0;
 }
 
 static long madvise_populate(struct madvise_behavior *madv_behavior)
-- 
2.35.6


