Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A1FD5B87C
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 07:07:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 412C36B0005; Tue, 16 Dec 2025 02:07:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3C0086B0089; Tue, 16 Dec 2025 02:07:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BF5F6B008A; Tue, 16 Dec 2025 02:07:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1742D6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:07:49 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C2FED60387
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:07:48 +0000 (UTC)
X-FDA: 84224454216.19.A5708EF
Received: from mail-qt1-f173.google.com (mail-qt1-f173.google.com [209.85.160.173])
	by imf07.hostedemail.com (Postfix) with ESMTP id E54354000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 07:07:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DtkALHix;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765868866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HScJKo2ZJ/IGih9vrcGVoqKVZ2gLkTQ4915YFT77Pi0=;
	b=0Cz/XgE640J/SzR6UBrh/Xt/vJY32dJcslathRBtrsdimO2aVlkx2JItl4NBQkR813Sgrs
	SFALPwRDdTTox5stcwPNmsJqtmAxFG39OpFfzLmZk+OpAg0IXHUuNrZtKucRFo2PEpj+Oj
	80z5OZlubSVKv/Hj9ApSkvClChj5WtU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765868866; a=rsa-sha256;
	cv=none;
	b=T6SPIFTEjDxpwofEVJxQJxpCLB7BzlE3kOc92Y+A/9OUwuWuRLci/s9OfzAtOB/GgqjsZB
	+iqzK9z1vXK9kxBVkdjPMxGvSoPHNV4mDn5jCNunjCpuUZHT523jHqZ9mvXVlQioTjFymv
	bSNSotKyD2e7Pb6lUBgrn2bq9rjhr4Q=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DtkALHix;
	spf=pass (imf07.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.160.173 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-4ee2014c228so31105411cf.2
        for <linux-mm@kvack.org>; Mon, 15 Dec 2025 23:07:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765868866; x=1766473666; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HScJKo2ZJ/IGih9vrcGVoqKVZ2gLkTQ4915YFT77Pi0=;
        b=DtkALHixlA/qcSoDsDND7fhtdTUBbs8afsjRv7eYmSvQzt3Vb1aTRQhCGr32eyI16n
         TyvrwWczE3usSYTY/ZKbhu2Lnp2Bw3fGKr88JO1PSGmbsd+pluhyQ1eZEeeO/ULjXxMT
         OMuklK/12GUxKDUMltcb1mGxxB+ejXk/GoRUXdjXoUPLc/ELtw8F28sDM30vYd2JQP36
         LvZdGJLYKPv74KfKE42FZ4jZn9hN3pQKGro81J2SueFSw/sGdkipwcmdKvzAhdnR70xi
         /cmp7EpPH9mhdbDwt2xV/8qEWvt9ioRTPFKKcpMbxI3wllGj/oIKL9fC5r9swl2zuRSE
         agGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765868866; x=1766473666;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HScJKo2ZJ/IGih9vrcGVoqKVZ2gLkTQ4915YFT77Pi0=;
        b=UnlQSZCnF9Ar+0+StjDauBTfeYaT34lmUokxQirbs2iYvrvN3C4Xx5KCUx5QWR7xBK
         pgLXipeRHwxRAxKSXqMbIp7kacoEbXIrD6aZ2mTAU1yGXhuUDLCXKVAwcddCErfriYOc
         YI9uEnK86R3jI8YBGB5QD+yVP/kx9ANb9DUVj1cW+DoiVkEqbhGBYBjJnFuQB+x2h85Z
         d4fVjwnrVjjhBNiVWWWv8oOvBV/7FPB5woZbM/dDsMyVWKIPIevCcmVftVaX3nellflE
         I6uv4Leado6eCysFNO0uwvk1gFAocGNkEY2K2qjXswqLIolRF1kCnSlJN4omufzkM7pb
         8d9A==
X-Forwarded-Encrypted: i=1; AJvYcCWYDPZKc824bSs8Qh+mX1l6c522WBQ+Jc75EKixLp0Jr+fD98kuySk3fH68rZ7dQ21g5Haf5pOHsw==@kvack.org
X-Gm-Message-State: AOJu0YyZMLwBY3QLH8zKT1z33fwHjCANPz7GPHpis0qc1npyvMdB62t3
	X2V++5W1pKluJjCNF4dK04U8sWMXyjXPUimqqp8WvRWlSd9DC2rLkCX33U7EL6gV8WniyRrdSQ+
	0mg/nUBodeE9UfH5VphMjbh5aO0JnRzD7yVLA3xM=
X-Gm-Gg: AY/fxX73eHfZKolaJtCyOTzg4oafT70x5EqV/oREHQFXnwcRc7PFdoi2xjW1Oyjf8to
	5MA4KE6zI03MdhsLW+8ZH7kg0+NBUDDqaAMsRHRH6bN78l0a8uGvGwsMlcHifCeiT+322yA2039
	xw3ufa12lRbvVEiquZylMEO5zbTlmTnRSOTSFXgES3qa3n8xCL0WngLLcTztB3LU4X6/QoGtnjk
	9tImTCMr8JrZse3SLi+Wrcrs0FHkTMvDtp6j2a/OPTBqCkLXs/l8Ff7OF7qF8D2K4/mMEaKwKzi
	TczExWWceOI=
X-Google-Smtp-Source: AGHT+IHdFbcCr8rDYHyI9PjajR/t+4eN/PBNmV7BmRo8+mJOOy3yb1aGTT+f0yRNO2U2a9JTAylP005Pr7cTKtFcS5w=
X-Received: by 2002:a05:622a:4889:b0:4f0:5dd:c963 with SMTP id
 d75a77b69052e-4f1d04715femr185534361cf.7.1765868865896; Mon, 15 Dec 2025
 23:07:45 -0800 (PST)
MIME-Version: 1.0
References: <20251215030043.1431306-1-joannelkoong@gmail.com>
 <20251215030043.1431306-2-joannelkoong@gmail.com> <2410c88d-380a-4aef-898e-857307a57959@bsbernd.com>
In-Reply-To: <2410c88d-380a-4aef-898e-857307a57959@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 16 Dec 2025 15:07:34 +0800
X-Gm-Features: AQt7F2qpFeQSv5QD2stCOPk1MGDu8zClAXpXqMgzVuI8pDG-5lp3de5bo6jqHcY
Message-ID: <CAJnrk1Z9gddx9F1oSbq9bWfFefURCqoAg3SDmT2Wqrnb1bwrwA@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: Bernd Schubert <bernd@bsbernd.com>
Cc: akpm@linux-foundation.org, david@redhat.com, miklos@szeredi.hu, 
	linux-mm@kvack.org, athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, 
	carnil@debian.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f49miseeioqiekj9bm4soepegnxkofst
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E54354000B
X-Rspam-User: 
X-HE-Tag: 1765868866-325871
X-HE-Meta: U2FsdGVkX1+CuehCO0Wpvy/JYBhZ/W/nJ2nMHuxqH6K+1wLClX9W224ExbBWw1qel4NR7X5A7vGMjzklHeyvvRPvzJ1x+W383MukuvqXnDHMZWVdEod0YHDN0rbcswVdDAn6Xiq5qbnkhCduUT6jdgTT6mOFm0lsYnBMMBOwTNo8gKTFwM1RkPqN+1zsko7pI4WkhJci99gi/2+WQqnpqh+tu3qK+79m3cr8DeWNlKCF3HTz++vaASq3WHnPybMHOJWBnyNV4nTyyiGLvktHlvkQQ9hi1MMMZGgxD0J+BOnzzAw6j9O2ed++2cr+dVXQPz0nXISsPz80QXoNubZ/95Fc1sqD1tRyjL1shGsu8ayKC7FYdZJHK4hKom57bXVCFwhSK/3WPXOOvii4A0eGz8o2yoLf0MkD6eJo7Awu03CTmkDTzRpPSyQFnRanWBKgL6MIhpj3DAJq4QqHb2/KX3Vmk7+RQRdsyXKnYYVsxR8PRX3/Fv4xal0Mj9qwoe6qZUrcLjgiMpLnMSia4q1Y114TUihVLOuHHW6qXH29hCsZzJ+ZsM3jS48s8MfbzED8STiaF68NHA0NJRX1R8X8mis3eZo+fp+yTAbILP3HWX2Go50crSB/8HByu/wgCXFxP+29d1wnQXXxdeNNwicnv/Z5n9+k095sOA6EzBAUwocwIu/Se3470TGgQC5JBqt9I/0Cd1gDVG7DwtXVZ8rP2v6CSWKKeYeV0fj/SYyM7qMpAmqzy2RPI/uDbkZAAxXzaXxdNX4hL5XaOao+o9nIFlkgGn68GVnLyhjvOe4WTnqNZM1BetTwWaTAyXQCA6jCYBdCjkaWS6cDOJAPZvGueGA9D5dTcBUw6abrds7r4uQZMoYEsI6mP+oDegF7yDTGoOzf4dEdI4dcbRMh2Adzx7um3kIViHBeuT+8VHpkr87SSldz9AwooLSR0j9tryxScQSWDJCU/r/55FI//M4
 jANMyWt3
 CGAlcF0wia64zYhmRSUwpPgI404wHEoitNPXvSCX6dNHyLwfVPDHEqM6x79y6fr84QwZ/zqfulyn94vCYsfL5xWqu2u9DnE0YhoOWNhRPBdCdJIFfWJSLRqvcjIvU97bcfAaVjtrKgh4LzF+ONTPGyDZIKetjxlhwnxbzq1xyjWNl2XAZVCBDEuCUz8dz/97rl+t6EIhq6u0UYzzPSUcWhj3cdARU3El9W19oASUat9vNRrgL5x5O+MHSGdD34rsqjPdHcvEPQj0mKiiNmEn0Og4fo5zpivfTLFQN0GsYZtYrX+Z0jVo4jxZfzwXg26FBLxwOcUN7BY3IkJHrjQg40c9dtVr105yE4fya1fLhNGNFhCsHnlLZEyd1lEizEpoNP3kPUZR+6sam2MYOnTNKkdtdjEX+5Xypgp3pYE8tt/tScA6SbE/vYE+TiLoCYAChiXGYYd6vReTTYmE622hX1MPLft0vQWeqZe8INqKEH5o6S1LqY821du9aNOvhl92VeO/EmZvEvrw+CwfRSeVuevGgXe3mdt2FZyJNYhPErOdD2fsL1kwrcQYkbk5KsfThf5fYlCWIV2bofncysPWqwD5Z0UX93qNNtlo/DgHQ6hN9IzZso623N/aMISeinO2V093BhWamsE3Jq6rcjVz/nUlhM4JqZDcLWFTfw2ZRsmW3K81DzXhfBBNVKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 16, 2025 at 1:09=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
> On 12/15/25 04:00, Joanne Koong wrote:
> > Skip waiting on writeback for inodes that belong to mappings that do no=
t
> > have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
> > mapping flag).
> >
> > This restores fuse back to prior behavior where syncs are no-ops. This
> > is needed because otherwise, if a system is running a faulty fuse
> > server that does not reply to issued write requests, this will cause
> > wait_sb_inodes() to wait forever.
> >
> > Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and interna=
l rb tree")
> > Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> > Reported-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >   fs/fs-writeback.c       |  3 ++-
> >   fs/fuse/file.c          |  4 +++-
> >   include/linux/pagemap.h | 11 +++++++++++
> >   3 files changed, 16 insertions(+), 2 deletions(-)
> >
> > diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> > index 6800886c4d10..ab2e279ed3c2 100644
> > --- a/fs/fs-writeback.c
> > +++ b/fs/fs-writeback.c
> > @@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_block *sb=
)
> >                * do not have the mapping lock. Skip it here, wb complet=
ion
> >                * will remove it.
> >                */
> > -             if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> > +             if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> > +                 mapping_no_data_integrity(mapping))
> >                       continue;
> >
> >               spin_unlock_irq(&sb->s_inode_wblist_lock);
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 01bc894e9c2b..3b2a171e652f 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -3200,8 +3200,10 @@ void fuse_init_file_inode(struct inode *inode, u=
nsigned int flags)
> >
> >       inode->i_fop =3D &fuse_file_operations;
> >       inode->i_data.a_ops =3D &fuse_file_aops;
> > -     if (fc->writeback_cache)
> > +     if (fc->writeback_cache) {
> >               mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_d=
ata);
> > +             mapping_set_no_data_integrity(&inode->i_data);
> > +     }
>
> For a future commit, maybe we could add a FUSE_INIT flag that allows priv=
ileged
> fuse server to not set this? Maybe even in combination with an enforced r=
equest
> timeout?

