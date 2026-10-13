Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FB44CC6B03
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 11:23:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB2EF6B008C; Tue, 13 Oct 2026 07:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E648D6B0092; Tue, 13 Oct 2026 07:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2D886B0095; Tue, 13 Oct 2026 07:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A4CA26B008C
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 07:23:31 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 66F001A0B66
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:23:29 +0000 (UTC)
X-FDA: 85317367338.07.D33839F
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6731C180004
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 11:23:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="v7Ad/SaT";
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791890607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lglLC9+yE+tZ+AHV0VONJs0/vCldZdYwmVgqh0e7e90=;
	b=zwxxR4i17cJeLDekBzINIhzdedimfRsjtyMFvAPqr4tyfgMes5jDC8UZJrh82P+N+2lN+5
	uzln91K+g07DyACqSsjSFL8WGK0A0SJAwGBLQVUWn3WuvqySqun5RXtqasXgOwTLLHMdUE
	EtvXw6m70WKRCNKpEa3D5bCq50C7P9s=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791890607;
	b=w57Tz7xgA2zspKInUf86pT1nuFZ83CkgfMFWMGsF1YaLjc46t79FFjEsKQHRObNMkrK/cq
	g1zEyUWQ+S7CH0qaS0EjJHpcGE5zrn3beL6Fshp29YsCwmDO+yt6H65Q25/SDiDxDX2J9+
	K1OZvA+yAjzC4G4y5gGTKAi8hKyiMmY=
