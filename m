Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9C6ACAC59A
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 15:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 335888E004A; Wed, 17 Sep 2025 11:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30D7C8E003B; Wed, 17 Sep 2025 11:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 222EA8E004A; Wed, 17 Sep 2025 11:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1050B8E003B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 11:32:49 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A54A413B564
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:32:48 +0000 (UTC)
X-FDA: 83899134816.15.2AE7C04
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 5304114000C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 15:32:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=N3n2hgJJ;
	spf=pass (imf26.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.44 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758123166;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V4k5J8VkcsZOGowc/PhE+thWQDtpKbu6223a2JTLS/I=;
	b=VbziEIHGdLZaO/eTHm4fYmL6dRxJl2gsFeGJVgq63uRdQFfuE6k7Ho5nt7fOz3xnrZ2/ng
	WoH/0v79dBFDglf5/wGDrhk4PQYojOWm+1XlcP5C+B6Po3YKLLZCzehGCYM4qWH+Y+nBDr
	uuvWgN23NyaWoe7rbtaO/b8vWtpFIPw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758123166; a=rsa-sha256;
	cv=none;
	b=rL6zqMmuzGN5gJ8h3HBQIBAD6oAwoteugntCZazHZshHpqZb6UjobCO6OenpSgWtn+7fkz
	RPhgNcykODkJRxQOPP6/l0XMIGTnoco2nIczcxmU1isI8Nd9o3hE7f/5w1hj6D5dgH8/PU
	TEEq97i3LYpW/039Kwsue1TXYAgSl9w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=N3n2hgJJ;
	spf=pass (imf26.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.208.44 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org;
	dmarc=pass (policy=none) header.from=linaro.org
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-62f7bcde405so2182590a12.2
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 08:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758123164; x=1758727964; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=V4k5J8VkcsZOGowc/PhE+thWQDtpKbu6223a2JTLS/I=;
        b=N3n2hgJJQsxX1u9bhISuCzFmCRoRNLMlHEUYtTugFCl/fOI5CV+LerKQtLtGOqycEM
         riBhcbstSzdB3Eqhw4pRuN01K62motET9b+dLzUR0BtCE1iUjq68fNxonhf+jVIs7pUQ
         nd/4HLBGBJd3DQS/Ukxwjs4QEzKeZug1aQreFfw4Ol5EuVi49gpnXUo4kCmfWLratGCl
         mVyUY3ih+NyIO48QB4ZhXivPuQAsvQ84+j4dqtQRfp5FzGpKvPjDksCQp3dYSVlmkk9j
         1lJB6ADanc0qRyE+XMSQJLvZWH7UqONVs3E9Vah4q2y/7eJjLXjG9QgKkKPa149ocxCX
         P22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758123164; x=1758727964;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V4k5J8VkcsZOGowc/PhE+thWQDtpKbu6223a2JTLS/I=;
        b=r+HMv46xp7AN8bNGn7OF/zPwEeIpTeBlZYGE6T8cPq5cO1FW1YNn5PLoiUzWpsa0GN
         AKy85aQl6GXBJlgmnPIQ/NrbJZT4Cn2VSWK50nufYd5ii4Qr7ZWKiD3UNlH4M4s073vQ
         1GFaPS7Vop6OMwz6ulcoyc6sPHxXS5CGotBqpuJm8qAf2jQfyk2TyDlpUczepBbJHqg9
         jaosyKG7k8c8BHxN0k7Z3PIOWTp3P6jHJf0v1876dEbsxp1mqXKEZj/sAjO+ylfCLKQZ
         Aog78ll9mTWUHQtYzL0xULxCdHBK3rWyk5IUcQnPG2wL1vGnkbTPeFYQd3aSD/V6NNEe
         9g/A==
X-Forwarded-Encrypted: i=1; AJvYcCUCBVrG6ZtjgtArjIc2w5IDUv1m4s4NXVyk0BHA3V3QBJHIizGz1Xx9MtK9z57xOLr9BT+px3g8uQ==@kvack.org
X-Gm-Message-State: AOJu0YyeNMaW5sTlKRBTk+7GtTbFDJC4Ta3z7H3e9UhjgO2Rqfx/P+3h
	JE36UN69wQ8zcTJ6bJXz27+K8u6gQGKwvmrNdR1K7etXBujffTUI3TBxBK20hfuPK70=
X-Gm-Gg: ASbGnctSuOr7Ab4wJdsNG4AbgMJ0Rw1utxE5jfAgRm7gDBFZgwewGaBESmcPQdjfW+i
	75vraLmycWFiCO7Bi8aCy021vhvQG+hiwNK+GpoJpL5biA6Z0OUUCf0UUJ7OWy0gIYEUVeD4dbh
	4YUuxHbOsHs6enAdz3AL/0Q/dU/DWTkOsiwP3l5ROYhSpOA27+WNn5AeSDkAu2GGNl8yDXwMuoK
	TaGQxgCgvpQUPBwqlaWodr/yxDjaUtXIY+rvHiWXtNno/8HenBc7ysewTMXV745NVLpOdLeJZLW
	h3d5ESuatro22jzgR1IL5nkU7gmL2jZWbAKGzRGzrf7SNKmKsWA3XLamQ8r3sSsNoschmbWdos+
	hMVHlOFNnP2stT3gcRDwsgLNCN1Il/uTcwdi/jopGQTM=
X-Google-Smtp-Source: AGHT+IE8ZMv8HN0yNwSikwv6pMskOhk9zA0LwfuIGCKmhTnIQQy04Vwmljxv3YCiPD4eKH8iHrC6Ug==
X-Received: by 2002:a17:906:6a09:b0:b04:a1a4:4bec with SMTP id a640c23a62f3a-b1bc020111bmr330491066b.58.1758123164384;
        Wed, 17 Sep 2025 08:32:44 -0700 (PDT)
Received: from [172.20.10.3] ([109.166.135.151])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b07b317124esm1395390166b.46.2025.09.17.08.32.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Sep 2025 08:32:43 -0700 (PDT)
Message-ID: <10540b3e-09ca-403d-bc20-b9412a7fe28a@linaro.org>
Date: Wed, 17 Sep 2025 18:32:41 +0300
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC][PATCH v3 09/16] genirq/irqdesc: Have nr_irqs as non-static
To: David Hildenbrand <david@redhat.com>, Thomas Gleixner
 <tglx@linutronix.de>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, andersson@kernel.org,
 pmladek@suse.com, rdunlap@infradead.org, corbet@lwn.net, mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org
References: <20250912150855.2901211-1-eugen.hristev@linaro.org>
 <20250912150855.2901211-10-eugen.hristev@linaro.org> <87cy7q9k8y.ffs@tglx>
 <87a52u9jyl.ffs@tglx> <8df2cf28-c15e-4692-a127-6a5c966a965e@linaro.org>
 <2bd45749-e483-45ea-9c55-74c5ba15b012@redhat.com> <87v7lh891c.ffs@tglx>
 <95ff36c2-284a-46ba-984b-a3286402ebf8@redhat.com>
 <24d6a51d-f5f8-44d7-94cb-58b71ebf473a@linaro.org>
 <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com>
Content-Language: en-US
From: Eugen Hristev <eugen.hristev@linaro.org>
In-Reply-To: <7f4aa4c6-7b77-422b-9f7a-d01530c54bff@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 5304114000C
X-Stat-Signature: nue7diu96kffgisows5m496sobxsq4fa
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1758123166-608555
X-HE-Meta: U2FsdGVkX18ffWTiM+zB3M21rWMx86yBfq/rMf0NburLCXp/ft4uVchWujoX+sA2cju5MA1Ye75mPjt03LYPE4n5uIkF7mRAyVGnuZ7+gPAE7zBfR7QiRqRYmDyRn4e0+Vmy+vfJ+p9IETshUDLVhw32OIrzPZNvU/aVHwXxxc/hUmrWWzFVnXpwAQvG3Dd4ZCI1wxHMDQaRwBll8M2KtCYZiRxagm4cqGdbMbPZk0f6ukvvzsh2aIb3nGwMMhwsEJhPNHkWjDBA1jkRlGQtCQz/BRWbJ4lO9bjaFEu++kIzr1hNhtQ6bn3qla3cK08cxMG8rff5vfgUKYXPac0kqAshQUCr7I92drq/cdFYUHj/lF9VCsvMz3BdVQ9v5hQoCzNSQOwhhr41jhiCK4ueDSXVyXccD389s8Ru+BN6KsqvIBI8n3gYCmYyZAs3zG8IhTJyh2hc6MDd0mRdhO/+0yoRe3sHxHB1pbQ4n8pT3Axw+rsJhnBVIrlAsXI6BjMBb9C0YTjpyU3XRIAQbV6rrtlwxRGQKOy7i8gKDYgiZTKyWsiikmVuOjFAE0qN79tGql2kdYBxfprd7mivyidXJ8BF2QQSOXbIMJ7xsOCntS07Sj6nSO1Wl3Ln0LpSh4XG6TJG9Gd2BzjPT2ypJ6vYclgnRuUomCJ7ZC/W6F/nzdidM2T3D3MAHs3BfvkRnVxfciXhkmqIEwr4laRR+JyzQFPZiFBwrItJYcurRD3EEu0+pADKPMPLdarKecZeqih4hNesPUlxvnEo9C609BytvP/veQUWJU0pkRdk6Jas04WcLPxa8FsI5QSJxB0wqMvXvTOL+PzSvvB5Lf0qxcc7oLxiKWPODsL7V2DfQKFSnufRavhsU9tcrGPj65f5/yPAI7FmatPD0H4cjbKm+IFcIJLsmFmEbkaNKuaW7iDlXfSV1bSNZWZ8+JsXw6ZhWM2YnQj4oPTBMrVWn/xI3dA
 QFEPD/Ji
 OyjL7TIPJdfp7YSmcGD14vbEHTAYixtYl/trVs06SmFMeR4vHOONJ1yuPSQz3TucgMi6SJE6/o6bOMT85q0MLgDUyh1ZdoL3YugCsBRAlBcgnN8tS3VbATxHEyLPIEvhc+sd7JWj86qq8TJRkUeu6g6OU5tSrQxDI24YnU0W8VRS6/JoHSs1koge2UsL5kUjta8uDp1tL2wxllTBF7sWmBPqsMzyARyQgceGzJMuLvOwKh0ADFCNn+4wj+8OaqBcNBjK+6Zrfl4l4jeSWlTgvf+JKV4BJgigv6LdQ3rjblO4JlgfbZIeZivN7hW2ExJGzrgS690dXr0wx5kdF2J6tz9vpenTsx/CrzWPflGFPoovHnR7JJeAHTpuxHKjgGcedl//MdL/ihkRksiJrmui0mrApU0rq69JDXLJDrzC3/WuGy5eMiRF2UYCAceUN+XwH1W+t95hlSe15Sh0C3+0vlSmlZucVlEkmNG8gGCETT1wswgk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 9/17/25 18:18, David Hildenbrand wrote:
> On 17.09.25 17:02, Eugen Hristev wrote:
>>
>>
>> On 9/17/25 17:46, David Hildenbrand wrote:
>>> On 17.09.25 16:10, Thomas Gleixner wrote:
>>>> On Wed, Sep 17 2025 at 09:16, David Hildenbrand wrote:
>>>>> On 17.09.25 07:43, Eugen Hristev wrote:
>>>>>> On 9/17/25 00:16, Thomas Gleixner wrote:
>>>>>>> I pointed you to a solution for that and just because David does not
>>>>>>> like it means that it's acceptable to fiddle in subsystems and expose
>>>>>>> their carefully localized variables.
>>>>>
>>>>> It would have been great if we could have had that discussion in the
>>>>> previous thread.
>>>>
>>>> Sorry. I was busy with other stuff and did not pay attention to that
>>>> discussion.
>>>
>>> I understand, I'm busy with too much stuff such that sometimes it might
>>> be good to interrupt me earlier: "David, nooo, you're all wrong"
>>>
>>>>
>>>>> Some other subsystem wants to have access to this information. I agree
>>>>> that exposing these variables as r/w globally is not ideal.
>>>>
>>>> It's a nono in this case. We had bugs (long ago) where people fiddled
>>>> with this stuff (I assume accidentally for my mental sanity sake) and
>>>> caused really nasty to debug issues. C is a horrible language to
>>>> encapsulate stuff properly as we all know.
>>>
>>> Yeah, there is this ACCESS_PRIVATE stuff but it only works with structs
>>> and relies on sparse IIRC.
>>>
>>>>
>>>>> I raised the alternative of exposing areas or other information through
>>>>> simple helper functions that kmemdump can just use to compose whatever
>>>>> it needs to compose.
>>>>>
>>>>> Do we really need that .section thingy?
>>>>
>>>> The section thing is simple and straight forward as it just puts the
>>>> annotated stuff into the section along with size and id and I definitely
>>>> find that more palatable, than sprinkling random functions all over the
>>>> place to register stuff.
>>>>
>>>> Sure, you can achieve the same thing with an accessor function. In case
>>>> of nr_irqs there is already one: irq_get_nr_irqs(), but for places which
>>>
>>> Right, the challenge really is that we want the memory range covered by
>>> that address, otherwise it would be easy.
>>>
>>>> do not expose the information already for real functional reasons adding
>>>> such helpers just for this coredump muck is really worse than having a
>>>> clearly descriptive and obvious annotation which results in the section
>>>> build.
>>>
>>> Yeah, I'm mostly unhappy about the "#include <linux/kmemdump.h>" stuff.
>>>
>>> Guess it would all feel less "kmemdump" specific if we would just have a
>>> generic way to tag/describe certain physical memory areas and kmemdump
>>> would simply make use of that.
>>
>> The idea was to make "kmemdump" exactly this generic way to tag/describe
>> the memory.
> 
> That's probably where I got lost, after reading the cover letter 
> assuming that this is primarily to program kmemdump backends, which I 
> understood to just special hw/firmware areas, whereby kinfo acts as a 
> filter.

If there is a mechanism to tag all this memory, or regions, into a
specific section, what we would do with it next ?
It would have a purpose to be parsed and reused by different drivers,
that would be able to actually use it.
So there has a to be some kind of middleman, that holds onto this list
of regions, manages it (unique id, add/remove), and allows certain
drivers to use it.
Now it would be interesting to have different kind of drivers connect to
it (or backends how I called them).
One of these programs an internal table for the firmware to use.
Another , writes information into a dedicated reserved-memory for the
bootloader to use on the next soft reboot (memory preserved).
I called this middleman kmemdump. But it can be named differently, and
it can reside in different places in the kernel.
But what I would like to avoid is to just tag all this memory and have
any kind of driver connect to the table. That works, but it's quite
loose on having control over the table. E.g. no kmemdump, tag all the
memory to sections, and have specific drivers (that would reside where?)
walk it.

> 
>> If we would call it differently , simply dump , would it be better ?
>> e.g. include linux/dump.h
>> and then DUMP(var, size) ?
>>
>> could we call it maybe MARK ? or TAG ?
>> TAG_MEM(area, size)
> 
> I'm wondering whether there could be any other user for this kind of 
> information.
> 
> Like R/O access in a debug kernel to these areas, exporting the 
> ranges/names + easy read access to content through debugfs or something.

One idea I had to to have a jtag script read the table , parse it, and
know where some information resides.
Another idea is to use Uboot in case of persistent memory across reboot,
and Uboot can read all the sections and assemble a ready-to-download
coredump. (sure this doesn't work in all cases)
What can be done in case of hypervisor is to implement there a routine
that would read it, in case the OS is non-responsive, or even in the
secure monitor.
Another suggestion I had from someone was to use a pure software default
backend in which to just keep the regions stored, and it could be
accessed through userspace or read by a crash analyzer.

> 
> Guess that partially falls under the "dump" category.
> 
> Including that information in a vmcore info would probably allow to 
> quickly extract some information even without the debug symbols around 
> (I run into that every now and then).
> 
>>
>> this would go to a separate section called .tagged_memory.
>>
> 
> Maybe just "tagged_memory.h" or sth. like that? I'm bad at naming, so I 
> would let others make better suggestions.
> 
>> Then anyone can walk through the section and collect the data.
>>
>> I am just coming up with ideas here.
>> Could it be even part of mm.h instead of having a new header perhaps ?
>> Then we won't need to include one more.
> 
> I don't really have something against a new include, just not one that 
> sounded like a very specific subsystem, not something more generic.
> 


