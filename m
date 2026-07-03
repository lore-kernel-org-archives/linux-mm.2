Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D367AC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:29:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6589A6B00B4; Fri,  3 Jul 2026 08:29:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 609096B00B5; Fri,  3 Jul 2026 08:29:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F7A86B00B6; Fri,  3 Jul 2026 08:29:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 25D536B00B4
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:29:02 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A518EA052B
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:29:01 +0000 (UTC)
X-FDA: 84947394882.16.C249952
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf22.hostedemail.com (Postfix) with ESMTP id C4F50C000A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:28:59 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HL8h+CtS;
	spf=pass (imf22.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783081740;
	b=tPw+1FXvuIvPQbCb+7z8SfnuNBsP91YOjN8x4X7hyAr7bIXkI6DeI6436zXG+99/RuO4cA
	Yxy2qRz8hSvu53GJ5TluCPeJqNHRser9WibCsRFX5S6fj9Ry3gP/jHujE4+tmGvkXMKvjd
	uMck84KSMZvFEc5sdiYYPCkQtcP82NQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783081740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3xWVG/3qQZSSCl9XZAnFe0CG/d9wAGXcusZYIWuv8No=;
	b=hro/DqL1H8Hf/nr3Ee0v8NAFYD+MI4Ow4htmwRSK7vb8Ud6etxndgpBX5+DGa4ImdYk3jY
	sXRO9nJTV9BiZ5Um8gi9vULqCKFfFfr1FLM/YFWdy3UnFIS2GfZEZBUD6fa0/ZzrNDeljQ
	kE0wXOM2a+s5+mCck7x3lyf6BtHNjfI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=HL8h+CtS;
	spf=pass (imf22.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-84592b55832so329499b3a.3
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1783081738; x=1783686538; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3xWVG/3qQZSSCl9XZAnFe0CG/d9wAGXcusZYIWuv8No=;
        b=HL8h+CtSFlCDxUMs5i4F0CQSMVjpuFCSFoK8xK5dVDR4k7VrV62u0ADt+1dCwdwtug
         ugQmAGms3E/g4MbwAFPm2oKhovUhv0PdChZsDME8cNcV6Q+bPyqFU4zr0bP+e02swQZr
         UNq6Z3MJRCL6LluubCDOt7x/Cjp/CXPTB/Z8nc4N5qQn3Ra/nG9p63EkxZe3FZce2IrZ
         0cCVvTuJLk4LwnGDSEC+xkCtRdz2CeXnOd43OIg7Wvkxy4AqG+hL+Uxf0PimEDL+t7J1
         ydz9ed/6t8qYYUEGoJZQKxjXvkyxfWwkvk6UNs7McwYANA9HX7sJNkLKL1rkghIq2/W/
         6n7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783081738; x=1783686538;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3xWVG/3qQZSSCl9XZAnFe0CG/d9wAGXcusZYIWuv8No=;
        b=hXG3fTF22alNx8OZ7CfxaAXTiWVWvLu6vwIovNlJUfs8HEWKLy/4Sr3GsiOP4hc2S6
         3a5P/u+GZhE6vSy0TNs4iEM7sX2X11PAuUSMIWMB5M3PU/fKRDv5ksMR6CF072YvLzHe
         jpCzirCyyJGw7JZAV6Tnpd6fmIRS3faolecF7/DstkO4LJA0SeOQSayluzL2KTtRCfOj
         3vn7g/DzJq2DKncfcWANmHMY8h8XcKcR6a5P8Xsg2E42zgZkOli4Kizsif5F3PurgFwQ
         me3GYkG471/N4ZmJQ8Q5Npdo0aWWTTGxzqjzF2Yp5t8EeQ+f1y1Pi7uf5kVAYJko1UDX
         l7Jw==
X-Forwarded-Encrypted: i=1; AHgh+Rps/GR+QuX3AxdihP6YT+cNDG4ILuNg7fMIhIKr4Hd0QZmIvukeIdn89v0U5FrYE0s1xyD71Q7Www==@kvack.org
X-Gm-Message-State: AOJu0Ywo7A1KNuZaXf/HaOPtyFz5gWo/wTRTzzJog2enkuR4bbjObAmz
	MrA9xqk3NPcgZ1/aUyonfPaBMMnijVrEDNLuOYZL1hQAUTFXkFEPjhvqgJWk1WbN0l0=
X-Gm-Gg: AfdE7clIcIibbRwyGsS7epFukcJNG3SWMjh7o3h8CibPmwIoGTBrhYeisnqQktizFK5
	p1KvO2IPYUncYqW7IargWTBDLklmdE9m0sV1VJcz1qXm0SV6tCbqUpSYyK8UAYLW2GvrKYNS2Pb
	Q+IU8S++FiICJ3DdvaXG+0G8IPGwWWh/viMTHUsWI4BHmGyh/QILTfPcrhtefV5UX7F80T/IPpB
	qV0X6Ifkmn2ZPeah7TQVLpGVs9ePdUOQ83kZ3o+RlOLt1yrK+vCRyzlVKwzl3VVMzwyfsV/WAf8
	BGMLpdr9a39WVz6J8zn1dIi0PEMI4knD6blsWgXh9h0VH/ei8NcHUSettxoH5gAqvbG2i1DgFCy
	VWNrhwjn5lEkyOocswaY2SeYLro+E4BA2LMrbc4RkbFHHULyuWsoobfz7utToXdRire4fF49HCy
	tgvoonBt8hL382nWcjFWZbhxpbcrLIUpoTlJo4j/s9288E5ByIKlfB64tcDN0+tA==
X-Received: by 2002:a05:6a00:18a7:b0:847:8b0f:2508 with SMTP id d2e1a72fcca58-847c0686cc3mr10380342b3a.13.1783081738170;
        Fri, 03 Jul 2026 05:28:58 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.224])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c9e8f3d74ccsm2705551a12.9.2026.07.03.05.28.43
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 03 Jul 2026 05:28:56 -0700 (PDT)
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
Subject: [PATCH v8 0/3] riscv: fix PIO helpers and add optimized percpu ops
Date: Fri,  3 Jul 2026 20:28:29 +0800
Message-Id: <20260703122832.15984-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspam-User: 
X-Stat-Signature: 8nokxcaqpeubzb665rriq95i35sokxr6
X-Rspamd-Queue-Id: C4F50C000A
X-HE-Tag: 1783081739-179163
X-HE-Meta: U2FsdGVkX19mCd4TxyUfInfS3g+Nnxgk7+ww/Va/tBe1GYkaH7JgyifprzWWNuuNf2hwQfkMjPBbvPL2EYBFmXMHmhctE1o10KWYIXxjsbFiPF9jG+tNTy49xKQhtr1Dlb2tmh8BRqsK70LlPmgOpTx5U2E74g3sd1rJKiOizQ6VmDG3J+M2Orysb2Pc2h1Ja1TDyplAB3O6xUHqthbRnmcisuIEQZVknZaJCnJxjn3xEauzjf0GNFbsfodMQQgEo3aqGuxe47r0cnV3GQDD5lh6ddd3/mRxHXXb8951Shh2qCFKpLKqRdZkPc68accVour15bUi7NJ6fl2wIG+Vp60uXGrpn+02QsJDNBeOs7WunaVVos6Ads4WorFjKOInTcl6TqOmJKu36MiJNPkAaks1mveeo6SzNDkxvXJbj/onhvdVekNeW0+epBjw5bY6n2gZP2+TO7M8wD2L8JaJOHJnBEVrjt5FSrzou+epZMhvX1P5B9PYepKmvcJ9fYG8LfSOwyGfapAorYieSFfRF5ZfEpVvL3OISCugsQ0GzqMyBVcnCFpz+8cEVQex41B6PnriZDyOmAw+5LmkenNQVVAIeUR9ctc/euHwT4NeHgcJ7FR8NILo8v2WL5CDOhBYnH47TNejCJT761YjzLG+F1qPek3YUpUPlWREZKBdcc+ZhrVt1tKSTVpjJWNfOhN3dhhMTZ/XbsxSp5ish1U5tP5gChDaO6Vsh1mS0Ttk8smbVk20p6+U3fIh0tip2l06YUUWuXi5nauFgl1wYnObEIqLgPBMqwgwFUROxXbSnYZz10RD4rcA5esDGNvGRQrZk2gCgNwYZ8r7yqTO1Z4e7cdVdN4QqIorqTRCoBntQ2OBb2DHXIepM+kqis4FHF84qngZazcEYfdfhfPoD6v/7smFrTcZO7+W4IwVaSI2k25ZpZMpr6hGBmFogeHBquuAq0NyvnIb7LTk8hyINHN
 3eu4vlNi
 eTuFcIpGFO70Te1E7d5R0h/fsfk7zrq3+uaouT4xGBl6w0+TtXX8JEWOAoN7Q9NOCSgEwEoJmP9q5lt3a3xJmIUVgGRfN/l0oFj39d0Tg3Dkr6Hc4muIy3jSgv1k3c6T3xENfKvs6/+K/sQAMvOvLssZoLU6qfTSTf9kwspx3fumbzk7KlIl4XMCytShIW8mbzi1SN8E/de5HH7TwGRXAjuftOwVm8nL0BRZN5TPaFWja3qNRl+1t73F58Q0KKGb1LdZ3PasxyyQ1XS9z+briQj3UqMZQdeQrds0nTDQW4ToaxvPoa45e/TcbOdD036kKF2pD39qKPBPRWGQBjG3U6r5TR9a/1IwoYOEwpJONz6sT6eLnHIwW2GzoFxlgsZZUAcEeORNIA7x0uEbpiX7nmQDnkQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v8:
