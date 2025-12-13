Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A4BE5D59F77
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 07:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 161706B0007; Sat, 13 Dec 2025 02:23:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1390C6B0008; Sat, 13 Dec 2025 02:23:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0286C6B000A; Sat, 13 Dec 2025 02:23:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E7F976B0007
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 02:23:10 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A8AD31A0511
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 07:23:10 +0000 (UTC)
X-FDA: 84213606540.13.01676F0
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 899854000B
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 07:23:08 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=PsXrTdO0;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf12.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765610588; a=rsa-sha256;
	cv=none;
	b=xuKwTil+JYHbvf1HyUwn/7kgxblo7LsCBQk8IIhQe1UWf/5O+FocrnbmXvrKCRJGxgMYiJ
	2qG6unpmOA4VBvoUnbOK6qHSgNvzvQ1Qe/W1bPEyXOZCXrNTuAnuaU2KqOG/c4lzq1LwYC
	tia0dzd3GSwEgeyHUWiiewZax4rYBvg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=PsXrTdO0;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf12.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.214.177 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765610588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qS/a8O0BbZSZZsXyGtd7peZrK8putFww9+X+USFCeDw=;
	b=s25CuHnl1/VzmHCi5uwQY+WEx+fD/h1StHVAK/FHso3b9Xk+JYiMyP/ksZ4G0CgtAi4lS1
	+9y1nSWy0Ld3jGgZwmfE74ZQkSZtiEblLjolHCDzlo5Dg2mkQamP1WuRSp9PnYY4KYTF4v
	w/Hf5h04IjQs+dh0Dh/r04ITlKkxKIs=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-29f2676bb21so15904505ad.0
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 23:23:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765610587; x=1766215387; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qS/a8O0BbZSZZsXyGtd7peZrK8putFww9+X+USFCeDw=;
        b=PsXrTdO09ouRbYNBstlYnK+RcWGzTAUYUUu78HIXI85ZfEhlNI6hSVpOOT0LI9ItSA
         vk7+KW2Br7jo1eUyp+v0h0tOVZ0V3oucHiGerHSsRjt8BaNYprP1dl+HKperMAUhjzc4
         ocalq46wq7uzQOwes4Tvm6gxi7hJd5WUwFApuQQxjmYnoGrc9iYO/xghiA1qfF6Q8CiQ
         x8cvF5hr3GQjNy4/b4xMluI/6mSggjkmKWu6MZjT/l1DFcpcAL3JSDZyoREdSYuMRxEs
         Qa+sNkVvrgriG3YvH70tApYm8Jdtod+cte6Qk8ybn05LnQq87RuGcuZdIEoTYRA4xzaQ
         y/yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765610587; x=1766215387;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qS/a8O0BbZSZZsXyGtd7peZrK8putFww9+X+USFCeDw=;
        b=Sj2xSQ4g7nvj/JFEiqcFhT+nJ5aAVIt1Ruyn32L5JUn+lYtFmFpXWCnPoCO8yPCu8w
         Zry9Hpkd9AGlQBkELr6WkrMJeLvOfAtY9sos8E7x31Pjvkq1BRxPKKTS6MCx94F5DrHx
         9S7ZaxnuXyWr3MHgrc8SQlApfPqmTxPs/L619cWxWskM9St3UF6iXrvjFwrWG7xHZV/w
         AFkVtRmlqpABRV79bkbT+4ASwg0jdYYLDtOMZSLmuW9nyTmJ/iK/v93m5RYa+hMn9cvP
         ok0qrI6K2TRTqOD2dx5oVjgAihc02KeZBDSGOxWNdO+Gqa3CQXv8NYQW+9FGpOkY+ZKq
         kqOg==
X-Forwarded-Encrypted: i=1; AJvYcCX8Tv36QkaLvcO6LN3vtR0e8ru1o3ViNqwQZ/O7ADSqMPRv/++F2RzPIQ2CLJrFIBEACpux3r3x2g==@kvack.org
X-Gm-Message-State: AOJu0YyvViID7eHN833QjyT2oHszgPCQq6Pkk4D+zKFdHGXK+qZ7NN+E
	tiGREKykWsW1gN11Ot4XagBWoB+knfYbG0z6Y1cQAINF+1u8MpfD3/aXwqDyFNTKtuI=
