Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 829F7E9E310
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:14:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7E06B008A; Wed, 11 Feb 2026 09:14:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 113A56B008C; Wed, 11 Feb 2026 09:14:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9666B0093; Wed, 11 Feb 2026 09:14:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7B566B008A
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:14:33 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AC7EE1B3A46
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:33 +0000 (UTC)
X-FDA: 84432371226.03.6FFFDF5
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4560AA0014
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UhE6gbKu;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770819271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q3Xt6rhgAo9PMTm2PCN8mvAUz0apI+pbZI385wxspwE=;
	b=Z1H8K2tFcwDlIS2Q8/YwL3zD+vikpiwCant/pAaogsIgY/eIOYK0nIOLXWPc4HspWeOpe3
	0RHs5SXxVSoya/XsYLGFjnvJ1Hz0clygGh6q9c4zhtErX8MwwZE0tQrKBks32mb1xqJvtX
	AYxiAJFf1DYxZEcTyYlN+YPBLZMi2xI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UhE6gbKu;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770819271; a=rsa-sha256;
	cv=none;
	b=AWX1hNkkDvOkRtqC+jCYFniTShifH/DddwlRJlO+WdgLsHfJodxWp1MBs2UwtCEEMjBkj9
	F6ODW2ebxpH0+lTNIOw9QfM3N8p3Dvm8FLVB7mh25xal6wQQnipsoBQ4KZfsGR46pLAjY9
	wGS27nWaJZJGOcJ6VMwXWthSYKCpNas=
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61AMN58T247099;
	Wed, 11 Feb 2026 14:14:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=Q3Xt6rhgAo9PMTm2P
	CN8mvAUz0apI+pbZI385wxspwE=; b=UhE6gbKuuBYtiX1wPvAncyAppLquVqzkP
	ZnRVK5jfbyI/B1LZc5vW6nhk4VqWUzEuG/nkLgLRgi7gp8KJGYX/nBZKQuHEn5WC
	8Rvel6z2himbFdyrktWTDIei4P9PwVt0fL5T+DmlZDI69atDDZnWfZUTHKmHbO8Z
	U/c1bbh28qouPMdCD6d7slsXS7QR/j8sMehYyIsnbN0LM/VgGKiiljpDBU99Rftn
	5bGYv/B3NwLxpWFYoGK7kf9Jkjpc/sqS2LlbuuKWspRIlGYbMAtAdMvCCJw31eiM
	ewe0rS/enuI2fWdOAD+SiAQ7qQseZZR6dEaCb9RKLqSSCqm94h11A==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uy0n5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:07 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BEDuF7001420;
	Wed, 11 Feb 2026 14:14:06 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c6gqn63td-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:06 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BEE2ln44171754
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 14:14:02 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 82E2A20040;
	Wed, 11 Feb 2026 14:14:02 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E903D20043;
	Wed, 11 Feb 2026 14:14:01 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 14:14:01 +0000 (GMT)
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
Subject: [PATCH v9 6/6] x86/vdso: Enable sframe generation in VDSO
Date: Wed, 11 Feb 2026 15:13:57 +0100
Message-ID: <20260211141357.271402-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260211141357.271402-1-jremus@linux.ibm.com>
References: <20260211141357.271402-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfX7HSPJ61QxQJs
 +1eDrcApiym3Em4pW7xtFyg71gjw14Gqf+uGMziZuGfsVtHoZ/IFuWlerRQMZ4UWlA8Niup5GqP
 omxcAy8HxkPSznYU09FCa2yYg0dDP+3FxAIpInemNApHDQthBPpRcXJwxyw75qBzZpgh8cMIBhc
 VCpD1VFf+n5hyKvSjLD1Rq/iAG7UcRmq6Fxqu66U6WToInRtV6nDzLYUWoydaGHzgZWke3bMutd
 n2GUPG41SAYiYqKFWP5JwQzI8T9clSC26qDFG6O4q/Hd16yoQ4UjmI1Ux3yZqzp/71tISW6sTXM
 SGOgYnwDkEUh5uGMn+1Z0OzejSOcjP+qkqhQeNpRrIWg5Msd8d9l3nRaJsZN4Ho6pX0GMzvpoWP
 cQYu8FH51DyJvsXvk1L/s0ubI5z0esJ/JEqQZ+j03/ccPPoZaOW5iZKgv+Sy/DhYF/5re2Yv8Td
 UA/wxfSyFQ1TptNpilQ==
X-Proofpoint-ORIG-GUID: x6hV9bK3Cg9x2EG9Dvt43keP7ljRBpqb
X-Proofpoint-GUID: 1bRUXk3Z-0Yr6vbsGSG9vxB2aqhunltn
X-Authority-Analysis: v=2.4 cv=O+Y0fR9W c=1 sm=1 tr=0 ts=698c8eb0 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8
 a=Jhyzjtp1HSYqCdt93m4A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 priorityscore=1501 phishscore=0 adultscore=0
 malwarescore=0 impostorscore=0 bulkscore=0 clxscore=1015 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2601150000
 definitions=main-2602110107
