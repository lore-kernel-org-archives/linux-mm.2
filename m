Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 17861CC6B38
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10716B009E; Thu, 15 Oct 2026 18:55:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8EA6B009F; Thu, 15 Oct 2026 18:55:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5FF6B00A0; Thu, 15 Oct 2026 18:55:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5C9956B009E
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:55:47 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E546DA782B
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:55:46 +0000 (UTC)
X-FDA: 85326369492.30.A32ACDE
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com [209.85.208.174])
	by imf23.hostedemail.com (Postfix) with ESMTP id EDC3B140009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:55:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U44L9exU;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792104944;
	b=DqEoFar7R2SrcCEvocIwoJYGgg2wDhC6NdEA6ow7XSSmpIj6yLVXfrljOUF41f0Kab5z52
	V6BwSGrkN7lUm73MqSQvWks1omGSW5SaUsRDZgkTaLC4gjG3YoSvZbDR0mVCdNLRjZpUba
	w/0kGQ+Z+VYosFDSYCapQ1/1lFIVu5E=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=U44L9exU;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf23.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.208.174 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792104944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ir9yC4IPsDGWndlbFXv4TFfTkBDdrwDKIOA2kRca8g8=;
	b=AHujwlULLY832Odq/CAeaiv7vDSKrvYlC2av2AKhfUo5QuV6n/guzdNAsOqi7TwKv02SkL
	GMppgs/0wIx8G7bagpBGM/0T55TCKho8kZVl+9GlkbRshRYWy8RkACiE4V+tco8q1saoPR
	AXZFCFdgSzxFbfOKJcg+uMrZtQbLC8I=
Received: by mail-lj1-f174.google.com with SMTP id 38308e7fff4ca-3a98f260f85so19320601fa.0
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:55:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792104943; cv=none;
        d=google.com; s=arc-20260327;
        b=FojQAxceO/01yjUk4OBKQd8Zu4iQaHEghOBY8dSJ5eYLL8IwrxZjdm+7kZHgvAjJcv
         iTNrihkyr6f1ZEsCpey2cihlgbUeJHGgJmsp6n2vsq1f4ODAg1qM5yQltXFJYKR9zHkT
         X0vgDdYKUPA1vBGr6PM5bKHW7lEQXpkKSsu4nzHkpy3dBJlQPuxRpk9jRelz9qWR9Xmr
         wuK5W0GO/iLZnXKR2+pwkofmJlHKsvmn1KiwdEKhrw4XdCuQ4z8yxs0gW9l++vkxZ3ZH
         U9+9Y2yASa/fG+yCR/l7w/rD06YqNbcs7hV2Ytx3HAfBTRyo+Mc5w4Ygtc2Z6NMdSSrr
         lMCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ir9yC4IPsDGWndlbFXv4TFfTkBDdrwDKIOA2kRca8g8=;
        fh=/90wQFCYk/dhyYumFx/8rq8QDUJ3+fen/Mh3yf8FICo=;
        b=KzB2m3N3q3USizfIsWLlBFP0tKS1H5EDWfwVYZVzJL+d91eXc6jmy2+d7plLFDPSFI
         sVNUqNOwoQIbYjQo9Lj/Gneub1d6XhCydyoX/AXj6dm9KowkpMMhh4L04+rBEtLUG0FB
         AajcxoHjIWcbBdo5f7z4ichCueg6sW3hljX0bTeWzfohG6n69VK0FABxXqW1L/KmelPh
         nGWC7bbnqrsgVqnlEWCNVVHytgfRAtdrYlqa+pUpZKDotnByiDx9zdCX+RTlKTXYv68r
         /nN3d6JeBQyYc6ha7cRtSthBV29RMWNGp/egLwZOT0xlTD/ghAVf9aXJkaRka47PtGRb
         GspA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792104943; x=1792709743; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ir9yC4IPsDGWndlbFXv4TFfTkBDdrwDKIOA2kRca8g8=;
        b=U44L9exUuR6TRiLVigOYNxmea6+mZ29EGMTBkvqyIk7+CGs53M8tCSp1MPagKGHgct
         DXA+GHnJx5Lm8MCxOHdulEXS+K/6wByGQXK6Gzy8oPHI4TDThnQ5/Gyg6WAbRdVKvNr0
         O1G9g5L6cqaBRJl6BR2ly52DLEdCakAC6UzpNaIUD1wmnlu52MgEMoC5akY01MGa/EFO
         bgqJIZbNuhf+tjVOoi4dW2lShQGmJQTICNtMTxPpPeptpFiz6O3YeLdgPxHXMntcMgQn
         0w7vXgA2xuFfbDaN1IVWBOpDNFIwOLSzzpsPqZA2Fz5gGeVfH0lc1GHARUUGTuZ8S4eY
         PoNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792104943; x=1792709743;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ir9yC4IPsDGWndlbFXv4TFfTkBDdrwDKIOA2kRca8g8=;
        b=WZibgMhzNC1nZmTqBXrXCY6Kq3vUA0zsijOJjBnbA7zRCnH5eUPQfXAsmQJXUe7D81
         I22Em+Tt+/XmehaB/oqsF0XSay7rwqfBr9solUX/G5lECH4qC9m4mIc3kz3SHkttzYHE
         KVxRf5iyQfUt6UsSCjPUvigYG2mGTyFZhgUnYYnVaRKihNGN5fVBVXGq2E6kqHWx5Nh5
         O8G0oUwalH0nKCGxyxkaIuwhXrY5SA5cgBkO1ZxyFs6VrTuMBfMkQSv8hhV7g8mqAQyA
         fZ3SrNDFP1o+rrDQbfl6XpHoeBPEPvhvTgeb4TsiJCEmcML1hwuohL0FjSNhRLZ2a0kZ
         KxtA==
