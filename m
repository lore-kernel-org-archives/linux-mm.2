Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9723CD8C92
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 03:43:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 57F856B009E; Sun,  7 Jun 2026 23:43:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5572C6B009F; Sun,  7 Jun 2026 23:43:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46D256B00A0; Sun,  7 Jun 2026 23:43:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 35C5D6B009E
	for <linux-mm@kvack.org>; Sun,  7 Jun 2026 23:43:22 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id ECA88120919
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:21 +0000 (UTC)
X-FDA: 84855350202.11.6E1299D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 532E020002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 03:43:20 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LDGPIPI3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780890200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XwgOL7yvpTj5e2kxLuLeC19oCe8j+WMlaRhCcir6U04=;
	b=v8X4IzolNLTI8Y89UIjU/nwG4txCHJOLcV2V4gyIYzonmUGfh1hN6qi0h5Il28rDM0HDNk
	2PyMIZiDn36m1QyOufHNq2KSjKGzv51c0fsa3s3sbXHYhFTme+OcsyzqlkJQcUuBvZT3+e
	ojXhQ4JGR1J7ZgG8phg66Gpisrz8AOg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LDGPIPI3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yukuai@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yukuai@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780890200;
	b=6ScUdr1pNEa2CGoCcsHJtJwF+c5iwicOMSsWi0zo51TR8q0ZBi05RjaFJsDxkKbJe80a1z
	Afsk+xpYjcEBBwHORg+N/1kDmzQAMxFOMHYxBzZJ2gX5JDfULNXeGcdQ3AGWjhRiUOGapk
	IScz3B2WuovoQxmjoNpCwDDXLhzlYBc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A4A5B41AFB;
	Mon,  8 Jun 2026 03:43:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 746AB1F00893;
	Mon,  8 Jun 2026 03:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780890199;
	bh=XwgOL7yvpTj5e2kxLuLeC19oCe8j+WMlaRhCcir6U04=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LDGPIPI3GjdPwnLL9bjwz5Ut16DAKbzD0MWWoYlfOPr1iX4p0iex98B6R8tY6cYXZ
	 sm/xc0jjukwVKIcd44R0eZa64PXHKlgMy/jGZKCxdA8bQsTgASJ5205uziCMyWd8dQ
	 Fkr8CfyyACcK0F5z451FQy26fZMS9IwoFs8VoEh0kuxoMslVc9r4NWtgSpFIcI87q7
	 brG88enB38rlb18Y92U/kTeZfBA3UJuhjS9Vw3l8qWa0JbZjqAdBEPNRP8XRMaHkBL
	 t8ss7c4DgHIjI93/bX8Yo4gkCt4qpuwdk5r18Y3CwR0bqVPIbYNRfNjcEo/zU0wUDK
	 K26gkMCakAKuA==
