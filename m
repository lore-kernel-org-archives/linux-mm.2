Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF94C9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:10:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 915F46B0096; Mon, 12 Jan 2026 10:10:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80D156B0098; Mon, 12 Jan 2026 10:10:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6CE396B0099; Mon, 12 Jan 2026 10:10:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5D4BE6B0096
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:10:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1DAE21A047B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:32 +0000 (UTC)
X-FDA: 84323648304.10.AC0196D
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf28.hostedemail.com (Postfix) with ESMTP id BD723C0013
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TQ+OIovS;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230630;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vQetHPompGRD/vSLFdydHefEXe7bm38DTvvWqRPqm0=;
	b=k9qkVzJ4lXX/7rgLYCoWcZ/i4grs/RH6o5S3BWwh2pjfYPN6kZ7jAxeJEVhMp+nd30dLJe
	fKzpicYaWDBbWANpGngTShdCGwv53sEGe/cntTva2MszWJxeJnqUTAGopkHqr9V/hcsNAS
	9/IyOJjYwYwbgohakoboIUetGqfTevo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TQ+OIovS;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230630; a=rsa-sha256;
	cv=none;
	b=HAPKSf4NSHWNbZCtNqWcRHsuIcmKXjnK+tJIIh6QbxRg75fxmFVG8TGcNnOkLO8UQOssnz
	9K/Ylxi4jCt+ab8aABwqNOgW6bmxIKzt4mOqukYsl+8g+bob5MUZaZdFtSDI0iP9HyIJuk
	Jq+kM7CmoJ0S8xR1Mu+Lp1+nR4twR3Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/vQetHPompGRD/vSLFdydHefEXe7bm38DTvvWqRPqm0=;
	b=TQ+OIovSjPDeK02j/5jZXJJVpFGDT1gDna2/4WYNAC4JbOjMVbyW27ylRqeb7Bes9x+xXxOY/
	EaNKgjeRZmP/3iaCq4zsOBbDgymBRjKGagyXXg8KbKc9gHqa9Oeh3sW1LcuBMdlPadiJOEwlEuH
	r7nuvnAMYCeJDiwkdPx7u1A=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqbLg0Wscz1T4Ff;
	Mon, 12 Jan 2026 23:06:35 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 71F754036C;
	Mon, 12 Jan 2026 23:10:25 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 23:10:24 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 5/5] mm: hugetlb_cma: mark hugetlb_cma{_only} as __ro_after_init
Date: Mon, 12 Jan 2026 23:09:54 +0800
Message-ID: <20260112150954.1802953-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: BD723C0013
X-Stat-Signature: 4np7gj33pp6i1ikjxncb4enh8busebta
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768230629-87095
X-HE-Meta: U2FsdGVkX1/tTlHDQk40zl3xcfoNevAqOAjh29Jdw+VXAxOxwmfS2DLF9c7OqjGmbBeVIuTmkFdHyR0vDm92FvInOnxhwFiqSFhsFjP5HWXXl4OLKA6XaINmLHPS/z3mnryepcCqg8b7dIS/4rTNFN0Gd1Jv2q0vCrJFmgfy+EJSzGKqQLHzdWNKLugy53gMthnFKyAXLy/Evm6taIAK4i/PYYSYXW/xUzAkzw+fpFAsfkr9ebmnY1UAPFbdmTMFf12KWPPggmPaDkuctgVWmsCzf7xrEHWNvfgOAmytcVrr7McA949tdvw71CE5c0B/XJBbMnXHWXUSW/ayPkq58y1JEFm4WqNGBQg9Rs/XVnQCMab+aFCevqom/Z6HjjTsVaMitQzsExhD+B1vGco4Ece1BBl4GZGpmSmnFTc5nVY9611eN2zOHxcXj7qDo1CVY24xXpR9nlJGUkCaJVmBzZsMhjMiTkbasaCZEBw8dSQb8qyXudyLd2hY9ES7Puo7cUEw1QdHAdCCAZ2TVXkG8JzYKREVnu+9a4/084dNgQF24q0HnnXL+96t68ufC1B5HTiLBgmNlYF3MmgD++f17qCMsRTl54GtGUJ6Y98DJ53lyz8xp8fIFIx+OHukScf3z9nxc0IUJaNdOG43fHhTQHKlriNAaM35Q/LIs/dHZuygY+zAPepUviIma0LtvLj11zCDcu+XM86+vyDBJqoXtgMYv7PMIlekr55mm2Y2j7IWF7rvpGy2YaV89WSEWIkTJOjBCigYqvISIar3A8U83HzoUyvMiLrPD9HlvYvSxcxyfdNv4+tkC6nWscQOlpU7hnP/sMAgsMIElJ0eM36lgooDTpTCVkjBXeEMngFp+zWtQQFZOdf7ahHItHypwkC3YdpbwKl1tz4ekiZlk2i5VDRt4PJasiF3bGUZGZ4gWvgV8GppwIEHxd3QXhfRCqM9Nq6N9pe9UePLoojIPof
 xNtKY/sV
 bs3jytpH6yYKFJFh8FCygpdkyWBe9ZvjbdAq2QtuZpDMMUfdt3+De+cCs4XCJXvhOQAS/UPXMr2UQ4bpDvjtacFqR/JgaRedtAcp2d7OT2KZ4px1EFNDt91BVudPoHu+EaILIahYGzBmZMUiBAZze0GJ+Rb+5ypsQPmR9EQ7e1mw69C2DZbpnEcssOe2l7fPEhhBuMf3M7XGrg+FDqHl6+1mHrtHWNuuiqnR7FBGlSsjaW0PII0SbN7bIaE1jAEDaIptII5hgBDfQT72w5vE9jTEvC1LfseyjS9gA9VgQxR4h4xTRufGkT+1H/rIwradZXrreX8A7m55cYggnhbymXE355WozksQU89vesEd+jSDzQ2KLl2lB6BVhoA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The hugetlb_cma and hugetlb_cma_only are initialized once during
init and never changed.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb_cma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index d8fa93825992..f83ae4998990 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -13,9 +13,9 @@
 #include "hugetlb_cma.h"
 
 
-static struct cma *hugetlb_cma[MAX_NUMNODES];
+static struct cma *hugetlb_cma[MAX_NUMNODES] __ro_after_init;
 static unsigned long hugetlb_cma_size_in_node[MAX_NUMNODES] __initdata;
-static bool hugetlb_cma_only;
+static bool hugetlb_cma_only __ro_after_init;
 static unsigned long hugetlb_cma_size __ro_after_init;
 
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
-- 
2.27.0


