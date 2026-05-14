Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7A1ECD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:13:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15E0F6B0088; Thu, 14 May 2026 04:13:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10E806B008A; Thu, 14 May 2026 04:13:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0245E6B008C; Thu, 14 May 2026 04:13:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E50C56B0088
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:13:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8BA9CC1F23
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:13:19 +0000 (UTC)
X-FDA: 84765310518.17.BE02FF0
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E554180006
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:13:17 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JNmisdlw;
	spf=pass (imf06.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746397;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=i0M2iptptb250Psp+ZWNGxv8OhRpj/x6t+2FKnbK4Kg=;
	b=r3hcx7QO48xh20Ms5p0PKFNb7OGGA2Z+j4A7RIlJbZR2uhFQ2CuE8vSIHkTauJicinuw0P
	p8ZL3RJNnQXDp9u4zOjkb+wJ8ytxCrQlItNGbGFeEfH0zpdVhDhyzSRwo4CGZGziRUS0Gk
	bsCbLR0cKFDYlEDcXOCuQkrybvMsJGo=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JNmisdlw;
	spf=pass (imf06.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.177 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746397; a=rsa-sha256;
	cv=none;
	b=0uFy50jVebByPDWXUZqZBM0N0HX7Fm5KgWbu7BiMAsCighg8sgj/YDc5YwPZCRMdLzVIBq
	wrA5NbujXR8u1uHzddN3Tp08qrQahfoswGwjWfhDt3jM6kDFEba6xq7SlTEUJ3Rqmi/O1F
	ImQjQpnMgYpJfzHwvR5jSTstefqEtVE=
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-83975e992e1so3811927b3a.2
        for <linux-mm@kvack.org>; Thu, 14 May 2026 01:13:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778746396; x=1779351196; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i0M2iptptb250Psp+ZWNGxv8OhRpj/x6t+2FKnbK4Kg=;
        b=JNmisdlwaJSBgbqcFftNn+r5c93AV1PqDw4DH0/y5I4TjwaBQIux0ctQwiRO3xlJ1o
         9yAdLdpeb/mAyoFwIpRaFemIKuuNRu6wyLsXKevNqVdqHwkym/USW1LO4pl/hMd9eNlQ
         KvzD5yBICWE1RGmI/cITIkTqJghISYS7VsybycGXAXKbJPj+T97hQNbrTPrr8pWFOATK
         uvM/GK2ZVNWyLSD2R495TMpbVaPjb3HeGoDE1FuJFqfl0Wfv+E1TF3+wtz7YpRiqgjWS
         /fz2rJsdZfhVUht6/+R8c48YvLnGDkPOKnwXJWrhqakNdK9bZcRBHKNvyGZcf4seYTMP
         k67A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778746396; x=1779351196;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=i0M2iptptb250Psp+ZWNGxv8OhRpj/x6t+2FKnbK4Kg=;
        b=JKYkwUnjciKo5lm10xzPeR2/8LrYDl7FVJrx5ctmlK4V9LXDJFZHbDSIk0hQUsaI4R
         xlVDSzV2AOUxTxKA7KGGhoZm5rgtT6mgALt8lnj99/IirULz8mJdHP/1P6nNre5F1o2o
         oz4xRNVpRmL10to5DyxvfwRV/Vy3/QSHzR2RxsWT6d7Zl+z0dgd5e2L6fThxgnvsDelT
         1ZMlMCv3Uq65GkOM0MrxKU/Cgm5SFRtzjyIXawZSEDFUeY+ll9/EMGdJmsL32mBXYVkH
         uTnJ3m2ZOPJxid0SVDXTgfGwfET77aKbLxLBeFzFLCdkMvhfUFsJZn7pNhzd/czmJF2H
         HJVA==
X-Forwarded-Encrypted: i=1; AFNElJ8mY3GOEKrXarv+AtZWaL2aA3/YGMyvCk3WV0ojywiknoZRLhAYIp0vDudgwQ2E+VlFooxBjBjEqA==@kvack.org
X-Gm-Message-State: AOJu0Yy7sF2hqiyYVJEdyS2cV2eldJb4iyQVQnuCBC3iQd/05j7enH+d
	kKQNTr8yjKd+NWfd5J1Gd7tDjAB/U9m8og7dSP83nwAYMOjoTUrFGQ7w
X-Gm-Gg: Acq92OHRyx4juZItQt4B089RguRklMZuztD2XsMS6it4evMBxRIF0kUpNYGO7cVdDH4
	d9c5DuatefF5jwLGWeUSaYnGPADKYOlRGrhwzFkMjMpHfVUWCYIKtny86kOrCVvb+D0bDfWMfj0
	lGmCKawGNNfqvIECZ64dyUGDatJ4ZLxHlSFTNqJoikGXpvlUfAy0LxmRRlPE5Kgdtw/fhsRDBuD
	qtZMFb9HVT/IA7KW7clfZMu46TduwJQGvxyxxu5T41EupXLWhpaP8B0YUzUQ/MT/OnQj0fhMIM+
	CYDHfGRIwIQ9D7WwH9YRtB5SW67u/x0cnv23RfmrB33qb/lwpz+HNVyM9V1IFVhM81HAYMXYtd9
	/m7mallrOk2/XsZYWKZ0FL+woNsARVgQrs/cFN72PzhxKIYBlO8BfR3ApzLJPhFL64Nq9RsCWDb
	P/WsI6ZRohoXsy8WbEW9/CPV6USbufa2t8dx3myjzz20g=
X-Received: by 2002:a05:6a00:4ac8:b0:83a:7565:3505 with SMTP id d2e1a72fcca58-83f03e95beemr7192464b3a.8.1778746395930;
        Thu, 14 May 2026 01:13:15 -0700 (PDT)
Received: from [10.125.192.65] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f19f7cd19sm1845320b3a.54.2026.05.14.01.13.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 01:13:14 -0700 (PDT)
Message-ID: <8fa07929-ed41-b716-c888-0368f883a020@gmail.com>
Date: Thu, 14 May 2026 16:13:03 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>,
 hannes@cmpxchg.org, mhocko@kernel.org, tj@kernel.org
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, mkoutny@suse.com,
 chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev,
 cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>,
 Alexandre Ghiti <alex@ghiti.fr>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com>
 <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
 <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
 <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com>
 <CAKEwX=MOixJAUGiwUcMQa0Stvg-mR-MvpDRD8WA4YMtRvnUYTg@mail.gmail.com>
 <6fc7fdf0-368c-5129-038e-623f9db2aa88@gmail.com>
 <CAO9r8zPvgB-MG2ufmdn4HoS+QEPBAehU9u7fQmYs+47NF-C9aw@mail.gmail.com>
 <CAKEwX=OY_nws-vf3VgnD54G205TK2YjkoAwRCyB9jvW=Oz3PpQ@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=OY_nws-vf3VgnD54G205TK2YjkoAwRCyB9jvW=Oz3PpQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 6E554180006
X-Rspam-User: 
X-Stat-Signature: he96e8uufi4z8buhpydy3ja1srrm966i
X-HE-Tag: 1778746397-151582
X-HE-Meta: U2FsdGVkX1+BknjzwDSKdSOsSDxThdXE+i6hht7tjIO2h+NmfclWAj96pd1mRl5nP7vchBFKfZwcdrSlHDYA5Bp7AUKhWQp0bLEpywuTF/RyM0hmY5Gu9u68TT9XuFJ+cXANPcNfOzLHKGo1aS+sZ9dIu0VmitVYAv46bYvpNc0BVPGGkLwuUZDmdSExTqot0hDrLv7slpblwnGv4uLdBOnpcHqjmO2KpGt1vOMswO0P81gevE9U+SkBvKQmHFeprgvYL9bnun+YZKoy1erunCbKsSw05sTiqN02UC14/VnDRUEMq7VF7AmQSbzVmNygrjYtEwV1v6nea6kBZULmbkZDieei3KGYhoqi472yQLU7jt2hRnDRfsVhPmYMyIwHcLea+WZ8wm4RPBzHZ4WB4nA1FGNsthwHD3wSxZCVS1QEXSROE4qKovVzaHRSggwRggKOhOPDen5QnJ10Ou/vHqwwWR4QYd6u6EgI+yTUYFV5Yc3bCwES/Za36zt/0a9X0OyDdcQKGKNBEBFyPAgCkj3gxpbG6Svk/6sg1P+RrIjBDug65iNs/S3/youWW+ZMW/54IqDVLP1VSe6MrepuM9YUvdc0mgHHmf372sq459U2+XfPX2+tbWUZ9X+P29WV9bduHTRO8VDzs09UDxI0ugrE6atlJEZE81PWrKoHZFyHtepE+UDkZtCLiGn3LNy8JOokW1bFBRIgzP63U78iG6lbABTacJRL6+JVXPwQ+GgpsFTHG8rrE8yNLveNsAQhgAI8Y/CMa7TcfEtjE64s/KfB1HhS9vwjn6vJsjeZ1EvqG0nExvRKplhlDrhe6ifkis1UKQiLZMi4zez8unza7CPR78rtUZH5GjJONfIKODKkzOGsVvNBEpb2Z/2+dqsA8Hb+5OV3nuEUH6GFmCFKaMu0CDGVMoFagQYRK6AkHoku+ee7cTzIXyXrNOyRmWKQIm5ieN4vxowrZVuEue8
 wY8iCxi9
 MSbNGdF8X7ehqU/YbgTX7A/4n7B1p7O5F5/i3J0Kuo4bCEb+DFcvZEEyxnOaK2RMnMqchd68ovOSdK/WEZmRUq3bhS+xX1Sb85r49pxMU/l7nnxD1adLk1LkQVHFzEAIj2Z+wEdc44FveC08LYQ8t6Z6xfQ1HdZlp2LYUXGLcG2/JTGMkm8J2V+SjTWouYoy76taY7K+v6TXeSkR5KRLitWs6bHlzwlX1PSqiMe1f5YU2SPjOP2dHGfnkWjg2tBNreCK19Y2RS3uHj1kuJxqvfhF8V8oAOIHsWBcvMkIMYV1Is2bfSBuAUYw5WHtrPM8GGy9T/uUsBS4FobqRvxoBGrudFAgzWVwDFTPmqkmWRtLUiyqCEMWB7oIu6FJEKh1k+WVh4d2ny6HCN2j629WViNyBjPe8/c/DMlA2QLZJtmVMgg8UUwIhiK1oWQlFy2+ZpkYow8bQ1IIsGc/LzUkbEgOs168aycA0kQQR2HbsWNfR11rXQQC8va9KIEGwk/wyF60QfgmKFFoQN+xBClOakQvI6hl/zALTTCAdcETfbppfDPFWsLBk7P7Fmbyd/vHB8w5+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/14 04:53, Nhat Pham wrote:
> On Wed, May 13, 2026 at 11:55 AM Yosry Ahmed <yosry@kernel.org> wrote:
>>
>>>> Zswap objects are organized into LRU and exposed to the shrinker
>>>> interface. Echo-ing to memory.reclaim should also offload some zswap
>>>> entries, correct? Are there still cold zswap entries that escape this,
>>>> somehow?
>>>>
>>>
>>> Yes, the memory.reclaim path does drive some zswap writeback, but
>>> it is not enough for our case.
>>>
>>> 1. For a memcg that has reached steady state (a common case being
>>> when memory.current is below the policy target), the userspace
>>> reclaimer may not invoke memory.reclaim on it for a long time,
>>> and so no second-level offloading happens through
>>> memory.reclaim. In this state we want
>>> memory.zswap.proactive_writeback to write back entries that
>>> have sat in zswap past an age threshold, to further reclaim
>>> the DRAM still held by the compressed data.
>>>
>>> 2. Even when memory.reclaim is running, the fraction of zswap
>>> residency that ends up reaching the backing swap device is
>>> still very small for many of our workloads, and the userspace
>>> reclaimer has no way to participate in or control the
>>> granularity of zswap writeback. So in our deployment we prefer
>>> to leave the zswap shrinker disabled, decouple LRU -> zswap
>>> from zswap -> swap, and use a dedicated proactive-writeback
>>> interface that lifts the writeback policy into userspace where
>>> it can evolve independently of the kernel.
>>
>> To be honest I see the point of proactively reclaiming compressed
>> memory in zswap. If you use memory.reclaim, you are also reclaiming
>> hotter memory in the process, and you are not necessarily getting as
>> much writeback as you want. The memory in zswap is a more conservative
>> choice for proactive reclaim because it's memory that's guaranteed to
>> be cold(ish) and not being accessed.
>>
>> That being said, the interface is not great any way you cut it :/
>>
>> I don't like the 'memory.zswap.proactive_writeback' name, maybe we can
>> stay consistent by doing 'memory.zswap.reclaim', but that just as
>> easily reads as "reclaim using zswap". Maybe
>> 'memory.zswap.do_writeback' or something, idk.
>>
>> I also don't like having two proactive reclaim interfaces, so a voice
>> in my head wants to tie this into 'memory.reclaim' somehow, but that
>> includes adding a pretty specific argument (e.g. 'memory.reclaim
>> zswap_writeback_only=1'.
>>
>> I don't like any of these options, and we also need to consider what
>> the memcg maintainers think. I see the use case of proactive writeback
>> but I am struggling to come up with a clean interface.
>>
>> I also think we should take the 'age' aspect out of the conversation
>> for now, it can be a separate discussion. Well, unless we decide to
>> tie it to memory.reclaim. If memory.reclaim broadly supports age-based
>> reclaim then zswap writeback can be a natural part of that without
>> requiring a specific interface.
> 
> Yeah perhaps extending memory.reclaim is best... Sort of analogous to
> the way we have swappiness to balance file v.s anon....


Thanks for the suggestions, Yosry and Nhat.

My only concern is that if we eventually need to add more parameters to 
zswap_writeback (such as age or others) in the future, would it make the 
parameter parsing and the functionality of memory.reclaim overly complex?

As you mentioned, if the memcg maintainers have no objections, I will 
attempt to implement it in v2.

How about something like this?
echo "100M zswap_writeback_only" > memory.reclaim

Thanks,
Hao

