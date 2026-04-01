Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A8CE7107637F
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 14:23:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 064E46B008A; Wed,  1 Apr 2026 10:23:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03D116B008C; Wed,  1 Apr 2026 10:23:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E95556B0092; Wed,  1 Apr 2026 10:23:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D7F926B008A
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 10:23:36 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A5A0D1A08BE
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:23:36 +0000 (UTC)
X-FDA: 84610205232.04.7541532
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id C982B120012
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 14:23:34 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gCltjpPq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775053415; a=rsa-sha256;
	cv=none;
	b=XURTRNfDwYW6VwZkyQ17WVprI3qrzQbFclKxa1z/9p/Rj1S43Q6K2/3b1+dAp8g6H6L1wq
	4Jn2o4PuUvGc1Ib7qTTPXUBPWl85kdbSogU79QOYBogvrHn3ATYS57GbMYpE7NCgVIHxSv
	dp2eCe98vsXl6Dm/JJjJkPJsvyQpGFw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gCltjpPq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775053415;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xrKowWS+Oa8t0AYRFquY0pxVj+Qa0DciPRq0ZyRMQpw=;
	b=DjJbOK7JyFmsJYc4wNNeE0UU3SyRtzEI1Il/wjkg38XwMa3FPVFRTzDwVdIbiL2RqiUOSI
	n2ZfNAxTKN+q7nyykPkD6yVU4RQ7S4h/+A2huqf1dVe89fWWV3ni2KMTT5KZ+4kUKRbd74
	670KTJFJh9bF2X75QRvYf6EUTKPp3kA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED9D540ACC;
	Wed,  1 Apr 2026 14:23:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BEBFC4CEF7;
	Wed,  1 Apr 2026 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775053413;
	bh=6VHZQdVcweUnK/eBmrW7ZqmrS1qt6jitIGklQQlSOfI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gCltjpPqUrkUauJrDpAxOiS72XBVBRF0NIOdSjUwJB4A2Msa+j63e7I2+6XGBDfPI
	 Qg+UlNp77GoNiEq9KISRwkEOkw1xR5F3M3CYFCDzhUSL6Xy5nN415BhEphEpAMhbed
	 OS33ZBSPmNCu+w6HAj5fLvbZFGbfJxYQd/FqN6igVmyMkif0IWW2vGN8VO4UYs+3WT
	 GlUx8ByO7kdPe1Tk8bnt4kNCVkmmyzgTwxyCanh6wM9CHF6y2JhDsRLk24kuMkZ4sL
	 JcWaI5Z0+LAzd49vQzKWX4j5M4FdDYGaibl6qSYe0AajTlk99PVpKPZAUhgp3N7+Rr
	 hai4g5YzrC93g==
Message-ID: <455a3f72-a513-4fe5-8b8d-31d07cb3b0a7@kernel.org>
Date: Wed, 1 Apr 2026 16:23:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 10/13] selftests/mm: skip uffd-stress test when
 nr_pages_per_cpu is zero
