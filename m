Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59468CA1013
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 22:42:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5E7A8E000B; Fri,  5 Sep 2025 18:42:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EB58E0001; Fri,  5 Sep 2025 18:42:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FD3A8E000B; Fri,  5 Sep 2025 18:42:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 89BAD8E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 18:42:42 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4CE391A01C0
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:42:42 +0000 (UTC)
X-FDA: 83856672564.26.81EE584
Received: from mailrelay-egress16.pub.mailoutpod3-cph3.one.com (mailrelay-egress16.pub.mailoutpod3-cph3.one.com [46.30.212.3])
	by imf20.hostedemail.com (Postfix) with ESMTP id 60B9D1C000F
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 22:42:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=AcOYyFpS;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=fBG6Tw91
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757112160; a=rsa-sha256;
	cv=none;
	b=h/9Jo9IjXecs+c6cTUB0C5ISu3osuVGU/SpF+K3cg5k371Mse+3Pjt4FP53FQstEAwpt6T
	D+raVlCHL/yG6FtEjpXfHk8PGkwS/58Stc8AxiH+m4HgkNWS2O6QL6OYwsAVuoy1TMrhAP
	8b8hwaaXC2pl0GUVFoESvcuCJrMqLjg=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=konsulko.se header.s=rsa2 header.b=AcOYyFpS;
	dkim=pass header.d=konsulko.se header.s=ed2 header.b=fBG6Tw91;
	spf=none (imf20.hostedemail.com: domain of vitaly.wool@konsulko.se has no SPF policy when checking 46.30.212.3) smtp.mailfrom=vitaly.wool@konsulko.se;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757112160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9xMrpEXG0h9LXCdOySlqpPGWgrvgr6XLD10hQV2w4U=;
	b=xocrYcdtzpta3ocP8er/UpJFmS1z0fGFZzELmLC8m2tTVUvn80smA4cNYTil6C59tSq67+
	S8XVHG0rZPbtNXPoPQJ6S3Wxpy1Gn8bQENfZ2i6qkM9GOYdz0K8XlkDobt/6sgYCxBsGwO
	1u60GUdUXwgTkwaDNyY3JERtqDfG/mQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1757112158; x=1757716958;
	d=konsulko.se; s=rsa2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=f9xMrpEXG0h9LXCdOySlqpPGWgrvgr6XLD10hQV2w4U=;
	b=AcOYyFpSqfd3i8NYCVDRlxQwgRXmJmcsMZylw44CDfROKVAycnd7vV2xLCeheeHf6D+dLbbu0VuKj
	 K5qN48/5eQGhsR+vUy2yjt5d3CtTufZgjwBnaKvGpE7eQqLiBfzZccjN3dZXoy/j1GFiT6mjlVU2HF
	 K4cU8Y1FcxS3jCAzYwOsDXSBRONF5vorWZIV/u0+nxrYAx1miVJer+V6d9WHEg4F1kHUl66ph6O3mR
	 xNCGe5BVPMcYu6fA0k/EJOWLyuNQ/6isbWPmR7f0DVjdnly9qJyTuzOy87KBlx2Z+4TvdcGEbtF02k
	 WV5j6/6KsK7U/0412oFVUpvqdxC0n9w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; t=1757112158; x=1757716958;
	d=konsulko.se; s=ed2;
	h=content-transfer-encoding:content-type:in-reply-to:from:references:cc:to:
	 subject:mime-version:date:message-id:from;
	bh=f9xMrpEXG0h9LXCdOySlqpPGWgrvgr6XLD10hQV2w4U=;
	b=fBG6Tw91cRm24RdKubzQerR3NsieKINFD80GO4gPES8NMAHFwCpexPqdgABDfvKYMxalUCEMgFJv/
	 6mQJrgNDg==
