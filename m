Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62E53606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 18:54:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HDdFSan7
Received: by kanga.kvack.org (Postfix)
	id 088B06B05C4; Mon, 23 Nov 2026 13:53:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03B4F6B05C6; Mon, 23 Nov 2026 13:53:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFA716B05C4; Mon, 23 Nov 2026 13:53:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AF22D6B05C4
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 13:53:41 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8AF9A120974
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:40 +0000 (UTC)
X-FDA: 85467282600.03.F1A539A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B9AE16000E
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 18:53:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HDdFSan7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795460018;
	b=W8CoMxPikhiZVE8hrHU+hAwJHmEn+ZrvDnoiVPi7M4qHlnMKZARL4Em1pxotkkVpG1khOK
	sgfG1XWmHRelmZJo5WcKDiXs0xyPb2qm44LVGpDQEvv9Nzk/v6VubP2Isn09v9gzGiS3NX
	FbxLxmI8zpIYb9hkQVr5k8Mmlf80tEY=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795460018;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Fy4iqtyOKVldxfrRoRe9ktEnWMk4sYM46noWj6UrSRw=;
	b=3OuBpuebUtzV0L233QbDU0qWBn95vkBKRQxt6O36yMxEgS2MhJSGmltjnH4rEhPuMeaBPQ
	RQW/sla5685iCGYEQ8cgdqf1vWjR5CxWVf8pj5Y5rSDj5xh/lTyFZuGw6jHigfUKWte9Jo
	+hyJVLzh9aGrXvXYF7tqgAO6DBPR2wM=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HDdFSan7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf08.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1C0E062426;
	Mon, 23 Nov 2026 18:53:38 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795460017;
	b=Jjom/3pXj9tQ4Zp3RY6f1pRLFSFi1elnVZHOHB16wOhnCgzztlKtRhds8GqKWoTbFEh7
	 FfyFpocQ8gnZXG11ZMWH0dKXcBRs+B1NQ6x2dOwzudNvipDxD8r8ORv8sY7alkGQsyRaM
	 xHw7fmarnOqgfcJrJh5iXpORnzg+WlxaaWDqqPQuLaHlg7QE7eXZXb63d8pWM75CGE6Sp
	 GNNeQk6qJOA3RbjOAgLudIryPmgPkgzyLuIoEbtWmyEVWVhWRBvKFAX9aWHCev5dG353a
	 dZhr6uCSMMdmGgTpiUo9Z9jGuUt9ox/7HZaVYiXqP0SREdR+Wo9EpqYacfrovf81V5Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795460017;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=Fy4iqtyOKVldxfrRoRe9ktEnWMk4sYM46noWj6UrSRw=;
	b=tRGxDVjH8MG4m8kIQshdLIlAYSkuobghJlZyhEOJRFnchk5NMEm1ZuL+cNRaBTMSHB+v
	 ZzCrqNeCOC9oL8+eBJwOhx5obY4uuaAeU24F9RWRSYLzunqyjXg4tct3cb7r6Nv2595Tj
	 9S9chC2aPBehcCUuFKQ4N/spZVS3zNJGiBAy4ewHWy0TDb0XPcOgb9ypo3JDQQXnDot03
	 WIAOMrgCMO5I/oNHdWaAcWHsfaGdj/pXSTgOpf0HkhREeaAqU0yLHhJ1bh29S4NfVSzot
	 NnuU3VKDVDIip+n9LhxM/AuLw3QoX8Lv6ZN4FfLkFcTs3nFUSIZaEz2cYcHjoHpczWw==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 05F841F00A01;
	Mon, 23 Nov 2026 18:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795460017;
	bh=Fy4iqtyOKVldxfrRoRe9ktEnWMk4sYM46noWj6UrSRw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=HDdFSan784ZY1na1QkuZrD95OJiWZSBxW9gq0IStIhqhG0yjn0dpGPLLGatoic2DP
	 Py7ZCCqX5utH+eeLqYyOdGxXmcWhNWPFhzmDDMoHwmXyzb0BPwiitlD84JT8t3ocM9
	 3fF85JwREouTYeQn0DrSMgA+MCpvbj5GgMG6chRw/nS+zWCb1B31mtQjRv//RVYdwI
	 Y8dUXCa2xCVsKHSNpuYZfMD1ckgK1ZXwVEP/viCzLZZe47PMjmHamNIAE5XE/EVBqF
	 kfkLTE6Xb2npiprm7It0dl0ROQvEbq60eDfb/z8FrZooitk5uC4vvYoTKkeoIJTlTK
	 Vzw7roGeXf40w==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 7F6304C659;
	Mon, 23 Nov 2026 18:53:01 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 24 Nov 2026 02:53:04 +0800
