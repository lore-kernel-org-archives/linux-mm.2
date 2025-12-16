Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FB6D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:27:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 059B06B0005; Tue, 16 Dec 2025 02:27:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1FAE6B0089; Tue, 16 Dec 2025 02:27:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF58C6B008A; Tue, 16 Dec 2025 02:27:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CE4076B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:27:20 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7627B135D63
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:27:20 +0000 (UTC)
X-FDA: 84224503440.11.60B4842
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5FCEA100006
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:27:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=TJmhQFHJ;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf14.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765870038; a=rsa-sha256;
	cv=none;
	b=yFCtbWPM+AuksW9cDT8ab96mEAdzSSMm0V/xvk8S/zIqldgBsp8OgoCGhwVBwGgW9IEC4n
	PaVPhpX6zxEf4kBmXVr1oSo+WZhmRThZSfArLfRqBcGoP16xZNFpOVgz5GlrJHmV2fMW4E
	yPMufdClB9qA4zaU0aBmy8YAX8/ukd4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linaro.org header.s=google header.b=TJmhQFHJ;
	dmarc=pass (policy=none) header.from=linaro.org;
	spf=pass (imf14.hostedemail.com: domain of eugen.hristev@linaro.org designates 209.85.214.171 as permitted sender) smtp.mailfrom=eugen.hristev@linaro.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765870038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PJCA2xXmtdABe9cuOOw6HKVAFYxYWKkv6zuIQkQSiJk=;
	b=LQ18zAVAdBso1oLu+7NTBUklH19b3pvqXpqfUgjcFsFT+eooGUactA3zd0wPinzjh4Lle1
	7L3T04uYLza9iSb9JDshXanqWpghGtYD5SjP+GldrDt+OuXS5BY2gPZ0oFPQdPTiVGi7GW
	fbNmbA+ttZ9CK6TJCF5vvJkmbC3oQ1Q=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2a0a33d0585so23896465ad.1
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:27:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765870037; x=1766474837; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PJCA2xXmtdABe9cuOOw6HKVAFYxYWKkv6zuIQkQSiJk=;
        b=TJmhQFHJ3z1m9SZCKoan+s5PKceGOfPJ0Pi1HwI4qj0yWn603SETr3BYCDMqkgGz8d
         N9OkHRAUZkB7+hu+xxxd5Ysnvyp75hubpajnvIRy9EVSifYLSkq5HEiGe667P0t1UKF9
         9WGEBlsMa4NPQqZHDGmi8LmOd6CDD3TbS7szVzmUmtAI3LID0xvqzSLz4YjHQFqFVqSi
         18jdW8JDbqebWto974bdUWBXmb9t7nxLD0cDHdGlgyMR60p+6wzydYlErVSbxmHsnnhA
         UT3h1Eil4Jqjde4CGsaU/TmBL7MFjASTErkTL/aeHKHmKcaOh+qSmfSryzeKk/GjE96V
         8yNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765870037; x=1766474837;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PJCA2xXmtdABe9cuOOw6HKVAFYxYWKkv6zuIQkQSiJk=;
        b=P/yfg17vY0wyHfA6k9EEb8Djo0kjuWGcgyjIyyXmjB+1PBuPmOV9gaACYO6yEk29h7
         8lL1IOTQKy10vioJJCbB49cM0pzEXtLGbB1ehn4/huKNzGA27iCRyeBnjGpwhGARvTqf
         48jJsFE899lqNbMTgzKHJZAsDmOeVqODbGKM2OUyB5Kj9UdqLOfTZBwoU+XkfMMz/x5c
         rNWwpoXbIXl71bRzhHS3KZ/RBvpvpeM/o8TPoDPDLoo73fMGKYmW3gLF8KsYvGIAJJau
         fPKpVbjP+jLrjS+mFM9wpAxER5nQAfSWciAhkWaGlvnN2Q4yvGXEBudK0EBpxi4sA44V
         D4KA==
X-Forwarded-Encrypted: i=1; AJvYcCXwAjkPR3QuRXiF02m0/ENnJmTeyw9INwykeW7F9yu42WRMIP6JHZyfLuprbxR/L1XQdijdkoTVhg==@kvack.org
X-Gm-Message-State: AOJu0YwPVq/ekQKs5BNBLEwd3crtKL0+k711N/qrP9hVuYr6qg2k9wuv
	Tteo3xifEPEeuGx8Coun0BFCURLwr6rkRr7EHF+x5ieAAURD/aor3df9cM7xU2zI+Ac=
