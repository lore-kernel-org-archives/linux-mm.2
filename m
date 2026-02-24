Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB888E9B243
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 09:42:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 102E96B0088; Tue, 24 Feb 2026 04:42:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B0D46B008A; Tue, 24 Feb 2026 04:42:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF54F6B008C; Tue, 24 Feb 2026 04:42:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DCA126B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 04:42:20 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 712978BB92
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:42:20 +0000 (UTC)
X-FDA: 84478859640.06.C80CDA2
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id 34CB5120005
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 09:42:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AXG+c0Jz;
	dkim=pass header.d=redhat.com header.s=google header.b=P8LBZVZU;
	spf=pass (imf29.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771926138;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFXRiyap5BrRiey8XcKRTLPgUy6tRvIlHZrT7O+t8rM=;
	b=EWIpNyJKti14cZfDagZZ8lcINU/82D8Lptm1ZvJ0R6nHfnV+g0HIGN0voogbzVXt6RvMq8
	Flas9GfBojT49LAxGj+v3VPTv2JcQ037GbRMegM3vRJfd5RqZiHG6c8hn+/+Ct7KIAzY62
	AeUY7ByaDXo6Dh0FDgW/Pw1dCBm5VAQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771926138; a=rsa-sha256;
	cv=none;
	b=4JVYhxU+NgolHKRvPpUDK7yRK0h+Y9mQ3HvDQhm5+sfX3EQGMupjTc0Cqb31aoB35tlqG/
	8LzUM45QYupTsR7V7xyVIKt3hQuYyb3k/uoT1Z3FwcQPEQrhysTpx0qbYfrJomKuoszBSx
	jhfTHziItXhJOeMV2jvUt6KiKUMHGbc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=AXG+c0Jz;
	dkim=pass header.d=redhat.com header.s=google header.b=P8LBZVZU;
	spf=pass (imf29.hostedemail.com: domain of mripard@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mripard@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1771926137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=qFXRiyap5BrRiey8XcKRTLPgUy6tRvIlHZrT7O+t8rM=;
	b=AXG+c0JzrpIYpVv4X+ilfAWMx3MP2MdQA5AD7kKX1uPg0W33Ms2+sFq8wiwS6bJxTGNEEg
	h+TtxVhl5bFBrx2lpYO8fcrNi4COu9OFxCtN1eHSD0tND8EF43MDMY/xJRH21kHjvbztOf
	auDF7VjUqkuxmeCTIVJGVMk9+BtGWg8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-190-ZbCVfGoFM4aywcP3scfagQ-1; Tue, 24 Feb 2026 04:42:15 -0500
X-MC-Unique: ZbCVfGoFM4aywcP3scfagQ-1
X-Mimecast-MFC-AGG-ID: ZbCVfGoFM4aywcP3scfagQ_1771926134
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-4836cc0b38eso6769605e9.2
        for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:42:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1771926134; x=1772530934; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qFXRiyap5BrRiey8XcKRTLPgUy6tRvIlHZrT7O+t8rM=;
        b=P8LBZVZU1lxrp+uRUid+l02MDmanjLewxGThrxM3s8wJCfSIBmhnJQLT2RIw1Y7P4R
         7hdjxTlMJ4OjD2WHs4hZ8AXgPNAX5sFbYLj+fTt0nx5BSjM8Srv75tJDgp6Jskd3pVqb
         nGHSJ/P7i5ETJph+auduP51tkbc4RO6lKIyctZdCU3c7MsQ/W0r2j3TbpQ3VKQbshqJ3
         vIaC5OekXapPg5ksu9M9x/QeFJuO+VWKtQXDXMzUuDY1BXWjOU7RnhtIW95yPlCSXDfM
         tAO5OxpXsX8B4dirXtk9C1ZSa55hY4AtVTRGWswtIu7HeSx1dfF9855dGyeALM1dSrma
         jB0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771926134; x=1772530934;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qFXRiyap5BrRiey8XcKRTLPgUy6tRvIlHZrT7O+t8rM=;
        b=gMyLFY6/Q+tAoFAdgo2NkFPw7/WiLWNaQQDfbORJBvwiV4KYMZsDoqjVPqEHeL0e/d
         lcCGhrcqG5Ngt9nUE0sXfaxCfeXdRtV+Q7NCRAphWdDYbSRTBt69QJNF8rdIEsiiwiLq
         LJJR83gKcRQLm48gKwDYPPhjNAiWsYhemZ/Hgs39XDY+mNfEz52P6Ar54E4DOZZDOvsb
         EGbntWf/6Z/YOZwgmLlVz2clMOehG0O4KeETwm3QBaNWKffCOaS34bZATEJ7W1nHGAFm
         ywES7IEyWijDXUj8kXTmJoXZuemjzGyEBh4nKdHZWaENfiW2bSeNF2TWCI8cXhjaGml7
         9BmA==
X-Forwarded-Encrypted: i=1; AJvYcCWcUqXz37Ikg1GjZ5KBpQpQvD/hlWY1ZoWB7Oo7SWLXcr3lviUMUjde3hu6kbahRfYR1+Y6JW7Tzg==@kvack.org
X-Gm-Message-State: AOJu0YxuDabG7Mh8RMVNMzgAfIaJP52J2lVKHyserUXPZKCwdj4WNMUR
	pTqDI+HshzfkskxdhnR7x7nsFXcGioyW9hKytNSIiucX8kpr4NyOEWEqqd/njVK/1ubxU+j6pP/
	xAt4Ws+es/hGqWcXz/gvQqq+uidPT3nnIOYDstYv/A/CfSdpGLG4A
X-Gm-Gg: AZuq6aJFJf4NRj/GdKZreadsRrgtwKGKVfdSxgczLxRV5W3Hp7I+UMsl0HGIqAZbfJW
	CrPbLmBnqDR18mumoCdEYf6zKKVvZNdufH8BRLS5dcZkTa1QNFKf3LyEtlLUZfVVdfNOJnqyD0C
	+l+7gJpoWJHS/cW3yhNrRpqzy5nY7UAKHi/oiP+CBSA8R86CwpbRdeKhZ2D930fxazZAj5bFRsJ
	SOhhLA4eG/vUi5yaxbcShSMKwGvwGfmS/c27ccWuZNZC5OYofA8Lyf7/Y4P8q0/jGGlr3LJYKxD
	73Jkpg0IB0CtRtpUUCiuKeFWOhMwlvAP72wFLycZFsmq0PtoGOZVzr2IJ1sKBrOR4NGIVCboyw=
	=
X-Received: by 2002:a05:600c:3e05:b0:483:78e1:784 with SMTP id 5b1f17b1804b1-483a95aaeb9mr191397925e9.4.1771926134365;
        Tue, 24 Feb 2026 01:42:14 -0800 (PST)
X-Received: by 2002:a05:600c:3e05:b0:483:78e1:784 with SMTP id 5b1f17b1804b1-483a95aaeb9mr191397375e9.4.1771926133815;
        Tue, 24 Feb 2026 01:42:13 -0800 (PST)
Received: from localhost ([2a01:e0a:b25:f902::ff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483a9b7fddbsm253006935e9.8.2026.02.24.01.42.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Feb 2026 01:42:12 -0800 (PST)
Date: Tue, 24 Feb 2026 10:42:12 +0100
From: Maxime Ripard <mripard@redhat.com>
To: "T.J. Mercier" <tjmercier@google.com>
Cc: Eric Chanudet <echanude@redhat.com>, 
	Sumit Semwal <sumit.semwal@linaro.org>, Benjamin Gaignard <benjamin.gaignard@collabora.com>, 
	Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>, 
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org, Albert Esteve <aesteve@redhat.com>, 
	linux-mm@kvack.org, Yosry Ahmed <yosryahmed@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
Message-ID: <20260224-terrestrial-jaguarundi-of-influence-e3ccf1@houat>
References: <20260218-dmabuf-heap-cma-dmem-v2-0-b249886fb7b2@redhat.com>
 <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha384;
	protocol="application/pgp-signature"; boundary="zryjcv333aysdxbr"
Content-Disposition: inline
In-Reply-To: <CABdmKX0LpKJ9tw48oQh7=3CF0UR5uFtgo0OMwQhHBB40LnijyQ@mail.gmail.com>
X-Rspamd-Server: rspam09
X-Stat-Signature: areaggcgemduu6x5i6561q6nxykab979
X-Rspamd-Queue-Id: 34CB5120005
X-Rspam-User: 
X-HE-Tag: 1771926138-306358
X-HE-Meta: U2FsdGVkX19/zXk2Fgg3ZQlwtyybgtw9nddK6HAPefZ+cvRnQQfp+9ScV8mU+2zWMpMebTkVur1OcGAYZC9SkiaIW0b7TO6VWkAYlRux4osM/v8B6z6gjOrmHPrVDz1lpHr4WYvxG5MhRjyB9lMPemtRn0E0gjXyRfPwhT/lREQAg4BPLziVojWPgCQ8NR726MGN2jFWpptaxpIUBt0mrr1q0mSGvO7+4mbpxxT0ZzmM/5AVe/bVB1DEZQQJPnB5SH2TrRdxY6ifo0Ng9A8xuEl2SxOzFMwdPZA0jSaN+nPNeFaG15AWU7K56yvK+UUkq09O4aGohoJTrPGZHIooqIzyVY6YeYlOeb+lkfvB6K3EMfHAb9wNbOHQjmMY8thOYrpn9Uzq2s67ORPTzSdkKQPN1adOWcHEz/k1BUD/Aj+wzGNMxlk/+ILwsxnLOTGK7lm2H1Zhc7zRrvXOrnbGoOVdgaDoQMHEXMApV7+1Fh78eae1M0yPbbG1xN4OgzyBLs37YCLdErZwqgsITqJpSj3SRy8s7+NsXBdy2RU0OW47wSlXtCkOuJqHml506BnShhmOan61/DST7hVe9Glq/54ECSql1fvtqJoLMUYdemaZHp5KJhf3Y7IuMiMHGNWFBLevJ3B4jpHi7qU56GthLnoDzedkWcagh6GCZJeATf3M9VELVkQ6YE482JS2ZJbyWTkgnwzjaTMVOvnVH3wwdwv6wfO8uUWqVaVeRd/iPX2lGVBECym7DQnC0Nq36TbeAD8fsENkrfqRCQdjQUDz/lC3fBvm7y1xsd1f74+jXjPHtAIqt3l1qk7dqtuKy3m92h7DgkpZOtFx+0IB9ri9mbNAb6Pnmrupuc6grITWXJcYNynKLpKG/Od/DpansXqaA/cgUF920/vukXeFvbbWF28z8eCcuVvVUtM66mP2tuA9ZsRnffaRqYm3wLpLhgZpzzCUALvJAObvNrpEJUA
 m83j7LMQ
 /P4tdJs0sbXy6CziQ8mmVRjbT9X/MV35waFBahim9comqTvY7Ezc1mwy817NFe/bfy7IMqLdCr8FAWLMtdvLpJGJ1nJp4FcBTIGXt38C18Z5F8baP3STJzjJaG9q0Lp6GHuXpHmxsDbtJNxAkqHgfC0/TZj/R7SKBL7SyHRlflnvzX/irYCm9RgjF5SgLYPquoxrthrmZ9NiD1wnWYCEZ+HV/m+CUC8zEupMCqza3OXsuc6Ph+bdA8ghhK1FTjGMEPcemWc04YE4ZyDIRZvdUohQLTZn4B8myTZb+/ZKu9WI1t5tdJRc1KmTmSyIT7z8MvJgPIjGbcBHqIDLz2I8xXJl5ZUW/b3YQogLwJOkcBveSAklO/cyHvTB2Te9Z6yHGh7BRD2MfdOUWUpVzSAx6ZiVZmIhR/tMX9FCeaop06nkOFeFkFGjuchMvF5HHE1vsPYGW7FbVIs7QnG7uYKUTuZeDXe1p8X3vU+0jqJK6xcEmBtyunjmF9rxXf7wXoJHKliqdZVyXlD+me+VWoUMgJ7Epch46WFJXhpp7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--zryjcv333aysdxbr
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v2 0/3] dma-buf: heaps: cma: enable dmem cgroup accounting
MIME-Version: 1.0

Hi TJ,

On Thu, Feb 19, 2026 at 05:14:42PM -0800, T.J. Mercier wrote:
> On Wed, Feb 18, 2026 at 9:15=E2=80=AFAM Eric Chanudet <echanude@redhat.co=
m> wrote:
> > An earlier series[1] from Maxime introduced dmem to the cma allocator in
> > an attempt to use it generally for dma-buf. Restart from there and apply
> > the charge in the narrower context of the CMA dma-buf heap instead.
> >
> > In line with introducing cgroup to the system heap[2], this behavior is
> > enabled based on dma_heap.mem_accounting, disabled by default.
> >
> > dmem is chosen for CMA heaps as it allows limits to be set for each
> > region backing each heap. The charge is only put in the dma-buf heap for
> > now as it guaranties it can be accounted against a userspace process
> > that requested the allocation.
>=20
> But CMA memory is system memory, and regular (non-CMA) movable
> allocations can occur out of these CMA areas. So this splits system
> memory accounting between memcg (from [2]) and dmem. If I want to put
> a limit on system memory use I have to adjust multiple limits (memcg +
> dmems) and know how to divide the total between them all.
>=20
> How do you envision using this combination of different controllers?

I feel like it can be argued either way, and I don't really see a way
out of supporting both.

Like you pointed out, CMA can indeed be seen as system memory, but it's
also a limited pool that you might want to place arbitrary limits on
since, unlike system memory, it can't be reclaimed, will not trigger the
OOM killer, and more generally is a much more sparse resource.

Maxime

--zryjcv333aysdxbr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJUEABMJAB0WIQTkHFbLp4ejekA/qfgnX84Zoj2+dgUCaZ1ycwAKCRAnX84Zoj2+
dm9VAX9JuCh6S7GJf/wUUY2RPjeN5/Hr5cmqHNDJmY78HFfnpCUW4mFYqDeZaoeP
aK99/MkBf0bRStrApFYWF5JgHSK2oeVEEzJ9MxforcaAQ09KVjoG4RckJH53I57/
PQy+P4+J5A==
=fLNZ
-----END PGP SIGNATURE-----

--zryjcv333aysdxbr--


