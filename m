Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4916BC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:04:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A49A6B00B2; Tue, 30 Jun 2026 11:04:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CC66B0110; Tue, 30 Jun 2026 11:04:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 291966B0114; Tue, 30 Jun 2026 11:04:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 054A86B00B2
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:04:29 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8B88540537
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:29 +0000 (UTC)
X-FDA: 84936900258.09.1E23BCF
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf18.hostedemail.com (Postfix) with ESMTP id A83261C0011
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nPhLHt+1;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831867;
	b=8QhtwUVwtB4jcllG0Ypu/YfTfC9UMFrHKZh8w1DK4G8cAHySoFVhOAhkSK5de2WCnG9R1T
	MWwcFyGiAko5B86Zbvjx4usgR9VD8znjFzEm2XDMKEZEwuvgYqN9vlLbKZrwpf4z5ljSnH
	YzkDf+56OOh867ov0SdtmUC+g1zXBkg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831867;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hkhDPMkIn7o4S+p4EJjWg1/vRnrXI2zfxcLsfb3CwqA=;
	b=1i+XmzmNKpYbDiNDOZjiQEMyONLCW+qfKWgLHt02vFsqpyhlooSMdiAdtFe3S1n8E02c1x
	HLyMLOpOccHYt5z+nBjkdrKGsn2t9wiTB8LfMdEoh7a0PuO6aKTIz6ISIDfZ6fLbr/Xz20
	Sq6FpqMfLQHrCHgSGkUB39YGI081xds=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=nPhLHt+1;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2c9c1779fc8so11332045ad.3
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:04:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831866; x=1783436666; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hkhDPMkIn7o4S+p4EJjWg1/vRnrXI2zfxcLsfb3CwqA=;
        b=nPhLHt+1mbWcSvP0n9yK2XxU+fHKlUM2+vCbp++v+zKaHq86OreaEkPQ6YCMzwHOI8
         Q81trJ/wWHQ0moUR4K6idm65wBSLS6H+viZlJ/vypYm2PrmwPbx0zxvJeSeajztv9j7R
         E71HuD3L/4/sv6V69ld4KAsoV83pmWoGT5qzmfOuC95N03JwcwbtUQEvNHpJgrIZCpQS
         jF0Fwb2MZ6r9d/7YS1VCCJ02NS3HynDSJeWQCiJW9HOfeT/jFWHGqvgCCGYQ12UpRyei
         lfoMsh7eLGEiKt9GmtOCwoDfKQCZPksxj3Qr/ZFbO1lbh4eJNAWmHeSGaWgaAKN23SOe
         z7dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831866; x=1783436666;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hkhDPMkIn7o4S+p4EJjWg1/vRnrXI2zfxcLsfb3CwqA=;
        b=nIKUZhTIcbAIRK2ri1FWOIdgteGD1MoPpGlRIap9hoiK7mUadigjoVJoi/oc/tdkxy
         sZKEHUx2cDpwHqWEcbMTcYMZ7nu1Ug7z6+nyV2rf5zudmVE/WW0SmTzsMhE0HSeiTcmY
         qvzimF/3BgShx16U+FKHIDjls7Y/kpAiWavaVl3ombIAqu3FeTGrA5YVeL9EWxCDcVHo
         NzmSKWXS3uOxDxHHqp5MUCMGIfEahSXalgpNeE6FuWRU3XdGrpC446RLna3SvF0HuVj8
         Kn0yuTcY8UBh8smD2SQ1zit3xTeZN4+/8Lt6RQkYvRa1zyXEbUiZIvXRytU+FQ30KcQT
         MSjA==
X-Gm-Message-State: AOJu0Yx9mMrHr80HAKgl28ItUSPh01s74FVZYz+GOsNb4dDZXDWb2xa3
	SezUCMUY3eiiY94q7dEHS8SumjOVqArrfkAKQBKUyU55ODq5jtVnpXmp
