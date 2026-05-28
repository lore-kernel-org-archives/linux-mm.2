Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03BD1CD4F54
	for <linux-mm@archiver.kernel.org>; Thu, 28 May 2026 13:10:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3480C6B009F; Thu, 28 May 2026 09:10:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F9876B00A3; Thu, 28 May 2026 09:10:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20EF56B00A4; Thu, 28 May 2026 09:10:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1207A6B009F
	for <linux-mm@kvack.org>; Thu, 28 May 2026 09:10:10 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B6A98161F79
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:10:09 +0000 (UTC)
X-FDA: 84816861738.20.9FDFA95
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1F92840002
	for <linux-mm@kvack.org>; Thu, 28 May 2026 13:10:07 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UKEYhoMA;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779973808; a=rsa-sha256;
	cv=none;
	b=a/x3F4zH3cJ0NCSz2leUnVpPhBsYM3ASpqC8K15OSUVdsp76BncI/rmutuIaj6PDt+R8Em
	3UmkSmZekxme7H2eiUp3hxS9h/G44K17UayilM6QcQ1WQweTFnYBpt/jfAapYcWCcc6mS1
	eNgkuspaY2d+nW7QX0YUWSupNyvv4V0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UKEYhoMA;
	spf=pass (imf07.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779973808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vBdipJ1lWYMswZIllLQPqc/+U4TCGgVcu+lzw0tAm94=;
	b=5yhkjI+YW9XfAGDzkVuBJbvo80vQvw0jilzPcp21HtAEewlg/QrJf3EBYuqwqEXHtrEWZU
	kcLYQr6Ky0oS0mwwwwT54t2Q9H/rCtysMy0aD6OPBebIVGdECD/JQ1d6YrdSmKbPZAq8vL
	xKgI+6PbVf6OsRBHXm9NGWHXXSdJmeM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4861942A91;
	Thu, 28 May 2026 13:10:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CA91F000E9;
	Thu, 28 May 2026 13:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779973807;
	bh=vBdipJ1lWYMswZIllLQPqc/+U4TCGgVcu+lzw0tAm94=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=UKEYhoMAUhUTYRLziHClPsxubV45B0aR6fEIS4gjkQI/J/56Co9UWD4OzWY/gskhR
	 /kcnDd/Pf4FeADSDJjHGo3s27Vwmq8j4x/iKTlSDyDXldmAWLdwi6WWoFLWva5fTBL
	 2yksIbSne+xYYGVhevFMn3aAe9d+ySCHxKU32F8AoM1O6NJq85k/XFeaGmKKaWnzE4
	 kcRR2bCgGdJIewhD7yWV4Gn8L1IiVHng+xA0DxCZuIMzhfLEz603MQFrPJAKoaAEN0
	 ekxmvEGetTIygEs4nMWjI22Plc9vceAWDpB8ZKwgVPUKYl9hYX3zOmAwiAg9nPy9sG
	 1XKjViiPExe9w==
Date: Thu, 28 May 2026 14:10:01 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Carlier <devnexen@gmail.com>, David Hildenbrand <david@kernel.org>, 
	Heechan Kang <gganji11@naver.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Michael Bommarito <michael.bommarito@gmail.com>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] userfaultfd: remove redundant check in
 vm_uffd_ops()
Message-ID: <ahg-iFdkbl8p8E75@lucifer>
References: <20260527184751.4147364-1-rppt@kernel.org>
 <20260527184751.4147364-4-rppt@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260527184751.4147364-4-rppt@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1F92840002
