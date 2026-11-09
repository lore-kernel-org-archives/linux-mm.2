Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 94A7E606A321
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lJYz2A0b
Received: by kanga.kvack.org (Postfix)
	id A49916B05D6; Mon,  9 Nov 2026 13:56:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FACA6B05D7; Mon,  9 Nov 2026 13:56:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910E46B05DF; Mon,  9 Nov 2026 13:56:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6B42B6B05D6
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:56:29 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DC3071C4188
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:56:28 +0000 (UTC)
X-FDA: 85416486456.30.347F841
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3CE4F40003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:56:27 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lJYz2A0b;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794250587;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7IIG6gsWToOocYzMc8/wEygPBmXPfFlQcsTrLpdB5t8=;
	b=tcWZs8gHV66hBdMQ/zrKOQv7O3t/v6D4WxoxDdMfZWeFdpptPzuBTRgWIMNQSLFJ83JlAw
	8kSvXGO92ZwXyXg6dG/cB0dM58QDeJGxGDfRLAtc2DMm2xXmpN719U+gmUUHij6wF8uG7g
	QyA2oLlc61bR5+xc+Y0hq0GbKqsV390=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794250587;
	b=YXibOIt9zF9fMqbGJU+KqsXHrfOLSH8QR8qygEPEPkfRq7HSfE6FYek0TkOFVxhiytdApf
	AGfrRL8t+215gXfq2/z4PoY5Lwi3EvFrgZ8/Dygz1y1mTfrFLKD6LZ50wm0ZdThkymYUUV
	sLD+rJ9GZ6EC0n16pgrhtYgl7QNNeHc=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lJYz2A0b;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ABCE541891;
	Mon,  9 Nov 2026 18:56:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5281F0089F;
	Mon,  9 Nov 2026 18:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794250585;
	bh=7IIG6gsWToOocYzMc8/wEygPBmXPfFlQcsTrLpdB5t8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lJYz2A0bPFvD255SXUbUBOlu51qDSwePKYo9MZK23qpyFOKd2/4kC59kwiP6JQ2WY
	 jYC5Wq0L9db0MFa8yDrv3Sm6j9b7d6q/4w0pxI8dfHpZeJAmcT0hXSpIk6xG9lSJsC
	 JWQqy2jAdVog8NDKn019bUPIJZCRLQlexEkhxKEJ/xrelawoXfLml8RUpEMakX0vJI
	 jfhWoVzeDP94pvsi4JvVsU76JUhtohQ3TeqysfGZOiPwWfndrJqX33MTuWaKGJcMzo
	 3s6L3UxE5yn+63CZRqw2BEsXtJ/5I1cP0dZrS4RXIC4XHdpyHDtqV4DmcntkGLtI8k
	 KCbMfHVw8q0ww==
Message-ID: <sashiko-outbox-205453@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/filemap: let sequential faults restart mmap
 readahead
Reply-To: sashiko-reviews@lists.linux.dev
To: "Alireza Haddadi" <alireza.haddadi@it.uu.se>, =?utf-8?b?TWF0dGhldyBX?=
 =?utf-8?b?aWxjb3ggKE9yYWNsZSk=?= <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vishal Moola" <vishal.moola@gmail.com>, fujunjie <fujunjie1@qq.com>
Cc: linux-mm@kvack.org, "Roman Gushchin" <roman.gushchin@linux.dev>
In-Reply-To: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se>
References: <20261109-mmap-miss-v1-1-8b44b33f3358@it.uu.se>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 09 Nov 2026 18:56:24 +0000
X-Stat-Signature: 3ews3h8ajeexta4qn57wiy4eetb3jfe8
X-Rspamd-Queue-Id: 3CE4F40003
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794250587-241497
X-HE-Meta: U2FsdGVkX1/HAuiSUjtGkblmJtr6wjcWaCoQncjTbS3KiE7LvcKvknYd4X8K399DGflPdxfDMcuGgUN2Q7BoXe142S0AtTT01dFRb4ePG1gvfVI/4IJJELNdywDjPcbkUgSbQOochS4zBzoiaz1I2GzXbQP3TIW+HANA1NpLeCcQXnVOdZTssfQSZgAZ5flzLUBO/SR2l8oy7QypLmUOm6zEnXvcgdjEpsKAJk31Kt7c96CZ/m2kBYN4BARjgzZeHKYNRxVeqaeaTpgc5GIAok74TO6w8S+jv+n7XOilFjyvWXVQSUageCEfXo/hzM7Kia3xjpqZd8HZXRccGprkuI2J8L4dLPFHdxTUPHb/deM2F5jHBUqSjDJOXyf7XT+7wftaKLsdTWFkYE4xNrvrztWGNbIywlEQZRt/lUeYf1Wc9aa8CmeG9wOW/naRqeeqUPG0quN2ZK81PYySq0Y4KIO+iCHEX+CKEW74QSGxjPgtgE9kg/i1+X7Q7ZIxOql3Jgqc65PR62Oq+yrwIAZmLZpx0vHh7xhWqHIeSGyYV86riYw2uijFjfuL5FZ4o8wO/7m+62Z/SQJXBNzFoIjSUr0IiqDh9MVJKCgjbWKv8aM4qJBtRhofcjrbsz2Owe1GWGmTqU+R5JlZw0DUojejHorU1qgNKxrRWHBAmKaN/l+Rwp2PsIQjPOfGzNVcY/9nH9/5Xf3vO/jmgX0v4tzpC/tIJe9uNz8bpcDb0lCScGrlRzfgTzGfyxheDq5DoEnp4uMHsRY3fQ5SnWtKYTyPH3rG97s+jDXXM/5rE7CrqiYG5I+RyBZVmtTD3tzYSs2qpAKttZJzlc78svJMhDUL1crEjeqx/qZ678Jm48b57LFjmNnKHNHNuw1yPobMN7T5YdnaN2dVi23u9k3oqy6gJo7JnQiIma4TgcWNEtY+sFJXILat0bMNdQ8joaDDHkTGaKO6zR+xrgEAO98YdhM
 EW7GekWO
 MhHZWBw7OjF+PoQoOV0Pdc27w2kIdfoXpbbGyQp9LQaK8/wMrUt8uq63SsKe9Uq9qwUfU+k9cknjIl/pBb/PKul7V1cmHXMCfZDxiDdU9RYtxc7L+1u4L3Mz4StjQrsGYQeIORuAa07nuCGDoAPOzAb7FrKiARAkIa4f6K+9SHkTvahkAC6dAaEtVPYk2g2KM2fV0liObEqgG0GITP2CZCFV6smILVOKJrkayb5YMFho4KQV8bSIE0lBNtlkor2F+KBdqBwIgN6VahziKEGfyppWtICvH7LPdtJYNV2x2GkkFzWBVw/NH7j8MBEZ5J/CGlsQ2/38APwLNzRE4c15l9t7zd/vLYsqGtfjSbQehosWmE1z3CDKH4vGrfRvDeF1EYxzT9ZEfpP8RH71d9bo1YXrE8Dav+fB+jEvwFyUyIH8w103WhAvdA3Xdr6T+FBIPaBT+v5u8imvMo1RJvdQ+aHKY5dtswsGQr244LXgl5+PK+m3beZ+mbvcRnWcSOXT8bb3SNgrLssxlBGzPu4vt4UPTKhz3rEbCpt7VJXazVBDW48j6tHB0jnglz4XTrRcT5c4jwvocwGVFp0oRFMCPpJS84SnfklywRrSd5uDknXCpRy+8BeioLJ/P8nDyU9o8eSurGVkBfJqh2zlt8B+gPRgcAQO1KO7aw9V5FnoqMsbSlKs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm/filemap: do_sync_mmap_readahead() fails when
  mapping_min_folio_order() > 0
