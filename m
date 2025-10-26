Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09F08CCF9E5
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:02:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6804A8E0163; Sun, 26 Oct 2025 06:02:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 630EF8E0150; Sun, 26 Oct 2025 06:02:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AB0A8E0163; Sun, 26 Oct 2025 06:02:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2BA9F8E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:02:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E6BEC129C9C
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:48 +0000 (UTC)
X-FDA: 84039826416.01.A7CCC86
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id E3E00C0009
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:46 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FzuP3MBO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761472967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PF80wY+6f9zS/8Mmu7EkeRXBI6Ih5rRYihiNKAuvyqs=;
	b=zznqbVwX5oSkTdLTgIuRoIyUOM2/Hz+QetsOEF5AtNWhuVhiuiJqU8dZfdTO/YELy73u80
	4rN22CIVcqaoBDSyt7zYO9OhJmQGB2lLbrLgG8KJPmZ2Qk3tsDfZvEukg2CSO5/J4ZzXhp
	4ylxuNs1xFYTLDfNY5IHtdrCVAzckHI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FzuP3MBO;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761472967; a=rsa-sha256;
	cv=none;
	b=rv4mD3D4ga6MH+ZaFLEBY0/T7SyUKDQxkzHho7LHzgvnM2Zyv58e0USfliFDFSV6zpC5Ls
	dO1ERXF6g0CH9T3CMo2C2q2mRlYp3UQb/lcK6tf4JPmPGDiIgKgnpBwmY3zTusmn3bz4Q6
	9ALvRPVu0ln5ATSRejCeZDZd3BwEa7I=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-781997d195aso2561320b3a.3
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:02:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761472966; x=1762077766; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PF80wY+6f9zS/8Mmu7EkeRXBI6Ih5rRYihiNKAuvyqs=;
        b=FzuP3MBO7LVhedII+NlyWMorE2qeygY5Oet8V26O5/nuEU3AHiEUPI3s5dO+vPOSyV
         1/wgAmTt9Vp8egIRLYpgTtVffp2Pdt1XutZ7PQP1UfecS79n1e4QzaA7W8ytVpkCAPTV
         LeHjf8slTQ1tpUZKGhafn4TOThuPIyc+qsWBNWlqzpZrmqq//Z1yHATkYJJNoNzxQNxg
         9OusDqLaE0MdS1vuWU0xYAMjvOvqoCG8N8q3MiOjJtpwj+nGl7IL6dW7CL4UIWr+CMgi
         jzkR15BiEpTuxbpSaAe9jw5A03suJwh8I/DL36CAlyf9yl0774JoDneMYxqQHELGhpXf
         P6dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761472966; x=1762077766;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PF80wY+6f9zS/8Mmu7EkeRXBI6Ih5rRYihiNKAuvyqs=;
        b=s1f75+xk5jf/2BobSXBavFyur5vrnb0H1JdWrm/xIIPyb/5pLlojty1WccxG1p74as
         br9ZBy+TtCFQ83dXc3RiUhZEm+x2N83ZlpTIiVqX8z/tHop5+Q16vZ4JjkTfmqfotk2d
         QaPGpuy6HHGiMAVZzXue4QdGtuVJuU7dcyEfsL9GSuOvhss9/5jq735UUl1gaBwcgy0U
         p05uAjistmPUYz0TEmzwYwd9h/qBbbvk+ePpjqLtxH1cUiY60RL4J9fF57uB6mBnNpAb
         hxJHG88oPchHyqH0tLMgX1fEWLe1/4Ke/S9/d8TQXFRbqRoCAaPJm5WC4+NT/TofWqPX
         nOJg==
X-Forwarded-Encrypted: i=1; AJvYcCUWTG1EcZyLcD9mi6Us9Nr3Hw8xFFPryUS0Qy8a+xQpFaQyG5mo+CzcaiiHAFteRwI+oTO2THmtcQ==@kvack.org
X-Gm-Message-State: AOJu0YyBYQywuqm35lcDZ2ulCRTivD3o5Rb44yj1gorOvTJjrvFFmDEU
	h2NG4OKdcR455wpLNxyDitgpH5+Aq4fiVen5/17o7xD0CGRrwfBMUdUj
