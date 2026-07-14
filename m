Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1BA4C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 20:07:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D109D6B009D; Tue, 14 Jul 2026 16:07:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC0D76B009E; Tue, 14 Jul 2026 16:07:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BFE5F6B009F; Tue, 14 Jul 2026 16:07:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99A116B009D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 16:07:07 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 259D91204CF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:07:07 +0000 (UTC)
X-FDA: 84988466094.19.5E11136
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf24.hostedemail.com (Postfix) with ESMTP id E7D67180011
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 20:07:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dMmNsSId;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784059624;
	b=fx7AAK7rVGaHphtTPNKBtbYPs/BouzRUDXl5DGbHvGU7vxLcovt+zeqyKlRczZtNknW0f6
	t5H5tl0fmx7RlKiTVyROTlvxlXm9paH5Vlp4ZjD06DxqSkDYG2CxrVxy5MXrkLUjxCq1FN
	IOiqLsPiVBcZ62wkFlqIwtKNGL3JO48=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=dMmNsSId;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784059624;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZU7WkL3i7SeRgw5VglrcCcv1+ohX2xp0VclLPC+zgZ4=;
	b=KntI6Iurs2yFUbfpt0aPqUhxAwZm41j+UKolbIimGGoYMF+0uQrqwcfKfvzpiACWxeBCA0
	FuzTbHoMy1dU7ZUacRSFH1v0XT65xRPXmg/l23JSZq7Dsb8swuN2T049RrZyeqdkPs/sI6
	wG2oIkCd0QVGvGQD7rCNgTrREUqah1c=
Date: Tue, 14 Jul 2026 13:06:48 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784059620;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ZU7WkL3i7SeRgw5VglrcCcv1+ohX2xp0VclLPC+zgZ4=;
	b=dMmNsSIdDI5qEX7Fe1KdUrRF1+56hw0daHyObBPoRBHlkapQaVA20nf+VW5moiise4EA7k
	vHWB65YHe2v1r/liuuQ8KQj7MtjofuSgzavPSB/Z9U5y2Q9cBBkM2nCT2NfnwcDEmuZ/sH
	B1DKUFgntjr7QQ8Nz42SVsuyPi/OhAw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>
Subject: Re: [PATCH] mm: memcg-v1: make mem_cgroup_oom_notify_cb() return void
Message-ID: <alaWwe-2HSpnCrnq@linux.dev>
References: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260713093737.3299646-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E7D67180011
X-Stat-Signature: 97fsxo5sjesb4zkpkd11jy4w79qcnxqy
X-HE-Tag: 1784059623-244011
X-HE-Meta: U2FsdGVkX1+hyHI+On+TqevIi0KDEoarTFmNVKHx1uScxQ6euf14SKtbaTYfVUY6GmzjVwLmRHWotIblWnL/fh+o6aTNvSEp0fvpMcYRNKoszxEQKdo4pcpKIUB6l2STp3pZLf3h2mku4yL5YTjybf9aCNZwBgOYcYoVj9gXCNboeZ4zI7en4opY5ZWa5PmoFXavyWn0tDe5VpFdexzDwmhqII7ecPJxklQkbQGHLakh0MUcTKN4unMZl9SX6eD5xzxwkY1imKVsQbWpzLxpTLaWAAa9mA52pbGSqRxbHfJMlIDhH28vdZl8BmTeV61x2zVECN6S00N2XKj9eTtN5/3tC97w6ukcHiQt1wCQ4pBLq0NrR3cfArblWxzIWmZ4WdWzsLyGgvl+fsbWRleVSB4eyy3DPrudKpp6t8zcXEhSkt3HzZ0uWnQWkb+yC+EjhKPxGB5e+eBeR7+yxkqAVGqaCoxWl6PskXutUz6SayY0DjZUkdR4nIqeixUeEWS5/R5uPEw3+gZylKg6hmw89+QAfULwxZ1ZxwCsNL3Cb2tCJmwb6EC3QLLAY2PgTXSy5o1xtK4+u6mlLHTDZmpL682oT4b4mBp3v3aVOHzISy6GHKIQTstLKfrfRCnSAiqu4YjM6vKQ8L13x9sqeu34Jeu8SZgRJ+7KfwmOeIsHqfWY5ucR7SeubF4BFv/UIU69aKIT7vGiQV6YswUuy/38l6JBCsptONLS6khQWapX7SZDodrWGkgbeQNOq+Y6BqcKVEnV9OGhRlRvlX4nR206Ye6359LYhH9lRrWeRTVqqHG76IQoez/2LpEw9bRzfs6Lt0VglnjD7pIDQrJ2HX1YXdvWdx4LK6tj1+5nbshAQ0dthtFiKcbkO+A2MZ/ZogcRtxFede/JRFd1D6co0IFojt9JJECfnjUehPFnTOaO4RPIdUFReVZU272Sa3CrqgC4d8TkUddwvL1ER1/3x6I
 mSIqPVP7
 zlhUV34ad3EVGrMbPEpt30uqLetxoaPPCOCPkP/d77QpXu+tl7OhLR2br1gzgb0vCsmaHBGnUs2PGDZhMDVVzkvTFyIZSsB56qXGEIfaeoxXSpoUWwO1WK2eGnqYXINeFseI12KdXsCt5WgRPIkEWxlc9ac15O3XkLmztrEPYfTm4qE7zqHiK6rD86k9pdU8QjtGG1rpJsmM26qInQf5sh3WYjKQ4QFq/NAQxH7f9NfBvIzVG2QScaTd5EQhHwdw4LGUZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 05:37:37PM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 7d74b06f240f ("memcg: use for_each_mem_cgroup") replaced the
> mem_cgroup_walk_tree() call in mem_cgroup_oom_notify() with
> for_each_mem_cgroup_tree(), but left mem_cgroup_oom_notify_cb() with the
> int return type required by the old callback interface.
> 
> The function now has a single direct caller and no failure path. Make it
> return void.
> 
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

