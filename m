Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCDF2CD6E49
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7995C6B00EB; Fri, 29 May 2026 13:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6876A6B00EE; Fri, 29 May 2026 13:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48B6F6B00EF; Fri, 29 May 2026 13:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2AF776B00EB
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:28:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E8B651A0202
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:04 +0000 (UTC)
X-FDA: 84821140488.05.9C4497F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id C55312000F
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:28:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irMSoY43;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RgHUcO9zOOU0NSzK4GPlfHyRlPNkFFMFUZ9QDaPQAxc=;
	b=brUAuzHQyMxIhYTvFV2V9+tUEuPqPkcb2qr+R6hzd0tEuxifeWfrAt4qskGdaaYpX+oDbi
	b2uJSSgOCLeS9HzgS/nZg7vpWVw02MEtmeZFz8WC4S+n8ei1tHocjLf2ix0qZ4yxg0bf8W
	O+sepbPEbc30+aydotXDnEGhASJ/D04=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=irMSoY43;
	spf=pass (imf13.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075682; a=rsa-sha256;
	cv=none;
	b=UkIuBAQpKuWRWOBW83XDBSkEv6S08CiiZ2/Z/LIo+VH32Vr88aMUFlHEKL+GfwAZUhaIig
	Veogh1F+4lF4dVEZuXkTrgESrmEOC+2t+wT5bEM5I3k2zNGT9nWOyCrzEMeCpth/uWG4Vt
	O6EnuRv3K+eeFdhqkCgQ/ehR+AuU6RY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F10B8417C9;
	Fri, 29 May 2026 17:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4264F1F0089D;
	Fri, 29 May 2026 17:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075681;
	bh=RgHUcO9zOOU0NSzK4GPlfHyRlPNkFFMFUZ9QDaPQAxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=irMSoY43ILIg366K3zo8XV+bjDC0UWPxuxRTjpQ36t9PTIr2dgubZdyeOTs6bAv8M
	 1wSARfM5eOk2hZ7egJT75taRlPqBIS8x9FXH6G4lHIOEbzJfC6fZHerhJbDXH95JOl
	 mPbxZiKQXy6ZASKakUWg4Z4cnLlk7icUoHSbOwOhlu7YB10nLjjnP9VhE47tuO9xzq
	 8iPDvBMqP4D5eTYE2xaGqMzWjVwEKqz6RWIeuU7xXACIzbGfZK7afCE4QPs66QALQE
	 yIZb6tiM4MTnBpXG7NOsYoUOVMQ4A1W58eLh+XFQXlHrIkUFcex1RU4mw6e6QPUO+1
	 O59EErTIFmx/A==
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfauth.phl.internal (Postfix) with ESMTP id A2063F4006F;
	Fri, 29 May 2026 13:28:00 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-10.internal (MEProxy); Fri, 29 May 2026 13:28:00 -0400
X-ME-Sender: <xms:oMwZatjpQC0iCVirVLO8f334LrJxxjOhWG7GMmslpIwTjFUnPhyidw>
    <xme:oMwZal_oBUhSo1T0v3edH77TEJ_gH2YLNk9FWnp7pX7rqBc6yO1ZN2lT2KcxFiDLL
    kroxnCjCXI9jMA9gWOEivXXQTgOggCxsDBncr9OJbrypjMxyOgAp6s>
X-ME-Received: <xmr:oMwZalmKmtuCQony9H3iECNg37Q7CAgurKrT6sNKZXNjExRbfCxdXHfMEcLrzA>
X-ME-Proxy-Cause: dmFkZTEHS1Z+n1S80q4BaszFx9bNnHLQ6sgL6J9HpxOFXRfFtKsh6le5cKxaCZzZ/qH/SJ
    zONNCxWzVoPiQhYsD9dliy9AdrB2UY/Bhb82egQk/l96x3r4UUhrX92dr53s7Ptki96Mx4
    DvJi8H/xrcKSa4upwFZAuWyRsvkJtw5DUL41fEdJBQDb5TWXZV3TgknVzb3pm5Cw5eabt3
    ZKinBz9XCIvsS/RAa3Cb6hoIPIA7Rb0ceUklQcqu2F89W2umMVSE8bbF5HocBMl20u4Nxk
    92MelAoY5r8qDI90ESLS21z7KfMewjRnztTxCHQfAtq0f2Qz4D8wiVPs5MI39B39+ARIB3
    WcWKMELBym8czu8yPkh/bqVNd7lU6jSLQ8pOPppnRP3jfjRlneJX4hgafo4AfFHURiwK/m
    2CQ8gteJg8A3DR1tnc37Csx5XD45IOMzipSP9JEfmrhWrW4OP9Mdgntlwgum+3OrPWqPla
    IcNuh9xPKrDVXwKwGduPRzpk76s7Pdfb4CTLhnUjwd9jPfcn44XxEkXOn3py4mUC8nL/YI
    59RGluiiyTne3n7R3Dodb6CQspV3MDbiRPARuHobRvB5vru0AjfQCXw31U1ChWs6MfXMAt
    r9pDpTH2rvs4S4ocribmdnlows7fmpPLidtqhS0P8SzwDxugrv3g52BKYiKQ
X-ME-Proxy: <xmx:oMwZar3uAIM5ZgesJ-XRTyUkrc2SZO3XvA3MRnMPzqAS8RaRjsmptg>
    <xmx:oMwZaiTH52iln2qJNZJ0m1COLBDC_1-HiaowOkjPtgEU3TDhV5tzzw>
    <xmx:oMwZajM0E7SNBZgcFvlGnjERGcvcjXtDOlzxEW1gsztjSclC5SaDAg>
    <xmx:oMwZaugxCJYUQSN0u_bbvVdxJHdASugC8XWUTNwT47hOUpj_iMLsjQ>
    <xmx:oMwZarLe1chvcHgZJMXMUnYKraa8b7tlM0SVGXN8m3p8WrkRtT-2d2-m>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:27:59 -0400 (EDT)
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
Subject: [PATCH v6 09/15] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
Date: Fri, 29 May 2026 18:26:38 +0100
Message-ID: <20260529172716.357179-10-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172716.357179-1-kas@kernel.org>
References: <20260529172716.357179-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: kszro68w7s4ckmx5axe9a5kfscj9izqr
X-Rspam-User: 
X-Rspamd-Queue-Id: C55312000F
X-HE-Tag: 1780075682-613809
X-HE-Meta: U2FsdGVkX18mBPiKd1Hm9pj/KpOPxrWmrIrOD4lT7KC8nJU770iZz9FqgBV218zgyFSPjmYvUmhiEEqRdIpKj7yhocimLVSK8NeXffcs8HoS04ShSH8ITy3IzvqwNGq/a0LuGQKqyen15PJ/zfYp2UmzWFUVeMNmy/tpgvRWFdjlszeShliA34Af95eLwpFKNkm7YTMnRrQGwxI7zti7GTtc2VgE22R/2QxXb4LT1HbRPdHhs5xxjw5tOBxWnzdw+0p3cNRDQJW+rHfO/aQrT/HvA4oJAhFysxr/d/Sj/ztGwBf0N8GBkGvyQKoJ1X3B+7pxRK7NJfhhEf4ShINXDi9vywMFmP1QIE8ruieh3Cqpm2jek/ZqzAoZhAsTqyT/nh9xdTH15bUq6bjJzbLDWt63j5ObSgoSvOMQfWEDd9XYylI16nWv/KgdXfAVXrGBW9NBNfPnuwn+Jt5ryBFLAkLrgC/IobTxoa1z03RuaajbZUz9KA0YSHdwtj+jMasyFKfoXij3ypPyeTkAFKTwM74GcwrAmAB0ytIJR27u2PSde1xYsliU+DQmEJ8WKUX8Las5yMSjwXw7rcJFGLPGJyosWBiFqvXo5TsTB3Bp9GUm2Lu5iM0HBKJaIKBUmRW75mp8DbqDuMT8SwWZQucvTBkjKMTPAYaJ8uyb6OtWmgviOOdc7m3daDl1QQrFgDrLTqtFAONScIngecq0a0ANwzWhPOI/SsAXDE7fD5jSwuEuXXA+SS7w0MrHUPR0OJ03x/KvxiPRaWcLLVg4AJm5wlp+JtkIfHv/0pUwRFyqRxa2kdznEJdmsuYDISi82OpoBedjw9JBlxnJ4d/Kfz3iUryUJOj1z8X1qSqz/Stmv/Dt13lIJEwkZDLl3i9Z7QyCQOAkbPPzZqg8+h8Smro8RUJDpnLGI1IFvmLxCMeB70NnrJvFCrbAVlW3PzjHptpcGqIt4h27XxHAgx8uMjx
 lgOInsuC
 eiXQyz5np2A0lh2mWl+nOnMLRg6rmlDeRLFVQnlY/Al3ScTRDwbrOopTIcV7+XbuebT8aycgpAvonaY3lIXfGwOMBsbsZg3DwrF9P8OiQu63XERWqfDvWEMoVJfG9XqN0+8JA3qlrD1/bqtVfRnQosGUvI1IQMQnug1SSgIX7kAC7DX8A2ZgSYxHgaXyiXjkTGlx9E2ZSsnfimfaEkkfWBmzSOeSNnpuaIM9HyawBz4JefQn5DzMtCPDWijhEtdqh5dzEncNcUxggIBiESTKAud2gyS3qUfiBethJJddvVuO7FXAzEPHDlztIee4OZJ9ylqvvH859R6XDvVOrn8zfjbnDLwftdjzRLdx1bExmmZ7Rz29j0wV6lxMYoUwc2eSMb/2dFHXGYKSn1X4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add the userspace interface for read-write protection tracking:

  - UFFDIO_REGISTER_MODE_RWP      register a range for RWP tracking
  - UFFD_FEATURE_RWP              capability bit
  - UFFDIO_RWPROTECT              install / remove RWP on a range

Introduce CONFIG_USERFAULTFD_RWP, auto-selected on 64-bit kernels with
ARCH_HAS_PTE_PROTNONE and HAVE_ARCH_USERFAULTFD_WP. The symbol gates
VM_UFFD_RWP (previously aliased to VM_NONE) and the smaps/trace-flag
hooks added in the preparatory patches; without it the UAPI bits added
here have nothing to drive and would be unreachable.

Registration sets VM_UFFD_RWP on the VMA. Combining MODE_WP with
MODE_RWP is rejected because both modes claim the uffd PTE bit.

UFFDIO_RWPROTECT is the bidirectional counterpart of
UFFDIO_WRITEPROTECT:

  - MODE_RWP              change_protection() with MM_CP_UFFD_RWP
                          installs PAGE_NONE and sets the uffd bit on
                          present PTEs
  - !MODE_RWP             change_protection() with MM_CP_UFFD_RWP_RESOLVE
                          restores vma->vm_page_prot and clears the bit

userfaultfd_clear_vma() runs the same resolve pass on unregister so
RWP state cannot outlive the uffd.

Re-registering a range must not drop a mode that installs per-PTE
markers (WP or RWP); doing so returns -EBUSY. This also closes a
pre-existing window where re-registering without MODE_WP would strand
uffd-wp markers: before, those caused extra write-faults but were
otherwise benign; with RWP preservation in place, a subsequent
mprotect() on a VM_UFFD_RWP VMA would silently promote the stale
markers to RWP.

The feature is not yet advertised. UFFDIO_REGISTER_MODE_RWP,
UFFD_FEATURE_RWP, and _UFFDIO_RWPROTECT are intentionally absent from
UFFD_API_REGISTER_MODES, UFFD_API_FEATURES, and UFFD_API_RANGE_IOCTLS,
so UFFDIO_API masks them out and the register-mode validator rejects
the bit. The follow-up patch adds fault dispatch and exposes the UAPI.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 Documentation/admin-guide/mm/userfaultfd.rst |  10 +
 include/linux/userfaultfd_k.h                |   2 +
 include/uapi/linux/userfaultfd.h             |  19 ++
 mm/Kconfig                                   |   9 +
 mm/userfaultfd.c                             | 189 ++++++++++++++++++-
 5 files changed, 226 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index e5cc8848dcb3..1e533639fd50 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -131,6 +131,16 @@ userfaults on the range registered. Not all ioctls will necessarily be
 supported for all memory types (e.g. anonymous memory vs. shmem vs.
 hugetlbfs), or all types of intercepted faults.
 
+.. note::
+
+   Re-registering an already-registered range must not drop any of the
+   modes that install per-PTE markers — currently
+   ``UFFDIO_REGISTER_MODE_WP`` and ``UFFDIO_REGISTER_MODE_RWP``. Doing
+   so would strand markers with no flag to describe them, so the call
+   is rejected with ``-EBUSY``; userspace must issue
+   ``UFFDIO_UNREGISTER`` first. This differs from older kernels, which
+   silently replaced the mode bits on re-registration.
+
 Userland can use the ``uffdio_register.ioctls`` to manage the virtual
 address space in the background (to add or potentially also remove
 memory from the ``userfaultfd`` registered range). This means a userfault
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 5115827981a2..8e0833e6613f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -150,6 +150,8 @@ static inline uffd_flags_t uffd_flags_set_mode(uffd_flags_t flags, enum mfill_at
 
 extern long uffd_wp_range(struct vm_area_struct *vma,
 			  unsigned long start, unsigned long len, bool enable_wp);
+extern int mrwprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
+			    unsigned long len, bool enable_rwp);
 
 /* move_pages */
 void double_pt_lock(spinlock_t *ptl1, spinlock_t *ptl2);
diff --git a/include/uapi/linux/userfaultfd.h b/include/uapi/linux/userfaultfd.h
index 2841e4ea8f2c..7b78aa3b5318 100644
--- a/include/uapi/linux/userfaultfd.h
+++ b/include/uapi/linux/userfaultfd.h
@@ -79,6 +79,7 @@
 #define _UFFDIO_WRITEPROTECT		(0x06)
 #define _UFFDIO_CONTINUE		(0x07)
 #define _UFFDIO_POISON			(0x08)
+#define _UFFDIO_RWPROTECT		(0x09)
 #define _UFFDIO_API			(0x3F)
 
 /* userfaultfd ioctl ids */
@@ -103,6 +104,8 @@
 				      struct uffdio_continue)
 #define UFFDIO_POISON		_IOWR(UFFDIO, _UFFDIO_POISON, \
 				      struct uffdio_poison)
