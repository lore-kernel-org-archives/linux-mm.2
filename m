Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 736BCCCF2DB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:24:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F4376B0254; Mon, 19 Oct 2026 09:24:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5CB606B0256; Mon, 19 Oct 2026 09:24:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4BA366B0257; Mon, 19 Oct 2026 09:24:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25B226B0254
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:24:19 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A93BEA8322
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:24:18 +0000 (UTC)
X-FDA: 85339444596.30.7067596
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id DCF8210000A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:24:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZcP/V1D+";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792416257;
	b=hrcv8nktY4IAoKfMN6roFN5VzrjQcSzF1ylFdS+UAlPgJXJRcyiYFu/9NFlojoFZ3kJBZl
	hteh25Dd4rCAMKlnepIhOErpXsURFhvMcRb7+qzUZX5HPDn9LrtPmPaxgutu+55hP+TIWl
	yStND2WjfrBNmK89tVcRikh2m3F1GNc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="ZcP/V1D+";
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792416257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WCRqZNeckY15D0lVwoVM0U4hT9cjL2n8Ttnb75nDkG8=;
	b=rSAXGFtC/uWFH2nI+T46sTjCyBRlT0LPqUt8xt7y8LqditQPTH9y/0dVmT9YVPIeImKTbT
	BityqxqvyWqp02BbLRlyqykigtNs+nkzb/6BMuSUSjw8ebWZATrlOri4MUZq3KKTbuSU/6
	aZ6SGyXrUtcJsmzWiquqZdB/eIBiUkM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 631F740963;
	Mon, 19 Oct 2026 13:24:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9342D1F000C4;
	Mon, 19 Oct 2026 13:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792416255;
	bh=WCRqZNeckY15D0lVwoVM0U4hT9cjL2n8Ttnb75nDkG8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=ZcP/V1D+BfB2bhX74a3xgdkNlYqZmTKQDmmXp/USbEJYCDQcqco9yn3z1hxlRrBpk
	 7Nv8boDEuXbQYl4t3T4voNLFgFTqoBlrwhstRPnDS2schA0//V8H/ovRWtkjBPiQ17
	 SsN2VgT7XgYIYNT7LSn7Q/OZS/YJ/U0czfX/ij3B/HRS8Ycp/Zd5A3xQgageiD6fjv
	 VmkGtMy14YUULfiytqOEcOhcEN323Uyt46PQhbwWT8FQZVBoHTbRZQ6XDBRVhUSTBq
	 hWEOMgVXSOHJpQhOP8Z3SPbWzSjttJyaywUuFaQqWyXck2crIZuy1rEdx35KdXapUT
	 /VRPJvJvfRDnQ==
Message-ID: <efa6a28c-f0f9-4d1e-9cce-fec2c08e7d9f@kernel.org>
Date: Mon, 19 Oct 2026 15:24:11 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/ksm: keep soft-dirty and uffd-wp when merging a
 page
To: Samarth Narang <samarth.colleges@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>,
 Peter Xu <peterx@redhat.com>, Kiryl Shutsemau <kas@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Kiryl Shutsemau <kas@kernel.org>
