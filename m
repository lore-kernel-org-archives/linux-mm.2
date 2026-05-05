Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC970FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:34:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 453F06B00AF; Tue,  5 May 2026 08:34:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42BFE6B00B0; Tue,  5 May 2026 08:34:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3413B6B00B1; Tue,  5 May 2026 08:34:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 22D616B00AF
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:34:16 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E1C9D40427
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:15 +0000 (UTC)
X-FDA: 84733308870.10.6F7F787
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7FB1340007
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:13 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gsC8zFEG;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777984453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r17k1R93k501Adh2XLghvooeGjUcdSZQ9KHd6Y4UasA=;
	b=o9a5cYPpU8lHeIX4OgKGDe99n+TcFC4I+56HBb9WhHm57jK2lgdALNoPcrUfSQqIRsfUxA
	5seAr2qtH0l5AgoiJHOeT43FSuTb+DL3XpGqS7ChGFmar50vTuXz7NmcxlPBpPppNE5dC2
	hy1uYziayzZpsp8C6BG9BoFQj+uCDEU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=gsC8zFEG;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777984453; a=rsa-sha256;
	cv=none;
	b=mSnYfgboSO9XWDJ6yPWEXZvz6kr09fxuTbcJCVPbdFyU5R9NxXrELisOa4wn48LfLKUghk
	1TU73Bv3FaprUzApNFSsRpE4XavfuvkDWtNaQdX8w+oIqszElelJIIj1acF54SFLHVPAAo
	uGGIifxawRChF/4f7osXBFe2hvEuwVM=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6454WaYr2230519;
	Tue, 5 May 2026 12:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=r17k1R93k501Adh2X
	LghvooeGjUcdSZQ9KHd6Y4UasA=; b=gsC8zFEGHp+mX5gUS67OKo+aL5nFsRP95
	bZBQtW4/zvttRExjQmeuHimc0TrrUr9wc1CZpW5IPBPNwgg12JtHG/zG8z8MUxBJ
	sDLwckxyNK/zi2iSTIDLZKzZILEe8/I9hhlYGIckM230MsPfkcUVKfUupBonlS2S
	1DohQTiJjUJdNMv1cjmJvJjH8pDPQ6oGlPW60fe3NktzyNHRkIUSBx6+b9leAmt1
	IeZfdr4Eu3zzKAwIEopCZzlwFLVATDfrTJFw8aoKhsHhUUf82mP3Iql6+fwDV61l
	ZmxnOeYUMYDUgPgCkmsANhVRSVuCg83je/rUOwfSfh5TWXvt52ubg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1bkkr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:50 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645CORDl016273;
	Tue, 5 May 2026 12:33:49 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjsj55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:48 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CXjsO50921820
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:33:45 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 18C0620040;
	Tue,  5 May 2026 12:33:45 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 99EF72004B;
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
Subject: [PATCH v10 6/6] x86/vdso: Enable sframe generation in VDSO
Date: Tue,  5 May 2026 14:33:40 +0200
Message-ID: <20260505123340.3770025-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260505123340.3770025-1-jremus@linux.ibm.com>
References: <20260505123340.3770025-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: TazqjqGS3DajpXpFL_l-9HGHfhTN9sDG
X-Proofpoint-GUID: swDo_SMI0-NcvdHBba3xccpfVlIWiNIl
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX6oQCIXuJVPPD
 /Pnc0MYD4CIiirwYPYwwEmOXpKUan3TMMJ8bfbsmmpHcKLcTmYVe+VKUTGbv3NtHQHqmYia9Dum
 CbT8XYNKL9ceey8ZBROsLCNbx0t756AdVL74uuRALFWLdug9Nb0W0qkhv6gEeZqVpRf+hDs4G+p
 JfZVpr9eJaXG9cdb5XW098Z8nrHUaADS840dFOuJ+ctG/LAPtd5bwm+68+8SutcxBP/xY5oJV+B
 aIIZvN8IzmTZZcZWh5tN5kEQnJ/S58MY2pXt9ZkhIWc6mypbRflM9JLXBYKsgCtlm5mSVphMPd0
 94mndGeAv0l/X9YL7H735U6P6QjBVB8oUxO5ZKYcMgoQgk3TKc9Q9OqxlWDLwTWPRr++KnQbirZ
 UFLVPl/GpE91wvW407l/+08KE88PYrSPHcKTdEI23D3mKXDgI0X8BX/g5L4e8JSSEKYaGS+e9gd
 VOwurI8AdJDWIBuYeNw==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f9e3af cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8
 a=Jhyzjtp1HSYqCdt93m4A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspam-User: 