X-Gm-Gg: ASbGncuRirZa5lHPtUUWhFe6eAqPuP5nARkqX/s+nByMoRDThIrA+vRyWCCTng/vLaG
	zAZI/Ba6wiqsP7W7BTbmyABWlNqJ/L5bcZfdb4+AsnXlDI194JARJb8g7WpkZd0c3oEJCFnmCXa
	cXc0V8znc1WFowFMDO0a8hwfAl5VMX5ZAa9vhQQOWB3gQ/3CFZ+x0r01qEmX/lHQP755QkrFOYw
	v+Vw7WiFQJYIXn3oJMKWT7oU/s0ARpOIDsuj6Ls40jjHrZ0QHjwQyoMcj/QmzF4l4LHhGl19ffH
	EQE5hLAmRX70X8u8/PMLreOJo23qd8C/9HeJXWJK8l69ykmMNWw/HMpVed3Zug1mNW0axlcVWTF
	mUjWB8JwixH/pzT9euucyRAwlM59Wv4AdnngOFJXNQlHHU3ysAJZjobftsIjJII/zMTayWTIcbe
	/SSL6WiMLve9gMLt9vqRrJE9YdC0iXwGPr4G4=
X-Google-Smtp-Source: AGHT+IGp0Rjlq2zrhnxyc3J/CBOgBztHysuuoAmJfBv0zmIFKSuQwVknuGe3ZmxLHKU/iFYQ0vyqNQ==
X-Received: by 2002:a05:6a21:32a8:b0:33d:7c76:5d68 with SMTP id adf61e73a8af0-33deb36e3e0mr10084650637.46.1761472965257;
        Sun, 26 Oct 2025 03:02:45 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.02.36
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:02:44 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v12 mm-new 03/10] mm: thp: add support for BPF based THP order selection
Date: Sun, 26 Oct 2025 18:01:52 +0800
Message-Id: <20251026100159.6103-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251026100159.6103-1-laoar.shao@gmail.com>
References: <20251026100159.6103-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E3E00C0009
X-Rspamd-Server: rspam03
X-Stat-Signature: a7am3h3qmt1n1obb76idqkd1frx9bxas
X-HE-Tag: 1761472966-129292
X-HE-Meta: U2FsdGVkX19bOy95uBdS3JJYqmYDc67fIN/Z+Wyv65d5EfQ//4vEa18qLgI7snRfHdte0NpmcrJyU7Vb9W1AgNTshYQHpVM0+9RHpO4UTGbekb9ZvtJ1Nf5FlzautLM6BGx1C1E6+HjZxLAFVrhoGKYMnAaahW9n0BdM8sw4pLISTMI5EKWg2Fk5MD1VWQTMEbcjndDzXV2JW4o00Fuls2x4dli+V8s6uix15tTpDsLU+SXecnI+SFl132PkyNrtallVHvLXOejce0exzx2zQCrUinrdyqfPFBsstQ9+BPdtpxL5+WaNsi+2dprMfkWAgJUwPG2B3hnw2nuXw/Cd76yWRbhXyv2MEceuo1woJ4/7zielz5hk/TeU44+IeMdbV9RYlCysDM47sdEgPS1QvwFuKMzWgB/DUJOYgLSE5iC5u9WsZYKPD7i5Qdo6X52MU8h/uOW2qTC2SeDaF7++bQZg38d/dbGVlbmnP6HarTxXppdICJMH7cPmICg4cZ/y7GVo8qsvDzw9gbwrrxH/i9WHlXRrxUEDUq7QWA2uxJ242yU1/R1jIijNw02rm9casSX0VdKd4Ba/bSVbMbW2srD/Z0vr2U2p9NdnZjxxCuDYx4HTooY9DXoyEhVvi44euGW7RxyT1AoQAJNhWFHKv85UeY6bHAXOPF2hpN9Z31eJTnFe9xfGDNhFnc+eUvCL0iiqrSkbGkiBaURp/MEkFqiybLqnVw0mAVvD6CMZ9AMrAt2zKp3gAPp8c7SRjV6TUkQPrdyKoO8hxhbmbem9t+Dx+RE8eJjgrax8Gd947dHDP2OfCenRt6i10kGl9A82yWrfw5Y/DNzDHv/gbVsK+q2eMzku9qFbeGSq55CJSPg9vnXjT2XoCUMpy/mEpPC+DJEZ0nPQI4yedfoVSmxg0O74TknIkYfFeX9TmkwSMtVr4Z5sfkp9LAutG1y905qBATMtgJr0F0RgskPhVnX
 Q9mIXXQ2
 t9pGTb142WBVjUGTMW0vJkoK/23+SLyMRoXFm3/Qy2qEyAQqepLydiNsA5yMBbmcVZi7D+dF34GvL6KOkNPlWwWYUa04EBS/pLK8YUFypW6mNA1dq3D5oGg+BLJ5wIoI8PCVQGrr2jX59sKw1bG4YbgPMKveST5u+K7dEszdSDzTWzKCD0uxpbj1ZFz5amZi+j7bnBvL2mD4O99efOickEe1+bunVyY+jBc1wNg7m6SSrCwhBFiV1UNaGR1NrcSxNUkMVzmASUDXRZVYriLS3tHk4fEKvLYgVmeqdVlzJkYAHvBHhqZWynz+2e35fgtWf0f2/FIbLFJivZHcsrxAefBq2DzIDRDsHwRFzZ1sJdOzPRkvRQmIYY0xGyq5zZ4bu4lZKCAnjMf7ueSfTselfTXfHYOmN2+Vx9alsXB+bPdZBaGqIAqVG2h9V+JAhg6DsmxiHvOx9CKq2dAvUsZ4HWYUDt0ltDEn6DXxEDvSuugSkzlkW03nLbPTbeQABBi4piYXbq4hbp1cYEz6C5GS0F2XASqGZRITwr/8BxHeOkeB6tHbNDf81fFgQsVa2NT+nn9qh6voLXaw1YAl37KiUYzT/1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Motivation
