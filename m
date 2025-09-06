Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5AB04CA1013
	for <linux-mm@archiver.kernel.org>; Sat,  6 Sep 2025 03:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A4338E0002; Fri,  5 Sep 2025 23:21:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67D6F6B0010; Fri,  5 Sep 2025 23:21:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 590C18E0002; Fri,  5 Sep 2025 23:21:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 488D46B000C
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 23:21:35 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C1E7D13AEA5
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:21:34 +0000 (UTC)
X-FDA: 83857375308.25.7E88973
Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	by imf16.hostedemail.com (Postfix) with ESMTP id B860918000B
	for <linux-mm@kvack.org>; Sat,  6 Sep 2025 03:21:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nPOx88R7;
	spf=pass (imf16.hostedemail.com: domain of "prvs=33770fdbf=ajgja@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=33770fdbf=ajgja@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757128892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ukV1P46xm4LSs6P9dPGvdjimOnGmu5wrUw+EGUHyxAE=;
	b=oeWT212eGpfouW1qZGWPDjeEoA+pX53feIZUEOrbH3yLU5cJUJxXL4DV4RBrIaE6Rq1Y10
	hAGbWKTznjcRx9tVYeroXL/J1H/XjTnSblcsWmIPlXIfmRWk0SIlBKapThUK875VasyMlm
	SGxMP5zUh06G4ngYK+JMqOS0NRODy34=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=nPOx88R7;
	spf=pass (imf16.hostedemail.com: domain of "prvs=33770fdbf=ajgja@amazon.com" designates 44.246.77.92 as permitted sender) smtp.mailfrom="prvs=33770fdbf=ajgja@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757128892; a=rsa-sha256;
	cv=none;
	b=oIeCrSXZVbDB563L/x/6G3ThTRpCaU9SM6QNCpvAw6qS92FlhDwIY0Y8g1BtMI+fjESzrM
	A1O92MCMKaJH3Jq/1wF/MvhrnEZFeu3XfAvhJW51tVMFiB/xnD1ymtSNiRQa+UALpPQmdM
	YaJMRvte2m46LjbUo3oFEK9tIYWRzD8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1757128892; x=1788664892;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=ukV1P46xm4LSs6P9dPGvdjimOnGmu5wrUw+EGUHyxAE=;
  b=nPOx88R7xmye1MYC0TOlNT739TuYt6I8gknMHVpGtGGQYErQsm9Wwl5V
   3rSW1nh4QPynrILpQp1MmBf5MRX7yF/yc0p35xMG1HwRKEzVHff3GczlX
   9E2wxWUgW1fDaOU2sDUm2obS7XJcupyy9GQxQbC4NPxknzxhYseRgL7Ae
   uLvuZonEZGqAQf1LbJAEwZbykCswU4uBTeGv8t1RkqTcQ2ajMor/pDksp
   CJ4cvR+JfTdxOo7E0D9ZxcoSnz15oHzFgdFYN7n5/kLR5nkr1UGUEITnM
   0irbee8/nFtls8/MSjougIsMDbA3drCBOCeNTqhbj3mZ46IQzowG2RXaI
   A==;
X-CSE-ConnectionGUID: 0UUPTMG0Q8e/TgRO3JA41g==
X-CSE-MsgGUID: zGTnETyJT0+2svpF8rOm2Q==
X-IronPort-AV: E=Sophos;i="6.18,243,1751241600"; 
   d="scan'208";a="2522412"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Sep 2025 03:21:31 +0000
Received: from EX19MTAUWB002.ant.amazon.com [10.0.21.151:28382]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.63.19:2525] with esmtp (Farcaster)
 id ff3684f7-82cf-4557-bb86-378b3641385d; Sat, 6 Sep 2025 03:21:31 +0000 (UTC)
X-Farcaster-Flow-ID: ff3684f7-82cf-4557-bb86-378b3641385d
Received: from EX19D032UWA001.ant.amazon.com (10.13.139.62) by
 EX19MTAUWB002.ant.amazon.com (10.250.64.231) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Sat, 6 Sep 2025 03:21:31 +0000
