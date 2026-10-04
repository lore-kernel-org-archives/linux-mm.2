Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82019CA5FF0
	for <linux-mm@archiver.kernel.org>; Sun,  4 Oct 2026 17:42:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88BB86B0092; Sun,  4 Oct 2026 13:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83C786B0093; Sun,  4 Oct 2026 13:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72CDF6B0095; Sun,  4 Oct 2026 13:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EAE726B0092
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 13:42:26 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4DC731C3FA2
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:42:26 +0000 (UTC)
X-FDA: 85285663092.02.D76B18C
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 5BDA41C0008
	for <linux-mm@kvack.org>; Sun,  4 Oct 2026 17:42:24 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iNeZnHC+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791135744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lc5562D3mWi9zthF4OGWqkURt3JXx0LaNSqwCjnMAYk=;
	b=xKjsgbs5TsytvEILvdg1+vRVREPpWa0m/jvMnzZWvlRLcOZQ1u8Sp4+dlTVWUzlIvdCp7A
	0K0F8nWP/vXwsTCs0NP7uxP5spSNeDjJ0yGPR7rHayJuZHvUoc3XEZl1rXrfMGjIk9UJqV
	CFez1X3CtPWCrLxZJtDVX0uW7yDpp3g=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iNeZnHC+;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of surenb@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=surenb@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791135744;
	b=KgUl30C9UFiBTDmYs4VsHDlCfFel14MEld57cEyoeFLd4RQjnPGyca15J8+ZN7hrdsn+c0
	HYIjpVPSDayjmA6OPzjd29ZjnzpHfaPVrNAfpCSjFw4iIL+/mCrmvPSiE1wQC6J2dJ7cxp
	/THESSBup52YboBDZnGMpJUSdmod49o=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-5337fa12431so183151cf.1
        for <linux-mm@kvack.org>; Sun, 04 Oct 2026 10:42:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791135743; cv=none;
        d=google.com; s=arc-20260327;
        b=A0v7d+PWgFK8SAgndFIFcKN5qBk33L416cjrC/AM68F1v8stMxDoMZL8dsuYPTICYg
         NDxsU/YhNn5cD3WC/7RdL/ZREryoHxKWB2bZI1tRRSalHyaL9EP6Orp0T/MMv0mED5ed
         IC1Z8XFBWE8DclmcUzNjo7FcWR+vyFffddgMSkENBzMu2fiIhVrToMP708rzd95evy58
         3WQQbGOuD/vpogRQUMLGyLFXf0Hh+rWv1GoxaheqEbocHAZrcvuKPqd1mvhKEEzT72Tj
         ecaew6za7HRKW502E/0dahWtI2fSe9UupKrE8xqFIO7r334om/P5VY+Vt2ZpMYJoLk/B
         RJFA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Lc5562D3mWi9zthF4OGWqkURt3JXx0LaNSqwCjnMAYk=;
        fh=cZKWfUlqvWLMV4VA8xEs14D+yBLDtmD/p97Hk1MOUDU=;
        b=K3K7iN8bf+fmFUuboBemY5dNEBxwdxenGOMCnufZy559sykeVu2Q8S2Ngb1/3rUtji
         Vwy1U3F0vTbXOc4RMQlE9lYoSdW1+DOtXY6t748GYH0JNdWISKauREUCFMm3AWsQSOWX
         ZB9PMRBeDSFFVgpeFDg+i87ggkructh/LEYjeBSY9O/mVu9jnXk7HT4EWy9XXyA7ENgB
         2aVaIneG85IH8WHdM01RO109C+ktur3xKZeR/X4aLJ5hsKNCTG89mhiV7LsWsPKhxe+7
         Q3QPZqdGGGGEbOPTN6HZmwzYjW/BbP2ta+8/0eQdQpPDpecRpsSbvMBqNbndfdAaz9nH
         0YGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791135743; x=1791740543; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Lc5562D3mWi9zthF4OGWqkURt3JXx0LaNSqwCjnMAYk=;
        b=iNeZnHC+dJtoMH4hMEzUjxl5166errFi0yrWdvAl6Upd+0uBWTyQm2P1/P7z9NlWfR
         9HefmwL986/YcaPrpZTsYZ3IAX3GRO+YgtbXgiFiyWZxG/POnItEYn3tIyebSbNNTGhs
         eDg1eHA96JJCmw+kjD4NYKjFvPtzNM2pZde7mi5RAgxfI94O4FwDjsVnb1kgJ+J6125h
         slFBNNF3RcR/T0neKD8/kjfJ7s8ur0B+sUYnr7C5qST8dXkvdt+BpOeW+EsymTH+3qcI
         RO2xWwBbLL4mUfBox2HmUyfOV4NZnQJKE9yifT0x0NKXBMOJd01tm5LedCR77xfi3Qiq
         jkmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791135743; x=1791740543;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lc5562D3mWi9zthF4OGWqkURt3JXx0LaNSqwCjnMAYk=;
        b=IICVb0xS2uTbGx1WQkYrXzjhHcI6JV0fsrvqwN7wRYYCj+SmXVQ1IeZS94QBWmAw4K
         LU+VT8BaMLMdXNwHJogKVplZQLu6OgbgpaZZLeDQdOCipBkk38VcLbmPX1oXZplXM3qF
         73mOsLvJxFdwe49w++F2Xv6nk6qMgVSj5ECCxN3n36eYQEti4Ywo5v2bgoPbvYexs31D
         HzqSBVILgv52OJgX8MdgqgH1hTnhLp8oHxL7NKZLvGS5+YNf5XSiAD84AVBd9Urdjg6Z
         zaEFr76bUA71d7nqvQba+EXyqTFDJyxHf4eLuyhvU8GRLJbJ8L2ckNCKgJYj6ffqbirv
         NROg==
