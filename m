Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A757D5B161
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:00:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6C0A96B0005; Tue, 16 Dec 2025 02:00:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 698426B0089; Tue, 16 Dec 2025 02:00:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56D3A6B008A; Tue, 16 Dec 2025 02:00:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 432876B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:00:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E42C916035D
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:00:37 +0000 (UTC)
X-FDA: 84224436114.17.1C04685
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1B621C0003
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:00:35 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QJXU0ivI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765868436; a=rsa-sha256;
	cv=none;
	b=HkMR2ue6ZzQ6uZCbFaSBaiJjt5nnXgsnj7ZyF3iG2l0TRmmw/xuzIg8ovuZG08BVnmXZaq
	EiYfDAf2uPB/yuQ8t6HDNKEUI/pxklTKPki55T0QuRMmyAE/Io6ziqMGDTDeNf8rZ/SPbz
	U0RtSbpUldPrRb2ZOO3aJbQY2FKJ6sk=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=QJXU0ivI;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf22.hostedemail.com: domain of rdunlap@infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765868436;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ACLxWNBKlHzVYrQhk+bIPDxbMvRXgt1a0foI415LnX4=;
	b=sriBtYH7wa7gGUJoQ8RWZIR8Cfx3EEFZ7niNL7FfDRMvsjH0dCJ6U9lrXOpA//ASnj5BHn
	VmDs+xM6Ey6RvshujqG+iv1FfwG/hVE5jCyhWVRGA8rjZD/a9QV7exPNCYHBrQ/oqNe2Ue
	t/sOUCdAB0StSd9H3KnU92qAs1IdDwc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:References:Cc:To:From:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=ACLxWNBKlHzVYrQhk+bIPDxbMvRXgt1a0foI415LnX4=; b=QJXU0ivIeBSXYI/xeJMRaNszO/
	3N07ehRAX6bpi9ocM0/RhO18PXW7yDlTSBZeY2KO/EzP7HrqEFfNMN+caN/TAlT0zTxOmhXJGKJGC
	DFqJzmsU8Fi8N4yFEX/r/AOacAnnKIKh4nmIVmJbpUJkywLMkOCRnSYNF7OrmWCi/OIG1ObxhqRwi
	n/IRgskUcjEfHp41IVygkeiJXsTqr7vxTO5scFMdybpHp4b3hnPPzNhX/EIzhPDuEpKyEwDdJstjq
	h1X39dJKIHUTC+IqdNwmUHfo8E+U/j51fff9B9mT9yc0neDnekDPXsKfz7aX7iZfNa/QNy1EmvPDI
	Lck+C40A==;
Received: from [50.53.43.113] (helo=[192.168.254.34])
	by bombadil.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vVP2w-00000004ojt-3TS1;
	Tue, 16 Dec 2025 07:00:34 +0000
