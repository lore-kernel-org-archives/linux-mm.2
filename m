Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 14BFC606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 18:54:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jC9C5R9C
Received: by kanga.kvack.org (Postfix)
	id 2D0846B00EF; Tue,  3 Nov 2026 13:54:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2815A6B05B1; Tue,  3 Nov 2026 13:54:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1977C6B05B2; Tue,  3 Nov 2026 13:54:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED1FA6B00EF
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 13:54:28 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 83E46160287
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:54:28 +0000 (UTC)
X-FDA: 85394708616.10.0D9DF99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id F3DA880004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 18:54:26 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jC9C5R9C;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793732067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JPljfIGYRDg6q52cSpwt94ZpPrzmAsejEq2y2BXIXP4=;
	b=gf3QQg4vs7BaEVo42LKOSaFZrVZKdc2f/6u01rkrs0021pxSD2ZPmfhZy8r2U84Dug9+yf
	Wyrtfduvj3w61r5zsuSCleGGwtjTAAEKzkRobzVAruSk7MQYmNnBvsNL/3YfZtQCglwkzy
	eqCTn4xhTVOkGnN3zeTjKyCLyiHt9lc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793732067;
	b=BbPw+w4mi7F5cvp/V97YPST/1rOmZLOA2JQR2Ztmm5nPqEpuxwX6LgJAQLVkrk4gWbzvlo
	blk+l4AI395Hs/I4AmI8Rv5dKaRNS8AcsTJR/iNi2XTK8E/Jz6pLwL61tP0pZv79KyYKUn
	nop8Dp+9I2y+MgSCQCKiXz3iuloigZo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jC9C5R9C;
	spf=pass (imf02.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 46CFE601FF;
	Tue,  3 Nov 2026 18:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7A2D1F000C1;
	Tue,  3 Nov 2026 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793732066;
	bh=JPljfIGYRDg6q52cSpwt94ZpPrzmAsejEq2y2BXIXP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=jC9C5R9C/AIcfymo/OgR/5QSN9tRRJhOrWZZ3Ql64cmS7m2RytoQaDU1OOEFjiI1+
	 LUmcdiwRvFuMNeeOYl6DX5oVQ9GcYX/ijn0V0CXkUrebK6h8Lzg27aVbUF3FFQJInW
	 ga+3CMyMi7i/WATmUjAQcRfeLz+nDG2yy0i6cyCqLHJXGgQbKiaWqIK1mVnTGbM6e9
	 xzHQK/m6ctGPw56Mki0ZFtWQ6Snkvt7dFuZQjKKPaBFcoHz8Aiaa2lARbnzTQ1p189
	 tsM8fDrTcFvS8KTGv5Jao1uv80MSSY3BSv4GdKf90dbSmYvQuVQVqPFc3bOYcF3Wz9
	 RNt3GxHOfeKvg==
Date: Tue, 3 Nov 2026 20:54:17 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Umang Pokhriyal <umangpokhriyall@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] userfaultfd: validate the whole range before
 changing write protection
