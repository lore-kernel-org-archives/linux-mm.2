Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A185CCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 15:44:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B16598E0028; Mon, 10 Nov 2025 10:44:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEE4D8E0006; Mon, 10 Nov 2025 10:44:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A03D98E0028; Mon, 10 Nov 2025 10:44:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4D08E0006
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 10:44:53 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BE681DEF55
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:44:53 +0000 (UTC)
X-FDA: 84095120466.30.EB157DF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 55E471C0010
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 15:44:51 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F47izqIv;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762789491;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U3YLWVGxztyOvSR8l7bkzJwKtO4g+QIxERj3wYyh3L8=;
	b=Ld3U744d92fU093NNOnNz05ZT+xrA0h6MMkEcd7j9NPlTsKVTjT7rse6m+hKRXMnSKhCfm
	QreeDBlsfXEvdDqa4Olh/1aVWQof9hufgAOyXx85++bydqSQbM36inimTDyREyuybQ9wO3
	J3vl5LSMbUEWjQx1iycn9+epbaJ6R1I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762789491; a=rsa-sha256;
	cv=none;
	b=DqZSpUtWZNkTlSiB5sGtuKdc0UJU99mFMZ8+JvCGXOAkD81hvy+vHxE1GD2pdklqhs0sex
	3xuIwkQzpik1jpSQOHIF3oQRH96Ud3FhT9xN4W7gd5PmQ+yiE96oXeQ04la4BIW29trg/Z
	efsi/PF8WpF05ct4Dz4tZMoccFsKQHE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F47izqIv;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 23D0743DAD;
	Mon, 10 Nov 2025 15:44:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB80C4CEF5;
	Mon, 10 Nov 2025 15:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762789490;
	bh=7ECB/Epw4N8G0fPSAf9HzVlYqXXeRmVNo6f6Ug/7m+A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=F47izqIvDYv7w+GY/eGCtiRSRXvcX9+lbgTTRYtjo7OHpHNCi5gNSTxeJ1ehecWxs
	 QhEjvAJZWHBeO2YXuPRtZh8595tI11T+oBLryABPoc+HvAuxDmEAnmgVHs1ZLHGN7q
	 ex65oUEqxy2tO9KiKVp9fBleF62FCWu9uvgjA/DPOgj4cpQpDBIIhEO3mcXL90WeXt
	 +94jklpOLg1RAAhmMZmuQoFzI8wttAWhsrirxzhEIXUWk3jWHehXEehpGRUkHbYzv7
	 QvyniMWauBnYre+wYVHQPrHW2JQ4wQn+PaLRNcIAu1u5/2/ucyVvf3dbkDjEWNLI50
	 6Ykabp5DrdXTg==
Message-ID: <a65dcd48-d3aa-4372-9c58-2278fc161b68@kernel.org>
Date: Mon, 10 Nov 2025 16:44:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] mm/madvise: allow guard page install/remove under VMA
 lock
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1762686301.git.lorenzo.stoakes@oracle.com>
 <d246c206e2df45cf15ccfeb33124809dafbe1eba.1762686301.git.lorenzo.stoakes@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <d246c206e2df45cf15ccfeb33124809dafbe1eba.1762686301.git.lorenzo.stoakes@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 55E471C0010
