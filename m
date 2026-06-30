Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CDB2CC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A172E6B00B6; Tue, 30 Jun 2026 00:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9787B6B00B7; Tue, 30 Jun 2026 00:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 819376B00B8; Tue, 30 Jun 2026 00:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 433DC6B00B7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 91A358D23F
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:32 +0000 (UTC)
X-FDA: 84935247264.25.289DB7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id DFEC580009
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fw63Lx7a;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792511;
	b=f+f/JuQ7vTHQLz/mbnz9AWAHoYR/gVLDQa/BroqADXF0VS/iSY6nIKZBFcvuZz68oAwSDG
	62aYuEtQIbGtxliX/sANko+dAbAMfM6bveF1NHC+JFqGy+D15W4/CDsnM9gPSS4jUnIe2w
	bYN4xmPJmkIE8dREk3cit/ozWUh4+R0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ISgM0/IpFYdSGK1NuzNK8sv6iik/7pwEzAP44Tm5nXw=;
	b=w8lX0p3MLD8fBBNcAKJ7mYtz3ISn4WUgLL+rlk4tLJ4VGqKIww4t4s0GxWkHDYwu/S5Sey
	l7Qk1PSk3dDMZDT+P1p9OHBSWMpUNtosZ0us44nlbLgBtznZhQqXPbJNRVJpD+Uck0vUKY
	rJGnQECF1DEDFaSoujj4Y451+wFs0jc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fw63Lx7a;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4780543C88;
	Tue, 30 Jun 2026 04:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C501F00A3D;
	Tue, 30 Jun 2026 04:08:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792510;
	bh=ISgM0/IpFYdSGK1NuzNK8sv6iik/7pwEzAP44Tm5nXw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fw63Lx7akv48hSwtD/WuDicFwfkoCl91ylnECKFw+TiGqiD2mHcHh1ipb9VvgwOKa
	 YVDD+BBHiDHLSmMnR1fbrtrytq80tHi77Ze0VYxdazJTMDP12U69JuGAt9v65jsYAB
	 X/WC3KZjelGUvsw3vq8UZxe7rdOlI361ClhdrtxTou7BwZaepJkjC9rX3dvDB7ULl+
	 rIW4O/LQnQnq0U5wIkVJEtQ5TiHzRMBKphLXCfcp/GVBpPoMvhu0jS/uA74dHb1EcF
	 G6/KJbKegj4/IgojjMdm4SvUvMwFzTfihg9cdvtxki0rye5UweV5XXiT58JfoAu2UE
	 DPENrFlPK0OgQ==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 13/18] mm/damon/core: remove nr_accesses_bp setups and updates
Date: Mon, 29 Jun 2026 21:08:06 -0700
Message-ID: <20260630040812.149729-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rf68fc4qd7u7wgzx4sanyqyp16r4jo3y
X-Rspam-User: 
X-Rspamd-Queue-Id: DFEC580009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782792510-803857
X-HE-Meta: U2FsdGVkX1/b4+OFTtGtJao+3qJlDFqdfo2CA94ybVSzbFNTQaN094Vnj50j3NttpLL/eleBFbO7pfR3Cdh5xGQ+Z6MgU5PcNKkAgm87QmNFPs30JZ/+wDdYpOKDSm+YsfBmeb7uekWArSXNQcW5EB80caNiJS/12B7A72xzuce/y66knA7vBUJjhn7HrT5ihIjZV1EUDFMy5gBSLwyxr9gkAdHFc414TTS9VXmUxQ0zN60CQKMeuQ60P0ZNB8k2IfYji6l+C2lir1wfzVzNR134c8aIcM1bRJmwJZVqf2Jt+CKhXayWtNBPbK9LIlcpRSop8Jr4OAsh1cieCtzj7x0GmnhSxNluw1tkPsHsXaVffX/QD3O8uteip5jtnaAVUeYtM1LEWtxfZ32w1Jc4/pcfNKA+cTNhNBTCUqVdIoxum6EoDo8uvdXXKddBrRT1By2orcBjBvaW6joRARQ/AEOVjLnEGEdCYt9GiBqGBYk2JEI7HjfM4K0oEjU7aqn+GOj3FmUHWCGNbwHxj1phn4PCA1YFw5deUiLFjd0NSb0xaNMtvXXihLEKWcKpsaaPsxijWIPjGa9waIFq+JejiaFoaGX+cQp0ViadkCjSrbrFx88iZsg6b1yVlXN3h5j+G3PS8KfVVibjWjmiq4KFPU5a1IpXP3qYIf5jIWmC0V+7/cPVxtC9JgC5y4o0e65lEmuchFvQ11hoGoIzhZU50+EOq3cD6It3O07rdCgNjPCedQCXzl33QAdI/W7uSpzrsglW0HJKNoBnI2zsXnLIz9kBuAgLNJzHtFKcflHTilUgFilLobo9LtKtecbLvFm9jt0SXoJydCyIEdfe2tI4JEb+ktwPVYa0aSwHPcWgdwJ2vB4v6iPuws27YBCKdens/OSiqYoB8BA2jCIDnlLgqS2Y4MADtELuqRQJh+YkHLGaHXjSdH8B1udu7gOB6Y1Z5Tzc0FpCUqSUxfnIFq7
 DAiS/HrO
 oMDETZSvfRBL/zclEf5VT7Er1HHUyrpwmSpaLW76DuJFjBYjsWUEt9Mc4wanqC5H/ariO1nD9Nuk6jRoyFai+RG5lzxkEnUXTXgL+uAHqCmmAeMtV5kb79npQAqBllourPz1yk9GWiQeDLcA93kAsWLpq1ld+E0/vYKVdUD9AM+16uiNs8+5YCs8UB2usTd9exEThlnqJnEporG8gRGKPq1OQS/68HWZDdcWVliPdbYV1L0oXSJ1rcNldj9i5EA0nM1VwLNkqNN1kib6u5tw5M4eoIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON core sets and updates nr_accesses_bp in multiple places.  It
