Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1626CD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 296456B019F; Fri,  8 May 2026 11:56:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247336B01A1; Fri,  8 May 2026 11:56:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 10EB06B01A2; Fri,  8 May 2026 11:56:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EA3B46B019F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:56:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ADD60C0A49
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:34 +0000 (UTC)
X-FDA: 84744705108.15.8D7359A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id C07431C0014
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:32 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUylFRxl;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255792;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBRSZjPdXHd0ax7n8H3GneGiOmUA1GHqEVsn5XcerdY=;
	b=ciWTBOoPSKViqvnXa9VX2JPpf2VLyS49x6tEWmECHG3msqIY5p3NOXydiCHRyhTfkVEKJ0
	qRGSK1h66lzU5iGiFUFds2YdmtiaShyYLpTJJQWKgxGJWpCswOu9LH8WrvhpB1rA2cgHMF
	5QA6YQR8fd9WwxQlFqdXiB3Ej6KXEH4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255792; a=rsa-sha256;
	cv=none;
	b=TjBAzLjJ4LewsoPuWIglOUidtSf4GNyexv7SS2wxFI49aPOVuZmugKAyUkYPbVZ5Qzx4ft
	W18ZxusWXTs900gJ3E3/Ha6lf/zox+WbXTrIXwqyVgTJZyLwY5Y4UzLBRegYpph6m0EA1W
	0g+/aA1hcSQyNweovo+7o8wO/KwBzz0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tUylFRxl;
	spf=pass (imf21.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36F4361145;
	Fri,  8 May 2026 15:56:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E963C2BCF4;
	Fri,  8 May 2026 15:56:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255791;
	bh=rF1Hph0j5RuosA5fFwFqwHFJizVXDlJkkdiXUn+mTDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tUylFRxlqIZ6esjd0Hc0Z0gEzW/KtXKuXU2lfLqCtGz+Q+NjMriSuNSa0R+mbGn/a
	 6fWv3SotbGd0++Rp7/wF+/BhuFGXQyV9wRkAvYQJkinrB/IRphkrA0K8UaIYYK0FIH
	 f/RW4k3HTlg8d5V4kkmawGfvigv76NIXWQtGxJDM3y26TeIO3aMUmjAwJQFd0eWZWK
	 PyNRSxQMxTNkPA75f1D7rTv3rR2U1FN9vXxYJVUOAzRgmLDeDPDv9pYgFcHX7ayjLQ
	 GPdMyIbAssKy+kVNSKSr06rjIrGmLy9twDb4sNRdzipGIg8/N8yV4W0X34knG18zvn
	 wDnObisEum42Q==
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfauth.phl.internal (Postfix) with ESMTP id A15E4F4006E;
	Fri,  8 May 2026 11:56:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Fri, 08 May 2026 11:56:30 -0400
X-ME-Sender: <xms:rgf-aYunwQmJsxMTuKQR3Rc3D3u2Uf9P_otkilWhsELLz18rOkbreA>
    <xme:rgf-aZZ_SfAl9MLFfE2Amf3YSyeBRxgPQrmOEBAhpXa8CDj-Qn5sdXCFmM99AKm95
    9oZT_3xRM0QRzfHr_ujP1U87KcWNBDYO7-twqwB-J2jARdnUbezmQ>
X-ME-Received: <xmr:rgf-acRW8VJGK5w8uQXVvCkjZxBhojCrYx4vzo3kJXxJGJLL_n-zirwUj9714Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpedfmfhirhihlhcuufhhuhhtshgvmhgruhculdfovghtrgdmfdcu
    oehkrghssehkvghrnhgvlhdrohhrgheqnecuggftrfgrthhtvghrnhephfdujeefvdegke
    fffedvkeehkeekueevfedtleehgeetlefgfeevveeukefhtdetnecuvehluhhsthgvrhfu
    ihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepkhhirhhilhhlodhmvghsmhhtph
    gruhhthhhpvghrshhonhgrlhhithihqdduieduudeivdeiheehqddvkeeggeegjedvkedq
    khgrsheppehkvghrnhgvlhdrohhrghesshhhuhhtvghmohhvrdhnrghmvgdpnhgspghrtg
    hpthhtohepvdegpdhmohguvgepshhmthhpohhuthdprhgtphhtthhopegrkhhpmheslhhi
    nhhugidqfhhouhhnuggrthhiohhnrdhorhhgpdhrtghpthhtoheprhhpphhtsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghp
    thhtohepuggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepshhurhgvnhgssehgohhoghhlvgdrtghomhdprhgt
    phhtthhopehvsggrsghkrgeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhirghmrd
    hhohiflhgvthhtsehorhgrtghlvgdrtghomhdprhgtphhtthhopeiiihihsehnvhhiughi
    rgdrtghomh
X-ME-Proxy: <xmx:rgf-aUwaQouZpEWrLGFhJoZvgEqRyjDKLEPW6XSVBg1CnJOD_bXzoQ>
    <xmx:rgf-aQfNnaOVwwfbzEtXu0RvPv9Ij6vr1MLgaocUMXzckAwoEm7FxA>
    <xmx:rgf-adqnIYTNwyuMliBWDBTTh7rVzdeMv1x0O862wGtpFlRs6TtfSQ>
    <xmx:rgf-aQN6C5jp4cA2jNI6UzBjQP3Dj5jt4iqIsHhc0xOLWhGGQET4ew>
    <xmx:rgf-aTHU53lZpZ0bOtKq3d8NNAU8S0anuoz4Gm_vuEFFQwEQOCKzSHvM>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:56:30 -0400 (EDT)
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
Subject: [PATCH v2 12/14] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Fri,  8 May 2026 16:55:24 +0100
Message-ID: <e8f142c530b715c6d45475230c4e35a1cfd8dbd4.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C07431C0014
X-Stat-Signature: t75swbb3fssbw53t9p4jommajbukdf38
X-Rspam-User: 
X-HE-Tag: 1778255792-868546
X-HE-Meta: U2FsdGVkX1+dN85mo+sFpf/2onDHkBD6bskn/4r/Mi269y0F6rxJFbLbE0K0aDLdAWzfyVsbYc/A4OKkPjm9VC2NUYxa4/PG3NR9ln0hX5dkoG4IYlAsKTkn6BPzNpuTC57yYB85aNwV98NFJBnCihAVqDojrmgj5k55S/Uw2G4FPuAxoltj36tYKcnA9FL/0k4PGZPc11lYMWmEQ4uo6660cPXyj6SnxhL0iR2ADU0JtkXRNPxPo6WvJfVQIELtpKi9goN1dv+3uB8jr1PONvDUoQmIIT9lg8SaJ06ygfCLZHguYCTGrHF1LUFkj0UMi6fSGgtbVWvfXn1mUvXFpSwrSsrwCr3rLvh+PHQ8hgIeqIp1zhFXAx87PWAUB1Gom/MW1Z0IR3qUGH2c1hzAB6HDbGFy7CcZnTI2S5pprB3LINYYWs5hQeArAEgJCxmR6TZWvOuTsNxNX52KBvUQkpswL9bE2ndcr4HqdCgQFpG+YWDahaNuR7ZxXTvz9qY3Io3hPWgm6PHTtjHp2WhXE52nTnnxfTZI4jBFquW36cW82HSl82j5W+RZrPJAyGnYAX77AnaI7hyarYbdnyykBkycUYoL9kDHmmRYWo8uUxvKjac6Oi++ueAHQAKx4RsBkqk6zSEBGdwhgalSmPPdmXFp90lUccZk2VJdlkSwx3WpJAvKFb8lkgF+TkJQ3q+iEX6O8PWqe81p7CaW/q/WMK4D2jHEh/49DLjmZ5hrNjfYQdoYVC4wDHjQ8oYfEuD8Xnjg3RP5m+FHHmqReH83EiT7LzDhBGzg2krUFQwwkUW65wt9j1cFjg91kPS2JBE8UKtk3DeSLchpQvrViXDmqt0H8hnlghSgOCrHPLe7B45NZs0jjF9kmu1sFQeZVKn93syiikr6TDG6AWxb8yhn89ykmU1FSvN+wN1bQoXiXZdQZBGEAa1hYxiHyMNXL4p3RprYLQZRtuVxlSCsMd6
 IO92FzpQ
 ccI5JdK6kYibuKfrs7rhEdOVzU1BIHTapr0vwoPrOeTooisa1nuyob9gCWDsIZy0ONrpx0FkOb07il+BpaMsIRztupmtNCPZlAXp3ygZDDesB+vCqViX08PGQ4kEGhfYbfVShXsyAs+58Eu7uwqA2LzW9SPEIzMj9q4qVDo9fvBysOXeHJ1QB3M3huBvHggLEZdy1nAdgscrAvEyuvzuFcNBaTGSbNKOUhIOwPO4BFUpVrIMTD+OS7qEb0EkGsxvZgtZC4hDKK6hZW3OasafKfWpaHs/Y9ugRsz0YXDvrJ6H7uHHbFMFg1rzF9oilIg2NPh6j/+80teppHso=
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
 fs/userfaultfd.c                 | 150 +++++++++++++++++++++++++------
 include/uapi/linux/userfaultfd.h |  14 +++
 2 files changed, 136 insertions(+), 28 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 4a701ac830f4..908e63304706 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -79,19 +79,29 @@ struct userfaultfd_wake_range {
 /* internal indication that UFFD_API ioctl was successfully executed */
 #define UFFD_FEATURE_INITIALIZED		(1u << 31)
 
+/*
+ * UFFDIO_SET_MODE updates ctx->features under mmap_write_lock with
+ * WRITE_ONCE; readers that run outside mmap_read_lock or the per-VMA
+ * lock (poll/read_iter/ioctl, fdinfo) must pair with READ_ONCE.
+ */
+static unsigned int userfaultfd_features(struct userfaultfd_ctx *ctx)
+{
+	return READ_ONCE(ctx->features);
+}
+
 static bool userfaultfd_is_initialized(struct userfaultfd_ctx *ctx)
 {
-	return ctx->features & UFFD_FEATURE_INITIALIZED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_INITIALIZED;
 }
 
 static bool userfaultfd_wp_async_ctx(struct userfaultfd_ctx *ctx)
 {
-	return ctx && (ctx->features & UFFD_FEATURE_WP_ASYNC);
+	return ctx && (userfaultfd_features(ctx) & UFFD_FEATURE_WP_ASYNC);
 }
 
 static bool userfaultfd_rwp_async_ctx(struct userfaultfd_ctx *ctx)
 {
-	return ctx && (ctx->features & UFFD_FEATURE_RWP_ASYNC);
+	return ctx && (userfaultfd_features(ctx) & UFFD_FEATURE_RWP_ASYNC);
 }
 
 /*
@@ -106,7 +116,7 @@ bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	if (!ctx)
 		return false;
 
-	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
@@ -1871,6 +1881,109 @@ static int userfaultfd_rwprotect(struct userfaultfd_ctx *ctx,
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
+	 * Single WRITE_ONCE so lockless readers (fdinfo, poll/read_iter
+	 * via userfaultfd_is_initialized(), and the userfaultfd_features()
+	 * helper used elsewhere) can't observe a mid-RMW intermediate
+	 * value. Hot-path readers already serialise through the mmap lock
+	 * + vma_start_write() drain above, so their load doesn't need an
+	 * annotation.
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
@@ -2109,29 +2222,7 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
@@ -2201,6 +2292,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_RWPROTECT:
 		ret = userfaultfd_rwprotect(ctx, arg);
 		break;
+	case UFFDIO_SET_MODE:
+		ret = userfaultfd_set_mode(ctx, arg);
+		break;
 	}
 	return ret;
 }
@@ -2228,7 +2322,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
 	 *	protocols: aa:... bb:...
 	 */
 	seq_printf(m, "pending:\t%lu\ntotal:\t%lu\nAPI:\t%Lx:%x:%Lx\n",
-		   pending, total, UFFD_API, ctx->features,
+		   pending, total, UFFD_API, userfaultfd_features(ctx),
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


