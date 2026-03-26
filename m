Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 994F1106F2EA
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 08:24:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DE2386B0005; Thu, 26 Mar 2026 04:24:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB93D6B008C; Thu, 26 Mar 2026 04:24:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C80B86B0095; Thu, 26 Mar 2026 04:24:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B2FBB6B0005
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 04:24:04 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 44A21C37CB
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:24:04 +0000 (UTC)
X-FDA: 84587526408.14.02A3A82
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1E771C0008
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 08:24:01 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hWZQpWKH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774513442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uwrkRWpWhPgQ2rjDl7v1ppy090ZCsQxxY2hnoFQafZs=;
	b=areFx2iFqVXWcfomYrAx8zZiAToWjRBiWuC0ba4E+Z9p3Pe47TMyAOpCwwdQT0FByTILQk
	YHlicrP9ObleK6VS0ClSth9wzLvOXPggqfymehZFwsUq5o0JoqM/XmmZ1pRCDZNSXkAk1m
	rWWdHuUaEHOwZy45JHj7zPy9SNYr+Nw=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774513442; a=rsa-sha256;
	cv=pass;
	b=65rnIR7YDAz9hWvzIc8vghBrd+AfRj5h/eV/TOGUaNHHo+10DedXqmXJ1DMwIR6GmuVKtl
	cy0h72gsvRBsc4po3b/dMcmzljtffo6LSI3eg8glatuZjtxLHHYPYaAGNwRgTGTvMf6Qjl
	E7eQO6sq+1iKRBPn1e5caBm+x0IPYbc=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hWZQpWKH;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of surenb@google.com designates 209.85.160.172 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-qt1-f172.google.com with SMTP id d75a77b69052e-5091ed02c54so353421cf.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 01:24:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774513441; cv=none;
        d=google.com; s=arc-20240605;
        b=HIPmwnc56lupKXTSnLhtDcGIrWd265grQnRQqWYfgyQwdBFyGi0dtz5iU9lTguu15+
         ZGdocnDW2BEQl0/OtVzRjErDNKcj9c/CpPzbCeLUA3s9wxlVH51bJAxuj+w06TPxUNho
         hIvsGKY+rckCgFtU7P8x/h2TliqmKdEuuVztN9USJesoQ01R5tMxKWY2ufy1ve0XyJSn
         foxTtHoSAK4iDrbHJHDhQHg3/EkDawfmBi6iX9ITDoFBhd7IeDb6Wi2zqgw907B1ccXw
         YcLMRepmBIAyNbGCTacgngwodvgYVupMapZ1dNZEfUsRm3Lm5wNI606gUC7VcgH1XrPn
         LwWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uwrkRWpWhPgQ2rjDl7v1ppy090ZCsQxxY2hnoFQafZs=;
        fh=qgjKEikBQBp+roNpfzWAyktJ/qJKxw17z9Qxj1CpLOM=;
        b=RFI6wqdDQQ54pFHMJPczNepoRUkeuqr8lxr75faZFQX/FR1Ebk75u8i1CWGIanS7k2
         yjkpmcFoPRBR4sS3a7fuL/J2vP8zdQNEbXQCHDvvwTYFeqeBChmzaiFNNR4iO2b+tgSO
         h0YQX24YPtvNdw4alIlluWK+wjRfkR9/xfumGtXsFkdlHTaUpr3QwQrmzg7VcEJs7+a9
         6KoM5aGsxqGGO8Gd0QpJd0vOC+PKmJeLKWtCUlcZYYKJSY/a4tV0ZKzXRT+ZG4IqfSSp
         3KYHRsGjAW+nLOm6VhCsRYaimRyW+Jslx5/RJmr4JzFqBOTwqTha3rzYJTaPZo/jj1tq
         tUAQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774513441; x=1775118241; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uwrkRWpWhPgQ2rjDl7v1ppy090ZCsQxxY2hnoFQafZs=;
        b=hWZQpWKH+OdfbUOilji+7+Gaz7wz9cfCho/7Xy1ZYLQR+/hdeuBYfKF2wLv1ZM/Z6r
         f6G2aZuNJKR3+J7XV9XSQGv24sI8FfuDX3zWQuPuIgwB9s0v6+LNGz7krh+/de/Z7jAX
         mgGyoTNpRmLMnQoZALgOqbn5rt4xHBKat8b9hUl6jv9v4jSQe15xqWmWUnTPcvqVb5Ju
         UtMXBwD5XS1JFOJS/IMcyIUhk4yWcnlCgxqTAqcpA1aA64E3sbVSKIx3MGFn/Mkzz9qu
         s1OA95EnZcq4ssRr6t/CaT4s8GisLlLgrFGKdfLYpK4CAp84I4JaRKo1JaATuQZ1NcaV
         qOeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774513441; x=1775118241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=uwrkRWpWhPgQ2rjDl7v1ppy090ZCsQxxY2hnoFQafZs=;
        b=McktgK23ySE/Th5EQ3nvK+SaQ3ow4Niknw3XDq5qKv82WV6D/uP0Suz58S0gOCaOTw
         gMMxp18sTSb0queYTIHKtqm/e+jNqQmVJn8DiQJcNVAfuNhQ0b81fbAPB1sK73YrXPkA
         o0nm1k1G7tYK/ArLjirjUzzwrDBsR+rl9a+brjtR9YDuzrBwbGzBvB15yvZwVZqtuiqJ
         8+yetcUJHZF/0IxoB3TqBEwuiUTrk+gFjKACofMh0Gk+FI5UTyjmwYkq3qPbF6rfp0L+
         GRWB6YT2FNxzHoosPJ+RIz3g8fXHwbAy1ovPfIpgBOX3NwDb8OMe/hJ9qdPA8wGF40+y
         CyrA==
X-Forwarded-Encrypted: i=1; AJvYcCXTLUn75445AnhpFPaBkhRPbYjTRPkIhBvFBfWBPNn+43endMdPTMlMTnqzHQVIuX8ZCF6qPQCyLg==@kvack.org
X-Gm-Message-State: AOJu0YzC/YH8Zs9izCFv6vZ/Llje8UQLbnCT4xT84A7riAMf+tRxXhoS
	Vo3navtsxOZzdKWLr1VSL4VMcguD6As9RYqGXUIe4SmMgOP6zKY1OfyJj4VYmDOw+QV/XES5fqd
	VOF5z47xiPKvGDyeh3LPob+n6PeKI2vAubIdufCRB
X-Gm-Gg: ATEYQzzii49f3hxOrq9k3cT0n5pz4LHpQymoKHERnmhDCVgehpDlBV2Mkq/uPe+fd4n
	SltcpauT/TK5cj7WygX4HbS1Mh9MEBXhcvRaSWJVw7k13z+zpgiYzbgYyGX+Q0xTJjuRN9CpnSx
	PRF9C3i9AINc8yVhMQzEObPpD9FMiIM+r3xpfDYmDsPIpN0ojPaILTHlF77NM/7O775Y6yqmj0v
	ZqwQ2tGGRvDt3KiT9qSyE0GB/DjPsLty56koF5dpsaHYr5S5LG4C5tSJb2g1Vc5g6sHtwcSVc86
	Q8t85w==
X-Received: by 2002:a05:622a:a950:b0:509:21ff:cd49 with SMTP id
 d75a77b69052e-50b93a03cb1mr904991cf.4.1774513440208; Thu, 26 Mar 2026
 01:24:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260319083153.2488005-1-hao.ge@linux.dev> <CAJuCfpG5OG66mgfn3ez5ZXTjj7VC8yuK3L2u83uOZhyBbRH2Lw@mail.gmail.com>
 <CAJuCfpHD4SB30oP7Bdm=ey+2W7CAsFPruedEbqgR5OumrQErxQ@mail.gmail.com>
 <9ef1c798-a30f-4458-9684-900136ae8b7d@linux.dev> <CAJuCfpEt1EwS4_kiTbger7sBGFKKhi+6PBjrYrTK1HEJzxOTGg@mail.gmail.com>
 <575e727e-cd47-41df-966a-142425aa8a8b@linux.dev> <CAJuCfpH4Wpv+jFOm2Xc3UOpn-vcEsJj6W0JJC=SJ2nkA=gEOWg@mail.gmail.com>
 <35d274d9-ed52-4325-80fb-c374e8af3169@linux.dev> <CAJuCfpF7BuTQgypAsaaccNnk+6Eyo5pumh1nMhFMQeff9CxkgQ@mail.gmail.com>
 <88c6ac9d-d966-4c25-b16d-6808f9e8c43a@linux.dev> <CAJuCfpF_hvo+gt=YugtBRh8uniaP=Pw3vCu1SCRPRk4FdYdVhg@mail.gmail.com>
 <CAJuCfpGVZVtV5SO=6+TU1Q-id5GXo4cyFmsDgmj=10NXQ17bcw@mail.gmail.com>
 <efa491a3-eba7-4661-81af-1737b707ee1d@linux.dev> <CAJuCfpFGrC3-toPWL4aycBH4Mp3UoOYu9oSxRdnz+LZrO_Npeg@mail.gmail.com>
 <098f53cc-97b5-4647-89dd-0e5820b1e9a0@linux.dev> <CAJuCfpHGmgZX_F7Kae2pZqvLRS4pR9Y3+CRMVZWOxb0XpO9EnQ@mail.gmail.com>
 <ac271897-8145-4ea8-ad7b-bc7ba4b76c67@linux.dev>
