Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FDC5D49224
	for <linux-mm@archiver.kernel.org>; Fri, 12 Dec 2025 13:13:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72D946B0005; Fri, 12 Dec 2025 08:13:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DEB76B0006; Fri, 12 Dec 2025 08:13:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CD726B0007; Fri, 12 Dec 2025 08:13:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BF9D6B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 08:13:23 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E55D686838
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:13:22 +0000 (UTC)
X-FDA: 84210860244.26.26013BE
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0785A80015
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 13:13:20 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DOf5272k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765545201; a=rsa-sha256;
	cv=none;
	b=LGVNMT7RgCtwh1vBLtclMz/gzMICbNfWaZBUCKPSov0U+rboiBac6CM7A9zoWxReHoqlTx
	SxVI4UsQkiazVzKhnE9U1cQLwqVqPB5/0iLdDZYrIfaKOE44BeJ/+QoHZgZwTDdfqEhz/C
	ewk0wI2ZhMB3wo94sxsYtHkyZRL0AXY=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DOf5272k;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf02.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=mjguzik@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765545201;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lRENsSGe42QcAlN79Aq2vwZsd9IsPf+GAuC01/5784A=;
	b=CXCNOOZsFMdKVjLMY/PsxqGwQG/Sghu3w8istclpu9XUnXUjwciRS3/rSHJfreZ7bv60R1
	uW+CoblRQnmmRPwNf4O8ULhTBfzVlJ68dxquF8pq1dnuELZpeM9syGGH2kvanA66z65VAi
	/xt3y173MqUd4Gpm70YJc4BHplPeueA=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b79e7112398so231331166b.3
        for <linux-mm@kvack.org>; Fri, 12 Dec 2025 05:13:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765545199; x=1766149999; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lRENsSGe42QcAlN79Aq2vwZsd9IsPf+GAuC01/5784A=;
        b=DOf5272kYxXVJbtK/PAEaFk7+fo3UmoiW3XZHFfaPERtBNkIWILvvD2LFKWMiUEju5
         ORQc862K6z7DMqUjJuALyRb96s+KbOyEEZDfOeELmA/Hcrx+phIPfGMcgPrz8G3FczNZ
         Kl2CEoJ3QhWaJ9KL/1G8GWOT3Z6cbJVHULcwK8jrRWA/7dbJ4ziCNPYwNkhZVPg4tEcn
         HLbtj2xW6q25hcREWe69rtGWbP5smBZzgJH1+JPWUEawJH59omqH/7dEGe2Q8YaGpodo
         xLk7khodAtSYZXcjz+hhdtzfMugyRdtGYDV1fNsiGTghIuzano8+TAC3BV87bwoyXddo
         66Xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765545199; x=1766149999;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lRENsSGe42QcAlN79Aq2vwZsd9IsPf+GAuC01/5784A=;
        b=BTIQvQS1MsRvE6WlQeZKQKMFMEzhZeCdxus3ZUPcynpgkGoJ9UMnD9oOi/1EmmkgRX
         ScDdyoRIuiCTvq8lp/Y4etGnzE3x8dhPY6unLfc8TyZzL0XYAGiHFaTxt7Ah1L40Ec54
         NRjbWnKV2hdntaM6rXxR9LO673gfRy5OeEmgyezioUQgRiROMJo9E8ADIkEpxxfJshzx
         bsy2of6VZuSVTnVxPZ2wz5MNcY6haNVHhcqmdG98VHs09vmfMA8TBaiyWh2+o9i9UXVK
         KYF4oD6vcMHTtHkFy1PARJDY6JjUFEXHZl3jVcRT/T1eUmbqCbHZBMq+wNi9EtaRCQEK
         iw1Q==
X-Forwarded-Encrypted: i=1; AJvYcCV0NizavM7UQReYOaLAQehagRU2h+Bra9nynD8HQCR6Bx3Rt/nqs6pS6kOgaR3yNZNDgjpG/l1/Uw==@kvack.org
X-Gm-Message-State: AOJu0Yxa+brltjsVr1Qv5Z7ZNMsIa1ff91imSgg+5wzqJtcYLv045D0Z
	+/fnq1GMHzxqiW3M0wM12A9mYj+AL90ntzhrJRnkACrXkUIXSxWAk4HfU7BmNIVj9eHt3escO+6
	QITPwBwRzfWmczLMbifEOIFsY6ZH053M=
