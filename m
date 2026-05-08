Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD3DBCD3436
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 15:56:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E226B0197; Fri,  8 May 2026 11:56:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1357F6B0199; Fri,  8 May 2026 11:56:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F19AB6B019A; Fri,  8 May 2026 11:56:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DE3CA6B0197
	for <linux-mm@kvack.org>; Fri,  8 May 2026 11:56:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A60D9401ED
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:28 +0000 (UTC)
X-FDA: 84744704856.28.4760D48
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id ABA4C1C000F
	for <linux-mm@kvack.org>; Fri,  8 May 2026 15:56:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRjri2xP;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778255786;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9ma4azyUSsghhEGYIgwkpSCFBtsaIW96PcZ3ihQVdi8=;
	b=F47Qlx9ejIDHca7tKkAhW4Hw6baeFqLrO2tzfpyXS2i6EhuS6TTrG/gSQnUzUEFakwC+Q/
	Pru/M9lk9s0q+Ri2RQgtuRPSYX2cfgByOTb7MD3ldAGiyi7I1Oxv4JbaQCMh2O6gW4P5No
	1MzgxT0DDG1k+B2ErWc4SXzq5yHIqoY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IRjri2xP;
	spf=pass (imf18.hostedemail.com: domain of kas@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778255786; a=rsa-sha256;
	cv=none;
	b=0n3QjNSZtDYcaPVz88ZSCYw+vPpMWRiACs5+Rx8WUgnZ2CewZKb8lENWNLf3zN8OzYS/mn
	uBKjAZFTML/Wa2kL8bVKAq5raR7EWGxEv4GYVXsu3qAsnhMByPq5zKVJmXa0KB2F/63zHp
	MkS9TlEMJ1uFEc/m+lR6W6Ok+55/8oY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2AFB36057A;
	Fri,  8 May 2026 15:56:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F83C2BCB0;
	Fri,  8 May 2026 15:56:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778255785;
	bh=JzhB0eJbGbSZzPE+BU2Y8dIhlMUK8h1EeM1miWgAPQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IRjri2xPMkPLl6VL0VhQiAWUysu+IGcrZjxl2D53V9MVs9AZMc7F4KlwSEO/Ru9gT
	 qVZsq/EdCDbXLxhoaxrJzdD8It5tW3vv2fsv3nC0KPupPjppcMElrbtevO8HPzwfTX
	 NArr3bpHS+/hjCeDD0Jj7NdZ/IwaMFjtcfLIU6nBHpccPUWm5w/4xgT/k4537uyRvZ
	 5/+A6qeOcEXuhdcX8Aj2kgj/1TA7k8wElcidmZNSsIxDpr+DlZ9ZI10xnqvHYbUpxj
	 KSH+t1FAi4P8jlrGxQ6wswxEjrJv9U+78r7CKan3YOJ5KXxO1jL81A5bxlQ1pJLQX1
	 8ccCcd8XgHclw==
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2E45AF4006B;
	Fri,  8 May 2026 11:56:24 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 08 May 2026 11:56:24 -0400
X-ME-Sender: <xms:qAf-aZlcv28q0MMp-tmOePyQvyphzGXybHW6DaOCJXWX89tWJpxFDA>
    <xme:qAf-aQsjddWRdBxH72bfLvzfXRQ4uAtUR_booXvuBraTHwB2b-5jKqMcBqHaPJtrg
    B08m3prGYp9LbDxd7N_tm1rrU7JRs03gqsweY_DcZNhzfSIdMerKg>
X-ME-Received: <xmr:qAf-aYfeW2qnZJQ2kR5ZOCjPKmcR7Th06ImcEFpyTMUaj8rtrHDq4OXNjcZoMg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdduuddtjeejucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucenucfjughrpefhvfevufffkffojghfgggtgfesthekre
    dtredtjeenucfhrhhomhepfdfmihhrhihlucfuhhhuthhsvghmrghuucdlofgvthgrmddf
    uceokhgrsheskhgvrhhnvghlrdhorhhgqeenucggtffrrghtthgvrhhnpefhvdefvdevje
    evhefhhfevudefudejfeduvdekheeludfhiefhhedujeffffeigfenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehkihhrihhllhdomhgvshhmth
    hprghuthhhphgvrhhsohhnrghlihhthidqudeiudduiedvieehhedqvdekgeeggeejvdek
    qdhkrghspeepkhgvrhhnvghlrdhorhhgsehshhhuthgvmhhovhdrnhgrmhgvpdhnsggprh
    gtphhtthhopedvgedpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtoheprghkphhmsehl
    ihhnuhigqdhfohhunhgurghtihhonhdrohhrghdprhgtphhtthhopehrphhptheskhgvrh
    hnvghlrdhorhhgpdhrtghpthhtohepphgvthgvrhigsehrvgguhhgrthdrtghomhdprhgt
    phhtthhopegurghvihgusehkvghrnhgvlhdrohhrghdprhgtphhtthhopehljhhssehkvg
    hrnhgvlhdrohhrghdprhgtphhtthhopehsuhhrvghnsgesghhoohhglhgvrdgtohhmpdhr
    tghpthhtohepvhgsrggskhgrsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehlihgrmh
    drhhhofihlvghtthesohhrrggtlhgvrdgtohhmpdhrtghpthhtohepiihihiesnhhvihgu
    ihgrrdgtohhm
X-ME-Proxy: <xmx:qAf-aSZcR9gSa0I-d2KG9XLAmkYotb0hauGbjoVjrpFlRkGGW0VJpQ>
    <xmx:qAf-aQ1yfRnEEpKE_J2XcWS9JKUNfJ_1LnVump0MBuBblZk07pZs9g>
    <xmx:qAf-abpjzkgdoZNVd7OPRyv7C8M9Q6-FmwszPd877e0BRlMeyDtI0w>
    <xmx:qAf-aRzBkwEvMpWm7JjSlOrJLn045I68hq7J2Iapzog807BcDG4OPA>
    <xmx:qAf-aUCtguHzJs-ryn-vxamLRnxPf_X-oMZ3HwwIZMvvEyw6IgyJRsdB>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 8 May 2026 11:56:23 -0400 (EDT)
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
Subject: [PATCH v2 08/14] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
Date: Fri,  8 May 2026 16:55:20 +0100
Message-ID: <1ad0cb61a7b5a33a5375baadbd0720ba2ba43d2f.1778254670.git.kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <cover.1778254670.git.kas@kernel.org>
References: <cover.1778254670.git.kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cwbtthmyx7kybc5cspmmugwf8tmcdjew
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: ABA4C1C000F
X-Rspam-User: 
X-HE-Tag: 1778255786-967827
X-HE-Meta: U2FsdGVkX18IzzX6YEyIgRZmy6tbOPA/YvqB/5zbJk/pwPdWjcRXeo+Ymiv4OBul7gy64/4OCvtDU/bqneWIHqjxjrj+pvsCfN3bmI/VHz5hjWurK4peCYNMuL4vi0y/nPLaKG6yrK1FSFG+9WZyrHu7zln9Sx0KYCeAAVd9v20KxFuTJs545EEapBm00HGtRUHJ5DR11XFvNkyNBlMoonSfxCeo5Gx2wAjllVePWuE16JXHKepzm+EynI9LW+JAMGlxtNHU/WCOGlc//DqtG0arsUDlIGV+awQDN+8DIw+Jr0/nqLfmeQYdeEdoJjrClhmF8MmK55GNS06TRF2m8DdHkxIz4q1AanwiXGhR7H6+3LxYTKCR/Xw0/R+1bwI3n5KJJ5EfhoYHNP9XtwonIHsfXoQe0dY829GQZ4Mfryc07Mgk9+taG/0EHI2NR/SPoDvqnb3JhDQpKP0eB0FKM4GJ+qFpcWUTdItt364v9LskTAXyP66hzwprbpaRImK66CPFfk4xmq4gLD5/Yw3yWlNDdh1fv3JmYoDxN4iN596lt72w6DOBl6oQCbF0WaESFv11uqVCnWrlm8DvwGeoxQvvDpdyscO4RpSZnMw7RXE6JdmxBEGzEWiK2vuNJAhRw4c6huArnCEAEMkDzcs31BAHCpIyr8szb1ZXS6NnL39zgnagottuw1A2b4hyevrSpdk9t/8pWoK9vcq/LaRg/bcrixRQDm9UUgwVQpWqzTtCBfLnNdvBajwHn5Rhl5MQMZYgFNrMdiLoXLi/7WyciYKdtzS/zxLjS17wvVqIIMPWM5Ddud5EIsp/8vGMaFKRg5Lr9j9+nbPU6X9qxWIfpT3pVkNx7lrKgnXMc8S0qGFemuQGMNzsLW2xU9ieIqD6h29pS4BUQ38wiVRgubt5HqBm3R1dQj7rfZHAZQPjxZPamk9I/kAHI9gZCC230xpOpNWSk9KZZeNHYBwO975
 bZgp294b
 txK9aFZAGTLXZT292TIMKTGB7B63ALzKCIf1csMEnpWXmQVTdzXrcSnRpgmFBJe7DJOdQCJtq/wpITgk/y42RO++nj2FvwNpjKmqsLIAv23LYbViML+4GXzrckFsVFINFSoltvPUGafrHOkao5v4SvuX2acL551KpTasX9Vk33rj8kSoe3xqi/uquLdJ0Kul90GKkH49BMpY6eTBCnATgQRGxzqok3m4G5essqxYlY2hwUUWa/7UQP0HiPUwoKJEtNIbLOcmMdJISQblH00BO4yJoOZyT6/4i33maiR2lK1yLmTFhYJoFTMTGto41LV6uzkC26+uULl6WtYMCUbVFTbdkqQ==
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
---
 Documentation/admin-guide/mm/userfaultfd.rst | 10 ++
 fs/userfaultfd.c                             | 84 +++++++++++++++++
 include/linux/userfaultfd_k.h                |  2 +
 include/uapi/linux/userfaultfd.h             | 19 ++++
 mm/userfaultfd.c                             | 97 +++++++++++++++++++-
 5 files changed, 209 insertions(+), 3 deletions(-)

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
diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 0fdf28f62702..f2097c558165 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -215,6 +215,8 @@ static inline struct uffd_msg userfault_msg(unsigned long address,
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
 	if (reason & VM_UFFD_WP)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
+	if (reason & VM_UFFD_RWP)
+		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_RWP;
 	if (reason & VM_UFFD_MINOR)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_MINOR;
 	if (features & UFFD_FEATURE_THREAD_ID)
@@ -1292,6 +1294,22 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
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
@@ -1385,6 +1403,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
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
@@ -1418,6 +1446,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR))
 			ioctls_out &= ~((__u64)1 << _UFFDIO_CONTINUE);
 
+		/* RWPROTECT is only supported for RWP ranges */
+		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP))
+			ioctls_out &= ~((__u64)1 << _UFFDIO_RWPROTECT);
+
 		/*
 		 * Now that we scanned all vmas we can already tell
 		 * userland which ioctls methods are guaranteed to
@@ -1765,6 +1797,55 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
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
@@ -2071,6 +2152,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
 	case UFFDIO_POISON:
 		ret = userfaultfd_poison(ctx, arg);
 		break;
+	case UFFDIO_RWPROTECT:
+		ret = userfaultfd_rwprotect(ctx, arg);
+		break;
 	}
 	return ret;
 }
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 3725e61a7041..3dfcdc3a9b98 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -162,6 +162,8 @@ extern int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
 			       unsigned long len, bool enable_wp);
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
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index d4a1d340dab3..8d4317ed6e85 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1072,6 +1072,76 @@ int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
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
+	long err;
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
+	err = -ENOENT;
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
+		err = 0;
+	}
+	if (err)
+		return err;
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
@@ -2109,9 +2179,22 @@ struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
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
@@ -2160,6 +2243,14 @@ int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
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
-- 
2.51.2


