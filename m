Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50CDEC88E53
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 08:09:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4052C6B008C; Tue, 15 Sep 2026 04:09:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DCFD6B009D; Tue, 15 Sep 2026 04:09:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 319776B009E; Tue, 15 Sep 2026 04:09:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 131F46B008C
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 04:09:33 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id EC6501C207A
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:09:31 +0000 (UTC)
X-FDA: 85215272142.04.5D84BD0
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf14.hostedemail.com (Postfix) with ESMTP id AFCF4100006
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 08:09:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DfjZHrj6;
	spf=pass (imf14.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789459770;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=20Fe+I2cMVs5mxtZubUVJjijWQvsdk6rS2l+/KpMrEo=;
	b=AzXrwry2b0gnF6nU9z1SepegJpWiWWwkX0lfaxhug5bc4vGc3uM5AByWgqjWrv+JDy5PM+
	IO9XdKbRGPz/ml0J86gjnSmuSIW1ApobnhgqmjRhZMNtWMM11YtBRy/FVD6JFMsS8qkUY4
	+xi+0EW/uOBIFjG9NGBe2Pb5isNQB68=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789459770;
	b=GRxaO0yY2lShb3HfXE8HhNXvSr2fSrXbAumRwjgSh2pRGue19bPAaNyd/VX8vj/O+6fs+E
	LW/7AddgjMV+8oO0ZxXyQsupoljkjO8tXvq6bLou6OQN2xzD0t3FKRsMIF99yb/0zEa87G
	XEjEqcN1V7hNrBXuJIXIRO4eP5PsgqM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DfjZHrj6;
	spf=pass (imf14.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BkVd9U0H4Y6EudAIncziUfkCyRdScrX9nZaOR99Nz6k=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789459768; v=1; x=1790064568;
 b=DfjZHrj6G1MyB2GA9MrphguV2Gfsts1XdFRNq7jjG2eg876c61r0OsxKdl5S4F3zZOuTIiHx
 BOAXgc/UY9WqGwgV1KcqduieSq611kIl3/N1bUxGGVo+tv3DzQZUgQzmVgihp/XYgPDj3dHj40m
 v8AzEWkseUq+Vb7ly85rjcL0=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 84fb79607566e710;
	Tue, 15 Sep 2026 08:09:28 +0000
X-Mizu-Trace-ID: 84fb79607566e710
X-Migadu-Flow: FLOW_OUT
Message-ID: <ce56891d-8302-411b-a396-66f40760b3be@linux.dev>
Date: Tue, 15 Sep 2026 16:09:14 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove unused exact_nid parameter from memmap_alloc()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Kaitao Cheng <chengkaitao@kylinos.cn>
References: <20260914055130.44543-1-kaitao.cheng@linux.dev>
 <20260914212200.75878c86ab806c7e09b6c69e@linux-foundation.org>
From: Kaitao Cheng <kaitao.cheng@linux.dev>
In-Reply-To: <20260914212200.75878c86ab806c7e09b6c69e@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AFCF4100006
X-Stat-Signature: w8ngxou1k95fuenqqfxtufskc6t76ufn
X-Rspam-User: 
X-HE-Tag: 1789459769-27988
X-HE-Meta: U2FsdGVkX186ppk5jqEDQAdFIAVZysp4/o5htkd0IgGgMnX82usyNMs2y0cCjUYRpa0DvVuPqO4Rhu4Z7TeCGtLkg6cSRGDPfgf3hK2W8cjpx3EofdRhYk45j4r4ryJT09T5e8evrY5hsCgsnxNHRD1bL/kLk+ckHgaq6dR9K+9YX2V7pDqJwjjtwW2X11fRqGKq1okPFn4GQxNCvkATNajQu5Kv0mWY+lJ4gqeY1oNDjepEHWFEwmJHR1yyu7J6nyVMwHYoMzFc9OUq7NsxaDiuNItzHkZ6sSMGefa/zTN9nD9xs4zEknSGpsJlwhojkm8mRSMs1XI0FShWezUfiqEjcb2DfXiLqOgo9FcNoHe1UPP4FQ4aq3FMgWMD0pp4R7HGAetC0P+FCjQTmt4hj0lE8B4+L4sbeBUaFFlR53ZBa737lwJnry+jya4CBVaZ6f6yqafTR84ix1yirPHg5cdGNp85HjvFss30fWtzgaow/ka6Hhid7ZLpSZ0K3AfWowaxZzhi26IbjpZlYgoVZOarNXjmJmT3ybQt1YQSwNmU2ShWUWZfK311S1oko1Okhjp7iOdT2vYPtQ9nVljs1ut+IQkcrosQCSzWkubiLH4Ec+Gu0Twrvxq3M7AspNXapAOaqS81fu5gqF/OwLZcTKUvfU3z44Yhn42OF43mIwmCJyc704ZlV6MRss/ISx9tZWlLAFYaufFbH05vjoARFsufhvkWJ9zxS8R56Bne4nI9UEP0ib0JjjIvhqL+TS9NzkPIGNPPadC6Zyo1+UgatCLTyPHr0+OO4Ji1a2Lq80T7ZlOFhs1s3ucRiyT1QaJSpB8IeAXP5nGhGiISQvrGUNUiIp8Od451Wm6Ll/PcvNJ6IGzLx6sii8BZmncagabVZ8ZDHyaWhRafi6y4yechjtbeJAYWkBQlJ0dmtv1AaeBm0RJx4JeiXrPiQj2VhTFFG2ELJZyZRFyWz83BMN9
 //AOUTT9
 JwxOXr/8WmQ8p7uitaTt8Czef8MTHza5/Zj6E9Ppwnimn8/I/wZtF/v12gAVjluy3yZAOHmt2MP+qfd/QVFcHDkXxml7k4TasDO3imF3wSIc8yUVRMjfMAcWxp9nbtipEfaaX/67zQCKVXDqGzmiR0InmWlSWyLF79IQbfkj8MdD5KaCyFvv49x9KqRajIrei1jfsHLpBP5qgkL5vxMhOT5meEyRoprgwVAuWsafdxvj/A1uCXB/71ZTN76UpxZWTbv8rpDqu0XSEL5RUH/HesdcADayYjEhPJJHIiSuqr2HGXCqKgzJRpI9ULni+LIA/HNzsS9b2124+nlhBhq0v8pEz0vwg2jxpBmXj
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



在 2026/9/15 12:22, Andrew Morton 写道:
> On Mon, 14 Sep 2026 13:51:30 +0800 Kaitao Cheng <kaitao.cheng@linux.dev> wrote:
> 
>> From: Kaitao Cheng <chengkaitao@kylinos.cn>
>>
>> Commit ffe55393137c ("mm/sparse: remove sparse buffer pre-allocation
>> mechanism") removed sparse_buffer_init(), which was the only caller of
>> memmap_alloc() that passed true for exact_nid.
>>
>> All remaining callers pass false, leaving the exact-node allocation
>> branch unreachable. Remove the exact_nid parameter and unconditionally
>> use memblock_alloc_try_nid_raw().
>>
>> This has no functional impact.
>>
> 
> Latest development code has changed quite lot, but this was an easy reject
> to fix:

Thank you very much for helping me fix this issue!

> 
>> --- a/mm/sparse-vmemmap.c
>> +++ b/mm/sparse-vmemmap.c
>> @@ -53,7 +53,7 @@ static void * __ref __earlyonly_bootmem_alloc(int node,
>>  				unsigned long align,
>>  				unsigned long goal)
>>  {
>> -	return memmap_alloc(size, align, goal, node, false);
>> +	return memmap_alloc(size, align, goal, node);
>>  }
>>  
>>  void * __meminit vmemmap_alloc_block(unsigned long size, int node)
> 
> 
> --- a/mm/sparse.c~mm-remove-unused-exact_nid-parameter-from-memmap_alloc
> +++ a/mm/sparse.c
> @@ -215,7 +215,7 @@ struct page __init *__populate_section_m
>  {
>  	const unsigned long size = PAGE_ALIGN(sizeof(struct page) * PAGES_PER_SECTION);
>  
> -	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid, false);
> +	return memmap_alloc(size, size, __pa(MAX_DMA_ADDRESS), nid);
>  }
>  #endif /* !CONFIG_SPARSEMEM_VMEMMAP */
>  
> 

-- 
Thanks
Kaitao Cheng


