Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54ADDF9D0D3
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2596B009F; Tue, 14 Apr 2026 10:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB496B00A0; Tue, 14 Apr 2026 10:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EDBCF6B00A1; Tue, 14 Apr 2026 10:24:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D418B6B009F
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:18 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97C908BE92
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:18 +0000 (UTC)
X-FDA: 84657381396.06.8EE7D6B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7C67940015
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1DIGAsn;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176656; a=rsa-sha256;
	cv=none;
	b=O2UBcFLoMqGo6h6V6HgrdAynNx7mQ/ZiICSJkEEzeJMqvahesV9JQR0mWnWNBb7lu/tQNR
	fBnjbmNiXdiyR8WvVdiTe9qgIKGql9UctTh5NE71k0OUr+5CmX4Kp9iobsdwO3Qvvh6QUA
	fhDXckilUQjSsUPzZPbbZdeywFm/dm4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176656;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwg7u+diSak834m4Y/znpPYnMYIf/W/Wji7e4ZNzbkA=;
	b=0MaOIEgHmQlMZVDyuiTUUDs/YryviFYzylbiQXlspzRgijNgaD63RvGW4JMZkFeCQb71nB
	YMVNtdYawnLje1CcTDc0qwsyvWo63DLfB8Embd7uBQp76X/YD9QcL2qFKGVeRnsO8/xNpw
	PauSVQgaori4JlWbVxXdBN4Q9DO7KZU=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n1DIGAsn;
	spf=pass (imf11.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A94034457B;
	Tue, 14 Apr 2026 14:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F5D7C2BCB8;
	Tue, 14 Apr 2026 14:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176655;
	bh=wU9XhAWdOkm2epOMZqX4k9UHuR2i8O/RDnn4cDbflLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n1DIGAsniyY8vj4+mAakxpkv9iBsInZPGyST0/WXXjMQGAuCTtS8/cmieVr3Ye5Ul
	 rF6mcAKzF684kHK2IctebHCD8ljK9Tv2VFCyG7oSLj1PAGSJbN/gvuIWuE/aYe8iJP
	 P7fUpR+L9IXRzv16wGuwtf7IFh5r6lQCx6AMmIlgF8Q0Lj8c2hdTI3/q4tfckAqL4i
	 p2K6ICCBx6Rri0H/Uk8AhigoALkVc4ZBFRbIqXB2Tw23ajt2XK3+sGk4QQFD7BXWS4
	 PPHbcFBvo3JNfaj7Wku9j0LGRhHmnF3e8aH55BCFY4Qg0TGVUfKVBB8wyn3g9c6zu8
	 i6nJt/in9MD6w==
Received: from phl-compute-06.internal (phl-compute-06.internal [10.202.2.46])
	by mailfauth.phl.internal (Postfix) with ESMTP id 421D8F4006F;
	Tue, 14 Apr 2026 10:24:14 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-06.internal (MEProxy); Tue, 14 Apr 2026 10:24:14 -0400
X-ME-Sender: <xms:Dk7eaYqI27hsNvix2EPZxKVuvcYdoPuEppH7El0A6dfwJ6sLPvumYw>
    <xme:Dk7eaVl8QJKm5Gg4FHtOxm7VUZUoqBRHyGs-eG00kdOTPUoadqPBBaz84ExolXrpS
    ybwi5Xla3zUi57zYAgsah3tun21RAmEJrF1Eh8tloIa_-L7GO244gs>
X-ME-Received: <xmr:Dk7eaSQ6KLe9DBEXvv7zUze0hStzZpwuck1YZOzwuCgewegYvcM-QRB3RsXVww>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpedfmfhirhihlhcu
    ufhhuhhtshgvmhgruhculdfovghtrgdmfdcuoehkrghssehkvghrnhgvlhdrohhrgheqne
    cuggftrfgrthhtvghrnhephfdujeefvdegkefffedvkeehkeekueevfedtleehgeetlefg
    feevveeukefhtdetnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepkhhirhhilhhlodhmvghsmhhtphgruhhthhhpvghrshhonhgrlhhithihqddu
    ieduudeivdeiheehqddvkeeggeegjedvkedqkhgrsheppehkvghrnhgvlhdrohhrghessh
    hhuhhtvghmohhvrdhnrghmvgdpnhgspghrtghpthhtohepudelpdhmohguvgepshhmthhp
    ohhuthdprhgtphhtthhopegrkhhpmheslhhinhhugidqfhhouhhnuggrthhiohhnrdhorh
    hgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgtphhtthhopegu
    rghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvghrnhgvlhdroh
    hrghdprhgtphhtthhopehrphhptheskhgvrhhnvghlrdhorhhgpdhrtghpthhtohepshhu
    rhgvnhgssehgohhoghhlvgdrtghomhdprhgtphhtthhopehvsggrsghkrgeskhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheplhhirghmrdhhohiflhgvthhtsehorhgrtghlvgdrtgho
    mhdprhgtphhtthhopeiiihihsehnvhhiughirgdrtghomh
X-ME-Proxy: <xmx:Dk7eaXBRQxby81eJQ09tIpX5wnaqAWdYU9yTBINeIx-4Voth2bS4Cg>
    <xmx:Dk7eaSpBc0PsFsAeRHo6gQptwun0PvtIEjUBNtK1NHywsoSAgsZoHQ>
    <xmx:Dk7eaVhSKEC35Fqwid3zGuX0_-Sy0RNp_Xl-uhts-r_xtg74dNxszQ>
    <xmx:Dk7eafxnkvdJQBYXnFFycV1qd9HnMMH6h18AfVl4GDhb-NEUs3Brmw>
    <xmx:Dk7eaTL9FTMXqSC84SYr7DyvLsWGLK9jQdMCbnVbmbk5lOdtXjAk1YMp>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:24:13 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC, PATCH 10/12] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Tue, 14 Apr 2026 15:23:44 +0100
