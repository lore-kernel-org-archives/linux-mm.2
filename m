Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ADFC2CCF9EA
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 22:13:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BF508E018D; Sun, 26 Oct 2025 18:13:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496D18E018C; Sun, 26 Oct 2025 18:13:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35E628E018D; Sun, 26 Oct 2025 18:13:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1AE8F8E018C
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 18:13:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A508258FE9
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:13:03 +0000 (UTC)
X-FDA: 84041666646.25.0D3DBB8
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf18.hostedemail.com (Postfix) with ESMTP id 16BA31C000B
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 22:13:01 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=YwrHTdFG;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf18.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761516782; a=rsa-sha256;
	cv=none;
	b=nacPByA36eW8FJI49BwVBRSuWW/6XcNRXbUIZyFyEu0tQhE87C37eZTCJKJIfPYROtaWru
	JVbd7FGQWf+yh6sDpZBtzt3XeZTtLY+hYBTdXWHPVF7tT+a9rEv4AdkyEMSSFkTAvlTiDp
	IY+Nxy8MpJscKarQrC4/TEdMTQEhLh0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=YwrHTdFG;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf18.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761516782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=hARM3PE/fySirCrpK2SHSPeP8s1QBdwnxki1irso0xA=;
	b=OqaxeCyca36VQWmv9A+nKBGqrYIFjj2RHUZGyrYWBKTmYinvCWaq8e0jTlwgFZKsgaAjq0
	1uFy4h+MQB0wA1J7BxDrAzraOCz36vOrl10OencnhQrjOoSef+RJUo908+MF88rFiwqJm2
	hTcQf33r35bPFenVcEAhtu0hDXKXLvs=
Received: from mail.zytor.com ([IPv6:2601:646:8081:9484:8257:f1ab:878e:498b])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 59QMCFpK548264
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Sun, 26 Oct 2025 15:12:16 -0700
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 59QMCFpK548264
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1761516739;
	bh=hARM3PE/fySirCrpK2SHSPeP8s1QBdwnxki1irso0xA=;
	h=From:To:Subject:Date:From;
	b=YwrHTdFGutRUx90/3B5amccAgoA86Ywn5oKY2a1/73I9q4dCtNWFpC///grkBBBxf
	 fgsWQgWkkv2/Q3gDhTPmHrU2jzuQx8pq6uKG9SFrRzNfT1FsHEgyxW85HPHYWdfIET
	 C9VaH9oK1F21V3W0/hUugRafKf9tjZA6lfEdCXEnLMYSJwNnVFU+FSWuAyCW05WESS
	 Noicu5hfJsZ2/Ykff7opO6FrSS+zEXQcwBAAR7ep4LzvOmkiHd9TRtv7nrICWwA+NH
	 TH7PqxsZqtWWfBktxeNH7IAqn3p7mDcr8sm7OEQNZWlj0Ur/+Opwdu6u8iXyMK7v8l
	 Ag/gWl1LqsFCw==
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
Subject: [PATCH 0/6] x86/entry/vdso: cleanups for vdso build and 32-bit vdso
Date: Sun, 26 Oct 2025 15:12:00 -0700
Message-ID: <20251026221208.1938173-1-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 16BA31C000B
X-Stat-Signature: c3f4hu6cigzzu9uaemqyyr48wn5o1nsc
X-HE-Tag: 1761516781-89246
X-HE-Meta: U2FsdGVkX18VZlwlNyifRL1htGg7F8WNgh0MycJVg+wfMrbLw6NzR8reYbr9dOeKLlXDa2LR1ZsU5ksDq4bEdtfpDD1DBUoGJcaFM29E2MKK+hxiUAfPQK+CGvbgOOm5+NUxjXyQGCP4ULwTQ3k7p+8+hIt+ogbTB2wVbpW7mAHhYvsel1ehng5WCpRkYPjCgQFAW9aDBhSsw2FJjJqvY4NHAT0ooDsZJRl4zIKK6CTI99wA562qMTUSDUHTb+IbOP/lkUm1+cvsZgESrNZtqS2tQyjIUN3LXONk9g8EQihbEP4+834JHc1Ovlg6i8lh+1x8/vZSgsHD6KV1PicWzekC4j3nhJrrecSIEC+V1ZhBM2uBm82XvnhRDdILg3d4Tuaa1I4fj3sR97AqDkAxTLPGbCloCqNpGeBi8Jr2mfxRMTK/IsUL0AiRRbGvZDTkdg4sjhmT5H1CHPp/VuwtV6dy2It//zhRxN3tq4atIgwjEmei0a86shOUfITaR+WiuR057D+0AMGJ0YwX6MFlCQgGAZO7UJYNNVXzRHhQSoxRKK7UuoonI6FmOvMqIeu5fvOorF0J/m/RtUw+yfxZ1F/yKIfJMKhbqvUeHgUEihazvBY2D9c/aqApewYQLJK9CdSVk2Hbs0y9X/B9/91Q4y11lANw4EY7UiKSsbRjf25wcCMyeJVdPX5PBWAQ+QJEuDmHRvSzn766vD0DLi0bfjUdsfr1ZqRiTMkecjjHC0w3LU9RX146XQhyTAKs1aCrZJO50W0hEKTIiD4F/oSmckdbCRWbEmFsIcay6DCZ1I/5O5la0v0icWcj82dClJyFtqSmYup+Kof0Aw4l1+LSj4uEEW8sAtl5RYXPeEIusnBIXaU/3FVVPRF0THo7K94etn0K0KlTYjGES/zZW67/wRouDKRIPhc1Cnry+D8Io39KQK9ysiju+QewqHNTXKUxh8rCEMNWsV2HdzSeIk4
 KS/RFFQS
 a9YFef4y3AeoL/CU5P9At6uU31EO/A3D8LlHtcmxHB9fu/DFJBWzBseGvFVwypORtGWmRuixMdzghKls8HlT2wB4QsQUM6r4v31T7/Z1DwPY9CEATdBeFKjOiEXRLpEKWj1aDg7SpDT97o0Mrc+3SFcBXsQul9h1RpMmNp5i6FkkJu5UdzbH66AscVm4OLuyBnC0Wj/erPME7rtLhOtKmnk8VXFcteu4ZRv9ZFRPxZn1PisaSz9B4dkSelcQ+2rQK29EDEDyKtix4xXqGkz9aH5zZmzIikg3b3O/FxOCz8JaTQReXwWPs5sEGj+rrwYUC8+YL
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "H. Peter Anvin" (Intel) <hpa@zytor.com>

