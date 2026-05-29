Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 122DACD6E4A
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 17:24:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76B2D6B00D0; Fri, 29 May 2026 13:24:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CF366B00D1; Fri, 29 May 2026 13:24:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BDC06B00D3; Fri, 29 May 2026 13:24:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 448DC6B00D0
	for <linux-mm@kvack.org>; Fri, 29 May 2026 13:24:23 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D7B5A120241
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:22 +0000 (UTC)
X-FDA: 84821131164.13.CE5027B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id C711720004
	for <linux-mm@kvack.org>; Fri, 29 May 2026 17:24:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aQGn8jt5;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780075460; a=rsa-sha256;
	cv=none;
	b=BSqTSP9iq34PzAnsJtY5tmlXc4CkKEjAAuO8y1yCVu0Y1/iAqi3B7ygo7FG1gQBPF6zWsP
	OPRv0ZHxPZRadRAo51myYdni9nOrJ8cWN6Yt+oqVXc2kBVafG4rZW2zEwpMniQBvL0Gsnx
	PL1skSaor+WbfniwVvt1eLF7Wz0X6Lk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aQGn8jt5;
	spf=pass (imf31.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780075460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVoJCbkI8s/nRA3AM39fhnw9JOfOtPPsCwAz6Lm0b5Q=;
	b=eDxk+SenmsVsl35eUweb2vQTwG70GrC73mdJzMjRSOgs6aK9grMypbX3hcEWy+45GLddut
	pz82OoVgnqKY65F6Hdv4TEVXWocwRGgtKzo/vhTRLqbOK2UCWsn/qJu3RGWFapkJBmpVa5
	RH0hxKFJOI1ApuSw0oACTcgA+Pzpmhw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E6C8C43B51;
	Fri, 29 May 2026 17:24:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE611F0089A;
	Fri, 29 May 2026 17:24:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780075459;
	bh=iVoJCbkI8s/nRA3AM39fhnw9JOfOtPPsCwAz6Lm0b5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQGn8jt5JO/pV0IPHLlF1MTcUbTx3kEDpUNSRD6eMocxYb9wKOacw+2grb3qpyQKh
	 cDBAYgAPCps2/YVZMZADwzwlTp9y30dA14IPaDohu8njgJap/DjLyQTs18jgs8DWJc
	 v3QnFexlWZZn2u9ZVT6iuOw2WIaT/rrIR8r90j/PE9aDLeQXiIm8KfHL8Rlktpoopd
	 udu6BsLOyOxjGzk/zRfwcJ2YZX+vGYR2YAf27WDT9gPKs37nJ72mbAmLTQFos/ceJg
	 +1iyTvWbQhAtoeXIFMy273NLTIhWrjh+It/Z7PIr9CIrWW63mx8CbEnyMVi70magMo
	 czYPo+mYzzxBw==
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfauth.phl.internal (Postfix) with ESMTP id EFD09F4006E;
	Fri, 29 May 2026 13:24:18 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-02.internal (MEProxy); Fri, 29 May 2026 13:24:18 -0400
X-ME-Sender: <xms:wssZahfg1iyrILJmAVPn7Y5U71gDd_f-OFbYItmdd0KPr3aLCPjhIQ>
    <xme:wssZamzjlwLLUcujOH6KKlzR-PvvDyHa9Z2NXBsaygguBo-FVd16klFtnkK_fjf2E
    iW5z3kLcn-qSM7tzlzLMePx-KqFEv0KSlzt9hFSIFlAcFD2mI6XjA4>
X-ME-Received: <xmr:wssZaqLnOfsoBBQMQHAYUIYoUG0jX5HCxDlCdtIvnFwAQp9bt9GS9MxcWwivOA>
X-ME-Proxy-Cause: dmFkZTFrgX5MM3DUSJ7xzqsXiT9K7Mp6hFpPFfxmC0MA+iN7AjFohwvWx7oxJHZ+5oTsa/
    eNprXeJ/674yJe1dHbWF7GZb1XnToVb0R4autdIDJiozLrBStYEb9fpXa/2JrApUqbrre1
    LdBuyJn9i8qKcJffyvK1YIhy0raIMBiWiOnHjwA5r86k+Zhi6bSohRFuPzPhOdP14jnWJI
    /xiWZuCo09JkwaiWtT4Gp2J4EUMHafSQnln9uaxNuylCfDh3CVEdSw0SaHR74GjGjlbPAf
    5lIf5oHRJw+wgkoNP7G5YvX9mPChAnbwGYXnMrRN1deEijcEXsq+k9G0Lzj5Q5OMaNJVZP
    ynHfTSCMN2Wglln7FwCeGxWcRR9bI2b3w8oJShKhvuMKIwP0IBVzf44fyIK2FGEUvOK548
    Eq/sQNY5Z1h23soaVM4lhxLQFbLksIU3Fsd8HKslIEZ0s+EQ8tfFmkcDNslrl9b1g0noyB
    LxGGX71AMWfXhsgBQSLBvluF8XBHVSeIQ9sxPjxnVVXsDHHaAwEFV3ywTZoDM30+wwW2T+
    e1UAgp4FmIIfSe+xihledFa9IIacTucEedO4UqqAbpFgVcLaeNQxsxaRON9wmaMXnTxUnr
    JggfNJowpV6m3GFgUHO3Qq9TKFsPiXlu4b06H73uaWUCYGZiIDRpW/m3fzVA
X-ME-Proxy: <xmx:wssZanuLzrazh-39vUG6hczDKFciamDflbxJP20bLeZXbscQwzr4GQ>
    <xmx:wssZakRt97rWJ0ocgpp2stNMAFQhYcJTUDdwRcMkHcbBIFbSX100Iw>
    <xmx:wssZagTcunkjrPIn-hJ-SoryF7MMRp0AG6MRenIXzsmao8VRQswdtw>
    <xmx:wssZaoph53enRFsixzoXKibo1H-xB5oMXn2GCdjnyo1Ofv9-X8AqiQ>
    <xmx:wssZaoDPxFfR1qG98TB-qkzqNA8guPLhR4muQ4DkAhvNNa4Y2T4nAvuh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 29 May 2026 13:24:18 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	stable@vger.kernel.org,
	Sashiko AI review <sashiko-bot@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Peter Xu <peterx@redhat.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH 6/6] userfaultfd: build __VMA_UFFD_FLAGS from config-gated masks
