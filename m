Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8001A606A326
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 01:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=R3cSXNEU
Received: by kanga.kvack.org (Postfix)
	id 93C986B05B5; Mon,  2 Nov 2026 20:30:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC2D6B05B6; Mon,  2 Nov 2026 20:30:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82A1B6B05B7; Mon,  2 Nov 2026 20:30:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5E81A6B05B5
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 20:30:03 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EAEA1C02F0
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:30:02 +0000 (UTC)
X-FDA: 85392076644.02.22B2A13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 594F920002
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 01:30:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3cSXNEU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793669401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JL0qvT8ZjJjiuievn8oHTO+mTi5spxR1dpR3Ut9PSkc=;
	b=xiXUWt7YZWvxPY6j6GPPlgOvx8Ovk/2X4qTthH9O1j8SgG5cA22CUCWdmUZnkR8i5e0Fm8
	7nh7dPhF9mPrOYUW15z3wkqQH9Wty7kUjohi5Wt5NxrZZztsQFy7Q7D5K9oHXxoZHT2Z8J
	7oCz2JYrP7VRN0kPevv+kjCX3kBsiJE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=R3cSXNEU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793669401;
	b=YlhQWy8G420Jgu3C9nv1kQHni5+ueLFoIdKkeKw6jRDLnhFt8zFz5GNMrrcZ69qBi0kK6H
	+CpcvivMg4+G2s4tHexTtAw1VVJH512f+bKcbni+VB+16wD0BJTFLWsQWw/D7wrP3BKBlJ
	xcZVgaxRCHviNp/UUEAO9kFGISomr40=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CC16040806;
	Tue,  3 Nov 2026 01:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33B781F000C1;
	Tue,  3 Nov 2026 01:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793669399;
	bh=JL0qvT8ZjJjiuievn8oHTO+mTi5spxR1dpR3Ut9PSkc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R3cSXNEUgnb3K9YOWjnMQqFH+EiogBKNMMLkot4qCORp6kHRUaaVhX1jCsg7RTM0d
	 F9nMpF9n9e76JMZcvCUeVOLI1GJJYz20/HE6P+rlUcTLBX9dz163Lz2Cr4WWcTBFJx
	 SSc32ghlzCrYzhzdgN2qRpBfo0/MkVgKbE732CGSlcPVMc9HMy9RQqMNWD0PtwQ9tA
	 +iz9py1Vw+1YdOefU9z+3YfR/JzCkfrw1PYU/yQLxxUSSO2E9lqbEkjVphHn3/lHcO
	 Tn89iFq3+Isg31Pvh4tCnu2qmOz7o0YHdBHoINyTS9bCr4Z0PJak+1q/8AdYOZWwom
	 Rs1wUnMZKdvEQ==
From: SJ Park <sj@kernel.org>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	yosry@kernel.org,
	shakeel.butt@linux.dev,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	david@kernel.org,
	ljs@kernel.org,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev
Subject: Re: [PATCH v1 3/3] mm/damon/core: use node counters instead of flushing the root memcg
Date: Mon,  2 Nov 2026 17:29:51 -0800
Message-ID: <20261103012952.93674-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261102225030.2743129-4-joannelkoong@gmail.com>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 594F920002
X-Stat-Signature: g81ubiqjhm8oqqzrzqguhjo7raj8qhah
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793669401-711392
X-HE-Meta: U2FsdGVkX18wKdii3P1kdxq4Il0nxxzsyq8rhJmg+A6xibHnHy7BIvaNWU2gvlrjNiRUbDuOoN5tFUF95WAd1bHXx8JYg0cDrn+95hoCLPtmSCCcd7N3VqztArKHFa05kMm7pOhbbJ6PoXxMnFSbZK+ay9S1BRuy/kgWZM1qx5cB40gaqpU9rueA/BK8X6o2IcgSaPQoKHcrTOKr+NAxhcRbXgcu8hAodMEuRV6JzX+M+qs6b4x9wuCq5nD5F+OBtdOxSSl8V3//VL6P5KaX6go3ipDa450YLwZU5Amkx3Ypj6CRhDTLhq66eLo3g8QhSu/A5fJDJ+X/6N2kEM78Cw8zVoryC0qVv31pQaKuwuRxF9AM/MfxAjm7Qbu2V5d9V+6yuz+iv7a4hDEOuPZySrQHlMdz1nqeqzuqvZaApfcX7aaZBL9EQHeWKjat9gvqbXpd+Bq+AGHxIFlGI9IInuxqpTp9J8tco/BTx1WBhtAC8DRsp4lRgGuF4/Ex8kkfeJwhJl0Tt9kxfRWVkfv8mpZKMeA4W61Ow7iILRp0u1BoCNQl/wkL8afi11JpJ/eK5KFA6hjoXGHYgP98/S2zRD5NQqRTkGEGMBgMhIpl1KnN6ZneP8aWE97aBur16FjYCZVTgjXQku3YcbriUHcTK0lvVjKx9+CybCT/MX0a4svjYLQjweG3RY4L8QbN232ohxr4bdYZsoldZGDiuURaTyFHzfTK2GGKeEdVx4kDptB/3Lyxs4xcarAURa2vX6kUoumsZhfOsJ2Z/VkvDz9jxGa2aAo5Nh8TO6w+XRCWJyvM6ZDuUh0KDlpbZvOhiKDv6lX9+bikJOs4tHlGuQ1jIDVn4Y9oiyhcmK2y4uis94okqlfIWYBFbFQxJ5V0dqjgGyrpq/XFwZRzVZCF7EFn2rgNtlUyhekPRJZelR/eAkS0qZkrqRt1CliO+UuKiGcuZFPhrigQKSuDHQjel1A
 Z7M4s0N9
 ymhlJwEwlsObzL+uzJ+BFX6mR/6YUTi2X5Xqjs8pioO4kMYseytJ+fFYHl4OixD9egiMFZWqG8ybGAcAoxE7ocdYMa0LxYafgTB2L26QXG0dBbYqEecCVYFnRi/yoJunZjX27h0aSPHhCY52SV/wFQyWln9/XJZzQyHQjJPhNn+4uFWAUYGE3O96oufPAwnr+JA0tt0+MzQbJ/jXLw4hfJei1AzBjCQYJszcpxwFN/w5vSRwpn67Y6zF9PvZWjsHI/mnV2MQEZDqgNvuLWmPthUm3yA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joanne,


On Mon,  2 Nov 2026 14:50:30 -0800 Joanne Koong <joannelkoong@gmail.com> wrote:

> damos_get_node_memcg_used_bp() flushes the memcg stats before reading
> the LRU sizes of the goal's memcg on the goal's node. For the root
> memcg, that flushes every cgroup in the system. The flush is not
> ratelimited, which means it happens every time the goal is evaluated.

Just thinking loudly.  damos_get_node_memcg_used_bp() is called only once per
DAMOS quota reset interval.  It is usually recommended to set the interval to 1
second.  So a sort of rate limiting is applied in common use cases.  That said,
some users might using quite short interval.  And it is obviously better to
avoid unnecessary flushes.

> 
> For the root memcg, the node counters hold the same LRU sizes as the
> memcg rstat stats, and they are always up to date. Use
> lruvec_lru_page_state(), which reads the node counters for the root
> memcg, and skip the flush for the root memcg.

Again, loud thought.  For root memcg, users might use
DAMOS_QUOTA_NODE_MEM_{USED,FREE}_BP instead, which calls
damos_get_node_mem_bp().  That said, some users might use
DAMOS_QUOTA_NODE_MEMCG_{USED,FREE}_BP for root memcg (maybe it makes user space
tool writing easier?).

So, looks all good to me, thank you for this patch.

> 
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Assuming the discussion on patch 2 concludes to have lruvec_lru_page_state(),

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

