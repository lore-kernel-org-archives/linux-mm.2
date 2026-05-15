Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BAE1CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 15:29:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E3C26B008C; Fri, 15 May 2026 11:29:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 494D76B0092; Fri, 15 May 2026 11:29:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AA0D6B0093; Fri, 15 May 2026 11:29:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2AC966B008C
	for <linux-mm@kvack.org>; Fri, 15 May 2026 11:29:11 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD8731A0157
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:29:10 +0000 (UTC)
X-FDA: 84770037660.30.434147F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 06F0318000E
	for <linux-mm@kvack.org>; Fri, 15 May 2026 15:29:08 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kfL2zLkU;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778858949;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=47uW1dSMq50FWT84PFH95/nzVAlAHslLZsLpyIKFipo=;
	b=2xwKdcs9Y/n7HZoEyOIHq2uMsB1RGLElBl91KcZ3kkljUs0YIWVvz8i7W+UGA8YUxWgvC1
	KNhilN2X81xu8q+SmQnfZMBPcxTadKWj0S54FBMvKjLw5A9b2cTxUcs5QDw2Hc+eq6uy1R
	oJ/SfYJMe+mOMDWsQQOVDxMytYy3dMw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778858949; a=rsa-sha256;
	cv=none;
	b=8TXL4AI/oPdvUSrmNc4/sSYYgCR2CqwGHIWyNL1uDe0lXJOF9lbYrrgi1rmrapFHEYhi8D
	wSAM6ozAXDEv5x9ME3rveZWEPaQuwu6M3xoUA0HOBEi6HrFY+ACeIU/AY93iUAFgeUslIE
	wVSDyq0f+XATl8Y4FDxWWQ4Rr46Qs04=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kfL2zLkU;
	spf=pass (imf24.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0046543C1F;
	Fri, 15 May 2026 15:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB22C2BCB0;
	Fri, 15 May 2026 15:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778858947;
	bh=ThUTdpiSZ+8umL9OOiGs71lNS12Rndy3keIYyO09rHc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kfL2zLkUf2Rn2PzYwWL6zVKwUsEGNaTFTGJbOr7mXrCAkJGcTcR9KLKcHkpnhNM2S
	 29BxO7rkQX2phATYD36HEUG89aKsoarmDEq7bwJwlVfTWeRKU6ZMzYuBxB2dagxNbT
	 p/gM3UUDh0nAFR/lYFojkRoFi5VV6VDYmAv0CO22jVNsXJif4VgsfrqTi/UHg7Kibf
	 3CPnVD9l+l+DBVPq86v360h/h+2FSmKzB4mvuh4HCANC2GbXnoXXhH1RJBPv8tB523
	 Pe1X8GEwR/PLx18yazLDsidgsKbh4dLlsOV6YZZuuE3V/G0imFmNEkoCaXHebSKzeI
	 Mfn5KiA3v6L/A==
Message-ID: <bd36e972-8900-4476-a66b-4dc218b21a4d@kernel.org>
Date: Fri, 15 May 2026 17:29:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] mm/page_alloc: remove ifdefs from pindex helpers
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
 <20260513-page_alloc-unmapped-prep-v1-4-dacdf5402be8@google.com>
 <4074a816-9e75-45a6-8141-25459bcc106b@kernel.org>
 <DIJA0MM2F3D2.61WBO3MJZRNQ@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <DIJA0MM2F3D2.61WBO3MJZRNQ@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 06F0318000E
