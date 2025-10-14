Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0217CCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 13:58:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07C038E0127; Tue, 14 Oct 2025 09:58:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02C2D8E0123; Tue, 14 Oct 2025 09:58:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84758E0127; Tue, 14 Oct 2025 09:58:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D49D88E0123
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 09:58:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D9DC13BF30
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:58:22 +0000 (UTC)
X-FDA: 83996874444.22.D309281
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6D30040005
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:58:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=z5X+UJP7;
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf01.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760450301;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DPbeUy3W/9rBcRrgYSjHO9WvnXLnpPKdc9WYHVyaao0=;
	b=zhe//Y7PH2qXOyVui1F+K7czefG1DInmED8geVyf20ojWN2wOZg4YEvD2iX7414e1s87tX
	UrFhaTjPjV+Xhn8wL3JQu5jTD6TbPk501tMnMlmQmX6caYHKWVNEReXZDOpeFdMk0ovtqV
	vN/OJaMjxRt0pHW/WJbUDFMmYnZyPBM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760450301; a=rsa-sha256;
	cv=none;
	b=6Xuyx1dtHEyTuAXoVeJCdvcPZJTyb0fKUzHvRTvHvWUAKP/sazPYZJIupAvHcC2HMC/kB4
	DCbHRhMITtomHArqwNwgmks5m0O5npa1ZIoZXmtlo4Jp+QPiSt6Iup3ZKCrobaXXRHy8fi
	ohkn7CHZqUMSPQT4PmNlsU/ISdSTHH0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=z5X+UJP7;
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf01.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
DKIM-Signature: a=rsa-sha256; t=1760450299; x=1761055099; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=DPbeUy3W/9rBcRrgYSjHO9WvnXLnpPKdc9WYHVyaao0=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=z5X+UJP7KNYEOVYguIFQVOx04anzOqXAPzZKMMaBJHfVc41kWbvnVrOlSN9tasPg/gAWsonoKN2zj2a/ChsC/BTcEw68j68B4gSG3WA3tM9qhYpcIuwSB3O59MEbDyuM8GIckxgEyfDqCiMUfx6eXokXxP23Y5Za9BT9wLc2wZY=
Received: from [10.0.5.28] ([95.168.203.222])
        by mail.sh.cz (14.1.0 build 17 ) with ASMTP (SSL) id 202510141558173878;
        Tue, 14 Oct 2025 15:58:17 +0200
Message-ID: <58c7b900-6152-4b17-9308-ed971f6a1f9a@cdn77.com>
Date: Tue, 14 Oct 2025 15:58:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
 Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>,
 David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org,
 netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>,
 =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>,
 Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <87qzvdqkyh.fsf@linux.dev> <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev>
 <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
 <87a5205544.fsf@linux.dev>
 <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
 <875xcn526v.fsf@linux.dev> <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
 <87h5w2w94e.fsf@linux.dev>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <87h5w2w94e.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A2D030E.68EE56FA.0022,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspamd-Server: rspam01