From: Yu Kuai <yukuai@kernel.org>
To: nilay@linux.ibm.com,
	tom.leiming@gmail.com,
	bvanassche@acm.org,
	tj@kernel.org,
	josef@toxicpanda.com,
	axboe@kernel.dk,
	yukuai@fygo.io
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	cgroups@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 5/8] blk-cgroup: don't nest queue_lock under rcu in bio_associate_blkg()
Date: Mon,  8 Jun 2026 11:42:46 +0800
Message-ID: <8496fa234b21d4b31b7f068766906d0bffcac8e6.1780621988.git.yukuai@fygo.io>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1780621988.git.yukuai@fygo.io>
References: <cover.1780621988.git.yukuai@fygo.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: n77hbiu3mcfp3q3qwjss4pz4i31e5ept
X-Rspamd-Queue-Id: 532E020002
X-HE-Tag: 1780890200-481655
X-HE-Meta: U2FsdGVkX19MSgeC3/Gwk018nN1tMKqCJBVI0KgqPSiBQS2wv2vT0Tuy2bvgc6nticqqz9nzE6ZpacRCa9a0VwW2qAO6TeV1SuJ42Hcfca2p7Og47D7ARUSLRyzKg/Slf4d1uEILMyLATb0C0E0/INpQIqWTvsN5OdyeXNCOthUJ6qSNlk5CHj2jo9ixAkOEjJzL//0SsWXlj5Xy+DqFVjFLz8dTm14oUokbZ2SKKt+OpIZKThwTwroMbnCVOslcijrdYKR5yrdHafoR7+TWZ3yhLlnNFH+Y3cnxIGMJdobXzJvy74+ol0iSrWyazGh7a4UXMLNTYSxKjqzfzWVJlAQeuyJvZmMnOdFYbtf64CyRBohL0AT8C8wxBqC+qOQo3QSjphDZmsub0I/PK78Y6rc6JhXE/HOa7A+bHnrDKiR+54FjA3BehYCBk3jD2p3G+qmpkZt3/EbEkIW32qK//a/esgE3/slarjmvYkggtmbhx1jyS7cPDqvm/VOm9favREK+ZpCvEbdX1sKaR1bQlZp4RtL0nkT/Mnon01FJAnzqJc0MzHGm1Qt5A/qVUeqVq53PuWu4JbVWZ6b/VCvt92OWrIa4CT9V5oAKrheJuIUGSqe5XoS+hUaCC5zCJSIsGc2uKlI+XhyaYyKcEB3J13s3pXwakknZ8VT1EA1NFJNuZW4gx1jBq/Xv+F+x3Id3J6UzMPOZyHxwoUW8K3SvB3TzEZPOvtK83mgd+Chct86TveaB8tBYX07DPTAeRTdkRUpqYnFIjvbfHGbuG6fLO5DzOUV05kVeJT4eJ1KHlNkg57pKhbypL9PAjbG6eWQSerQUcppl7F5UewR4k9XI5lZpiJBF4P+FBAPR6MDJQplSi/SBTmZlZ1qACGUI0JgX288+zhEqlG3eG1vZl3RcPLLCwT0BvLj4fAf7Crwkk3MzCbebubIeoPi9AwdS0LDNSGiI1Bz+4p4EdY1GKAq
 MrJahg9o
 y1AyICGioBnSdpGgns6Q1eS5R1p/aHGcVOD+wxO6cMsh9AMYt/9aLUiKtqoilshCf6+0pqD8a4lq2WmTNJQRKGquPHpmEaAiA/fnybQ+JrX4Awrz4si/BkKqUmdFU+p2AMw4P5OXqh8JbkZbDbWcsNdXr0w0ptaNTZxbYkC/7AlvWyK55SOn0JZct9ox32rr+N6F8S5DvS4vjsBV6qEJiMCENZfk3C0JM2VizybJ9LrvGiAHBzKukeX7jWr3IigHGg3+luj6PcLUK3OmeS9ogWoWuN5skZ9jRE5Zb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yu Kuai <yukuai@fygo.io>

If a bio is already associated with a blkg, the blkcg is already pinned
until the bio is done, so there is no need for RCU protection. Otherwise,
protect blkcg_css() with RCU independently. Prepare to protect blkcg with
blkcg_mutex instead of queue_lock.

Signed-off-by: Yu Kuai <yukuai@fygo.io>
---
 block/blk-cgroup.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index e2896d582235..8c9ca52a54f4 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -2186,20 +2186,24 @@ void bio_associate_blkg(struct bio *bio)
 	struct cgroup_subsys_state *css;
 
 	if (blk_op_is_passthrough(bio->bi_opf))
 		return;
 
-	rcu_read_lock();
-
-	if (bio->bi_blkg)
+	if (bio->bi_blkg) {
 		css = bio_blkcg_css(bio);
-	else
+		bio_associate_blkg_from_css(bio, css);
+	} else {
+		rcu_read_lock();
 		css = blkcg_css();
+		if (!css_tryget_online(css))
+			css = NULL;
+		rcu_read_unlock();
 
-	bio_associate_blkg_from_css(bio, css);
-
-	rcu_read_unlock();
+		bio_associate_blkg_from_css(bio, css);
+		if (css)
+			css_put(css);
+	}
 }
 EXPORT_SYMBOL_GPL(bio_associate_blkg);
 
 /**
  * bio_clone_blkg_association - clone blkg association from src to dst bio
-- 
2.51.0

