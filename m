Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4863FCD5BA6
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61B4F6B008C; Wed, 20 May 2026 23:54:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 553B06B0092; Wed, 20 May 2026 23:54:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 444AA6B0093; Wed, 20 May 2026 23:54:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 184BB6B008C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:03 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D20211C039E
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:02 +0000 (UTC)
X-FDA: 84790058724.20.1159D66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 39D55C0004
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDvBnehm;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMM8ZRfSsARmGo6eD+hRIbIxGHEMj2jHM5nMAylgAOE=;
	b=GVSD4a124FnZOrwyb9fkRgZsZS8RqjzgNuj3gmDqk3X1n08h0HSOt09MRsbFMOjNLkT8zU
	3kZKer3FdTfvIsSQPTE9KR/mdb4B+RDP/80f8NC5YbBtsVx2nH4blcwgwLoImxR2O7Zl8O
	WEThTK5UJHUPzMZe1Ts3AyYsjsqLCWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335641; a=rsa-sha256;
	cv=none;
	b=7u7ZRoOEod5AIvGO5jqU660CwoHnS4ndoWDsYgPM4Va0oR6QxIFV1kSoMQsPOLIDqLkDAZ
	YnH9iUQSnQeDv8zT8L19EOUHxJELKKdPj5hilIhCVBzoazCxAXiAvV5HF/WuZaKuBXe4Oa
	At3UTsUBJUCAOpn+ThOoiJNOm0r6Rrk=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iDvBnehm;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C0BD5601FC;
	Thu, 21 May 2026 03:54:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A1E71F00A3D;
	Thu, 21 May 2026 03:54:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335640;
	bh=iMM8ZRfSsARmGo6eD+hRIbIxGHEMj2jHM5nMAylgAOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iDvBnehmRwrVXOGnplb24UwMW47ZtquKrCHal2FynT4Ad3Mp9Q9J40uXtQF2rdiR3
	 YzxegO2k2fBKjorOE+WtZaQYhoQ4F2LOttuwuKK6pYUtm+fr4WTNW/lzNet2rY/tZU
	 O/tzrKzPt1fZwl1WEbUwTA4lFu6elBajsb3v31UFjGCXmjKYAKpXdPw9hQH2SQDEtA
	 xttATGDDDmfwxcI+m+fZKaEaVEpZh2jrtQjt3r2Fievnbm6TU8osdgLZmqQgZGfsmj
	 3gphpztxGPo2dBezI0az/vtMF5mJSkLEKmRVBO7zYMn3m9wqKENvMG5/8nXBFJH6Ah
	 LBBeMPB856YJw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 02/14] mm/damon/core: do not use region out of a loop in damon_set_regions()
Date: Wed, 20 May 2026 20:53:36 -0700
Message-ID: <20260521035349.87565-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 39D55C0004
X-Stat-Signature: m4ghsu1ihatu86g34imapfrbszw1fa1w
X-Rspamd-Server: rspam06
X-HE-Tag: 1779335641-372886
X-HE-Meta: U2FsdGVkX192+MSKX76llyfoSjKdB424wLzVkLMgP0E74Wzujyg7O+Pcd4whpvKyPjEbG9oq72B5i19TuTFUalfGl9zdiad79jePuu1TArnOd4UL1I0JOYcK3rrnnJZrDszabuH8LiQLtR+NryEdkOdqxE0mJTZN8gvduRusrXfM5sVU+Tf8bxt61gpaPYsrPxo/cu1qChYMfM8c8rMjGzNw5BL40PXT6GmZrJqsACiczBKLNtYTUzUCf0GTR7BLQGfspgWF/LQ1JSwrZfrUwQ+U2979VfnZZ1Za5BJcWt05/EMiaZL8pL/0YgbFYlE7vRw2XYUWEgH3+QNqWX474NVyLcYqVn78hfZBvItlLwd/fc4KI78yTT6N8c07s7qyUzBHMj2EXCXrPEQcyNmX1LIEx+i3NJicptnGoxIUB7o2zj0UM7VDsBHVSA5IDjgH0YnwQ1vixrdLi8cIDClCt3BLUV235ftj+ENa4qV/PG7BEWqD++ejuZgbGaIkm9+aR1ME11rMAzUKF1XgDP8rB5l/qM1yg2pNJ3wVSwA4p+k7OA/JHo689GEp/d7CA+IOdjgX7/UTt+RKBW15Lp3A3lWLC5b0Te6wOT7PLVitUaS5eC+2wFgCpEZkQOnIAMjjlyFVvnmo6gJAyfZTju3Bov/RWbg2Cr1w0VfGlP6A5qPfiJBjnV2JjueNrn0yZS7qRDPIqa3XVAQGuZrX5/gbq6QWXjq9P/NSIy83zY1fG0N0xwNJ7PCeGhBBWBsU2tvtJuLn0l4qD65z/1sRn9DPCtOJDzXADFP5wzJu4rlInnhkWcpgeMOxRbiAU7tUChp4vhdofCncTuPH/TW9D0KNXb+kiFK2qJ9vrRy8kI4ANYIGejfleeYtrkeFyQoGGhJBa1kAoATDfznEVK5l7yRvacgdin/3/UbovggrtixQtfdS8dVgdvn0CkFVH3H+zlgXgxIhQEX+Vh5RK4OjVIB
 +VaW9wNZ
 +tY8qS61w7DUh0W/vvW5vEtBsZOfdRsoMhNYOthOiMoXKxi4ziWD7z3pKaEktRplfGFLUDKBPM+p/nSHn07GFBHQnqGjXMMLDfmVV8KFhsx/YSU/mJYMc4sF2T3R7TLturUq6FuoWW9YdHwvt3Mok2Ri+uqRiRADWp6awZmjMSngtza8Bc5p7Pykv5f6Vx7zPbPTdO7yHHGvyGIOCWdN6Da1uBt3qSmpCIcfsMQ0F3yZlb2NTELwDVE0mcOFDDW1Y3NLWFybcNYtr6wqX7LN5Ti/1eA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() assumes the DAMON region iterator is referencing the
last region after the region iteration loop is completed.  The code is
indeed implemented in the way, but that is not a documented safe
behavior.  Hence it is unreliable and difficult to read.  Cleanup the
code to avoid the case.

No behavioral change is intended.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 40946a7f6f549..e8cf3632115e5 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -374,6 +374,7 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 	for (i = 0; i < nr_ranges; i++) {
 		struct damon_region *first = NULL, *last, *newr;
 		struct damon_addr_range *range;
+		bool insert_before_r = false;
 
 		range = &ranges[i];
 		/* Get the first/last regions intersecting with the range */
@@ -383,8 +384,10 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 					first = r;
 				last = r;
 			}
-			if (r->ar.start >= range->end)
+			if (r->ar.start >= range->end) {
+				insert_before_r = true;
 				break;
+			}
 		}
 		if (!first) {
 			/* no region intersects with this range */
@@ -394,7 +397,11 @@ int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 					ALIGN(range->end, min_region_sz));
 			if (!newr)
 				return -ENOMEM;
-			damon_insert_region(newr, damon_prev_region(r), r, t);
+			if (insert_before_r)
+				damon_insert_region(newr, damon_prev_region(r),
+						r, t);
+			else
+				damon_add_region(newr, t);
 		} else {
 			/* resize intersecting regions to fit in this range */
 			first->ar.start = ALIGN_DOWN(range->start,
-- 
2.47.3

