Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5A8AF60A2614
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 00:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=XMcsybOM
Received: by kanga.kvack.org (Postfix)
	id 5B5BB6B061B; Thu, 19 Nov 2026 19:07:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 566126B06A6; Thu, 19 Nov 2026 19:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47D1A6B06D6; Thu, 19 Nov 2026 19:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 146356B061B
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 19:07:23 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 71E89A898A
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:07:22 +0000 (UTC)
X-FDA: 85453557924.16.D0C6EBD
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf19.hostedemail.com (Postfix) with ESMTP id 6FBD41A000E
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 00:07:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XMcsybOM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795133240;
	b=jdewtikaXkHad/m5AbASgem5/cI0H5dWTa2ztvMsEa1nxb6i6Cn16+X+qG9wlN6shRwWN4
	pyGR9/PdGvs6ayOSvuuP72KfmDRV5iHngKXqKRn6RNUdSr7XxWHSiqvuLjCVY0SI0FnxAP
	UkoH8/zuIsIwCxwxjAV/xbVGRW9F2vk=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795133240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I4jT0D0imwxlE7FU4a7DD/JUhscf9TEVsEoiJwVSFSk=;
	b=HDDtAfezcaYchlZhH3IG6tehR3FL0HXIe8l0QtUhDcS3LZd0+lA/w2YKvmnsVNuRFaP0mi
	6wZeRTSwR21Z8jijI2bA6CZB5chsL4nVVP8VM6mxBCONg9IuCZ6wirrvmKLQOPdMKuCbn0
	D57cOKwbYtZYNVeQcQ2uPfwSYPYej2A=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=XMcsybOM;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4bb606491faso1428135e9.3
        for <linux-mm@kvack.org>; Thu, 19 Nov 2026 16:07:20 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795133239; cv=none;
        d=google.com; s=arc-20260327;
        b=rmZUNwuJ9y7+r5wvg+H/W5XlRUFqeafWNKfPEI+j3Z9covrBJ093B9vuWOyIU7Ibwv
         oMQTKn4DS8khD7/s7XvwAhqXOtOVmwzGS4CW1K+bPryvknXarL11P8Yf2x5ajHUkMmTZ
         7MIhHe2d6R0IudCYkcC10XTF36eJ5eJQVPAWwVL9ipNqIIqq2+rw8xkbeEKghJVQhJLV
         v5KXSPY3akbdjRxHdQeOQA14nW+QleNOsoiID+vjYURA9JCuuSDMOVH9cMTRlDNjmzZk
         iOnykmDFcKwTKs4ZZzgKA/u25llJrKlgowPl3IslshLJhaf0vjcth2rP84kpHEY3tSGW
         4Kfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=I4jT0D0imwxlE7FU4a7DD/JUhscf9TEVsEoiJwVSFSk=;
        fh=I/icalU+oTHLpCajtxTxQwAs39C9GK9x+6oBcq7ma5g=;
        b=Kpvgb8m5dql2sRT4toewFj2VOjvWkUAI3MJW3bMNp4NhchCEyhNpB09l7nA11/LIyR
         hNs5bJxhmVvPGt/Zsvrs4X3IiNX/W1pL1SAzo0+5U1KUFoBD65UHUUZnTU/tKNtPRvYc
         mdB9vtX4824b9peg17OdxGB27LzuKYmzckDmf5E5SAap9Ggo2F3QjoLk3cZT+Aw7NsnW
         O73O239813dVlaSDf37bB5yHEaGAk+sOyTkqeVAmUnSkEmO6r3K93KSk8Sc8OglY4k+G
         DWWrClEc+yuQ13rcl6Fqc3HoNIZ7Y628B8f10CCozD08qcyn2NIssbAyijG0dExkNKtO
         OLWQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795133239; x=1795738039; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=I4jT0D0imwxlE7FU4a7DD/JUhscf9TEVsEoiJwVSFSk=;
        b=XMcsybOMEb9epqrEhLk4oB62LKaJpPaOuLOgRoEeTW7mr8echFdE5lzFQsGG0mrYH0
         7rYxIwBFc9C+tWCtkG7pGh3uNAxtgAJCmEW8r6cmUzUCLrpCDDFOd2HvQGUgvJ75Tua0
         iDECVlBN/Yh0+akPGDSa4hW8peQvAqGD53CNZom2aHLRfsheqELm+vKMjq0MA7A828+9
         POc6/IuzWO4pyEL15+GZNqwdbyDQeOvDl/ZlRNLVz+uif7DjjDvSCsxYiBsTWUy9eyYs
         sxOwF9G0KwqeJZb66u29j/cBAKxZm8kmXbdQ2zP2U3+4rhu2v+ZXjAku/I420Fx8wKFT
         gyuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795133239; x=1795738039;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=I4jT0D0imwxlE7FU4a7DD/JUhscf9TEVsEoiJwVSFSk=;
        b=A1tOVnu3NE18OKfaB0Y100r8vsaQIQjVpOtvCB+cH4S7rt//I9DzIbjlSmgvCVpu78
         EFCicyN9bQDdXzdOL5EMBw1W67FCj33s3AxqhNDouZ0GUmvxYeEoRZlOUF6uM+VqqoVP
         F3TaflMQE+FM0WZiHV02OP1AnXkH/8ghnbhjZ6q6hz5UveAERohTX62fTRnK03jTOhAF
         i870VQ30+ceuL6oCnqsqYbkAZJiocdA/C1u/4cudrqM0Y06Pb3ZEKEz+xKGcgU7XGlqR
         r+Dt2Scsf47l9cCWXVlH0PTyh2D7/0SOpJc4tmKU413HRMVoJQKj3BoK4u8ke64/Db0I
         gZBA==
