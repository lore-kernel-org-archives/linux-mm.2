Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36A67E9DE5B
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 07:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A3EF6B0005; Thu,  9 Apr 2026 03:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 554CA6B0088; Thu,  9 Apr 2026 03:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 46AEB6B008A; Thu,  9 Apr 2026 03:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 39AFD6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 03:54:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CE0611A04DF
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:54:13 +0000 (UTC)
X-FDA: 84638254386.18.8CB464B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id E2570180006
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 07:54:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deUTiNJS;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775721252;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FuWux20iUqLwlWHsiLowBSdiDzURl+/x5fFZ1Y4ba1o=;
	b=Onj/vvQIbYwAW9DicnERuoZnu/wlrSDNUpotQ8jCoYmsfcBXPSjAec9OwtfUuTecWDfyWs
	Rl6MbA9Cxp8ssMHqJ5tDGr+iM2mIEb+oMxzEUdx/22zPgdJ7CpwwYeoQRG8QX+IpRpUZYt
	brOVDE0UIwq2btY9IYuEydy/5jNjnpI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=deUTiNJS;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775721252; a=rsa-sha256;
	cv=none;
	b=JzQbzNMn/DcQgPsEDO74coRCag4bB5+TUjlTMJT0gMAXcE+CxUGo0++W9HccI2HrkwY/JE
	LO/fapYWv5DRouJzCH0dxvuVYMaWwdlAnGasbYX7IJnuaQaHcLsrWArqJXC+ePE7CELgea
	7KBKmFsL8dor8CE0/dRchANvU3yV5uA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0978842DDB;
	Thu,  9 Apr 2026 07:54:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5667EC2BC9E;
	Thu,  9 Apr 2026 07:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775721250;
	bh=2AqO2B4PoeUn+NsMyrRZTH4RsKgtVTRhCrCLeTcVFlE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=deUTiNJSP/4r5rdX5GLZayNjEt4CNzx1LTHSgzzSedi5ZW3OeZna2VYjrQPX98BRd
	 m8jfbGQJGP8MwZcRA02aKJNCAdkB0TBAOIqic3YOWHL4t98EgrDTJAZQgC6qpWG58Y
	 wZmWBH/0lJ2JFCIo6QUpJ7vWeVVia/L/bzsygskAhxOM5GZ38IbYiA7kS5nTi7HnE1
	 GvQj39Ws0377Ye21Trcud0ad9xerXoqHtxIMfvaZmaHmkaWAI3Gr3cXe4XwYcxaKFy
	 vmC3dE/zBCZOpCEEEJ5aDEKdVBbCIY3NryG1/n/0KQVbU3ABOxBy4Zv5RHJJ0QatHh
	 3VxiqLDit/Msw==
Message-ID: <e3f15b4a-a010-43bc-a07a-4fb387c06255@kernel.org>
Date: Thu, 9 Apr 2026 09:54:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: use ALIGN helpers for PMD alignment
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260409014323.2385982-1-ye.liu@linux.dev>
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
In-Reply-To: <20260409014323.2385982-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E2570180006
X-Stat-Signature: mf9gqy3nss1h1swzfxqn18rmndj8pqgt
X-Rspam-User: 
X-HE-Tag: 1775721251-262292
X-HE-Meta: U2FsdGVkX18CuDapO0oLg1J8dapH10IKYBdgHBF8sKxmhp0dvLtzWhspdFSCxUF306YflqaMPJEZ00RgEo3OPDvIe4KSitXx81UsFRO8R1PIj9LXomowVPYbFrhen8sESiZ9cPyumgYJXfd1AXLPdAl3/1B7fkiM8TaVvnjaReoLWy/xjxgK23sUDtaSQXDOGOxDQy4SxqmCYXSPU5Gb+4LjVPiF7tJXCayqAjzfDDPjwD0IkNEaOPX5OCCjtoK/U/h6Dpage/IV/2PHNCHlQnEdLdS7Gbc5NKH5EMQZG3ijHfZTrI1L5MLQtkawpRbIJG88IdS6jrKj9yC3D7hVKC2W+Rq35LBi54rXA9n7VSi48345DAr6Uyr/yWjpwnkltYtoqXxFQXaBfM2w4L90RlEixvyVzX3tiUsE1QX+WYpXaI/MwP8lF8TrT0CiYmMwqKRRRdc+4MrHH2yU8Pir4eLeaFwKrmiRTSjEe3YR8A338gkeEcrrs7S2dz7p9zRY+dWW7dBtFQL5GjRU/dgzTxqqAM6L8dNNU5JlD32Fcl+J+2fYEBAA77VdIxHFKZiE4+ki3bLMQQfOLeKS3C7Utn0qDURBHDCOUhuAD66M4UgXQ77O2risE31YCdqN3fmGXq7zfrwK2bcu6HSU7jpwGtMeBRdtP6h5eMx3CIcqLoV8eCIWWwg+BiThW2X4U0sq44FENqf82zc1QniAD5OqtELm254IHoPL2kLS0pdN5GPmWW2o9ch6y/gZ1quQFW9Y55AY3vrlI45K0OfMf371clPbiuaPDz68th9AelLFUUuZ7E8W7+s7ceZyEXxSKYPQ4EZ9PakYVbpJ9SSByD6O6UKwmvqTTZil4PnIT8qxTy2bV5Wgt8Z1UZtyRjsbLzwi7/qzZd5HRkWwBBxYo20Xbuqwa7zGEQWBpQFGRw3ty96Ll5LBhTG7CO9tOyAlTRN/oRF68t0fQ2o2O9awek3
 MC1RcHPM
 TXbbtYhM228Y1fv1FPv5IYmRfbH9IuCXG9CKc6Nf52t/pmI4tN8EglK2+wujRwClYa7ZpDJUOe5Hnc3LOpyZkUWB+Y/xeb/BDxKkrp21m6LoB2UiqORbgkuQEGEKbxePJmCWKnceh6S+bzLXBH+zfUQAYVPkodMCoVDORTgbjy7QDZR4Jx3s4lH1Ar8DKPghUyQitexZ0TbXegVtJzphZrGb4LEL/W0JZVS+f8JhYHQxVW/37eLfPjUzRxTSjhtdfeUBy15wmY6YuYwb9u9mi3o2X0ehxr6arav9Q
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 03:43, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> PMD alignment in khugepaged is currently implemented using a mix of
> rounding helpers and open-coded bitmask operations.
> 
> Use ALIGN() and ALIGN_DOWN() consistently for PMD-sized address range
> alignment, matching the preferred style for address and size handling.
> 
> No functional change intended.
> 
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> 
> Changes in v2:
> - Switch to ALIGN()/ALIGN_DOWN() per David's suggestion.
> - Also convert collapse_scan_mm_slot() to keep PMD alignment helpers
>   consistent within khugepaged.
> - Update the changelog accordingly.
> - Link to v1:https://lore.kernel.org/all/20260408093534.2373007-1-ye.liu@linux.dev/
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

