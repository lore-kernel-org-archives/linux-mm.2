Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE183FD45E3
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:56:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D3A06B0088; Wed, 25 Feb 2026 14:56:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5843E6B0089; Wed, 25 Feb 2026 14:56:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4944C6B008A; Wed, 25 Feb 2026 14:56:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 32BF06B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:56:09 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B8D9B1A05E5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:56:08 +0000 (UTC)
X-FDA: 84484035216.05.34C5DCA
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id D89F2C000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:56:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Puw2K3QI;
	spf=pass (imf22.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772049367;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRL6lEk8UXTpub6PekQgYs2cjNTKn63oRhQdj5ExDbk=;
	b=5xFWL8Q0/ULiETlQPuYgP1aRskzQqBX2NqalLKP9L4ZGIdNOYPO99KM3t+ei3GFY/ELji0
	aG7YTR9Fn0GauL/0fSEZiemthU7qQnltA3exjWb/sMd/kNoirJyHPflMxOyaWbV0c2ENoE
	jGe4bZsIhx9HFSTSJb3F9/sZFpHbJIk=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772049367; a=rsa-sha256;
	cv=pass;
	b=yrpXw8ApgWQAZzZMkxAhVfFlXWOKt3GUXX6qLCIa+ryjDWpHcXfTWECuFH6CmscGXQIJSS
	G/lVAOUDURscz58ZBkLsypBhFg9+jpsLi1OQYU+XdFl3DACo1ZX4DkGWFVvhTMj0ezeJhf
	L0VX3AF1FC3ZwCFMK2nUDekT/4zRGMs=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Puw2K3QI;
	spf=pass (imf22.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4806b0963a9so14715e9.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:56:06 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772049365; cv=none;
        d=google.com; s=arc-20240605;
        b=aiHP1M9cqkYlehyz9oWHeooYWYJAYm4WbXdm9tHNgMEV9TfD5cmW4Irvo3FMrMKpwv
         O3d+rUiGTWvJHMuve27tjNnL8XbnWJ8i7qxVsLsf2060fZV34TNl4uaDrBM45Cl8AHW0
         5c7Xy3lrf3rqsbkIcVHMf3S+tJLAL9Mn/C7wXoKhEUDtrkm2i4dAT+Dt7lxiz8eBzsxV
         du1CSLelW8mV/E98pIkUH7/DE71Ftn7PilU3kKm272Qyj7eEr/JaKtRLGZ/aeBYN82CY
         dFYhJsWIWF5B1qAYXMNiAlPzLq049o0k/yIH/zcEFFA0c02rbNmrUzKFJbJWanCQR8x9
         ZU2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HRL6lEk8UXTpub6PekQgYs2cjNTKn63oRhQdj5ExDbk=;
        fh=eEBEqT4edsnFGO3PEXHw2cwMZe+vwad2K2qU8ihiibM=;
        b=lCcWWsLPzBKee460H58WJxlnZpBsAm5ysd4FqT6+QWDGkJDKD0wW5QdNRJm/1Nfx6R
         l0P5AAjjCU3H52mVEbMJgnxsu5OJyzGuISe0/y88OEku3QLMHFZbIbxWk/eCgCGpuPPN
         OCsjoy00wVulaBBTp2w7BKDhOlpzLGzyH+Kva9ilbWTP4yJbMAEYWK0ZYj/HdfqijbEj
         jfXPU61zlURhyuWZLZPaO5TNuhZzwskcJ59SWLCtpcpAce7LAR9Ee0N+u4wFvuUjoTvE
         /d/PcOaRttYg5NxnLFBAH4rG1aQarz26rlOlUyjNjrcuNf6WivZ0XqZSZ9qSxtgZCrhT
         ZRsg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772049365; x=1772654165; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HRL6lEk8UXTpub6PekQgYs2cjNTKn63oRhQdj5ExDbk=;
        b=Puw2K3QIjHd5xxEBYvSg99Pn4GY9MAIOuO67c5y8nWAbR95QuzSvWas5au4eD3rH7C
         ZpPpx5cPkFv7h4SGS0B0DYP2NabcH4IvdFk5ziF5vAMWYPLwk4TUiIqDALnNKJGAqLFa
         AJtHkkX6+9NgzWXhrWmlK7bPhGjcIpzgxw84km4t3YXwmRgMklfZ96B871mX/YjpzuO0
         QvRD3Ynsw/oO9IwTYhzUkocIiue9ArrpglFxp5AEcZNJW77NQgHGUgVvYLaFUlAK2hAQ
         Wl2TS8hySI2mUr75Bsm5eUTTN/9/jlpeL0orydW06uB6BIb23hrFI2kvmUeGcZMDu61M
         qaZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772049365; x=1772654165;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HRL6lEk8UXTpub6PekQgYs2cjNTKn63oRhQdj5ExDbk=;
        b=S90HxWneyxNuIr4yO0BnOBu6P5D+nUyqrJbtDnmw/8GnDOmPUFqkwufHDR9LpxRIwf
         GFXFHNu4iz51CkpBIs4zv9YeaB7tzD7+Qo30t/dUOTaPWyGu6GG6gOZA033X1/PyWuRl
         4h04tQwu2dF/sjjzvmdaPiZyKj6Jow7XSEEfOAY0IfDb7NoDB48jRTVXQf9arDwSqYq/
         Nr74xX1g12sDjN4CUpFD5xXK0FX3Ns+0S5JB81jE7AIrYAC8z+PhzJUsODE2OHBJvWTG
         Z8xfBAqlfAChyQrOOyxiBNPMkwIpOHkTaoqzxZs2xJhCGW6fwv6l+i+cBW5Aftopmhoh
         rDEw==
X-Forwarded-Encrypted: i=1; AJvYcCXS7blQnWDTiU4gch+/hd5OLNl+SPS7PidJ2n6u135/7AkYbKH8X1uJO7SsVmgQiHAZwwDagYjUBg==@kvack.org
X-Gm-Message-State: AOJu0YyBx61JxorSN84PvlHBjRJzxFWAa98fgdS0Iuw3wKcrTENWZ8TB
	2ZB/uUsKKmQn4w9Z1zfGVtSEs/Z97wYRhAETfu/3PnZQDsepIi4e0sPNA3Xo4OL9d/VHXY9BxXo
	tIPmwslQLHJtT/imE/O/qnR+pKzXxVVTtTh5YIx8W
X-Gm-Gg: ATEYQzx1QrvPT2LXYA0UXE5yjw22wCGm1Zl+LhTLw4GDJt6mk3EYifQ2pmkRcUGiBTS
	NP+iSmlTTC1hK3puf0B3NUIVdsftkfL6n+WAIyjQ9KTchvkNXeG/UubphCQzdJnO6IqqHF8zGyd
	5N+CelJAioro+e6an7Do3Res2/VnS/i6OEPihS+5V1aLczjNVwMWYKwGPXzlr1mCDl8OTUxX8Mk
	HNjEmrlbzhRriwFHSTtAvy+3TvooPTuC9UQKI7gjhkz0p+XmsDYIj9btjvhqQOQWnBfS2IZ9xv9
	skJ2K6f8Omfk9Hb7npw434Jhq7t52wsCmlWf7jgdNOpwHxgBhvpQ/FqyLmhJzOxbnFd9KA==
X-Received: by 2002:a05:600c:6a8f:b0:477:c5b3:7a9b with SMTP id
 5b1f17b1804b1-483c3188d68mr92305e9.10.1772049365087; Wed, 25 Feb 2026
 11:56:05 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org> <20260225-dma-buf-heaps-as-modules-v1-7-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-7-2109225a090d@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 25 Feb 2026 11:55:53 -0800
X-Gm-Features: AaiRm50aJvmG-U5wbOHTqLRYSqzdYRLj0K9YYWnCflGgDx3T0BxE0_R2bnIQaGw
Message-ID: <CABdmKX12GL7gd_TMArPbjGwSOOhu+udFHZ61dDfMwWf3q6cB+w@mail.gmail.com>
Subject: Re: [PATCH 7/7] dma-buf: heaps: system: Turn the heap into a module
To: Maxime Ripard <mripard@kernel.org>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: sx4puqqtju6khxoyyz8dn7f1cyzwpj3b
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D89F2C000A
X-HE-Tag: 1772049366-244686
X-HE-Meta: U2FsdGVkX1/qNVYeIioMdzNSWU8uNVDZ+OOVsiqYLkNqS9DReE9vZJsl4zGxDn3etqd22xnIlVuEkRaxuJhiIHLQZva/YxNF5lNSPYcAGk5pQPnZ8EEcjRRF74OtnXshr4HFZbT0hgPMvyqxrcpGbuRhqnQQT3dypg1CUTH/I2N0sjCMWBWHvL+0fk1OTsc+DEb4QJd7pIq/e08B5KSp/IRL9uxo+FaAalTFWzqIZHfcm2JpTuhR5pDru1AvOThTxUJ9dids/jP0d0AOgEIEJ/n4oresWXDhutXVkj4NwGTP5d30dyn5i1EqTmD66CrKaundjmB419VGdHJr9apGvZVgGrlXqu9mXoGLPyucHmL3vxMnjYHG/9kiG96WhS+zrb0/JYa5mu1KUCXVcCLMPk3dQqXqiObsyYITblheYk90aD+SufEMGFUVMouD62s6Lkyu3n69isiH36B83eCD/8aq84QYAmCA9KZNIficd1L7X+r6knF+vUDMA42hCph1I0Q3Q6bhzKc203RuN0x2qLOaCwYqsTCH8nmUSGqlJWI/0Z3n5tWy5M5oKOd5wPJz735qw03XDi3egw9fDPx1Zli/fcO3MCDbbH9kd2k8qzaBHQ+GUWuh1zHoSgY73VvAiN/dKvHuhVYkdyaQhq3pyv3zZDWNvh2HGG26tnkRre4S1lMbufk+/l9ZOb5YZLo+cDMR+xkHQQLZhxM0u9dp7roKPQUoI2okNKYnLMalLv4dZDzI0i9VVc8hJUqdSeYi2sI/EZegiOuP9ycOm/sH2Az0NTsPvL0h/ajJt3iHBNQinUzB1/deJNx3FMMMfaa52i3mtoZj1lDHLLJNY/O+GElbutgr2NC9EgAmkdOGZaB0xjmk0yWC6xODO1wRLmESc9HrSXNgC8aKHhHOhJWl3tYw+Qm7KEBtuSy54cJFCjirw851VdEne3edoMqcYw3c8KlT2vtQqPM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> The system heap can be easily turned into a module by adding the usual
> MODULE_* macros, importing the proper namespaces and changing the
> Kconfig symbol to a tristate.
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

Same comment about a note about the module being permanent.

Reviewed-by: T.J. Mercier <tjmercier@google.com>

