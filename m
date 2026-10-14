Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2990DCC6B1A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:37:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB7586B00A2; Wed, 14 Oct 2026 05:37:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8ED76B00A3; Wed, 14 Oct 2026 05:37:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C57666B00A4; Wed, 14 Oct 2026 05:37:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 901C86B00A2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:37:19 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id DF7784048F
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:18 +0000 (UTC)
X-FDA: 85320728556.21.F281633
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf02.hostedemail.com (Postfix) with ESMTP id 145F580009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:37:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Md25q2/7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791970637;
	b=3tVZDVL+apMgFEDCmNEcJB8UNIa7ZxDsKMCZsXxa5gvTjp+eaNhKVd47ZpoMsbNdKCDz6D
	yiQff2qtK+2D6Hz83xXPANDVIiWR28eVLCevvKJEjWSt6fSaxTsG7r1S/euCXJDsnrLXCL
	/ltz4eP+xYfQhxd7Eu1b/5AnfDdokKo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Md25q2/7";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791970637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2G0A/3OONu+QthUk+8RoUXZZVX5MxzQK4zcElH7KTo=;
	b=yMruPjuOZB13IYWuGIFOhOcj0UKIXZ0nOzyH91FVs4+LSnemk+TDXEWK4cFhPl7V+LBAvq
	tWYI8OryMyMRNYA2hQmunT9QviDKgWRbVXGanNGSHmboLfXm1qkjAdCY37cHCKxdwE4XG8
	qfFDyjEDZ6aatVUTB6AKSS7OEim1C0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22AE540475;
	Wed, 14 Oct 2026 09:37:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC701F000FF;
	Wed, 14 Oct 2026 09:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791970636;
	bh=+2G0A/3OONu+QthUk+8RoUXZZVX5MxzQK4zcElH7KTo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Md25q2/7GRPy3HBELNBHL7uPX806RGT67lCZfLnSBsUeXUM6XEDfdGJ20wgmzESxB
	 BNDrLWfenVgPPRBuyJF/xnomNAmAXkKnAN3BOHThnnzLiIxlnmAeyoneb3BRBtw7C8
	 pSr1jnxuo6Ol0etv1XXLWTs7GvNhxUMsp+44bXeK2bEGqX6JUOQ4KnRBUZLb6Ko80R
	 Ou/NDuR0MuGRoLb/SGPYiJTu1yLgQ13YlNnuvn/2M9B9ag0IGRwfB3RbJGp2xqM1lT
	 iDQYcE1WOA8t9OxfkoqcAVFVITy7fAoIK3Gl12LetkJ0b+fm1xS4QZ6opCzMpPTxZh
	 UQbqqrxEHmCMQ==
Message-ID: <ef5b6275-d15b-4192-a278-ab23235956a0@kernel.org>
Date: Wed, 14 Oct 2026 11:37:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/21] mm: change behavior of pXdp_get()/pXd_page() in
 compile-time folded pgtable
To: Yeoreum Yun <yeoreum.yun@arm.com>, Russell King <linux@armlinux.org.uk>,
 Huacai Chen <chenhuacai@kernel.org>, WANG Xuerui <kernel@xen0n.name>,
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>,
 Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Tianrui Zhao <zhaotianrui@loongson.cn>, Bibo Mao <maobibo@loongson.cn>,
 Anup Patel <anup@brainfault.org>, Atish Patra <atish.patra@linux.dev>,
 Paul Walmsley <pjw@kernel.org>, Palmer Dabbelt <palmer@dabbelt.com>,
 Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
 Dave Hansen <dave.hansen@linux.intel.com>, Andy Lutomirski
 <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, x86@kernel.org,
 "H. Peter Anvin" <hpa@zytor.com>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jonas Bonn <jonas@southpole.se>,
 Stefan Kristiansson <stefan.kristiansson@saunalahti.fi>,
 Stafford Horne <shorne@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-arch@vger.kernel.org, linux-mm@kvack.org, kvm@vger.kernel.org,
 kvm-riscv@lists.infradead.org, linux-riscv@lists.infradead.org,
 linux-openrisc@vger.kernel.org, Muhammad Usama Anjum <usama.anjum@arm.com>,
 Sohil Mehta <sohil.mehta@intel.com>
