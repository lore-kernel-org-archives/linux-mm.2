Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7756CCA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:25:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C104D8E00DA; Tue, 26 Aug 2025 09:25:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC0268E00D9; Tue, 26 Aug 2025 09:25:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAEA88E00DA; Tue, 26 Aug 2025 09:25:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 97F2C8E00D9
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:25:26 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 442A71607E8
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:25:26 +0000 (UTC)
X-FDA: 83818980252.06.9C8BBAC
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id B381940014
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:25:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EnJ0hlmY;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756214724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4QSSifgUL+pROPLdu64RBhU3ne5/Fuiph5UVy59wA20=;
	b=IK6YIojn/BpQgF4ov/q0gblEKfhiZp5bfaPSpcVnL1k0ciaKWGQOnjwTZVIdEwcovaSE1D
	RJXOIKix5nWcLXGsVtJmVJs/qbbPRJpBh626Lm+YMB8cRGTAL0SXozbSTSdfl7wIHWDnlk
	dv/HxBNv2M2BQi/bKeRyC5iTGLMAD6A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=EnJ0hlmY;
	spf=pass (imf27.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756214724; a=rsa-sha256;
	cv=none;
	b=QXOdRW6+Cnuy2nzy2j4X/5eRewl0QnhcbtCBB4YqEItQebVOXzisJb/r6Oo/eIaaqHtXNb
	biDmgzn/+WafP/rBXsEd6BnGmnJ+OCdZrwdDsMk2Dr2TENu0LuVTdZqOm3N28Om1tYDlwS
	EafaeozejUvc4sc/LmeR6AK8hPuD+Ds=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756214723;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=4QSSifgUL+pROPLdu64RBhU3ne5/Fuiph5UVy59wA20=;
	b=EnJ0hlmYvYgGm3Vxp7TJ/Z5FHiweZ8rBeXe2U3fiGwOocZXe5qAehsg24stQsBCEnx+SRY
	0Es0X8dlJ41S1RNPjwrMkFwvwH6eCc4/l3BET3BqxjJWoNj+xO5Nb01VygYleWzlflfhB4
	QD4I4d4JvLJlaWUAED9Swl6AgboNpTg=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-274-Vu8lvl7YMEqWbbjlg-BACw-1; Tue, 26 Aug 2025 09:25:21 -0400
X-MC-Unique: Vu8lvl7YMEqWbbjlg-BACw-1
X-Mimecast-MFC-AGG-ID: Vu8lvl7YMEqWbbjlg-BACw_1756214721
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1ad21752so26871945e9.1
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:25:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756214721; x=1756819521;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4QSSifgUL+pROPLdu64RBhU3ne5/Fuiph5UVy59wA20=;
        b=REsbfO5iQVrjCp5+99InUh6OvT9+U+B4HJDmHL0qxLVaq5vuhdM/h+7rIliveZZKvL
         g7WOj1bYpAoEv3m4rnO3Q208NdV26dLpSXN+xQ5KjQ1CPANPoOeNydvUOf6Mqd0oBV6l
         yy6N7ZmfQIc8f1DTrkrvC4L5CEvBqxPdsG+0QAlLOboyhVvJnK1oTaC4TT5eb2N0g2tC
         WsSwcC54erBgC5sfLBmVExPDxl+BqxfEAGtjFGzoiicgWX1s4s+1qj1JlIEUCGHERMkJ
         KAS1iaien6ehCqts0sQN+1CJHg7KPWBnHdAoVxf+99we2aIZ92EbfpgG5jurXvIr2akb
         gW4w==
X-Forwarded-Encrypted: i=1; AJvYcCX8VoI5aAgKDO9OnTjqWykGqP64ExPvNZ3a3xxtSSqhMfyAoMwtrM0nBdfVuAfsL4YQ3CWrV/gVvQ==@kvack.org
X-Gm-Message-State: AOJu0Yz77Ovd1/aPncVTNbxGjQ5aCTSgfTdFqT2tZ67Eqr2LbKSPnc3t
	gGW0DxazmPjbctspniRPlKkIsxykI9PSTOh3GvX0jPYgia8CD5tqCacbTB0lY7OTIuUAcFeYTpj
	us6U2grSt9TT3CLHVAU9DOatPHrMRtClEBHUUQHC1oOY7byZ8OUlw
X-Gm-Gg: ASbGncsGXpb9mTiuzCY7IVNvXHKEu/LjmnbtLQK+8UWUaFIUsndBuqW2prPOCIzc4O4
	1E+iUW8fjvhASVcc1QFPKYqcRJkBLEfGUafXG4yg6CVfRIe6YtZI6TvnS/tROaiy+LoIyDONs93
	T83lRNRcU72tv5jRwu5LDC2e0t2/Ra/1Z5wgT4Ku/b02RHTrkhJ9MD8crsVzdzZre/EDWGMIRAX
	UQ2oloxuiykNN5JfM8tVvZMfrL3fjveOloUKpKTGgZQVXReqFjPON3WDMPLUgEFo72ilF1y7qFY
	Buvtcc1n8xvY7TC9eSX2UXESP0pX/9/3IHqh/3qceOYHD0qkipNC71AJM/tOs/tNEwtvqKJbkw=
	=
X-Received: by 2002:a05:600c:348f:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b68e5699fmr15039285e9.11.1756214720623;
        Tue, 26 Aug 2025 06:25:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHZ48NrVXwqJhZgyCqJ5MFpPBhjkOC2mFGLCH3i0h32WZie7Q73yLQ+HzSD9j5V62fMkPbf6w==
X-Received: by 2002:a05:600c:348f:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b68e5699fmr15038955e9.11.1756214720105;
        Tue, 26 Aug 2025 06:25:20 -0700 (PDT)
Received: from ?IPV6:2a09:80c0:192:0:5dac:bf3d:c41:c3e7? ([2a09:80c0:192:0:5dac:bf3d:c41:c3e7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-45b66cdb5d1sm14126195e9.8.2025.08.26.06.25.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Aug 2025 06:25:18 -0700 (PDT)
Message-ID: <f8940d8d-0cb8-4b10-854d-6097d1a2c39c@redhat.com>
Date: Tue, 26 Aug 2025 15:25:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
To: lirongqing <lirongqing@baidu.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, giorgitchankvetadze1997@gmail.com
Cc: Wenjie Xu <xuwenjie04@baidu.com>
References: <20250826101840.3954-1-lirongqing@baidu.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250826101840.3954-1-lirongqing@baidu.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: tpomIsRPaE45XLHTYQLmIZwgnBwTUwXfSpZi9I-CJk4_1756214721
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: dinc3k71t6x7ttfmj6hyw4cp7rf11z8k
X-Rspam-User: 
X-Rspamd-Queue-Id: B381940014
X-Rspamd-Server: rspam05
X-HE-Tag: 1756214723-348062
X-HE-Meta: U2FsdGVkX18aiFpqM/pCSSKZbda1Y5f7URAYhDBjMKKdbAH6Astr8+/pf8Z9WU6SQ0OcJv+olSSQCSI/ZSLddjI7OghvDFCjsP8bpweGHz+AS4bNe+QNY2t7GfPiEd5c3BxOz1q/V8Lb7gnEh0uezvxvKBEaEqMrhO/Kd2cBOnOGaXIJnCs1Tw68Zlg7UlifEgZtaLMFmLjH4dKkb7yTjxw/3clf25LnB9a/KUx9+5DV0SKg/+5dLSo1GXnB8UoSFf9FdoJciAx+qVZhCXW397zPP2mrq/C8NNXNdsfopdj5CUzShfgkpdkVDttoKAPXvdl2inNBLGvI/L0+DUCLZbZUfQjLXrWvEBLFIx4SF+TZYREuVCeTGOaF+X3pDMFh7jmeZNsfxPVW48j3ucKRSE1/GTxWZaEXHDnjxjiEJgM2kDqLeosokWQ3m70qtHmS+TN4yB/CCbY56tEX0qylvSADDqjUV1dfkhTttl5rRezAMeIqIkIg764+J+xry4uBuzFL/MnY+mgQQl9xPbDwEn0owwGXsFTQTTCwcKtGzDejIJn/QXCrbJS2dUmqj1nM8t5u/qITjVbnGCop+fn13FMRvxq0d1+JwPA6Sh/Ex2UpuXmENvlsRxgu/JDaACv0zZFWxuA4k9o22EO/4Iqufgm2REiXUDr3osmxH0pjWaYMdwDkniizcwhTDajR6pr0RqAsCSWLr6pFl/MeGeT6oFNoIvSgAcstvlbyN5FcF2aDMbmi+MHtxhkDqFYVKOdin8Lx/SikITvCbzfln9nlqPk394/uCBKIHjNXlLVqmR59wTx1B67lhO7um2d204Lteq0gFY3XTQBuwRNDYjAB/JnS1WVClx6oN0fSWqn7sypaah3xktGJgjTt30WeTLtWcXJro9rSkRepUbTYTCGAtjPTf5iYDInAaD45MAZCSgXQ8J8KSnH0ESNeP6r+KAfMHTGYv/FO18BC0lThtiG
 9k5GU/5K
 cQRzebOihZyHyxcyd3QZtkTQNTRgSjPA1LMqIZ7149vaeUoSl8MjGEUcuN1kFdZF4R0nR4uFIXTbDQUCvefYLBvxwnAQ5wdd9Mt3vkKHVOFLhTLb9SsmzuSklH4peEX2v/ij/+lMhOB6xFtnG52hIdRlLuvqSdIGl/QlUve/FIaIJj8JhoS9qbwT8m/FbIZ9MsxYnOAlT7NlOfxMk5db42lSrLPIRW7Nd07ijbMY/BuZigPA6pSxrcFtfHkaiwYUb9hJn7kkGdmMwEIWybksa4muszuJfcW73Q6PqdlGsq9XD1/yeb65J5Wjyh9P0Kfd2yjc1yyWZLgFSyZwFTeEw1uqDcXX+COCB7SMDtHF7fHbmOMeF9j8QAI0HvxjZXcPD6wh9PrTdtw94fEy3vTzvMYPBAZPlAXkm2ovbqgQleFE2Gm7ft0/T51l7YD1TAD7mHnbphe7OyNuF4ZEcokjKeFLrihPOGnf443EumU0i3oPSp+Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 26.08.25 12:18, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> When the total reserved hugepages account for 95% or more of system RAM
> (common in cloud computing on physical servers), allocating them all in one
> go can lead to OOM or fail to allocate huge page during early boot.
> 
> The commit 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages") can
> worsen peak memory pressure under these conditions by deferring page frees,
> exacerbating allocation failures. To prevent this, split the allocation
> into two equal batches whenever
> 	huge_reserved_pages >= totalram_pages() * 90 / 100.
> 
> This change does not alter the number of padata worker threads per batch;
> it merely introduces a second round of padata_do_multithreaded(). The added
> overhead of restarting the worker threads is minimal.
> 
> The result on a 256G memory machine as below:
> Before:
> [    4.350400] HugeTLB: allocation took 706ms with hugepage_allocation_threads=32
> [    4.351577] HugeTLB: allocating 128512 of page size 2.00 MiB failed.  Only allocated 128074 hugepages.
> [    4.355608] HugeTLB: registered 2.00 MiB page size, pre-allocated 128074 pages
> After:
> [    3.561088] HugeTLB: two-phase hugepage allocation is used
> [    4.280300] HugeTLB: allocation took 712ms with hugepage_allocation_threads=32
> [    4.281054] HugeTLB: registered 2.00 MiB page size, pre-allocated 128512 pages
> 
> Fixes: 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages")
> 
> Co-developed-by: Wenjie Xu <xuwenjie04@baidu.com>
> Signed-off-by: Wenjie Xu <xuwenjie04@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
> Diff with v1: add log if two-phase hugepage allocation is triggered
>                add the knod to control split ratio
> 
>   Documentation/admin-guide/mm/hugetlbpage.rst | 12 +++++++++
>   mm/hugetlb.c                                 | 39 ++++++++++++++++++++++++++--
>   2 files changed, 49 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/admin-guide/mm/hugetlbpage.rst b/Documentation/admin-guide/mm/hugetlbpage.rst
> index 67a9419..5cfb6e3 100644
> --- a/Documentation/admin-guide/mm/hugetlbpage.rst
> +++ b/Documentation/admin-guide/mm/hugetlbpage.rst
> @@ -156,6 +156,18 @@ hugepage_alloc_threads
>   		hugepage_alloc_threads=8
>   
>   	Note that this parameter only applies to non-gigantic huge pages.
> +
> +hugepage_split_ratio
> +    Controls the threshold for two-phase hugepage allocation.
> +    When the total number of reserved hugepages (huge_reserved_pages) exceeds
> +    (totalram_pages * hugepage_split_ratio / 100), the hugepage allocation process
> +    during boot is split into two batches.
> +
> +    Default value is 90, meaning the two-phase allocation is triggered when
> +    reserved hugepages exceed 90% of total system RAM.
> +    The value can be adjusted via the kernel command line parameter
> +    "hugepage_split_ratio=". Valid range is 1 to 99.

Can we just do something reasonable here and not introduce toggles where 
nobody knows how to really set a reasonable value?

This really sounds like something we should not be exporting to users.

Also, can't we fail lightly during the first attempt and dynamically 
decide if we should do a second pase?

-- 
Cheers

David / dhildenb


