Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58E6BCD4F25
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 08:15:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BC1906B0095; Thu, 14 May 2026 04:15:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B23B36B0096; Thu, 14 May 2026 04:15:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61656B0098; Thu, 14 May 2026 04:15:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9A7036B0095
	for <linux-mm@kvack.org>; Thu, 14 May 2026 04:15:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 368301C049D
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:15:55 +0000 (UTC)
X-FDA: 84765317070.27.FF4198A
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4683F120009
	for <linux-mm@kvack.org>; Thu, 14 May 2026 08:15:53 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RI+x87/8";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778746553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUhzM6fW54CIjEhJ1LOogiKkg+75ePaMhcH2tPJszfQ=;
	b=aR8eoxLL+DlrgpS03gTmqZv5fUH2jYBNGJ24ABHkx+piEl6rw80QhggRBuxhYlfRNn9xMt
	27wzCU7AJnXTcHzlv9kmeH7wQDs5om3Fo2gSlc4IaHRHwV5lITM56wyqJ6vmbwLwW5gbxm
	f8WDTdH2VYOOZmBOQCPTSyFnrrmDu8k=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778746553; a=rsa-sha256;
	cv=none;
	b=q1jsW9Lc5lQQEQ07xEjI2lYHJqhaL3Br+weLctogPnH996KYiac5XBh/64WgCKUgYRrf+y
	NvaeH70aYr6WcOO8Sr3Yyg17/1DPNBTfszK5w26L6ZNWcy6KvG1IfBuLdUow26Tm3PkdQW
	z6KSyJoPZ3hTrftBbOH711//wLnmwQ4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="RI+x87/8";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of jiahao.kernel@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=jiahao.kernel@gmail.com
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-83ef8b48f94so1983985b3a.0
        for <linux-mm@kvack.org>; Thu, 14 May 2026 01:15:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1778746552; x=1779351352; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IUhzM6fW54CIjEhJ1LOogiKkg+75ePaMhcH2tPJszfQ=;
        b=RI+x87/8uRpzPSvPc5+seIZFMVDUpNnKamEFPDZrQSaKbwpUC5uDxsepldLfIAaMet
         vKQ029/+fkua/i71bzTQVzjEAHlgpEgXYXsD3n5w9/v+fBrxwGroqqjn01Sn0cEkVMw2
         Rp64C+O8ZuoUvuXpvEKj0ogKMupvcJ8oknsHWfQBisiXUbBCVwJO8eye7paeBQ6dXEhM
         Iuxkt4T4NmaFn49gASGzgLyDGKPDlXMiWbRYjtzHVez3xnMPZKfEWnXLOrbpBPYJds6c
         1hFfiDKMPz9R1JOYwE2iYJqekUi6eiDMKQxXNbZLHVTPJXkIMZorW17dKtmsVkJW11cc
         rAkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778746552; x=1779351352;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IUhzM6fW54CIjEhJ1LOogiKkg+75ePaMhcH2tPJszfQ=;
        b=PS7Mx3Zggukm1pJxeEY5fm1JGq3DXTtZgFzkna1OPQhV/qobGcKyuPnR3ap5N6a6sk
         uue5Xm4TosVBh5Ja/cVYPW3lqx2ClXSicFuSiayYcLnGtCdNpzdXN51JPwoAChB2ktBJ
         aEw3GcpatdUJ8vKx+cZSfK8MZHSWPYUPTYZhpAnbGlQyGvL9CLjAKgnS9LV0w8ZxWJk3
         H7o2KRTroP7yv5oK9w3s4o/iORQhhQLOTCgWTns1Oc0V7JpIgFKtbRVexsqlosH0cNhC
         j0HARraprymap0D6FPVbpSSEmh5gpKhvSgA8OUGnzQX1WDlAX9Lj5zoNEZIL8zTZTYbi
         jWtQ==
X-Forwarded-Encrypted: i=1; AFNElJ8kikGADz1bG9GqcyRNs0slTEiWc5B1oSFqhtvSU5c9YakOx3bknTNii4EOzLUwTHDy4mYYh/Ud4w==@kvack.org
X-Gm-Message-State: AOJu0Yw9QHDTZiKIWd1Mcr9XEZCOH0p9t/Qv0KJ3e39b+k1HPt0cVR4w
	H2GCTBOpN2ksg+gNt4Wcxp7HagoTGKV7TXwmPZrth4As1nDskoq715d+
