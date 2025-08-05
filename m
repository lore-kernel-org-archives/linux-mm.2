Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B14B2C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 14:55:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42F3E6B00AF; Tue,  5 Aug 2025 10:55:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 407426B00B0; Tue,  5 Aug 2025 10:55:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 31D0B6B00B1; Tue,  5 Aug 2025 10:55:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 26FB66B00AF
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 10:55:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6EE0B140116
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:55:12 +0000 (UTC)
X-FDA: 83743001664.27.211EF67
Received: from mta20.hihonor.com (mta20.honor.com [81.70.206.69])
	by imf29.hostedemail.com (Postfix) with ESMTP id 9E17E12000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 14:55:09 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754405710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cgGcAvpEC4s6ikx6dYr46pVh7U4bC+vm4ncZ+popWZE=;
	b=nhbqPZfOzz94KonqGLxxxJzHMCUl91m1DHSXkoVipE0FSEXNkcoqeLiuEDx34zObbJ83Yl
	0HECAsNPSGXHV/s9uYkl+R7NuujPu+97frKj0cg/JLIGkJGiZwcFawlF1VIqK7GMkF5hiu
	5uJMXer4h4f8vTzUQzk3Jw5xBm10qHA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754405710; a=rsa-sha256;
	cv=none;
	b=IgibROMWj6Abh6H3ZgBVFpNwVtzsCPTmX2g8ZysiO5Gh3LMW0UBpLAk9q+w7c1ZRkE0tQZ
	Rvjp5CTqdoKPnhqZAEGnwOGN77REqDCVl3bhGuAhuRlFMeiLIpQa3IP2/wggnVM/Mt6diu
	/g+j9upZm1tuvc4dBPkv9p/WNys254o=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.206.69 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
Received: from w011.hihonor.com (unknown [10.68.20.122])
	by mta20.hihonor.com (SkyGuard) with ESMTPS id 4bxGbl51hszYlngv;
	Tue,  5 Aug 2025 22:52:03 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w011.hihonor.com
 (10.68.20.122) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Aug
 2025 22:55:04 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Tue, 5 Aug
 2025 22:55:04 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <akpm@linux-foundation.org>, <andrealmeid@igalia.com>,
	<dave@stgolabs.net>, <dvhart@infradead.org>, <feng.han@honor.com>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>, <liulu.liu@honor.com>,
	<mingo@redhat.com>, <npache@redhat.com>, <peterz@infradead.org>,
	<rientjes@google.com>, <shakeel.butt@linux.dev>, <tglx@linutronix.de>,
	<zhongjinji@honor.com>
