Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62AF7E9E31B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 01:43:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EC876B0005; Wed, 11 Feb 2026 20:43:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998E56B0089; Wed, 11 Feb 2026 20:43:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87AC36B008A; Wed, 11 Feb 2026 20:43:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 790726B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 20:43:07 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EB33CBA3F8
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:43:06 +0000 (UTC)
X-FDA: 84434106372.24.BD9EA89
Received: from mail-yx1-f44.google.com (mail-yx1-f44.google.com [74.125.224.44])
	by imf01.hostedemail.com (Postfix) with ESMTP id EDE3D4000B
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 01:43:04 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gPICc9ER;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770860585;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pQNNV1lyjEdP2OrQfDb/AG8ogO9dTjL4vmNELjD2OdI=;
	b=3QCZWjfakPkiqYsuHsiKHy03w13lUc6iA/rQtCLguITuC0s9Kl1lux8Ru722av8n9zaTvY
	kKSBHQk8zTdS00ooetIaeI841bSqnUu6kgsbcamRzT8/EuByWbZA9uPT3Jwfoxl/Rxm7YQ
	e8cNXOnOrYSSWpXU6Is57RdAuZjhOGc=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770860585; a=rsa-sha256;
	cv=pass;
	b=UOOhbRt7kEUfNodGMpDmAmU3jpZQFlH7/F+AiqVs+z1fvHxdemSESDHAanemiRFQRopvBj
	mq4IkqM23reOpW1LeYCMQtKGljL/h8HGgKpJXrouYbGNB5iZXXSpAHJwBXjbuoZdtc6xHl
	OydGg01n0qaMz8GboGGQxFWoB5c13Aw=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gPICc9ER;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf01.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.44 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-yx1-f44.google.com with SMTP id 956f58d0204a3-649b5f5570fso2257223d50.0
        for <linux-mm@kvack.org>; Wed, 11 Feb 2026 17:43:04 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770860584; cv=none;
        d=google.com; s=arc-20240605;
        b=J5xP1asf4YTFA/A6ugttAbsq3eeS0lIgk+IMYI9RRf+ekvYVtH/Wg9lmA4iut9vheB
         pONaX+7dxA8kbMAhsmmhtTkcgyiusNSvoLrAdHNwrE4hxwGplsA6Zppb4JnYqKx9GRMz
         VTbu5K6jJtjv9EMB3m9Xdw2kuf40EzLNzYvHc395mVg4J8x+QjLU8XXg6ig99gYQfeby
         51yRD0vdexrAJ4wHJ3GjkxaB0vBFOW7ypSr8511y4zng5Mc9OQ4wOc0QxFB22zFdulw/
         Ol2uPvYE3Owb4cxWvMD8R8AUuEtoJRCzyQXvpHWFQw6ZlkmgTGcgUlqNYK3zZJgqia4/
         3VzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pQNNV1lyjEdP2OrQfDb/AG8ogO9dTjL4vmNELjD2OdI=;
        fh=P2XvMllnmwJFSSssSZTwzBZNVukk1SEh6iNHMfpsE4E=;
        b=kGMoZVRLuMXfrkk3xO4QPvca/7rDR6WtRN8NEvu4Kf4UPzb87LOda/hKclrp9s0orf
         gET8J8b59f4SfNsgaof4m821LKA9aRqEdtgC6Ng82NtFw7wiMq94iKpWsIwt5n5s0E5g
         9qI1vOJ9LrtM+QHH8/C0B32On4hdGpGxNGgSE4rM9fGni+oZ9Z3nLBMzX5NwaL/E5zRc
         PovII1gRydRF6GtFohrY3IOrwTigoPRIJ3MCnhcG9vo2poVYIjge2PUtr2MO7nvm7KVt
         pC4+8d/dcAtxcz/ElJ1+KmozRhnDztz3yRcYMXVW3UzJ0vQFZe71sd2kvt/QJNTi6ijD
         FVGw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770860584; x=1771465384; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pQNNV1lyjEdP2OrQfDb/AG8ogO9dTjL4vmNELjD2OdI=;
        b=gPICc9ERGBlkSMoGRdeFaspo19OGslYd6M6dhtb6MyU8eqYgZ4xXRdVOVCBLmPbrFW
         i3noXfOPAO+0CWbqoqsK0yyt3oT3tbUxEbqlPRPRZoDNbPUVBgyYLMU9mgFMbJSXvHN+
         wnVCmx0WVO8l/ksI4Uv9vKfhpDtR57eyui+gk4vS3N4AszxuXGOpB8fBsR78oqoRybNb
         pO7/Sx+F9GtEWwEtDWugO9awplbx1cj3BXHRkku0vxvJFF6YgdRNIQ/RErEz2l1sAU6/
         SN2VWvnrF7EgSUvXCchJ+vgx1HV5fwpZ8S9EDiGNc253yWMiR86mXimQC3jhrYhqP4JZ
         fchA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770860584; x=1771465384;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pQNNV1lyjEdP2OrQfDb/AG8ogO9dTjL4vmNELjD2OdI=;
        b=CBLA7O1KWhAPP1MlvQ1ckGCo5SKM267rXJrImcwZO2/YCywqeVcnGch5Q9aVJDHMCP
         QrJb3Xh41M5WHQNOtip1PKI2bqyVa2nt7R2zgxPwQQsJK9I3PReIMuiKffC3EDpghr9o
         ibRTRQ2zXJ0OjJpiBhjCknJ8NGkQz8rN+EHQT4kOR7hVIs9ux+UrcNuZNJUWtB5Nojgy
         ydm2H+PI5vxCPndssM5qRUgbuqrB2Vemkz04pUKcXX00q30X8komMLkz54inxeOLMx3n
         hpSguR0Wp0dzSco3gx4X5ijEo/RLltTpHTXpQxnw5kPiLYGOvtblitm+bx7rfThXUtW6
         2yAg==
