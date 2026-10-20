Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2A2C606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 17:58:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=W69weLHI
Received: by kanga.kvack.org (Postfix)
	id 7AD2B6B0179; Tue, 20 Oct 2026 13:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 784F96B017B; Tue, 20 Oct 2026 13:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 64CF16B017F; Tue, 20 Oct 2026 13:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3408E6B0179
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 13:58:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 888C71A0328
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:58:54 +0000 (UTC)
X-FDA: 85343765388.24.9678ED3
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf25.hostedemail.com (Postfix) with ESMTP id 92A43A000C
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 17:58:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W69weLHI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792519132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dc+Bo7udqDy3OvFW1e4k6Vi+Psamqa3s48HVUQ/rqV4=;
	b=u7OxohDxjyBxjkIzRedYPM+sN5JVyAB4RMa0+Te2CrsXUXIuKUuLuo6218QDqSfZBZ/jnJ
	/5OR0prkghECZokz+6yMw2GJn1fq1wcu1CV+OdDBM0VL5fOyEhXEKXydAiHZHA+yHSWJ1v
	PRKhQP9nVz37zTUoG1gu3Uw2dn7vXJ0=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=W69weLHI;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf25.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792519132;
	b=PwaYItTxXZHVz4Ac6KBmEgJt7hftOlywxd9crpA3pWOVwGi+J2naOk8GWe+ymJmVprfvkJ
	z6aBXaqtCq/QhQlLWHEKqgh9UpuekEPMqz0IlxdRchYMq8OxtUNUl6Tufop+fm1ySuZl8N
	jLeNxxDjp4GmbYxOFIY2iZBKvOa+r9o=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4086e892a4so474902166b.2
        for <linux-mm@kvack.org>; Tue, 20 Oct 2026 10:58:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792519131; cv=none;
        d=google.com; s=arc-20260327;
        b=DpF4g9qe6t0I98E0S5jTFTuZSs6ilUMe5i33Qk3pnYRpkbFpL2K+mEioHVKXp4C8qW
         +KgA4lm59a1SX2di3TCxJuNlg78MX5sZgzCmf6mruw/hAnBX5OWRsV2bFINj2wnvCmhJ
         4ZlNzFrAzjgslOv5Kg7mwBIilW0+guYhZfFNyBxHSTZ1thSqts/pLwGBSHgRC2vFi4bg
         V+UeEcMI24luCAHdrY3ulMN9Gl4ukT6i45GBqPLm13Lcps+CMgQskcXYJwlYkHCRHsIz
         ABTHO+ovRGe/Nr+4jAYiCiVs1poNnTx7FGP2MCDppgr0PO+CzD27U7BK+Eqw7sEqGVrE
         bXGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Dc+Bo7udqDy3OvFW1e4k6Vi+Psamqa3s48HVUQ/rqV4=;
        fh=ApOVIMZLkV4GR5MNxVbYuZ1QUCchfe2TChoLyfzVjng=;
        b=nWGgSjAV4kwkLOeGsIkZikSJc5wB5rPSWDeJaTOcTyW2xRtMvQn9Rhrhj8U9v6e9oq
         Gf6YRoo0Mg2RzNOHWuuDu9VGjdqA63/1iHXxloHD42nUsH22LT/GXq5r9Y2iqtt+oY8A
         iEyLTxNfxXzjjYRZ6GZRst2Mf70dqNnnsv3psDJlghRKCSHQB0mgNz8Lul44+fd3Iauh
         4QtjXdqdmibMbTYOryA3eoIkTOvRlYR1j2NUD1vgO07lBDlFlq+JpDb6niPZMBaWeWM3
         6w3Mgp8IFdPGsiBCjUkzG5XD3LMpJITEoas5IRoaMtWamDLgihI+lLzFVVLCamQt37cs
         liEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792519131; x=1793123931; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Dc+Bo7udqDy3OvFW1e4k6Vi+Psamqa3s48HVUQ/rqV4=;
        b=W69weLHICy6WDMyIj1i71jPo7isLg2A9fHTvYM5Rgdq6HjA1IIMk0i4d+FLRAmRWTd
         j5g6mQ6JusEfeRzRNN5Bc/+zzYhSkue+GZfQq2+EVBEbQ+71VTAsrsxlmchc1Ix0stbC
         WFV2+uQjsDncxtGcE/KYOJbWbn7KHSHPEsGp7RLzr+baHUp9HkxRB3bvZS+N2kHVeJT9
         OiVAuW4EiTQ2SWslWZKmbFYFxRo/K/+vh5k3i5gAHSrE/ezVVuWkuhr5BG51H7gP+TnO
         HA65vRRccy47so0F4OSqEHUZ0EPMyUlBVY/0YjmOsAKdu8U/TsRxqojqZ7GkjZyhqtcm
         PAmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792519131; x=1793123931;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dc+Bo7udqDy3OvFW1e4k6Vi+Psamqa3s48HVUQ/rqV4=;
        b=qFn4kr5mUTuPLq4Bh+MAct9CTS+LhBL+7OzfJoJzD/9DUoqS2k/bP4dHe3hk/czMyK
         rSy2HF+TwKz8Ul8fpWI55Kg5HcU2ouoDoTDkTtu2APuQOFMJXRZXB/5IpNQzD4fm256k
         t/1yFPQD+4/ZBWRyZlnZX+9e9lygFRBrenMXbkNFsgUNluP4Cl7+8jqHUItsF87mdnkB
         KT+uMVlpMuBKOzgAy/3McsNrcBuhpLAz405iNFaYkvvdXez2Iu0Ex0ms+cIRwrC7YCeR
         TrPtjzJh+yRxGblH9dAm1TRToky8+JyAxBn1T29nR9IZFYfDFx2mx2asgeYrJgcPZwTd
         tpqA==
