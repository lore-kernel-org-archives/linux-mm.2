Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 917D0CCFA18
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 06:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D7208E0009; Sat,  8 Nov 2025 01:33:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AE668E0003; Sat,  8 Nov 2025 01:33:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EC358E0009; Sat,  8 Nov 2025 01:33:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3AEC18E0003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 01:33:04 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EE2141406C2
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 06:33:03 +0000 (UTC)
X-FDA: 84086472246.02.D2D8465
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf14.hostedemail.com (Postfix) with ESMTP id 478B1100003
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 06:33:02 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uzq6smUi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762583582; a=rsa-sha256;
	cv=none;
	b=gp/8tLd9pm40HYXdjvrepIfbIgFb+r4fBuJ22OpyeN1yTrOQXn+FoGzo444KhWzBBfiKwt
	JnAJk6EFBPQU7Lsf2mRZIjBwqHzhimlAqNLuVT36v82SxHObVIDlnOStKrlzF4o0cdOjZI
	zOUUw9nBR06TPkYh82NFsBRttMa9EoA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=uzq6smUi;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf14.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762583582;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J/7T3JLvqIy8G97oSkwZiUgQ/us13qwXbaI51bbYH88=;
	b=ytYdWeKRXDtt45c5UXuoyhe9haLyyFx6UJXlv/c/yyoM5g4JwmCmHhP0gcS6muwmuwgHIY
	YjVPCI2ekDW3TJfWlazhHyJv+PrYhDJB6XlDGDXOS6bIbByKlctCkuKrQNHCzzxl9IJnEB
	9KS+XTUbJENSUFh+E0P+BU2kYXS+Mic=
Date: Fri, 7 Nov 2025 22:32:52 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762583579;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=J/7T3JLvqIy8G97oSkwZiUgQ/us13qwXbaI51bbYH88=;
	b=uzq6smUiUaadIABNL4WAH3kQ9/NWi6rV98ylBfMFIppw4E+N8btmKbgAwhGrszMoJj9rnz
	CB2k+MOmm4mSUBVKeFZssHPocjdfCursoyR/iyfIffk6nTiCSrZTDcFQJPhgzISSZpcb6J
	ZQS4G8+TUhTtakAd1HkSQXaXtPTzs0Y=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Harry Yoo <harry.yoo@oracle.com>
Cc: Qi Zheng <qi.zheng@linux.dev>, hannes@cmpxchg.org, hughd@google.com, 
	mhocko@suse.com, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	imran.f.khan@oracle.com, kamalesh.babulal@oracle.com, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, akpm@linux-foundation.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	Muchun Song <songmuchun@bytedance.com>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, linux-rt-devel@lists.linux.dev
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
Message-ID: <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry>
 <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aQ3yLER4C4jY70BH@harry>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 478B1100003
X-Stat-Signature: ftpri1wgqq1tq1tzcew1o8aknz9et94k
X-Rspam-User: 
X-HE-Tag: 1762583582-23064
X-HE-Meta: U2FsdGVkX18j1yD8w7tjdpujKsTrgouGE8g49rsFNiQ35d7x2Yx9FWlUDA0Dis/Yx3RA/5r0bIE8vnzKvYbWQRtVt8qcRyHphLohjgnFqaVPaGdAAqYpt9fHVdNJWaEXzo/EhkjJ3GBJ377Q4Rx14YkmTajj8oaZsNPuJubdGPqy3kmRMOuw+nTXOyb6OO0Zd1ODySgvtHZuj9qC7ry3t/tADAmU51yNDRaSgisbysn0+fyoas+SD/42ZdhSgbqDqVzqYhnrTdJIuqMbgJn4jdqyJPCbSczjV/wFgOhaTI6xCIHilXHYRIxGdU9ulKj6QpDN2CHg0nyPC7qpFEcMKYa7ZNy/jgbbuzV8UcYcjJFQZMgrF28HgEoZMcpDnOx7L+fTiKiKVM9yEUR1C5ciRLjvQWL8I+wFRvDuHvD2+yuVZ2wQCNSwSL4R/c0qKjOkpgWt39Kej/aDqti7/ni7uFHt1fygZVFXdG9unKSO2QaCIUuP6z7BzQFJj5Gj8S6dLxtgBLflFv6PGpYlADeXj5TTNF1AlbBysEsfZLZ/2q1QuJdmu3Gk0vM//fmaAl0x5tBeQyCbveNo4rrazNkSPWzZorqx462i25LBpiGG4iYbJ/qNQhtKubj7d9LDh72j/q+tPJdhEXhB/J7JJ1j5oVutBzkaW5gNGt6lHd+ALmrjXZSvRc8VIOyWKz2UUqjxbxPZLDBwfuospVT6SexxJBaKGGIOYF2xTwUM/w5R6FfqvwNEUKWRzL1QxwMTjE9uOUu1AvLYMRaMTJnNW4tCtHEAGuaL5k3yKRO5z0hiSP4wkKNnXaiFSC+ifCrRs4xN9q9lqi9GBu0UbbANo8nhfFtr3l+SFeUvFEi28ou503yE93ZTpKau0z7mcNpZkuIF50sy5bUwK7Um88HSOgMEFWpMXrEdIAA0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 07, 2025 at 10:20:57PM +0900, Harry Yoo wrote:
> 
> Although it's mentioned in the locking documentation, I'm afraid that
> local_lock is not the right interface to use here. Preemption will be
> disabled anyway (on both PREEMPT_RT and !PREEMPT_RT) when the stats are
> updated (in __mod_node_page_state()).
> 
> Here we just want to disable IRQ only on !PREEMPT_RT (to update
> the stats safely).

I don't think there is a need to disable IRQs. There are three stats
update functions called in that hunk.

1) __mod_lruvec_state
2) __count_vm_events
3) count_memcg_events

count_memcg_events() can be called with IRQs. __count_vm_events can be
replaced with count_vm_events. For __mod_lruvec_state, the
__mod_node_page_state() inside needs preemption disabled.

Easy way would be to just disable/enable preemption instead of IRQs.
Otherwise go a bit more fine-grained approach i.e. replace
__count_vm_events with count_vm_events and just disable preemption
across __mod_node_page_state().

