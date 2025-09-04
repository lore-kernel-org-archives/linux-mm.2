Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39802CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 01:06:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8FA478E000C; Wed,  3 Sep 2025 21:06:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AAFC8E0001; Wed,  3 Sep 2025 21:06:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0EC8E000C; Wed,  3 Sep 2025 21:06:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 66A4C8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 21:06:03 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 050F413BB93
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:06:02 +0000 (UTC)
X-FDA: 83849776206.22.C1A8F3A
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf11.hostedemail.com (Postfix) with ESMTP id E5DE640013
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 01:05:59 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756947961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/cf8xzxgUV1snPOTNaz/GhSh78iXOfgxIAOqboaFvgM=;
	b=6B3FJhlgy2RIWyzFMs/uAYymRok+HE/34oMV1rPZDBiP670iDejClYaYgkH2IBu/X49WUP
	SSnwSiQXitNXnJi/ck6OxpesDL4NAfe83ZEWki3HXAz/2Z6XYcnSRcifqVhLvjY7Yw+zJr
	uiAbM/qy/OOdcowFGPq4uD3PQ92tvQY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756947961; a=rsa-sha256;
	cv=none;
	b=4hqGDDWgm3pdx5YGCBHGWdRLYpS7g4t2czOSccNnURu1lgy8SeARk9xOtc6hf0uw6n/HL7
	xyE8oyviEU06yJPO7r/OEucuyG8CLhu41JA+koWDRYhpTWq4d1UA9Fj7JjQF4sAVJXBtXq
	z7JYbjXJrA+9u3LnwWcRWWs0Hy+nZWQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf11.hostedemail.com: domain of tujinjiang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=tujinjiang@huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cHLmf4wbxz2VRh2;
	Thu,  4 Sep 2025 09:02:26 +0800 (CST)
Received: from kwepemr500001.china.huawei.com (unknown [7.202.194.229])
	by mail.maildlp.com (Postfix) with ESMTPS id 770951401F3;
	Thu,  4 Sep 2025 09:05:34 +0800 (CST)
Received: from [10.174.178.49] (10.174.178.49) by
 kwepemr500001.china.huawei.com (7.202.194.229) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 4 Sep 2025 09:05:33 +0800
Content-Type: multipart/alternative;
	boundary="------------A492Ru4Vmeb1KvsDwdS9HbYp"
Message-ID: <f5dd70ab-c610-4142-be57-1fa311672b5e@huawei.com>
Date: Thu, 4 Sep 2025 09:05:32 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] filemap: optimize order0 folio in filemap_map_pages
To: David Hildenbrand <david@redhat.com>, <willy@infradead.org>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
CC: <wangkefeng.wang@huawei.com>
References: <20250903084223.1653192-1-tujinjiang@huawei.com>
 <3c283054-b14e-4f36-966f-78cf3bc0f3af@redhat.com>
