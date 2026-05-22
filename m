Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 062A2CD5BB5
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:05:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA8426B0098; Fri, 22 May 2026 07:05:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E58C26B0099; Fri, 22 May 2026 07:05:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C5CA06B009B; Fri, 22 May 2026 07:05:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B15916B0098
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:05:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 79B469284C
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:03 +0000 (UTC)
X-FDA: 84794773686.07.73B7D30
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3215B20010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=N56kr6qA;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dukp3RbmqmBUYvLDRffdTZCzKZvbBqET3lnQ61OH3Og=;
	b=dDmggLrUeCJtzycQb2JAnfzWoYxaBQs5kQ9v4/jt2X4J2yS/5Vv8KgB4fwWrcYUEq/jhp/
	tAbiRpmaAJzAsU2YVC02y0n6cKIDCREg6s0GLXt5ZmpvwlyFf5/BZQALiX4PrjHdv4CByt
	m+lvCpmCIAR8HPXx9DIqNTEgMMfkMTQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=N56kr6qA;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447901; a=rsa-sha256;
	cv=none;
	b=Ia4XdY7xFxt3ZX74pSfEVQ5nDRW2qwucR1WY1U3mJaiRjG5bfWNDonLWvrizDUKlMxLUXd
	ZPvPGaekErCujCdfyK5nMfGD2Epub0+cXVx8FBT5ADvvcMNZS4Wq/mDREBoRPpOlqv4veq
	NyAHh6JN+KNZFAoPgsVZBWrR/ZAciig=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M688L04011095;
	Fri, 22 May 2026 11:04:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=dukp3RbmqmBUYvLDR
	ffdTZCzKZvbBqET3lnQ61OH3Og=; b=N56kr6qAD1foYW/7xO6iNN31uMXp7H0H7
	3MjJbYpv5KIef2257BYrUwyw2OzCaNtXv1h65zdWfRN5wlcYqTV5dlm+uXix4k5O
	qD/f0IwqwYH1Sw+gPxox+jPDxWwrLNp3oKxkdmOnmpC2VOLw924AIe/im+FWNK2O
	f39pEv3E+2XuEDEeIud3yvXdt70WNN886igrUE/4NriArraC/toJCbo6dVbxJV7i
	8NdzE/z+DVvMfVtNYYgx6i8c8CmqqfjnuSfR+KCwS2lgIrWUNeV+njBT9YCdqCi8
	pWSStqnbaUA1idcA4QHEZMUCqGu9LgI+p1cUU5GA2eHRCJRSU4OvQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6hb8t37a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:35 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64MAsK1H022927;
	Fri, 22 May 2026 11:04:34 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dj0grj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:34 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64MB4VpO53412238
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 11:04:31 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 15F7920040;
	Fri, 22 May 2026 11:04:31 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9AF292004E;
	Fri, 22 May 2026 11:04:30 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 May 2026 11:04:30 +0000 (GMT)
From: Jens Remus <jremus@linux.ibm.com>
To: linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org,
        x86@kernel.org, Steven Rostedt <rostedt@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Indu Bhagat <ibhagatgnu@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Dylan Hatch <dylanbhatch@google.com>,
        Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>,
        Andy Lutomirski <luto@kernel.org>
Cc: Jens Remus <jremus@linux.ibm.com>, bpf@vger.kernel.org, linux-mm@kvack.org,
        Namhyung Kim <namhyung@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        "Jose E. Marchesi" <jemarch@gnu.org>,
        Beau Belgrave <beaub@linux.microsoft.com>,
        Florian Weimer <fweimer@redhat.com>,
        "Carlos O'Donell" <codonell@redhat.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, Jiri Olsa <jolsa@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v11 3/6] x86/asm: Use CFI_* macros in SYM_FUNC_* macros so they can be added to VDSO
Date: Fri, 22 May 2026 13:04:24 +0200
Message-ID: <20260522110427.2816637-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260522110427.2816637-1-jremus@linux.ibm.com>
References: <20260522110427.2816637-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEwNiBTYWx0ZWRfX7eRzAGSEYild
 aTh2y6YS+EpXO0McH09V1dB44x5tsQ52vOKGlEnRpkVIvVk5VRfRU38aBK7voga2cLYqZdb+jCC
 O7OFnhTTuw5oXAYNJucb86zPONwtUOkQ+mDkmxZlucv6lLkMJuiw3sYbcBmHfuzPo49TxUjajlY
 iabrMN2niogIDbH35DoMSu6xMcbZF7JzEtGhN6mACUOZxgi4CHlKZFCma0uxPhKbyrBaKcDz7OX
 cVCVVOO+zBvfvjZQy+RrCMn5zTqJznSoGpdDLJKufuyeO9JuP/wYpjboyf1NXCWKg8mzeSMZSIv
 rVJQA5rq2zMO3icnQB1xekq/d7Pm3GKu3Wglwc9ld7q51TMc5wF9vOQsXjlIoQU8HLahrlgHsNY
 YiGaaYDG9C/Q0XW8P1q2mG2Bf+lVSxUJr/Ma4m5sMUEbYkHK1ACdEQY/2ubEJYG62d+XajSFCzy
 udmm6jb1ByoHt1CTahg==
