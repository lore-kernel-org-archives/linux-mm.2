Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E82CCF9F8
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 15:47:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6A068E005A; Mon,  3 Nov 2025 10:47:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A3A8E0057; Mon,  3 Nov 2025 10:47:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08728E005A; Mon,  3 Nov 2025 10:47:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BB90B8E0057
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 10:47:13 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 58DFA1394E9
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:47:13 +0000 (UTC)
X-FDA: 84069724746.05.ADBE34D
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id 799BF160004
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 15:47:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T8pquomC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762184831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P4jFr5lYY1kEAlyY3CIvv+GZPJTGU8I35dy0xtW0d6E=;
	b=ry6PfKyq5QKj94KV4oETHe0byJmmWhxtK6ym8crj8YpGpmWGmkjpa8CXbdK3sc37epJIDl
	Id0mOtPWe6+mZRdZna7AfHO50xrSfy/gg8HPquLaq7O9AereuLVgd++QeslLR/EJqQlfNX
	ZDY7DgikcuKP1IvvOGJn2oH2QmC+fm4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762184831; a=rsa-sha256;
	cv=none;
	b=45AocvJjKl+LtrblgGdtS1PJPdpetx6URfsSn3WB8TjxqLSqBH3AopdNKdVNUHZg0R2Shg
	3xUaqtGTw2e79fxikj6G85nmmcC7gDBmkUzzngN2FgfHFpkA8I8as0Gy8H9pyjNfy+8raV
	Kkbmg6SvPjI60zT6A/ymSIP2adzU5kQ=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=T8pquomC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of lokeshgidra@google.com designates 209.85.208.43 as permitted sender) smtp.mailfrom=lokeshgidra@google.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-640b1d0496aso9851a12.0
        for <linux-mm@kvack.org>; Mon, 03 Nov 2025 07:47:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762184830; x=1762789630; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=P4jFr5lYY1kEAlyY3CIvv+GZPJTGU8I35dy0xtW0d6E=;
        b=T8pquomCLOY1fA/Ms0wRxi4GmgNCf1/fPfE7iZvnPTWCv5tjc0sYBJTiZYWOizk3mB
         Qa8uvchE/ndLJknfBVqRBabqfeZVuKPMxHKts4cm2jSs4/8fAS8zTD4tZNs+MBLlV74q
         6ciA2GGxW9TExZo4ruzpW4XQZnh/m7Bbyi9yVjlsLeTIglFYi7x377LnIzPEChtkVBPo
         FZVuJHMDcDdEN8v97koM8w6F4ElHE7sjb13e9yA+/ZZXeYoGKZMWBNLcZpwgOLcbgVW4
         Cti8c5s11kKjyQ02ikOeJLX70K7rrcJo+LBLdF3Gyu9KGuV2KFjgXZ0uRZwa7Fpa/IC9
         0R/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762184830; x=1762789630;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=P4jFr5lYY1kEAlyY3CIvv+GZPJTGU8I35dy0xtW0d6E=;
        b=Q0LVyw6sbZYDyIIdSkL7kF4lK9kv4Si/YHCc3CmslO5xGw3frq9IZY257OREsaby41
         oSQLEDuXW+3u85kBVJU64w+emydRMo2GXjBHUeNQ6uUPajvfSUYiD3kJU5NpZ01/+mti
         9PW2oWZZzjqsK2+NpQN4NLoTHAA5A1ChPCs62VhTBWy1zVgMvLWlGs6hVzzjrJTi5eTF
         OKnstdgzKp3VJJ4AUBvgKaanBeB1zEGmxUB3+k3abze9LSAq1wfbBvIM/xbcy0uxJ1Tr
         kQoahlmsFuZlfPJcN4VY9FAkpCh+T+XAblRCvlTZdUylugoYOEfPp7rvlYeyVyFup2vI
         p9vA==
