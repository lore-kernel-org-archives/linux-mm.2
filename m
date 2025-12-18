Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B24F6D68BE7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 07:47:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 09E746B0089; Thu, 18 Dec 2025 02:47:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048B86B008A; Thu, 18 Dec 2025 02:47:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8CFE6B008C; Thu, 18 Dec 2025 02:47:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D95F86B0089
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 02:47:49 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7185D140DB7
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:47:49 +0000 (UTC)
X-FDA: 84231812658.05.F350A12
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf08.hostedemail.com (Postfix) with ESMTP id EB2C6160015
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 07:47:46 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xGswW9mm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=12xfeIIr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xGswW9mm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=12xfeIIr;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766044067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pSlq6nuapXlPZtqsKEQ7mS1ImZ01jhm7Caka7wJ5hO8=;
	b=FP5UKM2jmQ1X/NUi01vUAAwJF/dO+awU/k9hKOT38Wis+sfToIHUlLlWPLwn7wM7n+TUSD
	qIjpMSOofPlJBTU/62TOxlmghCl5mS9pxgHOPjZw/DEYQiCiRk992dMH9N+YAqSzBNdkKs
	6U04+iRd1Lwqf7zLSLo8c2KwUDGudvc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xGswW9mm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=12xfeIIr;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=xGswW9mm;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=12xfeIIr;
	spf=pass (imf08.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766044067; a=rsa-sha256;
	cv=none;
	b=XL8+I7/FsyL7W255VIEgFaMgHLtJfjlkG9Qe6wrxE4afjkxLE42hggDsuBc8v8/FFfSYr4
	RlMOzX0dOb5VNXGdCECoxg8tmyFHVwZYCLZgFwm4v2ZM5bIQmfhuW1oB3lmbU2aq05VF0i
	8qrTc6IRp16cG+RlhtZtG3FPiZpYVm8=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1608E336E3;
	Thu, 18 Dec 2025 07:47:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766044065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pSlq6nuapXlPZtqsKEQ7mS1ImZ01jhm7Caka7wJ5hO8=;
	b=xGswW9mmEdYxve8qWfUjRzkM0alEkhjtKTJql2b1uFo3KxBid93Ccp2YT5lW/tnR2/aq83
	GnVwshDLCQ9OEARRJ+blcWw5Wl7RurDK7UmOcEhlE2Z2F4SfrzBbvbhYAVHXE9j6R5t4Lp
	2PMhlBjHPhxgTYbOSHjVGtxyJ/yuGyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766044065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pSlq6nuapXlPZtqsKEQ7mS1ImZ01jhm7Caka7wJ5hO8=;
	b=12xfeIIr0TEtg0oz9K8ds5m3lHbkuGcVBzuNqIxhI3qsl8sqFDjbH9XpqfCu6RFoILRFqv
	lhZYgT/Cb4LCAyBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1766044065; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pSlq6nuapXlPZtqsKEQ7mS1ImZ01jhm7Caka7wJ5hO8=;
	b=xGswW9mmEdYxve8qWfUjRzkM0alEkhjtKTJql2b1uFo3KxBid93Ccp2YT5lW/tnR2/aq83
	GnVwshDLCQ9OEARRJ+blcWw5Wl7RurDK7UmOcEhlE2Z2F4SfrzBbvbhYAVHXE9j6R5t4Lp
	2PMhlBjHPhxgTYbOSHjVGtxyJ/yuGyQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1766044065;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=pSlq6nuapXlPZtqsKEQ7mS1ImZ01jhm7Caka7wJ5hO8=;
	b=12xfeIIr0TEtg0oz9K8ds5m3lHbkuGcVBzuNqIxhI3qsl8sqFDjbH9XpqfCu6RFoILRFqv
	lhZYgT/Cb4LCAyBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id BE9853EA63;
	Thu, 18 Dec 2025 07:47:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id fLIwLqCxQ2nnCwAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Thu, 18 Dec 2025 07:47:44 +0000
Message-ID: <7b2673cb-1f0e-4a5a-84e3-0ae10437308d@suse.cz>
Date: Thu, 18 Dec 2025 08:47:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] introduce pagetable_alloc_nolock()
To: Brendan Jackman <jackmanb@google.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 Ryan Roberts <ryan.roberts@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
 martin.lau@linux.dev, eddyz87@gmail.com, song@kernel.org,
 yonghong.song@linux.dev, john.fastabend@gmail.com, kpsingh@kernel.org,
 sdf@fomichev.me, haoluo@google.com, jolsa@kernel.org, hannes@cmpxchg.org,
 ziy@nvidia.com, bigeasy@linutronix.de, clrkwllms@kernel.org,
 rostedt@goodmis.org, catalin.marinas@arm.com, will@kernel.org,
 kevin.brodsky@arm.com, dev.jain@arm.com, yang@os.amperecomputing.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, linux-arm-kernel@lists.infradead.org
