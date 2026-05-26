Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 152ACCD5BB1
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:06:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3F0346B0099; Tue, 26 May 2026 09:06:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 355626B009B; Tue, 26 May 2026 09:06:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F30E6B009D; Tue, 26 May 2026 09:06:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0AB276B0099
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:06:04 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D32A51A0418
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:06:03 +0000 (UTC)
X-FDA: 84809593806.10.46DB586
Received: from fout-c3-smtp.messagingengine.com (fout-b3-smtp.messagingengine.com [202.12.124.146])
	by imf12.hostedemail.com (Postfix) with ESMTP id E04774000F
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:06:01 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Q 4wLGDE";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ew91eedb;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800761; a=rsa-sha256;
	cv=none;
	b=BjJxQnONw7FA/7BL4GlVdly6RQxPZ1jw9QcmeEdoJCRUpD3MPXYOy+xWGdyBAfhb4QZckt
	dCIitAbZZ6l3mErK/hq9T1KFdqPpJaJSWBdU9pOrMPqbxLocyEDilPwIyM8dz+Y8RZK8IJ
	l1NMbZVdVrAMa6sbLX8SXzKAgJBaK5o=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="Q 4wLGDE";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=ew91eedb;
	spf=pass (imf12.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GacYIKsvEC3Q0G1cEeb4eXR0U11nh62L+pkNkKxBJpI=;
	b=xGKeCK7aTJmtNVfQkHbRa2dtXJF85ls06Hrywp/XUNC3E3J8/XhPyUoDCzyKnPJAho/AK0
	McrUW9Vj0rylZLV+OfkyS2WpfbkE4YV1F7MM5+ucTybhy47a9Au35us3Z5nsD3DDLRYNjf
	rrgAppGHLRGTorXk1vR6nhJrhBktOYk=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id AB6101D00137;
	Tue, 26 May 2026 09:06:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 26 May 2026 09:06:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800760; x=
	1779887160; bh=GacYIKsvEC3Q0G1cEeb4eXR0U11nh62L+pkNkKxBJpI=; b=Q
	4wLGDE0XMixu2WxHKxn7Cm8xuYKFqaat8Kj+JE+/HUbQGwUZts83X5c9tcRDmxLv
	IznhyyD7EI8xqzNg775D9LB9GVibUdBYVnN0QRjJj0d19BS9iHIHPiR0tOPZFb45
	H4LFTH8OrI4Z0l03UBfii32PfTLZKOX1DYf1WTGyC1+6KSTNGbjiU3Izp+iboW0e
	1gXvkgHJFc091o/vjEwbni6RKSf5EHIf/zZAtyzH7CEbnjYSufTSzqvs3N3antBa
	0ivuiLpkDkvQ1qrHrAT4/fteBMd5ML8IqH0137xOD3Ll39YeqQYqRr/qvQzAOGXZ
	TmHCwVXZIJdiUf8AYhWLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800760; x=1779887160; bh=G
	acYIKsvEC3Q0G1cEeb4eXR0U11nh62L+pkNkKxBJpI=; b=ew91eedbQJG4DdDQH
	aDBaNKfQQ7dczaGMtRwncBf1OxMQ7aDsNJbWdplYyKkmBQrW56cRE3n0wGF7IvzC
	6IGgY/TquYm/X9naofh74WcCf7cf3Qwb5utRQNO7Q9E1acO7kdt4MVzYeKmGQuLC
	q0aFkqFkjUtjlJUfgjGf6iBPjqqUxXI2ZCyuBuE/FV1AM2K6QcvenIxN2uw1p3M2
	mPVW4NhKVez8rofkdjcMYyAhZQEG7BzDgsy23ObDghk3oEPgdvZ53vpu4vYwc4Wz
	SjtW3CFN+Rm/jTZeKE7sajzsIWcqSnyEhpGpB9aKYa83g/rd6yJ1M/S6PQ0lxlnO
	Ndgxw==
X-ME-Sender: <xms:uJoVathDs_OeumwUtZW2PpKmke4818Z0zsJl3AidxjX9xgnfYKRt5w>
    <xme:uJoVal86knvezYJnMD7vmOY7Yv1P14RPcWIH8kJd4yHxuufAGebcO1xpxjY0LrVvf
    3MaYpNEUan7mwa-GmoJYbHruCF0p6He9pLWjCT3eHtndbKo4ryzgZM>
X-ME-Received: <xmr:uJoVall0BXipnsPI40bjS4wnjRkm9rbpmcucw_lS1Xbk9HQQv7Q1uBNcX1P1Pw>
X-ME-Proxy-Cause: dmFkZTEJiC033GhjL2GdnX/sXIn31a6xYH9Q9kJLS3tMsbkgwO/cImnHqXQKfEc55wOLx4
    i2tqVUZQjDS/XsxdV1Neul2ks/uVgINeMKnTDgBTDd49K013fUhaa7mbXp5KOF+CzusOdT
    UiYD/yezdXIvKfe8z5w2tcDXcgJNRSU5eSwZFLQl4UtnpivyD/d0gOKuFq22BcEw4tqdAi
    ZrLfx6gsOEL+8JLB9yUFNWntFWViMy1Q2hMU0QsTFycK4r8MnF1MjvTDo2QKxDh/PpEdKA
    ZnnGzw8DPiuoI+QbA8cmDBSDEJ+Eojxn1EXRLRmRJNLXOxLbY2LwfoxO6aBp6BbF/3ouAV
    +rtH4r1JZbSnpOY5yE9tRPk1Hf2qqFNV17pMimdGxS0WJ3e9vVWWBY0OhpskHqwuc58Q/H
    c88Z/36lFToSrmUzOzYQPXAz042mFSuRSJR03wCPSDvZuE74YShMvkkUGfyynvupd6D1j0
    lqPpgLnubsUDEZywqaFQ4fP1K9nyQ7vNxJUG36180U/0iZssi5sfjTWzv1W9oRpU5JvzFT
    mHex9P94YPFqBQUPxjSe1NxFfXNob2HrZj/btLjiMFvusBZp5jbZOLPxHoP41BinZPdTv5
    +q3fjPHduTRpB2hTfs9lXf/ThqnJ9M+7rq0upIV0+dZ5IIGjE0wTjaKcbA9g
X-ME-Proxy: <xmx:uJoVar2QwuJkXP7qQR6SOn9w5bFfp3NZqtNgFOnj-vDO81qcFSSJKw>
    <xmx:uJoVaiTB5X3g2SJ21V3P6V_ruf-YkjeBj7ZFhzi0Pv6P65aeOu-QyA>
    <xmx:uJoVajOm0kog1TjkrKq01is82bsKm9mgyW3JePlie3iLLUeipIoT6g>
    <xmx:uJoVaui7992MpHgYklA5GHqLDfo0-C7a7rbk-RgwVs8wXoncchrL3Q>
    <xmx:uJoVajg3JEvzlg09_FMy-edSzsX9YXG7nFdW29gaOHICBzceMkSt6dCL>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:59 -0400 (EDT)
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
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v5 16/18] userfaultfd: add UFFDIO_SET_MODE for runtime sync/async toggle
Date: Tue, 26 May 2026 14:05:04 +0100
Message-ID: <20260526130509.2748441-17-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E04774000F
X-Stat-Signature: 3gdd7k71nzhz5rnhei1nats9gk394xd8
X-HE-Tag: 1779800761-909356
X-HE-Meta: U2FsdGVkX1/02/BQtz0OLdcD7aD3cwsHjPnEHDLpmh9mZVpkYwj4k0PeNTwe8dNb7EFWt9m+smq/0j9tI9RepbcYCyjAOGvrrnFwGNJyWfL824w6H+FhaVVxl9+oa5OvJ/hYCTInp0pmllPythLcp+PxXLfWY9godZpLsQM3E/Otrm+5j6unz7DXIxIHVFRR3z3ChvECELgLAN0YyxQJ7wsfrOs8qZYKIok6SZESeTZ+ZLJu31qdYph/bRQRtUq9iTZ+sFedpOAHbghZPiR2t/+j7xYqTaewwsVWy53+Pfsi1n8ecG5i1n3U63WzOEwfWRAeGnlXKXn1bN60w1tJvmG4+pLKihVF/NsSMx93OUXOnWXC+iXuh6a6qeX5QkK+1YYpODpPp+EKPnvGK77HCQIoJji6MCz7RZAgJtl2zMeAuvWJ6v9ShpvsU8Yi4sY3B0RzOoG5sDzJmgQRVxqkEaBYxYplV78mvkuXam7Ac+aGvPIsUVjAHyN7kDyNXU7XvdSGoQPEDCMvljUh1hAPlLAyy8Gw0UROD9O/4vko1Ow4/EoovCWCpJ5zOMTCc0ZFcOkozBNTe+4f7hkRSA0PG5mdSo8GNLMeveFL2Cy3T+aNEXoBy+MebbO3ozFBWfUnYI6YX+gG9qH3iNfFSu2yAMnToP6CBT7CeGArf7TaViFCq8VD7Q8dUpNLQnTJV2wrCc7wDnsTBuT26v0ZttTdbf++OLvQIowsuY6I9Mh5I0+Mdr0v1vUoH8Wet3IuhR9Lbo9/CbSIBL6u8MsY0XQFyjUZisOXCyjtHbx1CwKo6tBebG36dwaj0VV3+UtVLLLLmLJKoalO+DiIax11SNuS+Q36XBxDD/b2CQOid/I2VwfDrtiHaMcMaReNP8EdJh/B0tKhSXAwDEb3VpD+vqgzYk99Sz0liQiB5skm14nGxa95Qg/rFuVHrdsdLeWxXKliVxNX46/r8sxZoC460lH
 jvX4MAs0
 v9iPxBAka0HLdsX282q/IvyvmCqL0ZkqgBcAdxarIzgGFS99fTWadDNBGNQfLBmZk5uS2YIPe3WPy/CnqUQI9dm1WFR850Gsp6wrcaUXrfr/NbMwjwbE1tZUZFbBJu12olJ8p4DrlB8hO+kl1ZOqXaU/1JwtiW+fotd5X7wv2AWL2k4nzypuETBj+9my9lYX3JKEGNn5TNMqM7H3f3hxFCN45eDEKaluN3MZaj7Abh8pB86vaCCQLDrYQFCRf79w+mhr7ELq0ylfGjFZA07gbkPt0S5Ab5CQ9g/HiWFxYqaaft7taVpeWmJ+QscBf2zdLLQXfANXrcReNQwD1M/fphmRtFsDA558GjrULljlbgRvY8cnOu3/ly/Otj1L19n7gF73vxDQd1Rb+SD8zTE6rS1C4AV2cHTkUKBRXVXqP61tg0O6dr8oU5ii6zWCIlk8fbP8qhvf4NFYGnAE73/bKInb538BTMtX7GJChqy/YPwtaG1fqeo4y+WskWq6tv2e7hngvRJvFP7JcrOTDPVfe48d7cZ6djwf+vg14r+iT/tflLt00mKPfzCWjuCGjIS7P+Ca8B9mzRNrdaQI03/QXRjdQs08PTn6jls6sxoZQH4x+htGMM6u+6fN1XtVmG+oSxodnCcf1iXGy9rvSVMPUdJKQIy6ungk/0UjXsZ8ei/4uJib5PUbdDsH5XW1dGPppFQGR
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


