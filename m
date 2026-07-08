Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B8DDC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 11:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48ADF6B0098; Wed,  8 Jul 2026 07:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 462A46B0099; Wed,  8 Jul 2026 07:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303316B009B; Wed,  8 Jul 2026 07:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D76386B0098
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 07:14:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 65C911C3D35
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:35 +0000 (UTC)
X-FDA: 84965351310.29.D68FF0A
Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	by imf07.hostedemail.com (Postfix) with ESMTP id 7974A40002
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 11:14:33 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="S wjnbNn";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=FMAWrkXU;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783509273;
	b=YwjD/VRlHAXJ3CUBmVNdza2LnrZZEYfJOe4MaERRWdpq9i705wlufVomrB4a8ulZPjy0Ha
	dvYO2xyd0DGys1LlWIhZWJVtjmjjyQRKaMX8USR4pM4hsXHlf77sjGoORX2FdaaHQMzmph
	ip/9vvQ9jY0yi+6+OYV7+XYEtj9SiYI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="S wjnbNn";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=FMAWrkXU;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.154 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783509273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a4IVeu0En0xOylE6mKO+gIwR+qNQBRcda1XJv5tdibU=;
	b=rLcYqurE6OYu4pyu/tVUAw3JKDUhBVcJ0CoB7qBfnjmhE7mTdKdp+FLHx11DR5x4qD10UT
	QU0GiyzmJfsGqRzMmXMTSsp4dOBUhaePLtOYnj8WeE8O8sVxG8iPRj6FLIW1ksScJxi4W3
	dMxktHxumOo4OlNWpfKp5QSvIq6abic=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 529347A0150;
	Wed,  8 Jul 2026 07:14:32 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Wed, 08 Jul 2026 07:14:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1783509272; x=
	1783595672; bh=a4IVeu0En0xOylE6mKO+gIwR+qNQBRcda1XJv5tdibU=; b=S
	wjnbNnoVBQ9TMlwc0+K4Gx3cuw2Zd86i/VfCSxrS+e4DhWcyVf+c/ZcPI8IqkG9v
	OV2Fd88QbvBggeBYm9UTxAMFqPegNYyshPeJKEpgJrckkQJK/joMRjWjcjdsRe6x
	ngrlnpHLhdOwlN16o/JSMsFdMAnHOv4Ci6yV68SzKdgqblgEjo74bf+wXd2NssHF
	UT4S+bai6QW/Xy49qe5uTGlOH9XM2BK7si9uYIWhUhKYAisbNEeBnO5kNEzb6uMO
	Zl/QfJPUctD2W3Xc2ONRS3ZK3Gqd7zKQIx+bou67oCk+81m9FNb0aUgkwMIAL0VF
	oeSmGeOKhgbNolHb2CUTA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1783509272; x=1783595672; bh=a
	4IVeu0En0xOylE6mKO+gIwR+qNQBRcda1XJv5tdibU=; b=FMAWrkXU5zEbWjh0t
	U52styhNkGq4RIS1sv3Xwkv485WPYmUbE+UYOuDMUjDjP0K/hZKqkcPvU1CpzLWK
	wyB/KOmsiIrrL+FasxGljptb54ymqSal7F8Dh9FyRf3WA+Qzj5RCHG0odrcXJgIT
	OphnEO2v8bjlR6bRPU5k2vnzxxJXlVBqRurD95OLGoc9qmI1x37j6ghrZ5B6Vr6B
	nvrIBhuuZcLGSu/M23BaNVeUMgc19E0cFONzIRzPGb3w3a166eqPnHIn8VhNrjmw
	iAGO2874aeN0x+FxVo/9ggQxovRnI2g6ySdpY2XnqFQOvtg6dHB6cGzxz/ItfmTq
	jGXqQ==
