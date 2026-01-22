Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BDC10D62606
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 09:28:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 144606B012A; Thu, 22 Jan 2026 04:28:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 11C866B012B; Thu, 22 Jan 2026 04:28:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 073A66B012C; Thu, 22 Jan 2026 04:28:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EAD446B012A
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 04:28:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 872721A0219
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:28:25 +0000 (UTC)
X-FDA: 84359074170.10.0F0C656
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id C320A180006
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 09:28:23 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769074103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+6O8o0CLfACvMNm7PlpOKlIfZBdzVHk49w13/EP+J80=;
	b=zT8i2bus8Rwh5DUISuNltor5v7yC2m+SDpfjMzoNosK39pXtspr6NPYD7gGmzDe/5yBX8r
	/UyOeHa66nllHkVdoGKmbup1L/8nNfLibhBj51X2t7x3BKXyLsqvoIr7PpBPSnesApjIGl
	t5AZOXiQD6bdf6HXJja+orHYELdXnOc=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769074103; a=rsa-sha256;
	cv=none;
	b=A0I5RD+wAOJofe2HdW56zMEDLrIoiFOkA4z8LIgIyiHJOT4N9thvlvPWL3/1hBFEmyOs/1
	zoOOg+UhTGiJIg71h22Q49cksDNmbUAccXul/c1nbnS5N/56TAISfLlTyDwj6Q21CyoqHa
	5fNwNFoG4y9Ceu2im+sb59zpvrgxQEM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5F0A41476;
	Thu, 22 Jan 2026 01:28:15 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E3C973F632;
	Thu, 22 Jan 2026 01:28:17 -0800 (PST)
Message-ID: <6486c6dd-2702-4a4d-9662-09639532ce6f@arm.com>
Date: Thu, 22 Jan 2026 14:58:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 5/5] mm/khugepaged: make khugepaged_collapse_control
 static
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Wei Yang <richard.weiyang@gmail.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-14-shivankg@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260118192253.9263-14-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C320A180006
X-Stat-Signature: y6r8rof9ndn4asxqgaayz84g7rpbc8fz
X-Rspam-User: 
X-HE-Tag: 1769074103-415438
X-HE-Meta: U2FsdGVkX186S2RQni69/0fCGftVqnOuqF2gM5nm4Fg0hgH0ZW8VsVfBDgCJR0dbWAEP6WbD0Yhn1z8R60f2GjlqchmIKOQ3W2O43CeCeehPlzfy8CWw0dAn4Tq/yHBQzDwjTH2oi3N9jfVfVFaieMHAhyBfiFIxp2Il8QEQQHv5g956NnmtqHLGAcSR6H8qZ8FAtIizLMeAMEcb1Fu5qpqst0d0kXPmewJL74VtbkTcDb0XFxS9jenTh3AGi6Amew4LnIpHWTYdVaT6VeOk/rddhuY6FSE4NmcClZrxjGwzII7IvSFFqpoknWX8AM6h11ZRgWvsaulXm4N2FaKJXCYC9r3+HRw/TZA6h8W65vjEdAlM6wV0HBXv71vIqTEahKEM1Oe1qc5ww0ITgc/7qJ8Mnc/DF8cuJcJsyPLjSyX+cf65tojJQPcDOyihzbIHXu/t9p7s9gIq1YnmFMFphhMbFNZ4UNcwfyuYSZ1b/xi3fD8kKXOZTJ2bwsQMctEF1hhL02j69sGoPXHrbGA0FmLo9g2VLy8qaAE8T8Wpep0EwC53SlONQd5D5X8UGtGmSxBs6OsaVlW2NZ35m5+sUIZQfaXI6faPMHEhTm8XwVEm8HUofb1+8ves6yd6fGvHD7c9y7v8/pTdiiSjlqjU1d+qnyIKPpilcqZtMWJYvIs6X/XUIkolhLE3INIFcvWGHzucp/dwnUfKYjHh4R2bzL+4xgp5I+8IJfZl3K0XRbL2yv/l6vm1Bck0Pz2shZPFdG79kVcqBK0JDDlzLE8bZRiO5zSkw+jZ7vIax5kztx0gcptHo75YqLx0qt1mdLmoFtJYrx2CfZtN9uRTTA/MxcPIz+TBwlRWki120QmFd1ZWUt7KFK+Bdy8lcG30kN5Oicx/oHrmA1WdtKdHw5u9LUbeQvpC0RpzcymdHgpg6WJQ9dVSmay7akaBnlXq7OHp44zO561gLxtjbhuoH7e
 VCMn9gVf
 Uo/I7kRahrvdWLODPi+9wsdJ9Ht1jFNdhaRHf6wX5Sp8iXGy3INFYZNqIhXxetCXcpfLb+nqjgfq2j1D8Y+nSmfGOzEVomqecDBchDKRTV5kbs3gDq2g2WhC+f6i+9fawekc8u1azp+tUuIOK6RjTcxQFYzd7FUgpYdQnwTOgQEX02H4DBNoYCfKPyl6A0LRzwgjHdMxGXkoIzII1vyxw3jc54MqahweINWtAxIi2OeidOINvLPFUzw4RwgA+V8yXGxVT45kqcuaVjFUMweAsHiNWBPOyPfp8ONcltq7EuzEyY0PQZNjeLKB+r+K/aLcg3ivDR8ir6P4BUYvEm3y22aK9xuJpsApuIJJW0Br9rJq8Imf+kovrPIccB2bILxuhLRS/SZ8jSn4C2E8IVv2z6kiNvK8WHP6+3vEy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/01/26 12:53 am, Shivank Garg wrote:
> The global variable 'khugepaged_collapse_control' is not used outside of
> mm/khugepaged.c. Make it static to limit its scope.
>
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>  mm/khugepaged.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 1667abae6d8d..fba6aea5bea6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -827,7 +827,7 @@ static void khugepaged_alloc_sleep(void)
>  	remove_wait_queue(&khugepaged_wait, &wait);
>  }
>  
> -struct collapse_control khugepaged_collapse_control = {
> +static struct collapse_control khugepaged_collapse_control = {
>  	.is_khugepaged = true,
>  };
>  

Will it not be better to just remove this variable? In madvise_collapse,
we defined cc as a local variable and set .is_khugepaged = false. The
same can be done in int khugepaged() - define a local variable and set
.is_khugepaged = true.


