Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5198A606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 07:39:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=rskvi+T/
Received: by kanga.kvack.org (Postfix)
	id 6BD5C6B05B3; Wed, 11 Nov 2026 02:39:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6939C6B05B4; Wed, 11 Nov 2026 02:39:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A9D56B05B5; Wed, 11 Nov 2026 02:39:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2659C6B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 02:39:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3B4840214
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:39:16 +0000 (UTC)
X-FDA: 85422037512.13.8DA122A
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	by imf06.hostedemail.com (Postfix) with ESMTP id B1820180003
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 07:39:14 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rskvi+T/";
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794382754;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+y8pTT9IxNdFeyxnEwAXMpH6ns3wd9vUIK7TvRgs5QU=;
	b=LJQMHWK77ehsl00pvXAGK3mQnDC/lRJosY7Q8vUKPcpA6Sv65sTB+doa8osWijBIPKRvw4
	0n1s53URYg+X3SWiUXy8PGlk7sq7r+3ZW0XRUkpOERmf6XY9GQL0z42Kun2XL8GVeqI0B/
	94/4ldyNFJQ8mEOL2iGIqCRawWbcdWo=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794382754;
	b=mIU6eU3dg/PUPWjRQj+pPVXoGPl4xCXDOktlNRyctuVQMc728j3PV9+D+6AcE9EI4T/DtT
	V3JAPGZGixBmfmO/0xkxdkefTWZ8/dIv1hIEsaMPCnjEoFwCGDB+hCB2L01KyaW6/8irKP
	B4E5icIjjY+sT7CQIITFKSZL1b/NGOc=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="rskvi+T/";
	spf=pass (imf06.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.51 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b7245ab5e2so4159061a12.1
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 23:39:14 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794382753; cv=none;
        d=google.com; s=arc-20260327;
        b=Ua+Xm3t12VwVFMpFzzM0dHDk1Mq8flfh+VITBp8zPvMe53fqB6NcOO5u+kvuekY/2k
         iZ+WNvdBdP+MEUC2YTYxMWvSap+w+AR8FsHLMt4oef5Ekx+8e5+mrsKDms64UrhEFRoR
         cneRSAUyMCDh/w/Gzd2MCTTyoJzV6UVb4PtHScMVv49jTjvn4tw0WOB45bv/4aT4vSdz
         MOgwAILDdKWdif/g9/UZNR1WETBhQ+SLYWvGYosiq2zzouyeyB7De/79s4QiuMGrHlnl
         6+1fBEfUjHFIPu3MO39XcA41mHFFWU6dw3AnvGJPgsLdnzO6RINXs5fkeVDMytLmXwO8
         tJ4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+y8pTT9IxNdFeyxnEwAXMpH6ns3wd9vUIK7TvRgs5QU=;
        fh=czmRmtTdJI18DSjGVDSl3Wbm33iLAHA/M1Lvlh0NI3k=;
        b=Y3ssifhgIn562ZdbRRKaqxSDf0m0fHRqk8piUygnPePX49fcfderFefyoCoUvkDi0q
         dGINue5ofZIfT8PBcS+YAsRrTVwrk2RQQT9OzjbkARZ/Rm1qzpOz6i070DxJOtCNbMv3
         TPpdh4axP61lyl5+0v3jP0lHvUB9jnJ8HewFtfVD2qs2MzjLOVd0j0zP4X6TLi4YYrcv
         YEBn58DM+jGbuDXrDPS63fC+wnyHPb/0813eOpxvBZu2KS7cgLK+8l30k9GVDWZIhENU
         MCNT9J/ZAHFLAQ3C4j/Wrc+jaFbnluuTRrb6KVlLGtOspBrbxmvLumPKccGcpHa9ER9T
         bXVA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794382753; x=1794987553; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+y8pTT9IxNdFeyxnEwAXMpH6ns3wd9vUIK7TvRgs5QU=;
        b=rskvi+T/ud2e+VciTyfrqVN9l+I3p1+wi8jFuhF1hinZJbAz1dHZlKuKCKJqC+uNRk
         VgyX2Xkn4IXcXHjcEizPQj8rbBjemOuc/4doIWRkRnnJTl4hGJECgbVBiDxmuPPTjjlO
         if+7++UJGem2kLFutnclmUwqM9LYYdUc8Bt4MYWOp7E5HRR0Z8XkbtO/XO/+UcczDoLY
         AlwPl1xcVR3mRnSUS8204ovzJrHeMFcbB0Aq3AzV3hqE5Lbc9OyPZhKjAK8496rXaZzz
         VyxdiAKIyW6L97uQtmTiyC6k/3QRZNUoqdYx8qk/kWPqb6F/EgHaRyVmNudYTamrmhnv
         pYdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794382753; x=1794987553;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+y8pTT9IxNdFeyxnEwAXMpH6ns3wd9vUIK7TvRgs5QU=;
        b=W/D6k3zDr4jHG04joDE7zroO/KgQmhL/UBC6rJgIKKHbD+KADhL7+SmHXSgN7QbEBe
         hOFTBEirYoPmb8wYMrsqusp1HB/o+ReSdf3y1+iiyW/q0IGp/EZT7vuK+FOKEOgek5Wb
         BHhe8m8+41viKYFVrooiYtSQ30gr16JplVLZEllI5xd94S1n3hm62W2NSgkiYIuBqlJ/
         n7rvESJy2iNrknl6M4aOL7aFaQ89IGx86OUAODpegZQEkGjQv/nJ5IV2NSHkeRNn+ICy
         yJLZt7wsBqwKIGauZPzXRR2RzspDPZrV76ArzDAR7EBsxAv5+wgf6Ww3H7FszMgSZDlE
         AeEQ==
X-Forwarded-Encrypted: i=1; AL+hErE610Fu40Y3i0lyO9AJig/Eiw2klzvh6YJfALuc91ggovjsNY32w97RrTePoReruTVTL6iZ9J9GGw==@kvack.org
X-Gm-Message-State: APuU4Z/lTIN/d29h56woW5bySI8IrwVhf/gikBfA3wnen7zFgWlaZCC6
	4eD6XAsmq/Nlo2GKCipYrG5tcrgsynfiJJQgrM9wUuLsb61qgbAHzypEHIZ6np4jVo+WkuOCjbt
	t9UMYhlv3cTXLmF/A0JZnTUWIR5nWkCw=
X-Gm-Gg: AYBFou383BOEIKjs8LIQZ1I/d9oXSjFbSKlCfkq4d8bl3SPPQMbGUXJzQSziR1NAjja
	6NeQfMCs0p2RNxxTHR/m0QsMtVEBnqi6SVzFpL5rL3+klE1Nz4ONQ02SXpqFUpwMEbZQwTTmg8S
	caFGr6wO6gGKoHab+BDUz3Yf03Ys9uiCdB1/tL+ZVPc7PG7WW+P62ans4SFZnnAzC5xD8vDmAem
	5/BDSwdzi7sood2/5zj3eZ77Y+tF1aoNXZyXEohQ0AWY7mv37Ff7FHRmEUbYx8cXK1Gd87nnoUZ
	hNA02VZiH5Mxu7J6oFNUYKoSsDzOovWY2f28F36/51JoSz22KzC+moxNx3V9GzRW98gjMhWFUCe
	M2Rz3e30AqT1+ZiAMWDlfqt3RoIpZbT/OGGCRns5NSsk/HWvRW4MebvDb4RjrhohEYPYfDw==
X-Received: by 2002:a17:906:9fca:b0:c25:4d9e:bb28 with SMTP id
 a640c23a62f3a-c50630b6ad7mr164113966b.3.1794382752891; Tue, 10 Nov 2026
 23:39:12 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260901063755.1519710-1-hebaoquan@kylinos.cn>
 <20260901063755.1519710-4-hebaoquan@kylinos.cn> <atJwMRHXzXc57qpu@KASONG-MC4> <avQW6uvW7iG9Tw_F@fedora>
In-Reply-To: <avQW6uvW7iG9Tw_F@fedora>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 11 Nov 2026 15:38:36 +0800
X-Gm-Features: AclHuK_5362EwQf1Izucmtsyon_XOQ4gA-gcb7KEX4uGRGpRBX8Ima33k-zCxQ8
Message-ID: <CAMgjq7ANR-ex+qWWjV06b9rE6+0=RP42tzLq5F-M4yw8hb8Qsw@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] mm/mglru: skip cold PUD subtrees during aging
To: Baoquan He <baoquan.he@linux.dev>
Cc: Baoquan He <hebaoquan@kylinos.cn>, linux-mm@kvack.org, akpm@linux-foundation.org, 
	baohua@kernel.org, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, david@kernel.org, rostedt@goodmis.org, 
	mhiramat@kernel.org, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: gohqkmn7bzj7dhkre6eu3r8taw96788r
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: B1820180003
X-Rspam-User: 
X-HE-Tag: 1794382754-295197
X-HE-Meta: U2FsdGVkX1+CeosquzM5lx4RHnqHqlGW1xsg5XA5j4vuIz3lLOoS+b+R+Iz9t8T99b5qxuWjj+yHKIkK6GLCf6k+UR/dh4EN0steeFGwS2ygocZyXQkvCbT7G1Wbt9lMoI/McEXgghljBtVmtvgIPqHnriYtU2ixe2G07RwjeyUqhJQrPy8G5LF7cbD+UQg7q+5xHoM8PoMndc8CPhiofcGW/nmFLwhiyxqEPU8oSs4a1VK61YE3J6i8Uoi1K33L0MGMhes4HP6MBx8Fsm17nIX3TIU7UwXR15Jp2PW5OKTU4ZczHeZ1Z+3Ptj4V/v+nY+U6lvBnG51U9ysoGldy+6yTcH4qqxWwyAa9AwPm8LczUX8ACFpzpnArcxZy9JrxZtNSs74etDWWfAg5baqT+ZBqBBtPFtZBJsl8ykisZr/r1yTghYFoNQ2qo0YepUNyfGdRvV0iRZRupoNdTxoC24+xoyrw/OmsZVtzuieWf7AHyE0Lcz2XOilzUA9qrUwmg0OsfxMl+LXwpCF1VNxkglT3Csme380BphGcE2evtbpQp1/eti+JBsqrtt2KUiV0rHODtZPF/Y50ylnJh/3hOjOBbMVG0HtE5v0v535k+qJwBl3ICM3yYsM+0NVXnThNjqcCMg3Dzy7vl5ILaT8bj5Kl3u2+uQiy/x5WzLld5ya+lpyBfcwZtkqpTeAOpGZEMwv4RjuZ/ZgG4vLrgMAY1/7JCQEDr6zRVFHGieiR4FmQUnTflWu2TGPMesDz/vT2RRmTAEiaovJXS0p5e5vCafpI4hPWj12YA5RydN8bADboKojYXp+cySg7oGtFC/WCeST0pKmA50n2NysRmFhCKMsl4N6y+fPmBupub0uq83Y/MtNfwE4nJuHL6aIYLR6PuNm5dn6TzpgsYVVLpN2OCudYna37c4k5dB6k3tSAlx1YdR/4lmgm/z4LpLHLmCp0bCs8LwGZ60gfRAHQvXk
 w3lSPxVP
 vP/b1uKbKXbxvWU5ng7Temc5gDBIdYdhPKP8g9wv2CaVNgEIpRS03PPXkAbPVACS9XXqMF14OZqDfPeqetPIE1xxwzcMDJ4qDZRMEfrzhNmcGW/ikUXhjFluk8iPqpv0cmf6RM6G8+g9MFfhXGufISZfMTrkyEsUDunykB6UQvTjFX3RxXAOmulJNifKHXVCTUfReXZ05IAsR7+nIMcymZtymcuEb179i7twXJn55k7Gikkcm4nUjCl1JfaFg8HfAurWjtZUM3AEWASrdDfFU7XhnXpATFuzHkvQcbbqmlS9wqiCAyda3la7WXo6TQM8IY0JHwyCfdnfyayO3xb0xWtQ1ZKT5duB2DUbhpqt5musZdN7zB337LYSBjxn64Mg7v1wkvzDlNdCTcdctR4GbVvkCIQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 11, 2026 at 3:19=E2=80=AFPM Baoquan He <baoquan.he@linux.dev> w=
