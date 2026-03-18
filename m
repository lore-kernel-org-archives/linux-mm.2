Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D58FD10775FC
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 17:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11B186B02C9; Wed, 18 Mar 2026 13:48:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0CBC16B02CA; Wed, 18 Mar 2026 13:48:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFD8B6B02CB; Wed, 18 Mar 2026 13:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DAFDB6B02C9
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:48:04 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 931F9BB859
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:48:04 +0000 (UTC)
X-FDA: 84559917288.20.E7B4F0F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D05E3120014
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 17:48:02 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jzROPGVp;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773856082;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VGL8ZCoxxnmMgegD515h89Z98Ff8Q4k3igrZcTWq+F4=;
	b=FT3PeYDzpyKCFs0/tZ2tq4oCfgTOyXpPF3JX9x3/Q5rOGdNPJpq6NnnhRMiUMdcqeFWfYk
	/Y9OllI+flprDlFwZyLTfFvc/PpYf+tdaHx/gGIoE/7R6CSUVfr89LClmCKM5VjL1QGxVq
	kpswYhIV2IqWovs0OrDxAoBYEF2HKD4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773856082; a=rsa-sha256;
	cv=none;
	b=xzzu4OwSru8ROQ6HwT/mx0ROT2vfO1xFo0EsbOsa+UTtA1XjBW6/M6JCYkW2nQEhihQtqu
	2IK4JJVacAXz4oDMTPvZBFKZIXKMsUn1Jbb4FcfgsiUiJxO2KhYB07/s1kJL311q94uS1i
	bxsRRdySOCtiseGq/Ki5B9NYIo584Y8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=jzROPGVp;
	spf=pass (imf29.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EB51A60132;
	Wed, 18 Mar 2026 17:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99B7CC19421;
	Wed, 18 Mar 2026 17:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773856081;
	bh=hq72KfDI9YIjm4UqddYP9KoqIbbXOeXeI0l+6wtPMMo=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jzROPGVpzZ38jRINIUlrs6pYfFojw6d5rE/vbNiFKT2UViwtaZd0lDJtPPR3nnuYS
	 FF9HJXYzwRihCsjyfkE7AMRmpanGALhCQ9VX7i/W6cYBSjxY2y2GwDDanrboMs/kOZ
	 kogswLXx++OfebTDVl2acbny9BYIqCrFpBBH+dng=
Date: Wed, 18 Mar 2026 10:47:59 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, Jann Horn
 <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Kees Cook
 <kees@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vineet
 Gupta <vgupta@kernel.org>, Russell King <linux@armlinux.org.uk>, Catalin
 Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, Brian
 Cain <bcain@kernel.org>, Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui
 <kernel@xen0n.name>, Thomas Bogendoerfer <tsbogend@alpha.franken.de>, Dinh
 Nguyen <dinguyen@kernel.org>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Paul Walmsley <pjw@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>,
 Alexandre Ghiti <alex@ghiti.fr>, Heiko Carstens <hca@linux.ibm.com>, Vasily
 Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>, Sven Schnelle
 <svens@linux.ibm.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar
 <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, Dave Hansen
 <dave.hansen@linux.intel.com>, x86@kernel.org, "H . Peter Anvin"
 <hpa@zytor.com>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Xu Xin
 <xu.xin16@zte.com.cn>, Chengming Zhou <chengming.zhou@linux.dev>, Michal
 Hocko <mhocko@suse.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley
 <stephen.smalley.work@gmail.com>, Ondrej Mosnacek <omosnace@redhat.com>,
 linux-snps-arc@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 linux-hexagon@vger.kernel.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 linux-um@lists.infradead.org, linux-fsdevel@vger.kernel.org,
 selinux@vger.kernel.org
Subject: Re: [PATCH v3 00/23] mm/vma: convert vm_flags_t to vma_flags_t in
 vma code
Message-Id: <20260318104759.92b339d382e7d8d25daea54b@linux-foundation.org>
In-Reply-To: <cover.1773846935.git.ljs@kernel.org>
References: <cover.1773846935.git.ljs@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D05E3120014
X-Stat-Signature: oedig7x9zs5jmhoe3d1dy5w8tzqi8etg
X-Rspam-User: 
X-HE-Tag: 1773856082-486228
X-HE-Meta: U2FsdGVkX1+mWgn94GEDIQURoyjPw/Ipx9Hggxu3wvXettsyHZGgwjuHZVnTmEbJlS7ZeAV3wN/BQ6mUpnCQuV/+dqLXZopbUZARyroC+383JAhw8Y9PXfGMLbTjyH4rdtTCOQhwGWxW9jVJesFikjpDz7JczyRbVRMrwAhI1cocFvmQFLPsF3J8vk7jzBa1gFE+pUp+H50eQlZL6xtBQwoB/+3jq1VvESBT3CpYIumKLLmoKtU5KkJ5SsCTxQwoLEHYakao0TMX0VQ7eDotn6PVn0XatolbJp4ZEdMeNIw2BevEb7E/aNlTK7WN4EvCYYm0M93S2QwynNQHA05SSHv2XG6/l9N51+9qsETR2uk0DW080I/PD0ZM1ZhGhB2qLnA9m+GlreLRNIfQjLhoGDXfZHpRjIGP8S7Ez8phUl2DHF2e2MWxnQEqLBn4emQQevjvmhqPc2TwoCRuqtRJPBEC02prjq6eNl7gRVOdiZF+fNjd8koXfjwj1+DC+IH+d3XGFIfMcziXCiehYNJD7Rfkpp9hWXeo5z5l4TfXdwpRCN4O50xee2wdZVJEQmYHzLOPMJEN18dLYTyjgYJh1chdF2btnl4PV7WJn61UywXgpRLnEg4Knl7YcUi92CH1C/xA2l8uYaNB0i62XTiW1/QtMIzXISdV5TvDume1PTh85o2Y/eDTR/P5IWU41C5rMPKitetQZgVW3lGKXlc8+Utlt8nkYk658dbEU0fzWyZY/6469Y9lg6dP5CiF8kEmR8k9LDUeFeVFSkv+sg2wwz9qq1dWzdqDDhi4GUV0paFoUxOjtJjdLCjHc3VdxCRiIeezkqvlK/gg5RUoUQutukrDfZVFwN5y9XhGe56kuIb8BtyurT/MOdt1VolxUYzbqcKsCPIvOMqsrkK1g+kCbTW+u3/cv2jeOLHfDcm9i5jxAk9n+f3fuYpYfXqNzyfFTDpYZcvbOHlaVwIcQg2
 jYADEaMF
 3NE7S7B/bgrT2V1p3O0o/S4Jzo4xFwBRPDsYVWrlG55492MG+XkOfDDor0lCn8hBrCMrY+e0f4Us+hJkSsWAoed8CjAfp4/w5fnJ/TO72+Wh9XGII3REjENDvznf8DOFB6JvwaR8pafavPnZLcd3eyyNEQEXm25sa9Md91VpLmYIdhY6KVsIF7OOKQCfu3gNzPS9PPmAOnegmZI8Tl68gUDJdNuUH37BWb9uv0qVzffFMchltxxgU3Sr9AZN0zXFu2AZurS2LG6dNAlntbz4tTJg0dqcMBk6PbrJDaFQZTKVOg2NDSnj6stUu8aiwsZwmTI1C8SiGY524SD+idafCwJiYqg2INiuurWdyB+nf1712uDTFNbKAoyfKO8gFcKamRLDZwBzZ4G6JxpA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 18 Mar 2026 15:50:11 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:

> This series converts a lot of the existing use of the legacy vm_flags_t
> data type to the new vma_flags_t type which replaces it.

Updated, thanks.  Below is how v3 altered mm.git:


 arch/arm64/include/asm/page.h   |    4 +++
 include/linux/mm_types.h        |   32 +++++++++++++++---------------
 mm/mseal.c                      |    1 
 mm/vma.c                        |   27 +++++++++++++------------
 tools/testing/vma/include/dup.h |   22 +++++++++++---------
 tools/testing/vma/tests/vma.c   |    3 --
 6 files changed, 48 insertions(+), 41 deletions(-)

--- a/arch/arm64/include/asm/page.h~b
+++ a/arch/arm64/include/asm/page.h
@@ -46,8 +46,12 @@ int pfn_is_map_memory(unsigned long pfn)
 
 #endif /* !__ASSEMBLER__ */
 
+#ifdef CONFIG_ARM64_MTE
 #define VMA_DATA_DEFAULT_FLAGS	append_vma_flags(VMA_DATA_FLAGS_TSK_EXEC, \
 						 VMA_MTE_ALLOWED_BIT)
