Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA20CD5BA4
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 17:06:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7A26B0095; Wed, 20 May 2026 13:06:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 18F5D6B0098; Wed, 20 May 2026 13:06:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A66C6B0099; Wed, 20 May 2026 13:06:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF91F6B0095
	for <linux-mm@kvack.org>; Wed, 20 May 2026 13:06:24 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 918521403CE
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:06:24 +0000 (UTC)
X-FDA: 84788426688.01.254B1D3
Received: from mail-yw1-f176.google.com (mail-yw1-f176.google.com [209.85.128.176])
	by imf31.hostedemail.com (Postfix) with ESMTP id 8D5522000C
	for <linux-mm@kvack.org>; Wed, 20 May 2026 17:06:22 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=stNnDDYU;
	spf=pass (imf31.hostedemail.com: domain of olvaffe@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=olvaffe@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779296782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nFISdxX0pfMGm7mkdTuVkepPKyGH3+oJOU4ujc5bnFY=;
	b=rKCKiZkycRPRaCLmCABfdQLacO000Ee1HvNQvp0Ekl8AFB99a3Bt7EarrvcW/VJYfkMfIV
	se+Vp7mCE/lXvyphygovwxtIKI3p1jjuIImZOjPXxvbA1W3E9wrngFxS9wY9cdfBKGQ3dj
	x6JhkFQUavlBgPOmFqyiqd4FSrMpstE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1779296782; a=rsa-sha256;
	cv=pass;
	b=SIl7PnplajRvBTDM7KMaan9wCOz5nwvPk/ZNFzEr/9K6ryri658DCXco0z6h3WiE8YErsY
	1U8qxc+PJyg9s1SAn6YSLpEYWojGJQZeV6m1rWYfcMCgyuhBLrcJxTImdK/9EWaWgkj1J+
	b6sKpspwsUrkdnZ2v14nKgNVaj0urU4=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=stNnDDYU;
	spf=pass (imf31.hostedemail.com: domain of olvaffe@gmail.com designates 209.85.128.176 as permitted sender) smtp.mailfrom=olvaffe@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-yw1-f176.google.com with SMTP id 00721157ae682-7bdc947aaa3so47229887b3.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 10:06:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779296782; cv=none;
        d=google.com; s=arc-20240605;
        b=CyR9VMg171rcYyN2w59UWVpTge2kHzqOF7A6WRoIIQpaA9GEvJJWQ6qCG8QgZBb1nc
         xXAHMYWrEpxgkHi+f2eZQ2RVn5MLKaNYJXKUf7XbDRXyltgRFn8wTuCI1iNekDsChBad
         uv2LyEmoz+pPIvfHPfWs/T9W6TJ3AU+U1Zw2mRcQ//g2RFZYD2z9SLEchixBVzRvFfll
         tjDqLteAeHj2JbK1G7HLIKdHF7ZFciFPQcw2WsQy7/YwIMW0KrvJ5sV7fdogOaLEyPTe
         km/phtR/GT2q4jOuX8Hr/hrn+5vrssCDvMRjtrYJm45CKpLz+5yJEwJGbu8yu+1rPt59
         t1jQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nFISdxX0pfMGm7mkdTuVkepPKyGH3+oJOU4ujc5bnFY=;
        fh=e+fm3v6PRcwV1wEM2GsSslRU9MUeE8cfgvJEBse2rSY=;
        b=VlKtuV1d1pqpBn+33O2m4oHNmEVcjpMqSazP/bhU+7mL1zldSN8oMnjlx4eQQsWK4Y
         Ki2G+83KqFxcNIDBvsnghm4cKxvXABtRg1CzLxOi9ck35mHo64qpTpq0mfdfN17oemKC
         PnZbr8r17oZbUdtzbaEXVHIKxAvGT4gR5TfpN0dumquWN15DtKp8CYze6vnSJRjIGNYk
         YrMrOvrLyjw6tKuU3rxphwfcPJDP6Bymh2bIeVdwg1yMs0PZImcLR+lu+/5HagxztFta
         N+FQpZs3d0oUEOz8ptASXg2wiq9gP5JEhbYBGS3lGhPf18uxEdx5ffMczq3a1SBd6YHQ
         9BBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779296782; x=1779901582; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nFISdxX0pfMGm7mkdTuVkepPKyGH3+oJOU4ujc5bnFY=;
        b=stNnDDYUqArPxFXWTRp2HQk8ttZpVHYtADbdNRAeK/pkcs2RFKs0VQnv9qc2/SOBf5
         iTylsKUDPDhU6K8VPVSY0is5uie8Um0z66lctXLL5rDfRjrrsxN6G6PNbjqNL7Uw8J55
         D4HznpLIcMHP9NLpNKT+BsRrvQs5mRWyHLkcHA25dmTjphHcSODy0BbXPXIFQxoHKnpj
         khylBJjUySKME4gUdPTKrowkzL3MMu0adR6wi0A43EkZ/KcOe4G/LUMO3N2Kg03Alcqg
         A5zrqBqhtKFHm1bZI01VdSrfTkW4mYoLvOQqFF+tl9L8y8v/upuxNisSsxNCJmdM4hO7
         Fm5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779296782; x=1779901582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nFISdxX0pfMGm7mkdTuVkepPKyGH3+oJOU4ujc5bnFY=;
        b=I/HiRVBgixzS1tAx3hePaP/TM+9a6YxuUAw5qBvCStyCx/mm/F+tZHGRnmRpDqmWc1
         L6nn8v4HcTpH53TKCrMoM1QfpOMt6hcXCMW+rhGNZD4/jBgxnENPfy+EgDp2qk722RuE
         uC4e202LCIkOiVXfX1GRxVSdyXRSQ9dverUcN1AZJSXBR+ZIL4SromoLWie6Z9qO5yno
         jgZvaAazAnD3fGxfLAA2/tLIS6X5BlwE3jSwK++8kC5dDoAYgjo2nN5cFnjpftYkFuPX
         dtSHc0kDd8ALQh90ozlyCGqN7AYfxu8ay6ghWd26risHn60+4bAHX9GmEfzGbgwC58T0
         U6JA==
X-Forwarded-Encrypted: i=1; AFNElJ+hRziAxkFU1vDbfFnxfTTIj99oUgraMRjLbDvxZ3dF96rS14RR71QTE0UlOIDqXA77IXhUkoNAxg==@kvack.org
X-Gm-Message-State: AOJu0YwI+nbt+f2jNSsN0HNj97cuBoxN7+A1MIjrigYtE0QbYcsQLmaZ
	jm9RAmNX3UZUg33ArhXrLpxnXktre6lCIlzSsacmCGA4uUo2oSRJYsdKXT3rOhg5TusUyzj9pe8
	dDn2ZJsz1l0osORSl30Pazdc+jtxV0yc=
X-Gm-Gg: Acq92OEhCk6Ug1TcbkxbtvHdYr576d0xGQWU5Ul9AJKfvuZxVGWKwY52DdiSQSNJQyN
	JVYLPWOa8IJWhtluPvDfmEmFC5RPMXZa/7vlf393uxcsHCQhe/hG30PXxWS410YCzJ90Ub2Hdlp
	VlMFCn1Tlf7u3DYAt/ODcOynGmzzAWvKElFEUzh9cyzwiNI1YHd5zU46PKrHAew9zpc83CTc/ns
	Xsw0+v89NM7lbgvaph2kXixLEOvo4iXr4Gg/IPlToUk64HwUGs7EW8nCllBOhE6aBhXrkmfLxnF
	dDeeJg/P2cs8AAzSCt3Tf9FtZqWBOcjHrBWCflbbijBVCZn0MATJHbkPSV/oTgKoUO4UecISQZH
	P9K0lTeU=
X-Received: by 2002:a05:690c:95:b0:7bd:9ce7:164c with SMTP id
 00721157ae682-7c95caea6camr255420347b3.43.1779296781530; Wed, 20 May 2026
 10:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20260519-panthor-kasan-v2-1-b7384458f076@gmail.com> <72bec63c-09f2-4a97-908d-3e6af8e3e0ae@linux.alibaba.com>
In-Reply-To: <72bec63c-09f2-4a97-908d-3e6af8e3e0ae@linux.alibaba.com>
From: Chia-I Wu <olvaffe@gmail.com>
Date: Wed, 20 May 2026 10:06:09 -0700
X-Gm-Features: AVHnY4KCjJFV5sGNMkYIse20ZX9pmqbwIjImpX4-u232uC675gPXBTQzEBtuCAs
Message-ID: <CAPaKu7S4JCRiTyYvTgXHKP9osH8yh8YVzXiPQuNVAV9pBZtmuQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] mm/shmem: set __GFP_SKIP_KASAN for swap_cluster_readahead
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vincenzo Frascino <vincenzo.frascino@arm.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Hugh Dickins <hughd@google.com>, Kairui Song <kasong@tencent.com>, kasan-dev@googlegroups.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Boris Brezillon <boris.brezillon@collabora.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8D5522000C
X-Stat-Signature: cfbqcqb1ydid6ceja9iidekfwefj451k
X-Rspam-User: 
X-HE-Tag: 1779296782-174640
X-HE-Meta: U2FsdGVkX19hIrm4TiCPjuPJM1hIGhHES7Q6IMnc9aMn7xhcrKaUIHV0HHch84B7UFdv9YELsICFKW0iW0Xd65cNB512xxwz32DRHJrlO5VqpWGhXwqy/L2GhymofJQblpEZbnyeTDkMEeoRjz6Beauey7UH79rWWQThE/XPmgvRvJ3XOuzaDCVp8KXMlXZXgNoYPmzWarIU9Vg1ShiD8aTjXMlzjlVX6V0qh7SPhPKTgxBBjtvK0Ndv1VG3sJA+/jfwUgEd6lNv4+wMDFk7tIi/0DIFUKbRowWHfrvgHoPzEtA6TWYX7MdNZyRCxNq1uk9yZY+kA3jcIlPnZ51AIM5NaL0z73Z/1nyJy+pDWSceETaOMnOc4BtEOlerVwkYoEss0AcreiukYi2nQAqWn2gXkSQsSc/7kZW6ylXgm6T9ibPrqfMH4gH7HZsNJwukotm6BK4iHjqZJ0KH+xO+QbwprX5jwpCN4gKHYe4IlQGeZTTaOYRSXFoAi8K2895H/AMetUqey4KTxAv96UGb+AcV7/JGPfh5gIWRVw3+6+mq9EmT0LWFOxIFWZrO9XMcEXUxcHaAzOvQJiI5EyQ0AvJj6mZp+J7JAsXVcbxUZZp5mSioduiVMea7r2doiI8T+wsUzAsslmxl9JOZgg4x2ikD8NkV1Vl0gFiUZaikS9xWcC7DbGa2Njhav9jP3R0UyD8w4oy5X/rmLmHcbSq7z3Qn+0sRIqOYAUV4RWSFuil1tFgvZGWPsDD+/srT3IgXLLlH4ED31UD65TXNeorNuptSToI/34WNaDONqAIJkmD7vDBLLJ7+gjvTwmXTnYwYWgBqwm0Zvwae1zeaDqo1Ebjlnbk/emfTBlyt2qYGcvXKNAsE/eDIj/9uh5C2scUCEC/SNu131casR1IMqieBy+8rLSzaMjDHb6MX0fMEh+EfqZD47sxd9kNHclVXsIa+EIgpioCR+vzus4DESSp
 ElOMnBPN
 57w2+nj4Q80qj5+tq+WPHhw/8nkCb7MHpuFkoUR5z/ozt//lI0iRn1S3pEX9wx6tyIg0An0bLsSb6p8IyrUQtIzvU2rY92vv5u13Dkm2cGjuquhGVXVa7gImCB8foM8SjyE9r3QQ7VJgxFguYY7KCXqESYr1KaruVbonNntstJaKGj9KaKZCwUZIH5zKbV+Sr6hGMMA+RwuuVQUL6cJJ7jJxXx14Wovm62YTJlmqR7D+niblw6yAIwPxYbpFQER5tt5PHiPN1cpWrLGAsIQOkMkQjafH9awM3VLmRF1ItgK/Fy+NyXeNVM/3gekA9G1PzbGHVOEybqAFQzvcPddLAdYZ3BiT76xeRCGEM0sdM4bv1AOVwJJdnSodcnuN2tJ4+gAKlYegA2B39Vv3xIAmm7mjMCeeqLY+nQYyjsqhd9w5AUe73yFkEAiidTL/xbsKvo4GtN82QfRjc/LMixZ/+66b2jBOrUQVCgk/aiqjONHD/nNrCnppj5wmNVajMIKFbyTFARAmVhrN1aF62F+/ligBndS/MH9KOWWXPzI82P6TVsYBrtqaivU7IvoqOtTk8YubgjSzFdhhDeHclx5swM1gVFj68BbCmXqx9DCQ8JWK/Q1fnEnbha6rN/EQSQjOuj9Z6LLWWRbknYepejPVCNW9Qxg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 20, 2026 at 3:04=E2=80=AFAM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
