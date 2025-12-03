Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D76FD12D41
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 75A356B0029; Wed,  3 Dec 2025 06:22:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7314A6B002A; Wed,  3 Dec 2025 06:22:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 66E3B6B002B; Wed,  3 Dec 2025 06:22:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 55C676B0029
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:22:40 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 12AA3BA636
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:22:40 +0000 (UTC)
X-FDA: 84177922080.14.9C5C91D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3D7D6A000E
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:22:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h1MQbpxV;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764760958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1SCgMHqFatyBVvirqGBwfnr2sJ9r9hMYmJdXqkpxGVI=;
	b=zSo5abEhexDnLiVf+gjod2VpNqms5RW9V6NfjkYbKvBP/G8++rpqokHcDxl71dzdQw42ln
	xTfcHUdVjZTXIlttzS2mBslafArXKUQqCWWblG49oTaIkH2NmuiuaGQBIidwWDQ1dDw898
	HEbw/Vai/E1TJLjt4DH2VjVqpl2HCh4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=h1MQbpxV;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764760958; a=rsa-sha256;
	cv=none;
	b=Ybku0Ry/LbopaRepSGYsvyjjy2oKYjOJYFjSoqpFr1u3Ki3VC1QUKp39GyE57xaw/F4S9s
	RfYHSEwgtfjLaWdMblNEjE0ACq9p/qhFjwBcW5blB1DRadnpwCjQm+Ks4jurRHATJ3ysAn
	6ZtUtdL28oACN8TWARFq7snttnd0bWE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3CE5417B7;
	Wed,  3 Dec 2025 11:22:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C68CC4CEFB;
	Wed,  3 Dec 2025 11:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764760956;
	bh=Ra70rAIPocOZwVn8LAoNGHSFsWLKLEMD4yOgJi1DkYQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=h1MQbpxV1pat+Gn/jAhwJCr0oz4+Izs2LeA/8W8gcmVlXTJpjcrPgJW8VinebpcqT
	 lioBrQXYXvOw0prQ4x5kX+aCLAM51nwfQ+1tKxlUdKrRaMHcooYDwdKmEZ1WcynRWq
	 2+gFdyRobfK2eXUoFCbuaHg7JeLUm2fGMG6GaM2plsKHG/8Wf8+/IudiV+1Gx+j2+5
	 GWFnXkLFkUjMFO4JBRyf0Dgf5KdHegXlinoZRKt4P8U8Cusk/Xw9dClzaGmIpQc5cz
	 clIMaCHvw6tNscd+dHnWgDs6smoBMHwS+hu27OjUBKuMDGPsf0uSazrvXG8IK4fhA9
	 2mo9JjqvjkW2g==
Message-ID: <4a9950fb-471e-4b04-8a0e-0f34e8b6a082@kernel.org>
Date: Wed, 3 Dec 2025 12:22:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/page_alloc: make percpu_pagelist_high_fraction reads
 lock-free
To: Michal Hocko <mhocko@suse.com>
Cc: Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 Aboorva Devarajan <aboorvad@linux.ibm.com>, vbabka@suse.cz,
 surenb@google.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Oscar Salvador <OSalvador@suse.com>
References: <20251201060009.1420792-1-aboorvad@linux.ibm.com>
 <20251201094112.07eb1e588b6da2ee70c4641d@linux-foundation.org>
 <aS_0bgCs2qE0y1bJ@tiehlicka> <aS_2Z6ROtrxLQcRN@gourry-fedora-PF4VCD3F>
 <aS_4E2H5aJmSvWF7@tiehlicka> <aS_8BgwR3R_geayy@gourry-fedora-PF4VCD3F>
 <8b89bb59-6b6a-4a79-a571-e97b9ae5287f@kernel.org>
 <aTAGBPuS_iUAWNKO@tiehlicka>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <aTAGBPuS_iUAWNKO@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 3D7D6A000E
