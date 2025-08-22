Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 15291CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:58:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 47D598E0098; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 340B08E0097; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207158E009A; Fri, 22 Aug 2025 05:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E113C8E0097
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:58:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 921CF1406F5
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:36 +0000 (UTC)
X-FDA: 83803943832.12.81AE1CD
Received: from pegase2.c-s.fr (pegase2.c-s.fr [93.17.235.10])
	by imf21.hostedemail.com (Postfix) with ESMTP id 644D31C000F
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:58:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf21.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856714;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GtQ2Q/aaQ74mOKTCLMcZMIova6ijtMTs5ukzxF/EuMA=;
	b=MtkvH/qXdJk0tmL4KXOcYTn8quIWSVDrcViin3aEVy6V9xJ8okHJih+yVBRpvy0NMSWuuh
	z99POIrGSJR/W/ot1KOGkAkMl3RuDtZSyQJmbnG4ITomCuXNzI3yVWU+2X5Kyya+PKQO0E
	iixpdj75rTU5OksDc/epDmdyIW8sWqM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856714; a=rsa-sha256;
	cv=none;
	b=d0+DxP/u/k+jXQbMBFsobaWiUuvw7Fk7kFkOxME6RZJ80in6MEeLfttGYfelY9vfo1RMEB
	/t7ZqJD809/9UqDTr7Ax2iR1+jNNAoAmRR848r1REbTc4c1k/dtngnawSvZsecA1HeScGz
	cowwloiZby72hfzT5CvCuus4NXIe+0A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=csgroup.eu;
	spf=pass (imf21.hostedemail.com: domain of christophe.leroy@csgroup.eu designates 93.17.235.10 as permitted sender) smtp.mailfrom=christophe.leroy@csgroup.eu
