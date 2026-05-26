Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E80ECD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 13:05:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77D56B00C9; Tue, 26 May 2026 09:05:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4EDC6B00CB; Tue, 26 May 2026 09:05:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64516B00CC; Tue, 26 May 2026 09:05:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C70946B00C9
	for <linux-mm@kvack.org>; Tue, 26 May 2026 09:05:42 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A6B11615F1
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:42 +0000 (UTC)
X-FDA: 84809592924.07.7B5D712
Received: from fhigh-c5-smtp.messagingengine.com (fhigh-b5-smtp.messagingengine.com [202.12.124.156])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7BEAA1C000B
	for <linux-mm@kvack.org>; Tue, 26 May 2026 13:05:40 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="V 5u4u9J";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=TNeGK86g;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779800740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l2eF4l/Q8Tds5YOPGrl7bqPwv4dzEj01YZ9nn6A7U0E=;
	b=M3VmHQ8kZrQP0JnvXX3mDkrNiqtENjBX3edgWIMOX0U4ClgNU0wTdgBhV3qD9f/L7GUu1A
	5ELRhpf83L9QvENP5+H9tGD7m1VZ5MQjTSxTXBBz80MQ3ov6Q3rE1GnGHJ5M3Q7GZ3UaVI
	sigaOFXQzZl1eipBFJM2tlWK89qOnh4=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="V 5u4u9J";
	dkim=pass header.d=messagingengine.com header.s=fm3 header.b=TNeGK86g;
	spf=pass (imf21.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.156 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779800740; a=rsa-sha256;
	cv=none;
	b=EA/fgbT5CIcvEA2OI0qhrb65HFSdvEiwIHoKmmfwXeds3uWsTdV4+MdlXihw/+SadhUhZ3
	WEI/ZJwBU8waQldX8evl31U9Dz5kmJY6GhVDERARnp9zOV/8jjrbics7e4A8cj6PjYXSQs
	b4I7gtA4t/ITj43X+7P64z+L4TgX9BQ=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 509AB7A0194;
	Tue, 26 May 2026 09:05:39 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Tue, 26 May 2026 09:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1779800739; x=
	1779887139; bh=l2eF4l/Q8Tds5YOPGrl7bqPwv4dzEj01YZ9nn6A7U0E=; b=V
	5u4u9JxJ0J8lbXAksIQko2i3FlJtARolCg7Nz3WU5SiPyOpUQ7IYAXw//cJKSo8y
	r+6SSj4XodSX5glaroP5q5h+sfNAgOTD3mOUWdeQufaKElE3imsDMPhlBQx8TZVY
	z33H0aAmfZHfTqhF5j+o3Z0TJ09jdP9AlUW/OdgtowUEhEVNpSLZxNLnEzipcggA
	ZuoWZaS4oUiSFkwOKdZUaGjtZXy+bquw8F05E8V3y8Zn8sGbPsZwJnEflX1wloPT
	yRe4qkI9lyc0GunJiu/fsBbAPREx5quhfOoZ/1fDxhH059UzybDNf/MK+2KCbolq
	XUEDhsJEg2+B61aE6MveA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm3; t=1779800739; x=1779887139; bh=l
	2eF4l/Q8Tds5YOPGrl7bqPwv4dzEj01YZ9nn6A7U0E=; b=TNeGK86gGw0/gzlGC
	MNU034ZThmu5B5GTK/c+09HUkUIvMnmh+X7EjZB8HywNFsFdEowhE3xe/Okj65MO
	JZTzSs++JGT31ZooqshCnWZ3fmffJ9OByj5/RsXVv6cnKjsMekNsQLW5sTs9rmKD
	hc3NA3TCitkMZnFwj4wN+OHrc93t6UFi91rCjmc5GqWJfinOjE0UbbUSDqs/t9Qq
	gSKGX8iZ1yTFHp3MNKojC5+Gs0SAMCZexpMb7fhnwh+DCFArSJYwJ4RrlgyENw54
	mYxDAXp97LBf2EBtEWu1o1hwhsfsuZ3vOEuLFzCUGZnzn2UNz6nxeAsVVIyWMkUi
	abNCw==
X-ME-Sender: <xms:opoVanACn-MmhQtmC1BemPJ3Y7jdKMWcLVLVMygh8F4hANx5JPUoXg>
    <xme:opoVahfxTvTF6LHeZZnj64QmhM5GFkEe3ra2Hc7BzngGi-9OMJN87Ft5rDpv3Sv7g
    tudIfqcH5HWcC9vuTKCF4jrKYmH8temMj0aAQ69O788hzVMVr1KqmLY>
X-ME-Received: <xmr:opoVarGQKG6whQqQYjiKnmJvBqLi_HE-WfCLyOb00bpl-K2qqMODfren-ABvPQ>
X-ME-Proxy-Cause: dmFkZTEJiC033GhjL2GdnX/sXIn31a6xYH9Q9kJLS3tMsbkgwO/cImnHqXQKfEc55wOLx4
    i2tqVUZQjDS/XsxdV1Neul2ks/uVgINeMKnTDgBTDd49K013fUhaa7mbXp5KOF+CzusOdT
    UiYD/yezdXIvKfe8z5w2tcDXcgJNRSU5eSwZFLQl4UtnpivyD/d0gOKuFq22BcEw4tqdAi
    ZrLfx6gsOEL+8JLB9yUFNWntFWViMy1Q2hMU0QsTFycK4r8MnF1MjvTDo2QKxDh/PpEdKA
    ZnnGzw8DPiuoI+QbA8cmDBSDEJ+Eojxn1EXRLRmRJNLXOxLbY2LwfoxO6aBp6BbF/3ouPS
    G/W9A7xIdv2wgm2GgO5LpY4dwVSaqP8u7FJCUmWLRPJ62hiMmrcyCmaN1wqJ1QoBAFCciv
    rtvEX5b6D7FtmTG0DAlx4/3hMp5T8ngC47L6P1fbpnHt4xCbDv2EmzJrpGT70FlgWiB4/L
    zZh5ns/idLUntFwmT1P6exBpd5NXjXWMI3SFBI92vxouzE+iSh9WzKoT2Bb9+0Q3KZVChn
    4uYOm3ROFAjDS3s2eqfX20zYMIFP8AHJ3aKzjKaDBiYnpm7OxV2guKu4ime967rdmop5W3
    yhcuutd0fjyR2zyBB7xcxm+FHk8b1irJ2B9YNsIQ5MAyZTVBrKYxmzGoWtTg
X-ME-Proxy: <xmx:opoVajWyTKxhWZ6dx386kHK80yYRKWxmLzWuRqhW44CBbzbv_EBccQ>
    <xmx:opoVajzRZ1LpSppGDHmsUtmFRLAeSQ_EHd8jKNQIu6NsddE68bFNpQ>
    <xmx:opoVamsQyUalSDgnh9DjxeMJFgFfWvBQoX2OyK04ih8tPbZa8kvaqw>
    <xmx:opoVasBF8QSGNqEgjuu-R-o0DUR-PLytXlYKJHbtsQibUv0aGIDM4A>
    <xmx:o5oVahCJsq27IXBczI4pCbcDFX6ZVO8ep10ZOmfI_7MSl7b_vj-hldyZ>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 May 2026 09:05:38 -0400 (EDT)
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
Subject: [PATCH v5 08/18] mm: add VM_UFFD_RWP VMA flag
Date: Tue, 26 May 2026 14:04:56 +0100
Message-ID: <20260526130509.2748441-9-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260526130509.2748441-1-kirill@shutemov.name>
References: <20260526130509.2748441-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xndzkshnatkckoctqikmpmzzwtxbzdwe
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7BEAA1C000B
X-HE-Tag: 1779800740-242747
X-HE-Meta: U2FsdGVkX1/QEMGUmCZlLUscemGqG2d3ch8UL2yVHkcRCaNa66D7a6gJ/DZBzWVrJ2c1bO+ccjkMrffQHWB+w/17Zs0wR0V1HsLblZspu6J9O4SdFkJWJvXttXZTxGfaIsXHJiyh3ZAA6yvCXHos3Jx9Ty6K0GA3vht+N4xCGz0td3TwHDfhsbzLrdXC7FIP9FfS8bYNptxh78ZJF/WZ58MjHNcFCqhStqNo4qMFy4s9lMECEDKREHqw6PWVQmDc45VMM8TWH8hrQKmlxd3zYCg/VE6h80BVZnYUGBRk1QUwn6jTLSiv8c8OgNW129x/S16//WVUipfsvWWQiSOLXc09dJ8PshD7Eec/MmGNj0f6ZbRkwLbAG7Dr3IhOGyBEbN67oXyB/EFYcmmOPGBqlEfZNl+6QirBtHnOQVwy6OuNL1n3P4ZXWrSWc3U17hkTZ/uFYMYBz+4uqeFnjetcoZz2OjBGT2h0fOZA2jwugOrk9kA8dBpCZKLZUnimWL68xOxg1LdavYDeehy5ZoO1YdI2yFH6mSfNnnb3RHuPXCJEgkDuw7+PNnWZCYi5Aa4xaqdYJsRT+fkhijrMSZ/Nrrb1PuujULKhZuxtLs8/SQdhSsS/MY9sWbjyuzhCNSEZNkigBhf+q8cDJ8rIRRJ3f24eVGLoqfSstbUQ3c8VAXhEHg99W80e+6ShtwKTa4rWfPlvu5IylunvMGg20GgbBN058WgI0hZGWU07mYemfxJKAvglJ8GT8tI++Us4AJbHLJPqH08UqFH3jsZvWVTfW1o+1YLjhu+LwCpvhrIakaDfsPDC9q/S5YGKKY78Gvt1nqJ7pInvttjYUzntb20YHV1Gnpg6x20Osx5+bD5IAVCBbT6pwZjZ9hAPCtv5Rm764IlIGDUQ1W6rVlmic0A5EAxxyTyh+t8A9yJiFVUb+yE6uGK8hOMllinNKBQnAWe7R+i2cM0wv2fhzGwbyFC
 DRyXK2Ox
 c6aQgIBU6BNX4m6Wb3edKB1OgvewglNJQUFmBcM8l2k6ZQ3zALGKTCocXcNTL7YsoyZ50V12eInagH103kkSyLUoTnpeACGbsql7UoHmHBu5nyYxKFMoOYnqJ8GORHl+lxP3gv34T7Lho08IiIyFJqctGtBOXRuzv7SN+nhCMnWLYfxF6Qd2X4ejMMUSHnrpuZjtCwgwCof/iMQv2W9eKPkgv5mMHyCxAznZ6tqRg2Aozrt679BSv6lGbzFK83vCIkTDC91uclqVHD2Qwv8fIunOk4AjH6HQRBNukg470mHf4MWKI5Nppi+9Er/C276HDvPO0NUryogUAq4pYHd2myg4Z1meYzUjlEbTUvqoDoNMGG6Gv8TFPR1nUtROX7Unhtlhjnza9mY1ovTYpp2rAN8UsNf81CsE5rb9tz7q+ntuOJZEFFH11Tz5gJoZydCGIHJaQqfDwO+2qLgy2YqLycvK62lLf+xTI12Pw3AnhoSr7jBHJYJ8UnIc3OJD0NDnZqPTxAKF4iHuHfNjvStmj6yqTuExH9cK3kwVzgAHFmPnpQB2OSb5xhYKebltRuOe7Kg6a7rjtdl+WoqriEk+HYqI6IrZBwzHVzS8LKmDumXwouZTEPg7xsSOooSIbty1ysIs+yqdoqV+VfvP96WsYlBDLC5CaxM6AbE13AXAGPfV2A8Q=
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
---
 Documentation/filesystems/proc.rst |  1 +
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 28 +++++++++++++++++----------
 include/linux/userfaultfd_k.h      | 31 +++++++++++++++++++++++++-----
 include/trace/events/mmflags.h     |  7 +++++++
 5 files changed, 55 insertions(+), 15 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index db6167befb7b..db28207c5290 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -607,6 +607,7 @@ encoded manner. The codes are the following:
     um    userfaultfd missing tracking
     uw    userfaultfd wr-protect tracking
     ui    userfaultfd minor fault
+    ur    userfaultfd read-write-protect tracking
     ss    shadow/guarded control stack page
     sl    sealed
     lf    lock on fault pages
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 1e5f6ee8a3b6..974c5f4aa533 100644
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
index 71b11945e4fc..6499cfb61dc4 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -362,6 +362,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(UFFD_RWP, 43),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -505,6 +506,11 @@ enum {
 #else
 #define VM_UFFD_MINOR	VM_NONE
 #endif
+#ifdef CONFIG_USERFAULTFD_RWP
+#define VM_UFFD_RWP		INIT_VM_FLAG(UFFD_RWP)
+#else
+#define VM_UFFD_RWP		VM_NONE
+#endif
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
 #define VM_SEALED		INIT_VM_FLAG(SEALED)
@@ -642,22 +648,24 @@ enum {
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
index f4cf5763f92c..0aef628514df 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -21,10 +21,11 @@
 #include <linux/hugetlb_inline.h>
 
 /* The set of all possible UFFD-related VM flags. */
-#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
+#define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_MINOR | \
+			 VM_UFFD_WP | VM_UFFD_RWP)
 
 #define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
-				      VMA_UFFD_MINOR_BIT)
+				      VMA_UFFD_MINOR_BIT, VMA_UFFD_RWP_BIT)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
@@ -178,7 +179,7 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
  */
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
-	return vma->vm_flags & (VM_UFFD_WP | VM_UFFD_MINOR);
+	return vma->vm_flags & (VM_UFFD_MINOR | VM_UFFD_WP | VM_UFFD_RWP);
 }
 
 /*
@@ -208,6 +209,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_UFFD_MINOR;
 }
 
+static inline bool userfaultfd_rwp(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_UFFD_RWP;
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
@@ -328,6 +339,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
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
@@ -421,8 +442,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
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
index a6e5a44c9b42..bfface3d0203 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -194,6 +194,12 @@ IF_HAVE_PG_ARCH_3(arch_3)
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
@@ -215,6 +221,7 @@ IF_HAVE_UFFD_MINOR(VM_UFFD_MINOR,	"uffd_minor"	)		\
 	{VM_PFNMAP,			"pfnmap"	},		\
 	{VM_MAYBE_GUARD,		"maybe_guard"	},		\
 	{VM_UFFD_WP,			"uffd_wp"	},		\
+IF_HAVE_UFFD_RWP(VM_UFFD_RWP,		"uffd_rwp"	)		\
 	{VM_LOCKED,			"locked"	},		\
 	{VM_IO,				"io"		},		\
 	{VM_SEQ_READ,			"seqread"	},		\
-- 
2.54.0


