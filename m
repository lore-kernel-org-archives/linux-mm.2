Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3FBE606A31C
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 00:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=StOVEISL
Received: by kanga.kvack.org (Postfix)
	id 91F4D6B05B8; Fri, 30 Oct 2026 20:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D0146B05B9; Fri, 30 Oct 2026 20:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E6BD6B05BA; Fri, 30 Oct 2026 20:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2096B05B8
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 20:46:51 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8C6BC053C
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:46:50 +0000 (UTC)
X-FDA: 85381081380.01.71A13D1
Received: from mta1.migadu.com (out-34.mta1.migadu.com [95.215.58.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id E11A5C0005
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:46:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=StOVEISL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.34 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793407609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H7Ifc7p7cHcO1C78lzF+gI6I9rOcTVWv5sLtNAQ1MO0=;
	b=ga1rZBaGRajsax9DWZ/V2NAdlqFKSpKI3q3FTpfr6ilbOxGeHsxCLBUQX8ShZbbUlF6j26
	vvWs7PTGxae9Y2Aqd/73t+BZ0dcxwDvxNuznXHQKJWwQpj4OFYLb49FnfYFmqP43A68smP
	/SZzPxy8+J0xAaPzvB0kSpF7DZCBGsE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=StOVEISL;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.34 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793407609;
	b=7Qz8gwSuJCJLOg429yPZj1PKW8j0JaT9GfoUObndU6q766c6Rn++PglCXrXf5S5DLhmglm
	MXcl0oUH7oZblvgAYw2ki7aHugIVizwlE+an7SzZjFuWqq5hA5d8XOpRWlCYfGxxAbdALR
	hDxIBo32sJ6fnr9qukT7+qYNKRb0dGE=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z26c2PyZ8pF8QGqqT2YXQEk7jdeK6dxDZwh05tv1Xdw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793407607; v=1; x=1794012407;
 b=StOVEISLs7OTCFFflGvKw3SGY3u0LB+qtHOZoYHM907Qe2I2bliBtIMwaVx+X9XV9oDdZhX6
 bLwv6fhv4B1GGNxmjaxcHbXmWHIqDa5viGyTJEQjrRnrO5qvYvuTCDBPgdIRpYdqow2OdTTLZpP
 UT8a7Gr/3H22m/GTp4QsGiEY=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 619347082113727e;
	Sat, 31 Oct 2026 00:46:47 +0000
X-Mizu-Trace-ID: 619347082113727e
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v2 2/5] memcg: force charges from reclaim before trying
 the limits
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261030205418.341214-3-shakeel.butt@linux.dev>
Date: Sat, 31 Oct 2026 08:46:31 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Tejun Heo <tj@kernel.org>,
 Harry Yoo <harry@kernel.org>,
 Meta kernel team <kernel-team@meta.com>,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Michal Hocko <mhocko@suse.com>
Content-Transfer-Encoding: 7bit
Message-Id: <7CE7A687-C45B-4F99-8F58-88633E052D85@linux.dev>
References: <20261030205418.341214-1-shakeel.butt@linux.dev>
 <20261030205418.341214-3-shakeel.butt@linux.dev>
To: Shakeel Butt <shakeel.butt@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: E11A5C0005
X-Stat-Signature: 4eigfnuezquragtafajphnnpyam791us
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793407608-253874
X-HE-Meta: U2FsdGVkX1+7+BjQiyfbYxQchNfQosx3Nuv8hZxhPuZEnzRbDUlclbGKLkipevxtXCT+TJlLe0wlhbKFPwERB5KRAXVlrSLFA5zZgTXKIECJOyfENaxOVyfBmVqA06iAXAPl9Tx9XAJIv2Y67uzjtqu043AEWOLVwcu/C1xn39YLYwNV6jPLKrfYbJiWufHLlqZnXOlGYPM2/j7OgV5IoQ+RMd2SRUEnE9+XC55sfDFQnsChwGIdOBZWrFzQmdD3JJqDT2dlnjvkK8KyTzg+wMhARnqIB5Ziic6h5Zqcak6RJzt5X/cCKMbG0n7OqoSOl4z7yr2hNhxCH/Virrxrgf0FBCyy3J7ixzkyvK81lMr7VaKHGnxrZ2o6ZS49k37dQMueRvRt3E2xyZ5CTIGoTYrkjYBa8p4U2RnEGX2Hy1ionyfJzSnNJzLr1uvlYFxOs/gAGqnlGNPf/WAw4pUxZ43tkUyma7ODxw1bWKHniKrKk/TdPd0iVz41qaDpEto+25ov8dCfUbeJsdiYd95JV7zyIBz89+XWAdOYOhY8+armEipIlPzCBvVSxEJ1xV2/r8T/iB7gnur+waTttfl7hKDJ2K1F8KmuR/a5XoOqZHmlAzoBpZ+n5o+aM2GOPsh1LfRxMGIS+PQiAKloUG8y/DCGOkpwVLNa69TTejhjWIgkjIBQfhJy1NvTUZAHLHoksCBCAMft/tTOYQKkmvWw2LunZww50v3Lh1S3ntIuO+X69X5wh5JB5t5WbDeZqbR6VXUjWSplP1PtYbi7HUXFkP4ujKBJdl6hItbSfrXYO7lghlGcQdj/I9aaoYFXfRKIhQqD3IVScQT5Hv19QH149SDAVX0Zc9CAR8Xjx3eGwgfs/WIIX//Thr9Zq9jbxJozGBqNrI5VREVIpYnw81xxKaxkPROtYfiDAA07kKpLcN0NSpzc5x37ET3HCpMpoteEpsBQmhopE2XqAj8oZbb
 4XDhjKc4
 cOdPX5JxVL2VD2xQxncSSGeWxAfxSC8iirwq8Wt79WXKjhsV83/MKlGbyrLQN5QmWzIp84H1Z2Xr6M64tJH+vp8YYyKxk35pcpqwZWdl8yCimuzgfAFRVP0cb1C5tv/ZmGWwZ0w6omLoC+GdTtJEtyXt0ZAQLO4WPTlGQfoxb6m12JSdUht/8tMiwTlvI8yLogsig+JKV8f/R79w0YFJIT1Z6toiywWQ3BtFoF1c5YDu5HZmmocaGOXSHy1PfEOiPUokWtB6QwkYOu/kPCK8p82onI/j0ytg1fHNnlVUvh2mszyWQlIcv+GGMn4SuLbS5PlqpQv6oasA2NileIgoYQ6oMWiWBRJkahsvyrlFCxA/D8xU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 04:54, Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> Reclaim can charge memory, for example when zswap stores a page.
> try_charge_memcg() forces these PF_MEMALLOC charges, but only after
> they fail at a limit. A charge that fits still has memory.high
> enforced. That can make a task in direct reclaim do more reclaim and
> sleep longer later, and kswapd records overage that it never handles.
> 
> It is also a problem for the next patches, which make kernel threads
> queue high_work. The worker charges memory from its own reclaim, so it
> can queue itself again. With those patches but not this one, the worker
> queued itself in 118 of 284 runs in a VM test with incompressible zswap
> data.
> 
> Check PF_MEMALLOC before trying the limits. Reclaim charges then skip
> memory.high, as they can already go over memory.max. Drop the
> PF_MEMALLOC check in memcg_enforce_high(), which no longer sees them.
> 
> Other effects:
> - As before, the check reads current, so it also catches interrupts on
>  a PF_MEMALLOC task such as kswapd. Softirqs set PF_MEMALLOC
>  themselves for swap over network, so the check can't be limited to
>  task context.
> - These charges no longer charge a batch or refill the per-cpu stock.
> - MEMCG_MAX still goes to the first cgroup that the charge puts over
>  its limit. On cgroup v1, memory.failcnt no longer counts them.
> - high_work can still run again and again when there is nothing left
>  to reclaim. This only stops reclaim from queuing more reclaim.
> 
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


