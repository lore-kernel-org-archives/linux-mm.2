Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9CA4CCA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:12:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 00BB98E0011; Thu,  4 Sep 2025 08:12:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EFE6B8E0001; Thu,  4 Sep 2025 08:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DED598E0011; Thu,  4 Sep 2025 08:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C96338E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:12:56 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9A3541A0168
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:12:56 +0000 (UTC)
X-FDA: 83851456752.04.E747692
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf21.hostedemail.com (Postfix) with ESMTP id D7F701C0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:12:52 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756987974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ckXNxxNG2rUMBWxCj4OwYtb+QAP/IU+ONllBc7op+N4=;
	b=B1O632BsZ20wJq9WaotFtNlq4KubDDd7DF2YlOhstIXARd50dzILh2axME0CM7hsVJV8ai
	3bIs/1V09hWMWj64USaBDkE4kQnKfsxKqiZLuPFOHpJAssdKr7lsKOCzwP3IIYKLaIAD9C
	6v766LEkxkhL6KWCVgK5lQqvg7zd5io=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756987974; a=rsa-sha256;
	cv=none;
	b=OA6S74DL+fJwddFhw+80tPwqcJjJvOYBilMMC0ubyUCrq3UfYLeRfu1OgDbK37QS79RZDn
	DTzMmPxKfcu0q4fsPWAjGqO5bIobVH5C9uvFQKDlf0OE+6XwJKKH9EiVyOk/SB2b+cScqf
	Il/SvCF0s3LQ/b4v6/w6W8jAurZdS3I=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cHdZX2BSZz24htl;
	Thu,  4 Sep 2025 20:09:40 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 39D241400CB;
	Thu,  4 Sep 2025 20:12:48 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Sep 2025 20:12:47 +0800
Content-Type: multipart/alternative;
	boundary="------------Te0gsmdQ2l0CU0PqrSMAsi4C"
Message-ID: <0f167c1e-1444-43bc-b993-72457ee1bdb8@huawei.com>
Date: Thu, 4 Sep 2025 20:12:46 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] filemap: optimize order0 folio in filemap_map_pages
To: David Hildenbrand <david@redhat.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>
References: <20250903084223.1653192-1-tujinjiang@huawei.com>
 <3c283054-b14e-4f36-966f-78cf3bc0f3af@redhat.com>
 <f5dd70ab-c610-4142-be57-1fa311672b5e@huawei.com>
 <407a9aae-43b9-456b-b626-4eec55909dee@huawei.com>
 <8fbec487-b696-48ea-a449-411ec74ad378@redhat.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <8fbec487-b696-48ea-a449-411ec74ad378@redhat.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D7F701C0006
