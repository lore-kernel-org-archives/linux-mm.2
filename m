Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF5FFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:18:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06A066B00A4; Tue,  5 May 2026 08:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F37026B00A3; Tue,  5 May 2026 08:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB1A26B00A4; Tue,  5 May 2026 08:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BE2E26B00A2
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:18:19 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7EEB18C705
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:19 +0000 (UTC)
X-FDA: 84733268718.25.28D9733
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3645420010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:18:17 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nclHLjg9;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=llT3Bhic9idyt3sPU6ZF0LwtwTZv8wZlRy0aUwi7kYg=;
	b=F/oHtqjKWBu0aESocyNvJJJAf3tVFchlYTT1OliVpJBzM6cU/fAp7/EOq7zdyuXEv/IE5b
	qLOn6mVBhrv6AUH+pOCZQxq1ElzYO6mOjRm8SbmjpDQBgWwygvSKpQhTkCR7V+bOSLRdpz
	MMD/u0dgerlQ1WTCiHIutJi1kIMxpek=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=nclHLjg9;
	spf=pass (imf13.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983497; a=rsa-sha256;
	cv=none;
	b=6w/gYfeUfArVSPFl7uepboP0u9zqk1NClqunGQBsqiADbpCO/Aos+Vjtxn2C2LMs5z70/A
	xuq3vzLWmzNmObcSSQkhpQz3PxAKSj0qW1IFGEQ2NljmJ78mqymRG50HJBp0F9j5k792Pf
	FfwsssGf23oF4TIshU1stuVM+VPfUVQ=
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 644M772W879334;
	Tue, 5 May 2026 12:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=llT3Bhic9idyt3sPU6ZF0LwtwTZv8wZlRy0aUwi7k
	Yg=; b=nclHLjg9YrZoEQ4MKRZANh07/iifQiV1UfKXHAgYmYParIpT5IzgJEYHb
	ElwDWLCTky0n/NYNRVbA6sJm9gQZy239+rtpN7hU5L1Wnvm13znOdv4Dy9TeCsz+
	fRZ6y9J/ChO+RB+Eq0sRAJ+f2kXTngNbhCCl/L93zzKQUOt4tmVRqjf61xM9aFrO
	T9PPJBdH7lG7aiH3Co6GWhfDqceNSRoDOCrPgdWji8CUw0Q+X7CRQzPVzIs2XcYU
	1Rk9dlYc+NfjqnJ78lk68tyE+8nd9MR1PGf0bQi4ZzrXJgO7ojIJCHll6nNVwYrn
	cpcxCb6KswkWYz5ydN/w+c/7+eAHQ==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9x4kg5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:26 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645C9jXD024681;
	Tue, 5 May 2026 12:17:25 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dww3h1epy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:17:25 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CHLLE30081558
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:17:21 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4B42F2004E;
	Tue,  5 May 2026 12:17:21 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCC2F20049;
	Tue,  5 May 2026 12:17:20 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:17:20 +0000 (GMT)
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
Subject: [PATCH v14 00/19] unwind_deferred: Implement sframe handling
Date: Tue,  5 May 2026 14:16:59 +0200
Message-ID: <20260505121718.3572346-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfXzK+tM4dHQ5oJ
 MdX+8Rh7NXcIkVonTW0HV/soapNGLDJeyTVwWimaiCR8J6cLkXy8+4UV4QfiTnErNczrdnpFUM9
 jXUKUZ8Kn3KlJFll7/xE+P8UEMbUD0JBZw/gaOYoTU9qNBnNpw4EAxElEVbn0f4Rf/zG6tK96Cd
 JS9cS880iJjIEf684bTcAgBtSm5AwfHYC5VScXUdS25zAtrNqVc3Mrk4pxK+7m/R9uKmcCpMT7/
 7AbfkTSGV/09f3Fhfx7xsT9zAUhd2EwBwcL9Q2Kxw4CwqZ1Ijyvg8o5j0jS3iNvQUEdtqE4sBOc
 mGXlqKRQeYmi047CR64TdwOlUY1u5SWm803H7/0Nv+cXaErmlh2c2IUUE/5VuS2XvJ7HtL07Fof
 UPeTB+jebxx/dvUUFUf7ApcKhS8pARqzHDHTgzA9inYj9oM7uUYMB5K61QmRGfloI6+m2LgFHAc
 qL4sHHrKJ38JhD6Hzkw==
X-Proofpoint-ORIG-GUID: jy9g1owsajKLLw1g1bQpOgj0ru3-oMpN
X-Proofpoint-GUID: TrA4mvIZfh8aTdD5HOXkna__ldgjOzv5
X-Authority-Analysis: v=2.4 cv=W7UIkxWk c=1 sm=1 tr=0 ts=69f9dfd7 cx=c_pps
 a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=uAbxVGIbfxUO_5tXvNgY:22 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8
 a=JoJwsiaakNZ35iy3YUEA:9 a=ul9cdbp4aOFLsgKbc677:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 adultscore=0 lowpriorityscore=0 malwarescore=0
 suspectscore=0 spamscore=0 clxscore=1011 phishscore=0 bulkscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604200000
 definitions=main-2605050114
X-Stat-Signature: x8bz85s7e8maqhw8jwa1zk51gaf31wny
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3645420010
X-Rspam-User: 
X-HE-Tag: 1777983497-49146
X-HE-Meta: U2FsdGVkX1+cOU3poQc7Ga3dG/K/H1VrjR6H96W2ZduZ4aU8OqgTKkoahQDGIh94m00K7s5wHooXy7QXBuVtSMh2Z1lVz2ER7Lb5KAUrtzm4AN/Vw/is+JNEQI756t9V/1gJA1cdTbvczRx2/saBhmRkRj6meVmNGn3V8zTyJkE2ivPaUYheMtSgvM5lX1ffYaJtT/iscenUjRAJazogbe3enVz9jLO68mpN2ReIln12Pcz1QxU7lFdRDzXcGyRkFLQ6pL1N4odzObI1ITc6wuhT5/U/smIB3m0VPpdUpxZmtdhZ2ma5DNutAVZ2rHvAARVsIHPvfzcDJy+p8v2K7YDXi4TMPUlxkRMNLpb3hiREfuwc52sLrGPQ3zKx3JLpIZwJJlzWJ1lPR3ws0UPIAxYop55tSe+YFxThNhOBXOVMRtQYSCAN6egTpq7iGcj0C70g1wt17Snb3EpXdsDrGquXByJ8YcGHtzBDZ6NiMZd/+7WqMvccfiKYeiYF7AcyF+MRv4mJrTIW4cHz0S+T64SGduqTZDIaLNiwFrYSxV+tjiZ7AEcggmLX/V4wFTra4Ms46OiUH0KWnCofJfIt+KlAui4eT4gZJneHklORJV4xVQNGrcBK3xoBpdAN4arnY1/TBFzfY/GZHfCF2hJe3zVm+KOtBB/b6xhg+/OuH+/a9pwJAT1ja8+BCoDPEFsX6owjlT39MIwT7XMCAsBNzfgHEWiuofrRqiZ9YHhDRVY/aXeeoqn7atx2y4qIHj+yp+gFFBGeRZm/yDDImqY8JPnu7sdhFoxFecttjb/GG52XGQxUnBtEb2xSXekg7nDxRgJM7XTWIJ44K+jRccLfGSs1ILx14KCcgqQEaKbzg4hNnELhLuMHxbwuLLConWF9lJH/TOfPdRGG01ve4+WYtNmar7x/4CrVPcLq4cTtleOUUyhAJKtWUF6CN3QJdHjwKV59YiWpWdQA6yBQ9LJ
 N+kwJZa5
 yiegbo0nN+Yxcijvq12rg+fISoqpiJfBEcD6wF/vwph0NSprKUuKXC5Bomd9kvmmL2/Tz5vTBh6li/oYlokv7R4D4bgZN70czVo/5Yr2s+0QZ76CifmZeBPXjEGAOjXt8XTR08ju4+Hdol7Kp/movSGObdDHUz4lDvLY6U4VNldBq7jtofE5+k0ATqVZVMU5CqbLEjhPSyuxOaCoQhth0/tDT+b74wE7W4MHHlOK3HsSQe+kyiWjiZ6ZSu9FFFTnZHaftNEbRRT0YQ2vBLeZYqHVzH6nSaozaFLpoP87tovPgFYSV07z1XKgxGw==
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


This series applies on top of v7.1-rc2 tag:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  v7.1-rc2

The to be stack-traced user space programs (and libraries) need to be
built with the recent SFrame stack trace information format V3, as
generated by binutils 2.46+ with assembler option --gsframe-3.

Namhyung Kim's related perf tools deferred callchain support can be used
for testing ("perf record --call-graph fp,defer" and "perf report/script").


Changes since v13 (see patch notes for details):
- Rebase on v7.1-rc2.
- Correct SFRAME_V3_FDE_TYPE_MASK value.
- Fix FDE function start address check in __read_fde().
- Rename SFrame V3 definitions accoring to final specification. (Indu)
- Improve comments on why UNWIND_USER_RULE_CFA_OFFSET is not
  implemented. (Mark Rutland)
- Add/update/improve sframe debug messages.
- Add generic and arch-specific unwind_user.h to MAINTAINERS.
- Add arch-specific unwind_user_sframe.h to MAINTAINERS.

Changes since v12 (see patch notes for details):
- Add support for SFrame V3, including its new flexible FDEs.  SFrame V2
  is not supported.

Changes since v11 (see patch notes for details):
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

Patch 1 (new), as a preparatory cleanup, adds the generic and arch-specific
unwind_user.h to MAINTAINERS.

Patches 2, 5, 12, and 18 have been updated to exclusively support the
latest SFrame V3 stack trace information format, that is generated by
binutils 2.46+.  Old SFrame V2 sections get rejected with dynamic debug
message "bad/unsupported sframe header".

Patches 8 and 9 add support to unwind user (sframe) for outermost frames.

Patches 13-16 add support to unwind user (sframe) for the new SFrame V3
flexible FDEs.

Patch 17 improves the performance of searching the SFrame FRE for an IP.

Regards,
Jens


Jens Remus (8):
  unwind_user: Add generic and arch-specific headers to MAINTAINERS
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

 MAINTAINERS                               |   4 +
 arch/Kconfig                              |  23 +
 arch/x86/Kconfig                          |   1 +
 arch/x86/include/asm/mmu.h                |   2 +-
 arch/x86/include/asm/uaccess.h            |  39 +-
 arch/x86/include/asm/unwind_user.h        |  68 +-
 arch/x86/include/asm/unwind_user_sframe.h |  12 +
 fs/binfmt_elf.c                           |  48 +-
 include/linux/mm_types.h                  |   3 +
 include/linux/sframe.h                    |  60 ++
 include/linux/unwind_user.h               |  18 +
 include/linux/unwind_user_types.h         |  46 +-
 include/uapi/linux/elf.h                  |   1 +
 include/uapi/linux/prctl.h                |   6 +-
 kernel/fork.c                             |  10 +
 kernel/sys.c                              |   8 +
 kernel/unwind/Makefile                    |   3 +-
 kernel/unwind/sframe.c                    | 842 ++++++++++++++++++++++
 kernel/unwind/sframe.h                    |  87 +++
 kernel/unwind/sframe_debug.h              |  68 ++
 kernel/unwind/user.c                      | 111 ++-
 mm/init-mm.c                              |   2 +
 22 files changed, 1423 insertions(+), 39 deletions(-)
 create mode 100644 arch/x86/include/asm/unwind_user_sframe.h
 create mode 100644 include/linux/sframe.h
 create mode 100644 kernel/unwind/sframe.c
 create mode 100644 kernel/unwind/sframe.h
 create mode 100644 kernel/unwind/sframe_debug.h

-- 
2.51.0


