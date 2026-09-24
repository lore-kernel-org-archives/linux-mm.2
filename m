Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2962C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:19:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBE296B008C; Thu, 24 Sep 2026 04:19:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E6F9E6B0092; Thu, 24 Sep 2026 04:19:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D36CD6B0093; Thu, 24 Sep 2026 04:19:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AAD046B008C
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:19:48 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 92B6512024E
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:19:46 +0000 (UTC)
X-FDA: 85247957172.12.03317FC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id CB0BF40009
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:19:44 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+gQShgo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790237984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j38sKxcUuo+v+Xf2oFDiECaiMijka26xvcA+axqRQxY=;
	b=IlyEAZoo38iFFrCmlaXc6OT4y5c40m8ZkfFKdwDfLWcppGcHN1b4FJibNPcvXdmwptzt14
	nsXGjPc8Y0ddiiSQk8+3EmFaPhNi29Wsu8w6LC426YDlB4gnVKKHKmS8/CucU6eQb0UTYC
	Bqh2tyHr9zRMDrjLOyvJZUJxxaW83gQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790237984;
	b=7unJ2eLAjhEVQb2ywtydDIVEOfK9yxlnnZR6dbOli8jXPca7ELoaxbOLtrm+JXCB5Wa+fM
	ghwyT92eBBIRdubNPHQY/fE/3B6xIlV/73qbGqCUWB0FTrZjjg7eLKDUpcgFadbfdTt88w
	zXRcBkVowe7DPRiU9VtBeZRX8PEnZn8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+gQShgo;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5A0AA601FE;
	Thu, 24 Sep 2026 08:19:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BEF1F000FF;
	Thu, 24 Sep 2026 08:19:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790237984;
	bh=j38sKxcUuo+v+Xf2oFDiECaiMijka26xvcA+axqRQxY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n+gQShgouLNB4db+aIgFmU0669lvvGgyqD5kLZaf6uVg42XzHAnFT+lXpFJw9bJKb
	 EO1Bjtpb6VPH/M/4BVZKIF8ezAVotbvVw8WTP+tW7F7BQrt3if0KdoQ6pQ47M1GMdH
	 TXRFzeOPvpjVJbZM7hixJhvVnDv+asJOWGsjGrSOyCVwDX7k2TE0Iqih5KSeCNZ1n/
	 savoOMzeKelYBBa5rpykQ3V84ZCeIBG69Sj7aXKVzhDzOdo1rW4d1WvT8pPU+PZroG
	 ppFv+Rwl1qgTNwaPNx/AA9iHYcGixy3TEbTwZAglGLRyta1LNgIqUlzPACmUYjrV0Y
	 VrBK2DVCZG97g==
Message-ID: <d568a29b-5745-4214-96d3-1b635cd46c15@kernel.org>
Date: Thu, 24 Sep 2026 10:19:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/5] hibernation, KFENCE: explicitly map/unmap KFENCE
 pages
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-4-7f7dfae3dbe0@kernel.org>
 <fec1931b-1173-4e14-b74a-7b3987a9b7bc@kernel.org>
 <arP0-maAEi5yeNnl@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <arP0-maAEi5yeNnl@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: CB0BF40009
X-Stat-Signature: ae7zxfzrnm59h57eojgusf4jjnqdc44r
X-Rspam-User: 
X-HE-Tag: 1790237984-733605
X-HE-Meta: U2FsdGVkX1+F156nFsQKmSrae6oHiWZ+n6ZyjTIbWBF+UbvwTZ+1zQ8s/pFd8I93cE9V4RtFEiw1srx/XTR4yjDdOVVexqyveTzgJwXfCABdOph6hoijSpN9DGDyagh/hklwG/sLYuJEzIeCFn0SsC5yNA+Pi9kbg/+kHDHBepVS/fEusOIRGiZz58aLUe5v1C2kyHVtKFeGDDYNiVXQHBnSqIj4p2kMDOrVXz+XdEs1BWqTMT0v2ZtMN7SHh1VZ16ghOiY0OwK0LuYxlM8OqgmS+90a6vBtfHDAfqQuEFP7vSXZBfqKxg21P4CUYY9LTKKacB3YIPnJ0d5UW7SaVQXHTeqpj8lwTbfhksDdfgCfIcZ8wea82F07hRGdOcDiaG5KjWsO7Hl9FBnE6ZRIS/GXOYj+kIs86JaaK5+N00Lk1yOlFd3IfeW9Xte+knf2D1cDWXDltAUqo9vkryx4RNRKIoP8n+3f78BDk+oKqtnFCfgW6jNor/hxpQoHrFPmRGbCZOJE4KcfC2BdmkH/BsCSG3Y/yDo3BuSGwQx4czPdTkeXOK/rlKwCgt93QRps9B1bAFA5MbeBPFRL5wjelAgSzmHd01PutuiN9R3AguYCE2X+IddJtyks/lexXJhvMqcxmHX4oM7S+6ffyQGokUNHG2FzNl4wA8fs3jz+XqBTB7pTxEvv2R7QeNlIiMe8hZjEIrXyK/gU0cvwAVmtbBo7IxVHOL0egj64wH15SzMvdJy0PyEX7mn6G3pUh94GEokcK3RTVrKKkmgxbeoyP/PDPE2oQuyLlppy1Jw+/9Ns0pRYLUybjRGZi0Naz1tyaqtWWtSCncgBiROFXjKzv5dDCNhx1jCUQn4ziZzA17hbDchq6CkuNftON/TedoM/5EUnzdtErWq4rwV9l+wrZuufx6+NnIJYuHp6fWF9wk8cdicmH56YQbf/2vB5Vt+gZG/vjic9biTxAAXMW4a
 tGNMSL0w
 gQc9l+mEOthAy/lxGjnvd47t5RScKCryCCD0GHsttc3aoF306h9GlMk1TZYd/wr9TI0rUfCtUHh8iwYbsfNTClLblVetGv+DqfldrZTTZCF3y0zDHwwFt3MeZQWB1FkPfTl4q9mxay6p0E7AYrg+KyfLTeX1vSCH2Ru0VYYnYHA+KxyTJlWQYRgMGymrUFKicVSTelFVt7yDhUI/AvWQNc0lghpfqlLts735Z+Infy+2Z63Wy+V52qMdnXgXx1XR1QN/kQy4O09AtHlLIaRl4cCyCLPxAb5oVVCjH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 17:49, Mike Rapoport wrote:
> On Wed, Sep 23, 2026 at 12:31:26PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
>>> The pages protected by KFENCE are removed from the direct map.
>>>
>>> safe_copy_page() temporarily maps and unmaps them using set_direct_map
>>> APIs, or, when the stars align, even using debug_pagealloc_map_pages().
>>>
>>> Neither of these APIs cares whether it is a KFENCE page and both blindly
>>> perform the update of the kernel page table for any non-present page.
>>
>> Agreed, we should route this through the actual mechanism that modified the
>> directmap in the first place.
>>
>>>
>>> Ability to use debug_pagealloc_map_pages() to remap KFENCE pages when both
>>> KFENCE and debug_pagealloc are enabled is an amusing coincidence.
>>>
>>> But with increasing appetite for using set_direct_map for hardening
>>> purposes, it becomes too big of a hammer to enable saving any non-present
>>> page in the hibernation image.
>>>
>>> Another gotcha is that loongarch that does not have a direct map at all
>>> advertises ARCH_HAS_SET_DIRECT_MAP to allow coexistence of KFENCE and
>>> hibernation.
>>>
>>> Extend KFENCE with a bitmap that tracks which pages are protected and
>>> provide kfence_force_mapping() and kfence_restore_mapping() APIs that allow
>>> forced mapping and unmapping of KFENCE pages.
>>>
>>> Use these APIs in hibernate_{map,unmap}_pages() for KFENCE pages.
>>>
>>> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>>> ---
>>>  include/linux/kfence.h  | 29 +++++++++++++++++++++++++++
>>>  kernel/power/snapshot.c |  7 +++++++
>>>  mm/kfence/core.c        | 52 +++++++++++++++++++++++++++++++++++++++++++++++--
>>>  3 files changed, 86 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/include/linux/kfence.h b/include/linux/kfence.h
>>> index e5822f6e7f279..33a126cb6d1b7 100644
>>> --- a/include/linux/kfence.h
>>> +++ b/include/linux/kfence.h
>>> @@ -222,6 +222,32 @@ struct kmem_obj_info;
>>>  bool __kfence_obj_info(struct kmem_obj_info *kpp, void *object, struct slab *slab);
>>>  #endif
>>>  
>>> +/**
>>> + * kfence_force_mapping() - make sure a KFENCE page is mapped
>>> + * @page: page to map
>>> + *
>>> + * Check whether @page is protected and map it if needed.
>>> + *
>>> + * Requires: is_kfence_address(page_address(page))
>>> + *
>>> + * Return:
>>> + * * false - failed to map @page
>>> + * * true - @page is mapped
>>> + */
>>> +bool kfence_force_mapping(struct page *page);
>>> +
>>> +/**
>>> + * kfence_restore_mapping() - restore mapping of a KFENCE page
>>
>>
>> The name is misleading. You are actually restoring that the page is
>> unmapped/protected?
>>
>> 	kfence_force_mapping vs. kfence_restore_mapping
>>
>> is confusing.
>>
>> Can we find a better pair of function names that describe what is actually
>> happening?
>>
>> Maybe something along the lines of
>>
>> 	kfence_prepare_copy_page
>>
>> 	kfence_finish_copy_page
>>
>> That rather expresses what the caller intends to do.
> 
> Naming is hard :-D
> 
> I feel that _copy_page() is to vague and adding hibernation there is to
> mouthful :(

Yeah, I wouldn't mention hibernation.



> 
> And these could be used outside of safe_copy_page() someday.
> 
> How about 
> 
> kfence_set_page_present()
> kfence_set_page_default()


Maybe spell out "direct_map" ?

kfence_set_direct_map_present()

kfence_set_direct_map_default()

But yeah, something along those lines is better.

-- 
Cheers,

David