==============

This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
programs to influence THP order selection based on factors such as:
- Workload identity
  For example, workloads running in specific containers or cgroups.
- Allocation context
  Whether the allocation occurs during a page fault, khugepaged, swap or
  other paths.
- VMA's memory advice settings
  MADV_HUGEPAGE or MADV_NOHUGEPAGE
- Memory pressure
  PSI system data or associated cgroup PSI metrics

The BPF-THP Interface
=====================

The kernel API of this new BPF hook is as follows,

/**
 * thp_get_order: Get the suggested THP order from a BPF program for allocation
 * @vma: vm_area_struct associated with the THP allocation
 * @type: TVA type for current @vma
 * @orders: Bitmask of available THP orders for this allocation
 *
 * Return: The suggested THP order for allocation from the BPF program.
 *         Returns a negative value to preserve the original available @orders,
 *         which is useful in specific cases—for example, when only a particular
 *         @type is handled and others are ignored.
 */
int thp_get_order(struct vm_area_struct *vma,
		  enum tva_type type,
		  unsigned long orders);

This functionality is only active when system-wide THP is configured to
madvise or always mode. It remains disabled in never mode. Additionally,
if THP is explicitly disabled for a specific task via prctl(), this BPF
functionality will also be unavailable for that task.

The Design of Per Process BPF-THP
=================================

As suggested by Alexei, we need to scoping the BPF-THP [0].

Scoping BPF-THP to cgroup is not acceptible
-------------------------------------------

As explained by Gutierrez: [1]

1. It breaks the cgroup hierarchy when 2 siblings have different THP policies
2. Cgroup was designed for resource management not for grouping processes and
   une those processes