X-Gm-Gg: AY/fxX6IsvHKlwXjQkWFbT0l2t6zbTHF3Fs6tmRh08L6iwZC1v34aaMnuMT2OFx1HfT
	l5X1j13fI6wrInN2vdBZpBcZG7tX29tD4ediNTxuyyUel0dtOyY5rU6ye3sJLSqVlgFYIVrn5Rs
	W7hPK/E7kw5TcSbX9qFlDbawnbs6NAvidpy/RP5rBMl/SHg2sSRbA8IN1wcajo5EYWDW+SmTI9H
	qmcJdmHgSxWQveFhMbaQFfmQ2+5QF+xY9ACqRzH8Zp7tYFA0YLZxpI84qpL8s7MiCfNYosAEipw
	pGCzQjXpBzr5JvOKo38cgK2E0Rbe9XdkST6oMgQesNygeRgLnKpxiDZwPA1TC6LsdT6lHGv0ujz
	wLAryoj+waQ9E7co3mOCUxN0d3Er+CEh4JL+BRS34Lrj8B6h+ro9ShZxS6DhPFPfAMzq4PnauYS
	ZROE/HpKWV4s/3OgsDA+SUrZJAJqMyDJ/nK/knvOZPU6F8MtmmbYM=
X-Google-Smtp-Source: AGHT+IF5ZAK05FTZM7z1I/Tfu2uwtqip2Rr6c/twbgvqZujsfkv8PIP29+IUmV2/Et+MT9YWs2FBBQ==
X-Received: by 2002:a17:903:2c07:b0:29d:df04:fcdf with SMTP id d9443c01a7336-29f2436dfb5mr47558295ad.42.1765610586985;
        Fri, 12 Dec 2025 23:23:06 -0800 (PST)
Received: from [10.200.3.203] (p99250-ipoefx.ipoe.ocn.ne.jp. [153.246.134.249])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29f2563b116sm39121255ad.102.2025.12.12.23.22.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Dec 2025 23:23:06 -0800 (PST)
Message-ID: <c3db6ccd-dfc7-4a6a-82b7-3d615f8cab4f@linaro.org>
Date: Sat, 13 Dec 2025 09:22:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Introduce meminspect
To: Randy Dunlap <rdunlap@infradead.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com
Cc: tudor.ambarus@linaro.org, mukesh.ojha@oss.qualcomm.com,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 jonechou@google.com, rostedt@goodmis.org, linux-doc@vger.kernel.org,
 devicetree@vger.kernel.org, linux-remoteproc@vger.kernel.org,
 linux-arch@vger.kernel.org, tony.luck@intel.com, kees@kernel.org,
 Trilok Soni <tsoni@quicinc.com>, Kaushal Kumar <kaushalk@qti.qualcomm.com>,
 Shiraz Hashim <shashim@qti.qualcomm.com>,
 Peter Griffin <peter.griffin@linaro.org>, stephen.s.brennan@oracle.com,
 Will McVicker <willmcvicker@google.com>,
 "stefan.schmidt@linaro.org" <stefan.schmidt@linaro.org>
References: <20251119154427.1033475-1-eugen.hristev@linaro.org>
 <bf00eec5-e9fe-41df-b758-7601815b24a0@linaro.org>
 <5903a8e1-71c6-4546-ac50-35effa078dda@infradead.org>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <5903a8e1-71c6-4546-ac50-35effa078dda@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 899854000B
