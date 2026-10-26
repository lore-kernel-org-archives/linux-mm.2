Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838CA606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 21:09:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=f+UaSY8l
Received: by kanga.kvack.org (Postfix)
	id 52DEC6B05B8; Mon, 26 Oct 2026 17:09:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8106B05B9; Mon, 26 Oct 2026 17:09:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 359276B05BA; Mon, 26 Oct 2026 17:09:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F34106B05B8
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 17:09:53 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6F8F4C064B
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:09:53 +0000 (UTC)
X-FDA: 85366019466.27.951258F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 95A63140007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 21:09:51 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+UaSY8l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793048991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Km1rvIZ3U8wdp/hbA44AgM+K1KBOJrLBa2SNISYlT0M=;
	b=eQN0KxVM3OKKs7/Nnv0lurdJDVhxMngFcTx9sAyWx2RM/lZJIlICpGGqbC2SBydtI2/f0U
	+404+tGB7G0pew0VqzxxFg1XuDNEhXaAjVHK4d/tsV+bRcWsgj7LgKoi0RiZFGkkpnhw42
	6LYNu7Kr6ztkutQo9NIO6mZky2JoaKs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=f+UaSY8l;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793048991;
	b=wU+3KKKErwUhO9uHwc4XNG4ZLZzOohkyp0KVydzhmB/SydNjQlYQSoy0WoWTjlzCYEEVBr
	1IptzSwjV83lx4P+FLqeIjrIc4Zz3D4WE/cZQR60Qy0n/K1oE09JfWMg4EXGe3xkI5xEzN
	G0t3u/LLMXLC2oDdUnhPylSuc0ZllsY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5879419F0;
	Mon, 26 Oct 2026 21:09:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05771F01825;
	Mon, 26 Oct 2026 21:09:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793048990;
	bh=Km1rvIZ3U8wdp/hbA44AgM+K1KBOJrLBa2SNISYlT0M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=f+UaSY8l63lGr7187Oqi5dgWlzYCfWCFaR+aTlR56miEamPTBI4jbIlQqtDV4H+mh
	 BLRVFIVd9jZkJpPOplQT67gOCLCjIxjBiDjg6DWbAS1RCwcdMi8TkwxsG5AcBeLf8j
	 8hgPaTi/N6aVWdyw6QbM8e5ynYzOOsMInDRLXP3Tk2Cxm8qnQvFd0ecIYIAEwDwjD+
	 GHnAbdyPr1B1jcq0txZD4N+6/U8T6KlIS3FmJXW8dej3Z66+3iVYyi/v8kCg9+3zCq
	 ST/TH1O9+5Jop7hjGAp31uVHgqKJq3BTf4vFndIHSV+Da7tw148EFhdvLcMoJWhNmm
	 m9us8+cBvgVMA==