X-Forwarded-Encrypted: i=1; AKwUvBztAQOGR28YDb2vMrK5/i/lVTMkXN8xLaabXEpFG/LcT7bOGDlzqwNYGpFwU3uU+8FDhVb5pV4EVA==@kvack.org
X-Gm-Message-State: AFuF++l/ntcle0H4U8NSQomW0I/T/h+ClJJ+eODX4wfvE48M2Bimg9M9
	YtxiFb+ChUupJ2FaFTVkVWDEU3+Q1ZHxYAzKi4nc2eKETHk7yyF/7bMBODJv5fxa6YzNHMPBupC
	2BOIrWkQgGssLl8qdiRyMB/GnurBhpi1bSkYQ+tU9
X-Gm-Gg: AYBFou0lUKjjfmW8Mo1nK7b6UvuBkMMgUAmF9XxPnX0USMJmjR7LfVEuTzrPc/OTqNS
	SvK1AiD08jToxnRcTM56juiWavcu0HwcykKQxGpl+ikydsQp85yqWg7cLYlW0+ztD1XAmiA6wHf
	ORRz7W1UZtdBfkjAI1nIHcrTCh/w8kosf2OrwhCMFDl7UbGmykvLUl++CXTJstxPOPOWDinnynE
	+r3STm1uaZHI+l6bneek8RpIGlqvVs5HS+D5ttGeLKf2FOUvCs2oiycSP7REld1iRrbfrLckX+k
	NhTPd66t8Yr1P5ukei5zSFJY+34k8A/k34hbWkxtO/77hkLjvFK3QerV
X-Received: by 2002:a05:622a:606:b0:532:84d3:abb with SMTP id
 d75a77b69052e-535131b5a84mr14423871cf.7.1791135742728; Sun, 04 Oct 2026
 10:42:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260929082014.160587-1-hao.ge@linux.dev> <20260929082014.160587-3-hao.ge@linux.dev>
 <arzgoe-bXAz1poAt@milan>