Subject: Re: [[PATCH v2] 2/2] futex: Only delay OOM reaper for processes using robust futex
Date: Tue, 5 Aug 2025 22:55:00 +0800
Message-ID: <20250805145500.29079-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <aJGiHyTXS_BqxoK2@tiehlicka>
References: <aJGiHyTXS_BqxoK2@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w002.hihonor.com (10.68.28.120) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9E17E12000C
X-Stat-Signature: c87ommjzwmwjfe5wtacw5zfspuby85ge
X-Rspam-User: 
X-HE-Tag: 1754405709-497920
X-HE-Meta: U2FsdGVkX1957W4gAG1hl2WkTjafYGbdpSQt8dFDmIXBVZod8im6bv+zypemz7CRetB8juMUFIA1mYRF6jc8CuGUZ3MIvLgVuseOkm7JpDO1kWmeawh/b3JyXcwAfFj3QlEun9ZuKruRPKk+FnWtbykplRZlta2nR0KxjPR93yCYkNrDtoEX3e+LUrEqmOVJzsTsa0QplKFUgJhRdERGqUZixCmDyoKlXb2BFWiLyJMJFio7ZLs2weyLJLtNsm8YXqwYGCzaKldNbtlYk2cFMAR05OzhMz3JYXgVFEiYg8gUpy4skUZ2SVLhTJtFFt/PidGvlUQ0S9hgk3nNBFc+So5XaDHlthHwC3hAVtpQpVd3RY+PL5jAdtYNmRDkXoFaLGQN+bqldV4OTLz3g+/x3+q92YGUvP2Kyt3JGQbGAWFaLP515McgWW2jv9fqgK5t0JJJAFq608TyZ36kxd9wx2IQRJtSvQGctowGZ35LamkNGEtmt2gz8zWh5opWhDVMmv5jFGipJTwuEVZCnUQDp5QHOHHONTKP21pKEDuhE2jMCAQ/bdnYWFQdI3xL841B5I7Jnwhesgf7NM2b3dqKIbykYjMhXG7kdfjKedJ6M2Hjt6+gvAf1U8AH1sy6ZdT8jtI3RC5S/mOzjPir4Pke/KtHdemVYvs3oMBD7byTWdqosjzvyVt8C7oB0BZxHFJzu1goCi+eGQtBIQqqI5uQw34zbceeSZTsINn34Q1KKZ/N7drc6vC20H8YGCCuDjekQMs6xO+IuPb3VK26c6PeQY4W+i5lmBmN9imBsCuuv6iqR1JFUWC2/MvGZENMCx0UY9fbwai1e3njsYBggxqJTr0xHUCFMysJ2ZQLLSDOjoPDcMxCQTHOU2XGEpunR1Gc/a6L/CfzW3HgrjyX8KoVHLczr41nYh48prKaLxxUIRRVOChmN1FEHcHrfJAbWd0tQAAXdITQ2UiIgYW4KK/
 EQteNL84
 hn+QHFSFE0gPHu5LE/V7h+7mehg5V1VWU6GGXjmxKU1/cTTbvjZGJS2ZEIB3Lu0utZPeaWETD8g8eCRWdKxugc2yPpi71t4/JuMkFilnY6Mi8sUpTL4iRjKsV/5J0ZilSS6BhWz/48KjYRYfA38tKqJ23JtoJPjd4OiDVRqqHZFa2e1BbPZD6VmQgeQW+GoK25VwCDk37N1ztd3KTtVnoCgDWBw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000004, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon 04-08-25 14:01:40, Michal Hocko wrote:
> > On Mon 04-08-25 19:50:37, zhongjinji wrote:
> > > >On Fri 01-08-25 23:36:49, zhongjinji@honor.com wrote:
> > > >> From: zhongjinji <zhongjinji@honor.com>
> > > >> 
> > > >> After merging the patch
> > > >> https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u,
> > > >> the OOM reaper runs less frequently because many processes exit within 2 seconds.
> > > >> 
> > > >> However, when a process is killed, timely handling by the OOM reaper allows
> > > >> its memory to be freed faster.
> > > >> 
> > > >> Since relatively few processes use robust futex, delaying the OOM reaper for
> > > >> all processes is undesirable, as many killed processes cannot release memory
> > > >> more quickly.
> > > >
> > > >Could you elaborate more about why this is really needed? OOM should be
> > > >a very slow path. Why do you care about this potential improvement in
> > > >that situation? In other words what is the usecase?
> > > 
> > > Well, We are using the cgroup v1 freezer. When a frozen process is
> > > killed, it cannot exit immediately and is blocked in __refrigerator until
> > > it is thawed. When the process cannot be thawed in time, it will result in 
> > > increased system memory pressure.
> > 
> > This is an important information to be part of the changelog! It is also
> > important to note why don't you care about processes that have robust
> > mutexes. Is this purely a probabilistic improvement because those are
> > less common?
> > 
> > TBH I find this to be really hackish and justification based on cgroup
> > v1 (which is considered legacy) doesn't make it particularly appealing.
> 
> Btw. have you considered to simply not impose any delay for _all_ frozen
> tasks?
 
Thank you, it seems like a good idea. I will try it.

