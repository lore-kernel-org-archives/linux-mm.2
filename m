Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0B4CCD98D2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 21:28:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 90AE26B00A3; Tue, 16 Jun 2026 17:28:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E2956B00A4; Tue, 16 Jun 2026 17:28:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D02F6B00A7; Tue, 16 Jun 2026 17:28:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4BB296B00A3
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 17:28:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4EA9D12015E
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:32:35 +0000 (UTC)
X-FDA: 84886167870.09.DD6EA66
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6ABA51C0003
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 15:32:33 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQl9OuSl;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781623953;
	b=6zDptpS1LMltcZZ3JZDK+GL49JnBhMd5Iy1CgiVqNiG73JMYa1KhZF4lRU+cKiDBb3YNIb
	h5WqUNbn60OZCSLlj2x3rx8Sx9fxCKPdw70YBX3XLQz03SrMSoTsgsqbKyRjhECcWxm4KE
	jZanSJ8M8XujK5mrVlvpMznMCNwqCaI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XQl9OuSl;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781623953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AGo8r3BkY6DeVzxrtsmPgLNvPJ5SlKgHNyOuJikhf2Q=;
	b=PVTnaBxQb3UwdXzuJbUWVYDQ8MuzkP8Ck0EHrI9IrTCk1KNgzD1sVMXSRtCqjQXteH/oRP
	odlB3MG5PHizo6EtcoPZpkAO74USpdKeb9bvSsCaMNqftaQ7U5vnhraXoekMx5sze1Q8HO
	Iuvt32C/jHcVijfGRpYArXg91OFUO/g=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C2851600AB;
	Tue, 16 Jun 2026 15:32:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395E41F000E9;
	Tue, 16 Jun 2026 15:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781623950;
	bh=AGo8r3BkY6DeVzxrtsmPgLNvPJ5SlKgHNyOuJikhf2Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XQl9OuSlMrEyGtDl5pvUamOsvh7LxrccFQL0/Izk51u+XHUACGSl9ChFXQN5itm4f
	 u4LzXxoHK+QJABYkNwLCqNte5IyaMQquY6lUI3rUtkI/Ji6JORnPc9563nfwMG1NSU
	 6+vkkDjRKOqa1BO9csiO1lGchrr/xa65SHx/WEA+T8IlYnsT7vlUrKI8AkD/mfrsAF
	 exIv408tFBtdUeejymGFIuqcoOteL3psU95EgvUUo+4ZrtWJwgHpTdbu2kR6iOKveB
	 sRH5PRFvezCZoVW/cPO7It5tM6xtAOOQy6i4Y+gL6fhSTU2WCGOMSDoSeq8GTgAkOl
	 wUDR4SmYrLRkQ==
