Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B34C9FF8860
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 11:47:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29D816B00B2; Mon, 27 Apr 2026 07:47:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 274186B00B4; Mon, 27 Apr 2026 07:47:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18B276B00B5; Mon, 27 Apr 2026 07:47:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0747A6B00B2
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 07:47:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C25331B6F0B
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:47:54 +0000 (UTC)
X-FDA: 84704161668.04.A23E9E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id AE0BF80008
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 11:47:52 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eg9Jiiou;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777290472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5vg9xoDKrzbnriu8DCxQCXsgI1uZAv4Cl72wPpMiEa0=;
	b=0mmZu1CYzCJhx3sn7BLjkff5LF4wy+DT6zZw+urJqk1b2EkvJpgaS54xp/oVb8TBPVZphT
	Qq38O4I6fkBGoqvxi7jDC+NIhdMB9rV79xwYdAtr3JQw4CJ81eGi05d5MzdXSzWjcfXMJs
	m2mWPr6tM+82NVbrUlvqCqK/N3nNUL8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eg9Jiiou;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777290472; a=rsa-sha256;
	cv=none;
	b=OHUhAMsi17jgBEuGqq51tJS/bh7R4utrI2asgAvGBNJopQc5W0bG1AU3RHE0QvcX5UNzze
	7T3Ys3U2k53BBoM4Us0SXl+gt/y4HgLk6176ndhG3g2XANrJLHbcvQMrunSeG/JsM0OTJN
	2TDCvaGRrHbj4jDlgeUX1U+he9qWwH8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D358B43DFB;
	Mon, 27 Apr 2026 11:47:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33668C4AF0B;
	Mon, 27 Apr 2026 11:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777290471;
	bh=hRY7obmR9e6QVqFUCEmAN4SbG7l3gAQ60qItIMhRPe0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eg9JiiouctuUABW9G2hFJPK56S97wwLRrS8UqsN9Ib0aV3769tFkptTI1EEhujooF
	 4jqAGKkPNrGNHf1Lj128ABqR/ossA4jknjuJtPQJ5yGArfCcUuktoDuUdZ91JAORKR
	 N4Yv9WWppQm6uAF9fblyPKF0bnM8dTcrU0ySXLnyN/aBluBAkMsdxRz0A4zI3cMej+
	 XTSviGI1Imtrc34OsdffAoYhSG0Bp+JPrPBW9YUAuSmWQeiH3EBtoSX5Tg2v9Z8/6+
	 f+RuI9E9A3rCRl2RX/eB5su/kTEng+mXdR53osoPJFGX4bEtil201v1bEhkM4wsw3b
	 dYu5ZoBoNh9tg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 5BD14F40069;
	Mon, 27 Apr 2026 07:47:50 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 27 Apr 2026 07:47:50 -0400
X-ME-Sender: <xms:5kzvaUFy18kEp-30nW--_kDEeHiGd8r_oAfIRp8aZFP_3ueBK_Gh2A>
    <xme:5kzvaRRTeAF9VXtfEtcCebKV9XO3YSaZe1InmaD4DaDZxrtO4bj2b58B4_t3AFkG9
    xn8BbCyH7O7UawwDsUGmGKFEDNB4kloY8xOkb__JlB-XaBUSSrcPheE>
X-ME-Received: <xmr:5kzvaWqXDPJf5myhpjL0KHo-GbMvyeiZbFTRMqkjvqUwSIizXYEkIyM9yYM_Dw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdejkeeiudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgjfhgggfestdekredtre
    dttdenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceo
    khgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhudejfedvgeekff
    efvdekheekkeeuveeftdelheegteelgfefveevueekhfdtteenucevlhhushhtvghrufhi
    iigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmthhprg
    huthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdekqdhk
    rghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtph
    htthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehlihhn
    uhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphht
    thhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghp
    thhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhh
    hofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihguihgr
    rdgtohhm
X-ME-Proxy: <xmx:5kzvafrE-VLf03Dqrii8IRIE8tHz18hhXPbkaCy1byZDSGf8txAhQw>
    <xmx:5kzvaR3NkexKgdevnXOo5PA6H09IT1dRuyNcxGlAJODKolB-Tbozdw>
    <xmx:5kzvaTh1YfSIsrYFWWFGqfLifJogcLEWOJLaJJvDBoOQRuu1qC5ORg>
    <xmx:5kzvaQlfYIxjLrQWjA0ZJAwnSJe59haFuy8aHV9gvA4P53i_Gz1jzA>
    <xmx:5kzvab-7WB1FQj8Ax7uhnqOW2NE4CKXLo68ACPXeDiKtx8IWGZ7JeMV7>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 27 Apr 2026 07:47:48 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	peterx@redhat.com,
	david@kernel.org
