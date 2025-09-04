Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60D0FCA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 01:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5A468E000D; Wed,  3 Sep 2025 21:06:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A32D08E0001; Wed,  3 Sep 2025 21:06:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 96FDD8E000D; Wed,  3 Sep 2025 21:06:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 842BF8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:06:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EB7B1DF346
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:06:21 +0000 (UTC)
X-FDA: 83849776962.16.AA749CB
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf05.hostedemail.com (Postfix) with ESMTP id D3BBC100005
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:06:18 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756947979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ntQOLd2Oh7vsvYb9bKv3M2vu/ZgjqeyWSK5OBMyPe58=;
	b=iQBS2SvBKhkIelYzxo1TOvLQwRSoLCerseXigGHMOJW0B36oIg3q2Z4sNj4cTJoreHHFFJ
	oKUE0t1HWY7GZoCR16cIH6cmLoYC6zD8vKREi/EpKKfMpWBmqbzheB5Y3r8CGnHJsRu286
	7OEz/PZWvqB9O7xjvB9NF2zZ2LzbJ7A=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf05.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756947979; a=rsa-sha256;
	cv=none;
	b=MOiIhDdd8FYdd6MArb5YlxMlZVLtrKyzR1NWOBD4VYDw7qFfmpZmYO0EXDRvfxko75Fy3K
	yUTlEQFWgmiL9mf4tPLvtyiWpdjDjEgFYyeBAerpYqGD8/jnYX9QOCCbn1MReQrs27NWt2
	xIVd2MaKk8KypbzpprDOfJCyxevdGRI=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cHLlj1pj7zPqPB;
	Thu,  4 Sep 2025 09:01:37 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id CE1F21402C8;
	Thu,  4 Sep 2025 09:06:13 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Sep 2025 09:06:13 +0800
Content-Type: multipart/alternative;
	boundary="------------GwviP3yUyw6VH2NLGZh2grOq"
Message-ID: <407a9aae-43b9-456b-b626-4eec55909dee@huawei.com>
Date: Thu, 4 Sep 2025 09:06:12 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] filemap: optimize order0 folio in filemap_map_pages
From: Jinjiang Tu <tujinjiang@huawei.com>
To: David Hildenbrand <david@redhat.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>
References: <20250903084223.1653192-1-tujinjiang@huawei.com>
 <3c283054-b14e-4f36-966f-78cf3bc0f3af@redhat.com>
 <f5dd70ab-c610-4142-be57-1fa311672b5e@huawei.com>
