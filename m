Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE1E8CD5BAF
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 21:12:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9EBCD6B0096; Thu, 21 May 2026 17:12:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9C3B96B0098; Thu, 21 May 2026 17:12:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D9626B0099; Thu, 21 May 2026 17:12:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7CDD46B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 17:12:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1613D9108B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:12:35 +0000 (UTC)
X-FDA: 84792675870.15.462C0B3
Received: from mail-yw1-f182.google.com (mail-yw1-f182.google.com [209.85.128.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1098218000C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 21:12:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MUfB+3bY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of olvaffe@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=olvaffe@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779397953;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hug/izXxjfcnE4vKgkqAIxaB37uzj17DsXmftmpGyBw=;
	b=Jw4QnNTSd/dmftL8l80H6zEWW4M7G+91FP/PTaZrjHPNwIW0KQQpi/VY2naFNV8qWHkVtZ
	x1SaO3Jhd7YDDoxcWTr8cJYYV7CRkNklRLWxQGh2DV6NdBTpqusbTFiNl7R1as4xi22os2
	A+OC59M3OpGvUc34SR7YxX6xyfRRujU=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=MUfB+3bY;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf16.hostedemail.com: domain of olvaffe@gmail.com designates 209.85.128.182 as permitted sender) smtp.mailfrom=olvaffe@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779397953; a=rsa-sha256;
	cv=pass;
	b=yGzkSIoFZa2FWNK613bs3YZ8lRREyEQzzbtW4Awb1UxdSNb/PsExm/nEuyx2StMNNYMFpU
	8nZ7d/Z+BLGnJL/pvYuoehB8cMf37RndKC2LvMVi+3T8aw6iSIcA9FzuRzU6Bnn6rpmfFe
	2rr3Tc7/ys3hxgQhb5f0+Xq/0URqtds=
Received: by mail-yw1-f182.google.com with SMTP id 00721157ae682-7bb0d18c7f9so60430637b3.0
        for <linux-mm@kvack.org>; Thu, 21 May 2026 14:12:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779397952; cv=none;
        d=google.com; s=arc-20240605;
        b=XUG1F6424/XL+nSUuRbBBor9b/cT0gVBKjtkAVO6/mDbg6qtYXF2QhyO5hfPUEEmid
         LRlfmFCdAf8zTJbr+ed0HI2jsMYhM1YtYRl+1xPSTR4g0c3vC3K9t2/Wg9C1zNJ8QTiS
         Q29htfPqF80BdvZz8cAIiHUR3gS17N/W+gqpwXI/PvV3hpXjQjk70ild3ma/KjeCa23w
         j+Qw6c1NrYf6Wbk70E7PDh6qrVn4WN9LBsR5qIfXlC0h0Su+j5nE457ZaCa0HWtxtd3k
         HlkWgDufzKDeYlbF6aMtifniF6DqreQrtIc1eecQpVORBtpq0X6INf2ph4C/43xAgln9
         AP6g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hug/izXxjfcnE4vKgkqAIxaB37uzj17DsXmftmpGyBw=;
        fh=2BYG8znI+EGFufuK5hDi+Po0CMShyRJTzIpwHZWBY/0=;
        b=Ms7WAMHAPMZBPOnA3kd03N2B5ZeIIuHWprUOtVgD+2es/4L4eqazCicIc5kcUxKBrG
         oE/REe/tubyIkwx77ozDL+hNhfDJbHALF7+n9qVPcymKCmBsgOtGpMe99xponYza+RPB
         Ozzu4S9ZBj3btgX5H6IshjpEyUni6f+gPkoLNk9uqAaiGssQQ9wBNOybFVhJ1p2vlYUi
         covyCu5QjsIgrmfZJCC3VFFaywkgosaYo819+TJH6I4XIzJXORjYMTDGJ9XsA7CHlgbI
         NCkCqzEWTGUE4W6ZczWz7gfSwPh90Nft3q1JG1d4EQpKU33hcRs+lNjZXj21lE52+Ocy
         SiEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779397952; x=1780002752; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hug/izXxjfcnE4vKgkqAIxaB37uzj17DsXmftmpGyBw=;
        b=MUfB+3bYr3uhP2ouuzLrv6AU95nJIBVCRtp4STQdMMos+Hqm80trldj0egJSTskRWi
         Z6W7Jj8TMILTW67xuCBGiSAyzQ4OdMjrvNUkava1O3tHDentpX847n6ogUuAHDV0e0vc
         QQvA9lDs+F+9Kjc/iA2+B5BTFNRFNA3ykUyWlosfyT5KxUhke932fQErdTOsTMNDvX3l
         +EYJKKhbDvoVbQ0S2bnYcwZ8pBXLLj6vMt8oz0eMBnNb3fTOgKtfZvodh6JmdyN6e3Dl
         GBJzOenmVvcLy/EYWFV4GebtqIcp1qFszRdI2U5NdvwZ3KjH+u8GiL2u2W7+qHZASTQJ
         OUIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779397952; x=1780002752;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hug/izXxjfcnE4vKgkqAIxaB37uzj17DsXmftmpGyBw=;
        b=MBPjcrpL4kpZGloBvrnvOz9L4LQcH/3AzhzdnczkpOYrG13WR2Wid++927M36k+De1
         UB/RjbpI1r6jl0kbyh4YXXCjZZrS2CVVpu0DbxaDywilCP4KvM8pDRJlOwqGQ2INjzIM
         f2nU5hay3tr5UW2zCVzrQDnnXBBp4s19Y/6rzP82hYTcozvRzIESBcx/iK5LR3TlEmWq
         4C0jtsJArTqoqx2JdiCwzURtBRBs+avtkVbPY/dgfn7E2pzfc5XLqYaE4hQ+p2fANE6B
         Wg6uz9+oSPMf6GG/xZOAyvNU2HrtvXrFIHImXsNoN2zm72pQ0qAoNaWgzwygnnVmhMjB
         fUkQ==
X-Forwarded-Encrypted: i=1; AFNElJ+41hsGM2I/nL9vAjSXrBx+exRF5I1csFcjHfuVKJsD5YtHy1kwECuDst063OPdA04U+fkdgcoB6A==@kvack.org
X-Gm-Message-State: AOJu0Yw9SG/zbR1MBuj68jH7wZOORyYx0l1qtNNBwKur/ZaoW4uUeEzY
	C9Pay6N8abYCFwXDQKzEB6sTLI5quHYy8g1joEZjXSloKh0RWf7k/AvtMAaaw5tzs5PiVyBvHbh
	lS1aIlZCHfKSHh1cYwquT7pRUap4NZWI=
X-Gm-Gg: Acq92OEh7soyUWIYqYSivXyMXa1WwAYI1YwuatcFBpWjXwVCVsRpRkqL00KEwG+BhvJ
	VMfwB5Mqk6GQaUix5OpL/q/tlzRefdrhNQ0La1aQ0yATZ3KOSIL2bRpzF1lNHQSPlKMcP0uAZUZ
	eIpbM4IEByX5RRpfmsgCEUP7lu4hQ2LmH+e+JN+LfD1XNwluJBezgFNgpm+F+EZxN0PpP2FamUP
	9nSx8YHRh6of2JeHHKkVgW/3zSsG41R6HL5NJ5BCxtrkAHD7oxjaNfNq9Pkb7C6K5ABGMU89y5z
	Q5htG/wpB9UpIb8xOrXi7wFwSA77KaS7lYTpPRUbNdmvHilF/KUarYwxNJUfa/KUIvvXV51S
X-Received: by 2002:a05:690c:6a11:b0:7a0:4146:6eda with SMTP id
 00721157ae682-7d338884b2dmr13330187b3.20.1779397951961; Thu, 21 May 2026
 14:12:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260519-panthor-kasan-v2-1-b7384458f076@gmail.com>
 <72bec63c-09f2-4a97-908d-3e6af8e3e0ae@linux.alibaba.com> <CAPaKu7S4JCRiTyYvTgXHKP9osH8yh8YVzXiPQuNVAV9pBZtmuQ@mail.gmail.com>
 <aa244c61-b936-4c53-af7c-2f5190867a7f@linux.alibaba.com> <20260521105148.5497c281@fedora>
 <CAPaKu7THqu4=rN26jtjNS5EPvSTzfoMqG5n4bZr_3Rh4ngSvqg@mail.gmail.com>
In-Reply-To: <CAPaKu7THqu4=rN26jtjNS5EPvSTzfoMqG5n4bZr_3Rh4ngSvqg@mail.gmail.com>
From: Chia-I Wu <olvaffe@gmail.com>
Date: Thu, 21 May 2026 14:12:20 -0700
X-Gm-Features: AVHnY4Ing4YTYNlTCHVZK4ymzyl38iI-WRnsIS2UArQDk1shX7jFvy5ly4Q4njM
Message-ID: <CAPaKu7QD4wvR=QRN7YbafwQfYUBSVefapFB1myceNrEDdMWDRQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] mm/shmem: set __GFP_SKIP_KASAN for swap_cluster_readahead
To: Boris Brezillon <boris.brezillon@collabora.com>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Alexander Potapenko <glider@google.com>, Andrey Konovalov <andreyknvl@gmail.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Kairui Song <kasong@tencent.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 347iwxrqm9cgoee9nq61mnxrzby7bg39
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1098218000C
X-HE-Tag: 1779397952-450783
X-HE-Meta: U2FsdGVkX19JqasTf5fQvnN3idFIQpgdCzkBT9B7/yVX40fXx+Eri+Bt09I0ZvzyXisAvX0WFAk0twku1t3n2TXOUAGjKoG5zIfECONA1m3rFoPyjnwYHkeZaonbyYKBsSNfuFDH6cUtWtzkde8ku1nRB6kX0GPUCHKUGASaYATJM2xv0qBg2jR2nd6SEgQugTsFT+RM3gD3sCu05BKcx67Ln7WCiJzj9o179MPYRkCwTgX6pnMN1ekWXOszBK0T39tBaPlZg4+kJlYjaQpWUCduUMWF70GiJHXbWKNrsxEbb1dLOsbcyGpmTv6R7zxxutUl+lr6jQw2cu3Vo2kBjRnmsmztC4OVVYWiSusXpF91FKRfdLLCRP8YfieoC7S7+JAkcDm81gkb5Zj3/f8+8oERwqVSew/TZycxyTIKjyammotto0dIAo5g+C306TGCt652fxWg41ZeDE8zpqztY+oF5wIJ/+nv/I/b3m4saOhl01y1c8lLFKtKs5X+yVxRduvweCvH423c7vfN+0tT1AAClvAlhA9IfW5jX/Yshs0Pjw61RnrgM7VrHPzbSNG9hprhKdd8gYMAvr46V0aXHEfSGG4seZPolPO7df39q7KqwU3BmQrQWy1J8JSW0SfwvVXWXjPhh5aE9aHGBLQ6Q8P1OdTjBGUSl1mo7MoNI/59N6GdcKAIEaca9ZTIPy7R+9C9kh1t/Yl1CGimgiZh+2PrmM9R9z/ra0NcsvNQuxkKvR9LB8+KQqidupISgxfKMkuvzaYrpR+dZNvoF5hq55qBI0EoWEomo1glvxi9QVxXi6epsAJZKHVW9XW6lkXjc0XTVlMBKcTVt4Iic9xGbAYOoe333FtowmmctR9Yqc130jyPLquDe3cp7p8hjwPHI8tPO7qDRLZz2/KPQZkp9hIW5Jrcoj5xDen46ecGVWRDhcT8kuvK43/QXiz8p7RLM1acFjU5xVXte9PtMw3
 s3HQI1Go
 IVwTQEQr9MGf71y0KxJJnws1shk7pPTkzISK5oBlmAQ3iKHH0XjFOxJ3hCW9JN9h6Tf9TOYDG5qnBn8QATKIpfOABcr06nW1ah9SuOR6xEN3FloNGzsFHTjrzybrTmde8XVwouwPPE8n56RbHgayxznrUCc+722j1XVYP3dXI0np3+Vc/Szpkf/IVSvoiOHJO7HxxFnjuRXgWgeksUA2/QlP6Ye+dXGWOQiXroJOqpygR9hARIDhy1yzYZJkroiJAJiNXDcuzFtTmEiVn/O76jyJd+yU/uhkEQZTxiLWiOpnMKK48iMTD89F5SdvrKkga3B5saZzqx1q8NWSKv0By6zlqHQYL0QxR/QHQ4wYE0GVAC02b7/QcHEVGJjJ8ei7QNbmld0xApO7bLYTyLJwWe5Q6r9nq5C3+tNXUtVLYMsZR630ZucQAWwAWppJeGx2U9H+Ic5Qhfs8A4Fwg4/ohdpVc8PAAOg0Z+xVzovyrUcwl3yZo5NXdY0Xw1njqos5Gt59yPK96rbUfz23oLY2rQ8ZhYCt5FFRSnNODLyAhxgClvAe6zoSZeB5z1abjnbm5tvtMY7dsykr0lXpXMJ8uXLIEJu2pRITMtLC2EW9yTMFbU/H5iBDtmnHY9cs5leLbFH9KLu4P4rQRvqcxi7Co4ePDDONB3ZMy6Xcdr7VfFPSfBZEHkgSrNPUw2Tz+/fUNIsW193chBvRpFPdFqw3qD82EVC+S9NXBX1roRA7L8XjQEFs/XZA5qOlejNnDHXzmk5Ze8j25NnbxvB4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, May 21, 2026 at 8:49=E2=80=AFAM Chia-I Wu <olvaffe@gmail.com> wrote=
