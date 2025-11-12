Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 085CBCD37BB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:23:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE0988E000D; Wed, 12 Nov 2025 15:23:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB6348E0002; Wed, 12 Nov 2025 15:23:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6D88E000D; Wed, 12 Nov 2025 15:23:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BA0458E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:23:42 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6CBF5BA7E0
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:42 +0000 (UTC)
X-FDA: 84103080684.30.CA73AC4
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf28.hostedemail.com (Postfix) with ESMTP id C0685C000A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:40 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=hjYlM03X;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979020; a=rsa-sha256;
	cv=none;
	b=VdKSd+pRyMw74U19nssQJXmTZzeo9wIa4vLI3ZxWlEi2nniIO+D2sYWKvHTUBS9K6Pa9Ij
	iOSGUBkAK9QSTgVf7mU97BOhPlu62GxEuI+QEjL4sAm/K4ynorGCKrRjvS6iRWuJF+1u1B
	RrAUK7jssYAVqjOmu/F3Ao3ykrjcK9I=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=hjYlM03X;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf28.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ImePh3VNFlRKFA3aVONVbSvh+rUXxcMoLlx75oRDw3U=;
	b=173lsyGy1dD41v0cw5+TL8YRLcZGkGpWUIHwMOuW4mKYlggH0G3+RED/05Dbl0ahQIQPw8
	uMK+uD7aJLclLDnNTuN4icGnQJbafcRMEmujboC326tqGoAcAD0EOarAiBkNXUWcAMLGwb
	3SkMWi6JYu9xkRpgo0XQka7iJ/KlwqQ=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2M1978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:09 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2M1978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978991;
	bh=ImePh3VNFlRKFA3aVONVbSvh+rUXxcMoLlx75oRDw3U=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=hjYlM03XBIIjaEGfWSA0UmQWuITCtXA2+ecAASu5QDLww+uOrYBRrqaCL/sZgjUZ8
	 dl9jtYdo3A0olwtEyvj4z+HVNyCmpc0Z8G3ePUVA66mq/jVxHVzvr5xdo/pxJVoPRp
	 h3zvhxhB/3xLVJr41WeceZvzQOepAvyWmCoBaklCVncJSWRt1mUvVl87iwdXGwqCYT
	 y26CPA1xhhWISUxqzgYYfx24L3Tzq0UuChIOgLzijj6NV4kGKGriqHOO8rpKH2VMZQ
	 n8wIuf4bWdhoIdXfpbKsW3GKG+399DUT6PsXmszOJymnSrR7G9CI//3ZRjstQPqU8c
	 tZUJLbJNelHpA==
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
Subject: [PATCH v3 3/9] x86/entry/vdso32: don't rely on int80_landing_pad for adjusting ip
Date: Wed, 12 Nov 2025 12:22:48 -0800
Message-ID: <20251112202258.1310754-4-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112202258.1310754-1-hpa@zytor.com>
References: <20251112202258.1310754-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C0685C000A
X-Stat-Signature: 13sn4fxeigqawtzskk7jseaiyjzrz5fs
X-HE-Tag: 1762979020-890202
X-HE-Meta: U2FsdGVkX1/pePtuZ3iHXMEmu7+Sda5bA1mSCbKMqqJoCzF+y74DA8ibENRPIXXWnckmdr8a0r91pNgpu5tw65OtVqNpVXbgGvvgEhTsNGr1/z77CjPYwuvjfFbwBgPSzj2QM72EGl0G66Owmo22wbM/f0hdI8Ou1zQJInato+iAmmROlFLRH6QzHwp9nBXnx/4HayyHXfFnqE5rHmuqkQPszqOBLIubHAvksTmjdPaAVtzAHy25PwXWyQka8RcyJSutJka0u90gzS7wnGAu09frxhyRZYSqF65kyJ5W3XpwttgE8aU/jo39lMnCJbkPcuxDXTizviplv/A/EUGcy3Xayc9MkKpJEj/X9lc3LS8p8+egUFxkU8Woa/8vs8LAa33ACp2aAIhFk9naspX9jqVHkJ+r4ALCK7KYFEKfOWR3WtUYSuMLnisidIBTFyYg7FZH9HdNPS2LJPupCV96IJ/T79CZOuwajAZ21JyO8atouuhF51f22Lra/S9VLyk/9tF331SRB/8+a3hC2IeSXefCQ176nAFPCh1Muvrc5YXg9g59ebpiVqp/EhiZnNG77MGOIyIEGyta5Ex2zP3LMPU1IEHT4n8ZAr0Lwdi6AmxLLg3D/wY0TAlVojwfmpqy0QozNmWsqfbldOmfCih+Vz1/AkcKxCSILRiYpI0zsUbHmJRv6Tesmqxmm0J9f4zaCoWNNOQ5mjan0kITzvpHsFn4ZQbi0IxtvpMKGxmTBSPp1RSfy8PyUDpTLbycMpmVxb3l3lalBFaCDd4Cc1zhocMmsf5vhfpUMhdYm8Hnvz3P3Ows5lxpp0USRyLmaXi4+uh7QI5v84pLUGLf0pgTRAvWXaGXSGhSRQfvMZDXdXa8bRPMyLUDXUQI/l/KCjWXwQhcoRHufPFKjhEFn59Eoud8nljKnb3a3U+gz61vApSU1GG6LkmfHHOMJ+bbWE/lk5KZCDA3saMP/PCOG8A
 MBJy794P
 sh/wfSzFMqp7yvbsn4/l5ti/bnHH8g8pCfF8sYnUfpf9hPXCjeERbCp2aQ73iNCJqWes+VTnYzh3m0weN1yUPV+IFop7FJWVGsJoiAMzTF/teFopl8fxC04Cr/XDbtPWphQnpSvO40Pr0+PIpqeDRGke+/GzwNgG1wW5P6RuxmSf7720vAuoROPz8/QjiV1GH1+CymIRa37ZBxN2D2GHVcAGU+4K9npS1DWTB/QAWVFa5R1ERIkIGc8bpMc5nHIJ+BH5HRQLKZ19WOfFDEV6SsYflTZv5B8QNVzWUpOvntYPDnm5+0DNgq35nnBzzLlmCU6AJK1PFJF/ezvudSxzUBQmhew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

There is no fundamental reason to use the int80_landing_pad symbol to
adjust ip when moving the vdso. If ip falls within the vdso, and the
vdso is moved, we should change the ip accordingly, regardless of mode
or location within the vdso. This *currently* can only happen on 32
bits, but there isn't any reason not to do so generically.

Note that if this is ever possible from a vdso-internal call, then the
user space stack will also needed to be adjusted (as well as the
shadow stack, if enabled.) Fortunately this is not currently the case.

At the moment, we don't even consider other threads when moving the
vdso. The assumption is that it is only used by process freeze/thaw
for migration, where this is not an issue.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vma.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

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
-- 
2.51.1


