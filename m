Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 133E7C56208
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 16:21:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C68AF6B0095; Thu,  6 Aug 2026 12:21:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3F9A6B0096; Thu,  6 Aug 2026 12:21:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2FC76B0098; Thu,  6 Aug 2026 12:21:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85D7C6B0095
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 12:21:30 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85044A0137
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:29 +0000 (UTC)
X-FDA: 85071359898.29.543106C
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91281C000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 16:21:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NcLdMqeD;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786033287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Siy56LUg0D3k/aJEZkR3M4GURDeHhGcCXphn6iQtEPY=;
	b=uWXKMAa1PDzaey4MOfmGnvRKj0VW2Z16zaOTDeSZjMhYxEngkt9KF9tfWvYnb6gl7a0CF+
	c3PLsafVtViDnJgkIGMA7WicilyN5DdRcVfsy1/2dGq2LJldBMQm8kcJIqqhSSYRaiO+Hu
	Rv80WTVvVMihs2hzvjxk5kZync79j7I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=NcLdMqeD;
	spf=pass (imf10.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786033287;
	b=5P7p3uEJtmL7bo75T5Kovc5F+lLEq9a1mNTNYJ4VbHgeaa+DwZRyzOf17SocV+L1k9o9ME
	T53bREY5Cdr3/mBTrY4sjHo4wdHsmCoBzSG1/xChUHONwRpfek2iJXezb505y+UDPj2jam
	VwKlUAtA0+AUbGlfNyah3bzybDqx4oA=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-84867f07d63so2898668b3a.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 09:21:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786033286; x=1786638086; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Siy56LUg0D3k/aJEZkR3M4GURDeHhGcCXphn6iQtEPY=;
        b=NcLdMqeD2M1gjT+hblb7Z2TlgtRQQg2sAu6TJT1SU//tV8jIcqDZ+lDWHJmezEB//k
         r0Mi+fxKCZ0ZVOpAzamehaH4QwS25bA9oucNrws5Lp9uFBnn4rqquE4vQTonkrtTojaZ
         McnwAs65n6cqqiVlzPhwnzjFkJqNNU/3IjZY4D9f3vo0brthIwDe0Aapd9EbAerdbkRB
         8n9qVOPddboYFR0y75i5GH/NMq6YbJAVlc0DHZu/GyUzDddnrkjLtVGfvb12W/h3oce/
         41Lypp4/ZXuEwCbH69D+6KEjKBDG9Qaz2S6aSTLKYFJuK86VMOWvwklig6YDt7Fzr7dU
         ps7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786033286; x=1786638086;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Siy56LUg0D3k/aJEZkR3M4GURDeHhGcCXphn6iQtEPY=;
        b=cCL3JFXiztcnMzBllEG1jDrnL0QSjLeZGRv60SPpQRli2kTykoSd7QslatNC98j44i
         bzU0ue7bz4vnaFmtTUvwfkP6+B4CoyMyZ84ukdp3tR7BT68WtflFjk1zszXtmxh88oLs
         +hOvjrMsjuRudqo4ZqOB4uMUzPLPLfSTL+NXLbvZDsnamf9gxtSUURpzpFF/Oq4Q2Set
         Nkcorz1Is54aBdmsLA9H3y21BMpmOb9v2NAAo7OozM7gE3zmgRGUFEyLKBDRCq0wLpKJ
         0lgIfA9d4Ol0Ssx1sQhsyq2nDZxybIizOEdJp3LFbCIqI/iK+mJGlooCB/0JnsNaFHMN
         yNxg==
X-Forwarded-Encrypted: i=1; AHgh+RrY/DWvvPKiVhcIRzaJ1H8sHGzfVtwWBZbX60Ye/vr1daJB+uvG1Maj8dM3rIRt+4xd46IVJxhlcg==@kvack.org
X-Gm-Message-State: AOJu0YzNI01mVjCm9CwmauhmXe4uD7O5cYNwQwwLNuRok1vn859pjEDL
	aIZwdbtXzcHxayNa8JCUCQDnqX3+kGiq5vpfb3CPrx09B+HDk0zhhzIH
X-Gm-Gg: AR+sD110W2w/MqVNXu99djd5/5E5pJyQhaYntB4ObVXuTHGGWJwKJBvy3g8rYO3NMLf
	veGmP2VJBYHziuQjkqvcv/PSkCSokYFwM03MNshMms7h7VC0u9xXU3voJ953jybcupf5rah9I7B
	SG7tlI3pSXwft+tUZUxaf30qrHma9lgea94IOmkE40AcA5uF9wK7JhaEIT8fhjbaghE2XgLSB72
	q94+Y7o+r8bdj7o+GJRNQ9KKmczjo/TPSZtTY12LIiiP23aGMbtUNNGdRTe5F2rsgDvD7iP+uey
	ZWY9Bn/NBq3JaGtvA1ReNoQA2AVBbgedkiD/iGnmtLsylu4rDrP4BxL5vAtUDxeIhI14PQ4Ah9P
	e/jwW8X5lNg+vUvbdoGVH6wSwKTCtLSDEVcqJfjp5f/+LPYeb9Mr7AXYLIKPeYfhmg1bEzEs4h3
	TclyXPMVqmd5Ky5BrGfwgrm8zdA6KOpyVOhq+7Xsmf9E9YNqZKLy9ylh/Y
X-Received: by 2002:a05:6a00:4ace:b0:84e:e741:175e with SMTP id d2e1a72fcca58-84f2e0294f3mr19717547b3a.31.1786033286323;
        Thu, 06 Aug 2026 09:21:26 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f459b66e6sm1662739b3a.40.2026.08.06.09.21.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 09:21:25 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v2 3/5] mm/mm_init: move the range check and clamping inside ZONE_MOVABLE branch
