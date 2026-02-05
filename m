Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9A9EC1EBC
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 15:05:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A71E06B0098; Thu,  5 Feb 2026 10:05:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A52CE6B0099; Thu,  5 Feb 2026 10:05:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 955526B009B; Thu,  5 Feb 2026 10:05:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 834A26B0098
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 10:05:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 10CFE13AE83
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:05:53 +0000 (UTC)
X-FDA: 84410727786.30.802A654
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 428141A0007
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 15:05:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nnxsi5HU;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770303951;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uRemT0rTjqM/Nf6Wea5Ss4vloc40VnBxi4xhQri3+w8=;
	b=iXmQclETvv4UElcjn9rAAzwqaOvdEAppnXtyWn4rgoYAQmzu3VQGioAMPr2Aq8mjir3hqB
	9no9pIGowMwbpMi+b43XTJyzzs+chVGfAIaSZ1kK8d5z7v1jRV46Pp+zh5q55ccY8o0wqk
	ezqhQFqICqmZi4nezgLid6qr3XF2gMg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Nnxsi5HU;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770303951; a=rsa-sha256;
	cv=none;
	b=hSOhTxi3d809Pws52SJFjvl/7EFWpsvLLTjWcoO+MbzhjRCjGyMCfWdZVfQDXSFtSG15sg
	PZAsapopOhA5ft4mgDmhyD0wr7FWUPe0ZxQ2tzRt7lh7mQQrmQtKroNqZlpT8F7FSG/CWV
	t4dmnl9i6cvYqDYvDrK/WBLwCS4Ng1w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 24052600AD;
	Thu,  5 Feb 2026 15:05:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FE20C4CEF7;
	Thu,  5 Feb 2026 15:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770303949;
	bh=j96p+OyD8Rwd2quAZhZFmoOxkn1/T7FEMnk0TZP4YRE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Nnxsi5HUZSnSL0xRsB5HIqzymZ2WU5Q/JBJ1FWvlgD8f9Lf/AVQex1Zc8QhGgF3DI
	 R7lmPisE2yWGZnoq6iFZJDqbv5+mx0ONEx6i4GL+pcsC3YBx1mustgCqN1AwvF2d4C
	 NTmEmcBL2COI1YAebiZ003vRsEnEGjtKX0EndcECnyp50BdIDHtPW9iTQzc210OsgR
	 FrIfZT5QL6SPqN1QDGYyTQNzTHLZoUO8Wolg/RsAIIGoxBftIyhVrqKHtt8FA0pRQ9
	 9ZINY/D+Miq//aTKcVNhoPESi8R9eIKvURNUJmA0lPtJ0o/8y0TEXOx+kzwxWNy/zy
	 w0o3UTmd7ykOw==
Message-ID: <13205d28-7478-4578-8bf3-ead18b4dc6b0@kernel.org>
Date: Thu, 5 Feb 2026 16:05:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/3] targeted TLB sync IPIs for lockless page table
To: Lance Yang <lance.yang@linux.dev>, Peter Zijlstra <peterz@infradead.org>,
 dave.hansen@intel.com
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, boris.ostrovsky@oracle.com, bp@alien8.de,
 dave.hansen@linux.intel.com, dev.jain@arm.com, hpa@zytor.com,
 hughd@google.com, ioworker0@gmail.com, jannh@google.com, jgross@suse.com,
 kvm@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mingo@redhat.com, npache@redhat.com,
 npiggin@gmail.com, pbonzini@redhat.com, riel@surriel.com,
 ryan.roberts@arm.com, seanjc@google.com, shy828301@gmail.com,
 tglx@linutronix.de, virtualization@lists.linux.dev, will@kernel.org,
 x86@kernel.org, ypodemsk@redhat.com, ziy@nvidia.com
References: <20260202095414.GE2995752@noisy.programming.kicks-ass.net>
 <20260202110329.74397-1-lance.yang@linux.dev>
 <20260202125030.GB1395266@noisy.programming.kicks-ass.net>
 <c6fda7c2-ad54-416a-a869-1499c97c7bd7@linux.dev>
 <4700e7ba-8456-4a93-9e28-7e5a3ca2a1be@linux.dev>
 <20260202133713.GF1395266@noisy.programming.kicks-ass.net>
 <540adec9-c483-460a-a682-f2076cf015c2@linux.dev>
 <20260202150957.GD1282955@noisy.programming.kicks-ass.net>
 <d6944cd8-d3b7-4b16-ab52-a61e7dc2221c@linux.dev>
 <06d48a52-e4ec-47cd-b3fb-0fccd4dc49f4@kernel.org>
 <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <3026ad8d-92ad-4683-8c3e-733d4070d033@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 428141A0007
