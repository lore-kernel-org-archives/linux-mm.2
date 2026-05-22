Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D608CD5BAF
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 02:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A28126B0099; Thu, 21 May 2026 22:42:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D8DF6B009B; Thu, 21 May 2026 22:42:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9162C6B009D; Thu, 21 May 2026 22:42:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF8F6B0099
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:42:41 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D4C63A08C0
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:42:40 +0000 (UTC)
X-FDA: 84793507680.08.5CBA6DA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 26E4E100006
	for <linux-mm@kvack.org>; Fri, 22 May 2026 02:42:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L9O80Nsj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779417758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UfaKm7/ffChZJckI3+fZbp1IlqqOKUAIq6IoYDmzaVs=;
	b=L1XWm/6fWnVeaqE8/ASlvkDLPsucvZMCbdHQj3qdl28hTfD7CW2vwgYTE6rYErNyOUHVzI
	cXjC0Idf2w855k7hjswIkA7UArTQz+dg4Ic9ZrJ4SbNjMTeP1HGKkDH6yuNp5XycJEtgzw
	gLnMJZEqFjHDQxfrmsgJdASltu/1YAI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L9O80Nsj;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779417758; a=rsa-sha256;
	cv=none;
	b=E72eZuPcvXraT8OlmdbT8KXGN1DzabMFW+uNJhuXeLoqZDMHrPO5nfc2P8PyoWTMSNrsLB
	uRKEwVPC+7O0zMnqCHNQnix8JE8ULQuStBgFIPQ1TPxZXoe7MtC/aQsd0aGF+nfRIwPpGg
	Za37+HY7Jf+yo1rZBXdjniWkVwos5hw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1DB3E436A7;
	Fri, 22 May 2026 02:42:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3A911F000E9;
	Fri, 22 May 2026 02:42:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779417757;
	bh=UfaKm7/ffChZJckI3+fZbp1IlqqOKUAIq6IoYDmzaVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9O80NsjEeGKhmccQwt1t/+jRv+G3YUBl9ucxh8w4IYjc6ZLDLk8NAHsqnpYeKCHq
	 Wc7m7hLBHuRnzeVYhK9cALdTwu/kbCN0+KoWvtkq9ywuGneOK2S2ra/jVCLGLMMVfs
	 d6Fz1884Waxnlnppcn46gthfOeKPCRDk+adi4jAcahF20U3eotYgX6e7S23m2+VkWN
	 Ug1fJJQmoWIk07kiaC+nXEGFtsVgKOp8fO/OXNt6ki9XJkaGvoZngaQHaLaHged1bg
	 id4M6ZeqAkoodqwQXPPxRZb+9JNKuvSmi+QFLKkQ7aivP5MCG9cMrOboC/Z2OlzJhM
	 gBVxZXufJQ2OA==
