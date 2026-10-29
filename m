Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD6EF606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kSJM4jh0
Received: by kanga.kvack.org (Postfix)
	id 88EF96B05DD; Thu, 29 Oct 2026 16:40:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8666B6B05DE; Thu, 29 Oct 2026 16:40:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77CA26B05DF; Thu, 29 Oct 2026 16:40:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4FEE96B05DD
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:40:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6BE94050D
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:40:40 +0000 (UTC)
X-FDA: 85376832240.08.EB934D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1116C40007
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:40:38 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSJM4jh0;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QSDRgnr69YPTIztges5CfT2KnEGoLvf21RQ7Ru6EwMk=;
	b=3CBjBt7paVOqiAPzYrtem222Why87N9U8WlriRUkmwt0iDLw8cqS8y8PnjOfXQq34GI02i
	M3zg9LRE/X8tpOL7OAlCeJxBvjA/HbQIn+FJJLHexyJeIcF9Lj68do2ruZu5sEvgU8Y3Z8
	8a+KnaWxyB1BWWOhpfhhL86Sy21FawE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kSJM4jh0;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306439;
	b=aq0OH4x6kNIgK/9PE6qukaYGi5hxZ/kHdBGmnF2yX/d3d7Mde0xNdb23wHkWi698+B3IQS
	I2IaC8wvc+giP2JCnjHl8a2pOPKv2ymFJ354b8jBTxwvdzWO5PP81h40Ea03MK+ofkiDeP
	zF8xM/zcQsGCC06lozdTcaNLNUfizAw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 61A2C40803;
	Thu, 29 Oct 2026 20:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F16E01F01826;
	Thu, 29 Oct 2026 20:40:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306438;
	bh=QSDRgnr69YPTIztges5CfT2KnEGoLvf21RQ7Ru6EwMk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=kSJM4jh0HrN4VoBlBOqhsPGwGw2Ay3L6UkwB26SEadkf6ghUVo2z8TB8QCJ9muHku
	 5O77SDUckn2sO3yoVq/4XT6gpdq26chxpQr5jmd+TFr7yyyjMEAT7vJlAlHNi2G586
	 9dRzcbSiqzIJZhkYCZd0MkRZjlSqG4A/IqkIfPVXCSD+uJYrJlLddKokdFu1Lpj4s+
	 AM4Rg32kxI2Hn7JiuuOIn7WunGYp4G6VoTkDjcU1gizGyXkzJyZ9GEOxzwegUo/KUo
	 f8ea/Z5QTtcFqqdC8XZvDhfq5KUMWVmWRyPkk5jZK+YupM1MEDamRB8Ea2ZIKljyXO
	 MS5d+tWdUKOVw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:33:24 +0100
Subject: [PATCH v2 29/47] mm/mmu_notifier: set ->mm only after mmgrab()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-29-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Chris Mason <mason@kernel.org>, stable@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2087; i=david@kernel.org;
 h=from:subject:message-id; bh=c82hKzDD/9RIfU3f00HaLlK2GVigMUUm/EjoMU8UlA8=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer+3QEZsaWVS8/Mt/6UkCdn1zjjE9rGt3nrrZJ0dxZ
 1tMXZtlRykLgxgHg6yYIktQ8H2Dly/X1Va78THDzGFlAhnCwMUpABOJ9WX4H/prQtCmW1M9M2oK
 9NuZ999n01ZTbl/OzdHgtG6HjKPSZ0aGF04lWz43hK3uUjCvqbrEzXLhdlBiS+zbzR6tTzNsL7N
 zAgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1116C40007