X-Rspamd-Server: rspam02
X-Stat-Signature: 3rfkgjhikzbdf8m1mosqiuzqhz1ef98x
X-Rspam-User: 
X-HE-Tag: 1764760957-212700
X-HE-Meta: U2FsdGVkX19NbPoZbburSzwcKxBpLmt4eTqtc2WsqnW2q3LNx1dqJOG5AHyYHGaNlyQfrks+U/cohH7q38rbyIE1ICBzgrafREjGaJm6Y8TEsNt6sH6sdPxgjuKs4qEc4FlUg1FI43aaF5CJInpoTQrFCj4vGRRt1/vAznwO85hpoenZDQ7CIgCf2YxsXFcOKWuOZVbyORDtB//QJ+DzAurwDFyChEmkDdNR6SUYTguvY34vId9Gq+3YMOghkVroMV0zzvq5MKWWXyMn2gsZ6awSwD3mF3v8X6P5GL02QJDQ+/WUcjF2K9VXKyimiFG8WAraneNPgCvtnrITCqlldkUYYdYCFu4APph1DvmKG47gt5Z6qjGgDRnpzslxTGocl+t3Nr3GJ4f40nHQgzXHWe78LeSVSjO01OE7fSpWExaKog9dF8PEBuv1RTta7GS9dunV9TbKYPsb0R4KY4khAL/nNb9k2sFGUVviB/tWT23k8bDg+0vAfAlt1W3YLmxuuWgiT2fI6urwN95+EjiDZ8VAiOB6pGWzbl3PNvzQNkI3idKsj1s8iUdFKFMPDhLD362YhmkaW1gBf4ROMnYatXG61cMwfNCTwMAFmeZ/9oS03I20JKsxreawgFBgnBTqocaRjV5nj7fW8kO3kAlt+J34tVK4c6ZMUf/kXBO9dyPYFdJFg/hBvGoGITkAgvNtVtcs+fdN3WRVTBTyq7jECXO0+bj186RAOG+sGpD+TiEY6ZRtIWGofphfVuqX8Ye3LEMLaRs4OQvwk/6N1Pfwv20GFK9+zQHthKoFbi4dfD31iyYH1ZRp17o+pXPKvY+JVyPnfH3FEhQjOhMjxHvlfnZtUAGWa+9aV4dr5mjitkYxRARkpPBuAbfo34LU31DsWLLr0qXQqDufpmUDdr+T5GOuqWQiNQ8lirIC3GWEvRBsUrPTuHds1xDZhe9vbK57KdmYDnPVvqhR3CchhFU
 GDIOCNWA
 kj6R3IVXhRNce8HT+Z7OjnwSf/TccGlA0hwrV4LnNOnTqm7H+SYORq6OO3IdU+LHwip5I4nmjfC6iQGU5YUGT1DeyU7MntYDVNWsYjtsmkWrV4ZDcQUw+P5BJ8Q69wTG6pl3FybEj9gdarevDXvyojwSeaJlbTOJTFOOFwYNskMF1/V6tjcxMMcFjFmM8FCXDpScaA1mRQaoRp7fe5JIQRtDOGld0EcH82Kq/mi1L1wOztqkXKIw9d24OZS0aOrXJjlrRBCR6CziR7W75n/UOPtTM3jMJEybio1dMAGfZtk5YyW4IYUyn88LEpw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 10:42, Michal Hocko wrote:
> On Wed 03-12-25 10:15:04, David Hildenbrand (Red Hat) wrote:
>> On 12/3/25 09:59, Gregory Price wrote:
>>> On Wed, Dec 03, 2025 at 09:42:59AM +0100, Michal Hocko wrote:
>>>> On Wed 03-12-25 03:35:51, Gregory Price wrote:
>>>>> 		if (!ret) {
>>>>> 			/*
>>>>> 			 * TODO: fatal migration failures should bail
>>>>> 			 * out
>>>>> 			 */
>>>>> 			do_migrate_range(pfn, end_pfn);
>>>>> 		}
>>>>>
>>>>> Maybe it's time to implement the bail out?
>>>>
>>>> That would be great but can we tell transient from permanent migration
>>>> failures? Maybe long term pins could be treated as permanent failure.
>>>>
>>>
>>> I see deep in migration code `migrate_pages_batch()` we would return
>>> "Some other failure" as fatal:
>>>
>>> 	switch(rc) {
>>> 	case -ENOMEM:
>>> 		...
>>> 		/* Note: some long-term pin handing is done here */
>>> 		break;
>>> 	case -EAGAIN:
>>> 		...
>>> 		break;
>>> 	case 0:
>>> 		...
>>> 		list_move_tail(&folio->lru, &unmap_folios);
>>> 		list_add_tail(&dst->lru, &dst_folios);
>>> 		break;
>>> 	default:
>>> 		/*
>>> 		 * Permanent failure (-EBUSY, etc.):
>>> 		 * unlike -EAGAIN case, the failed folio is
>>> 		 * removed from migration folio list and not
>>> 		 * retried in the next outer loop.
>>> 		 */
>>> 		nr_failed++;
>>> 		stats->nr_thp_failed += is_thp;
>>> 		stats->nr_failed_pages += nr_pages;
>>> 		break;
>>> 	}
>>>
>>> So at a minimum we could at least check for !(ENOMEM,EAGAIN) I suppose?
>>>
>>> It's unclear to me based on this code here how longerm pinning would
>>> return.  Maybe David knows.
>>
>> I would assume that additional references will always result in -EAGAIN.
>> Remember that we cannot distinguish short-term pins from long-term pins.
>>
>> We should never have longterm-pins on ZONE_MOVABLE, unless something broke
>> that contract and needs to be fixed.
> 
> Right. But what should the hotplug code do under that condition. Loop
> for ever or fail reporting the broken contract? I would lean towards the
> latter. 

If you can detect it reliably.

> We have never promised that offlining will not fail ever for
> movable zones. We just guarantee that the operation is resistant against
> recovarable failures.

Right, but we don't want it to fail for reasons where retrying a bit longer
would just have worked.


What we document is:

Memory Offlining and ZONE_MOVABLE
---------------------------------

Even with ZONE_MOVABLE, there are some corner cases where offlining a memory
block might fail:

... list of corner cases

Further, when running into out of memory situations while migrating pages, or
when still encountering permanently unmovable pages within ZONE_MOVABLE
(-> BUG), memory offlining will keep retrying until it eventually succeeds.

When offlining is triggered from user space, the offlining context can be
terminated by sending a signal. A timeout based offlining can easily be
implemented via::

	% timeout $TIMEOUT offline_block | failure_handling

-- 
Cheers

David