In-Reply-To: <ac271897-8145-4ea8-ad7b-bc7ba4b76c67@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Mar 2026 01:23:49 -0700
X-Gm-Features: AQROBzCybaIYeujta-eRq3RoVe13du84cm179sTroW5W6JW-We3pM80yJ6cgp1A
Message-ID: <CAJuCfpGpu27LHnjpO=tj7uTcKRVWLmCqT4AKUS3Xtmhr-CFTmQ@mail.gmail.com>
Subject: Re: [PATCH] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Hao Ge <hao.ge@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kent Overstreet <kent.overstreet@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 1E771C0008
X-Stat-Signature: y48fxgu6d973b9gpjfsqdeqrdutz9jms
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774513441-602399
X-HE-Meta: U2FsdGVkX1/vOND5NFT4we+YMvrevgV74C6o50JeKEAJ+oYSeX8Sy4dRLh0aEg6LKlFGpBrxrM7r85HIpFZpjMSZALQ/0ULFEJsCVCO+N31gJHwFNlxFFnn9Mlw3N7N1JVhq1ur37BABGTc+b0toS4gttZ+UTwFiyfAetL3Cl0hlZlpIvriBOIzbw5YydMrXPyjwgEqL5NXDtqvzJ2eyyOHFNgKc3HCvU4DAS3Pr/SsZDeVos+EXGr5gSRES7UNkns4QQVoEKYJytoZ1XmbWua88CR62wdsNpaQ4dcrzVC9UqIJEQyX8981XHazRvEaR3LvWElxzw+uxIn5yCILgZg4jScsVN/Orbw6HhzC/6xtEeFABGVeUvDY62IRHHuUEZKcvm3r4bXNjqzt23rgG/UsFOa7EzVbfZNHw2+/HcaT6V/yS0ba3z7kqL6glxjdRzlLn5CzuS3qN+XsMLI9H7jYH86bzcCLI1/D7B+fXAMg0nIh2Ubh6JQinqsenvn4riQyfZdWKbc+Yk0rolpWHncKX/Twzxk8Nrt8UulnUEU4Rdfv+gqWAjMYfaSNoaRaSj4SHewbSPByWHbNa9oBWRAftQzG+I4QSJ0yytYHime/F0E59ZWDOosM2pQgUN6/9R35BFiAFTSS4e6y6K8ggMJteTJb1K53d5NLWAjWrGdJjOBu8L92TqRfScL1hkgdVZMLo+pMl5sIxH/dsrCyBjKKmMyUyxw/MTS4inYPk4ZnqeNBLiJ6yWidCLgIqs19zo2jXcAy3f826VO2op9o0jtPA6M132qdv4Iso2nRJw4+qns4lq0Yc29hXnrbx1XM9wJdZDEvg3Hp0Y8N5C87t9ip5khaOwOjwKEfky96iqGchiv/G2S5gOyIHmq2qhXfHwrXZajOwTFEY1GUbh6jnNtC1s28u2EEIjRboGLaXxlV8jtGPXpg626ecSzBB4T1MOd6NhW2kPud4F/+r6Ub
 Me1G5ssL
 G7GfLhknbkQxDOa162IBRfcECt26ilFQ68hOKqtdlghQN/v8Ng8/qJOtGsvTvaI6Gegs6f4ODeBcrsFlumP0ySAstsHNXj0jTYEq4MB4vlIdvEGC+RA7Uck3E8WWahgbrVv1KGk7bXLqsNDIrp7j56aNrLY0xzatxXRxMGbiOGj7EFhsGyb82q1VRigh3ds2JyWJ4WTpfyG4CspxZhZ4dQoDABtWiAfYMq/eiUiN2xBy46MPA892wODebGrF2rwYwE0rc+llz6im1oAcOfv00USFY39lyvMBgAqqniVaGnygtpSJoDL/qUYdIf/fLk0PaAFGpOYyOBAkczf8WwvJ/g/IIpNGnVtPx5EI+AhcPMGWS1l7U4SbbcxxDc+pDrX7Zs/hWsXg/XSScbi7izlx9lbdgErNTcDcmWFekcEgaclwzu2QLjZCrcTu7mI9nejWItRcXR/CNJbKXqroHCBh6pCln0hhFQLzYgzQJ8jsvl09LKVk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 10:34=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote:
>
>
> On 2026/3/26 13:04, Suren Baghdasaryan wrote:
> > On Wed, Mar 25, 2026 at 6:45=E2=80=AFPM Hao Ge <hao.ge@linux.dev> wrote=
:
> >>
> >> On 2026/3/25 23:17, Suren Baghdasaryan wrote:
> >>> On Wed, Mar 25, 2026 at 4:21=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wro=
te:
> >>>> On 2026/3/25 15:35, Suren Baghdasaryan wrote:
> >>>>> On Tue, Mar 24, 2026 at 11:25=E2=80=AFPM Suren Baghdasaryan <surenb=
@google.com> wrote:
> >>>>>> On Tue, Mar 24, 2026 at 7:08=E2=80=AFPM Hao Ge <hao.ge@linux.dev> =
wrote:
> >>>>>>> On 2026/3/25 08:21, Suren Baghdasaryan wrote:
> >>>>>>>> On Tue, Mar 24, 2026 at 2:43=E2=80=AFAM Hao Ge <hao.ge@linux.dev=
> wrote:
> >>>>>>>>> On 2026/3/24 06:47, Suren Baghdasaryan wrote:
> >>>>>>>>>> On Mon, Mar 23, 2026 at 2:16=E2=80=AFAM Hao Ge <hao.ge@linux.d=
ev> wrote:
> >>>>>>>>>>> On 2026/3/20 10:14, Suren Baghdasaryan wrote:
> >>>>>>>>>>>> On Thu, Mar 19, 2026 at 6:58=E2=80=AFPM Hao Ge <hao.ge@linux=
.dev> wrote:
> >>>>>>>>>>>>> On 2026/3/20 07:48, Suren Baghdasaryan wrote:
> >>>>>>>>>>>>>> On Thu, Mar 19, 2026 at 4:44=E2=80=AFPM Suren Baghdasaryan=
 <surenb@google.com> wrote:
> >>>>>>>>>>>>>>> On Thu, Mar 19, 2026 at 3:28=E2=80=AFPM Andrew Morton <ak=
pm@linux-foundation.org> wrote:
> >>>>>>>>>>>>>>>> On Thu, 19 Mar 2026 16:31:53 +0800 Hao Ge <hao.ge@linux.=
dev> wrote:
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> Due to initialization ordering, page_ext is allocated a=
nd initialized
> >>>>>>>>>>>>>>>>> relatively late during boot. Some pages have already be=
en allocated
> >>>>>>>>>>>>>>>>> and freed before page_ext becomes available, leaving th=
eir codetag
> >>>>>>>>>>>>>>>>> uninitialized.
> >>>>>>>>>>>>>>> Hi Hao,
> >>>>>>>>>>>>>>> Thanks for the report.
> >>>>>>>>>>>>>>> Hmm. So, we are allocating pages before page_ext is initi=
alized...
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> A clear example is in init_section_page_ext(): alloc_pa=
ge_ext() calls
> >>>>>>>>>>>>>>>>> kmemleak_alloc().
> >>>>>>>>>>>>>> Forgot to ask. The example you are using here is for page_=
ext
> >>>>>>>>>>>>>> allocation itself. Do you have any other examples where pa=
ge
> >>>>>>>>>>>>>> allocation happens before page_ext initialization? If that=
's the only
> >>>>>>>>>>>>>> place, then we might be able to fix this in a simpler way =
by doing
> >>>>>>>>>>>>>> something special for alloc_page_ext().
> >>>>>>>>>>>>> Hi Suren
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> To help illustrate the point, here's the debug log I added:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>>>>>>>>>>> index 2d4b6f1a554e..ebfe636f5b07 100644
> >>>>>>>>>>>>> --- a/mm/page_alloc.c
> >>>>>>>>>>>>> +++ b/mm/page_alloc.c
> >>>>>>>>>>>>> @@ -1293,6 +1293,9 @@ void __pgalloc_tag_add(struct page *p=
age, struct
> >>>>>>>>>>>>> task_struct *task,
> >>>>>>>>>>>>>                        alloc_tag_add(&ref, task->alloc_tag,=
 PAGE_SIZE * nr);
> >>>>>>>>>>>>>                        update_page_tag_ref(handle, &ref);
> >>>>>>>>>>>>>                        put_page_tag_ref(handle);
> >>>>>>>>>>>>> +       } else {
> >>>>>>>>>>>>> +               pr_warn("__pgalloc_tag_add: get_page_tag_re=
f failed!
> >>>>>>>>>>>>> page=3D%p pfn=3D%lu nr=3D%u\n", page, page_to_pfn(page), nr=
);
> >>>>>>>>>>>>> +               dump_stack();
> >>>>>>>>>>>>>                }
> >>>>>>>>>>>>>         }
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> And I caught the following logs:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> [    0.296399] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>>>>>> page=3Dffffea000400c700 pfn=3D1049372 nr=3D1
> >>>>>>>>>>>>> [    0.296400] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tai=
nted
> >>>>>>>>>>>>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >>>>>>>>>>>>> [    0.296402] Hardware name: Red Hat KVM, BIOS
> >>>>>>>>>>>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>>>>>>>>>>> [    0.296402] Call Trace:
> >>>>>>>>>>>>> [    0.296403]  <TASK>
> >>>>>>>>>>>>> [    0.296403]  dump_stack_lvl+0x53/0x70
> >>>>>>>>>>>>> [    0.296405]  __pgalloc_tag_add+0x3a3/0x6e0
> >>>>>>>>>>>>> [    0.296406]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >>>>>>>>>>>>> [    0.296407]  ? kasan_unpoison+0x27/0x60
> >>>>>>>>>>>>> [    0.296409]  ? __kasan_unpoison_pages+0x2c/0x40
> >>>>>>>>>>>>> [    0.296411]  get_page_from_freelist+0xa54/0x1310
> >>>>>>>>>>>>> [    0.296413]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>>>>>>>>>>> [    0.296415]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x=
10
> >>>>>>>>>>>>> [    0.296417]  ? stack_depot_save_flags+0x3f/0x680
> >>>>>>>>>>>>> [    0.296418]  ? ___slab_alloc+0x518/0x530
> >>>>>>>>>>>>> [    0.296420]  alloc_pages_mpol+0x13a/0x3f0
> >>>>>>>>>>>>> [    0.296421]  ? __pfx_alloc_pages_mpol+0x10/0x10
> >>>>>>>>>>>>> [    0.296423]  ? _raw_spin_lock_irqsave+0x8a/0xf0
> >>>>>>>>>>>>> [    0.296424]  ? __pfx__raw_spin_lock_irqsave+0x10/0x10
> >>>>>>>>>>>>> [    0.296426]  alloc_slab_page+0xc2/0x130
> >>>>>>>>>>>>> [    0.296427]  allocate_slab+0x77/0x2c0
> >>>>>>>>>>>>> [    0.296429]  ? syscall_enter_define_fields+0x3bb/0x5f0
> >>>>>>>>>>>>> [    0.296430]  ___slab_alloc+0x125/0x530
> >>>>>>>>>>>>> [    0.296432]  ? __trace_define_field+0x252/0x3d0
> >>>>>>>>>>>>> [    0.296433]  __kmalloc_noprof+0x329/0x630
> >>>>>>>>>>>>> [    0.296435]  ? syscall_enter_define_fields+0x3bb/0x5f0
> >>>>>>>>>>>>> [    0.296436]  syscall_enter_define_fields+0x3bb/0x5f0
> >>>>>>>>>>>>> [    0.296438]  ? __pfx_syscall_enter_define_fields+0x10/0x=
10
> >>>>>>>>>>>>> [    0.296440]  event_define_fields+0x326/0x540
> >>>>>>>>>>>>> [    0.296441]  __trace_early_add_events+0xac/0x3c0
> >>>>>>>>>>>>> [    0.296443]  trace_event_init+0x24c/0x460
> >>>>>>>>>>>>> [    0.296445]  trace_init+0x9/0x20
> >>>>>>>>>>>>> [    0.296446]  start_kernel+0x199/0x3c0
> >>>>>>>>>>>>> [    0.296448]  x86_64_start_reservations+0x18/0x30
> >>>>>>>>>>>>> [    0.296449]  x86_64_start_kernel+0xe2/0xf0
> >>>>>>>>>>>>> [    0.296451]  common_startup_64+0x13e/0x141
> >>>>>>>>>>>>> [    0.296453]  </TASK>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> [    0.312234] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>>>>>> page=3Dffffea000400f900 pfn=3D1049572 nr=3D1
> >>>>>>>>>>>>> [    0.312234] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tai=
nted
> >>>>>>>>>>>>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >>>>>>>>>>>>> [    0.312236] Hardware name: Red Hat KVM, BIOS
> >>>>>>>>>>>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>>>>>>>>>>> [    0.312236] Call Trace:
> >>>>>>>>>>>>> [    0.312237]  <TASK>
> >>>>>>>>>>>>> [    0.312237]  dump_stack_lvl+0x53/0x70
> >>>>>>>>>>>>> [    0.312239]  __pgalloc_tag_add+0x3a3/0x6e0
> >>>>>>>>>>>>> [    0.312240]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >>>>>>>>>>>>> [    0.312241]  ? rmqueue.constprop.0+0x4fc/0x1ce0
> >>>>>>>>>>>>> [    0.312243]  ? kasan_unpoison+0x27/0x60
> >>>>>>>>>>>>> [    0.312244]  ? __kasan_unpoison_pages+0x2c/0x40
> >>>>>>>>>>>>> [    0.312246]  get_page_from_freelist+0xa54/0x1310
> >>>>>>>>>>>>> [    0.312248]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>>>>>>>>>>> [    0.312250]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x=
10
> >>>>>>>>>>>>> [    0.312253]  alloc_slab_page+0x39/0x130
> >>>>>>>>>>>>> [    0.312254]  allocate_slab+0x77/0x2c0
> >>>>>>>>>>>>> [    0.312255]  ? alloc_cpumask_var_node+0xc7/0x230
> >>>>>>>>>>>>> [    0.312257]  ___slab_alloc+0x46d/0x530
> >>>>>>>>>>>>> [    0.312259]  __kmalloc_node_noprof+0x2fa/0x680
> >>>>>>>>>>>>> [    0.312261]  ? alloc_cpumask_var_node+0xc7/0x230
> >>>>>>>>>>>>> [    0.312263]  alloc_cpumask_var_node+0xc7/0x230
> >>>>>>>>>>>>> [    0.312264]  init_desc+0x141/0x6b0
> >>>>>>>>>>>>> [    0.312266]  alloc_desc+0x108/0x1b0
> >>>>>>>>>>>>> [    0.312267]  early_irq_init+0xee/0x1c0
> >>>>>>>>>>>>> [    0.312268]  ? __pfx_early_irq_init+0x10/0x10
> >>>>>>>>>>>>> [    0.312271]  start_kernel+0x1ab/0x3c0
> >>>>>>>>>>>>> [    0.312272]  x86_64_start_reservations+0x18/0x30
> >>>>>>>>>>>>> [    0.312274]  x86_64_start_kernel+0xe2/0xf0
> >>>>>>>>>>>>> [    0.312275]  common_startup_64+0x13e/0x141
> >>>>>>>>>>>>> [    0.312277]  </TASK>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> [    0.312834] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>>>>>> page=3Dffffea000400fc00 pfn=3D1049584 nr=3D1
> >>>>>>>>>>>>> [    0.312835] CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tai=
nted
> >>>>>>>>>>>>> 7.0.0-rc4-dirty #12 PREEMPT(lazy)
> >>>>>>>>>>>>> [    0.312836] Hardware name: Red Hat KVM, BIOS
> >>>>>>>>>>>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>>>>>>>>>>> [    0.312837] Call Trace:
> >>>>>>>>>>>>> [    0.312837]  <TASK>
> >>>>>>>>>>>>> [    0.312838]  dump_stack_lvl+0x53/0x70
> >>>>>>>>>>>>> [    0.312840]  __pgalloc_tag_add+0x3a3/0x6e0
> >>>>>>>>>>>>> [    0.312841]  ? __pfx___pgalloc_tag_add+0x10/0x10
> >>>>>>>>>>>>> [    0.312842]  ? rmqueue.constprop.0+0x4fc/0x1ce0
> >>>>>>>>>>>>> [    0.312844]  ? kasan_unpoison+0x27/0x60
> >>>>>>>>>>>>> [    0.312845]  ? __kasan_unpoison_pages+0x2c/0x40
> >>>>>>>>>>>>> [    0.312847]  get_page_from_freelist+0xa54/0x1310
> >>>>>>>>>>>>> [    0.312849]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>>>>>>>>>>> [    0.312851]  ? __pfx___alloc_frozen_pages_noprof+0x10/0x=
10
> >>>>>>>>>>>>> [    0.312853]  alloc_pages_mpol+0x13a/0x3f0
> >>>>>>>>>>>>> [    0.312855]  ? __pfx_alloc_pages_mpol+0x10/0x10
> >>>>>>>>>>>>> [    0.312856]  ? xas_find+0x2d8/0x450
> >>>>>>>>>>>>> [    0.312858]  ? _raw_spin_lock+0x84/0xe0
> >>>>>>>>>>>>> [    0.312859]  ? __pfx__raw_spin_lock+0x10/0x10
> >>>>>>>>>>>>> [    0.312861]  alloc_pages_noprof+0xf6/0x2b0
> >>>>>>>>>>>>> [    0.312862]  __change_page_attr+0x293/0x850
> >>>>>>>>>>>>> [    0.312864]  ? __pfx___change_page_attr+0x10/0x10
> >>>>>>>>>>>>> [    0.312865]  ? _vm_unmap_aliases+0x2d0/0x650
> >>>>>>>>>>>>> [    0.312868]  ? __pfx__vm_unmap_aliases+0x10/0x10
> >>>>>>>>>>>>> [    0.312869]  __change_page_attr_set_clr+0x16c/0x360
> >>>>>>>>>>>>> [    0.312871]  ? spp_getpage+0xbb/0x1e0
> >>>>>>>>>>>>> [    0.312872]  change_page_attr_set_clr+0x220/0x3c0
> >>>>>>>>>>>>> [    0.312873]  ? flush_tlb_one_kernel+0xf/0x30
> >>>>>>>>>>>>> [    0.312875]  ? set_pte_vaddr_p4d+0x110/0x180
> >>>>>>>>>>>>> [    0.312877]  ? __pfx_change_page_attr_set_clr+0x10/0x10
> >>>>>>>>>>>>> [    0.312878]  ? __pfx_set_pte_vaddr_p4d+0x10/0x10
> >>>>>>>>>>>>> [    0.312881]  ? __pfx_mtree_load+0x10/0x10
> >>>>>>>>>>>>> [    0.312883]  ? __pfx_mtree_load+0x10/0x10
> >>>>>>>>>>>>> [    0.312884]  ? __asan_memcpy+0x3c/0x60
> >>>>>>>>>>>>> [    0.312886]  ? set_intr_gate+0x10c/0x150
> >>>>>>>>>>>>> [    0.312888]  set_memory_ro+0x76/0xa0
> >>>>>>>>>>>>> [    0.312889]  ? __pfx_set_memory_ro+0x10/0x10
> >>>>>>>>>>>>> [    0.312891]  idt_setup_apic_and_irq_gates+0x2c1/0x390
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> and more.
> >>>>>>>>>>>> Ok, it's not the only place. Got your point.
> >>>>>>>>>>>>
> >>>>>>>>>>>>> off topic -  if we were to handle only alloc_page_ext() spe=
cifically,
> >>>>>>>>>>>>> what would be the most straightforward
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> solution in your mind? I'd really appreciate your insight.
> >>>>>>>>>>>> I was thinking if it's the only special case maybe we can ha=
ndle it
> >>>>>>>>>>>> somehow differently, like we do when we allocate obj_ext vec=
tors for
> >>>>>>>>>>>> slabs using __GFP_NO_OBJ_EXT. I haven't found a good solutio=
n yet but
> >>>>>>>>>>>> since it's not a special case we would not be able to use it=
 even if I
> >>>>>>>>>>>> came up with something...
> >>>>>>>>>>>> I think your way is the most straight-forward but please try=
 my
> >>>>>>>>>>>> suggestion to see if we can avoid extra overhead.
> >>>>>>>>>>>> Thanks,
> >>>>>>>>>>>> Suren.
> >>>>>>> Hi Suren
> >>>>>>>>> Hi Suren
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>>> Hi Hao,
> >>>>>>>>>>
> >>>>>>>>>>> Hi Suren
> >>>>>>>>>>>
> >>>>>>>>>>> Thank you for your feedback. After re-examining this issue,
> >>>>>>>>>>>
> >>>>>>>>>>> I realize my previous focus was misplaced.
> >>>>>>>>>>>
> >>>>>>>>>>> Upon deeper consideration, I understand that this is not mere=
ly a bug,
> >>>>>>>>>>>
> >>>>>>>>>>> but rather a warning that indicates a gap in our memory profi=
ling mechanism.
> >>>>>>>>>>>
> >>>>>>>>>>> Specifically, the current implementation appears to be missin=
g memory
> >>>>>>>>>>> allocation
> >>>>>>>>>>>
> >>>>>>>>>>> tracking during the period between the buddy system allocatio=
n and page_ext
> >>>>>>>>>>>
> >>>>>>>>>>> initialization.
> >>>>>>>>>>>
> >>>>>>>>>>> This profiling gap means we may not be capturing all relevant=
 memory
