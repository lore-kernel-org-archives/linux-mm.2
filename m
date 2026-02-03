Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0660EE8784C
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:20:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29B526B00AC; Tue,  3 Feb 2026 12:20:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 275986B00AD; Tue,  3 Feb 2026 12:20:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0983D6B00AF; Tue,  3 Feb 2026 12:20:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E46966B00AC
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:20:44 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC1841B210E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:44 +0000 (UTC)
X-FDA: 84403810008.28.7C596B2
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5A0008000E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:42 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HRHRgbSR;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770139242;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zbEOunzPLvo2IhCRBkf2kXMVwbrggheQV1ILioljlFo=;
	b=EAC0qdXJf/nCLdxLnTpH6W1yHPPe8PB+RJQs5mltCEUAwVxnK/KB6glHn+qV99crCRo8YY
	WkDdj7krDCazv2Iwo6H5bIFldMbFdhjNrnJ6WXSUcKYp3aQeV1NVTsKO6PFQWs759WQhAN
	rn+A3E5pBmvcDm7EF7ebunPEOOKD83A=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=HRHRgbSR;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770139242; a=rsa-sha256;
	cv=none;
	b=xDY/SUsKQJnTHKy6fiitGwe7T1LL4RcZcfi2cWUgdogfgTQa2Fzh1VwYogIfVNV9jaf20Z
	UB8pNYKPbxqn7NBSawzzerViZm8UABgTEibqJay+Bq/saBJqw4KnKf3STqnMhrK80iOTq8
	zsCfa0KXqe4VETVQmZCnV8mJDifn4uY=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 61395d4b032189;
	Tue, 3 Feb 2026 17:20:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=zbEOunzPLvo2IhCRB
	kf2kXMVwbrggheQV1ILioljlFo=; b=HRHRgbSRlwTPUi0r5qDrskloJi/qp3Cw2
	8NVidbY70X4X7Vp8Vrq/YceTzsi7iNKdibYyjk34+H9oIjz4cGdJmpOqkLXC0ZD0
	1oLJRIG5H6V+fEVp6F0YrYBUUxU+YlEAwnYS8nyzdv4Ghz/c4jwO4u4KOv/M0erz
	nGnOfww5JG9rrahI0nU0yAkOJLRLscVL9fz1YUDQA/uhhvkCRycAZfkdxavFg3oU
	jyzPaxNzyR4bYQ87YrFMH+LJ3d7BsSl8/hY7IsxE2stnpY2MbQWjbJ8AC+ucS2Ix
	0u23XmyqOF8KWip0zkR+zBnF8cBjp7AwQ1Dzp25DDZ/1J5HjtYgmg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185gv7nw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:09 +0000 (GMT)
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613HK8Ap029062;
	Tue, 3 Feb 2026 17:20:08 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c185gv7nq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:08 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613GY0qe027419;
	Tue, 3 Feb 2026 17:20:07 GMT
