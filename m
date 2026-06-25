Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47026CDE001
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 14:25:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 664DF6B009D; Thu, 25 Jun 2026 10:24:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C836B009E; Thu, 25 Jun 2026 10:24:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48FFD6B009F; Thu, 25 Jun 2026 10:24:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 226D46B009D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:24:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A6A441659D4
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:52 +0000 (UTC)
X-FDA: 84918656424.27.5646410
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 19D7AC0002
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 14:24:50 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kdAoFumM;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782397491;
	b=jlWgP9AX4nU2BKE4fDwPvF25irRuQN138qvNd/ILDCDwbHSGDEDa7AL3cGoGJINwffxdo0
	35ZIpqGjZsA/G2G9qZAj+NIGRJpL8LLjxJU/IF6PtyC8PpS8APrOfWnUu08AY9jCtlSlGw
	uvKmxJiaFXfp8Cji4SNU4bzw8Ug3dJg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782397491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HI/zoVaSGKDNLoA6cct9QoJPib3MnUiHJc9KJcrjGCA=;
	b=g1oEBr9dknbc/vc+Q7ek77hhWvsOXM3Lx7wTbsmQI08NlnF2zE8qfNmyD4BjfkeBTdPxhB
	7S5hzU0QYIEPljC/weuDcnvp5jhImsAJZMHwHiEgdr3RJMcn96TWGI/odA9L8wcygPWiIV
	WOGExjbb2gDVkC88vqjWJ11LCCxtfAY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kdAoFumM;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A18016021A;
	Thu, 25 Jun 2026 14:24:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8C441F00A3E;
	Thu, 25 Jun 2026 14:24:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782397490;
	bh=HI/zoVaSGKDNLoA6cct9QoJPib3MnUiHJc9KJcrjGCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kdAoFumMFmi8lT19UnVawdo/dF2kT1jrR8Zpwb1bBDvnk5ceyRoTQhg8gVQjibl0d
	 lIPsINw6UFSNllBr8tHQs4ab+lrffozZWkxzXV35ueEto6mG27HfvKwuDg0W+ZjIoE
	 xnVqQY03+pDWmkQef7urPe5XGKmBDsnhH09Uahn+MI1CiC1FH+/jI8Y4rf5hZHPj+e
	 TYnyYPdax/RtAbWo+IZ2uOWYL6cacsu3n/Cnn3SqprbSP5phS6I7TulDGAUIDsy8fB
	 rrX/QxRE/1Dr0V3zLrJfOuZ/DEM8M1aKecVwQAVDPB31xD/VAp1DrgNBhoPAVk1wu0
	 2RUGOhCnRndoA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 08/11] mm/damon/core: reduce range setup in damon_commit_target_regions()