X-Forwarded-Encrypted: i=1; AKwUvBzV56Bb/KoTNPmc7NhOGVTj1CCaNE69i2qNO6fWkNDnk7nGaG5QSb+x6uW6ws4katleNQmG+rgnhA==@kvack.org
X-Gm-Message-State: AFq9FYKhDaUlflMrPK3vAqBDM31/e7cLEbQx+8m3vwMGcquVQowPfNI1
	6S7d/AICimWCx06mhVxf7YnWyRdJRtKKdg750SiRC/BNyDPWE7ysSRiqFLckcrzoc38JbbAOzq6
	6uZCV9b2iwnQ17BxkrVzPKfBsx4gvlkg=
X-Gm-Gg: AYBFou0U79McV9ZkB+w3UYo7J/ClOabV0qThsEnTPz1bzwsEgBAvr9kdNFUWCZFu9jw
	M9njnMnUuhxqUURo4g4qIA5Q6aWUT5r20Pj/x5uHWG9MyVk2hr+k51QQvEUge/MAcGF23Uddmoe
	Cmxg8ldZv9f192b5dDEql6MdaZxWQdznof2D7tkIOrZlK41ii/8x33GXYPk4iAusGYUUpAQAkgB
	DoO5kIngA1OecItypsonRfYQFVuI64MLpG+0CdDXrT5aPGnKDf0luYwk3K07goggoQmqELZyiz5
	VaH9HRODkmjQJV3SyWkGH46+Dhbg9ShZ4En0wkHgZkMyubd3rUOsOD7HJvz8MspP2fxw1FfrRd7
	Ez10G0Z5ej409
X-Received: by 2002:a17:907:930e:b0:c31:8c48:e18b with SMTP id
 a640c23a62f3a-c419df3d9e2mr827528166b.14.1792519130900; Tue, 20 Oct 2026
 10:58:50 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261019160615.2348500-1-nphamcs@gmail.com> <atcRLYvKavedT6Hs@yjaykim-PowerEdge-T330>
 <CAKEwX=MRvzzd0Fn=UX+LcRo+K9wuqCWSB42NNn7rvZkZukRRrg@mail.gmail.com> <CAKEwX=OwzpxUfdANEXoCeZPBqch+91C4gKwhrcikm6Gj_LBPKw@mail.gmail.com>
