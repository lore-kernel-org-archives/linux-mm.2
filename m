Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07A64C44512
	for <linux-mm@archiver.kernel.org>; Thu, 16 Jul 2026 15:07:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 207686B012B; Thu, 16 Jul 2026 11:07:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1430F6B012D; Thu, 16 Jul 2026 11:07:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07EDB6B012E; Thu, 16 Jul 2026 11:07:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D27126B012B
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 11:07:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C57DA4015F
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:42:45 +0000 (UTC)
X-FDA: 84994603890.19.5FE1CA4
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 4A0A920007
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 12:42:43 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YhDNmB5s;
	spf=pass (imf13.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784205764;
	b=tT+jqM7/GitM3AyEfp5Pi5dLLYP57MqqMzHx/yWGOOWh/FTiLvy0zkuiq7Zr7dZggylkoy
	UnrxTRowa9qEi2/3RtVxgybo6A/ZcHTxe1CKtjSUwwaTcNzp/LC9Lo3gKG6GygM1drWL9q
	Uv8s28E3qpxnnOIIGl3sq1nGRdEbVak=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=YhDNmB5s;
	spf=pass (imf13.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784205764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=SXHE9RUaBpTIzBZsLxmZxoZ7/zzqOF995lpxXageMRM=;
	b=Vvk/eg9JhdTPD2Hr+ZmRzyYzqVV1dmD7jlMaOpeGLoyn2qss2/iLVYDkfbzaHQXEWcyqRW
	lFANNBWGUT7g+delxuWi5W6YT3lTIF1Yhoo4mbRlwLTbyFfIkIdij4ezsgXNqeEESGSZiJ
	+ZJTAjd6rIizX6Fwv7dEIScg+WWdKC8=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-84867f07d63so7460892b3a.2
        for <linux-mm@kvack.org>; Thu, 16 Jul 2026 05:42:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1784205762; x=1784810562; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=SXHE9RUaBpTIzBZsLxmZxoZ7/zzqOF995lpxXageMRM=;
        b=YhDNmB5s1jxq3ih7cBXaMIhtr7RjztmaW3mj0iOeJamdWVdZTNKe9Zk5SLyM1FlPHr
         CzpwIwKMx+BmVfP/xGLpveZ1s1WyBLRSG40iPW+M/7hdDnKNjhjalV8goonYnkpAIfSm
         2KP875+LDam3x0iKu2RZRJXl4AfNspYQlYiJnXYz4ERmnlQ/Tp9B1Uka5ofwrKqk0Wvs
         zW1QL2WoRey8OsVZb1zfEOtfjjSD0KxzphiEwEQ8VGyAWOYwAsBLdoBecyhfbFoXgwDW
         9h8+An27psIfjgfU75fRYxfh5k3BDIJTmEGpuAHnhiGaELysOpFCLX+OcNGkYTvmuLFV
         +B1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784205762; x=1784810562;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SXHE9RUaBpTIzBZsLxmZxoZ7/zzqOF995lpxXageMRM=;
        b=L4O1i4XUlxGFIHRLeo/g05Mvf12y8xNLTPGhqdFrIHB8rXjRTW5k1jxIWDZVpgp1Mf
         I6Eewpg8yGjk3A47ORyb3XsiPSFlkKtQIe9/nbX0PaQ5YkYuULKa51E4hsN81lYM3040
         p62wUfozJM3D2azbtrOcOEmIzd2RmJOUdSGXqE3HTx0XxsBpE2JepK5AepP/NCen02gV
         4+xt8jjHL1AnO0YqWpgvPEAJbMJHZm8WijsknJZCLoV/gWg9eONM36tggDpztj+xt3G1
         Umz21Z8KEJGLh/JQlVKsXz7xsk9nMFJ0WFLO2pNV4VYtGOffTLZEV0p1ckUahBAH3gq0
         08qA==
X-Forwarded-Encrypted: i=1; AHgh+RrpjrUP9ml2LeUbgG9EfOzCSKStu5dtZsUka+PNOR0OHEyobXrJG2XiRhqskIWES38ogSHHTrsdGw==@kvack.org
X-Gm-Message-State: AOJu0Yw1ygvXbkquof9yEEyr4cK/G9aErsDua3QFofxdbNSMnjb5dPwX
	FqxL1DLrkxLSu26/HxLsaQsSFfGe4wcgoaG15m8ygkV665xKTWrsFmUIsZCq/ruC/Tg=
X-Gm-Gg: AfdE7clqlg8TdrPkWJpTmMzmJ+T2Yrsevka8C0SPUfSRTWtO/SJwmLsj/c6ZvrLkQPJ
	BeOlC5kvN9CtF8mFFG+7HI4CX6I+s05ukr5tOM0s3nY+cw6lU7z8At8tsbPKW1ZmWRwCDMtd6fR
	fqzJlF/ehJRVNi7C0pnINaSasuNDUC+8EPMPDTRbvbUNdqjW1EqHCSOyPmntw1wNkeQxUOrkmW+
	ZXwcaIF3wPmRK6z26fINaXOaS4n8y3nUnLi5dALgB0nVeSDHxEunCg27Ck58ceiu0+oCkv4+DqP
	rHHHOtR+oMW7gwagPmQTtkUp0aarNEZwOby2l4bR/jbW9nn87wEJ+LUXVGeRmtJier1Z7DVGDNo
	7jnONBt5HcoorObD1PDV9QwKY6/Lww2DO2MTpExEEPvsIjLsMK72y3whiWI5DLo5lgvJQ2ATPlc
	T7hK3zrFcRglCxHPbxt59jL+k=
X-Received: by 2002:a05:6a00:815:b0:847:7f38:27c6 with SMTP id d2e1a72fcca58-84a672b4789mr6422956b3a.50.1784205761835;
        Thu, 16 Jul 2026 05:42:41 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([2408:8606:1800:501::2:f])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cb258eeaba2sm1730793a12.12.2026.07.16.05.42.33
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 16 Jul 2026 05:42:41 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: linux-riscv@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org,
	kvm-riscv@lists.infradead.org,
	kvm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	kasan-dev@googlegroups.com,
	Yunhui Cui <cuiyunhui@bytedance.com>
Subject: [PATCH v2 00/15] riscv: add Svnapot PTE folding support
Date: Thu, 16 Jul 2026 20:41:35 +0800
Message-Id: <cover.1784201104.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4A0A920007
X-Stat-Signature: 6snet33wdy859h89gpe9afuozok9d3s6
X-HE-Tag: 1784205763-410069
X-HE-Meta: U2FsdGVkX18c8xN/cCejtDSTE03KPhR92HTjwVd6njhBu6i9JkgaMQWHVEs0u08oVPFKuyuFcnwmt2pEsLRS1khe6Rd3TezSyCG2BtuouArxDWj+fVGjMFiIxkDdwlG09B1Gs99ajvR6qrKt1ZY017n5PxJ6VA5+jQeo+J+KqRV7uUpf6aLaMOPxtx/kYlGR+gniv/JDvIESSxM89dj5wwh0RyU6e2zIWqP3CPygMmSc/0xHDEsIl+em3KRhLOGWTc3wBED2A+sYm+nNJT7ky/qut3Vb4T7OwfxuRVIGA3U/w6vSi9H8xero82hwpBLAu2IxcfGUkUMzgowF0RwXD6SvKK1hf1r672gA7kJIV3GLVbXJ+qSjV4I09oAIPx6UyZMSt73KNoPM5QC7lvgP+bJCu+F5r/TrlNoOVleUHeK9yhlXGjJWCRIaRovR1wRelAMA4l/8VTfCXUAKgHtCXKENzr+Nw4ewzOWYPugDhu7TlXEbQg/D82r49Ss6pgxRBJiDgc2okh58xJlWyPdAi/mVzTHKA8fq5LM2ZvEyqpmsNKNp+hsnCZV3qg2z0OR1ynfvH25BtzUfSLEUViOVmkKFPSd2g9JE+fH2/Dhs5imX7Z0EvAg5G3rU4zpIFYgZm/D8+8yfui/SA+USeXPBm2FcNzNMKd14p4y77+PiZFgqZH1EVgDEk5XvoCxgQgqAv825BV0j03TwxTJuHII2mtiMR1hL4c5hoMYmqfSmtNQRJPzVdsfO0gvCQfyu+iROiZOmihR7gK4oAusK/2WHtuGDG0IUQvG5U0dm6hdZNumns6S9qMM2XWc0hpPsUMQ29/fQnYDTMAI7BCFYfcmIqZGB0RTvaHaM+5j30v0InOVRfUXqGV57x1P+mzMEQvcdQIWlUUyiHVfGSrBWUjCBh6wYCIbo9BA+TzfbNCiZMPhQ6ngMCxUgJWB9qXyXWvIaUA3+jwpA2EYelXSqWOS
 T4+lMxme
 sbGjwhGxIWoLvYHMGRlvpU5oW44If70KO988EsEBw61O2n57ONEoEfxWTpujrcsNh+GsUza5+KhmaUn8xXqrAZtW4Re90RjzaRPMA4668zHU5EeXDy8szVir4sQDx5Br4iqrC8mMdQANtW8Wmry3rdhcV3xpv4njnNRkuTNtGqJJYpCF9xLk76r5WVV+CBJ4nqAyHJm2D3FJXNZInFYRH6WFTHdnaM6hItFOxom3SEVH1TXFPKg8tusbFUHEYuGtbzDKbbYcmfwC/XMNZxXT9XhD2NTNRaT+cCYOxxZYbPf8LKyZCRWvzU/4qrXqqyNtDuP1wNMZidG0xwgYrwXPjxKkiBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Svnapot can encode a naturally aligned 64KB range as a single folded
PTE block. This series adds the RISC-V MM support needed to use that
encoding for suitable user mappings while preserving the generic MM view
of PAGE_SIZE PTEs.

The series starts by adding raw PTE helpers and switching architecture
page-table users that must see the encoded page-table entry to those raw
helpers. It then introduces Svnapot read-side and update helpers for
folded PTE ranges. Later patches make the generic PTE batch and leaf-size
interfaces work with the raw encoded view where required, avoid redundant
A/D aggregation and TLB flushes, optimize mprotect() for Svnapot ranges,
and request 64KB executable folios when Svnapot is available so text
mappings can benefit from lower iTLB pressure.

Dependency:
  - This series depends on the prerequisite RISC-V patch posted at:
    https://lore.kernel.org/all/20260618064406.14508-1-cuiyunhui@bytedance.com/

Changes in v2:
  - Rework the v1 7-patch series into 15 smaller patches: split raw PTE
    helper introduction from the architecture-user conversion, and split
    Svnapot contpte handling into read-side and update-side pieces.
  - Add the generic MM helper changes needed by folded Svnapot mappings,
    including folio-batch comparison flags, raw-entry leaf-size queries and
    fast-GUP-specific lockless PTE helpers.
  - Make the RISC-V pte_batch_hint() implementation honor folio batch
    flags, and preserve Svnapot leaf-size semantics via __ptep_leaf_size().
  - Add follow-up fixes and optimizations that were not in v1: avoid
    redundant A/D aggregation, avoid Svnapot consistency checks in
    ptep_get(), avoid A/D aggregation in fast-GUP, remove a redundant TLB
    flush, optimize mprotect() for Svnapot mappings, and request large
    executable folios when Svnapot is available.

Yunhui Cui (15):
  riscv: introduce raw PTE helpers
  riscv: switch arch page-table users to raw PTE helpers
  riscv/mm: implement Svnapot contpte read-side helpers
  riscv/mm: implement Svnapot contpte update helpers
  mm: extend pte batch and leaf-size helpers
  riscv: make pte_batch_hint() honor folio batch flags
  riscv/mm: preserve Svnapot leaf-size semantics for page-table
    consumers
  riscv/mm: avoid redundant Svnapot A/D aggregation
  riscv/mm: avoid Svnapot consistency checks in ptep_get()
  mm/gup: add fast-GUP specific lockless PTE helpers
  riscv: mm: avoid Svnapot A/D aggregation in fast-GUP
  arm64: mm: avoid contpte A/D aggregation in fast-GUP
  riscv/mm: remove redundant TLB flush in napotpte_convert
  riscv/mm: optimize mprotect for Svnapot mappings
  riscv: mm: Request large exec folios for Svnapot

 arch/arm64/include/asm/pgtable.h |  25 +-
 arch/riscv/include/asm/kfence.h  |   4 +-
 arch/riscv/include/asm/pgtable.h | 480 +++++++++++++++++-
 arch/riscv/kernel/efi.c          |   4 +-
 arch/riscv/kernel/hibernate.c    |   3 +-
 arch/riscv/kvm/gstage.c          |  25 +-
 arch/riscv/kvm/mmu.c             |   4 +-
 arch/riscv/mm/Makefile           |   1 +
 arch/riscv/mm/contpte.c          | 804 +++++++++++++++++++++++++++++++
 arch/riscv/mm/fault.c            |   4 +-
 arch/riscv/mm/hugetlbpage.c      | 135 ++++--
 arch/riscv/mm/init.c             |   8 +-
 arch/riscv/mm/kasan_init.c       |  16 +-
 arch/riscv/mm/pageattr.c         |  12 +-
 arch/riscv/mm/pgtable.c          |  52 +-
 include/linux/pgtable.h          |  71 ++-
 kernel/events/core.c             |   2 +-
 mm/gup.c                         |   6 +-
 mm/internal.h                    |  39 +-
 mm/mincore.c                     |   2 +-
 mm/mremap.c                      |   2 +-
 21 files changed, 1542 insertions(+), 157 deletions(-)
 create mode 100644 arch/riscv/mm/contpte.c


base-commit: b8809969e1d7a591e0f49dd464a5d04b3cf02ab1
-- 
2.39.5


