Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC83DD2F35E
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 18:51:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C6AC6B0089; Tue, 13 Jan 2026 13:51:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2711A6B008A; Tue, 13 Jan 2026 13:51:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16D636B008C; Tue, 13 Jan 2026 13:51:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 060A56B0089
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 13:51:38 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9812816021D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:51:37 +0000 (UTC)
X-FDA: 84327834234.20.263512A
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf26.hostedemail.com (Postfix) with ESMTP id C5F3B140007
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:51:35 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kIsn8PND;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768330296;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YSyCYm4RI/yOISWqF0EpwwOCB780fUcqokCOrTMCaj4=;
	b=azOhKbTNe7KQ8r7LxveRo0WD01imrGZYXmnhIg/fb9ArAAsEqHlBmIfcrlLZ7dZQiikG/T
	HSTCbuyeTE08/x1sBELMqCyjIuyi9ckxCcb34SWj7k3W0kPwAUQslz+DWo8Or+uW5YV9Sa
	+AqCxLXIyYV8kFGgs3YiSEQ7FXIkgIw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kIsn8PND;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768330296; a=rsa-sha256;
	cv=none;
	b=Aq5CL3eVd/bmCF+je0WxSB+o8YsXlV0leX4tX09YmbtmiiINbToUU06Ypizr0LL1xQKOXO
	YLqZd8Of7GUyIW4jqyCC66GPV9t/LWEFLrQghxdAKV4MVUKyrx7iAGf6AX8/qOIv955Xf9
	pjCUsByiwDNDWJfcp7o+2J9NlbLmGQU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768330292;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YSyCYm4RI/yOISWqF0EpwwOCB780fUcqokCOrTMCaj4=;
	b=kIsn8PNDwk/uIEAwdGjqTZ9RFbMGqbD5t/OD3hzJ4Ifr+7yWtFRpLFXOnXJxBeHaEhUxPz
	xx8kF/7Tr9UrUn10mTQ0ciIeDwd8AbjaoTuT5X3ua0HqZyqstTQCjV2ZatcM+UVHf2QSzi
	0ZkPHCG2ZYnwPrCuvx3ABUZU6Dp/4Ac=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Chris Mason <clm@meta.com>
Cc: Vlastimil Babka <vbabka@suse.cz>,  Andrew Morton
 <akpm@linux-foundation.org>,  Christoph Lameter <cl@gentwo.org>,  David
 Rientjes <rientjes@google.com>,  Harry Yoo <harry.yoo@oracle.com>,
  Uladzislau Rezki <urezki@gmail.com>,  "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,  Suren Baghdasaryan <surenb@google.com>,
  Sebastian Andrzej Siewior <bigeasy@linutronix.de>,  Alexei Starovoitov
 <ast@kernel.org>,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  linux-rt-devel@lists.linux.dev,  bpf@vger.kernel.org,
  kasan-dev@googlegroups.com,  Petr Tesarik <ptesarik@suse.com>,  "Paul E .
 McKenney" <paulmck@kernel.org>
Subject: Re: [PATCH RFC 10/19] slab: remove cpu (partial) slabs usage from
 allocation paths
In-Reply-To: <a4b0be3f-bb6f-42d7-9176-a2bc0dcbd3a8@meta.com> (Chris Mason's
	message of "Mon, 12 Jan 2026 09:36:25 -0500")
References: <20251024142927.780367-1-clm@meta.com>
	<28e6827e-f689-45d9-b2b5-804a8aafad2e@suse.cz>
	<9a00f5c2-7c9b-44c3-a2ac-357f46f25095@meta.com>
	<01cf95d7-4e38-43c6-80ef-c990f66f1e26@suse.cz>
	<a4b0be3f-bb6f-42d7-9176-a2bc0dcbd3a8@meta.com>