X-Stat-Signature: eks7jkqcutmbqjwinr5ipe7mk8bakmai
X-Rspam-User: 
X-HE-Tag: 1778858948-819244
X-HE-Meta: U2FsdGVkX18euu9I7CnKGU4+SV55lCktFdahKW7kJGJY49/SCxxLaP4ZHY1vxo8IfVKIFCO3XAtjsV8Ueqh4OptOR5nnqQUPBmG9uy4pa+RxvLZj7/Oj2ge/voxFDvGRy9A09D3vHnfwm+3G6QIkDp1o4YomWnCohOf7/i7jbhS/DDemxNRwA2SCqT3jyPs3n2ZsEFWwuq43ym7HZHiVtfLFBgXNB43mSevsnwpPOT9tlgo4COFynSwH7d+xEGMp8GxA3Rs3D6uD1bO8Xo8LFWn25xPWz0BkUpKebJjHu69OLjqfm/HvnXMwxLcs5lbGjo/1+Yhq2YD+NhbJwlk16xDwgOnOYHQZNv88R+voI64giMV3/IHe3oAe1QZhW/AYvR8BNpX0bv43RPSj1gLZgFVdZ1x5ZqwMZL2t15ZziWtF75h83bBRy2GHaGWYzX6R4kBj2nsC/yalGgSP0MXv4a7Ove3uTWWhy+D6Hb6LSpAWkcHjJIw3hoC3cBsO/LoILsaIYRnA/wrafeGf4EhXq0MOZq8uiAJpySCujnda5Y2Xz7eFsGrMIF9gD0KVtuW/M6QSsTeWJM9M4iCkaSmkiIOCGseIT0KB4ZW/DFGCQEy1rIR78dXm8sbDQGP7BxsMQ8KG8iDiLxYycUcgoQjq4nzSbenchf0uhPPi8QoFX7XfmgcS6GKnlZLDbkLssjc4bS3Antto/pbL7jJe6goXiZsanNFy8fO2Wbfnkjkm9LTHBSuyvNkRqLwAOikxq8Q4sZmvzezJ+mQHAntoBqMDqPLWccImgaS5pSMg4oCcFHcfaxXJJbuRtg8feagQCBnGiip2opnOcgP3LNFA5tuFdv2uSGvC0IEhGwJmR13QredvrIT3/6RJzRcrXqVpcmR3IcsgXwzmcARsEhRKMYBs5xauTk96r74HUVikcMfenfvP8dkj/3TmngH1LmpWO8uyM6xqMaDj1Td+mv0sF8o
 6D5fx/7y
 FwABaQJTbjR5+43EClX+y1+6CtKYj7FJdUsGpRuA5FWqzgeF1quWO0jAxFAqf19ZCwgHbIdPVYvF/TgIdisSFymIusKd8XfeTyvE/vaTHbn4KSrf3XNLc7VQ85KzZR335awozBUzilDzUTqXD6UQT0Xq2TZqVp98MS+vQ4lpX+pq5a+gFVZZVjF5Auygeo37UmXHEXtoFQcWDJOE8O2CJlYl6f54ci5E8j5oz4tnfnnJxfzhvPikb9QbrxtIkUfoGFXbW/vzekrF8mYwGnaM4GpgUvCNeBtMC6nkEL2zXsHlqhSg35LByvNvuuA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/15/26 15:15, Brendan Jackman wrote:
> On Wed May 13, 2026 at 5:19 PM UTC, Vlastimil Babka (SUSE) wrote:
>> On 5/13/26 14:35, Brendan Jackman wrote:
>>
>> Uh yeah, VM_BUG_ONs are frowned upon now. But doing a VM_WARN_ON_ONCE here
>> makes little sense. There's no safe fallback if we end up here with a wrong
>> value. 
> 
> Isn't that grounds for upgrading them to a real BUG then? My experience

If Linus noticed, there would be yelling :)

> has been (I broke this code lots of times lol, I REALLY struggle with
> this arithmetic stuff) if something goes wrong here the machine quickly
> gets irrevocably and undebuggably borked. Crashing is the best case
> scenario.

Yeah it will crash quickly anyway if you mess it up. I guess if the check
would help you find more quickly what you messed up, a VM_WARN_ON_ONCE would
still have some value even if it can't avoid the imminent disaster. So maybe
just switch it to that.

>> And it's all internal to page alloc so I'd just drop those checks
>> completely at this point.
> 
> But, I won't die on the above hill, if people really hate BUG that much
> happy to go with the flow. 
> 
> In that case, I'd suggest we drop them as a separate patch.


