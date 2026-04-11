Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87845F45A12
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 04:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 746186B0089; Sat, 11 Apr 2026 00:00:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F6D26B008A; Sat, 11 Apr 2026 00:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 60CC16B0092; Sat, 11 Apr 2026 00:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 51FE46B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 00:00:44 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E12EE8B953
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:00:43 +0000 (UTC)
X-FDA: 84644923566.08.8EE4604
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id CF5A81C0003
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:00:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhUoAwrU;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775880042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EK+tj6IXoU9NqDFl67wx0QrRHyI4Qa1XXPET3QHX/dM=;
	b=OVj1XE/sTU+v4dYD0DksQaSJlAwSzn/4ayFoLGr5pS5EGO6WjgA9f9RHSgwQGtIl3mZiu9
	1mBsk/p51QBxTzvA17xleWXfO2qLiV7/WTQvN3gwPnL3V1HjCcPXP5gwkcPBIGiUlDbvwp
	r5jejb46cqoyj/jb4WzshxiY980XPmY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PhUoAwrU;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775880042; a=rsa-sha256;
	cv=none;
	b=4OHpxlN+tVCylIz9ekyseenBUX6mNIDPgNEYNfYe44M4p5l/8jxnjc3/vL1cP8x4fgyXAf
	Fsgp+evMP7v1WDft6IYnouUVewBsvAk5v2BbhHIdD1lBniDNllIVVulNCyYVNeMuCUl58s
	ICm793iZfCfSCjktxqGr5T9s9z3gzkI=
Message-ID: <c9444f86-3370-4d2f-bb84-30640e18cdf6@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775880039;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EK+tj6IXoU9NqDFl67wx0QrRHyI4Qa1XXPET3QHX/dM=;
	b=PhUoAwrURUEhd79eWEeMZzWool747Xc7qWTtIKl+xSN5Bl/pwAUlWHqlVwpITIj0GCVDHo
	q9hOt4bOszfYsB03DynzaoHgEADtI6RtkGx7kNtktjRiv+tpBK3e4e16YjbxHQU9C8O/MR
	0GOEhfKRtFmwTiiZJiRKy3fqeJ+W2eI=
Date: Sat, 11 Apr 2026 12:00:31 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v3 06/10] mm: shmem: drop has_transparent_hugepage() usage
Content-Language: en-US
To: luizcap@redhat.com
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, ljs@kernel.org, ziy@nvidia.com,
 Liam.Howlett@oracle.com, npache@redhat.com, dev.jain@arm.com,
 baohua@kernel.org
References: <020a4fe05e8ac52ca47c27b0fbb6a07c163a118f.1775679721.git.luizcap@redhat.com>
 <20260410155949.61736-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260410155949.61736-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CF5A81C0003
X-Stat-Signature: mkj3t4wj5jt73fzx55ehcsq9got7cugr
X-Rspam-User: 
X-HE-Tag: 1775880041-500665
X-HE-Meta: U2FsdGVkX18Ql/5H7OKAfpnDseMiziDBwdnFglhKiV08D6nDFt0d/jzA6RFDKtekCxGVZfL+Kl6ai+HGW1trZzd/2OzIejsbzSB1d2ffxNHixkNoBjKkddagSUrAfn7OU+Bgcvpji7QkZoX5HVwOZ3crCQF0AfTGuzxrNwMk1lV/wHtw6az5j+30V2hpQBgGU9NzxAmorl2rTKc5ZJ1DZY9jxS1rLoi6KT2CbKngHiQDmjVvGR514jqlFQ0e8spO68qLCKloagKwLRoqnZdQ1vNLZybl1LFHwH2yF2rtu0ritxKkyQHHKAzwxdV1/Fwpf/tq3cWmulfjBg0E5AXot+P105Nd9UbrZ91AAt1LTQF89ZHxe2WY/S3Fp8ksGipVejJ7k38xNjyO+DkLLZ4wxcFmf+mpn3Sxjt2yoNsxvGo6yH5OatswI6JIuVX39Gr6eluLbD7uhT1wX92yupMovur+YwdXRPSxjw0D3QTu1DniAiOEGcDQ10l7GeH8gRwKrETw5hYRxnQiUn9vSpcQ4QH1iWffqxf6+EVNPjyVMzkYPGQyTHWoGzXDP6opK1HnvBlTW80rimrprV0Zc1gs6B2atU9CnmjkOPebLv1WAb3pzJZ7dARmiI5iSEIZc2D1cPYwyk0g93enCQWnv5RSE6/xIQFwJQ2flwH7ERdLapr3Zm3XoEOl/HSxZx/ejTSE575mutvH3qJOsP0iTUcdNJGozCvaVT2Cx0Rvhds3NkNqolWnMb4gW2/S+uQavFQXF6mvLHODOnwTAOZqd54ROZ30EMFm5b1OzXCWamT31rSpaOT2zkALE9BSZWliMNzFOwyUhpyzIC5TXHOspOOHZg8AHFEEwvqjZiXUgZaXgnN9QwawWJowZpdsYVp6QwQBk6cHI9JE3gCYYhSFjXuEYFaVpZ59YhuCqxd1JeXibhoDvMpskSktcCbkwWS2uAivEWGgrLTKpbhIW67Pj8l
 7jZVPKRI
 C2CcQLDeyUWgFyDyo8U1ZE4FDn0x4c91/cGuRxIeC8+/2dRRH6+F2qucGe/bDYyYB5+KJ7nuNfGnkZwXen2nwwyILfohKfTgn6NR7lmKpnXWUxAeaAB/Tkr9OfeC3TyNB2Axig7xnic63H8Yq9hVvZaK4dgEdjMfICwVK5VIg7m7ohiwnI4HtUFr/XQtXmVNP0CR2732ToXqNvD+rlQKe3OQfgbNO4YPql+RVhojQfTgIItX7bYnoWlhulDmXDqteNKWNeb+zJT07svOAY+31M7gW8A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/4/10 23:59, Lance Yang wrote:
> 
> On Wed, Apr 08, 2026 at 04:23:01PM -0400, Luiz Capitulino wrote:
>> Shmem uses has_transparent_hugepage() in the following ways:
>>
>> - shmem_parse_one() and shmem_parse_huge(): Check if THP is built-in and
>>   if the CPU supports PMD-sized pages
>>
>> - shmem_init(): Since the CONFIG_TRANSPARENT_HUGEPAGE guard is outside
>>   the code block calling has_transparent_hugepage(), the
>>   has_transparent_hugepage() call is exclusively checking if the CPU
>>   supports PMD-sized pages
>>
>> While it's necessary to check if CONFIG_TRANSPARENT_HUGEPAGE is enabled
>> in all cases, shmem can determine mTHP size support at folio allocation
>> time. Therefore, drop has_transparent_hugepage() usage while keeping the
>> CONFIG_TRANSPARENT_HUGEPAGE checks.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>> mm/shmem.c | 7 +++----
>> 1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/mm/shmem.c b/mm/shmem.c
>> index b40f3cd48961..6f8b20d77e07 100644
>> --- a/mm/shmem.c
>> +++ b/mm/shmem.c
>> @@ -689,7 +689,7 @@ static int shmem_parse_huge(const char *str)
>> 	else
>> 		return -EINVAL;
>>
>> -	if (!has_transparent_hugepage() &&
>> +	if (!IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> 	    huge != SHMEM_HUGE_NEVER && huge != SHMEM_HUGE_DENY)
>> 		return -EINVAL;
>>
>> @@ -4664,8 +4664,7 @@ static int shmem_parse_one(struct fs_context *fc, struct fs_parameter *param)
>> 	case Opt_huge:
>> 		ctx->huge = result.uint_32;
>> 		if (ctx->huge != SHMEM_HUGE_NEVER &&
>> -		    !(IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>> -		      has_transparent_hugepage()))
>> +		    !IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE))
>> 			goto unsupported_parameter;
>> 		ctx->seen |= SHMEM_SEEN_HUGE;
>> 		break;
>> @@ -5451,7 +5450,7 @@ void __init shmem_init(void)
>> #endif
>>
>> #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -	if (has_transparent_hugepage() && shmem_huge > SHMEM_HUGE_DENY)
>> +	if (shmem_huge > SHMEM_HUGE_DENY)
>> 		SHMEM_SB(shm_mnt->mnt_sb)->huge = shmem_huge;
>> 	else
>> 		shmem_huge = SHMEM_HUGE_NEVER; /* just in case it was patched */
>> -- 
> 
> Although this patch simply drops the early has_transparent_hugepage()
> checks from the shmem parse/init paths, shmem_allowable_huge_orders()
> still returns 0 when thp_disabled_by_hw() is set.
> 
> So on hardware without PMD THP support:
> 
> unsigned long shmem_allowable_huge_orders(struct inode *inode,
> 				struct vm_area_struct *vma, pgoff_t index,
> 				loff_t write_end, bool shmem_huge_force)
> {
> ...
> 	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> 		return 0;
> ...
> }
> 
> 1) the fault path still falls back to order-0 allocation
> 2) do_set_pmd() still falls back
> 3) khugepaged won't collapse it either

Forgot to add:

4) the buffered write path also falls back for tmpfs mounts

> 
> Nothing jumped out at me, thanks!
> 
> Reviewed-by: Lance Yang <lance.yang@linux.dev>


