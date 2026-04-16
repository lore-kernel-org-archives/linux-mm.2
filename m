Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D9BEF8809B
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 07:32:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 250C56B0005; Thu, 16 Apr 2026 03:32:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201A56B0089; Thu, 16 Apr 2026 03:32:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F0B86B008A; Thu, 16 Apr 2026 03:32:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id EE6C26B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 03:32:38 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0FE8A140705
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:32:38 +0000 (UTC)
X-FDA: 84663601596.29.0C3EA24
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1018720003
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:32:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FyGrNKGC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776324756; a=rsa-sha256;
	cv=none;
	b=KOVB2niJyTgdf8leR4/7yCF+ZfqIxJ2z9HH2cbZ7Rch3/kyc3zgxTGzl8ZyYXzOVutFl0d
	xgQIJngroay+GvQlhZD1oSJQtapm35IZrgbpBQFMdUFrU0T+kQy391AC196t4cHD4zuHVQ
	ztcg4741tlFXLbYZUKK5gkRDZmX+P/Y=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FyGrNKGC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776324756;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwioQqo3saFabutwcMLfJtYnp376Ch/FQYG56niV6tc=;
	b=Upq8fvslBk7+BVjoGHOyybavnd+M5xg1CWlJp+6ibwOmbcwpW1z1ehKT7hpWsLNL9jNBA0
	Dxlkioj9TvrxXZiUQZyV+17xaGHfg/1tDXsdLu3LyA4KJ/TJfzlFWVq3akfre2XJcu86Jw
	BhEkwybXx2+cf+aLS1ySWy+/DWMDQqU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C25A8444AE
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:32:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949D7C2BCAF
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 07:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776324754;
	bh=oV7AP5mxtlQKF75hMQurxqdhxeqExUc+aEqIYXJ9l5U=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FyGrNKGCDx+b4EADrkLbazLm7XA9uk/KIFm8dvVP+YFr6ZaaguUKlMHxJYUeHpL2s
	 q4BJ0f0cR4eQ6eNAZOFlA+yCatzHqWwg5sHGc3LuvoaHn17MOJzy3vZENhcLIAhzZF
	 TU6r5MnsZANc52EshVlPBwyDMcw7UEpilIDSQA6g5wmyIDW7lUIPzDliGocpaAWALA
	 gyW/VItFzEj4aIF8U63pWYbRZS65kpD6G/m6r9MB48w2qum2Kt5XV+2gqHrDZC83GC
	 yeFe3vgwveX9D8BE7oYBUydPq1KiCsOUc7DntsEPvFcJpXELv8sleMPGFA12KXYEyN
	 0J2CMQBDF9kcQ==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a016799d2cso82855826d6.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 00:32:34 -0700 (PDT)
X-Gm-Message-State: AOJu0Yy4Hw14u/dQFXgI/Txp2w/0VgQ1avCztuF1t3s1OlXHUzyzsQHK
	bXNvoLB/Z1yO+Z4UUI+IQ3aKvCVO02nfH5QjJwd549FpO5nSgXy/Ff+1hTtrGMPP9Q/FQjP+ejy
	An1sgsIx3AKdDiB9SOjJgQEevaes8R1s=
X-Received: by 2002:ad4:4ea7:0:b0:89c:9fa2:5de9 with SMTP id
 6a1803df08f44-8ac862a63dbmr422176606d6.36.1776324753663; Thu, 16 Apr 2026
 00:32:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-mglru-reclaim-v5-0-8eaeacbddc44@tencent.com> <20260413-mglru-reclaim-v5-7-8eaeacbddc44@tencent.com>
In-Reply-To: <20260413-mglru-reclaim-v5-7-8eaeacbddc44@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 16 Apr 2026 15:32:22 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wUvBZMbXA0sb_+TeGcpr=HjqMAPZS6WYyjU2wv5-+kHg@mail.gmail.com>
X-Gm-Features: AQROBzAUFaJKGEkE3cHcprN4bf5vG9D_0uxg7dnNE_sUxPdgo9B8itsdFfUTq4I
Message-ID: <CAGsJ_4wUvBZMbXA0sb_+TeGcpr=HjqMAPZS6WYyjU2wv5-+kHg@mail.gmail.com>
Subject: Re: [PATCH v5 07/14] mm/mglru: don't abort scan immediately right
 after aging
To: kasong@tencent.com
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Qi Zheng <zhengqi.arch@bytedance.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Lorenzo Stoakes <ljs@kernel.org>, David Stevens <stevensd@google.com>, 
	Chen Ridong <chenridong@huaweicloud.com>, Leno Hou <lenohou@gmail.com>, 
	Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Kalesh Singh <kaleshsingh@google.com>, 
	Suren Baghdasaryan <surenb@google.com>, Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, 
	linux-kernel@vger.kernel.org, Qi Zheng <qi.zheng@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Stat-Signature: pekqrimt49g1mxdyr4trnnwxa6g5tuys
