Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD664C44532
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 23:41:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 912EA6B00AC; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3306B00AD; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F0B76B00A9; Wed, 22 Jul 2026 19:41:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0CC4B6B00A7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 19:41:25 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 57D6F160154
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:25 +0000 (UTC)
X-FDA: 85018036530.05.F0FB4F3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 554E5180003
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 23:41:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TFzoNq87;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784763683;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P04kqb8kM0nfNoJO47LUqR6X7j9KGN3BIksq+8jvJR8=;
	b=gM4lVnhjCHjurJdmBaSIfh0z7pGDEb9ZX9o/B84DaLQCusxiP+F28NZo4HNN4R2QNOTP7b
	D1qJaKpQkWI1WTFGbQmhrzLcUM7Q69wC7T1ObAacFtvfKEDcAeEAf9O5Yt2BYLz48ytUOT
	5kKUmA02Cx7FPQInxITZ6hlfsGgeBbQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TFzoNq87;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of devnull+ackerleytng.google.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+ackerleytng.google.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784763683;
	b=TLihKyXs4QwDY1okHRnBPrw+rl9qxu3xcJRpc5OvGkZ9GEgkyv88P1mCW5ebwrnfXykJhl
	rPBhkrMyjrRKuE38G7CKUN7ZStdBOiYI2VjLC/SKeU4cVHzEjBp5JCEHpJymli7NdEjXDb
	N1ETcOhBkX5Ql5cTkCf++a1xHwbcTDk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6968B45130;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4A4D3C19425;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1784763680;
	bh=5jfm2MbqP71BsjfPjrd0Br42vvUHXqP+s/GdXagyPXY=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=TFzoNq87S38GGo6Ssm7lOwhxQZMCtuARuGEPFPG4IS5BpH2vy5rIMSFiaSyYpl4mJ
	 Xm0VJdnaW6UqgomQ7nAzsoeX2WAIQnZ8lT26S5m7JpYb1ESNUWOYt1V8cx4zYeqQLY
	 sED7WuyAx3Q/WXzc1/6v6MYjVuPRnBB9ahGBSYFR90eqZ1Bps6JovLDKWQ2XPcuEjy
	 h9tq65Q6RqTBhyMp3VmgKPnOLD1k9HsiVZpHD6nlbAwyV+X5dUnm/GHgtuNoqeYTZb
	 pCqBsZimkvBmjF9jR1I9VI6amHsMAUhQ436dSFTfZ79Qe3D41HpWxv80/Yo3E4sdx5
	 FVhF9YAYEb2OQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35563C4453A;
	Wed, 22 Jul 2026 23:41:20 +0000 (UTC)
From: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>
Date: Wed, 22 Jul 2026 16:41:15 -0700
Subject: [PATCH v4 07/16] mm: hugetlb: Fix Use-After-Free in
 unlock_or_release_subpool()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260722-hugetlb-alloc-failure-fixes-v4-7-88e8b81970dc@google.com>
References: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
In-Reply-To: <20260722-hugetlb-alloc-failure-fixes-v4-0-88e8b81970dc@google.com>
To: Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Hildenbrand <david@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
 Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>, 
 Wupeng Ma <mawupeng1@huawei.com>, fvdl@google.com, rientjes@google.com, 
 jthoughton@google.com, Mike Kravetz <mike.kravetz@oracle.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
 Shuah Khan <skhan@linuxfoundation.org>, Alex Shi <alexs@kernel.org>, 
 Yanteng Si <si.yanteng@linux.dev>, Dongliang Mu <dzm91@hust.edu.cn>, 
 Hongxiang Lou <louhongxiang@huawei.com>, Miaohe Lin <linmiaohe@huawei.com>
Cc: vannapurve@google.com, erdemaktas@google.com, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 linux-doc@vger.kernel.org, Ackerley Tng <ackerleytng@google.com>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1784763678; l=1786;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=+8BKlqcw0osweyRZX4DVMuCuKwenNXcfBjXVW5HQiFI=;
 b=1QJ1v6HnKCN4SUgfZ0zCwSM1fabe4JN3I0E4aRntYBp8Vk2QcabaSyeAnsKBGGeTC3Y76lQen
 YmRVqUCR2SyD0f88goOEuJb9brctkXRJonc3/dbLVzTo9GlGyTpg6do
X-Developer-Key: i=ackerleytng@google.com; a=ed25519;
 pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Endpoint-Received: by B4 Relay for ackerleytng@google.com/20260225 with
 auth_id=649