Received: from dev-dsk-ajgja-2a-6a9b5603.us-west-2.amazon.com (172.22.68.79)
 by EX19D032UWA001.ant.amazon.com (10.13.139.62) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.20;
 Sat, 6 Sep 2025 03:21:30 +0000
From: Andrew Guerrero <ajgja@amazon.com>
To: <cgroups@vger.kernel.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>
CC: <hannes@cmpxchg.org>, <mhocko@kernel.org>, <vdavydov.dev@gmail.com>,
	<akpm@linux-foundation.org>, <shakeelb@google.com>, <guro@fb.com>,
	<gunnarku@amazon.com>, <stable@vger.kernel.org>
Subject: [PATCH] mm: memcontrol: fix memcg accounting during cpu hotplug
Date: Sat, 6 Sep 2025 03:21:08 +0000
Message-ID: <20250906032108.30539-1-ajgja@amazon.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [172.22.68.79]
X-ClientProxiedBy: EX19D037UWC004.ant.amazon.com (10.13.139.254) To
 EX19D032UWA001.ant.amazon.com (10.13.139.62)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B860918000B
X-Stat-Signature: wejhrkz5aqupqn99g148gfqec3maajzd
X-Rspam-User: 
X-HE-Tag: 1757128892-962290
X-HE-Meta: U2FsdGVkX199kQbN1tgOS32J/0I2aM6yXV7tjfWHZLHy6zm7rVlx8nEdKfspSd62lANA3vpuaqk7BldQpkjoFJ9TLuJH54u1MmDs2W1oUNp6tqomNScNJ9mCLUx6upTtMGtalDbvZUFHhCawnvaZWEsqKBRFL5jW15lTPnwGb2c3FvLp4XEUk7UwgES6Uex5wj+E2gauOFNxAYuMnW/HnlAqW29a8yzIy7b1j6ZY9Krx14IwMzABEPdxK8kqsx70b0TrpShLTjs5YW8e4gpaHMU3VbqgETg60MQRK5s2OM3xSFKmFAZsDMcK6/paJdpsmqsLClF9Sc9Ftqgpsu9bCmK+SJAjK4JxTq5xRvWBSSKU64+t4XcXdDdksAG92J0TCilFlQDfmAMDid5pF9xIbUFax2BFmOddZ561Z0ty3QI5SPjpKoC5lYjLw9WUgQaEd8NBDf7QkOzLb9Vn20xM9XZjdVPm4vajaQD3YJCfFXdHglwc/P7dVq2V3kaOseGQg/vChmCSHM4ygYC3rF4E5q0Zv2b+syGtoNUYHmazKvUVACN0SRGS7K4b14/hFmmMik2ZL1QvbNgS3tTSGZnZXH0V+PUgSjp2XszI/bNEDJLdpnxzELj5i5IaApQycr5XM3BPnjb7UN9GMVVBWPLIHMRbbJvN1YZJhM5Wdg0MKd/QHeIarZEdGXzvNgcMelY1bQ71lR6RwE0Y2LmMs+uw7oNltGO/sDaSxBYeIbNKcV4szmOCts0jKumUiG2zN35oZ3N8L7DzuorJVbTubLBstxI4+2e7zK/W6v1AyJPUOBwzD3ly9rL19K0QY6/lmfs3UyDHaiYEDWC8jTPfvhUesnzC66Z99r4TSSLQ1s857xJNLlLSeQnJcIKqiyJjm9OQAFwC7i1q9P1LwuH46TUeMbrn5Ef8MIdI/fY+yVHMas/wyzU6YiLv3k5Abb5EqeOg7aRfpBhkLIrpmX6HaAb
 UmxVktHz
 619tEbGJfafdU/aXI/1yBbFmpnDEsFxQE15M89QZJtndl9Kpq2VEiv/XT5hpg1vdDTw7q3Wxe/Ao5NS7QZMbmSZuUksePVT4bD9oOLPXWVeGI8hybvAFWHiKHB0KZarYa995OdoDyivXt9WZK/9UA7TtexGSBQn6yaLMx5GWEVCYd3fShto9aqaByAeAfSqLW6LLk7VO2OVU6YGNgvprwJ3/R91fvXSiPKGkhTxwvmrg8WBk0wyWNvBB0D+qVALkHS2KKPap9AllfTKicRVSPVDUXG8gT441XJX3+fARI/aAOPHq+Szwwr3F7wlMzS2al13Uj9yJi6JmmaJ0u+x3BPdIYhceTBwfdHzAiXik0O4tYUh6mIvxxYVdKN+AyVcoh4VY5eX9rWpDYBsHIMcDDAQapg3IVa/rlZDuqAXsCWrdSGS2hp0iCE9hVpogRsQpWYn/7BzaPOQNL26aAC9dtfmBoPuNCx4OYoOBizxtQ9K+FFHwzl6RN/rGzUnkQRgUPMvAJQ9T0fgtBkntXoTalD4qPrG+7kDUvH5abQK/sZv7hGnX+9H+tdQDsXq6cMfOrCehBBMYtmiUlNXyPANrjI/rriM5DNW9JP5Ea024NcZBuvOpigX97tCkmKett7GpMZwUY9jtWJuMrYf9rzULG0+m6ymDjoCt3caEA3DXGWCBnF0YpOtBpADqvU0Pv6gdsmwdNs86oEOUCzbZzgyCH2syiws146BxaI3JT
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A filesystem writeback performance issue was discovered by repeatedly
running CPU hotplug operations while a process in a cgroup with memory
and io controllers enabled wrote to an ext4 file in a loop.

