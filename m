Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 272CFEA7944
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 19:59:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 907C46B0093; Wed,  4 Feb 2026 14:59:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF8F6B0096; Wed,  4 Feb 2026 14:59:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DF4C6B0098; Wed,  4 Feb 2026 14:59:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6396B0093
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 14:59:14 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD5E71A0291
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:59:13 +0000 (UTC)
X-FDA: 84407838186.17.B8FCFBC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 1183320007
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 19:59:11 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ldpXkUS1;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770235152;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEE0snW1c0yyhQTqHtYDbkG6NF+2an5RXcvUDICSa1U=;
	b=iNV4STHY9zlJnc0/6OwzPxSmSb5tZ7jNZ1meF+DVL+AJy9mdAwYL7qnEADC2Svb5pF6e+M
	CINYjkdrGp3/lTHTlF8DRizSwtViVMqpduSy7AiSpY4EAIQm1ngdgH780T+GSvyq2UuS+t
	BrqpEJIGvTJOwO6CNh3PWBOd5SkMB98=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ldpXkUS1;
	spf=pass (imf13.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770235152; a=rsa-sha256;
	cv=none;
	b=A2M22PlwcERCqPWPzun1hQFnoI6EscHlfX9/NF3hFs+ixKOsOckqkSk7y2Aj6WZtsdDu+6
	+F0qkTdQkIY/uTEdrXxqhpo9yOE9ANkdYnilGdm8U5yDCSR8mnk0FF8I7S/4wtFVlNorIE
	rCIsGC1qI/jF+3/q3U9dB1Fy1bmEj28=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6C0A160018;
	Wed,  4 Feb 2026 19:59:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32D2CC4CEF7;
	Wed,  4 Feb 2026 19:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770235151;
	bh=nPN9Wvy1E775/lgZvMVwn3Lvoht3KjaZQK/EfFGaIds=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ldpXkUS1iICiHnYGoD5ql4tiISVVvP7um/WsyvXhQetlA4SBh0uL20QqUpODVTf7c
	 KjT7GB5T9VWYAizuAPw5wNsrI6wFlO0LFJMbBJXXL+u4KWdweqQxVly1s+9SXCY+5B
	 jf/38/LdUF4/YMlMeAmMZpleptWpilEyvLLLHcfaOmChTLhcaol2jxqvlnDjLB/Hni
	 qgxgQcqqjyDiWhEA2YfdFYFanDds8DxJmBr8s7Xm6a//vukHQeCkqrA8AvORLliOdn
	 zpiwFE0Zbsa6no4r4vBx2Hx/kQjd5LY4lBYdT6DPq/7y/fdm/0ZfPPEd6onbsHVcc+
	 K3sJUI6W08TNg==
Message-ID: <29b4dc97-bb01-42fd-8ccd-f4cb2886ccd3@kernel.org>
Date: Wed, 4 Feb 2026 20:59:05 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] mm/memory_hotplug: Add support to accept memory
 during hot-add
To: Kiryl Shutsemau <kas@kernel.org>, "Pratik R. Sampat" <prsampat@amd.com>
Cc: linux-mm@kvack.org, linux-coco@lists.linux.dev, x86@kernel.org,
 linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
 bp@alien8.de, dave.hansen@linux.intel.com, ardb@kernel.org,
 akpm@linux-foundation.org, osalvador@suse.de, thomas.lendacky@amd.com,
 michael.roth@amd.com
References: <20260203174946.1198053-1-prsampat@amd.com>
 <20260203174946.1198053-2-prsampat@amd.com> <aYMjjyVVax5cml9B@thinkstation>