X-Proofpoint-GUID: mYPKGMVhPDV735Hqyi2dytZl4AyO_oTO
X-Proofpoint-ORIG-GUID: MmEW4uDYM67WTyhb2NRlf-QM4roo-tP9
X-Authority-Analysis: v=2.4 cv=aYBRWxot c=1 sm=1 tr=0 ts=6a103844 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HSAZBKcgB-AHDwtM:21 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8 a=VnNF1IyMAAAA:8 a=i3XSr9hboEKZ3AC0laIA:9
 a=2JgSa4NbpEOStq-L5dxp:22 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 adultscore=0 bulkscore=0 suspectscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 phishscore=0 priorityscore=1501 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605220106
X-Rspamd-Queue-Id: 3215B20010
X-Stat-Signature: 6qq4gx839yfjg8f885ntm3njr996ywf7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779447901-369742
X-HE-Meta: U2FsdGVkX1/GHxfCukaym/ajfq+ksXJ5u7qdBkOpQFT2i4oKsp1Ay65OpCzUzidUFBUXCAjZObU2L0eUc7PsOaDljz8ksA6DxApCCBtZFE5laMphgTr/rEnA+Hj7l4q4DOsZu6INfXgeDPygii/Cjm1OtXKS5mhjCeWzd0GJ7xnCh3Zkz2x8cziKIINjOAUfkPEohhfXhl5y9ZDnOx0Xe320zhrREOx/46PvJYoh2Iqp1Uv59H+OoxDw9Fn0bAFhWIiOe9K7d4b6iFru34IPZaiyaddSiGjUWiL+/YbBXFbcKZ9xydd5HLa0hDtsEN2bbW2O682pUMmxEC0/iLJpcoCvzV4NgZcAm+zjkimDA0aWjNdTN7y0nyPU61mrzH9EJgEkfClKJfL36JVCrV6V6oujK8S/nkDRmt7pYWmuoEDxBeTXBhU/TibUiRXwBEjAqFMVQ2xMdgA/kFPwvgpMVLwUiHFg95xsg+hCbBmv/D04PCCbIwkUKBANa0VqdATeC7sSYTnOeEwrLWIj4p5hKHaiFyw2qGbztCJBVAry33Xbpdg5UMukq+wb1lXzYSOJvIxTqMYc+reWpC2JFpGqwhCtm9uN34zPmAEamzfjAHpGWHW0Bd7Y0cSNPUJZVJqxRVLAIj1SoJCjK+6wrbCfnohnwW2fD0jjCOOOz0Tth8pHhDQoOayeBYmPWRW9Pw75v8Mis574WmZ8KXoyw5BQ2fef5Xx2RVX1USYV8T1B56E/5wsEJXeAl911QmixMpWlqD1/dAGuHVIIDUZ1xFxge89bj1fIkldvY1VG+nnfTywG7pdoOqIIaqpuOgmRH23phYKGoP9o6vd1BrZ1JqHcJ2N/bQLljMMxicqRQkzu0ExMNWxDeUwVRx99O3C4L7/nXDyV1cNOHHbPx0kLEqmmn01fK5uDRoH44ipLeHqlB6+RqaDWfGIgpwG+wnWO5yl8AEmEulH/WyqGq1n0aBe
 sWWHWrWS
 RVFn7LeSlpIM+goVgZUerQJgjrCfWVTOZmVuwtiyNCX37slh8MbqmFcwCV+63D5KYGHlVaklmy/f2wIashYg/tP6iXjWzUvIx/c4QHv3Kj0PXN3oRWjW51vCf8CPcL3EtBPjJuz/2bhbmP5Z7ZGwaTdFkGzPRQxs4PRwmYRzUFHC2PM2ax4kOdEoXpF3HSnnCIKgutfHvnswS0XgYspB7xVvPE5PryOYJJVfH6piE6A0bbvjveQVY8ZNc96tdZ00UwGUE3Zz1aSaM0/hNA7PIjnVyFMiwUEPvhDDMS/BhccG+d+TE1M4MJ5eVYNKndKKouccjoh1L0FVAzdKRKu4JEXKF4FFZoW4E2VRfFoBbHt5To7pY3fpHxVhZ/sI4ZonflKT0xtySYA+PY/c4dA3r8skeHhijU1Q3aj4MQlusB8lSXDA=
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

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
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
index a7294656ad90..c2ca8117376f 100644
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
index f2d49212ae90..bbe270483e3e 100644
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


