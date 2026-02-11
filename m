Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0B09E9E30F
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4DF2B6B0095; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A5CA6B008C; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E0396B0095; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E54016B0093
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:14:35 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2693C140407
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:35 +0000 (UTC)
X-FDA: 84432371310.10.A625F90
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id B869D2000C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:32 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="kz3/r5BN";
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770819272;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cSiBsMiyvS7cygGX52RlC3XdEyvxbuMMGQjKtYeDTPg=;
	b=fwHNm+izV/SH+PXPoGAh74kmCiAA90Ek+jtoj3d0FRtMHWyaU2xJQPhbG6FBEt9bBy9XmR
	43fkDSVJyXxntG3eKQR0KTTbDA1LkR+fe9ky8skMRg3slUO5BnFdN88JxteHR7IIJhROCy
	eq/Vp/d6KSpgUj+WDW4Ho/z/Qq6o+LQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="kz3/r5BN";
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770819272; a=rsa-sha256;
	cv=none;
	b=aZ07dPT1M8EaAsaNDFcm1JGVZmeksijsZ/P8PXlo+Vut59PNjbN5Zbr+lr9h5/M+wVh7vf
	UHXYr4L3f5ZHnyQ9OWy8OumDRJzJIj9ych6NaIv592R9TAG8Y2kpK8k2OGKM45pPX9mR/p
	pRpoCQcoZacEglIYtCa9FFhM/G2FqmA=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AMPxUu091358;
	Wed, 11 Feb 2026 14:14:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=cSiBsMiyvS7cygGX5
	2RlC3XdEyvxbuMMGQjKtYeDTPg=; b=kz3/r5BNvOSuPyChC5xPDRz+Snhhv+bl6
	ubTrEO9TxQhY3Fixxws+ivvSF87HDzy+8XbDr/Yua2mN0+d6x6wSSKhvi09OxgVu
	mebMiZ9Hz615vzeiGu861YEWc5kIDHsyV/NIwRhmA4nkYul4zMYODpwy+vhotGYl
	zhelUsKlkmJCgBtAI2STG2LIRDBHSzLfvHJFpSjwWR2Xy0A3atHcGAqHMwXjRtoY
	c8QJu1sZn7uHefU+H7dCWWNAe2+6rtwMuhMS/gncg8RpOEdPV8/1DPL+kE8DQmt5
	0KOUj94zunLDkcvd+e6hcXDt2zz94++nk/i2TgY3oaHNOaw6RxXSA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uhfmg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:05 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BAomEB019258;
	Wed, 11 Feb 2026 14:14:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk5wag-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:03 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BEE0OH59113890
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 14:14:00 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2FAD920043;
	Wed, 11 Feb 2026 14:14:00 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9822F2004F;
	Wed, 11 Feb 2026 14:13:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 14:13:59 +0000 (GMT)
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
Subject: [PATCH v9 2/6] x86/asm: Avoid emitting DWARF CFI for non-VDSO
Date: Wed, 11 Feb 2026 15:13:53 +0100
Message-ID: <20260211141357.271402-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211141357.271402-1-jremus@linux.ibm.com>
References: <20260211141357.271402-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=YZiwJgRf c=1 sm=1 tr=0 ts=698c8ead cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=zOOTxvlrTZNIKiBVQswA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-ORIG-GUID: x44cYHj-o3vU4pGpJe8M9L_He5W8_tnK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfXxH/OxxGB55JO
 qBUnCbUmHRLSbbJAIZu+XQXLey7Y2Ch+IBMyV2QNdzdRzH6UvzIMEiciXzVh9wR4Uy9RCMFIvBw
 x3MeMCK64plX9iWAL+GCBFZpSkVpapzcKbCAAYJmTKt2slOMOMlki2Z3T1WzO26sun6KfBDPRKV
 oT0bo0zlZOxZn5zdvei7LBvNiL6wVgBhKLh5Lq+9Bz35NuRoH+rwp9V7SfB51VbMgCLKxrOOvT8
 2i4BFQlnaNQIeqm78PmOSqIivRwTahmfJaOg0v5c3O+LuCON08U/Lq/L9dpoSPxdMs2gaRC/S+I
 ks62tke4+92z14Y1f6OT+YygLXEFae6Sp4Cj4JeJ573ncloPaaFfaA99Sxm9+nv7X5nQfPxFa7J
 GEsYTYQdRP6+LOOkoK3Alt0P6n2J/GwJ3bEErSlBntqfnNSdmPQdut7e57hGhs5HGSxiztJDIG8
 qpCHOTDyntY9XeiN1eA==
