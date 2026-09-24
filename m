Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01B58C98310
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 08:16:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 199286B008A; Thu, 24 Sep 2026 04:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14A746B008C; Thu, 24 Sep 2026 04:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05FF06B0092; Thu, 24 Sep 2026 04:16:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D52C06B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 04:16:52 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9318A120235
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:16:51 +0000 (UTC)
X-FDA: 85247949822.01.CCA0B30
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id E037B160004
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 08:16:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ntwTH3MF;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790237809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GlkUeK+CoI4sX/1Kb/GGrPydzXNfACW/Fk6fPi/2geQ=;
	b=Yy1e91ZS8t7AIyAFxl8zZ+v6L9TcBDC7R5PwE1DngqtegSlYuCH9pGI/bHpg80c4VvontA
	qmEk/rUZek+xzEhHAAvQNrRfZAfTb6RmgeGE8wMlSLeOdGkRuYDF0UROAgqVAxCD+y8DRi
	4ir78oWE0MXbeGA47KttsAfh3iGiosw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ntwTH3MF;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790237809;
	b=aLY32ftKKlpYTWvy/hiYktSYBsD1q+DU8YlvHah7SJ0EdDVS3tVdtvgU5h6hkpl5Yw4T1U
	hIYfFq2PR+lnpOZQHGbl8R7A/1qqDmE1iZIlRmJGhaHfQbpfxi/f3U5g+Do0Z999ko8r7J
	WICiFeMLcumFP40lT6rxtsET5WJkOgI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 330DE601FF;
	Thu, 24 Sep 2026 08:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D4081F00893;
	Thu, 24 Sep 2026 08:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790237808;
	bh=GlkUeK+CoI4sX/1Kb/GGrPydzXNfACW/Fk6fPi/2geQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ntwTH3MFC1AqMSiVALyjvMdSqJhNw+QehUMFv8ChNY3nUEPoeQRCQqWQEYYGguK+q
	 3RgCJtdywgJapljiYq1Mey4P8axQtGGQdgSxrIn61KlKS3GAjqIgEFHE3hskBKgaXE
	 zj82bUfAQ2PvnnrgeT/1qcwEYmzPsRF7hwfIm+Cq7eif1U1gsp2b9V4w6YEDdei1To
	 0PE222KjY0oceNBHyh8nMSdJUeMwlvbXXNvNeUrdRnqqaqsHc/YZMjvlJRHUbTjGEb
	 2AL2arEhpgB/BMoQ75pkMbmqwDN8UoIBr3D84WgVCD4cdkA917WVjA/Rm6RWtU6Zy3
	 ROazRS22MSxJQ==
Message-ID: <b3de63c9-32ea-471d-b2d6-0565d93313f3@kernel.org>
Date: Thu, 24 Sep 2026 10:16:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] hibernate: handle potential errors in
 hibernate_{map,unmap}_page()
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Dmitry Vyukov <dvyukov@google.com>,
 Len Brown <lenb@kernel.org>, Pavel Machek <pavel@kernel.org>,
 kasan-dev@googlegroups.com, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-3-7f7dfae3dbe0@kernel.org>
 <5271866c-a334-453b-a95c-8bfbede1232b@kernel.org>
 <arPzeJ7ZsdrXkzbF@kernel.org>
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
In-Reply-To: <arPzeJ7ZsdrXkzbF@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E037B160004
X-Stat-Signature: trk4mmnwnashzsf6pxfzi6u1bcpay8gr
X-Rspam-User: 
X-HE-Tag: 1790237809-559188
X-HE-Meta: U2FsdGVkX1+9y9g4iaGWMb/ZPWJN1GigqHrqIdtuxl5f2jmZPqo2tZcTHdfOtoULTSf9nKvxX3d0v2KczCNA6bbez9S9gkBWHc+V74J5w0TosOQGO0KE9VtGWSFlyYpGc07wF5Ugh5AYLxhDwpdGGCe22zJWTtQvG00ZskrGbApUq7sCIXiojCzseuZBS9wY+jqXegxPB6iERSE0vSlE56FqOumsVl7z+ZsFbBwCjA76JkHqfotkpsbYa8f87K88FEH876XOjEoNf+w5wcI5ADkVVvkEusRQyZZArca6MXC2KSynoXrN5m23CywGPvigHeu/RHigp26Y8DvpJS3ux1oMIcM1hAkCnHgVq+BAehz7cCSwrAIcV2YoT4joZUaHgK0K8uPdze4XcchtBAUsPHCHQH2we+wjca2mG2yIWir6XN6izHF6jmlb7msc+2rYvuD45JzwvGGlpLFy0qXqMOBNejCFQRDUfehvZZMseWCm22IFinRpNeLaTqytSob6rDTAcHy/2bq5Ue5jQsU1l13voE8ZSAdo+vzvm6plDfraQ/nvtFOyjqQVWCfZsNK+gAcLysBE6kwCSPzf7PxeE5EUoI70R6fpjJLaIu04wsGAea3MIL2kxFNWFjd2TmqjaTt9EtU3nGbgazEL1Wdve+Tarmh8uppdoeBmYvQ0ece+FjSl88VF9HWTPN+APbrQ3MmaRVgoGy0KXkOILe23fexwO+2BIwMuSqugWhabPJVXIqeIWLkVHzSVJxXVhnn0Ns8osY713A/XqK6IE7EpD95N+uQTBfLsfwND3z2yz4YOR0pQNb8TmXWC86BffXkB/DBj2f618jXVhkRi7AU2aszWEvj/N6za8pUmF3gM+R87rEzCuHzow8FVLxsFEP+lwtQuijXxOx9I1IoTQi8SRQn6Pke3fx96ZZ6QMwTag2jnT7BgCXVWnenkugktnN7s7cc0oa8zcFQxLLacEg+
 xJHh4VFE
 Rbw/0bg3kYBZHnuY92GR+CmezasbwV+DWtmoCderjz791mep2jJJ5Snh9giN+Kh0/YXSyQSsO2I1lA9gn5CMNdS/bCn5X6zLodJqgiUWVA/IBYILC34ZChtM2g68uY3iDgaTHkRUb9p73aidddeQ2mwefJuEtN8Bx674hwTggz1oeGA2gtQjju9RZPmBF08V/NRRCa2uz/L19sxKTEoVvZqmUVFC+NdjKSm/RY4vdlDE8aHodCWM8bNEX1IEkjAIQ8W60UgojgiHAZQ09O0Nob/w2wunqQTl0wtTB25GRUfHf3y8eUUE5EFyh2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/23/26 17:42, Mike Rapoport wrote:
> On Wed, Sep 23, 2026 at 12:13:39PM +0200, David Hildenbrand (Arm) wrote:
>> On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
>>> When safe_copy_page() had to map/unmap pages only because of
>>> debug_pagealloc() there could be no errors in the kernel page table
>>> updates.
>>>
>>> However, with the increasing desire to remove pages from the direct map
>>> this assumption becomes a real stretch.
>>
>> What's our general direction in that regard?
>>
>> I'd assume we'd not want to modify the directmap from hibernation code and
>> simply fail instead if we encounter that scenario.
> 
> First I want hibernation to only touch the memory that we know is safe to
> remap, for now it's only kfence (the next patch), so no arbitrary direct
> map changes there.
> 
> And if remapping fails, my take is that we should abort the hibernation.

Yes, agreed. Only handle known users and leave anything else just aborting
hibernation.

-- 
Cheers,

David

