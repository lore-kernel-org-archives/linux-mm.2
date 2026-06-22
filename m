Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B15ECDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8FC6B009F; Mon, 22 Jun 2026 10:21:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5422C6B00A0; Mon, 22 Jun 2026 10:21:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 457F86B00A2; Mon, 22 Jun 2026 10:21:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 411A96B009F
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:21:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BF7B9120183
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:52 +0000 (UTC)
X-FDA: 84907762464.16.15106A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2793B140007
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:21:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FnKATpWv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQradOyUplHOgC8HnoJqDwUCjl6LH6os+/rkUZXzJJQ=;
	b=2+QIgZlJaXBxDAuVE9CPKV2AMNkG1u2iKEL0uXiNd4WSRyQh1h34grU1ZcwS2uugnWcqcE
	5FZX+3K02xZSxoozSh7lt3Er8Q6IGRU60pkBidZV7j2VpYKrtaimDR1fAGV04N57BWraPD
	bSvtEOiaoH7pKGvO6r1IJpLH/uGPfa4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FnKATpWv;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138111;
	b=v71n65w1Ih1Y3FZjJW5JFSAnTKOqMUV6aaO8yzl2Pyn79OP/xuWx3Sp38c1U5MgFQm3Oga
	m9BzucerbvdfTdABHGMc209ULjKBp+GqeiiODVJ8TjL9K5hfBN2n02T7N1tRQlMsqaOLVO
	sqpnr2ae8i9iVmw/DG3zdhbXODq4vJ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 73C00442EA;
	Mon, 22 Jun 2026 14:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E3151F00A3E;
	Mon, 22 Jun 2026 14:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138110;
	bh=PQradOyUplHOgC8HnoJqDwUCjl6LH6os+/rkUZXzJJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FnKATpWvDwkHRwdi9Uav1cD+mTAY2mfWw9x4neKuDXB+UkN3ME3GrN0aTqK3bnXKR
	 UahrR9MatgNRQp8lcBKKxTCp44jVg6UdjIDyPWtNas6yFDl8E8PxfCUfrxyqg6s9z7
	 4X8JiaU0kCdrp+SZ3TrAGpCu+2iF8abRAx2swsglG/mCp5WCPmf+12o0cfJ4fdFx/d
	 +jC4BdEwcAL3TT7V0mQ7tmXBTHXF6uNR60ZyLWS2jSYoYpCmQPGJgn8imLYKCvyYEc
	 /SvhOqO1BtPJN0Kch5b3h9z1RyNM+fQzI9s2KDWPpOzDtK5l7dhIlUgooKIxv5y9FE
	 Bjg4YrbyBTk/w==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 03/18] mm/damon/core: always update ->last_nr_accesses for intervals change
Date: Mon, 22 Jun 2026 07:21:23 -0700
Message-ID: <20260622142139.30269-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: fed74tmkaukh5ugmfy7tskzn187dgzzd
X-Rspamd-Queue-Id: 2793B140007
X-Rspamd-Server: rspam11
X-HE-Tag: 1782138110-575406
X-HE-Meta: U2FsdGVkX1855qXplTohj47lWh7sjilyj80HWFmJt+EnYGELCO0bx9Z3ksAstlRTw69nRBnRoTc9QO3HrQdZq4OOpa0K8c04GCCd1v/GhGvcoIgNpxP8kID3eTisgHmiD8ap6enM9jT1F0SWxCnoQx5aiSnMBF1ZO0Xjd0TI5hYnL3eNScKxFtd0CFRH9KLULR3yBj+HLqGLclhuFXcAa9y1R5dC3bkkxFKdO7z4hCem678H+IbLViXiRcEsHflwp8096QVvCuYEcngdVTxt2WCS3/seTHjDyweV2PYgZa7WsWrB02nzfljnRDe5x65RVSMgJosJimG/UCZqWb9Axy9DYHDj2ISrmYeltPHUTF2OXR8HF55Nk+JGpxV7VspVlpGLbUYAK7vf4i+oP7tPtTfLVmeO3lyjqqMUgWW1hf8wUsfrhEzHsw++QC55N1CJl82CwGzLv4bemnEx7R+Ij7ilJO6rgaNV6/ProutMgnnv+7TvXZKpo4nd4n3Qgr7i6nJij4GcquM7CcIqdNr5+RsMKwhFk7uhvLskoE/C345ng++C8S9tcfOeIMikNlH63cdL5oZiqljrBJeY0FWdUg65545xvgZO02/QMXlz1unetohaGyyCh/W3JnliCaiDXbCi9k2YK6uqXsKAeVy6qD7IATAWORrEUGscz4fSraIa4IQwXD/953g+H8hjj/vRwlIPNdT91X4VSgAXT5XczywRicuIgtmkZMGAWa/23hpiEugV69jkvj/ZP/VbHRiYvbPCb3xbzwxklZA1mKQAHJNd/JDlkuCfVOp9S3gbXl59mwURJqySgLi36HEvOuF76F0grDHUlt9chyhRu4qya+i8Oc0fH83p+2A38lgIs8jBlYzESxGOiwzLkhZ/Y31shrqsee9nO+TF92mN1ZHrVI6fPZanJrzuGIBGu+Y8J3Y2R3zlC3IkmLgC0FzwoJbj4M7Sxo4jvQM/3I9tdrK
 i/hlFUNJ
 EwXeGsGLeYRKHXe7OrUlgazKwOhLIbT0bHi0dSQT938G//0JfvgC6FpLlzvxramJj3kM4HnYFTzLK+BdVuDtSKpL+wFipnoAs4HBLaZYkLbSv7PRws2SDmG/iXrCre4aYkkRsohsCojauuIaRdHCemRvgg34ZLcQ6Jl2ZroWtYwowQ7kCFGTOB5SW5v0ODl5kT+wsvGAELaov3sl7tj6sc583qTzVUBu9DVFUF4EDTuyrBynHtWE400gT40gMTvzW5MKhGuBo9DX1AvJRx570SRC6cw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Each iteration of kdamond_fn() main loop caches and use the next
aggregation time (next_aggregation_sis) because it can be updated in the
middle, inside kdamond_call().  If that happens,
damon_update_monitoring_result() is called for scaling the access
frequency information of each region according to the changed intervals.
The function does not update damon_region->last_nr_accesses when it is
at the end of the aggregation, because it will anyway be reset after the
function is executed, in kdamond_reset_aggregated().

Let's suppose damon_nr_accesses_mvsum() is called with the not yet
updated last_nr_accesses.  It will use the fresh next_aggregation_sis in
the context instead of the cached one, unlike kdamond_fn().  As a
result, use of not updated last_nr_acceses with the updated
next_aggregation_sis result in returning wrong value.

There is no such damon_nr_accesses_nvsum() call at the moment, so this
is no problem.  It is planned to add such calls, though.  Prevent the
issue by updating last_nr_accesses always.  This adds overhead, but
that's fine because the overhead is not big, and it is anyway not a fast
path.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 2cc911fa221aa..191533685cf2f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -873,6 +873,8 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
 		bool aggregating)
 {
+	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
+			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating) {
 		r->nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
@@ -884,8 +886,6 @@ static void damon_update_monitoring_result(struct damon_region *r,
 		 * interval.  In other words, make the status like
 		 * kdamond_reset_aggregated() is called.
 		 */
-		r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
-				r->last_nr_accesses, old_attrs, new_attrs);
 		r->nr_accesses_bp = r->last_nr_accesses * 10000;
 		r->nr_accesses = 0;
 	}
-- 
2.47.3

