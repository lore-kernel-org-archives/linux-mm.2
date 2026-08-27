Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94B56C61DC4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 17:48:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9E8B6B008C; Thu, 27 Aug 2026 13:48:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7B616B009D; Thu, 27 Aug 2026 13:48:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98BA46B009E; Thu, 27 Aug 2026 13:48:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 649C56B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 13:48:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E7A241A0135
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:47:59 +0000 (UTC)
X-FDA: 85147782678.09.CB5D9A3
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0F86A20009
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 17:47:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Js4oHoze;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787852878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p+49vqR2fh26OMS9DxmmmkkFrygreA7GbCzJCw/ytWM=;
	b=t32IAYqBe+2hDLlSZMZ++80b9JnF9iSx5kZRF6+7JvysocrBXYOaiC2HGLSLqLfJ5gq8Sn
	b5C37gQ4PN0NT6be1yWtlJjZLoW9Qn+SgFMCZrRlNe8LagOy0xJxsXQ2jetT47GtIQ29fS
	vay4zkSjZkdCYqb+q4HZbqkfv9V9E6k=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Js4oHoze;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf13.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.45 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787852878;
	b=qa12VC5ssWBiSYnG5Wvdi7n4HbWyhNmojNXb6gnVcrfSLyiQnCtNX+twRhdeJ68TlX6+3O
	ghCs9d6Lgp7KBiMWqAHXDN5oNTPEZIa//Ts+oSwG+QXyrAuwVc6nnxoJk5ou0qHE2LhDFx
	iuYoGnvZvrRUbJeORspPsjL7pYQl7e4=
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2022323c37so19122866b.0
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 10:47:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787852877; cv=none;
        d=google.com; s=arc-20260327;
        b=MMd4eUG4C034n45+up12iTTfSLKBy3OU9q3mfZjc6rOX8WscXbaNV015qtempF2lwE
         VPel0+0QxoCXkFmZOmL/jfLSGs4KZPMxHHOYYAaEfF5hCQpuUERomyJ+/o6+9hIXcJlj
         wxcKKhmkFzUUM8pfVO1ab5O+5yd7VCJLL6He8xoUAApveyqZpohUe573JgmKRd/quZEb
         FjM/CC5xJXWGedl3/QBsnH58qQCYIzPrLZ3s3hE7iaRcqIq9ri0tDOqLJDlU0iDCEKyQ
         2mFxVKq2m2ybOXzY5me2PIr6Eucs48ml6/5UmdcCJxp/C13TA/HviwQnoiVHRTfbWDQz
         sHyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p+49vqR2fh26OMS9DxmmmkkFrygreA7GbCzJCw/ytWM=;
        fh=gW5ivs51vbjATpS7fTtCbsRWfHNWurt1lFXO5nnQLVM=;
        b=VvwRKlKBQv635BN8f6i/L4k7IB4w/NxZ5xwJ7fzmAL0rA0YVXRVsKLBg3gqbN0y1hp
         LbdidyEIyxm1RteXXsWjWcpxdcYtRNZrmg+DoKBamiJA6cZOuNT9nHO//SYyisQVWEYB
         EE5FFJPa8gX6N7HxyMMURc6bbIjWrxoC6sY2DApi19ewd6Acshoe2gm+DiE04yk4ZlUM
         EWQMs8VlWBBt4yHU8gxnZQKytZgbxxfLl/zbJhQvgd0FZg8Ija49dL11NAAYTKQYR2dR
         XHCcdcMoLJZ4rad8jz9eAUUIx62Zi/DnZQaBS/GoGoVMjMrzCIXzqf93dVY45pVq44UF
         w3Rg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787852877; x=1788457677; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p+49vqR2fh26OMS9DxmmmkkFrygreA7GbCzJCw/ytWM=;
        b=Js4oHozelqjbfMhn1EgIIpE03P8I8rEX18VUkPYpfK6iuCwFcd+rxw2joTcx/nWtz0
         gOHLoQm7h5o+IArIeP1Tzq3INoe1eQP2Tty/x9PXzYCKFaF9A4WO/MPCby06xx86FxEu
         7R080RzcRzOnYM7AyIa+spWzzjX928mtl1CMZPq9d6eQw9s6wapvPN5Q/WNM/g1p0XX4
         zUWJLBVeNXJDgmckvDhGP1DRNyTrtRBsQt1TlPr3doWzur6dLeLsva9BqhC3P+GlR0mz
         BdPaKrlDC78wEFax9Dt0SdZVXAMOnL/5w58gUz52P2s7e3LFYm6cgR28n6NgZ5uE/WXN
         Whvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787852877; x=1788457677;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p+49vqR2fh26OMS9DxmmmkkFrygreA7GbCzJCw/ytWM=;
        b=VP2vJFCYHfrErpqFEC9XCM/WL9X9RzTOQpjJmSUkz2HxNfnHntpqRMlhS3kZkaxl5Y
         kRp9kWfQPOO2xmZiQ8v53hSyowKovozVXUq/vUvH1IJnwIAkCWK0Pa2lAj5G3QBMSpSQ
         FD3eBZO/0XrptNyjhOVnnZlcgG6jBX8vJLWWisucdyGCOUI66j5x52r6o+PgK0YreglH
         P7wD23ftzel+baMjPkfjsk1tHM7xjcun1hajDTZ+YZLxD+G4JSQrXiaXJyE8NJ/Z1nWW
         6Vm3UL3/TewzzThoJRz6ExgHVxln0X9RxPRXf1KXUY8TODOx4KIVvhrbfWjm8ss2NPTe
         x1Uw==
