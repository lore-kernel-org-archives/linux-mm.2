Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C496CCD1AB
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 08:30:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D3E188E001B; Wed, 22 Oct 2025 04:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CEE968E0002; Wed, 22 Oct 2025 04:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB69B8E001B; Wed, 22 Oct 2025 04:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A5DEE8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 04:30:32 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6F33013BBDD
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:30:32 +0000 (UTC)
X-FDA: 84025078704.03.F497ECA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf28.hostedemail.com (Postfix) with ESMTP id C6453C000A
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 08:30:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wd0gC0fK;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761121830;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsxLvpRfVAtzWmwD/BrE9GukZbvo8A6MtCgmoy18IPU=;
	b=oApsdrxPPfCNGDqiE9JY7Zbi2Hvw/GcV5scZ36AnupLZD2PkgEi8U0KKZP9Clayy3811nY
	vFzyNLzpPR//5dPuLZtYc4aXt/2d2ZMYU4lbpdF/GyHM/Uq6xq18ZngYZ1Xw3+D+kh6eoD
	iKo/V5SdCo+lHQM/aX2iq6TWwKXPwDQ=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Wd0gC0fK;
	spf=pass (imf28.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761121830; a=rsa-sha256;
	cv=none;
	b=wj+1UG/W3prqlAaLPNwWmXhvAOHEYwOgnFHVm1hq839ZlItUYfjPrkjgQUm7VNA/VtCfGo
	mayr+PdbIw4BTPvnZel4zK53tmKzL+N15iku8uplJ0dz6hb6XnC4fKiLs0P/77/k+sfum0
	yJhjlFQ0zkvQSC8gO0Ui/g+Scib7u48=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761121829;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=EsxLvpRfVAtzWmwD/BrE9GukZbvo8A6MtCgmoy18IPU=;
	b=Wd0gC0fK2M7DtefLZMaxzfK+jWgGWpn9sPTXOxpcfpVRkOWDdxIq9YQIRep64WBnpNtLq8
	N7h68erYZAcaftAQR4jJjIujqpg3xpF2je72iyp25b3TIE+MbLxo0RwicG8gv6cH0fVXbV
	SSCjyGVt2Qn4K1KkLCXCgRC9rf6tuXE=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-517-YW9TbHvvOMizLWLhBT08lA-1; Wed, 22 Oct 2025 04:30:27 -0400
X-MC-Unique: YW9TbHvvOMizLWLhBT08lA-1
X-Mimecast-MFC-AGG-ID: YW9TbHvvOMizLWLhBT08lA_1761121826
Received: by mail-wr1-f70.google.com with SMTP id ffacd0b85a97d-40cfb98eddbso291350f8f.0
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 01:30:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761121826; x=1761726626;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EsxLvpRfVAtzWmwD/BrE9GukZbvo8A6MtCgmoy18IPU=;
        b=YDDmbQw3zHl3iNdZmG3N7YVWuNrhQWK3U33dE8vYuNLQxGEC5F3DEV6TYvCdAGLcbX
         /9a9F6dDLEMQEYq49X0trsDJSzhtMQPXf/Eeh/9t8CHKOc6RRuJqOnKf1jroF3p0jOsi
         8r6GIDhzAipqwTVA7UvvZcjApWhHzV37qjm9545ZUPjWnoZT0ioNHYYJ14jZVDd2HMrw
         Wr3WALVYvi/Y1dH7nRetbCJEziroOzSvpHT8VcQgQIYfNSvh8u6IhD1AqqpruhKtdsR7
         BSVjDeFa2OlZThRbaCr+PRqCLGvicFBPQugkHqmWav5N36+2NmcIxZwmsaHQoc/wOObM
         Hxqw==
X-Forwarded-Encrypted: i=1; AJvYcCWxRhnBn/98rIe2K4fD1SQSX4+sEoMra0glmK3TVaS/wK0JXcJhVALpUCt/Tzak2IGGzHwMHoMPMQ==@kvack.org
X-Gm-Message-State: AOJu0Yy3sCyPggLUlPXHvGn5t6Jqbkz0co6F0GiKTbEd8a3WVWRXa4WP
	y9Dq3LTH79elG1530WmGIfR4OXd0CXQqh7rKwBFNFCusnsnEZWpPfBXJIjdVz7+MP5iqvjIzsou
	Rjukg+QOyEBfcVi3dLF/VE1Kne9lD63uFxcdwDXkLs0Ju0Dk6u1cK
X-Gm-Gg: ASbGncu7ADTOu6/iZidvfYrtVv+V/rCBt9DEfWlfPJgOWdGJoEJhHNIZBIhlF77ejCN
	+fxZkwy9nyYOWNHh+0rAqAtQFkbN1bQE9L3pu4vpcDkqPhunk996OEX6zMIi+BSrhfBvvsE2OWv
	AkGYaYZaDAaGRFvGOImO47ZFUF21CF0cGgmwvAiercoSGDVwSpo69FuwaiLyjdEMtnJDQM6DEh+
	349t8ki9Zsa7VwxR85aHoYmLA1O70jasuIghTxpgJU3fVzfc2dd0+qwxAcAYwT5GZKhBM7xLoka
	h6REMWr75rWi32IPc6ckSTxEFHsVdB+NS/G1xAd5C7/eesm8+o8/R9hvLf7Aw6+0aL0Au2ymnCj
	NLBonuM3BFqXpkdvIytnSzaqf4fq+bpTea5svnoxQ6ybsaRh9Q5Zm/PJKNWWdses20Plo6TOfZQ
	4hYyn8xdhSznb3LvW7UEaVS+b/bfA=
X-Received: by 2002:a05:6000:4025:b0:401:c55d:2d20 with SMTP id ffacd0b85a97d-42856a892b7mr507133f8f.26.1761121826478;
        Wed, 22 Oct 2025 01:30:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEr1mFA4TypwGaJb/ZVWY2T1KbDUJFoQ4UPJFSPR1XrWyJedLY+MVkn551j2s+baXToxNihRQ==
X-Received: by 2002:a05:6000:4025:b0:401:c55d:2d20 with SMTP id ffacd0b85a97d-42856a892b7mr507111f8f.26.1761121826043;
        Wed, 22 Oct 2025 01:30:26 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f009a6c5sm24596493f8f.28.2025.10.22.01.30.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 01:30:25 -0700 (PDT)
Message-ID: <43cc7217-93bc-4ee6-99d2-83d9b26eb31a@redhat.com>
Date: Wed, 22 Oct 2025 10:30:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible regression in pin_user_pages_fast() behavior after
 commit 7ac67301e82f ("ext4: enable large folio for regular file")
To: Zhang Yi <yi.zhang@huaweicloud.com>,
 Karol Wachowski <karol.wachowski@linux.intel.com>
Cc: tytso@mit.edu, adilger.kernel@dilger.ca, linux-mm@kvack.org,
 linux-ext4@vger.kernel.org
References: <ebe38d8f-0b09-47b8-9503-2d8e0585672a@huaweicloud.com>
 <20251020084736.591739-1-karol.wachowski@linux.intel.com>
 <0fec500c-52ea-473d-b276-826c0f4dd76f@huaweicloud.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <0fec500c-52ea-473d-b276-826c0f4dd76f@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: yirqG0XFSES9JAg3s_n9pXmNQLqD-PWg2EDiVC1oKP0_1761121826
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C6453C000A
X-Stat-Signature: ag4qccsx469bwwypcmcp1g6heny9b4zc
X-Rspam-User: 
X-HE-Tag: 1761121829-522145
X-HE-Meta: U2FsdGVkX18Q/6c8kyTgPpyWWOa91GcHip19guspW++oHcsKu45U5Gsn8cz5yf+JXD1bD6Dw/XxoAt1uRS9HuGkIqgbZTbS7wR4u+D7yiAaCXAY6G9ulY4lZleLzYeUjZEQK+odS2pInbqKOqiU27T8yah6WpLz0+EZmFO4ygaU57N8/s1mx+X3VXQu3SQ2iInwPFMjjnFAKkl3g1X7C1AcGBTUyQh11amS/ALS11an0NsVlotpYjFQyIDFG7SpheaXQnUmHxR8LiT6TGa9gRgPS3Bwt70lMUIH5Dz6WcOBFf3a0bNFKHIQAHL6hcHsL9RpOgnNw96symSiXcIweIGaox0WFXr4OrDnXPdyE1R5IDInNZ8AFvNROx76Ih0Km0CzgldZIiE9Fd832cQm4AfBtQPNF3qvA6GBiEqFFypQjDwTvGeLxtbsAK8InY4jA48v9//I5H9N7bw7OsxUnNNDz+aIuqzzG46k8tBME6kAdXlblpLB4feW0ghvkLi+loEZ15kEDQphzmp4cEmkcRoDotTq066Moeo1zIWCElX8Yz92Ox450dAAJC6ug9GqXW04h2bFK6CEa/PuKU0y+HNX8Ue1MZXTCe0DE9cnALSMst7OzApjjppXUgGElukKi0id6yRWVNKg1H7u5GJUsxnSNZSWgjq0fvJW5TLEo1STPQaULidLk9/p3aZDvhjctcEnVXfKFUSQMByzKcqqvmECrnJEIdzONIL+zqCKxEqpLD/0/GoNlPNduZhzKoE80y76D16Iq6GcRrqUkZKqASE6nHAxmPT4gnYmlCRAeFl4TaGmJ263vWM6VygukgBta0+FFjEkNDZKUVNNdV+P+K3Nxb/apEFqASCbv4d4vsjw8yzEMnQo3k9iJZ5SQ6uyRB3yWe0XfeolvcJk7X+Phe4QCcjSqHEsmuXKvbZ5cLu4eJNITjiEWzdNaQSH0s8+Od/hMKNSBuOATWi0kRCV
 AbXMVYxw
 o3SwAWQGPawDamnC8HE0IOfhR/LK3For1TXzQ6BePdOxyqusl0ELquCJ2QVoeBKnWzBZTGj6PmCax/zo2B+tWMfERt6BvMFm/l+opZQdwA16eJV9VzdZa1OjyReFQy2XLkuCw3K91mst6MrfdJ5/TekopR5h4lFaitIErMUjWzoW4lEcE6E3xVNaSDVqkzobgxSiCzYoO0qmDdEfmVVXVWIB0prMyglGcavt7OTa3bvTvYF/6/n7c+G9CYiTCZ+OaxuvIrThtRxig6Sdbt/B0JRJCqsqYsdaKrorbwoDkDx9kNILWPr/9M4aMR+aosPBhaxhxhZL7JhkyfMyJasBEwCdUFFbSzMWs8KQdtnNSpkUUiN2mXLKwZlOshKBFyEnI8DF3Afo77kvJSqMDHU0BJgxSt8k0TgOv/WT8vrDbxnPexZf4aNr/PpL/HvPrl5SR0jBgVlu0AaTXremlWNtJ22JaDNKem4nkaIdP6c/sPpmchj8tQLv0DDDypGLMf2wtZ8juTcSdGyk2rK/sozBMtFiRIhgM5Ebe7fcYVHeR+ISUYhIGRvSag5tkVEjBNrencF0eRKV4kyVg9shosCBhyxKz9w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.10.25 04:46, Zhang Yi wrote:
> [add mm list to CC]
> 
> On 10/20/2025 4:47 PM, Karol Wachowski wrote:
>> Hi,
>>
>> I can reproduce this on Intel's x86 (Meteor Lake and Lunar Lake Intel CPUs
>> but I believe it's not platform dependent). It reproduces on stable.
>> I have bisected this to the mentioned commit: 7ac67301e82f02b77a5c8e7377a1f414ef108b84
>> and it reproduces every time if that commit is present. I have attached a patch at the
>> end of this message that provides a very simple driver that creates character device
>> which calls pin_user_pages_fast() on user provided user pointer and simple test application
>> that creates 2 MB file on a filesystem (you have to ensure it's location is on ext4) and
>> does IOCTL with pointer obtained through mmap of that file with specific flags to reproduce
>> the issue.
>>
>> When it reproduces user application hangs indefinitely and has to be interrupted.
>>
>> I have also noticed that if we don't write to the file prior to mmap or the write size is less than
>> 2 MB issue does not reproduce.
>>
>> Patch with reproductor is attached at the end of this message, please let me know if that helps or
>> if there's anything else I can provide to help to determine if it's a real issue.
>>
>> -
>> Karol
>>
> Thank you for the reproducer. I can reproduce this issue on my x86 virtual
> machine. After debugging and analyzing, I found that this is not a
> filesystem issue, we can reproduce it on any filesystem that supports
> large folios, such as XFS. However, anyway, IIUC, I think it's a real
> issue.
> 
> The root cause of this issue is that calling pin_user_pages_fast() triggers
> an infinite loop in __get_user_pages() when a PMD-sized(2MB on x86) and COW
> mmaped large folio is passed to pin. To trigger this issue on x86, the
> following conditions must be met. The specific triggering process is as
> follows:
> 
> 1. Call mmap with a 2MB size in MAP_PRIVATE mode for a file that has a 2MB
>     folio installed in the page cache.
> 
>     addr = mmap(NULL, 2 * 1024 * 1024, PROT_READ, MAP_PRIVATE, file_fd, 0);
> 2. The kernel driver pass this mapped address to pin_user_pages_fast() in
>     FOLL_LONGTERM mode.
> 
>     pin_user_pages_fast(addr, nr_pages, FOLL_LONGTERM, pages);
> 
>    ->  pin_user_pages_fast()
>    |   gup_fast_fallback()
>    |    __gup_longterm_locked()
>    |     __get_user_pages_locked()
>    |      __get_user_pages()
>    |       follow_page_mask()
>    |        follow_p4d_mask()
>    |         follow_pud_mask()
>    |          follow_pmd_mask() //pmd_leaf(pmdval) is true since it's pmd
>    |                            //installed, This is normal in the first
>    |                            //round, but it shouldn't happen in the
>    |                            //second round.
>    |           follow_huge_pmd() //gup_must_unshare() is always true


FOLL_LONGTERM in a private mapping needs an anon folio, so this checks out.

>    |            return -EMLINK
>    |   faultin_page()
>    |    handle_mm_fault()
>    |     wp_huge_pmd() //split pmd and fault back to PTE

Oh, that's nasty. Indeed, we don't remap the PMD to be mapped by PTEs 
but instead zap it.

__split_huge_pmd_locked() contains that handling.

We have to do that because we did not preallocate a page table we can 
just throw in.

We could do that on this path instead: remap the PMD to be mapped by a 
PTE table. We'd have to preallocate a page table.

That would avoid the do_pte_missing() below for such faults.

that could be done later on top of this fix.

>    |     handle_pte_fault()  //
>    |      do_pte_missing()
>    |       do_fault()
>    |        do_read_fault() //FAULT_FLAG_WRITE is not set
>    |         finish_fault()
>    |          do_set_pmd() //install leaf pmd again, I think this is wrong!!!
>    |      do_wp_page() //copy private anno pages
>    <-    goto retry
> 
> Due to an incorrectly large PMD set in do_read_fault(), follow_pmd_mask()
> always returns -EMLINK, causing an infinite loop. Under normal
> circumstances, I suppose it should fall back to do_wp_page(), which installs
> the anonymous page into the PTE. This is also why mappings smaller than 2MB
> do not trigger this issue. In addition, if you add FOLL_WRITE when calling
> pin_user_pages_fast(), it also will not trigger this issue becasue do_fault()
> will call do_cow_fault() to create anonymous pages.
> 
> The above is my analysis, and I tried the following fix, which can solve
> the issue (I haven't done a full test yet). But I am not expert in the MM
> field, I might have missed something, and this needs to be reviewed by MM
> experts.
> 
> Best regards,
> Yi.
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 74b45e258323..64846a030a5b 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5342,6 +5342,10 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>   	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>   		return ret;
> 
> +	if (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE) &&
> +	    !pmd_write(*vmf->pmd))
> +		return ret;

Likely we would want to make this depend on is_cow_mapping().

/*
  * We're about to trigger CoW, so never map it through a PMD.
  */
if (is_cow_mapping(vma->vm_flags &&
     vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
	return ret;

-- 
Cheers

David / dhildenb


