Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2684410BA435
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 08:08:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76C7B6B00BF; Fri, 27 Mar 2026 04:08:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 742EF6B00C1; Fri, 27 Mar 2026 04:08:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 65A096B00C2; Fri, 27 Mar 2026 04:08:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 556F56B00BF
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 04:08:01 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 14EE7C3F5D
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:08:01 +0000 (UTC)
X-FDA: 84591114762.09.A31FC48
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf05.hostedemail.com (Postfix) with ESMTP id DF023100004
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 08:07:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EUOhRxMY;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=vbabka@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774598879;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qbAyX/dJcdcrO6MnxnxfswzmV0uXORbDrNSB9i56BJs=;
	b=eiqj5MXpUNDsz0WLAA8IupcKebX7IBEq1uFbiSpgOwBPRMfSTrDChd3RwrhbtEF/fRW0MH
	xio9gY458MTUinR5GeaqofJroU4631+JrEckArqHpbfj/AJ9IPZZqy0yeExRIkJMqAe2Gy
	WOm3FwsPXddnhUNzxR1IxNbc/EXpNIA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774598879; a=rsa-sha256;
	cv=none;
	b=6T8jD1uIkXP9spk0bdkG2Pr8MRZjlWL4JE5kbncE9+lYbVG68aJnH/0nIPt7I9jBdgPuR7
	vNU1r9eOzcQ4RrHr/uYWfYRx49aJSSmQsvH6YIP88LGxHMWAzkuqJIfS/ArYF8nngEQtxF
	1S08jCpQkJ/KHmfuFfTYj8qQDE5U5vc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=EUOhRxMY;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf05.hostedemail.com: domain of vbabka@suse.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=vbabka@suse.com
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4836cd6e0d4so2582285e9.3
        for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774598877; x=1775203677; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qbAyX/dJcdcrO6MnxnxfswzmV0uXORbDrNSB9i56BJs=;
        b=EUOhRxMYQh5KCmPgHFqtWchhTPGryaWJ7IDiFX9eYa4KZxFWrhEtJNpXSJvUGurllW
         GJHpRU+Lx4dfg8xPxL9XHEuXZ7FKjZnU9VMiT6qfvk5t3/Zu57aZZOVJ5eTuooaxGyuO
         vEocCrLNqaZ5sMJRqRUXqHbigGGaCuaP46x5xZr3wKnWHYU2WWir2pRwjm/u/65AWiNt
         mfWHEWztc+Yu+nTSY0s7OhDFjiNpDpLGEhLrBxd+LRFwnvx9FpGpOPgwhvOrBTzN096D
         90jFyg0L8RsgNkyZTVx9zMlVC7lvkXUSqxAMEBcCIHAz7P4TWWsrojsZj7FOJrwhRYau
         IAKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774598877; x=1775203677;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qbAyX/dJcdcrO6MnxnxfswzmV0uXORbDrNSB9i56BJs=;
        b=ZEYWqiISeZwXALhnv6oGVB3V5P8edR15D5sAUwICE3cf46DP6cPy2ugBsx86VJbLSN
         M/Gu2q18CnMQrdsU1B0bpOgweYihPqg/wgtOwb294x101tJbFDNTo/SuvnD9Qp2Wya1N
         viICef4lv4cNofEPJA+XFWcumd9ecId79uKq4gL6/eWCu6CBW9j2akGZ53dmNH85kD0Y
         X4JZ5wNJt0KrSTG7UIKpsGgBXhEoOSy4cBfCssXgPLLIT78EBUxRGTjKCIFrplllNseE
         QagHSu3ao/Z09lw9KJ1pfjPr82qkIHHmKSJVcdveqkFb8bHtvWrH01w1sBqhCxMuaEXe
         TQog==
X-Forwarded-Encrypted: i=1; AJvYcCXk+xfuuQs/6zZRVux29yM7IujOrYczElao9xcRJuRcT9nHX9rxyvUW+H6uu6HZMI/cp1T4sau9IQ==@kvack.org
X-Gm-Message-State: AOJu0YwaHhVKQ52QMo9Q4JHG+FjZkYkkFPF6cjJUu22vlwVI9kXkusSk
	AZ2j1qfgMknvbY52GS4zUdZrFUjzFGeaFHVcOqFM5LJf2Zjy1TrH7a6wpMLtYDKFj0g=
