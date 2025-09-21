Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDFA9CAC59A
	for <linux-mm@archiver.kernel.org>; Sun, 21 Sep 2025 23:07:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0735E8E0003; Sun, 21 Sep 2025 19:07:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 024468E0001; Sun, 21 Sep 2025 19:07:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7C138E0003; Sun, 21 Sep 2025 19:07:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D4F8E8E0001
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 19:07:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7F26E16041E
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:07:40 +0000 (UTC)
X-FDA: 83914796280.23.B483F7A
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9B0BB180002
	for <linux-mm@kvack.org>; Sun, 21 Sep 2025 23:07:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kxZurglJ;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758496058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLMc7S+BvGFbDaO/gJECxMl9cCHViKZI7SeUZwZSwFM=;
	b=5P5D11+06ltpqwVkKtbzD9P8o2Yj5hJr8M+Ho6fnSGdfBbc2UK60nXSxZiTqnx9y/2AVH6
	bru24/P0IOkvahl8r/PXRKhHPENos0j0xZ64HyMmAbu6jJIisrYw9IHYQlExUrJJNlDHpg
	r61RBV1XhqteYzmLorqzDrguccmmmwU=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=kxZurglJ;
	spf=pass (imf06.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758496058; a=rsa-sha256;
	cv=none;
	b=mOP21CVfeq9mk5KTePHtVwO4GcL+0dV/mLVqjgVFBxI4kBRM/lXzRYZXrwK79Q0yQAF78/
	TobsQ/aik6SSR0KLx5bcuL6QItRgP1v/gcNj6gBKpuModrBrf3S0pojLDKU5z/rFbLWBs5
	bf28pkLdA+gf/7bIokGZ2xx8xl44cjI=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b5d5b1bfa3so35250381cf.1
        for <linux-mm@kvack.org>; Sun, 21 Sep 2025 16:07:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1758496058; x=1759100858; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lLMc7S+BvGFbDaO/gJECxMl9cCHViKZI7SeUZwZSwFM=;
        b=kxZurglJwjV2Ie2Q+MxtKcd7IBbbDQ8oy4lYFv/b0zjBiJPekJMsejIziDWw9NgBqm
         ujpkGiyDan62qyOiwMyD6VIAh5xxsNl96RRaYtxRSoIAkzh0VKJAcZrrS8sB762JXzeF
         6tph6fLmlvHx0zzoLpU0fJAlA0AIaZSnO/NawBX/0G5jMVi4sutCHgwFOe7atdYoln4V
         dht8FOCAS6yZnU51SopcDAF6EcJ6ktykSdgFZqvys3Pza2nk0rMkZR25eKE7e1UniUeX
         ZwsAkte4CWvOL/W2SgJnN0Inx0eY799oFhfoW4QYa67mgBlJYWpEK4zfRsuoOv9a6CpY
         m5DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758496058; x=1759100858;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lLMc7S+BvGFbDaO/gJECxMl9cCHViKZI7SeUZwZSwFM=;
        b=uIVTT2xbldL6KI/3CFPwsgQDf79I2uXJwkSlECZz8IraAYKRLuRD2BXeiR5rBC+rUA
         FOUj9HCu59pGhJHer2eaRvsJn9aaIEDiEmn95xGBzKcMUWbN7YMygeptcPFHqvOHiGix
         nYCLTjL6RccN9dB0sgz/gvWOGe8z2mTkqBoaIhz/R5yZpR3V5O01qn/3BTAAeA12Nq89
         b3DqDzMWeYGp7NKuXYJGG8KMW3vs0vvhqSQHhLmstNhGuT3A84qjGDZxzBM3mAePLvlB
         7K84qQwqa9uePUoABSKeXsk9ZYwRMdZUlBs0dYfkUKe1DcMzSTpWKBSpdnH1nRISad3A
         dOug==
X-Forwarded-Encrypted: i=1; AJvYcCWtOc3F6Xa9SDBwu4StqTY8AP+2qZbvyk9MNb0BeIdyMjc1fq95glMtXbMQADIjw1EZNmb5SEBQPQ==@kvack.org
X-Gm-Message-State: AOJu0Yy0Qqn0GZ7f2mhSLVhCWmaHE9Yxqd0ljNAPK0PNymYyOZymuHz1
	wQBKOch8TabPxC/rDlXN/iMOArDE8K/5J82FumAMZ7WvWp3PlSgE3K8ULwDegcLNrizzpqiRYXG
	S6ntjVW2znOKMq+DgQafbOWx0lGuJmcbG9Y7bui2w3A==
X-Gm-Gg: ASbGnctHQiT/2adLSc4hS0nK0YhSffYGyt1xbpAxyq/s0Ex0rax8BrUf/IdBjXZ3vDv
	ZPIsXtckesY0SW8eelAfIyArc7mEhQuAXu9LRIFRQGh61G0Ne4wzOQa/kwsoKCaiu5d+MXPZ0PF
	1eZX/w9XUIyAPKHQZMPhLFwb+j4b+cTGyrLuILoGORXbzarsAd6iOZnkMBIQIdkyD4rCwyLgy97
	ec5
X-Google-Smtp-Source: AGHT+IHmze5kshtpkjcVDTa3fEK5IBVKNtBZKjp0RsV9bU4OnWjNfFA7pSzx83Z/cbIj8bRK8EXOYxNjbrN+FqGjSUM=
X-Received: by 2002:a05:622a:198b:b0:4b5:e807:75bc with SMTP id
 d75a77b69052e-4c07623261amr138764581cf.80.1758496057664; Sun, 21 Sep 2025
 16:07:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250917025019.1585041-1-jasonmiu@google.com> <20250917113609.GB1086830@nvidia.com>
 <aNB7fTesaVCXHB0E@casper.infradead.org>
In-Reply-To: <aNB7fTesaVCXHB0E@casper.infradead.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Sun, 21 Sep 2025 19:07:01 -0400
X-Gm-Features: AS18NWARkb_6dtXKYB99s3afrmUWcnRiCwC7xnI9uhoqJ6HmAQbNH9XqJVlHJgw
Message-ID: <CA+CK2bDBU4Bb83tUyzdiTa+kjhKK7fvObzpqH1gOPwKqoOnO8Q@mail.gmail.com>
Subject: Re: [RFC v1 0/4] Make KHO Stateless
To: Matthew Wilcox <willy@infradead.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Jason Miu <jasonmiu@google.com>, 
	Alexander Graf <graf@amazon.com>, Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Changyuan Lyu <changyuanl@google.com>, David Matlack <dmatlack@google.com>, 
	David Rientjes <rientjes@google.com>, Joel Granados <joel.granados@kernel.org>, 
	Marcos Paulo de Souza <mpdesouza@suse.com>, Mario Limonciello <mario.limonciello@amd.com>, 
	Mike Rapoport <rppt@kernel.org>, Petr Mladek <pmladek@suse.com>, 
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Steven Chen <chenste@linux.microsoft.com>, 
	Yan Zhao <yan.y.zhao@intel.com>, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 6ytn9cxxkyyxfijb3aw6mkemrkrnm5gb
X-Rspam-User: 
X-Rspamd-Queue-Id: 9B0BB180002
X-Rspamd-Server: rspam04
X-HE-Tag: 1758496058-149743
X-HE-Meta: U2FsdGVkX19n52uW4HRvThtD6WQU1iWJHZrG1uHC5x6/UoSNLreE6WDGL+exmVJ0YKqyXnNKk4t/FET49Sz11mFybEihhyd+ISYzGxl0g7oHcIRdkMsCvH62b2JKM9uf5OJamyIIky+crF3Igfh7cDmZVf4azzGoO2sfRebipY0QBagUK0CIaDYTwOML8iRyRkMOZQg/63Q8wc990bkfQWUfdxg0p2e304j1GorVnGO/ieWcXq/toNzetOx1vcsBE8D1e8usYrmlZ2idQDD5k7qCC4xZMcFWKEszsUP+IOeM1X2bOMOczwdMMvaNBomiUAC4rEQQakx9P4x8f1BWvDNBsHs1fYq4mp5pEqNKNE1MTYuWdADO4EPgWdoZpJwAE+XQIECwXhNXDATWc5EvCQ5tYQWqWIuLc0bHveSyRYlVUGRsQQYyCrZETOhtWKTqXK9dTz3Ai2nS5wz8OuHnorLrYEpsrsfRwAD9X0VkfrvHiiNVTKIu8m0RCu5M7YbeOlGWayGZQW4fA8D7pjBEHtFLvsRw/iSzAJcalKvJtezirbX2a3BUkdQGzNZwt9711YjNml/ht4C06MNFtrdRkY+zYe2/0suQVKGP9SlO9HBi1+oVIbwLewdvUs7cvHh7pvp68pyP7HXgR1FfepXt/DKPbRXyyLZUPRISjDbUP/5O3NIZGr3n+zANl6t43CiVd1LINw/sQyjFtQSv6LvrMBGqzX1zwSkwHgBzIEcG8er2KcNKlVLYGe6dTq0vFGhtOrOYPhTNdu94XW1W6C/RzI9IervHWzFqLWqIEgNjZ79GdBxmo1K2oya6N6BDiZv8taPiUtVBqfmCmJoVBG37ZMO4wzAqhlLNObaD7fiif4cwsbcBtDi2bvkpnSC6j68Zfn6/4i99N/CFC6gNHbM4fOduD4jtqmRy5+eWTtdkbUrOxz1OFuUpXR0K0dEbpVy4GqEjEM6rE5S2oI0RLDu
 1gW8wNiF
 j0fKZ1zyjvEUPBGP64t25uild1mk5RtN1HIoyzqgY9u3ebKlBJNz2c56U8kiBT1iuguRYiY4mhrntzIlHgXPWevUds4MsoIx/K2sMk7Wixn6TDJHT6x6ETlZ8uzKh55K0GHrqZvGtkQkKO9/ENTisCMD7UFvqc4OkQgNNuBobsyIgzdv7qqwVFqwhqedaRMmeiK+D5/TfhYx5jf6QeBW17okiRw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Sep 21, 2025 at 6:26=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Sep 17, 2025 at 08:36:09AM -0300, Jason Gunthorpe wrote:
> > On Tue, Sep 16, 2025 at 07:50:15PM -0700, Jason Miu wrote:
> > > This series transitions KHO from an xarray-based metadata tracking
> > > system with serialization to using page table like data structures
> > > that can be passed directly to the next kernel.
> > >
> > > The key motivations for this change are to:
> > > - Eliminate the need for data serialization before kexec.
> > > - Remove the former KHO state machine by deprecating the finalize
> > >   and abort states.
> > > - Pass preservation metadata more directly to the next kernel via the=
 FDT.
> > >
> > > The new approach uses a per-order page table structure (kho_order_tab=
le,
> > > kho_page_table, kho_bitmap_table) to mark preserved pages. The physic=
al
> > > address of the root `kho_order_table` is passed in the FDT, allowing =
the
> > > next kernel to reconstruct the preserved memory map.
> >
> > It is not a "page table" structure, it is just a radix tree with bits
> > as the leaf.
>
> Sounds like the IDA data structure.  Maybe that API needs to be enhanced
> for this use case, but surely using the same data structure would be a
> good thing?

Normally, I would agree, but in this case, this has to be a simple
data structure that, in the long run, is going to be stable between
different kernel versions: the old and the next kernel must understand
it. Therefore, relying on any external data structure would require
the maintainers and other developers to be aware of this rather
unusual kernel requirement. So, I think it is much better to keep this
implementation private to KHO, whose only responsibility is reliably
passing memory pages from the old kernel to the next kernel.

