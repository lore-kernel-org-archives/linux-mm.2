Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59309CCA474
	for <linux-mm@archiver.kernel.org>; Tue, 30 Sep 2025 10:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B57108E0027; Tue, 30 Sep 2025 06:37:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B07818E0002; Tue, 30 Sep 2025 06:37:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1D448E0027; Tue, 30 Sep 2025 06:37:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A1C78E0002
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 06:37:43 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4FEFA5A437
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:37:43 +0000 (UTC)
X-FDA: 83945565606.29.0C5765E
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	by imf15.hostedemail.com (Postfix) with ESMTP id 6A12BA0008
	for <linux-mm@kvack.org>; Tue, 30 Sep 2025 10:37:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=BcTwBBrW;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759228661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Nc2h7glBxt5xx7n96Lm8Ls8CG8CiBezBcmaA0eivQdI=;
	b=tEnqkV8C60UWHNVhEm5DWkyoHmffKvhHwANt+x5DjrmaEQjrZ6lpSrUICP9F3d/RmnXeP8
	Ml1/TROOH4zNoDTs1NWxKEwqxQ8v5pjQONKqkYz9q15udjVvrtgyhaW1m3P/H2wuGA161x
	yyMauo50lrKZ2wrfzWrBGSpFD/BEps0=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=mail header.b=BcTwBBrW;
	spf=pass (imf15.hostedemail.com: domain of boris.brezillon@collabora.com designates 148.251.105.195 as permitted sender) smtp.mailfrom=boris.brezillon@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759228661; a=rsa-sha256;
	cv=none;
	b=4SZjXHbB3/D+lpDH0xU8U41EWnisotLN5pyR8GSmCcPFxUaBJU5LP/GYc63jvrcs3AHvtw
	W28t86lJaPjFnEnvao8cgjJJWj/4CidMemSU3mOYGLMcX2ek0hhpVYteo7bZaLm8WfRsVw
	dgLN3YO/HiqehQDlJEU/HGjYhlSvx5M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1759228659;
	bh=MMIyOgdHnuGM4uEoQQLpGnCP70/OAeedxU02J/5zTEg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BcTwBBrW+yRD6eriWbZ42c2oQO0j0hHeqx5JV8UhHtjJWUIV9QhoSoxmg2XpIDyms
	 lz4tNqJJXoIRt/bUJ48xHdLS86A1CwPFTFHKkOzuulzseeIHYklcAYoKneep4Rs2A4
	 QamQa5Sp313UMIvSQGLQtKA5d9jkwmlKfKZr57hSEVSrLgNV48osU8VZP+O+RM7XaB
	 VpZrQl1XhODJLADRUsuW7dNaJOugL3bRX7qvCmoSOZhl1wp+cYo7nWgfct6opzmWKu
	 KKDbmEhiIKqKi2PsDE0Weo3zTPGgd38cpmHb3DB1ZeZSel/nuOIhaYysMN3VXUnGzA
	 skvbg3IV8yilA==
Received: from fedora (unknown [IPv6:2a01:e0a:2c:6930:d919:a6e:5ea1:8a9f])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bbrezillon)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 19E9417E124A;
	Tue, 30 Sep 2025 12:37:38 +0200 (CEST)
Date: Tue, 30 Sep 2025 12:37:32 +0200
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
 linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
 intel-gfx@lists.freedesktop.org, linux-mm@kvack.org, kernel@collabora.com
Subject: Re: [PATCH 7/8] drm/panthor: Improve IOMMU map/unmap debugging logs
Message-ID: <20250930123732.43e6987d@fedora>
In-Reply-To: <20250929200316.18417-8-loic.molinari@collabora.com>
References: <20250929200316.18417-1-loic.molinari@collabora.com>
	<20250929200316.18417-8-loic.molinari@collabora.com>
