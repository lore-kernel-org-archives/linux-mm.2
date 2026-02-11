Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F9B0E9E311
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:14:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A88146B0089; Wed, 11 Feb 2026 09:14:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FCF76B0093; Wed, 11 Feb 2026 09:14:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D236B008C; Wed, 11 Feb 2026 09:14:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5EED96B0089
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:14:32 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 21DC7B8BF8
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:32 +0000 (UTC)
X-FDA: 84432371184.23.8E01B38
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf27.hostedemail.com (Postfix) with ESMTP id B69DB40006
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=T8HlXSnQ;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770819269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ozqt9kYUw9hKvY7/dWXgcYglieEexRsyUqSs+6cTMXw=;
	b=Ps51NKOsNh14Jo/Z2fQuDcyNHseQXUds1tIREBK3kDusbvuCaO8kxEJSgmwdPmpLAEtfKT
	PtIKPeseaCmaXaCw3k6fpnCEqeOJnP8ZH4CCr1oy6KFbx/38QE/98G2cSmwSJVxFW11y2f
	uK6Gp4nSD6TKSLubQQn5twQWYlYeqaI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=T8HlXSnQ;
	spf=pass (imf27.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770819269; a=rsa-sha256;
	cv=none;
	b=K9NwuXxV+Ctzrf1/cVECU1pEzWYb3K60cwnLvGepR/mp0wpCDdImQ2xvzOcu8Hj5EC2mdI
	Sm+HIAFY6g0frEuJDlAGOOr1+K91CTznao7QTRHRn4afKoPEzg8G2ogNDRTvWaR8ls+jFA
	SDteYNhafFvu8VWv21azqBn80IRfxyQ=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61BB8MYn3537614;
	Wed, 11 Feb 2026 14:14:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=ozqt9kYUw9hKvY7/d
	WXgcYglieEexRsyUqSs+6cTMXw=; b=T8HlXSnQm8958TE0+FY/7Z8lGqsIJcSOU
	Fpe4XHm5+Hk1Wh48s3Nu+Qs27sUAQWbbdEiSaTdnHHxemzmWOqNR2vyn84/W0Lba
	L9gv/3nwzKrWtGDXdfYQGpaAFR6BKoWohG+kcQMvX7K2CibVXMYD2NSW7Mti8NeN
	S4EhcPy3w9ehVwTM475ARDAwzXxbA4JmQIcLIsdT99A0YoXNkWgOFIWBxXEg/w+P
	QXjxz6RPnbEBeMt7Z5AsuJZcSPQG2id498MSFDDcFbcju7sweyuA3tVFv3gSK6iF
	3hfZ+CZ2aT4KJAJt8YvrLCjqeKLMWljYAHI9YWRKnFr2JK/KpjnYA==
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696v6xkx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BDecK9008390;
	Wed, 11 Feb 2026 14:14:05 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6g3ye5v0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:04 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BEE0Vk59113894
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 14:14:00 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id BE7D820040;
	Wed, 11 Feb 2026 14:14:00 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 357C72004E;
	Wed, 11 Feb 2026 14:14:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 14:14:00 +0000 (GMT)
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
Subject: [PATCH v9 3/6] x86/asm: Use CFI_* macros in SYM_FUNC_* macros so they can be added to VDSO
Date: Wed, 11 Feb 2026 15:13:54 +0100
Message-ID: <20260211141357.271402-4-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211141357.271402-1-jremus@linux.ibm.com>
References: <20260211141357.271402-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-GUID: Ml6Orn5IoSUyqD7K0i-cbu4RT4xWxx24
X-Proofpoint-ORIG-GUID: 6FoFqX8emWMKU_rzeo9BmrQoP8H49iiL
X-Authority-Analysis: v=2.4 cv=JdWxbEKV c=1 sm=1 tr=0 ts=698c8eae cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HSAZBKcgB-AHDwtM:21 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8 a=VnNF1IyMAAAA:8 a=i3XSr9hboEKZ3AC0laIA:9
 a=2JgSa4NbpEOStq-L5dxp:22 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfX+tDqH2ueBFOq
 SgsoqkdqLsioevjTt3MUZYUwSCmrWyIQ/UQAUAKmsUwjVoax6+PeAw38nx5xebaxiuUd97etfhI
 f6HunCA/YO+qk0F+V/Z+wNPoFWhfFwkQStGN9uQ1uQBIZEFoMEovfyRH4TalQPDCP+UnG65wJCB
 11qZw0R5PJg0AOUnxA/GcccMZfptHGDBs4s4iFWfPp6EsEBN7NnRF25wiG19Y+syTwwo1+BPkt2
 qSkB29jHUnImE5NV2Qn16BuNhZ8rhUksj0V9+krG+AiGZprfbWqyvVFNDu2SjNpPF5+ICQTlMsQ
 YmiRzP5TKWpWm6KHM4kE6rXCMKB/vMJyuyBDw1TPe9UmlqQhwTR4d+VyA3Xbno5Y7/2c6s0Pgbh
 ng6HvsqIUKRI2VdBsEwJ586E4M38LcnlBiGspG0ocvpe7AEmcKTbPcHhrF+cH8q669fkWMfUkwy
 JHi52k7sV626ypWTXbA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 clxscore=1015 impostorscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110107
X-Stat-Signature: dzh6nh4j8kb7werxa4kq95o74h81w874
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B69DB40006
X-HE-Tag: 1770819269-637971
X-HE-Meta: U2FsdGVkX1+JQcj6XeV7E7X20mmHPxnVGkM2mWAV/zKpnX4H81uV09CM+hWr6tNDX1ew9y999YLFFQN/pLmfW1dggJ0pAcYroX5G77229+Nn6eALWUEEwifWEwEURe75tjNdQvoSl3WElGu9pEiTz8XEAMWbYlmmDfGVZl832ZBxdcuCXSL2DyYb9uw2bfBYYYzOTb2BZzOk4ygmrv8J+OuREL+ul/aaMg2cMBKXk0lOuE7LqHDZoKnWV8pd7juXJi79VWZ4/YJUKlUqSsn55H7iEfPRvV2rlXIlpZtxTOEjHlixR0QAhbbMnS17PkNTh19wVqFkRKh72hv9oueiEgLvLO1iqWkgYeg58yzKxcWQlhpVfL6t6LDUbbrSC3GBrwG/LkemdhOQeKKHcDzdBAWWzoCbwV4iPiCjW6aEfzEufzORbBFciLgiXaJueu8jJH/8XvEcQ5NW2O03e14yvVc59/0gEL7LJTWOL/Z4WM+Cyp6w31csTSY69JVrLZFlQ3hIM7PXyu7DYfKirjtnDntvNyJbWAI0/tSAXQr8CKPSTmWqAD1tZ/UQ7aU7SE3+yKhprw/NemwQ8VWpdQgoSNPpP9f3AZAXsaxPRawNJrLeC1cWAdX8hthUPt0lWhFfzPXB3Rh3pXRuuly3k2GwgZvQAe31kOA+CxwjNT44SslWTeDwTsyCnjkmFpjWMmi/oQk8TR3haCgr166W52TKBfuWw9LVgczkfPezre4K16RZRVDoIiQPjK8d+ykO0fo6l3fScbvoZWt5DnVeiNa6K9slY6iZID2MFLF3N+FVRZ2VMkNcE5lZyN3ee5H3PnFH1swkhk9sZA+S2y+G3+IsUyBYQj3vn2p9jZEp+vQfPbEhStuEjp9sNQzVt55EGi4tWFbZ60JleSnqSdKYqaOTWvKhTLaeJOolh5UMIdiS0FcYINtFX1NqHFm4pPBSuxpbLcy0WYlWZLSl478sXIt
 A5rsjffA
 xpit28KOSUJZIb9zvWenjxDWLvdQx2En2q3PfMsfzLm2YrsPmqIimHWiQFEctlOZBMRlTzCrOX6HINpoAV/+1GQ6K1k7nUk4VFCYKtzfSpjvX0Hah5B3LfSjq5W5y8ValT4jnev78Ymht900dDxJdGhc/dj5esTr6+sjn5qqIDTfjtKluVbKBnz1AxkkieriLZrB7g9QK0JBFoSEqJLBzLTCnpFjCafGq94a36ou8guvVniRpyB4vqklfE7HYSfCD37Oc6m84NMKIvtrh9plLdMZoEAf1kP/CBnHD0kWKRH7CbSovkClZfTOkhwVNee8CC70u2SPTEkAanJr37joa6F0mEgQx/jQKHDOjMs25kNSS+1cdf99ggK8Ccdlav8VHBg8LfMM7H0Ed7RaYa3fK/NNlJfZyKfnyy5gzEpV7m8II0XQ=
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


