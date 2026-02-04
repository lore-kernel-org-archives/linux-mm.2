Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 58856E9D41A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 17:15:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5E9C6B0096; Wed,  4 Feb 2026 12:15:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0B976B00A1; Wed,  4 Feb 2026 12:15:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90E456B00A6; Wed,  4 Feb 2026 12:15:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 767E86B0096
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 12:15:45 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 22C5CB7C08
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:15:45 +0000 (UTC)
X-FDA: 84407426250.11.C727FAD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6A660180006
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 17:15:43 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sebSfXbp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770225343; a=rsa-sha256;
	cv=none;
	b=yFPbqi63XbnUvbS13MW9ifHoaetnM+q+jn+wemtDbWnYwSEfH1FT2vyMgR2shBKdUI9J47
	Eou51e+v/SFC33uvqnwb8aFAqWdr836Q3n5mGVH3whO3Nr6WM1eTVdDXAzRtSp3Ue+T0xP
	6v9nkAB+47yuDnz4oU8osRsAMSGG7Zg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=sebSfXbp;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770225343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fkXq6/lnbEWIGLPM2LPLowIu1e3i+jucTphYiEBVdCY=;
	b=rUKmEnfxmXFHqUCgfWB8V+vZSklXbODDFhux1Ixl+IZAB+LwQkMxXzV2m49MzgzYL9k19M
	7hdDiD2zOuzzyz8sJWfyqAFAiyv8N+3NqJCSupXNTGvs6+cUzuZJk3pGanx50/f79gc8/9
	vmwDtpRKn50Oy7PhQNmvumbQeHAuByI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B215060010;
	Wed,  4 Feb 2026 17:15:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B489AC4CEF7;
	Wed,  4 Feb 2026 17:15:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770225342;
	bh=ATG1jVXlBdy9zSOY16C8gy7f3/mfNGfDiGM3R3zgiYY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=sebSfXbptLEqXWM7aQrpcCaIOcv3oK39oeD+G6DDM53sXrb4q6jou6B+tOWd+o5uO
	 CNe6CCCZxU6vyQbt/XH5XA3ECiQEriD8EfH+cLIQCZuoYSntC7Xw7BVB0hxnI23uaW
	 XoG9mqcwLiUrNW9sW9XChNnSau7mq0gejdVDDJeoeCQpOD1taQhqlNrCV2WvqV/8fq
	 PlkcqE8mA4e1cS9JZQ3tlvdGu22rue4yVeztUdc/7diyhxp1bhihl/ls7seSNtgQBR
	 V5OveKB2WZ7SR/v/9p0uJUYR9SEZuia2qcrD5FRo34RaYhVW/mBo6FZl+xZrJpoaeM
	 u0ORBTA62F0ug==
Message-ID: <1db245a8-f9ab-42e4-8cc6-cc7562961921@kernel.org>
Date: Wed, 4 Feb 2026 18:15:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in memory_failure() at include/linux/huge_mm.h:635
 triggered
From: "David Hildenbrand (arm)" <david@kernel.org>
To: =?UTF-8?B?5piv5Y+C5beu?= <shicenci@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linmiaohe@huawei.com" <linmiaohe@huawei.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Zi Yan <ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
References: <PS1PPF7E1D7501F1E4F4441E7ECD056DEADAB98A@PS1PPF7E1D7501F.apcprd02.prod.outlook.com>
 <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <b9e89c85-807c-4a8b-aa5c-8c1325e75445@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6A660180006
