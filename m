Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 232FAD25030
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 05:56:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 598D26B0088; Mon, 12 Jan 2026 00:56:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 546696B0089; Mon, 12 Jan 2026 00:56:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41B476B008A; Mon, 12 Jan 2026 00:56:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 30E6C6B0088
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:56:56 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C2749580F6
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:56:55 +0000 (UTC)
X-FDA: 84322253190.09.04AF4E3
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf15.hostedemail.com (Postfix) with ESMTP id D7A05A0009
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:56:53 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KlMHf+s+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768197414; a=rsa-sha256;
	cv=none;
	b=0ofnivCiJo0UsKnZjluBwJcewcJkgikUcVatk5BbeJENSwV4GSTxPOrS1riX6TJSGJZ3Y5
	onI/ZZ9Wkl5kw2wC01ImyqP8h6xqWOuUpbncN7xta0miBLCtObhA+dVcDgp4tjX8HmFVyK
	dvYDmhF+NKy3ea2IdQhGJOhfbgRRU50=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=KlMHf+s+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf15.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768197414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MQUdO7kF0Tnp+bmM0UqigmkOuUsrJx5sPNlFABU/J6A=;
	b=CvH9DEK8vHIe9LqgnCIg8OrUmxmccnTAVPfG5VuMflexHAxxyevfShQjDXefG/OD4qimxC
	Khm+Bj0Um62+JOS/4BPpZv4g0tKiVybghuazVT+S6S7x/7FkdSJtzGIIg0fMiOQrtvu4ZM
	U/sQsTpmtUCWslmE0MGHSIIja4Gxt3A=
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-b86f81d8051so203609266b.1
        for <linux-mm@kvack.org>; Sun, 11 Jan 2026 21:56:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768197412; x=1768802212; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MQUdO7kF0Tnp+bmM0UqigmkOuUsrJx5sPNlFABU/J6A=;
        b=KlMHf+s+oQDADqWuU4hYStuMrSrNipnoWwuNTGl3I0eNJQUveG5+OYleDOg6Q0lrhP
         udRD4oWO+g9n1DRxY2/GhkAw1T2GuEkcTUOavisZ+5S+sJib6dGkw3I6rHWEZfWYDZZw
         0djehuUIrWVuyuwWvL5dxUAJoRJEdZoOSmmLlZE5SE66esQl94aWo8sVXRaX6aSJoE1F
         DLgAmTQwiCrIcv+CsUtTYKLse1q9lH/On8IyNu1MufJsZdKB1AKHA5HLvFsLpt5VTYHT
         k5SwGdcgh0QdZQg2tsNz3h+khoTYfwuELr2uSj0lmNh5onpiYFaE5SuytmyFaemO1Oay
         bi/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768197412; x=1768802212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MQUdO7kF0Tnp+bmM0UqigmkOuUsrJx5sPNlFABU/J6A=;
        b=MfmZdzXKhsXvFsubbDinXg206nk1xaokP17VPj2WruNvnSvwK+/ZJg48f4/9lmDQmA
         Mk6F6JIRrWjhDw1VBCJXIuVINvesKMYP+TXOV4+ZobkNtCaeIzxMA1XTqK+PRCpjtrEN
         HWZJj6k/nUxTfp2sm/4HRsScqaxEo35GB0fTJ7C9vrtl1MGjoZ0SkQajOpQWYKPtVcO5
         xNvCvPq0ntMvGHTzhB84P3YC2tkhEBTdWmgS4ndRIfpHFs9ipuYmYQoqW3WKSoRa/Ao9
         eavaDvVdvRpz41Q7VBPCgt3bZH8jHcMn81Nqrj0MHymds/sXmUc9+5vc/mivFqy7cD9L
         ykqg==
X-Gm-Message-State: AOJu0YwlNzkaWgJOSK5OkI95PKmCqooIJ6iVzzipkZnkpsfprEHUQkir
	XO6IE2mQ8YsEJazBEPzI3T3i3u70wShPnFHRIGh+/kBY95ahOp60hKvnugvq0ICywQ1ZC0OJmyc
	1r/ryzNPDN4d8guU4nLXfRrNm1/7+dEs=
X-Gm-Gg: AY/fxX5nqq984untmk3Ik6GcnMu1hQHfwaj9idl4/I3lzj6jh3/WiV7ViPFtReh+sYg
	OCC0Pr1PScbPzfPI9MVM/ZE/pIWTIapm42L30aO2GW4d/6yQxap1EyFOFHOblHp3c93cLqy+Ofj
	skbe/Ppz0guPn5VxkC1mTefDKK6hk5flqzJz1N2RRz3DBLSiAqmIGSalwoLr9A/NaACf2UCSo/n
	C7//vNPBSOlXKfw21Xl70+im8lNxE+6QxwCz05cWGrfAA+kD0meN1xEutwi/Kto+kfJIkaqLM34
	ctJV0+LGp9BheRhbuoYa7AT8VFHg
