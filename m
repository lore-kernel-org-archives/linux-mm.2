Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 606E6D1953D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Jan 2026 15:07:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A3736B00A0; Tue, 27 Jan 2026 10:06:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 985026B00A1; Tue, 27 Jan 2026 10:06:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E7A06B00A2; Tue, 27 Jan 2026 10:06:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69D006B00A0
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 10:06:54 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2F0911401CC
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:54 +0000 (UTC)
X-FDA: 84378071148.23.3EDD4C6
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9F5B240015
	for <linux-mm@kvack.org>; Tue, 27 Jan 2026 15:06:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Fr558ciq;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769526411;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=jLRo5dWQOH/PXS2/HPYSVLJpM/ceW9sy18PSHcPjkr4=;
	b=8KxhEcfxmhbgmm5mu7V380bqvlTZiizqlfrT8YdzXLpA1gHuHfdiiv/U5J8Ssi3eru/dkV
	cVO3ZLZJ6gBRQKPCZ+cSLOzwssYt6mUkXbfCfxQmMbWR0NtJmmUFk61AwIPZKhk4Wpgar8
	iEdJ1k1x+tjqaQ+9u/DaUL9A048bKXE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=Fr558ciq;
	spf=pass (imf11.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769526411; a=rsa-sha256;
	cv=none;
	b=Igz5bd3PBe+0v0YPIu6fI7UQwDYUhtiYhaVC+g5AvW3qrNuUKcfNdm7GTKu4biJkiWh4qw
	tOmF2/Kk4TiRnCP33KQb38r9cdV1xIaxx0sL+byUbfnGYKC5xhjf8MlZxry3Cyl3eN6wN5
	KmN+DFVVkhpNQQLiDDNQF8ZB6/DWFu8=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60R53102015526;
	Tue, 27 Jan 2026 15:06:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=jLRo5dWQOH/PXS2/HPYSVLJpM/ceW9sy18PSHcPjk
	r4=; b=Fr558ciqPqwWIGFX1x0Mzd3ZFIKBntnf1/Xcz5N6In7QPtx9ylxFv6D9o
	cK4J2JP5Y8JzHPArHbw/BcJPyDpGKgDJSOY5FfBqcnMXb0iEiDQyn33BQWVoMjvh
	EkNVbsap+UYsom4RG7FoT3dxuItFFlTOTRLy9X69fBQbtuWt20KUGWckx/P+YkUG
	trGPNzSX3qeb7fRPGQ6BhXb+Xg1Eos/Gr3rjUsC3g1/ABq77Unbao/Qb3JDT1irV
	UgYQ0wMYSXqNgkISNRjPCL7lzeC6hm1nHEifZ7hGe+AnnMz3N8GVPUjTGGQ1MtgB
	qmqN/IlZeDjNbu/lYKQHVNQ/fGPzA==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr646q9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:02 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60REknqZ027971;
	Tue, 27 Jan 2026 15:06:01 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnr646q4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:01 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60REgU5d023624;
	Tue, 27 Jan 2026 15:06:00 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bwamjrwhn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 27 Jan 2026 15:06:00 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60RF5uQK27328946
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Jan 2026 15:05:57 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D065E2004D;
	Tue, 27 Jan 2026 15:05:56 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6A19020049;
	Tue, 27 Jan 2026 15:05:56 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 27 Jan 2026 15:05:56 +0000 (GMT)
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
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v13 00/18] unwind_deferred: Implement sframe handling
Date: Tue, 27 Jan 2026 16:05:35 +0100
Message-ID: <20260127150554.2760964-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI3MDEyMSBTYWx0ZWRfX7qcpMQXHZrCz
 PJDHpcN9CMWtPiFxoQ2uYjYvStMx/x7IrXGTbCzzJxlJISHpQPpQTaIRatPScBGb25OmQBDISKl
 ZsJvW1BCfmWS/59bh65URFDXa1xFDfigc5VBrLzZ7voV7PuzqQypCXGyKPUhuvfWD1HUXKGIp2X
 ZPNx6uco2W3q4Wi33j2IM1A2EWuFC8ZHKL+dUxNcwNSpHuOgcbxR/PVqUVW2nAykQnNj/XEqpOz
 o/x5WEKMZNo2ZQDSp02A1eXMgdJzih2kpuoQTbomsesKZsez1YCdF+f5/0ZijV/GBz6NV5yS0Wy
 Z6Qcm/XGcq3mxx3tPhhEl6EFthgEzuG4yfmhSNEo1W7toPF2YdHuHll+Zo3n+FaJy+2F0O3TaTl
 zUFxPHi57PayA0Ae7vP5x8uKIiNN/XxVSUalmVi182X6osY4Di+51NWjl4hMbtck9Xs2uJhiPvn
 3WHYzx3MCiRJ4WzAxng==
