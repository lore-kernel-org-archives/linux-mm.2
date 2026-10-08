Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 77290CA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 07:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 691266B008A; Thu,  8 Oct 2026 03:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63AFC6B008C; Thu,  8 Oct 2026 03:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 529996B0092; Thu,  8 Oct 2026 03:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37DE76B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 03:30:39 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 99D148047B
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:38 +0000 (UTC)
X-FDA: 85298636556.08.9240BFE
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf14.hostedemail.com (Postfix) with ESMTP id 64491100009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 07:30:34 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="D8kc+ni/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791444636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=8u18xg6N9qLEr1Kj9955ylpG90sgpgszfVpX4EGLse4=;
	b=kudPVrNWflF+fM7sM6+/nHGcoxSdjbqRQl5UNgZRM2blb/Jqz2+BRAd7upaiLIHOcFmnqv
	E/TjgsIxvvs7w9wLxwqiU6IBa5/CTGUhBGCMQr5psIIFE16f5gY/8+TXoqgZkv5rG9iJnk
	gBsDKPuHEXH7bH3vRY7+f2pFOvPx0X4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b="D8kc+ni/";
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf14.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791444636;
	b=XU9/A51TSXGqK40verQ5kCRRvb01an4dIDakEAQAC1TQ+x8yiJkMctuMpyST+AWvDtlTNT
	gnEDMpOVQJVIWDor8ihecswKbCZ+1bgy5brxXoRXRzbRwkUUbhq8wW2T9J+8cjxVVyY9xo
	TzRhkRz0tzGJIq3BjpNtpqLzucBFNqY=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3964dfb5b9aso2722685a91.1
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 00:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1791444633; x=1792049433; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8u18xg6N9qLEr1Kj9955ylpG90sgpgszfVpX4EGLse4=;
        b=D8kc+ni/2y99gLSZBRUobCPM5HFvZjfdXffD6Jw7PBP8Ui/nwv0404JeyuBxOJg2CF
         q/EwgvSc0ICFbQh6qb80zxlfzPZUXL/T/0gcji12BD7ZaN4Ab6tklfHIH1oak/plY2Gk
         pa2AdNVIgrbMRRsNA7mZLS/s0Fd3DFwWjb7t7PuS77KMvz5EQHqhZWeQus3smm9ZNK1P
         aV2EYvY8CkqUr+mdr0voHbEFtclxVFdECO7OJa3Nbs6s/Gc/JXGbEXy/cdcomhvjnaUJ
         hWjf4NvbyiE/BN4/dPoRC4Rw4CgdP2ZblwUT0wupaAdUdql4dc2xyaM/AT+lr8h0vwcy
         N/zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791444633; x=1792049433;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8u18xg6N9qLEr1Kj9955ylpG90sgpgszfVpX4EGLse4=;
        b=A57Ngt1qErTbCl68Gf/wa0M7cekuan+/LN7qxlwE+BH+mENNeluXDVAD34mGvn+pBc
         T0xSfzSpewcxSWZpleYV5L3Gy9wYbdf3uY9my6mXU/PNlLDnkrhHipdzrlv94/qU8s/r
         Mn4iu9zgaQXBYC0Dji3OfbfdOx7eifbvspW5cFAFsQyaVnJJdcFBS0SToY0Q8sNK5cPt
         tv7J1/SbwuZpby+wxXs0FbxsASW0fAXh9jjUwcF0BKk8M5sHc4Kf8P92EGxt/7WIB9bI
         anxEMdSF9axC/LX+4kCVGVNXm7j4QjvhR7kJYjL+hQFaeJcFKEA6WdxOQLkuA3dxceDC
         k4+w==
X-Gm-Message-State: AFq9FYI5Z1ujtkLOID7s0NmFXLz5v/ETGo7HkhscPfLdQdRWrRBlwDvO
	O3d2M2jIKy+vDv7hAyqT6Tpj0sbKBbJASdxkucuumxUBL/uwIPtyV+I3oWiYlgLSfpc=
