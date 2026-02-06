Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6199AEE6B4D
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:37:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46106B0089; Fri,  6 Feb 2026 14:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1D646B0092; Fri,  6 Feb 2026 14:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 908896B0096; Fri,  6 Feb 2026 14:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7D1AA6B0089
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:37:14 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3C6B3B80C9
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:14 +0000 (UTC)
X-FDA: 84415040388.13.389BBA5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9BE7160011
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qPNanBbm;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770406631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QCAVPB72jyVOQtIN9AZsualABh1ZvRwaRF/xv3xRJ/g=;
	b=vkXbSsTYgSkwYwedAy5wG5mmPcDAevbFUkg0/E37Rz8DMO5QOYwoBETl51JMsyHYSqYneM
	C4b3qvvlivx0j2cyn4jDL9h3LOOACq0azZuY2CLVqPorTAcXptqZ8APyYW8dAzxBJFFWmn
	ZH2k2EcZtmdSvEP6CXhB1q6jaZl85HE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770406631; a=rsa-sha256;
	cv=none;
	b=dXYpClkr6N4Z8S7uvN4eXU57Ave6Bo2eOqYR3+gMIe8Hm37dAarvP4JEdfgNfG/DFHPoIW
	IncXw4P2eBhqWFB6yt3ToQ+/aAwumeh8tXTAzQhxXAkdiYe/ROOLcuwO1xhgkx57x7cpiy
	ZXuajGkZDWBw3r13yjW+Md54C/hBEeo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qPNanBbm;
	spf=pass (imf08.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616BGccx013109;
	Fri, 6 Feb 2026 19:36:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=QCAVPB72jyVOQtIN9
	AZsualABh1ZvRwaRF/xv3xRJ/g=; b=qPNanBbmktCh0K8Wn7X0VbDAborUuj2xh
	Uw9ZiLoFmVmZj5ucmupLJbarxd4svQOT6K/VBOoXc1EtegYkBA06F2FV8yEfpFFI
	E15mZsypfHICsZl+XgzPrCUMip1mZMHw05uHRKbhSMk27cMnxVdIjEG0lrt34Cep
	lG/yDcWZ6SLkLsLBbG23B22U4mDOjEqzrAKZVrI+07KWt9ZLQhPkfxj6tINqyfy5
	2y0VaVchF1+cPsBPdKp7RliP5A9K9cKLQ1rSIFEY6OI4e5XYNbVplBPkVJuiRg8i
	bur2rEU90BxNm3jM5RUoDKdOW0r4UYEnPvTHecfwVpCslKvACapsQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175na2u8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:51 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 616JapYt004215;
	Fri, 6 Feb 2026 19:36:51 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175na2u2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:51 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616GBvUX009147;
	Fri, 6 Feb 2026 19:36:50 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1veyfpp2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:50 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616JajvL11796960
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 19:36:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 90C8220040;
	Fri,  6 Feb 2026 19:36:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1DD622004B;
	Fri,  6 Feb 2026 19:36:45 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 19:36:45 +0000 (GMT)
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
        David Hildenbrand <david@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH v8 3/6] x86/asm: Use CFI_* macros in SYM_FUNC_* macros so they can be added to VDSO
Date: Fri,  6 Feb 2026 20:36:39 +0100
Message-ID: <20260206193642.1580787-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206193642.1580787-1-jremus@linux.ibm.com>
References: <20260206193642.1580787-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: WHTwM4LcvveccdB4-B2GG-XgFt0zai_d
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=698642d3 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HSAZBKcgB-AHDwtM:21 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8 a=VnNF1IyMAAAA:8 a=i3XSr9hboEKZ3AC0laIA:9
 a=2JgSa4NbpEOStq-L5dxp:22 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-GUID: sUtyIwKinwH7phyPaHZHm32n0QbhG-sr
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDE0MyBTYWx0ZWRfX5MJxenjC8u2r
 c2eaIHRgfl8No5IulHsfFpPZizTHPSSwBd2gNtWsI43OGjg3ckadSfV4Kdoci0KrjUtmMHp/+it
 TAMeq00FHj8ng4O0PjC+t96wbDbEDAtC5KYGSrPWKyzebw9QrAqVGGmM0TYzIjTsg3OiS86SsNC
 AUZEuE27NddZps1aloHsgmuFLv83JBjBmqVOJpT0vpSAbR231jQBm/9kFZv+AnnHZciA9sag3cV
 vCQeFJIE244EJ5w5UzQUe14mtCY97HPhveyacfHTEEZh8RbPvAS0ZO3wESy7YLSBsV0M8AI7mwp
 NbpAT8+Hhr4ZYe9+uHDx71BncmzQp1x9kX58DFCEX1Hv9lr3PmxwbkW4/wBsYnE09nJmcuwfvam
 xJ1T/tvBjunsXIunWoODooTYkyUYLk3f3P64W6tRmhEq31kUShWHb6xZIF+7Eh0+KTG2ZLhrZkk
 5f7hQ24ebUzHpqDmxMg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602060143
