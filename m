Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45482C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 14:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C84E6B00E0; Tue, 30 Jun 2026 10:17:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 951BE6B00E1; Tue, 30 Jun 2026 10:17:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 83FFE6B00E2; Tue, 30 Jun 2026 10:17:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 493316B00E0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:17:52 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B28C41C6FD0
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:51 +0000 (UTC)
X-FDA: 84936782742.04.6283B14
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id EC83340010
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 14:17:49 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T4m9KOaZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782829070;
	b=Cjw1brRuikrvo8UGJWVNHy0OJXetjB+8ud8cxNoZX3U4LUhMwKNNEiFOGRLu/JDu7NJVGp
	0Omr8Pj+/SdEn7VHKTM2l50cpr4IC0G6Z4+NOMqdHhGf/xPfNklAKFQKGqx3qjGphELxKV
	Ddt+5S0405Fca7RIIiEQHi9g74e4+ek=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782829070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DpQXH4eWAzKUpyJ3N4PMjq4KjSfFjbZwL0TXiysKWH8=;
	b=BSzDHyITqUI5GSJmn9ZlOioa103LAYLS5fQBjrCjGWgwTgbAKcjjuBKjwnCRKaqAhiT6+N
	nhPq/gJpOao9Bk5ZG4dZ1DsAxZJlMNLzOkXMBl9joOWrgybaTGRIgsy9tmkPYb2G9Kgazb
	3kkvwopUH7hhfzoh+zk3Gc3hNskQq4c=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=T4m9KOaZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 48C32434CE;
	Tue, 30 Jun 2026 14:17:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BF21F00A3E;
	Tue, 30 Jun 2026 14:17:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782829069;
	bh=DpQXH4eWAzKUpyJ3N4PMjq4KjSfFjbZwL0TXiysKWH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T4m9KOaZc9PBbmhx+I6uZFVtxtofgHXWxNr83EHH42rQLsumNAEoxIDnOUO4MCd7C
	 ps4DN2kllZscItINWvABpMlr1xkg2pmlAo5N7j9R6umadpPI3EPzm4m+iuRCuwlIY2
	 PBkvBEXHo0REDXfTekNgzOTiypE2u4mct1DniolrXpnYSq8cwytTceYilnKXiRM1Ot
	 M02SFoT/GE6VTOqhsx4kJq1UPnaIX1H9I1dyvcUAhjF9SpjxzpuK6o+c5PjeAQxPYL
	 GAJHSyhIx9R8/zzh34+W3vaIEHfkx5dcirS8H9KfP4B+5HjfIf+il/utnkNp1y/lR0
	 ZcDB/xBDrnrwA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/11] mm/damon/sysfs: split out filters setup function
Date: Tue, 30 Jun 2026 07:17:24 -0700
Message-ID: <20260630141726.92246-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630141726.92246-1-sj@kernel.org>
References: <20260630141726.92246-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EC83340010
X-Rspam-User: 
X-Stat-Signature: wkkcnaheh4mgbrcfkjw9wud9qyj6643o
X-HE-Tag: 1782829069-618421
X-HE-Meta: U2FsdGVkX1/TR3RNiXlD8OxLV29Ef/L3joxMKgwrofzcAa9ZxRQ7ZYqsK34CX2t158Bi4DkkruiZ2ELOvEPnHkLZI/4T7zRLYu7hOK33zsVUqXbRhq3XxsWQNvllAtqIDRQNfrB0NBI/hqJiUF/6fEXkbAUNidkTFqDToGFpLuS+k0fky+/VkOEKbhUovhjsWqkRy6hpdBj7XVunBCwZFqF/32lRPmFFE40jeZN2logRFIZFSWcXeIztGAOjvTZ00xMS1mNoDffvqkfUxdUB6hJwq9yCv0tUpUr+3Y7V8+eYfrURzRwq28zy3jq2dJ5MicEptVND1oLG80W9aXTxQWtw2GXv8xyiWnd++9YilLVGoEl7PGxBJjoHDkUzwyBs+y/wPIIJ0adgTRI4UOlFzEufc5fqGXuRvfU8HAEk57e3Ki62W0+M4eULgbZ4Ub1v3i5gj9NROUKxXXNo9SoZ2Hp1OCNljHgQwTVApyXHPNkBbjbWMMbZs4mML7q8wM4B4/j/EtwEjPDzTcMRFJBgaa3vWDLk9yHNmPKZrDjfj1yNpSM3YOBA2WN80jvAITTdHtB+IoLLl35QmP6vKW/FA7tp2p8+eO67G1wU1lxCD16cL5rsO9JTOkfu7OHkdTorkZzsNDhSt2nHPfKfNl4QZrPie6wY6Vx80zr8D6BBsW2mCLbpk2KezS6KjwE9F1rkt8BG0brbh8+8OPp2jd7Ad5Qmgy0R2la/ykrUoXN8JdgFmdLzNG22FQMKOZNbSmwyCBqbrVHNf5dWxJrnd5ovKdep8N8UZDHxkOlFFEasWAYPFneQxceBE6kK2hiGM/SyrpnJUC7N6pVUQ/TBF04pPoAoCVVQNzbHX32CV8x9HyU1YSrL1zg8/c5dPcCt7MVWuyBzY+rlqE9X2PojzTtqW9Fh1TYKDrsLp6+wxdP6dMX6hIANqbwzaWmwVa5SbsARSw+yhLjgHi0cUJHCaVG
 XfxB+wvI
 BWqwM2ZXSPouZLDPc2fPeynkv+j0jLkohaHz7Y2UIVCTb1i2zmuUlu6lPqerxTuzxkOGscKurEQhcAlpdCeZX5fyUetMdjiKQ+SldTEyXfUNF2lGalxFisvn45/MUuJloYOVPBHl3fkhQIXGk9nDb5OMizUnvHl0M8IzMEiICRXPPXXeW3hKRexMwqe5V/eSWbkNNr/1uEYryfC2oF97ZTla5p9fBMCjV4fFGdYvsP20BEyw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_sysfs_set_probe() is doing not only probe setup but also filters
setup.  Split out filters setup for readability.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 02afd37b04df4..5b2ae2fe948fa 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -1909,16 +1909,11 @@ static int damon_sysfs_set_attrs(struct damon_ctx *ctx,
 	return damon_set_attrs(ctx, &attrs);
 }
 
-static int damon_sysfs_set_probe(struct damon_probe *probe,
-		struct damon_sysfs_probe *sys_probe)
+static int damon_sysfs_set_filters(struct damon_probe *probe,
+		struct damon_sysfs_filters *sys_filters)
 {
-	struct damon_sysfs_filters *sys_filters;
 	int i;
 
-	sys_filters = sys_probe->filters;
-	if (!sys_filters)
-		return 0;
-
 	for (i = 0; i < sys_filters->nr; i++) {
 		struct damon_sysfs_filter *sys_filter =
 			sys_filters->filters_arr[i];
@@ -1945,6 +1940,17 @@ static int damon_sysfs_set_probe(struct damon_probe *probe,
 	return 0;
 }
 
+static int damon_sysfs_set_probe(struct damon_probe *probe,
+		struct damon_sysfs_probe *sys_probe)
+{
+	struct damon_sysfs_filters *sys_filters;
+
+	sys_filters = sys_probe->filters;
+	if (!sys_filters)
+		return 0;
+	return damon_sysfs_set_filters(probe, sys_filters);
+}
+
 static int damon_sysfs_set_probes(struct damon_ctx *ctx,
 		struct damon_sysfs_probes *sys_probes)
 {
-- 
2.47.3