X-Gm-Gg: AfdE7cnzidoKul5vkIVhXnEGrVt03KxJFxx5s6VEvmjsCZn+KQs2a21TJZS0CAHEVhX
	UoNLXKj29SB0UzU+qV9pLCnLM2uWTRDRn93qGb5jqRpVAlsWb9Qy7gPkP0ZbNbG5LNUZ8YHlK5i
	IeQKn88a99tpHeHPFWEdN7Vb3W1Cqxgce+SIxLdL1fvlaVJIXWM+/QB7zLp5RZN8+cGPoYnpRLw
	jMjWG/0izq4R7fwU+6HhVzUXr+4OJJ2Y+psFWxuGKguYMQQi2CnDHTnN9pBmqG3kqY0jlywaKFo
	AEYA5CpBl60XiEVsOYou9WlOWNct9jkWAo2uLjHHDQqJZ+Lgw607UiwwITEteCyEBuEnxXhQdAy
	ON/lwZKn+1/fUaper0AhMoorr9HhjGpO+u0WnsCTZcF161JD02+JFO/bnzXFGZ4lOww5/Q/AR7f
	JN2L+ukYQ=
X-Received: by 2002:a17:902:e541:b0:2c9:97a7:71ac with SMTP id d9443c01a7336-2ca2ea23674mr32988355ad.39.1782831866110;
        Tue, 30 Jun 2026 08:04:26 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.04.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:04:25 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Albert Ou <aou@eecs.berkeley.edu>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <ryabinin.a.a@gmail.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Huacai Chen <chenhuacai@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <pjw@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Will Deacon <will@kernel.org>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexander Potapenko <glider@google.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	Andrey Konovalov <andreyknvl@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-riscv@lists.infradead.org,
	loongarch@lists.linux.dev,
	Nicholas Piggin <npiggin@gmail.com>,
	Vincenzo Frascino <vincenzo.frascino@arm.com>,
	WANG Xuerui <kernel@xen0n.name>
Subject: [PATCH v3 0/8] treewide: remove unnecessary invalid range checks in memblock iteration loops
Date: Wed,  1 Jul 2026 00:04:05 +0900
Message-ID: <20260630150413.1718632-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A83261C0011
X-Stat-Signature: q1qegkapqmnm6rf9mpmnf83qi5m3u16e
X-HE-Tag: 1782831867-966698
X-HE-Meta: U2FsdGVkX18G/YvNmdX0wtf814Wf1ZXLusXhIxEe1KI+YxhZODB+bAIHJTdD2Lu0dlJYG0+jdi0eMyGAcX09DICltpjfx5FXi/236iBDTDR2IPtl4scgRMdMrtjFUffiWlSwOwJ32BRZ+vSe1lKLIYHCifAs7/fRhliLZLos1s3kNs0LB1eDnmFoeKfQ2yVXKrjW2MmavcZ5/QxbZEzhpn7NT1lkzTe1/i/QGVZrGRvkagopCyYBVawxujgbkkk5r26vkukmyn1RIekDCTfSRlk/O1JzxWuYykf0qEXy9Mw6KenhBMXR+CMt2aHptqdT811e6WubonT8jSOjVGeJVTR2dbD0EKHLo4l0h5zdRWu//Qkhh6I/ciAvAp12nl5WFCfzmoDYMmBztH9phxFl5seLBxUxW+QteyZm5LhHk1eqgQvcOP1nez6x+Jd6sskxcQzSTN02JJumblc9CcykGEdu4DVdk9agScWH+EsQRHi0bNdWk6qStPXaQ2YaQKyTMpwZYDODCBF9HD0tWus0rlSWtTqQVWag2DdAc+MUEp5d5ZJsCsn3g+qLdt/IT4XM8mm46E60q91UM6bUUWYgDxQkI898ZCSKUZImgiCuDqMC17zBYGq/jmZ7p4tv9178X7YV/1AoIxqsKwyAjxbp2wGO/jBEuBEr3A7aZp3jJIbpthatB5AtmoTFIVVPWNI1tYiGqB1dm3r4TCqZRM2dfljHLN7Mz8YB4Vyci5eadRQuNCXFYDb7hizhEA+S311OWaANe4WJUPwN/TYwjgaux9ye8T/Cq1kM/KMhWBk8SmhKF4SWAOjBQ9uPVutaKIig5RQIzMT3Q4UGhot/MB5iNNPDsDdy/B2zdtqrwnAlouyDgTlpL1cwYfgW3s9S/12xoMGmoX4+JBRc9RNArlnHU/rgj2/HYk8VqoYBFufwGumZgBToiNnBcdOB6JX8okKJ0KN9svg9bOQpc2D/d7/
 8ErHlLFA
 o1cD8P5GAzUt6e6rknAO7u+S1NFxsByhoVTEIKcONSZ4xgjeNx4ZlU5tim9GSOcm+LaUknltN7fMR0tb1L1WrbVXplhYo/AHA9By+8lzoL3AKo7WrygkTaYYEInw8uC2m98kTxUDn6a+djfA5dcUNZezA8I5TklXFW3X6kB76kkvPmBNQXF6QDqf0HVAkJYCUknXtqMQ7XZog3z1tk6zEfU9pkkBBIj3CcJ87dk2OiGhy4ly2YQQ3J/906ENXqahbBqcAxWhnz7xGzl/hex/GDik1ipHEYjNxMqiGSbzKtEDkc9D/A1dK3gKdt38FxHogdrxODJmw4i6jAscF7Rlv+rb9RAcgt5s71k6QRUfSM0jbUVTvGZ8I5uVGDWfqtCDPA6/u2XO9I9E+9MrswZU6QPY8QqwEyCSAmyZARidquIXrdXzSz+kxbtitBHf6DNyjYoW1TKSAyIsuBVr8HxyrjBLKR3gbc5HNFv496aJh3THRAtjP66LVTAd8iF7YBB7B9BUM7kcFhrsFX1Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The memblock API guarantees that for_each_mem_range() and
