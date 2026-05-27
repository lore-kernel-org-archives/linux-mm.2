Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0A2ECD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 03:26:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D1196B008C; Tue, 26 May 2026 23:26:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B716B0092; Tue, 26 May 2026 23:26:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0917C6B0093; Tue, 26 May 2026 23:26:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC2846B008C
	for <linux-mm@kvack.org>; Tue, 26 May 2026 23:26:07 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8A36216081E
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:26:07 +0000 (UTC)
X-FDA: 84811761174.07.5C6D8F6
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by imf12.hostedemail.com (Postfix) with ESMTP id B3A2240006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 03:26:05 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hf0SL4wf;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779852366;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/tRm+zsnDmuyGHwdztYsUXcSwovq8J4jp1TlNqlOchs=;
	b=3SiF94rGC12Oa/IcJnJmhnGNSMxK0FIz/qt0q1Z3RaBp1jyj2ipotEbBZvVjFe1dNsTq4c
	sJ6ON+lnsAg64I+U3ajzth9VGGhLjvJm1rO0eBOTOdybRJLi1CXDB3HzcuxYCxMV6Ytmj7
	CMJHpWfATr1QtRisph2XSByb9FQxnVI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779852366; a=rsa-sha256;
	cv=none;
	b=RtLLr8iRleJVnBKQE8u+36zWV8osY9Y+TArkJa2AgR3mVTjq6bdSTZi2qV4uaPfL6BIFBt
	Ba2WRNtrkS8VEo8d9zvpA0QScVTRqVOxE376BhAdll6mZ/BGlGjwnVkIQKi/2NAlOdGb5E
	bck1T7Nw/4Gv0/481YN/Cb+1SJ/ErlE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hf0SL4wf;
	spf=pass (imf12.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.170 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Tue, 26 May 2026 20:25:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779852360;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/tRm+zsnDmuyGHwdztYsUXcSwovq8J4jp1TlNqlOchs=;
	b=hf0SL4wfqtfohYS34VQmpkzQC1T2f4e2S33zRiUVq/e0eBKYZOoNJwGW4UupbR0y79IqRT
	j9OVQFwe7fC1fT3Yu+jv78Z64gfWLRF9Ix3dRMeInBmJuGf0tYNGmjZYmJbPelfMuCbXp/
	eA85Or/x6/Hob/gClTgxrE6eO4BcEFs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	David Stevens <stevensd@google.com>, Chen Ridong <chenridong@huaweicloud.com>, 
	Leno Hou <lenohou@gmail.com>, Yafang Shao <laoar.shao@gmail.com>, Yu Zhao <yuzhao@google.com>, 
	Zicheng Wang <wangzicheng@honor.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Kalesh Singh <kaleshsingh@google.com>, Suren Baghdasaryan <surenb@google.com>, 
	Chris Li <chrisl@kernel.org>, Vernon Yang <vernon2gm@gmail.com>, linux-kernel@vger.kernel.org, 
	Qi Zheng <qi.zheng@linux.dev>
Subject: Re: [PATCH v7 00/15] mm/mglru: improve reclaim loop and dirty folio
 handling
Message-ID: <ahZjvYs83591EYXW@linux.dev>
References: <20260428-mglru-reclaim-v7-0-02fabb92dc43@tencent.com>
 <agH7qYcyFgRzkQDB@linux.dev>
 <CAMgjq7BzQAPp8u_3-9e3ueXmRCoW=2sydok0hFM=MYL7VC1YYg@mail.gmail.com>
 <agK-rkIIZlwBiMsv@linux.dev>
 <20260526183506.ffb1bbe41043c6247557caa1@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526183506.ffb1bbe41043c6247557caa1@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: B3A2240006
X-Stat-Signature: kcr9dk1arydzq5xrs1ph9nksfzw97jfg
X-Rspamd-Server: rspam06
X-HE-Tag: 1779852365-198893
X-HE-Meta: U2FsdGVkX1+HnTjGFfuvXK5XKcRFM9shGDWRGb4zKXHVCgGMmkevxCYDj9GuW1wRgN28MIjkdenxAIKaKFXoC2K1dQ6zzAocG5SWhB934iNwbwZGSrezg6HA98YJ1eNs+1NhCqvJIWpNsUoXUPIeOGYUzeX3or77qiGx4zNMEX19q7C+z4KVGpF06lRUoRryGhzpcDqfRGygi22Iwft9ulOTBdzfQOgPBeDRII4WwB3FDLD6qIRamvvsgil4icKxSWA4XNjUcjrMd9l+83T0xuiPDlZp8VyuocAwsBsW84W26NadxtPOGeBa86GyrYayuSuC5op9kGAoU9v/lBygQhBrKD8JuqsGn37pFTnTrB6Hjz+aAX4uLFyJJc7YFwjH4O0mFdgKIyRyiF68wA7iMWzQi4OafB7XdJ8C7uFSAjLWwF0RLwwZ57Q7tcL86qPipuIRB6D3YkAGrCk5BAcZARCPpfroeh945CeTaSRU3B+h1L7Fm7HZa+kmh8xyTrkOVnNId+bpnljYRmBdDtUpgEHymh1TU4WoqxV5tEPk4KQzJXmOSFzjrbawwBXPVdrGZPgCo5SzavSHMbjiyuuewC/XtKSMjbQHjTLjSOU6gfzJ4CvIU7pR+EvJNmjye6YydW3yhFjvsOfnGMgSxBZc1tbJVbjHaNxbb8dfdzDM9aGN9bTj68JYmZ1z+Y9zc6zWjUZagFxlA6ahfITAG3PvyvXyv+4aPc+RGgerICiFHYwUOkc5OCFR7WlauXHGiLIWJVC+8mtkwSIdlHjIUOl9lvZnZ9SmPdSdRBbZoW05D980SWyJq1QqraYGy2IqjFDDkKWTGupjDnBjcMSVnpWCVWotiFxZMvvwrM1O01HNc8buR+7VJGwn0qa3l81kG67K+Hb0xR/XAecGifUOhSbSDDFGRbp9qT2lr0Fe1zKsczz01V/AK7g3dy7I3BjXaztv+eoLxo+ZqKYqBJRqvOS
 gPT3d5gW
 LRlTDiFRUrsGZykHntzsp82eo9a88efx5gOPUoGe+jqPbfVus481kuaoZ9HdBo/f0Vs4exSAUWIGqU/DayT3bD2NEeDUyl/WFcY4rYvliI9HJztw1sLcmjRJNgxzZUtFyh+yD+KiSyPrN2yq+YJ3LUNgaG3JKYavRuN4wfejMTvehb8gGt3z3lgLDgbd2TF1wHmlGwGUBbcat5AkWO5gJm2En8lby2W6Eev2PD2Hf0piDffLWneCPBo/2vNjgSSJcXRlhJfxV+gmNfOPJLJ8jkEn6mA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 06:35:06PM -0700, Andrew Morton wrote:
> On Mon, 11 May 2026 22:56:21 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
> 
> > > > Please include traditional LRU results for all of the following experiments as
> > > > well (where it makes sense).
> > > 
> > > Sure, I've spawn a few test instances, was busy travelling last week.
> > > That specific test machine is occupied so it might take a while.
> > > 
> > > A systematic test run takes roughly one or two days to complete for
> > > one kernel version or config, e.g. the JS test takes at least 2 hours
> > > to finish. Comparing versions/setups takes more time.
> > > 
> > 
> > No worries, we have couple of weeks before the next merge window, so no urgency.
> 
> Well, no, not really.  Some schmuck wants to get our
> stable-non-rebasing branch into upstreamable shape well before the next
> merge window.
> 
> This series was issued a month ago!
> 
> Sorry to crack the whip, but let's please all be aware or our
> upstreaming timing.

Thanks for the reminder.

> 
> > I will go through the series in depth, hopefully there will not be a need for
> > next version and in that case, please just resend the cover letter with the
> > information you provided below and don't worry about the length of the cover
> > letter.
> 
> That's a plan.
> 
> Happily, MGRLU changes are well-isolated so I was able to trivially
> move this series to the tail of mm-unstable.
> 
> It isn't a problem at all for me to defer this until the next cycle -
> please let me know.

I am on it and will aim to be done by weekend.

> 
> I'd like to know this as early as possible so I can hide the series
> until after -rc1.  We shouldn't have "not for next merge window"
> material in there possibly invalidating our ongoing testing.

Ack.