From: SeongJae Park <sj@kernel.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Shu Anzai <shu17az@gmail.com>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/damon/core: detect internal variation above max_nr_regions/2
Date: Thu, 21 May 2026 19:42:26 -0700
Message-ID: <20260522024228.87328-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <26baec2e-bc11-4042-8f61-0b3f7fe1c3b1@linux.dev>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 26E4E100006
X-Stat-Signature: z4181mxnoyfudud3o8sgo7yqznqxgudm
X-Rspam-User: 
X-HE-Tag: 1779417757-426600
X-HE-Meta: U2FsdGVkX1+OwM/KuR6WLS5to9P46gxLdxnK7QCOK0KojmmrzJQiFl9h7xtxwC0UxUPVFj9V2aJ2K5n3Ij9iroH3xv+0lt7ySGG6RWo3iN8RJKnlnzY6JHEbWg1H+0bHVfCDhcdCM4olAEVkSwY7XDqXKoZxfFt2Ty8GQN0dFATYfj3HeEBvJ1lJv7WdEJgXBBeE22biISipvc5WwixCmzauYzWmhYsyGLU8gceXwnqwaSb/vKHqMoBOjVy2cfjzvKd7aDklyFsM67oTaT5QhKGoy0b86vkvVOek9C8pAXdxOgK/olKRKJdd/eIMzDLrQek4oCrnOxdTXeqwQA9YAmBDsCrNa3Rv2gdd3c379x9leC+BoeVayQG67gFRC7T5OaWeoOsE4ZOvdhiLcABWRynuJQKajcWBn66v+y+xRg45tqKsZUU3yacA06bWpp0Vdu31PLPPhEIHTwltqMqc50BD8HR7/dltP+EbwxQLuMIQpSZpQjyOcnEa23+3cRpnP0sKd3+DyyeBxtM+MXRwqIF4kDGl7PaoamgZS2TcT9Wp2Mmw/4QMTHhm0EGxOy6DEqhtb2fIU4af/OsG9k+dQIq+WeGcbc4/FQe2qWcsDBkHyc3WWQ9IEnPDSYKFVFuJoqX+cgkrroBmlfYECM8Xu4akntsZkuVAytz2N99TI7ukxuI36y0KwPOPwpTDQG0yZTOSacHIst9Uo0TaPGRgDyOLOHPJkJWD8I2EabTcRVW23kksyZBGRWLgQZcYd8u4QuJV0MblfEHnMcGCSHdLZu9W0hY4fctctDBh/ugpOZq0AdSSP+FdB0BQmGPai4neLebSztgFIPGS5quMfHgP/LjhZPQGw1dXA9qgjMkOkP0g1ysZKe0YHif7ovVo5LsoltV9LRTJRroXWk9AUaYqjCdkSFrE1m/4FdvZdNA4wWXbJmrCw+X4TiKUdSMz9SCzh9pzAVpxGe7mQi5QUeV
 +3B2RyKu
 ZnScBYr2Co7FQlDJJBQSSlnSVW7QXfn15VbigSYtgEF5N8kkabC0RZi+7Z4CSimXI+3XK2yeRL43xWhsocl0yxjejaBucKWzKFI+7bN9g3w3REDAhldYPViFJlQ5kFzBRbCopZyQzN/9UJrN7+0nX7JD7LmP6VHoDtjJRkc3QkkIRkA2Usl8qDQauau+yT/N3cnihX2kavvQfQ0O1J5ynfRQLcmONfKPDnTmtkkDASpoobuDZlmisLpD57YgUvqbPkwBuammODjiY6EJUeJ8kJyDv+m/5aP700nIt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 23:07:11 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> Hi SJ,
> 
> Thanks for taking a look.  Quick replies inline.
> 
> 
> On 5/21/26 10:30 PM, SeongJae Park wrote:
> > Hello Jiayuan,
> >
> > On Thu, 21 May 2026 12:52:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
> >
> >> kdamond_split_regions() bails out early when nr_regions is already
> >> above max_nr_regions / 2.  A large region that picks up new internal
> >> variation after that point never gets split, so we lose visibility
> >> into its hot/cold structure.
> >>
> >> We hit this with damon-paddr on hugepage workloads and damon-vaddr
> >> on processes that mmap a large anonymous range.
> >>
> >> On our production tree we added a current_nr_regions counter (no
> >> good upstream home for it yet, so it's not in this series).  We saw
> >> nr_regions never getting close to max_nr_regions, and the picture of
> >> the access pattern was too coarse.
> > Is 'current_nr_regions' somewhat showing the number of DAMON regions?  If so,
> > you could also get the information from nr_regions field of damon_aggregated
> > tracepoint.  I'm wondering if you considered using that but found a problem
> > that made you have to implement the internal change.
> >
> > I will be happy to help removing such downstream changes.
> 
> 
> Yes, same data as the nr_regions field in damon_aggregated.  The downstream
> 
> counter was just for convenience -- easier to cat a sysfs file than to wire
> 
> up tracing.  Even the tracepoint covers it, It's cost to much for 
> Grafana to just get
> 
> a metrics by tracepoint.

Makes sense.  And I think this deserves to be upstreamed.  Some minor
modifications might be needed to your current implementation, though.  Please
feel free to send a patch to start the discussion, if you want.

> 
> 
> >> Example with max_nr_regions == 1500.  A target ends up with 799
> >> small hot/cold regions plus one big region (an earlier merge
> >> collapsed a uniformly-accessed range into a single piece):
> >>
> >> H:hot
> >> C:cold
> >>
> >>        r1     r2     r3                 r800
> >>      HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|
> >>
> >>      nr_regions = 800  >  max_nr_regions / 2 = 750
> >>
> >> Now a cold subarea shows up inside r800:
> >>
> >>        r1     r2     r3                 r800
> >>      HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|
> >>
> >> The small regions can't merge with each other (their access counts
> >> differ), so budget never frees up.  r800 can't be split because
> >> nr_regions > max_nr_regions / 2 returns early.  The cold subarea
> >> stays invisible.
> > I agree this corner case could theoretically happen.  But, would the small
> > regions have the current pattern forever?  On real world systems having dynamic
> 
> 
> I agree with the point that this is a corner case. But it's not 
> transient for us.

