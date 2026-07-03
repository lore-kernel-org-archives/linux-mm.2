Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3A3DC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 16:43:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45B606B00B7; Fri,  3 Jul 2026 12:43:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40CAA6B00B8; Fri,  3 Jul 2026 12:43:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323036B00B9; Fri,  3 Jul 2026 12:43:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E82876B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:43:22 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 5615E140209
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:43:22 +0000 (UTC)
X-FDA: 84948035844.09.4F37477
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 41EE41C0002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 16:43:20 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQgODdQc;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783097000;
	b=uOF68nEe+U+PVusfN1dkwW/YElwlECPm4VDI+v9/dfLBJuJZwaVwdRhxdZlwWP1sxTx5lA
	ArWMgJOQgvOTd09FNSo8P+pAPoFXdeVQ8t906wBMk72jnmw3Z58Mz8dX7FS5rnB+Mj2rww
	aQ239x5UVx57KKD8yABQqPiFh9ISet4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783097000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wmiike0RMf4GUZzG60cV6tKCpPnHn3sgz+92qG8ZSFo=;
	b=z0tgRfqLscePWjpj7qNHmBsqMR8v8rW+bjbM6laJdtqrAbgt54m9J2u/x+LFn5ZdZZFeIH
	UjuZNUEHMXacUUHfsFRh/aA4wNvGsEpU/TBjHq66ajJ74IcuNqqCVQ3iTfRORrusRpEN6Y
	cY7EVo+zqh4OXHdmWnZu1rnGZF9Bzgc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oQgODdQc;
	spf=pass (imf20.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 68F4C43E4E;
	Fri,  3 Jul 2026 16:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4E11F00A3F;
	Fri,  3 Jul 2026 16:43:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783096999;
	bh=wmiike0RMf4GUZzG60cV6tKCpPnHn3sgz+92qG8ZSFo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=oQgODdQcQOZJ6UkIoTHpSPAR+xm0LbTzqhxtul4thXzJ1L4k1xRCB5Jfy9i79GdKy
	 AqZzrmO9bPCWxh1+UKQeckEA8xfE1ALRrFgdtPWO8vjwNCunLuPHT3DQY412txfRXM
	 IcPirEckZNvCksYf7oe2J9e7Gb5Koo01YZfFnIEDWVb2ZH6ACzGBQOnmSqTdpxJG/p
	 jE9g1J1K8wCvGiZ6t6teTZjFTfq4KjVtxn3YEXBVakSfpQy5fogPPdyjHcKdGbkX9Y
	 rkoOLSm0x9pfqRwQbmndrfkrHk4CW6WfefyPzMPDnrR/5D2l0WpKn8AHdQbcbcwD0f
	 t+0ZKGm4Ihgmw==
Received: from phl-compute-11.internal (phl-compute-11.internal [10.202.2.51])
	by mailfauth.phl.internal (Postfix) with ESMTP id A9FACF4006C;
	Fri,  3 Jul 2026 12:43:17 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-11.internal (MEProxy); Fri, 03 Jul 2026 12:43:17 -0400
X-ME-Sender: <xms:peZHagMAZzcYl7CmGJIRQXcADJfppBSUDgNGnKdXW7-27IhwjKYNSA>
    <xme:peZHav94GBW2fS7CSPjP7dXckGLtKDruvWFJgoRhS21FxCl5eSniepVxlnmADCm2k
    ot3CcE2nTZxy-aoG3P9nlnbLnnddED08kNQfUr4Ghc-QSpAM3BUGVc>
X-ME-Received: <xmr:peZHag-yEVwy1cFKNkUnw1mA7mzH_ik4hwH_tdr4YTNR-JuUxfNtBQ6LD3-XvA>
X-ME-Proxy-Cause: dmFkZTEhXLrG7RRgWewl6PxPi2xh+8RsvhIU1msTLaJArxEAHB6uY996MYxuxeHg0YK91y
    R0wyJcP7nTPMFDWO2Q8TpgpNyNZ42owgYwLWubaXjtExEZhofOlvlDvWLcia4Prx0zY45R
    Fw38UnVt/frpIxZIsiAA6MUvzEARpnKuokCRNpn3gJzH0DP6jNc6FvmZdyr5G4Z2yyeA3e
    A0pTNJ/xcW6DuOeNSIJ8JAKYtZNQGLKSOSu8G1RdEMTK0KDrunlklY8omtJiDqkZaS+9Im
    xxzBCx16mviGsn1Gf931m+HMap5B6fYLxqAeP9gaObnEeRSCHAQmpkENZV8SepZp8HRAVS
    D0mw8Lk+gVKD1CORE7bPyI2GJGmG4myt9165rJWgPoq8dT6ush6hA9t45mkxQ+OTjL+AIS
    p+s9Ya+POW2qVpOGRTM3mU/duDR8ZK8HmdXoz87Dnj93jS1kPgVfUmo+5sGgF1rAvYNw17
    jjw7+Tv7Y9MATgSPzv+Oq5FeWwGbeqjXX/0q+uGinBX/WSOsXB0IeMiSnOhwNfCGQJLE0k
    Bld2Zc9VVIRr9ZuB3HegwP27DOKH9IzcWyGPzpgQVWOiR308qAcGNSuLpMCF4ffgkhfCf7
    XsttxQzyy66CukTnb565g5n2L6u6r1LVYxt905mN7so2p6LQ4vyLwep8Ryiw
X-ME-Proxy: <xmx:peZHavqZomUiomjVpT4A2daHUPpDZbqZLOGRjBjZpiGyVhDSfJNukg>
    <xmx:peZHarJH0dyQxR4lrQGZ9IqAUJctIzzPAFEoPd5G-ISbH1gMNpzZSA>
    <xmx:peZHak0BtjTmrFjtRwV9bkHngywyLii-Ma5udRkPh5Dbtkh4e9qQ0g>
    <xmx:peZHak7O_jSu-q03beVgwlBiHYK8VGPqx_4AvW4Ujhd0wQ8X3DYjUw>
    <xmx:peZHaiMlQJmsOlLT50fzJ4z4SqiiflrE1QXy9udNZWRfsTPEdZJWvGeB>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 3 Jul 2026 12:43:17 -0400 (EDT)
Date: Fri, 3 Jul 2026 17:43:15 +0100
From: Kiryl Shutsemau <kas@kernel.org>
To: akpm@linux-foundation.org, rppt@kernel.org, peterx@redhat.com, 
	david@kernel.org
Cc: ljs@kernel.org, surenb@google.com, vbabka@kernel.org, 
	Liam.Howlett@oracle.com, ziy@nvidia.com, corbet@lwn.net, skhan@linuxfoundation.org, 
	seanjc@google.com, pbonzini@redhat.com, jthoughton@google.com, aarcange@redhat.com, 
	sj@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	kvm@vger.kernel.org, kernel-team@meta.com
Subject: Addressing Sashiko AI review
Message-ID: <akfmUXjqaBQnxqYX@thinkstation>
References: <20260703133615.1039465-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703133615.1039465-1-kirill@shutemov.name>
X-Stat-Signature: mmi75z8q76y6ubjn9ro54ea71rahxc9c
X-Rspam-User: 
X-Rspamd-Queue-Id: 41EE41C0002
X-Rspamd-Server: rspam05
X-HE-Tag: 1783097000-434961
X-HE-Meta: U2FsdGVkX181c/+3TZRt4q/H3s+URf64PI8mxIRgQeIdhvc/SS84HBMy5z1KACuJpaE2by7PCjst2rm9PhQlrPuihqoL6aam5eyFdqLPx6SGhS1GHgkIRB6kofNoFWEGRg6OpfNeCMhVRx91+YkY5RbS/zP7lK+jEtP/rGNSMEQ3DszN41DwLw7dvcQTXq+Xusejbm48IA00I+vCRVKIgze8vlTLQ6WOEnz75tAOZeAfM9zOvoG5wula9rjWtHCltUM2kPOUteq1saGIRhErctgHDNIZOMxFDv9jSSakoLcUTAUjUBCkGRJ3kMQvl9771eUeJdxpUSsFNogbtKLHx++8rE9x8Naj4zY3xQAbT98yIf546YQPVsXQ5o5eoj5fBhNgkD8LiK66rLn6l+8QBpKvEiHGGEUvgge+tIyfulAIeerx3Xd/uRAEuZ4/6Q7XMUvFzsaxFDFAfMGfcDZUQN4Tm6/tHGLlsEbjvbUWth/8Fn+TdmdP9mIHGh6gVnNXjp9wXml/UPRk/H56LRI5PiVTkXEcpEo3s4Z+iei/+7qPuVkXqAnjKKYnENwyqtrYekinRjwG9sGM9Ty3r9E6O8bx/q1bGbmby1frmZP3PgzdaX+JuPY/nhSI7p5ZPHReee+JSSmjwmQDQi46C0keH+IG1QdCaCdKe8s7jTmHjZSFbXUHAtzXXJ6K27qY0i3T8h9yMmMTXAggMeZ88B8N789pfdp2TvwWhcyKYaY8ECNleiBrnzwjDERBWx7X8Xx6VMco379lrVZXvF+gx5j8Zu1KqaHXWXjoY92Za36gOzFOCXdvodR0fDy4M/0emQfRTmQAcnk57Cz55bVLfvLDuR0fF9FTW+lvF91DlCtzhBG3VcsJj9ENT22npSfaXI0dYBkB2x7GpVTLR2AOOyQZ4I8i8I3Lk8+30w2D4DfIgxCyamBkS9qZJaCWXEb8M8JEDYoIJ48i+LbQsoJoIOp
 Vwlfrvam
 lhnYvz1UgbPNdIjOeNdVV9b22NYH7lWHEYYEHcT/LQbmora3+spygjJtEbmpMGkkG5sRw1c+SUudVX1t/TLRLfRk74olu6pGuG4Num6vC9xmSQOrOiHym1J7QNvOkGKTRF/tJwXS96OoR9/8hXyJ1/Rl/HJRyQI+2jixxX9QLIj8Jfp5IGkndw0csobVY0DzipLw9fWpzwYBTTcZYxqAiKFzwhmNVk5y/Icu8L2iHCH16tgYLapW178NjvJgfmWiL6pH8mj8XNGLQofSG197z6eGMMETU+9pPrSm9cYncLcaHQRo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I looked through Sashiko review and queued changes for v9 (see incremental
diff below). The v9 branch is available at:

https://git.kernel.org/pub/scm/linux/kernel/git/kas/linux.git uffd/v9

- 05/15: uffd_disable_fault_around() did not cover RWP, so one
  missing-page fault on shmem pre-installed up to 15 cached neighbours
  as accessible ptes and PAGEMAP_SCAN reported them as
  PAGE_IS_ACCESSED. Fault-around is now disabled for RWP.

- 06/15: change_huge_pud() rejects MM_CP_UFFD_RWP_ALL next to the
  existing MM_CP_UFFD_WP_ALL check. Defensive only.

- 09/15: the PROT_NONE accessibility check lived in
  vma_can_userfault(), which unregister also calls, so RWP register ->
  mprotect(PROT_NONE) -> UFFDIO_UNREGISTER failed with EINVAL. The
  check is now register-time only.

- 13/15: userfaultfd_register() read ctx->features with a plain load,
  racing the WRITE_ONCE() in userfaultfd_set_mode(). Benign (the
  tested bit is not toggleable), now uses userfaultfd_features().

- 15/15: the documentation wrongly claimed UFFDIO_API returns the
  supported feature bitmask on EINVAL; the kernel returns the
  structure zeroed. Corrected.

The finding against 03/15 is a pre-existing bug that the rename only
made visible: copy_hugetlb_page_range() clears the uffd-wp bit of
hwpoison/migration entries with the present-pte accessor, corrupting
the swap offset. Fix posted separately:

  https://lore.kernel.org/all/20260703161833.57416-1-kirill@shutemov.name/

I believe the remaining findings are either pre-existing or false
positives. Ping me if you think something is worth discussing.

diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
index 69836e39aa0b..783d969f0e28 100644
--- a/Documentation/admin-guide/mm/userfaultfd.rst
+++ b/Documentation/admin-guide/mm/userfaultfd.rst
@@ -348,9 +348,9 @@ without ``CONFIG_USERFAULTFD_RWP``, and architectures whose ptes cannot
 carry the uffd bit at runtime (e.g. riscv without the ``SVRSW60T59B``
 extension). Requesting an unsupported feature in
 ``uffdio_api.features`` makes ``UFFDIO_API`` fail with ``EINVAL`` and
-leaves the userfaultfd context uninitialized; the bitmask returned in
-``uffdio_api.features`` then advertises the features the kernel does
-support. The recommended probe sequence is therefore to open a
+leaves the userfaultfd context uninitialized; the structure is returned
+zeroed, so the error path cannot be used to discover what the kernel
+supports. The recommended probe sequence is therefore to open a
 throwaway userfaultfd, call ``UFFDIO_API`` once with ``features = 0``,
 inspect the returned bitmask, close that fd, then open the real one
 and call ``UFFDIO_API`` again with only the supported features set.
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index ca718e8590c5..bfbd6a59909f 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -171,7 +171,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 /*
  * Never enable huge pmd sharing on some uffd registered vmas:
  *
- * - VM_UFFD_WP VMAs, because write protect information is per pgtable entry.
+ * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
+ *   tracking information is per pgtable entry.
  *
  * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faults for
  *   VMAs which share huge pmds. (If you have two mappings to the same
@@ -182,21 +183,25 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR,
-					VMA_UFFD_RWP));
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
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c67261f04731..4150f1bdea0c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2766,10 +2766,10 @@ int change_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
 		return 1;
 
 	/*
-	 * Huge entries on userfault-wp only works with anonymous, while we
-	 * don't have anonymous PUDs yet.
+	 * Huge entries on userfault-wp or userfault-rwp only work with
+	 * anonymous, while we don't have anonymous PUDs yet.
 	 */
-	if (WARN_ON_ONCE(cp_flags & MM_CP_UFFD_WP_ALL))
+	if (WARN_ON_ONCE(cp_flags & (MM_CP_UFFD_WP_ALL | MM_CP_UFFD_RWP_ALL)))
 		return 1;
 
 	ptl = __pud_trans_huge_lock(pudp, vma);
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index a7659b0a1147..c96cfe0871dd 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2221,15 +2221,6 @@ static bool vma_can_userfault(struct vm_area_struct *vma, vm_flags_t vm_flags,
 	    !vma_is_anonymous(vma))
 		return false;
 
-	/*
-	 * RWP uses protnone as an access-tracking marker. PROT_NONE VMAs
-	 * have vm_page_prot == PAGE_NONE, so RWP resolution can't make a
-	 * page accessible -- the next access would fault again. Reject up
-	 * front instead of letting FOLL_FORCE loop on protnone+uffd PTEs.
-	 */
-	if ((vm_flags & VM_UFFD_RWP) && !vma_is_accessible(vma))
-		return false;
-
 	return ops->can_userfault(vma, vm_flags);
 }
 
@@ -3758,7 +3749,7 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
 	if (uffdio_register.mode & UFFDIO_REGISTER_MODE_RWP) {
 		if (!pgtable_supports_uffd() || VM_UFFD_RWP == VM_NONE)
 			goto out;
-		if (!(ctx->features & UFFD_FEATURE_RWP))
+		if (!(userfaultfd_features(ctx) & UFFD_FEATURE_RWP))
 			goto out;
 		vm_flags |= VM_UFFD_RWP;
 	}
@@ -3825,6 +3816,17 @@ static int userfaultfd_register(struct userfaultfd_ctx *ctx,
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
-- 
  Kiryl Shutsemau / Kirill A. Shutemov

