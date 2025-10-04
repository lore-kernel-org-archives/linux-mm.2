Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74E0FCCD182
	for <linux-mm@archiver.kernel.org>; Sat,  4 Oct 2025 22:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F6C78E0005; Sat,  4 Oct 2025 18:40:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CE5D8E0002; Sat,  4 Oct 2025 18:40:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E4388E0005; Sat,  4 Oct 2025 18:40:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 66CFE8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 18:40:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0367084EB0
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:40:26 +0000 (UTC)
X-FDA: 83961902094.13.8252406
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 12E1E16000C
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:40:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ihiT7FOA;
	spf=pass (imf08.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759617625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOAdntz+KeAlO/SvuA1JcD8OWmt9u//UdVphsQBdXps=;
	b=b1NEgFVRmJl5n9Np2ivITqHHkHOOXq4hpkS8EUdz60lystemzHzaz7W8b6xoPr6vaJxJHD
	i4LdDaHfResCt84YRiCzTzncexwa6CMrNR0IAKexcF4cUyEpxaZ51ND9qXy0NfJCL9UW4L
	b6uNE6GgW+ckSyL9JSzH6ikXEAxD4Y4=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ihiT7FOA;
	spf=pass (imf08.hostedemail.com: domain of bagasdotme@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=bagasdotme@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759617625; a=rsa-sha256;
	cv=none;
	b=yKK8/lBXNoguqRWB5k03htatBZEIQNJauyemCy2v+ovbzj0czdS/PX6evRDuzGFHcYC1ql
	3q7VWTwU1d0swUVuQ3EpmVs+2Li2vHZTKhfUuHPPHksYUF2G3QbpYe+SvP25IbK/bbWUqb
	5pMo08yCfzcrp8HUV9GVaBOXVjVV6c0=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-269af38418aso43028975ad.1
        for <linux-mm@kvack.org>; Sat, 04 Oct 2025 15:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759617624; x=1760222424; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bOAdntz+KeAlO/SvuA1JcD8OWmt9u//UdVphsQBdXps=;
        b=ihiT7FOAdCpqMAwkvmiGNJdlQ+b/eUhNnDfXsDI56OpMQL/3YRZUnLUKGKe1dy16WV
         ZeHWaq+MW8ml4O4PICnR73EnD6E6ISTIwydDMJB2duPbJQLkzw8wMJyyFRUnfJqSq8rn
         96iO3YsRPOCC95TVnJ4dgN6se6lxLOIOZJEzeOwZf0kpTTkTwKfr4n3eZPJnADPeyU61
         APo0lE7QaTrglNFjs6htTCQRmbjFVj0C8bjctxT/zVRbaU+ZthhqfQP4ckjhHvYiclc1
         agTgPsa7Z3BDtHRzWFO9QEODpKZQNJNZHp5VWJgaapcDbX8l30EqDusT4nFB0wI9RUa9
         TjKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759617624; x=1760222424;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOAdntz+KeAlO/SvuA1JcD8OWmt9u//UdVphsQBdXps=;
        b=lYn9QksjYDfI3VOZlq9ZVIU8wqJOxs45HsoaUWk4cv0acH6H7sqG3IO27FwPnjdkca
         WV+Eej0g1FQ4XFKCDdDDqr66QCcHacXjP9mcQEp3YCkOUXYapKJ8+dWWzJIMDEPkOou3
         l7xfqDy0BO/i4wy4pR8dI+jQo9If4bvdryaxnvwqVPR4DJK7uAK6GmnfIib5jlZsNVh8
         p6gYjCwVYtkLRC8ESx0FOD1l+lZYWgMvn2skxcQ/5dCtUyktxwqCqKkUGn01bOFWdNGj
         /r+KKu2tYDQby2DhKqSiyS3tAEPJSQtA25L3FMmhq8O2c1iQIKsRHt/9hUDhQlxED6Ll
         WpGg==
X-Forwarded-Encrypted: i=1; AJvYcCXH+EeSHphaLn6NimrYSDwwIi3A83ddULM2ahoAByOdp0cKSjhvPNwXYVR09c7CQslTvdFCkhkRgQ==@kvack.org
X-Gm-Message-State: AOJu0Yxxx+DST3vftPWP1w0opmds8jlsnBBxHCccDfwrsi2nB/Ef6Tz8
	LzkFvdN/BnP5u/WxwkIZGo+vL2Ysc4Yel19/C++bM97g+lNwN0PTc+w7
X-Gm-Gg: ASbGnctN5NPRbvaEaGPnFHpQnpSV1nnQEyD+jgSTg6CwrZDvc8pGuL2MImJOWqPFAKE
	1XSRam0b9ICSCzzE8g4KYIRefMkvA6QfGElohiUlxmxm5IrtCj80dHwIw4EHyGs4WHv4MPz4V+Y
	Z8DBeR/H3PEH2OKUE68w7kZIMer/iH/XDWXRBHZv15YkAScWq6kR87fonwpi/KnmSKcOd/yJwuA
	KeVVvYaB0XgtpN47tbpe+dwippr05YSWyWnL2BpNx1xq+FyTvXavtYpE2FM+Z9yLflCqOj7qtPn
	pT0kxKMfqWlXLsjHcIzQeaFvG/f3XJEyYpTt+8f6EJF4EKA2rEHR5drSgB2BEuy04dYxB9WKyG0
	Z953bT++CkZTVrvCbc1nK8n8rByKAiU/xcduCJQJqDtFqKXhGbbM9gRz1JNVB
X-Google-Smtp-Source: AGHT+IEEuDpKzQXtVuShc4pJf9BgCPzJ18iq05PWmkh13oJnHgXyYPdarqa0eRgaRYG+SwX7DVV9HQ==
X-Received: by 2002:a17:903:28e:b0:270:ba81:14d9 with SMTP id d9443c01a7336-28e9a693fd4mr103604355ad.36.1759617623667;
        Sat, 04 Oct 2025 15:40:23 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-28e8d111910sm88078525ad.18.2025.10.04.15.40.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Oct 2025 15:40:22 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 835BE4233433; Sun, 05 Oct 2025 05:40:19 +0700 (WIB)
Date: Sun, 5 Oct 2025 05:40:19 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: =?utf-8?B?TG/Dr2M=?= Molinari <loic.molinari@collabora.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	Rob Herring <robh@kernel.org>, Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>, Melissa Wen <mwen@igalia.com>,
	=?utf-8?B?TWHDrXJh?= Canal <mcanal@igalia.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	=?utf-8?Q?Miko=C5=82aj?= Wasiak <mikolaj.wasiak@intel.com>,
	Christian Brauner <brauner@kernel.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	Christopher Healy <healych@amazon.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, linux-mm@kvack.org,
	kernel@collabora.com
Subject: Re: [PATCH v3 10/10] Documentation/gpu/drm-mm: Add THP paragraph to
 GEM mapping section
Message-ID: <aOGiU77k1XPb9W9M@archie.me>
References: <20251004093054.21388-1-loic.molinari@collabora.com>
 <20251004093054.21388-11-loic.molinari@collabora.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cgdVn3+TYG3JLZOy"
Content-Disposition: inline
In-Reply-To: <20251004093054.21388-11-loic.molinari@collabora.com>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 12E1E16000C
X-Stat-Signature: 7ud7f9xj7u9i4aimegdm93ubfcnrwu71
X-HE-Tag: 1759617624-235547
X-HE-Meta: U2FsdGVkX1+FOMQTROwmI2HjpgQ7pJoqm3BAFO7ykwpcqZeNCR2Q01TVMAAhIlODr6I7yp9JM6aQuL7A59QFyYy/A9ZH4bn5G+leP+lreqV64JmlNtTU7kwjnp4VelOEyYqhTBPaLmeoLOzKbPT0O/WJFlN9vjuyo/o2/H0BgWhSWOTwhplw2pKPgkyiXGMbrNKMUAnlzcsKfLw86sBmxzYfo5ooK23ukcfYx5L/GG1rJyPfTP9XHsHEx/NNYX2DAsa9ajyJV5fmzaJkTh1OOOgpAWtRArdzoCxt1GWJUmTnep1rpapbqu798PXD04tWgHdSVsDz/rZTMYqGIa8hcRx1yWOaOxbas/BqH2Q4K8ecJ005CLHb4KnzaQo1kwOwhcfwkLofgW7IgKY5o1Gk+7MiqYZN1AmMifVaY2VGFW3ebxdCiyCcfQSo+TSKHUVE3aMOUZemJP9iLuTixANu67CZTjwbxW4Za9acXXeDkb74HPpbAtCnNbZ6nooy9BlgkjtghhAKn6oQqJJlVKsLh7M5Qi/LK7SVWs6hzuFhWIixF+lW5YR/ChNB5I7LVQxSUoDWmq6NUUt/LQ/XitQOE4AKYN09wa7LoVXDnsE4QMds2kOp2HsXvADr3alB6Go2Jqm/Mt4gIDanChZ2jrH1g4kfqSkVEHkW3UF6s4kd4creA1LHoJQqaWiEF6Wg96AaMfQALYUfie4QgPBfEJZRPfNhCrv4kBnwlgcti+1FdtD3EKs8btD5hBHDeQ6D/1rqzk7jeOz9nkYCWufFz6u0TdmZVsAxRjAp8RMMEzo5TO3hFNKPZzXVG4KfoI3eOYGwmXIzEJyrn8l7DAJIY7tvEGVwtYWSxSaFJ9f0IMyWjWLS870hiip53OudYbsVi1nQ4vCE29JvGRAA+iloW7r3yCzNJSn7OVQb1yJTDJ6qJ4iL0w8pXGU+4hqE1k6wcLwrrGyJZEB3duSu91isiRz
 zMEpzDQO
 QQ6cwf1WHTv+sIPQ1WNZsgyRh8uDfeu7Rk1776DO6MBAPGAUFQhESuqQASj3q1C4RnugiljxBZNucZyZeE/dzVaiRKcuLUheq60P2vRLIblW4yBlJDOHTcOUtXFa0EZD5GtnUQMHc5/iwS+mq2uqDywwAyjXVWMfdzDykAoYVgEmKjC3refQIcQ17aUazjNA9cz1ARZdC1tmOURSLAoXN3RbQIspdzWbm72S6dKoqZknZGx5CyxGjJZlzkylX9Pp2aIp6Y7dLL6LIRakxuZbdZlvvJa2O9H2dbKA2V49imaxI5lLO2d/AnxvXHEm6yz8bqByUYh5s+xwEbVzKeQwYpg9+uiH7CU/Zaf/+eX2tEfyunYrEXhNK/dP2pOHoUQTbtLHsM2MeyyXVMgKvERJ9XABSd8QuLL8IIBwa54wO+b+4ciYzXXzBzwn1h9H7os1bZ6TfE72U+Yw7YKCCRV39xw99mHV7GNCUOzB0gzGseusFiEEWqpHVy4fpUh92zaHb9t0cDUIu4WsB4PM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--cgdVn3+TYG3JLZOy
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Oct 04, 2025 at 11:30:53AM +0200, Lo=C3=AFc Molinari wrote:
> @@ -290,7 +292,7 @@ The open and close operations must update the GEM obj=
ect reference
>  count. Drivers can use the drm_gem_vm_open() and drm_gem_vm_close() help=
er
>  functions directly as open and close handlers.
> =20
> -The fault operation handler is responsible for mapping individual pages
> +The fault operation handlers are responsible for mapping individual pages
>  to userspace when a page fault occurs. Depending on the memory
>  allocation scheme, drivers can allocate pages at fault time, or can
>  decide to allocate memory for the GEM object at the time the object is
> @@ -299,6 +301,19 @@ created.
>  Drivers that want to map the GEM object upfront instead of handling page
>  faults can implement their own mmap file operation handler.
> =20
> +In order to reduce page table overhead, if the internal shmem mountpoint
> +"shm_mnt" is configured to use transparent huge pages (for builds with
> +CONFIG_TRANSPARENT_HUGEPAGE enabled) and if the shmem backing store
> +manages to allocate huge pages, faulty addresses within huge pages will
> +be mapped into the tables using the huge page fault handler. In such
> +cases, mmap() user address alignment for GEM objects is handled by
> +providing a custom get_unmapped_area properly forwarding to the shmem
> +backing store. For most drivers, which don't create a huge mountpoint by
> +default or through a module parameter, transparent huge pages can be
> +enabled by either setting the "transparent_hugepage_shmem" kernel
> +parameter or the "/sys/kernel/mm/transparent_hugepage/shmem_enabled"
> +sysfs knob.
> +
>  For platforms without MMU the GEM core provides a helper method
>  drm_gem_dma_get_unmapped_area(). The mmap() routines will call this to g=
et a
>  proposed address for the mapping.
=20
LGTM, thanks!

Reviewed-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--cgdVn3+TYG3JLZOy
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaOGiTwAKCRD2uYlJVVFO
owsBAP926UwrcUZLpaNBVlMMMAJn+GCE/YTh2qS92wDMr5wDhAD8D6FJXmT5X1j7
e7eeG3goT2uCJaiZG5r1107jYRzKSAs=
=vdd1
-----END PGP SIGNATURE-----

--cgdVn3+TYG3JLZOy--

