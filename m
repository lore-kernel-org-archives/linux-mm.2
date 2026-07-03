Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE60C44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 06:38:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D899A6B010A; Fri,  3 Jul 2026 02:38:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D605D6B010D; Fri,  3 Jul 2026 02:38:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDB726B010F; Fri,  3 Jul 2026 02:38:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8CB296B010A
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 02:38:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0784A0468
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:38:48 +0000 (UTC)
X-FDA: 84946512336.30.9891C55
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf10.hostedemail.com (Postfix) with ESMTP id 2B539C0002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 06:38:47 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kf+KTADP;
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783060727;
	b=d5ZAPeay+VeyDpt1U64KiPHh6aRq4SMEMFlDQmNifYG82z4dj5pDb7DXGlGWgK5PgLZYDp
	e4UNJy2rq9lqTXqtSsPD9S7epTrIxkFO+6ybgEpqzMZOhSDuHagBrOLsE44NSD3p0hS8lt
	LwZ8izvkWJjlVO+dQcM4zF7WZ1rTRjM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783060727;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0fEkK9pnSJD0txsSBPtdtsEE+U5WFOOOSBGYT3LbvKE=;
	b=8Y3Fs6Yx3Bwmbol7vslrbHEp7+ZaULkV3L1K8ZRsjahXuIeEKtD69b4/FXIMH4Ty/CTu1q
	2icYj6L9d7XGKAiFhupbBQ8KiEjJdD2DoFMSVVAaJzlzw0rOA4DQZSN23jAhAXUxHp0i5F
	n8ZY6aKLVOXjS+hiaHo1BW/Q5x8tujw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Kf+KTADP;
	spf=pass (imf10.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783060724;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0fEkK9pnSJD0txsSBPtdtsEE+U5WFOOOSBGYT3LbvKE=;
	b=Kf+KTADPxIaSTV+fpz3zkI31900PahAzK4oDrKTYL2hq76L6jqeC1Z6rsae9oA+qGkPsrb
	MmUFdtb27N8LjAkSWVFxCJNOTAjLsHP2MnhQG2EvGZ1Jlw5nlmfsM1ioniGKXkzUH/zN8v
	c15uJL34DaqaCj6QOnE0Iw+ptapp6c0=
From: Jiayuan Chen <jiayuan.chen@linux.dev>
To: linux-mm@kvack.org
Cc: jiayuan.chen@shopee.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 2/2] mm: memcg: reset oom_group in css_reset
Date: Fri,  3 Jul 2026 14:38:24 +0800
Message-ID: <20260703063826.306878-2-jiayuan.chen@linux.dev>
In-Reply-To: <20260703063826.306878-1-jiayuan.chen@linux.dev>
References: <20260703063826.306878-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2B539C0002
X-Stat-Signature: nc7hnsutq3qr4ruxprcpjp1666grpxqh
X-HE-Tag: 1783060727-95976
X-HE-Meta: U2FsdGVkX19aapUGJ7U+vlsBZ/C0sOtqLa9X/s308OGLWJ/kzyuN+I0sqeeW/K3KLBP6Fe40h+RolCZl0KiqVC2fvo7VxtnBQq1JR0sYBgRmxIwIPbWBCQGur7HJJuAwPxONh2DBbnE7nIQafcpGjwP41Mqz52/Q7CXiXHU8RMH9DL5VDvkFdQ69kDVUZkx7ArS8r9sBvi+sb2P07nHD4iG1HG6uNw1ycniWYNQf8RBqGuV4wnXQ+CoLgtFxfWvSi2r7YDFl4YH6137yWs8v2A6F7sWFjkPXVsCHgyHSvA2bQq0NRG2n86W6lTqWwC1Od64eZ+g05ubYCmMw2zPHhNJVUBeFIpamgkSSl+23+OEzHihG+FMf/jaRi/EONhUEBctetMCyDCdBBcd9iBHlzOzxqmxHJVHBRoIAc0S0w6ugfIBJAujZdBlmRWJIWR8AqAckOWVPFJkYcET/G6zzsEuj54ZxEGs1NMt5vDlWLDP3w11DOSstnWvG3/HbEXasYLsqSHLUYE6pZ8Mryhw68vAs4CkkzyE60HhC/aty0XOjK40k+aAwYKC90GynRyEKDNLkBRxIMPV5qjIS0kPWAkCbMC9/wBJDEPeG7GekgSunK01WLVncXmegGvIRdgzYTQXAASzVGdWNL8PoRrY5sFqRaajhMmu0xeZDoKMmch+oKkZulNSv7uib2bCMiscexMsdTYY/9wob8fb8NVw0IjxTDC/3crvuPcO3mKg7r6Z+POe9fbw/rMKn7HD7fdn0lCufX6EoseAw6MNcBdsrBHjEvn8bIZit2TQA63t9Gvs+u55B3j4qKSB+C+6sRitk5OfJt6Aipba2jKW6HvDhUVbHPw3sTF698Ed/hKSUPybVa/tu36PbcQDbZAZ/xDk05DoZMh6o2uPqK/JzfVnHgdd2mD73Wx2dW/OCIA8dTmzpBB+/65rxdALsqnfU27ulaSBe0cxPbQf5CwbQo2R
 8RP6D1Hg
 SIbaBWUpYzCq7jcY78fccXbQbV1oiKFhXYhveKq8fc45vSfMsS8gRWAry95IyAqCtPbW/SI7LH4kWs2gSunm99rP+Bw5eiXz2z7w77Iil++5WtKpveeqDFEqCpM5CyDv9DBvsBnOKCGxSynMpMJt57ETM/TMmSLvYCcsF8z0GKgjQSVut1z0na+frnEQR1UtvKH2YxLhBPBQjRsEHAmup7zHaNCWlg0QXE286SyXz8Ws4ewZGiqNKhHOZIIh29Xyc6GGVbUISqXLHUUvRGX4B7/uhqMd03vfTweucCmOZdXLS385XatOtiUbNSn7CZQNcnz9jI2uNhWcLTaW3BTfVUkoorNUHLJyLsUyBX6FIEWAV9FM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Jiayuan Chen <jiayuan.chen@shopee.com>

memory.oom.group defaults to disabled, but css_reset did not clear
memcg->oom_group when a disabled memory css is kept alive by another
controller dependency.

Reset it with the other memory controller policies so a hidden memcg
cannot keep applying stale group OOM kill policy.

Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
---
It is found when Sashiko reviewed my previous patch.
https://sashiko.dev/#/patchset/20260702024827.353185-1-jiayuan.chen%40linux.dev
---
 mm/memcontrol.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c20ef3c1d6fe..c7de62c8f86f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4362,6 +4362,7 @@ static void mem_cgroup_css_reset(struct cgroup_subsys_state *css)
 
 	page_counter_set_max(&memcg->memory, PAGE_COUNTER_MAX);
 	page_counter_set_max(&memcg->swap, PAGE_COUNTER_MAX);
+	WRITE_ONCE(memcg->oom_group, false);
 #ifdef CONFIG_ZSWAP
 	WRITE_ONCE(memcg->zswap_max, PAGE_COUNTER_MAX);
 	WRITE_ONCE(memcg->zswap_writeback, true);
-- 
2.43.0


