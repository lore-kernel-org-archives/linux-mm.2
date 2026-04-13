Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4E5AEEBFD3B
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 11:16:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BE686B0093; Mon, 13 Apr 2026 07:16:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 995B76B0098; Mon, 13 Apr 2026 07:16:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D33B6B009B; Mon, 13 Apr 2026 07:16:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7F00C6B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 07:16:53 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 08B1187813
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:16:53 +0000 (UTC)
X-FDA: 84653280306.25.E8C8A31
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 47FFF40004
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:16:51 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZzKtNdJD;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776079011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FLikPFq1e0W/Y2Ci88LOqUlSKBOJue4Gg85MyiPf9n4=;
	b=z682UVPgdIOIjcNVQlUCsLmk+bfw9LAY0l6alK21qhEJzyjudBwlJGuor35JqRyOpdIyvm
	q4JE4aS+6Pn3FpP2L9hm+MWaHvB/e4SEEZe0StdN3/rJnK+3UemYqjJc1wiVlodwG+aWl6
	qPA0FcWDHjsRSyechuUemGnyQRVO9u4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ZzKtNdJD;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776079011; a=rsa-sha256;
	cv=none;
	b=dmRNokUwVZ5Atlh83zMs9Q7FsdlefkSw1W0YP5lr3bA0S6xLJXXB+91l9h6hbpCCeiHhF+
	43SB8sxbJBruSV8ufzFTCQukU7QpD5ByhJkoUhurjZ6IU0YypIHrDuzbLatbZguH+tfWab
	XCrTrXuw4I82niiu6vYjs3nb9AtJP1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 665B06091C;
	Mon, 13 Apr 2026 11:16:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78796C116C6;
	Mon, 13 Apr 2026 11:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776079010;
	bh=ju44g2f6nitaqzcqt3MrF4XfBN5G0lGaHkRMYsfWfiY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ZzKtNdJDBre26quVvPblkzY5izZDtEfqSiY46VIL1ePjpEBoozWvxlbyj09smAWdN
	 /COz2RDPaoVdUhZdIbTGIZTNWtaOOg638KVKySwc0MocYQ0wNA7WjtUDpoYtai8QZp
	 ut7BH3GoaZ9u+Ztv2gntRvMxhdE40OTND0hpmcaIf87IwbEhO+QFaSu1I3DXtS1iLg
	 vv6SIyCcLFyspET1gpvg5GM08CNpBnm+Zm9MxVx2Yhrahm5M+CldogHZs/prBl9LZi
	 C4MkCRzU9PU4DVJno7GJlo8l8gmKca9d/vV1VrLK8X0OP+YB5PFW0+UbFwB8yqiPOA
	 dH2iCvRIQzPEA==
Message-ID: <f33b1c76-52fd-416a-882f-316dfed69017@kernel.org>
Date: Mon, 13 Apr 2026 13:16:45 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-hotfixes] mm/vma: remove __vma_check_mmap_hook()
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
References: <20260413105713.92625-1-ljs@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260413105713.92625-1-ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 47FFF40004
X-Stat-Signature: udci6qqn3pc9eaiaem16ci3ktmafzg4u
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776079011-127307
X-HE-Meta: U2FsdGVkX1+X6tXVm9nJ6uy0E4lVTuu2luLaMYkieoIo2mAOXvLQSWg8WWgWGx9Nzi5NbE5soBJ5vCKf2pwXSR2jsJfBu/XIixKM8UEJbFHzwZTT2xlGDAAArvpcrdZ3hjfDy/+REK2MkOB55kJKzTqj/nPbLKYxiYRdJCr0FvuTNfGUxx49aMxQcck7u6LvGbXNHd8LRZtSDXJpj3tfvfWe58eBN15Pv/IKLKrnPKU8kN8CI3Hr4xS3ZLzWRrGXzTHESo97DHpzvO31wCVPNE23xkJB9TSendhiM3WIFssgEP0mowj1Qk6ei+186UQUKWz9R00Rf2I+wVYD8Wk5z6ThkuPX/jFxqqapMxDFWQdKgxVnFS5yiRNRJCw71sXU6vi5kmxsoU4kxkae+F18eGPTfDPHWFTVJJiXCw+HhjJYyOcBcwjzOCgiv0FPc6/6EMUkEKuVo9eglTHr7AiXQtXhfqye1e1y0nSm0OJAoEfky6c1qUURm1Zi3vOEErv3ZwOEREbRDDvAhEZtNYqRd5qiWQQ0fGoDzDytcW0pOatUyvDG37ruVL5PajhWaTjOOPGOITSP5d6M23gK8gZwcd+5UBatPGzhUovwNvcdG+28VUPF0yILONu5rS4vevBijhm4YL1wIYCeCKv6w6IXVW+qiTrmW0DltI1vBabu8zQNxTciEqeQ/M4NWrjEOiQHjD9kokTKprR6D4VHHWE6NjzKvQeepd9x5E4pIcgBD3IlQtRkuhDlwCj7XSW5MXG77qr1yu2YBN1mOZS8u/yqEf+h5lIfNUf2nJ8EOxZBxh7tDAE8ToPOM0OT81/1J0RC//s3ft0lsln4lNDNWk4v24P8QHYhpbaep+Pts+AXMMbMg3Z/0ot/t0TnwwgZxgihAMbr75ww+IcckcQdBnp5Me3K9upZ32c9QNWmPLz8Atrl69zz8BJafVimDpoaqCmw9CQSFDvYVEB7ekNLhnw
 s/wiCgjA
 yJ2jPgPNIrhTRw9v6PFVzx0MAM1Dy0bMPbNfmyK46HYOb5tk1Rk/2QTCWnhVB4yKpjlXW4WDdumQOATUxzcu8LHwJpYfPN+DD9nj02LJP7Ji3wforT9UWEzx/4ADyNjgONXmaPO3KMQSMM0Dhw1HuQS0RW5St9957khPZgSL3gQis100cuW45OBo17/uJQWOiS1P9Kjt8Ve+f2JD54PMrR6efddj0AB1avs3RYjF4r4bxLqnWsONXTwI6OMqEYR6TRVk+0CUUkhQv1BrZ9d894G8cOEwAgM3Je14DNDY1B65F3UEoj+h3bNv8fBXQipLGTaY5C/Mg8vOl/sMp7rI07K/eJh6YdQfNW3JAmlMw8hCsDdVjJV6n5yBk7f3XLwwHX4sza79EQJvIkTk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/13/26 12:57, Lorenzo Stoakes wrote:
