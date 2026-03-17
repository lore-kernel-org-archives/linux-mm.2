Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B990FED9E1
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 15:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 82F336B008A; Tue, 17 Mar 2026 11:05:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 806FE6B008C; Tue, 17 Mar 2026 11:05:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71CAB6B0092; Tue, 17 Mar 2026 11:05:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 606766B008A
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 11:05:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DCD488A979
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:05:34 +0000 (UTC)
X-FDA: 84555878988.30.BBE4F6A
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9C843A000C
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 15:05:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773759933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tn0SZO83j1egoKZj5ZrOFWPkgvEVOpvUCaCtsW+ARy0=;
	b=UYBsiX2N14mX9HaeWjpTfWH99TUKQZiF6otBBOnZ74rE2VDwSg8SHCRM5PZ1H+cxTTkIAe
	cGnRUhKGjctMi0lL8u4yAJ3dACT0BS/Q1yVulgW5PbR/5HE+FhqOo+hfK4L5oQ3g8n4OW6
	A3kwClc5uNfAX3ERrAIOuWDmsYqUFew=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773759933; a=rsa-sha256;
	cv=none;
	b=OHbvFq1AhdNFKhLPVNeqVvu/9y5kwUdNrI3ivyIXJY7TkSqPA+yKsIwTIekQ1Cg+IFUUeN
	GgwmrFpfmsFUVAJq7IkonIGeqYbRRNWb7kpAhYtxB9WD64zRBcEwDOT3gjQsftiky98wlK
	3Lvy+p1E6BOP4J40uWsI3rsWsI28KRc=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4D4961477;
	Tue, 17 Mar 2026 08:05:25 -0700 (PDT)
Received: from [10.1.37.182] (unknown [10.1.37.182])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 48ECB3F778;
	Tue, 17 Mar 2026 08:05:29 -0700 (PDT)
Message-ID: <f7105fbe-2141-4036-a6b2-5ec4384b77e6@arm.com>
Date: Tue, 17 Mar 2026 15:05:27 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
Content-Language: en-GB
To: Kevin Brodsky <kevin.brodsky@arm.com>,
 Yang Shi <yang@os.amperecomputing.com>, Jinjiang Tu <tujinjiang@huawei.com>,
 catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 dev.jain@arm.com, scott@os.amperecomputing.com, cl@gentwo.org
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <0b2a4ae5-fc51-4d77-b177-b2e9db74f11d@huawei.com>
 <de0b06cf-15a5-4109-b339-75c10d9b8a18@arm.com>
 <0a740020-4780-4156-a9c5-f8b4ada9c8c0@os.amperecomputing.com>
 <4ad2ea40-b23b-4231-a0de-585b205865c5@arm.com>
 <9dded616-989b-4846-8596-1c45a6304d36@arm.com>
 <6c0ed052-5f3c-405a-b53f-4ea21a24479d@arm.com>
 <a76e2d63-7217-407f-bf6c-98cf58dd70c5@arm.com>
 <3d2e8e41-8b41-4d1d-9292-de90425708ec@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <3d2e8e41-8b41-4d1d-9292-de90425708ec@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6c4wbdwf5amtmkbihei1x49hnehgg844
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9C843A000C
X-HE-Tag: 1773759932-8857
X-HE-Meta: U2FsdGVkX18wPqoztayOfhu2Mb80zFPY33PPbc/Sw4lOMAanjn5lC/T44ISvQtZTapWbKLoYtax+lbZ6cWrlJ3GfiHEBXyft+Jp0JYHCRC4TYOJNL2a9YJHFVMxG3miIUBMb4KQ5/AAf099xGwjoBo4ml9QyeL/NJ6NrlSzEn5/XuFQfKUUoZVlOQpFw+4j51qkz3UfCBdYAhMZLERp5An3jcaQfgajORXwF1dE0PduIrPg2oVo4ZQtGL+9FIfT2/Q4drfOXXQ8H/tSQyrD1gu+obi7U5+Omun/50+O3E8hTbjlzqnIvmKdYmW59WSM3jYH31EUpKmQiW44Y7RwPrvzukvGZ+/6IcIndzwsqRPXRXIsYLD0GHx54S7fKTYWl1s69C4y9Ia2BdaumxxRCofn8I175tekhwrbeQh3TmqPLE5a/URPsZcjxVx02m2Lix72+qkTJesYzMEeFz5WWScM3TfdC2+JmpQqDbVHR8bpVeDN5oWYFsVKbOGGZ/xz431RvNR04QuMOWSuT9owKKLExl9OW6wGXd7nStENo6n4xCS95vsVEHCJVCnnKkrKjJiyUk+Zo+i4q3CzH1L7lj/gcOnsI5SKA8eQBAxQG+R82MDIl1BAxTcL4daHaqK6x+sxoBWQ53Y7IpEk4RoGAp3snw7oZF0cKersKJQawbwgLSa3i6GccyTCEZkqtp4kKD8wtOxoLwZJNSsPhr/kJsMnvfpG1vPZrXRELd2Hh7EKot+2uvfH0Z4fiyXL9CMu3qBMpGiE9NXTcuIAL4pwYAcla/bvsWpGfkPoVm/osmbutP/hBH7RJJl0Ka4Cs4qVP0AjnON8ommchj307Bc04XO+wp71ymqF1cXUyK4iDJcP+ZxaRaVua5pJQeExltJ0zLGofaBhXp6ly8AFcPqvxC/hDgKDHISR4I9D9y7rc4nnLyynKyygTCgSnU9+Yon/dSZc5/M4PX8+6YJunMIt
 maW1yfsS
 M1GfCUlsZvRg3SwaRc6PhSSGRwwNiWziif1//AMUQLv40uMVjTnEmt10PeRMCGpl5yNNNRTTZUMSgxZ6VusL59Oe/ZqrhskK79FE7H3QaokvMY6PqkIXSjUebHhl4+KAeGDwue5YJjNR7HSq23kOQQuxO0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/03/2026 12:43, Kevin Brodsky wrote:
