Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86C2DCD5BD0
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 12:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CFD46B0088; Mon, 25 May 2026 08:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A7AE6B008A; Mon, 25 May 2026 08:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E47F6B0093; Mon, 25 May 2026 08:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6DBA36B0088
	for <linux-mm@kvack.org>; Mon, 25 May 2026 08:22:59 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2692214023E
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:22:59 +0000 (UTC)
X-FDA: 84805856478.30.EC01881
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5E3C712000D
	for <linux-mm@kvack.org>; Mon, 25 May 2026 12:22:57 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fvjwkMKO;
	spf=pass (imf29.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779711777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=IwuURQBEyX2Ow+eyi17IhR1pDynYjLjI1eOjjb4C8q8=;
	b=cZUtc9/nuILx7eZC0+VnU3r6/hD8tKaTgRS4WTaUzW8PAtrSPEGFoxFLt1t1b2nMuvEUx1
	xTBgHbdmBhVzQ1jVJ4QskuDXEWkoVURLpnVxkT9BHgD97taGGsHTPvyl3C8P5gR7mmCNvn
	V8KAqGEbuBMQZp2SQXRweVzdMI9Bwv4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=fvjwkMKO;
	spf=pass (imf29.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779711777; a=rsa-sha256;
	cv=none;
	b=hntEwRuda54nCbqWA5KMbM6W+6VlNu23FSrSE6YngeOyIsfDPTOAhGTP2vk+Ay655iiAUA
	1VMZPZ59rPgQTRVibg+hRVS7g1zMJb3wTbboJWCVeAPn889GGO/SLypnv3n/KEq2t37GAD
	qD3YxE7rHEtS1j4q4D61WARzN+SU4tk=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-36974217d4eso6230029a91.2
        for <linux-mm@kvack.org>; Mon, 25 May 2026 05:22:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779711776; x=1780316576; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=IwuURQBEyX2Ow+eyi17IhR1pDynYjLjI1eOjjb4C8q8=;
        b=fvjwkMKO+d8/W6pCp7oOzuIqrboFGs1Vw2/yN6j/nq0lL0TLGMOfhhaMS6tZkEz8ss
         XkVxV49uBmiDZc7kcYCtTvs2ETPa2e/LG3vUoGWAtvFOgwJTEKrGYZ4yOe2GCN7SHVq3
         YrkgCTBFeXCjgvd9z+dIuuqpc6EZEiiPW7KbVWRPha2//Az/hgn8L6CIzPyt4lw/XaPr
         myhGIienZPtZdLLzDutWWQkRC8D3gvZjl3TrNs7dXTOwLT5BQEWX5U0KVQDhyNVa2G3W
         VSdiruIKF9e9i5VgpURRqM/Bfx61d9fp6GsCiWCtlHIYFhQAI96UlYpVXoXbcJ4itbmc
         kK6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779711776; x=1780316576;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IwuURQBEyX2Ow+eyi17IhR1pDynYjLjI1eOjjb4C8q8=;
        b=Agi1m+N/G+3qwpZAH5riYVvsC3b2U0tW2cNi4sFEM5We3fuiu0ceu60kOsocBTT4KM
         vPiYaq/+eLUVtQEbnGIcJODsJZr5pe7xOwfGUQaTAyy5Up5+i1BcN2UrWfB62/8iBcVO
         6kqcFgmsJa8EYaU4kgYQ/hYDmDf+BgBhMYB1i0loRiw0LMvifhORB9CfUuAWbaOuiS0P
         sPW4KR68M3k/mc+IVyge7nUD2RnYkn3Qqmuvkn/GizE1k2HQQ5OcdKP8waArEgCsyEp/
         ym8RPNgwjUN+AoHVkDffoaSSP6Lr3MhLtVfLBC6OtrmzLCEtbub6/SiOZpIXSNGG70f0
         jI/w==
X-Forwarded-Encrypted: i=1; AFNElJ89bm9jTZldjCYC4M/9bZdCqfEZ22l+NdQEZ6ympx3Bw6sqbu2dOdlSfIvDzFZNeiYw1BuZ1roQbg==@kvack.org
X-Gm-Message-State: AOJu0YyCacpKNIEedfom0GCexf4elOiB5JvdLuJonl3xcBEwjBWI3SL4
	2X/efB3mK9CbKD3oq3nybMdhN/98GPojAHRI7w1Z1ZjswwfGMOfR51Q6qwcocA==
X-Gm-Gg: Acq92OHLPCSIaqMdyy3gTQGeeHfMFEzw4ZLz2lOUq8nz1ynN1vnuCnSzmQov92UYmu8
	FzK1pKAXCx0QfjKlIC/oqBQ6w2uoJBYY/DpAZ+V7752lyd9pjNjCmqHrftPLWiOECoWxqnBkZSQ
	OUqun50GbWKeyBPkoJy0nIgDh6taBQO19cqKWUsTEl0ZKaDWld7U+NAGJyKKsEyoZAgoEpYV6v7
	aIINrboFWkFexiyW0xuBl0KYL/PLQO21dMx8p6w1WkeUsCo+x4dT7ct0ELg1icJItFVNWOqGqXu
	p4t/chRz+jO6kWT5b12HGAFo7cFHuhzimRPLnKV7NPX5gd1AfkOkHvfgBKBNMIOdnK0hoYrshcI
	mV83CldOPihOakj58JW1r/sHo87VwlsoUBXPtBGlwuPHnrLXDsTiuBw6mESMTzQvrkSpZKPhiA8
	j4XwvPM/HG6JXSJAP67/Gv2CIyAWg3S1GV+HS7FIB/h5Tae+CEPo8=
X-Received: by 2002:a17:90b:384a:b0:368:d839:28d5 with SMTP id 98e67ed59e1d1-36a677fd1f8mr13345191a91.18.1779711776032;
        Mon, 25 May 2026 05:22:56 -0700 (PDT)
Received: from localhost.localdomain ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36a72c913a1sm8999131a91.15.2026.05.25.05.22.50
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 25 May 2026 05:22:55 -0700 (PDT)
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
Subject: [PATCH v2 0/4] mm/zswap: Implement per-cgroup proactive writeback
Date: Mon, 25 May 2026 20:22:38 +0800
Message-Id: <20260525122242.36127-1-jiahao.kernel@gmail.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5E3C712000D
X-Stat-Signature: qnufd69fbgryaexyuju943w68jk4g4fd
X-HE-Tag: 1779711777-731275
X-HE-Meta: U2FsdGVkX19ZIZnY9GW6WazLjOrfk0YWw8pyzlBGsj8fMZICBiJOabM5zJc3xZ1nopboOAsy/JziMn8utWeHf1AEllSzYLYIbnRUVh1BIqhxmD+tcVW0Pbw26aqBl1J7NnwY0lIfUeYpg/qygrDEyaK++i/RkZXTRUsCapMk+zz1TlNTfkXOZIwSQRFFxvlX5y/PDXq4vyeR9RqyOQpKycIXaclsCSlNtmYcrH73Ksqw6WvaQ/Y6DIy74Dz329E1y/8IqmsMgc+gEVFwUmBekNLaeExUrLSge8EpcESLJpiZa+zWfsNTD7KfccM+mpfPHUWmu8wCgimRNGpIB9jF9SlshlE8OKrvIiXNPwQlTU1wDbSsoqpf/nYgs3O7cFX6TLIcFAuc9NJQCZBns45P7zEi913Q/9ssiuujQZZtDsOuqwdtas2WaxspRd8DTE497bKnxwYGi0Om5fllFlrINJq2QEv7iebIR7hO0bVlugW+HYJDrArcH2BbPbTn6xyplCbLEBHM5GDgU7kHYzIBPJxxowy52XyJmPGKdArwZsyr5YLg9JY35i30Ri5nRxXBzSVYVFvRBPAKJdoqxOR029SZKvp3kABeOqSCeAMiBFn+VqkPYdh1QbfWOzXBul8NqFNM+wh6vnt4nU1le2S5yDPEcvgwSX/uShZUuYgBq5+g8okz5fdlNuovVQ2QQiy7vi1bOPE7ueoLjMVqqw/1vhf6mZAYtp0H1m8QE9WT8jJBcPaeZPHz6rzt0G9FUS/ItUTcwpuAr2oBhO33eO5j+8JETGAKHuJO3RKP8RTveY73gwRSbj6q2bb8EsCI03yShoObG8SF9pw7pYc9tLKyErF5261hBs8pV90+QGPCLoz7ATkuD9MZK9sQNL3ek0Ntk21tYvQ7b/lc/wgVx5LFOPuCCOgyxSlg5Ho3x6LztPRUNl658q2d0iytwYtDn9UzzP4PtZ8G5f/Oxiv3QXp
 nczUj6av
 LrTG83JXvtrYFuZ1pcY5BcO1g2DhePLp1o8T9YjXPatrvwabx18wPB3Aqcfs9YnNebVxpxnn6Qmd1YG9LrmJhtjwCx5h/HeNa7xrYVtq0JDhrWeROmpkYOuB1mJNLGCVxXWtLn92oWx+aYMZaLhTvJHUwG4MXW4Zs4cMVymjqiyNwhWJCrMcT8bZqTV/oxwedaDMEkjwDukb8dwmYPDIJJ9Hn4kvsBngaPCjLGNN2KOFpCKP4rJ3S0kkhVIlIaanW9f72XgsL09InMLjr6AKHst8pek8JsYZuf36kc1cb9d3iOC6Zzno/o+1AP2bCrO6kzZOjSAN/SAtTBzv00YbEssOt2sN85JLSfKsxEXUIW6Nv7uR04J2JLOSrEaktzfhgkFx4ea/hEgwSEKa3UQWSDk4HUVJdpPu4L1LdidFlwLRqXEAsKF8Mwxr0HCoC2osr69y4TxyL4Vw2llriWV3eqJeD5LvWKhyTe2ovG86jHY8ZquAcBK+wlmRMpb3cSrVzanD8OFn5wUjhYSRIkg1Lk8pSk82OpuwpFfpFrLfIchTY8DWJeeWKEnMSgg1hHoAqE9R6vbdChRaLmAm5Zs+KZsadlMRVjq/TzxHXOHUUvNIWWAw=
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

v1->v2:
    - As suggested by Yosry and Nhat, extend the memory.reclaim cgroup v2
      interface with a "zswap_writeback_only" key instead of adding a new
      dedicated cgroup interface.
    - Update the zswap documentation and add selftests for proactive writeback.

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
 tools/testing/selftests/cgroup/test_zswap.c | 161 ++++++++++-
 10 files changed, 470 insertions(+), 55 deletions(-)

-- 
2.34.1


