Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE8ADD2CE17
	for <linux-mm@archiver.kernel.org>; Sun,  7 Dec 2025 12:39:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9D56B0005; Sun,  7 Dec 2025 07:39:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4831F6B0006; Sun,  7 Dec 2025 07:39:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 34B716B0008; Sun,  7 Dec 2025 07:39:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 206AA6B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 07:39:24 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ABB9F52B26
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:39:23 +0000 (UTC)
X-FDA: 84192630606.27.6A4A1F9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 03458180010
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 12:39:21 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j0MPFla5;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765111162; a=rsa-sha256;
	cv=none;
	b=d5x9uXulBt9aNQxWGKBf+l4m7V0Zt9ij3Hq0Bicf3zqbLMVr37DcHt2TpyO1MQzj9kVQEp
	LQtzM3io9yAe+IP9n6BkNpjP++V1NqNTmgrBIy3jlwbqcVC2veoiRAHr7Jaii0LYydm8z5
	HSn1DD0/8AXA0nTkAw1S3a7Bhtp1wuY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765111162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G+tAs3zNXiqRvuXVGF6Pctt/OzAoFUsb7IrHe6WohS4=;
	b=a+bxm6QwVi/Ui+T1WXD5e+RGtqImT7FS0JFJ/3AgDKUywD6IRcviF9ch8ke1uWfoOlozLy
	HfCGV5w2BMr1npdrvO0wwWdSuTxX3iAt6WoK6pZOIIyTdn6NLvK6fE0zw8HVrwMtdGlh0i
	caMTMul0sAKt56iL8q860VyU0RCCi6E=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=j0MPFla5;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 1A9D960008;
	Sun,  7 Dec 2025 12:39:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3E14C4CEFB;
	Sun,  7 Dec 2025 12:39:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765111160;
	bh=EDc/Ngb1HhThAXOD7k5e16o4L5UdHvj6G/GaIzURyHE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=j0MPFla55Igf6JYotD4zn3bR76m/U/xQjs3q3ZMqJopt9AYI0rPAlbxo+C0QqslCv
	 eKPyvW19I4GQDtiTkAhTrQD5nDqmh3RthlxWAf8lKyoagQbNXZFQ+xaJAuR/946JXI
	 4LhPNsW6osRoKI5nbkX68Lcndo7tXjSmvrR+hJONbEJtOoV4m0O8mr8cEx0vxOqxVM
	 F6IBzsyRzU0IlQNIcCB4WT9GU/1A913ajVoi1VzTGcPNcnviFPdZ5tpzSv2hMFkjOx
	 j3cGSrwa0orHQroytDD03PY2FkvYDWoPXLv7Whw72v1O1riVVO300gsqy1Ccvt8B6a
	 nw/aLSciIFdBw==
Message-ID: <3a408dd9-a38c-4202-b79f-91bff843ee82@kernel.org>
Date: Sun, 7 Dec 2025 13:39:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 4/4] mm/hugetlb: fix excessive IPI broadcasts when
 unsharing PMD tables using mmu_gather
To: Nadav Amit <nadav.amit@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
 linux-mm@kvack.org, Will Deacon <will@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Nick Piggin <npiggin@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>, Arnd Bergmann <arnd@arndb.de>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Rik van Riel <riel@surriel.com>,
 Harry Yoo <harry.yoo@oracle.com>, Laurence Oberman <loberman@redhat.com>,
 Prakash Sangappa <prakash.sangappa@oracle.com>, stable@vger.kernel.org
References: <20251205213558.2980480-1-david@kernel.org>
 <20251205213558.2980480-5-david@kernel.org>
 <0914A8DB-447C-4E62-B151-62E5E4E99749@gmail.com>
 <C9D5EFFF-05D9-435C-96C1-4B13134E2904@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <C9D5EFFF-05D9-435C-96C1-4B13134E2904@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 03458180010
