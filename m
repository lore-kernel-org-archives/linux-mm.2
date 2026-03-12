Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0944E105A597
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 12:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E9296B0096; Thu, 12 Mar 2026 08:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A0D66B009F; Thu, 12 Mar 2026 08:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A2236B00A2; Thu, 12 Mar 2026 08:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3836C6B0096
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 08:59:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B86FB1A0218
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:59:14 +0000 (UTC)
X-FDA: 84537416628.16.71AC009
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id 18705180005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 12:59:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUbVAO1x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773320353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IT35hmMkpJTLydYg6h4wYE27b29UZK0Yg3i1Ba0pR/o=;
	b=PNfdEULEJvQXDu4X/G3R2oz/dVKQuZhRJ4/nys0aZ4CymWOWlG6n+63wJpNOcQTcdfoWvs
	GHOO5teASuwIF/LL93DBVgCX545xL7hGznyfAZS4cHNtT6vp3vydtAwfgbij7u0xVU9W6H
	sjzHbDSrRkVe+MnK8hfqp61ziAGCDwg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773320353; a=rsa-sha256;
	cv=none;
	b=5pbZan/wqy9iEUjg8MPGpSt2IN5oV6HdjIPTVb95Bz0KmnZZdLp7fTYaZRiboC75hmVxOT
	BCe/xrm0Jj1dRyrrlsRoacslx13TT/Bzkit2eF0OJz40cQjIcvAsS8RuAgQhTjnHGkVe4R
	VjDWZ9YkP1obA1dNyPPuis8aLF0sjVw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=kUbVAO1x;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 82E0E60131;
	Thu, 12 Mar 2026 12:59:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE0BAC4CEF7;
	Thu, 12 Mar 2026 12:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773320352;
	bh=4EEyl9P2phGX+HwpLUxMhA+JCF9RdOHB4xQY9FxOTGY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=kUbVAO1x91zfStXxxANoYTJv0Ff+JvcWOyNXKg04nWwHWPqw+FmjGa8mF1Moh0X90
	 ahrl1iH3mybRF0h74/6OP9S7PSQ4zKMWF450ufAzpVnEEKlYItYxLBFnihDbCbW/eN
	 OqICOUjm+w9EhVZ7EW5nADKF8fRWxpQ/Aywyn7StT3t3ubt5S0ti14CA244FJfXQeC
	 MK/JATDYt6zmDbpxCl0cgT+SBhTlUpfrHnkRPfVPIdERcxb6kjTf38ZdW9J5VGWGNG
	 wAsKsbfZuxUFDneMJ0LqJmT27+ZoaXBPMQyhj6dY3Q0VVaazw21XN/I/34tIJd+A1d
	 q38WzRCGvLQDA==
Message-ID: <38a2ee9b-9bd6-4bb4-a522-db6552eedd34@kernel.org>
Date: Thu, 12 Mar 2026 13:59:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/4] mm: Fix demotion gfp by clearing GFP_RECLAIM after
 setting GFP_TRANSHUGE
To: Andrew Morton <akpm@linux-foundation.org>, Alexandre Ghiti <alex@ghiti.fr>
Cc: alexghiti@kernel.org, kernel-team@meta.com, akinobu.mita@gmail.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, apopple@nvidia.com, byungchul@sk.com,
 joshua.hahnjy@gmail.com, matthew.brost@intel.com, rakie.kim@sk.com,
 ying.huang@linux.alibaba.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Bing Jiao <bingjiao@google.com>,
 stable@vger.kernel.org
