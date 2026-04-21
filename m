Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65B61F327CA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 09:08:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 955806B0088; Tue, 21 Apr 2026 05:08:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DF006B0089; Tue, 21 Apr 2026 05:08:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A6E76B008A; Tue, 21 Apr 2026 05:08:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6389D6B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 05:08:33 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0B8BEE5B74
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:08:33 +0000 (UTC)
X-FDA: 84681987306.02.1582676
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4999940004
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 09:08:31 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qHrgWQHh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776762511;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iCBXrhg7C9/srZBYKXkvWBRwmDURbGGY8aIrv/zoQug=;
	b=sqouVGxgCOS0QrXENmDM+HKrT/bq6AxQB+uiLHx/KXjNgZ65MfzZHqUTnAoWUsgFaCMV5B
	m7p56sEKHJwCYGE9LTVkBQAbI4Ck/itneclBPT1JcEy2gPajAG9KhkLEw+OkZqfnhhGYB6
	9+Jy8VTUxlEG+MQjo2ZS8xTC2mKHo9I=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qHrgWQHh;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776762511; a=rsa-sha256;
	cv=none;
	b=yPXbnAUsGO7DTxb/6OdbxcgOACpp8meD94wdjCdMWG9Y+HuxoIxLLRZtxmcurZskEdKTMZ
	puaYVglsGGT1eQ6qPqCWoUGhHMah0IihLc0LJJRsMbiMBi09tOz+ND5J1Zx4GILNKn8BtN
	LrD0uVxwIZXS6QYqQrdNqTP7jR1EMHA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 12BED40B4C;
	Tue, 21 Apr 2026 09:08:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4575C2BCB5;
	Tue, 21 Apr 2026 09:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776762509;
	bh=JnjFXHz/DzaxlCC1EjhtvgOWVsZUYZ1qXPlyL5Gg3Mk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qHrgWQHhOHD+v7BkML+OGgs7w/nKJBfA8bmC5rZq1RqPZcVUc4LkU4Tp2G0Xekbsf
	 T/ngt4IGDVyFGM2c1dXeWNIJzARNeIZZUr3sKEbXj5zohufQJ7YZ0JoSnGqQMzZIAd
	 wQiCG8b3OuEmQyj/3cAEB6wnRhlkQ64luJuEKnHXe1rf6VTjmscUi4+RwtH1qr6Miz
	 M37r41MIXPe7jmsjSbOzCjsqmJHZJ2nR5BEdHqulAHA1Gg3/S99IHJRjrJ5JTwCx0l
	 kVX2E4Z5FhEBG6sMoXScopZXMVgzM5M2UCqUKH36sWcXh6A60qcGA1S01NTwCVQHKT
	 j8308YPwRtrJw==
Date: Tue, 21 Apr 2026 10:08:23 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Ye Liu <ye.liu@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Ye Liu <liuye@kylinos.cn>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Jann Horn <jannh@google.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: handle potential NULL return from
 anon_vma_name_reuse()
Message-ID: <aec7p15jvsw7XRHz@lucifer>
References: <20260421085056.26033-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260421085056.26033-1-ye.liu@linux.dev>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4999940004
X-Stat-Signature: mgzwu54raudrbiq7e5u17w7qqmnrwdur
X-Rspam-User: 
X-HE-Tag: 1776762511-561291
X-HE-Meta: U2FsdGVkX1+zXyfMWsSnl0aaQr0f/XDhG1FK7TQMMS86FNNAUbpRwIXlz7bFaXKvPwEHtv4h/wSHQH9/V4DpAMwYr4eg2CLIMV5yWJiESb7JMH3LhW0cf2joHGpGkdnLKaVM8lobKUvJUHG3k2lr52aRqAincDNRy+UyrHl7QYLSZhFmrtVSbK4aOtujt+Ut1xfOmg0JuT3gAB/k47/Q+ofPUzbjUTcz0uiPtjdNIe3Lc3mMjLQ53GeLA0W0Xj4VDi3LMTHI5HG4ZiBnlyghOEz7AP2slTZCqYiOQWRCvHqX2KG3M369iC5iyewrCRVI/FGAuf9Q6BfPyTbqKJJO8bG2CvoOcbqVAK7Ksc2eMAT1CHYibRzZoq57zGxqJNiQs5GfElnZv1+BVUlST6veqCyY9vBmhInHYLWA0EHTIP+y83QeMI2LqULmZLT3IL7u1GUbodIs/mdtRC89hZTc/+fFGRHAJIhU/pChxwZyYVja7BFMp6OrULXXVH9xgjKxKYVmJs4v/Magmf6iqH4s5CV7EiHqxK/x3eGIuNzCCualDdoz4Wpr0qD3LkPtbDoK36YZG4mdBIHSJCdaJqsLwLqgwbgUsdITwdyP/uqeh740NB+TcggB2hlr85sjdBp6aiHbDRKprjZHSOVLr1sOJmjwMcf8E//UG7khu/S+ko8sbf6SxgK8bA7QmajVspZw30/UcblhOS3V+UdUuUxr5Gv+cTDgBZd8pCruanz5rKe2vP6KUxONWCLRTdNxAdExkmzVbQybGpR5TmpbbUr0osBbBc/bc6JInk/ov4k6D+y8NS4e0NHSdxGcbYq3SaNOatuHcADVzdQsx2zdt2SLS+6gItpbkCtYG4GL7MYRO496SHgXSJJQNWovMU+L53QQHXVdwuNd0IgT0mwqLYqMFt1gJOaZLkgr0UeMiXdQcv6Pj10fhDHDKezTW7tRJR/XJ1ZzvxPsCMcuU+mhXHf
 kZbN6/ar
 GYVLpVE2BlXDPA1ICf/n1P7yP5piHzeZ9nnWZrpN5eFKFa3MJRbhNsgZPxFZmQdWPjiHNjnus4TVfpntuMgsvQARuzUcySCG1nIprLC0qPJZxh9HmVdQmAuIGb/ObKAZtU0Hgrf2BMZGsJF9Aj4bQXEE9Jft6/CcTUYxjHsKakQxv5/H43dafc6WtW7HuIKPla8Tg+ku+H4tF2wkPRSjejMEBpF2mCugw53/V6K0bXE9dYrxNq5XTxCmLO68IgwWJ43rTytHdwRsaGYUdY4M6apr+PfmkQXLkP7dSTH+SMitThWA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK, expected allocation failures (even if practically impossible) should not
