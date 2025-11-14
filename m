Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06C83CD4F49
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 04:37:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 146578E0005; Thu, 13 Nov 2025 23:37:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F72C8E0002; Thu, 13 Nov 2025 23:37:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00C7B8E0005; Thu, 13 Nov 2025 23:37:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E0AD28E0002
	for <linux-mm@kvack.org>; Thu, 13 Nov 2025 23:37:42 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 887FD87704
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:37:42 +0000 (UTC)
X-FDA: 84107954364.06.E58FDC1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D10212000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 04:37:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763095060;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lIDs2V/QQ3l52abqYbeogadc6hSYp+ftV1zJ8fAMj7Q=;
	b=klP58sdwXe2qsU5Qr/1O2UURdJUGdXwcsFIQTWsWOed46TagcqTmfUhfXvFvYy7qVDSNhG
	6s8sD2kyAc2waMEH2LHhZ02/bKY+1wr92v7yDHIA5dBEiJg0Im+qB+cT6D7MMN3oXNIsW8
	fDDM7j1jqq3BAoK8VY0bxeP87Ac8daE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	spf=pass (imf29.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763095060; a=rsa-sha256;
	cv=none;
	b=xYnVdZqvBE6GNZO+DV3HPbKV5N1xqC7yXl88PmatYWFUxpKiEa7OUeO9EOBOyqCUYEioQv
	zKwtGbUq/HXwswd1cCktm24LFk8xDF3Zr7YoDuF9RKwRQ8Y5pNKpwKo9ilSf7Ot1763r/t
	jK/fonGCqggdoiPfNjIdCuIz1HDaswQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CF838106F;
	Thu, 13 Nov 2025 20:37:31 -0800 (PST)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 825873F63F;
	Thu, 13 Nov 2025 20:37:35 -0800 (PST)
Message-ID: <7eb23e67-e8a2-4f58-9a2b-8e78eb9a3d3f@arm.com>
Date: Fri, 14 Nov 2025 10:07:32 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Patch v2 1/3] mm/khugepaged: remove redundant clearing of struct
 collapse_control
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@kernel.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com
Cc: linux-mm@kvack.org
References: <20251114030028.7035-1-richard.weiyang@gmail.com>
 <20251114030028.7035-2-richard.weiyang@gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251114030028.7035-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8D10212000A
X-Stat-Signature: ph5fc8uzx3ciub8tdupykywuccuy6nzn
X-Rspam-User: 
X-HE-Tag: 1763095060-996690
X-HE-Meta: U2FsdGVkX1+HX95buULn2vpGOmeTdhtWnjzOgNZ+5nRdg90fTfswu+9mX+gp/TJrLDHmVraICbBI9j/cdw8QIR6XvO/atgf8L4f3uXfaw8uUBfJBDeDO8IFaXI9WP9Z9xxElOvSTVOoKWhTHpWboNJ36I3fqmxNWmxJZf5eecvgqcJWkSv1FB0WjGpcpH1AChv1tUTJ01kJm3csdrrlRTUd180AIgb7QGfsQOZOK2aeMcthWlZv6GCwbKDKxpnIqMIR40jKuOPeW0rXCu08Qv1jvKtnHFdQVfa/wEan8FGBCJ3oUCx6gOi+uVW8TkUWBwJw53C9KWoNy6itVIF1UpD5fCJwQwXx/3/KGXDqRCwvF2QXwidZUcGZadTvNdZG9hGidHc8SN4xmzcrnh1dPb6ycp4LhLVSqsI/3hCpBwDDr+C/1ifVgbTBlz/MFhQVtyQeZIsGBSVGssrdaihuHaq0CjRXkxwgBNKGENsrA4UP6gqbj3HlCPBj7OEUPOu3W9Ovziq6yxa3maAAx4nFdHcgFyfFif7GpefyggXC0m9s7BKwvi/8Qozy8Fl9MAa6QfkbYcdd/ls/PJQ8lBGP5iHzaO0A6Q3gvDGVpjrLn+YeJknpN/g5PafR7kKzGyuDV6bkmrHAsdqzuyq9WiE+e+jc943Lk11yT7Wy39z89tbF7+bqcE4vkgERuq8qwygLdNlkkDPRPTlNLhwOD/1w/by+OrLzKIk0RIAi+8heGMOzAJf4nCD4+QvcgMgjHINJiyTqvw0b5Re/SCbVazthtLixkxSwsEr6EKnz/n22B1NKBR6kwatnV2MPBFolyvdqIP6kWAlWL5aW6kj3HKnFk2Ea2vuhh+64NDP7eOR75OL42qtoB3pCC0X7CUCe73xTI6BJiTZmCKC594ktX0p/3COggqTsaOnxxJW6SpLbnHS+t5VjYbMk9D0WOrDqg7Zt9XGK35Z+3tQnqVBAM6DA
 roItMOTB
 RNqzmNytaojYT5D8p3sHy899Tzlvy0OyB/B0jDdXFPRTu/DhUid+wuAyL6InVHEYrzo9h6qNAVPe4U2LwuAR/aSY1EJ5izlLjCWr1ooLT2VDTMxpItKUvlm3Jfu96KcMqEcHyoLuLdBKh7GIncPIfTNrkm+Q1rUjeR2yn1bsAe54zpWmq+VnL+DZppBPPd4pClvTZ7c7RYl4iKbYzmguL5nKxi1j5ilw2eTPuH8g6UC57GLvlq3ODwmHVvkbdug+rqvEysbEbe1nRjx1523TwCic589k2qFUDJllWA03R9uhnQyLRhZd9mCcN42PT9GhkRJPdExa87Vm0/+Lg/gRx559faw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 14/11/25 8:30 am, Wei Yang wrote:
> The structure struct collapse_control is being unnecessarily cleared
> twice during the huge page collapse process.
>
> Both hpage_collapse_scan_file() and hpage_collapse_scan_pmd() currently
> perform a clear operation on this structure.
>
> Remove the redundant clear operation.
>
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> ---
>   mm/khugepaged.c | 2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7e8cb181d5bd..1fc8986a28b3 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2803,8 +2803,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   			hend = min(hend, vma->vm_end & HPAGE_PMD_MASK);
>   		}
>   		mmap_assert_locked(mm);
> -		memset(cc->node_load, 0, sizeof(cc->node_load));
> -		nodes_clear(cc->alloc_nmask);
>   		if (!vma_is_anonymous(vma)) {
>   			struct file *file = get_file(vma->vm_file);
>   			pgoff_t pgoff = linear_page_index(vma, addr);

Reviewed-by: Dev Jain <dev.jain@arm.com>