X-Rspamd-Queue-Id: 7FB1340007
X-Rspamd-Server: rspam06
X-Stat-Signature: 9j4jkeujrddxpbhej1gsh1k11kzu7j49
X-HE-Tag: 1777984453-468527
X-HE-Meta: U2FsdGVkX1+FXnlgI+9/BtdNNcGRLoxBKQ+EHXnfEv491qwP3LNpIu8OcHEJKOD3vLSrCBIDWte2cvHPwqNVxUKI7IMuWPaNupIV5FmmC1Okt8kA35AbvlDCe+1+xLyXGwlyCHN/7F6Bfe93uDMxTTcpHL/7FATeQWf7TkD0Dba+zcw+32+K8qFcKCaQId5eujcR+JxmolkP3z6ap6CvdVxbEDCd/rlktAdTZN1zM5j8JG8rld/mLiwdewbEaF6AUQoqCYvTp1BB7uMUzg1pkkoX+cm48i3b8cyrwVyGrCbCwDfg6Y+jPTX/ce9MiUUwgXwea8dvY3CX/YB/4dkQ3e7+xPq5wCEUhJtPrO5YdBI8dRJoD5/lCb+HSLsjec6tSX1k6JS569RcWzDkiPJwabD5Ph7+dB4DWEfaVYbJioytKT5Q22m5+W/9GNtoH/2ruBWZCB0cveo6gbQmXUJXdQoslVla31aT4o3ELq32WAy5C6kwfPqN1I1yXUoxrEXlXwQK3Ngnn2i9672UGbzQPaNVi3EwHb/ZDsP1aaGptwKv2bbKfiOM9Rb2QU+8n94ScltGZKtBsbPIPgIAt3pAJILD9dXLjqL80iTBDOVB0utaAbN21to3xCHuPha/ZO6AWmFHnmnH2KMeC3sZB38bc+xYK0OTWJp8eWzCs78/tJuRWaN1sA3pxTwDRtrn5ZSArg/PtMJFQivzXwd9+UQrUhPTXbN7fLPmYe9MBiKAknC0kqXT0GNRY9iVErJK9ItuCVvWnJidyaW9ypXQhL43CIdl2JSNjqh3KeedvbHzTDzbqFX9y0xXECP7Cm2lO5hZ+FieBC/aS/9K7VhFBzvVsR38GdB/FcMrcpLPn2dqEO9CvqrdA9qyI8vMCnn1iWv3RZMr+TihAJugt8CuIwxOZEa2KKWBXRqkF//fRPqcrODZRYrQgZUozTE7tnI42/Fr5vz/U4Miv4EFHuz2BPu
 G2Z/xxx1
 SdPuuL0n8+JKB85rVaen+CieGc82LkGy4wN52D3kg7KQ+gJP+kMCzgEW1aWQgtvt7+1ACitxKV6y2W2xBnmdmkcqln5FpCfwh7Rpf2zWdn1n+dMO5HxlSV6GYw4HPuJ7YFqiBWZHU15t9EaauUobOMqEseRJxJ06Vky5KiSd+u6kdSt00rIaGgWFF0DqEZ4RKjIdAR0R67qAp3eKLsgvv4q2ouTnLTdNMUM9vsMFxC9XbxtK9i0tH1MPCtw+XRdCASxmz7M2nX3rzRAg2C5P6mRtMl6Q2ZyjciR2/
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
index e86880045158..79aef9b67645 100644
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
index 55554f80d930..a18b65749ce3 100644
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


