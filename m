Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EBB62C44500
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 07:04:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F4E86B00F9; Thu, 22 Jan 2026 02:04:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4C27A6B00FB; Thu, 22 Jan 2026 02:04:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F8FE6B00FC; Thu, 22 Jan 2026 02:04:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E4046B00F9
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 02:04:43 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BC844B60D2
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:04:42 +0000 (UTC)
X-FDA: 84358712004.29.6A3FEFD
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9623340005
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 07:04:40 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769065481;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l547LiaHnoZQ5msdl2AnV2grmSoGsZE6DFRLGBSl0wc=;
	b=wM9/I3QwxrfSWcyCKWoTPnozKIhJflxK+vqqrFOLSK4U1YuEzVqgKXu2hPogWXDbzLbEF+
	B+vDHjLbSXETorz6W/omlRAV04f/qx7HhEVXuFoRsy03yq/kIC81lY0eqCjtqk6xGWRvNw
	htIR+NtQUIw1Mw7KdaRi4YZ/cj228bU=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769065481; a=rsa-sha256;
	cv=none;
	b=J3QsOSyH3IaUIQuvQJyMtse1WKaIxEyehx2A/TawBVE/sJcRllDwZaTVhm46bVXTher0if
	qGcD4HFNUMgQCj+FlARKYl7NvkcGR9gc/f07YTQ3Shwda5ZgBWeVYC5W5MoQ6rMghqb3nI
	WsYySv6xuKYWUJLvPYtIYPOmKFaribQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DC5A61476;
	Wed, 21 Jan 2026 23:04:32 -0800 (PST)
Received: from [10.164.18.63] (MacBook-Pro.blr.arm.com [10.164.18.63])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F1B633F632;
	Wed, 21 Jan 2026 23:04:35 -0800 (PST)
Message-ID: <225e9943-4e7d-48c6-83b9-98284fa31092@arm.com>
Date: Thu, 22 Jan 2026 12:34:33 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH V3 1/5] mm/khugepaged: remove unnecessary goto 'skip'
 label
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260118192253.9263-4-shivankg@amd.com>
 <20260118192253.9263-6-shivankg@amd.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260118192253.9263-6-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9623340005
X-Rspamd-Server: rspam07
X-Stat-Signature: dzgb8ywystb99ibokmx118hpd655jkyb
X-HE-Tag: 1769065480-283045
X-HE-Meta: U2FsdGVkX1/vqKP7qE3DB396cumQ3HoVM0HsJXruuVBGfLOwDcEgI1N4c68VEKtU5jIVbP6tKKLdgVMOilWIYhZ7Jo59e3zZwVdAZa4OrLn3o5D8QdJq32yX5jBoGGnw6+nO1ztGIXf6Vv1QDKo9nLBLWJVZ50rPyWbD/fqfY4nhh13Q2eKH6Arh/fOLkY1B3CCvqFQLvKN+FtLmtrY5/almPzOu6C3ybjakjRvQ3JKkZu/IVUnMCI0MQPpdxkeulFEj2UczE0+b/Ng910Z2o2oPcztHEkLGE/Z7QR54B4kLGVxqnBXG/eDed48im61RhyIhbruDVS1spxrSLHBfmWUHWJeUkWPkC97CX5iX3gq4r4XvqO1cO7n8Lp7w/4TBavr3VOjO3Cr4mOljZvWBOnH5JK1PFkp9EU3aREyL2tXfM8PueGtmv1N6YUB5H3uOdgUpmOqn6ECtWlf39riKh2E989sEWj+Q43CDMDoCw/HaEVO0r9O9uZ11966plIS446JqerieYgVPtZ+SlA6Yx6qK7jhqNiCY9f5dQPowBHyf8oCcdG9wKkME0l+ZIgj1lT42dmtlhWDkMzxI0+Or5yH8joIPp6QaEHEgNaBIWw+fQl+zC52JqaRcJ8K0fY9uGwcakzD7PDy5OfMWd2OkbiL8tOAEUYcmBL7BpmlxsMrRDaQsiGU5vV6ge47Viycv3li5NW+NnZ5p8YxZaDv8f9GW93yf75E1+s0Razx6Af3v/BwFH4by8piasdtqrBxZbz1brzieJhtRCMxsA5oY21r30jLldCUSyErLHpUIQ7dLwHVuT9j3spdRKWjPxNOLP2CtOV9iPpgZfWg+4MvhpW471ADp+kcxFaT01/6VxBk2XgDBHXM0pb03okuefuoU0JrRVFMpQhOIxdkYUz0ea1zlI2NF2iBJFt+PWY3S0c+O2X5Ea5irypjB3k5Oczbv7M85QQnMUMQNwXJ3Wop
 0yM67GE3
 Ki4LF12Q+j8HnyaT7BbBbC/mZuECiXvzLUCaIGidAz+up6hW38rfuCNa/YX/DgSeFnajte6KlIXReTCDsRlIs4eTR3HMyflLhvS8XmlL8fvgFOWZgGZC0v+8NNNVin0d2oWH4kq7DWrxvUglnC2qGT7MmCkh/bVD1I7z8MERNP9RwK+1ouhVegfV88DL6/H+jCnkaEsetyu7LqVr8tJAm35s2AukXi22yBV7QdPxIFVMeKjhFuFUc1nviciLw9H5Wn3SNCk8GIYWxDEpzEavKzzGJZZCAwa8EnhFIZHaUMbighx0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 19/01/26 12:52 am, Shivank Garg wrote:
> Replace goto skip with actual logic for better code readability.
>
> No functional change.
>
> Reviewed-by: Liam R. Howlett <Liam.Howlett@oracle.com>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Signed-off-by: Shivank Garg <shivankg@amd.com>

LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>

> ---
>  mm/khugepaged.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 16582bdcb6ff..984294a16861 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>  			break;
>  		}
>  		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> -skip:
>  			progress++;
>  			continue;
>  		}
>  		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>  		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
> -		if (khugepaged_scan.address > hend)
> -			goto skip;
> +		if (khugepaged_scan.address > hend) {
> +			progress++;
> +			continue;
> +		}
>  		if (khugepaged_scan.address < hstart)
>  			khugepaged_scan.address = hstart;
>  		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);

