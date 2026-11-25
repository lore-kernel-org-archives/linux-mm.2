Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37286606A681
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=znu4Qbd+
Received: by kanga.kvack.org (Postfix)
	id 343D36B0ABC; Wed, 25 Nov 2026 16:27:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31AA76B0ABD; Wed, 25 Nov 2026 16:27:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2311C6B0ABE; Wed, 25 Nov 2026 16:27:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F35B26B0ABC
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:27:34 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6CBF7140126
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:27:34 +0000 (UTC)
X-FDA: 85474928028.03.FE0FBC8
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	by imf30.hostedemail.com (Postfix) with ESMTP id BBAC080008
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:27:32 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=znu4Qbd+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642052;
	b=UkIZdzNrTZ2gVZbXtAsTDTqBRgtq8nRf9J9Uu+midN1VlojW6VPyBok03tv4hkYIoetV3w
	i/bsBz5QZ2ScxC3Sfftb4NXKbJdQZ9lqZf6eraL040rkLRUc+xMSSaPvXuaNd7XvS6q57G
	xYVRoMnEEU3AOTM8h7QUU898Kl1z2wU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=28q8FBnALdQedCtV2p6X4g9SI7ggHDelqgXm1Uk3okQ=;
	b=LX9amZbjPr8UjhGrG7R1jBFK3G8J1uGoF3a47or4hLuC7cUF58DRX2qikR7zxaQni3ISHw
	g6jCm+s3sZ/0go5pQNwM4+1/HZjEDVha4sz10zBnDML+5FxyMtXiqSEQVdpyLQCP6bT4kn
	6B1b6gAL0Lh0ivjuSgEU+AgHz7JEGs4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=znu4Qbd+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.167.171 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-53dbe9b8d6eso4527806b6e.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:27:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795642052; x=1796246852; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=28q8FBnALdQedCtV2p6X4g9SI7ggHDelqgXm1Uk3okQ=;
        b=znu4Qbd++8/nGxXJWnJY7eyTP3TtC4tFnLHGjwLvhQONEZNqAnhWpZaVapnV/5y4G/
         mqk2JnlF9YRYpzdNjpcwXu/wFAkYCGdK6g+DbkMlfyVQYeudEOD+fgnhJmZ2jCpN+/DA
         OGpUpcHboK7KUgxLgggn6OubYsyYP0S+aaPBuAQMu170fqSl7fz5oxunITYYdI0Os1EM
         /y2axPWRwut21hj6q4hRf6p2rwRPs1JYUxZPS8H/Qt+kO5Hzj5xZVHP9hsbtOFuEH85Y
         U2IQUuL8TsAHPaEjIpQGvv+8nH1tzgvSeoN9oGy8XDhvZ0IMii4p5ksrTaXBHvrJf4jv
         BW+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795642052; x=1796246852;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=28q8FBnALdQedCtV2p6X4g9SI7ggHDelqgXm1Uk3okQ=;
        b=pXt9Kk9fv6kSitntyoxnjXOnjJOdI7jtSHqyOMsEKywZmlFKiVdBNCdu9QMmOSb+cV
         +ouoE+hnU2C5ElVtb+YnvlhnpWgbZ7mwtwz5fmhyHLh9sAdNYFw5Np5Y/LJjlJPyu5G8
         5zrgPYLeZFCES9goHisb66LwKVCQpFnC04npPdGfPY9BGTqj/gETkWM8tX4y6MEiNKsT
         8kfOrjCQbPY27c3wPArCUjjl6FQOzDv8E9+kdXRhciTUkslJfhdX8Jl9sN3fgFt+p0jR
         lHBDi8ADO1W7/dm9rmZQ+Yo6rJTRwQwsZpM9jkrbzxlNzmzDE/KzKRlFFvIM2nt6qOJm
         9omA==
X-Forwarded-Encrypted: i=1; AL+hErHqYSr8zP1YgyG2urU6UaIpO5Pv/8IYQ+vqSOR3xJC6WSgLpG/dNutlZeL7kdtFngQAJ3nbL1MPmQ==@kvack.org
X-Gm-Message-State: APuU4Z+fB21ajvmboDaPVzV9hJrCEmPMweAZCHm3rf9LQTv4KFC3oUrm
	ZLjDy9N87F01bp2xkYkERcHnmp95wn2mvzaOrVR67xg60CR6596XWJ7L