X-HalOne-ID: 9e70b073-8aa9-11f0-90da-4f541c8bf1cc
Received: from [192.168.10.245] (host-95-203-16-218.mobileonline.telia.com [95.203.16.218])
	by mailrelay3.pub.mailoutpod2-cph3.one.com (Halon) with ESMTPSA
	id 9e70b073-8aa9-11f0-90da-4f541c8bf1cc;
	Fri, 05 Sep 2025 22:42:37 +0000 (UTC)
Message-ID: <5f6a8336-3d0e-4fa4-8fc9-08f59f462eac@konsulko.se>
Date: Sat, 6 Sep 2025 00:42:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: remove zpool
To: Nhat Pham <nphamcs@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, hannes@cmpxchg.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Hellwig <hch@infradead.org>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250904093325.2768507-1-vitaly.wool@konsulko.se>
 <7b1ca42d-1b89-44f4-bffb-e6b09f86fdc5@suse.cz>
 <1d42c513-cc83-4f08-a10c-cbd6206070f4@konsulko.se>
 <CAKEwX=MMNSg-QdA2XdBpzhi_d-o9Pv4OOPR5nqrvUVWRdnnpLA@mail.gmail.com>
Content-Language: en-US
From: Vitaly Wool <vitaly.wool@konsulko.se>
In-Reply-To: <CAKEwX=MMNSg-QdA2XdBpzhi_d-o9Pv4OOPR5nqrvUVWRdnnpLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 60B9D1C000F
X-Stat-Signature: bftranp5s653etrz38g5e6tsui4386q8
X-Rspam-User: 
X-HE-Tag: 1757112160-328020
X-HE-Meta: U2FsdGVkX1/fLBPnig+Lt4U+Qf0jpVulrtLAzYTzR56KTucYi90MA1waZ1qW1WuJneuD1RGded7A3NDprqk8wzbTQciK5/eWOOG/Iyqa0rJRCaSPrld0hI/m8nHbWH2z1pounVdXCKEwOyZn9eWhBQaPVlBQWxsaNAeoPW89k9QFh8Hzcxt9k68fF++6rvZzoS4kFAd3m3U2NvU2lXWXZje1snXb5uBI+Yh3oWf30uZRtWWVN4isZ+Y5tfpcBEBLWdDJ/8AVsd7aAKg75FN1WhVMqwQfZh/lfCKZhUv+fFVUU80scp9JNfW5ov230rQ9hzTlAJT7c5HhC+IWPJ1J6Z/EhABGULl0VMyYyZXVHtvvKE5VP/6zkLkdPvyJKeT/8VvaWPO6YfO0zLTz00R7hH8yuaxAa2sLVK78l546fpA9671QJ8Z8yxjM5amSp4BsoPlg6ZUNGifj8oNZGM6dctIpv45meHqdRfpga3TX8h7PxkBElU2JrZYmy/2p+g6pYx04rD1yBstUq6T42EW43r/cy3AUkguGuMjtId7b8dSQBW1nlfs4iQGlg2gYpVRGoiFB35hXrMh30DQzUX9RWgrA3ilHHY++B/qByFJfG2BSyaymMdg3DPkN4AZnX+te29VW8PM2DMbqYSLygzwFZDVjhOwUjrC6W94CE4WRGxNygmONbci75gV8PJHwak/ccKuiPwhF1XvcLbVCR4+XqNc/geFhDFaq52O4RUXS4iKq9kno+229YFk30+LOWmfdj3azRCgy+4oe04YnyQPrd/iZarmZzhY0SgVCZPLS6NVU0b3ruqTMSMl+BNoQ5EbbsH5PFk3McN4vz7ZeG2CyrmFuUSduZ2UMoGJ1pcT9y1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/5/25 20:02, Nhat Pham wrote:
> On Thu, Sep 4, 2025 at 4:49 PM Vitaly Wool <vitaly.wool@konsulko.se> wrote:
>>
>>
>>
>> On 9/4/25 12:13, Vlastimil Babka wrote:
>>> On 9/4/25 11:33, Vitaly Wool wrote:
>>>>> With zswap using zsmalloc directly, there are no more in-tree users of
>>>>> this code. Remove it.
>>>>>
>>>>> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
>>>>
>>>> Per the previous discussions, this gets a *NACK* from my side. There is
>>>> hardly anything _technical_ preventing new in-tree users of zpool API.
>>>> zpool API is neutral and well-defined, I don’t see *any* good reason for
>>>> it to be phased out.
>>>
>>> AFAIK it's a policy that unused code should be removed ASAP. And that's the
>>> case for zpool after Patch 1, no? It could be different if another user was
>>> about to be merged (to avoid unnecessary churn), but that doesn't seem the
>>> case for zblock?
>>
>> For the C implementation of zblock, no. But there's another
>> implementation which is in Rust and it's nearing the submission.
>>
>>> My concern would be if the removal breaks any existing installations relying
>>> on zswap. Presumably not as a make oldconfig will produce a config where
>>> nothing important is missing, and existing boot options such as
>>> "zswap.zpool=" or attempts to write to in the init scripts to
>>> "/sys/module/zswap/parameters/zpool" will cause some errors/noise but not
>>> prevent booting correctly?
>>
>> I don't expect heavy breakage but misconfigurations will definitely occur.
>>> I mean if we were paranoid and anticipated somebody would break their
>>> booting if writing to /sys/module/zswap/parameters/zpool failed, we could
>>> keep the file (for a while) and just produce a warning in dmesg that it's
>>> deprecated and does nothing?
>>>
>>>   From Patch 1:
>>>
>>>> Note that this does not preclude future improvements and experiments
>>>> with different allocation strategies. Should it become necessary, it's
>>>> possible to provide an alternate implementation for the zsmalloc API,
>>>> selectable at compile time. However, zsmalloc is also rather mature
>>>> and feature rich, with years of widespread production exposure; it's
>>>> encouraged to make incremental improvements rather than fork it.
>>>
>>> With my history of maintaining the slab allocators I can only support this
>>> approach.
>>
>> There was the time when slab was the best option and it was more mature
>> than slub, which is now the best and only option. Thus, the "maturity"
>> point is indeed valid but not being backed by anything else it doesn't
>> weigh too much. Besides, zsmalloc's production exposure from all I know
>> is limited to the 4K page case, and zsmalloc is truly struggling when
>> the system is configured for 16K pages.
> 
> That doesn't sound unfixable, if I recall our conversation correctly.
> Perhaps all of this effort is better off being spent fixing zsmalloc's
> inefficiencies :)

