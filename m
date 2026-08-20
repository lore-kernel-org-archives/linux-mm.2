Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D042C5DF88
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 02:48:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F09426B0092; Wed, 19 Aug 2026 22:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6B3A6B0095; Wed, 19 Aug 2026 22:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5A4E6B0098; Wed, 19 Aug 2026 22:48:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE2F26B0092
	for <linux-mm@kvack.org>; Wed, 19 Aug 2026 22:48:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 332941C1A85
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:48:48 +0000 (UTC)
X-FDA: 85120115136.14.63758AB
Received: from mta0.migadu.com (out-239.mta0.migadu.com [91.218.175.239])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4FA84140008
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 02:48:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cyc+7oN1;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787194126;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qZhgMMAx9AT70H0W1kmDjsQfIKT7wc1OtXlOqMfwxLg=;
	b=zf0k5urUZALRdsQiKjaQRImqlXz7oiHnGcHlJZ6LDZsKSuPx3b+4bA0VwbbXsCdE40ktQh
	d2A31c6mp+Zw202YRQwrbWt36bL+nbEA60q2/20+WwHcAtcfZzhzvnhXr/SNdEs15axF+W
	WoL0PCwpgOWJLwTv12i4KiY93SqEla0=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cyc+7oN1;
	spf=pass (imf23.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.239 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787194126;
	b=0n+/P4RTJE8GCqqOmSiToTmmOm/C+6dB2ihWEygqU8hS8kvA6jm/pcauLuLUD+4PeaTXH/
	kXdPNgcCgC1tMo8B6h5SU2EzraQxZQ8MXyPzvYIKiriuwbxIt9V7roTf37kxzYvChuMmuw
	+vE708J+2V7b/g0yARwnZIW4vlbGr3o=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=kaupwl2CerM+wcHSCXXaFwLigAE3E8c74QApBbEU49A=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787194125; v=1; x=1787798925;
 b=cyc+7oN1V/RyuWDA6yX7TGuwVuvkxIFDEfyO7oCFLaGM4PuJMPPljaqSl4pbWWZ2IS0Ky3hs
 lAtgufRUd72tFIbQ7z5dK/+4zdeXEh2pbzdgMnke4qYR+AfYF2OhR62ueGHqAl80eJfUxAKahuT
 U0ExjSOp+DQ59ulJL1ftdoHM=
X-Envelope-To: linux-mm@kvack.org
Received: from teawater-KVM-Virtual-Machine (39.156.73.13)
	by smtp.migadu.com with ESMTPS id f4ede75f08bc8454;
	Thu, 20 Aug 2026 02:48:45 +0000
X-Mizu-Trace-ID: f4ede75f08bc8454
X-Migadu-Flow: FLOW_OUT
From: "Hui Zhu" <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH mm-unstable v4 1/2] mm/vmscan: fix missing NR_ISOLATED counter update in MGLRU reclaim path
Date: Thu, 20 Aug 2026 10:48:14 +0800
Message-ID: <8b1669146ea1d37190a19c0938d6514cbe1cc88a.1787193916.git.zhuhui@kylinos.cn>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1787193916.git.zhuhui@kylinos.cn>
References: <cover.1787193916.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: untrh9o536e9idrtwsbqd5xcyqt6pu99
X-Rspamd-Queue-Id: 4FA84140008
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1787194126-909336
X-HE-Meta: U2FsdGVkX1+Dbo9H5+skWdZ8vEDSdoLddHBP8lv3iePFojntvMwrWYYYDz25V1bCyyaTf4zfuB/bZHhqifWlU7oZTPAOUew34CEffkdNfmW0OdjAHxQQEJ6XdG2oTpRIjy4iqjNdqN6iTK5iFIxdQt1h157hZMa4qZRKTpDkOnXI9LwxEEUwM2nNrDHoclwaIJaKCLwR4y6IJRBWeDT/Ytt1C1Dfw2/kwQ4UiG5J3rGddSxBL+ZsdaS63Q55o2KXKhcTKVDngLWKZ5hIkoO2/a82v6AzHrwEGwlWwqB3MKFYgXK4XUGnnrKnJH1rMioDnEfG/ndDE8qTsdTvsS/ON9UD0kZJvizqRoETX3IJixEFNsZs1TtuVuDYKcZozez4mm3WsB7ogrDyGuwaX3U0oo0PLrg//WUVzr9Ym0YT3nKrUhukVtcrmZcACxUIj6cKoZbFhIcrd/XEGpdfC2MWokA5sE69XOfkGMMVyDh/c7aHJbcmZsXJG0bqDkcoCR+WLbNLPnxJGBfkOfk4VigdeTB+5H1JJ77rtK6yPM/EMWRHIUMNDs9+eeshRd6ng+v296Aywr6WSUa3SvId9B5gRxoo8GRslZzA5SROIs5DqciLpDYp+9OIk0n+NrUZ/2jLEBTdwD+pPKqmPohHxjg2WkWtJwEmKv8NWUL7O+7tBSzjJoSbKnvLkdCA5ok3TxuISXvgbTK4M0IJ9i1k5WY0tFblTr8DCnBIZJMSBKjLhMb2AhGbh/hcL+A/H3ByP9qPBYACmg/neDURnjIYnMaMHXH39+wcNFs9BypZc8AZmtx55HEPMT1/Gfgehljjj1R5m6GK0x+yhhbcxCgm8Dc8ecRUVuSw7914FP2wIemK8VPw5HSv2xwJGAFPLglGRQBljL3L3pafI5cqPCR6oY8Q31HqbwRq9kGsvYHfsuSLhqsaClrEEST4n+vFFVHYZ0XOpEI8uX02mkkbWEyiGIe
 gltXjJEi
 CmIgpD4SfAcnNgRnio95yewql+lGMmn23tjfAtavebwKr1eNtzFjSbmNPIDqYmFnnhx1QWX39TcfxiJ5qSx7ZgqDUjTk5bvjYwORDmLbfrngV+ORDj7JPPU0L5o4ElqNPkinC3Myhgq0iRvm37ZDgin6Gs+4NqQHFaUgGLL7LA6wyuvaljcZxGLjGPS+2wPLck1Er4tacnx/R4MMcIui5IVqsZJY7Cs0InW3JqlqORXTQvZuvs8Ll3NmiX6gZsqF2vekIYxlio9cuOK4P65ZBR6Cl2A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

