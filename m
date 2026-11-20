Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC58C606CD15
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KHgIeGfQ
Received: by kanga.kvack.org (Postfix)
	id 25B6E6B05C9; Fri, 20 Nov 2026 13:10:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20D706B05CA; Fri, 20 Nov 2026 13:10:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0100C6B05CB; Fri, 20 Nov 2026 13:10:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE2D76B05C9
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:20 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C50D16012B
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:20 +0000 (UTC)
X-FDA: 85456287000.23.ADA3352
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1EB1B20011
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:17 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHgIeGfQ;
	spf=pass (imf03.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198218;
	b=UFRwry6V+HLVliBnPlBqE6ntN1ud/zegyvmsCzVpnEQEcCWglYqISIog6yiScXqiteCLXd
	mBaIo6EL681n1+g4oByDieTFkWkOx4g43xKrQJOXxqF0s35gyuxJfM0L8evcd5C6DkY+EU
	V7P2o2xwXud0xa96wMnRoLk5rLw2gjE=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198218;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T4U9voPWRkqEb5e9dPQUgRiRcqSJxhhWoKa+JQ6JU+w=;
	b=sn8/8RE0SNnttXo1Y56jtC7IpiyK9CZ7/+0RMYv2POkK0Z7jFMXlDazlOpdYEWfKVp9cH1
	UnGT+kHJoGkOi5qykWsLeur2sivGgy52u0uS5N8MexEY3NRgTW90b5yqsD+yPV76h1yxdB
	373TrcKvRbW6TV7Go+cyDz642piDiyo=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KHgIeGfQ;
	spf=pass (imf03.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1")
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6837B40706;
	Fri, 20 Nov 2026 18:10:17 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198217;
	b=VzzXs4Unhmd59VkXB34xrlNKBcVKUYySJHDlVHAUjK4XTMFIZ0uvw+QPbfL5iI0KO2P+
	 RrG7+YkzE97yTDEbf1Mxicxj6GwNVDsD/CgoRIPvP0sCQ/womVrnS+fBWeOTqtJliIWIv
	 uk+Mb7at5O/xo7btqVunZNdwuNzKXD1CtnzlAVYKLbCs6Th4a9BLqZWEZn8Tu5/M+dkkZ
	 /sLrkdfLY3YnIWnoV11zE0jGEhGjxZkJYR8guiZ7qLkXo7E7HMXFcCyQHqD1lpDZe+8XJ
	 CeJ34LU8LUV8o9C8SGzrnQp9WgjiOAmjLkVN9trt+X4OBZ7EyrNwB1EociJghEf7L8g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198217;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=T4U9voPWRkqEb5e9dPQUgRiRcqSJxhhWoKa+JQ6JU+w=;
	b=LFBVvmzMljZEcROVBnhw/gtb8p0mepkY4A4TekQkQZMOCZMcDHisPXSrpOJ6lbYmpTE+
	 F/QzFlwaSm66F8FTLK7pJmn115PpO/2E8UVRdgLW6SBvYH8AUmQSmjR9HeUrc5GXtCaFf
	 NuJ6eLVKBpTCmQh+KIk18C8edLf2uAEoQV60ZVb+gXE51WgTAhcE2/eBqNq+Kf8/JfMfo
	 xNXwLQerh8Qe7vJpSOKtEdsoyCcpZRJivWXurb5KPwyAZDU05EA1h5hR7yT/lRNakkCWm
	 me5F1QIokMtodmq+G3572lrNR0B1TvanKGTISqpZzi5F6a/nyYuQl9yazWzN2L4ZsAA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 728F51F0093C;
	Fri, 20 Nov 2026 18:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198217;
	bh=T4U9voPWRkqEb5e9dPQUgRiRcqSJxhhWoKa+JQ6JU+w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=KHgIeGfQUZAht/m7Mbs1p3qQRbp676OxDWiOAha0uP8Z89IoKR/9fYd6DDVCDcuOk
	 0V53k4Och2A97MJK6AKqhKzf6oCqhgJq3milfnQuKrox7ZXvDxCXozY1DpTI51eJTS
	 CD7cmTVv2kJ8TPrrRRhJaMr7k6ATIK15TMvWtfV6JpogL0PRkwLPSSuHbhMHJ+H3Q8
	 ovR2EkVbaQ/qcjaW/FUUjb9elGJVWDFvYrHiGuaOCTAnFhEL9UzxORghHm5mMXh3cd
	 v4ttRHd5NIzHdNojaUS9grnDh7sn7xiB6jdMMpNI3fyZqjtDqYLqTaW3RDTOMDvfy1
	 P844JaKhvrUsQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id DDA634B921;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:15 -0500
Subject: [PATCH 24/60] mm/madvise: restrict reclaim advice to common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-24-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198153; l=1781;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=/55J316jzS1Wh7mQFy6gzCQoU7Eiv7k39WwzIyNwWco=;
 b=s8Msb/DrpA/5wN3ASvagAuczkPPgA4E++0gfH202AUo7xPM8n5yupjDRsPxxFkVKilzb+fYxT
 xtWsWL7f8LdCntXyjxSr/jqmZ85TrM6YA0zmgNaeq1zdsJM3IBJCiUJ
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 1EB1B20011
X-Stat-Signature: 77q84ds3whykfm5geqc7tfojrahtieyr
X-Rspam-User:
X-HE-Tag: 1795198217-625608
X-HE-Meta: U2FsdGVkX1+fAp1unVfOQvRqqkN6LVQ4tKUTogPgVeiIsy1sHmHB/N0ZcHr4su5GPv27FQnbhQp7Pu9T/98974CVLJKLlvjkLt+w+3tS/Xl4OkywlSWlLdFMW8I4h7tNxE/f32ZgERM9IlE2rX8xvUc2OZxYxAtlwVR3H2bu5TWkxdXIWHcn3968ckzrqswMoJ8HH7wdXsba0PI8nJNwg9MXRRIg2RqLrQ4uErQvTSMhJKJq6fU92ftA/aEUlMPn9lVuN0MAHJoVmBpVkE6fO1vwGNCUr0jzPpwkxg5ANhcH3hPLkODkuLHjzm1d6dYGDj49HfcMXNjLeUo1lWrvuaN/Mq83lkRhWidBDrTV7j6GwizMzZcteS0KJIttS7WbbGjml5zAg1uxoqvLvOTYEE3g5IZoPk9gBXmrotcj6nv1QN/LrP2HiX1rg6n5MbeVLu4sDrp/u7Rp48rXe0DyBcS1Wrd3Ci4ik7dN+FnvWXvU0o/Q2quzKEuu/P3/Ezw3a6JZZMp1ML1ZcBitlVLqpzf8eBwuJSfXzu2m5zEGj6s4F6B6kINsAacbrfGwDsIHpngbxQGQXgG14X+p+SXI9lSNcQIbr+Woks00MZV+3WPVHFL4XieDYSJpu6PaFmkynpr57Za3K0Nmm1ZAdusV3fcmz1ieY3FDTDYIOqo4FXLLs1dmhoumK1W3irwgwbQkvoyJ7matBDtQULg7oS56EuAx5ddyYyUwhSWbas9z1X9eeNQL0f5+2j4DOySkG+pxu2sn9tJGCNUTxuzDzT53b9qMy4c+0F7dDDZ6XRFXEY8Vt3AWLimPylhPWHLmNMdITuc1wNSqBLSnpKJ9Ezbwbi6xIIC+eAWPg6MVWpCM6nTdi328SDZf1qlgNHZKlmRPLeJ+KHY9j4j0nLrcXUdb5ynY+1U0ox39cYMfYLFdcRfsBkSDff4K19/VrSlBLi5XmVbECkyxfKYD9dm7JEZ
 9VcAu54r
 PG99yssZfN/0x5dHlaal5gWk40UZdyfLlmAvbdCLle0t8r13FQN2IEvpVv20bhy8tMF847N9zKgkj/S6GDDntHWXhKz7RPkZ53TqvWrtlceJf/4BgqtTxG4eEaTGbkPUeMxG0LQOnjhz0ldZIiCVAkjM/kJVT+QOr/vz2Q+FUVN23+SSAW2tgmfNKGzh5YmKuXHpbyq2/nJ7tFZ2ETRflOcBorhxDHnikjSVbQrn4vQyB6p3L1Q+Wq9qEOnhhMzlhMv5HoUm2OPBYmCOdWA+26OLHqf+KIe3FLD2kdG9tAMsXCT/0YRBoqBg0viNs4KzalNnysRKBz3U1VX/GEKW9DcGGJe9xfALDUAiC96urBe0byn5hPMWLZopvdCH0Nlzrj9KSb5dxOD1YzFSHQcH5yJUfBttlZmN5B8vxAbg/s8XsoOzEefEkHRW0lpyrBmf9B4mPeZ0QY6GqpcPOv+N1MMB6Hs05JqNU/hl8/B8hl8b+NHEDHGEP5QSWKQzMHJsH25DyErmg3doC2Pbjg4ZlJ4lp9HEbnck4UtdJDAssGsmf9WXd1TiAF5i+1pr/fEBgB9num+bAGwM/N7GzBcrOtnn+i0UX2dFkLpzMsryrrXy0pDyMDJCdaE/LKwMq4gJszwmYH1A5m0pwU2SLC/SaTyCuqZY8WmCzISD1O2lcKsEsq6kRGJsR7g6APgAopQJ28aBJX+7XowG1OjHMdgZoZyt9x0rKTUhJeFaI2Dhsam3jMFOjfugl943WVDHzBy8de3di5zQk5vIODHE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

MADV_COLD and MADV_PAGEOUT age or reclaim the folios a caller names,
and MADV_FREE marks them lazyfree, whatever node they are on.

Restrict them to common memory: convert their ZONE_DEVICE checks,
including the one in madvise_free_huge_pmd(), to
folio_is_common_memory().

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/huge_memory.c | 2 +-
 mm/madvise.c     | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 75e8641bf9ff..cae28513b121 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2452,7 +2452,7 @@ bool madvise_free_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
 
 	folio = pmd_folio(orig_pmd);
 
-	if (folio_is_zone_device(folio))
+	if (!folio_is_common_memory(folio))
 		goto out;
 
 	/*
diff --git a/mm/madvise.c b/mm/madvise.c
index 2d54cb9863ea..0f1648526f15 100644
--- a/mm/madvise.c
+++ b/mm/madvise.c
@@ -404,7 +404,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 		if (!folio)
 			goto huge_unlock;
 
-		if (folio_is_zone_device(folio))
+		if (!folio_is_common_memory(folio))
 			goto huge_unlock;
 
 		/* Do not interfere with other mappings of this folio */
@@ -485,7 +485,7 @@ static int madvise_cold_or_pageout_pte_range(pmd_t *pmd,
 			continue;
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || !folio_is_common_memory(folio))
 			continue;
 
 		/*
@@ -715,7 +715,7 @@ static int madvise_free_pte_range(pmd_t *pmd, unsigned long addr,
 		}
 
 		folio = vm_normal_folio(vma, addr, ptent);
-		if (!folio || folio_is_zone_device(folio))
+		if (!folio || !folio_is_common_memory(folio))
 			continue;
 
 		/*

-- 
2.56.1



