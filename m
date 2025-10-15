Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBDF6CCD18E
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 09:14:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3246D8E0020; Wed, 15 Oct 2025 05:14:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FBFA8E0002; Wed, 15 Oct 2025 05:14:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EAB08E0020; Wed, 15 Oct 2025 05:14:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 08D308E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 05:14:26 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id AD28988BE3
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:14:25 +0000 (UTC)
X-FDA: 83999787690.12.4758A05
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id B75A9A000B
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 09:14:23 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X6/fqgpE";
	spf=pass (imf15.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760519663;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNter1wl1oLLlJYevVTo4vpc2F0Z/0nnhZY0eR5fUuY=;
	b=Zok5R2zml3PztJzZ6xhmIYZlAav0Hx42bmJJ64SS1w1xKUMHe++WXxKHWELjAQhIOAwWtI
	axLgHUsh1qjpcF06t8wprLkuJTMxPfxcwxQoZRAqaXFt+UmkQHdn0X0fvbial4O1pKJ1nC
	8gcZWXoP9U9z9+kAjI6PDfbYPnQDKKQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="X6/fqgpE";
	spf=pass (imf15.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760519663; a=rsa-sha256;
	cv=none;
	b=u5nyQgbm6BUqdsgROOM6YKp3GfpTEtyBYcRxWhoIiQ7Tiky477ekjDZD0koCDvD7aCvmYS
	fMcq29sb4BhOKnSQGlEtf1IaBJMvdX2t990KXoPdkc0aopjuXCmY0n596vRZ+diz5pYnBJ
	jr4wp88e9F6ccH3Z5A8JO1CpIDBlUL8=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-37777f72838so625831fa.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:14:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760519662; x=1761124462; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNter1wl1oLLlJYevVTo4vpc2F0Z/0nnhZY0eR5fUuY=;
        b=X6/fqgpEHzcVIAmhThdhKPw/4LcleyW8u4253jUYDsMbFx+9wAFr1eNIXneyg4f351
         v//WWkgb+HRKbc4RIKp0dP0bNun8XV6TKaaWcQ7HSvC7tRhURSdDUY+Fa3bkYVib5DZz
         Kax4NIO2SYTyoy5eKCXLPH5U9P0XKWVP5We3dv4nnRkDPXU3K06COsfgh7yodsEv3z8Q
         4T2K+TKp92+25tLPdz8hmrb7Lk8xvLZoSdpEbI2Tk/zXOuDSJV2Br3KF5iMSk20dAhn6
         fPP8lnZNtq5WBZLcTsAIl7ZXflREYV+aEHPTmfsvsYnK451FkGcMRnTzZH34sKrAq8Bs
         aZGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760519662; x=1761124462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNter1wl1oLLlJYevVTo4vpc2F0Z/0nnhZY0eR5fUuY=;
        b=Lbl1zfC/5J2AP9CboNBcdJbWvdJrlh7K/hASaWTTyFiGoEThVYFf0nAujohdFuj2X2
         SCEdh6T+NOTMUBqrFFLDLcyyonj+VcigggW78qQygKk7gRJwDrY8LpM7kaBw2uUKMFmR
         9aqhghk1VsilYumBEBHs/BJjXWgKU7HnYEszg8IKGI1QtdL0D3LYTlkW9wcGY/gf8oMd
         4ESlT36BiN63R1kK3r43ueXt4v4hUid+Mkzl5hxl3HJIC5jXyzlPmvBnjj3I6R6XyJ5B
         4Jh+PjsqAxg41jHyr0ehDn4Dvqt4NOTYWGT47SA8enoae9vwAV07+W52ymFypMBkRiBI
         qAag==
X-Forwarded-Encrypted: i=1; AJvYcCWBUEay3zIKSgW06SbHUei1AO3g2vBWoLdfFFfDvES2SCDQzu6YY5+qM+3v93GzRyYverfakRmUAQ==@kvack.org
X-Gm-Message-State: AOJu0Ywp+sKnMOK2V18ZCi8JoiJW9NMPNSeKQ5UPMluq+G2a+FXtRiMn
	NSMMzWb4sdPgukXMpE0DG4t+zIxbGe7XfpmGLEBVHrOkfO3lB5BtCPYy4uTW7dfKzx7UinBSeX7
	AGZHtl/hASmalocISHUAjl7IKFHhxal0=
X-Gm-Gg: ASbGncsB04vQabtokLqbddiZCOuGH9wE85lJqzrf4dfEjaWBxHhWhe6RyXGIvS/lB4j
	TvmLPF/7HJQ/3N+Op/G8jpdjXKstbVTecKkBzuDZ2pvS6zBH/FEIF9EWbTPDSHG+lhYSargO34u
	vm0dODVjG+MQZqQYO0GhanNsB8E8wGqY6m2uOY6amXAw1e+QM6FGBAORm4wsCAAH+LqbNDSqGwP
	7OLKlkTE4yDssg6ACvmNUePW0HEBp0RZGV+aw==
X-Google-Smtp-Source: AGHT+IHIzIhf1YNCI5C8onxDXaNTHHoiFmiOUpxt66KIf78orh4sRuZHDUQFOMD42XgkZiDlsjMqDxaFdaNS5QPVDow=
X-Received: by 2002:a05:651c:19a2:b0:371:ef15:f19e with SMTP id
 38308e7fff4ca-37609f1b402mr41581191fa.5.1760519661576; Wed, 15 Oct 2025
 02:14:21 -0700 (PDT)
MIME-Version: 1.0
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-3-zhaoyang.huang@unisoc.com> <87953097-a105-4775-88a5-9b3a676ff139@amd.com>
 <CAGWkznGN7W-txq_G+xpZ6DtH_1DNorYc=CxqUjebo7qfB4Sxsw@mail.gmail.com>
 <ecba7133-699c-4f3e-927c-bad5bd4c36a3@amd.com> <20251014171003.57bbfd63@mordecai.tesarici.cz>
 <97da9924-9489-4d30-a858-8ee5c87bc031@amd.com> <CAGWkznGnmb=8GgcrfDvY2REHdRZYVXZy=F3thXhK0FaSoiK7tw@mail.gmail.com>
 <aO8TKQN6ifOSMRSC@casper.infradead.org> <CAGWkznFG2_WGmLRmHnjV-49iTX0mrt9jxQBzZYK=K9U7eKJD0g@mail.gmail.com>
 <20251015104008.4bcd99e7@mordecai.tesarici.cz>
In-Reply-To: <20251015104008.4bcd99e7@mordecai.tesarici.cz>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Wed, 15 Oct 2025 17:14:10 +0800
X-Gm-Features: AS18NWBFNrpCd7vYazsrAzxjhFltbgGwOyCb8rBQZuWBjfGrYICxBoM7m6ifLQ8
Message-ID: <CAGWkznEkVz8p=Gbc8JC01SLkUHdTPW126z-fsJCZhoOLDSF5vA@mail.gmail.com>
Subject: Re: [PATCH 2/2] driver: dma-buf: use alloc_pages_bulk_list for
 order-0 allocation
To: Petr Tesarik <ptesarik@suse.com>
Cc: Matthew Wilcox <willy@infradead.org>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Suren Baghdasaryan <surenb@google.com>, "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, linux-media@vger.kernel.org, 
	dri-devel@lists.freedesktop.org, linaro-mm-sig@lists.linaro.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B75A9A000B
X-Stat-Signature: 7uzpbz6om7td81r35awem6esyko4d3ob
X-Rspam-User: 
X-HE-Tag: 1760519663-793050
X-HE-Meta: U2FsdGVkX19dROBh1z8rwfst5nrGz7nu//umgEUNHdf7MrViDsaQFy3HkKtWwTbKzgFRVxM4YVoOA7L54CGafn83cItJ7JhMksqr+5/ZdFa+7NYNsg8lrSzHYfk2/FWFVzKmb12ABEuSR14JqVqJp8tucNBIrrqQYFKxWltOThTqfRfL2ZuUmspbcVayOyHvjkbbQF0Ufd30ZfaXjXo+Sr+LLT53Ik6qUbAVJXRDORKbz73bAOFeuPh06Ib7sSYm5V1+14+Nh0s7ZvolpwI3g7YcRte7PhzA1dpbYx9HQf0Ko0L6rTDbEV45f1ECKqMrMZdstEs8sB5ifO5DolnGRMk4U1gggqqtQomsX2y4wNrMRbyFeFxb8qddbRAvaduTuMfVPKbjMpd0aKgJkhpjiDlAY3iQ0NmlJK9ihTOkatjaDpWZIYisQuPBwZgtdM/cBLAFTnAuK59jhxhEOOILK/QLP1iyKutfBW5zhFJ9WpvafOABNjYO6jZwiGwduDHZvPQoOQETa0JK2nOrbeXK5EER2sTbYT0EJM+wMu8C8Cl3/wR769eGXPUSOIqJyfUE/dyYT3wpAZem0NYO9bZWbpNnrTfzCOaXYDLRrlfcEl58JrWzd8SYj2fEe5wzoq1s3ClMhFr/OGfTV/y2m1B4HUc2K94724AQTyJRabo9NYmvT9uwa+sC504sWfA+9gIqBZW7OgkSleppkIviLEPuOJfCw8LboedNuZyhrn0+ueBJO8fCxZjd4cS60tofstKAgAcfOUWZkFGlenjexNcKCj94ufDod5h1ZNDC8bzbt0NwbG0Vfr55KwsYCVQDklWk3ZLqaAyAD+lpIIFHJp56lcifspVIyzm2pnI0EEfNW3I2B2+MIbNIvjKhyLFtM2Kh8g6IJ3l1sQUO1tCX6BGmfVudiSSVrgeCZbO21SWSQa9nZr63vFMr8rMun7Ym5FRtOQWNF5A8UvbPgA0L6Ma
 oHGi9Bi/
 NYIX1f66evp/A4+PwUX/HhfxgSrtcVg/kzWeepieTwCgwobajSuFqNvWajLh9V1tZOnihuhCTSULd72Boslx2m3oBy9F5PU5fPJaYdENsQ7N989DUVcvAKojx6dRqXHjSX1nwh87gz8SNpP5cob9WvWg3j+c9nTIdOed3FXzjJns9EUxzEm/kAoeQFDUrjl3iuF28zWBxKde4OtI0C1gNPJYN+gS4c8F82XNVGF9SdmpU+lTniakEIEphINtPWqYG4GkUr7Mo/OlSW3gCDTYFgyWe4hLNGvS+7kVlbtWvoVcnqlseOfh8U0dIHh8cAd+QC0EJ1mTumxLkTYXKSIg1f4nxXhFqrY2y2mH1Ncz7NsKroHO/5JndwbDj8iYeXSnm06lRxCzIgad9Ab9RQyFylrKNrbdMH5km6k0Ovp8kGPHsKfYDhI19Wzsl5gi7RuCeqmuT3QSMnh23a5Hz+nVuZfDrao/eJ2MX8WY5HzMP9ic4SIs/3THjBJjYuW3JG1Jz3CL63mmSQ3HMTLsj8rVN8hgaqVT12ljVJKF0sJDR88HttvQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 4:40=E2=80=AFPM Petr Tesarik <ptesarik@suse.com> wr=
ote:
>
> On Wed, 15 Oct 2025 13:52:57 +0800
> Zhaoyang Huang <huangzhaoyang@gmail.com> wrote:
>
> > On Wed, Oct 15, 2025 at 11:21=E2=80=AFAM Matthew Wilcox <willy@infradea=
d.org> wrote:
> > >
> > > On Wed, Oct 15, 2025 at 09:12:07AM +0800, Zhaoyang Huang wrote:
> > > > > Could be that we need to make this behavior conditional, but some=
body would need to come up with some really good arguments to justify the c=
omplexity.
> > > > ok, should we use CONFIG_DMA_BUF_BULK_ALLOCATION or a variable
> > > > controlled by sysfs interface?
> > >
> > > No.  Explain what you're trying to solve, because you haven't yet.
> > Dma-buf works as a memory allocation backend could loop thousands of
> > times alloc_pages for allocating order-0 pages to fulfill the dozens
> > MB demand, this commit would like to replace the loop by once
> > alloc_pages_bulk. Whereas, alloc_pages_bulk_array perhaps introduces
> > extra memory allocation along with direct-reclaim which could be more
> > expensive than iterating the list. so call back the API
> > alloc_pages_bulk_list as well
>
> This does not quite explain it. IIRC you mentioned allocating 18M as an
> example. The ideal outcome in that case is:
>
> - 16 order-8 compound pages
> - 32 order-4 compound pages
> -> total 48 calls to alloc_pages()
>
> But presumably, that's not what happens, because fragmentation makes
> (some of) those order-8 allocations fail. Since you talk about
> thousands of loop iterations, it looks like even order-4 allocation
> fail in your case. Then I agree there's not much value in trying to
> avoid further fragmentation, and after so many order-0 allocations,
> it's probably also pointless to do memory reclaim.

Thanks for the words

>
> OTOH I can see why the opposite approach is a bad idea in situations
> where fragmentation can be avoided. To make things even worse,
> alloc_pages_bulk() will rather split pages in the preferred zone than
> try allocating from the next best zone.

but the loop of alloc_pages(order-0) could also split high-order pages
one by one on the prefered-zone, right?

>
> To sum it up, Zhaoyang, can you please describe in more detail what
> happens in your scenario and what you believe should happen instead?

My goal is as simple as eliminating the loop of alloc_pages to get
some performance gains.

>
> Petr T

