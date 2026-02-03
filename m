Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D367E8784E
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 17:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55B556B00AF; Tue,  3 Feb 2026 12:20:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43B9A6B00B1; Tue,  3 Feb 2026 12:20:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F32C6B00B2; Tue,  3 Feb 2026 12:20:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2EA6B00AF
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 12:20:49 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AC2BB596A6
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:48 +0000 (UTC)
X-FDA: 84403810176.17.C551F44
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf12.hostedemail.com (Postfix) with ESMTP id 446C040010
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 17:20:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UkVOeiSo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770139246; a=rsa-sha256;
	cv=none;
	b=la0iifFKi+m4kCxw5zrbDqSySZ6B7ejxKe+Zc3r2bXFHbjgF1gnPWIJNBUSm/QfDa0gIoV
	LEcaeOfCam/IO3z7ejviv9m+XaUow6FasMgqAsOV7MEcorgibrJf+UYgTNCHKb9HnkgEY8
	hHMz3kcvIQ61fWZXhUERGwUh3z3SkHM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=UkVOeiSo;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf12.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770139246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=holsj/DH/vmC4w5up1pgT5Wl04Hxp/1NxOAJ2YohSC4=;
	b=q4pUMJIumZ31iTiFOP4d3PtER3fCyjnYmfjZjGLPQxsOgq+rj+IHZceKszHHnUXnqR3noN
	YT3W+EnnuKEokfmFbG/qM90nuuyRZsZ+Z8X+QA5eXfobe3eF4QhBIImLkUBWF0kpY0Yndn
	yVXXkrI6IvcxdxmPePz0OeszSQaTgcQ=
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 613A7nar003180;
	Tue, 3 Feb 2026 17:20:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=holsj/DH/vmC4w5up1pgT5Wl04Hxp/1NxOAJ2YohS
	C4=; b=UkVOeiSo7tVC74Oe4tQmg82tutN7L1QEpLOw+VqWhNXiosKH7+1ZBrsDj
	mktPrpytoAL/1BrAiCbQNdbTOpl+aZGCnlNY9iRRLJwLoxRNCXT2DDtpLiFHsCx3
	rXCHHeR2dUUj02eOp+UgQZRKUmsa6DFeMRCAjpn+wPEQzVjXzMFWjVFuhx7itUIm
	8JKKQdfCi5zklM5T+9QS6rp4p9pzjOfjMaqNItWBLuDRvcnIU2rQLaZ5CVdAkbIT
	9WTr0eLxUXon93XVGiaATInhNWd6pNsriy9RowevBU7x5QA3ktKYzhw+nLx2TnI1
	bP2IRpH0sJjXnShKdvdDXWwXtxYKQ==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f6ehys-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:06 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 613HK58c013988;
	Tue, 3 Feb 2026 17:20:05 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19f6ehym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:05 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 613EZQwX009152;
	Tue, 3 Feb 2026 17:20:04 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4c1vey23j0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 03 Feb 2026 17:20:04 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 613HK0ic59441638
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 3 Feb 2026 17:20:00 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id EB95820043;
	Tue,  3 Feb 2026 17:19:59 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 64B0C20040;
	Tue,  3 Feb 2026 17:19:59 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  3 Feb 2026 17:19:59 +0000 (GMT)
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
Subject: [PATCH v7 0/6] x86/vdso: VDSO updates and fixes for sframes
Date: Tue,  3 Feb 2026 18:19:51 +0100
Message-ID: <20260203171958.1522030-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: AvCe0Lizk_qNOQPcgj5xw0f4cpi6WqAy
X-Authority-Analysis: v=2.4 cv=drTWylg4 c=1 sm=1 tr=0 ts=69822e46 cx=c_pps
 a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8
 a=VnNF1IyMAAAA:8 a=Iv64z9_ZCafLdlMPf8wA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: xZBc5_zw3IOyV4v_T4s7DqJ9T8UhHJ6y
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjAzMDEzNSBTYWx0ZWRfX47xopohdQhDA
 saX1Kkcbkz1w+ABI7KeZuWK3heQjLj/i3ALX+l44OQ+Fvuji/agkjKrp+HOVKsC6EeZz0A72Ram
 oR+e3pJ+5PX6zzKT7XlMlmBTTmo0/hxiTolQo7NqRj9FhE6QrudKvSCU6TtMRc2opRtxe3h36+Y
 +BjaP+uuM6BRP0bbOOgiD37el298K/R68dUmem6thsTAzcnFDOUB7wSO7fIlsH3mf4d3lc66grK
 l4qrLhNYFbZIVakWULDM+P/WJAEi84WnTnRHlNF/tsfuG7Di4nwvVOJwiA6G4mqpiRjwLLexjdw
 e4Io0DCE4Fm7MuNo+jHczsBzst2kdOgjNCO3U0GTdU2Lwk1HhC+Ox3LPv7cJ2ZrpXq0tz50ZT9e
 MoxxElSVPjBS7e9An27AnuDwORa8owHVNFjf0tP3xfRAQq4FnUfIIOPMHpAGti1GWCC2TkN6/Bn
 C+pjIR550Lixs0e0o+Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_05,2026-02-02_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 clxscore=1015 spamscore=0 malwarescore=0 bulkscore=0
 phishscore=0 adultscore=0 lowpriorityscore=0 impostorscore=0
 priorityscore=1501 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602030135
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 446C040010
X-Stat-Signature: bcw1god4kt9x314fmt5i5xeb3nbkx5wp
X-HE-Tag: 1770139246-139503
X-HE-Meta: U2FsdGVkX1/HBQ0vSfmUtGR04g0pw+QJ3flGXHFR0rW6z+n7BMp9vSH3gavgRoO/x9PhI004cF4tFICWj1N1niOVmSRmFnFMczFDruleYWqfCNWx702YIqAcU4vxZeVUwOzcIliST2XpP/esoG7iEksaOnuJR8z3plmj5UsZ7GIjOY7qX2e4ClpzhEHN24FL4x/cfNG+PLDHm4NDV0mEikzsF1EoM7trlzHhg4CaKozG3Gw2Awj5jpQ12LHoIDbVghe/3qR0OPZd7ui1EjubhG3SBvbwcwGVXjLw5ZV+XkEnTwqUbD2Mt1lRXsOcaHYnWf/5UGQWkc9d4Fz7FPfKmMLs+pDY35P7Jmnnq31+znHq7/xwygKeOunQ33atP2oEBQ+1i2K5EOsY50FnE/Hyit6Ud0rwwXh4e6CASWzIbC1iLR5no7SpEW9jfkUS4o4ynhpyPxzRJxyQ1P3sYowFM/8C0pyvYlECl27+hr+8mfyWVhC5uui3AZSTmBkb45mXXhdCP4QXy3aF49UN4+l2BcdDletztoU8jv1aO66XFK78THpQbykIay+JIH9S6AJNY1+gazPhZ5Jbh7SgRuOUJ8nZ+boypYpw1h8/b7urB3dofDTCbsuRk+wg8pss8ygFi8Dbj8knuN8jlXjKWtY5fjKlsoIRxHUTh11M+msf1rswlhTae6L5UH7sbqJypbWoPKeCAT90hKtErWzbM1BtOYgqnTNamS3WUW3Z14yDHoGAliQX749/CK19WR6smupMbO2/mPqhJsSfzeunt3x0IU4fFXKx5h8pHp4wsHSFIFSTmwXI+SrfPsWzbhw4CClbZnT6637g80XxerWPLG7SmkA6diGFhH4vq36CEl78gLaGC4QkRay3vDU0UMLGdB0j29kbP43kjmJjRxNdp5mrz5oy8qO4zCB8zmXVi+SHqthZZU2fl1LD1kKKAfkTO4b91cUbztabZluTxT7K+6N
 6A1DOZmc
 z1fWBDpfdnWjV6LstlqBucv+rZeYCaX5t7Wll2XUE8M8G4p5AWKFbBkbZxmzquqgYKb5FDGLuRRWh7mWRmiOzvMbxGbzAv0H2mXBsDGvRW0il3GUsShe19YpMl3XXyJ1fJoLSIvSOfdyiJ6klrlVI4vJgjD85vJvY97zvkRv0Bu1qJTfoqh/NJwrPQsgQ/OwVCGjAwLvixplix5vnnGz3VJXrdxYmcCImOY5Y4TJGT8IfQrm5+0RbAzDx+cK37zlKhE7Qsk+CN1vZypYFYoLwylqqv43fGM0PdULR
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

