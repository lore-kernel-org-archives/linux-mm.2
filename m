Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07226CD3424
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 06:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 317CA6B0005; Wed,  6 May 2026 02:46:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8CC6B0088; Wed,  6 May 2026 02:46:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DEC16B008A; Wed,  6 May 2026 02:46:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 094F16B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 02:46:53 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A2483A04BE
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:46:52 +0000 (UTC)
X-FDA: 84736062264.23.87EC710
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7CC43100003
	for <linux-mm@kvack.org>; Wed,  6 May 2026 06:46:50 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iZSjygop;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778050011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fDIKOXzLh8b/6k4kDMKE5XN9tNAAyDfy7kHAa6y+dGs=;
	b=Be/0SOXFzu2RMg/FHc+Lmr5luMt2pFLgKClRYnR8k/r5ugHu+RRGKZ64mgdC+hCKGzIm9c
	p+65RhdmX9SEfeM5UP1UNAczR9GWsFm/QsUJtzhPbKz6wRxAJiohqLuovJixO7pfEN/XCf
	kMb/cmNN/C1par0Wa+7YLrkFuGn+fX4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=iZSjygop;
	spf=pass (imf14.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778050011; a=rsa-sha256;
	cv=none;
	b=UEmv+rV66sbBe+0SoZ8Yb6t+UrRmBEoUEKhowMgYCLkXhb/in2UUjyD6vQgn102oNzX0BS
	CiX5igN9ybVl05KmtBJU+Pm3tWBJMpY7A2HuJA/z7/i+eVwBLH5gu8ya5DAAyW2nr6F6Ns
	g/o00iXYaG3tW68WRYuxrwTKFCEYoqQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 164071A25;
	Tue,  5 May 2026 23:46:44 -0700 (PDT)
Received: from [10.164.148.46] (MacBook-Pro.blr.arm.com [10.164.148.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0139E3F763;
	Tue,  5 May 2026 23:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778050009; bh=HFZLpvkdsNmTj63qRZ7hFn86ZsvIp71KRJEco/ZEoww=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=iZSjygopO7FKtdzR7WuyKQRo4UxpS+t/O4U4GQ4lSfoaQtPS/qNgUJKQAO0o5JqEO
	 XhZxOFlIBLwPAN1Cmf6hP+b6FbHcGABYauA6SLw62LqPzySqOIM4mQ4aMWLek12rxk
	 rGiRJXuxCEbQc3MFkLnNvPba33PW5CQK0YQKnOok=
Message-ID: <3fb8c00d-d60d-4fec-81b1-e7633384a52d@arm.com>
Date: Wed, 6 May 2026 12:16:35 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/khugepaged: clear MMF_VM_HUGEPAGE on
 mm_slot_alloc() failure
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Xin Hao <xhao@linux.alibaba.com>
Cc: Ye Liu <liuye@kylinos.cn>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Andrew Morton <akpm@linux-foudation.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260506012130.9306-1-ye.liu@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260506012130.9306-1-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7CC43100003
X-Rspam-User: 
X-Stat-Signature: cz6th1gehsxwie9etcmt3b3g9pgp1iyf
X-HE-Tag: 1778050010-628170
X-HE-Meta: U2FsdGVkX1+KS1Dln1v7L9fmOgNx2HUC3/fePpkZgdadPxnvin8o7rvcFu9eSlwj8khaDT1kdfwPvH2ZqCT7Zar6pdEIZ00vQnKtUpo6bb3EollR/kFLIufQrhVvPSwNlf21LVoU8MTzS83WAFZDYUsGGVho7AMjcmzUJQRDXYnTVuHrwdVeT6MpsnP5Tr4hTYWSBVZ/hdlcgEfggrksnc1WgGmKV4UchxNlAgSoefgyz/qIJKLic8Q+391YPk4t2SnHTK9DsJIotLq8RhLZ3EesPXTYRs3R5Uj4npdjTOLRXWKBDDaQ5vMkCUdVJ2m0x3JdPbxNsg0Z0iH8SBNSJVZxxx+upf7SVTVWQPPoMgq/0dkik+UR0wjpXK8cbIOhyBzyJKi0caDdJKmqV4nR9hfgsFasyb8Si5vC3A/I2k/hLH3V5oQMTCbByRz5Kn0U0eXOPQ97an7LD8LN839JM65UwEPv05CT4X8Yxs/dybhWLv92QYD3EZnUYj0voNJuKFxZSAQvoZRYaQPpoUGA5RzTAl79BTUPQWz4q8U5lEoQjhx3hkvlK2y6vdYAojut3OA0CogDHzIOcYJNiIeXXMqf45BOH0H+4COyq5N6DVyDB6HvYThHxia08OM0PJl94CghOzAOqhUHa53Anb2dnWUht/eUBOl0lSkecevQrbkeIPCpiGmlA8TTeO3AhhHhgYGHWVMiB9posx/rvv8TxbpXh15RNLDpEc6nSceGPcytPnaJuyHW4FONHJxTjY1KN/H+LJCfjEesN9+o9EPPFhOyjTn5lOoqWyL7PTbaWnOqKSWAUjZG6MrVAZXV96jU1qFaVH96B771KBC83C5LFjffYK16X7rM6in0YJqgzJ3tJ3282R8xG+ra5FpSUTeF4EEqA1CqpJYOWkQM6wHngHtvQEBcAna6mCEadBXTIYS91TY9s3DqQKeqhoZF382ck7q2g0zL1jtLZrwVfkB
 hbxid9Md
 Pwai3cTEmgsn7U4hblc3jY1iwWQ5EDZqVfBSppxSR/ofPzdOFljYlMhOOGWKyGXzi5ZnL1V1cUyPEokd6zL2NauMp/rc+RHQzfrH6K34oiPSIcNHhIk9p3y8kIJMYcp5xQhfrAPEKYm349zfC32IHr+UdbSY/RoBgZ6LwybbpDBNM8wGSpw3iZ7X4tlpb/buSDsH6LUlvwlzCm6VbHEuJFMBYEJV2w59dWkhBkjysCdEFt7rkoIiAJmXBWD1aQApYhMjviraKcw27EdJIRB3hpAKtSeJcevp26H0MNEfEg1RV6SdjwEjtSok8PhvbFyMYTA9jL0yejNvkmDvDCjNtg9vJhA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 06/05/26 6:51 am, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
> 
> __khugepaged_enter() sets MMF_VM_HUGEPAGE before allocating the
> corresponding mm_slot.  If mm_slot_alloc() fails, the function
> returns with the flag set but without inserting the mm into the
> khugepaged tracking structures.
> 
> This leaves the mm in an inconsistent state: it is marked as
> registered (MMF_VM_HUGEPAGE set), but will never be scanned by
> khugepaged.  Future attempts to register the mm are skipped since
> khugepaged_enter_vma() checks the flag and returns early.
> 
> Fix this by clearing MMF_VM_HUGEPAGE when mm_slot_alloc() fails,
> restoring the ability to retry registration later.
> 
> Fixes: 16618670276a ("mm: khugepaged: avoid pointless allocation for struct mm_slot")
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
> Changes since v1:
> - Add Fixes tag as suggested by Dev Jain and Lance Yang
> 
>  mm/khugepaged.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7d48d4fbd5f3..60ab7c1b61dd 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -559,8 +559,10 @@ void __khugepaged_enter(struct mm_struct *mm)
>  		return;
>  
>  	slot = mm_slot_alloc(mm_slot_cache);
> -	if (!slot)
> +	if (!slot) {
> +		mm_flags_clear(MMF_VM_HUGEPAGE, mm);
>  		return;
> +	}

Note that, a racing khugepaged_enter_vma() may back off
when it sees that MMF_VM_HUGEPAGE is set, but then the above
clears the flag after slot alloc failure. So we end up not
registering the mm with khugepaged. But I am sure no one
cares, we are in much big trouble if slot alloc is failing.

Although one could argue the same about this patch, I will
still say it is important to fix "flag is set but not registered
with khugepaged" because that just feels wrong.

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  
>  	spin_lock(&khugepaged_mm_lock);
>  	mm_slot_insert(mm_slots_hash, mm, slot);


