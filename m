Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2B30D606A330
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 20:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bFAorTwu
Received: by kanga.kvack.org (Postfix)
	id 098136B05B5; Mon, 16 Nov 2026 15:12:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 021E66B05BA; Mon, 16 Nov 2026 15:12:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E79B96B05BB; Mon, 16 Nov 2026 15:12:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C60226B05B5
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 15:12:50 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4A1BD16021A
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:12:50 +0000 (UTC)
X-FDA: 85442080500.26.C868C56
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 61770180002
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:12:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFAorTwu;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794859968;
	b=TObDRyDWspcfHmN8aCAD2AzpnaJKMHrG/mDEwvHeIV/EijbbjaHlXLA2Wcc80dVLeTFS3f
	t9UKpy2MXPf/6eBWJVnt+5G/iBvfnH7anRAnvjINjoyz8IrldjKDwqOa2YzdIO4wXV3p2h
	XVWqoWI5EqJKR3H899Cvdx6+81hz0nA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bFAorTwu;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794859968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3/T98WVUUlelLAAHqGHAXLZt1KhHqbJmfxjYziitH7U=;
	b=PRKc1ZqWSH1XO4gsX9IG/gvd/wWqtpMOzdk98xRuHH528uTEEkLM5YSkPrLV+qmZqL4bka
	NtJbGdlErLETEhoRmFyhzNsKi5YcdleHO0TrnSwftpjA6vg592S2qbgpuGyXaMgwi+buG5
	L0KfNenjIDJh7mmAIMSMohAhrLHQ3Xc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E2C346271B;
	Mon, 16 Nov 2026 20:12:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 696C11F000C4;
	Mon, 16 Nov 2026 20:12:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794859967;
	bh=3/T98WVUUlelLAAHqGHAXLZt1KhHqbJmfxjYziitH7U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bFAorTwu5j+G1q4RpJxdlpz7CDg7F8FzK5Sxi74cKmk7qMNnx2tUJ/JuWmNOzZ3p8
	 VopJ+QNZ3XkQ1IjsvySKurn3hWDKSaUaEechMytGaVAwlRPwaa61xIYV8mKRMjhgpv
	 Nolv7ZmjHggmfiNt/HgBuiQKRXkeR1jU2Qs5huaXoCBh9I5xE5DNnEOTC/w8npVVm9
	 PSzBzOtNVmsdpzG/oAcle2Jx+8z58qdXvRTD8u0hxpp0MlRqqRRr2KrX6m0beBJYR6
	 s/jjiO6K5mgy6tiCn8SRKchuC2z3wT+csO6PbSdSFBQgU5/1NW8ijSWJsUQQekHdns
	 G7SdRkrpUDDHQ==
Message-ID: <f81bd37a-9637-44be-83fd-be7e717fa182@kernel.org>
Date: Mon, 16 Nov 2026 21:12:42 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hmm: skip NUMA balancing on protnone faults
To: =?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
 Matthew Auld <matthew.auld@intel.com>, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org,
 Matthew Brost <matthew.brost@intel.com>, =?UTF-8?Q?Mika_Penttil=C3=A4?=
 <mpenttil@redhat.com>, Leon Romanovsky <leon@kernel.org>,
 Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>