3. We set a precedent for other people adding new flags to cgroup and
   potentially polluting cgroups. We may end up with cgroups having tens of
   different flags, making sysadmin's job more complex

Scoping BPF-THP to process
--------------------------

To eliminate potential conflicts among competing BPF-THP instances, we
enforce that each process is exclusively managed by a single BPF-THP. This
approach has received agreement from David [2].

When registering a BPF-THP, we specify the PID of a target task. The
BPF-THP is then installed in the task's `mm_struct`

  struct mm_struct {
      struct bpf_thp_ops __rcu *thp_thp;
  };

Inheritance Behavior:

- Existing child processes are unaffected
- Newly forked children inherit the BPF-THP from their parent
- The BPF-THP persists across execve() calls

A new linked list tracks all tasks managed by each BPF-THP instance:

- Newly managed tasks are added to the list
- Exiting tasks are automatically removed from the list
- During BPF-THP unregistration (e.g., when the BPF link is removed), all
  managed tasks have their bpf_thp pointer set to NULL
- BPF-THP instances can be dynamically updated, with all tracked tasks
  automatically migrating to the new version.

This design simplifies BPF-THP management in production environments by
providing clear lifecycle management and preventing conflicts between
multiple BPF-THP instances.

WARNING
=======

This feature requires CONFIG_BPF_THP (EXPERIMENTAL) to be enabled. Note
that this capability is currently unstable and may undergo significant
changes—including potential removal—in future kernel versions.

Link: https://lore.kernel.org/linux-mm/CAADnVQJtrJZOCWZKH498GBA8M0mYVztApk54mOEejs8Wr3nSiw@mail.gmail.com/ [0]
Link: https://lore.kernel.org/linux-mm/1940d681-94a6-48fb-b889-cd8f0b91b330@huawei-partners.com/ [1]
Link: https://lore.kernel.org/linux-mm/3577f7fd-429a-49c5-973b-38174a67be15@redhat.com/ [2]
Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
---
 MAINTAINERS              |   1 +
 fs/exec.c                |   1 +
 include/linux/huge_mm.h  |  39 +++++
 include/linux/mm_types.h |  17 +++
 kernel/fork.c            |   1 +
 mm/Kconfig               |  22 +++
 mm/Makefile              |   1 +
 mm/huge_memory_bpf.c     | 316 +++++++++++++++++++++++++++++++++++++++
 mm/mmap.c                |   1 +
 9 files changed, 399 insertions(+)
 create mode 100644 mm/huge_memory_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index c1a1732df7b1..e8eeb7c89431 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16521,6 +16521,7 @@ F:	include/linux/huge_mm.h
 F:	include/linux/khugepaged.h
 F:	include/trace/events/huge_memory.h
 F:	mm/huge_memory.c
+F:	mm/huge_memory_bpf.c
 F:	mm/khugepaged.c
 F:	mm/mm_slot.h
 F:	tools/testing/selftests/mm/khugepaged.c
diff --git a/fs/exec.c b/fs/exec.c
index 6b70c6726d31..41d7703368e9 100644
--- a/fs/exec.c
+++ b/fs/exec.c
@@ -890,6 +890,7 @@ static int exec_mmap(struct mm_struct *mm)
 	activate_mm(active_mm, mm);
 	if (IS_ENABLED(CONFIG_ARCH_WANT_IRQS_OFF_ACTIVATE_MM))
 		local_irq_enable();
+	bpf_thp_retain_mm(mm, old_mm);
 	lru_gen_add_mm(mm);
 	task_unlock(tsk);
 	lru_gen_use_mm(mm);
diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index f73c72d58620..49050455f793 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -274,6 +274,40 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 enum tva_type type,
 					 unsigned long orders);
 
