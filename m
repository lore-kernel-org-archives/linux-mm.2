Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18402CD37B2
	for <linux-mm@archiver.kernel.org>; Mon, 11 May 2026 02:54:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688CF6B0088; Sun, 10 May 2026 22:54:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6397F6B008A; Sun, 10 May 2026 22:54:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5507E6B008C; Sun, 10 May 2026 22:54:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 462BD6B0088
	for <linux-mm@kvack.org>; Sun, 10 May 2026 22:54:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 05DC4A0553
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:54:31 +0000 (UTC)
X-FDA: 84753620742.26.A7250EF
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf06.hostedemail.com (Postfix) with ESMTP id E90BC180011
	for <linux-mm@kvack.org>; Mon, 11 May 2026 02:54:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OtrDo2C1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778468068;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=rwo92ed4cIHmGejveTVccOrdOc0h+7Q6Jv7ulCR5WYw=;
	b=r200kBAHCSGct/69vKIGIL/CMjLuFp1Ch25zm9AYR0OEp/MYiOYTB1Zq7mLQuvGR6wwvTx
	7FBBiY7vQ+JM/k9xswv1GDItELz6FqhISXoUBshnj75E0kMG3T00ziFLNHCwBL4Iws6ERa
	uHrWHdidfaYdYeuWeup5jFgR0EmIHuQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778468068; a=rsa-sha256;
	cv=none;
	b=TbJuAiKc2uFs24GvpT25FrBmjeE5EdVG7JY/AZqYivfznQVTtUQ2CFusVFxMRXd7bXZt5U
	dxSWg8TuLXyJoOd/mwRIGpTAmVzsAJ9So3ZDOysNljF6LNBlkYemh9V33lo6/yaNG4uIf5
	Hr8zm0SD9WitbOTkeXvV6M/IJCS8hRg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OtrDo2C1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1778468064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=rwo92ed4cIHmGejveTVccOrdOc0h+7Q6Jv7ulCR5WYw=;
	b=OtrDo2C1hr1DFmyUCYslmNu0/aYQfTspdAMdgG4Ug2PC7PIUiwL4mHtgQX0aqWAqXxYhan
	mSVxg86fuYskf+fg9lVosAKDG2RTirSi2SSwOKKGcZ5L1QkPqiSOCVO1r9R5+4XkW0TfzW
	YleSf9VQqoxoql5twpmr5w7N07957m8=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Xin Hao <xhao@linux.alibaba.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Andrew Morton <akpm@linux-foudation.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3] mm/khugepaged: fix inconsistent MMF_VM_HUGEPAGE flag due to allocation failure order
Date: Mon, 11 May 2026 10:54:07 +0800
Message-ID: <20260511025408.54035-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E90BC180011
X-Stat-Signature: 95by7cusymu9ty5j8ypeozjqi5ymn5sk
X-Rspam-User: 
X-HE-Tag: 1778468067-923927
X-HE-Meta: U2FsdGVkX18SGSIVrh3KtJ98QsHkF6E6pexAU/Jv/J5wD7ycwlXUd78ymwAOPJhmc0ZInquvh0jOwCZS71YfccZ+puQn+uZBrBg7Aj4qz1ORk6g9365fGhzCcf3JePL5Rzn06DcffZax835QmHQ2altNhr+rm7XCzwLDjwCENDw9BvelclmRd9wLLmPheRK6L9BqJqOtWOm7Dsx9bPdz9hfsYIWIpYF7L3Iau0zXgI5KsEy1kOE8H4anKpv/xshPksrWfQmkWHF0euatufTt3QnpqWzU9HJORpvhhRuYSgfQ6LhRCxKu73NQoF0dFUcdfT3+jU3iUS9AB42OjfytCDoAQwN7nwQzuEuZGZ+1KZNE35VesnyUAxcNM77Z6/Lb2M251DgCoGuVA//shmSus+BNsBSxP8xNUwY5Ek8AAtZFrcZnsrlff52f3I1555a2K+LaEYXa1hKDIfCG7SSZU9j9DUneWoPP2Fc1nmQerQmzqlPOo0/oPxQ/eoGhq6p2mVtyhrNZFoeWkvJB+Nbw0Au2JWdv17agjEgeitfum2dlR9BeJtPikYDFF181lEc6UVHrfj89N8PUPA1Cgp+xAvsEMgwZtPM5RcdziZzQ8sT5l6VUyXdU945gkqVmHkolOFm741UKRdTymMMJlQ62BeXnLxOaGsGuljcZbQdqbcn4+Shhg+sL1tcVlctUy5P2WiSTjy7sypopTMFckfTJ3Xi6hkKi6O6TJj8vVuScifHjpWCsw+XR921yaSqqU5+vTKEBjYiFdDmYrkyPsWAPPku3duTuL59GKtsyzqaCRa4HuOml/2ROA3NrgDYXcF1jSkXIgvWKlN0rD0v8/zlICLLhq7qbOAOuI8yRw1Bs/0axeBw/JruBmHBFEpxPMkhr1TmvKOVs+/NF6kFPGZuW3IYjLHOwZPDywdRclMApjMS8MEsZLeXbcw+CMqY4cbQTFjlFLZC9qj6rpUYyJtb
 GFHqrog0
 yMZBHjFS7CTy7iRVhFP/grPU91eQA24W+axX6y2wd0esA8TPax/r+JVlXOxkPgoxR2Ro3QNVuAZyHBFG2ot8UM8OXvFuAT+3XkNTYrzJtoMJOtn07DDb8hGaBW4F5W6mcvxQjYFGepAAPGxQoO8OaV7QUEhjMI1mUzhUotBA8v5nLNTwoykkTvFgpVdEnoSmVeWn/2jBVMwQ3XZ7sdcKVmZCVv/TorXV5dEzSw7XHpz8nu4AfbdyqzHzm/mxqEjxt/cEbnN+FTGMPOOg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

__khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
corresponding mm_slot.  If mm_slot_alloc() fails, the function
returns with the flag set but without inserting the mm into the
khugepaged tracking structures, leaving the mm in an inconsistent
state where future registration attempts are skipped.

Fix this by reordering: allocate the mm_slot first, then check and
set the flag.  If the flag is already set, free the allocated slot
and return.  This ensures the flag is only set when the mm is
successfully registered in the khugepaged tracking structures.

Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for "struct mm_slot"")
Suggested-by: David Hildenbrand <david@kernel.org>
Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes since v2:
- Reorder to allocate mm_slot first, free it when flag already set,
  as suggested by David, Dev Jain and Lance Yang
- Update the subject line to better match the patch.
- Link: https://lore.kernel.org/all/20260506012130.9306-1-ye.liu@linux.dev/

Changes since v1:
- Add Fixes tag as suggested by Dev Jain and Lance Yang
- Link: https://lore.kernel.org/all/20260501075708.327217-1-ye.liu@linux.dev/

 mm/khugepaged.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 5f4e009593e0..78735f34250a 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -437,13 +437,16 @@ void __khugepaged_enter(struct mm_struct *mm)
 
 	/* __khugepaged_exit() must not run from under us */
 	VM_BUG_ON_MM(collapse_test_exit(mm), mm);
-	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm)))
-		return;
 
 	slot = mm_slot_alloc(mm_slot_cache);
 	if (!slot)
 		return;
 
+	if (unlikely(mm_flags_test_and_set(MMF_VM_HUGEPAGE, mm))) {
+		mm_slot_free(mm_slot_cache, slot);
+		return;
+	}
+
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot_insert(mm_slots_hash, mm, slot);
 	/*
-- 
2.43.0


