Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2624DC982C5
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 14:51:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7966B0088; Wed, 16 Sep 2026 10:51:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168B06B0095; Wed, 16 Sep 2026 10:51:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 02F986B0099; Wed, 16 Sep 2026 10:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CA9506B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:51:52 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 61B3AA5B4D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:51:52 +0000 (UTC)
X-FDA: 85219914864.13.8772E83
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9101AC0007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 14:51:50 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJmX77mg;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789570310;
	b=a1yRwWrDF9KctEB8G0M5zH65hBu5NTdJ23VekFAGZWaY8LZKwLqE7td6Gt5DiP1losux4M
	8hWgPCK0k8a+7ijRUmR2x3R8QmZSzaC58QFG8omwuRgwmwyLfZmyhxE5Yg/q5aFUBj2wNk
	NOTLkKmkmU7Of4ISKVQ1eLBYedGI4eA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DJmX77mg;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789570310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9b/9Hwh5vUHfr3h3yI1jv7U58Y0A9HgrBxLkX3sPvA=;
	b=4f2tpXlJQPWONxjrZ9XhS91vhQUvxkjRLuVdZVLq+XgqA4kSFw8qF1rBVk4zez5rnfJw+1
	wmS+4P2E9UvSndArinuvfkV1kTIOaR8bh2HjZnUZlgbtaWuzlnUukEBFv12jeBPbkt8/bZ
	FYHZ4SN0Ffz+Dh58uiLZVu2HcOklT1s=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B742540367;
	Wed, 16 Sep 2026 14:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1141A1F00898;
	Wed, 16 Sep 2026 14:51:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789570309;
	bh=s9b/9Hwh5vUHfr3h3yI1jv7U58Y0A9HgrBxLkX3sPvA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DJmX77mgdbs6Q8GAXeo0braYp2Bik3mxuTOg0XuCWiVphbHAn0kd2P/Gl+uG+6WHV
	 Nj7WIlnKvMiHz2i5VCCjR0CKoRaRenUKdVTz4v8buhxLZCDYs7IWCtsnkMkJY5qML5
	 abKuZvlhV5VK8XsDgdsDHh2VJyTT/NPOcB+cu8l4dl4wTx3cP9yEipHHWuu3Sstsgs
	 w2BFWBemQKvOXthe2X/HXPSb4U4WjkI1WB1QXgotSE6z7uqoNYpuGUaxbqDGsHaugi
	 qFBqz/j/wpD9Z4FAxE0BIjGvJbIomrHP3AiW+U8sR6kKKimRJUHOhADx5jFJ6fVP0H
	 hUGLHYw9SMtJQ==
Message-ID: <b8ad366a-a019-4462-9dce-f687f60ee7f2@kernel.org>
Date: Wed, 16 Sep 2026 16:51:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 7/9] drivers/base/memory: count inherited poisoned
 frames into the block
To: Breno Leitao <leitao@debian.org>
Cc: Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Miaohe Lin <linmiaohe@huawei.com>, Naoya Horiguchi
 <nao.horiguchi@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
 kas@kernel.org, kexec@lists.infradead.org, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Thomas Gleixner <tglx@kernel.org>,
 Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
 Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, Brendan Jackman
 <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, Oscar Salvador <osalvador@suse.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>,
 hannes@cmpxchg.or, shakeel.butt@linux.dev, linux-efi@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, rmikey@meta.com,
 riel@surriel.com, harry@kernel.org, linux-cxl@vger.kernel.org,
 driver-core@lists.linux.dev, kernel-team@meta.com
References: <20260915-hwpoison-kho-v5-0-3bc7a57bd503@debian.org>
 <20260915-hwpoison-kho-v5-7-3bc7a57bd503@debian.org>
 <de41b78a-8471-4832-be0c-35d410a4499a@kernel.org>
 <aqpczrtIwSG948iv@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aqpczrtIwSG948iv@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9101AC0007
