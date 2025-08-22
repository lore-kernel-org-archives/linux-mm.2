Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F839CA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 03:46:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 559076B0140; Thu, 21 Aug 2025 23:46:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 530C66B0141; Thu, 21 Aug 2025 23:46:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 446446B0142; Thu, 21 Aug 2025 23:46:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 357686B0140
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 23:46:56 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CFBBAB9AA8
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 03:46:55 +0000 (UTC)
X-FDA: 83803007190.15.673DD04
Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1064EA0004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 03:46:52 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=D+YeRstv;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755834414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+sWNjhBxu8PhYFRc5QOiVV8JYxNP7JQ9csrDkux4Wew=;
	b=Fh/Nb2p8j/FxcK0+wXfNls+GzgeHvMUaM1BCBBb/nXYJdkCQHh28WsIQd8khCFougAUa81
	FAZi4X0owQALn++Vi6ddTvNlBbOLfdb8J2pO5OaUE2Uh1jBKVg+DnpULQ9vInouS97eP2a
	hZJ+JgIAN3emvoOEA93mybg9J6b9yuU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=D+YeRstv;
	spf=pass (imf15.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.99 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755834414; a=rsa-sha256;
	cv=none;
	b=EYsI6LK6OWDo7Jt/oaBBAUx+u2ljyjnaff8jQutIqI+9s5rm7Z7TTq2rQiDmcRihTNqOQV
	1Eu6bRfTyp74akWSb2fM9wq20oqaAYq4oLMtaAksbL6UukR0n7GRJ9gYDL/sQjEvwbH1Ah
	VUm9G56Smu2xTxOogrjt0jfrdQWgAlc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1755834410; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=+sWNjhBxu8PhYFRc5QOiVV8JYxNP7JQ9csrDkux4Wew=;
	b=D+YeRstv3nHWk4oDPdwOPXRphNPCTqGLgorHOvLfoU9ICRoxUlkZEMQLgQTSbF/IfFPhDFqamjw7ySDghtv5v3lc1gIa6M/oeyQ0YQ0uGadD4mRqEz30Bzewv6O1DemQliU5q0iZz6Hc3EPrpjIyzOy6aM3tY6rzbkhgzbaPPfM=
Received: from 30.74.144.125(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WmIBLI8_1755834407 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 22 Aug 2025 11:46:47 +0800
Message-ID: <ad4ccd32-173e-43ef-b00f-afc05035e28e@linux.alibaba.com>
Date: Fri, 22 Aug 2025 11:46:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: remove enforce_sysfs from
 __thp_vma_allowable_orders
To: Usama Arif <usamaarif642@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>, david@redhat.com,
 lorenzo.stoakes@oracle.com, linux-mm@kvack.org
Cc: ziy@nvidia.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 kernel-team@meta.com
References: <20250821150038.2025521-1-usamaarif642@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250821150038.2025521-1-usamaarif642@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 1064EA0004
X-Rspam-User: 
X-Stat-Signature: caweph1xhjn91bz4mgbpzpb345aujqh4
X-Rspamd-Server: rspam09
X-HE-Tag: 1755834412-400528
X-HE-Meta: U2FsdGVkX1/ww+u0HKIA4CEJw4DojOx0hTLRD25zogpN8ZVK4YkNw9YJ8mjDhafqEyuH7x8fx3Q27vulIF9lzdzZfTdlGSbYJMImoVJCo3Wr6vlrTYrXIe6OSB2dT8K+x0R4b+CybOA83UpdymaMT+UAiiL7CE7UHM+CysIZ9YGWyHnzGDHlJjDD8oOx3XFq2a+iZ0vEET0FpeO8U7yLfrstxWI1/UME9qEE9mLIK8N8pppY+H0lbuqWZzZ79QL9XNI+GZSOwTo4115Dh4oCTwD1d617h9h8prKTqAr0IveV+9n4Qczk2/fl2hE8vfMBZpaWn0He6EFTEvtwOx/FKZ2lD+5VdUKONtUq9X6O38qz9D+vNXN0w+kYPXZhCrwbyTbKbJ+ZI1L7h3j7U40aGeuBlx5/wTk2qwPiTQ62iPeE4c9ipwziMWharYHW+YbQGqy3k9JDxCHE8HQ24999RyzH6XuKwvFZIhmNld57/jTopJGpI/wz4Y4IyhJVtSaOkWt20b2zgopPOfPPI7dQeG8uduitHADaX8hHYDBjRkEvr97MEkSN6byIEc7lymiaj3CRVixF5wxadgONhtciqJ5k1Cze7Dwl5G7lDjrECI5kVDT9Qgt6Gu1lMVVnjIwSSIyxhgvSDT1+XYJ47tReuFzOAkbpRhTAJeIlER8WJThgvOmRQw46ROi4Aa1h3sp7OqPcb6qJTfgB5LkNdGcWNqMvX1DYau2yrO5vylmciUUA38Dw86M3pny1wH/jYGLzFAB1aysGTdtyoKxkN0LwAYqDO06CaQB8rDQqkfzjcl3tCuQtkP5jn+LIzLH/FNpsKIjKt/HkxJvpykXaaZJDyADHJJqpkTd54GEE0A0Y5LcbqOrVHctrWfVDPMMVg0OX1BXZOzUNn28hzndr9vAkJAvoi654bpxZXU4UVX/HYh5OM6jt72xypcqHlJjwz2dTXdhTWE00bU8k+t6YRyG
 IJdbi9T6
 1p5W29+L/U2tO37bhvKU7y7GrmXp2ZJL7zHfaXHUfm/XSuHPydol+LOr8hScZzhg0Vs7tcLVoyt02YSs54Ra1GT7eFDudrxA+z3gIF/ZJHmtEfmUQjlHdryBuWcKLPQHKVFrpgIY/69KTd1NypenmY9c7tWuaS4tiWedkf4b0fVwutgGFalsowedS7/GUuLrVnauA74gi8Usq4LH4edJwuImV2YDrIXS0BMH0BLexFBpEeOhEyc1OorogsOOAGVrrczgUi5SQX+MBDwg2jmIRJRKAManNv//CW6tKtFE8mjZZ2eKJNvDBnQkGBgm+IqQYCSB7tNbEDqUAXlU7WBfFSnSo1ejI/JoUy5Me8I7WZ9I6OLTD3JDtc4oxedbV6YU6/qXAasSyQ8g87RQv5/tRZse0EqgDFOYT/3/I9c8GwJcv4Us=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/8/21 23:00, Usama Arif wrote:
> Using forced_collapse directly is clearer and enforce_sysfs is not
> really needed.
> 
> Signed-off-by: Usama Arif <usamaarif642@gmail.com>
> ---

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> This was agreed upon in [1]
> [1] https://lore.kernel.org/all/cd99f0f2-260d-4494-bbf6-99daec3e0683@gmail.com/
> ---
>   mm/huge_memory.c | 7 +++----
>   1 file changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 6fd714bd04844..5220dbc9fcb31 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -105,7 +105,6 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	const bool smaps = type == TVA_SMAPS;
>   	const bool in_pf = type == TVA_PAGEFAULT;
>   	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
> -	const bool enforce_sysfs = !forced_collapse;
>   	unsigned long supported_orders;
>   
>   	/* Check the intersection of requested and supported orders. */
> @@ -168,14 +167,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>   	if (!in_pf && shmem_file(vma->vm_file))
>   		return orders & shmem_allowable_huge_orders(file_inode(vma->vm_file),
>   						   vma, vma->vm_pgoff, 0,
> -						   !enforce_sysfs);
> +						   forced_collapse);
>   
>   	if (!vma_is_anonymous(vma)) {
>   		/*
> -		 * Enforce sysfs THP requirements as necessary. Anonymous vmas
> +		 * Enforce THP collapse requirements as necessary. Anonymous vmas
>   		 * were already handled in thp_vma_allowable_orders().
>   		 */
> -		if (enforce_sysfs &&
> +		if (!forced_collapse &&
>   		    (!hugepage_global_enabled() || (!(vm_flags & VM_HUGEPAGE) &&
>   						    !hugepage_global_always())))
>   			return 0;


