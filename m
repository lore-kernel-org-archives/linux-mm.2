Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73DC3E9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 06:35:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D756B0088; Thu, 19 Feb 2026 01:35:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3FB766B0089; Thu, 19 Feb 2026 01:35:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF916B008A; Thu, 19 Feb 2026 01:35:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 178B06B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:35:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9090C14044B
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:35:22 +0000 (UTC)
X-FDA: 84460244484.10.9AA3E42
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	by imf19.hostedemail.com (Postfix) with ESMTP id 224B21A000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:35:18 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qWXPew85;
	spf=pass (imf19.hostedemail.com: domain of sgsu.park@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=sgsu.park@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771482920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=aloF7MkDLud0BSRnjOsxj2IOpjpppNDUaB9hMm+IoPs=;
	b=UVdPQEiP3LTBl/bY67blySzpzXRSJGgCuQh3r/4EiHPmqCbT45qKw0yyt6nbf1+chdEVGb
	N+QavX3s7AvvxnfrcfvE0j7cBbMZ4SMVfaQzc8+BfvMeYYgOI1X5DOhpIKulsMgiSUUlon
	OufoSDcCLTUGcBSj6j4GodwFyQdOimA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=samsung.com header.s=mail20170921 header.b=qWXPew85;
	spf=pass (imf19.hostedemail.com: domain of sgsu.park@samsung.com designates 203.254.224.33 as permitted sender) smtp.mailfrom=sgsu.park@samsung.com;
	dmarc=pass (policy=none) header.from=samsung.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771482920; a=rsa-sha256;
	cv=none;
	b=S2BTCAwUro/reQHEUF9QLIDrZtMtmMGMPHe+gPs6O2cbCq2dOuQIWX++9y26QXZtY9N8Pq
	luhSLqcjA7mislZf0w9trjoS+Wj7MDyGLzcEmPu92l6nOYUNhS77gJiDlOJ5d2nfDDoxoo
	Cf9ur7NVvzlroXQzX2vFTPxPm8fapVs=
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260219063515epoutp0390ad0a4462dd412dfa92d2425fef584e~VklNUgPw82730827308epoutp03Z
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 06:35:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260219063515epoutp0390ad0a4462dd412dfa92d2425fef584e~VklNUgPw82730827308epoutp03Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1771482915;
	bh=aloF7MkDLud0BSRnjOsxj2IOpjpppNDUaB9hMm+IoPs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=qWXPew85r6IG5W3gx73mRYzHEDp0D+8g86aZEz2fBRX6ccurudJZ9C5ZRjXr4IkJ5
	 YcVHyb7QyUjFXxk38WM4NxDzenGsJSfFP1TUOWiXbnbDK/5jUZO+4pvME1MBc3zOtx
	 1jyEhPfI1puzw8V9nSXMy8pFYQmNQG5IBUinqtCU=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPS id
	20260219063514epcas1p19a13513456955c828a2a6ebc020ae3e8~VklNByP640223502235epcas1p11;
	Thu, 19 Feb 2026 06:35:14 +0000 (GMT)
Received: from epcas1p3.samsung.com (unknown [182.195.38.190]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4fGkC62Vv0z3hhTN; Thu, 19 Feb
	2026 06:35:14 +0000 (GMT)
Received: from epsmtip2.samsung.com (unknown [182.195.34.31]) by
	epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
	20260219063513epcas1p15c63c2cdc21afdc58de9e5dd5e741833~VklMFQLR90223502235epcas1p1u;
	Thu, 19 Feb 2026 06:35:13 +0000 (GMT)
Received: from U22PB1-0412.tn.corp.samsungelectronics.net (unknown
	[10.91.134.171]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20260219063513epsmtip2e76aff6f7aa8ad043e142729f46cb468~VklMAPEV01618616186epsmtip2K;
	Thu, 19 Feb 2026 06:35:13 +0000 (GMT)
From: Seongsu Park <sgsu.park@samsung.com>
To: catalin.marinas@arm.com, will@kernel.org, maddy@linux.ibm.com,
	mpe@ellerman.id.au, tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	dave.hansen@linux.intel.com, akpm@linux-foundation.org,
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, Seongsu Park
	<sgsu.park@samsung.com>
Subject: [PATCH] mm/pkeys: Remove unused tsk parameter from
 arch_set_user_pkey_access()
Date: Thu, 19 Feb 2026 15:35:06 +0900
Message-Id: <20260219063506.545148-1-sgsu.park@samsung.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20260219063513epcas1p15c63c2cdc21afdc58de9e5dd5e741833
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 101P
cpgsPolicy: CPGSC10-711,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260219063513epcas1p15c63c2cdc21afdc58de9e5dd5e741833
References: <CGME20260219063513epcas1p15c63c2cdc21afdc58de9e5dd5e741833@epcas1p1.samsung.com>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 224B21A000A
X-Stat-Signature: 76du47f9wuqti5zutep698x7q5suqois
X-HE-Tag: 1771482918-714028
X-HE-Meta: U2FsdGVkX1+JtLDAiRKTGHE7Lnof8ZAjptKXO2g31QZKcKzHNpQxA0QMEkj6DzwrlQjF2sMpveRz6uVjvpzmjkazZgB/nv+1c6ec9AzkVtEkHY0DIOxYlI8w6NMIr5dJ56WYc8kAcESHzNhu1MCJmGZgCohPMBJUGDITCbR3r8UNAZrgKGDLbByD0mHUmpv+nysYxwRSstd9bJJTRSncVfWfK482erjkte2RasQ+5c13u1R0qZW5QeR4vcWPiVWduoVaQyiUT3gXAuNnxkWvxKB2u2P1XsMl2YH7HUNUPSTYX1gh4f8426GIEgoqrGX0/wdfdVPQaoxVEssfmFbhplFxsRqhQpGT0k6wAzosmMfMLPdtZOzL/9Gp4PS346AZXW40pr42a1h7b0XlU2oaQdLeaqfyDkrIlEOKVERC1E8sgizkE80bqQplh/k6QeZYPPkqvhE2Y6rG6QXOx3THI/UfXJdsJLvPfHEt8zuyHKMCJWHkq4RzdweH8CyQdf42l4szffSSiBqldXm3U6/fgddZ77/X8H3RVR3FQHy9ZlLY2VOMqD8s82C210ACdexie0pfr+TDPsMfG7wuNqjUB8wS41WOMwgADfPhIKPkVk+9pnRwryjPQuqGNBP6CkoskhOgoyE7JomBi6EJr7xfomaxAUN20JQaC23zR5teXF7oTN/bYFKa4fzVjtOcCv4S/Asir9EOki7vNOMprfDdZZ/F0uEUAsL2d46O7ZeAS9od3gbZ5HWZ8pVCH22DCcrYat9MPC+YFbLuuceGb1AyWpVdmamcKKelz3UH+t0UrmzvPy7Z1Kde3PeEgTsXH/5zEmsXmnSJvflVDFqqE+laC8z7/dp34uGe5GsbDKXkftGs62INpHwsNWNNKD9lEeL+BjtqRaIvYLYPNy5fHkDZEPYZ/IazoYoK1driJghoPo409Mzf8yGBhFNuAreZK16BUgEQi4Pxz6kUvu8BjKO
 HZpZMQTH
 P+AqR8Ym9/0Td8NOfjqFyIonGsoiebt9hoW0tNg56NqpPLaYG4fleYLS/otIx8MA6qlfV4Z73WG9QGiKsvcdT4farT6E5KKg8rsh4tByOdqjKTSH14x+NpV3f7qz6VUBnzZAg6J2iSM2x0fw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The tsk parameter in arch_set_user_pkey_access() is never used
in the function implementations across all architectures (arm64,
powerpc, x86).

Signed-off-by: Seongsu Park <sgsu.park@samsung.com>
---
 arch/arm64/include/asm/pkeys.h   | 3 +--
 arch/arm64/mm/mmu.c              | 2 +-
 arch/powerpc/include/asm/pkeys.h | 8 +++-----
 arch/powerpc/mm/book3s64/pkeys.c | 3 +--
 arch/x86/include/asm/pkeys.h     | 3 +--
 arch/x86/kernel/fpu/xstate.c     | 3 +--
 arch/x86/mm/pkeys.c              | 3 +--
 mm/mprotect.c                    | 2 +-
 8 files changed, 10 insertions(+), 17 deletions(-)

diff --git a/arch/arm64/include/asm/pkeys.h b/arch/arm64/include/asm/pkeys.h
index 0ca5f83ce148..cd286d3a9c94 100644
--- a/arch/arm64/include/asm/pkeys.h
+++ b/arch/arm64/include/asm/pkeys.h
@@ -12,8 +12,7 @@
 
 #define arch_max_pkey() 8
 
-int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-		unsigned long init_val);
+int arch_set_user_pkey_access(int pkey, unsigned long init_val);
 
 static inline bool arch_pkeys_enabled(void)
 {
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 9ae7ce00a7ef..3fc8566708ea 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2207,7 +2207,7 @@ void __cpu_replace_ttbr1(pgd_t *pgdp, bool cnp)
 }
 
 #ifdef CONFIG_ARCH_HAS_PKEYS
-int arch_set_user_pkey_access(struct task_struct *tsk, int pkey, unsigned long init_val)
+int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
 	u64 new_por;
 	u64 old_por;
diff --git a/arch/powerpc/include/asm/pkeys.h b/arch/powerpc/include/asm/pkeys.h
index 28e752138996..bd20d4106471 100644
--- a/arch/powerpc/include/asm/pkeys.h
+++ b/arch/powerpc/include/asm/pkeys.h
@@ -143,10 +143,8 @@ static inline int arch_override_mprotect_pkey(struct vm_area_struct *vma,
 	return __arch_override_mprotect_pkey(vma, prot, pkey);
 }
 
-extern int __arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-				       unsigned long init_val);
-static inline int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-					    unsigned long init_val)
+extern int __arch_set_user_pkey_access(int pkey, unsigned long init_val);
+static inline int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
 	if (!mmu_has_feature(MMU_FTR_PKEY))
 		return -EINVAL;