> On 17/03/2026 12:45, Ryan Roberts wrote:
>> On 17/03/2026 09:29, Kevin Brodsky wrote:
>>> On 17/03/2026 10:13, Ryan Roberts wrote:
>>>>>>> Another option would be to initially map by pte then collapse to
>>>>>>> block mappings
>>>>>>> once we have determined that all cpus support BBML2_NOABORT. We
>>>>>>> originally opted
>>>>>>> not to do that because it's a tax on symetric systems. But we could
>>>>>>> throw in the
>>>>>>> towel if it's the least bad solution we can come up with for solving
>>>>>>> this. I
>>>>>>> think it might help some of Kevin's use cases too?
>>>>>> May be an option too. When we discussed this there was no usecase for
>>>>>> direct mapping collapse. But if we can have multiple usecases, it may
>>>>>> be worth it. 
>>>> I could imagine that if user space creates and destroys lots of secretmem areas,
>>>> then it will completely split the linear map to ptes and that will never recover
>>>> currently. So I think in the long term, having the ability to collapse would be
>>>> useful. I just don't particularly like forcing symetric systems to map by pte
>>>> initially (which is slow) only to collapse later (which will cost even more
>>>> time). But it does feel inherrently more robust.
>>> Now that you spell it out, I'm realising this would actually make things
>>> pretty complicated for protected page tables. In that series, page
>>> tables for the linear map are allocated by a separate memblock-based
>>> allocator [1], tracking the allocated ranges to set their pkey later.
>>> There's a strong assumption that these page tables are never freed.
>>>
>>> If we initially PTE-mapped the linear map and then later collapsed it,
>>> that assumption clearly wouldn't hold. 
>> Sorry I don't understand why the assumptions change? All I'm proposing is walkng
>> the linear map to find compatible PTEs and collapsing them into the biggest
>> possible blocks. The pages aren't being freed, they are just being mapped
>> differently (which can be done live for BBML2_NOABORT). PTEs with different
>> pkeys would be considered incompatible, so we would end up with a boundary in
>> the leaf mappings at that point.
> 
> I'm not sure I'm following, if all entries in a PTE page are compatible,
> then surely we just convert the parent PMD entry to become a leaf and
> then free the PTE page? And same idea one level above.

Ahh - good point! That totally passed me by before. But I'm not sure it's the
end of the world...

We would end up with about 0.2% (4K/2M if I've done my maths correctly?) of the
linear map sub-optimally mapped. Personally I don't think that would be the end
of the world.

> 
>>
>>> It could be handled by poking
>>> holes in the tracked ranges, but it gets ugly and increases fragmentation.
>> You'd still want page tables to be allocated from contiguous physical (and
>> virtual) memory so that the boundaries where pkeys change are minimized.
> 
> Yes that's for sure, that's why I'm concerned with individual pages
> being freed in a middle of a block.
> 
>> I guess I've misunderstood something...
> 
> I might have too :/
> 
> - Kevin


