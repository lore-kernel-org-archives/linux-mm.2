Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F70ECA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 08:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF6A98E007E; Fri, 22 Aug 2025 04:23:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA6738E0056; Fri, 22 Aug 2025 04:23:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96F228E007E; Fri, 22 Aug 2025 04:23:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 826688E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 04:23:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F37415A3F9
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:40 +0000 (UTC)
X-FDA: 83803704600.09.CC812F6
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf28.hostedemail.com (Postfix) with ESMTP id 46B6AC0015
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 08:23:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Mo3SXVoQ;
	spf=pass (imf28.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755851019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ORwxJimgFatk1HZTZhUcztwakbaTy7mci6/DafCfjsE=;
	b=ukx7DsiAceXjs5muQuaa3QLKrDyg5I3+CYTG8VwVMA0IC+CKdl8O05NnTdwImAqZyoyH7G
	ej4+YrhmVUFmJeseZTkSgmkLe0x95QCscRZHHcfHzXVqXep0rfUvPdf0W3TOCY5HwC8Wla
	f/1pZVNR8/WIrmtud/+WG9sE/kcj9RE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=Mo3SXVoQ;
	spf=pass (imf28.hostedemail.com: domain of usama.anjum@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=usama.anjum@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755851019; a=rsa-sha256;
	cv=none;
	b=BiERjl/mZME/v2hrpcuOM74jG/+yIIg7hpqt2jLMuLQ2eVW7SJPxds/H45/URnksv3ELrT
	BvMUME2bVXK3N784eOna1XhSIU/QXtoSJAD8LS44UT4tlBwj2PzUbsLe4PJlrFYH8jyNO0
	0EySFWwHxRTJYycG+DOtBklmOLqpl+I=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1755851017;
	bh=0jRkmhz63wy9fDzRoFQ6jLTDJnLHcryUWGPCMeOuRPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mo3SXVoQX00rreJeQtrS4eVBtHuxZoC8Om/y8ytIGq/Hm+AIS2sawTRGxPwOS96W9
	 wNBFW/mw/O9sWy7szdGOw8HycqUR4gcMMkN/DhV3XbwxRqMXICTXebJxJwdq3VP+iZ
	 Sh1f3k96yvxyiCKRHOcXjOl+Dme79Uf7J+1m+/8oHUvKVS+3YI/N5WHO7s7M+6Vn2B
	 t1cOTldSFakNHnWURgZ7YMM+uFdHevBi57TnfgZ6vNWu+h4NTP4B5sDG6RZCUviId/
	 hncIEU2TG1qFkdVd3SZCasIs8VCwuDleksbR6kr2GDk1WkZZh9Z3+dLxBd2dyLL/5u
	 +GqkA+lOGfJPQ==
Received: from mt.tail9873f4.ts.net (unknown [103.151.43.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: usama.anjum)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 2A30817E0458;
	Fri, 22 Aug 2025 10:23:33 +0200 (CEST)
From: Muhammad Usama Anjum <usama.anjum@collabora.com>
To: Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Leon Romanovsky <leon@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	kevin.brodsky@arm.com
Cc: Muhammad Usama Anjum <usama.anjum@collabora.com>,
	kernel@collabora.com
Subject: [PATCH v3 7/8] selftests/mm: mark variable unused with macro
Date: Fri, 22 Aug 2025 13:21:04 +0500
Message-ID: <20250822082145.4145617-8-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.47.2
In-Reply-To: <20250822082145.4145617-1-usama.anjum@collabora.com>
References: <20250822082145.4145617-1-usama.anjum@collabora.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 46B6AC0015
X-Rspam-User: 
X-Stat-Signature: m51kxd3d1n8dnbzhoezxqwyrjr6sc9a5
X-Rspamd-Server: rspam09
X-HE-Tag: 1755851019-611273
X-HE-Meta: U2FsdGVkX19yDNjX4/e+fSFd/nmRPmpnqUXbKJDLWWw6/rFwzY/Un3hwst2U7687quRKj2mj0/JI3q5UMrVR8n/4PZ79/vBM1r+ARpDbznpzrlYFSz5urW7xt4sztp1hW6/DRxehugYesTbvo1i2+W5zrLGdSkveHGMeXs0FFa/0FtqiCPnKkhagS6xcLd0ja+o/DmhI4meAlA7PIV5jaPBK6iJIwXsPq7B2kioCpY4EDdXI8k6PH7EzWgCWardbjTWUFODuWKnKfddY+UjiTmQvGCqLS5R62TgGUrIy6QGJU8tsFZR+W4cosiWH7Y3sGtgfBqH3Um1gnQBunR/Kfb73ZGfEMgAY3qxjUnSUILTE+sAC+lHW3XrhGInPBXGzqN02aXO1rGuOn4dr2l/68ggLgWr2fyeTqx5dv7pyShNFVTbrCWGIOmMehtej9L7VWue+0zbxQA9xD0v2B00ZEX4mjJRbRWkhcDMi6QkiNWdPODpvs6+Ay0+fIIo4i302/juM0w+suMWYEfzIbIMCWlM9/anfb3YKxXK5OfCuIoOgGxg+OQdKKfZcdEknMEkLOsi69g6UUrICk6iNS9lk81/n6mFTRF+Jb95rni0p+ZplYKwi5x7vwssZiiZu8ZLpfQfwZAfXuOKduhuymcjA2Rgsb42Yk7VWd5Ysx5RmVCcRjiAOlKisWnxyTqjQAyA995S2lXSd+PlgIoDzH1kq4z05FfD4Nq5EllvfzsWqhSCyeKcc1lc4miZ7BN/IqckmulbbTxp5fpS88V6evEVUHRVCinh5PkTrs+DeEI7qC5kkuMLP28O2v6sm4WZiucuwzN+cuJqIF3F4NpPahVwt0NBb4bkZFECpJJKcK0lmWxKdp1xEq46HXhdAFEP/vUkcDrM5L2BNGhfvg08hFfe0iwBh27OUmtDBgVqi+PI1WqPaN0ZRDUy5Le+U3P3bYjELfC1SMYppsjPpZTl9jL1
 IPpwBEoZ
 HZhkoQ1cvbqA28Bd7GO3Sd/GT2MqHO7UJnfx76tZb3Em6rslg0GNt6C02TWI+Ofus2ZQ37KUAm4Xfc0sTWa4jxxUOnKAqYDg1IZFG3HBUGoubIbjeWPRb6Ob3stBBza8fdSmN9XYQjYnDQ/GxtHqZlaw5g7G6R/H6j41KrmzMEZRHHibQOFTVpqdAvbN+9X3iFGdajZ211VRD+8dxhdNgC1IGoeFOnX3OddGQXzPsmed0d9LC0gPFFZwUAHKO/BdBGyq1DBUP8cUBag4hCPA6nuUiIhcf1vRgDiG9nKKdv/HHVL0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use __always_unused macro instead of raw compiler attribute.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
Changes since v2:
- Introduced in v2
---
 tools/testing/selftests/mm/protection_keys.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/protection_keys.c b/tools/testing/selftests/mm/protection_keys.c
index 6281d4c61b50e..967181bcb4120 100644
--- a/tools/testing/selftests/mm/protection_keys.c
+++ b/tools/testing/selftests/mm/protection_keys.c
@@ -1302,7 +1302,7 @@ static void test_mprotect_with_pkey_0(int *ptr, u16 pkey)
 
 static void test_ptrace_of_child(int *ptr, u16 pkey)
 {
-	__attribute__((__unused__)) int peek_result;
+	int __always_unused peek_result;
 	pid_t child_pid;
 	void *ignored = 0;
 	long ret;
-- 
2.47.2