X-Gm-Message-State: AFuF++nVPkun5QaDr76mrjkqNLAC7qJ6T+VC/wJuCHj6C48B7MD2c1di
	pKGEpA4b5jfEK1Fdc5XfNel/MHWTyWhe38G5TUw4Vn9lTp4U88pnZPjTlBcKUTkFVqzKdHND4V+
	f764wdptZI6IhkI6+VEnjREpp8RWKuqs=
X-Gm-Gg: AR+sD12adpE/E5gzYEiDaOSJN8F+KV/npEyOScLAkuwAWWvlTWZ/teKDhQ3c9f8bUHt
	SdR2l3HLiXB+jemz5nb8r8N8F8r7MEHyrz5qoSOB+hNXJ0oXqndfXkR3oMtpzVkixJrRX3WJVcA
	tl2DwJRXuBot9DSdTFu/xl3Snnsyq23vg92Pp+o5wXDKiRZezfsE++USjNVDfOs6Tv328d/puo6
	e/VOfMEspFyAUhK65Jaz6z4UTbXR8WcC0FZLrvv/6WvRcM+xOKUAg5fQ0TMykYMWscY+EwPNB/3
	RZHlbWqLzEJMGL+xeL1P0seRrPkVBLg/Iq2OvFy/IHh8ioiR5vbWBL0vXohjCphjvO5O1l0wywl
	c
X-Received: by 2002:a17:907:1b07:b0:c20:21be:ea75 with SMTP id
 a640c23a62f3a-c2556fe4518mr31900666b.8.1787852876603; Thu, 27 Aug 2026
 10:47:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
 <20260821-swap-thp-cleanup-v3-14-9b43f5163238@tencent.com> <9adcaf53-3a40-4d97-9365-b9af97891894@kernel.org>
