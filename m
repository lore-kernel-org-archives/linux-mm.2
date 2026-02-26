Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92867FD8FDB
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 16:59:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E790D6B0123; Thu, 26 Feb 2026 11:59:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E511C6B0127; Thu, 26 Feb 2026 11:59:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66866B0131; Thu, 26 Feb 2026 11:59:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BE4236B0123
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 11:59:07 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C29458638
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:59:07 +0000 (UTC)
X-FDA: 84487217934.05.331FD5B
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 6C76814000A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:59:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wgwkr2WX;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772125145; a=rsa-sha256;
	cv=pass;
	b=Dsws3pLK1XV6J8uGp+KDp0KsCXrnNxzzoKiT4w5/PxjsT6qnw7KqIO6Olx8UQdoxi1Nlj/
	bipynPgA4PhYrvFRODsmj8mPu/VGXwRf/Ef+rcsIBQgRJl3NFaqegElkRFReOPR0YaEaIs
	/qpng7j7W9vDf7czGP4PcepVAXbiZtQ=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wgwkr2WX;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf23.hostedemail.com: domain of tjmercier@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=tjmercier@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772125145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaC7hfbtyJLGGerhfBe2P9Hj0mHnDOXyDJFEYnDiBqY=;
	b=sRt4Mju99MktzXSoE+MbOHGFrig213h2qOjkrqCkV4TsFfywbLxKiT1oHZ5UXBSdpsV6Rc
	GnXJZb5EAp9XWOi7zQFGxEPe1iGSReFWXu2qPqrlo9eY5Yr5Ba8l8Deb0duD7tPsNlzExN
	53J9QxSBgCrpfVrXueLCP8Hjvz/UNXE=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-48373ad38d2so106425e9.0
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 08:59:05 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772125144; cv=none;
        d=google.com; s=arc-20240605;
        b=Rw7o8rAJs9XSm0dpn+RAIjaHuaigEziVivGleiPI+U20Ogl+rR3tnAVxpnqItsBGu/
         mdG5P05N+IqNGZW3we5TPKURbJBvnQIE6+nnMQqF1bfguxNR81424U3RDb7xqpkB2VjG
         sSHBV9NrK6jq4WiPgo2QD8VokChb++DbcIiv1U2Ent6zIjhgq7lNPpDt0Y2g4xgFAjpo
         mWuLXxDhPDDY3PCikpiEJbKPgJ0VH3oTUEeHl+luxPGsgg+JAguFAEsncM9ogMLVOwo2
         aGv0fbItDyI8GERmjfpdKSPBR7xnu8EnKxtIdoQ78c8ruqeIABG08qDSbSIs24KZePNQ
         me/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=GaC7hfbtyJLGGerhfBe2P9Hj0mHnDOXyDJFEYnDiBqY=;
        fh=h1rlcT2iHkMGo38aHZyUu+VboN40rpHL/U/u5/5k0hE=;
        b=auZJlmC+H8vvjHTsnKqa9ja/QgapdV4jwruRyu5O6Z41QY5YqNW8dh6dtlDmg8WOff
         TCg3QfsPmTCKlXxrj/019sRcAda0Y8ydq1yOoxW+QTpS6im9NL3+ABqRhI535sio4Que
         D1hYPFTVy02GAIZdlxOMZqngYII7TMMDf9Vd97tfJCutaeeN7AQseVCE4adjocTLRkuj
         8NFo8XssJ2/T6fHRkN/hFMxm3gpCdCZ5XV9VHQPsV/zObtv9+f4ABu0e7vNV58cDbeBo
         Jz85vqrOiKw3ZwnLD/dGz0sfoyM39s31q+N2tw0ux/CRExsehQVi3n6E00AMNr7TqPEz
         zBXA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772125144; x=1772729944; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GaC7hfbtyJLGGerhfBe2P9Hj0mHnDOXyDJFEYnDiBqY=;
        b=Wgwkr2WXCG+D8P72UHRNpPkhnvfAG1y1oGVey83TiUmI7VQ9lJpnhMNmW7MUSmdrxs
         zRM6Nsg+MHaYvRvCtwuLSeDqQ7DyGvZYdtGTV7Y18WLIirblNicKT42M2RBZleMhwt2R
         E6MZ8ldXDtp58jKNxgD3POzB/EOdlZOZBXJ1S/oSa2kzqE9haQShExzmMbiaDZRkdkuz
         3g2udd8xIM1dFTsJl8TStqp5yOz/EaotfSHa3kDqnmg3QGJ4YL2oBaj6rOxpSqEXIlgx
         GSxPZFT6Evg29MODa+Mgaly+ffryOS1i+6wmnwqqvNysZEJcJ59op9/pe7bwSssw/EPP
         pCWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772125144; x=1772729944;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GaC7hfbtyJLGGerhfBe2P9Hj0mHnDOXyDJFEYnDiBqY=;
        b=fcRVgbDM88CfcAyG8ZsAAQwhYP4V+9ewdEPBB+s0jyZXiHQCx1qHUsRbSvHREHmT9Q
         hA4Soq65T7ZYnib5Y0zUVmNdPT/8MnWo7QhEUlzcvBKm4sgs4ZtizF6qugk3Z/JdG1K+
         E5TfGRksJmDy3jPXPs1pyfeIAfYMy1oUjt2OtYETihO0/lRI+OBPnviEreDmjm3veAM0
         lMZ1wYcWB4Rhf4K6hlIrzp93K30y5xooZSHEbPZ0A0LqQTBkZDrbe7hrgZdY9IFLf4+3
         O4pZ8a4SBorAD8+LW7wiXtRv+VWeLebPC2QtTDoe7QJJaXTMBkBRkZFHnYf7EhUFB/l+
         wkNA==