Date: Fri,  7 Aug 2026 01:20:54 +0900
Message-ID: <20260806162100.313965-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806162100.313965-1-ekffu200098@gmail.com>
References: <20260806162100.313965-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91281C000E
X-Stat-Signature: 3ou74makabcj57ttqdp1uez8tjwd8351
X-HE-Tag: 1786033287-63955
X-HE-Meta: U2FsdGVkX1/UxvhlKdJtxUPE3jxhIy6FVe835qZmVSqHwye00CW5IxY5T9/kiTY1uN7SdnfBx8YMkV9oA9ZAJ9PR4PkXFvXAO0NAKpOsS3hzXM3rJwp7VLwElnjl4+hxLzCrDg3kXg43x/1bbGrMOkTUD7z5EXSFoLbhUBa+evnDaeQ1aikxYiPnf6tmq21qOi+2iBsQfCKcmuxCsDrHJoF4+VYzj8urSw7+KFEfhGAp07m52cTb+LLROL+ltu3brEVPd5TAMi1L31BQX8ZSqCfkAYsmLHF7CPFKVaephe8caKBy/4neT/32U7nuorLImetVt+pxJwQSB9DL7dhmdfH8r5pPXsY0MvLGPBpEV36fx23X/1tzfhh1Jogd9VHQus57G/KPRf7X0PPFby+HB1Qq9+nE0iO5vr8XJzHxHvkk2G5Q3NmFW4+vZ7BJw966xBPQNJBT9kFpx+NgJ1kp9cyJ16bWp5FnULWr+jj19EY0jcMaKGHLDE/HXxa0SsrHq7zA98ZqTp7zIdAwgkqx3DTyxSTROgOxJxlPbFL/0kJfObNczjwHs9YTrTePpnKD5Y1N4su+TIRHyGTn2EMnIAxxs97sxwkBzGMHuZh0ea93QYADBFi36Y02hMfixO7ktdrXLCK2PvwwakFS51HAkIAMo3GbTbUDQ2yIbm1DyYp3/xI9SjinIm+tIMugmE10c8kGpmHluPmcO2Ks8sOBPxcYHpQ3mfpFmhf7mjWt14uUQaTfL/wTAJk45ToecR+AL1wOxLiKVuxjR/+hqOspnhXg7jErmVqDIxdss870vIUgNZmXslTI39gjczXjQ9C4kHr43rcvYOWfuB+GNkzMTYMQhIiqI+UrxUUo4yzhUfx6LjWMFUagNgx9iG98Wc9MuJKbJ+PvWJRXTOJ0k9Yun2PeRJL4R04a10iKQgsuDvuRCAnEjyAm203MXyjJLex++n1kEm5iflUeMNoJhYx
 2tdZ2oFP
 Ocd2rPpsq60N0QKn/b3ntFgVY0Nuh5bybbjKwiNk/9cpZOsHCqDVoMaoJVNsQyVaxoBLZi/57tPZxImxwfFAJ7wFeiGmXMJrAkeZWcdhzBaNEuZiXjZlXjmO9vaZsBA01l0N/qxdxbCPWNhma055UjFqgkql1UtLpOSefKl8TIHm5OAvgXKKrvoREykJQvQc7eId8chCC74gzd9iHTZ2Bw4iMrKOR816Oym7MLqZ/fVeYG9L1Geijw7fUpT31kwRnIisRlo7fvrJ7kmBhTNu9skcaG2iewyM58zjO5Ikbjk1OpBlNOjP7MOU8rkpOkL8ftU4qqkxLQEDdKYd3zRpfhzVhPaU5dSYm6IazNB8oTmx5pgohVXzfu8CjX0UjwjpMAaDh7nxDVyEcZXuC6jkwSOSr9GkSswFbTPNhUI4dv1JDNqGLXGfio06RbqBxikjQSfKlboiZvGG+rSc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Outside the ZONE_MOVABLE branch the check and the clamping have no