@@ -160,7 +158,7 @@ static inline int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
 	if (pkey == 0)
 		return init_val ? -EINVAL : 0;
 
-	return __arch_set_user_pkey_access(tsk, pkey, init_val);
+	return __arch_set_user_pkey_access(pkey, init_val);
 }
 
 static inline bool arch_pkeys_enabled(void)
diff --git a/arch/powerpc/mm/book3s64/pkeys.c b/arch/powerpc/mm/book3s64/pkeys.c
index a974baf8f327..2002331b05ba 100644
--- a/arch/powerpc/mm/book3s64/pkeys.c
+++ b/arch/powerpc/mm/book3s64/pkeys.c
@@ -335,8 +335,7 @@ static inline void init_iamr(int pkey, u8 init_bits)
  * Set the access rights in AMR IAMR and UAMOR registers for @pkey to that
  * specified in @init_val.
  */
-int __arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-				unsigned long init_val)
+int __arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
 	u64 new_amr_bits = 0x0ul;
 	u64 new_iamr_bits = 0x0ul;
diff --git a/arch/x86/include/asm/pkeys.h b/arch/x86/include/asm/pkeys.h
index 2e6c04d8a45b..06ed2cd2592e 100644
--- a/arch/x86/include/asm/pkeys.h
+++ b/arch/x86/include/asm/pkeys.h
@@ -9,8 +9,7 @@
  */
 #define arch_max_pkey() (cpu_feature_enabled(X86_FEATURE_OSPKE) ? 16 : 1)
 
