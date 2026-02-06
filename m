Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA86EE6B4E
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 19:37:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B10C36B009D; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CD2D6B0098; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7FC386B009E; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5A0F96B0098
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:37:16 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1B0F11B23D7
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:16 +0000 (UTC)
X-FDA: 84415040472.06.940F244
Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	by imf17.hostedemail.com (Postfix) with ESMTP id D21A840002
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 19:37:13 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Mcwd/XCp";
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770406633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ma34NLEtUZgBq0xsOvu4va3yuInPjfwgpEJy6PXbUus=;
	b=KKOs6bRznWE4Wry1M8IjupSyX5iXcyFp/HQlQwhqdEEF71noQKEbsbWSB2nhLfwWihGh5f
	RXaFLT55XbGeVs1q0HWsZna6i0h2jWux3KI2TyM8en03BUAP1XrPQw1T0bugWK7fwyg3w+
	DyE4PV/xs2iU55pSUOZ4EfHlMnIXK0s=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=ibm.com header.s=pp1 header.b="Mcwd/XCp";
	spf=pass (imf17.hostedemail.com: domain of jremus@linux.ibm.com designates 148.163.158.5 as permitted sender) smtp.mailfrom=jremus@linux.ibm.com;
	dmarc=pass (policy=none) header.from=ibm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770406633; a=rsa-sha256;
	cv=none;
	b=NYZTF4Z1DLPw3Sjh4ackRBTlr24agDP1rfeG599ElEEfynV2DcyQjMkFTo8GgXyzjXRYCT
	QsHNM55MOLx5J+aNj+ca/e+P1AY+v9MF8QgjiK1sFmv2knF9E/4vdVWpRMJCUUwznnJxjD
	V5mWr1NaDAztxxiITRWl0AZv8XXpRew=
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 616CshLf023156;
	Fri, 6 Feb 2026 19:36:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=pp1; bh=Ma34NLEtUZgBq0xsOvu4va3yuInPjfwgpEJy6PXbU
	us=; b=Mcwd/XCpvUGsoN3qMJzQF0mnCsfgJV/aiWecEfqqE+AfJUa5fMxMqvtw/
	70Hupj9D4y0aeiih7jzFdjlrxdalDorlp6J0DcLRFBImOThAa56GYfi8OL2NGyje
	W9JK8Dc5x/XB3JajJ8gOiBV5vUy0BoBXFPOkwCIcKU0dqjpVtWa7sY4k9QOC7B20
	1GhhFzJUFp0YDVpabmxcryjC2DPnIag/erhxSQSYIkwQeM9SpX/63TqKElB1p+5x
	yGMRyT9CSqX3jWfbTWO6hF8CuE474Hbvwm6MMX0DpvsPLR6A7Ws9EU0QIW2yLnOr
	nQXdI1UfueKFZhvRuIawoDZGPm2/g==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cwhvkk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:50 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 616Jani1009456;
	Fri, 6 Feb 2026 19:36:49 GMT
Received: from ppma11.dal12v.mail.ibm.com (db.9e.1632.ip4.static.sl-reverse.com [50.22.158.219])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4c19cwhvkh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:49 +0000 (GMT)
Received: from pps.filterd (ppma11.dal12v.mail.ibm.com [127.0.0.1])
	by ppma11.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 616HQYTg027353;
	Fri, 6 Feb 2026 19:36:48 GMT
Received: from smtprelay03.fra02v.mail.ibm.com ([9.218.2.224])
	by ppma11.dal12v.mail.ibm.com (PPS) with ESMTPS id 4c1xs1qb4h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 06 Feb 2026 19:36:48 +0000
Received: from smtpav07.fra02v.mail.ibm.com (smtpav07.fra02v.mail.ibm.com [10.20.54.106])
	by smtprelay03.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 616JaiFO56689142
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 6 Feb 2026 19:36:44 GMT
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 13C2B2004B;
	Fri,  6 Feb 2026 19:36:44 +0000 (GMT)
Received: from smtpav07.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 8F98820040;
	Fri,  6 Feb 2026 19:36:43 +0000 (GMT)
Received: from tuxmaker.boeblingen.de.ibm.com (unknown [9.87.85.9])
	by smtpav07.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Fri,  6 Feb 2026 19:36:43 +0000 (GMT)
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
Subject: [PATCH v8 0/6] x86/vdso: VDSO updates and fixes for sframes
Date: Fri,  6 Feb 2026 20:36:36 +0100
Message-ID: <20260206193642.1580787-1-jremus@linux.ibm.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA2MDE0MyBTYWx0ZWRfX8mKZ+9vMgaYf
 1RpUBWYDJ42YbJO7QtGgFkZcmkBgvqyaaGyEGFD3IFv8rEx5d7G1lLn97OHbgXTN7EqjcBSJox9
 8ML/uxGNtu2tZql14ZYfHUiAr+kZHxNeD1dClqLaFoynUBSQ+vqv/FCSgOZKTqLm5PsSK04j63M
 aj7B/SW7AjmFJqGE6RHdg2V63tXORo6GmZrz+wSlzn6eSMA+goZqGi8Y5ncadHMllOQmZFUtrod
 DkBV7dS27vtNzTFYg6PuFWChoV9nTDOMS0mhlOH5T5GAmB2YnZxknMnfDKc06oBgyZPuF8bGLxV
 xy1W5zQ3mzk7HrerlEExvq0ns+aBpOVJD2phClXKg7FTS7K4x2o7htfjw5vueUkme8U4WGwFghU
 ej5PnNgLVV+hBYrOnjWl3B36gv1gkIK2rkpxMtSIs9YFsvTLuXBT07ORa1wfsx9Mnn2Is9S+rp4
 1X+smqbDfIk53LG/kuw==
