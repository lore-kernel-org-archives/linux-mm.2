Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7C6606A323
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 11:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=ZbbZEG1n
Received: by kanga.kvack.org (Postfix)
	id 8056F6B05B0; Sun,  8 Nov 2026 06:05:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B5DF6B05B1; Sun,  8 Nov 2026 06:05:05 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A4596B05B2; Sun,  8 Nov 2026 06:05:05 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4B92D6B05B0
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 06:05:05 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D329A12043D
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:05:04 +0000 (UTC)
X-FDA: 85411669728.15.EB38FC3
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf10.hostedemail.com (Postfix) with ESMTP id 39565C0003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 11:05:02 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZbbZEG1n;
	spf=pass (imf10.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794135903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KKnJ5ofY6xI7mGRCSoUHzG0stJCP5GNAGXYvslrLiuU=;
	b=1oK4nnZKCVJy91/qFCrF1yeR2qd5W5SlBBFZemNW7a4YB9jwkdWr/UXKIhonbgKGxsp6wM
	jqK7PHAhBLCqPgcdLc/baa5u+vBD8EhQ+6yMMN7EW0vFKakAuthaMTrGT5yItU5zRcw9Qj
	bmFFJH5WxuyaEq8Zlz8Z22/SgWtOq34=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794135903;
	b=vlmrEoNFSZlMj3Ey5dKAZzzZ6YKsxstj81k51Rbl5d8NjQn3u79oA/2RT1GSrbwAnoA6tD
	g93iEBLCOownE8nQl/c+RXBz0aomsJw9b3FQIqNQ+T4ecb3099IcaO81Q+RPRV/S/Kb2YL
	8SreYuxWsjd2hMhh+WFUThvmxNEg/FI=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=ZbbZEG1n;
	spf=pass (imf10.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-3b0a519049aso17300a91.1
        for <linux-mm@kvack.org>; Sun, 08 Nov 2026 03:05:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1794135901; x=1794740701; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KKnJ5ofY6xI7mGRCSoUHzG0stJCP5GNAGXYvslrLiuU=;
        b=ZbbZEG1ngfncILhv83Qm/90psOOV3niPqE6TkTuJaR8a7je97R0aKkl24RnWC1cIhR
         fhzdHmWA/suMAszeZrKqaFumqi6VndiwU49etrOJ5wPjdZes9piJpPnJA43VpGoTDpp6
         qqbUJCztYo8tMx8NXC7kN0GlqtI7tFP0OvIU0avs/mSByPKa6y0cFf7jQCCPzv18LTXE
         i+mWCcAMBtLTUQVHq5qGMd+mVyd2EI+L2pOSk881mVbMB5GK5TTHfKrhotqGnLxeQJH7
         CCCIDUuN1uZqC244lw2fUlWI/Oqc9QMtSDBB2lxmvfH+sHM7QPz+hPz0SiOGavDwMYCI
         DUtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794135901; x=1794740701;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KKnJ5ofY6xI7mGRCSoUHzG0stJCP5GNAGXYvslrLiuU=;
        b=p88o+jic8l47iIozO+qSNulVoP/wz9aLxIn3Tg5BCvwDT6jXRHzynupa3KpvBoaaOn
         eTVNzHOE4WOwnlnCQryFXWzaw9Hp9OKSPNKwrBCJV/h3YHGTH8Y5Pcrshu7sl1W/A4x9
         O3pEznGCW60/HXhoguf7sAGFR9TPZw3eXMozHUQXZVfmkjb89zw3d4zEJMTKpq3SiX0Q
         prD7R7E2RMpR0nuedzdSMZrskPq4UzwBPgIQJR1SubwkCpltGM0h39EbNb8enC8f9jcy
         Z5inFfVwQFy1MaitDgtfP7A18B0w8E+d/s+WZF98q9BsocGAets0I19PaXz+B9B1tZGc
         Eo4g==
X-Forwarded-Encrypted: i=1; AL+hErHWHP5KqIJqEF9HV/vD7D4iAmFDuiddJH8QbhE2g0g+t4FS6X0q8h+mHpE07y26hgAbZkN1Fl/Q+A==@kvack.org
X-Gm-Message-State: APuU4Z8y4uwY9fmVlHcP9crM8MuF7IgOO3ZUnJpy6Q3INofgspitX1Qd
	dsGjfbtMFFy2NWj+wqZHCHDNaGnbVMCwJ/AHs4InLQHUEe9sCep8XkgZrwvZf5SRnzY=
X-Gm-Gg: AYBFou02bkjpIk7/BgTVr9F/bc1tm420YTdVLhe9g/OCtkEV+YwPCD6XuXlvIM9z/oI
	CsygnxSF1FbsKZWoShJP9gee7Y2uzJcptk2Y5Y82fzga4ukdXG5Gw3XkfHq0lFPRAshqC26+LMZ
	xW7uPQr+Rc9BY7PYdar/4I5/2MARtILaDnCYQlEMUUy1lNvEDbGKj/f6dct/WlBrW8gFm9Ej5/5
	NMCKIfTiuYi8m6auhlDN4M29bgv8SYhYAfrJ6WIAE/ieiCQ6w3ysU+eNmCKvFtIRPm9I0gJTjJ1
	XqQBwfx3JD8iAyIfBCAa/UKOhi+vjMXqTRjjwVCjzGjVXFrQqsAjX0mtRSZbWszCl3nuz+GEDLd
	W3r12DGuaSRscvJNUXjYp9ceBLmFPxmFeiY2Ok7yk9zIql++le2hNBgFmmJLL9gcpgcO1Pkv1Xt
	Irmxxrq+0NaOrKywockXw6wRNhbdK6Q5YI4RJOXyIARiOA+p87J8Qq3P10cjuG/oXOGxS942IqF
	w54nTYpaLpE92AOOrcEfIFioq4BZTnOope6pDhfzBsC5NFL8RrPQ9NrsBN9entHT5EtlVT5D5BZ
	SKC1XeuGCIpr7KuEpKiUjZq246kSwEWM76ODMEiOhL5k1yZHYtTKhitHZiAUgMU=
X-Received: by 2002:a17:90b:554f:b0:3a8:10e2:ad08 with SMTP id 98e67ed59e1d1-3b12d51f0b3mr872216a91.48.1794135900776;
        Sun, 08 Nov 2026 03:05:00 -0800 (PST)
Received: from localhost.localdomain ([139.177.225.233])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3b1278918f4sm2609818a91.6.2026.11.08.03.04.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 08 Nov 2026 03:04:59 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	memxor@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	bjorn@kernel.org,
	pulehui@huawei.com,
	puranjay@kernel.org,
	thuth@redhat.com,
	ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	zong.li@sifive.com,
	conor.dooley@microchip.com,
	tglx@kernel.org,
	debug@rivosinc.com,
	seanwascoding@gmail.com,
	andybnac@gmail.com,
	menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn,
	atishp@rivosinc.com,
	apatel@ventanamicro.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	arnd@arndb.de,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com,
	qingfang.deng@siflower.com.cn,
	linux-arch@vger.kernel.org,
	llvm@lists.linux.dev,
	dave@stgolabs.net,
	emil@etsalapatis.com,
	ihor.solodrai@linux.dev,
	broonie@kernel.org,
	cuiyunhui@bytedance.com
Subject: [PATCH v9 0/3] riscv: optimize percpu access
Date: Sun,  8 Nov 2026 19:04:03 +0800
Message-Id: <20261108110406.97495-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 39565C0003
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: ns64aw7stuni49pxez6rbo1hpjisgwth
X-Rspam-User: 
X-HE-Tag: 1794135902-315592
X-HE-Meta: U2FsdGVkX1+XjGTsNSeWc31X34eyFSw1IlkELkQD+DrXPC3n6vdaYRg4TnRFy+vp5cGmpLBmWCUh/N5N8WQT2vMB+j5jv9u0YrbeqCMtv+UbawTS8H0D4v2EnkEU7IutYBCq/4Vo0kR7vylhf1qWY8CCfs1v7Z272uft2/ZTbdvJdTmBx4M1aUsoJKLPAnkqmxQiv7QhcRZJ/csMaNTu3D2ZUbwm2BoSnemUTOPjQExINV/Eo+QLaiW/uIJnuF/G4gB0lvdMJKi+Eo3jpVNc2rG8G97WrgPMZf+4xJDuQBqsC10mpi4E9RKFEhLif59nwsLT9bhb6Yx+AjjfviMrB2AROeYLprMYQsp9BVKgN5smdky7tt4x3C+0agLcoVLfXyEg64uttuYHhghDWhuTwYUZlGD6HoPXLsZ+hjWj0Rv3G2lJ4+R2hXZUYMqIuqWdt1uiXs5UGNkylhRyPrz9c36qhfCntQA1Ov/0JP0f1NNiOblSDUQ551WxAoeCfe0X9s9TvHaW0491XAP1J/i3p4wWBzqNcPXuD8/LVTda8jRrKBmmPmS09fjfc36kEB2ZOVtOAklSBYq4VW7bixU4o69RPBp+6hGxOHkJ4lq/YXx1NFBnF7TIxVj4bkUE/bdLQz03Lk60DMfW0k2VU6UvRZR9jsFQYpOTCVCq2k99ULD+E++BHlGWZkaTHWD9bUSc5OajMb7hJpBzVg3nrTsl4J+OoHNzGXqYgBxSQxHGGEDWgmvWOTTO85h6Euycg6RrdiFpFgyz8EgOLYgoSgH263BMSA8SxtkGaSNCG9w3RqOi1nwYoNknuSXm2E06BxaVcgHI1gRBhJfa2s7PpfRK+7iav+nfnsMmBzOSuizgo9rqV6n1TPoWIJQBrgiJ3EGVkhh6oGQa8p2qX6YKxUDN4FLHbMAy6H3BLOpFH3ZwfPwot+Odliv4Hf87X+Pe+4GisQjJr24MtV5uobYTPH1
 aQEjXVaS
 bUol+mlu+hJwwJnYAPZ9S4L/MrONwVO3g2cFX8Cwvd4BUdbIpah6wPrPR8f2Yus3A5xlPdr7315CfQkLdG7MNhLmcAXTvKwSEaMGYs1vF4+WKQl1k4y/Ac1OS1c9XaxXwtl0+7R4pVerEO18/tdDmLkUqi/K/LYxkK2ODuswQX7AWqcf/QItpMbuZPmJZozmZ1nH2tGk/YqPziBCzrZgAmnnp4nZsoMatChYtlHXqxauJqbQ4eK8OMcxHerrmhPS+YY/gTTAHZdpYoPPTqg3cZnE9Qac/PtjmUVmU2NCDBP/8EldSEmc6Cvi/DydaOozoWRBbGfdzDakZlOuXTEeobZBATghmpZMWFdHxIPLPcp6SxBQNrho5J3wTGUtvYyozR0obhTRGF9IXirg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

RISC-V has no asm/percpu.h, so this_cpu_*() read-modify-write
operations use generic fallbacks that disable local interrupts. Per-CPU
addressing also derives the current offset from the CPU number and
__per_cpu_offset[].

Implement RISC-V-specific this_cpu operations using relaxed AMOs with
preemption disabled. Native-width read-modify-write operations use AMOs,
while 8-bit and 16-bit read-modify-write operations use Zabha when
available or a local 32-bit LR/SC sequence otherwise. Cache the current
per-CPU offset in thread_info, keep it valid across CPU bringup, hotplug
and context switches, and select HAVE_CMPXCHG_LOCAL so vmstat and percpu
counters can use the this_cpu_try_cmpxchg() fast path.

On a SiFive P550, Davidlohr Bueso measured about 15-20% lower
this_cpu_inc() cost in an ad-hoc microbenchmark.

Changes since v8:

- Drop the PIO helper patch, which has already been merged.
- Rename the first patch and update its changelog as suggested by
  Davidlohr Bueso.
- Use value-returning AMOs instead of rd=x0 for CPU-local operations.
- Remove unnecessary memory clobbers from the new relaxed AMO and LR/SC
  code.
- Use .option arch,+zabha for the Zabha inline asm, matching the
  existing RISC-V cmpxchg implementation.
- Isolate arch_cmpxchg_relaxed() behind typed always-inline helpers to
  avoid macro variable capture while preserving atomic instrumentation.
- Make the cmpxchg128 fallback use the already resolved per-CPU pointer,
  avoiding the same macro variable capture.
- Copy the cached per-CPU offset from prev to next during context switch,
  as suggested by Thomas Gleixner.
- Initialize secondary idle tasks in the common startup path, covering
  parallel bringup and CPU hotplug, and remove the duplicate initialization
  from smp_callin(), as reported by Sashiko.
- Select HAVE_CMPXCHG_LOCAL in a separate patch.

Yunhui Cui (3):
  riscv: implement this_cpu operations
  riscv: store percpu offset into thread_info
  riscv: select HAVE_CMPXCHG_LOCAL

 arch/riscv/Kconfig                   |   1 +
 arch/riscv/include/asm/asm.h         |   6 +-
 arch/riscv/include/asm/percpu.h      | 574 +++++++++++++++++++++++++++
 arch/riscv/include/asm/switch_to.h   |   9 +
 arch/riscv/include/asm/thread_info.h |   3 +-
 arch/riscv/kernel/asm-offsets.c      |   2 +-
 arch/riscv/kernel/smpboot.c          |  10 +-
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 8 files changed, 598 insertions(+), 16 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h


base-commit: ddfe51b0a0f5dc9e415cc2c8ad8db17532dd426b
-- 
2.39.5