Message-ID: <20260414142354.1465950-11-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 7C67940015
X-Stat-Signature: r7wysn6mfskhp3z3tuc4b9xqke8acqwo
X-HE-Tag: 1776176656-587511
X-HE-Meta: U2FsdGVkX187zxO6WJA5WZk3m8qNZeN23XMH/UeBKZc4LTkAeQOvpn0bwom6Su/eLgnlweHBFLwTfe8sElqmokXl+HmSald676Y4iMJ+7ONeYTPhwB7KUKo1jfDJt+k13NrpUXemNoSLMccsKOZTbYoV46T+Czm0pTV3lyOexCnBp7cr5Yp2t79y71xUBEYUZHC6Kc8/MLT6gudg2VcuFcON7sDNWo9uP17snRgKmOwnwmJhCWQh8/DaKjYkL8zfiUZeaIOItgi/rL1FhkoRFcuxD/xdGMObxP/QtcwrY6OmHB/7MbBuZBkrhkVRpIWrd4TeFUwp+JDDExGhLnpZlDAc9JB8gh87akRacIRSPhYDgUc9fU+J1Kp/scE6QN5qPa4Canf5t9O7kxr87UiTJob2VgsEyRDOp/BpvEv+wf31VxrIu2jGB9t2L/tMqDCHsuDou9f6zYbltTt75jhHFj3+j+JMGsFVaLMUN3b4S+DMbqU8//sDxK3opGEAvdiq8lkDbA53SLEmjX2iMlObToBMygT1Sf0qAWZtCePfCXF/RyJ+BmhQHhO7Ml8uuh95PPHXYfOGCVf/oOj2wMnukiRtpjpscLOTuHPjiWBL2L14lXVC/htIEXc3njoUY2Z9os43tBpBFGJGQ+H9aeVF/+T6wyeyPucJVtIQbAiNm8rc8scOU1RVt/8EX/+5pYEzWqcKVHX/uw8azgYEBghjmp04dZ7y1K4osWLhqoXBZVI6M2xXSmCNNVNrTHqPv6JanCijZCJq4lyr+3wh/3za30zkgXPuoRXiqtnYcikVGZS/dfYjxSGE/owZ4cpbuuozM8QneKB1V7/Dv56oi22SxWORILqoRd/MIsKe5wfKUKaAdXGsyczhnjaonlbyoCmmjYiy0j2eRtexrCrtZmBiqkhrXXT4Tp6qRGFP+2llw55o8ouIAXsot8nMxsSbXejxzaBA+0khB4YADLakf66
 AzHxQeEf
 rwXztim1aumIgx0MsUs/FjxDcEgka4YFKiXShItZ/wMZBp5q9s3tJRV/LhbvO5gvpAYFBkenTCrfjpuIaa/DexGFihJiepbCV5QtRjQ9QYQPd/WY/65H/QgW3nq8zfFC2BWBUF2JRHAefxwZaJjggxViFcZy4DLF1Snsco4cJ73gfBRzGiVHfcsylrpfor7HBJmlMXKfO3kvCULSq+pruMOmY93VXDILFjfiQ4W/NS4ITGMsiHr8uE/Zxt9NgdzoZ6Us8o0HSL4FcNCWR74WihoADNmTMVeAkqbrstdelmUjKK8KVTz6JdDlR5bywcGUC2IQ9O+/0gsxssJg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add UFFDIO_SET_MODE ioctl to toggle UFFD_FEATURE_MINOR_ASYNC at
