Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13635FEEF44
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 13:37:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5A026B0088; Tue,  7 Apr 2026 09:37:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31CB6B0089; Tue,  7 Apr 2026 09:37:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46D16B008A; Tue,  7 Apr 2026 09:37:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B29BE6B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 09:37:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4F7B38C543
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:37:35 +0000 (UTC)
X-FDA: 84631862070.15.C8628A6
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4F7AE140002
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 13:37:24 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=chkKpsB+;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf26.hostedemail.com: domain of wangzhen5@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzhen5@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775569053; a=rsa-sha256;
	cv=none;
	b=ffT2LL34IEDoT6cjuh52BklUv+MEVPPy64i6aDVL4FUYTgPYBRRk2YGsFVZqHRAKrSQu2T
	IfOZRAOEsBo3tDoOBB8/phSTPHIT4hu00Aj73imQsiWqaK5bxiwqrn/JRz296m/3RA+Ew3
	ylMiv7RbDW8FIi5NtLC4zTDJ8Yn/+HQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=chkKpsB+;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf26.hostedemail.com: domain of wangzhen5@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=wangzhen5@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775569053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=daoAa5k1kSxW3Z4c9BEZEd4leck4VaWEW7nNrwN5c/w=;
	b=6lK1/PHEJaedAyUPI4L+8/taahsZLyPEm4UPqvM6gDxfr8CZzPkx9hOkVl3a+mSuyMIAXY
	FIzAdfMgPXTs+lEeFVMlCjjlwWXXriLnlYmWioI9qyA//kr/Zkz1oM+XMZZKjhtpsLMCpJ
	DYv4H8lB7M8qyg1SS8YkHePiyETzdtw=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=daoAa5k1kSxW3Z4c9BEZEd4leck4VaWEW7nNrwN5c/w=;
	b=chkKpsB+5OtryPLyYG28VQGyj5u45lqpODL4ijE+o37CXCQ8MMvEIKTHMd4bu7y7VSjJ5LZdz
	OGpSlLgfoauDnIFwlsU9LCOEArzVaQnForQzc8j/QQsIdK6vcUZp9hwZPweqsFvZhh+My3BBYsE
	tdIZ7hHjeBEd6nBRffZzugY=
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4fqnK86dMBzYmvjb;
	Tue,  7 Apr 2026 21:36:12 +0800 (CST)
Received: from TA011.hihonor.com (10.77.232.85) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.27; Tue, 7 Apr
 2026 21:37:09 +0800
Received: from TA011.hihonor.com (10.77.232.85) by TA011.hihonor.com
 (10.77.232.85) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17; Tue, 7 Apr
 2026 21:37:09 +0800
Received: from TA011.hihonor.com ([fe80::1391:8a1:1ddc:4344]) by
 TA011.hihonor.com ([fe80::1391:8a1:1ddc:4344%8]) with mapi id 15.02.2562.017;
 Tue, 7 Apr 2026 21:37:09 +0800
From: wangzhen <wangzhen5@honor.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand
	<david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng
	<zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, "Lorenzo
 Stoakes" <ljs@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu
 Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, "kasong@tencent.com"
	<kasong@tencent.com>, "baolin.wang@linux.alibaba.com"
	<baolin.wang@linux.alibaba.com>, "baohua@kernel.org" <baohua@kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>
Subject: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness = 0
 or 201
Thread-Topic: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness
 = 0 or 201
