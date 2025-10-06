Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57EE4CCA471
	for <linux-mm@archiver.kernel.org>; Mon,  6 Oct 2025 07:37:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 990EB8E0013; Mon,  6 Oct 2025 03:37:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91A368E0002; Mon,  6 Oct 2025 03:37:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76D4C8E0013; Mon,  6 Oct 2025 03:37:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5E9378E0002
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 03:37:44 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 295161A04AC
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:37:44 +0000 (UTC)
X-FDA: 83966884848.30.095B180
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf24.hostedemail.com (Postfix) with ESMTP id 09C9C180003
	for <linux-mm@kvack.org>; Mon,  6 Oct 2025 07:37:41 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JWyUkupH;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759736262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7c4mRTEqZdZGm9RTIQw/5XdulTJUNtDD37vH797NP3U=;
	b=SlF86wVMxGgQ1rjzublk97AuxsFgsHGhlvbpiWgW508Kf1EUdmAIiHaOVUdEjx4EiZufEz
	0B8xzZZO0tzBeDsxXfDADqtfPNnpU/6BqWchP/hR/KgWbADLB1n8wa8Pu9KMf0F1hz52NU
	rfYXiq2IBnGLPSa5XJVcZMh/glNg9RQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JWyUkupH;
	spf=pass (imf24.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759736262; a=rsa-sha256;
	cv=none;
	b=YDiRTP8FFOwF65JifAT2m9VR0BaxwlImj6DAEyG1AaxQ55/ie0XVPase3EbNwFWYmgr+bq
	M8pFrjT5bxrA3cr8s7yVI+bkdZlWgMPu5XOtvaOJTEvb5fIqEytA6hyuKPI7/oYUumq1/R
	75be80/O2pbVh1OXvFVI5SE7c6ldcYE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1759736261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=7c4mRTEqZdZGm9RTIQw/5XdulTJUNtDD37vH797NP3U=;
	b=JWyUkupHDf2Jcso+uTfKjGZUG9z5ugxLpmxDNSMU/PM8Hn10Z2WKMNYO0/Jxbq6DiSSZWR
	fUb9meCCYgPuv7DF689ufc23gOofXp7SFnAIcpSbapWG2Fam7v2v9n05cqXBTSoxteYES7
	PCkGfwNh/dZpfHdhwPth7Bj7zeTqdrw=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-518-8sZsb2ILN-Od-BtRWoDPbw-1; Mon, 06 Oct 2025 03:37:40 -0400
X-MC-Unique: 8sZsb2ILN-Od-BtRWoDPbw-1
X-Mimecast-MFC-AGG-ID: 8sZsb2ILN-Od-BtRWoDPbw_1759736259
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-46e38957979so16508385e9.3
        for <linux-mm@kvack.org>; Mon, 06 Oct 2025 00:37:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759736259; x=1760341059;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7c4mRTEqZdZGm9RTIQw/5XdulTJUNtDD37vH797NP3U=;
        b=pRopV1BGyK2qzo5I/JNzvBeCUVZnpGGOTP4+byyLWxMOPrgYAuOSuwu25fPiUROo6K
         iBqWCRXPxUUYV+tlZIgWtxl5y9nqgtnMRuT04NL/U+98xom+Zxq5fuB2LE+jjxnJnKQc
         OTswi8nvjP+Sh13v3yj92QYQpXMExE2SidPt/hP6D/43KN6zFvnDt1vOEBYjZ+jzz7zz
         HsplJtmEfPnZi5+TPdAbqFFdyuCWvdZs84+iy2mUTSgXILbsVTykKgyH8f1PvDLR6Ri9
         zeYiRsPs1i9LGbWS01l0XcfDr08ZwEEE3hfKldxPhIY9TZFnWo4q2boyecMgKoUikpOm
         pMbw==
X-Gm-Message-State: AOJu0Yx7iMkyp2DjEV5H4Tdzyw0eaawABonykYsprqhF7LhdNohp9xd2
	rZLLOgIydxruwanCxzxNcxcBFJ/70t+6IGKEt0/IirkupRhloGKADThOX0d1OvI8BMhDF37jlth
	2/aI0NO1jruLHTpm+9ZiG+ql9qBmQSo8xthvN6fRKXQaYizFmN705
X-Gm-Gg: ASbGnctslmzy+KQxeRSZ816AMgkvTM7vlZj+MjaHEqgL1An8fIasFxLnrumCsv9uWbo
	/m+gKAneXanFhj+NmmNmbtVOOLXoyGACBAKpSUnbY2dMKTmf01azKMchEm4Q4yMTEObKHHpTcYR
	Gu/eLU43Zv7DguvtZWS7Q3/TY+gB3knOAIihYd1yLG39hf5wF6cmUNDMXawXY0LCRSe3uqDfj+C
	iE+2fGMne4Ifi8uDCJdAdVbBmpQ2jY+Zshjtc3rGSYjU9Iv9bPjWiYs53TNMssM7j5NWqdbCT6d
	QNS6L/5HI6QicQrAtqQUuhLyoZ9SotODu+RqQHgA0OpYLZykZC0nSGz09YMMi+vGrEABrc/x8lC
	aFbTWosef
X-Received: by 2002:a05:600c:8b32:b0:46e:42cb:d93f with SMTP id 5b1f17b1804b1-46e71109fdamr78874075e9.15.1759736258919;
        Mon, 06 Oct 2025 00:37:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFRMSS2VJCwM83W0PXSsMxtlWivQYq+uynZFL3Dbx2bgu3Fi6f7hITjd2kxM2lB1ZJRAGCqvA==
X-Received: by 2002:a05:600c:8b32:b0:46e:42cb:d93f with SMTP id 5b1f17b1804b1-46e71109fdamr78873765e9.15.1759736258481;
        Mon, 06 Oct 2025 00:37:38 -0700 (PDT)
Received: from [192.168.3.141] (tmo-083-110.customers.d1-online.com. [80.187.83.110])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4255d8f4ab0sm19527928f8f.52.2025.10.06.00.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Oct 2025 00:37:37 -0700 (PDT)
Message-ID: <6db79bb0-382e-4c3c-89e0-4c7822d4dfca@redhat.com>
Date: Mon, 6 Oct 2025 09:37:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] hugetlbfs: skip PMD unsharing when shareable lock
 unavailable
