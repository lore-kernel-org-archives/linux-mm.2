Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 020D0EDF176
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 15:47:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6AE116B0088; Fri, 13 Feb 2026 10:47:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65C656B008A; Fri, 13 Feb 2026 10:47:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 533F26B008C; Fri, 13 Feb 2026 10:47:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 432626B0088
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 10:47:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DD4B813AFB5
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:47:38 +0000 (UTC)
X-FDA: 84439863396.04.42086DC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1723F18000F
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 15:47:36 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E1q0w0cD;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770997657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/sqO62M0VA23+/Us4iYIJs6T1Y/ZN1kF3DRtuRbdkEc=;
	b=wNlton2B7RbvFK+usV0Q+TGtDyu7GMJ4XPBAlf/Uyv3gDkQvdzKsIdz7y93Inb41Z7/Zwn
	d5UOrT3Tg1wYl5+MaKKbhwxCaqaeh2pCa21eTt/y6R43Ey+N8V54b8sC76OzEL2EiDIhPQ
	ANvORy/46KpNUpnBhJ4VxqfeKc3p+xU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E1q0w0cD;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770997657; a=rsa-sha256;
	cv=none;
	b=2CSG6pTdKVdsJfLCLogrmnQHFq8j0o9fQJth+FwhqnygJvqLxjp9UQayXin8r0Da4PVQl8
	VH59abh4FKE+vKoO1Y2cZvfGzB7Mzr2mFDMwk4DStCPCaFRN0uVsH/oZoo6RlwdliF5qTk
	C+KBwdQr2EF1whZMzbWNvgnOb2IBKR4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0E2D1419D6;
	Fri, 13 Feb 2026 15:47:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C19BC116C6;
	Fri, 13 Feb 2026 15:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770997655;
	bh=XfS2U8kOK3udT3K8Q+XXE1402dkA/o2Hbuihs3yn/YE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=E1q0w0cDwPhOB4LOSqfrUxeF5HN6B0FfC17poneLeKRwHBfHScquG3UD203zHqHjP
	 Qdhqz0Ctjr1uFF/kXy6c+yP8JKhLJ6Ml+n1lHcsu85oCiL9wE7JRHZCHZLhVSwxYoJ
	 xtzWwG7bm+gXJudcH/2V8Ebt/ixxX+OUI8d8Y2kehEBlV2mOTLHqa5fWa00cj7xPkR
	 pdsYcyoULcTrFKrLoBBlCo841df4RR4dO0ETVGv/Osfz0dlW+TVxl70sQLFoljnFRj
	 UE/YVpqYUgDaNVbdyDII+6taRrOJys0/+KcS33CEgCcwslbkpIx9NfhK7QKGUZQvMc
	 3A5JqaribBaPw==
Message-ID: <c450ee86-4c34-449d-b144-6b4dcb996998@kernel.org>
Date: Fri, 13 Feb 2026 16:47:29 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] mm/mprotect: 2x+ slowdown for >=400KiB regions since
 PTE batching (cac1db8c3aad)
To: Luke Yang <luyang@redhat.com>, dev.jain@arm.com
Cc: jhladky@redhat.com, akpm@linux-foundation.org, Liam.Howlett@oracle.com,
 willy@infradead.org, surenb@google.com, vbabka@suse.cz, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
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
In-Reply-To: <aY8-XuFZ7zCvXulB@luyang-thinkpadp1gen7.toromso.csb>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 4ndryboets948ajhtntob7q9uf9f19ap
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1723F18000F
X-HE-Tag: 1770997656-970961
X-HE-Meta: U2FsdGVkX19O6aSI26NygQ9jr3UYqrDaopxGwe2i/L78Pdr3uBMQuPoxmV5ncn5aD2emAPmgBkhBjiq5p6RC8HNE65diUC3cKct37f95s8TgomH7tLVYfUtdkARadtUMG8TTjwJvzG2EjdtUtSBk42BLukEXuF2USZgfYrm/3+TPP0OAXJxA5SakhLn/bGZLsjSw6iVQJYqGJYWZhLSZo6kmkC1qwf8G6VyL0sG6Fm5mwhuZ+VUa/enHQQH7Qos+va4qV6zofwSx84Pqam/sckssl6q0RiYxpXzhekYh1HFcF6mc9lZGZxVk7X2NUR/3RDfS/LXSX4pKob1rtdVp5N+ZXvW0EGWcEX3ncXjeK1ciie/UaJkj3WD2EtS9Ub1NQz3wZOq8JpwFvJhnRd56+fj6efPL49NzoiLOpKnCp2q6PNavIQ91zIB84JlbRKObgSQILUSTBt89iVusXwWl+ziLVsyGUGk6cu/JD5jcpYzWFweZja3cZ+3uzDhyf0/KIYNO7M0+cM/z8+qYfvFfhO6cuJ9RwqFGo/+MIOV+papiHgXAHfGKaOUtjCoH0SS5KtsJRybL3Ev/NvKdjzxfoJG4tJ+zqAk/zTk+GJZtpMPaHNlB2ILEWYpgtTLxtL62KxVprn7fW0hj0sIZicvaEbmgYxKerUPoJfrG6ki0KpV4RhiHCr+iYdSADhSAxwRipQn9dwsuwUCwKTnKGshuBYeO2uzJ8iS00HKzjhV3GGa510u1u+9CDQ3bbYpstLz/fRzUeZQIgVl+RBRd+YWs9w+mrsO8dLQRgvIi5rVVn4iej2e9GA4z8RSE6DAgOzXhXJkoa1z5bKk8Kibd3RyLaCrjhh5sKHpnimki2UCnqXF2pSj5HkLOhiOP8xuBjJCtORTU3JcCVDjH5t+ozhkh/B3+h1lQZhkFBL/xT9zri649t0QZiUQnHrD/EhNyJPUlaUiRpUtIU23sH9HNkRg
 641xS7Wo
 laryaLryoJIRqf5ta/rkn3SplDH2PfEfkYbROx/YCxxRVibz5mUpg5Qq1UJE6msJWV8NKopFpv6o3EUo7eDnPgHBpTiH3prZmcik7FpYbqKPxGram5+ZmyYQop5zgjaH8VOsbfsOjMIgnnOk4zzo4lFh4w6CH8ZSvI8bsA5xaPicq+3GUBbl3TlMSiDbbS3s7C9bSO4imHCc611MS9BTIuZJmW5NbsjYXfv7HdsF3j8KZbmBHqrB5923PkqPFDHtAL7En
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/13/26 16:08, Luke Yang wrote:
> Hello,

Hi!

> 
> we have bisected a significant mprotect() performance regression in
> 6.17-rc1 to:
> 
> cac1db8c3aad ("mm: optimize mprotect() by PTE batching")
> 
> The regression becomes clearly visible starting around 400 KiB region
> sizes and above. It is also still present in the latest 6.19 kernel.
> 

Micro-benchmark results are nice. But what is the real word impact? IOW, 
why should we care?

-- 
Cheers,

David

