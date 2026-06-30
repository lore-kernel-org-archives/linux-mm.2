Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054E0C43638
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 10:09:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F41326B00B8; Tue, 30 Jun 2026 06:09:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1A3C6B00B9; Tue, 30 Jun 2026 06:09:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2FA06B00BA; Tue, 30 Jun 2026 06:09:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BDB676B00B8
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:09:07 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 1552812043A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:09:07 +0000 (UTC)
X-FDA: 84936155934.04.E6E6600
Received: from out-188.mta1.migadu.com (out-188.mta1.migadu.com [95.215.58.188])
	by imf30.hostedemail.com (Postfix) with ESMTP id 3EEC980007
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 10:09:05 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aRutZEds;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782814145;
	b=IIUKas9L9pVgl29UMX2iL1W7BhdhTnFLze4+jYT7qidVngQlK4VM6oGQ9fw+3HsD9/xIY9
	kHk7akxfz9zFbyl65g2Jq/HJK9jW6k1sBacpovs9Vhugu0kQfLARAdI66hb8QyNePAIlhr
	Ky0OjrNM6p6uruIt1E5sPRkEzAm61xs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782814145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FSNOm2q+3f3joQNb7BZoeC7qzDmBVHPFm6THuKHZtzQ=;
	b=twoaFaHV8ssR7kTJbsjo/p6n4J/1V6f8KdmgK6iCeFxVrJxtLvJCb4ow/ILv80vfTQIKZE
	0wUl73H1j50VxT4JAHaBMMGr7/Jni7vQPUk6KhrHJBU0Rrj1R5JeTvYuGYWDhqlSLmW8YJ
	vcQbJBJFM6DhhQTVX8Ok5wbmGedLgiA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=aRutZEds;
	spf=pass (imf30.hostedemail.com: domain of jiayuan.chen@linux.dev designates 95.215.58.188 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782814143;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=FSNOm2q+3f3joQNb7BZoeC7qzDmBVHPFm6THuKHZtzQ=;
	b=aRutZEdszElsjGKIZ3OIRCtw9Yav7eECm7lwEFlEZ0qblblQvKMm8PBwgWO74ZUcTT2CPv
	zwcexmcNBY94EpEZNwHg81ypFJ31cjtTLo16DqHaAXfrA5B18qpl/lH7qzZG51+u0zc/ll
	laL/g5h+Wp0yy/mOIrKkva5wUmb73j8=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@linux.dev,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] mm: memcg: reset zswap settings in css_reset
Date: Tue, 30 Jun 2026 18:08:30 +0800
Message-ID: <20260630100832.107062-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: za4xsu3c95qaf85iaukq4i1dubgeamdq
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3EEC980007
X-HE-Tag: 1782814145-824919
X-HE-Meta: U2FsdGVkX191I+AtamU1JNlz0PfDu2K7Nkzu+zaiIZCQ55f6joIGp1bp3DOiG/YPJlf4DqDM8/DyQUIfNQGP6FkWENO0noHrGruOhp9zWf2NDLL7EkDflga+4LG9ZaRN92b6Hx3wcXKhNDSTeMkfFkEzZvVTRNHJVV7ktH7VgbLj1ysJTcucoU+yC6PrKcDv1Um9k0ZAxV5ppGuOq3qd5aVUiuWXXhu7l2zHhivU2fHjPMCBr0vOoMbym0idDHfBkrT2Yc4QkVCFTPoVS5JwbC9w154MXCbsHddkaKWfFgcOcs9bP/Z5/Mgy7tvc0M16wPkifNmLPf0prUGA5V5eSjVv8yNGBIyMwAhRykOKkIGkVrlnld0tjXohxbS8CTprSD62QXqF2BqHYBNlLcGUOFuQztgI49HQMBpS8LQDQzvgK39b0vqh75Rww85f4Lo2v5H/+BI20UJs9gmjeUCD9LZAODTDMoL+B2y8fYbhC3L/6Sm7x55wH37JDcjscIa/z4ZUsKTLno7Lnh1BViAC1Y8eGV5wEOLYbcUyHPZumLsrPZEY5vDJnuOpwKXQQNhCspbCX7/ts15KxPz6J/XyuXJ6A5zjiOkaqvdl67XlIXjSk/tLbMkgOJAbBe7Y596W6XgrFixMmU0unwRVDD7LRq1YryYD9QWfWwrGkFNYzqiL89HpXz81Z/Jxm/XCL4onIGnkzXrwhm9PdMrgGdmLVA9/sAZiMcBv6qIr48r3IyaRlduxvmm66SeGF4evxbSfUyr7xKCxM3hT/UeZNnDW//84p0NJWCgW67vY26xR7zjgkcPFXT0g6hMM4chejdjlRdD2VfqrQozYjp/M6O+BAclWrJ59SgJgLee4mnClX7ojdmtlGPxKrKQ6/d4siXlSLl0YBw1yTlt6tekkpmt22ru10DUm7Jh4hwT7dnyMJSJRwFRySBHW+AujNfDldb6SgWCE7kgPiynQfEss0M3
 VjJ35SW0
 rrBkM15YWlhNVTsfxWZHw/ywwYOWFwWD7eanNRU7MlvaCbMprFxiBlCs2pf6E0CBr+mmZn/jOMSxetCld2WqaYiFFLhIE5P78WONWhH2wzmULwFF+Zxqh+16OzyUYyokfHV9femalm7XxC0UsTnjwQAF1DkoOZi1Q6Rv4Ig+6RKPNlO5cp1kfc31UEI35Nro0C68pXWLJbKs5jfVVo7skfDf3p9054zeLPtAF/Hbv5pKtLIvQqJ4D24kvMYj8yPJ39+90vsH4mRog+ACB40YrTDAaUTS6fSbQXVFzlcuEXdXG+OuCosbyu1BMWQ==
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

	# child/memory.swap.max and child/memory.zswam.max disappear
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
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
 mm/memcontrol.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index d20ffc827306..eeeb22a5e8cc 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4362,6 +4362,10 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+#ifdef CONFIG_ZSWAP
+	memcg->zswap_max = PAGE_COUNTER_MAX;
+	WRITE_ONCE(memcg->zswap_writeback, true);
+#endif
 #ifdef CONFIG_MEMCG_V1
 	page_counter_set_max(&memcg->kmem, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->tcpmem, PAGE_COUNTER_MAX);
-- 
2.43.0