X-Gm-Gg: AYBFou3B5rGl+EEAvBQhz0PLXj5yV2wX8SNW5ABT9XABeIHc9rLAdQMw0Z7b/Lkz8xy
	mglPLQZwtsIU3Ux4eTlD52Z2+eVUaY5svd4ecUDZtVoTr+Q3tOHPc4ZapQQfAH40u4sGsq2LF4C
	NGKUy5Hy80ElgBBuXLASuwFTD/zghhkHz0Fs+8uYsbMhNiTQ5xV7+g1cvdOYyD7LViNIsTDV7qY
	EliWlnyqm2if1/oDL/Y4wT1WXgCWUVYjTQjjBGvwYD/n6tCgM4HMeeDn11bjiB8WAE691WzoqyI
	q3dfSMTIINFD+BLZNZTJo0mKvfoQwXNn6KsA92NqqvViPp7trLuvklxMOw3fpJrjOlWfOEVmjYW
	ls50rDGe1N/0Pk2R6Uvz2WYHJk4R/4bo9f2Q2dnSqVZvQoVWxXyHK72YqD2DhxOXVqacQKE3oUr
	S8gehB/Hv5sIw3tNyN81TOLYzXZvzBT5rXmkCjYWY4gtuz3ZpVNHnH33Ru8xHnt/ppWHQbtAFlf
	R3iU6tZTghUWrtOkLc=
X-Received: by 2002:a17:90b:3ec9:b0:3a0:9aa4:f9bf with SMTP id 98e67ed59e1d1-3a8a072a971mr4136690a91.12.1791444632841;
        Thu, 08 Oct 2026 00:30:32 -0700 (PDT)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a8a438f25dsm3114715a91.2.2026.10.08.00.30.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 00:30:32 -0700 (PDT)
From: Muchun Song <songmuchun@bytedance.com>
To: akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	stable@vger.kernel.org,
	david@kernel.org,
	osalvador@suse.de,
	dave.hansen@linux.intel.com,
	luto@kernel.org,
	peterz@infradead.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	x86@kernel.org,
	hpa@zytor.com,
	catalin.marinas@arm.com,
	will@kernel.org,
	mark.rutland@arm.com,
	linux-arm-kernel@lists.infradead.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	linux-riscv@lists.infradead.org,
	agordeev@linux.ibm.com,
	kevin.brodsky@arm.com,
	bjorn@rivosinc.com,
	apopple@nvidia.com,
	linux-kernel@vger.kernel.org,
	muchun.song@linux.dev