:
>
> On Thu, May 21, 2026 at 1:51=E2=80=AFAM Boris Brezillon
> <boris.brezillon@collabora.com> wrote:
> >
> > On Thu, 21 May 2026 15:05:21 +0800
> > Baolin Wang <baolin.wang@linux.alibaba.com> wrote:
> >
> > > On 5/21/26 1:06 AM, Chia-I Wu wrote:
> > > > On Wed, May 20, 2026 at 3:04=E2=80=AFAM Baolin Wang
> > > > <baolin.wang@linux.alibaba.com> wrote:
> > > >>
> > > >> CC Kairui,
> > > >>
> > > >> On 5/20/26 12:31 PM, Chia-I Wu via B4 Relay wrote:
> > > >>> From: Chia-I Wu <olvaffe@gmail.com>
> > > >>>
> > > >>> swap_cluster_readahead can allocate folios for other mappings. If=
 the
> > > >>> gfp flags do not have __GFP_SKIP_KASAN, but the other mappings ha=
ve
> > > >>> PROT_MTE, we can end up with false KASAN errors such as
> > > >>>
> > > >>>     BUG: KASAN: invalid-access in swap_writepage+0xb0/0x21c
> > > >>>     Read at addr f5ffff81aa71dff8 by task WM.task-4/6956
> > > >>>     Pointer tag: [f5], memory tag: [f9]
> > > >>>
> > > >>> In the above example, because __GFP_SKIP_KASAN was missing, KASAN=
 set