X-Gm-Gg: AY/fxX47vH2y6PA8UFHcBSy/Gpb486EQewDl5OEj4UZPRBSc7n3Z7fzvDWns3+yDbXu
	tTKXo7bN05R9iiwwduAP2CKpCTmnazPqPXgfIq09wI8HXifZPXG9HwkgTSSuZxQSLb2KkKcflrd
	ceeKE+fIWyIlt+krQ/dBwAK9UF+o/d7F/Y1SQ5zu8D3aXT5kSgEQv467rzNogJ0Mnhi+exVjYGx
	xTOfY4SQi72nmo+DcMhFuSwAxo6Bonzvxjw1SelErqvWIy3GACQjc9b3fbnmOuNT3B3LEjXLnEh
	8ntHqWv30+o+iXjJL+oaZXZ6AaFlHObPO/auFeGFPUjXT8UEq57RZrR9BnFBS9MvNKdQMZwMXOC
	t9DP9wr0OSKeeTeKzezPUy3QixeIpiyW11g3N43SOhXNySMZDvNOyVQLtAdakwD4l/cjGP6FK2c
	eVeAH4quknnRaH94ZXMr/bvUSRXZp/euzRTuc+DFBvOU45jRliNGXXAQ==
X-Google-Smtp-Source: AGHT+IG0XHPlxrZ19+Thmc35PPwHSeilDW9jn34WiJoQPAtDXf3ILNz55k3pKMcPVzcVte7yg4mphg==
X-Received: by 2002:a17:902:ea0b:b0:297:dabf:9900 with SMTP id d9443c01a7336-29f23bde313mr144794935ad.0.1765870036820;
        Mon, 15 Dec 2025 23:27:16 -0800 (PST)
Received: from [192.168.10.197] (14-201-17-74.static.tpgi.com.au. [14.201.17.74])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29ee9b36a80sm155735495ad.19.2025.12.15.23.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Dec 2025 23:27:16 -0800 (PST)
Message-ID: <93297eb0-1ad4-40ba-9438-ac02aa6b1d6b@linaro.org>
Date: Tue, 16 Dec 2025 09:27:03 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Introduce meminspect
To: Randy Dunlap <rdunlap@infradead.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com, linux-debuggers@vger.kernel.org,
 "kees@kernel.org" <kees@kernel.org>
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
 <b74aef93-9138-413a-8327-36c746d67e10@infradead.org>
 <93682055-4a6d-4098-b74f-afef735d1699@infradead.org>
