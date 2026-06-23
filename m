Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA940CD4F26
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 05:02:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 595A66B0088; Tue, 23 Jun 2026 01:02:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51FDD6B008A; Tue, 23 Jun 2026 01:02:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E75A6B008C; Tue, 23 Jun 2026 01:02:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 074B86B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:02:28 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 66FD814025F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:02:28 +0000 (UTC)
X-FDA: 84909981576.27.A74DA16
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3666420007
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 05:02:26 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HuC8saHz;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782190946;
	b=zvkENaVVbV2y5vYFJ/5MrAbm5W02t31TzSdkRiURPYBGrkq6EGk/rP3sRdTLwEaJlJ80h5
	czYJ5hIk6Sy8XSYEzOvNmYSiVC1esRkPEDcHRtG5owjcgZxAdIC0I6PDLM1Wnfj/S8QO36
	g6aOJGktyYszQd0bnRAQIzD9XBiMU+g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782190946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jJpVWCXhXhzN9dpfIh91h7AiToKwgdpZ0Q4+DgKMiXo=;
	b=dKCo6KJflZ0UcijJRLtLIFgWVDGznE9kAffzz6Np/IYh+VmXWpWVc3M/asdx6cuE8co077
	YXLirzfy7X/ypEwaTqpF8BunOguHjHi4FBOj6ofK4FqH+OrFF9H0hgcN+2j7tv8arv+nlV
	EdUg3oxiZU5tlJwZ7Zfqha7bc0a6Tuw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=HuC8saHz;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9897D1A25;
	Mon, 22 Jun 2026 22:02:20 -0700 (PDT)
Received: from [10.164.19.14] (unknown [10.164.19.14])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A69713F632;
	Mon, 22 Jun 2026 22:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782190945; bh=/tf3ua+vKT99+55m2tCLALI+RpDjIfmCrLzHSIvEtUg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HuC8saHzhLFSENYFEE1x41S1sRkkb3fz7XT9b2XPuRDl4SGP1EPkUKZ1/29no1S1n
	 6ygfCJM6BN+ZVQ+fbSop01/2Y7ev3RT41BJ9Llz54s8acdxivyvEQy2ypkWeyFwnsN
	 DVF+azu/KTetekBkxbb1pagp+lFxQWb20y2KmTPs=
Message-ID: <78d97371-b477-4230-8690-ac870a7bab3b@arm.com>
Date: Tue, 23 Jun 2026 10:32:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
To: Catalin Marinas <catalin.marinas@arm.com>, Harry Yoo <harry@kernel.org>
Cc: ryabinin.a.a@gmail.com, akpm@linux-foundation.org, corbet@lwn.net,
 glider@google.com, andreyknvl@gmail.com, dvyukov@google.com,
 vincenzo.frascino@arm.com, kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org> <ajVByfkLbetzA8bB@arm.com>
 <2208123f-8a51-483b-aa93-c35d8d053d25@kernel.org> <ajltLd6FQg1aMge_@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ajltLd6FQg1aMge_@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3666420007
