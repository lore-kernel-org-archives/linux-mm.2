Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1C361D637B3
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 21:26:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78C096B0088; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 780CE6B008A; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B7C06B008C; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 544CB6B0088
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:26:57 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0EF61BB321
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:57 +0000 (UTC)
X-FDA: 84226619274.01.917623A
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6D4B840002
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 21:26:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=Fy9+m85s;
	spf=pass (imf04.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765920415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=kICXnCTNHNjUBILudSo6c9gFjRsUFpG+vI25mVtUO1c=;
	b=a+hdUlC4EUp8aCZMUOat6ufM/iBKU7dJzeHnLLN5nOoQ1slEyvA8SS8fSvrvV7LVG8ybZZ
	KxmfhyKd2NPuTnDnYjFCEEkUoTUDXlDjAIGr26zrRxB3SuY4kSFyCmH5BWQl/WsVNZ2hne
	vC07PHjComEGgah+XQ+Vj8E04unVPmg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765920415; a=rsa-sha256;
	cv=none;
	b=MNky8f5H+GrJNqV5Y3H4oMqhyeC3U6Z1dLaJXzBbphzGJK9yyqeOcuhPfA51mQUMjcflyd
	axwU4Y0xWICQulmeK4Kyr/iHPucjsYHmVhzfrVNjyQqwvxr0yAdA5iakqnn5kCqpVeCRLB
	9Kp6rOE73Fcbk1tRhTLhNKUoM2MxVkQ=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025112201 header.b=Fy9+m85s;
	spf=pass (imf04.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com;
	dmarc=pass (policy=none) header.from=zytor.com
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5BGLQC1x2563820
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 16 Dec 2025 13:26:12 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5BGLQC1x2563820
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025112201; t=1765920375;
	bh=kICXnCTNHNjUBILudSo6c9gFjRsUFpG+vI25mVtUO1c=;
	h=From:To:Subject:Date:From;
	b=Fy9+m85sA5KFSoFWLsOjHXO1eGJbjKhGTgfLOugQSvlY3RiCLtxoJfXfzg2XEQKc2
	 TIN8WPX29CTtMpFsnaGp2PUWiSSFmiAd3PIF9cYPP5NuYlypqthIJ7rXcCZ6jNUvej
	 fvOoqmxkILuVnCv3POtcyl1V0iU1Y91CCp4pzlXB35Ng+F9wK2yKg8GVvtoOT2QMoE
	 G5d1cckpBrmZ7bc6lzAwnla4OZ9nzlLSpmdEw4B/Bho36imA4HT4PCywTTQbbZzPjk
	 HdRf8n0Mc7vX81V8dcAodn3AkyITARcYDbE/LOIH+zEW/QJeb1TbqMrh6bioz5g4S+
	 RAM1ZkDHYbsVA==
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
Subject: [PATCH v4 00/10] x86/entry/vdso: clean up the vdso build, vdso updates
Date: Tue, 16 Dec 2025 13:25:54 -0800
Message-ID: <20251216212606.1325678-1-hpa@zytor.com>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: r83mbeddwkseiepwyp9uhyjdjihibyms
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6D4B840002
X-Rspam-User: 
X-HE-Tag: 1765920415-280881
X-HE-Meta: U2FsdGVkX199BpA71Ri0is60XcAZR/TZ7vobMSIvO7TqK3Bq3iN/DsXrRWLhS9j+oKZoYJc6YLKnZ91eKwIsRK6rBkQ2moULKhbPR8qvw35E/WYh17Al3JUvdIKZ7OTKxlxrBP7jF/1dmaPOtKUe93C28lrgs6sACVB2QshOlu8YtHx8aYnAceTZfM1fcQYJCc5+q4SCigrpyu/SlJvj8Yac4FmE+cm8t4R7UpQOjYp76ibjCL8q0S96T3ictddY2kP0Ah2tEAvANHT3wkt5hx1M57zPGwo3qyOhBJqv0KreyVSVeX1khNEf5+mn69WxP11x/IBM2ShmBqITWn+OA4d+RDikqJ77KGepVbwatYCC1trjqbWoQmixs7j3U4ZpaGfGcOLVrFC6+MMcJuBDCNYZJi4ZMcUU8ahgZA4ioM+R+MeOlYb0CxUIyj2Ry3FgsXh9G2Rh9XebUO0IPJJvMa4qIncW1mbOjKhS6vA2Eqp/0qtUUyj5h8e3E7Dq1vU7ZEp8IqzJT1Ki/5h8/ERCCbIyzls6vHLrX+dL9TqUw+zXXjAIinLobAFrxFWYtKlh1esN+v5GAqxA9FCI4MhUrD67bxiu8GnVot8t1qMd+3eS5CPD9kAWuBdNqiqXd+xIMVn77dVSqfOaxcLnNNMSmpSeCS00SkfUOqbkBle0tFtfW2kZoXXcX/Tu+S12K88VJI5mz2ySWb94pLvPa2MIzabHFmKG1DKi4/ldCG7qcFR1D5Jywq11j112y0/UX6Ea1lzRYEZQuvYsrceB+tYcmDgOtlXzUAvpTjpk0JHdJbOGsAjLXjcRfLQlPvHcn3cQ4RuonsFIWYGy7ZbB4SI82tGP37rlxfr+u3oh8iG4TSB4f/MSLB8Ugp+grWeya+X92+jZGsz6TUlt5kn+4pHkZ0mwLz1R+WI1/eve3wUOpYYg1wYA3TFHJtIo4GoHf9xaOI1yjbJ3Ysl78ZJK7mc
 4y8kpPzj
 bo2k5zsEOrIXCy9P9SYS9rHr4sGqz+TiWgp+dW+segleBLj6YZsLVzqDTEkkBsVSlQhzPj7ukziVNYeB6lEZPpZOs12M0b4J+PTRjtxsWtOnk+v4zdVKk9YUu1Tfy2dHKeqT5VK3sWuJbzkplah2kiVbGjT5OmA8xhDgsNLSL0Bye44FNJ4tRgqo00CX4WlwGQIKHNsouVdBlb5eIRviRhHqeN5xrwz/ym2kl5rllWc5WBeI=
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

Changes from v3 to v4:

  - Improved description of patch 01/10.
  - Split out the move of vdso2c to tools into a separate patch.
  - Remove unrelated formatting changes from vdso-layout.lds.S.
  - Fix *-x32.o being missing from "targets".
  - Rebased onto v6.19-rc1.

Changes from v2 to v3:

  In arch/x86/include/asm/vdso/sys_call.h:
  - remove stray comment from prototyping (Uros Biszjak)
  - remove VDSO_SYSCALL6() since it would require special
    handling on 32 bits with frame pointers and is
    currently unused. (Uros Biszjak)
  - indent nested preprocessor directives.

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

