Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8989DC87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 03:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5AB56B009D; Mon,  4 Aug 2025 23:55:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B322B6B009E; Mon,  4 Aug 2025 23:55:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48026B009F; Mon,  4 Aug 2025 23:55:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 953456B009D
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 23:55:03 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 11F4B5D79B
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 03:55:03 +0000 (UTC)
X-FDA: 83741338086.26.0BD0C31
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4756A100003
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 03:55:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ct9bI+pB;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754366101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kn/kjDJbLDIHElYk8Kpqr2EGBYFuzsNf7XyiOkmYajw=;
	b=NktSlBYFBaMl4tOiaA1DgrFQuCjwW8AIQzuc+XN+yodW89+OWZM/wOzCy4y4s0j0JBDJug
	pd24uD32yIn3EHNTQfTgbJG4OpPm5X++OiT6otBDirw9GjsYnEqYVZC6Lm1ipGwxheG7nx
	Z0wl17CqRrwizm5j0MZcvRno0LEtXTg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754366101; a=rsa-sha256;
	cv=none;
	b=r4O/kBV3cSWN2qdQmYNMQh1DF3gMvWhzY4M/uBLKiOhwMQm02lnaiEY1F/aoo+Idkr46Rc
	03lQ7c7kMVyF/9mpTZJBltD9p4NmJpDc6i+yKjywTlyFkjChOGeen5TmSyS4ph6k3/wpvX
	xFtSdOvuFkhS+dZOK2iAI8/oMbeXlOw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Ct9bI+pB;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76bddb92dc1so4599287b3a.0
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 20:55:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754366100; x=1754970900; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kn/kjDJbLDIHElYk8Kpqr2EGBYFuzsNf7XyiOkmYajw=;
        b=Ct9bI+pB2hN0bL/gHYKLJpH/iIunO+U60wWJwlCamKAEiCLkgqOYYEL9DcePuUB8CT
         uR9bBWEMpAMI3tC37JUnmzXh+ZbP4tw2Wfx9RBhOzNyxJCECmBChXpIPPXun6x5sTHW4
         3UKM5/OrPFgxXpxvYqT6+1gvWEUARGMbaTv5u4MXbYZfBG3AibVCbdyfqUWYSCdX/LDC
         2SUAhufuodEV8Rj8JhPs16EFxO9rvoNFgywaK5ebQV4xsc349sMmUR0jb2WmX4LtDajI
         wVwzcapcvnna+OUp4TI8/F+TTUaOXzByz/tJKBxUONpxfvVEyD92W+KSNE1sD0y1rnB/
         bGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754366100; x=1754970900;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Kn/kjDJbLDIHElYk8Kpqr2EGBYFuzsNf7XyiOkmYajw=;
        b=uDY17KiPVJB//yIGyRSog9swXwqA+s3TZ+VymcngmcQI0HcJ2t024IHjLh/xllvlR6
         F5eO0MgYaluc9ICVt2zLoQXVeoRl4pBh2o/vGlFt+xaJ21nj1aFF8Ze1fThFOqb1yzEl
         itmEl7zszXGv28IvsYrs9hHZYpc8k3EcfTGOB9hhugmHXKtWtHrVh3OYcE5UK9gNTUFj
         Wo5FfKwhfpP5pirk0qCI9pCgBH/phetliqREXGlJ6D5l2n8ws7+bCnUAO3rQEqjMSP7W
         ZOdeRSq4LG5ybox8/jvyWqA+R7sdEPOH2BV7uR0YMTHttk+NmP2YdqEeXGSmvXITZMl9
         9rrA==
X-Forwarded-Encrypted: i=1; AJvYcCUXKL08rju6DguponX5VUGzdIpeHZTYJ8smK6O3nZ1BlycUuC4yfnNPRHwIOHB3akD/SBuFSmYbwQ==@kvack.org
X-Gm-Message-State: AOJu0Yxid9qX1yn5Sjb07Ye0xOrINZcnC62zeJRtyjPwsEpMOUp8IWmW
	rAtV1176V4hHD4a0uPOUyzGtWTz0uguTxJwXxpdql0Me4wNTnbOKxRLZ
