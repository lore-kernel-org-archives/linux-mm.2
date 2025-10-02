Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31B7ACAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 20:46:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BAEA78E0007; Thu,  2 Oct 2025 16:46:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE8F28E0001; Thu,  2 Oct 2025 16:46:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98A208E0007; Thu,  2 Oct 2025 16:46:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DFC58E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 16:46:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DE66A11AA80
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:46:43 +0000 (UTC)
X-FDA: 83954357886.11.7625638
Received: from mail-yw1-f179.google.com (mail-yw1-f179.google.com [209.85.128.179])
	by imf29.hostedemail.com (Postfix) with ESMTP id 1299F12000E
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 20:46:41 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YVA3z1sP;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759438002;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mtg5K7mFEUovxKHIKqKvsg9K7Q6jEbo/PlbyX0ggh/g=;
	b=tV5xlnyOU5P6Qq8NLelFJDQBOOZFCH2GirajabYwGRiBG82diYyPojM658o5kHhSFmZXMt
	cyOJhIJoF8qCE9AEigJZsJJ/TmukbFqq+Hog5wiBB4DqZMif73kuNaTKq0XFeS6+ZKc0MF
	sr+KKuf0hHVBhCTPWbtormiZnXoEpJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759438002; a=rsa-sha256;
	cv=none;
	b=UbzU23T0T2mrsr/QQ1YK7fPXDdyw8rVpe8by8mo/XREZpIVZN3UnCfrwK2p4tgb5bZg4fv
	YtwndgxP+IXMlcaY+9KSOkGCcLTR60lnGYICdmA01qiK35gcPWKMy6sbJXt9nwDHYlVnWm
	IBVoKBJ05dcHtNOUdFeQmzr8NDgikzs=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YVA3z1sP;
	spf=pass (imf29.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.128.179 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yw1-f179.google.com with SMTP id 00721157ae682-71d71bcac45so16953587b3.0
        for <linux-mm@kvack.org>; Thu, 02 Oct 2025 13:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759438001; x=1760042801; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Mtg5K7mFEUovxKHIKqKvsg9K7Q6jEbo/PlbyX0ggh/g=;
        b=YVA3z1sPMzmGYmBhqtAKRHPuWbkKa71yMZPi1LAhObt0bZWrAxyceOUJ+B4sOk29Oa
         /Ec7yR1uwtw4O4b8MAxezqEknEwAmjPEDTJILpRiRDUYjYPTJtHo6eE5xlu50aQVnxVR
         tkVWGTlg9hHpMLZ/VfeesklMSBTDsGQRF7KdU3e/6gKir+G/GAlE7a2/ZLZqj2V2aqBu
         DQH8U6gdwQTYi1AFVlR+QWR/5af5cBsq7ZUAn4/ztekYw2FCXYzk40dvtCGNA5KIEOV9
         RB1u+5s6moNpSTtmUisArOO+1YqdZ4HjIRu6T7EZgv2/kQygWGaX6CpOjeO4eIiQ4vGG
         IojQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759438001; x=1760042801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Mtg5K7mFEUovxKHIKqKvsg9K7Q6jEbo/PlbyX0ggh/g=;
        b=V8fmgwA64NA4fq7XPfg37m6XRDBk/6RGfV6x/8RDDt9zbVfdbrNeKLkw2UndlKBZUU
         PVVJTlXKHY52I23uTKTfsgX4ZJTB4j/2u7CUQtAzTHUtw8RDpPE5PQ4tLBN2TSz8ZoQJ
         DLU7eIVzdW4dKMWsm3eELkJPIVPQJANyBVCVU9IYhxy7QJXO5511qvIn53jpHH1tCch6
         CPTjjMydjm6YcOH84r/iM1aHZrh5hyz1bbYzoeVgYPkdsM8XkBWjU9YhLCFNmAYqKJpC
         1oKhJ4tcqBh8NnVhVecZWuOpV7bTGay2JkfhIK82eufMjlMwQcV0KAoT4FLtvIVGDx5S
         jvlA==
X-Forwarded-Encrypted: i=1; AJvYcCWdyy3ZLp0UZaf+YlAkFEmQxPEQuwYcJtcP03pRhtA2+JIt/ORui+jJm59+YI/MuelDEJn1ulQFGA==@kvack.org
X-Gm-Message-State: AOJu0YxRKHMZmb7ik5SeO3G+6d21ltQ1xZnUgmOWOnMPRJQHd71soERb
	6Km184WwuD3yNjBmVgDCkYGtd4T+X7FfUxGxqkNxhIT4gEOAUqqlgG2y
X-Gm-Gg: ASbGncvFZItG5gWOo5midRz5NXjd/w38oFYpQzFtrLaLfo4q1ZXUAwv5t6zpqW3WlVp
	xo+Jyu2fDMp6W/IafsC8y6Rq/Qm8nPZKmU05kwKbeIJyLb/uiA0kuo5MmsWDuGRAvFkRcN0Gk9C
	2+wyVCXPtIdxtZ8MC0tZtR3S9SZWQfNL6nRqntELJN6dJ+FhVsiuOs56thsAyEyXtsPZrJFlITo
	92ObiQMgvJ0n4MtMr2nyay+pkMHMZTrPhV5pm/gzORWe0oAjS1tyftDB+rso+OdxzNWzMNV/CZj
	m5Xgf5VdvyfC2Ee8PHCS28emc2NblNCZdpSshAgZ20aj6VpGUAA7eYoe+w7DUqHZ3O02QkZHVeS
	gp3yZhqk3QlYRIlccCJHwIe3oYEKq9NuMAtFTvt6Ry5BqNdmstEOIDLM4XenRIEm7SbwekHjhkE
	q+Ij/iq23TXqUCL2LhwAtIkPvI
X-Google-Smtp-Source: AGHT+IH1dK4l8EVgnO4Il3oHYv3U0XOv5jcIZNNZM8+Kj7vgvveFLxrmq74ZKJzTaehh0HFqLOPNkQ==
X-Received: by 2002:a05:690c:6085:b0:772:2b5e:1f10 with SMTP id 00721157ae682-77f9456fdf6mr14998337b3.1.1759438001032;
        Thu, 02 Oct 2025 13:46:41 -0700 (PDT)
Received: from localhost ([2a03:2880:25ff:74::])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-77f81e63e8bsm11224447b3.67.2025.10.02.13.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Oct 2025 13:46:40 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chris Mason <clm@fb.com>,
	Kiryl Shutsemau <kirill@shutemov.name>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH v3 2/3] mm/page_alloc: Batch page freeing in decay_pcp_high