for_each_mem_pfn_range() never return an invalid range, meaning start is
always less than end.

Several memblock callers still have unnecessary invalid range checks in
their loop bodies, so remove them.

Patches 1-6 cover for_each_mem_range() callers. memblock never stores a
zero-size region, so the range it returns always has start < end. Some
callers apply __va() or __phys_to_virt() before comparing, but these keep
start < end too, so the check is unreachable.

Patches 7-8 cover for_each_mem_pfn_range() callers. __next_mem_pfn_range()
skips any region that contains no whole page, so it only ever returns
start_pfn < end_pfn and the check is unnecessary.

For reference, commit 36ca7f4be809 ("arm64: mm: Remove bogus stop
condition from map_mem() loop") did a similar cleanup in arm64 map_mem().

All these checks are in different trees, so I split the change into one
patch per arch/subsystem. The patches are independent and can be applied
separately.

---
Changes from v1 [1]
- Add review-by, tested-by tags from v1
- Add missing simliar patches(5,6) to patch series
- Change base to rppt/for-next

Changes from v2 [2]
- Remove unused local variable and braces

[1] https://lore.kernel.org/all/20260621145919.1453-1-ekffu200098@gmail.com/
[2] https://lore.kernel.org/all/20260629163736.1606688-1-ekffu200098@gmail.com/
---

Sang-Heon Jeon (8):
  arm64: mm: remove unreachable invalid range check in
    kasan_init_shadow()
  LoongArch: remove unreachable invalid range check in kasan_init()
  riscv: remove unreachable invalid range check in
    create_linear_mapping_page_table()
  riscv: remove unreachable invalid range check in kasan_init()
  ARM: remove unreachable invalid range check in kasan_init()
  powerpc64/kasan: Remove unreachable invalid range check in
    kasan_init_phys_region()
  mm: remove unnecessary empty range check in
    early_calculate_totalpages()
  mm/hugetlb: remove unnecessary empty range check in
    hugetlb_bootmem_set_nodes()

 arch/arm/mm/kasan_init.c               | 6 ------
 arch/arm64/mm/kasan_init.c             | 3 ---
 arch/loongarch/mm/kasan_init.c         | 3 ---
 arch/powerpc/mm/kasan/init_book3e_64.c | 3 ---
 arch/powerpc/mm/kasan/init_book3s_64.c | 3 ---
 arch/riscv/mm/init.c                   | 2 --
 arch/riscv/mm/kasan_init.c             | 3 ---
 mm/hugetlb.c                           | 7 ++-----
 mm/mm_init.c                           | 3 +--
 9 files changed, 3 insertions(+), 30 deletions(-)

-- 
2.43.0


