Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18821CA0FF2
	for <linux-mm@archiver.kernel.org>; Wed,  3 Sep 2025 07:49:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2288E0003; Wed,  3 Sep 2025 03:49:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 672768E0001; Wed,  3 Sep 2025 03:49:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 539EB8E0003; Wed,  3 Sep 2025 03:49:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BBEC8E0001
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 03:49:14 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CF6B885EF0
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:49:13 +0000 (UTC)
X-FDA: 83847163386.23.E344EF9
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8B24B80006
	for <linux-mm@kvack.org>; Wed,  3 Sep 2025 07:49:11 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DP+Jdxs9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756885751; a=rsa-sha256;
	cv=none;
	b=Tgy08n1rHVPbFZe9b5R++VC1Ms22dDqcbZcvlDMKv78Am7x1mNELZ0BeO+ck1QWG60PLKG
	Ns2atioHzKSZQFjSHHGzElUvc4MmbJxYsqZJAVvBwtrq1DWPgfkIfhR4n7T4mWymlIzq+o
	mLsKy0ABjiFk5ydygVhgW+wfXUWMmWU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=DP+Jdxs9;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf02.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756885751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JtjZS3oI1Ds2ec1UKAPpV4aTFHH5FBSt1NM1wfVNoVE=;
	b=d5RdgLvaeFxeJndA4W6lzaQHKXlZnF3zh9tII06e2wPsXtCsuEgqH3GfOiAB3s0Iw65XGQ
	QiF6Mcx22wlODTl+Q3VeV5piV+uSOW31S7fE8RitdHXt2ftTwuQKDqlTlEDSSGBazx4ZWZ
	vXrvglwzf00T+hZU2eCf89+33IoZJak=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756885751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=JtjZS3oI1Ds2ec1UKAPpV4aTFHH5FBSt1NM1wfVNoVE=;
	b=DP+Jdxs96PQDK3Cg+NMfUCwTIA7a7WVbpwZBYQL7v6eMhg0IBA64DAGqo/1bVNc5lc4nI6
	R2FeGbQo6dI/ZMtNNxxIxR+FzEJnqCTkm5kYpZATCQur/ZfG1hplgMu8sdxAG82a+8489e
	Ej0Tk0EIv60wBN9MJWq5Of8kz3L/RA0=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-313-YSFNhWH9P_uVeqEDOXlDkg-1; Wed, 03 Sep 2025 03:49:09 -0400
X-MC-Unique: YSFNhWH9P_uVeqEDOXlDkg-1
X-Mimecast-MFC-AGG-ID: YSFNhWH9P_uVeqEDOXlDkg_1756885748
Received: by mail-wr1-f71.google.com with SMTP id ffacd0b85a97d-3cf48ec9fc1so3145007f8f.0
        for <linux-mm@kvack.org>; Wed, 03 Sep 2025 00:49:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756885748; x=1757490548;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JtjZS3oI1Ds2ec1UKAPpV4aTFHH5FBSt1NM1wfVNoVE=;
        b=v6ruVoJED9+5rZ03/Pz9odyiK//RAIVBtzXnCm8Oo/VcWVc+7zQh5ra6FpWKReIVE0
         XpcffrJTJPL2CjnZxGSONOgrbmGqbLf+jgQxgg/i6qnfOauDlRbTX1CBMSslencX4+Qi
         L85DjccOBPNrsFWEAqFqXQNceAXsusMjLsxrqqKqU2FvneGfGhVrSF2Ulc7IP14X3CGp
         tVMjzkuzAM+Ygz/hjDibahYyOH1JuuHNaokwtz2nBzjeue76mTyqo5oH8BvPThPMsKUE
         /9wI1fsVIoo9gPGkGWTHI9sEm6w9bBtx87Z0ybTnunX3if2Fpa6uIGffW8qahHAa0qVR
         79Sw==
X-Forwarded-Encrypted: i=1; AJvYcCVDGrkSo+nOuvDeOqQqNLaNRpboTt4oDO6riLAITTueM0Sxi2Ya1G+v5ZtF5fCGwwuKREhbn+LQzw==@kvack.org
X-Gm-Message-State: AOJu0YyLR8gGpmh6AVML1a3PwiJ9Pfe1zIqieZUiTFm3vLmYok8kWgU/
	YZ7vDieJf5+fDq+hfuiRuwkemBPjBP/Hjb0Xukuxk2/s0CR2irMERZfiT0cdUxvMmwdh2d1GjT0
	kwqc1IzS7ZIEvIHum+ehh6qyfBKpxpPPzT/t6rKKVlP3lmUqTpLemrf/tMkEq