X-Gm-Gg: AY/fxX6Vl0tvWNELgD7vH0DvIabmjR+L8fbEotdnFnoqZMWhOPcOXJfKwGoHcHA486G
	pITu+NS+gTC0AvpUirTkJzKYojPPvoFShqDd+MXzhztog6SUV3AE3X870B9TbLkfJa6fRnT+2g2
	js//ZDFuw7xYB3sz30Hxwad5D4mXr2JfpvbvTFLIwJ5hur326KJAAzAvCHKwd/AN54NNZuVeIel
	3wTOWFIVBAcxm/AGxiEgNBQ7nQAR4HuQakv1MnA1HOdaFY2/3kFcxwgPZKuuTinOGtaKbbNMnQc
	Yb7Srp8PdX9snsTwN1lN+rRmsU8KtKFSC901dw==
X-Google-Smtp-Source: AGHT+IGeUEdWSo0UQylax8AjTeoevB9lbUHZGK4SebEVQVrrrNJyb4PU3dS4H5lqX50viNblVESEPsMllC6umiUgfDY=
X-Received: by 2002:a17:907:960e:b0:b76:25fd:6c26 with SMTP id
 a640c23a62f3a-b7d235c845cmr198331066b.6.1765545199142; Fri, 12 Dec 2025
 05:13:19 -0800 (PST)
MIME-Version: 1.0
References: <20251205175037.1287366-1-lorenzo.stoakes@oracle.com>
 <20251205184342.2cfcc73e@pumpkin> <4eea9138-3853-457d-9113-e3caa7f00437@lucifer.local>
 <20251205213449.12bf4819@pumpkin> <d8bcc6b5-eb75-4a0f-99a1-295dcb04dfe8@lucifer.local>
 <e7fb4a23-5ece-4a03-8f0d-58517c388eb7@lucifer.local> <7006fa60-f4d3-4e7d-8c2b-974e9e4a1224@suse.cz>
 <ek7v5vxht56g77kbojo35eqdcqdmxjvguf3tp5wnfydopbthb2@xie6b7r53ote>
 <CAGudoHHFeuEQ0kBYfrYuUPxNQdw4YHNG81JiHPFHq0evUcEczw@mail.gmail.com> <20251212130243.03538bc3@pumpkin>
