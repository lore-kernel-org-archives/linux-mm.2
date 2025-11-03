Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A89ACCFA03
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 16:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 786708E00A3; Mon,  3 Nov 2025 11:20:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7375D8E0057; Mon,  3 Nov 2025 11:20:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 674488E00A3; Mon,  3 Nov 2025 11:20:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 599788E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 11:20:11 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D84A2C024B
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:20:10 +0000 (UTC)
X-FDA: 84069807780.26.608A7FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D440C0003
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 16:20:08 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KFtuqkuI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762186809; a=rsa-sha256;
	cv=none;
	b=K0CCSyEH2VvO2mhLPQaZbiPW8BdkkrpQlCy3wazjm3VsMFyhcD+tFtv2QVOFWmmDDhvvTq
	7xuyTvR8o98IcADjQAC+RGcwlntQ+Jkne4pQOvxGsQcOw5lUYQ3YBtlJtC2WO5os0eEMtM
	ZokYgiq3CKjkoo/Ct0tQQh3oT0dQYsQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KFtuqkuI;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762186809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ER219UrfPxkRJvTBMeBD6z1LgSqWuUSf+l32c5Uzaeg=;
	b=p/GrFCYe3KArx6PjBuekdOGZujtLEF11J8wXK0Mmpnwx8sI/t6kZQijSsnY5VWzMCVE8MW
	dbOKO+jonFIVmZF5P+X03jMRQU8aDSVawLwhnnkH2Y+byNJDsm1QNXrCtL1gG00crx8FUY
	1ZZDbvWvuRqVMqY3u2duGpUGvrCD7sQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 185EF43C3D;
	Mon,  3 Nov 2025 16:20:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38C16C4CEFD;
	Mon,  3 Nov 2025 16:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762186808;
	bh=Hezw5acmWrE3XMal/Pc0NEaf9QX4LTCJHGhfQ7AcZes=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KFtuqkuISv+qmh8eNFgrfpZTMKvkAPLUb5xmMw0YccraXaWuhJa5ACzEsK+guRh+q
	 vfEvFoOc2Y9ZwklDyD0DLCgMmHeyRDd44/prkRXitcrlmr6ZLXrGhbQnr5ZgpameMm
	 5FUUWOtpX+P+XAiaU00SrTDuLMt0lii6JwSZhJacDNKo0r7Z0L9nT4I6EhQ0/x0Ykg
	 5kJA8pMoRIUXP8zGCxssRt4fhblNTlXm/mSU2XDfPGPNmaU4iCna6gaDKuXWpagZSm
	 FxyBQphG61EBI185eFyMWftyujX/Psct4ftc07GvKo6I0hzaCjcID2b7fmBUKQNO+9
	 /yKDgEhDBlg6w==
Message-ID: <b2a1ef9a-9822-49c8-85e6-43b19bc8bdd7@kernel.org>
Date: Mon, 3 Nov 2025 17:20:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/huge_memory: introduce
 __split_folio_and_update_stats() to consolidate split task
To: Wei Yang <richard.weiyang@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ziy@nvidia.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 lance.yang@linux.dev
Cc: linux-mm@kvack.org
References: <20251101002927.2610-1-richard.weiyang@gmail.com>
 <20251101002927.2610-2-richard.weiyang@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251101002927.2610-2-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1D440C0003