ARC-Authentication-Results: i=2;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="v7Ad/SaT";
	spf=pass (imf06.hostedemail.com: domain of surenb@google.com designates 209.85.160.176 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-535f598d126so87291cf.1
        for <linux-mm@kvack.org>; Tue, 13 Oct 2026 04:23:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791890606; cv=none;
        d=google.com; s=arc-20260327;
        b=N9NA47EW8d+605xHrh6G4xA1Pp/C655Jcuudk2EZh6UcwXcQTW3pWj++9B3MlJZqk3
         PGhyIh6gHmLY1g9rDmkVQuQF7uagDUsZxtlSBLGvuA3LJABx6RcUZGqkX35NzOlUueHW
         9fsIKtS6TT9gXqtItE73ke4byCOYfyDdggfIlC1XDDWCD+TUcwIKHyynvMxNsezaqYNN
         YTQytmRSG69fBWwBjMAOAAyVdev8OsSY49bn629ALqc/cghvtFi8vIkDATiF7qN2+6wc
         YATLVcKbEtHROcq4eRZYWsKVU+RFgubBqvLZBZHmmpqZ8v/roEIMRPbOTiLJMbkZUhLU
         oy7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lglLC9+yE+tZ+AHV0VONJs0/vCldZdYwmVgqh0e7e90=;
        fh=egtoWdMzCNGFicc5RryQtLWMemDdVfVv09F4Rput/7o=;
        b=fCQ5KyNACt3BJ4E8nNM3bzLmEaw5yjvCUbfhu6235XGMz2Tl4NP3XX0JDOtnBexscS
         QijP7r93VCc8CjC/IJdEuA+EqIo3m+rgWNMbmlwor/4biUVy1zBfZVSxYyGL2hd8nN4g
         QvHIRJGF+IlkAX0SYHKXyrlQQ+HBbuWwAZm8UBc4RjsrfDZKvmOBefO3tMMCETsfRSGm
         6Daf504Ild+Fu4HhscoIMl6akeXsi+M1h74aor70p10DH5LhGKa9NhxG+hZD4jyf+iSs
         dm79XrK5Qr5cmKUqVWR1DTXsY+5Flee9eNbHFJ2HpXDAcFz4jXm3ofuAk9s0tU1rYIwG
         lAXw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791890606; x=1792495406; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lglLC9+yE+tZ+AHV0VONJs0/vCldZdYwmVgqh0e7e90=;
        b=v7Ad/SaTGw47TQJPF56gfRIS6BGwv78I6KdZJcb53zCPxSV67ysfd9LKje4B31GIUh
         gZma4aPy3vZyoRzv5mm2h0PlbetOCQpwvBAnV+T7PxgitAHri/7oHuT+6cz0hTOWEmQ7
         a1VAFdgbXZEI38SLE7lkuI/c4WHh4Xdd6LmjyC+PljrX6BBqPgiRvdaDH/dNRbPeNjWV
         oBgNsxw9beXQQwEBBA1x+L9+2AM1JNbzhxT42/ACJcFNzLEcMRH8xsDoV0UqRitXTrfS
         YKuOuMoHGpIx+QaCF07IeSCcD1FPDKaOqZMZ3UcPjnAmkDabIZAyyvudLwZsjF+f5uU8
         cIfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791890606; x=1792495406;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lglLC9+yE+tZ+AHV0VONJs0/vCldZdYwmVgqh0e7e90=;
        b=iKryE3sDCQrIBgf8ZWNKtBGNbuDhBNR8Dj91//fy5/9GsGKfDgXMJ7pw7/4x75tX15
         b0j4zObz/HH3aTJu3J1QPC+PT8mU6Ff84+AGqjX5nKEDmzqWKa/RawMEehoPI44jHKhL
         PQ1QNSI902LOCaT7AcC5KY7VoHAJXuOUSjNh0mBYyfWm+PrROtyz4ro7uLZbEl3LgmOS
         LncQVgPB+aKWzMjAqqLpRqDCvebQrEyrLQg3JoetqK+KgJPWX0cnQCHYD8ccrptyR7d0
         r+eTJYlHl1hzrHT56JccOqvosmbWAAQerbPVZtooQLlLjmyYsn/Rs68H8IOR7c2Qx+2C
         Wp5w==
X-Forwarded-Encrypted: i=1; AKwUvBwb54R7TmGq0k1Ndo0q/p7x+Dxtd0h1jfn6smvAUr2zVSS/BDMiJ0C962ZXStcovWRiCc5KEFGfpA==@kvack.org
X-Gm-Message-State: AFq9FYK1R8eBpyU2X1vGPYWNsK/mXfG+Of8LXhqECqndLr3zkKiDWoLN
	E7jKGa0niTzbsS5U8JpLsKqUvhdAr7lEDFhDt4sRFPssa0nwT5WP3UTNNZ0f3pGtbL/bahFvJ+K
	tR0EH+H1gxj4/k5oIZlAC1iguWKDHibqpQF7DZy/R
X-Gm-Gg: AYBFou1RRQU4RYkYtPcd0XWUHnNFRhwa4p+6nLalGs80HOHHvMYSKkopZ9EUB1oAdER
	/a59cBjr/20IhJwlQ6wxSCI8Fqaf9FJMRbNxrxqTi8giJsi32qbdxiyt+X1ldzPhAjPO9TlCxd7
	xGTelmtQ5h4mBLdBB6dwIsEvT8ufa/diYyT/0EtpT4QZUL6tEu/1HFevISrvxcKY3nCs0yIVKA3
	/doxeouxfIj6qW1mIwFmuW+M2MWWhPedy/eErhZw/wDWWDjv9UYv6epYoJ/LcAxDlcW50VDOqTR
	ixipOBFjrukgwbETuXeWygiORCzw4vk+PWkpakuG7CnwAam2ByGHRN7p
X-Received: by 2002:a05:622a:180d:b0:531:34b9:2532 with SMTP id
 d75a77b69052e-535b320372fmr48865141cf.4.1791890605760; Tue, 13 Oct 2026
 04:23:25 -0700 (PDT)
MIME-Version: 1.0
References: <20261009063619.112313-1-hao.ge@linux.dev> <20261009063619.112313-3-hao.ge@linux.dev>
In-Reply-To: <20261009063619.112313-3-hao.ge@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Tue, 13 Oct 2026 15:23:14 +0400
X-Gm-Features: AclHuK-YS0X8RHvN1DiVTwo6aWWizXGsTLGePiTKV5Kwl9ajh5-w8CnH9PG_B2Y
Message-ID: <CAJuCfpE9VfgTw2ZNMJTEVh41H_R+1RY_MtzeMuZNCD3BFm-Piw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Hao Ge <hao.ge@linux.dev>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	Nicholas Piggin <npiggin@gmail.com>, "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, 
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, Uladzislau Rezki <urezki@gmail.com>, linuxppc-dev@lists.ozlabs.org, 
	linux-kernel@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6731C180004
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 66tzddqbcaiyedtf43kcfgjigywhtf7p
X-HE-Tag: 1791890607-798606
X-HE-Meta: U2FsdGVkX1/7Ah7Vz98gbuBW6H53JlghnLQxdeu2wIYHfyLqU5DQbtT99ECaA2nysZmcrkR+HGYXMo7zkvYstNlXS3w813krjpZdw6t3ICvtkKJZ9OH0goCEX8uWGUAD+Ttq25nWrHDQHJ2setrZzHHE0qOtYDdqu9LYQ3NYFB/ter9AzjchbpSJ4oc6yC6Xudch+FqhUzOFwFg6gY+GZRMMQRLVQldACJlfj5vUcjivgrWz0ubB7WymsXR6/+rhmxQ8AHal8BuF4iRNjii48Qs2SMbHwVmczc4TWdhvfotd/9v9miMwNhhySsq0KfgytmBsfRB1R4sZGrwmpsP1ryuOjho8XVguEk8/uhqHreptXVNRnYMLes2eEqnRpk/s4lYVYseVBr7QzoKeQYYEZpBUBP0C1lYAI2WkSrcPHYjMXPfWLSymVzH52RiOcuTbPLdHVZC7T4RepGVITaLaE7Ljr8UCeyS0dm5MLxbbCowy5avCdIvCpmka1oF2MyiF/+UrDsCykyznSP/LsZgdEH7t8nlAgpd375hGC6sh62BQgL3G3mNFIyN4edNnJOPY2h6OFyeyVT8Rn7U5QhFXDxE6MQV5w/42vg9UIzo/ioxuBYHgg5GFwvVGIuKJ0HpH1MNM6liQEi88YEFEFvC+ZAqzae/gL/dpLEt/7fmexBVwRzTFK9DBz2rQaC37cPN1gfnCxMzuidfvd22ofrTP34DxWumQvBXfHZ9Z8b4zZyfIaOiLk8Z3OLsOlvayFwwIgG46WtWR8pmsee/Oe9G+CBUYxNuvEZ+kpplK6p7Diu6QkAngUfv+i/5YUAgHBVuQQ2jsaUtjHm+E+Hv9NMOmrfVY9yC4VHwbQx6R9+56+3eobntPqpyJX4YusLr8uN9nKo/YgsM6GSvLJ2u8vgIj5tQWHMwyRTighI9rmDEUnJCc5k+Ri17/YQuIQ6rzxejgl6l09ajgcvX+eAwp8VS
 XTEZSe5N
 Z3Qf0eZiAT18QpUDg4HTJxvQRL+8HUzmtVcEn7VOG16giWs1XMl5+pZruJimFgFfXMUcFB5ND4vlElrOCYtojw26/NElk48frQjNRIZLEDuqm2MnVyyPBlyC+nMrHO3DRrvbbul4MPQ9Ln70MY7MdWAX2SQl+Sqrt8zXO9u0Tte8EQeSst7UaFL9dvy+ow3KcH7n79KBlqLaGvqjjhIZXHeQAt+RiSpV7KfB+OJyx8CNOM+jtRBa4c1l5Y9HFVxkDxUmkcx9ZnPEfoUTWvilo7hdAAYRntxyoPWzd3EHR0/ubEkJX4Lmvd7L+qnsoZMDtDAP6UX17Y23RDtwrJCGQ0RZgbgN+TOsQP8cCwThq3rKMjeQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 9, 2026 at 10:36=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> __vmap_pages_range_noflush() and friends can install some PTEs before
> failing and leave them mapped, and the kernel callers do not agree on
> who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
> roll back what they mapped before the failure, while
> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> __vmalloc_area_node() rely on the mapping functions cleaning up and
> do not call anything like vunmap_range() themselves. When the same
> range is mapped again, the attempt hits the leftovers and fails, with
> a BUG() in vmap_pte_range() for huge mappings and a warning on the
> small-page path.
>
> After discussing with Suren and Ulad, we decided to put the rollback
> into the entry points of the vmap API rather than into every low-level
> helper. __vmap_pages_range_noflush() undoes the whole range it was
> asked to map when it fails, and vmap_page_range() undoes its range
> for the ioremap-style mappings.
>
> The rollback is __vunmap_range_noflush(), it only clears the PTEs,
> no TLB flush, nothing has touched these mappings.
> vmap_pages_range_noflush() drops the KMSAN metadata when the data
> mapping fails, and an empty range bails out with -EINVAL now, which
> used to BUG_ON() on the small-page path and map nothing at all on
> the huge-page one.
>
> Reported-by: Sashiko <sashiko-bot@kernel.org>
> Suggested-by: Uladyslau Rezki <urezki@gmail.com>
> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> ---
>  mm/vmalloc.c | 44 ++++++++++++++++++++++++++++++++------------
>  1 file changed, 32 insertions(+), 12 deletions(-)
>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index db669103dc66..e1b376f57dd2 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned long=
 end,
>         if (!err)
>                 err =3D kmsan_ioremap_page_range(addr, end, phys_addr, pr=
ot,
>                                                ioremap_max_page_shift);
> +       if (err)
> +               __vunmap_range_noflush(addr, end);
> +
>         return err;
>  }
>
> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long addr, =
unsigned long end,
>                 pgprot_t prot, struct page **pages, unsigned int page_shi=
ft)
>  {
>         unsigned int i, nr =3D (end - addr) >> PAGE_SHIFT;
> +       unsigned long start =3D addr;
> +       int err =3D 0;
> +
> +       if (WARN_ON_ONCE(addr >=3D end))
> +               return -EINVAL;
>
>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
>                 return -EINVAL;
>
>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -                       page_shift =3D=3D PAGE_SHIFT)
> -               return vmap_small_pages_range_noflush(addr, end, prot, pa=
ges);
> -
> -       for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE_SHIFT)) {
> -               int err;
> -
> -               err =3D vmap_range_noflush(addr, addr + (1UL << page_shif=
t),
> +                       page_shift =3D=3D PAGE_SHIFT) {
> +               err =3D vmap_small_pages_range_noflush(addr, end, prot, p=
ages);
> +       } else {
> +               for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE_SHI=
FT)) {
> +                       err =3D vmap_range_noflush(addr, addr + (1UL << p=
age_shift),
>                                         page_to_phys(pages[i]), prot,
>                                         page_shift);
> -               if (err)
> -                       return err;
> +                       if (err)
> +                               break;
>
> -               addr +=3D 1UL << page_shift;
> +                       addr +=3D 1UL << page_shift;
> +               }
>         }
>
> -       return 0;
> +       /* Undo the PTEs installed before the failure. */
> +       if (err)
> +               __vunmap_range_noflush(start, end);

Would it be too complicated to track how much was actually mapped and
unmap only that portion?


> +
> +       return err;
>  }
>
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -715,7 +726,16 @@ int vmap_pages_range_noflush(unsigned long addr, uns=
igned long end,
>
>         if (ret)
>                 return ret;
> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_sh=
ift);
> +
> +       ret =3D __vmap_pages_range_noflush(addr, end, prot, pages, page_s=
hift);
> +       /*
> +        * The page tables undo themselves on failure. Tear down the
> +        * metadata that was fully set up before the mapping failed.
> +        */
> +       if (ret)
> +               kmsan_vunmap_range_noflush(addr, end);
> +
> +       return ret;
>  }
>
>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
> --
> 2.25.1
>