MGLRU evict_folios() isolates folios from the LRU without updating
the NR_ISOLATED_ANON/FILE counters, unlike the legacy
shrink_inactive_list() path. This causes compaction's
too_many_isolated() check to under-count isolated pages when MGLRU
reclaim is active.

Add NR_ISOLATED counter updates in evict_folios(): increment after
isolate_folios() and decrement after all retry passes complete, using
the existing nr_isolated which holds the original isolated count.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
---
 mm/vmscan.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index c1404a59523d..98226bb021f3 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4892,6 +4892,9 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	scanned = isolate_folios(nr_to_scan, lruvec, sc, swappiness,
 				 &list, &isolated, &type, &type_scanned);
 	nr_isolated = isolated;
+	if (nr_isolated)
+		__mod_node_page_state(pgdat, NR_ISOLATED_ANON + type,
+				      nr_isolated);
 
 	/* Scanning may have emptied the oldest gen, flush it */
 	if (scanned)
@@ -4954,6 +4957,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 		goto retry;
 	}
 
+	mod_node_page_state(pgdat, NR_ISOLATED_ANON + type, -nr_isolated);
+
 	if (nr_isolated > total_reclaimed)
 		mod_lruvec_state(lruvec, PGROTATE_ANON + type,
 				 nr_isolated - total_reclaimed);
-- 
2.53.0