Well, there are 2 main issues with zsmalloc on bigger pages as I see it:
1) the granularity in allocations goes down due to the limited number of 
zsmalloc classes
2) the idea that an object can span 2 pages on a large page system turns 
out to be costly and inefficient.

And if you think about solving these problems you end up with something 
zblock like.

>>
>> Things keep changing, and some of the proven solutions may not be a good
>> fit moving forward. While not suggesting that we should have a handful
>> of zpool backends just for the sake of variety, I'd like to emphasize
>> that there are good reasons to have zblock (especially the Rust one),
>> and there are good reasons to keep zsmalloc. That leads to the
>> conclusion that zpool should stay.
> 
> IMHO, the needs for multiple allocators do not necessitate the zpool API.
> 
> The zpool API is only needed if you want to switch the allocators
> arbitrarily at runtime. This one is a much harder sell.
> 
> We can always add zblock, and select the backend via build options.
> Overtime, as zsmalloc improves to acquire zblock's advances, or zblock
> implements the missing features (migratability, compaction, etc.), we
> can unify/remove one of them.

I think migratability is no longer an issue. Compaction will be added 
along the way but it isn't a crucial feature for zblock because its 
fragmentation is harmless in the sense that temporarily empty slots act 
like a cache as opposed to being an unusable free space.

Best regards,
Vitaly