Date: Tue, 13 Jan 2026 10:51:21 -0800
Message-ID: <875x95ibx2.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C5F3B140007
X-Stat-Signature: yw49xzgpbxtxrqx4jooc9r8uaacxg8uw
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768330295-613889
X-HE-Meta: U2FsdGVkX1842RjHFSCGJw9iDmafajrvFWSIbtYLWm9LgDIwxD/OdvgqUxZC0tX8LBMJboKCZ/jP+HsTGK/db3woEHvWtR+vxxWJ8kZzQgaCPIzLbE6S6Kl0BxLIBhcR4boadqmAJFATYc/uvlAZQGJslu6h55dq88fSwtswSTS5aegp2OxOLO+XhLIlbruDESExRCuEkuDkhPa2JQ5bLIK36K6Pq33gdWhEUikqyFoquNsPYj0/erSGnJm3O7b6Vd7myt5e/bJyT3OihB1mxNGF5cghCxSY9u2kSvprRr4AQuCLja6q/z8C7cxq1TVTC8VRyu6jAB7X7WuS9uwFSRR5H/OxXvDptrvJnnW0Ah/UkTZ3hytrMUiT5suC6Tf/N9cC1TCBwF8JFz8fP4SiwRR99izwqgVVCPM6DqezqMhd9yY7XyByZBnFTYCSzh1Nog6L6FJyFFpRyToGPNJ5DQIO+UAAIhfjzV3x76kIQXJdHpVjiqSnykniAwY5s2Sj/DyLNiUV/XXni2mwE0He2WMwe7VWY/iYD92TFMmQfwWanPoxN017wTssDwz1ScuDjcFX3fcLY3nnuOiRv67mSJKpy+jX3UkMMQTJvPF+fYNnuMrVvgr8SewsL1NkUK21Z7yK/XKVmS0g6NaWZni18PzOeAuoypdcOYsYDIK/vfYux9SHj9uLOpgyztOToxe1JOpkB9wv73/igs82V7BlUFLHki+wwtYXWhmswpZuUzlQihASpNVhtswsSFgx0EG01DztVhOp1nP96jejXdtNppPqx0SocCOJRB05sEsXh3nnmrIYlBE4ETOGyUxyLMH2ZExxdY4DMArxX7gGHZbuOs4JYuaQ02f04ceqdhpouQKNfArygTjYacqFMinxDDOsfeft2zdSPZpsR6SbuJcMS4MAOv39AfeaUjFdRuRHiA9IGhKI2CsuBbgm9TdNFph8vEhNcZ813KYD7Hes8kz
 5OjpyeXX
 GnI8B4L8jmYxYXU+ZyOZZx5lUKnDWFyo/CEZxTJJIENSMI5A028/dmMal4+LHLJNqgv+KUxtNFwKjB20d7xNacp9hoUQrHycG7NbM2oSMHbM40sJ6wm6/7f8r3DZTCzaY/QX7YLsGZ5mCAuKv+KhXfYOh5+hX4XpJTWerhClzzRonhUul6n2j/OPrrAHKDQV/qC9ozYgY7azIj2SS9mcXMBTFWKlZR3ZqGKxllYgMikiYw9hBIT32vvhV1w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Chris Mason <clm@meta.com> writes:

> On 1/10/26 10:41 AM, Vlastimil Babka wrote:
>> On 1/10/26 14:20, Chris Mason wrote:
>>> On 1/9/26 3:16 AM, Vlastimil Babka wrote:
>>>> On 10/24/25 16:29, Chris Mason wrote:
>>>>> On Thu, 23 Oct 2025 15:52:32 +0200 Vlastimil Babka <vbabka@suse.cz> wrote:
>>>
>>> [ ... ]
>>>
>>>> By the way, there was another bug in this patch, causing a severe memory
>>>> leak, which the AI unfortunately didn't flag. Petr reported it during
>>>> performance testing and it took me more than a day to find it. Oh well :)
>>>>
>>>> Wonder if things got better since then perhaps, and your or Roman's tools
>>>> would find it today? :)
>>>
>>> Yes and no.  It didn't find the leak until I changed the prompt to say:
>>> "there is a leak, find it".  I'll see if I can improve things...
>> 
>> Thanks. Hmm even if it has to be done like this, it could be a substantial
>> time saver vs finding the leak myself.
>
> Finding the missing break on the first pass was tricky because claude
> consistently focused on concerns about potential NULL pointers and
> mostly ignored the loop flow control changes.
>
> I think I've fixed things by expanding the loop analysis and also
> forcing it to make a more fine grained list of changes to analyze before
> it jumps into the review.
>
> It caught the missing break 5 out of 6 times in a loop, so maybe?
> That's probably the best I can get right now for a generic review, but
> claude will almost always be more reliable with extra directions like
> "there is a leak, find it" on top of the review prompt.
>
> I've pushed out two new commits to:
> https://github.com/masoncl/review-prompts
>
> 9a44c271 CS-001.md: pay more attention to loop control flow and memory
> allocations
> 7fad3996 review-core.md: make change categories more fine grained

It helped Gemini too. With these changes even the flash-3 model caught it
from the first attempt.

Thanks