> >>>>>>>>>>> allocation
> >>>>>>>>>>>
> >>>>>>>>>>> events during this critical transition phase.
> >>>>>>>>>> Correct, this limitation exists because memory profiling relie=
s on
> >>>>>>>>>> some kernel facilities (page_ext, objj_ext) which might not be
> >>>>>>>>>> initialized yet at the time of allocation.
> >>>>>>>>>>
> >>>>>>>>>>> My approach is to dynamically allocate codetag_ref when get_p=
age_tag_ref
> >>>>>>>>>>> fails,
> >>>>>>>>>>>
> >>>>>>>>>>> and maintain a linked list to track all buddy system allocati=
ons that
> >>>>>>>>>>> occur prior to page_ext initialization.
> >>>>>>>>>>>
> >>>>>>>>>>>        However, this introduces performance concerns:
> >>>>>>>>>>>
> >>>>>>>>>>> 1. Free Path Overhead: When freeing these pages, we would nee=
d to
> >>>>>>>>>>> traverse the entire linked list to locate
> >>>>>>>>>>>
> >>>>>>>>>>>            the corresponding codetag_ref, resulting in O(n) l=
ookup complexity
> >>>>>>>>>>> per free operation.
> >>>>>>>>>>>
> >>>>>>>>>>> 2. Initialization Overhead: During init_page_alloc_tagging, i=
terating
> >>>>>>>>>>> through the linked list to assign codetag_ref to
> >>>>>>>>>>>
> >>>>>>>>>>>            page_ext would introduce additional traversal cost=
.
> >>>>>>>>>>>
> >>>>>>>>>>> If the number of pages is substantial, this could incur signi=
ficant
> >>>>>>>>>>> overhead. What are your thoughts on this? I look forward to y=
our
> >>>>>>>>>>> suggestions.
> >>>>>>>>>> My thinking is that these early allocations comprise a small p=
ortion
> >>>>>>>>>> of overall memory consumed by the system. So, instead of tryin=
g to
> >>>>>>>>>> record and handle them in some alternative way, we just accept=
 that
> >>>>>>>>>> some counters might not be exactly accurate and ignore those e=
arly
> >>>>>>>>>> allocations. See how the early slab allocations are marked wit=
h the
> >>>>>>>>>> CODETAG_FLAG_INACCURATE flag and later reported as inaccurate.=
 I think
> >>>>>>>>>> that's an acceptable alternative to introducing extra complexi=
ty and
> >>>>>>>>>> performance overhead. IOW, the benefits of accounting for thes=
e early
> >>>>>>>>>> allocations are low compared to the effort required to account=
 for
> >>>>>>>>>> them. Unless you found a simple and performant way to do that.=
..
> >>>>>>>>> I have been exploring possible solutions to this issue over the=
 past few
> >>>>>>>>> days,
> >>>>>>>>>
> >>>>>>>>> but so far I have not come up with a good approach.
> >>>>>>>>>
> >>>>>>>>> I have counted the number of memory allocations that occur earl=
ier than the
> >>>>>>>>>
> >>>>>>>>> allocation and initialization of our page_ext, and found that t=
here are
> >>>>>>>>> actually
> >>>>>>>>>
> >>>>>>>>> quite a lot of them.
> >>>>>>>> Interesting... I wonder it's because deferred_struct_pages defer=
s
> >>>>>>>> page_ext initialization. Can you check if setting early_page_ext
> >>>>>>>> reduces or eliminates these allocations before page_ext init cas=
es?
> >>>>>>> Yes, you are correct. In my 8-core 16GB virtual machine, I used a=
 global
> >>>>>>> counter
> >>>>>>>
> >>>>>>> to record these allocations. With early_page_ext enabled, there w=
ere 130
> >>>>>>> allocations
> >>>>>>>
> >>>>>>> before page_ext initialization. Without early_page_ext, there wer=
e 802
> >>>>>>> allocations
> >>>>>>>
> >>>>>>> before page_ext initialization.
> >>>>>>>
> >>>>>>>
> >>>>>>>>> Similarly, I have made the following changes and collected the
> >>>>>>>>> corresponding logs.
> >>>>>>>>>
> >>>>>>>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>>>>>>> index 2d4b6f1a554e..6db65b3d52d3 100644
> >>>>>>>>> --- a/mm/page_alloc.c
> >>>>>>>>> +++ b/mm/page_alloc.c
> >>>>>>>>> @@ -1293,6 +1293,8 @@ void __pgalloc_tag_add(struct page *page,=
 struct
> >>>>>>>>> task_struct *task,
> >>>>>>>>>                      alloc_tag_add(&ref, task->alloc_tag, PAGE_=
SIZE * nr);
> >>>>>>>>>                      update_page_tag_ref(handle, &ref);
> >>>>>>>>>                      put_page_tag_ref(handle);
> >>>>>>>>> +       } else{
> >>>>>>>>> +               pr_warn("__pgalloc_tag_add: get_page_tag_ref fa=
iled!
> >>>>>>>>> page=3D%p pfn=3D%lu nr=3D%u\n", page, page_to_pfn(page), nr);
> >>>>>>>>>              }
> >>>>>>>>>       }
> >>>>>>>>>
> >>>>>>>>> @@ -1314,6 +1316,8 @@ void __pgalloc_tag_sub(struct page *page,=
 unsigned
> >>>>>>>>> int nr)
> >>>>>>>>>                      alloc_tag_sub(&ref, PAGE_SIZE * nr);
> >>>>>>>>>                      update_page_tag_ref(handle, &ref);
> >>>>>>>>>                      put_page_tag_ref(handle);
> >>>>>>>>> +       } else{
> >>>>>>>>> +                pr_warn("__pgalloc_tag_sub: get_page_tag_ref f=
ailed!
> >>>>>>>>> page=3D%p pfn=3D%lu nr=3D%u\n", page, page_to_pfn(page), nr);
> >>>>>>>>>              }
> >>>>>>>>>       }
> >>>>>>>>>
> >>>>>>>>> [    0.261699] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001000 pfn=3D1048640 nr=3D2
> >>>>>>>>> [    0.261711] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001100 pfn=3D1048644 nr=3D4
> >>>>>>>>> [    0.261717] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001200 pfn=3D1048648 nr=3D4
> >>>>>>>>> [    0.261721] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001300 pfn=3D1048652 nr=3D4
> >>>>>>>>> [    0.261893] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001080 pfn=3D1048642 nr=3D2
> >>>>>>>>> [    0.261917] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001400 pfn=3D1048656 nr=3D4
> >>>>>>>>> [    0.262018] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001500 pfn=3D1048660 nr=3D2
> >>>>>>>>> [    0.262024] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001600 pfn=3D1048664 nr=3D8
> >>>>>>>>> [    0.262040] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001580 pfn=3D1048662 nr=3D1
> >>>>>>>>> [    0.262048] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040015c0 pfn=3D1048663 nr=3D1
> >>>>>>>>> [    0.262056] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001800 pfn=3D1048672 nr=3D2
> >>>>>>>>> [    0.262064] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001880 pfn=3D1048674 nr=3D2
> >>>>>>>>> [    0.262078] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001900 pfn=3D1048676 nr=3D2
> >>>>>>>>> [    0.262196] SLUB: HWalign=3D64, Order=3D0-3, MinObjects=3D0,=
 CPUs=3D8, Nodes=3D1