X-Rspam-User: 
X-Stat-Signature: sxqmtpc9sbkxd655onj9maceejmx4ysa
X-HE-Tag: 1789570310-341643
X-HE-Meta: U2FsdGVkX18GcmCEPtUDLvFDgr5Q6/n0aK5w/zm0Flc4lWDJmcCLyj94jGNCKj++T+1cA+PRRUvT+hGWEZUN5IOulPT+L5yBK/ouO2Pv6ea+FB31Bq8OORj1C9BU44dcJZP29WAN2sFs4+2iU/9YN+KTSVS4E/kzj6pCqwh4M/WIxaF8wcI1HbXWmx47uUjMGChCq5chbmbgkAJW/25DBY5/09/eJwd7CcISR+RCZpSYEbF/GpYJpBmPLe2E/Gwwj2sjRa9xz/i0BlHJKK9jDRLrMZmCTaG9jgp1u2mQ3YbOs/ox75mceJU4TDVEAb9iqmzW2vWmQXQoL7+/EFysxrqpkYXma1OzKunZtOfXagrFhmLeDJhilvqOPtepxqCCqH5G7pwm+5Im37hFs27E3L9shx7y733RV0+Nd+GH00nXoqkkFEdGsK2zAuIEQvnCVvDPt0x4d2NXB6R1RyQq7i2iIBYvfPjKAxB8scC0WZI4WtKIN1DC3e3FLzbTWHoSd4Ub9RBp5SRY7JxLC/Bpm8DHVWtUNNhBLuRldxuMazXduyp7S56A/Q6e22k5Y/oAH0ZSh34y+tZQ5w+BvaNCHbs9ZupqlNsFS9PeWboz/l7G0JVrtZtKqE8DHkm+q3NN2fowpY4ptOJzaGk+m5UuOA1C8zn5ouAklzvw7ffYIdYKYOKkRu4+mtywMnQZozPQE3mWaVLZZekRsDSkDPffqFMI9zOIugdzJEdj3v/eO3fwXQodR6AwwX6Xqa5ZKuWbm7v4s4ZVw4jog1Dg7Ws0+mHcF4FVOAFzLePwoMKjAZfKS3+yDqeGn0MMjui9DCsrnOfCICJkLJJdy7CjBQuLRlV+VEetsCBo+3jqjutJ+g9S/9Gku6hmprVsRWPa0SC658+rZDm0pOpYjTMvLRUngEGaKWE21eNBorcHtB7uyMquqvbqst+FEWWL9U5ad/rvpgwlmzv23Q1d1P3dzJ7
 lVe2juL1
 qonWLBdxPgtrqQnS6Aw2ypyZ5lQakH95OtIfQfDYfGeQzLd9pZ5h0UyyRfW4gLCTz0VinH3XRi6I6q7BBZZWJ0OG+dv3uaOhvQ5WmM5Jx7meEuX62NhS86HGMMJFfli8OKpnY1OUiT3yt3pjafrA+oZQVuZ09h7His38p8WahWzNmnNVQkjO4R/GUMi0j3wWaXTjLXxV6+HRJK434lKHqCVH5bZl2ouRvxeSgEZ25G4I6pDTI44Q3p7YN+Qs8uCZwMF+ZnMoo6NNlnDE3kZCeaiomy5FzQHDLV4IwFRe2KEX9k7gYwYKHaWfjocQPCg3foFUmKMWux5FcMu0ZE253WLXi6bJOiGS3jgI7hkQKHr0Ab84=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/16/26 11:35, Breno Leitao wrote:
> Hello David,
> 
> First of all, thanks for your time looking at this patchset.
> 
> On Wed, Sep 16, 2026 at 08:48:56AM +0200, David Hildenbrand (Arm) wrote:
>> On 9/15/26 14:53, Breno Leitao wrote:
>>> +static void memblk_nr_poison_init(struct memory_block *mem)
>>> +{
>>> +	unsigned long pfn = section_nr_to_pfn(mem->start_section_nr);
>>> +	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
>>> +	unsigned long i, nr_poison = 0;
>>> +
>>> +	/* A hotplugged block is created before its pages are online. */
>>> +	if (mem->state != MEM_ONLINE)
>>> +		return;
>>> +
>>> +	if (!range_contains_poisoned_memory(PFN_PHYS(pfn),
>>> +					    nr_pages << PAGE_SHIFT))
>>> +		return;
>>> +
>>> +	for (i = 0; i < nr_pages; i++) {
>>> +		struct page *page = pfn_to_online_page(pfn + i);
>>> +
>>> +		if (page && PageHWPoison(page))
>>> +			nr_poison++;
>>> +	}
>>
>> That just slows down boot unnecessarily on 99.9999999999999999999% of all
>> systems out there.
> 
> hmmm, I am not sure I see it that way.
> 
> The loop only runs for a block the bitmap marks. On a machine with nothing
> recorded the bitmap is all zeros, the range_contains_poisoned_memory() check
> right above it returns false, and the loop never executes.
> 
> What every boot does pay is that check, once per block. The stub installs
> the table whether or not anything was ever recorded in it, so this is not a
> NULL test: it is two 64-bit divisions by the unit size plus a
> find_next_bit() over the single word a 128M block covers at one bit per 2M.
> 
> The real cost (that "for loop above"), comes when you kexec (not on cold
> boot -- given the bitmap is empty), and you are trying to init
> a memory block that has poisoned pages into it. Which seems the right
> trade-off, no?
> 
> That said, can we do better? Yes. The silly win is to let the table say
> whether anything was ever recorded in it, something like a
> linux_efi_poisoned_memory->empty that the first recorded frame clears,
> and return on that before the bitmap is reached at all.
> 
> Is this what you are looking for, or something more drastic?

Ah, that magical "range_contains_poisoned_memory" does a bitmap scan?

I'm sorry, but that is absolutely confusing.

There is no way someone will figure out that range_contains_poisoned_memory()
queries some efi specific bitmap that won't even be able to represent any memory
outside of it's range.

I don't really have time to give a better solution, but starting with the
naming, range_contains_poisoned_memory() is just absolutely misleading.

-- 
Cheers,

David

