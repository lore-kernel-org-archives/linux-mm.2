Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07AB9D6100B
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:28:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F816B0096; Thu, 29 Jan 2026 06:28:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84EAA6B0095; Thu, 29 Jan 2026 06:28:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 735096B0096; Thu, 29 Jan 2026 06:28:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5350B6B0093
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:28:09 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id ECF9B140984
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:08 +0000 (UTC)
X-FDA: 84384777456.08.5B7DE23
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf05.hostedemail.com (Postfix) with ESMTP id 821CB100007
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:06 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="qjVdr/ie";
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769686086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+WS183iDiP/nMxD+iOR/QQgvkFj3ADjsGmYllgfRw9Y=;
	b=OvsPVgUdcuW0CqUNIs0lyxN/M7awfWtzoyD2FVjG3gMP0s1uEBt/mrlCxoP1N7yfWnF3yg
	AHG4kCztfTAxmg1rpzf8BiO2P6jcsZ/gLvACXNkuCAbQS5KYZG088yXNTmdheEx+fuRuwY
	5DJPrhpGOyu2kE9ljBWMZXOeW8imKK0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="qjVdr/ie";
	spf=pass (imf05.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769686086; a=rsa-sha256;
	cv=none;
	b=IEWXsQQsr83qd4gVk7d7jEPFnVByudYyZ6dpg6R3akdG7AWSjDh/wFdX6xFAlfwCDn0iSd
	C3vk6/q65STzQlJIL1VLh3EAE0xLGSbHfHcQSn3nje6UChCWAncgU/4GpWO30JITIxBpvr
	xSOYNz3uwiQTVyG7uU1JbeSOaqvJ1jo=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60SLbExu029402;
	Thu, 29 Jan 2026 11:27:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=pp1; bh=+WS183iDiP/nMxD+i
	OR/QQgvkFj3ADjsGmYllgfRw9Y=; b=qjVdr/ieMEvTG7Y7/Q5cjxhJguSg/X4UP
	D5EGulcCJIx9eIkolk408Yk58ryP9zCiUgWdEXlXS5wDejRHTVpRGQfT2iqHRgHz
	U6tx8mh1Nhf2VGrNN7es7w2op81AoVmniC9DLTNIWp9U/XdUCKlRkrk1idMJy+aY
	OTeMtYwS++c9zzS9TbdilrzdvmboR4Psd4t6MD8cWLox2qB89xlCR4x6FTK+N16q
	cj/6th7EiR2hy3ps8YwD+Pja8omhpjNVXY3ZdwpoXwHoCIPZ92jaJZ9adLOaDlhr
	0yCxiSsIyzayTLGwyeAxjb0blSWNXG3vIHlU+sdCuMsplaWcaNYNw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt80b0k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:39 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60TBRc5F029845;
	Thu, 29 Jan 2026 11:27:38 GMT
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt80b0b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:38 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60T7uk1h019733;
	Thu, 29 Jan 2026 11:27:37 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4bw9dn9ed6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:37 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60TBRWj950790804
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 11:27:32 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 2CE0E2004D;
	Thu, 29 Jan 2026 11:27:32 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 923822004E;
	Thu, 29 Jan 2026 11:27:31 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 29 Jan 2026 11:27:31 +0000 (GMT)
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
Subject: [PATCH v6 6/6] x86/vdso: Enable sframe generation in VDSO
Date: Thu, 29 Jan 2026 12:27:26 +0100
Message-ID: <20260129112726.892340-7-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260129112726.892340-1-jremus@linux.ibm.com>
References: <20260129112726.892340-1-jremus@linux.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: uTa8eSSN46EPfpW7hKzrsKBZp5iZuGKI
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA3NiBTYWx0ZWRfX4mXlQtZtf/7S
 bTyrWr5bZvPKSOhpHdcVVeu9bA0g3qsJ5+tNJ8wN/aOAje5GeCzyj3aqizAui5ueSqhPBY/QdiS
 TwqsijJymF9GLe1vW9u/GTfioPlaXsZqEjKTn2P262/LRpFbljL+Lbz6dU5dHRMebbACL6Rb16z
 /7Sa6GLU12zR1z/ImcM/hsliI3PurGu1PJY3lnOyJQK9u+va3a73sJkRxqwPUpPNbvUWpzBY0HG
 NPQGe5V3fgwjX77iyaXCqHILY5yCix4LWXHspv2a8EikAnkkG9LKb0bvVz0QTimlk6B9QWuy1a4
 sSKOhiF4bL2QcbYvgJMQ8yOEiBsORTiFP7iYw6t8TE0v3tlMaRpt4R4n4LbHlVRKgSMy7+KOY+c
 /1mVmXXBrnrs3k4f21TeclxNH6tgMb7pxLTYgksd9iOwGo0GW4vFBbAQ61hmYzucCoRWCVOFl6e
 2TSjOmAeI5YnaLPZr0w==
X-Authority-Analysis: v=2.4 cv=Zs3g6t7G c=1 sm=1 tr=0 ts=697b442b cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=6um0ROA3cFbXW2b5GMEA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: PsbsJ1Wq2W19p2SJZWUmsrKQMcbbGAFf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601290076
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 821CB100007
X-Stat-Signature: yuknh6th3pdg384xrho4f8tusfxrj961
X-Rspam-User: 
X-HE-Tag: 1769686086-675246
X-HE-Meta: U2FsdGVkX1/DjJ2ERRdvp6fiOBYxEH/RHr/A9VHLjqH0rCddQdR3IoCGWkf9m+Suy7CIkJ2+f1nUUdvkSgG9fzib2oxEJqx42p2BvcpxZ7vzTpUjALWkca1VF5qGpDk4WTHKjy/e2U54p3ZDpbthyYXTEdIM2DEvE74JM9rw2sgux+Qfmwmp5W0PV2YnojKexaJgwkLoRnSU9AoMAJBKY6exLGXwdveYt6xoqpziafRq4vHL/0R3ZXiANVr3n4yMtsmh45+Y5f3JomfU5UddrQkYwvyDm1GJbODtO23KAxkU5y1dsOyk+BuvEL17o4+cDDB9XRfH7j3kcOwq4cgAWVZJQUnaejZNzCAKum55EqDoi8Zfn8R12aXnB+Vm8QNVOBVa95PJPqRyGmKpgBhaaYiWB+wMNAdjl08H1EyApv8EX9zY8VNN2bSDuSQcVNqdblAOwGYL7oAwSa1+Vm9kYmF/UyB2uDI/u3S/vDL3pO7CwhclPKWwyr9TmuRuRdkPapuBS0UH70VWRq9zmKMuBUfq690d3MtE1oQ4qk0ALfsinfqfsDrDTx/EQLfluoXTWfjCkwQQD0BmsxyuiZdIv82Fnw3iDGhLUg7FXsKvepwgDi8pOoYIhR6msvBvTkDr2ZXO0/aqGsiNRG0SSOKvL+EMEJA8340sZuZBTBnwthjgcN5q7YNoibeGN32LrtYn5edCl32RdhaLbg7VAAjBd9946DeSQ19Q/Nq2bxCnzfNUmrM0p9hYBYYuxP96vnTT8BX54ko5p8mQG99A+O8sgXC1kHMqm4nOq6MSJj7OgHugK7zUJW4+Hb3dpgXsHKDEsypDaJyxHehdXV4Mn5P98KE+z9oMZqih/LIZGb+t+dIuQ3i1jgnl1+sx4KZ9HfqkaEuT8CpNTkQiANnuVC3wQSo3LaAolmNkWtp7LRBX227RWeLgIhnviibtYoGqyYvKV5yrRfhDvYqklpiiZNx
 SlabaWgg
 avsJRYSGA8OBoa9e06EbJ+PZrMR+wTZi0Lt8EjJeKoUbMLSYZUEfK9u7pQvdC+DqYP8hoxU34g+MY9MbJmTZLRQfOXO8etREgA81yZaHrXe72Q0IsKnlfCk89ELpIsZrG8fyrRoaGB02pFZcmWJXLzoRnlZc31v6eb5XB5a09GY5JidGfUX5CRSA7QKIeJSJCv7+eKxB/koc5YbA9+rDJPpUvsvZ1srHAdNuRRsQaxvjndWYeYR7jLd1rwGtH/lMKCCOHxIhvWi6TccQpTKUWtcbjlIh2nFxkinCd
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
 arch/Kconfig                          |  7 +++++++
 arch/x86/entry/vdso/Makefile          | 10 +++++++---
 arch/x86/entry/vdso/vdso-layout.lds.S |  7 +++++++
 arch/x86/include/asm/dwarf2.h         |  5 ++++-
 4 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/arch/Kconfig b/arch/Kconfig
index dcb553136e0c..b5b3a83072f7 100644
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
 
diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
index f247f5f5cb44..748e0a630e81 100644
--- a/arch/x86/entry/vdso/Makefile
+++ b/arch/x86/entry/vdso/Makefile
@@ -47,13 +47,17 @@ quiet_cmd_vdso2c = VDSO2C  $@
 $(obj)/vdso-image-%.c: $(obj)/vdso%.so.dbg $(obj)/vdso%.so $(obj)/vdso2c FORCE
 	$(call if_changed,vdso2c)
 
+ifeq ($(CONFIG_AS_SFRAME3),y)
+  SFRAME_CFLAGS := -Wa,--gsframe-3
+endif
+
 #
 # Don't omit frame pointers for ease of userspace debugging, but do
 # optimize sibling calls.
 #
 CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
        $(filter -g%,$(KBUILD_CFLAGS)) -fno-stack-protector \
-       -fno-omit-frame-pointer -foptimize-sibling-calls \
+       -fno-omit-frame-pointer $(SFRAME_CFLAGS) -foptimize-sibling-calls \
        -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
 
 ifdef CONFIG_MITIGATION_RETPOLINE
@@ -63,7 +67,7 @@ endif
 endif
 
 $(vobjs): KBUILD_CFLAGS := $(filter-out $(PADDING_CFLAGS) $(CC_FLAGS_LTO) $(CC_FLAGS_CFI) $(RANDSTRUCT_CFLAGS) $(KSTACK_ERASE_CFLAGS) $(GCC_PLUGINS_CFLAGS) $(RETPOLINE_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
-$(vobjs): KBUILD_AFLAGS += -DBUILD_VDSO
+$(vobjs): KBUILD_AFLAGS += -DBUILD_VDSO $(SFRAME_CFLAGS)
 
 #
 # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
@@ -104,7 +108,7 @@ $(obj)/%-x32.o: $(obj)/%.o FORCE
 
 targets += vdsox32.lds $(vobjx32s-y)
 
-$(obj)/%.so: OBJCOPYFLAGS := -S --remove-section __ex_table
+$(obj)/%.so: OBJCOPYFLAGS := -g --remove-section __ex_table
 $(obj)/%.so: $(obj)/%.so.dbg FORCE
 	$(call if_changed,objcopy)
 
diff --git a/arch/x86/entry/vdso/vdso-layout.lds.S b/arch/x86/entry/vdso/vdso-layout.lds.S
index 60747905de2b..acdc55435d99 100644
--- a/arch/x86/entry/vdso/vdso-layout.lds.S
+++ b/arch/x86/entry/vdso/vdso-layout.lds.S
@@ -59,6 +59,9 @@ SECTIONS
 	.eh_frame_hdr	: { *(.eh_frame_hdr) }		:text	:eh_frame_hdr
 	.eh_frame	: { KEEP (*(.eh_frame)) }	:text
 
+#ifdef CONFIG_AS_SFRAME
+	.sframe		: { *(.sframe) }		:text	:sframe
+#endif
 
 	/*
 	 * Text is well-separated from actual data: there's plenty of
@@ -87,6 +90,7 @@ SECTIONS
  * Very old versions of ld do not recognize this name token; use the constant.
  */
 #define PT_GNU_EH_FRAME	0x6474e550
+#define PT_GNU_SFRAME	0x6474e554
 
 /*
  * We must supply the ELF program headers explicitly to get just one
@@ -98,4 +102,7 @@ PHDRS
 	dynamic		PT_DYNAMIC	FLAGS(4);		/* PF_R */
 	note		PT_NOTE		FLAGS(4);		/* PF_R */
 	eh_frame_hdr	PT_GNU_EH_FRAME;
+#ifdef CONFIG_AS_SFRAME
+	sframe		PT_GNU_SFRAME;
+#endif
 }
diff --git a/arch/x86/include/asm/dwarf2.h b/arch/x86/include/asm/dwarf2.h
index 65d958ef1178..ce294e6c9017 100644
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


