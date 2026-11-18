Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 88591606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 10:26:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Mn/Zrkoe
Received: by kanga.kvack.org (Postfix)
	id AD8606B00EF; Wed, 18 Nov 2026 05:26:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89836B05B6; Wed, 18 Nov 2026 05:26:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9784B6B05B8; Wed, 18 Nov 2026 05:26:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6C56B00EF
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 05:26:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9C1781A06C8
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:26:38 +0000 (UTC)
X-FDA: 85447860876.06.CF609BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9AA09140009
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:26:36 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mn/Zrkoe";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794997596;
	b=asjFmuvZ7wsiC6w6wuFx9157LYoJ3yCqTTJIIxkplGGL6hwyvfDEdM1itVIhY8XmhP+Cr+
	rzW92ApvTbdgxFiPzgw2ncG356gAf/4KagJTBXf53mcbxkTV9F9rU3OKDUvSAZ24DZe8c+
	aSYfG7ZNjpb7WgRqA1WiQOeCO7Ierx8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794997596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Jv+UoiRybidtTIhCZ8L+Fb7Gei05WnQLxDeqowwvbS8=;
	b=OW5FMdzmb7eVwN5V53QFLumqJINdzT7HKKztzZ6M+Mci9QXGd7g7+L5Ey08XPwjpSkbVo3
	Y9btObOzQzWBdaHy2Rt2ghvGbqdRYARQL0Sy/e+R9UjJcC1d3ReaAyDhL5ejeY0A1KgUZO
	wIrEY80M5y9SQkyLxg9pItYlBqSX+vg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Mn/Zrkoe";
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E6274124A;
	Wed, 18 Nov 2026 10:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34F081F000C4;
	Wed, 18 Nov 2026 10:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794997595;
	bh=Jv+UoiRybidtTIhCZ8L+Fb7Gei05WnQLxDeqowwvbS8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Mn/ZrkoeJpF3VOgN9NmX674NzjrCwfHej4ZSjjnQKiZpmPIyPbfSs88/SnoppoYLs
	 GmBtZCwkgjsEz8qMGAychmwikeKOSi5c9EFG6T1ccT2Dr2A00Ta9JpqnxIjqHxBI1z
	 7bvNlTP1WYOgLtdPhTzbxe/vIqZV9mfZMlFo225JmdJgZjAGFNiWLwprcz2YNfgIFE
	 fQfnSetp8p5Z7O7tQdBWqzTq55DQjx4bYv/DFPdpF5WlY4EVNUKJKco6myEgaQnQQE
	 At6dCGjKUCtNg6Nq5joEknVeMwYJimRcd67A+ILvQgl0BGF8TXPWazanqdm3B9nPJa
	 QrDnzXrHJrubg==
Message-ID: <2a93c7e3-be5f-4315-80fc-fa05bd260d6c@kernel.org>
Date: Wed, 18 Nov 2026 11:26:30 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: shmem: limit forced anonymous shmem huge orders to
 MAX_PAGECACHE_ORDER