- Fold the TASK_TI_CPU_NUM cleanup into patch 3.
- Pick up Arnd's Reviewed-by tag for patch 1.

Changes in v7:
- Rename the internal AND helpers for consistency.
- Undefine internal percpu helper macros before including asm-generic/percpu.h.

Changes in v6:
- Keep the RISC-V PIO fix local by directly guarding ins*/outs* helpers.
- Add the missing asm/cmpxchg.h include and clean up LR/SC fallback naming.

Changes in v5:
- Drop the generic HAS_IOPORT_MAP/ioport_map changes.
- Fix 8/16-bit LR/SC fallback masking and constraints.
- Initialize secondary idle task pcpu_offset before CPU bringup.

Changes in v4:
- Rework the series into the current PIO helper fix, percpu.h, and
  thread_info pcpu_offset layout.
- Keep the generic pci_iounmap() behavior intact.

Changes in v3:
- Fix this_cpu_cmpxchg128() build issues when cmpxchg128 is unavailable.
- Fix sparse warnings.

Changes in v2:
- Add non-Zabha percpu add/and/or support.
- Add the thread_info pcpu_offset optimization.

Changes in v1:
- Initial RISC-V percpu.h series using optimized native-width percpu ops.

Yunhui Cui (3):
  riscv: io: avoid null-pointer arithmetic in PIO helpers
  riscv: introduce percpu.h into include/asm
  riscv: store percpu offset into thread_info

 arch/riscv/include/asm/asm.h         |   6 +-
 arch/riscv/include/asm/io.h          |   8 +
 arch/riscv/include/asm/percpu.h      | 300 +++++++++++++++++++++++++++
 arch/riscv/include/asm/switch_to.h   |   8 +
 arch/riscv/include/asm/thread_info.h |   3 +-
 arch/riscv/kernel/asm-offsets.c      |   2 +-
 arch/riscv/kernel/smpboot.c          |   8 +
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 8 files changed, 329 insertions(+), 15 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h


base-commit: 7de6ae9e12207ec146f2f3f1e58d1a99317e88bc
-- 
2.39.5