X-Forwarded-Encrypted: i=1; AL+hErFmbnSCAj8WeDDUavo3DFkpZCuzkd043PPzDFnu2e3Ky9AAucashNIvH76ib3YP/Ui+EWAst67tQQ==@kvack.org
X-Gm-Message-State: APuU4Z8oeEFbk1he+19hjyJNKOaGjnpAifqxs+WscxrQyHyCgGRDxDNa
	vCtUgTs0tNg0mbsexz4eqSvWg2d0OHgnfU05VVf2TNZ1FLw1D9wdR3hlrJdYpkN0GgGnulZzs58
	AOKuDDu/xGEID04DdfJVK5cTLHXwvhhc=
X-Gm-Gg: AYBFou3kr3qJL3p1WMclPpjzpaKX2hvLhJpPxoe+Cr1Zpc3PBBnY6PtdLClhPZGWNxc
	iSZk5gqAg29d9SRursrXpVSCaNX/0WQ8XKFqAHIzRs+nNn5atVMu82Nj3BLA7JQeJ6iIlLqS8iS
	OLcT1spCb5//3yj0khIn3Wk7tRSPOIhm1zqfhYqyHuA1iv+33yfntx5BW4ZE6X1zYuyqZqpoLOZ
	bg7q4yz7Y3dxhz13F36UIN6a3gTqDBqkRltEXalRe9YOvGfQ/1Kku0wMzCELwVexKl/A60Hoc7a
	UWdFUt0GMXQL8a0PMYIMgyhcAPSQVWkhdgIGASma+wFh1IEFHA5gxod6Pzq5Kw580FAeFe5n3K+
	76OqvaKtcgDXTDswzFmL4DncvONzBi2l+9G2FYcBJFobFW6G7jvO6YJ6hR6W/Gb8FycxoOa2lZQ
	Vp7u4z2QDcFbW8qfM++N/MuYWjQHq2vDLnE9DtWeOG
