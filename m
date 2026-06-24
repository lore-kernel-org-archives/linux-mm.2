Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE68DCDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 04:15:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7CC266B0088; Wed, 24 Jun 2026 00:15:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77C746B008A; Wed, 24 Jun 2026 00:15:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692BE6B008C; Wed, 24 Jun 2026 00:15:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CCBA6B0088
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 00:15:09 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BCFD164CD2
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:15:08 +0000 (UTC)
X-FDA: 84913491096.12.2E482FC
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4D2781A0009
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 04:15:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GaP209XP;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782274506;
	b=VI+hzPy2ujc5PwqxRGXK4W4RjuiwFXcX54aXiwkmnE1AjVwiL0YaQsC27eXnZLY4FtfcCY
	IOQRDPK3gao5IEhfCh9ECB2bSF3ngFXPBOHA+cXZZcxqC3SbPVQVqH+nTo4E0TyFxhMcPd
	InHYh5ojXa8Pnl39aI2/bya5U4aTEB4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782274506;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P5mg+QmunwOCQlPQb38qcZsLDKLxbI7GfqzqEdvUheA=;
	b=JNCL/AaWrwfKA/jv4mpb6IzgzJpmcdLMcAVi/anr8DaBSMAAbZRhPms4lc6523lrr7lfpc
	9qkDS+FLk1pL+chYGHXH0mgLRrhX7RGzailGOUqOy/uOn5g2zkv4CeRrhLV3bNsOtUHQln
	eFJqZceZ0Jxbp/0up2RfWGjOZJChPro=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=GaP209XP;
	spf=pass (imf19.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8A4201758;
	Tue, 23 Jun 2026 21:15:00 -0700 (PDT)
Received: from [10.164.148.38] (unknown [10.164.148.38])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C92303F836;
	Tue, 23 Jun 2026 21:14:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782274505; bh=Rt+dMmjfl+HECVstGcDntP8qmPQ3Au9mMljeDbocBoE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GaP209XPOmNK0pP342ZcONRM7jF9d/ZFio8I1JCPA5GBq70ARBEkb+C24Fq6kM4NY
	 nVKD8Lfn51GoeWLXQJPJoqxgi/esOQIqhMW9JUng8alESW7BHHqjqirY97ZkyhEhSP
	 OcHOCcYjKGVzSYAXUFE3Jhp/cxRvk6oGBlNumAzo=
Message-ID: <f5927785-d5d3-4e64-bbac-220d40718a1f@arm.com>
Date: Wed, 24 Jun 2026 09:44:49 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/2] kasan: hw_tags: Add option to tag only at
 allocation time
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Harry Yoo <harry@kernel.org>, ryabinin.a.a@gmail.com,
 akpm@linux-foundation.org, corbet@lwn.net, glider@google.com,
 andreyknvl@gmail.com, dvyukov@google.com, vincenzo.frascino@arm.com,
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
 workflows@vger.kernel.org, linux-doc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, kaleshsingh@google.com, 21cnbao@gmail.com,
 david@kernel.org, will@kernel.org
References: <20260612044425.763060-1-dev.jain@arm.com>
 <b1502a60-09a1-4699-886b-93d041de7023@kernel.org> <ajVByfkLbetzA8bB@arm.com>
 <2208123f-8a51-483b-aa93-c35d8d053d25@kernel.org> <ajltLd6FQg1aMge_@arm.com>
 <78d97371-b477-4230-8690-ac870a7bab3b@arm.com> <ajq-Ukmd9NBruhr5@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <ajq-Ukmd9NBruhr5@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4D2781A0009
X-Stat-Signature: fq7nwjukbgyee9mqr76ng99gfcggeheg
X-HE-Tag: 1782274506-894760
X-HE-Meta: U2FsdGVkX1/yWulqCXBszt2pXeyzKgp6rezKUoxXXr4RLNkiOmcRiB9OvEbfCaRbqXuZ8KSGVKW4S1TxCQkit0a3JWe+qASQuDgErTD5jcKEje2yLVBX8cHsxGFOONk1acfp2dKxHQGxDCjul6V5jMpOkKD2CdFBwbFlCOisrI1RxbCwirKPgnZa8YsDgp1lcGp9yTEIhzvJVzezy0LSdMggwXG1MgKnbeROUn2AmAktM05XtRUORugHaU/DN/JJMpgiyjm4bqX4K/Z9haOIob0KPNpZZDTAJvMFmUvqOjvDhJy6rjL9y6Ww9MNqCB+PZibsEXjI3J/UaClazUBoWJBjliowvRRKVqkivJJbgLTHm/o3iKTiUTan5QhFi6YjTRmDsj/kbwNv2U1rAEk/XWjBePYs/1xprVy/yr/YZAlhAb0rFlUh3mG3vTdz7UrUMVASJYiI771BLvche6C75vMzZ27ii+BBF/K0qOI2IibXujCKT/qz5OXWzOIoKUzMebUdUnN2t3Kb066vClBk6ajqyjSA9/3jLt0a+q5ECoRCRdoS0xffquXZ263ddXG286mjz5mF55PhLcE0HZCCn4Zms/1Lv0kM4GTW+TIkvVgwmIfAUn8a5nzkFM92VmgLpWVq3A07nXeQDZEZ1HV9YcMHdznbs72azPcf9L9bGZNRQ/KPy/IOuihxBVzRm0uxTsj4YGn4KuIuwzDBisTtHb/Qvx9jZpnbKaAujjhYH03ZQtz8UAd+mPUolDC0Fz5xMpLjS0pwS4hKumA5w5igWobt2CI/MS49dayI/lqNxLgrs3Q+CAUFnKQ+H8bQNllxNiNdH0eHJ/L6bWIn/mpVfyIJatUd4dfh/lIrBF7D9+ANaeBoOfpD+7DjobitpD2jtz2o3RROjDFqKWOwJ2GxhL3ukbDK1AGxYs2yTesPouXEYXZBjA9GQB7a3yLmo7mbYHvwVuqLUfxCZif3rU6
 E7qeTPCP
 fR2i0wmKmOXtS7C9J7dYvDturj8l9bR5K1ElJtPbxoL0DVMDX2IfMtt0uCTwLTI0nT+dW/3Q4xQm9gc1mxSPGxUgNO8RueRB4t66I8eW8/qfHNKoYJeDj0g7iwtZYfDLMG65g9nbIGgw9Etk0zIq3ipjatJEvYcg7cJbqSdvectkngpklSLNXogucrZD9OGIOrqW8SIsGXrLlu6lj8INLVzL36Eo2CO0cMxDBTmpi8LoEdmDkfIfbhQE7HYUavWt+fDlv9U0LlYxRYRW30LKl2W80Z87lrYwPJbiyVEJw82Q4mx3Mt4aFOXqjQrPXbNogiaG0f2n6cvkO8F5Md5hY/batI5wkK8xgd+ItgJDMAqVCYhg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 23/06/26 10:41 pm, Catalin Marinas wrote:
