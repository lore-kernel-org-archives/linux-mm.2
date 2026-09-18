Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3160C982D0
	for <linux-mm@archiver.kernel.org>; Fri, 18 Sep 2026 02:22:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9980A6B0092; Thu, 17 Sep 2026 22:22:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 922306B0093; Thu, 17 Sep 2026 22:22:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E9596B0095; Thu, 17 Sep 2026 22:22:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3EE596B0092
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 22:22:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8E473160475
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:22:31 +0000 (UTC)
X-FDA: 85225284102.09.E2BA57E
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf12.hostedemail.com (Postfix) with ESMTP id ACE6240002
	for <linux-mm@kvack.org>; Fri, 18 Sep 2026 02:22:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=at+180r9;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789698149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Cvk169Syep4khxZ06F0hThbd1fhib5jsWyzda7Xu2/8=;
	b=yIH1azqcyQ/2PSgIt5VMXYRadGIqnxfNnwuC2wVgJn+bAqQZkCBWP5EVcVdy0ckItopRLn
	hRshUYjO536SyB7GzNBWOmYn0NXW50jUIHtRd2tgOO2J1a00yfFt4wroJGWhcCf38lH0vY
	Cw5CyBQBbL8xmGbX6OrYXX2+jgsC6M0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789698149;
	b=zMsLcDBYhWdyHw6mVpWzBX42DqTbujSziOQmGXpT9zoDUvdqkgyyrSoTHmydCAlYpsY/9c
	vzsUHmStaXJnKz01ezUwSEUiPhMnHJEXCDcFhyN/ikNj2qrAAKxqkyEN9e16mfhBl9LELp
	76b9sTQux+5V2idRWx0LggT5VpzREkE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=at+180r9;
	spf=pass (imf12.hostedemail.com: domain of laoar.shao@gmail.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-85469e211a0so320742b3a.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:22:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789698148; x=1790302948; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Cvk169Syep4khxZ06F0hThbd1fhib5jsWyzda7Xu2/8=;
        b=at+180r9TqmrGzVq4jRz+IM0d31nQtPGCZZ3I0oR89lpb1gaxs5Azau+RyjuRVlh/w
         kH+dThzbMqkv8WGT0Fxj2Iw1EDyf2ITzaqx5uEY1X6kvdpJD2w+ivW5/ak7iL8YpdNIQ
         d6ZuX1TWyh9/zrVlDbO0b/jpLRByByG3Q8XdyjdkcB1r6lQ2gFSvU5aCMWxwHVCxAuNf
         gezl3CZ8pKTw+MsOUr1XFlnN+C9ZV/Bbud/TGp5b4fxBXjSoAhDF7zgzsuZkfyweCuTq
         NLmXCQ69wHD1nokjVJXN5OevKuNKTxXR5iT5qgXT+l5XymGS+X0/Gb9X9MPwwwEYCdRo
         +X3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789698148; x=1790302948;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Cvk169Syep4khxZ06F0hThbd1fhib5jsWyzda7Xu2/8=;
        b=AvL2ZXZsBkf1cqd8wEcpST32PJfSyIVGGj1Sj529pwCEaB25N8OMIcVzFcQoNjuj4W
         AghVbv0GruaK6VfCTw7rIXB51Dc5uTKSgjsp7OVbLiI4cV839qLXzeU9B1SZOvQVOu3l
         hby2j1IyoQlTct9hio/7F3MpWU6t95OcBnNMBDB7TnqxoMvUze6ssx2mwaqD7zxhZQyr
         O54aJNP7H5G0DP6p8GE2d55SboZg6ZubSTMTD0q0hE5AirkHLY+j8KIW7lq1gU/U994k
         xW06qMcJi/DLMFkXhVxlsYTXD8QvynQB4JN1gFJLOXJJgcQ7n9CUxy5r0lGQdWDzcZfn
         8e1g==
X-Forwarded-Encrypted: i=1; AKwUvBzUNQE3n58D4FQ1HPpNgflBCmqhrwbW10UCTrgUEida0aGcZsdBEPKSl2m1mgkBND5yuwG/q2eiiw==@kvack.org
X-Gm-Message-State: AFuF++m0rU3qBvO4lHRx/tdevU7c1+t8pJOPrE5zLWt1l/d697LkidlG
	hbtbrAMApsslWpy2Qf/V6X2Ca+Pd90wfl9gooDvzXmO++n9q2B1cmYh8
X-Gm-Gg: AYBFou1LhjDEoAS/ZSbI4FziukR+Dfs2d7Bbl4OAB40fMSoRORRuCJZrTupc4cSrSsY
	dB0UtRqfDlW89Oup13XCiasb5NQXomgUPvlEKaYEt70WTa/bE4xTYhV8ZPreGyKjF9ydn+wESvt
	lchOZ7S8Xg9auygBf5BGMN8YgIbvcS55pp/h/V4Vo7nXiOtaVUPLrPFOB9un6zY34L3HMQ74uvU
	7/b5SVPQOJtP+BRgpCLOMeyD7IBYbYkYn/LUtQ6+jvUzdwLyk7gweWCjHIb9UeGp+fXL3CohWzr
	ZBYSW/8R0Np3tNEu48H/BaN2eu93Cyfh0t4S40mVc8jECxI2XStjiaWrorubNHdg8DCcIuS4km/
	6UNK6D1zD6k6DzT1dmCctrCzwuFaxVt6TMkWWpouScMbNtZSq+eY856mkEW2sT5TyTPqaPXL/e3
	VD5wv4lZJT4Y0/2MgEkMDU6FbM5WKvsRhE8AkP+vwIvHqwfbxGq7L59/NTwc9x94DpXHckPwHzq
	dvGcBzVhIQ84bWZ2+5cAR1i8ebxMdsUgaTvaPNi38nJ+psELNN/wRz86kF2dnRolLr69A==
X-Received: by 2002:a05:6a00:4291:b0:874:706d:8576 with SMTP id d2e1a72fcca58-874de4ff4b3mr1799036b3a.30.1789698148120;
        Thu, 17 Sep 2026 19:22:28 -0700 (PDT)
Received: from localhost.localdomain ([240e:46d:2100:4fc2:8444:7c4b:1e6e:4e9a])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-875dceddd1csm63692b3a.28.2026.09.17.19.22.25
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 17 Sep 2026 19:22:27 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: hannes@cmpxchg.org
Cc: Liam.Howlett@oracle.com,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	ljs@kernel.org,
	riel@surriel.com,
	vbabka@suse.cz,
	ziy@nvidia.com
Subject: Re: [RFC 2/2] mm: page_alloc: per-cpu pageblock buddy allocator
Date: Fri, 18 Sep 2026 10:22:22 +0800
Message-ID: <20260918022222.22955-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260403194526.477775-3-hannes@cmpxchg.org>
References: <20260403194526.477775-3-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: s4rgig55ybiw3jg5dmw8hizmg71dj4zx
X-Rspamd-Queue-Id: ACE6240002
X-HE-Tag: 1789698149-663035
X-HE-Meta: U2FsdGVkX196DiCnk9I103VZ+0blqO+kVCCl+OUAiqaUzJF8bqMIqOMJ70Mz4pnfuvBHpICjqDArBOIg4D3z6wW0uoa7x1TwvorxizqNKZdU4kGxvBUy37zIEGzbvC0mIAJZuVqrGABpO5RFnLpZ4KU2CD8a+cjlxRPQJwnrGrT1ZRmfkI+HllL3TOZjlyeiF2wuO/D4BAMcx6ecc2iD4pHjlPNq3j2h0BLbpp962ci1WszmPc7WjYtd2bAf+mRpiO3HFLZmMGbv7G4H30EgpfgT5vv0v6QHeR4kiuxyg5eYYjpp9SfOSoHVI2TxxjQp9D+vnzuNQG73TrsxT4B0EJc8u13dV8oiopRblKopyIsmeTblFFtjOV7wWbtV21lsUEA38Bcr4qy4J9xFWVzObGZQ1+yuSSGbUTVsRMaApq8rkINhqMqoXfsBlfUfPByU7TQmFKpicRQrvCC+NwFRBrjGwjbK6WE5dgJrTI6W4Ex7rBqIQ+6d5Inky5g3XcK4UYTcW80oZbaUJkIKn7sPRkFi4rlJPHJ0jjk9GoQ9ursKmg7IKeZ2nSwdntkJ+9q339L0clvaRTyAlWMtboxnfxI7lgsbGTRRyLJj2p544HfEGvFLi/y8RjqyH+/66y2an8Um2ibtatOEj6TwFxh4Z9/FL6UxgHadyyR2J7ibsMrRh8TUu9W9QybcZ2t3JmDlj3IuWcVlkIq0bg1s9QWS6rOhOMk/iht5Ztsm3lShDH5/uituUTji1tGsmKPQmMWuCvYjRpQebZwef6a4asAzAV21ngZeYX9l2opk50jl0WYQ5ZpRt1Sf9AkbvhKBbPvgHFw94usR4TMFJJbiqnn7xcraAIKPWq57Kv7BsHow1iWdJKnsQJCx6MYy7cEszKpz1XMqHGSiaH+LpmcxWcIkoo8itLrUfvyE7jduBdYQkBspyG4903ner8OvJUcv4hSRAFB5e/ckrgSBGWWJjI9
 vJmXduYc
 m8MzdPQ9F87j4rqIZBaOw+Ea9rRkc6h8SlVbZfp7QyT5cazkUq0mkomroZB597eHfaE6/M+NlbNx8qMuHeaQpurcXPGslEEXalXhCKYfF67Vw83PD70xj63R/KDA+De+OZyWKBkg/Z6T9pln52+XN0zpO2gGGHfhRyTcVEaEQ0i3/1z5nwshfShbYsyiE1xtB3jhLkHlYbYSU9IkdXhecrjNT/E6s+pGz6+yJHySyiedRV3X45m8CK61PW6wvkW2ttC6qtFeRPb+w6eTVq/tTNQSKAfJu5+C4RqWGFeqgJErvuu5r+Yzwne6gEEB7RfvoVNwI/sK/bh8d9/CU5FfJ29VKbrPf7/Kz5cWcICaodzCmr8VuactcLtYu5zyp8cUtaBxRGY/7tRxsMMx6pB7w9h29Q4P0j09qc81TjUUb3boC4QWpNV6rqwbg8Y4t9YmpGW5t/dICI/ryrKGrEn5yPM5HoB/It/TH4mhjEPjG+iFhmyFhUpGl7SOZScSw7qMF70G1Ic4WTeh3+gZlzAi1dxRXg/TTUFHa3SdX1adR/q1YRhvF+o8fR/TGsJA51/m5Inb4gAy3kh9BsL1C7JguVZFSYmKeC4UbO9/tHNt308pq4W8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  3 Apr 2026 at 15:40 PM Johannes Weiner <hannes@cmpxchg.org> wrote:

[...]

> @@ -2941,15 +3242,45 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
[...]
> +	pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
> +	if (unlikely(fpi_flags & FPI_TRYLOCK) || !in_task()) {
> +		if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
> +			free_one_page(zone, page, pfn, order, fpi_flags);
>  			return;
> -		pcp_spin_unlock(pcp, UP_flags);
> +		}
>  	} else {
> +		spin_lock_irqsave(&pcp->lock, UP_flags);
> +	}