X-Proofpoint-GUID: RUCt7kZLLE97Paz9uCofjiQX3_DqMij0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 spamscore=0 impostorscore=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 adultscore=0 clxscore=1015 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110107
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B869D2000C
X-Stat-Signature: r1h83jt7xiajj9aryeasbg54yktuos9t
X-Rspam-User: 
X-HE-Tag: 1770819272-131362
X-HE-Meta: U2FsdGVkX18+T14IsjX6vJ+vFkjZUVybnNPW3ibz4q+JqZiiqLRZoltE+xJj5y5Eevfx3sD+aLTDjs8jJen17CsUQJnJQPXpg5GrIiffclB2HGabNrFpan73P6IcSRRSF7VJ+nmXRlW/iWk52CEigJiVhMc3+a8NTx5l4I40BuItAzZGLrOPouMWveVpyqwvmiSthIuzjR17k9JY5A9ivbq0U4TQbZp3BqOPl53mrvTAk/n/L/FQr1n9FZVoOEGTkoNOZyVZv4KDZe8H5TWyts8PcEPpYCBKaaR88CL44xIZ5wnFKNE2qQ+dfAt1Cwo5eg58HoVOiqYgqaRn3Z69YVRmLfyGsdebdiE7HCUYRdRG9Zb0gpO6llpLdqHAqY5WBxTnBa3D2YE10JJW9kftyeC/RaogkRUWnxzUqxVxdlFuhwOIIUsxcR//sfBBbAmY3UPAFeRnSU4Jy4nJiI2cbH4r+DMrseHcTZtmrmXH52GIAnLJdVZaPeq2KMPLaoYpPJxxfAo6r460NYgWsf/Dqt2nNbKO7kEuqn6wjZAtHxbtoyfHx66hUMGwm2X1ycAsekBoPDlKXPIGWxuaHB0Fj3Vp86MX02b+yMI5mN9NvR9vIKuT6AZAGA8sBXFJvYur8RpJOQlBvDkDpQorXdScCe1xKlPnzuszPALKgYKL928Gnhx1AuoApmlyllR4XCLDKaQ6oLO9hWhEqCaIpt6oazM4efhSDzzrj3PFuU3hZ4DF3cR7gnosgry738JEyBasPX0p80l5tL6vaPCH88JjU/hsATQ/DYMcyDZ5Xt4VlIxnlHBHbQKGoflGheqI7+Lc8jpOw5F0PbW4B95rPUepwbCMzp7nGL6ryDMwQIyPmsTvIwEmHNkbAO7AVqsbwA5joMdIDSrodZILqQE8KDwLc3U69RALh+AKcErmiFev6IAX5Wh/w9d1ZEeBkS+Xuu42cuGQPIxrZV7+kluXTGl
 iyMK6/eN
 YztQZwqUT5XOwfaJbDUSTfyn4EcUa5d4QwsqZIXzRwznXhcrVZloib7KvgQvneF83v6SdEHWxjJGZWVrm4jgAnP0iEd7PSDywuXv4nhqu7FWvapPtH/W4W3shXYFsj+Rckqe9xVAv4dUjdoLqhfAxXatdWyZoywHlt//oHkbbp9TKfQ99oh4y1G/UvzaqYyDrcURVQ6dZevwb7kyKg3LVo7LfOaxpRSRUO6IGgmgWt5Ld4qxNxS5jWWlPLtsiftYSvmbYDjO1PsSg3ling1tJYrnuo/MB/W+UcEr89e/1hm0RGBpsacuEUQFerhZ1D8Arnf/uyX8r34vzNLdficaTlNYagdacmY1s4nqO4BE+Qc6AFAf9kvgkxpAf7toqLKN0yqPDEvhL6/gQverZGhGt7WbvT1OjXT9wBTzVJckByA3mepFfaKBkN9UiSg==
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