X-Forwarded-Encrypted: i=1; AJvYcCW7Ac8kY5EH4hIgoi8sfZdXWqWp/SBL7u9vLHpGegbafG3aT6ToxJMtXR5uD5lZreAPi7qqHqhEpw==@kvack.org
X-Gm-Message-State: AOJu0YxvycnQkGMPkpRdw+180ZtfVAZ4SJcYO3dqsoztk/y20hvuS/f2
	Y8DvkNhciBPXLupuw+5ofhBLBfZnBXc1hHL5dDUcA8ikSxScxCI6xBIZnMcnfC0iwVCohSNIe8W
	wnkguyaDCsZBAvujZOLWbt5qfSa9g6CWXbq1xqztI
X-Gm-Gg: ATEYQzwjBL0f9H1rVtENjaWjL03Q4IHyRkCwDLj/ourvbUTb5YGbQFuDrWPvGIte/x7
	+7UQZ0fB+BDm5waTJwdBnhXtGuyf8iax1trCtjdt77qIerpp/0dN+QR6lX+FZ10MHeqYEdEQcin
	RS5arRaBmw6vmsvcufMe08dC2WUe3IxDkoztsUsbOIDluFPdtWd1hhhFvjYoWyXLqvLbOEmZbIS
	8HF8bmid66Dr6HSoreMBTAyZsq9na59InOHEP6mnbnUZ6nhpuiD7Jjcx1yPd/EYfO5DHggB92Gc
	/m9lu1+ibMzWiHZ6UDez8pR69diTj0lp2Qu+1IfKQ8DKrLXL1vkJVjc2JQqN/LzcHv0PQQ==
X-Received: by 2002:a05:600c:4f16:b0:47e:de1d:ce99 with SMTP id
 5b1f17b1804b1-483c31a76e5mr1276055e9.12.1772125143309; Thu, 26 Feb 2026
 08:59:03 -0800 (PST)
MIME-Version: 1.0
References: <20260225-dma-buf-heaps-as-modules-v1-0-2109225a090d@kernel.org>
 <20260225-dma-buf-heaps-as-modules-v1-2-2109225a090d@kernel.org>
 <60ecebf2-a708-4797-bedd-588c3e9931ff@kernel.org> <20260226-impetuous-analytic-jellyfish-d4a86d@penduick>
In-Reply-To: <20260226-impetuous-analytic-jellyfish-d4a86d@penduick>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Thu, 26 Feb 2026 08:58:51 -0800
X-Gm-Features: AaiRm51ICxvhnfb6IRxyaVo1JANC2yUPYPY4UyYDMkMh1Zp0Qc24kArQnpKFuW4
Message-ID: <CABdmKX0KZLGaJWBoo3tkCxLvby3f4Fn0nMCLyz4a-H-9J_CtPQ@mail.gmail.com>
Subject: Re: [PATCH 2/7] mm: cma: Export cma_alloc and cma_release
To: Maxime Ripard <mripard@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, 
	iommu@lists.linux.dev, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: axj9psottuo8in8qijhiyq7qna7dw8mt