> Commit c50ca15dd496 ("mm: add vm_ops->mapped hook") introduced
> __vma_check_mmap_hook() in order to assert that a driver doesn't
> incorrectly implement both an f_op->mmap() and a vm_ops->mapped hook, the
> latter of which would not ultimately get invoked.
> 
> However, this did not correctly account for stacked drivers (or drivers
> that otherwise use the compatibility layer) which might recursively call
> an mmap_prepare hook via the compatibility layer.
> 
> Thus the nested mmap_prepare() invocation might result in a VMA which has
> vm_ops->mapped set with an overlaying mmap() hook, causing the
> __vma_check_mmap_hook() to fail in vfs_mmap(), wrongly failing the
> operation.
> 
> This patch resolves this by simply removing the check, as we can't be
> certain that an mmap() hook doesn't at some point invoke the compatibility
> layer, and it's not worth trying to track it.
> 
> Fixes: c50ca15dd496 ("mm: add vm_ops->mapped hook")
> Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Closes: https://lore.kernel.org/all/adx2ws5z0NMIe5Yj@shinmob/
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
> 
> Andrew -
> 
> c50ca15dd496 is in mm-stable, so thought best to do as fix-patch? Will
> leave a small bisection hazard (unfortunately) so putting this as close as
> possible to the patch it fixes would be ideal.
> 
> Thanks!
> 
>  include/linux/fs.h |  9 +--------
>  mm/util.c          | 10 ----------
>  2 files changed, 1 insertion(+), 18 deletions(-)
> 
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 0bdccfa70b44..f3ca9b841892 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2062,20 +2062,13 @@ void compat_set_desc_from_vma(struct vm_area_desc *desc, const struct file *file
>  			      const struct vm_area_struct *vma);
>  int __compat_vma_mmap(struct vm_area_desc *desc, struct vm_area_struct *vma);
>  int compat_vma_mmap(struct file *file, struct vm_area_struct *vma);
> -int __vma_check_mmap_hook(struct vm_area_struct *vma);
> 
>  static inline int vfs_mmap(struct file *file, struct vm_area_struct *vma)
>  {
> -	int err;
> -
>  	if (file->f_op->mmap_prepare)
>  		return compat_vma_mmap(file, vma);
> 
> -	err = file->f_op->mmap(file, vma);
> -	if (err)
> -		return err;
> -
> -	return __vma_check_mmap_hook(vma);
> +	return file->f_op->mmap(file, vma);
>  }
> 
>  static inline int vfs_mmap_prepare(struct file *file, struct vm_area_desc *desc)
> diff --git a/mm/util.c b/mm/util.c
> index f063fd4de1e8..232c3930a662 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1281,16 +1281,6 @@ int compat_vma_mmap(struct file *file, struct vm_area_struct *vma)
>  }
>  EXPORT_SYMBOL(compat_vma_mmap);
> 
> -int __vma_check_mmap_hook(struct vm_area_struct *vma)
> -{
> -	/* vm_ops->mapped is not valid if mmap() is specified. */
> -	if (vma->vm_ops && WARN_ON_ONCE(vma->vm_ops->mapped))
> -		return -EINVAL;
> -
> -	return 0;
> -}
> -EXPORT_SYMBOL(__vma_check_mmap_hook);
> -
>  static void set_ps_flags(struct page_snapshot *ps, const struct folio *folio,
>  			 const struct page *page)
>  {
> --
> 2.53.0


