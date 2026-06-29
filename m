Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84174C43602
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:08:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17DE16B0096; Mon, 29 Jun 2026 08:08:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 155406B0098; Mon, 29 Jun 2026 08:08:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01CF46B0099; Mon, 29 Jun 2026 08:08:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B49526B0096
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:08:04 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2109EA0611
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:04 +0000 (UTC)
X-FDA: 84932826888.30.D249F9E
Received: from fout-a3-smtp.messagingengine.com (fout-a3-smtp.messagingengine.com [103.168.172.146])
	by imf18.hostedemail.com (Postfix) with ESMTP id 293BA1C000A
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:08:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="e h7Qa5K";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=bfRn6Vgu;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782734882;
	b=CpG6C4+uvqGo1CF42v7uSZZLts2+GVWisZpVPBNr3oAUm//XAlZ+do4Nw6yKu+B3u2/2VW
	gNCPNhloTg0QaHh3Oh1Lk5bLl0Rp2Rl3i+rPsNmg0nvV+nGpRjroC48FIQ94cbpURxHgMn
	TanC3ZmXUjydgYXFJ/EmGOdkeGg0qxU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782734882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EHyluruvg80LL7D5iPr6EokbEesUw4mOCnn0P49HM6w=;
	b=Lpckv0GtlrSeY0MR9a24FWXVHTxE8bfw7NQ1L+Cc7bp8GOuAQqM6a6oiGIm7CNiCAC2WN7
	GD+Q65Tp6DW0Wls2ZuOxehWdOB3MZS4XxLg6hZhour9r0lWp6BRGEtVhf1jQCvWvQlGJHC
	vQT1RGPSVgAs5VSnF7f/sy1BHNnPAIY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="e h7Qa5K";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=bfRn6Vgu;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of kirill@shutemov.name designates 103.168.172.146 as permitted sender) smtp.mailfrom=kirill@shutemov.name
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfout.phl.internal (Postfix) with ESMTP id A37C5EC0110;
	Mon, 29 Jun 2026 08:08:01 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-09.internal (MEProxy); Mon, 29 Jun 2026 08:08:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1782734881; x=
	1782821281; bh=EHyluruvg80LL7D5iPr6EokbEesUw4mOCnn0P49HM6w=; b=e
	h7Qa5KME6Si9/H3g4mXFqFTikZAg/bjSR5gzgnSfpQ2RIKIdbYel0TLOWWMDeyXc
	4p9HuMG0poiLfXfEZ7gZAgwTvuTXGRLHehNhvJV2aTUzaeL0gikZvRK43xMb702Z
	P3X3zqFB12NUkRx/oApq0029ln6CPLH/UHMcxNt6JZpRQGNL0IF4Ax8XddxAtuIT
	uvIlGX2NO8WtAHNCIq9cD8QpdcUb5Dr7WGRICO1K+PCSNCsBxhs/HINMd37RSGAx
	U4azuTMS8HUKGmICc5yg936TsTIxYdI31ssVE9Gyd6i14MCxtpa5w5KBUjBBNbsJ
	CjKMKcG4ZOusmJwbuczKQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1782734881; x=1782821281; bh=E
	Hyluruvg80LL7D5iPr6EokbEesUw4mOCnn0P49HM6w=; b=bfRn6Vguhv3lrAmz+
	wRODoDhCdGtpyayCl+DJMK/WjdOlX/nSqon4ZIQZMf7L7Jrf5t3DaDqmPdBkGQ5g
	tjOC+IoPnBMAnUkpXGiGfMAOWGDL/fuv1RwySqShkbc6py9NavcO6CrAs2V5r2GY
	ueMf1qTr4RKl23OtXqn+X4jq3wEm6zpD7lO6p18soN8CwlymL/C5nwQgB8c9SwXX
	At/47cfWm16TXWovcyCmbry7ByC7wvLKw2SmMAARH2yJTvNq4lR6q0jPKyq/qmo3
	8cKe4iK1wJn7VuRI+0+LJsyeoSZOoIs5MfkcRMjdj7tGMFcwsVnQYhiYkGevwYNd
	JvNIA==
X-ME-Sender: <xms:IWBCamsuYPw6t63GuVFaADZHia_SJ6gL9zbl-JYsM58Y4aFSd8kwYw>
    <xme:IWBCavYsdkG0R9YVhsCS08PRDrNeWiBgO4jIKGnc2k7kaRtL1sLgd6BT9EHA25eD7
    hw5eG6H-pYEhgltAZtwHiYUWET_Bla4ORSIuuBgFpMHil7MUZgxJLQ>