X-Stat-Signature: 9j5ekktqobqobc43cwz5k7pcrx5gdwzh
X-HE-Tag: 1762789491-211131
X-HE-Meta: U2FsdGVkX1+3D3QQWle5AlwFdvmPq1aS62bj7mBfeFchk+M8RR8SR8GdPy0c0lbJCjDsAyyUyj0kUg3epXm+m9tJYew2NLLeChgwNs/NXbC8YK+0OKDMnV2g34MuXKT0Zo04fszq0/7l400iCY71pFPOYiJTKyR/lO+LFtPgsPTyI198s5Xd7dxDhjjBtFhVfsArkKOWZfenoNmqd3Qk2zjvAkeKB+JxvTwcMXwoicQfr+riTAE3EmmhIpnGqcvX9iHWWF9+GD5F5E8nkaJ0S0rCwsqp7cL1r2unPys07YTA9CcCl+IOLHZrV5WByTrZc8OWQYtwsal+eFxu2RGDGxOo2sVi/1guZ7fT8ANe4OFJvcGf9u8TjGe8CNawAhpCF62sA0rFPsVxxXdr0p0E2dXwM2KFsi7C5xHyFKrlVCmfJuL0YRGP5cp/ylxvLoAU2uDD4cwlIP56KoNDhBHUBhLLFuWB5KgqYpWT/7o1/Xpd+cuE/TBeKC8J1CBQluYNvX1/yTqN5t9+Dyak+K877IDotwmVLMwpstK95MsxAEY71yIl3xLHWN7QfO0tMj0FOaPEF3SLIg9lUzVNjb9AB1HsmiHyrMI1Y0EG36rhFFUyA8/3MS9Ehp+JTz7zqYA0sOWHOIpZhhfcXYDxrcr/ns5RP99CgH+Zq7MN3OQv1A1OTa74LCge8HGgx+LW2joRaowjdT+DMvBwj3XjnrNup5/nlWcgphW0maNUjd0uxG26kzILvYAFsM8lpA8zNscSBbCxeYaT3zAuoILrcwWNuga+itkZQ6emFK+pA/HEZm6t7Oa2cCZz8lYnv34tOF2wR/H3qjnbueTutTe2zxFC6EtiWSwYkcy+N1puc8q5A84Ysq8CjyBG59vXJSouxL8HWXyaj6R1mtMBBZElKzktg/kO18mZWQggvFhMxwoKxVoj/bRJ0ntqJB3W6mACqNCtyRVq3D2pmES/gVog7mR
 cQ6ySw+H
 DPI0ks1Q757LTDp+2ezwex/tbbl3RVPgcdX8wujEOPOH21YgOwsEmhGMlln8UVP/4ObKmFfFW0szW4L4oipclT2ZAwenIy9bQ6KFOUwa25F14blobqXMplLsAN7eQJuDt1NRVs+jbNMV9zXDFjS/ChuNBRj8vcuo/ml8TX0xlA3pB4I44msPeCKCmPuLssBdgswP24s/V2xChHZQ+ykTqu0/EuZcm3QpOts27c7tgxUWVN+QL+5WOV5ITWz5PzvdKPbDmgrfe38R0j9oDloxUQULO/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 09.11.25 12:16, Lorenzo Stoakes wrote:
> We only need to keep the page table stable so we can perform this operation
> under the VMA lock. PTE installation is stabilised via the PTE lock.
> 
> One caveat is that, if we prepare vma->anon_vma we must hold the mmap read
> lock. We can account for this by adapting the VMA locking logic to
> explicitly check for this case and prevent a VMA lock from being acquired
> should it be the case.
> 
> This check is safe, as while we might be raced on anon_vma installation,
> this would simply make the check conservative, there's no way for us to see
> an anon_vma and then for it to be cleared, as doing so requires the
> mmap/VMA write lock.
> 
> We abstract the VMA lock validity logic to is_vma_lock_valid() for this
> purpose, and add prepares_anon_vma() to abstract the anon_vma logic.
> 
> In order to do this we need to have a way of installing page tables
> explicitly for an identified VMA, so we export walk_page_range_vma() in an
> unsafe variant - walk_page_range_vma_unsafe() and use this should the VMA
> read lock be taken.
> 
> We additionally update the comments in madvise_guard_install() to more
> accurately reflect the cases in which the logic may be reattempted,
> specifically THP huge pages being present.
> 
> Suggested-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> ---

[...]

> 
> +/* Does this operation invoke anon_vma_prepare()? */
> +static bool prepares_anon_vma(int behavior)
> +{
> +	switch (behavior) {
> +	case MADV_GUARD_INSTALL:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
> +/*
> + * We have acquired a VMA read lock, is the VMA valid to be madvise'd under VMA
> + * read lock only now we have a VMA to examine?
> + */
> +static bool is_vma_lock_valid(struct vm_area_struct *vma,
> +		struct madvise_behavior *madv_behavior)


Not sure about the "valid" terminology here.

Would "is_vma_lock_sufficient" be a better name, that would imply when 
"false" that another lock is required, because the VMA lock is insufficient?


-- 
Cheers

David

