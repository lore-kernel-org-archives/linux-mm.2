Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C630FC5DF71
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 06:36:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 245AF6B0406; Tue,  2 Jun 2026 02:36:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F62C6B040A; Tue,  2 Jun 2026 02:36:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1342D6B040D; Tue,  2 Jun 2026 02:36:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 051CB6B0406
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 02:36:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C25BE1625BD
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:36:53 +0000 (UTC)
X-FDA: 84834014706.15.79CD20D
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id C274AC0009
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 06:36:51 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p6MC8xIh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780382212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbV2ba6ufByeLTz/eEXm3fk9UoyCf31oWQKaXI5SGFc=;
	b=oNrBHg4fvrw4uV7ymKGTGHR40WzmlldOafhgfsVkeCfBF1vY2s6uoQOXKwEtTLfUGTyreC
	pQZVMW5s1ynNEloU1LQ3QhdM8gPCS1d4UXQvXiPZVf8dV5Iuhxh9usDUwiHWE6O4whtD0M
	nQYggO+ATo2H+7KSCdnB+IWpLAmk4HY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=p6MC8xIh;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780382212;
	b=t9pXdQfY24A3uB/cuOzFmKs4zNzinzul/VYc6onKZhc59R8utVM71INxELsIxNyw21ic2D
	SSQJTb/pS0SrBfOnEPh8zHYW55JUxfYBn+AcNWUVUtCN5vScSu2TGkqAL9IB0mkDSWT3hN
	JuWM8shj2bRnhX6h2UMNYs817zrUopE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id EE51232CF;
	Mon,  1 Jun 2026 23:36:45 -0700 (PDT)
