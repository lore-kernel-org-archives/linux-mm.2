Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68BCBF8FA7A
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 13:40:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E086B0093; Tue, 21 Apr 2026 09:40:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D14816B0095; Tue, 21 Apr 2026 09:40:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C2AF86B0096; Tue, 21 Apr 2026 09:40:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B050B6B0093
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:40:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3DF3A5C6E2
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:40:32 +0000 (UTC)
X-FDA: 84682672704.28.9385F1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 815CD1C0005
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 13:40:30 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwGD1I5G;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776778830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eikW16p/Uj32kziMU+STA1h1pl5h/fgSEDT7WNg7Rvs=;
	b=M8hV0It49SjZflUrbu8cLIG7rJmdFXzwAxjvH+2HV44EcHDy6Cc16H7fWY11bZ7HASm8c0
	ZdQXte2e/GGAJoeGBLLP9euxk4aSD+X8hGWZl21O3MCCOaWsV2pBzzJaGJ1vwfsODL+BVW
	L54GJ43ILJUwELDUOGtWEJsqKFnKaKA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SwGD1I5G;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776778830; a=rsa-sha256;
	cv=none;
	b=oFQhZbhivHORJI7sM5BggC6pDD2LWvIK2pqrxePZmtHedo/oW5Lyy3LEsxePOFVfuhMx94
	+5qlKw1ykTYMmOxuVuUJDlS0olksCdYv3hCQob9UOinOlTrHvqhyDfpNz8sPseCmMfjnuj
	g6/RkJFMDdSoNlb/hSnyvOqfV+UnY58=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E83E360125;
	Tue, 21 Apr 2026 13:40:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B923C2BCB9;
	Tue, 21 Apr 2026 13:40:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776778829;
	bh=/DfHPhmirXGOiPUArQx2j0SHUooHOmgUasHwD1et40w=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SwGD1I5GwtCgZMCgwmFmfSH4TqkBE+rzAnoMt0JqEPrieoZy7+4lU04RaSvWq+h2s
	 7cuxNuM4DnRkVRPtRJbWexnFVcQVl6A36XCtu9Tvh7HUNY0gQaAdrT4BkSMONrbTGx
	 jtz/KuT0ULA/JvtoFINgV9HOPDZGzExTwsxflT9ydHeoHOyyeD5EMPaHFmXQ3tKx3c
	 hD2XXZc5E9CE2NWjkqbRIuhf324omEb4epS/tKwA1iFrR2K/uWjMaSGX9HxSZTAw6P
	 XPaWqKUeM3Wodod+LEbE8TtSRYxsLtVlXEn4VbUPu/Ly7oALBWtPTR8URVs9qe8Isv
	 oV6TGvjoT7m7g==