effect, because every branch ends with one of the following.

 - *zone_start_pfn == *zone_end_pfn, so the function returns 0 anyway.

 - node_start_pfn <= *zone_start_pfn <= *zone_end_pfn <= node_end_pfn,
   so the check does not return 0 and max(*zone_start_pfn,
   node_start_pfn) is always *zone_start_pfn.

The branches set *zone_start_pfn and *zone_end_pfn as follows.

1. If zone_movable_pfn[nid] != 0 && zone_type == ZONE_MOVABLE,
   *zone_start_pfn = zone_movable_pfn[nid] and *zone_end_pfn =
   min(node_end_pfn, ...).

2. Else If zone_movable_pfn[nid] != 0 &&
   *zone_start_pfn < zone_movable_pfn[nid] < *zone_end_pfn,
   *zone_end_pfn = zone_movable_pfn[nid].

   The condition requires the clamped *zone_start_pfn and
   *zone_end_pfn to differ, which cannot happen when node_end_pfn <
   zone_low or node_start_pfn > zone_high.

   So *zone_start_pfn = max(node_start_pfn, zone_low) >=
   node_start_pfn, and zone_movable_pfn[nid] < clamped *zone_end_pfn =
   min(node_end_pfn, zone_high) <= node_end_pfn.

   So node_start_pfn <= *zone_start_pfn < *zone_end_pfn <=
   node_end_pfn.

3. Else If zone_movable_pfn[nid] != 0 && *zone_start_pfn >=
   zone_movable_pfn[nid], *zone_start_pfn = *zone_end_pfn.

4. Else *zone_start_pfn = clamp(node_start_pfn, zone_low, zone_high)
   and *zone_end_pfn = clamp(node_end_pfn, zone_low, zone_high)

   a. If node_end_pfn < zone_low, *zone_start_pfn = *zone_end_pfn =
      zone_low.

   b. If node_start_pfn > zone_high, *zone_start_pfn = *zone_end_pfn =
      zone_high.

   c. If node_end_pfn >= zone_low && node_start_pfn <= zone_high,
      node_start_pfn <= *zone_start_pfn <= *zone_end_pfn <=
      node_end_pfn.

So move both inside the ZONE_MOVABLE branch.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/mm_init.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index bdc15de0a62a..fa6b5977261f 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1205,6 +1205,14 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 			*zone_end_pfn = min(node_end_pfn,
 				arch_zone_highest_possible_pfn[movable_zone]);
 
+			/* Check that this node has pages within the zone's required range */
+			if (*zone_end_pfn < node_start_pfn ||
+			    *zone_start_pfn > node_end_pfn)
+				return 0;
+
+			/* Move the zone start inside the node if necessary */
+			*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
+
 		/* Adjust for ZONE_MOVABLE starting within this range */
 		} else if (*zone_start_pfn < zone_movable_pfn[nid] &&
 			   *zone_end_pfn > zone_movable_pfn[nid]) {
@@ -1215,13 +1223,6 @@ static unsigned long __init zone_spanned_pages_in_node(int nid,
 			*zone_start_pfn = *zone_end_pfn;
 	}
 
-	/* Check that this node has pages within the zone's required range */
-	if (*zone_end_pfn < node_start_pfn || *zone_start_pfn > node_end_pfn)
-		return 0;
-
-	/* Move the zone start inside the node if necessary */
-	*zone_start_pfn = max(*zone_start_pfn, node_start_pfn);
-
 	/* Return the spanned pages */
 	return *zone_end_pfn - *zone_start_pfn;
 }
-- 
2.43.0