References: <20261112-numa-v1-1-ad9cbca8f49a@intel.com>
 <b32fb02a-68b4-4db9-83dd-254147dbf215@kernel.org>
 <1993e931e6a4b0cda5c04e72b1a8d5fb924f950a.camel@linux.intel.com>
 <9ec3e8b9-064a-47a7-8d00-566ff371b846@kernel.org>
 <0b794f803517c27ea818a2e894761095300b4da4.camel@linux.intel.com>
 <6af3d5d2-4fab-4a3f-85d9-34564fca8ffe@kernel.org>
 <58755e3cb51d534b749d70847a5478a40c1c10fa.camel@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <58755e3cb51d534b749d70847a5478a40c1c10fa.camel@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nzg1e7zbt8pewg66b5iogtg759z5w8j6
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 61770180002
X-HE-Tag: 1794859968-904409
X-HE-Meta: U2FsdGVkX18rv5Y+ZfOZjEFgrDcwCN07NgBI2EoCaHv8xu5vtt6d3qDzgDyywdobrr2fIoMy1u09hr8vdPwNmao3mO4w7ck2QP/pvNCwaraLceV4vETC+EPKyColTqs0KEyxUfnfPxsqH39/NHmnUgrwBoR/Xt7awDASzZ09uwVEBltvIW/pJUdtXcJ7iOq0v9XQw5lj3fRLeFkR5XSVWGdk4+rNmI1nxxpPqLg6R/fJ8oIHdQxs/G/3jMNQ6tE8U4l8UdO7H84dbrdPiz8lG/GrN/z75tGo2dluTI38XYqjKIueJ/hTMhOEOLig86jm+R2Z96XhpihMwTxhKW2rTofvhub2FBJUJP1sDkqPufM+sWQr06Tdt/cuI8r3lZHG3K3OYCIEFSPs7KCe4BxzlNHpcFcC03bTDLOMSurFgLvKjtXnODfQoUIE/nqSgQKyNwx0MsvPxdlMxJdl+29dL+4r2dwQ3J1fOUcOe1pHALMLfQ2ixV4IjTGBLBjq4KsZuDUOm0VtYNQOOCL7v4tjrq+HeB5Cd1VMKjDwLSxowkNHAaqTI3dkRNg4wdAJh1M8ZDVqXYitBFzgt1N2lme3evroSknIQGCapyLIvBtPnfaNYoyTStWGWOK845DIT0S0LxxPAzd7fmcnAi1bM+XlYz0i/V0QzGtjA75ahV8h5TYfSfpqpPHd96BT3kk33RwOaxEydi4FnxYEoEt/zktu/1oCjtIM0wXgsk1tIaCJIXUvD0romieotstJjHj2YKWoocMMe6pecAgZIVJJ0u7i1jqIcRIHoBXQTSPnlx/qqL0afPf9nTXDth7B0jjN6b5Vk3DGnUKmjEqXUm7fDWMIiPs90p3DWCyEPTLlE/V64gouS72nLz4ZWFXkuXL51/SVKIhxt59wBDbHl4t3ZkyrfSBx0NkGH2z7o8fHLd9GluZUMRsNP/GSxM4OHplyr0j45BURrdNNmA5i2qKNHVX
 +WbSmUmg
 LUoVAvjRQ0+UVRmQrUQUOxE1A3oqCXcq8akgeImVLTEICAgNUi20sbEvS0kgU8gZSE42d/0Dc0PrTVZP/hyzB4IHQOgOfc/SlexVbX/jBDN46HeRXy77sX3FWH4uSo2t3quA6Pz92+iBxbX4eF9f3RBsdxxqXSL/sPpz22jihSjbanJ5M9GQdntyp88hfxxxxMXUUQp6UitGORRmmYwuLyYt1yneOdstE9p3qwWmuC2fSnpioOxhb359Mmv7RKskyBYL7XPuDYCpNg/FIGU8AbyG31g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/16/26 15:53, Thomas Hellström wrote:
> On Fri, 2026-11-13 at 22:19 +0100, David Hildenbrand (Arm) wrote:
>> On 11/13/26 21:56, Thomas Hellström wrote:
>>>
>>> Wouldn't the net effect be that content stays put instead of being
>>> migrated? In both cases a later CPU access will not trigger NUMA
>>> hinting except that the proposed change doesn't send content to an
>>> irrelevant node?
>>
>> My point is that you are essentially disabling NUMA hinting because
>> the CPU will
>> no longer trigger NUMA hinting faults.
> 
> Yes, I got that part, but that's is only for a single scan, right?

Well, one NUMA-hinting protects again, you would get an MMU notifier, and fault
again here?

It all gets pretty unpredictable for these PTEs, no?


>> But then, just disable it entirely. Maybe John knows what to do.
> 
> We can't do that globally, really, for these type of apps. But one
> remedy might be recommending the app to mbind() with a no-migration-on-
> fault policy.

Yeah, something like this. I mean, it's hard to see how NUMA balancing makes any
sense here. You're just trying to fight the mechanism because it ends up causing
more harm then good.

> 
> Also the hmm O(n²) complexity in this situation isn't really ideal. We
> might need to look at that as well.
I didn't quite get that, can you elaborate?

-- 
Cheers,

David

