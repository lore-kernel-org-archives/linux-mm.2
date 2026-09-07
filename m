Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A10E9C79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 02:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4756B6B009E; Sun,  6 Sep 2026 22:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44D216B009F; Sun,  6 Sep 2026 22:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 363E96B00A0; Sun,  6 Sep 2026 22:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A9F96B009E
	for <linux-mm@kvack.org>; Sun,  6 Sep 2026 22:55:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AB051405F6
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:55:05 +0000 (UTC)
X-FDA: 85185449370.17.555E19B
Received: from mta0.migadu.com (out-87.mta0.migadu.com [91.218.175.87])
	by imf14.hostedemail.com (Postfix) with ESMTP id D19D0100003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 02:55:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sN0eY5sc;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788749704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kBTJzMnjR4WxLKB0jhdQnWoe3eZFgGcZ1uXAwC0TSsg=;
	b=Qpf8YRpdtY5VuLKKa9TqYwmBT3Tgqydu5BnKxh21/P0BdhtPTPHUJy3aS6GZ3dzR2bKOmk
	M+n5rqqpd2x24K/yptPyPPHPJh/+JBkN97vlutibmOUjCZR0qfryNRW76FXtdjGwAt2qHs
	4Xp5WHPrwe1ZSr1ygu3MBgjRsVeb7nQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788749704;
	b=q7f9OADKJN5eYzMrrMzX5eAanQZ0Jdp9T7k74P+pqihj3y5ASiOrtqN2NIgsYbGDO2X6et
	BNk4UV5JbmDUhr9pFa05/xzk8+yMpsiI1J1uLMWO4e1sJm2oRyuSoehCzIjg6Q2gjlKoj1
	Wc7ficYRQSMdYHmcfHeRZyNOdgbVhC8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sN0eY5sc;
	spf=pass (imf14.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.87 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=siEozKNwZMwLyUvwvGE498xwfE7YRELk03NIbRMtXmQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788749702; v=1; x=1789354502;
 b=sN0eY5scc5iiMJ08mqwQPCLFiSLkNKOoGw/GxGVfxqtiVGqewbbOX4ZRyIswks0+OrFFfMgv
 3uyVQT22RPXtFJyZPy4xwz4wdWBal2Xb6YnUFrvBgvy0rdesJqxszB76gms7Q6Chl6+21MoDMmV
 TSAFidCX9W0HM1EXvteB0xgY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5e5fb54c20b00d72;
	Mon, 07 Sep 2026 02:55:01 +0000
X-Mizu-Trace-ID: 5e5fb54c20b00d72
X-Migadu-Flow: FLOW_OUT
From: Ridong Chen <ridong.chen@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Chris Down <chris@chrisdown.name>,
	Tejun Heo <tj@kernel.org>,
	Yu Zhao <yuzhao@google.com>,
	cgroups@vger.kernel.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-mm@kvack.org (open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)),
	linux-kernel@vger.kernel.org,
	Ridong Chen <ridong.chen@linux.dev>,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v4 0/2] mm/mglru: fix ineffective memory protection for non-kswapd reclaim
