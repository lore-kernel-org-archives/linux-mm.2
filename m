Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECF08C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9723C6B009E; Mon, 29 Jun 2026 08:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A8486B009F; Mon, 29 Jun 2026 08:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7704F6B00A0; Mon, 29 Jun 2026 08:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 41F5F6B009E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:12 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 95D2A1C6BEA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:11 +0000 (UTC)
X-FDA: 84932827182.22.7999CC2
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8E39A2000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:09 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="NBp/o/t6";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="T Ivpbkh";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734889;
	b=o142yMmkHtRgZ4QFKse8vmFSk/fpj8QLotoG3kKsyaxSotBkOkPuLO33B1x+xpaKlYFGh+
	A+uAk51XrqMCj5rQ4RJCK7HF4QHV9/HpGrNk/SCd4PZ8i5tOHV9iK5hmyYMNfTI8leXwer
	St6SLoDz5lyQuoZ8xsSDbNk3b/De4Zo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R2HAsvV2aS50vy0Ddv5Z9TIljsyWizztKXk84xdH2Ws=;
	b=BgqouOclAZyx2q3wyAQbL0bsQYRa8bE9N9VdfE0iXqeXSnr6Kk6doyQUSyWT4eXB2/S89j
	ld/aSkwpGg3RLW6+hns8LplEpMXPY1ZX4SJRvjNtEjxrhXawRYoRTnfcQl41ni/83o4KMD
	9BqdZZ2TVo+77nijjA5OhiafTCV28kk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="NBp/o/t6";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b="T Ivpbkh";
	spf=pass (imf03.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 1FF48EC0123;
	Mon, 29 Jun 2026 08:08:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Mon, 29 Jun 2026 08:08:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1782734889; x=1782821289; bh=R2HAsvV2aS50vy0Ddv5Z9TIljsyWizzt
	KXk84xdH2Ws=; b=NBp/o/t6buhJoW+3C4pue4ewmXqpXYeD79xZPpsWqcmCr3kc
	AYbJa7PrXjFkbqnA9MlkVYzW5c1XlPp2/2LVD4dgN/lRtqVW+WxbhSM4VEjcx+z8
	Tzkr38OoFZsHbIkMkq7DuaThwbJefkt79nZ8Pn22CQGyFyeHI+VWWseS+23tN89q
	qSBwQSkIlrBpVfgEUyY4xIRIooBC20Y5HlbpYucCW+3T9qLXd345BmAtoq2ixrHq
	IdRpP/ZY1WA4i1jN/j7XnHBfRLW9UldCqe1zwNfnZtzL846JCtUkwrYHwQ7pgBqf
	Jh11FpNeFtKeH9pZdfWhWOGH587TbJQXJXQYCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1782734889; x=
	1782821289; bh=R2HAsvV2aS50vy0Ddv5Z9TIljsyWizztKXk84xdH2Ws=; b=T
	Ivpbkh9zWO9Bc94f/hyfdihztvIE+vlq4JbQu2M/XEPYXf0Oz9HPsQlFe1PX7zw6
	5tUKFxG/wXRfY+uIsvaOUOUdIYuMMboJkwLLigwdd1FHjSeDwUH9OV9+0QXEt3re
	OKp9AMDGdatf/byT1okLMh9Rve0l5xb1DMFSHogBU4J+QWu6mK6frfGEE6/wef7S
	2+VMBiY/oXwnUDw5hOflNcIezPaSlQ0vX0oXVNpQ9pHzkHt3Y5DjA0sZeNbwPTnI
	tdAYPCBst/KbVcq08dLWThMpc0wBBNRpG1JcMZyJVbX77K8XagkHy5sRn98inE/5
	j7tUqkLTV58yICHUiiMzw==
X-ME-Sender: <xms:KWBCaiUimMRCzihi3sJArs3pg-RjjvwI6vgf97oHyKChuLu-16hyvQ>
    <xme:KWBCaigPusFom8hmwohtHbPsOAAnwNwgNnfSz1yWd0LaoQswt3UhgXpCiDF2eDNQJ
    UNorCmatQHjpLABVMqEvXx56lZIv2Z5kSV-t__zKlqvfy8dmHlHnF7n>
X-ME-Received: <xmr:KWBCau6jc5fHwBTHT0Sla6O3ZgyB573LN3X85iRl3vfqLdHyUD4c7b4SCNsmMA>
X-ME-Proxy-Cause: dmFkZTFY9msGIGksnyHNhpdpiL2Ew5X29ZHd8bcNS69STRb5aokGzn5HjcNIwS0kCdENba
    6SlKS6wYtn0p71nlzYZOVLykStl3Q2hkfL2qEQk188rowBgd6iJn4CFsTORvSWNVZxRMM1
    nHLQZ85PvsMHeuBoK4lGcoG7ioTf2JyHtEmBF8if6Po43U8CzIy3EHWnFatxau8M1EpHaG
    Q/+3pCc92/T9ahokkjka/kvSk9kXBX9TD1WGRiS0Ovdl5ja+ZagisFwLuB77wgF7Biblu4
    rAPyGMWqZ/uXWIWLV+CKn7ltXGkWhTX9CZOX94EvsXkl37bIkkGVOUTt/qEVtY95e0K8ZB
    lr+FrD7SfH0cTZkpv8m8icbXrku/bXyCHLD0oLW6ZZ2wEuRtpg8jX4m5akkXPWq7JV8wFl
    P94/F3GsrF8XSDi1p5an4kYPL/vIuxAK5m16vC5qmDNhWUcSPkVNTPeUFR44MVGhL17qja
    Fca1kTJzZfTuihu0QWq9Le5Tc+Nw/BVx39WcHppIQEfO9BjFLFftBAeWViEI5SUJtnEJtD
    6O9C7d1O9IoukIzwvAudExxwVYA6swCQL8iiUGqMDlvyRP3EoQCBz6XWui91jQlU9raC2l
    oeVNYoyEpsuCEuXd3UvX+74zA3V8itZStRQ1DiJFKhR47Uv3GXCzj58RQ7IQ
X-ME-Proxy: <xmx:KWBCai6xyFb44jaLFpa6pxtamAV5P8WnVCzHhHFoxjz2S9fJBh1Emg>
    <xmx:KWBCakEX00tXZ7G_z9Un5Hx4w6IRm0NQhxhZKg3zuGUErvWJFzSrhg>
    <xmx:KWBCaoxe-rzN_hcLGtqksHYmv_eW0YnzfHxlmSWD_0BBxZiSnHP7Lw>
    <xmx:KWBCas0vjUjsvkB6BPnJktw4M3xMGI95nlv1Js-L4d_WOb2ZoIPEvw>
    <xmx:KWBCah1yFYxZ4xqkK7USASRRGR6QxtoTkmbWT3qEtywJCOt9QpIqlwTW>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:08 -0400 (EDT)
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
Subject: [PATCH v7 09/15] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
Date: Mon, 29 Jun 2026 13:07:40 +0100
Message-ID: <20260629120749.566063-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: gu8cg6nxmsqt5dssfeadohfkg4gbypnz
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8E39A2000A
X-HE-Tag: 1782734889-925684
X-HE-Meta: U2FsdGVkX186G4oUQJmctf0hjclnvv1SJvIlxau1o6rBQYY/fLZI4rNk0DZ4zuAubpz9PcB8ArSGl+NTaKkB0+eUTsNPHIgsGJzkzGZr1U3BdoT32/lfse5NsQoeUZfmx0TCw1oWK4PaNhkfk33U/Yy1mEw5xmq5Ng4PwiQKAtc5DVkjCQxMnDlFxsV8TH/CIuFNmHz+cfHmukBHnqBvuOShObJnvoay2myt/QxQqgzhtqeCilbq70DCsgR4zS7L4x0wsu3NGqqoV3VbIgiHOeONyHbr88l6l46w/qwOr8XhjU7f3Up3M1onWHUDEIAp+MfoT0smDSP9tpNYP6gyNXmwT0Rh/uPAWFBJZK7qTevmpic5/s//hX1jB6suRYNOFvyl8cEjePQCoh6KmhYP9rv4ExFb15Ka9YZqpEJdfmUGRjTQP3V0AnN1mSXaal8CM09uRkcOztdBWcIkGl9WhxFd/dYMubyGyYUkwVtJEXwpkNXGL08nIkc1S5r044Oa6hrVzt9nU2XDS7XlDWMrDPZULqggFLUL/YwgEeYhA5Y+fEjGA3Fnz6vsaojw+0YjgV00FiFg5eParl0i6tJvRdFX3v9lYj5IpHkhx+VbtDpYBgFoxaVGBx7XjaX6VMXmQqyh7n8HiurqXqof4AcB+GtrrUbN+JMxuLbZU+ZDx6UkHcS+vc1H11lHvxvAX8tBa/LZJdSRnSYpWqcYBfT+gzWViNNBJPssnjm7PbZ+7MUzQomEZKYR9gsBugg+VuJQURJcEg0Lnb4A74wSi6tBBsBD4tqkxA1bdNiOzkg+NpK9m/eMqb+1bleVajbpxHSMQEFHFI9abktzxK+L3vnZKzzZbn20Ni4qbro/VnVsBeDwul5GihzXA+mOSQ+ARV/hDKJVAKV24TlG7nbBmfKe8cfv5OZjaLm/bOOCSI4Oso6awdyTBmwV47/DoNGXsLw57dwzL9PDtP70OWRIdlq
 zZctJjj8
 8uFYuU4sbljOvk8Y/QG46C5zFmjRztR/9MVMeo05B6ooNo0Clc6cGGEUwFh9LFKAR1UkzOSoV9mNIa1Hp1KxfhpF9CiQuXHjiYxr4DTbqlmhucvPKlDEIPklMAJ5mOPD3AHPW1xMy6k6BiRAqJiE1/zJajCdY3dy2AzWPUvUD8TEgo0SZkzv/eXlXbZXvORXXrP3Xh88gO1Fy/yRLvKB0gxsdAF3fmDXZPkzdzOU8AUEmzc9ug9j8tz2G7ycGe40Wy82VO+SCE5A01bJ0fEgJyaHb3XhzX7ql1r6L3w2vE0lrcfw8qSN7054EHg2ac+0dUgC/NZljJrOx7nbxSNAwy4osixGyT32tQcA0D/AOgz73lWeTZoDsALM7OAKvld0dcZsoq6zUjoIgbhOFmu/WDHa4C/73gaKfYpRiRDCrIwWDW81FQNfxmXoUHB86kB1eBmDoqKvnY0i9I9Mo/Gy0WGfvKzt/8xXyIktJUWliUYFNOnC9SFhVgr8gbzBOiMm9H3wuIA28/ZArg9C06/4gehqi/Q==
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