Message-ID: <a56cd054-acb7-4386-9f22-816f82e55e82@kernel.org>
Date: Tue, 16 Jun 2026 17:32:24 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8 01/24] mm: Introduce kpkeys
To: Kevin Brodsky <kevin.brodsky@arm.com>, Linus Walleij <linusw@kernel.org>
Cc: linux-hardening@vger.kernel.org, Andrew Morton
 <akpm@linux-foundation.org>, Andy Lutomirski <luto@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Dave Hansen <dave.hansen@linux.intel.com>, Ira Weiny <ira.weiny@intel.com>,
 Jann Horn <jannh@google.com>, Jeff Xu <jeffxu@chromium.org>,
 Joey Gouly <joey.gouly@arm.com>, Kees Cook <kees@kernel.org>,
 Marc Zyngier <maz@kernel.org>, Mark Brown <broonie@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Maxwell Bland <mbland@motorola.com>,
 "Mike Rapoport (IBM)" <rppt@kernel.org>,
 Peter Zijlstra <peterz@infradead.org>,
 Pierre Langlois <pierre.langlois@arm.com>,
 Quentin Perret <qperret@google.com>,
 Rick Edgecombe <rick.p.edgecombe@intel.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>,
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>,
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, x86@kernel.org, Lorenzo Stoakes <ljs@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>
References: <20260526-kpkeys-v8-0-eaaacdacc67c@arm.com>
 <20260526-kpkeys-v8-1-eaaacdacc67c@arm.com>
 <CAD++jLnURXzgAgkWCcYX0dLOLqHQw+gn96V1dzDa_0Aoi3430Q@mail.gmail.com>
 <b4eb4ea8-f4d6-4be2-81b1-4a8a46abe94e@arm.com>
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
In-Reply-To: <b4eb4ea8-f4d6-4be2-81b1-4a8a46abe94e@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6ABA51C0003
X-Stat-Signature: 3ron4nnifhxg14j6kcjdsobn68g8we3y
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781623953-53153
X-HE-Meta: U2FsdGVkX1+M9XC5ZurcE0ooxf6MhuPUwRslMJeQIvQ0M4XcD5df5PiBgT3/AJtR+V3HyzURoRrSKBIL+SbYaILQvWD4xcLR89M39gSexxptoQVTBzZ1cHI5+dg6lLVWGdzG2842dewJvAiYQ4nat45He7Qk3Ha0V2igSreM6laYzcFPLWk9KLwpRMV66vQS/td5rDerKITnzzz2EqTEMrlJbBpsK/WaDrtCbcH09NGTQKGvE4lrfpJYIuFBP3koQFvjlZdBY9t3CQ+G+PMgZPgysKGNhMHrqUDj9ZO5Xu4VCS5YoMlFRcAS7sPBY+AOsjJDcKfFgqZgehWWwh8NtIx3UZGM9aCA9Bqh36aPegokHEPjbvW6OuKhDkaz0tWsdXvCIXb3Uf47YXJw7ZDp8fu7S3Fq+bdWTwN+KUe5qRIQIOGaXGS1qvSXaNY8JF/JxzeBt6LnKdk6QLZ+WnpjOKYJpkPeaSG8e2nzew9PFaUNUpaN9PNn7cQoucx/zRyHIQ6IgPdCC/B/9IFZ5ZLXNrK2kiu/wPDFEYuresO+X3uzBem+MEK99JaNwhCQ5N0RwqCJOJHTHXkp9WGPjxdHI099xz7JtZfXRbuecqnJh8LryxM8i/J0SlvQTW6Y3OSs2SMonTTA2X2LD8xFSn0VTvEF49TWIqSvCVLf/hn5H9GByqlBYKkyjmzqR8PZ7DJDPwWq931b7OD0ord+2wzYkVwIoh77CABzUe9rIgWf6+Cn9bW5eNaZr0GS6bqh7tICkdqqoayl+xKe33g7wtvFw/mDFs9GOPU10Rr2hIetpIYoo54PBqZ+uyxuDNQTgi4ICjK5NDTyLdJrLODNhkokB4HR2r8ujMVaM0qsAeeJopduqvVWAecVUAXO/7+vGAGldNg0XZO6x8Toj2T263CyO5WAcDiTonHiBZsbWKV1OhIrK2AusZbSdlB3ZflFNx9uRiP2RTAiyT8LqkW8sYi
 JONkRww7
 OcN1YcMooTZ6jTgWP9kyXI0EtNzEEQ87TzJCXXWCnR7qCLH+dvlaDCu1X2N0vUEOBWSLqtF2+iIyKBzJlBSgOHnNShsbBFFZoved4BGMgVP3B+GF/vZdCo51XzeIRoAX94qrbnWAmz8m5MO+x8ZSYtL9hOcsVUwltR0fsoZcqn0AP7ANjqKhXyCWU0cugDGBfkt3HuEx9mSuupp3W+zxDs+cT/tsZKBR9Qvd7ANZvfJYuNuJw/4yBq47tWSBx4MmZaFiYUtEmAVh857PTn/7rliJRYzdGuPvYKMHl
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>> +static __always_inline u64 kpkeys_set_context(int ctx)
>> Should ctx be unsigned here? I'm nor sure what a negativ context
>> would mean.
>> kpkeys_set_context(unsigned int ctx)
> 
> That's a good point, now that we say "context" and not "level" an enum
> would be a better representation. I would directly use:
> 
>     u64 kpkeys_set_context(enum kpkeys_ctx ctx);
> 
> ... unless we really need another layer of abstraction.

Using an enum will also make it easier to just automatically update MIN and MAX
values. Although, arguably, you can just assume that MIN will always be 0.

enum kpkey_ctx {
    KPKEY_CTX_DEFAULT = 0,
    KPKEY_CTX_COUNT,
};

Then, just reject anything < 0 or >= KPKEY_CTX_COUNT.

-- 
Cheers,

David