X-Proofpoint-GUID: Cnghv0JLFjVoOT4Cw5u3lEHG0lpNgECq
X-Proofpoint-ORIG-GUID: lk9wg6AvcZr5GoAnEkF26dxZ3DFbx60e
X-Authority-Analysis: v=2.4 cv=X+Vf6WTe c=1 sm=1 tr=0 ts=6978d45a cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8
 a=98J7bzRMxkTV7QTXyM4A:9 a=ul9cdbp4aOFLsgKbc677:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-27_03,2026-01-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 suspectscore=0 impostorscore=0 lowpriorityscore=0
 clxscore=1011 spamscore=0 adultscore=0 malwarescore=0 bulkscore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2601270121
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 9F5B240015
X-Stat-Signature: 89rt4rpoqtiz3mg4pnr55eghnzi58wgq
X-Rspam-User: 
X-HE-Tag: 1769526411-841990
X-HE-Meta: U2FsdGVkX1/RJbSOJ8lHMmsWAD70m1q536dMOykpwagBw6wu8kfZqcEl6UEtdJzx44JvP93OPFKSULuRa8l/Oj6DFcA3g4jwzbMXTn0YChLnIInr1y22MxNN0ktgMtJuPH0zMajzrj3IAwNkokxWF+7LgsLNOJQAuWzR07N5YUHywh8+q45OQJ7PVw/4Go2JnEBi2pXyjlQQSzrA7wIhJjS3dhr9V+Qfw83ItLrbEEyHvqbEt2ySOWd/0LAGOBcB+ogf2nKQhuuXozyeHrzBrzVFAmfNbJms4HTdKYJ3Z4g2xz57XA2jspEvl9lKasse5nk1kf3hxG+lgDgZkCD1U7JvkTRR19akdNsC1H7TkuSfd2w53mkQ6T5DNClGWrLnC2fKZTGyS8uqCcRNXEXGWzuJOg/bWidYqs/EaAuUgJ7YUMKyDpf6iZ0UloMsVbQ/aUD5L04wCRYsnUuJ1hJEh9oLEUf4GFwtIczCb+YjDKg58qutTRQrye3O604NPJkz4kVchaics6xanhft6MmXbb6tlibWWGNZZNkJN4BKZEvyP/9cAuiy8HQ43jXqAR5IGVxn/OwuyCsoiQBc85eWwxcn6rsrCX1vkassvifOTDRFrFn7fDGcBY/Fb1lr3lKStY47vas8soS7Ubuphcjw/PzRG1uT3y44WlNZ04fVTX8AarFayevjUNHqR9SnS/NRKLhX3JXX6mrVaxSdTCIXHmAPBpltlD9pRJAmbXAuMrq6QtdtcHT9iGg2bR5vcbZTiMogkW4nyJmOQzH2Mqv8WMl9z5odMobMTqISh115IOUCIg0Hs7QJ0pZuJcVjzPBYOseyNvzL4dXU0yhX/SUBjtAB36UXmOId4PTuaGshGDbwNW/XYYYqy2z30BTBqtXGs17cmWdKniW7CEA//F9x3ykASJVgp4IkfU0f+pPg9qXD1GJ9siuEI9b6umHgh+2YozoIBML2iEPlKLPk08m
 2Y/g8TMv
 /R+1O3ie8pf3OfD2KjnPCKpGn8yNxAEgSM3mGeUaNEQR35RfbZmgFbk0nq+8ir9FulR5KwAQOIoaa2QYLK+AkQ6XC7KEFQrZ/mQ+wehNLa6+1oq3ZC3q4Zo/wPsxdm+DPOmqlsC4SPQVGPWQT+A+4gZyOW/qL8DiuVgAsKEoJKeMIKwb+N8bVDDSVMAAbKeaFnwDxa03yTpCyljs2fu3tt/0SdBPqtgPuie/nebxvFiHFvaZv2Hmw8lQ+AiT9a7E7SYUQmeDpE0GEiu74Ttd1iuqZj+AQoXvx60MYhCQfZCLrbGJt6UjeuJ7/Q/lt58NLg605weHWuB1rvy4xTqbYjQorXwcFo8JqrcCgsJ9+0OsvzJabW8ehCLW8XZXBKQaHRgJaZvfC9CmDaE4a2/80h3WVDQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
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