In-Reply-To: <arzgoe-bXAz1poAt@milan>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sun, 4 Oct 2026 19:42:10 +0200
X-Gm-Features: AclHuK_ov-dYU8ZQ3hSK0lFHr-9gA3i8l8r8LsI_kBqLCittdU-KxegpDjovpwQ
Message-ID: <CAJuCfpHavrwaJ2T6daHnJc+r=9khBwrv_zOp8s3Cwi347SHXRw@mail.gmail.com>
Subject: Re: [PATCH v11 2/7] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Hao Ge <hao.ge@linux.dev>, "=Kent Overstreet" <kent.overstreet@linux.dev>, 
	Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>, 
	Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>, 
	Aaron Tomlin <atomlin@atomlin.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-modules@vger.kernel.org, kasan-dev@googlegroups.com, 
	Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 5BDA41C0008
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: i6idq4zpb6oo8ux9bgqxrutd48bskjsq
X-HE-Tag: 1791135744-139364
X-HE-Meta: U2FsdGVkX190DYUYXmyM4S+qTkEVqOcybByCb4i5FiK92mzX8jKh3Vt/GiPQsRW06uVaxnZ3KjTiMh27YTWOR81s40IqV0xqGVcUoxn/2qcRaFP8BM3hbl8kjkFHveXuQZP6JlRXXeWq19qqSd2zPqAqygFqnVZA2XckYHzFiNBzqL6+0jtFQUaam02mtA7WvmU0L4FLU9QmVM5/ZpNWdzC7H1NJXOq9AyECVolPgky6qwwi5f53R/cOHsSQ3A2XhVPGKKmUUf/vfjBSGeMSvwkKROPz6nS3faRkHBFr2/jLcIVozzkJjJwTGm5Fxj4gqSRhejLZMf17HlYtWp3gjLZCGkSzF9EO4S1osY+mgUJ97fFF3yoUgyfsCyTg9ql27r0o52qv1HEeBQGCwOrgKu9lXTipcPTlzGMFmzX5W37pMvdosMRbKvhX8dx7znp+ZVh4y6isRTcrkmt39Ol6rUUKInusAUDZFE4ztlpAzFfV7NRyoSrA2A/zqODNWPKj2jDhDXpFWTGRa4YfFZrM43jO6JrCQMdhbRAnhJ0vGplj456YPtQjHrAILaw/0UHdXUU5VorO2hp/n8PmDK2htPOorF07dtCHr1c/8FIFOTdQv4KdcWYIfE982XhdZnaTSUbRQ+6su/+xXNJXNZqLOscmvEq/4qiX1eqVfNcf7/ydIAP6zMeJWr3AE/tjVu7kfMS7FyX7L8YIV8Qnkcq2ng9ZluaCsnHtdtxBi+zsyntFEH1rxwJwg3iK42zN+PCDC3w+2BEyb3KEC3q+uXykvEyrQW+kXl4CigX8+9iL1UL2GbVR7hOXVh1V9m95wrQzb8OVr/vcZ0hugeHY+0fJADXdQVFHdSILuehHoNVAEP18LgJ5XJxuE7dzs1o1iGpmArbG5k4f6v8gLObuCWSDG9eqEbORs2GJ98P7fATGK+e2YitRjbPN3XffAmGwx4nle8uxHTTOqiBlMPNzLtj
 Ztdxp9DS
 rpjpm375XK3JsnSvyKtNJsaW838Y4B6WzLx7WHtyBEdiW2rtwCyr4Z2QhHWB2aFotBPvfCZczFH4aPM5KLhqLbzY0VBy6AbZ5hWgZ6NXUKATazKBBRp7QEdCV7rq9JKt1DGCJfQRqXxmEJK38kUHdWyv40NXgDtiFHulgU6srGRr1mMcKgZmKhVy/zhc/Ou4kMrpLQgPW1F5GtNm3Uv9aFM9TOf8ebrHZ29kD6n74kUm6/w2OCk+6QQWLslnFbdtSowBjRFCaHHzv4fzXuDQ+P4DhRf0AjYnNp3rm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 30, 2026 at 12:12=E2=80=AFPM Uladzislau Rezki <urezki@gmail.com=
> wrote:
>
> On Tue, Sep 29, 2026 at 04:20:09PM +0800, Hao Ge wrote:
> > __vmap_pages_range_noflush() and friends can install some PTEs before
> > failing and leave them mapped, and the kernel callers do not agree on
> > who cleans them up. For example, pcpu_map_pages() and
> > kmsan_ioremap_page_range() unmap the leftovers themselves, while
> > vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> > __vmalloc_area_node() relied on the mapping functions cleaning up and
> > did not call anything like vunmap_range() themselves. When the same
> > range is mapped again, the attempt hits the leftovers and fails, with
> > BUG() in vmap_pte_range() for huge mappings.
> >
> > After discussing with Suren and Ulad, we decided the cleanup belongs
> > to __vmap_pages_range_noflush() and friends, so the callers no longer
> > need to unmap the partial mappings themselves. Each function now
> > undoes the PTEs it installed itself.
> >
> > The rollback calls the low-level __vunmap_range_noflush(), it just
> > clears the PTEs of the range it is given, which is all a rollback
> > needs. It cannot use vunmap_range_noflush() because these mapping
> > functions also map the KMSAN shadow and origin, and for a metadata
> > range its hook would look up the metadata of the metadata, get 0
> > and BUG() on addr >=3D end. The failed mappings were never accessed,
> > no TLB flush needed.
> >
> > Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
> > Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as nee=
ded")

I don't think this fixes 0f9b685626da. I mean it fixes it but
indirectly. That patch expects vmap_pages_range() to undo the mappings
when it fails, which is a reasonable assumption. By fixing
vmap_pages_xxx we fix all its users, including
vm_module_tags_populate(). So, it indirectly fixes several callers but
when adding a Fixes tag we do not list all patches we indirectly fix.

