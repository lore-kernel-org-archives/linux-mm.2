Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0106E60A3808
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nZpgHUGb
Received: by kanga.kvack.org (Postfix)
	id EFF946B05B6; Wed, 18 Nov 2026 16:03:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB0016B05B8; Wed, 18 Nov 2026 16:03:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9F986B05BA; Wed, 18 Nov 2026 16:03:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1C06B05B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:03:50 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 14A2D1208BC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:50 +0000 (UTC)
X-FDA: 85449466620.22.19162C4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id EB8501C000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:03:47 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZpgHUGb;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795035827;
	b=6285VKY/KqBAqmB6gQ6uPsUqzKGOP0DBiHqmx8OorC/EAFV42Z4sHewbwUuI3KLdqAfivg
	j6QHw5sY1h0NnTF2fMrULKPOCK7S1IY3u+SPwsnulaF1Cn/aOIsgBXZKQLJVBnKHpLNpjO
	exwmBS2WclNkTtRAdtZFE+3JiXw3P4I=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795035827;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y6mYfGolJS6nXYyvKPDyCfBdq4QUzDPuKkF7vPXmNoQ=;
	b=fTPdAlX59EL8E9/lo61iI63vYSNDw/VUIZvYvResNP871YKZHV4qKFyiyK3eDxEGI8J5Bs
	V8O72XZyPdR9+JC0Q1LyVkrSRZOFoe6FS1Lceip4wljLuRwLCCCqAzoEFoWG6b0rwP7QDE
	DQNP2bZ5QtHXm/ZvTCsCel9ommC5b/E=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZpgHUGb;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf20.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AD92B639C9;
	Wed, 18 Nov 2026 21:03:46 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795035826;
	b=yLxHjO1Btb/uJjk00tUMB3U2gk2+VVsq8sJ+KrQt4ADzCWQspnNMtVYn4M18WT7ytMt5
	 uA8Cl2FnT91aAqA4RkHuz3gFkXiB/CxzxrwH3t43YGkVuvmaLj/xS7QbfWDzgF6wUXTEk
	 aNuyVuoQdDz1yJrd8t7QUDNups120QOMlKDrZUPm+TKT6sEv8HC0ivDZvDoHEPE5sjr9d
	 RWi67uzMmW5O5WnT+n/ZzSvz5k0crfriponTqGZ037zFP90gob++jHW9wSW84wOTRjXtt
	 sU3AczsH/S/mCnNbiO38H+4OlzMNfQNBFARSMkbtpRszIBcfRU1PsKsLEWu02+0gFWA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795035826;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Content-Transfer-Encoding:Message-Id:References:In-Reply-To:To:Cc:
	 X-Mailer:X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=Y6mYfGolJS6nXYyvKPDyCfBdq4QUzDPuKkF7vPXmNoQ=;
	b=K0SNUKghj1TwNLwdTfJ4BBdZb0TB7QKwE0PYs+EStbefC719+7x20c6hqQlOXlMFZCH5
	 APPQdxiRO9VqdoACRsAEvp6kLJz+torXXe0RJ/U0KhuiWek0Kq3QdFXt9XA0900pedTGa
	 00wlZkmM9KKXe6S/B7Xr6RasIr6MY19YRkbTFpRJeNjro6DVdR+fiM7YXXuJH2OBtKbcQ
	 hd5Na4h9c2h9pX3l1rf5jllxZ96yVf3wTkp+34dGv/p719StqCBp95M24W8uvFLHC15s1
	 1nsltViZsEOMwLl2e4dIT1YTMijhfP0QMDoTOeX2x99bkcmZKWbXg1z6RT4GmxIyDbg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A42331F000D0;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795035826;
	bh=Y6mYfGolJS6nXYyvKPDyCfBdq4QUzDPuKkF7vPXmNoQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=nZpgHUGb2YZutFzEdxfDMtOoWT1hcEfl3ZduEVBD2FmfGGfD6fkLBWF7txYv3iiFx
	 QMri3jhUFUMManurakID0+LFfREGHX2VywFrQyNknn0tScSB2hf2Qw44p0BazS7sUa
	 N9Uu+I24r3M6mKtyodeXjuBojJEPADGpPWu9hViG1SLVFZ5/z93XhCYN2R1X1He1Sg
	 h/EA4JjBbuVjNtth+uft9NvOyPbbXgSyCHsZIA5VvszswiIzSw+A8eiFZ6KVj19Qrb
	 JNstNslG+La1b//VdeLbrkZdjtxmETvJjbzM+3stFZDtBkydinRsNk9wro++GWCBsH
	 QGXsSjwO96MEA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 210B44AF82;
	Wed, 18 Nov 2026 21:03:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 19 Nov 2026 05:03:33 +0800
