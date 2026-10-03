Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6F9FCA5FEC
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 12:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EEBCA6B00A2; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EC3316B00A4; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDA1C6B00A5; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A82116B00A2
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 08:55:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F21A9C0948
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:24 +0000 (UTC)
X-FDA: 85281310968.01.AA663E7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 038131C0004
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 12:55:21 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WNvPwcgp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791032122;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3jfUjuo7TvsULg+QDWj7moiquwYNe38vQWfseYt6pGc=;
	b=z4wZuVniKwbrV2NJa3u9uZAZYahlDwSJcylzmHFS/0u+VBEXq1lJFG550KOXNyMTm5JR7c
	jS1Fp5/daDJeApGxcT7OHIO878mi4HHh5Zpw4iNGF2WKJwvs1eNiZUTeCDyWIAKRnVU9nI
	d9GnJ2VBtnXZyafxsqX6oubYjh6cZCE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WNvPwcgp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791032122;
	b=7Pr6OtxqW20yjW3UZm27jitOxogTZ6sjp9qsLSZBnasFxOzBVS2Z4RRmEPLMUS/9SzEk/C
	fqp/Kz5KJ0bmgH4d6HZvbviFF1EZbePrzP12sPlWXkO0YBjuqjZ2svOAeaiPFb1qxU/c1L
	h6SAirpUvVthkoIgWQ61fSsCfqpjZg0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7BB9844868;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 32267C2BCB9;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1791032118;
	bh=ZaMjkkVijYxyZ+ww0bbLzE2oZnESozZolZxSzIbcetw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=WNvPwcgpAtw2b3jNI699rufSbiAGxTWbzwVuuhLlfJOOcvGNzxc5VoDjym1bAE7aF
	 eVQLDuT+uXyjb7trsutY4ZxJFYZAszb+tTtzLf9WugnTrpl/TiJHDZiJF021jaRlTJ
	 omfS7B37h/dJju38HvgrP4l7zMsc/pCFTwRlLiJfa1wTSLRnXvm3SCvshETw5MxKzN
	 u+bTFSWJiX7bQmcd/Xw4eX2o2GyD/CzZiP0s6IFIWrC37R8odSmkL6bHN5reDJ4fyi
	 EryvsFex7K0TbqWLyK/24ERKcMj86Cr6AwdAMO6469Oym5ibXNfgOysks5Jj4s4pz8
	 3f26J4KZINKeA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D411CA5FED;
	Sat,  3 Oct 2026 12:55:18 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sat, 03 Oct 2026 20:55:21 +0800
Subject: [PATCH RFC v3 10/17] mm/damon: convert to LRU refs based
 operations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261003-mglru-fg-v3-10-cbd4546a5bd9@tencent.com>
