Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDD6CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 17:52:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74AC36B008A; Wed,  8 Jul 2026 13:52:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FB846B008C; Wed,  8 Jul 2026 13:52:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EB126B0092; Wed,  8 Jul 2026 13:52:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2BCB36B008A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:52:56 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A083E168BC4
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:52:55 +0000 (UTC)
X-FDA: 84966355110.02.8AEA322
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id AE8A1180010
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 17:52:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="kLiY/C1c";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783533173;
	b=qOfqZt2wz4eXru4iIvDjvWMPgDd1E4t+I71tl0siRA7vT1j3U4U9iCWaDm1/4jLQ+kmVur
	C8Wuj7NmiguKtt//aWvKGcby4HESd6/+XXM1tAVbXoxYLTCqBOhFS45wIUJT+cJUe007ud
	pdNmZ3F9ljcGX8wfJOV2nycER8cfuzE=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="kLiY/C1c";
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf24.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.42 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783533173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ODUTGjX6gwQ1xNBg4qRm7Lfy2XuwBvad7mUkr1WxTsQ=;
	b=lH+5y+cz1CKD2RaAaLpOEQRXc78yYTmUfPQCYTg8EWb58bHyn1RbrUpEC6Iu6od7d5PXRT
	H4wBhlgs6VAbp635gB3UjAEvm3z2wNO2PwyyZZOwyDe1I36V6SmQHHV+t/Aap5wWf8Mk2t
	BUA+tts04efH/9y8yRXXmgzR5saoJZU=
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-47640541585so578668f8f.1
        for <linux-mm@kvack.org>; Wed, 08 Jul 2026 10:52:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783533172; cv=none;
        d=google.com; s=arc-20260327;
        b=kyYypRb1ePO4Zaaj6vCY4oaX8ISard7w1T0JIfgzg9QvRNRhZwiTD76NZ6deOtwUnh
         OTi1YI9JXnmkf8U9Lg4D6lEhXKxkEfsNRnIIqk6dGudRfPGGperZ159D1eJORxrVsC9m
         68yu9wUH95knOCzO8+8wOkqltFpR1fVfHOTVvGzgBIu9JTtY0tkWGLsGkrfk/BD1zIr+
         2dIMVU2hdvd73B/Jdoa+QK1CsMLG/W5MX3k8qvJT4580ThN8JlK1+sW1VGHRLl6/rhKY
         IIPVRsRq18uKFj5gFYrzfe2EjyqMgtrEIEalO12saV4NSwsNS0JuENJOrEtvTGbi+OjW
         StjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ODUTGjX6gwQ1xNBg4qRm7Lfy2XuwBvad7mUkr1WxTsQ=;
        fh=sO+Yj2o6VKM+8QrexolmbnshG8uGZpKtA7MveI5iEmE=;
        b=JPVHFw6fiuDs2u/uRb5fGjvZ++IJa8GD3cH2693EO8G3UBOEisOcIRzRnLk0hoB0RQ
         gwWjZ8SK+G7Iit+KnZW1+yL/WCzV7J6hRpa7iHPugMBE4tD142FN1ofR4MHCnXMXear0
         goLLdVgXCZ/FgQrr0aSqKU9j4LEOfloDmYvXgWcFdAPno1VimV+cl8e2GcCW0krNhMNb
         YL+XjXPj4NyYcE9t/TA71Hk6L8cR3YOfRECH+tezzXWfndRwITplTsOMAxNwil71pBsx
         LpKUJaKHrtAfnqCLApAc+8+orShqaRvV4ZL7ELv6zL73+wYlU+Xm04F+5AW/gWVIqlRT
         JQTQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783533172; x=1784137972; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ODUTGjX6gwQ1xNBg4qRm7Lfy2XuwBvad7mUkr1WxTsQ=;
        b=kLiY/C1cY7wLstLRvK7I7YJEnnYACCAp3+zeNw5T/c7OdhdX6GWXdzViLkKYDS7p4M
         lV9LC3m+Wrd2oRJjtJa22uV6R88dmU7Evi+soC2o8c5hydC3iV8YDRscS1+K4bu9mR+B
         m2N5UnFxVVNLv88AaFT1xm+W+7qEdkOwFpKM+buwWpxr+RhwR5SbrMr8HaalLAMM95c3
         cHoGmEnk7ZQWV8C8WdvNJOgo8TJ/qEviD2goY0B4w7soy86hgDoU0p4NjvxBtk6rLGL6
         hj0JGmdXAjz53dU6KE+VqW5ffK5NFFPrCzhKG8yqQXyeN/aJUY+d6BgXKgGXUIzNCNl9
         MNCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783533172; x=1784137972;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ODUTGjX6gwQ1xNBg4qRm7Lfy2XuwBvad7mUkr1WxTsQ=;
        b=B0dniW4W+mefVxT8vkSBni6EplORiMnV276JVIR+hhEzKdwmvkZOv8JabotwpELFoM
         ECd1yVdlNEyFCSYILhXzbXJQqMxSIFHeeFBdaYu318eJ2E1hAi3x0rB74k8GIoemycRn
         go/cSwNCWT3ZgquSN4q4PRvcfTIyGvL3QKdY0mJyAIM3ViT7lFmIG0ZfcaIj/cXBvEzP
         iW/wiVhRYyeRtj36qGTew50x4T4OS78dSC6AAA2HDsu0R1KZVdsJfzr4YH4e1uH8umX1
         AK4wZ8CBYY5Po9+qFqklgx1rWYBgrnBz57BDVLgh2SfLu9cjIRu0DTtCCgCA4yy/UN6o
         U7Sw==
