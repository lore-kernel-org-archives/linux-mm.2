Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0369CD98D0
	for <linux-mm@archiver.kernel.org>; Thu, 13 Nov 2025 19:29:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B64E8E000F; Thu, 13 Nov 2025 14:29:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28E808E0007; Thu, 13 Nov 2025 14:29:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CC7F8E000F; Thu, 13 Nov 2025 14:29:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 078928E0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 14:29:09 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B8648160115
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:29:08 +0000 (UTC)
X-FDA: 84106571976.26.15975A9
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id AE34C1C0007
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 19:29:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FrF77Os2;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763062147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gn4tP6akjDt+BnDBMVmYBOqJ09Gs42yv7nYdO7lYCwA=;
	b=YeZI5eJAuoeCYBwiiAyL9fSw5qhTDdKRtPmAA9EMzIZdrEQi/9F5pQcFmzCSCkyjg/W16o
	i6bN/3ftbjRZH28CoM/WjMHIRk5yHBOV4xui99kkIjdejKiO5ggbO9zWudnyObhyhiXjgQ
	7KyOnXSCcObElHrxAZ8FywJx7Kyubdg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763062147; a=rsa-sha256;
	cv=none;
	b=Rfo0l00b2LH65yqEhL0+dhaN7n6fcG+zWU/F8cBSFCqLZGCoyVbJZ1gjC/7/N/jbFPqwfS
	XHe6UN2GsS7oAkES+6IqP4U6ZHLNWCJS/Phrz84usJGmhpjB6EGi9B5yA73d8qHXGkpN7i
	NgEvFfmt2x3cjQ6hJaKL7Xf8DbY3QWk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FrF77Os2;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 13 Nov 2025 11:28:58 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763062144;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Gn4tP6akjDt+BnDBMVmYBOqJ09Gs42yv7nYdO7lYCwA=;
	b=FrF77Os2V2wrof+YbmAjPp/j45H3feInvjlgCe+LUZ4v3Or6L4PJR+RTSZhGf4EquGLn0A
	RKTs7msdRWJfF/39amd4VHtkWZTYS2bRl5OpvQIRBKnNL7TEYi6I86MZ7kkqpR37quy1XI
	6tH815UjQvjSwK84o1LoxgWrtWSQvF4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/vmscan: skip increasing kswapd_failures when
 reclaim was boosted
Message-ID: <jbqwxqsqvjqo664s275hcub5wgnjencvqgisiniflylp2fpxz5@imttckfazi7u>
References: <20251024022711.382238-1-jiayuan.chen@linux.dev>
 <e5bdgvhyr6ainrwyfybt6szu23ucnsvlgn4pv2xdzikr4p3ka4@hyyhkudfcorw>
 <aRWswVgIaAqJEvQB@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aRWswVgIaAqJEvQB@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: AE34C1C0007
X-Stat-Signature: sgjb854n9ck7g7poinibcf6s3bupgn5s
X-HE-Tag: 1763062146-998579
X-HE-Meta: U2FsdGVkX1+ngq2vPlt0/8vWj+0s2/b+GwpjfYOTqYTWSMGq9D6RrrMyRCfvD5RaMuEw+1Gb8DFpDjj8WThP92zvDG2ZezppFeR/0Dv+G9iciJdUQPh3ly2ZLCZOLrWxWHmJAGzT3AkuHgw/CnYfgsVRsU8GarMmWydF2ruevQBdsFWheOCiUW+44zYT+cK2BaQYktVZJoNCt0iygteU8LvklOXJAO/8to5cMOOlugmR6+d8pzXZC0m5dLDf17WHR6EUoUuJyHboR9Qvhz0SGroHN+xxAdpvnkOdAOH3SMAdfQpmpuL3E6dWOZ7WhfHIe26ha9Lhl05J0mPM7UW6AmMrQsAVuu0F/ihZtnwRT+ZN6cE18QdOZc5K8cJmoT4bV87sz5UNcbxgmYRQlJK3jQgrHMiO2wfnO9qLCDkWwzI7PLPtfkdwpb4CP7oWnVoFtW6uPc+9HK8Ne+W83JSQVYfjwdI0kpfe/ONmgKYrBb14x6oomAni8hIPwaJH5tzGgQOiBvvoKxwZN14yUwpqP9FjW9Qkp8ncWItNa0ALy+ZKYcGa9zVpReNqLfg+MWP8fHcX2/kGjnuaP2fGFsatKFg4o00asSMQDoNBkYa7j3PoNI1MXAtAzOA5rdamBB7q7qkUQLrJgguEb+G5K1B9j+J9sujeyEurE8b8om7oBo7lSiYn164z64+LSQfPY9BuNG7aRsovGGnTI/BURa9+d/KmvUiD/UM7i2h2fXeKA39dGDuPjMT73ak3lF4Jm9Qnvs1mSuGZz32QvhJ6cWvYoeie9NwRstzTkl7nXlk9/zRbAG6DhPB5LdAneMnYfTqkvDze4epQUgaZBDdcFusd32fjCkD2rpC/iMKGgITA6SUTeljwzaTwhUGf7Tq9gq7QisRy5FFabkegxdUFbpwGHM20wIebsRLNtDGoCVuX62q41MWjKexZSBMq/LRQ8bABleR/FkvhB4uvJpMgcPj
 fxqPmjkT
 lBOUxkN6/JQLWy+BAT+/6xikZst85kcjLsJk0kA20CyGFZIiVZPgzJrwJsL8aOgd8DdZs7GaySRelMGaPMt2UD8pVoZFk0+xynRX7pqAc/qeK8Jl9v+N7j+USK6jFwIIb6UiF29iIeK/Itm5w/uHPnSO/wCcyaD4DiW+meK1bloIQ5gG9jAKudznOTg2/mlmU71eoYwTVOzt+kI7VH9VbbCF0jbKPkHlbZGV3WVeJJ926SN4I9wR17iKlLDBYad15BWzJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Nov 13, 2025 at 11:02:41AM +0100, Michal Hocko wrote:
> > 
> > In general I think not incrementing the failure for boosted kswapd
> > iteration is right. If this issue (high protection causing kswap
> > failures) happen on non-boosted case, I am not sure what should be right
> > behavior i.e. allocators doing direct reclaim potentially below low
> > protection or allowing kswapd to reclaim below low. For min, it is very
> > clear that direct reclaimer has to reclaim as they may have to trigger
> > oom-kill. For low protection, I am not sure.
> 
> Our current documention gives us some room for interpretation. I am
> wondering whether we need to change the existing implemnetation though.
> If kswapd is not able to make progress then we surely have direct
> reclaim happening. So I would only change this if we had examples of
> properly/sensibly configured systems where kswapd low limit breach could
> help to reuduce stalls (improve performance) while the end result from
> the amount of reclaimed memory would be same/very similar.

Yes, I think any change here will need much more brainstorming and
experimentation. There are definitely corner cases which the right
solution might not be in kernel. One such case I was thinking about is
unbalanced (memory) numa node where I don't think kswapd of that node
should do anything because of the disconnect between numa memory usage
and memcg limits. On such cases either numa balancing or
promotion/demotion systems under discussion would be more appropriate.
Anyways this is orthogonal.

> 
> This specific report is an example where boosting was not low limit
> aware and I agree that not accounting kswapd_failures for boosted runs
> is reasonable thing to do. I am not yet sure this is a complete fix but
> it is certainly a good direction.

Yes, I think we should move forward with this and keep an eye if this
situation occurs in non-boosted environment.