X-Stat-Signature: 9xkpheptdf184e9461qym7nbk5ozf98s
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D30040005
X-HE-Tag: 1760450300-364906
X-HE-Meta: U2FsdGVkX192F0j/uZ2ODtkVaKVhfBj7aSVYQvNCvm8QnQQqlk9IbMZtDMA+l4GYFSxtJ3x62CsVURm75mOdC3/pXPnDcRCwf+XhjqTUGIXT62OAOONNfvqAwUPLXGKCPA7JjcAiP4A5aRzb9DMrn/JAza+Ja0xBsXJF+cwA4d6l14qc/ev1Lc+pmnk/TlRk/3IKQL+u0+Cf1wIyRJNq6v1bwA4wqw5jimteAJGqaP/AzkT+Y+0wCjv4/JKfA5ntrHGNHL7a1f++B1qQGuhA8UKNo0uElxQNj0pE3JWWQchk9E/fDGdgoL/4ekIfKtNgy1yJBOR0J0TyRONabuEERBcx7EUZYEksCUTx36FtAjjKUZiTLkNJiaxRF1+BwA9qXNlq9Y85IvfWHEl55sFvxyhGqmqYeCuMshjYwFmxlRxd05lVl5HobgEfAy5JrWrWEgRlVJSzrub5FMc7NYIXqED76tSxZU3Zr2kUik4GD2mlHMTDsBucn0FYoLo6w9sqlMuvwO908Ziv7T8oLfDlPweUad0LgnQeuXkA66Mo0guvawMepTF5iATwdF3jNhxE4gu/M8KfFUzIvzc/4qIMI7/Q/iKyqsZhILvBHLcupYPOaoLRK/HiWxMJGSCo/NJQVoIt6Bhb3duPyAvGaCA2F1yM3pgxcpinoYCpx6IkKQAH6rHrqgzQA2Zy7smgIEsogZYTjplC1emG/Zsnr1aHmkh6o0pMyLu9ewOXOw4UVoHJGEeASBeL5r2HHLP8j7I0fh0zXMASNhBlYvf10fxvRUeUepSoQt4H8rqJmqqzv9LrCA3Rcry9pikqtQ9isgrBwhzJTHI4SuremyuhYa706k4gGgT3b9f+CcplsCx3uCdQ902Mtp86iVlV/XZ4UUooHETNkwAUN6U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/14/25 3:43 AM, Roman Gushchin wrote:
> Daniel Sedlak <daniel.sedlak@cdn77.com> writes:
> 
>> On 10/9/25 9:02 PM, Roman Gushchin wrote:
>>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>>>
>>>> On Thu, Oct 09, 2025 at 10:58:51AM -0700, Roman Gushchin wrote:
>>>>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>>>>>
>>>>>> On Thu, Oct 09, 2025 at 08:32:27AM -0700, Roman Gushchin wrote:
>>>>>>> Daniel Sedlak <daniel.sedlak@cdn77.com> writes:
>>>>>>>
>>>>>>>> Hi Roman,
>>>>>>>>
>>>>>>>> On 10/8/25 8:58 PM, Roman Gushchin wrote:
>>>>>>>>>> This patch exposes a new file for each cgroup in sysfs which is a
>>>>>>>>>> read-only single value file showing how many microseconds this cgroup
>>>>>>>>>> contributed to throttling the throughput of network sockets. The file is
>>>>>>>>>> accessible in the following path.
>>>>>>>>>>
>>>>>>>>>>      /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
>>>>>>>>> Hi Daniel!
>>>>>>>>> How this value is going to be used? In other words, do you need an
>>>>>>>>> exact number or something like memory.events::net_throttled would be
>>>>>>>>> enough for your case?
>>>>>>>>
>>>>>>>> Just incrementing a counter each time the vmpressure() happens IMO
>>>>>>>> provides bad semantics of what is actually happening, because it can
>>>>>>>> hide important details, mainly the _time_ for how long the network
>>>>>>>> traffic was slowed down.
>>>>>>>>
>>>>>>>> For example, when memory.events::net_throttled=1000, it can mean that
>>>>>>>> the network was slowed down for 1 second or 1000 seconds or something
>>>>>>>> between, and the memory.net.throttled_usec proposed by this patch
>>>>>>>> disambiguates it.
>>>>>>>>
>>>>>>>> In addition, v1/v2 of this series started that way, then from v3 we
>>>>>>>> rewrote it to calculate the duration instead, which proved to be
>>>>>>>> better information for debugging, as it is easier to understand
>>>>>>>> implications.
>>>>>>>
>>>>>>> But how are you planning to use this information? Is this just
>>>>>>> "networking is under pressure for non-trivial amount of time ->
>>>>>>> raise the memcg limit" or something more complicated?
>>
>> We plan to use it mostly for observability purposes and to better
>> understand which traffic patterns affect the socket pressure the most
>> (so we can try to fix/delay/improve it). We do not know how commonly
>> this issue appears in other deployments, but in our deployment, many
>> of servers were affected by this slowdown, which varied in terms of
>> hardware and software configuration. Currently, it is very hard to
>> detect if the socket is under pressure without using tools like
>> bpftrace, so we would like to expose this metric in a more accessible
>> way. So in the end, we do not really care in which file this "socket
>> pressure happened" notification will be stored.
>>>>>>> I totally get it from the debugging perspective, but not sure about
>>>>>>> usefulness of it as a permanent metric. This is why I'm asking if there
>>>>>>> are lighter alternatives, e.g. memory.events or maybe even tracepoints.
>>
>> If the combination of memory.events(.local) and tracepoint hook(s) is
>> okay with you(?), we can use that and export the same information as
>> in the current patch version. We can incorporate that into the next
>> version.
> 
> In my opinion
> tracepoint > memory.events entry > memory.stat entry > new cgroupfs file.