X-Rspamd-Server: rspam11
X-Stat-Signature: c8168hq9xstc3w3tzzo39w4nwjd3wx97
X-Rspam-User: 
X-Rspamd-Queue-Id: 4560AA0014
X-HE-Tag: 1770819271-347495
X-HE-Meta: U2FsdGVkX18LLPhGzZ8whSRyMrMxNs+68KkS4xLnvuLMuFMX+Fy2olsdjCzID6Lx0D9VMiZpPpWd3TLMs9bWRdKFg2Ym0wEZJCwiYUy0HVdmOPCIQzn16hKzfoohXbyIABEF15wg638MSAAnsGj+fUdcTGAbNSLKYCk8pE17wgbV4ti9dWtjg0aWdk6s7YPYeIygKJ+hZENps4sYlWx8T0+X6B+S2UEAFVSVkfxSOeaoMaDLek3T6zr/yqQoXhYu2qHcDZdE+F6WNcphicBPmMBQr6qVKiD7eb/KvK4kkahD7TCS2VzGTS9jHRgFWOMF4+EWZ7RC+xAL6vWIim3nTpCFQubOoAcJWIduB0ddR8Dcvwqi6o6oR5+5wDI42kvaEn1A3IIYWrgc+PvJZONiDMWiLkk8t78MmrWV5zl3c41eIE7T2Y1BQqOsyxnjzeywlqH7/D2wRCTq/ZlhpplNJowALbtFOiP6TjUetIFehtZSB6HSnkGkmgb4xLyI5q6/eLCs7RMgAhPFkNjFt7lJCBMWZWHSKuqt3K5qY5YADSQlNU8RHyAl1I5dNI4kfhQC3cIgKA8OOC+CJJBlSA1OqcCTks3Hai7vHgTmw21Vkd9ut42ew17S59dmYrKaKFjN8ltRUQSozUIetkrNALRtQfc/X2KNaw69hOp/srsEzs1sX7GAuAE341k5W1yMTooh4u17FHlho3+QH06D6BNF7JFw3IcR8vhJkc5YHTDgwgWY0ksQ6/VXd7dcnen4OKMajoM/l1oNPvey3R26RduF2jy6wfoMu215o/x7brHAWWce8GiQHwaA/u2jrAH/1JXX4y27tbQins/KQmUgsCT47y88TnZaJGAdjuVkdMoExuX5BR70t9gYr95EZefj9T6WAF1ymrnlbwBoLR/yszOZEk6rK333bYI6FzXmW1EF5XNN3vsrlVsVnEOHbL9/n6pt9lSy0jfdVerWEgX0bTg
 pbYQFYRM
 EzkQ5FRQ8AI+aBvacxLO7C9zMgP9LbXNucS9LH5r7rnheZgxlBUDiU+Se6Anox4+zGsxGc4Kbin87s9WdJ3+7fDzylSlP7QUjwI6N3SSbO5oAZ/zhRdgBThc+7/8zevY6KdhVsXN/zVko94LdbaGUUs1jBDV9UmSwtICFUnPciGCaeSyMi160+pXc+EmXxCfUGJiLq2u3dy95Dd5sO2/rravHAvhd6WxdlLbeU9ZtTTCJETChRC4d6hnNrsG3hCq04Ka2i/iNPPlPC98KKzIub5hu/+ZfQwpujlC1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Josh Poimboeuf <jpoimboe@kernel.org>

Enable .sframe generation in the VDSO library so kernel and user space
can unwind through it.

Starting with binutils 2.46 both GNU assembler and GNU linker
exclusively support generating and merging .sframe in SFrame V3 format.
For x86 SFrame is only supported for x86-64.  Not for x86-32 nor x32.

Test whether the assembler supports option '--gsframe-3' to explicitly
select SFrame V3 format.  Note that testing using Kconfig macro
'as-option' is not sufficient, as GNU assembler will accept the option
for any target, regardless of whether it is actually capable to generate
.sframe for it, as long the input does not trigger the generation.
Therefore it is necessary to use Kconfig macro 'as-instr' to provide
minimal CFI directives that trigger generation of .sframe.

For x86-64 VDSO, only if supported by the assembler, generate .sframe,
collect it, mark it as KEEP, and generate a GNU_SFRAME program table
entry.

For x86-32 and x32 VDSOs, given SFrame is not supported, do not generate
any .sframe nor GNU_SFRAME program table entry.  Instead explicitly
discard any .sframe.  The latter is required for x32 VDSO, as it is
built from x86-64 VDSO objects (potentially with .sframe) converted to
x32.  In this regard discarding .sframe also prevents potential
issues with linkers, such as GNU linker prior to binutils 2.46 commit
7487c98ff07a ("x32: Allow R_X86_64_PC64 for SFrame V3"), that do not
support R_X86_64_PC64 relocations in x32, like those found in .sframe
in SFrame V3 format.

