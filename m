Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6947EE87852
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 18:23:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93E136B0005; Tue,  3 Feb 2026 13:23:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EB2A6B0098; Tue,  3 Feb 2026 13:23:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 795B56B00A4; Tue,  3 Feb 2026 13:23:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 653616B0005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:23:52 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8EF16C2166
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:23:51 +0000 (UTC)
X-FDA: 84403969062.08.BAA189E
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf14.hostedemail.com (Postfix) with ESMTP id 28A76100005
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 18:23:49 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CLJMZHam;
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770143029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97sz3ptFn+IzHWBAcS9kZLGRT230Lzf5igUm2viuSR8=;
	b=NTy/PN1eP2ygI9dMhdKXqBcXhizaNVqrHURelQqg1OtrmR0TPrbbrGkRMB0N+SykCdiS5v
	NAVGPLWnM/G4Be9jvEppp5eFKcf/lBpBBtxOh4gsTR2PBtHYiF+4bQdSVZNGzYrNhR6R0A
	964iLpaOIw5T09bjzee+gYZ0WoAnzpo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=CLJMZHam;
	spf=pass (imf14.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770143029; a=rsa-sha256;
	cv=none;
	b=vdHU2841S/a/biHbqyDMB3f5SpQ8RUnY3d1T0X3iarnQvKhL4DwaBUXt052njYT9olaYaf
	vjSMjxa2Crvpg3Qel8+1hTMt2sBb8m3sC+F0yiWJ5sTez8QrDoau3l19+5jXZ9DjoTHpTh
	7h2Kndh887Ms76LCRfLRJ6fasFF1FLc=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613A2Qmf032157;
	Tue, 3 Feb 2026 17:20:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=97sz3ptFn+IzHWBAc
	S9kZLGRT230Lzf5igUm2viuSR8=; b=CLJMZHamVeUwlwmSezu0m9G1P6ZZ6GaeU
	MXALycuUT7U9tveqU8//iJWVp60uuX9rwSYe2WVXERbf0OcyCGe8bsHpEgp87Ri1
	6kAY1CGZKF200gLLe6tfkw2njgx/dkeJBYCY0J9lylBnI6ipq7EFr9leXQ40OtOn
	t1OfZeX49t6nhRYEm0Kv6Q1C7ueaKuJKNcs4sb0yuacUu7a/UetaXRL4DToUKUF1
	6jI5iLUU7d82DaKeZUxSaTiwCUvExT10Xq/FHOzNcWLN5SBBW0ni/BGZbXTgryF4
	tskDbS+C7pv4ZELaaLLAtdCeYUyO4iYsmW1Szhr5RmnJxOs5kEuhA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185gv7nm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:07 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613HK6ia029023;
	Tue, 3 Feb 2026 17:20:06 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185gv7nc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:06 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613Fbld6004466;
	Tue, 3 Feb 2026 17:20:05 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1wjjsx6t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:05 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613HK1ND30474818
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 17:20:01 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1F3AD20040;
	Tue,  3 Feb 2026 17:20:01 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8DA7420043;
	Tue,  3 Feb 2026 17:20:00 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 17:20:00 +0000 (GMT)
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
Subject: [PATCH v7 2/6] x86/asm: Avoid emitting DWARF CFI for non-VDSO
Date: Tue,  3 Feb 2026 18:19:53 +0100
Message-ID: <20260203171958.1522030-3-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203171958.1522030-1-jremus@linux.ibm.com>
References: <20260203171958.1522030-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=69822e47 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=zOOTxvlrTZNIKiBVQswA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: CdJzKKERM1cgzByuDAecuye1eel0i3hN
X-Proofpoint-ORIG-GUID: VM_mh-_OuVHLOIbilB5VYZVhiJKMZNsL
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzNSBTYWx0ZWRfX7CArlsFbCu+1
 HqBB7Pre1iPR2aaiF5OSlVS4me7QW8KFWjJomiQH+GOgksOG++KYZWq1aaDsELyVQ8pbPPcZNd4
 Xz/uKAFbXXVssFxjKqZQdMTU4gjynSse090TByxowdLCJrSGAKdKbUw2ft4+M4bYh79VTMHBYMa
 ct4PD3FJBF9big/bR6R5KfX42+3vvosqJC+CiIjgSufIHHQmFcJzTsMoBPMUGpjQINr4fl3dhu+
 ZxB4iHmUJ5g10qHLSV9FHp6yVaJn9dbPnb4z8UcUlZFxOxxX9Dft445qpW2mRvI/kfzr2tcN4fV
 tKCNZub4xfZiu8hc63cqVp6zgCdIhPa+jX3oYl7nQgh2u3izoEcYwgPD9VuCGnKX5iT0W5w4ydU
 ITfL370VtFuHgCeurOaL9F7tmkmy4QdYHwhaW1JVE2WuxUwMkRwDpnNVXclBRX+e5U3sNOmz8dO
 i2fXTFnMeMqaCKT+62w==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602030135
X-Stat-Signature: pq1a8sqzruycq8b3q9akad8sz6g7nfmt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 28A76100005
X-HE-Tag: 1770143029-510768
X-HE-Meta: U2FsdGVkX18gE86LLkZVZjmreKu8Kcc3L6/HrihQl1ERa8WnYNXSgMflezVjC4JpR/Y/NRV9rQKbHgjZRod36znXc5QrrnKe5p6E8BuIsY4wG/zJ4UE3e6olR89BgqWbZieuxwr4Y/J9IRl/s1g/mcH9VHf314uK7sQUu6Umqxuq6funGZRgZQl/9PD99u/gONejg46tRaYy9juPWpUp/D5VSYfrVcidTOyHmYgJF4TO+/KMcMjt7PorgV/OlmfSG2vWIOdDJfBaglvKaUiFFL05+pMAa2kdnFf/qP5g059ob1vM9u/8Qg/slVvCyb7+B1FKDrIVRx+Yv4F3LJf6/2Me1CgS/g8g+O8Jw+889IQ1p1ijcHWzNFu8SmTUNHdhxaxpvx4ZeZVxyhQd1ox9L+n8OaRTvLH8p7ihRSnKWHhflv5KnYFPPmrNPGVI8snQdRgPnGlewI24AA/W8TOBu35SIOHd/gm8XdXo5vOcK7xzMhIefMCp0NLMiZlLwVZCu1GRfTe4RwWAeliiioA2aC7NNWFgW1rWM8daneyandTCETV+vllmrZQpZC40h7eJGXRXRqwWLHYVXTTaUbWh3DteSr5MekqTK7T+tZWlxe7quQ5IQPPFewLHw75yM04ARyodjgXbJlbhkIupggo6GXWQU+eKcHrO5Vrd8KBZv+Csc88tsAjiKmmthMNkAKkr+HHR/zLo4k/2k62Q4Lsx89gqE4FElmR2ZkhUpZT+860QEvbARvohVFLU1esuOQlLHaJvpCw5Z0lXbHgk+TyYA/C9PCYtvGLR7Y7BLbwI7/n4ipayAmRVKny+egRfhC6BOFRcaiccMY+BGflcJbsGl3wwjT7R9iyn9dC1V7S5oOSNvVGRlxFo2z82NQaVw4wc22eYZwigCvOvjwGemS6Sz1X7mkUuEB0Rz7rcYWT1zRjWezG+mE/zTi9dT+4p7mudjDUcnpw+sDMZhWkSYBu
 glCLIhrM
 v8EFPp6wtj84UXemCCVbA1Rn05HVT1/XS/vofmJM04XlS+9EB50oaJU/qokB6PFCtYy4eG4T0znw13NrYmwBy0S7xs905kqvzyjNFhO0v8BFDst7l2cNZBGaYtXYvYYrzAfWSHUT8Fs2ijfoDwt6bdsu0krb4f7WaleiRvA4G4bfewm+svT6tq8/RpkOuQExkMHxtjNS331N/0/MabnLjWt6bhOgtPH+8k0QKFGB9EmwFJq1S0qTcUc6tXQgBNlp9/Bp0PFXKlQxsq75Pze8dGIfVX+7dHqurc4Y+LEHZ0edEwxbAmpLjYV+zFINb7JWZ4Uk4u9j9i4rLb7A2qkCn6hU8hebmarjY9GSHw06Dr66EhX0Ppw3I3RF0potwljVEWExM9ASWeA5zkiyJ86B3M9983tQ5ri8TlFIG
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
index 09c9684d3ad6..7cc30500c095 100644
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
@@ -22,21 +31,31 @@
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
+
+#endif /* !BUILD_VDSO */
 
 #endif /* _ASM_X86_DWARF2_H */
-- 
2.51.0