Subject: [PATCH v5 01/17] mm/mglru: rename the generation offset in
 lru_gen_folio_seq()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-mglru-fg-v5-1-9eee2fe97a2d@tencent.com>
References: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
In-Reply-To: <20261119-mglru-fg-v5-0-9eee2fe97a2d@tencent.com>
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
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>, 
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, linux-doc@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795035819; l=2264;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=YwqZ+e/q+Bs63p0EPa3WlWInx++BICs4SMMeFTRMo0I=;
 b=YvPtmtaQbA6mZdFgjxoUMC6rb+7OWEf9+nliTpL4Bc3GKxUs5kNL45/RuGmCxmFZJQAo4W4WX
 afdUPeF417PBvcgFY+BnlE6WnpX3DQAkM2rk4mvWkE7Pq6SQWm5jzs8
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: k6tqu39y7i6wxzwp8w5jqixrzcaeebf4
X-Rspamd-Queue-Id: EB8501C000A
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795035827-604373
X-HE-Meta: U2FsdGVkX19qhrvxkAf29BemU79Gp4awFyyxTnKD1q5++6FVFXuQ8KNn2nNxJmd/y4rBeKaq9Ur26vi6J9alSnP1JkEybeRKD1iHDnrzdlM23fQLCYDv48rhAmrpN0anWQPOvkXFCMLzcOw28NX/90yfWdbkCRnx4Lp42uDnGwQ8UqNfTlmiOXtxUtbuBfIs/DHVSwEtjV2JprUPb3PDfHPrfzkk8zEfhoN91kYl1134ppbtfe9yhx1UxZbb/dMWvvAwh5/FGH34dAJmjD2r4HE8cfhmVph2R9dRf8OSsGkFICLd3yozqRUxKsbZOCsYITZm+gIzNcy4RNHJYwbAnABNN8Goa/7E+6I3aP7IXeEeqsH/zeOJCCDtFx33RUOJlxBmJlQia9Dh3ldD32s4OuPTOMbXYdfkBVGh2dBP52uHWF4zbtLdGAQqA1ZfvQ+7lD01yBKTraTtkcHrAEx7a6vsaeBgBxlzamtKzUaSsYnJ60IOzoGUqWepHMncnNLJPORP32EM4u1Sciv//Qnf386EI6dxyRjJ8xudc7bMCdxLFaIkrTTxbyGu4uFA8QItsha8teYZ1ufnwwTDaoB0cxrRZnsVvrIiOZ81gXRsVzlLy7LlNOMoQMzJHY/l4m8YOaXlenbt9lX1kZxdo6w0Ux8YLxbyF2e95SC/HD3iB1Zd6m2nNelB7W0FMwQl641wYY3vXdfZKx4g7wDl40drKxICOxqzMJVDrJ8bqXiyP/wvPmI6ACNio4zCKXnnjfYDW1WuV/GW3j3PJcTQjKhltTF5vddiv3v8OUm6cScu3HYrx/rCpweCPbbKjDanqJBjuwAillbkvAJdDTsGwoRRp0QWv1pdgyymG4WaRqWc8eExokE+mK8lsWLvECgjGDHtc76doNkKUCsRt5K2Bh3piVlJuxyMd/rV8FCrkZAp27ucf9bKie0W//QojF0D4cLuoeeVnvbLWtWsJMObkZH
 drS1BAnu
 DBUHQqbrh4usdVsFWQUr9fiQqS8bX9Lj8Hbto2oVX8+HuDYmSWm6FKR3VV8paZXD7PETnPu2akQ28ag5qatIO50kn893evMyA2fxIEAz2+3xPlRWOQWjPVVQWo5RdaYarHRfEpkii4o9sC5kSFk2xs9JlgK/qg0SMDlWnwHKB1ajtJqV0v3Uk3EEvgtX+9DYMq23DgW6di3cBoC9iK/laer0+weWmlTZYbydsbTHVYEEMtWOBT/pmT+cGb4/aToQEp9yCTb/+IqCSynYiALQlBPcDmuT0pVEGiHHOwLFftzD+BfgwCHGAiVgu40LRf8bsmDLy0KSVTRxOEaxgIhq8ecPc44LJI5qFhUT0A/KLOAtg+hNEfHXhZTLbxMluca0g+SKbr5xovmDPaE8bfTmtEWLdGuN50bmkqmVRqFvNh0ueyhByjNHat8nSIEEXoKqcTdNJOxgXDsJH4FsUXFXOobtev0XsQ6/37KOzH4HBGmgCSvNu6efDgF1kh80MwZ2wp/Bjkam9oLZkCavT6CDBOPu9D126edRKFZ9HdWcYgmRi+L7HRYSmNAJlro6G9ACOgt7wMzFpIvl8CiBZFVmqFjgqojHzNaK0auK2yc06HM2V9fzQv3TUb0SktjZ+g3ykLb+7au3Urylsw7mwuQnVymn4uIE8I/pyn0WBbb02mKpi6rdtd5ZR2bF6/XEMwoeVjt8fI/lOwy9NdpfxqRoZJYZFN19nM2s+Z56m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Ridong Chen <chenridong@xiaomi.com>

