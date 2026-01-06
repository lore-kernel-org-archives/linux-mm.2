Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 208D7CEFCEB
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70A836B008A; Tue,  6 Jan 2026 13:39:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3E76B0092; Tue,  6 Jan 2026 13:39:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E0516B0093; Tue,  6 Jan 2026 13:39:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 4C7BA6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:39:04 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2F8D5B7A7
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:39:03 +0000 (UTC)
X-FDA: 84302400966.25.610B9B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 398064000F
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:39:02 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XqveFlin;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767724742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hgUj4G+p8jDHvMX+STFXHX5ylg/LFAORDW4PvHGENCg=;
	b=w5U2tAnLIpD+XXG/IDKywfMA3TNOmveWsaCzY04URY/yxXHPup23StMMGbjMjYcDWiBxAD
	AD0pRL8hNyvHeSANy7Z1Ae+/gYIHlxGlbF5qwB5gsBv6DxjEa/cOC+12FvhjKyyHydF7WR
	J1rUqga/6qr3l5NPJrOJEN8FinVgjoU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XqveFlin;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767724742; a=rsa-sha256;
	cv=none;
	b=042w+4PXSbPIm8KxflNtS5t3B1h549f8yn0IbeJFVHiwzgPxZmxwIFtoDrBFjzO7sRhIm8
	bYa+3j9R1qSd+JW1S6bxECa0sMg8owHBFbCy9+nL+/eqEUnUobxHvZ6uUsYsYldGRi5s11
	o/gr1kve/Sovz6WlwVBIxxR57f77mVY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6CA4360008;
	Tue,  6 Jan 2026 18:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3DFEC116C6;
	Tue,  6 Jan 2026 18:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767724741;
	bh=tm0QDYQ7CzUd3TQGcCn0OduK4E5EmxUcy5XXrvBdEVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=XqveFlinAXm8UKS1c+Yoyd8/RpP4+kKAYqVmsJk5rUgZCvlflXGJtqqIUdqqGM8OS
	 Nkaj06Wqdn9WuXlcpMbwzgO2hfzGBPP4A2HA2alRyD2pRBv33lSRnXV9Ddxf/SCeBY
	 TwVbkU7dWmGBCnFriMz3re06gjBbQaAop9sYczEOB/ZDoJUIPLP3duHPI/zrfY2nOE
	 Ka9Py/ZKzR/E/RycRjzz7ZgYmI9uJBRQUTjEmfWVEK2BKlRsbBYPdj3sPRgI+Yi9jP
	 tnkDTBtaoCRtGJFXX9506e0u3ORWVqO+rVReKfZG3v9cnxIPDsvBv+/ZR4LGYlE7Sk
	 OyCgAx/dHBeBw==
Message-ID: <616f97b7-24e0-4134-a08d-5abaf07a8b09@kernel.org>
Date: Tue, 6 Jan 2026 19:38:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] memory,memory_hotplug: allow restricting memory
 blocks to zone movable
To: Gregory Price <gourry@gourry.net>, hare@suse.de
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 osalvador@suse.de, gregkh@linuxfoundation.org, rafael@kernel.org,
 dakr@kernel.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com
References: <20260105203611.4079743-1-gourry@gourry.net>
 <7f053290-6b9a-4d18-936e-0f28006c79c3@kernel.org>
 <aV0_SMq_I_R7ikF3@gourry-fedora-PF4VCD3F>
 <9575e042-39f4-4f01-80db-34aaaa9312e6@kernel.org>
 <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aV1PQd3tyfSiH4xD@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 398064000F
