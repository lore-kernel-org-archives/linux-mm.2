Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 053D4CCFA1A
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 04:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB33A8E0005; Sun,  9 Nov 2025 23:30:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D633C8E0002; Sun,  9 Nov 2025 23:30:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9FEB8E0005; Sun,  9 Nov 2025 23:30:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B6E188E0002
	for <linux-mm@kvack.org>; Sun,  9 Nov 2025 23:30:25 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 284FB12D97A
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:30:25 +0000 (UTC)
X-FDA: 84093420810.15.3144AE6
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7885480003
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 04:30:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QrKMgcjb;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762749023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VM4mtZug8xE4ghkhPgkEdlWdDR6+a0E4+YRze3eMGSI=;
	b=7/b7UYP8CuofBUzkLk3az9Kjd9hBaq1CxNNUXpRNupOME/ZBHJTlJVRJsJ49+l0W7MhVda
	y2nmGWdZ06ulUt+relCQiL5IhdQfyr1QhCrU8zEFCXmXEYqOWFgf9qL7Atg0zkoegEGCOs
	Va1+h1e6bY35V3itmf6aMczFV/ikHJA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QrKMgcjb;
	spf=pass (imf02.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762749023; a=rsa-sha256;
	cv=none;
	b=3lsEx4jV8HP/uiJG1b3hwXKRIL476n0FqQi5bobXCJCEiUjGAk4z9EuPNBKZPQzstC1BZc
	1OOFs23n6bp0U/thZJ8VtQpmE6DLlgcPbAAmq4He1uVJwV16WOyyzBDyd1TSSvjqvDlu9+
	lYvmhTubI8O0cYZuTQFW0t4qfX2ut4o=
Message-ID: <2a68bddf-e6e6-4960-b5bc-1a39d747ea9b@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1762749017;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VM4mtZug8xE4ghkhPgkEdlWdDR6+a0E4+YRze3eMGSI=;
	b=QrKMgcjb+M+1F+KOE1U1Kz2oPhiC+29MYWaxjYCseEb9dCjF/qm7ht2OVhV3hu6Ni8yXAS
	0k2iLbwHoKMIxa4K4ZUwxl+IOfLx4O354NnSpcjicDEqtBtrjS0hjI2H/wZRxnioVCq0s9
	yXbOo+3DumqD4576zhhXeGXKJJNoBrE=
Date: Mon, 10 Nov 2025 12:30:06 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
To: Harry Yoo <harry.yoo@oracle.com>, Shakeel Butt <shakeel.butt@linux.dev>
Cc: hannes@cmpxchg.org, hughd@google.com, mhocko@suse.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, david@redhat.com,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, imran.f.khan@oracle.com,
 kamalesh.babulal@oracle.com, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 Muchun Song <songmuchun@bytedance.com>, Qi Zheng
 <zhengqi.arch@bytedance.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
 linux-rt-devel@lists.linux.dev
References: <cover.1761658310.git.zhengqi.arch@bytedance.com>
 <97ea4728568459f501ddcab6c378c29064630bb9.1761658310.git.zhengqi.arch@bytedance.com>
 <aQ1_f_6KPRZknUGS@harry> <366385a3-ed0e-440b-a08b-9cf14165ee8f@linux.dev>
 <aQ3yLER4C4jY70BH@harry>
 <hfutmuh4g5jtmrgeemq2aqr2tvxz6mnqaxo5l5vddqnjasyagi@gcscu5khrjxm>
 <aRFKY5VGEujVOqBc@hyeyoo>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <aRFKY5VGEujVOqBc@hyeyoo>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 7885480003
X-Stat-Signature: 79ke4jp9cqnzwkdii1oob7r6chu5dqzi
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1762749021-674987
X-HE-Meta: U2FsdGVkX18I10n3nIZsRO4oDFxLygW7KccykP00m1CZxv3ktS1NhRlfepJ0uLcB4f62OtkLMqYwrMR2uIqOh8U6p+fhQt1sj/ojp3mYsKvK2E++tKy2k9UyMYOQr+TxOcTQQlVUMybhhf2PNF13XgYQOl+QYuSSo8ExdxvIOCB5h4hwwFH4ACe3HHLgc102zxiIgUzpcs+O7zRNItTRO1NWWnPwlCXWKCdoVKIrAPgpqX7HUoq4XD7InjapYuNEbhil5GCsn9b6uvR1nCd1eb0xTDHqdQC4nKRCpw8hPETtPOh1DJ3K0Yqjqz4UIp59r4F/gR+Uhz93X8ML6uif2z/pz0zQPBVLDH/vaYklAmuoUiIAbiBm9XVTDOYayxoeJO+TzaeV3LGHPfW+h1wjTTcjBF/7asf4BewS6MrUPNn2+BeNUsXUG1McYKqtMKOrzacWk88J0hUX6gWHfIIEm+0Ol/JGz+l7SMv5gCdXBOhNNIzjOec27gQoMevlGQVQ+RY6vFgwb9jhu6WFQkCXQ0ha++uMAHotUgd5F7hRddX2D3Dr25f+Vau3srsQKH/VXrnj1WmhpzI0KkTfNImNap6l4tMy+29AS9T23c7qIYrixln1CKFNGc8ZMv3/WoYdEjDo70k8awtlNWJPgbIK0sBnEk5oBu0Ow9mIKl3X2fIkVlEz9QxuY+h79zqaPU4k+CJplxwO0RwnstycBcd4B7CwMVt2hrQOXlv+NgOixyqiUb0BlLRpUsnV0zRx5ioFLqyUDzdiC14TvxtNSqVlv4+Wf3muCuuKzTqVjxcpNSvb2fBrURXwF6ZmqY8G/+geAGVt63OPXLezpmZUlcpnbO+Q6SLYxsDdgOsOYivNrw0QNwpPE34bPRSqDSvY1vKhAsAZdUcyq2aYtARVtdKc7wpVZxkqQkO5DUwtONbqBsnrV10anXWVX2Q3Z+su5DdcRtYkJPOHsDK++7zfRkw
 ERvVIsse
 pc4Dk9ufi72qWVS0eQvK/sD0faSNWlbzsrzfVJjfS6ZxdffnP4zBrLbcQLWZQAmKhwZYpHU0zNTo1b+YFZcItMNYOb3EKF9ep2+AHGZYokmwHDXDKLSotsgkYGW951rdMPP/SND1dxpZeIe8SdGZx8HANqeelE213SUS7FeY+pEcBYJhqrejpoZ/Y9QS2C5JFWEwKgTnWgtrHlPJ/UT8AuFZtgWUMoIGD7RKCOmbAea9frMqR8LCtvcC6+c3BRKJ6b+qj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/25 10:13 AM, Harry Yoo wrote:
> On Fri, Nov 07, 2025 at 10:32:52PM -0800, Shakeel Butt wrote:
>> On Fri, Nov 07, 2025 at 10:20:57PM +0900, Harry Yoo wrote:
>>>
>>> Although it's mentioned in the locking documentation, I'm afraid that
>>> local_lock is not the right interface to use here. Preemption will be
>>> disabled anyway (on both PREEMPT_RT and !PREEMPT_RT) when the stats are
>>> updated (in __mod_node_page_state()).
>>>
>>> Here we just want to disable IRQ only on !PREEMPT_RT (to update
>>> the stats safely).
>>
>> I don't think there is a need to disable IRQs. There are three stats
>> update functions called in that hunk.
>>
>> 1) __mod_lruvec_state
>> 2) __count_vm_events
>> 3) count_memcg_events
>>
>> count_memcg_events() can be called with IRQs. __count_vm_events can be
>> replaced with count_vm_events.
> 
> Right.
> 
>> For __mod_lruvec_state, the
>> __mod_node_page_state() inside needs preemption disabled.
> 
> The function __mod_node_page_state() disables preemption.
> And there's a comment in __mod_zone_page_state():
> 
>> /*
>>   * Accurate vmstat updates require a RMW. On !PREEMPT_RT kernels,
>>   * atomicity is provided by IRQs being disabled -- either explicitly
>>   * or via local_lock_irq. On PREEMPT_RT, local_lock_irq only disables
>>   * CPU migrations and preemption potentially corrupts a counter so
>>   * disable preemption.
>>   */
>> preempt_disable_nested();
> 
> We're relying on IRQs being disabled on !PREEMPT_RT.

So it's possible for us to update vmstat within an interrupt context,
right?

There is also a comment above __mod_zone_page_state():

/*
  * For use when we know that interrupts are disabled,
  * or when we know that preemption is disabled and that
  * particular counter cannot be updated from interrupt context.
  */

BTW, the comment inside __mod_node_page_state() should be:

/* See __mod_zone_page_state */

instead of

/* See __mod_node_page_state */

Will fix it.

> 
> Maybe we could make it safe against re-entrant IRQ handlers by using
> read-modify-write operations?

Isn't it because of the RMW operation that we need to use IRQ to
guarantee atomicity? Or have I misunderstood something?

> 