Thread-Index: AdzGkkmRmH7PUgfKQEOsIlMMxaeSQwAASDjw
Date: Tue, 7 Apr 2026 13:37:08 +0000
Message-ID: <4451bdc432864aebb54f401eee51ea53@honor.com>
References: <7829b070df1b405dbc97dd6a028d8c8a@honor.com>
In-Reply-To: <7829b070df1b405dbc97dd6a028d8c8a@honor.com>
Accept-Language: en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.163.18.244]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Stat-Signature: o1awftuzqmeykbg5s1fs3ijhppn9w79e
X-Rspamd-Queue-Id: 4F7AE140002
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775569044-519202
X-HE-Meta: U2FsdGVkX18IHjGwGuOAxURQA309B0BQm9XMC5dqQol8X7GkuTmi2RWKJR3gOmmQzGZk6CRbPueKKBSa8rxe16+MNhNwo6ix3Y3yEMzqqqq16RTD9qcu7AW1B7UCtq73/+tkYzEZLB18UGhB5nqTXMi6k4tpfK6103x9Tm/r1oft1nK3+9PmXtVKiwQ+RvfxrjxQXMuOmmRWk2x+osapYfBGk+prQzrnbaqjiH+3pKf6oe/einaVc3cigU7T7LfHSo4+CXRytnu3D5+5z1RH6tYCK7PYMddOfqbiyKmhNpBgwG9qleom6O1IIA+hyZDLCAh6EblAA9v018XK2dbM7oorsMTqDQeXVCRA5u8Hr6OuRto1lU4eEP/FBsn5sMXYEJwJ2pig89hoUaB4RRn7t5Pt6jeuu5xbX0wuy/yOdHXlAZkrqVjm/bUrdJHMIuK0/j+cgiu4+czQogzSjSw5OH28CvOb7ioTvYZLcpqfvB0NQ+plFEiHiIjcVLJxVhxV3MaxJalKs2GLijh4HTJg/sEFxRmGO8lfuMmZwAR5JWw8I63LAq45grinoyhaVTzlMzHbKxavjD7xVGbH2SQ7f6Zif3HxTKsg4v6BHnUxLGjouxZ5VhCA5W3rH7mjjij26qvcbozRq0D1BuUCA1KRy/YgNGVQL7Om/p2+jk4wt5rCZRrcmkO6h1uJBUkOXbxgIGqPxFXj5MU0DzQEntyPdDPH8iuhB8LpTArIXTbqLi/KCG/j/9wK+uagPoLTjahJY/j0LEsGLO6RB3MctCZrJoWHIeTCv9gXU0OX8sRGe0JiyliqvDSpW222j8AJdTQOnSFsvEeBg6aWupyXxbjllvRMzMPyJ29C9hsc8Zcu/kXuz/UdK9m8RF2n82LshBh5L3Mdw4pcFZmccvwb+mGiaXXC57/ArdB9Corp9F8aeDLoHEMw5Ayq39A7YRN26cD9uoNwKS4TOMEgWiS4mHy
 Wxepb2kP
 NN0lfSWEOHTF4CuJ4gmaFVvLT0wXs07SEEONKA7b8SAw2VPvQJaVBzDtkyOpRxCEjDrm+IDqb1E5z/hI9nShRUrn+c2A1jmCxqVQ9VizanGXXANxM5b2FiBFkz9FQqdsOPNPdeWAR/ekz+k43aJV3ObGjLGEis5fzX+DlBqOS43vq7m0ZnnXvGgCYTEZeM5BkyrVV0zkiuvTiale2WeryRl/M7CC/WlKaSfibXRNWTzy2R+l4euTQKAUMmknChPzfqhEXEC1QJqV3qW8shv7469VH/UOFCDjmADmqdDPKBZcgrOH09bg2Wt5vG+aDb4KJCn08wJRItH9H2BoFpO1ZrOTTpnetmPxATPXQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From ac731b061f152cba05b9aa351652a04f933986e0 Mon Sep 17 00:00:00 2001
From: w00021541 <wangzhen5@hihonor.com>
Date: Tue, 7 Apr 2026 16:17:53 +0800
Subject: [PATCH RFC] mm/vmscan:Fix the hot/cold inversion when swappiness =
=3D 0  or 201

In some cases, when swappiness is set to 0 or 201, the oldest generation pa=
ges will be changed to the newest generation incorrectly.