[...]

> @@ -3025,17 +3369,35 @@ void free_unref_folios(struct folio_batch *folios)
[...]
> +			if (!in_task()) {
> +				if (unlikely(!spin_trylock_irqsave(
> +						&pcp->lock, UP_flags))) {
> +					pcp = NULL;
> +					free_one_page(zone, &folio->page, pfn,
> +						      order, FPI_NONE);
> +					continue;
> +				}
> +			} else {
> +				spin_lock_irqsave(&pcp->lock, UP_flags);
> +			}

Hello Johannes,

Thank you for the great work on this series -- I hope it is still being
actively worked on.

We are suffering from heavy zone->lock contention on our production
servers as well, so I backported this series to our internal 6.18.y
kernel. However, since deploying it to a few dozen production servers
running workloads with heavy memory and I/O pressure, we have been
hitting hard lockups at a rate of roughly one every day or two. The
hard lockups look as follows:

[149519.005207] watchdog: CPU22: Watchdog detected hard LOCKUP on cpu 22
[149519.005211] Modules linked in: af_packet_diag netlink_diag squashfs loop zram xt_owner xt_DSCP cls_bpf sch_ingress xt_CT nft_compat bpf_preload mptcp_diag raw_diag unix_diag binfmt_misc udp_diag tcp_diag inet_diag nf_tables xt_conntrack nf_nat nf_conntrack_netlink nfnetlink nf_conntrack nf_defrag_ipv6 nf_defrag_ipv4 af_packet bonding overlay ipmi_ssif amd_atl intel_rapl_msr intel_rapl_common amd64_edac kvm_amd dax_hmem cxl_acpi cxl_port mlx5_ib cxl_pmem kvm acpi_ipmi ib_uverbs irqbypass vfat ipmi_si cxl_core i2c_piix4 ipmi_devintf fat rapl einj acpi_cpufreq ib_core pcspkr i2c_smbus xfs ipmi_msghandler k10temp i2c_designware_platform i2c_designware_core input_leds sch_fq_codel drm fuse backlight ext4 crc16 mbcache jbd2 polyval_clmulni ghash_clmulni_intel mlx5_core mlxfw tls nvme psample ptp nvme_core ccp pps_core sd_mod sg ahci libahci libata aesni_intel
[149519.005260] CPU: 22 UID: 10305 PID: 3050692 Comm: java Kdump: loaded Not tainted 6.18.44-3 #3.infra PREEMPT(voluntary) 
[149519.005263] Hardware name: ZTE R5350 G5/MB53A05A, BIOS 24.25.02.02 04/30/2025
[149519.005264] RIP: 0010:queued_spin_lock_slowpath+0x299/0x2d0
[149519.005270] Code: 83 e0 03 83 e9 01 48 c1 e0 04 48 63 c9 48 05 80 48 61 9f 48 03 04 cd c0 5c 6b 9e 48 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 <85> c0 74 f7 48 8b 0a 48 85 c9 0f 84 6a ff ff ff 0f 0d 09 e9 62 ff
[149519.005271] RSP: 0018:ff7d3f62682ef678 EFLAGS: 00000046
[149519.005272] RAX: 0000000000000000 RBX: ff483cf409daf880 RCX: 00000000000000bc
[149519.005273] RDX: ff483cf409daf880 RSI: 0000000002f40100 RDI: ff483cf40ad75540
[149519.005273] RBP: ff7d3f62682ef698 R08: 0000000000000055 R09: 0000000000000000
[149519.005274] R10: ffb3caab519aee00 R11: 0000000000000001 R12: ff483cf40ad75540
[149519.005274] R13: 00000000005c0000 R14: 00000000005c0000 R15: 000000000000000e
[149519.005275] FS:  0000000000000000(0000) GS:ff483cf46a79b000(0000) knlGS:0000000000000000
[149519.005276] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[149519.005276] CR2: 00007fd14532b000 CR3: 000000061d798798 CR4: 0000000000771ef0
[149519.005277] PKRU: 55555554
[149519.005277] Call Trace:
[149519.005278]  <TASK>
[149519.005282]  _raw_spin_lock_irqsave+0x51/0x60
[149519.005284]  free_unref_folios+0x60c/0xaa0
[149519.005289]  folios_put_refs+0x182/0x210
[149519.005292]  free_pages_and_swap_cache+0xc7/0x170
[149519.005294]  ? __entry_text_start+0xf/0x30
[149519.005297]  __tlb_batch_free_encoded_pages+0x47/0xb0
[149519.005300]  tlb_flush_mmu+0x4f/0x140
[149519.005301]  zap_pte_range+0x300/0x490
[149519.005303]  zap_pmd_range.isra.0+0xc4/0x220
[149519.005305]  unmap_page_range+0x270/0x3d0
[149519.005306]  unmap_single_vma.constprop.0+0x7d/0xc0
[149519.005309]  unmap_vmas+0x92/0x160
[149519.005311]  exit_mmap+0xf2/0x400
[149519.005313]  ? mutex_lock+0x13/0x50
[149519.005315]  __mmput+0x52/0x120
[149519.005318]  mmput+0x30/0x40
[149519.005320]  exit_mm+0xe7/0x150
[149519.005321]  do_exit+0x1c7/0x490
[149519.005322]  do_group_exit+0x34/0x90
[149519.005324]  get_signal+0x919/0x960
[149519.005326]  arch_do_signal_or_restart+0x29/0x100
[149519.005327]  ? __x64_sys_futex+0x77/0x1e0
[149519.005330]  exit_to_user_mode_loop+0xa0/0x120
[149519.005333]  do_syscall_64+0x1ea/0xe10
[149519.005335]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[149519.005336] RIP: 0033:0x7f9ed929c39a
[149519.005342] Code: Unable to access opcode bytes at 0x7f9ed929c370.
[149519.005343] RSP: 002b:00007f9e8d2fe300 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[149519.005343] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007f9ed929c39a
[149519.005344] RDX: 0000000000000000 RSI: 0000000000000189 RDI: 00007f9ed6074b3c
[149519.005344] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000ffffffff
[149519.005345] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[149519.005345] R13: 00007f9ed6074b3c R14: 0000000000000001 R15: 0000000000000000
[149519.005347]  </TASK>
[149519.005348] Kernel panic - not syncing: Hard LOCKUP
[149519.005349] CPU: 22 UID: 10305 PID: 3050692 Comm: java Kdump: loaded Not tainted 6.18.44-3 #3.infra PREEMPT(voluntary) 
[149519.005350] Hardware name: ZTE R5350 G5/MB53A05A, BIOS 24.25.02.02 04/30/2025
[149519.005350] Call Trace:
[149519.005351]  <NMI>
[149519.005351]  dump_stack_lvl+0x26/0xb0
[149519.005353]  dump_stack+0x10/0x20
[149519.005354]  vpanic+0x34d/0x3a0
[149519.005355]  panic+0x57/0x60
[149519.005357]  nmi_panic+0x2b/0x60
[149519.005358]  watchdog_hardlockup_check+0x1b4/0x200
[149519.005360]  watchdog_overflow_callback+0x7c/0x90
[149519.005362]  __perf_event_overflow+0x11c/0x3b0
[149519.005365]  perf_event_overflow+0x19/0x20
[149519.005366]  amd_pmu_v2_handle_irq+0x1f5/0x3e0
[149519.005369]  ? flush_tlb_one_kernel+0xe/0x30
[149519.005371]  ? set_pte_vaddr_p4d+0x4f/0x60
[149519.005373]  ? set_pte_vaddr+0x7b/0xb0
[149519.005373]  ? native_set_fixmap+0x59/0x90
[149519.005375]  ? ghes_copy_tofrom_phys+0x75/0x120
[149519.005378]  ? __ghes_peek_estatus.isra.0+0x4e/0xc0
[149519.005380]  ? ghes_in_nmi_queue_one_entry.constprop.0+0x3c/0x2a0
[149519.005382]  perf_event_nmi_handler+0x2d/0x50
[149519.005384]  nmi_handle.part.0+0x5a/0x160
[149519.005386]  default_do_nmi+0x11c/0x160
[149519.005387]  exc_nmi+0x10b/0x1a0
[149519.005388]  end_repeat_nmi+0xf/0x53
[149519.005389] RIP: 0010:queued_spin_lock_slowpath+0x299/0x2d0
[149519.005391] Code: 83 e0 03 83 e9 01 48 c1 e0 04 48 63 c9 48 05 80 48 61 9f 48 03 04 cd c0 5c 6b 9e 48 89 10 8b 42 08 85 c0 75 09 f3 90 8b 42 08 <85> c0 74 f7 48 8b 0a 48 85 c9 0f 84 6a ff ff ff 0f 0d 09 e9 62 ff
[149519.005391] RSP: 0018:ff7d3f62682ef678 EFLAGS: 00000046
[149519.005392] RAX: 0000000000000000 RBX: ff483cf409daf880 RCX: 00000000000000bc
[149519.005392] RDX: ff483cf409daf880 RSI: 0000000002f40100 RDI: ff483cf40ad75540
[149519.005393] RBP: ff7d3f62682ef698 R08: 0000000000000055 R09: 0000000000000000
[149519.005393] R10: ffb3caab519aee00 R11: 0000000000000001 R12: ff483cf40ad75540
[149519.005394] R13: 00000000005c0000 R14: 00000000005c0000 R15: 000000000000000e
[149519.005395]  ? queued_spin_lock_slowpath+0x299/0x2d0
[149519.005396]  ? queued_spin_lock_slowpath+0x299/0x2d0
[149519.005398]  </NMI>
[149519.005398]  <TASK>
[149519.005398]  _raw_spin_lock_irqsave+0x51/0x60
[149519.005400]  free_unref_folios+0x60c/0xaa0
[149519.005402]  folios_put_refs+0x182/0x210
[149519.005404]  free_pages_and_swap_cache+0xc7/0x170
[149519.005405]  ? __entry_text_start+0xf/0x30
[149519.005407]  __tlb_batch_free_encoded_pages+0x47/0xb0
[149519.005409]  tlb_flush_mmu+0x4f/0x140
[149519.005410]  zap_pte_range+0x300/0x490
[149519.005412]  zap_pmd_range.isra.0+0xc4/0x220
[149519.005413]  unmap_page_range+0x270/0x3d0
[149519.005414]  unmap_single_vma.constprop.0+0x7d/0xc0
[149519.005415]  unmap_vmas+0x92/0x160
[149519.005417]  exit_mmap+0xf2/0x400
[149519.005419]  ? mutex_lock+0x13/0x50
[149519.005421]  __mmput+0x52/0x120
[149519.005422]  mmput+0x30/0x40
[149519.005424]  exit_mm+0xe7/0x150
[149519.005425]  do_exit+0x1c7/0x490
[149519.005426]  do_group_exit+0x34/0x90
[149519.005427]  get_signal+0x919/0x960
[149519.005428]  arch_do_signal_or_restart+0x29/0x100
[149519.005429]  ? __x64_sys_futex+0x77/0x1e0
[149519.005430]  exit_to_user_mode_loop+0xa0/0x120
[149519.005432]  do_syscall_64+0x1ea/0xe10
[149519.005433]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[149519.005434] RIP: 0033:0x7f9ed929c39a
[149519.005435] Code: Unable to access opcode bytes at 0x7f9ed929c370.
[149519.005435] RSP: 002b:00007f9e8d2fe300 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
[149519.005436] RAX: fffffffffffffe00 RBX: 0000000000000000 RCX: 00007f9ed929c39a
[149519.005436] RDX: 0000000000000000 RSI: 0000000000000189 RDI: 00007f9ed6074b3c
[149519.005436] RBP: 0000000000000000 R08: 0000000000000000 R09: 00000000ffffffff
[149519.005437] R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
[149519.005437] R13: 00007f9ed6074b3c R14: 0000000000000001 R15: 0000000000000000
[149519.005438]  </TASK>

