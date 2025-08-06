Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4455C87FD1
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 00:31:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14BAF6B0092; Tue,  5 Aug 2025 20:31:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 123D96B0096; Tue,  5 Aug 2025 20:31:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0129F8E0006; Tue,  5 Aug 2025 20:31:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E51228E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 20:31:13 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 51D50B7EC8
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:31:13 +0000 (UTC)
X-FDA: 83744453226.04.CC9BA88
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7750EA0003
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:31:11 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RdHt3nra;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754440271; a=rsa-sha256;
	cv=none;
	b=uQGxfsFXpcqMdf5YXK7gBz7PM15TfdfGQE24Q4iN+bK3++HZl59vpaCUziRHG/lFQywIGW
	3UFMZqbf3Jrk7xKYyNKAxyqC7Zlfagys7wRVGGNWbccIhE/uhZqL1wVopNy/CUDYuvGW5C
	OEeF8iGivQ1aFBoD0c0Twkd/N32rH0Y=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=RdHt3nra;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754440271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PQW7x8/sT2XH71D/EzxgimmlARKGdp6ktv+T4TBKp/I=;
	b=tUBo3ECBTqphZr9+JE6m4KX5X37GPHKqR660CZLEtPzzapDfQPvumbkf1w/mIGEOGuOWWK
	0QNQNhs6vimunGJryqMlnI06LoCQj5kOKgtuegnqp6TA2KGg5sk/hErN6n60NN8dGmIsHV
	pSyRggqQOEaDZidfdDwbLPKWAL08hsw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B2228601F5
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:31:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63C33C4AF0B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 00:31:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754440270;
	bh=NdVW8GEHxRFur7BG7bwD8zjVH3GXuWbAKImo+tKETyc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=RdHt3nra0caLUfJ/Dg8MBBmTWuy9ILtKqZvwlQzadX0efVxPHSjxPX++aHiVcfsNw
	 v7E0npHz6lS3xDn+eRZHdz09Ryok031/aoQjq010VIsCQzTRvlpAIVyvuCJ6sAaCuW
	 NK3mHMRn+DnNZ3Ht7v9sUtPSbLunL44dBNyFHCDN7ARjBBikH5yOsLm+crVwTf/Ve2
	 y1Sf/n1eQlRSq/ok9P9Dn83PDfCaJZRQY3uP2/Se9v6Xf5CD/SjC42NyJyMKmXgOuv
	 gu0BSaQavShnfonE5onSMy6dUoJYVUAtZaY90IIeCqM0XWNpqPygD+x7FN1OZ7Dcrf
	 fqJPu5T/+Ad8w==
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-458bf57a4e7so16955e9.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 17:31:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWUxVH4TRdjqFQ2Jcbv0c8e5teQNO9dx339omSZZb24tLhMm33vqSfPUCOm7Wu8MsN9/hvrPQ1cUw==@kvack.org
X-Gm-Message-State: AOJu0YyX2OFDtVCdDe0CZOjyZlM8yvPSlveOjckxxmYPSXjIDOBEZmIB
	BB5rSAoFmvxvIhiGVEqfAyA18rsmQn5Bi7/wew+E1gZci8ZIP1SznyjiCaXLNs7vrxsz/Z3o4MC
	vs5k7fDN5ozKj0WBWXVLOg31s5c0eXSjVySaC2i2V
X-Google-Smtp-Source: AGHT+IFdNhN5Gwax9QOBme7ZeWIPzBmP0VCTW8jj4gPJTs+CB/Aq8Lj1enCzcQdPRvQ2uGvSsfhLA9AxQScdbXBhpFI=
X-Received: by 2002:a05:600c:8885:b0:439:8f59:2c56 with SMTP id
 5b1f17b1804b1-459e6be6779mr427105e9.2.1754440268999; Tue, 05 Aug 2025
 17:31:08 -0700 (PDT)
MIME-Version: 1.0
References: <20250804172439.2331-1-ryncsn@gmail.com> <20250804172439.2331-3-ryncsn@gmail.com>
 <CAKEwX=PkJdz3Um9j4m2bPahN9NbQpn7QnOvEAxDdWUHTqSvchg@mail.gmail.com>
