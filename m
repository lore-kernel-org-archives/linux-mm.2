Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCC8FC624D3
	for <linux-mm@archiver.kernel.org>; Fri,  4 Sep 2026 03:35:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CBF996B00A0; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C23AD6B0099; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9BA36B009E; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7DB076B0099
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 23:35:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0BB231A0701
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:35:17 +0000 (UTC)
X-FDA: 85174664274.01.6AC015C
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2C720180003
	for <linux-mm@kvack.org>; Fri,  4 Sep 2026 03:35:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DsLtkYV5;
	spf=pass (imf16.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788492915;
	b=1ixl56r/FaYyN0gErVy5Y7wblTKpfSrZka6ODrS/9QhebUjrVVjXTvTc07LDim4wXWSwpH
	zxJi+ZFurY6u9kj94l44OJv/QbMX3Loy69wPxl7vLQ4pYtVMiC9z1s2lLprce6O381pg7N
	yODg4iRRD38trnQrkzluHFFwnxNVu+s=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DsLtkYV5;
	spf=pass (imf16.hostedemail.com: domain of qinyuntan@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=qinyuntan@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788492915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=oQIqkOb/fjxZy4PwRAU78hf5BLiwp7jSD25p5AZ6eDs=;
	b=7YLUlAOs0CWeFDk4lsKXi11qyxaiKRUDNuzPLNbFh41bSHVhHrfhTzTAhfoUnUa0Fo+0S3
	dWgbdEMmulvacg19d4NhRwiURiMOkZrMb6mSvZbVfOtg1zBo8TaawYLZdiCx8MZtT1ZW0y
	87wu+l7lRJe8Ep6f1Sv7RN/NUAWAcrc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1788492909; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=oQIqkOb/fjxZy4PwRAU78hf5BLiwp7jSD25p5AZ6eDs=;
	b=DsLtkYV5XvZcVYJ4jIDUNQGX9XhU58PGEgmgDuBXH60TcnnL9TYjK5AvRHvRz85riqqNXW4GQVenklAdgpRLTgoA/OVxemCObVkO0p52sucLh8zUxFxHoc6E5LJR/oz3SaxrgOIlVV71ejZNPxf4c2I3053axSRkw9/VAYLw+sY=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=qinyuntan@linux.alibaba.com;NM=1;PH=DS;RN=23;SR=0;TI=SMTPD_---0XAHQrIP_1788492905;
Received: from banye.tbsite.net(mailfrom:qinyuntan@linux.alibaba.com fp:SMTPD_---0XAHQrIP_1788492905 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 04 Sep 2026 11:35:07 +0800
From: Qinyun Tan <qinyuntan@linux.alibaba.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Xunlei Pang <xlpang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Qinyun Tan <qinyuntan@linux.alibaba.com>
Subject: [PATCH 0/2] mm: restore SHRINKER_NONSLAB on THP and zswap shrinkers
Date: Fri,  4 Sep 2026 11:35:01 +0800
Message-ID: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2C720180003
X-Stat-Signature: donoenaoxbpn41pad3e8goxk88cmx4zw
X-Rspam-User: 
X-HE-Tag: 1788492913-441198
X-HE-Meta: U2FsdGVkX18SfN5EGn7pFq3kRMJpRwd5Sk7LXNP6ISpU/3dz3/kkCUqoCmhMCJ3YeQXCxFbEljToNLhFSHu5W1uokrkvdASnmpXYneh7D6VY/DYrkdIMWYKXQjm8RVHi+Aw55Lb8TW7vzDpyk8p2QYB8kePucv/uffmu4urJSWqWLc+CaKNTcpvE+cVBwGopUzjEYqbj/nmNHWfMMwVwW1ufxqCdRiJcXxbOiM3F3EO5m0oqEP9MwQhTEA64F8rBd17EXHU48rkMZTNEDSU8fG8nwJScCYCfhfu4fWmiTYQduNvcsFMxrxhn6Lm0FZj1VJGOXVBDd3LunOzESZm5dZf+dOPbnRONp/P5zMtALhjpw7s8o9NaSXfmF62bFSeR4cebfjRkjpgplQaJUa2wgMIk5RKjstOpyVE5KMRuMirHppe0unk14BHq+v+yoitjdpTFl+4I9tN+xbWuM7t9BBsEQl5+iSWCLeZhv14lMa7uS8DzR+nKBQDEbtJR8ocd2Qhm1lnEidwbYAtt3dW1OAQqmIVOuRcVpEFM12orxlHc34+jdLU80yz5/3A4GnNScNyfQ8bXKfwYpxAnTMTn1mCmmMfJ9IQt0Ak7SKe/wokIfOk4zmS7Tv6LyctUJ8+ptB5/2wmFUPHBNtxtKxt7XXgQ3rMAQecqtGnlgC4uYYoN3mJ4LRyM2sx6hjaY1vxv1jtQS9V92W9CX4peO4Hlx2FI0ixhdQGQqf5OZHK2jaIbjZ9h8GSE6cZDxUpEO+dX7bh6PGOppqacLvRIzutV+Zrk5di9IG0ndiJcxuVpxp/ovQb6Rr0uwiW7SVBB5ROzzO3WEK2Pl/imWKwuCmpip3nl8T+OkVG6+ImXnuYAo+qkEFDbOAGYLqQ5LZtU/R/jEvx/ngeNMNji6cGn3q4lPoGJVOsRMQZuEgcNqvxnjH3q0ZbUn+PyxjvoY5yc9R0nIH3xbhyhEBWL4LdnSJi
 +CxWaKcy
 Tpf4DOlQSb/0hW+yw0AiyZkPtZwjzxG6KucR3t/nKOlOnqc95nuFw3cux7ygLQe8uaV9UNQMhSABb2NWhHlJToXeQcc9voVzObujbfC09zj1IGIvxk6apbH42+XY3bYQWd3ypgIOmffNVczwfSVpmQIe3UaBN/xFKkdUHZMaFWkH7v+GNVURasC0Lu+mJIM7m0zYK/ijyZMKed0ygjN2A5Fi885vA+3ZOrFxDr8Nd5Ft+BOPQNj5C/3E6JiHKG3JFdvidKNyTTfrvxqib5EmXincxNm423X4KFTZC/rgw/W9G/5L3N8omhYfcMToYi/fu8bimoDwSrAem78g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While reviewing the patch "mm/list_lru: don't copy stale shrinker id
from non-memcg-aware shrinkers" (now in mm-unstable), Michal noticed
that the two non-slab memcg-aware shrinkers, the THP deferred split
shrinker and the zswap shrinker, are registered without
SHRINKER_NONSLAB [1].

Without that flag, booting with cgroup.memory=nokmem silently demotes
both shrinkers to non-memcg-aware ones: memcg (limit-induced) reclaim
neither splits partially unmapped THPs nor writes back zswapped pages
of the cgroup under pressure.

Patch 1 restores the flag on the deferred split shrinker; it was lost
when commit fafaeceb89a5 ("mm: switch deferred split shrinker to
list_lru") re-registered the shrinker.

Patch 2 adds the flag to the zswap shrinker, which has never carried
it since its introduction in commit b5ba474f3f51 ("zswap: shrink zswap
pool based on memory pressure").

The series is based on mm-new, on top of the list_lru patch above,
but the changes are independent of it.

[1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.alibaba.com/

Qinyun Tan (2):
  mm: thp: restore SHRINKER_NONSLAB on the deferred split shrinker
  mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB

 mm/huge_memory.c | 3 ++-
 mm/zswap.c       | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.43.7