X-Forwarded-Encrypted: i=1; AHgh+RqkqqStf5VX9Cx8wWghGJzWRSm5RS+jWzpSPcNuxTQzPtWxYWuyh6SckasucqaceYumAX1C3A3qJQ==@kvack.org
X-Gm-Message-State: AOJu0Yyeqz/vxUE3mqWxgBNCV7r+zOARgRRUTjcVT6AzHmLbcoczpxgA
	15XIyvOofgk/XojPsl/gAxNmjeYL6V5FxCpF2Eh604VBtn23OswpaO88qYxT7HgGBMVyRZYtjDD
	2XYk88M5z9zGqWR9hcPVrS/i9naRUzPI=
X-Gm-Gg: AfdE7ckDwEUZKW+kr1uUvYF74DpAX18wRyFg2/M+9SoWHZ3nN8NTXBgJJy7w33XtxSc
	DAGg5IKnAKyMNHvL7g0263ruxi74inN+Gi5X1+ZuTqaXyS4bLjh9W6ClfNaKfNcDrMqAnVdrku4
	VRO8OHA+TjQ35OLXtMvj0/FTIBxFcROJR0nhI/ratfjfDZqGeIc8lpiAbNLIiigkV0qMvGjbsl7
	K5otAyeHIDY8bgau56DVtMbwh2LxWIFNUPoEDaB1VAzCENXhQ16Ktoz9OzCFGRpFZp2+RUe+TwW
	p4TvildymNXoyabvqnsaPXl2SkmRoSzVLkJlyUFjzWmWOXJfADXEKZpmseI+xSk=
X-Received: by 2002:a5d:5d0e:0:b0:470:258b:b20a with SMTP id
 ffacd0b85a97d-47df072e0cdmr3993320f8f.10.1783533172118; Wed, 08 Jul 2026
 10:52:52 -0700 (PDT)
MIME-Version: 1.0
References: <20260707201735.4113107-1-joannelkoong@gmail.com>
 <20260707201735.4113107-3-joannelkoong@gmail.com> <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
In-Reply-To: <584098de-dd48-4004-8e7e-3d826e60c860@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Wed, 8 Jul 2026 10:52:39 -0700
X-Gm-Features: AVVi8Cc2n1_H72zYC9ks6sgcP-WB0WebXEk-ehLngINs3i7UdkHv3gRazx4q7U0
Message-ID: <CAJnrk1Zc1cZa5edmb6Z18nO3xfLBww-7wobxkOe2OJmWE9qzpA@mail.gmail.com>
Subject: Re: [PATCH v1 2/2] mm/memory: add anonymous mTHP folios to deferred
 split list
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, usama.arif@linux.dev, 
	alex@ghiti.fr, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	baohua@kernel.org, lance.yang@linux.dev, vbabka@kernel.org, rppt@kernel.org, 
	surenb@google.com, mhocko@suse.com, willy@infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AE8A1180010