In-Reply-To: <20251212130243.03538bc3@pumpkin>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Fri, 12 Dec 2025 14:13:06 +0100
X-Gm-Features: AQt7F2o4lX6_1PZCowg_bAaBC6l5PTQi-AggdPUIRfEMVW00qQ_ebTHC2K6_0l4
Message-ID: <CAGudoHHZfd1C1cLU_N+VNO2pSMZhHcFOoBNPR-RYN+NgRGoHEQ@mail.gmail.com>
Subject: Re: [PATCH] mm: avoid use of BIT() macro for initialising VMA flags
To: David Laight <david.laight.linux@gmail.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, oliver.sang@intel.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0785A80015
X-Stat-Signature: zj3zxcjwhjac36ci5fodohbnu8hgr1yt
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765545200-578070
X-HE-Meta: U2FsdGVkX19q6qvTAKlOadsRXQ7+boW8NhNE7d9YYkAcqlwtDQBL4L5WblcMTrlu2Z6ZQWkWXiXqAkkoysZQgIOeTQf+qpdjuZDmF8XB/biOAVuHNRzdehIt9dHZINZSAeLYtSSxxdk05AULcAK4fWEdc573g4go1VAuOZU3GXMmmqDW4GH9yhdYXBIU6hLeUPaCwWfpaH+dRLx2KxTowcBCIPMAAGkwomhMWdHsEpHxX87L/3apYZF6C+Er01CeARu4qMs0/OwPwi/c446kgrpHN7B/fVX4YQ6xxpH67f881RHtCAvIzwZYvk9nEQPC/K963Sh/oyt/qLkSq2BE6xM9wuWuY9IbwUY43o6d7Ik6GRdF3rDSBI1VAPtMFvP2u9pKy65+x+QKnU0OFbXeRwueHCrU9oFyCCh/t604eYx3xyvXHVIgAff52MGzQXwRhEVyRPFXRNHj9Qwh09MeV9MHRyxFf90MqrwALKcecTAmFCC8kuqwloPKHft2SMjbkVPRGE+gyZYRC0Hkky3/XOIzQUhm7RK6hexGtBj4DJ2kgoHyH3FPs6+Cl+KYWDBipOaiXAhlJuPt+HXFDgD16Awxz5kAwQ/Q2jlSqe/ERfdieNlbpgotwT+gy23xOSnOoD65SwE5CDXiOMuACRoWZyxYAJgQKbvQi4VBMsQLGFnCJndHNUh51KaDOZJRHkB0ueYv+Hc1rUwtbC8bOlkphQlgxAx5IvyrhGemnB/8XWlFI7wm1kFZlMeKAAs+phQW4RrfSxNQYX2r+2GRDYQtAACcf2KXrLAFKZyu+Ml+nAIFhnVzjHSiwTuY3WLRV1StvJ4tymnfoGu8LaflRVGfDni48hLR6E26XGzgilCbNVMc8rACO2Qr+m72BynWxPspAGmFEtNfASi/TNTJdjhuWMM2jw5Lbkz6Bw8UWDn1aay5b2w01erH5FpEZpGGs+BH1dNIIc6Tjft0W14lkTL
 9NS2R0XQ
 kv6YYWLOUWmSSrTCjXlhnCFGec0o5O3Gwwzy0MHjF6XmTlsXHHOqHu/GaK3DWH4zIr0CuQ1Op1UULymYd1H2jN8bFERI4F010gmf+1t2KAI0harOFzs11DOT13x2I0kZdOtuWmHHWFBDrz3QasZZPLs4rLFyijvJWt1QmgiKNYxxlgi1HZjlytDjOsVYWOt+7UY3WdTp7u10l8MeBmOaqe4fHCzSWhpkKbr9A68nY/c+ppUVRY6TH9yPcs8B5HagG7vk4flm137k+clecAETFs3ejFOCUsx0ob4VVQjC/tRXECX8qBrFUbbvhiRtqovwZV7gUnZ59gSRikurVeP4168lIKS4ktyVat7QUzeIweow/qprD5xKjSNZMaoKWOLT4kb4vQC6Wc/na5oqIPBklmKfGgTclXfBr2VkD2tfD7OCzPC1XYFCEo1N03k2IMDv+HR55
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 12, 2025 at 2:02=E2=80=AFPM David Laight
<david.laight.linux@gmail.com> wrote:
>
> On Fri, 12 Dec 2025 13:24:57 +0100
> Mateusz Guzik <mjguzik@gmail.com> wrote:
>
> > So I had a look where the timing difference is coming from and I think
> > I have the answer: init_ipc_ns does not have a guaranteed cacheline
> > placement and things get moved around with the patch.
> >
> > On my kernels (nm vmlinux-newbits | sort -nk 1 | less)
> >
> > before:
> > ffffffff839ffb60 T init_ipc_ns
> > ffffffff83a00020 t event_exit__msgrcv
> >
> > after:
> > ffffffff839ffbc0 T init_ipc_ns
> > ffffffff83a00080 t event_exit__msgrcv
> >
> > This is the pervasive problem of vars from all .o files placed
> > adjacent to each other, meaning changes in one .o file result in
> > offsets changing in other files and then you get performance
> > fluctuations as not-explicitly-padded variables share (or no longer
> > share) cachelines.
>
> Those look like text symbols, not data ones.

I don't know why it is annotated with T.

There is only one symbol in the kernel with that name and it is the var.

You can see the same thing for other vars, for example:
ffffffff83808040 T mmlist_lock
ffffffff83808080 T tasklist_lock

