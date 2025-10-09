Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E4FCCCD185
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 14:44:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B218A8E0035; Thu,  9 Oct 2025 10:44:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD11A8E001A; Thu,  9 Oct 2025 10:44:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C0118E0035; Thu,  9 Oct 2025 10:44:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 881BE8E001A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 10:44:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 54A005BD1A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:44:10 +0000 (UTC)
X-FDA: 83978845860.09.05D83AF
Received: from mail-internal.sh.cz (mail-internal.sh.cz [95.168.196.40])
	by imf04.hostedemail.com (Postfix) with ESMTP id 17B7F40005
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 14:44:07 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=4Sa3zM8D;
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf04.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760021048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ToT0NvhlqFGtmHqtaoOHWloSTlf7psIb/sdAF5TIfxc=;
	b=eGFvXzn0jVARdZ3lJXIzqDoRpFAHoGD4KGyoQo5rWl6bf25n0A2Wr/YXzbPYksYkmTulYf
	2woKBGWUtv0CUtMXJDUcuB1NLu4ueYDxYdqgSx8PZtloKqGK5mt+Yfb/9nFepX8Uf0qBOt
	/gKr1uWr4CSE3XiBQjEiMmc/7QSzoUo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760021048; a=rsa-sha256;
	cv=none;
	b=z0XtPyf7LKbZ2eVDPz/nyTMEbcf+gpvez2Y7o/LeXP/+iphuqGptXo7i9mr/0U78eOw3wF
	jzrnOq1bfDsT3NlCfIgdmizMbzg4Z7owArbWLJsdssOgtHRgmM9krsFUmAlQGwd+heasK9
	n6PKoy+vQSQTZWluGSr97jr4Dpj1iwA=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=cdn77.com header.s=dkim2019 header.b=4Sa3zM8D;
	dmarc=pass (policy=quarantine) header.from=cdn77.com;
	spf=pass (imf04.hostedemail.com: domain of daniel.sedlak@cdn77.com designates 95.168.196.40 as permitted sender) smtp.mailfrom=daniel.sedlak@cdn77.com
DKIM-Signature: a=rsa-sha256; t=1760021046; x=1760625846; s=dkim2019; d=cdn77.com; c=relaxed/relaxed; v=1; bh=ToT0NvhlqFGtmHqtaoOHWloSTlf7psIb/sdAF5TIfxc=; h=From:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:In-Reply-To:References;
   b=4Sa3zM8DcUS5rZ3SLc/w5A+CEPjq7es5HLlbIW2+08+b4NY32YTRJyokfqJFtHcRpGJ6HiIZYCZ16+lP9nsssmpXcE4ZS5JvB23bxUOFfZfAMujFDMIipf9jCXfpedIp3Z+FZQ/4AdsdVi8bwTbVFdKCt0yPZYbgvateGqvTEXs=
Received: from [10.26.3.35] ([80.250.18.198])
        by mail.sh.cz (14.1.0 build 17 ) with ASMTP (SSL) id 202510091644051992;
        Thu, 09 Oct 2025 16:44:05 +0200
