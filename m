Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70BA9FA3753
	for <linux-mm@archiver.kernel.org>; Fri,  2 Jan 2026 17:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89B216B0088; Fri,  2 Jan 2026 12:42:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 873406B0089; Fri,  2 Jan 2026 12:42:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5C56B008A; Fri,  2 Jan 2026 12:42:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 683246B0088
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 12:42:49 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA5638C52B
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 17:42:48 +0000 (UTC)
X-FDA: 84287744016.16.9438910
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf16.hostedemail.com (Postfix) with ESMTP id 172F1180005
	for <linux-mm@kvack.org>; Fri,  2 Jan 2026 17:42:46 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lb7VyccR;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767375767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/0X43tzsEjAIkMG5nHwHs/LKFKaM5iOATeWa21x7UkM=;
	b=q2mu8fC9pV6hv3AvA82248GIraa0Ak//xM2eJ5MjNNyIvVZe0YEaclj5fKE7x8TMjNw1Gk
	jaZZ05ai0SdKgnuXKaKehZsLgCuzScCbgilsyKiewL7v8vnPykPCyam92gn8XHoXJFFA9X
	smgdTM2bsuwz4hYdSLd6z2m+E/R7m40=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Lb7VyccR;
	spf=pass (imf16.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.222.178 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767375767; a=rsa-sha256;
	cv=none;
	b=3lavHK5fkGsatKJdjvVEmp169ylEVt7AVjKifKvnzUy/g9jQ7+nx9xRT/JGn4Qf1p946Iu
	zuNprL+XZbefnp8GOjdXDv0/HVjPHMQDNRYfMCypxnDKGnU2GZWOEnTBTbJfIajIheGUdi
	xEDOPKaZXnUWLZMOX+FjuGUBbRui5G8=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-8b31a665ba5so1379758285a.2
        for <linux-mm@kvack.org>; Fri, 02 Jan 2026 09:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767375766; x=1767980566; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0X43tzsEjAIkMG5nHwHs/LKFKaM5iOATeWa21x7UkM=;
        b=Lb7VyccR69G1w3p41RLI52vl9M6S7e4Q6tbkJhWsPiYIgeVSAvXmOJyibBzAn5/sZk
         iltdNpIFbQHm8W+oIL47s0Z+3oPKDik/xo3M6rpw/LVsYsjwHJBixH1SNdGOZNtSmNBs
         2mRt8qVnOXyY+2Gl6i3pFPdiBhtik7eQKZS7RTr3tcBm7DgCHWIRNjCc2vHmLMhV3MZK
         WtyRGX/jbLNhbfpmEWeKjvZmoLHkqMBDEvs0FXb2TpTgxwMgn0nrG+/ygVG267EETWn9
         IChWEqel28hqH/dymBNvwZK5v0+Z92HNPPrjpYWmgPgXyiwUQqKIFxQg6EdCK5WpfW7k
         L4zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767375766; x=1767980566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/0X43tzsEjAIkMG5nHwHs/LKFKaM5iOATeWa21x7UkM=;
        b=JeRr9GKDbsFo4rcFTr8HW0BDIZbFqpFeqvCUpeeLiYFMlutRnVJ50/iRWm4+Cqla9J
         SiKxriAAb6XVXm1p+clzfIkvxmKC0Yi0EOje8qa31p81kORgplxbEUz7ev7gjMpe3OG5
         fAc0KPr0rE3mmngsndz2E2jChKXtOFcK65HePcClryb1wkULr/YBXYqNk/v8FdUKh+gA
         bfagtIXauqXbkHfiLw/8yK5nPlNXrCt8qzFn3jUBqF5B/dtNX+VI5UHhjgBClzvKDsV6
         223/yOJT7oG8vAR7dvUvsSMAoCUpm3EWgYBYdQrB2YsRZiOPhfG5NNAssx75z6XSL5Ct
         sGIQ==
X-Forwarded-Encrypted: i=1; AJvYcCW1+h1aEHP8XGXrmoY622Rqlf3a/AmmSPqspmul5iN+DBEazbPK4U2+CUmb9cBd+o7bqEHm7eOi1w==@kvack.org
X-Gm-Message-State: AOJu0YynTxgxt04IdZWvwS03XabTKCWfSYxvnia5MY8sGdUUeMOqoU7f
	lxf/vKkMUz8uAK1elA0X4vG1UDSSZISG9IlYGraAdONP8b0v3MSvQDlYbOhKFC54YOlTHORKoBS
	1iKK457gSlj+7upc7uFITasHLG+1EldRKHv4UdSw=
X-Gm-Gg: AY/fxX5OfLx5vktRR/GpDPxuTklSRMTmgWwgd00OXvBDhMdUaVQxmFFhCFBgPQM3P7R
	ZuCjRdU5sY+c05T15fF5yA2irG4Fjmv1EKf5h42VPk0mHxW1TeYe2BsAxMObcLJ/3dQJ7qHeUfJ
	4rT8Z1H9dSz7WL1AGbI/nYH/kieps7amkgNfSobrYN51kbfX7r21g5D4l4oUw0BJVNIMQXKXkoK
	IeGfyOmeOHY4Mg8WZR0bYPBQgHlBEd7D/RwU34QHcVXRGPGWsHRUYeRbw/D+T9XtOPcQA==
X-Google-Smtp-Source: AGHT+IHTCGFABNwPrRSP04C0uqspZoW3b8+qyuNDvY7nmDU36AGNpQ6R94yX7G4K3JG83u9w3TG9d+djwu3dA02k8LU=
X-Received: by 2002:a05:622a:1c0b:b0:4e7:2dac:95b7 with SMTP id
 d75a77b69052e-4f4abd2b668mr721175471cf.37.1767375766098; Fri, 02 Jan 2026
 09:42:46 -0800 (PST)
MIME-Version: 1.0
References: <20251215030043.1431306-1-joannelkoong@gmail.com> <20251215030043.1431306-2-joannelkoong@gmail.com>
In-Reply-To: <20251215030043.1431306-2-joannelkoong@gmail.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Fri, 2 Jan 2026 09:42:34 -0800
X-Gm-Features: AQt7F2ohaHF2UIzgTLkq0qp5Sg4UKfGxsYKPSUC_Kd08WY71gAokum3IjvOCHyE
Message-ID: <CAJnrk1ajqa4+GNgXNNyZ4sfpsyr3fcO15FH2CiTipyeMoVyT1g@mail.gmail.com>
Subject: Re: [PATCH v2 1/1] fs/writeback: skip AS_NO_DATA_INTEGRITY mappings
 in wait_sb_inodes()
To: akpm@linux-foundation.org
Cc: david@redhat.com, miklos@szeredi.hu, linux-mm@kvack.org, 
	athul.krishna.kr@protonmail.com, j.neuschaefer@gmx.net, carnil@debian.org, 
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 172F1180005
X-Stat-Signature: fjkpg6uhyhszn8kgqkds7rbqdfxma4o9
X-Rspam-User: 
X-HE-Tag: 1767375766-86669
X-HE-Meta: U2FsdGVkX183AagvLw+hHjQ6v65anRZpqiReVsRtbDBnEdlAlc52AhSk0Wqb9tXA9fKTjQHDNnY4oKHnmSWhYe3sRz1JKyVlVcuzRlhFpUL1JLUjg6OpNMsVFYC2sAdZWrfmmcQ24CspDlzwmcRIor43sdRVeY5qGw4+YjL9jeT4pY+i6ezdcH1wFVO93Szczuk/9vXnRt3nbrpmU8wjWvdKVOxrThKtYXuxSwvc+UHcafev1KFKSfT2qHLRHj/EmqLbp88rKJRCyJu0TWKguw/QcF558PQkDaMZnnTUHycJ/U9jNYq+06Myfzeuq7uDihQtVxgTzagvAk1r8BYg7jZHD5He60Um4w0WeL8XbRn/WL5w7Rsw6MHECl2gqjT+eeMmLAbyZKi5xpenzEhAGgieAo7RY2iu1wXnF2bdy6ZKFApidZoWuixcLr+9dy+dq7cxmgHkTcQ20y7gl5EDBBtnZBpJ1Af9TSq30tfj4AH/3Tj2CahiWc6JBEsN1msxbjWfeTtvMBA8owlLxh9VqLM8R7nNCryMGDsg65+AQ8D8+WuTFOQNiSt4yZg0O5wuqjkWdugdXgMVNsYCkVSGp//G8ZPuGJ4Ibe9Cyo5uKklnH1ccrv+Smhsnuh07fEcCIj74X4YKCeMXN40E/vbTVAg/agBMW+26JNGalmcvPt6qxmdtGdUWSLBQUdriEwT4+YbWAbz2znqT97vwswtFAXxBh2X+/kIt5TY/PEPUbZioEuDoikZubhmKZbyEkZtm3JZUthnwBtoNk/GKJ6Kn/Oes1TDuSs6AVth+9dPgWz6d7O7bTRrpWuIYNDGQP8zmZY04n4T4+dLgq+0EulNfEMuJvUwQkopUolHEkgIuD6RlajwKH8bPnhZjVfEm370JNjJS3kl5pzvktJVxLt+RD0b9FFSPI20N6Z+AMwwu7gjE/U8qr3sjref1CJ+j4bUKwEvt6aQJ1KgtaILaW9d
 W0gAnEkm
 OjbMer8PxVtNT+uutO085Dizn11O5oery8iL7ByTocozyxZSy2Y47tSbVmfeRTczCJc1loD+aJWQTPx7FsW/SHAue8R1TieZjaCeKXNKObkrC3yGEpIPvRUr6jJH2uEiyUfS4Utho5zvtqI0YDN7ihT5d76Mo93KUW7XVFntIdJ5EpDRs43PFwjbFbujO/qiay+dgRfpN4IpPd2hZHxK9kqQnabSjhCTlXVF++TG1fPK9nVQ2Syqx4Vt5srrs+Lc9aFKQ0M6igZp97fFCOia/9oa1LkBe1JXmhvw7PndyV4CExnxYFZfRSrviprLeM+Se9GCnudk0uJxncfK/EurCFYSZJohDyFhLyXuG8fW1z3GdfJb8NoCnF5GJHRbOQVbhP+ZROeaObvB1EWle7mNLB2K9RcVoCwKzAKFSdaYcoYEqBcoLg4qPt7Mt30A4VS+F0I0d3HAoyHzpvNJ5Rqytt4SEY4TM53tkUgqP5NuH7BgFLsHb/26cux3hE+AU0asaEm/gpI5xvTFaVu5EGv5MWZHT2A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Dec 14, 2025 at 7:05=E2=80=AFPM Joanne Koong <joannelkoong@gmail.co=
m> wrote:
>
> Skip waiting on writeback for inodes that belong to mappings that do not
> have data integrity guarantees (denoted by the AS_NO_DATA_INTEGRITY
> mapping flag).
>
> This restores fuse back to prior behavior where syncs are no-ops. This
> is needed because otherwise, if a system is running a faulty fuse
> server that does not reply to issued write requests, this will cause
> wait_sb_inodes() to wait forever.
>
> Fixes: 0c58a97f919c ("fuse: remove tmp folio for writebacks and internal =
rb tree")
> Reported-by: Athul Krishna <athul.krishna.kr@protonmail.com>
> Reported-by: J. Neusch=C3=A4fer <j.neuschaefer@gmx.net>
> Cc: stable@vger.kernel.org
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Hi Andrew,

This patch fixes a user regression that's been reported a few times
upstream [1][2]. Bernd (who works on fuse) has given his Reviewed-by
for the changes and J. has verified that it fixes the issues he saw.
Is there anything else needed to move this patch forward?

Thanks,
Joanne

[1] https://lore.kernel.org/regressions/mwBOip3XK77dn-UJtlk-uQ1N6i3nwsKticZ=
yQdPYzQcsk0dsjXl4oOAh-Neoxv-0TlpKnt_FEJwx8ses5VJglGLJUW-bIG8KWchtoDwCnnA=3D=
@protonmail.com/
[2] https://lore.kernel.org/linux-fsdevel/aT7JRqhUvZvfUQlV@eldamar.lan/




> ---
>  fs/fs-writeback.c       |  3 ++-
>  fs/fuse/file.c          |  4 +++-
>  include/linux/pagemap.h | 11 +++++++++++
>  3 files changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 6800886c4d10..ab2e279ed3c2 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -2751,7 +2751,8 @@ static void wait_sb_inodes(struct super_block *sb)
>                  * do not have the mapping lock. Skip it here, wb complet=
ion
>                  * will remove it.
>                  */
> -               if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK))
> +               if (!mapping_tagged(mapping, PAGECACHE_TAG_WRITEBACK) ||
> +                   mapping_no_data_integrity(mapping))
>                         continue;
>
>                 spin_unlock_irq(&sb->s_inode_wblist_lock);
> diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> index 01bc894e9c2b..3b2a171e652f 100644
> --- a/fs/fuse/file.c
> +++ b/fs/fuse/file.c
> @@ -3200,8 +3200,10 @@ void fuse_init_file_inode(struct inode *inode, uns=
igned int flags)
>
>         inode->i_fop =3D &fuse_file_operations;
>         inode->i_data.a_ops =3D &fuse_file_aops;
> -       if (fc->writeback_cache)
> +       if (fc->writeback_cache) {
>                 mapping_set_writeback_may_deadlock_on_reclaim(&inode->i_d=
ata);
> +               mapping_set_no_data_integrity(&inode->i_data);
> +       }
>
>         INIT_LIST_HEAD(&fi->write_files);
>         INIT_LIST_HEAD(&fi->queued_writes);
> diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
> index 31a848485ad9..ec442af3f886 100644
> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -210,6 +210,7 @@ enum mapping_flags {
>         AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM =3D 9,
>         AS_KERNEL_FILE =3D 10,    /* mapping for a fake kernel file that =
shouldn't
>                                    account usage to user cgroups */
> +       AS_NO_DATA_INTEGRITY =3D 11, /* no data integrity guarantees */
>         /* Bits 16-25 are used for FOLIO_ORDER */
>         AS_FOLIO_ORDER_BITS =3D 5,
>         AS_FOLIO_ORDER_MIN =3D 16,
> @@ -345,6 +346,16 @@ static inline bool mapping_writeback_may_deadlock_on=
_reclaim(const struct addres
>         return test_bit(AS_WRITEBACK_MAY_DEADLOCK_ON_RECLAIM, &mapping->f=
lags);
>  }
>
> +static inline void mapping_set_no_data_integrity(struct address_space *m=
apping)
> +{
> +       set_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> +}
> +
> +static inline bool mapping_no_data_integrity(const struct address_space =
*mapping)
> +{
> +       return test_bit(AS_NO_DATA_INTEGRITY, &mapping->flags);
> +}
> +
>  static inline gfp_t mapping_gfp_mask(const struct address_space *mapping=
)
>  {
>         return mapping->gfp_mask;
> --
> 2.47.3
>