X-Gm-Gg: ASbGnctjvJWNWVQ3iIEjNhFpwJY1ZA0Gnvu4scPrcym9N+Ed/8uAZrq58Cx2c+h6FUp
	j40uYqU097nH5+s2WA7yg/ocYF6+RZDmnWRVlYMxE/XPEKDgqK7SP7wJz7LrJt/Z1bSdl8SA6Ci
	iO86TQucOWUdaDDGncqBXx6vhjTiT1/LYQ3E9Udpdabruil6MSVfoAW8eW2HjIOih/XzNVjzxC0
	FeuIL+gSsR4rFKff1OAKwMlfy2yHevYz6Kfykxr0VvX1REYRwHAE0rv8333h/kix5f56uHFJnzV
	GKqnbs/eGAqzYC5S1eHnLILgH6d+zIUdLET+INwf15ST63JrXObqO8+wIwY82C5VgUbXCMd8B4y
	r1h/m6qaOIcZ9EFSjYSCeAXK14/7/CcZUvQxhidiYer/T8h1+g1ocrnbMjsl4Nwk4hbk=
X-Received: by 2002:a05:6000:4282:b0:3dd:e4d3:d172 with SMTP id ffacd0b85a97d-3dde4d3d286mr1041592f8f.7.1756885748232;
        Wed, 03 Sep 2025 00:49:08 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGUOLgBAUDmMz80z4OZdF860ZqnxqbWORYZdE1I9b8GTgj1H3cajVGrCdKRXxtWcIn72gKz9A==
