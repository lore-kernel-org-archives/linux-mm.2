Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A9BA6C43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 12:30:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 896F96B00A6; Wed,  1 Jul 2026 08:30:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8701A6B00A8; Wed,  1 Jul 2026 08:30:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787686B00A9; Wed,  1 Jul 2026 08:30:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DE3C6B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 08:30:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BF379167E99
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:30:34 +0000 (UTC)
X-FDA: 84940141188.20.4E4FD7A
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf19.hostedemail.com (Postfix) with ESMTP id D76171A000A
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 12:30:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="YLRVf/la";
	spf=pass (imf19.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782909032;
	b=NdLt43TEI2Ee2HXTNgyzPj4kf8JuuXEiL8uZiYtuDSqCgtnO+Yh7z7PQV/YbhhHAtp5Ryq
	1+pLWBgqUXpWDKBN83JJM7nOOEUWhK1Fkzh7lqS/NWOhTNaJ5SjMq9Ps9cINNPtXZ+cYmA
	iP/YvIoBGyXQB/4T2mkTGGFcESdLEIg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782909032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=J5IzwYzPDTeWx7tKr7hSDF5l+BLDO1MD+S8kZpieZcM=;
	b=m/2HYc8FINxazlpdW0TBLwraCcovytYFkN9fYcjjjM/0fYAUCRM0Mzk79vIif9kUa1AtSl
	KAFLIS06njbsq24EtXLmxnIr1Et+wl2V0OcevuLKlOOdhVUykVkTS8EQ4U4tkhlHUGOLjh
	O4JuzOVa8m963DW7r7M/iSqKzL7e0xI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="YLRVf/la";
	spf=pass (imf19.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c99672293cso3673685ad.2
        for <linux-mm@kvack.org>; Wed, 01 Jul 2026 05:30:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782909030; x=1783513830; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=J5IzwYzPDTeWx7tKr7hSDF5l+BLDO1MD+S8kZpieZcM=;
        b=YLRVf/lacDXqWeHayRkEjqka3XPRlvUIVv/ZTQV2LdVSIIUzOvvNqM/rVspEDWSwtS
         CnW1R3ku1RT/EoW2/DbHERKmcVxkbD83hriAxDCTD87SRM9G4q4Rv+4SmcZDMcKXvXi+
         fDDMx0eMODzunruIYm07lBv3qEjY7hXc7+23P+oWu632qTH2XZcEhCMpfaJV+yIfIQV1
         pA6hGFHCmNYiifn2QQgyfHzRP0DEknZ+HcllycApg28PUA+c2GHww1twDox5s8Zd//F2
         xyGCkEG8hyx4AiGHIZcIJbE34xrHQ0yI/o6nafV2EvhQhH6jO/nnaCmmOGsBugbTD3U8
         AOSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782909030; x=1783513830;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J5IzwYzPDTeWx7tKr7hSDF5l+BLDO1MD+S8kZpieZcM=;
        b=EOVGpt2B9D3QtfuD0VsTDDtn6LFZy/E4afQD8eGR5sqkt2zrmc1Iyc7nz7layqAsxh
         PMxKlM8pq9vOlm5Tve9PiKuCZ5Jt3EkLYiayjdcLzHb6HceNuCSIFJMNOqELeuT4CL+a
         wl77MgofRr96TsGpLKDJjjZkU1K9dsJk3qpv1CbUeIKVqDNcRMUHSZ+1SiIkmYdpI6Tq
         kvt1cne0dP6shY3Sle43KtUk80XvhzylKUOU1Cap64wf8Ey2nIpQ7kF94N7jDTLbpd6/
         /ZnTp3LGd9eK6e2PsJsTyCm5E2luD2XqBFPvCYduaiBs/upQuhQqwW2qlGrPnMl1ZLJc
         OsIA==
X-Forwarded-Encrypted: i=1; AHgh+RrHOkGpw2EQKot8l9CujkKcsaT5RWvq21FuZ37xnWl1zVHnQyteZ48Xdde37Gpdtx06v2OeAiHUqQ==@kvack.org
X-Gm-Message-State: AOJu0YzkBimiHhS9LNVziQIwnKqNPwcWiG9VYHpTaArq2V/ueNAiaQ3V
	qXxDsFnwR2rL7le7RUcNyqJSiF7lrtWQyUFPGwbHOofVKS8Nitia7kB6FIZSPwNgpk4=
X-Gm-Gg: AfdE7cn48QjHgkYg1uKYaqhtHj3oZr77U7Tpco84Xm5HW1e+pbf+ZEn2+KPhzNrsxba
	jVxQQ2XuwD7c1MnTKMCns4rulJOZDBq4ZP20GGejlM57bu0kb50DLMJv+xpVozGWWcLfCsuLtT2
	CH8mKWvqUoV1LapKBkSQ5JI/7JAfsnZrP0jg/SOOzCEjqPpafq2zqSoC9R4pyKXzB/CQveHuG5O
	bjq4IvcPF9yft+4PP3MQkUL1fIHdSYYUbzflyAnz5Ef6w5vKhL2lWlilJzyW7kbFdtAE0l/NbX/
	//nwBOyrxLHZDJMrtZrLpwhmhn3ZqEp+cYvIrTWZhRhFX38nwpghP3FNZsEwVr7hkPc8AjJ5Og6
	C2/6S139KMiT2j1MiQWRK3uL67Zn9CPm8WbQik7ZtbsSZGDzsIxdaajARL0ug0H30N0lakr3BJ4
	vxlZ8TCA6Ykcb18qjWgO22j7FDSI9MHXv/NSWAI+MunoxTN3O2hu+xtHuZ
X-Received: by 2002:a17:902:d549:b0:2c9:c991:3bf0 with SMTP id d9443c01a7336-2ca7e682ad6mr16606255ad.8.1782909030457;
        Wed, 01 Jul 2026 05:30:30 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca4bae1e2asm25166825ad.73.2026.07.01.05.30.14
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 01 Jul 2026 05:30:29 -0700 (PDT)
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
	cuiyunhui@bytedance.com,
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
	llvm@lists.linux.dev
Subject: [PATCH v6 0/3] riscv: fix PIO helpers and add optimized percpu ops
Date: Wed,  1 Jul 2026 20:29:45 +0800
Message-Id: <20260701122948.57584-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z546toyhoj51fnafuo1y97ituhmo51q1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D76171A000A
X-HE-Tag: 1782909031-656909
X-HE-Meta: U2FsdGVkX18dGApltuLVoV1yIzvnrSmTBdwLI7x5KdRUs09JBfeQcD/O2tUxgQyo/8r099A+//Thg19lchAKzNP9A5Nf6Qoc1kQm8I/khse7mNZtoiJewx8HAtQKziasxY3Og9v3Gblpq9ve6S7QejqSB0ZVjCZ4NyEypBnoKiC2/A3vboH57aECkl2/FzQJKFNXkIuMbgJhJumjDwlVcH/mb98aKeepSjNlCdFZ5G5I+1bZLicJF08LLotuGK/4iG0h5TyGEqU0xSJ7cPAaptqjiUhPt+4TAkpmYoqJyHbklXKBw4lVrQlXzRTTMBzoDxn8TTPDHlujclCVRu39JbWTSjtizFFxKn8pBhArQH3kyt3QeOIKwEe6qyFbPzveFUXFBR8XmYCeOiLnPU7WbTCvhMOR2uXXRTuwsERx3VaF5djondXLqefmbNh8ALE8ikx+PnLDhMwFCqRSddjHBq7nArtVqp8Mq7hsjEdtbVEMYDVBs3c40JEZcLQ7ckAzVMTXW3++ghoP5MvIBkI1LkX2IRqjZDurkBZSoZLqXjVqw0QdD52V3BP0hpYpKpqMu2zNYqYrJoe05jN7HgVm3gFay+aNBsWitD6Gp76GUvOC3nUdVUDJBIb+noAse948CQB2dL9D9mLcJESXq8EmiV/HCgsjWiHEqP4c2cQnlDXRxEKjINZnTKmzNzdJr6dldOTOyy8d6Skq9Fxnh47fGmMl6eSYOuhJ9yijqf9tPLVhqdZ7R9gtEBRrcHEc7Tw1X0nHcCSJSv6xuAp/DemutXQmtEbbu9uSyX4CsfABWZRMKFT89VHFuCFbUrSy87gi7PnNa1U2tWIwzHnEDSKsw2TtfOIeohOLVimOErge5XfodR8w6dYbMtzY9yFi2blwWlZJoeMzK2tHCqOveCHQ4xDiYeeGPwL6EOWJwvEVFNi+hyOGEsmlbAFO4VzKK0k45ainx5DLGYpfIiSMYX0
 bd69SeJZ
 EKIdIQRpxPcjSfT+pHuxCpLugWwmZLQxP8ICqv/Qs6URg1sEeOrLiDdYFKqfuIi0YeWhFTwMZ9XosmcF7gDyIqi1cmCB7SxDYqdmwsOXCb/XKvlvFfW0RmLuwseZVjGcpGOBKWAHNv08KdM68cFD//GBWqBMtFckIyYZYr68h+I0h1C3s0dFVK8c5Krd4SjdxC5Dg+3GfKMU/j5nl467UDGqJPJ6lWfoTQOyBa/g/shPJykXvaXvRZbourUCrwZp8OlPX/PkSq6RSLUYCjIG7/BHjglY3jx0uaP0tnqoV38gvFdek6Lw6TZPvoNBsIWGNU2hNWB+2MsoQZ8hlqm8YeK7rgCMKPiTfR6Wud1HFPp3hjDikADsZB6YXa+elZq/0CvSHGLfTX0h/vLT+XaFwG4kKmw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v6:
- Drop the extra PCI_IO_ADDR() helper; directly guard the RISC-V ins*/outs*
  helpers with CONFIG_HAS_IOPORT.
- Add the missing <asm/cmpxchg.h> include to arch/riscv/include/asm/percpu.h
  so cmpxchg_relaxed() and system_has_cmpxchg128() are visible.
- Clean up the two 8/16-bit LR/SC fallback asm blocks to use consistent
  old/new/field variable names.

Yunhui Cui (3):
  riscv: io: avoid null-pointer arithmetic in PIO helpers
  riscv: introduce percpu.h into include/asm
  riscv: store percpu offset into thread_info

 arch/riscv/include/asm/asm.h         |   6 +-
 arch/riscv/include/asm/io.h          |   8 +
 arch/riscv/include/asm/percpu.h      | 288 +++++++++++++++++++++++++++
 arch/riscv/include/asm/switch_to.h   |   8 +
 arch/riscv/include/asm/thread_info.h |   3 +-
 arch/riscv/kernel/asm-offsets.c      |   1 +
 arch/riscv/kernel/smpboot.c          |   8 +
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 8 files changed, 317 insertions(+), 14 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h

-- 
2.39.5