> >>>>>>>>> [    0.262213] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001980 pfn=3D1048678 nr=3D2
> >>>>>>>>> [    0.262220] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001a00 pfn=3D1048680 nr=3D4
> >>>>>>>>> [    0.262246] ODEBUG: selftest passed
> >>>>>>>>> [    0.262268] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001b00 pfn=3D1048684 nr=3D1
> >>>>>>>>> [    0.262318] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001b40 pfn=3D1048685 nr=3D1
> >>>>>>>>> [    0.262368] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001b80 pfn=3D1048686 nr=3D1
> >>>>>>>>> [    0.262418] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001bc0 pfn=3D1048687 nr=3D1
> >>>>>>>>> [    0.262469] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001c00 pfn=3D1048688 nr=3D1
> >>>>>>>>> [    0.262519] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001c40 pfn=3D1048689 nr=3D1
> >>>>>>>>> [    0.262569] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001c80 pfn=3D1048690 nr=3D1
> >>>>>>>>> [    0.262620] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001cc0 pfn=3D1048691 nr=3D1
> >>>>>>>>> [    0.262670] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001d00 pfn=3D1048692 nr=3D1
> >>>>>>>>> [    0.262721] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001d40 pfn=3D1048693 nr=3D1
> >>>>>>>>> [    0.262771] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001d80 pfn=3D1048694 nr=3D1
> >>>>>>>>> [    0.262821] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001dc0 pfn=3D1048695 nr=3D1
> >>>>>>>>> [    0.262871] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001e00 pfn=3D1048696 nr=3D1
> >>>>>>>>> [    0.262923] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001e40 pfn=3D1048697 nr=3D1
> >>>>>>>>> [    0.262974] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001e80 pfn=3D1048698 nr=3D1
> >>>>>>>>> [    0.263024] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001ec0 pfn=3D1048699 nr=3D1
> >>>>>>>>> [    0.263074] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001f00 pfn=3D1048700 nr=3D1
> >>>>>>>>> [    0.263124] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001f40 pfn=3D1048701 nr=3D1
> >>>>>>>>> [    0.263174] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001f80 pfn=3D1048702 nr=3D1
> >>>>>>>>> [    0.263224] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004001fc0 pfn=3D1048703 nr=3D1
> >>>>>>>>> [    0.263275] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002000 pfn=3D1048704 nr=3D1
> >>>>>>>>> [    0.263325] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002040 pfn=3D1048705 nr=3D1
> >>>>>>>>> [    0.263375] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002080 pfn=3D1048706 nr=3D1
> >>>>>>>>> [    0.263427] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002400 pfn=3D1048720 nr=3D16
> >>>>>>>>> [    0.263437] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040020c0 pfn=3D1048707 nr=3D1
> >>>>>>>>> [    0.263463] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002100 pfn=3D1048708 nr=3D1
> >>>>>>>>> [    0.263465] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002140 pfn=3D1048709 nr=3D1
> >>>>>>>>> [    0.263467] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002180 pfn=3D1048710 nr=3D1
> >>>>>>>>> [    0.263509] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002200 pfn=3D1048712 nr=3D4
> >>>>>>>>> [    0.263512] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002800 pfn=3D1048736 nr=3D8
> >>>>>>>>> [    0.263524] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040021c0 pfn=3D1048711 nr=3D1
> >>>>>>>>> [    0.263536] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002300 pfn=3D1048716 nr=3D1
> >>>>>>>>> [    0.263537] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002340 pfn=3D1048717 nr=3D1
> >>>>>>>>> [    0.263539] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002380 pfn=3D1048718 nr=3D1
> >>>>>>>>> [    0.263604] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004004000 pfn=3D1048832 nr=3D128
> >>>>>>>>> [    0.263638] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004003000 pfn=3D1048768 nr=3D64
> >>>>>>>>> [    0.263650] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002c00 pfn=3D1048752 nr=3D16
> >>>>>>>>> [    0.263655] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040023c0 pfn=3D1048719 nr=3D1
> >>>>>>>>> [    0.270582] __pgalloc_tag_sub: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040023c0 pfn=3D1048719 nr=3D1
> >>>>>>>>> [    0.270591] ftrace: allocating 52717 entries in 208 pages
> >>>>>>>>> [    0.270592] ftrace: allocated 208 pages with 3 groups
> >>>>>>>>> [    0.270620] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004002a00 pfn=3D1048744 nr=3D8
> >>>>>>>>> [    0.270636] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040023c0 pfn=3D1048719 nr=3D1
> >>>>>>>>> [    0.270643] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006000 pfn=3D1048960 nr=3D1
> >>>>>>>>> [    0.270649] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006040 pfn=3D1048961 nr=3D1
> >>>>>>>>> [    0.270658] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004007000 pfn=3D1049024 nr=3D64
> >>>>>>>>> [    0.270659] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006080 pfn=3D1048962 nr=3D2
> >>>>>>>>> [    0.270722] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006100 pfn=3D1048964 nr=3D1
> >>>>>>>>> [    0.270730] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006140 pfn=3D1048965 nr=3D1
> >>>>>>>>> [    0.270738] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006180 pfn=3D1048966 nr=3D1
> >>>>>>>>> [    0.270777] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040061c0 pfn=3D1048967 nr=3D1
> >>>>>>>>> [    0.270786] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006200 pfn=3D1048968 nr=3D1
> >>>>>>>>> [    0.270792] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006240 pfn=3D1048969 nr=3D1
> >>>>>>>>> [    0.270833] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006300 pfn=3D1048972 nr=3D4
> >>>>>>>>> [    0.270891] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006280 pfn=3D1048970 nr=3D1
> >>>>>>>>> [    0.270980] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040062c0 pfn=3D1048971 nr=3D1
> >>>>>>>>> [    0.271071] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006400 pfn=3D1048976 nr=3D1
> >>>>>>>>> [    0.271156] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006440 pfn=3D1048977 nr=3D1
> >>>>>>>>> [    0.271185] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006480 pfn=3D1048978 nr=3D2
> >>>>>>>>> [    0.271301] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006500 pfn=3D1048980 nr=3D1
> >>>>>>>>> [    0.271655] Dynamic Preempt: lazy
> >>>>>>>>> [    0.271662] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006580 pfn=3D1048982 nr=3D2
> >>>>>>>>> [    0.271752] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006600 pfn=3D1048984 nr=3D4
> >>>>>>>>> [    0.271762] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004010000 pfn=3D1049600 nr=3D4
> >>>>>>>>> [    0.271824] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006540 pfn=3D1048981 nr=3D1
> >>>>>>>>> [    0.271916] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006700 pfn=3D1048988 nr=3D2
> >>>>>>>>> [    0.271964] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006780 pfn=3D1048990 nr=3D1
> >>>>>>>>> [    0.272099] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea00040067c0 pfn=3D1048991 nr=3D1
> >>>>>>>>> [    0.272138] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006800 pfn=3D1048992 nr=3D2
> >>>>>>>>> [    0.272144] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006a00 pfn=3D1049000 nr=3D8
> >>>>>>>>> [    0.272249] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006c00 pfn=3D1049008 nr=3D8
> >>>>>>>>> [    0.272319] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006880 pfn=3D1048994 nr=3D2
> >>>>>>>>> [    0.272351] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006900 pfn=3D1048996 nr=3D4
> >>>>>>>>> [    0.272424] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004006e00 pfn=3D1049016 nr=3D8
> >>>>>>>>> [    0.272485] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008000 pfn=3D1049088 nr=3D8
> >>>>>>>>> [    0.272535] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008200 pfn=3D1049096 nr=3D2
> >>>>>>>>> [    0.272600] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008400 pfn=3D1049104 nr=3D8
> >>>>>>>>> [    0.272663] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008300 pfn=3D1049100 nr=3D4
> >>>>>>>>> [    0.272694] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008280 pfn=3D1049098 nr=3D2
> >>>>>>>>> [    0.272708] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008600 pfn=3D1049112 nr=3D8
> >>>>>>>>>
> >>>>>>>>> [    0.272924] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008880 pfn=3D1049122 nr=3D2
> >>>>>>>>> [    0.272934] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008900 pfn=3D1049124 nr=3D2
> >>>>>>>>> [    0.272952] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008c00 pfn=3D1049136 nr=3D4
> >>>>>>>>> [    0.273035] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008980 pfn=3D1049126 nr=3D2
> >>>>>>>>> [    0.273062] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008e00 pfn=3D1049144 nr=3D8
> >>>>>>>>> [    0.273674] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008d00 pfn=3D1049140 nr=3D1
> >>>>>>>>> [    0.273884] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008d80 pfn=3D1049142 nr=3D2
> >>>>>>>>> [    0.273943] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009000 pfn=3D1049152 nr=3D2
> >>>>>>>>> [    0.274379] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009080 pfn=3D1049154 nr=3D2
> >>>>>>>>> [    0.274575] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009200 pfn=3D1049160 nr=3D8
> >>>>>>>>> [    0.274617] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009100 pfn=3D1049156 nr=3D4
> >>>>>>>>> [    0.274794] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009400 pfn=3D1049168 nr=3D2
> >>>>>>>>> [    0.274840] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009480 pfn=3D1049170 nr=3D2
> >>>>>>>>> [    0.275057] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009500 pfn=3D1049172 nr=3D2
> >>>>>>>>> [    0.275092] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009580 pfn=3D1049174 nr=3D2
> >>>>>>>>> [    0.275134] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009600 pfn=3D1049176 nr=3D8
> >>>>>>>>> [    0.275211] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009800 pfn=3D1049184 nr=3D4
> >>>>>>>>> [    0.275510] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009900 pfn=3D1049188 nr=3D2
> >>>>>>>>> [    0.275548] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009980 pfn=3D1049190 nr=3D2
> >>>>>>>>> [    0.275976] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009a00 pfn=3D1049192 nr=3D8
> >>>>>>>>> [    0.275987] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009c00 pfn=3D1049200 nr=3D2
> >>>>>>>>> [    0.276139] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009c80 pfn=3D1049202 nr=3D2
> >>>>>>>>> [    0.276152] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004008d40 pfn=3D1049141 nr=3D1
> >>>>>>>>> [    0.276242] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009d00 pfn=3D1049204 nr=3D1
> >>>>>>>>> [    0.276358] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009d40 pfn=3D1049205 nr=3D1
> >>>>>>>>> [    0.276444] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009d80 pfn=3D1049206 nr=3D1
> >>>>>>>>> [    0.276526] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009dc0 pfn=3D1049207 nr=3D1
> >>>>>>>>> [    0.276615] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009e00 pfn=3D1049208 nr=3D1
> >>>>>>>>> [    0.276696] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009e40 pfn=3D1049209 nr=3D1
> >>>>>>>>> [    0.276792] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009e80 pfn=3D1049210 nr=3D1
> >>>>>>>>> [    0.276827] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009f00 pfn=3D1049212 nr=3D2
> >>>>>>>>> [    0.276891] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009ec0 pfn=3D1049211 nr=3D1
> >>>>>>>>> [    0.276999] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009f80 pfn=3D1049214 nr=3D1
> >>>>>>>>> [    0.277082] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea0004009fc0 pfn=3D1049215 nr=3D1
> >>>>>>>>> [    0.277172] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea000400a000 pfn=3D1049216 nr=3D1
> >>>>>>>>> [    0.277257] __pgalloc_tag_add: get_page_tag_ref failed!
> >>>>>>>>> page=3Dffffea000400a040 pfn=3D1049217 nr=3D1
> >>>>>>>>>
> >>>>>>>>> and so on.
> >>>>>>>>>
> >>>>>>>>>
> >>>>>>>>>> I think your earlier patch can effectively detect these early
> >>>>>>>>>> allocations and suppress the warnings. We should also mark the=
se
> >>>>>>>>>> allocations with CODETAG_FLAG_INACCURATE.
> >>>>>>>>> Thanks to an excellent AI review, I realized there are issues w=
ith
> >>>>>>>>>
> >>>>>>>>> my original patch. One problem is the 256-element array; anothe=
r
> >>>>>>>> Yes, if there are lots of such allocations, it's not appropriate=
.
> >>>>>>>>
> >>>>>>>>> is that it involves allocation and free operations =E2=80=94 me=
aning we need
> >>>>>>>>>
> >>>>>>>>> to record entries at __pgalloc_tag_add and remove them at __pga=
lloc_tag_sub,
> >>>>>>>>>
> >>>>>>>>> which introduces a noticeable overhead. I'm wondering if we can=
 instead
> >>>>>>>>> set a flag
> >>>>>>>>>
> >>>>>>>>> bit in page flags during the early boot stage, which I'll refer=
 to as
