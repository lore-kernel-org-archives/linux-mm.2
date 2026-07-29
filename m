Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 26506C53219
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:05:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17C0F6B0095; Tue, 28 Jul 2026 23:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 153546B0096; Tue, 28 Jul 2026 23:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 091B46B0098; Tue, 28 Jul 2026 23:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E190C6B0095
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:05:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 76136160549
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:05:35 +0000 (UTC)
X-FDA: 85040323830.20.3AD96BF
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf12.hostedemail.com (Postfix) with ESMTP id 43A3240005
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:05:31 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="sM/2I38Y";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785294333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zvEjGtV5JAYedJWzyS4m7ytK4cwj4L+MmOrJsuhLQCY=;
	b=PG9NCWvga03eeuPkN26CWBrR6ZlfFYAyTihVIvjyJrdD+QQcngm4hB8ZEkLht5ID2gqtZu
	0VUArpMJxHbDD3xcUT0mFgqoqusIETosFapGkGOwgSqzrYTzyTG1X8jZNwdIsTqVl7UimD
	6MDFx1NVujq+4/5jUGJsToMjLFrvwQw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785294333;
	b=r67ktKIE2SOZPJcP60b1K3OohmJjacrcQ9lMyyc5PavqizLxq6Dq3Rb8r/m1jY6QMe4DdJ
	qQxC/ii+S/Fj6JUITx69gvCBNIDZ7nbRFLvsWgj3w49EEZY30NRRji1ug/5/wJ4g+dyiG3
	FZDBrAq/Ee6YEotO4mXfK/uz2/93OQs=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b="sM/2I38Y";
	spf=pass (imf12.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785294329; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=zvEjGtV5JAYedJWzyS4m7ytK4cwj4L+MmOrJsuhLQCY=;
	b=sM/2I38YPZB4exGip/gi/uf1Rjhe9QUaBnJgLJScYPZ3vVDRwqck0+G+LDuxfvqxzgXpe1rBL4UnzIIRPNocaPONRubMpU4e55uvdVJc6PRZH6YcOCP5BXdEweWvkVFhay3LglNzorUtaexybBg2jktfNLZ6Keo3Xg+WjOiRnbs=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=6;SR=0;TI=SMTPD_---0X80itf1_1785294327;
Received: from 30.74.144.130(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X80itf1_1785294327 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 29 Jul 2026 11:05:27 +0800
Message-ID: <200530fc-dd16-45ac-93d4-c64b11de14c6@linux.alibaba.com>
Date: Wed, 29 Jul 2026 11:05:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] mm: shmem: reject impossible fallocate ranges
To: Ren Wei <enjou1224z@gmail.com>, linux-mm@kvack.org
Cc: hughd@google.com, akpm@linux-foundation.org, vega@nebusec.ai,
 zhilinz@nebusec.ai
References: <cover.1784947149.git.zhilinz@nebusec.ai>
 <adcf644e780706c220809b7a41e6e496d2181806.1784947149.git.zhilinz@nebusec.ai>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <adcf644e780706c220809b7a41e6e496d2181806.1784947149.git.zhilinz@nebusec.ai>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 43A3240005
X-Stat-Signature: 89sf7rk5dz5arpzetrxmyhggtdzoxrx5
X-HE-Tag: 1785294331-138078
X-HE-Meta: U2FsdGVkX19yD2Yt7O+i+cMXv5n1Ba0i+0nrgTWbmsOIJRqvzp1PxakJYHuMB2KrsYO8M1TxZPMmdjYjbTU/+QHv6hSn1J71cs7hI7rYKb7ybuYXHo1TnABLZWeBehgc6pT4GmlTSBqBhTUVI4SBdKX0X+mp/ipw3n0hiEadfqSRXxp1Z1f9aRoBBQAC+wJl4zqRkzwHy2RUJebMgxpprMnjqacVTRY+uB71b3zRujsECsVhtkmvi3A3unEZi+MhOuc3ElJ4cQCpTErXofJlRSz6Cv1rBCmiKgtQAmengULLpSzOOuWv2jEEMpW3zXKH1c1sDX4N1zuB7hPJrmKabCGIIsvHC81b6JQX0RA24m3RZ8FxPzMTPHoFCjIjL69h4RSvZJJ4bDarGLM9nL38cwKzxU7Gwp5r1cbMMsMm1GJ/Bf4MLuT+P8uGAUaDJjse2xMVTBxPXIIV4GCOSXQSe8Apd7Rbn1LE7pdJGH9rUMajgUlD81e6d/GgLY+5aWc8HzzdlaCsxbIx+rOr4fdkN606yxi7MKQVRN9zchqX/rOvd0wB6CVT9xXkvt/T1L1jw9kHsm7merH0dbtnBOqT/Okiol1S6LReNBulm6lUiFaPUQjv6TCWAhw1jlBrkaadyRD/Ssq1DY1jn5FWlUutxkZOtG9hgKWSHNaDRz3dVBs/YMDIXgRICMfxfSHUtMmMB3Y6kW8cDBV7ODwobMhOzrxN4+X4ybLIM1siuPCfDr4Ijq9Y9w1OJ2+Ed+ddx2vUfbQP4NbvpKpnVW55F3sjsZwDtt8nsrznzDD2GEJj5VQ/UNi62GnBuFN8DbFOlmMSnn+nwVp+bqnlFU517vklYu0tBrtYmlTuWse6ouohmMoo/k+Sy/zcGoLn3VMrCGEiguQxn1goJc+zx9LOprPxn4Nkm+KNSR46zM1rgURSRzKobEPopTo0LUpocKw3s9svFfcZDiGZaonLeGFNxk7
 rqMbSwGN
 Hq4K5CXTNsypsi4yn5yXTJbRIy22sq4chxyAQNyyJeQgtwIrOSg+Rq6jJ1e3UyLnCkxRCKXaZr+teKj5avGagDxZU6Qo+RvLgtDvMjEug9MqJdyIA+Y9/OdePoLzzFikqgj2N/9mSTxpIKgHkynm/XC8MKxuYDcAky54JS0G5uPpttqOkYvTtr1AZhHamwS3DMLKx2+xSW+Yl3RRjU8Rr1BxoEyb2YTB1Q138F//nm/lrkeGINa26kU7/85qImLpvgf6ClLy7ZgYQim74dBJYCPh3zPrTiX8IWYIDgIxWzr3HTab3EefI5tPwDCllLRjzGpSOkoDgoV7/tSq+sZR/Sbn1XHWQgGb003iii2skHLBdA48=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/28/26 1:38 AM, Ren Wei wrote:
> From: Zhiling Zou <zhilinz@nebusec.ai>
> 
> shmem_fallocate() validates offset + len with inode_newsize_ok(), but
> then rounds the end offset up to a page boundary by adding PAGE_SIZE - 1.
> For a valid request ending at MAX_LFS_FILESIZE, the extra addition can
> overflow loff_t before the value is shifted into a page index.
> 
> On the internal tmpfs mount used by memfd_create(), sbinfo->max_blocks is
> zero, so the later max_blocks guard is skipped. An unprivileged memfd
> user can therefore pass a length near MAX_LFS_FILESIZE and make
> shmem_fallocate() iterate over a huge wrapped page range, consuming CPU
> and memory until OOM.
> 
> Cache the validated end position and cast it to u64 before rounding it
> up to a page index. Then reject ranges that are larger than the tmpfs
> instance limit, LONG_MAX, or the system's RAM plus swap before the
> allocation loop.
> 
> This preserves the existing file size and seal checks while preventing
> the memfd path from entering the allocation loop for impossible ranges.
> 
> Fixes: e2d12e22c59c ("tmpfs: support fallocate preallocation")
> Cc: stable@vger.kernel.org
> Reported-by: Vega <vega@nebusec.ai>
> Assisted-by: Codex:gpt-5.4
> Signed-off-by: Zhiling Zou <zhilinz@nebusec.ai>
> Signed-off-by: Ren Wei <enjou1224z@gmail.com>
> ---
>   mm/shmem.c | 25 ++++++++++++++++---------
>   1 file changed, 16 insertions(+), 9 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb3..d626561d46db7 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3601,7 +3601,8 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   	struct shmem_sb_info *sbinfo = SHMEM_SB(inode->i_sb);
>   	struct shmem_inode_info *info = SHMEM_I(inode);
>   	struct shmem_falloc shmem_falloc;
> -	pgoff_t start, index, end, undo_fallocend;
> +	pgoff_t start, index, end, nr_pages, undo_fallocend;
> +	loff_t end_pos;
>   	int error;
>   
>   	if (mode & ~(FALLOC_FL_KEEP_SIZE | FALLOC_FL_PUNCH_HOLE))
> @@ -3649,23 +3650,29 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
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
>   	start = offset >> PAGE_SHIFT;
> -	end = (offset + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
> +	end = ((u64)end_pos + PAGE_SIZE - 1) >> PAGE_SHIFT;

I don't think this is a common case. Can we just use 
check_add_overflow() to avoid it?

> +	nr_pages = end - start;
>   	/* Try to avoid a swapstorm if len is impossible to satisfy */
> -	if (sbinfo->max_blocks && end - start > sbinfo->max_blocks) {
> +	if (sbinfo->max_blocks && nr_pages > sbinfo->max_blocks) {
> +		error = -ENOSPC;
> +		goto out;
> +	}
> +	if (nr_pages > LONG_MAX ||
> +	    nr_pages > totalram_pages() + total_swap_pages) {

No, this is wrong. fallocate() has nothing to do with the swap size.

