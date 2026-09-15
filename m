Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 865D0C88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 06:09:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9184E6B0092; Tue, 15 Sep 2026 02:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3A36B0093; Tue, 15 Sep 2026 02:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 769F66B0095; Tue, 15 Sep 2026 02:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E06E6B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 02:09:51 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 33B4C160308
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:09:50 +0000 (UTC)
X-FDA: 85214970540.09.2788715
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 608BD140007
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 06:09:48 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MzIK4Efw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MzIK4Efw;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of kmehltretter@gmail.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789452588;
	b=XzELBVQ2OBuq4a/2HM+LDW6Do62YXG0SxvmXCgOtvkC7onJPm/dWGgd6wViW52Kuu7iVY1
	G4TPpkZoyzCWnCb8GYzgsHuAEs0rLgz6ikGze97Gp3N3c2qDkeBInk9VTq3y+DLbONWqkD
	G74YvbI9t8v6vl3iSsoVM8AE5Blrl1w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789452588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eHs3rghcFG8c8Adwq/+j11WtqFeOvFLLNzQbYygfDg0=;
	b=0I57Ha+kbawoNd/3bRSFKVmE/+EdpVxtCtZjeDvchUU1XHKGh44wMKbc6w/yhKfU9P1rig
	yiH2oKcYjIBOvp+pFvXqvLPoSttVoss9efX4T+ISxa0xo0nbiSrhY0qL0RCe8jOwJTavRl
	7BhX8patM5CAToiYMawbae5CuY14NVU=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4998b5a63e2so44693885e9.1
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 23:09:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789452587; x=1790057387; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eHs3rghcFG8c8Adwq/+j11WtqFeOvFLLNzQbYygfDg0=;
        b=MzIK4EfwK1Xhb4d/0DOoZR6qya0HYEZtgl52xve7aOFI09ZsuiQ431qZXnbKXmll/y
         OV8IcZlZnmb3LXT0yl6JcL/3rsqpdXNjk5b79pnRUum84Y+HVSxNH0SYjhGY1CI1q1pl
         xHHlW/YGMOdp25lkErn9AdUUr29EwNZYtadQdX7onRblNkIJCp/rIeE4uCHBWgAB/nI3
         FIQedTv/HD/x9Rz8l5/Ne2n6mNcOr4Bixr9Ewut8mYYbTimhio1bO2hOgjVhIbxoxNKj
         LPdgyfOEIA5k1mLDe3WxLGMrFA+2vXB8SdHxUgnyTc6X5DhxAb8tx/bfPuNUFOAQBis9
         ajhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789452587; x=1790057387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=eHs3rghcFG8c8Adwq/+j11WtqFeOvFLLNzQbYygfDg0=;
        b=A457kJSLsVUcSW1uHmE4J/vdaBFXibFERYsJvgIFJw2Z1G2ngpjlYpjLRKANvU+pMQ
         h+1Xa0o++no2z80RaTsQZ3NW0hiQMOlp461Uyd+VgBb7dBJMCKVsjppg/5ltVrvC/7t5
         Tz5aUs9Ed7SmjmbGlnk57woGP/B0w5ugm0qCF99FU7GWJXKx7lP9Uc/4Tix3tml/GK2p
         p057FfQ89VHDmF8L5/cPvEYx8Lib8wrvNi5ZfqGbLLW4jMPnEVjm+GPvQZjMg4Y6gmWm
         mHMUWg/oyJJr6b3ETtxVjiJsra4x4URcA+Q5unaRjd/CiW7GKHYI+vkMmExAYNiRIOGX
         MCRg==
X-Forwarded-Encrypted: i=1; AKwUvByLi4N9AYY1lntqWbFN5o5ymr4KINVKl7r3Qgc+dW1upZJr88XweoBrZS0JPsFWYagmyvuBhWw9kQ==@kvack.org
X-Gm-Message-State: AFuF++nqEmwTJLlQLLBA5tMvrLF9iO+0DSKfhxRbd20AgNb+x9nYrC7W
	4+uKQ57LjEUSW655I00aDuuFK7oZPYPCRPIoJv3Fm3Mmote/TqK37ZFP