+#define UFFDIO_RWPROTECT	_IOWR(UFFDIO, _UFFDIO_RWPROTECT,	\
+				      struct uffdio_rwprotect)
 
 /* read() structure */
 struct uffd_msg {
@@ -158,6 +161,7 @@ struct uffd_msg {
 #define UFFD_PAGEFAULT_FLAG_WRITE	(1<<0)	/* If this was a write fault */
 #define UFFD_PAGEFAULT_FLAG_WP		(1<<1)	/* If reason is VM_UFFD_WP */
 #define UFFD_PAGEFAULT_FLAG_MINOR	(1<<2)	/* If reason is VM_UFFD_MINOR */
+#define UFFD_PAGEFAULT_FLAG_RWP		(1<<3)	/* If reason is VM_UFFD_RWP */
 
 struct uffdio_api {
 	/* userland asks for an API number and the features to enable */
@@ -230,6 +234,11 @@ struct uffdio_api {
 	 *
 	 * UFFD_FEATURE_MOVE indicates that the kernel supports moving an
 	 * existing page contents from userspace.
+	 *
+	 * UFFD_FEATURE_RWP indicates that the kernel supports
+	 * UFFDIO_REGISTER_MODE_RWP for read-write protection tracking.
+	 * Pages are made inaccessible via UFFDIO_RWPROTECT and faults
+	 * are delivered when the pages are re-accessed.
 	 */
 #define UFFD_FEATURE_PAGEFAULT_FLAG_WP		(1<<0)
 #define UFFD_FEATURE_EVENT_FORK			(1<<1)
@@ -248,6 +257,7 @@ struct uffdio_api {
 #define UFFD_FEATURE_POISON			(1<<14)
 #define UFFD_FEATURE_WP_ASYNC			(1<<15)
 #define UFFD_FEATURE_MOVE			(1<<16)
+#define UFFD_FEATURE_RWP			(1<<17)
 	__u64 features;
 
 	__u64 ioctls;
@@ -263,6 +273,7 @@ struct uffdio_register {
 #define UFFDIO_REGISTER_MODE_MISSING	((__u64)1<<0)
 #define UFFDIO_REGISTER_MODE_WP		((__u64)1<<1)
 #define UFFDIO_REGISTER_MODE_MINOR	((__u64)1<<2)
+#define UFFDIO_REGISTER_MODE_RWP	((__u64)1<<3)
 	__u64 mode;
 
 	/*
@@ -356,6 +367,14 @@ struct uffdio_poison {
 	__s64 updated;
 };
 
+struct uffdio_rwprotect {
+	struct uffdio_range range;
+	/* !RWP means undo RWP-protection */
+#define UFFDIO_RWPROTECT_MODE_RWP		((__u64)1<<0)
+#define UFFDIO_RWPROTECT_MODE_DONTWAKE		((__u64)1<<1)
+	__u64 mode;
+};
+
 struct uffdio_move {
 	__u64 dst;
 	__u64 src;
diff --git a/mm/Kconfig b/mm/Kconfig
index 776b67c66e82..fac01bcfc0d1 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1333,6 +1333,15 @@ config HAVE_ARCH_USERFAULTFD_MINOR
 	help
 	  Arch has userfaultfd minor fault support
 
+config USERFAULTFD_RWP
+	def_bool y
+	depends on 64BIT && ARCH_HAS_PTE_PROTNONE && HAVE_ARCH_USERFAULTFD_WP
+	help
+	  Userfaultfd read-write protection (UFFDIO_RWPROTECT) delivers a
+	  userfaultfd notification on every access -- read or write -- to a
+	  protected range, letting userspace observe the working set of a
+	  process.
+
 menuconfig USERFAULTFD
 	bool "Enable userfaultfd() system call"
 	depends on MMU
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index e30878e4e00b..c07e3232a01a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1157,6 +1157,75 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 	return err;
 }
 
+int mrwprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
+		     unsigned long len, bool enable_rwp)
+{
+	struct mm_struct *dst_mm = ctx->mm;
+	unsigned long end = start + len;
+	struct vm_area_struct *dst_vma;
+	unsigned int mm_cp_flags;
+	struct mmu_gather tlb;
+	bool found = false;
+	VMA_ITERATOR(vmi, dst_mm, start);
+
+	VM_WARN_ON_ONCE(start & ~PAGE_MASK);
+	VM_WARN_ON_ONCE(len & ~PAGE_MASK);
+	VM_WARN_ON_ONCE(start + len <= start);
+
+	guard(mmap_read_lock)(dst_mm);
+	guard(rwsem_read)(&ctx->map_changing_lock);
+
+	if (atomic_read(&ctx->mmap_changing))
+		return -EAGAIN;
+
+	if (enable_rwp)
+		mm_cp_flags = MM_CP_UFFD_RWP;
+	else
+		mm_cp_flags = MM_CP_UFFD_RWP_RESOLVE;
+
+	/*
+	 * Pre-scan the range: validate every spanned VMA before applying
+	 * any change_protection() so a partial failure cannot leave the
+	 * process with only a prefix of the range re-protected.
+	 */
+	for_each_vma_range(vmi, dst_vma, end) {
+		if (!userfaultfd_rwp(dst_vma))
+			return -ENOENT;
+
+		if (is_vm_hugetlb_page(dst_vma)) {
+			unsigned long page_mask;
+
+			page_mask = vma_kernel_pagesize(dst_vma) - 1;
+			if ((start & page_mask) || (len & page_mask))
+				return -EINVAL;
+		}
+		found = true;
+	}
+	if (!found)
+		return -ENOENT;
+
+	vma_iter_set(&vmi, start);
+	tlb_gather_mmu(&tlb, dst_mm);
+	for_each_vma_range(vmi, dst_vma, end) {
+		unsigned long vma_start = max(dst_vma->vm_start, start);
+		unsigned long vma_end = min(dst_vma->vm_end, end);
+		unsigned int flags = mm_cp_flags;
+
+		/*
+		 * On resolve, try to upgrade writability per-VMA --
+		 * MM_CP_TRY_CHANGE_WRITABLE WARNs in
+		 * maybe_change_pte_writable() if the VMA is not VM_WRITE,
+		 * and RWP can be registered on PROT_READ-only mappings.
+		 */
+		if (!enable_rwp && vma_wants_manual_pte_write_upgrade(dst_vma))
+			flags |= MM_CP_TRY_CHANGE_WRITABLE;
+
+		change_protection(&tlb, dst_vma, vma_start, vma_end, flags);
+	}
+	tlb_finish_mmu(&tlb);
+
+	return 0;
+}
 
 void double_pt_lock(spinlock_t *ptl1,
 		    spinlock_t *ptl2)
@@ -2145,6 +2214,15 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	    !vma_is_anonymous(vma))
 		return false;
 
+	/*
+	 * RWP uses protnone as an access-tracking marker. PROT_NONE VMAs
+	 * have vm_page_prot == PAGE_NONE, so RWP resolution can't make a
+	 * page accessible -- the next access would fault again. Reject up
+	 * front instead of letting FOLL_FORCE loop on protnone+uffd PTEs.
+	 */
+	if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(vma))
+		return false;
+
 	return ops->can_userfault(vma, vm_flags);
 }
 
@@ -2197,9 +2275,22 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
 	if (start == vma->vm_start && end == vma->vm_end)
 		give_up_on_oom = true;
 
-	/* Reset ptes for the whole vma range if wr-protected */
-	if (userfaultfd_wp(vma))
-		uffd_wp_range(vma, start, end - start, false);
+	/* Clear the uffd bit and/or restore protnone PTEs */
+	if (userfaultfd_protected(vma)) {
+		unsigned int mm_cp_flags = 0;
+		struct mmu_gather tlb;
+
+		if (userfaultfd_wp(vma))
+			mm_cp_flags |= MM_CP_UFFD_WP_RESOLVE;
+		if (userfaultfd_rwp(vma))
+			mm_cp_flags |= MM_CP_UFFD_RWP_RESOLVE;
+		if (vma_wants_manual_pte_write_upgrade(vma))
+			mm_cp_flags |= MM_CP_TRY_CHANGE_WRITABLE;
+
+		tlb_gather_mmu(&tlb, vma->vm_mm);
+		change_protection(&tlb, vma, start, end, mm_cp_flags);
+		tlb_finish_mmu(&tlb);
+	}
 
 	ret = vma_modify_flags_uffd(vmi, prev, vma, start, end,
 				    &new_vma_flags, NULL_VM_UFFD_CTX,
@@ -2248,6 +2339,14 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		    vma_test_all_mask(vma, vma_flags))
 			goto skip;
 
+		/*
+		 * Pre-scan in userfaultfd_register() already rejected mode
+		 * switches that would drop VM_UFFD_WP or VM_UFFD_RWP, so a
+		 * stray bit here is a bug.
+		 */
+		VM_WARN_ON_ONCE(vma->vm_userfaultfd_ctx.ctx == ctx &&
+				vma->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags);
+
 		if (vma->vm_start > start)
 			start = vma->vm_start;
 		vma_end = min(end, vma->vm_end);
@@ -2514,6 +2613,8 @@ static inline struct uffd_msg userfault_msg(unsigned long address,
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
 	if (reason & VM_UFFD_WP)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
+	if (reason & VM_UFFD_RWP)
+		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_RWP;
 	if (reason & VM_UFFD_MINOR)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_MINOR;
 	if (features & UFFD_FEATURE_THREAD_ID)
@@ -3613,6 +3714,22 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
 		vm_flags |= VM_UFFD_WP;
 	}
+	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP) {
+		if (!pgtable_supports_uffd() || VM_UFFD_RWP == VM_NONE)
+			goto out;
+		if (!(ctx->features & UFFD_FEATURE_RWP))
+			goto out;
+		vm_flags |= VM_UFFD_RWP;
+	}
+
+	/*
+	 * WP and RWP share the uffd PTE bit and
+	 * cannot coexist in the same VMA — the bit would carry ambiguous
+	 * semantics. Reject the combination up front.
+	 */
+	if ((vm_flags & VM_UFFD_WP) && (vm_flags & VM_UFFD_RWP))
+		goto out;
+
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR) {
 #ifndef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 		goto out;
@@ -3706,6 +3823,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		    cur->vm_userfaultfd_ctx.ctx != ctx)
 			goto out_unlock;
 