To: Sayali Patil <sayalip@linux.ibm.com>,
 Andrew Morton <akpm@linux-foundation.org>, Shuah Khan <shuah@kernel.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, Ritesh Harjani <ritesh.list@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>, Michal Hocko <mhocko@kernel.org>,
 Oscar Salvador <osalvador@suse.de>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Dev Jain <dev.jain@arm.com>,
 Liam.Howlett@oracle.com, linuxppc-dev@lists.ozlabs.org,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1774591179.git.sayalip@linux.ibm.com>
 <0a4106d7c594c5bb471a48ca37348883e204d295.1774591179.git.sayalip@linux.ibm.com>
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
In-Reply-To: <0a4106d7c594c5bb471a48ca37348883e204d295.1774591179.git.sayalip@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ric4m77a1656in57866134imj34t1y6k
X-Rspamd-Queue-Id: C982B120012
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775053414-396809
X-HE-Meta: U2FsdGVkX1+lqkONiLmXjHmYr3MziBSwkw4SIrypgEIGqjdV98sOuSKzbT3A/QoDgjZTFPpeqgUNr1kqhFcbMWBHRq3l4lMyDlsbfYAser+eSCJ6bWDqjrLvPpE2Z30Z2Svo2iJQlPJ5ckW6Hq9jjkaipbUJjfZ4iIaA+ON2NsiNCcjY+usKxhww2LEpsDz7afnPDaZu/YwuQ/dMcmts7j2oHaS7fTHbPBSr5yBE0fY4ArG8Hd0IHVah6hV4WH+F7PE+4K+7hjzzbogFpP5ZB7w3MJjWpnbGwoUJ0piasCaklxWxVF/sbvEwjgK2PaAx4rI0tzm4WNOhBYS9b98O+6BohqK9JYiLY37jju+EYsELBOMc7X82UG1tJthnU0m3arm54oYS6YVgOBBF1Xixg5u/Q80/X/1uaz6xz8m82eweOC4+te6AK/f2eJb1HEaVPC5HdliBHB50FQeqrK5fy/4ItG2jECrZPcsLsX906NucyvYA5vTPR3/06iHHGf2daGhEvzomj3RR8Gv3/OlKCrZwhe8Tr1nv3sfp2pdMOoAPzsQow02zjhZQbXtainWEoydnb0jyhqMkdGn5T19bAcLKv6LDKLlcYqNlEPkBUqyWYJvN+0AKLWa+Tabb0zycqur26m8YZ/bpBDK9u3pqzLXiHoAL14cVc5TQ5RBooV2/AnyzEWnN9sWOOx+FbBhLYmSi+QisUnVOac/2zO4Q/6N32Pc6EZYmwyDkfzBOK1/8E27eZ5rJYVXNOSBIp0Db8akzJzxtu2Se15gvIHvpdUK4Z7kT9UpSkZP9DgYjIA5fLMNoRWT3CG1KIqdv1u+gwg15f9UYsTyYTPhxUeVrm8ZPrBj1U8i37sILuy+dkbMq5IBUOfAKEgDdM7AhxEUD+J4md+umbbXdUGrdEN4PLVnlG+9BXCruPVv774YSyiEj9NmDzz6CfSPTo3RkZ70JbDXJJsmLgpaZQvrRbJK
 kIxH3YsQ
 u0SGHgEXD/R47UhXMffH0ybi+P8M0yWIjznV1c9XbUtifzTXUtI/1zeq9Rk6Vzt3ZegHIYte8ZPpmDmLWoAEDIBX0D6wbjBR/TGda/gtUVz8csGP578wxKucfGhbTc3ZDsXBBb1Zny2vFJ9I5RTg4eKfhPEKPnMCjTRAQLTUA9kDpF4Z0aQsrBttdeXPTMLinOVlQk1tja1Xqs4rHU+hBTAY5df5FUyBHWacx9A04ixFEIqDftihtdnw0Us4JAo+gFzf1BD9kfM/LJe/mo0n9WdqjqKM8gnDH28oJP9YW/q9wOhRgLukYkgFXjtTnHrX9p+kQElx74N7uaa9UnxjO8OjjjY2M/YjY2WtDaqQVpk6COsXwiitsVKps2iprPA0rqQIz6bevCilgNkDLca+zMMtDbtJKI/FnREmGvt471PJqPJWxo91rgg1/D55xVQeIM5ie
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/27/26 08:16, Sayali Patil wrote:
> uffd-stress currently fails when the computed nr_pages_per_cpu
> evaluates to zero:
> 
> nr_pages_per_cpu = bytes / page_size / nr_parallel
> 
> This can occur on systems with large hugepage sizes (e.g. 1GB) and a
> high number of CPUs, where the total allocated memory is sufficient
> overall but not enough to provide at least one page per cpu.
> 
> In such cases, the failure is due to insufficient test resources
> rather than incorrect kernel behaviour. Update the test
> to treat this condition as a test skip instead of reporting an error.
> 
> Fixes: db0f1c138f18 ("selftests/mm: print some details when uffd-stress gets bad params")
> Acked-by: Zi Yan <ziy@nvidia.com>
> Tested-by: Venkat Rao Bagalkote <venkat88@linux.ibm.com>
> Signed-off-by: Sayali Patil <sayalip@linux.ibm.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

