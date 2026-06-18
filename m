Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B85CCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 04:49:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1641A6B0088; Thu, 18 Jun 2026 00:49:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 114BE6B008A; Thu, 18 Jun 2026 00:49:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02A426B008C; Thu, 18 Jun 2026 00:49:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BFFC06B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 00:49:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 190E21C2E50
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:21 +0000 (UTC)
X-FDA: 84891804522.21.F18C088
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 62A3420002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:49:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ErrZNQS+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781758159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=/50j8h9PVe8SgOeD0lIk2bjb8dms38WVFY5YQFYhQcI=;
	b=A4y2+KMKzE7llnP9PWWBtARQVPfJF7GbTFFSKUi+WCeQ9Praz1Ot3u8WhJY2yFMVuYVU+M
	VpaqmDkj1mI5MniIuCvCDfgtDhWG1yjWilXpsOdqqNwa0vlJh4iDvGLt4bt5TzQ1gKi3ux
	LZvmoK9gsDjE1jpBaKTuHV8OhxJpsaU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ErrZNQS+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf13.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781758159;
	b=yqafscLbWambyAWV9QZgWr0oz1FyT3P1Y2OPRKwZrlfvUZWqr5z6iHLYetahfzMUaaeJd5
	U5euFkAEc+r3I9LJNMy9YzjCNEyDfsKBSVLXVo/A0qRZxPebDhMVCNHzAFbddcg06DHaS2
	XPYQbp9JI63VyIvBpTmXtyrqWBkoIk0=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8419ab3a297so203351b3a.2
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 21:49:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781758158; x=1782362958; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/50j8h9PVe8SgOeD0lIk2bjb8dms38WVFY5YQFYhQcI=;
        b=ErrZNQS+8/3RtVB6jqMKn/1A6KaihwoiF5fZjCXzcs9QpBhWZtIdpyvQYgqqoDlORQ
         Rr7dOhlidXbk0Tl/T3p7ZA+nCeomLyfWg0cS31W7tKi8qguw9XPgKDwDjcVg4Ew5J4+z
         xyElf1hHyQGYPCwiTTAMN3I6ssANxmXP6aYIi2bYfOhtq03/eJN5M8AaNjUPpZoAplRR
         KwrwgQvuq/6nVRR0Tg7ST4jrRpq5EcW3MQElobai16u/3D18h6HgswNAQVlxk/bm3SR9
         ww/7mdn6IgRa7QyT0K09iIaSBEsUPVwxu0sh2XpWZcaKgApgtg5wLBCnFCOjr3eaXGFE
         Dy6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781758158; x=1782362958;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/50j8h9PVe8SgOeD0lIk2bjb8dms38WVFY5YQFYhQcI=;
        b=BpF7t1SFmYCYS4VtBu/CzZUByKMvodiNoUOKL4u0nlYVTt+fqHazBLnTIK6zoNuwBU
         2BlGI+hk6/ssyuaj+g8vdWygUgCfUzdinf4z+XAcq8o/XaKSme7GfOVeHGkrIqTjymKS
         P2QNhQE7oGzen0GrN/bV9uD/mzFPIJLLw5Qx2wuXDjs8erHe9y1HSFCbWHufe2qKvShr
         p/HFxP7GCiQuzD7HsPJu4uFvEanzyRoBkF/2ifM4xfjs55ZFGNmEGOsuod2N12w3+jvY
         sQumpVKDvJpYl2gAhtPX4tfQFTNL8/NI2+JopHhJnE7i79qwzpgPZcVbcf4DsE1VnFTf
         Hu1w==
X-Gm-Message-State: AOJu0YwmmKtR8xiTqAw6rLET6HLLNKvIQzT1axVrZbWJqlz9nJKbR6ys
	UdFmFwCYEHuafXR7s3vbeI/yp9+YHGgerfbqpS+8bV0Jly0Dc/5zw3ys
X-Gm-Gg: Acq92OF1f76kf6ryv/KJv/Up4CtLDiRL7ud7Q+92UM9HKmfjL+/XOgTV06KR52+TXq8
	2o+DX4Pr2oh2RJc29IZ5IMSPEQXmAJgjriHylJ3z1KywiBhQc2kx4bRKW+p2t3w/g5pTl4dsRrK
	IvWrDmdEw5d9cBrxAFmWe8KpHpHrGziJUWn5cRIi64y6r2V3CzLFKK8FbpS7/WE46SxElJmyl9e
	h/EI9zk0WuSwY1ZwhnfG07KpVekcmT1ZiEnyKFPUO9e2lpNLnaQh4jO+irDb6cYOkxdb6L13sV+
	lp6wZzARbQ0KHPrSHOi0ZLCtRhQf+Mptjfs+V2drB6whW7omPiAI/ZY9dXZoYzXU8qiHNuIn7po
	OgqR+4VMjnnYczix2fiXj3NVzcfOXOu+NqXKnJH0250n/KhuHtkwhxg0mJuMKQHGF/TzFFbx+VC
	fEaeCfEiszbfH85qLduQ5/Z9HYBJMxctrHOndNcYgtnBO4PzNIsHk=
