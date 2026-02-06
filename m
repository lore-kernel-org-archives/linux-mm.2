Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 534D4EE6B4C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:37:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B97B46B0092; Fri,  6 Feb 2026 14:37:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22A36B0098; Fri,  6 Feb 2026 14:37:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99AAC6B0093; Fri,  6 Feb 2026 14:37:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7DA3A6B0092
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:37:14 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2B7A4583FA
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:14 +0000 (UTC)
X-FDA: 84415040388.23.1B192D0
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id BAD008000D
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:11 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DK5QG2gF;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770406631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2yoq+h6mZB9/GPSodoD2HiVYMivcoOgmMDda9g822Iw=;
	b=OzVVzawRIquJvHCBwKPicmTuQf7pbNont7+t1WCIkBe/f4PHGtMYjsb5AJ2aWIUhhahwUI
	XCrRe5biGzEIDujAj3v0KyuLZNMvfu0T2gI9y0RNzRmfoDs4T8is1j77SkeHGOPqwxM3na
	ejXH2PwCLakfrJ7/J8irdDSEE4zYTh8=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=DK5QG2gF;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770406631; a=rsa-sha256;
	cv=none;
	b=llQF5vEr7iIWPN6617w+tVnDmJ5NXn8N6Q1s30vpOCS5xwCk25FkyJSCbnFMaHNjuakx4r
	KBbGNtWwjO83ltaZYV+eOq/TSRxKtvv7ZA6XjQVezwFlFUhagUd8mjmmUxxkig9gvXXfxq
	WQKZOEjYUIV8x5BG3HwvKfSQ69vy/7o=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616CnfYC027933;
	Fri, 6 Feb 2026 19:36:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=2yoq+h6mZB9/GPSod
	oD2HiVYMivcoOgmMDda9g822Iw=; b=DK5QG2gFeP36B6l9P0cWE2ELzOP4elYmV
	JINE5LDx1CfbVoPfOeNN0XVASoDlsu9pBRBqQRUkLXXpNoQQvP+JS3kRJuXmh28U
	cCqNBs98V2g9MZ8rScWgE4dyguPxjbRLSthIlah+7CPq624kwlzBjbQj+gJ5n8aw
	2Br9dhV6/8FBmTq2LMb5+Zzh5dmjD8IxMyiFJc0y43IUhahyTooGj0fU14IY3be4
	D/obvFmgBNbkSEr0N4gbZ15DMDM4VIqWp+Z2WNqo/6f9qR5/T7Y1U2KtK/+fTWkk
	Dn26uojV3Q0j7t/nKCx/K6muJPKxRHKh4pLq3XzB4WSUXmLXCWiXQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175na2u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:51 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 616Jaosf004210;
	Fri, 6 Feb 2026 19:36:50 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c175na2u1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:50 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616HqVs3027348;
	Fri, 6 Feb 2026 19:36:49 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs1qb4m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:49 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616JajdN11796958
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 19:36:45 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 17A2420040;
	Fri,  6 Feb 2026 19:36:45 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 982E320043;
	Fri,  6 Feb 2026 19:36:44 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 19:36:44 +0000 (GMT)
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
Subject: [PATCH v8 2/6] x86/asm: Avoid emitting DWARF CFI for non-VDSO
Date: Fri,  6 Feb 2026 20:36:38 +0100
Message-ID: <20260206193642.1580787-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206193642.1580787-1-jremus@linux.ibm.com>
References: <20260206193642.1580787-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ga-6PM7vNYrgQgTGQqmjgW5kEaBoxd2x
X-Authority-Analysis: v=2.4 cv=VcX6/Vp9 c=1 sm=1 tr=0 ts=698642d3 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=oGMlB6cnAAAA:8
 a=VnNF1IyMAAAA:8 a=zOOTxvlrTZNIKiBVQswA:9 a=2JgSa4NbpEOStq-L5dxp:22
 a=NdAtdrkLVvyUPsUoGJp4:22