Date: Thu,  2 Oct 2025 13:46:32 -0700
Message-ID: <20251002204636.4016712-3-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
References: <20251002204636.4016712-1-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1299F12000E
X-Stat-Signature: u1rrzcndpb7qk3fads3cnwybfwhfbti3
X-Rspam-User: 
X-HE-Tag: 1759438001-543362
X-HE-Meta: U2FsdGVkX19rVaxFRoTNwxCydisLNmnmA8M4+k+t7jkRmK3WKnWbnHIc+3aUpD5GLZ51smFyWUdKe5goHSVhojTTmj+THl5/rwqRutgf24K+g2itDLU3rd11KWdM60YktDcCGvf6FMgl7MrevZYbuLrauklV0IhSiKB0RrQkrN1cLAe+azTJ7f3qhuO06my4+Zd5e8pokNmWxwugj8/xyKSloKGGHpMa4Hp+fLQ6mPcQtPrG2U2c3+emK4uedpG2UzFMQCskDlogLV376/CipaUM9qZIsp3pOkpDnDCAHPpCp3r+qRj3A6u18EfpDBLqTZA0Zp7WTYfdi4pamnADn6X4swkclVlNM2Vi1Z00l3UeFHxliFGKnqjfmmb9/POiHVQ4aCHikVMYLsyFYJy+aZCwzMSLWsiPn0V90wIbWkPFfJ6JFnxo55BgGIE/7BTbir0y6AsM0QdwSwlaXHn6oIGkQUwpFzhuSumqsn0k/BnAFzuyKH0Fo5VwIE33tp0he24QHhb0ddPZNjZCHAPrE1QQFyIuR3YTUYbie2fWHIecIxKZ1XCTEpZxUTrPt52tYdxgxWfzjPDfHI/WeMhhdn5E5NznK+DSiwUldWsSFP3majfN7fFJOyFAISvnIQgmqI+wDvAU2udjMiLUV39ivT4/Szib/4BlVdgPyW3lxJ73Rap3rPVNtvU5tX/W1HorV7DI63WpM2Ge4HmVRETgaOLY9KcX4q95QcDKZDqSDRCc1FFRPZf21ACbQv0czpPoTGy4xmdaWhG6/tvsetMYS6klSK32c120NIwXWcI0TO3IjRD1jIa8/HuebuJYnT/mitN56CXSYg5ldQtiuisFUbw6pmDiQFj7BaN4A1DYSG5dqKzltMxAiWAPOlnHQTvuijIF0Ruf1fetoBSmyImde8NelSqJXs/Y97UCu5mJG8GV6lgmpqfJSNafGXfguSR7OnCAt8O+sTh/ECW9w2U
 C3Xntm6O
 75JR0TM0B1tDTOISOZMok9mFEEQL3iuqdEuyMMQ8CcgpDkJ7YaMcI8HuD+ERSIb2jm1MF0X+O0SEcPWR6Q126u/dtumx0kjyPiJQyadONDJObVEBMTM4AMSU3a1wNag/GXtI988lNbGePySqs/w9nIoWgoF6JBJXYSEflBKhG2wuVygTvZVEB4Hi22BjJ2dSgYkip/GaT4uk18fVe5XVned0Gxoay6qOEwmYzuejebXFkSXVlD43Zdfhk/U3mmVTsuB/3uyQlU8FfVjP2CdW7WUzb0m9YB0rSz4xYxZ05HYgAX7MR5dh30tVOGOUkLCctA4FX5ZjUI/s8oEsgNgVbB1Gzd3Bk2TUTm9e7Boj9zJI0DfrH20l3K+o/NLoDl1hHSuFtGxq10ghxojzXuYtbZumD5fxQ3qUob2DPZhA2HmPa74sldTKNi03FqzEF/kiOgqAb4XswjR+gydNEn5rk0T7EdqSL8lbgk4QqbQ99eqtUCYD/tcGDUTdy7/oaOo4z7aIK2Gk8anhiLakruHTq67tu4dXrNEqigqAVT9gg4M45BoO/KZv1KCJGYimbQpgFG9w0gQ93+WpbB5lE8Fr7gng3XSo/zs1cuHs+nYNHQ7d0qBbmzzslGF6AvQlTV3qGMck2XrdymDqgWjnnpvyPvgvTfY/cuQaODY7zgS3uGabTeEiDC+JCqaLkoQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

