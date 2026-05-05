Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A1CACD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A46B46B00AE; Tue,  5 May 2026 08:34:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D0DE6B00AF; Tue,  5 May 2026 08:34:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BF476B00B0; Tue,  5 May 2026 08:34:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 742156B00AE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:34:15 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 226C71404C1
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:15 +0000 (UTC)
X-FDA: 84733308870.24.65B3ABD
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 83468100006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qmlDclUp;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777984452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSiBsMiyvS7cygGX52RlC3XdEyvxbuMMGQjKtYeDTPg=;
	b=1+L5+jHevUglv8wDOl6PgMRUWM4jDLXQrAyK6qZEjsOQ/++mFCsvQia+VRo/spv95jfXGg
	Uz+dij6vnteLHhYm8NrpKGIuNP5/mjBLBhv0L1QjuNoYZi6ZsvNjSNIP8lz69FcG0N9+Dy
	S4EtHVW+RZCVKleqpKJdKo2wAr9xjAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777984452; a=rsa-sha256;
	cv=none;
	b=vA8rnTBpXxQYdksOG5EBEFk5Y+6MCOjyhC7JX2cLjz/QWJkGu/MBHTksEIpXivS0bPzHTf
	Y3idtMfvMFH+TzbAKqjGk34TSu0ITgDOul8pj0lYQcPLCAP9jy7qZwJBDwZtb30mw7xqE0
	+4p7v2Sqrs66Hr83690sNroZ2WNI+Zg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=qmlDclUp;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6457Vt1j2805903;
	Tue, 5 May 2026 12:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cSiBsMiyvS7cygGX5
	2RlC3XdEyvxbuMMGQjKtYeDTPg=; b=qmlDclUpN92qW9d+YesE/GcqxsAMp6EoH
	a7TF23djLdcniuwKYSgTgKz/6lsQCeNXtSDHFF6Z3jyAqYe6cfMmrsF/DqRHQy++
	0yNRVBvugQoSfdz5ADQ09ktEGubO+OYDPml6Ouoxaos13IskEQEyYbJmFJuKjIYy
	BZWKc+lxueQ9aHXCpaMsWvX15mh14f/n/jpg64rauPmT5jkxLYLRIGOUys1CwMgt
	rrGzT/5ayP+1wtPm3NT41a1xTHbRwRlQiN4RqFRD2SN7ovIlIvS5TRjVmRz1vVqw
	VvbDmhIAd+8PWcI38S+TziSrK8cRD2iGrhaByh+VMfhZXkRL2Tklw==
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9v7bn05-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:47 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645COOsh030976;
	Tue, 5 May 2026 12:33:46 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4dwx9y9aq7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CXhR320185376
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:33:43 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 42B072004B;
	Tue,  5 May 2026 12:33:43 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B45B42004D;
	Tue,  5 May 2026 12:33:42 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:33:42 +0000 (GMT)
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
Subject: [PATCH v10 2/6] x86/asm: Avoid emitting DWARF CFI for non-VDSO
Date: Tue,  5 May 2026 14:33:36 +0200
Message-ID: <20260505123340.3770025-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505123340.3770025-1-jremus@linux.ibm.com>
References: <20260505123340.3770025-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX+8UcH5+UOaM1
 NiyK+gIU52dpuz51o6BTQysBsVyNT/2mHHR9qR+6Emc/FTD5h+tcOm+YkehVAPO5XFOYOi9bgMg
 Yk8NhMcfHccMTzJgElEu0S/Gq0x1tew69hfaJkeFN5/h5GDUT1S/CrDWP4SiLTJy4OJ2n8VcGJ+
 zdt3iXbDlgGIua5NU1SD1/qsimPp+X7M21nFoGb/aYNW63LIsa3bNIG+toisTxLPz+310iBbCfs
 zTeEMnf+xooGMloeqkO5fmBGK8oOsZf744P0kcRi6BpBwA2FSzrV1D6yuWwbSAoJF30dmRkkU6D
 vLvlivEsq9xlD4KUxctpiONUN76EfOv1mdeITHDkHe7Yp6vn06VV8MK41EqyxL6NWHfsfpRzXT+
 HhnxMntyythGAMxfrm9LY6aUx819saPNKadhTIavu+/FKJ2FDOKdImtOXDZhvzw5bfofFPlPwBA
 sRd0ERyHmcZAWKrhGyg==
