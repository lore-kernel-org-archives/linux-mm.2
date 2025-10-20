Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE837CCD184
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 03:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12C968E0007; Sun, 19 Oct 2025 23:11:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DDF28E0002; Sun, 19 Oct 2025 23:11:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0E2C8E0007; Sun, 19 Oct 2025 23:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DEA368E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 23:11:52 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73A0111AB6C
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:52 +0000 (UTC)
X-FDA: 84017018064.24.F9FCFC9
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6F50614000D
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 03:11:50 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jSUe9nq6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760929910; a=rsa-sha256;
	cv=none;
	b=zV+wg8PuCmhO9e1hqxdAfbXrno9Stdl8KxMAybzEngiv8vHBRby8A3N3eEuUkfQ8iLVWUz
	VSI9Jeutvc81+LmTFAJhOT3aRjUD3I6nr3f8L3hg34tDCx/iJ9jAnB28MNk90ksJUYlLG9
	0vJ+Lsz/5DTd12FgCkjzEe2kchbGEBI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=jSUe9nq6;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760929910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7dIpGA9N07lxe3UFmdRp50JaLK0u62tv/Sc6f4SiuI=;
	b=XEyM8zZxe77mDY3Ff4wL9SYjrrM3X/AwGIqP2DJBq1dH4Eu9e1ARYc3/LKP6RVJrtc86od
	k42AD2VdotP9mXka1REnLGHKh+2bqcNwRgFCHh5zGaNkvET2ms4RXugByjtjEilkAjP+MX
	gGLmSU3JCByJXnWLP4DYSbHsgqFysBY=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-290dc630a07so17478565ad.1
        for <linux-mm@kvack.org>; Sun, 19 Oct 2025 20:11:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760929909; x=1761534709; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N7dIpGA9N07lxe3UFmdRp50JaLK0u62tv/Sc6f4SiuI=;
        b=jSUe9nq6LMZyeBzFxx9JkED+osTlSNfb58nkmO1XqL94CMHYV1fMoE/+O8FAldduo4
         SvXY+ZrIOHCB1l02Zx7Tk8tj/c5U7WBfJvwDfl7kvv7QftTJ83SfphgzQgq3xgBS4sP3
         NLtkFtdpS87lFB1AffFXYflMugqtWOMkZr74R9PMqeQFxIZMv9lvME8hrKZr2mlGMozE
         +tUo1gvB1urAGEsGcWfiaoVRTTHQsRLyQPmq26idSgdsCKTlUraZcu027UAqLPrcHWJt
         YmaYI0gTqe1Ri+jiijZleSBvrN+IHdH+zGmCIB2+vJXv6pSr4/8Kju3UuDFdR6UCVyU5
         RgDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760929909; x=1761534709;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N7dIpGA9N07lxe3UFmdRp50JaLK0u62tv/Sc6f4SiuI=;
        b=ZMd1EQkUWN5uRTpbLTysXYkOlwMdvzW2QnUF5pnTf2+b457r2cYQH5yyQgNpx0HenU
         Kz7trF0teIEl8cQPRkbyDtmeR+zA8bYTvCKG2Q0KL8twNYuGJMvbnVOaws5UKb10dxRx
         lJGwFP7Lwl6mrdU+2QGB/pYeECiJPD2NQVEDq3zWAuaiaPoAYDcV6XGixi+9KFk7S03b
         +PY1W2RvmnwDRVwD0Kf+DpAYSqo2wHWkk6/58YcWX2MlCRtkWI6g22cNIkQuOwiHOE6p
         Rs/WBiTxKycXTVaUKizQGjBsrLI6spFh8wEAIKkWvFUziorJpK0m/kREumyp/44DiT9e
         9wWA==
X-Forwarded-Encrypted: i=1; AJvYcCXAKFwTdk+/NxxFghsL3soRL9ODZJ8y2mXknhnJA+7Zt1QV34SCdo3Pz3z4R8yhYisFUX/tn3F2ng==@kvack.org
X-Gm-Message-State: AOJu0Yzkgld4BKa1x7iv5ZSvCNvS9e50tKKXYA5jlX/9/SLuD1+uIry1
	ZSSqcLcCFJ3Sc+TdBl+E/E+U3Fi7Ez+uCr0Ucakg4QV34P3FzjfLwRhB