> >>>>>>>>> EARLY_ALLOC_FLAGS.
> >>>>>>>>>
> >>>>>>>>> Then, in __pgalloc_tag_sub, we first check for EARLY_ALLOC_FLAG=
S. If
> >>>>>>>>> set, we clear the
> >>>>>>>>>
> >>>>>>>>> flag and return immediately; otherwise, we perform the actual
> >>>>>>>>> subtraction of the tag count.
> >>>>>>>>>
> >>>>>>>>> This approach seems somewhat similar to the idea behind
> >>>>>>>>> mem_profiling_compressed.
> >>>>>>>> That seems doable but let's first check if we can make page_ext
> >>>>>>>> initialization happen before these allocations. That would be th=
e
> >>>>>>>> ideal path. If it's not possible then we can focus on alternativ=
es
> >>>>>>>> like the one you propose.
> >>>>>>> Yes, the ideal scenario would be to have page_ext initialization
> >>>>>>> complete before
> >>>>>>>
> >>>>>>> these allocations occur. I just did a code walkthrough and found =
that
> >>>>>>> this resembles
> >>>>>>>
> >>>>>>> the FLATMEM implementation approach - FLATMEM allocates page_ext =
before
> >>>>>>> the buddy
> >>>>>>>
> >>>>>>> system initialization, so it doesn't seem to encounter the issue =
we're
> >>>>>>> facing now.
> >>>>>>>
> >>>>>>> https://elixir.bootlin.com/linux/v7.0-rc5/source/mm/mm_init.c#L27=
07
> >>>>>> Yes, page_ext_init_flatmem() looks like an interesting option and =
it
> >>>>>> would not work with sparsemem. TBH I would prefer to find a simple
> >>>>>> solution that can identify early init allocations, mark them inacc=
uate
> >>>>>> and suppress the warning rather than introduce some complex mechan=
ism
> >>>>>> to account for them which would work only is some cases (flatmem).
> >>>>>> With your original approach I think the only real issue is the siz=
e of
> >>>>>> the array that might be too small. The other issue you mentioned a=
bout
> >>>>>> allocated page being freed and then re-allocated after page_ext is
> >>>>>> inialized but before clear_page_tag_ref() is called is not really =
a
> >>>>>> problem. Yes, we will lose that counter's value but it's similar t=
o
> >>>>>> other early allocations which we just treat as inaccurate. We can =
also
> >>>>>> minimize the possibility of this happening by moving
> >>>>>> clear_page_tag_ref() into init_page_alloc_tagging().
> >>>>>>
> >>>>>> I don't like the pageflag option you mentioned because it adds an
> >>>>>> extra condition check into __pgalloc_tag_sub() which will be execu=
ted
> >>>>>> even after the init stage is over.
> >>>>>> I'll look into this some more tomorrow as it's quite late now.
> >>>> Hi Suren
> >>>>
> >>>>
> >>>>> Just though of something. Are all these pages allocated by slab? If
> >>>>> so, I think slab does not use page->lru (need to double-check) and =
we
> >>>>> could add all these pages allocated during early init into a list a=
nd
> >>>>> then set their page_ext reference to CODETAG_EMPTY in
> >>>>> init_page_alloc_tagging().
> >>>> Got your point.
> >>>>
> >>>>
> >>>> There will indeed be some non-SLAB memory allocations here, such as =
the
> >>>> following:
> >>>>
> >>>>
> >>>> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted
> >>>> 7.0.0-rc4-00001-g6392c3a6119e-dirty #31 PREEMPT(lazy)
> >>>> [    0.326607] Hardware name: Red Hat KVM, BIOS
> >>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>> [    0.326608] Call Trace:
> >>>> [    0.326608]  <TASK>
> >>>> [    0.326609]  dump_stack_lvl+0x53/0x70
> >>>> [    0.326611]  __pgalloc_tag_add+0x407/0x700
> >>>> [    0.326616]  get_page_from_freelist+0xa54/0x1310
> >>>> [    0.326618]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>> [    0.326623]  alloc_pages_mpol+0x13a/0x3f0
> >>>> [    0.326627]  alloc_pages_noprof+0xf6/0x2b0
> >>>> [    0.326628]  __pmd_alloc+0x743/0x9c0
> >>>> [    0.326630]  vmap_range_noflush+0xac0/0x10a0
> >>>> [    0.326637]  ioremap_page_range+0x17c/0x250
> >>>> [    0.326639]  __ioremap_caller+0x437/0x5c0
> >>>> [    0.326645]  acpi_os_map_iomem+0x4c0/0x660
> >>>> [    0.326647]  acpi_tb_verify_temp_table+0x1c0/0x580
> >>>> [    0.326649]  acpi_reallocate_root_table+0x2ad/0x460
> >>>> [    0.326655]  acpi_early_init+0x111/0x460
> >>>> [    0.326657]  start_kernel+0x271/0x3c0
> >>>> [    0.326659]  x86_64_start_reservations+0x18/0x30
> >>>> [    0.326660]  x86_64_start_kernel+0xe2/0xf0
> >>>> [    0.326662]  common_startup_64+0x13e/0x141
> >>>> [    0.326663]  </TASK>
> >>>>
> >>>> CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted
> >>>> 7.0.0-rc4-00001-g6392c3a6119e-dirty #31 PREEMPT(lazy)
> >>>> [    0.329167] Hardware name: Red Hat KVM, BIOS
> >>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>> [    0.329167] Call Trace:
> >>>> [    0.329167]  <TASK>
> >>>> [    0.329167]  dump_stack_lvl+0x53/0x70
> >>>> [    0.329167]  __pgalloc_tag_add+0x407/0x700
> >>>> [    0.329167]  get_page_from_freelist+0xa54/0x1310
> >>>> [    0.329167]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>> [    0.329167]  __alloc_pages_noprof+0x10/0x1b0
> >>>> [    0.329167]  dup_task_struct+0x163/0x8c0
> >>>> [    0.329167]  copy_process+0x390/0x4a70
> >>>> [    0.329167]  kernel_clone+0xe1/0x830
> >>>> [    0.329167]  kernel_thread+0xcb/0x110
> >>>> [    0.329167]  kthreadd+0x8a2/0xc60
> >>>> [    0.329167]  ret_from_fork+0x551/0x720
> >>>> [    0.329167]  ret_from_fork_asm+0x1a/0x30
> >>>> [    0.329167]  </TASK>
> >>>>
> >>>> CPU: 0 UID: 0 PID: 2 Comm: kthreadd Not tainted
> >>>> 7.0.0-rc4-00001-g6392c3a6119e-dirty #31 PREEMPT(lazy)
> >>>> [    0.329167] Hardware name: Red Hat KVM, BIOS
> >>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>> [    0.329167] Call Trace:
> >>>> [    0.329167]  <TASK>
> >>>> [    0.329167]  dump_stack_lvl+0x53/0x70
> >>>> [    0.329167]  __pgalloc_tag_add+0x407/0x700
> >>>> [    0.329167]  get_page_from_freelist+0xa54/0x1310
> >>>> [    0.329167]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>> [    0.329167]  __alloc_pages_noprof+0x10/0x1b0
> >>>> [    0.329167]  dup_task_struct+0x163/0x8c0
> >>>> [    0.329167]  copy_process+0x390/0x4a70
> >>>> [    0.329167]  kernel_clone+0xe1/0x830
> >>>> [    0.329167]  kernel_thread+0xcb/0x110
> >>>> [    0.329167]  kthreadd+0x8a2/0xc60
> >>>> [    0.329167]  ret_from_fork+0x551/0x720
> >>>> [    0.329167]  ret_from_fork_asm+0x1a/0x30
> >>>> [    0.329167]  </TASK>
> >>>>
> >>>> CPU: 4 UID: 0 PID: 1 Comm: swapper/0 Not tainted
> >>>> 7.0.0-rc4-00001-g6392c3a6119e-dirty #31 PREEMPT(lazy)
> >>>> [    0.434265] Hardware name: Red Hat KVM, BIOS
> >>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>> [    0.434266] Call Trace:
> >>>> [    0.434266]  <TASK>
> >>>> [    0.434266]  dump_stack_lvl+0x53/0x70
> >>>> [    0.434268]  __pgalloc_tag_add+0x407/0x700
> >>>> [    0.434272]  get_page_from_freelist+0xa54/0x1310
> >>>> [    0.434274]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>> [    0.434279]  alloc_pages_exact_nid_noprof+0x10f/0x380
> >>>> [    0.434283]  init_section_page_ext+0x167/0x370
> >>>> [    0.434284]  page_ext_init+0x451/0x620
> >>>> [    0.434287]  page_alloc_init_late+0x553/0x630
> >>>> [    0.434290]  kernel_init_freeable+0x7be/0xd30
> >>>> [    0.434294]  kernel_init+0x1f/0x1f0
> >>>> [    0.434295]  ret_from_fork+0x551/0x720
> >>>> [    0.434301]  ret_from_fork_asm+0x1a/0x30
> >>>> [    0.434303]  </TASK>
> >>>>
> >>>> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted
> >>>> 7.0.0-rc4-00001-g6392c3a6119e-dirty #31 PREEMPT(lazy)
> >>>> [    0.346712] Hardware name: Red Hat KVM, BIOS
> >>>> rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> >>>> [    0.346713] Call Trace:
> >>>> [    0.346713]  <TASK>
> >>>> [    0.346714]  dump_stack_lvl+0x53/0x70
> >>>> [    0.346715]  __pgalloc_tag_add+0x407/0x700
> >>>> [    0.346720]  get_page_from_freelist+0xa54/0x1310
> >>>> [    0.346723]  __alloc_frozen_pages_noprof+0x206/0x4c0
> >>>> [    0.346729]  __alloc_pages_noprof+0x10/0x1b0
> >>>> [    0.346731]  alloc_cpu_data+0x96/0x210
> >>>> [    0.346732]  rb_allocate_cpu_buffer+0xb93/0x1500
> >>>> [    0.346739]  trace_rb_cpu_prepare+0x21a/0x4f0
> >>>> [    0.346753]  cpuhp_invoke_callback+0x6db/0x14b0
> >>>> [    0.346755]  __cpuhp_invoke_callback_range+0xde/0x1d0
> >>>> [    0.346759]  _cpu_up+0x395/0x880
> >>>> [    0.346761]  cpu_up+0x1bb/0x210
> >>>> [    0.346762]  cpuhp_bringup_mask+0xd2/0x150
> >>>> [    0.346763]  bringup_nonboot_cpus+0x12b/0x170
> >>>> [    0.346764]  smp_init+0x2f/0x100
> >>>> [    0.346766]  kernel_init_freeable+0x7a5/0xd30
> >>>> [    0.346769]  kernel_init+0x1f/0x1f0
> >>>> [    0.346771]  ret_from_fork+0x551/0x720
> >>>> [    0.346776]  ret_from_fork_asm+0x1a/0x30
> >>>> [    0.346778]  </TASK>
> >>>>
> >>>> and so on...
> >>>>
> >>>>
> >>>> In fact, I previously conducted extensive and prolonged stress testi=
ng
> >>>>
> >>>> on memory profiling. After our efforts to address several WARN cases=
,
> >>>>
> >>>> one remaining scenario we are addressing is the warning triggered du=
ring
> >>>>
> >>>> early slab cache reclaim =E2=80=94 which is precisely the situation =
we are currently
> >>>>
> >>>> encountering (although I cannot guarantee that all edge cases have b=
een
> >>>>
> >>>> covered by our stress testing). During the stress testing process, t=
his
> >>>> warning
> >>>>
> >>>> did indeed manifest. However, the current environment triggers KASAN=
 slab