Thanks, noted, we will incorporate it to the next version.
>> Also, would it be possible to make the socket pressure signal
>> configurable, e.g., allowing it to be configured via sysctl or per
>> cgroup not to trigger the socket pressure signal? I cannot find the
>> reasoning why this throttling cannot (maybe it can) be opt-out.
> 
> It's a good point.
> 
> First, I think that vmpressure implementation is not the best
> and we might want to switch to PSI (or something else) there.
> This is why I'm resistant to exposing implementation-specific
> metrics.
> 
> That said, I believe that some level of customization here is justified.
> Maybe opting out completely is too much, but in the end it's hard for
> the kernel to balance the importance of e.g. page cache vs networking
> buffers as it might be really workload-dependent. Or some workloads
> would prefer to risk being oom-killed rather than to tolerate a sub-par
> networking performance.

As of now, socket pressure throttling can be disabled by moving 
processes, causing the pressure, into the root cgroup. So we would 
definitely benefit from disabling it more idiomatically.

This bpftrace output is captured from a production server using nginx 
proxy (the left-most column is a timestamp in nanoseconds) which we use 
as a HTTP cache. As you can see, it fluctuates a lot.

26920285712831843, unified:/system.slice/nginx.service, scanned: 556, 
reclaimed: 146, pressure: 73
26920285731493743, unified:/system.slice/nginx.service, scanned: 22886, 
reclaimed: 13606, pressure: 40
26920285779559500, unified:/system.slice/nginx.service, scanned: 21775, 
reclaimed: 11525, pressure: 47
26920285784845147, unified:/system.slice/nginx.service, scanned: 698, 
reclaimed: 522, pressure: 25
26920285833808666, unified:/system.slice/nginx.service, scanned: 740, 
reclaimed: 232, pressure: 68
26920285835668081, unified:/system.slice/nginx.service, scanned: 1475, 
reclaimed: 1224, pressure: 17
26920285838877445, unified:/system.slice/nginx.service, scanned: 2919, 
reclaimed: 2334, pressure: 20
26920285854811898, unified:/system.slice/nginx.service, scanned: 11586, 
reclaimed: 7666, pressure: 33
26920285873634643, unified:/system.slice/nginx.service, scanned: 22898, 
reclaimed: 13387, pressure: 41
26920285899176135, unified:/system.slice/nginx.service, scanned: 10957, 
reclaimed: 7077, pressure: 35
26920285901529378, unified:/system.slice/nginx.service, scanned: 587, 
reclaimed: 156, pressure: 73
26920286020702357, unified:/system.slice/nginx.service, scanned: 563, 
reclaimed: 87, pressure: 84
26920286037434038, unified:/system.slice/nginx.service, scanned: 22072, 
reclaimed: 14161, pressure: 35
26920285789562313, unified:/system.slice/nginx.service, scanned: 2810, 
reclaimed: 1696, pressure: 39
26920285879597883, unified:/system.slice/nginx.service, scanned: 693, 
reclaimed: 625, pressure: 9
26920285884686863, unified:/system.slice/nginx.service, scanned: 2768, 
reclaimed: 2284, pressure: 17

We believe that the issue originates from suboptimally chosen constants, 
as seen in [1]. Currently, the vmpressure triggers when it cannot 
reclaim a few MiB of memory on a server that has over 500 GiB of memory.

Link: 
https://elixir.bootlin.com/linux/v6.17.1/source/mm/vmpressure.c#L38 [1]

We would like to work on that more after this patch to try to find a 
better constant or at least make it _more configurable_ if that makes 
sense for you.

Thanks!
Daniel


