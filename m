Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42677CD5BAA
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 15:41:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57C3F6B00E9; Wed, 20 May 2026 11:40:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553F16B00EA; Wed, 20 May 2026 11:40:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 443196B00EC; Wed, 20 May 2026 11:40:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2E8FB6B00E9
	for <linux-mm@kvack.org>; Wed, 20 May 2026 11:40:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E60C21C0F98
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:49 +0000 (UTC)
X-FDA: 84788211018.05.8DD603F
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf21.hostedemail.com (Postfix) with ESMTP id A663A1C0007
	for <linux-mm@kvack.org>; Wed, 20 May 2026 15:40:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TTkErN6f;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779291647; a=rsa-sha256;
	cv=none;
	b=Hza7GS6zQ4rDidT3XyynN2eC3uUIFGB2iB1DJ/ikTIHavOGuk403fNHCe0cpIW4vIHcglw
	H64XIMcQF1kE//ybeEXn/9jpJveYNzOGaShooWnb78mzpy/7P4HeoLgQjN9pE5O0miUbyP
	0bxryVJGhiIbQUgtSlnpFngECs5dUx0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=TTkErN6f;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf21.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779291647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lwjdtCuitwD1sxxOwVoASWkQT0ZkabubPfjDN4g6DrU=;
	b=JjmscR4a8aRy8KZ9Xnv211Ta/8qT3cGMnBxD/d+uWQVLFFLfONu5DcJvoAoQsA3FJMJfDs
	0egpb8ljP90lOgzxLDvGMkG3RNcbLiY3m4NXrTo8ilDYvnYFSDlJjuNgbF6KDrTksxGx0G
	DfUwLy/YWwq3Zh6Z4eMXYrv1Vd+D0qs=
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KCUSjP007259;
	Wed, 20 May 2026 15:40:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=lwjdtCuitwD1sxxOwVoASWkQT0ZkabubPfjDN4g6D
	rU=; b=TTkErN6f3AA2mgWmrfUbUsFSup3+BxG/oXdqz4DGeQUV6oQ2xR0ERaJm1
	VK3WylYUJZXm+9MUg2jdesSTZs2qGky3RFX3cDH0LLYPE4aYEXyfd0kIYbS5cjqy
	RfOwqCeavPUZYnhaKBBEI14lL+xdomLbyjOmhL7QZF/XjkF8ZoqV8wYmErKNQ5Jt
	Tf+Kx3gdaGi8xiSCJl8Rkm78qNscDxOPk1ve+Fq2SWw29vWocIU8jJ62qpvggAXH
	I2tLBIOcYb8qJsAbzbZR1AJzo6N3zcdp3cdQl3o6nZBNCzNDEehmA06+YnSVhaDL
	U00tLHXysEv66d5U+Y3eREEgEiGJQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h88htf8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:12 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64KFd77e012018;
	Wed, 20 May 2026 15:40:11 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e74dhqwdt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 20 May 2026 15:40:11 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64KFe7Ad44892602
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 20 May 2026 15:40:07 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 52B8D20043;
	Wed, 20 May 2026 15:40:07 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B821D20040;
	Wed, 20 May 2026 15:40:06 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 20 May 2026 15:40:06 +0000 (GMT)
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
        Kees Cook <kees@kernel.org>, Sam James <sam@gentoo.org>
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
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v15 00/20] unwind_deferred: Implement sframe handling
Date: Wed, 20 May 2026 17:39:44 +0200
Message-ID: <20260520154004.3845823-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: pv_sVuaM7P7V8B1VIaVuys3tEZhZHZ-a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDE1MSBTYWx0ZWRfX0fKO8uQ1c5hd
 kEp3Vn++iawAOleY1ZdnnzjnnlSAeDfBv26OyfmKpuWST2kRH0fJXpKj8X53PV29JavGjuvwUjB
 hS5qWMKtbNhIy0oWiVjnsIoZk1U/8dsy6kfr9t35qvcuzlWXhGlG8ECeQdeJHgdQ0ljL5iAxulO
 9Hq5YTSjrawZ7hp8zZjBfq01bZ6qZPd2XsUZVgbz+uMd6Wq9eSjNxKQ+s9D2SNfY1n1eoaHmOG2
 o2CRq/gAyvkxbyr3mR1yUborrRuRn8Hom+xRR/yvfmu0JRzAZlOKami/zQ2wV14GgpvWTlHwe37
 dCcVjS5Icv/CquC8dW7qH4S9t+FJ9nmsY3x08+KRaNKO360Wl+wN4pF4TxN5NEZQjNR33rvQyOr
 JsXtpdc0DxgBhJ+r9Mje+jERepFiHhCCoTBaKF/Hxsez+7JjHUXlHu+hwAy595ljjbdYe005N+H
 sE09E7NJPOMg9+zxRvQ==