Received: from localhost (mailhub4.si.c-s.fr [172.26.127.67])
	by localhost (Postfix) with ESMTP id 4c7bGr0ZKTz9sSY;
	Fri, 22 Aug 2025 11:58:12 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from pegase2.c-s.fr ([172.26.127.65])
	by localhost (pegase2.c-s.fr [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id O2kEh4GEi-xJ; Fri, 22 Aug 2025 11:58:11 +0200 (CEST)
Received: from messagerie.si.c-s.fr (messagerie.si.c-s.fr [192.168.25.192])
	by pegase2.c-s.fr (Postfix) with ESMTP id 4c7bGq6d9sz9sSX;
	Fri, 22 Aug 2025 11:58:11 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id C7E138B775;
	Fri, 22 Aug 2025 11:58:11 +0200 (CEST)
X-Virus-Scanned: amavisd-new at c-s.fr
Received: from messagerie.si.c-s.fr ([127.0.0.1])
	by localhost (messagerie.si.c-s.fr [127.0.0.1]) (amavisd-new, port 10023)
	with ESMTP id kyxvRiMS9UjN; Fri, 22 Aug 2025 11:58:11 +0200 (CEST)
Received: from PO20335.idsi0.si.c-s.fr (unknown [192.168.235.99])
	by messagerie.si.c-s.fr (Postfix) with ESMTP id 771E88B780;
	Fri, 22 Aug 2025 11:58:10 +0200 (CEST)
From: Christophe Leroy <christophe.leroy@csgroup.eu>
To: Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Darren Hart <dvhart@infradead.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	"Andre Almeida" <andrealmeid@igalia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Daniel Borkmann <daniel@iogearbox.net>
Cc: Christophe Leroy <christophe.leroy@csgroup.eu>,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org
Subject: [PATCH v2 05/10] powerpc/uaccess: Remove unused size and from parameters from allow_access_user()
Date: Fri, 22 Aug 2025 11:58:01 +0200
Message-ID: <987c04688a537710c212fb35f2676311da94c1b2.1755854833.git.christophe.leroy@csgroup.eu>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1755854833.git.christophe.leroy@csgroup.eu>
References: <cover.1755854833.git.christophe.leroy@csgroup.eu>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1755856679; l=5354; i=christophe.leroy@csgroup.eu; s=20211009; h=from:subject:message-id; bh=pN4mv5SfPTESXIT1PtFDsmVlUJhI6vGXL0aiUyNtU/g=; b=Bu4ikyLq1pN/L5W86rytn1JbsXSSu+bIHrWJqiGv9PK5Fq01x2XJ3sPr+KkWnmzmy52dACItS CmDpj3q3eZeCPHC21wM4V6/xEYsKrnmPpK5zktbf8Gm3JFSTp1DQzhm
X-Developer-Key: i=christophe.leroy@csgroup.eu; a=ed25519; pk=HIzTzUj91asvincQGOFx6+ZF5AoUuP9GdOtQChs7Mm0=
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 644D31C000F
X-Stat-Signature: x5k5sq69tm5ntqtt4a6acbqu9uxgwpa1
X-HE-Tag: 1755856714-584621
X-HE-Meta: U2FsdGVkX18oiVPWGGAVz4jw/UBE/nzUH+Fj+PEpo4YQbxGguoHMt1Al1paixkXY2n6Q+ISn6ATG6/R1FpblSiNAvGyyL9UOp03UzJRi+rnQtAZF8WlxKiD0502HdnFcM+62aF2vwWapIlSenmrZVtKm8UZ5gt2ruYiO4lhYbyxMyGYw81n4HCGIplnX9g1RROAta65AcvQFM0lO62ZKMwSHPUBWHNowjDGEvCan+/haPpON4KGuCQWbBqxEQTtmWQ5tI3rN4EIULIGd854WW3J+1pIV1g8xjK3ZqcWVzsdAwZmHRdj9wwACzAxV1plzigseTxxulaEPht7QX4HCRdJ+KEcTfqgoqa+BYErYqTIG6ouZRW7T4NtZqBVnUaQXmlOqe3a7Du2xT+H5UGIVEfP66ZAhM6mFqrgKqkrq9Zje0D64uYFQO1Q8uu+4kjAWHYqVEkAdEyytvUKUFZ+pAcUjLs11h+lTyxIpl+u7i+T3vsDSZxG5zlDD1kjh4T2gqL/KucVYAncnpozKOUa4x4VOkrm01gENMRpyQ8hC1v1vJEYfYPBurQwfsc9XVNtdrL+Dpbg6SrpObKtthxU1r6cZ0XxsITMFLqEFe9us7HXWxribArSPad9wWkAMGx3MTnBmmsyeajkErxbTHiz4T1gumI9qgxGNTEkeJCO9P8egrtdAGEMuIkW8XJWRe3gom6QgrpilVuBzpQokCCPTiqYMd8nMisz3UdD5KF+ghXXO4P3jaSwDjhsuzZYFm3FA1nhvHb5dSCgMkpUAsNmVfPKQrTKQoHsjsdOSADxiZMAhHsUdGYzi6qmR8b+XL9C/VnpzZRiQqQS8Ae/ezGiP33veVLb+xaIfewoRSvRMrhPBt+BRxJJB+WpKWW4IaeZkeHxmxPDdi+VGcDoRYJRZu1hfCj+cWkjCWEk1BdDIsK7XIUKXvecxKULeM9X80kBNMCJXjchSLVA2H94R5Ws
 KHmf/7m3
 hAYRBm2q6VxoZU01bu7d9A5fGLPBn6cMJCXZEYYM9wdY43zHNV+6IPr4ikPImH7gKv/Fxmnrr9wYPUwV/Yi6ge96jwV1wQwvMWZikgY6CIKFGLqIC9GAysJlLq+nOnQF9o3sCafJVNomhqppwfCMqBdtbTKdkXys6/2n327CQNpBUC5xWqc+f7JqF8s+B7U6W3WggMCiEIELBl9QHcjA/aEjvdVBjPtYonHgbTuh0eOSXTHRtT9sYH/DFvn5rdh+jZxvr
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since commit 16132529cee5 ("powerpc/32s: Rework Kernel Userspace
Access Protection") the size parameter is unused on all platforms.

And the 'from' parameter has never been used.

Remove them.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
---
v2: Also remove 'from' param.
---
 arch/powerpc/include/asm/book3s/32/kup.h     | 3 +--
 arch/powerpc/include/asm/book3s/64/kup.h     | 6 ++----
 arch/powerpc/include/asm/kup.h               | 9 ++++-----
 arch/powerpc/include/asm/nohash/32/kup-8xx.h | 3 +--
 arch/powerpc/include/asm/nohash/kup-booke.h  | 3 +--
 5 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/kup.h b/arch/powerpc/include/asm/book3s/32/kup.h
index 4e14a5427a63..6718b7e40eef 100644
--- a/arch/powerpc/include/asm/book3s/32/kup.h
+++ b/arch/powerpc/include/asm/book3s/32/kup.h
@@ -97,8 +97,7 @@ static __always_inline unsigned long __kuap_get_and_assert_locked(void)
 }
 #define __kuap_get_and_assert_locked __kuap_get_and_assert_locked
 
-static __always_inline void allow_user_access(void __user *to, const void __user *from,
-					      u32 size, unsigned long dir)
+static __always_inline void allow_user_access(void __user *to, unsigned long dir)
 {
 	BUILD_BUG_ON(!__builtin_constant_p(dir));
 
diff --git a/arch/powerpc/include/asm/book3s/64/kup.h b/arch/powerpc/include/asm/book3s/64/kup.h
index 497a7bd31ecc..3b8706007fa1 100644
--- a/arch/powerpc/include/asm/book3s/64/kup.h
+++ b/arch/powerpc/include/asm/book3s/64/kup.h
@@ -353,8 +353,7 @@ __bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
 	return (regs->amr & AMR_KUAP_BLOCK_READ) == AMR_KUAP_BLOCK_READ;
 }
 
-static __always_inline void allow_user_access(void __user *to, const void __user *from,
-					      unsigned long size, unsigned long dir)
+static __always_inline void allow_user_access(void __user *to, unsigned long dir)
 {
 	unsigned long thread_amr = 0;
 
@@ -383,8 +382,7 @@ static __always_inline unsigned long get_kuap(void)
 
 static __always_inline void set_kuap(unsigned long value) { }
 
-static __always_inline void allow_user_access(void __user *to, const void __user *from,
-					      unsigned long size, unsigned long dir)
+static __always_inline void allow_user_access(void __user *to, unsigned long dir)
 { }
 
 #endif /* !CONFIG_PPC_KUAP */
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 6737416dde9f..da5f5b47cca0 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -72,8 +72,7 @@ static __always_inline void __kuap_kernel_restore(struct pt_regs *regs, unsigned
  * platforms.
  */
 #ifndef CONFIG_PPC_BOOK3S_64
-static __always_inline void allow_user_access(void __user *to, const void __user *from,
-					      unsigned long size, unsigned long dir) { }
+static __always_inline void allow_user_access(void __user *to, unsigned long dir) { }
 static __always_inline void prevent_user_access(unsigned long dir) { }
 static __always_inline unsigned long prevent_user_access_return(void) { return 0UL; }
 static __always_inline void restore_user_access(unsigned long flags) { }
@@ -134,18 +133,18 @@ static __always_inline void kuap_assert_locked(void)
 
 static __always_inline void allow_read_from_user(const void __user *from, unsigned long size)
 {
-	allow_user_access(NULL, from, size, KUAP_READ);
+	allow_user_access(NULL, KUAP_READ);
 }
 
 static __always_inline void allow_write_to_user(void __user *to, unsigned long size)
 {
-	allow_user_access(to, NULL, size, KUAP_WRITE);
+	allow_user_access(to, KUAP_WRITE);
 }
 
 static __always_inline void allow_read_write_user(void __user *to, const void __user *from,
 						  unsigned long size)
 {
-	allow_user_access(to, from, size, KUAP_READ_WRITE);
+	allow_user_access(to, KUAP_READ_WRITE);
 }
 
 static __always_inline void prevent_read_from_user(const void __user *from, unsigned long size)
diff --git a/arch/powerpc/include/asm/nohash/32/kup-8xx.h b/arch/powerpc/include/asm/nohash/32/kup-8xx.h
index 46bc5925e5fd..86621fee746d 100644
--- a/arch/powerpc/include/asm/nohash/32/kup-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/kup-8xx.h
@@ -49,8 +49,7 @@ static __always_inline void uaccess_end_8xx(void)
 	    "i"(SPRN_MD_AP), "r"(MD_APG_KUAP), "i"(MMU_FTR_KUAP) : "memory");
 }
 
-static __always_inline void allow_user_access(void __user *to, const void __user *from,
-					      unsigned long size, unsigned long dir)
+static __always_inline void allow_user_access(void __user *to, unsigned long dir)
 {
 	uaccess_begin_8xx(MD_APG_INIT);
 }
diff --git a/arch/powerpc/include/asm/nohash/kup-booke.h b/arch/powerpc/include/asm/nohash/kup-booke.h
index 0c7c3258134c..a8fab0349704 100644
--- a/arch/powerpc/include/asm/nohash/kup-booke.h
+++ b/arch/powerpc/include/asm/nohash/kup-booke.h
@@ -73,8 +73,7 @@ static __always_inline void uaccess_end_booke(void)
 	    "i"(SPRN_PID), "r"(0), "i"(MMU_FTR_KUAP) : "memory");
 }
 
-static __always_inline void allow_user_access(void __user *to, const void __user *from,
-					      unsigned long size, unsigned long dir)
+static __always_inline void allow_user_access(void __user *to, unsigned long dir)
 {
 	uaccess_begin_booke(current->thread.pid);
 }
-- 
2.49.0