In-Reply-To: <CAKEwX=OwzpxUfdANEXoCeZPBqch+91C4gKwhrcikm6Gj_LBPKw@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 21 Oct 2026 01:58:11 +0800
X-Gm-Features: AclHuK9UBnCJDKT6vP1WD_aznvQkjk4cpSf1QdPurJznE3HDglLfCYeOaCQoUZk
Message-ID: <CAMgjq7AsUWGw5K5Xk1qz67atXmXB7vYDww-+u9t8Mz7rNAH-6Q@mail.gmail.com>
Subject: Re: [PATCH] mm, swap: revalidate populated clusters before scanning
To: Nhat Pham <nphamcs@gmail.com>
Cc: Youngjun Park <youngjun.park@lge.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 92A43A000C
X-Rspam-User: 
X-Stat-Signature: rswoinhrhrs38x7z6z3w9t1mg15pkzyu
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792519132-935744
X-HE-Meta: U2FsdGVkX1/FKAvxGCPSzF2aBrDQbCbvTmFvGX7nxCLlThtHwI+pABo1lM5ApiZGvU1H2NHFblAmUoGf3S/4t5AY6eNJ0/RoCGvAvhqMx1ypdkZ5SVzEefapQBzroN/pK3MtrCZS3MTqqfwyIo82O3qCvLJVe4J9CDsj4Q8Gn+4fU1iAkbJnQ8ien1v5+d0VFM+n9eKFFn7shDtnolIF5ckB4usOFhyX11EtRI1cB47ST1Lt2DQbKmUCFSn6q83oOgLEIEPnnoAOa3Q4YGCiJ7F/B6n6C5/r9znixx6aVqap8s69fdgh7aaD0kmjH1VJfVVQJAEovXYOqOEdI/iU4zGnmblU8Bq9bnmTbTJ0ByonrpuwtfgUAog16LNzEc+A9lVfdcnBprIp3//oqC1f4Iw6H+MejTULdjK3gxRLLIaPQUBNkz4G3iP2JVN8n2mVJgKY5vHrbfr2liuoF2IccC8IDC1UC9ivFz44tZJdpi9axxr4l32WnPpOvM4PrSXbm0HKg693oKUh7yt1btNMEgJ9I9MKBVtdhIox2cqqEIJZn/STQUQTZ8Neb81E1LjIegnZOTdbmY18Us0DgOGumAzWf4t6llabsNBiH3w3+nwxtMd4teovqdinmBCU+V0QQs6lVdUUWXiWnDIj4fJODgZZpV9HLRpY8PJioAgRlfJ3YGWMWOjthXuFmK2LyNl6UPEWGJgG8y1hMBCLhQkckgrov0HwaRmTxwuGXX07mNYSPECfd3Cp983S3yygBNa74KqMjGjU4RKoBtX/365Eupu5Ic4dLiSf7cyNDYP7F9wrVKStAm2Rs19rAdbzrmkCoVbHXWesEGNwW9ZHei2fxJxC7m91qaS0eW2S3NyRGbjmNbg9yxRk6BAH9hyLocFepmP4Bozza25t7EeV/DlMXUXLBu9vHXAuIMZ2hkRN92GW9dT9dt6Ny2lcMMM56/3DQBk7EGk9FktXrfffxpL
 dzIkIIlI
 3seI6haUF1EijTJ2we+K5uH6sTmRbBDXU6tkupB1+aoR8LHeA1VESuDJxRgt3/74MC3T4vo61kOQIVGVW313wzsk0qVMFRboacY2Nnv10mC/6bXdPcML2//F8fQw6lyREkShkHCXXT9kibhsjRY9JWRGTxbGyt7pxNAiE7JJsrcnssgJvu5FxzoIigj4pKPn28SpNAlhHUaZ5Rim+ubKQHP2JuQY8Gvp2NXjYvCP+FUwL3TOLiVl/487jp79osTncLPaIEBRbEl61gyJjepX08fjuy+Qn+gZV4JfPNrZoWiF91YietpB7kwhtYtNKkU+766x3khBw80Jw5j4FvVE+0pP9VlJhZmA1ex4cVYGJ/mRHniJa5ZL+2wSEMrPLMfpAyS4w04DxhvdKhbO0tyZ3PZovzSVId2/QyzWqLfJDKGk4cQC8ytwIkFhHHwV6iCLse/8FopNn2BS2IMbwesU1PjK5rHdGGUVCR5U98OFfkLhvRu01N/HxEgmDTQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 9:23=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Oct 20, 2026 at 6:12=E2=80=AFAM Nhat Pham <nphamcs@gmail.com> wro=
