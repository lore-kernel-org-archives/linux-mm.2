Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00982D59F6D
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 06:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5180C6B0005; Sat, 13 Dec 2025 01:57:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C8C86B0007; Sat, 13 Dec 2025 01:57:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DEA26B0008; Sat, 13 Dec 2025 01:57:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D1DC6B0005
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 01:57:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A7DB2C055E
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 06:57:14 +0000 (UTC)
X-FDA: 84213541188.03.6920654
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf05.hostedemail.com (Postfix) with ESMTP id 010C3100006
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 06:57:11 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2Wp77FJW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765609032; a=rsa-sha256;
	cv=none;
	b=ElKuLsmBf8LYTbkxO62C+GtUkE+hLJ6OiZoscGF9xCHMB4Fdxz1xRU8pm1yMHvma7irQKN
	eK//UwdHp8llqlN86IHm6fXR85rpjVT4BxkhYYCWNBK6dIMtvMG58SSOlbsGSOhBU74tt/
	2ORU7tQfM4fejZX0qacc52YBM8VFYp0=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=2Wp77FJW;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf05.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765609032;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UxVyimGao7p0sqobtYKOAtYcaEFn3ktSbdCzD3T7UOM=;
	b=fhQUaC22pB3OPeTGh5ZjFsIvJrg8choC/GRIl+cW9lkx8HtgVUhq8qcZM098OfrIZ1P4za
	XX1St2rYtGrWCnd5WyvRLbHEEqaAqH/9meBrseVOv1DbjjhGfdsDKQ5OosE+v6cu4Aev79
	hhNxiohh/8Pv+tE4s4w0bquoJyBPe3c=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=UxVyimGao7p0sqobtYKOAtYcaEFn3ktSbdCzD3T7UOM=; b=2Wp77FJW1QESi4u/Ikpi/5sH98
	2n09GBbxkBnzNeqR7/bLDordnvS0VbZ3ISU+6B/iF2FyALRRwyWaFgYrLrm68hMGQ2TKr1AP03xBx
	9Hj4cmilLnMyteyZVGWxdsdye3IzECUwZu/a632Vwt8dF5pSQQXA6Vn3bfCgeoTEFOd+la+5ycefT
	XbQ4c0xVUBZFsNadBc+Mhun8jPAM8YcsnRiMciyE48aFXqkhLimuJLnXbledwuEV8VQe7Kvt83dHb
	0NbFfYdlDF761J3TDFvi0J0e9S5TE6CgjsgfUs1TyQ6oCF4YjYcfpOL9wbOhOxqnSDYqSmSLGj2Ii
	eejUXsVg==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vUJYx-00000001TgZ-1cAT;
	Sat, 13 Dec 2025 06:57:07 +0000
Message-ID: <5903a8e1-71c6-4546-ac50-35effa078dda@infradead.org>
Date: Fri, 12 Dec 2025 22:57:02 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Introduce meminspect
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
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
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <bf00eec5-e9fe-41df-b758-7601815b24a0@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 010C3100006
X-Stat-Signature: pxb7fynheswfbyu1mam964kpbrfc85n4
X-Rspam-User: 
X-HE-Tag: 1765609031-628215
X-HE-Meta: U2FsdGVkX180DjUWAiQTtNDaIVbmXWhBU5BJVAsBMIOgj+NtSSlGnQrvOlroT/0zQdmiF3mdJKBPH7hhvhpATp9DZG8Ex7ZoEqHT+f2lwNpvw9YLhrucfQLC0iFTVX5Z4825M/jMim8A/wEB3+/BP6ebKDqWZHTWpWE/HBDRAJx8k7fcfbF/fRq0bn6Aj9e0gJDm/jGQ+312W4lDCwU7SD9fdZarH5eYcMnqq7O7R+n9QWZusSxRomBhULS0GusWiBNwn8owmIeJ58WUxzCaoAJNTwYVteVFDJ7LoYUlp9RIUataHzBknylI/2AiM6qbp7eBt1dbifj/Vrje5jHiUDN2Ev3PCAAV/WuAo10L5z9m1bBk93ux63C891bX+3akqEc0N8DrUSdPLfoT3Hfsf+T1pK+oClEnCWZJwjnlb8gGfqYTNh3wQ4cqnXLLL2fPu4knhC+Bxwb7NdPf6ZL/XgMS9FSeviSY4YlKaQlaqmtVr9GlY4HfdLahM/E/L/q9GPjmv+aI7x1kjt93VTxpUldRwmhbje6i4rSHrK0meqUgZmHPo8kuwgfhR9WzUO6mOs5tCr0rFywxefSOnZDQe3NkM+1S91TEpkQw4/SLFdP84o1nEbOJso4XTkIu+l4fxSL14AuBu2aem8Qnxl/Aku7egajfhlLLjFHa+sZn10b7QwYMKBzZmrQCdvJCwksTL9iyju8BuVAAXXCGtte+xoJcjQ/6QqmbGcvHFZfyKpgIS7v5U77g/BVfhnFzvwZuKFLqCKxtUTXfW/pZ8pVAB6j7aU9dLms3CQZ6O7ScP5OceLE0KxFcH5flB940FTK6X6vDivwZYWC0FktTD5DRk8CCDc7Zz9zBK72MQcS5Gv7Tr8bjtp9CxFwRLSQ2YrFNJHjwAwAIgBjsqlKI7jeH+/xUcwkdSDMwgVVnHRLic+EA6/ItfIHeAjtfAGnY+th1/FxrFX4OAg5RAtpnihK
 H+GsjdFR
 or5KF3mC074AelBwg60CVTVOM438sdawQPRMiatfMKnh8MWJlkDVzLIZhvUSpRdrSBTp15Vj1giB/rDloZd6qJ2kt/njjtfm5KB3cLZKDY9gHCjQOU/7J9xYH1s+OwJQq7tw1gtNumfhaMkuLYJwI/mCYE8dRtbcuX1dqBzLjyawyjhefuJ8eMzp9Nu1aGeGonFFVdPrI5ymRhikRczwOXo55srOB3JuKfRXSTsxGDQFdqvXHG+U7NNEcEyTagtV3UtfeofKflVdTJh7alLXo3ZVeLoM32w/19B9KR19aZFVAdngqD27EPyxsqrjtaxQD6+tcUw8swA6ah8Rp1egNDVqBXlX7wDLT0Vm22k7gw1+JANEeWexBBX6xYrSruiB8aOaJ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On 12/12/25 10:48 PM, Eugen Hristev wrote:
> 
> 
> On 11/19/25 17:44, Eugen Hristev wrote:
>> meminspect is a mechanism which allows the kernel to mark specific memory
>> areas for memory dumping or specific inspection, statistics, usage.
>> Once regions are marked, meminspect keeps an internal list with the regions
>> in a dedicated table.
> 
> [...]
> 
> 
>> I will present this version at Plumbers conference in Tokyo on December 13th:
>> https://lpc.events/event/19/contributions/2080/
>> I am eager to discuss it there face to face.
> 
> Summary of the discussions at LPC talk on Dec 13th:
> 
> One main idea on the static variables annotation was to do some linker
> magic, to create a list of variables in the tree, that would be parsed
> by some script, the addresses and sizes would be then stored into the
> dedicated section at the script level, without having any C code change.
> Pros: no C code change, Cons: it would be hidden/masked from the code,
> easy to miss out, which might lead to people's variables being annotated
> without them knowing
> 
> Another idea was to have variables directly stored in a dedicated
> section which would be added to the table.
> e.g. static int __attribute(section (...)) nr_irqs;
> Pros: no more meminspect section Cons: have to keep all interesting
> variables in a separate section, which might not be okay for everyone.
> 
> On dynamic memory, the memblock flag marking did not receive any obvious
> NAKs.
> 
> On dynamic memory that is bigger in size than one page, as the table
> entries are registered by virtual address, this would be non-contiguous
> in physical memory. How is this solved?
> -> At the moment it's left for the consumer drivers to handle this
> situation. If the region is a VA and the size > PAGE_SIZE, then the
> driver needs to handle the way it handles it. Maybe the driver that
> parses the entry needs to convert it into multiple contiguous entries,
> or just have virtual address is enough. The inspection table does not
> enforce or limit the entries to contiguous entries only.
> 
> On the traverse/notifier system, the implementation did not receive any
> obvious NAKs
> 
> General comments:
> 
> Trilok Soni from Qualcomm mentioned they will be using this into their
> software deliveries in production.
> 
> Someone suggested to have some mechanism to block specific data from
> being added to the inspection table as being sensitive non-inspectable
> data.
> [Eugen]: Still have to figure out how that could be done. Stuff is not
> being added to the table by default.
> 
> Another comment was about what use case there is in mind, is this for
> servers, or for confidential computing, because each different use case
> might have different requirements, like ignoring some regions is an
> option in one case, but bloating the table in another case might not be
> fine.
> [Eugen]: The meminspect scenario should cover all cases and not be too
> specific. If it is generic enough and customizable enough to care for
> everyone's needs then I consider it being a success. It should not
> specialize in neither of these two different cases, but rather be
> tailored by each use case to provide the mandatory requirements for that
> case.
> 
> Another comment mentioned that this usecase does not apply to many
> people due to firmware or specific hardware needed.
> [Eugen]: one interesting proposed usecase is to have a pstore
> driver/implementation that would traverse the inspection table at panic
> handler time, then gather data from there to store in the pstore
> (ramoops, mtdoops or whatever backend) and have it available to the
> userspace after reboot. This would be a nice use case that does not
> require firmware nor specific hardware, just pstore backend support.
> 
> Ending note was whether this implementation is going in a good direction
> and what would be the way to having it moving upstream.
> 
> Thanks everyone who attended and came up with ideas and comments.
> There are a few comments which I may have missed, so please feel free to
> reply to this email to start a discussion thread on the topic you are
> interested in.
> 
> Eugen
> 

Maybe you or someone else has already mentioned this. If so, sorry I missed it.

How does this compare or contrast to VMCOREINFO?

thanks.
-- 
~Randy