References: <20251212161832.2067134-1-yeoreum.yun@arm.com>
 <916c17ba-22b1-456e-a184-cb3f60249af7@arm.com>
 <aUGOPd7gNRf1xHEc@e129823.arm.com>
 <100cc8da-b826-4fc2-a624-746bf6fb049d@arm.com>
 <aUKKZR0u22KOPfd7@e129823.arm.com>
 <d96ac977-222e-4e8d-9487-da1306198419@arm.com>
 <aUKnfU/3FREY13g1@e129823.arm.com>
 <d912480a-5229-4efe-9336-b31acded30f5@suse.cz>
 <DF0J58HOVLL4.2E16Q87D2UXRW@google.com>
 <d5354d96-6f28-41d7-9f66-64c254d9477b@suse.cz>
 <DF0NWLWKRKYI.3PLY78UGGG2PD@google.com>
Content-Language: en-US
From: Vlastimil Babka <vbabka@suse.cz>
Autocrypt: addr=vbabka@suse.cz; keydata=
 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
 m6M14QORSWTLRg==
In-Reply-To: <DF0NWLWKRKYI.3PLY78UGGG2PD@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EB2C6160015
X-Stat-Signature: tm4g7rnhpra6it6epgkoakc4sprjkgcd
X-Rspam-User: 
X-HE-Tag: 1766044066-620779
X-HE-Meta: U2FsdGVkX1+mIiHDWC4oKzznausa4+zuPn2bBnblnZJNiKY8Cf59lZZwRpS/GGUQeD7C0LX/ggzYPmJ40fd27/CSCaqYMR3jE5e9yllLq5R+Race80qVypqkvhGLjUHxTOTU4Du1PJ580K0y4ezLGvQMJZ15bni9g018mC807d62HvmXaR+JI6FxmEJemPPk+9Gh0wY2UY2igXSdtqv993h07nJAAz7aH+alo0KYrWWEdKKess1kKU2h9R68p/5xymd+DwmK0+MLkDCVSraWhTMIfX5os0XSLbPP6GNVPfL5T631L8offxUL9GwRBwhFvFCiGo6cHrqCNMpfsPDEWUocrSyFi3oJwpq4Ej2y4eEqEAVYpeBfA5lNz6jGW1DdqbCAKB8o3ze3GcJUpjdp0ZhyEC6xPBSE5nn0zec/KjEBFiVAimeXNneNg+cYuMYUsp6YUt7crYmHOHrFt6VHEm4MW6m+cv1g4vQIWDIHFypBSEBrKO4kYzcT5KX2msxJ8Urod57gp1w1DaCcXSVTyTO6xLG7buGoS3INOODWTitews54HU/ws8RESwA+Yu1Ppo7OdWZ1g7D4FZ8ue0011vWRaRUznYK6W0NaayVz0tzwABbWmh8vp5+lejfT0ohhOx56qE5Vx6oUIDX0Sp/vQHmd2prcVrol7G8jJZWQHWuWwvcUgXr/Hfe30y4UOxQc3EMLowqlUur4F188khVc6n9Zw0ZEw8Z8szqxBrlKb+C4zbhWWip1MDCDyG1hV/F4/Mc7SxOFZr1/u7YDVk6y/SDas79l+FoM6MH/TRtHS8j0Gmke/WjdfzPBrxHGSb+5DErHuVkArP7GxVM54XN3WwMNaGKxwDRS6ThFAPMFZS7NMoZakFRFxDzFaxse0JEWnebhXAbXl7VW72V+5t2vIttbPcfz+R9CNtYMl8CoCpVpbh/P01LumKPCdRPWSr/z0M8umlLbz+NIXBvLEJX
 AOcp6Ezq
 +KMWX4FGUqOEU3shQCzt+JNJJWfua+6sLix+jl37Yp9SqE64iGljE6ypBtv84iM2TE2FBpvMot5YxsS3k337rSaqLYnM08QbJw9/7aAQfb5VAvDZeuq/jN+cnZVRlUDkfA8WGh/FGi/qlC4vR2BKB1cYNOnJliylwau06Na0m2/cZ3zvxk9qE5dAMm8/AbXUQeKP1VCHSGJsuw3gomKberLXXfG4d2H6S6qsGM6U5TRoNieS8/A2m4hEPMHQ9esTZnotmitmqk4Xkb+l1Hg8/pVht71iChz3RGRj48KOFPvBPHp5bRaIU0O+kQGazuIDpDzgAqGMPNGvyppqvUJQTHCD8dzhiMHjokXjbbJks75nadkgAa1CxjGo/SJ4isXO8cCTOAcUqaaPzna10eTDXR8YQ328Q9NsZd4AstbCYpxIF4vQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/17/25 18:19, Brendan Jackman wrote:
>>> From 4c6b4d4cb08aee9559d02a348b9ecf799142c96f Mon Sep 17 00:00:00 2001
>>> From: Brendan Jackman <jackmanb@google.com>
>>> Date: Wed, 17 Dec 2025 13:26:28 +0000
>>> Subject: [PATCH] mm: clarify GFP_ATOMIC/GFP_NOWAIT doc-comment
>>> 
>>> The current description of contexts where it's invalid to make
>>> GFP_ATOMIC and GFP_NOWAIT calls is rather vague.
>>> 
>>> Replace this with a direct description of the actual contexts of concern
>>> and refer to the RT docs where this is explained more discursively.
>>> 
>>> While rejigging this prose, also move the documentation of GFP_NOWAIT to
>>> the GFP_NOWAIT section.
>>
>> There doesn't seem to be any move?
> 
> This is referring to [0] and [1].

Oh I missed [0]. Thanks!

>>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>>> index 3de43b12209ee..07a378542caf2 100644
>>> --- a/include/linux/gfp_types.h
>>> +++ b/include/linux/gfp_types.h
>>> @@ -309,8 +309,10 @@ enum {
>>>   *
>>>   * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lower
>>>   * watermark is applied to allow access to "atomic reserves".
>>> - * The current implementation doesn't support NMI and few other strict
>>> - * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_NOWAIT.
> [0]                                                   ^^^^^^^^^^^^^^^^^^^^^^^^^^
>>> + * The current implementation doesn't support NMI, nor contexts that disable
>>> + * preemption under PREEMPT_RT. This includes raw_spin_lock() and plain
>>> + * preempt_disable() - see Documentation/core-api/real-time/differences.rst for
>>> + * more info.
>>
>> Can we reference the "Memory allocation" section directly?
> 
> Yeah good point. I will send this as a standalone [PATCH] mail tomorrow.
> 
>>>   *
>>>   * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
>>>   * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
>>> @@ -321,6 +323,7 @@ enum {
>>>   * %GFP_NOWAIT is for kernel allocations that should not stall for direct
>>>   * reclaim, start physical IO or use any filesystem callback.  It is very
>>>   * likely to fail to allocate memory, even for very small allocations.
>>> + * The same restrictions on calling contexts apply as for %GFP_ATOMIC.
> [1]     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 