This hard lockup can be fixed by the following changes on top of your
series:

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9b52478c911a..74d80dcff6c4 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3266,13 +3266,9 @@ static void __free_frozen_pages(struct page *page, unsigned int order,
                cache_cpu = raw_smp_processor_id();

        pcp = per_cpu_ptr(zone->per_cpu_pageset, cache_cpu);
-       if (unlikely(fpi_flags & FPI_TRYLOCK) || !in_task()) {
-               if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
-                       free_one_page(zone, page, pfn, order, fpi_flags);
-                       return;
-               }
-       } else {
-               spin_lock_irqsave(&pcp->lock, UP_flags);
+       if (!spin_trylock_irqsave(&pcp->lock, UP_flags)) {
+               free_one_page(zone, page, pfn, order, fpi_flags);
+               return;
        }

        if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
@@ -3378,16 +3374,12 @@ void free_unref_folios(struct folio_batch *folios)
                         * contention on a per-CPU lock beats the
                         * unbatched zone->lock fallback.
                         */
-                       if (!in_task()) {
-                               if (unlikely(!spin_trylock_irqsave(
-                                               &pcp->lock, UP_flags))) {
-                                       pcp = NULL;
-                                       free_one_page(zone, &folio->page, pfn,
-                                                       order, FPI_NONE);
-                                       continue;
-                               }
-                       } else {
-                               spin_lock_irqsave(&pcp->lock, UP_flags);
+                       if (unlikely(!spin_trylock_irqsave(
+                                       &pcp->lock, UP_flags))) {
+                               pcp = NULL;
+                               free_one_page(zone, &folio->page, pfn,
+                                               order, FPI_NONE);
+                               continue;
                        }
                        if (unlikely(pcp->flags & PCPF_CPU_DEAD)) {
                                spin_unlock_irqrestore(&pcp->lock, UP_flags);

With these changes applied, the affected servers have been running
lockup-free for more than two weeks so far.

If you have any updates on this series, we would be happy to
test them on our production servers and report back.


Thanks

