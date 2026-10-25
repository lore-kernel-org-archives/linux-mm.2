Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7403B606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 25 Oct 2026 17:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=gT796LRL
Received: by kanga.kvack.org (Postfix)
	id 178CE6B05BE; Sun, 25 Oct 2026 13:40:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1064F6B05BF; Sun, 25 Oct 2026 13:40:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE7576B05C0; Sun, 25 Oct 2026 13:40:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B74E86B05BE
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 13:40:46 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 367C7140591
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:46 +0000 (UTC)
X-FDA: 85361863692.23.FCA1374
Received: from mta1.migadu.com (out-121.mta1.migadu.com [95.215.58.121])
	by imf17.hostedemail.com (Postfix) with ESMTP id 009B640009
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 17:40:43 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gT796LRL;
	spf=pass (imf17.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792950044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wx7DtEnW/yiqV2jfL4jW638vppvg9yzl2vShHqhjnzQ=;
	b=RuY7Q7lpdK4AyKm5sWinZB7zH2NOw8rR0xgBfAhkOxUeZc7Sq27ZeS1IHdeJFMyQuz/jsb
	rOWXTfCY3iJCqeBwuwotrHN4IclStWnpZV2g0/ob+tE5gUqvmcknTmDmiBRyRiCZSkdwpv
	1hSyt5YtKztxxseA7+Uwk2krr8NSqSI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792950044;
	b=Bc6u3pzzptgHl37W5LiHdesPXqfKwgK9Dri3o+h24Fe400GAfAjxKv0EvuDf/32TjHH3IL
	tz4jtzHtgx5vytxs9mVjcdxd7Bj/4WLJOY1yZ1Jn2z1GIik9e/k8kLRouuZZZcPafdGadO
	s/HFr+/TCwPEFtyAj0ikHQrdCTihLVM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gT796LRL;
	spf=pass (imf17.hostedemail.com: domain of nico.pache@linux.dev designates 95.215.58.121 as permitted sender) smtp.mailfrom=nico.pache@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=OWOq7n51OZNlSYTiLRU59Gz0Q2na9qpH+zMvubZiDBc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792950042; v=1; x=1793554842;
 b=gT796LRLwsqHeKK5Gm1O7PXv7PjYZqZnGEQMo1b1BHHXGFRMX8GbgNDe3JAvxpKb1GxwTyLb
 kYgsYOtk/zUQWTCTpbRQnsMTzudDk4Qvmr7mfH71BESGSTl5FjvhQL4vGfWUspQw0BK1vrOoKCY
 x+IthNE1nY9xE5RZ1bLust68=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 75892baac6524e44;
	Sun, 25 Oct 2026 17:40:42 +0000
X-Mizu-Trace-ID: 75892baac6524e44
X-Migadu-Flow: FLOW_OUT
From: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Date: Sun, 25 Oct 2026 11:39:46 -0600
Subject: [PATCH v2 1/2] mm/huge_memory.c: skip zero-page remapping when
 underused THP shrinker is disabled
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261025-b4-ksm_fixv2-v2-1-8b61ad0491f1@linux.dev>
References: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
In-Reply-To: <20261025-b4-ksm_fixv2-v2-0-8b61ad0491f1@linux.dev>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu Zhao <yuzhao@google.com>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usamaarif642@gmail.com>, 
 aarcange@redhat.com, "Nico Pache (Red Hat)" <nico.pache@linux.dev>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 009B640009
X-Stat-Signature: 1b6mdai5cy1tbpah8k4taqeb85waxxio
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792950043-297587
X-HE-Meta: U2FsdGVkX1/q/f7+M8EW12/Nl22JsF0UH4j/j9CxdaCqttRR6r6ODIeEMaibOZ3cbRy3IB6zikYUjV7xDVHpoe9uOj7wmCg37l1qrCHbK2XrjhguNiVvq43Ir9PniWSDK0/F/9v2hbevw/8Zk3+c21QkeO4snMZ62RuXg27dtEpYZ0oBUop/g4H7IuEkgsYf1XSB0eS6k3bGc//PoM5rUBZY4KzFGgmhhwh7V4poBB31VK4V9ZNE6VaQl1w9ccqmsy+mFwZoEdxafF0FiFZLoJ/A/wRNUyNKUOlboYSyqkTXpvRXGcncQTndfgngh2XrK7mLZDkPo8pIb0QarJbm0YVB1vLjW2Wx36ptPe4CVa9s6gKXDQwquQfX6tMlqkOyD/wczy/bRqMyuu5FSqUFnER8PsO5lBJsdjn8opkAx6Bugey7cJswUQGVUeF/9Lrf/u/H7/8LEssG3nIP3lbHAWYPbiGN1Z+jkrJOVO6MSQh3vN9UtuThH0VHIiD1xpGMv83AuIUyBngJbG8vuipvDWrqep1a8YysRvEhlVzRwCbNLT8S2dIYeI0ReLKQ8BxuixYxBttdVVQ5JyeeCEcPf5NoajCy7kt0XTtSFRA5oQfPo3VDm4TmATOyg1z9RrZOO94X5WnrdP7Kb3xs1j5FyNgwWJNNca8xaMI895SRN/A4PMbx9kEZsEkCn+6w8cvkZBwCcX9fhFQSkZrxH03QE2HQIPrFmaXyXv/qutCJSIuqWqRPmtjlOAup987ztSFHBKniUvKikeu2exlLUx574lFcnO6lvQ8N/QjjzfqvRosDv0BP0zgwV6hOA5u03npD35rOhMpXwsbnvdH6e+8T9ZBe5jdY/TKzMUYjTg154xD4beGMd7Wvj3SWqlrik6EmENYPYB+rHP6kGdWN+b0agmi+CUuXgSO+tGbcQp7C+Hy1S1i6QsR1brA2dw/vzOUMUtpQWwx4rc7apsRMdIB
 CfNpbvLi
 E6PjHneBRCi4/L3gJpySSZChKI6JH05DE3vGnhBmGFBlkdpSTLxxenNeB35ve0Aj7iCnPxuJSouUrNT/MvtHD1VW8eYB1mZaxb6NheV1KRimK4ikNwVUuQgw8aBX9Dc8kF4mIzdsgujXqkhsVIJyiHC8CpfRFrthfTgFVqmL+xgazxqqFMKUg4dwRlNsVSTp5lHor8b+tRqpnJXLqmBiQ7AX6zn9grflDBDLvGilQHLKU1+BodkkdwhGAp8ipSwPXX8+b5rCpWR6QhbnWNvmM9KdMmEz7KS2S9BhfmalO1PXvx7KLxoRB124Ev65qZLWGcy5hpozk7Heq8IcPSZiLifYVDPHnOWdCConTIkE8kHl8B9s495cA4vGnMTYnVwk8ry4g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The zero-page remapping in __folio_split() was added to support the
underused THP shrinker. When the shrinker is disabled via
shrink_underused, gate TTU_USE_SHARED_ZEROPAGE on split_underused_thp
to avoid scanning subpages for zero content unnecessarily.

Suggested-by: David Hildenbrand <david@kernel.org>
Fixes: b1f202060afe ("mm: remap unused subpages to shared zeropage when splitting isolated thp")
Signed-off-by: Nico Pache <nico.pache@linux.dev>
---
 mm/huge_memory.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index bd44d58e8684..2d56d1bff0ea 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4104,7 +4104,8 @@ static int __folio_freeze_split_anon(struct folio *folio,
 out_no_split:
 	local_irq_enable();
 	if (anon_vma) {
-		if (!ret && !folio_is_device_private(folio))
+		if (!ret && !folio_is_device_private(folio) &&
+		    split_underused_thp)
 			ttu_flags = TTU_USE_SHARED_ZEROPAGE;
 		remap_anon_folio(folio, 1 << old_order, ttu_flags);
 	}

-- 
2.56.0