X-Gm-Gg: ASbGnctqVQLvUkGY+sbVSZTvXam6L1Wiq/ls27adKwYzk6SaR4mIB3rEUVx1/ruOSc6
	eZPsM7xON+DnqJjarlSKcvye7mpg8j1nVi19q4bBBmeUzH6BbdD38ohTFb70l9wqPQRvEkgJzdR
	4IjtpS1+/fsizsW2D+M0oz1ANPq8mcunk85avPHHRAZ/LACeMeYS2mLVYk3L9jO4WrsNXmZHgZ9
	xbQfetKfgyHlw7Z4gjascMXxzFu6V0kr10kw3av9xNPigrnS2az+6GI88lAiQXmKC0YMbGKBchA
	gDRnRVpADQUtcHaGPKudFMuvF5Ed+EzORYFhNeh7/nNwVtO1RemVkbujUOqn2+gq86cQ22F7VxC
	SVZUIMZgCBpmltR0lWi27MD0PFPSQ455Ae51u11luRYItTo1v+SuYrgGLxBYMHfxfySi2UzodF5
	GZcEuQaM58PAILTwOvWEMnTO6PEG1O2EiTUVLonSHho8Qg0e1dV7s=
X-Google-Smtp-Source: AGHT+IGspYXmR4YxpeQGg57qiWu34oNl93bwQFPMt7D8ODMVLpp2KTojGZyp7q87NVTNiEbSLgF5Sw==
X-Received: by 2002:a17:902:e88e:b0:248:ff5a:b768 with SMTP id d9443c01a7336-290c9cf35ccmr121143215ad.10.1760929909062;
        Sun, 19 Oct 2025 20:11:49 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1da1:a41d:2120:6ebb:ce22:6a12])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-292471d5794sm66007245ad.53.2025.10.19.20.11.41
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 19 Oct 2025 20:11:48 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	david@redhat.com,
	ziy@nvidia.com,
	lorenzo.stoakes@oracle.com,
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
	rdunlap@infradead.org
Cc: bpf@vger.kernel.org,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v11 mm-new 03/10] mm: thp: add support for BPF based THP order selection
Date: Mon, 20 Oct 2025 11:10:53 +0800
Message-Id: <20251020031100.49917-4-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
In-Reply-To: <20251020031100.49917-1-laoar.shao@gmail.com>
References: <20251020031100.49917-1-laoar.shao@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6F50614000D
X-Stat-Signature: s8mauj9ejmsq6jhz578cnhdbqumjzcij
X-HE-Tag: 1760929910-784113
X-HE-Meta: U2FsdGVkX1+HDj+s4gEk7sjytEjdeiPrjpQY/zqWQChqwSWhdMEK7sKoCEhDnyLx7Wihaqr0+OuNuLQJtuA2ONXYJdAH1MS8wLme9OLPkRcEHRai6ZKYrpZw44mfbc6wlx/PmMjwJiWPJSfcQRckau2fxvT8L9Wxi+x1vcff8CYJfO1JOkMRJUSFDra3BWPx1UYQp28Idz6Dv4q18TpUH2vXEdj3DyviZdQqSAVoO8SfAf/pZr4Su2CTwd20n3N3A/29wYxRooPjHuAxX4kWI/E2oNCSWSbpUmeKu7xqAeaW9140sVjrWyJKcjkzCMBFK98UyGE0ugXm88ysaiW4Qt5aOh+PskMaNj9wNUh4LpfybhRdFoRGS9dPMN/j8MuCrGlK2w8Y0sqRODH6h+44yPtArbOt+pe/RVzlAwOqlerq+0AAt+hBq07C2wCPr4Z+QRbYNONPHK+P1VVGdWdRZfG8FkK8eydYeVuFSyJfFUy1ccxQw6rB0q/eHl2ck5sN3lpwSLjg05io7mrBp1NuHuGVujtFfp51lyE5eV/7kAeRBsW6BaU8oiDjkEpMO/xLEWOIgCFrvTaWes+7yY6Mb1qaov48rYVtI3WZfnGdzLBlICco1G2tGnpRtQfX7sd7KU2F64wjyDXb/PxtR2LviY9IA0Jdnpi0PnYfQDlTBsO1r3YoJN+t6zp85zKM53KY5h5cT7FKq5M4YCRYD/qEmXZceGsCo2d3BgupoHDbb/d0/1cpTISqBzITFAZjrVGiXdpxMd7vPxyUDZnMzoDssg9WrWimzqSG7cw0bTiGF9qKKYpAucMTb0/EHEFjyZFjgQ+iZLKaaF95KscSSeQWVG7gw/qGvKMjbGx+Tj54JPNbnWY+0h7rJ/hImBuVdVAYu5QW0rgvr0XQdF+BoSbJOakUnyiN/MuaKhDC8jHG1nw5tOemgkTlGz8EdH7sSUlT5POnBgt3wJYROJBOBtq
 Lr+JwNrN
 6e10J7A9PZTZI2AauV3TwofBPNUD8ErhX7HIvvuAQXzjcWVtGozK4nZaHspeoKqmfEHUShf2AqI/N0jIz9gY0dfWP/n99jrh0XqpWUx2ki49lwNy6F2Qelp1Gvg/uK2R199DZvlCyoR1E7GwvIQECdl7LROpkxwhiNrr/RP+q2TRtdmFnYe5veWf+bVODPo8j5e5k2lU8D9Zh7UGYsNB4wj5ucNThZ7kd0gaDJGmYfIBBkRp99FqA7BUySUApX3V9eH6xSD4CR0WIzHr+qzO3vrCJufFImXNxB0Ylcp+9oz9BQLdr30r0purfXhB02vSdWWhHTo+LamqXDDsWYfe1YpxdyfUGyQszf04cakN/gWN1ZPa01rSWfdH3dggkTyOOQt3M51QLuySw2+jgJ8lCRmt8FkKePDfvOg9jvSCFa8lnLCLIKuPFIhDU0RTzLaoMUkSr54OEdA+ltbeq9Y4nzQAkm3jkK7raLx0hPyhpNPJFSKJp/Owc8h0aNBQcmbWbDvg6yql+5OcOTCdAItHVy5cotp90zZmfST9FoBpcC6uhVNQ7bd7u9/wQZLGsKxiwKsEnD0DLodcZs637oQch+JAbDtW3sD/gxb0tv5uh9l+DTrIu7Qog6AsWKA==
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
 * Return: The suggested THP order for allocation from the BPF program. Must be
 *         a valid, available order.
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
 include/linux/huge_mm.h  |  40 +++++
 include/linux/mm_types.h |  17 +++
 kernel/fork.c            |   1 +
 mm/Kconfig               |  22 +++
 mm/Makefile              |   1 +
 mm/huge_memory_bpf.c     | 314 +++++++++++++++++++++++++++++++++++++++
 mm/mmap.c                |   1 +
 9 files changed, 398 insertions(+)
 create mode 100644 mm/huge_memory_bpf.c

