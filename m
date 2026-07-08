Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9613CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ACAC56B00A3; Wed,  8 Jul 2026 07:14:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7DB46B00A4; Wed,  8 Jul 2026 07:14:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8F7E76B00A5; Wed,  8 Jul 2026 07:14:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5283E6B00A3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:46 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB231403AB
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:45 +0000 (UTC)
X-FDA: 84965351730.05.A51C790
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf26.hostedemail.com (Postfix) with ESMTP id BDF88140007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=LMnv8Jye;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="j RBbhe7";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z38qT6DEcdmSy9ymbHzqLrw3Uz/9WEQcmj+4hyFcDY0=;
	b=7XyUZW1QTI/SdwE5scq8mCIhabupp9xlqENE5Rk/16SISl/xHCOs80GV1Cq4YH5aA/rphD
	HpKb8t7YvCRejXE5UYoSzLqwhwsmmw3IGDM7pN4wkqZaCY9UD8NlkxqbG0S7csB0zmKDgL
	donXZLoxpNdjF1L2Q84hqjxF9dpeCsY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b=LMnv8Jye;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="j RBbhe7";
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509283;
	b=7kGhs5X4Ikn23BBqJ11YSP2f+/wovh1wgF2lWwb2ve0kbn4xYHv1C7XH5pZTB59fkQhLMo
	xkKbTJiGl3k8vH4a+4P9fjWM0zoLcXGEBq8stU2EKtd/Jye2PtKX5qGhjF66hmwNcBSGVI
	YO5c3qk9KQ6biVZ80T/19mTK1Fbxz+g=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9BFCC7A012C;
	Wed,  8 Jul 2026 07:14:42 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-03.internal (MEProxy); Wed, 08 Jul 2026 07:14:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:content-type
	:date:date:from:from:in-reply-to:in-reply-to:message-id
	:mime-version:references:reply-to:subject:subject:to:to; s=fm3;
	 t=1783509282; x=1783595682; bh=z38qT6DEcdmSy9ymbHzqLrw3Uz/9WEQc
	mj+4hyFcDY0=; b=LMnv8Jyet1G3aCI1nnV6J6348azbBL9cfueWaCcvT02P4Gg+
	RmI9/dFn0PfoE8OM5nWKHfEqj1bMhODZJxwYREE12mjsp2Djf0h9stRB8rfwcoP0
	IWLpcBxSH32Y25DMmR4+krvapMNkW4VOesSDjEFmxGdf1CKijg3erGFZGwBOXvo9
	YVDtyUHo6hMcJagt2mdt1jQZn37ypXR1bgzsNIAyET/cN5kirARU29aQM0G/9CJi
	3xYi9srEg806pr7O7eaXazT35WV/kB9ROSaR4Zi2SCd64KR3WeXxRwltAIyWvxco
	OMpYIC5adaBJTiS2aF8WmUu0xzARJy1VEVAEug==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1783509282; x=
	1783595682; bh=z38qT6DEcdmSy9ymbHzqLrw3Uz/9WEQcmj+4hyFcDY0=; b=j
	RBbhe7yy4YbcfeBZL9KFP+u+X5rvXSQTLUDR28IMH9TlA+v2o+b5/ZvElqaKE57d
	WVYtLJlsbqUSX8gGZJnxkinty+manmttNYhy/vwnE1DzJkvMHnEa0f9uArQm3Mag
	4li/PKfvIDrj7lOIb8hL57DTqxCmTZ9qujfwk37R4hdhOYkk/MDaQJ/0eUhsBrYn
	08bwqqEhBQlwLSqLFQEbt10LpOgPqPMYZVKo4MbuVtOOcXk+IEE9kV2qbgtfbenH
	FgCF3DhaG5v07l5QOHiN2cun+G66ZQfCGQajXuiz8Cqn3YTnGphItXb3ETKKvjBX
	2OzSoKshkmYuejvx1nrJg==
X-ME-Sender: <xms:ITFOaoR3krtwsfBxeRfs3KlYMbbZTsM7OUTbG5-yKSJt5mQtbkcH5Q>
    <xme:ITFOapvCl-iH6LM7zg2W7tlovFjNFmaMd0t72HTMHeKDxLJ8aMBiksmhEvjO0qzS4
    bX_iQTnll31e55qnqIJJ2OtPgulne8Kqi4sNFfmP_KtYuRMMEXXU4I>
