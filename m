Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8730DCFD64E
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 15:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8582E6B0088; Wed,  7 Jan 2026 10:09:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8056E6B0092; Wed,  7 Jan 2026 10:09:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70AF56B0093; Wed,  7 Jan 2026 10:09:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5D3386B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:09:45 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EF9EFC1A91
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:09:44 +0000 (UTC)
X-FDA: 84305502288.27.DD7023F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 18165A0007
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:09:42 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l7EkdduQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767798583; a=rsa-sha256;
	cv=none;
	b=bSfVfnHVrtEKVIhkZIuwNtH+CoONlZEEI53drW5L4huW7IN2TYTyvb4zfJofDOut9gnoWl
	w7oRdtJYVJAkMkLLz6eKJ237n0QbsTaQowklJS7c/3F2RQE4wy6zhYd0atLzeGEVEcbzsG
	56EI/u8iuq1m8RyD+ktRM31UFxrc1ys=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=l7EkdduQ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767798583;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iDkZl+JNdkHPS8SUwazGVxV8y/02mGfRGnXmDskTns=;
	b=ZuY7B5ubZh3X3SiqqwhhPVro3ZL0c5Dc9JGi5jN742OY6EvW9eI8Nf8zY3hGjkakReRznN
	HVQfJBY/ph+MSM3B2yxcENjGZH0dDDFO4ggpE9or1ngJr/+9SrEFHaPwuhI4Wwh5e0Iwu9
	acUQ6HXx2Ajb6aHosIi5C4tPeLsRh3E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0C5D5443BA;
	Wed,  7 Jan 2026 15:09:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C94BC4CEF7;
	Wed,  7 Jan 2026 15:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767798581;
	bh=wTafYNIje0IAQr4XFgtXKuH0/8MFPDAFFvntDIO066E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l7EkdduQblfvPk5R/a8xHq9uqL35tj1I53o25XjzvCvGGWEMWRg2QDr7y2zE1gWQi
	 s7LrncVkGlrC2XjxgeGpgbqzr8nsNTaJmKolKazosuhj86VX5opdQfHau2Wsj+rZ++
	 2w2iGkyqmT6L9CaoUCsJpWK8mM2MQTYkyR70wXXOdpgBlaE3Xr4uTrX62ZKJQiA4EB
	 ZgqCHo4komeB7klWJ4MfJ1seSq2zOZ+/YNbFgyi0Gw2lT6sUhB0AXSjYj1YrQCH5cb
	 IeTCJi02fBquxDFi5xtW8d0wvtSgIeB9d/H/teb+FlQbmR/8hWglQGQjIYrKd7LHn8
	 TMvQUWQQ8uYcg==
Message-ID: <39533aa8-ca78-41a8-b005-9202ce53e3ae@kernel.org>
Date: Wed, 7 Jan 2026 16:09:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Michal Hocko <mhocko@suse.com>, Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 hare@suse.de
References: <20260105203611.4079743-1-gourry@gourry.net>
 <aV0kzBxg57Mlw8mx@tiehlicka> <aV0-ChclC7SCrxcg@gourry-fedora-PF4VCD3F>
 <aV1nPG1BgBQDWkjE@tiehlicka>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aV1nPG1BgBQDWkjE@tiehlicka>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 18165A0007