Thank you for sharing this nice information.

> 
> On a production setup with max_nr_regions = 20000, nr_regions sits at 
> 11k-12k
> 
> for extended periods. There are occasional bursts (e.g. from offline 
> pods), then things settle
> 
> back without ever reclaiming the budget.

Could you please clarify a little bit more?  What is the occasional bursts, and
how offline pods contribute to that?  What "reclaiming the budget" means?

Also, do you have some measurements that shows this problem and how much of it
is removed by this series?

> 
> 
> > access pattern, I guess those small regions may not keep the shape forever, and
> > give chance for the large region to be split.  Am I missing something?
> >
> > My theory also implies that this kind of situation could happen at least
> > sometimes for temporal periods.  In other words, it could happens too
> > frequently and too long to be problematic.  But, in the case, maybe the user
> > could mitigate the issue by increasing the max_nr_regions.  I'm curious if you
> > considered that direction and found a problem that I don't expect for now.
> >
> >> Patch 1 lets this path still split regions that just changed
> >> (age == 0),
> > Why 'age == 0' means it is a good candidate to split?  Because it means its
> > access frequency is anyway unstable?  Or are there other reasons?  More
> > clarification would be helpful.
> 
> 
> Yes, age == 0 means the region's access count drifted past the merge 
> threshold in
> the last aggregation -- the strongest signal it just changed internally.
> Regions with age > 0 are stable; splitting them tends to oscillate (the next
> merge cycle pulls the halves back together and we waste the budget).

Thank you for confirming this.  Yes, that sounds good approach to me.  But
because this is a core behavior, I'd like to be careful more than usual.  I
will spend more time at thinking if I'm missing something, and if this is the
best approach.  If you have measurements that I asked above and can share, that
will also be helpful.

> 
> >
> >> up to whatever budget is left under max_nr_regions.
> >> If a split turns out useless, the next merge cycle undoes it.
> > I'm again curious why the user cannot just increase max_nr_regions.
> 
> It works as a workaround, but it isn't free: higher max means more sampling
> work and more memory,

It would depend on the real number of distinct access patterns.  I understand
the number is really high on your use case.  Again, if you have measurements
and could share, that will be very helpful.

> and 20000 is the ceiling we actually want to live
> with.  Bumping to 30000 just so the splitter has room to make progress
> between max/2 and max is wasteful -- we don't actually want to spend the
> resources for 30000 regions.

Makes sense.

> 
> The real issue isn't budget waste, it's that once nr_regions crosses max/2
> the splitter has no recovery path -- it returns immediately even when 
> there's
> variation worth refining, and merges don't help because the small regions
> have different access counts.  nr_regions just sits between max/2 and max,
> and new variation inside a large region goes undetected.  The patch gives
> that path a way to keep refining within whatever budget remains, instead of
> asking users to over-provision max.

Yes, I agree.  Nonetheless, as I mentioned above a couple of times, if you have
and could share measurements that showing how big the problem is and how much
of it this change can solve will be very helpful.


Thanks,
SJ

[...]

