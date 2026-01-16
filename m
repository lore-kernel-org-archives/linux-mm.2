Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADDBC982CA
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 15:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 436BE6B00A6; Fri, 16 Jan 2026 10:14:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3E4626B00A8; Fri, 16 Jan 2026 10:14:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3114A6B00A9; Fri, 16 Jan 2026 10:14:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1E3C76B00A6
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 10:14:16 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BFB4C1AD796
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:14:15 +0000 (UTC)
X-FDA: 84338172870.05.114B794
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf14.hostedemail.com (Postfix) with ESMTP id 01016100014
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 15:14:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OcridL5n;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768576454; a=rsa-sha256;
	cv=none;
	b=VzBLPnFrxrpDMOmobbxVukVxA/RM0OV8d2taGk6dwEAvOy8XlN+9o1WWX+UBbeiDQ7NORh
	h3Gsfxc3HMf16+Hb0LjmKl3BdhOVKNaVj0I+kOWvwrnFam4k7O/9BwIZlWiwmUAZG+Mg4M
	jkI/4JWI7ndcma+EsXFiMB9iwiUqtj4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OcridL5n;
	spf=pass (imf14.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768576454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NO9avectM4oqIErpCHYan5QDEY3yIsqWHROY9nL0nfY=;
	b=Gu7X6zFbwgS0ZqqEMS/Fd09ZiBz0z9pyoiA3XnKUIcpTtA1hUVElpCRwDKolX2DFNwrG4H
	E86ik7PBz3xPtygDObImGTBOWmxvAMoTQNAp9o5Po28QODRz39F3A1LEjmV2RCp5idcKjV
	qi4+8ESTis1hUPBcp/CLiFdr14dXmAM=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-88a3d2f3299so21215536d6.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 07:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768576453; x=1769181253; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NO9avectM4oqIErpCHYan5QDEY3yIsqWHROY9nL0nfY=;
        b=OcridL5nVOjKghpa568c8FGduk6Ag3M9SS1LIrhjnRjCNazeXi8KtMePYFtuiFkBxY
         EyNaWIlHkUPG00fnJUMtUP496vC9DmOUyTRV/1MuVc3Lx6UA/72RGwI3ZAwvO41Rs4/N
         jpEjrWBEgHYcSfDxwFzvyuYVtWIlb1D+4DhaxhErOyHJ723viHeIjayoz6J2iopUuZ3a
         Bj/ZmKU/0yUYnyd6sKxTvoK47plIvDdBZeVDTKmKFoyH15bmXkTjLSjnFYNFL45zpZTi
         g21Fr/1uWd9uViA7n5tpPNRcakZK4sBoL/cNzCKQ3oum6JBbpUOHgRjw8rlsgKWvgbo6
         MNsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768576453; x=1769181253;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=NO9avectM4oqIErpCHYan5QDEY3yIsqWHROY9nL0nfY=;
        b=BtvOnftk5YAf/u0sIvHQSoaaE/nzeHKC/foH6ZnSN2WRm90kaYFOEp0w9/SvfVLLFJ
         yFnNQLSSvNymiG24IDpH8ji47Jlk3t2vYOpzblJUpGsHeJB1/lD5L5u1UOxrBJZk3lAk
         lOvomSrY3a72HPrWNeZpZHxq5nYpdqk/j2Rc4SFQv8JTzu0GCEdR+/ejv4Nag+AgwnGd
         Gb/YSFn1xpLWE+D7ffSwDWGxMm6hHducjrPZ5m8uTxNKWgyVCZwsYATEvCBdRH78jbZV
         4R94KfzyRrcrpgAZM9166FgLpjIaXk2e6Od7qTxtpwlIm78F687OiV5rp2I0tLWh3la1
         qVvA==
X-Forwarded-Encrypted: i=1; AJvYcCWCA/M4gaxeJqPzl9OapyQXczog1nc7L8yqgnHJjG0Qj1fQgsy6lZhFUndqY8w0UqqJsPqVo5zdWg==@kvack.org
X-Gm-Message-State: AOJu0Yyo+0CMZEFiKHKawwsOuXo48CD0kDw+aY2Qut9FDS32rWrW5OMl
	x5BG70eFbzgn92//Dy+7YK+iq5XFAoSQUr/ki54rjSe7mfm3/agAY6oLijzajVJ8dCcDnkfQM/V
	N3nZP5REqF55sbUJ6okagCaqKdgUHFlA=
X-Gm-Gg: AY/fxX4aIoSgqlfMuaJFfwzwV62J+/xTpfEhhU/9kOSJeS1GXY7cl5Mp0H3D8uOj+XX
	CM+R3dcs59aUN44T5OxEbEUvdpp4R+AuDsX9SG6PEiz2fM+EaqcQoMolZ162J2qs2WMjBaHI2fw
	cxdyjaC5o9jrGkdivWYZcJdbTZHyEam54Qqmf9b48AACzqRPMrb1994Spn+MAR3spxQtkKbBuny
	NRqOdUQJ5CP/P+9fnE0/J8SJuMm++iSKmiRRX28SvUMMJXLewpkrVaVo3l/ZgbLOrPp9FVU1A==
X-Received: by 2002:a05:6214:1c8e:b0:88f:ce04:3261 with SMTP id
 6a1803df08f44-8942dbed93amr49871526d6.6.1768576452689; Fri, 16 Jan 2026
 07:14:12 -0800 (PST)
MIME-Version: 1.0
References: <cover.1766631066.git.baolin.wang@linux.alibaba.com>
 <142919ac14d3cf70cba370808d85debe089df7b4.1766631066.git.baolin.wang@linux.alibaba.com>
 <20260106132203.kdxfvootlkxzex2l@master> <CAGsJ_4yKRtyADU2ZxUMgvqdrhAEL4SpZxCMRt28gNJfUf--5zQ@mail.gmail.com>
 <20260107014601.dxvq6b7ljgxwg7iu@master> <db4d0a19-598b-48ff-accc-f5940a481035@arm.com>
In-Reply-To: <db4d0a19-598b-48ff-accc-f5940a481035@arm.com>
From: Barry Song <21cnbao@gmail.com>
Date: Fri, 16 Jan 2026 23:14:01 +0800
X-Gm-Features: AZwV_Qhh25guirGdCd3FvYx-1o2HRDCiexeYBr732qjmPh2DKC6RTtL0fDbc61E
Message-ID: <CAGsJ_4zAxhSDqvN5tzSeHR-kifaxm_GbPhHCeSkYsRJk=uHN-Q@mail.gmail.com>
Subject: Re: [PATCH v5 5/5] mm: rmap: support batched unmapping for file large folios
To: Dev Jain <dev.jain@arm.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	akpm@linux-foundation.org, david@kernel.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: m4u9p35ggrrkyworgdafrau39sd54dt3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 01016100014
X-Rspam-User: 
X-HE-Tag: 1768576453-249071
X-HE-Meta: U2FsdGVkX18eAPE8MvLzedOQCxie2hyUSyklCgMfLUK0daiBOfsdUh+xnl5efqKhdwgrQlhrHK65ykxoCRkJkk+q7V1/OkNDKbLpK5AtgdGWzds+fsTttDitOCn36RPIbqjvK20eiFAn9hIPuudqp/jI9E7u0RYydP76twl5pJbps26I6EVm9jOBRck0MNYa9PdleF/T2W9CXU6o2z8WWhDRfzNf3zwrwBFc4EtrAv0PgmS/KG+de2Yy5wuyvkQoME3PFeckN+cGZsK7h/62gKD+CFfLCshiROxsbjNPbjmV8LMTUXnJa7zVY0jrzQH+/ksc2H/ITk/7MiuY1daFDECLC3EeDPN41yyYRhesiUjfmNOIKUZC5DT5tBkPKlt+8T5VxJBwCQiO2Ya/QEbZYw/YVNF+RG/vRoCc1DbDUPmnG3lVyOmno1Wbni6qGr5KkDkYuyPVeGvZRc4a+PAzcStOA7KZQYVrJHDWpefUg7ADMKx/CBKmwfdeEV8ip+BWh/OU7cxg7j96bjNBfi471EZ2HJYmmmaRbpLWhE1s8m99IbNnuGiHSNHEbpIAi1NzdQwzTkhB3lLc103+EKxVPzoCxCQ9nDwJe/190dGm+WnLNfkyFZfbMnkE3Gnvo9Ik1KTpFqpyZwaOBD5suA6tGF5Bz4hFfpROhxcuT9DKIuDzdJnueODnF61C7AiB7KJeI/jVEheSpFRC+k85d6x5seVAgTCSfFcSnVn1TCwA0++eSe07Jwn4/sRapve8NDbS/iRxmExa0/sLoN7+TbGJmgUZpVz6LHIy2h6AG8l1d+DRO11hQwWIi9w6aXzj/WuwRt6WLrUvAHsX16haAO5ldsjdPyAkPn7H5XI+1AhZSWmF+9u/s2Lqng70zykGmaSDehAUn2PJ50V9dynWZcv8V3peOrLDE9nzYM1/1qqYEAP+f1OxSL2dsmZQGZRHmlikWCmM+1/PU54/4J7RfsS
 kwYZNZ9C
 dCsWiwQF3s9gvYRu3lEQ6qpyzZqs8MxMXiLkT/kbZQZ5iaSQEwpYoQIG+6+wVAmcr0+byjVy5gbkYFtlI9oKs/w0XN5DLg30hfM1/PINRKa5iD0H/le/w6ircWIBnqvT96mzJX3qIiwQ/KwhhMDSSqBkqCZNNApuD7GAxIPhFcXAtkmWnwZmf6CzAJCCoUdSOFmodmUIP1wud0hELg2CDocYzIRJANDMF5jYMZdF3jIWnFKBKG7l1odhNxXO6LivV/+AIxqxnvrozjPfY6aWiNKiUV4oT+r4sReS+y0gHOxQXXTG00uska2u1f5zlLiqbqYB1JCVSToL8qhuxVG0egoEPN7xKuOqZ6I25/CkkPDXqDqiHeTSouo+XWcCDUEodUdLbuVJZBPbAU/vVtIyrzah2r45+ran0KOlddlE6PWZ3CuoDdMSOQDObMDBacFwyb4aakqZ5PHuypTdQr84VqHQnT+9wYl8epeHd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >
> > I mean maybe we can skip it in try_to_unmap_one(), for example:
> >
> > diff --git a/mm/rmap.c b/mm/rmap.c
> > index 9e5bd4834481..ea1afec7c802 100644
> > --- a/mm/rmap.c
> > +++ b/mm/rmap.c
> > @@ -2250,6 +2250,10 @@ static bool try_to_unmap_one(struct folio *folio=
, struct vm_area_struct *vma,
> >                */
> >               if (nr_pages =3D=3D folio_nr_pages(folio))
> >                       goto walk_done;
> > +             else {
> > +                     pvmw.address +=3D PAGE_SIZE * (nr_pages - 1);
> > +                     pvmw.pte +=3D nr_pages - 1;
> > +             }
> >               continue;
> >  walk_abort:
> >               ret =3D false;
>
> I am of the opinion that we should do something like this. In the interna=
l pvmw code,
> we keep skipping ptes till the ptes are none. With my proposed uffd-fix [=
1], if the old
> ptes were uffd-wp armed, pte_install_uffd_wp_if_needed will convert all p=
tes from none
> to not none, and we will lose the batching effect. I also plan to extend =
support to
> anonymous folios (therefore generalizing for all types of memory) which w=
ill set a

I posted an RFC on anon folios quite some time ago [1].
It=E2=80=99s great to hear that you=E2=80=99re interested in taking this ov=
er.

[1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/

> batch of ptes as swap, and the internal pvmw code won't be able to skip t=
hrough the
> batch.

Interesting =E2=80=94 I didn=E2=80=99t catch this issue in the RFC earlier.=
 Back then,
we only supported nr =3D=3D 1 and nr =3D=3D folio_nr_pages(folio). When
nr =3D=3D nr_pages, page_vma_mapped_walk() would break entirely. With
Lance=E2=80=99s commit ddd05742b45b08, arbitrary nr in [1, nr_pages] is now
supported, which means we have to handle all the complexity. :-)

Thanks
Barry