X-Stat-Signature: opt5yesjdrrg6rqjmgkxt6x775riq78n
X-HE-Tag: 1782190946-12331
X-HE-Meta: U2FsdGVkX18A05Z27Hi3HlYw08ew7bs16QErCRZ8rw397U2hmu7WeP+r2H51vMoks5JgfeuEeA4SQKKcl+nxkcKZuoPKxXYk4Mpi89NRlIth51FKZPZHpQSDgkHrba1NffgX2ruMhTKOx3hW9cwHL8yBMU5Z+uh6s7xVVIJS7833DlOAvmgq8lfnbKJoB1jWWDZZG1iVJjoeV+CMsTcqNhT2lcYLYN8fJ4jQHm25hwfdxuz3nxiGtGcnW0P3HGqmLD2QJiwso/Htw87EYm0hVfdxbRw8XpvpY14N52JG/B4WEgukd8jKsHd+2gw/0+todstrqHpJn5aagmkPfC228DRfZRt3y/rI3tY6lqgTr6mzSWNmLGcV6f4Qp6MHrfWUGv95hQ42EBAGo1mo4ugOnFE7+a/IX3BE/NJpUaZeJaACT5ZoKFupEDKfpbtIRx/3qUQd/W6xLulhGablwdZsEBqErTZzZjb4MpUR0zkTaFnm8JkblMQxsNUABUm2Y0I00oxNRJ+PdsF86imHs/bjiW3r+VL+GprbHnSOxHzPM6zPvptLy12SXNLd1V29FtXTe7HvK8avBmlNnIC2c0qEfl+52byqwxZqst9FYwvsuddJC7QHkcAjCb+Dfbw5POFL7zd4COypFP4X6qlSG5fy6fmXt5KXRh88PVA4V6ecPK805tsk8dnZstoTXVybdZJX+rQs3qxU30V7pYx7qAVhliKYoZJphCZY0RUSeNedfdX2RupROWm+mN2pC+srm/P0HwCpG/GXf1va9wKCzNVpTH2wKmC1sDg5h1MtvR2vtF1GUc6adBhQ41UcldiLwSnPswC6+8/iS6FYTHLZ7nfP1lNYUWDDVDdJHamhkykORfzj4aorkeckxpHG2cG31Hv5rS2LI4ybRALVlrWVWeMqDU2/Tf7Cqviz/rg8PQOftar1XjIIIsNqy/NdhfGznnw5fAjBeKmn0lzO/NvoUZW
 EXAmEdp2
 RqAuk0VNCA75k2CjhhyS3l/eFa0vUjDdQkxgZkk94+FJ9spyWch3a9ZiT7/399VWt/cKwZy891id5N2ANHzFrKg7HoscLuN3g+ILAw69XXbH/9ZCc7QPWxG0vss4WeGtHwBHA6W05KvtO6ecNlZrBJEeSWs/cRlx2uU5GjUk4ELUREDpSsJjJW1isIqcR0CetNhr4tD3jaAz//LRnBtnzUECp3hY8ZIXsObqle2STAhMQmn4+u6B0hZaDQOmtqU7GtVQFA62XHmb0bwr6ounlxuQHYJdmlQcky8R9oIRtez2maE+PeG2+q7/OeGPVLPU5AyZo3rI/YC5thKv0H+nLO8uvKtawyR1MUi7br4hRackhdLE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/06/26 10:43 pm, Catalin Marinas wrote:
> Hi Harry,
> 
> On Mon, Jun 22, 2026 at 09:42:10PM +0900, Harry Yoo wrote:
>> On 6/19/26 10:19 PM, Catalin Marinas wrote:
>>> On Thu, Jun 18, 2026 at 10:35:15PM +0900, Harry Yoo wrote:
>>>> On 6/12/26 1:44 PM, Dev Jain wrote:
>>>>> Now, when a memory object will be freed, it will retain the random tag it
>>>>> had at allocation time. This compromises on catching UAF bugs, till the
>>>>> time the object is not reallocated, at which point it will have a new
>>>>> random tag.
>>>>>
>>>>> Hence, not catching "use-after-free-before-reallocation" and not catching
>>>>> "double-free" will be the compromise for reduced KASAN overhead.
>>>>
>>>> I doubt users who care about security enough to enable HW_TAGS KASAN
>>>> are willing to compromise on security just to save a few instructions
>>>> to store tags in the free path.
>>>>
>>>> To me, it looks like too much of a compromise on security for little
>>>> performance gain.
>>>
>>> I don't think there's much compromise on security for use-after-free.
>>
>> I think it depends... OH, WAIT! I see what you mean.
>>
>> You mean use-after-free before reallocation does not lead to much
>> compromise on security because objects are initialized after allocation?
>>
>> You're probably right.
>>
>> Hmm, but stores to e.g.) free pointer, fields initialized by
>> constructor or accessed by SLAB_TYPESAFE_BY_RCU semantics after free
>> will be undiscovered if they happen before reallocation.
> 
> Even with SLAB_TYPESAFE_BY_RCU, the object isn't tagged on free either
> (or realloc, only if the actual slab page ends up freed). But we don't
> get type confusion for such slab.
> 
> However, without tagging on free, one could argue that it reduces
> security for cases where the page is re-allocated as untagged - e.g. all
> user pages mapped without PROT_MTE. Currently we have a deterministic
> tag check fault if the page is coloured as KASAN_TAG_INVALID. I think

So you are saying that a stale kernel pointer can continue to use the
reallocated page, because for non-PROT_MTE case the page does not get
a new tag. Makes sense.
> for this patch, it might be better to only do such skip on free in
> kasan_poison_slab() rather than kasan_poison(). Freed pages would then
> be tagged.

I think you mean to say, "skip tag on free when freeing pages into buddy"?
So that would mean, kasan_poison() will do the poisoning also in the
case of value == KASAN_PAGE_FREE.

> 
> An alternative would be tagging on free only with a new tag and skipping
> it on re-alloc. But we'd need to track when it's a completely new
> allocation or a reused object (I haven't looked I'm pretty sure it's
> doable).

That was our original approach, and IIRC we had concluded there was no
security compromise. However it is difficult to implement - it has cases
like, what happens when two differently tagged pages are coalesced by
buddy and someone gets that large page as an allocation.

> 


