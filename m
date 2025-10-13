Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06488CCA476
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 08:27:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FF668E0024; Mon, 13 Oct 2025 04:27:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D7678E0002; Mon, 13 Oct 2025 04:27:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2ED2C8E0024; Mon, 13 Oct 2025 04:27:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9F38E0002
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 04:27:38 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C12E0C02A7
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:27:37 +0000 (UTC)
X-FDA: 83992412154.05.9FBB753
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 30551180007
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 08:27:35 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AIpSkemC;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760344055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IYc0yyeIWxSa0xUCnbG6eH4WRp+VUx0D733T1/rtD3M=;
	b=nwUzCXKoon7ZWZvKuehF/dlX+KpDxRsd+3n8vxSXb+SZp0P5aOdKBG0HvxbwnH1yvCxKud
	Rhows7XuMbVjMqQvpvZ+Ie4AZ2ACGgu/cob6yD5zokHHrSwszkPN1kN7impsrvaqGjDrZr
	IRFMJ424u4I3nrbTRd9HE+yyiCXHTIk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AIpSkemC;
	spf=pass (imf06.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760344055; a=rsa-sha256;
	cv=none;
	b=sL1ZlvU108nv/tWtn9qt887dzQTVdxdJRHE0U9SzqNP4o2NTPS3i+3rvqcLvURdCLMfVsg
	Zbajc5SU9HpSiLgatjvCjMeLUPUlFoO0iyMHGazqjcm0vCEuDyaHz7RZEpej2aXYfHkEyu
	EYtgUUf9u7hGl3Gbd0lzLmWv8M7Gg1A=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1760344054;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IYc0yyeIWxSa0xUCnbG6eH4WRp+VUx0D733T1/rtD3M=;
	b=AIpSkemCVeeLUkb4t6mtT350nDqEsUZtR9niwOTm6QqtlC2ohsq8LXZvPHEkaRVKhZKjj9
	y+Wu5+t1/lBJh+1FYXFcaqUMIszY6lKfeo3yClgoF1gBrmGRLk34ifK/LsQsWxqxFd+Yt/
	1dysrd/uE4i5OaM//Jl0J7wB3UbRbPA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-8pZORutEOya5CJ-7ruXd6w-1; Mon, 13 Oct 2025 04:27:32 -0400
X-MC-Unique: 8pZORutEOya5CJ-7ruXd6w-1
X-Mimecast-MFC-AGG-ID: 8pZORutEOya5CJ-7ruXd6w_1760344052
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-46fa88b5760so12545935e9.3
        for <linux-mm@kvack.org>; Mon, 13 Oct 2025 01:27:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760344052; x=1760948852;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IYc0yyeIWxSa0xUCnbG6eH4WRp+VUx0D733T1/rtD3M=;
        b=YtRxsQRh6PrbDHXIp9xC2uCqWuqFvxdy0UFdyhtmT8YaVGJqpOzTuwFHa25l4/d6o2
         35+LwiRkJapgxKzBcdl2kkAO/ywmS19b8aNeG9cB0+hU/ofV8W6W0WDUxeow1fc0glzI
         UcgFXSzEvah2qDOW2qUq3Ii5UjIxj5IMvbXhqpXZbY/R5fJGOMtqlz4UbQ8MQ2LR3m/l
         maRNE67P9BWYTzHJ6RRll9XIQeQqIt8X1Ryp1rer0hIe+W8cHJzoVJnFuYoklfhfx851
         yfKqWtOFWHN9CxGkNd2364zhLQgDiVT+eK+FOTPTljk8YFsptLd0tCouWkkyCDg1QuoX
         ef5g==
X-Gm-Message-State: AOJu0YxGYzQhY37kJvqvXYrYB8WFSb3y9bywWp/3wR+hpBNo+5DY9k+h
	NeSB+hJtYUWG/w6170MEMsKoPsfXkrG0WuDHuP9qd7y5m74W0lhob59PQ1igd7KUHoivfIc7LHI
	mfcInpPEI8B+fNfKl/ORo07yA5ryADCVxramjTjVgEtI1ejCv3i38
X-Gm-Gg: ASbGncvIklzNXsS9HU4RS01ZdEgX3KE/5ihmswrykCpcBRVFwHy7cm6iSWMimly5Wy+
	ckaH7B/IlxcrGcZ/Viuy9Q+DzujSujbrDEX3yVBZHoAJOmZOSZE6LTLmRI/JjelTlrWpQmRTCA2
	LZdam35RJipXCviWgzYfh/57kX3BM1zCRqmyObs/hsab/r8RTyVMT71UG/sOc1/053yRD0Zm0TN
	2TTesBDKqcgzzx0kKtbUik7d7/CbDuSPsTxA7+HH0lrdOVmYIDckHAmSTfmHNTwkplM8V6GxPSH
	gLjl4GiP+0sGkzreRsk3RyDBle51f4KjZI9BGtLGrroM1+s8p1t+r61p1qU9+aqy/6FiXSMfMLL
	vErk=
X-Received: by 2002:a05:600c:8b37:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-46fbbeb30afmr56924985e9.40.1760344051722;
        Mon, 13 Oct 2025 01:27:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFA2SBh7ozmWj8p4x8T0KaKYDgKMnupDj5F/SOVScJTQCghcNRaFN3WsoBZ6GD+Qz5jMvZobQ==
X-Received: by 2002:a05:600c:8b37:b0:46f:b42e:e366 with SMTP id 5b1f17b1804b1-46fbbeb30afmr56924695e9.40.1760344051179;
        Mon, 13 Oct 2025 01:27:31 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-189.customers.d1-online.com. [80.187.83.189])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46fb489accbsm196059665e9.14.2025.10.13.01.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 01:27:30 -0700 (PDT)