X-ME-Received: <xmr:ITFOauVdFnvlHhD5M7F1fiYltBT4IaVsT3UnIWH4Fh922p8ZT5kU_FZvQqrd-w>
X-ME-Proxy-Cause: dmFkZTFUNIYXC0Q5t8iqxsk5x/ZZMsEDxIoZnWAQZPTQe2TvhnM3yGqaiQbzxnqs+7JIiR
    Yq5XhJlRG8HRcn4TzRiv2EKww24qGo2vzTE+dwYEALdjzUu9fkyEySz6S/StK8W84OHvkq
    W9bJFACiywJM+FHRWARKJSxsj/OIv5i/+BUkO9YHMo8DRu+y4pegyGixo+73/KOUD27j6H
    5pOE/wzQGFm6/nPC8g/bDVffg3JUC2YP/n7l/I6zXixgasab/b3ztmwGVl8QyMOBshJvPS
    ED/XZSrmnCYJ6UGjCdjgdYCVYCbIESChWLzOeM4GIrKC6PPK50eSw/FV+ttn4eLfWIUOfV
    dbOwITEhoKQWpZYZ8ntL3VrYQExOXjgIIyVX9ha3yUT47Cj/b5yLG50/LRotwnK54KNn0L
    WoPkQge+GcTU1gjuXSzz9M3XncurMCV+Bt8G45wy6HbRlM3Fx8UYT3YEnfa+ubzsWzxG5e
    WBk2IixQIAarhBtugtvxyFyXAa3qy5K7VRgzv2xjjoyJsDu97TqFdiHQhNcEKvPoXXwpWT
    vRX3yfWZRfgRW1iUv4KwAAOOr81lQMPdy5tM/7zknIpitCPE/uJIZUI7aroKjFstFXaitz
    cnkzgKSgCIQQFbck1ize/uweU75kK3UL0q9mvpjwdxgw47m0KAxgYz2ilvWw