X-ME-Sender: <xms:GDFOajw11VyygoSDzHt6u7opVIbJCr6rrpUsKBYIjOugY68C6fVVcw>
    <xme:GDFOavPZFf5nO_wOPZEiRp7eOc6f24_4dDJk9mAPpwO2Ya8EMjSl0M2_m7xJLhHXW
    pCO-nL4_ikJBMGE5Rn_PIIunHknJqvYZsJp_5J_hrp3QmRUkIr-Ds4>
X-ME-Received: <xmr:GDFOal1e378pK72_8cFYRtzEvHZ-KTlIkAup2IAgDzuKycVvs5Gwzq8MOWD8hg>
X-ME-Proxy-Cause: dmFkZTFA+hhByeLgFww1qUzdBJoK1nZFesRo0aB6c2MB73AGri9tY/5/KB73XNPDnHBeny
    VPl9i20EQaa25oDKD5gIiwR8mM6BfhFqxnrdZTac2CL0R6sTKopOhQZnnsHK3kfJMrQP+T
    a/3NJyWvJgpKXqnilG7Xb/ul1dGQwwkG1TWteGtx5YWHcwtEH6iKqW9rcoX1er/ovdB6Cn
    F/wAHSIBSrpaKkTUBNtdV2XQzY4Evf4FvqCR+m1yiNzv+wIzxfhiz1F9A05CN5a/Z/rgUm
    8Q+6H55QDab8QWsxF5eUieV7iqxcOEfDk9Ykltt1gpFUblRTxKfGNFm0fMa23LEmflmEk1
    4ihm6wev+Vdr2CMsKNcPRwHIppB8GuAXmJHalfyXkjfvb0ixFDUTodNkLDH4RwEbhRG06c
    5GXG6GFyJPlQ/njDi0J2V70cD7BTDqz+v9OHVVOhvRDX9wgLAJzlJGMZq7KfQM47yUtl4v
    TVbGE1JvpVBrZUqnOB0B+N+y4SdYVP0vaOmVar3YsjE7VZJh2p0xHMzL91rsn1pETb4VZm
    qmY3szEYSmUveyF+w4Mx4JBmXzpXUNIObSO/df+6q0PnPJgHzOudeM+dejEq5FQMnfQjg2
    6tQFkdjHvLiF8G8QJUt7jM1RLTXiRl0MmtvTx8dzvpWWwBeaSZaaZnP5s/tg