Date: Fri, 29 May 2026 18:23:30 +0100
Message-ID: <20260529172331.356655-7-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260529172331.356655-1-kas@kernel.org>
References: <20260529172331.356655-1-kas@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C711720004
X-Rspamd-Server: rspam03
X-Stat-Signature: xdqxymmk3mumthrcxsp59e4m58yjck4f
X-HE-Tag: 1780075460-203819
X-HE-Meta: U2FsdGVkX1/oKQdF4oO62PaMyeyIUPmALEneF9LK4yFXRmaO7Oc/Tr+aopLJ7r/V0Trwde34be9SN+VjORaKE4XvsD7xEx9d8g0wzNz8BBjErDVUyArQhRXF2FjRIICRa7+B95ivyc2zMWg5xF0vGnqoYmMCpudSTnz4195ofPh4pFK7+Ny/uYilsAKH/UhV02QzOalLiP+0R7OE9p+9Fw93aKbLaWaOjP/XoelGE0MEdKRv+GApNE+Y09B5AufwO6n4o2BcV+gUmk6jualSFDD6U1s5DPKu9d9rEAQT5z0K4dYMEcf64uLClzjAitcG2PGbFKCdPBrRzwQcAYOGAlmmhEZiWt7YuvR1ZeX16fgk5wspGSdKTGE4r9Ut9zQ0TEPrBYdYdiOYNZ+h5HrCzaIT/fIT/uVjAIzJgwmdlmfu9F20qcSShAjChqQv9YoPZ02KngepTI0V9fOcVWN0ZBoIJVKXMl1JYz3Eo4Azn2RZp6D21687Az84AsGOllDftr8YMSXP6nel8eSECADVxqXidzqeXOJyjvgw3s0d7dC2bLNOMq+1XB1aQT71FBlvp7jFSoc8fjy4BEIGyn4cKdX/M2YNtiNXjPaidvddCHBo8qV8eUuMZ23Wl9LgiR3yiUqvzrSCO1rcZ6zPdHhaxQw0XpgSZgtmvXRh7zIPqG8ttxWvp6QiiNIexUIpFS+BqOq3XgSjC1oKKwNqLRNRQLZaqKsFGnQkAGMZMX4UU8cIv4H3V2+LOSIdMjL4rLSDx1vliZR61n78DiILbJskUmxrbiAwFs4Lj0mjNyoVgplCMudv5HsYeNKhUkoojjNsQ9OFegc3kQ3ey2aryVyCEb2e4WA8EfMRXdOJrURd92i/siP9ZVjm8sOEOgdSYDTjE0wUDeaz6ezcRBDnSiEzD6dQvVlP9sc1EMxYRJs8StfF92qEURpF9Sn1MGtgKFdQgO2AgBBOumRZXOd6HrH
 8FUU+IyF
 SxPq4zQkuJ10oqvYFpKUa7eYcD7q4J6XFSZX1JciWtxr9pMvnIn9JRTmv8z93guz7hQdtLAiJMyh/bUb0Kafi7aNGhirK6DDtCo1HWXDzNF+f67fE/O1m4vSLlngKGUfv9KspJTZxC4WYq/Lh/Qe0a2+ZrLM0lEmzBdwFPw9CrlCEjhmbC/UQ4bNHHL58vQtqkxeCC/W9UUhgcCHzTq9OfPUcfq/Wfo9dlHnRsyUzF7eaQKuKEa7WI3oafGH8EcDydeT3d+veASge3OJ725TW6Ja30K72+l3U4NqbG+s+zQigcYmxVBCQ1H1kSA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The VMA flags bitmap is a single word today: NUM_VMA_FLAG_BITS is