That sounds good, thanks for reviewing this, Bernd!

>
> >
> >       INIT_LIST_HEAD(&fi->write_files);
> >       INIT_LIST_HEAD(&fi->queued_writes);
> > diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> > index 31a848485ad9..ec442af3f886 100644
> > --- a/include/linux/pagemap.h
> > +++ b/include/linux/pagemap.h
> > @@ -210,6 +210,7 @@ enum mapping_flags {
> >       AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,
> >       AS_KERNEL_FILE =3D 10,    /* mapping for a fake kernel file that =
shouldn't
> >                                  account usage to user cgroups */
> > +     AS_NO_DATA_INTEGRITY =3D 11, /* no data integrity guarantees */
> >       /* Bits 16-25 are used for FOLIO_ORDER */
> >       AS_FOLIO_ORDER_BITS =3D 5,
> >       AS_FOLIO_ORDER_MIN =3D 16,
> > @@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_=
on_reclaim(const struct addres
> >       return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->f=
lags);
> >   }
> >
> > +static inline void mapping_set_no_data_integrity(struct address_space =
*mapping)
> > +{
> > +     set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> > +}
> > +
> > +static inline bool mapping_no_data_integrity(const struct address_spac=
e *mapping)
> > +{
> > +     return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> > +}
> > +
> >   static inline gfp_t mapping_gfp_mask(const struct address_space *mapp=
ing)
> >   {
> >       return mapping->gfp_mask;
>
>
> Reviewed-by: Bernd Schubert <bschubert@ddn.com>