From: Eugen Hristev <eugen.hristev@linaro.org>
Content-Language: en-US
In-Reply-To: <93682055-4a6d-4098-b74f-afef735d1699@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 5FCEA100006
X-Stat-Signature: 7sb46sdgb7ongdgyk86pnpwkojj3oarn
X-HE-Tag: 1765870038-305044
X-HE-Meta: U2FsdGVkX185wVWUJ2WLe2QLVWgarSy/Cqjz2CcLcroTcsY619EZ4UaPWNSzuFPP2mp+Lw2Iu3EadA5FFaKvjy1AogVBgtt6IgvYMymSnv/+Qdghf57IjjqLzO1aLpo9hfHVG8v+rsfA9ySWdlY+pkPZCc/X4D/UnkSGaMsEAam1KWPIIQzVjuDZ8BL87vy5uNcMtBmTW4qs0jcx7VLXt7OyabjR304An6EqmWyLmOO7NUnmJqlr0tZql4Ys9VSk2UL+ycZ0erxt/fSvzWn6Osw7IDQ22x00t04VlcIRFbzFZyCNZtbxQAwT4Fw19jvYVTSCT6ceLW9m2jrPmTH2XF1Qn5ljSVaADo/h5VzG/Sf2UDbed1x57L9E3sVaXunXu18PQIBnKj69pWVIqnbt3yXhoAmOJqcGpgeuGq6g0H6VDOTtG22K0hTXGW46ZZ06W6kQSsSraqWdvWB1CcerROx8VOt1k4la/DYhZy0DAmnL7ooa+ZR+YFY+oJuLKx9R35Hb4g7HLOMVcWQ1LxOs82HN5dpTkY36Je0qveda0QsaE28EaATgiPMxZutTjd0Q4p03IX/YeSQd241KobzFNaCori751u7FE7p0SGp2f3rvGjtCRVXYeYCgCx32KxmxS8UXIM89uFiWBxC1V/kGxGiOVsZjeZkmajeb3fMxqhx+GqUF/TbWJbWZyqyn9S22sWm/P/ttPSiyBqpG6pWSxTmRmdHd0QG47aWMxVRJQ7U7NntUCCGSQue9fUjmqr25OLlwqzp9JMEf40BhSUaQV3ZQGgAufq8xg8ktA0Ly5ozT2p4VS4SZFZKGyHVgTJ8hjmQjJZCgg5Oa97mZaEEGWUdTEs5+rqaSqR2R+ZAkPxepoyyD1xkEMzm0tisNfqJZPlIjBn6HJEhvyJUzmpo8dMAq+5qcEI3ERxfArFxmlpKR5AWSRxK9QrhsdEavKNEHnf9Iw06MwypeU5fidqx
 IHnidrPM
 gyzdypzNsIhbOMfuTdekAdCAAtdOiiWlkfE2N3DbFArSpZSQyXWZBOFDna5r3eHm5bRHl0K+2wcfIVOb8x8GTgtaBFGLgORJUBFKCKc1i82hH0C8QfwvqRDFECef6ndmOvnsWCCS7XCES8HNaxgTk2SBD4xfXYInYyhOZVkPAl2FITuqsNnyRX+eO3Cxn/d5TK8rWBP3lWlUfUYXF3Me7AnJulEpOsTj3G6eptKM4DAYFsT+Kx6FceBfiYGSJY1cOy7JB+n6GmhUnNAh6uGHMpQ7fJSsh/ihWFM0jt/GxMcTZDu3uibr+AahcUzGaFyIpCme5vPvXur5duer7x4fHf6pjsuN2fBbybPX/uxBl8/3IaDPJgOBoIbFrKgDUgnhx+HKwX8HyMPJ7eP3xvnXpIsNiQa+l9LsHvtq8b3CPicfyKzxg78SZqEs1SlmQC4mMsPbCCrrLDIFCyAwiuOQD3Os3eO58QufPURr/CgzayCzPNqfQSOTaEZZfRpcmvELkHCdVwQ+KqY/DFJ9fwlUSfN22D1L4y7THWFi+dWyzj70VR9ATm1+vr8ocAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/16/25 09:00, Randy Dunlap wrote:
> 
> 
> On 12/15/25 10:54 PM, Randy Dunlap wrote:
>>
>>
>> On 12/12/25 11:22 PM, Eugen Hristev wrote:
>>>
>>>
>>> On 12/13/25 08:57, Randy Dunlap wrote:
>>>> Hi,
>>>>
>>>> On 12/12/25 10:48 PM, Eugen Hristev wrote:
>>>>>
>>>>>
>>>>> On 11/19/25 17:44, Eugen Hristev wrote:
>>>>>> meminspect is a mechanism which allows the kernel to mark specific memory
>>>>>> areas for memory dumping or specific inspection, statistics, usage.
>>>>>> Once regions are marked, meminspect keeps an internal list with the regions
>>>>>> in a dedicated table.
>>>>>
>>>>> [...]
>>>>>
>>>>>
>>>>>> I will present this version at Plumbers conference in Tokyo on December 13th:
>>>>>> https://lpc.events/event/19/contributions/2080/
>>>>>> I am eager to discuss it there face to face.
>>>>>
>>>>> Summary of the discussions at LPC talk on Dec 13th:
>>>>>
>>>>> One main idea on the static variables annotation was to do some linker
>>>>> magic, to create a list of variables in the tree, that would be parsed
>>>>> by some script, the addresses and sizes would be then stored into the
>>>>> dedicated section at the script level, without having any C code change.
>>>>> Pros: no C code change, Cons: it would be hidden/masked from the code,
>>>>> easy to miss out, which might lead to people's variables being annotated
>>>>> without them knowing
>>>>>
>>>>> Another idea was to have variables directly stored in a dedicated
>>>>> section which would be added to the table.
>>>>> e.g. static int __attribute(section (...)) nr_irqs;
>>>>> Pros: no more meminspect section Cons: have to keep all interesting
>>>>> variables in a separate section, which might not be okay for everyone.
>>>>>
>>>>> On dynamic memory, the memblock flag marking did not receive any obvious
>>>>> NAKs.
>>>>>
>>>>> On dynamic memory that is bigger in size than one page, as the table
>>>>> entries are registered by virtual address, this would be non-contiguous
>>>>> in physical memory. How is this solved?
>>>>> -> At the moment it's left for the consumer drivers to handle this
>>>>> situation. If the region is a VA and the size > PAGE_SIZE, then the
>>>>> driver needs to handle the way it handles it. Maybe the driver that
>>>>> parses the entry needs to convert it into multiple contiguous entries,
>>>>> or just have virtual address is enough. The inspection table does not
>>>>> enforce or limit the entries to contiguous entries only.
>>>>>
>>>>> On the traverse/notifier system, the implementation did not receive any
>>>>> obvious NAKs
>>>>>
>>>>> General comments:
>>>>>
>>>>> Trilok Soni from Qualcomm mentioned they will be using this into their
>>>>> software deliveries in production.
>>>>>
>>>>> Someone suggested to have some mechanism to block specific data from
>>>>> being added to the inspection table as being sensitive non-inspectable
>>>>> data.
>>>>> [Eugen]: Still have to figure out how that could be done. Stuff is not
>>>>> being added to the table by default.
>>>>>
>>>>> Another comment was about what use case there is in mind, is this for
>>>>> servers, or for confidential computing, because each different use case
>>>>> might have different requirements, like ignoring some regions is an
>>>>> option in one case, but bloating the table in another case might not be
>>>>> fine.
>>>>> [Eugen]: The meminspect scenario should cover all cases and not be too
>>>>> specific. If it is generic enough and customizable enough to care for
>>>>> everyone's needs then I consider it being a success. It should not
>>>>> specialize in neither of these two different cases, but rather be
>>>>> tailored by each use case to provide the mandatory requirements for that
>>>>> case.
>>>>>
>>>>> Another comment mentioned that this usecase does not apply to many
>>>>> people due to firmware or specific hardware needed.
>>>>> [Eugen]: one interesting proposed usecase is to have a pstore
>>>>> driver/implementation that would traverse the inspection table at panic
>>>>> handler time, then gather data from there to store in the pstore
>>>>> (ramoops, mtdoops or whatever backend) and have it available to the
>>>>> userspace after reboot. This would be a nice use case that does not
>>>>> require firmware nor specific hardware, just pstore backend support.
>>>>>
>>>>> Ending note was whether this implementation is going in a good direction
>>>>> and what would be the way to having it moving upstream.
>>>>>
>>>>> Thanks everyone who attended and came up with ideas and comments.
>>>>> There are a few comments which I may have missed, so please feel free to
>>>>> reply to this email to start a discussion thread on the topic you are
>>>>> interested in.
>>>>>
>>>>> Eugen
>>>>>
>>>>
>>>> Maybe you or someone else has already mentioned this. If so, sorry I missed it.
>>>>
>>>> How does this compare or contrast to VMCOREINFO?
>>>>
>>>> thanks.
>>>
>>> This inspection table could be created in an VMCOREINFO way, the patch
>>> series here[1] is something that would fit it best .
>>>
>>> The drawbacks are :
>>> some static variables have to be registered to VMCOREINFO in their file
>>> of residence. This means including vmcoreinfo header and adding
>>> functions/code there, and everywhere that would be needed , or , the
>>> variables have to be un-static'ed , which is a no-go.
>>> This received more negative opinions on that particular patch series.
>>> The annotation idea seemed cleaner and simpler, and more generic.
>>>
>>> We could add more and more entries to the vmcoreinfo table, but that
>>> would mean expanding it a lot, which it would maybe defy its purpose,
>>> and be getting too big, especially for the cases where custom drivers
>>> would like to register data.
>>>
>>> How I see it, is that maybe the vmcoreinfo init function, could also
>>> parse the inspection table and create more entries if that is needed.
>>> So somehow memory inspection is a superset or generalization , while
>>> VMCOREINFO is a more particular use case that would fit here.
>>>
>>> Do you think of some better way to integrate the meminspect table into
>>> VMCOREINFO ?
>>
>> No, I just wanted to make sure that you or someone had looked into that.
>> Thanks for your summary.
> 
> Although you copied Stephen Brennan on this, I think it would be a good idea
> to copy the linux-debuggers@vger.kernel.org mailing list also to see if
> there are any other comments about it. [now done]

Thanks . I copied Stephen because we had a discussion at LPC at his talk
and he also attended my talk.

I also had a nice talk with Kees Cook and he was very interested in
having pstore as a backend for meminspect. (copied now as well)

> 
>>> [1]
>>> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
>>
> 


