Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8FC9ECA5FED
	for <linux-mm@archiver.kernel.org>; Fri,  9 Oct 2026 08:23:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A50C26B0093; Fri,  9 Oct 2026 04:22:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A27DB6B0095; Fri,  9 Oct 2026 04:22:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9654D6B0096; Fri,  9 Oct 2026 04:22:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 702C06B0093
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 04:22:59 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EF40C402A5
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:22:58 +0000 (UTC)
X-FDA: 85302397236.17.A1069E4
Received: from mta0.migadu.com (out-120.mta0.migadu.com [91.218.175.120])
	by imf24.hostedemail.com (Postfix) with ESMTP id 27D1318000A
	for <linux-mm@kvack.org>; Fri,  9 Oct 2026 08:22:54 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lzAQwm46;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791534177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oPKfmQ01IpavpOUMHMCz4tLEVNdQIFdmn1JVvwShTRI=;
	b=xj0u/uV9MFg27Ok5Gr3PKMvOe+gjuJxLUy515OhqXrmS597EUOcvvz9KO5uKNndqENq3tb
	i+q7eOmRlxLF+quBvcDxUPJ1IXoViQL2EbSqMJNwqQa/lqpiz1pQiNUio9Z8LbHX9U6g5t
	WV9OsA14beP26S8/PQLUmt+b0hGEZ8w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791534177;
	b=BZjr6081EL+ie+d9i+1C7XPdWPWMziAT2rkN97ZHGstsebHfeSBTus8Tq76OoXloGsEd00
	txnm9pJH/E5NmTm+yl7kvU9IAcQmX7nLeHaz7DqILQAwmJF0HV8jh0bjni9IsGpq3QEkfq
	1YiggDZ+7pH+SvtztRBodYRxdR/xVjg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lzAQwm46;
	spf=pass (imf24.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.120 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=c5aDOqijhnGPpwPCmjSXCbIeHPczQrKsPxgMJv3hKPQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791534172; v=1; x=1792138972;
 b=lzAQwm46m7c4MXznCJpzzcM+m+QYqY79uC477fKHXPozG/TetRQTbA0vJOMxchj/3j05PAjF
 eK75Cgrlpo1SdPkaa8te5lVHheGmwx9rCxDtBMg0d6q3B93sF6D3ZgXNWsJO5YwYrEHbCwqcuFe
 4quKoBYkubaynDJbtZkWlveo=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 23e08e172bfdef72;
	Fri, 09 Oct 2026 08:22:52 +0000
X-Mizu-Trace-ID: 23e08e172bfdef72
X-Migadu-Flow: FLOW_OUT
Message-ID: <baa5ac6e-e7ea-496b-bea7-a3790d277d73@linux.dev>
Date: Fri, 9 Oct 2026 16:23:53 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/7] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Suren Baghdasaryan <surenb@google.com>,
 Uladzislau Rezki <urezki@gmail.com>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, Andrew Morton
 <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-modules@vger.kernel.org, kasan-dev@googlegroups.com,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260929082014.160587-1-hao.ge@linux.dev>
 <20260929082014.160587-3-hao.ge@linux.dev> <arzgoe-bXAz1poAt@milan>
 <CAJuCfpHavrwaJ2T6daHnJc+r=9khBwrv_zOp8s3Cwi347SHXRw@mail.gmail.com>
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <CAJuCfpHavrwaJ2T6daHnJc+r=9khBwrv_zOp8s3Cwi347SHXRw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 27D1318000A
X-Rspam-User: 
X-Stat-Signature: xjt3r345gp9g6azjots8esduqzxyarpy
X-HE-Tag: 1791534174-66189
X-HE-Meta: U2FsdGVkX1/BMZvqrJ+D/Ep+Ni18nulcgUmQieFjWbVorAFzaMMxbAfpiAVN6eaQdgT4vKIyXPbWJwev3kvbmZO89cwWW1O4mxOyKd4QrBchLGJNnoPJzdk84Rno/JDvVhh/rtsERAh8JwrTEITJvkZyspDsin1eg4yCOEwC8buukispwrF2JsJMDIZ0NbOznVC+KuDZLhRzNyETk6Hey7E/9tUhhPuibIm7UGgg4dCEFYNcFlKLTiUJ34Jp1CFgIGgf4o8sEB8Zdu6ifyKESanGMYxRa6nedwXCdlS717K/e+1uQ3qjU2nFEYGKr8PQg2jXzfay9bRPMo9K7CxMg+ub9A1931Oc92K0tf5mtlw6GoY1fAjwGr/Lcr6HCu5lyE4Bq26QI3xfrrVRe92XGYp/pGo0JCbsVUKeTyA3Sbqb7241JEgUaQcJOa/J1bVD/kj8aCPkeZKAS1epgrmtOz8pRAYVV8vCEJ9YhnUjQcigraWGjFAregXFbXaphi5pd+2sYFpJpZHXOAPTgsG6T6JW8xQqaRXZZxlaGZs2+6vN79ryS40zl9D84DOgXstTDJ+bhEIRcotP3nXFuLtYQsD35dRLzW/gS/5+9T2EAEG/UKTollSwWUM4l4dlceK1UzwjXaceCRtkzqTy3QGdyN+LAfzjcFeD+t3M1LZmBSCfrv1/GjBwBDU+S+OwpoH9GeCHe9vUvV6Eesagn1Ah3OJ5UZMHm/l+8Oeor0/cfdNfO7h5TJRrlDSnY3xZTiJLX1piDEfQi22eICeJpB4gQVNIbvBYrZKUSdomfYEBN04FX97y3pU9IIRYJSbJSUq3VEPlYUHw4xsoMLLDwS6h/OzPFty6PYdcbcpPTEHPzHN07XpKS69raE1i1OV+KpYhENLbS67sQsxEHpVim6lLMTsKw1NonBCmLdfuzOd0aucL4NAmVDXf0nzzOkzroD04I5nW21wFgiyWzXPy6xv
 Tnbh2Z13
 CIThibhwmeMg9Ujr4ND+SL8a+Uc/66ebebanLJpg8nM1oSfzb5vs8vhXsAl72zea+E4Ub4/Ytq2AFYYN4+t+BW1tjXsgPvaoNHt3o5P1tZ805itTaXyI7MSCw4eHZ4aYEDxDMk97achvxhZe0SexxM4KWbip93jClUJ7gImgkqndVz3LRgxaZ6IsmOrlsgP5tylF2p7e3OQ8LXtr0x+jesXaOS/YN/2Os41CgAeZnl3XVF6rCGKDIfbFs0nCXJ7B3CcwDH+hXTXZL0GbasULIpcRxCurAB9H771tCk1ixRQtiGJEiwY5Vm127+RTUXwby7erK7LbHzww+T30n8fMQbAd74DoK4UPhjYEv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suren 