X-Forwarded-Encrypted: i=1; AJvYcCV7nT9jeoFcMPbC3YqongZ/NLwjz+0ANzNlYisPXvPhj2lvda0eW79t8jCuYB7Xdhu9hlBHYwYL5g==@kvack.org
X-Gm-Message-State: AOJu0Yyu260OHFa1eJTgjdkt+9fQCL2r8r8pjsi7Bkk9tmBTE6gt9LCv
	ywjlWJIQCyJfZA6Z4hI5hHe0Cc8+I4G3OjgR+ynKv2X90P+PKxNusdT2MA6ObppLoTJIBS+6u/5
	IcioqDcmTCqb/wOZpN3mRHk4Uvx5beBrigYQiNTV6
X-Gm-Gg: ASbGnctnkWk18KmBtAH5qYM/mZ6T+06RRpHgSnPa0MAlLT8JZeI5fmcdmHRoGrQOXg2
	Jz2aDivtru8Quc9WP1bW/aeNIlBaAA/D6K7N1lNEzLXnbrh4c/YtIwSR2PyW7ZhA3cAdgcIH3g4
	bDViSUvXXETgqzj6ZKKKEP4SB7n7ALUwMvv8yzXtv/dCuWZgi+aSg9RNWqA0AP8FAbrWiOlvBS/
	sX4TQjWmJVbMnIS5qW2kpC61G8NV2bWMHiS4ZPIONKMNqS5esfD9dyx9/B2Q8UZB8qyN1xs8dDg
	IdoBX6TbqdT6ZJhB7IEUR+fLbYLe
X-Google-Smtp-Source: AGHT+IHgXOH+wJYPPmVBJ6VUytMG7LHE7rUNpnfqshN8gNPMukuhiGMr1MsilwU7jXACtyKpozrDJlAndrup3nwFM7g=
X-Received: by 2002:a05:6402:208e:10b0:634:b4b5:896f with SMTP id
 4fb4d7f45d1cf-640e4239043mr4817a12.4.1762184829585; Mon, 03 Nov 2025 07:47:09
 -0800 (PST)
MIME-Version: 1.0
References: <20250918055135.2881413-1-lokeshgidra@google.com>
 <20250918055135.2881413-2-lokeshgidra@google.com> <0ea92729-2403-4de8-9ddc-a1c7bb2121c3@lucifer.local>
 <CA+EESO7yyhNH6TYza+j7h9JZb1_1eHdd1x3ASmuNga2yYng4JQ@mail.gmail.com> <ecfc09fb-cc4a-488a-bd0b-4f5b3af3a2ac@lucifer.local>
In-Reply-To: <ecfc09fb-cc4a-488a-bd0b-4f5b3af3a2ac@lucifer.local>
From: Lokesh Gidra <lokeshgidra@google.com>
Date: Mon, 3 Nov 2025 07:46:57 -0800
X-Gm-Features: AWmQ_bmkOeJxpmC3VysekC8ABX8A_m-pHxe2GveLTKnLW--vZ4netlLSfWD9W_w
Message-ID: <CA+EESO7F=x0vrrA+K7ajcSyH6tfEtsg9gHVnOZf8U+M7kqcgyw@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: always call rmap_walk() on locked folios
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, kaleshsingh@google.com, 
	ngeoffray@google.com, jannh@google.com, David Hildenbrand <david@redhat.com>, 
	Harry Yoo <harry.yoo@oracle.com>, Peter Xu <peterx@redhat.com>, 
	Suren Baghdasaryan <surenb@google.com>, Barry Song <baohua@kernel.org>, SeongJae Park <sj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: uf7r9qi33wzcyfp9ndwz63t5mm6z8jkg