References: <20260311110314.237315-1-alex@ghiti.fr>
 <20260311110314.237315-4-alex@ghiti.fr>
 <20260311100646.81819c0f02eec5d3f1dcaa70@linux-foundation.org>
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
In-Reply-To: <20260311100646.81819c0f02eec5d3f1dcaa70@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 18705180005
X-Stat-Signature: s3qhg9r6jfd8m8fds6zgzhq1kwcjx49x
X-Rspam-User: 
X-HE-Tag: 1773320352-851837
X-HE-Meta: U2FsdGVkX19hJ1OYkc6XQS/tjj2jcFYHmUV/u24HZKHcPAVKmOWj2wZTa21iLB5KR86Q20+WuZf47/rSJ00JUDDqD6BOckpG5brr+rUvHqq0p9wNNZtE2AFOqeoTXsSdpiSfosp1w73XuBth/OBiCRauv/MuSqpas4H1oiFipid8cyCvPaJqstxtGMHrJ4tUmCjgr57cm8j2iLYp3D8w1RImNHlsHAdIa6zxfjweZpvVx4rE0tlJlo4lmFR9MiIinJnh5WJg5C25FDrDQWKmvSkoBQDPKvfA9MjyBS9jAZXiJteoe26bdRQG4GkA8fuc4iLoMdb3JrTmpeBIZvJ3bNWjEI8yGFPk3owI6zv1SCFwRbM4oWPGQ7HkJFZTu60W6DO4ialGnJHG2Ktas0KwuHugIVW/+iRRzHxtg5PpzHloXl450s31OULC52Da9+As/FJjGlWvmK0s+J7K30zgorNNc/2Rr6X15jx3Sp9X2GM3uaX8sdyemAA9J/i8tBsykfTKxOeTDKw/tlVHi845vU7p+biWbIRhlhiCa8rgnzm6JzCZPLP64NzpTrdbULTHzzJ67gpTk5rWU4Nl1HB/w1SPxytghnUQThazXGaLNmVqiMngUgYb8A8QVLh0AV5L+giFZcw/64TRTsg6UB+Ku1wzfzeoUTZJBhvfKiOBd9Njpgybj3SoBSh+OLFZstXUtuGXdcnlpg+T++QlF1OJ9BkC/66ozh2gjht1OTlfB6zTwMuXPIrPP8aQ6J+MHlGqfa9NGklU/pPj+LK8kU8PoApcfxKkoLbgxgN2dx5jolERFmb1fbYbiq1QfUZJqVYB0NrCwXcOSYHrGJ3/e8qi+UtxDATMcRdUV7BjmLzsr7SOMzwJbq2P19CmZDd9CCFwIUw5C3rwPCXA093MQe99T7Jmivx1iCXH9fb9tclUyGTNYzrOyx14xvhbTSUtOFE20iBhcvwCAQuUuzdaBNQ
 81FiKgc4
 XwNTqQ9s7TIpKDJP+EwgleDGqI7mh+HNOIrg+yEdWvT+KgWpGCs97f3cnYGLI70BrvBYrIf29FyKKI1/fLJnH9rfQYEyS6Xpb2guNaUNedG361OcPF4yIyl8KK32ZYeSm7kuIYpErfzeWrMOV5vY6tNiLd2TyGVx23jqoIRRqtegCupJQ048kZpFK/o6RILXl9XtKKE9Z6zZOJm3N5YG4xPF/in8+5NLbzu+ysGSKdGCWwhMSDY3zsLPjab8Dp+NxPX0Bxx/BKsZDiHBmJfvUTLkSLP38zutnggCAdEtIoHhpaIKzMJXGcNnt64YrpoYXeX/9XlUIQwFbjxoei+OtYHkm023lOtrK7UZfo9NTo+TLoHJ9xBDvJsIjqjz7ulnTR5VXcUVZNxKT3alNnpyJVc8mAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 18:06, Andrew Morton wrote:
> On Wed, 11 Mar 2026 12:02:42 +0100 Alexandre Ghiti <alex@ghiti.fr> wrote:
> 
>> Fixes: 9933a0c8a539 ("mm/migrate: clear __GFP_RECLAIM to make the migration callback consistent with regular THP allocations")
>> Cc: stable@vger.kernel.org
> 
> Please let's have the cc:stable fixes separated out from the cleanups,
> and prepared against current -linus mainline.
> 
> Also, when proposing backportable fixes please ensure that the
> changelogs carefully describe the userspace-visible runtime effects of
> the bug.

Also, please move fixes to the very beginning of the patch set, or
better, send them independently.

-- 
Cheers,

David

