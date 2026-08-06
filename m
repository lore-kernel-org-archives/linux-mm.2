Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8C23C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 13:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E46BB6B007B; Thu,  6 Aug 2026 09:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF74C6B008A; Thu,  6 Aug 2026 09:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5DF6B0092; Thu,  6 Aug 2026 09:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A31636B007B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:56:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C5744076C
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:56:49 +0000 (UTC)
X-FDA: 85070995380.23.9DBCC70
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2525180013
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 13:56:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DkGAyZHD;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786024608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MC7T7ylhK/aLr9fs0E5SYbo5bCKm86oRgZDfYL13AS4=;
	b=vkqlB8fnbQcmHe83PBte9RpRhRjpyxXh7a4coYZFHOAhTmh8pLLkUj+m/wEFQUWoMdwD8w
	NtENyDry3g5LBZamplEUajAE9zKn5UXw930XWX0Ry2mI62+/xbPqVVAtAQBL1WCUYLlnl3
	we5/SEVy+KWPLaS+UQpat/0HEKPOyrA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786024608;
	b=7qkiqhcuX3DOiBGKWncOzBhlK6C0Fbr/BtVJ15oxkHNZkZFrMg0MdO7MUwOP3G/aWU/wnd
	5LnqgkD9d0UP4Fu3Bhd+uxTK/nuuDCyEhThNVFglDYY5NQ7CGaqrl//oCTul6mhkO4BpGL
	9c894eFYtWP+SSwUg/gpkr8f7gsn1Nk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DkGAyZHD;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5C2EB43252;
	Thu,  6 Aug 2026 13:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2DC41F000E9;
	Thu,  6 Aug 2026 13:56:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786024607;
	bh=MC7T7ylhK/aLr9fs0E5SYbo5bCKm86oRgZDfYL13AS4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=DkGAyZHDVpHpzU+8ZKASQVokbVrEOI2Cii14k622zjZ3cwd+Ne0Csvoj1YN6XENG2
	 H6pM+hFjLX144QIABtWKyQNdmRNlQqAo9KOZsuVMgPVI2HU+aYeTA9WBkxKJNTvsxl
	 7lZChMbTyMO+ZcnZwpoSJDoGdnUcZbnQkAzLD6/tOGHXr0yGNSzKAn6ZkDwDMKs0a8
	 0AR97NvqqDYbqVSd9DbVAOHVoj5q22bDD3m9UmUPN2nRhjMnbqYVKcDVrVMGzfrL1D
	 yQUySxekwYv0qd9PjbpnVJzwEnJ7+7UZ1Avixh4y/xFPoppigmWx1aOBhr/5xfa9vZ
	 Fxwf+avkzMfBQ==
Message-ID: <77a27056-555e-4395-b71e-e777548750e0@kernel.org>
Date: Thu, 6 Aug 2026 15:56:35 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v5 2/4] mm: distinguish large folio swap allocation
 failures
To: Xueyuan Chen <xueyuan.chen21@gmail.com>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
 zhaonanzhe@xiaomi.com, baohua@kernel.org, hannes@cmpxchg.org,
 youngjun.park@lge.com, baolin.wang@linux.alibaba.com, hughd@google.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, baoquan.he@linux.dev, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, rppt@kernel.org,
 surenb@google.com, qi.zheng@linux.dev, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com