--

commit 6cc011b67fa27fb6f1bce2ab0a11aad698934f50
Author: Alireza Haddadi <alireza.haddadi@it.uu.se>

mm/filemap: let sequential faults restart mmap readahead

When mmap_miss exceeds MMAP_LOTSAMISS and the page preceding the faulting
offset is cached, this commit reads ahead one additional page and marks it
with PG_readahead so sequential access can restart async readahead.

> diff --git a/mm/filemap.c b/mm/filemap.c
> index 93db8fc60ae0a..0930aacee9fea 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3403,8 +3403,33 @@ static struct file *do_sync_mmap_readahead(struct =
vm_fault *vmf)
>  		 * Do we miss much more than hit in this file? If so,
>  		 * stop bothering with read-ahead. It will only hurt.
>  		 */
> -		if (mmap_miss > MMAP_LOTSAMISS)
> +		if (mmap_miss > MMAP_LOTSAMISS) {
> +			struct folio *prev =3D NULL;
> +
> +			/*
> +			 * Nothing is read ahead now, so mmap_miss stays high
> +			 * forever.  If the previous page is cached, this may be
> +			 * a sequential read: read the next page as well and
> +			 * mark it, so that async readahead, which does not
> +			 * check mmap_miss, restarts when the mark is hit.  The
> +			 * pages it reads then count as hits and lower
> +			 * mmap_miss.  A random reader rarely has the previous
> +			 * page cached and keeps reading one page per fault.
> +			 */
> +			if (!force_thp_readahead && vmf->pgoff)
> +				prev =3D xa_load(&mapping->i_pages,
> +					       vmf->pgoff - 1);
> +			if (prev && !xa_is_value(prev)) {
> +				fpin =3D maybe_unlock_mmap_for_io(vmf, fpin);
> +				ra->start =3D vmf->pgoff;
> +				ra->size =3D 2;
> +				ra->async_size =3D 1;
> +				ra->order =3D 0;
> +				ractl._index =3D ra->start;
> +				page_cache_ra_order(&ractl, ra);
> +			}
>  			return fpin;
> +		}
>  	}

[Severity: Medium]
Does hardcoding ra->size =3D 2, ra->async_size =3D 1, and ra->order =3D 0 w=
ork on
mappings where mapping_min_folio_order(mapping) > 0, such as large block si=
ze
filesystems?

In page_cache_ra_order(), limit and mark are computed in base pages before
new_order is clamped up to min_order:

mm/readahead.c:page_cache_ra_order() {
	...
	if (limit > index + ra->size - 1) {
		limit =3D index + ra->size - 1;
		mark =3D index + ra->size - ra->async_size;
	}
	...
	new_order =3D max(new_order, min_order);
}

When min_order >=3D 1, limit and mark both become index + 1.  The allocation
loop then allocates only a single min_order folio at index, and
ra_alloc_folio() rounds mark down to 1UL << order, placing PG_readahead on
the faulting folio itself instead of a second lookahead folio.

On the FAULT_FLAG_TRIED retry after maybe_unlock_mmap_for_io(),
do_async_mmap_readahead() is skipped and finish_fault() maps all pages of
that single folio at once, so async readahead never starts and mmap_miss
stays above MMAP_LOTSAMISS.  Scaling ra->size and ra->async_size by
mapping_min_folio_nrpages(mapping) and setting ra->order to
mapping_min_folio_order(mapping) would read two minimum-order folios and
mark the second one.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-mmap-miss-=
v1-1-8b44b33f3358@it.uu.se?part=3D1