X-Stat-Signature: 84bqwsmdkwkbeybgu7uuax6ji3nujusq
X-HE-Tag: 1779973807-373790
X-HE-Meta: U2FsdGVkX19qiMkfj7HH36pPvLjNnEEyHUp6w74I6W7Jpl/LF2sFMTScznmSqGnc4K/6P09sbGOZPZqT0xJcMGukOYMi3/DUXoKQFnuWR4kFpXoXzXq23aCFZK4pTWOi6szBa2jNt3pxap+JeAQSw2jHMzeRC+UTjnbw13fmzywcEYtaKdrxR6RR0CVrvRJd/8Ri0dzcrhqSC5zf9oHoo+mUWfA+w0K1PEf/Src1hMtNK7TZEZGv5ordkj4NfUpP2ScsJZimuH/enxLsbvJAryqJCT7HUHziwYD2YvCZ+MexHF8JSbCQO2PYH5hnjiQBbX/J5P557QKihMm9ALyaF9ax0b9vX8Iww0nmpZPKiz23OU8L3Ab8VkyO+tuW2rtl/KkLhK+IlhbUol2YATdSsyd4fqifh04gpxkXpGkTQSYkMgZSeJPkeeOcreYdW2NnER4xOhrcb3a//YVYCnBg0/uB6oKKWSAgD2fPpzdAKzveWc670MFQsLgTbdDyAWAPNedo/cwarmKMBBZQIfJRht/JyLXWZTupv/MQciPmyh0TjzyxdIiTAtc3X52+YfmkMdKSU7YXVmkYPFK05qj6KobH4OFhLb8exqos5Xa18TOiDjBOwFTbRrGmGhKeVmlxWttMZ5N+vk6ykih9G/vL4EgiF7HHgbcfD4WYaPumh2vi1/BRtntn8cAoXl73qhPpT9ZWqoaFhlq/8Gc2eiJrtjLWayf0V0b1xzLpV93ST0+F4ZfNsEPaHBRopb8RokA8guglBrkdw+ObV0l7XCCInzzi7Asw2utoxx4axY6XvTQDrCsgzVwI2nB0oy8tfBJiqAwQuddzBep2sHIIwGnkkszfvABs/v+bJz76bbGeCJGdEflvozJQiZgJN0FHeabY/XFBHzcM26TaG6wWtvK69syV1Lyelv5pdHQ/uzg8GL8SwrpcLtuQJyrKmdA7jS27Muke2syFDLVZtuMRja8
 P6Rhdai6
 3X2ZHxULt/V3Khy1NYxzSyau87H134IejwuRFhf5KW5x+1Wis/3PTmnrX6UDepQ0SPCPPbSH8AP20xqGV8z8dk0Gm7AosFXfNLjAKwywOZbfZsWgR7IbhmGj8jUHvAJbi6RxPN8XAMtMZzsOAbMLAxlBRfbqQ/o+r0CjSKWdBZPQ3QJDWzRUKPcJHLfyMLRgUcOPYrBrKX6DJUJmTWnGdPD/zOfk/ITf2qOVyb/Gy/K9xNSFMNQpIrZqLG85p8wZrzuZg7BZeN72LukP47vfy0X6DNeLjdagVQrrQaRlejalUJal05Z8m7V09m/ZbWZ3OEDcGMizu0l41A41Nj7EfMf0//F+qfigZzLJIrRP0pWYe8VwmNRLDPBB5etU2MFfejtaoZvCG9yiSoWg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 27, 2026 at 09:47:51PM +0300, Mike Rapoport wrote:
> From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
>
> Lorenzo says:
>
>   static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
>   {
>           if (vma_is_anonymous(vma))
>                   return &anon_uffd_ops;
>           return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
>   }
>
>   This is doing a redundant check _and_ making life confusing, as if
>   !vma->vm_ops is a condition that can be reached there, it can't, as
>   vma_is_anonymous() is literally a !vma->vm_ops check :)
>
> Remove the redundant check.
>
> Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
> Fixes: 0f48947c4232 ("userfaultfd: introduce vm_uffd_ops")
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

:) thanks! LGTM so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
>  mm/userfaultfd.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 2872c71bbf36..80cc8be5725f 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -68,7 +68,7 @@ static const struct vm_uffd_ops *vma_uffd_ops(struct vm_area_struct *vma)
>  {
>  	if (vma_is_anonymous(vma))
>  		return &anon_uffd_ops;
> -	return vma->vm_ops ? vma->vm_ops->uffd_ops : NULL;
> +	return vma->vm_ops->uffd_ops;
>  }
>
>  static __always_inline
> --
> 2.53.0
>

Cheers, Lorenzo

