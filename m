Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92AEDC61DB9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 03:01:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70FFD6B0092; Fri, 28 Aug 2026 23:01:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0F86B0095; Fri, 28 Aug 2026 23:01:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D67E6B0096; Fri, 28 Aug 2026 23:01:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 368E26B0092
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 23:01:14 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 947E316030D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:01:13 +0000 (UTC)
X-FDA: 85152805626.18.81BC300
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf07.hostedemail.com (Postfix) with ESMTP id AB91340008
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 03:01:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S4sp1jPi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787972471;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLUy3j7XIC3MuF9b+5vRoq7wyMMTL5+219ycTFp+SUE=;
	b=eqSYTCdUeZcd9rBZEoF1X+/1QNVH2+aq8IaprST9PEv7yjZxeOM/JJbKU+fg6aR38hLS4X
	YD2EOgcItwjXMZ56dUaL97YNt5otPxyaUEEb1DsVy+hsC6/IXbJl1GV0wy0lj/+LiN0C2T
	R7+xmgNHNPDZRSBhpCTSZ4TcWcaFPaY=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1787972471;
	b=eY8JPWH723sBV/+l8jeqr/O/Ul0tBEIjhQaYi4qcpkC1b0LTWVdKQ/joM3AW4kNlUug0RS
	1sZMnfy9SZYTlttFiBp6nWqX/DaqG8AELUbXneeHCNf339CRbees6EufTB8eALM7YJckLz
	mwjHohaz+T9ADi8ykV8zUdsCo9gTBGI=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S4sp1jPi;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of surenb@google.com designates 209.85.160.174 as permitted sender) smtp.mailfrom=surenb@google.com
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-51c01c79467so116181cf.0
        for <linux-mm@kvack.org>; Fri, 28 Aug 2026 20:01:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787972471; cv=none;
        d=google.com; s=arc-20260327;
        b=BRmtpkvzo95p41NjxqSNiw7v3k/6lCallRxP3cr8cbeu2PG50d5tpi7qhkpOKn4oIM
         4G0Udnf4DbWXg0oM3RtL3H6cvbz0PhhVWHlQ/sdU4fHHjQyWNnxVn36gjUVj53y0x1Kq
         HRtKamEBpTsKz4p2Tb4gmZPfCYxMSbuX2VHbzKouz0lJybxe2Fq+5mKtv76qI49qE0bV
         7BFfn8IVnaegTsKChXMSiY6X9M0V4uKHr2mj95DTtzQLpYeX087MCByOSO+As2tAG1sP
         WdUGpJrYpj6MEviKBCVCepNc9HSAyv+LGxXHpaLXKvev/eWctdtxKgxh/gSPIcVIAijE
         A/kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nLUy3j7XIC3MuF9b+5vRoq7wyMMTL5+219ycTFp+SUE=;
        fh=msCBmeZhA137ZRh/IKA4ZXxSrxh52Zg/57BJgpj0XPE=;
        b=BvUpCz0DpvBColmg6PezVO+o3l4nxzsw15PEbyMutzA0w2E4DsVI+QnGM9u36pMRL/
         RYusKjZdJl9hBPXmIQ7U6iQsvJv8CwkFlrqeVyYR1o/w0PPEEkrWumGCTfQjp1a4diPx
         R7tGLtqv5Brn8C/xf72x5L6xhHANHXLJyuxNGGv9KV/ec1mUPKYb8yeaWcN3pWq13BOr
         xnSkYuoYaTEQ+udW+hRItFujMmPfhhR/WNH5lUYgb2t9JmaLegD0QrCKSchDFXbxcLMH
         HT8+MAn8UlVLInsfOW6zWy6VFJbOXmxl7+gv+6cCYNQe2ZOrtczFGohHngXSi1lRcg45
         xC3A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787972471; x=1788577271; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nLUy3j7XIC3MuF9b+5vRoq7wyMMTL5+219ycTFp+SUE=;
        b=S4sp1jPij7yzxHJ9mJhGG7po30HnKUAWQvoKt2Aq45eitg0HmoyvAkbkBhJSXw3W/U
         R9Em7j44/ipyfsjkReqXfbH22PgU/cwK98kH+B5HDcpdXhwyfvANHzIc3sMolyI39niE
         LyG1R6ay7a4Fre88CvcCFINDYEshnMRVIpTVpns0DXlyoJV00DUeWi7vmkY1htXyqLzs
         bSMCKk4O24BRhxEElHoMWiwYfOJxDPRtShBE381EpeDWOygJlqTd/H9kDk57vDmHOip4
         z037PLmI9rBeddOXnAF5v4956BWddMKXoE9KnJL6bTrd+y32hkmrpQul6WE0E3dE0aKg
         5+pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787972471; x=1788577271;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nLUy3j7XIC3MuF9b+5vRoq7wyMMTL5+219ycTFp+SUE=;
        b=FfRSv7J8xCmetZ24ssTPuAF8sfYGtwVmnd13oMqMKo0ah2ddKn5vPasjrqI8V9RY1W
         gJO7o1D75nkJnRhU1XTupKd4/1aNC3nPAtCVIynRL+FTnXQk3B7p9Yv+hWDGGOYA3loJ
         Rqvy9QaQvf4qWtR1XFJb4pNx+Syu/b1s8Q3Vx18qyAS9fl8DNEeW5QRS1IAs9LGGXnDt
         E6kM8OdmNoXS0h/uST0zQMkaoNzS4nlHblRVO4Lg8XLLgWFn+YPeAK0+tA0FnFLxupHh
         2f2pj3xULf4z0ZIn3FtyMnEwN7lgGWoxJss2ocvm0imtlkQTSzD9TK0CLfCxS+0DUTfp
         BvjA==
