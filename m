Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56FBDD172BE
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 03:18:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C16816B0089; Sun,  1 Feb 2026 22:18:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B9F806B008A; Sun,  1 Feb 2026 22:18:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC3416B008C; Sun,  1 Feb 2026 22:18:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9B1DE6B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 22:18:39 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4936B160A49
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:18:39 +0000 (UTC)
X-FDA: 84398059158.09.A81F2D6
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5C4E12000F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 03:18:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hR18QGyg;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770002317;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WcIkuTCnSvaZXRrX+rXO8+4cHF1+iTfZ6q0AXxSYTGQ=;
	b=YSth7vj6BUXNSWFjJdJLpNbEZ/4XZYVfQVdME9CUKVL2MjXgFcJcnmj9My1jHqfJ1PkHYC
	h5qxJLAVkqKE9bHeoDMdcunlLF5qGf43sBkyHaDNig/ORTucOcdBkytCcf5nOaomXPx0WI
	ARajLSUDKptKGxHj1inRFL1kbcAP2GA=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=hR18QGyg;
	spf=pass (imf03.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.215.171 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770002317; a=rsa-sha256;
	cv=pass;
	b=P7YUSrH1rVDdBvb7IgVvPgiGXENvvcgEpGtCW6MN7Yq+GhRBfZdNslO3czkalxnGi3zQ+V
	1K9ZN6kYKFquolXcYQtEzbf47cUooglkxTVQ6jfX5oaHFy/foBUlg9YD0M89UTWJkfLMJc
	PU5Fh4Zn+PrJXTBWTlN8jymw59YaUCk=
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-c61343f82d7so1557829a12.1
        for <linux-mm@kvack.org>; Sun, 01 Feb 2026 19:18:37 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770002316; cv=none;
        d=google.com; s=arc-20240605;
        b=iEeFnpSMCGgU+IHK66wKnliFZqmzV5dyAxyPYZBUqurTQegCt5xrwtOdd1bjQC2+/R
         fiAikZzUWjfjOAu+RHd+XgFeZIull9Z8WVr8TjEhQxkqcON0AqUG0x5fiuQcIoO2TcHt
         UhM3YatbY2XQfwTNXa19ISkKUhGuSxjiIIxJvdHEfCLBepoEMhQFi2CCypKuPINoiX2M
         Znp3Y40D+Q8qns4YTogHyI0WSdwqqGNIA+d66Ex8ZO+eyDXxEKarVsVuPpBh056u1U6i
         M5wnZQiSBS19+1ubgsNfMYl3D9GH9j7RBoluFkD+A9+m+0QgcIxmcm5QrhK2VY2p4VeR
         fsBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WcIkuTCnSvaZXRrX+rXO8+4cHF1+iTfZ6q0AXxSYTGQ=;
        fh=93kFg1MXbW0hqR/MdQOhZfZq85DQQ5oy4J3th1gwT+Q=;
        b=jNbt4mQ7WD9vx3Dh/7QluUrq0w7+FHv91Xcygu87EAgzSTZHepk26mNKGMjrlOxtK9
         j4eOnSPVoIJZHXSEOP4uDpeOBgcAH9xB7FxKnlkqNYrgoQUzRvXVZ90rmWWfyqmLms9q
         CgMRplfebmvIwNpIfpLvzK3U8U8e6J9ObWMcrItWLblQY+NJe+hIj23k/6/5h1KI7p3V
         ABR2ctiC4+hF5iolea85olT7NJuNplU221cUsT97T7SLpUu58xB6u3FHML4k99GSbDD5
         LgHzsaS9zJ12UGx62LPFVa/zBw6FxCeSKL0VBNojQtl/oxLSq8C8bUiYAoZGVLLk2qOp
         fOsA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770002316; x=1770607116; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WcIkuTCnSvaZXRrX+rXO8+4cHF1+iTfZ6q0AXxSYTGQ=;
        b=hR18QGyg+CY6mexnpQlvmccsEjPDZX1H9Sc/4ok1Fp1XYfblGeIM33qEwyNyXcAQ30
         MK8m8NdniHWnGS1onHEm/Lu9IYXP2UmmUB9r7fNxN/l9RrTqFHa+lRkAwlJLypEpzlik
         fVXW0eicB5AKmrCosnKYWV/m+ksIWTPAe352wcSM5YdeE2Zm78ZbM1UjzpP7+tK1NCBv
         er1Ubk5BcMhcagzKzjdHh/aK296DyMymw0xpqTs9Ln+oDgJBhh+HPD91mSJ30rxwz6ob
         RSpc38RPAfLgTmuGwn0Lxg4ixyn6sGmBQKrCS1tqNYIncaZaaPvjbsZB+G/fslwFy5ym
         +cLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770002316; x=1770607116;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WcIkuTCnSvaZXRrX+rXO8+4cHF1+iTfZ6q0AXxSYTGQ=;
        b=JkUeJfOuomUTAoC2BgLUAa5bQXlUzNOsyfO5FPsLufjDhnJi4mb49I//kJwBh3+2vr
         ttkjRxgF5/hJK4U2vrHH+2G0g8cFRH0dMQ/LUU7/Ecnu5ztoiZtLW3m3+LrMDRzMT39v
         YIFtx+SEkZch69GfOGAd7dv6ck7zPcxY6KSOyDOzSQird9c8PtqaNKyuJXZNffrDnUES
         G6C7XzVXWyJv0Ruz3dc/1Drc9gEMsSYdd9BfU5XOBewZdQyrleokzFsdSr0C3miXo334
         sx7jHumXVoMfnvWV6MRvIL5CjiwPvrPlSq6C6OjKQK7AwBNVlBdOtg73Rej8vO6iFxBc
         uYEw==
X-Gm-Message-State: AOJu0Yygo9cROwBLXJOHMca9CaSa1MrmnbAEjTs3AKekAEecS43taspa
	tW6nzE23Glrm3AP/+klUl0JeKkE3q2xAI5uDswf4p3rrZkYhjrQvsC6ihJdnd+IRoyIPhB1FbVK
	V0J60QZa6kpqqIlsi5uhhuLxbIEqXZGA=
X-Gm-Gg: AZuq6aKjpiUQE9VsRpqxvyosgyMIU+BR6qtCAhQ/QOU5LI7bybQQER+VEipInxdM2uS
	B0Crfl381ohy/r41rcLFX0zCqJQw1G+/GbeyjGrgA4ggHsC3ofWh6+7tscyicpqXUq5myu8Zr8b
	Yu5Kesbg1r1U5QjTzIT8VNE6ueGDJN0+i/IyDZ/WAEEAJq9Ef3d2RgKxSwsLlE0LrOWhrwK/Z5Q
	gKDWFHSaHXhJ/VI6UIb4radlBSpZ9GZlljjsGLRfRiRG8YsVNVFyhInXXYYGNq8t42a4vVwMja/
	D47+Ceq2kghBA4xsroXFr9pwzZuw
X-Received: by 2002:a17:90b:3d4c:b0:343:c3d1:8b9b with SMTP id
 98e67ed59e1d1-3543b396543mr9861836a91.19.1770002316051; Sun, 01 Feb 2026
 19:18:36 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
 <CAMgjq7BM0QFvk3_D4qyggjJ4W_+nHAupQnpAYehGq50CYNJV7w@mail.gmail.com> <CABXGCsPrpLubmjt5vGacPcmQnOYj1EVei3G3=L_2X_-Wfa3kcA@mail.gmail.com>
In-Reply-To: <CABXGCsPrpLubmjt5vGacPcmQnOYj1EVei3G3=L_2X_-Wfa3kcA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Mon, 2 Feb 2026 11:17:57 +0800
X-Gm-Features: AZwV_QhAVIlsdfdnEgy0Zx9Okq4QjKYmKd4H-76ds82wyEEZmhSB2oBUu6YQpLo
Message-ID: <CAMgjq7BpeaDU9_DhXYvLMadTgDq_ObJeBb+ndfMygzz7n_FjTg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
To: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5C4E12000F
X-Stat-Signature: bi4cnyi6wh4999e1mcadryspgbf498x7
X-Rspam-User: 
X-HE-Tag: 1770002317-467324
X-HE-Meta: U2FsdGVkX1+cFZNpcUqlcrE77nhB6GOERQNJ1+AeQCBS2ZriPoEr7aqXe+Err4IO4Wpu3zvngqaPZd//Rfip4/7PEVkaKFmD/A62AWiA8PA/GaCAnNkvW3PryGSyHOFzFYvmp6MTAp3pHmRQkhikLso8GcB0EOr8MfISO9k8GTsa7iiTjg4GKaLulSENkUj/lSg4hgFzxgXLVt5NllCLrKqYeo84UYD8KUjdjskGK7F9wpTC1dgkyFNTLIE/uqqMEig3m7Q7NK5MPK6YmsOzmdfQXDGznEJiW9+oaCUcRT78APRg5l/614XeMpfu52dcvJwcXOv1vmxrM3S02MNBGKzfPusG/klt6q0Tgnn2bwzXT813wJ8IQfnh8eocFZI6rgXArny68AmciY0Rpft2S1/E2iRVsCDttgDtoL3QM/1b6MhaGrqq+KbbWCUERr8rlXhqajSsQA69OJ6b5ZpNGhOM1yNUN62EmYVathTEQ1RjL0Z/w6tynr4Rm5k0lcS6n0G3jtiftFmmLriD2q+b9Y1ifgi63Xp5r1etUoQ+73XrXIUR/X86efst+8abSVgbJFxG+pzh4rQfn/cL0EP2wAusZF+dKOSmkxm409jbJz1Unm4ISpGU6OW2Urfems8chWsDFYl56D+NK+5RjKpetxDx6zCOqpXfiPhCaOwnORoAsjDqCbZkruZjD1Pmej+Uzx9EZa56xrNSub1/yrJaFTqlBCQXfBXfe0tT6m2XovpLTwmh6wjtrk1uP8IGOwJ5c45OIYrRFccfHLaiydMR15u/SbKyi13e5LNEcYJBMmsHknrrgsVn6x95Hla/ZmcVH6sUnMBr79BmzNhBGrNPIiVLEL54X8W6a0d/Oj6HCgYNy0hfR+bNEypPy7cTP6Vw72/vDjaBBLeWN9dboyWz9OF+W9judcjIMvfTtVxHScwNWNKgqTx5cF6oHxb899xFVKeYh1cTsOURyi+xDqA
 g/RYqoEL
 5EdlxoHlOYNP4rwGSc6blO9x44bVpGT+RoaDA3SEGwOLjArEFph03adso3MTFaL2e4aqA1KBFPI4OIS3oIaha8ys4x9IyTORyW2Q9lNQq5JWPkpi3OuZPELsoL4tIU1mdQukFPMnVeNALGkRRa1TV4yC9wl3q09ikBpNGQ1UOQMG42iu3vhhz9wdEoGI6Z0TotKq1IAbCzj9Vsi4FcihlLfjxrt1d0o4RHeBcwJ7ILDfwRRU1pAVe+8qrUBjEqfO+Og4OxZD75dVFH4bxHAG8SxlJZOEnt0Zh0WBvBhKZYiXugfHeUgp8UDqD8k2WZ2/WDssjang9gtjvZnkbX6wVrlJM8Tp0OSvbs2FiS7vwDxDhzKaHFjPSOPjO5TnqpUeK5+BQbWPqA2Xfz5zYHLDfyKqhLO9ObbO8oelHdG5QcTF4IuTDq9dI0xFIfwkxGUQRyK1CMtVi+VQCGGjLVrDtRiKHo1Hh5ExYw+ouQJsm7dJ7Z5RKXs0IH9YqOpRz7KcH58uCUZelnIIcSwaAS/3zt0/MCMeMjC2KIN3f
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 11:47=E2=80=AFPM Mikhail Gavrilov
<mikhail.v.gavrilov@gmail.com> wrote:
>
> On Fri, Jan 30, 2026 at 8:31=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wr=
ote:
> >
> > Hi Mikhail,
> >
> > Thanks for reporting this issue.
> >
> > So the problem starts with `swap_map =3D vzalloc(maxpages);` right? Wil=
l
> > it be enough if we just pass GFP_COMP here?
>
> No, __GFP_COMP won't help here. vmalloc always calls split_page() for
> high-order allocations to treat them as independent pages (see
> mm/vmalloc.c around line 3730). The compound page would be split
> anyway.

Right, but with __GFP_COMP, prep_compound_page clears the tail pages'
private too, so the code snip I posted will clear their lru on use?

>
> > And worth noting, mm/swapfile.c already have following code:
> >
> > /*
> > * Page allocation does not initialize the page's lru field,
> > * but it does always reset its private field.
> > */
> > if (!page_private(head)) {
> >     BUG_ON(count & COUNT_CONTINUED);
> >     INIT_LIST_HEAD(&head->lru);
> >     set_page_private(head, SWP_CONTINUED);
> >     si->flags |=3D SWP_CONTINUED;
> > }
>
> Yes, this comment is the root of the problem - the assumption is
> incorrect for vmalloc pages obtained via split_page().
> post_alloc_hook() only clears page->private for the head page
> (page[0]). When split_page() breaks a high-order page into individual
> pages, tail pages keep their stale page->private values.
> We could fix this in swapfile.c by always calling INIT_LIST_HEAD(),
> but that would only fix swap. The comment in vmalloc.c suggests other
> users also rely on these fields:
>
> "Some drivers do their own refcounting on vmalloc_to_page() pages,
> some use page->mapping, page->lru, etc."
>
> So fixing it in split_page() seems like the right place to ensure all
> callers get properly initialized pages.
>
> What do you think?

I took a look at the history, commit 3b8000ae185c ("mm/vmalloc: huge
vmalloc backing pages should be split rather than compound") dropped
__GFP_COMP and added split_page, that's the commit added the comment
you mentioned.

Fixing it with this patch you posted seems could result in other
issues, e.g. split_free_pages / split_free_frozen_pages would call
split_page while the page is on a list, so at least clearing head
page's LRU seems incorrect?