X-Stat-Signature: udpudx8e3deym53se7sn5f9rmu116x3x
X-Rspam-User: 
X-HE-Tag: 1770303951-414429
X-HE-Meta: U2FsdGVkX18Rx4s2W4junNwVzTlDdj5tDroPUTRr8cxNk7Ca1Fvksw2LQ89W9mIvceMdTdRYmHWecDxK3D39LT/6bgQm0oRbHGFxdkeV4ILOeZCLenfeO+N/bCLGVa3bWzcL7uqJFiEUzehZK4khNwGfnRpmtDiKbR9SJjwyTTDcNfKAKZsdOUMPaluWDkccsijJq36RrN5Q4KDnkXLKbRzp6Gfn1I+t+w5VsoZK9C9hoab5bQun0xbIwBSRVJ/smKdVbEQPaBrZGBrlnpsSODbcog+n0HWf/na2NjxxPKZEguRsoB8fL2l18Q2JkXVqYLkxb48SUPvdBeKTZercPcza4MzgeAj4knugbYD73KYg52CD+acJN3j/BzmbolUpGC/Jh1hkjSivc+r+ndrMBNEnUA1newbAoNKcqVseSfCick4bsuWk3/dNqJ3Vg3668RLnxuKqyrDW8cc4OLbifoRn0azb8oF+0xqrP8/hckjiYqPc+ZN4N3c4eCvHwENmd+rYTTaBncVCWrq398fEJ4WnN5nArtvzgpA+K/qTuWTHwrR9oeSXsfZ4Pv29JNzulpM1+Hf+8R0jNJ6Nt2xeAIyiYmpiJQ+ntg4TdpGWY2Ayz4V5oueWm4OcFhqaHb4f5ZvIs8UXpORWNbUYQmJ5eWBR4SfIzbewqVD5TxKtUetcawYDjgXS9AI6uiNjQOBBF+da7xjM18mOkp1+r2FgmuQRtZisH8s2l49ucXuo+bgFZeqgMcZzRzZsBW9ObuqT7ZiLkCI6tAhmD/hH3KjKJ8vaLkMZW2dwe+PenRGaN/zxD8Ym/Qil7mLOg1EL/p2Ra3ZrU+l10KsuEaDWfzBFBbQxIwTlhiqe9wGpZPhuipzEPwCOxVh7QkPaJ8bqrRlqaqOQ+5urQ45Ac9MrxW4DP2L/MWuXLFuLG8u7FKn0KSf8sFZ2Xf9efCbWTzDmvcS0VrvRj7zaRnB6PnFr/Mg
 pXRHCwgq
 6lMg3aimXCknT+Ht8hXodHM6eXJCNe2+W04VL1y2C+uvPGcpzrfVIk4TAgaWM85SqN1XBwuv1gwPlpqjUL+Ljj153os6lwVFU1HTXmMW/YIQTVs+Xlu9dnkk+b/oclc5JKQfW8EUenezsibcT/E228hB5Eqb4Y9ZGLdsU7TxcPtIKotK+13s2955gLPpiVH4MdiiYVXiso+OW4tPuHHbdpiggW/vCbUsHgCxds66E1sE/lJyJsuaPaxOb5ahJULhhnhd7wSDxgQuWy0EP719wIDUW589Xc7ASHec4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/5/26 16:01, Lance Yang wrote:
> 
> 
> On 2026/2/5 21:25, David Hildenbrand (Arm) wrote:
>> On 2/2/26 16:52, Lance Yang wrote:
>>>
>>>
>>>
>>> Yep, we could replace the IPI with synchronize_rcu() on the sync side:
>>>
>>> - Currently: TLB flush → send IPI → wait for walkers to finish
>>> - With synchronize_rcu(): TLB flush → synchronize_rcu() -> waits for 
>>> grace period
>>>
>>> Lockless walkers (e.g. GUP-fast) use local_irq_disable(); 
>>> synchronize_rcu() also
>>> waits for regions with preemption/interrupts disabled, so it should 
>>> work, IIUC.
>>>
>>> And then, the trade-off would be:
>>> - Read side: zero cost (no per-CPU tracking)
>>> - Write side: wait for RCU grace period (potentially slower)
>>>
>>> For collapse/unshare, that write-side latency might be acceptable :)
>>>
>>> @David, what do you think?
>>
>> Given that we just fixed the write-side latency from breaking Oracle's 
>> databases completely, we have to be a bit careful here :)
> 
> Yep, agreed.
> 
>>
>> The thing is: on many x86 configs we don't need *any* TLB flushed or 
>> RCU syncs.
> 
> Right. Looks like that is low-hanging fruit. I'll send that out 
> separately :)
> 
>>
>> So "how much slower" are we talking about, especially on bigger/loaded 
>> systems?
> 
> Unfortunately the numbers are pretry bad. On an x86-64 64-core system
> under high load, each synchronize_rcu() is about *22.9* ms on average ...
> 
> So for now, neither approach looks good: tracking on the read side adss
> cost to GUP-fast, and syncing on the write side e.g. synchronize_rcu()
> is too slow on large systems.

GUP-fast is 3%, right? Any way we can reduce that to 1% and call it 
noise? :)

-- 
Cheers,

David

