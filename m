Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 21802C5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 07:00:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2779E6B00A4; Wed, 12 Aug 2026 03:00:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24FDB6B00A5; Wed, 12 Aug 2026 03:00:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18D7E6B00A6; Wed, 12 Aug 2026 03:00:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EB1C16B00A4
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 03:00:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 69B57A2711
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:00:33 +0000 (UTC)
X-FDA: 85091719146.28.BF898B4
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 83CA2120002
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 07:00:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L8J0CWWY;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786518031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=54WVphyLueCZiaN46FTY/NZ/+uFXJ7ELUaT5/RiQtLE=;
	b=LjxlRV2V+hZ9losZvuiOe6ZWdO5qt9xDk/Q5EkuA7Xf3D8LSk7ptxYghKQqHrXIDDsm1YV
	DU6ZZjXC7UW4lL6MtAyn7et//2rv6SmXiE3LdOcKf29cnWHJtRqoBa4te+AzaaANqPCrOl
	BZ48bXligINPksYVxf3Bg45oK538nKE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786518031;
	b=Wdg5/rAW7+xEuHyRYzDnHESI+m3wTywU7ZlCFZ+NERBKKpVudz1kJ/QMnNzg0fsmCnva1F
	qNzGBQqFc72OaITwQBYe/gClFQhOr1XPqGIr26ejoJwdA1gwqw+vud6Mhl2ptQLsbYbGk0
	FxP8g/O778/itnREx8poEs1puE3NgXs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=L8J0CWWY;
	spf=pass (imf29.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786518029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=54WVphyLueCZiaN46FTY/NZ/+uFXJ7ELUaT5/RiQtLE=;
	b=L8J0CWWYuEMMUK59Y0tpYq+M46FrVhvUdtaJtPLDo+KIlhAEWW8vdoLrt7YCdKQQHv6ZSD
	WeSR1gqK1r0kyVORuJgfxshVPMhLFORDIV5sn78858/5T/PpN5/eE3qBI+jYU7G1iKQJJD
	OUleuhVK7XM3mbebQsXjXMNAeZYzgOs=
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH] mm/mglru: Fix young counter undercount for large folios
Date: Wed, 12 Aug 2026 14:59:33 +0800
Message-ID: <20260812065933.103627-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: kpcjaa8nzctwyrssj3o43fuy1oj4xuqd
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 83CA2120002
X-HE-Tag: 1786518031-873816
X-HE-Meta: U2FsdGVkX1/Ab9OON7eekf45gMAzFfr3+2LnG42s9UkgX5a76wLy3KaheC2VegSvpivxz7lKFOQnu9cEO4uaMTAI0oLeyDraQj3H3N6tDbwvSi0QdrdT2x9TVa+FhIGX2b8jamHHeZOZDJiOorqBau9FXC8fm3dSUpyxRsLFpnwK1tjmTHY0Sm7vMrpS3JuQYo5S8gw3CmJV+UOEXzIHmI5Vktd7/YeiEkCI0CYWQTxTsV0IdBmpiONp/tX9p2jNzDhsBZ7fd4E9w8x1xnehlDGOvUmQU0TG/Obv8CYKGfFzAtGDx9uQ0qGGIBjHTJ7hWIcWQSD6cH/hme6VwxZULvnaCbWSEoikmrDqQfnJO2BkCT8EhVqjBQH1kDCah6hfqDseiTt2247Hb+1B1YsUGf7XhQ5Xj/kebElo3KONAMfX/62ygx2wkFpHAqNTT5OoBuoVc6DXt6W1miJ+tB6FzXBceiHjfPeLu07d03M+DSo+aiUXuN6092h7948QcJ1xgJKjvTzOE8ZGBzUjA3stOTSRwn9ZBkSyrDc+lzzU0RAgreonKSmBUbqYMIDNOacN3mA/Ld82hOlSZ51B9rm8gNj8gvx7tY7jqKJSDx/8WMLdZ15Iuj1x479gbh3vgTKkEUpNKgnHJ886KIXcoIm+ii4C79e9kB0JvlVdQu0uxZCGOg+TTvDEATaON8F9/oO2neehmUgDBX2zVebfW9TSwRZwwcwOV1NJIIY/hmjjqxV93m4kwJLryzeR8MwBbwA/AGVriGhsGR/BpqC0vYU2x9oHRHyOLj8c/Cr0DUSb2LXvNNm/VfwL2LP1WaL8JRugfuPJWspDhT39IQYM2IyCEnTrzQBqA6612rqpbfN1owcyOsSVoTQtw88NhHcV83cLiJzDKCSp0rg0dtEq0PJO9p/7LPpmeSn3odERUx0vXVbKHYc6lRGfXu9siEbKXt1MNEG9D16yK+vx9feBpbB
 qMnGRzfa
 TosIoHSDNGyDcH9fnAtUaUZv1IpDIEi3sYdnxzidRrV/vY39XGR2jwQQZBh8VzdV/NSmau/T7s7MrcmACXIAVIiQ6vmDO6LuzwdkMuKXuYRNN7hFFCcE5oXfivcnCjt22EqG+PvMDteNsDUG8CxwXEpm6rLejhjEz6DvncK5pYd3EQIlgW+uFjKp9OJL93i7pvVak
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

In lru_gen_look_around(), the young counter tracks the number of young
PTEs.  The original folio's contribution is represented by the initial
value of young: test_and_clear_young_ptes_notify() is called on it at
function entry, and the function returns early if it is not young.  In
the subsequent loop, the original folio is skipped (its accessed bits
were already cleared), so it is not double-counted.

However, young is initialized to 1 regardless of the folio size.  When
the original folio is a large folio with nr PTEs, its young count is
underestimated by nr - 1.  This inconsistency can cause
suitable_to_scan() to return false, preventing the PMD from being added
to the bloom filter and reducing aging accuracy for mTHP workloads.

Initialize young to nr so the original folio is accounted the same way
as other young folios in the loop (young += nr).

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index bc324e37c5f1..264017850a55 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4192,7 +4192,7 @@ bool lru_gen_look_around(struct page_vma_mapped_walk *pvmw, unsigned int nr)
 	unsigned long end;
 	struct lru_gen_mm_walk *walk;
 	struct folio *last = NULL;
-	int young = 1;
+	int young = nr;
 	pte_t *pte = pvmw->pte;
 	unsigned long addr = pvmw->address;
 	struct vm_area_struct *vma = pvmw->vma;
-- 
2.53.0