X-Gm-Gg: AZFdTZdS6qShV8ryNGav1vY0xSoOXzrkaX4l172MhQqb5v0GOdf5fXzvYo7g06kmzNv
	deUVO9aNwpqstSU3HMAfFHMzCS7BrCq1Jog9DX/tmNqP/UP2cIgRVL1fTyTqvb063fYWrgE/42r
	6XPZThfbKQmQw2O9VTA/8mE4MyhLeCV8nr3nXg1dQ1uUz7bA1yyJmqpBK5PUuMAPluY0mfs7s/C
	KJilfKlRcGqspI2DJsRluIZfqSuWNaYHPNQumafEc8t8Kr/2b/ickSeAA+qG8wamLqOLC37q6qs
	+KF7u4waeDUOB8Mdh1Lm3/yXsLzu/vkY73sUc3vd6Tt1X/4xJmJKop9is4Ovfo3LP4LWUGUK+1n
	0U0GkcAgQuWEsZrTvVyP/VpKzH/GLqImSj/FYym1R/CzfQaGGBbv/TzNDix88J/6zzO0cR4tI1+
	0+uNBhgQpbmgqaONOvA8t4Y7S8oXQnm5vhJUawXDF3eZi/JMmFWmcHRCBSaeYCnfVeU90NzUbjQ
	cPNxBd9qub9cAYoXgV273IqBRBDqQe9k5T01y6RYTu2xAkVfSm7x+HJ9h9jcV8A3PodJMfwpBsf
	yW4gvQNpyRIz5bY276meqpb3xnBGVtS+tKG9cAJYNimiomSHaHELhxkqosY=
X-Received: by 2002:a05:6808:6d93:b0:4b8:46e3:e221 with SMTP id 5614622812f47-57a09c1de59mr13142873b6e.13.1795642051631;
        Wed, 25 Nov 2026 13:27:31 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:7::])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-57a350548ffsm13685530b6e.11.2026.11.25.13.27.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Nov 2026 13:27:31 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	kernel-team@meta.com
Subject: [PATCH 0/3] mm/page_alloc: drop the pcp lock before re-enabling IRQs
Date: Wed, 25 Nov 2026 13:27:24 -0800
Message-ID: <20261125212730.1128631-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: jarco9ssfg9sp18b5u45pzkx9e7hmtdx
X-Rspamd-Queue-Id: BBAC080008
X-Rspam-User:
X-Rspamd-Server: rspam03
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795642052-774006
X-HE-Meta: U2FsdGVkX1/MsAUqoLgq7ntQ/4STL4gvkHrqwn6DL+/OLgHcjuirjb6khHD9/ADJQgGvnCSKZ4kD7zF/BcSNjnGyWPq06d0efTYdAGunIx0x7+aDOIRCdSSiZ9nOInLi4syctC4kntUnm5TwzzOvxQWEgPDEXDtYf8CMXGm03wfx39vgKVwwyyLH1zMDV1d8MnhP0D0rD+/vMvHb/6uApDW0PQsO+9uzrdD7HT9DGaVBtlnDOuP8i8wAR4kzPMdNj5lrMyQUEIrMfcouCi/NLV4wCWJUfHJA1GxH7N6IAH+af86toNfKf9quO/hXE8Qkf3hu99rQpxTt2srqMX1hLfvF2DFKW4J75vmCfjqA4BbjNtZGHdcJFXlGQPdHQEjf2WPtNj5v/ulzxYczK+BhiFW68qx5mhCp+dP2gO09sBMVq2pEzRUu9FyYLIBzhla+ZjJh7VGMkL4qOj7xOlBVEU+Glf5ejm0tZk2XANHlRgzg5Nes3K6PLUwlXO+3rNKWrubY7Sa9f6llxiwFNxrYnBKaarCOW289CnnQPMt6NG5/XCO1iGjJPLLJ+29WKVl886g/N04OZAazWJz1KNe9AboOO8h/03NGQQDoVSqbRsxAhggg6gZunETgVYGhO083LpSMztcyz9erVxvcIRYWowdsfQpurTUlgLjOgaIAPWMM7JMq+jbULO4vgNgaC0kAJzTudKAVdp1QmbpbdH6slfS1vdhp6ft5ZoFqhwDbqLUpPJK5LRgZro35xwIgFCYfZLQCQgZp+AhxkA+ZKRGLhl53ZKQVKLnLc6QtDsZDVRaGR/tUIYVdxmGIcQuffZiA+M1M6RoH01vgaIszPVxtsGBJ//rvN7c6uZgUEbQWJmDst3t2G7M7Trt2J03poLFeabXS1n5sMTgqMio7/tIh+G52063/undT41npCm4v57XaVvZc2T3bd0h4Cb1yuv88BtwEUVtq+iThYUsCVBl
 IKy5ND/i
 6pQadZthc7mYVIPWXQeFjm7IdVolaouY80q6Avq4+G+wEu7ohoSBIwkbqq5zdbwhK9J0Dh6/aPqSDd/ON+4sKA8BwKNs3Mouxg6QyaeVLaqmU+EZAMIAC8s3/oF4jxndpUgXV9+VJ26kFI2uAlJl2vN/q0F4bXfWTxci3c4azv3F1uoVyXTQxa8TTFFm7/Rquohn/47Gv5l4w9GfL8ro95IvKFJj0yZjg3QN6rg5+V6dE4AGBCIhZW1CREehXZ8PrISTZL+L5BGMw5JMcn+QdMTM8f8ZV1U5w3VSVrqeHbfDtnSp8+K1DyEocFH8nEw/GD8vVlYcbJHHTxu6CovuuUvD4/FK/TzYa9AXPz/iWMQhNjXGbhYWNH9jS51y267qIhLSZ/bkV3vDJonWkep38mgksFfQldPQllI8qQ1vbpW4vj50uEfM+FYzpP9v1wduDXUqc6VaWPyJEWij1h6dQ7QHSLIAEb9UtmlFCwtxNzdpDGQpKCx0DXFr/Xn6fgpbCOVkwt+geCPzwRbWJeO3AWvF2AVCoA8HvGomoeszPC3ZAI/YudjbVO89sHiK33NE0003HTlbwtXkjFQ/hVZOjdr2nb6oetJrTVk1fHX5x5jk2blpMA7xYHSR0IQiMkkT8gh6rGuHDskaD9FhzzTUhNf7XvXzR5WBVEG+1ZmJVzlMeMhbLWUiPQKEwHrJU5F/vsW1ES5LxzjJvjwO6oaMnUhDIoeNQ/KIh5u5S1JFIYa17FJi/3rtRK8WHnEMro4i2fcMee5CHlCQ6ohxt9tKbzjA/g8O/x6bi1Y0G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When the zone lock needs to be acquired from within the pcp lock
