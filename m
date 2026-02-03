Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CF2DE87850
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E83386B00AD; Tue,  3 Feb 2026 12:20:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E166A6B00AF; Tue,  3 Feb 2026 12:20:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92C66B00B0; Tue,  3 Feb 2026 12:20:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B330D6B00AD
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:20:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 82FDDB9E8A
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:45 +0000 (UTC)
X-FDA: 84403810050.20.507C7A0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf05.hostedemail.com (Postfix) with ESMTP id 32521100010
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:43 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GvWYwwug;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770139243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pPI9EWmq7u3u+RGtTd5A6ZQ46pFppN0FQBTU9jL6e0E=;
	b=s8cNfvHuOK1/k7s4V9TidHcA6V0ls4uuHU60TIQXXW8rCnq1VyYFIaX7BL3knvmjA3xIHr
	KKLNKFiPKJym4pDibLOV5rqwnjcPZpYq09VyPfo1T4woBueRZcKO2SG4r/Y9iUZymShw5F
	P30X3Og/gBxRaTQeBBXbVkkEpWdPgGU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GvWYwwug;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770139243; a=rsa-sha256;
	cv=none;
	b=fzMmpxkhxTER4B4GdZPB6u7Rm7rL7ZxthyK4QvDgDjunCMheT81vybn8/PeNlESySWLwgp
	gsiryb7x3TtOR/2HL38vd2fSNPlbjANM5J6vfFED/Q44ScgPcaO8RYJkVmftiv1bVTHJHP
	0UIopqU2wF+2J3XdR5JlUTQ10ZctFpw=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613GSWWx011631;
	Tue, 3 Feb 2026 17:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=pPI9EWmq7u3u+RGtT
	d5A6ZQ46pFppN0FQBTU9jL6e0E=; b=GvWYwwugR3MXWeh4Vh5v9BF7SaRZThKEh
	1VdsoQOVsvqhuesAaWtQOPU7J4KdAasGTM+Fy4CAMatb4CHBY0jTqKcxDZ0HkPPm
	W4Ikdlwi/f1Uln702N86J1X7LOQ9pj4JeczUIhY4XZAphPicmp2+m9sCGmgWLr4z
	RDI/V8hhSDc8BkORGbG1JE4HirMtIPSKGh6f/hm+NFKNUVGf3cE/i3m6w/axFnFL
	HXpw0Fg+qxujSyxjZVVmJAUmLjRnbirwM+F8WSBdbLXo5ommoD9nst8qS1UgWZdm
	PVJGKjMAinTjdC3wcO0wfYAIf71YusdJtPvoymqLPemQ0rqJlpzng==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cw4307-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:08 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613HK7FI032712;
	Tue, 3 Feb 2026 17:20:07 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cw4302-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:07 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613GWNTM006033;
	Tue, 3 Feb 2026 17:20:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1x9j9rhy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:06 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613HK2L342795462
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 17:20:03 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CB1BB20040;
	Tue,  3 Feb 2026 17:20:02 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 49D542004B;
	Tue,  3 Feb 2026 17:20:02 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 17:20:02 +0000 (GMT)
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
Subject: [PATCH v7 5/6] x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
Date: Tue,  3 Feb 2026 18:19:56 +0100
Message-ID: <20260203171958.1522030-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203171958.1522030-1-jremus@linux.ibm.com>
References: <20260203171958.1522030-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzNSBTYWx0ZWRfX3EI2DlfpE23k
 v5I/pwewTWpERmI7m882YrVSrKAVP7PRYZxaxeHC3sziMQdhkr7EZo8PfT9lsIfhiUDcLjjRTA+
 /BiNYQLCYi1EPKBKyI+4fJKnAdKSsbnigI3n6SEZwRL+KqwJUEStPV1ZUuggmoOO0+vwpg4Q4Wc
 hQKTqGStolz926/Y6JzSV2A9Yb8S1q9u2ShEq84srBxGBhgewWi/aJICtli9LqKm90Ff/FcUl2C
 JX0KWHdwRQerEo3+Y0J8mpW1EdJYLg4rSMqEEsMbdF3zSGg6RCm3KMZ495uoe1LWql5HLGI1qob
 WI5FLi09szJEp11hAC2Km1e7+RpTOMkKUEucFqFjnYo3YTdQaIsU7j30tJSXWGjbTJFHRZ4lUmN
 WOpEZtU5KaJ3oc3kT0fEqYOWpKqHPy9mIYUylVo88onO4biP7Ycymd77AZiu0Un7YPV6nTyI5PS
 mQr0WDhNkSvCafErldw==
