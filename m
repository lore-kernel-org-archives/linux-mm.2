Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D456EC61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:49:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9C6F6B009E; Thu, 27 Aug 2026 13:49:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C74526B009F; Thu, 27 Aug 2026 13:49:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8CB96B00A0; Thu, 27 Aug 2026 13:49:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 81F9D6B009E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:49:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EFBBFC010A
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:49:09 +0000 (UTC)
X-FDA: 85147785618.02.16A9129
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf18.hostedemail.com (Postfix) with ESMTP id 1816E1C0003
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:49:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UycZiJ/t";
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787852948;
	b=G11q12OQTgYE21y/RdYtm6OREdTDVBwKaAumd837sakI4OGpLvdtezmAV2Q4Vw48FP+dpk
	eO9qCR0f0MWsRX4ndPfenaqM6IrrVgdAUjF5pA2grhczGMeLZZaiZ9K29IV6wD0ywVvFem
	RZYo+ljZ2gcPcagmNwLQc9z1FH3PDKE=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="UycZiJ/t";
	spf=pass (imf18.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852948;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yW6biE5fdFGdJHeb2R6IVd0GCVVjxtlUxzSI9ivUYnw=;
	b=6g7xTOeawnkQSPUSSV2pLQW3PXMAqk/xQ8sBwvzHDHB+VOYcVaXmvKakmB32h4DumJQLI3
	TR5e3rfhvWgxkQ4VNYWlDq1N5x9i0QQiLYklTZogO556yUsbkvt8Ct6V3hevSlKeirMBmV
	Wq1syKEAxqOQrnX8xZOSQ3AEghAAL0c=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6a41191c9a9so117802a12.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:49:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787852947; cv=none;
        d=google.com; s=arc-20260327;
        b=nlF/zhf4rEHTjkgihotjRe5bmnS02tK14UrOL5SuftHeBIoexYvkY5asyWwXibB/TP
         lWwbckIOkGnAVhLJaIF81h9FMzwlMQVnwiHKATu2rcMcXVdxvWwQE/uf1xPwktDGpYEP
         owEWOhAFSZWmqs15oD5AKIabq5L40FH2n+IGAAecllrsVE0HSYVt+O0tFr8Xt/mgInbi
         7zSJ+TMCZwFETZOJ3Q1iaubo/D3xK3d/xdHVLXNBiuOjvikqWTAvROPkkAvt/1Z1ARu8
         CC6t/lnBlq0F8XrG70BVFL4PqEeMUJ53AbkJV7MsVdM96Qg5TgkjuuJzytxJLmKIKsyB
         CgjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=yW6biE5fdFGdJHeb2R6IVd0GCVVjxtlUxzSI9ivUYnw=;
        fh=zSqwoe9TDW+vLpRbTLVJT0aySUskQcMP6Rymw9YBM/s=;
        b=bBz2BXmHObZ2FOXhMH16TALIpQoTO7Qw6NUqQyalzZPGSxGs0qFx1tzxDfzY/lzhxe
         31obIZUGKL6Jt5y30VGslJquqTSwNt6CCOsYwFOubiQnfBOSZ3LOcPTZuCVILWvisu+z
         wfThr/ufgeiX0HTHd/CDlZSYRV92oHdBB1FcH7Lqbqn20e8ahrj/6Q1B54aql6IzrDYg
         nyjDfk4NhSLIyQ7KQWax+7Fl004AYK0h+P+c6mmX22Tq4f5dHF0v6IsbWsGzdk3du8Br
         IB2Mc7i3o+6jxmiBeCUYAm8FBxFwLV9sE2eMn7uXZPfk5IzpeJcJ9BJOewJsFNOPyIJa
         X25A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787852947; x=1788457747; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=yW6biE5fdFGdJHeb2R6IVd0GCVVjxtlUxzSI9ivUYnw=;
        b=UycZiJ/tNxWjbZdmeQCLP2MZjNSRWi29OGRmn3mlia2zXjCdkcztF4eY03temMLFFo
         btSiL6sRLajbIedlf9Uyj/BVsEFJv6g8NbquL8Aoqf8r40Y22rZfJg+P1BctPUFBqKdQ
         wFWprRkgbbINIhJd2tsTS3imxChSvmND6nBH8rk9BiHi37RRBe8obHwgUt/z62t2ltgh
         ihdOK2nD5PEjITHwNG14UvO9O6l/g1R5QlBrP3rpuaWUnEh7gzbhj3TBH7D4grOguW6x
         DZDMdbKGjAkh2hwVc0aeQzai1b5+gCuAMM2BYfupqkg1a2TvKN17GDfKbD0QiJGwZpAW
         wI9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787852947; x=1788457747;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yW6biE5fdFGdJHeb2R6IVd0GCVVjxtlUxzSI9ivUYnw=;
        b=CAt3+j4HYAJMAEcwPS3HAEJVMDITP3Q73WYs8znf6AGZxjShgqW3Dhzugg7Bm/mMXy
         wArpJeQara3JWc4DUqROZqgVOv9q7Cyg65SxnoPc1BtJjy8lomJcANJCxWmzO75svZFG
         /nx2YXxak2VC0s9LJ81atPD1TTvLfJd68TdVZz5BNfuwJz/6zWp40bxE74A0wdIsTPVX
         39SdH0bTK+UE24XvZndBByGJUqQ8IEmnKHulnYUV6yCs2SxkxVuYdhW9rOt9ZonQYlu6
         8gzSYEaoVnrw5hrQVL80LXXoMS53vQYSMHfBNu7x9N5Q1R0p+4iXu9HwzHwJyhXRyhEo
         usOQ==
X-Gm-Message-State: AFuF++ngZbvtnnWKPcX8npGBAomRgzfzHUlgHOt+xHSIAjIbfRp4/Icc
	ijtZjUCoazDQqPOHeI69HAKli3tdbDcpLWfMMaKjIne1OvSfhCopxTTyuWVsrNZuHE5K0uqdmdx
	YtUcfBDlVavi8Y5UbFjKn5tIg70FgMg0=
X-Gm-Gg: AR+sD11pG7fPVA0QuWK+jh9D3qtV0mNB1wKnOsfXDg3CeDAYCR1P0NKu+6fZ02uS4V4
	7bq6DRAUbgN2ijXR+Yc5IR/IVNORLEdkwHBBxZ7g9v0GfjVj/YngvWjBpJSwi3u9pBHOrDZkn0i
	N/4i+O2RPvfC5SejoDWEVon2pUnYDh3OsTa3zOR7Qk2riO+Gtu3/8Tdpjv1OfTxH4c4qq4HXLnk
	pJy6xYcRNjPNfgpUjiEsh/Ucbyp5/qh4y2ZrlZYYmXLUO2EvxzcvI3stWGm2s/t/euDhs2FutQY
	cVkyzK783w8Kfh8DsUQvAHeT2JlOd6ssw/X4+u2asjnlIOKT81XC5D3NEBGYO91kXAdcc545Mbg
	ZtGLt/tzWirTv
X-Received: by 2002:a05:6402:d0b:b0:6a6:4a5:bd37 with SMTP id
 4fb4d7f45d1cf-6a60d33913dmr89806a12.8.1787852946307; Thu, 27 Aug 2026
 10:49:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-16-9b43f5163238@tencent.com> <DKYI7U97KSE1.2S1M7CWBNBYFW@nvidia.com>
In-Reply-To: <DKYI7U97KSE1.2S1M7CWBNBYFW@nvidia.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:48:30 +0800
X-Gm-Features: AcwNN1XhnSrcGWzKjxM9OlQz8QONVR283xx9Jx4nU8W4sLhXLThIBH32-pmHlLU
Message-ID: <CAMgjq7CXqtbCH1cEJpNEta8KJbqDzd+ZQEd81dS9botZmCsQZg@mail.gmail.com>
Subject: Re: [PATCH v3 16/18] mm/huge_memory: clarify supported split orders
 in comment
To: Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1816E1C0003
X-Stat-Signature: 4yfez7c8ssei91kba9afsu7txmuoqd8h
X-HE-Tag: 1787852947-789768
X-HE-Meta: U2FsdGVkX1+iMWuOUt0cctEdyD00RIP1E8MaZhGjw1Y/TnQ0celfQobQIsjD0xEA7sEE2jv1PHzKWweWPsOEpwBBWsyAvddWXIT+VL4rJixqvNFc2retNdYqz9W5ZF6zfzu32RFGsKcmq8eEgUhRP/Q1/YwPIQJBlxh79vRpyvIBEjStFHOmGmAEESUNpF7EhEaa42EJs3tihQhQDWHmlMTsXjVjtL9l4lQWVW9ce3s8bgF6kqws/VcKfT6CYIoTiIiYp76CGQ0i7XRzMOrbNZs7svl6b0bjTes8RmVkF1vkJ8ONyFcAeWjKsYcEj0o7sphXoIfYbmpuLMefg3SV87i+CPjzFZ25Erfkn5I8+LkBgVKQ0aLFSyeIoIFm5ZBiVjBuXWNPYXXedZ+qhNqzhENXt9NXkxLBLmht3rMiq33RaLm0z6zbeIK+0p3bPt+DZQlw1suyhJJe1OU0oFyICfQULFBCYKe+IpGjr/ey/UQL+PIxqZXcK4CQhFbSBlLab6dP12zbu+MxZNdHNm5yYFAbUFdQ8zqyZaIC4YoHxgmzzgs14uiSXw2GHxjAYYlQXeTUX1ImWqMPcvsQKXqLbrESK+l7zNd6so6K9R/xrX9/TBSxkTe/M4dgjxG12OMYihsrht0Y37RXYgGN/I8ODwdPgEWhh9xHE5YpXjC4PUHFia7qUag1xuMYtzpz8d6SNUvYdUf9kEVRU15W11kqhkMNdi4LLZjj9KESNuCEmWooD5tvXlFkxC0G/j9wT9pM/awnkPn8w7KGFnFo8OPp7i2mUjTQ7AzI+KnsxSyhAe1nvPamEdqLaFQCdZDtnebcvazOhEaGkA7KU3ITr7PqZXGtSAOVK0zZhYDRCUVYPn1KWALjm37VKOUhTwEk43HO5Qs2KbeaEauY1uujtqfzOUPKvFFoL5H4UXtGen5tCzVgKXB7l77V6pimH8WU5cRDm5GhqrexE7GyhTVq9A1
 plkkIOQz
 YBkyAGl+SVHKk7h6JhnLi3vhRITZhm5LBmUj2LCENIRPyxxlZ09p8LGi/G/ECyu8CCD2iFoX74dsbVZH2fyGplk+LaEHTmVEqa/UbRiwaamfOrLzC7LqRf5VIePBlPTMSgVBEIugQIJbBiw1ZVbX9eExJSkwigvGmZrLDtqrdZVYq++1Ic5lIQ0v1obhtcTfB/Mt6aJ734TTP0OB/oUPtQSzgRVDql8JVUVPe92okwpaZTAgfBokxalDgAncekYL0R+Jb9zIb2wNkgvjs1Iat8bMFtiWyNpJ2xJsBXdFA3PnGIHl06zvkDr3q/F+2zrTEDOAkczdDUGIPou+JCrWkz/V4Niss+SDOnWYu/7u0/mkZNIIttLLOwZF/OUdmBmy9w104qHHwydI15oTcVI48q3QKthDax0NC2Gf3FHXW+HXCREfM3nr4hFGmFBs/merHMXwXLHirGdRepgj1AbNIYaMj9cYr22rIDmlXFbETxBx9iOqy0SjGt+qYsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 26, 2026 at 10:02=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
>
> On Thu Aug 20, 2026 at 2:55 PM EDT, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The doc comment for __split_huge_page_to_list_to_order() needs an
> > update: only order 1 is rejected for anon and swapcache folios,
> > matching the new_order =3D=3D 1 check in folio_check_splittable().
> >
> > Also realign the continuation line of the function signature while at
> > it.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 11 +++++------
> >  1 file changed, 5 insertions(+), 6 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 06f353f937d1..0a971ca48151 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4400,11 +4400,10 @@ int folio_split_unmapped(struct folio *folio, u=
nsigned int new_order)
> >   *    GUP pins, will result in the folio not getting split; instead, t=
he caller
> >   *    will receive an -EAGAIN.
> >   *
> > - * 4) @new_order > 1, usually. Order-1 is not supported for anon or sw=
apcache
> > - *    folios: anon folios need subpage 2 for _deferred_list, which ord=
er-1
> > - *    folios lack, and a swapcache folio may become anon once faulted =
in.
> > - *    File-backed order-1 folios are supported, since they do not use
> > - *    _deferred_list.
> > + * 4) @new_order !=3D 1 for anon or swapcache. Anon folios need subpag=
e 2 for
>
> We use head page + tail pages instead of subpages, so the sentence could
> be
>
> Anon folios stores _deferred_list in second tail page, which order-1
> folios lack, ...

Good to know, will update.
>
> > + *    _deferred_list, which order-1 folios lack, and a swapcache folio=
 may
> > + *    become anon once faulted in. File-backed order-1 folios are supp=
orted,
> > + *    since they do not use _deferred_list.
> >   *
> >   * After splitting, the caller's folio reference will be transferred t=
o @page,
> >   * resulting in a raised refcount of @page after this call. The other =
pages may
> > @@ -4432,7 +4431,7 @@ int folio_split_unmapped(struct folio *folio, uns=
igned int new_order)
> >   * with the folio. Splitting to order 0 is compatible with all folios.
> >   */
> >  int __split_huge_page_to_list_to_order(struct page *page, struct list_=
head *list,
> > -                                  unsigned int new_order)
> > +                                    unsigned int new_order)
> >  {
> >       struct folio *folio =3D page_folio(page);
> >
>
> Otherwise, LGTM.
>
> Reviewed-by: Zi Yan <ziy@nvidia.com>
>

Thanks!