X-Received: by 2002:a05:6a00:4615:b0:822:6830:5900 with SMTP id d2e1a72fcca58-8452444604bmr7259302b3a.6.1781758158031;
        Wed, 17 Jun 2026 21:49:18 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8434b020b53sm17214781b3a.47.2026.06.17.21.49.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 17 Jun 2026 21:49:17 -0700 (PDT)
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
Subject: [PATCH v4 0/5] mm/zswap: Implement per-cgroup proactive writeback
Date: Thu, 18 Jun 2026 12:48:52 +0800
Message-Id: <20260618044857.69439-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: bhyogujtdnru1uppgincpps5grjwbu6d
X-Rspamd-Queue-Id: 62A3420002
X-HE-Tag: 1781758159-298432
X-HE-Meta: U2FsdGVkX1+IHxbgr7C0f/Auwowgu45PufgHyE0d/IOcAOjIbGaw3zMKcv8cg2BVMeLznGPbbr9V43RwD7vO0zhPQOTKLg7QiJG5no1LRQ31EkpLaBQ6qrRWHte+fwEu0pPGHkUjCsV5v/q7kZWcQTQ7StCokbqqldW6rIJ5ms9ZTSwuQ7nI3/3xcpf2Km16morUql31WGuoK0Jo29d/ilpFO6lwohJjwJDwF30Zs0Ao0tP7FHzU1ZEfRw9lrD2tB0jFL1PdbHe/60WmUsCnhW5EOTnqImfx8wFeOZ+m2NBb2oJpYm0a8PJ/v5N7YC4zTrC9Zvj4Wvh/1cIq28OaZlmiYtFPi1wu0e6QPVuvWBI6vTc5fNZ86nzXXOBav/mY9qCdHk2NSFQFbWGhYYUDvQh9oaLIx7h5abhFjn2Ha1w00R81wRzfOpdsr1kZ74rX+3Y5OjaRp+45yKYWklUfF4hVtLp1p7cOD8gbZzLwc5qUsBBqOwvJX9GBZT+1R2/iW6IJMBGgplDUdWOEpUzKxmMWLPbl+YsFj+iP0QECN2lgeRbP9e90kAmGnxR8Vh6uLKG0d9vP7nE8/iKT9HPHQhh9GIsCB5myfGOwzvVrbCeo44IpcYY26tagaFDJkT4xmuN3QQWxkz/mdfUbj6HlVAkkiwyXXEQvM4rc9WmMn4ObmWU+nUx9rYL5+nRiMzAYPFQNWJgq+1aYq8ELg1h5nF0yXtC7mfGQp5yCn/wQZcHacEw3+Ph1NSbF9UHpqFtP2tNk4EnUO72KDfUMBTEtSg6I96GaAj5D4q/ZbUm6W+g+yjjfyQBgAAgFeuc2py1AJ/Vo7ExLZd+dH06uRPWzHJx84BoEIUOY4gosbd5jNBgYFuf8aHHH/AWQbxr1MBTXl4cQaf1V/k6ogPaeisMRk9NFUe4S41nd4gdMlY+juDISy4o9iIJVjrzRa7AA7Gcm7oIBFGTRozQg0ahK/Fq
 HO4ze0l5
 P2xnZZzkAFMdh2XZwhjbtjR9naCTsYyOMDLXzfZjcDe8o14Vat1uZ/zsteGKuR4M39Omc8ZEBVSYwPQyoNF3IFYGXq3bJLFbgD+736++Te+s/ohUEG9L3wou/6aCcaHUeEiqxDc//cTxUB//ZrmAU1V5BBXmT8YxSScnBd35fE++IfYWp+k5KqWDj7Xr07Ts5L5JE41dbp7qI8Do6xrUjZSGXKm5Sim/vX9VLNI2Hob6GTqPSm46BYemGeYnfZYqMc9fuCG0uARS/kk2lvvu21WzHRYNtxH7xLQvzl7KAPRVtSJwPMqJ86TvWDJjuHHX7e0+asYYMADsJEj2QNwessxopPFSCluz/U4NoXjWtpFyNRJ1mTkpvV37CYcB5njQlzBgoTaR8V+zENnedlciiDSR+ceM8agMlWtrm5ywPL5iyxVmhskOfPRIyh6QUu30G0JG+94XWqYINAWqKJ3rrecNd/jYSwqqKMNpQeni4XvdLO/MHXalE1NZoOnkEHXp7DXUvGHe03T3pRk6xyhXTpmrqtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hao Jia <jiahao1@lixiang.com>

