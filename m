Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC47CCA490
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 00:04:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F12B26B0092; Fri, 16 Oct 2026 20:04:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC4906B0095; Fri, 16 Oct 2026 20:04:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D64E46B0096; Fri, 16 Oct 2026 20:04:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AE0CB6B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:04:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 440BB1A01CE
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:04:58 +0000 (UTC)
X-FDA: 85330172676.12.EC98C71
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf21.hostedemail.com (Postfix) with ESMTP id 886E71C0005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 00:04:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/jA4ioQ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792195496;
	b=35KpvpleRBsV/EKfA7HLr7EN30H7OYVHl5rVG+pkiA/zgo7GJFqYcKZ+qhkk9nEvytLlsx
	obW6yZJkcL2YmXzM/buXmXxLur9zIzgJwnjPARMCqZujCuNZmd0LzgtFEUYxZhMx/GYknF
	xhwIGIGZcobQabg6wwZQHXtHImuDOuk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="Z/jA4ioQ";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792195496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lBiMjT8ldL7Ky1jQPlUb8oCa4/bnIv7ADJeJybOOjZ4=;
	b=lML/bd/KLaynInldyalUFMcgZW5i5hG2fKC4OKV83pfzACry6g/Nedtc2xWrn4cKSLSK00
	PScVT/3KCTlZ/FN61wGxWcoZ4PnbAmGV1wKg6U41B2j534YZtl4FvMPOp6NJarFOQ3+9cH
	f2cXxet5zv13oUcGBHwxpQjLAPtLs04=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-cc50ad2d650so331011a12.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 17:04:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792195495; x=1792800295; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lBiMjT8ldL7Ky1jQPlUb8oCa4/bnIv7ADJeJybOOjZ4=;
        b=Z/jA4ioQFmxK4nIGVExaxROb3M7iLiVj2iX+wnHkgj3ku7p0ayXdDy1UQF8mMMMZbR
         rLNw09iZAteC848Le+JLJ4dOXr/7MhR1pUsk9i6OYd/P68RqhvKGk0BF5HRKKuaQyT0U
         IZcP9yB8c2xRKEzG+B3ep1K0ZaGdlub3sba0kObOyFGZqmwQiflhe8UuOmN2I5ne6+xd
         JITum7zphpIh42gAAy2aNrYMwqchPmbxXaGdRCet7y0eFwiGyq556Kzm1/XiTN+GkP2f
         SLQETcfznDq/3KksjvThS7Ap+smizF+rPEWXLj/7dRhpERfUNtXKIDl/5k/jrAjJPup6
         e8gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792195495; x=1792800295;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lBiMjT8ldL7Ky1jQPlUb8oCa4/bnIv7ADJeJybOOjZ4=;
        b=lke0jyJvLTytyCjSlreNaENHYBkq0jZGB3+CQ8fWtIMR/geRlw5uBAj9ifH3jQCPJA
         xjcuoU7crhPPC1Xn9jnxyAjSG5yL4BfNo457e+wkEb9i29invUZNDNPNEumg6rXy+UPf
         bMwgPFv/0UJeHpxPqPpO50nabwMMekd0oUcUgdJ2aGdztspCB7fyU7XaBvda7O0mcP3E
         LwVlgn1ITrG9OeceQF2XlCGBMExnUbkD+3A7NP9NM3bfQvQrrf/GOhjXpmgnpzkZKln4
         B7G27KMBOvrYsTZNMAmD16WSkMH60X6pwQqRoE9T3QulnsJLiKZC2udYfQHdaGhWcuSH
         E+EA==
X-Forwarded-Encrypted: i=1; AKwUvBx6JFRzP6WJiTgw/KA9RPqJttzS/s9FM6ROx06Hv3aCXNPJM6mLzFV1+gnNcLwqzd8komp5bl6RAA==@kvack.org
X-Gm-Message-State: AFq9FYKlF9Bt0hjSewaXpy1wNRukzT/68lGQrePiZ464C5B+g8iQf1rK
	lkXt0K5vrR6qtxvTL5SHpV6tEBKF7E6TZi1lwKynhb3tx61CYPSI9+5R
