Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E702C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 06:38:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F372F6B0109; Fri,  3 Jul 2026 02:38:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE7256B010A; Fri,  3 Jul 2026 02:38:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFD3B6B010B; Fri,  3 Jul 2026 02:38:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B24526B0109
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:38:47 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 144EF40448
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:38:47 +0000 (UTC)
X-FDA: 84946512294.28.6568FC2
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf15.hostedemail.com (Postfix) with ESMTP id D23F0A0009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:38:44 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IlPBo5Ep;
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783060725;
	b=igSI8BxKQkJ+o+aWWN2l6Cld82pRie3iIO5/D062JuhXdRDGnNaJE+rUqJFT/8W1zBRRSs
	I/UH1Kx/rqoW9xc9dFA4q82aXTPTUvny8kWlFForJkzWOqi/udn0P7fvyfNBzjr5kJ8GPB
	exXR9vDQhqpmpevkqGY9j1izoZAeuC0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783060725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=z0NILGVMEqCxDUwwsKsa9n9qfS5/GPIbQstMynaSZY0=;
	b=mFiO21c/W5zduhCm4UnTC/CHkX2Zk4KYXgD2/Ojdz8FGCRfVzp8uoKwrN/dDnqOR0BBvNf
	3V9ZbQwKjC98a0HMMb7+ZlTTa6BbVyoPzwwagQL83T/AzDupuAxD519R61fwZPkab83b8E
	bupfdZXnt/VMTGg+ZspVqeOZv+XLroc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IlPBo5Ep;
	spf=pass (imf15.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783060719;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=z0NILGVMEqCxDUwwsKsa9n9qfS5/GPIbQstMynaSZY0=;
	b=IlPBo5EpD5UJdecwEsnJy88CIxXeca2so8Drk7Be2zX9Vee+P4m1ajEMdFd+al5Qn6usSi
	xddm56PP7uTa2i04ZG1qXVQ3aLiylCYlRONRgTOd99jR27EvTy/w2nxXSnhJMP3MI7YsDK
	Xb+35SN9RVjLvVR81vgrQ7IfLw4pe+s=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Tao Cui <cuitao@kylinos.cn>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/2] mm: memcg: reset zswap settings in css_reset
Date: Fri,  3 Jul 2026 14:38:23 +0800
Message-ID: <20260703063826.306878-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: kqhfsseawnhrc5sprnycsaq8aft9fpsh
X-Rspam-User: 
X-Rspamd-Queue-Id: D23F0A0009
X-Rspamd-Server: rspam05
X-HE-Tag: 1783060724-321015
X-HE-Meta: U2FsdGVkX1+/px+zra+1NMvX2ftety4Kk5K6Q2nOSosex6F9HdQELU6jZGXMNWGnSPgcGpOHc0H+Yw/SvUa3+GARjE50RPe8LmSfVnImCd03/e5nY+Aq4Fz10yBp7mXlEQfteWb9UdyoJBmg1xvEk/34zllrBye6ER7/PYosn/X80Hdlhmq6GyOrpwD/9xTXETOpP8H04sPW2T5+HJ6chjg65qMplc+ZeJ79abbZaxwy5t6pzLI4j/j3MxeRpY6muUqPtmte+zO973tJ+6gv6TfX8SNBm68JowP3Ga1Sy+237T4VClj/hff9LZFjCxm0eCltQgHBfUHltcDOOrXYQkGFS9eKIwNOzdQ57/q/UR85ecGxD2pMNYKZ1nhtpcG47szBUZaLHZY50DwbEaymZ0vYjIniA8t2MaCmrly7BrLmsFz/5eqbc4ObuY98S0PAufiE+NHcXY1OZJ8TWrWpZbuAURF81TJ2gj/wyLDuA4xxd9gxypzAkWxx8Pl5IUijO3KNnwkaNCRiV8/4LM9Q49uBON/ZGo8nKjqTCtxUugV5/62wTdaNRz47FJ+8gHAReSQd1upkXvd0+Lhph9sC8FMoj/Fz9VXYmLv7RFTzL9jAItSAdSat4Zn1ZnXh5G5aNZzlTcypgk5hf5kbr7VZGlJC7MGe/Ol95V+JMSZM429yw1VFumKiICF29646yxyXLy1H4TKVYi366q2FLAJctpReUlQcPVLaTFMms9mQQ2MDaIt9IaPaWGFjwvCDbEQPCEJCoDK3LEWvgXt4SL7hPmBmbMuvnY4LhgcONcISLbgVQRULFPIQBdom0L2wq2anG4tuOzogPIAunQ7lvmT8QDIvTUsUR+QrZlBhBVw6owTXEtH13sdi1FoWeiUT5K3sGX5adlfZfapCpNXKOMFYmC0xtpWMspwt+24Wl4e/mH5WIpiArwOjq4vrKgwMrpIYOhn2KwTwhzzQ6G7L9Zm
 Zby0QDkB
 w1TE2QPzExA6XFbFkWcsLxgIxDHXoB/tcyKPc+Wrb6TFfxVnXD2Kiu3z3BZixZtEsJEBGxC8NsJn0zzIwgJC50JX7bWXseB/d+Fq0EA4rgi10chKO7dE37dvYfNwIJzYKKfeDQEKFSYLCYUxkr7omxsAsVKJz2zzd//CMKpBsjl2885njwioEreL+QHGoQrcdMfHJBFQDjy0AlvJBCIK2+xmH5yGUhQZKEaQ5eRXYEBejbsCLn3QPeKwOIWJMsgnR5CDOUsd/c9x3WW+VitB/sdnfyUGF2zW6porNdEZdm/zFlzHFlpOfd+jnB2E340I032B1K7hfx/EzRTM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

