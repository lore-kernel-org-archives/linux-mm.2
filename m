Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB657CF64B1
	for <linux-mm@archiver.kernel.org>; Sat, 22 Nov 2025 08:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0C36B0008; Sat, 22 Nov 2025 03:50:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07A646B000A; Sat, 22 Nov 2025 03:50:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC5F6B000C; Sat, 22 Nov 2025 03:50:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D65D76B0008
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 03:50:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5E1EABB4D3
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:50:50 +0000 (UTC)
X-FDA: 84137622660.17.34C57B5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7FE97C000A
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:50:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZgWY1C1;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763801448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QoQw1JIuRrlurYe6pE57FziMq5YHi/5AuozAeq1c9rc=;
	b=Fz2pBAnjWncAaeJRp3cOeavZzO0iy//KlbG22xVhoHv6LXnR+F1MhnxwS1rrFY9y9HCCA/
	aV6S3NeODd8D6SuiXqZu4qn6Oql9dHorU7GAoGLtvxqfkD3gJyxNrUhjMpA+nrWPrfOZ4b
	uxIbfnMXk1Vv8+NEwGIDDzLwMMYIXog=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FZgWY1C1;
	spf=pass (imf10.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763801448; a=rsa-sha256;
	cv=none;
	b=CbF+edfh+8CjMEGvnV9auaNsOLZLfzbEIjYVaogHO0ozeaBANDPdvaXOEgnwFC55E9DOnz
	8AOV0K49GFCnpWTMmlzkJF28uTPJn1kL6APhuLS3tg2Oyu13npxoSc4wrOh0JqtMVWAEac
	WUVH8RWDy/mWyuvaaYYT2awBexsp45g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D772160180
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:50:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 771A4C4AF0B
	for <linux-mm@kvack.org>; Sat, 22 Nov 2025 08:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763801447;
	bh=AFQwbzMeOX1xJe41E7z6Op1y0RUau1XJaNf9YmM1yEM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FZgWY1C1svsxdIUknoU3/orm+gjiYl+ckfymAwh1FkBRFn9hP4VE4z6n1PcZC7oap
	 fxSUvgW8Jou7U56Djxz1wH8gCgcCIM8YbHrm64zVZTmUfz+s04m4W3EbHmoXdnebla
	 RRNWQA4RynTA91vdlEK/hc7az2StY4ZHc1dQL/twzG88dqvrv4HYgN31vX7Sm37906
	 gZHevQw9R2PPW3nqYDJINzXQ7xFlm1j4gWgyooltX6PqxVw0p2xTlDHVeMhVK49udB
	 zoD7uIJehCmVfm2OdEGR4lopAeHe7VKyJ/7NSGgkRnat2b5vTr+UwupVad5GTF8W4D
	 Zqx/s9HZvuy2Q==
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-63f996d4e1aso2885189d50.0
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 00:50:47 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUcq+ZdsXXr3DW+xcijLrnFazHgVNO9hY3tl18kUIabMBG61IOU0pbJBIHHl4zf+YHZIREeKKidcA==@kvack.org
X-Gm-Message-State: AOJu0YxMlJokWVYj4SPfthhVicqrb/yjC5/x4Goc1nNKBdLXifK86xDH
	JOw8zM1wC/RjPxjRKJt3lt8j843HEfk07gzJPlG6MQ4eEpYky1q4jbGNhvay+h/oc/jF7DAtQel
	bV8Al+JkfmPSKs6LPvoMdwDu5vkblfWFH77MJ3EAVmA==
X-Google-Smtp-Source: AGHT+IGN1+lzSCSZ/qw4DS8BV8a0sd9HVdHAmqlCsCYQFvwweaE6ZWrHVtoacgo7Aeh5nNu86jdz9hXBhNdonN1wz1c=
X-Received: by 2002:a05:690e:4283:20b0:63f:9b89:8893 with SMTP id
 956f58d0204a3-64302abfe17mr2928242d50.52.1763801446728; Sat, 22 Nov 2025
 00:50:46 -0800 (PST)
MIME-Version: 1.0
References: <20251117-swap-table-p2-v2-0-37730e6ea6d5@tencent.com>
 <20251117-swap-table-p2-v2-2-37730e6ea6d5@tencent.com> <CAGsJ_4y9sQd9x-kOqPZzaNPTtSOhFSYzFdjiRsJFjT2myYEK7w@mail.gmail.com>
 <CAMgjq7AKWEqzHtMFWcKPCxWtc7jE1j9qGOQ3izsxRef9FCd_+Q@mail.gmail.com>
In-Reply-To: <CAMgjq7AKWEqzHtMFWcKPCxWtc7jE1j9qGOQ3izsxRef9FCd_+Q@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 22 Nov 2025 00:50:35 -0800
X-Gmail-Original-Message-ID: <CACePvbXbx2bT3K4KZMAh3yLuC1p0j80DS3XJfPHChVkqNJkLmA@mail.gmail.com>
X-Gm-Features: AWmQ_bn-dSHsTSgpZdDbCsvlzAGsFyNaDNRZmggHTnrxDYTYdLnSQ6zOouVBGq0
Message-ID: <CACePvbXbx2bT3K4KZMAh3yLuC1p0j80DS3XJfPHChVkqNJkLmA@mail.gmail.com>
Subject: Re: [PATCH v2 02/19] mm, swap: split swap cache preparation loop into
 a standalone helper
To: Kairui Song <ryncsn@gmail.com>
Cc: Barry Song <21cnbao@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Youngjun Park <youngjun.park@lge.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 7FE97C000A
X-Stat-Signature: m7puwcwiowoij1hb68ojqfxn3kruspmq
X-Rspam-User: 
X-HE-Tag: 1763801448-749578
X-HE-Meta: U2FsdGVkX18vccNuhp72PmiP0rHipDazFLfv9EapU/1vzF4HTa7wzBgzzzF3baByVeRFrLMdXIOtqCuPNmZScOUdMaazEcQ9A8pRuPzHAzBvb2ZB509TCXLnfuc2mklIMmG9agTE4ZSw8BdS33NYX3xf8A4eEQUs/VyjhwxtyW5ZusVr55pjyLNCa/ulJ7XjwnG28A9Gl0XiEf21CCdDG3lvs3sD+Lw9IFIdMmojmb8pFq86fDD2hTPLeCmprEJvRj7ZFqpPH4DmpROjnm1MIYWV2Mn3TyACO3+In6pRhGCOstVbpccF6GkjEptgO4gQCArSBzXHcDE7t5Vos9G49STpZ4PYM7oZIofEs63r4lYdOGsDYVYGeU389lgTLVXht6qwgzuRuiBLxgRBwTnVGobrA/fW2BM28LC7P1fuln2Vrq51fhc1Zk5ecKKE/39UHAmNnsY2DUkYVARpYj3gkSpJuzYSNVOsMCalXwiH8QGyl80PLy5nccLLkU1wSXnq/8dJDbX3EvwQAjWjQytCLGnIUrbt6Akb9Ork2smegyfOf0xxxppDOyc8FEy1d0G+wjPSUlpMmmKuDgsoJ1HJMY7/G+oODgakfxHcUgfMF/2TIa+AygGbrwust0eLwAcE11gSCuqIQSrkNw5DuRu27MBP5NB0GohqB1pZwlHjtvS1owoPoUbAdZ1CGjygaY5SIASyYR8QIglk0V7hLA4rDGM7X2N5gr1VQTyP1hSeTMv79d44LomcN0zBVqTrQsWJVA4xPooQcCcCvCwspnUnl4rlXO7+xqKBu0WWFJ+qG/7FwO8l6A28ifqzHYnyCDu3ifOdE4qGprpr5487eGXadtkxq++lC4pYowQEZHeSRa9WV1Pz22xaWxyXD+DV/S6hWfUIWTwViVcLCuFOg/Rn1W8Cx68NFhWV2MAPOv1wIwlYPdDgle2WpsriOaRHqyg0s0E4/PCE/KVU4UrKlIo
 kPuOI/C1
 BbRNT87XdrXB1g1LdZnTmz0iGx6m71yHWtN1pFtU7FPOWWgwycv1ZXnYd8wAfsnDMT1aUHWINMr4GFuHYRin894TuKNEnWCIrq6nca63pt1evxDl0qPsWFJBbnbZ99WxlGi5kb4RIBIQA1f+VQFCls8llVeaZ/vSsjdUkDp+LKCXUXtcvjvaJIT/O2gkeFjTsPwNrPxIH9ZSVKN/h5x3NGhHs3wIdYYLR5uReVesSJsCb6KPJKfSAsayzInIvVNHmpgiMh7+rIIweM8qhNMCNpeW7+JoW6FgCrqS6cqCnsSlyym4VVdiNfWyexSzempOyTc4rwMy0WErlqZyyMZ0+NFdGnJqvmqQBOcPv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 2:04=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Mon, Nov 17, 2025 at 4:27=E2=80=AFPM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > On Mon, Nov 17, 2025 at 2:12=E2=80=AFAM Kairui Song <ryncsn@gmail.com> =
wrote:
> > >
> > > From: Kairui Song <kasong@tencent.com>
> > >
> > > To prepare for the removal of swap cache bypass swapin, introduce a n=
ew
> > > helper that accepts an allocated and charged fresh folio, prepares th=
e
> > > folio, the swap map, and then adds the folio to the swap cache.
> > >
> > > This doesn't change how swap cache works yet, we are still depending =
on
> > > the SWAP_HAS_CACHE in the swap map for synchronization. But all
> > > synchronization hacks are now all in this single helper.
> > >
> > > No feature change.
> > >
> > > Signed-off-by: Kairui Song <kasong@tencent.com>
> >
> > Overall,
> > Reviewed-by: Barry Song <baohua@kernel.org>
> > with a few minor nits.
> >
> > > ---
> > >  mm/swap_state.c | 197 +++++++++++++++++++++++++++++++---------------=
----------
> > >  1 file changed, 109 insertions(+), 88 deletions(-)
> > >
> > > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > > index 08252eaef32f..7b93704fcbe7 100644
> > > --- a/mm/swap_state.c
> > > +++ b/mm/swap_state.c
> > > @@ -402,6 +402,97 @@ void swap_update_readahead(struct folio *folio, =
struct vm_area_struct *vma,
> > >         }
> > >  }
> > >
> > > +/**
> > > + * __swap_cache_prepare_and_add - Prepare the folio and add it to sw=
ap cache.
> > > + * @entry: swap entry to be bound to the folio.
> > > + * @folio: folio to be added.
> > > + * @gfp: memory allocation flags for charge, can be 0 if @charged if=
 true.
> > > + * @charged: if the folio is already charged.
> > > + * @skip_if_exists: if the slot is in a cached state, return NULL.
> > > + *                  This is an old workaround that will be removed s=
hortly.
> > > + *
> > > + * Update the swap_map and add folio as swap cache, typically before=
 swapin.
> > > + * All swap slots covered by the folio must have a non-zero swap cou=
nt.
> > > + *
> > > + * Context: Caller must protect the swap device with reference count=
 or locks.
> > > + * Return: Returns the folio being added on success. Returns the exi=
sting
> > > + * folio if @entry is cached. Returns NULL if raced with swapin or s=
wapoff.
> >
> > Not a native speaker, but I wonder if adding *already* would make the
> > comment clearer, for example: "Returns the existing folio if @entry is
> > already cached."
>
> Agree, that sounds better, thanks!
>
> >
> > BTW, returning NULL may not be the best option. Returning an ERR_PTR
> > seems more specific?
>
> I also don't like the idea of returning NULL, but all existing callers
> are all using this convention already. To not introduce too much
> noise, this maybe better be cleaned up / changed after this series I
> think.

There is only one possible error condition to return NULL there, it is
fine to stay as NULL. The caller only cares about whether it has an
error or not rather than which error anyway. Not a big deal.

Acked-by: Chris Li <chrisl@kernel.org>

Chris

