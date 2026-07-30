Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5E4A9C54FCD
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 02:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29F726B008C; Wed, 29 Jul 2026 22:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229466B0092; Wed, 29 Jul 2026 22:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118966B0093; Wed, 29 Jul 2026 22:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id CEA126B008C
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 22:02:50 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2F3C0120859
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:02:50 +0000 (UTC)
X-FDA: 85043794500.05.CCE3463
Received: from out30-98.freemail.mail.aliyun.com (out30-98.freemail.mail.aliyun.com [115.124.30.98])
	by imf23.hostedemail.com (Postfix) with ESMTP id BA0D314000B
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 02:02:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DktpZOYk;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785376968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/IZvBfcFjPVhZmo5POZlSlll5l1dfa6LjVvoLhlsFcQ=;
	b=YhWunQk2N/nstG1vgLaWLXt8goLCZCYspitslsZRSxlFfNTMeOfznvGmgCDQNUc0hUw1hU
	wNtfTDDbcDIXnrNSzPMIk2iMD2suZ5ZuyWi6ok+NPxkmNHpVXdDixRmOxhu7T0v0JbHDIg
	rm81fY/g6xVfkL9QgXrsCXIfz2AGjbY=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=DktpZOYk;
	spf=pass (imf23.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.98 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785376968;
	b=KqpQejiRxeh+ONaAaZjD+JEeNHAWGAPN3djCLeYNUFsqQgNTkHu6uzsl4L/OcTA2XpV1Gs
	5lkw5gYiR4Gm1gaqcV6nmt2TJYSoARO09PGqFTrcApzYs8O8Xw4eY9XxeTr/UNMfFF/Sty
	s/Ea+tGU3CadVtk54h4EPAUHyU3G9xE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785376964; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=/IZvBfcFjPVhZmo5POZlSlll5l1dfa6LjVvoLhlsFcQ=;
	b=DktpZOYko/8Ut2JTgiJMCCa2YT3NXbXn1fAuIl1Or9IURA+KwIBPZI5uBHLGrx9zrRezvIPJzAwQyZHnDJqT8ad7Bxf5cFQ1SlUR7uA1BTbQ3nlNiJR1NalcgHsKPTgwAqzUG5XlQXt2hMDxr1ZJjN5U+rPstLrDluQ1k7yBFy0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R601e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X83S3tb_1785376962;
Received: from 30.74.144.124(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X83S3tb_1785376962 cluster:ay36)
          by smtp.aliyun-inc.com;
          Thu, 30 Jul 2026 10:02:42 +0800
Message-ID: <21cc294a-9bff-4ae1-8f7a-f51b91579dcd@linux.alibaba.com>
Date: Thu, 30 Jul 2026 10:02:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/1] mm: shmem: reject page-aligned fallocate end
 overflow
