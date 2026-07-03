Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80A98C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 13:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFF666B00D4; Fri,  3 Jul 2026 09:36:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A14526B00D8; Fri,  3 Jul 2026 09:36:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4C36B00D9; Fri,  3 Jul 2026 09:36:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9416B00D4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:36:43 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C8B0E165DE6
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:42 +0000 (UTC)
X-FDA: 84947565444.26.18E18BC
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf29.hostedemail.com (Postfix) with ESMTP id D1A1B12000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:36:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=UhKAGvyO;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="J c+CPZx";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783085800;
	b=gSyVpHMOszOpBSCqC+hr3nlDAkHT1EyjsfuynYb/qtrh14S8HHV0A1r1tkxS/Yl2o6FW1/
	3L+knfssnPQ4VSdkbc1I4z2cZ6WLtPfbp+jqJAyKi+l9oXIPjeU7/370njSH6QJa172Kn8
	vtX7Sn5jCXJSgcfzPLj4Ae8jdzcemkM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783085800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2HAsvV2aS50vy0Ddv5Z9TIljsyWizztKXk84xdH2Ws=;
	b=FssMaq2/GAqt/P7EtqJWjIiDWbXQaFNcMm+oe+xo/4whM+ZRJwpuNjfBx7qS1+J1nSUU42
	2hHvDfGyrL6Q+SelDoib70LdUeD4GquvH5WghSW4Mx22pobqSg7W/wtYcm0/qs1/LH4TQo
	GR5ZdHPwDESERTDRTBzGepxWxZsW11o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=UhKAGvyO;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="J c+CPZx";
	spf=pass (imf29.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id A73A27A00B9;
	Fri,  3 Jul 2026 09:36:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Fri, 03 Jul 2026 09:36:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783085799; x=1783172199; bh=R2HAsvV2aS50vy0Ddv5Z9TIljsyWizzt
	KXk84xdH2Ws=; b=UhKAGvyOOkPZ5W0HKoyXO5Qc8ylUK+IQO2m/x2wlSFwOebDu
	gE7chANdBTbG/Fj3EAUTfI+ekfh27ho4QjUFQXSFrWnf6v6y0Klc7tVzFn+3N1wh
	sXRb63XgOyK2aVtx9PIs1iILAKIjPYBWqF0iqoF2EZposcf+HHZs/nqIEh3A4VTa
	osb2Dln2STnEVvE4f2IMIb6pRC7acOlFadr6myGylDD2XoaZo24fS6bathueE8pr
	2FOn/ADNL0E+npUV9bHmdImcfJ/kufM90vJRyxoiYFr5hW/KHvCPYHCmZ67Du3kt
	xkfb+a54BprIT8gBhf+r9L0mllRtJXKfwZ31mA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783085799; x=
	1783172199; bh=R2HAsvV2aS50vy0Ddv5Z9TIljsyWizztKXk84xdH2Ws=; b=J
	c+CPZx+HDawsO8gGRaBOtVjwVE0zHjByOC24EKkv2p5JOuFaSQVFOOBA4gCGuX9g
	SqgqsIVVjDwYO6mFUpz7FLVTZd0xhlL+TEgyMVjz9Q+CZQ5OcZ/OlXYhdFuaNey0
	QThTemYzJt9FqRHUkgDucuy7Hlg5SDXOhXNP0eRLDAlWrssZQmZdPdumcQJRPbCp
	Z9K/gyCfWCMGZiP/3iS7OZT6YLuYAKfVYt37VSXKNkNKlbLNjfD1O8YR9HNp3pyh
	rDGv07BIM9SBYpeg4nsmiIKH8r8QkZ5jSj0s2XppM8KTabtKDUUnlTIb6/sB/b+l
	Avlay5x5GGLNr8N2L4IDQ==
X-ME-Sender: <xms:57pHatmzaSiN6tRsO1tWGQV_Q2_hnoFA3l5hP5adR9Wl56OK7816lw>
    <xme:57pHaszQzPQmZ3_FD5pX48N6B5A-7dtbTr4p2bSNFwDwWfhmkUH3cwVEUsOvNHg9c
    v78QbaFyUYLSPkvF5YXao8sA3sJN8R-0e5QFbW0J3o1r34IVt7l2w>
X-ME-Received: <xmr:57pHasJumeuKcQaaxMHyZ8p8LZ5JMwJAoSQ_vsyXq25f7gPHQ-7jTtibGyxLWA>
X-ME-Proxy-Cause: dmFkZTEvpT7VPI/TDUGEnnIrVlILKwXgeXt+foeC++RMQKPZsPpb69BYeN94A6l/J4m8GR
    j7cxKNSW+PCS7l0cP9ewYlNjp3o4SRzo0q9x8boy+qMv6IPQeEYIg3N09NNUL1YwXh4Yrh
    l/VK9KxOHmvITqsfYi7VnRs0zn+zCS3v2T7VSdeEEdSIb4snV1El6VtdknOa4IcxGosKQh
    b50hZlM8u2LRvSc9TWKyrKm8vDP+A/+u7lOr+AQwZAIydhhZxADZY4tnbcibEwn1oxgg5G
    tZcbEgM6HqFuHN1XrVgTaj9QN8QlhWjwEBL1Bk9WTH3MhpwrPTlQlB4jwdEhPAmIPHL5hj
    pToV5MA0SP4lEY2TL+XiVXRAk9CCaAhuROWYoOeCzg4QiYxBNgVfG5ZSjTr2aOsjt1QLxf
    F+YbfqDkJPvLu8RfLA8T+YSLl7yfWxKEfrsGCPiXuvGG+09tCiQlHLnd4zOcgNvybMB4f/
    7ft7zU+LHo5stEazO3BJJBci9I4qJru2VP3nmt8s6C6veAaz4xjFvciS+8RiIT7r7FF88+
    T54T4cE3U6uXEVAc3PM9vMTWTaj/0chXMfgjzGY0GyvAlhJYa+t9GHABNkJ30KCVjucyEC
    F83SyWkBaLE/C8o/ZHKtC4jZJv2IfHZVXU8Te3L5UJ8LmHGSc00Ou1cU/0Ag
X-ME-Proxy: <xmx:57pHanKFivK_CYKearS9wtnB_YlzOtXXbE1P6QJHD-Xuaa31RIFyHA>
    <xmx:57pHajWQv2gwXfnMcz1FtcGbtKtWeb0zwhiyzNboWTLkH3DlD7MTSw>
    <xmx:57pHanAWRZsQaec6mwEhiUjj0qq0Civp4JR_Db0tDM5UWhhSd6TnCg>
    <xmx:57pHauFTxE0YMfyiFySXj_5Gp479PJ1oN_yOTMCslCzV6C8kHfgQVw>
    <xmx:57pHajEyNchp3j2EBOTEvW_am3zqTb3mBhIV2SkVqX67ZismXEQ71vkm>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 09:36:39 -0400 (EDT)
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
Subject: [PATCH v8 09/15] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
Date: Fri,  3 Jul 2026 14:36:08 +0100
Message-ID: <20260703133615.1039465-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8w5wuuw7qug3hc5x74q8idtu31utssog
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1A1B12000A
X-HE-Tag: 1783085800-340912
X-HE-Meta: U2FsdGVkX1+8ALglUcQb81g8fKqwVUwIdTRds4pvRNJDBZSHeHx8FFCXR+J5VZSVqJl2ELyCyb2IpnQQk7wTENa9ejwsr0K2Oij6KD1O5jeheKCfwa/BZ/V5KYVrdWkZJRqh/PuCD84iKmoT0JPG1wIeLrzSNXVZGcVy0AtlqiJXZ9p0mpCi62BzMjSxKm3qaWYG+dMV1Wasuxej/87LChxcc+z5Mz1g3sErSRg672l/cewYgsEe/Mtw+GEcp18UFaxPvYvfg6E6dHChT6X07h3SkBSS7VW1jketa0YGnXKqyWGz1/sCm5qRKuzvZsbhZNJZlthIUIMmjdzi8cZed5NYsCKejblJPPgMcLVMyY0bjAqMrrHiSqTcuhpzqPU+4QMopbkZYEX1XgPngV/qyD/blPSpbqz8WuWZG5K11SSrRD2wlb0Z4dqKKxHaGKOapVLuL7OZskTVbMt9ShR5QtXtaszodwuoE5OhI08XQqkCWvURRP5S13V5Z0dg3U4vCrJbmxC1datS/0FTDMrMYTaSEd3PST42t8IxuDnscGS4aO+X2rpah7smQMUa7eUHm39SW8JAyS1zmTbszNoLSsqGYgiiWClkyZfeto6RWxLLcUUUwXJ9JNwuf7QYzLBkKIycO3PaAyBciQQAYthrzpfevkSuL5GWuEsf5IxHDVA59hTr5RCPpT/1qfN7Hgs9gy5Q/XWrc093inkIiJ9eS7nfBvVMatRiBqyRNkiCDZNL8ltseQDUsdGHSnt2tdC5p9VzIEQN8SYfuMc0GHVYlGCNckRPLWUcpxsu5c0Ssk3klMf0drbazZa38s3akF2q/5NjeFYoChubZa0UNbh+TsrXbD5kOmIWamq7XWKdWkuCASBKO0xpDVYzjBf/ll/bAiIbf5VqADNpsdkgs6SwPDx8cq7rSNozvbw7F4yMCz6BKTQJL3oxuRhHaJ/mUL1VXUeBCEsV/CjV3QCRDiU
 JjnJDqUP
 c2lpDK2lUbAf5gOnZpDgFkuUFDmNymjByVIXaf12dh9zReckbeflMH010q+FtPq6nYG/6+OGsXab92LtV1EHtpwTR3NZ5hb8/QeNSWXtj+auBH7D5WUesPN1aHW75ZBttVjgeT+I3TuRtLzQOCsloXmj2RUg22GzIX9RKlLbhpY76YNZHF8errYONQE46fwRDz5srXJXf30N1/a3u1kOZzJC5LSTmxQxJ3bjjck21dj8D0VqnIcZxRSoErgUGODKVRkhz+HFTLb6A05f+zh8B/VBicARWa1tgZUpaIip0NUUc3n/MjH4TmBbchmdyj9bxHQ3fKOUoDRB3i+QRtLwvhroXJNiiP7i5ihE72CPUbudvSKm+Z4BT38Si02EoHeGOQ8b94CLk9f915PbVA7p4Q61CxaH3ZdHVem6faLDIy2TNn4eF3uCg0KXJl3X3QEQPYUdkyxmwoamdAA/g79gHmVoxDmxbldlY8PUajxZ+riV9Yjz9bodnqfiN9sY4azLnsTalzqD5yDjZayGIC+0znQP+ww==
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
index 92d27c54fe79..d65e1833f08d 100644
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
index 9e0ca4824905..ccb716535155 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1386,6 +1386,15 @@ config HAVE_ARCH_USERFAULTFD_MINOR
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
index 4fca0409b7d7..a58ebf68d7da 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1164,6 +1164,75 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
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
@@ -2152,6 +2221,15 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
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
 
@@ -2204,9 +2282,22 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
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
@@ -2255,6 +2346,14 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
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
@@ -2521,6 +2620,8 @@ static inline struct uffd_msg userfault_msg(unsigned long address,
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
 	if (reason & VM_UFFD_WP)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
+	if (reason & VM_UFFD_RWP)
+		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_RWP;
 	if (reason & VM_UFFD_MINOR)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_MINOR;
 	if (features & UFFD_FEATURE_THREAD_ID)
@@ -3620,6 +3721,22 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
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
@@ -3713,6 +3830,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
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
@@ -3746,6 +3873,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR))
 			ioctls_out &= ~((__u64)1 << _UFFDIO_CONTINUE);
 
+		/* RWPROTECT is only supported for RWP ranges */
+		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP))
+			ioctls_out &= ~((__u64)1 << _UFFDIO_RWPROTECT);
+
 		/*
 		 * Now that we scanned all vmas we can already tell
 		 * userland which ioctls methods are guaranteed to
@@ -4093,6 +4224,55 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
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
@@ -4399,6 +4579,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
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