runtime. Takes mmap_write_lock for serialization against all in-flight
faults. On sync-to-async transition, wake threads blocked in
handle_userfault() so they retry and auto-resolve.

Since ctx->features can now be modified concurrently, add
userfaultfd_features() helper that wraps READ_ONCE() and convert
all ctx->features reads to use it.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 fs/userfaultfd.c                 | 95 ++++++++++++++++++++++++++++----
 include/uapi/linux/userfaultfd.h | 13 +++++
 2 files changed, 96 insertions(+), 12 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 43064238fd8d..0edb33599491 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -79,24 +79,33 @@ struct userfaultfd_wake_range {
 /* internal indication that UFFD_API ioctl was successfully executed */
 #define UFFD_FEATURE_INITIALIZED		(1u << 31)
 
+/*
+ * Read ctx->features with READ_ONCE() since UFFDIO_SET_MODE can
+ * modify it concurrently.
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
 
 static bool userfaultfd_minor_anon_ctx(struct userfaultfd_ctx *ctx)
 {
-	return ctx && (ctx->features & UFFD_FEATURE_MINOR_ANON);
+	return ctx && (userfaultfd_features(ctx) & UFFD_FEATURE_MINOR_ANON);
 }
 
 static bool userfaultfd_minor_async_ctx(struct userfaultfd_ctx *ctx)
 {
-	return ctx && (ctx->features & UFFD_FEATURE_MINOR_ASYNC);
+	return ctx && (userfaultfd_features(ctx) & UFFD_FEATURE_MINOR_ASYNC);
 }
 
 static unsigned int userfaultfd_ctx_flags(struct userfaultfd_ctx *ctx)
@@ -122,7 +131,7 @@ bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	if (!ctx)
 		return false;
 
-	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
@@ -435,7 +444,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	/* 0 or > 1 flags set is a bug; we expect exactly 1. */
 	VM_WARN_ON_ONCE(!reason || (reason & (reason - 1)));
 
-	if (ctx->features & UFFD_FEATURE_SIGBUS)
+	if (userfaultfd_features(ctx) & UFFD_FEATURE_SIGBUS)
 		goto out;
 	if (!(vmf->flags & FAULT_FLAG_USER) && (ctx->flags & UFFD_USER_MODE_ONLY))
 		goto out;
@@ -506,7 +515,7 @@ vm_fault_t handle_userfault(struct vm_fault *vmf, unsigned long reason)
 	init_waitqueue_func_entry(&uwq.wq, userfaultfd_wake_function);
 	uwq.wq.private = current;
 	uwq.msg = userfault_msg(vmf->address, vmf->real_address, vmf->flags,
-				reason, ctx->features);
+				reason, userfaultfd_features(ctx));
 	uwq.ctx = ctx;
 	uwq.waken = false;
 
@@ -668,7 +677,7 @@ int dup_userfaultfd(struct vm_area_struct *vma, struct list_head *fcs)
 	if (!octx)
 		return 0;
 
