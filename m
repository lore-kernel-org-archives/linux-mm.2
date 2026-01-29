Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB5D3D6100A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:28:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6278E6B008A; Thu, 29 Jan 2026 06:28:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BD226B0095; Thu, 29 Jan 2026 06:28:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E15A6B008A; Thu, 29 Jan 2026 06:28:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D77186B0096
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id AB40516095F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:07 +0000 (UTC)
X-FDA: 84384777414.17.9D60EED
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5543618000A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JxTYzD7d;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769686085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u44qKJ7Aaq5lAryo2OrDX5kYjG7xdxcWhEvgrFgy9tU=;
	b=y03n79+s0e3W5W5WlNjaKfgYB1juA8Z2n33bHtw3Wba/FxgK84BdOsBAjyFmFbHjvj1HMH
	eOrTi3Zhn6YfwLwRQRIcWTHiMDgMOxxmLh7e4w+AtIDS1kOzkTdSUlx2QKoKIa7L+jMwii
	2Z98x95aoJbBRQYRj8OE0+1ia3ajcH0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=JxTYzD7d;
	spf=pass (imf06.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769686085; a=rsa-sha256;
	cv=none;
	b=wEGIi9RWyNAN8lDKZN33p4Mjmc60+yn3Q/Xnh/euYEDCFnWeIBV8cT9N6A+WaaqYz/DnTZ
	CUxNoyQbsWTgLcmb02e3OPgyI+UUheljNyaJ6btV8hJEV5JrF2BdFd6xeu4Kbyx5Jj+rbe
	TsHmIp5Sf2x4qPuv/Yrn4A0GkoRx6ZU=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60SLbD3o022764;
	Thu, 29 Jan 2026 11:27:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=u44qKJ7Aaq5lAryo2
	OrDX5kYjG7xdxcWhEvgrFgy9tU=; b=JxTYzD7dUKAgaEBRiT+oX9xSZt3I7p1Dr
	Kv80PXbBDPkGjwAxfecC+OpRhIRw6vlrBkkx3kIMIXgC8AFy9XtgpL2C11lU4TdH
	E3oepCaiP4rPcwHy8kkzaIElteusLHhorDNbSFkq1zASI5hnRR0nUiMY75xOMMYf
	h3lv50heuGoJW76UyQMPeiGM3LH99ITrk9xo7jc9WVACNzb/dGziRdMOLC0RIHX1
	7iYk6sg+ZndRb8TYMuhWma3oPA01OQkLGA81Hr9bCauNFMwLqL4pk13iHd/A5Zm5
	OMT0l2f+CZ5jF0RTRSPxtz5syigTBkHoK7NwmYtnX4DQ/P0IrfSWg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvkgmwvcg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:37 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60TBRaMN025262;
	Thu, 29 Jan 2026 11:27:36 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvkgmwvcd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:36 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60T6hAOs019647;
	Thu, 29 Jan 2026 11:27:35 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bw9dn9ed4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:34 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60TBRUMk56099142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 11:27:30 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6025E20040;
	Thu, 29 Jan 2026 11:27:30 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CA21B2005A;
	Thu, 29 Jan 2026 11:27:29 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 29 Jan 2026 11:27:29 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        bpf@vger.kernel.org, x86@kernel.org, linux-mm@kvack.org,
        Steven Rostedt <rostedt@kernel.org>
Cc: Jens Remus <jremus@linux.ibm.com>, Josh Poimboeuf <jpoimboe@kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrii Nakryiko <andrii@kernel.org>,
        Indu Bhagat <indu.bhagat@oracle.com>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Florian Weimer <fweimer@redhat.com>, Kees Cook <kees@kernel.org>,
        "Carlos O'Donell" <codonell@redhat.com>, Sam James <sam@gentoo.org>,
        Dylan Hatch <dylanbhatch@google.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v6 3/6] x86/asm: Simplify VDSO DWARF generation
