Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E371BC43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 03:39:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1A966B008A; Sun, 28 Jun 2026 23:39:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ACAB86B0092; Sun, 28 Jun 2026 23:39:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BB816B0093; Sun, 28 Jun 2026 23:39:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7391E6B008A
	for <linux-mm@kvack.org>; Sun, 28 Jun 2026 23:39:31 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 052D21C6A90
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:39:31 +0000 (UTC)
X-FDA: 84931545342.26.E1337C1
Received: from out30-111.freemail.mail.aliyun.com (out30-111.freemail.mail.aliyun.com [115.124.30.111])
	by imf24.hostedemail.com (Postfix) with ESMTP id A5551180004
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 03:39:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FC4z7olR;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782704369;
	b=ENYg2yT+aPSZ4LiHKy10k7ZPb7R2YOmGeCwSXK9SfB9tws77IcEnMNwVAA6OEyOZ0Z25nN
	gYSQ0zLhTqMgBZmdpLz4iDdRUOUveUWLay53a7qAX7OgdQrAfEZPwCaregJPI8bY/auI2E
	u4czNwB4N2lB4FCUjySKOMMvJxfxfrw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782704369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MyGVXVIwnr/mnxRnfjP6RMMCQrfjfQBFtWk9/oy7rWM=;
	b=7Cat+o7F/BnRsASYvXpOT3WwX2fMGZQcOlx0q3Fy8qmVvjKwxI476ecBDt88VpWtsSm7KX
	OsYLernUbqU/qusCHQxkw5I8WDdWhrhcn2QiUWQ2smDDooTESh/oCdqrn9leyi/Ic/62Mq
	57o4k1zXv5GEESkru2TvrkBP/xO+90s=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=FC4z7olR;
	spf=pass (imf24.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.111 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1782704365; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=MyGVXVIwnr/mnxRnfjP6RMMCQrfjfQBFtWk9/oy7rWM=;
	b=FC4z7olRu21TcvXzd/Gv4JKc8BeWNpdYGQpCYdY4VY6Rhbo5ORWPFMmU+ET/gec7G3uq2l8SXqehFfdZb2gm0qUGMraiGlOiEMstBfIsmfEnTFJ3V5YAF+PApDCu4E3SQDZJv45+RnYF8/uIIDDiGQ6n0TjUhuzvtdmoPPRCH40=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R721e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=5;SR=0;TI=SMTPD_---0X5m6Ane_1782704363;
Received: from 30.74.144.121(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X5m6Ane_1782704363 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 29 Jun 2026 11:39:23 +0800
Message-ID: <8b6aecca-c4fe-441b-b0f9-fff10f7b43af@linux.alibaba.com>
Date: Mon, 29 Jun 2026 11:39:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/shmem: Fix data-race in shmem_fault
To: yahia <yahia.a.abdrabou@gmail.com>, hughd@google.com
Cc: linux-mm@kvack.org, akpm@linux-foundation.org,
 syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
References: <828504a2-a1f8-40ff-bf84-ed7d03f02d83@linux.alibaba.com>
 <20260629033516.10836-1-yahia.a.abdrabou@gmail.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260629033516.10836-1-yahia.a.abdrabou@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: woq574fd75qhjdffu4z49tprskmmfsux
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A5551180004
X-HE-Tag: 1782704367-943309
X-HE-Meta: U2FsdGVkX1+dDguNZsIMZBdzWIv13qY/h6yABReZa7VJwyccJeDb8rQUOoV8I5LAyl7K5fo6l33/ff3n5WKeRyEUbWeRSL3HpgdcomyUUdl7JHGz9JfPfRxCG2kVPxIb+QMTZ25C9dGQVLllqCgXlugpkmxcRqsiAS3ITcJkr0OdVbfvsGnXC4JggdMXS5o3cZsAG3siIwEI9OKNTW1Aql5Mm4bkQfLb4ZcnQuHx3L1+kNAkK4KOKdo6P5yvtCNP2zQRBXZfu4kg/Ye0Dn3c/aTc+qufrosqPDrc72Vl1ZWgkGwk73d3JcRPA5LCa18XH4FOeJl7ylqMvza3dD5a3AVAqkeI/UXxvGvodLaOkjDlggmVHCJs/GXd4Z4NGO0Zxb3xoANcRSfWGQlWfPVEvsGRMOH5AKaJp2KduQ6JKJ9rRRP1+On4GQk8yVZ85pYGxPkkpj3KuIDUSyNmt5BbD/Nit+cTIbRzpYZ4JtEjtVipi2HjT4795jHUOfvkjP8/ZGRE6vsFbBdUAXJLR8FISfuj83emraC0456fnUhf3mgpGdFlFndn5Zq+Ojr5ZsXL6teqzchJk5VAqgQbbfZmSy1kiKjCLlxjnVfPCRU38M4Vo/XS5JmnzAwFKaPjWhOrxbefO/meXOD6Zvs51ozGlXG0wsExtRLFwDqgG1y/wtajgjcMwkjOE/aoKIDBLlhL//ldSJDaYgZjKCaSgDKP9ifsLRwXmUkbOwaZZsfPKNs4iTj3FCE9sKeO3vTTcE6CPLPdXMi1yYVNQ8ODeyKE6lrm2+ngj92fiij2c3UR59PNCxHkYCXLbu77Re8S5mpd0suQwDE4QjJi9WuGatuDS365uysgVhuUKNfGLGgM+wkqVP+AvQbFbdivtrq3Giw6FgI9d7YrmecNJ/yOux03x5GM+8qIMhMkLi/khCLATLe71HmJOToWMtZM2+ODZcOKfjzk2OmZu1SIYbgIQLu
 mNrTcXny
 R8Op5QNTyhJctctVfC1Oo989LAw00RXvKQfR8QzUIGgjpxwBm+g4k/6nyRM1rqnPrSLRWN0xANYEj5WALH0d36QVxUgcJT/Sj4MFZSs/KLVU1rvtikJgiSVTDNgnvhsnSJyoG2Hvm21xYyvnI2E+8exUHPRep3y3NNZjxH1ve9yR7CCtSPFcYRHzfJCFlzMDMFDFi05ahZOynlgjKDBqllo57P9i08lbZcUlEJmiLWs5vGGrqZnbPUUXcVXXUmatgfLjyr0W7NafLqHfVCPZjSofoAI2uCstwCK0WJiVJSV3GIeX1GDGfRuAfyFX5I4+U2RJR7rA6f3z1Aubzn8Bq4GpB2etJ78wJ4+flYoxtHDxiUwUGhjLg1v3ARCeV/gDqhJSm8LRACJjnHtmFd1t4gBH/eL8fXEtt6yK3yBVTQQqAZYmPoH9zfBkew5zpByBJ07c2vcsyeAibjIejJlLfjS23CHSA5UQdh4bQxeGiygLCLEDffqtSFYzjtX8+DCGT6ahFdoxFxqOWzygk4v2/LqzH5VNOynQO4tHJR2fYwLXh5kvAO7ThsS5ap/1A/gLrZKt3klF9paYhCAnIwQWqJYxlxaGF+rkmCFAxsXHyVTS974GVtHh0PwnIWrZOAPHMjPl2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/29/26 11:35 AM, yahia wrote:
> From: yahia ahmed <yahia.a.abdrabou@gmail.com>
> 
> Hi,
> 
> Thanks for your review, you are absolutely correct
> that i missed WRITE_ONCE is required for READ_ONCE
> to work.

Please write a useful commit message as you did in V1.

> Reported-by: syzbot+76cc716982cf0254f302@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=76cc716982cf0254f302
> Signed-off-by: yahia ahmed <yahia.a.abdrabou@gmail.com>
> ---
> v2:
> - Add WRITE_ONCE to shmem_fallocate()
> ---
>   mm/shmem.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/shmem.c b/mm/shmem.c
> index b51f83c970bb..20ee24ab4806 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -2693,7 +2693,7 @@ static vm_fault_t shmem_fault(struct vm_fault *vmf)
>   	 * Trinity finds that probing a hole which tmpfs is punching can
>   	 * prevent the hole-punch from ever completing: noted in i_private.
>   	 */
> -	if (unlikely(inode->i_private)) {
> +	if (unlikely(READ_ONCE(inode->i_private))) {

There is another lockless reader in shmem_writeout().

>   		ret = shmem_falloc_wait(vmf, inode);
>   		if (ret)
>   			return ret;
> @@ -3630,7 +3630,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
>   		shmem_falloc.start = (u64)unmap_start >> PAGE_SHIFT;
>   		shmem_falloc.next = (unmap_end + 1) >> PAGE_SHIFT;
>   		spin_lock(&inode->i_lock);
> -		inode->i_private = &shmem_falloc;
> +		WRITE_ONCE(inode->i_private, &shmem_falloc);
>   		spin_unlock(&inode->i_lock);

This is still not enough. Please check all the writers.

