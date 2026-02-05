Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF10E91297
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 09:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6EDF66B00B7; Thu,  5 Feb 2026 04:04:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D92E6B00B9; Thu,  5 Feb 2026 04:04:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AE706B00BA; Thu,  5 Feb 2026 04:04:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 489F66B00B7
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 04:04:03 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 13F40C1B1C
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:03 +0000 (UTC)
X-FDA: 84409815966.27.7AC4A49
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf23.hostedemail.com (Postfix) with ESMTP id 63E37140006
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 09:04:01 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T9tFkJs7;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770282241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TuhMoOfRbvDRr52ITJW32CIqePtfQkF24X/lt5AE2Eo=;
	b=kBUEWWSSsgi9to65QOqIgN8Au9Co4FLcYQejfQLtBBgdw4rWM7ohvoqt4Z497BOGu5gMzS
	/1BWkHWdOquB0A7WjGduo1If5IVIGKwBQR9q2bPoy/jonOXpQ8Yjb6Wmb/weQ2++pXK3RX
	rympQR3qTayP5DSaRd6ZUFTzYlIRO3I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=T9tFkJs7;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770282241; a=rsa-sha256;
	cv=none;
	b=qoYDgGk7+iVjDcYw/LtKfPWj3IsEYT2QqrcC+5ymMgeL2Owf8eQ1UkNui+HdRstYYDRvDF
	g2ajDnE3lWkVXlVpH7ZocuS+rcnznYuUL/KDyRrRR9b7nP5sW/igr3wPcEUnok8iYZZLOO
	fzbGFpCikNFhMkav/KEzkk5ApjB7HmM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770282239;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TuhMoOfRbvDRr52ITJW32CIqePtfQkF24X/lt5AE2Eo=;
	b=T9tFkJs7ctZ0NCtrcpZ8FGPMeUOscchOZ/GeyGeplqd3G7G12nmIo0kc4sHfKcallmV8jU
	08APyxlfApctPlNsY6t8VBeNCJC++rC0NB2qBGll/JPk9KIB7NqR8sNmTTawzQtZZHdZYp
	RwEvA/GSIClVZp7VXmNQleupJH2Y9bs=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	yosry.ahmed@linux.dev,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev,
	bhe@redhat.com
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v4 20/31] mm: zswap: prevent lruvec release in zswap_folio_swapin()
Date: Thu,  5 Feb 2026 17:01:39 +0800
Message-ID: <d29cebbdfb716fb468de8170a8a23586d395e987.1770279888.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1770279888.git.zhengqi.arch@bytedance.com>
References: <cover.1770279888.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 63E37140006
X-Rspamd-Server: rspam07
X-Stat-Signature: 14wdgx35ajoc9sug8ifq8h5888ugrpqx
X-HE-Tag: 1770282241-923492
X-HE-Meta: U2FsdGVkX1/rBI25Y0xTp+rbSeaRIfQH89KIcTDVsMujKrQfUS6ysR2YdMPzxSal6/3SkypO9MDbD4YucUWJa8d3LQ+e9hpflvI16u3L73Gm+UOcNU2BY8enckVrgbPwZTFCK5uE+Go3qm36Luqk3Tr0B1bkijQ8PItCAXHIsHVKJyB4j6t5snNOGyQ4EnxsewROtdTFFKZDRxuf02kaKb1pJ5gZc5dWb/hjYky5yCZEesGQiTOb4BM2ucq6DacaARa2/2g6IUC3smRXS2UWLrBgStk2Yeyk8E9SbCGTj/5EKTCy0oyX7NYrjNmpcP4/lc3+M0mZT542zm4fSG/aKuM4kgB/lV0TCu1f+4sneqdBNob9g0Orer0hfYFe8xH8K/UzGi2fW+pXxRLP2VFiiQcC3RAh9YWVYQrtsXtoYm6J47+plLa7t45BD4E9/rEy/rvWNC6ezp2NzWmcPmm84sA/XoEgFzvXjrstjK9TWHGWzkxkxrfAFmpviy6HzoM0+LHnj3YtHsFcnq3k+2I6s4DPWl4QxNbwN+fOx5E8TMzjxVRvvqLxIWcaF1LAUYyZgVHt/bt8WILq4BtWEZDI6MjJ5V7iPDxesTe1XkwpubXRGIrnf/vZ2RTSIwUfr+pnMGB29VbU73Tu8Ch2qOV3GC4z4PSzymGFcP0I04QKG+pJT8jUjkenowvoEDSPC1z8fDsVH3PMb8MDEJtCRu+YgkyLHPLV0cNEEXkxIvo+dz3SI2t7def1arrt70ElRyIOqKpC3k/NckFGGrnBs3gDeJ7Q5QabNdK8lMWLhkcmKgnsvv6e2JQzDyKTr1+opyqty3scnTcx2QQOGY16L5/D6g2d23N+RkeOQDOAeZFMl+cc0C9LySOVvxITvkLc3SwcFHunWhIFnVru3GooSw/ujv8oBGhfuV6Ij+NW57E7gmLyy8bBe9zYljEzFfKX+auW5hUY6YI1gd/Tc3WShKh
 HPTpgGwM
 RzVzWy6+dZAxqgC6HApHYfVHh0XagmR17Tfrki0YMYM6tIMeSX3WrHEwgAFU9NIa57OaTWdzrd6+He1BGHclPlYkFyZWD+zHb5B01VDT3giI+0OWoQH0PRmFfin7tUh8yBzRr6U0B9wvdBGR3uZ+/whLmDEtInZ6wK0bDSpKTMI60NUjwo9B98qXN/LH0LyxsDw1xQrXArdqM8ly4C5bjsz508XzBcc4+lBUcZaMX159oruyc/Fsqwv8VQ62thXrD1SrRFjqK2WEcat/toj8o0Cp+jcrbW3YOhWhDbO0g4a71Ro2R9ZM5mAeuM9h/0Dd9bJ0SRPVbXFkIoCVB2f67W+2bWw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in zswap_folio_swapin().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Acked-by: Nhat Pham <nphamcs@gmail.com>
Reviewed-by: Chengming Zhou <chengming.zhou@linux.dev>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 mm/zswap.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/zswap.c b/mm/zswap.c
index a9319ecd92b4b..aea3267c5a967 100644
--- a/mm/zswap.c
+++ b/mm/zswap.c
@@ -664,8 +664,10 @@ void zswap_folio_swapin(struct folio *folio)
 	struct lruvec *lruvec;
 
 	if (folio) {
+		rcu_read_lock();
 		lruvec = folio_lruvec(folio);
 		atomic_long_inc(&lruvec->zswap_lruvec_state.nr_disk_swapins);
+		rcu_read_unlock();
 	}
 }
 
-- 
2.20.1