In-Reply-To: <9adcaf53-3a40-4d97-9365-b9af97891894@kernel.org>
From: Kairui Song <ryncsn@gmail.com>
Date: Fri, 28 Aug 2026 01:47:19 +0800
X-Gm-Features: AcwNN1UolfPbwWi91Y1xRcWs4KUR666VdDfIVutcZFkSNdsg3NHjJdQfhrMLT00
Message-ID: <CAMgjq7BShyGaT0rvZqbHP7r6_A7BJwnJLsVyo9cvj1ZVt2e=cg@mail.gmail.com>
Subject: Re: [PATCH v3 14/18] mm/huge_memory: clean up after-split folio
 freeing in __folio_split
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Barry Song <baohua@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Shivam Kalra <shivamkalra98@zohomail.in>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nwmkcoc6iho4sf34gnsq6n5hc8jgoh48
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0F86A20009
X-Rspam-User: 
X-HE-Tag: 1787852877-560494
X-HE-Meta: U2FsdGVkX1/XwIj9X+Q2dm/253hfDiaGeP8FRd0NqX+QZuOJuBZWOTHmGqvsbB1Xy3/tHdO03xflV9K6mfaDjguNYRji3Bty1scXRDxTfyADsR8jY0eYLTTuFrpvo/DCvcL7YE1eWaYcIMPx9np7X8993pBSUywHG/E0+z2TwlyeELlJwnYbLiAqKYqYTN4eY5laxk9lvdqU6BWdTSgYBYce6thhpBLyBR7K3B8qXqZLKF0Hp+bLCxkwjEpDMHXrgqRqzdD2o7weP73yjqJKTnc+K7sAJ/xsh2iy2vDs7pjoDmUqrtMgdvyob0s489ecwcKH48ZJpiBLCqVhNKaYgbE7lpojmRErGM5NnYIBDgBYDrSv5EDbHGlnVOvOD3ZgL0GHnn6jx0JMJFL+XDXmBSgDgyHk6NWAkrvp0br5UEmMAkfdjET2+4m+bkgp9gdtqzcnoPQedXT+tE9F0JHeEql1u+RjQ+aZYXAah/qLEnuqMMa2scqlekFQ4mZ8+HJdpFPoP8xqV8LTTVMzAxvrCO3mIFMYmDw9Txee9Dd9fEe7nCoaj01+6T7CJEaxsoLy1hY/2OgH4eUP4axnk7J0D8nW+OK++x2xXbd/XGVeMted73eXFP3/mJorXSFZxK8sIIdfbwGLYolIGU9n8bi7IqeJEe9p7E7MOm5XFsJEJTWKrZo6Ze1Q/Xv6L27J6BMTu1OeKQIpCP+7ywqsPcEmPkYN0ZOi5RxbcxZ4jaJLB81KmHYxNL2fyvdnfCWoEywohyQwUq6dl2TEhkDt7ChtXl9xDxkcwb+EzeP4sLFOgnKrnWH1iDQ/2fmj3yRZfUz49rJLIsPWKa3U6G991R2dfcMVRUyu9P01gWVpmxH6XOrSLkO9IePxr8VAFF8KHVuBPh9xjXLlQa6kCJm8fkosQTX18VNpo4bTPWUH7f25mXIKxA06BD04DH17QQaTRLfzxI1+aE3FFFmoI8xCwR3
 dMqD3bUS
 6UQwYfHDPwEkvYT9kkPh9SBr6rVB8njE/Vd8NcsXoFq8RLJFq6pbJEPlPlzFHcuncNz07ISqyWFjIUDTOm13ysDXRhoOqvpYnTRklpP1auns5IPUoFt4YsXbTtzIZZsJDTUWW6pcymPZ7dYElIaEg/FwQ+9O/gapZZyjeRKn6Bg8uwsTBAgHE1wUhpPM9Zv/7crOF8st1QoQginX7iy4RwS9S0cYGVmRKz/0JgANfFEBOM6uWOPSgRfGBixoedmMCO9wZuGs/JYkT6zjZyBJBjdPoK+KudvF+iZryfagUEa7lcHFgwTGCA03BvsBMVncAuxRhd8xp9r2PRoIELSgSfkAG4QIxO0IkKEErCrPn7HZjkrpUSncM9gBGVtLpsH/ywlNonVE17DioFUHsPLsDefSPe6aWZ2dWyppT4MIFnO5U7Z7yI65DSLJfUojcJYwl0FolihfXOF10zXqIgFvzvGV5lzZFbveNaIXRX2zrR2/DeT1NfVRaI9rOskDPm52nWm8jANlGbpzO/4Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 12:48=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 8/20/26 20:55, Kairui Song via B4 Relay wrote:
> > From: Kairui Song <kasong@tencent.com>
> >
> > Replace free_folio_and_swap_cache() with an explicit folio_free_swap()
> > and folio_put() in the after-split loop.  free_folio_and_swap_cache()
> > unlocks the folio, then free_swap_cache() must trylock it again and
> > re-check folio_mapped() before freeing the swap cache entries; if the
> > trylock loses a race, the entries are left behind even though the folio
> > reference is dropped.  The sub folios are still locked and unmapped
> > here, so just directly call folio_free_swap() directly under the lock,
> > unlock and drop the reference.  This makes the swap cache freeing
> > deterministic and the reference drop explicit.
> >
> > Reviewed-by: Zi Yan <ziy@nvidia.com>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/huge_memory.c | 10 ++++++----
> >  1 file changed, 6 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 84c6e4bbaa88..113a33cddace 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4337,14 +4337,16 @@ static int __folio_split(struct folio *folio, u=
nsigned int new_order,
> >               if (new_folio =3D=3D page_folio(lock_at))
> >                       continue;
> >
> > -             folio_unlock(new_folio);
> >               /*
> >                * Subpages whose mapping has been zapped may be freed
> >                * earlier, but freeing them requires taking the
> > -              * lru_lock, so we defer put_page() on tail pages until
> > +              * lru_lock, so we defer folio_put() on tail pages until
> >                * after the split completes.
> >                */
> > -             free_folio_and_swap_cache(new_folio);
> > +             if (is_swapcache && !folio_mapped(new_folio))
> > +                     folio_free_swap(new_folio);
>
> But this is effectively duplicating code that belongs into swap code.
>
> Should we instead have a helper next to free_folio_and_swap_cache that co=
nsumes
> an already locked folio?

I think the only duplication here is the is_swapcache and folio_mapped
check? folio_free_swap is a common swap helper. And putting the
folio_unlock and folio_put in the swap side looks odd to me, since the
folio is locked here and refs get here through the function's
convention. Pairing these unlock and put closer to the convention
doesn't seem too bad IMO.