X-Rspamd-Queue-Id: D9BE7160011
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 57fyt8xkfwft6g5kcox7bhb9h7dw9dh6
X-HE-Tag: 1770406631-772035
X-HE-Meta: U2FsdGVkX19lVZiVsARdo6Mq+2VOku9vjlZyJgdLJCrLsm5f5qkB2kq0xag0ecnrv7u8DRvftETVU22SzoDMz4NvqqwOqEGz/chU8OqF45tSNGquoz7miuus7OB2nSqMY/c+RPOHPqtptemYW7sGCctKZDuR7ZzlsfBj4dkavLGSNZQBVoBzrhjfMCTpownVb/O7d1oBu8lZIIA79sjsbv8ZqvcwVl2/5GJWEZc5ZuWWk+C3KOeY44h8YSbvrRZ3Z1lA/Uc4H3lX5TUvshE+2HsB83EtVg9N3gaDxe9iRjKagi34B9Sc9WzqNBg2Jk3yg/IUmR00NFiX1Cd3/iO6i8+WbE2UiEZou50q4DIZg51kjUbagDTictRATtJX1uESNseEt6mgB/ihTgBAYxni51zm9t04+ljvgA1+Qr4Z+JPxrgPNiuUOSWEqGN9r8lNQAlep0q9ZKnsWimTlpqIIVDfAlGIsZtsfJAcdcOG3NUxPKcpvCVGi95PwLi9/Us2fp/kOc/MYjENI+CoRoTF3xyc3fWLYXMu6OTs5qFdBsBdHiDx02fgoP4L2TrY5ZladznFVQcDHll9P9aO+sRIZQrWFfXolf3C//I/RaNGvWCNdWXjbsp3nfyolMOVyrlZ2e6O3wX0nu0LizUkjLhGIx9JveT9ghEtDq33gzZo7bECk7CTSibigzaxhYTFQWzNN+cXGq5BzuvhdnFPgX9UT0gyU8ewqP+u7vvzycU2FA/q34UFjdUhVQCyvRNnulswCjSmSeoDb25E7sGY6iz9vPLg3966g5pHONQlcehAlMwQW8hLC9iM2N28v4c71kK3hfSgRYcm1kcm2MtRleYZpsOA2MHfvIXHwSaxCD8wcSREb6ZjIUARsYLwZ/31+b2WjfzGprmhNQdKkJd54w9GRlkP2pGk9ygFWGEf/exOBmpYM0DVoLKPoHeejEKJRRZ0RoDUGarmFUZjdnvm0m4Z
 Ju/0bq1M
 DEgfWTlrgihQLkJo68zpSMoMhFlNidAUNe6MHTYy/Q8XsLTTISTCGMZPaKA9VR1vm+0FwNHUflwiFX05WUlUopHktuH8t0Rq5KOAHD3m32gbJuNpT7tTP8NZCCqm9T79L/9pRI0Rbe9QwbP6ZBdnU9LOE3xcY4prymZjPmNoar9RUxbOquCfUFWtE+u9csmPEYU0zbF8r4fpsqQqNcLRt2oJyxuj9nTNITCVO/K5DyF5ocQCKl5CtAuNhePfz/5F1jfM+H0VZkrJYw97b0y+aRhyT3jt36dwB2SjELyLphkv4hFI6pz38EIaDmq6Nesj2WeIsgaE4TUf2sgF7TkUzpc94kHzuuj9qKz8DsGBEk8/P/YGt1WubEiXospY967rRIH4bjBrju+dpw4YC8AfrWSr5FPufyvtN+6yD9sAVt8tNglQ=
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

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v8:
    - Reword commit subject to Steven's v6 one:
      https://lore.kernel.org/all/20250425024022.652143069@goodmis.org/
    - Drop my changelog from the commit message, as the patch is now
      identical to Steven's v6.

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