References: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
In-Reply-To: <20261003-mglru-fg-v3-0-cbd4546a5bd9@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>, 
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
 Gregory Price <gourry@gourry.net>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
 SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, 
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>, 
 Zicheng Wang <wangzicheng@honor.com>, Chen Ridong <chenridong@xiaomi.com>, 
 Tal Zussman <tz2294@columbia.edu>, Kairui Song <ryncsn@gmail.com>, 
 Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1791032114; l=1029;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=eKGLjjXY3osdWIyKV8AoaoBEcDdnPeYiyjs+M5fNrAg=;
 b=6SppS4XxsAWehLp8Tg44F65lq9GMzZKV0bWu42Uw1WD6ANsByiq05vtFSbGHbL1YqgZ8ZGIWN
 RA+F8+lb6cQAdNG/3FFKQyOHfnkNbJu8srJgvEyK9lanlEYiMBcbk9S
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Queue-Id: 038131C0004
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: csnghj7ug7p1tnchkk86zrudcncjdc3j
X-HE-Tag: 1791032121-499513
X-HE-Meta: U2FsdGVkX1/L1Ju9oF5vaCHjfhMEvbRzjAAR8Q+ez5y/1ZVWRDXFDfZiOjhnCkoLARBnP/2xLGj5yIma1l/rGWNoAYYNF1bVDykjfztsYXr3lFg8m6rwwji5yTqT5g1YO6zXeIieGjFnTSEQyeExSjTM4cgqSFC3Su9YeGAf06u7OGsh47rbUzVGDFjq00OmYWa4f/Cp/Hoz+w5dfBRV0phSBxksTnmiZGcNgKT8E4z0HXoEXC/vld+jPXgFUnuEhKT9Uf3r3FGinndFOh5a8SuE4UVctlanTzEJ2nnnrU6StNdpGXoYS4Wq+0IYk4uVjTawkynpM//6OlsOsqbJ4kLv/uFbyJEqQemZGF7qFjw5MTNM/OzH5tHf9E1hJ6udpvFvp+Odoms6xDAOt7YrCGQo+5t4M2EU61un4KjU35tppbWNaLuUXwFpDgla3fzvMK7F2rYaL5g/rK0fvShS2w3SSREjDLMoytUh7XHaJIAf5bFk7qdthiZxIyHWzs5q/vc7hHmn9qz5PKwCb4gUcwJZsbfsyIH+BIGei+aYiEsoI0PpczTUZSdJ+fi2JRb5FifKETZRJmf+bh8a7ceZ7zMq4CLg8xRzi1OmZu0BhrFgsGrW6xjlGGXNBmYfVyCV1mU7NTCURLzsHuJZfrUOKxqtZSgw9JtVSojoYatwM35K6+pDbEluVDa3hpuO8zUQF5CRDTWy9J6/XDJ/evcczqj4yfgHoeSW1m9KNM4FeeszI4UFNGaIB79ask+EHUwKa0PqZhFzxkcEvlnqpJX439WXqqA6eE14Tn6U4IDg+aLobU5NBoSxAvTZMsqeqK5sjBCkk6czoVRvUu+xrUO5ssBFzxHnQEAAmqP8Vq6fIj2sC0frNulZTpk3dnK4YbbGsSlzc5lf7kfr7SUUSSKaikZpWhFYe7GDNLFvDC+7FjfafzUCm6SeHLMVfBp3joprsR5HJQDkDuzSLg9MNr/
 r7d2NqHy
 xc+o6M1GZT9hUiDRB01jfWleqsdirwgMlrEXdf62oWJ50fuYyVFjmXil62s+J5Zz7B5ZpmA/zN/NmwQPTJp6coO0F057t7dXmE9rotFjwdA5HVW7Vyupt98Ou0Z88jkbuA0rHxdlxePag5Bz0yM6NumAvFvl4cf94vUQzg9/Ppbo+KeaU/zvo0dN6EtS0uD/847sIq61/v83L72+oZYZxskJFl2n6SZIlBfJqsFtVHP6Yb2JBAoUo0zpuObnVHCZpzSVoXLUIMv8QWdGFUqOJLNYIue50ZomBxBwtyH/7/GsPc7Tb2IisjOhH5JDm2kNCusObLRVRocNegWA7rgLnzIwmbtgPpXQ67t1xZXcYlhtF7iuqTZmdL1qJkcxF3/X/TrmkWQPg/3MOuNI7HWjrj+5Lp3QHHV8xYkLMu584DewVOK4V4ulEX1L9A5KE4h2PKVnw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

damon_pa_pageout() cleared PG_referenced directly, which under MGLRU
may corrupts the folio's refs count in later commits. That flag is now
bit 0 of the count (LRU_REFS_FLAGS).

Reset the count instead under MGLRU.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/damon/paddr.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 2cfdc356b415..4db141b3fce3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -279,7 +279,14 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		/*
+		 * DAMON only gets here for regions it measured as cold,
+		 * so the hotness can be, and better be dropped.
+		 */
+		if (lru_gen_enabled())
+			folio_set_lru_refs(folio, 0);
+		else
+			folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;

-- 
2.55.0