X-Google-Smtp-Source: AGHT+IF9+5Xm1x2hlaMfVdBJMXeE5xX+pUBh8s0pJhPoOJjfsYHUGhHytLEUNT9OMey+gHzXJkXW9WWRMyLYWqXhHvg=
X-Received: by 2002:a17:907:86ac:b0:b87:2882:bf7e with SMTP id
 a640c23a62f3a-b872882c3bamr66251366b.11.1768197411905; Sun, 11 Jan 2026
 21:56:51 -0800 (PST)
MIME-Version: 1.0
References: <20260112-shmem-swap-fix-v1-1-0f347f4f6952@tencent.com> <d20f536c-edc1-42a0-9978-13918d39ecba@linux.alibaba.com>
In-Reply-To: <d20f536c-edc1-42a0-9978-13918d39ecba@linux.alibaba.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 12 Jan 2026 13:56:15 +0800
X-Gm-Features: AZwV_Qi-Mm2ah-xczly_xAKLT7xAGHWF9XcoeRmwlQ3QVUGtCtrYpZeOA8joW4A
Message-ID: <CAMgjq7ASxBdAakd_3J3O-nPysArLruGO-j4rCHg6OFvvNq7f0g@mail.gmail.com>
Subject: Re: [PATCH] mm/shmem, swap: fix race of truncate and swap entry split
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Chris Li <chrisl@kernel.org>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D7A05A0009
X-Rspamd-Server: rspam06
X-Stat-Signature: nc7nnj7uo3mci3h68ujdcg1z1c59fe6d
X-Rspam-User: 
X-HE-Tag: 1768197413-208986
X-HE-Meta: U2FsdGVkX1+2x+U+xjjg5AzBCDbbbqq8egp5nHW+Oe4ZPLtjiztM33pQ8lRFQ7KVXhsHjjfrsmJ6RwBTCq54HwHPUoPW49/7WEBpRxF1kxwJLxSRK+X3sD/DTnwH6xBpRpInfU+aARCOBudFw2O+U4pUx5gRsOXLZrvkVxoH8xzEqVSnnqCieqVu4V2abHTAfBBv0TWjvkqJPrV15F2jBW4Qut7T34nrahCANSUoLMlqcohXG851nlikS4BcAMdXYnAGsVep+C7YHmRLLmgMtjI59QT0zAauBl3rtk2/JGX172cJoTQDJYfSNaJH6J/m+UyRFVN8FiIfpyNUJkam+28aB1xztvfaWqRPKyGXine/7S3ceoM7KDtg29qraDq1HfX/552qxKnIVNQelUqaqSte+J9fUhQ7VzWcHOk5uhTw2Y3f41+HxeZl0D/ENmLC0UK1PiUyVmICVsPRyRUEDy8kxqlLIDVbBv6GgNXYStFVPTzWeg0OKkE80DkzUTD/Mm/USWZAG5zDsXbo7FPK8S+afy7gWUAk7Y3nBb7RaUVdP+z7yYntOJwFSxEDOfcfhNO4RKM6Lw6wcVvdF4CMdoPTK0HtApusJEPRxrCvLV9pb0NV4IeIHZwzZjkRXVCLBXZxBuATSViHDnzaPq8get9aIqHwFmNcUkKDMp8hK08pcgZ8hoRCUMkXW+IwrBQrDWQaUp9XGkYNgQamui9kV2RVOEAMt6M0zKUgIuDM/kjj3EwPJGujMFhvOy84KcjoDQ2nQ+6bg/cAx+uMG1u/jo/QoZ2Gm14+fkw4odXT500INIbma9h9gW1GRMHHHzzuehEz/c+vAY+7UOnc8JSTjm7usamU4KiLnDzJ7PBWYGHv/f7YQ2fXYSBiKJGNF+88U/eSsSPbamYB9kYwPmroR6tw72buK4N8wZYw32uS5ROwk8uKSLC+YBwWP2l5i4sEjrlIiCm+/+li23qn1lJ
 MtTyi/Dz
 lYO2oeZPwhBc3t9daBgOtfSLbAH+VAaV6MaYxapaE//iu/flVWRoW6o/eDMsyRDHkQAZOAYswWhSTnXtoo5Y/nqI8SbwVm/pUjpb8CNyDHLQa14i9MR3uoQkswspsoS5gToXmReh0Gc9mrNzgMGFk5W17XOwKJ9E4qazlHCNpdiGKr8qBDYsuG+QJrUrOX/ADahSm47uBZex+hBgR49ksH7IcBF1K2RUbqip7B6vk4hbdTOgsJobx0Zc1jbfxnyyLiokVrpBFXopHj9SmQc1SS1POADMkEApqQKboSH5/0ab+rHYBV8ueUwSPc/n2sNM+mTrXiD/eNPkPVOjhJ2pVRB7aDXFwTeBQzDX5TM/MCgwV9+u3N7PgDfrREzrj+hytelPdRKgixxHM/rpvlff9IQcb1RRj0wXPNNtCTp2ITHjzR2Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 12:00=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