To: Deepanshu Kartikey <kartikey406@gmail.com>, muchun.song@linux.dev,
 osalvador@suse.de, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, broonie@kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
References: <20251003174553.3078839-1-kartikey406@gmail.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251003174553.3078839-1-kartikey406@gmail.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: KIzkgoimHMZgVyueAreBJWpT6zNaJ5pIdCtUNclnXcM_1759736259
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 09C9C180003
X-Stat-Signature: wrxmpzcc8y8fo7bukkmb8urzgofomq8p
X-HE-Tag: 1759736261-551701
X-HE-Meta: U2FsdGVkX1/c41kvJ6OWhHmlJrsGHLyy5SdJl7bz0bmb1+Edqt+itm6hr+FOmJU9kz9fB17zWkxHdiN9vVTI11Omm5seJGzcyjqtgYThExWKHopR48TZbfBaIns1nCAKN2GWK1pJekTywdUbB1XPmLQDL8dZ0r02oLDMVOt3Y2EdFEhAkpBeD9th5jrZVndB06TfMWRGvMyF4qqPdSqz9ziwxoErCdv3Rkhv11lsMnPgMwPepHEn863TKKtlncFg5+U0UIVF91YxUX5Q8pbxVToW1v0gO3WmFOr9yvNHK7YDsoD0RNaCe8F0gm5xzR3MZQMBoXHhZc3/K/btI3TksCO+4ZLMeNNYvFy9VAM2l+5kMIaCUVOivQ7DSCEHL1JML+Mz8VWo6gG0jfnEh//nqXO95NGofxXM7bgHDrfj0lySF3/MAWdjHnWcin5tLcjXMuhtK+zUjhDY4SzMFLi/rBrZvBHSZ/yrAz99oUTN7aUQpVZ25KA4C2+3yV9cMZ/O7C/TeKs06qDaw/vw7jP5yuEpHtR11eh9Dimf/WIxBRyy54oKI0F5gF7XybT2YengnQczgtHSG5fveA5DCXaf27coMJytO4k7hVdU00sfzGgh4GqjYX0ZHTH0kmzZ2PA/AUHf8LHBK6VxMLJ3hHNAJq/X5rtDrdyEI/Y7/KEkrUlfyTCHL/0FCBF1Eu1d17h3RR+smn6WUWQpIJZwRoNNtedVpmH6+Mi3enoKeuOZklXwY75ceclyX4Ah3wGcNOiD+/tt+1gzlEJmjyyMKGVxpvXOCoRe4hzdWsG2EEakwCdzjNVKoHu2za3ah0dfMM5vImBTFSn9EoQM6dIu9W8VAs7Lpt+xpTjSevbsv5rHHgQRnRhGlA/x7B+0ja4w2d9EwG5HxfrDJaRkmzoCePu9tcJWh0vLblPxrFaVf7/TPyivGQtdGReb9Y4dhY/D24fN1PDFZxYIr45Xd4SZuBE
 eGjLvZlA
 6FMBlm5XgaQ02JvVkhmejdxUvsoYd/3PbvN+hwGeevekSvwkSkHjE630kjkNugTA8Kx9DGL1drjkto1kArX+0FNTBePdMF1l0SNrW4ciSO6RezJZ018qIcF+WO4F5GgceE6nHmQ5nBQrc/stgfPZHqfk9f8FmZAsmgA2xW5YsusaReZiO1rDgkbsUrlmnOVeojFHkuUEN4JD8EM9lQvOCbmgkwd/Rdw+VRu7YkpjyDVc7H6Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 03.10.25 19:45, Deepanshu Kartikey wrote:
> When hugetlb_vmdelete_list() cannot acquire the shareable lock for a VMA,
> the previous fix (dd83609b8898) skipped the entire VMA to avoid lock

The proper way to mention a commit here

"... fix in commit dd83609b8898 ("hugetlbfs: skip VMAs without shareable 
locks in hugetlb_vmdelete_list") skipped ..."

> assertions in huge_pmd_unshare(). However, this prevented pages from being
> unmapped and freed, causing a regression in fallocate(PUNCH_HOLE) operations
> where pages were not freed immediately, as reported by Mark Brown.
> 
> The issue occurs because:
> 1. hugetlb_vmdelete_list() calls hugetlb_vma_trylock_write()
> 2. For shareable VMAs, this attempts to acquire the shareable lock
> 3. If successful, huge_pmd_unshare() expects the lock to be held
> 4. huge_pmd_unshare() asserts the lock via hugetlb_vma_assert_locked()
> 
> The v2 fix avoided calling code that requires locks, but this prevented
> page unmapping entirely, breaking the expected behavior where pages are
> freed during punch hole operations.
> 
> This v3 fix takes a different approach: instead of skipping the entire VMA,
> we skip only the PMD unsharing operation when we don't have the required
> lock, while still proceeding with page unmapping. This is safe because:

It's confusing to talk about fix versions. If you want to reference 
previous discussions, rather link to them.