Message-ID: <auot2ZVM5YjyFlZZ@kernel.org>
References: <20261102103621.156928-1-umangpokhriyall@gmail.com>
 <20261102103621.156928-2-umangpokhriyall@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102103621.156928-2-umangpokhriyall@gmail.com>
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 1qwx3b8k5oop81bqg54qx6bwk7nrx4bu
X-Rspamd-Queue-Id: F3DA880004
X-Rspam-User: 
X-HE-Tag: 1793732066-177057
X-HE-Meta: U2FsdGVkX18nzj4G6FOwwj+LQu/jZMkXix065dGGAr5m6wDXx8ivKtFfDnWRZXES25bg8m/w0PV6lKjNWhHfiIMDh8DdR5RqXOVzr2MeZ/AXhINnN4V7VOENaygT95KVZxTYF9QunwKlOP86JN8rGQhShXUwEq5Qkdvnv+MVMPrUXsYEuW6m89eN3Kz7JqAciJbARxhVYeZ/gTZmALIA39bm40IHKnGhgtRwAc64xQ5z6wnJZSaYuRjetuXcwOn0nEOGjVGOPq4HUsV/Qs8LfEhkZPZ3RCOPM9ywlNnXY0nPBSRXeE0ardHoj/9WMaP8NelmhlP4t4cOJJMkiXFgUM3Q+tDmIHVqy0or9Z6GqnZacJVkPB5mJthbrdt6QYcnsGbdkSg+Boab89PNIIsGLkXshYkLi83jLcH9rINEe6O8G5NLh3udAGTw3w2uFn/eDp8wZgyY2ljzp38Iw2GduaGoag6g0/7V4yHnaWO0EODd4R5SQZ1l/13ykjgq1YnpJTql9ujdqndIA8OWDvGxg4+/dw3E9z63uWFVKq5DUh9fxr+jhu9SkDfPHDG9VI0lN7ikKUuTsRfw+uG22ypi/JR2su+GlbYDhjSVwKRBDu29SCH7pj7fcgbNWFWVu9idxREMdVCpP7hqSq9HqwIv1IjzrvEZMByRjOQLxQnnRZ2u7ZcJ1gmHvcba2yWI2HBpgwa+F5Gn3CrVNwI63eO464zED/PYLtPtiOZ7HEnOjo5IQwiRRHZP5GTDMO02n+m0beR6OZzkCspoH3TOJcN+v5etUntTq/QHl4E/PbBNyoJPPfVoi7PbLO+YWCXs0tOvIP44qWWB4hBrysOYppMba04pG3jUbKUd5LytbhF1OVYxcRieDpcKAeEYVLHUv/q6TB9tqeqlCvlZarH/sVRvJQW1G+U4CvkcgG0O2TLl8aNxjrQ1pXwpTiFKZ4lVdrY74hqBrmFPffqHzmMJgPi
 EmkmbGn7
 K/1Wv/D+ySNUT9E+ZWT268DbJiH5+0sqwMUrVtXmYaSmZJvdRLXKjQoNCiQLJB5Jzpj31m/9AE00WC8tXp68o0z9229kri6346fRdICcaGtRswUvr3P4sLwnIT1+fZs3lTJhd86DpBvbYgBqA18OT4YWr9+zb1jFB7xAp59DoGySEOOzIcefoxTiZWTKxdn3YxvyXJEhM6oXG0hWrsPKWSAw+eecw9YPSyXs3Px3YoEcmUWsOlZi6p6X28vxxF4DQmNcoguoYheXhaKE/njYG1bteNC+X5h2Jm7H/q5FtV+UCQ6o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 04:06:20PM +0530, Umang Pokhriyal wrote:
> mwriteprotect_range() checks each VMA as it walks the range.  When a later
> VMA is not registered for write protection, or is a hugetlb VMA the range
> is not aligned to, the call fails after the earlier VMAs were already
> changed.  When unprotecting, userfaultfd_writeprotect() then skips
> wake_userfault(), so threads blocked on those pages are not woken although
> the pages are writable again.
> 
> An unprivileged process can trigger this with a range that spans an
> unregistered VMA.  It hasn't been seen in practice; it was found while
> reviewing the userfaultfd range ioctls with an LLM.
> 
> Validate the whole range first, as mrwprotect_range() already does.
> 
> Fixes: a1b92a3f1498 ("mm/userfaultfd: support WP on multiple VMAs")
> Cc: stable@vger.kernel.org
> Signed-off-by: Umang Pokhriyal <umangpokhriyall@gmail.com>
> ---
>  mm/userfaultfd.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
> index 87da92526..b8a9d9574 100644
> --- a/mm/userfaultfd.c
> +++ b/mm/userfaultfd.c
> @@ -1105,21 +1105,31 @@ static int mwriteprotect_range(struct userfaultfd_ctx *ctx, unsigned long start,
>  	if (atomic_read(&ctx->mmap_changing))
>  		goto out_unlock;
>  
> +	/*
> +	 * Validate every spanned VMA before changing any of them, so an
> +	 * invalid range is rejected without changing part of it.
> +	 */
>  	err = -ENOENT;

Nit: this assignment is now redundant, isn't it?

>  	for_each_vma_range(vmi, dst_vma, end) {
> -
>  		if (!userfaultfd_wp(dst_vma)) {
>  			err = -ENOENT;
> -			break;
> +			goto out_unlock;
>  		}
>  
>  		if (vma_is_hugetlb(dst_vma)) {
> -			err = -EINVAL;

Same here.

>  			page_mask = vma_kernel_pagesize(dst_vma) - 1;
> -			if ((start & page_mask) || (len & page_mask))
> -				break;
> +			if ((start & page_mask) || (len & page_mask)) {
> +				err = -EINVAL;
> +				goto out_unlock;
> +			}
>  		}
> +		err = 0;
> +	}
> +	if (err)
> +		goto out_unlock;

If we a breaking on any error to out_unlock, why do we need err = 0 and
this check?

>  
> +	vma_iter_set(&vmi, start);
> +	for_each_vma_range(vmi, dst_vma, end) {
>  		_start = max(dst_vma->vm_start, start);
>  		_end = min(dst_vma->vm_end, end);
>  
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