X-Authority-Analysis: v=2.4 cv=UuRu9uwB c=1 sm=1 tr=0 ts=69822e48 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=UlpOIAycHnb1QmJiUioA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: khcPwzs2dvqSOa5gE7bJJBkBKOjeb5bh
X-Proofpoint-GUID: 1J-H7T4m2VdrwjLemy4_14tDYKVzjIOM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 clxscore=1015 phishscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602030135
X-Stat-Signature: g6i8mshzxerk1sug6qo6r5egcif1f3o4
X-Rspamd-Queue-Id: 32521100010
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770139243-598738
X-HE-Meta: U2FsdGVkX18uM34mbbeVA2z7A5EPBuMkX/ncNUDnEIh8YnAsmSrWVMnhiZ94I3Xx1X0g1rnvg1mLTiwLVuobLow6nCtoEOTEUyojLvX+gvtinAUsT8zHHOdRvm4s5zLHKPj6I37n13+Hhk7PU42OLBuiSVuL1CUxSXuUxUAtk3SYaQE9AWbVh4eyN+3v3cniFu6nRHNXSPoPFs3QipJUg/0AKnQR7q7PBU7OvWnGzkNsmwW1ZKLr8fFwPPLpcfqJ/nTGIfBYxR7P/yU1ee9MXedTQYrDnevtMguea/J6V8aNeAnkHMQdgrEhWgMqepiNXpY49OtLt3uoFR9ihuh/ccsXIN0OzebsdpTGpg+PxUpNw3s4vXQgsB/UaB3eurWh1xbjtel1b/0v+OTGxQ1r2eHGyy8jk8fScbinkPtl+NJKbK0Nb10igEO6UA6q7V89mlY9L2K+RBGmc+7Uaf1xxTVJB5y3xB5ZbDPYoRPCnoPzU4lBcb2nvljg/X5G2OrEGVCqw8B4jAQ7KBjJWEATi4AALkkL4AWAqFBNW5X0G5cDz0Q0+JvisFjvcoLRpKcFKKduNg/lq2VEekkbEFsZmzIW0LYRQ95UMk8vFnKvSOhhd9eM4DP/UPc4zDwOUHkyYkLsvro2JdL3JCRf8TdTvCfKN7t6xb4dPCiNhVG8mI/nuJ0EK2StisQc/JbkqqWa3pJSxHHp/T3LFix/LyGUlPS5Gk5E2hyerKb9wn6XkHXfT/fPAV59SUvaLl+WGsI+yFkC5CiqYC562m80ZMAL+ACEzSB0lJXO7Sxi9qXLXPO6/4A43zD+y8WRvwT5Enp3Ok65UOjUZqpfF1s0BR3zw+u8u+S3IzX1Z8Voi/D/Vj9wzaBtHTuy+sJVC4Dt+CNkvQUUMtWBSRNUvXedWgMjLABf1R8oV6DhNUbtRibARxnPL3Nsh05pHpg/GgCf5XCT/m9rA1qogydXMkFdF3C
 tRh90Aq1
 vWoSrpyF+hwb+POcb8Dzx/SrLirP/G7mizP4WAjX2pkSnVxbXJ7edEqLwu2wy2glQALOmILVzA//2bVtZq2SgpKo3XPYjzU5qc1ubHziGWPhcfwrlMNpVLNPgggFwDE+rTjw6bKFsVpl/CfuxTS7zwrcwPDJyxpxTafXjimp7GXlGqi2/xdVsELitidxcQW40DdsD4H62V3YWN265lFhks52HmGWJ62PS4P976p3M1CHQTiellroCvAORzSfBzWRNMpCA08DJ0iFBAroyafWXOeOElUwLReiqleoCeMoF8RR/0mLiWzpzcMd6Q9DYHO/8SCWDlp62qSfPCG11ohdDIvpL8+VUPimdBLfe5yODpmLGXT/BRKOKLCq/mXS3GNTVJ9RUhn5k9doCxPjXziYzrHaIM7BrvwYvvJn3IHoZccnsaBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Use the CFI macros instead of the raw .cfi_* directives to be consistent
with the rest of the VDSO asm.  It's also easier on the eyes.

No functional changes.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vdso64/vsgx.S | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso64/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
index c0342238c976..8d7b8eb45c50 100644
--- a/arch/x86/entry/vdso/vdso64/vsgx.S
+++ b/arch/x86/entry/vdso/vdso64/vsgx.S
@@ -24,13 +24,14 @@
 .section .text, "ax"
 
 SYM_FUNC_START(__vdso_sgx_enter_enclave)
+	SYM_F_ALIGN
 	push	%rbp
-	.cfi_adjust_cfa_offset	8
-	.cfi_rel_offset		%rbp, 0
+	CFI_ADJUST_CFA_OFFSET	8
+	CFI_REL_OFFSET		%rbp, 0
 	mov	%rsp, %rbp
-	.cfi_def_cfa_register	%rbp
+	CFI_DEF_CFA_REGISTER	%rbp
 	push	%rbx
-	.cfi_rel_offset		%rbx, -8
+	CFI_REL_OFFSET		%rbx, -8
 
 	mov	%ecx, %eax
 .Lenter_enclave:
@@ -77,13 +78,11 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
 .Lout:
 	pop	%rbx
 	leave
-	.cfi_def_cfa		%rsp, 8
+	CFI_DEF_CFA		%rsp, 8
 	RET
 
-	/* The out-of-line code runs with the pre-leave stack frame. */
-	.cfi_def_cfa		%rbp, 16
-
 .Linvalid_input:
+	CFI_DEF_CFA		%rbp, 16
 	mov	$(-EINVAL), %eax
 	jmp	.Lout
 
-- 
2.51.0


