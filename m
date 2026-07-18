Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37798C4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 09:53:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1EE96B0099; Sat, 18 Jul 2026 05:53:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF6696B009D; Sat, 18 Jul 2026 05:53:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B33EE6B009F; Sat, 18 Jul 2026 05:53:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 87EE36B0099
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:53:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 08792A09DB
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:53:57 +0000 (UTC)
X-FDA: 85001436114.28.11390EC
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf08.hostedemail.com (Postfix) with ESMTP id 45EB8160004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 09:53:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OcCr8E5O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784368435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=TU7mrx5DtF0KFJ2y4d8E6VS3OLaCQseBFQLZUn6IewI=;
	b=XK/DwCd3G9aw+G+bVWMZqTUITj6YPLsl8ZQpzxRiolGfXRLmvLacirjniykSngKjDQ/YlZ
	6Fb18jq4+6wchpVfnG4l82LUgHhrQOVo0262ZMvcG9qgde94A8TSVv0AyQI6bMeS7WSIqK
	2Qk4Wgem4Fe09EKFpXKfjUCSmp7Pw0s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OcCr8E5O;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf08.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784368435;
	b=lVs/gX/HBWaG29wF8Cqjq5JWayPFxZlMxvDYSypkQgwlksZ+GBSh0HBhHhNgjHtT7ZzCxA
	C/cP5zl9dkp//st0VktfCjtRD/+6Y1KQLq7wGaqbN7EPMyxqZX6ZlXsJMD8qYKm+JyXpUJ
	YoeasMs7dobYVbuHeJkT18O81je6FiE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784368433;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=TU7mrx5DtF0KFJ2y4d8E6VS3OLaCQseBFQLZUn6IewI=;
	b=OcCr8E5O5Yj8NyB0vF7HPdl5tzPHgqk5VXyRrYP8LqqmyeAe0N2gQa7TTbgAAhyRFaMAn2
	DkeqaV6cX6k34yet3dyMtXYOyVq93vqp1k/ivAlKbb5FhfKttPKA3A/gFsLWNEkVeFwL6t
	ErCkBHzOXkl8nyr8gQxJN6F7mtMqZ0w=
From: Ridong Chen <ridong.chen@linux.dev>
To: akpm@linux-foundation.org
Cc: hannes@cmpxchg.org,
	david@kernel.org,
	mhocko@kernel.org,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	ljs@kernel.org,
	kasong@tencent.com,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hezhongkun.hzk@bytedance.com,
	muchun.song@linux.dev,
	dave@stgolabs.net,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	ridong.chen@linux.dev,
	Ridong Chen <chenridong@xiaomi.com>
Subject: [PATCH v2 0/4] mm/vmscan: fix swappiness=max and clean up per-node proactive reclaim
Date: Sat, 18 Jul 2026 17:52:47 +0800
Message-ID: <20260718095251.82937-1-ridong.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 45EB8160004
X-Stat-Signature: x1fkd4kb5uqedfw6htrhqo38zyg9uik4
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784368435-68583
X-HE-Meta: U2FsdGVkX1/e95Ngjlq8T7OJpRtWpFddmYudAgNZQytaegReh2YykPF5niFyOUO76pk+07xrML4pLfho/F09ZoWZRpI214AtYSaWo/8YczOE20uLr8IHzeqbV5+5lMWUdK9E/QMO3MmW5yss3/mngmY0MgrIy84e46rUa7zdhR0gtoTm6v6EwiR/hPgEKL7n6hUsdRJwOFGwZ7cbJDa5kBjXGLnUC3ALKSOmJ8jXmguggaVRu1RkNV73VLcxckUCOxq4nB9SP7Ev6xWW4VeTmqDMLgOO8yDgQQYywsTMZjZkeAyWsp3T9CQGa3OK1Bx/YCFeFUZCWBu3PjdAO5IZebylM8Ae3fWRCjA5uUS4o42pLbQLOvzjb+tq3pa0+LU4EbusAGhVWykbM/G3DNQnH0R3CnkhYLKcmhHt0QyKkKusS95JpsY/zKyUDZHRnC7Rkft4BmfXld0tV7jB1YGfidqV1lzQluxdV/QPePHBhlTlCEyMuGwN0M/DHWOvkIlhbLN8DcdAPma1Ji36vpv4D37M/Gr2YcUpphnLpp6ooVpvEjkkVrIqh66y81UbNmb8YX6j6NI3Z8xsW5RzkscU94BVN1fHFruZUXhZf4aP9LyE2AihZcjNJGmc0kBFWEa3FPvNCL+77X+KWANlKnWemzdQ1jTTl206yXnln4w5sm3lUvf+FDF660o4l8eHJvz8BCE8AkTfAGVQQ8XaJP7AwErQmBHubSkTrq929yk6HKUKT7+51Ts6qQgb+56u8Je1PEwQf428ndcSwVX0YqdlQjz2xCWNqnpStiXCXjqbtG1cvzt4GgJ+yvl5m6nHtTQ6bVC5fPsZHX71mTFGbGLPEMfvfjlIFo5q3G8Is+89l3ANcYv9LfOmOHcxwSRxFVaNPyL2EMhLajGa+p1HQSoMjM7BfcSXSt+l+tw1KRPnwIAz5C9BY3HQPsmdhz6i9e0p1Q7K6VaLAR4HgFJxE3t
 zoKr2QKV
 XISe5IwPBapblUa8DigEuzGngEWtzYf90TG++ZcEpJSXni92NBMb6v4EcxXZIuw1JiBh3RLdFNZvzttXAVj3M0ggD6fQZgiR2Pxu0E17LvnJhutrPoOCz+c5eUAwfEdgNyOw1OxDFJdLYRrDvwBdyJKF7cHuXlrVQZw0ATjq4EAIjBZIvlypWsfHSPZZLNoEfCoQshAkyXUruQVxK1LFPsudt9XpUwt98PlRi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ridong Chen <chenridong@xiaomi.com>

Fixes and one cleanup.

Patch 1 fixes "swappiness=max": the anon-only test in get_scan_count()
sat after the "cannot reclaim anon" check, so when no anon was
reclaimable the request fell back to SCAN_FILE and evicted page cache
instead.

Patch 2 fixes reclaim_store() collapsing every error into -EAGAIN, so
callers can no longer tell an invalid argument from a busy interface;
propagate the real error code, matching the memcg path.

Patch 3 drops the now-unused gfp_mask parameter from __node_reclaim().

Patch 4 fixes the same "swappiness=max" issue for MGLRU.

---

Changes since v1:
- Collected review tags for patches 1-3
- Added patch 4 to fix the same issue in the MGLRU path.

Ridong Chen (4):
  mm/vmscan: fix anon-only reclaim evicting file pages when
    swappiness=max
  mm: vmscan: propagate real error code from per-node proactive reclaim
  mm: vmscan: drop unused gfp_mask parameter from __node_reclaim()
  mm/mglru: fix anon-only reclaim evicting file pages when
    swappiness=max

 mm/vmscan.c | 43 +++++++++++++++++++++++++++++--------------
 1 file changed, 29 insertions(+), 14 deletions(-)

-- 
2.43.0