Message-ID: <adf3cb95-916b-4513-b763-48aa8fbfb700@redhat.com>
Date: Mon, 13 Oct 2025 10:27:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] hugetlbfs: check for shareable lock before calling
 huge_pmd_unshare()
To: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, broonie@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
References: <20251003174553.3078839-1-kartikey406@gmail.com>
 <20251008052759.469714-1-kartikey406@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251008052759.469714-1-kartikey406@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: -Rl7QAisrGJ9vMEWzNt1mksoeMAHzeLGSL__ZAyNfhk_1760344052
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 56tbnrjgn7jt9g6fx58h3zijem6ne7g3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 30551180007
X-HE-Tag: 1760344055-68201
X-HE-Meta: U2FsdGVkX19Aec0hJFYKwLFz5ahVJlcO8ddnV4nr3zLHG7VjlgWd5BEqfnQu2smC//exDZWsPcxLzg2WkN/QWAi7BcBCnFy1ytDD583EutguEr5b0Co9lMjjGeCUCeJpAfS53JCDD3FFn8Exng/Q/+2jx3xngGFGE2jOj+/NwsEGhNgCGnC4HmWf2b8f4ifeJAuEeZJyCzljuLvyig2G5SVjepuUZdAjFWY2GKzFgxxUPft0pIsY2bl51AZ+cGeh9RUJnzZbG8r/nf3wwHRmmjvfOrM/1vxaky7rxQqgefLp9qB9+RE/aQGaJpH+EKAEyU8wB5r/o8PPlVG1DqGz1JwrtFoW4CtZxiD9U1ygeZO2yvsYZ7LBKwleiaWEjkfv0lyY2GFXeIjw2t/Lq0YIz8VXkTmkyxMezjk5syq1RXb2AFMVLel0JSk0Nk6J+esU+aKee3b4+2eGaj2UXAoGKkjZK2WXJyl8tV+8094F2JhvQV9xuNYTTMhcWp3uNeQIpTUQT5a0ScKHaLQC+fbZHbDkwf7CbUI5oT4tA/GRR+CP8U5FYk7i1RkCEq7zcY8kxc4HkyBZ4mCGu7ThzjzPoSS79u6mwM7kk/31+rDjaH+eEuJAAQHV5s7D6/4HZ/llr55djlJUgUVN9yZEzA1Q03aMe68xEGTOdRg93lFhCFqqwlTvjD6xjDsqJwpXT5WM1P2zZJLxk17oS6hTM/B0b3Bpw7Qwjr6qX0XQqqVwu/151gNVqp6s12QsY/y+wkRG+1ZZirY6wtlA3p1lonIJD7rFlTuHhcEBFjchCHTMMTQlW2wurP59VfP2tGVgaRB0bIy5ki7BpRKyrjdr4aKdf9jd5WUubp9qhpScXxPQ8s3mny9PObcMnguVd6Xn0M/X4Tv+sdIPydYA7NwmKcwLBg6O39kGEf+XHpS/KlM8e8CoFj7XVeyPyiQvu/Fo1LiIeiHe7hmstKHwEDtVxx4
 DPtXcU7e
 mMLGgzgoYX6FSGvGlNyHG0DwN3H7u6YZ7VHHk8T65Zb13PO9eZSu4Ol+CedWpUYaUXRvknyG37gueueK9eXx2iN29z9yUFotTl1eLV2XCSR6hJP2ecquVtuyLLixArrAG/pn0ZE13XCL76mpQ9zilooKWH7Ae7HTjH7SrdapiPp1wdIJYP/DJUvnhfQE/0KisUAk1ibewc2CW8cYjimNwCiPCZ/Bp0jRdAq997U4unR0H0cpcnBxyDFTvj1eltoKDF3Fu8yco3d7puFhbNkOvA7Lt9cwH3EdJZDP8cs4yuIGro4hd3kG4U3lal5snFDzSCR4tmFFBOo9iZCtoV8mx5a8laCL4GD4sjxAKRKJPt6p34//jMxj8rjEkZjM9uKU0rDKfC94wjnNqxowBlHD4Lz9AfjudEnefDX0eLtpZHQvaNP4OpcXO+VuOuNYvS6SibJ1ktlhxxT9TnEGOt+bq1mTkP3cSrnuN3nxqxTjfO9+Lm8HT70sXPnARDGHdadeHFWLfqcuR8Jr0L2PC3aiaUsYhYOiswwQ1EEVBUq0xGYjTK4O+2uIl8wbvwvw+heSkJGlDoHDIizBniqVCUFJtaL9GcQ3mjDrZ2h8R+oMyZW17hYKseBV7DuvlBiiAawjQoTn7FABta6Cl+ZEYGsWEeGCYW9A9epDjXVbMc1Zhg+8m5gHvudHeoxp1Jx1O/qJzHonyhPATaqNwHxytvCVFWODPAXf1mz+3zJH8Qp75bqni90sJVPRPza8z5kK2s4Rg55tR3ZlrGJIprrlvAqWoxFFhFA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08.10.25 07:27, Deepanshu Kartikey wrote:
> When hugetlb_vmdelete_list() processes VMAs during truncate operations,
> it may encounter VMAs where huge_pmd_unshare() is called without the
> required shareable lock. This triggers an assertion failure in
> hugetlb_vma_assert_locked().
> 
> The previous fix in commit dd83609b8898 ("hugetlbfs: skip VMAs without
> shareable locks in hugetlb_vmdelete_list") skipped entire VMAs without
> shareable locks to avoid the assertion. However, this prevented pages
> from being unmapped and freed, causing a regression in fallocate(PUNCH_HOLE)
> operations where pages were not freed immediately, as reported by Mark Brown.
> 
> Instead of skipping VMAs or adding new flags, check __vma_shareable_lock()
> directly in __unmap_hugepage_range() right before calling huge_pmd_unshare().
> This ensures PMD unsharing only happens when the VMA has a shareable lock
> structure, while still allowing page unmapping and freeing to proceed for
> all VMAs.
> 
> Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Reported-by: Mark Brown <broonie@kernel.org>
> Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> Suggested-by: Oscar Salvador <osalvador@suse.de>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Link: https://lore.kernel.org/mm-commits/20250925203504.7BE02C4CEF7@smtp.kernel.org/ [v1]
> Link: https://lore.kernel.org/mm-commits/20250928185232.BEDB6C4CEF0@smtp.kernel.org/ [v2]
> Link: https://lore.kernel.org/linux-mm/20251003174553.3078839-1-kartikey406@gmail.com/ [v3]
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> ---
> Changes in v4:
> - Simplified approach per Oscar's suggestion: check __vma_shareable_lock()
>    directly in __unmap_hugepage_range() before calling huge_pmd_unshare()
> - Removed ZAP_FLAG_NO_UNSHARE flag per David's feedback to avoid polluting
>    generic mm.h header
> - Reverted hugetlb_vmdelete_list() to not skip VMAs
> 
> Changes in v3:
> - Added ZAP_FLAG_NO_UNSHARE to skip only PMD unsharing, not entire VMA
> 
> Changes in v2:
> - Skip entire VMAs without shareable locks in hugetlb_vmdelete_list()
>    (caused PUNCH_HOLE regression)
> 
> Changes in v1:
> - Initial fix attempt
> ---
>   fs/hugetlbfs/inode.c | 10 +---------
>   mm/hugetlb.c         |  2 +-
>   2 files changed, 2 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 9c94ed8c3ab0..1e040db18b20 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -478,14 +478,6 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
>   		if (!hugetlb_vma_trylock_write(vma))
>   			continue;
>   
> -		/*
> -		 * Skip VMAs without shareable locks. Per the design in commit
> -		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
> -		 * called after this function with proper locking.
> -		 */
> -		if (!__vma_shareable_lock(vma))
> -			goto skip;
> -
>   		v_start = vma_offset_start(vma, start);
>   		v_end = vma_offset_end(vma, end);
>   
> @@ -496,7 +488,7 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
>   		 * vmas.  Therefore, lock is not held when calling
>   		 * unmap_hugepage_range for private vmas.
>   		 */
> -skip:
> +
>   		hugetlb_vma_unlock_write(vma);
>   	}
>   }
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6cac826cb61f..9ed85ab8420e 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -5885,7 +5885,7 @@ void __unmap_hugepage_range(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		}
>   
>   		ptl = huge_pte_lock(h, mm, ptep);
> -		if (huge_pmd_unshare(mm, vma, address, ptep)) {
> +		if (__vma_shareable_lock(vma) && huge_pmd_unshare(mm, vma, address, ptep)) {
>   			spin_unlock(ptl);
>   			tlb_flush_pmd_range(tlb, address & PUD_MASK, PUD_SIZE);
>   			force_flush = true;

Wondering, couldn't we handle that in huge_pmd_unshare()?

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index eed59cfb5d218..f167cec4a5acc 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7598,13 +7598,14 @@ int huge_pmd_unshare(struct mm_struct *mm, struct vm_area_struct *vma,
         p4d_t *p4d = p4d_offset(pgd, addr);
         pud_t *pud = pud_offset(p4d, addr);
  
-       i_mmap_assert_write_locked(vma->vm_file->f_mapping);
-       hugetlb_vma_assert_locked(vma);
         if (sz != PMD_SIZE)
                 return 0;
         if (!ptdesc_pmd_pts_count(virt_to_ptdesc(ptep)))
                 return 0;
  
+       i_mmap_assert_write_locked(vma->vm_file->f_mapping);
+       hugetlb_vma_assert_locked(vma);
+
         pud_clear(pud);
         /*
          * Once our caller drops the rmap lock, some other process might be

-- 
Cheers

David / dhildenb


