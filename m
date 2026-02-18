Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E108EE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:56:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A0876B0088; Wed, 18 Feb 2026 03:56:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44E0C6B0089; Wed, 18 Feb 2026 03:56:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3437C6B008A; Wed, 18 Feb 2026 03:56:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 219BA6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:56:02 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B7C1D1B49C6
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:56:01 +0000 (UTC)
X-FDA: 84456970122.03.F9BA9BA
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7AAD5160002
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:55:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RqjqFZSN;
	dkim=pass header.d=redhat.com header.s=google header.b=tUwnbI2G;
	spf=pass (imf08.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771404959; a=rsa-sha256;
	cv=none;
	b=aveT50Om0XyoDPG4aAUFqcW90pbOr6kFfjPjBSIj5DrINjbzG45eNN+QLAneUSOLQ+3UNI
	rFMncumDsKFZVp8bgVb3joJOZqbHmCOyScOXN3Sdm6yvrRCh2SDL9izWG51fx3YdYF9Ygz
	mD/5cT165TgGWh0WPm+X8P4DY9TRnQg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RqjqFZSN;
	dkim=pass header.d=redhat.com header.s=google header.b=tUwnbI2G;
	spf=pass (imf08.hostedemail.com: domain of mripard@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771404959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/9otZd25ocNn9HUDGmNAX0+CEXD0GlGASUVcWCKDTQI=;
	b=kfPfyY5yL+zyFmM5lilOd3iDn6Vpba3HLMRnfR2I2QkZjc6lxVzy+hraIVlzgx1s8BF/bW
	9NCt+KqQmnOfv6VzFuRiHND0sTA41wJZbY1N7rNZ3dSSJ/JnTgtR4jVq5r13o+bWrLacEJ
	209WXuKoIvLBMetp5yaA/bn5xUThf40=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771404958;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/9otZd25ocNn9HUDGmNAX0+CEXD0GlGASUVcWCKDTQI=;
	b=RqjqFZSNAbdqH0dOqsy55Xud/vJdmvz1tzkXueNqmjNvTZhtI2DLJa0UALI5NDoLiATY5B
	70YEqAvLFEUuyUycH912YOhipUYpbFvfL8z/zUdtxNwLl47gfi9OI9LJsODsJNNzRp9/3T
	iCiXBBc/orJlAz3NmnwGaI5CCBk36FM=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-217-60Ep5bQ1NFaKl0M_ez-1lQ-1; Wed, 18 Feb 2026 03:55:57 -0500
X-MC-Unique: 60Ep5bQ1NFaKl0M_ez-1lQ-1
X-Mimecast-MFC-AGG-ID: 60Ep5bQ1NFaKl0M_ez-1lQ_1771404956
Received: by mail-wr1-f69.google.com with SMTP id ffacd0b85a97d-435991d4a3aso2995646f8f.1
        for <linux-mm@kvack.org>; Wed, 18 Feb 2026 00:55:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771404956; x=1772009756; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/9otZd25ocNn9HUDGmNAX0+CEXD0GlGASUVcWCKDTQI=;
        b=tUwnbI2Gue1zt5K8yfnP7MYIzPsAnoEJsn6rYFPZFBLmwRyPcl3WrbjYOFGbbEoDmf
         3LQBiBcpTaPuuM7I6rIBy1u3VJhVO53SbCEquaNJhXb3mghJHd/e+UvbLwMSsWHnYtW0
         mRlQIU6KOsHuw3OJQ53TNigN+u7Yivzcnco2XjzgGhGwpsjwu4IznULiVNhvE+TDmW+b
         hpyP13nl2oVKqtRtZ6jeuqzX/0vPxjYkFJrxcuWDHYZgbWkas0YXVO7E3jYB8v18Fneg
         hWhlEPc82CYoBO+Dv4OjU0FGU70j9AnZkj43/7FYwUG4RUtDPUzrX5qucU5p1FSF2Awh
         qkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771404956; x=1772009756;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/9otZd25ocNn9HUDGmNAX0+CEXD0GlGASUVcWCKDTQI=;
        b=XxU4i5HeBasGgqqyaCUFltfbXY/Vp5Ohb7EVHqYuXVvF6/R90iYKWap30ddSiCjyjH
         1K9xwhR6J9YwY9TrkRi9gTlOAFKv4JnUo03AiGCDfjnwVeyxhfADsVUjnjbIr91sPTbX
         x6TZ0WhZF6nS3WG396Uvb9DPDi9kTV/p0oKsbl5w/ROQjznVSpPKVwJPnB/YBCIa0hzN
         X0ttP6q4BLp1nocQ+3dSSOLcHYDaPHMNtEvHLoe1Ao5p9WpjC1d4nhHCFm/a44MdbNOM
         M1F7ICoviVtC76D892l8Yg6Cymoa0ThJ+hzmXlLHXirlWQvxzKigq2n8VcE4oZmYwscK
         /H9g==
X-Forwarded-Encrypted: i=1; AJvYcCXAnwnDn4ZO2w3O0kkPsXqn5Tn5336REIe9MmuUf2S/TgEOHULJDbm2VOpVqa08lOZVXybv1TugIg==@kvack.org
X-Gm-Message-State: AOJu0Yw0ddo8PmLcZePJQD/059Y8JA3xV9sFyV7KRDpJTNvBqAab/0Nw
	nxIvTiJTFAE23h9r5GpG0kXSBtXHEpXOA52AQAvTrk84Qbh8fALL2KDRfk3nM6QGKRcM9gcCews
	JumTULjPY2RZxrAEYUoTlQc+N0GhQ//LctIQNUzQ/sAHEG2gr6/hs
X-Gm-Gg: AZuq6aI42keLP96XtLcBJV2+jBsGe9m9xWAPlK3LiF+/EtABnjpmOe/JCl7aAAh0Ba6
	1zi08dHw170U0GKICzYPjjF1zq7lR8mkqwSeMeD7z0laNuXZdVFGq0EMUHDq2p/s63Q7XaH1roD
	nGI1k3GaTkTcXj+XqtWnHOfywewYErratR7MK2v63RvLuuUJZukIfyCgGO8H6jlXX/PCvPbLssO
	BzhnzG1shzQXMo3Rsc+FD+pwQCdYLsIMYI8Fth7insxmJNEnzR4OaFYoMsaylBSCp25Yu6bDkJ0
	21IJimB7YPEqG3jJ8jXDiK/XrcccSHrhGvrItClmzwdcOIqPOUC0YrGmoKU+83JhMcM1NMAweg=
	=
X-Received: by 2002:a05:6000:26cf:b0:435:95dc:b8ca with SMTP id ffacd0b85a97d-43958e4c9a0mr1686374f8f.40.1771404955687;
        Wed, 18 Feb 2026 00:55:55 -0800 (PST)
X-Received: by 2002:a05:6000:26cf:b0:435:95dc:b8ca with SMTP id ffacd0b85a97d-43958e4c9a0mr1686327f8f.40.1771404955056;
        Wed, 18 Feb 2026 00:55:55 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac8209sm41853724f8f.30.2026.02.18.00.55.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Feb 2026 00:55:54 -0800 (PST)
Date: Wed, 18 Feb 2026 09:55:53 +0100
From: Maxime Ripard <mripard@redhat.com>
To: Thierry Reding <thierry.reding@kernel.org>
Cc: David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Rob Herring <robh@kernel.org>, 
	Krzysztof Kozlowski <krzk+dt@kernel.org>, Conor Dooley <conor+dt@kernel.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mike Rapoport <rppt@kernel.org>, Sumit Garg <sumit.garg@kernel.org>, 
	dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org, linux-tegra@vger.kernel.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
Message-ID: <20260218-lean-faithful-beaver-2efd77@houat>
References: <20260122161009.3865888-1-thierry.reding@kernel.org>
 <20260122161009.3865888-5-thierry.reding@kernel.org>
 <20260123-active-witty-rabbit-0fc5b9@houat>
 <aY3j57xvdOY09EwQ@orome>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="sfzhuutowl7gwtka"
Content-Disposition: inline
In-Reply-To: <aY3j57xvdOY09EwQ@orome>
X-Rspamd-Queue-Id: 7AAD5160002
X-Stat-Signature: memrnqdojitj5mmfjk9csy3bqsk7ehzo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771404959-410954
X-HE-Meta: U2FsdGVkX1/wycu+9jxXUyYvFW6kgrME7jkx3Q1RxYCJYL0S32zapMBqEjyi6HT8naMQqYTFIYzEoifSxo7vRUI5mJAZRpO0v8/NFTf+Xjz/YiYsOldjLzEU2A46OR3plz3GDIuVdO7GUsD/iyS9w6OePjcb/NHt8QhNhOn/6WbXeeCb8DEeEuBtOABurY2cpPsYAUEZ0RjpsbLSGjplvgtnm0bH3b1G42FDJxQQephIXSal1QHUTg70Dv0N8QNhifoS5++yqAMFKjhh0G/BDGNORkD11ekB3RK5MLBl4clh0fi24q6/EoMaL+vBzjHnI1MOAC7bpPNt9kbrQ0OcpTUDGvIbklwGmqOLrTBln86c8g+jKqjF3ibSujPwStlvDMbA1bcFPQx9Eik2CijfEaLcDmUBThCTHOCVwgelYNDM+vVXTHfH/pzXUNmQI71QsFMwuCrc5rRNVir8j/r56UYj+qQpP5aDa1ox2nRgKZGYGFgK14FS/GJEB4FSRLylQ+sbCbkdFnpeKvTtmS7SZr8BTlxX5D7Bqa8xYP9m/Ctk+TP7jvS2ZD0V32IukOhUObjRVe//LVfTzLYwl+IbVC+vDTIsCTA8OKAfLHF3ZbE5CAruwZatPzEuPpo2kh6kvM7s1N/l1I494xaTh995+lt057qEYxq5lHiFs7iHGkhg/S8UsIo2d3zGkNCjyxGKjIc7uu76OjVfPbmmPV72N+0oDyv/h8q7kQnMnhSLHU6iQxLRUSXtdEKQXvtk15D6eykw18O8FcWZ+35erTaGaN3qLC7GCgEaD1OjcY19EdtaRd+HydX7S6+5IE6Y9UWVCJNiRRg3emVM/QqqHLUYx22WXKMA19JOsyyh6BrdfxlC3v/dPaA6VBpNY6dhq+1ADTy43V9aShl9imguzcikQvPFzO5OHxap597C6kLGCC4aPdzwPa9QvX0lpG/VNcSdkAFeqibEHC04ZW2X3BT
 ODMxwdG1
 2+3om1E1Tnuo4sGq9HOuTOQMQPaHPJPcy9wez6lTAhH4ro3LZ/p9+irEWnTg1v2IjaGwknIMynyt+E/SFzix4hk1RHby9Ssucozkn+jwmAbn80W94mKZ4IoymknKLex2lXTa11ixv+nhhLTpvg6pFuirWME6L0WBo4FKLKfd7fD8f68z3hR0wyme7wpuJd7TMi1LVixbVFl8hId+kPy/mu40VI1KPB3iqjdI6VHNFnmGnwWR3AreQqYsVzD5Kos7O42WRT5yopsrKcVLcX/64rscqoUzBzQWO50O1d7FIR+vU2rzTK1Umfc3o7kAdY0O0Vi/0WZ/5r8vNTVbbP0JiBT40QbB8tqLvSSZDG6NtIUcGWI+5/rTOuuk0gf/XofVwbz6okAeqwUG24A2NuibgbVlsC9454KRU9B3odFdM1o6bOUOVSQONhUdzEQzavq4nIjpL+c4+7DMo+DcERR9Tnj2Oo1sZNDd5Rhw5zQCQ9rcJobkZ5/AyIEiVhTGAv880gXHkdt9vmLVXuFYVnGSHv7nae0PSAh4UjX3tcGQ1aTLcczienq3g8ZIUAvx0PnuMxsMbQgYhbrUVGcXfED5y+BHVzQD4qlGlszf3U1QI+sdaeps5yUo5s1aaJjMsYxKVetnV1BihlVHzOAF4F3IOSUgCER70YKpazbIOktDRRhQCLm+RkavgovdjQWdxRWqxX+b8DGD6b8EHBaXuLqmIXiun0kkj37DJ1wXz7DciCShj1Qg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--sfzhuutowl7gwtka
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 04/10] mm/cma: Allow dynamically creating CMA areas
MIME-Version: 1.0

On Thu, Feb 12, 2026 at 03:44:11PM +0100, Thierry Reding wrote:
> On Fri, Jan 23, 2026 at 02:25:16PM +0100, Maxime Ripard wrote:
> > On Thu, Jan 22, 2026 at 05:10:03PM +0100, Thierry Reding wrote:
> > > From: Thierry Reding <treding@nvidia.com>
> > >=20
> > > There is no technical reason why there should be a limited number of =
CMA
> > > regions, so extract some code into helpers and use them to create ext=
ra
> > > functions (cma_create() and cma_free()) that allow creating and freei=
ng,
> > > respectively, CMA regions dynamically at runtime.
> > >=20
> > > The static array of CMA areas cannot be replaced by dynamically creat=
ed
> > > areas because for many of them, allocation must not fail and some cas=
es
> > > may need to initialize them before the slab allocator is even availab=
le.
> > > To account for this, keep these "early" areas in a separate list and
> > > track the dynamic areas in a separate list.
> > >=20
> > > Signed-off-by: Thierry Reding <treding@nvidia.com>
> >=20
> > AFAIU, this won't create a new cma heap when registering. This goes
> > against the recent work we did to create one for every cma region.
> >=20
> > I guess, since you have a driver that would explicitly handle that
> > region, we should create some kind of opt-out mechanism, but by default,
> > we should still create such a heap.
>=20
> It sounds like there's a bit of a conflict between what you want to
> achieve and what this series attempts to do.

It's not ongoing really, it's part of 6.19.

> The way I see it, the CMA code is more of a helper that gives you a
> specific functionality set. Exposing each CMA area as a heap that
> userspace can allocate from seems like a bad idea to me.
>
> Without knowing anything specific about a CMA area you don't know if it
> makes sense to expose it as a heap. Given that there is very little
> information associated with a CMA area there's only so much guessing
> that you can do. I think it'd be more sensible to make CMA areas opt-in
> to have a heap created for them rather than requiring opt-out. Exposing
> a heap publicly applies only to a (potentially) small subset of all CMA
> areas, albeit at the moment it may seem that that is what it's primarily
> used for.

Do you have any specific example in mind except for that driver?

So, the reason why we did that was, mostly, to allow proper cgroup
memory accounting through dmem. In order to enable it in DRM and v4l2,
it was agreed upon that we would switch the use of dma_alloc_* to rely
on the heaps instead, where the memory accounting is greatly simplified.

So we want any reserved memory region a device can allocate from to have
a heap.

So I do think we need the call to register a heap in rmem_cma_setup.

That being said...

> In fact, for this particular driver nobody must allocate from any of the
> CMA regions associated with the heap driver outside of that heap driver,
> simply because the heap driver maintains meta data about these CMA
> regions for things to work. If we allow access to it from anywhere,
> things are eventually going to explode.

=2E.. I also agree that having it in dma_contiguous_reserve() might be
overdoing it, and I assume it would solve the issue with your driver?

> > That being said, it's not clear to me why the heap driver uses CMA in
> > the first place.
>=20
> We use CMA as a way of reclaiming memory if needed. The heap that we
> create is meant to be resizable, so that when nothing uses the heap, the
> memory can be reused for other purposes. However, when memory is
> allocated from the heap, we need to reclaim that memory for the heap and
> relocate any buffers allocated from the region somewhere else. CMA does
> all of that for us, so it seemed like the logical choice for this.

Ack, thanks!
Maxime

--sfzhuutowl7gwtka
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaZV+lAAKCRAnX84Zoj2+
dlYJAYC4+jPKHkn42l5qLnxTY3EvbGxcZHDH6RVzs/0th5A4+2dTD8lM8sIBBgPj
qui+8ooBf0t6WS1apZEC3zF8JlGWCr77XkBnVp5ZaozpXhqmNBMCQy7tm7z3cF/c
XrmTT30Bzg==
=yW5/
-----END PGP SIGNATURE-----

--sfzhuutowl7gwtka--