X-Gm-Gg: AYBFou0j3Yw66n+fNSQr7uthbBeGiSXxD96GU50elljEUpqt4sd5g1wIVO3/2fyK9to
	Q2GykQPmb8azQhsEF4XMEyjVLHfrJZCbbt19TPUx6ebDfMmX4iKXkim0t/3ISVLANTjMGJJykmX
	DqBuRgPibOxoH2esVOdGXni71clc0JwZ9k8ZelSRtWRtr/RubNBO89sYAm+utNN1nIvKOQFJajG
	MjEJ++fhELp70wfcYWxSJKRbRN+CtRNPswVZRGj4p5E7xh5P8Pk/84Li2XtDcWXQPRC2tjBldN7
	+EtcqpO4+Dc6t8NUJvUnjusr+bMbFQd8e2TCuWzFQYVkxnKNC7onQa9OKlS8fNrpQwY2VDXSjcr
	9qSvcYkdcJIa6kgItxRGWkUQvq/bBeFG1KPZImQgBAUL0szYV6f8sc6XKhf4F/h4VdayDbgw/Hp
	HqXIaebaKusXLWSp/6SEL1LWI+nkcN4K2ZvfpSzDFjQC9TeYl7gyJ4x/uzTRgcrEPKuaDWOV1Lp
	0PeRne+nEEB3U7hcoltE52eKvdo11UCtkXdcRFUrkak5PMgK7ySQISaLWEFTPzKYcrZzg9yeZD9
	ETunYzSgnKKD44j9n/amD8TBn3kUJKxI5qetRr+dhTnR7dm8NoKq2LX6MrisslX0lqn2xftR9Ua
	CRHdYyZPAvQ==
X-Received: by 2002:a17:90b:2e46:b0:3ac:9e76:aa9e with SMTP id 98e67ed59e1d1-3acee276f13mr1245594a91.3.1792195495154;
        Fri, 16 Oct 2026 17:04:55 -0700 (PDT)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3acc98139ccsm3284963a91.0.2026.10.16.17.04.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 17:04:54 -0700 (PDT)
From: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org
Cc: david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yuzhao@google.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	apais@microsoft.com,
	rlmenge@gmail.com,
	Siddharth Chintamaneni <sidchintamaneni@gmail.com>,
	stable@vger.kernel.org,
	Hardik Garg <hargar@linux.microsoft.com>
Subject: [PATCH v1] mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled on cmdline
Date: Sat, 17 Oct 2026 00:04:51 +0000
Message-ID: <20261017000451.89536-1-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 886E71C0005
X-Stat-Signature: dgfi7r8d84mcqnb5n8h49bbt31oiyc3w
X-HE-Tag: 1792195496-355467
X-HE-Meta: U2FsdGVkX1/gkL0x8v/YdC9N5HG6fZxxjuQK6i4Y7pPAonFScFhU8pDaDuHadYjKL8uNib28bZmqPq10L3LHfB9CPvrW5d3tBFJGNReF+nc2xeKFNBOzItyyZw72cBkY92JurTTCiVrYwnrbzwfFUZD480HoPuYUJFwq/Vcg1rInSDNYyXiC5RmLVJv0+OcVZ0b5QoqcvNoDtLVw5umNPypwERFEOErGoM9Jirh6j19PXLv6xrL9WYERWKy8ZkBz8QOazbxv7s7HNPdgVw8kGCOh361OXne4M+e2+1Gvak9KwHbqVhjCjqpZfcBr+ZHZjWnqdGAsrmCo4nnEpr23S/vVPlRn1uJykm8OUipCgceZfRbcRWK44nnyYx9ZOmc68WkMWqKTElDmi1NAW/zrhT6cDDgwG91xO0Ssf7zUUSCUrKNAYGzhgB9wG+1V3M3lAUchSTe2fLLtcch/YiWS6iPeYnmCHgZ2s2tDiEhhmBtqVFuuYIGnWUiXPn0cyBGDXh1OxoBpevwJcZFwGKeiOJY7RqOPxMao67NGN+H5hEWq0O5TOPeTw4VvkORXMtq3bRfOWQqO8kcbrF5iQhm5bl4ObgVe53cHNFH53oNqChnV3PnExQrykB3O7zArqDF7YiORxIeZLXbnnAV/ZqrOLGqF7nTQBzQ03mD5dxlzwP6234LXTd4cyw3GQVMgdpzlc///0NHWjYZjgTBWJNAsOvEoK88HGifWQ24gdBToG/0at5iznTCCiVvME66EfvIZs5icSqkizJY7wzwhLJWkhObXe+fQwcqp/SRU0+1UDnDmKeKIsu8kdYW4ng3SRKWy5zVNyLaxCZtgr3S1lvtA3pF/VIu+qSl3BPn+J5l7QEzayXeJkgW/QchEx6LZ1WHDqg8fpBmbC1XOFlSBZ+kZ0txqEytUPS3XGwo7G/T4IeENRTyMbFpYQD91pQQUPCpKhXoVqU9Im8HWRL999ii
 8oOVe5kY
 StBbA8lqvtMr9BjD++a2u1T9MK67UkgfDJNpK6SjGVFBckYroYL/dAtWw0UtDfXFd/b/QwIrPSOsUJdYLzpDXlLrj01WLzVSxz00KmyjaiKpI2lQKdKrSW9GhR6LE4jibvauJQuD0LGQ9W0vlMIDCrYdQEoD9xL5rB8vW4RUHmOEcSqfOGH+tYx8ozExPcKdj30jt1AF59EtdcGnVo8MJSf8ZM7g7p1OWa4ZSUQ8zFixlRvuWvO0KD4hrDC9sxvFLuFDXSmA8g4fuH2apPi///rdmspMOag2uRQP23zp4WGaCPEpubNYWc2EpG3siQZIxiOz3FsX7UWIKQv9NiR2aJBvT79cp+yUrAvjDV2JsnQHqzBw1DRemC+pIBynr5qK2Wf/DxVOPfzkterij12tMFox+mc6R343oQrL2RkFToGBXFmyhGKSXQ773I5bhkRq1/POEiXgW+deSE5U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When CONFIG_MEMCG=y, lruvec_pgdat() returns lruvec->pgdat, which for the