BITS_PER_LONG, so on 32-bit vma_flags_t holds only 32 bits. (The bitmap
type exists so this can grow past BITS_PER_LONG later; until it does,
anything declared above the first word is out of range on 32-bit.) The bit
enum nevertheless declares some bits unconditionally above BITS_PER_LONG --
VMA_UFFD_MINOR_BIT is 41, with VM_UFFD_MINOR == VM_NONE on 32-bit so no VMA
actually carries the bit.

__VMA_UFFD_FLAGS feeds VMA_UFFD_MINOR_BIT to mk_vma_flags() unconditionally.
On 32-bit that becomes __set_bit(41, &one_long), a write one word past the
end of the single-word bitmap. The compiler folds the out-of-bounds store
with wraparound (1UL << (41 % 32) == bit 9) into the first word; bit 9 is
already in __VMA_UFFD_FLAGS so the mask happens to come out right today, but
it is an out-of-bounds write all the same, and any high-numbered bit whose
mod-BITS_PER_LONG position is otherwise unused would silently OR an extra
bit into the mask.

Rather than feed bit numbers that may not exist on the current build to
mk_vma_flags(), build the mask from whole per-mode masks that collapse to
EMPTY_VMA_FLAGS when their feature is unavailable. Add
mk_vma_flags_from_masks() for that, and define VMA_UFFD_MISSING / _WP /
_MINOR alongside the VM_UFFD_* flags, gating VMA_UFFD_MINOR on the same
config as VM_UFFD_MINOR (which implies 64BIT, where bit 41 fits). An
out-of-range bit is then never materialised, on any arch, and the in-range
fast path stays a compile-time constant.