X-Stat-Signature: gh6ynjga4hkywgir9jhpu8iykbhm18qe
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765111161-519719
X-HE-Meta: U2FsdGVkX1+gH3CZR5uXdPIOLYOk9UBNhgsSz1PQ9iLFKiNBupVl8UAJNiFuS9fUh4vKPg7Si8xBwmx4VJmUr5Ul2h3Bap1fn4R9Q7TfNSuhDLYFpQ2uNqPMWgTrahEEMJoWMR/5r2yRwg3C+pWWpTYVipjxqBJZ12oi6QjhRyN791+8GaO8Q+HcaXUEI08eVn/Fzt0xfTWUGij9p9DcDfZsFP8Cbi26Sz+DO1fbyqUcY8rdbiAFctpQBe6//tTNfxa6PK2qCzigk3ngELJ+e1h8j2lALWlysArRo2KekcUWDHAdVPr8CDvRk932dSyM8+GLe+srVSeYK689OSuDfWg5gY+XI8nGecUWiq7Bza0IC8YbmxOSF5O8A1HKu79LJJsJuu6TapYW3QUjExHvtP/HxMZWVXeFe0zYHr5kJIZFd9Dz58UodMAWrYoIU2BvbEky+ttexdaKVWzbxSOmTPRklH/ugzGnLLVe9yRZAlE3TawmxqYP8+W7w2P0eky/5DQjD+LyCr6YQyuzZA/tAH+vpCOwQ+sLsVc+1icO70iZE9zyXVT51eePRELLWLrvLMDm+KVhCUJDYmmgiWx7AqnsGc2mk1BM202O54Vy80Nu2qAUp9/8jmFQ034XsmJFutjj7c5cVD8YillPI/RGpyp3wIb/6d21NUwWW08UZQ50YbzTvGYRaCVWxUl4T+h/0d3SLf3fDEGXVNUeYIBFLY7iKAHVjz/FsM//gvwXm57Mt+Z2fBHhyOBVLXXV9MSu1mS4EBbWK7ctEl7fhFuSy6qj6Q1VAr7+sB6cTReD4xPaSqOy7zMcmLP4uoT4j92iqdIOkq4lsBdIzEVMRKb0ng79IfIQlWi9hCB3u0QsRHTA18mxxPrww32/Qf0vRMwMU1FF8xiFRGMDuOHk7ntNZADMH7rubMeloRFMjXaS2fsv9lVsztNimAvwoEMUi6L/CXFb/BUn5zsNabYoBtQ
 ITf5T1L4
 /d+kRl8fuf3AIYBMjXA7E4H13QPdtGal9TKTe12kWsKFyU2Itz4L7GWzDR1KdosA+e5oNxoRKMLTv+uXwRiN3i3eHdx0JvOAjmSXuyd+MFutaCUQcKU9ZZ8RUAoN69mS3OHqAEUoIyXSzZ9XbyANbAR5ZFcsedGU+dsquI7qTORwEQpUYxdbko7WAs+RZs7d+f4UN28UbC6DUELvW+W9VUpWMk1lUdir65l5edJyuv2YcHhkr2SaYyvXpcLtPR/AemLXEMjyya9jzC3pFSQQR8UjQo+SXC7Kvk3CUAu6phh3pX3g1/8ieIPw3Pbp21X/H+UsPjBwK8Wm6f2SuEYJxBf8qzfCR3pCb7RlMt5wukS99bAk3eoWOS/hHet2sM4LGlzhvVtIz/cySlDIPjheYq5jdfH5OmosgnMYP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/7/25 13:24, Nadav Amit wrote:
> 
> 
>> On 7 Dec 2025, at 14:15, Nadav Amit <nadav.amit@gmail.com> wrote:
>>
>>
>>> On 5 Dec 2025, at 23:35, David Hildenbrand (Red Hat) <david@kernel.org> wrote:
>>>
>>> @@ -400,6 +411,7 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
>>>
>>
>> @@ -400,6 +411,7 @@ static inline void __tlb_reset_range(struct mmu_gather *tlb)
>> 	tlb->cleared_pmds = 0;
>> 	tlb->cleared_puds = 0;
>> 	tlb->cleared_p4ds = 0;
>> +	tlb->unshared_tables = 0;
>> 	/*
>> 	 * Do not reset mmu_gather::vma_* fields here, we do not
>> 	 * call into tlb_start_vma() again to set them if there is an
>>
>> I understand you don’t want to initialize fully_unshared_tables here, but
>> tlb_gather_mmu() needs to happen somewhere. So you probably want it to
>> take place in tlb_gather_mmu(), no?
> 
> To clarify my messed up response: the code needs to initialize fully_unshared_tables
> somewhere during tlb_gather_mmu() invocation.

Good point, __tlb_gather_mmu() needs to initialize it explicitly!

Thanks a lot for the review, appreciated!

-- 
Cheers

David