X-Forwarded-Encrypted: i=1; AKwUvBxlvKppWkxinQexerM4+KW6rWgKm7eCAmNLDbgzNBu3vcQoJOqg674xLUvr9fpKEp5K/4RqfjSYmw==@kvack.org
X-Gm-Message-State: AFq9FYI6yjdRdSk92U9RREHfapdzH3JVzQ/J/pSI1DzhiIVnsjq4ptrt
	cnap+9k0n7YYYmObBnb3udOdwttDrPqTtb8Kju5tqCed0x2mjh3trXJmd0C6VEgukLyCUL/9eb6
	M1YdjPcgc+Q/TDU9IUh81/vQQfUoODBU=
X-Gm-Gg: AYBFou0GkyGq0l0GIzS9JZ6HPTwQDGgVyDzE/uBfZDUPaojQkvikR2/Ebe7cXDErg9F
	PcuEPsads676+wZiyOJFlAjH3s8sgUDknLfsz3zsWtw9HNbopTInwk8p2JoVp+qDrgpDr6R1Kz0
	VZKXbCLhNT3Q6NHQOKzYwHGnx1xhZe4cavBGBFFula/ShqBxAd842lrAfOkOZIcc2pL/VU54cVR
	1twZ0Nw20ei0bSTwnnJ1R/txymHS0+Xf79xWh2McFlA7RKnIpEJwk/7bHRto96YO9PbERqILdYT
	Ifr2kd8BXlV+6rn104OkJQqjceDnX8WtcMv/3eKaXYGT9qng1nG9lb530cRhOLJ70g==
X-Received: by 2002:a05:651c:19a3:b0:3a9:aa26:3a4c with SMTP id
 38308e7fff4ca-3a9c538f51cmr47801041fa.21.1792104943160; Thu, 15 Oct 2026
 15:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-6-kanchanapsridhar2026@gmail.com> <as7JC8o2kggiq_ss@google.com>
 <CACpmpofXMGBP70Rn7jHLwOF38GRKMUGoW3rb1Jp2SPH7ygKcfw@mail.gmail.com>
 <CAO9r8zOEcGmg8eVttu41htugnng0ahnVQbubiJfxVH+GfDe47Q@mail.gmail.com>
 <CACpmpodDA=oqnVa_hsJpyhGt=4zxknYF=QX9L6-sJbxsRxtM2w@mail.gmail.com>
 <CAO9r8zNN6F01icKUFr8q_AgJvhxGw0MkGezKbBuKzFQV0NaAdg@mail.gmail.com>
 <CACpmpocCJWkA+zvZ9ivNCt8xSZWfViKQ2ZeYN+f1EmdVTewzRQ@mail.gmail.com> <CAO9r8zOtedHfJ5A7JiXJYtWO-MjoGfE9PLPyyrQoHrr-R3FivA@mail.gmail.com>
