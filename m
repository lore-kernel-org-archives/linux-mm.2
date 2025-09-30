Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07429CAC5B8
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 07:36:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 662018E000B; Tue, 30 Sep 2025 03:36:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 612B88E0002; Tue, 30 Sep 2025 03:36:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54FBA8E000B; Tue, 30 Sep 2025 03:36:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4368B8E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 03:36:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DA38E1405E5
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:36:46 +0000 (UTC)
X-FDA: 83945109612.17.9D8A74E
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0E0B614000D
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 07:36:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I7LfKX44;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759217805;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMbO9Tlys5llPIB/GKS5R/+Lw3U9d4/u9TV/lNk2GF8=;
	b=qRx5pj5GKBXUvUXcd9saSjGLeQop+G20B2Wk+AugODHbyG+sE6ftyvM/nViuDVMSmmIZGz
	F27R5N8EfeDqC79Up4PhHIRN60IvaJXihj/8WRSBT4C/8+2Fy+AkNOq5l1RB3L+Jo+CneF
	LQSUwo7YXoWlIIK2F38e6WnqIQrNJ4g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759217805; a=rsa-sha256;
	cv=none;
	b=1LZdy7gHEPMe/oqTdXvkkAVjXHtVrGI5FNv434jp1Kr4Mdo9gDjtjlND4xNq5KzxceHkYh
	7VLPuzuNeOMjeYhjLmTEqZ+Jf+GMLrnOjuHGM5zMopnWb+OzTi0arXv0MUVLQJBBkdiDba
	BJFFoUgaI/VJ6TCD+OisOOOBM7+HvHU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I7LfKX44;
	spf=pass (imf26.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <556e072d-6bec-421a-a78c-fcde61af67f9@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759217803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nMbO9Tlys5llPIB/GKS5R/+Lw3U9d4/u9TV/lNk2GF8=;
	b=I7LfKX44os0xFnVKDz31DNnBjFvIrbnjN2gggYFuKyx1SoGR9d/Xs/QWF4i1I8nA2V5RWl
	W85GgcOtwqUi+YQglSgCu2t2Q0M0gzq8vFreEoFROs6WgbEcu960J7PO4AXZWGr9y45Q5H
	DN77mofyd0GxSn0DtEEpDiyjEUy/2X4=
Date: Tue, 30 Sep 2025 15:36:36 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 1/1] mm/ksm: fix spurious soft-dirty bit on zero-filled
 page merging
Content-Language: en-US
To: David Hildenbrand <david@redhat.com>
Cc: xu.xin16@zte.com.cn, chengming.zhou@linux.dev, ran.xiaokai@zte.com.cn,
 yang.yang29@zte.com.cn, linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 ioworker0@gmail.com, akpm@linux-foundation.org
References: <20250928045207.78546-1-lance.yang@linux.dev>
 <e74ae9da-9dfb-4673-ae9f-c0b27b796cf0@redhat.com>
 <8476e9be-3f80-4d7a-9a38-f910661e61c6@linux.dev>
 <02c8cf41-116d-46ab-9d40-803cc26dbbf8@redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <02c8cf41-116d-46ab-9d40-803cc26dbbf8@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E0B614000D
X-Stat-Signature: gdsizp7ck4fzfjyjx1h5gq9useabyfpy
X-Rspam-User: 
X-HE-Tag: 1759217804-676305
X-HE-Meta: U2FsdGVkX19cb90pjdgQc87pfXLs5XP/awizk2W+Byr1smPOaWHd+o0f3cBhLoYjJK16IpKCGtj5KR0RAhhF9ypVOt+ww30/aPf6b3VQo7eLY9OaEtXxJ1TrfpkZhBLDoSHMG1pKOOTpnsUVyhhuf6yN4WE2mg6XxON1GjU3ZVixpHDOXsWiQubQ9K29X4m84JlR4mYRGkHP0ehK6d0AbjzB+Cv1n43iFzBS5i+/56i+GjbLxl5q3NFhfMRi5BjwnYR7nNeq5P/kMzLF4zPAPcHl3YtxW46sVmUwNEaYXVtd5cS4E7TmxkhsrPpiZmV2G1yrMXbRz3MzjpW+D+WhKttSw0UEkulLeyDsa+SRFiHZteWTyMkzcH/4P6GVimPQhs0uRF8eaqUBDfbE3pz1ugWdDs1HucMZzJnbFrM18j5eW5OUDMu8fVMv586U1Np2ifazknNJ8p51sGFZdLDjY/Ni8BmoPJWUBFo9gNhxOpxD6i0Mv8sEQqCXdV/Zbpng5tx5uSCBoJacxSl/qSOZbbieWtxu8bndhch3F6spEi4jaNXXq1ukHuZ9exA/fFzPLjV0QHbTpQVX44GT6yAXxWiXAttxO6XkHEzfH0hTLASdEAwnmd0fAuLM4jklum5ByuKW17dtVQAGyumKvKaEdcxle8eGc7QZGdr96TatBecl/TiaEh1mmyOc86IE9Dkwo7t42RtWfk/7/yWEQsUxUyaoyZLyXbDt/wdRLhaBebdnp6j6JUy9J2LS+gH6mS2+uRFLQOksebCf9W83o9ltP7yDGgIxCVSrh2hDBhZNiLzEHWVLx9idL/Pvj+myWgIYpwCGYMq4zigHr1CR9leyr3J8PYCTZZlR2Ee1UW9iSGJzN0/Vs1MNZW+UO6gI2nbXBA9vjtw0aR9vEmXUDi/pNRGasYq0DepoheWzska19AvhZnoQEMTIWvNvJZT7eBwj3VZPU/f1OTUZ9gtM9a7
 v+qqLLg0
 qPruVKmYsgP7peYzxMf9yAfqbb/jT+ZNCe++oR4vutREOIS4L8tJ0SlS8kaEhDHXWdKSgiBTc03gel8W1UUMpvHWXSU4KekY9IDmFiMzigaaUknc0WJn+RbazIapAIMi3jQfx0HfxJ60KGo0h4VGnnnLgOJJ/DqdQX6ivc8k6rkeND8obpGjOPYWGi5E3tvHER/x6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/30 15:32, David Hildenbrand wrote:
> On 29.09.25 12:08, Lance Yang wrote:
>>
>>
>> On 2025/9/29 16:25, David Hildenbrand wrote:
>>> On 28.09.25 06:52, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> When KSM merges a zero-filled page with the shared zeropage, it uses
>>>> pte_mkdirty() to mark the new PTE for internal accounting. However,
>>>> pte_mkdirty() unconditionally sets both the hardware dirty bit and the
>>>> soft-dirty bit.
>>>>
>>>
>>> Right, that's one think we should clean up at one point.
>>
>> Got it. I’ll take a look when I get a chance ;)
>>
>>>
>>>> This behavior causes false positives in userspace tools like CRIU that
>>>> rely on the soft-dirty mechanism for tracking memory changes.
>>>
>>> IIRC, false positives are not a problem. We get them all of the time
>>> when merging VMAs etc.
>>
>> Right, Indeed.
>>
>>> So I am not sure if this here is really worth fixing. Soft-dirty is not,
>>> and never will be false-positive free.
>>
>> Makes sense to me. It doesn’t seem worth the trouble to fix. Let’s go
>> ahead and drop it.
> 
> Yeah, I would prefer if we can just decouple soft-dirty from dirty 
> handling at some point. I recall I had a use case around 
> PageAnonExclusive at some point.

Cool. I'll give it a try ;)