X-Proofpoint-GUID: jz6f7ZU_Z9DeN-lqP2jp0FAbGt0gyK0T
X-Authority-Analysis: v=2.4 cv=apyCzyZV c=1 sm=1 tr=0 ts=6a0dd5dc cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=V8glGbnc2Ofi9Qvn3v5h:22 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8
 a=abAiAxy3cSqj7G8NtIYA:9 a=ul9cdbp4aOFLsgKbc677:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-20_03,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 phishscore=0
 clxscore=1015 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200151
X-Stat-Signature: uyx9tq381qchrkrfsefcmyj8kpp691xt
X-Rspam-User: 
X-Rspamd-Queue-Id: A663A1C0007
X-Rspamd-Server: rspam07
X-HE-Tag: 1779291647-371929
X-HE-Meta: U2FsdGVkX1894nMSykbj7w6cowD5TD2AbG/ap21t9tjoMg3csyWthGrzgdi4fnek2wGUm2Gao0NnjTAIYQfCsxJx+S3u4RtflLL3yWsRFrj8ZlYLTFKfA3TNHs7el56gaKB5AxZiZBTk8g5DgPBjo/fUhpDmvhFD0JSaoTEsgSi3Wm+iv15dNGoapIx0jym37tvfocbNyNNoJ0cDKGiUvmV05e/zeVFn0o1fA6EOcrcjG9FPPfuxKSeJorFDEIsuF53s4bwHj4zbZoLUPN3Nj45K8XauaLQS0rVCY+qEjPc8NJebQ4uo/faqR4y1BrhvwixHPLuV4caaKrk+01o+gPGc6oWolRk3PmlQL7812ZTbyws8QFcrMP1THILNTOXr20lpxltOjXS/frgOjRbTV4QSHsxiEm7ufZmT/uRgEnz2W+6J0y8zfGr1YevbjZBFY1l1BdD0ZqISFJb0UNo0DD7bTf1Dp65NZE9ou/MuTHF4VIx5+4zDhpeC26iJuhIeK4RWEXFaOLCOoJnLZ5wfoecl3YyL36HkHbyNR7dZPbGrtmq+LtMQ9Ky5uLseapG733VW4zLgtTNWyCH53R4AwDBmlMQz6nVoemLRJ21WNLD0yEf42D41ameCR+OJdYFUBzLLLD7sTlibcMsIO/uC8n1gbhmzskIP4F5+Ux6loeXU5LomiSCga2KYsypSF7iFuqGnS875vrGhP7AsrK+Zepcd7m9A2sJuzf3rsidpxkwZTL87Kf48+fmaQl7gY6UaGuK7KT//6FnG4//7fX0IvZvuloiCDZZzQ8WewnXWy6nEsZe+hBOze1LmEKhlKFFx+pTKMuqdX6fXp6kcJSU1IeTYvD+YTHE6crLQkFPqqD9lMynsLZlZFH96nnNfrfsXDcPf2AslTwi8G2hjgn5ycQd2n5452nG2ue60NpmV2F1RmuVSFmpBg1bnml2R5IohZ9jeNklnkK5j181BLSF
 7p1wuhSn
 zVDbPxZzId/ECLJFzWjFSG1T9Gv9aC2n4BMxPZ6NepWXiN25ZoiXt9c1MFAXn2L55RuWIm1Bj/83De1FAJdxgwJPi9bkwfbON5u5qSBg07mWprYuZjGQFDyBU7jAMcMGJoAHyyThOaxv92+Vig+8/PlNhYL51+VHps5TUjY/NmRsMCZZqvvVTDZwzEt4wFt2mRJzB0MPqhtm4xkMi3SL24eVDF70JgicbzXNwiCFFboTTRuVmt5Xlk5dQmbhg+8Ls5nOV3jWGej6r2Uc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the implementation of parsing the SFrame V3 stack trace information
from an .sframe section in an ELF file.  It's a continuation of Josh's and
Steve's work that can be found here:

   https://lore.kernel.org/all/cover.1737511963.git.jpoimboe@kernel.org/
   https://lore.kernel.org/all/20250827201548.448472904@kernel.org/

Currently the only way to get a user space stack trace from a stack
walk (and not just copying large amount of user stack into the kernel
ring buffer) is to use frame pointers. This has a few issues. The biggest
one is that compiling frame pointers into every application and library
has been shown to cause performance overhead.

