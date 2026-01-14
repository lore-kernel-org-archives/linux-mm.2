Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9EDD2D29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:33:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F1B6B0005; Wed, 14 Jan 2026 06:33:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 109D36B008C; Wed, 14 Jan 2026 06:33:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0367B6B0098; Wed, 14 Jan 2026 06:33:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7D026B0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:33:36 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A02EE16048B
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:36 +0000 (UTC)
X-FDA: 84330359232.23.E7DCF77
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf23.hostedemail.com (Postfix) with ESMTP id F0A39140008
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:33:34 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TX8Icxa+;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z0u4X3qGXgYyNfrzLzU8BizQ+vhvSMeoi5s8ySDp/8o=;
	b=cb6dxOq3rDeTxiuemb3di4RLUDe8xAiP6+o9mHtEK6gZ7EQRGnc7dsLfJf0kkg76sxKU5b
	LVissTFU0TJQqllwkN/ojiAQnaLdDiDcSg1kLCJi3h+pxbcQUzTJtgVhW9lTRSa+mkMs2A
	pNvjfGAMBv5NkGgzEI+kSNjkZpculnk=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TX8Icxa+;
	spf=pass (imf23.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390415; a=rsa-sha256;
	cv=none;
	b=3JN69nTZcI+cXR02oDq6mf+AAu4OnhJvoxZBV2bUMMIR1EAYbLK/FGOABrhBlOD4UPAg/J
	MQewk6Q9NYz8pmje+vaSRsBmpHSoDRbANakorGCyvIT4sTecVCGFWt6e5ZDKRVeoMaaxqw
	VBGqhQF+EJJHPUTxtACyTdrvrgmTK9Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768390413;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=z0u4X3qGXgYyNfrzLzU8BizQ+vhvSMeoi5s8ySDp/8o=;
	b=TX8Icxa+t2EkkcRi83IFQ8R6pl/W+UhkWFBXoVd1Dsg/nqdLJYjDYwyhRKgqEWNOus5Yfc
	fW7eycNk+hpN1U1c6b072Th87Ktddj7tFWw/zl+2Js7e7kZbCF/+TewKc6G6BIDxw7vBQQ
	b4dGx0hg50Z+71J/vWRLOSrf67y6a6w=
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
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v3 09/30] buffer: prevent memory cgroup release in folio_alloc_buffers()
Date: Wed, 14 Jan 2026 19:32:36 +0800
Message-ID: <094fe768fc694c2b09e6263e92d6278c12238759.1768389889.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1768389889.git.zhengqi.arch@bytedance.com>
References: <cover.1768389889.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F0A39140008
X-Stat-Signature: qu5qhb4crjzqrbspzex67jo9396hp4td
X-HE-Tag: 1768390414-67947
X-HE-Meta: U2FsdGVkX1/WsQz4JUiiTiZGFzSopa7/FDDr+mk6V1N6p0PqDO2/YbXxeTU5vv3JXy59Q8UKWSmvd6QQivnPLnMLo8LHT+0w0HuutC2THVBymzD4Zvwao9ml0/cfhCqNNOEQwYsgvzeaBW5wLChnzsnTW7GKWgCk8WoevFyUGzS+WDcert0jKOU7Yxs6Sq07G7ZCXMb4HYE03lol7AUNrIn8KTwHGSAkefc1lVFKP6m2UtLQneoy5xRN7UDE3msjqU0iLJSkHG7jVpx00yhq8YA0KWExkl0dd6vCzNXjJaHhxUybXZEuJgD1KJBMXUdFTnTjY3krsksXT/0fKHFASSK9hQ7gQSuPmG/GNBZN4NzBLx7qrn4xEeK6wpA0psNThJdHgQtr4P3iKHNuWCVFK49TMv6phX5cMzkMzj2wie3hG0z/DJ5SX2RZCTaOHA/cKiN7MEnrJwjUl/lExuRqDf3IYQz5rHvPLzpvG1k2ZBB6rBT8gFCCL+J6EhVcHmYqfV2q0MqUdgl8zRSjoaLwCLBSP1PvDOFeBn5csMsnJ9FHbSjD0VEa6EG2hHWzEsSFUvmBPmQM6Gpy6n0Y7BnNx2jfVZEuDQAmEegf7LK2UUGZeWbjlDyajdWS6xmkUtSg7KSOLuILeaieazfxhrIpgeO9gb+j2smA5Lm8oB059SztnVPAoJoXKWBT4xMKC6UrU9MWLBwL8koOMURVdCECKoD5WXMqzjt6m6wAZGdxPDgU/m3OmfxIFWzgjXNdATOY5zCDp7suS4SdV5YxCH3DwkyFBP7LuMJaR/JvXFM0lH93hhi2ZTk0nIrJglD9NySFXv43vvvFqy1c3Jpj2vTk7S3lZd5FJPBafBQ6FfERhabi9252yTfO+O4f8wdcYf1k7TuXVolgnuLYYIIbdPbZVzuwTLQYv0zkI7D1J2GfR37u1n3roywUtzGsJ6KRObZg/4MqPNt4au8lFNwrflP
 0A45jobe
 QRnP+7FOp7SZPAMc4S5LLzlySI+vaAjcfSXd2JvNfzfpTCbgtPTtLUM0vd+FfALraexCeYp4TagF8RxrcISVFKcmTdnHAZWBJejhdEWz/v2zEmljeF45o4P+jTkDQBaBUXNzTwDdm1c26UBtPeiDBJ9GyBGMG9jGJaIVcC1lJTSA5Y4n6y5Tysa9hse68ANAf3gDg3HbJNaSLBi+cf+totNy8ZXQomIt4w8oOlQeFrTZPzNabGKXsk/qqI+DYPh8XarRpGYv6qov5HUmkLPM1HydKupiYkVSEKE1czNXVGPL3itIirCKmt//VVyARZhHbGRFa
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

In the current patch, the function get_mem_cgroup_from_folio() is
employed to safeguard against the release of the memory cgroup.
This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
---
 fs/buffer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/buffer.c b/fs/buffer.c
index b67791690ed33..d80b635cff162 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -926,8 +926,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	long offset;
 	struct mem_cgroup *memcg, *old_memcg;
 
-	/* The folio lock pins the memcg */
-	memcg = folio_memcg(folio);
+	memcg = get_mem_cgroup_from_folio(folio);
 	old_memcg = set_active_memcg(memcg);
 
 	head = NULL;
@@ -948,6 +947,7 @@ struct buffer_head *folio_alloc_buffers(struct folio *folio, unsigned long size,
 	}
 out:
 	set_active_memcg(old_memcg);
+	mem_cgroup_put(memcg);
 	return head;
 /*
  * In case anything failed, we just free everything we got.
-- 
2.20.1


