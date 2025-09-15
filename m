Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D68DCAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 18:03:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 922978E0005; Mon, 15 Sep 2025 14:03:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FA398E0001; Mon, 15 Sep 2025 14:03:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 810768E0005; Mon, 15 Sep 2025 14:03:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 704928E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 14:03:16 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F392EBAA8F
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:03:15 +0000 (UTC)
X-FDA: 83892256350.11.AB3CB90
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13533140014
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:03:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b6gQHAwN;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757959394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=95JKLG4VxpoRRKdB6YDz5z9F+dIRiRX8Vh+WVp1fuog=;
	b=Zw+HarX+Y9J2ySFj5lgl+Aao6u1dcyxTqoEMmfAg5ajbTv7alFVkqFf+TicX36s/OoTJTK
	uIRbVOhecJioz8Iv/iZzkVGRZSC0wmhJap6LpL/102+G/r8Kw5Dz8RT6Ay5W0XluDl2gFq
	p9VFtPGtxUmim7rl5KqS5gdmJ3ExwTw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757959394; a=rsa-sha256;
	cv=none;
	b=gDRco6LpwHfIgRIo5PIkpgye1STriMHDJv9rBcLag22UUlAtOrdMhrZ2YIhm0H7ugQ0srU
	6Ux1Gcn/+0Pf/dGzLXJcuhLUHUGzA+YSCc6GBLIH6jEO/l+YR8wJ2cUGsb6ukYjkcuZnVL
	DKfZRdulUdruNwhpbVkkz5B1m450vMI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=b6gQHAwN;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2BCC7601F3
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:03:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBD08C4CEF7
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 18:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757959392;
	bh=95ccvwynTPPBJ3VSneLqZ1zP/VaVb+UaV3d2KQZYJkQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=b6gQHAwNSHIM0m1optIKYBL3uLR1WmN984EcPGAyGqBs2pGtAsY++vKO03EZkFIwV
	 +tRMRu5ftNCsop4lkHoIxHLopYpvorUXj/i0l1Q0NLY8RVi0PxAvrmS6Ubc1tYJbQ5
	 dGRJysVxxfW8HtC2AgEEkXlEPB7dhWgScZezzJWvV1M+62hGmJ5PW1oT6877zcFZ4M
	 8VipDL+Z3vuvQOsA0EPPdWRsBW8M6ME4wekPiGZ+8upRDpollWrgHgJyNwKyDS6rF2
	 9X++AR7AI9cFawDF4VpooBVn/NrPr3dWNXN0g0mAFEtWBfcxPsCkxdEtyZhL9psuAJ
	 FXRPzbT8IjBMw==
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-60170e15cf6so3013809d50.0
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 11:03:12 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU/gEK8gLyLTSASOK2Mpq2K/MFYib0RL0Z36DGr8r7qUmrre581H3zHW8EzcPD4u1lc8sa3LTDShQ==@kvack.org
X-Gm-Message-State: AOJu0YzFaUPwe/qBygY+DwsLHGkasYnOxAaX0THgmhE1aJyvtvZGJz4c
	GTFG96k6zW9/bOS+HN2SqNzULI274qCCuQj8rLShmykHL4nU9vzxl2Gok69AfDK6y4XVc9ySvm0
	WYrAKRslXI8okHzcSDm8k3bJmcesLUW3BPgBhQPIUZw==
X-Google-Smtp-Source: AGHT+IGznbxlru4z1wgEjBBcYPzKTJKderdVTriUrpm7drfmb1ZVpveUFgHxH+0dDwR+fAkdCmzAq4G/cfPwxyeMIDE=
X-Received: by 2002:a05:690c:3388:b0:729:46de:38bf with SMTP id
 00721157ae682-73064febdc6mr119361847b3.29.1757959392031; Mon, 15 Sep 2025
 11:03:12 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-15-ryncsn@gmail.com> <20250915150719.3446727-1-clm@meta.com>
 <CAMgjq7A1hqQ+yboCtT+JF=5Tfijph2s4ooSqNwnexQ9kwJOCtA@mail.gmail.com>
 <6466a351-4c3a-4a02-b76f-8785daf36c0b@meta.com> <CACePvbUWGNq=TW2aP2zvcp9=Xt86hBPi3Ga1SLqjeZcyaKApoQ@mail.gmail.com>
In-Reply-To: <CACePvbUWGNq=TW2aP2zvcp9=Xt86hBPi3Ga1SLqjeZcyaKApoQ@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 15 Sep 2025 11:03:01 -0700
X-Gmail-Original-Message-ID: <CACePvbWiGZEuR1xHorjS2mXE-=Z4ZfpR8U_1jSMGMBe8PFnU_g@mail.gmail.com>
X-Gm-Features: Ac12FXzKV5l_rqhgwUM_R0cj5e126WLF3vMosZkwhTpDsrGF8h_VyiI2EGR56GM
Message-ID: <CACePvbWiGZEuR1xHorjS2mXE-=Z4ZfpR8U_1jSMGMBe8PFnU_g@mail.gmail.com>
Subject: Re: [PATCH v3 14/15] mm, swap: implement dynamic allocation of swap table
To: Chris Mason <clm@meta.com>
Cc: Kairui Song <ryncsn@gmail.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Nhat Pham <nphamcs@gmail.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@redhat.com>, 
	Yosry Ahmed <yosryahmed@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Zi Yan <ziy@nvidia.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 13533140014
