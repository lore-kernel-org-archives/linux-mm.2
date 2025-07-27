Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4870C87FCE
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 10:59:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5E086B007B; Sun, 27 Jul 2025 06:59:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0EAC6B0088; Sun, 27 Jul 2025 06:59:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D24926B0089; Sun, 27 Jul 2025 06:59:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C57986B007B
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 06:59:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 45C101A00EC
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 10:59:56 +0000 (UTC)
X-FDA: 83709749592.07.5F0F528
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CFB7840005
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 10:59:54 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5E38ZSM;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753613995;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kmIY1YzYqHrEFKJ1n5m16jAQf3BDqgalyXBF+PWx7Bg=;
	b=axcwXhOjNzPqzyaxR8F4Ub5tRdmE9XXBPCxblbfxpOMrIyGEHWE6wvuQmUztsJ10HXTKtO
	ovsFnjXiodNb5rAECbd4LZ5P03xdHDuHU1qSiob16ue0ZCZRMpMJ0hd8cVKZgX95xQV2Q3
	KXFLl2mRYcShGxHcvV1W/nFPxD8VK8U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753613995; a=rsa-sha256;
	cv=none;
	b=pGCZ4rrbsq66DIYnJ+F3t6uazy4XLwA56jmG5StaBVMMzBGTysq1rsntujUfH44LkYY30R
	/12b+IHmCwwoNnqagtk34piDWIo5+HkNlqbFj5OqQsiadK4zFL2KNPXdaZUOjOFNfUmihs
	1VFUA1oYlmDImaWgZF+5A2azZtkQeX8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i5E38ZSM;
	spf=pass (imf07.hostedemail.com: domain of dakr@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=dakr@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7321944F4A;
	Sun, 27 Jul 2025 10:59:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67233C4CEEB;
	Sun, 27 Jul 2025 10:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753613993;
	bh=58VEwhCHrFJ1R45SJv+ufoUUAGi0PqZriv1MDWB2qig=;
	h=From:To:Cc:Subject:Date:From;
	b=i5E38ZSMQQw9olQF3vXX3wo3A9j65/Rw233xxLSXmuncUmz2QsTgprC197AqbX3gJ
	 AXA+x2tBU5+Vg5xj8RpupL4zXJ1SFNczYIRoW67wggJNDcsWFGcyJ4U5jROIms93+d
	 tfEBds2gxTp70qN3iCGJtmB6041aZUU2KLB13dHtUbadsqHtGhgne14EDjAS1Mj/Uj
	 PezAcUhZ4uDxoxPFCDnrM9YN/mc+A9GUBRIu0LSiEjCF1nAuMitQ6XqErxXw7wC5K8
	 zlE13ftoLpCJkRvUlc+o0bAxfgql8YHAjR2A81RyscNUPQHdXR3maaBAIHvg5bKQAB
	 DHV+ZKigbgZBA==
From: Danilo Krummrich <dakr@kernel.org>
To: akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	david@redhat.com,
	mhocko@kernel.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	lorenzo.stoakes@oracle.com,
	gregkh@linuxfoundation.org,
	rafael@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Danilo Krummrich <dakr@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Matthew Wilcox <willy@infradead.org>
Subject: [PATCH] mm/vmscan: fix inverted polarity in lru_gen_seq_show()
Date: Sun, 27 Jul 2025 12:59:06 +0200
Message-ID: <20250727105937.7480-1-dakr@kernel.org>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CFB7840005
X-Stat-Signature: drcxif9c5kq5bgf67wippcgtgseii5jf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1753613994-490649
X-HE-Meta: U2FsdGVkX18klf73VVHwLtfozkDJ96+VBFngJ0mS8f1dCVXtwFc2qJ7PGjr5rmD1HI7pgOCWWohJYMxUaXVdGnMeKoVkMSTQANtnEOYjL2ZkwqHuPecxPBIcjDNr3a/mKTbws8T1yykOdMEUr2ZP+nNNhA2sYQNF7HsDRacrUbgj7rKLMcncvl8lhggtwseMQc16A5j9cNvok46Cl/OXZnkPTWzqPkq9c8VrJMDjsvpGU1okWyfvdSRRUbnUCApyxQpx9ThS4R88mI6gnGCRmuojzK3hFdXJ8kJ7RY702AJSdiRPLbIq/k2YroqoRnVURzsA/+irpRCbeJKJmBruHsVsHkLQEmC5elmNZ52BiybwAN0aesSojHQuOp58euXIoFvQ0TCbMGHDp6T9p8UmvztKXtBPSRCSiURQqo5T3Dxd1Y/SNPtYk8pUkLOy+dq+5DY/TTO1r6Yg9MNZz/w/t2bKknjRU3RTOMXBvAa8oSjKVF+5+CTlFO/OD3u8yZOrXLmT2wmrvtxyUKZ3f8X5nvGdNutnFv+QgjFhTMP0WGgQM0FeelBON/yYWjgB6BiN99o2Kf43y8OaD6wkj59MGOI3qFdQUOnxVaIvukfWgnqqLTLP5FdJwvbmxkXi2sYxUHqyIZTh2vFeyUd+Ph48EzLdmDqZt9zUOek/tvdTsUN3pIj1hYl/1t9a7jIkqfhOP+9gyYwRo7boRQkviLL/W4XxoN+CFyIoKk1XTRsdrLw5zrxZkZDvJDnxNXPTVERC3vZNBOLLmb0i0+qF3tcQDFrVjl9a++DFUv6xB9zJ9R1sUZqQEBHL4A+8hrWa2JBmL7B3+GdZLHrXpXw0sGVtsRxJFFR19a/6ECizvMRM2RzcDgtWmtbtzFeGHvywr2zPKIfQMv2CArkzdtFYHsrVX4QxVsB4xtobjR4F2GXYAMlSc4eV1WrScYU1FUjhnwUa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit a7694ff11aa9 ("vmscan: don't bother with debugfs_real_fops()")
started using debugfs_get_aux_num() to distinguish between the RW
"lru_gen" and the RO "lru_gen_full" file [1].

Willy reported the inverted polarity [2] and Al fixed it up in [3].

However, the patch in [1] was applied. Hence, fix this up accordingly.

Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://lore.kernel.org/all/20250704040720.GP1880847@ZenIV/ [1]
Link: https://lore.kernel.org/all/aGZu3Z730FQtqxsE@casper.infradead.org/ [2]
Link: https://lore.kernel.org/all/20250704040720.GP1880847@ZenIV/ [3]
Fixes: a7694ff11aa9 ("vmscan: don't bother with debugfs_real_fops()")
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
---
 mm/vmscan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0e661672cbb9..27c70848c0a0 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5756,9 +5756,9 @@ static int __init init_lru_gen(void)
 	if (sysfs_create_group(mm_kobj, &lru_gen_attr_group))
 		pr_err("lru_gen: failed to create sysfs group\n");
 
-	debugfs_create_file_aux_num("lru_gen", 0644, NULL, NULL, 1,
+	debugfs_create_file_aux_num("lru_gen", 0644, NULL, NULL, false,
 				    &lru_gen_rw_fops);
-	debugfs_create_file_aux_num("lru_gen_full", 0444, NULL, NULL, 0,
+	debugfs_create_file_aux_num("lru_gen_full", 0444, NULL, NULL, true,
 				    &lru_gen_ro_fops);
 
 	return 0;

base-commit: 51a486feac0ca002bee6429f03da0a6c206d0dc5
-- 
2.50.0


