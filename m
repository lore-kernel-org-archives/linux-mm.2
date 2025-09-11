Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7938CCAC58E
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 02:16:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 962998E0003; Wed, 10 Sep 2025 22:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8ECAC8E0001; Wed, 10 Sep 2025 22:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B4558E0003; Wed, 10 Sep 2025 22:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 62F028E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 22:16:02 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1C1111401E2
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:16:02 +0000 (UTC)
X-FDA: 83875354164.17.5E4ECD6
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf24.hostedemail.com (Postfix) with ESMTP id 46860180008
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:16:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=moU3wgr8;
	spf=pass (imf24.hostedemail.com: domain of balrogg@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=balrogg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757556960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z61Ud91XiDdZmJa+FtI6083ufxhXzmGdnKS68dPkBBs=;
	b=ML0HoluLq695K2HUt90hM2E5SKJk4SviWygNAwTJgeUFUkeDG3nVJ9ASUPxle+UdJ+pn7S
	3NI0zHHXeLdhClPy8W7Aznm9MXtxNpVOsxDFWyokT9KhaOiqjC2qenZwz7Rc0ITbiiUGBn
	5iYUzDRXhMDaQYz1mkAzjfOwd6zExA4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757556960; a=rsa-sha256;
	cv=none;
	b=v7OCwiHYc93j8IuCcYES5GTLG/Qa8/DCfaEXMNWPVkX3MJ+rnZGJIiwvw9tLZSgCuZgemx
	0rxK6oUD/hAx141c4j2eSDL1Cthrob8dNm1t5cNU4uFTl0nkTVzu6Bz2rtCWi8rb5LTIo0
	Yvnp+12eKI3lrQhZCIPYCPJIjRLvvPY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=moU3wgr8;
	spf=pass (imf24.hostedemail.com: domain of balrogg@gmail.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=balrogg@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-45dda7d87faso1050915e9.2
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 19:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757556958; x=1758161758; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=z61Ud91XiDdZmJa+FtI6083ufxhXzmGdnKS68dPkBBs=;
        b=moU3wgr8+ivtDTUjVuw+AepnPyOZbrQ5PipwxiUaqSTXjLGA/DzgW+hRzGXQVHssnY
         4ylC8hSuC5iLSl4Mv8RRDpCmDIgHI4rbnPFm03unbMa40U7yyb6Mj3wOv7n5eWbjXs+9
         pu/NEZYlzdqrRtGsrM0QLAhCg5XPMW4YIiNRAdGugCNVYk5ivzEHUWU4fArmH93EZ6rC
         BETwhZ1tcEP5xJz615pH+xJMPYbmLrdlZVsH0xKy9IIxq5OxBfUK1HBrnKNBBbrS29oE
         FstqjWtdiW7ut7YuW5wIplfl1zn1H+U8HFWbiE5SXXZeWgxJ2K9R3EABa3Dte0hkdhAO
         g4Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757556958; x=1758161758;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=z61Ud91XiDdZmJa+FtI6083ufxhXzmGdnKS68dPkBBs=;
        b=QuL6H23ylzYrws2ntRxCd0h8GvlMhs9yI1b3TsW3Wj9U4x6dvIgBBzHB8NZrTFUsFj
         1lRRbw4mxC2FN7xbe8f5dsJt+LKS8r3PBVRfgqWIT5XTXdqxgJ1eIwF8gik1lyPVkDf0
         a9Au1IxHp44G1P/EcnuyKMGtFg1+oooLQEFzhzjMrWgbs3RPIwHpGWG9L5GuySdPNdp9
         RDIuc1SW4tllckgxI4CfE6LU94jdY12YfS9PvRv0z2zlK+C+OZ6HnBKUfF8c4ToQ6yOf
         NRmzYg0DZ3Gc4u4kD5UoSdDYaYuPODjPP9qAIW9mTiNwzH7sZjzuEzKl/TpQlim3KIgi
         Y0sQ==
X-Gm-Message-State: AOJu0Yxamv2PI0cG87ErpZFURBVi/n+USqgfc6YnTKtseqyXlgmII4O0
	85xWCP+fylycwaLDUKn8iw8nrKbuPP0I2AHtN/ul5u1qvdecV+qqKlxrJ3uIQWxE
X-Gm-Gg: ASbGncvBWqq4cW3hcyVW8MllQcMo9qYByoKGy3vsf2lz7The+/lzAE7gL3MbqXpx3ba
	jf7zSqF5q8dAgyv/A2K1uKamOzdZJefSb5DnCsG01RU5fUNLLMZtMgrRgC2o70V2oknrjV4i0qr
	M0lu1SABMWoEvVcQTXD3ebjSZo5t26lpIW92BsKcKBpjcRhzXHSlwZut3M0HNzsk1SgdWeXSRl/
	K7DqflgrT181l3QFeipKZZjt/zXWnoHAlrLENrmsNedf5c9QGqOY+7xs35/ccPG5TQJwwUDlCmB
	0nA/XXW5XQEuSIkVI4Pc4KOGGOIORydWY/2q8X3x+zCV1Gnnsoceru9RMsz33ZwuhuojOUb1WCf
	JV8EinLAYM6QN6voIvukSRoxI+QFUD2/K9/H+KWQAuO2jEogcMQ==
X-Google-Smtp-Source: AGHT+IEwiGxM2I2tMq/8NUzlNs+PXpwDcsY0NskG+ulCgXKuPzRP1yl+Ca4cmuleeQvEp32B4oqTzg==
X-Received: by 2002:a05:6000:2081:b0:3e4:64b0:a76a with SMTP id ffacd0b85a97d-3e641f3155emr11788137f8f.9.1757556958076;
        Wed, 10 Sep 2025 19:15:58 -0700 (PDT)
Received: from localhost.localdomain ([82.213.227.153])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd43csm503301f8f.29.2025.09.10.19.15.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 19:15:57 -0700 (PDT)
From: Andrew Zaborowski <balrogg@gmail.com>
X-Google-Original-From: Andrew Zaborowski <balrogg+code@gmail.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Miaohe Lin <linmiaohe@huawei.com>
Subject: [PATCH] mm: avoid poison consumption when splitting THP
Date: Thu, 11 Sep 2025 04:14:01 +0200
Message-ID: <20250911021401.734817-1-balrogg+code@gmail.com>
X-Mailer: git-send-email 2.45.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: i1z8o7aahob4qji34izf773mtbr7165u
X-Rspamd-Queue-Id: 46860180008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757556960-733707
X-HE-Meta: U2FsdGVkX19NgBONmjaaw7xUC9pbN6HFHHu4/xsLpFr49HZTEbFlVrEpQDeAiqfXfoffQ1/PGiJlUHCvvuEPVvCReEiJhKRTEdCJFxLOOnM6o4kErA1E5Vh63gSkizPAq+RkViETPxm0g1slmf7O4TswmmqB+ZUW15tdNJKimyFucS4tL3OTCZDGiIKnh6yJFuuLu77FGLDP9rBSs7iq1Cby6aPZWoRGGzFocuvCcx5XdjXjH3EvWZCdscxrSG89e86FebtwZbiTMOougRuZw68X7QDTvXJ5+C7RyG0C3OKiTEr3YpPNd8SR6slgzeVKY4VqvIBWf6MC6V+i29go5tDqhDEllo42+PEyQoFmeJQvOYc2zlbhD22kd/N4B78aQogb5q1gT8HXDJlB9Ms5e2abVfxI9UrdRCeO+rRy9+FAekg5Re2/TUo5aZfCi7Ao+6Tbovr4s8Tx1p8WtCKjflMQjvRRpwg+BTqBOcCxMp5zkmriWgTlZkT/HLMGKcV/6P7M4arzW5JEs3+9PBNWOoCsTqdM8Wh4Mzwjkng08xiY40IpWcR5b7R7yh/IDO/YWuK0kol5Bgkq7wtfYBa2i1dog+kRZcgnSl5mpSNVQRZJzHTrtbW1xgBcqjnh8xQb7gAnJZ4JMKIK+Bt4bJtN49/rOjRvYEv76TO1Q0KhWKTgahLzgaFUSFGa/THZnoBiYYN+Gps0z/cSXDrbHH1kW01dqtcF7BmH3PgxYFSlJTLedI/9VvvkGNAVvP1ttQElVrJjCx/AKARe5n/W8Ygk1iUufO96UbiSBZDIzL7fSwawE5L4aSwe4KwCmw2cZXkIf7EFpnDfyGvemZR2/LqqLt3QsA70ICbouxCYhsdjAq3shTwEpzHtmUfIeF9Eq+hmFFH+PUaU1idExJz9fHy6VfT+i5A1N9GDc6ZJ4LS6js5VmpDydvaXOtTouj+Rs4Np08MwmD5GqHhOQT7dxNA
 XTOYXr6k
 MbwAfAZs1oVszNMGfij26gHj/W7/EzfJ+sMw9n7L+BFJfViG3AuUW8EI4sfEnmbm8qeIUs7ZdomrgIroCCM5IqNLjs8w2U/0rJEMcEsxVx4LJHWzpbmzswmn9QDuldzqShWeAflManUiCMsUDPKaMGq/SsbCT4/20g40475b+y+dUD1ICiBRynfCyRzk8XxAtfCjzOEIntkr7vC4E07A7l1tLElgmwIma8Ul7e7XHEBcVPAEy9F7l2A/n/JaFqOy3eHZNVhqWpduodz/6tk3VF9r8db0lrWpkbhqlOQWUmtj2mGIPi1FT47av44Yc7vFInt8fkTcve567cXRKUyxD9yRV2n1k8QjzfPkgFdPbxB7A5L5FUrwMgpQRjbGNAQ4I2phyqmx8juQvKCtSbmWVJL6RGjYLJsMp4twK
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Handling a memory failure pointing inside a huge page requires splitting
the page.  The splitting logic uses a mechanism, implemented in
migrate.c:try_to_map_unused_to_zeropage(), that inspects contents of
individual pages to find zero-filled pages.  The read access to the
contents may cause a new, synchronous exception like an x86 Machine
Check, delivered before the initial memory_failure() finishes, ending
in a crash.

Luckily memory_failure() already sets the has_hwpoisoned flag on the
folio right before try_to_split_thp_page().  Don't enable the shared
zeropage mechanism (RMP_USE_SHARED_ZEROPAGE flag) down in
__split_unmapped_folio() when the original folio has has_hwpoisoned.

Note: we're disabling a potentially useful feature, some of the
individual pages that aren't poisoned might be zero-filled.  One
argument for not trying to add a mechanism to maybe re-scan them later,
apart from code cost, is that the owning process is likely being
killed and the memory released.

Signed-off-by: Andrew Zaborowski <balrogg+code@gmail.com>
---
 mm/huge_memory.c    | 3 ++-
 mm/memory-failure.c | 6 ++++--
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9c38a95e9f0..1568f0308b9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3588,6 +3588,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 		struct list_head *list, bool uniform_split)
 {
 	struct deferred_split *ds_queue = get_deferred_split_queue(folio);
+	bool has_hwpoisoned = folio_test_has_hwpoisoned(folio);
 	XA_STATE(xas, &folio->mapping->i_pages, folio->index);
 	struct folio *end_folio = folio_next(folio);
 	bool is_anon = folio_test_anon(folio);
@@ -3858,7 +3859,7 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 	if (nr_shmem_dropped)
 		shmem_uncharge(mapping->host, nr_shmem_dropped);
 
-	if (!ret && is_anon)
+	if (!ret && is_anon && !has_hwpoisoned)
 		remap_flags = RMP_USE_SHARED_ZEROPAGE;
 	remap_page(folio, 1 << order, remap_flags);
 
diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index fc30ca4804b..2d755493de9 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -2352,8 +2352,10 @@ int memory_failure(unsigned long pfn, int flags)
 		 * otherwise it may race with THP split.
 		 * And the flag can't be set in get_hwpoison_page() since
 		 * it is called by soft offline too and it is just called
-		 * for !MF_COUNT_INCREASED.  So here seems to be the best
-		 * place.
+		 * for !MF_COUNT_INCREASED.
+		 * It also tells __split_unmapped_folio() to not bother
+		 * using the shared zeropage -- the all-zeros check would
+		 * consume the poison.  So here seems to be the best place.
 		 *
 		 * Don't need care about the above error handling paths for
 		 * get_hwpoison_page() since they handle either free page
-- 
2.45.2


