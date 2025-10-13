Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24F87CCD18D
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 14:31:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7F2198E0043; Mon, 13 Oct 2025 10:31:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9958E0017; Mon, 13 Oct 2025 10:31:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 706CE8E0043; Mon, 13 Oct 2025 10:31:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5C7BD8E0017
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 10:31:02 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F4208C046A
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:31:01 +0000 (UTC)
X-FDA: 83993327964.18.BC27DE2
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7DFD61A0010
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 14:30:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=zjZ2hhR6;
	spf=pass (imf19.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760365860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+zeKz23GcC8G0cCKClcwBTlkpCur/puh9HJz5dxq7g=;
	b=r/7FjxUdI7nRmuc/0UKqQrkhNVz3b8S4RgCiWkFkXDHcwzFq37dWVqkLKbWb7J8uzSQJIu
	JtsEm1CalkN4uQy53mfvITnLzleM4oUg7HxF5gkhd2qbklHTc62OZOjnCK1vz4fkXw5NLZ
	vvWrOuYFr6I70UWP4a56iNJBpq8Dv50=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=zjZ2hhR6;
	spf=pass (imf19.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com;
	dmarc=pass (policy=quarantine) header.from=cdn77.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760365860; a=rsa-sha256;
	cv=none;
	b=1TRJl14Sypm+eJq2FHpHV89VNADIRQbdLDIXJMPCII9DLKrsg1lVdcGI6mx3aeejvUSRvw
	ElE//rxlFVMVw4zlNHM/o9yVR/YbBfBoogbF6clKIgDNEyhI2dTr2Y/1NT1GWemPYdVEOm
	gulEw55SWo4c0A+GG2bRtfOk1+Urtgc=
DKIM-Signature: a=rsa-sha256; t=1760365855; x=1760970655; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=4+zeKz23GcC8G0cCKClcwBTlkpCur/puh9HJz5dxq7g=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=zjZ2hhR6nzhJIj2WKDmpSgSXTHEddDcN9agWH15DleRsMmw6CBfQSvFskrFwOGXZitXcohfNavuDdRvLRPYzNg15iEen5oJ5V2nnrCDtTsOnd/Kk7H6O7xxGjfBNaR/4493s4wOU7SZ7jnaRDl5pZZaBX0xcpsBjCqkBZEKYn2E=
Received: from [10.26.3.35] ([80.250.18.198])
        by mail.sh.cz (14.1.0 build 17 ) with ASMTP (SSL) id 202510131630537100;
        Mon, 13 Oct 2025 16:30:53 +0200
Message-ID: <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com>
Date: Mon, 13 Oct 2025 16:30:53 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
To: Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
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
 <875xcn526v.fsf@linux.dev>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <875xcn526v.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A2D030A.68ED0D1E.004D,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Stat-Signature: epmg7yqsmng6ozdd8ciihtq9eeqajsha
X-Rspamd-Queue-Id: 7DFD61A0010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760365859-752217
X-HE-Meta: U2FsdGVkX19uGkBA3al1stUDeTr8s3OoltkByo2/XUv4cHtyMKMpIjNxvI9ZeM+kmAQK+KtTbf7X9gAfQejqxNdcuMjSHOtADV/9JzuyDz2aA86RnvkSiqCHUNpoBY3GJw7fFTvM5rNUUY+9lLIrdN5ALxP9v7SQuJ1DZbv/RrYwa6vklY7U+DIG2lotStWDhvaUrKyLFKNiHVRmrnOGsfjLgZpS6PrA3dZZFLP90hbhtbpwOejmHaiwT/qePyhWFWPMe7tAeXzOa/wKzLzGXQuYdBQFglqvEYNj5HeRCLT1OyGidfB6bPmRxSFWexitCxRua4Ddxr7cVSwJGZM2x5W/W0xN2pE9z+drCNssVa2e8nNyaZpcvw/550lmSj3GC/Pd5Qau0wZO38bM+UDZAqIt4hhurFLkC/cpXpAPFW5ZN2j4qhCSEsr1yjtTKj4RzKyr7+YAS9AvpXQKnFu9Y/kxkkDwDP1+U+KPmZKMgOxquD1GqfmbCFESHE4yDhWdkCirV0SZAnT2WFD/WYHEAvZN4cyY0zollSrzLxnpI3Q4hEYH65i7wuzSilv3Mj3HAaWaplZLD4Ih5pwc7Hd15PjKeR8AK9X27dZRh7B+PT7h4COY1rwh0unZvpLh2GXPiZv/+GYqIGsOcSz5FBuxoMfCOML0l6aZjmoguERiwHJ4bMMmjNiaotJf5mdokHB9+61QLHf72wQKSVNQR9XzkvUzr4rWUB34nn5dsfBGu/pumAx+G1U8wmbPN4l5hc+NcvkBQZLjondFjIwwKTXKFAfoVLHVKS4SsSqR9dRWxLdEOkj8KsMuYXiwEpVWmV/4P+J9uQTrWCbbTDodmYdOL9ZWNrFTr6XsfmU/im/ZJSO04qIJWq0EFXKVauAs8j4GWUVEyZTQOXmFxr+sLim13+sX5vx6FxE6lw8d1UTKuCJewWBRJi9prQjKUNQmHzDwbIqVZ/QPwicwJAFb7jn
 cVOajSf7
 Swd8GWbgACjv5/5k39aZEe7M4T0BNN/c7KnNHmY5u/H1TPYzV6kerEqF2DbiuIv5SfKdlSxpLdvOyIK06CE5cJ0MQYZbAgoVxHEnNnkIqhZzqm16jQmWmO5Bww/FZAz0Ag6s8gqKHS+zmd0hTruMgFLKUa1Pf7diZ0QiK/d6COqe1JunyjpkRfaUvAix5AkknAvMdX5KKJQqfiWNzz6Y45Ahw+CaSyAVEqektib2LbGyPOBOI0Gjh+kkM3Z9JIo3GY+ut34TmNKcmcR7ylraA4pDWt9yTddxYlbdWbaMxYT+nGPEW232QwcTmX1PImGytzkz7K3PdxyUJ/Pc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/9/25 9:02 PM, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
>> On Thu, Oct 09, 2025 at 10:58:51AM -0700, Roman Gushchin wrote:
>>> Shakeel Butt <shakeel.butt@linux.dev> writes:
>>>
>>>> On Thu, Oct 09, 2025 at 08:32:27AM -0700, Roman Gushchin wrote:
>>>>> Daniel Sedlak <daniel.sedlak@cdn77.com> writes:
>>>>>
>>>>>> Hi Roman,
>>>>>>
>>>>>> On 10/8/25 8:58 PM, Roman Gushchin wrote:
>>>>>>>> This patch exposes a new file for each cgroup in sysfs which is a
>>>>>>>> read-only single value file showing how many microseconds this cgroup
>>>>>>>> contributed to throttling the throughput of network sockets. The file is
>>>>>>>> accessible in the following path.
>>>>>>>>
>>>>>>>>     /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
>>>>>>> Hi Daniel!
>>>>>>> How this value is going to be used? In other words, do you need an
>>>>>>> exact number or something like memory.events::net_throttled would be
>>>>>>> enough for your case?
>>>>>>
>>>>>> Just incrementing a counter each time the vmpressure() happens IMO
>>>>>> provides bad semantics of what is actually happening, because it can
>>>>>> hide important details, mainly the _time_ for how long the network
>>>>>> traffic was slowed down.
>>>>>>
>>>>>> For example, when memory.events::net_throttled=1000, it can mean that
>>>>>> the network was slowed down for 1 second or 1000 seconds or something
>>>>>> between, and the memory.net.throttled_usec proposed by this patch
>>>>>> disambiguates it.
>>>>>>
>>>>>> In addition, v1/v2 of this series started that way, then from v3 we
>>>>>> rewrote it to calculate the duration instead, which proved to be
>>>>>> better information for debugging, as it is easier to understand
>>>>>> implications.
>>>>>
>>>>> But how are you planning to use this information? Is this just
>>>>> "networking is under pressure for non-trivial amount of time ->
>>>>> raise the memcg limit" or something more complicated?

We plan to use it mostly for observability purposes and to better 
understand which traffic patterns affect the socket pressure the most 
(so we can try to fix/delay/improve it). We do not know how commonly 
this issue appears in other deployments, but in our deployment, many of 
servers were affected by this slowdown, which varied in terms of 
hardware and software configuration. Currently, it is very hard to 
detect if the socket is under pressure without using tools like 
bpftrace, so we would like to expose this metric in a more accessible 
way. So in the end, we do not really care in which file this "socket 
pressure happened" notification will be stored.
>>>>> I totally get it from the debugging perspective, but not sure about
>>>>> usefulness of it as a permanent metric. This is why I'm asking if there
>>>>> are lighter alternatives, e.g. memory.events or maybe even tracepoints.

If the combination of memory.events(.local) and tracepoint hook(s) is 
okay with you(?), we can use that and export the same information as in 
the current patch version. We can incorporate that into the next version.

Also, would it be possible to make the socket pressure signal 
configurable, e.g., allowing it to be configured via sysctl or per 
cgroup not to trigger the socket pressure signal? I cannot find the 
reasoning why this throttling cannot (maybe it can) be opt-out.
>>>> I also have a very similar opinion that if we expose the current
>>>> implementation detail through a stable interface, we might get stuck
>>>> with this implementation and I want to change this in future.
>>>>
>>>> Coming back to what information should we expose that will be helpful
>>>> for Daniel & Matyas and will be beneficial in general. After giving some
>>>> thought, I think the time "network was slowed down" or more specifically
>>>> time window when mem_cgroup_sk_under_memory_pressure() returns true
>>>> might not be that useful without the actual network activity. Basically
>>>> if no one is calling mem_cgroup_sk_under_memory_pressure() and doing
>>>> some actions, the time window is not that useful.
>>>>
>>>> How about we track the actions taken by the callers of
>>>> mem_cgroup_sk_under_memory_pressure()? Basically if network stack
>>>> reduces the buffer size or whatever the other actions it may take when
>>>> mem_cgroup_sk_under_memory_pressure() returns, tracking those actions
>>>> is what I think is needed here, at least for the debugging use-case.

I am not against it, but I feel that conveying those tracked actions (or 
how to represent them) to the user will be much harder. Are there 
already existing APIs to push this information to the user?

Thanks!
Daniel.


