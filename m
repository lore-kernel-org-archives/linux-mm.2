Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C8DEB60732D3
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XYwfeMTX
Received: by kanga.kvack.org (Postfix)
	id 6EF876B05C8; Fri, 20 Nov 2026 13:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 678816B05C9; Fri, 20 Nov 2026 13:10:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 540D36B05CA; Fri, 20 Nov 2026 13:10:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1DDEA6B05C8
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:19 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 942CA4016D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:18 +0000 (UTC)
X-FDA: 85456286916.20.797D155
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 63759120006
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYwfeMTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198216;
	b=Asa59GNJWBRuP/cZQ+tcvnAcrxijMBjiayQ67xuHm0UD//neQxI1inWitrCbDyc3n/fEN+
	LmEIi6k29fOXm5fVzcLiFgK8IC1PN4LKh1awe0zzRxbSVypvYnKDkIS9n4qcAWDArOQPiH
	fopTQWtp5XWXlAjmVPMmb7XBFPr3dcw=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198216;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5H5FsDeB1gHzRgpDszJ63Z0a+uiOyNfPCLVuov6SBb4=;
	b=b+6fR4pVCdF8P99Dxv05m83EYt53OVp+jlIpTeh3GS/kAwEMSA2JpDc/vpk5w3IXn4nXZA
	TJnqYopcYD6BI4YNi9D0oZGvtLCM91QdVA9RiJW1ThUYXXVPB2qGg6VKxZ6b4icxg5gu0U
	esxK5DvixA5IBwvHELo5lXL3W1bpNwM=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XYwfeMTX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf29.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B35A0456B7;
	Fri, 20 Nov 2026 18:10:15 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198215;
	b=QbOSctPpdk/Xhs0NiClZSRDpnpq2PMHIS0Gb/pQMfR0iaFwCsSopk2lWaZXbo7OPUsi1
	 dLcVts1vn0z9rIAaAPfH+vTt1MsOYaHy+t6girRs8+E+AnOfqG6IqlZxR6CmL0eaMjmzt
	 vbO5wOnf66ElHiQi7fUlDL4fTbWbWJzj4mUzwfTdr6iYGE6uIp63y3HXgjEN2cg3qeZg1
	 nFEDBZoaDyXP0stmPyPxZ/PMi1QZxvDH90ZWiJTu3Dun1nj0PL6K5RoHacn3nPXljS6pK
	 fnCk96m8YyNON9tylRdMBAmsoR4V49cLxjq3uhmA3bGA6B3BwdJr9ozMSjBwYSI5C3w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198215;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=5H5FsDeB1gHzRgpDszJ63Z0a+uiOyNfPCLVuov6SBb4=;
	b=aw9k5jRxYFCZBmuKV0knGeKAt6BnjBURWDZ6FO0Wd5o5DfEb0icUoynHZnPRlxn8E1/e
	 6GgKB0Zn4NUchDfVAnMui3XC8IkLU2iElmZNacvE3lLLQkTJpRxqeZg62kyfnTY1B7hLS
	 l9QabvPAusHNFglFg3jVf+BmHezFdasx+AwbN/3RBjUTm6YtfS3k+CnQrXrZsFomPC7qM
	 OMgdHTXW53gBAaC84kMYGTv/Nv72SMWAWe2fj3P51e9aRsnVdPiW8l+sGCfp61TGbYmzY
	 ZlPBzaW7ieVxbhCdIlpImdgJ0oZZLIPwMToSwEv8uujymPAceGYxB5v2ZIxvt9V/TPA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 0DF101F000D0;
	Fri, 20 Nov 2026 18:10:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198215;
	bh=5H5FsDeB1gHzRgpDszJ63Z0a+uiOyNfPCLVuov6SBb4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=XYwfeMTXle/iC9PG6DG84WONVljzofwIrqPOoXGxpRjAMWR2n1Ql0qgtOiMpsrLaX
	 Uc5scqoYEPeu8buL5j4mtVt/hTh6qb1XuRtJy2ky+QExbDTtCnLrt/P3VcTeoNtMDK
	 4FNnp1s+o38uMAueWuRv6GOoppgTme8fbvHBi88z029uH30CMZh2oyk9mTCtfPKfof
	 JUfxu97QcOB0R6Y0XyfVj3V4pDGB53FW5iYP/MSgwf1FCJQjR1ZmuHCeSIjSb2DfQm
	 qwDAzPtEvn8sgAdVBiPTfKtuBZLgmfCuDCkAcDLTCtHrA5eERNvRii/aS0n4AQ4wtX
	 s0COvRzdJUTCQ==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id BFE184B91D;
	Fri, 20 Nov 2026 18:09:19 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:14 -0500