X-Authority-Analysis: v=2.4 cv=UuRu9uwB c=1 sm=1 tr=0 ts=698642d2 cx=c_pps
 a=aDMHemPKRhS1OARIsFnwRA==:117 a=aDMHemPKRhS1OARIsFnwRA==:17
 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=meVymXHHAAAA:8 a=VnNF1IyMAAAA:8
 a=jr2uPhgrsSS0o8xo2gsA:9 a=2JgSa4NbpEOStq-L5dxp:22
X-Proofpoint-ORIG-GUID: QNaf73D0vqY1_4eUemPIwjnYjdStnZCp
X-Proofpoint-GUID: XpSLgiwr41UcTlOa0i9XaJmodtrXicv8
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-06_05,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 bulkscore=0 adultscore=0 clxscore=1011 phishscore=0
 malwarescore=0 lowpriorityscore=0 priorityscore=1501 impostorscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2601150000
 definitions=main-2602060143
X-Rspamd-Server: rspam11
X-Stat-Signature: 9cey4oyrjsj7rqst5d6aaxcket7m8iwj
X-Rspam-User: 
X-Rspamd-Queue-Id: D21A840002
X-HE-Tag: 1770406633-320273
X-HE-Meta: U2FsdGVkX1+BC5NCIZHnrjr2IQt+BT4EICzAlv+IIQiR4A3wPH6rHc2PJbZEEuLoScGFuPZV6/2uq8F3o0UiXAc1MlVfAAKYEWMhVdK9TOjyB7mgEgCK970m1R9xThGIX0gbpIuDvGZp/KO2C2SAD8lgHekdjqRn9WppsqSK2QslYomFb4jw/LqZjrroK7HHS1cdC98MtlzpMGu1a75WeJCGBnxobwnBpjGaT5PUfL5+sGXTwciNvwN6yLWqtrdD2RyoOVQZIRX0C19eoxJPwecPI1V+iAjfa2sZ2U+eO8gHfwEeSMxXm0FfNDaCB9iVe5AzYRms96wzC4hiokViSnX//GIPrFZjQPBLor35JU/QJRkmftIFyXxq8dm7xiqTtGup1iNdNqrmGR6Kvqf968pAOoLR8Tu22DuZOvMdysgsd9P7uSB0GpCe79TsfBAXSj7SEw671bzKfOAYQeejQ5rekD/7uC/0qsFud8LIrj2hijMTYY/NJaswejCa24k/QwwX2aqROyUVG8L43zBtclnoJXEgN5E+qaufCUHzJH7QxyRvWBMZksMcOpoTjqKu+UCzLj0tCRsOKVgELoCji9JSdpt1WPVwLByQMfLyYZDLTmyci6tYaNsLCFwljljxx08HJHjqjO2uo45hq2FyXIrBXzmY7Bf+rN1C+u9farf5sUMMvxsSKIoLhsjaQXvxF9jIa7k6zG4tjcvBGJQZh8WfOqVOUzEjAq+bZKkBWi/gfs3yMVoovQ/og7vq3zQ0PIKaJHbZssyqBPb3E/VjfcLeumxCo9VqRp3rpP9voWcXQhg+sE7bJp6UDdcddb64OyFdi7wXETf2+c/LTGHnYdLwHvUGYuPcP2hyL4iL7JS9kAXv1Kxg6c7BqZ9mxbDLHZdm61tHplLUsHM7Knk6pNOCDoXowdy5k26uOAeaEotOqv09HtttF8Hp0GL1fiHoGiFGVwQIt3cgLEsqbph
 iCyc8Cd/
 i9Tnu/u0LcnDOKaBwfNoAeKHWt2NJEXD2Nf1BId8qgANzshfpnOneNhif5ekPN4VjlA6jLS8bxGqr5RXskjKUxcQHYFwOqFt1olPqX08/em+gvklnzNoRxHDM+paHh+YzodsKiOSTyewEDcEFrttbh2G/Ijjr0czNMu1Jj8bzyVM0c4o3IOpP9CCUgGM3YjqZhd/mJ19FnjEgUU4MDeCz0TnOwku8Mhl2QBjxH/99q/Thu0JUE3cNlX0jXvIJM9Gr0c0SwH7Y1nuNtocc4TBx9E0ysAqDB0VLog/mHaFsd78i+j/c1jjJXlO9upEpV4fnO4BYGlpYjEqr/PgHrUdDnoe5pJsp0WGAjfyF9sgeJPtXNddCjVAjB2qj2KV4H+K11XHl
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

