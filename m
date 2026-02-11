Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CBBFE9E310
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 14:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 685566B008C; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626056B0098; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40A166B009B; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1276C6B008C
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:14:36 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEC3D13AB87
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:35 +0000 (UTC)
X-FDA: 84432371310.21.599055A
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8484E80008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 14:14:33 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pUKOPhDn;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770819273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=C7xAfdpMOTvilgbGfl6MI5ZAQDEnBGLGaHCN4H4rSHg=;
	b=jcKGBMhBfuDBD4Vg+iKHPEf3pQZCXdvfMkhXnKaW1edecuT+vb9nulIEbay7qdpPQUaw9a
	tyqi80NqSw3oHFGFb1gm7Y36QFfGnXX5Q4QgebW0hNz3ZB4Js5cnOnSyEEm2U2NMee0STZ
	AaUsg+Slc4EYcUw5jeUtsl5pMm99wn8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770819273; a=rsa-sha256;
	cv=none;
	b=JEnovtic5phQxdqp1qC0marVFpefV4IfK4+yhZ0Zu1Ju7cbAWRBVjvIuO9JZ5I7UhdgpEF
	nlEsHgK2cKNa6y6ihj0dFiobxCOWTPf+8MsiyQIES9Z23lfIYGhxdNytcbleAWObDsUDh8
	m+4NBQX+kIe2RttxNeGQPyWk6acmzZU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=pUKOPhDn;
	spf=pass (imf30.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61B3UgPQ1915889;
	Wed, 11 Feb 2026 14:14:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=C7xAfdpMOTvilgbGfl6MI5ZAQDEnBGLGaHCN4H4rS
	Hg=; b=pUKOPhDnck4Q9STWjISIYOiIe41lRR24JfmI/37W1Yo1912gMHl/Ecjx1
	3jNWqtHbLjmnUFOQ3AS7XFRJ+F9l4IVuZwi5R/XBh0TLAMgCRDxNIdEt9dhzQ79f
	usGQgbeWHDJRKKTWAsMmM48Ok+F+2mujMvr8DWyWIqEPbvOCJ59IAC8nob4WMn2W
	Ha83VXo1S7odKUt1jxm4CGcWqMglcLOmgb780cw2MsEOEjGtn4ghlmCWBLNBp/IJ
	MXctnV0p2umjNVoDYnr6+G8/ayjYZ45B5HSFyhOM/ggYyMDMXa0kzpRiF/gTgg7e
	HW6Qstp1yatVyq8tcCyUBLMIY2aFA==
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c696uhjjd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:03 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 61BAKMMg019225;
	Wed, 11 Feb 2026 14:14:02 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c6hxk5wae-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 11 Feb 2026 14:14:02 +0000
Received: from smtpav01.fra02v.mail.ibm.com (smtpav01.fra02v.mail.ibm.com [10.20.54.100])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 61BEDxIi61735212
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Feb 2026 14:13:59 GMT
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id F10BF2004B;
	Wed, 11 Feb 2026 14:13:58 +0000 (GMT)
Received: from smtpav01.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6669B20040;
	Wed, 11 Feb 2026 14:13:58 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav01.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 11 Feb 2026 14:13:58 +0000 (GMT)
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
        David Hildenbrand <david@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>,
        Vlastimil Babka <vbabka@suse.cz>, Heiko Carstens <hca@linux.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>
Subject: [PATCH v9 0/6] x86/vdso: VDSO updates and fixes for sframes
Date: Wed, 11 Feb 2026 15:13:51 +0100
Message-ID: <20260211141357.271402-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Authority-Analysis: v=2.4 cv=KZnfcAYD c=1 sm=1 tr=0 ts=698c8eac cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8
 a=yyHzTi5TPZ6eMx7n6w4A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjExMDEwNyBTYWx0ZWRfX07i6X+fQf8zN
 c3Rc2RJMzzVpF375bNDDCP/Dutmx87jRngoa45cIAraPPJeHJH748qXpNHLe99uUUdtyjoM4Z8c
 YQFbVUXqszB/yNASEr3dnEULNKOaq2NPbqlD6gQDgYFIGEV4Rd/jp7Emk2V7F0ROk3u1VOmNx0U
 OI/xiPPnyUUS+MrD8zfP+gcgBueUpNW9XuA3Wv+XJ0uK4dRkCzXNQUEwE5toP5XRDGO03ZlDJGb
 TbfqMc0RkOB8cABLEIzLln5qRD+YZcGOQe7jx08MRFz6WY+qM4gcnkcxKH/ESVjGZW3XUGyBgdV
 Xm/gO1PWbcX2VCLIZ4LizNCsY6y1sTR1843mobX5QOTcrFu/PWenfmh9T89F9a0ub1shMkWnFgO
 c98JwA1naCOOK48mDgkSH1AYsLzIMWFKmWTZi9rhgSHuvr5ix/6xw4tq3uaS/4MOlJbgS55/C7V
 uaMhAJN8DRq2UgdTBPA==
X-Proofpoint-ORIG-GUID: fYxGIuKxI2IysMn88FGH_RM0GYztilz-
X-Proofpoint-GUID: Cud1plyvitWwUQ8LOQUCZYatGYKgBM46
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-11_01,2026-02-11_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 impostorscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 phishscore=0 malwarescore=0 lowpriorityscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2601150000 definitions=main-2602110107
X-Rspamd-Queue-Id: 8484E80008
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: rcf4yjstire86w41ndcj6omijyk5m816
X-HE-Tag: 1770819273-214608
X-HE-Meta: U2FsdGVkX18zr7exOEOeCssXKL03B87qe2JnNDV1z5vxvvs31zvzmzxM/Xe9e8Sq/BG51pVTDfOVS17mKyMz9wR7MNwFDBhyhFhm7T/IJvfJ2mCV2HXPV0wcPJ0Pbaij5wA1Z2kVhd2OOjxLsc1ao/RgD3/G2B+cXoad67TGONWq/B4fvoXY1dqmtLurqu3zw2a9P4c3hwBsrRhdAfqJM4HY2QbOA9GH5cmw6F5bABHCzxXlNLb9HnCYNRaaYW66s5MKYv0h2RUUhW2zAZyq2+V0g15N0cfwc0fRdwjo1hW0EJ5A68/xZ0pa1I1bfgbeollXkQ/kpuSSV7SfyYT9mekILCAGJhp3tSlN91fZ6gN4NHfzlDMCQ4J7KEvbwxIhuh7BFm6jKiG3Y49PTEkfmXc9ns6SKxheE2Ay5z/GgABnruc+MUWnkHVrkc+lgnvYu2+Aw6ztctdQd5EggblFt0IE6vAYnqU3uysmYBCg82Ggli00c7+M4p3/7MtTOfJLYWa5IBEPGr3HT8XBSAJ8sEQRdAxiPk1pD8yYYeCF+KcpVSYnoIVAx9kwf2u2rJUN26Bivig1F5Oq2sbD/DIp3EkHZSvl00S5QhxAHBgu32FRz0svc6T0PMfHa4JB3SslqlKg/xdBLtQf/pFlMmgtVtF5Fui6FFvSTGy/pT6TC85BzkrMY8tfegawh5JrT0HFH+FTm0abUqRnypqYILdjLK+uopNX5RTUb1ZKyZr9hlIqRkm4M79Z6p5Pn2qrHI/QF8DcTNzpDtxvIxLZmjCv/5C35rv3UhV59UUPxg2MX+nlyrazWzHjme+GpRAFF3pt4DXtDKp6aHmx/AW/aGT+QCOHjr4+sE9U2EfFamJJ/asVVZchLU8YuJ0LNjuDUAvXXbVTB4B4aVIYF4s1lebp3R6RV/mp9Qo+uXAjUoV+98VKOa2StDk+1sqIOaWIX2JX7RFO/XVmT5wN40FzVqy
 9hqfS5S8
 nIZFWiP93+iQgaqoEh1Gb7xe8z8JTkf7xkfq+V2DgLcopelcAh1RwpbyIJ8h4c4fw7I213ebTwDzqirU4q2YUp3LT15uVNIvnCyxN+5zie551h1lLstOPLJX5MWZ7GYmQeSJIY6s6pRKXv7Sg1ddCy1bKr7LxviZPl7iakNLASTex+bjYXzoIqoRM/XadWx9wkimuAbFsMAzCwiz3KS9pGETeMASqn8sYsZkBnlLf9cZk2AjYArlFmjwMko5+k7upDz/xgGCmtSVTmw6TXszrX+lCNGQuHOS5d4V6WRByPYIazf5wZznhMrSOTa0fFU127NL4gEUEY/qmvFZU8Y35gglnno63hOk5pugv3SF0ewnt+L+uuu8Ib8VqsA==
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
   https://lore.kernel.org/all/20250425023750.669174660@goodmis.org/

This series focuses only on the VDSO code. They are helpful fixes
and updates that doesn't rely on sframes (although the last patch
is sframe related).