X-Gm-Gg: ATEYQzwu6Op7MUNPqn4XogCzj6tiYqhKK+dMqv8iOQ99/xhDqB6V4DQqSvj6C4R1HwP
	iQY6sn7/oMwSs8eNzjz05hdIawhKc6JMtyPfgItCJaDnH8BdmHaClV75WDLpA3lQchOXah6h0ui
	HBWzEFouwlBAODXkMh0p0mtQgCSH9Otn4wm6xOiz2Qd+Tkjc0nBoEVaG4MDLB3DTGzSop/EK31X
	XHIq3uAGz3Rar3Bido8F7/iOzUGRPVY15oEwJrZbc8qNghec0mrBkx8TZsotqXdDKmgDm02egZS
	zOJkNeYg4Ulg+W2VkR+JDm0lMGT1nOKXSs/PNVUWWhhaBivbGjX+lwQggI/VJ/kSj4Y1TzIgHWi
	Q3l4LJI6hBUpkS1OlKZw+64wd9ugy5v+P//Fit2WKaHkG0GnsuRr3ettn2ZM9M1EY60XnIgVl44
	i58uSewVZjEPWOfLgDLUd286fHLggh2Re54oF2JGkAb8IfCfZjrSF03uAyrg==
X-Received: by 2002:a05:600c:1d1e:b0:485:385f:674d with SMTP id 5b1f17b1804b1-48727f0e5acmr12813705e9.8.1774598877151;
        Fri, 27 Mar 2026 01:07:57 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903:1ed6:4f73:ce38:f9d4? ([2001:1a48:8:903:1ed6:4f73:ce38:f9d4])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48722c789ecsm79068835e9.4.2026.03.27.01.07.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Mar 2026 01:07:56 -0700 (PDT)
Message-ID: <8406d210-4f68-4919-b791-c03c310a8385@suse.com>
Date: Fri, 27 Mar 2026 09:07:55 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Lsf-pc] [LSF/MM/BPF TOPIC] Towards Unified and Extensible Memory
 Reclaim (reclaim_ext)
Content-Language: en-US
To: Axel Rasmussen <axelrasmussen@google.com>,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>, Andrew Morton
 <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>,
 lsf-pc@lists.linux-foundation.org, Johannes Weiner <hannes@cmpxchg.org>,
 David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>,
 Chen Ridong <chenridong@huaweicloud.com>,
 Emil Tsalapatis <emil@etsalapatis.com>, Alexei Starovoitov <ast@kernel.org>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Kairui Song <ryncsn@gmail.com>, Matthew Wilcox <willy@infradead.org>,
 Nhat Pham <nphamcs@gmail.com>, Gregory Price <gourry@gourry.net>,
 Barry Song <21cnbao@gmail.com>, David Stevens <stevensd@google.com>,
 Vernon Yang <vernon2gm@gmail.com>, David Rientjes <rientjes@google.com>,
 Kalesh Singh <kaleshsingh@google.com>, wangzicheng <wangzicheng@honor.com>,
 "T . J . Mercier" <tjmercier@google.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Suren Baghdasaryan <surenb@google.com>,
 Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Tal Zussman <tz2294@columbia.edu>
References: <20260325210637.3704220-1-shakeel.butt@linux.dev>
 <20260325190547.abb7309fb63473b57b7a90a0@linux-foundation.org>
 <acTaRgusrxfCoKqe@tiehlicka>
 <ac05d923-7871-4691-8d26-eff41b3a3db0@lucifer.local>
 <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