It is possible for pcp->count - pcp->high to exceed pcp->batch by a lot.
When this happens, we should perform batching to ensure that
free_pcppages_bulk isn't called with too many pages to free at once and
starve out other threads that need the pcp lock.

Since we are still only freeing the difference between the initial
pcp->count and pcp->high values, there should be no change to how many
pages are freed.

Suggested-by: Chris Mason <clm@fb.com>
Suggested-by: Andrew Morton <akpm@linux-foundation.org>
Co-developed-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
---
 mm/page_alloc.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index b9fc357d2d48..f525f197c5fd 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2559,7 +2559,7 @@ static int rmqueue_bulk(struct zone *zone, unsigned int order,
  */
 bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 {
-	int high_min, to_drain, batch;
+	int high_min, to_drain, to_drain_batched, batch;
 	bool todo = false;
 
 	high_min = READ_ONCE(pcp->high_min);
@@ -2577,11 +2577,14 @@ bool decay_pcp_high(struct zone *zone, struct per_cpu_pages *pcp)
 	}
 
 	to_drain = pcp->count - pcp->high;
-	if (to_drain > 0) {
+	while (to_drain > 0) {
+		to_drain_batched = min(to_drain, batch);
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		free_pcppages_bulk(zone, to_drain_batched, pcp, 0);
 		spin_unlock(&pcp->lock);
 		todo = true;
+
+		to_drain -= to_drain_batched;
 	}
 
 	return todo;
-- 
2.47.3