References: <20261019010934.697895-1-samarth.colleges@gmail.com>
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
In-Reply-To: <20261019010934.697895-1-samarth.colleges@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DCF8210000A
X-Rspam-User: 
X-Stat-Signature: 5rot5jsx79esrsbpwdbkref4msf415e4
X-HE-Tag: 1792416256-279267
X-HE-Meta: U2FsdGVkX1/ONlm9H1tTykVWGLCX8HZizF1wH5M0wJTf7kPMxnAaB1py/F7Eayxe7MZx/RLKcZpFqK3wjSbWIjgacS1P4PYTpazJugbxkY5ZOEoVivpucvVpIXP6MCiQ9QBAotQC5loqcjed2m4FPz/ij9V/P3tyxwwwYEqGDAUpu21ht7bLczliADy07vlGtz3gJ7r69C5raHNjnPfAEMHTr/SY4gCCCPPYxKx92EJZkWLS4xKwyVuYynt6rMRKRAE8x7MJuCnl0BjHIQ61uTejI72AI3UdfpMkHbMUYZYQvnDvtTbnsTwx4UjWW01C1wlzcpsPUyduIe3tBlN3366QA/wjBHdWRD7hbo7tjlvuAr0aR345uVWBPD6fCcVcIXRGZX6lT+gdzMVjyZQEtWDs64v3/3mMn2TiAKsA16Q5+tgHBnWjXIw/rWrBiP5Q55PRssHxcnVwnfiSZKHwO3/6pde7MkS8LXdE1ZJQaFNidzmLMIxLu9OmMDHkRmMKh9K/mYA4K7RNYpga+FEEMGFil8OEOVKlJyntAuWEe7iuaH8+D7XFuxX1drUO5YQfxkKf3BoX6Qng6eH761TNI9ZB9GlPBPTBUpZZexsWN1VMtXRyOqsHYu66xAi521k2JQuYqdFQ33PnaUQWYucW6XDhObplMET/vE0A+ZhoNzvZLk0nH1yzVQf79+zvp/9jKYsI3Z6PLqFLDPULjMv2IvaowA/gU/duvz162APv5pSbUphVcmryXyTulcPnVuzLjV7i4mW51Fp5o3CKwgZIpwPIKFxsdfg7QxTZjSpmeJwqQ7nhVm0Ps3bkpChuirwd36dlXlf4k+ftHQL8ZAINn67PJfhVwXy0F5cPI5wBsGeY6mxSxlqPiDvXBtwr8BzcYkBRuglplfM6ai5tDFCjlOhX5hszHgDNdSe8LKvIMarKR5E+FO7NfMB9R963SZJxA4I0l80RHQldMB6HRNX
 RfaCPka0
 LOyIgWS5KyTdFkhS654EHwfdOlsovYrME9YyCxp3KE9rVHpMe4nw9b9mkYsSkK84KUQAUpYkxqibtPIjvrGwgl91VmA3QkutED3YrmgqqxmB+xXv3mux+rax3UdJ6wgJZPcGd/XzR6ppQlAXOENagj4GUhK2qQ1SRmCqTdWM8xGDFmjRsHicaYtx06qWOEQyNtppjz6HynKyGBQ81ADzQNUSH4apv73s1HJwBmO3vgKd70tOAdYS3/0VaMoRnbYaPw2Nff6rcHAgiGyIPCXRGPkrYfVLf09OBplbo86hiwdQRTK06MUdMN1Zt1nW979Zm+cOH+7qY5vl9j7Cow9RdRitbLw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/19/26 03:09, Samarth Narang wrote:
> replace_page() maps the KSM page with a PTE built from scratch, so the
> soft-dirty and uffd bits of the PTE it replaces are lost. Due to this, a
> write before the merge no longer shows as soft-dirty, the next write to
> a uffd-wp page raises no write-protect fault, and because the page is
> mapped with the VMA's normal permissions, on a uffd-rwp VMA the next
> access raises no RWP fault.
> 
> Copy the soft-dirty and uffd bits from the original PTE to the new PTE,
> and restore PAGE_NONE for RWP VMAs, as try_to_map_unused_to_zeropage()
> does.
> 
> Fixes: 0f8975ec4db2 ("mm: soft-dirty bits for user memory changes tracking")
> Fixes: 63b2d4174c4a ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
> Fixes: 2d427bb01639 ("mm/userfaultfd: add RWP fault delivery and expose UFFDIO_REGISTER_MODE_RWP")

I would actually split that up into separate patches.

Over-indicating soft-dirty (as raised by Sashiko) is in general not a problem.

Losing WP bits is.

UFFD, the gift that keeps on giving.

How to deal RWP properly is a good question (see Sashiko review). I feel like
some more stuff might be missing there to handle this correctly.

-- 
Cheers,

David