explains how delicate it is.  The field is no more being used for any
real purpose, and replaced by a simpler function.  Remove the setups and
updates.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 22 ++--------------------
 1 file changed, 2 insertions(+), 20 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 78c32ee45d28b..dcd5e484fa442 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -302,7 +302,6 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 	region->ar.start = start;
 	region->ar.end = end;
 	region->nr_accesses = 0;
-	region->nr_accesses_bp = 0;
 	for (i = 0; i < DAMON_MAX_PROBES; i++)
 		region->probe_hits[i] = 0;
 	INIT_LIST_HEAD(&region->list);
@@ -882,20 +881,17 @@ static void damon_update_monitoring_result(struct damon_region *r,
 {
 	r->last_nr_accesses = damon_nr_accesses_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
-	if (!aggregating) {
+	if (!aggregating)
 		r->nr_accesses = damon_nr_accesses_for_new_attrs(
 				r->nr_accesses, old_attrs, new_attrs);
-		r->nr_accesses_bp = r->nr_accesses * 10000;
-	} else {
+	else
 		/*
 		 * if this is called in the middle of the aggregation, reset
 		 * the aggregations we made so far for this aggregation
 		 * interval.  In other words, make the status like
 		 * kdamond_reset_aggregated() is called.
 		 */
-		r->nr_accesses_bp = r->last_nr_accesses * 10000;
 		r->nr_accesses = 0;
-	}
 	r->age = damon_age_for_new_attrs(r->age, old_attrs, new_attrs);
 }
 
@@ -3110,7 +3106,6 @@ static void damon_merge_two_regions(struct damon_target *t,
 
 	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
 			(sz_l + sz_r);
-	l->nr_accesses_bp = l->nr_accesses * 10000;
 	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
 	l->ar.end = r->ar.end;
 	/* todo: do this for only installed probes */
@@ -3222,7 +3217,6 @@ static void damon_split_region_at(struct damon_target *t,
 
 	new->age = r->age;
 	new->last_nr_accesses = r->last_nr_accesses;
-	new->nr_accesses_bp = r->nr_accesses_bp;
 	new->nr_accesses = r->nr_accesses;
 	/* todo: do this for only installed probes */
 	memcpy(new->probe_hits, r->probe_hits, sizeof(r->probe_hits));
@@ -3830,18 +3824,6 @@ static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
 void damon_update_region_access_rate(struct damon_region *r, bool accessed,
 		struct damon_attrs *attrs)
 {
-	unsigned int len_window = 1;
-
-	/*
-	 * sample_interval can be zero, but cannot be larger than
-	 * aggr_interval, owing to validation of damon_set_attrs().
-	 */
-	if (attrs->sample_interval)
-		len_window = damon_max_nr_accesses(attrs);
-	r->nr_accesses_bp = damon_moving_sum(r->nr_accesses_bp,
-			r->last_nr_accesses * 10000, len_window,
-			accessed ? 10000 : 0);
-
 	if (accessed)
 		r->nr_accesses++;
 }
-- 
2.47.3