X-Forwarded-Encrypted: i=1; AHgh+RqCBK/3zRkt1Utt955CeXmeG+pKzIEr+j180SokHlGKESXbhKWeIFUy6kIMjqOFICcbAVRu9TJdkg==@kvack.org
X-Gm-Message-State: AFuF++mNQVhXjZvyqTaV9OXOt49PwwqYTj80kVDtvG3uwI28lwOMvvPE
	9/yHYff974+NEDDGEli/AwJNsyzM8Y8RupgjWIotXSIMt7tvlndOOeofAVoMt8vpWjhmQqMWuPN
	YtJldKuE2G66CxTAQQND6soY+0jvAjiKfNoWuk8Jj
X-Gm-Gg: AR+sD12IWr6MZza8+jvufsWY8pc1TEam2VvpR/0bqFrfoNT4qve9py6aAPaASzF7+RE
	XWCU33i7ba0cJirNM8sq0GQVjMLp596w7ReUhz0Z2rItMEkYvOYN0UUenBf9MOEvnSTvDaT2TYj
	ya6zvWF2QP/gX3NFICzifhSCWKIftTbzoHgn8j2HANBu1wyTOkGFONNvPMl9GWr8+LVzPtFMzWF
	o9x79XHlzg/kiT7E1qlQ/bG2uenFxRLvxzC78veVzI/GY6cnUgWoaujNuoYKOSlS/Uskrr5uJfa
	Y4osTzOKKmea8IVtgHzlY9qJhZ/pZ7LH5ARX/enT4cs=
X-Received: by 2002:a05:622a:598e:b0:52d:7a3c:8396 with SMTP id
 d75a77b69052e-52ff6f30c8emr8619941cf.2.1787972465651; Fri, 28 Aug 2026
 20:01:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260811025157.1632867-1-riel@surriel.com> <20260811025157.1632867-6-riel@surriel.com>
In-Reply-To: <20260811025157.1632867-6-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 28 Aug 2026 20:00:54 -0700
X-Gm-Features: AcwNN1Vj4z8Ya-qEYZ3MpBVI7mTdOXWm950pMK1qBQFZM9vP_MY4EVjBkzToltE
Message-ID: <CAJuCfpE+BWwX1t7bO+TQq5njSNOMcewewMzSukO69G9vDiydMA@mail.gmail.com>
Subject: Re: [RFC PATCH v3 5/8] mm/gup: fill the pages array outside the
 pud/pmd lock
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: AB91340008
X-Stat-Signature: h5bzgzm7yqerzirthrkiy78eygd88bnf
X-Rspam-User: 
X-HE-Tag: 1787972471-620632
X-HE-Meta: U2FsdGVkX1/V7zA+Vb6uET11o90BYxy2szyY8TA3KZrxnTQ9xmI9vY8DeS+tA7lprVWdBC2KQzwNcsWiC6aIfbebEqoWZj9LDpUOUFikaCG2sywUA6Aza2DOvlErLpc6e0/SXUMTnT0SXjmfV8tCAXbUJH2+hDhAK3zDT5VDKavPmPPEybPR++PCjDYhNW5cpITOK0dOgCTlm5V/audpXR3rAJPmgKrUVIrn9hGd3QPxCHMjjQH7RTkfbSdopcUqb+H98V5Zegejw7gjWDzNGRqT/ifdNhetAGpiuabDCVfZFk/z6Shx3aWNTDuJD+nN0C1s6nwZSki2Yh5kNXjZDh5/yNdKuFkiXkZu4m8PryoiCdhWwodkYrqnImUX5NAZEL3JpGFhmXKPJQepZIxe4Xdie7BkXnVYPTuuXWaRUxyxh+0+uGvbPi6iZCJq7qvSlOv5u0qpN6hS83Yr0stbmotNKUgVuAKms/JDW62aWdi3oeUmJEWTDkDKiZM/BqSJOuHA0/SY16T/NRKWB2WkN2qw0J22PIlS60x0cVKBzrfTbVciogJF3nKeCSLdCIOMVQxyDE1d3faYktau3/N8bAYjbFQ48VL13ukF+jEnTgVM70qaXNHD0PbLPIybaPy+BIF6krO7kYRngqKU2aCIMbGLounnjb6uJnNK/rUjP4wOpRqrb/1xG6iQjYwK3BNNuOmx7x14FbfO/nY9mtHgw9Jr+VzJsAg9X5/ChGtnYV3BV8QfXtvXoLoSozngvcK8yZ/JBjNPknGYPw+vAPk7TBK38IaIe0DtndDhM/pj4ESgn4+JzXA/ttCbTy0KIYSe87rimi8+TJvUUNLGODiL6W5IW4jAaLIm0XhY/e4M6PgLkBQ2n5CM+CHwjmP0rcjG5V7DAvk4QcbFxmsZseD5tp4T60D8zpeKSdNZE0e5hNVCKmGWza19Ko54PbN9p8Yht1RXh7lXmcRD4w1p2PH
 CYzHW34W
 dEcn5h9e/QvBSCb5u7sGWYG6gjn25V9ihoSOJnb0+yfAtCDiDbq3XrrYM9c8GL2SdJoxV5sSRCZdrELoOLNizGyooN9/JcxjCtq/0e5toP+w6Q7tsuvrOdx/JUlE1WS2UafXwBHgZn3r/1mhtr8IOLiGaM05t1aFGGu7669vhlgE+dE9lQbnnWHncfQ3JONL2NiiADLH1WP5GNI1on5MOJ6mGeQp5Y+7KgvpU4xCNaF1E72mG7XaYMPgyYSm6Y2tOZj/l/i8KIY5jg4/Bfp+osvoM/D0jJSD7c8iCuIbi8GxTWqImrD/WbPnDhWewTcjtx41UuN58jH6IfKnbFuFBixp0hw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 8:07=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> follow_huge_pud() and follow_huge_pmd() fill pages[] and flush the page's