+#ifdef CONFIG_BPF_THP
+
+unsigned long
+bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
+			unsigned long orders);
+void bpf_thp_exit_mm(struct mm_struct *mm);
+void bpf_thp_retain_mm(struct mm_struct *mm, struct mm_struct *old_mm);
+void bpf_thp_fork(struct mm_struct *mm, struct mm_struct *old_mm);
+
+#else
+
+static inline unsigned long
+bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
+			unsigned long orders)
+{
+	return orders;
+}
+
+static inline void bpf_thp_exit_mm(struct mm_struct *mm)
+{
+}
+
+static inline void
+bpf_thp_retain_mm(struct mm_struct *mm, struct mm_struct *old_mm)
+{
+}
+
+static inline void
+bpf_thp_fork(struct mm_struct *mm, struct mm_struct *old_mm)
+{
+}
+
+#endif
+
 /**
  * thp_vma_allowable_orders - determine hugepage orders that are allowed for vma
  * @vma:  the vm area to check
@@ -295,6 +329,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
 {
 	vm_flags_t vm_flags = vma->vm_flags;
 
+	/* The BPF-specified order overrides which order is selected. */
+	orders &= bpf_hook_thp_get_orders(vma, type, orders);
+	if (!orders)
+		return 0;
+
 	/*
 	 * Optimization to check if required orders are enabled early. Only
 	 * forced collapse ignores sysfs configs.
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 5021047485a9..e0c89ca9f6f7 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -983,6 +983,19 @@ struct mm_cid {
 };
 #endif
 
+#ifdef CONFIG_BPF_THP
+struct bpf_thp_ops;
+#endif
+
+#ifdef CONFIG_BPF_MM
+struct bpf_mm_ops {
+#ifdef CONFIG_BPF_THP
+	struct bpf_thp_ops __rcu *bpf_thp;
+	struct list_head bpf_thp_list;
+#endif
+};
+#endif
+
 /*
  * Opaque type representing current mm_struct flag state. Must be accessed via
  * mm_flags_xxx() helper functions.
@@ -1280,6 +1293,10 @@ struct mm_struct {
 #ifdef CONFIG_MM_ID
 		mm_id_t mm_id;
 #endif /* CONFIG_MM_ID */
+
+#ifdef CONFIG_BPF_MM
+		struct bpf_mm_ops bpf_mm;
+#endif
 	} __randomize_layout;
 
 	/*
diff --git a/kernel/fork.c b/kernel/fork.c
index 3da0f08615a9..dc24f3d012df 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1130,6 +1130,7 @@ static inline void __mmput(struct mm_struct *mm)
 	exit_aio(mm);
 	ksm_exit(mm);
 	khugepaged_exit(mm); /* must run before exit_mmap */
+	bpf_thp_exit_mm(mm);
 	exit_mmap(mm);
 	mm_put_huge_zero_folio(mm);
 	set_mm_exe_file(mm, NULL);
diff --git a/mm/Kconfig b/mm/Kconfig
index a5a90b169435..12a2fbdc0909 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1457,6 +1457,28 @@ config PT_RECLAIM
 config FIND_NORMAL_PAGE
 	def_bool n
 
+menuconfig BPF_MM
+	bool "BPF-based Memory Management (EXPERIMENTAL)"
+	depends on BPF_SYSCALL
+
+	help
+	  Enable BPF-based Memory Management Policy. This feature is currently
+	  experimental.
+
+	  WARNING: This feature is unstable and may change in future kernel
+
+if BPF_MM
+config BPF_THP
+	bool "BPF-based THP Policy (EXPERIMENTAL)"
+	depends on TRANSPARENT_HUGEPAGE && BPF_MM
+
+	help
+	  Enable dynamic THP policy adjustment using BPF programs. This feature
+	  is currently experimental.
+
+	  WARNING: This feature is unstable and may change in future kernel
+endif # BPF_MM
+
 source "mm/damon/Kconfig"
 
 endmenu
diff --git a/mm/Makefile b/mm/Makefile
index 21abb3353550..4efca1c8a919 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
 obj-$(CONFIG_NUMA) += memory-tiers.o
 obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
 obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