Date: Mon,  7 Sep 2026 10:54:43 +0800
Message-Id: <20260907025445.1836238-1-ridong.chen@linux.dev>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D19D0100003
X-Stat-Signature: mc5u6no5ptdapb4o51p5aczqss1eamzx
X-HE-Tag: 1788749703-505447
X-HE-Meta: U2FsdGVkX19v2dj50El1K6JhDvN3sNHBFxaXsORSG6FEz3UI/O3X9y0+iCZfLZDBlpaKcsd8G9CSslacqivuGOgOn97kS9EUqixH90BySn625KWoLft6HyBrY7FQI+pF6FRUmw8ZFAHOfpnESnx9RxwSLNRai0aSNxMQ1PvffJROTleM7npDLlo7v17aBqVJloSRI//E5y3M7lD1OcW+51NpsqQYIl2UJxZ+b04t7RIvQjT5ksl2uD3CvP1A6RjGFkjpQMEiUNhcyWOrRXOh+/BabxxrU1acyIi7YacTEZL0RdQ7UsneIjLFpKUTdxoumn9GE1MFgAFLeAaCpnlQ9c+vxyi8qLo6RUUxmAo6QytGFkBU9vGEoU7GkKnqG4EBto9VFwGK+DDigmrVikeWgC1T2ljVITgYrwSQbNIvll33kKvkdNjept7Gw4EL+e8Ihjdz6WAg28+REbeTM+Q8On4zs3SGyzP3z8YE9ZHt/rWfqpYOIgaAGNICqxq5C/PM3/TKxnNAC9nihA9wzO/e53lzR96zmE0QdvFgDJ+oRC8X5gSeUI7z4Gu1Nplu4hNPNkT6FqJSSYP+dYZepQdB4aV5+KQ7/MNCumtULbTwviA8mgW3s6IULzyXi217ALorXFw99s2p6ZTym2sd2yGPl//fx2I815E9qC76/TeZFWOJOt7Yxz2WQAJWMQ3eBOz9Pr7G36XxyK47EETt9RoV6fRDH1SDTzDmqTiXBIlLCUNI0ShvCQh7xR9JOr49XIi1/yeXTNHkberRF9CF8jYI+WKaaMo6Md1Nt1nTIUvALFjIQ9JqO+TRPtcIt/W2/pPIRCOEj6MX6sQXTrOYsqKpMWHW06blcYXJb6vDP6nUwkI4YPZ6vu5HZMIcn0mqOfsKxtdqOzwrktY5WHGMkZ4cQEDSM4FGoenX+B7aG7za3fW2d9hU+2Zpz7R/hmsQ1QyfIT/biJ6zV11UNn8mgRY
 2JwM6eFo
 lY5UPGDrDok3qGoZfylabXSC4QWkcePY75XCJ3rkXpIMAFiMN5glL7BKR1SkaSJgz9XhRxUpnVVyyLSD34RuHzfW/YG6wDPGLOvyfzYHwIPov6u2vQ8XXIQuyqzZ9JGilCddLa9APlav2+TF1N9X10AC34fRl9dVpDo9Vu++TA+Mk+E1Yx5hwSSVJv10qL9ZUFq0CUvhRUqy8xf1fphfKJ1Oc/2j5cTU19hbGsLgrFPb00VJkfVr5tZZIKUo7smv7vcUNgsJk6MBF5wuE/4gPoC+f3c+DYH3xWNpLO3CXPiM6FCaytoPmHuNuL0uC9XIsf/j6KaHgcnx+xkaA+jNRSdwq8Zu0DUCCNskq0fSVWW00kIsh4dPKvLaNEVv+WuMixvH9gtz+Sxgfyp+uoGhMnlv+8iroM0CfvvQHptuG79w3JEGUfC+vHF9SKbKX3OwOJTWzyTJt/34nM+tsdTmALZfdotiRKUy2QzgPeiJwMBN7hshAzgy0opzYnzhmL7kigzBwOi25OPtbn04gjTbz/TKRnxIBxNpL4M/VQNMXMqgPw3M9Q5X908yT459liE5zjLc+m7a157oFD7nt6LgfirDCO9rZARt1KBK0rTljA70XVYHXvxqXyvtVDl3Sa/sGmcv5EBu7E3EREWuCYHDMGqas5zp18X6ZGvQFZaweIC8wtzufZCVveOmXZS8GBxYAFtUj/dvNeNmGMogV17tdMPVceLTihc9aUFqtYYYhp8KuqtU9mqFVxHbIg1kU5oKA9thvdGKkAmhU0k7ur/GUf95lZawZUi8mBiqu1fvKRrY8OIbX6CScavejRfmgsvXpcuTXs0KjCVWj8sxib5qyhUsbW+jg2r9fooim
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

For MGLRU, memory.min/low is not honored during non-kswapd global
reclaim (global direct reclaim and root-level memory.reclaim), because
these paths shrink memcgs using stale protection (emin/elow).

Patch 2 is the actual fix. Patch 1 is a prerequisite: an integer overflow
in effective_protection(), spotted by the sashiko review tool, which
patch 2's new caller would also be exposed to.

---

v4:
- Per Barry's and Johannes's review comments.

v3:
- Per Barry Song's review comments

v2:
- Fix an issue caused by non-atomic read races in patch 1 [1]

[1] https://sashiko.dev/#/patchset/20260828092432.1257917-1-ridong.chen@linux.dev?part=1

Ridong Chen (2):
  mm/page_counter: avoid integer overflow in effective_protection()
  mm/mglru: fix ineffective memory protection for non-kswapd reclaim

 include/linux/memcontrol.h | 10 +++++++++
 mm/memcontrol.c            | 45 ++++++++++++++++++++++++++++++++++++++
 mm/page_counter.c          | 21 +++++++++++++-----
 mm/vmscan.c                |  8 ++++++-
 4 files changed, 77 insertions(+), 7 deletions(-)

-- 
2.34.1