Subject: [PATCH 23/60] mm/damon: restrict DAMON-native folio operations to
 common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-23-74f5f9a115c2@gourry.net>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=1668;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=V04Qzs1fFpNTUapr14E0HnNb9Xxz8DrH55t1p7KWMZU=;
 b=RMc1L4r0dlZpqP5Q+uot3dU1rWD7OMYOabzEbwk3/bzUXH/pZdb+6OmzM/UnOgzxpD/hhyFTZ
 4DV6BPxrgdECffvg689x8JzsMYq+qTUvinCDA2UxDQTgWjuAldpeOdl
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 75tfrmyk96kj179hzygiem7ic46ymdaf
X-Rspamd-Queue-Id: 63759120006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam02
X-Rspam-User:
X-HE-Tag: 1795198216-593089
X-HE-Meta: U2FsdGVkX19QjbdM/eDmZhAhB3YXBFtZbSmdaNpnnx7gwD4hWdZW4raTF/jWDaT/p2UY+k55cpwXrItbgWzJxMG46xUCz4xBPedxZxb6vSyYX+3uDhqULYpbBxHseY26mxA1zv0vmT30q2HFj8rivo6JQlgLYagEUVhWVYflWh/w5trUmTyB2Hb1cwW1P5nRyz5s8KD3PrTNymwxqBv/xUfo4Cz6mXSYaXEHwrMtxulGCkskCBdmtrbRigaIK5E/8YRQ+zr/tCNVGxQw3f+FsXjo7K4cWrDRcL8nQ6oZeH/v1a5/bHf1fsxwJRoj5yu8qtYS+MO0069Oh5s1XFrFk6NzPDr/siMRzKkhcCJDzUCYDX8KbdBZdTPQlSYZ/mcNoI10Yt8B2oKdPDM0TWQi8nHG8CjuK/+yrCDZXaGcK9ECOyk14+PPaV7InZEGwbRZ14kw/rPoVsWbFIKqjkuaFDCwVrxSpNGDCFpAoqjFDSyfEHQCUy4DhvlxoyieVB3XkU5PtPTOQtog4T7fES4cwSiDNJUkl8nt7NKjJDjkm+9oksbtzSVhrdonOLgzlFvIBPERXGbEJztHR35WKb+Kt1h74wnylbxtHYhoTzKguthwdd7UmmfMU9k6ei1DRwjoTAzrV1YaBjInmhCxhPWfBJ4n9pFkyVB+/YdhNX7gV8DQaeBiaenCV09f9qCnZh/iCrXM67zPVeiiSzBC/+r6RBW5HTaHaknqLz/EBC38NUxFcflP25HEGM8XrpVS1KP4jqNVnqva5beHhl0j6yQfL+pcgoWn6DxZd013hwvaNb55E46yf+6Ig/+KFaccDiMHIgu494eyk/4sC0hPMCe2XXSjO2oWk7CR92s2XSHQRHMbZe08Hxz5Ty+rJDu51on7k9uT62ZVvmH5DAgGjfwgUtsEdvrdMGMHDvYD5ZL/kYOBcGtTWzeSek7kl26eB51W2DidU599HMYkesxfaXC
 SUJwp6GZ
 DyCC3flOTOd3b6jxCzzv5gr1SVhyzMAnKQ/FLC61acE2kKTH73s/X0GqiHeMaMtLMghU2wTA2khbJGCa9M0Wns0eDs/MN1DQg2nHD4m76XgP8xKWiHg8nqD7W3fzImGk6tVr3Rj8EIjXjH7HwLhV5HJ//uQRy6qkYA8rOhGQWSl9WGtOW2QbYdv/xdCcAWdLFQ26CzDFDY+NOSwlVnJuDwC5xrsViejglM4QkCg57wT1vXhTcwJzweo+MUsVVmsICGmwWH0vIsm85ldbvdp5xXAFWonf7vsgq2JL4boAoekMo+qF4ZDFBc5n/BXAHhredHWb+QUKJ4yXMLt6hxZuk2sDG6d+MSs/FISg/v9PTIaOvpehQX1xGqaXp1/nnEn6tz2vamyJEl24H2VpF1RprJqek5lrZGp+yIuSY2rB2MEvzjxlYUq9M5nnIMf7c7sL0OvEOSzPeb5E6xWtEgerRpE26fwSf/t8t4IcWP9nx5VxJzRMPP3Fdtpt7FeEHRLL3I7/r6v2hwHjfgTXtF+ZwL3S+prQvOl9WgE+3+UrlBcVYDn0V9/mdWDbwtlG+d7yPXayNAmBqOBnkEqobRtkP2wUDNtkLM0/vS8zEQshw0kNXEzPqG+xp03eAd1wVs5HeL55+QI200rGOW7abTcdg1l/v0XodThBcrYvjkGLoWcUZZbcOvb/7Ghl6lXqbghXjTNQbp68WZJYRYAcHpEUfVFB/LwIqYf3J1y4EezFgj6IKD8VctRjIiuW6/UqHlT+SVgguJ9tF/vrnJDI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

DAMON acquires folios to age them, check their accesses, and apply LRU
operations and migration. Treat these as general-purpose MM services
and restrict them to N_MEMORY_COMMON.

Memory outside N_MEMORY_COMMON can still hold ordinary LRU folios, so
it would pass the checks that keep ZONE_DEVICE memory out of these
operations.

Treat these folios like ZONE_DEVICE memory.

DAMON cannot acquire such a folio, so it never ages one and virtual
address monitoring reports it as accessed, and DAMOS cannot isolate
one for migration.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/damon/ops-common.c | 5 +++--
 mm/damon/vaddr.c      | 2 +-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 15cabc79613b..57201a0c5e3a 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -17,8 +17,9 @@
 
 static bool damon_folio_acceptable(struct folio *folio, bool monitor)
 {
-	return folio_test_lru(folio) ||
-		(monitor && folio_test_hugetlb(folio));
+	return folio_is_common_memory(folio) &&
+		(folio_test_lru(folio) ||
+		 (monitor && folio_test_hugetlb(folio)));
 }
 
 /*
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 1e65e7651cd9..338876559140 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -830,7 +830,7 @@ static void damos_va_migrate_dests_add(struct folio *folio,
 	if (folio_nid(folio) == nid)
 		return;
 
-	if (!folio_isolate_lru(folio))
+	if (!folio_is_common_memory(folio) || !folio_isolate_lru(folio))
 		return;
 	node_stat_add_folio(folio, NR_ISOLATED_ANON +
 			folio_is_file_lru(folio));

-- 
2.56.1