mem_cgroup_css_reset() is called when the memory controller is disabled
on a cgroup but the memcg cannot be destroyed because it is pinned by a
subsystem dependency -- for example, the io controller declares
.depends_on = 1 << memory_cgrp_id, so memory remains in the cgroup_ss_mask
and the css is hidden rather than killed.

The purpose of css_reset is to revert the memcg to its vanilla state so
that no policies are applied and the css can be safely made visible again
later.  Currently, all page counters (memory.max, swap.max, kmem.max,
tcpmem.max) and other limits (soft_limit, memory.high, swap.high) are
reset to their defaults, but zswap_max and zswap_writeback are not.

These fields are initialized in css_alloc (zswap_max = PAGE_COUNTER_MAX,
zswap_writeback inherited from parent) but were missing from css_reset.
As a result, stale zswap policies remain in effect after css_reset: the
zswap charge path (obj_cgroup_may_zswap) continues to enforce the old
zswap_max limit, and the writeback path continues to honor the old
zswap_writeback setting, even though the memory controller has been
"disabled" on this cgroup.

Reset zswap_max to PAGE_COUNTER_MAX and zswap_writeback to true, matching
their defaults in css_alloc.

Test:
	echo "+memory +io" > /sys/fs/cgroup/cgroup.subtree_control

	mkdir /sys/fs/cgroup/test
	mkdir /sys/fs/cgroup/test/child

	echo "+memory +io" > /sys/fs/cgroup/test/cgroup.subtree_control
	echo 10000 > /sys/fs/cgroup/test/child/memory.zswap.max

	# child/memory.swap.max and child/memory.zswap.max disappear
	echo "-memory" > /sys/fs/cgroup/test/cgroup.subtree_control

	# re-enable memory control
	echo "+memory" > /sys/fs/cgroup/test/cgroup.subtree_control

	# before this patch
	cat /sys/fs/cgroup/test/child/memory.zswap.max
	    8192

	# after this patch, same as memory.swap.max
	cat /sys/fs/cgroup/test/child/memory.zswap.max
	    max

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Tao Cui <cuitao@kylinos.cn>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---

v2 -> v3 : typo in commit message and add Reviewed-by tag.
v1 -> v2 : add WRITE_ONCE.
https://lore.kernel.org/linux-mm/20260630100832.107062-1-jiayuan.chen@linux.dev/
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d20ffc827306..c20ef3c1d6fe 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4362,6 +4362,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+#ifdef CONFIG_ZSWAP
+	WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
+	WRITE_ONCE(memcg->zswap_writeback, true);
+#endif
 #ifdef CONFIG_MEMCG_V1
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
-- 
2.43.0


