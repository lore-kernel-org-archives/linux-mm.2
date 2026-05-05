Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D38D6CD3427
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:34:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28CA6B00AC; Tue,  5 May 2026 08:34:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E8C1F6B00AE; Tue,  5 May 2026 08:34:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D77DB6B00AC; Tue,  5 May 2026 08:34:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C0D206B00AC
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:34:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 734B68C627
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:12 +0000 (UTC)
X-FDA: 84733308744.12.21DD47F
Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	by imf20.hostedemail.com (Postfix) with ESMTP id 211081C0010
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:34:09 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GYO9Kxnw;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777984450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wDW++CGHOP4UoCeI+NHJp/Rz+4K72y7e5MBlqd2dS5c=;
	b=LQ1vCmqNE7D2oUtsP2npjhodFylqWBNXRWNamv3R/2zbqBaRATGE8wOz0631wj+7AWFTNt
	ON3+1lQEpeeu64ktVxOtFm0flrLDvnmhM0k93J68OQwrH33kHpf/cRvjgA9VQC3r/mGFLE
	MpZjRE15Njqh5bv3Ai0zMLSjJYJLxLk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777984450; a=rsa-sha256;
	cv=none;
	b=GqAGnAxf6NkuX9Amkm0BiND8zaQ/RY3UfTxhCZsaJ1DqjquD356iH6ps0IOvT2Qpo9kLMy
	SS3ZHueb3SEsG07ve2/u4ih0gAyhm0kPfgv9/4SDtfy8fPshLJdeO6JRdWGpgpkJHdTV9v
	ZSzYLFXhNJG+8xVw/FmcFGN5a5w7K3Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b=GYO9Kxnw;
	dmarc=pass (policy=none) header.from=ibm.com;
	spf=pass (imf20.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.156.1 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 645CD5SL599575;
	Tue, 5 May 2026 12:33:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=wDW++CGHOP4UoCeI+NHJp/Rz+4K72y7e5MBlqd2dS
	5c=; b=GYO9KxnwyvMIMwIxYDtR7UfZBkimR6Av636MQKpLpFFjzhlsXI8mEY3fh
	UbBsj0MRY7iUE1ICpKldsqLdnHr82FtPJQ2H0VBskmFIYtx29HeKofziiK/ghA+m
	K81+3v8b+L/7/aYciP/sKb5xquMEGkngFpdJ/izw+wDMs8TkuDJDbdl2BBUkSk8+
	FtgB6xasfYwHB+rnyxZfFizr53jnlU9Mk1URuUU9U0bxfqSFJ2WsnmySflVO+oKg
	HneAU76p4bgCmi+wHwpgSKngqiT8To4edsuqzZGx3tM5pDgR9mm58SA2M1qVQtDx
	tcmq7b4iCCHNvzBzGTj0fgk4lYcDg==
Received: from ppma21.wdc07v.mail.ibm.com (5b.69.3da9.ip4.static.sl-reverse.com [169.61.105.91])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4dw9y1bkkg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:47 +0000 (GMT)
Received: from pps.filterd (ppma21.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma21.wdc07v.mail.ibm.com (8.18.1.7/8.18.1.7) with ESMTP id 645CORDk016273;
	Tue, 5 May 2026 12:33:46 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma21.wdc07v.mail.ibm.com (PPS) with ESMTPS id 4dwvkjsj4v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 May 2026 12:33:46 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 645CXgwl45351184
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 May 2026 12:33:42 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 29E912004B;
	Tue,  5 May 2026 12:33:42 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B230D2004D;
	Tue,  5 May 2026 12:33:41 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Tue,  5 May 2026 12:33:41 +0000 (GMT)
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
        Ilya Leoshkevich <iii@linux.ibm.com>
Subject: [PATCH v9 0/6] x86/vdso: VDSO updates and fixes for sframes
Date: Tue,  5 May 2026 14:33:34 +0200
Message-ID: <20260505123340.3770025-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-ORIG-GUID: hy-u69z9qrLRbeoEPEQKKikpMdUB_vDT
X-Proofpoint-GUID: mMiaA0kVCfuIXUlGhc8SwxpOlWBGYvvT
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTA1MDExNCBTYWx0ZWRfX403IkCiWrITO
 u6nRm6SHFiimTS4/rLl3yOHyfY+/3EUwgAT5lFQvAmAFSNAcytjflpkvFuPDqQDUqGwuUthBu6A
 TvyBAhJ5M6px8iyqerIb2EGmK5gBc+VRhoAGP4EDwg4UstqgZzcRGs9Qivf85IXoxARXikxO6bj
 j6oaMkEzM1o7GtkLQQ407Pid10Cx5NGtPEAP1RuiqgmQ1LxR/FfjyQ13PrcK9ulE8T9RTr+N2wp
 rRWihyfpYEvsU3E7pkfbJWx2dlKboPWcHSd3HEg8teFgCHiA0wyFkvJ6n9BOAFM/40ingpxwGUe
 eTvXICsfI6EoQbwyalEjR1E7R797ha9qPzcpWPRoo5xqx0DG43gAxoW40PxKy6WYJK6AQ56KrO3
 TBAr/MFfs6nIsCfowIrzML99aoqcVYRut0Vr/VcfaZ3Wz7DW0Tx2sLTwxxJ4gbKEkBrL8B6lpj3
 kzNONLNL2KGglivo+oA==
X-Authority-Analysis: v=2.4 cv=UbFhjqSN c=1 sm=1 tr=0 ts=69f9e3ac cx=c_pps
 a=GFwsV6G8L6GxiO2Y/PsHdQ==:117 a=GFwsV6G8L6GxiO2Y/PsHdQ==:17
 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22 a=RnoormkPH1_aCDwRdu11:22
 a=U7nrCbtTmkRpXpFmAIza:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8
 a=yyHzTi5TPZ6eMx7n6w4A:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-05_02,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 spamscore=0 lowpriorityscore=0 malwarescore=0 suspectscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 phishscore=0 impostorscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2605050114
X-Rspam-User: 
X-Rspamd-Queue-Id: 211081C0010
X-Rspamd-Server: rspam04
X-Stat-Signature: u6dj8xbcoch5spctctzsysa3yi1gnsdj
X-HE-Tag: 1777984449-977687
X-HE-Meta: U2FsdGVkX18XiO0c5Tf7yy/nm3JwkhYKwrn1hO02ujkTugHXu74LduuniNrxOXfqnHciaO1zDV0FwR+PCFbDaMOO9DqRA5SR659xEw3cneleHDpBA4OtyJTmkF/1yN0oNw/2kcgDmvT7zaI7MkBLYCLAbj98wNVSEXX7bSM4yfuVaNjRxEOB9SvBuFwaP/UzNC9auzStAjTKAXJ20IeRE5qNh+OMH4vuDc0BOoMtvk31isq+VdMVlWL0zQZpROtSN8KdCOVYE3ElZ1IuSkmp53U5ws2XE6pQQmcL9GOV3uYbYbHVxuoAjceGMPilM2TIKoQ0CJcM9NUkq/MYDkXthIFS1oH7GSpFrxL74g2TDBcstohtnczU3/9+KZ/edU7iA9gyzLMo2h4uhtkrvy2gk1ZvyMFVdsCml1R+iCbjzRxk1+A5l9bnJLN8acCsb2pQRVconcoNRtX4WL8V8FaYs5Me3JkL/dB8h0Afr5Byrq6I4SNkXq8g9mcrdxt6GT/N7gTUiRM5WHJHgcn0AffW74Wi83EzDguot5tyFjowcu22BDJws/kr5e9gnZCafHo6S6+MN1bT/l+R4QfVY3uC5pgFQwIpmGmcseuX4BZ+UNAwpvnNmuOQnAZU+C/Y6RQcUcyCk3phEZUvY62Oux6VT7ytKJGmEVlEyTSpSU9RxlldlqtVWmIlrMb0rF71X3jaVrbmrHbeSxF0DpLbJenoDn/q7JdMriIh3BNlRodf4XDi4kL37I+I+XOzixwIh9IK3aICsUGS2HEhczjyKKvht5SKa7naRRwgsy3b/p+ueLMNpLL1dsdR8wu/wn3oldscvAgPZ7IJPVcK5eJ0PxcJs2PqVgUZO7FNhO/03r+NV7X/OgEFjHpJoJukaTCLq4PKSD21uqGs3n3dL2S/+vfQBu9dCH4dD/7F6jWkVx2t6D6dzKRPwYWcmzmy1hbKABYatIQbpDp7Cfokfy1lhTY
 gvOLivcO
 h/LwmZ3h4CYaMu1htCCVZGtp1Ke7BGnXUL1IoEGDzwXPm2r76R0iKLJR/522kWS38nCyNU11XpEt7dPOxrrmhcPNDTY/RJP2g5Jg2O2Omi67UG9+kvT8I1MJOyIAhAsQwLEYFn3aMG0qZ8DK7k58o75cZZkAqDCeLZZlwHZumLrc07YOKFY3iSrOIIKgCFGzXuxfnp85CcbsX5igD0ttZesvN8iuXIdWpEP0T37hLxC2wJWwDwkgnYOW8MDtlhFV7dPJbtomPyv+X2x1zrBFdGed9OIIJlnVtuAk1
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

This series applies on top of tip:master (a375022d6383):

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git  master

Like the unwind user sframe series [1] it depends on the binutils 2.46
release to be used to build the VDSO with SFrame V3 stack trace
information (using the assembler option --gsframe-3).

[1]: [PATCH v14 00/19] unwind_deferred: Implement sframe handling,
    https://lore.kernel.org/all/20260505121718.3572346-1-jremus@linux.ibm.com/

Changes in v10:
- Rebased on tip:master (a375022d6383).

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


