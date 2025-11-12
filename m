Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B06E2CD37BB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5CBEC8E0013; Wed, 12 Nov 2025 15:23:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 557878E0011; Wed, 12 Nov 2025 15:23:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A9328E0013; Wed, 12 Nov 2025 15:23:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 23B938E0011
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:23:48 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E94CB4BE86
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:47 +0000 (UTC)
X-FDA: 84103080894.03.2073FA7
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1FBA18000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=cqeb3vVu;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf30.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JO4NTIUlmNaAY7yiYGnbE1tZshxRZRjWcGcuMEnO2Hs=;
	b=WZNDMhmsq35Fjsw/nNS9h68/+zPPxZp8669zQeq4yQcmcgG/UZ6IIIzhifyOoTxYNJzWkI
	hmuVRs94li8Rea+n45Oe61K1+LMppeYCpwtTcDSjR12GnpLXl8mNeII1rVAZF+bmgwgQEt
	czGv0CN02YNSAbCpeKDR6jeLAoHOxYk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979026; a=rsa-sha256;
	cv=none;
	b=5uIHJMQ6lTIGBmoMqz7Vs7wR7Z8xgVNPxzsiuUVTBbFXyQVLhTGBRl0t1gsNJ7h1bKy4IX
	juhMbVj4rDJ/wXAp6tCuC5z5aufxgS8wKhb/nvbuij9/Jlj9XoShniM+Tlzd8XBiRQD2u8
	E4umpC5teMZDElVinPkGd3uOdN9zRRA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=cqeb3vVu;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf30.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2M7978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:20 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2M7978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762979001;
	bh=JO4NTIUlmNaAY7yiYGnbE1tZshxRZRjWcGcuMEnO2Hs=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=cqeb3vVuc6fpkuuhA9ngqVxP73miAJEYWN74jSKBFZQRgHXgXrOPuJVnnZl/Pw35U
	 7L9p9q+a6zNLXHcwMYQkjtVQZn6mSxvz9tmwlCaj/tchRBNj259xDVgJae1wMSyPs2
	 oP8Pnve6U+tE0qmrBwNLaPeJL8MdmE21Isedup/8xOgJdotQkNh0w/r6hSMg7wVw2X
	 7LpGxwR0FCOhUi4DpObBQQiHVRDTYmgmeeOEoUl8rucFFFXEDVgTKXV/YMIBCA4OTb
	 jhsqjbyx2EGfWymE/EyeDOVkGCJBkLsBd7cxwxY6UR4HcVVVf/RP14ObZ5fJ8xBU4u
	 IaLK1xmj7pKjQ==
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
Subject: [PATCH v3 9/9] x86/entry/vdso32: when using int $0x80, use it directly
Date: Wed, 12 Nov 2025 12:22:54 -0800
Message-ID: <20251112202258.1310754-10-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112202258.1310754-1-hpa@zytor.com>
References: <20251112202258.1310754-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5uq141ypjaxcnten6uyq4ot9tug9g5jy
X-Rspam-User: 
X-Rspamd-Queue-Id: 1FBA18000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1762979025-797428
X-HE-Meta: U2FsdGVkX1/ltynzuFrBOXNDj+8sEUBahAqMlgjkkx7wbTMhs1B/4+l4b1aOzWkve0FtzX4DNR3C0apXj9QHlfpo37M/LxfUEIfvuTvnfpveXjgCwvmbNpxy+sYM2X7NrGSWmnruIaeIjA3y1PDmYRUyXgnWMOCTjds1ThLnn1GedkDv49tSTTiigvIvVnGUsvfoqopnS32okLGUKEEpXoCX/a6GFjpXedyGGWXJ3Epy2cZ/8EOs5GKUSxUzmK9MOozfuaOqod7Ep2DO3UAoeCK8jIcHClLlcZWUpUg80JuMO/jfF9tkopcidvgrrVB4ObBmLhpJmoiO+YRdjTQ+vTfNFcNLYDKvKTPECl7jXot8+2MF2TphngiAWSsR8pcBQR+/cQfAyaMaNZkFBHri2zYmFWhPcZHGxWJ2FEAy4XygqHsSZMqv8BgFdCimNZequ1uyQGBy6KNonULzJY7/0Mr5j/o8juiBzgbcepy+et3eqma7zdJXsOK24OTgBd8MMM3CC2imNCmV7k5fy+1NH0zDoQqondyLPU/z3PYEXSo0P1HVogr8Sc9YaLJVnAnusBXgTFC/bgXtazRRI6FG6jRqt9fdJPu3DG1KHZyJlb3WtSNe28k/O+NX0iwZbz9TDRWNmyJctbr5tvdUekAhPc0S+kH0yyOQa6GtVPvwT6KkrvwJJXXdSmlKXNy17oM0+rxucvT2X6CNG0PMua8ubCzw1K5O0KcJ3lg2TKEyY5ydbnERO8XoEFRMrhA3sVgPyu2Dm2uFI1wJnRfM9KCh+onaQ5DSvi3atwYRR8Ig2cl/2+wAXhLetF6fuFqcwq1yw7s0OqtmTu2tEZhZpTVu45rweukFNYOBVu7NWOTr2J0ZqJ+1QeVmXgraw47JqcRoa4itf/4SZiJhnpTOcSVrq1DeKi3GJUCgBJOk7dYnnf6Z6q0wukzt2DZFMzXfPxB/l6CpSxEMpWtW0Pvxpy2
 MsNjumcY
 K3BMON4S+jGE3YqhNJD+JZWwFaewJKwO6D9vMNYodyAMmqtSVo7EtKwIi6082P50IwTQNDzWwpaErNnP2DcaoPLAdXrDKq0PAuLhrXSWoa0UJumX1ZvPuCf8lP+08uWiwMnXGP7l15WfOArcCmnL0L1ovJMvKmpjz/qoJC5joB7NWBhhRjwWtpIoT0K7ePGtz1wQyIOgSW6WsQTg7rZBCvQsvfGXrpChk1E7pXGMGW3ged+Qx/Ity+ni1MNrk8Mb0FWPdiun1iaIn3vGlHetbhhGRq8Xt6+TcWor31lLxUYY/4kvRQfDdF/7AsfFu4tm+ZjMJk8TPYXpTfck=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When neither sysenter32 nor syscall32 is available (on either
FRED-capable 64-bit hardware or old 32-bit hardware), there is no
reason to do a bunch of stack shuffling in __kernel_vsyscall.
Unfortunately, just overwriting the initial "push" instructions will
mess up the CFI annotations, so suffer the 3-byte NOP if not
applicable.