Cc: ljs@kernel.org,
	surenb@google.com,
	vbabka@kernel.org,
	Liam.Howlett@oracle.com,
	ziy@nvidia.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	seanjc@google.com,
	pbonzini@redhat.com,
	jthoughton@google.com,
	aarcange@redhat.com,
	sj@kernel.org,
	usama.arif@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	kernel-team@meta.com,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH 12/14] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Mon, 27 Apr 2026 12:46:00 +0100
Message-ID: <20260427114607.4068647-13-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260427114607.4068647-1-kas@kernel.org>
References: <20260427114607.4068647-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AE0BF80008
X-Stat-Signature: mf6mhw6idmb6c4148a3ot8jw638r7uhz
X-HE-Tag: 1777290472-661672
X-HE-Meta: U2FsdGVkX19AY/Xivt3B4i2zxfMPRqBYvxi6TgTe/Hf8qp/z/CUnG0sU0fi93wxc2J+OEPR6KmMaEypauwalMwTSHqLJ1tOhfyyHVODmcFVp9JRW76BfPBXMXMj43lksCvEeBPUCL0mo2LV3UMOoc9czFe6gPuRMTs427YqKWwucaobYm9urSQd3j7XMl9GSeraDW+8NGdDLBPry0az3GiPMYnX6w0MP4bLq8+iJx3rj/eifL+s/hTWVoVYSuL7bjd7N0PLwx21Nml9EXGT9eZOlXB1IWZJjVQXv51eLO+tKGsDD0qPojt5T1Ol0Fu51uzLHEvveb2vxYBo1fRt0fRbZBKi2skADs1aQ/UtpJ76KV30Z/Cei3l6pt1Is9UrQ97ck2rYSvi8QB0ZdnXuk931vbXgt0oYKKRDjhihYcr5B7V+SLJtxjXSccW+5M2Kl9Cc0M119hm82JzpQOebII1wsgGwY/r0fCY50ucK48OEDnUvKTnhlbc7m1u0EdpaHz74mADPagptDED5wXsEqpf0l+SzX8PJDfaOClWGRHIhjbrIGc7G6uar6ntXYC2xPKIRLfZod6jEpss6GZs8GLtgjqdkix8u1W4hOvPZ5eqeRpwWhOIO2j2ZQRMt/9nYi57ANvVA0QLuM7lBjE9/Ln7eE82tnlGWhELC13HzeSZdqBl+WGP/FR/Zek1XN9aImrrxAq+B+dZacmlBwHM/vdJr36rURS7UvmSW3fMUgqqv1cQnkRQlcXV4n1A+yvE1BKZPpfk7aW7mNeUOJMjHMpz6ezJ3CuH716e3GQ6RhRQYfC1RQU7CInwQ4vSPo6Iv39bp79/zsW0AWZR6yZoXTtdN0kFfhMO7e7L62uwXcPimGJeUfrMQWs3WzzCPzpU44UgkoguRiS6PrCle9R5CeCOegnvdFzQVPgpoUwjK5z6+VvFUR91jQr1MNJUN3Rswyi6O9fwVCCnVjp/Yp0rK
 ocvpB6oj
 hs2mH66kYQVauvympK5tE01wa7qgFqvS822sR76PCQVWa9YydBDhY93wBr8cdiccsDyspwyBipNP+4MRBVL1xhckFgaz6MJ1u04xmy5ITnaYy0WOrjeIEkjkaQ0TTcKmXEnV6fiQ7uCElIi8Jzzyl3+MNC+6pqmBJIIX/jAWMrJ0fT0b/UdpcUUR+P8zKN9Lu1IGX8On10ftidGRNpExWa0I1tALH4fz/jUq8koT0ZG54Va2zJZ5G0qet4M9EtFqiWlQudVzCfVcOJKRGmAQ/sUIXoIBNYvlyvbUp/AWrL/EVpnvGrxKuhQRjyQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add an ioctl to toggle async mode at runtime without re-registering
the userfaultfd. This allows a VMM to switch between sync and async
RWP modes on-the-fly -- for example, starting in async mode for
working set scanning, then switching to sync mode to intercept faults
during page eviction.

UFFDIO_SET_MODE takes an enable/disable bitmask of UFFD_FEATURE_*
flags. Only UFFD_FEATURE_RWP_ASYNC is toggleable today; the ioctl
rejects any other bit with -EINVAL. Enabling RWP_ASYNC also requires
RWP to have been negotiated at UFFDIO_API time, mirroring the
UFFDIO_API invariant.