X-Stat-Signature: wkqbpm3bkbd3a7kpf635x3smm3qeamqt
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793306438-289325
X-HE-Meta: U2FsdGVkX18ysm6emGemAHhHQwMZqC82T/DFa1VHyKKyv8rN5V58qNVYOXSl3I+yCawCQTFFfvYZkICS4AxFyFVcg/klO+/1yMaypP2Q/UUgB+3+9jlRrD+0MkNNkD23OnKDSTat7TbVA64MCww62/oKug3WkGxKcTwUQFKWQMEnvsl/gNYAjn5EFOEEB9PQVgR8PwA2jeA6RAEB+IHU+H32hBTuTzZ1EMZUKrSVXUgrj5HnEmqoKgJnQVqBHZ1iWI61l3gJ9dELLPicGBQ/xKL8lJ9FodTkBvI7oOHa861t8f06y+x1satsnBuhwrZqd6uJKdCSVoRnkYLVQCZU7QlhsFcDYULOlvSC+wJwjgSfpyPrsDX3Re5XH7D0EKokY9KMPqaAqP8/x92vRMz5+f6o43nGDNeTkVFkmALSK/ZZgxRdWEZsVyk/1unDg1m3QK9I4AfJ2UwUzAkZgzV/4CVyfnlDOK6qUMtl4HN7IeHlCGX8IxKTYKZJQ1jRW4/3b19tRgqf3b6HdsURDzcaTALR2cgXY/8DL8/kVm2KdmLND8YrXPmC8dFkb7CE4UywZcljQsx3usk+tMhN2jcJMPEzVwkQBgCD/b9IjrbleEKDEZFB0Az4X+GfgDNFstHXdTwEdiSZznutSkVgnKmSHkITASYtiHNyKrpkUS55gOV600Ml7hRXmlam0Qyj5JPorzjFrQITZcJAbs/N2S4OEr1HZpk1li02sINcw3tbmRT4kcDGNaslAfttlMW5156UIPT7VUQYU3D7CrJjamG+VpfbZr3WmiA1+WKT9q3ritRWTMTtYUw78evE7YK2dzTWfY3LHQjHB++N2SlNNq5dusyXSOYVT5lOj40PxK6kRiNp+7SXk1W1q+l8L26ewy5DgM+w65sgbuHEhv6LeuPRhlS3h97ErfLioh258JPbZfoVOLzrDeHnv+rywvm5qLM+YS5hC0nEfeN2vmIAvGz
 dUReiEgW
 G3y9/89lgtd+HZ0mn2ZYSEX/+BBn06nLW2u1h5WpZV4iU9frqk2+TxH//tPbuT/Jdx+aYpS6ZoUxNQXoHq8zAx58Pk+EuzH9Q8MJNmbL7SlzyLZutRtuYcCYtoRmyPl5mSRbXN1iBwdBK4WgKiFeW0qRQwYMENG2cLP8UtCoyelsWw/VW18q9ZcGf72e05GJmiVHVa+teK6FzG609O5kaWs432HfBY+K9Z5COLjuEdEWy9KaVoUxtgxoXu/VnjTYWYKPTPt8JgYmQbAWdu4G/Nz9LgFbc9D8xPLwBQkal8XEwXki6YpAckDsHn/OK+r2A82lHoJC+C1wZxTxR7MPMW64z00BZpyGl1DemC759nP0BHPEWaJQ3k935/tgVosNXuVFxIbJoUaGrH0VsLY1De/XjHo+Cy7SAROqaXmfddk6/L4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Chris Mason <mason@kernel.org>

Radeon uses a non-NULL notifier->mm to decide whether to call
mmu_interval_notifier_remove() when freeing a buffer object.
__mmu_interval_notifier_insert() sets ->mm before validating the range,
so a wrapping userptr range can leave ->mm set after insertion fails.
Cleanup then tries to remove an unregistered notifier for which no mm
reference was acquired.

Set ->mm only after mmgrab(), once insertion can no longer fail. While
we could fix radeon's code instead, setting ->mm on success only makes
the code more robust.

Fix generated by an LLM and sent by Chris Mason in private.

Fixes: 3506ff69c3ec ("drm/radeon: use mmu_interval_notifier_insert")
Cc: stable@vger.kernel.org
Signed-off-by: Chris Mason <mason@kernel.org>
[ david: simplify description ]
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/mmu_notifier.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 2e20f88e162d..a7bae5de5fed 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -947,7 +947,6 @@ static int __mmu_interval_notifier_insert(
 	struct mmu_notifier_subscriptions *subscriptions, unsigned long start,
 	unsigned long length, const struct mmu_interval_notifier_ops *ops)
 {
-	interval_sub->mm = mm;
 	interval_sub->ops = ops;
 	RB_CLEAR_NODE(&interval_sub->interval_tree.rb);
 	interval_sub->interval_tree.start = start;
@@ -964,8 +963,12 @@ static int __mmu_interval_notifier_insert(
 	if (WARN_ON(atomic_read(&mm->mm_users) <= 0))
 		return -EINVAL;
 
-	/* pairs with mmdrop in mmu_interval_notifier_remove() */
+	/*
+	 * Pairs with mmdrop in mmu_interval_notifier_remove(). Drivers take a
+	 * non-NULL ->mm for "registered", so set it only with the reference.
+	 */
 	mmgrab(mm);
+	interval_sub->mm = mm;
 
 	/*
 	 * If some invalidate_range_start/end region is going on in parallel

-- 
2.43.0