On 2026/10/5 01:42, Suren Baghdasaryan wrote:
> On Wed, Sep 30, 2026 at 12:12 PM Uladzislau Rezki <urezki@gmail.com> wrote:
>>
>> On Tue, Sep 29, 2026 at 04:20:09PM +0800, Hao Ge wrote:
>>> __vmap_pages_range_noflush() and friends can install some PTEs before
>>> failing and leave them mapped, and the kernel callers do not agree on
>>> who cleans them up. For example, pcpu_map_pages() and
>>> kmsan_ioremap_page_range() unmap the leftovers themselves, while
>>> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
>>> __vmalloc_area_node() relied on the mapping functions cleaning up and
>>> did not call anything like vunmap_range() themselves. When the same
>>> range is mapped again, the attempt hits the leftovers and fails, with
>>> BUG() in vmap_pte_range() for huge mappings.
>>>
>>> After discussing with Suren and Ulad, we decided the cleanup belongs
>>> to __vmap_pages_range_noflush() and friends, so the callers no longer
>>> need to unmap the partial mappings themselves. Each function now
>>> undoes the PTEs it installed itself.
>>>
>>> The rollback calls the low-level __vunmap_range_noflush(), it just
>>> clears the PTEs of the range it is given, which is all a rollback
>>> needs. It cannot use vunmap_range_noflush() because these mapping
>>> functions also map the KMSAN shadow and origin, and for a metadata
>>> range its hook would look up the metadata of the metadata, get 0
>>> and BUG() on addr >= end. The failed mappings were never accessed,
>>> no TLB flush needed.
>>>
>>> Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
> 
> I don't think this fixes 0f9b685626da. I mean it fixes it but
> indirectly. That patch expects vmap_pages_range() to undo the mappings
> when it fails, which is a reasonable assumption. By fixing
> vmap_pages_xxx we fix all its users, including
> vm_module_tags_populate(). So, it indirectly fixes several callers but
> when adding a Fixes tag we do not list all patches we indirectly fix.
>

Got it, learned something new here. I used to think we had to add a Fixes tag
so stable folks know which branches to backport to.
I went back and re-read Documentation/process/stable-kernel-rules.rst, and turns out
that's not how it works.

Both Fixes tags should be removed then. At the end of the day we're just normalizing the API;
those other commits are merely beneficiaries of this change.

Thanks for your patient guidance.

Best Regards
Hao

