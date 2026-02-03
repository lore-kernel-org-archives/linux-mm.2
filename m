Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE726E8784E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:20:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CCE336B00B2; Tue,  3 Feb 2026 12:20:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F776B00B3; Tue,  3 Feb 2026 12:20:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF90E6B00B5; Tue,  3 Feb 2026 12:20:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98BAA6B00B2
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:20:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 609791B2020
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:52 +0000 (UTC)
X-FDA: 84403810344.08.9B963C5
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf14.hostedemail.com (Postfix) with ESMTP id C00EB10001E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kVLWmePk;
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770139250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qw4qDo6dg3CARlMyfCMYnV+fGLk0LGSatUAQU5V1Pww=;
	b=x84bufxOYz8YmPmbspD9BbttQwFU9AAagSRLJn2m5G3osK4HoV2cOloXULEfaD9pOjgId+
	2b0DOyF1uRVNMIN5onhFq/oZDwuivMMmAPbpZg9SLIACte9bx8+/np6bTbCdkEIfxHLjVE
	cQ7UmC9TispmRErMTWPLot102cQS/pA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=kVLWmePk;
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770139250; a=rsa-sha256;
	cv=none;
	b=OHVtR9RSCqb20adosdXAa/Rb/Cz6nkGF9a4peaPGXT/SJXegya4cJqrah1rAAfwU8BVe+D
	nVtH3OyFpPGHxv6F+a4oJtH1vQKRj5uIiEfZ5nJRDgGAT0+eq6XsYW76Vex7qBaMxCfe62
	DX3/hVYMYw2SNy9hjzhjXR73KuXeKak=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613Bd0Fa029379;
	Tue, 3 Feb 2026 17:20:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Qw4qDo6dg3CARlMyf
	CMYnV+fGLk0LGSatUAQU5V1Pww=; b=kVLWmePkRO8sRaeDytV7m/bFQKQZTuqEj
	Xqm+HDq2LoOCvsdSgwpfRaFMrw+viwyJJFV7vCOXS8T1J9yP7r8EJPgZMd1m20sP
	r+htuLSW4kaY+bG0UsdXLYRQ5MG7WpzMPGDmuxH+qutqAg35r/L0ixKAprgSCSo3
	g1RspNi2Z8OSzNEHutlF7ucBlpZroGI1XFTbTpablnAHLTGeXmS2Trps4+rk0tDX
	3KNJCw2T4Sliel4bVIoCoJpkbyzs1AbgNgqfa4zpbNKKkbUNHi1rIRaKrxY8/N0p
	kRHsd/25tO8HGlQf/yx+700TEL352MoHCyHGPM45h6hUmQfN1h7Ow==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c1986egur-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:07 +0000 (GMT)
