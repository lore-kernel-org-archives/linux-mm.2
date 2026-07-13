Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B4F8C44507
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:37:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44F786B009B; Mon, 13 Jul 2026 08:37:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427186B009E; Mon, 13 Jul 2026 08:37:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F2676B009F; Mon, 13 Jul 2026 08:37:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0B8E86B009B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:37:26 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F73A88517
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:37:26 +0000 (UTC)
X-FDA: 84983704092.15.27ADE2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id B6FE24000A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:37:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aGRSwWNy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783946244;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wnf8lMh29RRrgFePOwpYLwWw6+OTMWkR/m8/p4tHLLo=;
	b=LEZCWWOd7PmSGD4rI7c6X2x1B1Pxj/byJqHQ7uTsU2wzgyTl8CH6nvt4RyKyQZZd300Cc3
	7oqrOsIto/C32U0YgZf3buLLClKracp/BQ0syTyTSbXidHCD9l3HcNP+Yzin1z1ZvoAlCn
	E0cF4ZyYTPaxbF3RoX+UySmgbFCR9/U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aGRSwWNy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783946244;
	b=xRvbSGvEIkLWluiiVKkiyJX3OojHHBpVZ2VaeZdLEw8I/gNam2nnTlOKNlEhxT2/993hGr
	g2/LyDYjT+Cr9iVF+HambzI5Odmmg6q/gX2QydXwWYZknnuFiE1f9UDJ2QyLwVbKCbhQfz
	frxkFy7qRCLU1pUwCJJU/3bjFVLILLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EBA61403DD;
	Mon, 13 Jul 2026 12:37:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6669F1F000E9;
	Mon, 13 Jul 2026 12:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783946243;
	bh=Wnf8lMh29RRrgFePOwpYLwWw6+OTMWkR/m8/p4tHLLo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=aGRSwWNyiYn6uHnSGSz3sew72p0VxNH+W189lLeS7dC1c3MBoaaQEQLXgy2P4PVIS
	 LDB1VnhfrZyIfFgQJ0MlVGCUxQaD4PRt9FXVm7+ngle6erhpBtUKIZEaFFkjFqh6Nn
	 QEVpGh2M5SqF/mZLD3WDShEBvg/UKzRnqd3CAmiBjRkjfdQ/gKtWM8ptGfLFshePDo
	 tKmVNfe8Ykq8XzMf2p1SG6ihI97jENtQGNe+nxQxWpOB97gVmWuYtBEsP8EPxvVkPH
	 m/G+3qkud9s6X8Jgi/mNV1nMNbCxfpDTHMikbInerUdrWh0NdaUFAHyP0ig1SqtBOF
	 DsRLLeQOT9+hw==
Message-ID: <aee27d04-cbdd-4d7e-9156-7dd675d3bf45@kernel.org>
Date: Mon, 13 Jul 2026 14:37:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
To: Matthew Wilcox <willy@infradead.org>,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
 usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
 Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
 <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
 <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
 <alTN0i6XgnI_eDoh@ashevche-desk.local>
 <alTbSRXXqNFPl59U@casper.infradead.org>
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
In-Reply-To: <alTbSRXXqNFPl59U@casper.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ze7itax9ut1c799qwrmkfjwqoo47bdss
X-Rspamd-Queue-Id: B6FE24000A
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783946244-999151
X-HE-Meta: U2FsdGVkX18zwcce+xDiMVTJSYeoWwvJVvVdzNlPoEhXwA4wJ4jnqhPltJj/xouyyzG06ux0crRIQLpgZyDRxwjeW1xgkSGhLcGaBBjfqrw9zlchcjj1RLuDY7Lk9qCYh8hgDxQVfY68PlJRRIYOpL3kAhS16hZ1y5Rd8iH34UamB0EpRmyx4ZLiqUDtlYStLmAWDY2q87fSzmJQKiRQSX//Zqu3QEEV9yw58H+/a7fdMQeoPROat1UOVnpJKU2YKPVxKdvX2iCcVgfGkX/4YCvotxD6SMhzVeX1xDFmtgb7gWELy8cIwKieCqyQ29BmMn4KdICFZ8Uvw7uU6fvIFheb9eol/8dIrgCR09qnt5y/tnnvzuOvwQMcN6/o149RVhIRZYbicphUlGXXwpPDMqenky9R/e8e0g3L6DwHBlOQQKANL7ewrr8atSnI9I6vWgfJ2qf7aOhspyYqoffQoAn+H2ypi386LZ1P0LHcOxSTyCg3b0wFALpHBkWTpcIwHnPI1iaNR60z5UTRWiba15Vl004FVR3qZcbioP4fCaiNh/LMSzo0PJmaG4ZNfFK+HrSV3ISvhJyixuKFr+GPHExPmYn/XKoiyB8WdGkmDuq+6ejav2GnOwYokTuZnq+tq8gdUTg0wUQYP98MJuUrGulTVt2weRzqB3atF1xtuXNHCRgMOpgf0yGsuIIZiGledLMtELszW8F1dVx1UOrmM6cjiN50GrkKaLt0mdRptDjowE7uUfoEU4nwwzmvdw6O3p1vh9Ax8qzUtRMGdQsEbjMhZWvPmmScamUStaKWVmiklCLMMXi0IlGKFuEvYhbTY3wpwBd86c7GvyQewG4icbZWOiSYTXn1nFFl+QUL9RHX92Fsdq8qC4V5QadRTW7lMkhOtdsXI2hJmHSB2eLRkM2xbgkrLZka9sGvFB+lOg5Z4x48W+yaukIfOe14eDWJPs4YClXa+CaKh0sN8NB
 tWaLoOwO
 0ocAqgvaJYG/rPyUHQZ0ARBOFihmLQ+mPZAj+SLAB/ExivLUo3wr9fVSqJ5dKuiP+L0wO7OVkkyZr47k3776h4LJBM2vAWl3RZfDRkS45UaZcw15XtPfNiVWU/ke6HLcTfOdHhz1lonW5ZqEuLGhS+TTf+QisLa/kwumnVB5E+Ck6vcons9bKWgF7zoGFcgsoID/6jgFgfNR0TxykaIoQUVF1WbeTJs3MEtbrahTFjx9bdes6z4ggr7c5iKE184tL4Wia
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 14:34, Matthew Wilcox wrote:
> On Mon, Jul 13, 2026 at 02:36:50PM +0300, Andy Shevchenko wrote:
>> FWIW, we have hex_dump_to_buffer() for that already.
> 
> ... which doesn't eliminate the problem of allocating buffers in the
> caller.

I was assuming that we could possibly use it from lib/vsprintf.c to implement
what we want.

-- 
Cheers,

David

