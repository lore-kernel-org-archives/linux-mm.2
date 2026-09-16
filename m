Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AFDAC88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:54:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7DDB6B0088; Wed, 16 Sep 2026 06:54:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E27C06B008C; Wed, 16 Sep 2026 06:54:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D1AC46B0092; Wed, 16 Sep 2026 06:54:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A91BC6B0088
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:54:04 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 222E5C060D
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:54:04 +0000 (UTC)
X-FDA: 85219315608.07.CA3AE74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5C84C1C0004
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:54:02 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bSUpKngB;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789556042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K8sT3qjJgiYU41deN4p7Wl5xM6q6ADoh7h6pB9tDP0M=;
	b=4rK7urO9K56Yi+zoywp902dfC+/uzgUhdsnj774GY4PN5Cax4rlzBuWu4OGQXABlSlDV5m
	GS3Z3RIR7I0wnNB+/sJo7NjdnN8bARJXlqIyZBZW7oac+pz2kUnW7uLgHiD4X3ZasBGvz3
	flA8F1koO8vN9PIhXcKy3b+novZwDX4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bSUpKngB;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789556042;
	b=viCNrZtiYttL8h67KLEr8yQD05oDdsDq8Ok8btT7iufHB8oybfpdcSkpWl0aHU4SGE4GFW
	zNUL5BkNh2+jXRMeOHDxtFjvAMS99/Y00boMe1p49Z92QUKZODqgTwbdVjnGJumxHU/gyW
	9DvY87m90O529iqI/auRVEkq8iV5A5A=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8244841780;
	Wed, 16 Sep 2026 10:54:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E75651F000FF;
	Wed, 16 Sep 2026 10:53:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789556041;
	bh=K8sT3qjJgiYU41deN4p7Wl5xM6q6ADoh7h6pB9tDP0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=bSUpKngBu52G0CG8UQlTQFfbdTiEhxt4kuSWUaDB4z3r4fMrZH5qgTjYirquqN/Kz
	 5hVYfgVpU9YI32/BjQglTFoDEDl8MrHBwF362ZLSy3cIGdGtah9Y/PIzT6/LuxopqG
	 Cli/VuqBav0YEsey2gCTj/FxMhxHZ1mM6M+4ppEKXSozxCIf2J9R+kcMpX+0VYhpKe
	 nYkINUFpU7ryYS6pE6tVnB1rNTGDsJZm3ABWbDFhkZHOqwgshdRNLj3qbv6gBqTuux
	 rHrXbp6FInlycGD/QQC0s1Azyv7MFlIl5idEq0qit+lWvnQ6Nzi5KYd+JuxCAnG4nd
	 u89xAa8eGHM+w==
Message-ID: <27b6a4de-ddc1-4aed-bd30-f466c730d551@kernel.org>
Date: Wed, 16 Sep 2026 12:53:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5] mm/gup_test: safely calculate GUP batch size
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260915102524.125758-1-sarthak.sharma@arm.com>
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
In-Reply-To: <20260915102524.125758-1-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 7r7u6wrmnoctdjiec5qqzpumsjx76igb
X-Rspamd-Queue-Id: 5C84C1C0004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789556042-797133
X-HE-Meta: U2FsdGVkX18SHM56GSfR16JrUJ++4b2lAWJpzM3+0ushbGf5Vqe3xDpPJZY19Ll3mbbVCByyElpZyQ7ODMjq0yZgtFJXx/tRvUzL5OW/1Dr/lPF2v/TI9G55FKXDNKp5DRK+lfVrZfWyr1U47gIfsYjresAqD5m2tooBPavQI2LxztpqONdGSc11LOQ4rUQmmrvG2fnFxL/Opj5PwAwFy+RDr+2ui4XHUXwUcT+JZspWice1S/nbM8zxXDeZvUZdo5nPVp5lEqbzYNGId3nKeVR0+u0rTMTZpKMxZkK3RoPBbAoRq+SJ40N2Iw8PcvPKSQIkvs5m7XvLeUhuFBQjM4efJBLcD3fhA78qqMcYmtnSO8jykJzJT5MHzOSVnXRuMMlk2yza6jmyRRFpbiLjnwTXsny3khOh7CcmlsjG7eF1XslxxjbHPxQQ+Bpyl6+cKa5G4qZTFdxi1CNU0kKCQpTPTM7th/h/lj6u+1ai4VsoFq58jvLxcyjoa/cBb6AHMppdmeFqiGH/p5C1BNJZG66SO4ExOqDPWPT8EtBGi5G0iis5GKOAWzDGXUPyHASfV0nR+z0xa7G2v8SWwXH2exfX0S7hLScKVKOfV3eXtWG5U35QMUFHq431F8cNnHDvla8fMQ3y0Z3NgaFO8U8sZO7g/+Vm/gadS4Dm6KfKLtZ5HP44yOCnNnmjnAZCQJcJRoSO9d92SHgwlFgrf6P5tMtFO4NVzkD7PISm2YzH+MqpgimxUXicGWFCQNqKexhI0kBB/JJbcGQwMs+5Od+R++84JlTsr1y3HTxvBLqPNSJ2PTcc8kFDu64iQGW6sGrj8QqTBpDWs4PC0JbBGIY3MO4mG1NwXb8DwsaEbMgDH/jOPKUysebMuF2w5HAc6Figk7hwapnRGEq/KzJQvLT71DBimtU5V70/EoJeoewxuu/HmDEOZ1xjYArojoAQauuUUVe6vvRPL//7b0KIKVs
 WB8P2jNJ
 JWO/icnu8XZcHlI+CkmOfOcULxLpU1nusMrkgb0i3JPoDrh2aoL0Cm64G01o7M0ccF6i7+NjfhoUhNulRwo0yf5K9UVgQoIO7F5qjbNu1nRMbeThHW/uhsrYK39zVy5dt1n8+AScFN8FpYNhzI//k46P6Hmf1AHgdnpsypykrVN8cKWSLfL9b0K5O04ktrq9oejRF83c13Er31D6D7+c/vMFBGhvlsYrlmAtsg79IJB41ifEtWnNp2TNEf1l4ozYmQ1NHI9nycL41Xmn11noS4SeMk5olF1uuKLTE2gg9v4SnJHJ6tnrv4ea8gbTarGxF9HpAcUqLvTzLKlsOGTXCv/66UihaDRRziKqAdpWr2nCFOQY+JYzwWO9fG9m7W+5nMKTq4Bzl689VgwQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/15/26 12:25, Sarthak Sharma wrote:
> __gup_test_ioctl() calculates the end of a GUP batch using:
> 
> next = addr + nr * PAGE_SIZE;
> 
> If nr is too large, it can cause next to overflow and wrap around.
> If it wraps, the next > end check is bypassed and a large value
> of nr is passed to the GUP call, even though the pages array was
> allocated according to gup->size. This can lead to out of bounds writes.
> 
> Also, when fewer than PAGE_SIZE bytes remain, the calculated batch
> contains zero pages. The code still calls GUP functions with pages + i,
> which can point past the allocated array.
> 
> Calculate nr by taking the minimum of the number of pages per call and
> the pages remaining in the address range. Reject zero sized and non
> page aligned gup->size values and zero nr_pages_per_call value.
> 
> Fixes: 64c349f4ae78 ("mm: add infrastructure for get_user_pages_fast() benchmarking")
> Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