diff --git a/MAINTAINERS b/MAINTAINERS
index 46126ce2f968..50faf3860a13 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16520,6 +16520,7 @@ F:	include/linux/huge_mm.h
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
index 5e5f4a8d3c59..5c280ab0897d 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -269,6 +269,41 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 					 enum tva_type type,
 					 unsigned long orders);
 
+#ifdef CONFIG_BPF_THP
+
+unsigned long
+bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
+			unsigned long orders);
+
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
@@ -290,6 +325,11 @@ unsigned long thp_vma_allowable_orders(struct vm_area_struct *vma,
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
index 4e5d59997e4a..0b4ac19e14ba 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -976,6 +976,19 @@ struct mm_cid {
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
@@ -1273,6 +1286,10 @@ struct mm_struct {
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
index e47321051d76..a0304c1f2fa8 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1363,6 +1363,28 @@ config PT_RECLAIM
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
index 000000000000..e8894c10d1d9
--- /dev/null
+++ b/mm/huge_memory_bpf.c
@@ -0,0 +1,314 @@
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
+ * Return: The suggested THP order for allocation from the BPF program. Must be
+ *         a valid, available order.
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
+	/*The list of mm_struct objects managed by this BPF-THP instance. */
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
+	int err = -EINVAL;
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
+		goto out;
+
+	err = -EBUSY;
+
+	/* To prevent conflicts, use this lock when multiple BPF-THP instances
+	 * might register this task simultaneously.
+	 */
+	spin_lock(&thp_ops_lock);
+	/* Each process is exclusively managed by a single BPF-THP. */
+	if (rcu_access_pointer(mm->bpf_mm.bpf_thp))
+		goto out_lock;
+	err = 0;
+	rcu_assign_pointer(mm->bpf_mm.bpf_thp, bpf_thp);
+
+	mm_list = &bpf_thp->mm_list;
+	INIT_LIST_HEAD(mm_list);
+	list_add_tail(&mm->bpf_mm.bpf_thp_list, mm_list);
+
+out_lock:
+	spin_unlock(&thp_ops_lock);
+out:
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


