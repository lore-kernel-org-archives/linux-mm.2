Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C93ACD5BB1
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 11:39:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66B906B00A9; Mon, 25 May 2026 07:39:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6246B00AA; Mon, 25 May 2026 07:39:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E4286B00AB; Mon, 25 May 2026 07:39:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 34F2E6B00A9
	for <linux-mm@kvack.org>; Mon, 25 May 2026 07:39:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 015FB14015B
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:18 +0000 (UTC)
X-FDA: 84805746438.03.9F4D3D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0361E4000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 11:39:16 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XVMFF+sX;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779709157;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VJiLnnmxKx1AqdCXsILEaQEuBxwUu2dxhQnKdI014eI=;
	b=BbjudnmxEHBZj3+NBb+B3C//Njptj0jFf0K9uEr2aQIuoJdl3yoDvMBxRBWQ0wvAh0BU1R
	pFWQLH7Z/CrrnBHxCFeEkqL0Wt2MvV4xOZgRx3I0y9OAR7ZkjrLAbMXdi45mWuZqy9Jp0Y
	9jl6wqFleqZRsfCHxvNoYoFwWXo9tB0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XVMFF+sX;
	spf=pass (imf07.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779709157; a=rsa-sha256;
	cv=none;
	b=EEgWAVeXQA1AWJpELYOeSVh5qt2eQ7QrE8tkzhI/LsL5VJZOJ3y+9UtXCMB3v9qJK37IXD
	oxaezZG1/s06FgsVCkKIDBwd0fYJUuHYaYFrwQuehGarBcM7ujNskAG5JQEe9QieN7Qamv
	Qg+NEQCHKQWa8NuTBbMfdLK54cxL7Uw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4EBD1445C3;
	Mon, 25 May 2026 11:39:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FEC1F000E9;
	Mon, 25 May 2026 11:39:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779709156;
	bh=VJiLnnmxKx1AqdCXsILEaQEuBxwUu2dxhQnKdI014eI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XVMFF+sX4StSiQ06wtHszuJChE0tmiL0oaL4TgEg5vBgnOCciuOEoUVq8SajUq3yO
	 eEr1Yej9aB6JUmeXV7HYUrSiXQJqWC6pxp1SQgXsib2rv3V9/uKO+pGqfNxcFxC3OI
	 BXS+VLmNp0Za7Yf8V9JKFbbjxYWA3r9SEBhoIeGbbAjbX64q1Xsc9DqRh9Md5haRry
	 /TIzkSE3CIr8izT6JW6Q/u3VCnH2JtgF6bP66vx+Oso70pLllfdvsHiMV+RuEPNkpP
	 Bg4OlmhfNKAnhBzWdLIIhvtyFDA3p7xQ0CkSy3OeqMMq4bn2ljrHfxfJUnttFd6lCg
	 xOjLJGzPvlvdw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id E2944F40082;
	Mon, 25 May 2026 07:39:14 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Mon, 25 May 2026 07:39:14 -0400
X-ME-Sender: <xms:4jQUaomlLMT3f2VicKLG5B9DAv9kW9Bf_TbZECqWUmEXyYPHsHgDlw>
    <xme:4jQUarzYMdqqBQjtQT2SZXtTq8wN5hXjfl5SMF89a4QckwBwQFkuGxUnY25902diL
    xtic5bOv_oNM1goxCU0KYVMBWjODcAYNrIO-38oXUCJtMT9kEhj3w>
X-ME-Received: <xmr:4jQUavJv_82IYATNHHoWhLLba5Dc6OQuRn1G73nZtwKzZA1or7NubStU9YGuww>
X-ME-Proxy-Cause: dmFkZTFnTuEJhvyD+myNg4p794atgQHzdZOXs2A3gxvR3FSD7M0iqWwHWhOfEG1IgnscR2
    dpWEnUQHTt04gBiZJ6FOYLwJWkueK3/2x7yPKsRIizx2ATY4cFZISTDZP9EiTwl/39cNmM
    OA0CsMrDRjxwva2a2lWcAgzMzYsZoGkumkodmX+5ok307LF0rRD0oLFOgPIpccglfJ7Cmv
    AURvPb/dWg6Eh/o3LACLo5CgxqvMM0m0aATVsjZcPfM5Eqk+WNKfRQ8GkDG8MvyLCL9P+n
    Ffx6yvOWdEN3fPIKUkuyF3PJ8RYaK5VmWWEYQaxtLNJTEh5sz7hSNo8ZFBfkwknbfQV6HA
    7SIS4yYDrm7L/JyPwzoUh/jhVh8fTVT6g27fnKgicpk86vK9a+0Gke1AfOkjM+6TDjHjVb
    fNKLEKArXXTuzvROeBsxd9FXHQjGTxjvBjnkm8Ggf6DzqfgOycjNsGDy/TzWnbSS1vbbVo
    /BBpYUUqtwJrP3ujfvaq/a4LYgi9p7yt07xwmPlqwQHyqbUp+9hXF9zxPMSPHZB7iuDeWn
    C5rF9J8xyX7m27pqToy+P7UD7UA7a2SlYIYmmPTlo+C7r5OxT0rcGXSs80ECVaoqaOgSMG
    pYsrF2sXk2BI4xWyuyWQtQgrXPE/nN6dVL1YbLMMmMFxPfglk91Y7iNhsJcQ
X-ME-Proxy: <xmx:4jQUauImSrUZAyR4Oct02FTPWQbYwnfa5tZ68GJwKQjtHnKqeuz__g>
    <xmx:4jQUauXsoXIksiVJJiftYV40SY2SyNwn_i-aAPuvvCY83sZEtG3nbQ>
    <xmx:4jQUamCtLEJo8WZLFr_BoPc-G3aphUCQGn5lVXjTOfm9vdi6W4zAEA>
    <xmx:4jQUahE4O7X7-QOP-NUW8R5B0Bi0X0lxMD7PE-dZwxCJQ6jqt-bUsQ>
    <xmx:4jQUaidU5CRnl6gisyo32K_cWkZv5JR7vjmnNKNqMN1YNhKXZnU-8FOj>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 25 May 2026 07:39:14 -0400 (EDT)
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
Subject: [PATCH v4 12/14] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Mon, 25 May 2026 12:37:26 +0100
Message-ID: <20260525113737.1942478-13-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260525113737.1942478-1-kas@kernel.org>
References: <20260525113737.1942478-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0361E4000D
X-Stat-Signature: py1nqcxdra46b6tqmxr4ucrhd3c99w1k
X-HE-Tag: 1779709156-696533
X-HE-Meta: U2FsdGVkX19NEByB/YlMWNUho7a+T9VXgeR6Nl0N0NSQ7KNyHGkpNyouno5/rcEwLnj46BKEqdUVEmWQWEz4pDGvd8mixZxgZIIEJ0q3KW1/7PFAL10g9TQ5INucC/YQXeY4ES1Yde8BUtVxr/9Hsr0ec8aKvXI8LGH8JjyVBGxni+be151pRMZTI7b+nBHVGwGRC8FPS8+hsP5EwiaCU8Nd6FtTmf/Z6dEPRh6ji+i/ykqETPjnu/d2opvG+uhAd0NlZLvkMfyiARa9HBWhl6oKLnkXeT43e1NSK9BXr5koMzgyA3/4gA8b5grtZ7r00Ka1BqamwCbE3s6AedsBqFYOWLtA0pFECXvCl0pjvCGJX0NvdPYB9SbBGNLQFNiJ2+544E391NBaDTHkRYBaPxWRG2E5HGzOdMmPmWB+GbOvf/Ud8muv+YHI7GaprFuQfE2U9cfuaT0YpUvPlm6AvJW5wrlKFnEXU5nW8b8f8W64FBNZ+0fbxsLCPmM9EFBNFr7Eq5GQYLREO5tsy+/mwE4gFiElDkitFLYF6uPh0pzpdK2oC3zgDJz8fT3KWFOgK+3+N6qgoTCUfmjAFrHQpbEggjKyVZcgq37B8LIr1tpSegDMNTGVebibpLBorES3bFyk9I+QgKDZkqRSo+uvYIXY6URfkBHq+Xq5ElwB8WsgpD9IRYkta0c1sokkmOblhUHcwymIyDpNHWETkA+qGA6vNkigqBiEf25EfNYVrFPkZgaqJnoxvx12tsy2qfL+vlX7ZgUjhC8Vl5SnhQ16fcJceEyQzmCg0o3GMTLCPUvbTU9aQ+D0243M95t4DyGEfSACJ05N7ydWtImpKj0cAhjTixaGwJQqCnT/y0fg/iF8pZCD3+9jkIBAYSM5BTv6220piiChLftsVSNt/eXGA030mMAbhXyMaoPnYV+l1GK1aFtETM10bd/8Rw6QF5DBKc/3P1EP5+gtZNRLayv
 JcusBIrZ
 WbqQ0fmDuDlcySMregp9WGMOmp8p1FojAGpVTicaTr//Va7NfHsJx1PkOgfeEy5dn9mLjX1KTYD1z7BlKpi09yKuyESr95jasSixDTUrpK8Uy05WvNY7sFk0eHaM6FbEwjnIBp+VIMCleRlKZL+0rDTgQ7KMlX28tymoYknCIrBIuh0ZYieeffb9o12Z4XtA2KSW3p7zQ88AOy5oNLJGVIyqEXzIZRITmlxoqDRualfglufKLOvy2zM7z04zLT4IJchoKhoBxWNN1/5WgGPuPN2tj5sNu3hLt7c2KlmQPOLpHwnfxLSM9c97Ia9NBwkhkq/TCMt8C3NPTrp8=
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
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 include/uapi/linux/userfaultfd.h |  14 +++
 mm/userfaultfd.c                 | 150 +++++++++++++++++++++++++------
 2 files changed, 136 insertions(+), 28 deletions(-)

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
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 20478bb37311..680ef9bd57fd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2468,19 +2468,29 @@ struct userfaultfd_wake_range {
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
@@ -2495,7 +2505,7 @@ bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	if (!ctx)
 		return false;
 
-	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
@@ -4261,6 +4271,109 @@ static int userfaultfd_rwprotect(struct userfaultfd_ctx *ctx,
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
@@ -4499,29 +4612,7 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
@@ -4591,6 +4682,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_RWPROTECT:
 		ret = userfaultfd_rwprotect(ctx, arg);
 		break;
+	case UFFDIO_SET_MODE:
+		ret = userfaultfd_set_mode(ctx, arg);
+		break;
 	}
 	return ret;
 }
@@ -4618,7 +4712,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
 	 *	protocols: aa:... bb:...
 	 */
 	seq_printf(m, "pending:\t%lu\ntotal:\t%lu\nAPI:\t%Lx:%x:%Lx\n",
-		   pending, total, UFFD_API, ctx->features,
+		   pending, total, UFFD_API, userfaultfd_features(ctx),
 		   UFFD_API_IOCTLS|UFFD_API_RANGE_IOCTLS);
 }
 #endif
-- 
2.54.0


