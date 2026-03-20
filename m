Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 458801099B37
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:39:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B48B36B0174; Fri, 20 Mar 2026 15:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFAE26B0175; Fri, 20 Mar 2026 15:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C23C6B0176; Fri, 20 Mar 2026 15:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 82B4E6B0174
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:39:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 47CD613A8DA
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:14 +0000 (UTC)
X-FDA: 84567455028.09.00EDA20
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id BAF9240006
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:39:12 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lpAQUmdy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774035552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=170DByzvbvP9k4XcrU8GXJj5O6OctxAxX7WxB8sLaRU=;
	b=HO/qGyQLbiE7SVcAgSNOnCSsXj9lyPXAcpVZ9QtdfrzmC8FGvmDZxbRIdy91j5QJpXUXIf
	YdsvFWrBqs8wsn1Io0Nb3PGgO0xDpYfw4UZRIR+VaCT4zl0YkoWyJ5dt24DHSqwRz5Qsbq
	Tf83XLnFeIkpygawE45LIdjpk3KbXRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774035552; a=rsa-sha256;
	cv=none;
	b=c8vz8VU8vOzsPtNkyM2C4eCrllqIKik5EpFfaENp/PKmrPbfPbvkCLYHdba0AseaRCCcJL
	hS6KLWP21tiCzIp+Lqnn+LPrEkJukDT7m1+1ftzLjL/UX/jUxDlKkmNdWIHsi3HiJQ59M4
	WkPec9NhBt9C2jWoHklf8/ndSaArMOk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lpAQUmdy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D349C400CE;
	Fri, 20 Mar 2026 19:39:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FE2FC19425;
	Fri, 20 Mar 2026 19:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774035551;
	bh=lxWfA+t9zzqjUdufUd1GoiM48lK3fJwyqfSRLCG77ro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lpAQUmdy3kgCqV/DDmFMnnZRjXoNAbs/BsNWZ+K0NoSYku9PqAhb2cykSq5iWBG1l
	 JvOTJHZtZswImdZxa8eLnCY+1N5PeGjAIS5K3BxtBGyeu3R7ht0+Ppuq/Mc50fMpxS
	 iuFJqqfY7xOSlNw+79DoCKgp+EAGa79eY27hDApsJoCETY+/9FcUljejok72YO5obI
	 yWlUx+bxQan63XtiSTYdzVqJyuWJh2L2qBUHTUpo0qcY+fS7yH5jAeAfglZZDcwzRw
	 9SKCWACa/HCKMiMunraFqBWV0oyVtNm666sTvGctVHd4l9q2gPrM0aQ1RoAqtQivfT
	 szMXMGmvK6KLA==
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Vineet Gupta <vgupta@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Brian Cain <bcain@kernel.org>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Michal Hocko <mhocko@suse.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <stephen.smalley.work@gmail.com>,
	Ondrej Mosnacek <omosnace@redhat.com>,
	linux-snps-arc@lists.infradead.org,
	linux-arm-kernel@lists.infradead.org,
	linux-hexagon@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-mips@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-um@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	selinux@vger.kernel.org
Subject: [PATCH v4 11/25] mm/vma: introduce [vma_flags,legacy]_to_[legacy,vma_flags]() helpers
Date: Fri, 20 Mar 2026 19:38:28 +0000
Message-ID: <d3569470dbb3ae79134ca7c3eb3fc4df7086e874.1774034900.git.ljs@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774034900.git.ljs@kernel.org>
References: <cover.1774034900.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BAF9240006
X-Stat-Signature: pepy7u4tq7t9eyegb4x4qg4me3zhjghc
X-Rspam-User: 
X-HE-Tag: 1774035552-871037
X-HE-Meta: U2FsdGVkX18gY3YAiBnKfeT7X0y7OBiEGQvMO1onbjB7MkLFOZmaZZGeknH8hP2mEag7axRcKBUEtzTlCgH2aKSJVCJ1LdJlJJ9QC47Sqgr/BKeawK964waG9v5Qi9gWfGmOCkGSwFCUcOgYevIZrhUgaU6ouMYju1b/Rn0icXY1jQJoaqUELC0KT+NRko9odRjH67R+aGgRcwyybgJ71usiefRz4dfk3sSyMU7YTVSM+Pwp2l1R1EBwbcDOI+Cj1ED8Pq7pLU6Wp3ymvv2n/6+OC1wYSoWT2JsHiDNz/iLyxUMETq6gyTLNPEV7BUwup1UPg2MbHc+kg1t8kazjAY5bxbmYDsf3SpSpLadm4xf6YKv3FK/BLGL0qXse0hPjr/2whliESd0iebf6p9nT7DZAuO9v65Ic/h+dFKaDc6IMR0nnrvIeGvOT0LK/lWqvMaz5E0z0bgpZ30DTjQkvdRnq9ighZ8iCtP13Sh9cnm3yl/KHbNUZr6zEFOYhHOU6Y9DDKlk1iwKsEKmBjh+wBaN1XdpSoPOwWHQf0niTMiQ69kZsSHx0R09JCIIChz778XPczmJg97xsHjaL1nF16An2w4rV2lIZc1nRI/3GJ96CVRQpnCvrFbyZ3njfFfGx0zJ3svQGOXfvVPDeWchL7euEGOvieQArrS0nvQ8wtQQiOOKhK7QdBGsk+zBScdXuPSkcrsAJRxI9qseOhaNdlt7PXBG5F2Sygq11lebF7coeZveA9DiaKZ2jsZa5TWgInhj9Y1WBDmIZDIzrfu+XvCo1UrspJKeUP9at1e+4SEDEjJRlTu2MCYbiDbntEg0gwM7Ireg3KkYn3rbu0ZWQXE+2nJmBjwHlufGwNMWeFqf4WOkxvZgnao+bJP/sSGcndIrI9a9nZ+EOP7T9zTVIokZB4L83h2g0qPOkhv5f4V9gMTdzF7MqpJPKgaZePELFc0IFJNf/Mq2IEVwIiyZ
 6i1BFC5Q
 MeDv92+VSH06Pehr2lK/ZOc2kWhi1rck0ENrdQ5/clNoZpyR7yfg3rhaxTGcCHk36DJu4NGGyNEb8rA9j4lJCsP0ofBk2e29cfvV/Uiy/Yzyg77I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While we are still converting VMA flags from vma_flags_t to vm_flags_t,