X-Proofpoint-GUID: 3sQTOCeco3KdfPwBYI8kOe2KzWqP2DUJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDE0MyBTYWx0ZWRfX495HbASuKkh1
 2jcSG9t5Np/glcCp45HbmjjN+bNtpbDMsTEv+VQc7AEhlTvLAktCg4Yc8pXH7ZM7K2wC00DiwGY
 NEBRmGgqGyHzy+Z+UXdhX/tT7RUUIk8jtnwC5lF2fMVWU8ujFyJfxrHn2PwM8fiKH1FSl2BJZdm
 Aqzmet/XnhJeJxw4M/VJPuzw+ADjj07XhD/pMR4wLP4Zlu/zQYZ9Y+6eR0MnLaxeynlUXX/FnPK
 ZA19cBM1FLDBerii/c3XghkzI8dU1W4icvmsX2vcB4T/gIhvO5ZlxVxNn95OY+vlGhmIZmuvR9g
 unE5IjGF19VxbA8v6ayu1IYbtQ3aHSxlvFfFDkimHymQLcl70Mbqi6bZa6DqxNuq6hOOpoAG2u/
 i/GCbYywXM5L0lCYwpUzuHG6ialZoeLQMOZgsAgfLo7IcR2JUrr9DtDeqw9zQbO75AFcPfyM/mZ
 Zu/9RtAokVe9ALqtvrg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 adultscore=0
 bulkscore=0 phishscore=0 lowpriorityscore=0 impostorscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2602060143
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BAD008000D
X-Stat-Signature: cd8gqbaoycdnf3k91yifscx4c3gtbmwk
X-Rspam-User: 
X-HE-Tag: 1770406631-418840
X-HE-Meta: U2FsdGVkX1/5gnIgMkjZa/hcoK+757EHknFo3jDZ9/zdDC0eGlYYR5YDK0JXAlxXQiMaeaAL7QudEuL8IGLUoSbN6zErp0bFtdKMv8C+INecohpC+yZb9UY4sjYSagkUBISA3QWPrr10yuhX8yKKrvB5DA44/WEYsx3WokDgK4WGS8AqXAefQM8eAqxWu2mFAZ2T1dJwzIk7TGQeV8hBjE2qxfyAwQGuJuQGt4JEY1dLt+Y+tzx/b8uKql6pQCVk5u1lKJP/twkqXEWrfktKmq5bVOqadNT+QRKxE9iOUp0tAaKlzmuTIrevdjUGm4cCg70MgfLRpZAP/jEySMivgz0TPigky2LKUDNwqJILia8GBEQTzlOuxAMu6R7uNZiNS6eLl/skHCZuFpZSLXsNZqOZu7V9SG4ZN5YGdpJzxT6rOfngdLIl7DUtPY7r+0tEICLsJKRahQI3ADA+cE0xA9y1ptMXoeKHgHKrU8l41VnCZMrMkaK6wBs1MlXp4Xp8o547U1Vl4X4QIgHGNWgk3AXNSbSDQ2JYMpysU0I91rRz2+ROAbYs+IWIwnu7a3Zk1iS5oOOm9SlfEsMbuNfKRAxdeic9EUOW1g90PHGcH61slYH0+5BtaZZyKJ4RCoR6ofjKR7H1B7DHNESWSs7o7D9fdfHWPQJ6XJSB9bfYd7R+CFHsukttmylRtQebNlZiqPZmMgn5J9cRA9M+d/dqhLv9Ld/s5+MfOFSXIhD2Urs1MfQs6kvhHgufXElysWYX6dY+b1qiao90YHm/aLBalE8FdvSnQfTWsm77SE768RNEwQaB0/81WNlQlAFkkIWEVJTaaslsdReV+fd3w+ST6G7AxMdPGgPEf5gRSrAeEEnLzDXN77f+nG/T/76aU4i8sIMltXAyzgZTBxQOdl/0SzhXNnNyWBORiY3XLDOD/Kk/LzjaKiW0Xi5a+GQ8oaw6Qx7x3qKZRI+OuxDEmhJ
 zC3EoXZC
 XQ3SUKqX4aTwfFhLrI/gjZQpS7kLn2vYmm9dWr3P5IHb9RchHFeFcOdLiHsbIHEh5NHupOnOXaDNcNpntftfN4DRIHxU+ZCSLcNf9fKjAqYFkKn0nQeCPnG/8WiI7Wcbt8UcP2YrY9UfS+75QjUJHrb3Qe9W53idGQw0ho4pbdyeOEPAcGUdHk38v08dYLKmP8VvDWsv5YmEoo3ktpQJYWaxX1APeyF9Jeci4DFPeWjPokaGt/vPhu9GSSLwv0rsVjaMjueset21MwIL2N8nbuBrSu5m4OAeooF1+WW2yww/nhHkI3d3itVESzYQv3cTiBNHwezVF0Yq+bm86Jl49YPykk1wdJdvWb+eIjxGoDIGVLZdeCn4zkr0DASEQwOwD91WSmErsi0E8qNgqzIOPiBySNjlbWscg/tzKuVpem72tcLxf1yl2Luar+A==
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

Notes (jremus):
    Changes in v8:
    - Define CFI_SIGNAL_FRAME for !BUILD_VDSO (new on tip:x86/entry).

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


