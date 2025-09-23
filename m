Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72207CAC5A7
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 09:01:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C2658E000F; Tue, 23 Sep 2025 05:01:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99A308E0001; Tue, 23 Sep 2025 05:01:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 888EC8E000F; Tue, 23 Sep 2025 05:01:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF018E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 05:01:07 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2B69B1A040B
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:01:07 +0000 (UTC)
X-FDA: 83919920574.13.920645E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD5BA8000D
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 09:01:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L2pmNK5D;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758618064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IkO4rImhCx3UOUFiDFTs5OyK4dbhGcDUSPwdGTIbKUY=;
	b=HTZK08LONQgolK7HErXfIcC0L/UYpgwd8ntHvipvuOirB6xI1m9I54ez2ENfi/D6kDOiFB
	VSqma4BUZ9rtSMszGVNc23t3LRTSHR1Wyjn644zVPCx2BMqEioN0FViRajfVa1yI0Zqy0d
	poVLoHuBukIX+O3P2JkrPVR7InLsLqY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758618064; a=rsa-sha256;
	cv=none;
	b=AxJN0pk+CT4hI7YSIY5RFo6NGzTO4Rd7Vio3bQV3hAD5yEsITpoIa3H8L6IxlrmRbB5ENL
	B2gpW2begeehG7H7fkSEQriL9OOhuUlBGe8SP5N66KT5yz644Qu90d1POgdwX9vN4t+aGJ
	aKHJTzF5lrutznxCkJKs88uaaMuAuH4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L2pmNK5D;
	spf=pass (imf30.hostedemail.com: domain of david@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758618064;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=IkO4rImhCx3UOUFiDFTs5OyK4dbhGcDUSPwdGTIbKUY=;
	b=L2pmNK5DIYlJC4PBWRfsPAJNIX6wvff2lqAfH+LBQ1VdiCsWaV2n5Z9nPndTri/ayYFY4L
	AUd0ZdnWpIxYReZXbcm/45sZpOKVDdcrhkWuUB853UyDLE5wS0VVevhBVAV9Y5Lc1l0rPD
	fxvCq8DP80g9+YtiIkt2WnpizkuoRXc=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-637-kqDZZ4otP-yvmf43nqVIPw-1; Tue, 23 Sep 2025 05:01:01 -0400
X-MC-Unique: kqDZZ4otP-yvmf43nqVIPw-1
X-Mimecast-MFC-AGG-ID: kqDZZ4otP-yvmf43nqVIPw_1758618061
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-3ece0fd841cso3611455f8f.0
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 02:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758618061; x=1759222861;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IkO4rImhCx3UOUFiDFTs5OyK4dbhGcDUSPwdGTIbKUY=;
        b=wKic8lemyZEpQ9BWMMskmt1sieUytn7eVWoCwfW9Zrow2qDwir2M8zGZn4AV2sfe6X
         f3QsBP7U8ruSs9QxzO88qMhqZGyCC+IaQoDqlwjKN41vjT7QM7mBwlZQvj1rZboT7lzT
         h0Hf0R0HZBescYgEgq9kBmHWJcTC+kAXze6sp2OqBBd8tAAHRjkUmQxnfPnpIGzJpkV4
         OwOnlMjiUaw0AqP+LfT3tonAh1xP9kf+eSYjThF85/08o+otGlESEelB8VTa6qLRhlht
         0Rc1rbfv+gZ2EJ1HQe/a/cbKoJKJ81oe99jqQ25whFWtk5ykU+OeGFYwXyUO3iUTIKpv
         U8/g==
X-Gm-Message-State: AOJu0YwxNY63arIAbqIEVe/4637xvBbKmpMViiDWLC68l9C+CZ64fNa8
	WcyhFdGXKNdQE1oPe8tiGhDjJUP4H/In4lNhQvwhs+GXWEu1Slf2+jQi94Jfx6nr4KbaadSmVcJ
	L+Syo8US08mzUtJ09oRhgkv0fT87bDOBXC64LcqN/vOPuPWFNtl3s
X-Gm-Gg: ASbGncvKRR2c/8XJM8pj2jwhEbSDFfR+rvApLjp3Q2ya5VT+nGHR0jeplhBV3i/8sPC
	VzCA2j9OzG7QTJ92ZQjR3vyfBp3WK3Uyv+h96fBZgEts+U6IjWANHYBrJn43nne6dj2UYzw3Iey
	pnCUTUxXymJVnW17c5mPGEXFEDnGWQFNg96MvbnN65eL/ePe/x8Cr69P9Xs7HIc5Uj8Xam1FzVH
	7+/toSqitVl5OnfGbmOPmfPapx1H5ZA8DxVKIxrkJvIcFQR2Tv2Ckyb3ciqmJWAPk8S2wtroN5w
	qv5qT4R5Y4JCDXS3HIXYpOsSX31hdFNGrvPj8kO0RqALtvgdDWRScql3/kgtBelrUxwKe/LFpLM
	OqurYQxCh5s2YmVcWF27r72E5b2hrj+k2wjendSwHhoNvz8RKcHqFCXDqVamf6EdxDQ==
X-Received: by 2002:a05:6000:2484:b0:3ee:15b4:174c with SMTP id ffacd0b85a97d-405c3e27714mr1264779f8f.3.1758618060362;
        Tue, 23 Sep 2025 02:01:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG3NrQhba9sI3Pw87M3Zg2mlzDIzvm7/y7Fut6QEDxAdFkWqEoochcNJl6lnDgHbTzCBm/wbQ==
X-Received: by 2002:a05:6000:2484:b0:3ee:15b4:174c with SMTP id ffacd0b85a97d-405c3e27714mr1264738f8f.3.1758618059633;
        Tue, 23 Sep 2025 02:00:59 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4f:700:c9db:579f:8b2b:717c? (p200300d82f4f0700c9db579f8b2b717c.dip0.t-ipconnect.de. [2003:d8:2f4f:700:c9db:579f:8b2b:717c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3ee0740841dsm23126417f8f.23.2025.09.23.02.00.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 02:00:59 -0700 (PDT)
Message-ID: <b41ea29e-6b48-4f64-859c-73be095453ae@redhat.com>
Date: Tue, 23 Sep 2025 11:00:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [DISCUSSION] Fixing bad pmd due to a race condition between
 change_prot_numa() and THP migration in pre-6.5 kernels.
To: Harry Yoo <harry.yoo@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Hugh Dickins <hughd@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 Jane Chu <jane.chu@oracle.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org
References: <20250921232709.1608699-1-harry.yoo@oracle.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20250921232709.1608699-1-harry.yoo@oracle.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: UgFE4uXr0xBs0PGMiJ9b1WwwiInx6OlLIKFj9tx3_yk_1758618061
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD5BA8000D
X-Stat-Signature: quqiop183ms6bedjkuij1faf6zxb1eu4
X-Rspam-User: 
X-HE-Tag: 1758618064-723844
X-HE-Meta: U2FsdGVkX19ZJSx/Htv58cocUdQ/WYwy6+w35HLPRHYoAji3F/KJxepZZGU4KGp/8J7HBmSWoGEy9RMDjEWMMUI8jiCdRoGzoFIqIeYLAzkeFcyrs6+4eVQpdnZ6HQCOzVECOXHYeIan3xVIm7YwsD+8ET0Lnt5BDA20zV21km2MItiFsoc4xUigBSb+8bhh1s2CmBzo7s/Am0Er6Yxlk3lMQIR4N/rbxwLGe7VLfrreXywFxqP/lRRigsRCvxP6UFtN7ALnyITdelVIBZd/qKWxx0vBU21XZxYI4yUyGucxblfcJxbuULJndVXxi31JNcTC5WLuhSnSf31ZuSTP5XVeQkcRYXmM/jfEvZC3DE5K6Pv6NY3bN9sdIJ+zY4ah2GY09/0y89CNCCE+NqweB5qk7yu1WUUK8RDodrkieeg8Lhm4Ik+fm+PxljxUBufPcPiFBPfbnRULAToobu2v1RRZ6h5+6OgCd77cC9A7bAAJlQiiBk2FINKXJkgMTh7aoPIJ3bJx0bS+VKsKsdssqW4XehL4C5q3hUUU6ogiYaus9rj6dI1fqu+kE1unIeZO0EAfkf5wKUIXvG/QM3+eM5od0k+zbjdZiO0m4Jd9TN4HQGAfg/m7+FrFjO5dt3M7lkBy/MykC9n7l5VbEIT1Q0BklNZS+N4dxm26s3B2lhA4OJ4fZq6Ii6sVL9uwsiw9R1qv7Q8Ci8oRtLHBI/NXW+yIvoZObzYuhVu4+/kijWpdcs3WK2799jNtJc1CCbDvKCTGlvgMZdkOaon3pB0BNwi2abBo0xXg603AuYC08jrn6Eq+inv/TGcaItYjzpjZa6udv8PjKTBTgenuclwKWm1Gzucn6CK+XgDcAPIBkqK2gtm0VU9znR+iQtWs6Lh96H6xJZcGoClFTQigNpUrqFo5QC17lQY+gjvGIz9LTRO9XoC+I5ySOn2nRc0Vfwi8Ea6WT7LMHVTzQ3cn+ev
 8/4MFspA
 uL9PZnLAj2K6kVXQGfdKT5mPyZatkpQg2dQOu4xZY7+p9xB5kemEGM3LpyG+dMN/qh3EfwDhwqlxy2AUPWoEt9lUREB46U/9H09snJlYiuCGV0RO6GDm26hbeZRzEEfq2kW5MmvZVF4uU6+O78Us44ZAZElNMk038QHTMjMJBU7oFXQBktc+CJz0gCWajXTNQZCwMpsm4XFssm0TwkAsCCFVJsX7fvoJOoqH3zcNgw/AeJYYdGqGsvMkck9b1p9Fd6CtqRDIKx8rULCLDfnRalPhj7t3tjwBINiXQYfoPMmwsdJMUGvjhJpFwlahWJEXGm3PRWHSJXPurfYkmNRCxpsFdX3EPkAkoV3+K1zEKRfo1YiSG1BHBoW5M7DjvCuUknV8QDaxAnBNmT/e+7qbYXF0kmwUeF4SV9Z6xsHc4lWYKtoNDPazhP4BaO1ve1fXtb72BiQ4HzH97LLA/0xMAb15EW3uzyrKjQsKNc9znHpJpuljgyqf6tudl4rZHD+AbySqQyQvI4Z0TvHK1/Ch0GbcydyKXTaRckRUKtVNqaNhCCKqSyJxC+7huidnIFdPySmtgjqvDukgs/3xH0arAWLXWgxRNTlIyak3azmNOHJreJB6HG2EwO2uOPwPm8NuJxpSCS7AVvVXSPj2wNkzlO8M5gantSEY2532M
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 22.09.25 01:27, Harry Yoo wrote:
> Hi. This is supposed to be a patch, but I think it's worth discussing
> how it should be backported to -stable, so I've labeled it as [DISCUSSION].
> 
> The bug described below was unintentionally fixed in v6.5 and not
> backported to -stable. So technically I would need to use "Option 3" [A],

What is option 3? Just to clarify: it's fine to do a backport of a 
commit even though it was not tagged as a fix.

> but since the original patch [B] did not intend to fix a bug (and it's also
> part of a larger patch series), it looks quite different from the patch below,
> and I'm not sure what the backport should look like.
> 
> I think there are probably two options:
> 
> 1. Provide the description of the original patch along with a very long,
>     detailed explanation of why the patch deviates from the upstream version, or
> 
> 2. Post the patch below with a clarification that it was fixed upstream
>     by commit 670ddd8cdcbd1.
> 
> Any thoughts?
> 
> [A] https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html#option-3
> [B] https://lkml.kernel.org/r/725a42a9-91e9-c868-925-e3a5fd40bb4f@google.com
>      (Upstream commit 670ddd8cdcbd1)
> 
> In any case, no matter how we backport this, it needs some review and
> feedback would be appreciated. The patch applies to v6.1 and v5.15, and
> v5.10 but not v5.4.
> 
>  From cf45867ab8e48b42160b7253390db7bdecef1455 Mon Sep 17 00:00:00 2001
> From: Harry Yoo <harry.yoo@oracle.com>
> Date: Thu, 11 Sep 2025 20:05:40 +0900
> Subject: [PATCH] mm, numa: fix bad pmd by atomically checking is_swap_pmd() in
>   change_prot_numa()
> 
> It was observed that a bad pmd is seen when automatic NUMA balancing
> is marking page table entries as prot_numa:
> 
> [2437548.196018] mm/pgtable-generic.c:50: bad pmd 00000000af22fc02(dffffffe71fbfe02)
> 
> With some kernel modification, the call stack was dumped:
> 
> [2437548.235022] Call Trace:
> [2437548.238234]  <TASK>
> [2437548.241060]  dump_stack_lvl+0x46/0x61
> [2437548.245689]  panic+0x106/0x2e5
> [2437548.249497]  pmd_clear_bad+0x3c/0x3c
> [2437548.253967]  change_pmd_range.isra.0+0x34d/0x3a7
> [2437548.259537]  change_p4d_range+0x156/0x20e
> [2437548.264392]  change_protection_range+0x116/0x1a9
> [2437548.269976]  change_prot_numa+0x15/0x37
> [2437548.274774]  task_numa_work+0x1b8/0x302
> [2437548.279512]  task_work_run+0x62/0x95
> [2437548.283882]  exit_to_user_mode_loop+0x1a4/0x1a9
> [2437548.289277]  exit_to_user_mode_prepare+0xf4/0xfc
> [2437548.294751]  ? sysvec_apic_timer_interrupt+0x34/0x81
> [2437548.300677]  irqentry_exit_to_user_mode+0x5/0x25
> [2437548.306153]  asm_sysvec_apic_timer_interrupt+0x16/0x1b
> 
> This is due to a race condition between change_prot_numa() and
> THP migration because the kernel doesn't check is_swap_pmd() and
> pmd_trans_huge() atomically:
> 
> change_prot_numa()                      THP migration
> ======================================================================
> - change_pmd_range()
> -> is_swap_pmd() returns false,
>     meaning it's not a PMD migration
>     entry.
> 
> 				    - do_huge_pmd_numa_page()
> 				    -> migrate_misplaced_page() sets
> 				       migration entries for the THP.
> 
> - change_pmd_range()
> -> pmd_none_or_clear_bad_unless_trans_huge()
> -> pmd_none() and pmd_trans_huge() returns false
> 
> - pmd_none_or_clear_bad_unless_trans_huge()
> -> pmd_bad() returns true for the migration entry!
> 
> For the race condition described above to occur:
> 
> 1) AutoNUMA must be unmapping a range of pages, with at least part of the
> range already unmapped by AutoNUMA.
> 
> 2) While AutoNUMA is in the process of unmapping, a NUMA hinting fault
> occurs within that range, specifically when we are about to unmap
> the PMD entry, between the is_swap_pmd() and pmd_trans_huge() checks.
> 
> So this is a really rare race condition and it's observed that it takes
> usually a few days of autonuma-intensive testing to trigger.
> 
> A bit of history on a similar race condition in the past:
> 
> In fact, a similar race condition caused by not checking pmd_trans_huge()
> atomically was reported [1] in 2017. However, instead of the patch [1],
> another patch series [3] fixed the problem [2] by not clearing the pmd
> entry but invaliding it instead (so that pmd_trans_huge() would still
> return true).
> 
> Despite patch series [3], the bad pmd error continued to be reported
> in mainline. As a result, [1] was resurrected [4] and it landed mainline
> in 2020 in a hope that it would resolve the issue. However, now it turns
> out that [3] was not sufficient.
> 
> Fix this race condition by checking is_swap_pmd() and pmd_trans_huge()
> atomically. With that, the kernel should see either
> pmd_trans_huge() == true, or is_swap_pmd() == true when another task is
> migrating the page concurrently.
> 
> This bug was introduced when THP migration support was added. More
> specifically, by commit 84c3fc4e9c56 ("mm: thp: check pmd migration entry
> in common path")).
> 
> It is unintentionally fixed since v6.5 by commit 670ddd8cdcbd1
> ("mm/mprotect: delete pmd_none_or_clear_bad_unless_trans_huge()") while
> removing pmd_none_or_clear_bad_unless_trans_huge() function. But it's not
> backported to -stable because it was fixed unintentionally.
> 
> Link: https://lore.kernel.org/linux-mm/20170410094825.2yfo5zehn7pchg6a@techsingularity.net [1]
> Link: https://lore.kernel.org/linux-mm/8A6309F4-DB76-48FA-BE7F-BF9536A4C4E5@cs.rutgers.edu [2]
> Link: https://lore.kernel.org/linux-mm/20170302151034.27829-1-kirill.shutemov@linux.intel.com [3]
> Link: https://lore.kernel.org/linux-mm/20200216191800.22423-1-aquini@redhat.com [4]
> Fixes: 84c3fc4e9c56 ("mm: thp: check pmd migration entry in common path")
> Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
> ---
>   mm/mprotect.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 668bfaa6ed2a..c0e796c0f9b0 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -303,7 +303,7 @@ static inline int pmd_none_or_clear_bad_unless_trans_huge(pmd_t *pmd)

This is like the worst function, ever :D

>   
>   	if (pmd_none(pmdval))
>   		return 1;
> -	if (pmd_trans_huge(pmdval))
> +	if (is_swap_pmd(pmdval) || pmd_trans_huge(pmdval))
>   		return 0;
>   	if (unlikely(pmd_bad(pmdval))) {
>   		pmd_clear_bad(pmd);
> @@ -373,7 +373,7 @@ static inline unsigned long change_pmd_range(struct mmu_gather *tlb,
>   		 * Hence, it's necessary to atomically read the PMD value
>   		 * for all the checks.
>   		 */
> -		if (!is_swap_pmd(*pmd) && !pmd_devmap(*pmd) &&
> +		if (!pmd_devmap(*pmd) &&
>   		     pmd_none_or_clear_bad_unless_trans_huge(pmd))
>   			goto next;
>   

This is all because we are trying to be smart and walking page tables 
without the page table lock held. This is just absolutely nasty.

What about the following check:

if (is_swap_pmd(*pmd) || pmd_trans_huge(*pmd) || pmd_devmap(*pmd)) {

Couldn't we have a similar race there when we are concurrently migrating?

-- 
Cheers

David / dhildenb