(due to refills or drains), IRQs are disabled to prevent deadlocks
with the IRQ handler. Today it looks like this:

pcp lock
  IRQ disabled
    zone lock
    zone unlock
  IRQ enabled
pcp unlock

So any interrupt that queues during the IRQ disabled section fires
before the pcp unlock. This is not a rare operation; the zone lock
remains one of the most contended locks on large systems. 

Together, those two observations mean that any IRQ handler that requires
taking the pcp lock will fire before the interrupted task can let go of
the pcp lock, and the handler will always fall back to the already
contended zone lock.

In Meta production workloads, we've seen softlockups on large machines
where one CPU spent 23s in an RCU softirq freeing page tables, and
taking zone->lock once per page because it had interrupted a task
already holding the pcp lock.

Instead, keep the IRQ disabled until the pcp unlock, so that interrupt
handlers can have a better chance at taking the pcp lock and relieving
contention on the zone lock:

pcp lock
  IRQ disabled
    zone lock
    zone unlock
pcp unlock
  IRQ enabled

This series was tested on a 128-vCPU KVM guest, where every vCPU faults
in and MADV_DONTNEEDs in a loop. The "pcp fallbacks" (taking the zone
lock instead of the pcp lock) and long softirqs were summed across 6
runs of 30 seconds each.

+----------+---------------+-------------------+-----------------+
|          | pcp fallbacks | callback avg (ms) | softirqs > 65ms |
+----------+---------------+-------------------+-----------------+
| mm-new   |        135590 |                14 |             832 |
| +patch 1 |         10481 |               1.5 |             116 |
| +patch 2 |          2327 |               0.6 |              55 |
| +patch 3 |           190 |               0.6 |              10 |
+----------+---------------+-------------------+-----------------+

Running the same tests with PROVE_LOCKING, DEBUG_VM, and DEBUG_PREEMPT
also raised no concerns. 

Joshua Hahn (3):
  mm/page_alloc: drop the pcp lock before enabling IRQs after a drain
  mm/page_alloc: drop the pcp lock before enabling IRQs after a refill
  mm/page_alloc: disable IRQs around the remaining pcp drains

 mm/page_alloc.c | 59 +++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 50 insertions(+), 9 deletions(-)


base-commit: 9f004372ebeb18fdeb699f9880a0e472df90135b
-- 
2.53.1-Meta


