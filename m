Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D638D637AE
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563D06B0096; Tue, 16 Dec 2025 16:26:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 49C296B0099; Tue, 16 Dec 2025 16:26:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 183836B0096; Tue, 16 Dec 2025 16:26:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E12EA6B009B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:58 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B56CB8B4D0
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:58 +0000 (UTC)
X-FDA: 84226619316.01.D4C726F
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0E7B58000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:56 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=K8WR0xCy;
	spf=pass (imf02.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920417; a=rsa-sha256;
	cv=none;
	b=sO2eztWboe0zEkvjsN5acUs7KqooltstgDTCN2P4hg5it2xBjdvssqvyQAJl8adYKeEBfS
	Va7dkBsgZMR30VUBgl5844+v1n1NuSKHsKTh96Gz64SK5rrOsQ7oFO0mHobZzTbvzURtmM
	vDgtbES+QKZaQjbzJH3GUH/gR1T+bDU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=K8WR0xCy;
	spf=pass (imf02.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920417;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fg+x4l4yBVX9RQI2ybe3EpOM6reoeao/7cwqkI1TOyQ=;
	b=Q4/IEhLTJJT8kTv+UFxWbYWxSdRWPq+ggZfOupsma6GwYJqELDBvmenTI2W8Zj6JDQ5AWq
	5xqUJs2pjAKICqSEhHjSfAtaiQJ7kZ93VHDw+1lwKIjlLzHp/DXczTMQxh09EF+UOOu0pS
	G1F82bwKqhHg1loiXsiubX5qsxn8Grw=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC292563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:32 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC292563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920393;
	bh=fg+x4l4yBVX9RQI2ybe3EpOM6reoeao/7cwqkI1TOyQ=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=K8WR0xCyMau+WQ6iLmi1GqIknwCQ3rJDQ1NBQ1pylo0Vo9Grp4bV7c6kR+/d9fEU9
	 9CkNuNdA5rJuHmVT0uLlYGyt52MHmGMWi01PultxzdvLGYHs2w7r87OBUkBrtUE0F0
	 Szl34LVPb+wJbKNwo/bDqwT3i3i/tEUS87g5tIuXYFy7Ai5ObooY412PnYdLEu0/sy
	 J8/80FGgsv+xe3wRVws4xdg6j1tivh48OqyL6RBpVtFUjjpt2XNT+8wDCfWWgNO0Bd
	 +RQA1WlUPULSR+UL/y6MAeOV6lCAIRUBbog8HMg7tSWXsysHE0wY3CrpvHmkd8tw9i
	 blvkPnFT2LtiQ==
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
Subject: [PATCH v4 10/10] x86/entry/vdso32: when using int $0x80, use it directly
Date: Tue, 16 Dec 2025 13:26:04 -0800
Message-ID: <20251216212606.1325678-11-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: <20251216212606.1325678-1-hpa@zytor.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 0E7B58000E
X-Rspamd-Server: rspam04
X-Stat-Signature: uudz4kwt3i5kh646tdn9gjzuwnpztzb5
X-HE-Tag: 1765920416-821755
X-HE-Meta: U2FsdGVkX18I0zIdKGe4L72f14ftOfXOcqMAoNC9jX9PRlM9MjYn/cI2CvfDjv1EDOSQjSs6FWnnkYOlQk+MNCuo3yAISo30tXWvT4f0JAEtRr/1i4XtZMLYlqq6JzBM7m0Fs1IRtgH4VEpWREtn8LA51wjLzUAJCprfTkBrYboUhetV/XWGzgvoKYjpwDtVGhXIUwmtegkOx3p6Mc3Axq78PfyKKtxvQOzMIvYqMGgcuMlNGUZmc0Mm07W7AG6fw8bZ6eX4xbdMYlNZ6CqFYOxuWIqjziePssCw1dcVFobefNILBZU83BPwpOjw5OGiJ0uxJ8RudgybaJiCwl1yEHcAy/eZ4DZM2MmJONAwnszarLGz1+/wxWTkx0Imo0F1aEhQgfb7FrUFpEDFVB5E8l1G9J7PZBXiXN6FkU+OMXDHAOGmX4l4yszySiGnR7b/FTALMd8Pc4nhJ9UuECXXCeE7clssvbfv0i9Fkeg6BDE+5Yf2VVRr/654t3KgrY36usvv2kEs+EYbDnfsMk/b5WGA3P90LGD6ovXCs7kyX0AIrQUa6D2rxW/SP9Md/IbfnpP4lr25wkDqwXt9QaxXG4qzeA/DSCmmsj7SdniXvgtKoPCokWL+hS44GgAl/C8ksqm/3sKGJblHC0xehTUE61QD99/ykUphiyaxJgViGqytp0I8chsVYkrLJn0lOzYhzriBPijkoW7j6VERGN8bc2jG25PN8o7otzqAhiTeH4UuzPY7Oeg2uaVJAfi/DVnScfbtMDHzYlK89Io8j+3LuIa1BBrfabeyTUE2lWM4M12Xy7o4fc5xC6usQNeiKB85nn1RbeZjweGQTUXBcjAM4tXDq2gimmj0gqF/dyJrESy1M81/mvUtmxRViz8gVJzcF5O16lkLCZSe9/dYFfM+8U71XXoZ4cnDF85luTih9ZOETXJEUBMUcJpqpXUCdFd3qD5kz3mtdWYF7GmKHEl
 jC8Gf5t6
 gf4TKov5SXpVDJMyMccoWiIxZfCZgtEVKyrJlSe7JOt8KSnthYIg/s/jAzkfdq8HudH3B1EfmFlxoCJ/UhZthNlEoz/VumfuHskLMw2tWYDU5chQ93K8JgDL3c2aXdJMpjEbOnvxqovbFfU+VJyYdyIcrHzdMWY/5NEEucJ38K+kEPCFDK4rkklOixy7B05pLdvStSnFxpNCzveCH9Tp+9ztLqDIwyxkqpfzfQTUoA02vUjfEgi4tP5UJ2SNd4p+gvdno3sGx09i0nYauozRoaDOcGlfxgnAZkgK2RPrkGeUbOXlfxeo7NcpHqBeHMh3njLxGQmgq53qJHdKC9gdS5cSi9w==
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
2.52.0