This patchset cleans up the vdso build by building the 32- and 64-bit
vdsos in separate directories, moving the vdso2c tool to
arch/x86/tools, and by merging common code and especially Makefile
rules between the 32- and 64-bit vdsos to the greatest extent
possible.

Be more strict about sanitizing and standardizing the vdso build options.

If the vdso is build with CET endbr support, add an endbr32
instruction to system_call.S.

	x86/entry/vdso: rename vdso_image_* to vdso*_image
	x86/entry/vdso: refactor the vdso build
	x86/entry/vdso32: remove int80_landing_pad
	x86/entry/vdso32: remove SYSCALL_ENTER_KERNEL macro in sigreturn.S
	x86/entry/vdso32: remove open-coded DWARF in sigreturn.S
	x86/entry/vdso32: add endbr32 to system_call.S

Overall, the patchset removes 90 lines of code. Although it touches a
lot of files, the vast majority is just code movement and/or
deduplication.

	-hpa

---
 arch/x86/Makefile                                  |   2 +-
 arch/x86/entry/syscall_32.c                        |   2 +-
 arch/x86/entry/vdso/.gitignore                     |  11 +-
 arch/x86/entry/vdso/Makefile                       | 162 +--------------------
 arch/x86/entry/vdso/common/Makefile.include        |  83 +++++++++++
 arch/x86/entry/vdso/{vdso-note.S => common/note.S} |   5 +-
 arch/x86/entry/vdso/{ => common}/vclock_gettime.c  |   0
 arch/x86/entry/vdso/{ => common}/vdso-layout.lds.S |   0
 arch/x86/entry/vdso/{ => common}/vgetcpu.c         |   0
 arch/x86/entry/vdso/vdso32/Makefile                |  24 +++
 arch/x86/entry/vdso/vdso32/note.S                  |  19 +--
 arch/x86/entry/vdso/vdso32/sigreturn.S             | 152 +++++--------------
 arch/x86/entry/vdso/vdso32/system_call.S           |  10 +-
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
 arch/x86/include/asm/dwarf2.h                      |   1 +
 arch/x86/include/asm/elf.h                         |   2 +-
 arch/x86/include/asm/vdso.h                        |   6 +-
 arch/x86/kernel/asm-offsets.c                      |   6 +
 arch/x86/kernel/process_64.c                       |   6 +-
 arch/x86/kernel/signal_32.c                        |   4 +-
 arch/x86/tools/Makefile                            |  15 +-
 arch/x86/{entry/vdso => tools}/vdso2c.c            |   1 -
 arch/x86/{entry/vdso => tools}/vdso2c.h            |   0
 35 files changed, 255 insertions(+), 345 deletions(-)

