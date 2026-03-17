Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE909FD875F
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 12:43:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13FED6B0005; Tue, 17 Mar 2026 08:43:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F11F6B0088; Tue, 17 Mar 2026 08:43:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006B96B0089; Tue, 17 Mar 2026 08:43:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E35E76B0005
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 08:43:14 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6EC3216013F
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:43:14 +0000 (UTC)
X-FDA: 84555520308.28.393064F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id 82E5120008
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 12:43:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773751392;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=JiFrO+qdzRBS30UpjlcTyT9sGWUvl9N5cpLb/NIGpgU=;
	b=ZCfoV4K5MEUvWIyw2voq7STYwZ/s4A7w7tOX4SLawGxoKImUsm61/droXTFqapiKsG1q0B
	UrUP8OP6WFLEh72+/h5WaYmwjcuncoVRt66Ju9NRbmnl8/g4129dQcqSCy+XfoNUhW9ocQ
	CzFCNdHYhxEMBPUcEaTCm8hMT21AN4s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	spf=pass (imf03.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773751392; a=rsa-sha256;
	cv=none;
	b=m5cOoYfnPVDAZk7LGM/IwEdMqw5xBxuQmW/Ka0YGJE/RpdIBp2vRrtJEGe3QqPh2PzhaDD
	ljf9gOBWmxil/DDsCTp4LfsvuvIFCQRMGAxUsE6iJofbUZhLcslkeE4VaDtwfHzG/JWozp
	BgITp+rGct9KKLedlgqYdBl39Y0T4eY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5B2B716F2;
	Tue, 17 Mar 2026 05:43:05 -0700 (PDT)
Received: from [10.57.60.143] (unknown [10.57.60.143])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5C9473F7BD;
	Tue, 17 Mar 2026 05:43:08 -0700 (PDT)
Message-ID: <3d2e8e41-8b41-4d1d-9292-de90425708ec@arm.com>
Date: Tue, 17 Mar 2026 13:43:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 0/5] arm64: support FEAT_BBM level 2 and large block
 mapping when rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>,
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
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <a76e2d63-7217-407f-bf6c-98cf58dd70c5@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: r69cqmao55hbsrmmsrncicpzbwae654z
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 82E5120008
X-HE-Tag: 1773751392-171452
X-HE-Meta: U2FsdGVkX1/WZAd2/80grt4hxzGDTS41JMvymVbzAaSXL3ETSKhsyh9ExYXSPWVH5kmvuNCzhH6vUj8cm+3wAyYjVMD9a4fIdi1P5kTJWuY1b9OHlYGOaSsjSWeDdBaQNQkVEW9tX9b8MakQ9ann0sYDh5in/4xEDiTk2kFkUbnj8i6Sk8ZwQ/0/7dDm/KnU+18hgi4ukGnVvjlfw9dj1tUQklK90IaRFgCcaZvNVA9fPTvYsnQFtd6NskHisB1VN0z2To8i1fi+vtdUbdryRMaekPukTHtL4+OlzTaXLTEtwPNVB8yRWjT8chBdPY4kKlpgLlffSK6GsSn7NGeJvHy4dxsSAOuSblvhANv/e0o2lHKb/8SfEP+itSjMoBAQ6eWaRtYaUYNjIGSSWtbYebMEP5aUEMgXwY7cnuqDyzWbNh3sm9RHI6KYL9330JbUteCwiBqaLiyMWPTraQ/3gbJfp0yzagNZZmoBDKFrk26X41Jjjh6yMUqbmbeS/QazOMKuNkICnNhHth5EVb9Hx3iLlC1pKMlpP/h1oG2Uq4PlAGSk0Aq40ZY1kAa4rdtk9bb6gdVJPsNt59M0mrkxi39IYRwMaekWzU6ggpaXH4hS0oYPUwZ/baO+/rvLRv8eaWUVF6JzeWGMIGkvibwPsjTic6993AV+toiFiF1a5UiGsHxxV1BsQVAWK15yDXIn+6iL3UihktRPyTef46ffWhw5PrGJR1UPpOkm0Vfd543IAWAWaNTgB8S3ya5xt+YXJLSqoyArXbx3y7JLlZipQ9SULBkert1sCTtdPq1LRjmUXBBESdRaIpuGA/BMAqQHlTjJ37eGCA/KudgRGAjvwL4UElcJtqX8+y+otoammb4gy1HaemD73fjUM56MPBPSXbgpSulDfgqxMWStfMJHVDIlT3p6sztKk0lKYr5SxNOfqrXlOJslO3mUX/GnH9G1Dlu8/qdJXvxITrosPeP
 ZkvFXIaL
 yqGWRbVm5GiPXFT6DKJWd3O7RFt2M5grVKLzjgac1UIknj+qlCevzJpvxSmwg2jGkNVhRc9wD/CP2g2DFKAKaVo8U7ht5OtwUGH3gA2WJFkSVGZlhwMqOw+AztV5w3gksjzxYi6ttRiJ8ED6Zu0lt9KjJ+g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/03/2026 12:45, Ryan Roberts wrote:
> On 17/03/2026 09:29, Kevin Brodsky wrote:
>> On 17/03/2026 10:13, Ryan Roberts wrote:
>>>>>> Another option would be to initially map by pte then collapse to
>>>>>> block mappings
>>>>>> once we have determined that all cpus support BBML2_NOABORT. We
>>>>>> originally opted
>>>>>> not to do that because it's a tax on symetric systems. But we could
>>>>>> throw in the
>>>>>> towel if it's the least bad solution we can come up with for solving
>>>>>> this. I
>>>>>> think it might help some of Kevin's use cases too?
>>>>> May be an option too. When we discussed this there was no usecase for
>>>>> direct mapping collapse. But if we can have multiple usecases, it may
>>>>> be worth it. 
>>> I could imagine that if user space creates and destroys lots of secretmem areas,
>>> then it will completely split the linear map to ptes and that will never recover
>>> currently. So I think in the long term, having the ability to collapse would be
>>> useful. I just don't particularly like forcing symetric systems to map by pte
>>> initially (which is slow) only to collapse later (which will cost even more
>>> time). But it does feel inherrently more robust.
>> Now that you spell it out, I'm realising this would actually make things
>> pretty complicated for protected page tables. In that series, page
>> tables for the linear map are allocated by a separate memblock-based
>> allocator [1], tracking the allocated ranges to set their pkey later.
>> There's a strong assumption that these page tables are never freed.
>>
>> If we initially PTE-mapped the linear map and then later collapsed it,
>> that assumption clearly wouldn't hold. 
> Sorry I don't understand why the assumptions change? All I'm proposing is walkng
> the linear map to find compatible PTEs and collapsing them into the biggest
> possible blocks. The pages aren't being freed, they are just being mapped
> differently (which can be done live for BBML2_NOABORT). PTEs with different
> pkeys would be considered incompatible, so we would end up with a boundary in
> the leaf mappings at that point.

I'm not sure I'm following, if all entries in a PTE page are compatible,
then surely we just convert the parent PMD entry to become a leaf and
then free the PTE page? And same idea one level above.

>
>> It could be handled by poking
>> holes in the tracked ranges, but it gets ugly and increases fragmentation.
> You'd still want page tables to be allocated from contiguous physical (and
> virtual) memory so that the boundaries where pkeys change are minimized.

Yes that's for sure, that's why I'm concerned with individual pages
being freed in a middle of a block.

> I guess I've misunderstood something...

I might have too :/

- Kevin

