Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0F62C43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 18:12:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEA596B00BA; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB0746B00BB; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9781B6B00BC; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 641836B00BA
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 14:11:49 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D598E1A0555
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:48 +0000 (UTC)
X-FDA: 84951887496.27.4ECAF61
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4F4CA140003
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 18:11:47 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ajlcylt+;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783188707;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T/jrLjscVUQeC5WNYbMxUpcBegD3KHrAD9D5l1ftK2k=;
	b=xf6FrpJKdXTs+iRW/1XUMJ3Bh5AeLbK5SD/01+XYOUDad1Qe076SplEcVUF1IlRwXx5nLb
	8OqD+kn8Ik3fHYsyx0ee9tT6gGoYtF0Sy47cpdieucr0UABilqpI1FRhAAu3yMdsP9lkee
	yysSt+hxxajv9HFSn68gri46U58Gn74=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ajlcylt+;
	spf=pass (imf26.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783188707;
	b=2s8IvPgEoQtN3Q28q9OliMVKdAtxOODQYe55gN3DwSuz4RfCxvVxx11cNxkOM0Patn4pS0
	5ryjcWDkzqo3MtvyHt18vkUPbWbVYRMH1jfwEjEuje6POI1321HrUxrVBTwXOGOoTli5I5
	MYScFmjAo5BgcUxENGM5Z4WTzcft4Qk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7D01A6136B;
	Sat,  4 Jul 2026 18:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC2C1F00AC4;
	Sat,  4 Jul 2026 18:11:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783188706;
	bh=T/jrLjscVUQeC5WNYbMxUpcBegD3KHrAD9D5l1ftK2k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ajlcylt+UqiORqyCeCTb8OcCBeRFj+zJiG2sUfY0goWT4g8P5+WflEtIfmosxak8e
	 9YKKKJUn4F9pnMcPS9P+omTSOmGEnFzVtqR17OXcDVzf/RGuGCp5yxnEE8U5vt0NH9
	 wUOoL4CHTalE714OlsKOQUKtFQ+NnKYyxIb+yMeGtFjnc2h0IRddu5URqrBgix/6n8
	 VNxztLqrjFt/ZhdqhUAlF1BVEdogSsCV6wYJHdsBDvwxwAD9+4956//R/Ha45lpQ8n
	 UP6it/13s4olVFA3i4bYDIrwvRluvIMt1htH8rg0mfRu3Y/FV4otL6sWZ/dyHjVchb
	 iyWKiccq6tgnA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 05/11] mm/damon/reclaaim: ignore damon_stop() return value
Date: Sat,  4 Jul 2026 11:11:28 -0700
Message-ID: <20260704181135.132956-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260704181135.132956-1-sj@kernel.org>
References: <20260704181135.132956-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4F4CA140003
X-Stat-Signature: imk56qtzw38wsgot7juz4omg7799joim
X-HE-Tag: 1783188707-321048
X-HE-Meta: U2FsdGVkX19vh21R87gFTYtlN1vQaH2yaD9iONS/6j5tZ/KREbV0satMqWxpXaJ0vaUJLRVnniibHVtWRu2FnB/Op7KVC9Qb4EX4mxgv8KImL85aDMjEcE9BhTyJTpm1TRddSHmkfoDfvX/vG8FfEfEAKnB3rcPgDkffIQit4wNjTCC+p3SqAxPgn4dTfqacDdo+FHWCcVSKvPx3yfiQnjYbxM6Xf3C5S3pCarHdt3xTcBFrzhVwSYtW1BDPGHbfkEAvNxUqR4fG7iwNOvw0ZQLnFuOc7wsrJEwDuhdA1Bpy1VflJzQLYbrgx77O+UsK0qUh/kk6OwMGDry7S1zejOFm/r3oMF0ji1NdJ3nc6F+V6HztU5gvEWeOQY2MCgmT9mMTZFt2Dmki7TPPgztcL28UGn53vhNu6r7mUKCOSx1SAJH9AluUSd6+hZ4Cc0G0H3qPFk6aJo8a2Qy95NVPRJiv3bonvZjf9DTLZZBUh9XCGDgqlu3QaZc9Gz8AYsYtKl5Ip85A2NGoCvgBPFx8Ok0kYmupn1ENHvsQONgG18znWtC65g3meK24yDu+GYD2FnKfR0JZCsF2sXPxXyyAA1wte2DFfyJRpWvcmYuj1irTce5XeCKCYkEWIis6J5ASpjjLEArg94gemPc7BBMq8xPk1OD4Wacab7STgq3Z+tvB9j8QAXL/z7B0SfK73yewlDMtlV0Gz0ZB4JTJxPbCTcPSGcplb89j55KxmChHMw+n6D8l3CMO3XKf4U6ZtFY5PVdhO2B0RriERscJWrdn73J98SXNXFGm5/rrWWXY+GxZVkwAoalSNp0YZVymwaA+x6Gl2xq/nXdU22BxPjFzaRCRZ/KO/LF9gUYbpdeCefEDrWmUy5peDR8CAzjFiPk2ec7P6OttvMXd3t3ez7d5MquDtLXMiNuyvVTJ9qo/x1seI4NC0huEPRavUF4yUvWxNJQK30sC+aMqcEm/NwJ
 Plk3e26P
 8oS8yHdZoZNP/2XLxFsLIzIRBYQlkWIUgIJvy8KrB6HG7VByNeE+P7u6oxkoYCt6EYqdS3NVsfzPD7GBDEcWYCJzYgn0YPeK8ezkf2Kp17MKvw4PtITS+159i3muLhbGv2n41KN6eKJ+GA7XTpg8xiBEm5hpLYMnUW3RHiobhDrykO0hvvhzM1P1c/47yd9hFDS9SHeNIVnAhKa8ANRpKO1ZhZ/Ctv9yf3oFWll0HVizDSV70Owa/EqQpMd6cXep+1fwCoKK2OWoWx9eu/xHTfAxNqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stop() return value is guaranteed to be 0.  Ignore it.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 6469b25cc34f9..09e941d75f67d 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -332,8 +332,10 @@ static int damon_reclaim_turn(bool on)
 {
 	int err;
 
-	if (!on)
-		return damon_stop(&ctx, 1);
+	if (!on) {
+		damon_stop(&ctx, 1);
+		return 0;
+	}
 
 	err = damon_reclaim_apply_parameters();
 	if (err)
-- 
2.47.3

