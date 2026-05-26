Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C106FCD5BC8
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 11:46:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34A196B00C3; Tue, 26 May 2026 07:46:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FAEC6B00C6; Tue, 26 May 2026 07:46:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20FE46B00C7; Tue, 26 May 2026 07:46:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 142096B00C3
	for <linux-mm@kvack.org>; Tue, 26 May 2026 07:46:17 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B72FD1A03F6
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:16 +0000 (UTC)
X-FDA: 84809392752.01.8965A0E
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id EAFAE140013
	for <linux-mm@kvack.org>; Tue, 26 May 2026 11:46:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BFpY4Qhe;
	spf=pass (imf26.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779795975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=983/W68Px22eGNnSr2lTrxriWPgIBrKprA/JK1mMbWU=;
	b=6lnNy1V+1+CDh5huPZlHq0Oz8pMUVoFgO4cH49d1Hwej2K2GYMdbWpHugNzxcXRXS/mtIM
	NbDW1/XMe2Kwkh335MHev7jl4xbktn5r9Sv2Theo1c5DSy2MNnyKxRyE1rk+wvzRfgCqi7
	omkzFHeUjLJfOFTPulvZgEftt7cHEnA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=BFpY4Qhe;
	spf=pass (imf26.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779795975; a=rsa-sha256;
	cv=none;
	b=PkxWTs1KDLYbFotavpkf/RyGibN6zwlkfCRrr5GUv6o95PBE7a6CAbR6Wn/JuCp+H9DzUV
	xUCwMQMkLohPjmP/7wM6Hf635ztj6sk2SnT7tmcA6fV8OXYiA1ctFt/7lSsgVTLLb5k7a8
	TRogcmj3h+G3y46b8fK3U/8iBO2Huo4=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c8173b2af32so8169866a12.0
        for <linux-mm@kvack.org>; Tue, 26 May 2026 04:46:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779795973; x=1780400773; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=983/W68Px22eGNnSr2lTrxriWPgIBrKprA/JK1mMbWU=;
        b=BFpY4Qhecv926knraMRzEfHsmGig+2vC1lEtGdhd5xwftbp8E/4yQawtzSokvMCqL2
         QByf91dFbPnEetX5S2SfAH5c5RKZQRIELT9vETLAWC3VFB8LKUoUduEZPALTrh31EjVV
         G6pAEdnprVqRLloudgFtQrfC/LH2tIYdFhbtYHwNE1uORo4S2hVxA9vo9Sok2EXWx1MY
         SgsByS4E4R3Lx/1KZPtKsTmBPN5abDDhRnEPaz4HZDwHgcWozvUKqFV0XoMjtqLIvn7f
         Qq50Hx5IqIYZ84wUgz5kp6fuYAQ+xRAwZE2SAGQCQgpZB8vLheN0bLGK/Ta/I7c4Evmp
         eVQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779795973; x=1780400773;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=983/W68Px22eGNnSr2lTrxriWPgIBrKprA/JK1mMbWU=;
        b=nfFH4m4GplAAvLyXeywCCbJvb+9cxniL6rvCRrqH50CGTecs+wNpMcefelpbcFyUHj
         5sOOk29xFhNVlUnwzqZF37Nf4uC8pWO0v4WpcugXEBANEcpIyqeaFeLUXAvLTCffREBS
         rxDWhp+LCK5X3ObaAduAGQEZ53YWEgFW3dBb69o51tG1PCFAFbvsDqkvoD5fvt37+TID
         mZoFTE2zlen5KZK/kKkTmDBow0C8rxxXrmxv1rTluX0j4yhI12cH/dYKzF8mQ94NofMn
         S14O4j8/1osslFmJj0swJ9mvvfsbFouojDVJ8AFxgPO2cXB4TWApVGoxhFUay6ZXbPZp
         bDzA==
X-Forwarded-Encrypted: i=1; AFNElJ8Eyy0b+gdU0Zv5aAZbzvQV65Z8qGiheK9aXxFj/WYLpuULqYACBmfSC5heJVSaKePiUAbMFzOAmw==@kvack.org
X-Gm-Message-State: AOJu0YzdasIqn5PJggqRudqMI2+UNM2BSPvGWcf78WP9GB9FLG0cgCkv
	qKWBT5prjPLXAu2QnV71EdnbMtCbtCbr0AsGqGjdCcPRAG/gSKoj2cKw
X-Gm-Gg: Acq92OHjHaGfk6qymEHQNKZ3/d0nRTJ+HXg/Pm2Gt7FTu9UbJLOJB03BNpJdP2/1Rxv
	iytKS9ppb11dpy6wUqHIzkASQ2NUEsDL+xt7w5/EMPWp5bp47L6VBb+P54Jl93XR8kKNyfNGbPu
	Mn0qW2gaXB63Xb+KUVUUz0ZUc9iH9Nn57TgYHr4jX8g6aGp7uqicjUNuaDVQ+Jq/rUCakwSab54
	36PTq70mI20MzMJtdB4TaQMDPV3yAiKSOmyWPMjmW/LZ3jDiYAp4D4hEHR0msFcFtOi6WJAGatn
	I8uZg4IgrkG8Fcaal0mhMnyIDG0DbbJdXUUSYozXOxMqFdX2KQUZuqXGFkWns7w1wJOcqpw+99M
	9Q4Y7Ajpue3yxEQNFj1wxbfq2D8pW6peAfXYr3eNSzpFXNbSn88PMr23sIc9hemQFNHletbZhK/
	PyHKBkBnLGRnhYu4r0ex7kcOU8XhKCjzkHZubkT5odDMtXrcOIiCc=
X-Received: by 2002:a05:6a21:a45:b0:3aa:3fbf:d0a3 with SMTP id adf61e73a8af0-3b328fb7b6fmr20340231637.47.1779795973481;
        Tue, 26 May 2026 04:46:13 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c852028fe99sm10304341a12.4.2026.05.26.04.46.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 26 May 2026 04:46:12 -0700 (PDT)
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
Cc: cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: [PATCH v3 0/4] mm/zswap: Implement per-cgroup proactive writeback
Date: Tue, 26 May 2026 19:45:57 +0800
Message-Id: <20260526114601.67041-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 9knnw3hm7oqs1mhntae4ohm5co6jhbhj
X-Rspamd-Queue-Id: EAFAE140013
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1779795974-420201
X-HE-Meta: U2FsdGVkX18V6DshW2c/BxwawFF7f4YsTUyq77hc2KZ21s3Q9XQfKGWfo9/tEM60yB37pg85A1WPQ1z0156S0AFAkg3vrxlbkgkWNwrzDOkiFNmMRieIsL8dNYRvP5qYDR3PG2Hh2GjHAvEbAzM56BQxBedb7sMToh2t8zwyawxycJMvXLZQxPnygghpNk/FtdKh1hcaUd2hhWrV6YtaIhK7/km6r7SLVSHfOfSezlqlWlAfxdzm4xDbiwEZLTDh4CwRB5wHCY0e6Y+gARVKurLczfsc1E4kVGE6rJFkiEMvBtNjRZ6ylnmLTgkleavX0gqLvOpPk/sPs2aduZO4UbzYyjDW0+bvfLu0Rba+TiNOIFCzuKJbAVghigYs9znS/9xLfDIQD3syw6gI8VDlBdbRhGuREaosRgocK/wyYZIu7FZHjPXylA6qZG5P6zQ57+jbZp3Gxk8yI+b9v4kE9Z835Xbi0WyLMK/PmPfXrSNzUjKYTzw+SJUJC7voih9fm8K4XCAT+WdLZeIahvvRezKIEdzxzvOdqJ+M5TMfFWg1F+tFSxThX8CP40kF/5GtH1yeUoNWL/UPHvZW3a5Y1dWDwDxbqHFQQQy5eVW/5NyGLVDQlWkWKZ3UzifKCAinBHSdsMQhN6gxHKs8KQfJbk8RaAOV4TC30Wqxrp8acNx8ZJc4Bp9iRTyD/ZFtpOURwf1lncgM2/mJoMmcxRXWJNgdw88B3mCGxdFaoHyuN+6o4BiBJosI5PeOpTvMOtN+/+LJmDeWHEWL7hn8V7GAAoAkvCk+jUE8fD96OvCzhuhAJbZOvWOADGY4/U0PTkkPXr43KHiZkEXCxL19+gWYgQJ3LtDoCILHf8dzziC3Aihc7HothBTNGTPOweHRzl1pDIn/Fr+gWqcImBbQFtFEy7a7zIZlOqYv81NOSSQsC8X/skKxVQTdnbsN2ig18N2SgQbi3o0cE+xry2fH1mb
 j+c2TfUg
 cR/dqpOSjB8j2YF6LSt7A078heB+YjjEyL9WjZoiK2lvApC5AAVWAEaKs0TRFlH0koOOvwHHP3pUaBi1We4QoPP7dVdp+pgS2wsd/zlYaffbvrT+WXjUjS0reXjn2IcTSKhCsVf0Tdv0mdKXL3hLecU2bSqirh/c28eSJz3X37wKUk011VbGWFeWjD/P+PnO2SgGpkks3HvMVVYgO8t5ai2sc15vYXNwgxAQz5oQp6Lm+V7lzxxd9+KSpWOLIMbQAppApPuyESzVn67JgX9FU9WbaapqCW20ImbhThX19FAxkGXlwT1qpH/K5m3W2z8Bi+S2MlL9imY9gpCKJtrditjlzU0Us41rOXnp9C1XrMKCHS3qq8ETB10hKGbjF+4gtHQmiLDWYVkJukYmScaehxRepVozEtP+gGj1tf02+F3XJQkdEpWGwZGCLwocybOQMZkti8nCIGDi2UHwYxODcPYOgGtKkKHbPI1MUlworf2L47VAJiUzq+S/UjhxH6tHjDUdsIMtTvshEPPLAqLbgXbKvFU9v8Un9ziqkq7tkVYLO72Iumb1zkElOgvpw86sOgxL3tcgYgpOXSl4acU6fsdHuNPBg2go+6b7GZ7DqXESKJ0I=
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
pages from zswap to the backing swap device. When specified, this key
bypasses standard memory reclaim and exclusively performs proactive zswap
writeback up to the requested budget. If omitted, the default reclaim
behavior remains unchanged.

Example usage:
  # Write back 100MB of pages from zswap to the backing swap
  echo "100M zswap_writeback_only" > memory.reclaim

Patch 1: Move the global zswap shrink cursor into struct mem_cgroup as a
  per-memcg zswap_wb_iter, so patch 2 can scope writeback to a given memcg
  and make forward progress across its subtree on repeated invocations.

Patch 2: Extend the memory.reclaim cgroup v2 interface with a new
  "zswap_writeback_only" key, allowing users to trigger proactive zswap
  writeback up to a requested budget.

Patch 3: Add a zswpwb_proactive counter to memory.stat and /proc/vmstat
  to track the number of writebacks triggered by proactive writeback.

Patch 4: Add tests for zswap proactive writeback.

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

[v2] https://lore.kernel.org/all/20260525122242.36127-1-jiahao.kernel@gmail.com
[v1] https://lore.kernel.org/all/20260511105149.75584-1-jiahao.kernel@gmail.com


Hao Jia (4):
  mm/zswap: Make shrink_worker writeback cursor per-memcg
  mm/zswap: Implement proactive writeback
  mm/zswap: Add per-memcg stat for proactive writeback
  selftests/cgroup: Add tests for zswap proactive writeback

 Documentation/admin-guide/cgroup-v2.rst     |  22 +-
 Documentation/admin-guide/mm/zswap.rst      |  11 +-
 include/linux/memcontrol.h                  |   3 +
 include/linux/vm_event_item.h               |   1 +
 include/linux/zswap.h                       |  16 ++
 mm/memcontrol.c                             |   4 +
 mm/vmscan.c                                 |  14 +
 mm/vmstat.c                                 |   1 +
 mm/zswap.c                                  | 292 +++++++++++++++++---
 tools/testing/selftests/cgroup/test_zswap.c | 155 ++++++++++-
 10 files changed, 471 insertions(+), 48 deletions(-)

-- 
2.34.1