X-ME-Received: <xmr:IWBCaqRoOxtF7898Vsn3uH95fOzJ4OK5Gb-8kj4pUoJY1DLUIwKaUm03o0NpUQ>
X-ME-Proxy-Cause: dmFkZTFkUUhwNS2UOAVx/IBbrzKXSreY+ak5DIStIDnIdf8ollE3srlBToeHRa//rheBNl
    79FgyiGmsdvZU/Tcz6Ujyy6P3H93DpTv3pkfdsrpJF+EaJOyGAHjK/DX1ir7D/rxOetcfJ
    ACRJMyCr8ijnBJ1owvTutR0gnBGS/Auv/bw8Cq01Q+42YQK8DlOO/FEN8wDymld3vUOixc
    JS+bfo1+VjOWPY58FDUC5sxmrU54vs6rhQDll18DTBH06Oaq4bt2D9o4FhN6FkWhBoy3zM
    rjuZ7jrhTY5AfeQo9ZSo4Yh4SfU4ip1tCepzSIQnQxC3PArs6Fsrkd3q7w1mF77YDFbdb8
    5rAve2jCMwTpEAl3iwF85t3VaQSCF10+Xh5n1igRCUyGdkG5IuwUI3JLDp3MAwmXWu0bi7
    iFHUVSBGzQ+HSFVX7nPipCHTLPRrkNrAk89kKnyLYBn/8iBT/xiTtIjmdaAzYo3TspigLJ
    OxIeAM8FYqhOIWa8J94ldpS83L4Th535F4RJh45dBdzIdaN8M8cunljURRqfJX7OUffcKh
    3FsD0Ljv0YHiCPYf5b2wtQr4Qo0Sn/4zn5H287vDRTogeVF2RLEc7NpttrX2vAsm6VwBz+
    ohY3VWJlWQk1wbC0l7b81I5ypsW9lQ4XTok6Ix4l4jAXQE0BsakdhC01eSqQ
