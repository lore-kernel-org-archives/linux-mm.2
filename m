Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1303DCD98C5
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 00:22:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA3AD6B0005; Wed, 10 Jun 2026 20:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7C496B0088; Wed, 10 Jun 2026 20:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9136B008C; Wed, 10 Jun 2026 20:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9B63D6B0005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 20:22:54 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F1DEE1C2EE3
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:22:53 +0000 (UTC)
X-FDA: 84865731426.22.BEDDF81
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 62AAE2000B
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 00:22:52 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lxbh7HPQ;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781137372;
	b=Wqfcox8tQMbYhb3plN0hoLaKvf4NsaxOZ24VPvshMwUAHtwmywjfW55G58ZRGlex/M/ckt
	xJ8PO1svgSGVDGsFWhTNhvxnfBb3yGKSszi3i3oMdWqFY+ccnjx2ZjX3s8dvlFrjXcJxn6
	VVYCpRj7xyJZqtKOcoAeP7JSKQpxvQo=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lxbh7HPQ;
	spf=pass (imf31.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781137372;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2SvRs21mGVxCJSkrSt9EaDORfooGulFSzr+iBZ0ww28=;
	b=sPqxpoKlx4FVUMvdTJfJ/A/tMCcdJkPfOr2gTuTej17N03ZkaIUj6CSX2Bogvzt+yuYzOQ
	dOAxgUcp57Pu/J/tQJVuqQ78flgWIi4O+HKWJp1WTuOQJnzb7+XL5u49DJ2CLjvqWAEFKZ
	cuYLJJxhZEgU0cw4CEx/yM4MowZUSCE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D514F60204;
	Thu, 11 Jun 2026 00:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27B281F00893;
	Thu, 11 Jun 2026 00:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781137371;
	bh=2SvRs21mGVxCJSkrSt9EaDORfooGulFSzr+iBZ0ww28=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lxbh7HPQ7YCt/Q+bwgr4myrYnjUXT7Vo/3fMu/0XWpHdBnxLX3Dc45N+I1GmceUWp
	 7/7xSwT4hduI8gyQ4Y9aQ6+/VOpTM6qwz+mePKALM6yp31yBR3a7EFOjr1ojweFHOR
	 NfrkaKUvcLGw/Quz1KS1SlLE8yDMtoGstP4K/kKcalN9kKHzOyMmjaaTiHl2IS6Avj
	 GtA0r49DlModp3BIHRRYqyK+r0uDE9Ri9UL8KO+nROhXXi+Sv34OkStKqPC+PD6r4w
	 G/Xc9Sl4IzGHM4RZ91PEYA65f4eJX+mIl2V16z7lpDcMhFMcEOeieXhtSEKmgVuWQE
	 GVdaq8jEQ4Hvg==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Qi Zheng <qi.zheng@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Zenghui Yu <zenghui.yu@linux.dev>,
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH] mm/shrinker: do not hold RCU lock in shrinker_debugfs_count_show()
Date: Wed, 10 Jun 2026 17:22:35 -0700
Message-ID: <20260611002236.69207-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260610232048.62930-1-shakeel.butt@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 62AAE2000B
X-Stat-Signature: i5snc9k5rxhe7er9gf4fmsi3iw1o15mq
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781137372-950993
X-HE-Meta: U2FsdGVkX1/mrSJU3wccBLfxxVOHZRKzUuyCUbOHtggDv9UVWSaq0CUeF5mpmm07+q1MmqPu9WayLGn+jO+aB50qcUJl4IA8C3/mqpk6Y/Kc6xyQTpN3ajS5nccUg6+CS6X/4NBvB3HcROVGubuQsP7EqulOpVzRQy7BlOn/I3BtjfM1pnzTATwmr0YD4I7EqOJfODJfFxRnkxOwjbTt/rrK7fzqLetOl/Eh6Yy0UtGWGvsiftW04NAsG2i4Q0jq+clu98GCRC2NGy6CQijSmoX8JvM4jXVh/zf1XonoAmAq2J9mdV0UbDF+5gG8qEq1TLBOCBI3bwuzQYOnE1tNxzd6GnWpPpRkTAaUvKQ40e0IKxlMwtnONRg2Q5nx1f43td894OZA0JmwV8EYS/rcyw3YfNDXMK/fwfFo9W/erZ87EbWTNom9gQ0pjtVO2XjofB2bTWSrdxwSuHHSRTo/ha/izZqdTGz0trqg7g11ga4TXQzZ2s2arNbsIzPGFuqb94UDG96NQrLF8STW/bg7SAJ4L9PI00nrnGhe9+ST7VOHSWRcCDT/rTFZHdDOV6UL1qz52vZXJwQ7Pjaizg0Hsn6kriTuYmgsxK0ewgoVuDTCxWjpRuluzeA92BFf7OsqSoUKkaOfign5QJyoHr19jTpcWa9GVHYpPT8GDlivfPnDhCNvttfDGIAzxPAKYzKXx9YkJkfAkxUl6FMBPzBaidZ0cpzVskGrkncRwcmpETtmOR+ue+MBoM1rhI7y66dNBOn3xECky/Q3s22WCDtui+3oGf7rOgLsYU5BSQ6UvSzQlRmmaFM5nJ4isBMLNH/vdVzPlVgS0KtaBrpLzmf7ALJWEor3tU9l+GgEyIIxKDvAt6Xenc9GAcY+iuJEMxRvTcl62ZnrM3xOwnuHrPSjXJLeLADUGZ4/VcaD/Xmf4WFLtgVKufIDDHouQbiRiUMJsubdxDzZBUDdyvM+AP+
 xNTUcOoI
 tHoRl4qUgAG4ne9cGbD0FW+K08ZB3YU1QTarSRYPCuYK03oFwaO7ap6/qoFo2o0Ll7JoJuzjMSpba6jo9ZT6YeKbduCUmEun+T1pTdhlciZUO6YRBLyPsMZzkNZ888PbMXkom/YhFo6QKbEW31ITF38HdWo9sEagUQZ9jH/FWe4K2+Z+hU+5ywcMavHgKCPv6+cbM0EGv6/8HDx9MO5z5pqXDi5m8K67nmeyoEbTDJ2FTsedgdSnCk3suVxPTILfSVA/oYuDdjXJUSkeB4d53JxSKfTvGglBn+MD3Vhnihs1ZrS2nkuw789nACA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 16:20:48 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Reading the debugfs "count" file of a memcg-aware shrinker can sleep
