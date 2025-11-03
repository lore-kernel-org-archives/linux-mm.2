Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33951CCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 07:53:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F9178E0031; Mon,  3 Nov 2025 02:53:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D1248E002A; Mon,  3 Nov 2025 02:53:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6B18E0031; Mon,  3 Nov 2025 02:53:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6813C8E002A
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 02:53:31 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 328395C34C
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:31 +0000 (UTC)
X-FDA: 84068531022.05.D98D506
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf10.hostedemail.com (Postfix) with ESMTP id 33AF9C0005
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 07:53:29 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=d0ch34wp;
	spf=pass (imf10.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762156409; a=rsa-sha256;
	cv=none;
	b=exrONPMyGTJVHcrSxJc77l3qXUDET8+uUYlR2BMvWxZiCB8y/3MQ0Z8q+SEgsATWwXtVhb
	bdpqHFnRBfYXKkoXgvl7o8nNpcmTeUXoDFpgKceIVcIwXZgGHyyskAGdD0PcdffWYfnuTG
	TN4LQuMNd6FqwVsfpaP6tds/kRubPhU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=shopee.com header.s=shopee.com header.b=d0ch34wp;
	spf=pass (imf10.hostedemail.com: domain of leon.huangfu@shopee.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=leon.huangfu@shopee.com;
	dmarc=pass (policy=reject) header.from=shopee.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762156409;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ba4jPz4GzIpOX2boFuFrVZ/wgd/V0hgb12GzaY8s2GM=;
	b=DAeigIJM0eLzqZJWe1WlW3B4PnSt/durnAkc7Wur5R18y4PD/qPKKQMueXwkfeBnbu7YNk
	M7LlwB3Hhkg3t+fdejOogA5ZD85XtCkTAtxx05jRhdcATdramsFAGpUFePMobexEmWBJKH
	CBmcfAqacOsbiskHzR44DqgDe16QMzE=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7aa2170adf9so706007b3a.0
        for <linux-mm@kvack.org>; Sun, 02 Nov 2025 23:53:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=shopee.com; s=shopee.com; t=1762156408; x=1762761208; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ba4jPz4GzIpOX2boFuFrVZ/wgd/V0hgb12GzaY8s2GM=;
        b=d0ch34wpn2TYIk7olLLe94ebA5fyQTqoEWZDNlmHjhWhUxJSDrH/NOavRSpqkVXAzz
         TgNb3cxEYmQ2fJATQz28kUqumqu1MOxz96uiOJbT3y5H7KpzH6CTZ+2IqRDuHwEPjzdt
         ysssJyd98QX9ZD6bdK1zupI49VpLZUkhpzYj0oBdiKPezxpNms7uiujBhQkuJgz4ze1Z
         6dd+G6K2dQpC0Z/kqmYs5ZV7G2pX/Z8EFmG/YTQvHEsNKrnnqyKiEe5xG75f6c1Jqupc
         cLHtKHgJkHCB9CMU9iX7WmGKdhxBd1+GdOEqSXPp2+8Vs49N5Hbj9QkdnusD8rUMEOgs
         wEUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762156408; x=1762761208;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ba4jPz4GzIpOX2boFuFrVZ/wgd/V0hgb12GzaY8s2GM=;
        b=iZl6JzqLXsZhDJAYvkiA7ao1yZUoLqbcjhnIhWwsUoEHrHZJ/VYAz8l91Y8hfyr+Oy
         TEXgZjUjdWZJBOnStuY8KtDV5hV8oD4gzjCuLyRenrm0NcjKOfdYAX8VZDaElfcK3OKm
         pr82vyez+XcBK4Up3bithLmiJo+JJBIkpRoFkhre786kCeMcSe252Sje5YULF7EzQQgx
         LGP545T7gQ7UhkHfaY0gfBNZ4NBR/IuASUaq3lrCLr2Ap3ss7vzA1Kthri8MrKcv1KcD
         3OihDEcSrXFKJw8FHArKMRhtZ0CEHuEaC8+uwGJHdZH7Q82rsHLISwsmhWAeCqR8ukFn
         +ntA==
X-Forwarded-Encrypted: i=1; AJvYcCW/506HYQHPydlE3b2NCPmorBm0Z8ZT54jhUop8hWvO7VOndOf2AVUjmuRLU4YtDZ1GbRE77ELoDg==@kvack.org
X-Gm-Message-State: AOJu0YxcuGE8uQloAQhTneFLQBSbNjz58lgBUWpjb9qLVyGnJ7/zJFnE
	PjzIQXYJbnFX9xdmmxAxBSja1RgF/arGJiJw87MvlBUIT/X7hCxWV94d+2amj7hMmXs=
X-Gm-Gg: ASbGnctY3EOxVdbzcWTNMroMgPeumYhuP0xXHXpS/fEr0Pj7+49cOLic98zhCOXoWd5
	Vkqzuw04xFBm0lEzvxh+xqwLhD6RBlMk3VTw2qScSlmUsmSCuVtLYj99qNfeaYX6DiKaBk6zBXw
	TZbROGY06L2edFwT+HIOZY0aPuFBt6ZHk5Og3BCb3feD37IvLAsclTbbz9d+vQDEw17LMI3ZdLK
	0so/hJNNH9mkwC36ywC5wpbu3vHARSwkv5QWlRQifTXY0nlFYvgAKfkbiplW5TD73KK8iOO8aYo
	nN4djB6tscOWWY5uVZtVUIeIPXpJLp1fjSnODk8VI8t1Hc7NTEMAKXCV10/kCAzKwcCmHE+FroM
	me2sAE5kqnlVw5XYTlDjbI0JG7DEkoWjHtyIgpw2ARNbook2qjJ0zbO0tTt/Y9WE5Dy6DFTHNDe
	9ikMDvcCUQSt3qLQ==
X-Google-Smtp-Source: AGHT+IGWNo1R+qKvdYnQyYk2CzdvOoi6Va0W2v8DV/ljaASF7VURewKuzp1i6g4RA/RRpxV0UmwQ/w==
X-Received: by 2002:a05:6a20:7344:b0:311:99:7524 with SMTP id adf61e73a8af0-348ca351af3mr15450451637.18.1762156407934;
        Sun, 02 Nov 2025 23:53:27 -0800 (PST)
Received: from .shopee.com ([122.11.166.8])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34159a16652sm34552a91.20.2025.11.02.23.53.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Nov 2025 23:53:27 -0800 (PST)
From: Leon Huang Fu <leon.huangfu@shopee.com>
To: stable@vger.kernel.org,
	greg@kroah.com
Cc: tj@kernel.org,
	lizefan.x@bytedance.com,
	hannes@cmpxchg.org,
	corbet@lwn.net,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	shakeelb@google.com,
	muchun.song@linux.dev,
	akpm@linux-foundation.org,
	sjenning@redhat.com,
	ddstreet@ieee.org,
	vitaly.wool@konsulko.com,
	lance.yang@linux.dev,
	leon.huangfu@shopee.com,
	shy828301@gmail.com,
	yosryahmed@google.com,
	sashal@kernel.org,
	vishal.moola@gmail.com,
	cerasuolodomenico@gmail.com,
	nphamcs@gmail.com,
	cgroups@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Chris Li <chrisl@kernel.org>,
	Greg Thelen <gthelen@google.com>,
	Ivan Babrou <ivan@cloudflare.com>,
	Michal Koutny <mkoutny@suse.com>,
	Waiman Long <longman@redhat.com>,
	Wei Xu <weixugc@google.com>
Subject: [PATCH 6.6.y 5/7] mm: memcg: make stats flushing threshold per-memcg
Date: Mon,  3 Nov 2025 15:51:33 +0800
Message-ID: <20251103075135.20254-6-leon.huangfu@shopee.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20251103075135.20254-1-leon.huangfu@shopee.com>
References: <20251103075135.20254-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: ogxpi4kamjqb46fitntwk3q65uqxerbf
X-Rspamd-Queue-Id: 33AF9C0005
X-Rspamd-Server: rspam09
X-HE-Tag: 1762156409-70624
X-HE-Meta: U2FsdGVkX19DQvcz5qHe4tTQGNltVyQCGkkUMmw9otzyp6aQjVX65YYYBsAqounDGlhy724+st4/LDC/7Qj+Ykb23RT8TWjGe+jCbHjI/pIbI5yAln+8IJbmS26n2pGnciUm9wDTbmvFBiKF5aO7C81CeiFiQkn2CrqRs+OF4fjnocuy2wM/mAu1SnhGaaO1DGbcDgpz4eZN1YT++zVIvTkt82ydz25Yf88/ZNuN3Em/GXXBj6XiOsiRL8QOyMLDuX5b28UxoCQKaZGVBPHzBbl/fDxNI9zugAwqDL23vDrjfvsDaYqCtUWlAgTWv4vjhnNKglR7vXTMsjWe99Ojfm6tAqQJnAYrsCycpF9qxsMTcW0ggIho22xjvQZqquCSqPBmgffR6UVe3iAHa0j/Vi6kRMJSTBv/DVEthAHO2O4NrDtczDxEy/nnP4BLq/4IBjVu6zzHOnFF7IFcXb4FffD/Z6+3aLfNnL5huRCpYhUbSGtwKmRkLbItkavPOVCP8kIAbxWaTACJpCwXP2tiqg4Kf+82eNgjj4zZqbqaj9sPr0oL4R18xyEWGd2yYlLWR2A9+xxyEYOBTKXkFL4w+14aRAp0an9pm62BvfB6k2Pw/M9qUyWxaDfK5a8g1aL8ZMvCfQysoRnzG4VlGPmLRGLYpOor8KVRD3XAn4qF0YFIrYOeHvs8lxLHIBcutmX1mfQY+YwevR3ecgRawVf1K9GKCBcVHr5CI1NGly+UykeLDWx1+vycDfXrm1wTSZlj05LN1dAQg4FqeD1v2e5q0cCXKscGir/hfG86NMEawI+v3UvUOCyEstnZugpT4QAutyEJXXjYdT8PNkwudyN/wWQAx5ecNiQXeJft1mX41Q60DML1bjln7i57fuMXCRFl22Va+HvgGSVDftWVbg7Uw6B34ga8OpB4xckjCkVIcWHIyfob/1I+HIAqBerwttofmqOEXgHdcNnoZNXRNFM
 NoDkHQCr
 OjctRmKdpPwppb7RNelZeNQahwjoYCN+kdRXHy/FNHdwb7yhjvIBy8HTy6Z8fAL1PZx8hlGb9/f3GFBbkJjq8lmXR1B0RK5CkD2KOaVDdFpVJ7CPr4OTt4WcUgC1RvBtdrAIHe8qSr6ZAr6iRMCakQwbPN1xFxJjKNseLakJ+SK5WNOemz+LQYu0aYJbUXQbM5GPEioQuHfneM2z4ziDPRM+kMz5YaZqboaW99hha9d9kNmFTI8/LcDldfBiTGzKRtz1W4TlwwwATlAMyTvc/6vJa5gOAzqTaqkLz8JFLzY1cnhgmJiXiUavOho40hWh9DJAXQ3cAcQXCuOEVEeuEDvG+1ERwlMZbfYRWBcb12REP4xxvWnlzJCo/FaUz9IFJ13tR8ayzIBwXqtmef49dJwLi7HlJjPaheL4rO/EXTcAdgQtGe0IVgwGYeO1yrnV+5dJ5yUYc2cKuVD2gl9R9krrrmJtYYLFLtpGOOwnt8Uo0k0KFVd+s83KclWXlw8nFvUt1/8KKsBu+p5PMXl4AgTy/wfcz3+I+IlZCwUjw3MtJ3ApfGBlwTd49gnU7bn/kf2GFxdk2v6mm72e6EmqzxEN0exkV2ub1lKTYuobRDhMQ2pK0b67sjctElt3zvHvhwCPjWL3VAEp2BpHgoTbJ6ACB+IB0hfdxY4P2TRpNJbsenVZPy9MwvA5PLYH3xRuVWL6V
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Yosry Ahmed <yosryahmed@google.com>

[ Upstream commit 8d59d2214c2362e7a9d185d80b613e632581af7b ]

A global counter for the magnitude of memcg stats update is maintained on
the memcg side to avoid invoking rstat flushes when the pending updates
are not significant.  This avoids unnecessary flushes, which are not very
cheap even if there isn't a lot of stats to flush.  It also avoids
unnecessary lock contention on the underlying global rstat lock.

Make this threshold per-memcg.  The scheme is followed where percpu (now
also per-memcg) counters are incremented in the update path, and only
propagated to per-memcg atomics when they exceed a certain threshold.

This provides two benefits: (a) On large machines with a lot of memcgs,
the global threshold can be reached relatively fast, so guarding the
underlying lock becomes less effective.  Making the threshold per-memcg
avoids this.

(b) Having a global threshold makes it hard to do subtree flushes, as we
cannot reset the global counter except for a full flush.  Per-memcg
counters removes this as a blocker from doing subtree flushes, which helps
avoid unnecessary work when the stats of a small subtree are needed.

Nothing is free, of course.  This comes at a cost: (a) A new per-cpu
counter per memcg, consuming NR_CPUS * NR_MEMCGS * 4 bytes.  The extra
memory usage is insigificant.

(b) More work on the update side, although in the common case it will only
be percpu counter updates.  The amount of work scales with the number of
ancestors (i.e.  tree depth).  This is not a new concept, adding a cgroup
to the rstat tree involves a parent loop, so is charging.  Testing results
below show no significant regressions.

(c) The error margin in the stats for the system as a whole increases from
NR_CPUS * MEMCG_CHARGE_BATCH to NR_CPUS * MEMCG_CHARGE_BATCH * NR_MEMCGS.
This is probably fine because we have a similar per-memcg error in charges
coming from percpu stocks, and we have a periodic flusher that makes sure
we always flush all the stats every 2s anyway.

This patch was tested to make sure no significant regressions are
introduced on the update path as follows.  The following benchmarks were
ran in a cgroup that is 2 levels deep (/sys/fs/cgroup/a/b/):

(1) Running 22 instances of netperf on a 44 cpu machine with
hyperthreading disabled. All instances are run in a level 2 cgroup, as
well as netserver:
  # netserver -6
  # netperf -6 -H ::1 -l 60 -t TCP_SENDFILE -- -m 10K

Averaging 20 runs, the numbers are as follows:
Base: 40198.0 mbps
Patched: 38629.7 mbps (-3.9%)

The regression is minimal, especially for 22 instances in the same
cgroup sharing all ancestors (so updating the same atomics).

(2) will-it-scale page_fault tests. These tests (specifically
per_process_ops in page_fault3 test) detected a 25.9% regression before
for a change in the stats update path [1]. These are the
numbers from 10 runs (+ is good) on a machine with 256 cpus:

             LABEL            |     MEAN    |   MEDIAN    |   STDDEV   |
------------------------------+-------------+-------------+-------------
  page_fault1_per_process_ops |             |             |            |
  (A) base                    | 270249.164  | 265437.000  | 13451.836  |
  (B) patched                 | 261368.709  | 255725.000  | 13394.767  |
                              | -3.29%      | -3.66%      |            |
  page_fault1_per_thread_ops  |             |             |            |
  (A) base                    | 242111.345  | 239737.000  | 10026.031  |
  (B) patched                 | 237057.109  | 235305.000  | 9769.687   |
                              | -2.09%      | -1.85%      |            |
  page_fault1_scalability     |             |             |
  (A) base                    | 0.034387    | 0.035168    | 0.0018283  |
  (B) patched                 | 0.033988    | 0.034573    | 0.0018056  |
                              | -1.16%      | -1.69%      |            |
  page_fault2_per_process_ops |             |             |
  (A) base                    | 203561.836  | 203301.000  | 2550.764   |
  (B) patched                 | 197195.945  | 197746.000  | 2264.263   |
                              | -3.13%      | -2.73%      |            |
  page_fault2_per_thread_ops  |             |             |
  (A) base                    | 171046.473  | 170776.000  | 1509.679   |
  (B) patched                 | 166626.327  | 166406.000  | 768.753    |
                              | -2.58%      | -2.56%      |            |
  page_fault2_scalability     |             |             |
  (A) base                    | 0.054026    | 0.053821    | 0.00062121 |
  (B) patched                 | 0.053329    | 0.05306     | 0.00048394 |
                              | -1.29%      | -1.41%      |            |
  page_fault3_per_process_ops |             |             |
  (A) base                    | 1295807.782 | 1297550.000 | 5907.585   |
  (B) patched                 | 1275579.873 | 1273359.000 | 8759.160   |
                              | -1.56%      | -1.86%      |            |
  page_fault3_per_thread_ops  |             |             |
  (A) base                    | 391234.164  | 390860.000  | 1760.720   |
  (B) patched                 | 377231.273  | 376369.000  | 1874.971   |
                              | -3.58%      | -3.71%      |            |
  page_fault3_scalability     |             |             |
  (A) base                    | 0.60369     | 0.60072     | 0.0083029  |
  (B) patched                 | 0.61733     | 0.61544     | 0.009855   |
                              | +2.26%      | +2.45%      |            |

All regressions seem to be minimal, and within the normal variance for the
benchmark.  The fix for [1] assumes that 3% is noise -- and there were no
further practical complaints), so hopefully this means that such
variations in these microbenchmarks do not reflect on practical workloads.

(3) I also ran stress-ng in a nested cgroup and did not observe any
obvious regressions.

[1]https://lore.kernel.org/all/20190520063534.GB19312@shao2-debian/

Link: https://lkml.kernel.org/r/20231129032154.3710765-4-yosryahmed@google.com
Signed-off-by: Yosry Ahmed <yosryahmed@google.com>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Tested-by: Domenico Cerasuolo <cerasuolodomenico@gmail.com>
Acked-by: Shakeel Butt <shakeelb@google.com>
Cc: Chris Li <chrisl@kernel.org>
Cc: Greg Thelen <gthelen@google.com>
Cc: Ivan Babrou <ivan@cloudflare.com>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutny <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Tejun Heo <tj@kernel.org>
Cc: Waiman Long <longman@redhat.com>
Cc: Wei Xu <weixugc@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Leon Huang Fu <leon.huangfu@shopee.com>
---
 mm/memcontrol.c | 50 +++++++++++++++++++++++++++++++++----------------
 1 file changed, 34 insertions(+), 16 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 157be6820fd1..c31a5364f325 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -628,6 +628,9 @@ struct memcg_vmstats_percpu {
 	/* Cgroup1: threshold notifications & softlimit tree updates */
 	unsigned long		nr_page_events;
 	unsigned long		targets[MEM_CGROUP_NTARGETS];
+
+	/* Stats updates since the last flush */
+	unsigned int		stats_updates;
 };

 struct memcg_vmstats {
@@ -642,6 +645,9 @@ struct memcg_vmstats {
 	/* Pending child counts during tree propagation */
 	long			state_pending[MEMCG_NR_STAT];
 	unsigned long		events_pending[NR_MEMCG_EVENTS];
+
+	/* Stats updates since the last flush */
+	atomic64_t		stats_updates;
 };

 /*
@@ -661,9 +667,7 @@ struct memcg_vmstats {
  */
 static void flush_memcg_stats_dwork(struct work_struct *w);
 static DECLARE_DEFERRABLE_WORK(stats_flush_dwork, flush_memcg_stats_dwork);
-static DEFINE_PER_CPU(unsigned int, stats_updates);
 static atomic_t stats_flush_ongoing = ATOMIC_INIT(0);
-static atomic_t stats_flush_threshold = ATOMIC_INIT(0);
 static u64 flush_last_time;

 #define FLUSH_TIME (2UL*HZ)
@@ -690,26 +694,37 @@ static void memcg_stats_unlock(void)
 	preempt_enable_nested();
 }

+
+static bool memcg_should_flush_stats(struct mem_cgroup *memcg)
+{
+	return atomic64_read(&memcg->vmstats->stats_updates) >
+		MEMCG_CHARGE_BATCH * num_online_cpus();
+}
+
 static inline void memcg_rstat_updated(struct mem_cgroup *memcg, int val)
 {
+	int cpu = smp_processor_id();
 	unsigned int x;

 	if (!val)
 		return;

-	cgroup_rstat_updated(memcg->css.cgroup, smp_processor_id());
+	cgroup_rstat_updated(memcg->css.cgroup, cpu);
+
+	for (; memcg; memcg = parent_mem_cgroup(memcg)) {
+		x = __this_cpu_add_return(memcg->vmstats_percpu->stats_updates,
+					  abs(val));
+
+		if (x < MEMCG_CHARGE_BATCH)
+			continue;

-	x = __this_cpu_add_return(stats_updates, abs(val));
-	if (x > MEMCG_CHARGE_BATCH) {
 		/*
-		 * If stats_flush_threshold exceeds the threshold
-		 * (>num_online_cpus()), cgroup stats update will be triggered
-		 * in __mem_cgroup_flush_stats(). Increasing this var further
-		 * is redundant and simply adds overhead in atomic update.
+		 * If @memcg is already flush-able, increasing stats_updates is
+		 * redundant. Avoid the overhead of the atomic update.
 		 */
-		if (atomic_read(&stats_flush_threshold) <= num_online_cpus())
-			atomic_add(x / MEMCG_CHARGE_BATCH, &stats_flush_threshold);
-		__this_cpu_write(stats_updates, 0);
+		if (!memcg_should_flush_stats(memcg))
+			atomic64_add(x, &memcg->vmstats->stats_updates);
+		__this_cpu_write(memcg->vmstats_percpu->stats_updates, 0);
 	}
 }

@@ -728,13 +743,12 @@ static void do_flush_stats(void)

 	cgroup_rstat_flush(root_mem_cgroup->css.cgroup);

-	atomic_set(&stats_flush_threshold, 0);
 	atomic_set(&stats_flush_ongoing, 0);
 }

 void mem_cgroup_flush_stats(void)
 {
-	if (atomic_read(&stats_flush_threshold) > num_online_cpus())
+	if (memcg_should_flush_stats(root_mem_cgroup))
 		do_flush_stats();
 }

@@ -748,8 +762,8 @@ void mem_cgroup_flush_stats_ratelimited(void)
 static void flush_memcg_stats_dwork(struct work_struct *w)
 {
 	/*
-	 * Always flush here so that flushing in latency-sensitive paths is
-	 * as cheap as possible.
+	 * Deliberately ignore memcg_should_flush_stats() here so that flushing
+	 * in latency-sensitive paths is as cheap as possible.
 	 */
 	do_flush_stats();
 	queue_delayed_work(system_unbound_wq, &stats_flush_dwork, FLUSH_TIME);
@@ -5658,6 +5672,10 @@ static void mem_cgroup_css_rstat_flush(struct cgroup_subsys_state *css, int cpu)
 			}
 		}
 	}
+	statc->stats_updates = 0;
+	/* We are in a per-cpu loop here, only do the atomic write once */
+	if (atomic64_read(&memcg->vmstats->stats_updates))
+		atomic64_set(&memcg->vmstats->stats_updates, 0);
 }

 #ifdef CONFIG_MMU
--
2.50.1

