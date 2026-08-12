Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D717C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 18:50:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EBFC6B0137; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46D176B013B; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299606B013A; Wed, 12 Aug 2026 14:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C979A6B013D
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 14:49:20 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3235A8042B
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:20 +0000 (UTC)
X-FDA: 85093505280.18.8E6DE9B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 368D140005
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 18:49:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XX++aMIl;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786560558;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4zHJVSzXX1JrhGR7Q3NrJO1cw1ShDYbm/3wihgM9tc=;
	b=TKcXs1AyL8igNUBKaq8taEtmsBNhTXPqUUM+a6XOH2zs9p1wzu20T+qQB8hM7YNGtbtSYC
	SEszNYTOLtHzd5TLBKx8+1ug62FUcKQtqaGexTTeUWGQOZdFbH5OxkD6iIdKvnTPEfBbqt
	bECa4MHhitjPcwF4M9oRKb7ye6iIzLk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XX++aMIl;
	spf=pass (imf12.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786560558;
	b=ZMKLGXILN/pTr3PhooTKmdByDfO/7yuNkQNk6+GsxaAOCOMFITTu+P/5KkchwZ7OALJfUw
	jNXE7i3WobzERXMcOBsUvAM+gHDBp1+Al6oWYZ0m4DYH7nRnBJwMZdYn+9klrKXe91ABFa
	5oYzy2ggzC8dOjjohC5QABPHv4He4CU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F5BF43EFA;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 546A7C2BCFC;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1786560554;
	bh=JjjM3fg/aKGNITezeeJDvpfDoSmgq9K7Z/M4kmelVPk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=XX++aMIlyOmBPDiJyfbgHiq6BlW35+DEk4VJ3UVoulkP1DoK1s+C2+4ZuCYcWZtRg
	 qcWm5QJYHy/5pKSy5SYAEItzituZFu5LOBIA6RNUEuwFNTApTYdWbUyX1+m2GfOgj+
	 LHour2X6givacGgWcB84JVWvIwS7BA5HTUQOcpVkXjXBLwLhDjjC89apEqUv6R27oy
	 Dx5RvVZvjJUPRXgOY6tFZhFdPPckkOk9lanu6NnhlphX2oIbYOTMov3TH10/k94WxU
	 DPYpNoOL6cEBvOvMvjDEv8w1ycTUstFjECbbtcaw3jKQmqzjLwNSWK4ux/UG4fPqhn
	 YRFovH5HQjFSg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 40D93C5AD5A;
	Wed, 12 Aug 2026 18:49:14 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Thu, 13 Aug 2026 02:48:52 +0800
Subject: [PATCH v2 12/17] mm/huge_memory: add kerneldoc for the split
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260813-swap-thp-cleanup-v2-12-d2ee48c6aa49@tencent.com>
References: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
In-Reply-To: <20260813-swap-thp-cleanup-v2-0-d2ee48c6aa49@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786560551; l=3229;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=FhlwSOL3jcwUQT81uAoRstqIjxLtbsRoy84jVVwb1Vc=;
 b=9jyBJipVjAGpUZjWUk1tYRg5xbw9l3BNI+o4v5c9PQ7PpRl4b2c6SBlstfbKoKiwSvPd2Lxzp
 +eozp7aNoM3Cn76fqlLlIaMnPq7V2gmCAQso2WQcCGpCWjWaDO8KuPB
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 368D140005
X-Stat-Signature: hbirtgftp1eshotrigmnpzwefkt9iz67
X-Rspam-User: 
X-HE-Tag: 1786560558-535376
X-HE-Meta: U2FsdGVkX18ztTZVCsuhJZcqG+KtYPQ7+QWRBk2pr1Bvz1W16dKZ3ak8h0sNItKMdfTSQQmFeCLk1vVSLaly50WxYmDJPUwzlH39f7WTwveGNFi7TYuwuJRjNqggvTd7Z/dv9nHBHh27qQNyWmvhm2zYRJLq6BAzHjmykSHTYTpwAYBw+zhkVNNB+hcAoOU26Dit6+IQv0bi57jE/fE8EJyFZWVGqL79gPu/pNsFMSn/k8jf1pnQ5MGbNddljr5vZHLoNahqxkIfnWZ3KenNhe+zB1kqnWURMOfUKSjgzZwi9WYhL2baVL5PDHKcJUacZ2fRrxRuBq71tIPMjNrcujqj4MDktYieQL2DRyUgpc2ltvg5Phk+VfQFkVLgrCEx2+d9u95X+hLq0rU6bjkwu0c86fN5rPet0Bygaajrkm5P9LyPBpWTI4kEu9ufnIFh6f7jftkskEfEOAAxTJw5FlxiztaAJLMnqQEK969Fjwk0ry4xA2d+/iQ0ZnkRIrD3ZrYrMqWy0ZN0gJzjCD+7b3bLFXom0/x7tYnVVhpSE4XPM2wGH877C74DYfZQ5gc72ExPTWSmFfLHY5T6Cy1KxnfkJG3IPgMs61z+Vu/POjMIqgeeEBIjI7/6+biFmDmZSJ8SZJ7rlO30vVG7ITM1h0rNHJ1wL2W2+N42scSlhCOvLPDmwNL2TeRWYMy7jhTwcoDiAe1bCM+BioE5yCp00WWiK5qvwxFKpr0proaOOl1KLmy7cufOvBXMgB2GmbR1qMUW7e1UdXORmTwRxDyMthhOeGieMYEz9gIVt8pKKm6JhyR7c1wvw4jSckyWS7I0KPw9E83Pbps4zwChVTW4I5E2zmaMW7Oa9i2rIjZ3v1DcJ2jISz0qA3UqlHokgx00uRhQCo2cU9tQyDqClPN6+M1SOce+WxXc70YhESSXBrbPNcqY3RPGfSQHaUOlVR6bWJckTIvLhx+OMpAbm1T
 xG7Nzhnq
 IN3PcMZQZEoECe8A6RGWTMJUBz23Z3wCceDiVBZYjOMR23Q+DhZFjeWY5e1toeo+DdvhuoVAkUd4Bge93ATF8gnD1c0EafTEegEk9ZHoJaOgycuOWJeEG1rEhp1AMvlkko1vfkMkBiAdez+UatHBsQPlNh6S+ASJHNP95FcpGPPcSDAZ798I2QnAi/0qFgmN7MqCxRkyDMJZhOAlq5yLroQEqs43ebnrW8je1x3UzYbEep56pnLWRdOOWcBbx1Pr5R0h5z9kOvZ323968ImbDr8tOsaGs9ccIrjy3D+KBL1JJ/qWsjErWGhe1V01adxw1FS8Nr4t6w/1JKRq0QQBulRYMVQ6FtPDsWJicwu0AClesc2uL3Ddr9A3OWIRaF+Wbib3OSE/I4ZnGZRcoUbZA7V9KdBb2t1gfEIvUZ7mLn8lW8qqyDRgniB8WHT6/KDiWajoZl4JMHgfaMaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Document __folio_split_unmap_and_freeze() and
__folio_split_unmap_and_freeze_file(), and rename the file split
helper's definition to match its call site.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 67401c58794e..ce02608b37f4 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3940,6 +3940,25 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
+/**
+ * __folio_split_unmap_and_freeze() - split an anon or swap cache folio
+ * @folio: folio to split, must be locked
+ * @new_order: the order of the after-split folios (uniform split), or the
+ *             smallest order of the after-split folios (non-uniform split)
+ * @split_at: in non-uniform split, the folio containing @split_at is split
+ *            until its order becomes @new_order
+ * @do_lru: if true, add after-split folios to @list if non NULL, otherwise to
+ *          the LRU list
+ * @anon_unmap: if true, unmap @folio before the split and remap it after
+ * @list: after-split folios will be put on it if non NULL
+ * @split_type: perform uniform split or not (non-uniform split)
+ *
+ * Helper for splitting an anon or swap cache folio. It unmaps @folio (unless
+ * @anon_unmap is false), freezes its refcount, and performs the split, updates
+ * the swap cache entries. Split folios are unfrozen and remapped.
+ *
+ * Return: 0 on success, otherwise an error number is returned.
+ */
 static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_order,
 					  struct page *split_at, bool do_lru, bool anon_unmap,
 					  struct list_head *list, enum split_type split_type)
@@ -4071,6 +4090,25 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
 	return ret;
 }
 
+/**
+ * __folio_split_unmap_and_freeze_file() - split a file-backed folio
+ * @folio: folio to split, must be locked and file-backed
+ * @new_order: the order of the after-split folios (uniform split), or the
+ *             smallest order of the after-split folios (non-uniform split)
+ * @split_at: in non-uniform split, the folio containing @split_at is split
+ *            until its order becomes @new_order
+ * @do_lru: if true, add after-split folios to @list if non NULL, otherwise to
+ *          the LRU list
+ * @list: after-split folios will be put on it if non NULL
+ * @split_type: perform uniform split or not (non-uniform split)
+ *
+ * Helper for splitting a file-backed folio. It unmaps @folio, freezes its
+ * refcount, and perform the split, updates the page cache entries. Split
+ * folios are unfrozen but not remapped, they are faulted back in on demand.
+ *
+ * Return: 0 on success, otherwise an error number is returned. (if -ENOMEM
+ * is returned, @folio might be split but not to @new_order)
+ */
 static int __folio_split_unmap_and_freeze_file(struct folio *folio, unsigned int new_order,
 					       struct page *split_at, bool do_lru,
 					       struct list_head *list, enum split_type split_type)

-- 
2.55.0



