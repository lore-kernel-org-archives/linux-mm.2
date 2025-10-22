Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D2C4CCD1BB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 16:53:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B9308E0007; Wed, 22 Oct 2025 12:53:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9905F8E0003; Wed, 22 Oct 2025 12:53:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8A6118E0007; Wed, 22 Oct 2025 12:53:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 79DEF8E0003
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 12:53:26 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C97E88D60
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:53:26 +0000 (UTC)
X-FDA: 84026346012.22.268AC89
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf10.hostedemail.com (Postfix) with ESMTP id E5C98C0006
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 16:53:23 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=miff2ZbB;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761152004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wqeUxUX92Y1HayYdw7nIIpheb1/j2cuOnyvCmmL8BRE=;
	b=lMy+Li0Qm0V9yt7d844SrXJRraNBSjv66sbRLHytvo8FlJgA7ORNUwWd8ybps6ZKKFhIaE
	9blEti/hJJ0mi2P2sZZU/fsloTGD1UTd7jwn/rSSrd36PLyCuKnN4oJgPkZFAh4WrhJCWj
	GPmswlTw4DmW93XOeoGo0dSMVf3FjbE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761152004; a=rsa-sha256;
	cv=none;
	b=otdEsT4VQZcTRpV5v8bB5mm4K+QWjScY9R0HbTm/qHGthN5dHL/5dBaE2uJ+RFAgphygFt
	xpJ1q5kNWGh0M+lPCiWJ+6YoiJPuVpcGabh+SfJav+pOtJan0uCgU7YNQliWP+8ceauqkX
	htvywwYjPaAiHTdkRwz1pcbWEiYsmpk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=miff2ZbB;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf10.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59M9ufCp017502;
	Wed, 22 Oct 2025 14:43:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=wqeUxUX92Y1HayYdw7nIIpheb1/j2cuOnyvCmmL8B
	RE=; b=miff2ZbBKvd90piC615SLJE94VxM9gAhJZOr4WjvIEfE5kXlFR+1L2p++
	cduoqipi8SgxE3Ryv8K9saq/PzlGm6LZUzqw4AE4B0n46RYgV9N/iBu48HbPN5i6
	5TNlGasmcq8SzexPIx43JQL+/clQnJRmPfH1AxLV50LOwGJsONfG+DTWGBCPmW0C
	0AloowVmOvZlLDP73Cforxhhcgct5np54EGGGXJVKjRB7VeP8CWBjMpzoZm9jGqB
	s69QATfPxwQ4kIZZpl6T5MHc46Mcgf5hx2/8pL9AEQd+lZKVUziZFj6pJIShqktl
	BMezNu2bSXcN/nUz0RA02VIxNxqEw==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vuuxh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:34 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 59MEgv8p013427;
	Wed, 22 Oct 2025 14:43:33 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 49v30vuuxd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:33 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 59MBhucP011015;
	Wed, 22 Oct 2025 14:43:32 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 49vqx18juu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 22 Oct 2025 14:43:31 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 59MEhSF749873198
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 22 Oct 2025 14:43:28 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4F54620040;
	Wed, 22 Oct 2025 14:43:28 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id CCA1C2004D;
	Wed, 22 Oct 2025 14:43:27 +0000 (GMT)