> On Tue, Jun 23, 2026 at 10:32:16AM +0530, Dev Jain wrote:
>> On 22/06/26 10:43 pm, Catalin Marinas wrote:
>>> On Mon, Jun 22, 2026 at 09:42:10PM +0900, Harry Yoo wrote:
>>>> On 6/19/26 10:19 PM, Catalin Marinas wrote:
>>>>> On Thu, Jun 18, 2026 at 10:35:15PM +0900, Harry Yoo wrote:
>>>>>> On 6/12/26 1:44 PM, Dev Jain wrote:
>>>>>>> Now, when a memory object will be freed, it will retain the random tag it
>>>>>>> had at allocation time. This compromises on catching UAF bugs, till the
>>>>>>> time the object is not reallocated, at which point it will have a new
>>>>>>> random tag.
>>>>>>>
>>>>>>> Hence, not catching "use-after-free-before-reallocation" and not catching
>>>>>>> "double-free" will be the compromise for reduced KASAN overhead.
>>>>>>
>>>>>> I doubt users who care about security enough to enable HW_TAGS KASAN
>>>>>> are willing to compromise on security just to save a few instructions
>>>>>> to store tags in the free path.
>>>>>>
>>>>>> To me, it looks like too much of a compromise on security for little
>>>>>> performance gain.
>>>>>
>>>>> I don't think there's much compromise on security for use-after-free.
>>>>
>>>> I think it depends... OH, WAIT! I see what you mean.
>>>>
>>>> You mean use-after-free before reallocation does not lead to much
>>>> compromise on security because objects are initialized after allocation?
>>>>
>>>> You're probably right.
>>>>
>>>> Hmm, but stores to e.g.) free pointer, fields initialized by
>>>> constructor or accessed by SLAB_TYPESAFE_BY_RCU semantics after free
>>>> will be undiscovered if they happen before reallocation.
>>>
>>> Even with SLAB_TYPESAFE_BY_RCU, the object isn't tagged on free either
>>> (or realloc, only if the actual slab page ends up freed). But we don't
>>> get type confusion for such slab.
>>>
>>> However, without tagging on free, one could argue that it reduces
>>> security for cases where the page is re-allocated as untagged - e.g. all
>>> user pages mapped without PROT_MTE. Currently we have a deterministic
>>> tag check fault if the page is coloured as KASAN_TAG_INVALID. I think
>>
>> So you are saying that a stale kernel pointer can continue to use the
>> reallocated page, because for non-PROT_MTE case the page does not get
>> a new tag. Makes sense.
> 
> Yes.
> 
>>> for this patch, it might be better to only do such skip on free in
>>> kasan_poison_slab() rather than kasan_poison(). Freed pages would then
>>> be tagged.
>>
>> I think you mean to say, "skip tag on free when freeing pages into buddy"?
> 
> No, I meant always poison via kasan_poison_pages(), as we currently do
> with KASAN_PAGE_FREE being set.
> 
>> So that would mean, kasan_poison() will do the poisoning also in the
>> case of value == KASAN_PAGE_FREE.

Yeah sorry I wrote two contradictory things above, that's what I meant too.

>>
>>> An alternative would be tagging on free only with a new tag and skipping
>>> it on re-alloc. But we'd need to track when it's a completely new
>>> allocation or a reused object (I haven't looked I'm pretty sure it's
>>> doable).
>>
>> That was our original approach, and IIRC we had concluded there was no
>> security compromise. However it is difficult to implement - it has cases
>> like, what happens when two differently tagged pages are coalesced by
>> buddy and someone gets that large page as an allocation.
> 
> Yeah, it's fairly complex.
> 
> I think the more problematic case is when we can't detect
> use-after-reallocation and this happens when a page is reused untagged
> (probabilistically, also when the page is reused with the old tag). As
> an optimisation, it might be sufficient to skip poisoning when freeing
> an object into the slab but keep the poisoning when freeing a slab page
> into the buddy allocator. That's where the page may end up in a place
> untagged.
> 
> Also for your optimisation to only tag on reallocation, do you have any
> code to read the current tag and avoid reusing it? That's useful for
> kmalloc caches or other merged kmem caches where we can have type
> confusion.

I don't have it, but should be fairly simple I guess. I just wanted to
keep it simple for now.

Anyhow someone needs to first test the current patchset to get some
numbers, we would be wasting time on this if no one gets an improvement.

> 


