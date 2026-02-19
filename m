Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7CDA9E9A04C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 09:16:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5310E6B0088; Thu, 19 Feb 2026 04:16:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E7EF6B0089; Thu, 19 Feb 2026 04:16:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0AE6B008A; Thu, 19 Feb 2026 04:16:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 26F496B0088
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 04:16:48 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9A462C1965
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:16:47 +0000 (UTC)
X-FDA: 84460651254.17.DE199FD
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4B2DA40012
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 09:16:45 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gdLjRFsX;
	dkim=pass header.d=redhat.com header.s=google header.b=O5Qf49K9;
	spf=pass (imf11.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771492605; a=rsa-sha256;
	cv=none;
	b=XfjYOCc97FxNxE/uKBVuu95+CThQlgslR2i9X6BDOl8BKTVwQVLt68rPXJ00HGHwrDPKsG
	vpOhsqXom4/YKZKXmUJ0G+1GnDMCI95Jw9VgFQ2NynVhurfxevwx5lwbYQjfYsChMipQqK
	sIDY13oiMO5i/L2Nqw7tUFHrjaOLj9U=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=gdLjRFsX;
	dkim=pass header.d=redhat.com header.s=google header.b=O5Qf49K9;
	spf=pass (imf11.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771492605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FvCQKIeQDulHEvNvZG4/Rs7O2SMt0AI9xdkS+RkTuNc=;
	b=pLW8pt1d8ndT6Id1IFZFWnPAaU0xYJfvS7ga3PinC0BYejgllpwDssN7fZptY7UPc0equn
	TIkxxPkvmwjZBq3KzItxwHOwum+yGl66DDrbOi6UXtnGxAZAGUIUmSBzPKYqkTDqF+DweF
	OhANh1JWhqVlQqhCI3FVEq+lmAjEtgg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771492604;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FvCQKIeQDulHEvNvZG4/Rs7O2SMt0AI9xdkS+RkTuNc=;
	b=gdLjRFsXBwRCHj3Iht0T3cGD+c/Pd6f5uaCN5TXaYywCa+VcHlpZJLKIjPGmhK4RXCf2Bv
	3zk5UIyoPyASlS92YYOCIEze2S04tsjZm6VRSSwV1ZA4g8GMuu7n//b2AwMj64QbsbZ1vG
	nx5ZW/U9x26yebXf2QWRgm/dZ9S40vE=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-i_AOXmPTPx2XSaBXuoQ-qg-1; Thu, 19 Feb 2026 04:16:40 -0500
X-MC-Unique: i_AOXmPTPx2XSaBXuoQ-qg-1
X-Mimecast-MFC-AGG-ID: i_AOXmPTPx2XSaBXuoQ-qg_1771492600
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-4836b7fbf4fso6560475e9.2
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 01:16:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771492600; x=1772097400; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FvCQKIeQDulHEvNvZG4/Rs7O2SMt0AI9xdkS+RkTuNc=;
        b=O5Qf49K93uHzARxgCJ/UNbZEYODJPeZjVce/qbSKPa2XXGzfRhMPt0pfjakbrbKY79
         qmhGx6Z0BxdYSUu70zqMv96vfsoja8ZlAAAwHTvNDNRRlqSvMI8/OolfRa05eCP+QK0Y
         nJ+an8BZXlHYILQFtgYbuFHc0o6jaVqnmi9ZVKHPQ+PITlGGhRgr1W/WJMZwhYOovFSi
         uDw2J1Q8mqReMqcEG6gJAbVvtndYFZuft+qhXexXV2NOyNXTHZfnWI0n14BIxsvdTf1/
         HjnnZLpa/s4FFgquzVMtkKHMxYrRvbCELKNpXhDwFbTnE2GUp2NlnDJztqvUzqWrds/2
         sDhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771492600; x=1772097400;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FvCQKIeQDulHEvNvZG4/Rs7O2SMt0AI9xdkS+RkTuNc=;
        b=iB8XwvIP3qWbeOxEimiDcAGH5QDkk20QSWzYbfCEs++DVtAUz8YS448wIoVO8NVaFd
         ev0x/xjGu7LjorkfZsA2c7pxCtLsn5JdN+yXVY+Ho+6+Zwm27tu898N7Yn+UD0DHGbzz
         +jcbAseOex8/ACP45xyTXLpgbAhNtFUUFyCLMvff0yuRFO9yvXC4vWlbJZARxNoGA5Wb
         QPcusrLVlmyfKt4pBcoeCTmB8juNqa3OUJyQL9MgPknJ9bAvGZa+QdwkWaOZcJ1aJV0N
         nIQzUjXAaI30nNbQcEwti0GzRz48mLomOwF+mIBVDmXVK1VpcQ367g+jP74TygJZOujS
         Sy3w==
X-Forwarded-Encrypted: i=1; AJvYcCWFhZgoWzpPOs/fHLFgxf8jHRJ9mGcknubH7E7m7N7X6hUwFE7opK9yfl9nlNdue6KzzU1Gu7DqUg==@kvack.org
X-Gm-Message-State: AOJu0Yw45batdDy62E1b23xZxKzUs+3S6GsD1niUQs0YJzF9E+QkF0oS
	mdn/VeilUajPiqLZ+apBVMt/vVXcGjG1Hz+gKhYywCNn4W+4SN988hTebNuMLiQ6GEyr/vOp3ew
	zVh2mpYHo3u5zYuzuFcBv3rAI7xAaOfCArtnFLrGSsk1dnEv610Id
X-Gm-Gg: AZuq6aLhYGz6S44BdjH3sKNI1513M5DCPj4pJ0ASfq9Nog/ejZPgvF7erWRcx2u4fRI
	80aZxNA7nDwW32TC7o4uemWnLqoQlmhy1j2jJstr0vF10dRKHcl+J3QuWvOjl71k5SNKxjyC+xd
	e1Tv6f4L1dEyIOS/dC1SnuvlOQCwXxMxXXeUgz2hawDCgXC1ZlF3PbJPnSDTahXnJHapDPp4jyw
	uOUNdHfix5Bc/+TT8MxHuwAGeS+eM0+A2/XZGANPVZ7Mg5bA984hJbx4zjxb9JEZhWn2Gw5txCK
	lvFdYNMQ0BK+lvJMaT+IvbKNxyi/GnUPBK1zt3aAHojZ1D4kSNTGxFz9aNrHCLlCvREiGejtYw=
	=
X-Received: by 2002:a05:600c:8289:b0:479:3a89:121d with SMTP id 5b1f17b1804b1-4839e66fc83mr23233355e9.36.1771492599582;
        Thu, 19 Feb 2026 01:16:39 -0800 (PST)
X-Received: by 2002:a05:600c:8289:b0:479:3a89:121d with SMTP id 5b1f17b1804b1-4839e66fc83mr23232985e9.36.1771492599016;
        Thu, 19 Feb 2026 01:16:39 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4839ea1e7e1sm14492695e9.2.2026.02.19.01.16.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Feb 2026 01:16:38 -0800 (PST)
Date: Thu, 19 Feb 2026 10:16:37 +0100
From: Maxime Ripard <mripard@redhat.com>
To: Eric Chanudet <echanude@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, Albert Esteve <aesteve@redhat.com>, 
	linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] dma-buf: heaps: cma: charge each cma heap's dmem
Message-ID: <20260219-illustrious-tungsten-starfish-5dad8c@houat>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <20260218-dmabuf-heap-cma-dmem-v2-3-b249886fb7b2@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="qbjavhllvvchwpql"
Content-Disposition: inline
In-Reply-To: <20260218-dmabuf-heap-cma-dmem-v2-3-b249886fb7b2@redhat.com>
X-Rspamd-Queue-Id: 4B2DA40012
X-Stat-Signature: tzqqymx68fxcb4itohoztq7tzgnpeurc
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771492605-372804
X-HE-Meta: U2FsdGVkX18nybbJMSFS8mOZBJ973J50EFitvoKJvzmMjlH5377tmVBDRfO7CJM8mz7dn+CchrpbvaWefMkOjwgb7yKpQtMqFZRaVi+7TLG4PlmjHqoDWULY6P7BVfKuIeTaAt4dyAZpgf2Ld0lStzAWMf8+nOunt+qE2dZ/gl9YwIVk+mQEsX0oLuq5IvHb5thWToYt2xTo7uI3/sD0merihPIfh916DqZCG55nPBEfWiOot1DQpdXgFwd0xwPzO8yWnOV6C6K9GcJrqdzgERth2QmtRn9zqaNTaIuFlvw/w00pL6NtKNe4b9X5HY8HOsEtR25Hfytaj0L7xLrj8nZZGE4DNhU+EPyseDpLmVSiOXEhGsQj1w/wdajHHoWI7wa9hjKZmuLkVr8idftqHGXOZB028RT4cjofcA1jM4FOzdvhtyTr3CIBWOWZ2JnnmShSa+7byWjsQkhNXZRt2x10OeSE0SeRKdNqBjXJ/eEashRm6ZzcSrm8FMUhIjFeNsPwL05FMM5CvtGoq5MYPIixqhmozKqdP4qcTMrTTpfV3o9BEA2B6zn5NjPJWSpYUqaq6gwo1glshdMz3leQAsfHt6b5dtjV4O209LepXPcE0HYg7uxVSPZz3+FXEvn3P3Wlb4ZJJhqN9NPwGYQ70Vs1V3hQIHimNaYOWTK9llExzLiNvM4LQXWhqbQAf6BKc+rNDjRmzJi6RVt3Mv4rOuM7dTS9Rl9m6Mx7P9fsmST71bMH5/onOhzLYeBFYaCup1YPzTY9/hqaO5eX6vJGCQriZsVg6thF6r0vXoPgDcgDCtefIKgDD7VhNi3sbFLRa4UQ6KgbaHOZ4QC7k5l1XpVp601dtY3hFAoVk4akNmRBRfogjJmmUuNq2d10+bSNUuNaSMafuzI9G8SVuVScibiwCK1kPNbOM16JfKFJX+/LbK/ukuqvWnVSM94S1N/Z/MRwHpEdf70O2DUOelG
 sLVOguHh
 kAVTEPno3fB39cxagz7Kuh55Myi1jSmpgfEx8J3PGqQWYsv+6CToMgXjYx089DmVNY3MhR9D16xDAlV9674Tf3u3MFIyGrrzVhDANTSRC6KtPpjhFXjOZQAgg20hiNewfZ8uZoXoBcr8W2L7eXR6nUDJ985FW1qoO341XsBgwN26MuVyOAmun0hVLnAVQxlUDd4dygmQrrEvH4OUYcxwdIWWokBrKd00DiQP4B7yc/wUQ7+21D8jFMt0SosvgNvsMpmakeY+sHhmvZg2wZT7TgnUPS15sfF3ABan1AvkkIi+PTzdFCjuypbg2LioCvx7XEZlqA5GwzEqgSvxwMrXni/o+VYP9yyFmj53W5UpAh1lTWH8dCV6rvrmASw9MOF39yM0U7MuHq+4eUy89A63k6LVdgB5FhU8Nao/Bzw5xEn7sLS+MiieGhkr0ZKTWGzTvDLPZk1rulsg3+LPxBoFLREdnqvwa0jhdV0lcZoOagGUDehRK/7c06fOSH77+4EApcXpEexeTn5k+ElIsEiVQZyA0XbVuJ2eGD2gTC2f50u9vviG8z2II6pLiQEwOKjlhZg/W0ktincp13ZJejZCcOmGmFSTbn2CtHCleYYNZ/5SEQDG9S6LIdQn8+zF2m/b6dFySzj8UlAg5ht1NPrjXDc1aTg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--qbjavhllvvchwpql
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 3/3] dma-buf: heaps: cma: charge each cma heap's dmem
MIME-Version: 1.0