Another issue is that the format of the frames may not always be consistent
between different compilers and some architectures (s390) has no defined
format to do a reliable stack walk. The only way to perform user space
profiling on these architectures is to copy the user stack into the kernel
buffer.

SFrame [1] is now supported in binutils (x86-64, ARM64, and s390). There is
discussions going on about supporting SFrame in LLVM. SFrame acts more like
ORC, and lives in the ELF executable file as its own section. Like ORC it
has two tables where the first table is sorted by instruction pointers (IP)
and using the current IP and finding it's entry in the first table, it will
take you to the second table which will tell you where the return address
of the current function is located and then you can use that address to
look it up in the first table to find the return address of that function,
and so on. This performs a user space stack walk.

Now because the .sframe section lives in the ELF file it needs to be faulted
into memory when it is used. This means that walking the user space stack
requires being in a faultable context. As profilers like perf request a stack
trace in interrupt or NMI context, it cannot do the walking when it is
requested. Instead it must be deferred until it is safe to fault in user
space. One place this is known to be safe is when the task is about to return
back to user space.

This series makes the deferred unwind user code implement SFrame format V3
and enables it on x86-64.

[1]: https://sourceware.org/binutils/wiki/sframe


This series applies on top of v7.1-rc4 tag:

  git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git  v7.1-rc4

The to be stack-traced user space programs (and libraries) need to be
built with the recent SFrame stack trace information format V3, as
generated by binutils 2.46+ with assembler option --gsframe-3.

Namhyung Kim's related perf tools deferred callchain support can be used
for testing ("perf record --call-graph fp,defer" and "perf report/script").


Changes in v15 (see patch notes for details):
- Rebase on v7.1-rc4.
- New patch to duplicate registered .sframe section data on clone/fork.
- Address Sashiko AI review feedback:
  - Fix sframe end passed to mtree_insert_range().
  - Fix outermost frame (FRE without datawords) handling.
  - Use GFP_KERNEL_ACCOUNT instead of GFP_KERNEL.
  - Improve text/sframe section start/end validation.
  - Always use guard(srcu) when accessing struct sframe_section fields.
  - Validate FDE repetition size for PCTYPE_MASK FDEs to be non-zero to
    prevent division by zero.
  - Only add sframe for text that is PT_LOAD in addition to PF_X.
  - Use pr_debug_once() instead of WARN_ON_ONCE() to prevent user-
    triggered warning/panic.
  - Add support for SP/FP-based CFA recovery rules with
    dereferencing.
  - Reject FRE control word with reserved_p=1.
  - x86-64: Fail unwind_user_get_reg() if !user_64bit_mode().
- Validate FDE PC type for supported values (i.e. PCTYPE_INC or
  PCTYPE_MASK).
- Validate FDE function end against text end.
- Validate FDE's number of FREs to be less or equal to FDE's function
  size, as each FRE must cover at least one byte. (Indu)
- Validate FRE function offset against FDE repetition size
  for PCTYPE_MASK.
- Change type of struct sframe_fde_internal field fres_num to the one of
  struct sframe_fda_v3 field fres_num.
- Return RC of sframe_init_[cfa_]rule_data() if bad RC.
- Normalize error code usage (.sframe is removed for all but ENOENT):
  ENOENT: No sframe or no FDE for IP found
          (FDE found but no FRE found is EINVAL)
  EFAULT: Bad address
  EINVAL: Invalid input or sframe
- Build-time checks for config options:
  - 64BIT: SFrame V3 only supports 64-bit architectures.
  - HAVE_EFFICIENT_UNALIGNED_ACCESS: Unaligned access to 16/32-bit
    SFrame FRE fields and datawords using unsafe_get_user(). (Steven)
- Add pr_debug_once() when restoring CFA/FP/RA from an unsupported
  register number.

Changes in v14 (see patch notes for details):
- Rebase on v7.1-rc2.
- Correct SFRAME_V3_FDE_TYPE_MASK value.
- Fix FDE function start address check in __read_fde().
- Rename SFrame V3 definitions accoring to final specification. (Indu)
- Improve comments on why UNWIND_USER_RULE_CFA_OFFSET is not
  implemented. (Mark Rutland)
- Add/update/improve sframe debug messages.
- Add generic and arch-specific unwind_user.h to MAINTAINERS.
- Add arch-specific unwind_user_sframe.h to MAINTAINERS.

Changes in v13 (see patch notes for details):
- Add support for SFrame V3, including its new flexible FDEs.  SFrame V2
  is not supported.

Changes in v12 (see patch notes for details):
- Adjust to Peter's latest undwind user enhancements.
- Simplify logic by using an internal SFrame FDE representation, whose
  FDE function start address field is an address instead of a PC-relative
  offset (from FDE).
