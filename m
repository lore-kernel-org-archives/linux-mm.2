Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9522CCFA1A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 04:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4073E8E000C; Tue, 11 Nov 2025 23:38:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F2418E0013; Tue, 11 Nov 2025 23:38:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2C878E000C; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D7EAC8E0010
	for <linux-mm@kvack.org>; Tue, 11 Nov 2025 23:38:28 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A3130878AE
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:28 +0000 (UTC)
X-FDA: 84100698696.19.0F3242E
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf07.hostedemail.com (Postfix) with ESMTP id 20E3E4000A
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 04:38:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=SHEkIi9i;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf07.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762922307; a=rsa-sha256;
	cv=none;
	b=4qZAiSLrXfLFHB81OKWO+tMuMFpnczbziQXEIz4EAJFAmrvDGxTGPIc25YWSSXU/qX/0Ug
	KBEobgIffeHPXAuEiqnH8KX8VfnmP2lPStFA9kha+LV3lcYbRjMVGGFVIftkKT+jdZCWOF
	hppCqiWItdctn2ZND0/q4DF/fOT1VtA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=SHEkIi9i;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf07.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762922307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NrZ4a9zMFdvWjyXptq7JgOSecWDqm8f6ekGuTnbG+ug=;
	b=jW9PawomrEhJwxwF9XPF1WojBIOZJLirT/svlaP5tH4eI5BKiLVuLIaR5Yvveqx88zRbny
	7L6WdkrHP64XbuVDc2nOy7vGXr5X/ipkA8/vIOwybp9yBvsYgmH3c8P5tCsX1W7YraRcD2
	ivPWVhEsAVKTLPzIoRXEcG7hfeWMob0=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5AC4bYDM542538
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Tue, 11 Nov 2025 20:37:35 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5AC4bYDM542538
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762922257;
	bh=NrZ4a9zMFdvWjyXptq7JgOSecWDqm8f6ekGuTnbG+ug=;
	h=From:To:Subject:Date:From;
	b=SHEkIi9i+0a9MuvHZOHtVEPv6HqcQD/luJ0tEUMKKxnunRgi6YKnnIvnwd6YAcyJm
	 VPNDvWDGHqEsOp6kXnpxQ2egxT38JrVGljKEqedQ2f/gyOtt4Alt54N+UZcDyboJE0
	 GeeOMPGgITGU2RRgTMvMGslqjlXgarSaVSXDjOrVCrRik+KAyYsIIwLM3Z0l2fOfNE
	 HbgFyfGPBpCtWA+JcsMJpwbJxAxqk2b4dMv0IlwQd0Z0MyjBxyH7MGph4sUAx3Gkec
	 hqInN9c+zuPxn8YBOicyZ1r39aQ7B9GZEznHqwKvOVNHAj2B9Zw8ZeR9C/kzRRXFIp
	 6rK8tcfDe+3Hw==
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
Subject: [PATCH v2 0/9] x86/entry/vdso: clean up the vdso build, vdso updates
Date: Tue, 11 Nov 2025 20:37:18 -0800
Message-ID: <20251112043730.992152-1-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 20E3E4000A
X-Rspamd-Server: rspam07
X-Stat-Signature: zc76xaftrzi7jnqrwgrrxr7rn7ucj9ze
X-Rspam-User: 
X-HE-Tag: 1762922306-538077
X-HE-Meta: U2FsdGVkX1802zzOVN3mOYYLyIuDDXf5JcQb3qiGW0aZ8QjW12/9S4XH6bVQ2rcM4Vq4EpP3lLlht9FR6kUqWGPha3iKmftpE0gE96i/4mFrYaPJp3DfN1NMpLSwuyrb0Nexok/U6FxCjofwfyrtnEG/gJYqeplV3hqa9ZULq1k3OHyHA56yIUvyWta64Podu8umi/vFTBeeJ4wLfOFtNyOdo1hNNkS41TlVim8DQAjcJW2kdXUxyRIhP5JsBDSh1bSUJ0bDmuugVhAyHYy9WEU1knhGF0VjUjRYi6zf2V7MftxnVXuqtpYhpSkVS2a4MMJqDiq0aUNub89N5DOc3CvfgYc1qLxfibUVBdG29FBYS+yRzynuFoY7C76S/f9C270PKPOI4nlm2NueCHsGWGcfuRfiMUwuXondv54a3mxU7ZZPIdJ8IBFUSECLOZKObyYTxYM67Ukyrjj8WwTNcb9CVj8FdPJjSEWOEs42QAIJRYzp1G6yxAEQBkLGbuGfgMzddvhghSdj8QTy/vPT/4QIUr0CTa37ZpiAmgR8Lh9g5AyqoTz6mD1DGW1id47SqfC9adICUBRR5k1XN/L1qxqnICUmjzIDqpeqCHvg40MyZhTNtXHR0cTNbVchbMy+xdwEecQSeX3UKVzvQKcD93NtLilRM0VY/ibPTiaNdD72RY+9L9JLcb9r9KfPJxs+KwyweKx6bGEk2p4wgJhWNVAdx+lIuY9cFLx7Hmkj6WN23/g4yfZdZbJNgjF7cLNwXfMKn3NLSBCsZrv9lQeYhfd0KYn8aSl3odUfBzLpcAEcVXzTZnEFrd3AbbZOF7SU9mmZjfI9V55y+9nXjQR8CwrXV5CYKiO8kHiDxuJgyf9L7fdaoiLeQsISDrrSo4+D8/UU+Ef06nkzynwdgmdcNEIKzGnQKOJPidc3GAU0i+xuarZqyiWRFli17YJ9xFqSrwApN7/MI9Y/h8tYzED
 rrgsqvIz
 MrMq2akecLM4/v/uo+/w4b5MPtSG8Hy6baMZwAjuj/nd/PAQkqupID4LkQKigC7Vmv7LdUQHcwib8qCWbXMyveQ0lX4/ggNMqflkTdxsjzZe35TSwlZOw/FT8YP2HpWEONWZofI1jodMilb/TiUeuEO+zTj0mxXK6RjJ/KI+EcJzAF+DS83GsGa33Mt+T8+lLxzuwJjqvs6i4i4fXk4Ysr5iqA/P/alXnmB+afz8TBDG1HCI=
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
 arch/x86/include/asm/vdso/sys_call.h               | 121 +++++++++++++++
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
 47 files changed, 464 insertions(+), 498 deletions(-)

