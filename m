Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61AD7CA0ED1
	for <linux-mm@archiver.kernel.org>; Sat, 16 Aug 2025 02:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B54F28E0230; Fri, 15 Aug 2025 22:20:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B05AF8E0008; Fri, 15 Aug 2025 22:20:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F44A8E0230; Fri, 15 Aug 2025 22:20:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 896738E0008
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 22:20:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20243C02AB
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:20:52 +0000 (UTC)
X-FDA: 83781017544.26.D686A35
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 062CF40003
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:20:49 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SlpH8rwG;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755310850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K90R4g3Hs6iMouvWfEIK6ups64Nf++EDz0a7nplcn6Y=;
	b=pz5hQyM+Zbz600eWOrLAZUr8apVTZ+VsuubNRm1fSRCMN+AmxhF4KOV2j0MJ18A16p3gHZ
	nI2Brclsy7Exf4yYw3pKnL2MriCGwpXWVfHtbT8E/DfZ0N4AjmOtGPRmIzVaNyxSTgZT4F
	vG0VRFMFjxiewKD7orDkZXP0W4tHyUg=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SlpH8rwG;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755310850; a=rsa-sha256;
	cv=none;
	b=tcfbiaM75fez4aMdRMinF2GGKQvWJo7/dEMIjSqddLxtuq7SVVVkUB5VumyKXJqDukKezp
	xPZaYj/rg8euNpbJOWTuUE4hQ66OXPXBZwzBdaBdE5dxXfuLlZ22yRZPHp9QHNGnHcIdZN
	edIx4iaBAY65nroSIvoWK+sNyfWdmTs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84EEE45C1E
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674E7C4CEF4
	for <linux-mm@kvack.org>; Sat, 16 Aug 2025 02:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755310848;
	bh=SGP/fnSCgeDrRBCJO4AxUNkfcTT5VHchj3PQZX6+SoI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=SlpH8rwGfZmq1rsYwCEDX/y3S6Bg++0fAFyL5W6AMgQzCJADdw3+JgB6z5XmicJu3
	 OKTwjirei0mYZHauKG0+bsusQimCo9/GrMjVqMZ3+da7ETfsqIOVo7d0tUexPKzudX
	 reRIg2Qd73Hm70BWHCgYsTjE5OAiuJg9+anx5T6edIt7dFUj5CxQOT0tiTSVH1xOYo
	 6SlT4QO9543KVw4SZnHPb83Bz37a1vY43kL9oA8qWJDpCn0K8HO3BLMBfOl+0INb2q
	 6hOL1zF3uAiekY/b8l+AEEc4ev3O8f6gr4oCvvdDZcw42TE7qcFOI++9g1S724wK3J
	 6oFRg2R+B3Miw==
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-459fbc92e69so32915e9.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 19:20:48 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW2ypiCD4AxSE6xFRffezH8h5q+RqBnOnhstCQpGIWtUluDT9gpUZ0mvJugPRtjWlbjEATuIGsxpw==@kvack.org
X-Gm-Message-State: AOJu0YwzGyqSSjRkaz4I3z0MXmOP9OLxUU6sPIfooHF6XAFK4/X5ripC
	wJ3czDr7oNJHbJlkbjOIwahBtd3UiQZIFm4EFEdl/kg0q6VjFGk20ZHaQFX8XonXqWQzch2zGAK
	atEH0dP0POLncbpRFJlcSFrG5rD3XZ4dftBo3/OH7
X-Google-Smtp-Source: AGHT+IH5zqxe1aaCsBoZQqi76wgzYFtwhUIpz+xeDSd+aOqoxBLhFMgIfQ154Frn0hicQZC9eQkV1VxpiUnKJwpwCJI=
X-Received: by 2002:a05:600c:a20e:b0:455:fd3e:4e12 with SMTP id
 5b1f17b1804b1-45a26807ba9mr488595e9.4.1755310847084; Fri, 15 Aug 2025
 19:20:47 -0700 (PDT)
MIME-Version: 1.0
References: <CAF8kJuONDFj4NAksaR4j_WyDbNwNGYLmTe-o76rqU17La=nkOw@mail.gmail.com>
 <20250816000701.90784-1-sj@kernel.org>