X-ME-Proxy: <xmx:GDFOanHMenZuSxF6nT6J8cNZnZ6lTa2tNqHAapRFlNsICUflIv0Gng>
    <xmx:GDFOasjk6gqclmPA19gjOMjj2bwr47XF7J983Ck3HeK9mn6m1bqdEQ>
    <xmx:GDFOagcrOAf4QU3UznWOGhIr2lvzHFOqe5ZgGC403f1UKeb92gHNwQ>
    <xmx:GDFOaizC95VT74qTg5MMCQ1jGOwEHblWrwVS7BysT8fO0e0gVtj9dg>
    <xmx:GDFOanzpzdLxsMaYjYOYjPIdLNivXhK_fU-3IRJ9KGhuZZDTHUJQJj0m>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 8 Jul 2026 07:14:31 -0400 (EDT)
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
Subject: [PATCH v10 05/15] mm: add VM_UFFD_RWP VMA flag
Date: Wed,  8 Jul 2026 12:14:06 +0100
Message-ID: <20260708111417.173443-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260708111417.173443-1-kirill@shutemov.name>
References: <20260708111417.173443-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 7974A40002
X-Rspam-User: 
X-Stat-Signature: bfjzfy6qf4ckc6zorm73pb798rrk6eax
X-Rspamd-Server: rspam03
X-HE-Tag: 1783509273-275878
X-HE-Meta: U2FsdGVkX1/izM8KI8AZZX9jtZoOsEWD/AMMiB3ylUagSSqM4nJoFsXhDv1Vp27HSecyB5ITfJE11siwPsCv8WURKMFPokdyLK6Z9EHBPzxQupzbOoaZaTKU5jERjIpshzBA3T3z1y5/AudgqQcVVMlNHc7202QspYQ5Utk16gj7czu+xUbcGQYOSoj6VeFOT7KKBJ6NbT2lLqns34bl1TixP/TQG3gvEAnDQFa9TcUkWXDmpq9778qvdJB36zdp1CfEhcpPkCiLNrCx2uXsYDfCmtoC6S0SJYnCarohjnTj5aH1W1BgwUiyh2xPHf0t2XdjYejZropVqJxEV/FaUR0+5LxAoBqwQyoTvOZLXtO/RJlywxdKQA2zOnJFir+qfyh+q++C4osg/2EzXGe9dFv76y9XKb8FIq5cTOR/LKG9DzhUc3JLxlyRrjJZYvzYmbje/taaCdtlLKYmlrHL+wz4Io1tl6hvaJgTSZnG0TcDXH6A/VKWKQ+in9yHJHj7fda+vb6ycTHnN6lufosx+rD8cT087DZonScP/DbIdWwU1edhBZ9xHwakHHTAEwp8j9viZp8zKMCQp/ZEAFaJCujiVxgqCtcy5otBn8avikdAF2uw87sFYYILyJiTBZoStf83A5L38vVTSnkHvrZkWI+kaUHCOFCSyIJb3PykWuZ7nCON8Jw36l9s2lW/Txq0dBzMcMkvMJAdBAmFtmi9AYMY50D2TwRfTGDy4cd85hQViUuIP/klorLEUBvuBVIYRxAp9JQZvrldaQVysaY3y/f7a8Ig78vYu/zd7nO4wdw82d4HPfVEcnojbB9sJe4ddZUEu0LGRvYFd+CYOlPYrqunMUoBY/32aevrpf/VMbj5jOsJMq8i1+CWwomH71MD/HKXJh1e5dHlIRo+ZSn7c77og9jSlNW5M8IRAjpERYJZr2HOyiOZS0Ywl3fuJF93G+eKgRt7FWNoBiWq6gM
 H+XA1fBb
 js62ncMw76HO0uEaHYAY7Jgs2sYz7U7EXPLZ4kawFkRhkCArZ0QQqTVVfPeKabY3hcLyk7GEpT4+UWOyuLu+oEJNH/7woAaNTlE5GOfSkrUoviAzKjuP4vwUYXJhPo1+O3cbj080Hf4ZfPzBRBcwg3EnWC5nwQts+VfvFHgM9dhjBhZtbQb7C5vVGoFc4o17X/Ud/ZHO6FNaJgDyiEiDP7vEPdGr06r4VpmbAjqII1zndRxoKH2Bznnd2OoVR6wquScBiKFgU52jepObxSrn3ZAiXNHo1ZSCy+Cq5uqt/jCBrFtccp3h+rLLW9GdIWFHaIyLNRVuPOy8Lo9JQXRhVWYygu8PbcpqpCGp+IQ6CSr0zFZ4gv7wQndS2dUOZKp0GTg7SodTNE8zNZ7UylJeCyXz96SeA0GZ2IH2o7WKZRQSahl8bnZIaCOGoPUAMwUe85oyqiAd3RNfk73ScQcXTp12fZeJKndYBRnh80cVotR+JbsCbvcOSvbgDOC37CefNM5tpdk7KLQHjcErMhBjn+/AT9l7ofkkM/3WgZt3WoBBsRlbs02UrpJyKqQshRfuYPJ7M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

Preparatory patch for userfaultfd read-write protection (RWP). RWP
extends userfaultfd protection from plain write-protection (WP) to
full read-write protection: accesses to an RWP-protected range --
reads as well as writes -- trap through userfaultfd.

Reserve VM_UFFD_RWP, add the userfaultfd_rwp() and
userfaultfd_protected() helpers, and wire up the smaps "ur" entry and
the trace-flag table the rest of the series will use. The flag is
gated on CONFIG_USERFAULTFD_RWP, which is introduced together with the
UAPI in a later patch; until then VM_UFFD_RWP aliases VM_NONE and
every downstream check folds to dead code.