This series applies on top of the tip perf/core branch:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  perf/core

The to be stack-traced user space programs (and libraries) need to be
built with the recent SFrame stack trace information format V3, as
generated by the upcoming binutils 2.46 with assembler option --gsframe.
It can be built from source from the binutils-2_46-branch branch:

  git://sourceware.org/git/binutils-gdb.git  binutils-2_46-branch

Namhyung Kim's related perf tools deferred callchain support can be used
for testing ("perf record --call-graph fp,defer" and "perf report/script").


Changes since v12 (see patch notes for details):
- Rebase on tip perf/core branch (d55c571e4333).
- Add support for SFrame V3, including its new flexible FDEs.  SFrame V2
  is not supported.

Changes since v11 (see patch notes for details):
- Rebase on tip master branch (f8fdee44bf2f) with Namhyung Kim's
  perf/defer-callchain-v4 branch merged on top.
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

Changes since v10:
- Support for SFrame V2 PC-relative FDE function start address.
- Support for SFrame V2 representing RA undefined as indication for
  outermost frames.


Patches 1, 4, 11, and 17 have been updated to exclusively support the
latest SFrame V3 stack trace information format, that is generated by
the upcoming binutils 2.46 release.  Old SFrame V2 sections get rejected
with dynamic debug message "bad/unsupported sframe header".

Patches 7 and 8 add support to unwind user (sframe) for outermost frames.

Patches 12-15 add support to unwind user (sframe) for the new SFrame V3
flexible FDEs.

Patch 16 improves the performance of searching the SFrame FRE for an IP.

Regards,
Jens


Jens Remus (7):
  unwind_user: Stop when reaching an outermost frame
  unwind_user/sframe: Add support for outermost frame indication
  unwind_user: Enable archs that pass RA in a register
  unwind_user: Flexible FP/RA recovery rules
  unwind_user: Flexible CFA recovery rules
  unwind_user/sframe: Add support for SFrame V3 flexible FDEs
  unwind_user/sframe: Separate reading of FRE from reading of FRE data
    words

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

 MAINTAINERS                               |   1 +
 arch/Kconfig                              |  23 +
 arch/x86/Kconfig                          |   1 +
 arch/x86/include/asm/mmu.h                |   2 +-
 arch/x86/include/asm/uaccess.h            |  39 +-
 arch/x86/include/asm/unwind_user.h        |  69 +-
 arch/x86/include/asm/unwind_user_sframe.h |  12 +
 fs/binfmt_elf.c                           |  48 +-
 include/linux/mm_types.h                  |   3 +
 include/linux/sframe.h                    |  60 ++
 include/linux/unwind_user.h               |  18 +
 include/linux/unwind_user_types.h         |  46 +-
 include/uapi/linux/elf.h                  |   1 +
 include/uapi/linux/prctl.h                |   6 +-
 kernel/fork.c                             |  10 +
 kernel/sys.c                              |   9 +
 kernel/unwind/Makefile                    |   3 +-
 kernel/unwind/sframe.c                    | 840 ++++++++++++++++++++++
 kernel/unwind/sframe.h                    |  87 +++
 kernel/unwind/sframe_debug.h              |  68 ++
 kernel/unwind/user.c                      | 105 ++-
 mm/init-mm.c                              |   2 +
 22 files changed, 1414 insertions(+), 39 deletions(-)
 create mode 100644 arch/x86/include/asm/unwind_user_sframe.h
 create mode 100644 include/linux/sframe.h
 create mode 100644 kernel/unwind/sframe.c
 create mode 100644 kernel/unwind/sframe.h
 create mode 100644 kernel/unwind/sframe_debug.h

-- 
2.51.0