Fault-path readers of ctx->features run under mmap_read_lock or a
per-VMA lock; the RMW takes mmap_write_lock and calls
vma_start_write() on every UFFD-armed VMA, so those readers are fully
excluded. userfaultfd_show_fdinfo(), however, reads ctx->features
without any lock, so the RMW is written as a single WRITE_ONCE and
fdinfo reads it with READ_ONCE. That keeps the lockless observer from
seeing a mid-RMW intermediate and removes the audit burden when new
toggleable bits are added later.

When switching to async, pending sync waiters are woken so they retry
and auto-resolve under the new mode.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 fs/userfaultfd.c                 | 130 +++++++++++++++++++++++++------
 include/uapi/linux/userfaultfd.h |  14 ++++
 2 files changed, 120 insertions(+), 24 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 4a701ac830f4..83e759054464 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1871,6 +1871,107 @@ static int userfaultfd_rwprotect(struct userfaultfd_ctx *ctx,
 	return ret;
 }
 
+/* Subset of UFFD_API_FEATURES actually supported by this kernel/arch */
+static __u64 uffd_api_available_features(void)
+{
+	__u64 f = UFFD_API_FEATURES;
+
+	if (!IS_ENABLED(CONFIG_HAVE_ARCH_USERFAULTFD_MINOR))
+		f &= ~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
+	if (!pgtable_supports_uffd())
+		f &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
+	if (!uffd_supports_wp_marker())
+		f &= ~(UFFD_FEATURE_WP_HUGETLBFS_SHMEM |
+		       UFFD_FEATURE_WP_UNPOPULATED |
+		       UFFD_FEATURE_WP_ASYNC);
+	/*
+	 * RWP needs both PROT_NONE support and the uffd PTE bit. The
+	 * VM_UFFD_RWP check covers compile-time unavailability; the
+	 * pgtable_supports_uffd() check covers runtime (e.g. riscv
+	 * without the SVRSW60T59B extension) where the PTE bit is declared
+	 * but not actually usable.
+	 */
+	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
+		f &= ~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
+	return f;
+}
+
+/* Async features that can be toggled at runtime via UFFDIO_SET_MODE */
+#define UFFD_FEATURE_TOGGLEABLE	UFFD_FEATURE_RWP_ASYNC
+
+static int userfaultfd_set_mode(struct userfaultfd_ctx *ctx,
+				unsigned long arg)
+{
+	struct uffdio_set_mode mode;
+	struct mm_struct *mm = ctx->mm;
+
+	if (copy_from_user(&mode, (void __user *)arg, sizeof(mode)))
+		return -EFAULT;
+
+	/* enable and disable must not overlap */
+	if (mode.enable & mode.disable)
+		return -EINVAL;
+
+	/* only toggleable features that this kernel/arch actually supports */
+	if ((mode.enable | mode.disable) &
+	    ~(uffd_api_available_features() & UFFD_FEATURE_TOGGLEABLE))
+		return -EINVAL;
+
+	/* RWP_ASYNC can only be enabled on contexts that negotiated RWP */
+	if ((mode.enable & UFFD_FEATURE_RWP_ASYNC) &&
+	    !(ctx->features & UFFD_FEATURE_RWP))
+		return -EINVAL;
+
+	if (!mmget_not_zero(mm))
+		return -ESRCH;
+
+	/*
+	 * Drain in-flight faults before flipping features. mmap_write_lock()
+	 * blocks new mmap_read_lock() callers, but per-VMA locked faults
+	 * (lock_vma_under_rcu() + FAULT_FLAG_VMA_LOCK) that acquired before
+	 * this point keep running. Calling vma_start_write() on each UFFD-
+	 * armed VMA waits for those readers to drop, so no in-flight fault
+	 * can observe the old features after mmap_write_unlock().
+	 */
+	mmap_write_lock(mm);
+	{
+		struct vm_area_struct *vma;
+		VMA_ITERATOR(vmi, mm, 0);
+
+		for_each_vma(vmi, vma) {
+			if (vma->vm_userfaultfd_ctx.ctx == ctx)
+				vma_start_write(vma);
+		}
+	}
+	/*
+	 * Single WRITE_ONCE so the fdinfo lockless reader can't observe a
+	 * mid-RMW intermediate value. Hot-path readers already serialise
+	 * through the mmap lock + vma_start_write() drain above, so their
+	 * load doesn't need an annotation.
+	 */
+	WRITE_ONCE(ctx->features,
+		   (ctx->features | mode.enable) & ~mode.disable);
+	mmap_write_unlock(mm);
+
+	/*
+	 * If switching to async, wake threads blocked in handle_userfault().
+	 * They will retry the fault and auto-resolve under the new mode.
+	 * len=0 means wake all pending faults on this context.
+	 */
+	if (mode.enable & UFFD_FEATURE_RWP_ASYNC) {
+		struct userfaultfd_wake_range range = { .len = 0 };
+
+		spin_lock_irq(&ctx->fault_pending_wqh.lock);
+		__wake_up_locked_key(&ctx->fault_pending_wqh, TASK_NORMAL,
+				     &range);
+		__wake_up(&ctx->fault_wqh, TASK_NORMAL, 1, &range);
+		spin_unlock_irq(&ctx->fault_pending_wqh.lock);
+	}
+
+	mmput(mm);
+	return 0;
+}
+
 static int userfaultfd_continue(struct userfaultfd_ctx *ctx, unsigned long arg)
 {
 	__s64 ret;
@@ -2109,29 +2210,7 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
 		goto err_out;
 
 	/* report all available features and ioctls to userland */
-	uffdio_api.features = UFFD_API_FEATURES;
-#ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
-	uffdio_api.features &=
-		~(UFFD_FEATURE_MINOR_HUGETLBFS | UFFD_FEATURE_MINOR_SHMEM);
-#endif
-	if (!pgtable_supports_uffd())
-		uffdio_api.features &= ~UFFD_FEATURE_PAGEFAULT_FLAG_WP;
-
-	if (!uffd_supports_wp_marker()) {
-		uffdio_api.features &= ~UFFD_FEATURE_WP_HUGETLBFS_SHMEM;
-		uffdio_api.features &= ~UFFD_FEATURE_WP_UNPOPULATED;
-		uffdio_api.features &= ~UFFD_FEATURE_WP_ASYNC;
-	}
-	/*
-	 * RWP needs both PROT_NONE support and the uffd-wp PTE bit. The
-	 * VM_UFFD_RWP check covers compile-time unavailability; the
-	 * pgtable_supports_uffd() check covers runtime (e.g. riscv
-	 * without the SVRSW60T59B extension) where the PTE bit is declared
-	 * but not actually usable.
-	 */
-	if (VM_UFFD_RWP == VM_NONE || !pgtable_supports_uffd())
-		uffdio_api.features &=
-			~(UFFD_FEATURE_RWP | UFFD_FEATURE_RWP_ASYNC);
+	uffdio_api.features = uffd_api_available_features();
 
 	ret = -EINVAL;
 	if (features & ~uffdio_api.features)
@@ -2201,6 +2280,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_RWPROTECT:
 		ret = userfaultfd_rwprotect(ctx, arg);
 		break;
+	case UFFDIO_SET_MODE:
+		ret = userfaultfd_set_mode(ctx, arg);
+		break;
 	}
 	return ret;
 }