Received: from smtprelay06.fra02v.mail.ibm.com ([9.218.2.230])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs19qan-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:07 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay06.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613HK3sL24379850
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 17:20:03 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 60BB62004D;
	Tue,  3 Feb 2026 17:20:03 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D2FCC20043;
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
Subject: [PATCH v7 6/6] x86/vdso: Enable sframe generation in VDSO
Date: Tue,  3 Feb 2026 18:19:57 +0100
Message-ID: <20260203171958.1522030-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260203171958.1522030-1-jremus@linux.ibm.com>
References: <20260203171958.1522030-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=UdxciaSN c=1 sm=1 tr=0 ts=69822e49 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=6udGOm5lhfMXuTISw7IA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-GUID: VHjt-eRvyhuY4XLUf2QyJfD7buAYFta9
X-Proofpoint-ORIG-GUID: k8yu3lS81fBWOPKqR-jxHpstuWEE1Jhv
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzNSBTYWx0ZWRfXwIQ27Hx9zQQd
 quiqKbhCnBg/r/j/fdE5Y0oelOhIoUBVBZsmjbL6ak++GlM+L2TDR/g6ppoOHDLEvDyao1UgSIT
 ryiRqREfnyVEGQg9REeYKztEFqLNkluUKWQwDV3E6wTdHVf2qnBy607vsgQmWGp9xQOLsO+MkEU
 UnkaeAZjznG/ir7gEDLLTq5WIvFS2tRf15zmt7VkLCAJ4xsb2IdY0VngqRc0bawvrk06mxbOyxX
 uFxJjvUp+RphFiZn1yBLcuau4FnSYjhI/EnFeiGWoN1SHSdICIJb4Q1SNX0fElkLdK5zeOHZ9Mf
 8HAXbAZWupM3w+W9650RMmwwb/KvNmqIGkpJvBrEuNYCccCVTJ4W/uez6aD2u0rfUmIwK+8k1R3
 ZhCfYowILeQ8u8MehP73UQF2VILd/qXLCGcKkimHl3mPlxS0YZ5h9KEk63pRKioXw6OODAjKg4S
 NTfPsKhHbeIHhEekWwg==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 malwarescore=0 impostorscore=0 lowpriorityscore=0
 suspectscore=0 clxscore=1015 bulkscore=0 spamscore=0 phishscore=0
 adultscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602030135
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A0008000E
X-Rspamd-Server: rspam07
X-Stat-Signature: ttrk5rrjbkoq6zaqqmobtrbtg1hd3nyr
X-HE-Tag: 1770139242-251394
X-HE-Meta: U2FsdGVkX1/7eDFVCoyS2aJDgPgk0ggaZVqQBHfYm1lVyp/p3eTUxMUn+PzSdOef6+rrKnrtY3kPsGJ8liLswXoI30KoPzkvyTIB0EuwXTLupxMiDNJq4R0lo9QmJvalcHUyQP6nV6MJ3/NIxBWi21wQdHYWv2STfst42H2ADisdTbMWt6ZwY9TGgOfMDA/YZ18j2E73d/8KbAPH8U8iD2h/RpHC6mZwvYIBXl8r5uRzMJWsHN8utwGnWtrs2WUBnTziv7wHXHD6qC4fTXC1WjSDisB+qAmPRTDHC5rD2sD304fie4DBEpJlj3VZs5oKe8ucuJCaLeliN5COtK/Eq4jOODWuRnySU9vHNYXm0UgMt7zCWyOqGWigJgUlC6wVbVmlTlBSy+aTY2E2ANJK3d4Ber87rGeUAOOOdYYhggrBGc/2YrkuQb6rUjknrcv5Eo1KkuGalUGQM9qmw6e6K5uMLZsRPanSbf4bebvbvYzBvNAfUR99pCpQh7msjosKkd41GjkV0O3w44ZI7W25+eGdv6zymTWp6coW1BfzsR6NYkEGiZfctG0wtDZaUGiZYJxqVQNujbR1uWCJfYVFexIQW7itdwbnIM+DFxKQwHsUPIOL6cevpMI/LXQfg1s3kYFlvHcC1dhBB1k3qQJtxDgp4AKRXIYOIxPz6uN/HFCije213oRBGW/RuY7ByGuANbj/Bc5njaaBPnFmZKG3Io9kP6GFaZYdZlUveI7yljSI9Y+z3TQs6z5LQ2LCvhERa1yJTXR/zob5qGvkX5XQH/RXH45JaELkN7jfY+HyGlrKW/J2GfCkoNQxv3JiE4ruuwEDikFSqm9i6eTZ9DzsPO2xDzGH5ZNyqKNzOdbDl5G9Ztm0iF75ZAx8Zr/Z/HMRdXt6oOG5E4zP7prEY/CIY4n58LWJHq/RU1C6d20rEKGADwvXMwlpBhoK29sIWSOJdX6A6a4xXTs9tvndcyn
 Ukpzd6As
 Xlua12TE40K3DHCWGEvlzWMAaCONLj7znxuwJcLKDgdu7KiEA4pDjeZf42K2sFCMufL/dvcUHPmxCzYhis+bMnYi42ZIJAgCoOYRU3NraNAgNNSUM1Vy3EhArEUxr5S9rEaAdMEIHdjf5DI3NBSI7Z4Hkum3UqmdhkjnMVYAFdM8af5GCxLZxO6DSz/paKfrK5EWL21G+wlkXCHK+JZ7nTyuSDbrgBgOjgYhfjC0tdLoTzCcNxLCU3bn2XsyGLjXg7OPKeSqb9/lOFbTdIHMeBZeVN7n658BWqpPAUPYWDF9QkUG4olV1OKBaXo6wdzhmhZ/dh5qTkwIH8rgqk+7c3tzKCxvYc6Qu9+57wQ5BGUWhvETSZloUPXK7IF4nh1bMTxud
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Enable sframe generation in the VDSO library so kernel and user space
can unwind through it.

