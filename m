Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBF25C624D3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 16:52:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F24476B0088; Tue,  1 Sep 2026 12:52:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED54E6B008A; Tue,  1 Sep 2026 12:52:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9C966B008C; Tue,  1 Sep 2026 12:52:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A82426B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 12:52:14 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 252BFC0425
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:52:14 +0000 (UTC)
X-FDA: 85165786188.04.0ABB379
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7617E20007
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:52:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXawFtKp;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788281532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Xlhjv74JKDRq/CdVQy+k9ZQqiUsDAvlRmVP2/IgXB6s=;
	b=uegZVIiqPu5qd6Q2DLVj74kuuPQqxayMTPg74BXANIKIVV/Rk/zJEPgZeUKrjdD5fhmA6m
	kZdjuJn6KbaJtPgHY0ydcTmDUJ1UFCCAhyP2eHAboACUljiaoGfeO2xfZNuaBzcQNsXwPB
	r3MfXqyBSC2JE1TypilsvzlVsWNSA0o=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788281532;
	b=BxztjxSxoBGH7eyM6lRzJpgqqJiM47VZZoQAuUsR6zkQDSsXEBICoyZlwnbQkYypduvOJd
	a/iGeMIAGgi/fWc+iCktB+XEjxTsUQkZ274+/lkupI+DTA4RfqI5snxNiu/iHwp7plvpV3
	2IOJAZWUr7fYH1Cpj+FUxo57blL/VHE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sXawFtKp;
	spf=pass (imf03.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-39647184c73so1318821a91.1
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 09:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788281531; x=1788886331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Xlhjv74JKDRq/CdVQy+k9ZQqiUsDAvlRmVP2/IgXB6s=;
        b=sXawFtKp58URXgWvtN9Ev+fGi2aK68R5l6OqBlGl2zK0e3+0lTRPy9gXCXD4bWXJB4
         csD/XN/GfKF/DLtY/s8RWD+zzhsn90DxEXGBoZijYQVHowB6QOX3j9sbEryjmoBrtYHh
         bJFfdpK3T3q1X4+Z7DNHzyxruRnsJ9Nf/61p+BBQk/2HU2dwszXiuvuqBAkxZWabDLz5
         W31m8gqs1dBAwS9dkbL2p0GRZwC+lnQZv0J/ogu+t5sDj6Ne0Cwgc6yG7+sJBqruLsFL
         /WHoQIm0Dp2hWeiC9vRH01VeBn6CQoc34Cd7L7vT1Jbc7B/tnu93UnSoKF1Jo0yThaVY
         WxZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788281531; x=1788886331;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Xlhjv74JKDRq/CdVQy+k9ZQqiUsDAvlRmVP2/IgXB6s=;
        b=F01S2h8IUA6nOkJ05N51b1lzQ6K5CiVFu1dQnTfTqhjQQskFrf3cQuDCH4A58mzT3W
         RAIvt9kbWxSy7sTpRaY7O3bd+ADlvC0Q87gtFNp2shnt8AC8yJMTzpTNLTksE2mGcoCZ
         LoYlneS/x1kPW905BUm/M6wLQ1thfPhW0KmAi21qeCb432KjnP0Q6AFDliDK2nx4kUJj
         b7XGiwOUgmIAt+S/dMVaRo6IrBAvqsWYWvnhBJPvkXPxrGfPRO35vvtbT3iWm5IvcSvS
         qCLnxCRzLrXbolsS7OeZOUaykZoRS9JA0AzvHbFVOsk5T54Aev2mOfEU3ht2QKdOIMaV
         bjLQ==
X-Gm-Message-State: AFuF++ne5Nhg/xwjYFaWtTMKr4TstUUc49uj99UZulbout1JiGZhkqMR
	OQ9QxjeequqAYz8BgoSUcRTsScern8Elbdf2BNy6O8LLaaCyk5sJhyk1
X-Gm-Gg: AYBFou13KN0ghgLJ3kQKCaqmCg9uP/wz49xmEc+vf36yUnMJP5nJb83aOAWDq3lR65f
	97YrJJvjk4drp2mG0f6mXGYi08FKjkkPB18ftcK+ajvvxFO/JZfwYTqDVL8VeqweLHxhVK2ZGQV
	uPdoKT9clBEI5z+Lx82ZibfUJwiy44QxLu4I1ZrISnkdoDevSg/WybHtwctQj+Ao8hhYTddWyR5
	wgJ2y/irLo2H/S4//xgDmKEhLvBX14jdewtDq7vfFcEg3hJIC3kiDwzn8UveTSd7TVWz7XtxrvA
	gTNqkuJLRezT4/wCQZJTPmspWm0JwctUimSFBeiKy7f3GvR8BNX7ScUwDSDfYawqNKCxT1YNcGn
	mWFpqFTMYDAmU0z825DWXCCJi9pPyhrwXgLJDIEhqEBZ3rWoDYgp1iXN39ovqctmP0NSHDNE4Mu
	cf/jkRhYPNnpgxiqEPbvyEtVbAgle60A7iL0bxAfZHVEC+3CjdUmU5f68=
X-Received: by 2002:a17:90b:164c:b0:398:baa7:4c2f with SMTP id 98e67ed59e1d1-3990f79ddfcmr4165008a91.5.1788281531057;
        Tue, 01 Sep 2026 09:52:11 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39ae0dfe6b6sm524219a91.1.2026.09.01.09.52.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Sep 2026 09:52:10 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org
Subject: [PATCH v2] mm/mm_init: remove zone_absent_pages_in_node()
Date: Wed,  2 Sep 2026 01:51:49 +0900
Message-ID: <20260901165205.1025640-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7617E20007
X-Stat-Signature: ijb89y31yjindjz8nu5iczihry6wsbdy
X-HE-Tag: 1788281532-753782
X-HE-Meta: U2FsdGVkX18mYhZSShhBwOFfU0Vp0ag2e8BQoL49Wdtzody2uEzpQBQvkXw1lfnzFLdHhBjL8ymxw3vxOMKs8H0fVwzep4T6Idt6MbWCY4zhUik0W9rto6MeSCK7apJilVyh9li4oDGNpferLrtTVJhqm2cshxe+MdIekc+p3pDTSZ7umIBK4UlvUkgcsBNvb29A6JJpkwvabsnA3ADJ7mKjTJbcBqBo7Jk9C/mBGjqGZbAKY1xmjYbRYDIokCCgHbDq43aDi6xT5Z3LucMjI516ZMVSIHVflbDpriK3o6azYEYLBHDw58q2blQSBJQnifbK+Km0s2NqNDi/ceKdn/cS/qSx5uxI7qEev3vLVCIvWkKNyc3SmClO2vZ9Ev3FmJN/doZRHtMXML42t3dPYGjwE3Mh6M9ykGovmJqnnEjCoWdYCQ2v4wyOwhu65zH8eQOJuZO734ini2QIpkZamaYGS7CbImMh9CeGaBCVbb/9ekcdr7NK6pDs2RmDslbEQekFxcvVYSC90gmC5T4P62BxcJUL3y1us2oPdkyIhje1DNNo0FQi2QJbmwGSRwV4thTnEpmmO9UAVps2dZ6MwwUk0psugr5REdtOiz5PxHOIYpM15kLKWl0vVc/mTMv1TRg2K+1TZ7LAS32s7cuuyWJWUS8kxv2AM0/dWsrp5XrXagFZKrViEzy3vNHgch/49YUKA6l9is/+0SGPi1Jf2kBa1qTO3owYnRrEHryr2ofhM9VCP/GlSDbtBIX6GdGu5k53X37s3BhgZLvHFl06RSKy0AxW9H1Fd8zYMIhJMvolX89BCKSXtY3IkjzyibjCD/Db08WVXve+wa7C8y4pdCAay+ov0vSQ2vr3qTfYWIRAOTbNZolnjLT0MPZVZzCvocwri7DZLIRAlrZDmYmqJ0BysZqPwR3RVzujLhQPew+o/GQI697daGFYwv8zQX1YyFPY8wK7CDesNTSJcLy
 lZL62Dk2
 /uYrijxQuEp2DaLol6e/vkIulTAEBwve/DRGWLzXtCotgOBxCUlhVw9LcyxFb7lIB6dQwmVtpiQVDfqL5IYAq9bm1zKQz1KFwwdBM/4Ro+KXYlxPygIm0KpCRcoqOkqHwzvTNMQ2gw2BupuytlpL09GGxa8QGkHt8Lf3TzpQ3dTqT2YAEFgsE2Tylgn10GsyyA5v6WhM1d9Cqe5i9EKLJ93w7M3OldnvjrKgDiwJsE1qOyOEj2SpAfWslXDrUjHURASHWAcFF00tUUqLl4REU8dLUuU7CoIy61AypJzDC/bXG+o4Zzx+1yNdjaaq9zKFIObmy5MO1KL20O5CpdgBKZ+txrawUIttGHfvumb9mJnX6vdJC4JOytNxaStQpALjAnrGUxrPxD43SknEicvr5xQW5AQctEZ3JgTtggiKOvBeCLPq+WWbYODOBNBw+OnzKdt2f8l8lH4nr0MPRrOIK6hhi1pK1YJuMEGPlNIn+PKJiyp8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

zone_absent_pages_in_node() returns 0 when the zone is empty and
otherwise calls __absent_pages_in_range(), which already returns 0 for
an empty range.

So add an early return to __absent_pages_in_range() to avoid looping over
the memory ranges, then remove zone_absent_pages_in_node() and call
__absent_pages_in_range() directly.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
Changes from v1 [1]
- Add an early return to __absent_pages_in_range()

[1] https://lore.kernel.org/all/20260827144151.486192-1-ekffu200098@gmail.com/
---
 mm/mm_init.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/mm/mm_init.c b/mm/mm_init.c
index 1533aebafb68..c00ac947a7d6 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -1166,6 +1166,10 @@ static unsigned long __init __absent_pages_in_range(int nid,
 	unsigned long start_pfn, end_pfn;
 	int i;
 
+	/* range is empty, nothing to do */
+	if (!nr_absent)
+		return 0;
+
 	for_each_mem_pfn_range(i, nid, &start_pfn, &end_pfn, NULL) {
 		start_pfn = clamp(start_pfn, range_start_pfn, range_end_pfn);
 		end_pfn = clamp(end_pfn, range_start_pfn, range_end_pfn);
@@ -1187,22 +1191,9 @@ unsigned long __init absent_pages_in_range(unsigned long start_pfn,
 	return __absent_pages_in_range(MAX_NUMNODES, start_pfn, end_pfn);
 }
 
-/* Return the number of page frames in holes in a zone on a node */
-static unsigned long __init zone_absent_pages_in_node(int nid,
-					unsigned long zone_type,
-					unsigned long zone_start_pfn,
-					unsigned long zone_end_pfn)
-{
-	/* zone is empty, we don't have any absent pages */
-	if (zone_start_pfn == zone_end_pfn)
-		return 0;
-
-	return __absent_pages_in_range(nid, zone_start_pfn, zone_end_pfn);
-}
-
 /*
  * Return the number of pages a zone spans in a node, including holes
- * present_pages = zone_spanned_pages_in_node() - zone_absent_pages_in_node()
+ * present_pages = zone_spanned_pages_in_node() - __absent_pages_in_range()
  */
 static unsigned long __init zone_spanned_pages_in_node(int nid,
 					unsigned long zone_type,
@@ -1292,9 +1283,8 @@ static void __init calculate_node_totalpages(struct pglist_data *pgdat,
 						     node_end_pfn,
 						     &zone_start_pfn,
 						     &zone_end_pfn);
-		absent = zone_absent_pages_in_node(pgdat->node_id, i,
-						   zone_start_pfn,
-						   zone_end_pfn);
+		absent = __absent_pages_in_range(pgdat->node_id, zone_start_pfn,
+						 zone_end_pfn);
 
 		real_size = spanned - absent;
 
-- 
2.43.0


