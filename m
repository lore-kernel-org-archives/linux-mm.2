Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64846FD45E6
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 19:54:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C94A56B0088; Wed, 25 Feb 2026 14:54:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C72406B0089; Wed, 25 Feb 2026 14:54:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7F4B6B008A; Wed, 25 Feb 2026 14:54:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A58ED6B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:54:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44E14C25E1
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:54:47 +0000 (UTC)
X-FDA: 84484031814.14.51AB194
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	by imf10.hostedemail.com (Postfix) with ESMTP id 34F97C000D
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 19:54:44 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ve1zLKhW;
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772049285;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kHOrLDbHDmcLU0mU/NKuQBxgp05tP5/RxjExBXg+n4=;
	b=5GGlYJ6w4FYiNyW71DiuLkVotX2AXDu958PUFuwjakN6xETbo0KXtUnh6DY4YXJFkIDWVS
	84YyjP3gaLBVqVp0AsJqE2uL4D9+9IGKaOWmvDCP2Hsi0PA0E4QbHJsrs38oNaLc093Wno
	v2UYgH+uxhV/FrPAmGLeyXGpYL6lNkQ=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Ve1zLKhW;
	spf=pass (imf10.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.42 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772049285; a=rsa-sha256;
	cv=pass;
	b=sZP94mJ/ciB+cyTImw+vjlY32NWXwFN4fMnFqLyq0IoPcn4D8pi/uMa4bvEHp3ulVncL8j
	PI6FEeJM91PrkdFPUxJxTjHRa+chWLJ/IyGgprKhzDB83kBJRNxmZyG06z9TbAOywYjZwd
	iIVBlV3Eqla2RVVCPKKqPk1fXe9Sdqw=
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48371d2f661so12605e9.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 11:54:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772049284; cv=none;
        d=google.com; s=arc-20240605;
        b=CfFLt6hLYZUhf08q0PsxjB+gQ7MEpEfFxE/vFUShz3pplZSYpGqZj0VgMCIDmINoWw
         WSjBKgMZY1n5YfIt9CHJtw8JABgirUuzt+CQor8dFEL8fVBoVzVIre4wEpyeKQ53terP
         rERVgSm9ksbUhys08OnTe8skdMw1cJHF6P1wx7NabT0+Qh5EFz3MaC8am5jzzuYVkTsE
         BhqqKdATUJq9SdhqVZZtwWX6/VOfA/dVy64czXqtGVlzqbSbmY/KJrS13SdC33ALP+jb
         u1neADBPc0BWfhkglSPk3Yu5YFwc4TGdd7F0s3EtgmFOovFkTjhdDC2KtI7Z90CZAI4d
         O/aQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5kHOrLDbHDmcLU0mU/NKuQBxgp05tP5/RxjExBXg+n4=;
        fh=hlvfoPDKnY/Nj4XTw+UJdbch/7Ht+jS+XHDPikae7KI=;
        b=YcYxZofyAEmwHRskqpCNCwpDZEIcGa44tHyQAYuVhYAPUUU0JjxyLcblK5yoPyO+Qx
         jD3yjOhUB4HTOC1u3HDDJJ0iWuf0qEiCspWXTNR1l05lbH2FvR56hcoO2maKgx+vmfyq
         6P6iFPTNza9H/T6RXTvDZ3eMP9QAC9uHJwDAd054KuIMJn4D8wq6dI6Qw3Et6b20wK4+
         a/sZDqYXK1GR2AmHJoy7qzITmFCkafNq+5VWso6Gdvu4ryjKZwxpbcQLZdE+bP5gkwJz
         /ulOWzjFl+xE3YG9th7DZjdGe6BBFra+yCgAqkwLfDk91C2o+vr/AsJKCs0cHfwxg07r
         q3pw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772049284; x=1772654084; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5kHOrLDbHDmcLU0mU/NKuQBxgp05tP5/RxjExBXg+n4=;
        b=Ve1zLKhW2mhkOW+xFil7UWLul3RqZ6s2gBkMmfYZFlwjk2T/YE34anbDo+paaloeJY
         9Xy+7HDdlPqSFcIHVRarNq7b3S/beQy3L/XKUprYjKepil+EcmbaPyqwB1TjdU4ouUSs
         7bHH/hxs0svhteRkGozP02gHYHB7shthV5P39RlxkmFU45m64CSJZsh3jF+au6wsnAZU
         t1KsEXx75OUoetmfYtb358iP95FhAPMMQhZNsxY+j20VDLdK5YGtIvhuRfDB7/0cIDBE
         pTOb1fQfCIRzK6OSxybA5zNcNxo45QKnRzmbHT9dPlRHJkrS/4S+7mnqVbMhBAHo+8KD
         ahvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772049284; x=1772654084;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=5kHOrLDbHDmcLU0mU/NKuQBxgp05tP5/RxjExBXg+n4=;
        b=BvRKEWwc8HagoOvW6Y+Ts4Oc+grYmhsJAlJrksYN1/FBKSH6fXVs7vOn4j24qmdJwg
         I0UqlyqCetqkrwWjxsfmXM2YC2rTAeJl0EcYUHgfg1pcfOw539l22z1kagF9ZCgB7Gcj
         UH4u21bR/HrqZ1uDpk3OAwHj6YsNV5N4uk9DrcNPEACSXA7NT0EK8kfy/sxCTaQRJrar
         P40Je20m0u4EPm1haqUDPUw86hmcpE6BBy3IMCVRAkS75/mR7EBk/9G3RdHhr1tKhZA3
         +VbmsU+ZgEknufZ3MfW0bZt2T36lxJQGVduUVrWS5+ELa5QGW+7d8V09//E+k+h7Y1Yc
         34mA==
X-Forwarded-Encrypted: i=1; AJvYcCXTQX7gj5ei6MPsGXm1onXk3Lkx7KDxoXfC6fwGWfkqCk2/70W+8YPg75WnaQnW5nAHO+8GUQ19Lg==@kvack.org
X-Gm-Message-State: AOJu0YwpJl1AGSRkkiNbWt9XNnXSeNC51GPQn7TeQRAuGI2C+RaASti3
	jfFp+nhTVanvoyc21z34t7gBb+mDfbqYtgeC2LwU81IJAoPHqDzd9wuKkIz/W2AJisImy8hrkRl
	O1Ody0vY0nnZGAjW/Xp5/yf5KHr1Npr+yM8D+U2Bx
X-Gm-Gg: ATEYQzxVYCEJX6AG1SKYbRcWOjGExCF3Q1lkyK5e7hyPIL/H3Mu7Xa1mIQFJOrWM0cg
	TPFV8ChA5qyHPSgG6a2o0RFKsKhb2izKl3bsCDJzpHN32sAJBv/XkGdzdqbdldN4CZXz2l77VzK
	ajJZKCRv8hs9hN7SEyqbUW1d9efY234TsCHRymsm1esrAc2AzK3q9mmQKnsc8+Q96auzpNJtPxy
	pezwbnYTmeDducINObtcYkB26iCxTO8dnaiEtqTEBrenOpETpdnMJtWNAsZ8y2RPC8yMprePa8E
	MrlEM3ThjXIwCBT88MhA3wsd7xc2ZdyxpzAVIcqa1PMg0hGW98PuFU0Ynz8kiq2tR3eruQ==
X-Received: by 2002:a05:600c:a011:b0:47d:7304:d759 with SMTP id
 5b1f17b1804b1-483c31a1fbfmr90505e9.15.1772049283315; Wed, 25 Feb 2026
 11:54:43 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org> <20260225-dma-buf-heaps-as-modules-v1-6-2109225a090d@kernel.org>
In-Reply-To: <20260225-dma-buf-heaps-as-modules-v1-6-2109225a090d@kernel.org>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Wed, 25 Feb 2026 11:54:31 -0800
X-Gm-Features: AaiRm51QwXByHIj_4EAMjL0iJavUr_3DqvTRveBK0_qkEAD8H59M0Ces2LdyWWw
Message-ID: <CABdmKX26Q-DXsLEMbvsYbw_JotHpGk3zFDccAJaqir4aSBdt0w@mail.gmail.com>
Subject: Re: [PATCH 6/7] dma-buf: heaps: cma: Turn the heap into a module
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
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 34F97C000D
X-Stat-Signature: z31bsc3xp5df89xkyzzp95xs7cte181q
X-HE-Tag: 1772049284-478767
X-HE-Meta: U2FsdGVkX1+aYXMZaYFXKGK1B3/MRYBcNeiEAZ8YrvGg5WbR+LRy1N/rO+njHyB/EQGtlWplnKWRu7aVE3HEJ49+gofMvQ7JDL5gq3b5tWrZLVUI2YZLFwvMP88tdXHfl5EGaiapsyOCRO2GCDsmzwAIWDkt9yd1RoqIIBOx1Fj1HS0G4l5d1cj2eTZG0NZD8fjJNUwzVjO+Wv9BqdLY8jgnqCRYOG05GelOuVZszE9XXSQ51KvgBc/QABXyefWUM78D8AjsI4WTcHUM2UwwOd98zYYMZbDawUUZoiE80fViQDChuhpQbz9VcPXk5ZRwiNsAwc91VnXTWTr6G00o+oGCEwYAdYsVxKpSAsTuJ3WeYEVvNmvkJe8/cRqXyFIMQss/AY9ABG6wRGOhWmgqnwCgJuU2nbu+KJEqe45AiSpGHyk3YbOa4IKZo7ZeZm9r3PbARVIbaCD2Qn2HLe2AbLmRCnQM95LVrIPw75ZN83fSB3yjpn1Gt73v7pPb+5KgtKKTo5t0BXIjjbyBiFmLGGSDZ7PZx4K7b4kShmxyl2SctfRFxIMAfJPoftApSOMcTlbV9PFN0m0aEGTRlvVvhJehtzgMkJKBLVyP8Mlqk+m/+mfdjKP7qoMM/QD1uNd+D7N8WFIN7wkgogNC8Slwai3Uw0SS4mWvn2ZxQ3MSwayLtIoJhYFBE8vzo2SSyGWVytswAP1p59HvBCj3FPn1Db1yC5KgcHZlkh2GWq/f1+pIYIm8U009sPZfJnmmWB7eblRFrooUmdDeDa86G7yxEOYzVgLk1XmH/lp3rGkLZy6kiMmqokLYsm2srvi+clampab0+kllG6lM4TyCzIWcon6MqM3+KIUvjZ6yRc5r0BuBT1KV5yfeG+z1wa9sv2q2pQ5tCYawLGROkm4JpkWRxKDFJDCXCovaH0wOz2FhrLvF1sfvvprAUAqKPhE99Zw3wlBcJlA6IBx3xJ08j+g
 RHqKd9Zv
 dJK7uogSwAiODEQt87An9klS2lmqogNmLjSnN7NmSj6b5ce0b7ys2K2o8C/F0lqGCB5posJMuaJmMGH/052sAQ0zVPRozq5VO8cBR+tNbpKHJI4N1HB+M9Uq7HS2zEBrV+7GuRxkrDHooYqv1wW6tlN4K4UVCx6FC75VnPjwKliWGMGTyGUtkEOl9C1mtC1DOWnwxLmJW6CY/Fda0m0XrWyMBmXtv9yyHkOD9kujmEtK4v//5O0QvRqG4hgcC6ahP+VbHwratN35iQ4Mr2L+IYuwL86ZXG1w+LI4H6lsEAPX+6zusOtgq2DWjDA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 8:42=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> Now that all the symbols used by the CMA heap are exported, turning the
> CMA heap into a module becomes pretty easy: we just need to add the
> usual MODULE_* macros, import the proper namespaces and change the
> Kconfig symbol to a tristate.
>
> Signed-off-by: Maxime Ripard <mripard@kernel.org>

It'd be good to add a note that heap modules can't be unloaded (unless
we add more code to verify there are no live heap allocations). With
that:

Reviewed-by: T.J. Mercier <tjmercier@google.com>