Nothing sets or queries the flag yet.

Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Reviewed-by: SeongJae Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 ++
 include/linux/mm.h                 | 41 +++++++++++++++++----------
 include/linux/userfaultfd_k.h      | 45 ++++++++++++++++++++++++------
 include/trace/events/mmflags.h     |  7 +++++
 5 files changed, 74 insertions(+), 23 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index 2ccd5b2dfdd3..27189f6e004e 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -608,6 +608,7 @@ encoded manner. The codes are the following:
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
     ui    userfaultfd minor fault
+    ur    userfaultfd read-write-protect tracking
     ss    shadow/guarded control stack page
     sl    sealed
     lf    lock on fault pages
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 97b2ebc3fc48..5f15dbba66d2 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -1237,6 +1237,9 @@ static void show_smap_vma_flags(struct seq_file *m, struct vm_area_struct *vma)
 #ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
 		[ilog2(VM_UFFD_MINOR)]	= "ui",
 #endif /* CONFIG_HAVE_ARCH_USERFAULTFD_MINOR */
+#ifdef CONFIG_USERFAULTFD_RWP
+		[ilog2(VM_UFFD_RWP)]	= "ur",
+#endif
 #ifdef CONFIG_ARCH_HAS_USER_SHADOW_STACK
 		[ilog2(VM_SHADOW_STACK)] = "ss",
 #endif
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 113e1752548c..fdb8d1a500cf 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -354,6 +354,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(UFFD_RWP, 43),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -497,12 +498,17 @@ enum {
 #else
 #define VM_UFFD_MINOR	VM_NONE
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
+#else
+#define VM_UFFD_RWP		VM_NONE
+#endif
 
 /*
- * vma_flags_t masks for the userfaultfd VMA flags. VMA_UFFD_MINOR is gated on
- * the same config as VM_UFFD_MINOR -- which implies 64BIT, where the bit fits
- * -- so an out-of-range bit is never fed to mk_vma_flags() on a build whose
- * bitmap cannot hold it.
+ * vma_flags_t masks for the userfaultfd VMA flags. The two high-bit modes are
+ * gated on the same configs as their VM_* flags above -- both of which imply
+ * 64BIT -- so an out-of-range bit is never fed to mk_vma_flags() on a build
+ * whose bitmap cannot hold it.
  */
 #define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
 #define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
@@ -511,6 +517,11 @@ enum {
 #else
 #define VMA_UFFD_MINOR		EMPTY_VMA_FLAGS
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VMA_UFFD_RWP		mk_vma_flags(VMA_UFFD_RWP_BIT)
+#else
+#define VMA_UFFD_RWP		EMPTY_VMA_FLAGS
+#endif
 
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
@@ -649,22 +660,24 @@ enum {
  * reconsistuted upon page fault, so necessitate page table copying upon fork.
  *
  * Note that these flags should be compared with the DESTINATION VMA not the
- * source, as VM_UFFD_WP may not be propagated to destination, while all other
- * flags will be.
+ * source: VM_UFFD_WP and VM_UFFD_RWP may be cleared on the destination
+ * (dup_userfaultfd() -> userfaultfd_reset_ctx() when the parent context did
+ * not negotiate UFFD_FEATURE_EVENT_FORK), while all other flags propagate.
  *
  * VM_PFNMAP / VM_MIXEDMAP - These contain kernel-mapped data which cannot be
  *                           reasonably reconstructed on page fault.
  *
  *              VM_UFFD_WP - Encodes metadata about an installed uffd
- *                           write protect handler, which cannot be
- *                           reconstructed on page fault.
+ *              VM_UFFD_RWP  write- or read-write-protect handler, which
+ *                           cannot be reconstructed on page fault.
  *
- *                           We always copy pgtables when dst_vma has uffd-wp
- *                           enabled even if it's file-backed
- *                           (e.g. shmem). Because when uffd-wp is enabled,
- *                           pgtable contains uffd-wp protection information,
- *                           that's something we can't retrieve from page cache,
- *                           and skip copying will lose those info.
+ *                           We always copy pgtables when dst_vma has the
+ *                           uffd PTE bit in use even if it's file-backed
+ *                           (e.g. shmem). Because when the uffd bit is
+ *                           in use, the pgtable contains the protection
+ *                           information, that's something we can't
+ *                           retrieve from page cache, and skip copying
+ *                           will lose those info.
  *
  *          VM_MAYBE_GUARD - Could contain page guard region markers which
  *                           by design are a property of the page tables
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index c4f2cc6dfcf0..6dad14b9abb9 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -21,10 +21,11 @@
 #include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
-#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
+#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
+			 VM_UFFD_WP | VM_UFFD_RWP)
 
 #define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP, \
-						 VMA_UFFD_MINOR)
+						 VMA_UFFD_MINOR, VMA_UFFD_RWP)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -168,7 +169,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 /*
  * Never enable huge pmd sharing on some uffd registered vmas:
  *
- * - VM_UFFD_WP VMAs, because write protect information is per pgtable entry.
+ * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
+ *   tracking information is per pgtable entry.
  *
  * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
  *   VMAs which share huge pmds. (If you have two mappings to the same
@@ -179,20 +181,25 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
+					VMA_UFFD_MINOR));
 }
 
 /*
- * Don't do fault around for either WP or MINOR registered uffd range.  For
+ * Don't do fault around for WP, RWP or MINOR registered uffd range.  For
  * MINOR registered range, fault around will be a total disaster and ptes can
  * be installed without notifications; for WP it should mostly be fine as long
  * as the fault around checks for pte_none() before the installation, however
- * to be super safe we just forbid it.
+ * to be super safe we just forbid it; for RWP, pre-faulted neighbours would
+ * be indistinguishable from accessed pages in PAGEMAP_SCAN (PAGE_IS_ACCESSED)
+ * and pollute the tracked working set, so each page must be populated by its
+ * own fault.
  */
 static inline bool uffd_disable_fault_around(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
+					VMA_UFFD_MINOR));
 }
 
 static inline bool userfaultfd_missing(struct vm_area_struct *vma)
