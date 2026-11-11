Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EEF5606A33D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=cr32rMln
Received: by kanga.kvack.org (Postfix)
	id 69F436B05B4; Wed, 11 Nov 2026 04:05:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 650326B05B6; Wed, 11 Nov 2026 04:05:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 58CF96B05B7; Wed, 11 Nov 2026 04:05:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3BE366B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:05:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CD11F80252
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:05:31 +0000 (UTC)
X-FDA: 85422254862.28.FC0244B
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 08E0540012
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:05:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cr32rMln;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794387930;
	b=yHbfnIP6I+4oaSouX30HXhK1ef28A40ZL7iCS2a5A26N32bS2rHhByMNOLGS/SFCvKuIG2
	dJRSQuaCVC7OGA/9/wOESQbplGu1gyYX+wl0sYkcKHt4A/0LoZKcIYq0s0myafFdVohbnB
	deKxDTH8rnTDRkH6GbsZ16uTSWv1t8c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=cr32rMln;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.133 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794387930;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6boj/nrh3+x/lyQXEXT7Z8+s6teaalDRuOVNSEcHmJI=;
	b=CjFzLqvXbu8OtKXcFLLOvb0Znv0UrX1ZdiuzrFDnXZmbrbXQWdK8/d19aL4mkx7DpzKU8D
	T+hIX2EPliKzvmC8w6UmY3eszKZpK6wYpDExZSMj8fkOd5foNLfkTGB4K8Os+2onY86/Q/
	Q436XJN/dlN+mvuM3A88iaXIC8ovEhQ=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1794387926; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=6boj/nrh3+x/lyQXEXT7Z8+s6teaalDRuOVNSEcHmJI=;
	b=cr32rMlnF8/COM+czuMRzumWzbkoFBAaouth4dfm+ynQZuAyIiKxFYBrpnYAryfY7DiVjsYDYsl5P1zjX0+Tgqvxm+jmN43kVm85nl/hTPpuyFY2zn7C3MwIwDvSInh9CZ51PFEFc3F50twwjTkcLbMi8AGKNL2fJsa/pGM4K7c=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R131e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037009110;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0XEYLJIk_1794387923;