> 
> - PMD unsharing is an optimization to reduce shared page table overhead
> - Page unmapping can proceed safely with just the VMA write lock
> - Pages get freed immediately as expected by PUNCH_HOLE operations
> - The PMD metadata will be cleaned up when the VMA is destroyed
> 
> We introduce a new ZAP_FLAG_NO_UNSHARE flag that communicates to
> __unmap_hugepage_range() that it should skip huge_pmd_unshare() while
> still clearing page table entries and freeing pages.
> 
> Reported-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Reported-by: Mark Brown <broonie@kernel.org>
> Fixes: dd83609b8898 ("hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list")
> Tested-by: syzbot+f26d7c75c26ec19790e7@syzkaller.appspotmail.com
> Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
> 
> ---
> Changes in v3:
> - Instead of skipping entire VMAs, skip only PMD unsharing operation
> - Add ZAP_FLAG_NO_UNSHARE flag to communicate lock status
> - Ensure pages are still unmapped and freed immediately
> - Fixes regression in fallocate PUNCH_HOLE reported by Mark Brown
> 
> Changes in v2:
> - Check for shareable lock before trylock to avoid lock leaks
> - Add comment explaining why non-shareable VMAs are skipped
> ---
>   fs/hugetlbfs/inode.c | 22 ++++++++++++----------
>   include/linux/mm.h   |  2 ++
>   mm/hugetlb.c         |  3 ++-
>   3 files changed, 16 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
> index 9c94ed8c3ab0..519497bc1045 100644
> --- a/fs/hugetlbfs/inode.c
> +++ b/fs/hugetlbfs/inode.c
> @@ -474,29 +474,31 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
>   	vma_interval_tree_foreach(vma, root, start, end ? end - 1 : ULONG_MAX) {
>   		unsigned long v_start;
>   		unsigned long v_end;
> +		bool have_shareable_lock;
> +		zap_flags_t local_flags = zap_flags;
>   
>   		if (!hugetlb_vma_trylock_write(vma))
>   			continue;
> -
> +
> +		have_shareable_lock = __vma_shareable_lock(vma);
> +
>   		/*
> -		 * Skip VMAs without shareable locks. Per the design in commit
> -		 * 40549ba8f8e0, these will be handled by remove_inode_hugepages()
> -		 * called after this function with proper locking.
> +		 * If we can't get the shareable lock, set ZAP_FLAG_NO_UNSHARE

What do you mean with "If we can't get the shareable lock"? 
__vma_shareable_lock() doesn't tell us whether we grabbed the lock, but 
whether we have to grab the lock?

I see now R-b/Ack from hugetlb maintainers and this seems to be getting 
rather complicated now and I cannot really easily judge what's right or 
wrong now.

@Muchun, Oscar, can you take a look?


> +		 * to skip PMD unsharing. We still proceed with unmapping to
> +		 * ensure pages are properly freed, which is critical for punch
> +		 * hole operations that expect immediate page freeing.
>   		 */
> -		if (!__vma_shareable_lock(vma))
> -			goto skip;
> -
> +		if (!have_shareable_lock)
> +			local_flags |= ZAP_FLAG_NO_UNSHARE;
>   		v_start = vma_offset_start(vma, start);
>   		v_end = vma_offset_end(vma, end);
>   
> -		unmap_hugepage_range(vma, v_start, v_end, NULL, zap_flags);
> -
> +		unmap_hugepage_range(vma, v_start, v_end, NULL, local_flags);
>   		/*
>   		 * Note that vma lock only exists for shared/non-private
>   		 * vmas.  Therefore, lock is not held when calling
>   		 * unmap_hugepage_range for private vmas.
>   		 */
> -skip:
>   		hugetlb_vma_unlock_write(vma);
>   	}
>   }
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 06978b4dbeb8..9126ab44320d 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2395,6 +2395,8 @@ struct zap_details {
>   #define  ZAP_FLAG_DROP_MARKER        ((__force zap_flags_t) BIT(0))
>   /* Set in unmap_vmas() to indicate a final unmap call.  Only used by hugetlb */
>   #define  ZAP_FLAG_UNMAP              ((__force zap_flags_t) BIT(1))
> +/* Skip PMD unsharing when unmapping hugetlb ranges without shareable lock */
> +#define  ZAP_FLAG_NO_UNSHARE         ((__force zap_flags_t) BIT(2))

That's nasty: this is hugetlb-specific stuff in a generic mm.h header 
using generic mm flags.

I'm sure we can find a way communicate that in a different way within 
hugetlb code and leave the generic ZAP_* flags alone?

-- 
Cheers

David / dhildenb