In-Reply-To: <20250816000701.90784-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 15 Aug 2025 19:20:35 -0700
X-Gmail-Original-Message-ID: <CAF8kJuPCpnGAoz=1CBwe46ytpcR0ZUMAEWLFQce7eUWkb+0ERA@mail.gmail.com>
X-Gm-Features: Ac12FXybK7JLuVGm3itlsErVBVgF4jw7_rgwetALj8CISghHRKHNQTYxpGNpQPA
Message-ID: <CAF8kJuPCpnGAoz=1CBwe46ytpcR0ZUMAEWLFQce7eUWkb+0ERA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 062CF40003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: euyearnbsnj5p31hjfgs487j3d79gzhk
X-HE-Tag: 1755310849-936946
X-HE-Meta: U2FsdGVkX1/mxRHn8WUsSTrm8zpkz0mKghGdhldwdiNhOok3ELMi6Uw1iHeu8FNBojk2QPhxJLusdsd1dOwWZ8W/SPWTZNPAR1lZZGtgumCz92txCofN18SzNF1Wr6/4Ag/RJRe4zvPscGXRuXapVaFeM4dLwJR2H3CTzjsytieNWFK/qUFlrjV6d2mQ4FdhNSCZ0Z63bb1qYM7xg/tVCr46gyYF24+lxZUTU4SjidrjCZLHHI3QtD1XB3lGUjtUwcXyr222PLACY5pFEIUKpKWOHDfxU60fiiTa/kEBm+G5FK/LNCwjrnMdPBeYI1tzr8nE4+idxxxm1WTpx+RRvrXeLJRrQ/nWLbYZtBIFco6S7R8FC0UYL92+GevjsuIPUYbjfmANaCrCfveH1BAGfJSBAl3fk4EuJMlB+JJSUDzwkqgEAQibOvlM6p4MkVS5RxwyzKsJlDUBuJ34poE6BoD+unAZiiP+s0y49QlT1gW2qrygWKzMeQaXLcZMaujPgWYzG1ekXKMXgyNkos+pX82ynJGZUNUJ6Sgr4+y20NzRzAm776xPwhWZ5xpi8xrjBXJC5X+TofWqD+90rZ4o/nJojp9ywrFlWae3Yrov1wv53QjZYv+G4Yzw3HmLh1FMVUX8Id2U/mjQJNPKPohYBH2eOm1y+mfEcO4gvEGQZ6sNwzYEV5E8FEOpkLgcYNQuAdIAKMDuWhOl1uVj2ru52N5sb+lGm00EXYZpYMAmcmXx97t3QH28EDYs2IA1sClCANQDCwI706+OV3hOWvjB0Z0cKoMxGbUKNEzsd7uO1z4f3vtb2LRUT/7GoiAk4Giki4qMtXIAJsklinbuTkghDCK64T9scKuOoCVd/u6AnvQB5FicecYihnPeSR0Rk3gRu9LVJcUIm/ESqfO7me6ujK6XJqMRsK9d2u5nGYPbrwahGZpcNW2hmDag5oAundV3il98napcT9XiQcEh4io
 yQUWbIWc
 uczd48r3zQqHrrSlWy82JOAD9NzyB0H45oLhSL2YK81ZA3DY97ZmkyJMz16wknWa51y5Y+KDVWQY+c+Ib5nPiLFX1QffsqbTVrnty371rou7009/PSD/6G0vI3PxWea2eUH8uYDOmq7qUwopZ2nYou0hW2aMGTiYTpEw1ORCAkdk5D7CimWlU0X7c2GoY1gdPj6IuK78Vlx0ndR96arWimExPeAp7Fr+qQkXVhmeYA8XyrYpk65FUKX1EECkMEIP/uC/2pqq4d4cLts4AvFsYZzGkKDt5Po1oo7QEM2ktQYfLuyy1SYwuuaE0np15sx+eVtNvmdxOEmNhO9lQn63IBNv9XSuCg0edqvlo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 15, 2025 at 5:07=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote=
:
>
> On Fri, 15 Aug 2025 15:28:59 -0700 Chris Li <chrisl@kernel.org> wrote:
> > Sure. I am most interested in getting the best overall solution. No
> > objects to get it now vs later.
>
> Thank you for being flexible, Chris.  I'm also looking forward to keep
> collaborating with you on the followup works!

Likewise.

>
> [...]
> > > > Is there any reason you want to store the page in zpool when the
> > > > compression engine (not the ratio) fails?
> > >
> > > The main problem this patch tries to solve is the LRU order corruptio=
n.  In any
> > > case, I want to keep the order if possible.
> >
> > In that case, does it mean that in order to keep the LRU, you never
> > want to write from zswap to a real back end device?
>
> Not always, but until we have to write back zswapped pages to real back e=
nd
> deevice, and all zswapped pages of lower LRU-order are already wrote back=
.