lru_gen_folio_seq() computes how many generations below max_seq a folio
should be added to, but stores it in a variable named "gen". Elsewhere in
MGLRU "gen" means an index into lrugen->folios[], i.e. seq % MAX_NR_GENS,
so reusing the name for a relative offset is confusing.

Rename it to "age", which matches what the value means: the newest
generation is age 1, and a larger age is an older generation.

No functional change.

[kasong: dropped the comment table part, the series rewrites it]
Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 include/linux/mm_inline.h | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
index f6f4bc9a704f..2395ca8ee305 100644
--- a/include/linux/mm_inline.h
+++ b/include/linux/mm_inline.h
@@ -302,7 +302,7 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 					      const struct folio *folio,
 					      bool reclaiming)
 {
-	int gen;
+	int age;
 	int type = folio_is_file_lru(folio);
 	const struct lru_gen_folio *lrugen = &lruvec->lrugen;
 
@@ -319,17 +319,17 @@ static inline unsigned long lru_gen_folio_seq(const struct lruvec *lruvec,
 	 * |<---------------------------- MAX_NR_GENS ---------------------------->|
 	 */
 	if (folio_test_active(folio))
-		gen = MIN_NR_GENS - folio_test_workingset(folio);
+		age = MIN_NR_GENS - folio_test_workingset(folio);
 	else if (reclaiming)
-		gen = MAX_NR_GENS;
+		age = MAX_NR_GENS;
 	else if ((!folio_is_file_lru(folio) && !folio_test_swapcache(folio)) ||
 		 (folio_test_reclaim(folio) &&
 		  (folio_test_dirty(folio) || folio_test_writeback(folio))))
-		gen = MIN_NR_GENS;
+		age = MIN_NR_GENS;
 	else
-		gen = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
+		age = MAX_NR_GENS - (folio_test_workingset(folio) || folio_test_referenced(folio));
 
-	return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen->min_seq[type]));
+	return max(READ_ONCE(lrugen->max_seq) - age + 1, READ_ONCE(lrugen->min_seq[type]));
 }
 
 static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct folio *folio,

-- 
2.56.1



