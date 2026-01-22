Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1BCCD6CFAB
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 22:49:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3370B6B0372; Thu, 22 Jan 2026 17:49:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30E376B037C; Thu, 22 Jan 2026 17:49:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23AD36B037D; Thu, 22 Jan 2026 17:49:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 115FD6B0372
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 17:49:59 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AE88D1AEEAA
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:49:58 +0000 (UTC)
X-FDA: 84361094076.06.1868B46
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C55DF1C0007
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 22:49:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=suv9xQxJ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769122196;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICJuGF5wC0W7ZbSzVriavHpcK9cYzYCQ8RRulw4DujY=;
	b=zISPfqHmLrKYAnYKMiBN8DeROpOPEoJl4tZXtwvEkX1YVddU8Nu8jA+8zQ6RPIUTAVpiWN
	jFwQE0dqeGuKLzyzF896qy0lPPTfX7aTNHcGMEXBN7+aDZ/VQ3d4QN+0NK2d6sSuAfaUkd
	AO6qVLXslFQtzd5yL0/tO6DLQFfEJvk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=suv9xQxJ;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769122197; a=rsa-sha256;
	cv=none;
	b=5wdeHjxD+lslYvTmFD6dHNbUEpd8gzuRISPqeETq0bQBfZyLfX3BaMiJFz+DLk655J7gof
	yQ3H+g4sMkKfpGpmJiLPDWZB3VkUmo/FdZDPSuukS2++UlARw9IPnpiEHKBom4ZTaxNOQa
	11gmXwihfOjROFf8Aee1aiKC5Oppq30=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D9302434E7;
	Thu, 22 Jan 2026 22:49:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1FE3C116C6;
	Thu, 22 Jan 2026 22:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769122195;
	bh=eWzfvBBJVfH3cs7Ugnr5IAe0m04aC03BbCpeh0poZTg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=suv9xQxJ/OmsZ2P8dFYa94e6zxbPnmiJ8c4Kih4qUGg8/Kg23CZNqKuShF8Vjn+5e
	 IajYFVdMGTxzAo+o3q519CqQcmjnjMQUPUj6gKVctafcwRnYCUpKkrrP2WCSHyXu/e
	 s0ybylPA2yN6Tl/B+pJsHt/eRo0fY/W0Cb4X+opdsYqn/6FGm42hsBuhmDgj7+/6Hn
	 I2rnalAP7r7wD3p4cuBp7np1bXBKVmNu/yakcfPmnLMbm8JZQcvr5F0CrlNDSoVZ2y
	 TsLHPowYb66DRZhr2IfUW1cfAGuJPgy1tkLnaKcN2AWbhZWOFYupXXhRiV9gWBhUro
	 8Y4Q5ZR+GQU+g==
Message-ID: <57c5f44f-3921-478b-843b-877fae536591@kernel.org>
Date: Thu, 22 Jan 2026 23:49:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7/8] dax/kmem: add sysfs interface for runtime hotplug
 state control
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
 linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
 kernel-team@meta.com, dan.j.williams@intel.com, vishal.l.verma@intel.com,
 dave.jiang@intel.com, mst@redhat.com, jasowang@redhat.com,
 xuanzhuo@linux.alibaba.com, eperezma@redhat.com, osalvador@suse.de,
 akpm@linux-foundation.org
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-8-gourry@gourry.net>
 <3555385d-23de-492c-8192-a991f91d4343@kernel.org>
 <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aWfcYjZVrROHfGyh@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4nz5g9tfgprmqimgkpb3insjfpup5jyo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C55DF1C0007