Received: from 30.74.144.118(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0XEYLJIk_1794387923 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Nov 2026 17:05:24 +0800
Message-ID: <1291b635-6dd1-4887-bfb7-075eee45b7f6@linux.alibaba.com>
Date: Wed, 11 Nov 2026 17:05:23 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] shmem: Serialize fallocate progress with writeout
To: Zhu Jun <zhujun2@cmss.chinamobile.com>, akpm@linux-foundation.org
Cc: hughd@google.com, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+aae8bd56cc1c38d50ec4@syzkaller.appspotmail.com
References: <20261111084155.80971-1-zhujun2@cmss.chinamobile.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20261111084155.80971-1-zhujun2@cmss.chinamobile.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: n1j1k8ky6exznxwu9sygbmiyuxb75t8k
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 08E0540012
X-Spam-Status: No, score=-24.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794387928-353535
X-HE-Meta: U2FsdGVkX18gIgIom3Icz5scYrMsC43vFl+Nr2eiRZoyX0FOM2ITEb5l/CTjEKEZq4BlzcoTrxu17gUusuP91qBLKLZwzymfm8d3iDvBUsfsJg45oEJQx0E5l4MSlNUXJLTOlhUEKNqY2xUcqPUt1XDh+pIJZava2dlGVjjt///iMXsVepXTugpXA0MoWZfBICtT4JMH/zy8pOw3aQLAGiBu/F+Ao4QcPs8Yr4uCMjlfKyNZMGw/Zi3PIats/Wn1k72HYBUmagqfgl6u4wnVjeZw1WYgVRdpxKZJRHCBOGTg32OLJl5znckNJOmAVHvVBLBjFlg3aF+m1aipMlzMhP4lDffkMvNM0qwKhjZhE1G08bMI41dTJZrKUSf8NnL8sBBCsKGDR/7MDAxZCW3Dfd84Q4sfHpJUjZqLakfaVMszIF8FimlP4T0Tue9h+BKPZ1iJ5sSse9isTj9nBj9e/tsrs83NWVhqi9RPWe8H8zwL+YQY67jGxu50Uy6abLvynpn5QEsvTTnVR1ImR+//JozJMyfdTaj122zDZU44rEerxP9rwKdwYGs1BGY3a6jTctFnHdIsU5OCxaUEb3nurI0Z23Fl5vIH5uAW4I7LF75WFrFdB88NiFhOOIjQgjI8/Hni9I9159ESRqKCQqiupT9SBtMONZV3yHfgkYFzyK93UtghA650GW5Dg8OnRMuK/Hd4HIZGgl53VVrZyZTVDmBdpPPWFH3iZHr2r5d3czBRZm1eNLO3zNQGxoSd55soT3S3tSLOgtp7iz2WhA7x4PfjmAp4bT9UzR9xGqOnjazsvRb8U+YBQxnUSMdK41wRtRYYJTN3WFA9+yJG5ZXM6uHZPw08wofYb8KfHfDjOJQzsztBJprgb/s/e7eJ5UDA1tUxzWWqkD5grTIISzPNicsqWL/6vu9ciwdIAoEquNByl/0PrZgHB17DHw5EGJw/wysC2fHZcHGcNKnKLuV
 unvvYWMU
 3XGIt/VT4ST5bjNpJHtqxYWc6oBej/Zf498za1UtEgQ2I2Xi7w5UoxXR0jip3/zWf2g5ci9Iz75oLngYn+Wj+S7W79R2dIDhiRtfB4IFUyHwA4vbZT/Zm/1YSHnCy/01AsnlyL/f1XXPPhPfReNpNlnwXZHpNuDIcVIqqy0DcL5HjgH8tWM8SGmchr29xwNoUpz2mzYPZ9IXvAvuaTEwl/wImotI3lMDKSmFdX5NXttU4RH8HQpJPJU6SfinkCqShnpVLOzA/+zWYXZ6VDuqDtZNR6mNar9ZT3dYWs7lOmSf7Yg5oREFfjezIFAyybsOSsyQDOTl/e0DPvxriT1LMu3RrTFgkB87lNdsAbQn894XVSPaZ4tx+U3alej4kDuUL2ANS+pedWmYerw77YKTZnlr0l1bC9pnpcVBg3Se1SeVELBR334YvehG/5CC+XwGLx4OCDNLG+1GGUZl9vx6zLq3V9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/11/26 4:41 PM, Zhu Jun wrote:
> shmem_writeout() uses inode->i_lock when reading fallocate progress and
> updating nr_unswapped, but shmem_fallocate() accesses the shared progress
> without that lock. Holding the current folio lock does not exclude
> writeout of a different folio, as the KCSAN report demonstrates.

Could you show the KCSAN report?

Also, what's the actual impact? It looks like there's no significant 
effect to me. For this kind of concurrency, I think READ_ONCE/WRITE_ONCE 
should be sufficient?

> Use inode->i_lock to sample the unswapped count and publish fallocate
> progress. This matches the writeout side and keeps the existing folio
> to inode lock ordering.
> 
> Fixes: 1aac1400319d ("tmpfs: quit when fallocate fills memory")
> Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
> ---
>   mm/shmem.c | 11 +++++++++--
>   1 file changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index 990f1b083779..5769cfab1d71 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -3969,6 +3969,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   
>   	for (index = start; index < end; ) {
>   		struct folio *folio;
> +		bool unswapped;
> +
> +		spin_lock(&inode->i_lock);
> +		unswapped = shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced;
> +		spin_unlock(&inode->i_lock);
>   
>   		/*
>   		 * Check for fatal signal so that we abort early in OOM
> @@ -3979,7 +3984,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   		 */
>   		if (fatal_signal_pending(current))
>   			error = -EINTR;
> -		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
> +		else if (unswapped)
>   			error = -ENOMEM;
>   		else
>   			error = shmem_get_folio(inode, index, offset + len,
> @@ -4007,11 +4012,13 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   
>   		/*
>   		 * Inform shmem_writeout() how far we have reached.
> -		 * No need for lock or barrier: we have the page lock.
> +		 * Other folios can be written out while this folio is locked.
>   		 */
> +		spin_lock(&inode->i_lock);
>   		if (!folio_test_uptodate(folio))
>   			shmem_falloc.nr_falloced += index - shmem_falloc.next;
>   		shmem_falloc.next = index;
> +		spin_unlock(&inode->i_lock);
>   
>   		/*
>   		 * If !uptodate, leave it that way so that freeable folios