X-Gm-Gg: AYBFou314R/N3sPh6oDq6SWCIU8n7Ll0pld8QdgTILWwtN0HkfHcO4fe2Usji0UlmzB
	6jkLLs6MNJuVRJF/jd8y2f4Mq1Fml5QmmctjVkg/9QpWeNt6IoUcO73U0m5tISKHve04HOFNMBB
	fFe6Zirqbs2Bd7PlLGMTN9U0Ca6J/mS13hkReSnbwWCSuUsJmdRPgP0sGSt2+DjuPqAMZdqFrCO
	cyVk2RGTGttGhdRZGFx8bkPyPD/MY+DZR79YFguly9SWpNxCuGm5QlbNtk7Qsq4Fp0xZ/L0VtMO
	HOelXC8E0Po3rDRUBypGgQPk+kPOzA3TjN/zNbroyoH6ILZ/gWl/qyoz4q6Z833TI1zduxx2WLJ
	xGlE/w7atiNDUH/S4O+M803rcU7yEHT4Xf454SCgSmfbRQSaZkFhGSZ9UFIkn17feknholb1gEe
	NXLXZqsHVkFykLVp4GhhrDP+u0q9rgs4ZgMWDT9ESDwCdYn7sva6kS3SIVCrT07gFDa0Epzc9o6
	iashXp6ilil8rVxQ9P9R3EpPApr0uY+ARaOAIaN2pg2WK/z9Z6HLJFk+fJi83OnsntVajh7xHQX
	2EavHXVikXdnfzTL6jFyCyxoVs+jxPS+OVey6U0s8pxYxK52fgONK4XKjTDhGiop7VIGhGY72sC
	iO11/ILHhNF8iAThb
X-Received: by 2002:a05:600c:3146:b0:49e:6ca5:8198 with SMTP id 5b1f17b1804b1-49e7a668f45mr66829135e9.14.1789452587021;
        Mon, 14 Sep 2026 23:09:47 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-2a02-3100-afd5-c801-cc65-9ba1-765b-bff6.310.pool.telefonica.de. [2a02:3100:afd5:c801:cc65:9ba1:765b:bff6])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e7d27c88fsm44282905e9.2.2026.09.14.23.09.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 14 Sep 2026 23:09:45 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lian Wang <lianux.mm@gmail.com>,
	Kunwu Chan <kunwu.chan@gmail.com>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] mm/damon/core: score an unmeasured PSI goal as not achieved for the temporal tuner