> > > >>> both pointer tag and memory tag to 0xf5 when swap_cluster_readahe=
ad
> > > >>> allocated the folio. But the userspace had already set the memory=
 tag to
> > > >>> 0xf9 before swapped out. arch_swap_restore restored the memory ta=
g back
> > > >>> to 0xf9, leading to the mismatch.
> > > >>>
> > > >>> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> > > >>> ---
> > > >>> Changes in v2:
> > > >>> - set __GFP_SKIP_KASAN for shmem instead of drm/panthor
> > > >>> - Link to v1: https://patch.msgid.link/20260512-panthor-kasan-v1-=
1-d8d3e275d71b@gmail.com
> > > >>> ---
> > > >>>    mm/shmem.c | 5 +++++
> > > >>>    1 file changed, 5 insertions(+)
> > > >>>
> > > >>> diff --git a/mm/shmem.c b/mm/shmem.c
> > > >>> index 3b5dc21b323c2..db9130a8c5b76 100644
> > > >>> --- a/mm/shmem.c
> > > >>> +++ b/mm/shmem.c
> > > >>> @@ -1784,6 +1784,11 @@ static struct folio *shmem_swapin_cluster(=
swp_entry_t swap, gfp_t gfp,
> > > >>>        pgoff_t ilx;
> > > >>>        struct folio *folio;
> > > >>>
> > > >>> +     /* swap_cluster_readahead might cross the mapping boundary =
and
> > > >>> +      * allocate pages for other mappings. We have to skip KASAN=
.
> > > >>> +      */
> > > >>> +     gfp |=3D __GFP_SKIP_KASAN;
> > > >>> +
> > > >>>        mpol =3D shmem_get_pgoff_policy(info, index, 0, &ilx);
> > > >>>        folio =3D swap_cluster_readahead(swap, gfp, mpol, ilx);
> > > >>>        mpol_cond_put(mpol);
> > > >>
> > > >> If we force __GFP_SKIP_KASAN, would this cause issues for mappings=
 that
> > > >> explicitly should NOT have the flag? and your v1 link already ment=
ions
> > > >> this scenario.
> > > > We lose the benefits of kasan hw tags (other modes are not affected=
)
> > > > by forcing the flag.
> > > >
> > > > The other mappings swap_cluster_readahead can affect are anon
> > > > mappings, regular shmem mappings, or gpu shmem mappings. I think on=
ly
> > > > gpu shmem mappings miss __GFP_SKIP_KASAN. That might not even be
> > > > intentional, because gpu shmem mappings pick GFP_HIGHUSER over
> > > > GFP_HIGHUSER_MOVABLE to avoid __GFP_MOVABLE. That was before
> > > > __GFP_SKIP_KASAN was added to GFP_HIGHUSER_MOVABLE.
> > >
> > > It sounds like the right approach would be to explicitly set
> > > __GFP_SKIP_KASAN for GPU shmem mappings, no? I think having users
> > > explicitly set __GFP_SKIP_KASAN makes the implications clearer than
> > > having shmem core set it implicitly.
> >
> > It's a bit of a shame that we have to explicitly set this
> > __GFP_SKIP_KASAN flag when we select GFP_HIGHUSER though (means a lot
> > of patching to do in drivers/gpu/drm/ basically, because basically
> > every driver relying on shmem for its buffer allocation uses this flag)=
.
> >
> > Also, it feels like KASAN poisoning for these pages would be interestin=
g
> > to have since we know we won't allow MTE_PROT on userspace mappings
> > anyway. Oh, and some buffers might even be kernel only (no mmap()
> > allowed), which makes them even better candidates for poisoning.
> >
> > >
> > > We could also consider adding a VM_WARN in shmem_swapin_cluster() to
> > > detect any mappings missing the __GFP_SKIP_KASAN flag.
> >
> > If the general consensus is that all shmem-backed allocation must have
> > __GFP_SKIP_KASAN, yes, it'd make sense to add a VM_WARN.
> >
> > >
> > > > I guess what I am trying to say is these are all user pages. We hav=
e
> > > > to skip kasan when user pages can be mapped PROT_MTE. The
> > >
> > > Yes, regular shmem mappings typically default to GFP_HIGHUSER_MOVABLE=
,
> > > while GPU shmem mappings are a special case.
> >
> > They are not that special, they are just not MOVABLE because the GPU
> > might also access the same pages under the hood. If it's assumed that
> > any page being exposed through mmap() must have __GFP_SKIP_KASAN, why
> > does GFP_HIGHUSER not have that flag too?
> It is also about whether PROT_MTE is allowed. This becomes a problem
> when both kernel and userspace want to modify the tags stored in MTE.
>
> Another way to achieve the same effect as this patch, but is more
> explicit, is to have
>
> #define GFP_HIGHUSER_SWAPPABLE (GFP_HIGHUSER | __GFP_SKIP_KASAN)
> #define GFP_HIGHUSER_MOVABLE (GFP_HIGHUSER_SWAPPABLE | __GFP_MOVABLE)
>
> GPU drivers that can swap should use GFP_HIGHUSER_SWAPPABLE. shmem
> core can warn about missing __GFP_SKIP_KASAN.
>
> >
> > >
> > > > justification for gpu shmem mappings is that they cannot be mapped
> > > > PROT_MTE. But if readahead can affect non-gpu shmem mappings, it se=
ems
> > > > we have to either force __GFP_SKIP_KASAN or to cap/disable readahea=
d.
> >
> > I'm no MM expert, so it's probably me not understanding how this
> > swap-readahead logic is supposed to work, but the whole idea of using
> > different flags from those that were requested by the f_mapping seems
> > fragile. I mean, this comments proves [1] it's not the first time the
> > problem is considered, and I'm wondering why __GFP_SKIP_KASAN should be
> > treated differently from zones. Yes, that's an extra copy if the
> > SKIP_KASAN flags don't match but the zones do, but in practice, won't
> > we have GFP_HIGHUSER and GFP_HIGHUSER_MOVABLE in different zones? Or is
> > the problem that, even with a copy, it's already too late to restore
> > the flags because they been overwritten during kazan unpoisoning?
> arch_swap_restore is called just before shmem_replace_folio. It is a
> bit too late right now but I guess it is fixable.
>
> But shmem is not just a victim. It is also an offender to anon
> mappings. We would need a similar replacement logic in do_swap_page
> for anon mappings.
Come to think about it, that's not how things work.

Regular shmems and anon mappings set __GFP_SKIP_KASAN because they can
be mapped PROT_MTE. This calls page_kasan_tag_reset on the pages.

GPU shmems omit __GFP_SKIP_KASAN because they can't be mapped
PROT_MTE. This calls kasan_unpoison_pages on the pages.

With swap readahead, no one can expect the right function is called
anymore. The question is can we detect the mismatch and call
page_kasan_tag_reset/kasan_unpoison_pages to make things right again
in places such as do_swap_page and shmem_swapin_folio?

>
> >
> > [1]https://elixir.bootlin.com/linux/v7.0.9/source/mm/shmem.c#L2112