Consider the following aging scenario:
MAX_NR_GENS=3D4, MIN_NR_GENS=3D2, swappiness=3D201, 3 anon gens, 4 file gen=
s.
1. When swappiness =3D 201, should_run_aging will only check anon type.
should_run_aging return true.
2. In inc_max_seq, if the anon and file type have MAX_NR_GENS, inc_min_seq =
will move the oldest generation pages to the second oldest to prepare for i=
ncreasing max_seq.
Here, the file type will enter inc_min_seq.
3. In inc_min_seq, first goto is true, the pages migration was skipped, res=
ulting in the inversion of cold/hot pages.

In fact, when MAX_NR_GENS=3D4 and MIN_NR_GENS=3D2, the for loop after the g=
oto is unreachable.

Consider the code in inc_max_seq:
if (get_nr_gens(lruvec, type) ! =3D MAX_NR_GENS)
    continue;
This means that only get_nr_gens=3D=3D4 can enter the inc_min_seq.

Discuss the swappiness in three different scenarios:
1<=3Dswappiness<=3D200:
If should_run_aging returns true, both anon and file types must satisfy get=
_nr_gens<=3D3, indicating that no type satisfies get_nr_gens=3D=3DMAX_NR_GE=
NS.
Therefore, both cannot enter inc_min_seq.

swappiness=3D201:
If should_run_aging returns true, the anon type must satisfy get_nr_gens<=
=3D3. Only file type can satisfy get_nr_gens=3D=3DMAX_NR_GENS.
After entering inc_min_seq, type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY=
) is true, the for loop will be skipped.

swappiness=3D0:
Same as swappiness=3D201

so the two goto statements should be removed. This ensures that when swappi=
ness=3D0 or 201, the oldest generation pages are correctly promoted to the =
second oldest generation.
(When 1<=3D swappiness<=3D200, only both anon and file types get_nr_gens<=
=3D3 will age, preventing the inversion of hot/cold pages).

Signed-off-by: w00021541 <wangzhen5@hihonor.com>
---
 mm/vmscan.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 0fc9373e8251..54c835b07d3e 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -3843,7 +3843,7 @@ static void clear_mm_walk(void)
 		kfree(walk);
 }
=20
-static bool inc_min_seq(struct lruvec *lruvec, int type, int swappiness)
+static bool inc_min_seq(struct lruvec *lruvec, int type)
 {
 	int zone;
 	int remaining =3D MAX_LRU_BATCH;
@@ -3851,14 +3851,6 @@ static bool inc_min_seq(struct lruvec *lruvec, int t=
ype, int swappiness)
 	int hist =3D lru_hist_from_seq(lrugen->min_seq[type]);
 	int new_gen, old_gen =3D lru_gen_from_seq(lrugen->min_seq[type]);
=20
-	/* For file type, skip the check if swappiness is anon only */
-	if (type && (swappiness =3D=3D SWAPPINESS_ANON_ONLY))
-		goto done;
-
-	/* For anon type, skip the check if swappiness is zero (file only) */
-	if (!type && !swappiness)
-		goto done;
-
 	/* prevent cold/hot inversion if the type is evictable */
 	for (zone =3D 0; zone < MAX_NR_ZONES; zone++) {
 		struct list_head *head =3D &lrugen->folios[old_gen][type][zone];
@@ -3889,7 +3881,7 @@ static bool inc_min_seq(struct lruvec *lruvec, int ty=
pe, int swappiness)
 				return false;
 		}
 	}
-done:
+
 	reset_ctrl_pos(lruvec, type, true);
 	WRITE_ONCE(lrugen->min_seq[type], lrugen->min_seq[type] + 1);
=20
@@ -3975,7 +3967,7 @@ static bool inc_max_seq(struct lruvec *lruvec, unsign=
ed long seq, int swappiness
 		if (get_nr_gens(lruvec, type) !=3D MAX_NR_GENS)
 			continue;
=20
-		if (inc_min_seq(lruvec, type, swappiness))
+		if (inc_min_seq(lruvec, type))
 			continue;
=20
 		spin_unlock_irq(&lruvec->lru_lock);
--
2.17.1