X-Rspam-User: 
X-Stat-Signature: ug6h45ypbii69a1mr3jqtfhreyn1dux3
X-Rspamd-Server: rspam03
X-HE-Tag: 1783533173-132871
X-HE-Meta: U2FsdGVkX19TrDBAlqJ+5wPnBo8VvJkJ62lEPqni+Rw+teYMWMM9zGG9DiDp1KVBblre2btMlzOd3S6njv2CXsAi4dIyBw7yAQ5RGO5Hwl2Ba05S8RdAvPddA1hChaSMhhhKjT/kZhz4huFiadWTD62U67V0yg2A7knJlAcrMcPpIPzM9sELLYavOFQZ3taNBDpdSmqCJnFrdpW7qHgnDy3pwVv4sWS07jfZ/swzFWNHA9+w1nmHfuKiSvlw6jtNExUpFj4xEOQMmrVkm/Y0afK81JJQ6Npi4DpdY0HCVWOCa7HEjNdNOECT5sNdQzWBneeWXgg4JgKHbQ0hGXSoSg2ax3kYmwnzdmV3GsX75bUx5nadBstQE4s8a3Hrt4FnDtPLyD6lxbocXOIf492TNdLS2eZTjBN5TmyjXr+Cn5OqG48VPGBYgmy8yBbNgZfBtbW4fSKgm/hHD5xAKBTXWRXHT+GV/a29iNETSjdMwqKE++J9dFWjGU4pL6zL6/+Rw5hjpUqrq+xDa+Q1MZHEHj/cNkRpuF2drsq+EworD0e0z55bbiOgZPKxC3Soovq3orCZIrbdkJTLsmr8u6gFeOLHGyuQbU8PGcnPSPKduB0/6wBfs/joAefU7iLvZvZ+Xf2PsXmBEs6sfnRVRxj4yOXfKIkCtXruRZLG/2Mxja7bBHADl9E/wi+WzlioJW2R8IDTcT12knB2bkFC4MPinGkLW/BmqKobjF3G7E305JDZXLuCIMgdvNZmvkWAezeIPY+gr7vt9DmFdxW/3FYxIqYzhmsPIU9KOoxGKd5+S50PtjEF5Hf261GngKMfJb9JnBpgL4CMGXW/4q5i00U6BYkIu/jczKeGL/t1zbpf3PnvyjCtBXa1bEmJ0W2DOpSCSTHeeAmcmpH2MhbZgPoel4eSs5GPFU7uoyWmPWe4Xu6H3Xd8+AUr2sjlh289ZwC3B4RQknfQCZdpl11bZqg
 8cesNX/x
 RbA4tiMKd7adU3IsU2niG++p7QGzudMeGE8W6nJ7yI5YTdqx36s8xD7S7nWCieEm7vo/R9hFIbAONwTKAMuALT8wam6zbAQ9C+5X7+G0nvVf1h9enCZIxHIrRh/wfvDkZ/6DhbY3NLgF1A/OZ2xugFnsMlb0QBralum/klrb3V+X7NSZR4k8O8zGBD28RLFLKwJr7aCtBEWyrMqbgIq5Ssu3oO9WMIwuXctCaqo0/SplNTV6/jyypkOqZBnUCEc8oin1GZqUcuHTPxNOrdkydshO9X5W4kfllhdKYwGj1hdypVeSNcTX144tpz3LL/ThMjjuoHLymJZvIhGjM+DK3jyABt0aNNp4cxW6VapiLeYeeREKQMK4ldM8O9Ns6aBKj0SJoHGRUnvNY0EXG+OwUbwq4cBdJYf3d0crZUoAk95ejpICIlCme7XIbDVbI6jNw4oUJutu/LXNR2cLXsN5NZ+K8w7tagUpVkzYR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 8, 2026 at 12:56=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 7/7/26 22:17, Joanne Koong wrote:
> > Unlike for PMD-sized folios, an anonymous mTHP folio doesn't get added
> > to the deferred split list at fault or collapse time. As a result, a
> > fully mapped mTHP folio that is mostly zero-filled doesn't get split by
> > the deferred split shrinker when the system is under memory pressure.
> >
> > Add anonymous mTHP folios to the deferred split list so that if there's
> > memory pressure, a zero-filled mTHP can be split with its zero pages
> > remapped to the shared zero page and then reclaimed.
> >
> > To minimize overhead on the common order-0 fault path, the
> > deferred_split_folio() call is guarded by an inline folio_test_large()
> > check.
> >
> > Suggested-by: Usama Arif <usama.arif@linux.dev>
> > Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
> > ---
> >  mm/memory.c | 2 ++
> >  1 file changed, 2 insertions(+)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 6637c5b13c9b..441d918e3dc0 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -5259,6 +5259,8 @@ void map_anon_folio_pte_nopf(struct folio *folio,=
 pte_t *pte,
> >       folio_add_lru_vma(folio, vma);
> >       set_ptes(vma->vm_mm, addr, pte, entry, nr_pages);
> >       update_mmu_cache_range(NULL, vma, addr, pte, nr_pages);
> > +     if (folio_test_large(folio))
> > +             deferred_split_folio(folio, false);
> >  }
> >
> >  static void map_anon_folio_pte_pf(struct folio *folio, pte_t *pte,
>
> I had a session [1] at LSF/MM about having essentially all large anon fol=
ios
> part of the the deferred split queue.
>
> (1) I don't think this scales.
>
> (2) I suspect the shrinker should make smarter decisions of what to scan/=
reclaim
> first.
>
> I think this needs more proper thought.
>
> [1]
> https://docs.google.com/presentation/d/1RfKWCY1AMVns-WLn-QdAWbI2a-rA7fbFy=
h7XD1Wn5BY/edit?usp=3Dsharing

Thanks for the link to the slides! Was there a conclusion from the
LSF/MM discussion about the future path forward for deferred splitting
or is that still being determined?

Thanks,
Joanne

