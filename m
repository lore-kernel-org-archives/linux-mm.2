Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78C31606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 08:28:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=126.com header.i=@126.com header.a=rsa-sha256 header.s=s110527 header.b=MH3wMfsr
Received: by kanga.kvack.org (Postfix)
	id 965D96B05BC; Fri, 27 Nov 2026 03:28:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93D876B05BD; Fri, 27 Nov 2026 03:28:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82CA16B05BE; Fri, 27 Nov 2026 03:28:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64B8A6B05BC
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 03:28:36 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E3F3E1A023A
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:35 +0000 (UTC)
X-FDA: 85480222590.27.5C4DB06
Received: from m16.mail.126.com (m16.mail.126.com [220.197.31.8])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0388B40008
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:28:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=MH3wMfsr;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf17.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.8 as permitted sender) smtp.mailfrom=nzzhao@126.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795768113;
	b=H045L2P0cH9kEx8FbA+tfqdzqsO3r+wI+M9fEFTpYTu09eGYNBQhqrlV7FpPgvy94DTa1R
	zU2MdglduI5lnA332G90oFCzB/U1zh1T0rckcXXmYcGYhktW4veD1gT+kv8wuGRbwnXxBR
	bcYGDUzLk3Oe8Af8lvBBgYecJLaVj1c=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795768113;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FelsLGm3OIsJMRghgdPAN/WSMG0jTZ6UF/BA+N/J5Dw=;
	b=wlSxFWhHdMlPlbeiN22X6U4E5jPC/zntCJiMxBihpUtDhMAvNXOa5kNNdlS5ymib7sEWJm
	L7m6jmT3kuTe5htemXWRQjsG42TMEnMvLLL93laiqSVKt4i7pm9XyEnbiQ4F4AbK+DSmdC
	t8J3pbJi7DT1SzTjilnt5ffNfCb7pUM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=126.com header.s=s110527 header.b=MH3wMfsr;
	dmarc=fail reason="SPF not aligned (relaxed)" header.from=xiaomi.com (policy=quarantine);
	spf=pass (imf17.hostedemail.com: domain of nzzhao@126.com designates 220.197.31.8 as permitted sender) smtp.mailfrom=nzzhao@126.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=126.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Fe
	lsLGm3OIsJMRghgdPAN/WSMG0jTZ6UF/BA+N/J5Dw=; b=MH3wMfsr+91tP98ioa
	WxBSin2xEDbztiQxdRz/prROR1Dw4i8vM7x1NWXqssBG+jWcgbtAp5MFkkBGw5Nx
	KCRFeSdcA9i3apbeBtoofVHU+OH/i9JcmQwWWL4hNrpKyEvRBDM0XvGUnag2c6TP
	R8WSLPQjsndIKo3PDLI3JcyW4=