References: <20260921-dummy_ptxp3-v1-0-cd40cf68242e@arm.com>
 <as36bbrMVHOESsLd@e129823.arm.com>
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
In-Reply-To: <as36bbrMVHOESsLd@e129823.arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: gnbujdfkrze9dqmf9r5cf5qmyoyjgqdb
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 145F580009
X-HE-Tag: 1791970636-720719
X-HE-Meta: U2FsdGVkX1/poPcIy8Akt8oHWrZgL5nZHHV3HInARzKM21UYoauFflZg1SuYoWZ4wtF7Fn4TsDBeYyps47V4k60rOmv8IF4sBTSmGiSErAOl/uABpVoZONm0RblbQMKAZuojG1Xo1586bOm/LnESjWf0QHyWKnmtOnO8Qq4iGz8TffPm9MhfogRuM3MSVlasDnZU40WLhpDZuVuUDWzUu6qxvecYs8LgKiZj9tyF/sGHtdJOXE0Nd6l0o8uy0uB9JvGKbOHxX0ABKpLJlnWapHYBtGPpIFb6XU16HaMa6qnucplyyyu8ea4MNiw6q6UvcWJlwmTt3mZl2tKjFV/nD9m9ycg1FWzfCsjk6leL1VcHVcpwqIm1479N4EBrgKeTiMPGN0qwxCT4lBpEb1X3EEUySU5/1gtXOYsc15H73G8rGK5+ZwTWOA6WH+rm+GbJRsYJ/tl6Y09po+SXO+lFKmZ6ldNNSaiYHgRd6CPCV5dtMYAJrtt/Q14G17stW2uKzi+tuNnbdB9NncPvxYCeGwYxkq9GQi407+mH6TOUgLkK7xyAft2JoI1s8NdX+oLF+lcRU+tQ8QIPOci9jSXFyRvBv74hjAnCb55jeE+odrdTBZ3cJASnVUUr4NIj35T5fXXzANvY3x2sWLdg9zKF8FVPYTTpVCTKN+Nav3svDe3gC1WEx+yHW8sx6ZVf+LTErkqj2bxZ8JEE8eToOgl6Cdffo3rj97j9YPBzvqHMGK8jl3AJQeKhO1GeQKkBgyZN6UEHIlvMBs1Bv32/GG6V5NpZBWRAeVx5eu5RFPwZeq58KT1MkQfrKsh5El87xIGjan+pVgUKU7CYZtxwblJK5TogDM8ZXZeNhYdgRMW+7Y+mXgMriObRpMactZgTt9xfLxyS7lEqOZzW9bGtZCY+p+dHcU4zYyMaiKxijTBXMJlqsXS3t6mAMas+3wDfJZN5M7AkZD9ZFIpPYpFgV++
 ZoH5Fe52
 9xHXHU99mU4q6Tyzb+CeP3HTPL/+o9qaXYqJqR/C/E+gyXWfGbtN76edIGe80+6/L6OLJh1xUp1r4JekJHnLed7TNkF7boQpAHNn0qL4Zxr4kFUeQEiu4MIvYKGXzZiTIasPFeov7tLgNmhc7Rw7UqTnkpG9nhR2mNSrB9Qe4ldotze7OzFhpKDr8yhSD2x//NSub7A4jJJMmAtuFuuMg2h7fr5v8wbZZTsO4lHx+2+xGu5ScsPsE6lZYTmC/X0O+zRsd4aS0sGaHHx/qQtpz4zjBM6MNSueJyuz8RAnpynUGO0gJwOamWUAnZA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/13/26 11:31, Yeoreum Yun wrote:
> Hi all,
> 
> May I ask there are any further comments on this series?

Let's resend after -rc1.

I think most arch changes are reasonably simple and uncontroversial.

But I'd prefer if riscv maintainers could have a look at

  [PATCH 11/21] riscv: mm: use proper set_pXd() for generic compile-time folded
  patable in vmalloc_fault()

You are working on some general vmalloc_fault() cleanups, but until we have them
I would hope to get an ACK from riscv maintainers that this temporary solution
is good to go in.

-- 
Cheers,

David