> inside an RCU read-side critical section:
> 
>   BUG: sleeping function called from invalid context at kernel/cgroup/rstat.c:421
>   RCU nest depth: 1, expected: 0
>    css_rstat_flush
>    mem_cgroup_flush_stats
>    zswap_shrinker_count
>    shrinker_debugfs_count_show
> 
> shrinker_debugfs_count_show() invokes the ->count_objects() callback
> under rcu_read_lock(). The zswap callback flushes memcg stats via
> css_rstat_flush(), which may sleep, so it must not run under RCU.
> 
> The RCU lock is not needed here. mem_cgroup_iter() takes RCU internally
> and returns a memcg holding a css reference (dropped on the next
> iteration or by mem_cgroup_iter_break()), so the memcg stays alive
> without it. The shrinker is kept alive by the open debugfs file:
> shrinker_free() removes the debugfs entries via
> debugfs_remove_recursive(), which waits for in-flight readers to drain,
> before call_rcu(..., shrinker_free_rcu_cb). The sibling "scan" handler
> already invokes the sleeping ->scan_objects() callback with no RCU
> section.
> 
> Drop the rcu_read_lock()/rcu_read_unlock().

All make sense to me, thank you for the nice description and the fix!

> 
> Fixes: 5035ebc644ae ("mm: shrinkers: introduce debugfs interface for memory shrinkers")
> Reported-by: Zenghui Yu <zenghui.yu@linux.dev>
> Closes: https://lore.kernel.org/all/c052a064-cddb-494f-a0d8-f8a10b4b1c4d@linux.dev/
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