X-Rspamd-Queue-Id: 6C76814000A
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1772125145-798476
X-HE-Meta: U2FsdGVkX1+/83YXwi6AOFB3P7ctPGEuTThrV+2kWPX8Ms2+uwVEpX5mFxLSDlwgJPONy0aM6vvf1xa1oYoIswHuSQmA9YNZaVpqFZgTq9VGehqIjlf1td5fJ+iQXuQcGhFFHIMH02HaC6YoOiAGOcN1b90iI6pgDzMYx71ZXQLpf6LR+J2gg6Kllsa6IuEEaG0Edfg8sVuzO9lwrf+mXlHUOj8eQAJgt0RrmdnzFGvHsZt5E077tw6m1WgkdlZBscwL927F0ycXsqA2TlyVmno0q2P8cXsF4Q0W7XK/E/yunPdTRfb4NjYfPfmZIJv1JocSqKvhSMiG47ThmTspjNXDqtifRBhAoeHh2g9kTmiYoqMXtr3kS5hOwWhqKH1ETGHtwHdZdj9p0xcHWC1dyxiBqXnjpUuBR1b6w/9WKGsgfCzLDjaqV2ELnYiZ+ZUIUzblDIa1gDXikfHHm2y8prnoVL91C52YxMbO/bm5WoYtnF5/paWpKQXK+DmEqyJgZPKVajDtmXQCiGa9vbpHZzgS0LBQWcPKkJe1ftHAB2QmwcsZ+gviJqiNJK2/02BOxNXIkyCOkk6LzvO2TOq/q/EXzHGVfUkpxcB+WMLgwq0V5JrAhxaont2mqp6fbBpJL3hawAhuC3sd8eWD0PCcDzIpOi9JYFlqEWij296mh17ufCEmMXx4zvDz2F8DmdnFqAyr6elb2c+Mo10OeHnZrdbxThR+95O7SSnpEO8uYTDUWh6hucabR5XxC17WUQaunOFuASw8iNT4edjdYyZg4Litrsrq3/2fMeL1nVRULJTOypDl61oC6JrtyXkKresI4M12QXEM7Sa/QQAZWKs8S0YY+7o2HUkyS66buHSmb5Wf2klTcQ+q3y/xX3V0MI+SG3mWd8GoTJkLxvswY437eepk5X5OhD1zKuxJmad1gk9+YcKxYqgP9jFW3GAC0BzcayrwvXQT/N1NLCfyVdM
 bueb9bpi
 rl8fgr0JeWOCbs5awYF5M7y8U2suxmtIV6gOAUt5/Af9SGboIcRUhAqVVfKK/GolNvc2Q4IDf9vbL75ub+JjmN7pMV03+nzBPnJuGxyAlAxkPSfh7BnhjhzWERojiGxfRZrRFLHSBc2EjeeGuv50FfJdelnL1jHJfwXQxZR9dZ4k3w4cO32yLmftdb9jqJ7FfRou3BWIW/AMb7fxScbah/Hr7F1PRvoKimgY7akjfFQ3ZjyolhkCu2g55KZ/LSn4qmk93AR8BuZ23SW/k4bt3GHMt3uruFrC5qTsGNgbhXnRG4jgQAtSem2TSaQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 2:38=E2=80=AFAM Maxime Ripard <mripard@kernel.org> =
wrote:
>
> Hi David,
>
> On Thu, Feb 26, 2026 at 11:25:24AM +0100, David Hildenbrand (Arm) wrote:
> > On 2/25/26 17:41, Maxime Ripard wrote:
> > > The CMA dma-buf heap uses cma_alloc() and cma_release() to allocate a=
nd
> > > free, respectively, its CMA buffers.
> > >
> > > However, these functions are not exported. Since we want to turn the =
CMA
> > > heap into a module, let's export them both.
> > >
> > > Signed-off-by: Maxime Ripard <mripard@kernel.org>
> > > ---
> > >  mm/cma.c | 2 ++
> > >  1 file changed, 2 insertions(+)
> > >
> > > diff --git a/mm/cma.c b/mm/cma.c
> > > index 94b5da468a7d719e5144d33b06bcc7619c0fbcc9..be142b473f3bd41b9c7d8=
ba4397f018f6993d962 100644
> > > --- a/mm/cma.c
> > > +++ b/mm/cma.c
> > > @@ -949,10 +949,11 @@ struct page *cma_alloc(struct cma *cma, unsigne=
d long count,
> > >     if (page)
> > >             set_pages_refcounted(page, count);
> > >
> > >     return page;
> > >  }
> > > +EXPORT_SYMBOL_GPL(cma_alloc);
> > >
> > >  static struct cma_memrange *find_cma_memrange(struct cma *cma,
> > >             const struct page *pages, unsigned long count)
> > >  {
> > >     struct cma_memrange *cmr =3D NULL;
> > > @@ -1025,10 +1026,11 @@ bool cma_release(struct cma *cma, const struc=
t page *pages,
> > >
> > >     __cma_release_frozen(cma, cmr, pages, count);
> > >
> > >     return true;
> > >  }
> > > +EXPORT_SYMBOL_GPL(cma_release);
> > >
> > >  bool cma_release_frozen(struct cma *cma, const struct page *pages,
> > >             unsigned long count)
> > >  {
> > >     struct cma_memrange *cmr;
> > >
> >
> > I'm wondering whether we want to restrict all these exports to the
> > dma-buf module only using EXPORT_SYMBOL_FOR_MODULES().
>
> TIL about EXPORT_SYMBOL_FOR_MODULES, thanks.

Ohh, ditto.

> > Especially dma_contiguous_default_area() (patch #4), I am not sure
> > whether we want arbitrary modules to mess with that.
>
> Yeah, I wasn't too fond about that one either. Alternatively, I guess we
> could turn dev_get_cma_area into a non-inlined function and export that
> instead?

I checked the history to see if dev_get_cma_area was converted to
inline at some point for performance, but it has always been that way
since 3.5. That'd be my only worry with un-inlining and exporting it.
EXPORT_SYMBOL_FOR_MODULES sounds like a better way to me.

> Or we could do both.
>
> Maxime

