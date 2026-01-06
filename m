Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4CE8CEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 21:20:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9578F6B009D; Tue,  6 Jan 2026 16:20:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 920EE6B00A0; Tue,  6 Jan 2026 16:20:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A2A26B009D; Tue,  6 Jan 2026 16:20:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 55B936B009D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:20:14 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 040F0BD6EB
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:13 +0000 (UTC)
X-FDA: 84302807148.08.FA961A5
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf06.hostedemail.com (Postfix) with ESMTP id 3113F18000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 21:20:11 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=HtOBDzSY;
	spf=pass (imf06.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767734412;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aI8MIw+sMa6PRGtTxYvVJEbs7tXT12sE7HZ5eTyFKjU=;
	b=AymcK7vZbsVawiS7CbQofICe8rrkl7hH5pNNykHy8hAsraWXB2MRhA9aGQleLNPlufAcRb
	ff4uUjq9seK4rsI3v11hpzM/2zKYaA8pjeYBRt2s0f2N/z38pu7cPg8k4gCyGanFbzPGOe
	cDoOisrQgSFtDJo/Xiqi9kB3xEg1AjU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767734412; a=rsa-sha256;
	cv=none;
	b=je4zMsKs83dQJVRl2dJpWC4+XCUipaHxgrUBD6OEBrzPs7x6tL2Fsz84oEm8OxkkSS0nCT
	UP98IifKoAPCnHtKjpEi4bwxqOhV0VkLaGHR3SndPGzr9rmgm7+PI7y7YUbXgPD2e/8iXz
	4BaLwcyyywwKNitlo1UHDZNxIBf2Qa8=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025122301 header.b=HtOBDzSY;
	spf=pass (imf06.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from mail.zytor.com ([IPv6:2601:646:8081:9483:178c:dccb:2d71:85fe])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 606LIrDo029412
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 6 Jan 2026 13:18:53 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 606LIrDo029412
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025122301; t=1767734336;
	bh=aI8MIw+sMa6PRGtTxYvVJEbs7tXT12sE7HZ5eTyFKjU=;
	h=From:To:Subject:Date:In-Reply-To:References:From;
	b=HtOBDzSYOXIElCekW0xbSMoqezJNGWAvd6WaEV1EvTfZMIldHnKSr20qoQaBLFLXj
	 xODoSdOhVI2fcQNwmMkzFzmtKjkyeGlaK/DXbOZnF1UWa81uqePmMadJ8n6FfTvvbG
	 RM8kPPigUITdMIV8FuKGvK6EdVGp79UaHWT2o+W9VWD9oOi5LF/fNOh9/24TrDilRT
	 Sli0hekCuEPa8Dd5tLyvdvJf5ip5+okYvSAPDkKO5MGVxFxWvlgUXcWz+vpztnswqw
	 1p+kPkQgRASGlDp2tUHdT3rG5+82/UPMj7deC4ziJ/KQ6C34DB/PvlS1juBFoVj2PZ
	 SBzySI8XzhPWw==
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
Subject: [PATCH v4.1 00/10] x86/entry/vdso: clean up the vdso build, vdso updates
Date: Tue,  6 Jan 2026 13:18:33 -0800
Message-ID: <vdso-cleanup-patch-4.1@zytor.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216212606.1325678-1-hpa@zytor.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: k4q1xfzoppysyetqqwf1x3irysnfkkad
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3113F18000D
X-Rspam-User: 
X-HE-Tag: 1767734411-2442
X-HE-Meta: U2FsdGVkX18o0Imf1ECba9GkGXiOnhdHS0yVOAM5J7UNcn8JxEGm4cxfuSDHWvmz+RCpVpOI7Vy0Fyr5G4MbULKkW4TLrFdZD5HyrSDM6T0IEqjz22Jxv6TNSWshWM+sLW/uW1W5azzngClUmIubb7jiigzji0rP4GGy4AWTCK2oRj9Z2hjTrwJ9FNEShFqjgQLJL0LkIQA7RuOJM53u0ECv58somm9hBE8ZX2KVZkBNYZmyqaL42fPeUxWdo3kL/AoO7L2UyHlYMWWqdtgbKKc1FY2ihCiHIxtSiHEn6ScPQBVR/PigG/9otRobusxdMXeFDocvn4NnJjMs/YptHiuwRY0AL2F+uITf8yOeWcaHeYZxT9T3OdOSar9Kd2fxtrSmOkv58vbIDIILhdw0Pc90AZMtUheukoeYhuTGPP/AtsbIFWnIb2lMpxzF9TOoQ4zrftiKblziGdje0nhL9T7eVGBz+pBtgdhyJfYpwLQX95D/dI0VgGvIKdD2AGoL9Fw5asv76i2MijO/3WaY+31OhOn2KzbT7+zxKTcso10fC0pQ7usUJkcSdZfcNqo4K+Hbp/UNjhIUo+5CKfvuD/m6SQBgYidfnUoNf+6xGaUo6v2MJYaW3wPB9LqCxcrsWEizutTTZXzhza/+Q39DZoBpXShQ34a/IBSkcu+aAt5KA4mtZR0C3HnbF7bGswLnR4br2ra9CSTYtuAK5c8LZy1z7ZKM+lpYFFArimhVdAJTisA12JJSQT/XzUFDrIxLA4FukJm5bx4/u22LgTHaCqq54gERiEAMTCxtZ5gPxVTTY/8H9Q27ycYsDzP7UcUSVGVF57ssTHDdGynm+fB1nH4idsxCCo+SqBaIjYdzi29xQmS45ZrA+ZX7tYmzyAhazXdoHDg5sxFvkcU7SRysmHHKfHzIVrkguSAtIKyE10iKZH0nt6WBxoRtuVt/kyqP67afuBvImdsstcsQDmS
 faXsGOB/
 NnzwoLcX9MH8m9sWovDxp21VRlErFZ7UlMgbnvy9M3+Bo+6IAXWGbMEyLk+Vvhp2+ILIQC/wV8Wp10WWlsrVfjADjJC9R9jOFX74hSZChDQKI5s4aenFtD2TrLSpoJE+sex9pa3wSZgfR+I9frHgpWByLVkw2v37j+dgfqEd76+HrRB8X9Gm/W5mipUVFdSuKJdrkTgYQRx0fN+9vLdfKZMpt5fSs+02Ozw2Q/P8PYTF9t4AiSHqo/QLTGeVOx4IXCeZK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This is intended as a ping, since I think the v4 got swallowed by the
holidays. v4.1 IS BASICALLY A REBASE AND RESEND OF v4; THE ONLY CODE
CHANGE IS A SINGLE SPACE CHARACTER.

This patchset cleans up the vdso build by building the 32- and 64-bit
vdsos in separate directories, moving the vdso2c tool to
arch/x86/tools, and by merging common code and especially Makefile
rules between the 32- and 64-bit vdsos to the greatest extent
possible.

Be more strict about sanitizing and standardizing the vdso build
options.

Disable CFI for the vdso until the kernel adds user space IBT support.

Modernize the DWARF generation in vdso32/sigreturn.S.

Add macros to cleanly call system calls from vdso source code.

Add the GNU_PROPERTY and GNU_STACK PHDRs to the vdso.

When using int $0x80 (old 32-bit hardware or FRED-capable 64-bit
hardware) skip the stack stuff in the 32-bit kernel entry code and
call int $0x80 directly when used from C code.

Changes from v4 to v4.1:

  - Fix a single bogus whitespace character change in patch 7.
  - Fix the spelling of Uros Bizjak's name in the comment to patch 8.
  - Rebased onto v6.19-rc4.

Changes from v3 to v4:

  - Improved description of patch 01/10.
  - Split out the move of vdso2c to tools into a separate patch.
  - Remove unrelated formatting changes from vdso-layout.lds.S.
  - Fix *-x32.o being missing from "targets".
  - Rebased onto v6.19-rc1.

Changes from v2 to v3:

  In arch/x86/include/asm/vdso/sys_call.h:
  - Remove stray comment from prototyping (Uros Bizjak)
  - Remove VDSO_SYSCALL6() since it would require special
    handling on 32 bits with frame pointers and is
    currently unused. (Uros Bizjak)
  - Indent nested preprocessor directives.

Changes from v1 to v2:

  Too many to count - much of the patchset has been reworked

Patches:

  x86/entry/vdso: rename vdso_image_* to vdso*_image
  x86/entry/vdso: move vdso2c to arch/x86/tools
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
 arch/x86/entry/vdso/{ => common}/vdso-layout.lds.S |  38 +++--
 arch/x86/entry/vdso/{ => common}/vgetcpu.c         |   0
 arch/x86/entry/vdso/vdso32/Makefile                |  24 +++
 arch/x86/entry/vdso/vdso32/note.S                  |  19 +--
 arch/x86/entry/vdso/vdso32/sigreturn.S             | 152 +++++--------------
 arch/x86/entry/vdso/vdso32/system_call.S           |  22 ++-
 arch/x86/entry/vdso/vdso32/vclock_gettime.c        |   5 +-
 arch/x86/entry/vdso/vdso32/vdso32.lds.S            |   2 +-
 arch/x86/entry/vdso/vdso32/vgetcpu.c               |   4 +-
 arch/x86/entry/vdso/vdso64/Makefile                |  46 ++++++
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
 47 files changed, 444 insertions(+), 490 deletions(-)

