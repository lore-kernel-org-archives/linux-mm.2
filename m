Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2AB0FCA0EC4
	for <linux-mm@archiver.kernel.org>; Mon, 11 Aug 2025 21:31:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C079E8E00A4; Mon, 11 Aug 2025 17:31:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE00C8E0091; Mon, 11 Aug 2025 17:31:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1C6E8E00A4; Mon, 11 Aug 2025 17:31:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9DC448E0091
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 17:31:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 24D47C0227
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:31:38 +0000 (UTC)
X-FDA: 83765773476.18.4C49047
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2F7F712000A
	for <linux-mm@kvack.org>; Mon, 11 Aug 2025 21:31:35 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCBeBJmt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754947896; a=rsa-sha256;
	cv=none;
	b=C43gKp82HrQre+A5HJLqryRRJ0bFaFvsrCprqNVejwbQkHlrzt2WGVtZvshMPx+R+mzya0
	GKjoUSsCFGRy91oBkuc0ahXdIA4UpHZP1Y0s5fLxwrvWns54sVzAVGwmkamyTOwDg+/y2E
	SbOWgX5xbiRSQ2Po3/+kneDYLVJro90=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GCBeBJmt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754947896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mmwYpasJW0d8pQJPWzSNzQnwsfBE31Dbtu9ygTvRtHI=;
	b=ZvrCN6BozUKEIZ7i0n2SrARSCdWgzn24JNPrNsPIhdXrlmddu+NKYMcvB5QF4HxLJkmjLu
	aVlYCnN6mAzIZqy+fk2CwqZE0x2umXanN4ns0pbEQ2TkKQxJCKclfH6IgkiOBZGRx9ooGO
	4QnAHbUHOgC+H/MyilisIv467baoCu0=
Date: Mon, 11 Aug 2025 14:31:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1754947893;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=mmwYpasJW0d8pQJPWzSNzQnwsfBE31Dbtu9ygTvRtHI=;
	b=GCBeBJmti4GhQF/v9x3g0yrh7KOUcwYuUIOw+XnLyYUQ0v7R6os5PdkLj2YRHuqj5LJVkJ
	mrztlFNm9OpKrG8JLm/MWVHCqC8c3HST/Wk+ENEhGfl/g7n9+C+4iD9JYKPs30Pz3TnP9e
	y2Tcf/noENLxElI6awRqGD6/JvuDwWA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Tejun Heo <tj@kernel.org>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Matyas Hurtik <matyas.hurtik@cdn77.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
Message-ID: <kiqfxuepou5lwqffxhdshau5lw6bkkrvshv4ekhvrmugweipau@rreefm2uttjp>
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <aJeUNqwzRuc8N08y@slm.duckdns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aJeUNqwzRuc8N08y@slm.duckdns.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2F7F712000A
X-Stat-Signature: opwzxosmtizihyii7a45tutoea5hnaeh
X-Rspam-User: 
X-HE-Tag: 1754947895-430288
X-HE-Meta: U2FsdGVkX1990jyY3IbcmjgHZzeCe+YmPeiIpSBD09MmXfNFd3V7QMxqXAxbueIVv6RJ4xkBXp5UcBnjKi1b1yUYxq3mELcXhgtMb6y8bmiNSTMy5pCup1fqd2WsL5Dvq0mHyM8zq1GXOUgWsACTc5SdI1IAfxCfE9tpD9ffH2dqm9WsVjZbxsKHh6GoE4mO834dGgrVzWouaGI3cDhEkNh0YBhHIFmdCbIWJXY2npxrZ+0td+7UMB2E7tvXvrAL5wAq9JsPqC9ucnDxUfM8lt5qxdWHkiNVkeC59P0e9h8wG69wa4zDLKFiHe7YsDD/wXtr7tnBw8SzB+BpJ+DJ/GtIIQYT9ZBsmrfO7Gq1EnRLtgwRzqRhOCY9KqwBCfxjnQIK8hY7rCAYCMGIj6/CVtidf6riecgfiuVrvxEvzBqFqSCwwazCt0dLs+VlOpe8jlIV0RZVwqL/YZhdDC/2QJSvm+g7EygNojdQdhNz5Fdi15l0RlsSBPdLexg7pm6lvwi5bo/SOI3mUxqjt96P0eX5HDC+CHysI96VBUVU9RoB5iwYxN3umOjp9qHkZr2yuIgFGy8H2hLawCmerS+HCSCyL0OmetHENVNNcirPAEJg2jTsBpDaEiard6Zt/PQu6pIe0fODNYLqtPRLwE61G/0QP92D5p60R5euIUoHxr49ABiLHdF93se+fAQIchruHfj+SVjqLh/gp/paoffzMqtRSP+cgL6zVJKajkCw7fZSdrE1diyVgIh+eWtYoLILKGmp2+ArOh2Mna8yRvNSMGyvTCZkbRIRvDmRvcyt3RaEGPZRkrJhGJ5vEXSlTkGnEjygkK7TTDq7OHIINV/C03IyutR/L5irsAXnzTKteEMlKT8lAYku3RN4oulligYS9rBXGYmY9fbILENzXRSzCzn8ejvCnCstqFIjnFdP+gJC1sxi2kgM6M/aiNJH7lfANg1H4JcXjD0ynNKoOSy
 SG+n2syR
 o/qiWXK3tfX+o9h0hLxv2QrdbC3GfqWL4G7Tw2f6aNybwJ3YYkdSLP6iRkkWFphoir1aqD/QYMEE6uMhXbRvVfU6mRSZp6Evt5J71CXkpOIwV0HbOhGRkS7TJ2A/9DWWD8HNv6r3GrTdY45J4pKGPVToNN23CMNJDfsQRL+JYdzvCzDmFo7bGivXmzyQH2bGgGpKJOApCG4AbBmCt5tdJuyQyqwx0w/v1ZrUZk0GNKSmNmYdzVeQX507s7HjGE1H0gUNueWVqSJPKH50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 09, 2025 at 08:32:22AM -1000, Tejun Heo wrote:
> Hello,
> 
> On Tue, Aug 05, 2025 at 08:44:29AM +0200, Daniel Sedlak wrote:
> > This patch exposes a new file for each cgroup in sysfs which signals
> > the cgroup socket memory pressure. The file is accessible in
> > the following path.
> > 
> >   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> > 
> > The output value is a cumulative sum of microseconds spent
> > under pressure for that particular cgroup.
> 
> I'm not sure the pressure name fits the best when the content is the
> duration. Note that in the memory.pressure file, the main content is
> time-averaged percentages which are the "pressure" numbers. Can this be an
> entry in memory.stat which signifies that it's a duration? net_throttle_us
> or something like that?

Good point and this can definitely be a metric exposed through
memory.stat. At the moment the metrics in memory.stat are either amount
of bytes or number of pages. Time duration would be the first one and
will need some work to make it part of rstat or we can explore to keep
this separate from rstat with manual upward sync on update side as it is
not performance critical (the read side seems performance critical for
this stat).