X-Gm-Gg: ASbGncuCsaHRe55I/Clg5rNYuGoGQNU4UXwvbwn+j5FaBdPjh996iogt+1DIBvMNlFV
	hExFlghRlKa8JGVskbBzLw1FysPhYlxn7jcG5aQ3eLtJrAvbmHBc7I0j5kFjWr0WNH9GBVH4+J2
	qwZfngSDQzCRMhA3VTb4h+ioxketPATYij3SrDCKXk+OEvoP74lPOygtbwpv9JngZ+/ED20I59q
	KkTtLNXUQYTNvhjFu9W/FB5dNTnHW7HoJJeyORE8wR3ENd/YHBrLj7vI9rCmX1u/s2g0VkUqfa5
	sZTHHI0BCA4odd3us8RS8YmZMp5ppGPuPf74+pV3K1KYsRFnbdDHzZzmnQi8iIfkH+3m7DRadeJ
	YeTh991q9/DdEljqoU+qWF5U9lwG/BZ90
X-Google-Smtp-Source: AGHT+IEDoMfcCLIiYtU2HXEp6LOx9BrUl8fsP0ILlEd7EEB3Sw0CsktiKiv4Pv2bZ6wBHJQxNBmbsA==
X-Received: by 2002:a05:6a20:a83:b0:23f:f99d:462b with SMTP id adf61e73a8af0-23ff99d48a9mr9270147637.41.1754366099904;
        Mon, 04 Aug 2025 20:54:59 -0700 (PDT)
Received: from Barrys-MBP.hub ([118.92.21.225])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b422b7e4fc1sm10071141a12.28.2025.08.04.20.54.52
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 04 Aug 2025 20:54:59 -0700 (PDT)
From: Barry Song <21cnbao@gmail.com>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	Barry Song <v-songbaohua@oppo.com>,
	"Lai, Yi" <yi1.lai@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Jann Horn <jannh@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Lance Yang <ioworker0@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>