X-Stat-Signature: qqewxrrnhrimzjzjz6bhq7rpf4k8xfxy
X-Rspam-User: 
X-HE-Tag: 1765610588-469904
X-HE-Meta: U2FsdGVkX191I1RpCCCP2tpIGFcsoBy68rHLYpfK9VMAhzzUAk08SlWplCjiBWTkeEf3ZL1d0vLj9WGQlpC5WBcyuXk1fOABhkGEJkWYG3DZAifsaZ5WAnrLeJRS5NpczL67wC4yS9BOa3FYvHm073yrH1PsNQYMWSqJMaqxImgRL79i1HDTXCKh2/u7Glm9ELo7VtrF4bqn0vNggA8Jed5AjxgKpaGycRJu6PnSmFWiV8CHBTqLuIFjHklykrowFKcYOZBxMO+eguBEvwrnswTitppxR4idZa4lUVRJgLbHMUd5iXgYWj9T8CS+1qdNSk++5olMHpQvzQ34tObxiyF1AZtkhEIgjA5OvZ27sZopTMp8LJmBewNRdtYyddu+mxUl2K/0+OxeHuktHM3rh+9zwSxAVoEgp6ubMTnIPlyv1s3yzGcsyQXQfMpjoteHVrNB9mR58uwCUX5DAJQ9DckxdrOndjQXlVB7joL4Y3F11aP1v0WrrL3JeWEme7X3UYF+p8KzOaDFgbyrunDfzNMcEDJRiLLHC25fgHeo6GmOT01/G/hJjRGvW5RFFgL5uXVQ7ADHoZsHhGKzpFN8y7fLRbwy0Yk5Fkgbjx89JTmezGJnRdhMuS5tMubzoyy4z1iSYFlGTEEiTVfUClCWIr6Ck5QHkyO2oyAYCmRyqC8YVqxKkf7iHDRcop0Ueg/Yrlc3IoxIxAuRsMqjSRTVwFulVPpoEXJpVVVGvnihU6JTe4sYKUy2M4mYZGN3ks3iUZ1xRUODey4ehmhee+qdgovSVHLDxgTWnObAOgMHmafRc7RtWbCxCimzc4mO2OYdqlUuF6XX77/y7kIpxPgkD273hjZcx2irbBJfdQhse0hgwwzzv+3GQbishJYiGp8Kkzv8x74MPnJXwjU3JgSeFFdnpZOWRyhzDZ1P3NiUaqr3IDxkh/L5dLIAySNzN027tlr2po4RgfXqOsjMYJi
 Y6u9dGA0
 ep7HAjQc0Fi9ijhFph2nN7MG2Q6uOTfDA6IPUkN75CnuzQ7vgS+OUGz6BSD0+gaJ39mnxMqk9ysWIDo712iogDA+1kZHtbDXjRBBHGm9fV4+1OFJ1NnDoLZoYNIGEfL+5TlIJ/UZ+fQC9FhlXlg2sPJBB+nu0hxioxkx2xb31+SramhlV/G1bI+9v+uwgMeyopD4T5FU9sw5F2f85CbHffmk7aV6Hewwq2Tw8wH+C7GDxv6WlxXeqb9mefLQnwCDQVUR3RgjuCyT4pplmFqbyfUIKqDIDN5Onkzhn/YtZ41IwweAkKslZM9iqVELa5zRSj1X2LBx+OLE/Kw/xMjhjBZdig8NTy0WRiiMPdobeYLhUASvkQnRq6hFQL/P7HkBUzqsFHIOIgwdr1ibbsLv0p6jictRaV/mMJyr+Ir87u/39okXchZaBGIHp5fVD3SD2zKp1/zwXJlvqhub2LILlwhlriEI1bUDWIhTwGx8xu9eF7QCNE9tl49jvJWGGlfwMOSQsD6KIJMlpyyi9/2ijsgSotg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/13/25 08:57, Randy Dunlap wrote:
> Hi,
> 
> On 12/12/25 10:48 PM, Eugen Hristev wrote:
>>
>>
>> On 11/19/25 17:44, Eugen Hristev wrote:
>>> meminspect is a mechanism which allows the kernel to mark specific memory
>>> areas for memory dumping or specific inspection, statistics, usage.
>>> Once regions are marked, meminspect keeps an internal list with the regions
>>> in a dedicated table.
>>
>> [...]
>>
>>
>>> I will present this version at Plumbers conference in Tokyo on December 13th:
>>> https://lpc.events/event/19/contributions/2080/
>>> I am eager to discuss it there face to face.
>>
>> Summary of the discussions at LPC talk on Dec 13th:
>>
>> One main idea on the static variables annotation was to do some linker
>> magic, to create a list of variables in the tree, that would be parsed
>> by some script, the addresses and sizes would be then stored into the
>> dedicated section at the script level, without having any C code change.
>> Pros: no C code change, Cons: it would be hidden/masked from the code,
>> easy to miss out, which might lead to people's variables being annotated
>> without them knowing
>>
>> Another idea was to have variables directly stored in a dedicated
>> section which would be added to the table.
>> e.g. static int __attribute(section (...)) nr_irqs;
>> Pros: no more meminspect section Cons: have to keep all interesting
>> variables in a separate section, which might not be okay for everyone.
>>
>> On dynamic memory, the memblock flag marking did not receive any obvious
>> NAKs.
>>
>> On dynamic memory that is bigger in size than one page, as the table
>> entries are registered by virtual address, this would be non-contiguous
>> in physical memory. How is this solved?
>> -> At the moment it's left for the consumer drivers to handle this
>> situation. If the region is a VA and the size > PAGE_SIZE, then the
>> driver needs to handle the way it handles it. Maybe the driver that
>> parses the entry needs to convert it into multiple contiguous entries,
>> or just have virtual address is enough. The inspection table does not
>> enforce or limit the entries to contiguous entries only.
>>
>> On the traverse/notifier system, the implementation did not receive any
>> obvious NAKs
>>
>> General comments:
>>
>> Trilok Soni from Qualcomm mentioned they will be using this into their
>> software deliveries in production.
>>
>> Someone suggested to have some mechanism to block specific data from
>> being added to the inspection table as being sensitive non-inspectable
>> data.
>> [Eugen]: Still have to figure out how that could be done. Stuff is not
>> being added to the table by default.
>>
>> Another comment was about what use case there is in mind, is this for
>> servers, or for confidential computing, because each different use case
>> might have different requirements, like ignoring some regions is an
>> option in one case, but bloating the table in another case might not be
>> fine.
>> [Eugen]: The meminspect scenario should cover all cases and not be too
>> specific. If it is generic enough and customizable enough to care for
>> everyone's needs then I consider it being a success. It should not
>> specialize in neither of these two different cases, but rather be
>> tailored by each use case to provide the mandatory requirements for that
>> case.
>>
>> Another comment mentioned that this usecase does not apply to many
>> people due to firmware or specific hardware needed.
>> [Eugen]: one interesting proposed usecase is to have a pstore
>> driver/implementation that would traverse the inspection table at panic
>> handler time, then gather data from there to store in the pstore
>> (ramoops, mtdoops or whatever backend) and have it available to the
>> userspace after reboot. This would be a nice use case that does not
>> require firmware nor specific hardware, just pstore backend support.
>>
>> Ending note was whether this implementation is going in a good direction
>> and what would be the way to having it moving upstream.
>>
>> Thanks everyone who attended and came up with ideas and comments.
>> There are a few comments which I may have missed, so please feel free to
>> reply to this email to start a discussion thread on the topic you are
>> interested in.
>>
>> Eugen
>>
> 
> Maybe you or someone else has already mentioned this. If so, sorry I missed it.
> 
> How does this compare or contrast to VMCOREINFO?
> 
> thanks.

This inspection table could be created in an VMCOREINFO way, the patch
series here[1] is something that would fit it best .

The drawbacks are :
some static variables have to be registered to VMCOREINFO in their file
of residence. This means including vmcoreinfo header and adding
functions/code there, and everywhere that would be needed , or , the
variables have to be un-static'ed , which is a no-go.
This received more negative opinions on that particular patch series.
The annotation idea seemed cleaner and simpler, and more generic.

We could add more and more entries to the vmcoreinfo table, but that
would mean expanding it a lot, which it would maybe defy its purpose,
and be getting too big, especially for the cases where custom drivers
would like to register data.

How I see it, is that maybe the vmcoreinfo init function, could also
parse the inspection table and create more entries if that is needed.
So somehow memory inspection is a superset or generalization , while
VMCOREINFO is a more particular use case that would fit here.

Do you think of some better way to integrate the meminspect table into
VMCOREINFO ?

[1]
https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/

