Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3BC0CAC5B0
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 09:39:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F1DD8E000F; Wed, 24 Sep 2025 05:39:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C9568E0001; Wed, 24 Sep 2025 05:39:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9EB8E000F; Wed, 24 Sep 2025 05:39:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DC8118E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 05:39:53 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 969A31DFD81
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:39:53 +0000 (UTC)
X-FDA: 83923647066.20.CE39743
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2DF6520005
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:39:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N5r2Y0vR;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758706791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sBtWtIcm4uNLpnC5ycKK/EzXFgRKpe2dIBWZrRwdVUs=;
	b=2d4ViiCiz2oinjJklVhNsMUv1dvTFP6phcTx47XFBm07Bk+gD1MAjsrIOzCM/7IE8OoqyQ
	B6n2cGsOOY2pn4iMLEfc71zWcexBfIGPRcbYaXiplOlAKAFVGZIewrWOb3Q9E8dfQVCo8t
	nLnhFt4/TfB//D73RerQfzbKFlxX0kA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758706791; a=rsa-sha256;
	cv=none;
	b=Qdy1wHwsUhzm7Ym0g2L2t32Cozerwgqzcge9aSEYrXPHOvccFT0gxLr9EHVxv9wjnBvW46
	hcO5MfWUs/OtGlr81RgJVVMZtIY5bHH7yJyY2PjPYKYJEJH60RWUOEwJcwfKMoliN9bsnT
	fINZjVNm3a6CiBxk99HWLx6/d6gat8Y=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=N5r2Y0vR;
	spf=pass (imf13.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758706789;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=sBtWtIcm4uNLpnC5ycKK/EzXFgRKpe2dIBWZrRwdVUs=;
	b=N5r2Y0vRLpk6B+rDw+O58Uj+77+GhIh9O62I6bclhh39BA+FDDNhYRBLMzAArr3HOLARqD
	BZ13xoeyAtr0kmsM8s/nyuk7fee8bT9NdZAn/qj/h+2eHky2eAxvhHz/PX+B7GTvTH7gNf
	I2Ib0psPur0YE9ddadBBqEoCZCmQ0Wg=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-161--VMzaDNRM7GzGvVrFDvw-A-1; Wed, 24 Sep 2025 05:39:48 -0400
X-MC-Unique: -VMzaDNRM7GzGvVrFDvw-A-1
X-Mimecast-MFC-AGG-ID: -VMzaDNRM7GzGvVrFDvw-A_1758706786
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46b15e6f227so13263265e9.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 02:39:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758706786; x=1759311586;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sBtWtIcm4uNLpnC5ycKK/EzXFgRKpe2dIBWZrRwdVUs=;
        b=V5dWrkVqG28ubqrXvU0BkC4LpSjuCSrH1OBQ8UAf4rs7DXufpgKy1rnVV++PuxAp7s
         VDPrLCalL8eY+PJukpfDDPmbjK3KfUvJIiWoSPLaOlRiYmR/mjZdp6V+2npq5vHCEdn0
         e5X6vTqk1bmOVeClI2ODNfqxobxL4LH5clYK3fvSw/QW7wlYeYEynRVUmGwgJm9dEwvz
         ysL5f2GcrXMUYMyIxptwan0Trwg9TlJ2JkQVdVBuuh6pnsvEEL8ORCcBSXjEPfipF7JE
         PmcFSwLbfDN7UEJa/b4Ux2ZAgQeS2LLt9nQlBBiKw77R3fd1saNTChTH1wp579vxXG09
         qWSw==
X-Gm-Message-State: AOJu0YzSJEZMxkno3BwUTOpLcSRux4hAcb8+ToBLuk6Kq3JylhImSK8s
	/yIMvV6uusnnkjt5qQ/Np138tZYxAlFs3aGSnYVh50AF3VMrZTSutTuvifEg8XtESC1Il7uP8D7
	Y6oN0rJXOg89iqUZPMd+Rx01qJ93NcS3tVWNEFMBdj+/vR1oJpjUP
X-Gm-Gg: ASbGncsoP3VsQz669Cy3NxvDiymvEk/S9fePOpxVCE7ZTfz0GHwYGaR8QMV14M3+fNI
	T0GzuzGEONyv3kQ2tgiNeIp1FgLuR2NbI2bYpHJRVdMaD/ZvyT2k3cFveRV8K2VOPEUoOA4Jpm5
	VGZbqWjBjmi7ALfha4Kjhuq1YUCYP9MN5dU3e66pY64mciDbcDHEEAfRbWc5CNZtQAjO1pByI2D
	U7spfZ1Qk0mt+dwNu+IWKKa6c+RfbfdCSHRQ2II83cfhO5JT+WdMF6VOztv+n1Z4DP7JlIkH1Uh
	XsEFv1wzgyr9f2QK878WHwvK5j+A8ycSOFAxWhPophuxBUMd/TBs6hMJn2APT1Az2vR5jhU4uFU
	i/6Y1pu/UTA8m4lJ8LCBFyrkeAkvCANKyAxvmlSuPGYd9OvVvVq1jk3vfpjUbwSvRQA==
X-Received: by 2002:a05:6000:24c7:b0:3c8:7fbf:2d6d with SMTP id ffacd0b85a97d-405cb7bb8cbmr4752925f8f.50.1758706786327;
        Wed, 24 Sep 2025 02:39:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IELsQrH1u6AndZhOnAfrwbW6DKlO3Xc1JlZHRzbSnAkVMz1/nB3eQdXLFUiisR52Ncxx1IcZA==
X-Received: by 2002:a05:6000:24c7:b0:3c8:7fbf:2d6d with SMTP id ffacd0b85a97d-405cb7bb8cbmr4752894f8f.50.1758706785846;
        Wed, 24 Sep 2025 02:39:45 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f14:2400:afc:9797:137c:a25b? (p200300d82f1424000afc9797137ca25b.dip0.t-ipconnect.de. [2003:d8:2f14:2400:afc:9797:137c:a25b])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-46e2ab48c28sm24156105e9.18.2025.09.24.02.39.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Sep 2025 02:39:45 -0700 (PDT)
Message-ID: <1d593bac-0d9a-4cc5-8002-932e4ba88edd@redhat.com>
Date: Wed, 24 Sep 2025 11:39:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v3 2/2] mm/khugepaged: remove definition of struct
 khugepaged_mm_slot
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 xu.xin16@zte.com.cn, chengming.zhou@linux.dev
Cc: linux-mm@kvack.org, Kiryl Shutsemau <kirill@shutemov.name>,
 SeongJae Park <sj@kernel.org>
