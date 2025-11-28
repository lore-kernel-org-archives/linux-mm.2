Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFFFCFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 09:34:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D816C6B0062; Fri, 28 Nov 2025 04:34:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58646B007B; Fri, 28 Nov 2025 04:34:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96596B0088; Fri, 28 Nov 2025 04:34:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B55BA6B0062
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 04:34:12 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 61165591DD
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:34:12 +0000 (UTC)
X-FDA: 84159504744.10.F4B7FDE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id B712A80022
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 09:34:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1C76YP9;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764322450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dhuw+qKXASnxIYADUG+wqO3YsqCdXUp2HtXd/UoTZx0=;
	b=xQqw1QZXGUonLXWIRGPr0tNj48pIkb1i9aWGXfXGNELfm61Gq8m0OgruQ1VkRMW0GYjANA
	9vA5DperRMjV2bzwTby+gFAo8QbpuC4sJSHqx7PwIP8abS7oIftimf7eZ5d9i5iJX+xOlD
	0fojd7YG7ZRJwcoXPdK6s+fqjMSxn8I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=k1C76YP9;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764322450; a=rsa-sha256;
	cv=none;
	b=j5wuGDULPuY877edQaIZm0qJ5S08bNPvtWlkWhVXYGOFFRZIii/Bs6TPSCEqwjafnAAQom
	G6ApXpz9jonMyTRKJo48pkSqpZyPBYzkme4EgPe+k94+FfD/5eXADLu7fg6g9YdcJ+vRvu
	mzgjDAZPx18LKAKH3T34Q2bqLWYmCHU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B40360203;
	Fri, 28 Nov 2025 09:34:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5372EC4CEF1;
	Fri, 28 Nov 2025 09:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764322449;
	bh=2RrLO3ub+tMhHBuf1v3HTs4UiaOhLMuJeLuTeN4cwys=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k1C76YP96Tnw9zH9fBMCNHqDt7gFjXZ+y23temsYDx5IlbUpf7vBgDt76debNr1yK
	 5q9oe7b4kNjao6SQLx8bGZIo5F8yE91F6KJ2gLbqGQiwj8kqI6AxmXV/4Vas1tZeMl
	 vvKxogRYPjvtdv0cdqSH8HwY9ZZhXFV1lix+MCHL/gwxxyA/pooPpJGUq97VbrkI/5
	 kGTYoLED6iwWOuudkioRFpPmzeyxSsO9OyFsa8EUfuhxPwxEmqrHddFBKmru7D5viN
	 fisVB5r/w3Nc1ujtvc/1ybre9to31rIDS3ts4fmSOB2Mvylq/aUV65Ooa8Mvc+NZgg
	 d++WnJxycoxJw==
Message-ID: <27c06cf2-7500-4875-bd22-f55571fb85f9@kernel.org>
Date: Fri, 28 Nov 2025 10:34:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/4] mm: Add support for unaccepted memory hotplug
To: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev,
 linux-efi@vger.kernel.org, x86@kernel.org, linux-kernel@vger.kernel.org,
 tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, ardb@kernel.org, akpm@linux-foundation.org,
 osalvador@suse.de, thomas.lendacky@amd.com, michael.roth@amd.com
References: <20251125175753.1428857-1-prsampat@amd.com>
 <20251125175753.1428857-3-prsampat@amd.com>
 <66ylzwknm4ftd6utn3nqr63jmhl2ccvcdvyi5fechfnvmfxivu@37pckhjixayh>
 <14df1d99-7df0-4982-8029-e66dfb140399@amd.com>
 <dy65eupwalp5wsljetlto27l6tjjvoygeotjd3n7mk7zjc4dma@jf4hzsy6rtcd>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <dy65eupwalp5wsljetlto27l6tjjvoygeotjd3n7mk7zjc4dma@jf4hzsy6rtcd>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 64r4ndt6gjh83dmtq5zkdeeraehbi8oz
