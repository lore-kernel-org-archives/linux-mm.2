Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 016DDCD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 11:05:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 624316B009E; Fri, 22 May 2026 07:05:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CD6C6B009F; Fri, 22 May 2026 07:05:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4958F6B00A0; Fri, 22 May 2026 07:05:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 339926B009E
	for <linux-mm@kvack.org>; Fri, 22 May 2026 07:05:23 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F3758C2C10
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:22 +0000 (UTC)
X-FDA: 84794774484.01.0CEA404
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf25.hostedemail.com (Postfix) with ESMTP id AB377A0012
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:05:20 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sEtmJyHE;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779447920; a=rsa-sha256;
	cv=none;
	b=tOp+ujmtT+IiX+TMbwIvZmG/rsseLhnIH5Pznv4cmNMNAm9Vsz+szwfRffYY1prYMozA1o
	TVxdy543ZiuT7OM7WksLmra88f4iTU7CNsIk5tgEIF61KrMTVLXJNhggvpyzwR/vGT1jq5
	Kq8pSCqag0NKsYee4GZkcfw2PlHrDT8=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=sEtmJyHE;
	spf=pass (imf25.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779447920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=r17k1R93k501Adh2XLghvooeGjUcdSZQ9KHd6Y4UasA=;
	b=29D7g8YJmrsNMDDjuPyERcz9nTdNfbUT96Pe3/K7IDsSQ82zQ2hmmIwgCBxiRJOfWO9KeI
	6XKZy1xLkbGm5yXbpdXADHp9MOWvuig73AJfAvTWWjtgYBlWbwVd6yT1nB2iiM5ZVOPksj
	4J7McJbxtaSWCLTqJQqyD//VaUQRb4g=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64M9YQxS620482;
	Fri, 22 May 2026 11:04:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=r17k1R93k501Adh2X
	LghvooeGjUcdSZQ9KHd6Y4UasA=; b=sEtmJyHEdwlDWMV4TMGeI2wVKiQHMHJqI
	ROdVD+HiSdtU3QmlMAxWUYlyP4P35wl5Wrqe4WPq7HauQmA34pSk+PMQ+k1oWZ2U
	cw6u7Fx6NnWwswLwA2zM/DI/V+SWpcHLdhjUtn24ZWLsnQWTcmlfRWPDzK/+Un0U
	UTUQRCypq9MN5/hqI0rz3asJeIWU/UtfHBSqNM2gIl6oaMNJr0jkXGOyHfXhT4Tz
	+ei/JU7WCTxdyOaoCjmwsuN9H2kCnTWqrxXYZuWgiz6I0oEE2qMouh7gj0U/x9yx
	B3c7R6NGWnr6PshspD/KIc2Hi/YxV+n9IY+tiUNkNevzyVVQ2XjlA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88t460-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:37 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64MAs8Pj023384;
	Fri, 22 May 2026 11:04:36 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4e754grbw2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 May 2026 11:04:36 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (smtpav02.fra02v.mail.ibm.com [10.20.54.101])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64MB4WvC61669734
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 22 May 2026 11:04:32 GMT
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8D0C020040;
	Fri, 22 May 2026 11:04:32 +0000 (GMT)
Received: from smtpav02.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 137BE20043;
	Fri, 22 May 2026 11:04:32 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav02.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri, 22 May 2026 11:04:32 +0000 (GMT)
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
Subject: [PATCH v11 6/6] x86/vdso: Enable sframe generation in VDSO
Date: Fri, 22 May 2026 13:04:27 +0200
Message-ID: <20260522110427.2816637-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260522110427.2816637-1-jremus@linux.ibm.com>
References: <20260522110427.2816637-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: jhDsby7YLn8nlUdCGX69kiiglFhmIZjh
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIyMDEwNiBTYWx0ZWRfX2UzR0jfABKCQ
 tXtFP3nO8uSJzYLHWrMU5WjnWFNFIvQNVGvfC5AQxPFg0o62BiVfxfFpJ7jet5+9Ek5u4riOial
 0IaCZNVM6Mui/2XUr9cbbMx4BanDvjVuyf2CCuR1RbzROlCRwgDwlMVrdKdaAXkBUPStNX24d0S
 bcwoSEh7Z0Ur9zVfJjXjJne9yDNGW8n6TiSEMuI956+yDzkXeB/irGJLDjlf8xGWCeB7VOA2FiQ
 zFMyiyFP91H26QF2lTe2ERXbxZ4iCVCtIjX3HY1ODf83BEYdfnlu2Hn3NaZB3D8jTkAvWKd2mJ8
 5rtyD4qb2p+jBoOTRzJ8pCYhYvvZMFbKxgqkxPBLsV7CtIBn4AK6GnM0LgtHgaqr94SRxlkhWWm
 oPl3mDV+/Yisa4i4XUoRJVt6nn4tvi/lJS0Oz2hCEo7KUJoh1zMCbn1ajwKDkYSMzXhhkTiCpBp
 LcZlwb0JdlHyJGtRxyg==
X-Proofpoint-GUID: YaFHd8Qqj83VcLHjtIm-Nn75DtGeqRK7
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a103845 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8
 a=Jhyzjtp1HSYqCdt93m4A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-22_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605220106
X-Rspam-User: 
X-Rspamd-Queue-Id: AB377A0012
X-Rspamd-Server: rspam03
X-Stat-Signature: ur53ruowkiy854g18bc9taig4tgngnwg
X-HE-Tag: 1779447920-798095
X-HE-Meta: U2FsdGVkX19iukoARC+z1zGEIlw7KRyTGFcQA7sa/ixeq2eT+GLkn5bLMc5fLUo9Nlo1AxuFBEhHRyLLCUgfcqm2pfzDGwjRxZ21laY1IEnIJNncv2ydap6Up36V8HHYfLmf6VortF4xDmm1nJHQYdrDsEC0H4HhZ5K8vrWg2QdDjzrv2p8I03/bcozpFJsM+gOHjY7pnsVu5c1Qme5eldkeYIMXR3DRXjcL2zdCdO+exjdX6XV/uk4bZbNtPQ8kpHuo/m8yWqdbqV+GX+43bsuhIEIZ0CFJeyN4jTp03twZy75mSxIxXMJo2Lh8w1qtkfAR4CrHWxXFNlsTAxQ6MBv/Y4eg46TO6WsfvKoOft/sN9N2eo1C1L5oQxeA92BQmYpg44vl7wYNHhAIk7YDGs011Ds5flM+4wZPDG1jXx11OKIe/7l03BSE0LwXghNjG3bI7TCPU3eZcSi5BFCV/nFzUEu8GvEoT4VFbH+kB3LsUnuhl5b6fY8hUZSbUHHrG69NPQIsV6PwhtCCPpxVAKeR5cDk79TwomwyM4EDxLCaKm9z9wIg0PaHdtn1RssHrvKD12+ICOK8gV3xGgVZv5xEHRislXo5sXbm/d0MEB+hafH0FeVfLnF/o6n/lv9m55iUpnHQa9TJKJHpLBXKfFJMmtnbb1eGHDETlpiSyCY56yxzCSKvFdbu9RW+8WQyfTgvJePQOgeIezdmdPxhCqkvm8Qk3s5zGy03KVCDQpav2ZSG1vOTKtDTDavyEpltfXZTIclDO0/N+E5+U2Z2p3+IHTurU3mADtKf+OHrMnhgfbLur7E8bciaz0p98CLubGrOoGCet8AQZ93PCXRRrtlV8QHpxrlMayoXWoumAWOhOw9Uc7VG3igk02kRZaV4D+Ae5mSRw7Qo95zm3bmRlMII6o7+5tdZdmwOrxdNiFuGHA4pxcPGLZnqiX/yzs4xwZkbK2zcLkv3QmkUF3m
 /3+4uuOJ
 u3pjxiLi7tPLowtsKXK5WPJcJatMomyh4Nn8rWjv4CQqjrj5eIsK1vtLiU/bfbQeOO1SjKSmHgUmom/IlJj09SJgbgNQfM0rdONhxpe6OuxENhZNBE3PO5a9O58wvhHTfK3hBBP7y7L8i0+IYpVsuSes5FlOOpI3178f2OhNKJybQKVGMXWLpKYjrBlorev1iCkP2OVV1UhadY9E13jLDJ6u0TbiEjGhOnBA9tlRfMlURUICtz8LX9mkTYTYZXC2nI8ybA9lI/auAtOjvTyLRveORGs9IFo9VICzeG+xroevcIilCR+/VeHkexjI3aQzvJkoGwQgD2Mgn2r32/MjTfYNyOJaIA5Htjhg6Ej2CUlM5oWmi6qfmvPMeAQ==
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