X-Received: by 2002:a05:6000:4282:b0:3dd:e4d3:d172 with SMTP id ffacd0b85a97d-3dde4d3d286mr1041567f8f.7.1756885747761;
        Wed, 03 Sep 2025 00:49:07 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f09:9c00:8173:2a94:640d:dd31? (p200300d82f099c0081732a94640ddd31.dip0.t-ipconnect.de. [2003:d8:2f09:9c00:8173:2a94:640d:dd31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf34491a65sm22115160f8f.56.2025.09.03.00.49.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Sep 2025 00:49:07 -0700 (PDT)
Message-ID: <ea48bc1f-7ee7-48b4-b389-c3622fc4d3d1@redhat.com>
Date: Wed, 3 Sep 2025 09:49:06 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: tag kernel stack pages
To: "Vishal Moola (Oracle)" <vishal.moola@gmail.com>, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
References: <20250820202029.1909925-1-vishal.moola@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250820202029.1909925-1-vishal.moola@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: p4rm2nhtdNUCpnGXCP2gWrDQVDm-XiJkEeq6ghom8ks_1756885748
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8B24B80006
X-Stat-Signature: wm11uquyx1fw15zuwj636b7ehs5m3fpm
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1756885751-451913
X-HE-Meta: U2FsdGVkX1/tnwQZ/8KXywxXlj6rDh3v70qq/mQhRmtv3hFWh4epYIrgo80amXKCz9iLXJXUNREfGIeHBoYhBIlYmVA+SyWbmRorLL1vpPHe20LfW3tC1nTSK605CjMzzKDmpgv9Q1sgUB6ZCsRkylhDRtLMtXMvfVqqUmhSkyI0PifpeHef7WMMuNqvKIzF2hOxGe9jhs/CCfzeB5gF8oHFV2jHNtr2hiL/GxtlSLmS+GKmKL1eArUaMAL1HjF7FJ3/oC3s8tez8BdAqz89jYdi/frkxACW1BglxpER4iArJm9Y1VaKNmBleaUmL0Ok0OXgPT5/gZSNz1rWeCBKS83RvSmR+wdOayD+viNWcR97mWFf/vFT0anL6q4q0H4kD9PB80hppZoc/Oxk39oKQw8o3rdAysuluNAjXlz897naoffrZnb+jxFmVEKnBLXUByjYt+kmsRK+cafnFR4x8KF+ZzK6/3bhNGTTVZFIvj+oo73c74iS4vV+r0QIbu8TEWNh+c9jhK6BShToEkuwsa4Ztthi02nBR1TJ1r96H2KmuWJR6rPPgX1Cv8/2gnjEy0s9Nr2sheAqIWq8WzGt7JspNyv2q/gQrY729VPFQwwxtYf4QRPZ5Ha698OOaOZMul8uCCv19K23D4ovdLSs6lYttRxWm7tpi+ccsJEMmM5b8pyw3cEOiEsdrsOXwf7AT7qYg55sNoZPClaKUEvfe7IquVvgAOej5qAj0NxV0gqE7tLvDZti6wUk0eGGVEJYo3k+95k9qlL+p0Nb/k29Crv7fMizLRX+TDYvLW70GixipxBCc1JTcvSoc0wTp+gBJMoK6HeUJUeTuGZQ8VmsYm44YRr0Uowvja1sJKUkYWCd2DKcH5L3uRaiDr3hgT5mOxGQvHAxIbvKbyRKdekBh82ghJMNEjdviQ2WfRtaYmSWXsazCr47YfwLz90P/vJmzQBQCu8Nph1MJQxMfnm
 fGfmaoEn
 h4eSXB2r7iIwfJg2h6KRzwFfXjHiNhGyRB3b7f03qW8ZiERa80wi6i+3IGbuukQy5Iean0+2yuhVRECK4BYlirwySZBURywaH8/ffqnZzAF/P3SDk6XEVmTLXTwznK0Tcces3STQH6+JG9lB+rjAMpyF6kGgcy4uNezveKzxTA5P0TWx2Y0uZqtvYeBZF4GrrDgUi9a4DDZzZPvmUsfhzbbYVQycV1sAMnAFwfTKWnv3qERvh/qPxKzTAXow8M/m7z8xogX/e3IOIFCFSEscHVgS3MRiZp9igSSabH5qlyvuBP0zWclNTMb8Oi2XfjpU9LJImRizD1ivrz7oQAmPKE6C5dbHBfwRRGPeWF5n6Wy5kszSBms/oq7Ga1246+7Wn1hxEKOrxvI1+NRop9Y4dy/4jncA+Zlh5PmSfyF4h1z+fIwI+iAu0EShzPWMeo84NM3r83wQ5O8cfKfUq08tuAxycbOiXhEmFeP9CbYzRoSlrWkLJmaCCbZ9DLGLTqVaVyQV54NzalD9uilGkOqID3fMyDg7FKywVg3zwK5TMgxt9koSOYs1X1XtrQMIaj+BrCqE7f78yb6JrBmhdD3xKMxCgO0pPTmWEnmrnqhBNmu4W2QN8z0jq0o99u7roSUgzpkqD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

[resending my original mail because it might have landed in the spam folder]

On 20.08.25 22:20, Vishal Moola (Oracle) wrote:
> Currently, we have no way to distinguish a kernel stack page from an
> unidentified page. Being able to track this information can be
> beneficial for optimizing kernel memory usage (i.e. analyzing
> fragmentation, location etc.). Knowing a page is being used for a kernel
> stack gives us more insight about pages that are certainly immovable and
> important to kernel functionality.

It's a very niche use case. Anything that's not clearly a folio or a
special movable_ops page is certainly immovable. So we can identify
pretty reliable what's movable and what's not.

Happy to learn how you would want to use that knowledge to reduce
fragmentation. 🙂

So this reads a bit hand-wavy.

> 
> Add a new pagetype, and tag pages alongside the kernel stack accounting.
> Also, ensure the type is dumped to /proc/kpageflags and the page-types
> tool can find it.
> 
> Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
> ---
>   fs/proc/page.c                         |  3 ++-
>   include/linux/page-flags.h             |  5 +++++
>   include/uapi/linux/kernel-page-flags.h |  1 +
>   kernel/fork.c                          | 19 +++++++++++++++++--
>   tools/mm/page-types.c                  |  1 +
>   5 files changed, 26 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/page.c b/fs/proc/page.c
> index 771e0b6bc630..46be207c5a02 100644
> --- a/fs/proc/page.c
> +++ b/fs/proc/page.c
> @@ -201,7 +201,8 @@ u64 stable_page_flags(const struct page *page)
>   
>   	if (ps.flags & PAGE_SNAPSHOT_PG_BUDDY)
>   		u |= 1 << KPF_BUDDY;
> -
> +	if (folio_test_stack(folio))
> +		u |= 1 << KPF_KSTACK;
>   	if (folio_test_offline(folio))
>   		u |= 1 << KPF_OFFLINE;
>   	if (folio_test_pgtable(folio))
> diff --git a/include/linux/page-flags.h b/include/linux/page-flags.h
> index d53a86e68c89..5ee6ffbdbf83 100644
> --- a/include/linux/page-flags.h
> +++ b/include/linux/page-flags.h
> @@ -933,6 +933,7 @@ enum pagetype {
>   	PGTY_zsmalloc		= 0xf6,
>   	PGTY_unaccepted		= 0xf7,
>   	PGTY_large_kmalloc	= 0xf8,
> +	PGTY_kstack		= 0xf9,
>   
>   	PGTY_mapcount_underflow = 0xff
>   };
> @@ -995,6 +996,10 @@ static __always_inline void __ClearPage##uname(struct page *page)	\
>   	page->page_type = UINT_MAX;					\
>   }
>   
> +/* PageStack() indicates that a page is used by kernel stacks.
> + */
> +PAGE_TYPE_OPS(Stack, kstack, stack)
> +
>   /*
>    * PageBuddy() indicates that the page is free and in the buddy system
>    * (see mm/page_alloc.c).
> diff --git a/include/uapi/linux/kernel-page-flags.h b/include/uapi/linux/kernel-page-flags.h
> index ff8032227876..56175b497ace 100644
> --- a/include/uapi/linux/kernel-page-flags.h
> +++ b/include/uapi/linux/kernel-page-flags.h
> @@ -36,5 +36,6 @@
>   #define KPF_ZERO_PAGE		24
>   #define KPF_IDLE		25
>   #define KPF_PGTABLE		26
> +#define KPF_KSTACK		27
>   
>   #endif /* _UAPILINUX_KERNEL_PAGE_FLAGS_H */
> diff --git a/kernel/fork.c b/kernel/fork.c
> index 5115be549234..c8a6e1495acf 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -440,15 +440,22 @@ static void account_kernel_stack(struct task_struct *tsk, int account)
>   		struct vm_struct *vm_area = task_stack_vm_area(tsk);
>   		int i;
>   
> -		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
> +		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
>   			mod_lruvec_page_state(vm_area->pages[i], NR_KERNEL_STACK_KB,
>   					      account * (PAGE_SIZE / 1024));
> +			__SetPageStack(vm_area->pages[i]);
> +		}
>   	} else {
>   		void *stack = task_stack_page(tsk);
> +		struct page *page = virt_to_head_page(stack);
> +		int i;
>   
>   		/* All stack pages are in the same node. */
>   		mod_lruvec_kmem_state(stack, NR_KERNEL_STACK_KB,
>   				      account * (THREAD_SIZE / 1024));
> +
> +		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
> +			__SetPageStack(page);
>   	}
>   }
>   
> @@ -461,8 +468,16 @@ void exit_task_stack_account(struct task_struct *tsk)
>   		int i;
>   
>   		vm_area = task_stack_vm_area(tsk);
> -		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++)
> +		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++) {
>   			memcg_kmem_uncharge_page(vm_area->pages[i], 0);
> +			__ClearPageStack(vm_area->pages[i]);
> +		}
> +	} else {
> +		struct page *page = virt_to_head_page(task_stack_page(tsk));
> +		int i;
> +
> +		for (i = 0; i < THREAD_SIZE / PAGE_SIZE; i++, page++)
> +			__ClearPageStack(page);
>   	}

Note that exit_task_stack_account() stack calls
account_kernel_stack(tsk, -1), where you would do a non-sensical
__SetPageStack() first.

... so this would better be done in account_kernel_stack() based on the
"int account" flag.

But I wonder, if this should actually go to the actual place where we
alloc/free.

Now that it's no longer required to clear page types when freeing,
alloc_thread_stack_node() might be a better place to set it, and to
leave it set until freed.

I'll leave Willy whether we actually want this type, cannot spot it
under [1], but if we have sufficient types available, why not.

BUT

staring at [1], we allocate from vmalloc, so I would assume that these
will be vmalloc-typed pages in the future and we cannot change the type
later.


[1] https://kernelnewbies.org/MatthewWilcox/Memdescs


-- 
Cheers

David / dhildenb


