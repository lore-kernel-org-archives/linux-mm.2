Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 649FFCD5BB1
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:26:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935646B009D; Thu, 21 May 2026 10:26:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 899986B009E; Thu, 21 May 2026 10:26:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC786B009F; Thu, 21 May 2026 10:26:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B6FA6B009D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:26:19 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2303C1405E6
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:19 +0000 (UTC)
X-FDA: 84791652078.11.AAABA4C
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf11.hostedemail.com (Postfix) with ESMTP id CCF4F40007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:26:16 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FbEIrJlu;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779373577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CUDVPDhJAHMAsi2wcX+vNLrHzR8J5Vz+/d8Gdljsc8A=;
	b=au7EvDgUnZfGiU2FnuP7kSRtQNlMB0oWHhE9KuCNtOwa3Bq3kWVwwkX2VgOeOoGWsCYiKA
	/lVcsKkEK1nivjkh0hNjs59wR9318unWwGdrCvB871HbvdoeVq8qcBegR5onawxK4CmfBl
	fFsVFpYqZ7U+wgTWF2NOTzwFrnfrxJs=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=FbEIrJlu;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779373577; a=rsa-sha256;
	cv=none;
	b=YnPDS79BKrFR+iE248sHHKjPdE0aBH4nZ+StOUkb8hjQPsAF1et9u3QYpiNQTILZnsbjNg
	Ay7MSNX8bnbgMVNTZRakCEEhh46heIp8O4wzCOK3qjAdc86oZzx2y7bH6z1+xlzaYRSlg7
	ZpFHMsYug1VbfuxrO3pHxc4JStT3c6Y=
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64LDfhkg1497610;
	Thu, 21 May 2026 14:25:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=CUDVPDhJAHMAsi2wcX+vNLrHzR8J5Vz+/d8Gdljsc
	8A=; b=FbEIrJluDUiDCer7WB67fSUkQNoskITt8EJlWMTXqX+H5pu8kVrnAaCJ1
	93z6g3CgCc3xIRteqbO6wAP/h/rcIV4f6RLCtAmzPOwcwTtqQpq75Yn2UkEqYcW7
	xMykl9cqKeqIdTs8N5GI/WwtgB2M5mxGyMMiNEk2lVjsRYg4RoYQC9S0TIRJXMue
	GjSLyV6AtTmQ21rYRrRjjeInn0+24qzu3MmqYoEyIqdU6EtHyaEijKGI5hgvWlCH
	XAphyZGp9H1LmQf3FgaAOMREygpKAveTbDoAOXSNRVtBTRTbi/5ViIf+3iG/bYS7
	RK/hYmPgbNN5DJebUDXC8tHAHorEw==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4e6h9y7gqv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:54 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 64LEO6rI017123;
	Thu, 21 May 2026 14:25:53 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4e73wkcjca-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 21 May 2026 14:25:52 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 64LEPnpL55575020
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 May 2026 14:25:49 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1C2AC20049;
	Thu, 21 May 2026 14:25:49 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A9A6B20040;
	Thu, 21 May 2026 14:25:48 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 21 May 2026 14:25:48 +0000 (GMT)
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
Subject: [PATCH v16 00/20] unwind_deferred: Implement sframe handling
Date: Thu, 21 May 2026 16:25:26 +0200
Message-ID: <20260521142546.3908498-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIxMDE0MiBTYWx0ZWRfX95cPCc2g29UQ
 0gZiNDFsjKD/4QltvQJdJsnkulKtmBpQmfc/FByKlU5Ghjqjp6q9kgejFXVgtjJP2JrbqKi583k
 P4hsEy4rzLA2Otw50HY4imepVqo1u5EMisaTQ4KNfdtL3NsEJA9Kg3Nu4T8zroa2N7tyNWUZ30D
 KTAwT29kCyvepEY+/Oc75/nRkkrNEpPO7JesYLkT+YJSFU2ifhEz0DzwP0v3DS9BS1bplTAqRMO
 KFc5JDqcQRewnBNn7yoLtAdhXLG8e35Hkq3dyCOxZhajFC4OzrAO315lrsIbhqVUTEKq6Fuys6t
 3ZaE5lgy5FdtvywC43FzQ8BsLp+DKl/ZRbJl7xaJcwZTpuCgORCtfbh89OVodiWxRPP/YEQ35+5
 Hre3OF5H6eHvIR5u1uQZe5MUJO0eiRgcnJIzgIU/nG+HgGr5XK75NFOJzzRIXH+dU+4/pm4NCgZ
 oT8FR17FhG+V9mIG3og==
X-Authority-Analysis: v=2.4 cv=BNuDalQG c=1 sm=1 tr=0 ts=6a0f15f3 cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=iQ6ETzBq9ecOQQE5vZCe:22 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8
 a=j5PQ-GpHzejeWHZKa4kA:9 a=Xkwy1uZb78V45PHW:21 a=ul9cdbp4aOFLsgKbc677:22