In-Reply-To: <CAO9r8zOtedHfJ5A7JiXJYtWO-MjoGfE9PLPyyrQoHrr-R3FivA@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Thu, 15 Oct 2026 15:55:30 -0700
X-Gm-Features: AclHuK8cEQZHEGY2kMJTg0wCJzqaMpTTU8RvyNTZr6U6lGP9J6oTJ1x2_LlnLqk
Message-ID: <CACpmpoc9k5bATJDG=GqE1-1XhWCyixHC_ncNoYbRZ-CTkJbDVg@mail.gmail.com>
Subject: Re: [PATCH v1 5/8] mm: zswap: Store the folio's node id in the zswap_entry.
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f68fodq3d7pboc3ftx54hcwfchpf6urz
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EDC3B140009
X-HE-Tag: 1792104944-167044
X-HE-Meta: U2FsdGVkX1+PmR96LjWo8vWbPdDk4i6dGSED2zP3G9z7wvZPJaXOqQSbiM9/9XnGo+g7rnoOuS7wCyzWJr30IQ8BYpRADqzEIc1NQL/ffZ9ecbWQ9tJzESA/M+/dDyUJfBXpXnpdGzplkiBxtOlC8UwjUf9Ztzk6bWI9Zx9/k4X5P9+FyhnQfExQI5Ulqe470X98X/1TaCGJ5yMOdkxzRp2BpdRhksbZUiBeQP/nO8ksQarXjGZv0FlBMBZtzETvJbeTqB+Z0wib2/M7XLFBFjO4M35JyQSYeKptrdy9FqmMl1WI1atbGS4NC0dPIZC467yb56HlPeWLB+JQDMUG4bSEb0/6/5ujany0c+cmckmbdeQ7ELDvbbaQEuGgQLEAlw4NpNPULcxNoUMPJzLjDBd1ZBDORv0zEef6V2qSbyED58ZkObZNnpsSx3PXiqVhYY6S+mg5ZZbx4AL8sIjx3+EhzV412sUUwhPDhbdHAkW4rzlwY8yKhSRK8c4nRXrocxQfRZYte6a3Sq2CY1iGivNlL/hHFnh+75jPhbGQtspbGeM5iG29qUqAdAbm0sjwoNOZsm5EGPg05qQ/UrmHsUiEjFnHtk0X/V8YCfZ4whnChGEQdEli3Wl4wFqG9saLtWdKVr5h/HjXxHzSmlVAg4ALEbtkzAyfin9NmD1/6p1+ztCmtTpevPGK8FisuUUWKpkj9luI9BZ2cs0SqX02VFSrF4Lvc+OJw4oOOdWBlTsQaGaZpUVgx9+mgRt6+AOJmNo+sUu4cGetKGbicOJP2cakdxhzJS/mGTM0XV8qgAJuZJZd6ZQwfYppvLIdBKEWmBRUf0WgTv0FS86vkGrjIaUOCWVws2n1EkFMy2PPJtc47FUsfF/kCB0mv5Sn1UpRYz3UcpdNi+ooVmDo3erNix2bQ6mW5aHPSz0LkupNJZollJWRVE1FWgXtgDIJEVOx8BXHohZJct0k7rb77of
 2hXtFqlG
 MNMp/1XRhuWIs/nJXJXFVPISUCwgpeX6Wtt2V7Yt/h+nyXC+X+Enfsb2oCUbne5GlRA13d3+Ng8OvyDm/azKqLxRSg/XqgVuLjpWIP0AzO7JaUCYLGE5QwTIPO78TEkrvOhagz/xxlbkL8xW1TBu41cdsnWXE1oivtNjWiaHfyhDppMvVqsNNV7NoBK2/3d2g5i2BlcHXXmo91xiGF2N5jv8FlyHDv4285aACyFzuSsZW15OK7Yxb2XGkHY94iMOpViI2ANKpXvf4SS4RRYr9JJn1LfTouBFETGe3Wl7v1ZpAzMkLxj2yUYnlsPXD1VML7jXdqQ1364BTuMSwvk5W9VqE03R6EXrlVXshyP+NACcF+y0Yb0Etka6esvlQM14goxwwEx3aHCII6zuhaa24gmdx7FNAxQVU0bl1q7KBtCPdxSRmSlWDGlhgXSoiCtzjef6fg19RqkSVLByRgeS7yGl6Xbpby6UbAifJ50PVNxJW424guHI2dI3PAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 3:48=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 15, 2026 at 3:45=E2=80=AFPM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > On Thu, Oct 15, 2026 at 2:39=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> =