Message-ID: <5d10eba8-11cb-4031-84e1-a394ca5b4cba@kernel.org>
Date: Mon, 26 Oct 2026 22:09:40 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
To: Gregory Price <gourry@gourry.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Ying Huang <ying.huang@linux.alibaba.com>,
 Johannes Weiner <hannes@cmpxchg.org>,
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>,
 Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Lukas Czerner <lczerner@redhat.com>,
 Carlos Maiolino <cmaiolino@redhat.com>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Stevens <stevensd@chromium.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 William Kucharski <william.kucharski@oracle.com>,
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>,
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>,
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>,
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <at-yaxmjeOXtA15M@gourry-fedora-PF4VCD3F>
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
In-Reply-To: <at-yaxmjeOXtA15M@gourry-fedora-PF4VCD3F>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 95A63140007
X-Stat-Signature: rdt18c6hamr4qkh1htknkoqb8oueyic6
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793048991-217524
X-HE-Meta: U2FsdGVkX19zPzcAL+aSHduHFxPFYCo6HY81cV0diNvG4y49X+mgY/pGbJ/ViuZBPc5TcOR3gZE54wNC7k7o+bHLVjs3YG8YmGjrad4HUgDVjGQIFXIrpepst0j7Z4GjoltPa1zNQVnZjYS0ACPQGOw8Evt5WGj8mYIfv5LbEALDCqmiI1uXKwsHgSQIZxpT4S03KqqhdUpY+/cK0/RDpExPXey94TBLO1D8QRj4fssvgtwqyncVksM47xZThlYN5kFJYBVdDHLoVkX3KNlNl3H6u0R9ifAbVB9LXDTK3UXTdoAiEBhgbbsH1SdjXwqcCmZLH9owXxiXmQMnWJvEJdtDZPkvqUBxzoDeep1a7Fh1pUxnFpsPQH6jbD1NHTCxnoZf9KHTm/7hpWAKi+v1hov0ZV2Mlnf3sh+VMlAn0eCshyBI0JJwYdVXiaHu2QXn5TjuUxHeJl1ypVysZg0k3iDcp4840eLUXyf35eaX8O2w+M3o7MDHTTXgi1SJnON1fD+BFSpVdLU9mVU6/Cn0aZqrhQ8GXmyq+1Wx6/wrBNlRLG5ohtFPFy01yzfk/wY5GaerFAlPiFneXXqsq/+L4KMlA60RleaBc/kPI47LuRfFMY10rxxj302FSTZ46foslPbpdOVHug33HQkfpZMa+Kt2CAh8xTcNFKxxhDoPAz3Om549lHVMC0n/i2gL31HcazLkqknH6neFTdL2FR/JNXLVXlDa0re44HhmCI6Tjus1QfYMTAeCoapZxgMbx+2JNGlS2eWmNBJJbJP+x19aug+wdJl3zNQjJUGPv3P4bczOHQB3/Vsa7hP75hvVF/fDFAsFK4KgS9Ui9ejfSHt6LceXXQ2yLOpT+tkBeizd0JbWLrwdsIyJ6qiuF+MyCqbhyXG23yBgo0acFZi2YHhRy8vC1NzRkPcJOnIwezbOuf2/sKNQgQbhnHHXQvD3YI5zQiMThK4dyEiB+wcGMim
 DAMKaUNj
 +ow+eOvp8VG0SgmUqdfk/tBN+Ps8wA+DfVofyGMwBbsNHo9PYttmpi08BqrYRdj4hrRgG3TwEV2svjJQ09JhVx+vRwCYHmAS3ickjgSwXC7Ekc/cTngqIL3x6FodRJ1cwglZ1M2eM8N0omQrtWwk+JX9vVzokaoUAlTuQvSTk0a3uIxwpQRuiBhU5HsFjg0pOB5rrm13LY/9fUhfl3LektFld8VaSBw1uejWLNw96joXlO06ostD8/PnvVcFoZ/tCvUC+EBQEuY4PmbEGKiPKBdNunlcGpV1laewd19a0wyRNm57QNR9fC19s38FKYXmB7QDpMzy/2TlhdTgPjzJ3f3UiHJL+yfFrl9ouwVZRuAAbGJbrbW/zTAZrw4CIkjcVqwRfs8IgqZyc72gyq3vfkIuH9jkjtZ0s5Sf77wZ4jQ2Tl6pDravwy8sZHw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 21:08, Gregory Price wrote:
> On Mon, Oct 26, 2026 at 10:40:33AM +0100, David Hildenbrand (Arm) wrote:
>> I did my best trying to test these fixes. I was able to reproduce some
>> of the things (including unkillable truncation hangs), and the fixes seemed
>> to help.
> 
> Given the (urgent?) you're the unwilling recipient of my schlopp-testing
> harness.  The good news is that the selftests (attached) all look
> reasonable and reproduce quite easily.

Thanks! Yeah, I had ran a bunch myself, but not as many as you managed to
trigger I think.

> 
> Everything below is largely clanker-generated, but after a review I feel
> comfortable with tagging this.
> 
> I was able to directly test:
>   #1-#5
>   #10
>   #12-#16
> 
> so for those you can add:
> 
> Tested-by: Gregory Price (Meta) <gourry@gourry.net>
> 
> feel free to take or leave the selftests.

Thanks, no time to polish selftest ;)

-- 
Cheers,

David

