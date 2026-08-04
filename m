Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54F58C5518F
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72F856B010A; Tue,  4 Aug 2026 10:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706E86B010C; Tue,  4 Aug 2026 10:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 61D0E6B010D; Tue,  4 Aug 2026 10:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3DD6B010A
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 10:47:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0C9A8A0104
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:11:14 +0000 (UTC)
X-FDA: 85063320468.15.8857C4E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 51C4C40008
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 11:11:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+5pAPYK;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785841872;
	b=TPrEd1GuVaLKJW0eZzGWP2HMjMdm8dzaH9CMW8G1PyLkWR3iiczgKV/Irk8uqDV6Yua6y4
	OUpuUokYyRbD/JRst8MRkSx6O1jA7l1DKOFs0lwzBIiCfp3jX2LXtVOVvGbFbaqnjiAg2t
	uuwgKDS7ytvynGEk9rtCd7ar1CU8hgg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=G+5pAPYK;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785841872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x9WTrnnkHbtsN+MZWjYTlUGilo8WkuVoi8BtyG1CVyc=;
	b=WaRcYhNr7u5V89CxTMNnz+3isxg5iqY8j1+5SiyyFRKlywyBfVDbc/d8hO41SiYzjxJ0Q1
	xw6+Y8r9MCicDCYTFeY6l8z5rzDwzpH0OzJ0qznRKinJBturVx9nJ79CGf5/GVMdtUuTBV
	8ZlGzTY0IPx1SSDMCxu4sXa+NcfKMI8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5C4A60A59;
	Tue,  4 Aug 2026 11:11:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43EDC1F000E9;
	Tue,  4 Aug 2026 11:11:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785841871;
	bh=x9WTrnnkHbtsN+MZWjYTlUGilo8WkuVoi8BtyG1CVyc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=G+5pAPYK+UtORNM3sYcJFo94oS+gLZCs4XBiYmGGfFeHwS/SK9q2DYm7hyLcFvIU0
	 fraYmEKWxnutqgnwVh1FyxQapPubGQbF2nho9kc9lJ8+hCsAG+NRgG0PbruRaxXJoW
	 vYdxWr6VVAvzIQ/gVw/PE92V6stO3/tHUi9/ZHDnDps9Cllxr1OkDaOcSoOe0eBy1Y
	 ZsbRrbpXe18U+ACn+kxOkvEGCyVukK137ErQTUo7tvSK8r8K0pK2YR/qom3af91OHh
	 tHhBfVQtF+VRkokF0L6eIHv/pqfyVPvBiTLQpAxbgTuLCLy5Y1/U3SarcPaWlwoexQ
	 Vd1OigOBjaV0w==
Message-ID: <afa0ec96-3b85-4d6c-a89c-61366a10ca53@kernel.org>
Date: Tue, 4 Aug 2026 13:11:04 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: add some missing includes to mm-local headers
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, "Liam R. Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>,
 Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>,
 Youngjun Park <youngjun.park@lge.com>, Uladzislau Rezki <urezki@gmail.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260804-fix-some-local-headers-v1-1-a7beb173c116@kernel.org>
 <8179be78-a35c-4d0f-8034-27f3154db0e7@kernel.org>
 <7e7c8e04-646f-4135-9ba5-e0c7fd6d8b41@kernel.org> <anHG7BcQ8EFrwvGm@lucifer>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <anHG7BcQ8EFrwvGm@lucifer>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: ssjtann4ii6j9hpdcpz8cebqdyd8njtq
