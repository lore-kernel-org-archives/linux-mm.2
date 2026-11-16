Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9EF0E606A32A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 04:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=l5EctVU3
Received: by kanga.kvack.org (Postfix)
	id A17E56B05B3; Sun, 15 Nov 2026 23:16:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C86E6B05B4; Sun, 15 Nov 2026 23:16:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA5E6B05B5; Sun, 15 Nov 2026 23:16:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 661A66B05B3
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 23:16:11 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E3363408D0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:16:10 +0000 (UTC)
X-FDA: 85439669700.03.3009192
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id CF768C0008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 04:16:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l5EctVU3;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794802569;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7gT2JuiYFAN6v3dLuKfgKvKI5F6TdDS5679fODV4+m0=;
	b=eqmM0ckP2ZG8CxjNxzvzgA95dUgRNzNhYdkRsZWEXACQG7nZ236gjv0ukpuEbZAK4eVJW8
	RGiDzP4KnXMrO0enwJnNz+Os57jJ2WytmxgpPADnePR6HeAtdKu10eSnpSbv3SE5I/PM2L
	BOV/c+pxpiohkT08RsTlrLctjAbH0NY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794802569;
	b=G/xrB8hFZ2VBwk99cEdjmd5rq7YHTldjud0xwSm1VHw29+czZOvVfdwR1cXGnx5mmHoAQc
	Q4BhvvmAAno4FSBQ+Z5z6gkos1inj3wo8ZtNEZRjDcMU44WWBbmVH9CU9QonwU5N9D66SS
	PMHmIgDA1X5f2Bnu+yg5TsJvJ7ubgoo=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=l5EctVU3;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B1CFC1476;
	Sun, 15 Nov 2026 20:16:04 -0800 (PST)
Received: from [10.163.155.94] (unknown [10.163.155.94])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A34E73F632;
	Sun, 15 Nov 2026 20:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794802567; bh=07M/qatRqX8GlvVNpZ3BxRX/Cpixfubu9N9NgYkUMYc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=l5EctVU3pqdnc7UTBpxl7faldAhr1+sj1M1TgRsDoWwuRaD2Ni+NCqfZXSPrBLEV9
	 nliJLVvf2ZoEHEcuVd2Fib4wJkUcAwjA1hb95cFt3SEwx8elzzBENTxWTjUGc1ZINv
	 yMczDVQGRVCg2Py6/j4qGFIHtEmai+BzkruYIMuQ=
Message-ID: <253a1587-0f76-4013-babc-f7c9c0295eee@arm.com>
Date: Mon, 16 Nov 2026 09:45:58 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 5/9] mm/vmalloc: BUG_ON() on an unaligned range in
 __vunmap_range_noflush()