To: Jingyi Sun <1045704958@qq.com>, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Luiz Capitulino <luizcap@redhat.com>
References: <tencent_69A761EE2ABA6F15B942EBF0EE686B2DE608@qq.com>
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
In-Reply-To: <tencent_69A761EE2ABA6F15B942EBF0EE686B2DE608@qq.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9AA09140009
X-Rspam-User:
X-Stat-Signature: g1bfy11o1jhjc5zgg4tm9rbfqi3udzk6
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1794997596-587622
X-HE-Meta: U2FsdGVkX1/Xymm8KgCzqrNwtzEZr3RyakqKJRxQViTBRofll48uff14RwMtcCfz5fACwOjDR9r2G0gTric8ELDVsaFrAl6ot0ARPEMy3rCRG+B5oTSvPZtWU05iJRZ3GYmaHtPk+uvs+lMdVjlDtYPSh4bhlPIguFiNmmEE2P0v+JTx5AyvRYHjL2Kkcie1nzLIl+vnZv8SYY/oE5cHgb22vMLlTo1/+eLXyprgA/di1CsdG+1CNplLNM6dhRvBxWSjLgZm5DQldUVBQsd4ZGJCt6QsTiOxSirKTlHaL2zqCijpDO8KAZPOIfhMX22oERqMWzWNYFV62Gw/TnSlQDtJ3tzOr3wxyUlOYIq8bqVo0LOy4rNUqN4RMrdqz8Mk3IbhmMG/0Fqla+jWrmOKDpaJzoSO+0DQcaHnYZAt5Q2C+JbQ0bXodGEmKAAmiQfneNYm8GFtxvuV1ylmYAC3tQ4uaPA4vSWPUkIl/Jjdu1fGHKSvHiAm30PMhabUrO92r8J45dun0JsATTQqIPmQX/D71Nh11lxBPva/jLtIg0m06PeiaLrNIRwlZ8/EKOaEhe0BCJtI8MfRKiTM8CdlthMgZzROtEUaYvDVEXOz16EMypWNC+poPFyN7qkknxJtR3Im7gAUk1X2Y5pIEyArV7e567+G9009R6yct4kdaSmsyOLniUvcEM7XX2/3FqoqNkPX5YFikUQbpCTygePKBsFjnUv7w7c4P0aJVvJECXHyXneT6TbbOQGhL19gss9uUY/bQtBS4ZdmfgeWDAoUX7Eqw2c7Tfv8BZR8hGkVF9p6QKoABv5P8DZQpkSZ1ryN0NKxU05a4liTMeuTgCXKHUXNST9VLpjGB4s3Izd1+G0yaK2NGqdyUgRvkxlkKVfpZEO70Tu/gWkymnZH/vsgRRwSmX0ZkrRcFC8RRrz3gKjrgSAwsVuQqaWJvbw3C+UHtbW1tnTI+4Gk65zFwZF
 zifJUcWO
 1+bHfw8p2yd67axReULGuyFyeRlFIHhvCVRcBnYI3NWFeoyQtpHooyhlBvkaI3MZjVrriWGnNodh923HkoFUQNGozrLvscj8UAFtvlmd+si9DxYCsgkEzhZ01yk5KTuJrWyPweVoAcFW4sWjAyfND7vypMkXbj3t/vxbcOTD0Sw9BmSwcEIJliRMX81xg2QttvvUIBxg8bFHBNG/yGcp74+Jx8rxnkPwi8V+p/ivutZeEAFK/UlmbumynBPyDhbodtQmzcFK+i9RxRxuVSSLo+yTKBrZx4O4+OD4yWOd0IoRqxMJ1X5kMfPehdHHhxbEU6yBxYXoRfGyGcBD+twyRnU+lG/xa4jFVGVKG+0amzIeOlrc5PgnXrV9g3Y0L1i2bzV1WETnT8/YMRXQlnaqsoCEhY+jPKZSBu5RmCpvuCixVL+JjjEIcpSCh4qncstiYESqKpF7WK613BlabCUnttAQbanDOYFpt/F6czGKeOIsNCZWllUME57xubWTH/oRAdkIR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/18/26 11:22, Jingyi Sun wrote:
> When the top-level shmem_enabled knob is set to "force",
> shmem_allowable_huge_orders() returns huge_shmem_orders_inherit for
> anonymous shmem without masking it with THP_ORDERS_ALL_FILE_DEFAULT,
> unlike the other return path at the end of the same function.
> 
> huge_shmem_orders_inherit defaults to BIT(HPAGE_PMD_ORDER). On arm64
> with 64K base pages HPAGE_PMD_ORDER is 13, while MAX_PAGECACHE_ORDER
> is 11 because of the xarray split limit. With shmem_enabled=force, an
> anonymous MAP_SHARED mapping can therefore get a 512M (order-13) folio
> in the page cache. Splitting it later, e.g. on swap-out from
> shmem_writeout(), triggers
> 
>   WARNING: lib/xarray.c:1051 at xas_split_alloc
> 
> and the split fails, so the folio can never be swapped out.
> 
> This is the same problem that commit 9fd154ba926b ("mm/shmem: disable
> PMD-sized page cache if needed") and commit b66b1b71d7ff ("mm: shmem:
> avoid allocating huge pages larger than MAX_PAGECACHE_ORDER for shmem")
> fixed for the other paths; the force branch was left out. Mask it with
> THP_ORDERS_ALL_FILE_DEFAULT as well.
> 
> Reproduced on v7.3-rc2 in QEMU (arm64, 64K pages, -cpu cortex-a72,
> 4G RAM, zram swap): with shmem_enabled=force, a PMD-aligned
> MAP_SHARED|MAP_ANONYMOUS mapping of one PMD size got a single
> PMD-mapped folio (ShmemPmdMapped: 524288 kB) and MADV_PAGEOUT
> triggered the warning above in 3/3 runs. With this change: 0/3.
> shmem_enabled=always and 4K pages did not show the warning. The code is
> unchanged in v7.4-rc3 and in mm-unstable, but the test has not been
> re-run on those trees.
> 
> The issue was found with a research static analyzer for
> cross-architecture dependency bugs and confirmed with the QEMU
> reproducer described above.
> 
> Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
> Cc: stable@vger.kernel.org
> Cc: Luiz Capitulino <luizcap@redhat.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Jingyi Sun <1045704958@qq.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

I'll queue this later.

-- 
Cheers,

David

