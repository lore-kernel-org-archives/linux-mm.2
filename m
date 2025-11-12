Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99E3ECD37BB
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF27D8E0005; Wed, 12 Nov 2025 15:23:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECA1C8E0002; Wed, 12 Nov 2025 15:23:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E06628E0005; Wed, 12 Nov 2025 15:23:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CFD7B8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:23:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 668D71A0344
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:31 +0000 (UTC)
X-FDA: 84103080222.06.3865C56
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf26.hostedemail.com (Postfix) with ESMTP id BA70C140003
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:23:29 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=DQQX1usU;
	spf=pass (imf26.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762979010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GacBjPJEXkeyFGvcySDne54yt1x9SXUnR3yJ7bSJhAE=;
	b=IkSOIUJRpWUJ3TbGRdfexowKD3AjgDPIEmXzJE31+YnOm60EeOaniS+fhhFTjHDmMgmN3f
	YwiLvw2nPNEoIZYo8YEmtuRiNVcjFkH/AoDh+kA+WqOxf0kziQQmyM7aKGo4hPY9MJMaJO
	rRw2MjA86E1chY6Lp+6nudCVQfuHJK4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=DQQX1usU;
	spf=pass (imf26.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762979010; a=rsa-sha256;
	cv=none;
	b=GNKDBz+PG1zpeCtlEXCc/ausU2J1B86hQyVvzFb6M8/e7/p1wfdjxrSb6Z/UplltPPv6hI
	veBX8NPLYtbG3UP+wBUSeLwCRjdZd//Klf+Sdy42K8uhGMgaCpeoG2IVMmaeMa+Za1uIu9
	XO5UqH4fyneO6Ryb7nMs8RGfJ0Xyf84=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKN2Lw978372
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:23:03 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKN2Lw978372
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978985;
	bh=GacBjPJEXkeyFGvcySDne54yt1x9SXUnR3yJ7bSJhAE=;
	h=From:To:Subject:Date:From;
	b=DQQX1usUIahqMjsKWNcVJ0i0dpE90Gmy5bZ05KT7Utqs4KRgS57x17OedKRlTseg5
	 CHOzEX2rHZ9efgrpda3VtxZDwHIpPOJMo8vM8fFrfGSpc/w5wvUjHlZnWO6WDcSOlH
	 KWW/IvjCAy4iip+hB9m/spAcgc8fVjl8Z/O+nxZx2IGvH5LBoZzzbZpQWDuknN4oNH
	 FMpF6W9ECFEwVuPdBCRC3Gm2DiFjQ6YVLV38ux1PSao6Eh5nCpz4BhcIDVvqrkDWBx
	 SbLBGBjNY4B6oGJgzeepV0a45I+/UNJaOWR65JJH6qIX+FMJXF2UxScZSGqvrHFv1u
	 oL6C3vpwGfuww==
From: "H. Peter Anvin" <hpa@zytor.com>
To: "H. Peter Anvin" <hpa@zytor.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        "Theodore Ts'o" <tytso@mit.edu>,
        =?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
        Xin Li <xin@zytor.com>, Andrew Cooper <andrew.cooper3@citrix.com>,
        Andy Lutomirski <luto@kernel.org>, Ard Biesheuvel <ardb@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, James Morse <james.morse@arm.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Josh Poimboeuf <jpoimboe@kernel.org>, Kees Cook <kees@kernel.org>,
        Nam Cao <namcao@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Perry Yuan <perry.yuan@amd.com>, Thomas Gleixner <tglx@linutronix.de>,
        Thomas Huth <thuth@redhat.com>, Uros Bizjak <ubizjak@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-sgx@vger.kernel.org, x86@kernel.org
Subject: [PATCH v3 0/9] x86/entry/vdso: clean up the vdso build, vdso updates
Date: Wed, 12 Nov 2025 12:22:45 -0800
Message-ID: <20251112202258.1310754-1-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: BA70C140003
X-Stat-Signature: 5pby4oypjgy8euox9umefbijme4ct1rn
X-Rspam-User: 
X-HE-Tag: 1762979009-140598
X-HE-Meta: U2FsdGVkX19L4+M9igaQTtpyZUnvGWjH1QbsBkY9Em6r4Z7bgdQxwYPpt6N+kGAl7XeqGAbU5V02pAgXQszecmeqHd6h+OqMi4uvTY+3Ax2sjHvOAStOd885o6BP6rlt3PVZmfq7W41eXMoWt6C8MlCQmD0oJ4RKfJmeBSYjQOCB4CpjbNrzaBH4NkPoNF6ZZtaianTB3RKaEkJyusaj5PrwHdm5lSQEJZBxlp5P7sD+IdpMGWCzjiui6Te0tzsCNXsqRkwSUtDUTIYECUbgI1N3+odXZgA2lGJx/WDTb7G3vG2PoYo5aLlaNIL44LC2dF9djoBHmAM0rg3cPi2oie5pfadx0Qi9zSU8v4IhLIw4fuptO3O18VyR53tlmoeeQbL0UaMNQ0mrPhIye6kogpbAf6/BwB/W8VTHIPPmbbc2RuSH39BAMJrRp4Z2IpfaLSJ2SlnGaV3rWvmZK7WzOvxbX/viZxyqDqbM5G9Cm4YidBn0iStd+ms6/nja4TON6lWRtw005Aapg/cJpRsOeS4067+YIS51PAYGUXpWZzs9pYVvs8lT+XLhZgYM2aFzzFg/ngJTyvqHR8VQRNeorCX4i1UYwNEl8s5ifps1S4cYr6lDKmtVIjhjprXUh5/x+JHmFbqsHDoQ4ox3nS52QzvkabVVWT5i/3XDr5hZ1EPWbAAINfLGpiDwKKjaCRNRQPMxcZ1CiS+5RV82umNGdFmtKPNmipHfqNHNZaDRBtatHhlTFixov32V8u+EDOY0iN6KOy+SYb0aIo5u3msKbFGng4eCU0zRRpoMrfBAkCrXXRAGSgoZKMnq5a6CUd/DChRcT7X23GxHraBwajh8M44hSLcATPs/2C0bLSBZd4DI6YfOYCVknpYYaMinuebfBLF6iKCHSvR6ZShizOw+kSZy/sTUqollFksnK4iiMDCkKPxojuMJwIjSZ8U9QUoATVDtDmBOHR9OEflZbuR
 v9MvVhfq
 ISPRHyJNUhbg1CrA+zUDg9JWsU8QjCdPGqv/MZHxWkVjCUYuiWxJJE+X/o3FrdvVbkxC0HGkr29TTYTFicuy6fGiFECxeL2dncmVEsbyijXLxe0yLD2PDtWZtqhc4CZdV0KTkKNirNgEty8qxLGOQEZ6lmrS3vXhUPHGSywx2WdW1odCjnmODkI0LbyzvYyJLhBdD0eVnsm1aeRO1JhHl0aNCnqI9QO1E8JD/7q6T9JQJPJQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset cleans up the vdso build by building the 32- and 64-bit
vdsos in separate directories, moving the vdso2c tool to
arch/x86/tools, and by merging common code and especially Makefile
rules between the 32- and 64-bit vdsos to the greatest extent
possible.

Be more strict about sanitizing and standardizing the vdso build
options.

Disable CFI for the vdso until the kernel adds user space IBT support.

Modernize the DWARF generation vdso32/sigreturn.S.

Add macros to cleanly call system calls from vdso source code.

Add the GNU_PROPERTY and GNU_STACK PHDRs to the vdso.

When using int $0x80 (old 32-bit hardware or FRED-capable 64-bit
hardware) skip the stack stuff in the 32-bit kernel entry code and
call int $0x80 directly when used from C code.

Changes from v3:

  In arch/x86/include/asm/vdso/sys_call.h:
  - remove stray comment from prototyping (Uros Biszjak)
  - remove VDSO_SYSCALL6() since it would require special
    handling on 32 bits with frame pointers and is
    currently unused. (Uros Biszjak)
  - indent nested preprocessor directives.

Changes from v2:

  Too many to count - much of the patchset has been reworked

Patches:

	x86/entry/vdso: rename vdso_image_* to vdso*_image
	x86/entry/vdso: refactor the vdso build
	x86/entry/vdso32: don't rely on int80_landing_pad for adjusting ip
	x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
	x86/entry/vdso32: remove open-coded DWARF in sigreturn.S
	x86/entry/vdso: include GNU_PROPERTY and GNU_STACK PHDRs
	x86/vdso: abstract out vdso system call internals
	x86/cpufeature: replace X86_FEATURE_SYSENTER32 with X86_FEATURE_SYSFAST32
	x86/entry/vdso32: when using int $0x80, use it directly

--- 
 arch/x86/Kconfig.cpufeatures                       |   8 +
 arch/x86/Makefile                                  |   2 +-
 arch/x86/entry/syscall_32.c                        |   2 +-
 arch/x86/entry/vdso/.gitignore                     |  11 +-
 arch/x86/entry/vdso/Makefile                       | 162 +--------------------
 arch/x86/entry/vdso/common/Makefile.include        |  89 +++++++++++
 arch/x86/entry/vdso/{vdso-note.S => common/note.S} |   5 +-
 arch/x86/entry/vdso/{ => common}/vclock_gettime.c  |   0
 arch/x86/entry/vdso/{ => common}/vdso-layout.lds.S |  51 ++++---
 arch/x86/entry/vdso/{ => common}/vgetcpu.c         |   0
 arch/x86/entry/vdso/vdso32/Makefile                |  24 +++
 arch/x86/entry/vdso/vdso32/note.S                  |  19 +--
 arch/x86/entry/vdso/vdso32/sigreturn.S             | 152 +++++--------------
 arch/x86/entry/vdso/vdso32/system_call.S           |  22 ++-
 arch/x86/entry/vdso/vdso32/vclock_gettime.c        |   5 +-
 arch/x86/entry/vdso/vdso32/vdso32.lds.S            |   2 +-
 arch/x86/entry/vdso/vdso32/vgetcpu.c               |   4 +-
 arch/x86/entry/vdso/vdso64/Makefile                |  45 ++++++
 arch/x86/entry/vdso/vdso64/note.S                  |   1 +
 arch/x86/entry/vdso/vdso64/vclock_gettime.c        |   1 +
 .../entry/vdso/{vdso.lds.S => vdso64/vdso64.lds.S} |   2 +-
 arch/x86/entry/vdso/{ => vdso64}/vdsox32.lds.S     |   2 +-
 arch/x86/entry/vdso/vdso64/vgetcpu.c               |   1 +
 .../entry/vdso/{ => vdso64}/vgetrandom-chacha.S    |   0
 arch/x86/entry/vdso/{ => vdso64}/vgetrandom.c      |   2 +-
 arch/x86/entry/vdso/{ => vdso64}/vsgx.S            |   0
 arch/x86/entry/vdso/vma.c                          |  24 ++-
 arch/x86/include/asm/cpufeatures.h                 |   2 +-
 arch/x86/include/asm/dwarf2.h                      |   1 +
 arch/x86/include/asm/elf.h                         |   2 +-
 arch/x86/include/asm/vdso.h                        |   6 +-
 arch/x86/include/asm/vdso/gettimeofday.h           | 108 +-------------
 arch/x86/include/asm/vdso/sys_call.h               | 105 +++++++++++++
 arch/x86/kernel/asm-offsets.c                      |   6 +
 arch/x86/kernel/cpu/centaur.c                      |   3 -
 arch/x86/kernel/cpu/common.c                       |   8 +
 arch/x86/kernel/cpu/intel.c                        |   4 +-
 arch/x86/kernel/cpu/zhaoxin.c                      |   4 +-
 arch/x86/kernel/fred.c                             |   2 +-
 arch/x86/kernel/process_64.c                       |   6 +-
 arch/x86/kernel/signal_32.c                        |   4 +-
 arch/x86/tools/Makefile                            |  15 +-
 arch/x86/{entry/vdso => tools}/vdso2c.c            |   0
 arch/x86/{entry/vdso => tools}/vdso2c.h            |   0
 arch/x86/xen/setup.c                               |  28 ++--
 arch/x86/xen/smp_pv.c                              |   5 +-
 arch/x86/xen/xen-ops.h                             |   1 -
 47 files changed, 448 insertions(+), 498 deletions(-)

