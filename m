Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7E5EC44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 07:32:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C8F016B0102; Thu, 22 Jan 2026 02:32:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C14726B0101; Thu, 22 Jan 2026 02:32:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B11FB6B0102; Thu, 22 Jan 2026 02:32:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9FFE66B0100
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:32:30 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3B59A138FDC
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:32:30 +0000 (UTC)
X-FDA: 84358782060.10.964E58B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6317E80006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:32:28 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769067148;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=c1+EtnIjlBISuvdvJpqzwSHkUN5N1+SERnNkX9U/nos=;
	b=1p5OHzKnOPgPQqKCXzcgDSj+xRl3f+LjrM5+hq2DLJJymULSlDHc9HYNEjPIINElUzeGGx
	6sbpf8/pao2ynGGZeh5Mru01bvg/5j/+tJS5L4haeLJofTvhYeO7fP9oJJDXKNuW6NF0zN
	6Bg7ZwUBODKl3g8pz/haZ8gWiuLBPHg=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf30.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769067148; a=rsa-sha256;
	cv=none;
	b=w7ICBHh08enM/h5ewTiHYt5EkUfKtnY9TMVnV0RiCo7Su5mPk+3Musz9RVdWyPqg7v6NIk
	nZG8cw3hlMo0U8JINDNmPvAcTnww1ToZU+T+ModbwExwbhV3NPIPcK8F6Lqnm2cL5s7ui9
	3VMLd3gwm4mE3RFdy2Gf5sHjwBkjECg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C2D9E1476;
	Wed, 21 Jan 2026 23:32:20 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 977F13F632;
	Wed, 21 Jan 2026 23:32:23 -0800 (PST)
Message-ID: <829b62c8-e3eb-485f-8d7b-01419c841cc8@arm.com>
Date: Thu, 22 Jan 2026 13:02:20 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 2/5] mm/khugepaged: count small VMAs towards scan limit
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-8-shivankg@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260118192253.9263-8-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6317E80006
X-Stat-Signature: re31ohcjj6kxbi1ryekaf83x9riyzmpf
X-Rspam-User: 
X-HE-Tag: 1769067148-664786
X-HE-Meta: U2FsdGVkX194BlZn98W2NN6vAUOmpfa6qAN3esGlt46OulhvJ8tBwDzdxvtbA6N2F0k2+qy+VeJ88WDTmBpECteRXCGslzScHkaSB9xQRr1PjDzGi/kG+5uxMQBr6Fcn4Hort+WPuYzqDSQNJUV6OxIA6SvZsKR6zrM8z3bhKZkpa8/JNYhofRxtpiObYmJbpNwGrwb65w+zi8Yc3kaTtacORH1LiNZJKD260BOo4CORq/N+rMlmL9Pu39UFqOUYvmQU+Og4WQwsUy4jKnubrVXQJgW9BEXXqEbNOgS23FYr3MZj8KXuTJNGewsr1xn0PdUWKln6M6oQUh93MqpFPxbvvMC5hwqEDMXK7ihY1mJZEreTa2IEjKudtZqlBnnH38UKQsOJpdyjZRDBW8o4Vp9+QRHKbFx1jVtt9k2v7gkeWe8laMWrO7pqljX7F8hwCvLyPTaa5KbxxXVWuL5m6ZqVzmMFz4jg2NLUqUumlmWGOeYGETYcPy7KJtw3/bCPMhpWkQhgyWgPxr9sa1o9SP5XQUMdHAhQ2/FsXNEzhjSy9N0khIBgJmmpcfQzrP6UggAbHcxUIHW4WvB5ytBFdU/FI8IMEsmFBcwF4+u6KVxG9uaUZt0zHog7YYPSw8sD81EZT+4jik7H2oHw4Z8Myubz1N8lGds1AN/YGoqn58hIfPbOfvAujPUKyq42Ffx7G9Bp+klWgjUYP60Yf3qhEu1mhfeX/HniSVvaL5r+Vdl1KDkTK5EDtGCTVJLGY0vlLrZ2FoqXzWXvkHjhfkITZrHnRomswqaANs/2sLA3U5mgYflccJsQUh/pykRfjdNwMZ+9QslNSv88872k4jzcy8M08lpl1gPAJyWg/nFYH+vbWpj7uKRr4syDl/1sHaJUrPYImowb7ZgdcOG5MJkICeN42oGAWVpmBfpwDZ+XAim4bhQrtD2NSvXhqM3nZViPz5rYRn3nN1YhKh/zi5c
 RATkWvtO
 n70qmBpEGUqDyd+Hzv+ivux1qXHy3scPOKrf7ZamPMMhgBteiIaYyQdemTgjbNII6WiSs4i2wRBKnoVH7A4WlbBY4LgOA1fe/wG4isV+9KTB9TfAwKPV6j6kUfciPDifLjqf7oqT8sQKLKsj+0M7WC4NMikOaZwj9lTNLGvmHdGNfSol8DplKdt7ZoQq8mIwvojThH0aprBjj0NvHQ+lYSJxCSIDksL+44SvorHl8o/i1aUBuele3DJLyWg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/01/26 12:52 am, Shivank Garg wrote:
> The khugepaged_scan_mm_slot() uses a 'progress' counter to limit the
> amount of work performed and consists of three components:
> 1. Transitioning to a new mm (+1).
> 2. Skipping an unsuitable VMA (+1).
> 3. Scanning a PMD-sized range (+HPAGE_PMD_NR).
>
> Consider a 1MB VMA sitting between two 2MB alignment boundaries:
>
>      vma1       vma2   vma3
>     +----------+------+----------+
>     |2M        |1M    |2M        |
>     +----------+------+----------+
>                ^      ^
>                start  end
>                ^
>           hstart,hend

Won't such a VMA be skipped by thp_vma_allowable_order()? That internally
checks, apart from eligibility by sysfs, that the extent of the VMA can
map a hugepage.

>
> In this case, for vma2:
>   hstart = round_up(start, HPAGE_PMD_SIZE)  -> Next 2MB alignment
>   hend   = round_down(end, HPAGE_PMD_SIZE) -> Prev 2MB alignment
>
> Currently, since `hend <= hstart`, VMAs that are too small or unaligned
> to contain a hugepage are skipped without incrementing 'progress'.
> A process containing a large number of such small VMAs will unfairly
> consume more CPU cycles before yielding compared to a process with
> fewer, larger, or aligned VMAs.
>
> Fix this by incrementing progress when the `hend <= hstart` condition
> is met.
>
> Additionally, change 'progress' type to `unsigned int` to match both
> the 'pages' type and the function return value.
>
> Suggested-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>
> Incorporate comment feedback from Lance:
> https://lore.kernel.org/linux-mm/6b408736-978a-4d40-adfc-97819951c3a6@linux.dev
>
>  mm/khugepaged.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 984294a16861..93ce39915f4a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2403,7 +2403,7 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  	struct mm_slot *slot;
>  	struct mm_struct *mm;
>  	struct vm_area_struct *vma;
> -	int progress = 0;
> +	unsigned int progress = 0;
>  
>  	VM_BUG_ON(!pages);
>  	lockdep_assert_held(&khugepaged_mm_lock);
> @@ -2447,7 +2447,8 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  		}
>  		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>  		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
> -		if (khugepaged_scan.address > hend) {
> +		if (khugepaged_scan.address > hend || hend <= hstart) {
> +			/* VMA already scanned or too small/unaligned for hugepage. */
>  			progress++;
>  			continue;
>  		}

