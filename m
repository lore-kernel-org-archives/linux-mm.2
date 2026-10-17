Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AADD3CCA463
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 05:09:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 678D36B008A; Sat, 17 Oct 2026 01:09:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6293D6B008C; Sat, 17 Oct 2026 01:09:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51CE46B0092; Sat, 17 Oct 2026 01:09:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3E26B008A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 01:09:34 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A53D5401FC
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:09:33 +0000 (UTC)
X-FDA: 85330940226.23.A613667
Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	by imf29.hostedemail.com (Postfix) with ESMTP id 00761120005
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:09:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NMaYWjhM;
	spf=pass (imf29.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792213772;
	b=8jNPeodcpsSwhqWeWY8ISp/GLkyFuXaJ0WBBoHQ37bLf6lqAzp8bjqETN0soEqxLoslhvi
	kBAmQwKPhbUapd61QT6X9m45VFm3yN4A4yKc0eRw77KSNC4SRJw71jIxC5yZX8yoN3/iD3
	nFmgc5KzeXv8eKmZQhW7WxcRU7VqUnE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NMaYWjhM;
	spf=pass (imf29.hostedemail.com: domain of sidchintamaneni@gmail.com designates 209.85.215.176 as permitted sender) smtp.mailfrom=sidchintamaneni@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792213772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lBiMjT8ldL7Ky1jQPlUb8oCa4/bnIv7ADJeJybOOjZ4=;
	b=oSN7/w3cj6vGNFJ/DY+QQNDO6N3Q0PMcU8JUdsGDA2cOYfbBOIjGuJ6JKJB3rQLqJCDlY/
	RGv13Gz8fcJSCElibFOGgvShhMsv3qo/veNeH3fVlYLvjp5Nv2DqgauSh/llbF96zK1T4t
	wXh4sejgnvhm3EZcbczdWgKYrsyGqhw=
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-cc758830601so444311a12.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 22:09:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792213771; x=1792818571; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lBiMjT8ldL7Ky1jQPlUb8oCa4/bnIv7ADJeJybOOjZ4=;
        b=NMaYWjhM7YY3mC5XZGS56QoesIA1UgYixIlsWY/Fy7HbcbIn3LvqV/9XidcKWmrY0k
         JvbYsrJqMUpv8VuxC7kUc9mC4W1bxynZiHFdHmG8rBw3UmfDWhioG3pDHspNTOYYKhvl
         eNb5UIcTNPSB7O61rSLjy665+ryZLbKK1zuXe+WMi9BTywuIuV3QX8mP1GVXn9nw1F66
         AnVypA57F3LuLhd67n6r3pqw6bop2rLBd+fndXNFHtPOXeOEXIA9sF9B3U3SXuWeSZJo
         2qJtJNx2zENHtOM6xGmJiVqW+ZcVlme2DXXC82gh8ZkIIaMWgVZ4+5cS29y5xZ3fN0GY
         tmPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792213771; x=1792818571;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=lBiMjT8ldL7Ky1jQPlUb8oCa4/bnIv7ADJeJybOOjZ4=;
        b=oNm5dKNOrnu6UlI7dw1qz4vVtIGlwzIELULr+LBnpbHeIjTbVlPSYTB32saH1klzuh
         SGAdnJpU+mgWT14iHvcDzl+uPjIqu4OtzFGqn+VVC+mSYrfAXWszm6QnzOLH6mn8Y4Ur
         +5KfYCZ0LquMbl5tVh0tCMFBG0HJWuNyTVy49HhXtOYkv7aJAHEdVpQuhqto3EbKXU86
         rKSh5mhc0NhZ8xhJFHNTPVgezX6UX7qDENuSkLQYfPbWWyt7StfFO1EKRsIOCFKyiclU
         PONrBYBWdz+6PCTdLdHFrS1OQ/ZZdyiT+Je8O6kbERy/7DIBCSR27BPQekG/J/EdyigM
         jF9Q==
X-Forwarded-Encrypted: i=1; AKwUvBwEIq/EVKle45TOyCw7e/irPFmPUEsXFFsZfD/xJuf4hfzZ4R4LAExbJeYGiz7MCnGWsNo5K5bCwA==@kvack.org
X-Gm-Message-State: AFq9FYLeivNITDiP8N4h+ig/q4pEGbfFFFeTKRTGMpGdaQ+kjnMw1cHm
	vw0g9lU+AhnVW0jInTWGDL6y4RKlAHDxaPmUPkG54SRQXPRPOwvbYUnM
X-Gm-Gg: AYBFou24QFERxyXG+O1qlPc8aqgrHxdFVkbwokT5bdMwwuOxcekken/Au0TncJNzdYZ
	I8RO7sGEPMltbKkgiX8965MCAXOUYjVQvQgwH5FNxDXPt4IoIGVwy+9WkVxW1N14nQFYsWUAwTt
	Uqradn8pHul88EwfHgFLIhdlpqRp4xXEIYcJdh8J76ef8BP7Ewvmc9buou62AC83GtMOj01JZd4
	mzH3f7lU2QTUdtEgv8pDcbVV/7rYYC9azKVaXKbtybiIgIeeiTnpji4RmJWglrpMibf9AWQtjZK
	jAOp84jFQxm5BWm5qGKV1WOrLcp+YM4GR+wUHJONtHwCXfAxoOqpPPmBMrmzrWDWRElsr29M5IJ
	M2lYLOL6GzWOZpPA3axIzYIpk9AwJUTJaWlEyoGQ20UpSdm9RUVUxotY5e7QtJe+ZITNTVnBnmd
	pQfX0b4oyJMl6xx6MqZ/pjOYKGYDut/AYUv016Ru091LsB8FYZPx1Kn2oEadHNgfHb0S90V8mgQ
	EymwL99K+KHMMaXc7ID6+qUAZhBn41VbW4x73VwIC4NlwtH/LRLYLKqJNyDhDUWFFFueMG1qkbz
	I7j0R29AavqCfcTITdramN1J2Id1aGyiMxfhjrGmRQ/M7hgLgtFCBfA8uUsbQOJNvy+BltG+p2B
	6z39jIs8WXAMtIOTg6z3p
X-Received: by 2002:a05:6a21:6b88:b0:3dd:a00a:1715 with SMTP id adf61e73a8af0-3e2263d5f61mr1225361637.48.1792213770605;
        Fri, 16 Oct 2026 22:09:30 -0700 (PDT)
Received: from sid-dev-env.cgrhrlrrq2nuffriizdlnb1x4b.xx.internal.cloudapp.net ([4.155.54.158])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89febdc2209sm1446036b3a.33.2026.10.16.22.09.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 22:09:29 -0700 (PDT)
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
Subject: [PATCH v2 1/2] mm: multi-gen LRU: fix NULL lruvec->pgdat deref with memcg disabled on cmdline
Date: Sat, 17 Oct 2026 05:09:27 +0000
Message-ID: <20261017050928.128582-1-sidchintamaneni@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 00761120005
X-Stat-Signature: hd6udake56kztp9zqumb4xjmuq5ntn33
X-HE-Tag: 1792213771-908999
X-HE-Meta: U2FsdGVkX18/Cov21F8kouEEKe2RmKOism0oZFRrr6EIKs7xR/SzNoRAJJ2djJ/L4RgqEdGXHp3hm78X36n4GRWQ5uMcyc2vStsIEh4AbDQK73pJVBHDFB+vmzGZ00kCwLbjtpyhQfVbG1iAujz3Wi+EZV/IFuLLwYrO6M4A503z+Q9zNvHW8ScJU5L+kI8cAG+RPQwZyBdPDJBCsRghedWlbEzdNueuhmS2yjaZtSLuKl26rTct9axQJJGTrIjeTwNJaX5my25exwtnQLuXRW6jFFaepMLTAs1W6+yZsgCpOS34L/Qf/vFiq8Gir6UbQI4fSzZ6iLFP/JDVI11naKrNSrXCTcfnjJHSLzuxtwlvaB6Q/h/emIsn/Gi9rnwcTfBbqgFWeHwI1LCdclp+nf1O+NBsLURg88HF+TL0rNVuEmx1Wj9IsLJG5QJ6lfg3tAfbx2XfTFx91q4atL3+fOx1Z7JnMbBEQ0wfN/amAuIfJgx+aJYQ5+jK6Nit7Zp7HR45WmB04bZiA2N/Fb6XgXDZvdWxHDGw7tix94eOEU0xNZjY586hRQ66pJnWtMtM7eqZFtITbQG39fJJHSRWr324JcRvjEum/jpyyAPzF5nyoOVfWvDYfPG0nth0eo1dZr/m3bDvN0kV+kWJuY8zC714YyvQoyEn0XFq5KY5Bxv6gGZDtV91DTEL5PFbUCMiIPgYu15/fWwsqQt5Wex0QIxRo8haRNtrnKBY5dlIel0Qo7syrLWp+3UyOHcKHBhQND3e2/9+Rp4Kfhrm48s+GQMRvMQ0gDS4txwvnRZ+D4pzicrnvWvnpglEdEFiF4LdN4Zk4rxMBZexeA4AiSBZwtUbjVLa6gKrzTd+WHJD0Ab5WyHWDk8ZXGG+I1ivxJbNTVMvkkZpkMo1L+f+wx5zvUOhBSBqkJ4LUqJo5+ryzyyUC+I9FFywwY4yhweBfHfUbLGl8F3Tp6CO79YfCQ0
 gfv+Eqi5
 BJvcnlatHFRKH1SJO8JyJiDDaRNHTL+/mVFL2tG/TfO2Clol/Yral2QbUTq9VStZi/ZVB59u+OB30jaKFggQpjRZEFRDjTmUY9WoJQ0+Q7hmUym5SBF3eXcM6AkFuUECWomFDGkHJB1pQA2sK+NcZ/eb1jyNh3BkAle+SHr2To3JHv6tD6WED3meqUFQ8Oy20QlLQ7y74OVFBZ3C0alY/A6SrqdqUlC/SWMP/V4DeKZXPaaEciSCTt0CEPaCH6cDYDldIjyk2mlJu/AKpyoz0P0uI8PvubD/RG4FRkjBLWCZJ26EwhXbOaoBjUuKRQwRqZhGg6Ht0j4hlJa6txZMLOJfCxD1/IoZCyTCcVKAQPohnioQs7LYIJMadKoQiH/j5qFp8DtnADLO27sSswANnoSjcbuYLunTwHdNQ7dLqVRE8NsAJRUSTkbEd85yaalGouLpBuryWVYE2NZU=
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


