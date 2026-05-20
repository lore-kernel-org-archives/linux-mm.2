Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C571ACD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 06:29:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689A36B008C; Wed, 20 May 2026 02:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CC476B0095; Wed, 20 May 2026 02:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B6D56B0096; Wed, 20 May 2026 02:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 26C246B0092
	for <linux-mm@kvack.org>; Wed, 20 May 2026 02:29:11 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D91621C00AD
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:10 +0000 (UTC)
X-FDA: 84786820860.10.CE60F4A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3719414000F
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:29:09 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jeb/k8EC";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779258549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iMM8ZRfSsARmGo6eD+hRIbIxGHEMj2jHM5nMAylgAOE=;
	b=ekFamRjj+XrnuoFBX3GMFUhTHM8SkmXpb8MSaHa/EgQub8aPMHGGoKM23hkFiZb0p2ITlC
	0Uy8cJYrsETDq9vmR0ev5NXrNbPKPg+sgW0gQtgK8TekOXLH+/FTAlBTu93bnic5mk5VMg
	Or2DjC+HcX6dUZgolscnA12EVZ1G1uQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Jeb/k8EC";
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779258549; a=rsa-sha256;
	cv=none;
	b=VtMXEziC6gTC8jR1p80K2M7zDi7GP+ROzGWQ8tpYu64Sq0mGS+H5Cx66mXlQ+IZVTM3MwV
	LlMXb8treOQN4s2QrbdKMsmOSmgSVR6SseIu3XEAq1zZ7rpTenbCh4NfHPbLN93iKWU8ms
	CxG4urbC5oWye4n57qNc33T1GtBOJr0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 795EF40825;
	Wed, 20 May 2026 06:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 366C81F00896;
	Wed, 20 May 2026 06:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779258548;
	bh=iMM8ZRfSsARmGo6eD+hRIbIxGHEMj2jHM5nMAylgAOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jeb/k8ECSQYxRI6pMowOh6vnr6v2+UOutb5+7NMmpN8FF1IXZJpsjUuTQ9yd2SvSq
	 5Ag7I03DN6djHqW2oGpkQZXli+vphAS5DiYacQptubs5ef09jxEkGFgiymJqWZBncz
	 9tPZte19BmEfU7f9nnGBfD+35oHbSe2O+HSDpgHH6J0AocP9YcvoFXKlwLRL+WrM2k
	 WARX6EZRiFghYcrWO+oIaogBGaOEhXqF6VY/PUnMhboG3444EjP/YT1YyUcE4DA1OJ
	 owN7iJszrl0AaSTlrb/LoFVzShHxxKa060kCKlomnzzS7kVMvcPjUvwjwHhZzzzkg1
	 HY9i5KvXSAbJA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 02/14] mm/damon/core: do not use region out of a loop in damon_set_regions()
Date: Tue, 19 May 2026 23:28:34 -0700
Message-ID: <20260520062858.167011-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260520062858.167011-1-sj@kernel.org>
References: <20260520062858.167011-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ch5t8ty67qryfpzendptutsq58rajjqj
X-Rspamd-Queue-Id: 3719414000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1779258549-782504
X-HE-Meta: U2FsdGVkX19gdwHrSnQt0qcPX58VG54J6EpoiZW47jD5VtjlGRZW45auFuiK1n44iZLWUw2gjKPBDGhLPXpqNTE1QLS1dcdbUsSxyy7zv8PH+K3sL2PDMTwYgs/QqASBXywfwb+li8fI/qnJWN5d3L+0Nb6umGW/a1w498tJPcIvelDJ1dJ4nSTNj6BxtkFclW49Idot/tVViTP1lu4m9H5Aj1hf1Q03kSQQnguG6gnWckPy7OScVACeEsqErUZCsolb9ZV+5xY80yfVWTpm91iaIl2zmK9aabWKXiK3kbVoZ1aCYHhCgVKcfoxDsqXF27L2xJcpTGesBy+tyTFGgOtl8nezbQbdceAZ0WjVU8k9EZvwEw55ijkP69oXuYbJCgY8ou1iubDSQ4louFBaTGnjqI1yAJApYeif4n/leH1kRnBrUJk2cZA7zvmpG/YTv4ErKF82TFovWw7A4umxggixU0p+Fx5Wxot6zQ+TB1DEKeoytQmBI+GcVzOEZlQiAzy/PxJQz984mEh5WrT2Q5Z3mJT608iaDC2Ii4e0DbktZQUrU29ib8SjZoVeohVyYX2xAtrvo+Em4dT5zZV7YMMCySImt6iaHZO5wFPNJAw8rMD7gRiRGcHkl6QD70IIGCFFj/NXWdtoMy8MM6eYJh9IPYqWlxgZdyHfCTouraNY/E1/R0FzUUq+70hfZhigFJzuzieLioem3tVx/TRy/VV4BSKkWXHww4GJpuQCAnPKcF94VsB+MdUY+raSLpTP1uuAHWr4LEr7N464n8663IFKmiDb6kha67RSIMi71eRAkWlNjC0suRZyCvJSo49wpAkiuM6BQYcGbtk+MeRKMexHzpE37wVvfgjFBQ5drVxbvsDe+cQW2El+plUFdfyt1AAlK7GfnLwA6AWYmfDC7672DBSbvfertqniqhRDuoHKniT92gZgCjqIQNSYP67+R4iGfqcoClpAiL9eCLJ
 HddfE0L1
 45kcpL3hp4j+2kR0f/JY0BN8rj/Bg3SmwoTsQn77Jyf3bXy17fr3pWX//YGo7E646z/0oRUuEPIPiRAsW7S8sRPaWDIlmngZKDgmu9QuC8I4z58zgqQiSfdS++LX8dpz2J4KRqfrNTBF1GDBHhQVsRRyPpAgWmqNsgETw6px+m7EhZhoiq8n/RlA6obgNY2YBVCnDZ53QtHeweT2BMuNlRRo6G+5uzhmXm5p132/zSPgG5v2zet8NzZm/vIjx/GzWmrINX+I8WEH4DL1OcFtPe9olMQ==
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

