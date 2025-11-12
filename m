Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07C13CD37BD
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 20:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1CFFC8E0003; Wed, 12 Nov 2025 15:22:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A79E8E0002; Wed, 12 Nov 2025 15:22:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5F48E0003; Wed, 12 Nov 2025 15:22:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F0E718E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:22:40 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9C0AD13B17C
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:22:40 +0000 (UTC)
X-FDA: 84103078080.05.D840078
Received: from mail.zytor.com (terminus.zytor.com [198.137.202.136])
	by imf13.hostedemail.com (Postfix) with ESMTP id A256D20019
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 20:22:38 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=WhhQ7EuK;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf13.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762978959; a=rsa-sha256;
	cv=none;
	b=7TRxW6h3naUwPdr5PegdafFCB/k7ttYQGV0teyRIBJDE/PT4KehGmGn4iJM61VvXCUodlc
	d6Ik5Hm3pqzVHr89QyBaAOBQMnpVKwzhjfExNo/cUNDRLxzrymYcIO/VAJteB9+KRlUszq
	ETgT0X3MC+wgYSx6184/5sdvzADMsqg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=zytor.com header.s=2025102301 header.b=WhhQ7EuK;
	dmarc=pass (policy=none) header.from=zytor.com;
	spf=pass (imf13.hostedemail.com: domain of hpa@zytor.com designates 198.137.202.136 as permitted sender) smtp.mailfrom=hpa@zytor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762978959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=GacBjPJEXkeyFGvcySDne54yt1x9SXUnR3yJ7bSJhAE=;
	b=Z/lbgtbAJHRdhXBKIWrmNXNm31b5ZA/U8x8FuQYmv0VndAZPxysT+QIjNCOMJW+apC4QTT
	schOtloDBzsDbxB88PkR9aaDG7fttIbBx8I/zdKbNRUnhZmJDoLNx+INokfPipnvrNbo/W
	/gTV0pBZPnMRFlCZU181rogXKklaRAc=
Received: from mail.zytor.com (c-76-133-66-138.hsd1.ca.comcast.net [76.133.66.138])
	(authenticated bits=0)
	by mail.zytor.com (8.18.1/8.17.1) with ESMTPSA id 5ACKLxgd978289
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
	Wed, 12 Nov 2025 12:22:00 -0800
DKIM-Filter: OpenDKIM Filter v2.11.0 mail.zytor.com 5ACKLxgd978289
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zytor.com;
	s=2025102301; t=1762978922;
	bh=GacBjPJEXkeyFGvcySDne54yt1x9SXUnR3yJ7bSJhAE=;
	h=From:To:Subject:Date:From;
	b=WhhQ7EuKwYOXytPktFek3puY7Ka0XqBpn7jBOERZqLlcy7SfXWCNsSw4KzTyrdilv
	 xf34DKl84eb9wbp02eojRF1Arl3k73RGpmWbST7W1aDH5jgCFvity/lWEY3JsDu/66
	 uXn03ol/zqhoxm9wKKTvyWGhWcjKy1nt3b2wdtHuOktdHSOgmEQUbTK9TaRpNeFqna
	 GMKGGeMijqYo3e0UVhsVSvu/vfq6aj6nsMTELnn0OwBKjCJlGdM6QBeaOwImY1fAO8
	 BHm9EGykwgLoNslkep5UQch3jg45qyLBcV9GUZgL1RCODGmny3vbFlwxdy1QCUoeVl
	 ei6m6DpOShsyw==
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
Subject: [PATCH v3 0/3] x86/entry/vdso: clean up the vdso build, vdso updates
Date: Wed, 12 Nov 2025 12:21:45 -0800
Message-ID: <20251112202155.1310587-1-hpa@zytor.com>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: A256D20019
X-Stat-Signature: oe417gbouxw18h9kadtgqnqqx1831ct5
X-Rspam-User: 
X-HE-Tag: 1762978958-228224
X-HE-Meta: U2FsdGVkX19jJjbGE9HzBPYDsxgVcrHI3s/gOzpzvkv/MfVCYtM/PpPNSvP2N3HD2Y5T58dd9SSQZ9ZyzZ/ZIrIdG4K4DIxiW+tDZEJg8opPb61pmIQWmefJCFyLztz84KrJnlB9QvM8yVBBEhYgRvM4N8in3jPJtX4phYEzo8BDox4Dmiqi5b84v4gJUjG7SslMMuDjEByPicnYnty+o+eQQ1h2kFoOGGbsCRJ6uCuU/mZnfFDhmOfRIOYwlAN/2rBBhrkpKiS8DV22BNjNUX+ONT//DuCgSpwqxw4Oh5CBZELp8m0cLQ58HrnBW/ZNVRPQz96GlkAgqcQO6UbvMJUz9GyhGzZq0VosfwbKrySoObK40QuUZ8DnrBj4zjr0Uos0EDszCNMOYxx2z27hzwti/GKUdxVAjwLjxsDbZLxNNzuuskIkH9MkVgQrqFftyoGur70MMoHX5AoU++q8Z0/wSqQt1OP9NvDI71WLhq2yCEC256iKFuB7+rsblAUUJSJnchaderDVpusae0G/Tj8Tn8w2KVpCsl7Iy674ge7cKl9CyVzLDeooF5BGiWxKa95C45lu5vC3pl2eO6KVnGv0y3G/sGm5w9G0xvcjxpN1iaX4YCqnWVFKoifWkekWwCYZN/ZWKsw6lBW72GpmLXoSeZxsNwHJaSO0UIn6KULTD7J/Du/KJ1ZO64QhaBNWBNAqAUGYtLV9/Ju6du84n/G69O4srNYWXzMPPhDlH+8uB3k7ZtqxP6SlgeiR2DBN97OlfAzMWqxnERvN//1Lk4zU6DrCC32y4KncOwBXv8lrgsfGtLcbhNODGWUnYrK8XT2OnXKieFyqSF6rg1R6hguhmy3X0QvpiQo6ck8fIwBOzZnw9h8uVWJQHsS8cV5HR3j3Bn140wJqOGdjVvrLGQ/d+hdlZuq5HLPo7AK51qwmg2LMxHQZhMrfwmKDJiZZMzKH/LUZbk6b5Fhrla/
 uuhQQnsc
 awnYzTv8Vm8bv05rjxEz+ec2GhRAWxhAVgW/xaiwH7qG8ov+CpeZr2sfGvR2IiK4sZr/hUnIyY7dYA0xK3ngKsgV+/jnoC8xxfGyi6Q5m7r95/AszdhrIWw/tP5V7hwBbxqTZMDglvz+RgNPi23Ho2WAA39wyldmB0je2TSb3oTWou1bXcOIRsjACs6mwB4b413dPDGEDRzuJFpVFuVNVuEklN9x4PjgkDXIqM9KabxOeDIs=
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

