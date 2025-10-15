Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 10D94CCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:36:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A8348E0009; Wed, 15 Oct 2025 02:36:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 658878E0003; Wed, 15 Oct 2025 02:36:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 595FB8E0009; Wed, 15 Oct 2025 02:36:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 481AB8E0003
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:36:11 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AD5385C974
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:10 +0000 (UTC)
X-FDA: 83999388900.24.50AD6FC
Received: from out-173.mta1.migadu.com (out-173.mta1.migadu.com [95.215.58.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 29BE4140014
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:36:08 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sZxMVdrF;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760510169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CQXtHg5khcpjKfA9N6hKlz732m3j1ep8SxiJ8w0fvZk=;
	b=KVm7D26rEAccFO+tGZ0TKyUengTuQtalm/k7GKox3kvjQvJHxceGgeQ16SvqDvCqFHbI+n
	ImNFMnKUlYarYUAcT77oHewYv8GE2+Zn6YcgEbttZtH1gQ9IJLQiPrWftXS6Jcne0YCBji
	AJ+/252xFlSRHjR8TLjteo2idoA+mcg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760510169; a=rsa-sha256;
	cv=none;
	b=x9RqV3TA/+mY64+tIkglGaEXZcK5QkvVT6lFPkBbd3fYIcjjBmxmFJx9RY6Dw75FZQ9kO/
	VU30VaYARIwPUIJzI2Fxl/DulrVhfGYU6a3oiDD4SkkfeYzW1hxI7hS59MUwnXptPOJXeD
	Gj7PSaG8fouAhHlVhBHQ13rstTWFpZQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sZxMVdrF;
	spf=pass (imf26.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.173 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760510167;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CQXtHg5khcpjKfA9N6hKlz732m3j1ep8SxiJ8w0fvZk=;
	b=sZxMVdrFhkD87zH9b3Mee+lB9R/FSU8wb9ObVJc8sQoieXdZAQYZvcV9B/4fjpH09EV4Tb
	IabURBYbRnKXfAnFXx5aIRo7bnIPs/jywS1YV8+p+zBNDLVW5m/r2uuhZNFMi+MID/4qjZ
	ux7cYSCnmZPPUuL4BXVK6Xk2m73xBuE=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	baolin.wang@linux.alibaba.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v5 1/4] mm: thp: replace folio_memcg() with folio_memcg_charged()
Date: Wed, 15 Oct 2025 14:35:30 +0800
Message-ID: <bc75f3a5bd0920861e522abd83eef74d402d8b57.1760509767.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1760509767.git.zhengqi.arch@bytedance.com>
References: <cover.1760509767.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Stat-Signature: gwy98dgazicidu5q6w41o3wrud5p7grp
X-Rspam-User: 
X-Rspamd-Queue-Id: 29BE4140014
X-HE-Tag: 1760510168-743940
X-HE-Meta: U2FsdGVkX1/m3M+7H8KP/l0w+zpr94PsnAPnrDTkS2aE/3EInsvOG1qAvfxt6dwsJ8bV80jU94QjZ1ru8eidi9/imrCfnx0PERAp1W646MjYawXtocp6iImQk7OCBtVV24HKKJ2BIROEEoqriMIxaeg+Dm7ubbwI0RX6AxUkRxSAWTukfjD/zecESjb4/G8YjrcJ2paxMnKVOKu39CjPk6gdMnL9ySPRZIrZ6lCNjXD+dAGcVURUb20hUf4LAGoOWwO/iW8mCt0Ip6yLT0pAPdTU79ONTDvci3hlpGjaQZ4j4WuVPrUlPoSMKcLQ61A8xtNznkFB3F316fY0ekOfgmXF/J4L/vEJzxqRLx7BZXcoqijpxZPAGwfmiTHp8AHtWzD7ruYx/qw5f7kntUyBBv30MZX/2y+cBXN9Yxsx7MOzMsQkp85dYtvBQhUDztvMNkxr+zj3411633ZjgyjnWDSsud+Qv8xBsivBlW8+tWxDPZQe2mY09OqH7ZNi2whPH77i96dyIXiT27HOXV5c57/xmnkGdKzI2hBaOa4LQlSVaB6mvgr5M7W9HLLXUBOH4/p/iTBjkRHkw991vE1GEAgqFeAt/L0VCEsyltL1XoXYTFTC+3kS8+xRz1Tn026zGcI7HDvHEpxtHBVYuJaIvQQz4cRXqg7kjCvJsCtSi6lj6xvpbM6TVQRcxGilWnkNtmAPg6CA/X8ismHk883YyRaD7wf5zJIKMHaPl9NWLigusSZ4X6kt6Inv49CAVAntUlzEyeH35P6JdvNNzGR4hxQKa8mPZKwaYzoSW7jPCDNGB82zY6LqIKWJLwaCF7kjz8kSUHkbnNmSjhB9+bQvhUy0Yf3sleeHR72YXMEDPKWtH92f1sj/63ZskAKjCdftlgZORhG64BcZ0uIa337doFY6gJOk5T0uZI/OJ6J3F9Y5fNRqgcjyWKh7zqxzF+4b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

folio_memcg_charged() is intended for use when the user is unconcerned
about the returned memcg pointer. It is more efficient than folio_memcg().
Therefore, replace folio_memcg() with folio_memcg_charged().

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Reviewed-by: Roman Gushchin <roman.gushchin@linux.dev>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/huge_memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1d1b74950332e..3c42db542b1b9 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4014,7 +4014,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	bool unqueued = false;
 
 	WARN_ON_ONCE(folio_ref_count(folio));
-	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg(folio));
+	WARN_ON_ONCE(!mem_cgroup_disabled() && !folio_memcg_charged(folio));
 
 	ds_queue = get_deferred_split_queue(folio);
 	spin_lock_irqsave(&ds_queue->split_queue_lock, flags);
-- 
2.20.1