Date: Thu, 25 Jun 2026 07:23:53 -0700
Message-ID: <20260625142357.103500-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260625142357.103500-1-sj@kernel.org>
References: <20260625142357.103500-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 815ao6gt8ao3iqoije18pd53k4wkayyg
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 19D7AC0002
X-HE-Tag: 1782397490-829284
X-HE-Meta: U2FsdGVkX1/UunWkTgfFt2VSkrKsjSPQ2b8gJBit3X9tsUmCWkgEpC6THbn00Fg3XRDyCrO7YyzZFg9kZ2mSuuY6306qTQQcYH8ezyjq8GKzm7ja9Kv9wkaWFcuSRd3CHx7k9gszddb22U/WgZNHHzyofSv80JfJ8KzO5lwAMZrGhJC1owfyo8AfZFJ95SSD+9prsQzOpcVWWioCwogMreNG9CCUny+dHfM4EPJcCBAkKvRAYnIp2Y5o381O4DYiDrV9WofrlqlzvSabeBKhLpLQ5eTozFlG0US2l5mpK207bnzDoOJrc00+7H2irttDfK7J4fNanHjNr2268yV4jaOCPjYTRpn2OktAxvR3ud+QVQRxkC5yqmGst2P81U4hbQcjmwdU4NB8phqi4cw88JAGhbHZDHQHZEd9HSJDkFbIoxdOS77sY9YIDNVvreoG4B6nhaZ6Q55Cd/Z8zJVHGE5VpGmrLZu42rYWCsOfbN6Gm0SGfxrCdoVq3IaEA3EKUyU8jlvlrg3dYlUIfh9dgeoQYXyubpqz40IANvFIR32lHv0pEkF7oSff4iOOL5Vf/QlqvRNlOzdknZXJzWAtsBnnN30SAJG8zJMjprOs6pP7sVS7uUKnebiMVfc4YvbRuJ6rqQn/CLlOGBFfGCtLM+s5YVJ1aGxcTZ7ov3ycozDy8ET/BUpfdly2cGYirjQDm6SdHSuOOzoU83V8adV0hwWItYjE2JYD5PXEElL4SDIaCu2Ko/+WBp+mkXnV+LVC6Rpuykg8wcW4Xg53P5zCTGghbTtXgrvzq1Vi7AAnY4jKdgSzbIxhXDr3+liAJ8cH8KAKcpe+ccA+dVVWP5kkijBQDZL2LqUJf55FCoe09BIcHnr1gdx3kpGqpgu17E/fah3H9ysnYgAUE0xOv5oSDmJAys2c7uPT2BKAd3ntfKSrq+TWGWwb6PCcYd6dB8A2WnaeT3IiMfTO5oKIrXE
 LsLpd5pB
 LFJJQxX1r1Hr/g4+Uaw3Of0rprKW9dH0vvALIjWb1FFDFElP7/X++GfrBR2I9D211zfOpkOz0dwKwzCMZnZ6XrQjAyvIylmohT+XIzg1zltsOgWbjgSh+s7YwFqSw+jmx/ZrPJmM2hPm8njz52GClTqMZaQd5U/JmeW3hELnHTVMFdZ9/1XatKoZItQdBObUGD2Sauj0wwwAZd8ZydEDCSFwurrSd7PATuAaklnZeUSbcmEJpo1eH8k1zcHatQP8yRUlg9KMpFOYEFKNTHvU0YgY3zuvTXgoKaLrrPYzrO398uLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_commit_target_regions() calls damon_set_regions() for updating the
destination target's monitoring target region boundaries.  It sets the
boundaries same to source target's monitoring regions, even if they are
adjacent.  Meanwhile, damon_set_region() sets the destination target
regions exactly the same to the source, only when the target regions are
empty.  When there are existing target regions, only a few regions are
expanded or shrunk to fit on only the boundaries for disjoint regions in
the source.  Hence the adjacent source ranges mean nothing in common
cases.  When there are many regions, such adjacent range setup is only a
waste of time and space.  We recently found [1] it is actually causing
memory overhead.  Setup the ranges for only distinct ranges.

[1] https://lore.kernel.org/20260603112306.58490-1-akinobu.mita@gmail.com

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 7e4b9affc5b06..ce5294cb1b4f3 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1349,21 +1349,33 @@ static struct damon_target *damon_nth_target(int n, struct damon_ctx *ctx)
 static int damon_commit_target_regions(struct damon_target *dst,
 		struct damon_target *src, unsigned long src_min_region_sz)
 {
-	struct damon_region *src_region;
+	struct damon_region *src_region, *prev = NULL;
 	struct damon_addr_range *ranges;
 	int i = 0, err;
 
-	damon_for_each_region(src_region, src)
-		i++;
+	damon_for_each_region(src_region, src) {
+		if (!prev || prev->ar.end != src_region->ar.start)
+			i++;
+		prev = src_region;
+	}
 	if (!i)
 		return 0;
 
 	ranges = kmalloc_objs(*ranges, i, GFP_KERNEL | __GFP_NOWARN);
 	if (!ranges)
 		return -ENOMEM;
+	prev = NULL;
 	i = 0;
-	damon_for_each_region(src_region, src)
-		ranges[i++] = src_region->ar;
+	damon_for_each_region(src_region, src) {
+		if (!prev) {
+			ranges[i].start = src_region->ar.start;
+		} else if (prev->ar.end != src_region->ar.start) {
+			ranges[i++].end = prev->ar.end;
+			ranges[i].start = src_region->ar.start;
+		}
+		prev = src_region;
+	}
+	ranges[i++].end = damon_last_region(src)->ar.end;
 	err = damon_set_regions(dst, ranges, i, src_min_region_sz);
 	kfree(ranges);
 	return err;
-- 
2.47.3