X-Rspam-User: 
X-Rspamd-Queue-Id: 799BF160004
X-Rspamd-Server: rspam10
X-HE-Tag: 1762184831-519569
X-HE-Meta: U2FsdGVkX1868VilxRsIfYY/v5Cm24oGsebvrpWOuRpfjPpvR9jsnJrow/9+MpYF2Sa8Na8Om+Niy0SXstlJuRPItjMcD9IX4yiHHjfo/1wkpe2bKX072MvfPmAs40ftDf5fSQ6lXTjHDjtuldghQz3GdCXzJFd4fA77c+IIP2JyTRtpoIJ8j+PQMOvtXBdZs/Zmwt3prEY/RzOgeuzI1VgVKa2/GtWCIxXwyfB6sFCsKXnYQqcLtQa9yrNiuGIZ0hsymBUfrcFJDvb/surRMX9wKwnD1bHGhQQD+KMOTNzXoVBQWU2b9uaym4sQF3ARVykGbsxL2RypNG6hBeIDsT2G0afNNQxX0UnC9z8uTD7BBupYV6A0NPNwpuo9M58eaYgUqErg6aYktcxHaz0BwjzTvela3x31FLk6CC5j4GdYB7XnleYX+HQblhGIahOVs/H+YbYVjRJJjpQgN8W66/aQfE4kAMI5A96jTTyJfuUb9/9XgHFZZHM8x/2Q5QAHB0iAHAK3pYUENt8DmCdW8WDHQ1HTwfNwb5CeGWgZ9x5ePP0yKhI3fKqakiFNC7ElKkYWPBHvouAyWAFRNhvTO/k8QH3GsvdvNFCPODp5yHghYJX3kOAp29t/z/MRz09Cc7AG9unSZWhA7DpA8qauxsgbI7cQh5BzwdbM8JUDoBxPvSwxIukeEi7vzWMLML6UzFaodWvXR2xm40Z44N9P0k9KL0vnuW3FYuFWHjkUHQZ2wX5mg5r7jDISKqs2ZhnB4izICR+ytA+arGlSmSwHb6aIEoUzj/ZMKvdp5BRM/aI73KQstsF7M0yY5wdCVEjioCYH3Cbf/Gg+eoY9VOO5SGe4FDNJTpfTC1H+v8dKL4asTklzOXmquTSWx74174fnlAgO/DiOOeXjdulZ9aQzIgwIHJDBuTk+X3ohsXwE/0TEpFN7fre65zxkWyxYkPbzqe3omr3vMKM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 3, 2025 at 6:59=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Sep 18, 2025 at 10:45:21PM -0700, Lokesh Gidra wrote:
> > On Thu, Sep 18, 2025 at 4:57=E2=80=AFAM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Wed, Sep 17, 2025 at 10:51:34PM -0700, Lokesh Gidra wrote:
> > > > Guarantee that rmap_walk() is called on locked folios so that threa=
ds
> > > > changing folio->mapping and folio->index for non-KSM anon folios ca=
n
> > > > serialize on fine-grained folio lock rather than anon_vma lock. Oth=
er
> > > > folio types are already always locked before rmap_walk().
> > >
> > > Be good to explain why you're doing certain things, like adding the f=
olio
> > > lock to kill_procs_now().
> >
> > Agreed! I'll add in the next version.
>
> Hi Lokesh,
>
> I realise this was trivial, but it triggered me to hold off on further re=
view on
> the basis you'd send another version.
>
> Are you actually planning to do so? As it seems set to merge without me h=
aving
> completed my review.
>
Hi Lorenzo,

I think somehow the v2 fell under your radar. I think I addressed all
your comments in v2
(https://lore.kernel.org/all/20250923071019.775806-1-lokeshgidra@google.com=
/).
Please let me know if I missed anything.

> I'll try to get to reviewing the rest of this, I just happened to have a =
look
> and wondered why my tags weren't there...
>
I was actually wondering why you had not at all responded to v2 :) I
look forward to you reviewing it. It would be best to have your tags
on it.

Thanks, Lokesh

> You may as well hold off until I finish review anyway.
>
> Thanks, Lorenzo

