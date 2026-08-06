Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD360C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 07:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C577B6B008A; Thu,  6 Aug 2026 03:10:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F106B0095; Thu,  6 Aug 2026 03:10:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B45176B0096; Thu,  6 Aug 2026 03:10:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C5C66B008A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 03:10:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 214F680690
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:10:00 +0000 (UTC)
X-FDA: 85069970160.03.583D276
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	by imf31.hostedemail.com (Postfix) with ESMTP id 7003F20007
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 07:09:58 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=APQFTz7w;
	spf=pass (imf31.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786000198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=2rWnIhKLtx7RMjDuQwqgCN4If/Fil+88btYo9NiRc0M=;
	b=0HoxSFqv1JaYxp9xLkrQopz8szfN6LPCt4Qs2tJdjdiMMx3RnfHA0Jz9ZHKJjLdn8aRKfV
	2uUy+lfvwaHBLgPTAoeq+OTF+y2Xw9J3/zoYLfsewiaWNfmbY0IUi5RdE7oK9tYtU+/S86
	zDzgsyDQcAT/h4bX3Qm0+/Q0OJe5JeE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786000198;
	b=DTyIMmF3wTGLhxkdg+s+Tj8DK/IgctO8zQ6dB8QsRQzQyOM8ruHZfDMGnXuAaVZhNRaahf
	uInl5294IC7dJCvfl7JusZcMkM0MTRnyANguqKk6BfuTvzSXgT5r/FkgHWgbidRYGV/3ss
	T6IxkPYNFLu4LrDXkGheg1Uwt516Zq8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=APQFTz7w;
	spf=pass (imf31.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.171 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84e3007a2b7so1726011b3a.0
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 00:09:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786000197; x=1786604997; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2rWnIhKLtx7RMjDuQwqgCN4If/Fil+88btYo9NiRc0M=;
        b=APQFTz7wSuwwKxN9rXTRdPRZDyqZMV7bf5JKnNLeuKdCsqBCO3xqfSTaIiWcdojfOQ
         rm2EvJsW7v4KSyXD7oDgH5c68Rc0b0Ca130xyuILEuUFT3T4+4gVb9n0xYin5mpdoCyQ
         UMw4CD/Mi1kF3nIXuHjhww/nSJlNJUPv7I4awby5weNexByzbJTj+ZK5/gPJIL8N+mcl
         ixFAAu3TKZq1uNPUvbWu/BRWhUyHy5R4evfI48e4kDRcpDN5NOloeui+GyIjqFsnR9TE
         UQ3HaDRuJ/VOzAc0qjJLg1DZIX6qAwjrbJuHC83Vh4Q7Ny7jp9HOLIUvrbS/hr08CLdO
         0+sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786000197; x=1786604997;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2rWnIhKLtx7RMjDuQwqgCN4If/Fil+88btYo9NiRc0M=;
        b=pxSymYcTUB5tb8au4PpU3QOF4WjQL5CzMvgt0n4aWTb7ZWtYcfZo2vZRQOYkI6feEe
         p9OQ2zCHsld/yTg2JMSt0lfJR6lbT/aQzooVmvU0qus8ioHbIZyo0y6p21oHgZwjUyoW
         U2x0CkpmX2BY7l1upKVUaELjfiG/7drUhLTYLMrc0bNp5gCa1dWy/OrsapGIxjg5WdNr
         MSIk3dqGqxKz/S03GjM1XxY3JA39u52+QJEth/QwrHeUKxgmEwUCZUkegYHcGQ/1OyQM
         OCEB3o2h6TcilxGXuJ69PtbTzQdrlHlb7rsOqkNCwUchFCkkrDKn1iRauTY57F28F0jp
         IQzg==
X-Gm-Message-State: AOJu0Yz9lIOx+WB1MaN8OEpNr3m6/1Nk/mJ029Tr1AyqrE0Mbhf1idDe
	by31LjiMvTnN10nT2RomjDzSVQdI7qDPS6lltbYMXTB5EO7nzsCWNAxK
X-Gm-Gg: AR+sD13Kgk25dD6vPkZXjA++D4G+TY9vpCio80tpedMEKkBMFreT6crzcrvBx+HAMi4
	bAmBf1/rv74mYEI8dOJj4NeqVfgXlUVnbfpecmzoB+LDwtDLalFEICRsQddUmt4Vw3M/SzZ+tJC
	9UXUGB3eFn7sIsctb7FXPQ8roTD0u13MnsI9gI/7EcF+0859Ah/RMe16bM+owoVZWNo0u/fIFJz
	1FMvf4Op1MiacjNPd7d4fcZSGy1phTj+1+q1vLE5Cud+FuCuGjLptWN4gfGTpu3ZtDHvigyeWIj
	Cy2rPT6B5E0f9ONhZVAmSGz5P4MZR1xtOGZQEU6NQg6BtniG4ZVusflXkxvC9fGanJP2zDy0OU5
	TwATzHH5fyVwgiap3kHMXzrUXD4GGoKjzAw7gbvA5cLNkjgTeuksEQzr5bU2hIj7ZQcPTR9Cz2s
	4aUMWS2yfpF5avr9+9lxfdj/xi+vTgKLUMnYvFpqK5X9KgMR15NW3PvmVrdQHoGqk1uLVctK9/A
	F9cj/xWlLz+GUT4
X-Received: by 2002:a05:6a00:3d54:b0:847:8b1d:230d with SMTP id d2e1a72fcca58-84f2e014151mr13785011b3a.3.1786000197171;
        Thu, 06 Aug 2026 00:09:57 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f45bc9cffsm760154b3a.59.2026.08.06.00.09.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Aug 2026 00:09:56 -0700 (PDT)
From: Hao Jia <jiahao.kernel@gmail.com>
To: akpm@linux-foundation.org,
	tj@kernel.org,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	mhocko@kernel.org,
	yosry@kernel.org,
	mkoutny@suse.com,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v4 0/2] mm/zswap: Fixes and improves the zswap shrink
Date: Thu,  6 Aug 2026 15:09:41 +0800
Message-Id: <20260806070943.95542-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: gzhwjmz6xirjtrdefcxdueaupp3pzhbn
X-Rspamd-Queue-Id: 7003F20007
X-HE-Tag: 1786000198-491611
X-HE-Meta: U2FsdGVkX1/zuMaGPV44ii3eeQZXVNyMhTEmy9O9oNLsDUpjln+sES1G8a3LCTSzwB45XKiX2GDDRhWoDez7FVO5pGAQ+zhufNQ+ObX6ZYRsoEmZKYfNClQdkiKtTyINLzrPBniFz/7j3RRRQuGUSzIL0MA8mwY1g4fVgWzCkpbKxpphuTftH60hH3pI4kb6IPd6oB7RHWuD7NI2Y0Swic4Y2J08oUFHOHywjtK1JuPrTVwrMxG9ZPozK7ZcELTb0n1KHt7Yle+eCPvHIOc1Yh1a2fr6h3lYaMT4dddDwlPRD3xgk/cb5XJRhSOLag1Fg4wi7jak1J18wZqXO73+v7O/SsMA9zyuz6Byga0CC/mGkkKjhw3w6dwDrvrTuv/1BlzZqOgipLnhmibzSbyoKYAvnC4k2cpMChJ6d0ZxRZJ1UHipH8BM3Xio8XdMDCVvn2oanhwK5Z3eo/GvVg3CQrzNxRz+5Kw+ZYRgnIj3jCnfCnHIkRyivnibAxP1Sw85qEbnFgxSu2Q9HIndqh4WFGOJh2FmEEbY3AzjydvuuaT9v4Sh6sxaYMyqoRqZyUNW0UsewLazGIuptgMa9RV/K9rP6Z66Ejc6Ya0OLuTqDMtWmtw8YGYFZqB3kHeOTZQpaETUF6WRtffBr9B3KTy/ezfdl6AC8gZG849o4Iv1thWRqjOZu+MQu9Ikk2WbgfALFLhBDTWAAZkoQPg/hCguxLinodek2M4KMmtGvHDHllB1xix8Tk0IwY2iDFup0yq/dOsR0mboqJFPaAbf+F4F2oYW8cfBtxMgO3rByZoVNaLVKrrNgvQWkU5GJupVkufbYBZViYJXIM9Fpr4W4Y5V144hAcaTwoUdd8/Eo0Gt8aCof7gaPD4XEZj3pfq3FMcPNg1167uWrM7mp+ljbZgeZU4l7+/FY4mmW/vKFVHitr+FHLo89nb/bCZNmTL7vNxPwuNCp+oW43wuu1XOEkT
 ehWtlhYX
 eVn7llthSmhFmyH5xvHXQ+ZHbTG/r4vZo+0zDqh8B8s9RpAGZHwNLMjpctYZvEZLUqR7TUVfk8Jtzx0ZFEz8tDRk0m3pZxob7qjAQo+lndZ/nJCrHSJo1wdfej0g1b/75rbQ093ZhfG/FBFXTIyHxx4PAAyl/MEXFs+lbMf3PrMPZwEa9a6PGe+DjKX3I7q9hpy7soZBH/A6A/N90hp0NRT57PI95BHBJa9b4890hU9X1SM0uIpNs0VDtIbcwvsedEfCv6S+3047wlMoxiDtfZiQqYfBE+SioBb+7BDl1a+Rn+GrArDlPacHoLq//6KBYZ/4JpNLCBjDP65Fzg3Q63jOltrumW2FBrHqWKF1t0pDYVwU9XfvEqaeg36WdJAmY/8rPNqkH+lAcF1f2tVikIVr3XYDgXlc18i6lfUjovMM7tE9FXJ1nt4ZSepGV/o9QSyB5M8ZhgQYXH6gJh9jH4c+qTcu5BtMPbpgieailTApUVfNgQIpUQBUeX1eHHPtrYltIlfLmUReHRr1dn46hqsP/ZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

This series fixes and improves the zswap global shrinker (shrink_worker()):
Patch 1: Fix missing global shrinker when memory cgroup is disabled.
Patch 2: Extend shrink_memcg() to support batch writeback and thereby improving
         the writeback efficiency in the shrink_worker() and zswap_store() paths.

v3->v4:
    - Remove the nr_to_scan parameter from shrink_memcg() and cap the per-node
      scan count at SWAP_CLUSTER_MAX to avoid writeback unfairness across NUMA
      nodes caused by a shared global scan quota.
v2->v3:
    - Added user impact to the commit 1 message.
    - Updated writeback batch size to SWAP_CLUSTER_MAX to avoid introducing new
      magic macros. And enabled batched shrinking in the zswap_store() path as well.
    - Re-benchmarked performance data with the updated patch.
v1->v2:
    - Add a reschedule check to the -ENOENT return path in shrink_memcg() to
      handle the theoretical issue of prolonged heavy concurrent zswap stores.
    - Remove the shrink_memcg() return value changes part, and include a more
       detailed test report in the commit message.

[v3] https://lore.kernel.org/all/20260729084206.77793-1-jiahao.kernel@gmail.com
[v2] https://lore.kernel.org/all/20260717085151.22822-1-jiahao.kernel@gmail.com
[v1] https://lore.kernel.org/all/20260714081510.16895-1-jiahao.kernel@gmail.com

Hao Jia (2):
  mm/zswap: Fix global shrinker when memory cgroup is disabled
  mm/zswap: Support batch writeback in shrink_memcg()

 mm/zswap.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

-- 
2.34.1