To: Hao Ge <hao.ge@linux.dev>, Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, Dennis Zhou <dennis@kernel.org>,
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
 kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-6-hao.ge@linux.dev> <avWtxcH2mKw7dgbp@milan>
 <cea5d9af-435a-4708-a937-59c7cbcb169e@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <cea5d9af-435a-4708-a937-59c7cbcb169e@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: dj791gzbgbygyjafpufboj3zm7dxtkzf
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: CF768C0008
X-Rspam-User: 
X-HE-Tag: 1794802568-472185
X-HE-Meta: U2FsdGVkX19GHPcblD/LaFZUGaUD8NchnciTiA4tqETRq4H4HzrugR3ccT/9v7GeNbfJfFFLOdXEPzukLCQYy/SmGrCfsWurwr+JlyBK+zDlt3cResV5F94ewQBc6hA2GkcYg+FQQd+vKlcaEZvSE7g4P5fqrZVGTB2R7BjgTQgbJHuDi5OXEND1Ef1CNVaOwXgT5QSHOCqUNpK1mC8Koc3ZbnrWkI+Z4og40+TFRoHE04QWWPcxDIqnvO6UJkLdBozcDKt/BgL/fZmHtiFm0JCJDMNxt0zDB6qSe1EvP0e6Hi1YaKm6NohiX5ZiFznRlqNY675WtpVf2wXSOhfvoaxVs7oxfVSw74Hu886A7lFnBe5oNzto7JMBoBPmqMhXheYaxeMkYsvY5EaRp2AhNZUX4krNVErWPXku0UqVOBBLr5p7dk9Q0YVfnpBmASacTL5k9Y4dn59Gd6dssRGaio1rWWABS6FCYDmAsqLLcFprx+VphqPx5CJPXjnI00DSxDIFb0xSgECTTvVF0I9OnVfE7bhgaOCHujFAln0NlM6zGgPZzv0LnDt+Sj2kGPCROjdC796YccmlnD9SP165UNdUoNwyh+UV3+0X44DO/8Yu/N0yCr91nYWMRIo34yneW+InYbfT3Bb9MkW8KcyqZ5nNcSczJCDgFoVA4eOpHyEF3KxIDbKdpTQb+vHgLsoKo7LmA+P81+e6Ig13K/JjQNtFWbpVgbKuPTCLKauL0bOXPIaBt3U8VVc3sxoAJvR0u1qrbtNqEoVq9RUvHkArYDqr0L5xre+JT2tIndzuoiIEo0TnwL5dr/xJiasr8WG99jokhC50mGOkOPEBJAJFD6vF3joTvKjXFAq0BPU+22ocDpJFOrK65ujLvpVcF0p0YHfMxHYolAG9PuXgLVnwlWLHyBZAbdCcSKDaO64701SnI0jdqmyPWMec+VSnsdl5aIvUecwXmC218H+NzSd
 O7PNNRau
 Q/3WQ0/Li+cDYDPfnDAS7I/6wnTwbDFk8FwQXeACiP158hQpA3C9UhB/Rca6FZWmhetTwY0DXpw6JFOWsPK+68F/0c8nM7lUd2vHtkXlI3DV50O8qt/6CLg85eb+BM9lXq+NwR49K2qmZPbR3gYdcDqm9pebfwtwEsooZ7sbI9wFjxlFwvrxfxS1XXgGYdsa6Qk9pKPPql/ba5Wog7Of1eg60BVaajVaqIZz0BN43o7OQ/VSgLXLSei6qqBfZcb6iXqbACL92J2JS/mMZzNzc//GvHLibIow2+YJQeOQ4wP+GOoXQp/TSRUMZheDi+Tb/zPG6e3OfmxM0MH88k4R3Zx2FzlQ6ZpoJokGiuWPLmWHJ71Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 16/11/26 8:51 am, Hao Ge wrote:
> 
> 
> On 2026/11/12 20:15, Uladzislau Rezki wrote:
>> On Tue, Nov 10, 2026 at 07:25:42PM +0800, Hao Ge wrote:
>>> The PTE loop of the unmap path stops only at addr == end.  With an
>>> unaligned end addr never lands on end, so the loop walks past the
>>> range and keeps clearing.  With an unaligned start the loop begins
>>> in the page containing start, which extends below the range.  Either
>>> way the unmap clears the mappings adjacent to the range, and that is
>>> nearly impossible to debug afterwards.
>>>
>>> vmap only installs page-aligned, page-granular mappings, so an
>>> unaligned unmap request is never a legitimate teardown, and there is
>>> no way to tell which pages the caller meant.  Check addr and end at
>>> the entry of __vunmap_range_noflush() and bug out before any PTE is
>>> cleared.
>>>
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>>  mm/vmalloc.c | 2 ++
>>>  1 file changed, 2 insertions(+)
>>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 86fbb1d2b27a..0565cbfe325c 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -518,6 +518,8 @@ void __vunmap_range_noflush(unsigned long start, unsigned long end)
>>>  	pgtbl_mod_mask mask = 0;
>>>  
>>>  	BUG_ON(addr >= end);
>>> +	BUG_ON(!PAGE_ALIGNED(addr) || !PAGE_ALIGNED(end));
>>> +
>>>  	pgd = pgd_offset_k(addr);
>>>  	do {
>>>  		next = pgd_addr_end(addr, end);
>>> -- 
>>> 2.25.1
>>>
>> I am not sure this is good to stop machine at all. WARN_ON_ONCE()
>> and return?
> 
> Folks tend to dislike BUG_ON. Dev suggested switching to this when I sent out v3.
> That's fine. After all, nobody has hit this so far. I'll switch it to WARN_ON_ONCE
> for the next version.

To clarify I had suggested the actual check, not the BUG_ON, I thought it is a
well-known fact in mm now that BUG_ON is not to be used : )

> 
>>
>> --
>> Uladzislau Rezki


