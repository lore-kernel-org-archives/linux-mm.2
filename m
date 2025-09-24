Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6C0CCAC5AE
	for <linux-mm@archiver.kernel.org>; Wed, 24 Sep 2025 16:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DDA38E0006; Wed, 24 Sep 2025 12:45:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5218E0001; Wed, 24 Sep 2025 12:45:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F33948E0006; Wed, 24 Sep 2025 12:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E1EA58E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 12:45:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 701D3160930
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:45:45 +0000 (UTC)
X-FDA: 83924720250.06.AA24071
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf28.hostedemail.com (Postfix) with ESMTP id B3298C0015
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 16:45:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kOe+xLCN;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758732343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2NbKIXLQaJkhfupbqHT3GZbQaEaU8HZXwa5u3cYRWjQ=;
	b=f6cBVbn9b2vqUfpy0Z3fW3cUzfPKgXrLW8dJkYSzNkCT/ILPsG5/NPRG8CpyknKaLfu55u
	yXlzeQc1/b9CsQ1hy0h4ol4pp8DmtJwPSuY7SyHWvfqKnGHnLf60iALz9iBVnB8CPoyuie
	dTKB4SwmUjWesNBCyhW8PPLJvSYPHw4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758732343; a=rsa-sha256;
	cv=none;
	b=laYOz+TnVOqBD5YOMuuKG/JuS+4EfgLvIL2DtdZR9zI6HFqPnVP4zRHZcSt7drDZ8egcA4
	4VkYvcQSRCAmGfMVfQs2YKW40guKlq9+NU+rZ5McLABFVLAaeXNjWVQ9n1ZWGxDyEcV+Ng
	mSdlLsDBRILtDLqgYBeCCMs6eXGxGj4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=kOe+xLCN;
	spf=pass (imf28.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-4bb7209ec97so609871cf.1
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 09:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758732343; x=1759337143; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2NbKIXLQaJkhfupbqHT3GZbQaEaU8HZXwa5u3cYRWjQ=;
        b=kOe+xLCN+5iAxiJsasrYGzQIOHLP2GHTzKifsKZlqWeD3dM/yqT57ChbOHNbd/NnNh
         jjPpKVGP8mX+zz3myAddX8YnedJxm573OGOjy4AD1d2EgdBgz8Bkx1G+5M2pRrwR9CWy
         0gaLUHcCtnbhPRCZU4QNCz68QNscRCQ+gVCU143KU3RqvFJEVonmja+J2wwP2eeqiMMh
         +zk/Bs9sn7RtYthPeOMvbsctYddvyRCrXiiuqEw5XRFsD8/mnxJXxxEDyJj+tMwliW+Y
         98OzgOGMh+DYRp8ftzFDsymplW3ku4pBfpwRtCTDc+mfAtyucqILs4aDFvBVunCVfKLS
         /9Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758732343; x=1759337143;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2NbKIXLQaJkhfupbqHT3GZbQaEaU8HZXwa5u3cYRWjQ=;
        b=Guy+umXsjF2lWHZzEVzDm7rB79l8kwQAtNNSO4JX/nUDIybjzny/1oXlTPOoTYTWeS
         v+Ycv408fUMdAlso1/9PPHIljxTVXXcM5uupSlPRfTfkHnz0I94fc9a36Y4/6QsynaCs
         fO5McZEbBysBawh1/2L/+338ZhQOJ2xWxax+RAn+9Oiih3op3oHGEzKBH01RhIiNwqZl
         YMPhPDAPHKJkmg/A1y1NOQJLRMKOVRs4oCznxfMlEUnUcX+GVUyAjgx0McqWELaSwHxO
         uCZ3Jqn7wr3kWJM099I275GBq3tjOubwWvdHKrITflm8ink1kePvcbSKaXFntlIMpPv9
         LCsw==
X-Forwarded-Encrypted: i=1; AJvYcCUKHVxTQQ0domSLBa2JgI6kdukMwfKwfGKGvF2O0n3ca4TT50dcbcTyanch2X7Xw0pmHsdOcF+v8Q==@kvack.org
X-Gm-Message-State: AOJu0YwdJ2/cxeIMlcwmPL1eYCmLw2TgJkxb7kcrxTorGGosTULWtUqI
	+68PXHS3NHz4oke0aCchAcYH0yoF9kXxZxH/DyGK8PLyQIW02r6yuyx/4+nwrLD/rB71dcKgAsU
	BO7X/BchgScMMmi1ThO5Jdu79T5ExVmMW6X3MIXVj2wgWeJ0VHpKxem+NEuA=
X-Gm-Gg: ASbGncu5d2Ut1zYoRaLkGkucNbi2KBcLUD34k49p8WkNZNDnTekOOn3KuxSNIFx7OBQ
	seqlLRgKjVtA7AHIRHv/8DIe1kWmFxk8CLF+iH5YE0vGRQU0OUaU3OhUKgH+iFklY2pt2kLc/CC
	Rge6+zNVn8nMxh+dekTugFR43qB3J93xNtRejnpmiTkENAChvJKHkr4aMdDgPvWQQDG0xv6MxYN
	CwakTXw35BHpu/g3rpcRvx9AV6GdafVpV/zhgZ77w==
X-Google-Smtp-Source: AGHT+IHMK/7Jmo3+a/8PjZif3fRGH6pt4mJlS8BMbgu0AUDx1mKJTngjQ5eS55H6IRAztg0mIvw+Yxl0hJ0Zre0+U5I=
X-Received: by 2002:ac8:5996:0:b0:4b6:2d44:13c4 with SMTP id
 d75a77b69052e-4da2f12a974mr1006051cf.10.1758732342240; Wed, 24 Sep 2025
 09:45:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250923140058.2020023-1-david@redhat.com> <a751762a-b5ca-45c4-95c6-a5dc63231c66@arm.com>
In-Reply-To: <a751762a-b5ca-45c4-95c6-a5dc63231c66@arm.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Wed, 24 Sep 2025 09:45:29 -0700
X-Gm-Features: AS18NWBwzrq-zY6ivMWYO7CaFt8uN8gFAYHGvHUINDY5-S9aS3DyF-WLjrhJmBY
Message-ID: <CAJuCfpHrMkKQb1=V_yw+6QP9aQvPpjxnqAE5K4VmqS8-aQ4cdA@mail.gmail.com>
Subject: Re: [PATCH v1] mm: convert folio_page() back to a macro
To: Dev Jain <dev.jain@arm.com>
Cc: David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 1fdwfyqt758d5dryi8wqrxpz5fkm1gdf
X-Rspam-User: 
X-Rspamd-Queue-Id: B3298C0015
X-Rspamd-Server: rspam10
X-HE-Tag: 1758732343-351362
X-HE-Meta: U2FsdGVkX1/urkP9YYepHLuPh6wr1q22nfkjYGvaTN+RebUURFmZpiL+9S4dBloPX23TtRYD28xr0vf/ajtwNUSWF6MJr69NSVgUfTRaTxUuO/pdSxeyx4NTZ2WXoLP1WopgTnXuc1r5orFlYIHpTbSBth1pETnBE/74PgCsFyC6Amf2JzoNZWPQJO/j7LtnZJoPPWEsVEApQQRc/DRpdXr6ooCgj3JF+PKYs1vTmtEQ9yYocmHPTnzic8iIgFX2BwUFVkTId3dwxHhLmAalpAp9R90KFUiZGqLC8OBg0Nv4e0rDriCXLSfEbzJFlv1Yi9lAeHgD5rS2ZpVwsp3Rw4wrDHYvf6h0U4mWqEU6CPZCJ5wB9800nkgVCoIXWW2//lkM9eFR4S1byUdyqACjniIQP3ouQw+qHtO4ifzUHLAU2YJh1FwwLm/x5+g+5p8AMziPPrIJjOWekfCewBIIBgNrZu/ion41HJbLg7F6J05yXbe+bbOeZExLQJJZSggzJw9xqJ5cqmugB656rC09jV7oQVfdtYFqX9r39vrloc+k7nmBnlLTpYQ3f/ETuwan8wF81C2wt+6zPntRtcoVxeU32PyOQnjm9g6ZDCXO0qVHkpPSssIIRy4NNSiWowlcw/X2QutIOh8+aOIEhVYVMA0fNDOLW844ace+JGhsLKbnS4mDIsc6tOTMtedokmQgaz3mF1L2qrgRc9b0p8voM4hxWU2WUzwfnsshSU8K1erHMna3UZVOeLye8X9GqvStjt8poA4G3h08Quz8bMezOpqqt/YNpCuboS1kwuHQa8SBanqMVGglxJJa5cGdzi1Bq1o8ruVBqktHA0Lx76Lm8SeRTiyD5bm5I+cyuZ5tw8VqCRp2/GXjVTut/YrjKbzJMCGI9eLXq/KNYGbVfxUfrfa5PMCmnS6P1vOT9p6wZPt4l8PTjqKB+XYNiQ0qlwUVE3LclVGQgnk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 24, 2025 at 1:57=E2=80=AFAM Dev Jain <dev.jain@arm.com> wrote:
>
>
> On 23/09/25 7:30 pm, David Hildenbrand wrote:
> > In commit 73b3294b1152 ("mm: simplify folio_page() and folio_page_idx()=
")
> > we converted folio_page() into a static inline function. However
> > briefly afterwards in commit a847b17009ec ("mm: constify highmem relate=
d
> > functions for improved const-correctness") we had to add some nasty
> > const-away casting to make the compiler happy when checking const
> > correctness.
> >
> > So let's just convert it back to a simple macro so the compiler can
> > check const correctness properly. There is the alternative of
> > using a _Generic() similar to page_folio(), but there is not a lot of
> > benefit compared to just using a simple macro.
> >
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@suse.cz>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Signed-off-by: David Hildenbrand <david@redhat.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> > ---
>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
>

