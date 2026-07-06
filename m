Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3995C43602
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 08:48:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1DD506B010F; Mon,  6 Jul 2026 04:48:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B5866B0111; Mon,  6 Jul 2026 04:48:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 055FD6B0112; Mon,  6 Jul 2026 04:48:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C36D66B010F
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 04:48:33 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53999140321
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:33 +0000 (UTC)
X-FDA: 84957725706.20.2352328
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4EC8518000A
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 08:48:31 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="OI/OI+3S";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="b 4bPuIx";
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783327711;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TFn//N8fQKZosEpgVOOvzlcTpwp1+i03hvLSIOqeroc=;
	b=uSSdsLFb5oTTpcBy/gpT0P+0gZk55SapdznT8u2XtMcL1zJ3q40Blo7meJH36ber588CS2
	lSc4+/0K4cihafbbOaYgYsqJqzN1mgPwuIcW42Ip7cztYwAtH2CCZhHj1s/P9u2l+fxy8E
	idEqrsYs+oLf5xemWap+6WPFJCksbso=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="OI/OI+3S";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="b 4bPuIx";
	spf=pass (imf06.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783327711;
	b=wc+NupYp4nJto2edGDAgiPZoBuJHplDsgNX1CNo5byeywRm+/ROpbw9TqsPzeBdq/xj2r9
	bKEr+Ltyc3vo/sy2AT/VLeoylk8ysttmot5SaZbtuvQGI/cujE0vz3j+BWtaK0AIl0+7s3
	IczMpOpf0lTkCLI8V5BmnaRyFtJbnQ0=
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfout.stl.internal (Postfix) with ESMTP id 2A1221D0010B;
	Mon,  6 Jul 2026 04:48:30 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-04.internal (MEProxy); Mon, 06 Jul 2026 04:48:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783327710; x=1783414110; bh=TFn//N8fQKZosEpgVOOvzlcTpwp1+i03
	hvLSIOqeroc=; b=OI/OI+3S5ET4UDYDrjKZUhHbJIr8doBJ6TRpUNvHE15zeA+b
	sk3oR7P3tZeSVuqbG52FnjY06L69U8nhzDFNbf/MimLCySofyxqsvUIQMf7w5eaA
	Mwt3btC4jtTAvN8N+rBZ3RcBaB73DEzTRHiSlopgvkKMVDqNpM0H6l20l+KhzPun
	KH1F2moGs+xbfex/jnJjiQTOub2Ur2TDURjkhMhDzz+Fsq2sq9QM41Daz3n/Od++
	9JFIxVEmnZCahp5z1eZFfkXDuCUmLRiIqxe1u2G59Y3fV2XnJeH8grBIbO8IBGmG
	FInty8faUb6JYP3uQz9WdoDrWrsxDRJNxP8W/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783327710; x=
	1783414110; bh=TFn//N8fQKZosEpgVOOvzlcTpwp1+i03hvLSIOqeroc=; b=b
	4bPuIxn7qVoS8Wv04Xu/BWE5QFMaeIjVRbR2L4VA+j4MVvJbsR10CNu5DADBgqdY
	zUsJlR94zAtPhjKjxiNVAmRJi3yptD2lp6UrynuwdiFb/nLWXFGJDwFq8+winysS
	vDPEdty1onfKJ8QSCU2JxDT46e4nyoblI3vAszA7kMQ0kCFMy0wgmPvXy3KSdAaR
	sz8coK1RGFTdJ4Sxv5ZDuyzj7agqdOnMbtfo1ibvWi/tdgEuLdrSvhfmEmSvhg0H
	w7NNDdXluJPqptG0feGe/wZTwPoKtXEBKl/yRJmvC+XdNYpZL5FnXLMYSna9aSng
	OCdp9lqh+Jz6E45VQHWgQ==
X-ME-Sender: <xms:3WtLaj63ZorbI7Uj8o_SqVC4OGgWjeI9xGXAsbac0A9x6A4cRvf2tg>
    <xme:3WtLas0AsLVxENgKT9jfjVgvmha_mw9HAfKPp2N888gx3_PsaV-VbJY9ZmfRUkLh3
    awwz0-OTOlU-V9ohEWGqngXriTekO8syFjp0Wmhyr10UaABpYZbiLo>
X-ME-Received: <xmr:3WtLai_FYUh1C5E0lBoJBH-IDSSbS4zKDGIcRH2TuDkLBgiG5zdKrRdrf5NIJA>
X-ME-Proxy-Cause: dmFkZTE1HAxrDWJcKyWNBJ73THul+Pni1RTBd9xrf0khQ62auo02SuQ5gbJLxkQ3Qk71Rt
    f+PGPpiBaizNM2SZ8IrfQsHK3gYtMHoaCLmDTUWsgKKZPvRJtANNe6dp0pRFbSzpZ7Ir68
    3/In0zA3QiBz7VSIJWGJB30Gj5LF7PccEnLnCBfRMAcd0Ruq/WMP2imG8KXscpScOVRs3e
    Q/wFiWTRlZPXmNZzwwnPakhtvrKLPp/eIv/XhxcMzd3pTWLxn9+uixyv/f65anc6A7PACd
    VPXopYse7MIZNJLH0eIKl8RFUktrN1v664xHjciMcFFYVrJqWrPU6fblfiG0/eGu1JYQty
    fKwH0bomX8xk7ObfCyxJgoc9E7kJ88J9GCRGodL0AJPe0u4Okh+MVzmomJzJaQem14iwrh
    Su/sJzzpxQHgEboMnLNFkh4XrOSp6K33+/Eq92cHv9ga4HzhuQpUkIr4Fot2a0nCFDd86P
    MRMfSLdNOIu8T2bAFun64YHMokSfc7SdMYmqrh2zQr1HuMeecM0K1CUpiLuw5G5zuodTgW
    /2vKfu2jUDkN+pMRffml9fcCCKXD/ERwsS/77XDN5TwxLpPgqEK7knqeh1mioqQBSbECxN
    0VwGjJHyPCMNtfWSddh3V7qbH/v+1/f/L94Hs6lRXQmsO2ouJtn2evOfUihw
X-ME-Proxy: <xmx:3WtLats_-aOpIfv9P4VaVJCALhgWaffz5OsAtaTd6urTMMe4eXDmUA>
    <xmx:3WtLaupEK1fFJgoO9jt0Tx3E1Cc7BEdIskdBVUdB6Pb6p3XXaQsuHA>
    <xmx:3WtLaoGlV3BRujfNhG3KCHYxWEdg1PZ9Ld6Ca4n71E-B0gg_QRLLdA>
    <xmx:3WtLah6E4FSQ6e5Igv0ZHpl0zp9XW3C2G3_HJpwAjNrH2iSuE-hC1g>
    <xmx:3mtLam5x5T4GxhD7SaeNQn0FtDIHDZsyoCDbiqUaSeSySykCcFYGL_zd>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 6 Jul 2026 04:48:29 -0400 (EDT)
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
Subject: [PATCH v9 09/15] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
Date: Mon,  6 Jul 2026 09:47:58 +0100
Message-ID: <20260706084805.8400-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260706084805.8400-1-kirill@shutemov.name>
References: <20260706084805.8400-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4EC8518000A
X-Stat-Signature: 5e375kseyzccebjpizzujpq5tbdtqy93
X-HE-Tag: 1783327711-896902
X-HE-Meta: U2FsdGVkX18SvcFmxSNmNpoBJCIKgkLtryfZji4/tXf9VQ+LnEG/J78uhxuW3F8yZPm0tV9kdZOZNMIgsBGrLYSlUqvyVxaTtX1QTTXq6dpeR6YWttNvwIVZ+OBI/66n0wYTBri4AdJqhNJ9+0YrNje7Q4udzujd1YVP14WZZbQ0A+yv2dVgJK8GO+3OjChRtuDivT0LlU22J2wsOYU+Mz7nleGM0WpkGRkeKF48PLQgRHLL9mTHSWOUZuBPvohtHXFBdsqvs0zru2LtYWvmzJXgt9KAepzxL47Al5IOz/9cKtSeeqkPUysHUKkrZxVrsIL33Z1ZZ+3s5SuZlUJ3J97BjER9B3k2n8FyLS8yuVUENQa0RKYsTmT0IGMUILF1igVfpR4H9mylKagrPE9PqFSucrpbf8VR2c5gHJFcptxw9OfY4NRc0m0h58fc7GrEH7LDRAXmLpX/R8HwcyVgvR9p1HHOLdlB35/Smun5xJhjMyA0Z5qKvo4ZBbyeZ6dSHaVhS6kimgxaF4EiCq3nC/SMlDi+/vi3qzkkhgJvMvwy01UndcVlg/3jMylexTcnTG9FI8lPcIrIM396DPsFNMUAj7i8LH6HfKnH6noJOKmao5/J7rm3iL0ZF8/eBpULud8CLrWCywow7BinGMSi7rcHD8RvqgPfqtsdIaJZRSTG/SPCZ4SOYkSwJ4mMZBD+RxHe4BQ5fKFOyO/Yecyd4J5yWCmNsoI11534j1IuN+q7mFhOznjq/KQd0hE5K+uUFUpHcqxJrtMIB0d1R7PDog6U5hjuRmXjqe2CcIzLi3vXuNCGC43DL5NzZuDZb4jB1lc+E5aJovJb3PFWh8WrW2NPSnZSjRW+SS1SvV4HV+xqedn4VcBit/W3X7cvoGdMMitN23rY2XmyXJ/2g59Qlo5r7Y8PIz1XSsW3U68XdIno9NnKtONVk5I+X+h+u2Y+xqJ/l0tcgHsuZXjaOMQ
 +bGOxPa1
 abG+NNlxzefH3xK/kfhj0WKNxIsgD5+QupTo+UgIVzCe5JhoBkUrsbdiYyDCBZYnafqhAVXwb2LKXYyYHRmMmLon9C+XuhKjEB54cVpT/NHxW6hzCPy6HOzfAavbAETdIlC+VaaNTtnRBZHlJQa7JQJeSDDU4qNzfLjAJoFhOZypcMOpJcQAOPacU+wr/bPKUcTp6xnnxfz/0y91HHrMpmRfEuUQNCXuxg+ECV/RuS2oeoFwQEYDDgFJ1L8gPYpa3T08FOpjD76E+dOMvwKGGXvGHsckEgw9GU0pEP5U8qAA0KRE642W3RQHjTTy9jQKOhpAOrxi/+i+NWakZBQ62iuowCapXs/+OAWDrdT9LYsF4qjHyGq2KdE46jg2Y2epOmpV/2MYyE/Mdr0eRKPWglUBblmy5MjER4PJ1uJdFuTAldSJLKOjB5XYscDJ/8QHfHVYv6Mri7m3/HM78ta/YPDQqz/WxYPJVoh6jTyF39Pt2mdibnQLLHnQYA0WdgWOz2mDQsq8XIAeS1GuWCyeFvulG4pAYZr/ijh5beBUZPecbI7MK6Uck+acDbvz+/1m1ojIWf7DG8irw8bMxXWs2naqBqUYFnCTkLxsG
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
 mm/userfaultfd.c                             | 191 ++++++++++++++++++-
 5 files changed, 228 insertions(+), 3 deletions(-)

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
index 0a0763c6e9f4..d31648ba898d 100644
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
index 4fca0409b7d7..ff593b5d6eed 100644
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
@@ -2204,9 +2273,22 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
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
@@ -2255,6 +2337,14 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
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
@@ -2521,6 +2611,8 @@ static inline struct uffd_msg userfault_msg(unsigned long address,
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
 	if (reason & VM_UFFD_WP)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
+	if (reason & VM_UFFD_RWP)
+		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_RWP;
 	if (reason & VM_UFFD_MINOR)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_MINOR;
 	if (features & UFFD_FEATURE_THREAD_ID)
@@ -3620,6 +3712,22 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
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
@@ -3674,6 +3782,17 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		if (!vma_can_userfault(cur, vm_flags, wp_async))
 			goto out_unlock;
 
+		/*
+		 * RWP uses protnone as an access-tracking marker. PROT_NONE
+		 * VMAs have vm_page_prot == PAGE_NONE, so RWP resolution
+		 * cannot make a page accessible again. Reject at register
+		 * time only: a VMA that later becomes inaccessible via
+		 * mprotect() must still be unregisterable, so this is not
+		 * part of vma_can_userfault().
+		 */
+		if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(cur))
+			goto out_unlock;
+
 		/*
 		 * UFFDIO_COPY will fill file holes even without
 		 * PROT_WRITE. This check enforces that if this is a
@@ -3713,6 +3832,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
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
@@ -3746,6 +3875,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR))
 			ioctls_out &= ~((__u64)1 << _UFFDIO_CONTINUE);
 
+		/* RWPROTECT is only supported for RWP ranges */
+		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP))
+			ioctls_out &= ~((__u64)1 << _UFFDIO_RWPROTECT);
+
 		/*
 		 * Now that we scanned all vmas we can already tell
 		 * userland which ioctls methods are guaranteed to
@@ -4093,6 +4226,55 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
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
@@ -4399,6 +4581,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
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


