Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DADD0D6ACD4
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:14:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108546B0088; Thu, 18 Dec 2025 04:14:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BF7F6B0089; Thu, 18 Dec 2025 04:14:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2E3D6B008A; Thu, 18 Dec 2025 04:14:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E31CC6B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:14:19 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 506DE13C2EF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:14:19 +0000 (UTC)
X-FDA: 84232030638.29.279F0E8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8CFE814000E
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:14:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LM7l213Y;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766049257; a=rsa-sha256;
	cv=none;
	b=OnXgiHFZB2RcN22A7+boS8thmN3FcQy7lIHsH2ruCpMi+w5j62iHIRqpQ/+6XLtRMj8li6
	RIY5mihv/zyGADCytR7O3uaI8vuIxBgC5Ek25Kbr9gQzEGxQu4uTJfGsL3nH/isP6HlwcV
	M6GFEFIClYR04bdR+dNssrHnROeO3a4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LM7l213Y;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766049257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8oY7Q7m1bMppWgyEUZIUIq8rg0VYjCukiR6HF71ifqk=;
	b=Ws1Udpd1JMzuNZARKLRpVBgDFJQHyN0aafpwtaocGvzH8JFtDhU2VQ2rgIZpqfZOJ7goxM
	AKDjreuXVAuCGVIWpX5vHucaF3Wc8fiOfTnkoFzDWSRkWlScnIxy4IokSgQnizZr2b0lYI
	EVcrJIOIy5kKrh5N3UlVCY57o8CHRNI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F018960010;
	Thu, 18 Dec 2025 09:14:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90127C4CEFB;
	Thu, 18 Dec 2025 09:14:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766049256;
	bh=RbU7bkp5JA3adLxntFDCx5PqRnEWhiZPV2jX0v9jyt0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LM7l213YCC8qIHUjwHr4WGqsrFGr8FlEg3VWbQJ6h50XdTzP3Soge9oWQGxnrKQk6
	 5iYKwDaWIaYJjSVFvnbY2OrPBvrGSXsh6y8rJtmBElg3zIXvFVy3IpGFdMkPwVFAT+
	 H9CuL+RX7FEEKyKU6JkonHxQNGLIlZoCAaoEigfY1tZhB7dOxf7eds4RuN7bxLS2bA
	 sOi4XzZTrhQ3oVz/LrodLv+n/Oggi1c2vV2ABPmbBUcftzgcVCSxDxk5f+14MXFPh1
	 X6xOOGz76nWZVjztYBw1hld2YUSMO89OIjyRZrk15ERys6Mhqi4qZ3+b4hGYTVBvkA
	 cMZMr3YwjrVAA==
Message-ID: <5d0b97e3-c617-4650-8f24-f67538418012@kernel.org>
Date: Thu, 18 Dec 2025 10:14:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/khugepaged: remove unnecessary goto 'skip' label
To: Shivank Garg <shivankg@amd.com>, Andrew Morton
 <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
References: <20251216111139.95438-2-shivankg@amd.com>
 <20251216111139.95438-4-shivankg@amd.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251216111139.95438-4-shivankg@amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CFE814000E
X-Rspamd-Server: rspam04
X-Stat-Signature: e1e5asizbnz4h1gduo9daxrc7zr9i3o9
X-HE-Tag: 1766049257-908146
X-HE-Meta: U2FsdGVkX18o8Lq0MDwgDl+YfbBrZYGeGeLnjdofHkGaII5IDBudLBBgQkuGPQECILgyQKLIliy/THuWb1DLEhL+UDM8ntJ2wWHbwDkobC1JB1Hv26Pf67z0LBTTf6kewdnkRuOJclvqLyEHsawXBLgrAvVGsWJEwYzlawy6B2dUHodszBs8Rz/P+q6aov0mOjRIMRA0ix/QB3av8kp3S+gvQuWRRGj+BH3TF8J8jcRgysYrIoI/MjOU8FfX/hDfy4qiayug5HeWL49Z4XArU7GKZyOdZfWXsAW6c3QTT9fbrrQdpgFhkQE+lJQ0Ixldfbbu9W2Yni/ebqO9DSTRyiJnMIz8sUjC08Bxect6+9fTo+7yiDi3Vxq9slW6HuErX9g+uiWVGeVz/q9g6rJJAUxV9aeqSkSSjkFxejbxKXV0YbhVVgph5/JPyftxIZ3QmHyLcKhiaoDMuRqPDsOhZi68el32GX0UB5qhNY4l4+IUSo/9zSsG47GFlGCzzuuWTwxhQR1nUMjO73CtwodcMSfHdAIsuLkMbeqHeTET4CuXJ15plaWoJapKeypkwW5QBO4ltUQBxUhftXbrWJa8VIt5YvX4so4eK3iNjvhW0D99AzXbuNfH0mSS8RLWBcCb1rm8c3BauGNx2+jjmSnIPjxpGdx9PQkweUCMsiuMz6fpNY4DCYSoSYJzJlCra1pAiNyS2rM4Y+hqcj+jSORqPca12XhbxgCfGGmIazc1CZMaRMp8YiHdMWqOnZ8rRTJH/6pzVRPvwP9abdHexMhvrUC0k5BnfXsMRFS0Ftfe63O+eBhlkXWsrVh3vxhRqnC6kc2XY+OcVPROyfdHiDEVXXbQB1hLZV6/rdNVYAWk2FrOgLvP+iYSylSaFcIeTotX+ZoAIwfXTXL9OxC52yPnsOn9hRSDrRVSyzUBbJcbcpttTSiwDlFmWlWKxQRIj4RENJ2Q3PHX9ZT1fWK1VuI
 f9Gukazk
 Hxq7vZ2IQdukf5tzw6pysbtpbkooikcbs1jsnYBnzAvEXVVbWkjeYWnh9Yxy+LgbHEm6l6Q5WyqT0W0c2B9ecQoQPr02XkOZPtwOp4bG79ro2nKc4JgvrDnoTnC68oIzxRPbPitdzHbxh0N/QJu/2OEk//Eh9tedgcAaQRDmSt9ih5xahKeomTh6UvvI61W8IuQRDZoZxmlwu5Pbyv247jZ4RVpk+de0isum5fzf1azpkq6lwmrpWGxg6ciikJQz1GRabZx6pyNYpxdpFnJW5KJ6/FeGejpnuggp+nwKqPdjHhU4+6hMMMDlORw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 12:11, Shivank Garg wrote:
> Replace 'goto skip' with actual logic for better code readability.
> 
> No functional change.
> 
> Signed-off-by: Shivank Garg <shivankg@amd.com>
> ---
>   mm/khugepaged.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 6c8c35d3e0c9..107146f012b1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2442,14 +2442,15 @@ static unsigned int khugepaged_scan_mm_slot(unsigned int pages, int *result,
>   			break;
>   		}
>   		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> -skip:
>   			progress++;
>   			continue;
>   		}
>   		hstart = round_up(vma->vm_start, HPAGE_PMD_SIZE);
>   		hend = round_down(vma->vm_end, HPAGE_PMD_SIZE);
> -		if (khugepaged_scan.address > hend)
> -			goto skip;
> +		if (khugepaged_scan.address > hend) {
> +			progress++;
> +			continue;
> +		}
>   		if (khugepaged_scan.address < hstart)
>   			khugepaged_scan.address = hstart;
>   		VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);

Oh yes, please

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

