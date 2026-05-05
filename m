Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87A11CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4546D6B00AD; Tue,  5 May 2026 08:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BD06B00AE; Tue,  5 May 2026 08:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 342716B00AF; Tue,  5 May 2026 08:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1DFFC6B00AD
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:34:15 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D83011C03DC
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:14 +0000 (UTC)
X-FDA: 84733308828.20.D5BA498
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf29.hostedemail.com (Postfix) with ESMTP id 77987120007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:12 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aG8VYVuo;
	spf=pass (imf29.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777984452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qiH+5t/dirTrzjD9ZdtQxW3Rb7kBj9PpVkHn0IEvdoQ=;
	b=LPzbFUJWcI8drdWEmY/Lso2Rs0S9gEn+qJrF0vp1TL9iPelXa9DoQMsBkLqUnIPAkKsKzK
	IVzAljJ6sCP7hI/pD2I7Nx1qRFe+QaDV1ydyPzv/O8nIlNg2IUM+4xDI+xtR9SKRhEyr9r
	kHSmM28nUEzTmwGVVxDftx/v9aO/E7c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777984452; a=rsa-sha256;
	cv=none;
	b=m6+jb0jy+9faQlyDSQmOasYWQit3m65xjJc9UbEcvoO76YweLdpfiNuD0k4G5A37fWEEjv
	As0X5DrN+XvsL+m6b1BO7mFokQPsJ33DnjL1/cSaHn8oH5a7a5dLEeMWijyiaQ9qOcN0dy
	64zE49hYHwM3E/PKZWX5SXWRk8g0vvE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=aG8VYVuo;
	spf=pass (imf29.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64581TMM2735981;
	Tue, 5 May 2026 12:33:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=qiH+5t/dirTrzjD9Z
	dtQxW3Rb7kBj9PpVkHn0IEvdoQ=; b=aG8VYVuowd8OgGktvj+FrXrSA+0WQ5etv
	tYrnzcyAPOYQwDTIICVEPu6qdOPKraabsACvUfus0qNwhsKP+RyZJmc4MCERooNH
	HgPQMAm6ELM4ZGPOG4vlkCogAKlm+0czhQM/tNdLRttZpsHNmJBx8hsxEWxRAyUj
	dbUvjWCw+xRkFDa+S4N+GbGtdvWqwSwahsZrOcxCaf2sJUFmTOq0Y49/SPfceFxx
	9HHHP1BzYVovLmear98SY6AfLFOPXjMr68NkTzPdVD/vJLvsZ/oIa7yfl980ht4Z
	u+vDEORvdmondhmsnJ+NHqMuTFCQjEcjK6hxyB/j1xe/8tP+5Ymig==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1bkkp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:49 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645COOdf030970;
	Tue, 5 May 2026 12:33:48 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y9aqc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CXiFw37159312
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:33:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8A7EC2004E;
	Tue,  5 May 2026 12:33:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 31FFD2004F;
	Tue,  5 May 2026 12:33:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:33:44 +0000 (GMT)
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
Subject: [PATCH v10 5/6] x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
Date: Tue,  5 May 2026 14:33:39 +0200
Message-ID: <20260505123340.3770025-6-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505123340.3770025-1-jremus@linux.ibm.com>
References: <20260505123340.3770025-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: 2FV24UMR5c5THE0cNAo3Anuc28tkxuB6
X-Proofpoint-GUID: _E4Bj6G9ZgPd2D9qS4FJvgW8GVO12I3P
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX2V3ODEj073Vk
 XO3/fGg6ka6a73/7scHTr9ZNtdTEe3q8EZ+dUNW1WXohwOEyjKGYJwyq8owxV1kkZusk3PYWlic
 v3NbW9L8O3svb0+jz0C+WImK6+s27qQalwwcSPCDIIz7CT/RH+dq9MP5TXTqVDnm6aFIXe/iX3D
 AxPHuIKgltihrmlNdmAn6mAKbD4H7DRKttZyoFRTEcc4fWvMuI5boy6jNE2xb3SHHV8UMPf4dQ2
 11U8/QY2cZ9ZG/wxagzaU56aKmcFGfP1iMtyEMiriZLrU7HSLPmiqSFD2nEAO9CiDkjQphmFk9c
 ELiNdX//mYOzzHAgb+vuaXvx7STKYVnSrDeu2CUeEyUYj6s/V4M/M1OKCVaH1QobnH+bB3biRTV
 dFHTSt5ZNt8h7uwzWvFok+OaTkUAFrizzxIfOuXOcTss7a/ppAtGA5jm//Woiaa+/Hm3cBj0ezK
 /PSXbiAD6OteadC7YYg==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f9e3ae cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=zHpKlsP_3zAlDdbrjxAA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 77987120007
X-Rspam-User: 
X-Stat-Signature: 9grbz95xpiau7hohkkdknsmzz8rnajss
X-HE-Tag: 1777984452-147690
X-HE-Meta: U2FsdGVkX1/Im6gtYv86mY1cxPaDKT4PoHF/nyIRayBBdLqS8eOp+lpzZ/JwPY5Jy84mAC8cQsD/pKENx/KBGMHepFZyeslCRAAC7gcE3LvrGNxMVjTUJSAdv+EFAnUhjosk3updU9vcZ/75DmXC7YuoorxNWFA3vv3Kg13Jc06VAUG6Vl7mrDwfc2CKFuZEj4pBKE++x6vroVrr58Ko6ocjCjYzM4Vwn7oOoOKH8ZUGdFX03uBmhTsAdfew0p4DVBvtVkMPIrQYIR72fdl3Qb7cF/JdkusqYn8M8h+9hhugcQu3xQ6WIZwATnlArPk61zvB5rFrSezwzUFZQSRF7AVcbjBz89lRYf44osxmKF+DwZm4OHrIwTvs1Q1Hg73t2OLBhyYV7mR5IQs+/5e9Zyr1xXWDBXiCQ+oupDgjLtwweMlOMBXhEEFHn4xcNqIbZ7J96jujiabuYaTFSd+QERpdRW0nh3/1ViTrIO1H+2rmhPKL6YFUEr6YS4o3fFGEdb0jfkqH6jkXjx6hJ272Tr+VWErWj9CC4eRr6p9Dz+J2XhrekVut4VM2/q/wLTDsbi6Ncu2jgYaVOXRHIY5XbxQ1z26P2EgS3XWD7llkQaVkFpN+VhPRfH/XmltOQYN8VRhBewJkpkldg9ff3Sw3x4WmkaxqU4yNXfuhzhRwFWpKXL/RnqcR+bkKsnvCqVG+EIeb2QiziwXaBHN0r262C1AHS0xcpPImx/YOlFI9GuVXk2/B5uBxgEvvp7GfWP0URKK5HDwKk7Sjo1whtVvYQuMR/Hepsiyj6aFCY7DB0juGW2pXQM4yXkKAL7XuECYmhAlpaB1iHrYumxwEc3nxUbnJEeiEpa5fDRLRIfG9shftewCsRUbi0da1KXYzilEXjOps2pgt1OAD9AUhZbfljFn+/rBnOaFwHR6uJjEE3LdCjWFd0llAdwQ8Z+0KzR+V9OipXEUrPbCwJnT6NRd
 fGGlmN3n
 rHp05Gx28hL5iOqqAO6I4brKJfpFNjMoeRnfCGJOxHxvlEbWfNPteR63JdwgE1pZsayDatIAsnbRK6MMeZk+/m/y25cGTKiRoDpcgOGGwI9LVg3y8EB7Wv9mQ/EE1WPEcYtl72guazAvN14j+AMCDF2BbWjBol4bCYs4EZfYyCto+BuhtWeLJJFGLczcthR0e9GGGEdWrdIY2dMGAWuju6LSUB/AWF1L6lFAmwXrUrrElBIkWz9zhUtwa4cMrCclrqm2MVHQbTXLggySoHH9wHFwPYRlPPT7apoHpWn0a7lOY0xgbGPrx4wSXc25Vb+XZl3x2bdl1PiLNbaMUYj96g17opGKWX1JvZ5J60CwDpqK8osPXZ7Kkb3Bcf1GSPGb8KO2jCHHPhpMRThHc6mh/w4XiMUrQljEfqHibwXaFcYOnxwGjA4X95qbuBVwYL94++Pp4G92QmQXjkCyB62/QbgdfYR1+5c1lghaxFFS6Vfo1OgA=
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
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/entry/vdso/vdso64/vsgx.S | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/arch/x86/entry/vdso/vdso64/vsgx.S b/arch/x86/entry/vdso/vdso64/vsgx.S
index c0342238c976..76efbeb1e287 100644
--- a/arch/x86/entry/vdso/vdso64/vsgx.S
+++ b/arch/x86/entry/vdso/vdso64/vsgx.S
@@ -25,12 +25,12 @@
 
 SYM_FUNC_START(__vdso_sgx_enter_enclave)
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
@@ -77,13 +77,11 @@ SYM_FUNC_START(__vdso_sgx_enter_enclave)
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


