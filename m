Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E9CFC5DF85
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:56:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E87606B00A7; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2E856B00AD; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4EF76B00A7; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 504866B00A6
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:34 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D6109120270
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:33 +0000 (UTC)
X-FDA: 85122551346.26.2EC28A0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D94FF18000E
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onLYRwOQ;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252132;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f8UaixjwdWP2/kZ06YR8XvTp3PNSz7mUI3mUXL1hpVk=;
	b=3rhZ+P5XwDnzOGQ5O9aBlH1ZikQ43075sX/Xl3+XEifyDYPxmbWUkos4blmm3tyt29Pmve
	E8q2TxwYU9mcSiCwjsK8LL0IUHW/NpXq0i1c19KAlHf9jmYnUsbxgtfp9ONDqD3Bw+6wVu
	NGJwLmr7WgkOk6Ynbl4TEtn8ev7N/zo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=onLYRwOQ;
	spf=pass (imf24.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252132;
	b=InoOXD/t52CBLwxhCU9mevv7dV7bfOe9+Xv9j4r0J128AlalPrGDzwCpdCfZAiKVytKPNj
	SCTzN6z/RL8pA887k82m/DB2oCnTYwGOp8ST4pxKy4xJ0BrkS0xp+fJvwirRulwMNl0jHb
	jYrWxZO/SDElkD7zBvgvMYHeAqbrCOE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 89DF344FD9;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 69EDDC2BCFF;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252129;
	bh=Hzwzth9JfzXU6G/7k5R13jr0cPcr7N3JG9oLieGcwo8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=onLYRwOQP/Q4tD/72aklmaQG2o4led0qUUOy3+WzTp8dH70FDgTPb0i3NcEtWJjnJ
	 98JKfK2PF8MYxbxfwM49vfZYj9uf1eYS6PpdFLlMz0kSfPgxWjzaSfibyhefBYdS71
	 XhfUPi+CqVgg0JGevJy4xCnegmfg+XsnBkczPc6yhZWft9uXKa4nEljRGg9xqAsRNa
	 SPorjdiKjiaN4r7JW7gjRzZ3jc7tjVDddIsz6UQdIA8KTtWAhUDG+C+TgeeT8bKJaR
	 ceW3nVZgO3lr5RFHZRS1ctzDBH7o+Y/ci39nrPQx7iulgrK99aNu41sUQQ1a+jxJR1
	 j/IRuezz+B/Bg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 559B6C5DF85;
	Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:25 +0800
Subject: [PATCH v3 12/18] mm/huge_memory: add kerneldoc for the split
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-12-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
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
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=3229;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=kkYICD6QbWqRFssjOxU44lo2ZuCNOXywu0Ctt6XQNZg=;
 b=iTb0ckBN6dHmAPctrV4Br62LLWX6ZAgNv/UeyxZEBzV+MXrW6V5bKZvdnEYS4etaaE7oZcsiQ
 Tnhy+6ivET2AtWL0LL710cO5ulJmEpy4gR0CElo5+/xpitRNlIxHA6b
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: cxtczngnyowowzqrc3ywrby1mhcfgxc3
X-Rspamd-Queue-Id: D94FF18000E
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787252131-606541
X-HE-Meta: U2FsdGVkX18XxuholXM1WJo8XplNjlHxySRgIjZaqjD9x2B5hIMeSd35KR0qmX7Nc03FLjbKHMAYr/LoL6gnAuBsu16tKSvbzDq48YD7Ja/mdUCSG10uS+tRW10j4jG0qZSIcTypLqzgrYZGU2xmsl8e2AkEGRpRy4CsWUP0Qn+CPVBo6pxdOE7bZhGN38Nco3LlhAM1V1Ia1a1ySYmJwV0DXbi3/FZkZCGK4DOhHaInocyFcqio6PaceW1trw9rxJDfZ7uhH9qptleUBUzsBIhXULo5WucyqiC9/rusxAqDhEaRkIQa9DwOepv2fWUdXHmWo6Nbb6aUM+LSJhb/2X4mZawxSfvRO0wpee2ldg1efxwxW+s0va/DHR2yXfwYTE3hqXEvAXx9x6Pgsk+8uZC+K6QVnpXf9NndmOGHLJJAxf8bSuqTEaH6qBHTwRpq9eYGydvbUE226qhNkTB/VjbYJTO5HypqIaqqIkWqMagBnXotO+Km9slCA1Me5mUq1OjSHAtGusGc5UWI3cN2QrIcRu/kejZf3/oH54tN9Cmlu5Y63Xg6X6TgekXnzncn0O422c2j1rdBpI9gJKkzc54eRV/8qh7J1IWoLcF7YkdaC6UMEsJuiTa5tiW+yjh7S3JxbcYpFPUbA0DHoryg88DDBPI+iwocy10h/TTEgeXl9gzs9JTtMdRFF1Do41Z0GHUtmi7tO+uyyj7gS2S8/4FoFFPjlUyZLuhTKPc9Z0M2xKqXIZQg52tBhgAwXr2EB72Ycx+sUFtflb3BZ76MjKZ4ZIPp+LU3DXfJn56nrCHHDOtnD4dnPsHS/zEGV8Vz8gsEZNu+wGhwVCONH54lhGcmYuD7edRyABf9W9rvD8rDgbI1YiU++8ey3PWgw7aa85l/DAF1vluR9OLuqJzDYXwzQ21Psbogb+5w/OH+2zuKOys0l7UZCm5NylNm2eMncHoK0YnfO0YoYawxs4b
 P49lsZfl
 H83T96CJVrspgwtQsqxdrP++QIvv1wLTNVGvmBViwiWJbfOGqIp3V7uNOKrB50zgCUOKLt469kqc8YnfpAaMKrOPPMwxKYN8m9/f3Lft1AE/bUKZuCzknog8X/49WZVROnEDFkSQXJePbnZeyCdl5woO6AwbgiPt+Z395cfb1OsDl7JXCgLIPpCCr8WCSc8fjmHrPvwovMg30G9OSvxa1cvWN1Uoz+ey5aaHBxGKwLV09miiyoHktnilfmxxfzP5svibGyK8TqoPoo0C4yicM33o5F4XSAcTKoliD/6V2FUy/3GvOY9rgF7IU8TWolqbekJlnUFL+NjAu+JL2TrXY9TE1hlWfmtUofnDa25tIj1xLrWFrLdAqXrwcPjKSmdZw7BnqDDuaPATY7H7+YKe5TNZ8KnPt0TA3k/oB4nhwFCL+ajAGphRiFGN6GSpcuhaSGTlv4zR3FKuYqbw=
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
index 0186238e0d1e..72b364a90062 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3928,6 +3928,25 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
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
@@ -4061,6 +4080,25 @@ static int __folio_split_unmap_and_freeze(struct folio *folio, unsigned int new_
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



