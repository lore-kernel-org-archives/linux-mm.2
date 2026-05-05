Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BF2BFF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 06:20:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2928B6B0005; Tue,  5 May 2026 02:20:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243486B008A; Tue,  5 May 2026 02:20:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 132A66B008C; Tue,  5 May 2026 02:20:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 022AB6B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 02:20:57 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 651091C02CE
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:20:57 +0000 (UTC)
X-FDA: 84732368154.26.759BB40
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2CF6C2000D
	for <linux-mm@kvack.org>; Tue,  5 May 2026 06:20:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=azLMkmaR;
	spf=pass (imf13.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777962055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=IABxPdOKi9qQ0ncIcorYGTDUXVbyRSpLw0RRqytGSAg=;
	b=noi398bmNhOxGbqZqZBMQsTxKIYM9dAlaeZnQdbys0bvsJhD6Q52/elbnJhxI4Gb0PmGfR
	4m826VQWfg+M7HxAmpRdw13Tj2DxwZl8NELxIjGlUl+GJac/jqnM7Gh37xSrsWfd0nJGE4
	HhuYrBxl1oRN0A5HVqtEH93ddlW54XY=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=azLMkmaR;
	spf=pass (imf13.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777962055; a=rsa-sha256;
	cv=none;
	b=FU+cip17S1XOxAWGeyUXBMBSFGBcPxBgKbxI38PcRnlWooURHXiX/Esf/iNHEkTQdpCZUE
	Hk5/nBjCmrMWxOlQWZgsZp860Rwi2wYvjeKb4n8qDudEn44T7nENmADf8v+nraXffaEv/A
	zBzmqk7bLz3Qkzqy3OzSIW/+AhSthPI=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-835399c11e0so978138b3a.0
        for <linux-mm@kvack.org>; Mon, 04 May 2026 23:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1777962053; x=1778566853; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=IABxPdOKi9qQ0ncIcorYGTDUXVbyRSpLw0RRqytGSAg=;
        b=azLMkmaRxQcQyUhtut68+BMbKPEbsBTT3nJ0CLi+X3DYjK+pmmqgalNzdP887ACTyp
         NORWgcPRJESTE3J3oCvtULlrZaFTP5KI5+5Px3RrbyZyy5KL3jM1DmYRYjwaL08Cx5xV
         ZpDOG/qmbPzQqWLiY3QemIfYxGdtWE98Vij37UBd25PgghP2dwcTWYDFNRy2SgOOyj+R
         I+MRE0yHuGyhKbtCsdFThFhavOk2rHvfBG+faZ1WHwSKekKMy9cZG1q2VjIOmYdOruwz
         4C5jSBin2xLihsmAOe8pA3UFuEhVFSiSAujlcFyeogBDztOhMl9ITp7RungzeTu0S+Ow
         kqvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777962053; x=1778566853;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IABxPdOKi9qQ0ncIcorYGTDUXVbyRSpLw0RRqytGSAg=;
        b=aZT3wa5vSwm2CdYOLhTHsrPfPYwL+ddVuyVECX4zn/YgBJXOHKR+eNyqObQLPuLRWY
         boshtgo2F1a/ALuCDy8z544/2aXeM9lpyeIoGxXxesjVPgAz7hoLOIAcgQeO2P42/F8h
         aLHpiQOFO8sYRH2gxVqFlHEKD2NQfDeDv5hN0Q2+ikQBGVYDtqq+MN9D08iQ9Y9rpgkx
         YwqPW7ny849SbdDi90PRTefXlsaake9sDmraxSiIwwb0GvE/WDcDnl+ITZfqKD354oGn
         F38pZPUcNWrmdOSeWqiDRsE7hpcck8DgroYU4uZT9vY+DI+GYsUY1sOcC1K+9grMJeUK
         N8mw==
X-Forwarded-Encrypted: i=1; AFNElJ9aWhYmF15M7YGI/76FS1nU32+J4XglK5Quyuo8YTAvLqxLUwsR+ScZw8Lrzabq2luTWr2jQVY02Q==@kvack.org
X-Gm-Message-State: AOJu0Yx/TUYeJJh97ELgcwtFeIchdApMuRMepn8VPG/81rsb66d5iJrO
	gqJZ4pdUPpfB15i5NvQ2LAdTp05XuHo63SxWV7rERY6N7dnmFnTuu+Jpjb+werUkSFc=
X-Gm-Gg: AeBDiesYAYuUDSeMTxd3E5jI7OMnrYP2G8OZFy1hdftLcA64nXBeuOnY9KIByrTNWB6
	fIMJj1ueQElowQt0UEph9H20Fv1K+MSx2qqiB9yG2AgrOy2091QTq7TZ8PvCdLW2d0zcZUz6Xse
	buYJYYfd2caDk856l2EXDbDCJx99yiif5lO+zCGPd7CRy5ywjkcEPWgoYiQPb0w7XIdNi+A+wPt
	G+84nND18I8DJnBF+cpwnujzspbNNkhDnQjM5b7sY6IUd53wU4D+DU7c0U2pyNHFgIW4g9FB9Da
	P1HLJOD1otaLYeOMac+S0wbxyvSD3oIfw9QDwOR2Eu9WeDp/ZRgkdIpUj9vtgZ+dv3RmZNYP8bs
	2drwD9OBlXm9/QJHon4+zEqgE4cZcvtf0LYl+miyM/0MywgbOTj6W4TSg9PiwzoF2xLVmwscEJ/
	xebla9LiwPb3vMUBQqw5IaaxmbJTA6YgIhoxhS/+zUSttQbkFDftJtqlp46lDPhJlJ
X-Received: by 2002:a05:6a00:c8c:b0:838:3f54:a0ee with SMTP id d2e1a72fcca58-8383f54a1aamr5208071b3a.7.1777962052522;
        Mon, 04 May 2026 23:20:52 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([61.213.176.12])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-839679c8c10sm880738b3a.37.2026.05.04.23.20.42
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 May 2026 23:20:52 -0700 (PDT)
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
Subject: [PATCH v4 0/3] riscv: improve percpu helpers and PIO mapping
Date: Tue,  5 May 2026 14:20:23 +0800
Message-Id: <20260505062026.91724-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2CF6C2000D
X-Rspam-User: 
X-Stat-Signature: 47quefkdgqpepd4scf4snyaxbyrzhi1w
X-HE-Tag: 1777962053-288593
X-HE-Meta: U2FsdGVkX18Am69yh95B4s0apE1IKG1+j1LvYuPj/kHSDB+Ci4FkM9VHGhkWynGkuvOmd4q8IFwKfXBP0U4IOG14C0R3703/4g3IVP2fVjWos2KbBK87N682e/ca75aLqjLO7fFI51RA9BAD/zS9GpSrbJm+WbKeYFyXXh0JU5loepnEACJhLtNutibpCHiXGAn9DVb0bR4HSM0S88wuMUBnqYnVvWb022Zs/QLBJXMMv+iaNkafjxmah34OGXIOubIDRP/c6w1cgWbdzuhvSzNumxdKxQzXjmTU7Gudrdx+s6llhAyDyP0F/hUV+PMRNjjwETsqENSCoVToYribWBUS3W6bAOTsxSiSIdwh2VuSC9NzGEkolX2Uz393dUKpAP5b3lH5Y1wuz9HebDLDDSh4RKUVhba/bkwOf1ToIWfuqenU4q3k6BF4SjrDzsoViEp6np39YAfccqxR2t6SIHxWFUdmo96ZYzjEa1y8a0AI02ix5+Kpd5L/VlyCtXj652xORqLcWGsHC07dk/qqaWSWiSLhWlWnH5absbEujuzoq8pltRAuMvcspCGmJN3kIe7STcbQmj+priSOHlZu07akpr1X8z5ovX2YamZRO0hbghxEIzhThmMGlo67hn8Orjz8h8+wcbv0L+xl6Od1S8GKNJPgdbBvEruToZJsfrTuekJX88ZyBD1Tg15MROEMyuXhB8CeM5Oe+UOYevyxY6PyM7LnKHbFgPl6doSe6dzxT2cFIuo48kiLnefqxaESzCQts0q1hplYvbSA2eOkuFhEnYSkY2fcUvWXU0BiBDpjWXSf6J3kReWCNMVEMoYe6JQX1iVreQioR2hJ4CRqtt6QGiiUQjPwoyD3mGDjjFXdncuAoUYoqf/hj9+QQoFbWI28rgVfYerogEqzMPUzQWE+3JWrTDibNln3DtpIOgj58P/bZmeuFQVrSZ3fs15QDhNOmiHo/RrigSPUItB
 zpbqFJao
 8HoE21WJbH/YirHYYBJMHQJAxQusBUAtekC1DmugARrzM5T5BFCqvCS4sWSBxp99EwIixTzooRHuWKra2hM/Ap3nLw1sswJcAJc/Cim5ydcFkHOpl+16PqzUKd6n3zAFgzC9G5u8So/Gly3ClGtPSI6w3ZBgYEftXVj4JQuvlUVaxqPOhWru3E71e4A4y0vR8nxqX8HAMa3Csp8bgd7sp/b5MoWExnKrsxpeMx3VnBIlY1btKUlNLkQN5h/lfWlqs87kbk0+cFVF7pOSHJbLslNQgTapqm6K/pp28k7LDcwKAUeElYxIFyjoQq93RY7bDt0zuPVfXOB4BYPxYfjAXDyzkWuE/H/jd67nc9ALBx26k6iJL72k/21lmqHFaOHEdKF+fsau/xnt1tg9+ygtdVFCNJ4WCh7v7aXPa3B4ovhdoWEhNfwW/PkCUTqXB7iwjhPmf/DOwKRHt+nStdxpyq4/0vPCkq+hitBgHKVPgc84BDjlGliWJxACg/l50WjeRr2v9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series makes three small RISC-V cleanups and fixes around percpu access
and PIO helper handling.

This work is motivated in part by build reports from lkp and by follow-up
review/discussion around the percpu access rework:

https://lore.kernel.org/all/202512202218.FI6bB5kV-lkp@intel.com/
https://lore.kernel.org/all/202512210052.w0bpUAAO-lkp@intel.com/

1. Avoid forming invalid PIO address expressions when I/O port support is not
enabled, while keeping the generic pci_iounmap() behavior intact.

2. Introduce arch/riscv/include/asm/percpu.h with RISC-V-specific percpu
helpers, including the fix for the 8/16-bit add_return LR/SC fallback.

3. Cache the percpu offset in thread_info so percpu accesses can use it
directly across the relevant RISC-V paths.

Yunhui Cui (3):
  riscv: io: avoid null-pointer arithmetic in PIO helpers
  riscv: introduce percpu.h into include/asm
  riscv: store percpu offset into thread_info

 arch/riscv/include/asm/asm.h         |   6 +-
 arch/riscv/include/asm/io.h          |  26 ++-
 arch/riscv/include/asm/percpu.h      | 284 +++++++++++++++++++++++++++
 arch/riscv/include/asm/switch_to.h   |   8 +
 arch/riscv/include/asm/thread_info.h |   3 +-
 arch/riscv/kernel/asm-offsets.c      |   1 +
 arch/riscv/kernel/smpboot.c          |   7 +
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 include/asm-generic/io.h             |   4 +
 9 files changed, 326 insertions(+), 22 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h

-- 
2.39.5