X-Stat-Signature: xzgpjt14c8e4ymayqx4my57sco6gpgpn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757959393-976813
X-HE-Meta: U2FsdGVkX18Jd0KZ4fViRqs+yihyrB9XRnnSr1KiiuxDcfZLJKBkh34EEIKwRViszAXxpgqSTQhxpvnI0AmyAXNRDhyX6HOo+1oyOhJ6ZkTGHmqMeHsjgbmvMnZi0IQ18PByyAnAl9UKZPaQLPRPGXn55Jm/CqleFInn1oOC+WjWR87GWHoJZw5wHnEXnuip0/g+XGoAVgDNoCMCOBP0GWDZ4vfz9protA+ScnWqT7ZpbKEih05VennzqLYHTqMbmQFnggr+r2wH+LiLwD8kHSlI9XH3SHqj3SwoTyAlN+HpaB9uMYAfrqApVwt6Woy861UEoWKjhyg+rlOr0+TRgk3A9RERX+Y8lFNZq+9kWOV2758azrE6eA5wZrHbShiJ/48CdNRTWDu+PK6lBmkS7VJ5h6wz3UpvjZ06rHaV/wW4u91FlOPjOoZLizqSQYXuf8QAZCTPVXb2oWxbb2DcaqA7TyY/t5R/UoraIM3PKxrW2twSh4J/6gQBPg0Y4NsLruhfYafUNGf1hIl+e+qPXBHTFTGQk27VgP8wEOGCKIa5nC6coRoita0GZo5b9MHGhDZw7CTirlmTXF/j6mRUum3WFOSftJiGpfaTmibRNYSPqhu5D67xV2axrg6whet4JA2qSxE9lUx7iLivXDDt1nv0Aaa8++GGZjJHm1XRVxyvfmdOMYz7YHzKE0MyTPdpzwBU56yo7cKbV9AFK+HfNUbKn3LuBKRuDhUdSZYWSR8V89SGr5a6jNzdXlEQ4fEszm+060qCm/TwS0eRsnA2wiWwgd1QEQ2VAbDXHNdIS8Wuqrh++qcUO9SYNK55d2GrUjuIr1wQ3X1roO79IDJeYZgpcAtyJm0/eBqteVCXENplshKy5PlrjbMpUIHQIjp4Lj9xMW8QJcQ5GYD3PoooAiVS5JVWQAlGdqRnhtE2YnNjlrE0E8wc8vQcalQ6scp3gePABy6XRJc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 10:14=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> On Mon, Sep 15, 2025 at 10:00=E2=80=AFAM Chris Mason <clm@meta.com> wrote=
:
> >
> >
> >
> > On 9/15/25 12:24 PM, Kairui Song wrote:
> > > On Mon, Sep 15, 2025 at 11:55=E2=80=AFPM Chris Mason <clm@meta.com> w=
rote:
> > >>
> > >> On Thu, 11 Sep 2025 00:08:32 +0800 Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > [ ... ]
> >              spin_lock(&si->global_cluster_lock);
> > >>> +     /*
> > >>> +      * Back to atomic context. First, check if we migrated to a n=
ew
> > >>> +      * CPU with a usable percpu cluster. If so, try using that in=
stead.
> > >>> +      * No need to check it for the spinning device, as swap is
> > >>> +      * serialized by the global lock on them.
> > >>> +      *
> > >>> +      * The is_usable check is a bit rough, but ensures order 0 su=
ccess.
> > >>> +      */
> > >>> +     offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> > >>> +     if ((si->flags & SWP_SOLIDSTATE) && offset) {
> > >>> +             pcp_ci =3D swap_cluster_lock(si, offset);
> > >>> +             if (cluster_is_usable(pcp_ci, order) &&
> > >>> +                 pcp_ci->count < SWAPFILE_CLUSTER) {
> > >>> +                     ci =3D pcp_ci;
> > >>                        ^^^^^^^^^^^^^
> > >> ci came from the caller, and in the case of isolate_lock_cluster() t=
hey
> > >> had just removed it from a list.  We overwrite ci and return somethi=
ng
> > >> different.
> > >
> > > Yes, that's expected. See the comment above. We have just dropped
> > > local lock so it's possible that we migrated to another CPU which has
> > > its own percpu cache ci (percpu_swap_cluster.offset).
> > >
> > > To avoid fragmentation, drop the isolated ci and use the percpu ci
> > > instead. But you are right that I need to add the ci back to the list=
,
> > > or it will be leaked. Thanks!
> >
> > Yeah, the comment helped a lot (thank you).  It was just the leak I was
> > worried about ;)
>
> As Kairui said, that is not a leak, it is the intended behavior. It
> rotates the listhead when fetching the ci from the list to avoid
> repeatedly trying some fragment cluster which has a very low success
> rate. Otherwise it can stall on the same fragmented list. It does look
> odd at the first glance. That is the best we can do so far without
> introducing a lot of repeating rotation logic to the caller. If you
> find other ways to improve the reading without performance penalty and
> make code simpler, feel free to make suggestions or even patches.

Sorry I take back what I just said. There might be a real leak as you
point out. My bad.

Chris