X-Rspamd-Queue-Id: 51C4C40008
X-Rspamd-Server: rspam08
X-HE-Tag: 1785841872-813269
X-HE-Meta: U2FsdGVkX19idE8ywCdtqHgzmzVVz6UO9BC99uMV8j1kfV56Ml6MHiJHqKcO5fBhCnMFZpQDHtJnplRRyoE6kmRq3RnvmtTz9yLyi2/X6mPkVwgUU/NCsRxQzTlBqIMWVS0NcbpaLFveETtrsJEXraigDazYkSDAIDASnD3xyoFmtpclVmZb2FvP+0VMWKZ9BCK/VoIwRx7WXjgV6ighHCzi30TAX9W16uU9UB+4Q4gz/E25/obxIIuV6o0DGvaIafWb8LqWPA8nI7w/eJXBqVNXIYZjcvmbTraZ8Jdv44RX6amAjMoPYdkKh6ZD+Gg+K6VVf1Auo2HxI14SFu0svlYBG7wX85DdLFhekef40B1k+NCIfSitc5sGouChyM+DRRSUw9j1/AJI1CsM/GfKJQ86oU1wOKyDDkognh1j429EvZFnNF/QsfIfMmChRMRd2EIONiQeBqHyVLs5dpzNn5SWbf9vfBIDMrkJJ5v7FM2Jtybry4OXC/WPy0IOorGKdRI8Umww+ML4XLmeMbp0bfFEVmi6skTkxsW0fkbf7OSyFBe3vq7RO7gb/kUT96UtVQ9sm5t2Fsile1KK9s24eQYGIYDqM3AIeBPrskdpfD0ZA4NKs+oaGO46OZz7j0DGcbySTG5mf6tOSV127N/+cw5LD1iGW29DzLO4REgP/6v0qHwSEkkzENYsFNqXOt+uNG3KqTDQCbE+5RbHUiv83y+Lw4U3TlMxsN810o1P2RM/ZtkriG1kuGj5nB1jkmYVDnZrzY9E9N16ionLUwJ0gMGu2/IYoWdqrLaV7Bu3nI/iC2Ubo3+3S7V5E4+Syc1Tw05bLD5+o1ZBCBPU/S8c/2t/8WA1eZu2oQqMbg7+iFu4Eft0+4+jM5QhG+otCGZb1XtfugKc5gPOXqCywJShO3TB5zTaBeojTsjx+XyV3NoJLBHKYS+PmOP4XhsRiT9QK1txNcXuoVrwmWfL68l
 wkqC4hSL
 V4O0EBhePCQ/j47izXm3ge4RVXuO7RUlqNKKpmWdIe7gKcpo3ofFBlrtHe17rFLxs589bjJT1mxbUxbolcQeJB8Wo/NHIzVr2BH1mxw4Xu+gueuSDs0fGHtwD39PMIJh4XeruDKZgqhL6mvGfesUR5byHv8OnHMdit8u0E7dmlOB3do0g4coGmuzLnzqkiXA/Y7IW8RqvObIzJHdiu2f85h3TPHrLrANQPgo77I2ZyylvIn54Gyu7leqFBwgqc1LInBJL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/4/26 13:05, Lorenzo Stoakes (ARM) wrote:
> On Tue, Aug 04, 2026 at 12:51:40PM +0200, David Hildenbrand (Arm) wrote:
>> On 8/4/26 12:45, David Hildenbrand (Arm) wrote:
>>>
>>> I'm curious, how did you identify these? The mm/vmalloc.h is rather easy, but I wonder about
>>> e.g., mm/shuffle.h including mmzone.h.
>>>
>>
>> To clarify, I have clangd running behind a vim plugin, and so far it just worked.
>>
>> I had to generate a weird XML at some point that does magical things for clangd.
> 
> Well for me I get the kernel build to generate compiler_commands.json and use
> that via:
> 
> 	scripts/clang-tools/gen_compile_commands.py vmlinux.a arch/x86/boot/
> 
> In a build script.
> 
> But maybe I need your weird XML... I do get frustrated that it limits things to
> what I happened to compile. It'd be nice to get it to index literally everything
> somehow.

Nah, it was that magical json I had in mind.

> 
>>
>> So I'm curious how to invoke clangd manually to actually get these reports.
> 
> See other reply, it's just that I noticed missing symbols.
> 
> Actually this happened with vma.h (I sloppily got AI to figure out any other
> cases) which _intentionally_ doesn't have includes.
> 
> But clangd lets you work around that in .clangd:
> 
> If:
>   PathMatch: mm/vma\.h
> CompileFlags:
>   Add: [-include, mm/vma_internal.h]
> 
> :)
I was hoping for an easy-to-run script that complains, instead of people just randomly
running into "missing symbols" and then having to fix it.

But there doesn't seem to be a low hanging fruit.

-- 
Cheers,

David