X-ME-Proxy: <xmx:IWBCaqz2WhnjAbGNJPYGGDq31wI0Kd__asEcOVTXMqhD3Ng_Ck-eog>
    <xmx:IWBCaufhseLq1Eu4FN9IwKLhqnMBrfqn0HpE7sVfIgvVA3X13yWjyw>
    <xmx:IWBCajrL7-jjKKF5fYG6TpYAJtop7jYt47V7jh5fsjA2N0rELg68Ow>
    <xmx:IWBCauPJGJQyXYheqMENcMIGyl5Cp-EUDbHMNXmxTVgirIkiW-_9sw>
    <xmx:IWBCapLJr5sdFJ6v07GeqEhiWt3XdZs1rruIY2lebrtAyxPtDqInLZDD>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 29 Jun 2026 08:08:00 -0400 (EDT)
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
Subject: [PATCH v7 05/15] mm: add VM_UFFD_RWP VMA flag
Date: Mon, 29 Jun 2026 13:07:36 +0100
Message-ID: <20260629120749.566063-6-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260629120749.566063-1-kirill@shutemov.name>
References: <20260629120749.566063-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 293BA1C000A
X-Rspam-User: 
X-Stat-Signature: 5pnb9zh4dngirgpggkw6y9cqg63fz4zt
X-HE-Tag: 1782734882-239465
X-HE-Meta: U2FsdGVkX18+JbVDKGbKgNKvLBf9WiDw2Hb+jH5+t4LVg0otxgnEBtKkjCyAM0idr8F0ehbvYGIbEdGQFjBpKifJ7OUAZdiK5nbAOm8v+7HYSDd+PydJkYNNWAPFP4pIxn77AuinlvZZWxWz1OTJYNjv30qNI3U0Ei73XjLtjGwycs9Iq9ofBIJf2lhcXXqwXP0snVwGV9bDfzfU/Z1mGjbYhxUD2vRXSBxinyBFK8AZvDPUN1G6o/lEB3KX/TXB2yZ6IYqrB5TQyTthobfwfuPfJR9GLSjPsBk+Ht7uBr+jsxutJHH471o7XkdfAE7rffiK16kAQbg44dx6DPUHXFxLq1StWZ6IWeVpImGzoyzeH/IdThkqp9E5wQZpCuR6dYNpAhMMvZNlV601Lxy3f9f7+1muEWizcV/b4ewLMRN26yIXZJTVxreIHcybYSre+OLr80bictWg5N522BRhTsmJy0+KM+ZCuBjBvFTxpfVnKgvd156VrkTKVyXR2ik1xtqhX+bt28A+Cnghw8d17OMUNWmvCCUqapieyENPTGKsYI10s/mlD5YLskDQA4y/7ztb3F60r7Qb8d2lqt4WagFfQkGLh5OWuDra+cm+xyq99pdH3I5eO3KXHcbwVJZJfXq5knuy+buCMKYxWqwt42ANuCUS8iT5cO9yoMvlnB0EOztD/E/MK8M3LQqsQ0T9gTEOwGiDZN9ytEJmCfvY9c0eIw2Ajs0nGepAoF6AjPBVrjRjCTrCUb+MAMrQcsXPT2X0wXn7GbbwCkH2qphVBowcMfgN/uHGqLbhP+wmIUyiZYvOkbVHHz52kIgoUWGICTP+tTGGWKnyyuACwHWth5PhbDa/kvmT/702bR3Rua96WHLimYhiBNchMiXmGp/0yy1R3o2aIiLeWrQuq9oqS9N8dJ3NfpCeZ+/lX1uH+4eZ/saEP/NtLAPTkWVAkC9f728qoUg73CmCFCrIQUY
 rom3RJfv
 0Ox8l9525r6ZjhR25N07KCKqME50mSmVOBtnIGsa3fkQr39shxpH127cvmakcWa4NFb3xKKCk0p3yiQpdPSnTzKqNa9th5kfRUDXn60YTtM91qQlndRvw0zNq4EOJuWmy4upI2k7vShhbEQeNrsxS1PNZmIIj+naE4L6KNd2biMdxspHJSqZCPclNAhrfbbVwSDRpZK4IaOFqOjmg5gafc5MLNW7RdyNhOthjIPTKzbZ47fkjRu1sLEjNzzBZJtdRd9YmTVpNmqaWGFxVyfCUoecbvuyxYpQvEvZr0R8TsMLSa9Yza5PZoANPSaKX2VCYI8lcKz67pBV/PcHJJcjmt8tQrv0Sr74xaZf5Jtc3kZiXDjADs+FWiSdwu4P4DBa9Tx6vujFXRBYf6W1fn8e745xqcKj9NGVbuQJr2mpdHoH1r0psNfJBXPom+VziA38qdAkXVW8JC2O6nawfeFjYx+78LspbTEdBIoISpDd0QXDK8GmWhogHwDAQNg==
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
 fs/proc/task_mmu.c                 |  3 +++
 include/linux/mm.h                 | 41 ++++++++++++++++++++----------
 include/linux/userfaultfd_k.h      | 32 +++++++++++++++++++----
 include/trace/events/mmflags.h     |  7 +++++
 5 files changed, 65 insertions(+), 19 deletions(-)

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
index 56deb516b193..5b55c59573a3 100644
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
index 485df9c2dbdd..5ac31fbadeef 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -353,6 +353,7 @@ enum {
 #endif
 	DECLARE_VMA_BIT(UFFD_MINOR, 41),
 	DECLARE_VMA_BIT(SEALED, 42),
+	DECLARE_VMA_BIT(UFFD_RWP, 43),
 	/* Flags that reuse flags above. */
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT0, HIGH_ARCH_0),
 	DECLARE_VMA_BIT_ALIAS(PKEY_BIT1, HIGH_ARCH_1),
@@ -496,12 +497,17 @@ enum {
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
@@ -510,6 +516,11 @@ enum {
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
@@ -648,22 +659,24 @@ enum {
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
index c4f2cc6dfcf0..61ea83dbd026 100644
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
@@ -179,7 +180,8 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(struct vm_area_struct *vma,
 static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vma)
 {
 	return vma_test_any_mask(vma,
-		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR));
+		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR,
+					VMA_UFFD_RWP));
 }
 
 /*
@@ -210,6 +212,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
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
@@ -330,6 +342,16 @@ static inline bool userfaultfd_minor(struct vm_area_struct *vma)
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
@@ -423,8 +445,8 @@ static inline bool userfaultfd_wp_use_markers(struct vm_area_struct *vma)
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