Message-ID: <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
Date: Thu, 9 Oct 2025 16:44:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, David Ahern <dsahern@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>,
 linux-mm@kvack.org, netdev@vger.kernel.org,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org,
 Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?=
 <mkoutny@suse.com>, Matyas Hurtik <matyas.hurtik@cdn77.com>
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <87qzvdqkyh.fsf@linux.dev>
Content-Language: en-US
From: Daniel Sedlak <daniel.sedlak@cdn77.com>
In-Reply-To: <87qzvdqkyh.fsf@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-CTCH: RefID="str=0001.0A2D0305.68E7CA35.0040,ss=1,re=0.000,recu=0.000,reip=0.000,cl=1,cld=1,fgs=0"; Spam="Unknown"; VOD="Unknown"
X-Rspam-User: 
X-Rspamd-Queue-Id: 17B7F40005
X-Rspamd-Server: rspam02
X-Stat-Signature: n41p9d49dmkhc5i7nhgp7sa8d7e36dh9
X-HE-Tag: 1760021047-100095
X-HE-Meta: U2FsdGVkX1+3iKPwSMcy3Wdzkp+SEKs52FnrkC6H32CW6EtT5/Ww5MdVfKZFy4kFqCBb59OySE42egPwmrgM4LTuB+0vzPA8skAMFnnwn4whlMyqqpikNi2HnjUsaCHJNgEDDZ9H+wEnrd3HIvsqpCbp7+1dTs/l8BTCoA/RHmd5LBpM+p3Gw/RIa7Thm45ZpKyZUbSty+br4+CS0CLkF9jwqWwgOAl0jk3EESgHe5r8G1AxwwXvT/XAETnf6K97FsD7SIVkoJWl9qOkGUFM8TeSmz9Xl881G21uaF9MjlaCAOt2c6IpFaqYn/SWr8ptk1b1ay8m0YqnUdwTt5HtZuk+Jkri0okyGn6qvKT8eA0EpAnzsh6SbWhCQ15qMXzET6h/TBLWBO/D9F5Ixi0bHjvGhhI083/TsXGyoaz3S5f1cXPkW3h2u/oJNnfYSda0s6UHOCkZLJ7dLuXxPjIngiGOLMLrL53boKtAurYKKQc7FU8wPDkJZ7em7zAYxJG3ZyCp5+oyFxRiNm36wD63rpHGjW3q7r9gyaBOpyqKvnycCaBdqhVvXrD4JC9ZSHGeHhP5mXre+syzOYLIC96L2CCRnefyTUF91U5vh/6NuUQO8CArRwuxRQeuiZDU+1b28VHfR+8a73wiWUSmiFB6By4WCaozqLpkoFFFz2lebQoqZSVugz7AUoKvR0CVv/IQgIfl/Irt5LBIwpzN++qKpPxJIC12qr91tYMGaztAn18Jqhs8A4ZFfDzLVoLl7tVapvant2NVo/frsTBji+FTof8MiH88zsp46wXqv473dtrgoIvxl/yXIkFSkGdUdG1FKezmVcWQWn7LivcPGmCO2/7qtNjHXuJRRVkipovBt9Qj+GaGGNq5vwFrBCE9DPibFKtQ3f99/pEDj6jvgfxgnjNng307aJ/2ALvee7eLKNFDhZDzsixQEqZ3TNAz9ufAYGChr+FRSlg9m/dclIz
 fpnWXzXX
 27zu0IX/VSPWEbYZ/Tz1iVUKJdc3dTfoTvGZyryEZ4KhXdLsdV6f8eRiYkyr3gW9rKH7wRlLr4XSEzvxpbTcaRPYJZYT3ZrPaJwiaH6p7aMJTuhA93hTttRJaeV2wcqrjIYfeBj4V0faTVSWgjgOca+HT85fp2M2f3CH7JNJy0CQ8VLD6F79Asy/OTGD37Aii4OAEWHdPBWK18faASIiznxN27igR0LzMiWo91yRchKosS+skMF6Q/ShIXvIU60CU/eBczkiG43pgTOY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Roman,

On 10/8/25 8:58 PM, Roman Gushchin wrote:
>> This patch exposes a new file for each cgroup in sysfs which is a
>> read-only single value file showing how many microseconds this cgroup
>> contributed to throttling the throughput of network sockets. The file is
>> accessible in the following path.
>>
>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.throttled_usec
> 
> Hi Daniel!
> 
> How this value is going to be used? In other words, do you need an
> exact number or something like memory.events::net_throttled would be
> enough for your case?

Just incrementing a counter each time the vmpressure() happens IMO 
provides bad semantics of what is actually happening, because it can 
hide important details, mainly the _time_ for how long the network 
traffic was slowed down.

For example, when memory.events::net_throttled=1000, it can mean that 
the network was slowed down for 1 second or 1000 seconds or something 
between, and the memory.net.throttled_usec proposed by this patch 
disambiguates it.

In addition, v1/v2 of this series started that way, then from v3 we 
rewrote it to calculate the duration instead, which proved to be better 
information for debugging, as it is easier to understand implications.

Thanks!
Daniel