X-Rspam-User: 
X-Rspamd-Queue-Id: 1018720003
X-HE-Tag: 1776324755-77128
X-HE-Meta: U2FsdGVkX1+Sxt5c9MjJrKeZtFuJVM2P7J5DsjY/1AcekdxzUeFYDkOwtuv2XZWbR18ZVcazBsZWiVazQfz1V4RHhIjv+jGCZabf6hPHDjOuy9ikYHQBFZaiZKpgs4F5qLhi2hVNKDbzgRVn7Tc/Sb8QcLybBUHax78sV/tg/B0T13NEON5FU33216y/tN2W/HR2yG+r+V6u+u2A5eYkws60AJFIl2bQ9f0XB7lyKY6CFeZJbU2ek1Z8fJStY15vE5YrsR92+t7h8dYMS4tlBSTbidTNMPbq1QBhePTME3pnpJBEIktOnYKhbViU79l1Sk3w3PU3R1fKlHBOpTvNUJsaWqja+jvRAYCVHaJFNQEgKWmGyzs4QbYKZWaArN9Is2j1mdLw3XoKLHT6WhBcBb4RIsNbpOA3BpGXy/YDh20y/6Kdew8GCV/kSqE1z48RibfSX7ixNfVSSUbN0/j9cKMv/rNZw7sY8xPQEf5vCvjVILUz8mT9TMbwsJIU1yQjLQJXH3UNUYb3Y2FXZGTJ+I+T0Eh2kovgfgSo+f3njiSLjuPfQM2RmMsermoy6+HR899vo4uMKBL9As0zisGt3FgA19dqofJ7Ivw+uozghO7pUMhHv4RdLos0lzEHEUr4HGGab59GaI+u5RWBP6vfmuiJIJWNswgY/oNzO9plYifMLEdOvpR+6XraANqQiQTedWQbvJIPwDENQ4eTohTdehcBAAnIRw8BMlj3pBfuG8P6m3H6QvpuhvcGbaQxs7pp8LccFgAsa+Tw0jTALCm9ororwC10cKQH3PKgFlOi/ehzydrjhjdvKu2OYxDmfJS3iEqbCERT1meDyJdSNy2xB7pbdUBW8RUYwMw6cJ4uDNwikvePylQKlubl6+sfrF6a2ACIJGfjbDTCwP6CCPrYHGu7VDPo3ffV4RY534LgTz2wAgfLy3lYG97C6TYDHTm8AAEF1v5OJ4DIokCpI2T
 /p6mF1gH
 avIN+iiupcSy3j8RczLTDs2cYPBs8e31QOXKLtpA08rTG/um1Q/KRBmUxAQrmBdWI8hJ3yui0VwcPIDndpZnGnSIl6Ao9VT1HT6gmYm0x9ZBzohqFFmXQUvgm3SvJdBB2cK2qo3mENrxwuIpKGPdY0TERXZEVAKq8ImyshUGwN0zziyQ54rDRFw7yjDXuQuazzHJVqEKDhjVKzlsEXsutlZu0xSzqpOzsWicKseA16TvG8PD2lpqCSJ3P1ThizhTgNrgQl3P9z4DeYiCL6ZB2sX+EQUOnuEIrLlYzM8rNGgrMKTHRaU4/4+fNtjBvpqtF7kVngOjl4xfoEvU1Arr1XOTSUIQueWbqE4Jghi/FbNGgFpxpCiaB3cB0dZ4iS7tCpbTrlwNS/Beu4SyndaSt2siRs9J3VoUkxZUs3iofYEZ/z2xsrvzfbLTRdY9+RRN68mNl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 12:48=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> Right now, if eviction triggers aging, the reclaimer will abort. This is
> not the optimal strategy for several reasons.
>
> Aborting the reclaim early wastes a reclaim cycle when under pressure,
> and for concurrent reclaim, if the LRU is under aging, all concurrent
> reclaimers might fail. And if the age has just finished, new cold folios
> exposed by the aging are not reclaimed until the next reclaim iteration.
>
> What's more, the current aging trigger is quite lenient, having 3 gens
> with a reclaim priority lower than default will trigger aging, and
> blocks reclaiming from one memcg. This wastes reclaim retry cycles
> easily. And in the worst case, if the reclaim is making slower progress
> and all following attempts fail due to being blocked by aging, it
> triggers unexpected early OOM.
>
> And if a lruvec requires aging, it doesn't mean it's hot. Instead, the
> lruvec could be idle for quite a while, and hence it might contain lots
> of cold folios to be reclaimed.
>
> While it's helpful to rotate memcg LRU after aging for global reclaim,
> as global reclaim fairness is coupled with the rotation in shrink_many,
> memcg fairness is instead handled by cgroup iteration in
> shrink_node_memcgs. So, for memcg level pressure, this abort is not the
> key part for keeping the fairness. And in most cases, there is no need
> to age, and fairness must be achieved by upper-level reclaim control.
>
> So instead, just keep the scanning going unless one whole batch of
> folios failed to be isolated or enough folios have been scanned, which
> is triggered by evict_folios returning 0. And only abort for global
> reclaim after one batch, so when there are fewer memcgs, progress is
> still made, and the fairness mechanism described above still works fine.
>
> And in most cases, the one more batch attempt for global reclaim might
> just be enough to satisfy what the reclaimer needs, hence improving
> global reclaim performance by reducing reclaim retry cycles.
>
> Rotation is still there after the reclaim is done, which still follows
> the comment in mmzone.h. And fairness still looking good.
>
> Reviewed-by: Axel Rasmussen <axelrasmussen@google.com>
> Reviewed-by: Chen Ridong <chenridong@huaweicloud.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/vmscan.c | 8 ++++++--
>  1 file changed, 6 insertions(+), 2 deletions(-)
>