-extern int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-		unsigned long init_val);
+extern int arch_set_user_pkey_access(int pkey, unsigned long init_val);
 
 static inline bool arch_pkeys_enabled(void)
 {
diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 48113c5193aa..0caf91a7e062 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -1080,8 +1080,7 @@ void __user *get_xsave_addr_user(struct xregs_state __user *xsave, int xfeature_
  * This will go out and modify PKRU register to set the access
  * rights for @pkey to @init_val.
  */
-int arch_set_user_pkey_access(struct task_struct *tsk, int pkey,
-			      unsigned long init_val)
+int arch_set_user_pkey_access(int pkey, unsigned long init_val)
 {
 	u32 old_pkru, new_pkru_bits = 0;
 	int pkey_shift;
diff --git a/arch/x86/mm/pkeys.c b/arch/x86/mm/pkeys.c
index 7418c367e328..1dfcfaf77e23 100644
--- a/arch/x86/mm/pkeys.c
+++ b/arch/x86/mm/pkeys.c
@@ -42,8 +42,7 @@ int __execute_only_pkey(struct mm_struct *mm)
 	 * Set up PKRU so that it denies access for everything
 	 * other than execution.
 	 */
-	ret = arch_set_user_pkey_access(current, execute_only_pkey,
-			PKEY_DISABLE_ACCESS);
+	ret = arch_set_user_pkey_access(execute_only_pkey, PKEY_DISABLE_ACCESS);
 	/*
 	 * If the PKRU-set operation failed somehow, just return
 	 * 0 and effectively disable execute-only support.
diff --git a/mm/mprotect.c b/mm/mprotect.c
index 283889e4f1ce..fea7d56f55e3 100644
--- a/mm/mprotect.c
+++ b/mm/mprotect.c
@@ -978,7 +978,7 @@ SYSCALL_DEFINE2(pkey_alloc, unsigned long, flags, unsigned long, init_val)
 	if (pkey == -1)
 		goto out;
 
-	ret = arch_set_user_pkey_access(current, pkey, init_val);
+	ret = arch_set_user_pkey_access(pkey, init_val);
 	if (ret) {
 		mm_pkey_free(current->mm, pkey);
 		goto out;
-- 
2.34.1