introduce helpers to convert between the two to allow for iterative
development without having to 'change the world' in a single commit'.

Also update VMA flags tests to reflect the change.

Finally, refresh vma_flags_overwrite_word(),
vma_flag_overwrite_word_once(), vma_flags_set_word() and
vma_flags_clear_word() in the VMA tests to reflect current kernel
implementations - this should make no functional difference, but keeps the
logic consistent between the two.

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
---
 include/linux/mm_types.h        | 26 ++++++++++++++++++++++++
 tools/testing/vma/include/dup.h | 36 +++++++++++++++++++++++++++++----
 2 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index 47d64057b74c..c5ad55b8a45b 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1069,6 +1069,18 @@ static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 	bitmap_zero(flags->__vma_flags, NUM_VMA_FLAG_BITS);
 }
 
+/*
+ * Helper function which converts a vma_flags_t value to a legacy vm_flags_t
+ * value. This is only valid if the input flags value can be expressed in a
+ * system word.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vm_flags_t vma_flags_to_legacy(vma_flags_t flags)
+{
+	return (vm_flags_t)flags.__vma_flags[0];
+}
+
 /*
  * Copy value to the first system word of VMA flags, non-atomically.
  *
@@ -1082,6 +1094,20 @@ static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long va
 	bitmap[0] = value;
 }
 
+/*
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
 /*
  * Copy value to the first system word of VMA flags ONCE, non-atomically.
  *
diff --git a/tools/testing/vma/include/dup.h b/tools/testing/vma/include/dup.h
index 65f630923461..f49af21319ba 100644
--- a/tools/testing/vma/include/dup.h
+++ b/tools/testing/vma/include/dup.h
@@ -766,7 +766,9 @@ static inline bool mm_flags_test(int flag, const struct mm_struct *mm)
  */
 static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long value)
 {
-	*ACCESS_PRIVATE(flags, __vma_flags) = value;
+	unsigned long *bitmap = flags->__vma_flags;
+
+	bitmap[0] = value;
 }
 
 /*
@@ -777,7 +779,7 @@ static inline void vma_flags_overwrite_word(vma_flags_t *flags, unsigned long va
  */
 static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	WRITE_ONCE(*bitmap, value);
 }
@@ -785,7 +787,7 @@ static inline void vma_flags_overwrite_word_once(vma_flags_t *flags, unsigned lo
 /* Update the first system word of VMA flags setting bits, non-atomically. */
 static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	*bitmap |= value;
 }
@@ -793,7 +795,7 @@ static inline void vma_flags_set_word(vma_flags_t *flags, unsigned long value)
 /* Update the first system word of VMA flags clearing bits, non-atomically. */
 static inline void vma_flags_clear_word(vma_flags_t *flags, unsigned long value)
 {
-	unsigned long *bitmap = ACCESS_PRIVATE(flags, __vma_flags);
+	unsigned long *bitmap = flags->__vma_flags;
 
 	*bitmap &= ~value;
 }
@@ -803,6 +805,32 @@ static __always_inline void vma_flags_clear_all(vma_flags_t *flags)
 	bitmap_zero(ACCESS_PRIVATE(flags, __vma_flags), NUM_VMA_FLAG_BITS);
 }
 
+/*
+ * Helper function which converts a vma_flags_t value to a legacy vm_flags_t
+ * value. This is only valid if the input flags value can be expressed in a
+ * system word.
+ *
+ * Will be removed once the conversion to VMA flags is complete.
+ */
+static __always_inline vm_flags_t vma_flags_to_legacy(vma_flags_t flags)
+{
+	return (vm_flags_t)flags.__vma_flags[0];
+}
+
+/*
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
 static __always_inline void vma_flags_set_flag(vma_flags_t *flags,
 		vma_flag_t bit)
 {
-- 
2.53.0


