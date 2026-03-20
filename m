Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 638ED1099B32
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 19:06:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78D76B0148; Fri, 20 Mar 2026 15:06:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C29CA6B014A; Fri, 20 Mar 2026 15:06:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3F3F6B014B; Fri, 20 Mar 2026 15:06:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A63AF6B0148
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 15:06:46 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7680F1602E4
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:06:46 +0000 (UTC)
X-FDA: 84567373212.20.EAAAEBA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id B1A161C0010
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 19:06:44 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ht59kAY5;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774033604;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J8TtqmvEODTqgECWEXNSft9t0QuyXGz23pTnFK+usw8=;
	b=rlyfgWittPCTB2Br6qWS6ceKqCEjvESetTuJi6sgkWsuW8KDK/eyWYWtQYbVFWabOEy/D4
	Mp0oZonfgQdEtA/22ELGTl83702WzbORJrY3xOJB7SZEY6cSrTe0ETyodP7fSpelMYYwCW
	N9VFlS56ZsXkLZdNCo1S3bRQT+H2Xr4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774033604; a=rsa-sha256;
	cv=none;
	b=4NuDjqd/TKOfxKcbwr+LmqD6b4k8sIxVS15bLvKL4/Jsy9xUpf+v/USKx9AYm0Z7MOOCOF
	/NvrO43LkoMHrSuOcBfWH0V/zB8oeKKrMAIjMS4lwcwm9qHacGLvAuN9kBy3ys6APdncLD
	NxE0NgBVTBG18NL39tK1zg4dU5zpb+M=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ht59kAY5;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1E5E360126;
	Fri, 20 Mar 2026 19:06:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9A1C19425;
	Fri, 20 Mar 2026 19:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774033603;
	bh=yFInHcjCD0aikV57e8Hf/jnHHQaVc5KHOASzy/iqGzU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ht59kAY5IP7JOUFYzZGhuJYmcbYpJ+KKW7ZMABGHFWJoyj5OtAAhNOakEO/z2LraP
	 7wHWlC6wr6EkKVmr6gSGV90ldLJnklw0QBvujgFF8qxuEGYbkIbvnQy944vO+/xcIh
	 NRQFAZjlPgEt8zAcbr0eCDjM0E2GDlgrP6xR4HvHjLZbn18PKsc02pDqhjxyNpipXy
	 CrbZgNZJVoQJiFMtrc5vbkOeA4eefJ39Ja+ZMLIK3g/MdRb1fpiv5f5X5zMYxX6MSF
	 vZPu6kVmq7onoj81XRi3ICaaMuC2NVd7fnQpGUVWig6pVDd17vpLyN3X2/qSl5OL0/
	 3TGN8RnE3Sgzw==
Message-ID: <5749850a-b99f-482d-b610-b4c5e5ee522b@kernel.org>
Date: Fri, 20 Mar 2026 20:06:37 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 13/14] mm/sparse: move __section_mark_present() to
 internal.h
To: Mike Rapoport <rppt@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-cxl@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>, Axel Rasmussen
 <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
References: <20260317165652.99114-1-david@kernel.org>
 <20260317165652.99114-14-david@kernel.org> <abpo2qJq30cytRiB@kernel.org>
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
In-Reply-To: <abpo2qJq30cytRiB@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B1A161C0010
X-Stat-Signature: mzkxy1s5nbojxqgdehs1zjjf9r8m7o6y
X-Rspam-User: 
X-HE-Tag: 1774033604-510545
X-HE-Meta: U2FsdGVkX1+68ebPLwctp6YmVccB6Zxz+grBa52f+iantostPGv+Rsjh2XLfzdPxd/RbUQjJfUQR5285fLpTtXxM3Dmqy4RhDIFRtuNU99xWUyLmtLEI0Z9zgLr+FCwTrutn3omImxQ3AZkWbdC0Vv6a3MARD0XZ/ADl07RRFBTMNayUZ+ZEjwnm9VTYTGQp64DboVF6kw4lpjRfLYuK04e/gitM3fdtUcMAJcOtp/9UkOlrqFLq+60YtMR0dojJVkNkuJCCexEgTYkEsTBQUgReJipZ0zq5Ha4VSwpBK7wk5kC60M1evXset1GHRDy5hcgr030xYnlov2pTD6/cAxSjGpCQtqrfc7GbR6217d3MQcSGviuc0PunZvrhQ/35iDIZIz4F0nkT56tm7wx82KbVDlC9YPPvHYEFgfoZhomsi1GkvjbFTVKaPXZDLGItyK5VzF7cLKubsCz/+UPBSHj2Cp5TPs6jC6ebHfGoo3bB2e5/XSpyOFli6w+LYE2bq7wvf5OGct+FOPO8xVhFvruOMAXt24v9eJM5A63xbVcUUmpqg2HacBMkaAEftQMdyNkBue2ic9SMtQvScJhscL+PY8bwcfSs87BqfmBK4YrcV85UZT/LjLkGGLrqegASyhtKSEmwR1plRSqEW8ZyY5/6GTpHxfsZRFan2flwOeKnftW+fkvVKateIUw6kFspdVL1dqgzLHGOpxZspIkUcCCht9UYEa/Z5Kss7dBWJopO+fFDGWoIpEZmR9mPwjQJSMEhyp13WCVomU7LKEgHEaIYLKlovKTOKZxbylN47Ez5AaIhX8hmlcs/JaSO4RV1z1mhpqWXlLhqUDBndAgTS/AcF59BmXQaiA0SVtPIEf3gf5X6O0/PYPce3NsoR7OQsyQTRMNMgQ+3VrQYaaf+XwqvkxadspitUVbPoO1lB3JdaexjDhOnqBCClc/16lC5QF7F22kzBwNEfkZBAZL
 Gib59WkT
 coz5Qu6GxDrbY5H8II4DXnIOfGh0vC06gDSoHmhycF9nQ8px+xul88f75ksU2HB6NIb18gaqUjJGnBNoblz6uw4+tNFQNCRrxaB54oFkvB4QX00Yo8IH+uwx7NKski5xMFCCa92i4d8YG1AY8b3qBxioKptvAShslTHpfnPtaK/oxIaXM1ItUEtXcPHrmwpmP+sqLaI7r5Se66kLX/LJ7PcpE1efaLcLjfD615+aL4rQa98J2n+wvFXTPC2gMEZZw0aZWMC0NOPSk1cWyVVMdCRPEgd9bbMDJLVJ4U+VMBOqlkFN+IRkQnfguoA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/18/26 09:56, Mike Rapoport wrote:
> On Tue, Mar 17, 2026 at 05:56:51PM +0100, David Hildenbrand (Arm) wrote:
>> Let's prepare for moving memory hotplug handling from sparse.c to
>> sparse-vmemmap.c by moving __section_mark_present() to internal.h.
> 
> Not strictly related to this patchset, we might want to start splitting
> internal.h to sub-headers.

Yes, that makes sense. And we should also split the non-internal headers
in a smarter way (and do some serious cleanups, it's a mess).

-- 
Cheers,

David