> CC Kairui,
>
> On 5/20/26 12:31 PM, Chia-I Wu via B4 Relay wrote:
> > From: Chia-I Wu <olvaffe@gmail.com>
> >
> > swap_cluster_readahead can allocate folios for other mappings. If the
> > gfp flags do not have __GFP_SKIP_KASAN, but the other mappings have
> > PROT_MTE, we can end up with false KASAN errors such as
> >
> >    BUG: KASAN: invalid-access in swap_writepage+0xb0/0x21c
> >    Read at addr f5ffff81aa71dff8 by task WM.task-4/6956
> >    Pointer tag: [f5], memory tag: [f9]
> >
> > In the above example, because __GFP_SKIP_KASAN was missing, KASAN set
> > both pointer tag and memory tag to 0xf5 when swap_cluster_readahead
> > allocated the folio. But the userspace had already set the memory tag t=
o
> > 0xf9 before swapped out. arch_swap_restore restored the memory tag back
> > to 0xf9, leading to the mismatch.
> >
> > Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> > ---
> > Changes in v2:
> > - set __GFP_SKIP_KASAN for shmem instead of drm/panthor
> > - Link to v1: https://patch.msgid.link/20260512-panthor-kasan-v1-1-d8d3=
e275d71b@gmail.com
> > ---
> >   mm/shmem.c | 5 +++++
> >   1 file changed, 5 insertions(+)
> >
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index 3b5dc21b323c2..db9130a8c5b76 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -1784,6 +1784,11 @@ static struct folio *shmem_swapin_cluster(swp_en=
try_t swap, gfp_t gfp,
> >       pgoff_t ilx;
> >       struct folio *folio;
> >
> > +     /* swap_cluster_readahead might cross the mapping boundary and
> > +      * allocate pages for other mappings. We have to skip KASAN.
> > +      */
> > +     gfp |=3D __GFP_SKIP_KASAN;
> > +
> >       mpol =3D shmem_get_pgoff_policy(info, index, 0, &ilx);
> >       folio =3D swap_cluster_readahead(swap, gfp, mpol, ilx);
> >       mpol_cond_put(mpol);
>
> If we force __GFP_SKIP_KASAN, would this cause issues for mappings that
> explicitly should NOT have the flag? and your v1 link already mentions
> this scenario.
We lose the benefits of kasan hw tags (other modes are not affected)
by forcing the flag.

The other mappings swap_cluster_readahead can affect are anon
mappings, regular shmem mappings, or gpu shmem mappings. I think only
gpu shmem mappings miss __GFP_SKIP_KASAN. That might not even be
intentional, because gpu shmem mappings pick GFP_HIGHUSER over
GFP_HIGHUSER_MOVABLE to avoid __GFP_MOVABLE. That was before
__GFP_SKIP_KASAN was added to GFP_HIGHUSER_MOVABLE.

I guess what I am trying to say is these are all user pages. We have
to skip kasan when user pages can be mapped PROT_MTE. The
justification for gpu shmem mappings is that they cannot be mapped
PROT_MTE. But if readahead can affect non-gpu shmem mappings, it seems
we have to either force __GFP_SKIP_KASAN or to cap/disable readahead.


>
> Additionally, I'm wondering if we could use shmem_should_replace_folio()
> to detect such cases where shmem is being prematurely swapped in with
> incorrect GFP flags (e.g.: __GFP_SKIP_KASAN), and then handle it through
> shmem_replace_folio()?
I don't know if we want to impose a copy for the benefits. More
importantly, this only helps shmem mappings but not anon mappings.