X-Proofpoint-GUID: 0_uFKNj1zBABeQQdK6Fa-tlAuwKxXQCu
X-Proofpoint-ORIG-GUID: CPvQIMWgxbWFE4k8IOhb5eoIN_adUwGA
X-Authority-Analysis: v=2.4 cv=eu/vCIpX c=1 sm=1 tr=0 ts=69f9e3ac cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=zOOTxvlrTZNIKiBVQswA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 phishscore=0 lowpriorityscore=0 clxscore=1015 adultscore=0
 suspectscore=0 malwarescore=0 bulkscore=0 impostorscore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 83468100006
X-Stat-Signature: oicrfaqkfk4y3kqnkcs7rz7o6pi7dx6z
X-Rspam-User: 
X-HE-Tag: 1777984452-648309
X-HE-Meta: U2FsdGVkX1/nXxscFUz58N6cqKjeVdjveDmgBVfAp2vic0ONCnxywN5B/aieJPhYq8UwPwnvaG9G06NfB8tsxtJpx/F90xpSBP3Ju0tpx3xMFnqaga5sOLe3o4xCrpWAyZwjce7efZ6sy7aM6hyxNPsrNRdH8frcBMSc0+Ayw3FNx1VC4bcjiYNtMmTGaJsBAkm0RYAq+LwMC5pjJAg1Q6rW/L7VKoGWQytJBPZgY1kZjYbusOFiHCoAt9PcbrdCwFtEgP6xnLnGOp3BRfFejl4nHAqZKd2qcn//j4nAQaMDTzH5QhddS3juWOGrhtvXVcRekdZaFcj34KKwcuVgFmFhNSb3d/PBtPYBXDu8ZvWV2mboqdiWMUciRoo0nxP3hmxW8Ea3PL/XXUqRqGJ+EYxWQ4NpMNzGT8/uh+gMFY7YJ4A30SXtoCTTXtzBNofyTf0VtdMSGriyn/f9eclur+FWu6YF5pNCsdjCCSjIDUT0AgX7wTRvjm23TBRdxzy5bi4qdYo4wLCFzVgxDqNjaK3oQw4gAr0UlpW4oqcAV6kbh7ZEsyCRTe/unxMYnXs6gzrAw7l13IdokSaDZRoljjzJfAV5oJWQ5R69na5KV1fKYMrHIHxv0amS8xK1J40sgu1yrE2EkPL6R0rXEpQ7BtofhZe9eoww+MrM/RqZ2/4t7PMPO4DOp0dCNbpZoXXRkos67yiteD/wQ0FIBymPZqsqbcZR10/MSj+OHu0uSMAgQbWtsSWiujULzz+FT2a5ySKIAg8SdVcT92fxRKfGYf7Awq7s5I7+pEhEMoML8ps7u+dUH1t00HYpw95ZpiSoVFA39sRWzRKaYeIJkHiYSdAOqS7EumTh0PNXh4ynAlj8D3ZajvobK6SSbi9QO/pSVjMLt7S0WtYc3w85Ck3NX+pA0pc6flrkKRJ+sUJAPwpeMNEctjZJ4dRlYly7lHRIO8mjFDComaY5hoxznQk
 NP3TR9np
 +7YwovIHtyJ8iDImU4qnFJG77faIw1Yi+8pU01qJRZluUXjyhd0pPL9rNLi2JRTiAKfVWrRFzndTMEgduw2gqE8zOwhmDYj0YhdjA/bAlRq2536AC5HIL+8e68j2gaXzK4Ju7EnHRkOYbkeQJPBMXBqpkg1GDaLq7GCWR5P5VLIlgxC62Uiwa3UEh6AtCGSMHawVe5R2Xog5n2VvAVynNSzPgoNyFFuxIIsnZE0ib07T6X+9w9NBsfCBLVjHrOKb4oz9lzW9tiO0qKnv2dVgklkPBo45szJy1BWjJ3ncYQRvVqwSBweFfBeRSfOMWJCuQa5OSCJPFaRj+RTCOsr6U+J2tHgv/gPH0CGEZzr4rZq03yWL1ZeRtRWejy0+ZmzYl+bvO+eLG6L9zIvkY0+CZXXbaBTesTD2Z4an5E7A1TFQIye3ByXtij/EHyw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