+obj-$(CONFIG_BPF_THP) += huge_memory_bpf.o
 obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
 obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
 obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
new file mode 100644
index 000000000000..f69c5851ea61
--- /dev/null
+++ b/mm/huge_memory_bpf.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * BPF-based THP policy management
+ *
+ * Author: Yafang Shao <laoar.shao@gmail.com>
+ */
+
+#include <linux/bpf.h>
+#include <linux/btf.h>
+#include <linux/huge_mm.h>
+#include <linux/khugepaged.h>
+
+/**
+ * @thp_order_fn_t: Get the suggested THP order from a BPF program for allocation
+ * @vma: vm_area_struct associated with the THP allocation
+ * @type: TVA type for current @vma
+ * @orders: Bitmask of available THP orders for this allocation
+ *
+ * Return: The suggested THP order for allocation from the BPF program.
+ *         Returns a negative value to preserve the original available @orders,
+ *         which is useful in specific cases—for example, when only a particular
+ *         @type is handled and others are ignored.
+ */
+typedef int thp_order_fn_t(struct vm_area_struct *vma,
+			   enum tva_type type,
+			   unsigned long orders);
+
+struct bpf_thp_ops {
+	pid_t pid; /* The pid to attach */
+	thp_order_fn_t *thp_get_order;
+
+	/* private */
+	/* The list of mm_struct objects managed by this BPF-THP instance. */
+	struct list_head mm_list;
+};
+
+static DEFINE_SPINLOCK(thp_ops_lock);
+
+unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
+				      enum tva_type type,
+				      unsigned long orders)
+{
+	struct mm_struct *mm = vma->vm_mm;
+	struct bpf_thp_ops *bpf_thp;
+	int bpf_order;
+
+	if (!mm)
+		return orders;
+
+	rcu_read_lock();
+	bpf_thp = rcu_dereference(mm->bpf_mm.bpf_thp);
+	if (!bpf_thp || !bpf_thp->thp_get_order)
+		goto out;
+
+	bpf_order = bpf_thp->thp_get_order(vma, type, orders);
+	if (bpf_order < 0)
+		goto out;
+	orders &= BIT(bpf_order);
+
+out:
+	rcu_read_unlock();
+	return orders;
+}
+
+void bpf_thp_exit_mm(struct mm_struct *mm)
+{
+	if (!rcu_access_pointer(mm->bpf_mm.bpf_thp))
+		return;
+
+	spin_lock(&thp_ops_lock);
+	if (!rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
+		spin_unlock(&thp_ops_lock);
+		return;
+	}
+	list_del(&mm->bpf_mm.bpf_thp_list);
+	RCU_INIT_POINTER(mm->bpf_mm.bpf_thp, NULL);
+	spin_unlock(&thp_ops_lock);
+
+}
+
+void bpf_thp_retain_mm(struct mm_struct *mm, struct mm_struct *old_mm)
+{
+	struct bpf_thp_ops *bpf_thp;
+
+	if (!old_mm || !rcu_access_pointer(old_mm->bpf_mm.bpf_thp))
+		return;
+
+	spin_lock(&thp_ops_lock);
+	bpf_thp = rcu_dereference_protected(old_mm->bpf_mm.bpf_thp,
+					    lockdep_is_held(&thp_ops_lock));
+	if (!bpf_thp) {
+		spin_unlock(&thp_ops_lock);
+		return;
+	}
+
+	/* The new mm_struct is under initialization. */
+	RCU_INIT_POINTER(mm->bpf_mm.bpf_thp, bpf_thp);
+
+	/* The old mm_struct is being destroyed. */
+	RCU_INIT_POINTER(old_mm->bpf_mm.bpf_thp, NULL);
+	list_replace(&old_mm->bpf_mm.bpf_thp_list, &mm->bpf_mm.bpf_thp_list);
+	spin_unlock(&thp_ops_lock);
+}
+
+void bpf_thp_fork(struct mm_struct *mm, struct mm_struct *old_mm)
+{
+	struct bpf_thp_ops *bpf_thp;
+
+	if (!rcu_access_pointer(old_mm->bpf_mm.bpf_thp))
+		return;
+
+	spin_lock(&thp_ops_lock);
+	bpf_thp = rcu_dereference_protected(old_mm->bpf_mm.bpf_thp,
+					    lockdep_is_held(&thp_ops_lock));
+	if (!bpf_thp) {
+		spin_unlock(&thp_ops_lock);
+		return;
+	}
+
+	/* The new mm_struct is under initialization. */
+	RCU_INIT_POINTER(mm->bpf_mm.bpf_thp, bpf_thp);
+
+	list_add_tail(&mm->bpf_mm.bpf_thp_list, &bpf_thp->mm_list);
+	spin_unlock(&thp_ops_lock);
+}
+
+static bool bpf_thp_ops_is_valid_access(int off, int size,
+					enum bpf_access_type type,
+					const struct bpf_prog *prog,
+					struct bpf_insn_access_aux *info)
+{
+	return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
+}
+
+static const struct bpf_func_proto *
+bpf_thp_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
+{
+	return bpf_base_func_proto(func_id, prog);
+}
+
+static const struct bpf_verifier_ops thp_bpf_verifier_ops = {
+	.get_func_proto = bpf_thp_get_func_proto,
+	.is_valid_access = bpf_thp_ops_is_valid_access,
+};
+
+static int bpf_thp_init(struct btf *btf)
+{
+	return 0;
+}
+
+static int bpf_thp_check_member(const struct btf_type *t,
+				const struct btf_member *member,
+				const struct bpf_prog *prog)
+{
+	/* The call site operates under RCU protection. */
+	if (prog->sleepable)
+		return -EINVAL;
+	return 0;
+}
+
+static int bpf_thp_init_member(const struct btf_type *t,
+			       const struct btf_member *member,
+			       void *kdata, const void *udata)
+{
+	const struct bpf_thp_ops *ubpf_thp;
+	struct bpf_thp_ops *kbpf_thp;
+	u32 moff;
+
+	ubpf_thp = (const struct bpf_thp_ops *)udata;
+	kbpf_thp = (struct bpf_thp_ops *)kdata;
+
+	moff = __btf_member_bit_offset(t, member) / 8;
+	switch (moff) {
+	case offsetof(struct bpf_thp_ops, pid):
+		/* bpf_struct_ops only handles func ptrs and zero-ed members.
+		 * Return 1 to bypass the default handler.
+		 */
+		kbpf_thp->pid = ubpf_thp->pid;
+		return 1;
+	}
+	return 0;
+}
+
+static int bpf_thp_reg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *bpf_thp = kdata;
+	struct list_head *mm_list;
+	struct task_struct *p;
+	struct mm_struct *mm;
+	int err = 0;
+	pid_t pid;
+
+	pid = bpf_thp->pid;
+	p = find_get_task_by_vpid(pid);
+	if (!p)
+		return -ESRCH;
+
+	if (p->flags & PF_EXITING) {
+		put_task_struct(p);
+		return -ESRCH;
+	}
+
+	mm = get_task_mm(p);
+	put_task_struct(p);
+	if (!mm)
+		return -EINVAL;
+
+	/* To prevent conflicts, use this lock when multiple BPF-THP instances
+	 * might register this task simultaneously.
+	 */
+	spin_lock(&thp_ops_lock);
+	/* Each process is exclusively managed by a single BPF-THP. */
+	if (rcu_access_pointer(mm->bpf_mm.bpf_thp)) {
+		err = -EBUSY;
+		goto out;
+	}
+	rcu_assign_pointer(mm->bpf_mm.bpf_thp, bpf_thp);
+
+	mm_list = &bpf_thp->mm_list;
+	INIT_LIST_HEAD(mm_list);
+	list_add_tail(&mm->bpf_mm.bpf_thp_list, mm_list);
+
+out:
+	spin_unlock(&thp_ops_lock);
+	mmput(mm);
+	return err;
+}
+
+static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *bpf_thp = kdata;
+	struct bpf_mm_ops *bpf_mm;
+	struct list_head *pos, *n;
+
+	spin_lock(&thp_ops_lock);
+	list_for_each_safe(pos, n, &bpf_thp->mm_list) {
+		bpf_mm = list_entry(pos, struct bpf_mm_ops, bpf_thp_list);
+		WARN_ON_ONCE(!bpf_mm);
+		rcu_replace_pointer(bpf_mm->bpf_thp, NULL, lockdep_is_held(&thp_ops_lock));
+		list_del(pos);
+	}
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+}
+
+static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
+{
+	struct bpf_thp_ops *old_bpf_thp = old_kdata;
+	struct bpf_thp_ops *bpf_thp = kdata;
+	struct bpf_mm_ops *bpf_mm;
+	struct list_head *pos, *n;
+
+	INIT_LIST_HEAD(&bpf_thp->mm_list);
+
+	/* Could be optimized to a per-instance lock if this lock becomes a bottleneck. */
+	spin_lock(&thp_ops_lock);
+	list_for_each_safe(pos, n, &old_bpf_thp->mm_list) {
+		bpf_mm = list_entry(pos, struct bpf_mm_ops, bpf_thp_list);
+		WARN_ON_ONCE(!bpf_mm);
+		rcu_replace_pointer(bpf_mm->bpf_thp, bpf_thp, lockdep_is_held(&thp_ops_lock));
+		list_del(pos);
+		list_add_tail(&bpf_mm->bpf_thp_list, &bpf_thp->mm_list);
+	}
+	spin_unlock(&thp_ops_lock);
+
+	synchronize_rcu();
+	return 0;
+}
+
+static int bpf_thp_validate(void *kdata)
+{
+	struct bpf_thp_ops *ops = kdata;
+
+	if (!ops->thp_get_order) {
+		pr_err("bpf_thp: required ops isn't implemented\n");
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int bpf_thp_get_order(struct vm_area_struct *vma,
+			     enum tva_type type,
+			     unsigned long orders)
+{
+	return -1;
+}
+
+static struct bpf_thp_ops __bpf_thp_ops = {
+	.thp_get_order = (thp_order_fn_t *)bpf_thp_get_order,
+};
+
+static struct bpf_struct_ops bpf_bpf_thp_ops = {
+	.verifier_ops = &thp_bpf_verifier_ops,
+	.init = bpf_thp_init,
+	.check_member = bpf_thp_check_member,
+	.init_member = bpf_thp_init_member,
+	.reg = bpf_thp_reg,
+	.unreg = bpf_thp_unreg,
+	.update = bpf_thp_update,
+	.validate = bpf_thp_validate,
+	.cfi_stubs = &__bpf_thp_ops,
+	.owner = THIS_MODULE,
+	.name = "bpf_thp_ops",
+};
+
+static int __init bpf_thp_ops_init(void)
+{
+	int err;
+
+	err = register_bpf_struct_ops(&bpf_bpf_thp_ops, bpf_thp_ops);
+	if (err)
+		pr_err("bpf_thp: Failed to register struct_ops (%d)\n", err);
+	return err;
+}
+late_initcall(bpf_thp_ops_init);
diff --git a/mm/mmap.c b/mm/mmap.c
index 644f02071a41..cf811e6678e3 100644
--- a/mm/mmap.c
+++ b/mm/mmap.c
@@ -1841,6 +1841,7 @@ __latent_entropy int dup_mmap(struct mm_struct *mm, struct mm_struct *oldmm)
 	vma_iter_free(&vmi);
 	if (!retval) {
 		mt_set_in_rcu(vmi.mas.tree);
+		bpf_thp_fork(mm, oldmm);
 		ksm_fork(mm, oldmm);
 		khugepaged_fork(mm, oldmm);
 	} else {
-- 
2.47.3


