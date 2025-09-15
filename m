Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57807CAC592
	for <linux-mm@archiver.kernel.org>; Mon, 15 Sep 2025 17:14:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B99D88E0019; Mon, 15 Sep 2025 13:14:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B71278E0001; Mon, 15 Sep 2025 13:14:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AAE568E0019; Mon, 15 Sep 2025 13:14:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 98FAC8E0001
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 13:14:41 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 622151405E5
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:14:41 +0000 (UTC)
X-FDA: 83892133962.18.2C3AFD2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7F3A84000B
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:14:39 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tugri2f3;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757956479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g26MITPXysk6ICkT2lE+MoUF7XDI+TQnRGfKn/Jb8VI=;
	b=11wGfxpkBVOKWfI7XU9ZuoP2zVdhNGuxYg//8GN/7aOAAvVUUpc+k3TMVlvz/Jv1DsFnT+
	dkGtiZ+u1Xr95O5EJaLC0FFUfxlCs5BLTVSMKxID83BUwDv8ojGF/GelTHzUDKlqTW22HA
	xP0kwk0xycEPsBDZGi2V6JSZ5MxY2fk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757956479; a=rsa-sha256;
	cv=none;
	b=NTF7o7MvWAnoWRSHKzwtfFmuAL9kwCoqbuXPjv1wGVHBReUHKvae0zOtAccBS7iZ1DDu3R
	Si6fa8XTTSA1vQxn8MXliq+mSjIRTGU4IlOnDQ9EUg8FkbMOu2q0HrA7jQL7meTWlUCqKJ
	Mp2jpQfgI7DeYFU745jqlGVU/ZDG8mg=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tugri2f3;
	spf=pass (imf27.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BD9B66020C
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1DFC4CEFD
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 17:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757956478;
	bh=D8vghLD5aofkfZWm+QHf/Np3Id/lFsIZkhAuaHbgmWQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=tugri2f3kxqbUfFlU4YI+6/wjNNKm34ijZGfoaoKWksKKJHXEdpcigAIMzDlyeVx4
	 eqEbHXwppfjbelipqM2uL6uhSY7sm1VaOtsLvLylQzoC39vfWdZKhSYYVS7BlYhHQm
	 AeNG86Nb5teB8WF7b0OjJZEzWSwoho9EEPW5bkd+SnEGtN6l796LF8SbQg1WW7q/6q
	 tn4iVXkjfu713NeOZC+rGjjqpXYK9JpfiaZx0EXIlIaZbFUimdl2s+CKHmk60sPlZZ
	 ViulXB6HIrD12mrKRENL4snzmQJjW2kOgXRP+YBnaMx5kvYmYPYisEs6z62i0zanYN
	 pvuQlUDcbDm6g==
Received: by mail-yx1-f42.google.com with SMTP id 956f58d0204a3-6296f6ce5f1so1853499d50.3
        for <linux-mm@kvack.org>; Mon, 15 Sep 2025 10:14:38 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXf0fJnbi5pZLSxnWCIDqrAUL2wUhr2lb50wa7S8ldClkp9aegfZQsF9bkuXCwCxBUlceZG8J2hGg==@kvack.org
X-Gm-Message-State: AOJu0YwbQIpBNIrI5FXZV4iLMzpi0NnBOE/fCX3s8GKlokX2oa0/Nbcj
	eZeRaDonGgJjVUGxR0K+x57N2HJQArDAe2Szs4lD4ZpOFzPt+jfm8aKehmzWyrCcNUAQ7nB+WB9
	sQP04HA/rotOGeQRl634xABZNO8XBwGSp1hClw1ZoXQ==
X-Google-Smtp-Source: AGHT+IF4myrMUc66El4FGAdlIfJYMUaUupVH7LJ6OvKBZL7TB7Kw0evTg6GajF92fjSuFeSE2zB8FNEl1Xpe4O79P50=
X-Received: by 2002:a53:83d2:0:b0:624:628f:2979 with SMTP id
 956f58d0204a3-627229797b2mr9025390d50.17.1757956477693; Mon, 15 Sep 2025
 10:14:37 -0700 (PDT)
MIME-Version: 1.0
References: <20250910160833.3464-15-ryncsn@gmail.com> <20250915150719.3446727-1-clm@meta.com>
 <CAMgjq7A1hqQ+yboCtT+JF=5Tfijph2s4ooSqNwnexQ9kwJOCtA@mail.gmail.com> <6466a351-4c3a-4a02-b76f-8785daf36c0b@meta.com>
In-Reply-To: <6466a351-4c3a-4a02-b76f-8785daf36c0b@meta.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 15 Sep 2025 10:14:26 -0700
X-Gmail-Original-Message-ID: <CACePvbUWGNq=TW2aP2zvcp9=Xt86hBPi3Ga1SLqjeZcyaKApoQ@mail.gmail.com>
X-Gm-Features: Ac12FXzXaVaP_4Ed-c2dW6uD3tDhb2D5b92TY1d296kBGC73QKkhKMAR95GFcwE
Message-ID: <CACePvbUWGNq=TW2aP2zvcp9=Xt86hBPi3Ga1SLqjeZcyaKApoQ@mail.gmail.com>
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
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7F3A84000B
X-Stat-Signature: umh5hz8dcryyry884r7g5bmtt4o18ajd
X-Rspam-User: 
X-HE-Tag: 1757956479-661586
X-HE-Meta: U2FsdGVkX18sl5S3ETxrOBIgm/pJGzN/92RzfIQVw84Tjf7IklgEo0c+yOjqAW936UzAqwi4jCSy3670LUZxB6d3A3+G7rLOplGkaezYI+udA9KXzmjE9WII7NjOZS/DJItyO/mUrlw+lxvjUQ0C2uaAuDDLoUXVMyBdDosT0gO6+826zavzbiJSb6SSitB76bBo58w+oYfrnDn7w2ONomoxj/vyuAVPBuSj1Jo+eR+JXHoAJ8884fO+Fz8FPvctBOZ89AGgyp5lDdcUYE/bdoq1z4l7STh25YlridYS24P9jhXz3CtZmi+531QEJ7FAZgZg6JZMz6xCoB4UZcC9S6xST0MDmlXAsq6LclHBf8uteEVrYl68w54eu/xos2PBc3PDPA748/FJ0KDL9Ypwyauo9h7r+/C7qRQsgeAkI4OeNCRsDloQnsXOd4LDdQ/YhWq/QoZ6rm3aaGYQrxa7PcrbSW5L4NrVec3aAR+mlJ3yjZJfh+qU9HcteRUfITjApHkVYzCddsrVKiF0oASrx+bQ0cjdJLhj3VnHdUNPF5+y74n9hC4lWuUJC00njT93O4b1j6NJrd/IpzKsQFkSOxkMdPxVhwJ6uHAh+p2cv2JuG0g6ENYENv5enhCV9s1bipFBq6fi1pP9cClPQ2oRRauCOPb+vvigbDRDnwze+XYcmFt7wjLLU/bJavaxawpjcEd1jLXX4VzLkwqpv/2NwzCC7eWVsF4JZaRC7DN9QnvcyAt7L4sCl7vbeN/SUUac8mRRGiuEbisA52Q3FT8mJXJyYVJrchHmKpzJFwHWydRfBy4MlMoMo7OCSDkHSt1f62Q9Qfj7nT1njU8XPeQ1QXba9j4dYaCxafYfl08W6L1L7erejpaHzcGEleFgLHcALLEBPUxS15bW1qtMV2kqVT5ao01qiBNG3q0l3H7tzdKUPYMZEj9M/yIusgooTJBSgcaDl+lxWUHRPDExuWR
 5avpo0pS
 5f74JFS3pWMsShxLf2rPp74ppVNcQa0aiukjv+cxzyIsLbuvcOAmk1NgMqi0/fEk05RrqGz6phIrTQtUws4GYzk1SU8udsCy3vHUmElkONZc6Q/CDLvhKTC+EDfQ/25bVwjNOjEytpz9AQ3sfhUb1ZoqhDNtI/jZDUYpMP/S7R7b6GWrU2xJ3eiRkjKXxlFHS+/+XlhkqopDwXq0aEbT9xT7pZ1tbsE67JjgXxVOx43CCAcene6Z3dK8vpmFJr1IXAQMhkDXciLOoO6FiW0fzDnpxJrcHm8F0yBcaW56IEqDccoawObXev5NQLWifhqgGl1oL7GetAyvWeT3OVS1oau5IEtfvAqeRwDe1ymFnPf7u61JPWwEui90OhA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 15, 2025 at 10:00=E2=80=AFAM Chris Mason <clm@meta.com> wrote:
>
>
>
> On 9/15/25 12:24 PM, Kairui Song wrote:
> > On Mon, Sep 15, 2025 at 11:55=E2=80=AFPM Chris Mason <clm@meta.com> wro=
te:
> >>
> >> On Thu, 11 Sep 2025 00:08:32 +0800 Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> [ ... ]
>              spin_lock(&si->global_cluster_lock);
> >>> +     /*
> >>> +      * Back to atomic context. First, check if we migrated to a new
> >>> +      * CPU with a usable percpu cluster. If so, try using that inst=
ead.
> >>> +      * No need to check it for the spinning device, as swap is
> >>> +      * serialized by the global lock on them.
> >>> +      *
> >>> +      * The is_usable check is a bit rough, but ensures order 0 succ=
ess.
> >>> +      */
> >>> +     offset =3D this_cpu_read(percpu_swap_cluster.offset[order]);
> >>> +     if ((si->flags & SWP_SOLIDSTATE) && offset) {
> >>> +             pcp_ci =3D swap_cluster_lock(si, offset);
> >>> +             if (cluster_is_usable(pcp_ci, order) &&
> >>> +                 pcp_ci->count < SWAPFILE_CLUSTER) {
> >>> +                     ci =3D pcp_ci;
> >>                        ^^^^^^^^^^^^^
> >> ci came from the caller, and in the case of isolate_lock_cluster() the=
y
> >> had just removed it from a list.  We overwrite ci and return something
> >> different.
> >
> > Yes, that's expected. See the comment above. We have just dropped
> > local lock so it's possible that we migrated to another CPU which has
> > its own percpu cache ci (percpu_swap_cluster.offset).
> >
> > To avoid fragmentation, drop the isolated ci and use the percpu ci
> > instead. But you are right that I need to add the ci back to the list,
> > or it will be leaked. Thanks!
>
> Yeah, the comment helped a lot (thank you).  It was just the leak I was
> worried about ;)

As Kairui said, that is not a leak, it is the intended behavior. It
rotates the listhead when fetching the ci from the list to avoid
repeatedly trying some fragment cluster which has a very low success
rate. Otherwise it can stall on the same fragmented list. It does look
odd at the first glance. That is the best we can do so far without
introducing a lot of repeating rotation logic to the caller. If you
find other ways to improve the reading without performance penalty and
make code simpler, feel free to make suggestions or even patches.

Chris

