Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 537C7C61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 11:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407BD6B0088; Mon, 31 Aug 2026 07:17:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DF816B0098; Mon, 31 Aug 2026 07:17:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31CBA6B0099; Mon, 31 Aug 2026 07:17:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 14C426B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 07:17:59 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9817C140494
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:17:58 +0000 (UTC)
X-FDA: 85161315036.06.CAD74BC
Received: from va-1-115.ptr.blmpb.com (va-1-115.ptr.blmpb.com [209.127.230.115])
	by imf31.hostedemail.com (Postfix) with ESMTP id 49D312000C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:17:56 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=cahwJPC8;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788175076;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sk7m5/tft/ydmLxoPchPzp52VQWS3uxvgVEj6+c0Gmk=;
	b=J4WSx3t9xXN/ub0XAdLWCpH9hQaWaSZ+NF3KRV/S8CY7s9ZOo/HIBlhqhUda6SUnvbF347
	ECNAFyQondE1gYKgnLT//4b/Nkq/rrDGvCeqkACCLU/dcrJJE/k2SnSz63/qVijeQPqaE2
	VUqDaM1Q+7QMallp9WA7RdS/SviDv0c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788175076;
	b=LdDuhJWrBJoGQYYaAgo+GcJXKFksbO71TstOjwORp23TyzWrHplZFqsZlOfp6NdmUHqibD
	YkHfMG4/Q+8FZExfwAdWqFK4X2StszL30aka85cUyux41t5M+1CT1GkbGiTw14eyB1k9++
	Ao3LEreCO9UCtVU2MoDCDutTUcbSDoM=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=cahwJPC8;
	spf=pass (imf31.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.115 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1788175071; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=sk7m5/tft/ydmLxoPchPzp52VQWS3uxvgVEj6+c0Gmk=;
 b=cahwJPC8yhwEKN/G30w4+TGWKh1rlYTtEwLnyaIiBYtyoJd2zPvhs08amO+XVusVPW+TSO
 DBVSSJOFyC7uGOeFje2QGOZjUHYc2D7jZcOmJDbrLyi81CcIU+/vrdTXQ1gf8wQrmhnciB
 nr3km+POkgcMbOog3Qj/CWZFXuIy3n/UJkELyl+tBnRpNBaVAt5ke1rAVDDLD+MCsrMz76
 soRy0PoE1c3dO+Zk3y4IgCSsNlBWwmSzsaccRzdIcblt4geR+1KfhI/udj8mXUsGn8Yvyg
 cJGoiqaI2MtrJA5spGrfakitPfofjDaqxdvoSMox3ZVFwUoJepOXQTWNOISZkA==
Message-Id: <20260831111638.76012-2-lizhe.67@bytedance.com>
Mime-Version: 1.0
To: <akpm@linux-foundation.org>, <apopple@nvidia.com>, <arnd@arndb.de>, 
	<balbirs@nvidia.com>, <bp@alien8.de>, <dave.hansen@linux.intel.com>, 
	<david@kernel.org>, <kees@kernel.org>, <mingo@redhat.com>, 
	<muchun.song@linux.dev>, <rppt@kernel.org>, <tglx@kernel.org>
X-Lms-Return-Path: <lba+26a9562dd+e31eef+kvack.org+lizhe.67@bytedance.com>
References: <20260831111638.76012-1-lizhe.67@bytedance.com>
Content-Transfer-Encoding: 7bit
In-Reply-To: <20260831111638.76012-1-lizhe.67@bytedance.com>
Subject: [PATCH v11 1/7] mm: fix stale ZONE_DEVICE refcount comment
X-Mailer: git-send-email 2.45.2
Content-Type: text/plain; charset=UTF-8
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Date: Mon, 31 Aug 2026 19:16:32 +0800
Cc: <linux-arch@vger.kernel.org>, <linux-hardening@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <x86@kernel.org>, 
	<lizhe.67@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 49D312000C
X-Stat-Signature: zpyckr6xcbx76tb575iyag95455akp5b
X-HE-Tag: 1788175076-916857
X-HE-Meta: U2FsdGVkX1/5PiQteXxRRIrcZWh9zIawKE9Jwv76bXPgWr58K5uLl6aFlu223AA+WEtrZ4+4kWLM+LYsGqOKizQb3dpZiIaH9xYsulSq7Rc6wJLgUvUtb+Fh0TQrEqvMTSN12WHCL2R/3VH+J+Zqki849ZkHfrN08vv5hZkb8U4GX7UYVuLEL00ELD5MSO+LW5Znj/29nULRjNC3yhvvrLml4j5rP1q3v/Wh1msi+FDP34CPhku0Q7Oq+YuhnXgmoJQQYXg/kIM/QixztBscM0/f41CXJr2Mv+PsFMdxdRPQUTdeseb85suWJNZZ7Yt4REAYWXSe/waA7XRfd1FWiO2/5CVHI/5c/54TO1jKS84yu/u6Ru11YHSP+pwz9uUC+B8dA5FITQH975lDPameTdkKUxgWQbUv2CWAhQ8GrQ/udqu9wE/aeUtMkS5nu4R6JJNpApXtLCDRrpPAXsrC9K7K676HvKTdYsiJV/MTLOBycNZaIXNcS7xLhMN7iNDxN6d+F1iq+u4FW2wa6Tnq4A8WMql8sGPbSY7Is5kNoUGPstxkUVgP9yKBNolDaHx98hzsnuFqzjcbzlcL2jFDONHng7wBTUxpoY5DfIg/tc4Y/hx+dLLiXQ4TCEyo51YPIpqfT6gvtEndKxNZNElKSelK76CKZSndZL0vFEr0mdVq9stN1PhGZ6xdbpA/WNAilcLwZBRCGEfransQK8XIgb2xphILcmnhPVRQj45yYk2XYSr3uYZWnGxUL7vu5HaN8zZSrIQ37gcA2vV2Oa9zOH9qwPuXSlYAcrm1rrDY/+7gLtSIkOR429IhbU2UrjU6nFuvGralFJtGplOfexAdOlyvJxF+C1DNprKmolFOVbDtjkv9t7CVg0nRI9UQoNp9XKASRQzzSa0t3bgHvADDvaXKK+OR9Rr03mabYc2KVAVVNGOdQW1UdpFqXiGVsY1JM17BthvYe+8a4zbTHO8
 mBWor1QX
 TbMztLhKkwI8JlJ+wXx/3UQWhbamereCLRTIFVItjq1SyOhMcoqDHA4B7yyufH7DE0gS6EOS6sC4Hq7GybLKIrmmwOT1WQUyHJhe97KMhGiPdKByQGinl1KQem/E3mj0Lt2HnFEe84dgzdlkVWkZybqeOOCnMpxcfwrbmjVoczcqPq8E8X+8BdniEcw2UCdYanRNPLieZHhPApVM3xzGio9yIpQXbbipVBW2jwSab++Wqd3nS1KgdH4k9ZVBMhTONe7Fe4A0leV8ZQJ8mJqsBTYM7bH4bS99YU5ZVtrCR4w1fyTrMF+zgiMQO++GgALZFPXAicx2Q9e4Vb/lQ0N1Q0ZcfhKk+6oHj3naU
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comment in __init_zone_device_page() still uses the old
MEMORY_TYPE_* names and implies that FS_DAX pages regain a
refcount of 1 in the free path. That no longer matches the code.

Update the comment to describe the current policy correctly:
MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free path,
while the remaining ZONE_DEVICE types start from 0 here and raise the
count again when the allocator or driver hands the page out.

No functional change intended.

Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Alistair Popple <apopple@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 mm/mm_init.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1533aebafb68..8f73d5850db2 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1000,13 +1000,9 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
 	page->zone_device_data = NULL;
 
 	/*
-	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
-	 * directly to the driver page allocator which will set the page count
-	 * to 1 when allocating the page.
-	 *
-	 * MEMORY_TYPE_GENERIC and MEMORY_TYPE_FS_DAX pages automatically have
-	 * their refcount reset to one whenever they are freed (ie. after
-	 * their refcount drops to 0).
+	 * MEMORY_DEVICE_GENERIC pages regain a refcount of 1 in the free
+	 * path. The remaining ZONE_DEVICE types start from 0 here and raise
+	 * the count again when the allocator or driver hands the page out.
 	 */
 	switch (pgmap->type) {
 	case MEMORY_DEVICE_FS_DAX:
-- 
2.20.1