X-Stat-Signature: do4b4zyggfyzh7w8p1wut6wfu1nzique
X-Rspam-User: 
X-HE-Tag: 1756987972-269156
X-HE-Meta: U2FsdGVkX1/K1QJs7WtE2mCac/bBsi2RZj3iJW8HXDY5Xn4TxucTR0FXv0V+XYJNgjKbaUL7vPb2EjIXf1lr1xwoa4XPbgN+ag3OzF+xsYxsH88NlMxA6j81uDxOQjuq4iwg+jgM3s2T1BjdA8weMGplGfExfZ3opGMuf0Ey+5yKHX3A8knGUuYDUjFyObbdG2tsYEErhZ1PQl63seEWvy306jZRx90jNmcj4xNRydHlEpJcyQxOcsx9HzIYqJIM4vNuxRVcnCh6zNs8qAQj1qzHPfddrm+WuY8upJ+I4zlpzLpl0uWFZlLOvVpgKc0/9dUQi1jtyHua4gqPH8C3pZyZTNr7SLalvtxNtLYY8W+0EOKfbRpQ02M2M20tjn7sHmdbtkX2SGyHQGFfiPkFTGYES8OUm21w5Exb78M9vQDI9uLglnWFXvm8hbhEVWpBNwD2LQayhPv5/YfTLIEG9nHHKIrZYQlw/h5G9ijZRSYUXeGz1kIR0YGhzR6Be5BHTXKIzxp7JNxU7siwt6VrNi3AJHp8VLXadgw95swcg0ju7rJ2NHfaH3WmRIlzY64h1f974j8NkIF/URrMjMfjMaOT3kjjrAAQ05zhBKX1bViL3KwdI67eTx+pgUue3Yx1/BLgvI/S0SBajSCDwn/qmfzbnz0d9hwlipXzzBB8KVW4pBY8UyLn6uym9/jr4aVa8gUTiilBw2yaJQt0JT5ft1ZHVRdhe9ASdazxNFvM5E8qseZX8Ybi0GsZsHQ9qIsZqQIEiGH56Q4zPj00mY1V05T7iXznUl48Ati3hcURmtUemRLsa5vgTV6v5DKTOUQP3b4H9jwhIoEFXJt7biREC0pXfLKttEf5hG7U8eK2z2JwzlJ+r5LtnnJFBtt3M26J8wYhEsq8kzbNIHwW5KM/ulElRnr5PxizJG+7gaFbUFIQVF+awZPl3mFwO/bF/eh9OvgZvWsVyZCI7yjeaeL
 S16RhvzQ
 N7AKQBglBdJnhsfkEXuYASCzVn6drz1e3ikj921SYVcFCJ/JE+6ncanlGO2i0gCLGNLRo2qja9/mIuGUJL6VHJ1DngKXsO2KopWptR56WTLQVKTfOxwQmR9OinxRFM65EOB9yQA7WSPHtKgX4IssJ1TtHi8OcroGSu+G4t36ts1GXHptCAmv6uhslrQbmYuxD/bWuIsviw1LIFMCO4so92M381xN7tfdzwJHcEd1AW4RFcYmikW4+I/CIP+5JiELZFoDF4zUYujbAJYhA6FFvc9Cu4CJofFoVA7ooV3apPMDAWl9ZXZdger48PbHdYh6tbQVhy9/p+CFhwbSZY6NE4PDgOniZx09L+SDQaI38+tiwUsZE0MUWDvPacccEPmOR2SGiiWroZyHt6/scVX+48QVk3179/SY3CrSH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------Te0gsmdQ2l0CU0PqrSMAsi4C
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/4 14:20, David Hildenbrand 写道:
> On 04.09.25 03:06, Jinjiang Tu wrote:
>>
>> 在 2025/9/4 9:05, Jinjiang Tu 写道:
>>>
>>>
>>> 在 2025/9/3 17:16, David Hildenbrand 写道:
>>>>> +++ b/mm/filemap.c
>>>>> @@ -3693,6 +3693,7 @@ static vm_fault_t 
>>>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>>>       }
>>>>>         vmf->pte = old_ptep;
>>>>> +    folio_put(folio);
>>>>>         return ret;
>>>>>   }
>>>>> @@ -3705,7 +3706,7 @@ static vm_fault_t 
>>>>> filemap_map_order0_folio(struct vm_fault *vmf,
>>>>>       struct page *page = &folio->page;
>>>>>         if (PageHWPoison(page))
>>>>> -        return ret;
>>>>> +        goto out;
>>>>>         /* See comment of filemap_map_folio_range() */
>>>>>       if (!folio_test_workingset(folio))
>>>>> @@ -3717,15 +3718,17 @@ static vm_fault_t 
>>>>> filemap_map_order0_folio(struct vm_fault *vmf,
>>>>>        * the fault-around logic.
>>>>>        */
>>>>>       if (!pte_none(ptep_get(vmf->pte)))
>>>>> -        return ret;
>>>>> +        goto out;
>>>>>         if (vmf->address == addr)
>>>>>           ret = VM_FAULT_NOPAGE;
>>>>>         set_pte_range(vmf, folio, page, 1, addr);
>>>>>       (*rss)++;
>>>>> -    folio_ref_inc(folio);
>>>>> +    return ret;
>>>>>   +out:
>>>>> +    folio_put(folio);
>>>>
>>>> We can use a folio_ref_dec() here
>>>>
>>>>     /* Locked folios cannot get truncated. */
>>>>     folio_ref_dec(folio);
>>>>
>>>>>       return ret;
>>>>>   }
>>>>>   @@ -3785,7 +3788,6 @@ vm_fault_t filemap_map_pages(struct 
>>>>> vm_fault *vmf,
>>>>>                       nr_pages, &rss, &mmap_miss);
>>>>>             folio_unlock(folio);
>>>>> -        folio_put(folio);
>>>>>       } while ((folio = next_uptodate_folio(&xas, mapping, 
>>>>> end_pgoff)) != NULL);
>>>>>       add_mm_counter(vma->vm_mm, folio_type, rss);
>>>>>       pte_unmap_unlock(vmf->pte, vmf->ptl);
>>>>
>>>>
>>>> I think we can optimize filemap_map_folio_range() as well:
>>>>
>>>> diff --git a/mm/filemap.c b/mm/filemap.c
>>>> index b101405b770ae..d1fcddc72c5f6 100644
>>>> --- a/mm/filemap.c
>>>> +++ b/mm/filemap.c
>>>> @@ -3646,6 +3646,7 @@ static vm_fault_t 
>>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>>                         unsigned long addr, unsigned int nr_pages,
>>>>                         unsigned long *rss, unsigned short *mmap_miss)
>>>>  {
>>>> +       bool ref_from_caller = true;
>>>>         vm_fault_t ret = 0;
>>>>         struct page *page = folio_page(folio, start);
>>>>         unsigned int count = 0;
>>>> @@ -3679,7 +3680,9 @@ static vm_fault_t 
>>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>>                 if (count) {
>>>>                         set_pte_range(vmf, folio, page, count, addr);
>>>>                         *rss += count;
>>>> -                       folio_ref_add(folio, count);
>>>> +                       if (count - ref_from_caller)
>>>> +                               folio_ref_add(folio, count - 
>>>> ref_from_caller);
>>>> +                       ref_from_caller = false;
>>>>                         if (in_range(vmf->address, addr, count * 
>>>> PAGE_SIZE))
>>>>                                 ret = VM_FAULT_NOPAGE;
>>>>                 }
>>>> @@ -3694,13 +3697,19 @@ static vm_fault_t 
>>>> filemap_map_folio_range(struct vm_fault *vmf,
>>>>         if (count) {
>>>>                 set_pte_range(vmf, folio, page, count, addr);
>>>>                 *rss += count;
>>>> -               folio_ref_add(folio, count);
>>>> +               if (count - ref_from_caller)
>>>> +                       folio_ref_add(folio, count - ref_from_caller);
>>>> +               ref_from_caller = false;
>>>>                 if (in_range(vmf->address, addr, count * PAGE_SIZE))
>>>>                         ret = VM_FAULT_NOPAGE;
>>>>         }
>>>>
>>>>         vmf->pte = old_ptep;
>>>>
>>>> +       if (ref_from_caller)
>>>> +               /* Locked folios cannot get truncated. */
>>>> +               folio_ref_dec(folio);
>>>> +
>>>>         return ret;
>>>>  }
>>>>
>>>>
>>>> It would save at least a folio_ref_dec(), and in corner cases (only 
>>>> map a single page)
>>>> also a folio_ref_add().
>>>>
>>> Maybe We can first count the refcount to add, and only call 
>>> folio_ref_{add, sub} once before return
>
> I'm not a fan of that, because I'm planning on moving the 
> folio_ref_add() before the set_pte_range() so we can minimize the 
> number of false positives with our folio_ref_count() != 
> folio_expected_ref_count() checks, and I can sanity check when 
> adjusting the mapcount that it is always >= refcount.
>
I see, I will send v3 as the diff sugguested by you.

Thanks.

--------------Te0gsmdQ2l0CU0PqrSMAsi4C
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
    <div class="moz-cite-prefix">在 2025/9/4 14:20, David Hildenbrand 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:8fbec487-b696-48ea-a449-411ec74ad378@redhat.com">On
      04.09.25 03:06, Jinjiang Tu wrote:
      <br>
      <blockquote type="cite">
        <br>
        在 2025/9/4 9:05, Jinjiang Tu 写道:
        <br>
        <blockquote type="cite">
          <br>
          <br>
          在 2025/9/3 17:16, David Hildenbrand 写道:
          <br>
          <blockquote type="cite">
            <blockquote type="cite">+++ b/mm/filemap.c
              <br>
              @@ -3693,6 +3693,7 @@ static vm_fault_t
              filemap_map_folio_range(struct vm_fault *vmf,
              <br>
                    }
              <br>
                      vmf-&gt;pte = old_ptep;
              <br>
              +    folio_put(folio);
              <br>
                      return ret;
              <br>
                }
              <br>
              @@ -3705,7 +3706,7 @@ static vm_fault_t
              filemap_map_order0_folio(struct vm_fault *vmf,
              <br>
                    struct page *page = &amp;folio-&gt;page;
              <br>
                      if (PageHWPoison(page))
              <br>
              -        return ret;
              <br>
              +        goto out;
              <br>
                      /* See comment of filemap_map_folio_range() */
              <br>
                    if (!folio_test_workingset(folio))
              <br>
              @@ -3717,15 +3718,17 @@ static vm_fault_t
              filemap_map_order0_folio(struct vm_fault *vmf,
              <br>
                     * the fault-around logic.
              <br>
                     */
              <br>
                    if (!pte_none(ptep_get(vmf-&gt;pte)))
              <br>
              -        return ret;
              <br>
              +        goto out;
              <br>
                      if (vmf-&gt;address == addr)
              <br>
                        ret = VM_FAULT_NOPAGE;
              <br>
                      set_pte_range(vmf, folio, page, 1, addr);
              <br>
                    (*rss)++;
              <br>
              -    folio_ref_inc(folio);
              <br>
              +    return ret;
              <br>
                +out:
              <br>
              +    folio_put(folio);
              <br>
            </blockquote>
            <br>
            We can use a folio_ref_dec() here
            <br>
            <br>
                /* Locked folios cannot get truncated. */
            <br>
                folio_ref_dec(folio);
            <br>
            <br>
            <blockquote type="cite">      return ret;
              <br>
                }
              <br>
                @@ -3785,7 +3788,6 @@ vm_fault_t
              filemap_map_pages(struct vm_fault *vmf,
              <br>
                                    nr_pages, &amp;rss, &amp;mmap_miss);
              <br>
                          folio_unlock(folio);
              <br>
              -        folio_put(folio);
              <br>
                    } while ((folio = next_uptodate_folio(&amp;xas,
              mapping, end_pgoff)) != NULL);
              <br>
                    add_mm_counter(vma-&gt;vm_mm, folio_type, rss);
              <br>
                    pte_unmap_unlock(vmf-&gt;pte, vmf-&gt;ptl);
              <br>
            </blockquote>
            <br>
            <br>
            I think we can optimize filemap_map_folio_range() as well:
            <br>
            <br>
            diff --git a/mm/filemap.c b/mm/filemap.c
            <br>
            index b101405b770ae..d1fcddc72c5f6 100644
            <br>
            --- a/mm/filemap.c
            <br>
            +++ b/mm/filemap.c
            <br>
            @@ -3646,6 +3646,7 @@ static vm_fault_t
            filemap_map_folio_range(struct vm_fault *vmf,
            <br>
                                    unsigned long addr, unsigned int
            nr_pages,
            <br>
                                    unsigned long *rss, unsigned short
            *mmap_miss)
            <br>
             {
            <br>
            +       bool ref_from_caller = true;
            <br>
                    vm_fault_t ret = 0;
            <br>
                    struct page *page = folio_page(folio, start);
            <br>
                    unsigned int count = 0;
            <br>
            @@ -3679,7 +3680,9 @@ static vm_fault_t
            filemap_map_folio_range(struct vm_fault *vmf,
            <br>
                            if (count) {
            <br>
                                    set_pte_range(vmf, folio, page,
            count, addr);
            <br>
                                    *rss += count;
            <br>
            -                       folio_ref_add(folio, count);
            <br>
            +                       if (count - ref_from_caller)
            <br>
            +                               folio_ref_add(folio, count -
            ref_from_caller);
            <br>
            +                       ref_from_caller = false;
            <br>
                                    if (in_range(vmf-&gt;address, addr,
            count * PAGE_SIZE))
            <br>
                                            ret = VM_FAULT_NOPAGE;
            <br>
                            }
            <br>
            @@ -3694,13 +3697,19 @@ static vm_fault_t
            filemap_map_folio_range(struct vm_fault *vmf,
            <br>
                    if (count) {
            <br>
                            set_pte_range(vmf, folio, page, count,
            addr);
            <br>
                            *rss += count;
            <br>
            -               folio_ref_add(folio, count);
            <br>
            +               if (count - ref_from_caller)
            <br>
            +                       folio_ref_add(folio, count -
            ref_from_caller);
            <br>
            +               ref_from_caller = false;
            <br>
                            if (in_range(vmf-&gt;address, addr, count *
            PAGE_SIZE))
            <br>
                                    ret = VM_FAULT_NOPAGE;
            <br>
                    }
            <br>
            <br>
                    vmf-&gt;pte = old_ptep;
            <br>
            <br>
            +       if (ref_from_caller)
            <br>
            +               /* Locked folios cannot get truncated. */
            <br>
            +               folio_ref_dec(folio);
            <br>
            +
            <br>
                    return ret;
            <br>
             }
            <br>
            <br>
            <br>
            It would save at least a folio_ref_dec(), and in corner
            cases (only map a single page)
            <br>
            also a folio_ref_add().
            <br>
            <br>
          </blockquote>
          Maybe We can first count the refcount to add, and only call
          folio_ref_{add, sub} once before return
          <br>
        </blockquote>
      </blockquote>
      <br>
      I'm not a fan of that, because I'm planning on moving the
      folio_ref_add() before the set_pte_range() so we can minimize the
      number of false positives with our folio_ref_count() !=
      folio_expected_ref_count() checks, and I can sanity check when
      adjusting the mapcount that it is always &gt;= refcount. <br>
      <br>
    </blockquote>
    <pre>I see, I will send v3 as the diff sugguested by you.</pre>
    <pre>Thanks.</pre>
  </body>
</html>

--------------Te0gsmdQ2l0CU0PqrSMAsi4C--