Subject: [PATCH v6 12/18] mm/damon: convert to LRU refs based operations
 for MGLRU
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261124-mglru-fg-v6-12-8ffea39934a6@tencent.com>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
In-Reply-To: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Zi Yan <ziy@nvidia.com>, Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Tianyi Chen <hi@tychen.cc>, Kairui Song <kasong@tencent.com>, 
 Ridong Chen <ridong.chen@linux.dev>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795459977; l=1016;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=ofT3DkXyC3h7ptCQPZjIa/LhrvPGmBU9+3gfY2rFnss=;
 b=o6eHIETcJuwaJUc97SH5F7SQ/kGVMK/yHu942m9yR9l+9EVkcSYS7fRXRI9yRCIPDg6wTwp7x
 /7/d/ERJJiaCtmPfVXmihoibf7n0JZz3OuQL/SSmum1iHaht3PhdLNZ
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: 7B9AE16000E
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 6u3uwgmanu6nkexo9j5yhqd1tybhf1qy
X-HE-Tag: 1795460018-299653
X-HE-Meta: U2FsdGVkX1+U/+5S0aSLwxzetlpVibHSd9kmIfczxPlSfuhIEaRtajDv+YdBHzeiP6o5j1twcUAVJZCo9DnH8VRkm9iCvA+tQ0p//eolnfkJoDFW5xtLXIYyf/Dz7O0miq2qyywCEU+x/6oPchyT+BG7Z48ORkyYuRAv8l9zYdTx1rF6CHaEZzQDz1mphM0+sRyKq010Xs4Lena/TTGpDdQMINtt65gW0AGQiNc2DFZ55Zh192IFvkhpgHqAVL0DBuU5fASyOFlrUtUmsstCn9i3ArINQ6mFvkXBxuEuBvZ46lVQjpeJxyazBS7NoWKY0Z1YkPrC3qYm+vpfwleO+ZE78FHaOVFQJIGUm7z1K6lTjBi8xMEAtrV0kiA71VN2YPa949+MPw0JafPakL4dCQx8qK27o6A2c/M2HCqjjmUn2L/+L8P0oqoTq/eOAtrfVOSUJQkJ1f+lG0mA9fkYIUn/1fHLclBABPOa0IEsFZXInhOz1ubsMr6Cy4Qr20YPTj4pV5CsDvysqa9C8iER3TMKwAiavHplR9T7/eSpgmCaQpvy5c4WJmUlug/ptv/Ghj2YZ+lzE+Ynij/n3t0d2/+T+PGYva1hMgT1RVnkLuxFDjy1yQtqh44WENqGgSWk2z378YfazHW2W/+CO1ziJs6coYugiacpLy2QUzNv4wV+/wVYyTLGkzQ6JcgV3qDpaqGhPSFEbk6hZl5h/wWB8G4EnZixmTp+VJK5Nfqo1Iy+SgbVPnccEeyDUK4s3ocatAqzSABrN5VAFLCyqmakSBUakPX0A9ymgmPa9El5vO/atG4jqkviHF2csZTtjit+aVRKhTCQcH6hxWLzxJ6n/Etu8rM9pFYICY60u/w/YDnJTXBweV3KSDIFHB+YUjlx4VP3UQK8FJ/pfYj4xlwDaZPv2KTYcQ3qtjMabCGDYR58lT+sALjPp4thWKF+oyH5uXwtylKs2hmDR7SfmX/
 4T6XdwYC
 s/OgCk9Q/j3eEeki57RIjyJGDSfRfTyGZLvc6JV0aedyXHNimWbdgm6jApQS1go8siXhBb2L8EcDzSa950VieP3ef6eMEfAmdleWbVQj6+wmoG529uSpCo22DmEQbOHC1eczQy7Do4lEL3yf/3XZCSH33wUGxDeeUw6N8V/GufKNOdkyMPTyvfanYUlQNqJK15BBsyX7iKy3qCIDjS2824iOzWdXgi3bGXwf6sLiriVoIBUoHQk6sz5/vGpVtmGJN0WSCb40gVna5Q/VZkC0c66z5IUF4ySGiddRG2BjVBp6iqf1rU3ftHDhpfy3QlgvpLPMLT7KJGohDRrDhTh5A1nidJkre3OJ7iEN7NRef+2F+/3saS5P9lrbj1co4o9lI2xYCahK+iUBz9+WJqGTGzI6KHnVJxV93p/AcmgEKcYSLwFyKJO2mT1h5TcTk37khK5JOw7Ix9MdIYKi3l3QU8GvLNUe7Xm/lIMt+8EdAGp/f7rx9RQO+ctQbR7v0hTzmCFnZ4u0dZo6zumqQGXqC14wih7E5dXYyPdkAmHi+sE+S1ZBI0TWzqZNGdRJdQYfjAUhvNdkQrAVINJsF3YihH5sSOeBYKcEEVuC2H4OAVrZ3c8aGjDYKKNvnZYFhXAFvnmaJ97dgB4rl6TuploEo4ADougM5BXHtobZmOjU14rJmAvABFo/EfHHWEeI0NwGdWEmFyABf+kYiS7t8f4xtJVx2VdXA4MLimZcfDztZcKp1mUDVSt7Gwg6WcBOgaP3UmpQUP+6kjsXOojow8bidAWdZcMTcCA+BcWy50qJQP34WA0qJRcraX2TJDwaPVXubnS9sL1+YIya1u7BxAuEikj36cHrRNLzS9LmxWlgwaUZNx+4lQG1p8uuV/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Kairui Song <kasong@tencent.com>

damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
corrupts the folio's refs count. That flag is now
bit 0 of the count (LRU_REFS_FLAGS).

Reset the count instead under MGLRU.

Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
Tested-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/damon/paddr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index e89cb14ee17b..411e1d557ba3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -279,7 +279,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		/* The region is cold, better drop the hotness info. */
+		folio_clear_lru_refs(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;

-- 
2.56.1