In-Reply-To: <CAKEwX=PkJdz3Um9j4m2bPahN9NbQpn7QnOvEAxDdWUHTqSvchg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Tue, 5 Aug 2025 17:30:57 -0700
X-Gmail-Original-Message-ID: <CAF8kJuObbE+X3WKiO_Nviya129jeAuSXv7tCJ=4tb9SLf1pD7g@mail.gmail.com>
X-Gm-Features: Ac12FXwPeth1NcHjzl03MctXY7Aq-5aHjZOS12oEzmEfEPunQW-fKexX_ir8Z2c
Message-ID: <CAF8kJuObbE+X3WKiO_Nviya129jeAuSXv7tCJ=4tb9SLf1pD7g@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm, swap: prefer nonfull over free clusters
To: Nhat Pham <nphamcs@gmail.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 7750EA0003
X-Stat-Signature: cfmqdshubnqpef858hheddbn5g5fo4ep
X-Rspam-User: 
X-HE-Tag: 1754440271-640419
X-HE-Meta: U2FsdGVkX186yLwLAn0geV6aV6FhGm8huTbyt//+XcKnw+0Sp+0SE03NQfXlqnfCutiwrRK2Uv5wWlIILTkqZYn7b4naczegn1cKwjsT+5WMz4jsFNUnIUm0NcxTlzsY2QwmE6rslkSX63L4Eo+tgnja6oTzGeKRIp2YvpGlkIoOi1VbLUiyrS5d5i0GqORjgnXpPHwzFnwRM8O5fzzacCd4FfP2V57w9D/WrQieW5X3dnM2KcL/DyU4Y6Aq319U3ERDsnPoLjz6DQxVKrCXPUF0TKh3shncFhFBWzXHRbdoheDP5TQTk5omERhBwXSZPxcb0JYRURFN+Yyso0uttZS6R4ogEht3OrPdKU5LZBgSgvkijg39AXfkCOjRC79VPvpYlkXp+3OMQo3YY/NiIN+EIlyE+JGSvou+qCdICtpU6+bDEpIo1kBeLQK8zrWoVoFnX6yUTo8hSnvWYL8mAkql+AUO7bJPOeu0vS4oBjccqSDVtY44mDq6U8JNJQtFsh0lX4bxRMOrThO9xTNhwz4ipSX+NflbsVbiEiCQ7k90bqNnGs+M6JseLsgvlp5twnRD/KVIGKNqiOC54LLbIdKETDI77840GjZByyH6KfzMwdfFUC7LTDSNK+6h0+XMJveeZuCjSMZ8ZMO2Un9SPUSP/jw+TjD3DrSXS1INICRmoe8a4J07UjDZmG0LpkrxvmqQRst4lWropnXHl6XfnRFH/5LQ3HSSIwTQNToZaOZzIAt9UIrzVR9Ypkg7X8iiUkka5AcRNnmle9H3juFBaMzOirfmBkwT+gYIvIZaMj69KtlZmPWB7FqCa7KSFyJcjS1erqgLXum7hZ7EWP3VgCtJ/DwHtbfMQOKFyQ/GxS3FRq7Kn8D56Q8ZVdbM3FheRFTrs2jf7Mk2PleDqmA5ZadnBym2PugB3uk5s0eBcqbI2AmBy05jWmGyaw615mcHw4FgYXLfHDNOg1qK9hM
 8uz+vURE
 QLVDGUSODLWksPVogHf8se+prI+LEYmvL0uoAAYUoPdfujPpMMJwZi01eN3RN5zMcwktIS9jPBjIzJKpapyl1JT0TAYGU+hxuaNomniBjQnID2WbEOVOOnNlYGxLCuahLEIkxJn5+7QqzbHejnTk5bri6ibxYxWFwBwjQM2thdAQrH1YTQF6dur8wOWCNCh4V1V6KiHp/XwsItu/0zLJwxBdYQJ2cE5Sw0IIBteDTBXuFztAjetd6FuU9VScTDWws7zCqggJ6D2N8LeC5AU8mhlpkkbNv+wpCteSBelWr+Dzf9WdWJSTZdS1wfg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 5:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote:
>

> >
> > +       if (!(si->flags & SWP_PAGE_DISCARD)) {
> > +               ci =3D isolate_lock_cluster(si, &si->free_clusters);
> > +               if (ci) {
> > +                       found =3D alloc_swap_scan_cluster(si, ci, clust=
er_offset(si, ci),
> > +                                                       order, usage);
> > +                       if (found)
> > +                               goto done;
> > +               }
> > +       }
>
> Seems like this pattern is repeated a couple of places -
> isolate_lock_cluster from one of the lists, and if successful, then
> try to allocate (alloc_swap_scan_cluster) from it.
>
> Might be refactorable in a future clean up patch.
>
Yes, agree. I noticed that as well. Incidentally I am writing a RFC
patch to clean it up when I saw your email coming in. Another reason
to clean it up is that, isolate_lock_cluster() must be paired with
relocate_cluster(), otherwise we have a dangling cluster not in the
list. We'd better pair the isolate() and relocate() in the same
function for better visibility.

Chris