-	if (!(octx->features & UFFD_FEATURE_EVENT_FORK)) {
+	if (!(userfaultfd_features(octx) & UFFD_FEATURE_EVENT_FORK)) {
 		userfaultfd_reset_ctx(vma);
 		return 0;
 	}
@@ -774,7 +783,7 @@ void mremap_userfaultfd_prep(struct vm_area_struct *vma,
 	if (!ctx)
 		return;
 
-	if (ctx->features & UFFD_FEATURE_EVENT_REMAP) {
+	if (userfaultfd_features(ctx) & UFFD_FEATURE_EVENT_REMAP) {
 		vm_ctx->ctx = ctx;
 		userfaultfd_ctx_get(ctx);
 		down_write(&ctx->map_changing_lock);
@@ -824,7 +833,7 @@ bool userfaultfd_remove(struct vm_area_struct *vma,
 	struct userfaultfd_wait_queue ewq;
 
 	ctx = vma->vm_userfaultfd_ctx.ctx;
-	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_REMOVE))
+	if (!ctx || !(userfaultfd_features(ctx) & UFFD_FEATURE_EVENT_REMOVE))
 		return true;
 
 	userfaultfd_ctx_get(ctx);
@@ -863,7 +872,7 @@ int userfaultfd_unmap_prep(struct vm_area_struct *vma, unsigned long start,
 	struct userfaultfd_unmap_ctx *unmap_ctx;
 	struct userfaultfd_ctx *ctx = vma->vm_userfaultfd_ctx.ctx;
 
-	if (!ctx || !(ctx->features & UFFD_FEATURE_EVENT_UNMAP) ||
+	if (!ctx || !(userfaultfd_features(ctx) & UFFD_FEATURE_EVENT_UNMAP) ||
 	    has_unmap_ctx(ctx, unmaps, start, end))
 		return 0;
 
@@ -1826,6 +1835,65 @@ static int userfaultfd_deactivate(struct userfaultfd_ctx *ctx,
 	return ret;
 }
 
+/*
+ * Features that can be toggled at runtime via UFFDIO_SET_MODE.
+ * Only async features that were enabled at UFFDIO_API time may be toggled.
+ */
+#define UFFD_FEATURE_TOGGLEABLE	(UFFD_FEATURE_MINOR_ASYNC)
+
+static int userfaultfd_set_mode(struct userfaultfd_ctx *ctx,
+				  unsigned long arg)
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
+	/* only toggleable features are allowed */
+	if ((mode.enable | mode.disable) & ~UFFD_FEATURE_TOGGLEABLE)
+		return -EINVAL;
+
+	if (!mmget_not_zero(mm))
+		return -ESRCH;
+
+	/*
+	 * mmap_write_lock serializes against all page faults.
+	 * After we release, no in-flight faults from the old mode exist.
+	 */
+	{
+		unsigned int new_features;
+
+		mmap_write_lock(mm);
+		new_features = userfaultfd_features(ctx);
+		new_features |= mode.enable;
+		new_features &= ~mode.disable;
+		WRITE_ONCE(ctx->features, new_features);
+		mmap_write_unlock(mm);
+	}
+
+	/*
+	 * If switching to async, wake threads blocked in handle_userfault().
+	 * They will retry the fault and auto-resolve under the new mode.
+	 * len=0 means wake all pending faults on this context.
+	 */
+	if (mode.enable & UFFD_FEATURE_MINOR_ASYNC) {
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
 
 static int userfaultfd_continue(struct userfaultfd_ctx *ctx, unsigned long arg)
 {
@@ -2150,6 +2218,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_DEACTIVATE:
 		ret = userfaultfd_deactivate(ctx, arg);
 		break;
+	case UFFDIO_SET_MODE:
+		ret = userfaultfd_set_mode(ctx, arg);
+		break;
 	}
 	return ret;
 }
@@ -2177,7 +2248,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
 	 *	protocols: aa:... bb:...
 	 */
 	seq_printf(m, "pending:\t%lu\ntotal:\t%lu\nAPI:\t%Lx:%x:%Lx\n",
-		   pending, total, UFFD_API, ctx->features,
+		   pending, total, UFFD_API, userfaultfd_features(ctx),
 		   UFFD_API_IOCTLS|UFFD_API_RANGE_IOCTLS);
 }
 #endif
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 775825da2596..f0f14f9db06c 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -84,6 +84,7 @@
 #define _UFFDIO_CONTINUE		(0x07)
 #define _UFFDIO_POISON			(0x08)
 #define _UFFDIO_DEACTIVATE		(0x09)
+#define _UFFDIO_SET_MODE		(0x0A)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -110,6 +111,8 @@
 				      struct uffdio_poison)
 #define UFFDIO_DEACTIVATE	_IOR(UFFDIO, _UFFDIO_DEACTIVATE,	\
 				     struct uffdio_range)
+#define UFFDIO_SET_MODE		_IOW(UFFDIO, _UFFDIO_SET_MODE,	\
+				     struct uffdio_set_mode)
 
 /* read() structure */
 struct uffd_msg {
@@ -395,6 +398,16 @@ struct uffdio_move {
 	__s64 move;
 };
 
+struct uffdio_set_mode {
+	/*
+	 * Toggle async mode for features at runtime.
+	 * Supported: UFFD_FEATURE_MINOR_ASYNC.
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


