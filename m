Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9C80D111A8
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 08:05:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5AB86B000D; Mon,  1 Dec 2025 03:05:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E0B276B0010; Mon,  1 Dec 2025 03:05:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFA556B0022; Mon,  1 Dec 2025 03:05:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BFDB36B000D
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 03:05:17 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 92849508CD
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:05:17 +0000 (UTC)
X-FDA: 84170167074.19.6E81C8A
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf03.hostedemail.com (Postfix) with ESMTP id 8741F20002
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 08:05:15 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=l8LYok3j;
	spf=pass (imf03.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764576315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cFyz/Qk6kSqhqZv3xDyr1EG0kmvQ1cwCJUahn9SO5G8=;
	b=GGtfINx4uKfPbexMcL23y6lJHkgfnPvgJuYKZhCgWRfO92WSA3Cx65dvBU0iAgMdofRwZD
	DK3zn/vlOBAImJHMMSRqC5znlFGdYexAoeTs9LY4NT0RkYprjXOpldltgtMbLVTbVBJ/AM
	P/5frsxDixwhtpzkNWuGjU5L1hpmQVI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=l8LYok3j;
	spf=pass (imf03.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764576315; a=rsa-sha256;
	cv=none;
	b=7qesFMBVHYzs7rhGLm7HCrXZBHEhfZg50JEPJe+I5z0zswYzH8mOhy5KcSmxxHYlyNoui5
	WOn56M1Sq/8WBCw/m+WnKTNRkmk5ptziJU3Qd0tmk7Oge7lq9/WXJzRXSMX+ZwdQZbdff0
	YjpemvklPhWCFPYXAf7AURwAwko27hE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764576312;
	bh=AOGaPCVrzkgZmmb9BtWGyYN/DIDoq1iWanmV0V1M44s=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=l8LYok3jpLm4g5fxltRSyH6uFrGONRIfd8dZNss7W921eaCZVbddag1SUJJ9+x7Wd
	 v4jor1LAPe/fKVE9AcxvzBGC2VwaE8g/VpjBxLKiQi5W0r8vZcWESYAYIHXKVIaGV4
	 FOCBkOSXwNk6ZibxuXsqbQ/F4eYg5pHmIjf3i9p6r5WX4iPhwO5WprDZEtBEtLU/OP
	 ZDyOt/iNXXvL9teGdKTw8GJpWlCD1NnRePubQyLZJGvi7o8aa4MgYkPthTMYqmD4uL
	 BTg5xy7sU5rxtxk6+cG3PqB7WTOB7An6zJT//b4QsD4O37HcF2ZtRPpKKOyhgMIysK
	 VvT6wnLQQemZg==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 5A3C517E0020;
	Mon,  1 Dec 2025 09:05:11 +0100 (CET)
Date: Mon, 1 Dec 2025 09:05:07 +0100
From: Boris Brezillon <boris.brezillon@collabora.com>
To: =?UTF-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard
 <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie
 <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Jani Nikula
 <jani.nikula@linux.intel.com>, Joonas Lahtinen
 <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tursulin@ursulin.net>, Rob Herring <robh@kernel.org>,
 Steven Price <steven.price@arm.com>, Liviu Dudau <liviu.dudau@arm.com>,
 Melissa Wen <mwen@igalia.com>, =?UTF-8?B?TWHDrXJh?= Canal
 <mcanal@igalia.com>, Hugh Dickins <hughd@google.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Andrew Morton <akpm@linux-foundation.org>,
 Al Viro <viro@zeniv.linux.org.uk>, =?UTF-8?B?TWlrb8WCYWo=?= Wasiak
 <mikolaj.wasiak@intel.com>, Christian Brauner <brauner@kernel.org>, Nitin
 Gote <nitin.r.gote@intel.com>, Andi Shyti <andi.shyti@linux.intel.com>,
 Jonathan Corbet <corbet@lwn.net>, Christopher Healy <healych@amazon.com>,
 Matthew Wilcox <willy@infradead.org>, Bagas Sanjaya <bagasdotme@gmail.com>,
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, kernel@collabora.com
Subject: Re: [PATCH v10 01/10] drm/shmem-helper: Simplify page offset
 calculation in fault handler
Message-ID: <20251201090507.1ee10c65@fedora>
In-Reply-To: <20251128185252.3092-2-loic.molinari@collabora.com>
References: <20251128185252.3092-1-loic.molinari@collabora.com>
	<20251128185252.3092-2-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8741F20002
X-Stat-Signature: 1m5c417s5udixj6czj1nag7iqdyczirt
X-Rspam-User: 
X-HE-Tag: 1764576315-676636
X-HE-Meta: U2FsdGVkX18OhA/YfgkVdw7kEyjSlcLfZ55MaEmHDRfsRg5/bUrT8TIC/vbb+1YeyuV8sr18s9M40fyC+nfjLqXSeCSTzAGxziSpXMIw6vqdLNqYsg6LJ0AHYnFb6XKJUWUTrMdxfrZp260QwhWC2BZSKez/fMPrBC3bvDcKZxEpHsp/MUWtWL38rp1hQ4C6qIZ8tjdJr2ipaT6eiowPmwVzMxAIyM6jjHMBlEkUd1q6WexmFJb7qqjTNERGsokh7xJu98YJg4jJLXGYVEBnoIfsQ5BgCvE3Sg+GsFwkHmCKokWOTrtO1cxlLQntJP2Le1Nso9l1Ne4U7/smPFqNRqKTuGgbIc4sI0bge6jvBCY5JQvfBJIoEbwdntj/S31Ca8uUgiavAb8afPh0KgNnvxDc+IrrDWG1oFds97JHD1OHVoNNwzSCCrdqUBWypDLiz/hagaRCdc68x88+6709thhuFn2CR3K0I6yGhIJCJIZatDACoGZA7lIz9WcbGL5zbT4KJ0iKQoyA6cFbpvdIeW3tNyUqtDIm9o48ZK+GIgHB1uOXZlSRf+YNk4DnNGBMKpoprxzArLOMJmyBJxjltqKfCWwnr89Q3e2tD/0OAVW4aGRwG5TRCSDg0S/c5HDhpHt72fVYV4P/+O+mNuV/crp2UfCcaVrwpfPagNI/CoevlNpw8lGH5TU9+7gm/N8WZf9ByfR8DquywVg7Fn4Pnl3/pNObe0BfsA/YSbe4/39lwuDEUy9aYDBF2zwqsMuzKGCStT0naGGbuXJYwn6AApn7texRgeh5+yGo7kXwnetZZxECCLj5oZhXOdDOsC+2hzPahIVyB5+7yoiu3hhM/j9JYUgX8Av6kmfu1MrsKGjOKSFZG2z1yFAONEpRQNz17RZwtBLgZoaTs0c6PO2pXjKiiyGRE979cCxFjuVp/ZYrqXvsJyxogrmaW2OI4lcAME0iYtkQw/HNI6eX508
 M+yGle94
 jKqni51X6UGstgadbq+hKkSdCikplxUAnjLRqK3VNIaJ6eBmyeCX+JpA8o5csFqr2kZg1oMSagUvRlNVlGR1DSbNJ03PAyZe27kI4ifTMiTrZgzLnIRL2GzMKjPQjMagESsi7JnIRcRbm3XqwsdaPIphH00EFDDs2S8HqmMAVsK9BJzU5QJ8KXiLV5Y5thgpOBYJ/qOTbZx0H5qGfhg3Uy9i+p0HfpSZ7pdELKrcDotEXNuxMQiOSgWXuW0BmjjcBY+9qvc+mnEFL08P0FUAvbZ8aux2n/VhyR+QL3JoS7+INe44xKdb0+ptKywUVsrtEit7psUh0ORnFdLoKgsZ/etjCwQDDcFnnae2KMWVkb47R3AEYpZTZfuYjDsttQ4dOKpTXaT1ETAzN7nUxWyrhW3qoiQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 28 Nov 2025 19:52:43 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> For a fault at address addr, the page offset is
>   page_offset =3D (vmf->address - vma->vm_start) >> PAGE_SHIFT
>               =3D ((addr & PAGE_MASK) - vma->vm_start) >> PAGE_SHIFT
> 	      =3D (addr - vma->vm_start) >> PAGE_SHIFT
>=20
> Since the faulty logical page offset based on VMA is
>   vmf->pgoff =3D vma->vm_pgoff + ((addr - vma->vm_start) >> PAGE_SHIFT)
>=20
> We can slightly simplify the calculation using
>   page_offset =3D vmf->pgoff - vma->vm_pgoff
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

One nit below

> ---
>  drivers/gpu/drm/drm_gem_shmem_helper.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/drm_gem_shmem_helper.c b/drivers/gpu/drm/drm=
_gem_shmem_helper.c
> index dc94a27710e5..be89be1c804c 100644
> --- a/drivers/gpu/drm/drm_gem_shmem_helper.c
> +++ b/drivers/gpu/drm/drm_gem_shmem_helper.c
> @@ -577,8 +577,8 @@ static vm_fault_t drm_gem_shmem_fault(struct vm_fault=
 *vmf)
>  	struct page *page;
>  	pgoff_t page_offset;
> =20
> -	/* We don't use vmf->pgoff since that has the fake offset */
> -	page_offset =3D (vmf->address - vma->vm_start) >> PAGE_SHIFT;
> +	/* Offset to faulty address in the VMA (without the fake offset). */

It's weird to say "without the fake offset" here, because IIUC, both
vmf->pgoff and vma->vm_pgoff contain the fake offset. And that's fine,
the problem really is when one of the subtraction operand is not
relative to the fake offset.

> +	page_offset =3D vmf->pgoff - vma->vm_pgoff;
> =20
>  	dma_resv_lock(shmem->base.resv, NULL);
> =20


