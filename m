Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94735C5DF87
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 08:17:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39D456B0095; Fri, 21 Aug 2026 04:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 374D26B009B; Fri, 21 Aug 2026 04:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 28AAA6B009D; Fri, 21 Aug 2026 04:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 031CC6B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:17:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6A21D40327
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:17:07 +0000 (UTC)
X-FDA: 85124571294.13.42F673C
Received: from mta1.migadu.com (out-30.mta1.migadu.com [95.215.58.30])
	by imf13.hostedemail.com (Postfix) with ESMTP id 696ED20009
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 08:17:05 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cUmc+fz8;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.30 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787300225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hbJ6qX8RI3gMK5y4jHxx2USxOUGxbnF2MpuECV9enVg=;
	b=cvFY//G6MPDxDDwlMs3UHhEE+KXTog7HhhEkks7VoxbjuVigFZ87cFvsJLbYJ9QMOBwH/+
	QTIsfDrj13E4Y0FoHbKwg5bpkDSDa7yYrdOSZ6DBsR/d0Y2NSTTngkUcqMTgFI1cBkaIk4
	DVRG/JOcm/75an07ugYyguhDQeSZA6Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787300225;
	b=8g9C4zuU2xWmPJI1i7zKX+GLUEELZRIreo89ierWF5akQsyvDDc0ygbxmynyijT7zFxJ9H
	pMRDo9w7fGJsxpvN0YpJoBBydr+d1nSMmhOt+rYk0x4yOCnaSR/XsUSfjEU58fytDK2kcy
	tDIeqt7XAyFHLttnNcS4HuNtqzgVNGc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cUmc+fz8;
	spf=pass (imf13.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.30 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=q2LBYSGl4npt3b/U4TgoApNxg/auAjLyjB3dvIGUVCE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787300223; v=1; x=1787905023;
 b=cUmc+fz82tugVoetyXSen4TEtmnnwPbkouT5HPb1dverA6M4l2vjOLiFk1tA1L1QenIb7yIb
 7wIgr+FcleAigkH8QpXmtu7FtT/BNHSx9oxhZge4qWM4E5o0634f8ZHi68rtsxQSz7wdveYofXT
 NDMaotyeh9mPBzgR4R4wds1s=
X-Envelope-To: linux-mm@kvack.org
Received: from mi-ThinkCentre-M760t.mioffice.cn (14.29.108.92)
	by smtp.migadu.com with ESMTPS id 487007466bb3646c;
	Fri, 21 Aug 2026 08:17:03 +0000
X-Mizu-Trace-ID: 487007466bb3646c
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>
Cc: David Hildenbrand <david@kernel.org>,
	Michal Hocko <mhocko@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Date: Fri, 21 Aug 2026 16:16:37 +0800
Message-Id: <20260821081641.1339788-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: m8wi6syz3bhoqwhh9qhzophuadw313yw
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 696ED20009
X-HE-Tag: 1787300225-267576
X-HE-Meta: U2FsdGVkX19n6qFsrsapuh+TQkGsXfnGS5CQXBRJAh8EP/dEJKX7K/ahsXO02PTsZwnV6r+nGOupvRTQDrzuewmGuTrPjgCp8SxywhMa+XxOQSqXHN9AfSi77x/0eV+4/TNjALePs2DJ857DocVMHf4cEMoMiexJ4ppYEqjbBYIdLYWV/RUhcXBZ6chu+Bl/MOCaAPNr+Y/CG41IkYOiyfn5O2oPCdWhy/ReFSazL7gYrE1nVTh+y+F5skJhjpvVNNZbKFwffAqrtyoow7tEhn6tt0bqx1Waiuwv/Zt6c+BCiJNLEXZF3Oa7sJcFh+QDV6kiXEPl7ITVIFoqoQSc4BnBORricFXkxWOZTvlSscnh32uKhGbHm3WtJWSph68VAE5EIVUIpis0iNuKKb1K77eIsghSihVrIm5Ck/HXex9kU2sCsiBZEAInN0sT7G6ZuSTQTMqJHMqo+YThO2ef/HQjbjEkL5kXb7857JGVRCphNAtur/OUDltKqLSGdU4U3mgOvmk+vL/e+7W6tvsbv9qNGhc8oVPwMOAZQj/MWLN0gTj/pJKGbwzQ0DEVjwUIp+wA8mNsSSxKbnoSJUIUNXemOq/dwlb0IzLweZ8vMi0Ri8XVdBmuBbfZWAcfpetK2yrn94HTPI7OoDDa+GlT6YsjMpXDSZxnK3AurUYaKFF98cU3xzIkXy6mM7McYM9NHAjSDEAwD94VUpGgtP3NZOl7RXhmwgnL04DHzQDaZ7Z58STl1oyUQV9zTPhRJ+FuWri8scI1o5nbPg4Hp3qLgdixyvRPqCAhe8mxNwch4HUEIts3BiPSLYRBjixMwDTTQaYazBCVkEJo9M6z40N+p2OUKipZSLU7FWWbgtXVR++FRQABmrVUAOglIfy1CERi0ijnuD2tp1wZ+tcMXhGr8TFPd8N8WBsQr7h/fRJzfqHaEYaFGeNGMo+jylsbDhCOfZdczDS/brXnd2eoTxK
 /3zb8Ct+
 HjNKSdMuIsV/ZFA+xkPuyPYdB9wFx/NseXRIwRRxa71OLYHyP6XrHnvLxdWCS4CTKrliK9ytmTjVWuQjOH8Jk4R0rltf1zXo6TQ+gfMV+qnOC8R1CdPRgp8OLfdMOzDLyxsNdVUIjIMOACd7BbaBctzO2vOsEleBthIiYtnr+aTVD9OX5YJnhtQUxv4ecFCKkEF+1VlshKuLj80hLBkWKjMJ8OXMq/8VIgN2/Oi+wB3ZUzB4saOLf6nY4kgwYsScTsEKguwjPs8AC6PgJ/0C0Q3A4UMK7SvEr53K9zPz97/V7QSQFX6vKgna7OA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

min_unmapped_pages and min_slab_pages are documented as per-type limits,
but node reclaim treats them as one combined gate: once either is
exceeded, shrink_node() reclaims slab, file and anon together and pushes
the other type below its limit. Per-node proactive reclaim reuses the
same gate and fares worse -- with page cache and slab both under their
limits it reclaims nothing and returns -EAGAIN on an anon-heavy node [1].

This series gates each type separately via two scan_control flags
(skip_slab_reclaim, skip_file_reclaim) set only on the node reclaim path,
drops the combined gate, and extends node_reclaim()'s early bail to check
anon. The flags default to zero, so kswapd, direct, memcg and drop_caches
are unaffected.

Tested on QEMU (x86_64, 2 NUMA nodes), A/B kernels differing only in this
series.

Proactive reclaim (echo to node/reclaim) on an anon-heavy node, file and
slab under their limits:

  metric              before   after
  -----------------   ------   -----------
  pages reclaimed     0 MiB    254 MiB anon
  return value        -EAGAIN  0

Node reclaim (zone_reclaim_mode) with one type under its limit -- the type
under its limit must be left alone:

  type under limit    before          after
  -----------------   -------------   --------
  slab                645 scans       0 scans
  page cache          83 MiB scanned  0 MiB

[1] https://sashiko.dev/#/patchset/20260723045718.2052070-1-ridong.chen@linux.dev

Ridong Chen (4):
  mm/vmscan: only reclaim slab in node reclaim when over min_slab_pages
  mm/vmscan: only reclaim file pages in node reclaim when over
    min_unmapped_pages
  mm/vmscan: drop the combined limit gate in __node_reclaim()
  mm/vmscan: do not skip node reclaim when only anon is reclaimable

 mm/vmscan.c | 89 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 67 insertions(+), 22 deletions(-)

-- 
2.34.1