This series applies on top of tip:x86/entry:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  x86/entry

Like the unwind user sframe series [1] it depends on the binutils 2.46
release to be used to build the VDSO with SFrame V3 stack trace
information (using the assembler option --gsframe-3).

[1]: [PATCH v13 00/18] unwind_deferred: Implement sframe handling,
    https://lore.kernel.org/all/20260127150554.2760964-1-jremus@linux.ibm.com/

Changes in v9 (see indivicual patch notes):
- Always define KEEP_SFRAME to either true/false in specific VDSO linker
  scripts and use #if instead of #ifdef in common one. (Peter)
- Reword patch 6 commit message to provide more details.
- Note: Binutils 2.46 with SFrame V3 support has been released.

Changes in v8:
- Discard .sframe for x32 and x86-32 VDSOs. (Josh/Indu)
- Define CFI_SIGNAL_FRAME for !BUILD_VDSO.
- Drop .cfi_sections .sframe in dwarf2.h in favor of the explicitly
  specified more specific assembler option --gsframe-3.
- Incorporate missing changes and review feedback from Steven's v6
  (I erroneously based my v6 on Steven's v5):
  - Reword patch 3 commit subject to Steven's v6 one.
  - Remove SYM_F_ALIGN in __vdso_sgx_enter_enclave(). (Josh)

Changes in v7:
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
  x86/asm: Use CFI_* macros in SYM_FUNC_* macros so they can be added to
    VDSO
  x86/vdso: Use SYM_FUNC_{START,END} in __kernel_vsyscall()
  x86/vdso: Use CFI macros in __vdso_sgx_enter_enclave()
  x86/vdso: Enable sframe generation in VDSO

 arch/Kconfig                                  |  7 +++
 arch/x86/entry/vdso/common/vdso-layout.lds.S  | 17 +++++-
 arch/x86/entry/vdso/vdso32/system_call.S      | 10 +---
 arch/x86/entry/vdso/vdso32/vdso32.lds.S       |  3 ++
 arch/x86/entry/vdso/vdso64/Makefile           |  1 +
 arch/x86/entry/vdso/vdso64/vdso64.lds.S       |  2 +
 arch/x86/entry/vdso/vdso64/vdsox32.lds.S      |  6 +++
 .../x86/entry/vdso/vdso64/vgetrandom-chacha.S |  3 +-
 arch/x86/entry/vdso/vdso64/vsgx.S             | 18 +++----
 arch/x86/include/asm/dwarf2.h                 | 52 +++++++++++++------
 arch/x86/include/asm/linkage.h                | 33 +++++++++---
 arch/x86/include/asm/vdso.h                   |  1 -
 12 files changed, 107 insertions(+), 46 deletions(-)

-- 
2.51.0