X-Forwarded-Encrypted: i=1; AJvYcCXjxxLAJFwSOm2EL/hvZuR5xo92iPbIkolFY+ARiDWiUmXEvKtyNV4uz669NGjfZYsLk3EtT3AznQ==@kvack.org
X-Gm-Message-State: AOJu0YzQWAIOhYhviyGfusnWEQYGgPPUl/6G6kpEGy93h4mC6C8nx8nH
	VI6VoCQenei7aUJi7WLD06fPOp68OcSNChg+PF1LtcT6G7fERsGmSJOdomB6V057nz4OIQCku4B
	9dp3LmEJJjNoM08/zSWHspgEt0r1glYs=
X-Gm-Gg: AZuq6aL1FGa9LTmpItOrJu3jnmtv66pF/xeZSl5Q6Bg49vr3KaPXOHRXb4p95P9XNRu
	vm57LySrKdufNF90ryPIbZfP+twO4IXy3hLJmzAO1zL6Xz5/oEPnZeocXOM3tzRg/ilBDzDh+/R
	gEutQEmT53b32n3kaXzy2HKeZFMM18XhRRcX5RLINJcS5Ax8DPbDelbappuh7YJCOj8nRLLcGSl
	uIDGj4mzym9IqbogrpaCHa4QCPXZzbAOUAEBSYpNBegvlGiRJg98SMXprdz8IkIKt992OnEiyfH
	SXgFYtb5ELhelMJikU0=
X-Received: by 2002:a05:690e:190a:b0:64a:a578:9771 with SMTP id
 956f58d0204a3-64be6baa377mr766642d50.26.1770860583893; Wed, 11 Feb 2026
 17:43:03 -0800 (PST)
MIME-Version: 1.0
References: <20260210043456.2137482-1-haowenchao22@gmail.com>
 <5c4d773c-e3e7-4a71-b250-91701cbdd4a2@kernel.org> <CAOptpSPuntL5dy+D7-wWcWuOgxugD+_uLzEO8e4fyGjS_ZkUWQ@mail.gmail.com>
 <52ab55c0-6b70-4afc-866d-dd505ff3e85b@arm.com>
