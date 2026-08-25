Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3A496C61DBD
	for <linux-mm@archiver.kernel.org>; Tue, 25 Aug 2026 12:02:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 485EF6B00B1; Tue, 25 Aug 2026 08:02:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 436D36B00B2; Tue, 25 Aug 2026 08:02:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34D966B00B3; Tue, 25 Aug 2026 08:02:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 146236B00B1
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 08:02:25 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C984A02F2
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:02:24 +0000 (UTC)
X-FDA: 85139654208.08.3C039C4
Received: from mta0.migadu.com (out-214.mta0.migadu.com [91.218.175.214])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7B03B16000A
	for <linux-mm@kvack.org>; Tue, 25 Aug 2026 12:02:22 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e2Jxv3rU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787659342;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RenFUSOqV1gz5ciKF+hdTDfGTvf87pUfzq8Dx+44X7s=;
	b=iqXhM2b4Eezh8CVuLDD8O/NsOdOU5IoOajxKPeVPVKcAc2aHiCvjwoel8qds7h+uwB00J+
	k1X+f516GD1g8yt+1gcNzXaJG6PmRTS7fvULH/nVrWBXwOQVj0AveUJGI0p7n+EMttQsNQ
	cV2a56TngjiJQtZYT85LBemsUPOOBWM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e2Jxv3rU;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.214 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787659342;
	b=Xz15d+DKguBoRYgvzhT3M+k001veCyIZdTlKwqJWbBH4AtwEYRoF+qXRMDkV3ZokftmoUT
	q7mwQb+SUqsFm7k5/ySpm3Q5CPNG0AQ8YgAzfRXWjetvW7HAnsg0Z96dvDl68fuXeuPTic
	4288zOh8OTvEiUfkFqRYvHnxYp3oaSo=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=F10YmlO6apGqfUY4pH79O4UBnWaDT2uzM2vlHZEvwc8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787659340; v=1; x=1788264140;
 b=e2Jxv3rU/BVOOF/XlsLRYuW6TJVaPCLGXp8de6AP9i1ANC86JTqyrQx8U17azoX9m/GfILPu
 /LqXhNsNGM0EUWa10IOs0s/GS/Fg9bs/ltmuiJDxiwbrKy0LywN7Y1nPJrZ280wjHbsjCe8ca54
 MLrJMc1iH8+WRvkqEnnTLY6o=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost.localdomain (223.70.159.239)
	by smtp.migadu.com with ESMTPS id 95c8932470f5c4c0;
	Tue, 25 Aug 2026 12:02:10 +0000