From: Jinjiang Tu <tujinjiang@huawei.com>
In-Reply-To: <3c283054-b14e-4f36-966f-78cf3bc0f3af@redhat.com>
X-Originating-IP: [10.174.178.49]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemr500001.china.huawei.com (7.202.194.229)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E5DE640013
X-Stat-Signature: 8u7x9b9pbwoqtidb3gnpqwmutom3taua
X-HE-Tag: 1756947959-378747
X-HE-Meta: U2FsdGVkX1+MFv3Gw+gBINFqJlopz/hpqkp4iE8ABYJhrK+0cO2xfpMgBWlXoAN5zic5F2jTyAmoQMwDvb3D4vIR2IiwhOd+21vKKf1vV+iciNKkFd/EISPkqMikiOrOQUpMV2WLnDMy7JeULPlOxOwJ7FBSzQ8+EFddqIjDdHj7xAdRJCWXG/tOfCrqckTgaSHX3OEOovft/K4oS6OM/VaEX1gFHNbFsCJY4h0/06VlJPuHcRFkwQDxh00QfC9kOzuZNlbR03uMvHY9UvCFHKSxhByR8OB1nV7iDn3fCMLEcpG1AOeBUSqAKmod19cdYyImhCRjC3WYtbYSrGt4gO4klc1UHz6a1nUjMCiEA7DKjE0MSN6tchQcdQ4eTDTzrbrC5MqqM1XRxPVtbiriJUwMBXzeHNicUqWV8lNgC3KQVS6Bil3JltbfQTT95Fub9UcD7N2JjnX8f/0ySwtYnp7MqUtsZ8v78UuBK863PU80U3IQ+V83L5TjYDG5f+i5ktoIORVPYNkL+6ScO5i5by6wbvNLo8UuuLSSxLlAfXGtSY8MwfWVGq3AnQO8Jzx1kmQ5visaNOQ4n0OFS38oFkJpKUUJriJCfhxlbxh7g3G4G4nBJcdv+hKVUa+r3vQGvV5F82Wk37kMcsW25NLwm0mlAUfOYe9eCIZ8zvfVX+czfQbi1VRyIavOp4jKRKDJf9bdBkCpY7ZQBe2Inc56nDNBKoVEQ43H/YpVc0Rkdzvkq0Ntw2MZGJkADn6ZwZ0/SE1f2arrpgflZOdga2wUbgLMzf1oqxqToswJEuODLNtbWjL7CdlSe5kjijv4yrDp5Y/lg5g91uLgatLJY84FpaNl5OTehI0mj+TIKLGv+ulgNeXFg6VeCdUW+ze5ekGB3HlpMXO0riJFBvWc1gFrjZ1u2AuAbfiNw2B2l1pwSNAtgM5m0Rau8VtxtN3gUAO9WiehZMz1J6uZZBLF5Ik
 +293Tnqc
 KE3+2QfS+VcV+9uraFkiU6P7AWkS+1P+7UrqeiGDjuPFLc3S0K4MktpwkQNJQmb8W1I0Z/GW+CaIfjOH4NVehCBckl6JmvWBHqs4PXT7uPF214AJs+ra0t/3+PHJMupGmvbj7jL15C1DWXZF+6HICgy49oKJ/YRLnwuuL4Es36/1qy+wWPjPMNeYuX1Qp+t2sYSsUgvH1FoMeiw8awj/iYP5kBfYa934Hccw9seOE6YFN1RKVxNDEbJQs9zmkeNuKHfB75cVF/VVdQb/qFAeJoI0QxU/DryJGVx3Og7yB0tOCW8VBL2DqZ3ePsq+V0F91ADAw+sK2mjRVzs/L05nMIMiMm0zXBVQw8zdJWiOkprwWLWlhMnlV3hJHJKjSXXAaJpFFufF23zIDABh4hUq8VsneuwJXeXpgZMS6
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--------------A492Ru4Vmeb1KvsDwdS9HbYp
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit


在 2025/9/3 17:16, David Hildenbrand 写道:
>> +++ b/mm/filemap.c
>> @@ -3693,6 +3693,7 @@ static vm_fault_t 
>> filemap_map_folio_range(struct vm_fault *vmf,
>>       }
>>         vmf->pte = old_ptep;
>> +    folio_put(folio);
>>         return ret;
>>   }
>> @@ -3705,7 +3706,7 @@ static vm_fault_t 
>> filemap_map_order0_folio(struct vm_fault *vmf,
>>       struct page *page = &folio->page;
>>         if (PageHWPoison(page))
>> -        return ret;
>> +        goto out;
>>         /* See comment of filemap_map_folio_range() */
>>       if (!folio_test_workingset(folio))
>> @@ -3717,15 +3718,17 @@ static vm_fault_t 
>> filemap_map_order0_folio(struct vm_fault *vmf,
>>        * the fault-around logic.
>>        */
>>       if (!pte_none(ptep_get(vmf->pte)))
>> -        return ret;
>> +        goto out;
>>         if (vmf->address == addr)
>>           ret = VM_FAULT_NOPAGE;
>>         set_pte_range(vmf, folio, page, 1, addr);
>>       (*rss)++;
>> -    folio_ref_inc(folio);
>> +    return ret;
>>   +out:
>> +    folio_put(folio);
>
> We can use a folio_ref_dec() here
>
>     /* Locked folios cannot get truncated. */
>     folio_ref_dec(folio);
>
>>       return ret;
>>   }
>>   @@ -3785,7 +3788,6 @@ vm_fault_t filemap_map_pages(struct vm_fault 
>> *vmf,
>>                       nr_pages, &rss, &mmap_miss);
>>             folio_unlock(folio);
>> -        folio_put(folio);
>>       } while ((folio = next_uptodate_folio(&xas, mapping, 
>> end_pgoff)) != NULL);
>>       add_mm_counter(vma->vm_mm, folio_type, rss);
>>       pte_unmap_unlock(vmf->pte, vmf->ptl);
>
>
> I think we can optimize filemap_map_folio_range() as well:
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index b101405b770ae..d1fcddc72c5f6 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3646,6 +3646,7 @@ static vm_fault_t filemap_map_folio_range(struct 
> vm_fault *vmf,
>                         unsigned long addr, unsigned int nr_pages,
>                         unsigned long *rss, unsigned short *mmap_miss)
>  {
> +       bool ref_from_caller = true;
>         vm_fault_t ret = 0;
>         struct page *page = folio_page(folio, start);
>         unsigned int count = 0;
> @@ -3679,7 +3680,9 @@ static vm_fault_t filemap_map_folio_range(struct 
> vm_fault *vmf,
>                 if (count) {
>                         set_pte_range(vmf, folio, page, count, addr);
>                         *rss += count;
> -                       folio_ref_add(folio, count);
> +                       if (count - ref_from_caller)
> +                               folio_ref_add(folio, count - 
> ref_from_caller);
> +                       ref_from_caller = false;
>                         if (in_range(vmf->address, addr, count * 
> PAGE_SIZE))
>                                 ret = VM_FAULT_NOPAGE;
>                 }
> @@ -3694,13 +3697,19 @@ static vm_fault_t 
> filemap_map_folio_range(struct vm_fault *vmf,
>         if (count) {
>                 set_pte_range(vmf, folio, page, count, addr);
>                 *rss += count;
> -               folio_ref_add(folio, count);
> +               if (count - ref_from_caller)
> +                       folio_ref_add(folio, count - ref_from_caller);
> +               ref_from_caller = false;
>                 if (in_range(vmf->address, addr, count * PAGE_SIZE))
>                         ret = VM_FAULT_NOPAGE;
>         }
>
>         vmf->pte = old_ptep;
>
> +       if (ref_from_caller)
> +               /* Locked folios cannot get truncated. */
> +               folio_ref_dec(folio);
> +
>         return ret;
>  }
>
>
> It would save at least a folio_ref_dec(), and in corner cases (only 
> map a single page)
> also a folio_ref_add().
>
Maybe We can first count the refcount to add, and only call folio_ref_{add, sub} once before return


--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3643,6 +3643,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
         struct page *page = folio_page(folio, start);
         unsigned int count = 0;
         pte_t *old_ptep = vmf->pte;
+       int ref_to_add = -1;
  
         do {
                 if (PageHWPoison(page + count))
@@ -3672,7 +3673,7 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
                 if (count) {
                         set_pte_range(vmf, folio, page, count, addr);
                         *rss += count;
-                       folio_ref_add(folio, count);
+                       ref_to_add += count;
                         if (in_range(vmf->address, addr, count * PAGE_SIZE))
                                 ret = VM_FAULT_NOPAGE;
                 }
@@ -3687,12 +3688,17 @@ static vm_fault_t filemap_map_folio_range(struct vm_fault *vmf,
         if (count) {
                 set_pte_range(vmf, folio, page, count, addr);
                 *rss += count;
-               folio_ref_add(folio, count);
+               ref_to_add += count;
                 if (in_range(vmf->address, addr, count * PAGE_SIZE))
                         ret = VM_FAULT_NOPAGE;
         }
  
         vmf->pte = old_ptep;
+       /* Locked folios cannot get truncated. */
+       if (ref_to_add > 0)
+               folio_ref_add(folio, ref_to_add);
+       else if (ref_to_add < 0)
+               folio_ref_sub(folio, ref_to_add);
  
         return ret;
  }


--------------A492Ru4Vmeb1KvsDwdS9HbYp
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
    <div class="moz-cite-prefix">在 2025/9/3 17:16, David Hildenbrand 写道:<br>
    </div>
    <blockquote type="cite"
      cite="mid:3c283054-b14e-4f36-966f-78cf3bc0f3af@redhat.com">
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
          @@ -3785,7 +3788,6 @@ vm_fault_t filemap_map_pages(struct
        vm_fault *vmf,
        <br>
                              nr_pages, &amp;rss, &amp;mmap_miss);
        <br>
                    folio_unlock(folio);
        <br>
        -        folio_put(folio);
        <br>
              } while ((folio = next_uptodate_folio(&amp;xas, mapping,
        end_pgoff)) != NULL);
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
                              unsigned long addr, unsigned int nr_pages,
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
                              set_pte_range(vmf, folio, page, count,
      addr);
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
                              if (in_range(vmf-&gt;address, addr, count
      * PAGE_SIZE))
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
                      set_pte_range(vmf, folio, page, count, addr);
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
      It would save at least a folio_ref_dec(), and in corner cases
      (only map a single page)
      <br>
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
+               folio_ref_sub(folio, ref_to_add);
 
        return ret;
 }</pre>
    <p><br>
    </p>
  </body>
</html>

--------------A492Ru4Vmeb1KvsDwdS9HbYp--