Date: Thu, 29 Jan 2026 12:27:23 +0100
Message-ID: <20260129112726.892340-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260129112726.892340-1-jremus@linux.ibm.com>
References: <20260129112726.892340-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=Gr1PO01C c=1 sm=1 tr=0 ts=697b4429 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=i3XSr9hboEKZ3AC0laIA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: Oyg23B0gG2Awa1kopZNzXh7_duCwEBia
X-Proofpoint-ORIG-GUID: OsyQygSCtyWjSS4FapP7rrSktBeCogHT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA3NiBTYWx0ZWRfX218YVoj9uWGR
 UjQKUslWwhOYxZsPo7f0yEuGXAfcPR4F5eSFpzcxvP598njHCIhatVtq1CyrhGwErhqpaoCR0Q8
 CfCe0OXhncuayjginQuMlAx6Ivmdg24owc+0lKtJzKtjzlIR3yKilM8qfImrZyk5Ud/oVYk/osP
 QFXE2VRPBoq6sDj3ySsOlNQcqP+6SiNtkHOfybgVVh+mRjMY0SObjO/I2djjBIyOde88QjUHKgG
 ov8LobE2O8LiL3laYgunU4vnrQdFo/puNgt+mIgHJ2J5n58hI/flnfqs+foCOaahMMUyU9G+dYd
 bt78jsGXvxEHNuTJANaQmDnjHPmy/GGkiJIChopZS1VPPpXb/2BHWYppJ2UpnJeDTN/LSTu5kMm
 nc/vL5XSwWCnFQIcymVBkVc9lBylYiu3UXkjTUycRMcP0PzTgDStuTDDVqeKY4zztgwDawxvpw1
 8NLWKxEQh4niJJi6FPw==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 lowpriorityscore=0 suspectscore=0
 impostorscore=0 phishscore=0 malwarescore=0 adultscore=0 spamscore=0
 bulkscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601290076
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5543618000A
X-Stat-Signature: dir66xjepy95jyrtu3gmd9871bxzfp4m
X-Rspam-User: 
X-HE-Tag: 1769686085-635925
X-HE-Meta: U2FsdGVkX19Xf/Pl3OxUv9m0P7IOK5GFJUB0bEK3ig9/Tb901ynuPcIQpVMYsh27wC692HXxOQ7ai6mJxDdcm8kbKtMlldPS2iTjwofpmkj1fziu9Sg0044WQi6Ls925sQheRiOVwPVXmN50tz1L2YUoHKFSFWRg1B7CW/UE03D7qwt+n1rXDcqkExLSuiZxQsttrpJur/ZJdRn1f5fjDrbVDr59pyw0ugnAXEIi6qjKIqQwaxz0axXdOyaJR4hgLtYclfq43PvvAlYZMQtH7PNlLqHs9eL0IIsEjiiBBv0FV2YjzSMuSxXYLhmFVGDy6zezwzHlehgh9WCvyckWlP/adIY+SNX32NxDwMBsjd87wCC8WwhqOlADMDXLRelJYX8Ogzcj+Bbl4KArepQhvPBIJITVgROaoIFTJ197M7yUMxC8iKWxtK5B8F9SniODRjsUZHtAWj02dKFcXW1a4IbIGKa9IksTut9PXC9H0PB2jc5Jgtc3cYDFVx3BjsnqzEjKI24h+IvfjuFefPqHG3H+0p2mxy5XUSjYSwwFLFgRgluGZkS1Es3AN0To9DSmeob84NVTSibX1VL+ibXrEVnlzuO7BtvPbCnooB7xOZX71hiRTvN2AIhwprPyTvNWM/aCWXG0ViGI3g1l7vFJNzWihNxfI21OpBG/sRJDsT1T8SwxVp5Oud5imBvUehnKQWXqi0w2FrHDAciw9E8CETH62+gEIJE3fYGb6QfLyHt1bVgDra9kVWQC4UxdVFQNL+dhwEhR10OoSDtMShl/r4g5koXxndZ8uIQZsEme55iL0Vp4jNwSeYC0iLSjXwY/lT2Dhyny0C5aXMHzzs9POpV2luHhZ/cjm2yKEcDpj5KsKHytzZJ39Cla2yhYdsHFAFMcaFWg2av/FBNmZ1/VsaLYI2q8H/mAgPk9Gi2UVkg0vAqGuby6OgE6Vf5JUXa7AP8vw2TjDJUXauqTCsq
 ilIiLVR/
 8MGgycKmNoqrqPbk2d0GVdqVRP8Z7UzGkcHOM6++Ai9tbIX1b3U/VZU1hU0o2RvaY1z1B+b2NNp7e1Fvd0naCYsjY1NNMcpel+aQ1bwpsthBU/t030Ma3Q41jhWcI60ujrHTQnI1/hHutt4cLt/RvtHpydn2YWE+ZTDWlkjGmwLwC2u9XrVmph6g1MiiryfYcUb4ddLlA1CRf0A+Q3dEX0jn1C488JM1iHXSCEjwY8ZvrYumfhXSEJaHzrHH97vXQRYY1Ob0enYw0c7gunzijN+oPvwvscuCHZybO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Add CFI_STARTPROC and CFI_ENDPROC annotations to the SYM_FUNC_* macros