X-Mizu-Trace-ID: 95c8932470f5c4c0
X-Migadu-Flow: FLOW_OUT
From: Hongfu Li <hongfu.li@linux.dev>
To: hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	akpm@linux-foundation.org
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] mm/memcontrol: remove unused memcg parameter in calculate_high_delay()
Date: Tue, 25 Aug 2026 20:01:53 +0800
Message-ID: <20260825120153.1405-1-hongfu.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ezm5zy7byxrfhp69mmqub6nqcs3ow5cb
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7B03B16000A
X-HE-Tag: 1787659342-772197
X-HE-Meta: U2FsdGVkX1/lyFfinKNmI8wJZAsyxiBpY52av2V0f/aZ7pa9uosaqMNCSaWugsZ6Gw7v7Y4Fhf8gaAiWmoj76uhpp7oNyA5J1ApkgtOh1xnvMdJj33Ie+tBW2r15JHyBnSE2w00eEcKqw84h3L0DS6h4N6PeQPj/TSAhux4MAhMzH6Vmg62kF01LIW0WZg2vom8nQwTK/pvuwO+j/b6UwttIRqXsI49jhZlVCIq5aR8o6mMUuZ78k2cK2Ur9TXdRxYDezhJTCAw/L3qq7s+0Bd83/jEGnjZz+m8H71VYAxnYg4EFwiuzX6ahHYC7MpImTyMNt3OP8V16Ccb2JBYlqW8mfQXvcsTyFnt4XrQWqa72gAQYWmdRvHohcNL5Hgq1BvSuSdGiYQmSCAC5fhQLRBZXYeOU7XOEmYZpiOivR7GWYyMxLwxXmlwnBr7RmJsIWvMTILr9yRFhWW4+xXb85BupOorDzIEBejaXQ7WpZkDxk2YfrDa7Ce5xRBLwE2cUdquTTP36zWz1Q4whR2rJZ+cg5a/KyYYwEeZt2Iv/o09Vq3v+Fuy8VQvb5VakG8MDPvJ3PqPfB+CyPc9xWW5Kv412bJZsSU8tzs+hzHaWjvCk23LOkvXOAoE5C6rzYvk3XzOL+ly5nTUnepHqi36oIuLro5NgREoY4T60SeECY8y3GqYa+0M6dzytEJE7VI5MoO76cIcuhEqpNsER64qLF+weOqqDkz1w+JqpJI3xwrvne1nfmk01PJS0gX38zGyExTzaECGXaK7ATAipVbEQdEFj6JTOpzBy2fqL6yReAlEKFCJKEvnZ/SYY9fE2c4zMh9Ie43Zxiv56BW7OB5WeGN3CjgSWyg85Hcfn/bMjW9oLT8HhzKl+4BlCDQilNzyXMbnJRd2tOPuQ5Audjrlq8XpQ8uD/lp3oFR5ZSy/Pfu1xKZAfqU7rUBROxEDbGv31yBQxOLpsuWn1D+mohzM
 UzOPIeMt
 CKtF6EZ+Mw5KIoOYiteFhOlvfCgwSkkNdkDG+7p90GMZzo/da1vS5N9gyZaFoLAgobmQuDXl0pA5sCSZmhOJW1JL5zYFVcfcUC//qHWEsyMzV38v6H0GtmukWuFzwx+iCbT4PyTweDGw6l9KeK5wftaRGrWwogwT0u1LHLua/kDgf0ODsb4WBJuHhRQqVwEUXqd8yQ76x9juHoStId72HcCrdDSKtsoeL/P+gJuFE3w7tBhF9xwvHJ/XMFZWFeZYqM93eGAqMD/bNbViiqu5fftNQzQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

The memcg argument of calculate_high_delay() is never referenced in
its function body. The delay calculation only depends on nr_pages
and max_overage, and both callers have already obtained max_overage
from the same memcg.

Drop this unused parameter and update the two call sites inside
__mem_cgroup_handle_over_high().

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 mm/memcontrol.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 11b85f4b6828..8bdb6988e7f0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2515,8 +2515,7 @@ static u64 swap_find_max_overage(struct mem_cgroup *memcg)
  * Get the number of jiffies that we should penalise a mischievous cgroup which
  * is exceeding its memory.high by checking both it and its ancestors.
  */
-static unsigned long calculate_high_delay(struct mem_cgroup *memcg,
-					  unsigned int nr_pages,
+static unsigned long calculate_high_delay(unsigned int nr_pages,
 					  u64 max_overage)
 {
 	unsigned long penalty_jiffies;
@@ -2594,10 +2593,10 @@ void __mem_cgroup_handle_over_high(gfp_t gfp_mask)
 	 * memory.high is breached and reclaim is unable to keep up. Throttle
 	 * allocators proactively to slow down excessive growth.
 	 */
-	penalty_jiffies = calculate_high_delay(memcg, nr_pages,
+	penalty_jiffies = calculate_high_delay(nr_pages,
 					       mem_find_max_overage(memcg));
 
-	penalty_jiffies += calculate_high_delay(memcg, nr_pages,
+	penalty_jiffies += calculate_high_delay(nr_pages,
 						swap_find_max_overage(memcg));
 
 	/*
-- 
2.54.0


