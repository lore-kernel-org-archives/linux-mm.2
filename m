Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D4D1CCF9EA
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 01:30:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A956B8E0020; Tue, 28 Oct 2025 21:30:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A1F2D8E0015; Tue, 28 Oct 2025 21:30:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E7058E0020; Tue, 28 Oct 2025 21:30:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 79E0E8E0015
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 21:30:50 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 163D659804
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:30:50 +0000 (UTC)
X-FDA: 84049422660.19.CCF7E62
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 7786E40009
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 01:30:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQS9ejdW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761701448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GORi2px2GxRY3sY5uWSfO9+mtlOcFZm+R2VfJSJQ9Ks=;
	b=KgkFTozxN9sCsTEEZlCPZ0dqhUojOCv4EBBPS0L2fOYWL8yboMhovi+cSrXo7QXflPzjjo
	FjvtqEE0jMzmr0n9M2tmL5Bmt/iaQEr9RaCZ1eR40Ub8ItkqCAAxw6XuJtFN/bQWkLtL23
	TdAL0oFJEBWrOtsOHsyl6eqPnP/IwDU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761701448; a=rsa-sha256;
	cv=none;
	b=w3xXwMVW07A60Av6XrCN7xcNCvGKCJirq/EVnZCIE49r5vIQfPM+zD46FFMc0iX1u/vYe9
	+GNryQTBuCzY5u9tg1317ouIyMCT/+IdsCkyi8TNwCoi9KCaEcQUU0+Hxz2CUP7lOOnM74
	1iKio0Li0hb2EKcoQQMYPehRa/jxCpM=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YQS9ejdW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25B1F43C79;
	Wed, 29 Oct 2025 01:30:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9091C4CEE7;
	Wed, 29 Oct 2025 01:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761701447;
	bh=EQ3bCZVkdN7EmwD6AJ9LPqgIC7BgFpto7zSZs4VVicg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YQS9ejdWNO3Nbu7CZGOCbhwse4nNjgQROuhmP7+TM3dqdM451+M6oR30jF6RusXNo
	 n9F41W1NMQb59DJ9KQUcDMReSA3EtfZVhyosoTRlvg5Qw6LErwqQs3VYBQO4pNLl5I
	 JE1qZkKJMsY7WzYklJZL3w2LHf7vQiR5Xh36UR/gAAbuBfM6hGgc6Nq4lFji/lJvuh
	 6Wk+HS+mX30qdTFiMh+MIDdYNGqZ5MjJ9BIyq8Zaitbq4NC9r3PU2XWheGWBDwLpcc
	 yAr2Dmgm9MG5wn1lHoEa5C5TUeCC88ZZopnzT5tU1xkjArB73VYrg6ZuNFqzeGSpom
	 kyIWxMI633VOw==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Quanmin Yan <yanquanmin1@huawei.com>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [PATCH] mm/damon/stat: set last_refresh_jiffies to jiffies at startup
Date: Tue, 28 Oct 2025 18:30:36 -0700
Message-ID: <20251029013038.66625-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251028143250.50144-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 7786E40009
X-Rspamd-Server: rspam02
X-Stat-Signature: ncbfbs5byhph5spf1dbnipt6hi4b1um4
X-HE-Tag: 1761701448-540754
X-HE-Meta: U2FsdGVkX191mGMsC/9abvCljdXhpwCDKkjkApfE3KjCg7B/QyiPb/TZZDJgsjixLNVUAT732q/KJo1I3xDi2u1KcI6Dodpo86kUeJQdTRD5G/zppgYZRo6r9auMjgvC3RC+ZaRukuIBtBln3R5D2r+9e3zWm9+AHd5HrakpNdGW1SBdQfkZ+ZJ3fqlubowt3vTvQgM1o79t64jVGsGtirP0jUxaMxp5z482CdR0rLLk23P08+1uEf0qicoySrTtGKB1PUHpQMmId8EDFEAo3GmvjVjsIOUbghTuE5TYTW1ToB91Njpvsn4k87IKTEc1mznoADA4WmW822tY+42IIQKmJiNAi1ebijqE09SSipDkRMHr6/cMwx3tuZ7Bc+zreiNr8KY9PvI+hMT71gOZsVf0gD9w3d1f99TUiZgMNltAjFoxarHOcM84TGgcz/VlVYBwqFKKV3PCU3MN19LxoFmqowOigEZxuZunWlMCMcpsHHHDa85sTuMzIs25Y3oYGAZOenQxgVRGs4uuQ/i1KfwfhIqUst2D76iMs8XNjmxwlOV5+MD3vetX6Y4lGBkFX/rYzBdVQa9Y8/YTw2TCWrZc5ZgQtN9yGniKsA166jNmy9+A6Gp4oScg4zCXEreTXs21oj9Vf5DxjiasMAA1hdYjcUvv7iFe+M2EW2Xv5+sfb7hd0bVjRPSaoV1AMySILuWjSTr1ZjDmNbCBFhoFNYpVLwaC1VLbMI+Zn+5NWnPJEsO/WHvJZ0lftqQjhl+fK3noHaomedoxntDGTLGtR3rKxyx9Q/454cme7ylOC564dUhkFl+6QLrr2KQm4eagJX4IYWVFnVNR2e2ovSeqSzy1LbY6euqapZkU6mls+vvuaC3D3cSXjWlyYjqv3ZKmAWOjctJBJ9UZADXWMIeEAf40I3/vH360Q0PHiicYMYzvFKH4FrYImhDRQ+eZ6wPp
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 28 Oct 2025 07:32:49 -0700 SeongJae Park <sj@kernel.org> wrote:

> On Tue, 28 Oct 2025 07:19:14 -0700 SeongJae Park <sj@kernel.org> wrote:
> 
> > On Tue, 28 Oct 2025 14:19:27 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:
> > 
> > > In DAMON_STAT's damon_stat_damon_call_fn(), time_before_eq() is used to
> > > avoid unnecessarily frequent stat update.
> > > 
> > > On 32-bit systems, the kernel initializes jiffies to "-5 minutes" to make
> > > jiffies wrap bugs appear earlier. However, this causes time_before_eq()
> > > in DAMON_STAT to unexpectedly return true during the first 5 minutes
> > > after boot on 32-bit systems (see [1] for more explanation, which fixes
> > > another jiffies-related issue in DAMON). As a result, DAMON_STAT does not
> > > update any monitoring results during that period, which can be more
> > > confusing when DAMON_STAT_ENABLED_DEFAULT is enabled.
> > > 
> > > Fix it by setting last_refresh_jiffies to jiffies at startup.
> > 
> > Nice catch, thank you for this patch!
> > 
> > > 
> > > [1] https://lkml.kernel.org/r/20250822025057.1740854-1-ekffu200098@gmail.com
> > > 
> > > Fixes: fabdd1e911da ("mm/damon/stat: calculate and expose estimated memory bandwidth")
> > > Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
> > > ---
> > >  mm/damon/stat.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > > 
> > > diff --git a/mm/damon/stat.c b/mm/damon/stat.c
> > > index 6c4503d2aee3..6dc3e18de910 100644
> > > --- a/mm/damon/stat.c
> > > +++ b/mm/damon/stat.c
> > > @@ -132,6 +132,9 @@ static int damon_stat_damon_call_fn(void *data)
> > >  	struct damon_ctx *c = data;
> > >  	static unsigned long last_refresh_jiffies;
> > >  
> > > +	if (unlikely(!last_refresh_jiffies))
> > > +		last_refresh_jiffies = jiffies;
> > > +
> > 
> > How about doing the initialization together with the declaration?  E.g.,
> > 
> >  static int damon_stat_damon_call_fn(void *data)
> >  {
> >         struct damon_ctx *c = data;
> > -       static unsigned long last_refresh_jiffies;
> > +       static unsigned long last_refresh_jiffies = jiffies;

Please ignore the above suggestion.  It will even not build, like below...

.../mm/damon/stat.c: In function ‘damon_stat_damon_call_fn’:
.../mm/damon/stat.c:133:53: error: initializer element is not constant
  133 |         static unsigned long last_refresh_jiffies = jiffies;
      |                                                     ^~~~~~~

> 
> Actually, a similar issue can happen again if DAMON_STAT is stopped and
> restarted by user.  That is, if user stops DAMON_STAT just after
> last_refresh_jiffies is updated, and restart it after 5 seconds or more, the
> time_before_eq() on damon_call_fn() will return true, so stat updates will
> happen earlier than expected.  Shouldn't be a real problem, but better to avoid
> if possible.
> 
> How about making last_refresh_jiffies a global variable and initialize it on
> damon_stat_start()?  To avoid unnecessary name conflicts, the variable name
> would also better to be changed, e.g., damon_stat_last_refresh_jiffies.

But, please consider the above one.

And I just realized a similar issue exist for next_update_jiffies in
mm/damon/sysfs.c file.  Please feel free to send a patch for that if you
willing to.


Thanks,
SJ

[...]

