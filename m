Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 980D0CCF9EE
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 06:54:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB3858E0094; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B3A88E00BA; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 806038E00BF; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 676CA8E0094
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 02:54:14 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 279FBC03DE
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:14 +0000 (UTC)
X-FDA: 84057495228.27.1665B01
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf05.hostedemail.com (Postfix) with ESMTP id 315C3100003
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 06:54:10 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761893652;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=T7rMLjqwsC8w/+e+VeU1NuX0oG3pCQi3c+3F0cayWTc=;
	b=qOHgFNfBEVH+72B3EZ9ilT3B2OluXb6hRwHzXXxOWvjjNwUe0jVIxMx8XzHBXj0MzpqqYN
	rRDaOxl4FqsgRE0Uw90U5q1cGTOryllZZQoPKiYvAzPDbtsInTVoVp5iSMZ51jcZoCZ102
	aHR2/q9fNVzyK6x92WpmERb6wPcsHcM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	spf=pass (imf05.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761893652; a=rsa-sha256;
	cv=none;
	b=8ThnY4jw2BIhpJ5VpE3kR8gtD9vpNCe/u/2kKgj5EyyWBO1x/eShXlJd6N9F0XRzUprkLq
	l7gN7Vui9quaj8yFJcuUYc83S+HpHO1Agtkw/sTfMJO7xVon4tIJtp6hyhRgirxyGyaWFj
	aKSdnUOTPpxBXuqWct/gybvaRICQzxI=
Received: from unknown (HELO yjaykim-PowerEdge-T330.lge.net) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 31 Oct 2025 15:54:08 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
From: Youngjun Park <youngjun.park@lge.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Kairui Song <kasong@tencent.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Chris Li <chrisl@kernel.org>,
	youngjun.park@lge.com
Subject: [PATCH v2 3/5] mm, swap: Remove redundant comment for read_swap_cache_async
Date: Fri, 31 Oct 2025 15:50:09 +0900
Message-Id: <20251031065011.40863-4-youngjun.park@lge.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20251031065011.40863-1-youngjun.park@lge.com>
References: <20251031065011.40863-1-youngjun.park@lge.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 315C3100003
X-Rspamd-Server: rspam03
X-Stat-Signature: 85jdnzuzy3fqohr8nq83n7w4fnfdc5as
X-HE-Tag: 1761893650-322840
X-HE-Meta: U2FsdGVkX189jwuXE9lxLOZ5G6l80hsAaQdbKo4d4LtKAij6Hjj6bCo326MTo3Z8yNuCyxgt7lBLjEgyaeWEf0USoyvUEMEm+WjAIkwO4uIvlBiMta30nzQ+rMtGZPJpoTrmxZ+dR2RlDdHrF9wlScFUweGz+uIt55B+joMVti/cPb9Emn80+v0N3Y4W92Bcamry3kBE3mTFQV5rxbQOQ10PYB3iQgHPPnzOO9itk4CC3HsxdyqU93+CCZ8vzS/kWmPzEnlCr52Kv8FNHnGVNRXHUdV8DMDklYjV51Ez3rPeq3AoC+/ta3IjC3DReVZTB1IJ7NeBNZGeBkwm0pnF7mqdX2yTmyKPFi7LU6YuuZWh3UepaEdRTAo73zjICsdnHk+7poOsyRfIyGuWw2Xi4Iy5GYkoad6kCHIikEACGWt2yNUr+NuGo1iX7uWgDxqdJg5ymmhRxaCwLcS9vMUHjYZJx93Lby6+GiXdQrIz2mUv5m7ZzrPEI6UEOFl8FmQsPVLpEfIJQ4ZMLWMNicNVefbhLhXk3eHK4XyGvXaJSAF94Wg2gWie1+2wOh9PXxzxEXTG8u+tABReZMPuwE1ng8pRnlEVviGVjSJi57i1IEDVNEWKh5q9FY9xxf+E2RIjxFnMP+47iNatZ6EfemMIUMFmVdYrovTRPsFnE+GVssO3OO89XSSgiyCgBM6THAI52nX0QUSGvLPgZZ3W4X+Cai4FWkN0XXKCX4Atukvm6lBJj9ADhti8CYPT09j9KsIe758pBPGxONjVXb6abMaTo3gOYalTBc8ONuE/Oz9XjJzs7Cwt8rVmiJgK0uRxR63N9fQGm+iktmK5Kd4wpvek0Z7IssHkN6DU+5lI6/9s6wB+ZdCBQp5B4znPNBT0lZK113gbXIS2XcA8DfFLUV84ooPtLxT80xBiwqIUJvjlOCLEl4VMv1UkkKVT/mWD7p+U75TZhXw838U/kcezhnj
 rSXNZ9eH
 vGTOWx+JJjJ+34xFA/jOCAX9TX96laJRdRiEWID2ahCNFGz8yBPn9Ms5xs4PWaAkI7dGfT8JQmDgM1YXUw/oiRca3zJ/D9jLMpXKgHU+ycT94xo1PXkl24HKwp/E6u4J2VUUVNuA/wm4EAgfIEQNfqRZCOf9McFJs5VupgFzQap6R7fMS8gT71vsFhblSf555fMh8I/nrnSixs0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function now manages get/put_swap_device() internally, making the
comment explaining this behavior to callers unnecessary.

Signed-off-by: Youngjun Park <youngjun.park@lge.com>

diff --git a/mm/swap_state.c b/mm/swap_state.c
index b13e9c4baa90..d20d238109f9 100644
--- a/mm/swap_state.c
+++ b/mm/swap_state.c
@@ -509,10 +509,6 @@ struct folio *__read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
  * and reading the disk if it is not already cached.
  * A failure return means that either the page allocation failed or that
  * the swap entry is no longer in use.
- *
- * get/put_swap_device() aren't needed to call this function, because
- * __read_swap_cache_async() call them and swap_read_folio() holds the
- * swap cache folio lock.
  */
 struct folio *read_swap_cache_async(swp_entry_t entry, gfp_t gfp_mask,
 		struct vm_area_struct *vma, unsigned long addr,
-- 
2.34.1