rote:
>
> Hi Kairui,
>
> On 10/17/26 at 03:53am, Kairui Song wrote:
> > On Tue, Sep 01, 2026 at 02:37:54PM +0800, Baoquan He wrote:
> > > The aging walks into every PUD and runs the PMD-level Bloom filter
> > > on each PMD. Add a coarser PUD-level filter (pud_filters) one level
> > > up:
> > >  - walk_pmd_range() now reports whether it found any young leaf entri=
es,
> > >  - walk_pud_range() records that in the PUD filter, and
> > >  - on subsequent generations, skips the whole 1GB subtree when the fi=
lter
> > >    says it had none last generation.
> > >
> > > The double-buffered filter flips with each new iteration, so newly ho=
t or
> > > migrated-in pages are re-checked promptly rather than suppressed
> > > indefinitely. force_scan walks bypass the PUD test, so manual aging a=
nd
> > > newly added mm's always rescan and re-populate the filter.
> > >
> > > To keep hot regions marked, also report the covering PUD from the rma=
p
> > > feedback path (lru_gen_look_around()), so regions whose hotness is on=
ly
> > > observed by eviction will be re-scanned.
> > >
> > > Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
> > > ---
> > >  mm/vmscan.c | 52 +++++++++++++++++++++++++++++++++++++++++++++++----=
-
> > >  1 file changed, 47 insertions(+), 5 deletions(-)
> > >
> >
> > ...
> >
> > > @@ -4397,8 +4431,14 @@ bool lru_gen_look_around(struct page_vma_mappe=
d_walk *pvmw, unsigned int nr)
> > >     lazy_mmu_mode_disable();
> > >
> > >     /* feedback from rmap walkers to page table walkers */
> > > -   if (mm_state && suitable_to_scan(i, young))
> > > +   if (mm_state && suitable_to_scan(i, young)) {
> > > +           /* the PUD entry covering the young PTEs scanned above */
> > > +           pud_t *pud_p =3D pud_offset(p4d_offset(pgd_offset(vma->vm=
_mm, pvmw->address),
> > > +                                                pvmw->address), pvmw=
->address);
> > > +
> > >             update_pmd_bloom_filter(mm_state, max_seq, pvmw->pmd);
> > > +           update_pud_bloom_filter(mm_state, max_seq, pud_p);
> > > +   }
> >
> > I saw the discussion from Barry about the concern about the overhead
> >
> > I think we can drop the PUD ptr walk entirely. The filter only
> > needs a stable identity for the range walk_pud_range() is iterating,
> > and (mm, PUD-aligned address) gives that on both sides:
> >
> >    walk_pud_range(), test and update alike:
> >       (void *)((unsigned long)args->mm ^ (addr & PUD_MASK))
> >
> >    lru_gen_look_around():
> >       (void *)((unsigned long)vma->vm_mm ^ (pvmw->address & PUD_MASK))
> >
> > Will this work? Also I took a look at the hash algorithm of this too:
>
> Sorry, missed this mail too, thanks for great suggestion.
>
> Yeah, it's a much better way to do pud level filtering. I will
> switch to it in v3.

Great, we should have a super fast O(1) key calculation then.

> And the same idea on PMD has been merged, your suggestion is earlier
> than it.
> 65a9bf08a3e4 mm/mglru: don't use stack pointers when walking PUD and PMD =
tables

Not sure if I understand this wrongly, but 65a9bf08a3e4 is fixing a
potential stale stack value, not changing how PMD keys are calculated?