References: <20250924004854.29889-1-richard.weiyang@gmail.com>
 <20250924004854.29889-3-richard.weiyang@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250924004854.29889-3-richard.weiyang@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: cp16VrrdA5ZGmGiw7t0yrsg-RC6htHqRZSpoh4T2D4k_1758706786
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2DF6520005
X-Stat-Signature: bta4j7btfpwts61nfhxa6krx9auhyacf
X-Rspam-User: 
X-HE-Tag: 1758706791-181296
X-HE-Meta: U2FsdGVkX1+0gNUVOhDzXvXboDY3hyKyTjlJLutTYH21qsU9j5ctaQ0ZskDQu8QuIkwZGAC1qbG3rIBq50/6/2xynP69udZbcPQHHHyBP0RmBvKNze5DcOWsCWQLtOLH7MBgEWBuBfu6cpMg/HzdTS2HRFd6R8vcTz6LdNJSred0exeUrh4r7udsDsEXFtS0IlqknYochix2MqJWTrIf8ZX3EGRfJU/Het1e0RSOmQhXDHIrvesSiytbfG591bGGu1oD13Hg7TDIlIEqq8VAPksTi6W5VCvsZCqIKXdMp7yvf8QdskjJ00CBQlJDDIvIvR9w8VCCkE5hDB2BV57a6AYL4NNooio60vuSSs1eeFM6pKdgNMV9WtRtQ8Hs8Rs8DTRI5BforwjCJlolR6Y8Iqg9w9SMQAOeaecVuSqOfrUXyTOnP3PP/h3+VJeqAkLfnJx56lQZ6j6cxopRE9zR/DIEQdOjzgIfu5zc9FD+I9E1nc3TFEEskp8rDMFEjFZQLaau7hIVqr870IFKiE0ykJDRvwPnfMAcnnyFfzZlPOnBd4JQGK412BknxqHPnSzcTGcnBT69Ez3AP5SIj9gYfW32RVjKhd+zinz5GoWlsFQri7t6vNfJc2ZP9FFvE1GjYr4Z0LcGB0mAhvGr1PDETmT2o+KnpV/Y8Ud0RL8fDvbn8Z4ip0m2biEQaeAq8M/wy+1GMf6iVn+YGw8ytkmLBdmUvv3ts5kx/WOt9ArmcU/f8LMeQMPu/jXxg76f45MrM9Z6gf/bCAf8PGC+tnFeFFACBQr566i99iRlXH070t3BP680ZTp3DTYVPAuwGmpNm7vDQ1XdiSIl1f7g6PHF84bPCvy4ia5yteDVm3c6ZrhrCbV3zGpQQ27R5LOmu3hJpETgptq5fjWXoc6SbaC14yKBMCpkUeHS8U1NKQcL8PTGkqiP9peIZdUUOpXBU5e68fx9ZHs8515CnniMxBV
 e+7ylp/b
 2Iq1xGsGn5hzLScI6G6q2aFpypO5e5UyJ6SKoTeBXoJqy6aYI9ZLSpqUjwa7pKup8+EBBWjgpbCGfBfUp9TALn7AuM6nw1sKegocZHz/1A3LGyY4Nvfzuu0nHOcVkuqG+E+uFogeAyd6PDKJYPaoCKTYtL1R/VtqcbQ/Rz2OuiYxmSezFTAb5HUrSxgIuWYiLC/qp3czC0Uqezh0V9aptqHakAw5p7QxafyEp8zKZkks2VAiwLXtRgi5gZLQD/K5e6C1KxOknOZW+Up8XxR7QjFmC/TLlRoE3erAHvrRdWt2RR4w+gvSPAYlJAC4m8PsooV2eep/s6Y6ttX3de6sX02MyCPhlRfk2mOqnBA0noEok09Rdvxq71e/8XpYIG9k0D1Ux3BcoQkQYGLOIyfbBOtLkCD6306SNp/0A17AUJgo8AMZhhlATN5jvrvVR37h4bL/8D6QnzJ3nd4LJkbUmX2W0YVJA6+CYjMHDHeSWnI/7bUKzI63OO8omnv+Irb03wQc9pji3jam2emyl09w+KufdxxuB2PF8kmzAXW4LoJT7Eokn2cPfHdAI51cmJ2Yau4XxyhCxCk2b34Vb0F4ZIeIwkZhkxda9MRiKpfjPjAW5gBoWq740uQmacTicWSLOlYo0gMcETzQ0B+p2MGprBkwLJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.09.25 02:48, Wei Yang wrote:
> Current code is not correct to get struct khugepaged_mm_slot by
> mm_slot_entry() without checking mm_slot is !NULL.  

"Current code calls mm_slot_entry() even when we don't have a valid 
slot, which is not future proof."

There is no problem
> reported since slot is the first element of struct khugepaged_mm_slot.

"Currently, this is not a problem because "slot" is the first member in 
struct khugepaged_mm_slot."

> 
> While struct khugepaged_mm_slot is just a wrapper of struct mm_slot, there
> is no need to define it.
> 
> Remove the definition of struct khugepaged_mm_slot, so there is not chance
> to miss use mm_slot_entry().
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: Kiryl Shutsemau <kirill@shutemov.name>
> Cc: xu xin <xu.xin16@zte.com.cn>
> Cc: SeongJae Park <sj@kernel.org>
> Cc: Nico Pache <npache@redhat.com>
> 
> ---
> v3:
>    * fix a PF reported by SeongJae, where slot is changed to next one
> ---
>   mm/khugepaged.c | 58 ++++++++++++++++++-------------------------------
>   1 file changed, 21 insertions(+), 37 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 204ce3059267..e3f7d1760567 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -103,14 +103,6 @@ struct collapse_control {
>   	nodemask_t alloc_nmask;
>   };
>   
> -/**
> - * struct khugepaged_mm_slot - khugepaged information per mm that is being scanned
> - * @slot: hash lookup from mm to mm_slot
> - */
> -struct khugepaged_mm_slot {
> -	struct mm_slot slot;
> -};
> -
>   /**
>    * struct khugepaged_scan - cursor for scanning
>    * @mm_head: the head of the mm list to scan
> @@ -121,7 +113,7 @@ struct khugepaged_mm_slot {
>    */
>   struct khugepaged_scan {
>   	struct list_head mm_head;
> -	struct khugepaged_mm_slot *mm_slot;
> +	struct mm_slot *mm_slot;
>   	unsigned long address;
>   };
>   
> @@ -384,7 +376,10 @@ int hugepage_madvise(struct vm_area_struct *vma,
>   
>   int __init khugepaged_init(void)
>   {
> -	mm_slot_cache = KMEM_CACHE(khugepaged_mm_slot, 0);
> +	mm_slot_cache = kmem_cache_create("khugepaged_mm_slot",
> +					  sizeof(struct mm_slot),
> +					  __alignof__(struct mm_slot),
> +					  0, NULL);


Just wondering: do we really have to maintain the old name? Could we 
instead just have

mm_slot_cache = KMEM_CACHE(mm_slot, 0);

?

-- 
Cheers

David / dhildenb


