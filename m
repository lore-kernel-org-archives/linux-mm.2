Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B1EDCA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 17:45:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 420F66B0011; Wed, 27 Aug 2025 13:45:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F7CC6B0012; Wed, 27 Aug 2025 13:45:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3343B6B0022; Wed, 27 Aug 2025 13:45:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2134C6B0011
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:45:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BABB9140765
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:45:06 +0000 (UTC)
X-FDA: 83823263412.02.4C82FC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id AF3DB180006
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:45:04 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5ue+xJU;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756316704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hhYib2aPpohMOLuJp+CW4mT/+LdYLOc6zODOGtufGDM=;
	b=nXa5k5npETfyKJ80dYtSCunwMTO53eI+V9UEiC7jFppMFvb4BINr9kq9WFqiMymmKmsfcF
	PXHyoJxhb5TD//pxS5jV45QO025QLlE0EMbzt1VGc/4qmWq7P1C729wJ2bKjIMfGApK1gE
	nz58jKDjYwwIr05Yi1NmsIoW2oTwqjc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M5ue+xJU;
	spf=pass (imf16.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756316704; a=rsa-sha256;
	cv=none;
	b=YQEFi5zWoMdwSzrGssGTletOV4u2m5eqhzc5uIy/gRSDRA0tSKYxpHn6dR/jd+NA4kvTW9
	sA9Gzgkb8wZJKYtrRKujfk+eewmN3hGuXdwTk5li5dMYmWVND0zFp21sXFDCY2cT+u1vPF
	lvDWjPypqPfjZa4lse4E/i3j0iwWmTs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8693344BD3
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173ACC113CF
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756316703;
	bh=VljAt2p7DCm9K1DJ9W5ibhxr8MfRLAstnSf6W0A2afY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=M5ue+xJURTG/EgdBNYWtP+ifnWp2Ed2MP+Ov2D2UuseEPEzh5hV7UIHH8kqqMu3+j
	 wDZXcQe1260d/nBipOgJtyJ5jhjPkwhiyXVT6HhL39Z155SVa8+054WMphWyXnB3bI
	 znly89wf+mFgf9ElB4up40Bm522fdV8Jg0LVYIc7pz1/PqfAst6U72D+k0jDovOcRH
	 32JQJdrX7/04ejpWNKbT+3WYPbK+i4t+fXxVecwRVvNkzafItb7tjwlO7uUn5d9Fcb
	 DMRb1WSdr8+Jd4QYMdSfIQ5eCyUCRV6Y5EpYY2hgOwuhfbaUVnDl35aFiCqxOtKcVR
	 MwgyVwKnuZyKQ==
Received: by mail-yb1-f170.google.com with SMTP id 3f1490d57ef6-e96e987fc92so14045276.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 10:45:03 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWiUHp/AnB1kb++TdwFve116n9YmQu5Bq5TKvrIqCiym5BoGvFC0QJE5Zm+JBnNiLg7mBsJiajtLg==@kvack.org
X-Gm-Message-State: AOJu0Yz58RYuRQPwVRN2ldSFSeXfUVSS6MelRGcSO+sNLo9xjQnl7rOS
	mkYqNYAL6vqr7VaKbbhm5SHYjRSr6Lv8pvc7CLpVo9CkxGiF1QMnoKTk9V52pqVrY7j/P23rlVO
	qu6S0hNuK1j2nlT5tPUCkzc6pncW/9iFKXsFW6oDZLw==
X-Google-Smtp-Source: AGHT+IH410Dh0xmyIvjcmTpUNdArM69ZBr6i/qkg9Xier1rDRpXe/jJcgUeuDZjb9l+R3aRee1wIqjnRi3hTBWoa+Qk=
X-Received: by 2002:a05:6902:1505:b0:e8c:b1d:22a7 with SMTP id
 3f1490d57ef6-e951c3c67a4mr21352497276.36.1756316702255; Wed, 27 Aug 2025
 10:45:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-5-ryncsn@gmail.com>
 <aK5/1so7a0i80+dz@MiWiFi-R3L-srv>
In-Reply-To: <aK5/1so7a0i80+dz@MiWiFi-R3L-srv>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 27 Aug 2025 10:44:50 -0700
X-Gmail-Original-Message-ID: <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
X-Gm-Features: Ac12FXxitBgRzLWlNc1poHTuU4JtqvULJx8hBNZ7d5PhlQeGIAkFrGOgwUutM1U
Message-ID: <CACePvbU8pnjWCiWcSXRr4UdpuD_wdtrouLMz_fNB_=KRrdHLmQ@mail.gmail.com>
Subject: Re: [PATCH 4/9] mm, swap: tidy up swap device and cluster info helpers
To: Baoquan He <bhe@redhat.com>
Cc: Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: hhmm4j56qtqui7pxzujfc43xq8yejzqs
X-Rspam-User: 
X-Rspamd-Queue-Id: AF3DB180006
X-Rspamd-Server: rspam05
X-HE-Tag: 1756316704-472847
X-HE-Meta: U2FsdGVkX19TuJ+c0s1kp4WqmIbbBtkIyJbgtxpgl8EwJlT7cHWoMeiqcORVkWL+4xiqyW/KZx0vz6sfcZHcvR9/VIuCSxtQE/PYhlRPHYQyGJ8hGb/RnaCS4Daw40jgLXI4se6jjQDcvwGnKhRhKKK3bZLIv4dkR9d+UaOckEv8AkJgyNgh2l9z9CCsOwHvJwpMVo99epr7oMWHpMr5vvpy+Kjy7li77zE+StdDuv5dtuuUt4IEEBsT049kZDDTNdbjKboiOvGxotxEDuwsxZONDWmMcUX5bWeUokd1hTJmCcYwuPBBokezYd7QAEd3JKewCV3134iGB4G8oxCISGm9oV6AnkcEpjgdwNxxI3Pl0uRxDUTvBZIud15pTLTPQY5UL4G8psujFouq3PyTXnW6vVwEjmndAo1xqX/cCtojiF18bxBh+wT74yQnXYG4xRq4/whsGlh9608awpMjZhNNlXe+2DBnGuoZjMT16VSALPzhj7NPmkDPtdfKFvWIkQxc78wG5cDW1nk2peBuvyLbFUE3ZG0aPYhfokUeqhoFhsHyCDxkIYvUdW/g8Iyo6tKUpCBEW6QaaM+FmZi91dEECJeZ+ZJcfjeH/oRVO8Pi3LeGhgOgfDCpnp9ksO0XiCdv18wXO3KnS5XPPoeKnJSXUMvA5j4DEzPLrUmytMh2xOUTLx1HZsbybmoeccBtRxx+vwE9K0Gf1IDNpZwUjvoC4b4g5ZNH1gj9n2qUkIHx7hUJ1eMcdrISMD7lrDwZ/rVP6ku9VndeqIj8diVKj/8pjoFEMa+KAC8wo0Yx3ovaxb/WKjbCCNxrFv3oQFr07ZwUsCIFTMTpfgkCvKRczYqnW2lFNTkGinFudlwkBiW9B5SJBrzvQmVqbyZV1KOY2Vs0z/3lGpeg6KZ+TV6h8S2biXTXVlec3rj2DmvJrY1ankvgQ5kvvVuVS69atyLElguOvn4JDokwDZkYosg
 1R8Mno8g
 t5/WrsLGkIsbQMy+CfqKgJH+hGgfE0/gfteZLQN55vOhM36BTtpaTvI149TGRMceaJrpUzjM03ubHArXJmJW93eG0WomsjIdDex+syU8tvqhLo4lmG0SxT5ymZ6aVXXF4lIgWbl3sGWTgrxqY9hmMquZDmYuvZa5ZUTi/YHWXXgvGEF6d6PA6pcHnxhZMMhJHfITcDZM9yT66F429zt1fK2zk76vJenzP5FcwMY1AsDuc1bPSquWwNlzPLfvEpPhZXNVtUkxi6iClHa9AF9jaMVjEQNhm7HOQvZpP4AsC7N4KNrjWsixsxPuiaA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 26, 2025 at 8:47=E2=80=AFPM Baoquan He <bhe@redhat.com> wrote:
>
> On 08/23/25 at 03:20am, Kairui Song wrote:
> ......
> > diff --git a/mm/swap.h b/mm/swap.h
> > index 223b40f2d37e..7b3efaa51624 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -15,6 +15,8 @@ extern int page_cluster;
> >  #define swap_entry_order(order)      0
> >  #endif
> >
> > +extern struct swap_info_struct *swap_info[];
> > +
> >  /*
> >   * We use this to track usage of a cluster. A cluster is a block of sw=
ap disk
> >   * space with SWAPFILE_CLUSTER pages long and naturally aligns in disk=
. All
> > @@ -53,9 +55,28 @@ enum swap_cluster_flags {
> >  #include <linux/swapops.h> /* for swp_offset */
> >  #include <linux/blk_types.h> /* for bio_end_io_t */
> >
> > +/*
> > + * Callers of all swp_* helpers here must ensure the entry is valid, a=
nd
> > + * pin the swap device by reference or in other ways.
> > + */
> > +static inline struct swap_info_struct *swp_type_info(int type)
> > +{
> > +     struct swap_info_struct *si;
> > +
> > +     si =3D READ_ONCE(swap_info[type]); /* rcu_dereference() */
> > +     VM_WARN_ON_ONCE(percpu_ref_is_zero(&si->users)); /* race with swa=
poff */
> > +     return si;
> > +}
> > +
> > +static inline struct swap_info_struct *swp_info(swp_entry_t entry)
> > +{
> > +     return swp_type_info(swp_type(entry));
> > +}
>
> swp_type_info() is only used by swp_info() in the whole series, can we
> open code it in swp_info()?

BTW, off topic here. I really don't like the "_info" suffix. Anything
you can put into a C struct by definition is some kind of information.
Same to the _struct. Anything defined by a struct is a struct. Don't
need to say that.
The "struct swap_info_struct" gets two of the unnecessary words. It
should be something like  "struct swap_file" or "struct swap_device".
Renaming it is too invasive to the code base and it will mess up the
git annotation history.

Oh well.

Chris

