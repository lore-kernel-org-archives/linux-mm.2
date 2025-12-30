Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D698EE49B4
	for <linux-mm@archiver.kernel.org>; Tue, 30 Dec 2025 21:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85D986B0088; Tue, 30 Dec 2025 16:28:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80AA06B0089; Tue, 30 Dec 2025 16:28:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70DBA6B008A; Tue, 30 Dec 2025 16:28:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 604F26B0088
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 16:28:40 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 184BDC1324
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:28:40 +0000 (UTC)
X-FDA: 84277426800.13.AC75BC5
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 47F0B40004
	for <linux-mm@kvack.org>; Tue, 30 Dec 2025 21:28:38 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VyFiI3ea;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767130118; a=rsa-sha256;
	cv=none;
	b=T89eU+YDAMGYKs1o3s2yNPe/W4NuKgirt9wZgrVrFrroA9w1D4vtQxC5q6ipCl+BTa8lYu
	Iit75ol///rcIn8PFz/nmumtH0AKhPNqw+4qHWwgmv4mPcAkqABjDgyiXbkDyeAubGlw/M
	eFSMKGjxjj52hVRvCC0igc3YSX1vPFY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=VyFiI3ea;
	spf=pass (imf27.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767130118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Wl8MJl5xjhMKN5x7idTaTMq36HAT13FyBKGsWvOe0zA=;
	b=qm04x0V+kkJYLl7Y5PN7TX/O4yVwtdXb1ts5agi4PvQdG94271KcVuBsILwjFD68LhvX/F
	r6WL7mHGkT2iHpcsI23Jn9p+x5XqQrakCIWuT+S7j5kl3W1BRFzRjHFSLksEJUP93AhbSs
	p8QzM4yigR3Nw0hPQUXQ+J4wexAdZy4=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-88a288811a4so116406576d6.3
        for <linux-mm@kvack.org>; Tue, 30 Dec 2025 13:28:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767130117; x=1767734917; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wl8MJl5xjhMKN5x7idTaTMq36HAT13FyBKGsWvOe0zA=;
        b=VyFiI3eao/KQFuSuNmQCd0ZNKb5cdVAJVdJ3NOIqE+VYt6DjCV0OPEpMOMyPiubaf0
         /Iyub6Lcqm+t4l5YMrbFfiQnSbHP9b2UBxmnhLtsVVIcUe2rb3QL3ZtxyTFbnGKkFtCu
         TPu0xAMP0e1mOO+NQZbJ2icOdmi4q6kxAwR48tLqmDSZTIHwTT3kG7JXsBbnAm6fpOAc
         01ppIPUVc00BA91FI+eu7j7Z3qizgvUIrgoVt4AEJGc2UT/U4rTeDrMj2ig43W58QV8P
         LHTdUF8AM8HEHvyZFjKFtr69H2apA9XOJJojD+p+RN+HDwp5GfmUp26IQwPTZS0KoG0I
         oMzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767130117; x=1767734917;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Wl8MJl5xjhMKN5x7idTaTMq36HAT13FyBKGsWvOe0zA=;
        b=Za3+ZOoEtFP9acHQgr1tiwvriBkD5vnoFXWTfjglhAZy5T41+yInZEsNU+S+BmmDav
         pSx3vGh7WSmCvaEaL68ONW0iKuQI24lgzWy1msTSmzOgdUJfvC9Ehud8vhZDiI4Zd9cR
         Nbh0exhtCAevafnCnw08N3tDktiwuOuETPwZ7hqLVsodRMD3DUTZyRJznvCT/2WAgMFW
         LGSUeTVmU2RugteCcsi6RTS6ff2cfeBvP3U9JUj/NLBoshQq7v/CxHuDtQsxS9WhUOMO
         HL2fWGjRXCgqz2MDpppTTfv8UKByOaaiVaTMci+E7bdXDVqJCIDZI2xFWOrsIJff95Ax
         BV5Q==
X-Forwarded-Encrypted: i=1; AJvYcCWxqUKqltdN0k5tFbeweAkyVeRbVX295InAiyipQn2tcpLjEk3pRC1AEDkivxvt0qiPoXapNGZDXw==@kvack.org
X-Gm-Message-State: AOJu0YwJk/YPVFDzN3vLhU/OYnD/Q8FrjmckIuU8AN+OifC8OLYPz/Lw
	9WhXe+0MyBfcntingQZYhcYCxXTKBfAn/Px0ZkibyAnMlTAv0SVTNxgCOU6vEjx56y5srQyBaML
	HPDYrflx7GqIVWxCuENocFLXR0L0qO1g=
X-Gm-Gg: AY/fxX42YA8InF+JPRLWJ+EUbtjmuBX6c96t38rjmRFGulV8bp8q4nnqplCwvsgdvPf
	PIOMFoE99tVJjEXD6BBm0mPKnRev2xpUYCO8f20pzUe4jwpo0bEFdOeCFiyURE/UvIpDjplLhD8
	9l45Ltu/kpnao3FzRQ/N0WRujepImNycyHwD78dGYRwjCGOk18fXfkvq3jhEncNF/cLmlMmniIj
	TE5lHYuHaUw03TVMIYGsGiIpQdsVi92/8U8VWhm8O96LqzcFNuTH4b5YU6noPibW/tmOQ==
X-Google-Smtp-Source: AGHT+IHK6iUXK4O2FjWbiuKko6BqfTjCmwioqFyNTMNva06WBEbn4DaE+x+NHDutsoUOQOCC9hYzmZcbMsu+Tfxl2SM=
X-Received: by 2002:a05:6214:568f:b0:88c:5888:9690 with SMTP id
 6a1803df08f44-88d837933aemr657165516d6.37.1767130117274; Tue, 30 Dec 2025
 13:28:37 -0800 (PST)
MIME-Version: 1.0
References: <20251230130110.1366374-1-wale.zhang.ftd@gmail.com> <cb69a1e7-e836-4115-8733-12d2de879f51@kernel.org>
In-Reply-To: <cb69a1e7-e836-4115-8733-12d2de879f51@kernel.org>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 31 Dec 2025 10:28:25 +1300
X-Gm-Features: AQt7F2okIg7ROlhTPq72Ax5tD78usjQfMKe7TrJvJV-EG1QlTNuWcSQ3-NXq3_4
Message-ID: <CAGsJ_4w=KuVs5+p+3gZ=L7=rzA3qgnMVQOBJNBEPnMDWx2N+dg@mail.gmail.com>
Subject: Re: [PATCH v2] mm/swapops,rmap: remove should-never-be-compiled codes.
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Wale Zhang <wale.zhang.ftd@gmail.com>, akpm@linux-foundation.org, chrisl@kernel.org, 
	ziy@nvidia.com, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 47F0B40004
X-Rspamd-Server: rspam04
X-Stat-Signature: ee67bysogdwhxhdqogf1ocjypjkmns4k
X-HE-Tag: 1767130118-659000
X-HE-Meta: U2FsdGVkX18gPe/l0lDu8/QUPpUvuTfRFRdoytzIpvPSYsKn1gAFRsjx9ePzo2sHVo3TOKpJWywJEJvVbEc/i2UCcyGEZ4xV8MD5xUmY7alzf5z2Ua/8dQrbJDy7kB+pHMY/LM1OuSXUNvgZGGrNWD52lacyzi86n2TdbMor/ZmGNvEkA8cuVknwkjfsdMos/GeJfkhAoyQgLBkrKQllHS4yO2LSTGR3VhODIAnqiqHyYCRt/sdOgYnFcTwDZIDpUvEnitskEZ7BQq3YdvxlUr/mTfg7U/3gFdLxq6kIjdJfckL7Bk56xffxJX830uMIn4u0sN9oZuipsmOpJ63Njrl6arTbl54N7LbufxTgMssRyT2krtipEjs8R7aIM7dgJYej16to+xXq52CbkhzslIlPbUGrJNUhcFhNIZaj7bJNVBhXBVq8TRubOhyUbU5QEIXSb/HS6jnsoaklZR7HT8kbMA9fTf7Q2c+Kkoa4haksxdyWDut2vYNV1B2ihofjW4RyFirdC0sP3QiykJojPXefi0ZvwTlMPsueIsjEGhUeHuvkKDxSH/E1Q6/uU0Ss+yr/HOi7DS3pura323iLHDTRPEJWy9dX/pFwP8qls2k00F3+aNiHYJwhhtA52+CE/5P5KhFP1aQmA5KD9t/nWJStUzsW5J3tI8xI6ZdHNjKAsHe0PAhN18hy7CUTkBrANSLvz1l6s7Wqok7wr0PdsnDx8NTbREJOY4y8YbrnZNbPLJtsoVQGJwsR92pcKaFJmFTdDJEsJYylWhhYHp5uZgFGXwMo0m/HEvCTMw+wGVeuXDFIed4+YrQwGIQdRnw2qRZEKHc+hkecs9e4KdguyXufUIJcmfH3eMxQIdv7VyVA5Lprwnb+NQBdDB4AofCvUQPO3HjWIveGlx4X/SvdbnOwDAa5jcfRerUj81Pys5rvD0VmU/CDhE7VoeFh3SVVq/WcWVwslBMn2lqyTXK
 KSz8wq1l
 FJUHT91AoPQW3LiCs7NAYG8NTC5BUWe2EychbX0wFV1NmHpajNBK7D1fPVvisiNpQn72/BxgGq+Azw492AIH16oI+wj+0AiZ0sSAlRMmPxcW6RbsFnjCxf/4ww4GW4aMid+h2nj6xfOWVyrfRx+ykFQ2KlJ8EIu2qDbKzdHmQ3KoIrY8GifY7lFf9L4f2+DMCv5msBq98QRyCzZtggIQG3lvdikXuM4VsbYEq3OUPCPps+iEjXmwRZwkNZtByX06XmYgnFDWxf9wEPh3sjwsfMBk5jLMvz1K142sjWbMWOw7TpMHbjDEq45QH4J1aiiGe1TK4uu1JQMHDnLo8s0NaOlN0P0lXOAzZeLMRkxD/zh6HAtBP4TNWthC5lj7RDXdhND81y8Ve7l9JT78k0Zvnt2jKj7VYHm7REuuhybAycNVYWg/64r8aefy0kppgPFgpn2Zw
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 31, 2025 at 8:50=E2=80=AFAM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
>
> > -                     break;
> > +#ifdef CONFIG_NO_PAGE_MAPCOUNT
> > +             last =3D atomic_add_negative(-1, &folio->_entire_mapcount=
);
> > +             if (level =3D=3D PGTABLE_LEVEL_PMD && last)
> > +                     nr_pmdmapped =3D folio_large_nr_pages(folio);
> > +             nr =3D folio_dec_return_large_mapcount(folio, vma);
> > +             if (!nr) {
> > +                     /* Now completely unmapped. */
> > +                     nr =3D folio_large_nr_pages(folio);
> > +             } else {
> > +                     partially_mapped =3D last &&
> > +                             nr < folio_large_nr_pages(folio);
> > +                     nr =3D 0;
>
> The whole code was written to avoid ifdefs.

The #ifdefs are only for -O0 builds, which are never a
mainline requirement. However, dropping functions that
contain nothing but a BUILD_BUG() seems reasonable?

If those functions were actually required, the compiler
would fail anyway. In that case, there doesn=E2=80=99t seem to be
much value in keeping wrapper functions whose sole purpose
is to contain a single BUILD_BUG().

Thanks
Barry

