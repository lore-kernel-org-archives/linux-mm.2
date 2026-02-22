Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81685C636BE
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 21:37:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 580446B0088; Sun, 22 Feb 2026 16:37:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 52D9E6B0089; Sun, 22 Feb 2026 16:37:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402696B008A; Sun, 22 Feb 2026 16:37:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 290B16B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 16:37:04 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C2285BABF7
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 21:37:03 +0000 (UTC)
X-FDA: 84473403126.20.602242B
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id 05731A000A
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 21:37:01 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mhBXakJj;
	spf=pass (imf15.hostedemail.com: domain of chris.bainbridge@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=chris.bainbridge@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771796222;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=YYcB3zGjT8GKDiCMJj3SvE8SHtPoZo7cQxEGocwC61o=;
	b=NxSAoRhBEa/g5JycOjgTI1xf4x96JDP0wAzReIqwbhjWHx+XhrdBE6dnvJuOlaTmf+PkZo
	tn1Dqe+KeF3vD5O+h0c/dRagZeiWA1XqS78wmJH5J0ApepMf5CcNE6A2PfSgIrHYnS/7l3
	UoDVw21nXks+/JvrBxv89rtnKlwnrLY=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=mhBXakJj;
	spf=pass (imf15.hostedemail.com: domain of chris.bainbridge@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=chris.bainbridge@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771796222; a=rsa-sha256;
	cv=none;
	b=ha7KSmJPo09ec7e8M9cQYWN4x8LxH/jbrvpPn4Hfw6dVQ6UuUTM8nvsrMRBEXrHENXBOiY
	TFbCeZlWajXRp8Ja5Wn19pLw5B4P25D9YZptWRyPKuKdcK+0JiRPijSOSteJtiiU3NRwmz
	UoAY/WksMXfmdmDshGiJr9fLtTzcpyw=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4806cc07ce7so33878245e9.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 13:37:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771796220; x=1772401020; darn=kvack.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YYcB3zGjT8GKDiCMJj3SvE8SHtPoZo7cQxEGocwC61o=;
        b=mhBXakJj3CeKM3ukV+xa+2hIFQOmjoa/71xjh4nAbGgZzGC8eQkBewWOY9RJhaDrkX
         bcWbSK7qclQuI8jvMon1p6NWtbt5UzAmbB24n5lek1oMMMBYCVlzltcoCaJFdLQa092j
         SLJ6H6L6bnhBZGyR3PJhJ8nBoxG6eiytf2e6qEowU4jl8Cbl+vAmOPKx9+XTL9gNKIR0
         7T6Pro3+1OBA6EpYqxHef/GpIQZFepsLLNVjTMJWrB+zK5dk/aTEagPGxiG43Vp45vOO
         /llRQdXuSSu4W5wSNxnuqGFkwUp8PdvSMsy9uWx2V4lPcmWFyd/5xyvMQf6vKkqVC56p
         2b6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771796220; x=1772401020;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YYcB3zGjT8GKDiCMJj3SvE8SHtPoZo7cQxEGocwC61o=;
        b=MXERVbvbwAKuDaXwW8umHGLegqXqNpAv2WS7kkM+cBS+KOaC3tEzfwCuB7X0t0UNNe
         iO69unHWPJBcwNLOIYIFjscEfC+r6UwRzMICSjNcrD3lZa9N46SkrCVBIk/wB1GyYOTl
         kcxlr1MFuuy9eJW1Txq4Bd01W1OQLCuj8numd70JKkIYQQNnBwyKT7N7xXBxf+4oqAmn
         6Xx7IoNkUXvBJBH8hyr1no7mT0OSgOnpFn2+AQKXWMwSI4Lk+4AmrgPbkhKZjum7+kG4
         QvOKODy7e9VSPe2gfCeaI2zrjKu8WeObE5FmRp4Yu31I1ZeeYLbjaWLRFqPxljM2IMdQ
         64WQ==
X-Forwarded-Encrypted: i=1; AJvYcCUg10EZoijq2eeEn8rwcYETv2pnE9BeBkSzwRHTEB9+szSeLYFwsjtg43YScZKz+xmPsHQ1POlV8A==@kvack.org
X-Gm-Message-State: AOJu0Yxr0CrkDe5VWJRgK64N2mARV266HT+iQbHmrMxZWD7+bbE4cbF9
	qaxeQ1su/aviM6YOUWSEJ50rQEvb+kMDcJ76tZnCCEn3H5rdumXoLr8R
X-Gm-Gg: AZuq6aKy448A10o7fviw09MmHjkvZ/2KDobhSyeyv8/vwu1q+KtP85TBRGp3UjmhSeC
	qkgioI6pfQsfqtpq57pJJLAiLpw2oTEDDaaaVG7MaOT2bFUvR7ZooFys0pGAwJGRp9dXdUVUC8U
	xZG+81wTpVwjFBNHt7lfq9n/gX7OEJy+DRlGZkjBF7lKhVemkLiCwtRhRV7Zc20VjQlSkR5VCkb
	N/kXpoWAYoqKfNF/qS29sE1TJc2is8U1wEOXobnWNUIspwx8KXqh8cRG6EdhDSj+ssQGkTd68R6
	QOerW0Y1wJFn+UXoS5e/boY9Uz+ysFVpmK/cajV3ypvfE27nu998LiOm6Nijk6AJxJZTFKD8WTq
	FSPsUbWC38HbHgxEWgkS+awdqlebPS563UdlIueUJrhj4POuHkFZ/puoHObqnQ96nvU9qDZNg5t
	5UPbgFNSee0/rcmQas9pVtfQB2xDokQlYLY+Yr228UUA==
X-Received: by 2002:a05:600c:4e02:b0:482:ef72:5781 with SMTP id 5b1f17b1804b1-483a95f5843mr112802835e9.25.1771796220150;
        Sun, 22 Feb 2026 13:37:00 -0800 (PST)
Received: from debian.local ([90.243.35.46])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a316eb08sm246605715e9.0.2026.02.22.13.36.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 13:36:59 -0800 (PST)
Date: Sun, 22 Feb 2026 21:36:58 +0000
From: Chris Bainbridge <chris.bainbridge@gmail.com>
To: vbabka@suse.cz
Cc: surenb@google.com, harry.yoo@oracle.com, hao.li@linux.dev,
	leitao@debian.org, Liam.Howlett@oracle.com, zhao1.liu@intel.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-btrfs@vger.kernel.org, regressions@lists.linux.dev
Subject: [REGRESSION] kswapd0: page allocation failure (bisected to "slab:
 add sheaves to most caches")
Message-ID: <aZt2-oS9lkmwT7Ch@debian.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Stat-Signature: 4ixp7ozenhkebgbdbou9bczn1aycx65k
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 05731A000A
X-HE-Tag: 1771796221-26354
X-HE-Meta: U2FsdGVkX1+6Pw/3ZIIirtpmbdBW/WXZQnTmxGhH3Y9/gKry3ujVPeltq88/3nJOujP8F/JzqFs6L3zGapzH/jQ4oYhL69yyoeenYjFcpKZNwPkF7HuRraP2bsd0T+qrArFMMLc21mXLCVco2dfjZicyrUsMaGGCpfNxRDVmKnyf4dC43jN6/BELvNLA4pH5dLTJLH6liTtXdvzEXh2HZynfzXrTMgoRlRiqN2tu1IHwc4GT2c20+z8a0p0x9AWiDZEH9C81nd3EW/M1YCFcFgEezoXuo0SIqCxppsgZVT1uO+3eox0YxygCKpSx14NKOWM653ZtMZde0dLkhukrsFWfUZogrxJWvNuiBpI4uQ0GetfBkM5qgW436adnSSZU61JaP+bx8hw1tuuQxto5YiLB8iPizCocJuvxEwz7+aXyvwqDCkntZ9EjA5p1p1g09Yv96IRnz/BdBe4bJGYTnVP0SKqSur51AqPx46haF5+UtfeX7XoJGKJjKz92lS/XQaE9oxOI2ZMRHNH7TTjLeU32+djSzjxMaf0PZEELfAWbwIuCkhdmfxxx0X4GdO6L1U2kjtXZ/NfFD+35nLcsEPdJW6mvex3Me6walNF7Brqxkv7bj2+N0aWciuO4KKbEPONft9QPHnboSCKJDvDyDaJrU8ocnZf6ZSPVq/AIOVgGft1rO2bc66ZwjSFypfuZTPp2TB0aK5FISs2xI6hKyYyNmB0n9x4sPy3fj17dcS5xffCrOby0XXiTVB8QXat5lTma16BUK9guZSfMyDvqqygvg7k1VnVMaLQG3biF+JVxoJlpraTJNNXJL4ln9LsZqG/jsCTcYA/pTEVJD+vECVeCEH8w+kY2q95bhLMfYbfpmMXz1sFCPFdc0/DRBeZq2CcOJtkmwQJgO9gx2evzOd08YTD0EuPgTSINlH0Vt7iMvFLW/KgMgs7E+U0RgBPq0Yijsz3bMtD6iSZU2JF
 Vjy3g4Qx
 2y+mwYqn2VLg+9OTcjPVyd59HlIzg0P63wiWneS57SvfJ2Pl2+s9AuIC0rjJiQ4ibyN2N6A4P/u/jVzu07W4f6Y8PGCyekxKIYq71hhHJGwcMOr8yHfF7KzSxeUW/inIsjKDTTrVnGUCxjENBsjCZQkW0nudN/bFrB7Gux5h2HvSri6kjxvwb3dHTo6s6FI8r3pYMzZFOAgMZlgJ8KPSgR1gl7VaRKj3fhvxuKMWJM8rUpI0flPAXTuwFpkIEu90y/P/7J/VScEzysYYDmJl7nHGO/OdbRRGQSfuEgJVDQbUkkPYaXje7Zabr0KszEpC6zYyvnpfw2JqqDU3h5vP4/I+IJrL+zcNHcvCdFd36IJiUn+mjLjg8mo9Uv7jv1BsSce2NInr40RDlLTQfdRtGV+D2QsZ1k0o1JDowWVr6slsb+xk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

The latest mainline kernel (v6.19-11831-ga95f71ad3e2e) has page
allocation failures when doing things like compiling a kernel. I can
also reproduce this with a stress test like
`stress-ng --vm 2 --vm-bytes 110% --verify -v`


[  104.032925] kswapd0: page allocation failure: order:0, mode:0xc0c40(GFP_NOFS|__GFP_COMP|__GFP_NOMEMALLOC), nodemask=(null),cpuset=/,mems_allowed=0
[  104.033307] CPU: 4 UID: 0 PID: 156 Comm: kswapd0 Not tainted 6.19.0-rc5-00027-g40fd0acc45d0 #435 PREEMPT(voluntary) 
[  104.033312] Hardware name: HP HP Pavilion Aero Laptop 13-be0xxx/8916, BIOS F.17 12/18/2024
[  104.033314] Call Trace:
[  104.033316]  <TASK>
[  104.033319]  dump_stack_lvl+0x6a/0x90
[  104.033328]  warn_alloc.cold+0x95/0x1af
[  104.033334]  ? zone_watermark_ok+0x80/0x80
[  104.033350]  __alloc_frozen_pages_noprof+0xec3/0x2470
[  104.033353]  ? __lock_acquire+0x489/0x2600
[  104.033359]  ? stack_access_ok+0x1c0/0x1c0
[  104.033367]  ? warn_alloc+0x1d0/0x1d0
[  104.033371]  ? __lock_acquire+0x489/0x2600
[  104.033375]  ? _raw_spin_unlock_irqrestore+0x48/0x60
[  104.033379]  ? _raw_spin_unlock_irqrestore+0x48/0x60
[  104.033382]  ? lockdep_hardirqs_on+0x78/0x100
[  104.033394]  allocate_slab+0x2b7/0x510
[  104.033399]  refill_objects+0x25d/0x380
[  104.033407]  __pcs_replace_empty_main+0x193/0x5f0
[  104.033412]  kmem_cache_alloc_noprof+0x5b6/0x6f0
[  104.033415]  ? alloc_extent_state+0x1b/0x210 [btrfs]
[  104.033479]  alloc_extent_state+0x1b/0x210 [btrfs]
[  104.033527]  btrfs_clear_extent_bit_changeset+0x2be/0x9c0 [btrfs]
[  104.033575]  btrfs_clear_record_extent_bits+0x10/0x20 [btrfs]
[  104.033615]  btrfs_qgroup_check_reserved_leak+0xbd/0x2b0 [btrfs]
[  104.033659]  ? lock_release+0x17b/0x2a0
[  104.033663]  ? btrfs_qgroup_convert_reserved_meta+0xe90/0xe90 [btrfs]
[  104.033703]  ? do_raw_spin_unlock+0x54/0x1e0
[  104.033707]  ? _raw_spin_unlock+0x29/0x40
[  104.033710]  ? btrfs_lookup_first_ordered_extent+0x1d4/0x370 [btrfs]
[  104.033762]  ? preempt_count_add+0x73/0x140
[  104.033768]  btrfs_destroy_inode+0x301/0x6a0 [btrfs]
[  104.033820]  ? __destroy_inode+0x194/0x570
[  104.033826]  destroy_inode+0xb9/0x190
[  104.033830]  evict+0x4d8/0x900
[  104.033832]  ? lock_release+0x17b/0x2a0
[  104.033835]  ? find_held_lock+0x2b/0x80
[  104.033839]  ? destroy_inode+0x190/0x190
[  104.033842]  ? __list_lru_walk_one+0x30d/0x440
[  104.033849]  ? _raw_spin_unlock+0x29/0x40
[  104.033851]  ? __list_lru_walk_one+0x30d/0x440
[  104.033854]  ? __wait_on_freeing_inode+0x2a0/0x2a0
[  104.033860]  dispose_list+0xf0/0x1b0
[  104.033866]  prune_icache_sb+0xde/0x150
[  104.033869]  ? list_lru_count_one+0x13f/0x270
[  104.033873]  ? dump_mapping+0x250/0x250
[  104.033875]  ? lock_release+0x17b/0x2a0
[  104.033882]  super_cache_scan+0x302/0x4d0
[  104.033889]  do_shrink_slab+0x32e/0xd30
[  104.033898]  shrink_slab+0x7b6/0xda0
[  104.033902]  ? shrink_slab+0x4b1/0xda0
[  104.033908]  ? reparent_shrinker_deferred+0x330/0x330
[  104.033914]  ? trace_event_raw_event_sched_switch+0x410/0x410
[  104.033921]  shrink_node+0xac4/0x36e0
[  104.033933]  ? lru_gen_release_memcg+0x3c0/0x3c0
[  104.033940]  ? pgdat_balanced+0x15f/0x4b0
[  104.033943]  ? __cond_resched+0x23/0x30
[  104.033950]  ? balance_pgdat+0x739/0x1530
[  104.033952]  balance_pgdat+0x739/0x1530
[  104.033960]  ? shrink_node+0x36e0/0x36e0
[  104.033962]  ? __timer_delete_sync+0x177/0x240
[  104.033966]  ? __timer_delete_sync+0x177/0x240
[  104.033970]  ? _raw_spin_unlock_irqrestore+0x48/0x60
[  104.033975]  ? __lock_acquire+0x489/0x2600
[  104.033979]  ? call_timer_fn+0x3b0/0x3b0
[  104.033981]  ? schedule+0x2ba/0x390
[  104.033990]  ? lock_is_held_type+0xd5/0x130
[  104.033997]  ? kswapd+0x364/0x7f0
[  104.034004]  kswapd+0x445/0x7f0
[  104.034010]  ? balance_pgdat+0x1530/0x1530
[  104.034013]  ? _raw_spin_unlock_irqrestore+0x48/0x60
[  104.034016]  ? finish_wait+0x280/0x280
[  104.034022]  ? __kthread_parkme+0xb4/0x200
[  104.034027]  ? balance_pgdat+0x1530/0x1530
[  104.034029]  kthread+0x3ad/0x760
[  104.034033]  ? kthread_is_per_cpu+0xb0/0xb0
[  104.034035]  ? ret_from_fork+0x70/0x850
[  104.034039]  ? ret_from_fork+0x70/0x850
[  104.034042]  ? _raw_spin_unlock_irq+0x24/0x50
[  104.034045]  ? kthread_is_per_cpu+0xb0/0xb0
[  104.034049]  ret_from_fork+0x6dc/0x850
[  104.034053]  ? exit_thread+0x70/0x70
[  104.034057]  ? __switch_to+0x36f/0xd80
[  104.034061]  ? kthread_is_per_cpu+0xb0/0xb0
[  104.034065]  ret_from_fork_asm+0x11/0x20
[  104.034077]  </TASK>
[  104.034078] Mem-Info:
[  104.034111] active_anon:511 inactive_anon:2355672 isolated_anon:0
                active_file:77595 inactive_file:204731 isolated_file:0
                unevictable:7150 dirty:925 writeback:57
                slab_reclaimable:20227 slab_unreclaimable:201840
                mapped:121227 shmem:10197 pagetables:9634
                sec_pagetables:733 bounce:0
                kernel_misc_reclaimable:0
                free:36223 free_pcp:529 free_cma:0
[  104.034119] Node 0 active_anon:2044kB inactive_anon:9422688kB active_file:310380kB inactive_file:818924kB unevictable:28600kB isolated(anon):0kB isolated(file):0kB mapped:484908kB dirty:3700kB writeback:228kB shmem:40788kB shmem_thp:0kB shmem_pmdmapped:0kB anon_thp:8534016kB kernel_stack:31616kB pagetables:38536kB sec_pagetables:2932kB all_unreclaimable? no Balloon:0kB
[  104.034126] Node 0 DMA free:13316kB boost:0kB min:84kB low:104kB high:124kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:0kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:0kB present:15996kB managed:15364kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  104.034135] lowmem_reserve[]: 0 2862 11990 11990 11990
[  104.034147] Node 0 DMA32 free:52184kB boost:0kB min:15860kB low:19824kB high:23788kB reserved_highatomic:0KB free_highatomic:0KB active_anon:0kB inactive_anon:2871780kB active_file:0kB inactive_file:0kB unevictable:0kB writepending:0kB zspages:0kB present:2997084kB managed:2931416kB mlocked:0kB bounce:0kB free_pcp:0kB local_pcp:0kB free_cma:0kB
[  104.034155] lowmem_reserve[]: 0 0 9127 9127 9127
[  104.034166] Node 0 Normal free:79392kB boost:28672kB min:80308kB low:93216kB high:106124kB reserved_highatomic:2048KB free_highatomic:32KB active_anon:2044kB inactive_anon:6550896kB active_file:310380kB inactive_file:818924kB unevictable:28600kB writepending:4252kB zspages:0kB present:13077504kB managed:9346788kB mlocked:28600kB bounce:0kB free_pcp:2116kB local_pcp:0kB free_cma:0kB
[  104.034174] lowmem_reserve[]: 0 0 0 0 0
[  104.034185] Node 0 DMA: 1*4kB (U) 0*8kB 0*16kB 0*32kB 0*64kB 0*128kB 0*256kB 0*512kB 1*1024kB (U) 2*2048kB (UM) 2*4096kB (M) = 13316kB
[  104.034308] Node 0 DMA32: 3*4kB (U) 5*8kB (UM) 5*16kB (UM) 8*32kB (UM) 11*64kB (UM) 15*128kB (UM) 11*256kB (UM) 9*512kB (UM) 9*1024kB (UM) 0*2048kB 8*4096kB (UM) = 52420kB
[  104.034348] Node 0 Normal: 1024*4kB (UMEH) 534*8kB (UEH) 409*16kB (UME) 1301*32kB (UME) 154*64kB (UME) 39*128kB (UME) 14*256kB (UM) 1*512kB (U) 2*1024kB (UM) 1*2048kB (U) 0*4096kB = 79584kB
[  104.034390] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=1048576kB
[  104.034393] Node 0 hugepages_total=0 hugepages_free=0 hugepages_surp=0 hugepages_size=2048kB
[  104.034396] 299766 total pagecache pages
[  104.034398] 0 pages in swap cache
[  104.034401] Free swap  = 8387580kB
[  104.034403] Total swap = 8387580kB
[  104.034405] 4022646 pages RAM
[  104.034407] 0 pages HighMem/MovableOnly
[  104.034410] 949254 pages reserved
[  104.034412] 0 pages hwpoisoned


The page allocation failures bisect to:

e47c897a29491ade20b27612fdd3107c39a07357 slab: add sheaves to most caches

#regzbot introduced: e47c897a29491ade20b27612fdd3107c39a07357
#regzbot title: kswapd0: page allocation failure

