Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB806CCD1BF
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 14:03:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 150FD80153; Tue, 28 Oct 2025 10:03:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DB368013F; Tue, 28 Oct 2025 10:03:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4D580153; Tue, 28 Oct 2025 10:02:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D83118013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 10:02:59 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A349412A865
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:59 +0000 (UTC)
X-FDA: 84047689278.01.DDFF9DF
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf21.hostedemail.com (Postfix) with ESMTP id ECA9C1C000F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 14:02:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q4KXYujY;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761660178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KwZ644xbYvlNcagDZjQ0mKRDmPXR0vZ+/IMJ8ruGmik=;
	b=OXUs2i9bLEIm3eQRbrmsbJnumuvjsZ5yEPLWwy6q1y74llsG+ts6BeP1GhU2YMoXkCSHSo
	V3Rvfsekebiv8hvvCjYFF/28TjBqPjJSY0vIhAm7xVEe+vUQaLf8LJEj6PMbcpdc8zhKmx
	Zk+bHze0TXa3yEDCSkx8toyFRXqezgk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=q4KXYujY;
	spf=pass (imf21.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761660178; a=rsa-sha256;
	cv=none;
	b=pk5muauuXNumBs7gSBOYBCXu5kkAo1c+zcStitcAhDwDlwCTFf6mXCexOKzxTOyaPYDqDZ
	cphaNFTl13zWyfm8JxjkOBeRvp/yZm/oOHNkTrjw7mcJ6e6uW5Ci3UsKXw2aqP9CDV7bIe
	zQkF5LoSZyoKX0Svg2qU+TK4LmPYzEI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1761660176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=KwZ644xbYvlNcagDZjQ0mKRDmPXR0vZ+/IMJ8ruGmik=;
	b=q4KXYujYUCNGMd6/2GfYLrwuY6WKfDyyGjAFmIfFVpIINUQT+TYRszwkW0sd/3PfetejZz
	qFDU7mIuGhZ3R8LP+L8tH0OPOfJMdxCIBW7lZeAT7MGVMa+sgKyH9un9PUQmNiCyyFDaba
	dJb66qMsLrpMqVBKRqibHSucfgUHoak=
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
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v1 07/26] mm: memcontrol: prevent memory cgroup release in get_mem_cgroup_from_folio()
Date: Tue, 28 Oct 2025 21:58:20 +0800
Message-ID: <9eca65dec044d4352bee84511fb58960a1402ddf.1761658310.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1761658310.git.zhengqi.arch@bytedance.com>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: ECA9C1C000F
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: ffzi8t96ntpsczxytri5hewof1781eye
X-HE-Tag: 1761660177-436304
X-HE-Meta: U2FsdGVkX18WkC+gTKAvxagNikjQIi1RezkralcH/bYvExwhZUo+s1wBUsLTqjjtoj0bKhRzUAHpSApOabsKPaaJMdgrZdnu6E+2lBHwZt43y7u2APNfd4JK8eUD5DZbHSGQiy/tAvxFprtYTxTD4Yc11gsO37WVz43WLc5Ddq4FlK5/knWqSopYJubFUwrAhUTs57Kz4UdIiuyU6kxCBMz7+XPuGhJgJW5+UvDTVDB27SDPgU5iMG7fzALirTIC0BoOIQExuV74vLGOiaToO2TJpSGhk73cqzZzlNfCxqTKBQ0K/8wPkFvNLQ8gwCTzLmq6Hyoy0YA8zNsf+U71q1EoELuPZKiSQuPrl52CFAQbzzdAuZUwM1LVJPBuRqXjgYDXMHRogz8nfgxNQZ6B9al/6h1Ri7Yi6ma0AGM29TP+6ymri4tW3Z8iMqL8q5WuiLgzaAsl7iRtERUdXH6oDMVhvNvYRvkmvmIoal8ns2FvbqP5NyJVoeMZEv3uDpM2FmnfXZHKmCbHW76HN7oafehrzR3m+s1VhjirpD5Vbv/ZeLlkxdvxY7ziJO2JJ6thev3yVBS2KjdpPORuDg3edG2fdjSHbdUY9zotzIRHy2XUhltv+KP9Wx8pFj/tWrnBNYoLFE/krdCnN0KPZKe0FL1AXagh+EwzVQMyqs+tpE9MR4mdC8afr8mA8q11Bilj3jmGzJ8y8xD1HjapKxV/zC0cMsNr1um6rMlTtYjNQTyCOgMIJ38PQdRv7z1FwNafohhlFvALU9S68xxnZA7Fx7/kLlIwKfVQwICzj1NgKA3SAAhOi+JJEOX6KEYYi9KGHtvHStfRvLC/DbVgJoE6r6RmMOvZjECh41zfYanwolUEKh3WQ9gxn197BydYgoU+Sad7GHH4MVE7/b9vxO82PDMhFlRaTmRLqGEc7peQYnrL6t0RxeUFT6QJHM3DYcA4RBg8ou/5xFtdDTJFbje
 jJLElEuO
 9mQb6ytxY4TFLh6em2LKQueENgX3kAbOsjas3oUG7tWSh+b9QR2KBiwVRE8REBc8HpF1lPTnKVfl20tgdefsYXz0D68thdHmfn49T8uiQXHhxPxay2NtQZlGK3O/k9dcUet9tjqqSuNbqcAS7Lsdbvuhe94wqPaZZraSsSK6LFk/NiLX27/d+BieClhhpuFSd3qWhzx2x/L4OaoKXA6JQObDq0cMOfrCMWg7iIz37IKTCXI3HOx8oJ+E1TJ+n5sF+7yFBAlYfbZUV0lw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. To ensure safety, it will only be appropriate to
hold the rcu read lock or acquire a reference to the memory cgroup
returned by folio_memcg(), thereby preventing it from being released.

In the current patch, the rcu read lock is employed to safeguard
against the release of the memory cgroup in get_mem_cgroup_from_folio().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
---
 mm/memcontrol.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d484b632c790f..1da3ad77054d3 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -973,14 +973,19 @@ struct mem_cgroup *get_mem_cgroup_from_current(void)
  */
 struct mem_cgroup *get_mem_cgroup_from_folio(struct folio *folio)
 {
-	struct mem_cgroup *memcg = folio_memcg(folio);
+	struct mem_cgroup *memcg;
 
 	if (mem_cgroup_disabled())
 		return NULL;
 
+	if (!folio_memcg_charged(folio))
+		return root_mem_cgroup;
+
 	rcu_read_lock();
-	if (!memcg || WARN_ON_ONCE(!css_tryget(&memcg->css)))
-		memcg = root_mem_cgroup;
+retry:
+	memcg = folio_memcg(folio);
+	if (unlikely(!css_tryget(&memcg->css)))
+		goto retry;
 	rcu_read_unlock();
 	return memcg;
 }
-- 
2.20.1


