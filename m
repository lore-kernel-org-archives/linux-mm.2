Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BD87F4369A
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 13:11:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73F086B0103; Fri, 17 Apr 2026 09:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 716176B0105; Fri, 17 Apr 2026 09:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6534D6B0106; Fri, 17 Apr 2026 09:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 54B5E6B0103
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:11:08 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1C3F138E37
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:11:07 +0000 (UTC)
X-FDA: 84668083374.12.780720F
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0A9FE160009
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 13:11:05 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nLP9+NmO;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776431466; a=rsa-sha256;
	cv=none;
	b=Cgs+i1Rkf+85g4O4yb7dP7sSfjEkw28RSPJ2AkpJvSSM+t90vacmOJMI53fhghmG62gJPX
	4av99tkXL6Aj/TkEilGGqfdMMGno8pm2si/S9iKHfo/SPjESnSxpncaJiNWhEXDtcduGhb
	j/O851WxuxoYrGUOwpmhxcUYysZky3k=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=nLP9+NmO;
	spf=pass (imf08.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776431466;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UZ+9QdPmSTx/ezgB1oRSxcs6WFStfM5GyAzSgULBfK0=;
	b=0pgMb4HiWhnGD6S2N3Y7hytn4Wh8TlhzI4zrupCAzRjAvmCUBCTTw0RY7fP1l5lOLYUzDf
	FHcP7LwrhnFq3QGDK4da0Ru7P1yHtD84Bfapsaf54GxeXJHVHq+c+H0zqGNRkTkdbTblBQ
	ZgPHPTfFpQIiL2UTN2YwWFMq9XEixCY=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1216A1C2B;
	Fri, 17 Apr 2026 06:10:59 -0700 (PDT)
Received: from [10.57.63.31] (unknown [10.57.63.31])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 312443F7D8;
	Fri, 17 Apr 2026 06:10:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776431464; bh=UZ+9QdPmSTx/ezgB1oRSxcs6WFStfM5GyAzSgULBfK0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nLP9+NmOP4Js5PxqLmjA9erzChDc1WNxHz0qocmuG+AsyaZz8t5QVQ1Lo5Rct4eL2
	 KPNqAe7G2utJg38/pHsrTnSjhvBlhhVTbSoisuYuAhC7ve0hNuyJOThpP/YByANyjN
	 MdbXC7wVzrfGBlCo2N0+cUxzbDtoHJT7TGqJbU94=
Message-ID: <5adc64e5-d4e3-42f1-8cf2-6e824bad2bf6@arm.com>
Date: Fri, 17 Apr 2026 15:10:52 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 01/30] mm: Introduce kpkeys
To: "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Andy Lutomirski <luto@kernel.org>, Catalin Marinas
 <catalin.marinas@arm.com>, Dave Hansen <dave.hansen@linux.intel.com>,
 Ira Weiny <ira.weiny@intel.com>, Jann Horn <jannh@google.com>,
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>,
 Kees Cook <kees@kernel.org>, Linus Walleij <linus.walleij@linaro.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Marc Zyngier <maz@kernel.org>,
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 Maxwell Bland <mbland@motorola.com>, "Mike Rapoport (IBM)"
 <rppt@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Thomas Gleixner <tglx@linutronix.de>,
 Vlastimil Babka <vbabka@suse.cz>, Will Deacon <will@kernel.org>,
 Yang Shi <yang@os.amperecomputing.com>, Yeoreum Yun <yeoreum.yun@arm.com>,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
 <20260227175518.3728055-2-kevin.brodsky@arm.com>
 <eaca640b-5006-489b-8b2d-148a3c4073da@kernel.org>
 <fea9c939-f955-4020-bed6-427e592f0024@arm.com>
 <cf9da9e0-310b-4dc0-81aa-3154077fff85@kernel.org>
