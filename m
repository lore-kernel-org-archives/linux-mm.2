Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C162BEDB7F6
	for <linux-mm@archiver.kernel.org>; Tue,  7 Apr 2026 10:55:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1A986B0088; Tue,  7 Apr 2026 06:55:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BCB206B0089; Tue,  7 Apr 2026 06:55:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AE13B6B008A; Tue,  7 Apr 2026 06:55:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 992F16B0088
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 06:55:52 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 231301A06D6
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:55:52 +0000 (UTC)
X-FDA: 84631454544.02.E698141
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 683B440008
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 10:55:50 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XechboWm;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775559350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XhI2ZtNaa3WGy+PoC0/JjFHL9yU5zThKY4urO3lDB84=;
	b=ACyNHjS4mnGnzcodmkCCOZAmXkqCf14xV/uwvf2fdwW8Ps3tT4JsawxqzQBF6y9pB0Ard5
	PadON1ZmKg8zP7W/0z5tfPRLizwiCE8PvKBhBM8hv9xW8vJ2HCxhGURVpQ2CB5YnocY6VB
	Ax6GIG1BTsz0sTqU8CmH6WAUWZZTLhw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775559350; a=rsa-sha256;
	cv=none;
	b=1oHDOH7HvoxeH8n/JEPlR1YcIQWFTT92T2haFZOrvuTncmNXHTf3U3S7P52+5Xd6nCp9P4
	kZMflpVx7nHcSbmXk8JOM+ivYaNY0g85oSXN6P70iw9M3okdv46DofIs5FgoY2jvBqOZ01
	6MMwaxFSjzqUQ58OZduAvB2Y8OeU0hs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XechboWm;
	spf=pass (imf12.hostedemail.com: domain of pratyush@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 37E1C43775;
	Tue,  7 Apr 2026 10:55:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7AC4C116C6;
	Tue,  7 Apr 2026 10:55:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775559349;
	bh=DxuZSc3v1tSfQiDDs//E7vQOyQAhy+CLZFc51VXzKJk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=XechboWmrDEra1UKD/89mEc9VgqVKZx3trOiVrC2/tPXI8bAdnlaWYBhgZLst0KcG
	 pv/reEJAnUvUsgWWsJ5FcBt0hpoLloMwlvhP366kBM3swg2PNDA1w5sJPF0hV0grIA
	 1LmTg9zM+dEjCq/zebv3ikJrelbboAOUtySOSIE9p8LrHLrQ/So4OkLKg6DzcCBWtN
	 FcMrcMKD64JBsZztcunV4e1hnvpWSrYrlccRqXGQKx/lpvat9sFX+KHRBqcotVpE57
	 dt2LuTyKYFxNonlTsFkFkTZmeMEOZE6p91pZ6k+IweMUdSTBBpY/FjTzHtMryDjPES
	 fK5xLlehLs90A==
From: Pratyush Yadav <pratyush@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Michal Clapinski <mclapinski@google.com>,  Evangelos Petrongonas
 <epetron@amazon.de>,  Pasha Tatashin <pasha.tatashin@soleen.com>,
  Pratyush Yadav <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,
  Samiullah Khawaja <skhawaja@google.com>,  kexec@lists.infradead.org,
  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,  Andrew Morton
 <akpm@linux-foundation.org>
Subject: Re: [PATCH v7 1/3] kho: make kho_scratch_overlap usable outside
 debugging
In-Reply-To: <abptg2AObfxkkxKf@kernel.org> (Mike Rapoport's message of "Wed,
	18 Mar 2026 11:16:51 +0200")
References: <20260317141534.815634-1-mclapinski@google.com>
	<20260317141534.815634-2-mclapinski@google.com>
	<abptg2AObfxkkxKf@kernel.org>
Date: Tue, 07 Apr 2026 10:55:45 +0000
Message-ID: <2vxz1pgravke.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 683B440008
X-Stat-Signature: dixga85nujq4d8hadg9dk3g5zienmsuo
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775559350-161620
X-HE-Meta: U2FsdGVkX194i+J3h0wAn+QW662CSwaGeHYHSt+cJRupxsrUGCD9TZq0r2fTNs+ztaBMpTMCSXQ4hQSxuo8i/YJht9n81Q3/wTyXBOolQsvtD0jyOjCkHLA2PlfBC87Um///5nHP0RuuMTUTlLsgxneqWz+A1DQ/WBg0AgiXtNp/FAL6T/QRZ6J9fMdzrkyUBKHzZVgbeuMCArda4i9fnGoCHE1N9x7v5w3F9NLUdUrIEGGngo5fAOtvSlv7MIOWEI5tVLT6LVRtGcbpNEq08e7tXYf6O33IDKlEKkdvRw7TTN3LnGoauFT13inxJJieXQwx3YfJYm28Ut22k9uj2GMZDgdzScfKTerzhPG9yrnRfIdCGgorievKaX2BLk9ofoASHE8DpAY72mHzTocN451bR248vtTLUgHzZPupazmCx46bTIcGNbUJXflm3xtn5f3J6WyX9sHk1VKAWaIXTvMRrFgkN+nM9DdjTpGT7KxQAuImQzB676eTCVYvvodamV0TCPmYO/XPXp63+1YmXBk1Hi4y5SfhyCVt59wX1dJx6WpvNLepEt3CElGmpv8982Kqbojc76K3Pul1sMV3VpuwNU64ZUB17uYAcB92z7Rdy17YhogriV0AVaXneK/LvRvqO0RBmTLD65X/ACpbD68W6S4dXW6xLzgqDMXA7dmrcAHAvgXZm0/0qfRP3sqnkj1AWVjJq+GnuXw3/epgDc5ZmqifLKrW82zX4P5VKfhtF1/FMQwVRxR1LEtotRwAVTdvxjzsRREOLUoq3qTf/pcafYZ2VE3dYovtiLT3NlZF/At3ykpWo8GdSrLIKbuYeI6Za2U13lhYxEMIDwPvuNLPTHfp6YKOwgv8pdpIa6dkpJtz9e8B8kUQDXj8iZDK7qRR3aMIfwc7bPx5qLOdNiSymE6O/AiSMoe36qiRg+ZEfy3zqBsNYS0pLzPW3OFjGorOVZAarHawsR9EB75
 iO0AIbvr
 g5opsUlVK+Pv1C/htg9UgPt0y4+Ld/WpXofjvXxRVEHH0zq/sLU56lwZ95L2z7TIJDYDdrHkML6Ay+boYBsEpG0/KvheprWAsy7Ya/8QnsJW8xU6v8TsfqQVpVFP2TdJ7WHcjeFb3K54uZy2BmJEyn6R1rYguouR57vaXHUh5dt/BtE8EM4AyLL8JL3yTHBo63T74HT/3/o1w6nk+vUiEs3ZsTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18 2026, Mike Rapoport wrote:

> Hi Michal,
>
> On Tue, Mar 17, 2026 at 03:15:32PM +0100, Michal Clapinski wrote:
>> Also return false if kho_scratch is NULL.
>> 
[...]
>> diff --git a/kernel/liveupdate/Makefile b/kernel/liveupdate/Makefile
>> index d2f779cbe279..dc352839ccf0 100644
>> --- a/kernel/liveupdate/Makefile
>> +++ b/kernel/liveupdate/Makefile
>> @@ -7,7 +7,6 @@ luo-y :=								\
>>  		luo_session.o
>>  
>>  obj-$(CONFIG_KEXEC_HANDOVER)		+= kexec_handover.o
>> -obj-$(CONFIG_KEXEC_HANDOVER_DEBUG)	+= kexec_handover_debug.o
>>  obj-$(CONFIG_KEXEC_HANDOVER_DEBUGFS)	+= kexec_handover_debugfs.o
>>  
>>  obj-$(CONFIG_LIVEUPDATE)		+= luo.o
>> diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
>> index 532f455c5d4f..c9b982372d6e 100644
>> --- a/kernel/liveupdate/kexec_handover.c
>> +++ b/kernel/liveupdate/kexec_handover.c
>> @@ -820,7 +820,8 @@ int kho_preserve_folio(struct folio *folio)
>>  	const unsigned long pfn = folio_pfn(folio);
>>  	const unsigned int order = folio_order(folio);
>>  
>> -	if (WARN_ON(kho_scratch_overlap(pfn << PAGE_SHIFT, PAGE_SIZE << order)))
>> +	if (WARN_ON(kho_scratch_overlap_debug(pfn << PAGE_SHIFT,
>> +					      PAGE_SIZE << order)))
>
> Can't say I'm fond of kho_scratch_overlap_debug(). How about we make it
>
> 	if (IS_ENABLED(CONFIG_KEXEC_HANDOVER_DEBUG) &&
> 	    WARN_ON(kho_scratch_overlap(...)) 

+1. And we can get rid of kexec_handover_debug.c, for now at least. We
can add it back when we have something else to put in there.

>
>>  		return -EINVAL;
>>  
>>  	return kho_radix_add_page(tree, pfn, order);
[...]

-- 
Regards,
Pratyush Yadav