In-Reply-To: <52ab55c0-6b70-4afc-866d-dd505ff3e85b@arm.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 12 Feb 2026 09:42:52 +0800
X-Gm-Features: AZwV_QhWB8QKZLaQhjKHQWvchtvRzHYitwh0Jlcv9mT9NKSJgcevLLTvVJvIUZs
Message-ID: <CAOptpSN96Juwx9apwrt8NpakJOUoUCKxpUPyko9Cz_DJvKoZHA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: only set fault addrsss' access bit in do_anonymous_page
To: Dev Jain <dev.jain@arm.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: EDE3D4000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 84awdgimd4bq8e6fcuji7d1dbt5qo9xi
X-HE-Tag: 1770860584-311309
X-HE-Meta: U2FsdGVkX1+JkCzt6MTxh9vba/jhoYUS1R8TlWyDVTqeNY55w2BIvnNst7+RVYVzuhKsaSwqpNeA+pkDXr+a0j1h2OuZ9Vdt+H5JFXlGIqTBCPxLSPPu+dvsXQx8zVfpRwlNmYGcMZ1JvTidJurmxjT9lsOHWkm8BRVSke9B+xqEyeJb3Z+nDaDuqz9Y3E/O8SXMhp4mGByHU/IuEJzQhinDQhPoueGVGpUoOtbDQ+748wsUhEJ8UquVyZRnNlyt+eocDEK07o5OQ9pKneNo6qLJ1rQq8VuHZgliH3J3Z7HLQS0w6QuMYCWqN06Q98GSy6DV4Qwo9L/buUVdp+yqDNk3wj4ZSnCaY2KLGhNXk/4lsn4Vgqd+E5AKbf3SXBuW1Cxh+UIUUI1gpXm+J7hR1jmI1z9zA4Foae9F7gPNJtEzYZU/UhrWM1UjMkFCYQM/IADApB6AYtqI7tvNN4ywf5VI2oZ+hiZY1d86AlJXjz156qx/RB92r67mQg45VvvcKmGjQaunW+OV8Go2harLTNGnJOZhITGGCkXgXQaq4TW6CDwt7U32U58emb3eo4teCTb4lUC1LCm9g4gNHTyRiEobBUWOOhl1VmV0RrXtgdOvKrBF5zASW70lFcpfWMG5aV4yeyqF3J3BG32McSYnDyWY0tjuyfHkvh09IGSXZ9cQcmeahmNktOpEfMGdGyb9ba/NRJ59KNIsyJ8SovezL9OuUVLFHTjlzz7o4sBTBQJHl8Ska9C7t75/3AcbbFysj1N43GWVt0DxMm1OsX9AtwrzSNqiDcFMl4l4ITv4F1DjyyX7dxSH0BNOfUH0dalRzYixP5m7m60skbRkpXY7vIUzKZP9pFxmnZ6h+wtCnJbD6B9akdLWglSl+TfPeaZIXd0JdexOTEyPXDetWfqq7Q6nShJk05i48wQJ2yOTGvtsExMNsLMhxLIdknLWgBPlDd+iGnAfUV0974UkBSa
 oRTONvjX
 5WBi2lw7asI6EL8oZiwgDt2iuChdcG0j3gMRGqIzLyqzRm4FDcb850yZJxlepbJ0uZMVr8zSNnbljDebZomg+8gp/JYaqjneHqsqurfbelu4QcrQj9JQWh8AlT3zI3pzsT8H/9ZjkSjp3oRSimk4ZBjRmLwWalv0tnYKYmH+0FCvKI65HN/UvvkWMa568+MXaV1fm/h2zmQtYVPeRePokASohHdKnO22EAO2fdLnYmf4tSg/E63Z0cRIEgHYpU3kME5CH2rH/sCjCncBdHbY/U3eAcHRdKzbNRbhNP/oSjhS8thixbBlATzn6Ld9U1Zf1ebvJMKBKZ652dNRe++0yMzmTih99zZtWnt625m/9/0L2rucOXzlTjAne0v9ZFgYZwInIDy5sAV3gCWkeHRMvDGwVky5ygkX4wr5HR85rqJIQyJm0Dg9pwS8G3uoGbocgwWe1vUL9UmELmUgzS6dz4dNNMQt1zbRnnhWm7T+E1fByMcbqtl+XRCXDNQArHKpOiUi2lwLEVaTPRJ1OKgsh6SXmJg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 11, 2026 at 12:18=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