[ Jens Remus: Add support for SFrame V3.  Prevent GNU_SFRAME program
table entry to empty .sframe section.  Reword commit message. ]

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Jens Remus <jremus@linux.ibm.com>
---

Notes (jremus):
    Changes in v9:
    - Always define KEEP_SFRAME to either true/false in specific VDSO linker
      scripts and use #if instead of #ifdef in common one. (Peter)
    - Reword commit message to provide more details.

 arch/Kconfig                                 |  7 +++++++
 arch/x86/entry/vdso/common/vdso-layout.lds.S | 15 +++++++++++++++
 arch/x86/entry/vdso/vdso32/vdso32.lds.S      |  3 +++
 arch/x86/entry/vdso/vdso64/Makefile          |  1 +
 arch/x86/entry/vdso/vdso64/vdso64.lds.S      |  2 ++
 arch/x86/entry/vdso/vdso64/vdsox32.lds.S     |  6 ++++++
 6 files changed, 34 insertions(+)

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
index 856b8b9d278c..c486b07b195a 100644
--- a/arch/x86/entry/vdso/common/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/common/vdso-layout.lds.S
@@ -60,6 +60,13 @@ SECTIONS
 		*(.eh_frame.*)
 	}					:text
 
+#if KEEP_SFRAME
+	.sframe		: {
+		KEEP (*(.sframe))
+		*(.sframe.*)
+	}					:text	:sframe
+#endif
+
 	/*
 	 * Text is well-separated from actual data: there's plenty of
 	 * stuff that isn't used at runtime in between.
@@ -80,6 +87,10 @@ SECTIONS
 		*(.discard)
 		*(.discard.*)
 		*(__bug_table)
+#if !KEEP_SFRAME
+		*(.sframe)
+		*(.sframe.*)
+#endif
 	}
 }
 
@@ -89,6 +100,7 @@ SECTIONS
 #define PT_GNU_EH_FRAME	0x6474e550
 #define PT_GNU_STACK	0x6474e551
 #define PT_GNU_PROPERTY	0x6474e553
+#define PT_GNU_SFRAME	0x6474e554
 
 /*
  * We must supply the ELF program headers explicitly to get just one
@@ -104,6 +116,9 @@ PHDRS
 	dynamic		PT_DYNAMIC	PF_R;
 	note		PT_NOTE		PF_R;
 	eh_frame_hdr	PT_GNU_EH_FRAME PF_R;
+#if KEEP_SFRAME
+	sframe		PT_GNU_SFRAME	PF_R;
+#endif
 	gnu_stack	PT_GNU_STACK	PF_RW;
 	gnu_property	PT_GNU_PROPERTY	PF_R;
 }
diff --git a/arch/x86/entry/vdso/vdso32/vdso32.lds.S b/arch/x86/entry/vdso/vdso32/vdso32.lds.S
index 8a853543fc0d..3a161f8e9c2d 100644
--- a/arch/x86/entry/vdso/vdso32/vdso32.lds.S
+++ b/arch/x86/entry/vdso/vdso32/vdso32.lds.S
@@ -11,6 +11,9 @@
 
 #define BUILD_VDSO32
 
+/* Discard .sframe if any.  SFrame does not support x86-32. */
+#define KEEP_SFRAME	0
+
 #include "common/vdso-layout.lds.S"
 
 /* The ELF entry point can be used to set the AT_SYSINFO value.  */
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
diff --git a/arch/x86/entry/vdso/vdso64/vdso64.lds.S b/arch/x86/entry/vdso/vdso64/vdso64.lds.S
index 5ce3f2b6373a..6685cf385fc1 100644
--- a/arch/x86/entry/vdso/vdso64/vdso64.lds.S
+++ b/arch/x86/entry/vdso/vdso64/vdso64.lds.S
@@ -9,6 +9,8 @@
 
 #define BUILD_VDSO64
 
+#define KEEP_SFRAME	IS_ENABLED(CONFIG_AS_SFRAME)
+
 #include "common/vdso-layout.lds.S"
 
 /*
diff --git a/arch/x86/entry/vdso/vdso64/vdsox32.lds.S b/arch/x86/entry/vdso/vdso64/vdsox32.lds.S
index 3dbd20c8dacc..5270fd0bdd0f 100644
--- a/arch/x86/entry/vdso/vdso64/vdsox32.lds.S
+++ b/arch/x86/entry/vdso/vdso64/vdsox32.lds.S
@@ -9,6 +9,12 @@
 
 #define BUILD_VDSOX32
 
+/*
+ * Discard .sframe from x86-64 compiles.  SFrame does not support x32 and
+ * it contains R_X86_64_PC64 relocations, which linkers may not expect.
+ */
+#define KEEP_SFRAME	0
+
 #include "common/vdso-layout.lds.S"
 
 /*
-- 
2.51.0