X-Rspamd-Server: rspam10
X-Stat-Signature: 9ssk976fumghzx4tg38drfgu7arhejfp
X-HE-Tag: 1767798582-186554
X-HE-Meta: U2FsdGVkX197Ggg0UnQUIucSsWB3YPxaDME+iQO6MWk/i8fXLdFx2RL3L83JigXL8Pc2irw4j3Y/gkNeL/bXwkW5opTQJ1PCPNYq46yPEZEnHCzfaigiqEDqiWdzQbGd/UaQnorwKR1lCIo3CqIBz5akkzdZF7bzad6LOwVHkrnAXMKyQFHUQF89JVMa9erIwh5+YnE8Vq5/2SQ/jl0DxOA/GUnarCeZxMe0jW6lbtw+vcuWB4qYZSE7eLEuXFJn8GVcF5Z1KTyjI1Ek5vSswHleKFYPp+IAG7s7dm+boSiBkImGGu7s2rsiQ5dxg6I7AKGFqkF7YEf8MsuCZ/lEC/ph2y+ghFw5GGoEcq+EjvfAaE2wXTRHOvchzzvUNNRmHij/waWiex2aLyN15JOfUWGVaNu4y0VqxBsjPj0as8oxb58iEdV1FUlhE3EJxM+htI+jPbx2zEPJTGsonRiJ6+1VOw8F+jUwkmPbW79d8p0HVudv0lUUoXPgfZ/Nqa/iws1Lo8RPbiYHyKPh8zdoOdasSEMfDq5N2M0yillV3ET5/lN73aZneF8b2O2nAtkoQQBFpLtDx1omls4mxXZKcSx81skHPpfeI8yVzEkpcdwQBxsIaXoNjKDfoWD0DrstpGUJqB2MexSiSEGOq+uxFUTWBqLgRn5SCdXlM2/Xa5kbz68vzyKwAz3QPSLjfUBSfYZFMwcKlvL/R12y1LqNJQ3secVwRKazZ3kUFnav6mPhbrFqUyDRDUl3qaibl5mcFbfUEdJD3zTFQj/wyGlvUHeh2Lx5/DiTaPnudxVR8yUYND0DiYIFVdI0OrISkxBsWV6Q7DMjNZX3D15123WdtXZaSvKBGNEc2TsvJOMKlxVZdZx3+tOkx1YRZWRfFtboU4eFqwPzcyTML/kU8kOLn7ftmj9SzhzJ+OXfBWvAHAW6PxWAJvhhbaLxiIk7iXSfitjZOy10NH5q9nbc6fR
 hnxRxwhK
 fV6VE5bHiRUFJi/aHTLb35Jig1NdQ/2Gl3o6DU5B2c2tweSG65WVWJ8ByFkTOYzoZdBKglDE/3kTVd4v6wFnbYSGPhn8ekIg/IKy8hgjFI+trXJvwCgY0WiX0c+Jdv2yxOHUZ3vErjHql2rGv8m69bGyMO/4mtcAfItDXZif/En+7bSxbrzMv/6v1VOvw469PRAi2oRi77e0Vumm3scp0se4B+MQggKJy2FPg3GBJazlIUSQm54VFYncktcDqXMojkldGqMQV1IKtpvxtBSgyMMNXpxQIjKzcWxxKzs1sLKUI4xq/3b87iimtYg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 20:49, Michal Hocko wrote:
> On Tue 06-01-26 11:53:30, Gregory Price wrote:
>> On Tue, Jan 06, 2026 at 04:05:48PM +0100, Michal Hocko wrote:
>>> On Mon 05-01-26 15:36:11, Gregory Price wrote:
>>>> It was reported (LPC 2025) that userland services which monitor memory
>>>> blocks can cause hot-unplug to fail permanently.
>>>>
>>>> This can occur when drivers attempt to hot-remove memory in two phases
>>>> (offline, remove), while a userland service detects the memory offline
>>>> and re-onlines the memory into a zone which may prevent removal.
>>>
>>> Are there more details about this?
>>
>> The details are with Hannes, I was just recapping what was described in
>> his devmem talk at LPC ("To online or not online").
> 
> I know of policies to online newly added memory blocks but I am not
> aware of policies to re-online something that has been made offline.
>   
>>> That being said, rather than movable_only, should we have a mask of
>>> online types supported for the mem block?
>>>
>>
>> I briefly considered this.  I went with this for RFC-v1 since it's
>> fairly simple and because movable is really the only zone with hotplug
>> guarantees (any other zone makes no hotplug guarantees).
>>
>> It's also significantly more complex of a change for questionable value,
>> but if people see this as the way to go i'll happily pivot to that.
> 
> Sure, I wouldn't push for more complexity just for the sake of a
> theoretical extensibility. And I have to admit I have't tried to a quick
> PoC to see how complex this could grow. I was hoping this could get into
> a simple mask for online types with default MMOP_ONLINE_KERNEL|MMOP_ONLINE_MOVABLE
> and special cases just choosing one of the two and zone_for_pfn_range
> checking for the compatibility with the requested online type. But I do
> appreciate there might be some obstacles on the way to achieve that.

If we want to go down that path of failing onlining, we could likely do 
without any core-MM changes: dax can simply register a memory notifier 
and fail MEM_GOING_ONLINE of its memory with -EINVAL when it sees 
!ZONE_MOVABLE.

That works, because online_pages() does the move_pfn_range_to_zone() 
before calling MEM_GOING_ONLINE.

-- 
Cheers

David