Fixes: 9ea35a25d51b ("mm: introduce VMA flags bitmap type")
Cc: stable@vger.kernel.org
Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-8
---
 include/linux/mm.h            | 39 +++++++++++++++++++++++++++++++++++
 include/linux/userfaultfd_k.h |  4 ++--
 2 files changed, 41 insertions(+), 2 deletions(-)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 0f2612a70fb1..485df9c2dbdd 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -496,6 +496,21 @@ enum {
 #else
 #define VM_UFFD_MINOR	VM_NONE
 #endif
+
+/*
+ * vma_flags_t masks for the userfaultfd VMA flags. VMA_UFFD_MINOR is gated on
+ * the same config as VM_UFFD_MINOR -- which implies 64BIT, where the bit fits
+ * -- so an out-of-range bit is never fed to mk_vma_flags() on a build whose
+ * bitmap cannot hold it.
+ */
+#define VMA_UFFD_MISSING	mk_vma_flags(VMA_UFFD_MISSING_BIT)
+#define VMA_UFFD_WP		mk_vma_flags(VMA_UFFD_WP_BIT)
+#ifdef CONFIG_HAVE_ARCH_USERFAULTFD_MINOR
+#define VMA_UFFD_MINOR		mk_vma_flags(VMA_UFFD_MINOR_BIT)
+#else
+#define VMA_UFFD_MINOR		EMPTY_VMA_FLAGS
+#endif
+
 #ifdef CONFIG_64BIT
 #define VM_ALLOW_ANY_UNCACHED	INIT_VM_FLAG(ALLOW_ANY_UNCACHED)
 #define VM_SEALED		INIT_VM_FLAG(SEALED)
@@ -1238,6 +1253,30 @@ static __always_inline void vma_flags_set_mask(vma_flags_t *flags,
 #define vma_flags_set(flags, ...) \
 	vma_flags_set_mask(flags, mk_vma_flags(__VA_ARGS__))
 
+static __always_inline vma_flags_t __mk_vma_flags_from_masks(size_t count,
+		const vma_flags_t *masks)
+{
+	vma_flags_t flags = EMPTY_VMA_FLAGS;
+	size_t i;
+
+	for (i = 0; i < count; i++)
+		vma_flags_set_mask(&flags, masks[i]);
+	return flags;
+}
+
+/*
+ * Combine pre-computed vma_flags_t masks into one value, e.g.:
+ *
+ * vma_flags_t flags = mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_MINOR);
+ *
+ * Unlike mk_vma_flags(), which takes bit numbers, this takes whole masks --
+ * each of which may be EMPTY_VMA_FLAGS when its feature is unavailable -- so a
+ * bit that does not exist on the current build is never materialised.
+ */
+#define mk_vma_flags_from_masks(...)					\
+	__mk_vma_flags_from_masks(COUNT_ARGS(__VA_ARGS__),		\
+		(const vma_flags_t []){__VA_ARGS__})
+
 /* Clear all of the to-clear flags in flags, non-atomically. */
 static __always_inline void vma_flags_clear_mask(vma_flags_t *flags,
 		vma_flags_t to_clear)
diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index 3ec8e1071673..68edac4dcd78 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -23,8 +23,8 @@
 /* The set of all possible UFFD-related VM flags. */
 #define __VM_UFFD_FLAGS (VM_UFFD_MISSING | VM_UFFD_WP | VM_UFFD_MINOR)
 
-#define __VMA_UFFD_FLAGS mk_vma_flags(VMA_UFFD_MISSING_BIT, VMA_UFFD_WP_BIT, \
-				      VMA_UFFD_MINOR_BIT)
+#define __VMA_UFFD_FLAGS mk_vma_flags_from_masks(VMA_UFFD_MISSING, VMA_UFFD_WP, \
+						 VMA_UFFD_MINOR)
 
 /*
  * CAREFUL: Check include/uapi/asm-generic/fcntl.h when defining
-- 
2.54.0