- Rename struct sframe_fre to sframe_fre_internal to align with
  struct sframe_fde_internal.
- Remove unused pt_regs from unwind_user_next_common() and its
  callers. (Peter)
- Simplify unwind_user_next_sframe(). (Peter)
- Fix a few checkpatch errors and warnings.
- Minor cleanups (e.g. move includes, fix indentation).

Changes in v11:
- Support for SFrame V2 PC-relative FDE function start address.
- Support for SFrame V2 representing RA undefined as indication for
  outermost frames.


Patch 1 (new in v14), as a preparatory cleanup, adds the generic and
arch-specific unwind_user.h to MAINTAINERS.

Patches 2, 5, 12, and 19 have been updated to exclusively support the
latest SFrame V3 stack trace information format, that is generated by
binutils 2.46+.  Old SFrame V2 sections get rejected with dynamic debug
message "bad/unsupported sframe header".

Patches 8 and 9 add support to unwind user (sframe) for outermost frames.

Patches 13-16 add support to unwind user (sframe) for the new SFrame V3
flexible FDEs.

Patch 17 improves the performance of searching the SFrame FRE for an IP.

Patch 18 (new in v15) duplicates registered .sframe section data on
clone/fork from the parent to the child process.

Patch 20 is for test purposes only and will get replaced by a new
syscall, that Steven is working on:
[RFC][PATCH] unwind: Add stacktrace_setup system call
https://lore.kernel.org/all/20260429114355.6c712e6a@gandalf.local.home/

Regards,
Jens


Jens Remus (9):
  unwind_user: Add generic and arch-specific headers to MAINTAINERS
  unwind_user: Stop when reaching an outermost frame
  unwind_user/sframe: Add support for outermost frame indication
  unwind_user: Enable archs that pass RA in a register
  unwind_user: Flexible FP/RA recovery rules
  unwind_user: Flexible CFA recovery rules
  unwind_user/sframe: Add support for SFrame V3 flexible FDEs
  unwind_user/sframe: Separate reading of FRE from reading of FRE data
    words
  unwind_user/sframe: Duplicate registered .sframe section data on
    clone/fork

Josh Poimboeuf (11):
  unwind_user/sframe: Add support for reading .sframe headers
  unwind_user/sframe: Store .sframe section data in per-mm maple tree
  x86/uaccess: Add unsafe_copy_from_user() implementation
  unwind_user/sframe: Add support for reading .sframe contents
  unwind_user/sframe: Detect .sframe sections in executables
  unwind_user/sframe: Wire up unwind_user to sframe
  unwind_user/sframe: Remove .sframe section on detected corruption
  unwind_user/sframe: Show file name in debug output
  unwind_user/sframe: Add .sframe validation option
  unwind_user/sframe/x86: Enable sframe unwinding on x86
  unwind_user/sframe: Add prctl() interface for registering .sframe
    sections

 MAINTAINERS                               |   4 +
 arch/Kconfig                              |  23 +
 arch/x86/Kconfig                          |   1 +
 arch/x86/include/asm/mmu.h                |   2 +-
 arch/x86/include/asm/uaccess.h            |  39 +-
 arch/x86/include/asm/unwind_user.h        |  74 +-
 arch/x86/include/asm/unwind_user_sframe.h |  12 +
 fs/binfmt_elf.c                           |  48 +-
 include/linux/mm_types.h                  |   3 +
 include/linux/sframe.h                    |  65 ++
 include/linux/unwind_user.h               |  20 +
 include/linux/unwind_user_types.h         |  50 +-
 include/uapi/linux/elf.h                  |   1 +
 include/uapi/linux/prctl.h                |   4 +
 kernel/fork.c                             |  10 +
 kernel/sys.c                              |   9 +
 kernel/unwind/Makefile                    |   3 +-
 kernel/unwind/sframe.c                    | 949 ++++++++++++++++++++++
 kernel/unwind/sframe.h                    |  88 ++
 kernel/unwind/sframe_debug.h              |  75 ++
 kernel/unwind/user.c                      | 133 ++-
 mm/init-mm.c                              |   2 +
 mm/mmap.c                                 |   9 +
 23 files changed, 1586 insertions(+), 38 deletions(-)
 create mode 100644 arch/x86/include/asm/unwind_user_sframe.h
 create mode 100644 include/linux/sframe.h
 create mode 100644 kernel/unwind/sframe.c
 create mode 100644 kernel/unwind/sframe.h
 create mode 100644 kernel/unwind/sframe_debug.h

-- 
2.51.0


