Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 516D5C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1AD56B00A2; Mon, 29 Jun 2026 08:08:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACB456B00A3; Mon, 29 Jun 2026 08:08:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 993576B00A4; Mon, 29 Jun 2026 08:08:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66F3E6B00A2
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE9CF1A0692
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:18 +0000 (UTC)
X-FDA: 84932827476.06.E03F660
Received: from fhigh-a7-smtp.messagingengine.com (fhigh-a7-smtp.messagingengine.com [103.168.172.158])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC94020004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y RNotyV";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KLzfSTEp;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734896;
	b=z8LmWozamTyKkHkftoY47eHI13agGL04SKqy6TdA4JpZybakKT7iMzp9p+vvAusxUhUqkK
	WFfJHpEDO7nXb9N2TX/jIKEeXEhh5+026laqvUswzI4TsqBesRJSYakKNrsbjGibcXeeG7
	Ni+58XK1h/yblQoy5stk3je0RqY+p0M=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mdxUu2oye/uPbhzvJowyuT/K3tsRfsLqm46GQayd71E=;
	b=15uRWcmI8nuX/GxHVTygCJvLaBff+mgFgBXV3qdEWlgtl6yk+3sMt7cWtGr9ojoCykI+BX
	CMknbY3rZapzXbWSDBay2xIK41yXSOohi2hfQL1nD9XWDXjf50bXBHI+bN4/L7ycWwQoOL
	gr9YOFS7dpm8OQo2qRMVIGfQH2oPkRk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="Y RNotyV";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=KLzfSTEp;
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.158 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5F92914000FF;
	Mon, 29 Jun 2026 08:08:16 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 29 Jun 2026 08:08:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1782734896; x=
	1782821296; bh=mdxUu2oye/uPbhzvJowyuT/K3tsRfsLqm46GQayd71E=; b=Y
	RNotyVTn7H1lQxaOWU3ttjJHYAG4DEAhQB7+3qx1z/4+Q+riYk5ED9V4prPsMeWX
	DdcudHDJFF/VQhB6Wm7caRShlqzk/VcqciMbXl8yTetHK/5U/K7xrcT4XoZDVCDV
	4IQTK9HSTEj4bN3yO34+0lEO6FqO3UqdlfNURNsAnMcTY7RkYkXB+SpJOXQmOeyj
	PUi5j2C94mHFAYLoXcHK0LrVd5oJXUeY6XaGDwKJAUm8TKFKC33d2WH1puyeMieB
	zNAvxOdAGsGIB/HYF6foRHC181TPFalEmVDikspoR+F90FGv29ZdeK+X+QDqAXdF
	lIMLJ+Cm6ZDlEnYGAWqvA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782734896; x=1782821296; bh=m
	dxUu2oye/uPbhzvJowyuT/K3tsRfsLqm46GQayd71E=; b=KLzfSTEpAiPguFnx1
	Vu3KnrXGRYC31GeE85aXIlby7csdo9un14Whh6CJF8egFn9mrtU+Ksq95cpR3N6w
	kXi1EZ4ENfQPO+uCcKYt+GH+LSDITYaglDmXzNnTjRGrtQZVfL0qEJvLeKWzSRgN
	WziLBonnqeLIVa7lEsmrFXnT1BodmjPFNhpl7FmbTaFBISU3pNsCrFUlvWw6GSsP
	OgsdOiHYQj0RtrStYdB1tOr3gglwEdox0CFsiAB2cSkl8cG+g7iYUKAn2wrQr/PU
	eSuCyO0zCT9npxxHq7LlwJRHDwv5Y/xRd8V0jQjeF7euC5RUB6eXZLzulUt1ymSF
	u1Bfw==
X-ME-Sender: <xms:MGBCagY4Gq4D53_CQCbsAwQSR8EgVrlPPeQlcr_fCghLSP_dYLMC_Q>
    <xme:MGBCanR-xNGkVTn1wEWYWYM-dsJ_Yi2zQgJP3GAvvrGYiKVawOVgz2ziEoi4lt96h
    67S1U3t3aRiS-wUccIg-glJH48Jwp4QU5DjUs2HnkSqKv5Wo6w5PeE>