Hi,

On Wed, Feb 18, 2026 at 12:14:12PM -0500, Eric Chanudet wrote:
> The cma dma-buf heaps let userspace allocate buffers in CMA regions
> without enforcing limits. Since each cma region registers in dmem,
> charge against it when allocating a buffer in a cma heap.
>=20
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
>  drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
>  1 file changed, 14 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/dma-buf/heaps/cma_heap.c b/drivers/dma-buf/heaps/cma=
_heap.c
> index 49cc45fb42dd7200c3c14384bcfdbe85323454b1..bbd4f9495808da19256d97bd6=
a4dca3e1b0a30a0 100644
> --- a/drivers/dma-buf/heaps/cma_heap.c
> +++ b/drivers/dma-buf/heaps/cma_heap.c
> @@ -27,6 +27,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
>  #include <linux/vmalloc.h>
> +#include <linux/cgroup_dmem.h>
> =20
>  #define DEFAULT_CMA_NAME "default_cma_region"
> =20
> @@ -58,6 +59,7 @@ struct cma_heap_buffer {
>  	pgoff_t pagecount;
>  	int vmap_cnt;
>  	void *vaddr;
> +	struct dmem_cgroup_pool_state *pool;

I guess we should add an #if IS_ENABLED #endif guard for dmem?

>  };
> =20
>  struct dma_heap_attachment {
> @@ -276,6 +278,7 @@ static void cma_heap_dma_buf_release(struct dma_buf *=
dmabuf)
>  	kfree(buffer->pages);
>  	/* release memory */
>  	cma_release(cma_heap->cma, buffer->cma_pages, buffer->pagecount);
> +	dmem_cgroup_uncharge(buffer->pool, buffer->len);
>  	kfree(buffer);
>  }
> =20
> @@ -319,9 +322,17 @@ static struct dma_buf *cma_heap_allocate(struct dma_=
heap *heap,
>  	if (align > CONFIG_CMA_ALIGNMENT)
>  		align =3D CONFIG_CMA_ALIGNMENT;
> =20
> +	if (mem_accounting) {
> +		ret =3D dmem_cgroup_try_charge(
> +			cma_get_dmem_cgroup_region(cma_heap->cma), size,
> +			&buffer->pool, NULL);

This alone doesn't call for a new version, but adhering to the kernel
coding style would look like this:

+		ret =3D dmem_cgroup_try_charge(cma_get_dmem_cgroup_region(cma_heap->cma),
+					     size, &buffer->pool, NULL);

It looks good to me otherwise,
Acked-by: Maxime Ripard <mripard@kernel.org>

Maxime

--qbjavhllvvchwpql
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaZbU8AAKCRAnX84Zoj2+
diB9AYDhkg6+tBwkM8yMFN9/WFT+hpPNlhGw0UEY/ZE0DHuKywzN1rTS3USBgeXc
4vi8MkIBgIRG4eHa1thavtEHDzWooCqiLhwDczcPdIil4bWekTGZxgf1mQQHrqGd
pK5ZeNH5CQ==
=YZKD
-----END PGP SIGNATURE-----

--qbjavhllvvchwpql--