To: Zhiling Zou <zhilinz@nebusec.ai>, linux-mm@kvack.org
Cc: hughd@google.com, akpm@linux-foundation.org, vega@nebusec.ai
References: <87a63846fe9873b1e26e8a7dcafcb21aa8d709fa.1785309651.git.zhilinz@nebusec.ai>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <87a63846fe9873b1e26e8a7dcafcb21aa8d709fa.1785309651.git.zhilinz@nebusec.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: BA0D314000B
X-Stat-Signature: a9rhwbiqh84eknqfc96w6e7xo45o6ud6
X-HE-Tag: 1785376966-124163
X-HE-Meta: U2FsdGVkX18sMg3n0sbUiG8MiZCMSvPszOnrWy601rFDNJNPAjIgcWNCtZWVk6gQoP27K1wC+xUQrKBgGxjFpHsEczkF+OQg3qwgu/IvQu1M+APq5Oow7nhAD4uurdx1zQrkniW9nWgok9Wii3xwXKyqSHicFQOkoXUxfKYf0qjK8/HXKQUQzQnEjdTjp5L3rhx1/gC3KeWqNeyMwGtoKSPm67ZxuuoIYVV6fX+mPwOfZoZDH8TEgfI9YRKIWVH9dxc3YEE1LrOjbBXJKg4cN87SIU813Hhm+7X8xEhVQ9IPE9051S2emMPtvlHsCbHPuxtsej546tgqWGusfrVtef618Y9t7n81YYmPkBBbelmo3GJ+gwl23bOpz6exsY/MPzIfsK05MxgCHc2q+F9ho/CyIRilPHw6wfOPcOsQCuMlrvBIm6MseKcQ9mkHCbHpgo1w13BmjYBs+DFRT+m1k6vxgL4Q8yuuf2lc5DtRATMcZf3TRfIW1Xa5Wt/gBRJ3A+9FMtk2U0i0BGMhheebq/CVJYicaTQlnQXJqJscdiHnm9IZ6n7iXNySpDG1+RxMNgKUNIz/As2l8hnc4O9pLdM758RTA6yrp9AEQlpkSXGfqXzNx+hF0KtbSSUK3ERBCiI4ossbX054y3nudLcOOvQ8Ir8Vn0jA2rvRsGAbFKbCl7UV3kn/CCCEdczTb2QnFCbB9nMxt7FoVqdlC6eZ0CQe4bifRadjnlFFE36AaGh6SZOSHGS6EOCcNusFvAiF6+V96kPCZit0ui2YusRfIyrJ/10dpxwIV26qYe4EVk6n3/IJ1Pu2YPciQ/NABMcPAJIxFa318Ke3hGpHp4ODGmdluAvPZ25a9CJrjzZJK3WYFAFzc12o+5LdBof7dvCks/+KXkGd0T0mrVaWeddgcD743A8QouUr6GrHdUvORKdKgSNLx7xO4hYManfgpnpeSJq7YuarsrQh4APf/OM
 vHI154PF
 zCyOlpmXRaxO4QhiwXGpAGh19vb35UroU5v+ibzmSi2c3z6JDb4QUlHb4HyHcnju+tXqoIwXnQd6BNHd6ZUiGbEJs8mgXJl8YQYS/R822/TTLY5ZWNT/2UKddxf526uo8ZFujzoWfnzQKq1eSfqODtYbxVnDdzw750ztKxnyv7UH2hpTexAYEMqQIeWulNy4KAWO+rA0GNLapEYuB8WX+iF+WxJdsqjkwvG0co+qw7/mXObu2HmTJqxAjZ4jBhC/PQ7jpzPm3qsGSSVH1GYqUB4jtuV0Os33Cw1WMxR4sdKSnLZUhkRz8qXs7X8UVpyeifA69CbraDHP9kiXPE6aZxZoYzw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/29/26 10:07 PM, Zhiling Zou wrote:
> shmem_fallocate() validates offset + len with inode_newsize_ok(), but
> then rounds that end offset up to a page boundary before entering the
> preallocation loop.
> 
> For a valid request ending at MAX_LFS_FILESIZE, such as offset = 0 and
> len = LLONG_MAX, adding PAGE_SIZE - 1 to the validated end can overflow
> the signed loff_t used for the rounded end calculation. If that wrapped
> value is then converted into a page index, shmem_fallocate() can enter
> the folio allocation loop with an invalid range.
> 
> Cache the already validated end position, use check_add_overflow() when
> rounding it up to a page-aligned byte offset, and reuse the cached end
> for the later seal, shmem_get_folio(), and i_size checks.
> 
> Fixes: e2d12e22c59c ("tmpfs: support fallocate preallocation")
> Cc: stable@vger.kernel.org

I don't think this needs CC stable, since this is not a common case. We 
never hit this issue in products