From: "David Hildenbrand (arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYMjjyVVax5cml9B@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1183320007
X-Stat-Signature: gyja9eob737nqbjtk7mentwjjirb9wq1
X-Rspam-User: 
X-HE-Tag: 1770235151-469691
X-HE-Meta: U2FsdGVkX18GsCT2mGsYnZbIuc+M6+siK+vZFv4sDj7q1F51M0TZrlYqb3bJ6lrPjrkYtG3NEjMOJVaicZON+eVaMKn7X8oCsLctyQMi+exqrLDtef+pdDDU0yX3BwoO8dV5BwoghMlTXg3pJQ/sF2GQGql+2hWrKi0NP/tzgu0eZacg2fUrCACWvPd2Eg46UJjrCQM8Bej01RlwIhz82KJRvmvpGO7DxM8FIUTuOw8JR6aKDXyxUCJCPvEP8udnqGRsg++mfoXrIX7PW3OzBEL+pI0A35wfi3BmhGobxsqT5833NmoozbULs5DADz5/FoRJiQl2zhQZAuwBztUfN46Z8t/0xk+e7Fm5rRhkzu1ofd9JoY7cn2EgyYlM61bi8WIOEiP69HXSu2u3AfwZbGhy1D+vdQ7kIkDO2V2zLfMy/qm0Aju5pcsl7kHeYP+VksnH5KqxeJiYaUhW7k1oJqb605vC1fTS6vFDEQXM2PilVufV0bPXkClLmkV49vt4JT4wvGYNjqY8LBft8feh2qd26pJFvgtRzoaUIDuT5FfLByxrNDmyZTYYE2nEEubndcSCVkpOWHycWhKWH1ooMQwsXZxpY6gCG3MVKQjOdD27ufOSEE6R5buaDptyHCX7xWEl4i+zhwESOYn5Z3mpTAhn1J2xvyBB6Sr5kd76DIGsoTLuzw13id5A73GmVL5mVy6akR+D3T3D26Ag8dFGjIFvDFoKrSolF3RIoFOYDrqvqdnsIgcg31TY2xsOmJ7Y4MmF7iRCEiy6+W3ygfV3OsdnJjy01X0jpCDyp7T6N3SyQycv8MnHgVAdasf0adIpkn+mS/Re70cWSMHRgTCvA7YTJOFddDEuu2YeLvKJzNgvJhRJnHYvWVyEzH7UL0/u74tiPqUScH6rYc8J9W+jjeLi0e8sesfeKw1s5kufzkICknuRlsecu8O/v0bZn6khCx3jYQmCChIQDeUBcWj
 0q9wFsra
 /DXWnRLoZ7PW4Zvok8cJ0TK/mUoVReu5OUy/rw2QgXzZa564uebZeQecflPO78Wc4k3d4yFMCKZkRDFtOsjb+KxZsFSkBtD/NQ6++SYLY7T+hXGX/68bydCkERT53FWZSjqu9JqCuPpJA8jIze2xtDs8Gn3DMXXzkEvh0RC+0LMjQlB/oryxgBcK0uqsgyOUspbXoyeerhu8xhkQcQxjI9cL8ACxxUU9ftdLxVyMz4lHc8AeMuMOI5c9C2nRMXO0JH36MoxIw0z7hiA1A048y9IcteRRqeM4OBDM8d4EDfULQCri6h5qm6DumpIDfjVzMuiWqxKQCWuppJtU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 12:22, Kiryl Shutsemau wrote:
> On Tue, Feb 03, 2026 at 11:49:45AM -0600, Pratik R. Sampat wrote:
>> Confidential computing guests require memory to be accepted before use.
>> The unaccepted memory bitmap maintained by firmware does not track
>> most hotplugged memory ranges apart from system memory annotated to be
>> cold plugged at boot.
>>
>> Explicitly validate and transition the newly added memory to a private
>> state, making it usable by the guest.
>>
>> Signed-off-by: Pratik R. Sampat <prsampat@amd.com>
>> ---
>>   drivers/firmware/efi/unaccepted_memory.c | 47 ++++++++++++++++++++++++
>>   include/linux/mm.h                       |  5 +++
>>   mm/memory_hotplug.c                      |  2 +
>>   3 files changed, 54 insertions(+)
>>
>> diff --git a/drivers/firmware/efi/unaccepted_memory.c b/drivers/firmware/efi/unaccepted_memory.c
>> index c2c067eff634..359779133cb4 100644
>> --- a/drivers/firmware/efi/unaccepted_memory.c
>> +++ b/drivers/firmware/efi/unaccepted_memory.c
>> @@ -209,6 +209,53 @@ bool range_contains_unaccepted_memory(phys_addr_t start, unsigned long size)
>>   	return ret;
>>   }
>>   
>> +/*
>> + * Unaccepted memory bitmap only covers initial boot memory and not the
>> + * hotpluggable range that is part of SRAT parsing. However, some initial memory
>> + * with the attribute EFI_MEMORY_HOT_PLUGGABLE can indicate boot time memory
>> + * that can be hot-removed. Hence post acceptance, only for that range update
>> + * the unaccepted bitmap to reflect this change.
>> + */
>> +void accept_hotplug_memory(phys_addr_t start, unsigned long size)
>> +{
>> +	struct efi_unaccepted_memory *unaccepted;
>> +	unsigned long range_start, range_len;
>> +	phys_addr_t end = start + size;
>> +	u64 phys_base, unit_size;
>> +	unsigned long flags;
>> +
>> +	unaccepted = efi_get_unaccepted_table();
>> +	if (!unaccepted)
>> +		return;
> 
> This can be tricky.
> 
> If we boot a VM with <4GiB of memory and all of it is pre-accepted by
> BIOS, the table will not be allocated.
> 
> But it doesn't mean that hotplugged memory above should not be accepted.
> 
> I don't think there is a way to detect such cases.
> 
> Your check is probably the best we can do, but it means VMs are going to
> crash if memory accept is required by no table.
> 
> This is ugly situation.

It's all starting to feel .... very hacky, sorry to say.

This should all be easier. If we expect memory hotplug (SRAT), why can't 
we just allocate the bitmap properly?

-- 
Cheers,

David

