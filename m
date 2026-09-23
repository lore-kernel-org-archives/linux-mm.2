Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2CF2C982FA
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 10:13:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A35706B008A; Wed, 23 Sep 2026 06:13:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0D0E6B008C; Wed, 23 Sep 2026 06:13:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FC366B009B; Wed, 23 Sep 2026 06:13:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7515A6B008A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 06:13:50 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E5C7F140755
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:13:49 +0000 (UTC)
X-FDA: 85244615778.08.D826A00
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 0EA5A14000E
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 10:13:47 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPhKOaCv;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790158428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PREKX6Wfx3ocgL0Q8g3oQ27X39xtDWzJRCtGGTbSjy4=;
	b=hl+OzpiPe1GqL6tO75iAzfqPIxes8fXY3egm3Oo05sAG9x+qi9P+W+cpPpiyJ4AIhsEklN
	TLikKAZP54FCr+zE6yP1SC50C8WVavtOFIN0SC/IGHPVbEdKq7r2PfNjW4usRHCaEmPIMi
	e3h3Fr+cCMC+FwUm9Sw+CJqj+Lvfdho=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HPhKOaCv;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790158428;
	b=1c65d3UTa9nspUPbc1d3ZGJ0McqpOm9+by+ILEvxsEd6lHIjWcb0gTK1uJIisgtCJJ2gsl
	nGiK29chT42ZwEthE/5m3aNLk2uCFll053HInom9Br38NyZgn7cDhtBFobSKmyy/7II8YK
	x9EjJtg3QUu2DzRd7pO79n48HLBtjfo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F07B41B29;
	Wed, 23 Sep 2026 10:13:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 382301F00893;
	Wed, 23 Sep 2026 10:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790158427;
	bh=PREKX6Wfx3ocgL0Q8g3oQ27X39xtDWzJRCtGGTbSjy4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HPhKOaCvWCzYSlAAHvGPirT13fNYuHIJ2LWzRria8HssijiCd0iFrRZLIukuZ3FU1
	 EGZe1X5rXLmLUkikEjc4K5RoUaBZoClgb2pTgfTI4HJ7jt7TaQzMKZ0gNMpD5x6xtx
	 ZEfxcZsObvhR1V4IjHTAbT4cwCLbgsl9rQi6pqQW9kbO6lwtyacD7aVdFbNcpHH0JA
	 df0thB5tKOtukXu8mCV2+Ivf+pVKMQf63PYEMuBByA8zBHaG7/xL49PfU+OhTZsU7d
	 cT1ObMow7SOsSVrurB0qxnQ+lPfHkTK8LIhgWSx115Hb9ZGAmbrHzzHcEOrKmN0FC6
	 J9QiqSXszvWXA==
Message-ID: <5271866c-a334-453b-a95c-8bfbede1232b@kernel.org>
Date: Wed, 23 Sep 2026 12:13:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] hibernate: handle potential errors in
 hibernate_{map,unmap}_page()
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
 Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260917-hibernation-v1-0-7f7dfae3dbe0@kernel.org>
 <20260917-hibernation-v1-3-7f7dfae3dbe0@kernel.org>
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
In-Reply-To: <20260917-hibernation-v1-3-7f7dfae3dbe0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hb833ckd8ts1q5nnznn49mgudxu5gpds
X-Rspamd-Queue-Id: 0EA5A14000E
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790158427-598476
X-HE-Meta: U2FsdGVkX1+lXX97EdB7N7R0PaFw9HFQP9ZfQao4EVjNuFxoU4xl5FeZ9pam9LqMnb7xAfclmlUoyQzJg/xlJSCROrxIfVnFl7NO10E7gL7bcz5bucpsVjWlopeX3/XjCJhbX4McOSGd2bP7vfTZBpdNiclOYylC42Sjz+8di2GZZcYK3eL0tBO0LJzcwI0CVq9gmXQhlZiJ5DrPXmdWoTrxcV5wkEc2dFM37NNcUewoK5ND39bOXhy1khM1y4qSbzn7t8vU4YR+PcBZx74NB/bgV6KzypB6OduP16fNT1ZnWo0KwVMPwdI79i93Lxnd5XAOqdZ27gplTQiBD4DdNLW7JY8q4iNAjW18bWbYX9JRDlKWxNKXU2SEq26Dg8FieCEnLmXYDrtHvs4iEYUvH3SPF9KjzvgsG7Ks8PpYXxm3wO4N2H7RJ9/2hXRQxy5RkcXjL++jaDVTaD7VrUMchVIXaav6vAyE8X4tC0y0GhHOL5UDG8h7VTygpV9icL64vVEedn/Cjtp0EbW3HwFFsHHBj64st3h6kuuDaPHc09efR2IjCM6bcdAhSP+XxVJxpDWlJiGFjBW4svZGdSZYq14fil2aTWOKzYbzfTTIdhBf4oo9KCxWGNAdDF15KpA/A5wMKCpaKaAjp0Ibx7OK/UIcHybegEG+ZZDyIdmuW9Rrza3AsBuEiJXNJKmZbihhUnwrdiqII/ezSxbAOCGnZtNq6Y/+jBrFpTgO+CYXxQGpue8sLIrPQehvN6lzks3vA8QDbnh8kiZ0iyv2q3J0wyPHCFm/i61RDEQ8RmVHel5nG5QhbO6ua8WGjeUcAtfo6NvAAb+UI1O/NKWmq6/mHOTgIZQS+MShLulBFsmb5INUUvVHqiN0vCE7MwjjvqE4Bz8IxSM8hfvKtCO6U4A+qCFKzg3dsJKiKtEq6h7N+WDVFomYylpU5YsMzFiynWbqXkM1AjKR27CONmlsZqD
 WYv4BcoQ
 F5N3OKjTYYr0Txt2Xfld43VklnM7gsu5BisfGEcuiV6vpmpdHs1sJrAZz/YMHGWloEUNWOdVUXO3JD8muEhynm0gU1POyhk37958slZpd1hUh027yFMsYN6nyklxWI2LBWwOCuAyVMIHeMp+W6kEsJwGN5IsGosEDE2Jp4QyPZj0Qvm++ikNo83m6Ad6cenkLf0z/3ABzxtwLxvFIzLEldtyhrtskfQz/pLDVVnqWxwHMnwpugkr8KpPfWx9ebSrcdazYKMMMD0iCzCkVCyuZUlCvWKW3h7eQo3mbuBFcX/9wMbpi/pNno7K3qA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/17/26 08:07, Mike Rapoport (Microsoft) wrote:
> When safe_copy_page() had to map/unmap pages only because of
> debug_pagealloc() there could be no errors in the kernel page table
> updates.
> 
> However, with the increasing desire to remove pages from the direct map
> this assumption becomes a real stretch.

What's our general direction in that regard?

I'd assume we'd not want to modify the directmap from hibernation code and
simply fail instead if we encounter that scenario.

-- 
Cheers,

David

