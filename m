Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2292C531F7
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 01:15:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 208C76B0005; Thu, 19 Feb 2026 20:15:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18C416B0089; Thu, 19 Feb 2026 20:15:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06DCA6B008A; Thu, 19 Feb 2026 20:15:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E62EA6B0005
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 20:15:00 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9292FC3106
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 01:15:00 +0000 (UTC)
X-FDA: 84463065960.23.DCDB53A
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8D58D140006
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 01:14:58 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DpF16bFb;
	spf=pass (imf26.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771550098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmKdALZJb5FBSVFY2g/62lb/+tq0bPSvdEv6SUxXw5M=;
	b=onfjKUqZIAPwLg/dcA5zcU2/2ASI/lmUtMpaqk26ZSxM65wdJIa/Ep6FhYZHSRO1muV+VZ
	hlKY3UkHB5quvlEUYAL3DIEBScA/1+0T70tbvvLY8NkmjrepKsP9IiKcJ4WKwakgAnYoF7
	a7xXFygnbaMC8Vxz2ynK+TfxHKxCPYQ=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DpF16bFb;
	spf=pass (imf26.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=tjmercier@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771550098; a=rsa-sha256;
	cv=pass;
	b=fZqJsDieDj/otEEMg5v4Wn4EMNBAt8QvwAqMxKDIphTUCpnN0nJdKZQXaXbmrvtJ0JPcrU
	6vvxtuloQUT1vZ2GQp1k4o3bZvU34R0XvydCGQKmTnjl4t8baPefy3sVkWdsH2eZO2nGVs
	n+LtY5AD0cYTgaQx9AvGzUz6CLckbg0=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48371d2f661so18675e9.1
        for <linux-mm@kvack.org>; Thu, 19 Feb 2026 17:14:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771550097; cv=none;
        d=google.com; s=arc-20240605;
        b=F1+JsUZPT7n4/XaS0+QFWElPMeyoIMivPUa/EDYZl8lUtoQB5G/bUJ6keF7/cIx+pt
         IekqJlSarAIXqERfXReGiPxsOUlLorjrqA3dFo05ayMcSxoNrs33KVWhpuo/3lZYiwNM
         mqjoztm7Mqci5iHJoTxPjLNhjoqG2u89KVd2I2t2jwIVkqfD3sDBbM90FRRaTt05g4ma
         t7HylRx5HDkM7bXVAc4L+WRzkLwAEAL4OtQbq7e45kpzfx64VoDrC/o647G/+baGn6IM
         RKVIprF8yQzQJ9dHrgs0QcEsPv4O48eeNtuZHS/tJj6UBb+JogYGWPMpdCaIcFJKl4Yk
         U6Ag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nmKdALZJb5FBSVFY2g/62lb/+tq0bPSvdEv6SUxXw5M=;
        fh=J/FZJFRttTmUagUYKMzeqNwbdIzuLcwcYahLxG3dEmw=;
        b=AxrPZ/zBo8wkc7Du129k1x/g86H+yhZCjBrNmxfR7Cr6KWSIqyXV8fUoWd6n7JvFNT
         tTun3a86epFXdANQGShPyvLuF0xs90ghPNHsXMc9QGsnbNo5aGWSybVQ308m18Ii4KxR
         I2D6sUVO0qQH3ks86pyhchO1/rjiUWHtTAbjV+jGWTsvjzcr7dlBXHP3IV7YwWIU1Gtt
         ge4r+dQL39eQo2SKExSRcc/6t/WsiH85vUhaRJMXIPWa1hDoPeWNMXHk2itTwQh8EQwd
         tH/TcESo89gVbiZfOYJ8pO5Ofq+WUY+x+0+/8xH6XZVDExx7AEt/pAExM1Vic5dMW0wG
         pSEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771550097; x=1772154897; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmKdALZJb5FBSVFY2g/62lb/+tq0bPSvdEv6SUxXw5M=;
        b=DpF16bFbiCc1sddyNSxLoumuAAsuiSfSAMMV8TGLgAcVKWRtMcHV7Tvlhiwddgk75X
         RrYxEQBtUHQMyMUzz0pN/2TddF7ejhpEVBDKtQLnlUzVO0VsrLIWCcE9M3BtgaIBmmvj
         CXu57RerreZDA7Ta6mkQawhR9JZl0OS4fnQaivWODsyV0v+BZKVO3E7BvYoVNVi+StC9
         GQVPh09C27Ip5J9QADtlTPYtMbtFTw+jSwF2dXK/HbuhbozT10JMlIfGVZPmFqIfVOsl
         65MGDPW72IsdmttRW+wgPcMm35w1D1f8+s04z28ODEq7NFZYibCEThMMxQiC1IBckl6G
         JJVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771550097; x=1772154897;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nmKdALZJb5FBSVFY2g/62lb/+tq0bPSvdEv6SUxXw5M=;
        b=WXzA1wnI0sO/NQw30gu5K5/f66DGGj+xeOmb2GCk5sSWZwgg+W9qd7QwJzBretWwlQ
         w0NLm+fWAN7fdShoiL1KtejhhVqlhecP2UDOoa2jGm3mbR52hahoRrW4NhCXdUYhkGSo
         iJ0xeQTtJsyMmx1PCKavl7ewWhWHDvTOvw8shOd/QJn3drcr3z89OE7FHvSaXp1GhJsO
         FxV/l0LdjoMraIKZlsHibMp956vJg93dwNLmlG41jmKNU5Nbj7Omw2dpB/9idUTimEOi
         vxM5PRf9mDGX+BmKDc1NJ9vMZrJCBfnlRfzpyGI/sktl/D5WDxnTp4TqVltA52wyT80X
         MO9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUQyvY86nTG8KkxMSllSoL5Km4j7oDdzpVjIh7+jfxSxAi5Czlo6eZDYoRBhpX1kP9dSXj9knvvwQ==@kvack.org
X-Gm-Message-State: AOJu0YyGh3Cwlt4BqtvsvEHCEkmxD7XRew5iJvMtWaxhs8AndG5wGE6y
	xRjS+7vBMNR9qfLB9rK2CCzbwJH6ePn42Y1U7d7WeXk34+a0jZHtg+0kdcVnJJU9R78xaq/I9cu
	FNp67gwKEViMu1QU2GBrPH18qEdwnUi6PoPu0Up2E
X-Gm-Gg: AZuq6aLEumLuifM8AIA88fLUNR6sWipEuRZxSFcrkx9vPOQyCTtnCxzIMJvWRH/X1C8
	nnAl61wFRhsXLKv3lwsusteVI0H9Sho8XomYqjolk8JCJ8Nx7kYxsVcg/gJ+vAptZOvmSR/JNue
	tLCUU2UnDgjNC7ijMK+gWu/A5sSdIIUM/ZOCsawqbg+kFoZbblWhSSA4wMf3IxBX5fsf8l3Rwxz
	dhiCKfQYi0/ij4dKQffRGmub0e72xDXoe3ubabx88tf8w4/Wykv30tmrAP5vS7qFLyjV9q9YARe
	1UdAiw67yV65TqciWtbwHTh6y49gifiwtxgYE4uU/tHO9MQRLt5dkGP9L678gCjwH4zf2fCWBhY
	va9Pj
X-Received: by 2002:a05:600d:108:20b0:483:7f52:162b with SMTP id
 5b1f17b1804b1-483a3e452bcmr287525e9.0.1771550096636; Thu, 19 Feb 2026
 17:14:56 -0800 (PST)
MIME-Version: 1.0
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
In-Reply-To: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Thu, 19 Feb 2026 17:14:42 -0800
X-Gm-Features: AaiRm51VY-6IMlt-ihglkgENMjUfEiHWPo38nPxJvuL5b9iXSTZyagxYxax_pqI
Message-ID: <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
To: Eric Chanudet <echanude@redhat.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-kernel@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
	Albert Esteve <aesteve@redhat.com>, linux-mm@kvack.org, Maxime Ripard <mripard@kernel.org>, 
	Yosry Ahmed <yosryahmed@google.com>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 8D58D140006
X-Rspamd-Server: rspam02
X-Stat-Signature: gd9sra5ad78w9eumjuk1dtfyanr93tso
X-HE-Tag: 1771550098-954817
X-HE-Meta: U2FsdGVkX18YCIGlVFvTWQrh4OxhtP6f4E8jyJZ9XM2kV2MgEsRX2+xtnWb93wF+ENXzLbjx3e3j9G27R5gOR8fGUibCou2alLgvpEBTmodAQ5qNwaly1KBM73d0IKY1atEEAochftgFJD3ubAAIt7hKUMCUTYOHnGk1+8wt7bJOkMHFS4Jb5R4x0A3bmBIY08JD0AAe5THM7ptqY8dPXyCX7aNu+hhkfgX8FwE8N/D2WxUr5LsFZDBaZFHJrK/JpidO4vgGiKoAqmSrOu/BwEXQyDjdZRkvrjcYXhTABGGOyvuqhMNqK0zLCZ7l9cvVb4jfbHrpU8rXi1hPJaHVUgUZV2e25DX0v7VG26BQAX76i58Zcwphu0nFuT+higFPcTjFJj5AyqOCWF5eyX2GU8U0OIfkGa8hTvOExjf1D4bofOw1G6rwI2TmNKjGZMcpQa30i32146kX+UFoRiBnfkBRnIhWCjVSPiN/Z2sdyDNZ1i8AGiYNR3unXxKwtux/5QGwOzZj10fQiTaLojQgh8NRW18Tlu/IV1MS7ibGVQZZrjs29B22nycCyASi7dRh2g2OcGNVipaApfLfXDbaj5ytVJ1hzloOWkvEW0Lz5yl0LuYpZq0ASJcgA/Hrs72DfW8ll3hVptG4ABCnqQlruS3jU/szw0fO9nNZeTEZGjw0/XwxCzwKd9X8m2XZ1rnmraNOyTOaY1W3Eveq83XIseRmAeCdTEalUCbEJ8XPZDks29kV3Trdos3R2xM7TBBlWrD9vmTgFpdriqdDOLaiukTbvY7BAD6VO19uG/6tOnXch8zbP/FwXc6cZgxVKf9MnRnPZXso1Okg+L1K0v13xy/MVOlCQzirRrXuzfYWbm3TYEXm4ZwjmNVgtOrv9CnKQ3RHxIdVWGmoU8OUlU0LJfyoDjqgDzrMHECk/G4ONcQ51seMCJZIPdiKBFxaikFfJaS1gJl7OxMf6ebHO5x
 S9+joN50
 7X90Mp2pmb/+pt+kzHIL3CDCM739VkeBsnXHyGqGCXBkxJcfRKIMWtDB53AYk0PJEaO9I+Ef+zzDH/PGPb68yl/D/5TMWIwuyJgoprazK8/C3RA/Igwy5lyrW6vwNnKYE24OuZ8mPvfhDDbDu6A/ciWmoSxvHE7Dr11a4+72EiTNPrawuTl/Y2fbbbuG21VfovLgtrJTK+W2sssk54HvWu/VMU1Xuf2Fw4ItzEnYTio33aNwmlm2FPNbHklDPzOtbUThxNtjgVJlZ55QEUh85e1WdJqaSEG24Ke3B
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 18, 2026 at 9:15=E2=80=AFAM Eric Chanudet <echanude@redhat.com>=
 wrote:

Hi Eric,

> An earlier series[1] from Maxime introduced dmem to the cma allocator in
> an attempt to use it generally for dma-buf. Restart from there and apply
> the charge in the narrower context of the CMA dma-buf heap instead.
>
> In line with introducing cgroup to the system heap[2], this behavior is
> enabled based on dma_heap.mem_accounting, disabled by default.
>
> dmem is chosen for CMA heaps as it allows limits to be set for each
> region backing each heap. The charge is only put in the dma-buf heap for
> now as it guaranties it can be accounted against a userspace process
> that requested the allocation.

But CMA memory is system memory, and regular (non-CMA) movable
allocations can occur out of these CMA areas. So this splits system
memory accounting between memcg (from [2]) and dmem. If I want to put
a limit on system memory use I have to adjust multiple limits (memcg +
dmems) and know how to divide the total between them all.

How do you envision using this combination of different controllers?

Thanks,
T.J.

> [1] https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@k=
ernel.org/
> [2] https://lore.kernel.org/all/20260116-dmabuf-heap-system-memcg-v3-0-ec=
c6b62cc446@redhat.com/
>
> Signed-off-by: Eric Chanudet <echanude@redhat.com>
> ---
> Changes in v2:
> - Rebase on Maxime's introduction of dmem to the cma allocator:
>   https://lore.kernel.org/all/20250310-dmem-cgroups-v1-0-2984c1bc9312@ker=
nel.org/
> - Remove the dmem region registration from the cma dma-buf heap
> - Remove the misplaced logic for the default region.
> - Link to v1: https://lore.kernel.org/r/20260130-dmabuf-heap-cma-dmem-v1-=
1-3647ea993e99@redhat.com
>
> ---
> Eric Chanudet (1):
>       dma-buf: heaps: cma: charge each cma heap's dmem
>
> Maxime Ripard (2):
>       cma: Register dmem region for each cma region
>       cma: Provide accessor to cma dmem region
>
>  drivers/dma-buf/heaps/cma_heap.c | 15 ++++++++++++++-
>  include/linux/cma.h              |  9 +++++++++
>  mm/cma.c                         | 20 +++++++++++++++++++-
>  mm/cma.h                         |  3 +++
>  4 files changed, 45 insertions(+), 2 deletions(-)
> ---
> base-commit: 948e195dfaa56e48eabda591f97630502ff7e27e
> change-id: 20260128-dmabuf-heap-cma-dmem-f4120a2df4a8
>
> Best regards,
> --
> Eric Chanudet <echanude@redhat.com>
>