Received: from [10.164.19.28] (unknown [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 501BC3F632;
	Mon,  1 Jun 2026 23:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780382210; bh=hpM60ECSu6dT7z/73PUh64EF1RP0RcF1FXtP1wXOo5Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=p6MC8xIhKHmkf2W6HFKQ7QZ4vR+bfrEuDshR6Wi+MXh/bkI0sViriLHyI7KajfB0/
	 lx3Xo/r4+mfUm6f/ddif0SV/Bl7oWf5SFDDgxZ3/gsEdtPULneWc9tMQopmKCrgFZz
	 TnzwR72Cge9hd4K01+lgzkQwKxu40Dyn/1qlf6Mo=
Message-ID: <47959866-1289-41ba-9cb4-dea33fe8b721@arm.com>
Date: Tue, 2 Jun 2026 12:06:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/6] fs/proc/task_mmu: use huge_page_size() in
 pagemap_scan_hugetlb_entry()
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Lorenzo Stoakes <ljs@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 David Hildenbrand <david@kernel.org>, stable@vger.kernel.org,
 Sashiko AI review <sashiko-bot@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 =?UTF-8?B?TWljaGHFgiBNaXJvc8WCYXc=?= <mirq-linux@rere.qmqm.pl>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann <arnd@arndb.de>,
 Andrei Vagin <avagin@gmail.com>, linux-fsdevel@vger.kernel.org
References: <20260529172331.356655-1-kas@kernel.org>
 <20260529172331.356655-3-kas@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260529172331.356655-3-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C274AC0009
X-Stat-Signature: as53kb7xzwr6gbi3pejztsgnxptd9euf
X-Rspam-User: 
X-HE-Tag: 1780382211-130198
X-HE-Meta: U2FsdGVkX1+CskMdqyvFBywGQqnd5wcRWYKyKK2fovsthx/9IygDxXKgzArUMX+MCUqrAOz4wyJ3KdGoP/UEmznEHGYDaX9CQLT79WmCdyp+vtR7a/VooxX9dmj2Bp4VsGyt+Bx1y2o5LFgobzswe8bozuPxedMXck2Imi6mM6tpJz42KoDDkYQTyI/PGY9MjS5Au34IVbhBpI8sWjXAYu4oMjxggbIoXtLYUFMa9wuGIkoc9Qw5ljlAdiRxH8SSSLdC/NJlXqyTLbjDl9ph87Lyov8NwTPKNlf0haWdz64d3PWPO1ERoDbh493xouNxymr219k1Sg6E7hR3Olu7ST4T8PaySI84PwblEb9jfT+Dhk1C4mFSpZw1xI0zuVVFBYQ8+hAp3xZXuboZQrCA6gWy8tkU9o5zbhlLJk/PzLEhNaHxYzsIDBBojdcjrY4JcYcAWBR7lWH0rLMaEn42lHGlgoUufbcQlrpCDqV0P8mSoWiHldcf/1wm3N3j1wYfuFw3H1iX5xjo8Wb7xmv25f/cvM56Fm0dWiPdvsCIoY0dr3Frzqont2H7v7+Dh4hI9LIGg56e17luIscvuZIFMSNr3eWw9X6tjtASZ1UE6HvhGtUmmxeNxyWgT6PBWGj9SNFEqQ46qSHM9A5GPvRV64GWK9e7cp/SXqsaOArSppEINSNpF28IF0To3q89sssR8EiQtB8X2lPXJdxy33GWrx7dpNJMP6ep2OiLt7jBcb15qMIZ/IlYegHqeOfNQFpvOS7h59lv8OYedLdxcp5sRCYvl1NqPmR/mcoC2WdHmpIsZPDF4ZAByZE1ck6I8NGxBZEropWFJjfMpNTFkTbJ7H+lt1+RtAcSKwSSw4aKLy+7M3evWz1UlCZo7Uo3Mt5GAt/e5N6Yw+T7yDMbYJeHZx4HpYdPVCWb96lYTFUAcAYHC5SrnSskXv+EVfXXSROuIfRuQqOs2bAwAUgO7hR
 Og9fssYM
 zMzRXWIlAugaHkGRU481N2iQ+zJECCjnDocmbIaF9CTddRRLUn8re5TJB+YT+9AcbNAikl9wb0IEbMX5lFbfBUQWVGcB7ScrQvJDsGsPTeBHMBp5LsvbfuLGqgIPeBfWOK3tJBnD97kGPtwQfhZs+aWuVg+w8Edb0BfLOaqv0AQdxRCdIDTaKllk5lXz+Qt3HRFqpUS/DjNmnN35EL7KEztMorQ4vxFaRRjYl324VsBYG37TV2saWhLwOKjEHiIs9bULopA+SLcJI0hgd4TkLS7S3HY7tRppWyxvOIhEb0byeQoVCZ7DTclu9L4u/MT1e6Qorel9dINyCMftt6wtIpyE37eTxLIcjg4oaJ5M/p+6b6F8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 29/05/26 10:53 pm, Kiryl Shutsemau (Meta) wrote:
> The partial-page check compares against HPAGE_SIZE (PMD_SIZE), which
> is wrong for gigantic hugetlb hstates (e.g. 1G). The walker hands the
> callback a huge_page_size()-sized range, never start + HPAGE_SIZE, so
> the comparison always declares it partial and aborts the WP. Compare
> against the actual hstate's page size.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Cc: stable@vger.kernel.org
> Reported-by: Sashiko AI review <sashiko-bot@kernel.org>
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  fs/proc/task_mmu.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index e21a38ac745b..1489c67e88f7 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -2960,7 +2960,7 @@ static int pagemap_scan_hugetlb_entry(pte_t *ptep, unsigned long hmask,
>  	if (~categories & PAGE_IS_WRITTEN)
>  		goto out_unlock;
>  
> -	if (end != start + HPAGE_SIZE) {
> +	if (end != start + huge_page_size(hstate_vma(vma))) {
>  		/* Partial HugeTLB page WP isn't possible. */
>  		pagemap_scan_backout_range(p, start, end);
>  		p->arg.walk_end = start;