> On 1/12/26 1:53 AM, Kairui Song wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > The helper for shmem swap freeing is not handling the order of swap
> > entries correctly. It uses xa_cmpxchg_irq to erase the swap entry,
> > but it gets the entry order before that using xa_get_order
> > without lock protection. As a result the order could be a stalled value
> > if the entry is split after the xa_get_order and before the
> > xa_cmpxchg_irq. In fact that are more way for other races to occur
> > during the time window.
> >
> > To fix that, open code the Xarray cmpxchg and put the order retrivial a=
nd
> > value checking in the same critical section. Also ensure the order won'=
t
> > exceed the truncate border.
> >
> > I observed random swapoff hangs and swap entry leaks when stress
> > testing ZSWAP with shmem. After applying this patch, the problem is res=
olved.
> >
> > Fixes: 809bc86517cc ("mm: shmem: support large folio swap out")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >   mm/shmem.c | 35 +++++++++++++++++++++++------------
> >   1 file changed, 23 insertions(+), 12 deletions(-)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 0b4c8c70d017..e160da0cd30f 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -961,18 +961,28 @@ static void shmem_delete_from_page_cache(struct f=
olio *folio, void *radswap)
> >    * the number of pages being freed. 0 means entry not found in XArray=
 (0 pages
> >    * being freed).
> >    */
> > -static long shmem_free_swap(struct address_space *mapping,
> > -                         pgoff_t index, void *radswap)
> > +static long shmem_free_swap(struct address_space *mapping, pgoff_t ind=
ex,
> > +                         unsigned int max_nr, void *radswap)
> >   {
> > -     int order =3D xa_get_order(&mapping->i_pages, index);
> > -     void *old;
> > +     XA_STATE(xas, &mapping->i_pages, index);
> > +     unsigned int nr_pages =3D 0;
> > +     void *entry;
> >
> > -     old =3D xa_cmpxchg_irq(&mapping->i_pages, index, radswap, NULL, 0=
);
> > -     if (old !=3D radswap)
> > -             return 0;
> > -     swap_put_entries_direct(radix_to_swp_entry(radswap), 1 << order);
> > +     xas_lock_irq(&xas);
> > +     entry =3D xas_load(&xas);
> > +     if (entry =3D=3D radswap) {
> > +             nr_pages =3D 1 << xas_get_order(&xas);
> > +             if (index =3D=3D round_down(xas.xa_index, nr_pages) && nr=
_pages < max_nr)
> > +                     xas_store(&xas, NULL);
> > +             else
> > +                     nr_pages =3D 0;
> > +     }
> > +     xas_unlock_irq(&xas);
> > +
> > +     if (nr_pages)
> > +             swap_put_entries_direct(radix_to_swp_entry(radswap), nr_p=
ages);
> >
> > -     return 1 << order;
> > +     return nr_pages;
> >   }
>
> Thanks for the analysis, and it makes sense to me. Would the following
> implementation be simpler and also address your issue (we will not
> release the lock in __xa_cmpxchg() since gfp =3D 0)?

Hi Baolin,

>
> static long shmem_free_swap(struct address_space *mapping,
>                              pgoff_t index, void *radswap)
> {
>          XA_STATE(xas, &mapping->i_pages, index);
>          int order;
>          void *old;
>
>          xas_lock_irq(&xas);
>          order =3D xas_get_order(&xas);

Thanks for the suggestion. I did consider implementing it this way,
but I was worried that the order could grow upwards. For example
shmem_undo_range is trying to free 0-95 and there is an entry at 64
with order 5 (64 - 95). Before shmem_free_swap is called, the entry
was swapped in, then the folio was freed, then an order 6 folio was
allocated there and swapped out again using the same entry.

Then here it will free the whole order 6 entry (64 - 127), while
shmem_undo_range is only supposed to erase (0-96).

That's why I added a max_nr argument to the helper. The GFP =3D=3D 0 below
looks not very clean either, that's trivial though.

>          old =3D __xa_cmpxchg(xas.xa, index, radswap, NULL, 0);

Am I overthinking it?