> > Reported-by: Sashiko <sashiko-bot@kernel.org>
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Hao Ge <hao.ge@linux.dev>
> > ---
> >  mm/kmsan/shadow.c |  4 ++++
> >  mm/vmalloc.c      | 31 +++++++++++++++++++++++++++++--
> >  2 files changed, 33 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
> > index 0c88d89bf0d6..2166086d3dc3 100644
> > --- a/mm/kmsan/shadow.c
> > +++ b/mm/kmsan/shadow.c
> > @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long s=
tart, unsigned long end,
> >                                           o_pages, page_shift);
> >       kmsan_leave_runtime();
> >       if (mapped) {
> > +             /* Undo the shadow mapping set up above. */
> > +             kmsan_enter_runtime();
> > +             __vunmap_range_noflush(shadow_start, shadow_end);
> > +             kmsan_leave_runtime();
> >               err =3D mapped;
> >               goto ret;
> >       }
> >
> Can we just do that inside the vmalloc? For example in the
> __vmap_pages_range_noflush() as entry function for all(?) helpers?
> So we do not need do it manually?

Agree, that would be better.

>
> > diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> > index 859e6d2d57a3..9bbf75706627 100644
> > --- a/mm/vmalloc.c
> > +++ b/mm/vmalloc.c
> > @@ -349,6 +349,10 @@ static int vmap_range_noflush(unsigned long addr, =
unsigned long end,
> >       if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> >               arch_sync_kernel_mappings(start, end);
> >
> > +     /* Undo the PTEs installed before the failure. */
> > +     if (err)
> > +             __vunmap_range_noflush(start, end);
> > +
> >       return err;
> >  }
> >
> > @@ -363,6 +367,9 @@ int vmap_page_range(unsigned long addr, unsigned lo=
ng end,
> >       if (!err)
> >               err =3D kmsan_ioremap_page_range(addr, end, phys_addr, pr=
ot,
> >                                              ioremap_max_page_shift);
> > +     if (err)
> > +             __vunmap_range_noflush(addr, end);
> > +
> >       return err;
> >  }
> >
> > @@ -667,6 +674,10 @@ static int vmap_small_pages_range_noflush(unsigned=
 long addr, unsigned long end,
> >       if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
> >               arch_sync_kernel_mappings(start, end);
> >
> > +     /* Undo the PTEs installed before the failure. */
> > +     if (err)
> > +             __vunmap_range_noflush(start, end);
> > +
> >       return err;
> >  }
> >
> The only one user of that function is __vmap_pages_range_noflush()
> so we can cover both cases there small and huge path.
>
> Is that enough just to do unroll in the below:
>
> __vmap_pages_range_noflush()
> vmap_page_range()
>
> functions? It will also fix NOFAIL case:
>
> <snip>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 89c327a6ce7d..fa1f357ecf3f 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -359,10 +359,19 @@ int vmap_page_range(unsigned long addr, unsigned lo=
ng end,
>
>         err =3D vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>                                  ioremap_max_page_shift);
> +       if (err)
> +               goto error_cleanup_range;
> +
>         flush_cache_vmap(addr, end);
> -       if (!err)
> -               err =3D kmsan_ioremap_page_range(addr, end, phys_addr, pr=
ot,
> +       err =3D kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>                                                ioremap_max_page_shift);
> +       if (err)
> +               goto error_cleanup_range;
> +
> +       return 0;
> +
> +error_cleanup_range:
> +       __vunmap_range_noflush(addr, end);
>         return err;
>  }
>
> @@ -683,26 +692,35 @@ int __vmap_pages_range_noflush(unsigned long addr, =
unsigned long end,
>                 pgprot_t prot, struct page **pages, unsigned int page_shi=
ft)
>  {
>         unsigned int i, nr =3D (end - addr) >> PAGE_SHIFT;
> +       unsigned long start =3D addr;
> +       int err;
>
> -       WARN_ON(page_shift < PAGE_SHIFT);
> -
> -       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -                       page_shift =3D=3D PAGE_SHIFT)
> -               return vmap_small_pages_range_noflush(addr, end, prot, pa=
ges);
> +       if (WARN_ON(addr >=3D end))
> +               return -EINVAL;
>
> -       for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE_SHIFT)) {
> -               int err;
> +       if (WARN_ON(page_shift < PAGE_SHIFT))
> +               return -EINVAL;
>
> -               err =3D vmap_range_noflush(addr, addr + (1UL << page_shif=
t),
> +       if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> +               page_shift =3D=3D PAGE_SHIFT) {
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
> +       if (err)
> +               __vunmap_range_noflush(start, end);
> +
> +       /* 0 on success. */
> +       return err;
>  }
>
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -714,7 +732,13 @@ int vmap_pages_range_noflush(unsigned long addr, uns=
igned long end,
>
>         if (ret)
>                 return ret;
> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_sh=
ift);
> +
> +       ret =3D __vmap_pages_range_noflush(addr, end, prot, pages, page_s=
hift);
> +       if (ret)
> +               /* Cleanup KMSAN metadata. */
> +               kmsan_vunmap_range_noflush(addr, end);
> +
> +       return ret;
>  }
>
>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
> <snip>
>
> --
> Uladzislau Rezki