Received: from m0360083.ppops.net (m0360083.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613HK7Wo002267;
	Tue, 3 Feb 2026 17:20:07 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c1986eguk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613GhOlt005933;
	Tue, 3 Feb 2026 17:20:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1x9j9rhv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613HK14B13041996
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 17:20:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id ADD1B20040;
	Tue,  3 Feb 2026 17:20:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 273972004B;
	Tue,  3 Feb 2026 17:20:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 17:20:01 +0000 (GMT)
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
Subject: [PATCH v7 3/6] x86/asm: Simplify VDSO DWARF generation
Date: Tue,  3 Feb 2026 18:19:54 +0100
Message-ID: <20260203171958.1522030-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203171958.1522030-1-jremus@linux.ibm.com>
References: <20260203171958.1522030-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzMSBTYWx0ZWRfX62DPVxHpWzx5
 lCKe5+QUXT2K9thsGKYywB99hLCP6jVi4BJFmU3GgncYJvsqmukQhzhY3EcnmrzNakMOzkWvLLi
 7NqrqXafVX6xULUuJLRbkBsCNAkO51Ed7NVbAquKcRspZUCon0N4gEZKxqKbQy1ubdUXFfowWhM
 wALRYwcd9A0Z/jl42QvcuaKQlWkBhnmJ9LEhrelgQte8OUIymhBLK/VBIksqKHhWgD5hTZ/BUET
 ivetuoTQH363ny072TEfujp117nhJnAC/4se3YQhGPskOvOFtC7XowjpQB1vF8o3u2GNYvOWkMb
 DUOWHhl+lg6+1Z2u+JLTpRgOaDUzZi8ETzBS4Z8UBJh5c6lV98+yFxNSnUlOR1yNFkZCBRsVic5
 Z3N7WWkPY92LqKgxaXiL0+x26Rm7C3kXnp8siZU9k+FDtRSKjyDvP4MAglkbGEUqcMAG11aIMIk
 cpVgEwNO030u/VL1iEw==
X-Proofpoint-GUID: HkayKR_KEck4XN9jAGLBPp9MbczHsR7T
X-Authority-Analysis: v=2.4 cv=DbAaa/tW c=1 sm=1 tr=0 ts=69822e48 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=i3XSr9hboEKZ3AC0laIA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: aon6OdHEoOS9aXY10Grz5SOQXgUvW9Rd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 phishscore=0 adultscore=0 malwarescore=0 impostorscore=0
 priorityscore=1501 lowpriorityscore=0 clxscore=1015 suspectscore=0
 spamscore=0 classifier=typeunknown authscore=0 authtc= authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602030131
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C00EB10001E
X-Stat-Signature: soawqk7dwjryware6chkuyditzdtg1do
X-Rspam-User: 
X-HE-Tag: 1770139249-854308
X-HE-Meta: U2FsdGVkX1+7GjTPiBqongcR7f+9rjwtxy1TBFXH0SDPhJ+XowwqkiC4fAWpLl66QHG2xCvv1mEmZWfCq6vsxjv56NIovE3g+y4djl0KJ/nzZaJ2tLYBuw/hO775/vP/Xm3yJ9Yw6EwDrvJ8FxXq+CuHuQyD39lMKRGXjBaPtrFrQl5GbRtlNYuDvbMmJfkpa8y04BslBAMFgNqdMg74vkbLELbZHGqhaD+QlFXLLCVTQqwPBax9Lumykig5WQDg2NKXfaqJaBYR8z4ffuXWgyQMO58qtdINp4DYTKBOFltqbx3wXuUVJhLDjkgeyFZkbycoYcolV5SKki+rX6pblF0dgdoVySqK5GWCSAXxR10d4dOlJS4Z8MX/fgc3z0KL/nro6RauuN3awbEt22p4IC4YGYZ8cdpZKxnCROne2DAPz6aWRvr8Nwws2WraXD2PfAqSITlbfRGgNKtSaO+Si9vu83/M9hlWpMR7PD27ClyjOEk6NxD3zanybRmUsnFiXGM/daSSdW+X3VEThatbLREKJztc865xSZX+wOIIRL3gD/E07otxoMfeeD+jFcCD8BP1KHb0YNV4KO9fXbNUeWrOHYQz0aWyDPtWQnVQhCQNp5Xj8Ifu+rRVfng/zOwu/SiMU08o8fBtoIsZVx5JVPVKAy1RFeCiznIYFg7YIbfI6E0G6WqtugnPwlJjfZhRF9IpTGpn7Fnq3Odl0lxXhftV39fe/DIobDVQ/cDRC56J/uoPAhbWTOum8OeFnRQBk1EVnC8Uhdma+fF7hq+Ye25AX3QtAMh8MSqiqLTE3mNHcerUaXEFA16NHKkF2LuRvRC2z81aUTn3VPMvNVy8/p9eNHRcH3jkMQWQJSfTAnjCu/AuLmfY5E0kMyEAEIad3Wdsorg6vpJMQMzacT1NzJieldZHpDx2dQwPR2zptPy93FSSSNX9fisCq8KHwHO6DDXIpak8ycFbPKiJcSL
 9tP3Fk8/
 HeHiiwr1YlLPcSI7eZUYrV+b56IltRn1/FLOUw85VzPWf1fpP0eOwu3y2tUjOspw9vyoT3G61WwxnsFqCsJPabdrZQLeIsJkBSCvJP8RRn/Ckfc3os8LXkdurI2xxZOoX8xSMm/8TStdTmgpgpPpJUn6sQiLq8PVQKMr/eZAnbZJ/3LJe0hWz7v9J4TWnKEvWoEb3jHS8lnx1en1LO3Uqth3ViXoD/TYbWSHWbfc/pxqBgqz1mRBFUki9GD1oWcNdxHYVz9rDVA5ZLugYk1z3RLvZXyaRTDBe4KClZ/+WdJ8CqDhT1nqV23dfLRGfZWlLAjYHBKKaMfPkvyYVUwLqgNt07EhaO6G/UibPT7GlslQs6uxbHIEbuJQ2byOqAZ7V4NjL
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
 arch/x86/entry/vdso/common/vdso-layout.lds.S  |  2 +-
 .../x86/entry/vdso/vdso64/vgetrandom-chacha.S |  2 --
 arch/x86/entry/vdso/vdso64/vsgx.S             |  4 ---
 arch/x86/include/asm/linkage.h                | 33 +++++++++++++++----
 arch/x86/include/asm/vdso.h                   |  1 -
 5 files changed, 28 insertions(+), 14 deletions(-)

diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
index a1e30be3e83d..856b8b9d278c 100644
--- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
@@ -1,5 +1,5 @@
 /* SPDX-License-Identifier: GPL-2.0 */
-#include <asm/vdso.h>
+#include <asm/page_types.h>
 #include <asm/vdso/vsyscall.h>
 #include <vdso/datapage.h>
 
diff --git a/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
index cc82da9216fb..a33212594731 100644
--- a/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
+++ b/arch/x86/entry/vdso/vdso64/vgetrandom-chacha.S
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
diff --git a/arch/x86/entry/vdso/vdso64/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
index 37a3d4c02366..c0342238c976 100644
--- a/arch/x86/entry/vdso/vdso64/vsgx.S
+++ b/arch/x86/entry/vdso/vdso64/vsgx.S
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
index e8afbe9faa5b..498ac423741c 100644
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


