Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE2A2606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 00:09:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KJBOk22H
Received: by kanga.kvack.org (Postfix)
	id B5FF06B05B5; Tue, 10 Nov 2026 19:09:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B37CC6B05B6; Tue, 10 Nov 2026 19:09:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74A96B05B7; Tue, 10 Nov 2026 19:09:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 848836B05B5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 19:09:37 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1F719A75C5
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:09:37 +0000 (UTC)
X-FDA: 85420904394.03.1575D9D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4235CC0003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:09:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJBOk22H;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794355775;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D9RbdabYHrbLRamg3GYETMJN16hdNDL32IGRIbktV74=;
	b=3Wryz1Yp4cgJhnfpActjADg6EuKNBSfX2f6nOd1qOQx0qkXYNd7YXwCy4JNTNL0RNnsbNZ
	ocULeZhFM6bIl/sRkoSaxH3qnh/9J8VsL5bBouk2Fm+5jkJ3zFPeAD+BsnxZBL3KHxLbVU
	2LacZHFX47eHUrTBCuL8W2CE4mYW3Sw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794355775;
	b=rMrM0O7Hnqe4cvzr42TcxlBcNA5vHN6oqIk71gNWyNn3aLBwfc32hnkTvtNAI0reYN8oEZ
	Hyd5Iw1tu16h1XTOzYnsZ/YhCFtJYXWlUC5duw+maHDc/u31Wwc5tsYlnaBhb1PcaSVh86
	1SyyecFmZDrqlPKSJXXKvM2nk52BvqI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KJBOk22H;
	spf=pass (imf28.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6F70044F7B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2881F00A09
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 00:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794355774;
	bh=D9RbdabYHrbLRamg3GYETMJN16hdNDL32IGRIbktV74=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KJBOk22HBLkc6tfUu20Eh9xeMYaip5XleiEMISeXaxysRPDLpDmH612ksig07pAgv
	 oGgJBRSewh1EMfh0Bv/WzpbPc9TTs/V55rtx4I8NQ0m50YamECnqyZUWHJypRfOkMD
	 P5Hj0956d8kgNvlUz2NtH18CVGxcQ8/i8yyFt7b0qqh6JG/u4RC8Jhh4zOq/deY0F3
	 5wDcO0WKw19+2wz0E04QwPlazcNA1CYk3hEaqeAjFmvmL2ArEMjiP9EDIU/oVH8i8Q
	 s1FfPw+TcvBntwsSfbCWUUbV3SQL21EmvexAYuuYCPqdWf+Bc+TtTrWw9OGctpuKkF
	 O5PPkfnfxs+aQ==
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-5eac6c5f927so1048719e0c.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:09:34 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErHxOEPg+hXwYfbcUad/6ll0T1kTgu8SZxR4C3r/DAZRVRFMlCbHU6CktwANMP4BBVtPwavOPCLVCg==@kvack.org
X-Gm-Message-State: APuU4Z9ByIgXpb2cjklweNZb5uIjLA1uC+33RUIGnJrqabPHQUYg9nQO
	GWwTzDXJr8npyxQH2vctZ6qEUp+BDJG1kpTYbk2W/mtUpMnYPSwl5lcxKA6VDLJIcPZzO93WuM2
	h5954GrCUAyGxkK+HL9aAiLn63RMy/Xc=
X-Received: by 2002:a05:6122:32d1:b0:5ec:e522:70d9 with SMTP id
 71dfb90a1353d-5ee1c44ac6amr261128e0c.16.1794355773513; Tue, 10 Nov 2026
 16:09:33 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261110202025.25736-1-baohua@kernel.org> <20261110202025.25736-10-baohua@kernel.org>
 <sashiko-outbox-207746@kernel.org>
In-Reply-To: <sashiko-outbox-207746@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Wed, 11 Nov 2026 08:09:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zfU11fP=ekrVfFBb+nj=fs3uYAVZD8Fpm9dAS1fjZnpA@mail.gmail.com>
X-Gm-Features: AclHuK-sb02KucytR3FEDb8aRkGKMDn9o1EWXzBQq9iNIOSpuFJuwJQ7A_HDsNA
Message-ID: <CAGsJ_4zfU11fP=ekrVfFBb+nj=fs3uYAVZD8Fpm9dAS1fjZnpA@mail.gmail.com>
Subject: Re: [PATCH v6 09/15] mm/mglru: Avoid placing rejected folios below
 populated gen
To: sashiko-reviews@lists.linux.dev
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, axelrasmussen@google.com, 
	baolin.wang@linux.alibaba.com, baoquan.he@linux.dev, hannes@cmpxchg.org, 
	hui.zhu@linux.dev, kasong@tencent.com, kunwu.chan@gmail.com, 
	liam@infradead.org, lianux.mm@gmail.com, liuxiang.277@bytedance.com, 
	lyugaofei@xiaomi.com, mhocko@kernel.org, mhocko@suse.com, qi.zheng@linux.dev, 
	ridong.chen@linux.dev, rppt@kernel.org, ryncsn@gmail.com, 
	shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com, 
	weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com, 
	zhuhui@kylinos.cn, sidchintamaneni@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4235CC0003
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: xbci4qh7f5tzejrbdsqh1bkdkwstmojx
X-Rspam-User: 
X-HE-Tag: 1794355775-104132
X-HE-Meta: U2FsdGVkX18lomqSu5TUVbiCx5Ko7cHZh5JhW409T1AfKUdPXRsxGRZhYDo9zGsdGh5zRZ8AF+erkY01Zhm6rTAwOtAKYybDmRawPIuo8Vi4DU64eJ1gyiVuhzzT32+mYRRSnmUYoOxdcIULeubhWctBDJDo4c0S1vrw45LpLcyjVnQj/kquZ8wVsYyq9EXtJ9odIGAkDjLb/PgdpJ9HIThTPoojaxGpll0/pXTZ7y5TpeRV/YKN9f3psPg7HKdqMm2DoxNTOJB51+WJcQfDSsGJHxqFasbRamk0VdSbuHm0wEHdBc9V2zLeB4HcZ98Boz5j2hxTbNfTE2XFurHZWkRSMmy4IlLXIHpKP0nqRDdY+mW33RB7nIwPt5YhblSdP/kLdiwfa0JEhhxXyjli0GHbmYZ/oFj2Xo4NODXiK3MvJc44buo6GW7zaoCSmdm+bKPE3ADE4am7JQCpgDfC6iHKTXxqCI9gcaLotorLu723b7cLPNtk73sWRz4QITu3eOq2B8Gk4kEXX3ANjVfIeUQjMtrhsDfxyQzVL0mZiTytUYgLfhaB9rY1JtiR1Z253U1nCdblX8K42hifIWoWpw/uMmnSyVRW35WWhanXzfsXcgKxm4p9uXsmyOpbBHNMrEsUJhFQX54p5jrBn2ZnXNJR1muKDaN12zRVjuS8QW0RW1OKt5eVo21e7TuQtLUM/zFUPFLn2eRUFlzm2osXjv7LRAYQzUKrzx+XV5xFSphmjPccSeDu7zSEHck0cGFRgL+SzQ7BM6YtgOrRTwDIN2zlQnmgbr6OkNSBfCcsLmQQvXaGkUUu34aP44uXmJyhrUB2wKw82ei+T8RWNi1J0SSVCfho7qbT9ZtKMeBn/1mdFBlKA+cfs3rQSt7y+uOvZVT+E6lO4XZMxBAMhN5ZHrDzd1WToX74whf0YpEAFYJCIxkEXqmPOmPly3kTZ14BaHIAIzpoDPbgHVhff6M
 aZjj51dM
 b2yIs5VM9EryV3jSK4aMmd8rIWLAsmlIMAhTI1Vqr1p7gc8Nl0CKORmfOulAAFQLbEeHyLYjMOBCv+fmUmHtRIGBmvAJtBzCLXFqda8JUhkiQvuBy+5RnZHTS+oddmYAbC1+pSFybFj/kUBicQQrdQjnnRkSswxONNPPyIcla7Xd38or0fWkJb8PfPuz3bAtYEMst6tvQwrvrS+aTNF7MEFpH8ozG6xZGDTZNCPt9j4sGGsuB0Z2/vwDsD69DVpSIJHLP5clYTBUO780afOqVTRdfsEdMtjacYEpMaADzGVZxtj539plEhSW30PnmwaAT0aRiW+uAgKDXrrqQhVi4/mYNI0Q3053yFL7sBoc8YDfug7Uxoe0usfcljBtha4sU1t+1KelLNk+T1O4qJyDIMlq4TETPW65YeO4c1RsnrRB3DEJw1WrCg6OEDd6cUgfUKJfL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 4:56=E2=80=AFAM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found no new issues
> in this patch, but noticed 1 related pre-existing issue it does not
> introduce:
> - [Medium] mm: uncleared LRU_REFS_FLAGS in lru_gen_add_folio() [1]
> --
>
> commit 8ef17c06cc7c92ed5b07f7cf40e28066a3ac2fb0
> Author: Barry Song (Xiaomi) <baohua@kernel.org>
>
> mm/mglru: Avoid placing rejected folios below populated gen
>
> This commit passes the scanned generation sequence number from
> scan_folios() to move_folios_to_lru() so rejected folios are placed above
> the populated generation or in the youngest generation, and removes the
> previous folio_set_active() call from evict_folios().
>
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index ab69b9930893f..f6f4bc9a704fe 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -332,7 +332,8 @@ static inline unsigned long lru_gen_folio_seq(const=
 struct lruvec *lruvec,
> >       return max(READ_ONCE(lrugen->max_seq) - gen + 1, READ_ONCE(lrugen=
->min_seq[type]));
> >  }
> >
> > -static inline bool lru_gen_add_folio(struct lruvec *lruvec, struct fol=
io *folio, bool reclaiming)
> > +static inline bool __lru_gen_add_folio(struct lruvec *lruvec, struct f=
olio *folio,
> > +             unsigned long scanned_seq, bool reclaiming)
> >  {
> >       unsigned long seq;
> >       unsigned long flags;
> > @@ -347,6 +348,8 @@ static inline bool lru_gen_add_folio(struct lruvec =
*lruvec, struct folio *folio,
> >               return false;
> >
> >       seq =3D lru_gen_folio_seq(lruvec, folio, reclaiming);
> > +     if (scanned_seq !=3D -1UL)
> > +             seq =3D max(seq, min(scanned_seq + 1, lrugen->max_seq));
> >       gen =3D lru_gen_from_seq(seq);
> >       flags =3D (gen + 1UL) << LRU_GEN_PGOFF;
> >       /* see the comment on MIN_NR_GENS about PG_active */
>
> [Severity: Medium]
> This problem wasn't introduced by this patch, but should set_mask_bits()
> in __lru_gen_add_folio() also clear LRU_REFS_FLAGS [1]?
>
> include/linux/mm_inline.h:__lru_gen_add_folio() {
>         ...
>         set_mask_bits(folio_flags(folio, 0), LRU_GEN_MASK | BIT(PG_active=
), flags);
>         ...
> }
>
> Omitting LRU_REFS_FLAGS from the mask leaves stale PG_referenced and
> LRU_REFS_MASK bits set when a folio is placed into a new generation,
> inflating its tier access count and causing cold folios to be protected
> from reclaim at the expense of hotter ones.

Again, if this is unrelated to the patch, could you please
not report it?

Also, this is a false positive. If we need to clear the
refs, we already do so before calling lru_gen_add_folio().

Also, in mglru-fg, we intentionally keep some values there for
frequency guidance.

>
> [1] https://sashiko.dev/#/bug/linux-d2209941-6149-4b37-a97a-08c70d875d2c
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261110202025.25=
736-1-baohua@kernel.org?part=3D9

Thanks,
Barry