X-Proofpoint-ORIG-GUID: iPuILesC9-8cLglg6SguK1qrTTqRb-v2
X-Proofpoint-GUID: QHo5dJ-v-fCtM23zRfGvtir4nk0djgcB
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-21_02,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 priorityscore=1501 malwarescore=0 impostorscore=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1015
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2605130000 definitions=main-2605210142
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CCF4F40007
X-Rspam-User: 
X-Stat-Signature: kcxcmcgte7a5dam46kuu7k5rjate5g1q
X-HE-Tag: 1779373576-421228
X-HE-Meta: U2FsdGVkX1+oyWl8mmO9I4fZ49M0krTfhUA3sw+VArt9IMcCqbOnGLTluDDVCBg7lpkj4MJEol82WiuyKWaAOXBv9BoD6V1mRDwMIEvAQHS94Cve6APRFa9aIr5jXqi4+EfER93wbboaRWV+lMB/qyNyM+gOzPjYhr4+pyTmpfNFvSHcBmuaplYJnpgyHdOQ7Ng2rI5gdMrtpiRKaFQuKGZNxaD4q0p0eBivnTk8cToD/bTJ5H3AaeH0XQ8GpREvCRY5tW6Qdzv9oLZQnLASBEOroRN6/RnYguc6ils9HYhwN/DmsXP06J17RoQAkHCbzS+jOPzgM/WJECNXjXf1J7/u1dUImAuecMuxVwmBEqelebm2XDX3luetksQ8GZLv4xoiufK5bodbsJqpe7Dp6K7noYAmOvDSSGE6VmgSa+s8Zs2UFGpQTb8ePF5tuTAzcQAtiwAuPFjFqiVvoZ1c0Sq9qcUNXMx2m9f7g3bBEVpFDqjSMhXA0ziwD1n39nALpjssm/fxeaHxJo2dRzU2TfF/4L+IUo2DN1329E5ZIZvIszWV+EnX3hllkHmRWHVmtTZioKXKhaWcj4nscKWPSQisbGAPRwjxfW0fbYog3Qu2O71vmzAfNjzeuRoLLHipQV5kI0JRefIH6NFanqaVU9HWG0muzbgJGlDOLgKBSr5rq2FGJFl1bxqWRJ8T6Iq28n359IxBeE6JOXjNd+gi3rdwS6GhMIC6EmMLY7kIiF1qzSQuTNLrcdf0lC1Tf1ItYN82GJAqzwAk18zAt1GyQ/vQCzX8xp/ptlFo7ff/GMroJ53WurHpu7yAQafziKbNDCb0L7e0+5hH2UlFdpey9RY4w8m0VOkcCzYRXulHppZ5tMbT7c1CaABUJU5FDDdwTGc+FB/j+wVMtgqaOp264yJnPMYFhwtH5NIA2zZLNHWvf2O/fF/vPkzDvzOmQQbH0xkLhWl5+RNdq5Qf/UM
 BQpdcWYT
 69nPEwBVRPgOLkUAGWNPPH1GlZ0dJnFGnCS5NMpGZC0kzc6GhC+wGxoLCtIfZyF9nDFCTyheyrVgkF9fNgrBCATSls/PWOf8EGhf3JFOSApKgor2Esw9xBgicEaw98rzuMlTOtLZqrwmIr19tocjvC1AEAYjdYTHmbygHMs9TyD5AHuMNF3jzhemQvRhp8JekmaSmu2DVZzu+Zksa45seeBWvx7HUU82tAtU8wH+RGBNHS7N1EpUhaMs+KeB/gu7/oRKv7ZCIeQiP/VGPMLudkOT/bkJRdiKfK0siq1wD4O37D8pgd5gmRwnCTVVdsXB0AW386qrt6U7xydBvS7MQ11n2zA==
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


Changes in v16 (see patch notes for details):
- Address Sashiko AI review feedback.
- Move SRCU definitions between patches.
- __read_fre(): Convert user read access to scope-based cleanup.
- sframe_validate_section(): Allow for a FDE[0] function start address
  of zero.
- sframe_validate_section(): Replace alternation between two FREs with
  simpler logic used for FDE and use a prev_ip_off.
- dup_mmap(): Drop unnecessary CONFIG_HAVE_UNWIND_USER_SFRAME #ifdefs.
- dup_mmap(): Call sframe_dup_mm() prior to arch_dup_mmap().

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
 kernel/unwind/sframe.c                    | 938 ++++++++++++++++++++++
 kernel/unwind/sframe.h                    |  88 ++
 kernel/unwind/sframe_debug.h              |  75 ++
 kernel/unwind/user.c                      | 133 ++-
 mm/init-mm.c                              |   2 +
 mm/mmap.c                                 |   5 +
 23 files changed, 1571 insertions(+), 38 deletions(-)
 create mode 100644 arch/x86/include/asm/unwind_user_sframe.h
 create mode 100644 include/linux/sframe.h
 create mode 100644 kernel/unwind/sframe.c
 create mode 100644 kernel/unwind/sframe.h
 create mode 100644 kernel/unwind/sframe_debug.h

-- 
2.51.0


