Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7AB76CEFD0C
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 23:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5FC66B0088; Tue,  6 Jan 2026 18:26:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE2B36B008A; Tue,  6 Jan 2026 18:26:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E1D96B0092; Tue,  6 Jan 2026 18:26:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 89AC46B0088
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:26:34 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 394D68D6EB
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:26:34 +0000 (UTC)
X-FDA: 84303125508.28.3CE874F
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf30.hostedemail.com (Postfix) with ESMTP id C770980007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 23:26:30 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WYEwkBj2;
	spf=pass (imf30.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767741992;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dTr2VYpGZUXkz8/X79lKRSGp5qVJrcOa+q9S93X9RYc=;
	b=temOQ+vyQKhrxOluNSAuNbxJsmEP1vVlhmQAcDDYRY6fc6387xRPV/DhHv8JZGCQ7JXkI8
	SJSBqMSl7l4mAdhbx+EZvgqX2bN+9ZRNvswL/+3ecs//F+pRLprtGeEobOI8uWJnswR7+R
	6uYIagtW5GR2b8EJhE3KSlvpidtpFNE=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WYEwkBj2;
	spf=pass (imf30.hostedemail.com: domain of kent.overstreet@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=kent.overstreet@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767741992; a=rsa-sha256;
	cv=none;
	b=BVuw7OFjKp7f+B4Zt+hk7usldhfMXTqU/dxXbFxe6wkXL968ys54JIOh7dxdK3pfIoHE/K
	PwJ8hnAO2IAbnpuC6R993jErfzMKlh2OCo+4UcxmZblB8FeLnKpcVe39mCLlCD3dSc6yDS
	fyrsknXfEOil4j26CK8AKQyQxHs31cw=
Date: Tue, 6 Jan 2026 18:26:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1767741988;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=dTr2VYpGZUXkz8/X79lKRSGp5qVJrcOa+q9S93X9RYc=;
	b=WYEwkBj2eVQT6DEKGr4vtDO8503dmyiN76UZ0WuQyob889KZjYi5kTx0zAHNDZWvZPpyG5
	n/nzUG5ctYL+8tGC5zrH57XeIT8TFX7bLBgzwZH4EQAeB4uo7kA54mlvKmQ/+Ut9Q13D2/
	IX6bUtB0GzzlsfDUp1Z4Y4xq6NQVsio=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: David Wang <00107082@163.com>
Cc: Suren Baghdasaryan <surenb@google.com>, akpm@linux-foundation.org, 
	hannes@cmpxchg.org, pasha.tatashin@soleen.com, souravpanda@google.com, 
	vbabka@suse.cz, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC] alloc_tag: add option to pick the first codetag
 along callchain
Message-ID: <aV2VWbY4Rb_w-QTs@moria.home.lan>
References: <20251216064349.74501-1-00107082@163.com>
 <CAJuCfpEtZ2Ncpa4goKUcerruB67fALJ2v2KrbWB1_PB7iwwjSQ@mail.gmail.com>
 <75285cc4.3c52.19b916d9490.Coremail.00107082@163.com>
 <aVzorksJEyI0wlxh@moria.home.lan>
 <37169c79.a0e5.19b93a2768f.Coremail.00107082@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <37169c79.a0e5.19b93a2768f.Coremail.00107082@163.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C770980007
X-Stat-Signature: ko5rji3useth7bdcgs1eexbkoeb84twn
X-Rspam-User: 
X-HE-Tag: 1767741990-757607
X-HE-Meta: U2FsdGVkX18ILfmPi/GrDEJKYsAQ4Wg8qPHw/zM1acnB58yAsBqlOutAphC6jUiWYQoanDXjeTGjDe2pV1F2zY5XcWCgnzay/U9A/2eC6et+8vEexgEeTPZ/k9uzTm3DaejdFvQj6SU6ZTky4kkOztFBLUgk+RSQt3j0gawmL269EUX5qJWfDzfZ+bI9giAxzDSsx2iM91pNRq0667WR9IBY7/dyNSafZHyTAUsGDJNmV8R/ajgdoWalOuuZAESP3I8MOqnK7bODGBNp1H3NaJBfYKSmKxr4U1HCjaJot1L9a3jkjMuwC07jk1a2nRIViKDxYY1DQiP0h7gkZof7IatSGjtzG38dVKbSbPjYCPT8DZAdHPaalVVipIk91k+zEM30b3AFZGDnieLbIVSJzlI6LCAI5jaQPtnembMFOeL2Onsjl+/YGIg0/nywGfHDzSp932QsgTFgn4ammIWu2u54hhosnpEYlGyghSXj1Xzx1/KSBmWa+ppLJORFXoXz4a/2ERXylAEGRslHaPnxzPqTniwaFL6k50BI/+1o38kkdrjgne8NHYfBUZlBZxnrsEP7XnmIDp3yRa9kkhsSKVwwmExV8f7IJPBMbWyV7OBeYx/dM4yEX7FhDLFrNRQ7M602uWEoRarVUIRJ+AroYz+FMbsghPxw1t1XmHGmi1LBsv80SS8UTOL22VTBRXstHFl0QzJmO+u4FF5e9UQV+I+kckAPNuqq2KyeIUit9G8p48OOqyaUIjaxsSXc6LJYtu/1XKIJWbbs9NtW3LEzhYhX6IAZoyvkhx+13HZ2vKICAGss3fRdiGHt5hl6TX4lbMyTxL8T6kK0QZqOtiyd2alPts51SEKwLCMwJI01pCAnQFs7L/QMiNER/YgHBdTUjKSqteJsmpkrhUQyRCvKCVFuGmFNs8KhCn5iWHymr6+1Y2Jl3OTz+pAPYBlwXGqnuDhB9r/8urE2mNSqPJr
 Xp7MEx6H
 Hvs/VrdXJT0C8UP4mPFH5LsUgauMKNBwHXPSZnQGngpMS4OZBuMrkDNwkF99MRhOqKQhoF+X0X0Wl+6eRRaOQu46eNGeRyRnKx70SVBytVjjGdHGrbTSFm0jsASbIt7EodEZgUQN29l7vMa/JdxMPoyAo1Y27PcIHzSZ5aKM+dzX6VGf5J9Zd6am/M0g/0zGYALe4qyajlKre59UYHzPS1Wh6tg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 10:07:36PM +0800, David Wang wrote:
> I agree, the accounting would be incorrect for alloc sites down the callchain, and would confuse things.
> When the call chain has more than one codetag, correct accounting for one codetag would always mean incorrect
> accounting for other codetags, right? But I don't think picking the first tag would make the accounting totally incorrect. 

The trouble is you end up in situations where you have an alloc tag on
the stack, but then you're doing an internal allocation that definitely
should not be accounted to the outer alloc tag.

E.g. there's a lot of internal mm allocations like this; object
extension vectors was I think the first place where it came up,
vmalloc() also has its own internal data structures that require
allocations.

Just using the outermost tag means these inner allocations will get
accounted to other unrelated alloc tags _effectively at random_; meaning
if we're burning more memory than we should be in a place like that it
will never show up in a way that we'll notice and be able to track it
down.

> Totally agree.
> I used to sum by filepath prefix to aggregate memory usage for drivers.
> Take usb subsystem for example,  on my system, the data say my usb drivers use up 200k memory,
> and if pick first codetag, the data say ~350K.   Which one is lying, or are those two both lying. I am  confused.
> 
> I think this also raises the question of what is the *correct* way to make use of /proc/allocinfo...

So yes, summing by filepath prefix is the way we want things to work.

But getting there - with a fully reliable end result - is a process.

What you want to do is - preferably on a reasonably idle machine, aside
from the code you're looking at - just look at everything in
/proc/allocinfo and sort by size. Look at the biggest ones that might be
relevant to your subsystem, and look for any that are suspicious and
perhaps should be accounted to your code. Yes, that may entail reading
code :)

This is why accounting to the innermost tag is important - by doing it
this way, if an allocation is being accounted at the wrong callsite
they'll all be lumped together at the specific callsite that needs to be
fixed, which then shows up higher than normal in /proc/allocations, so
that it gets looked at.

> >The fact that you have to be explicit about where the accounting happens
> >via _noprof is a feature, not a bug :)
> 
> But it is tedious... :(

That's another way of saying it's easy :)

Spot an allocation with insufficiently fine grained accounting and it's
generally a 3-5 line patch to fix it, I've been doing those here and
there - e.g. mempools, workqueues, rhashtables.

One trick I did with rhashtables that may be relevant to other
subsystems: rhashtable does background processing for your hash table,
which will do new allocations for your hash table out of a workqueue.

So rhashtable_init() gets wrapped in alloc_hooks(), and then it stashes
the pointer to that alloc tag in the rhashtable, and uses it later for
all those asynchronous allocations.

This means that instead of seeing a ton of memory accounted to the
rhashtable code, with no idea of which rhashtable is burning memory -
all the rhashtable allocations are accounted to the callsit of the
initialization, meaning it's trivial to see which one is burning memory.

