Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 11665FD5F94
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 07:50:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3486C6B0088; Wed,  8 Apr 2026 03:50:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31FAE6B0089; Wed,  8 Apr 2026 03:50:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25CAB6B008A; Wed,  8 Apr 2026 03:50:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1821E6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 03:50:50 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B11B913BF2A
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:50:49 +0000 (UTC)
X-FDA: 84634617018.20.24BBE00
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id DCB8840009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 07:50:47 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KcGl9cWd;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775634648; a=rsa-sha256;
	cv=none;
	b=BH8/CEdXhT+wNUEwf3UodTRzCWJeHyVWI9lJUhhlbtIyBMEPW67q0uV0D2FlNIGmP0288t
	vl43uth0XY7KzKuYFihtOcBXmlb2LpMzkIWPcLDn3JvEWCoURh8EEyw4mX9FXA61xXvQzR
	lJWdV4p4mAbFcuz7JeGxcPsjXyCSf7I=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=KcGl9cWd;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf04.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775634648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kwaAVCJ9AgzuJi8JKla1pDfqyqywMetty9XDV1vrBxg=;
	b=Lj6BN2z5sd0KTExpavkP1hIC1MpEMDtpwfEf0ugOzhrPP28G0/qG8ATFEIPEt2lXpMXEA0
	xMr1T1dG922/aYLlVCieF4UIyhJqnTwGCdu/prC+N/IL7cmnwrrbNnvkRV1lX2zjrBiN1g
	4zRm8qgdiUNMxG8fqCfpZpVuQfa+M8A=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 3711D35A2;
	Wed,  8 Apr 2026 00:50:41 -0700 (PDT)
Received: from [10.57.32.84] (unknown [10.57.32.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 09EEC3F641;
	Wed,  8 Apr 2026 00:50:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775634646; bh=kwaAVCJ9AgzuJi8JKla1pDfqyqywMetty9XDV1vrBxg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KcGl9cWdEz8NMLMr0LTrT5hctHk/wUjL97oObHOKqRa02PevVRf/7Q0lJ5aEosm+t
	 4Be1ayY+7O2/0bhgMjr6+2U4GRm1WquugB/on5ug5x3FJrFbp2zYu4FROvwPP0Za13
	 XyWipQskCaCloqJ3Rw4atIe3QOTr2pgndsR8wuKw=
Message-ID: <971a511a-f311-4e2f-8b10-85d11e07bb0a@arm.com>
Date: Wed, 8 Apr 2026 09:50:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] docs: proc: document ProtectionKey in smaps
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Dave Hansen <dave.hansen@intel.com>,
 linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Yury Khrustalev <yury.khrustalev@arm.com>,
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>,
 Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
References: <20260407125133.564182-1-kevin.brodsky@arm.com>
 <98880cc2-09be-4bd8-b8f4-f0f0845f939e@intel.com>
 <2d2aac86-2780-4a29-9eef-116c26485812@arm.com>
 <18e2042c-d414-40fb-8819-5e930d5b1584@infradead.org>
 <8a5e4afd-cd0a-400a-8624-79c1dc9e3ff3@kernel.org>
 <fee59f61-cf62-4a60-9d8a-4543a02a9c48@arm.com>
 <efb2dda7-144c-4e00-bd5c-0b57a1244fb1@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <efb2dda7-144c-4e00-bd5c-0b57a1244fb1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: twgtkoq7gdhn9qysy8s4qz5xff1di6hp
X-Rspamd-Queue-Id: DCB8840009
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775634647-842815
X-HE-Meta: U2FsdGVkX183aGroAgyCmu633U7sYFj9IUKcCATgc0JXndsXF06E7FIx3AfzgrAPa5GWhGKZnhiA1r2hJe+GPsuM20/C4D6GN6Eev7kD1XLj+iQIikkZbCkhoGSFFzZ2v/EvzlIcDbML6bVaafaEUs8SlP+RXKf1OjeBmeeNDRdpMzXWoT1K8SaHcT1QglTBB2ev2t7aHIiswoXd3rqvmaiO0P8MWAxE2/B1M148BXsopNkgD+SGlXVP0dO5oLlL/P/FCkLEk6YWgsYicgbImnv28qt+lSJ+i9207EpxBG8EW8hyPDDwR3bI8aiHRala2eg8r66HIcsezZgAjskC+3nPj9qY4A/u0Uvv9uCukRYpDRE1/XNXxG27RLVlz3LtSJVJ2uCgGn6Wqktxwh/E7NPR3rOe+ZhABeBt1aJ//jgV+OMa4A76BKgfYjuBsRgASnLCn2gJ0RHi2bApyKy1VMrnBtxpQYueAfqj3Z/hg/apuUR69k8kubE4aoYBPrSEXFXiTXsSkVzv7WD50dW8DaXcZlvB0W+MihppHvQLexAeX7izXdfCL0xdeY0xJAVET209j2rlVclD0aMer55Dav6jdVc7oPFiYm1vlWd0wpzgLqrrPv/f7/sWI9x3JitpZpB6jvFL4+Lp0xKhEBDRcTe7q3E9kNWVvi8vjCuaNRcpIe+8prKXVGgdnmYrbmqQLnVx92pGhMudTLaUYjYNqq5tVC9b8/GNPfUXh0pyVZbaqZhX8g0l8Cs2E+j2jUAH6qiTkRGYW6oYPnibsy1XjeozVj03aC3gJDOlld8l8B8GQWxZvJQ0GV4p3Q2VhD+qZcDDCEZjKbce810Vnl13GnsFUSMmBeMeBVv109A5ey+snUqa02Rqnvfut2ljU7UL8wHNSQMAdj3sLzA2BQbbQz6XU5beypUXOhpywPOuij9gWcUjLv/F9C1GuKqfV22q3ikCgI/bFacf8gj1yxi
 tNN62HKn
 Z1rBORdSKjbSVD8UbtE/xYAlJsFTgi0sWs+llp6sJiex9wHal+0MVkwQ9VNKGoYs6Uh4Cgam/ttYaE4VFcG4ayQtqP5qxXIEciVN6HC13daSZZqdzIVC3AaYGbRbJ25obYoo6qLKb8vNbGrP+E+Skam7HsRY/1mNQt/SghnelJbcmXx08AUNzZ47H0tVS2ctOs5J9YtmNvZlD8oTvOhNb+DGhjJaU3zkpVXwYcDoP+U9j3SE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/04/2026 09:39, David Hildenbrand (Arm) wrote:
> On 4/8/26 09:15, Kevin Brodsky wrote:
>> On 08/04/2026 09:05, David Hildenbrand (Arm) wrote:
>>>> I think that "system" is too nebulous there, so I would prefer to see
>>>> "hardware" instead.
>>> What if you're running in a VM where the feature is hidden ... ?
>> Of course that's also possible, "hardware" has to be interpreted in the
>> context of virtualisation... But granted it is possible to hide features
>> even on the host with the right kernel parameter, on arm64 at least.
>>
>> "If the kernel supports protection keys (pkeys) and the hardware feature
>> is detected"? Still vague but a little more accurate.
> Can we just talk about CPU support, to avoid using "system" or "hardware" ?

I'm not sure how this addresses your concern with virtualisation though,
unless "CPU" is understood as whatever CPU is virtualised? But then the
same logic could apply to "hardware"...

Either way, I'm really not all that picky about it, I don't mind: "If
both the kernel and the CPU support protection keys"

- Kevin

