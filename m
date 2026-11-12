Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F671606A33E
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 07:00:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=owLrm7cB
Received: by kanga.kvack.org (Postfix)
	id 543E86B05C1; Thu, 12 Nov 2026 02:00:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D37A6B05C2; Thu, 12 Nov 2026 02:00:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E3AB6B05C3; Thu, 12 Nov 2026 02:00:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 150AC6B05C1
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 02:00:41 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9481C1404ED
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:00:40 +0000 (UTC)
X-FDA: 85425569040.28.3909B96
Received: from mta0.migadu.com (out-105.mta0.migadu.com [91.218.175.105])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5A48FA0005
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 07:00:38 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=owLrm7cB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794466838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J4xIggD0g8SlhhtdOwMFrAXrBVevW/MmjFyooXoSNeE=;
	b=mKwUmWFy8Z0y3zDYtifcVFeL6dX1Vfcz22TJUPo1hjWZbmTssgNoTdPCAdJP+94/GFb7RS
	nLKL+94S0jxzw7YhVsZ/vZO/KXYKpr9ipX8uwaF3HSpqg19alHQzdZ9prh1fflOe3kHt6S
	ZfOAM31Yp/ld4XkhkpSk6RmYlPouzwM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=owLrm7cB;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.105 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794466838;
	b=FSznt8Vbkz7Pm5lOT0S7/wyPblFO5Q7XMXqzxONF/9EJFaOo+K2HhojqZQaMUW8Ezwg5Js
	NseaNDckB7JX4Rq+7HiMmeSDq1yAUtmeNb8cbFhIKVW/Hs7P6+FRk3ECde/lhSzZRb4hbi
	z+NrmzLpiPthSmoSCnLLWltpYZlKVlI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IWVkZhORY9imY5FneS+keJKgSYCeTxoJHysJ7YNaF+Y=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794466836; v=1; x=1795071636;
 b=owLrm7cBfzN1UV7R16E1C54SoQ6uEbb9iF8oE9Q5nwcgoWHQirDw5gp7jkGwGjeLafzaGCP1
 Te46sEi7bhxP9cwDDRW2wHBKzqLnYx5iq1pmrfxW0YYJxKqEKpde6mzEEQo7PWPyTvt+znR0GhH
 xNDE2eDuB7safnAL4u5eo6JM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5f9d5e168c7f5611;
	Thu, 12 Nov 2026 07:00:23 +0000
X-Mizu-Trace-ID: 5f9d5e168c7f5611
X-Migadu-Flow: FLOW_OUT
Message-ID: <4ad546a2-66c5-4b74-a221-d9e8c1006c73@linux.dev>
Date: Thu, 12 Nov 2026 15:01:48 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 6/9] mm/vmalloc: only flush the cache after the vmap
 succeeded
To: Suren Baghdasaryan <surenb@google.com>
Cc: Uladzislau Rezki <urezki@gmail.com>, Dev Jain <dev.jain@arm.com>,
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
 kasan-dev@googlegroups.com, linux-mm@kvack.org,
 Sashiko <sashiko-bot@kernel.org>