cause arbitrary kernel warnings.

But also this is very silly, you would need INT_MAX references on the anon_name
to happen first...

On Tue, Apr 21, 2026 at 04:50:55PM +0800, Ye Liu wrote:
> From: Ye Liu <liuye@kylinos.cn>
>
> The anon_vma_name_reuse() function may return NULL if memory allocation
> fails in anon_vma_name_alloc(). Currently, callers dup_anon_vma_name()
> and replace_anon_vma_name() do not check the return value, which could
> lead to NULL pointer dereferences.

We assign NULL if the allocation failed. And every code path understands
vma->anon_vma_name being NULL to be a valid situation of that VMA not having a
name.

In the case you're failing an allocation that small, the system is under extreme
memory pressure.

Not propagating an anon_vma_name, which is cosmetic, is totally fine under those
circumstances.

But also, you'd require the anon_vma_name to be saturated at REFCOUNT_MAX ==
INT_MAX.

So this is just silly.

>
> This patch adds proper error handling:
> - In dup_anon_vma_name(), if anon_vma_name_reuse() returns NULL, emit a
>   warning via WARN_ON_ONCE(1) since this is an unexpected condition.

It's not? Your whole thesis is that allocation failures can happen here and
cause a problem, so you can't simultaneously say it's 'unexpected'?

> - In replace_anon_vma_name(), return -ENOMEM to propagate the allocation
>   failure to the caller.
>
> These changes improve robustness against memory allocation failures.

No, they add a bunch of noise, then make an allocation failure into an
arbitrary, new kernel warning.

>
> Signed-off-by: Ye Liu <liuye@kylinos.cn>
> ---
>  include/linux/mm_inline.h | 12 +++++++++---
>  mm/madvise.c              |  7 ++++++-
>  2 files changed, 15 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> index a171070e15f0..9bbaf8287806 100644
> --- a/include/linux/mm_inline.h
> +++ b/include/linux/mm_inline.h
> @@ -421,9 +421,15 @@ static inline void dup_anon_vma_name(struct vm_area_struct *orig_vma,
>  				     struct vm_area_struct *new_vma)
>  {
>  	struct anon_vma_name *anon_name = anon_vma_name(orig_vma);
> -
> -	if (anon_name)
> -		new_vma->anon_name = anon_vma_name_reuse(anon_name);
> +	struct anon_vma_name *new_name;
> +
> +	if (anon_name) {
> +		new_name = anon_vma_name_reuse(anon_name);
> +		if (new_name)
> +			new_vma->anon_name = new_name;
> +		else
> +			WARN_ON_ONCE(1);
> +	}

This is horrible code, but as I said above, this is not only wrong it's actively
bad - you're causing an allocation failure to result in a kernel warning.

We don't mind anon_vma_name not being propagated after billions of references
and under maximally extreme memory pressure/fatal signal propagation.

>  }
>
>  static inline void free_anon_vma_name(struct vm_area_struct *vma)
> diff --git a/mm/madvise.c b/mm/madvise.c
> index 69708e953cf5..ccb937a37e70 100644
> --- a/mm/madvise.c
> +++ b/mm/madvise.c
> @@ -118,6 +118,7 @@ static int replace_anon_vma_name(struct vm_area_struct *vma,
>  				 struct anon_vma_name *anon_name)
>  {
>  	struct anon_vma_name *orig_name = anon_vma_name(vma);
> +	struct anon_vma_name *new_name;
>
>  	if (!anon_name) {
>  		vma->anon_name = NULL;
> @@ -128,7 +129,11 @@ static int replace_anon_vma_name(struct vm_area_struct *vma,
>  	if (anon_vma_name_eq(orig_name, anon_name))
>  		return 0;
>
> -	vma->anon_name = anon_vma_name_reuse(anon_name);
> +	new_name = anon_vma_name_reuse(anon_name);
> +	if (!new_name)
> +		return -ENOMEM;
> +
> +	vma->anon_name = new_name;

This is pointless noise. Billions of references, extreme memory pressure
(practically impossible anyway).

>  	anon_vma_name_put(orig_name);
>
>  	return 0;
> --
> 2.43.0
>

Thanks, Lorenzo

