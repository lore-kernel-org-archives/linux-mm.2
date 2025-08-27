Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54339C8303F
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 04:47:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CA3F6B0340; Wed, 27 Aug 2025 00:47:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77B1F6B0341; Wed, 27 Aug 2025 00:47:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6908B6B0342; Wed, 27 Aug 2025 00:47:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 555386B0340
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 00:47:56 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 09DD61A01F9
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:47:56 +0000 (UTC)
X-FDA: 83821304952.06.93FA928
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0A1F740003
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 04:47:53 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yvxvw3iV;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756270074; a=rsa-sha256;
	cv=none;
	b=FZaFbKVlE9E+wrZs8hBT/zRZU0t/2OiMxuMm0UJfsf2olvfmbAVSpKYgdrelk5qI96ISI2
	4mkX6jGDquxWjm7ZhIkrkgIAqxXyIqnsHtcNW7CQqicHhR0khY0aN/FNX5/WOi6NAPu9P0
	1EHlrpPMGhSG7u2qNSge3958LTHtbxs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Yvxvw3iV;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756270074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wXAK34i6n0IW6+f/U/+fv+MxOP0/U5XW1xTt30ESlvA=;
	b=AaiZkFGE41k0IZdJwpEllaMSwkloMhszAsxRl6DtKvqufuVUFktEdBmHPIkL465cAAqnpZ
	C0bt+/pyxSd/DKPAdFRwERZguz+8JFcImPOYnBZ0CTKjPapkiXUn2rUc4NkVfcaf5kyBYV
	BmUf0eBXB4C/lvPfdNiJAfCVWlvbEYM=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45a1b0cbbbaso55556295e9.3
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 21:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756270072; x=1756874872; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wXAK34i6n0IW6+f/U/+fv+MxOP0/U5XW1xTt30ESlvA=;
        b=Yvxvw3iVwjRBmEupMJZLd7/w/i3npzQbyHvQw37g6u7J6BGMetCOQGFvTP3hmp8KAE
         +730spYiKfGvDziGRGXq6+rYThwZ/98/aSTf3IxPKkayaNDKktZyIH7LeGtlsghoe2dt
         HG1BOns6vkDi//Rrg9OR3Cgpg5yvboc2KDRNUpMaolcEMr2/QOt2RVd8loieCPhmycsy
         BRPLfkleaw/z+TdijlfW5TBd8D/BvynFHd/dUoyljOpZCUzRMMJpB/ftj5UYDFxW8weO
         AtslC0HujQW+LVMv5yEupZ/mDqpaJyUncMWp/0dE8WQAauRBQYwWKl9EI4ewFw6/0y8c
         t5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756270072; x=1756874872;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wXAK34i6n0IW6+f/U/+fv+MxOP0/U5XW1xTt30ESlvA=;
        b=N7fKePiJR/yFOOXKFm6wjs7jxp5hJ2ozni2IVHslfmsNoSGVkEXKs/AOIWMDohPMzF
         e5amnYjffR4+0IVLIFAuiLDGy83n2mNlFrPc8r0jRvrI7LPu39Jvyz19j4jzGVdx7uh8
         NXr6abs4Rp5ho/NNTsN5eSgDg4Am6YhAMA11ib5izM0OAXLMccmQuCLbeWCSuk55FIxj
         lrfxSWJAFhtzKpLeD4vA3r21ziOwbVODJsZD8qKXpYMxyhrphG9qrzgcL1rjtcLj54AJ
         c9bno6z5GyfraWWGDXzIMfo8yVcB9jmE8ryu+ZZW9ruokvOHjVTtz6FgnFkyd6BV206s
         BDXw==
X-Forwarded-Encrypted: i=1; AJvYcCXQoiv1BQZwbPqBfRYyxNoOTrCv/2r+SekdkpA+2r3Jd1xJvv3wRm0gP3ghI1l+qvh0gzl/85XtkA==@kvack.org
X-Gm-Message-State: AOJu0YxaD7ItdxiOIBvpyRsvRw9ExW41Q3vSAiGGLTOJkVZrKz31iZOM
	VGG7f2saPTvTyyi9iqe9/qKxEXuvmyJbUb8mgQpIZdZmGD9dG8CRoaqd
X-Gm-Gg: ASbGncs3MoMQGk7i9uvqQKCCqfzq6pzR5E+kh501UY4h4wposJst3X4LQFOGNWGWonw
	o+5nYKEosbyk6bPZ6MZUQjwmjCOdR+fYKbQ8OV4Nwb2fuFKEMBBcmVgP9VB2nu4PueTnY7XdipD
	DGLH0/2o9tGd4Q56534PMuifjV1SH3fLi3KHiwNw0zAj6RLJSE8KeGHLGsz8mq4wD7kF+A5ndtB
	sp7/LtaXS1u5WofpNKCDeh5nWSWS6VAM5NEBzUsrm16EV8O/LMALOmwJdbUVneiNCtRqieoElkR
	dvdaYEJGBmS2v3S8XmfO+0G027qzCsa1tujkLNGWjU6rqTmiYujUXnacRqG6xgQ+Mx3Y8QB8Auk
	HCmifzL+O/IRKAjthB6ILYQ+gg/5tVwmhZRXZ6zxuIf7ACVC8v0jd7KnUCHAhrVTJbLVqXYQHZc
	kOr7RXX5JqnK65ZzAg7Q==