Date: Tue, 15 Sep 2026 08:09:36 +0200
Message-Id: <20260915060937.3423-2-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20260915060937.3423-1-kmehltretter@gmail.com>
References: <20260915060937.3423-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 608BD140007
X-Stat-Signature: qu5kezr6hhuh4iy4hnzksrb3puz6e8ny
X-Rspamd-Server: rspam01
X-HE-Tag: 1789452588-626287
X-HE-Meta: U2FsdGVkX182ezqgKh4Jt0CZ8AcQ28ioSRRtZo/BzjhF/FCGifiGVvbQ9zHfDF/gWhjteIC1SrQeffYwAt+olvUz5eB/ZbG4vT8ySxIRIgp/bCfZvaRs+b8cA5vi8LgE1XdtfdviPocU1HHVoVQy3TuR77fQIVZtB3QDl4DPVMw42pY6rhpEgoflCu3/VcY2XCZcIH+BDLMmksGl2CJEbNS6bkKWz6kgeIKkCOah9Nd3mm1+svSEAKZF1RzFAiL+vF6JwHGrJ87OygUZ+Qd3ZWRnekmUxplILx9BWZrgvZhs8YYxaPWFLmYwNOTv9D1PgHLVT6MFNqbVQdu4kb/QGvwSbW/0jK3tXhL3RhV1Q/ExI4g6pi1Tyu8grtzWdG68D+kpHz6GVpdS/5uJmiAgjFXD3JhJr6xi6HnhZHiqneat76ff58DscHt7G5/xfz25R47TRPcBIXFljojO2rgy6ipZldHJTApNKx/guU3+4n204t8gJTm2kQowV111LGZxs1U3Q1dfSxV1L5++RFiOIxip1xcwdx+0aH2MM+Fi0oMc/ri5S4hCrswLAmTJ6ygxQ33P8zRc2S7srLjcLFFsxJ+ntfvNg99N5G4Rk6ZNQGMoYlX+J5vmvT7j8DxjpUk9Hk/WGhMeToIFw3fDf7Rro5Q08jbPN8ZS07fc5t5pMeknkFaCPFawdWZsAq676ynK520nWZbGvNkVyDJvW8vZbgmmDB/BMO/j6ahiJ5UubxYrFU99KesYKEjOI2T0VOM2VJYiyTIfonxKufX6+A35FQV/xhe7le87f5o93K/EvZ/9OHrEXXcAAqAJCt27rG30PV0mA61VjLOkon3FQ6rO+juy+roMuczRvSvXhCLva2c5k2IvWCefWL5kXbH6TGQ6Di8SZ6qhgt2aT0fGaNix4eXQbvgwFlWXJLsL8FfEiDUg6ldbTIf7pf3zo8QoAs/fHaqUQiuwOCsRqAppgJ5
 tvHNJx0/
 zthKMx3pjPZu/OV5zdbTm8QAjlVgsENZtP1iu7RF9QLHJEpsS1N7erSFvH8UvxEViSvYPWWh/bCaWRhlbJxeuv9/4Lz/Kecn5z0JHpoiMyN3KWTdj+3Vd1Gxu+FHoXpPt5pPiMCffQSs0oXypM4KSdScMyoF4+8MGOkFqjk1bW/ngqJwaovJqiHcA1DrQKs/VT0Apv07x34bw7e0PArL5g0rnW+pMEIn/JMl1nH6qvFY8XXcVfj50WJduehswEol0iWMxqA7nrN4gyyvPC3L4LK3K9g3KbUFOTrECeo95q8PeGFAOv/FVYG0Wv178RCY9SwGxldFugxnJ70BXHoEFL2h/XVsjaQtn5qJH8K/X4bAdJFg/LLDtibR7yWwjitYBDtRc7o3pYJbJnB2442rZkeyeoRrTM67yhDKa/4Q8H6khzicRCr+0HpfFHYOmpx+CkzsqDrTEqFqes1PoeYZqj8OT+mJZK/Y4vF+siLKmlKC8myavlOrEEKzz3b1UafZAE/64KiRD6VvEzdQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A newly created or committed PSI quota goal has no previous sample.
Commit a68878f83ae6 ("mm/damon/core: handle uninitialized
damos_quota_goal->last_psi_total") scores the first tuning round as
achieved to preserve the consist tuner's quota, since the feedback
loop returns its input unchanged at that score.

The temporal tuner sets the quota to zero for an achieved goal. This
skips the first charge window and the window after each goal commit.
Committing the PSI goal before every tuning round keeps the scheme
idle indefinitely.

Score an unmeasured PSI goal as not achieved for the temporal tuner,
so a new scheme can run in its first window. Keep the consist tuner's
behaviour unchanged.

Fixes: a68878f83ae6 ("mm/damon/core: handle uninitialized damos_quota_goal->last_psi_total")
Cc: <stable@vger.kernel.org> # 7.1.x
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 mm/damon/core.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 06cf2ab7e97d..e6d87fd3992e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3161,12 +3161,18 @@ static void damos_set_quota_goal_current_value(struct damon_ctx *c,
 		break;
 	case DAMOS_QUOTA_SOME_MEM_PSI_US:
 		now_psi_total = damos_get_some_mem_psi_total();
-		/* uninitialized last_psi_total; make no effect this round */
-		if (goal->last_psi_total == U64_MAX)
-			goal->current_value = goal->target_value;
-		else
+		if (goal->last_psi_total == U64_MAX) {
+			/* uninitialized last_psi_total; make no effect this round */
+			if (s->quota.goal_tuner ==
+					DAMOS_QUOTA_GOAL_TUNER_TEMPORAL)
+				/* an achieved score would zero the temporal quota */
+				goal->current_value = 0;
+			else
+				goal->current_value = goal->target_value;
+		} else {
 			goal->current_value = now_psi_total -
 				goal->last_psi_total;
+		}
 		goal->last_psi_total = now_psi_total;
 		break;
 	case DAMOS_QUOTA_NODE_MEM_USED_BP:
-- 
2.53.0