X-Stat-Signature: b4n5d8xmg35r4wfa81eg7jqdp4unrgkz
X-HE-Tag: 1770225343-48426
X-HE-Meta: U2FsdGVkX19WMROj2XCHrFmEO9rAiZcxKnIoBdgOH0Kn65TA32Cozg2NTSv4EhNZDe3W3wkkJ7VBrLupFztaOxtwNjpFSTOaLau3UVIotmOhpo+q2ucJwxbr8lcImaGxtFYRDJG0Zgw1x8/4bDT2LuaZ08AhQMqNcK9y2y/SHo5/Lsz3W1Z1ozL23kU5Xf3XCLQj2YrKNAY1xe+oGpGGoWT6xmAhwSJknNbEbOzFns7sFdWap5rfLlWB9FpFUk5dOVlTRTdhYD9lQ45jpOD3d3H/LwmoUNauREnCEiq+0muuo1WLxJOwGX+M82j7YNqXMU1Jp52K7pKcFyBxMqpyPpoYhL4xJDBVDevXlUH9vZve199X0ykzUbr5UJuXE1w3GbqsbsZe3+rFO55JgDTt8L4zuixjSlBuB8P4hUKPVEmeteO2okVHJBlgLVKoUC1drSmm3uZdosDdgFpckeNsEO8VMaKVW6U26SIkrsN0oAx1L7J6QevdYO6P0Cc0NXLXO+TU9rCZcO5LOjzPWgKSuYX312u64Sv2WvoJU2zifS84HTvBJxq4cPVHiPgf5oE74jDzXZzwuD/Oqe0qL5E5Q/tWmpcja+PvqvV7cgOkyuu9dkCDsTU+ArL+HcKl8znfbLVLN7llle3P0/VgHAbWY0dq2zcVr7kNllyYft8kT4H7WOE4MzfXpLincruO5xWKfBjklPqXgoovufOqfxlV2rahk/dDWBQoYF0W+KZLBfAPh4Q1mvcYg41NN6AFiOjA2/CGYdogCDnw1AUZ2blgqZW7rAr5fJ7XtLeV9RZLd1QMV57WRB7nUMdj0X93OK01QVS9Qy8z2VlVTuV9uiZQjd1I4R9zZ/rTTkO37LeU+hXMIPwvUVOMtIbYzVHYDBNLjuEbPZP1pd9VrGGVLP0goc1LvksBAzPUAQs3qsAmr9OlpO5XT1KPCrEJdYVmi6pK6dUx3iVeU41TQ9Io/4/
 /r3gNcOs
 7Es0K9D3Qo4/SrtoFVDQNqbg6AgfV/cuEqperHjc8K//EFzuyyTnhPme8MSYP9R6XczsLNSGt43eMl1CN0t3TxtVWWTiPcqAEEvgDjBblXXHK46sr8isFIA8sxSSTfCPj788J4AxqDsiAY/6PwO5o52KDmDXaMDQB4qXge5FhrcbS/R5BzX3OUcEv/yZjsW2P5JGZkL/Myc2j+YEalGoN+Fex7aTjrmcD9Vjemsy97YGSoMQzY2T/YOPy8M3u6ShEw7HoPqVOi+VWVF/GVfu+7gcGYBmjoXP1ShwzN+1rP7ycUXdmN8f2PPFmzkyHp9WBDqr5fIaCV509nu29Xw+bde2tGKEKnyWjZDFYq1umgRmqMxCARTlmGtFWTCoK49TLN/4qq8ebmQh2+00=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/4/26 18:12, David Hildenbrand (arm) wrote:
> On 2/4/26 13:49, 是参差 wrote:
>> Hi,
>> I’m reporting a reproducible WARNING triggered in the hwpoison / 
>> memory_failure path when injecting a hardware-poison event via 
>> madvise(MADV_HWPOISON).
>>
>> The warning is triggered by a syzkaller C reproducer that:
>> maps a file-backed region with MAP_FIXED, touches related VMAs, and then
>> calls madvise() with MADV_HWPOISON over a large range.
>> The kernel reports a VM_WARN_ON_ONCE_FOLIO(1) from 
>> memory_failure() and points to include/linux/huge_mm.h:635, suggesting 
>> an unexpected folio/page state encountered while handling a poisoned 
>> compound/huge folio.
>>
>> The target page appears to be a compound head page (order:3) already 
>> marked hwpoison. memory_failure() seems to reach a branch that 
>> unconditionally warns (VM_WARN_ON_ONCE_FOLIO(1) at include/linux/ 
>> huge_mm.h:635), which usually indicates an “unreachable”/unexpected 
>> folio type or state transition in the huge/compound folio handling 
>> logic during hwpoison processing.
>>
>> This looks like a kernel-side invariant violation rather than a pure 
>> userspace misuse, since the warning is emitted from an unconditional 
>> VM_WARN_ON_ONCE_FOLIO(1) site.
>>
>> Reproducer:
>> C reproducer: https://pastebin.com/raw/UxennX2B
>> console output: https://pastebin.com/raw/wrhKRwZY
>> kernel config: https://pastebin.com/raw/dP93yBLn
>>
>> Kernel:
>>
>> HEAD commit: 63804fed149a6750ffd28610c5c1c98cce6bd377
>>
>>   git tree: torvalds/linux
>>
>> kernel version: 6.19.0-rc7  (QEMU Ubuntu 24.10)
> 
> @Zi Yan, this is weird.
> 
> We run into the VM_WARN_ON_ONCE_FOLIO(1, folio); in min_order_for_split(),
> which is only active with !CONFIG_TRANSPARENT_HUGEPAGE.
> 
> But how do we get a large folio in that case? folio_test_large(folio) 
> succeeded.
> 
> I think we rules out hugetlb before in that function.
> 
> 
> Looking into the full console output, this is an order-3 folio (fully 
> mapped).
> 
> How do we end up with a large folio here? I am only aware of that 
> happening when something would
> allocate an order-3 compound page (not a folio) and map it into the page 
> tables. Yes, that
> is nasty and can still happen, not sure yet though whether that is 
> really what the reproducer
> triggers.

Looking again,

mapping:0000000000000000 index:0xffff88800fe2e600

At least mapping==0 could indicate a non-folio thing.

-- 
Cheers,

David