X-Gm-Gg: Acq92OEYB5golViY1lSxuyQAkqsKBsQiz4bBMn6gm3p+KSjQNI/cwQQzrNWY7Q41kc3
	4Jog6puVFDwdKiDGnNSpolXu/Rq6MDikudYAwcBAC/3MQ/371vVYXNJ4yV3aOQiEqPrwLiAjpc9
	dTwf07JjPi79VHwJOTCLYwpObRV0IaRPItHshF4wcL5oIcsESueh0qF5lZp17vfs8p6xXcXGdhH
	PSaqx/7FrvicgUexwc+Vwbof1RwVlyVWKKcz7Njo/99CSM9ewAEVEdCxFI60e4JPHM4tzCaoeQw
	goygxzE2wnnPfxIRcqQt0PepMrH+dCPF/t2jVSrfJcNzij7pahV2MHu4bkQquPNFbXslBXDrUvz
	6oczKkbs4pWPkmr7Ts4QH+iXyFjnpfs5lu5B2IiN5O2aDWRFcCi0QS/tVVDDguqZf6DnyP2gHNG
	IlKiLybBiBwfYqPDnbxeKI6l54sJGoyM83QmxwXlpHaMs=
X-Received: by 2002:a05:6a00:2192:b0:82c:7383:3745 with SMTP id d2e1a72fcca58-83f0546c39dmr6362403b3a.19.1778746551489;
        Thu, 14 May 2026 01:15:51 -0700 (PDT)
Received: from [10.125.192.65] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83f1977c494sm1854182b3a.21.2026.05.14.01.15.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 May 2026 01:15:50 -0700 (PDT)
Message-ID: <6c531b1a-ab35-e5a3-b9ca-40a639cca55f@gmail.com>
Date: Thu, 14 May 2026 16:15:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.15.0
Subject: Re: [PATCH 2/3] mm/zswap: Implement proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org, tj@kernel.org,
 hannes@cmpxchg.org, shakeel.butt@linux.dev, mhocko@kernel.org,
 mkoutny@suse.com, chengming.zhou@linux.dev, muchun.song@linux.dev,
 roman.gushchin@linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>, Alexandre Ghiti <alex@ghiti.fr>
References: <20260511105149.75584-1-jiahao.kernel@gmail.com>
 <20260511105149.75584-3-jiahao.kernel@gmail.com>
 <CAKEwX=PLFRkfUvZyaYfwBv0QJ-8KAktvZvGA02Hod04H-RsS-Q@mail.gmail.com>
 <CAO9r8zNOPdpJuTmccvQ6ZAVS+tXxp-_ofA765DbnfaUZOPPO-g@mail.gmail.com>
 <12e4784e-2add-d849-7e54-bde8abfa6e78@gmail.com>
 <CAKEwX=MOixJAUGiwUcMQa0Stvg-mR-MvpDRD8WA4YMtRvnUYTg@mail.gmail.com>
 <6fc7fdf0-368c-5129-038e-623f9db2aa88@gmail.com>
 <CAKEwX=M=6AQVYA7ROM0YOP7irpxbdMrEOAHKGKYo0Qgr+-uhSw@mail.gmail.com>