Subject: [PATCH] mm: Fix the race between collapse and PT_RECLAIM under per-vma lock
Date: Tue,  5 Aug 2025 11:54:47 +0800
Message-Id: <20250805035447.7958-1-21cnbao@gmail.com>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4756A100003
X-Stat-Signature: nx4s9ee43f8btucasuoyhu3mgsw6k46j
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1754366101-115300
X-HE-Meta: U2FsdGVkX194z0riWTVH4Lp7X+rTXNbSa+NZAHCLSsC9we02Mui2MphW0Abqo+VhMWfPtZEvtzuT2c/Sila/ygCiXuas7uSe0SgfVaN31nIfGf8+p5pmtInc1wBjehFPw4mS4FAF+WcUmxB9hgL3ZmIIFwUIpkKWNtzZB0Z2srMNIy1ay89+0XUsF9cviaizjzWHzvajMwlP73Jn4qjj+T/kD0cCJi4uALifqXDAGQ8Zd7s68a54gMxobYucUAo4lVgXhVWK0Vs/rqv9kvmOniFsGNOEM0Bm4fkyeqXid6mY8RwzWVMmucCkRsRkLmPY51Ftyw9BZmBZj/lmzmdHZHcbIsBM0Z3W8unw3r0TNJF2gflkbDc5ikKDeSH7rCiLc4OxmTz2vsuzHA2lDZhPKXSCbO1iiN9xmZoDaMj2lOI8wbj+Vi/canXRQPL2/uHaHAP/UQFxpJoM1eWJthISms2nvruAD+qCKQlhGUo+Hdx1hoi8rd6X2fCAn39LgbE29NLtiAYzkoPsffHIFoXzqwa/3Zjmkj/KAMSkVk7OGoeILi0eV5+oLA1pUhplpWe1wKnTxtUOdGowMTSQjAdJE/566QLGVD44Iv1tdmhEHZUre9n5M48gfEKuo7QiwffjSwEKv0XBAFMqm8xMkgBttsRFUekVyBH6mauphth3CLhtq4QJu978fTDnVQcBD22TlOaIv4vMEP2mt4DRgzRTp0l+v/8/7zbbVQo43uolXp8hBzYaBv5n/Vg5HQUU1esChKfSla7f47JEPB3+x4UlzhQUDfCng85SpPpG2zgfxzq/D+yf47j9VwVZBBKmIvBju5fmdo+IRmICTqmDWLjzhHvIEUAEoLYXHhP+6lO54iY1EyLdahzRCe705wfGI+66Bw0fNzCVwSuxIVcScIXbjatLKYVZ/jj3jiKP6Gu1p5ODhWBtoG2jHdi2cG8kUlShEphuocLbuU1DinwFVCE
 STkmLtWS
 zIFcF0eC5lFNfaK4HfffBjE3fNnA9bU2KrPc4ndqOiO8B7UQ18cypOJRFKkfJGzoNHk5ZjWZWH46bpuaoKpW9ADlP7c6xyD5+A538I43gYDnxQJWq8NbOgvI17BkF3lcUvyFiLMHU1g1qpvzcf5onQRA42XgBD1ieU4XHZ+rNJR4Ap0FLg0Sas4PQZCpUKkfbGDrn5nNvlvOtzlorahtPxgOt7MXq8oosoeApJOq61YwFqHsIUy3hyYwy7p3SMkzaBwILNU5a+TotDVCrDIAunbUKMZKKOGIIGnewl0s5wNlLlFRzWUzta31XPIErzD/CpW9VPRbeydwog6K/Qx0ZoZipIByRMqDf7vWEOkfiSXVogD7Rrz2KnFTlD4q72Qk3bi9EzNrgdxh5Pau0umFmi5E57ak0Xa5aSZDBP08eBurjqCyCpLqLlNqkw8XfUM8P0Yv2ll4XGU74Wop0pPRQUYXr0QcH7JFqA+oTyXoS2slcVLCMV9Q6r501OfoJGOJFeJsJrWLQjZ4kVAqQnP1TCLmRoQlqVrWH7ObrMF3vknWIZQW17xMMXWu6BVBHAlW2UhDUre6w+SROT4itHqw/JLFhWsoK/fYMK6N1PBnDIPLT/90cyi+n12B70YQ4GfbvCP9v+6hC6uf0ImGLhhoiLVLk7n5c1giqT3vgaB6UfROtgnu/ym7FMcJvAssSYExJI4NIWlxhXho57ExJAzKspljKXOwiXxoLZRzvluaGlQsNQ5N/4SPeQl0Gs7mx+YT6Oybx
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Barry Song <v-songbaohua@oppo.com>

