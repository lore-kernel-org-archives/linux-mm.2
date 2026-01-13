Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C5F1D29DE0
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 07:13:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCD226B0005; Tue, 13 Jan 2026 02:13:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DAE366B0089; Tue, 13 Jan 2026 02:13:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CDA6A6B008A; Tue, 13 Jan 2026 02:13:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BDBCE6B0005
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:13:45 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6277FB6910
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:13:45 +0000 (UTC)
X-FDA: 84326075610.14.57A4BD7
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3AFAC1C0003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 07:13:43 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R0ss3vem;
	spf=pass (imf20.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768288423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+ZKW0GP1b7GKPfgTqUx6aEoV/9mqleFS1zBFdDBGto=;
	b=gty0fyk8OZNdb8EOIvkV0K3msTGvWuk6BawDsbKlJJxO1IFG8+RYbT3k5OkA8Ot+0DmV/5
	++chSsBuuOYTLDUHGjVzV/1nnkMzvBYP4fLCe0UBUevs3pNawWRWYT/osBtH9VBMg3X6T5
	+lXz79yGhjzjkFzn6mWv2XBuE+rMsAM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R0ss3vem;
	spf=pass (imf20.hostedemail.com: domain of yajun.deng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=yajun.deng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768288423; a=rsa-sha256;
	cv=none;
	b=m97LPTfg/zZlOe4J3XWI4YBt2bgOgrmYAlmhof5wt1gEyr0u1ijtD+DfkIM+PXPJmtSFHY
	k9uSbYhf128abCyqJznkd8SEM2eN9BsuqhDdqEUk7w1uIVU4JS4NoI7VuvmJ1/WjChxWCx
	fCqFvP+W8WzuBrP+OFHGQq81Selhf7U=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768288420;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Q+ZKW0GP1b7GKPfgTqUx6aEoV/9mqleFS1zBFdDBGto=;
	b=R0ss3vem79jr77oOiAFgGjgTmEo0vBmk+oZ9KzSSyVrsLjKmPwi4zhcCWWfB1/WczmVXx/
	dExB0NiRgCH0LvFSUNKWCPk7wf4pILOruJVmNfvQLed2yFTV05XjJrzPBK4NiVHcOt5ZO1
	DwLaYjssM0823dNLLQFY40S+LJ6fscY=
Date: Tue, 13 Jan 2026 07:13:39 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Yajun Deng" <yajun.deng@linux.dev>
Message-ID: <5cda8821bd3ac432a06698fa7eebdab0aff77452@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm/page_alloc: Avoid duplicate NR_FREE_PAGES updates
 in move_to_free_list()
To: "Johannes Weiner" <hannes@cmpxchg.org>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com,
 mhocko@suse.com, jackmanb@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "Joshua Hahn" <joshua.hahnjy@gmail.com>
In-Reply-To: <aWUKKyBZzsCBELLi@cmpxchg.org>
References: <20260112121614.1840607-1-yajun.deng@linux.dev>
 <aWUKKyBZzsCBELLi@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: peyr3x9zwnnqzpxd67qs785ksr1yogdu
X-Rspam-User: 
X-Rspamd-Queue-Id: 3AFAC1C0003
X-Rspamd-Server: rspam08
X-HE-Tag: 1768288423-970615
X-HE-Meta: U2FsdGVkX1/rWwrT8rBdU5COuGYOe+5u7oCS5Kt+SyQhxxO0mzfQXsikTEXn5tmiwLh+cfypkFzOEdzuQv2az4TVlao5apOZ7BIm3Hc714p34wDR1IV/KX8P2Hvm1fi7tII8HBv1USp/R3XfnpSld6+SiR2HeMxE7ufAviVx65uY2Zrly9daTSkb2VmRBtRCGJe7x6KRxM0wmzy/+1pX3cNx43B2D8xZnwV38nzpOQ1cRUoPhhV+qJzy0uy92CoYhsLT4ynl6KDzIFa/DRjOENAdO+w5nIvqRY9TbcP/T8u+RYGSMHj8tNqueaUlJTMwN78QZCdWNO5L35d96k36eawYgdTf+rKEHeEJUtVznF9qMKBNX8kBfl4O3bkvruRx+IsHg3169Qx7ouXPI9nIpNqYAeX04lOl+w9ZGEac1laGn3jmWxBSJr0vx5WrKKibTLzk8VLPHbDqCsv8IopMvqlIoitjeXvV8ltBbiluAcUs/qfm97xD72pbko0P8NB9ssDE0yioiK40kNDFLKrL5jxeXRNAKMxOIPWJ+UkH4fXdCqYRzk5TXEhkS0m1ew5AL4rGNHPyi9PKYahQ0DqB0cQJF6SheT1bhw+3vZjlyUtavAjJAat9nEdPQ6NP3+3EsObJWAo6+c0zXGE/XbE7zvfWr6unCJe/a3IyDNV3n+r8+dwmKJR7RyqJNPar3FZJSWZQxWReqfGxlfai9kdLCwKIaOMwoLwyMOxswJ2Yt4DCZ3sG3e4HgN0yZe5u6Ux29qVFNOizF2DOovWfFoPwghqoG+NwuPjcPzfH07RjTI93yKW/pBvoK6iBzrHpZhU/TSoik+p8VfvRBz+Lc80sgRf0VOctXgcjeHMn8cnIpszpsL/8gDayVL/Ea3w/WJAzsS9Ug9VJdcTR9pT0G65JrmdL+WlostA2jyI55/7tEv6NdFa0EMSgMcyUldwCtIkbwbWuJ01EHN4fneeBElT
 RUEeuFNm
 rhYvfK7VsDtoh7f8uhbVlEkdmu3oEi1R8OR316sSyWW80f6xU8Xg5vtAqBjCDROfeE2fVkkz+/2kYBelJz3oG/89yPme7JqpBKPUwid9lvhUCvGOvS7Zh0tkuXri9tkP+U73YvN7oF30h9vUBsa1gS55jHey+a3hmke9CRMPlMzSrOFC3uX5qeKdr9s5ZnLBxrNzRR7MDnPqOSxjMMkAbXHvckuW+aYNWtri9nKbVfDuUJ+tVXeasWwR2XIfVk5kn3kWvs/hGzl1XDBdFMbbpcO27+m8BTR0LIAtbydDgLGeJi6Zznha1Z/A/xEU+TitnnopyG22G5JC/2Y3UqzwTwa9m1FGB1LWud91SfTxrTAOOd2jvr+vBk7LO10pl7a6jMqxdUukLKSN6zx5F3TVAC+m56y6uL8IpFzdA/SJPO5i+ZzQFVx8yQed4dQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 12, 2026 at 10:50 PM, "Johannes Weiner" <hannes@cmpxchg.org mailt=
o:hannes@cmpxchg.org?to=3D%22Johannes%20Weiner%22%20%3Channes%40cmpxchg.o=
rg%3E > wrote:


>=20
>=20On Mon, Jan 12, 2026 at 08:16:14PM +0800, Yajun Deng wrote:
>=20
>=20>=20
>=20> In move_to_free_list(), when a page block changes its migration typ=
e,
> >  we need to update free page counts for both the old and new types.
> >  Originally, this was done by two calls to account_freepages(), which
> >  updates NR_FREE_PAGES and also type-specific counters. However, this
> >  causes NR_FREE_PAGES to be updated twice, while the net change is ze=
ro
> >  in most cases.
> >=20=20
>=20>  This patch adds a condition that updates the NR_FREE_PAGES only if=
 one of
> >  the two types is the isolate type. This avoids NR_FREE_PAGES being
> >  updates twice.
> >=20=20
>=20>  The optimization avoid duplicate NR_FREE_PAGES updates in
> >  move_to_free_list().
> >=20=20
>=20>  Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> >  Suggested-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> >=20
>=20I'm not a fan of this.
>=20
>=20The code ends up more complicated, more lines, and fragile because th=
e
> accounting decisions are now spread out over multiple places (again).
>=20
How=20about V1? It will introduce=C2=A0account_freepages_both().
https://lore.kernel.org/all/20260109105121.328780-1-yajun.deng@linux.dev/

> Is it worth it? move_to_free_list() is used in page isolation, which
> has to do the accounting anyway; and migratetype fallbacks, which we
> are trying to avoid as much as possible. So this path shouldn't be all
> that hot to begin with.
>=20
Not=20all cases are of the isolation type. There are indeed=C2=A0duplicat=
e caculations.
move_freepages_block() will be called in=C2=A0__isolate_free_page().
Both old_mt and new_mt are=C2=A0mergeable type in this case.

> Simplicity & maintainability trumps here, IMO, unless you have hard
> data showing this is worth the pain.
>
I'm tring to do it, but I haven't yet.