X-Stat-Signature: e8gj1mjn6x54jdbe4uwshnbthe1fxp6y
X-HE-Tag: 1762186808-689898
X-HE-Meta: U2FsdGVkX18SckptB0/mgB5BTYJTiZIS7QNTPBffbzOkFoaU1mllRlS3SpyfPjRSeNKt3ZcSt+/UyvNyRdvuJSgV0yN4rk+nkDdJ6QROF3iPxXtLKw7dNp7aPYrT8CGUQkrvepq7dyYBwZW6MQLoboN6yq8nFcOU2YgBw7ddw7YymTxTjc5DB6jzYCdOtHz1opugCxIP4Y9mQNVzEPcC8lLsNPxXSdof1Wfl3yQcUJCFs0jVe/1wO7eHO5K4WZ11n4gwU55xxK4B+Yj1uMN8JG+cKyTtiEaFTTAJBm9f/DAX0gxq4v0PHaJ90bLvN3kckBc6f/DId9HQRmbv6Nvpg4qn+cEAQor8o03d8OVKr2hacfutsxXyfTfUmovrlhgr30iFLQAAOGJviD8Vav8tF6UKCPFTztxKE6AJBrU3wAJ7GZ9MfS+PlFLX0LJW7hxTzB6GpG+2ZQLAdwVAMbuaq9TMDLFhTUB4WZR0eZ6ZQYEl0shM9jO2u0+TFOZGFHMmRhAuZ+uyavUGPRbQ2jMrHYY618Q2S1xY27rTGa6m10na4SHiHIH2/5d8Mmhj7ov8xZnk7f9SA2RExJG6hapTeX6mCs5vwtb/t7eT8KJipLw/RezY3sE43wsCQINA5s/6hlTyVYXMGfoLg9J0+lTTLoTz5iyY7qPETyVic5bB9akiwx3yUz3a+1TboQBIp0WYIUhqLe0sRIAiu6fKZmjtlXGM76P5knSH93dz+O3k3jZE1Q/dt3UISDLYHioi5z6v89xaHwNyUYkMvYHEk+4GdCpLbGSlKnMsNi6NXmduWo0+WkqR0l6pkBaKMSYoq7gMnxL/LXPFsmWOYX6YegWlrk3XR/rt+rfOEITbXww5mO09FJyQfXdj02DKvYufC9kvQ5wtkGof9ZP5PYzL3+UocPjC9jNXji4Jj7l4dENiQpNgoHjhK/6Yqz1xG77/NoedFoCcL3+X5i4NLLJ3/nU
 pSs1ic8b
 2kbXEv1Dmp/XxCHNQMAlFphUOU8A+UJnoG6HGJFez+QnfrBG3tGjayu2m58Cr0PlbM01l2TmwVLsuOOh2zYl6oFlVAkgz03oBkhK//5PyiV4pCDQ5szMszXzKZF6E2hWXCWKX2Iztc+wqqqpw4N8T4k7kHBxis+qDNnXeavOjHpsAgp10DT5NAWZ0fdeM2Aiuq58Fq5Zprs08fkCKUEU2/bJPPc2ANWHeylQ5Wgjh+Dt7dFc6J+b1XjQrD33ek9rBSHhyvgr7gj4SbdARWcdOLJQ/U54w9C0y/usDBKxlJUVxcdbW7eLrvD12YwHuHoCw3FyjoszdmdCBVqzzu0wQnq9hwdhwIqZwqLmXJ63vrR259P951pGNIw2qgB+NNM4JDmH7N7CanO6J3TKxM1HeXRYgcBQqZq8B56qAu/La/BgMgE+nxECvl/fbr35CndUaJ0FX
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 01.11.25 01:29, Wei Yang wrote:
> The folio splitting process involves several related tasks that are
> executed together:
> 
>      Adjusting memcg (memory control group) accounting.
>      Updating page owner tracking.
>      Splitting the folio to the target size (new_order).
>      Updating necessary folio statistics.
> 
> This commit introduces the new helper function,
> __split_folio_and_update_stats(), to gather all these tasks. This
> consolidation improves modularity and is a necessary preparation step
> for further cleanup and simplification of the surrounding folio
> splitting logic.
> 
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Cc: Zi Yan <ziy@nvidia.com>
> ---
>   mm/huge_memory.c | 28 +++++++++++++++++-----------
>   1 file changed, 17 insertions(+), 11 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c37fe6ad0c96..abde0f1aa8ff 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -3567,6 +3567,22 @@ static void __split_folio_to_order(struct folio *folio, int old_order,
>   		ClearPageCompound(&folio->page);
>   }
>   
> +static void __split_folio_and_update_stats(struct folio *folio, int old_order,
> +		int new_order, bool is_anon)

Is there any good reason we want to pass things like "is_anon" instead 
of just querying it in that helper?


> +{
> +	int nr_new_folios = 1UL << (old_order - new_order);

Could be const.


-- 
Cheers

David

