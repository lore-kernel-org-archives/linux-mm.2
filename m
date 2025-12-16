Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2F5DD5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 06:54:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCA106B0005; Tue, 16 Dec 2025 01:54:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D77B26B0089; Tue, 16 Dec 2025 01:54:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C76776B008A; Tue, 16 Dec 2025 01:54:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B2D886B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 01:54:31 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2B1BB140530
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:54:31 +0000 (UTC)
X-FDA: 84224420742.06.A5F654E
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf16.hostedemail.com (Postfix) with ESMTP id 84AD1180006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:54:28 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="MO/94LMd";
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765868069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3RuRVgDnSJ1WklbtVGpQY94ttgAeXmiQnAu2DWxJ2NU=;
	b=nYe4m7+2wpjiH3wFBL4RTWza43LcYfUr9TbFxHcWwyAS3mYruY5wAD3r5aX6xbCBTD54zJ
	FRvphX2H172G4BFSURp/jZ0p6z3ijGlUcw8QT1NJZCozYDCzKnTyP1uppppJhQiEeo67nD
	zX25gUJW/Ux2LWWB86zIahCozx3LIUA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="MO/94LMd";
	spf=none (imf16.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765868069; a=rsa-sha256;
	cv=none;
	b=MGHO486rESqMBjJtitHfSaFegGpLcGpzx2HInbjKVPw9ivTMOpmYpWHkwaX7RTxr88y7Fd
	c/JicBVOPYeJ8pWXwh0Nm6oUo8JjFoKpn3rT0WwclDL5G8avze4N6dQW81yU8Ap/MsTtiy
	mM/LzZM4GlwmUtWaJtXb0iZYQvDzs2g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=3RuRVgDnSJ1WklbtVGpQY94ttgAeXmiQnAu2DWxJ2NU=; b=MO/94LMd2nNmSyM4b6pq0LPNfu
	lV+QLoNiqXLSxCSNVu9EwOfy/hKL9SpVyDdXKqXajYgK6W1juh/UmKkJl+m4KKNQ6UnUIpOB5WtDR
	zecmPUTTTIbWy0RXejw1baiKOkrL0aG5Voi0hSGlJompsJdF/WhTofMygz4bVBMlZmFXP3hTjl6wL
	lsqbsez7H5H7BehsNr/qAuorNFJd70QVQAUzQcof01bOk2Q2hCA4hhIc6vxaGd6z4611dePHGUG0p
	/1aPsVCtQ/SLgsVD6P2ObLgyO7kiyggEbfwHAem8Oaypq5Gvjn9Kstp31v3t0vmVeGLLLg0eF0G3s
	OpiXVZ0Q==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVOwz-00000004o6W-06pX;
	Tue, 16 Dec 2025 06:54:25 +0000
Message-ID: <b74aef93-9138-413a-8327-36c746d67e10@infradead.org>
Date: Mon, 15 Dec 2025 22:54:24 -0800
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
 <5903a8e1-71c6-4546-ac50-35effa078dda@infradead.org>
 <c3db6ccd-dfc7-4a6a-82b7-3d615f8cab4f@linaro.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <c3db6ccd-dfc7-4a6a-82b7-3d615f8cab4f@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: o1bt4didrcbgqbrs9g535dphuhqm6o4b
X-Rspam-User: 
X-Rspamd-Queue-Id: 84AD1180006
X-HE-Tag: 1765868068-675823
X-HE-Meta: U2FsdGVkX1/EEQneny6lWYlmsDjfR5OWpQlmGbDgprL1+Hs1/wPCgon8v3Tor8w3AGybemWNkbIZL6qIKE3WromaqI3dS3LQsZ388d5ANyl6Ayv4SmCnGGav1Rxuh2RYlw7e9um4P+bgscqF5/oeoSLcNA5t0puqtIIgXLyML/SGJOct6mitjNKY8KXRnZBTeh/AUvz+w2kzoZNg4baOWCIqMKAuDI9haxI4k3Yi2+FU2wSYeWdE8CpWYSq0FuUdNVnKDvBuoEZ4zEZQKOIOb6kZ7JIyM6F/NdYQvi0lvABaScJBb0EfWFZVkDCWP6xGCkA8LklgWZchcke6PV83fbHaFfi1xKOvHaytxzqJDRUe2Fa44FYZ67RkXNapXXJE/RRWaD0VCpAbsVLdCB6L+35XClNhyYp7ZwKtxPby9T9v0JGKz+4gEYOeeq3dFUlglUZJL8gmzhuVgF6LOnljZwLMSPrZoXC9QYwrG1t3Txq5KAMK8LMFaL07tmDu/AKWCPp5gqp8Eh1gNX59fcJDKYyuTEhsh/KADgxarI/2Zl0zvBD+OqNWxZCGz+jOK7QZe4do+puZlm1s6K9nvqz7C2Eq/aPl6fqfGEVOo5aKU/Nzr1XQpVaQHSnJDrOpNSuY9qP5fh8eBQ2TZYLesfn9RlBiwtH9ZGlxXmQsLYnfEY5kGK+W9bRnywP/3FPAUBxGW6YkGnItVOwbNb3fWnNQx5nFX/UlLBn73z1pLIz8SVuhxZiaMf6igA4SVaZebLUDCFtk2Gjn8fLxmAmjcBP2A4e5qlN0fx0kCzIzBzLLf/Qf2/xxT/tYWuXi3NntN7amWtLiWHrAWawBwC6h2WdgfbW4buCj7BQoc1sZ1zCUkjnZatuuhQC8f/+d4dcH45H7bfMJh8J4eCma8pPSuKoJ3Z8sA4P6uelBe9qXfBEBwwMY719gSFbf0Rzh4k/ucOrvXRFixJuCG/PsSPmsE07
 XqPJghj9
 pSzPNF2lDB6wP19aUsaXRVKN7HkNVuTVVqmFG
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/12/25 11:22 PM, Eugen Hristev wrote:
> 
> 
> On 12/13/25 08:57, Randy Dunlap wrote:
>> Hi,
>>
>> On 12/12/25 10:48 PM, Eugen Hristev wrote:
>>>
>>>
>>> On 11/19/25 17:44, Eugen Hristev wrote:
>>>> meminspect is a mechanism which allows the kernel to mark specific memory
>>>> areas for memory dumping or specific inspection, statistics, usage.
>>>> Once regions are marked, meminspect keeps an internal list with the regions
>>>> in a dedicated table.
>>>
>>> [...]
>>>
>>>
>>>> I will present this version at Plumbers conference in Tokyo on December 13th:
>>>> https://lpc.events/event/19/contributions/2080/
>>>> I am eager to discuss it there face to face.
>>>
>>> Summary of the discussions at LPC talk on Dec 13th:
>>>
>>> One main idea on the static variables annotation was to do some linker
>>> magic, to create a list of variables in the tree, that would be parsed
>>> by some script, the addresses and sizes would be then stored into the
>>> dedicated section at the script level, without having any C code change.
>>> Pros: no C code change, Cons: it would be hidden/masked from the code,
>>> easy to miss out, which might lead to people's variables being annotated
>>> without them knowing
>>>
>>> Another idea was to have variables directly stored in a dedicated
>>> section which would be added to the table.
>>> e.g. static int __attribute(section (...)) nr_irqs;
>>> Pros: no more meminspect section Cons: have to keep all interesting
>>> variables in a separate section, which might not be okay for everyone.
>>>
>>> On dynamic memory, the memblock flag marking did not receive any obvious
>>> NAKs.
>>>
>>> On dynamic memory that is bigger in size than one page, as the table
>>> entries are registered by virtual address, this would be non-contiguous
>>> in physical memory. How is this solved?
>>> -> At the moment it's left for the consumer drivers to handle this
>>> situation. If the region is a VA and the size > PAGE_SIZE, then the
>>> driver needs to handle the way it handles it. Maybe the driver that
>>> parses the entry needs to convert it into multiple contiguous entries,
>>> or just have virtual address is enough. The inspection table does not
>>> enforce or limit the entries to contiguous entries only.
>>>
>>> On the traverse/notifier system, the implementation did not receive any
>>> obvious NAKs
>>>
>>> General comments:
>>>
>>> Trilok Soni from Qualcomm mentioned they will be using this into their
>>> software deliveries in production.
>>>
>>> Someone suggested to have some mechanism to block specific data from
>>> being added to the inspection table as being sensitive non-inspectable
>>> data.
>>> [Eugen]: Still have to figure out how that could be done. Stuff is not
>>> being added to the table by default.
>>>
>>> Another comment was about what use case there is in mind, is this for
>>> servers, or for confidential computing, because each different use case
>>> might have different requirements, like ignoring some regions is an
>>> option in one case, but bloating the table in another case might not be
>>> fine.
>>> [Eugen]: The meminspect scenario should cover all cases and not be too
>>> specific. If it is generic enough and customizable enough to care for
>>> everyone's needs then I consider it being a success. It should not
>>> specialize in neither of these two different cases, but rather be
>>> tailored by each use case to provide the mandatory requirements for that
>>> case.
>>>
>>> Another comment mentioned that this usecase does not apply to many
>>> people due to firmware or specific hardware needed.
>>> [Eugen]: one interesting proposed usecase is to have a pstore
>>> driver/implementation that would traverse the inspection table at panic
>>> handler time, then gather data from there to store in the pstore
>>> (ramoops, mtdoops or whatever backend) and have it available to the
>>> userspace after reboot. This would be a nice use case that does not
>>> require firmware nor specific hardware, just pstore backend support.
>>>
>>> Ending note was whether this implementation is going in a good direction
>>> and what would be the way to having it moving upstream.
>>>
>>> Thanks everyone who attended and came up with ideas and comments.
>>> There are a few comments which I may have missed, so please feel free to
>>> reply to this email to start a discussion thread on the topic you are
>>> interested in.
>>>
>>> Eugen
>>>
>>
>> Maybe you or someone else has already mentioned this. If so, sorry I missed it.
>>
>> How does this compare or contrast to VMCOREINFO?
>>
>> thanks.
> 
> This inspection table could be created in an VMCOREINFO way, the patch
> series here[1] is something that would fit it best .
> 
> The drawbacks are :
> some static variables have to be registered to VMCOREINFO in their file
> of residence. This means including vmcoreinfo header and adding
> functions/code there, and everywhere that would be needed , or , the
> variables have to be un-static'ed , which is a no-go.
> This received more negative opinions on that particular patch series.
> The annotation idea seemed cleaner and simpler, and more generic.
> 
> We could add more and more entries to the vmcoreinfo table, but that
> would mean expanding it a lot, which it would maybe defy its purpose,
> and be getting too big, especially for the cases where custom drivers
> would like to register data.
> 
> How I see it, is that maybe the vmcoreinfo init function, could also
> parse the inspection table and create more entries if that is needed.
> So somehow memory inspection is a superset or generalization , while
> VMCOREINFO is a more particular use case that would fit here.
> 
> Do you think of some better way to integrate the meminspect table into
> VMCOREINFO ?

No, I just wanted to make sure that you or someone had looked into that.
Thanks for your summary.

> [1]
> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/

-- 
~Randy


