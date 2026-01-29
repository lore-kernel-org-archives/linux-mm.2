Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CBDCD6100A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:28:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80D26B0098; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD9776B0093; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE8EE6B0095; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9282C6B008A
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:28:07 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 40C305BD58
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:07 +0000 (UTC)
X-FDA: 84384777414.14.511440D
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf21.hostedemail.com (Postfix) with ESMTP id B59D61C000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ZNG/+fkP";
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769686084;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r5M640equKX0CdxLdHwrp8jnEzzf4U6HYKeUcIDGgiM=;
	b=DqGt1TGSesLJ3vwEyE70AgruIzvTEO7ZC15qTnKhmrXW01O3D3FvuSkUs6xFy4AGqezqz7
	/2It7HVIYWjNI+V9bo+KUsHrDDda6JxJS/z1D3sH6Lq1Seoz8DSjDizgWnBzw3cr0AJ37n
	SxojgW84lieUJvQoOnsOLA+T38U7NUo=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="ZNG/+fkP";
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769686084; a=rsa-sha256;
	cv=none;
	b=FTuak0i/FAW5S5XEGQiL6ZlUXMkccQQgjJuRp0/y5qhbWHSYLn2gOi1j2MYmmPjjR8ObAf
	zKZgwWiV8ratPC45YVutnzVvC19uaRZaBvm7ijB8/j8bw11upTZ14UL+uI+slhKHfLhMnQ
	slYGdIKnd+JlKz+twpDFJa137jCV+30=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60SLbDKO029323;
	Thu, 29 Jan 2026 11:27:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=r5M640equKX0CdxLd
	Hwrp8jnEzzf4U6HYKeUcIDGgiM=; b=ZNG/+fkPc3jUosQ+H0dtteQtTWodw+JEK
	CG5l+KhYGscgF391CINzZudVPlTaF/vyPBj6kGYw1IQ8BGJLeri8/AX9PeoRlOrE
	ELwL1GpxJycnqoN9CWJXS6XMBjx8aAr/iu4+1GLvRsHRfOo/WqWaWMb0TNQksphu
	ZEa9nmjWdNnSYmU5U5efsY1v3X66MI5yWgL0bZ3+cUR1wh5WXlcGl0W/tu6yiWvF
	SlgUvD6oPhul7oly5q9CS1qPUHoLJvd/gf25ZWHrXt3hzB91CfHG2w9Sg815VSF0
	YqHw6zuPcmGO4W/KkQ1Gilk2qiKtv1OsxUg3545xBP7x1xSOEaZfQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt80b02-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:35 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60TBRYSK029757;
	Thu, 29 Jan 2026 11:27:34 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt80ayt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:34 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60TBQ591031040;
	Thu, 29 Jan 2026 11:27:33 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bw8dsshpj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:33 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60TBRTre32833944
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 11:27:29 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C301E20043;
	Thu, 29 Jan 2026 11:27:29 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 24F342004B;
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
Subject: [PATCH v6 2/6] x86/asm: Avoid emitting DWARF CFI for non-VDSO
Date: Thu, 29 Jan 2026 12:27:22 +0100
Message-ID: <20260129112726.892340-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260129112726.892340-1-jremus@linux.ibm.com>
References: <20260129112726.892340-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: K-Ui_3hPsrZM0f_aHFZ4_1anvrih8eNk
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA3NiBTYWx0ZWRfX+MZiN3liFyvU
 O63XGWMmoy6SyIvVvR7KtpNmlPbou+Y84T7GvLpV3yHNmcStDxJLK0rkjGxlgs1nDDv4U4RBwPX
 bxsxsJea/kcN1SKkfSUCmV1SVlKf/uEtd2ahvt2a+ntkDFo0ruuFizCxPQ6gBY1DPn+lX1hJ4b+
 PWEqwvWkyeurDcnKsBcJ9QD+bxDJ0gIPp/y77RTMWO1K50F8aMyll9THTAM+/LKESR2dd+Rsz6N
 FikK+o2Sgb77TR6VsC+QR61KdDbqxactoDkZvCrWE8H6HV21sAfgKorlVr6bRVrPmXc85jgVu+k
 8RDk5jWGOsv2qLaAkHiLK1F3zS+fRacZMZFa4jQhkJhJdngp8DeTi4/y0UqV+dbrbYZpahy85Z3
 cA2+usBdev7huNHjon9Z2vc9uGuP0+5OrZkOt01DrIGGiLs8w/3FcaMLEZJ/dSjC6t1XlWTah0z
 xkUrzWWqCzDGLRLAkrg==
