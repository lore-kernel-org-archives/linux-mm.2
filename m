Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1BF7F606B2D2
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 13:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OFjB3ecx
Received: by kanga.kvack.org (Postfix)
	id 2BCF96B05B6; Tue, 10 Nov 2026 08:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 247166B05D4; Tue, 10 Nov 2026 08:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 115796B05DA; Tue, 10 Nov 2026 08:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E25E66B05B6
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 08:06:32 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 79741A8225
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:06:32 +0000 (UTC)
X-FDA: 85419233424.10.C39AD1E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id B2702140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 13:06:30 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFjB3ecx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794315990;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Ss5SZp6AbzZf0QMiHXB9m8r1DMlRHB70XqYyD/5vww=;
	b=uuOE8qH1sSWrJZuzMJ/Ei2v/AOGCMVNHf5G2GoxPGsMpt9/4mrsQvT1cgaGW5d0vPky4g6
	0lupBg4LC7i8FtLRjuKJIwBKZ6WpYQ2lFHboDvBRmrYaIBrBzZGCQxd+ao3cnb+KUXh7lS
	fstBdj3Xw9letDRVuXov6ilg8YBF2g0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OFjB3ecx;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794315990;
	b=vwqz7AP8ua4kFyUuvZylE1VVpPZJAEOIIJH0J7JtxGmDgXUBNP486Cjs/Ittdqk8Pmtmu9
	PEmgYkOKUJQmxYcb17Uf7TMV6aKYuiVJ2lwkIstI1atlmRjWdBIRIDaAcOLysG8DhpuMzl
	wuV6u5A+O7eIpoUJL6WSq/KPLuqSjmM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 38FDD6337F;
	Tue, 10 Nov 2026 13:06:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA9E91F0089F;
	Tue, 10 Nov 2026 13:06:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794315989;
	bh=/Ss5SZp6AbzZf0QMiHXB9m8r1DMlRHB70XqYyD/5vww=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=OFjB3ecxYngOo0b+pMl92LqbwrOyoUX3eXL6vkaSGjtkybyELg8tj3YuMgUWjydFN
	 WeE5IdDajyyW33aWwGVE9U/BqLx7Pu9W7s7P5HjyIi8BQavYgF1ZmTUFIhGU+eVqzI
	 hCpVoZ1np/YCM9BfAu484TDGZef5wY/rvFtbnoSSPuNltd1WuEXUlUZYyiDLDt3spB
	 OlHvIRXn1UTb4JQ5LE8FQsOxNi7nR2VkVNI2oiW9cA45w5u9jJyDZlZE6JjfWxNZOi
	 gtOMznbd7chtWx7n1tQ74/BO11E6IiaOcQnx7cjd7dBln+EkLhCJJZ6E9cyEWUlgZO
	 FZ25Ss9ldjPdg==
Message-ID: <32632bac-2cca-4341-8fa4-f5565b56b851@kernel.org>
Date: Tue, 10 Nov 2026 14:02:26 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] mm: gup: move gup_must_unshare() and
 INTERNAL_GUP_FLAGS to gup.c
To: Yeoreum Yun <yeoreum.yun@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
 Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Andrew Morton <akpm@linux-foundation.org>,
 Rik van Riel <riel@surriel.com>, Yuan-Hao Hsu <aa9736195201@gmail.com>
References: <20261109-refactor_gup_fast-v3-0-2aaef02df0e1@arm.com>
 <20261109-refactor_gup_fast-v3-3-2aaef02df0e1@arm.com>
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
In-Reply-To: <20261109-refactor_gup_fast-v3-3-2aaef02df0e1@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B2702140007
X-Stat-Signature: 3okht1wfdbdmd8pwxm7pwpq93ix1uzx9
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794315990-263350
X-HE-Meta: U2FsdGVkX19SQdgggERAxJ0wdQ6ztCFF3j4bNysEfMLCsPe63Wp+wVtihNEAQVTOeT7ytMWX7oo6YI0L2lVoLAw6AF3FupY8zShGEVfw68gQkuwP8kz3t849FOXgRRUyPt4s+BmaqWrttse5TG+C0iTsmh7KZnZH5BVaAsWk+Qx0KJWpZ2Y1RYXdq8SNbJ2tGubR0MnLfE4YJBcrwyamdljw2a5XhJi5GBBx64n2scc8VxD3WUOfk2EBwOcNJCgr7QZlmSqDEw+ppEY+gT4ZEkInwYmjAKxo/B6lqQY3Q+KoTIkGLp5GtDKYB1sEPKv1TNjA3ewpeC9rxlxp7JuosVhQgLG10fh3MEUKLKGseTKMpWcvaI/Qfm5/SDHmPwis4nG7MtHwmzhA1TtL7a/f+ZqHMBJouckEsh6k5VIg8Ty8W820F4hT+jjk4RxFQoClmhN+otfi71QxbZTZ5be3wGH1ekbA9Gw/m+5kQGqU1U3y/r+kpQ50i3+ZniElRIaqyF3o6c0Y2NzbSIb8YLcqD6Sd/nJop4MlWdauXJimeYrnL+8Mvel0bWtRLy94v3PfOoHDbcFvfBHAoB823Fr0+KWkWaxNcxuhaMq/mAF5fJy85UjUX8V86ysLRK6S7XxSA0Zc4JFS0LEvn3Po9ZZjU8guzDhmjYNhPy8vPHnF3wTyCwFj7xoBrBofoi91A8CGfPMuTcS2KpgespGECyV6XywFm2HodnNYQmCLC0M9nV5oSawikROjQ73W34mFoDQGWh0A2CKOf1Qejn6mt2zTYrlxmWoshARtLdCExFOp2C57pvdmPycP1aRG26gqeiSy7lQ+W2stXozoAChD9DXzNMQ0v6Hhznaajk0ZUuwIJE9F4/VmqZ37qDp9iV48xZ+gXgyqmPSpSc3rZ/M++Oic0qIw40YodCABQQPdLTQH9ULs9PFjgbtBG4wds6KoPVKCLOzNID8SLsdF1Kl5apF
 DMrC2kCn
 QVSVq6Z1YIRIyJm4clps/3WbAyXCB6ObDCMGgwUcWuUKPzOPKr3syWd60yeE0mD7sh9ZgzCrC9qUlpfTU59yx3RD1KFJvQ7xqOUzF1+vTpafIU07Zqn9XYLQp6z+KrJWgFVJBd0BJYmuu7JOWrx3zmG50djTEIbJxpSA9uY6cU9MGJbdvSQe7aIpQNRjoIUWqdPAWFSHBHNc+axY6RL4zubrOu8J/IVgoNgkIfeP/1QcXPf1Cn8pGDU1TXt1N01BPitcUOdwuXWFNLamtsRjbdCTXrmmJGSC+/PQP8vc/+H+1+Nt10SuSUuL68ebZ3WIkwhH+yLjg3Yn0JfQ8gSSlg3854dV+Sp54UIQKvRk8P6VwpLLfL3jMEE7cUDO7I0a3HGWlbZYsI9NH4FY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/9/26 13:32, Yeoreum Yun wrote:
> gup_must_unshare() and INTERNAL_GUP_FLAGS are used in gup.c only.
> Move gup_must_unshare() and INTERNAL_GUP_FLAGS from internal.h to gup.c
> 
> Signed-off-by: Yeoreum Yun <yeoreum.yun@arm.com>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