per-node pgdat->__lruvec is left NULL by lruvec_init() and only filled in
lazily by mem_cgroup_lruvec(). Normally that happens early, e.g. on the
first folio_add_lru().

With cgroup_disable=memory, lru_gen_shrink_node() passes &pgdat->__lruvec
directly to shrink_one(). If direct reclaim runs before anything has
called mem_cgroup_lruvec() for the node, which can happen during early
boot under memory pressure (e.g. a kdump kernel), get_swappiness() ends
up dereferencing a NULL pgdat:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000005040
  pc : get_swappiness+0x68/0xb0
  lr : try_to_shrink_lruvec+0x54/0x2c0
  Call trace:
   get_swappiness+0x68/0xb0 (P)
   try_to_shrink_lruvec+0x54/0x2c0
   shrink_one+0x8c/0x240
   shrink_node+0xc6c/0xe08
   do_try_to_free_pages+0xdc/0x570
   try_to_free_pages+0x124/0x278
   __alloc_frozen_pages_noprof+0x6e8/0xf78
   alloc_pages_mpol+0xc4/0x1c0
   alloc_frozen_pages_noprof+0x54/0xe8
   alloc_pages_noprof+0x1c/0x40
   atomic_pool_expand+0x98/0x300
   __dma_atomic_pool_init+0x58/0xd8
   dma_atomic_pool_init+0x154/0x170
   do_one_initcall+0x64/0x350
   kernel_init_freeable+0x214/0x430
   kernel_init+0x2c/0x208
   ret_from_fork+0x10/0x20

The classic LRU path and MGLRU before per-node lru_gen_folio lists
obtained the lruvec through mem_cgroup_lruvec(), which sets
lruvec->pgdat.

The above was hit on an arm64 kdump kernel (6.18-based) booted with
cgroup_disable=memory nr_cpus=4. It also reproduces on mainline on an
arm64 VM with CONFIG_ARM64_64K_PAGES=y, CONFIG_MEMCG=y,
CONFIG_LRU_GEN_ENABLED=y and:

  mem=160M nr_cpus=4 coherent_pool=512M cgroup_disable=memory

These options only serve to force direct reclaim early in boot; with
160M the boot eventually ends in OOM regardless. On mainline the first
LRU reclaim happens while unpacking the initramfs, and faults the same
way:

  Unable to handle kernel NULL pointer dereference at virtual address 0000000000005040
  pc : get_swappiness+0xd4/0x150
  Call trace:
   get_swappiness+0xd4/0x150 (P)
   try_to_shrink_lruvec+0x44/0x2b8
   shrink_one+0x80/0x1a0
   shrink_node+0xd98/0xea8
   do_try_to_free_pages+0xf4/0x4b0
   try_to_free_pages+0x110/0x360
   __alloc_frozen_pages_noprof+0x8b0/0x1718
   ...
   __filemap_get_folio_mpol+0x2ac/0x548
   simple_write_begin+0x44/0xf8
   page_symlink+0x178/0x198
   ...
   do_populate_rootfs+0x13c/0x200

Fixes: e4dde56cd208 ("mm: multi-gen LRU: per-node lru_gen_folio lists")
Cc: stable@vger.kernel.org # 6.3+
Assisted-by: LLM
Signed-off-by: Siddharth Chintamaneni <sidchintamaneni@gmail.com>
Signed-off-by: Hardik Garg <hargar@linux.microsoft.com>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index f11491ee9ed5..0c57e4f1eb15 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5253,7 +5253,7 @@ static void lru_gen_shrink_node(struct pglist_data *pgdat, struct scan_control *
 		sc->nr_reclaimed = 0;
 
 	if (mem_cgroup_disabled())
-		shrink_one(&pgdat->__lruvec, sc);
+		shrink_one(mem_cgroup_lruvec(NULL, pgdat), sc);
 	else
 		shrink_many(pgdat, sc);
 
-- 
2.45.4