+		/*
+		 * Mode switches that drop VM_UFFD_WP or VM_UFFD_RWP would
+		 * leave PTE markers without the flag that describes them;
+		 * subsequent mprotect() would then promote stale markers
+		 * into the other mode. Require an unregister first.
+		 */
+		if (cur->vm_userfaultfd_ctx.ctx == ctx &&
+		    cur->vm_flags & (VM_UFFD_WP | VM_UFFD_RWP) & ~vm_flags)
+			goto out_unlock;
+
 		/*
 		 * Note vmas containing huge pages
 		 */
@@ -3739,6 +3866,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR))
 			ioctls_out &= ~((__u64)1 << _UFFDIO_CONTINUE);
 
+		/* RWPROTECT is only supported for RWP ranges */
+		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP))
+			ioctls_out &= ~((__u64)1 << _UFFDIO_RWPROTECT);
+
 		/*
 		 * Now that we scanned all vmas we can already tell
 		 * userland which ioctls methods are guaranteed to
@@ -4086,6 +4217,55 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
 	return ret;
 }
 
+static int userfaultfd_rwprotect(struct userfaultfd_ctx *ctx,
+				 unsigned long arg)
+{
+	int ret;
+	struct uffdio_rwprotect uffdio_rwp;
+	struct userfaultfd_wake_range range;
+	bool mode_rwp, mode_dontwake;
+
+	if (atomic_read(&ctx->mmap_changing))
+		return -EAGAIN;
+
+	if (copy_from_user(&uffdio_rwp, (void __user *)arg,
+			   sizeof(uffdio_rwp)))
+		return -EFAULT;
+
+	ret = validate_range(ctx->mm, uffdio_rwp.range.start,
+			     uffdio_rwp.range.len);
+	if (ret)
+		return ret;
+
+	if (uffdio_rwp.mode & ~(UFFDIO_RWPROTECT_MODE_DONTWAKE |
+				UFFDIO_RWPROTECT_MODE_RWP))
+		return -EINVAL;
+
+	mode_rwp = uffdio_rwp.mode & UFFDIO_RWPROTECT_MODE_RWP;
+	mode_dontwake = uffdio_rwp.mode & UFFDIO_RWPROTECT_MODE_DONTWAKE;
+
+	if (mode_rwp && mode_dontwake)
+		return -EINVAL;
+
+	if (mmget_not_zero(ctx->mm)) {
+		ret = mrwprotect_range(ctx, uffdio_rwp.range.start,
+				       uffdio_rwp.range.len, mode_rwp);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+
+	if (ret)
+		return ret;
+
+	if (!mode_rwp && !mode_dontwake) {
+		range.start = uffdio_rwp.range.start;
+		range.len = uffdio_rwp.range.len;
+		wake_userfault(ctx, &range);
+	}
+	return ret;
+}
+
 static int userfaultfd_continue(struct userfaultfd_ctx *ctx, unsigned long arg)
 {
 	__s64 ret;
@@ -4392,6 +4572,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_POISON:
 		ret = userfaultfd_poison(ctx, arg);
 		break;
+	case UFFDIO_RWPROTECT:
+		ret = userfaultfd_rwprotect(ctx, arg);
+		break;
 	}
 	return ret;
 }
-- 
2.54.0