X-Received: by 2002:a05:600c:a085:b0:4a5:26b8:4507 with SMTP id
 5b1f17b1804b1-4bb8881e6c6mr26133235e9.21.1795133238907; Thu, 19 Nov 2026
 16:07:18 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261103212004.1356327-1-joannelkoong@gmail.com>
 <20261103212004.1356327-5-joannelkoong@gmail.com> <0d75991d-9381-440c-8d7c-07bca53cc8ff@kernel.org>
In-Reply-To: <0d75991d-9381-440c-8d7c-07bca53cc8ff@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 19 Nov 2026 16:07:07 -0800
X-Gm-Features: Aa3M54rC957n0ZdX59-8hwuBw55FCUz1-VDc-hFiinsPD7Sw5HR5CDw34MBqhUs
Message-ID: <CAJnrk1ajoz95T1-vpnqkTLDtoXoY_hKHsxtNJLjtbusB4Gd+XQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/4] mm: add anonymous mTHP folios to the deferred
 split list
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, baohua@kernel.org, 
	usama.arif@linux.dev, hannes@cmpxchg.org, kas@kernel.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6FBD41A000E
X-Stat-Signature: 7j7ukdyih3oo5suc1af3iifcz3y5pd4q
X-Rspam-User:
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam08
X-HE-Tag: 1795133240-992696
X-HE-Meta: U2FsdGVkX19E8QvIp7zazxzQcmAzEWwx8UOC7sFsQgAxYASVyr3e1Di4kwNCFeJMTvsLzFJ3njmpqCSAMkcUGtTNkm6W94XSPaOPyuXAvncBPUr4y4/f6LQQgzHlR9oXJxkTD7CvvtkfizU+kxsfNCJj/+baL/KdHQmHyNlNQlrOcq5ktbOPKa1dvQQuhYfxLacDZYwtPPv0pT2N7n9Lsjeu53771jiPb72sdDxg+pzb25ENgqp2L9gMG6w9G5TK7PTbQZFigLW7YJiIffRjOfnScHDS+grvWgJhlbvG3b/CIiOPC1l/uUzx/4DsrhhalJjxAG2fIdZ56ymG9Hq1DmTRa014H1FGgX/swbyzYuXwllliDT8ei+JSob5FZFQ+cbYtnNLFty1mtuNEnBTdwxtcpec0CtOU/k9kDjS/KGNXjaQtNu/xoMyeudF646CWhJPCa4Jshc5Ca5VmwOWrrUnbB//ejFGKXaZWyfwRKRN80/0KAKr9TZLgNLY0QdRaEW1KMArnEpIYhQNVf/tq6hwCyXX3QBJcyHohy0XcaQG+lHBlHxUdSZDkjIzUPGlDZwFN/pYIfy8oQVjk3+REpYHAd0vyi775Kp1NpxGMZXOAszTmcjhcGf2lpcxlVdCSLhqS5DysQLjCeNPebFRIiowYVw+Kw3wOzlKnVelZingu6aumHgKwo0RAPvjcLXwWxQZKSrg89X+FBmD5yQPerHs9SOiLz3/le6brhJWRP39jTIa8aNcvr8j/+r6xqhFgnQ+cOpgy35QLGGj4ED+0a/qYASHVON9bFriftrjkuDDCYNMxLMtjPqjruX+1ILGPaYSXF5OysddzGLZAFwxG+0hmy9s56jpCuEvjnS8GJyEVl53TcSR2ck3Eh4OdI3jFdONxkbE+hp/6pbkOG2g2PmGEThq3dfh/7hLuiBVEcSnCnnvDS4TcB4zVKQSKWNHVDZeYu8/3vCSpUccedbZ
 0xOjkicH
 1RIb8JMvgVDdME6WvyZ9As5hRIqIaGQ76A4hqyDUnNbsFPZzBcsm2TRx/OWE9h/LdxB5DB6V07DGwBNF78H5XW36TNGEysSz58++VEMqIXSCYtZDpoxvlPyzRkB7XC5+3ncuuPJYXlP9+dV8cGHl8HXRo+G/HNnL0wQr74fgXrWMhZ1dCObTcY+QLdSOJgd3DRy6FDq7sSVScxlvOq03mVhDy5wg8jIGzc/7Ig3xixotIW6TZdX5FvLpcUnE75TSQK4wyMIEMnyecv1eQEE67xkAydS6cLwdSuBUXF9FHjUNkpOloYx9iRXLxUDqZQOYfe/Yhg0dV4bIQVXlrKhTFHvenL1n1Ca/sHA4hBW2YxvMyauxBn+algtrPQTYNRoDZ0hqZ5B/SA52vBhA6q9aJoPxILTaxdNLh51YvthdaMg2m6O23ljs1S2FfOYc1Vy6CAiV0F/udiWYrAZ+Cj8zinx0dPuuNHcMHqd3liAZtLN6NYDPAKU/O1SZf94HWpU3nYy/7a4n9I3/r0UxuHvifSPm2YndGQjk5BYI4F62UaeOVVayOyFAmyVPRHBeCs8lqVjfES+5VKbktbS5dqx9aHYk3aj1+uXGYLQOiC950UpN/z3UXsAKzN4/HkeB5qbn6KTkgTH7o6GxD70M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 17, 2026 at 2:21=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index 8f90fb609e57..cda3c886ec53 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -4575,6 +4575,13 @@ static bool thp_underused_never(unsigned long ma=
x_ptes_none)
> >       return max_ptes_none =3D=3D HPAGE_PMD_NR - 1;
> >  }
> >
> > +/*
> > + * Smallest mTHP folio that is queued for underused splitting. Kept
> > + * conservative, as small folios are unlikely to free enough memory to=
 be
> > + * worth queueing and scanning.
> > + */
> > +#define THP_UNDERUSED_MIN_SIZE       SZ_2M
>
> Working on orders would be nice.
>
> I think you can use something like
>
>         order_base_2(SZ_2M >> PAGE_SHIFT)
>
> for that.
>
> And then you can just do something like
>
>         max(order_base_2(SZ_2M >> PAGE_SHIFT), HPAGE_PMD_ORDER)
>
> And place the comment next to this definition.
>