X-ME-Proxy: <xmx:ITFOalnJ2Rd2wSlsCmPodrKbuCSkxFZkPvG5csWuFhReExfxjUvflQ>
    <xmx:ITFOapADdW0LAMPP7Rp4arGtr04PzghHVpkfwVB3J_2HzEE05ep8sw>
    <xmx:ITFOai_2DuTChwxY07Jx6u-m_dtVLa2LE2XiXt_FtWm-BYqjxLnrvA>
    <xmx:ITFOajQy0pDR229kd-MDFXoxaqNswLAU4i2Lam03Ow1QI70kp5pJHw>
    <xmx:IjFOaoQx6uIBeOHSDwcljMOo8iwxDkYvHv9vgYeCsMSAtjyFGQlrRdBu>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:41 -0400 (EDT)
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
Subject: [PATCH v10 09/15] userfaultfd: add UFFDIO_REGISTER_MODE_RWP and UFFDIO_RWPROTECT plumbing
Date: Wed,  8 Jul 2026 12:14:10 +0100
Message-ID: <20260708111417.173443-10-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BDF88140007
X-Stat-Signature: ss49wa3d7xs3ighy7taz5own9pfibyif
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783509283-750111
X-HE-Meta: U2FsdGVkX1/lO3ebGQZn7ScvrJmFDKCTu8O0JpJ3WpKVhH6q5ise1VCtgEkVGVFEgp7MyLdNAlhftY1/MMpCfoqyEwuvM43Cx9cii5yoUqfa4ZU5dih/c+6Z2Lo+ZHDWoc25hrwx7+JSTRWRMDSTPrTiQMP5Yfxx+acD2xm5wOjjjK4i3J6Qmf37/8/xUBlQ3pMbmIuXpcdBkVEKmZ1B+mmMs/DiotPD5Ukf8qOSYTTUzlXGmTCeTnB8/id//xZ8XSwv6BQ1FEPmJrfISDzk+1T1GC0PqGiiwwhsKExn8f3HsDfjlaI9DbQAo4bQ5r/CrcXMEaFv4wEj+XEWHBfwcwbqCyeGBNcBPbaA1GWKhmfxg0hyQsWogs0XERv0bAAWNF825fn8DFTCva7k3GN3u75+C8Zp+Xp89keKTdz4WKlgKMnLggCZzp93E9QaKKlRjLbB3lNKsAvn0oNcM+3sEMi7fgxFY14TKJHWMjZH8ueSIYeSoy3BvqxJwRWf0hXL1k0VnbjzTxcSsMv1yOPUR+OjIBfpjrEgupHaYhkDmC/JwWts2t7BS/GNqcXwiC03Y007VcWwzmAOeBa7ND2Caz03aEctZgsiisZQ15/1DBu4zOfHTQsxJg7zVde7caGCG9b2+5GGuWP2V4OMJciDz6R4LiW0cmWeW05h4HK3F+f7G0l7Kc1eJNO0sCzGo+GAYF45IHoMuXLNIjj+QIaNXBL+8Dd2OHSGoDWFw7ONaVWPrXCfKlZv9J6A0ySQIt2l9fvv+1BgY9Zb3LzawGFAZP7wc8GR9u9kl+njjKvojg3NzY8bpujLVECG7O6r34h3LcBZoJOD3DiQpRiP5RAkFYE9XUVj3hfNrnz/JTKJIrX2obAhvzyJDlshgoSL1JSlTiZkHIDKc7z8+WaBAInMZRU6tbpaTwwQ8Rouozsi8qnqsoYLyzSHWBCQdVstlVZVXLQ5jiUsA0Y5SJcZW5P
 Gu2YSlM3
 H8FuaLQPJbif5cMKj4/eDIqhmZEAD/s1MAflAnzLHscH/D8A5YUaLtv5a0sGaNUWFH05l86p6jTXa5Dml4mdl3NWOfw1rP0JCtYax5cHm6Sa69DtRHp9zNq3z5zczzkE8dOTtAlkq3BrR/EGQcGJfqgI2ZHgzw6EDYDVBrezb7e1tC16SChtXWwY7l7HO7leceHNUuhciCEGN389vZQKndROyRVNJ7n1/JQ0Vn98IU5xzGFJ/SOZuYyrVZFacji0vFjOhdHYJ+PmESkNWKgjU1I8ij+Yv32JitLImOd+30C5Jk7bExF76XebFHRuRJBjEmDGk1XHlrIEVM5hRwSGLe6WhBM90tq5pEFf9RWbva4b0bJ+PzBkCS/vOyKNQYlPZM/QYxLLLzTGvSukntit6drwl9bItl0kGNyMKrL9FY2696UOl3Q14kvFAtKawYgnRwGX8KwtlZ4p2XXP23lFx4MNdoGfevStnMepu5++ul3nm7L4/Nrtz+Q8B1SPkMCAM69xdGzEaTPkrkSJrroYzTcfbDjIJkvrAdPLinC3vAnw6qCG4/bDrbzLHHJmFk7Oibstpw+Eb4EsJJGswdU8ynUUa0HJPevMshZDu
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
index 4efff892820d..9dcbf461f57c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1384,6 +1384,15 @@ config HAVE_ARCH_USERFAULTFD_MINOR
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
index e14524512a5b..92174d65a73f 100644
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
@@ -2207,9 +2276,22 @@ static struct vm_area_struct *userfaultfd_clear_vma(struct vma_iterator *vmi,
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
@@ -2258,6 +2340,14 @@ static int userfaultfd_register_range(struct userfaultfd_ctx *ctx,
 		    (vma->vm_flags & __VM_UFFD_FLAGS) == vm_flags)
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
@@ -2532,6 +2622,8 @@ static inline struct uffd_msg userfault_msg(unsigned long address,
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WRITE;
 	if (reason & VM_UFFD_WP)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_WP;
+	if (reason & VM_UFFD_RWP)
+		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_RWP;
 	if (reason & VM_UFFD_MINOR)
 		msg.arg.pagefault.flags |= UFFD_PAGEFAULT_FLAG_MINOR;
 	if (features & UFFD_FEATURE_THREAD_ID)
@@ -3631,6 +3723,22 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 
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
@@ -3685,6 +3793,17 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
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
@@ -3724,6 +3843,16 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
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
@@ -3757,6 +3886,10 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_MINOR))
 			ioctls_out &= ~((__u64)1 << _UFFDIO_CONTINUE);
 
+		/* RWPROTECT is only supported for RWP ranges */
+		if (!(uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP))
+			ioctls_out &= ~((__u64)1 << _UFFDIO_RWPROTECT);
+
 		/*
 		 * Now that we scanned all vmas we can already tell
 		 * userland which ioctls methods are guaranteed to
@@ -4104,6 +4237,55 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
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
@@ -4410,6 +4592,9 @@ static long userfaultfd_ioctl(struct file *file, unsigned cmd,
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