>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>>  mm/kmsan/shadow.c |  4 ++++
>>>  mm/vmalloc.c      | 31 +++++++++++++++++++++++++++++--
>>>  2 files changed, 33 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>>> index 0c88d89bf0d6..2166086d3dc3 100644
>>> --- a/mm/kmsan/shadow.c
>>> +++ b/mm/kmsan/shadow.c
>>> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>>                                           o_pages, page_shift);
>>>       kmsan_leave_runtime();
>>>       if (mapped) {
>>> +             /* Undo the shadow mapping set up above. */
>>> +             kmsan_enter_runtime();
>>> +             __vunmap_range_noflush(shadow_start, shadow_end);
>>> +             kmsan_leave_runtime();
>>>               err = mapped;
>>>               goto ret;
>>>       }
>>>
>> Can we just do that inside the vmalloc? For example in the
>> __vmap_pages_range_noflush() as entry function for all(?) helpers?
>> So we do not need do it manually?
> 
> Agree, that would be better.
> 
>>
>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 859e6d2d57a3..9bbf75706627 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -349,6 +349,10 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>>>       if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>>               arch_sync_kernel_mappings(start, end);
>>>
>>> +     /* Undo the PTEs installed before the failure. */
>>> +     if (err)
>>> +             __vunmap_range_noflush(start, end);
>>> +
>>>       return err;
>>>  }
>>>
>>> @@ -363,6 +367,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>>       if (!err)
>>>               err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>>                                              ioremap_max_page_shift);
>>> +     if (err)
>>> +             __vunmap_range_noflush(addr, end);
>>> +
>>>       return err;
>>>  }
>>>
>>> @@ -667,6 +674,10 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>>>       if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>>               arch_sync_kernel_mappings(start, end);
>>>
>>> +     /* Undo the PTEs installed before the failure. */
>>> +     if (err)
>>> +             __vunmap_range_noflush(start, end);
>>> +
>>>       return err;
>>>  }
>>>
>> The only one user of that function is __vmap_pages_range_noflush()
>> so we can cover both cases there small and huge path.
>>
>> Is that enough just to do unroll in the below:
>>
>> __vmap_pages_range_noflush()
>> vmap_page_range()
>>
>> functions? It will also fix NOFAIL case:
>>
>> <snip>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 89c327a6ce7d..fa1f357ecf3f 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -359,10 +359,19 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>
>>         err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>>                                  ioremap_max_page_shift);
>> +       if (err)
>> +               goto error_cleanup_range;
>> +
>>         flush_cache_vmap(addr, end);
>> -       if (!err)
>> -               err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>> +       err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>                                                ioremap_max_page_shift);
>> +       if (err)
>> +               goto error_cleanup_range;
>> +
>> +       return 0;
>> +
>> +error_cleanup_range:
>> +       __vunmap_range_noflush(addr, end);
>>         return err;
>>  }
>>
>> @@ -683,26 +692,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>                 pgprot_t prot, struct page **pages, unsigned int page_shift)
>>  {
>>         unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>> +       unsigned long start = addr;
>> +       int err;
>>
>> -       WARN_ON(page_shift < PAGE_SHIFT);
>> -
>> -       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> -                       page_shift == PAGE_SHIFT)
>> -               return vmap_small_pages_range_noflush(addr, end, prot, pages);
>> +       if (WARN_ON(addr >= end))
>> +               return -EINVAL;
>>
>> -       for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> -               int err;
>> +       if (WARN_ON(page_shift < PAGE_SHIFT))
>> +               return -EINVAL;
>>
>> -               err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>> +       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> +               page_shift == PAGE_SHIFT) {
>> +               err = vmap_small_pages_range_noflush(addr, end, prot, pages);
>> +       } else {
>> +               for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> +                       err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>                                         page_to_phys(pages[i]), prot,
>>                                         page_shift);
>> -               if (err)
>> -                       return err;
>> +                       if (err)
>> +                               break;
>>
>> -               addr += 1UL << page_shift;
>> +                       addr += 1UL << page_shift;
>> +               }
>>         }
>>
>> -       return 0;
>> +       if (err)
>> +               __vunmap_range_noflush(start, end);
>> +
>> +       /* 0 on success. */
>> +       return err;
>>  }
>>
>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> @@ -714,7 +732,13 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>
>>         if (ret)
>>                 return ret;
>> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>> +
>> +       ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>> +       if (ret)
>> +               /* Cleanup KMSAN metadata. */
>> +               kmsan_vunmap_range_noflush(addr, end);
>> +
>> +       return ret;
>>  }
>>
>>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
>> <snip>
>>
>> --
>> Uladzislau Rezki