Received: from nzzhao-ThinkCentre-M760t.mioffice.cn (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wD3V+v5Pglr3S9kEA--.12822S2;
	Fri, 27 Nov 2026 16:27:38 +0800 (CST)
From: Nanzhe Zhao <zhaonanzhe@xiaomi.com>
To: sashiko-bot@kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Minchan Kim <minchan@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Usama Arif <usama.arif@linux.dev>,
	Yosry Ahmed <yosry@kernel.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Chris Li <chrisl@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Ying Huang <ying.huang@intel.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Kanchana P Sridhar <kanchana.p.sridhar@intel.com>,
	Wajdi K Feghali <wajdi.k.feghali@intel.com>,
	Bala Seshasayee <bala.seshasayee@linux.intel.com>,
	Nick Terrell <terrelln@fb.com>,
	Barry Song <baohua@kernel.org>,
	Tangquan Zheng <zhengtangquan@oppo.com>,
	Bo Zhang <zhangbo56@xiaomi.com>,
	sashiko-reviews@lists.linux.dev
Subject: Re: [RFC PATCH v4 4/4] mm: swap: allow direct reclaim for synchronous multi-page swapin
Date: Fri, 27 Nov 2026 16:27:36 +0800
Message-ID: <20261127082737.3625032-1-zhaonanzhe@xiaomi.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <sashiko-outbox-216091@kernel.org>
References: <20261115024455.1465726-1-zhaonanzhe@xiaomi.com> <20261115024455.1465726-5-zhaonanzhe@xiaomi.com> <sashiko-outbox-216091@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3V+v5Pglr3S9kEA--.12822S2
X-Coremail-Antispam: 1Uf129KBjvJXoW7CrW5WF48Aw4DtFy7trW5Jrb_yoW8GF4rpF
	yxWFW3KFs5Xr10yFZ7ua1kGFZ8Ca93XayfGry3Wry8u345Za48ZFZ0kr1Uu3WDCwn3tanY
	qrsIkFW7X3WqvaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07UkfHUUUUUU=
X-CM-SenderInfo: xq22xtbr6rjloofrz/xtbBoxvqumsJPvvtvwAA3d
X-Rspamd-Queue-Id: 0388B40008
X-Rspamd-Pre-Result: action=add header;
	module=dmarc;
	Action set by DMARC
X-Stat-Signature: rourn13krsadyasbjzpgrafbwpmxd5fq
X-Rspam-User:
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-Rspam: Yes
X-HE-Tag: 1795768112-197966
X-HE-Meta: U2FsdGVkX1/NSgUaW29SloTHnn5l80VQJ6jAhumBdgwFJK4XufRpCOKPJDp9I3IkScXijCCNh8SFWH4a5UyDnMlUdScpQzMvbhLJ+PoP0f4tq5khFPC2Jt5xCmv+qo1qUZYgrYt7bPq7/iYhtP/MVR/zAzUGlGYqD4aVBoGyPOXsV1GoKHr4tH9HMW/0IwSQDAZuzQaCqNV+BsIcFiq85qFPuv+ORK7biJOEmBiv3Hrf6/8w+5SAxpilWzuzIhsDwtPCPNxbc/KCHyCN/qDwL45iMuK5R2f5unv12oG5VkKpFXP9fstLWrg52mayRezAzxd6GS/1PNJzRjsOs2ShDwAns0Ww3WB6tR/ZLszV8/kl0GOKMIB5Bq4NdQIyGzUYEAJx5YuQEVJy1bbu15MzWrfK5vrg26dUmF8aPjPHy6YYc7XdaW5ZiWRBdZFz9rZm2DGu0RbfUN7G+Rkwo+KB7neL9xvywmAH12lzOhWK/0Sn7NkoU9Jt7J4kl1ed9OQpPkGGwgLbLjaBsoBPu+OFrNKbpnBCRNlsE5H7E8081poBX/r39fO3KfmPaayQyZBp33zqDm/sim5p7EsLmOzQI3EsNj4Rg7KnJSaNPff5hSXU6ct2jJLAxddiENEJWoCFN7fE3Ot4eC/sg5npiRcke07ZeyE6nxdvz8hIS2PI17ZfuNaTz7iU6Awrs4cJ//EszehYGIvsXtyHgqFC6l3Ktj/sZczG0M0SebBIjOJl+MlwXojFwtDayhqwBLEJJ5C0uYk0W0MuDbnhZ4s1kKuJtubhavIYPHbzg0uNcF38MGYHxGgSTMv/FCeS1w7emUY1W+angDX+bWuZqmJWy+9/RQ815eo6y3gCjwcXz+KncrX+yOtfpGCGX4oX098QkviHkUvJwXkpF6rKOADtEeffosPhcsv+hEIS1TSWkmUv4D8KmRCokNKlKLQjMXTISgrsir6pFEGXeWygnHT1Z9F
 hELDyx6D
 h1rM4OGx1mMrQh52ifJ1bihvF5j4gNq3ofbwzH1fCy3/LlkbZf4Sgs67bWMEfXeaVm8SOo/4HnDPhl5IiaDM0ncHBAffQ/OWdLG5mo+R7kjvv6hrO5BBy5gHcbr3lEiq22LZBNGgURzcRZB6YFG49fdN+9QyCrrVzkAJznx8wq3HmX7cG7eTOcWgluqoqY+rMgfSve5uYrzAbIKECExMC7OMD+vvhWyQMz0+iDB2FmS6FSFNgoVUPSD1+UBTPxYIH8R+WZzeH0tyGfhnIi0oAhanLjZ0xmIic1Hh3HwjdK50VQLrChaUok3QN7TcCFFCaBlKviiWpHsebYbpJHeWBN+ACrs2kiEBlBg9j6tFjfEPIiKOGCc3KHS8fErznVw0YoCLbURoO8fdBk4t+ceBze+S2oknfIHb4jbISzCOOgcT0XpsleVZT6TurDvufQ/LlJrLlSnhX+AgMyd6BgRF/n8dXq22KfjyOh/1USOWrAWKXZPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

> [Severity: High]
> Can setting __GFP_RECLAIM without __GFP_NORETRY or __GFP_RETRY_MAYFAIL
> trigger premature OOM kills on order-2 swapin faults instead of falling
> back to order 0?

Agreed.

> [Severity: Medium]
> Should __swap_cache_alloc() unconditionally override the GFP mask for
> order 2 here?
>
> __swap_cache_alloc() is shared by all swap devices even when zram or
> CONFIG_ZRAM_MULTI_PAGES is not used, and when multi-page compression is
> enabled its order is configured via CONFIG_ZSMALLOC_MULTI_PAGES_ORDER
> (1..9) rather than hardcoded to 2.  Or'ing __GFP_RECLAIM after
> thp_shmem_limit_gfp_mask(vma_thp_gfp_mask(vma), gfp) also overrides
> defrag=never/defer and caller GFP restrictions, and placing it only in the
> else branch leaves out the mpol path while causing shmem_fault() swapins
> to behave differently between CONFIG_NUMA=y (where
> shmem_get_pgoff_policy() returns a non-NULL policy) and CONFIG_NUMA=n
> (where it returns NULL).

This patch was an RFC-stage exploration specifically targeting synchronous
in-memory swap devices (zram) at order 2 (16 KiB mTHP, the primary
compression granularity), to evaluate whether allowing direct reclaim could
avoid the partial read caused by order-0 fallback.

I wanted to raise this point for discussion first in the RFC, and will explore
more generic approaches going forward.


