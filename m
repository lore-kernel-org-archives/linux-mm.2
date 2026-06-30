Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6F1B7C43602
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 06:34:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43FC56B00A5; Tue, 30 Jun 2026 02:34:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 417616B00A7; Tue, 30 Jun 2026 02:34:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 308706B00A9; Tue, 30 Jun 2026 02:34:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 019816B00A7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:34:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8A8041C310A
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:34:57 +0000 (UTC)
X-FDA: 84935616234.06.6D34566
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id D0BA5100005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 06:34:55 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zb9fiMxH;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782801295;
	b=LzoOgT0N0+8+N2jpwT5EJLK6LI2WKBitIrCLoqH3QP2Xavf9hXSH1H00FntXxtAF4RWtM2
	0Sm3mUgPBAx8EROgD1leSKrpZ8/PEKggn+1cTElSo+LZk7aheRPDkakICGm41BqO54e3ek
	ylvgCOmomoS9FnHcmJnrbroQdp+o+ds=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782801295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EGuQzeJmx9gOrE/eY6AwUnnp4ycjaahX6HSrGeOyFuw=;
	b=tmcmsV6DveSvKpGndTdIFBVeQB+bxnx4iELKUdzI+UX+wemyqOhp8MS5xt+WnsWR5XxsVY
	oW3+8x0h/rn42HGEuc67OkySFIHl1XNze/gNL+VAr5qFtKE6jBf7m06ON3vLqyZBRd2veJ
	q/5UhGdYyiamonAtB9qBv1A9fFsPEeI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zb9fiMxH;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 47624600C3;
	Tue, 30 Jun 2026 06:34:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1ADC21F00A3A;
	Tue, 30 Jun 2026 06:34:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782801295;
	bh=EGuQzeJmx9gOrE/eY6AwUnnp4ycjaahX6HSrGeOyFuw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Zb9fiMxH2dvarKbg54RXe2oUt4rjfGoix58RvskFE5wWfyBEPQvVAVKlQHM5rtixK
	 3orrHnZxiULC3ZcUBJLyygEt1xlw6l8ADBF3V9IYDrpRtDoM8gMd6jvPK0DZmme+Xe
	 YOlwEWui+bN/KlsjVpP74HPd/WxX4UwvnHszTQZt5INNMaGEfKcG1g9pDQMfLbmvDZ
	 Hiy4cr1SRubbCj6NvkR6GClyJSmgybIDWamJ+CYPAymsoYgTzflQsPFB4stlyh3rAk
	 gse5TSzFAPzwq3YNNuLTpViT51z9eq6cBOlRkGENXhxZLY15R7xN8qZYQGw2X8VrGR
	 J/kMltGia6Utw==
Message-ID: <0fb36931-9097-43db-98bb-d087b7b0fa12@kernel.org>
Date: Tue, 30 Jun 2026 08:34:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] mm: memory-failure: fix HWPoison flag race with
 non-atomic page flag ops
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Andi Kleen <andi@firstfloor.org>,
 Hidehiro Kawai <hidehiro.kawai.ez@hitachi.com>,
 Rik van Riel <riel@redhat.com>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>,
 Hao Li <hao.li@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Byungchul Park <byungchul@sk.com>, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org
References: <cover.1782676497.git.mst@redhat.com>
 <0b5f8b4b-d7dc-4b79-9555-a5b36265f3a9@kernel.org>
 <20260629030657-mutt-send-email-mst@kernel.org>
 <4f5ba5d6-246c-4430-9737-e8dd8e4c5142@kernel.org>
 <20260629092856-mutt-send-email-mst@kernel.org>
 <54c8cbee-9b26-458c-93ba-5aa594f5d1e8@kernel.org>
 <0a309ed3-378e-4d88-95a0-65bf47c5496d@kernel.org>
 <20260629193347-mutt-send-email-mst@kernel.org>
 <5c8ca96b-381a-4fd3-a218-6aaa87a9a3b7@kernel.org>
 <20260630022129-mutt-send-email-mst@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260630022129-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6w53fmt47ebfeq4hye58zqbeexrodar9
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D0BA5100005
X-HE-Tag: 1782801295-287128
X-HE-Meta: U2FsdGVkX1/LCnDNfbPrVU3dt8GvyXecIZH1vv5bJ5AWyMjck6Oa9fW+JXhi9s5wHYMihX5/iMWqgBt2plXZJQy7Hl1YDAq/Pfi3CmPplMhLDTLoFhMS//UxLTHt8NpXb8Uma/Q9Y7Cr7xmt0C1XKRggCvWxvBB3kC1XwgX3sxKr/NuQGJKAKq4ba453dadxi0gxuoMTqOOM/ABfeqHcv+NKYbSbYOIG41yyYAy2PlwInZxvFcdw3aLS50VSCId0N6SpjMSa7x4W/VUbflqghkTkvyVF0+9H2xdkBQhZSK95b8Rngvm4sv6GKC9DvoyJFLEkIF92aHC9xIoN3nsVuS2AK5ivWiDbXEaSCzI37z/qTSMn4fMwBlUquQguAPoQnByLgIBYdGiXrwytDx9b59dRBNIobhC/UlJfiKawCburVltjbsCnx9cLL+gK/mNsvziG7k7iMEUx+2pB+OGkcKwV5QViyvmG/EbMEkvRHGYOBDdbJiYo2TY/jHxsVJzV9WVNlMqe4AbFAyo8OGLT5cXOiaHcnWNQR25wvQJnksw+R2frHfB6jT84AoTEm6eMEWB31VnVi+SJviDDKoSombcl20vxDNFF4bw3gXQ1Op3lyx1C/tNt91M8ldngQFWqYqlO1FKKwp81sLqpisPIwaxbh7CPkXgqR71+lG0KHvtNzDCN4uYQt1acFL26JRpHDZv7DjKV6CL9nIlIQrbycK+ERk218HL5aXhwpHGCuYg9bH9RHIs4u/V+JyBu0SQlndToeM85eSsy60blb4RKvTUpI4VCnNEQFd1J4PigwQElEwUvqM+BCgN71wnJSUDhKDLRI8WnHM6zB7AsRNXL8PNS25Nlht20MD9xBwQzYZ5hPzqmBJvr//pvelT1mdridYaYZ3gPKBDdqerKhCnY72Vy8vqpTWPf+UGgLLeLgxlCuBTKpHW4LIQ4csIMcL0Ey1JDn2/m54jnNQmh55j
 5ub1R98y
 jw4Gl+ED5Ub/YMjj7lfSIxLFLhsC8IUX0wu3M/Bl/p5cHoH65+6alUs7VWirwtFLfh0zcaSKq1/Gkr301/DfTP8YCC9M9LNp76VpGC1+31vpNqijpg3Qn/1Nj40J2HVXmvJ0nygkGyH54Inyzk7IYrRr0LOsUZJakB1NDPn4DEivTpC881n+siUOo3ksPCPjBwQaHB/mIPCCR6ACKcDyKbLGXtrpfVM7F2dMTM12fI0jkQBkHXBIgxdXgCQGGQDRI6+X2Qz4wzPsuXXFGZnj9kQNIZGMgAXUwkhpI9xeADnnrd4rdpxyD6tRlcpXlCEiKsA+JRdBHi+amaIm8RLwWuVL+tC0wj8cf7ThyVpEzKr8OxYM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/30/26 08:27, Michael S. Tsirkin wrote:
> On Tue, Jun 30, 2026 at 08:17:42AM +0200, David Hildenbrand (Arm) wrote:
>> On 6/30/26 01:34, Michael S. Tsirkin wrote:
>>>
>>> Wait a sec, what about call_rcu_tasks? Use that and re-check the bit is
>>> still set?
>>
>> So, in essence the idea I had yestarday when it was late was the following:
>>
>> Assume we
>>
>> 1) Can have a way to guarantee that a function on a CPU cannot execute within
>> our critical section (while updating the flags)
>>
>> 2) We can request to execute a function on each CPU and wait for completion
>>
>> I think we could just let each CPU execute our desired action (e.g., try setting
>> the bit).
>>
>> E.g.,
>>
>> 	local_irq_save(flags);
>> 	page->flags &= whatever;
>> 	local_irq_restore(flags);
>>
>> And assume we want to set the bit, do a
>>
>> 	SetPageHWPoison(page);
>> 	smp_call_function(set_hwpoison_smp_sync, page, 1);
>>
>> whereby
>>
>> 	static void set_hwpoison_smp_sync(void *info)
>> 	{
>> 		SetPageHWPoison(page);
>> 	}
>>
>>
>> The idea is (that needs double checking) that a CPU will execute the
>> SetPageHWPoison() either before the local_irq_save() or after the
>> local_irq_restore(). So it's own non-atomic update cannot get interrupted.
>>
>> Now, IIUC when it comes to "how expensive is this" I think we have (cheap to
>> expensive):
>>
>> 1) preempt_disable()
>> 2) rcu_read_lock()
>> 3) local_irq_save()
>>
>>
>> So the above wouldn't be better than an rcu-based approach we have right now.
>> We'd need something that relies on disabled preemption only.
>>
>> Huh, but I read that "anything that disables preemption also marks an RCU-sched
>> read-side critical section including preempt_disable() and preempt_enable()".
>>
>> So for our use case we should be able to use preempt_disable() instead of
>> local_irq_save(). That should already work for your existing implementation.
>>
>> -- 
>> Cheers,
>>
>> David
> 
> We have:
> 
> #else /* #ifdef CONFIG_PREEMPT_RCU */
> 
> 
> static inline void __rcu_read_lock(void)
> {
>         preempt_disable();
> }
> 
> ...
> 
> 
> static __always_inline void rcu_read_lock(void)
>         __acquires_shared(RCU)
> {
>         __rcu_read_lock();
>         __acquire_shared(RCU);
>         rcu_lock_acquire(&rcu_lock_map);
>         RCU_LOCKDEP_WARN(!rcu_is_watching(),
>                          "rcu_read_lock() used illegally while idle");
> }
> 
> 
> 
> So on non-debug build witout CONFIG_PREEMPT_RCU (what I tested), rcu_lock
> is exactly same as preempt_disable.  It's relatively cheap but not free.
> 
> 
> preempt_disable is not going to be cheaper.

Well, it will be cheaper in the general case (CONFIG_PREEMPT_RCU) :)

But yes, not for this case.

> 
> I can test if you want but it seems clear.
> 

If you measured only !CONFIG_PREEMPT_RCU, then yes, it won't change a thing for
that scenario.

> 
> But IIUC task rcu might be cheaper - IIUC it does not need rcu
> lock/unlock at all, it relies on readers to invoke the scheduler
> instead.
> No?

I thought that still requires protection of sorts (preempt_disable /
rcu_read_lock), because it might fire whenever the task is preempted?

-- 
Cheers,

David