wrote:
> > >
> > > > > > > > @@ -1449,9 +1446,10 @@ static bool zswap_store_page(struct =
folio *folio, long index,
> > > > > > > >  {
> > > > > > > >       swp_entry_t page_swpentry =3D folio_swap_entry(folio,=
 index);
> > > > > > > >       struct zswap_entry *entry, *old;
> > > > > > > > +     int nid =3D folio_nid(folio);
> > > > > > > >
> > > > > > > >       /* allocate entry */
> > > > > > > > -     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_n=
id(folio));
> > > > > > > > +     entry =3D zswap_entry_cache_alloc(GFP_KERNEL, nid);
> > > > > > >
> > > > > > > We don't need to allocate the entry on the same node anymore,=
 should we
> > > > > > > drop this and let the slab allocator handle it as it sees fit=
?
> > > > > >
> > > > > > Was this a recent change? I see the folio_nid(folio) on my vers=
ion of
> > > > > > mm-unstable as of 10-3-2026. Let me check, and yes, allowing th=
e slab
> > > > > > allocated handle this is probably a good idea.
> > > > >
> > > > > We allocate the entry on the same node to avoid having to store n=
id in
> > > > > the zswap entry (see entry_to_nid()). If we store it, then there'=
s no
> > > > > need to allocate on the node.
> > > >
> > > > With patch 0006, we try to bulk allocate all entries for the batch.
> > > > Only if this fails, we call zswap_entry_cache_alloc(gfp, nid). So
> > > > patch 0006 addresses this already, and the nid is used on in the
> > > > fallback case.
> > >
> > > If we are storing the nid in the zswap entry, there is no need for
> > > zswap_entry_cache_alloc() to use the nid anymore.
> >
> > As of now, zswap_entry_cache_alloc() uses the nid for
> > kmem_cache_alloc_node(). Is the suggestion to change this to be
> > kmem_cache_alloc()?
>
> Yes. I don't think we need to use kmem_cache_alloc_node() if we store
> nid in zswap_entry.

Got it. I will make this change.

>
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > Along the same lines, I have been working on replacing zsmalloc=
 with
> > > > > > direct SLAB allocations for the zswap compressed data storage a=
nd see
> > > > > > very promising results: memory savings and latency improvements=
. I
> > > > > > will submit an RFC shortly.
> > > > >
> > > > > Keep in mind that zsmalloc is movable memory, while slab memory i=
sn't.
> > > > > Zsmalloc may also be less likely to make a new allocation in the =
store
> > > > > path. There are other considerations beyond memory overhead and
> > > > > latency here.
> > > >
> > > > I realize this means we trade off page migration for writeback for =
the
> > > > pages representing zswap compressed data. This might not necessaril=
y
> > > > be a bad thing for 2 main reasons, the way I see it in this specifi=
c
> > > > context:
> > > >
> > > > 1) Page migration would only be transferring a memory pressure prob=
lem
> > > > elsewhere. Not sure how well this would work with memcgs or
> > > > containers. At some point someone would need to do writeback.
> > > > 2) I don't believe there is a zswap specific page migration flow in
> > > > the kernel other than zsmalloc compaction. IOW, memory tiering
> > > > components like CXL are handled directly in the reclaim path. From
> > > > what I understand, things wouldn't break with slab memory for zswap
> > > > compressed storage, but I could be wrong. I hope to include the
> > > > architecture level considerations/trade-offs in the RFC.
> > >
> > > Zsmalloc memory is currently movable, so compaction can move it aroun=
d
> > > to free contiguous blocks (e.g. for THP allocations). Slab memory is
> > > not movable. It can be reclaimable, but writing back memory from zswa=
p
> > > when we are not under memory pressure is also bad.
> >
> > All good points, thanks. I agree, writing back memory from zswap when
> > not under memory pressure is bad, however I have not seen any
> > writebacks in my experiments with usemem at 60% over-commit and with
> > 64kB mTHP.
>
> We can discuss further when you make your posting :)

Sounds great, thanks!

>
> >
> > I am running these experiments in a memory constrained environment:
> >
> > QEMU VM: 7G RAM
> > Swap: 3G
> > cgroup memory.high: 3G
> > 4 usemem processes want to allocate 1200M each. To make the experiment
> > even more stringent and representative of actual compression datasets,
> > each usemem process reads the Silesia dataset from a
> > pre-fork-allocated buffer into the 1200M. This causes realistic
> > compression payloads in usemem.
> >
> > >
> > > Note that compressed memory can be very large compared to slab
> > > allocations (or kernel allocations in general), so it can increase
> > > unmovable (or reclaimable but not movable) memory significantly,
> > > causing fragmentation.
> >
> > It took me a while to experiment with compressed size bins, until I
> > settled on a compromise between memory wasted per slab and zswap
> > latency in finding the correct size bin to minimize fragmentation. I
> > have been gathering extensive SLUB stats which indicate:
> >
> > 1) Even under peak zswap compressed quota ("pool") utilization across
> > 10 consecutive iterations, SLUB comes out ahead in less overall memory
> > overhead.
> >
> > 2) At steady state (when 10 iterations of the workload are done), most
> > of the slabs have been returned to the Buddy allocator, except for 3M
> > worth of slab setup per compressed size bin (0 objects in use): this
> > is as compared to 32K of zsmalloc slub metadata that remains at steady
> > state.
> >
> > I learned some really interesting things from these experiments, which
> > pose questions about the memory penalty due to latency that zsmalloc
> > adds to zswap compress/decompress paths vs. "internal fragmentation".
> > I expect to quantify this with data from my experimental setup.

