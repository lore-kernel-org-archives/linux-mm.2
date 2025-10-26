Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6FD2CCF9E9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 22:13:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 715978E018A; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B99A8000B; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D3098E018A; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D46D80009
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:12:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BD74816044A
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:12:56 +0000 (UTC)
X-FDA: 84041666352.06.2DD52CE
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf02.hostedemail.com (Postfix) with ESMTP id 3DF0B80002
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:12:55 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=GDPHiDaQ;
	spf=pass (imf02.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761516775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzsd16Tk4N416+vtdjDD9iGYV6V8cuWWcU6HWANhALM=;
	b=mFzIGhzfRFvPKAbMtQ2F5NTNMvLj9OJObVhFdhMg9XnvlF56xyXADDH5CQa9lArFO6oUT1
	dCsfTkuOu6DywejF7cQCVaRpzM7h5tiOb8aGR7EMO3xRaR0GixL6uHWsLO+sGsE1/IvY7/
	t7Ja94ZecJgOJKyxDdmq5G38zB0s2RM=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=GDPHiDaQ;
	spf=pass (imf02.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761516775; a=rsa-sha256;
	cv=none;
	b=8I4SCBU1RG34RlCUrh+uX+od5Ux01APdcoe8asVXN5hp1XzuPgpmETKsOzFvMkdiFs2fkD
	lMXXdhYcnfIdTOcUXwM37HHFQ//ImEJHHp5ExM0zcZvx4NtBl59NRYg9XK+TUWJIEwrnPe
	ELJ3SDlIF9JRfq02SDiXBWWpsryJnpE=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9484:8257:f1ab:878e:498b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QMCFpN548264
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 15:12:24 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QMCFpN548264
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761516745;
	bh=hzsd16Tk4N416+vtdjDD9iGYV6V8cuWWcU6HWANhALM=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=GDPHiDaQjqh4k3a4U+47ybqkHjhVkac5gEVdIoSd7V/tM7lZ64H7FQ5ZVNWAOh3xY
	 hs3fajKprTuBOxTHlED1aaCVpX/pkUo8K2MOmPwR/EDQCzTMwLE7BJ0qzoyqGT7Vlm
	 2TmEOdmmx7S++t8Ysboe0oZz9tO35+jcZAO4pscigd8SO16eh5vTI1hmLPGG8TZgLr
	 6w6HSdm25WHtfhvam06xgNaulibqzgO1jS2uG7jY3t+57WdrqQoHBQojz/MaS2cqvl
	 t9J8JycyzDr/iIJmvYj247thxg9hOiNM7O9DPjO8HKIIxUTIXMzXbpUDSaCjAvfkCO
	 HRj76AIji1xnA==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH 3/6] x86/entry/vdso32: remove int80_landing_pad
Date: Sun, 26 Oct 2025 15:12:03 -0700
Message-ID: <20251026221208.1938173-4-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251026221208.1938173-1-hpa@zytor.com>
References: <20251026221208.1938173-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 3DF0B80002
X-Stat-Signature: gyxzib9midj585fgj5ebfm7y6iky9uu7
X-Rspam-User: 
X-HE-Tag: 1761516775-624039
X-HE-Meta: U2FsdGVkX1/iNppxaxcenzOiCjJCaQs4RPzhsuC3u7jdIOGnhfB/Smz0gXpGoU0czoq+wRU8O5YHwo1pJDH7pTf2RjhC+2/aFZDL8krON/hiJYHVs1vA58JaOOI4mi/u21ClS0krpHxlQulaQdd3C6Oq+kQMp9lsKOzDEMpFHniVsYCy7k3B6HtjdLztiuZ5q7/uCFN0r2NLybljgjHtZLPIK9k09roe+roIysuesVd2lNkF8LuHXv6Zy82uPiQv9fwno4jnJ85R3hX8jKCAQnCjt3ceWDLFxmPVeQErHeg4F7i6A8t3WN2G58aoeTt4BYlX3yijh9Ddbfe2MlD01EfzMtfZC2kIZ9c5Ti5g3j8sL+mxNWDrxHr14CME7pqGkKAtVvIIlYYiwpZuyAyvde898yNKwNKPagMCn4+S6lDNUARdK9km1RmlHNTGpOEaFSUxZZS3SO/0nQWJk7NPRxkErf3xAibApYWlvrHkyygBy4vpnV9C6ZX4W1ygfOiu6+aGsVh8eSb1Iu8MKl4Fo7DzGW49dGFoKU+oBcCq3jYc5C2say8gmrarbeWT3cqSnUXXryPzq1HiWKl1rA7joJtj557uUeKObk8sIhhGJmaL62jToq5IBtMMjh5rlcYlEtxaeVPBioLtZqfnXxfkfBDIsaFOGppYH15+pT7ejQjPuN+4X/ze9aaNT3OsBvSjHm5DhiOOb+Lg6GlpKCu2dEwDhSH42CllCSaTuUidA5uTf2XniHKrerJYYBYHQWLQ2MzkGjZ0bns3HNwEFcfCsDhrO8G9cM67UqPTruRUS2u6icxPQr/8N1bVLBE4jfZvRyKJ98HNHMGlkUxWN6ydUgt20rWQSh+7iLLa/k+/ZkpBuZqRJO6mBZV4+6PtxdvKPJq6jdqXJYBOUObmj3kK4GFIvyfY1XpFFUmnD9R1QSM2vBTNGE4pc/otpgi0x0OLGdxA6Owl/V/k34tYlq0
 F2x5Bdoo
 Ym67iazHdjqFHym+ppQX/9Atw9tQIMKYaa/re
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no fundamental reason for the int80_landing_pad symbol. If ip
falls within the vdso, and the vdso is moved, we should change the ip
accordingly, regardless of mode or location within the vdso. This
*currently* can only happen on 32 bits, but there isn't any reason not
to do so generically.

Note that if this is ever possible from a vdso-internal call, then the
user space stack will also needed to be adjusted (as well as the
shadow stack, if enabled.) Fortunately this is not currently the case.

At the moment, we don't even consider other threads when moving the
vdso. The assumption is that it is only used by process freeze/thaw
for migration, where this is not an issue.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S |  1 -
 arch/x86/entry/vdso/vma.c                | 16 ++++++----------
 arch/x86/tools/vdso2c.c                  |  1 -
 3 files changed, 6 insertions(+), 12 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 2a15634bbe75..d14eca4403c5 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -62,7 +62,6 @@ __kernel_vsyscall:
 
 	/* Enter using int $0x80 */
 	int	$0x80
-SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
 
 	/*
 	 * Restore EDX and ECX in case they were clobbered.  EBP is not
diff --git a/arch/x86/entry/vdso/vma.c b/arch/x86/entry/vdso/vma.c
index 8f98c2d7c7a9..e7fd7517370f 100644
--- a/arch/x86/entry/vdso/vma.c
+++ b/arch/x86/entry/vdso/vma.c
@@ -65,16 +65,12 @@ static vm_fault_t vdso_fault(const struct vm_special_mapping *sm,
 static void vdso_fix_landing(const struct vdso_image *image,
 		struct vm_area_struct *new_vma)
 {
-	if (in_ia32_syscall() && image == &vdso32_image) {
-		struct pt_regs *regs = current_pt_regs();
-		unsigned long vdso_land = image->sym_int80_landing_pad;
-		unsigned long old_land_addr = vdso_land +
-			(unsigned long)current->mm->context.vdso;
-
-		/* Fixing userspace landing - look at do_fast_syscall_32 */
-		if (regs->ip == old_land_addr)
-			regs->ip = new_vma->vm_start + vdso_land;
-	}
+	struct pt_regs *regs = current_pt_regs();
+	unsigned long ipoffset = regs->ip -
+		(unsigned long)current->mm->context.vdso;
+
+	if (ipoffset < image->size)
+		regs->ip = new_vma->vm_start + ipoffset;
 }
 
 static int vdso_mremap(const struct vm_special_mapping *sm,
diff --git a/arch/x86/tools/vdso2c.c b/arch/x86/tools/vdso2c.c
index f84e8f8fa5fe..c81bb32b1e6c 100644
--- a/arch/x86/tools/vdso2c.c
+++ b/arch/x86/tools/vdso2c.c
@@ -79,7 +79,6 @@ struct vdso_sym required_syms[] = {
 	{"__kernel_vsyscall", true},
 	{"__kernel_sigreturn", true},
 	{"__kernel_rt_sigreturn", true},
-	{"int80_landing_pad", true},
 	{"vdso32_rt_sigreturn_landing_pad", true},
 	{"vdso32_sigreturn_landing_pad", true},
 };
-- 
2.51.1


