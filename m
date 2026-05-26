Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97445CD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E2996B00D1; Tue, 26 May 2026 09:05:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 093DC6B00D2; Tue, 26 May 2026 09:05:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC40B6B00D3; Tue, 26 May 2026 09:05:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D1C716B00D1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 782B6120343
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:53 +0000 (UTC)
X-FDA: 84809593386.13.9329E9F
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf14.hostedemail.com (Postfix) with ESMTP id 74397100013
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:51 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=lC8io2UL;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="f vWlrjs";
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0e4WGwhn0PB0Lb/bUSloM/7IFtEUrah/eLYoarii5hk=;
	b=Y7fu8q0aelPMhDk5VT9QH2KLIb0yjU2Jg5+CqqwgC2MTcPZ1S9T5Rgghl9aMY1YvudW9Aw
	wm5LwpQ6rGl0zUtE24Bobm7mYpONk6GJQwG2VG51O8V4Y9eSQVlzJ2EdnOgKnGx1TWH0u5
	QBR7griYR6AQfX9QjKQ3Vp6fYsAbj18=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b=lC8io2UL;
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b="f vWlrjs";
	spf=pass (imf14.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800751; a=rsa-sha256;
	cv=none;
	b=tnNIk+jvNZMG2kcmBmOJLbfZFiT8RfKjiO/qLOINYe7fk4KySIC8IIrZyRpYDSOBf1V4if
	PjMMIR7YUfWAE7wdqxwmx6bzJ3tbEhVbNN5IpXFdBcIN/kekUp7dZnMAVv0tvA81IVl7Sq
	AA+uzyQqlaUhlA5FcWU0AHBlWCLKC14=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 50E1E7A0146;
	Tue, 26 May 2026 09:05:50 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 26 May 2026 09:05:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm2;
	 t=1779800750; x=1779887150; bh=0e4WGwhn0PB0Lb/bUSloM/7IFtEUrah/
	eLYoarii5hk=; b=lC8io2ULtHRkLhUO+JAUFAnqeV+JrjGqOnCfL0cGQjufTXHT
	eTXds1hzRHzxAg/FAEj+OYeTM0f6+zhjbj9dwmCftGKDgpIYgxyOL7Wj1tWj0tKm
	ymn776dhK74C5e6poHKSfT6fOpqpeyPzhfZgYY7fcNcGbqw2gTkfnVmxftCyMLB8
	HYrbQUNkF+7dIHoPwb9054bahjx1Xmkn8q0YjcZDG3SpPyuS2/LXO6dyIPqgcG1w
	hBmO88JNCsj+vxaVE+GCz5PCUTacqPuP1DaZTUA9zk47A54rw9cDsPR5uI8x3PIs
	zmfJLCEQM3pOdFAvcKwIvNmWk7eWEJZrEsp3lg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1779800750; x=
	1779887150; bh=0e4WGwhn0PB0Lb/bUSloM/7IFtEUrah/eLYoarii5hk=; b=f
	vWlrjs2PMpezOSavRQBJvQcUBfPduV8Vvo05fY4ZR84zLIauGNVFURBxnK+FW2Ie
	EuSUIBBN+c/O2tTzBamFGufMkYP+VeJtTKrB0AuqczF+vMONj9DKECHmu/rg3odY
	W2xDkubqAK1Ere0/r3Dd3RReBG8rAQc4Oej2KYun1FCczSaiDAgwVQRz8uurfYG6
	zQeekFvr/gLyO5QC3VsCKR1JKe0STpcFxZiiFKWETgEOPxWWcVB+RLlhpWObxnlM
	izILu7S/BH322rT3aGvhJFpeUuxAy/mpd/zkl/Kl7Yk9w0oDcQLRlBfhNoVR/1kl
	hiyZ6ax1hHG9nr9UtuhWA==
X-ME-Sender: <xms:rpoVakr3S1UylukJVcf6BAms32JT3yUB03oRuwzTma08NYqKR7p2_w>
    <xme:rpoVaukN54MrMCxOmOx5nq9OfcEzeRv2AFVWEImfz9rgZg7m09K_Nij6rEfl5BlXL
    RsZZlESShmd20fpAYRi_75xe74F5SsSm4wM3KPeLd273CFePz0u32HV>
X-ME-Received: <xmr:rpoVahuCaenQxWor5kTI5bEKGH__BrPnC5M78H4P5C0ANLLrC-fTDhMyhdVihQ>
X-ME-Proxy-Cause: dmFkZTFJ2bJI4xDmQgR07sJBeQn9uM13l1IDWb+O1snDuz7v5Ax8JR5dVS3tEEBYspKeR7
    MIDNN1riH0BYtd9JI2yimrIxWvps4Q2SrjhhycZkM4QIBZFjrNtDvfd9yE7lY/trP7Euvo
    9A1MtXG3R7pWCmhu8Xv2H+6bXibGjLwmxPYzTSQ39I/RE7M0YISHZNzeDetuGBtRspLUQb
    qwrBGmt3FeA1FDZuAhJpNLgyNYx8/4GBXc2FpNzxLFKAKoQWeB/nDQgSR9dKbSc5evxZSG
    3jVRv3HVRInqyo7nrq6ydixC4naTHn8paXd04Htll73n7ZurarfHg1MsebK6ALakiAhuCn
    oDlclrUKU/Pko645/zg1XNdcArs2BVseMIXjWxVNeBUZeMjS4uoQYw8lojFWwf5+jmB2S7
    kapJI/Rn4gwso1QkoFhvzAr/8e1Y2LTylcJPE5kwE8Xuaqm3nC4lBy0pcqgowFr+oVgni7
    hw9DoS8LOYTeWlcJo7sOw3PthveWZq7rgH1fqOz93b4jm0ghjNUP8Z7MqgKbw0vHsCg0Iw
    J9NhHwuuN18HuQddabvA+Ic4waJ37XqgF5Wjig5vQ6vxw6EIkFNi2QFKqJ9eNoixEK9ZKO
    1TDBT7vjzGMfzMp7q8GJnhuxALkZX+1AOTz6ePMwfOzqiJ51wRryb+4MAhzw
X-ME-Proxy: <xmx:rpoVale4kPkLWNf0tpg1w3FfbHTGeVUkaO8JGwEKTXK5NH0K_L55_A>
    <xmx:rpoVarb5OHk3ECwCY8pMLE1T_jA_FDQ1u4mVuliM8lkCosx0BYUEow>
    <xmx:rpoVal3orNQTZ9XjyWKT94DzHcR0rsJKvAcCbwHJoCzjVk9-Iu-R8g>
    <xmx:rpoVasqjDxJeOIek0yMHPZcOT1FbO-stEvoEClG-7NOQ2gzPLzHAaA>
    <xmx:rpoVavXOJWeMT7-JP2u97hXFyV9Npm2T1WV5lld_c413sTZG3_iU8_9u>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:49 -0400 (EDT)
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
Subject: [PATCH v5 12/18] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
Date: Tue, 26 May 2026 14:05:00 +0100
Message-ID: <20260526130509.2748441-13-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r1x4138inim9k4pruf46fucd9jzi4773
X-Rspamd-Queue-Id: 74397100013
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779800751-337170
X-HE-Meta: U2FsdGVkX181ZoAWde+/V+8yBrpqrTiPKKYzzA/2V6JYa5+RkWP/Ic4VgtmbpF3jJ98h7vzV2wk+T4KuzXTsMn05xdDvx32lt/K4OQwsg8IUuaPutBf5BAsA4E7yx1mIBa7rOxqqGJMGeIcoom+/v6xeCs6ExiurSLLExT+RNQLIioe6bNADCZiXT2nALEip51bAQeKK/9TiNuackXifMwy6flUhRzk59ekmyAyOD3gQgbLR4Ktf9Ojphapu9jaz5wUMhc6PTJwd+DVPFz01S0dMgySpUD84tcI2r/ggA5B0n0WAhrXGXJa3HWpv595P/5EUADnr8BxZD2lmk0xh6vGEPcQLH//rOTcwXI+d3WH3gDs4mddg+fUiVjdUykcAl9xwrVnBMx/sMnXjpvlEyjLF4qG2G+Coh9AGLRNrZEQ+NH+4WDkhQUntydsGQ+ZioCfy9iISAN9nLqsnHbB7L6fQWRaRhsUjQg5H6XUxh2wWJO8jbW5Xd6uSxVaDYMArZcHgkjRWdyLR6AZ1qPWsmn3PloX1bKeOhLKnrW8d7sJgWryf6sq/qWXGJSSY4JzH5RuHKn4Ah7qh3ofSBnR9NSdDPC1ynNSwfFkO5MghXN9CsuVHtnKpirpbBePH6BUO73pO5F3QMYONzaQcVa1RNT0/l4P3hqt0r1UvWcpvIePj1Q7Qr2ZyLAb/HRR/fJ6Rg3dxZfj1zovls5kDfD8vueTZB59DZX1NaAhQzQETsmp0MHaR7wPiChatLjyPkFTDiAjyFscFAdDohlThPaqqwiVDIepnORXBpdgDq/JRkzI2LRPmePwa/wY2aP0YMsmxM7oRoLSB6d+DU8lL54c917XME7rkI982Bedz4+4HvQolzUp6aPC09vjSOsKa+AsP5/OS0DXQ7G30KiEKa6apYNRLIdygf6WVKPzfOg0lzxbDGwQYQPs1Im/Y3S9i/0CZq1xqq/rgWj3J9S/zRo8
 BdFgRraK
 CI0+acPu6+a3a7ptSWELEoiPV3LNuZbkPbx1MGhawQR70yM5fiz/vwaiJOYSWg7OCnREoDhauhrR5d1Zr7LcYwq0St1GXLwTfRNO0RlBYFqZAbosg70rM5T754/dzm3ZAykjeqR9Gz77oXkdwqIX2erAF+HkskNNCW7oWm1wQiebuvRBDPxIGzO8WJaE+CTVD8IoPrmAxhF/+oUXzbgTdbMkIxzyz/lbv8Lar7mDKffIIMgOZhGER24p0YmKulQMP2uJwux09RwBgL7jxLxMWxTkBhxcdtFbCdcnuKfE+8kPmnTrYusPr6eD9TC238KccsCfhoXdbHecIR4OmBpcVIica81ogQ5tUhQ7GgdUy9zykuuhVC+4vPvVqp7IwyxYhOVRcP9v5lwL33uTnFnLnDv3mFH+s4wcIDhlXSruFW4h7AeOqEHbxsj4QJn7JFoUE6vZt1qi8Fwt6OB5Ape1xVpnV3RIDg44hRdEYdxAaFfdy1MI4gItcYwzvF4itHt4NtVfDItSprq351JLNfplDlti8ceArOWhcYW8iYY078s7p2jh8JBr/m9vU6EKUbCn8LYeSO8BkvCQGEY/HV2qL3mPQjRmn8rH7ivdwLVhonyLkuG6IBchW35Xa0hufSKyPSh9+wSQq8twmOUE8BAaEPKKmzE37RTDlZuLU2EwWYL2FedmPRloBBUKTvfGOyX9mglFlb6I2+J4VFVg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

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
index 564eb2aac321..28fc44733302 100644
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