It was decided years ago that .cfi_* annotations aren't maintainable in
the kernel.  They were replaced by objtool unwind hints.  For the kernel
proper, ensure the CFI_* macros don't do anything.

On the other hand the VDSO library *does* use them, so user space can
unwind through it.

Make sure these macros only work for VDSO.  They aren't actually being
used outside of VDSO anyway, so there's no functional change.

[ Jens Remus: Define CFI_SIGNAL_FRAME for !BUILD_VDSO. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/include/asm/dwarf2.h | 52 ++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 09c9684d3ad6..13e2e64ef265 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -6,6 +6,15 @@
 #warning "asm/dwarf2.h should be only included in pure assembly files"
 #endif
 
+#ifdef BUILD_VDSO
+
+	/*
+	 * For the vDSO, emit both runtime unwind information and debug
+	 * symbols for the .dbg file.
+	 */
+
+	.cfi_sections .eh_frame, .debug_frame
+
 #define CFI_STARTPROC		.cfi_startproc
 #define CFI_ENDPROC		.cfi_endproc
 #define CFI_DEF_CFA		.cfi_def_cfa
@@ -22,21 +31,32 @@
 #define CFI_ESCAPE		.cfi_escape
 #define CFI_SIGNAL_FRAME	.cfi_signal_frame
 
-#ifndef BUILD_VDSO
-	/*
-	 * Emit CFI data in .debug_frame sections, not .eh_frame sections.
-	 * The latter we currently just discard since we don't do DWARF
-	 * unwinding at runtime.  So only the offline DWARF information is
-	 * useful to anyone.  Note we should not use this directive if we
-	 * ever decide to enable DWARF unwinding at runtime.
-	 */
-	.cfi_sections .debug_frame
-#else
-	 /*
-	  * For the vDSO, emit both runtime unwind information and debug
-	  * symbols for the .dbg file.
-	  */
-	.cfi_sections .eh_frame, .debug_frame
-#endif
+#else /* !BUILD_VDSO */
+
+/*
+ * On x86, these macros aren't used outside VDSO.  As well they shouldn't be:
+ * they're fragile and very difficult to maintain.
+ */
+
+.macro nocfi args:vararg
+.endm
+
+#define CFI_STARTPROC		nocfi
+#define CFI_ENDPROC		nocfi
+#define CFI_DEF_CFA		nocfi
+#define CFI_DEF_CFA_REGISTER	nocfi
+#define CFI_DEF_CFA_OFFSET	nocfi
+#define CFI_ADJUST_CFA_OFFSET	nocfi
+#define CFI_OFFSET		nocfi
+#define CFI_REL_OFFSET		nocfi
+#define CFI_REGISTER		nocfi
+#define CFI_RESTORE		nocfi
+#define CFI_REMEMBER_STATE	nocfi
+#define CFI_RESTORE_STATE	nocfi
+#define CFI_UNDEFINED		nocfi
+#define CFI_ESCAPE		nocfi
+#define CFI_SIGNAL_FRAME	nocfi
+
+#endif /* !BUILD_VDSO */
 
 #endif /* _ASM_X86_DWARF2_H */
-- 
2.51.0