Received: from tuxmaker.lnxne.boe (unknown [9.152.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 22 Oct 2025 14:43:27 +0000 (GMT)
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
        Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v11 00/15] unwind_deferred: Implement sframe handling
Date: Wed, 22 Oct 2025 16:43:11 +0200
Message-ID: <20251022144326.4082059-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.48.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: GgtjZ29_6xWj039oWr2J0c-Uv8vu4kva
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX42N1c30jQ+g0
 XAxt8+bY8ekXIGErvlpFBJk/bfAG+dFER49ApCJ8PIN9HvmIVcLeB8mjDqoHoDT7tI4pNcYBCuu
 pvCQOGw4vZZJDspVVU/8lXtf8icXBi5A91knuSQoQAczV8qRB99+E5HH8xmy1q7x3YLHVcSxorx
 +fj5HHQ3BY86xuPlu8JXKmvcTQvUZXPB+Ca7dLXXZw16MScQMxmQAe7yNQIqrpA8Bgct2ZmWqN8
 Zui7GN4J0jI2K4nN41mU+01rCv+8OrX+nKxahQF6cMb821Fk1a4LnYrPZyh+WfKq1L1BWAwXdEH
 7odE96skzucO5IO7yJrNvPiD+y7kzi9D6OmcbTsvE7P7o3El680fsrKDuyK0Gpc2Rd0egAQEMVW
 KePGQmQFh4FKsxZ1AOBA6lYR+JwH5Q==
X-Authority-Analysis: v=2.4 cv=MIJtWcZl c=1 sm=1 tr=0 ts=68f8ed96 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=x6icFKpwvdMA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=CCpqsmhAAAAA:8
 a=JfrnYn6hAAAA:8 a=W3Ibw5UVuYrs5_yFpHwA:9 a=ul9cdbp4aOFLsgKbc677:22
 a=1CNFftbPRP8L7MoqJWF3:22 a=DXsff8QfwkrTrK3sU8N1:22 a=Z5ABNNGmrOfJ6cZ5bIyy:22
 a=bWyr8ysk75zN3GCy5bjg:22
X-Proofpoint-ORIG-GUID: c_DPn-LZtCSMJRVuAxrTcXSg7ydCxI6c
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-22_05,2025-10-13_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0 adultscore=0
 clxscore=1011 impostorscore=0 bulkscore=0 priorityscore=1501 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510020000 definitions=main-2510180022
X-Rspam-User: 
X-Rspamd-Queue-Id: E5C98C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: cin9w1w5tms8er6og7w4pj545i8sczpt
X-HE-Tag: 1761152003-981735
X-HE-Meta: U2FsdGVkX18AhlLe1BV/e51pUJ1rUGhvFCgFWljnCb7pGmIt9jOGQrTyMNBx+AypUa6WH+hiN7P4zjZ0g1uBeEimz3CVsgsfE+cPo0owSPY8nu2hkDopIJ40QAzbYyHVRKl1V83Y2i+gyrtCDECviIWwfhnXuJwAm/+/seSEktLKOR6eRqLVYPnefY1n6s3w/PxjFputs0cSs+oeqAiyJwdqnm1CdVOYBHrA6/ACaz23aGNBbqSz3hWxd1ZhwMMPhot6IcC9aRfGeHvhMwQcOKIACzTBaWKnO1a8jM4URLdewZhqwa8z08+a3wbvX3cSmsLmjwPlQP1VnxJu4WfzHTLMNR0W7Va74LFPfZGLHNPgcF1cZrf4pf8utQdXiqGoRHg9KGAp3EXLB8BynmOEeVMxNYTPrGe548HrJziFpiF0fX8Y/XOsSVYtczZSnDl9pvQL0atS2yx6+PCuNqg/1xJPucAPoKHFcOQp6hjnNuXXaSezsJmpdjwLhlvqvHMivAboJ2pFb3wttj+K6jM9U21Bw8B/lc5ZV+U/LR+2dw9peNO70NsWdRTZqWIHa35y9yREH4mhmq3tiX1OzR75bt/gSL46Apg6KliRkG+6fnRJutIw2CTZLvzDG1qtnzB6Kj0EeYQUCVSmvVTQOOskEMXSgBMVi9lb1sUpr+lS9V6lY35YCu+7gaeooRwFPe1qkx5TWuFkR7261nHB+ra/dWtrCz2QDdbPhHJO6sR63sIk5Ojl5YMakRfRlxSHiSlR5LBZx870x0AoIXJp8jmUSCzhvZwGnYfz09r5R+b5yq6fF8J1/QFRYYUtJJAwfoyj23QxUHCXEO00rK6/JVyoGBPY/wKs2ocipIKY5TATrSScsw4JECtr2G9P2bWV1ddz4nIoUP+M0N7rkkYI/DCFPjxUBS6F1nFsZa0qN9ZS9MXw66/97lVxseNUudPp/b9fuy8k3HKVq4bfV+IzSuS
 3g8/qJEf
 a3tzDxUt52HN5z9bJZCD8xpdYCfk/0WVGjX0kByFNaop5o6HatQw1m5wUcHFNWozwqzHFOOcIwlWsIlWZQ+Y/2v76UXw0ecoHHv0JBLOrCexCev4CyV/X0FQcObPz3svnTs757Lec2t77ktDFpU6/3AJHlVpLScdxNjmmIXifZLlcpcGZy+hxTztTvMNkVXeDHVzPc+EMusZZz1bRS9D40AeV+r8SuJrmyEESRMOOQ7ZGj+OYRk0gpTIH8wc6ZJ1C2D0c3RDLmfFdGksH2z2QI33so7YzkhuEuwy833Yg0DFbcGONwwKXlLJQJrzwfz5s4CWu2SXxUV0/+gOa6sfCGlTuwLvt4EHLPg2G6B9Bzt9RAFlV48SfnYeBsUfERRU968iUAv9imfnHPl2KFhnUCUb2eEYgGrTdQfoVzfgG7jS1zpP2AO559U+dv0hwqYOxHqGU0C3piG3sIBshsqujvuwxPxfFcymASa54iynY9zvYGgg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is the implementation of parsing the SFrame section in an ELF file.
It's a continuation of Josh's and Steve's last work that can be found
here:

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

SFrames[1] is now supported in gcc binutils and soon will also be supported
by LLVM. SFrames acts more like ORC, and lives in the ELF executable
file as its own section. Like ORC it has two tables where the first table
is sorted by instruction pointers (IP) and using the current IP and finding
it's entry in the first table, it will take you to the second table which
will tell you where the return address of the current function is located
and then you can use that address to look it up in the first table to find
the return address of that function, and so on. This performs a user
space stack walk.

Now because the SFrame section lives in the ELF file it needs to be faulted
into memory when it is used. This means that walking the user space stack
requires being in a faultable context. As profilers like perf request a stack
trace in interrupt or NMI context, it cannot do the walking when it is
requested. Instead it must be deferred until it is safe to fault in user
space. One place this is known to be safe is when the task is about to return
back to user space.

This series makes the deferred unwind code implement SFrames.

[1] https://sourceware.org/binutils/wiki/sframe

Changes since v10:
- Rebase on v6.17-rc1 with Peter's unwind user fixes and x86 support
  series [2] and Steve's support for the deferred unwinding infrastructure
  series in perf [3] and perf tool [4] on top.
- Support for SFrame V2 PC-relative FDE function start address. (Jens)
- Support for SFrame V2 representing RA undefined as indication for
  outermost frames. (Jens)

[2]: [PATCH 00/12] Various fixes and x86 support,
     https://lore.kernel.org/all/20250924075948.579302904@infradead.org/
[3]: [PATCH v16 0/4] perf: Support the deferred unwinding infrastructure,
     https://lore.kernel.org/all/20251007214008.080852573@kernel.org/
[4]: [PATCH v16 0/4] perf tool: Support the deferred unwinding infrastructure,
     https://lore.kernel.org/all/20250908175319.841517121@kernel.org/

Patches 1 and 2 are suggested fixups to patches from Peter's unwind user
fixes and x86 support series.  They keep the factoring out of the word
size from the frame's CFA, FP, and RA offsets local to unwind user fp, as
unwind user sframe does use absolute offsets.

Patches 3, 6, and 14 have been updated to exclusively support the recent
PC-relative SFrame FDE function start address encoding.  With Binutils 2.45
the SFrame V2 FDE function start address field value is an offset from the
field (i.e. PC-relative) instead of from the .sframe section start.  This
is indicated by the new SFrame header flag SFRAME_F_FDE_FUNC_START_PCREL.
Old SFrame V2 sections get rejected with dynamic debug message
"bad/unsupported sframe header".

Patches 9 and 10 add support to unwind user and unwind user sframe for
a recent change of the SFrame V2 format to represent an undefined
return address as an SFrame FRE without any offsets, which is used as
indication for outermost frames.  Note that currently only a development
build of Binutils mainline generates SFrame information including this
new indication for outermost frames.  SFrame information without the new
indication is still supported.  Without these patches unwind user sframe
would identify such new SFrame FREs without any offsets as corrupted and
remove the .sframe section, causing any any further stack tracing using
sframe to fail.

Regards,
Jens


Jens Remus (4):
  fixup! unwind: Implement compat fp unwind
  fixup! unwind_user/x86: Enable frame pointer unwinding on x86
  unwind_user: Stop when reaching an outermost frame
  unwind_user/sframe: Add support for outermost frame indication

Josh Poimboeuf (11):
  unwind_user/sframe: Add support for reading .sframe headers
  unwind_user/sframe: Store sframe section data in per-mm maple tree
  x86/uaccess: Add unsafe_copy_from_user() implementation
  unwind_user/sframe: Add support for reading .sframe contents
  unwind_user/sframe: Detect .sframe sections in executables
  unwind_user/sframe: Wire up unwind_user to sframe
  unwind_user/sframe/x86: Enable sframe unwinding on x86
  unwind_user/sframe: Remove .sframe section on detected corruption
  unwind_user/sframe: Show file name in debug output
  unwind_user/sframe: Add .sframe validation option
  unwind_user/sframe: Add prctl() interface for registering .sframe
    sections

 MAINTAINERS                        |   1 +
 arch/Kconfig                       |  23 ++
 arch/x86/Kconfig                   |   1 +
 arch/x86/include/asm/mmu.h         |   2 +-
 arch/x86/include/asm/uaccess.h     |  39 +-
 arch/x86/include/asm/unwind_user.h |  11 +-
 fs/binfmt_elf.c                    |  49 ++-
 include/linux/mm_types.h           |   3 +
 include/linux/sframe.h             |  60 +++
 include/linux/unwind_user_types.h  |   5 +-
 include/uapi/linux/elf.h           |   1 +
 include/uapi/linux/prctl.h         |   6 +-
 kernel/fork.c                      |  10 +
 kernel/sys.c                       |   9 +
 kernel/unwind/Makefile             |   3 +-
 kernel/unwind/sframe.c             | 615 +++++++++++++++++++++++++++++
 kernel/unwind/sframe.h             |  72 ++++
 kernel/unwind/sframe_debug.h       |  68 ++++
 kernel/unwind/user.c               |  56 ++-
 mm/init-mm.c                       |   2 +
 20 files changed, 1004 insertions(+), 32 deletions(-)
 create mode 100644 include/linux/sframe.h
 create mode 100644 kernel/unwind/sframe.c
 create mode 100644 kernel/unwind/sframe.h
 create mode 100644 kernel/unwind/sframe_debug.h

-- 
2.48.1


