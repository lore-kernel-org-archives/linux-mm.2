Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B88CC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 08:35:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F0106B00AC; Wed,  5 Aug 2026 04:35:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C6F46B00AD; Wed,  5 Aug 2026 04:35:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E0196B00AF; Wed,  5 Aug 2026 04:35:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E2C76B00AC
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 04:35:48 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CAAFC1403E7
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:35:47 +0000 (UTC)
X-FDA: 85066557534.03.8F07675
Received: from out-177.mta0.migadu.com (out-177.mta0.migadu.com [91.218.175.177])
	by imf01.hostedemail.com (Postfix) with ESMTP id F1C9740005
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 08:35:45 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S0l1oRAh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785918946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u0AnJkrMx7QjOonbpzeN6LmXwjYrMRg/WF8FenCDs2U=;
	b=HIAiicW6VqFgoNz6PQIhbh5PCmYeYH+J8uUUI9RiUos9AEu6u03Op+vR2SVD3tO7uzgz7U
	h12bPh/LuiukwpkXcrD4oY6Htiz2h0qaSSig29DMkb2q+qxCVnvSfT92+WDWs0Z+E6cNMb
	NyQhF2WSi3tMa/urL2foNL8TV1oUcBk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=S0l1oRAh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf01.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.177 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785918946;
	b=gU7aUsHUY/1xmFd3AOax2mONP/i+iwDr5ihE3cn6NcVk25RTP+cjDXKhAcWoyi72fQ4dqw
	L/iJyAnS+DSeJw9rg8vQOa+sYQhdfmkodFlYKsM/zXIAELUZckK1H9ULrVw/tBe09lqCsv
	FNug4P6bA7R8ALfUTEhGNWQ6n2zeYq8=
Message-ID: <666e55c0-5d4b-4b3d-9523-8170a012b172@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785918943;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u0AnJkrMx7QjOonbpzeN6LmXwjYrMRg/WF8FenCDs2U=;
	b=S0l1oRAhRXzEMa8alEZliRFQYihbm6sNGtqbMEZ6pcnYJR2Vf5+jhfQUQlswrmqcs2CyHV
	GVP4mwT0sVS9f3LdXIaPAEnYIHbR4KObDuAg3Ta+q4Zoe6AHxKSaJPN5ghrjHVQLsXyHLr
	sSD07L+JgfuBgkOV8+75sDO2DUHoiUI=
Date: Wed, 5 Aug 2026 16:35:21 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] alloc_tag: fix undetected compressed tag overflow when
 profiling is disabled
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Abhishek Bapat <abhishekbapat@google.com>,
 stable@vger.kernel.org
References: <20260804122038.190270-1-hao.ge@linux.dev>
 <20260804124346.15e4be960ca4ac739f740248@linux-foundation.org>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <20260804124346.15e4be960ca4ac739f740248@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F1C9740005