X-Original-From: Ackerley Tng <ackerleytng@google.com>
Reply-To: ackerleytng@google.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 554E5180003
X-Rspam-User: 
X-Stat-Signature: cszib4q9fuzec4py5y5ykoocx8sfak3a
X-HE-Tag: 1784763683-102797
X-HE-Meta: U2FsdGVkX1/nD+vBlwmJRvSc1oEoHaUTwEE7t4he6YL83wM1t9wtWP0WHRhNxkvKJr7YpfNHJemiz6r7eYA7f1afXgFpYHRMbps51+pBLvBdztp4QPVZ82XIISgMxUsMZ8whhnkTjppGN02+F5GHGnVZN9eFUOrsfnT9SRZy98pCtYGQJZ9pJE5einWiWqK0J3PzQiGyHmEHyHuXiIHJYSl/lMArHWz1bMofC8iQgMurYZ8N2oV2jfShTWW01HbGD8fAv6vR73s0Nj1XP41SUFNfcJ+R+V8F1OlNmQns7a67AuQbmDxYkvRa33gBuHWeLCj0yOLO2sva11PPjZYGr8x2lB+FsZ2SfBsrP/mEfBlx6aKnC4EUcqOzesI2x82+0JP16s07NmjCsaMCehe8La5ptbhembPndNao6GKTpiFS9tjAr7OGCB+Ur873QR5ntTWYijxctZx6pULcsJHbsuqzYSm+upbQHxuV7BGLzuGgRmHwMMCca2gnCT3qcloCuJhojLmzNBWsml3VLpugjnq7hqFjWQpKf9DnDmBYQ4sHguszbfY+kE3ej90R+CtRAd/51iv1bD7Qo4UK6BFyu3MpM4lyIZY4/TCI+58+8EccsGKefI9aTmL3YyZ+VR8k2TfoH2GBcw2NS4m5TcRu62SKRmtWl64xWVyot9rRx380Dc+6Dh6dUcNfAQg4ku7dNu8/Xn9VtKH2NESnU0WZJ4xpWPCUJahQGdnFKtzwTV5aq2Klsh7LoWFkLlMKjMsT1p/QRHX5q6O/K3QEfuPAfB1XI70OX5WZV3XvDw9Sq1kzfn+cGxqz5bVslQZNwNmrYstGUd0Vb+eAqCSntiPscqbZDpp+b+DUIhQzMCl96+rUGTmy0pG3Hfq980fliKFlj+afMqw30xYoh120ObMyTBztvvR6xWY/Ql/2UHsxNBIZdp6gPfAhBLOnbcf5YZZlRGXHJ7sGF2z517qCL1B
 FERB88lX
 QXb7W5as0QZQZTq1eskfUNS0SA5UZtcFUv0FjCT0sDehNnwBfoDaFIqa9YsWIHwMac/b29nAdxwRdDL8tDsRjBtqiyD0HuHC8vncJy3ZBe4UdyxyaAe5VWF39zb80nO/+6yRC4LKeMrmAp9Wis3sdE6t/db6uIiXTFbfIKzxVOVWJH7Q7+N5W0nt2gn221kzhbefTJPqrzp9inWIL8Bu6fvbg/E1OIE0EmUl6fQgQXmeOt+K2Qhe+oNNjbTY3c8Oc4MhxdBs8JT7lPqU6gEVEamWMUibIEI60OInvgZQfwn5ZbCoil4tdTtHKcE2RUpQuxkrF7oCR+PBfY7ljeaacaH41oyBG3pTF9hnNEkJMdHAYj7QoyHpZ7h0LCVwCAk6EoRQEpCrgfRCZ31t8GoXTWGEa4dNRBAU2Z5hlqdhyDSPPbnAgVBh/NAaorc4d12jmjpNqN2/JqQh0S4068AOAgODaul6AWelgOJVxtwpFbpuZkkHFY47AsiZ5hVi7qGkaZ6NVXlMKbWOoTYurFvlVew7pBw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ackerley Tng <ackerleytng@google.com>

In unlock_or_release_subpool(), spool->lock was released before calling
subpool_is_free(spool). Because subpool_is_free() accesses spool->count and
spool->used_hpages locklessly, concurrent threads calling
hugepage_subpool_put_pages() or hugepage_put_subpool() could race when
spool->count is 0.

If Thread 1 drops spool->lock and is preempted before subpool_is_free(),
Thread 2 can acquire spool->lock, decrement spool->used_hpages to 0,
evaluate subpool_is_free() as true, and free spool via kfree(). When Thread
1 resumes, subpool_is_free() dereferences the freed spool pointer, causing
a Use-After-Free (UAF) or double free.

Fix this race by evaluating subpool_is_free() while holding spool->lock
prior to unlocking.

Fixes: 1d88433bb0085 ("mm/hugetlb: fix use after free when subpool max_hpages accounting is not enabled")
Cc: stable@vger.kernel.org
Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/hugetlb.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8431c00d48267..b759748468734 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -137,12 +137,11 @@ static inline bool subpool_is_free(struct hugepage_subpool *spool)
 static inline void unlock_or_release_subpool(struct hugepage_subpool *spool,
 						unsigned long irq_flags)
 {
+	bool is_free = subpool_is_free(spool);
+
 	spin_unlock_irqrestore(&spool->lock, irq_flags);
 
-	/* If no pages are used, and no other handles to the subpool
-	 * remain, give up any reservations based on minimum size and
-	 * free the subpool */
-	if (subpool_is_free(spool)) {
+	if (is_free) {
 		if (spool->min_hpages != -1)
 			hugetlb_acct_memory(spool->hstate,
 						-spool->min_hpages);

-- 
2.55.0.229.g6434b31f56-goog



