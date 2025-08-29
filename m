Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ACCFCA0FFD
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 07:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906976B0012; Fri, 29 Aug 2025 03:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE9D6B0022; Fri, 29 Aug 2025 03:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F45F6B0023; Fri, 29 Aug 2025 03:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD196B0012
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 03:12:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BEFA41605A7
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:12:34 +0000 (UTC)
X-FDA: 83828927028.15.5F26871
Received: from wp530.webpack.hosteurope.de (wp530.webpack.hosteurope.de [80.237.130.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id BB03812000A
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 07:12:32 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=TGKBDjgs;
	spf=pass (imf29.hostedemail.com: domain of linux@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=linux@leemhuis.info;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756451553; a=rsa-sha256;
	cv=none;
	b=ZPtB4CCavDv8NPnXPcvX7cbr6Mxh8/9TdXsbL0uLMkDRAHNqIaVneIXNaPZSir0Kh9g4eC
	ZacaTiX+nY94x6LDLgiTpiRBgw4k6qzGjeTj4EratChvDMjZElQrc530kJQEZ25KsorFSi
	8NvZy1ijpoR0xrVGsIlVveeng7O9mXE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=leemhuis.info header.s=he214686 header.b=TGKBDjgs;
	spf=pass (imf29.hostedemail.com: domain of linux@leemhuis.info designates 80.237.130.52 as permitted sender) smtp.mailfrom=linux@leemhuis.info;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756451553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdH9NIb3jzwErV0CVrE+UYxgQyTjohr+oYD/uFKLX6I=;
	b=bvrNodSoemnm0e3S5q83Vv8Xr3CfOwKuLb18E9a9Q2Kt4BQSKixi4S2k+tP+tv9d94trww
	lWkQhyI2wveIUp1LkRPwUfb/GUmQ2L+pZuu7uosI2uEN/+WCEOhgD5hBjwbtwLLHpiVZdp
	Zp5xrxJsOvGRtQU6fLw05ArAvne8laY=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=leemhuis.info; s=he214686; h=Content-Transfer-Encoding:Content-Type:
	In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:From:
	Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
	Content-Transfer-Encoding:Content-ID:Content-Description:In-Reply-To:
	References; bh=zdH9NIb3jzwErV0CVrE+UYxgQyTjohr+oYD/uFKLX6I=; t=1756451552;
	x=1756883552; b=TGKBDjgsaDgnnVi1eV9D40rFjQncY5WhH8bnq3XQ61tkf49RpwrrkBMcIbsUn
	HGiZ/peMr3XdlCQROXvLfi/QSZ1j9CGp7ZxVwMSJufF2KaZ/cf1CsHAYUI/CvCfi+dvMLOuj/WAPZ
	hndi7aeTAWW9w+FuHsr9EhHWR0UrYE6a+L18KMLxbF3X/GvPZDz+suso9lVSUaT8DEnsngsKpLIqi
	NH4YIrb3tfCI8EiXxUWXraqB8qc/9WU3qlYYE3kMOcwiV4gQ7F07CGhJmGDaJr2ME9BVECiCF024/
	P9fwKq6HGBXbXYPc36iUatgfFgwXOtAaHiOuoSECmcpyB2cANg==;
Received: from [2a02:8108:8984:1d00:a0cf:1912:4be:477f]; authenticated
	by wp530.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
	id 1urtHZ-008qQR-0w;
	Fri, 29 Aug 2025 09:12:21 +0200
Message-ID: <3aef893d-1218-4d98-b340-7300b74e9a60@leemhuis.info>
Date: Fri, 29 Aug 2025 09:12:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 02/10] slab: add opt-in caching layer of percpu sheaves
To: Vlastimil Babka <vbabka@suse.cz>, Suren Baghdasaryan <surenb@google.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>,
 Harry Yoo <harry.yoo@oracle.com>, Uladzislau Rezki <urezki@gmail.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rcu@vger.kernel.org,
 maple-tree@lists.infradead.org,
 Linux Next Mailing List <linux-next@vger.kernel.org>,
 Stephen Rothwell <sfr@canb.auug.org.au>,
 Alexei Starovoitov <alexei.starovoitov@gmail.com>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Bert Karwatzki <spasswolf@web.de>
References: <20250827-slub-percpu-caches-v6-0-f0f775a3f73f@suse.cz>
 <20250827-slub-percpu-caches-v6-2-f0f775a3f73f@suse.cz>
 <9f61c814-0d39-46f2-a540-cc9c0e716cf6@leemhuis.info>
 <e58c8482-bd11-4111-b912-daf8b43ebb15@suse.cz>
 <9705a0d1-0108-4f63-9a5c-9ca6c20eeb32@suse.cz>
From: Thorsten Leemhuis <linux@leemhuis.info>
Content-Language: de-DE, en-US
Autocrypt: addr=linux@leemhuis.info; keydata=
 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 n7RI
In-Reply-To: <9705a0d1-0108-4f63-9a5c-9ca6c20eeb32@suse.cz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-bounce-key: webpack.hosteurope.de;linux@leemhuis.info;1756451552;595909b7;
X-HE-SMSGID: 1urtHZ-008qQR-0w
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BB03812000A
X-Stat-Signature: ujr76abtawzkp3sr8raz3msgapwxrfgw
X-Rspam-User: 
X-HE-Tag: 1756451552-331855
X-HE-Meta: U2FsdGVkX1+8FSSCepAJMMnCF92aYpC0wakPxOtcxGdasePNh+xZHbM9ciXf5ZG1qdgFbsANF1o9laWiXLBLc+YEEij/cGbB6OMiEaQkIEuzigy8xdbtQmUdoHIfR1d+ekEAYd++gZFYqTG7fLnQvX6o6VGishv7g6FSxvWN0fKReUtECQaMWXYQlbJe1rYxmkHmltg2eaz8+RXJRwPzj0XZQAF25ZHcXv0SACG8GS1+yBqxLSnK3hcTEnk0P/lUTAG/uolZqs+b5VN2SmlWeFVb/4uB7Sa0tw4BuxyowtlECBFFzIpBv/5eHWzFxNdDL9kAqbPboq7aLVLbbmq3IyLcHVLIQ3Z7ScliW1+MljRgjgDzc1r5HqHY/N2QVfOJkso1Df2mQLbHWzvQ27NKETMGoaOI9tmgUWoQg5RwxqiuVcg+lp1LTotHplWW6KtxbL3+z6cG8BBc+YnpbvOUQgbcec4BlBxq+sbUuWYtpjZHN9ZOoH2iCblnOu54aCyE2vR79EgwY1V/kCnhjUZ6BBThXNKtk5bif75IW/otCV/nlSbcelR/ggZKCBb/QEOJwaDDwZ7SEBYmzQ91VayfiglorNY/RXwcobc/NFsYqq5srYDlAb0PMUpK/sir/Wa6m3gdPe9JkGZW22Q3TYWHaL0bOMwl/aCUDTR/8s/eaikfEgrJBFiB9RD8cJ1/zAsJwjCD4srjja+hNT9KBoqYelvjoDlgJLgT2WFt8xIFrO5Bwd5gcqtOXjL5bTKbm57wkxqdq/lIROxl6BIRZtl/qmRsJax3JxDURkCruHWo7VMmXY04j421JCBK7oimrTA+wkFXRYh8YtdgT1KpXawFqZ2X2Azf7hO6Lfl2bgfVzKIIMkYOzf9Rd2ernaT0uhN+5Z2LMA5m9C+hOAQo2OshRoOtNcUMlTXip6bdNvQRRbEr9a49JdP6f4CN5fe97iM0Z1w98vBi/YKMdOHrMe5
 MPe1zu3P
 gTRNiiLiCtJQckPOlr0b+AbnmfDZGRTfUCuyH5SO7Wduumr2ZUJTcQL07O7KwbSna8IzFFAtlJRyz289aOtOH/6Hk9PFthIXOn54o6ibqHRi6knL8mhsdeI8/Kdyikus+k23Fe04bfxYz5fvYGEzrklRTshZTZqXqbxgCDtP3jWrd/FwTVDLmmlnEe/VT2QLNiSOefmJyyRYxkvrkPIsnsk0HJCEQA5aijySPFocvpNnOvl7ZWSwWheHb3uqv7gcvX/lwv8j1emRjGDek65rahe/Vmz0sn55svO7pzy6f6blTsGT3AOZWN9cnTx9gGSy/6UbDXzI50XrVenbeZFG23QdvWlZOtm6uCbHkKWhQ1FL1H2qG0zLkDnYLkldKISfFY811b7GWxfDwsZYtOAws+2tNyi7iKuStVYOxrWppB/0VR9Y1cMNN/oTOxmxpcwe/xKhkRiw8tzX08hSilBlk3TAcIvkG7Nf8Gp0BlQfsMrJ62is29+eN0PUaIV4N8aa+TwVRVkrcOboQUj0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 28.08.25 17:00, Vlastimil Babka wrote:
> On 8/28/25 10:01, Vlastimil Babka wrote:
>> On 8/28/25 09:43, Thorsten Leemhuis wrote:
>>> On 27.08.25 10:26, Vlastimil Babka wrote:
>>>> Specifying a non-zero value for a new struct kmem_cache_args field
>>>> sheaf_capacity will setup a caching layer of percpu arrays called
>>>> sheaves of given capacity for the created cache.
>>>> [...]
>>>
>>> This patch showed up in linux-next today and from a *quick* glance at
>>> things I suspect it might be the reason why my daily next rpm builds for
>>> Fedora failed today like this:
>>
>> Hi, thanks for the report.
> [...]
>>> Full log: https://download.copr.fedorainfracloud.org/results/@kernel-vanilla/next/fedora-rawhide-x86_64/09498568-next-next-all/builder-live.log.gz
>>
>> Oh so I assume the .config here has both LOCKDEP and PREEMPT_RT?
>> I tried to make lockdep_assert_held() with trylock but forgot about the RT
>> difference. The solution is Alexei's patch
>>
>> https://lore.kernel.org/all/20250718021646.73353-2-
>> alexei.starovoitov@gmail.com/
>>
>> Wonder if I can just fast-track it to here from that series?
> 
> Did that for tomorrow's -next

Thx, today's -next build worked smoothly! Ciao, Thorsten