X-ME-Received: <xmr:MGBCajwgEnfDHRHLuJ92y6LnvzeD0IWr_VdElZTPyywp9CG__roMlgJ7zYVD5Q>
X-ME-Proxy-Cause: dmFkZTFY6shGePvmxOMh2n7JXpRvMYayhSPkReA/qp2Kk9FFh7qIwqznFdabTWQQmbT6np
    orb7nZimraCt1e9FjxE+D963WQ5XDZfLTwLobafoyB3i66gOkO3z85tAcKnmI3RB25+PVB
    EZ98eAuca1GkEm7XR3L2jnIB5DGE7Gq/dUpvQ2A9oIHx8hwh4f84uT4y/OhQorrh2fKXDR
    UYo9Jps0lppZOy2xiKorTonIMZqLK9GUCnCQcdTCD/z+aL3OihCctiT9iWAjf4SCGuOWH6
    0ORm+HxXgzRDvylsCh2WOkVei6ivCiAy/pOXBTW6wB8gDyVJ0wFaPNiIhLc7QTSUTVd0Es
    +R7bad9Z8NpvLxHXaghkQobBJyVXLTwAJEQaGU8+h/JjKroCjxjvo39z2Zg0H7DCf+g1fy
    eRM2LqR6vksWBBZtKCH7XpZFTPJR+1S5lGHrECc9QLO69YJ+H66WgSB1CYXWzdo5PV0ogb
    Ss1deWNrxyyeLcEQBwXTAQ5iSaRX6SxBnLWv5KHq9pZvA4jp/lBYm2M3IeMjCqgGoR1NdQ
    LdBr6bqtYn1dVujCQXDWRgfbXaJU2WOmzOL6kzJGCmgn+hcuAONhBvg+q14vvDvn2QSinM
    dwi/j4c5Pgrqf78MiLID8MTR95aZDIDQjocW+b81UbsV39siFoE9/AUhEYyg
