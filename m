Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4114ACD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 13:45:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 969EF6B009B; Wed,  3 Jun 2026 09:45:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91AC06B009D; Wed,  3 Jun 2026 09:45:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 830D56B009E; Wed,  3 Jun 2026 09:45:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 732E76B009B
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 09:45:02 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 200C71615E7
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:45:02 +0000 (UTC)
X-FDA: 84838722444.08.D9A83B4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5DF83100016
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 13:45:00 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TmG7iI+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780494300;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UAcEW5sdNzXOvmfS53awUiH9gNX5gi+01tp59tm5Mgo=;
	b=fhowu9H88zTwXuf0amqp91nD7M/f6SBA6xyLueeoWjuH/eyV/Fu9wtfosmjJILKUmEvhFC
	zVJKZks9uXOn8EJNG5+ZiSZs9enWvQjJ2BrhLpxumxQ0BZFnOF/gZjMRmfySPQGqYL68ls
	tbRIwc2NxEzIBEzMy6gkR0MI4Ptpy2c=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TmG7iI+A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780494300;
	b=Ji/4pKPHA6m6Q8Xa8eGFfP+gbkLuftA1MUndnxH0ENzOQwE9yINrJAAJkp+nAjebtfJVpR
	34XHTjm70BDDKrB+YPG8Y0+A1kCuwa51sxmScFROP6PRBqbxs3B0DlZh/3ZQiDZHi0rsvC
	aPqdGOM7+Ir88kMxcJF8/0a0TJat3pY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D5C5D601DD;
	Wed,  3 Jun 2026 13:44:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 944BF1F00893;
	Wed,  3 Jun 2026 13:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780494299;
	bh=UAcEW5sdNzXOvmfS53awUiH9gNX5gi+01tp59tm5Mgo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=TmG7iI+ADon1SUHGYPnaGVvdMlaCwNhAUdiLnKnBVhjmEuAiUJ3gucXtELvOYXjjY
	 wfjdALcg3+UuQiIPuVgR7//OC8D1F0K2QstqgbbTNpJxgRDkbV6s8+ES+JLVDADvzX
	 0bed1eQkhDy84HStoEhqYmFnF4Tk08e7wxUUivCRSTqB59usF6Zo/uedWhmz4lq9yA
	 ih+wOYHOZgPJYAHVBNW0glj9x9vplX2goojLzY1DrKAi9RsnOJ8zQzN0bDQrAyzvt2
	 7IVMk3i22Pep6O1zRHtTiyalbT97jJiopI2/0Hj/lphkZ4laxlKmrnaEvVzb68B9mn
	 VlKNASpUU2+jA==
Message-ID: <b930678d-a1ae-458c-8705-7ca9680d4cb6@kernel.org>
Date: Wed, 3 Jun 2026 15:44:54 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: mm/memory-failure tracepoint change breaks userspace rasdaemon
To: "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>,
 "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "mchehab+huawei@kernel.org" <mchehab+huawei@kernel.org>,
 "Luck, Tony" <tony.luck@intel.com>, "bp@alien8.de" <bp@alien8.de>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "xieyuanbin1@huawei.com" <xieyuanbin1@huawei.com>