When a CPU is offlined, the memcg_hotplug_cpu_dead() callback function
flushes per-cpu vmstats counters. However, instead of applying a per-cpu
counter once to each cgroup in the heirarchy, the per-cpu counter is
applied repeatedly just to the nested cgroup. Under certain conditions,
the per-cpu NR_FILE_DIRTY counter is routinely positive during hotplug
events and the dirty file count artifically inflates. Once the dirty
file count grows past the dirty_freerun_ceiling(), balance_dirty_pages()
starts a backgroup writeback each time a file page is marked dirty
within the nested cgroup.

This change fixes memcg_hotplug_cpu_dead() so that the per-cpu vmstats
and vmevents counters are applied once to each cgroup in the heirarchy,
similar to __mod_memcg_state() and __count_memcg_events().

Fixes: 42a300353577 ("mm: memcontrol: fix recursive statistics correctness & scalabilty")
Signed-off-by: Andrew Guerrero <ajgja@amazon.com>
Reviewed-by: Gunnar Kudrjavets <gunnarku@amazon.com>
---
Hey all,

This patch is intended for the 5.10 longterm release branch. It will not apply
cleanly to mainline and is inadvertantly fixed by a larger series of changes in 
later release branches:
a3d4c05a4474 ("mm: memcontrol: fix cpuhotplug statistics flushing").

In 5.15, the counter flushing code is completely removed. This may be another
viable option here too, though it's a larger change.

Thanks!
---
 mm/memcontrol.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 142b4d5e08fe..8e085a4f45b7 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2394,7 +2394,7 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 			x = this_cpu_xchg(memcg->vmstats_percpu->stat[i], 0);
 			if (x)
 				for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
-					atomic_long_add(x, &memcg->vmstats[i]);
+					atomic_long_add(x, &mi->vmstats[i]);
 
 			if (i >= NR_VM_NODE_STAT_ITEMS)
 				continue;
@@ -2417,7 +2417,7 @@ static int memcg_hotplug_cpu_dead(unsigned int cpu)
 			x = this_cpu_xchg(memcg->vmstats_percpu->events[i], 0);
 			if (x)
 				for (mi = memcg; mi; mi = parent_mem_cgroup(mi))
-					atomic_long_add(x, &memcg->vmevents[i]);
+					atomic_long_add(x, &mi->vmevents[i]);
 		}
 	}
 

base-commit: c30b4019ea89633d790f0bfcbb03234f0d006f87
-- 
2.47.3