This series applies on top of tip:x86/entry:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  x86/entry

Like the unwind user sframe series [1] it depends on the upcoming
binutils 2.46 release to be used to build the VDSO with SFrame V3
stack trace information (using the assembler option --gsframe-3).

[1]: [PATCH v13 00/18] unwind_deferred: Implement sframe handling,
    https://lore.kernel.org/all/20260127150554.2760964-1-jremus@linux.ibm.com/


Changes in v7 (see individual patch notes):
- Rebase on H. Peter Anvin's vDSO changes on tip:x86/entry. (Peter)
- Simplify adding assembler option -Wa,--gsframe-3.  Add for vdso64
  only.
- Align to .eh_frame and mark .sframe as KEEP in vDSO linker script.
  Note that GNU linker 2.46 will mark .sframe as KEEP in its default
  linker script as well.

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

 arch/Kconfig                                  |  7 +++
 arch/x86/entry/vdso/common/vdso-layout.lds.S  | 13 ++++-
 arch/x86/entry/vdso/vdso32/system_call.S      | 10 +---
 arch/x86/entry/vdso/vdso64/Makefile           |  1 +
 .../x86/entry/vdso/vdso64/vgetrandom-chacha.S |  3 +-
 arch/x86/entry/vdso/vdso64/vsgx.S             | 19 +++----
 arch/x86/include/asm/dwarf2.h                 | 54 +++++++++++++------
 arch/x86/include/asm/linkage.h                | 33 +++++++++---
 arch/x86/include/asm/vdso.h                   |  1 -
 9 files changed, 95 insertions(+), 46 deletions(-)

-- 
2.51.0