> Reported-by: Vega <vega@nebusec.ai>
> Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
> ---
> changes in v2:
> - drop the RAM/swap-based range rejection
> - drop the NORESERVE full-range accounting probe
> - use check_add_overflow() on a signed loff_t rounded end
> - v1 Link: https://lore.kernel.org/all/adcf644e780706c220809b7a41e6e496d2181806.1784947149.git.zhilinz@nebusec.ai/
> 
>   mm/shmem.c | 21 ++++++++++++++-------
>   1 file changed, 14 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb3..f4648545e7ae7 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3602,6 +3602,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   	struct shmem_inode_info *info = SHMEM_I(inode);
>   	struct shmem_falloc shmem_falloc;
>   	pgoff_t start, index, end, undo_fallocend;
> +	loff_t end_byte;
> +	loff_t end_pos;
>   	int error;

Too many unnecessary changes. I'd expect something like:

diff --git a/mm/shmem.c b/mm/shmem.c
index 6641823bed16..cc7b17d0111e 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3624,6 +3624,7 @@ static long shmem_fallocate(struct file *file, int 
mode, loff_t offset,
         struct shmem_inode_info *info = SHMEM_I(inode);
         struct shmem_falloc shmem_falloc;
         pgoff_t start, index, end, undo_fallocend;
+       loff_t aligned_end;
         int error;

         if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
@@ -3680,8 +3681,14 @@ static long shmem_fallocate(struct file *file, 
int mode, loff_t offset,
                 goto out;
         }

+       /* Check for wraparound */
+       if (check_add_overflow(offset + len, (loff_t)PAGE_SIZE - 1, 
&aligned_end)) {
+               error = -EFBIG;
+               goto out;
+       }
+
         start = offset >> PAGE_SHIFT;
-       end = (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
+       end = aligned_end >> PAGE_SHIFT;
         /* Try to avoid a swapstorm if len is impossible to satisfy */
         if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
                 error = -ENOSPC;

>   
>   	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> @@ -3649,23 +3651,28 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   	}
>   
>   	/* We need to check rlimit even when FALLOC_FL_KEEP_SIZE */
> -	error = inode_newsize_ok(inode, offset + len);
> +	end_pos = offset + len;
> +	error = inode_newsize_ok(inode, end_pos);
>   	if (error)
>   		goto out;
>   
> -	if ((info->seals & F_SEAL_GROW) && offset + len > inode->i_size) {
> +	if ((info->seals & F_SEAL_GROW) && end_pos > inode->i_size) {
>   		error = -EPERM;
>   		goto out;
>   	}
>   
> +	if (check_add_overflow(end_pos, (loff_t)PAGE_SIZE - 1, &end_byte)) {
> +		error = -EFBIG;
> +		goto out;
> +	}
> +
>   	start = offset >> PAGE_SHIFT;
> -	end = (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	end = (u64)end_byte >> PAGE_SHIFT;
>   	/* Try to avoid a swapstorm if len is impossible to satisfy */
>   	if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
>   		error = -ENOSPC;
>   		goto out;
>   	}
> -
>   	shmem_falloc.waitq = NULL;
>   	shmem_falloc.start = start;
>   	shmem_falloc.next  = start;
> @@ -3699,7 +3706,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
>   			error = -ENOMEM;
>   		else
> -			error = shmem_get_folio(inode, index, offset + len,
> +			error = shmem_get_folio(inode, index, end_pos,
>   						&folio, SGP_FALLOC);
>   		if (error) {
>   			info->fallocend = undo_fallocend;
> @@ -3743,8 +3750,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   		cond_resched();
>   	}
>   
> -	if (!(mode & FALLOC_FL_KEEP_SIZE) && offset + len > inode->i_size)
> -		i_size_write(inode, offset + len);
> +	if (!(mode & FALLOC_FL_KEEP_SIZE) && end_pos > inode->i_size)
> +		i_size_write(inode, end_pos);
>   undone:
>   	spin_lock(&inode->i_lock);
>   	inode->i_private = NULL;