X-Google-Smtp-Source: AGHT+IEYWtBY/v69iHdBMm2oOUl/phxTLS9NimBh75e+tw8TfgIHGCKLX3FPzWtHINS3KQsJxoZh6A==
X-Received: by 2002:a05:600c:c87:b0:456:f1e:205c with SMTP id 5b1f17b1804b1-45b5179f338mr152920525e9.4.1756270072226;
        Tue, 26 Aug 2025 21:47:52 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23? ([2a02:6b6f:e759:7e00:1047:5c2a:74d8:1f23])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b6f3125ccsm13026565e9.19.2025.08.26.21.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 21:47:51 -0700 (PDT)
Message-ID: <54cf2f4e-5496-45c3-a22c-aa8b38fede47@gmail.com>
Date: Wed, 27 Aug 2025 05:47:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 0/1] Try to add memory allocation info for cgroup oom kill
Content-Language: en-GB
To: Suren Baghdasaryan <surenb@google.com>,
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: Yueyang Pan <pyyjason@gmail.com>,
 Kent Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, hannes@cmpxchg.org
References: <cover.1755190013.git.pyyjason@gmail.com>
 <6qu2uo3d2msctkkz5slhx5piqtt64wsvkgkvjjpd255k7nrds4@qtffskmesivg>
 <aKdw6Pkj2H4B6QDb@devbig569.cln6.facebook.com>
 <tiwa6wnkdf6q2pfchxbbqb6r42y7moykqumvnzauckhavyemg2@zc5haja5mlxs>
 <CAJuCfpHyXWwrKkFmmbHTGtG9L-JK2eCt03ku9364i4v6SJKFbA@mail.gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <CAJuCfpHyXWwrKkFmmbHTGtG9L-JK2eCt03ku9364i4v6SJKFbA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0A1F740003
X-Stat-Signature: peie7xn5hwxz16r7pf51twih89iwhkmm
X-Rspam-User: 
X-HE-Tag: 1756270073-586208
X-HE-Meta: U2FsdGVkX19Q3DjvJ0BZvm+RZi3ENDfaFtXhQPqKfSObwx0PWwAy6MNsUAl3EYpfgP1waC4j1eTMPbp7G9Z591wsdqfgqwHMF5m2ixs48RPQuPi1OaQmmtJVRAbq3Te43OmEgVgn3FGr8Kx4Cbkd/gqwjNwvah2cMhZ8GugHFcwnMLerwORpV1br79ssqKw0DzjPs0wZ9NSxAprnJVC7Dp60zoOIkUHHYAC5OJZJDTxSqRCyimnQQLlWEKmPMPM3zu+KI5MzmzTjQPlW9mDY0XptCWaQN6oWK6Q0OOakcAx3ZLbY5Tnlv3bb3PbWHRjpuZZJgg7Bab3vh7k2yyLVVLeW+lU2oOsINLSm48v9M5tc86jNB0AcemuANQpA45eD51HBsiLOZsdf+vANzi/98MLogGLlekneFmd2aI3uYQM7sbh58A54I4UlLVYzlEhXcX7nop6ctleyjaJfAKDQXbR8o/VbOgqYL5ZBh3OG8YOlYsHQ3cohTt+ozfIzPF0nh/7tUVLbzZni3tow69lUlFpbq4Thh2WjqEZ0nBRUrSG2khmJV5brFwEr3nLtVSV01tfwA14HWtDUBRR9qoHKGHUE/B+MJwOEbIhwDIAxOArMgm1a2aCJoteaRffcmCY1CxNSqAdSbiO94/QoiplnT4SCNPW2ZgpXYYvtmvBElye+595jnIkk0UGbahtRIlqt886NgT8Lm/jDC+P5TYmw007q9kCVL812guknpGxpbE/86s64lpFE3ISa4+uClHZCspObtIRgN6VBa06vkN5FItDU1IQtztWm4vJwxB+r9PMnEt9Dug6Ddt6BnuXXBbOcgc20kV7EXCzKzB0tGo0iTGSt8GiVx0Mo2U+6Wa6tQhwMbNEbb25aaDTgm0lzWUXGhAn1ovoQRjTtDnm7T4lO5s7VdDwNaRMWiuAjqeJHV/ifjSfTqOtObkpsk5szRstgcodqY4FgzO1KFmFGVZK
 Y5n7/Dvj
 MF4P3riTJTrUvZ02Z2D7pBzxol8+UOh6XZD19/Dk0XSiMfPbuUoQunaxW6VBBhShR2Jv5P9DL2D8oi9AZzLCoN8PZZCUz9Zy5YqZko63lICPpo18nk3KS7hiv9Qm+KWlzRMQPT1TtW0dDh/G02+UG0SyqYQ6L06mViPq3ito1bWw7hcb3zgg3GdeWDbv1Swg/5vGBfPpiNueSOHlYfGDn31Q2+Eb9T1imLKDd4QyO+fnc6lUYUINH0Ullw2OiBIi9XQ+lP780i27eIx+BzkUwBrA4I9wpuan2IN5Xsj3wnAtw3AZ9o0FR7cuENHIdz9CIuQD8FE95h/mONMTVDzyWLbjv62JJW27MwDs7lUikfBCvgNlx9rm88nC2e4N/fp/3iQePnIbp/dukWZpZlIiW+KK3siHZ7DqnW8yEe4mhi/GYVJjblUglXi94ytJ9mIJxcYO9gezF/RpTlD44SuvoCBAmmvmT5pIVzWJ2hPopI0SadNANii4RJp9i97LgUmJBPIK9XO6AqvnROFdRqlXFTyWMceKeqQ8KDWu88B7JCgI8cCFSP+ONkhz6mQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 27/08/2025 03:32, Suren Baghdasaryan wrote:
> On Thu, Aug 21, 2025 at 12:53 PM Shakeel Butt <shakeel.butt@linux.dev> wrote:
>>
>> On Thu, Aug 21, 2025 at 12:18:00PM -0700, Yueyang Pan wrote:
>>> On Thu, Aug 21, 2025 at 11:35:19AM -0700, Shakeel Butt wrote:
>>>> On Thu, Aug 14, 2025 at 10:11:56AM -0700, Yueyang Pan wrote:
>>>>> Right now in the oom_kill_process if the oom is because of the cgroup
>>>>> limit, we won't get memory allocation infomation. In some cases, we
>>>>> can have a large cgroup workload running which dominates the machine.
>>>>> The reason using cgroup is to leave some resource for system. When this
>>>>> cgroup is killed, we would also like to have some memory allocation
>>>>> information for the whole server as well. This is reason behind this
>>>>> mini change. Is it an acceptable thing to do? Will it be too much
>>>>> information for people? I am happy with any suggestions!
>>>>
>>>> For a single patch, it is better to have all the context in the patch
>>>> and there is no need for cover letter.
>>>
>>> Thanks for your suggestion Shakeel! I will change this in the next version.
>>>
>>>>
>>>> What exact information you want on the memcg oom that will be helpful
>>>> for the users in general? You mentioned memory allocation information,
>>>> can you please elaborate a bit more.
>>>>
>>>
>>> As in my reply to Suren, I was thinking the system-wide memory usage info
>>> provided by show_free_pages and memory allocation profiling info can help
>>> us debug cgoom by comparing them with historical data. What is your take on
>>> this?
>>>
>>
>> I am not really sure about show_free_areas(). More specifically how the
>> historical data diff will be useful for a memcg oom. If you have a
>> concrete example, please give one. For memory allocation profiling, is
>> it possible to filter for the given memcg? Do we save memcg information
>> in the memory allocation profiling?
> 
> Actually I was thinking about making memory profiling memcg-aware but
> it would be quite costly both from memory and performance points of
> view. Currently we have a per-cpu counter for each allocation in the
> kernel codebase. To make it work for each memcg we would have to add
> memcg dimension to the counters, so each counter becomes per-cpu plus
> per-memcg. I'll be thinking about possible optimizations since many of
> these counters will stay at 0 but any such optimization would come at
> a performance cost, which we tried to keep at the absolute minimum.
> 
> I'm CC'ing Sourav and Pasha since they were also interested in making
> memory allocation profiling memcg-aware. Would Meta folks (Usama,
> Shakeel, Johannes) be interested in such enhancement as well? Would it
> be preferable to have such accounting for a specific memcg which we
> pre-select (less memory and performance overhead) or we need that for
> all memcgs as a generic feature? We have some options here but I want
> to understand what would be sufficient and add as little overhead as
> possible.

Yes, having per memcg counters is going to be extremely useful (we were
thinking of having this as a future project to work on). For meta fleet
in particular, we might have almost 100 memcgs running, but the number
of memcgs running workloads is particularly small (usually less than 10).
In the rest, you might have services that are responsible for telemetry,
monitoring, security, etc (for which we arent really interested in
the memory allocation profile). So yes, it would be ideal to have the
profile for just pre-select memcgs, especially if it leads to lower memory
and performance overhead.

Having memory allocation profile at memcg level is especially needed when
we have multiple workloads stacked on the same host. Having it at host
level in such a case makes the data less useful when we have OOMs and
for workload analysis as you dont know which workload is contributing
how much.

> Thanks,
> Suren.