X-Stat-Signature: y565uegwfkd9m8gzutxzufwqihb7m51n
X-Rspam-User: 
X-HE-Tag: 1785918945-601019
X-HE-Meta: U2FsdGVkX1+AUsA1D9JXqM+P9fwH0xoyO/B63ChXMVEjpjOsyeYKTM1wfNGoIplebSm6/HxGZ0Kch0YtsBqgxs/OsnskLzgiuf6CX1cyYVHzBIIUz7GeCalhUa2XcoRKnvtxQddnziCk2C/aYphA30E00OIlFUnZgSuwUWTiwPCchs2oowKAA0MxnSuetkGJTpqRr+kAK8V8NBygxDVTOlCUu6gvIEb6Ta/Q8SQdMyBnvzPrKh66qJnKMCmDFistBVRKkXRXyvE0dr0eMj+b3UE+fUp5MUkIE2ZCHaIY85yBg0n/sztPAsG0CgjqJ1tEuYN2BoBKnrXemoHPWyNI8bKiknJiPqBV1bqNnbL6SDZbVLDx2utRus8spaIRWsNODXbqlTj/oHgdUlTf5egXzkIGItHaE4NSfBVLHkADt373BAB2EYPCaCYhEK1X1DMKDnmQI0swPa0xoX4fs6wfUFVli5A9ymkxd74eRYBDrZYlD7JKBJdjVoMl2ko9sMm6susv/Rra5aceft/SPMcI9+7TtvZsL4TXq4p9LQ1NWFWGCpKGIkd1XfsakgYLxHZmi3cKgX4stJ3mtPHloXoTzAnvsg5YG0ld/egEc2CX5aggMUdQdQwMhCLRW7nQJTlBsKZ6TgCGBN6/BOYaZSHBcapp8d+PQbKtfEvWR3bmLUxFcczoD/zUkQxkeP+c3cVf8D1WJ3Q672kv9LDRk4i2k63NS2NhHX/15KNJCi051AD1ijE692NzQxhrb5gdCL4F0zreguHd45z8LRWnpU6OrHQNHzJ3anrYxeWh4LuhK7IS5WzuNLOqjYrL9RACVPp5rfbUfpAn8FyxWhQ8UszcFKS7yrXZK1UcdSv9F8pfrNyc4hrYo12MPYb4v9CJZqv0POC7VUXO/UGV+ZtKHfskIEL7S5WjjClmooRNuzqMitFE/CsVj5BHoCuEaEt2IgtHs+kldadF0pc97aTAMPq
 3j9JQFp4
 cXTkuhemZ3F9c/cTi3IhHXVKtwTpQs27IBtAUxAHCZcXa+zCwHTPP1CxfTyvcKlOmPMSwy9YuzznqeUEqxLZ4I6CaBAwtRtpB3Rb+jcwP84L8oCMoDpnrSgoccSnsdW4NV+Dzc0F7IrcMNtUHZEOGm/2vvyp35L/iUDOZcXgtJuXi3zDId3uiqEiKzmlgSXHexYzMgjO36Uao3xSq4V/9khMp6HEFS1ZOJYspjhxdtQqTdQ2RiZ3AFUoq08Og2le+OrbuSybtzKymzJ6CswbG6fhkn/nS751I/SOpE2+Ec3BjaITqXI2sl3UAD8D7d54HFd8v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/8/5 03:43, Andrew Morton wrote:
> On Tue,  4 Aug 2026 20:20:38 +0800 Hao Ge <hao.ge@linux.dev> wrote:
> 
>> In reserve_module_tags(), the tag overflow check is gated on
>> mem_alloc_profiling_enabled():
>>
>>      if (mem_alloc_profiling_enabled() && !tags_addressable())
>>
>> If profiling is toggled off at runtime and a module is loaded whose
>> tags exceed the compressed-mode limit, shutdown_mem_profiling() is
>> skipped. vm_module_tags_populate() still maps memory for the tags and
>> the module loads successfully, but the total tag count now exceeds what
>> NR_UNUSED_PAGEFLAG_BITS can address.
>>
>> Once profiling is re-enabled, ref_to_idx() computes each tag's index
>> as its position in the alloc_tag array. update_page_tag_ref() masks
>> it to alloc_tag_ref_mask before storing in page->flags. Indices
>> beyond the mask are truncated and idx_to_ref() resolves them to wrong
>> tags.
>>
>> mem_alloc_profiling_enabled() and mem_profiling_compressed are
>> independent. Once compressed mode is established at boot, it stays
>> active regardless of runtime toggles of mem_profiling.
>>
>> Remove the mem_alloc_profiling_enabled() guard. Also return an error
>> after shutdown_mem_profiling() to skip vm_module_tags_populate(), as
>> the mapped pages would never be reused - shutdown_mem_profiling() sets
>> mem_profiling_support to false, so no future module load enters the
>> codetag path.
> 
> Thanks.  Sashiko pointed at a few things, one pre-existing.
> 	https://sashiko.dev/#/patchset/20260804122038.190270-1-hao.ge@linux.dev
> 
> Is there any sanity in there?
Hi Andrew

Thanks for pointing these out.
I went through all the Sashiko feedback from v1 and v2.
Most of what it flagged is pre-existing and I'll fix it separately.
The only point that actually touches this patch is the -ENOMEM failing 
the first load. Between wasting a few KB of tag memory to let the load 
succeed and returning -ENOMEM so the user just reloads the module once,
I prefer the latter: a re-insmod works because the codetag section is 
skipped once profiling is off, whereas those mapped tag pages would 
never be used or reclaimed.

Thanks
Best Regards
Hao