+#else
+#define VMA_DATA_DEFAULT_FLAGS	VMA_DATA_FLAGS_TSK_EXEC
+#endif
 
 #include <asm-generic/getorder.h>
 
--- a/include/linux/mm_types.h~b
+++ a/include/linux/mm_types.h
@@ -871,9 +871,9 @@ typedef struct {
 #define EMPTY_VMA_FLAGS ((vma_flags_t){ })
 
 /* Are no flags set in the specified VMA flags? */
-static __always_inline bool vma_flags_empty(vma_flags_t *flags)
+static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
 {
-	unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap = flags->__vma_flags;
 
 	return bitmap_empty(bitmap, NUM_VMA_FLAG_BITS);
 }
@@ -1082,20 +1082,6 @@ static __always_inline vm_flags_t vma_fl
 }
 
 /*
- * Helper function which converts a legacy vm_flags_t value to a vma_flags_t
- * value.
- *
- * Will be removed once the conversion to VMA flags is complete.
- */
-static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
-{
-	vma_flags_t ret;
-
-	ret.__vma_flags[0] = (unsigned long)flags;
-	return ret;
-}
-
-/*
  * Copy value to the first system word of VMA flags, non-atomically.
  *
  * IMPORTANT: This does not overwrite bytes past the first system word. The
@@ -1110,6 +1096,20 @@ static __always_inline void vma_flags_ov
 }
 
 /*
+ * Helper function which converts a legacy vm_flags_t value to a vma_flags_t
+ * value.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
+{
+	vma_flags_t ret = EMPTY_VMA_FLAGS;
+
+	vma_flags_overwrite_word(&ret, flags);
+	return ret;
+}
+
+/*
  * Copy value to the first system word of VMA flags ONCE, non-atomically.
  *
  * IMPORTANT: This does not overwrite bytes past the first system word. The
--- a/mm/mseal.c~b
+++ a/mm/mseal.c
@@ -77,6 +77,7 @@ static int mseal_apply(struct mm_struct
 					       curr_end, &vma_flags);
 			if (IS_ERR(vma))
 				return PTR_ERR(vma);
+			vma_start_write(vma);
 			vma_set_flags(vma, VMA_SEALED_BIT);
 		}
 
--- a/mm/vma.c~b
+++ a/mm/vma.c
@@ -905,20 +905,21 @@ static __must_check struct vm_area_struc
 	vma_start_write(middle);
 
 	if (merge_right) {
-		const vma_flags_t next_sticky =
-			vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
+		vma_flags_t next_sticky;
 
 		vma_start_write(next);
 		vmg->target = next;
+		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
 		vma_flags_set_mask(&sticky_flags, next_sticky);
 	}
 
 	if (merge_left) {
-		const vma_flags_t prev_sticky =
-			vma_flags_and_mask(&prev->flags, VMA_STICKY_FLAGS);
+		vma_flags_t prev_sticky;
 
 		vma_start_write(prev);
 		vmg->target = prev;
+
+		prev_sticky = vma_flags_and_mask(&prev->flags, VMA_STICKY_FLAGS);
 		vma_flags_set_mask(&sticky_flags, prev_sticky);
 	}
 
@@ -1170,13 +1171,14 @@ int vma_expand(struct vma_merge_struct *
 	bool remove_next = false;
 	vma_flags_t sticky_flags =
 		vma_flags_and_mask(&vmg->vma_flags, VMA_STICKY_FLAGS);
-	const vma_flags_t target_sticky =
-		vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
+	vma_flags_t target_sticky;
 	int ret = 0;
 
 	mmap_assert_write_locked(vmg->mm);
 	vma_start_write(target);
 
+	target_sticky = vma_flags_and_mask(&target->flags, VMA_STICKY_FLAGS);
+
 	if (next && target != next && vmg->end == next->vm_end)
 		remove_next = true;
 
@@ -1192,12 +1194,6 @@ int vma_expand(struct vma_merge_struct *
 		       target->vm_end > vmg->end, vmg);
 
 	vma_flags_set_mask(&sticky_flags, target_sticky);
-	if (remove_next) {
-		const vma_flags_t next_sticky =
-			vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
-
-		vma_flags_set_mask(&sticky_flags, next_sticky);
-	}
 
 	/*
 	 * If we are removing the next VMA or copying from a VMA
@@ -1214,8 +1210,13 @@ int vma_expand(struct vma_merge_struct *
 		return ret;
 
 	if (remove_next) {
+		vma_flags_t next_sticky;
+
 		vma_start_write(next);
 		vmg->__remove_next = true;
+
+		next_sticky = vma_flags_and_mask(&next->flags, VMA_STICKY_FLAGS);
+		vma_flags_set_mask(&sticky_flags, next_sticky);
 	}
 	if (commit_merge(vmg))
 		goto nomem;
@@ -2950,7 +2951,7 @@ out:
 	if (vma_flags_test(&vma_flags, VMA_LOCKED_BIT))
 		mm->locked_vm += (len >> PAGE_SHIFT);
 	if (pgtable_supports_soft_dirty())
-		vma_flags_set(&vma_flags, VMA_SOFTDIRTY_BIT);
+		vma_set_flags(vma, VMA_SOFTDIRTY_BIT);
 	return 0;
 
 mas_store_fail:
--- a/tools/testing/vma/include/dup.h~b
+++ a/tools/testing/vma/include/dup.h
@@ -441,9 +441,9 @@ struct vma_iterator {
 #define MAPCOUNT_ELF_CORE_MARGIN	(5)
 #define DEFAULT_MAX_MAP_COUNT	(USHRT_MAX - MAPCOUNT_ELF_CORE_MARGIN)
 
-static __always_inline bool vma_flags_empty(vma_flags_t *flags)
+static __always_inline bool vma_flags_empty(const vma_flags_t *flags)
 {
-	unsigned long *bitmap = flags->__vma_flags;
+	const unsigned long *bitmap = flags->__vma_flags;
 
 	return bitmap_empty(bitmap, NUM_VMA_FLAG_BITS);
 }
@@ -775,7 +775,9 @@ static inline bool mm_flags_test(int fla
 static __always_inline void vma_flags_overwrite_word(vma_flags_t *flags,
 		unsigned long value)
 {
-	*ACCESS_PRIVATE(flags, __vma_flags) = value;
+	unsigned long *bitmap = flags->__vma_flags;
+
+	bitmap[0] = value;
 }
 
 /*
@@ -787,7 +789,7 @@ static __always_inline void vma_flags_ov
 static __always_inline void vma_flags_overwrite_word_once(vma_flags_t *flags,
 		unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	WRITE_ONCE(*bitmap, value);
 }
@@ -796,7 +798,7 @@ static __always_inline void vma_flags_ov
 static __always_inline void vma_flags_set_word(vma_flags_t *flags,
 		unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	*bitmap |= value;
 }
@@ -805,7 +807,7 @@ static __always_inline void vma_flags_se
 static __always_inline void vma_flags_clear_word(vma_flags_t *flags,
 		unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	*bitmap &= ~value;
 }
@@ -835,9 +837,9 @@ static __always_inline vm_flags_t vma_fl
  */
 static __always_inline vma_flags_t legacy_to_vma_flags(vm_flags_t flags)
 {
-	vma_flags_t ret;
+	vma_flags_t ret = EMPTY_VMA_FLAGS;
 
-	ret.__vma_flags[0] = (unsigned long)flags;
+	vma_flags_overwrite_word(&ret, flags);
 	return ret;
 }
 