@@ -2228,7 +2310,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
 	 *	protocols: aa:... bb:...
 	 */
 	seq_printf(m, "pending:\t%lu\ntotal:\t%lu\nAPI:\t%Lx:%x:%Lx\n",
-		   pending, total, UFFD_API, ctx->features,
+		   pending, total, UFFD_API, READ_ONCE(ctx->features),
 		   UFFD_API_IOCTLS|UFFD_API_RANGE_IOCTLS);
 }
 #endif
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index c10f08f8a618..cea11aad6b54 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -49,6 +49,7 @@
 #define UFFD_API_IOCTLS				\
 	((__u64)1 << _UFFDIO_REGISTER |		\
 	 (__u64)1 << _UFFDIO_UNREGISTER |	\
+	 (__u64)1 << _UFFDIO_SET_MODE |		\
 	 (__u64)1 << _UFFDIO_API)
 #define UFFD_API_RANGE_IOCTLS			\
 	((__u64)1 << _UFFDIO_WAKE |		\
@@ -85,6 +86,7 @@
 #define _UFFDIO_CONTINUE		(0x07)
 #define _UFFDIO_POISON			(0x08)
 #define _UFFDIO_RWPROTECT		(0x09)
+#define _UFFDIO_SET_MODE		(0x0A)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -111,6 +113,8 @@
 				      struct uffdio_poison)
 #define UFFDIO_RWPROTECT	_IOWR(UFFDIO, _UFFDIO_RWPROTECT,	\
 				      struct uffdio_rwprotect)
+#define UFFDIO_SET_MODE		_IOW(UFFDIO, _UFFDIO_SET_MODE,	\
+				     struct uffdio_set_mode)
 
 /* read() structure */
 struct uffd_msg {
@@ -406,6 +410,16 @@ struct uffdio_move {
 	__s64 move;
 };
 
+struct uffdio_set_mode {
+	/*
+	 * Toggle async mode for features at runtime.
+	 * Supported: UFFD_FEATURE_RWP_ASYNC.
+	 * Setting a bit in both enable and disable is invalid.
+	 */
+	__u64 enable;
+	__u64 disable;
+};
+
 /*
  * Flags for the userfaultfd(2) system call itself.
  */
-- 
2.51.2