te:
> >
> > On Mon, Oct 19, 2026 at 11:58=E2=80=AFPM Youngjun Park <youngjun.park@l=
ge.com> wrote:
> > >
> > > On Mon, Oct 19, 2026 at 09:06:15AM -0700, Nhat Pham wrote:
> > > > swap_cluster_populate() can publish a cluster's table with the clus=
ter
> > > > lock dropped. A cached allocator can use and empty it before the
> > > > populating allocator reacquires the lock. The resumed scan can then
> > > > dereference a NULL table.
> > > >
> > > > For example, CPU1 can retain a cached cluster offset on an SSD with
> > > > per-page discard disabled:
> > > >
> > > >     CPU0                          CPU1
> > > >     ----                          ----
> > > >     swap_cluster_populate()
> > > >       swap_cluster_alloc_table() fails
> > > >       spin_unlock(&ci->lock)
> > > >       local_unlock(&percpu_swap_cluster.lock)
> > > >       swap_cluster_alloc_table()
> > > >         rcu_assign_pointer(ci->table, table)
> > > >                                   swap_alloc_fast()
> > > >                                   local_unlock(&percpu_swap_cluster=
.lock)
> > > >                                   mem_cgroup_try_charge_swap() fail=
s
> > > >                                   swap_cache_del_folio()
> > > >                                     __swap_cluster_free_entries()
> > > >                                       free_cluster()
> > > >                                         __free_cluster()
> > > >                                           swap_cluster_free_table()
> > > >                                             rcu_assign_pointer(...,=
 NULL)
> > > >       local_lock(&percpu_swap_cluster.lock)
> > > >       spin_lock(&ci->lock)
> > > >       return ci
> > > >     alloc_swap_scan_cluster()
> > > >       cluster_scan_range()
> > > >         __swap_table_get()
> > >
> > > Hello Nhat.
> > >
> > > Good catch!
> > >
> > > > Reject an unusable cluster under its lock before scanning it. Reloc=
ate
> > > > it only while its table is present.
> > > >
> > > > Fixes: cdd77f84d966 ("mm, swap: consolidate cluster allocation help=
ers")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
> > > > ---
> > > >  mm/swapfile.c | 7 ++++++-
> > > >  1 file changed, 6 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > > > index c3288910b3e3..988b7316e0a1 100644
> > > > --- a/mm/swapfile.c
> > > > +++ b/mm/swapfile.c
> > > > @@ -981,7 +981,11 @@ static unsigned int alloc_swap_scan_cluster(st=
ruct swap_info_struct *si,
> > > >       bool need_reclaim, ret, usable;
> > > >
> > > >       lockdep_assert_held(&ci->lock);
> > > > -     VM_WARN_ON(!cluster_is_usable(ci, order));
> > > > +     if (!cluster_is_usable(ci, order)) {
> > > > +             if (cluster_table_is_alloced(ci))
> > > > +                     relocate_cluster(si, ci);
> > > > +             goto out_unlock;
> > > > +     }
> > >
> > > If this patch is applied as bloew, does it prevent the issue describe=
d here?
> > >
> > > https://lore.kernel.org/linux-mm/20260720071342.50742-2-shikemeng@hua=
weicloud.com/
> > > (This patch publishes cluster table after lock acquired.)
> > >
> > > This patch is chagned the way I suggested during review... :(
> >
> > Ah I missed that patch series and your review! What happened to it?
> > Did we just never land it?
> >
> > Looks like we are still doing neither Keming's approach (table
> > copying) nor your approach (publishing at the end of
> > swap_cluster_alloc_table()).
>
> Ah nope, I saw that Kemeng implemented your approach:
>
> https://lore.kernel.org/linux-mm/20260907091356.53026-2-shikemeng@huaweic=
loud.com/
>
> My bad! But yeah I think we still need this small fix (or Kemeng's
> original proposal?), unless I missed something...?

Right I remember that, I acked part of that and was waiting the update
on that sashiko comment, as the first patch isn't perfect, while
Kemeng's mail at "shikemeng@huaweicloud.com" is now bouncing back...
I'm not sure if Kemeng still plans to update that.