X-ME-Proxy: <xmx:MGBCajf0xYmuEJyPZlrMYMAamivdp2illrMvJCdKkoEMdhe6xv3Y5A>
    <xmx:MGBCakp3r1bQQ5UYtCY8IHQifc6N26sLACmyvcW3rIv7ulSdCrJETg>
    <xmx:MGBCarNsCwIG6X5HlHeANoCNdVTiqHZeAiF2JAbuUIaGqRAf0VgNVQ>
    <xmx:MGBCaiFJLOp8im6Zl9SjWDJiBoCa6FDpG__Rf1xXsM868YEn6VRPyw>
    <xmx:MGBCairnlKDnKqXTnHWauoaLhPcqGBAqMCsKbI6OenUHyTfsJij0IwFP>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:15 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
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
Subject: [PATCH v7 13/15] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Mon, 29 Jun 2026 13:07:44 +0100
Message-ID: <20260629120749.566063-14-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DC94020004
X-Stat-Signature: izpj8i87tuj8m35eydjuss18w19ekd85
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782734896-545249
X-HE-Meta: U2FsdGVkX194hLNjVrLfyM7aG4icJjuwqfDMQVqCSnt7Im6jYxwaK1UgWfeLLWfyicTynOInHfoTuI/Lc99iY8ipfVrVP5tcTTsuS3mmxMu1fV65bkLovrIvRbbuy0q1lx8Tx1F1BOEy2T22P+EUx3S5sYBf7MTSOVnzpyyir67axqRjRxbl6v0Hf3U8rz1UfB19mLy1QuIm93pt3vpgkdqQtWqcAr5hYHngpUx/pcX66cTWt9M0m1aZ/M+T9F3Jrcib00WcWe71tsnmWyn+6LQ+hZLWeQ/NJ0QFwTNEKi1ysLbkjXRoZI7+5IRbYtO5vq3nzaYMO7YJGYH4qlSXy8a8502rks3AW05cMi+awHDo4SPZGuNj3xoan32EhKDGPLYpVpXSiVSbod20ouMVNy67SBDVlqLw943nSw8WNSJGKkk8UKexIvVlHX3aw0WqeOoAAFpSlK9Se3mSBz1DTPruQUkyrOCsD62JBk8Ldatnmq2aeCgvLzw/7+OJnikqIqU+cr6MxVcD4jwdC7TwCHCYSENRYx3h8bfFqez6MSuOpuOUV8YJfpb5bGk4zBQV49G5q/BM1ZXmBBjWXj+e6Jvn0rnQST2omx+46WeSak3Ymb7hBY4v/hyBLzEnV/Io2G9149idGbciwDAPproojZUH3pqGwJOL5h1DMDkO91QAZVebmpWuNGNipgnkwFG0IWo18qdt5ZmH1g5XA2qP/hyxraGRyMQlD7hty38RsdJ0+aYenlXESAdlUuzdV33Kw8KqhqPosVPAaaQn6kXErlHxwhPqIJXICRQ5yvIbjSnIBc272tIVKPjtioYtVpPrALDt8YW2sKnPdG5XLBtg2bY9rxttv66RHymYwtZ0MYGS6MeuAt+Kq5CQ6gQWhpPh1+ulkIVRyOp6qTVX3ARWyrwaUUu+B8xFCAvO+QFhe8UkE9sF3ysQzFORi81ASy4lQT0pUsaAkxS3sFwk5CR
 im4VgLFy
 +Sv4x3paZygbACsSbF6te3q8VcJpehc/3l2IFajXuDdxAgv2zKlXXCbDX9KgjNdmC6kFMqFCeHN4TI0ziOGo6Xf73dxWWTpMw/O4PWpbIfhZdV6US9As7ubX26tli2WItaxLb1dp+rJa5fBcgEsklg+FYrPmrEN9kDHkTSTpq84R/z6PVgcf0LSaj+EVGODyOqpANSdjKHjnH4zHWfeLAj1OPZuAz8+IMnQPuJGqXKxcl0K8cFq5izDJWki6ibTv3mQJ3ORBJtQF+tYvbJ7YGFM4ylvEcSeZC0ba3SI/5kdxLJXhs2BN7Qpxh44uHceKNfLEL2RoUfcbjnYQ9awvtl16cBBKtSrTnlYvxx8EU0TLM9HXGRCJtsD31aqaQwClEsdAHRNBbaYVL+Pv0xvb2SXFyxmwE1YUTSr5edK7FqA2SX996atmICv/IqlI+S7iyBv2u7rPkwDLlVTHrj7Q9H4Htne/2D4MB4M/flJ8ZfnnVENMGizQyUSAfHGTRzzwi7Z/gWVKZPTaWC0g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

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
index 1a3504c63597..a7659b0a1147 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2484,19 +2484,29 @@ struct userfaultfd_wake_range {
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
@@ -2511,7 +2521,7 @@ bool userfaultfd_wp_unpopulated(struct vm_area_struct *vma)
 	if (!ctx)
 		return false;
 
-	return ctx->features & UFFD_FEATURE_WP_UNPOPULATED;
+	return userfaultfd_features(ctx) & UFFD_FEATURE_WP_UNPOPULATED;
 }
 
 static int userfaultfd_wake_function(wait_queue_entry_t *wq, unsigned mode,
@@ -4297,6 +4307,109 @@ static int userfaultfd_rwprotect(struct userfaultfd_ctx *ctx,
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
@@ -4535,29 +4648,7 @@ static int userfaultfd_api(struct userfaultfd_ctx *ctx,
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
@@ -4627,6 +4718,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_RWPROTECT:
 		ret = userfaultfd_rwprotect(ctx, arg);
 		break;
+	case UFFDIO_SET_MODE:
+		ret = userfaultfd_set_mode(ctx, arg);
+		break;
 	}
 	return ret;
 }
@@ -4654,7 +4748,7 @@ static void userfaultfd_show_fdinfo(struct seq_file *m, struct file *f)
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


