Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFAE9D6100A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 11:28:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 438156B0088; Thu, 29 Jan 2026 06:28:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BB966B0089; Thu, 29 Jan 2026 06:28:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 290496B008A; Thu, 29 Jan 2026 06:28:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 146A06B0088
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 06:28:06 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B39D116095F
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:05 +0000 (UTC)
X-FDA: 84384777330.13.D24978A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5B4A68000D
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 11:28:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M1gFEZji;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769686083;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SUOh161zhkIWDyOcaI3u3kKKSN0WquOk1hYBaryi2p8=;
	b=WBMRUlTP0Zm/ctDf52TsftclkiLzo1PBb/p7/6Dh9mr7IWUeghifmMvkxaZalXiReZ/DRq
	n2y9/SCkaDGehsjgBfsTmO1rt4oFSl7+8sVCp2B8Z07flbdOeaHFmcgnmeARmFf1APA+dn
	wwDKWSQY1Ixzq/VSrjF2S7IlRRrOcmc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=M1gFEZji;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769686083; a=rsa-sha256;
	cv=none;
	b=Cupx0TE21YbI1r0pyyzBrNtx2QxbBo9K2fjBmJ+6ZzaDlzO6Mo4HB4GYq4X8CIKOjPriCU
	4WYm579jlu4z7uqRWyMLGExhMV4cmFsIXP6L6MQmGxCxDeYyf/z+5BgPVfZOrgJH/T6L7y
	ToLCRMSt+fCzkgiU4Dg+5Y5BrtF/K4U=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 60SLbE8O029482;
	Thu, 29 Jan 2026 11:27:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=SUOh161zhkIWDyOcaI3u3kKKSN0WquOk1hYBaryi2
	p8=; b=M1gFEZjizKLN5GEXNMk7sla3zCggfrOjp7UkekOFoxS3mxNrRRNoraY6F
	hjdEmxJe5B3lHqlw4QCUV4MWw384D2LRtdAqabmzWIdQTAFKHmHbtTdGbjcUP2T6
	kYhUHY3XTwamx9tscsTfb4cMyr+B/xJKPGDEYcv7tgF2bnuTXgrnXRsfzxHSHI47
	zIiCDsz1iy9oCWYFONIp2WfyjpJM7daYfl8oNeH3Qx3qN5pMhXp7J7iOZimnrTy/
	IedLTyo39Fisxn9ahjqShAQyR5xIvQCeQs4sM6oClA6Tcf6cWafb63YSMCmheacc
	gwnd9EvuJWwzQtv6v/e/hCIn7k6mg==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt80ayx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:34 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 60TBRX8v029733;
	Thu, 29 Jan 2026 11:27:33 GMT
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4bvnt80ayg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:33 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 60T6Sawr031069;
	Thu, 29 Jan 2026 11:27:32 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4bw8dsshph-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 29 Jan 2026 11:27:32 +0000
Received: from smtpav05.fra02v.mail.ibm.com (smtpav05.fra02v.mail.ibm.com [10.20.54.104])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 60TBRSTg27919094
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 29 Jan 2026 11:27:28 GMT
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7158D2004F;
	Thu, 29 Jan 2026 11:27:28 +0000 (GMT)
Received: from smtpav05.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8AEA620043;
	Thu, 29 Jan 2026 11:27:27 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav05.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 29 Jan 2026 11:27:27 +0000 (GMT)
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
Subject: [PATCH v6 0/6] x86/vdso: VDSO updates and fixes for sframes
Date: Thu, 29 Jan 2026 12:27:20 +0100
Message-ID: <20260129112726.892340-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: KmyhTpEXJg8HegGafdKfkxfmrZXZHBL4
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTI5MDA3NiBTYWx0ZWRfXzPvvYI2epdOw
 4l5ffEeTLLs0bD6QGaoX5V0WOM1qr1OmTMcAijVu/mIoe3vxqzuTAZQaVv76Wmm37SbpJU/F4SL
 GLB7pCWWW6YoptFBEw7+72Fmd6dEpEa272HUBTH1q82evQpwXF6lXfwnVYzAeT7CYv8l4Xli8Ky
 y99NiRPgvcjf70azP/yg+oYRc/mVc6oQOCUQC4jc6r72gLIt+EbUevqaDoVBCATGn+On7K86Q1G
 +6F6YH2EANo+ecbKrpFZ920qArOabZiax8dEo1AUnUU+74MW8w6xTjSEkoEcg7gc6guqchwsW9g
 mU5Fox2jrgCzYWQm9BK5rcqneueOAjro8bf8cC+neovZw8H2GLniAbMiLCdUfE+mN62IvSAhSWa
 E1cuWgnN8teTqWvxGwk7Ote8VArQZKPExapqX9LTY42eGnqL6fiOxDrswQhCsaVMPo9jL8UVFh7
 g0JXyZUCWrmUVVsow/g==