X-Authority-Analysis: v=2.4 cv=Zs3g6t7G c=1 sm=1 tr=0 ts=697b4427 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=zOOTxvlrTZNIKiBVQswA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: ABkJohemA3HCrTWt9utxuFqFfrefy_nY
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601290076
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B59D61C000C
X-Stat-Signature: prwmhee3zk5qsa5tcohu1h6xzm7ceqgp
X-Rspam-User: 
X-HE-Tag: 1769686084-647797
X-HE-Meta: U2FsdGVkX1+jjeB1hvn114Oa5KxHEfEN6w4qHUfdQNiPyDf7bbgsP5bRpSW85q5U1KlpEd3u3E/AXohVUIdVtFggvtRpoJN4Hg9J3/wAKkDwi63nTE6uFa94gZbbdtOVqmbhJymoMRo0xmYWJPkewUiEDypQg6qm/i8W8TJKkiSzbgdV8QEt8afOuAsLksrLfJOsW5Whjrz0uWuQrjd8sfvn8DFmRWIt9tsYbQft7uK7+JECqRGINS+DduCMN9GIrs1Jo/QC+ip9iSG95tKmjNUKv0WWfDIkBOpgBlJVUfEG96e39Us3d7KiBxnSnDGHBk8E5fE2xTDCJxY4msQGla+6yNdiRe4Fh+UCb08nocM7+COIl28FrAr+K/jyrd+BRDncNmWK1mLsZofzo8xfUN7EH4+CMFZjiGDIL/G7//gHa3lCObkAqCR+vcYMk0CloRmzAsgSILICu8AJnb4iHqeZqUnCglAchKJD7g2UVJo1ehsy69kNMt/x+ZUuRrXZXjOmT0me6xoH5klsjBCziF1A2Er7OfI402iElbhIuEhVkqM/BSWCfYHsD4+orI2rHYNqJf/RQRwsEwTBnIh8B56m1iJEaZixVRfAwbM5LpNW76q4/xjKEY0MwcIv3Zx67vxh75NHbdPpzWlsMyT5QYeqr3C+SsDwapobHzKLiy5dJlZ2IkS4Io6AB2BhtBLDsFtsow7AtmiKfEK3FB9S9b4k5cmlhyQsjJ/URBXWj7E5D7rbI5tF1CAIDimU61BtRfUTLrFWmvJMFRPSKqA+3ELwNeS379nllqr1j714/Ukka1aZvKPz8ZIzj82CCJeACNTBmkKSFf2DZ7tDNfbAGsQVAaOrEroRsuy3m8NnaMt+HG/bBjWhXZV3P3pEOVRbn3h4/fPaLhsbs2Hw8ACNpODVoTlhoytTn72XIWTv0iK5twgFVFbwpIcxhie1n+BUPbzuDlcbpq2w2BwmJMI
 D12f54Ws
 trouh1Ox0RdbVQpm2cBuemUVxqahxPlxJQoil4G9vnYaTsT6bjTMOkl3AIyP/02yrWs3Ez7lDa3tl8VSQ47B2FyMAxC/9h1yu106CoMB1gtPu9PR5bUOkZZL9nhoBkBlTzVIgfVa4xIQ9EsU/C7fGtOkqSCNWT7xrh+8MD1+99DvvGCkzK8UBmZXNugUvk1E8wVaLG2ZywTJO4X2dtLCrnVcngu7u9znUvh31PSpnGmhS22A40GZpjs+mWcsfsZVwfQvL5jcKu8v7tWtdb9J40GYuCR2CkNMwLNLfMs400kOO4A72RQvvSpGTE0V/t78e3rrW56OUpjaqtkkqKJDVhdxBl9EZ0o9jUMmVeseEl/+ucx3HAFlZUxjRj0vhYAwU+7pW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---
 arch/x86/include/asm/dwarf2.h | 51 ++++++++++++++++++++++++-----------
 1 file changed, 35 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 302e11b15da8..65d958ef1178 100644
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
@@ -21,21 +30,31 @@
 #define CFI_UNDEFINED		.cfi_undefined
 #define CFI_ESCAPE		.cfi_escape
 
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
+
+#endif /* !BUILD_VDSO */
 
 #endif /* _ASM_X86_DWARF2_H */
-- 
2.51.0