Will do.

> > +
> >  /* partially_mapped=3Dfalse won't clear PG_partially_mapped folio flag=
 */
> >  void deferred_split_folio(struct folio *folio, bool partially_mapped)
> >  {
> > @@ -4600,6 +4607,13 @@ void deferred_split_folio(struct folio *folio, b=
ool partially_mapped)
> >                */
> >               if (thp_underused_never(khugepaged_max_ptes_none))
> >                       return;
> > +             /*
> > +              * Keep queueing PMD-sized folios as before, even where t=
he PMD
> > +              * size is below the minimum (eg 1M on s390).
> > +              */
> > +             if (folio_size(folio) < THP_UNDERUSED_MIN_SIZE &&
> > +                 !is_pmd_order(folio_order(folio)))
> > +                     return;
> >       }
>
> Shame that we already did a function call just to figure that out. Should=
n't we
> just replace the folio_test_large() thingy below by helper that embeds th=
is
> directly, with a focus on underused shrinking?

I will make this change.

>
> >
> >       /*
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 0c9ed04528d8..44376321180b 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5477,6 +5477,8 @@ void map_anon_folio_pte_nopf(struct folio *folio,=
 pte_t *pte,
> >       folio_add_lru_vma(folio, vma);
> >       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> >       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> > +     if (folio_test_large(folio))
> > +             deferred_split_folio(folio, false);
>
> Do we also ahve to take care of mTHP placed by khugepaged?
>

From what I see, khugepaged maps collapsed mTHPs through
map_anon_folio_pte_nopf() (from collapse_huge_page()), so I think
they're already queued.

Thanks for reviewing this series. I'm out of the office for the next 3
weeks but when I come back, I'll submit v5 addressing your comments on
this patch and patch 1/4.

Thanks,
Joanne