> caches while still holding the pud or pmd lock. Neither flush_anon_page()
> nor flush_dcache_page() needs that lock.
>
> Have the huge paths store the page and let follow_pud_mask() and
> follow_pmd_mask() do the fill after they unlock, so the flushes happen
> outside the critical section.
>
> This should be safe because try_grab_folio() has already taken a folio
> reference before the unlock, so nothing can free the page while the fill
> runs, and the fill itself touches neither the page tables nor the pud or
> pmd entry it was reached through.
>
> No functional changes intended.
>
> Suggested-by: David Hildenbrand <david@kernel.org>
> Assisted-by: Claude:claude-opus-4-8
> Signed-off-by: Rik van Riel <riel@surriel.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>


> ---
>  mm/gup.c | 20 ++++++++++++++++++--
>  1 file changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 5af6a23285de..4036d3dc27df 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -695,7 +695,8 @@ static long follow_huge_pud(struct vm_area_struct *vm=
a,
>
>         *page_mask =3D HPAGE_PUD_NR - 1;
>
> -       gup_fill_pages(vma, addr, page, 1, pages);
> +       if (pages)
> +               pages[0] =3D page;
>
>         return 1;
>  }
> @@ -760,7 +761,8 @@ static long follow_huge_pmd(struct vm_area_struct *vm=
a,
>         page +=3D (addr & ~HPAGE_PMD_MASK) >> PAGE_SHIFT;
>         *page_mask =3D HPAGE_PMD_NR - 1;
>
> -       gup_fill_pages(vma, addr, page, 1, pages);
> +       if (pages)
> +               pages[0] =3D page;
>
>         return 1;
>  }
> @@ -991,6 +993,14 @@ static long follow_pmd_mask(struct vm_area_struct *v=
ma,
>         }
>         ret =3D follow_huge_pmd(vma, address, pmd, flags, page_mask, page=
s);
>         spin_unlock(ptl);
> +
> +       /*
> +        * The ref is already held, so the page cannot go away: fill the
> +        * array and flush caches without the pmd lock.
> +        */
> +       if (ret > 0 && pages)
> +               gup_fill_pages(vma, address, pages[0], ret, pages);
> +
>         return ret;
>  }
>
> @@ -1012,6 +1022,12 @@ static long follow_pud_mask(struct vm_area_struct =
*vma,
>                 ptl =3D pud_lock(mm, pudp);
>                 ret =3D follow_huge_pud(vma, address, pudp, flags, page_m=
ask, pages);
>                 spin_unlock(ptl);
> +               /*
> +                * The ref is already held, so the page cannot go away: f=
ill
> +                * the array and flush caches without the lock.
> +                */
> +               if (ret > 0 && pages)
> +                       gup_fill_pages(vma, address, pages[0], ret, pages=
);
>                 if (ret)
>                         return ret;
>                 return no_page_table(vma, flags, address);
> --
> 2.55.0
>
>