> On 11/02/26 6:19 am, Wenchao Hao wrote:
> > On Tue, Feb 10, 2026 at 5:07=E2=80=AFPM David Hildenbrand (Arm)
> > <david@kernel.org> wrote:
> >> On 2/10/26 05:34, Wenchao Hao wrote:
> >>> When do_anonymous_page() creates mappings for huge pages, it currentl=
y sets
> >>> the access bit for all mapped PTEs (Page Table Entries) by default.
> >>>
> >>> This causes an issue where the Referenced field in /proc/pid/smaps ca=
nnot
> >>> distinguish whether a page was actually accessed.
> >> What is the use case that cares about that?
> >>
> > We have enabled 64KB large folios on Android devices, which may introdu=
ce
> > some memory waste. I want to figure out the proportion of memory waste
> > caused by large folios. Reading the "Referenced" field from /proc/pid/s=
maps
> > is a relatively low-cost method.
> >
> > Additionally, considering future hot/cold page identification, we aim t=
o
> > detect 64KB large folios where some pages are actually unaccessed and s=
plit
> > them into normal pages to avoid memory waste.
> >
> > However, the current large folio implementation sets the access bit for=
 all
> > page table entries (PTEs) of the large folio in the do_anonymous_page
> > function, making it hard to distinguish whether pre-allocated pages wer=
e
> > truly accessed.
> >
> >> What we have right now is the exact same behavior as if you would get =
a
> >> PMD THP that has a single access+dirty bit at fault time.
> >>
> >> Also, architectures that support transparent PTE coalescing will not b=
e
> >> able to coalesce until all PTE bits are equal.
> >>
> >> This level of imprecision is to be expected with large folios that onl=
y
> >> have a single access+dirty bit.
> >>
> > Thanks a lot for the response.
> >
> > I saw this description in the ARM manual, =E2=80=9CD8.5.5 Use of the Co=
ntiguous bit
> > with hardware updates to the translation tables=E2=80=9D:
> >
> >
> >> If hardware updates a translation table entry, and if the Contiguous b=
it in
> >> that entry is 1, then the members in a group of contiguous translation=
 table
> >> entries can have different AF, AP[2], and S2AP[1] values.
> > Does this mean that after hardware aggregates multiple PTEs, it can sti=
ll
> > independently set the AF and other flag bits corresponding to specific
> > sub-PTE?
>
> Yes. Hardware can update access and dirty bits per-pte. It is the job
> of software to aggregate them.
>
> >
> > If so, can software also set different AF bits for a group of 16 PTEs
> > without affecting the transparent PTE coalescing function?
>
> Yes. See set_ptes -> __contpte_try_fold: look at pte_mkold(pte_mkclean())=
.
> We ignore the a/d bits while constructing the next expected pte.
>

Thank you for your answer. I think we can now get the following conclusion:
From a hardware perspective, after the PTE continuous bit is set, the acces=
s
and dirty flags of the PTE do not affect the transparent PTE
coalescing function.

> >
> > The reason I have this confusion is that there is such a description in
> > =E2=80=9CD8.7.1 The Contiguous bit:=E2=80=9D
> >
> >> Software is required to ensure that all of the adjacent translation ta=
ble
> >> entries for the contiguous region point to a contiguous OA range with
> >> consistent attributes and permissions.
> > It does not specify whether attributes and permissions include the AF b=
it.
> >
> >> --
> >> Cheers,
> >>
> >> David