References: <20260730122304.2496440-1-xueyuan.chen21@gmail.com>
 <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
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
In-Reply-To: <20260730122304.2496440-3-xueyuan.chen21@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2525180013
X-Stat-Signature: 47iujrkwz98tb6w9z18oc5q1pp7qhqha
X-HE-Tag: 1786024608-455696
X-HE-Meta: U2FsdGVkX19yJu5z8Ix6WarTdIiakFu+a2QnkDHXJgrEXUV0Chg6gPm+b4NMz5S00DMrSX62q80faIDrejW7C0swBLj8/6a2k1yl+yGsSLupYMgmbmNta8+/IKKJwyV+5fE5sQK9sjqX8p7YGXLr0VwsFqOckAOi0qU9RLmWaL+YnXkX2IntcIgzncQn8MxM4dFn2O6U0JN322NOmJFCb9m/CtsX4oLAIIhBamSe/k804IF9rFABo6FgvRONTYcr94/ZSTZmWp9f4ZCuw4gAdw+ys79tpMEwBy1dPnyzizS9ezdnPLU1caixpQcef19IXSbHU7hzX5t+Kk2pbRpD94fmooLw2LuNtPLrQH0l2ZflXhdJ1FwPIweMbCiDQ+7+XSyX2MSv4ZSRn11+OpNmSwlqR6TGFSi9RJCJGTmD3ql2bF6Fpsb9/Os2kGGrtzDzFl+pePWuJhYtdh3sCMKIRbQ6dkRD8jwlVHqgTEw+K/Nf+ko2SkF1afxCiIVLDfu48nPAZR7IU2pAAo2cqrTmjjaAluRBdvBge3f2Z6Lsd39LA8aGCifgCtFshBLfJ0hL2lYkWJieje6OrNi+85UkYhOiwdLo6z049FBb8mU0ISqxvKSD03xzWlDQf/0vu/qqTObCkJ7ZCxuyJkws3GxnniwcHVnjaVBkj+T6jGkj3jnrkGOKPfq/HVGb+yBkcH+zKV4HiD1X2UtX+k8NLxq4tzzUsrxhG0fZW89LLJDKLdIX+jvLd9encrjFlkjhHKMYliRxlCi8XeKHbp/gGyvat3Wl27qHLzM6RpThZkiMo+7YL8/f1uw8whjXM+o4CQ4bDSwW373nRdD39sSO4QlVXJV/560n7lqPoIFCqF9A740PxDFrLxQQIW+edWhzEjMI3ejlxyYh9LV4qwLQ2aaH/vOveqRDb1OqTZZc2+uLS5Kco1duEPE2okJ1VNFdPZW9XIp7Mt7wkpv06uID2hr
 SWKKMjLa
 tFMSQWCHm6JIo0Hp+/9qqoIcOf4dcJnu6swUVMY6ShSXdJtFJkAzmXr2rDxtoxADl+2D/Fmr2wxGRUonQBC8AZfaebhhDgtyVmCex7vuN8lCVAccru5B74CfoIQ3GLFcedFKD8ofkgLYaV2YKBKUFekFRaO4ZWK6bfPl3HhufcAohagEGqOMMQNXQqZWxwn6QirAnFNjA5aYNq6ITKU+GNkW/bE9TlDMLCluImhjPHwlCwns/lu4v04qHoK4GHpvTqLD3WPUoQOs96sMILoh2WAhdCy2fhK84dgacSgZnDqNEyS3o5tdbrNAoHOnwVXVIw7Sp11cGb43kcwtiu2tEG4EFKpD2kbDyfcIr5dIj4EZjV3A4qP/r0j5bp6nqrf1ULGrBI/4EwyovcbGNzHhmLuGYAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/30/26 14:23, Xueyuan Chen wrote:
> folio_alloc_swap() reports most allocation failures with a generic
> negative error code. Reclaim cannot tell whether splitting a large folio
> could make progress or whether there is no backing space at all.
> 
> Keep the global free swap count and the remaining hierarchical memcg swap
> margin as separate inputs. The memcg charge path reports only its own
> margin; folio_alloc_swap() combines the two layers when classifying an
> allocation failure.
> 
> Return -E2BIG for large folios when a smaller allocation might still fit,
> -ENOSPC when no global swap space is available, and -ENOMEM when the
> failure is not helped by splitting.
> 
> For early large-folio rejections, check global and memcg swap availability
> instead of returning -E2BIG unconditionally. On a memcg charge failure,
> swap slot allocation has already succeeded, so use the remaining memcg
> margin to decide whether a smaller charge might fit.
> 
> This only refines folio_alloc_swap() return codes. The reclaim callers are
> updated separately.
> 
> Suggested-by: Barry Song <baohua@kernel.org>
> Suggested-by: Youngjun Park <youngjun.park@lge.com>
> Signed-off-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  include/linux/swap.h | 16 ++++++++++++----
>  mm/memcontrol.c      | 32 +++++++++++++++++++++++++++++++-
>  mm/swapfile.c        | 32 ++++++++++++++++++++++++--------
>  3 files changed, 67 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/swap.h b/include/linux/swap.h
> index 0544b2ec4c56..7d12058174ae 100644
> --- a/include/linux/swap.h
> +++ b/include/linux/swap.h
> @@ -509,12 +509,13 @@ static inline void folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
>  #endif
>  
>  #if defined(CONFIG_MEMCG) && defined(CONFIG_SWAP)
> -int __mem_cgroup_try_charge_swap(struct folio *folio);
> -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> +int __mem_cgroup_try_charge_swap(struct folio *folio, long *swap_margin);
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> +					     long *swap_margin)

Nit: two tab indent

[...]

> -static inline int mem_cgroup_try_charge_swap(struct folio *folio)
> +static inline int mem_cgroup_try_charge_swap(struct folio *folio,
> +					     long *swap_margin)


Nothing else jumped at me

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