@@ -210,6 +217,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return vma_test_any_mask(vma, VMA_UFFD_MINOR);
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return vma_test_single_mask(vma, VMA_UFFD_RWP);
+}
+
+static inline bool userfaultfd_protected(struct vm_area_struct *vma)
+{
+	return userfaultfd_wp(vma) || userfaultfd_rwp(vma);
+}
+
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
@@ -330,6 +347,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return false;
+}
+
+static inline bool userfaultfd_protected(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool userfaultfd_pte_wp(struct vm_area_struct *vma,
 				      pte_t pte)
 {
@@ -423,8 +450,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
 }
 
 /*
- * Returns true if this is a swap pte and was uffd-wp wr-protected in either
- * forms (pte marker or a normal swap pte), false otherwise.
+ * Returns true if this swap pte carries uffd-tracked state in either
+ * form (pte marker or a normal swap pte), false otherwise.
  */
 static inline bool pte_swp_uffd_any(pte_t pte)
 {
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index c1a05ff0feab..935893e5ea53 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -186,6 +186,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
 # define IF_HAVE_UFFD_MINOR(flag, name)
 #endif
 
+#ifdef CONFIG_USERFAULTFD_RWP
+# define IF_HAVE_UFFD_RWP(flag, name) {flag, name},
+#else
+# define IF_HAVE_UFFD_RWP(flag, name)
+#endif
+
 #if defined(CONFIG_64BIT) || defined(CONFIG_PPC32)
 # define IF_HAVE_VM_DROPPABLE(flag, name) {flag, name},
 #else
@@ -207,6 +213,7 @@ IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
 	{VM_UFFD_WP,			"uffd_wp"	},		\
+IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
 	{VM_SEQ_READ,			"seqread"	},		\
-- 
2.54.0