[ Jens Remus: Add support for SFrame V3.  Prevent GNU_SFRAME program
table entry to empty .sframe section. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v7:
    - Rebase on H. Peter Anvin's vDSO changes on tip:x86/entry.
    - Simplify adding assembler option -Wa,--gsframe-3.  Add for
      vdso64 only.
    - Align to .eh_frame and mark .sframe as KEEP in vDSO linker script.
      Note that GNU linker 2.46 will mark .sframe as KEEP in its default
      linker script as well.

 arch/Kconfig                                 |  7 +++++++
 arch/x86/entry/vdso/common/vdso-layout.lds.S | 11 +++++++++++
 arch/x86/entry/vdso/vdso64/Makefile          |  1 +
 arch/x86/include/asm/dwarf2.h                |  5 ++++-
 4 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index 31220f512b16..8170e492a44c 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -479,6 +479,13 @@ config HAVE_HARDLOCKUP_DETECTOR_ARCH
 	  It uses the same command line parameters, and sysctl interface,
 	  as the generic hardlockup detectors.
 
+config AS_SFRAME
+	bool
+
+config AS_SFRAME3
+	def_bool $(as-instr,.cfi_startproc\n.cfi_endproc,-Wa$(comma)--gsframe-3)
+	select AS_SFRAME
+
 config UNWIND_USER
 	bool
 
diff --git a/arch/x86/entry/vdso/common/vdso-layout.lds.S b/arch/x86/entry/vdso/common/vdso-layout.lds.S
index 856b8b9d278c..421eb4ca9131 100644
--- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
@@ -60,6 +60,13 @@ SECTIONS
 		*(.eh_frame.*)
 	}					:text
 
+#ifdef CONFIG_AS_SFRAME
+	.sframe		: {
+		KEEP (*(.sframe))
+		*(.sframe.*)
+	}					:text	:sframe
+#endif
+
 	/*
 	 * Text is well-separated from actual data: there's plenty of
 	 * stuff that isn't used at runtime in between.
@@ -89,6 +96,7 @@ SECTIONS
 #define PT_GNU_EH_FRAME	0x6474e550
 #define PT_GNU_STACK	0x6474e551
 #define PT_GNU_PROPERTY	0x6474e553
+#define PT_GNU_SFRAME	0x6474e554
 
 /*
  * We must supply the ELF program headers explicitly to get just one
@@ -104,6 +112,9 @@ PHDRS
 	dynamic		PT_DYNAMIC	PF_R;
 	note		PT_NOTE		PF_R;
 	eh_frame_hdr	PT_GNU_EH_FRAME PF_R;
+#ifdef CONFIG_AS_SFRAME
+	sframe		PT_GNU_SFRAME	PF_R;
+#endif
 	gnu_stack	PT_GNU_STACK	PF_RW;
 	gnu_property	PT_GNU_PROPERTY	PF_R;
 }
diff --git a/arch/x86/entry/vdso/vdso64/Makefile b/arch/x86/entry/vdso/vdso64/Makefile
index bfffaf1aeecc..459f8026531e 100644
--- a/arch/x86/entry/vdso/vdso64/Makefile
+++ b/arch/x86/entry/vdso/vdso64/Makefile
@@ -14,6 +14,7 @@ vobjs-$(CONFIG_X86_SGX)		+= vsgx.o
 
 # Compilation flags
 flags-y				:= -DBUILD_VDSO64 -m64 -mcmodel=small
+flags-$(CONFIG_AS_SFRAME3)	+= -Wa,--gsframe-3
 
 # The location of this include matters!
 include $(src)/../common/Makefile.include
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 7cc30500c095..90b42367815e 100644
--- a/arch/x86/include/asm/dwarf2.h
+++ b/arch/x86/include/asm/dwarf2.h
@@ -12,8 +12,11 @@
 	 * For the vDSO, emit both runtime unwind information and debug
 	 * symbols for the .dbg file.
 	 */
-
+#if defined(__x86_64__) && defined(CONFIG_AS_SFRAME)
+	.cfi_sections .eh_frame, .debug_frame, .sframe
+#else
 	.cfi_sections .eh_frame, .debug_frame
+#endif
 
 #define CFI_STARTPROC		.cfi_startproc
 #define CFI_ENDPROC		.cfi_endproc
-- 
2.51.0


