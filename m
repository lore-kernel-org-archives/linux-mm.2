Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C90DCD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06DFB6B00F4; Fri, 29 May 2026 13:28:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01EEF6B00F6; Fri, 29 May 2026 13:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E01776B00F7; Fri, 29 May 2026 13:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C55A86B00F4
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:12 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 95C4D140234
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:12 +0000 (UTC)
X-FDA: 84821140824.03.6A016F0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8D3DD40011
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:10 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFPqhrbv;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075690;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4cGOsnZk0xVIPLCyz6aanH/SA/ySZrmY+G3zdoIpae8=;
	b=KRJAsiSSNyWqJYxVhQlzIY6xboUjLJdKlVdS3toieI+crumyfg0PmgwQBQqt6Bl+RP817K
	RorENKE5N7dTXJB3UZVTCACDwuwT/Q5ouA9JXbIIj3Bd81FeyKoZ6Br6+tqxDztZxG/cyv
	jA9V4Cux9jMI2H1hcJXewotT1EmCyRY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075690; a=rsa-sha256;
	cv=none;
	b=xtgdlbGjZpbIPAws/BJM8OuK0arGZfuhotF8TPdr9mkNDyuNjHMe4ZcJGSaz2Zy6FQfQE+
	z+e1y3MmJSWXgMCwnp1Lp+OM8mWHNgrStEa//BSuoW9kcg/y4shGM0QNBDOWMr9yDeWNSN
	bV2Dmogjw53ppxC6tqB+cd8UJDRbti4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=QFPqhrbv;
	spf=pass (imf01.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AFFB3402D4;
	Fri, 29 May 2026 17:28:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040961F00898;
	Fri, 29 May 2026 17:28:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075689;
	bh=4cGOsnZk0xVIPLCyz6aanH/SA/ySZrmY+G3zdoIpae8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QFPqhrbv+oq5L1Y1rne8d5SyWmyjpMxI+dd7dJ4js+CF87JyscG9PMuO6mRNk7WUF
	 jaYE94qgTEiMwV7DgMS1HfN/Jgi6wxr7xeubVwHbzytcHM55yZ3j771SFTnm/els+x
	 2XrOXiB5uCkruPJgBCUycEpExvINWTJz0lgsf6LA+jEfULuhqzSHb5iyNLWusQIhX7
	 v2RehCGHPOQznhE2cZNGWFMaJqMyeZw522xNTXD6R49ZZbzQiGoTcZ/yOSHz/K241L
	 RP5xo23DcwD/KypdcFWwJtjHCqGRkBwvzQT423SkVkxG6b2jSa4h37KrcV05didUxc
	 aVE5TI1E1FbYg==
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfauth.phl.internal (Postfix) with ESMTP id 63321F4006F;
	Fri, 29 May 2026 13:28:08 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Fri, 29 May 2026 13:28:08 -0400
X-ME-Sender: <xms:qMwZav6W1dpqePiOPHJHabISuqI9HVIKJHnfIJolqGImB2ru4-ccuw>
    <xme:qMwZao3F61ZQBhBiSvkZdnuzK7u3oPxjESkvzzTxLjH8rZdR4_iuUP0h9vhN7phpJ
    Ald4x-2bof1biSiQi6sUiDXZWvhVtpJcYai3-jHZF8qHk8nsWiFap7G>
X-ME-Received: <xmr:qMwZau8KmYIHqmBoDtXSTd81PtAi7gsmxV6mSQUo3KUGoIwBtlanfl6cmXokEw>
X-ME-Proxy-Cause: dmFkZTGahW8s3xjZ3arjCZYsPeROx1tHGGIOxZ4ZTborx5JIY1xfx8o+3Ks6DBHpwKdcBc
    M0LV7UYzyw5BBW/MLyCvRpPXH4b3j/O36w1UIutGmjGoZPWXllz5NGLuWKcGXqDNqja7AN
    LjyibA8JUH8LlxNww+LolPBmmXeffckfCMyZ3ofUE4q+w091KUDN+vWzLN57aJjrFHnLmA
    DJhoBTsevLB+L7lFnUlwKPgFqlT5AUPgwhCfp483ir0podeZjRFOwVO5acGk8d/hTIZjyE
    iTtkTrHlenKgPfeJb7TkHTrSkVle7vVdqqUtJoKJ+Cofq6CG9ZD2U9nUSpGxcnBPWB+GRa
    b0IO7F5OKS2OV+GbvbidsB1qtHMcNOoe+59ZDo6M7vz3L9A2FRVgvm4um+TJvo5fWSEW9U
    gH3jd7S3OC6KsDFT1J56/dHqFJxINl48DrpXpU1bzj2a1g/HuERh8sgT2E1m1RHDST9jJi
    s/mvHpvoIBhhOxkYWUGIRUGbh8jO6FM6EmptXydkJ15HpjpoP+vK1KttBgs0Q/TDXHgfrQ
    0puVZknNbxLOQW+QuAqTV77dwReNjNWbo6afSkdM1Ku7s9UW3OMZq82w5fLoOMP6UZ8TO8
    DV0fKnqtWOd9qz9StSvYRvO2tB8IknM5bHEO6dR9GIDcy2Cm4ocehQ6NrQWg
X-ME-Proxy: <xmx:qMwZaptyLOMzTNHfFXRyyNnfk8WXgySTcz5cDwDi14xrQDFeNIjYZA>
    <xmx:qMwZaqpgkIh5AIMl7k-MyF3Li48S0406cpg0_38ia91jUeOJzyMYaA>
    <xmx:qMwZakH2UmSvYiOMOfbpRdxBvUqDuUiHVr46x8cx8e8c1H62jNxDVA>
    <xmx:qMwZat5lbvLAI4RE3Ao2hzwTAciwxlJSPucu7y3R7IuYBEt9w3-dvA>
    <xmx:qMwZanAC0S00gBpD7wzwdkQbnCf6C-yIBKQqdg9b63CzOvslWoO9lQBT>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:28:07 -0400 (EDT)
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
	kas@kernel.org
Subject: [PATCH v6 13/15] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Fri, 29 May 2026 18:26:42 +0100
Message-ID: <20260529172716.357179-14-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D3DD40011
X-Stat-Signature: 3xdfu8rdmzkuuu5d5hwp9zykhfwarkup
X-Rspamd-Server: rspam06
X-HE-Tag: 1780075690-581586
X-HE-Meta: U2FsdGVkX19zWz8+bAapBsb4XCKt/MV4mzY/YGqPRFjD8Z/biRYLKTlymGGqccR9ZUEcjQKx9UMOL6M/rZDK1xYNShbMoNvVipiPVvkIW31E2OBGOe2px6Tm2Hjcuy5skFRXHkdraE835dVRSntxJvD4UNbvEoLvS4lvwqFRh359v2so24ecY34mD1qqrqXPMjvsCuj0WGwyf7xyyyI6UeivcskXf8QyDraYdJpvVzNCT3C9Dksr/YmhOrhWR7hFlozwG4/1pNOp4LcDzZrbQg+6GbRdwUKJRcuIwSPPESmQzSHZ8oPhCqiE7kjcPYAyWBrc90jnHCk1JB6WB6xGDptCrUsjC+Wdj0kuT+Ob663iwer6HTG+H4wjVTLa6AKxLPrd0ZwbPXjGS/QrDSwQryGwTAELrxmFxi3mGYDqpeLjJU4Y3wkuiSLIH9mppfuZnAdxU8fuiuYesq2Ivp0C4S/3JAZ9Ar82fiywvOM9FQpwEHpgjkDcFKAdyWtRaWP00qyDza2457T344jmIr80wGC9FpgMNwaJZDhfbQPQb+sXsHXNW91vqYOr8euTc+DV08piTvKN2M6LLBYc7T9yO3jZ0ZtCmtSv+iLG1nkg/unLnYzbrmx7TszCBAOHYMPzEAuIkg7hmhPmOvUjTcBzE5jSqECcFTVuVmv7SLlEsNWzwmh8q6w6HKAu/Gt6MQw55Bm2bt0D9nJa8TYGjt/qtI2O6TGT27BkxaXfZzY3bazg4uLnEoHSSGgK9bOl1bfdZqNfpC7gcncZUNvVZcU4JuRLj0gZQbwvfiid0MqyMo0IgZmKJ9tbbInLyGUhWudnGYMSlv+WHbGh996eM3sSbZjQJ511Hd9zUBDV5UJtMFdpeQOfLv+xQmFOCygA7zAHFhNyhPmRM9cZkJucnKAuHfDOjKfZGxqT9ElHem4hiQ1J3UWim1ViZUE3syFGDBApC+QNen3b3hbg9nnbCyo
 utq8oLWs
 CZVQjoa2AC87l85OLt082isppfqimlPBejs1JYSOKLtcMielCebDAniaomZdiQ8JFdU5qUfi/47zNQ5jjfKr+Ub8Rf3j50yiFgxy7WuZ5V4wYhO0YNtRpBzzGDQ+ldhHwzPYWHQdcWyudFVK3pu1fDvkvdHApM2eSrP5Q6TUnYhETD6g0VopSWMCvS9AdInlnRP7s+Al0sSuY+CeLAf807CbF1L3pcZHM9SZan1H9dijYCrF+kaP964He8nenBZpLsN493DRa62P+fyIBGimvsHKkcpyw/fncyh9Syvg2NXY6yohnrq6PAmOoLZwUq0VIUC8C6UyplGd1OW4=
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
index f40bf473a6f6..f172ec14a6c8 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2477,19 +2477,29 @@ struct userfaultfd_wake_range {
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
@@ -2504,7 +2514,7 @@ bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	if (!ctx)
 		return false;
 
-	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
@@ -4290,6 +4300,109 @@ static int userfaultfd_rwprotect(struct userfaultfd_ctx *ctx,
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
+	    !(userfaultfd_features(ctx) & UFFD_FEATURE_RWP))
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
@@ -4528,29 +4641,7 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
@@ -4620,6 +4711,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_RWPROTECT:
 		ret = userfaultfd_rwprotect(ctx, arg);
 		break;
+	case UFFDIO_SET_MODE:
+		ret = userfaultfd_set_mode(ctx, arg);
+		break;
 	}
 	return ret;
 }
@@ -4647,7 +4741,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
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