X-Rspam-User: 
X-Rspamd-Queue-Id: B712A80022
X-Rspamd-Server: rspam09
X-HE-Tag: 1764322450-898493
X-HE-Meta: U2FsdGVkX1+4BOAf6SwZtcuxlZVhQDzG6L8PhlrBQDW5BrJCvfbjb5pm3V8EmP527lPwWq2N/Kb0ekumoxRe2O1dLsni4ikHv4X8VWmuHkEwFVRCxlzwFy1LtzCka5LWINI9EIcEhreiZpEWewf6ilwWyyslx8C6VQJinlnXhZjsz+FcEH8FyUhJNejdiBHFXi6eIN2Yr/1H39vqMzBnymVXkSk1tKL72nEzkChGv211BlFT1x53mveLdjPVLtcrcPDg8GCUVaPjrf7/jf3cLzM6F4wu6f6vUXEKcEQ9k8mYW6Rq4/dSwGY+7VQQyGUzXsM1s93WMwED3StrvRQe46Vb4Ka4U0rO/hkRgKn4xrS33xhU3NSoplAsxpmNgDbt0YmwfB5ANqPWbQSOYC0lgV5dF5tl6OO90FsTdy1StCjy7OgIVMgmmXQmu2SSPk7+w6S77N38aIxitsRuPgV7jEuLuJMbeG+p+YNa9HIg3PklA32wqpUTSdipd1N2pMSRhkdSsKownQmvs5A3OALyK3xCgq2kdSvtS/Jx4DVo6YfyHRikgtP4twBlqEWQz6zFASDQkPQ7gPyXz4EYajUMLe7dEnMeKOJrZR3hRP0THQBxRvOhLhWd7rzb7DJnsAVD+XcB/kgSekVDE8ANFcKAUMIDMutZFCAC2vt6qWtaDU6bCYAnmoA6m50Eo6jlE9vPngYFpN3C1sdFQoQAIwruBKVkTHUBnSiRe+YeAfsAoONrhXEVcAdRsY/JKTToGe6B2MkEV78IRm16oXSkDcX0TaggKz33g832HrMxWTbDg+kilCyeaxmjh5X+kdKiMGHSs4k7SGR/CtMsZKAOwTlGO/1uGG9aaXgzM56jifEz8JYBsgCt22y1zx02E5K7kFgnBrQW7CPl6QXoolRkZZ0YmJ8wwqLSzyGL3rP8SIZ/RsERI+NaQpfTupbsnuS1dmv+O9nJsXVIWziLZS5tMTS
 8zMxV8bs
 9ALzWoeLTjCIx6lVJ5N7qa592uViZvg2iXBt2mhj0bVYCfg400shjmX7gwIO0IKx+QYNExrKw2Id8CjZA8YyL/J5boo1ROXbkHkosr9JrhMcqTO2Fw+X9cXRaWBqbeAMw43lr5oJ6v4ElUSyPLnQPh4Dl+RGWzKlSGhUq1Sd0Cnkkwbqe428z1CNJePUwXKNVckW8Omzp4x19fhSUURK3/e6mN0udLIDKe13o/1MKqAAmZyDAkU/Ex3ILcKGQ/6SmHKte
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 18:40, Kiryl Shutsemau wrote:
> On Wed, Nov 26, 2025 at 04:27:29PM -0600, Pratik R. Sampat wrote:
>>
>>
>> On 11/26/25 5:12 AM, Kiryl Shutsemau wrote:
>>> On Tue, Nov 25, 2025 at 11:57:51AM -0600, Pratik R. Sampat wrote:
>>>> The unaccepted memory structure currently only supports accepting memory
>>>> present at boot time. The unaccepted table uses a fixed-size bitmap
>>>> reserved in memblock based on the initial memory layout, preventing
>>>> dynamic addition of memory ranges after boot. This causes guest
>>>> termination when memory is hot-added in a secure virtual machine due to
>>>> accessing pages that have not transitioned to private before use.
>>>
>>> How does the hot-pluggable memory look in EFI memory map? I thought
>>> hot-pluggable ranges suppose to be declared thare. The cleanest solution
>>> would be to have hot-pluggable and unaccepted indicated in EFI memory,
>>> so we can size bitmap accordingly upfront.
>>>
>>
>> I'm not quite sure if I fully understand. Do you mean to refer to the
>> EFI_MEMORY_HOT_PLUGGABLE attribute that is used for cold plugged boot
>> memory? If so, wouldn't it still be desirable to increase the size of
>> the bitmap to what was marked as hotpluggable initially?
> 
> I just don't understand how hotpluggable memory presented in EFI memory
> map in presence of unaccepted memory. If not-yet-plugged memory marked
> as unaccepted we can preallocate bitmap upfront and make unaccepted
> memory transparent wrt hotplug.
> 
> BTW, isn't virtio-mem a more attractive target to support than HW-style
> hotplug?

I would have thought so as well, such that we can just let virtio-mem 
take care of any acceptance before actually using hotplugged memory 
(exposing it to the buddy).

Likely there is desire to support other hypervisors?

-- 
Cheers

David