> >>>>
> >>>> cache reclaim earlier than anticipated.
> >>>>
> >>>>
> >>>> Although the memory allocated prior to page_ext initialization has a
> >>>> relatively low probability of
> >>>>
> >>>> being released in subsequent operations (at least we have not
> >>>> encountered such cases up to now),
> >>>>
> >>>>     I remain uncertain whether there are any overlooked edge cases w=
hen
> >>>> considering only slab-backed pages.
> >> Hi Suren
> >>
> >>
> >>> Ok, I guess specialized solution for slab would not work then. I want
> >>> to check on my side and understand how the number of these early
> >>> allocation scales. Is it higher for bigger machines or stays constant=
.
> >>> If the latter I think your original simple solution with some fixups
> >>> can still work. I'll need to instrument my code to capture these earl=
y
> >>> allocations and see where they originate. If you have a patch already
> >>> doing that it would help speed it up for me.
> >>> Thanks,
> >>> Suren.
> >> OK, my V2 patch is as follows:
>
> Hi Suren
>
>
> > Thanks! I'll go over it but first I need to check if the number of
> > early allocations is constant or dependent on some factors like
> > machine size (as I mentioned before). I hope to carve out some time to
> > investigate that this Friday.
> > We should also probably start a separate thread for this v2 as this
> > email thread is getting painfully long.
>
> OK, Right, but I can share the test data from my side.
>
> With early_page_ext disabled, I tested the following scenarios, and I
> will share my data.
>
> 8C16G: alloc_count =3D 802
> 8C32G: alloc_count =3D 790
> 16C32G: alloc_count =3D 994
> 16C64G: alloc_count =3D 992
> 32C64G: alloc_count =3D 1364
> 64C64G: alloc_count =3D 2226
> 128C64G: alloc_count =3D 3913
> I think it makes sense for the value to grow with the number of CPUs,

Yep, makes sense. Thanks, this is very helpful data! Now we need to
come up with a solution that can scale :)