Cc: "Lai, Yi1" <yi1.lai@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "linux-trace-kernel@vger.kernel.org" <linux-trace-kernel@vger.kernel.org>
References: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CY8PR11MB7134346A3E4BB28ECA28D6E989132@CY8PR11MB7134.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: cikh7zdqd9pdu96ey3qk5oqsxtwew4a1
X-Rspamd-Queue-Id: 5DF83100016
X-HE-Tag: 1780494300-89751
X-HE-Meta: U2FsdGVkX19q4s1CFO28qO+jnsWwxOqGC3qCGJkI4urubLiyBw2PlbaLHtkMOxFjSId0UZ4BDsyom7v4UifLNjKlWh/wBZ0RZqULXUCeKEpU6bWKx4vXhNjfCQwLu53g2U+aAOmEBgfj+JNy2/boTWq5YGfZ+VK1WWe49hVg50yiLYnJq69/K3g+a7vUDI/+sBTbzFwMdaVeqQLn83wsFbHP3aCI4KkcI/hs5HodYUeZMUyVUVzKEVCIiz+9qKp4/oDT4CR2Bvx1eIPsiHA+X8gLxhhio/oSeBt3XHODfxkSrQ/Sgt8dSVTTbeQzQT9S1gUI54zTHJvQiOYfb+iZGux2Xroqwf2dxEHY2jZ1yE86FDcbZlSweVq1WuFAeRMAka7Av54e49HE2dM/3FMX6dKNemyKWYQ4xVjp3+KXzie15tsvbEZ+VWeMRV0NE5dnE665ySgwlHWrv+52G3nnYHkK3l8dM5SaJ2YWNCcPNMgIhE/GQjAdNbyK9BsDCVAuPaKH4w3Z8qM52gdNGKuPzvcVm1uIfwu5NmcVL/rowuWSuUtCq2Fg9jkxiBJOiZh2gTvrR4D5RBLO9JX+1HhZ5uqWgzquN2v7UlHdJtGdKEgYUvNX/OJqsUUfWNP4KHmhCjkvqYMBaApMeFZG4sWWhwe8W13EZXT6jGNToinFO0Z5cIZ8k7A+v0bfXQFBV5l2r5zm1s8P147eR2Nw5HjwAuatWPLEawdtN1Ns88kBZF7AVhQ/leA8qeQe/V/7A32nmPebG5tQ1t4Px8IKL+o+HjdMabfBtBDAxbQfBOnojLDs/2h5oAV9QTuwi6SEsEmTBmzie6Q4R+McGuW73N2zXAMEkzx8nD0bXxgwpElyhdJFPf61muwMIrJIIC241PGf2+NMsfp6Hj9DpZoX4bbNUwOt6guRh/YSqEhTNgTZwLGure12bOJzdzjJNLB7pPgy3Xu7t3YwXcHvm1NtKfh
 W5Sb9dbL
 vLEcyW7H1XIHQYXovlwDJiU2T5t/elXsF6D6T90Yb4IJx9AzUp7Y62ep/Zgs/pVziL29SzvJs1V1StfqI4Jp9NmZNbfbUk+ZDoKYw5bc91k/moHUzTo9GtTeCzGPFnRcR6ZLKscBpXC4MD68qHfWgjs6uFMcWT1hDmd/9dsGkUp7H1rb38uEurxNUWUVMUseps+99hvCobCnrOzvr8W/XY4rLFCwlSWMUDWD6ARisSm7UTbTzV+9GF7ZmFxSlE541CGHtyNardFaa7KalnAR7FV+ANRYWTLxkzq3w0flCUA+PDWL2m0B+9ZQZqsDadfEH+yr0VMVfgKfOjoBkqLz3BInDPcp0jQekaM6ThPYZAnWW3xkwdTzwiulQL0CGKpRBDjA4ph6UxbZ+rv6YdNYr6NvjiXpywge7NeHCGAjVQyfXahySJf67QQBvYBXGfLxa6Onw+DfcFH0yamQkKjdpu/OQhc1oOcbc+4pUyfgc7iDlAre7o9yC9lKvw9Vet4IfFVfPiRZmY/iIknml3Rd7MJoFfYv8smxyk8i1it6RRNAFxsZ2mr5tcrYAdY74ZXqk/RzE7rzCb8v5ic0kEsdaVenA3lINoS0ggKz2rrOQwxQq1qLkRoeAq3ShFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/3/26 15:11, Zhuo, Qiuxu wrote:
> Hi,
> 
>  
> 
> Laiyi reported that the userspace rasdaemon fails to enable memory_failure_event
> on kernels >= v6.19.
> 
>  
> 
> Kernel commit 31807483d395 ("mm/memory-failure: remove the selection of RAS"),
> merged in v6.19-rc1,
> 
> moved the memory_failure_event tracepoint from the "ras" subsystem to
> "memory_failure".
> 
> However, rasdaemon still tries to enable:
> 
>  
> 
>     ras:memory_failure_event
> 
>  
> 
> while on v6.19+ kernels, the tracepoint is:
> 
>  
> 
>     memory_failure:memory_failure_event
> 
>  
> 
> As a result, rasdaemon fails to start:
> 
>  
> 
>     …
> 
>    Can't write to set_event
> 
>    Huh! something got wrong. Aborting.
> 
>    …
> 
>  
> 
> Reproducer:
> 
>  
> 
>     rasdaemon --enable
> 
>  
> 
> Could you please let me know whether the preferred solution is to revert the
> kernel change,
> 
> or to update rasdaemon to support both tracepoint names for backward/forward
> compatibility?


Likely the latter. BPF [1] documents:

Q: Are tracepoints part of the stable ABI?
A: NO. Tracepoints are tied to internal implementation details hence they are
subject to change and can break with newer kernels. BPF programs need to change
accordingly when this happens.

The Kernel ABI document explicitly doesn't list them AFAIKS.

There were previous discussions on the stability of tracepints [2], I don't know
what changed in the meantime. CCing Steve

[1] https://www.kernel.org/doc/html/latest/bpf/bpf_design_QA.html
[2] https://lwn.net/Articles/747256/
[3] https://www.kernel.org/doc/html/latest/admin-guide/abi.html

-- 
Cheers,

David