From: Kevin Brodsky <kevin.brodsky@arm.com>
Content-Language: en-GB
In-Reply-To: <cf9da9e0-310b-4dc0-81aa-3154077fff85@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 0A9FE160009
X-Stat-Signature: dgmezafydziwo741w37dxz4hrcsa47dw
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776431465-446980
X-HE-Meta: U2FsdGVkX190XzvjEDrUDLp/9Ra3V1fCyoVhBzJnSskzcHvzhBVanqbC217LsfgBkbom5kgM5LNvBzqe+cRcgDBEuJe5GIkFHJjgcdUbSvfVZgnD/Pgq9IUlYS+2aokE8OEqllyt65lYCZ9cApm+K0QlR7bMpvycAsPA+HqsCWiwKu2uFJbhkPkpKaP5iAU2923tej/hJ97EjXkezAfyVHiEqnHTSvo5CdE4i9i+I/B4YW3Zb2pU7Ao/UTk/SnaA5TFvApr6hgZyRVz7FCWg7iXS6oaCvSy2ER6nair65ym+HXBMIrYlNvpIRX26lotAciN6MWYmFcAHArso9uLCPchjKw9BBs5Z5XT71oVzmD+1UCJrAk7LIjPGy1EyoJ/59pb0A7jH2nN1cg4EHTwH5QNvkMavOWucMfA3Ev2QxFHc0WZ0v9c1JojFuhrEJB6OZX/h6Zt/UY+cLnC84logbmsksrIMoZtXemkgbe+5GRdgXgHEBy6CzlgNgT38zdqSnXXvAmqk8e/m37kQD081nzlE3WpjBAsZv6dsgA3FxaqJfhBBK8v0wShTQ+cr5PCWS3YxjRMhr0e8pPMX8lRtqL/rIqbVs0uFdTI4d7P7eyVSQ05/vom3VzDfpDV2ogDA1y7C0WNyHD00jJHHapq2iIWqjtvBAX762sTwofWPmOwORpMScErIEUG1mSmVwo8kDYjf5RW2/xGGzK2cmcCddLCyAWoz2RQq3/K2lVSpkAG63oR+dCDXoz/BpDxRHNUS887WvmQd7oWqtBKfTla0G3ZtB/gk+YYxItugNYThyIVUIMEQyYIMC7/vxIbxJbdNXcv1SbnZqMZYmvUemzGs5vI2vZTzh+viXy/VolDgGfG4nMVmU5MIoX2yBn5G047khOoD3UULuZFaFbUj7GZYcC/0K8FqPyWBiNoweufrorF4O9zpK6CYX1H4npt3gcxp/OK0/cXdBVMbAv6kYad
 Kw3Xsq/t
 oHCJFfvzatghMuCeneONsurvqb26RVfd+k7thhBOcbvCiM/+ejw9pbMZ4biyPZGFe9LqLu2qejmmk3yAjT+aVSdF0oNJPnZaRTS/TgijUa7eIC1s3zHKvH1lppIb9EeTa6WGFSz4bkbHvf4SLQeeJcW9j8gy2T6A/QxPGele/MWtWndWHJo8fJK7FO0oy+pvkUf+6EqeolZuTge7Kw+KIqM6z2frE0AzUcv1ifUz5/LpWQq0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/04/2026 14:00, David Hildenbrand (Arm) wrote:
> On 4/15/26 17:50, Kevin Brodsky wrote:
>> On 15/04/2026 15:00, David Hildenbrand (Arm) wrote:
>>> On 2/27/26 18:54, Kevin Brodsky wrote:
>>>> kpkeys is a simple framework to enable the use of protection keys
>>>> (pkeys) to harden the kernel itself. This patch introduces the basic
>>>> API in <linux/kpkeys.h>: a couple of functions to set and restore
>>>> the pkey register and macros to define guard objects.
>>>>
>>>> kpkeys introduces a new concept on top of pkeys: the kpkeys level.
>>>> Each level is associated to a set of permissions for the pkeys
>>>> managed by the kpkeys framework. kpkeys_set_level(lvl) sets those
>>>> permissions according to lvl, and returns the original pkey
>>>> register, to be later restored by kpkeys_restore_pkey_reg(). To
>>>> start with, only KPKEYS_LVL_DEFAULT is available, which is meant
>>>> to grant RW access to KPKEYS_PKEY_DEFAULT (i.e. all memory since
>>>> this is the only available pkey for now).
>>>>
>>>> Because each architecture implementing pkeys uses a different
>>>> representation for the pkey register, and may reserve certain pkeys
>>>> for specific uses, support for kpkeys must be explicitly indicated
>>>> by selecting ARCH_HAS_KPKEYS and defining the following functions in
>>>> <asm/kpkeys.h>, in addition to the macros provided in
>>>> <asm-generic/kpkeys.h>:
>>> I don't quite understand the reason for using levels. Levels sounds like
>>> it would all be in some ordered fashion, where higher levels have access
>>> to lower levels.
>> That was originally the idea indeed, but in practice I don't expect
>> levels to have a strict ordering, as it's not practical for composing
>> features.
>>
>>> Think of that as a key that can unlock all "lower" locks, not just a
>>> single lock.
>>>
>>> Then, the question is about the ordering once we introduce new
>>> keys/locks. With two, it obviously doesn't matter :)
>>>
>>> So naturally I wonder whether levels is really the right abstraction
>>> here, and why we are not simply using "distinct" keys, like
>>>
>>> KPKEY_DEFAULT
>>> KPKEY_PGTABLE
>>> KPKEY_SUPER_SECRET1
>>> KPKEY_SUPER_SECRET2
>>>
>>> Is it because you want KPKEY_PGTABLE also be able to write to KPKEY_DEFAULT?
>> Right, and in general a given level may be able to write to any number
>> of pkeys. That's why I don't want to conflate pkeys and levels. Agreed
>> that "level" might not be the clearest term though, since there's no
>> strict ordering.
> As discussed offline, maybe the right terminology to use here would be
> something like a "context".
>
> You'd be activating/setting a context.
>
> KPKEY_CTX_DEFAULT
> KPKEY_CTX_PGTABLE
> KPKEY_CTX_SUPER_SECRET1

Sounds good to me, that's more accurate than "level" if it is possible
to give access to arbitrary pkeys to each context, which is the current
assumption.

> What is accessible (and how) is defined for each context. For example, I
> would assume that all context allow for read/write access to everything
> that KPKEY_CTX_DEFAULT has access to.

Most contexts would, although as I mentioned in the previous email,
unprivileged contexts such as eBPF programs may be further restricted.

- Kevin

