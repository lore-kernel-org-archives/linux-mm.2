Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8DEAAC55160
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 838786B0098; Thu, 30 Jul 2026 07:42:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7E9266B0099; Thu, 30 Jul 2026 07:42:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7268A6B009B; Thu, 30 Jul 2026 07:42:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 539596B0098
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:42:05 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E80E91A00E0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:42:04 +0000 (UTC)
X-FDA: 85045254168.20.D61D8F8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id B4D0C18000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:42:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H1Gbg5PE;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785411723;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CwHF51oOsSu2w/ZbQy/Inj70L8Y1TvOv/J97Y4M77nw=;
	b=TQeErFE+ctdxkNQSFpPy4wENS/WjV89gc3hN6IXXMhVMYcK9HumdE+2qbWP4M7pS17Xa4C
	fBcN3j8d7HCbdBrKCwO43QVgzMKnSCOhY0Tjnh6VriG2Kp7z1npck+kRbpQDQoFOXvOGyl
	RYBbwXKFhQ1pGKw8ZEsM5HxZpr8AzsI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=H1Gbg5PE;
	spf=pass (imf16.hostedemail.com: domain of usama.anjum@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=usama.anjum@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785411723;
	b=gd+utvtPExfaNKvs9Med/+StuV58mH6kovOXTTu9fQxP690IRcbepDaKbyBSxZ27NDoqGF
	td10YZjRa8VStdYhcV9XsV05vrLxKul1iEAaF5vcS+fvd2NOFlNOkpxwZECANBIDNJACv1
	u9eKWaQUnv4wEutyptNLUz3oPldeFaA=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B9791684;
	Thu, 30 Jul 2026 04:41:57 -0700 (PDT)
Received: from [10.2.198.93] (e142334-100.cambridge.arm.com [10.2.198.93])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E9EC83F763;
	Thu, 30 Jul 2026 04:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1785411721; bh=GWKxVBmk/3OJM7zFLMXgOeSR5EPxu/L2awcWvhPKBNc=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=H1Gbg5PEEA8RfVYqh+JrU7GcC0XeT11ZBcXomHbtz9Xevp7Jp19CVznkQliO5hu4Z
	 U3mTfHjiUdlQ940dq7P9VBP9dStAXd0tFYEZDGE4BS4qLaIvslODSeTET8TrsRMjlw
	 eUfL/89J/usdRkF4ddRgTj7fnb5o4l2XdCSr5SBo=
Message-ID: <e098031b-23bd-47ff-95d0-3c0ce9487439@arm.com>
Date: Thu, 30 Jul 2026 12:41:59 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: usama.anjum@arm.com, Pu Lehui <pulehui@huawei.com>
Subject: Re: [PATCH] mm: use proper PTE accessor in move_ptes()
To: Alexander Gordeev <agordeev@linux.ibm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260720141633.501799-1-agordeev@linux.ibm.com>
Content-Language: en-US
From: Usama Anjum <usama.anjum@arm.com>
In-Reply-To: <20260720141633.501799-1-agordeev@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: B4D0C18000B
X-Stat-Signature: 4nnunn9gyedtngw83e8chma9jmqiwzmg
X-HE-Tag: 1785411722-533612
X-HE-Meta: U2FsdGVkX1+LJ3CA/nuOQ6uaclV6iEK/8e19lPWPp3ysns2ZGhETh8PkJD2bPZZZMVEBoCaZsBPzD3taCc8zQCN8nrAGdtfLsqwVZ02SrG7kVpO1zbg1T9P0gjr82FB/j76UnYGCpVTjkQsV54xdp1imSr10NI6NaJNd3d4FUgrud06WkYEJKkiKp+hS4RfO1dQQatWw063zpNoPJV6nK6xkssDwAh+Knl402AJ+nWyQKnc01XQ8q3nnh2CPSQjfuaVbzDq/Fbp6DPJ4N7LCNbr/iHkHzR/xivAhvRKJ1H3mqr+0WSvlJdt3fO+0dEtYsenxbA39Ot0kVqOIOK6JupM9PA0LgmY7B3k8dQT+sHm18Gxs+Uq+tU43kHGsgwhQVmnGdPApPM7j4S4wTlsa/3/13ZRmfFncFJkBDebuWot/gRqG2AJmetSEkIQXbbprf+8A4JtnYEb8ltGI1gQ4WHBuxPlBNyJ8wuKKSfFqyWO7TquSBIGpMMQmqGo4xhOpuAYVagIVBqTpnArOBklxAMPKsWPO9pyUvjO5EiLuRzifrcQia2IEMpqOIHbDyIqeigm0tfOqBCs/EyOjX2OQg19Ab+gg7sZEi7TWiTw+3w7swWytoPVW6E8ICLP7PjVBDMAVuWRE1Op7V2lcyVnExFlMhATbcS2qqAXk+AnkDafhjetzdix9ikGtNcjZL/IfzHYYkxrMvgGzPqjF16OQxht+CE1hPJiBp7SE7oy6QQJqGRvEw086258Qc3KQxJue95ZiXCvJZgUx7ZTLUoa9HygY+iiSGD2O57SV/nCSApDcM1ZwCQraynMwxEHiivGyU4FZ+35ylHdh132yzxvCdUQ42xZ5K4Pz72LrBH8H3hz+9nL+cDTYIv33zVAqiuv7yNbeUJeycJqDTy/erpwQCF5C5Z+/OrFd12mol/fBO3fKfP4gAE5AC7XNRR70nZtC9jH7b9Bz97bkTsN6RPq
 wvxjZCnI
 APfWC5K/oMYL5Iy9Ijwn+zqTZZNAv7W/lEF+KwzJwWRBFNDZF8LezHT8H2x70/nnhjTKWi98GGY772i8Pu2dYrjXUCV+wS98GaLitlrGiqLoQJP3w8E6SfMODLBVjIjm9ivvCx9SWjfMpuZoMO3B/aiaaKGzXnkIGkJWrhKXztPccgz+eikEFSkpJOF1nK0EvjBsfTPE72unSBmVar/59r4DJDgnP1iH+9CKAq1BZdpuD/ovyAwyZjlfD8CSipmOiXeBwrFF27dHotuZV+uAjt5T1FQDz1vY1S+MeuX0sL70o0OHrv7cDb7wGW9ZP5H0SMb18doSTDWVBR1hbDNk2qIYRkksqf4ON5W8BQvFTaRQNkCw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20/07/2026 3:16 pm, Alexander Gordeev wrote:
> Follow the pattern established by commit c33c794828f2
> ("mm: ptep_get() conversion") and use the proper PTE
> accessor instead of a direct pointer dereference.
> 
> Fixes: b36b701bbcd9 ("mm: expose abnormal new_pte during move_ptes")
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> ---
>  mm/mremap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index 0dfe3de39ccc..e99b19a9850b 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -264,7 +264,7 @@ static int move_ptes(struct pagetable_move_control *pmc,
>  
>  	for (; old_addr < old_end; old_ptep += nr_ptes, old_addr += nr_ptes * PAGE_SIZE,
>  		new_ptep += nr_ptes, new_addr += nr_ptes * PAGE_SIZE) {
> -		VM_WARN_ON_ONCE(!pte_none(*new_ptep));
> +		VM_WARN_ON_ONCE(!pte_none(ptep_get(new_ptep)));
I'd the same patch in my RFC branch. Hence:

Reviewed-by: Muhammad Usama Anjum <usama.anjum@arm.com>

>  
>  		nr_ptes = 1;
>  		max_nr_ptes = (old_end - old_addr) >> PAGE_SHIFT;