Like the unwind user sframe series [1] it depends on the upcoming
binutils 2.46 release to be used to build the VDSO with SFrame V3
stack trace information (using the assembler option --gsframe-3).

[1]: [PATCH v13 00/18] unwind_deferred: Implement sframe handling,
    https://lore.kernel.org/all/20260127150554.2760964-1-jremus@linux.ibm.com/

Changes in v8 (see individual patch notes):
- Discard .sframe for x32 and x86-32 VDSOs. (Josh/Indu)
- Define CFI_SIGNAL_FRAME for !BUILD_VDSO.
- Drop .cfi_sections .sframe in dwarf2.h in favor of the explicitly
  specified more specific assembler option --gsframe-3.
- Incorporate missing changes and review feedback from Steven's v6
  (I erroneously based my v6 on Steven's v5):
  - Reword patch 3 commit subject to Steven's v6 one.
  - Remove SYM_F_ALIGN in __vdso_sgx_enter_enclave(). (Josh)

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


I verified as follows on x86-64 using a binutils 2.46 pre-release build
that only the x86-64 VDSO has an .sframe section and GNU_SFRAME program
table entry:

$ make defconfig
*** Default configuration is based on 'x86_64_defconfig'
$ make arch/x86/entry/vdso/
  OBJCOPY arch/x86/entry/vdso/vdso64/vdso64.so
  VDSO2C  arch/x86/entry/vdso/vdso64/vdso64-image.c
  VDSO    arch/x86/entry/vdso/vdso32/vdso32.so.dbg
  OBJCOPY arch/x86/entry/vdso/vdso32/vdso32.so
$ readelf -WSl arch/x86/entry/vdso/vdso*/vdso*.so | egrep "File:|GNU_SFRAME"
File: arch/x86/entry/vdso/vdso32/vdso32.so
File: arch/x86/entry/vdso/vdso64/vdso64.so
  [13] .sframe           GNU_SFRAME      00000000000007e0 0007e0 00012b 00   A  0   0  8
  GNU_SFRAME     0x0007e0 0x00000000000007e0 0x00000000000007e0 0x00012b 0x00012b R   0x8

$ make defconfig
*** Default configuration is based on 'x86_64_defconfig'
$ ./scripts/config --enable X86_X32_ABI
$ make arch/x86/entry/vdso/
  VDSO    arch/x86/entry/vdso/vdso64/vdso64.so.dbg
  OBJCOPY arch/x86/entry/vdso/vdso64/vdso64.so
  VDSO    arch/x86/entry/vdso/vdso64/vdsox32.so.dbg
  OBJCOPY arch/x86/entry/vdso/vdso64/vdsox32.so
  VDSO    arch/x86/entry/vdso/vdso32/vdso32.so.dbg
  OBJCOPY arch/x86/entry/vdso/vdso32/vdso32.so
$ readelf -WSl arch/x86/entry/vdso/vdso*/vdso*.so | egrep "File:|GNU_SFRAME"
File: arch/x86/entry/vdso/vdso32/vdso32.so
File: arch/x86/entry/vdso/vdso64/vdso64.so
  [13] .sframe           GNU_SFRAME      00000000000007e0 0007e0 00012b 00   A  0   0  8
  GNU_SFRAME     0x0007e0 0x00000000000007e0 0x00000000000007e0 0x00012b 0x00012b R   0x8
File: arch/x86/entry/vdso/vdso64/vdsox32.so

$ make ARCH=i386 defconfig
*** Default configuration is based on 'i386_defconfig'
$ make ARCH=i386 arch/x86/entry/vdso/
  VDSO    arch/x86/entry/vdso/vdso32/vdso32.so.dbg
  OBJCOPY arch/x86/entry/vdso/vdso32/vdso32.so
$ readelf -WSl arch/x86/entry/vdso/vdso*/*.so | egrep "File:|GNU_SFRAME"

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
 arch/x86/entry/vdso/vdso64/Makefile           |  1 +
 arch/x86/entry/vdso/vdso64/vdso64.lds.S       |  4 ++
 .../x86/entry/vdso/vdso64/vgetrandom-chacha.S |  3 +-
 arch/x86/entry/vdso/vdso64/vsgx.S             | 18 +++----
 arch/x86/include/asm/dwarf2.h                 | 52 +++++++++++++------
 arch/x86/include/asm/linkage.h                | 33 +++++++++---
 arch/x86/include/asm/vdso.h                   |  1 -
 10 files changed, 100 insertions(+), 46 deletions(-)

-- 
2.51.0