Message-ID: <93682055-4a6d-4098-b74f-afef735d1699@infradead.org>
Date: Mon, 15 Dec 2025 23:00:33 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/26] Introduce meminspect
From: Randy Dunlap <rdunlap@infradead.org>
To: Eugen Hristev <eugen.hristev@linaro.org>, linux-arm-msm@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, tglx@linutronix.de,
 andersson@kernel.org, pmladek@suse.com, corbet@lwn.net, david@redhat.com,
 mhocko@suse.com, linux-debuggers@vger.kernel.org
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
Content-Language: en-US
In-Reply-To: <b74aef93-9138-413a-8327-36c746d67e10@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1B621C0003
X-Rspamd-Server: rspam10
X-Stat-Signature: fnktu1xd3qbm4ihugqg4fc76ydc4sisd
X-HE-Tag: 1765868435-704962
X-HE-Meta: U2FsdGVkX19MK8J1hkG2ioET7nixxC+pF3EfyhnadHHOlXti+UtAUKcI1NjQ2iJXUUBszrvT4dcVoi2xqmi7WXCG0s6cUWf2pabevNiqCVoKx0VINdEw5JVfBk33dRF3/zSEYJc914skSG8vzCO9tIELarFv0E4S1Rw4TH/kCKLhS9RNQvXCxKbjhItj4WcOMcQT5qjEryfxrXKEt3Q4C8FmG+xKw3ozNkFGm8ruw2QWOCmvKAsD9siWyE1m8lGVl1iTMjJVj2ikl+38H2TmsvF+5pueaGxe+uOam0ysN0qiZiRly16LuNjG5AF6XCCZo+3WD1OD/j5Y0EYz7CmQok/ctSrR5I6VpqKp5eDHCmOJQ/9KdyQMYpVXoh9qg+CgLnp/sVo8gjmJN+0/xThXO0Nq7MPSo93BYii0DwSA5MJDDO6yUYNY2fOAge45+fWh3Q+o6UUIQtM13oKs/XP6Cz7MZHI6u2JvETq24IwGX1jJyquio0IJRA4aNT1ILIlqYD86RN+hVP2VgKfwMp56cR/bNzQi2N+AEi++RSC8LGw1wdKTKYmPapr7X8uzq944y5uCaWPyNHWz16U0LiTtiW2BLGhm5nEpPjwmYG9Hz8kTAQ2wD0ijuLvouxrIY25hVw1x1U50ZthC7hTpy+DRIZgM2fZaXzF12pp4A4LPG5G6nd73f+OGB115PU0PJHDfJSyM0lANmQUECoAMNzdM7obCeUAibAdc6pQTJTjvBE6+QMZmZgJt+U/HeN6oSbiz5ffdF5cfPIyNWf33SapZKn4h+em5tfoOTU2pCE+ennmlNLIkZ34mwPmaOO0ptP+uV/2L/yNy1quQI0DvXcGmbwfrDpsDJUC3Pm/ooONEmFgFdRkMomocpnCTtSdJJjzsaAWeyfo+mufTgZKYLN8u53oQYsjjQ79x5XNOYTgVtz06J03jeNK0CBIXemz/6+uAMrp5tK5/Vr41TD0XKZG
 Ez3ESwND
 wqgNgzcGvxknc1MpGfqGJQwbW71s//ywUZd1d/jS7zzxrPog6B5qvI9A1zO3RKzb/+lvOjAdMgmqEG129QdE73dy0AchHtu1I6mSxEqe0sJErbozumt1Znu9QUbM7Bv6gslBGlVn7ub3eRpuiEvD+Rq2X6CNEzP4MLg6BUiwv7JAKbSWOunWhG9L8sNi2z9+X43XymTItq/WJeCaJy6/xA28z03X05EhqiPDwiL5En42uOPR+0R/BNrexWWx3alHU4EM7HFO7nx8UYKWe4/qk9UcpKCjikPK1xw158b5NXJ/qMKbpayG5U1GbtS1/YcXUyPXQqc+ZVw3WCrP0Ai00q/v/y0VHcKZR2lfz/ZaHkl1dFUhLrznfSxYUuYK9aiW/XNhJqAeGiyu67Qut0mGwD88zgRVlCEtcvjbYvix39Nlg5UOvI4MeGIyN9XLzghuwYHrNi0ITiuu0tMALQKuO1PKB5D4RQPwkYR+bGk+gIHHhI2YJnarKqH2/q8Ft1pDy3HxF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/15/25 10:54 PM, Randy Dunlap wrote:
> 
> 
> On 12/12/25 11:22 PM, Eugen Hristev wrote:
>>
>>
>> On 12/13/25 08:57, Randy Dunlap wrote:
>>> Hi,
>>>
>>> On 12/12/25 10:48 PM, Eugen Hristev wrote:
>>>>
>>>>
>>>> On 11/19/25 17:44, Eugen Hristev wrote:
>>>>> meminspect is a mechanism which allows the kernel to mark specific memory
>>>>> areas for memory dumping or specific inspection, statistics, usage.
>>>>> Once regions are marked, meminspect keeps an internal list with the regions
>>>>> in a dedicated table.
>>>>
>>>> [...]
>>>>
>>>>
>>>>> I will present this version at Plumbers conference in Tokyo on December 13th:
>>>>> https://lpc.events/event/19/contributions/2080/
>>>>> I am eager to discuss it there face to face.
>>>>
>>>> Summary of the discussions at LPC talk on Dec 13th:
>>>>
>>>> One main idea on the static variables annotation was to do some linker
>>>> magic, to create a list of variables in the tree, that would be parsed
>>>> by some script, the addresses and sizes would be then stored into the
>>>> dedicated section at the script level, without having any C code change.
>>>> Pros: no C code change, Cons: it would be hidden/masked from the code,
>>>> easy to miss out, which might lead to people's variables being annotated
>>>> without them knowing
>>>>
>>>> Another idea was to have variables directly stored in a dedicated
>>>> section which would be added to the table.
>>>> e.g. static int __attribute(section (...)) nr_irqs;
>>>> Pros: no more meminspect section Cons: have to keep all interesting
>>>> variables in a separate section, which might not be okay for everyone.
>>>>
>>>> On dynamic memory, the memblock flag marking did not receive any obvious
>>>> NAKs.
>>>>
>>>> On dynamic memory that is bigger in size than one page, as the table
>>>> entries are registered by virtual address, this would be non-contiguous
>>>> in physical memory. How is this solved?
>>>> -> At the moment it's left for the consumer drivers to handle this
>>>> situation. If the region is a VA and the size > PAGE_SIZE, then the
>>>> driver needs to handle the way it handles it. Maybe the driver that
>>>> parses the entry needs to convert it into multiple contiguous entries,
>>>> or just have virtual address is enough. The inspection table does not
>>>> enforce or limit the entries to contiguous entries only.
>>>>
>>>> On the traverse/notifier system, the implementation did not receive any
>>>> obvious NAKs
>>>>
>>>> General comments:
>>>>
>>>> Trilok Soni from Qualcomm mentioned they will be using this into their
>>>> software deliveries in production.
>>>>
>>>> Someone suggested to have some mechanism to block specific data from
>>>> being added to the inspection table as being sensitive non-inspectable
>>>> data.
>>>> [Eugen]: Still have to figure out how that could be done. Stuff is not
>>>> being added to the table by default.
>>>>
>>>> Another comment was about what use case there is in mind, is this for
>>>> servers, or for confidential computing, because each different use case
>>>> might have different requirements, like ignoring some regions is an
>>>> option in one case, but bloating the table in another case might not be
>>>> fine.
>>>> [Eugen]: The meminspect scenario should cover all cases and not be too
>>>> specific. If it is generic enough and customizable enough to care for
>>>> everyone's needs then I consider it being a success. It should not
>>>> specialize in neither of these two different cases, but rather be
>>>> tailored by each use case to provide the mandatory requirements for that
>>>> case.
>>>>
>>>> Another comment mentioned that this usecase does not apply to many
>>>> people due to firmware or specific hardware needed.
>>>> [Eugen]: one interesting proposed usecase is to have a pstore
>>>> driver/implementation that would traverse the inspection table at panic
>>>> handler time, then gather data from there to store in the pstore
>>>> (ramoops, mtdoops or whatever backend) and have it available to the
>>>> userspace after reboot. This would be a nice use case that does not
>>>> require firmware nor specific hardware, just pstore backend support.
>>>>
>>>> Ending note was whether this implementation is going in a good direction
>>>> and what would be the way to having it moving upstream.
>>>>
>>>> Thanks everyone who attended and came up with ideas and comments.
>>>> There are a few comments which I may have missed, so please feel free to
>>>> reply to this email to start a discussion thread on the topic you are
>>>> interested in.
>>>>
>>>> Eugen
>>>>
>>>
>>> Maybe you or someone else has already mentioned this. If so, sorry I missed it.
>>>
>>> How does this compare or contrast to VMCOREINFO?
>>>
>>> thanks.
>>
>> This inspection table could be created in an VMCOREINFO way, the patch
>> series here[1] is something that would fit it best .
>>
>> The drawbacks are :
>> some static variables have to be registered to VMCOREINFO in their file
>> of residence. This means including vmcoreinfo header and adding
>> functions/code there, and everywhere that would be needed , or , the
>> variables have to be un-static'ed , which is a no-go.
>> This received more negative opinions on that particular patch series.
>> The annotation idea seemed cleaner and simpler, and more generic.
>>
>> We could add more and more entries to the vmcoreinfo table, but that
>> would mean expanding it a lot, which it would maybe defy its purpose,
>> and be getting too big, especially for the cases where custom drivers
>> would like to register data.
>>
>> How I see it, is that maybe the vmcoreinfo init function, could also
>> parse the inspection table and create more entries if that is needed.
>> So somehow memory inspection is a superset or generalization , while
>> VMCOREINFO is a more particular use case that would fit here.
>>
>> Do you think of some better way to integrate the meminspect table into
>> VMCOREINFO ?
> 
> No, I just wanted to make sure that you or someone had looked into that.
> Thanks for your summary.

Although you copied Stephen Brennan on this, I think it would be a good idea
to copy the linux-debuggers@vger.kernel.org mailing list also to see if
there are any other comments about it. [now done]

>> [1]
>> https://lore.kernel.org/all/20250912150855.2901211-1-eugen.hristev@linaro.org/
> 

-- 
~Randy