X-HE-Tag: 1769122196-336537
X-HE-Meta: U2FsdGVkX1/jMLta4wc8HxPPR7OFce1qSU3hCOowciqyY9UEWoTf5nKyJQVnvCuHj8esb9NcPJTngoQ9+kVKk1aghJQs83VsdA2gtT7w1rB+TltZjEkSwRpX5WttNWz4C7Jct073yBtO240jpV5wHVSnk5c5UDWYNBNdaJ9jo9V6iP+dzDbu2NUq1vXV6JiLAjwYRkdvRKzfFsE12QTDOTRpOVRH3f5J19+YhPkeSS7AgcR5abFMSuDCy5KlT1E9WhUiaXZ3S+2qXdvvE7cc8KEprfwhL08lcTXYl/pO7qzhYeOUfGSaoVKW/qgW8TtDCwcXKczypuRqnYCca1aHVfeMoc/79VGmNHdJw86NGF2KKz+a2BQocQaeJ/TWkFIJDDclFzyjrEm/zucmXXG8pBKRonEtzn2DD8nym5Aa1f3h8wLwa9t/OrVHVLFRVtbSouhfWxgw8p/rT/wp+bgbNY0ncc0rezW9lvzFq0sJ13WR1wwCTe3q8c3uNo+UY/t1t5zibamrHVBsO4N3BQDu4Os0aEwgitzroQ/whBfzY7hyxLYsI0KOl9HP35A41HLSzKBNU+pvkDWBG9bg9Iq2q9J2yxBPY0a2W+9jTMj8alKizbmZbIUQKB4sr02Yl9heAVvx/m6ty7EDgtcOPbjB0PhhGO695ncDjS4sCM79BR4opJg9OqIcsEFGiAabOn9+mdvbJbSL6kaemianAHW7xd2t0w0JlqN7nRlq/EFK7olgSmxXQvaMyFXP3JksBoB9Zw2yi+hvRE0W3m5fHa/w3TNhI8x592GoSfj8WHxoIAth836Ch05S8hYUe4Iwp7X6e0kyAXEIYQFsRQH04aVExEXN/hoEFVOBovGhujCi8VET7Zj8pFydMUtC/JgZjH/GZzdL750xJ0mH2iyMRoZeIK9z+5Oikn2wMmzR3gyjExj2vOgqF9MAoqGRLg4lTDCi2m20kNvYtrIRsRG0i4W
 vaNkNE3I
 HtH8E6jD4Vhbz8Yxdb/08y1dG4dmWIY9eE9dSM1zKfqOVKO7EwUAGhwJuZFuFa3/zPA3dy0Y2SXPpXJFlpoA7/cvrNQe7TJGrcbmlVvajVug5UbEcBT10XLDZ8n4YsqSPNBm/xD3rAEvvPNv050DrMO92Igx5b3KITu8vOFUW//5Hxj88yrTh9p37tPwuIri90+BO58VZfFjDYAubHEc7lEnMNIO1PMs1d4innjkjpGi67YYDQ24Au8V3xf1HrM0QUYwI
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/14/26 19:11, Gregory Price wrote:
> On Wed, Jan 14, 2026 at 11:55:21AM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/14/26 09:51, Gregory Price wrote:
>>> The dax kmem driver currently onlines memory automatically during
>>> probe using the system's default online policy but provides no way
>>> to control or query the memory state at runtime. Users cannot change
>>> the online type after probe, and there's no atomic way to offline and
>>> remove memory blocks together.
>>>
>>> Add a new 'hotplug' sysfs attribute that allows userspace to control
>>> and query the memory state. The interface supports the following states:
>>>
>>>     - "offline": memory is added but not online
>>>     - "online": memory is online as normal system RAM
>>>     - "online_movable": memory is online in ZONE_MOVABLE
>>>     - "unplug": memory is offlined and removed
>>>
>>> The initial state after probe uses MMOP_SYSTEM_DEFAULT to preserve
>>> backwards compatibility - existing systems with auto-online policies
>>> will continue to work as before.
>>>
>>> The state machine enforces valid transitions:
>>>     - From offline: can transition to online, online_movable, or unplug
>>>     - From online/online_movable: can transition to offline or unplug
>>>     - Cannot switch directly between online and online_movable
>>
>> Do we have to support these transitions right from the start?
>>
>> What are the use cases for adding memory as offline and then onlining it,
>> and why do we have to support that through this interface?
>>
> 
> After a re-read of the feedback - are you suggested to basically kill the
> entire offline state of blocks entirely? (e.g. if a driver calls to
> offline a block, instead fully unplug it)

I'm merely wondering why, in the new world, you would even want the 
offline state.

So what are the use cases for that?


Sure, memory onlining can (in debug configs) fail, so you can maneuver 
yourself into a position where some memory is online and other is offline.

But "unfortunately having some memory blocks offline" is something 
different then user space explicitly asking to "keep all of it offline".

Why would user space possibly want that?

> 
> I took a look at the acpi and ppc code you suggested, and I think they
> also have "expect offline then online" as a default expectation.  I
> can't speak to those users requirements.

That's because the policy is defined by user space, and in contrast to 
CXL, hotplug of APPI is *not* triggered by user space, but by hardware / 
hypervisor.

> 
> This would definitely break things like daxctl/ndctl, but maybe that's
> preferable?  I pointed out that patch 8 does this anyway - and I'd like
> input from ndctl folks as to whether that should end in a NACK.

You mean that it would break the ndctl option to keep memory offline?

Can't ndctl just use the old (existing) interface if such an operation 
is requested, and the new one (you want to add) when we want to do 
something reasonable (actually use system ram? :) ).

-- 
Cheers

David