X-Stat-Signature: 75jaak1gnx9zhdnur4g7bpe98qersyr4
X-HE-Tag: 1767724742-466675
X-HE-Meta: U2FsdGVkX1+1Ok00vewg4oPQUpz+TezwTWXrBHrqPlKdz7ZM2jvnk0vM9otjDMpuv27q+4M59zUBd7g/mR8DuwyiNZpsXTPZX0jFsYY70Bt3cfGqz7iIeyCYDvVE2joD2MqGD9ZMvbVnGdh83tUkJKeG8koEbG9KoD59C+QeEqDGEx/vWEGMiFFPpi66u2TNtgw9owQ0OdTuAJFFvE0j3Me1CnCVl/hRVYJmBfaXuyGV39+chZ63cxA03EOhsePjJOZDKp91vD5GRLUCfg93ecypyV4lWAbsclwCxAzankp2N/Qvsrz0cTWIzBrCns6UMozP9Vv6JeheeHY6BfMMKEcCD8XbizoNQczGOY3nmkocTNWIlAqWgHcoLO3qComO1J7tCmh4C0md3TOLdCBsw2MBONj9IdXyDZ/NYPfx9OMrBwMkLr388Z/F2gFTkn2yUuNrovsEemn/hhJvGzWl3GcSbxKRljaxLsS6oeUbmj9zIRdPsCTB+RmUGfydA+dwRs2DXJn/ASKV8jwuAZJQ5jkMTakf7ifVQd4PKAU1/cof8HgHOX/lBRcdwcC2nVkklLhlCUVD8NUR4NYJlr9GBNdNAVxkL6zrWYueAbKLfHxdcsTH7QIsb1JYeJDPFBlnHBFDanETOR9MgpakG03pqh1zU4gLiCxMTHvtznrYNEjyCEMAyZ1S1hsMuCvAeWu+tZRoAw7g3hfML1yDCaQCZskznSy3jPueNYzkvaR3GBA86jOXPpoJdiDigiSn1i+0mqGybPFFekmv09r3eQ+zY7aiL/JY0mgvPSseMEXl79TUfR1epymGFkia0UllykNVJRPS9/41zddW+WSMhFR2Rgl12edW1BWkenHT0iRuHGv2XpD6ryphi+BMHL+ItJDIhwwP6pHxb/s+/HkRxdB8bur7l7BHWCpBniC1/T+8D5qUJpfh7T3a+zqFBiCF4DT4+k+76wehZaIpIOOTDgM
 yB8u/+tM
 Wk/85R67HRs7/CK6/1tTPLbq+wSynPUufjItIK3IEFa3s2iW/fV/gQ6FKZxfC84atwWdIEHNQx8A5JFnIU85tvOLwS6p5Ppy9aPzl9vK+JIoWjCjOKfmodPqxN+k7stNJmCSAtqPkmj+NqpJDRP8+ripnugFBiBkTsTcLNXeTNE76u20tanqkkQqPkJz5V9jFpzDKhJ8dcD/yWsVn1EeKVvRG3sryoTF+LRvAqXTnvCpUa6ohrKX/1pqFOnKbLc35S8QocRI2Ke8o5HvttIOB4dGp26x2706MlVfgXmwb+STv+m3UOx0J6Mp9Uw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/6/26 19:06, Gregory Price wrote:
> On Tue, Jan 06, 2026 at 06:52:11PM +0100, David Hildenbrand (Red Hat) wrote:
>> On 1/6/26 17:58, Gregory Price wrote:
>>> On Tue, Jan 06, 2026 at 04:24:21PM +0100, David Hildenbrand (Red Hat) wrote:
>>>
>>> I'm not against this idea, but it also makes the sysfs a little more
>>> confusing (`echo online` now does different things based on prior
>>> state).
>>
>> Right, but only for the contig-zones policy.
>>
>> But maybe you really want the default for such memory to be "movable" even
>> when not onlined beforehand? So I am not sure if the description of the
>> problem here is accurate.
>>
>> Isn't one problem also udev racing with ndctl?
>>
> 
> Yeah there's a bunch of races, the specific ones mentioned by Hannes i
> need to go back and re-listen to the talk.
> 
>>> I preferred just failing if the block wasn't compatible with
>>> the zone (maybe making it more clear with a dmesg print?)
>>
>> The thing is that this block is compatible with the zone, no?
>>
>> In a system where you would never want to offline that memory, why should we
>> stop someone from onlining it to a kernel zone? I'm sure someone with a
>> weird use case will show up later that will complain about this.
>>
> 
> Presumably you wouldn't be setting the MHP flag that prevents the blocks
> from being onlined in a kernel zone then - in which case this all just
> works as intended today.
> 
>> But the patch is missing details on who would actually set MHP_MOVABLE_ONLY.
>> A user should be posted alongside the core change.
>>
> 
> This is fair and probably the obvious immediate user would be a dax
> device with some kind of `dax0.0/protect_unplug` feature set.
> (With a better name obviuosly).
> 
> I will defer to Hannes on his specific use case, but I could see the
> CXL-DCD (Dynamic Capacity) set wanting something like this.
> 
>>>
>>> Anyway, let me know what your preference is, happy to pivot however.
>>
>> Restricting memory to be movable-only to handle a user-space problem as
>> described here sounds like the wrong approach to me. You really want the
>> default of such memory to be "movable".
>>
>> Almost like an optimized "auto-movable" policy :)
>>
>> Or a new policy that will respect a provided default (MHP_DEFAULT_MOVABLE).
>>
> 
> Fair, I'll revist this once Hannes gets a chance to chime in.
> 
> This was effective at getting the discussion started though :P

Hehe, yes.

Another thing to look into would be to provide a way for ndctl to just 
add+online the memory in one shot, without having to go back to walking 
memory blocks to online them etc.

After all, ndctl knows exactly what it wants, as configured by user space.


Something like "dax0.0/online_mode" (or however we can make it clearer 
that this is for the system ram mode), which would default to "offline" 
(what we have right now).

When set to "online_movable", we'd online the memory to online_movable 
right during add_memory(). So no races with udev and no manual onlining 
necessary.

One could also envision a mechanism for ndctl to 
offline_and_remove_memory() memory, instead of manually offlining it, to 
then race with somebody else wanting to reonline it.

-- 
Cheers

David