> as this involves memory allocations related to CPU boot, like this:
>
> [    0.345299]  dump_stack_lvl+0x53/0x70
> [    0.345301]  __pgalloc_tag_add+0x407/0x700
> [    0.345306]  get_page_from_freelist+0xa54/0x1310
> [    0.345308]  __alloc_frozen_pages_noprof+0x206/0x4c0
> [    0.345314]  __alloc_pages_noprof+0x10/0x1b0
> [    0.345316]  alloc_cpu_data+0x96/0x210
> [    0.345318]  rb_allocate_cpu_buffer+0xb93/0x1500
> [    0.345325]  trace_rb_cpu_prepare+0x21a/0x4f0
> [    0.345327]  cpuhp_invoke_callback+0x6db/0x14b0
> [    0.345329]  __cpuhp_invoke_callback_range+0xde/0x1d0
> [    0.345333]  _cpu_up+0x395/0x880
> [    0.345335]  cpu_up+0x1bb/0x210
> [    0.345336]  cpuhp_bringup_mask+0xd2/0x150
> [    0.345337]  bringup_nonboot_cpus+0x12b/0x170
> [    0.345338]  smp_init+0x2f/0x100
> [    0.345340]  kernel_init_freeable+0x7a5/0xd30
> [    0.345344]  kernel_init+0x1f/0x1f0
>
>
> I will send out version 2 as soon as possible.
>
> Thanks
>
> Hao
>
> >
> >>
> >> diff --git a/include/linux/alloc_tag.h b/include/linux/alloc_tag.h
> >> index d40ac39bfbe8..bf226c2be2ad 100644
> >> --- a/include/linux/alloc_tag.h
> >> +++ b/include/linux/alloc_tag.h
> >> @@ -74,6 +74,8 @@ static inline void set_codetag_empty(union codetag_r=
ef
> >> *ref)
> >>
> >>    #ifdef CONFIG_MEM_ALLOC_PROFILING
> >>
> >> +void alloc_tag_add_early_pfn(unsigned long pfn);
> >> +
> >>    #define ALLOC_TAG_SECTION_NAME    "alloc_tags"
> >>
> >>    struct codetag_bytes {
> >> diff --git a/include/linux/pgalloc_tag.h b/include/linux/pgalloc_tag.h
> >> index 38a82d65e58e..951d33362268 100644
> >> --- a/include/linux/pgalloc_tag.h
> >> +++ b/include/linux/pgalloc_tag.h
> >> @@ -181,7 +181,7 @@ static inline struct alloc_tag
> >> *__pgalloc_tag_get(struct page *page)
> >>
> >>        if (get_page_tag_ref(page, &ref, &handle)) {
> >>            alloc_tag_sub_check(&ref);
> >> -        if (ref.ct)
> >> +        if (ref.ct && !is_codetag_empty(&ref))
> >>                tag =3D ct_to_alloc_tag(ref.ct);
> >>            put_page_tag_ref(handle);
> >>        }
> >> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >> index 58991ab09d84..55c134a71cd0 100644
> >> --- a/lib/alloc_tag.c
> >> +++ b/lib/alloc_tag.c
> >> @@ -6,6 +6,7 @@
> >>    #include <linux/kallsyms.h>
> >>    #include <linux/module.h>
> >>    #include <linux/page_ext.h>
> >> +#include <linux/pgalloc_tag.h>
> >>    #include <linux/proc_fs.h>
> >>    #include <linux/seq_buf.h>
> >>    #include <linux/seq_file.h>
> >> @@ -26,6 +27,85 @@ static bool mem_profiling_support;
> >>
> >>    static struct codetag_type *alloc_tag_cttype;
> >>
> >> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >> +
> >> +/*
> >> + * page_ext is allocated and initialized relatively late during boot.
> >> + * Some pages are allocated before page_ext becomes available.
> >> + * Track these early PFNs and clear their codetag refs later to avoid
> >> + * warnings when they are freed.
> >> + */
> >> +
> >> +#define EARLY_ALLOC_PFN_MAX        256
> >> +
> >> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX] __initdata;
> >> +static atomic_t early_pfn_count __initdata =3D ATOMIC_INIT(0);
> >> +
> >> +static void __init __alloc_tag_add_early_pfn(unsigned long pfn)
> >> +{
> >> +    int old_idx, new_idx;
> >> +
> >> +    do {
> >> +        old_idx =3D atomic_read(&early_pfn_count);
> >> +        if (old_idx >=3D EARLY_ALLOC_PFN_MAX)
> >> +            return;
> >> +        new_idx =3D old_idx + 1;
> >> +    } while (!atomic_try_cmpxchg(&early_pfn_count, &old_idx, new_idx)=
);
> >> +
> >> +    early_pfns[old_idx] =3D pfn;
> >> +}
> >> +
> >> +static void (*alloc_tag_add_early_pfn_ptr)(unsigned long pfn) __refda=
ta =3D
> >> +        __alloc_tag_add_early_pfn;
> >> +
> >> +void alloc_tag_add_early_pfn(unsigned long pfn)
> >> +{
> >> +    if (static_key_enabled(&mem_profiling_compressed))
> >> +        return;
> >> +
> >> +    if (alloc_tag_add_early_pfn_ptr)
> >> +        alloc_tag_add_early_pfn_ptr(pfn);
> >> +}
> >> +
> >> +static void __init clear_early_alloc_pfn_tag_refs(void)
> >> +{
> >> +    unsigned int i;
> >> +
> >> +    for (i =3D 0; i < atomic_read(&early_pfn_count); i++) {
> >> +        unsigned long pfn =3D early_pfns[i];
> >> +
> >> +        if (pfn_valid(pfn)) {
> >> +            struct page *page =3D pfn_to_page(pfn);
> >> +            union pgtag_ref_handle handle;
> >> +            union codetag_ref ref;
> >> +
> >> +            if (get_page_tag_ref(page, &ref, &handle)) {
> >> +                /*
> >> +                 * An early-allocated page could be freed and realloc=
ated
> >> +                 * after its page_ext is initialized but before we
> >> clear it.
> >> +                 * In that case, it already has a valid tag set.
> >> +                 * We should not overwrite that valid tag with
> >> CODETAG_EMPTY.
> >> +                 */
> >> +                if (ref.ct) {
> >> +                    put_page_tag_ref(handle);
> >> +                    continue;
> >> +                }
> >> +
> >> +                set_codetag_empty(&ref);
> >> +                update_page_tag_ref(handle, &ref);
> >> +                put_page_tag_ref(handle);
> >> +            }
> >> +    }
> >> +
> >> +    atomic_set(&early_pfn_count, 0);
> >> +
> >> +    alloc_tag_add_early_pfn_ptr =3D NULL;
> >> +}
> >> +#else /* !CONFIG_MEM_ALLOC_PROFILING_DEBUG */
> >> +inline void alloc_tag_add_early_pfn(unsigned long pfn) {}
> >> +static inline void __init clear_early_alloc_pfn_tag_refs(void) {}
> >> +#endif
> >> +
> >>    #ifdef CONFIG_ARCH_MODULE_NEEDS_WEAK_PER_CPU
> >>    DEFINE_PER_CPU(struct alloc_tag_counters, _shared_alloc_tag);
> >>    EXPORT_SYMBOL(_shared_alloc_tag);
> >> @@ -760,6 +840,7 @@ static __init bool need_page_alloc_tagging(void)
> >>
> >>    static __init void init_page_alloc_tagging(void)
> >>    {
> >> +    clear_early_alloc_pfn_tag_refs();
> >>    }
> >>
> >>    struct page_ext_operations page_alloc_tagging_ops =3D {
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 2d4b6f1a554e..5ce5c4ba401f 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -1293,6 +1293,12 @@ void __pgalloc_tag_add(struct page *page, struc=
t
> >> task_struct *task,
> >>            alloc_tag_add(&ref, task->alloc_tag, PAGE_SIZE * nr);
> >>            update_page_tag_ref(handle, &ref);
> >>            put_page_tag_ref(handle);
> >> +    } else {
> >> +        /*
> >> +         * page_ext is not available yet, record the pfn so we can
> >> +         * clear the tag ref later when page_ext is initialized.
> >> +         */
> >> +        alloc_tag_add_early_pfn(page_to_pfn(page));
> >>        }
> >>    }
> >>
> >> Although this 256-entry array remains unmodified for now, I will local=
ly
> >> record the occurrence counts
> >>
> >> of these various early memory allocations. Hopefully this will be
> >> helpful to you.
> >>
> >>
> >> Thanks
> >>
> >> Hao
> >>
> >>>> Thanks
> >>>> Hao
> >>>>
> >>>>>> Thanks,
> >>>>>> Suren.
> >>>>>>
> >>>>>>> However, I'm not entirely certain whether SPARSEMEM can guarantee=
 the
> >>>>>>> same behavior.
> >>>>>>>
> >>>>>>>
> >>>>>>>>> I would appreciate your valuable feedback and any better sugges=
tions you
> >>>>>>>>> might have.
> >>>>>>>> Thanks for pursuing this! I'll help in any way I can.
> >>>>>>>> Suren.
> >>>>>>> Thank you so much for your patient guidance and assistance.
> >>>>>>>
> >>>>>>> I truly appreciate your willingness to share your knowledge and i=
nsights.
> >>>>>>>
> >>>>>>> Thanks,
> >>>>>>> Hao
> >>>>>>>
> >>>>>>>>> Thanks
> >>>>>>>>>
> >>>>>>>>> Hao
> >>>>>>>>>
> >>>>>>>>>> Thanks,
> >>>>>>>>>> Suren.
> >>>>>>>>>>
> >>>>>>>>>>> Thanks
> >>>>>>>>>>>
> >>>>>>>>>>> Hao
> >>>>>>>>>>>
> >>>>>>>>>>>>> Thanks.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> If the slab cache has no free objects, it falls back
> >>>>>>>>>>>>>>>>> to the buddy allocator to allocate memory. However, at =
this point page_ext
> >>>>>>>>>>>>>>>>> is not yet fully initialized, so these newly allocated =
pages have no
> >>>>>>>>>>>>>>>>> codetag set. These pages may later be reclaimed by KASA=
N,which causes
> >>>>>>>>>>>>>>>>> the warning to trigger when they are freed because thei=
r codetag ref is
> >>>>>>>>>>>>>>>>> still empty.
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> Use a global array to track pages allocated before page=
_ext is fully
> >>>>>>>>>>>>>>>>> initialized, similar to how kmemleak tracks early alloc=
ations.
> >>>>>>>>>>>>>>>>> When page_ext initialization completes, set their codet=
ag
> >>>>>>>>>>>>>>>>> to empty to avoid warnings when they are freed later.
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> ...
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> --- a/include/linux/alloc_tag.h
> >>>>>>>>>>>>>>>>> +++ b/include/linux/alloc_tag.h
> >>>>>>>>>>>>>>>>> @@ -74,6 +74,9 @@ static inline void set_codetag_empty(=
union codetag_ref *ref)
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>         #ifdef CONFIG_MEM_ALLOC_PROFILING
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> +bool mem_profiling_is_available(void);
> >>>>>>>>>>>>>>>>> +void alloc_tag_add_early_pfn(unsigned long pfn);
> >>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>         #define ALLOC_TAG_SECTION_NAME       "alloc_tag=
s"
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>         struct codetag_bytes {
> >>>>>>>>>>>>>>>>> diff --git a/lib/alloc_tag.c b/lib/alloc_tag.c
> >>>>>>>>>>>>>>>>> index 58991ab09d84..a5bf4e72c154 100644
> >>>>>>>>>>>>>>>>> --- a/lib/alloc_tag.c
> >>>>>>>>>>>>>>>>> +++ b/lib/alloc_tag.c
> >>>>>>>>>>>>>>>>> @@ -6,6 +6,7 @@
> >>>>>>>>>>>>>>>>>         #include <linux/kallsyms.h>
> >>>>>>>>>>>>>>>>>         #include <linux/module.h>
> >>>>>>>>>>>>>>>>>         #include <linux/page_ext.h>
> >>>>>>>>>>>>>>>>> +#include <linux/pgalloc_tag.h>
> >>>>>>>>>>>>>>>>>         #include <linux/proc_fs.h>
> >>>>>>>>>>>>>>>>>         #include <linux/seq_buf.h>
> >>>>>>>>>>>>>>>>>         #include <linux/seq_file.h>
> >>>>>>>>>>>>>>>>> @@ -26,6 +27,82 @@ static bool mem_profiling_support;
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>>         static struct codetag_type *alloc_tag_cttype;
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> +/*
> >>>>>>>>>>>>>>>>> + * State of the alloc_tag
> >>>>>>>>>>>>>>>>> + *
> >>>>>>>>>>>>>>>>> + * This is used to describe the states of the alloc_ta=
g during bootup.
> >>>>>>>>>>>>>>>>> + *
> >>>>>>>>>>>>>>>>> + * When we need to allocate page_ext to store codetag,=
 we face an
> >>>>>>>>>>>>>>>>> + * initialization timing problem:
> >>>>>>>>>>>>>>>>> + *
> >>>>>>>>>>>>>>>>> + * Due to initialization order, pages may be allocated=
 via buddy system
> >>>>>>>>>>>>>>>>> + * before page_ext is fully allocated and initialized.=
 Although these
> >>>>>>>>>>>>>>>>> + * pages call the allocation hooks, the codetag will n=
ot be set because
> >>>>>>>>>>>>>>>>> + * page_ext is not yet available.
> >>>>>>>>>>>>>>>>> + *
> >>>>>>>>>>>>>>>>> + * When these pages are later free to the buddy system=
, it triggers
> >>>>>>>>>>>>>>>>> + * warnings because their codetag is actually empty if
> >>>>>>>>>>>>>>>>> + * CONFIG_MEM_ALLOC_PROFILING_DEBUG is enabled.
> >>>>>>>>>>>>>>>>> + *
> >>>>>>>>>>>>>>>>> + * Additionally, in this situation, we cannot record d=
etailed allocation
> >>>>>>>>>>>>>>>>> + * information for these pages.
> >>>>>>>>>>>>>>>>> + */
> >>>>>>>>>>>>>>>>> +enum mem_profiling_state {
> >>>>>>>>>>>>>>>>> +     DOWN,                   /* No mem_profiling funct=
ionality yet */
> >>>>>>>>>>>>>>>>> +     UP                      /* Everything is working =
*/
> >>>>>>>>>>>>>>>>> +};
> >>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>> +static enum mem_profiling_state mem_profiling_state =
=3D DOWN;
> >>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>> +bool mem_profiling_is_available(void)
> >>>>>>>>>>>>>>>>> +{
> >>>>>>>>>>>>>>>>> +     return mem_profiling_state =3D=3D UP;
> >>>>>>>>>>>>>>>>> +}
> >>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>> +#ifdef CONFIG_MEM_ALLOC_PROFILING_DEBUG
> >>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>> +#define EARLY_ALLOC_PFN_MAX          256
> >>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>> +static unsigned long early_pfns[EARLY_ALLOC_PFN_MAX];
> >>>>>>>>>>>>>>>> It's unfortunate that this isn't __initdata.
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> +static unsigned int early_pfn_count;
> >>>>>>>>>>>>>>>>> +static DEFINE_SPINLOCK(early_pfn_lock);
> >>>>>>>>>>>>>>>>> +
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> ...
> >>>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> --- a/mm/page_alloc.c
> >>>>>>>>>>>>>>>>> +++ b/mm/page_alloc.c
> >>>>>>>>>>>>>>>>> @@ -1293,6 +1293,13 @@ void __pgalloc_tag_add(struct pa=
ge *page, struct task_struct *task,
> >>>>>>>>>>>>>>>>>                      alloc_tag_add(&ref, task->alloc_ta=
g, PAGE_SIZE * nr);
> >>>>>>>>>>>>>>>>>                      update_page_tag_ref(handle, &ref);
> >>>>>>>>>>>>>>>>>                      put_page_tag_ref(handle);
> >>>>>>>>>>>>>>>>> +     } else {
> >>>>>>>>>>>>>>> This branch can be marked as "unlikely".
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>>> +             /*
> >>>>>>>>>>>>>>>>> +              * page_ext is not available yet, record =
the pfn so we can
> >>>>>>>>>>>>>>>>> +              * clear the tag ref later when page_ext =
is initialized.
> >>>>>>>>>>>>>>>>> +              */
> >>>>>>>>>>>>>>>>> +             if (!mem_profiling_is_available())
> >>>>>>>>>>>>>>>>> +                     alloc_tag_add_early_pfn(page_to_p=
fn(page));
> >>>>>>>>>>>>>>>>>              }
> >>>>>>>>>>>>>>>>>         }
> >>>>>>>>>>>>>>>> All because of this, I believe.  Is this fixable?
> >>>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>> If we take that `else', we know we're running in __init =
code, yes?  I
> >>>>>>>>>>>>>>>> don't see how `__init pgalloc_tag_add_early()' could be =
made to work.
> >>>>>>>>>>>>>>>> hrm.  Something clever, please.
> >>>>>>>>>>>>>>> We can have a pointer to a function that is initialized t=
o point to
> >>>>>>>>>>>>>>> alloc_tag_add_early_pfn, which is defined as __init and u=
ses
> >>>>>>>>>>>>>>> early_pfns which now can be defined as __initdata. After
> >>>>>>>>>>>>>>> clear_early_alloc_pfn_tag_refs() is done we reset that po=
inter to
> >>>>>>>>>>>>>>> NULL. __pgalloc_tag_add() instead of calling alloc_tag_ad=
d_early_pfn()
> >>>>>>>>>>>>>>> directly checks that pointer and if it's not NULL then ca=
lls the
> >>>>>>>>>>>>>>> function that it points to. This way __pgalloc_tag_add() =
which is not
> >>>>>>>>>>>>>>> an __init function will be invoking alloc_tag_add_early_p=
fn() __init
> >>>>>>>>>>>>>>> function only until we are done with initialization. I ha=
ven't tried
> >>>>>>>>>>>>>>> this but I think that should work. This also eliminates t=
he need for
> >>>>>>>>>>>>>>> mem_profiling_state variable since we can use this functi=
on pointer
> >>>>>>>>>>>>>>> instead.
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>>

