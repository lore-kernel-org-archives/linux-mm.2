Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8BBC3F8A14D
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 10:26:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3FF86B0005; Thu, 16 Apr 2026 06:26:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF1CE6B0089; Thu, 16 Apr 2026 06:26:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE0136B008A; Thu, 16 Apr 2026 06:26:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A8D1B6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 06:26:18 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 2BD8B1B8995
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:26:18 +0000 (UTC)
X-FDA: 84664039236.22.8E9A527
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf14.hostedemail.com (Postfix) with ESMTP id 674F510000C
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 10:26:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lh6wVoP2;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776335176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=svqYsveO0zDGB0jjimFV830rt4ZkKBxhk+Yt9m+T9fk=;
	b=fDOWzlpqEvL7EtWeO93tfMOg6gdkIk/yNHeLwbERNdsgNK4/sDSqrTv0EpHFQZ8kbr7l5p
	WOIfPER5hXnm6P5+STBaMvFwHvZMmUsMWdANTEzltX9jjJ/LoMhzqMaTWpwAkVR59aVlXS
	CZQJw9KFg9lDJ8KYsUm7g0bittIFm90=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776335176; a=rsa-sha256;
	cv=none;
	b=iEt+8UU3gKlGrP9Sv4w3SXa4OpURiKM0l819142Pf07sDqEmMSBbrhNSnLc92Chy0SZifo
	ucyOXGxTMYnw0Pt9P4P7pACA71KeSBb3/fwuichULwHLvamKlkBXH8jt5K91mIpMHgvuGk
	jwfWTA4hijRCy+pEIFcSy9PQESq3A8w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Lh6wVoP2;
	spf=pass (imf14.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ab46931cf1so3803535ad.0
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:26:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776335175; x=1776939975; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=svqYsveO0zDGB0jjimFV830rt4ZkKBxhk+Yt9m+T9fk=;
        b=Lh6wVoP2APllFzdWax/9oVa83O5agf/5IHrpONLwXR6qbBpZt2VZRSky18J7GbxAX6
         +hFV88r4UI0dTQwFy9YIoOYWLpQ/p/blopjBMQvVDLzCJg5lpTC2ZYSHvcLb9QxiSOg8
         vvQ8apgSF+kU4YYi8PueoeQHpTMfVmhNRdBsJmWD79puOkQbbAjwCTRiWjOatWQMTmQi
         mL19jwE5IvGZkeDy8+qRCPFR0Ffg5OcFN+RdgGUD8PCjTdpdQ/5oSahXt2I9HtBVDay7
         9XWW0SGRComuGjSBiYo1ZlYc3G/MulALAYPoR0vW1k8t3Ed9U2BzreZyrBFYaz+hW0mv
         dnHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776335175; x=1776939975;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=svqYsveO0zDGB0jjimFV830rt4ZkKBxhk+Yt9m+T9fk=;
        b=E7QIbQ33EWfklz+og6n20okBmJ5VH8ARjoJgghAJqpvJ0QTj1drgtFjJhwF16ayJW7
         /sRQ0T7tzv7rXjcBQ1nlJVqsnKgpMf5XgS3wEuLelteTWRmSvKYK4B+w9lnXrfYd6lwt
         02d5T9sscquhvtG7L0DgM0FSeDvVk3JDOZ8SSuc0bhtOPYNjTbTE2fUUNk+HN82DiHGk
         gcxwkWvfcZQXSimr15Awc792dLagNtdERArn1CFKekW7z/xKf63VFA+T0hQaexOj/c89
         NpFTm6X8iqQQaIXQprRNjFIA+h99VIFJWtIgBzDGvLzLc7C3DLACaGTDu1cgv/p2omS0
         bHZA==
X-Gm-Message-State: AOJu0Yx1i068ZUp3TUUHhVL2HNfhNzrgxodWLEAoRrEb6TBlklS5k6sd
	n9SJKug78lRZ8lXHowO+tZlO3s7mokNvfKmnpEwSaZ2a/EzDpE4obi+K
X-Gm-Gg: AeBDiev8HCip869SZXfu2DNQUvG0caBon369HPUWmYK2jmOOPuHix55voGkhP/Gcl2G
	XyRP7p4caLcO98iEQwBQTlAfzVPWs2h5k9ORXgfN/l+AaSNnIPwtmgd7E0IPbqPIIzpsU+IbkMc
	WWGe4i/CB7dzlIuDZYv9F/t5JranqrAA/T2TGAAfcFUP9h8p82xpkuZNTYPV6/569tSKXtBywBz
	qN2Ze2psGYrzNXTRwKort4PyMv35/ucg1IEPafy9+qD0WUx2sFOB362uVtBBoO4kobQomKmhbw+
	YAzQQvhDc2PNwL39/KXsIaOk5jZuOXdEP3ZL7OIfs3sFq3T5lIJweHCYxWgzLt2YYHt8z+mdS9V
	9CVI4alM7lMlsUVbyBdiJwBGqFaBzjBdAW6E9SVS6SuixPQzdAIyOoOH4z9hjynH4OjOv35o3Nc
	4+8Yvbidi0i0p+ZldvsX4mHmG445ws
X-Received: by 2002:a17:903:2c05:b0:2b0:aebe:259 with SMTP id d9443c01a7336-2b5f028e1a1mr11115575ad.19.1776335175055;
        Thu, 16 Apr 2026 03:26:15 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b4780ef365sm47955245ad.1.2026.04.16.03.26.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2026 03:26:14 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: akpm@linux-foundation.org,
	rppt@kernel.org,
	djbw@kernel.org,
	mingo@kernel.org
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: [RFC PATCH v2] mm/fake-numa: fix under-allocation detection in uniform split
Date: Thu, 16 Apr 2026 19:25:58 +0900
Message-ID: <20260416102558.575210-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 674F510000C
X-Rspamd-Server: rspam07
X-Stat-Signature: ba9m59zupccfd6tq6ncobo5ey1wuz6bi
X-Rspam-User: 
X-HE-Tag: 1776335176-456300
X-HE-Meta: U2FsdGVkX1+gYJ0cK5IB8FF1vEB9+MMBNFWXtIepS67mqSAXfNOdzoai9uBWzWMasHAH1cBVmy8Zu+Ws7ufV/2KPW7h+xUDqPT2HKlGwE2gtIvi+5HI0WLWF/6vL1yHnSn+zlvWGvrOTPO3NWmkTqKt5SGHwa3nCIy3SBP8DIGeceThSrRD385sey3eqSNQDzahaLop3/G6Dc4YkRbb+6/8tvyETCEftmPedxyMqhjgePKZXRCGbUrfgLoeQ0Zv1BY8WoqVmDotrtt+6CxyvMdLA+T+3nNinerArBEp0mmdnaeLIgkj2CWcQ5wndJSUetEevxsFzF/6xEoI3AbKLnBf0PSj7IsLv4pOxhT55jLe66Z8fcXKiBYvTJT9oe7MlGHm9loQni4l5rJUx+UEtBbkn8Ak1hcr5JjVNlfKFkWLa0DlncN8YnCMCvHt9qJ2L6NwFP+CTIWtJFwJ/kMo6ENXoD9z9hvbO+pTnPJsUkFOWe339Bxa7ANlHAtMl55VBaKTGB0s2hVG2j+qpgXbvUfIGN+NlZE66VR50EhiyBlAcA5ncJnIln9Z3YtgbGGZ24SJ7IeefNGMw9En0BEU6jrwgID+m9HisidCAhRU7OpMjRBzcF6HG17R5SNBIU4lvF1tFS8VOG2D+qC2X7hCbXV1HtTLRUOCKjUVAhbptGPjsRP2wjYFB9C1MEh9+izQhLq5Jd5sFt8yQTuFhYEAtbzYLiV8M+r5XIBB9DPwZbgfwUIinHg6IQFfCOtBh3bUdEKXMSpOqV5fjz6Lf/mOEok+ZJ1xf37+XKOo6e39PU+gJ8+b/FN6s5ebp8fLkBlJ2IV+aFUwOAEWx5eZDSm5eM3mFGhyApfnn26vc90aOfoaJDKu2VLJCz6quVO3hPkl3xwvwqkDQPXIXeELPU3L4qOBfrEoO6vZmLlrTWcB41fNtJOTjjZw3oBxVu14kzMxb/uwAS3TzN5aJa7kIBST
 /JMB/zWu
 sFj84SDEnU4jrrMtkzexWWMB1gMq5FZjdih28Vf1IQK6v9ASrvHReGb7YTOSong1c+Z8egWq07pk5ssXDnApFGQMoUKfYtVyu1Q7RZh82rOpAUwm3ybsrL1N12Y9f6eV+npxC3CdqcX0LDBvihDPuwXbCqxMMX9zVv4m30rP3XyeIhI+xhh/hAtYLMO9kBF8LjCFfr2RGhhy9Pt9VudXTg2uMc898JTnh3UBQ+ppttdtXb8nGPeSiTCJazE4FUZZwN+uRTq3lV+9pcvnwA26/gyPIxrBzcnotfn5EXzIiKfK1hpDLGySbZibwBQS9Z+/iy1GJSPgPWxlk/6lihHlE36O6qTIEOoBeWsEAMLQzD6IwRTQSDfbTnnXUxEhvui3Bi1zIDvkbAXyim5KmvyDuBlqsoGgkZS6iWms2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When split NUMA node uniformly, split_nodes_size_interleave_uniform()
returns the next absolute node ID, not the number of nodes created.

The existing under-allocation detection logic compares next absolute node
ID (ret) and request count (n), which only works when nid starts at 0.

For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
fake node nid starts at 8, but only 4 fake nodes are created due to
current FAKE_NODE_MIN_SIZE being 32MB, and
split_nodes_size_interleave_uniform() returns 12. By existing
under-allocation detection logic, "ret < n" (12 < 8) is false, so the
under-allocation will not be detected.

Fix under-allocation detection logic to compare the number of actually
created nodes (ret - nid) against the request count (n).

Also, fix the outdated comment to match the actual return value.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reported-by: Donghyeon Lee <asd142513@gmail.com>
Reported-by: Munhui Chae <mochae@student.42seoul.kr>
Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19
---
 mm/numa_emulation.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/numa_emulation.c b/mm/numa_emulation.c
index 703c8fa05048..c1d0a76aef64 100644
--- a/mm/numa_emulation.c
+++ b/mm/numa_emulation.c
@@ -214,7 +214,7 @@ static u64 uniform_size(u64 max_addr, u64 base, u64 hole, int nr_nodes)
  * Sets up fake nodes of `size' interleaved over physical nodes ranging from
  * `addr' to `max_addr'.
  *
- * Returns zero on success or negative on error.
+ * Returns absolute node ID on success or negative on error.
  */
 static int __init split_nodes_size_interleave_uniform(struct numa_meminfo *ei,
 					      struct numa_meminfo *pi,
@@ -416,7 +416,7 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
 					n, &pi.blk[0], nid);
 			if (ret < 0)
 				break;
-			if (ret < n) {
+			if (ret - nid < n) {
 				pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
 						__func__, i, ret, n);
 				ret = -1;
-- 
2.43.0


