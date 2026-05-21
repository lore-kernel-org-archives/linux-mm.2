Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B298CD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 15:07:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D91FB6B00BA; Thu, 21 May 2026 11:07:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D43AA6B00C1; Thu, 21 May 2026 11:07:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80AA6B00D6; Thu, 21 May 2026 11:07:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9CBE6B00BA
	for <linux-mm@kvack.org>; Thu, 21 May 2026 11:07:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A8271601D4
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:07:38 +0000 (UTC)
X-FDA: 84791756196.08.128B63B
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf05.hostedemail.com (Postfix) with ESMTP id 3BC31100006
	for <linux-mm@kvack.org>; Thu, 21 May 2026 15:07:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OzXHkt8/";
	spf=pass (imf05.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779376056;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6U7sUbXLLnWSWD5bzxxa4WJ3Sz2EB6kaUosLO82z7w=;
	b=wKsf5osW4Oum+lDp2lih2k7QrPgsk7hxoP0znfxIMq94OgJf7h6/gIY4n//sqvpyUp2HhG
	+8QhE+Nl25Nt0Nf9zYYeFm2qeOiiCt/Pb8dkALAgOrlED9xpuwJ3y+nqEisfyS/IKiYoAy
	MVlZt4iSbHg9IZr+eKfDXdTMWCkjeJc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="OzXHkt8/";
	spf=pass (imf05.hostedemail.com: domain of jiayuan.chen@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jiayuan.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779376056; a=rsa-sha256;
	cv=none;
	b=PFhpn7sjHfCQX2xvGBJnTVq3P5cMSFQI6XbdUYP8vFKWHOK/4+LrtaR2kXGQdCu6dUPsDC
	UoIqQHjrjVjOZ45JnAsjU/p6U0EUkD0MWH4fnwc4Pa83QTE6YRJC37A6XiY/NobsbaXHC4
	WdavWGvfbGZoNZopLusRdPsG5jrIojg=
Message-ID: <26baec2e-bc11-4042-8f61-0b3f7fe1c3b1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1779376054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=t6U7sUbXLLnWSWD5bzxxa4WJ3Sz2EB6kaUosLO82z7w=;
	b=OzXHkt8/saWAnsi37FSdploeeEyPoMcveshhbWPKLruHntyC5aLMOX3HJ+Y+faUU8ZUZI4
	WJCRftUkm3QvqyRc9/555m/0HgP0Nt3EdYUEXDSqAq1qxu7gEAsrFSgZT0WDa0AmEmZ1Hc
	of1KG9Ch+mGDwYuIH01nniroLDpJorY=
Date: Thu, 21 May 2026 23:07:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 0/2] mm/damon/core: detect internal variation above
 max_nr_regions/2
To: SeongJae Park <sj@kernel.org>
Cc: damon@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
 Shu Anzai <shu17az@gmail.com>, Jiayuan Chen <jiayuan.chen@shopee.com>,
 Quanmin Yan <yanquanmin1@huawei.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260521143049.82745-1-sj@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Jiayuan Chen <jiayuan.chen@linux.dev>
In-Reply-To: <20260521143049.82745-1-sj@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3BC31100006
X-Rspam-User: 
X-Stat-Signature: 9kahwmnxgx3znynshqazpapgkzwdy8b3
X-HE-Tag: 1779376056-859198
X-HE-Meta: U2FsdGVkX18dRR4HhC0aNArKl6AeWPy6YfrAsdg9k/fehA473tmtnTXML5hmmPsFSz/e6E9UHdaC2CUzhdHU/24p03awnX3ScATHU6En0VBuVi6Ikt/yvA/+izD8GTOpM3lCkkq9nlTvkA+9vWOfG3u1SrsMw6vaeky6KnolqpWM2yT0+MVZ6OxrXh4omzREMtjfCSeTV6zxrXcWKGDx7/I9ohxSEMTaQBItKiVLMOu8qAyHBadJ9g3TG7Q26yV0YtiFmE7c4nfPCyZjoETKC2fzlcOvjY7nMu/NJo5xONz8fo4cjWFBlRejScF3+jxlbT1xoVoXQrYyVesgcpQU4fCrR1xPj5eCKuv+DjanhA2L3pXdEN3w1jtUTYlA+BeMGCCv5gSCGOQ5ugJpvpnGfqzZ1kLJLORaxynS+4EWl5ur5fLmXwqgFbJ7b/l0GX/8Ym0NDjy9O3qA+1PPghpZScYe0kXIJ3me70YgTYS9NxY/wMFAnvofo4oVbKrGURw2LPSRHV/q40o6ZDw6aX3xQT5wA1Ds4TFFLgeVx5LZ2iRSUJRTZWBogHXbefr1yMV0tlKopQlEt55w70t8P8WGwogd9RvGE9dJWmP1nVrI819PWfKKDlmSl9ppbp6pTUYjIcXCJVasqRQuInCGfe4WNNTc3e1VGnkvOX4y8JTZFawubHU4Lcf5tUsYLU/s0usx7ZFgjep2UAW2hwGNkzXyJWmwv2u81vUQ5MWEWu4IdT8AFNUKAWEyqQvAz3bSjXSmDiQTzr4sCTmTZx7S2Xxbp7hxNGVhLCH/QeGgkp5451rLP4c3a+N/OEBA6yfAeF0NMRhTu1dwJJYWN4ZOkzB+AlbZlrVEy7/UXk/t4ePQv+HZSRpRuIcYq8M47ww8TtjwDE5Ot5YBfQH0HuidsY+mWDuos07WYyDIA/G3WjCO5iYkKxzIhW/o6CRbLOoJXEkRXkYcDSi61trsz+Hm/km
 Ttv0idaN
 f9m9qzXJt7AiqYyGU9Y4ltMkFENUUdQEbuAO6OmpYbtMKl/ajTC20iuSov2dQ9f3nj2nDrn8A9UjjfENqPhz0iPDflG241XZlvjY3q/jMvLTzpsiEPqEWpylIxD+FEnaSeGeHrCPDheH1g0uT0OoS+aJwglXMlssQg5pdKF5tL2VblRCtyJE6KU34Y2VFev769QHT7Cz8MLHgFl/A9xzgBCtGZP8GWgxD4+lLrHC7KKeIIXVuPA+XDokI0pCWAKIkVgQeyh3Q0/OsPJeeHnfPo9ZjRw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SJ,

Thanks for taking a look.  Quick replies inline.


On 5/21/26 10:30 PM, SeongJae Park wrote:
> Hello Jiayuan,
>
> On Thu, 21 May 2026 12:52:22 +0800 Jiayuan Chen <jiayuan.chen@linux.dev> wrote:
>
>> kdamond_split_regions() bails out early when nr_regions is already
>> above max_nr_regions / 2.  A large region that picks up new internal
>> variation after that point never gets split, so we lose visibility
>> into its hot/cold structure.
>>
>> We hit this with damon-paddr on hugepage workloads and damon-vaddr
>> on processes that mmap a large anonymous range.
>>
>> On our production tree we added a current_nr_regions counter (no
>> good upstream home for it yet, so it's not in this series).  We saw
>> nr_regions never getting close to max_nr_regions, and the picture of
>> the access pattern was too coarse.
> Is 'current_nr_regions' somewhat showing the number of DAMON regions?  If so,
> you could also get the information from nr_regions field of damon_aggregated
> tracepoint.  I'm wondering if you considered using that but found a problem
> that made you have to implement the internal change.
>
> I will be happy to help removing such downstream changes.


Yes, same data as the nr_regions field in damon_aggregated.  The downstream

counter was just for convenience -- easier to cat a sysfs file than to wire

up tracing.  Even the tracepoint covers it, It's cost to much for 
Grafana to just get

a metrics by tracepoint.


>> Example with max_nr_regions == 1500.  A target ends up with 799
>> small hot/cold regions plus one big region (an earlier merge
>> collapsed a uniformly-accessed range into a single piece):
>>
>> H:hot
>> C:cold
>>
>>        r1     r2     r3                 r800
>>      HHHHHH|CCCCCC|HHHHHH|...|HHHHHH..........................|
>>
>>      nr_regions = 800  >  max_nr_regions / 2 = 750
>>
>> Now a cold subarea shows up inside r800:
>>
>>        r1     r2     r3                 r800
>>      HHHHHH|CCCCCC|HHHHHH|...|HHHHHH........CCCCCC.............|
>>
>> The small regions can't merge with each other (their access counts
>> differ), so budget never frees up.  r800 can't be split because
>> nr_regions > max_nr_regions / 2 returns early.  The cold subarea
>> stays invisible.
> I agree this corner case could theoretically happen.  But, would the small
> regions have the current pattern forever?  On real world systems having dynamic


I agree with the point that this is a corner case. But it's not 
transient for us.

On a production setup with max_nr_regions = 20000, nr_regions sits at 
11k-12k

for extended periods. There are occasional bursts (e.g. from offline 
pods), then things settle

back without ever reclaiming the budget.


> access pattern, I guess those small regions may not keep the shape forever, and
> give chance for the large region to be split.  Am I missing something?
>
> My theory also implies that this kind of situation could happen at least
> sometimes for temporal periods.  In other words, it could happens too
> frequently and too long to be problematic.  But, in the case, maybe the user
> could mitigate the issue by increasing the max_nr_regions.  I'm curious if you
> considered that direction and found a problem that I don't expect for now.
>
>> Patch 1 lets this path still split regions that just changed
>> (age == 0),
> Why 'age == 0' means it is a good candidate to split?  Because it means its
> access frequency is anyway unstable?  Or are there other reasons?  More
> clarification would be helpful.


Yes, age == 0 means the region's access count drifted past the merge 
threshold in
the last aggregation -- the strongest signal it just changed internally.
Regions with age > 0 are stable; splitting them tends to oscillate (the next
merge cycle pulls the halves back together and we waste the budget).

>
>> up to whatever budget is left under max_nr_regions.
>> If a split turns out useless, the next merge cycle undoes it.
> I'm again curious why the user cannot just increase max_nr_regions.

It works as a workaround, but it isn't free: higher max means more sampling
work and more memory, and 20000 is the ceiling we actually want to live
with.  Bumping to 30000 just so the splitter has room to make progress
between max/2 and max is wasteful -- we don't actually want to spend the
resources for 30000 regions.

The real issue isn't budget waste, it's that once nr_regions crosses max/2
the splitter has no recovery path -- it returns immediately even when 
there's
variation worth refining, and merges don't help because the small regions
have different access counts.  nr_regions just sits between max/2 and max,
and new variation inside a large region goes undetected.  The patch gives
that path a way to keep refining within whatever budget remains, instead of
asking users to over-provision max.


>> Patch 2 adds a KUnit test for the case where nr_regions is already
>> above max_nr_regions / 2.
> Adding tests for new features is always nice, thank you!
>
> I will review each patch in detail after the above high level questions are
> answered.
>
>
> Thanks,
> SJ
>
> [...]