Subject: [PATCH 0/4] mm: Fix page-table teardown during memory hot-remove
Date: Thu,  8 Oct 2026 15:30:17 +0800
Message-ID: <20261008073021.2512665-1-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64491100009
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: ae8hqws4t6zykerz668dmwfzrnnsub5k
X-HE-Tag: 1791444634-986611
X-HE-Meta: U2FsdGVkX1/G2QX/3Jh68yn4as8BVT2VKB5yp2j199IH8SGYBMIn+f1nZWwKhi49c1EFJqCqoO8awn44++Wg6EbBZrYKsd+nAfhlB6eNswx3B2RB1PEAD9lojEIGttf3yHd5sRpgdDG3lPfT6ZCqPJUJAkJGvedsIAUwS52FeV1lgkzi5hKbhwlx725ujaIjFVqcfuyPXWwtnSMGlSGned4rtq+m0R30IO1LXTmSvpM8qtJAxNErykK7gOcQHi/tXHXzxe6QCafoXVkc6ZnVY1LKScpfyh5zJh1FLiNUUNHUQQpV0dFJir5RhwaWut88zzzVJovGa/eLjlsfpHeUbE0i31QrJ70DII47ZwkDvCok8+ySxZrnvnkvp5J6Dle2HUvswmReT5MxMnqM3fHP/T/M+jOOdw01PIjhqAgBmH2CYgcaa8lgCxriyAsqcafGea0AIlU1aDjyPvbSfDTssmFiRFKCbAItBGOSxqXO/DhHbPmzk3AtGd7V4iNOzrDNn7DNk69Ve3pgoQ0WaEfeYX3QA91o1dzPKi6wr8N0mEvg3ViYblhPakGPlQiDecZy/bDhy9dAbFCErJ9w+JlDsFwqVgJC6lFhMiy+kUqU6XxFySR3vBCa6e47mEIq8nsLoAo11YopVTr6Q9dstz9k31TJvK6LixJrR1aiaXulDyc6wONbtS+6OuScvFdiI3pyrkAhmIfg3Y7OUf5gLwhZpalf6FaADjGBUyWSqn004QF4K7rzG4Xps9vY1INydw3hOieE6zH21b+gcHJCK9orTK+CEvdy7EDlgBnEny6VTA85QYM/RGh9zInaIKcZSzhNZITWcor3OAaVHIA6WFYSuZ+leXJ3T7I/lR1dxfLt7LDOudP2SpUQHFSjOzQPPHwhfeFVhQgtAfm9kKW/ZWy3HYlQkeHo8cL7Y0c4LNoQZjzfh8hlXnAVoZcSYt+AidMn6KLZcjfJdfNTkvLe1uT
 Su9+fA3T
 jB8K9egr8C51XpPiK/XZ5/Os84Xu2LqVv2ICLGLhCiBFjASjMl1kA5R3cbYTky/p6pi1lJbugyQBbvgq6H6Lqo6p26wOfFiVIpq7yT+ww4wQyh3R8T/VTe+vMSXPJji2ol0uGP+XOtp3PTGHy4IINjP9+1QvAZLFbnFoqVhVF/8RUpAev3dWl9OZcSlk/oHAls80XNGTtgFH7xNy8sq7yj2B4hYAJIgA3SpcWXTiIwZuvd/Xcf1MuA4shaw5eYcBL1lys7LalLFXcea5GBRpgZesv0R8ZQHy+0l91
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Memory hot-remove can free page tables allocated through different
paths. Some of these paths run page-table constructors, while others,
including generic sparse-vmemmap population, do not. The teardown
paths on x86, RISC-V and arm64 do not consistently handle this
distinction, leaving constructors and destructors unbalanced and
corrupting NR_PAGETABLE accounting.

On x86, the destructor is missing for vmemmap PTE tables allocated by
HugeTLB vmemmap optimization. RISC-V also misses the destructor for
constructed PUD tables. Conversely, arm64 and RISC-V can run
destructors on vmemmap tables that were never constructed.

This series uses PageTable() to determine whether a destructor is
needed before freeing a page-table page. The RISC-V fixes share a
common freeing helper across PTE, PMD and PUD teardown.

This series is limited to bug fixes for the existing teardown paths.
A follow-up series will convert runtime vmemmap page-table allocation
to the generic page-table allocation helpers, ensuring that these
tables run the corresponding constructors. Once these tables follow
the normal constructor and destructor lifecycle, the PageTable()
checks in the arm64 and RISC-V teardown paths can be removed.

Muchun Song (4):
  x86/mm: fix missing pgtable destructor for vmemmap tables
  riscv/mm: fix hotplug page-table destructor handling
  riscv/mm: fix missing destructor for hotplug PUD tables
  arm64/mm: fix destructor for unconstructed hotplug page tables

 arch/arm64/mm/mmu.c   |  3 ++-
 arch/riscv/mm/init.c  | 34 +++++++++++++++-------------------
 arch/x86/mm/init_64.c |  2 ++
 3 files changed, 19 insertions(+), 20 deletions(-)


base-commit: a92f009ac1c21986ff1ea0706419e545a4739513
-- 
2.54.0