References: <20261110112546.261415-1-hao.ge@linux.dev>
 <20261110112546.261415-7-hao.ge@linux.dev>
 <CAJuCfpHReBDoXj_U3Dy2hksj63KyHNBm4gS+wtR_ywidyJ8mfw@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHReBDoXj_U3Dy2hksj63KyHNBm4gS+wtR_ywidyJ8mfw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5A48FA0005
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: 78gwn5kch3cqx9osfjagtnhip6is7rxp
X-HE-Tag: 1794466838-251252
X-HE-Meta: U2FsdGVkX1+UH8h4GxPpStaVpmqtZRwDVM13gWpBp/jVCR56hgNsysX/Bf/wM+6psrbQ2iJdsW9dSCCXM62ak0Nuaa1rST30lQAtq8c/pXaj7DBfq6SOuXu0lkHn5jMQ3OOkset5jebi50Fy8PeE7Vj4nyvXKOk1dpaUpX1G1gcdmSGUsegF8KpsZGh9bBvjsboBWAOi3Q0WzxOvVYNq5z7eMZeh6Vqmuw6RqaMr829L/bI/4mYG73rXVAOXclQ9G09F5YodB2ev8RLvQplllKnnfXkLzIv9td6jLZWgzThpHFZbqGtm2hqKEwSZm0ynkTjAUOjZIKj9n74lmTQ2dXIVpDROLoF2E0BcxOVCpzg5j7C3/K1yZbevXSuRWt99AtFM9oS71U69QIAEHKuE6Fj4pAgz1WEHOq00JAOdOBrR35+YLHsWyHWk7zw0fxaa6H8XnbLqeUZLPTmrdJqYJhSzUNu9xaLrfwQRqnScPdCN4W3BYvnONo87qXI0OgL1PMNFYisyK+ocI2qhUgHDuulaHIoY612ahl0xODuruue5R2AD8TUdmLpeDS37UYcppGlNogxajjY0IRCG1anFxqAWpPwC3yCiHn1zcFy4rnvFaK9wjBsPaHjb8VhByZcCOc4BfM50GRWNuMgYDFMBpLeHoMp02Xu8PwU3zvw6TQ3bCiOZpfcdFP8tvk3ssssgadRr4PCDZLpJF6kDNAHrWnh05NufcLOwGpEs/L0PvqfnO4nY5Q0qew0u1RgB7QBq8Zp5emXY7MZZjXAYggSwu/kS73i5t9paRkyLC/rkVTnZKRoY0ZrP4IicNlWXhyxZIp0JvxaAuGb3ijCyopQTgL6ZV5ZNpmytkXZ0gnk1ZzuPUfiF7yT3lYQS/Fd/O2H8pT9foXoeU/FF/cyH+/NakAHAeUkXhU9doFrrONxo3He5ID+MzJbvoXox1dS7tSuzjPzGIbi9PyDb/qC7jeu
 WhrTTefr
 pBSM/ouR2SktuGsfnGBkSahDi3sBUWGkH0KtfY668OepIaetn0KvLadZM7jKxQ6RykCjrQZ16rwktTUxecF6sKeu3xTjQt6mE2DW+2N/IcjfHwAnKLQu9ECRsXP7ZX239HJBM62Tx2WwOdHjsUBIlQcHRyFTXJKNr3beJAlI9BO9Cbm90HjjFqwxqdOd6l4o9OTEcKtBgGUQZplWsU543pOI8zNIW4JjTGLEuA+EgL/d4kNCNBQjzoqmoD//GyBwmkWPGYmo1ebca8BIarcNKb9Hdhxz8GCV+lPJ341NQcGUntvNm4j6asy+Tdifvn/rP2J8EtIxDDbZ0bO97RAElSKu+xhzCI4o55nsLs4hkMP5gm00DgheIXo0o19cu6/N+smXGSgEoCtCPF5wOlEyUlTJzwA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/11/12 08:30, Suren Baghdasaryan wrote:
> On Tue, Nov 10, 2026 at 11:25 AM Hao Ge <hao.ge@linux.dev> wrote:
>>
>> vmap_page_range() and __vmap_pages_range() call flush_cache_vmap()
> 
> New vmap_pages_range_batched() function has the same issue, so needs fixing too.

Ack. will do next version.

> 
>> before they even look at the error code. A failed mapping is never
>> used, so the flush is pointless at best.
>>
>> According to the Sashiko review it is worse than pointless on UML:
>> flush_cache_vmap() there is flush_tlb_kernel_range(), which syncs the
>> PTEs into the host OS. Flushing a half-installed mapping therefore
>> leaves host mappings behind for a range that was just freed again.
>>
>> Only flush when the mapping, and for vmap_page_range() also the KMSAN
>> metadata, is fully set up.
>>
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/vmalloc.c | 8 ++++++--
>>  1 file changed, 6 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 0565cbfe325c..3f98056f8c7e 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -369,10 +369,12 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>
>>         err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>>                                  ioremap_max_page_shift);
>> -       flush_cache_vmap(addr, end);
>>         if (!err)
>>                 err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>                                                ioremap_max_page_shift);
>> +       if (!err)
>> +               flush_cache_vmap(addr, end);
>> +
>>         return err;
>>  }
>>
>> @@ -758,7 +760,9 @@ static int __vmap_pages_range(unsigned long addr, unsigned long end,
>>         int err;
>>
>>         err = vmap_pages_range_noflush(addr, end, prot, pages, page_shift, gfp_mask);
>> -       flush_cache_vmap(addr, end);
>> +       if (!err)
>> +               flush_cache_vmap(addr, end);
>> +
>>         return err;
>>  }
>>
>> --
>> 2.25.1
>>

