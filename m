Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FDD5F34C5C
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:47:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54506B0095; Mon, 13 Apr 2026 11:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B2BB86B0099; Mon, 13 Apr 2026 11:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1BFF6B009B; Mon, 13 Apr 2026 11:47:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8F1626B0095
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:47:12 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 471C216024C
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:47:12 +0000 (UTC)
X-FDA: 84653961504.11.BB60F4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 43AED1C000A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:47:10 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MMRDjhWl;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776095230;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z8LPd936gYzvFCUq0CkS0h5s6ZKp5U3pRoM0FLEvmlI=;
	b=lLCT5D3e+m65/2MUSDn+h41LBavWHpaDaCt/gNinF4Z4SSjhLTh9Va/iceV3lK+qyirEUy
	KrUzGJ/1axl90KA9apgisQ3gQKrorq2C4fEry/11WiSpElsd8yvs0e94CX349unKTMnUKf
	WxW+n49uJ1fTyFAB0p/74qFIItckvOE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MMRDjhWl;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776095230; a=rsa-sha256;
	cv=none;
	b=FwsvPuAcxU8UpNXNwR7fcGYNoloE38HA2kdEi1CX5zefgpdhRFpUfE9H/pQB7f2ona38ud
	XnqC+HsVKcZ5se/I/KL6p17L60/2Fswgb9SZ6G0u0H5rS/S3+11SSMTd+1EfpB9keanuUg
	sGM5Dxsifq+nU8RldwxxixkA+4aMBcY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8657960172;
	Mon, 13 Apr 2026 15:47:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D55C2BCAF;
	Mon, 13 Apr 2026 15:47:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776095229;
	bh=3GI/MCP1kRVutqcg9+UyZVZDvXObMmYiIvH2qlP/Pas=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MMRDjhWlMKJPMs2+iTlIf8F74H8+UudDBdSsUdEdSrw1JT4c7Wd337cKZhW4zK88t
	 JnewE19+O9IMHhXiE9vbYldk2/3shX6DJuw3OHYQk/PiNRGLcg10jN3Mfp6JAr0HrY
	 T6joA+2bDTdU7slp8i9CiUB/mvAEqS1SJWMcuUBb4U0MIWYktk9MgdAal5j/Vsy5mt
	 1azXCs5SXrS+D8H5AvwZ7IQ0ALa4vHdE7Dw0rzc7zE44Xqrj405tqJt2ODO3sP2vMm
	 YGOdL3TTfG+3iEqNxj7YgDoPXV1NGi0yT/JkgZ8nwoEfMliQ+9bGLdu93OQpfurveh
	 DHd6XCxZCatcQ==
Message-ID: <a4be48f2-ab0a-4808-a7db-2532ec65ad0b@kernel.org>
Date: Mon, 13 Apr 2026 17:47:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/8] dax/kmem: atomic whole-device hotplug via sysfs
To: Gregory Price <gourry@gourry.net>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
 osalvador@suse.de, dan.j.williams@intel.com, ljs@kernel.org,
 Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, linux-kernel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, kernel-team@meta.com
References: <20260321150404.3288786-1-gourry@gourry.net>
 <20260321104021.4a6074330131a2058e8706bd@linux-foundation.org>
 <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ab7_AVLgzLaDRcv5@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 43AED1C000A
X-Stat-Signature: 6mz9fz4qsbbiji144yoh491yhcjx7nxz
X-Rspamd-Server: rspam06
X-HE-Tag: 1776095230-688766
X-HE-Meta: U2FsdGVkX19IUBJXz7jjUhDfbLNs9GD5qsylzc8DDvQxtz+sE5EuoLc/DukMalYG1I6IHDeEa4LskASKWoPcgXhTTiOv2Xk4Ms0yukDUx75wI886ljhqKKrETwObG24/QBAmwEpUrLFR/ZwfL8FlxzQ1vmZelfT9xGUvPvna9q34wO1NcAEs35Q7ySB/k6seTLxGL9KlT8lh/6rQE0fCPzCjy1eAFDMO6pb3Ksz56FkzNTwNBhhnOL0g2Twplw0N2H8sRq0SeazanA50DwefbFxaWEgPRldWxjSGVYOwPhmqVwu2yAOKpHriYiRqyoHG7HUBKUNUaW0oLqUpVU7ibEczGAaUXfsSApsrHu5YrM1ebXxu31ZPRlDiifoZglEk0m6ryo3qnZWBVMZcXsAtxV0LcGr9sxwVdCeg1wtjXBeGNb2HimZnA0U2nlgpYVVj9N83Ff0IWF00MaytQoKtIVQTHH6L1zq0jj7CBAM8ZJ/h+UjtoJwEEdsqFkRQcZxuhn78O7jGAFVil1FrQ/3HX00wWeYaG1WCHJK4bNRehRhsHQ/X1d5Wuo1Mm6Cm7EEXa29kxd/+14EFDum0aaHSBnmyDBFCHJzSXv/NqpxUbGCIURGAw7QBwYpcrAu+px02CdRh09VeWiRortiBITwhQx/0WCCyZdH8X9vUpjFCuXEwxnUIqQos/4rOrK5xhdU6FMIejJv53Sld5MQHSc0bCC6qN5H0tm6v8VABCAwJEmslDPCQ9NTEIS5qwFBgwHWOV8wLmN/rtq/DzD1aFXp0N2PjwQ95ovkbG7BlSX9CL+2fQD2wISST1rn3JLGaEJT3wYuYPxPqKeM6XfEkUpjVk4sAdG85fqY/e2x8Z+x7HRA2gz/1MVwO+zBO43eRzrCZgWGbHxUy1ZS3mVFGQZLkX8iDGF4VmeCOcdyf/CiTsHrASWwvK/QAqolg4Q9xbk2XyF7FK6wL4qhpY+3H7dq
 KcPcoEK4
 U95EwGcjjJcKWlFqiaMACWqhdFERrlIjIRyzDj8hOvZT48GavZACOaf5f7iSdKQ8VHjdw1wFGla7/TjWrWxAkRS1BUd2l1KeQKqC9eV7HY2Oqfiy9hMwNKEnCcMQl6vetOhNBbbeCbbTYM4a/C/z3/QVlPscjTUuJiYdPALKETPFZurksQY0goB8ik8vWKDZM6sdQ8bEqnS2ZpaRMyIKlLuLOwKPCHSfQzxdwN2fiRFVA2aDoVgLQ2wA+eOJZCslXFVCPG3dcG7Vm3ErOQ4HHwo6F5t/lMCCK9vYK2jP2p01yTQbZmRDS3YEhXMbImQv12FzV+zfEolVJ1vqU9C4hdecbSv9Gm+R7aeTFqK7JcB5lps0RtAcjXY7vlYF+zZu9VEyAbMVnU8AIgJUE5NfCqz0Ezd41PelbRp1c0r8pb5anMZRpS30863sfrkRSkmhnH9a7Jsbb/pOffvX78urrlNfgdfkV5ejiqMfntNSY0UdBxQM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/21/26 21:26, Gregory Price wrote:
> On Sat, Mar 21, 2026 at 10:40:21AM -0700, Andrew Morton wrote:
>> On Sat, 21 Mar 2026 11:03:56 -0400 Gregory Price <gourry@gourry.net> wrote:
>>
>>> The dax kmem driver currently onlines memory during probe using the
>>> system default policy, with no way to control or query the region state
>>> at runtime - other than by inspecting the state of individual blocks.
>>>
>>> Offlining and removing an entire region requires operating on individual
>>> memory blocks, creating race conditions where external entities can
>>> interfere between the offline and remove steps.
>>>
>>> The problem was discussed specifically in the LPC2025 device memory
>>> sessions - https://lpc.events/event/19/contributions/2016/ - where
>>> it was discussed how the non-atomic interface for dax hotplug is causing
>>> issues in some distributions which have competing userland controllers
>>> that interfere with each other.
>>>
>>> This series adds a sysfs "hotplug" attribute for atomic whole-device
>>> hotplug control, along with the mm and dax plumbing to support it.
>>
>> AI review (which hasn't completed at this time) has a lot to say:
>> 	https://sashiko.dev/#/patchset/20260321150404.3288786-1-gourry@gourry.net
> 
> Looking at the results - i mucked up a UAF during the rebase that i
> didn't catch during testing.  Will clean that up.
> 
> I also just realized I left an extern in one of the patches that I
> thought I had removed.
> 
> So I owe a respin on this in more ways than one.
> 
> But on the AI review comment for non-trivial stuff
> ---
> 
> Much of the remaining commentary is about either the pre-existing code
> race conditions, or design questions in the space of that race
> condition.
> 
> Specifically: userland can still try to twiddle the memoryN/state bits
> while the dax device loops over non-contiguous regions.

dax_kmem_do_hotremove() loops over offline_and_remove_memory(). And once
something was removed, it can no longer get onlined, obviously. So that
should be good.

dax_kmem_do_hotplug() loops over __add_memory_driver_managed() and
onlines the memory directly using the specified policy.

User space can only interact with that after memory was already onlined.

So, really only user space can try offlining the memory after requested
onlining succeeded.

I don't think any udev rules do that? The usually only request to
online, which should be fine.

So if a user does that manually, good for him. We just have to make sure
that stuff keeps working as expected.

Or am I missing a case?

> 
> I dropped this commit:
> https://lore.kernel.org/all/20260114235022.3437787-6-gourry@gourry.net/
> 
> From the series, because the feedback here:
> https://lore.kernel.org/linux-mm/d1938a63-839b-44a5-a68f-34ad290fef21@kernel.org/
> 
> suggested that offline_and_remove_memory() would resolve the race
> condition problem - but the patch proposed actually solved two issues:
> 
> 1) Inconsistent hotplug state issue (user is still using the old
>    per-block offlining pattern)
> 
> 2) The old offline pattern calling BUG() instead of WARN() when trying
>    to unbind while things are still online.
> 
> But this goes to the issue of:  If the race condition in userland has
> been around for many years, is it to be considered a feature we should
> not break - or on what time scale should we consider breaking it?

I think the only thing we care about is that even if udev rules
interact, that things just keeps working as expected.

That should be the case (see above) unless I am missing something?


I'll note that offline_and_remove_memory() can take a long time/forever
to succeed. User space can abort it by sending a critical signal.

For example, if you do

$ echo "unplugged" > magic_device_file

And it hangs, user space can kill the "echo" command, sending a fatal
signal and making offline_and_remove_memory() fail.

The question is, if you want to do your best to revert the other offline
operations and try re-adding/onlining what you already offlined.

offline_and_remove_memory() handles that much nicer internally, as it
tries to revert offlining, and only removes once everything was offlined.

I think I raised it previously, but you could add a
offline_and_remove_memory_ranges() that consumes multiple ranges, and
would do this for you under a single lock_device_hotplug().

-- 
Cheers,

David

