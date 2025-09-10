Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C19CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 13:40:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96E698E0003; Wed, 10 Sep 2025 09:40:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9465A8E0001; Wed, 10 Sep 2025 09:40:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8836A8E0003; Wed, 10 Sep 2025 09:40:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 788C08E0001
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:40:09 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F13B11DF737
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:08 +0000 (UTC)
X-FDA: 83873449296.04.D6BBF62
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf22.hostedemail.com (Postfix) with ESMTP id 175AAC0008
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:40:05 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757511607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=2KcK1G0rH/uO/5EVvtXfuz7PHteCQACkb1xtZFzcoho=;
	b=4axbzgMkAdT+SMhSGXOPGXW5WfKRDOzm8FCn1Vy+ieAbgZh0soyCRPfG+p+i9jRp5RTka8
	w9u8u+JCaqjFeSCbr2gm+vOxSF1m1RiS+5Wr6TfA90PhtdT5AJ43vgomcgbgwjXpQ+2gkt
	Od321McnWBTx5t7qN3QBoBbuk+ZyiPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757511607; a=rsa-sha256;
	cv=none;
	b=dkGTzmuxXL8tLSopeX2zH61DoRQhstXhRMnIkSZHqqyD1Drf5N/boXPZFzfoUQz2TKVaWv
	ZPokYv7gWXRmuYu8FHOHmmzjeyYZzu51WGWMn7+xn0mBYMaEPmlK5cbwkyNKV5qYDsbZCC
	dAgF5V47IPeSz443XGG/UifpVVxpl/M=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cMMCN5THSz13NR7;
	Wed, 10 Sep 2025 21:36:00 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 632F2180B63;
	Wed, 10 Sep 2025 21:40:01 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 10 Sep 2025 21:40:00 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 0/5] mm: hugetlb: cleanup hugetlb folio allocation
Date: Wed, 10 Sep 2025 21:39:53 +0800
Message-ID: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 175AAC0008
X-Stat-Signature: mz8p6y86yd3gxhaac5chu85g9eb9m813
X-Rspam-User: 
X-HE-Tag: 1757511605-488002
X-HE-Meta: U2FsdGVkX1+NFG6qObt3cMpazwQ0SC7zzfr9DvpV3exRD4fF2j0rNHx/G9P7SuRyi3pXonWPFMid9Jd2W0TrYcUHvb/2cGGQ7XOe8r914RVdOpOnzZz9+MEJCSosqEo+6qyk5bC5CrOVSGDOIkzm+WpxavPuU/+W/qePAECZk7jdKHooCYGLBdjVdCayq0XFo1V5zZGdJebVvzNMTIf0zcFfNXTPqrH+XhGumiXYsIXjYjsLZ4zJn3il8vCxSAdasMvsj4WRGpd7doV0GlSpnNRhSeAOewEvFMqoK2Evx05ft1IuVJt/eSziSqt+K4y306bY31eWe7so70JNRBkd7EWU4yJYfMAZ2+XpmJDvl2HXwNesZ9ztenuf0t4wZAiQ9W9RCtkoMLGCEN2xCobZ3ZfR2N2Ck/66bwPimzu/U072k/joFkyiEBfuUUd34LTZNNqfXz6E4SC8rEYz7cRxpGcPs2U2Ed9umc5wwffFMPiK/CrfhKiMs+AxuhD568r2cz2YvzFX5sTHyfn3VbdWg/Yst80es+35YVrirfIuNF/ZQXAZEk0KJBJDAwueBTEb5p46Gp3zrWuJcHTO7aFWxxHl0+FHTi9LVqjXF8ledZFkKaeSUdVFi/7EclOedRsiFaY3ArasRZMoP4VQnwI1uzYx6VgXOtPPPiMC3Zgdq/2cXeruJpyMuj9TziXblFlM4gsXB/m9gkFpZPrevFbbNm1tzTkp5dr/Odbfpmk8iQzKJ349NqlRQEwjW8ByjfFZkEvd/Ua6gMKemdhgUiGbmQrTXBROgLDWKbnfrv8XxChvghv2XMsNBcwHJ7d1uK8FtIOtZ9NdT5bWXfPB04Wep1rUnEdwU3HxaQBlD/0BhYcR3EYS3zx9hAJNoLpiye4n4LmPw3eqCPMkVERgniBTvnmmLO/m1EVlTuLQLux832x/wkeeUIPvrXjNLLqR13hF0kPIRHOLnsOt0jKg31y
 ZW93jEJW
 tRdk9mQDJ+NMoGcMi5nbQLgiYmZNDzZ1cnteccczwCd1ALY+QbM3u73rFUPCwWhNVZoDex2qDarv6gCnwLhkHu/hbRvQ3QANK8v2DKJnk2bK59NuuSwk9Ss69sD+J9i5YQgznwLAFCnGGN6Aa5u71OuIm8Tj9UvKX8ZH47Bi8pKfrHGqS0Q1yb5ApjKAHBJBjKP+3GaYGxXGnvbD78QSffC+Zoufxb4roAgcW
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Some cleanup for hugetlb folio allocation.

v3:
- As Zi/Matthew pointed, it's better to not set page refcount
  for both compound and non-compound allocation by adding
  alloc_contig_range_frozen_noprof(), which need more changes,
  so only send cleanup part in this version to let it go firstly
- add RB/ACK and address commets(per Zi/Oscar)

v2:
- Add RB and address some comments(per Vishal / Jane)
- Naming is hard, so don't add hvo for alloc_fresh_hugetlb_folio()
  and only drop __prep prfix for account new hugetlb folio
- Add ACR_FLAGS_FROZEN for allocating frozen compound pages
- Refactoring the cma alloc/release to prepare for cma alloc/free
  frozen folio
- https://lore.kernel.org/linux-mm/20250902124820.3081488-1-wangkefeng.wang@huawei.com/

v1: 
- https://lore.kernel.org/linux-mm/20250802073107.2787975-1-wangkefeng.wang@huawei.com/


Kefeng Wang (5):
  mm: hugetlb: convert to use more alloc_fresh_hugetlb_folio()
  mm: hugetlb: convert to account_new_hugetlb_folio()
  mm: hugetlb: directly pass order when allocate a hugetlb folio
  mm: hugetlb: remove struct hstate from init_new_hugetlb_folio()
  mm: hugeltb: check NUMA_NO_NODE in only_alloc_fresh_hugetlb_folio()

 include/linux/hugetlb.h |   7 ++-
 mm/hugetlb.c            | 104 ++++++++++++++++------------------------
 mm/hugetlb_cma.c        |   3 +-
 mm/hugetlb_cma.h        |   6 +--
 4 files changed, 52 insertions(+), 68 deletions(-)

-- 
2.27.0