From: Hao Jia <jiahao.kernel@gmail.com>
In-Reply-To: <CAKEwX=M=6AQVYA7ROM0YOP7irpxbdMrEOAHKGKYo0Qgr+-uhSw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4683F120009
X-Stat-Signature: 8sf9i3sjocc3se3in8ci947r6bwnx6mm
X-Rspam-User: 
X-HE-Tag: 1778746553-804517
X-HE-Meta: U2FsdGVkX18N8RjOPUrQ6NNMEdwqTZBGXVkkeirq94cHxqG4kkRw3ZV/v1dKMtKTjQ3Ufw9z+8me98XD52e/ubNnBV3OWnn0VT76Qy0FWFWTvo6nD5ufT0JdwpRMAKNMv26HT6D9jTjXguT4aBWd/e/TBDf6iIS4sxh0gtDrW+dDT0kNLjkejCDDhBBttx84p/UIecG5/BmI2ebxNrRtuhxwNsoFrxQcL4bZRXT87VK9NfKeoTtdMmnpezMvDwbUyJBrxw9qeT0WKW+odMKdRnO1qXPr3h9jKCm+vCx2kTdIJr97mDZTFmljrxGo8/8QwAWunQdlemXaGfTm29bLtA4JZsbZVSlvwnDWu7HeQWLl8mhCvpm7rXlWV4eBJ5tkjQneRdaiplpZjXG9fh3/LEs9zaC8Kd19sSd4bnoI0jY7eydeUSowizAz8t//azVsNuz8v/rZAhP5L+/FwMzaKRruTwlsXrdIrqsQoZUizLkREmJsNPWL41nKhmhkE3DGO7OUiYbURFEmyHKddIgBHpV+RoAx9i5kI8iGCLSoTiBnquNK/4eliFLLBeJIyp/B9LVOoY1AnAahhuUS9uT9Cedo+BhTri2Hl6fRN3JGwlXHIu4yOlDs6Xjc+ZZ4z2jV3J4trB+hOYlDPqZTOJjOVpYhNtiVK/VIk+JRNYiI38i30PABN3TYPiCKLKKhpV9lNky42vWjhVbZb8NL0dXqZ5b0d1d6Yhq5N7+aVpyfURFROP+KF6eaVLnFUhakLYOMEDmIImlq88vJGqDHHVShRgc7femXHJzAqWlI/3MJ39EECS83XYxnfmvpQNqBC4kZCF2cf0uNfRWmfiLCwF0vpAhdrkWzTGrMXessPhIclEBNRHy/VF3dUS6HH8uCMZrEUhgZP0sxJetN9rqW5dP2YIwHsFK376FayoUNaBqIQhlphWy1G4rvwBy2EtanaC+HT+wKaXGRWw9E22Sj4kG
 qJTR/nKV
 taeDtfn7f/5eXyVlId7IrtgKaDSois3Hx3+AOti/RHCQhxhLnQjgvAH5HRYusqgsvy0eYj0Qk/X2Z/CEqdFrbJOgUqcVRJIxcgqk8VbCQ2pFyehmiX2rYxloRh++lRullRsN1rt1sN1v1+9UqiZDdmGqysvZl26Tb6TXhJ3UX6m61ebaCJYn4xNVcHStc/wsOb4Kd3bdXht01/NYk1GeVSTrfnQ3kTc66KQTRbUHm+BC28UZkWldrkXOIuCCmbLxfrGhTGFl8C+5Hc6SrJl+vD+yWyBWPU/Hsxh06vPZ80pG4yC2/PCZ6x5umzII5OdC1wWqKcYrqvSuAMxmTqgef/ujAKJsbqj7aLiapiWpUFHlfzqQTjfS42X2h2NaqzMqjrFb6TGZ30zzGkbIQe02T24cP4K65mvmC2bpymvowkysPhz8O7KJpODQMUv51LYUnJl0tLIrRqZLuXOMrOUxOIGAvwyJb7nE9WVlXj+3POmUSDR99pa38LKI/8ZbhdJ7R9AocWluaIrCpHFMOOKEM36YnSNE9XiEZ99lfc4gTxaFVioiEZOjt/PgqYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/5/14 05:09, Nhat Pham wrote:
> On Wed, May 13, 2026 at 1:04 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>
>>
>>
>> On 2026/5/12 23:47, Nhat Pham wrote:
>>> On Tue, May 12, 2026 at 2:32 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>>
>>>>
>>>>
>>>> On 2026/5/12 03:57, Yosry Ahmed wrote:
>>>>> On Mon, May 11, 2026 at 12:49 PM Nhat Pham <nphamcs@gmail.com> wrote:
>>>>>>
>>>>>> On Mon, May 11, 2026 at 3:52 AM Hao Jia <jiahao.kernel@gmail.com> wrote:
>>>>>>>
>>>>>>> From: Hao Jia <jiahao1@lixiang.com>
>>>>>>>
>>>>>>> Zswap currently writes back pages to backing swap devices reactively,
>>>>>>> triggered either by memory pressure via the shrinker or by the pool
>>>>>>> reaching its size limit. This reactive approach offers no precise
>>>>>>> control over when writeback happens, which can disturb latency-sensitive
>>>>>>> workloads, and it cannot direct writeback at a specific memory cgroup.
>>>>>>> However, there are scenarios where users might want to proactively
>>>>>>> write back cold pages from zswap to the backing swap device, for
>>>>>>> example, to free up memory for other applications or to prepare for
>>>>>>> upcoming memory-intensive workloads.
>>>>>>>
>>>>>>> Therefore, implement a proactive writeback mechanism for zswap by
>>>>>>> adding a new cgroup interface file memory.zswap.proactive_writeback
>>>>>>> within the memory controller.
>>>>>>
>>>>
>>>> Thanks Nhat, Yosry — let me address both comments together.
>>>>
>>>>>>
>>>>>> We already have memory.reclaim, no? Would that not work to create
>>>>>> headroom generally for your use case? Is there a reason why we are
>>>>>> treating zswap memory as special here?
>>>>>
>>>>
>>>> Apologies for the lack of detailed explanation in the patch description,
>>>> which led to the confusion.
>>>>
>>>> While we are already utilizing memory.reclaim, it does not fully address
>>>> our requirements.
>>>>
>>>> Our deployment runs a userspace proactive reclaimer that drives
>>>> memory.reclaim based on the system's runtime state (memory/CPU/IO
>>>> pressure, refault rate, ...) and workload-specific
>>>> policy. That first stage compresses cold anon pages into zswap. Entries
>>>> that then remain in zswap past a policy-defined age threshold are
>>>> considered "twice cold", and the reclaimer wants
>>>> to write them back to the backing swap device at a moment of its own
>>>> choosing, to further reclaim the DRAM still held by the compressed data.
>>>>
>>>> This is the "second-level offloading" pattern described in Meta's TMO
>>>> paper [1]. zswap proactive writeback is what this series introduces to
>>>> address that second-level offloading stage.
>>>>
>>>> [1] https://www.pdl.cmu.edu/ftp/NVM/tmo_asplos22.pdf
>>>
>>> Yeah that's what we've been trying to work on as well :) We are
>>> working on a couple of improvements to the mechanism side of this path
>>> (cc Alex) - hopefully it will help your use case too!
>>>
>>> Anyway, back to my original inquiry: I understand your use case. It's
>>> pretty similar to our goal. What I'm not getting is why is
>>> memory.reclaim (which you already use) not sufficient for zswap ->
>>> disk swap offloading too?
>>>
>>> Zswap objects are organized into LRU and exposed to the shrinker
>>> interface. Echo-ing to memory.reclaim should also offload some zswap
>>> entries, correct? Are there still cold zswap entries that escape this,
>>> somehow?
>>>
>>
>> Yes, the memory.reclaim path does drive some zswap writeback, but
>> it is not enough for our case.
>>
>> 1. For a memcg that has reached steady state (a common case being
>> when memory.current is below the policy target), the userspace
>> reclaimer may not invoke memory.reclaim on it for a long time,
>> and so no second-level offloading happens through
>> memory.reclaim. In this state we want
>> memory.zswap.proactive_writeback to write back entries that
>> have sat in zswap past an age threshold, to further reclaim
>> the DRAM still held by the compressed data.
>>
>> 2. Even when memory.reclaim is running, the fraction of zswap
>> residency that ends up reaching the backing swap device is
>> still very small for many of our workloads, and the userspace
>> reclaimer has no way to participate in or control the
>> granularity of zswap writeback. So in our deployment we prefer
>> to leave the zswap shrinker disabled, decouple LRU -> zswap
>> from zswap -> swap, and use a dedicated proactive-writeback
>> interface that lifts the writeback policy into userspace where
>> it can evolve independently of the kernel.
> 
> I see. It's interesting - we've been dealing with the opposite
> problems (reclaiming too much from zswap) that it's refreshing to see
> the other end of the spectrum :) We should invest more into this to
> see why we are not reclaiming enough, but I see the value of adding a
> knob to hit zswap exclusively.
> 
> Regarding age-based reclaim, I agree with Yosry here. Let us try to
> land an interface to do targeted reclaim on compressed memory first. I
> do see the value of age information: with it, you can track zswap
> entries ages and the distribution of refault ages, and only reclaim
> the tail. However, I wonder if you can just build a system that adapt
> the reclaim request size based on PSI, refault rate etc. similar to
> how you're adjusting memory.reclaim on uncompressed memories with a
> senpai-like system. Something along the line of - if we are swapping
> in too much from disk (or if IO pressure is high), back off, and if
> not, stealing a bit more from zswap pool (perhaps with a bigger step
> size), etc. Is there a reason why zswap cannot adopt a similar
> strategy?

I'm not sure, as we haven't tested the case of tuning proactive zswap 
writeback without using age. As you pointed out, age provides a 
deterministic target that allows the userspace reclaimer to converge 
faster in a closed-loop, which helps avoid performance jitters.

That said, using age as a zswap writeback parameter indeed warrants 
further independent discussion. So I'll remove the age-related parts in v2.

Thanks,
Hao