Zswap currently writes back pages to backing swap reactively, triggered
either by the shrinker or by the pool reaching its size limit. Although
proactive memory reclaim can automatically write back a portion of zswap
pages via the shrinker, it cannot explicitly control the amount of
writeback for a specific memory cgroup. Moreover, proactive memory reclaim
may not always be triggered during a steady state.

In certain scenarios, it is desirable to trigger writeback in advance to
free up memory. For example, users may want to prepare for an upcoming
memory-intensive workload by flushing cold memory to the backing storage
when the system is relatively idle.

This patch series introduces a "zswap_writeback_only" key to memory.reclaim
cgroup interface, allowing users to proactively write back cold compressed
data from zswap to the backing swap device. When specified, this key
bypasses standard memory reclaim and exclusively performs proactive zswap
writeback up to the requested budget. If omitted, the default reclaim
behavior remains unchanged.

Example usage:
  # Write back 10MB of compressed data from zswap to the backing swap
  echo "10M zswap_writeback_only" > memory.reclaim

Patch 1: Extend shrink_memcg() to support batch writeback based on a
  compressed-size budget and update its return value semantics, thereby
  improving the writeback efficiency in the shrink_worker() path.
Patch 2: Extract the memcg iteration and writeback loop into helper
  functions to prepare for proactive writeback.
Patch 3: Extend the memory.reclaim cgroup v2 interface with a new
  "zswap_writeback_only" key, allowing users to trigger proactive zswap
  writeback up to a requested budget.
Patch 4: Add the zswpwb_proactive_b stat to track the compressed bytes
  of proactive writeback for better monitoring and tuning.
Patch 5:
  Add tests for zswap proactive writeback.

v3->v4:
  - Drop the per-memcg cursor and keep the root cgroup cursor
    (zswap_next_shrink) logic intact.
  - Stick to using the zswap_writeback_only key, and change the proactive
    writeback size to use the compressed size.
  - Consolidate and reuse the logic between shrink_worker() and
    shrink_memcg(). Enable batch writeback in the shrink_worker() path,
    while maintaining a low writeback budget in the zswap_store() path.

v2->v3:
    - Align the return value of zswap_proactive_writeback() with
      memory.reclaim and update the corresponding documentation accordingly.
    - Resolve conflicts in test_zswap.c on the mm-unstable branch.
    - Enhance the zswap proactive writeback selftests to guard against potential
      future regressions.

v1->v2:
    - As suggested by Yosry and Nhat, extend the memory.reclaim cgroup v2
      interface with a "zswap_writeback_only" key instead of adding a new
      dedicated cgroup interface.
    - Update the zswap documentation and add selftests for proactive writeback.

[v3] https://lore.kernel.org/all/20260526114601.67041-1-jiahao.kernel@gmail.com
[v2] https://lore.kernel.org/all/20260525122242.36127-1-jiahao.kernel@gmail.com
[v1] https://lore.kernel.org/all/20260511105149.75584-1-jiahao.kernel@gmail.com

Hao Jia (5):
  mm/zswap: Extend shrink_memcg() writeback capability
  mm/zswap: Factor writeback loop out of shrink_worker()
  mm/zswap: Implement proactive writeback
  mm/zswap: Add per-memcg stat for proactive writeback
  selftests/cgroup: Add tests for zswap proactive writeback

 Documentation/admin-guide/cgroup-v2.rst     |  22 +-
 Documentation/admin-guide/mm/zswap.rst      |  11 +-
 include/linux/memcontrol.h                  |   1 +
 include/linux/zswap.h                       |   7 +
 mm/memcontrol.c                             |   3 +
 mm/vmscan.c                                 |  14 +
 mm/zswap.c                                  | 322 +++++++++++++++-----
 tools/testing/selftests/cgroup/test_zswap.c | 153 +++++++++-
 8 files changed, 456 insertions(+), 77 deletions(-)

-- 
2.34.1