@@ -1073,8 +1075,8 @@ static __always_inline void vma_clear_fl
 	vma_flags_clear_mask(&vma->flags, flags);
 }
 
-#define vma_clear_flags(vmag, ...) \
-	vma_clear_flags_mask(vmag, mk_vma_flags(__VA_ARGS__))
+#define vma_clear_flags(vma, ...) \
+	vma_clear_flags_mask(vma, mk_vma_flags(__VA_ARGS__))
 
 static __always_inline bool vma_desc_test(const struct vm_area_desc *desc,
 		vma_flag_t bit)
--- a/tools/testing/vma/tests/vma.c~b
+++ a/tools/testing/vma/tests/vma.c
@@ -356,10 +356,9 @@ static bool test_vma_flags_clear(void)
 
 	/* Cursory check of _mask() variant, as the helper macros imply. */
 	vma_flags_clear_mask(&flags, mask);
-	vma_flags_clear_mask(&vma.flags, mask);
+	vma_clear_flags_mask(&vma, mask);
 	vma_desc_clear_flags_mask(&desc, mask);
 #if NUM_VMA_FLAG_BITS > 64
-	vma_clear_flags_mask(&vma, mask);
 	ASSERT_FALSE(vma_flags_test_any(&flags, VMA_EXEC_BIT, 64));
 	ASSERT_FALSE(vma_test_any(&vma, VMA_EXEC_BIT, 64));
 	ASSERT_FALSE(vma_desc_test_any(&desc, VMA_EXEC_BIT, 64));
_