Organization: Collabora
X-Mailer: Claws Mail 4.3.1 (GTK 3.24.49; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6A12BA0008
X-Stat-Signature: iaxpg7fqgoyknw416tojyxxymr1x8zer
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759228661-473140
X-HE-Meta: U2FsdGVkX1+Fsj+EC+GpuUFm/r/+8wJdmVR22GE8TJWNKarQ7ACpWzPRRDxTnjhzYTYyBMfRq/Lw528yq6ZYExOdW35p5ntm/U4uyd2D3fZkS8RCLmwpF7X3E5KOD6XYcChj0nsXK3PQxBbRZO8j3pvDO6u5G1/k+JrjaSsxLdN+VdVswVxW4R/6ex4XDtkpGXnpnxeHnSHaXFCeIuEEjS3yyEm+yFWB2LdanL4dvmfMgvx4whRxLZ+NVsRCw6i+wbx9ENbCBq3hlMFF8FaujkdWmvINg46Qz7ZK+iXxsZZaL8lAHcgYrmI6NxmlufoCTYoqoL4oggFEV9EsSBBMq/2tePKkkw9iB3Rx6yjnCshECxMhb0zsDBi+qNUpvVks7WZLnmRYQJrtl6aiW3oNpvhmlv+yNSVuK85OL1HXM6KW5MtT2yqHbChdcv9YmdGqlKUT2p6BPU55bL3/b1cL3qwe7D77Rwjabum8XDrYLsoaAp+6ZAyrr8Qced7GzNDSaKDW7NVQexcWuz51M9tWis7+DxRaXs5Y7RqBg1D7XtNA48J071mnZGbOkbur0F9H6/Lqvo1O/+S2h4ZbpTFOMLpdzChZBMORbeTAk1NObMSzKPPm1EXsMscqSm8wXUw16uATa9ltvnTLZ1RbYTKdSwoSloR4ugDE7y0s7h6IFpVJ/2q27Ue55bIMVnVphUJRzSYe2e4jjMcpQaMTZIVeDxESDfmDyyEq2X2MFmAlj+50ef9FgxlJgyLtWX1Ih8Bxr/tTsVMzY8n/QxXn9Ck45DNFVjNr3/IU3UR2YAgYj8J7FAomBmCE86QR7d6LIFr9bpCnYwJ5P7mE1i4JnEG7wXBdgXuJ8cXzG1TTyV2sR0Ovs8R8HUF6QMoNdlWY89yXPPe3mcJpVYIdCoDc08RGjIKdaKSElhk+++q5B3swr32oIVNM+hTMUlePPnYAayIkOm0QtRk0LsrtKm6NA4r
 tQYyz3lJ
 nm8jFn4EtLiRuqvee/Ffl8Y/xSwKJCx/0X41Njy9SC/j4VK4JKJCFjn2MyZW/h08TmYH+UnlT+zOChydiMEHhpgGpXhfQnb9xD1PiULtOpcVaecv9bmXAUWowAkjH4AleV7ZI0vvBpkNhZLA7ovFiv0dObVJr96nQ/elVpah26w7S9TQu4RdgUQUsp+yV1e453BecrsdVMwZ32MgwxCAsIIa+IlzcD+8uBTm4qz9kTZfcYdhPnDQ9LWvISWCAVVRuVViYGk3RfV2wXqU57QlGR66ELN5kXv9owU4i+S1Urp6pRDeBPMXU5PYjqrZan5ucprvtfBIlE4FNncG8LpE5tZzCEbZigT/t99OG+R/bAqEf01X8ybPB4w9WWPc0/IpdMuVHU75R4wSe0aOOYoKKxYYAgA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 29 Sep 2025 22:03:15 +0200
Lo=C3=AFc Molinari <loic.molinari@collabora.com> wrote:

> Log the number of pages and their sizes actually mapped/unmapped by
> the IOMMU page table driver. Since a map/unmap op is often split in
> several ops depending on the underlying scatter/gather table, add the
> start address and the total size to the debugging logs in order to
> help understand which batch an op is part of.
>=20
> Signed-off-by: Lo=C3=AFc Molinari <loic.molinari@collabora.com>

Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>

> ---
>  drivers/gpu/drm/panthor/panthor_mmu.c | 19 ++++++++++++++-----
>  1 file changed, 14 insertions(+), 5 deletions(-)
>=20
> diff --git a/drivers/gpu/drm/panthor/panthor_mmu.c b/drivers/gpu/drm/pant=
hor/panthor_mmu.c
> index 6dec4354e378..aefbd83d1a75 100644
> --- a/drivers/gpu/drm/panthor/panthor_mmu.c
> +++ b/drivers/gpu/drm/panthor/panthor_mmu.c
> @@ -917,10 +917,9 @@ static int panthor_vm_unmap_pages(struct panthor_vm =
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
> @@ -935,6 +934,12 @@ static int panthor_vm_unmap_pages(struct panthor_vm =
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
> @@ -950,6 +955,7 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iova,=
 int prot,
>  	struct scatterlist *sgl;
>  	struct io_pgtable_ops *ops =3D vm->pgtbl_ops;
>  	u64 start_iova =3D iova;
> +	u64 start_size =3D size;
>  	int ret;
> =20
>  	if (!size)
> @@ -969,15 +975,18 @@ panthor_vm_map_pages(struct panthor_vm *vm, u64 iov=
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