From: Vlastimil Babka <vbabka@suse.com>
In-Reply-To: <CAJHvVchSfGDubPhir0SgZfr_BcpN5oq_7AY4AZ587_ucgY4Apw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DF023100004
X-Stat-Signature: fshc1y9fu4nnsj15a1h6ejdqstm1eq13
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774598878-852890
X-HE-Meta: U2FsdGVkX1907x4krl1XGEhcQ4nSN2rUJj4E1LcnPfKjg4VFMbrA8exhMp19KQcbc2qa7qIhgBq+x0F6c4xH3Nx2keYv0rlQXLpPkEcgseod2yrEPpxgzR0sx+4OZ0eAnx3vcX8c5k6zXAvWFDSjczAPM2YZbJfom9ZUY75/ul4gX2ikHLSMQALQUZn2qzMLv1MsJeNbVy3ejK6e5Bs4mxuD3sYaNoX4ua+p7SvSxfWpv1iyDo+ASx6LyAjeS/ntwm9PwDeeNOnUxAt7TZMnP6xW/FuPfaqAGwDnzOAz/ZMi9se/wyb7C/cRdNdipBmQwPjgLowxy/AFTzNS3WYDSDbV1M1K003wyDggkQuUSUt/ZkE73c/7Rz5MctjN9S6ucRI7FAsRkYD0wcQ7PiB+6E0X7ih+c9xTD9GJ7sFKFMeyK7c51TuLmnfiVmylT/fHDmkeWhMYgG7lUMvtU4tnGqW4dI+ydWyxq0KWJIY5ouU48RzzHW+RtW9DrSQ18uDggqIuI4JL3ALM0NOfcuzETNRXsNYTFfFQBStXb74NkXcGXk7zuDZG5mo7U8k4tcwh8BjJh0mwmd3M/drQIrRMz5/YC6dMtlXnJzgd1x9a6NChHc9+d+j8uFGvEF5eYTMiQRIk0GePXTU6D8X/VP2MKzn2Wrt+tJwvOGvMn1jLvUiUuRc9QzLCq/vF27hTwKy205ovE1JTc9MTq0PF0WfkmF67EF5YogA2TQk98y440VWE0dD1Borsf5lOFuWRmTChNw0v7A9hOTvpwAQsnhFF0fv4ubfiOsXMNO4ejhZINmMymB49H9e7nM36FoXwcvV1UoTaNpxY9BkwdWg79Mt+RXCBwU2Yz1WAHoMRSNKFFXnJiYdMI3+CoFyXKFN0VyIRkMUkFolfKKfD5th2KU0+7riFPdrmDDwWVzirIvU21IbgPWs+nE4NR6XHAbVwjpR/SnBNtRerrD1FChF92no
 5c938AcB
 5Qh+V19VsXNFvkTaLYvloljNZNc97kXf0Qx0gzy6S2wh0SGu26hQziXIgXH7d4dpHqgiGP88AVNjJy6bs8+k9r18yLn9vOzccqJo5wp4fTmaREKb2pP2qZP0PxVxkZNsxT5mfXRGdIZo8eqIBbWF/RLOfZzY8rKaocmEUGIUrZ8iNFpAJ1h6Yv/vVL9pjfAw5EIs/0pO41PEh5aALJz3VqCfqXkYPj75R5jW5erCRIBQOgiRWYhUXVVoIxTtRGHxMvHALI6C0Julf166ZRw3wdLLjlRLwVFtBeBYyCmOpd3Y+hOpnXVn+98g1z8h8MnDD6qZj2zN7/u99PFDxetn1XaGGrGtlFYG8THNH7h7FpGk/bXVJWTfyjeW7joSAfZPGEsM7dWIeotL7NzT0ctmQhzFsGIlvZ6XMn400R+3buq/BroRd3pDcMonf6AifEBtv4ENc2j7G+PE+w2Upo26Po4bEzOckQt8f+VHnEWx0mfVTzk71qnpy7xHSN9urw1xVb0HJBGfzWDaNYJShp8E3gPf83qoiNHPxu02YTS/Ysh2trSuUfe5qtffflrks7etNRlqI9xvObQQuYUFgVov1XgaFQlaFmek1L8EK90KePXRystgZS5YXM6hip+gy8zcy/HDT2hbYkf3WBHCU0hH7lKkvv/MnaI+Ej1lpng9YMvmcXylOGyqCeNV+upWhhPhaxBk12+y5EZjaBtACuw7QCBqlr4TC/8+tBeXjYzjedFXJJLQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/26/26 21:02, Axel Rasmussen via Lsf-pc wrote:
> On Thu, Mar 26, 2026 at 1:02 AM Lorenzo Stoakes (Oracle) <ljs@kernel.org> wrote:
>>
>> On Thu, Mar 26, 2026 at 08:03:34AM +0100, Michal Hocko wrote:
>> > On Wed 25-03-26 19:05:47, Andrew Morton wrote:
>> > > On Wed, 25 Mar 2026 14:06:37 -0700 Shakeel Butt <shakeel.butt@linux.dev> wrote:
>> > >
>> > > > We should unify both algorithms into a single code path.
>> > >
>> > > I'm here to ask the questions which others fear will sound dumb.
>> >
>> > Not dumb at all and recently discussed here https://lore.kernel.org/all/CAMgjq7AkYOtUL2HuZjBu5dJw=RTL7W2L1+zVv=SCOyHKYwc3AA@mail.gmail.com/T/#u
>> >
>> > > Is it indeed the plan to maintain both implementations?  I thought the
>> > > long-term ambition was to knock MGLRU into shape and to drop the legacy LRU?
> 
> I think one thing we all agree on at least is, long term, there isn't
> really a good argument for having > 1 LRU implementation. E.g., we
> don't believe there are just irreconcilable differences, where one
> impl is better for some workloads, and another is better for others,
> and there is no way the two can be converged.
> 
> On that basis, I would be hesitant to add some complex abstraction
> layer / reclaim_ops to facilitate having two. It seems ilke it may
> make things a bit cleaner in the short term, but long term might make
> that end goal harder (because we'd add the task of cleaning up this
> abstraction at some point).
> 
> My preferred way would be more like:
> 
> - Look for opportunities where we can deduplicate code, but without
> adding abstraction (e.g., factor out common operations into common
> functions both impls can call).
> - Identify gaps where MGLRU performs worse than classic LRU, and close them.

I'm afraid to identify these gaps we'd have to indeed split the MGLRU
differences (as listed in Shakeel's proposal) in a way that they can be
tried separately. I recall when MGLRU was proposed, we did argue that it's a
combination of several things done differently and they should be introduced
to the existing reclaim and validated separately. But the author refused to
go that way.

> We could go the other direction, where we identify places classic LRU
> can be improved, and port particular MGLRU features over to it. I
> prefer the other way for a couple of reasons;
> 
> - My sense is MGLRU is "close", meaning as Kairui said in "average"
> cases it is substantially better, and the gaps are both fairly narrow
> / edge-casey, and very solveable.
> 
> - Leaving classic LRU alone leaves the option for existing users to
> maintain the status quo. If we start porting MGLRU features over to
> classic LRU, we may introduce new regressions and break existing
> users. Using MGLRU as our working base means we can iterate on it
> without as much risk.
> 
>> >
>> > Yes, but MGLRU is not there yet and with development pace last year or
>> > so we are not much closer than at the time MGLRU has been merged
>> > unfortunatelly.
>>
>> I'm quite concerned about maintainership, as it seems the MGLRU maintainers have
>> not been all that active, and the MGLRU to me at least is currently a black box.
>>
>> I'm not the only one who's raised this (see [0]).
>>
>> That'd very much have to be resolved and the community reassured that MGLRU is
>> _actively_ maintained before we could even contemplate it replacing the
>> 'classic' reclaim approach IMO.
> 
> Very fair concern. Time will tell but I think things are on a much
> better trajectory now.
> 
> Barry's and Kairui's work here has been great. Suren's team (Android)
> is dedicating a full time engineer to MGLRU this year, as I understand
> it. I'm planning to do the same myself. I started by spending some
> time reviewing some patches last week, and I'm hoping to send some
> patches of my own in the next month or two.
> 
> I realize just talking about it doesn't mean much, action is needed.
> I'm hoping in a few months' time everyone feels much better about the
> state of things. :)
> 
>>
>> I hope that Kairu, Barry, Zicheng and others who are interested int it resolve
>> this, however!
>>
>> Thanks, Lorenzo
>>
>> [0]:https://lore.kernel.org/linux-mm/aaBsrrmV25FTIkVX@casper.infradead.org/
>>
>> > --
>> > Michal Hocko
>> > SUSE Labs
> _______________________________________________
> Lsf-pc mailing list
> Lsf-pc@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/lsf-pc


