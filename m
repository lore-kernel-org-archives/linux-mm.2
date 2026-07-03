Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CEF4C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 17:06:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80B496B00B7; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACE26B00BB; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4FEEE6B00B9; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2C91C6B00B8
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 13:06:14 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B2516120231
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:06:13 +0000 (UTC)
X-FDA: 84948093426.10.E834D4B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 2B5FB1C0008
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 17:06:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PraD7imw;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783098372;
	b=r1Ip0lCQK1X3shSHBrCIRXe3FsMOsnMWUkFqvTwZFwt5Au7blE9SctTwVH8Zy9mTaebHjV
	L1jmheLFmxS28XiRO7QvrfB4MlXUyhy9M9JukRiwr2MXuzuMZbnATGbl301NhyZt6c5kns
	hVQNxKn00ZIsCCPRb2FOT+m4zqk4kgU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783098372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PtgVIn45F2jyWQFHDav9RTyiur9MFQyJ2Q0LK1nrhNk=;
	b=X87azz2t6b8vvVjblfA2KyfOB6SgRIkxTR0wBYleUVreedOq3HMRFgucPfBT99g8GwuD96
	1gkYJgCd0M9/A9e0x+lBUh5/YW2TAzmiV/Y0/p5UmIUfjA9jDATECdRs8L3Pw4YGkD3Kvw
	M3H4LXqK5yhhsNjsWos1arKGTtfrEOM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PraD7imw;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CC4E2600AF;
	Fri,  3 Jul 2026 17:06:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C89D1F00A3A;
	Fri,  3 Jul 2026 17:06:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783098371;
	bh=PtgVIn45F2jyWQFHDav9RTyiur9MFQyJ2Q0LK1nrhNk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PraD7imw/5IQSWlUC9sVvd8yA2hPPxE25ax1vAwHdkpveOZvrxbKsngMpI3fQV/dC
	 MDNlO9/Jdia81RWJlv1HhTU56YaZGCXJH4uewnARWwDxdqmbPcAnmjHGkrepEg64DB
	 gsUKcURTnuE8dIEVU015jKAhFrm0DNkofCcGq3Q9pOZQB0NCL3PP4cJdu5YVcNS8hr
	 u7TjTEy2HrXwaWZ+jHGQSRo4Y12iA8q0ReKgXpu+h9wYndTrFUpvcQt8wg8UGc35ig
	 joZe6qgouYXGkfHY4YWQsmDUA4nyplvPecPVGPJA/wmLzB3u/k72nngA8fbYSAxN08
	 dsNY9kfB6/eZA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/3] mm/damon/sysfs-schemes: set probe hits as pseudo moving sums
Date: Fri,  3 Jul 2026 10:06:03 -0700
Message-ID: <20260703170605.94472-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260703170605.94472-1-sj@kernel.org>
References: <20260703170605.94472-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2B5FB1C0008
X-Stat-Signature: ieut63dhztgmga8knxmy556xhtcwc1ij
X-Rspam-User: 
X-HE-Tag: 1783098372-181022
X-HE-Meta: U2FsdGVkX1+eEYeyPHkNVs/KEsaIXIUO111EaOCwPn/F4imqm1390o/GKAOmGJLTJHEq9jUqaJSRB61un234ZeHne3hBttwFqPA2VWKMCxfPcx23uh1Vh6BPR+rFIOojHr1QIY8VIrZIDNYmob35XsSLeCpFt54h6ecCNN9YDdvV77Fti2GZO46IVXmKT5ylJZoNzAumPIbc9avdwGvFgVqGq6N7EgUKc0tyb3654eYXNuXKmWH9YSYIpf74ni4Lz6atgKbzYWu25mm1ICSyA2YEpUMSHBucItXEGVmeW/ptLvl3kFKnzFsVBJcot7shA7IPq1tvRfrV4TubUuQQKCvTSL6/6uGkTgRmv0UqrVkF7gG4oSrfcrJ0wGGIqi8/3QeTUUDw8f/fyPwZh/lO9aG4+23IJTIk/j9MoY7H1ISbI4hqSJFaeCdH7XbIuI/VBX5nTuxhWO0mEgSgmCAGvG0NXOgZNsY2N1C4+1PEjQ11gbdJqgRMpkee9CdksovNJU5GQ3AruJ9Qjg6thgzCNuKDFE8ULoSE9b4E2KbAEUp3mhMFw+BJcR4kHUZiHPRzpedYd0GksONdre+2TkZHxGLdlBwHrqVhi8h2/AJkG+t8zM/wp0428ilNCZ+uucE1FC/i/l53dfygt3xy/kk/8+aA+IFGAcI3YDiycYZMx5UDfHWdV1YYgLB4+T+bI8+mS6HTO0FWcZ7jV4PTYfN7HsvoPOxdi7Izwz2GeC/CV5tc5k9YALVroEvXsgfVVsKP0WP1XtosgX6yOjWVkiWVAuEObpnaGJmf7wrYJeKcVT64NP3JQ36+DYmOS4jMKVXWCXCVABburNJ1u+4/tmypl0JpOCNMba+4YsUuq5F+EHSC05AUJWlI37uyt55hZk6QgQJj+mkKcb6sxeH4j5TG0/i1bHEINAtvR4n+rUOAZqRB+J+4ph1z6oOGuSbNm0J8osuXp7IuI0Ycxw9j9Vt
 ulzVfAay
 1iMDafO3BiulCogManalc73gtnaLU10i+0vR7O/8FdYchx0PnwXFcsroW5KVrMTmTSzR837H1NsWfefI+hZLW4tEEbEJYvMTq+9F6bNgHQbH/O0F1bGeRyF9CHChLel/PDgs0xNOvGcDHkCdgTQ56Zyp2lxu+5X7D2bvyu4VtQXdyLYkMCqOv8pp2pR31aYWGmKOg0FZJm0akM+/yPV31jN2WGzS+UHTwQtNe9vnT98tpe8A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON sysfs interface exposes damon_region->probe_hits via probe hit
files.  Because the counters are completed only at the end of the
aggregation interval, users can show incomplete values if they requested
the file content update (update_schemes_tried_regions command) in the
middle of an aggregation interval.  Set the value as the pseudo moving
sum value of the counter, similar to that for nr_accesses.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs-schemes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/damon/sysfs-schemes.c b/mm/damon/sysfs-schemes.c
index dbf2b0515d582..32f495a96b17a 100644
--- a/mm/damon/sysfs-schemes.c
+++ b/mm/damon/sysfs-schemes.c
@@ -110,7 +110,8 @@ static int damos_sysfs_probes_add_dirs(struct damos_sysfs_probes *probes,
 		struct damos_sysfs_probe *sys_probe;
 		int err;
 
-		sys_probe = damos_sysfs_probe_alloc(region->probe_hits[i]);
+		sys_probe = damos_sysfs_probe_alloc(
+				damon_probe_hits_mvsum(i, region, ctx));
 		if (!sys_probe) {
 			damos_sysfs_probes_rm_dirs(probes);
 			return -ENOMEM;
-- 
2.47.3