X-Authority-Analysis: v=2.4 cv=Zs3g6t7G c=1 sm=1 tr=0 ts=697b4426 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=vUbySO9Y5rIA:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=HwLxJGTS2eH444T7Q8IA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: R-FiN0dvnPWqON9cIr5F4rUoJQsDj1E_
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-01-29_02,2026-01-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2601150000 definitions=main-2601290076
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5B4A68000D
X-Stat-Signature: nmkr7j775d18kgsopm16iyrdhy3hiirz
X-Rspam-User: 
X-HE-Tag: 1769686083-30419
X-HE-Meta: U2FsdGVkX1/UZY1RvVGCqpkBLsal9C9hQ0rZbdzAPGH173rHa22HVbHdqC8wLdmdjS0xVGIShpl8KYfu4ylXqDK4bDhYzMDvaTdZd3oFjdAe96obXOD4xVbQF4OwZPlYEqI8+tcVMsh6597jcKiZI5Q+vzJfZNCzcbnS8BLoXy8k/ySJYVNPaWsV/WEQbDSyPisqDxyGzhmQumcyjizQjlIBDdunfjEUkRP52fC2jlGiCEzwcR4bDV1UO02sjJlro2j6asidCxjPoEtbkeUIWTtRgrUpl6gOqCJJKiiwCt4+JLAqArwVujltngOJHXeAS6GT8J9DJWognYI+uR09YyuqDxBVY9ZpzH+URcL3YF0zI2f0jQaO6DW2DD1WTjFwuRqKzAcCZdAR/WKTmUvUbRCC3wEZOc7WexaNqJ8VVhMWuazLFVXpmMKhkQFOF9vT+YtM24Ld4Q30cHl7XL4qS/v8mfjqdUteU5AzzZ4Jvfz2a8nCR6Gj0b8LHE5DSlQ4o7RCqYqOYa4JGYHObSswdUlItUfjWLM0UZFkWB0trumsezyxOCLV2L7yfU0HDbQkjGcZvmps8YQDf2yjM9qI/MLg7Mk5jqORBsWnow2urwpq6pW3bQWpGwHvX8aU0W9kS68+AmGwgU6kf7zt3xmrpfEYc/cA0tt5duRU9jgBjIGOMThTKixeGCGRg/Wknl1CXDchC+cWBlD0xu9np1eRisRsA/oDjUdZLGZk/J/8qCfypD/co9jGaMGMsHUkHCanKB6AMzYYCBBiKhzOM48BYj7Z6/QoBtYaB/StlZn5bbG7lsCnqtRMPFkrjyHbZP0+3UgdAHBCyzHqSNGJuiIXkdP0kuXrfVK3AJuH0AgN3MdmFI5CATl9d4VJIcxm97T1oWwxWwWRHVgu9w+QxbAkPIsJEZpojzYZPlEnywccKnqNg/Dk5ArF9yrQFHJef7l9HfJC+icvmsPjk4RsyzQ
 M8InB1IB
 wyW2XU1r0GevrAWdOtdBFKXgE1rji/T2DfblYGeGbdC2816yZ1rWvTU7oCrALb6FKXDPEe0HvHGlQ/V5M8GvhPM5ft5h7mIKfOyHCRe1Gv3m9W6MT1j2TBTwoaFB5t+XCnjP6D5uzuHsRPvESSki7kRSDUquCpT7WQkAmCHvGVavLbtpzJU6XtJ34aYJrJURep8y9je8ixNxprrbY8Z8t711wlCDJSoWEFwn6THiyDyc0v/GA3ozqotm8yyfU0ONtfO3o7mQlEk5AzPVux/bE+U4uXEHYJdclWsE+ltvrEIscNa7MZCiWcFXbvnizCb7pOMQ7DJA+L9GG4qsm6Zci47OayvutWY+JDheigqg3cNT8LQ0tCebS2YJoTtOPmJ1OGz5N
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This enables generation of SFrame V3 stack trace information for VDSO on
x86-64.  It's a continuation of Josh's and Steve's work:

   https://lore.kernel.org/all/cover.1737511963.git.jpoimboe@kernel.org/
   https://lore.kernel.org/all/20250422183439.895236512@goodmis.org/

This series focuses only on the VDSO code. They are helpful fixes
and updates that doesn't rely on sframes (although the last patch
is sframe related).

This series applies on top of the latest unwind user sframe series
"[PATCH v13 00/18] unwind_deferred: Implement sframe handling":
https://lore.kernel.org/all/20260127150554.2760964-1-jremus@linux.ibm.com/

Like above series it depends on the upcoming binutils 2.46 release to
be used to build executables and libraries such as VDSO with SFrame V3
stack trace information (using the assembler option --gsframe-3).

Changes in v6:
- SFrame V3 support (SFrame V2 is not supported).
- Prevent GNU_SFRAME program table entry to empty .sframe section.
- Integrate v5 review feedback. (Josh)

Regards,
Jens


Josh Poimboeuf (6):
  x86/vdso: Fix DWARF generation for getrandom()
  x86/asm: Avoid emitting DWARF CFI for non-VDSO
  x86/asm: Simplify VDSO DWARF generation
  x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
  x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
  x86/vdso: Enable sframe generation in VDSO

 arch/Kconfig                             |  7 +++
 arch/x86/entry/vdso/Makefile             | 10 +++--
 arch/x86/entry/vdso/vdso-layout.lds.S    |  9 +++-
 arch/x86/entry/vdso/vdso32/system_call.S | 10 +----
 arch/x86/entry/vdso/vgetrandom-chacha.S  |  3 +-
 arch/x86/entry/vdso/vsgx.S               | 19 +++------
 arch/x86/include/asm/dwarf2.h            | 54 +++++++++++++++++-------
 arch/x86/include/asm/linkage.h           | 33 ++++++++++++---
 arch/x86/include/asm/vdso.h              |  1 -
 9 files changed, 97 insertions(+), 49 deletions(-)

-- 
2.51.0