The check_pmd_still_valid() call during collapse is currently only
protected by the mmap_lock in write mode, which was sufficient when
pt_reclaim always ran under mmap_lock in read mode. However, since
madvise_dontneed can now execute under a per-VMA lock, this assumption
is no longer valid. As a result, a race condition can occur between
collapse and PT_RECLAIM, potentially leading to a kernel panic.

 [   38.151897] Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASI
 [   38.153519] KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
 [   38.154605] CPU: 0 UID: 0 PID: 721 Comm: repro Not tainted 6.16.0-next-20250801-next-2025080 #1 PREEMPT(voluntary)
 [   38.155929] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org4
 [   38.157418] RIP: 0010:kasan_byte_accessible+0x15/0x30
 [   38.158125] Code: 03 0f 1f 40 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 66 0f 1f 00 48 b8 00 00 00 00 00 fc0
 [   38.160461] RSP: 0018:ffff88800feef678 EFLAGS: 00010286
 [   38.161220] RAX: dffffc0000000000 RBX: 0000000000000001 RCX: 1ffffffff0dde60c
 [   38.162232] RDX: 0000000000000000 RSI: ffffffff85da1e18 RDI: dffffc0000000003
 [   38.163176] RBP: ffff88800feef698 R08: 0000000000000001 R09: 0000000000000000
 [   38.164195] R10: 0000000000000000 R11: ffff888016a8ba58 R12: 0000000000000018
 [   38.165189] R13: 0000000000000018 R14: ffffffff85da1e18 R15: 0000000000000000
 [   38.166100] FS:  0000000000000000(0000) GS:ffff8880e3b40000(0000) knlGS:0000000000000000
 [   38.167137] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [   38.167891] CR2: 00007f97fadfe504 CR3: 0000000007088005 CR4: 0000000000770ef0
 [   38.168812] PKRU: 55555554
 [   38.169275] Call Trace:
 [   38.169647]  <TASK>
 [   38.169975]  ? __kasan_check_byte+0x19/0x50
 [   38.170581]  lock_acquire+0xea/0x310
 [   38.171083]  ? rcu_is_watching+0x19/0xc0
 [   38.171615]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
 [   38.172343]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
 [   38.173130]  _raw_spin_lock+0x38/0x50
 [   38.173707]  ? __pte_offset_map_lock+0x1a2/0x3c0
 [   38.174390]  __pte_offset_map_lock+0x1a2/0x3c0
 [   38.174987]  ? __pfx___pte_offset_map_lock+0x10/0x10
 [   38.175724]  ? __pfx_pud_val+0x10/0x10
 [   38.176308]  ? __sanitizer_cov_trace_const_cmp1+0x1e/0x30
 [   38.177183]  unmap_page_range+0xb60/0x43e0
 [   38.177824]  ? __pfx_unmap_page_range+0x10/0x10
 [   38.178485]  ? mas_next_slot+0x133a/0x1a50
 [   38.179079]  unmap_single_vma.constprop.0+0x15b/0x250
 [   38.179830]  unmap_vmas+0x1fa/0x460
 [   38.180373]  ? __pfx_unmap_vmas+0x10/0x10
 [   38.180994]  ? __sanitizer_cov_trace_const_cmp4+0x1a/0x20
 [   38.181877]  exit_mmap+0x1a2/0xb40
 [   38.182396]  ? lock_release+0x14f/0x2c0
 [   38.182929]  ? __pfx_exit_mmap+0x10/0x10
 [   38.183474]  ? __pfx___mutex_unlock_slowpath+0x10/0x10
 [   38.184188]  ? mutex_unlock+0x16/0x20
 [   38.184704]  mmput+0x132/0x370
 [   38.185208]  do_exit+0x7e7/0x28c0
 [   38.185682]  ? __this_cpu_preempt_check+0x21/0x30
 [   38.186328]  ? do_group_exit+0x1d8/0x2c0
 [   38.186873]  ? __pfx_do_exit+0x10/0x10
 [   38.187401]  ? __this_cpu_preempt_check+0x21/0x30
 [   38.188036]  ? _raw_spin_unlock_irq+0x2c/0x60
 [   38.188634]  ? lockdep_hardirqs_on+0x89/0x110
 [   38.189313]  do_group_exit+0xe4/0x2c0
 [   38.189831]  __x64_sys_exit_group+0x4d/0x60
 [   38.190413]  x64_sys_call+0x2174/0x2180
 [   38.190935]  do_syscall_64+0x6d/0x2e0
 [   38.191449]  entry_SYSCALL_64_after_hwframe+0x76/0x7e

This patch moves the vma_start_write() call to precede
check_pmd_still_valid(), ensuring that the check is also properly
protected by the per-VMA lock.

Fixes: a6fde7add78d ("mm: use per_vma lock for MADV_DONTNEED")
Tested-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Reported-by: "Lai, Yi" <yi1.lai@linux.intel.com>
Closes: https://lore.kernel.org/all/aJAFrYfyzGpbm+0m@ly-workstation/
Cc: David Hildenbrand <david@redhat.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Jann Horn <jannh@google.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Tangquan Zheng <zhengtangquan@oppo.com>
Cc: Lance Yang <ioworker0@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Liam R. Howlett <Liam.Howlett@oracle.com>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: Dev Jain <dev.jain@arm.com>
Signed-off-by: Barry Song <v-songbaohua@oppo.com>
---
 mm/khugepaged.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 374a6a5193a7..6b40bdfd224c 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -1172,11 +1172,11 @@ static int collapse_huge_page(struct mm_struct *mm, unsigned long address,
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 	/* check if the pmd is still valid */
+	vma_start_write(vma);
 	result = check_pmd_still_valid(mm, address, pmd);
 	if (result != SCAN_SUCCEED)
 		goto out_up_write;
 
-	vma_start_write(vma);
 	anon_vma_lock_write(vma->anon_vma);
 
 	mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, mm, address,
-- 
2.39.3 (Apple Git-146)


