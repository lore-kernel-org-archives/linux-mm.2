Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1CBDCCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460EA8015C; Tue, 28 Oct 2025 10:04:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 411638013F; Tue, 28 Oct 2025 10:04:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 300B08015C; Tue, 28 Oct 2025 10:04:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1C58C8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:04:02 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D808B485CD
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:04:01 +0000 (UTC)
X-FDA: 84047691882.15.B57DE5F
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 2AC8116001D
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:03:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qdyjhz16;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H+7NrfaZDIPUuVApNFCo2ZEP+9yr6hXQlGbR4tT0+ik=;
	b=XMKOzBF7HqEcdpry1dd1AnX3PgNsmlXvymZi//EGnOHNdukSHb3ql5YvBayLD+/b54Ob4l
	AHb+WY9iIEzLTlpTJU0GGuo15tE0/cwsLJgXnBqMz1s9NkIWG4TEf7lJjpmUokHVIEdcB3
	KaiermyAc93DWpJu23DS+1d/Fpo/VDM=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Qdyjhz16;
	spf=pass (imf08.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660240; a=rsa-sha256;
	cv=none;
	b=pwHy9Yn15z9WhTKuyA7QG1cnQ4CshLEIRTVKlN3FxteclgwrrMm/zZxPmf9/W+39yBWs3u
	bKocR/Mp1mJyLWE+IZXuZKvkK82NCn0/u3tWmrStHOeEgpo9d3Fv0C4OrkiJTW31xKdXSR
	HjaxzlXFdZd1/i0vp+2seLwAYejfRWo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660238;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=H+7NrfaZDIPUuVApNFCo2ZEP+9yr6hXQlGbR4tT0+ik=;
	b=Qdyjhz16yrrQUs+gx1nzi89faKxHADcP4j9vTU0L4BargQ0ss1oUx66KBzo6X3MeKKARg+
	i7TdrDOyRKnHNz6X7Ryn/w5Lf8VqKa61i19yefLGT69//fwtHrH24n4kSvJiW1mDdOEeSP
	2QfnOZ1TikLPFn1LqXa/r/dZnOq6tdw=
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
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	akpm@linux-foundation.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 16/26] mm: thp: prevent memory cgroup release in folio_split_queue_lock{_irqsave}()
Date: Tue, 28 Oct 2025 21:58:29 +0800
Message-ID: <ae89721afa0a21376eeb3386fa60f7426c746cd7.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 4z5aba4cgfoj3dzyyu6ozcdpptdnfjdj
X-Rspamd-Queue-Id: 2AC8116001D
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1761660239-223777
X-HE-Meta: U2FsdGVkX1/3p4mvn/DQZh/s3TEa95FTTcvajyz52zWBNSlGFKq8DTY5DdvA1GIYf6zlK18uSbevS0Xmo0ScFIoIx0U3im0C6+8lxbosv85XsV6KVCRaLUwTmlSjBhPCb4ZyGnMH7Ff3Q+LZB+L+HDLTbo6wvog4FHkaJGTyecklkGs4W7x4arWGCx5oFO6U5kjJ2DF4ZTJ+YK+0cxhqgKpBlZwfUMMbAt+aqYAsKBlZVM+z47yeIZPXxlIZ/KVFVhMTtvC2jyu4X5iDbCu16zCGvVauRIHt+if2IO/+KD03lpr9vdm7O9Dya/KMhOiMt3JjUkoO7lb9G6z1s1eg6Aw2dslP4b/g3dxU3EwVFHVdkVPJYwpyYtIpNteRECGYZ71D82st9qFEG0VZyGpMbj2KouAjh32EO6/q2mRYd3uEQWYjfP0CwQfJJGre63cH8Sq6FC9VW4e2lPUnx1GAZjYKZY3aTDbOAtRxF93n7P1MFwZ1vMPvxjh5XRe/xUcl+RXiqiOEj7YufasObE6m/b4qh2W5VFXa53WmUm/AsQkkqLm4OtsFAFX95d/uuXjTooTfaCDWIbZJczp3os0nGuKqqYh2hpkFBPgbwfXqskyhLCNBZwlioJmj1XwUZXwX45fZA6sjuHKTJ7fXA3ECHDtCMGwKQRkpws55/WAFyu9CXySBNsVWwtcO0P7SZYRBhjY3Y3KwP1REdR1BBfBnfDASP27HD6CRolprThXqLbLjh3OhlnWeiRPbbjmjd/CMMKs/fb/PMZ3Mndxq/gH8lB/Ke3FkQcaAtDud7JAkgvswD5J2M21eqzq7rJFpYjfVacp58K0yl6q/gx0B2fTxKjF6iGMKjgc3xfKNmu5BdYLyvIrL0lrXwkOZrxioMV452sQTAQS9GEYXJ8cdR3cHrMjIA6L3xEtlGaQjd9l6/OZcKDdHgv6r2UNvij4asw209MWBdlOG4eMno28Jj2S
 5IgvgUB6
 1HI0Ud/YxSSFAzW3ePMYszBWD6kovvq0UHK2Edv7jLMaD2oKz8tWt/9596u/iG3J7X59WDMm6DdbQkFLOhymU2amJdAU+zStOPBs2WrXlpqG7oH3/hXVEoVk7ZlpTDUnuyLh1E4SJ5YbPDX7xIFQK+jN4QN1Al6vD1HkWWdX6MN/KPqiKshuM0iz2fzbNTv8B42EFJ1SITDBwE+ojUkdafVUZlzNzEWuijKq8ni3KnFT1BYYPXdwq+lrs6gqkQv6MZ0iIfUyt+B6YvM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Qi Zheng <zhengqi.arch@bytedance.com>

In the near future, a folio will no longer pin its corresponding memory
cgroup. To ensure safety, it will only be appropriate to hold the rcu read
lock or acquire a reference to the memory cgroup returned by
folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard against
the release of the memory cgroup in folio_split_queue_lock{_irqsave}().

Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/huge_memory.c | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9d3594df6eedf..067259a9e0809 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1153,13 +1153,25 @@ split_queue_lock_irqsave(int nid, struct mem_cgroup *memcg, unsigned long *flags
 
 static struct deferred_split *folio_split_queue_lock(struct folio *folio)
 {
-	return split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock(folio_nid(folio), folio_memcg(folio));
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static struct deferred_split *
 folio_split_queue_lock_irqsave(struct folio *folio, unsigned long *flags)
 {
-	return split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	struct deferred_split *queue;
+
+	rcu_read_lock();
+	queue = split_queue_lock_irqsave(folio_nid(folio), folio_memcg(folio), flags);
+	rcu_read_unlock();
+
+	return queue;
 }
 
 static inline void split_queue_unlock(struct deferred_split *queue)
-- 
2.20.1