Message-ID: <13d881b2-debb-46e7-90b5-9b3e8a4275d1@kernel.org>
Date: Tue, 21 Apr 2026 15:40:22 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/sparse: Fix race on mem_section->usage in pfn walkers
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Charan Teja Kalla <quic_charante@quicinc.com>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
References: <20260415022326.53218-1-songmuchun@bytedance.com>
 <09d1ef13-e02b-41e9-b431-4c3254e42011@kernel.org>
 <B139F2C1-77CB-43A5-8377-4F4BD44ADC6C@linux.dev>
 <76cec69e-6ee1-4630-847b-80dc1e49d643@kernel.org>
 <FBD66BD2-79E6-4CBB-BBCA-8E8CB7DEB6CF@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <FBD66BD2-79E6-4CBB-BBCA-8E8CB7DEB6CF@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 8sfqqsmhjy8kenfyjwxadmwwmbzs1b5o
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 815CD1C0005
X-HE-Tag: 1776778830-891852
X-HE-Meta: U2FsdGVkX1/4RaXGf25EIUq3+YIxQWWLxpIAv7Mq7CEikSVjQmIZ9DcEoliXr3DrQ47rG4rUNrQGNPGd0DhJcwnrPVtB9Dg/fHJKTLUcoyo9BDzGtB+0UCCsZPWu2psNtloT+U4mf6rKrV6hyfNBeIRhmHhqk8qnWxkeYuLGhSCqqNGMY+kYpOLLP+wq+2mBtqpzjY/impaqy5fbKI+NaO55ukFdjJkopfIdX2q/nT/OyQ131Gsu80ylkfAYP+PEGnhAT5b1+Dkvlf4uZOnHh70u4HuPr4F+2Bu6btyav+1AiRq3sgMFGU3D/MLCev5/U3QZbSzNeiHXcRODsTARgVCLHnzFQjuSdgbQEMctnNN9IgLIsESUZGnXFzLxADiZ7iFIuryKzP34HEQ7XbZv3+mjQCJecsO7UOuW3XrNI1DKn4B2sWeYXgEyQNEC1tnKpFU6J+MszECdEGnN9gJyssf7ae7KvrAL/hOc/g3oTP1iCcAi7ohvZRvwPnRi+uDXU9g5bpgnE+aa9Y0j2M5wCmhDIrHB2/vsM/KOTF/RY+HiGeOGDN3EPvjGVV5l3h599aPkAN23bcCKvfOHHZH9wQYCH+L8mfzxNwm81OrpHmygDlOfFXKIqm8+kPcD4/gWGjDryGm0F8kLy2eMDRIO6ZBBSwmF+Tl9v+5oGaTRIWomd7ONtTTIj253HcrVyzdOX/g8slvQYCR3+mLUGYZ6lRJYTU8YQgjXNY0HuipsSt3+nMYnbLl6eJxCmfByN0ABek0Yv8IR8ChletHVDnJ3j2bRNmUWZUhE5yRU6MxqMUq+IrM1wNPVrma5S25NbB1KKkj34BGfKuqF9KRCZI4q8oMzoMPPBCnNqJHNVrELqyv66fvJLhIy9rIpHDpdmAkGAweUpCvDzkkhsT8DAkxS/a+n27WiSpD9dwx1zFLwKM0lR/W9PFQdg3upi1mfgiO3M4/xjbn7Sv3dlG5mpwz
 p5uqblBS
 GwNfW5SfQ5CQboWCOfXRBx2+OiYWZjZCnJNcJM2NSYl28dOtWe6xGtPO11gxkyHIowu3WjcStRKCd3YNt2tVYHLWS0R4vt3+hq8WbKoC2uxoPFGq6F1bmlpc9bz0KnJ+rF3Yk+Zp0m3LVCgc5kD90xATRnICLWUeD7EYLp9M+h8gBtaNW2oiPjvR/2VXLhkQdP3YnS6xtZQn+CfwHIGzoSh7dHRY9xsD0Sw28Pt3ThzZuyem9vxM8oI3kMkRGqrrDjfVVTpPPceYOr21zgrgvUcrxFJQU+9wDG0lJ0p2LBAYpTjqzmj5tA5h49ZJay/A3WP0GLM+R0snsgzc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/21/26 14:55, Muchun Song wrote:
> 
> 
>> On Apr 21, 2026, at 19:21, David Hildenbrand (Arm) <david@kernel.org> wrote:
>>
>> On 4/15/26 11:20, Muchun Song wrote:
>>>
>>>
>>>
>>> Agree. When I first saw the commit message for 5ec8e8ea8b77, I was curious
>>> because the goal of this commit was to fix an access issue with ms->usage.
>>> Looking at the race diagram, I realized that while this only addresses the
>>> ->usage access, subsequent accesses to struct page will still be problematic.
>>> It's just that the former issue happened to be triggered first in this specific
>>> commit.
>>>
>>>
>>> Glad to know my analysis wasn't off! It seems I've just stumbled upon a
>>> 'well-known secret' within the community. :)
>>
>> Heh, yes.
>>
>>>
>>>
>>> I am not sure if it is worth fixing, especially since I just realized the
>>> community has been aware of this issue for many years. If we do decide to
>>> fix it, I think the most straightforward approach would be to protect it
>>> using RCU, something like:
>>>
>>> 	# the user side of pfn_to_online_page():
>>> 	rcu_read_lock(); 
>>> 	page = pfn_to_online_page();
>>> 	if (!get_page_unless_zero(page))
>>>    		goto out_unlock;
>>> 	rcu_read_unlock();
>>
>>
>> Right, but we'd have to protect against the sections being marked as
>> offline as well here, though. So against a pure concurrent offline_pages().
> 
> Right.
> 
>>
>> If you're looking for a project, this is really one worth doing! :)
>>
> 
> Initially, I wasn't sure if this issue was worth fixing, but it seems
> we are moving in the right direction. I'll give it some more thought
> in my spare time.

The kernel would definitely be a better place if pfn_to_online_page()
could no longer race with concurrent memory offlining+hotunplug. :)

-- 
Cheers,

David