In-Reply-To: <f5dd70ab-c610-4142-be57-1fa311672b5e@huawei.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D3BBC100005
X-Stat-Signature: 1hzhu5jmnzguaxw6a9ta3t9w3zfnyax7
X-Rspam-User: 
X-HE-Tag: 1756947978-639453
X-HE-Meta: U2FsdGVkX1/r+GdkbZlEgPnV6MzswtfGCh4e7lJudfP6j10Qnwv6m/RFPQUqnMtN5ttqyhXb5tzfYrD+YdovCd1NeWbQtSHFRiLF67A8OJkdDVjRrmO2ScIZcwJW14lKA8ZtEIcunOovBvE2u/5sfnTvbv93nMrkHJCs/610/Bn+dUtLbynaOpVVP5N3+YcPMARJpxvRD0O+Mwmfa+8+oC5ZPk0lIU1t5je2jeV+Z/2hxaXKq9I5nONm8QZ3YJN1EpyEKjcOvkF3OP7IMZP778dFuRAXDb6uj62daHbLvWVUn0qSph+XzmCzx2B7sxBN0/YHa57Bn3hJzoS2q2zMb9XawpPZU4vfhmSfFL9bBv3IDsSaf31xreb6SSudgQuzGS44KkDhkQe7Xe1TWGeUnJKt0adOj49TfNKyZrV+UqbnmAzYFwLnGXlNg+CR2ddhM5pTsPMAoIiv/rBpTOn7zmYN6J8RhkMYU3xUxBVw3TyhBeKesT03VTrypQoa3WuoEhpdV/Qufgl8qp3QcAg21SRX8iyIi1GbHbNiBvncv9B+kfNptzPp++B1HqFpy2nB5GA+Nve6Svo6/gXOePF8hVrsOnvgUVphzd8XkQ1wajCi9czUyUwVTJOQ/Skz/LnHhBg1bNJv2114jc/CmsvwJw55eswkSYFsd+L/E8cfqgKx+NbKy0fwNIpQ3Nxl9ilCzEJ2EktkgFk5rHfxXNyDn1j6lyvX2PazTtmoOompPcc5c77PLDhsmEUpKuZuqulOH3VudvM6fcJGnm5Z9fVwjguH/fkUdMj1cjjuoY8Yos0dh361CgUxHdxEZIcdoHZRynJORwMMqITaQrJ5FvXFa0m6kJ6BjdzloGZoIp/4vRlyacGV19G9mOYOpLEHXCyTsLLV9KSFHYOApUUW5eqUBNQZnw5rESaqoq4kitbgbFUKB92cSqj0I5g8qcmGoOu3vfWdbwZFej/qJzo7hth
 HXvFP4v0
 50h6qBelDMPKauWYgpesQ0+MYa+ToEr9WtU3BMvaHpkfjsZemsQonR6BJZlLDe9otTeX7GZCFUaDj4fpvMFfGeLrOqyHLl5H/rXls8WhayloiGIRg4b0WzXqedipz/i05VvHW2Y5RURXexLGRfM47r3SzleMLKFHnPBQ9CViorv3wzmdFWeEMc1EAOppsWPfWFT3waXjKI57S6XJ8A+PBbNkn7Vg3iAhZGrqguZPYMMt9Wv1e7ltwHvdqjD4B2SoiP37E3T5IS4msJHwXeeXzwv/PLrxJ319PUgl6imZEX2sQbN6SM20BGm5xVlX34Lh35uTTFPA9014F2kEkbRTdq11VmVnr4iLBjuEHFsffddlHHQTj0f3SumOAUaNs5kyvWwSbndSqyAG30VtsRU0H7aKKv/JTIqaXL7LF13DAfaX/x63LlyfiqwX+Zw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------GwviP3yUyw6VH2NLGZh2grOq
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/4 9:05, Jinjiang Tu 写道:
>
>
> 在 2025/9/3 17:16, David Hildenbrand 写道:
>>> +++ b/mm/filemap.c
>>> @@ -3693,6 +3693,7 @@ static vm_fault_t 
>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>       }
>>>         vmf->pte = old_ptep;
>>> +    folio_put(folio);
>>>         return ret;
>>>   }
>>> @@ -3705,7 +3706,7 @@ static vm_fault_t 
>>> filemap_map_order0_folio(struct vm_fault *vmf,
>>>       struct page *page = &folio->page;
>>>         if (PageHWPoison(page))
>>> -        return ret;
>>> +        goto out;
>>>         /* See comment of filemap_map_folio_range() */
>>>       if (!folio_test_workingset(folio))
>>> @@ -3717,15 +3718,17 @@ static vm_fault_t 
>>> filemap_map_order0_folio(struct vm_fault *vmf,
>>>        * the fault-around logic.
>>>        */
>>>       if (!pte_none(ptep_get(vmf->pte)))
>>> -        return ret;
>>> +        goto out;
>>>         if (vmf->address == addr)
>>>           ret = VM_FAULT_NOPAGE;
>>>         set_pte_range(vmf, folio, page, 1, addr);
>>>       (*rss)++;
>>> -    folio_ref_inc(folio);
>>> +    return ret;
>>>   +out:
>>> +    folio_put(folio);
>>
>> We can use a folio_ref_dec() here
>>
>>     /* Locked folios cannot get truncated. */
>>     folio_ref_dec(folio);
>>
>>>       return ret;
>>>   }
>>>   @@ -3785,7 +3788,6 @@ vm_fault_t filemap_map_pages(struct vm_fault 
>>> *vmf,
>>>                       nr_pages, &rss, &mmap_miss);
>>>             folio_unlock(folio);
>>> -        folio_put(folio);
>>>       } while ((folio = next_uptodate_folio(&xas, mapping, 
>>> end_pgoff)) != NULL);
>>>       add_mm_counter(vma->vm_mm, folio_type, rss);
>>>       pte_unmap_unlock(vmf->pte, vmf->ptl);
>>
>>
>> I think we can optimize filemap_map_folio_range() as well:
>>
>> diff --git a/mm/filemap.c b/mm/filemap.c
>> index b101405b770ae..d1fcddc72c5f6 100644
>> --- a/mm/filemap.c
>> +++ b/mm/filemap.c
>> @@ -3646,6 +3646,7 @@ static vm_fault_t 
>> filemap_map_folio_range(struct vm_fault *vmf,
>>                         unsigned long addr, unsigned int nr_pages,
>>                         unsigned long *rss, unsigned short *mmap_miss)
>>  {
>> +       bool ref_from_caller = true;
>>         vm_fault_t ret = 0;
>>         struct page *page = folio_page(folio, start);
>>         unsigned int count = 0;
>> @@ -3679,7 +3680,9 @@ static vm_fault_t 
>> filemap_map_folio_range(struct vm_fault *vmf,
>>                 if (count) {
>>                         set_pte_range(vmf, folio, page, count, addr);
>>                         *rss += count;
>> -                       folio_ref_add(folio, count);
>> +                       if (count - ref_from_caller)
>> +                               folio_ref_add(folio, count - 
>> ref_from_caller);
>> +                       ref_from_caller = false;
>>                         if (in_range(vmf->address, addr, count * 
>> PAGE_SIZE))
>>                                 ret = VM_FAULT_NOPAGE;
>>                 }
>> @@ -3694,13 +3697,19 @@ static vm_fault_t 
>> filemap_map_folio_range(struct vm_fault *vmf,
>>         if (count) {
>>                 set_pte_range(vmf, folio, page, count, addr);
>>                 *rss += count;
>> -               folio_ref_add(folio, count);
>> +               if (count - ref_from_caller)
>> +                       folio_ref_add(folio, count - ref_from_caller);
>> +               ref_from_caller = false;
>>                 if (in_range(vmf->address, addr, count * PAGE_SIZE))
>>                         ret = VM_FAULT_NOPAGE;
>>         }
>>
>>         vmf->pte = old_ptep;
>>
>> +       if (ref_from_caller)
>> +               /* Locked folios cannot get truncated. */
>> +               folio_ref_dec(folio);
>> +
>>         return ret;
>>  }
>>
>>
>> It would save at least a folio_ref_dec(), and in corner cases (only 
>> map a single page)
>> also a folio_ref_add().
>>
> Maybe We can first count the refcount to add, and only call folio_ref_{add, sub} once before return
>
>
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3643,6 +3643,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>          struct page *page = folio_page(folio, start);
>          unsigned int count = 0;
>          pte_t *old_ptep = vmf->pte;
> +       int ref_to_add = -1;
>   
>          do {
>                  if (PageHWPoison(page + count))
> @@ -3672,7 +3673,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>                  if (count) {
>                          set_pte_range(vmf, folio, page, count, addr);
>                          *rss += count;
> -                       folio_ref_add(folio, count);
> +                       ref_to_add += count;
>                          if (in_range(vmf->address, addr, count * PAGE_SIZE))
>                                  ret = VM_FAULT_NOPAGE;
>                  }
> @@ -3687,12 +3688,17 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
>          if (count) {
>                  set_pte_range(vmf, folio, page, count, addr);
>                  *rss += count;
> -               folio_ref_add(folio, count);
> +               ref_to_add += count;
>                  if (in_range(vmf->address, addr, count * PAGE_SIZE))
>                          ret = VM_FAULT_NOPAGE;
>          }
>   
>          vmf->pte = old_ptep;
> +       /* Locked folios cannot get truncated. */
> +       if (ref_to_add > 0)
> +               folio_ref_add(folio, ref_to_add);
> +       else if (ref_to_add < 0)
> +               folio_ref_sub(folio, ref_to_add);

+       else if (ref_to_add < 0)
+               folio_ref_sub(folio, -ref_to_add);

>   
>          return ret;
>   }
>
>
--------------GwviP3yUyw6VH2NLGZh2grOq
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: 8bit

<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  </head>
  <body>
    <p><br>
    </p>
    <div class="moz-cite-prefix">在 2025/9/4 9:05, Jinjiang Tu 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:f5dd70ab-c610-4142-be57-1fa311672b5e@huawei.com">
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
      <p><br>
      </p>
      <div class="moz-cite-prefix">在 2025/9/3 17:16, David Hildenbrand
        写道:<br>
      </div>
      <blockquote type="cite"
        cite="mid:3c283054-b14e-4f36-966f-78cf3bc0f3af@redhat.com">
        <blockquote type="cite">+++ b/mm/filemap.c <br>
          @@ -3693,6 +3693,7 @@ static vm_fault_t
          filemap_map_folio_range(struct vm_fault *vmf, <br>
                } <br>
                  vmf-&gt;pte = old_ptep; <br>
          +    folio_put(folio); <br>
                  return ret; <br>
            } <br>
          @@ -3705,7 +3706,7 @@ static vm_fault_t
          filemap_map_order0_folio(struct vm_fault *vmf, <br>
                struct page *page = &amp;folio-&gt;page; <br>
                  if (PageHWPoison(page)) <br>
          -        return ret; <br>
          +        goto out; <br>
                  /* See comment of filemap_map_folio_range() */ <br>
                if (!folio_test_workingset(folio)) <br>
          @@ -3717,15 +3718,17 @@ static vm_fault_t
          filemap_map_order0_folio(struct vm_fault *vmf, <br>
                 * the fault-around logic. <br>
                 */ <br>
                if (!pte_none(ptep_get(vmf-&gt;pte))) <br>
          -        return ret; <br>
          +        goto out; <br>
                  if (vmf-&gt;address == addr) <br>
                    ret = VM_FAULT_NOPAGE; <br>
                  set_pte_range(vmf, folio, page, 1, addr); <br>
                (*rss)++; <br>
          -    folio_ref_inc(folio); <br>
          +    return ret; <br>
            +out: <br>
          +    folio_put(folio); <br>
        </blockquote>
        <br>
        We can use a folio_ref_dec() here <br>
        <br>
            /* Locked folios cannot get truncated. */ <br>
            folio_ref_dec(folio); <br>
        <br>
        <blockquote type="cite">      return ret; <br>
            } <br>
            @@ -3785,7 +3788,6 @@ vm_fault_t filemap_map_pages(struct
          vm_fault *vmf, <br>
                                nr_pages, &amp;rss, &amp;mmap_miss); <br>
                      folio_unlock(folio); <br>
          -        folio_put(folio); <br>
                } while ((folio = next_uptodate_folio(&amp;xas, mapping,
          end_pgoff)) != NULL); <br>
                add_mm_counter(vma-&gt;vm_mm, folio_type, rss); <br>
                pte_unmap_unlock(vmf-&gt;pte, vmf-&gt;ptl); <br>
        </blockquote>
        <br>
        <br>
        I think we can optimize filemap_map_folio_range() as well: <br>
        <br>
        diff --git a/mm/filemap.c b/mm/filemap.c <br>
        index b101405b770ae..d1fcddc72c5f6 100644 <br>
        --- a/mm/filemap.c <br>
        +++ b/mm/filemap.c <br>
        @@ -3646,6 +3646,7 @@ static vm_fault_t
        filemap_map_folio_range(struct vm_fault *vmf, <br>
                                unsigned long addr, unsigned int
        nr_pages, <br>
                                unsigned long *rss, unsigned short
        *mmap_miss) <br>
         { <br>
        +       bool ref_from_caller = true; <br>
                vm_fault_t ret = 0; <br>
                struct page *page = folio_page(folio, start); <br>
                unsigned int count = 0; <br>
        @@ -3679,7 +3680,9 @@ static vm_fault_t
        filemap_map_folio_range(struct vm_fault *vmf, <br>
                        if (count) { <br>
                                set_pte_range(vmf, folio, page, count,
        addr); <br>
                                *rss += count; <br>
        -                       folio_ref_add(folio, count); <br>
        +                       if (count - ref_from_caller) <br>
        +                               folio_ref_add(folio, count -
        ref_from_caller); <br>
        +                       ref_from_caller = false; <br>
                                if (in_range(vmf-&gt;address, addr,
        count * PAGE_SIZE)) <br>
                                        ret = VM_FAULT_NOPAGE; <br>
                        } <br>
        @@ -3694,13 +3697,19 @@ static vm_fault_t
        filemap_map_folio_range(struct vm_fault *vmf, <br>
                if (count) { <br>
                        set_pte_range(vmf, folio, page, count, addr); <br>
                        *rss += count; <br>
        -               folio_ref_add(folio, count); <br>
        +               if (count - ref_from_caller) <br>
        +                       folio_ref_add(folio, count -
        ref_from_caller); <br>
        +               ref_from_caller = false; <br>
                        if (in_range(vmf-&gt;address, addr, count *
        PAGE_SIZE)) <br>
                                ret = VM_FAULT_NOPAGE; <br>
                } <br>
          <br>
                vmf-&gt;pte = old_ptep; <br>
          <br>
        +       if (ref_from_caller) <br>
        +               /* Locked folios cannot get truncated. */ <br>
        +               folio_ref_dec(folio); <br>
        + <br>
                return ret; <br>
         } <br>
        <br>
        <br>
        It would save at least a folio_ref_dec(), and in corner cases
        (only map a single page) <br>
        also a folio_ref_add(). <br>
        <br>
      </blockquote>
      <pre>Maybe We can first count the refcount to add, and only call folio_ref_{add, sub} once before return


--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3643,6 +3643,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
        struct page *page = folio_page(folio, start);
        unsigned int count = 0;
        pte_t *old_ptep = vmf-&gt;pte;
+       int ref_to_add = -1;
 
        do {
                if (PageHWPoison(page + count))
@@ -3672,7 +3673,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
                if (count) {
                        set_pte_range(vmf, folio, page, count, addr);
                        *rss += count;
-                       folio_ref_add(folio, count);
+                       ref_to_add += count;
                        if (in_range(vmf-&gt;address, addr, count * PAGE_SIZE))
                                ret = VM_FAULT_NOPAGE;
                }
@@ -3687,12 +3688,17 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
        if (count) {
                set_pte_range(vmf, folio, page, count, addr);
                *rss += count;
-               folio_ref_add(folio, count);
+               ref_to_add += count;
                if (in_range(vmf-&gt;address, addr, count * PAGE_SIZE))
                        ret = VM_FAULT_NOPAGE;
        }
 
        vmf-&gt;pte = old_ptep;
+       /* Locked folios cannot get truncated. */
+       if (ref_to_add &gt; 0)
+               folio_ref_add(folio, ref_to_add);
+       else if (ref_to_add &lt; 0)
+               folio_ref_sub(folio, ref_to_add);</pre>
    </blockquote>
    <pre>+       else if (ref_to_add &lt; 0)
+               folio_ref_sub(folio, -ref_to_add);</pre>
                            
    <blockquote type="cite"
      cite="mid:f5dd70ab-c610-4142-be57-1fa311672b5e@huawei.com">
      <pre>
 
        return ret;
 }</pre>
      <p><br>
      </p>
    </blockquote>
  </body>
</html>

--------------GwviP3yUyw6VH2NLGZh2grOq--

