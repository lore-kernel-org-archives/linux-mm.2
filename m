Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89FB4CD98D2
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 04:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7AFB6B00A5; Fri, 12 Jun 2026 00:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D69A66B00A7; Fri, 12 Jun 2026 00:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BE1F96B00A8; Fri, 12 Jun 2026 00:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9DCDB6B00A5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 00:00:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 41C8B1C2E35
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 04:00:01 +0000 (UTC)
X-FDA: 84869907402.19.ED25520
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf11.hostedemail.com (Postfix) with ESMTP id 3B32440006
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 03:59:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RRYlRSJt;
	spf=pass (imf11.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781236799;
	b=Fg8jdal+iC0rJv4MsXTXKFM5lPXVuD2hC/V2c5OWRXQckfE3DhjOjY0E0eLg/sY7u2qAtb
	wSCrESDLgPbE0qyDMIK+uibOjN83xhCGHw86Y8TCvHpO2vqnfknJQw6uxXJ/oh9HGnleK6
	RWzxyDWlbViqizp7VCvAitWlYam+LYc=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RRYlRSJt;
	spf=pass (imf11.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781236799;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=M68SdaBUscGNhmEMw93Y768kiSRPJvpYSvhhFPj/A3Y=;
	b=uECpBHC+B28H1wVIgO5YDrI/OTsMODS9CCFI/qLNz82VK72xMzhJJMm5NjM+QWTqNMLByZ
	2KU7sAivYPrIxSc8QaPEx8qdkgc0Igt832k6Z4PWYICVZc88ns9rgR6NzjodRJVtFl7A2h
	sc3ucBD/Vyo/KOswS12fDBRm6eJyFr0=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aa679cc2c9so73982e87.1
        for <linux-mm@kvack.org>; Thu, 11 Jun 2026 20:59:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781236797; cv=none;
        d=google.com; s=arc-20240605;
        b=WcDGRGvm6dB6nd2k2wEp8ih2D9UzYDssdsOrnYWB+GjEMq7IhsYBtdH10Z+iOgCOq2
         p+L2kwvMwVrRIqJit01Pak8++eZwSaqzLuvK9gfWWc6VvXu6tLZNqSoiyvBVePwFYTdQ
         BImSeT1kI74g62VinvxR41sw0f74T10/n+p4oVf6BldC8PBducjkcw1mZB1grRTrr36j
         Grpg+8pLwUpNBpNGwNLxKZYY4NvceBcNrLer0rWSjWNW5pq3kezDRt+iboNmclcjyx6h
         Hk0BMWJEPYDPqIoi6qXagyulnOVrIieyiJNy4OQnbAqU8f/hGDoYzu+pCWd9UEYioDl5
         PsJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=M68SdaBUscGNhmEMw93Y768kiSRPJvpYSvhhFPj/A3Y=;
        fh=nVL2E7DrXzLb0WUB/hflHgJDn0/a2bIAkA0+uOfu/xc=;
        b=jvEZ8NMvw21X1Z30t1xYYidFXa8fUxQLUilD6ZJVWoVaHseWuBVGbplN5pMJkUygtT
         ONvOjUDZ6yCLmN8FtGFxzK1PgfEAhMNGKAFKQIr343CICV1Z3jBX0e2X3E0tuTR6yIbV
         nrcREzMNVvU9vhH25lPDpwjXYVoreVLgbBe3ZQq3qenZvpxTOrWwc1IgA5zVxRs6Tdef
         Ps8LnWg+w5Rbyz2yJhIMyhY5joqQUbqfHxZE7a44Rc3taHSdl09uIOBSzQBdxV8mz/bm
         44jZxu2FAKhgdrTD/F7qjkmupQGAIlt+kdf0YwCeI8bfnxrYVOyk/OzLKxDcTqnmlw0R
         xWHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781236797; x=1781841597; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M68SdaBUscGNhmEMw93Y768kiSRPJvpYSvhhFPj/A3Y=;
        b=RRYlRSJtBW6H99KukAj1U5xV8RcRr5/UJu64iLT9bfmQ+RT5lrIc8zg7bggg1TKgPr
         WHD25CDoSjPFnrwWp3YouSXTGMPPrtJY8GbAmG4m8OVlDjJfMPnTuScK6Ob81VDV8Fy4
         VgCJxKpOzvrRR9e+acagQRZnv3L9KzvHcc6hfHabGvHw/L8vqulr23r1IklcoeRTBGoQ
         zM1bfHiLhjfEi4duqicEa/+98j9S1vzcIM60PWSe+VDpblyMXoBEJ7j2MVrxs60On55Y
         1VJVaFI5HIU1TsUbDRV+eJn4vL2vqor2OaYnY+IqLTLnt8ItrFEMaTOUzQX2hhGV216p
         w6oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781236797; x=1781841597;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=M68SdaBUscGNhmEMw93Y768kiSRPJvpYSvhhFPj/A3Y=;
        b=DbfCI8hDIIAxpNS5Z6dUJve1gkXKOTXj7Azm93/km4kEcnUBeVOrpCoZIm444JvtaO
         YdkWd1xgDo2Y96rkYIg88lXhoPZbRQWdsKc4oHm+cvedjLliBjOIlCXo5ksmH0i6CDZ5
         /P7/afVbmk8vEWOSc9OH9Scsaxe8BlOrSkRzKC9cf/aAu+EXCGeZOZB8/FoBUiZpqTB0
         FqzjwOg9IjqY0zMzOnhF2BbHaWNPlG76v+yL9xa4AnyUzRZGFYr/dqElQl7FDEtdIqlM
         oRit3/RVHCAaL5ihyZmEitMPRo/uZYQGodp8+/sL6Kc1AjxSxqi5ed4aiP744anVhCss
         j7gQ==
X-Forwarded-Encrypted: i=1; AFNElJ/QhYEDdHiI6Z5UfmvDR4IP3W3uB7NlPht1QFsRNIT1rL6eCIMI5fYTQcHf8i9fsKKqUHuBrDomVQ==@kvack.org
X-Gm-Message-State: AOJu0YzLtl/6Yiqca7O0BzB06wMGnBZvd+AI25biQ2Xb6JHMrZgM2Ljy
	TjnLFvtu0COEao0AzdXOGcljjdK98hEAoKxpLM1FEzywhPErkZ5G/8GcEn6jLCVoGHJT+T5cm8L
	l9UixmDaU6w08D6YCAB65Y1zOWyN3CLE=
X-Gm-Gg: Acq92OG/GlGJ7fdZDQEaR+emaHbq8VRpb0sX/C+7cJhDur6XLB3qLPMINqxXYy3fyX1
	Qra+ISjUXM2lNMVhqmtFsA3ZsOUrh6V6T4zbgHj//lHTK/zq5fNCerzZmIYnJchhxbJXdokxZa0
	aQc7i8HXmmqKqI5BHOBrnMeAFhyxLoCBPb3jw6Id17CkSDZXKJ46upb/6XeTnZvy/zXTQV3ezUy
	Tbt2Nwevj/8VbfOAN++E+nKwejZUSesOGXmi9kgK0+bdqDD4jL8gjsu07x6/SiWA0vOAW6PSu+m
	rGbp4QdV
X-Received: by 2002:a05:651c:2229:b0:396:7eba:a8 with SMTP id
 38308e7fff4ca-3992b2f6288mr982921fa.8.1781236796920; Thu, 11 Jun 2026
 20:59:56 -0700 (PDT)
MIME-Version: 1.0
References: <20260610120535.2370844-1-zhaoyang.huang@unisoc.com>
 <b5393993-e75d-4e67-8dc2-85c9659ad27e@kernel.org> <4348A64F-30F9-4497-A839-A80BCFFCFFE0@nvidia.com>
 <CAGWkznFQH65gJO=xvxZLoDGWLu7YTCnSyfoy7JdLKV5eY8qLzg@mail.gmail.com>
 <2F9A72CC-772C-4691-9F18-77306EADC6CB@nvidia.com> <CAGWkznEGt1eRmiTLsU6DAJBmmbUG4ZY4HE5Cx=Oy0yznqGb0UA@mail.gmail.com>
 <A7D51FCA-7D88-449B-9113-7741BA2D659B@nvidia.com> <CAGWkznHyxMNX3=A8ApCuY20As4NJpF_dCTaY_5+STVSv3RjsBw@mail.gmail.com>
 <aiuAr0kYDcc-AoVg@casper.infradead.org>
In-Reply-To: <aiuAr0kYDcc-AoVg@casper.infradead.org>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Fri, 12 Jun 2026 11:59:44 +0800
X-Gm-Features: AVVi8CczdIyZGH-zgChlHE66kbGCubjaQD1D4zdIw0pHYcXape8Lc9yFY0RYr8Q
Message-ID: <CAGWkznHMm=Fu_LQ3ZrJ4-ZoW-bwu0N4_i_YfnO5x1AbmP2pPOg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/huge_memory: do not add dropped split tail folios
 to LRU
To: Matthew Wilcox <willy@infradead.org>
Cc: Zi Yan <ziy@nvidia.com>, jaegeuk@kernel.org, Chao Yu <chao@kernel.org>, 
	"jyescas@google.com" <jyescas@google.com>, "David Hildenbrand (Arm)" <david@kernel.org>, 
	"zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Barry Song <baohua@kernel.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Lance Yang <lance.yang@linux.dev>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com, xiuhong.wang@unisoc.com, 
	hao_hao.wang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3B32440006
X-Rspam-User: 
X-Stat-Signature: bupurb5t57o6a4bomeypmre1d4qjixuu
X-HE-Tag: 1781236798-748902
X-HE-Meta: U2FsdGVkX18qZiktIwvANJDCqs9pt8O29qJcFkOytB27+35VvtXCOePuBE/VkjqENraSNfrGaDi0jEo+yzbzmPa/JCIViwdPcsretyUSdg/WTF5QiD70sMAiD+FJqbQd/Ljse2At3Xjc1SvK3KpOPtVfmAjx/PBMuNzvysHXZkKSgCOcVl2fu0db+ZUDBX9xa2cDwZYMBa+gtqIlo2LArK6n4J5hA+padP+L85rooruYmRq3peIl8nvZy1DJIGIOlj0yORluznCs95998q5HiGGVcZNDsG0pqGNdCFrcCzQ0k5DNbYG776NGQaT3oRU6kNp3Du4C5/xOYPhJTwhKt04IzOTeFQMkYzsgOILb2Qmal7unkOE5CsRUTplonHyQWJxf02CMtu+BZ5N7ll0m73owDiFwsW9gvSq7qbGj+H9GQOPDx7CQ+kJSt+uKHxGhAoYk63zO2wGpZiDymJ015tdPIjooM/MIbhcuiflEhsvy6RV4Z1CLNUDjYvFadnJAMVjs/EDPtaFXSKG63AP4Ks2Y3izSIO6b3lDQMDyAHGBCObPW5u437J7pc1h1ozYB45Y4C1KgLvHD03H/3kX2W6bUEzAWPOp6mTG0uVmZgAVH9blVr5FlM6DDEC7OmwZ5bsFn2YWfZOyTDPiex6fA8PrMYqLFw7lZi8RPtiu9IcE3VYGSORapN8Slp4uQ0y7R+yoIyB/9vAHu+S6vWlg0JpvaAbzZ9M2ROjIS/myzyRaaOQnYfLQ3SM0StHo2MR2C2ANVtUfwBOVVVMOglmGhC08slk+YFIoqtp0JbD4p7ieHcyzqvvaf96FgL1vjUAuH4DW4XLinkVgJQhJIcs25gtEVkBXvEyk/RGbZ0c3Z5VHODWctsfJ9f9VUcSYIiQRzJvyBshff1VfqaW6P7FgHh8Ja/9V1E0QedRp6Muax068kiG5dK0k5F+qojCqnIHXBKr8fUwX97SXTQbDYt1n
 Ee/zBYtH
 LIfUa//IgDMMT+R4mmo1/LGdQEjqi8EoAxC07UjThyNgxXCep8ny8JumrgeMUNGaHM9AfmCisyhWaJXZ932KRMRl5YwGHVDIhT47dbx9MLKwC38Hx1wX99QEKq3e0cwM1zeeMqqcOeuW33u7vBNXYJ0sdoKa8KQxHwl8ojxyrTwPrBsoMIVQTizVGinxY52pIYy3Rk3XyWQ9riNSKMKWjpjmBbvSvGQkCdiAHC/qbortyL++toKwPEAasMZMG0KmW7SpQitRWAY6cG73WG0TJqZGbYkLLPEs5uXiThawIaUCc+VJfKPMzIKAzYgVs5GxOZJJqvIrWTkINtn7dPM5BxllvLJWdPgzHt5in8pY2ctEcnENej11obyxrxnqGHQCj/0NJIwLZJNUxzEtq2QkR9MUeYsaohYcizwNfmCPVfMcrYMrHoPNm1eQ57cyTVKzNYyvCM9F3Hy056Oc7i9u766H8RatIHGbe8RXrYV7o8Qs8aqlGF1Owxth4Xmiu0yJWrJsbNA3NrTgIYEr33ylsc0M38JKy8GO5wMTriZpzkhjU1Hx7KAy+20TkNzulhLq07/ZBzsAtP71XSDL+5thg8LGrfCDQvYW1nYwxsoBuDSFY+AcQmlXchzLmVYI+GDuBSkaO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jun 12, 2026 at 11:44=E2=80=AFAM Matthew Wilcox <willy@infradead.or=
g> wrote:
>
> On Thu, Jun 11, 2026 at 03:45:19PM +0800, Zhaoyang Huang wrote:
> > > > pin_user_pages*(..., FOLL_LONGTERM)
> > > > =E2=94=94=E2=94=80 __gup_longterm_locked() [gup.c:2465]
> > > > =E2=94=82 =E2=94=9C=E2=94=80 follow_page_pte() [gup.c:802]
> > > > =E2=94=82 =E2=94=82 =E2=94=94=E2=94=80 try_grab_folio() [gup.c:858]
> > > >              if (WARN_ON_ONCE(folio_ref_count(folio) <=3D 0))
> > > >                  return -ENOMEM;
> > > >
> > > >                                // Could __folio_split->folio_put co=
uld
> > > > race here ?
> > > >              if (flags & FOLL_GET)
> > > >                  folio_ref_add(folio, refs);
> > > > =E2=94=94=E2=94=80 check_and_migrate_movable_pages() [gup.c:2490]
> > > > =E2=94=94=E2=94=80 collect_longterm_unpinnable_folios() [gup.c:2391=
]
> > > > =E2=94=94=E2=94=80 =E2=94=94=E2=94=80if (!folio_isolate_lru(folio))
> > > >
> > > > Could the __folio_split race in the above scenario? It looks like
> > > > try_grab_folio set the refcount without using atomic operation.
> > >
> > > folio_ref_add() used by try_grab_folio() is an atomic op.
> > > Which refcount change is not atomic here?
> > The atomic I mean is folio_try_get is implemented by
> > atomic_add_unless, while try_grab_folio does this by the below
> > sequence which leaves a window to have __folio_split race with it.
> > right?
> >
> > if (WARN_ON_ONCE(folio_ref_count(folio) <=3D 0))
> > ....
> >
> > if (flags & FOLL_GET)
> >     folio_ref_add(folio, refs);
>
> No.  try_grab_folio() is only called when we already have a reference to
> the folio.  It says so right in the comment:
>
>  * It is called when we have a stable reference for the folio, typically =
in
>  * GUP slow path.
>
> You may not be able to see it; in the GUP slow path, we have a lock
> preventing unmapping, and the folio is mapped, therefore
> there's a reference count on the folio already.  This isn't true for
> try_grab_folio_fast(), which is why it uses try_get instead of ref_add.
Thanks for heads up. Could you please help in checking if this is a
real problem?

patchv2:
https://lore.kernel.org/linux-mm/20260612023456.2424044-1-zhaoyang.huang@un=
isoc.com/

>

