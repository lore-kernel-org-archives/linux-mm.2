Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 251D8CD37AC
	for <linux-mm@archiver.kernel.org>; Thu, 14 May 2026 01:12:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 63B826B0088; Wed, 13 May 2026 21:12:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EC8D6B008A; Wed, 13 May 2026 21:12:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 502066B008C; Wed, 13 May 2026 21:12:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 406766B0088
	for <linux-mm@kvack.org>; Wed, 13 May 2026 21:12:26 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CB0DF1404F0
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:12:25 +0000 (UTC)
X-FDA: 84764249850.27.62425D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0CEBF140010
	for <linux-mm@kvack.org>; Thu, 14 May 2026 01:12:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a2tSNKal;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778721144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JIPKDrNLoHwaiMx12hjYmDrr1jBQT0DrBFTG7X7hrmc=;
	b=l9fOYBCiKeBRIXxBKyfot5OBU+3ZH52EOAxCIp0KXHeJVMIJjALCyacRPfLyCeXNHboWBa
	ZEEtMW8w1FY6st0noK3rIfHhxm7CNq9Bu1SCoXB7jRMFwWsUPQFWYtAviZ/PzC9di7h4iJ
	xZnxhfan073y6+tq8nQIY1xSP7UKjKU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a2tSNKal;
	spf=pass (imf09.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778721144; a=rsa-sha256;
	cv=none;
	b=6gtTmf43k8ZY+BlFEI09vVQv3Gnsa30tOkn+CHB+S8vNscFVEgByjWZiNBNwR90DfcW2aM
	l70NRya64Fd6t7fYZWEz1YwCYAuw518G5ugtpIWoqtHjIQB5acU3FleMKr3Hi+vpfQQKXw
	yflVckTomORjBn2pCdt8lVD0DKImPUE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 31DA4403AF;
	Thu, 14 May 2026 01:12:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A84C19425;
	Thu, 14 May 2026 01:12:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778721143;
	bh=I5BsO9LjXXTko10w91/UPAFRg7TLDcOecDFgCr7EIFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a2tSNKalpud4RGoSM7eHWLelKomAhV7IwcV/EId7G3IgEwbaYa4ApHQjZSAN/ZLFX
	 lz8524xu0VUwEhWJbHi16N8VXZ16llXXz3EQQozpLHeKkvR3kwdmUvAtlQI7ZZBdDF
	 xu7V4pRClzKIOBYBq8hCl/EVKdyGsZe5whnDEziV5YJv5mPJwBQBISev9kGrYLGMoB
	 ZtQeUF8YJn0JiB0mm0ZwuTi5eOiL8QPcW3qtVk/H+M0h95lfI19+Hecvi+lQxwjaCz
	 gWzEJKS9JmF/XzDAQT1g+LeFgHGHHgzFCtz6SwhtYlLPvFSa5QXZdAjnbqc5ju3AgG
	 7jm/E5YclT/EA==
From: SeongJae Park <sj@kernel.org>
To: wangxuewen <18810879172@163.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@fromorbit.com,
	qi.zheng@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	wangxuewen <wangxuewen@kylinos.cn>
Subject: Re: [PATCH v2] mm/shrinker: simplify shrinker_memcg_alloc() using guard()
Date: Wed, 13 May 2026 18:12:06 -0700
Message-ID: <20260514011207.148756-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260513075214.2655710-1-18810879172@163.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0CEBF140010
X-Stat-Signature: kk4n3s9m9491acsosc71nk8jxc53saeh
X-HE-Tag: 1778721143-265881
X-HE-Meta: U2FsdGVkX1+uwuuktU7YyyhOmSsl61f7oc3WqOkLyGUvbMUSt9xl7UucGBLvOEi3qc3BjlJxGiwQS3xQ6uwRWKLLCyMZDIwWpoqQzENTtDFt8SN+PmoE88WRa/pFpZ2X4ubjeen3rYfgBkUkRYQ9gtUOGIb3cHt79O4w8MtBC2Bi0qotuuy7WRTWkSmQaUaAa9FmCQa6IzmRxHdsfYcRC35YsWfJerfwcebs/qgPS9PA7+Fqg6x9gJEgt1Hv2urotKnnvMX77cGNEPjyrojq+BLzLwVXDEUA0f7HO1hIkxpfeGh4oI8wpM9M6hEXM6BrzbVbxznQ9qk5OsgWxSYc/FZF5SHbX3NjE3d4cdIQbhJCSmVQSeRby7fST5BZkj2bGsfuQLeHTnWOJQLKHGJrq+nZr+BQpqNX5m2fJjOGRjkYLKwel50yrLpsBYRHuORZSmu5iVU87uQ9z8MO0T59jPgowgQP5EwhVGLT+XJgXnOsYPD075u9PC0WoeNSTn3GrzB3y1CJ69nV+oeegXyW2111UJ6F7py00cUygUO3tAfJ9zjO00NQHiFs8+LGnB+0LY5cY9UCjxbVufpYRxqsWG01NDITLQRo/nW1nRL0gWx910Pk0FEln8e1QwM1pZ86b95tM/3fYuK9XmuZHulLSEgGWH8xXYmfRnC2Il9nkXQd9VvcBwlCcDDaLIvgLFDBbxLosYVTHTiue1M1BZFbK+4XUc3Dg/bH2lCumZsN9baP9amtdmlBByy7kkoVprWL7u4X1XXEtJamJN4a8RMvf6Aa4AFxEjS1+9+d0xO6MuFmfu/09TB0KSxXR1p7sNBI6JLdeTeYyZGszQxb/RKZqKHPuHr2mVhhy5ri23uCd1f4VBszh8y+3LvJ7ytyz8LEXOCq7R8zgJUrWpfEfau0rDMFYkpRYmIScOCE5SRqaKTs9mLluukADVbYhyRO0nV+B9HB4A66oqow0ncDM9T
 +wClfzMO
 HYXq7/0SIhhLBnj89VXWIKNbHjVV6NdwCoTyr6BCicNhzALPFvQ4D2FwnJSLX0lPBXlCvuNr/d/GAkHg0hRPRfWRYCMUdwWYkXSxrTbSdQ9MW1C/SBRWEW4H2n4lUjjPxoFcbEUVvQd8fqELVtNSGVoDm7ZNmzCJbF/W2lrBkDtWm09IbNHr6i+V519xztezoGx7HXeZRHrYN6sp+6BOIfIzvlfcGiLOqChJUuORephjvSZZXshWZ9KhbnVigk7J6S4UgCFzqz2bBAo6cF5Tyzj2T5gsYEKsGT5z1QAPFRB3Ik0Ye72szoHfEKrTIxOTfbzocO3ycJcMxrgE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 13 May 2026 15:52:14 +0800 wangxuewen <18810879172@163.com> wrote:

> Use guard(mutex) to automatically handle shrinker_mutex locking and
> unlocking in shrinker_memcg_alloc(). This removes the explicit
> mutex_unlock() call, the goto-based error path, and the redundant
> ret variable, resulting in cleaner and more concise code.
> 
> v2:
> - Drop unused 'ret' variable to avoid compiler warning (Muchun Song).

Patch changelog should go to commentary area [1].  Also adding links to
previous versions would be helpful.

> 
> Signed-off-by: wangxuewen <wangxuewen@kylinos.cn>
> ---
>  mm/shrinker.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index 76b3f750cf65..cb03fbecc75d 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -215,29 +215,26 @@ static DEFINE_IDR(shrinker_idr);
>  
>  static int shrinker_memcg_alloc(struct shrinker *shrinker)
>  {
> -	int id, ret = -ENOMEM;
> +	int id;
>  
>  	if (mem_cgroup_disabled())
>  		return -ENOSYS;
>  	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))
>  		return -ENOSYS;
>  
> -	mutex_lock(&shrinker_mutex);
> +	guard(mutex)(&shrinker_mutex);
>  	id = idr_alloc(&shrinker_idr, shrinker, 0, 0, GFP_KERNEL);
>  	if (id < 0)
> -		goto unlock;
> +		return id;

Could this change the return value?  This code was always returning -ENOMEM
before, but seems it can now return -ENOSPC?  Seems that doesn't matter,
though.

>  
>  	if (id >= shrinker_nr_max) {
>  		if (expand_shrinker_info(id)) {
>  			idr_remove(&shrinker_idr, id);
> -			goto unlock;
> +			return -ENOMEM;
>  		}
>  	}
>  	shrinker->id = id;
> -	ret = 0;
> -unlock:
> -	mutex_unlock(&shrinker_mutex);
> -	return ret;
> +	return 0;
>  }

[1] https://docs.kernel.org/process/submitting-patches.html#commentary


Thanks,
SJ

[...]

