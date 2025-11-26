Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42D81D10397
	for <linux-mm@archiver.kernel.org>; Wed, 26 Nov 2025 10:10:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D6176B0027; Wed, 26 Nov 2025 05:10:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 986DE6B0028; Wed, 26 Nov 2025 05:10:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89CAF6B002B; Wed, 26 Nov 2025 05:10:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75F256B0027
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 05:10:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A43E140493
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:10:54 +0000 (UTC)
X-FDA: 84152339628.08.54C86FA
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1565610000A
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 10:10:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=BTGwNJiY;
	spf=pass (imf05.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764151852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7TlZdzh0Z86tFDvUK4lv6HBgPD1jjvywjJZkBRmnDQ8=;
	b=D0DBNDciDlwfBj89e1YnbCPwQUMDbZFkNtSqBhdT3S34XD7A93rU9BximO681EVXIsGE8H
	hGxL94uA7couCOe6eXa89AcZTUyG9An5zxE7FFAfHkBZJxBowb926rvxuv0tnXxLnjJute
	ZX+eqxW0m+NOE+WDrrIyJ2sKAysRGbc=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=BTGwNJiY;
	spf=pass (imf05.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764151852; a=rsa-sha256;
	cv=none;
	b=W7SJ86qJph7zhd5ZlSKmMnWQhq3aBW2jVw6RbDon9wn9O40pjZmztSAAZeo5zlaTuIhCvB
	qmuXKKgDA4CIi0arLsAzO2J75ERMJktovGkD6+L/BtF6niZoAD3UhPkrMsv5pzZjUIo14n
	qbnEMC9tLwWQID2q54xnRDv+cjfrMKw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1764151849;
	bh=ecJ1vGlyPj6hsCofjHA7b6XDNSRT7xhJLj2BkLxAf6M=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BTGwNJiYhH0pw6GB3bsWRZFrAfxZlQsY1XcuEL3zlNWjVHArUqmwi2Hmr9H0spuYR
	 ZZLN8ys30zhBHkvnwuv0MKYs3j2MayURZg1nfvQj5Y4SfOLRj6Pez/y7IfBn1pylM1
	 cJqj73uPzEbF1Bw70LjOzOLA1MpiTPezmO1B5FvasUQqo+0u9dm8piYmTyL/ParorP
	 Bsp8pqlHveaqQfQR8+cI2S2sRFvucsZrCuUUbiIE0g79lQfF7L74VOl3eJ0IHL+lNs
	 X2GqZWDiZ+gtHSazhxFkL8ABfWHWgkf5YvUXT39/hblLTtJvYreeuprfcmj/tGpnHI
	 /WoTfM4zP4pHA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id E4EC417E10E9;
	Wed, 26 Nov 2025 11:10:47 +0100 (CET)
Date: Wed, 26 Nov 2025 11:10:43 +0100
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
Subject: Re: [PATCH v9 09/11] drm/panthor: Improve IOMMU map/unmap debugging
 logs
Message-ID: <20251126111043.145e1aa2@fedora>
In-Reply-To: <20251114170303.2800-10-loic.molinari@collabora.com>
References: <20251114170303.2800-1-loic.molinari@collabora.com>
	<20251114170303.2800-10-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.51; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1565610000A
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: k6e7xsurxjt8jby4ydffju9ajod8fk6a
X-HE-Tag: 1764151851-353012
X-HE-Meta: U2FsdGVkX1+e0UcJVmzrH8I8GFXYpfezwhRa5C3tegR0ByXRsr0JLsFLESj4bn9bBqfq5QGb3vIvYWZJkOoIL40d2ESiQ5ga+r82MWAbjgq75Kye4Wy/cWNl19v8KLYrF2CKb0RKLSlbRRRT0fpbCBDJZV5ZTber4EXRFWlWBxJa0FILL9qzE6TKKxy/nETNs+bcqTG2xGOVAaisA5x8XhPPrMMmxEAfu+tEQ3IeNKHGzTlDamt0FuX3RmBKhCfXKJQ6AES3DrlZCg1WDerE46xItdU367Q5xt0X/zHUIDrrA2xp4a2sbkimJJuOJ+pbgIfDH0O6y2hQYaXE7jFlo67zL6UgCQo5FDiJtl9C/MT/V8Uo6Lyp5988vq5P+CaiszS5y6AZK2DsSWQj+ULnTwaKzCxT2ADXc4iKrV5VHyg6EVFSnSZsEvdWSYk2H5Ro4xRX5Vf0p64XBWo5cdg2ycKegumJNZZ7p9tBdEtm/JRUCI9JYuzhK5o696ORp/ao/ObPTfGiqefne3NwViEKZMy4826Rgj5SuDE2MxtnZnoxH7YRcgeL3lzl1+txni/Ov8Zxu68VoTFD57hrtyUNRMJLu298ag74k9NY+7wu8ZR9DkFrXkual3J2EWyGexgxodaZrGDiqgBWlgQUhvxgzwbCtx14lFGKopqm5Z3GzWJZ68pqVT0GukyYTil0/2bN9SbgxQoN779smrNfNiqTLqu70PXX5OvC6bBCjl/87WcJRCI8g85B5NzNZa4AM5S6Wcw/2uufL5z9j678B/U2pQW2A3RYc5snIefXC4wsMEHUHs+w/Ho8wrD8Shh91+oWup0QdEP3tcdW/qP9d+x/yMUj/lVJupLic/7GWZzD6/Ca1feHl+O0XqqbEJS9G/rRz4G+NmAmOAC5m8Yk0MOSP/iC5Udq4X3WtXDhZ2RF0f9vONzIcseuEjU/G5fLZWMYyrxFQiw0my5uAvtN574
 L4gb1oxm
 p5ttRRDBEjn7M4FXuT1FoG7ScACGGOj6dUVveNWp067JKwQ8I0ULDcNW/ZzvCxukqrsRTfJhJfdVtLTipvj6Ywnah+ezKf/ybxg/51qmlhL5RvJrQUF/MMf5UAOdso9HGae2Z72dah+vww2uNKoJpCvVvO20hS0xzXzTI6Pp3d+2+hvhreaJZgANUOMiO5zizqyA39aOyruziVkq9/iu63RmYLBMrVkmT4rFffyTuvfiHNCDO5jE6Z7Ba/CO+iIzvsieUST0u95QxEbUfRUlF3L+zZ7i+WGJPl/ToqtLv5CaYKVANtX/YZJUVQq7ctPBQHd6DkzV5bEhbsrOG+6zJ7RiTvSqACdrFzrTFmpODrN2lSsMAAK1qIh4VXrdyEazBKBkEFgqdQXxll8xuTNz1juZXPg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 14 Nov 2025 18:03:00 +0100
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Log the number of pages and their sizes actually mapped/unmapped by
> the IOMMU page table driver. Since a map/unmap op is often split in
> several ops depending on the underlying scatter/gather table, add the
> start address and the total size to the debugging logs in order to
> help understand which batch an op is part of.
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>
> Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

Just queued this specific patch to drm-misc-next since it had no
external deps. Make sure you rebase before preparing your v10.

> ---
>  drivers/gpu/drm/panthor/panthor_mmu.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/pant=
hor/panthor_mmu.c
> index 58fead90533a..32410713c61c 100644
> --- a/drivers/gpu/drm/panthor/panthor_mmu.c
> +++ b/drivers/gpu/drm/panthor/panthor_mmu.c
> @@ -918,10 +918,9 @@ static int panthor_vm_unmap_pages(struct panthor_vm =
*vm, u64 iova, u64 size)
>  {
>  	struct panthor_device *ptdev =3D vm->ptdev;
>  	struct io_pgtable_ops *ops =3D vm->pgtbl_ops;
> +	u64 start_iova =3D iova;
>  	u64 offset =3D 0;
> =20
> -	drm_dbg(&ptdev->base, "unmap: as=3D%d, iova=3D%llx, len=3D%llx", vm->as=
.id, iova, size);
> -
>  	while (offset < size) {
>  		size_t unmapped_sz =3D 0, pgcount;
>  		size_t pgsize =3D get_pgsize(iova + offset, size - offset, &pgcount);
> @@ -936,6 +935,12 @@ static int panthor_vm_unmap_pages(struct panthor_vm =
*vm, u64 iova, u64 size)
>  			panthor_vm_flush_range(vm, iova, offset + unmapped_sz);
>  			return  -EINVAL;
>  		}
> +
> +		drm_dbg(&ptdev->base,
> +			"unmap: as=3D%d, iova=3D0x%llx, sz=3D%llu, va=3D0x%llx, pgcnt=3D%zu, =
pgsz=3D%zu",
> +			vm->as.id, start_iova, size, iova + offset,
> +			unmapped_sz / pgsize, pgsize);
> +
>  		offset +=3D unmapped_sz;
>  	}
> =20
> @@ -951,6 +956,7 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova,=
 int prot,
>  	struct scatterlist *sgl;
>  	struct io_pgtable_ops *ops =3D vm->pgtbl_ops;
>  	u64 start_iova =3D iova;
> +	u64 start_size =3D size;
>  	int ret;
> =20
>  	if (!size)
> @@ -970,15 +976,18 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iov=
a, int prot,
>  		len =3D min_t(size_t, len, size);
>  		size -=3D len;
> =20
> -		drm_dbg(&ptdev->base, "map: as=3D%d, iova=3D%llx, paddr=3D%pad, len=3D=
%zx",
> -			vm->as.id, iova, &paddr, len);
> -
>  		while (len) {
>  			size_t pgcount, mapped =3D 0;
>  			size_t pgsize =3D get_pgsize(iova | paddr, len, &pgcount);
> =20
>  			ret =3D ops->map_pages(ops, iova, paddr, pgsize, pgcount, prot,
>  					     GFP_KERNEL, &mapped);
> +
> +			drm_dbg(&ptdev->base,
> +				"map: as=3D%d, iova=3D0x%llx, sz=3D%llu, va=3D0x%llx, pa=3D%pad, pgc=
nt=3D%zu, pgsz=3D%zu",
> +				vm->as.id, start_iova, start_size, iova, &paddr,
> +				mapped / pgsize, pgsize);
> +
>  			iova +=3D mapped;
>  			paddr +=3D mapped;
>  			len -=3D mapped;