so the VDSO asm functions don't need to add them manually.  Note this
only affects VDSO, the CFI_* macros are empty for the kernel proper.

[ Jens Remus: Reword commit subject and message as suggested by Josh. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vdso-layout.lds.S   |  2 +-
 arch/x86/entry/vdso/vgetrandom-chacha.S |  2 --
 arch/x86/entry/vdso/vsgx.S              |  4 ---
 arch/x86/include/asm/linkage.h          | 33 ++++++++++++++++++++-----
 arch/x86/include/asm/vdso.h             |  1 -
 5 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/vdso-layout.lds.S
index ec1ac191a057..60747905de2b 100644
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#include <asm/vdso.h>
+#include <asm/page_types.h>
 #include <asm/vdso/vsyscall.h>
 #include <vdso/datapage.h>
 
diff --git a/arch/x86/entry/vdso/vgetrandom-chacha.S b/arch/x86/entry/vdso/vgetrandom-chacha.S
index cc82da9216fb..a33212594731 100644
--- a/arch/x86/entry/vdso/vgetrandom-chacha.S
+++ b/arch/x86/entry/vdso/vgetrandom-chacha.S
@@ -22,7 +22,6 @@ CONSTANTS:	.octa 0x6b20657479622d323320646e61707865
  *	rcx: number of 64-byte blocks to write to output
  */
 SYM_FUNC_START(__arch_chacha20_blocks_nostack)
-	CFI_STARTPROC
 .set	output,		%rdi
 .set	key,		%rsi
 .set	counter,	%rdx
@@ -175,5 +174,4 @@ SYM_FUNC_START(__arch_chacha20_blocks_nostack)
 	pxor		temp,temp
 
 	ret
-	CFI_ENDPROC
 SYM_FUNC_END(__arch_chacha20_blocks_nostack)
diff --git a/arch/x86/entry/vdso/vsgx.S b/arch/x86/entry/vdso/vsgx.S
index 37a3d4c02366..c0342238c976 100644
--- a/arch/x86/entry/vdso/vsgx.S
+++ b/arch/x86/entry/vdso/vsgx.S
@@ -24,8 +24,6 @@
 .section .text, "ax"
 
 SYM_FUNC_START(__vdso_sgx_enter_enclave)
-	/* Prolog */
-	.cfi_startproc
 	push	%rbp
 	.cfi_adjust_cfa_offset	8
 	.cfi_rel_offset		%rbp, 0
@@ -143,8 +141,6 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 	jle	.Lout
 	jmp	.Lenter_enclave
 
-	.cfi_endproc
-
 _ASM_VDSO_EXTABLE_HANDLE(.Lenclu_eenter_eresume, .Lhandle_exception)
 
 SYM_FUNC_END(__vdso_sgx_enter_enclave)
diff --git a/arch/x86/include/asm/linkage.h b/arch/x86/include/asm/linkage.h
index 9d38ae744a2e..9d7f90c57451 100644
--- a/arch/x86/include/asm/linkage.h
+++ b/arch/x86/include/asm/linkage.h
@@ -40,6 +40,10 @@
 
 #ifdef __ASSEMBLER__
 
+#ifndef LINKER_SCRIPT
+#include <asm/dwarf2.h>
+#endif
+
 #if defined(CONFIG_MITIGATION_RETHUNK) && !defined(__DISABLE_EXPORTS) && !defined(BUILD_VDSO)
 #define RET	jmp __x86_return_thunk
 #else /* CONFIG_MITIGATION_RETPOLINE */
@@ -112,34 +116,51 @@
 # define SYM_FUNC_ALIAS_MEMFUNC	SYM_FUNC_ALIAS
 #endif
 
+#define __SYM_FUNC_START				\
+	CFI_STARTPROC ASM_NL
+
+#define __SYM_FUNC_END					\
+	CFI_ENDPROC ASM_NL
+
 /* SYM_TYPED_FUNC_START -- use for indirectly called globals, w/ CFI type */
 #define SYM_TYPED_FUNC_START(name)				\
 	SYM_TYPED_START(name, SYM_L_GLOBAL, SYM_F_ALIGN)	\
+	__SYM_FUNC_START					\
 	ENDBR
 
 /* SYM_FUNC_START -- use for global functions */
 #define SYM_FUNC_START(name)				\
-	SYM_START(name, SYM_L_GLOBAL, SYM_F_ALIGN)
+	SYM_START(name, SYM_L_GLOBAL, SYM_F_ALIGN)	\
+	__SYM_FUNC_START
 
 /* SYM_FUNC_START_NOALIGN -- use for global functions, w/o alignment */
 #define SYM_FUNC_START_NOALIGN(name)			\
-	SYM_START(name, SYM_L_GLOBAL, SYM_A_NONE)
+	SYM_START(name, SYM_L_GLOBAL, SYM_A_NONE)	\
+	__SYM_FUNC_START
 
 /* SYM_FUNC_START_LOCAL -- use for local functions */
 #define SYM_FUNC_START_LOCAL(name)			\
-	SYM_START(name, SYM_L_LOCAL, SYM_F_ALIGN)
+	SYM_START(name, SYM_L_LOCAL, SYM_F_ALIGN)	\
+	__SYM_FUNC_START
 
 /* SYM_FUNC_START_LOCAL_NOALIGN -- use for local functions, w/o alignment */
 #define SYM_FUNC_START_LOCAL_NOALIGN(name)		\
-	SYM_START(name, SYM_L_LOCAL, SYM_A_NONE)
+	SYM_START(name, SYM_L_LOCAL, SYM_A_NONE)	\
+	__SYM_FUNC_START
 
 /* SYM_FUNC_START_WEAK -- use for weak functions */
 #define SYM_FUNC_START_WEAK(name)			\
-	SYM_START(name, SYM_L_WEAK, SYM_F_ALIGN)
+	SYM_START(name, SYM_L_WEAK, SYM_F_ALIGN)	\
+	__SYM_FUNC_START
 
 /* SYM_FUNC_START_WEAK_NOALIGN -- use for weak functions, w/o alignment */
 #define SYM_FUNC_START_WEAK_NOALIGN(name)		\
-	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)
+	SYM_START(name, SYM_L_WEAK, SYM_A_NONE)		\
+	__SYM_FUNC_START
+
+#define SYM_FUNC_END(name)				\
+	__SYM_FUNC_END					\
+	SYM_END(name, SYM_T_FUNC)
 
 /*
  * Expose 'sym' to the startup code in arch/x86/boot/startup/, by emitting an
diff --git a/arch/x86/include/asm/vdso.h b/arch/x86/include/asm/vdso.h
index b7253ef3205a..c4290dadba66 100644
--- a/arch/x86/include/asm/vdso.h
+++ b/arch/x86/include/asm/vdso.h
@@ -2,7 +2,6 @@
 #ifndef _ASM_X86_VDSO_H
 #define _ASM_X86_VDSO_H
 
-#include <asm/page_types.h>
 #include <linux/linkage.h>
 #include <linux/init.h>
 
-- 
2.51.0