Similarly, inline the int $0x80 when doing inline system calls in the
vdso instead of calling __kernel_vsyscall.

Signed-off-by: H. Peter Anvin (Intel) <hpa@zytor.com>
---
 arch/x86/entry/vdso/vdso32/system_call.S | 18 ++++++++++++++----
 arch/x86/include/asm/vdso/sys_call.h     |  4 +++-
 2 files changed, 17 insertions(+), 5 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso32/system_call.S b/arch/x86/entry/vdso/vdso32/system_call.S
index 7b1c0f16e511..9157cf9c5749 100644
--- a/arch/x86/entry/vdso/vdso32/system_call.S
+++ b/arch/x86/entry/vdso/vdso32/system_call.S
@@ -14,6 +14,18 @@
 	ALIGN
 __kernel_vsyscall:
 	CFI_STARTPROC
+
+	/*
+	 * If using int $0x80, there is no reason to muck about with the
+	 * stack here. Unfortunately just overwriting the push instructions
+	 * would mess up the CFI annotations, but it is only a 3-byte
+	 * NOP in that case. This could be avoided by patching the
+	 * vdso symbol table (not the code) and entry point, but that
+	 * would a fair bit of tooling work or by simply compiling
+	 * two different vDSO images, but that doesn't seem worth it.
+	 */
+	ALTERNATIVE "int $0x80; ret", "", X86_FEATURE_SYSFAST32
+
 	/*
 	 * Reshuffle regs so that all of any of the entry instructions
 	 * will preserve enough state.
@@ -52,11 +64,9 @@ __kernel_vsyscall:
 	#define SYSENTER_SEQUENCE	"movl %esp, %ebp; sysenter"
 	#define SYSCALL_SEQUENCE	"movl %ecx, %ebp; syscall"
 
-	/* If SYSENTER (Intel) or SYSCALL32 (AMD) is available, use it. */
-	ALTERNATIVE_2 "", SYSENTER_SEQUENCE, X86_FEATURE_SYSFAST32, \
-			  SYSCALL_SEQUENCE,  X86_FEATURE_SYSCALL32
+	ALTERNATIVE SYSENTER_SEQUENCE, SYSCALL_SEQUENCE, X86_FEATURE_SYSCALL32
 
-	/* Enter using int $0x80 */
+	/* Re-enter using int $0x80 */
 	int	$0x80
 SYM_INNER_LABEL(int80_landing_pad, SYM_L_GLOBAL)
 
diff --git a/arch/x86/include/asm/vdso/sys_call.h b/arch/x86/include/asm/vdso/sys_call.h
index dcfd17c6dd57..5806b1cd6aef 100644
--- a/arch/x86/include/asm/vdso/sys_call.h
+++ b/arch/x86/include/asm/vdso/sys_call.h
@@ -20,7 +20,9 @@
 # define __sys_reg4	"r10"
 # define __sys_reg5	"r8"
 #else
-# define __sys_instr	"call __kernel_vsyscall"
+# define __sys_instr	ALTERNATIVE("ds;ds;ds;int $0x80",		\
+				    "call __kernel_vsyscall",		\
+				    X86_FEATURE_SYSFAST32)
 # define __sys_clobber	"memory"
 # define __sys_nr(x,y)	__NR_ ## x ## y
 # define __sys_reg1	"ebx"
-- 
2.51.1


