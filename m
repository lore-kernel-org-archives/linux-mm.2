Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB6E1CCA464
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 18:16:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D84E06B00AA; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0DA86B00AE; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEC156B00AB; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4F0046B00AE
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:16:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C0A131C03A5
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:16:01 +0000 (UTC)
X-FDA: 85325664522.27.93AFF95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id DC16A4000B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:15:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IDkFtyu1;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792088160;
	b=nz5gJfsq8MrMAQ1fzPQX6g/lr4JwdJbRDRMXaUcZwXFd0G55kMVE3grI/n5nUMEWvUS6C8
	JhLohnOiflqx3eVMqq/+gzz6r6g1TBI2fF8K6/1fjzq01SL6zbRBhFrp12j74z7yx84aa4
	5semfZj6lP3sHF9PJf56baOJX3J79lY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=IDkFtyu1;
	spf=pass (imf27.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792088160;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bAl0jvVKRuqpismQo5glYmVAx4LVgE0ZwXJ9J0Gk0lY=;
	b=NqgyyBtN/fsO+1I8XNoCqvWVTnooo01IQtwsRAdQ/T7lTBZsSV8r557hnRxEJUTlJKq4Nc
	IttENT16TLSlgOlXLLAw6IOlfZ9rUJVa1ssWoRfhnYL4O6o5aWN+P3M/rceL/pRXHxoOYC
	mr62L0AFR1PoREbAzpnobA5fWmhkUis=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2F4B447EA;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCB8BC2BCFC;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1792088155;
	bh=pughgVfMKfCJ9xqikMGkfv2NRbdXiHsr3Sk79GCYkoc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=IDkFtyu1xmRn8a+O3+PAEm1hPF3AY2R9tbhZz/tbxKpWee4tzPOpaOKYd9CyLv3pv
	 dAJ16sivZg0xheEOy90bFy2b2CLFYtsxU6VCBTF8ktVIIuVID+rJDdiDFRGoXHnZcS
	 BSa+Na119f0ljoLX6pZ727OF7GqJOA67yeTIx9GBlqbqlZ1PkP8L8QIeH71PxsOjPJ
	 KE2Q2tkKZVKFXFBQBKya07eZiD1BW6p5HJhvhkIIkqTY/RqfboB9gIxOHrdEVViV85
	 yCKjkYtSyJZSolpQSlgh9yaRyXVLdgq3pCaNUAlpdq2iJS/3d3fLjaAD+86rscCFwX
	 7nHY323fXrmZQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6EDCCCA464;
	Thu, 15 Oct 2026 18:15:55 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 16 Oct 2026 02:15:58 +0800
Subject: [PATCH v4 09/17] mm/damon: convert to LRU refs based operations
 for MGLRU
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261016-mglru-fg-v4-9-2106750c0bfa@tencent.com>
References: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
In-Reply-To: <20261016-mglru-fg-v4-0-2106750c0bfa@tencent.com>
To: linux-mm@kvack.org, "Liam R. Howlett" <liam@infradead.org>, 
 SJ Park <sj@kernel.org>
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
 David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
 Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
 Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, 
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>, 
 Ehab Ababneh <ehab.ababneh@intel.com>, 
 zhaozhengzhuo <zhaozhengzhuo@uniontech.com>, 
 Lian Wang <lianux.mm@gmail.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 damon@lists.linux.dev, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1792088152; l=935;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=IdCP7RuDv2hWzX1uoW+WX1Go69TBrhltD7BGki0ofGQ=;
 b=Jvnw/LzNfAwF0Q6VT7GjTKg2XPpgBmn8d8tPZH6NZUS89sJE3igFX1rLRNxA0eR1bno0GkTug
 trWX/+m9nCICP1Y2k3Z/SKOS/64rdqmsq80XiuX9nKzQcQXYdDvvbls
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: zy1s9z6m7htp6icisbh5oa3umqihqaa4
X-Rspamd-Queue-Id: DC16A4000B
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792088159-13936
X-HE-Meta: U2FsdGVkX18txGrAmpdCR5p6BA0y82Gi9cHmv6OVBMIqVDxPEuE1ZR4TaZ7frYFYl9+CcF92bQAlc478pvLzK08WDuz23dcTdOCNIm+CUa8mA8FVTN4AIOHue2Amc///i+qZCyz1ZHq5293KEXNuz2B2Kt4iyI4edQY8criDnhjM/dNAJEgj+/0Ry5I9mnK9yoJrFFmUxqbS8mkvGVgvxkmdfPEFvEuzVxb1XEbcOmSPPU5YhmIkSTj02geDliUPpPSW2qyMKqrvnzGi2qoXrKYKnug7wTHswxAkUgHJTMYLhjAGA8Eyq+IrN0xbAKgs4X8WWzQnNR4lDEmKhI04Xly37WUmuZT0o0G8YQxALJWQJycgsZDSn/cDtjmZn+kyn9opzgnr+AGBCK2qxZWQaiaAqsgGTWk5/B23r2np0W66xT+qpmx9Da6xOQjN8h8RVwoMAGGMrXGNi00eck+drl548pf/E0KIki++XJanqF+xQEFzCHvXExZDT2FdUxCShUT84CVvpgzQrMRsKzho+EVfuB1G37SZu/TK9CevyDAxaZMK3gno1pIZ8Ne1NYgVZfieMS/LwaSXJmT8HaN6R4BIrJaMwnvhhXGk5f9t7aYkBQt9DMfud5tqzlP3koA6lTf5Cj6O9qqZSKF5BlANHRvOzPfsSamKNJthxidSsUTWyf1ATEyA2D32dKp2G1ZheCI8kZSy9ftWK5yUMMgg8US6dsZQJkJd2WBOQ5a6onrIY7i4sKixNUbcExraYJWaiejCKxjoJTTnmMY3ndh+QYdZBfJQugD6nC86xfUJagD7q5n3BxC+n+s00lcs+IBukwbSrj8REthUxqzPxr7nSiHTzhOeHcqlb2vPE/9IF8dXa/SEPleMkoWIpJzOX0TCGLZE723JOyyTeggUST8Osp6dXCBh11HtARGMG+NyA0vPZw5hqu1X0sInlOfegKG6SsRtWGqW2iEugF0n/pk
 hZHM4vkL
 x/OZPMW6EJF6qEhX5C1fIkV3NzNRyYDraaDiYdVrztns3ygSl/zJHnyShj46/371BU1mlgyvCaIHIIwBudazgHWSI7ciuwRQ7pAjb/SrUAJrMXuTX685tGbl4wTvJkUePtE1CyDbCKvP8dAIQrpEc44xhAsQIlxOOCqE5ge4IS3Ok4wVAet3UFfI1HZmfRsxv9m2oUZB01XRyMmLQK+9IlMXIX0C6Sl+ibPSuX3QJLcx4zXuWzPK3W/5/c4a9KNQXZQYkELOfbv7tt1l+ckUZPYEurtKWgCuqXygDXRVzPWSQ2RaYrT5cuhdAxRMazfUqCEy256xYNKf9TrHhq8OwPACXTlaCEhHoUAkDf23uxZMEpF50m22IFcYLDvfcdLcxUBFSadUECfVQxldMIoAQcRr59pVQDPvG1B2+HGArajHHzPxnLBquPWEoxCahwHjv1/PHcWOeozdiqMEG1MsyA52xlsvW8hnb1Lj7TSyRo9Blj/YxZiPWsNlwj1lp82RVSjEy
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

Tested-by: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/damon/paddr.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 2cfdc356b415..6412ff2396b3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -279,7 +279,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		else
 			*sz_filter_passed += folio_size(folio) / addr_unit;
 
-		folio_clear_referenced(folio);
+		/* The regions is cold, better drop the hotness info */
+		folio_clear_lru_refs(folio);
 		folio_test_clear_young(folio);
 		if (!folio_isolate_lru(folio))
 			goto put_folio;

-- 
2.56.0