I see, that makes sense. Only writers to the lower tier while
maintaining LRU order.
Thanks for the explanation. I can see the bigger picture now.

> > I slept over it a bit. Now I think we should make this a counter of
> > how many uncompressed pages count stored in zswap. Preperbelly as per
> > memcg counter.
>
> I agree that could be useful.  I will add the counter in the next version=
 (v4).
> But making it for each memcg may be out of the scope of this patch, in my
> opinion.  Would you mind doing per-memcg counter implementation as a foll=
owup?

No objections. If the incompressible page count is very bad, it will
drag down the overall compression ratio as well. So we do have some
per memcg signal to pick it up. The trade off is how complex we want
to go for those marginal finer grain measurements.

> > I saw that you implement it as a counter in your V1.
>
> Yes, though it was only for internal usage and therefore not exposed to t=
he
> user space.  I will make it again and expose to the user space via debugf=
s.
> Say, stored_uncompressed_pages?

I am not very good at naming either. Maybe
"stored_incompressible_pages"? Uncompressed pages are the resulting
state, it sounds like we choose to store them uncompressed. The root
cause is that those pages are incompressible. That is the nature of
the page,  we don't have a choice to compress them.

>
> > Does the zsmalloc
> > already track this information in the zspool class?
>
> zsmalloc provides such information when CONFIG_ZSMALLOC_STAT is enabled, =
to my
> understanding.

Thanks. I think that is likely global not per memcg.

>
> [...]
> > I am actually less interested in the absolute failure number which
> > keeps increasing, more on how much incompressible zswap is stored.
> > That counter + number of engine errors should be perfect.
>
> Sounds good.  So the next version (v4) of this patch will provide two new
> debugfs counters, namely compress_engine_fail, and stored_uncompressed_pa=
ges.

Sounds good. Maybe "crypto_compress_fail", the engine is the common
name as I call it. Here the engine refers to the crypto library so
"crypto_compress_fail" matches the code better.

>
> [...]
> > > I agree this code is nice to read.  Nonetheless I have to say the beh=
avior is
> > > somewhat different from what I want.
> >
> > Even if you keep the current behavior, you can move the invert the
> > test condition and then remove the "else + goto" similar to the above.
> > That will make your code less and flatter. I will need to think about
> > whether we can assign the return value less.
>
> Nice idea.  What about below?
>
>         if (comp_ret) {

You can consider adding (comp_ret || !dlen) , because if dlen =3D=3D 0,
something is seriously wrong with the compression, that is a real
error.

>                 zswap_compress_engine_fail++;
>                 dlen =3D PAGE_SIZE;
>         }
>         if (dlen >=3D PAGE_SIZE) {
>                 zswap_compress_fail++;
>                 if (!mem_cgroup_zswap_writeback_enabled(
>                                         folio_memcg(page_folio(page)))) {
>                         comp_ret =3D -EINVAL;
>                         goto unlock;
>                 }
>                 comp_ret =3D 0;
>                 dlen =3D PAGE_SIZE;
>                 dst =3D kmap_local_page(page);
>         }

Looks very good to me. Much cleaner than the V2. Thanks for adopting that.

> > Another point I would like to make is that you currently make the cut
> > off threshold as page size. The ideal threshold might be something
> > slightly smaller than page size. The reason is that the zsmalloc has a
> > fixed size chuck to store it. If your page is close to full, it will
> > store the data in the same class as the full page. You are not gaining
> > anything from zsmalloc if the store page compression ratio is 95%.
> > That 5% will be in the waste in the zsmalloc class fragment anyway. So
> > the trade off is, decompress 95% of a page vs memcpy 100% of a page.
> > It is likely memcpy 100% is faster. I don't know the exact ideal cut
> > off of threshold. If I had to guess, I would guess below 90%.
>
> Agreed, this could be another nice followup work to do.

Ack.

>
> >
> > >
> > > > I can
> > > > be biased towards my own code :-).
> > > > I think we should treat the compression engine failure separately f=
rom
> > > > the compression rate failure. The engine failure is rare and we sho=
uld
> > > > know about it as a real error. The compression rate failure is norm=
al.
> > >
> > > Again, I agree having the observability would be nice.  I can add a n=
ew counter
> > > for that, like below attached patch, for example.
> >
> > I would love that. Make that per memcg if possible :-)
>
> As mentioned above, I would like to make only a global counter on debugfs=
 for
> now, if you don't mind.  Let me know if you mind.

I don't mind. We can take the incremental approach.

Chris

