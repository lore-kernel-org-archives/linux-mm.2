Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D2A9C9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 12:04:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 149B36B0088; Fri, 25 Sep 2026 08:04:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FABB6B008A; Fri, 25 Sep 2026 08:04:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2AD86B008C; Fri, 25 Sep 2026 08:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C23666B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 08:04:03 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2FBAC120624
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:04:03 +0000 (UTC)
X-FDA: 85252151166.15.4AB6F54
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 3CDC7100003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:04:01 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfORkqOw;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790337841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IuK/P9c6OAPq/+SKum+YEnA5wQo2vUmWCi3a8/VIFXA=;
	b=Dlm6ZGVADgjzRrcd71AxKbEa6Q4oeVKpm9APdrT+dVOZJ5PTwKGctU9LbXq1FK3L+sWMc8
	NJuonVaDCIbuaHT85LkoJwThcxrfeIf7pj2XKodaiIqgcSN1hrbREG+ByGvzo171Yo15+D
	EJbRJGw/ioQNm6WG4WaBNm3C8k+NUYs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bfORkqOw;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790337841;
	b=iqJ8D8SryuGZJfzp26roZr0cWEeYcUw9lPq3VQco7D/txwxduFqOq43TtdLzXbNgxGDTB9
	c+gkcfG+3VpDltk9KUWqMRicTPGS9vboKG5i7EPkaQpM/duS74J1cjRXJJ5Kc1HA5+RgK6
	WGKUeN+0rJMGE573iHsGad8y6TUo4cY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1373943A0B
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0A731F0089C
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 12:03:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790337839;
	bh=IuK/P9c6OAPq/+SKum+YEnA5wQo2vUmWCi3a8/VIFXA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bfORkqOwm/jPH01KRlZxDLwAYlym2PajjAtqz0iI3rvaSi9SxCw5xh08DCT+jq1Pk
	 UqIOxrzR42d0Tnf3h/pfrv91Xhm9l9kIdz8PmTH1sLd8mL5Cqw8Sx3Go3Zr81NlWNO
	 tVJh+xRci46THm57MHhfTEF9d4uYYI+gKDpY9o2/qW4kxGPsEfCRg7lmqBiXB8mH4D
	 AgzvWQA/UTSADFicPeAnClJp69KNg44nVAr3dmAZZ0lDjZRLwGdpkL7NGMlKN7Kixw
	 CC8V2P4xBAYZTHyFHogVgvmmClYDRl/bYi+zF8i4qvzUHUD5E180BoAFX0eaFxohcR
	 EW4uCNSKEhz+A==
Received: by mail-qk2-f42.google.com with SMTP id d75a77b69052e-53315c1a1d3so4930371cf.0
        for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:03:59 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByUuoXkUyj4doV1JYwcx3Ujc+RH3Hs1lJhzl78IBNK3u/oHTuTVqMGyo2zqbCi9PQO/teSlB1F5iQ==@kvack.org
X-Gm-Message-State: AFuF++mdTNC3YAifm5jsGct6RkPhSl0fNeVfNTyY6dgsGbSEk8xCIa8q
	L557gqdgzwS6JCGuWmUowUDHUBCH6i3m9VyGx7xSkhB16n+x5vFHtqKehvhI+UVNFR3Ilck2FGs
	fdbX9PHQ282tvj9Q6ZDlSkpaYk1s7Hu4=
X-Received: by 2002:a05:620a:17ac:b0:93b:d79f:d948 with SMTP id
 af79cd13be357-93c43eb2a12mr376097585a.61.1790337839274; Fri, 25 Sep 2026
 05:03:59 -0700 (PDT)
MIME-Version: 1.0
References: <20260924131106.1730494-1-dev.jain@arm.com> <20260924131106.1730494-5-dev.jain@arm.com>
 <CAGsJ_4yDZypOxjwmAY_usM+v_OJahShz-_uRSAiUZUAzv14VRA@mail.gmail.com> <9c00b28a-8b76-48c9-9318-cf1f4abaf944@arm.com>
In-Reply-To: <9c00b28a-8b76-48c9-9318-cf1f4abaf944@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Fri, 25 Sep 2026 20:03:47 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wHO4RznDsNN5rqvAc3=zMxey672tT7A_NaLFuARjqGHA@mail.gmail.com>
X-Gm-Features: AclHuK_jh9CeCH_kPepZsAmtV7M4LNfu_ssdJYktuOmQA89haRao37oJcpOqxWU
Message-ID: <CAGsJ_4wHO4RznDsNN5rqvAc3=zMxey672tT7A_NaLFuARjqGHA@mail.gmail.com>
Subject: Re: [PATCH v3 4/9] mm/rmap: Add batched version of folio_try_share_anon_rmap_pte
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, davem@davemloft.net, 
	andreas@gaisler.com, riel@surriel.com, liam@infradead.org, vbabka@kernel.org, 
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, 
	baoquan.he@linux.dev, youngjun.park@lge.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, pfalcato@suse.de, jgg@ziepe.ca, thuth@redhat.com, 
	sparclinux@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 3CDC7100003
X-Stat-Signature: aet8o5jyx1y95diwqxifyqmur65adc3h
X-HE-Tag: 1790337841-388046
X-HE-Meta: U2FsdGVkX1/oSE53bcTFVommkxTQYlibahnzYDmihVojJpGcn302X4ryyCro4T4DU+0uzKRRslYWRdwQSHi8S7il3T1pLZCciLXXEdTYpKcJgW3o5uSWVHYlLfRCZqj/wuTDFp1d/Xpo2vYeevXTMPNNF94BDOYZTEwUj2mAJUK+cGLIWBSWP6xaJ6x46fjG7QIPEFr1IM5c/CB7RE/DIhnC126sCP0O0uxLTF68xtBgVS0GCs7hCiuTS0X0qnX1uy8NU31XG17fgrNV+3AjprlcU1B7auwk9gKVMptawY+jph5xVDS+0eH+CM6kIRAL3Gri3a84cBo+li0dP/EAejxnfH0MON0oTvVgX1JhqUz5mA6Js8vsc/74j+sGZp9N3vT5LGS28lxWdhrgzMEFRsSzi8f1Ne5kLqu4M4HfXVISeHZaMci5FDkDFJ/qPyvHWlbwn4Idxo/vr5N+LOVH6ImPFYMQ6lsfAtXEx0XVf3sSIDxrHO61pjFuKUQXmBnK7cbxzNB3WpMWkKqF43LWbAADUorCHr4bgPTowTmIYhe1qOTi6PzmiFbAiMBaUtstIwsAXw6cczb/tnPl92y3ip5p0IaYwHD6EDFw5PnPzTyERoZbEjkPtfQ4tH7OhybE5ftfOMb4xG9CJda4R3Jhn8mWnleoxsbMf2cEDbbxuiV/s1yzP+iyIL/+GqWhg0cGjHbkjq/H802iM18GnXJzF+dEh9Yiu+F93gziNnCwqFLhaWYQVUUgBUCQ8an49IYoqKCdrkVTm0XLKX4dVfmv+CM4LSd9SjOLNASecQvtnoOEatunvpJ1+hzaoE+45qF/XpUbbIz1OcaxGj6U6rF80x2lInxHIHXQHDW1UlgXrImVBjdN3qmTfzpZs8RfnzMH1hVXRrbH5+HzpmbZPjWerozCgitpRstk7dfoTh6kwNAWkTJB+tn46y4CJSQ0uxlgbqlN/L/q4PYZsBoRhyG
 D9HTH/hA
 q1FQ0BO10CeZ9nPcwq3qD8lwwxxMVc24vr/Vv8lZr9Ur6eeE6kDl3FCFsO4euTUfG2YYb5d8z5PYC4inizk041cfixw3Uea62AeElmXYwIyIUrN+SIZW3DZLrEIlYrgLhy27hzxhBPECNO9TqeSEgBRccj1sC2Hht1FZdhN2EDwB9vyBvKZOc++fY7CochQGziNcadJN1O4IUroaBEqmCbEGAa/FlbHtaPF+bIu5duiFF3Y386L8EUSh5it5OVUk1x3QcdpS824KXaUVCRN5claO/Ko5rHcNah06ShCSRQdEX2DSGtRoZbjHPF1JppGH+unsp10R//yBT/madAawjCOu1ymSo2txlqdwfO3JbxZFRmfnvF4TavON10d3EG55JriX8Z5I2bMRtTOclshmLHZdE3EUqS1dpyXgQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 25, 2026 at 7:09=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
>
>
> On 25/09/26 11:00 am, Barry Song wrote:
> > On Thu, Sep 24, 2026 at 9:11=E2=80=AFPM Dev Jain <dev.jain@arm.com> wro=
te:
> >>
> >> To enable batched unmapping of anonymous folios, we need to handle the
> >> sharing of exclusive pages. Hence, a batched version of
> >> folio_try_share_anon_rmap_pte is required.
> >>
> >> Currently, the sole purpose of nr_pages in __folio_try_share_anon_rmap=
 is
> >> to do some rmap sanity checks. Now, clear the PageAnonExclusive bit on=
 a
> >> batch of nr_pages. Refactor the function such that the clearing of the=
 bit
> >> can be done at one place without duplication.
> >>
> >> Note that __folio_try_share_anon_rmap can receive nr_pages =3D=3D HPAG=
E_PMD_NR
> >> from the PMD path, but currently we only clear the bit on the head pag=
e.
> >> Retain this behaviour by setting nr_pages =3D 1 in case the caller is
> >> folio_try_share_anon_rmap_pmd.
> >>
> >> While at it, convert nr_pages to unsigned long to future-proof from
> >> overflow in case P4D-huge mappings etc get supported down the road.
> >> I haven't made such a change in each function receiving nr_pages in
> >> try_to_unmap_one - perhaps this can be done incrementally.
> >>
> >> Add two WARN's: check that the batch is entirely exclusive (for PMD
> >> callers, need to check only head page), and that there are only
> >> PTE/PMD paths converging into __folio_try_share_anon_rmap.
> >>
> >> Signed-off-by: Dev Jain <dev.jain@arm.com>
> >
> > The patch looks correct to me, but it seems a bit hard to follow
> > because of the `pinnable` handling.
> >
> >> ---
> >>  include/linux/rmap.h | 56 ++++++++++++++++++++++++++++++-------------=
-
> >>  1 file changed, 39 insertions(+), 17 deletions(-)
> >>
> >> diff --git a/include/linux/rmap.h b/include/linux/rmap.h
> >> index 62ef511a6175a..91b5763ef466f 100644
> >> --- a/include/linux/rmap.h
> >> +++ b/include/linux/rmap.h
> >> @@ -723,17 +723,23 @@ static inline int folio_try_dup_anon_rmap_pmd(st=
ruct folio *folio,
> >>  }
> >>
> >>  static __always_inline int __folio_try_share_anon_rmap(struct folio *=
folio,
> >> -               struct page *page, int nr_pages, enum pgtable_level le=
vel)
> >> +               struct page *page, unsigned long nr_pages, enum pgtabl=
e_level level)
> >>  {
> >> +       /* device private folios cannot get pinned via GUP. */
> >> +       const bool pinnable =3D !folio_is_device_private(folio);
> >> +
> >
> > If we make a helper that does:
> >
> > for (;;) {
> >      ClearPageAnonExclusive(page);
> >      if (--nr_pages =3D=3D 0)
> >                break;
> >      page++;
> > }
> >
> > wouldn't that allow us to avoid this ugly `pinnable` variant?
> >
> > Then we can make a much smaller modification, which should
> > also be much easier to follow? No?
>
> David had suggested here:
>
> https://lore.kernel.org/all/95b8224d-3ed4-4fe3-9954-d5ba0aa373f8@kernel.o=
rg/
>
> The argument was that the helper would have no context of the pages we ar=
e
> operating on. Although you are correct that this makes the function harde=
r
> to follow.
>
> Maybe, revert to the original function, and have this helper
> folio_clear_pages_anon_exclusive, which will take the folio and do
> the page_anon_exclusive_batch =3D nr_pages sanity check, and add
> kerneldoc to it which says pages should be within folio?
>
> The kerneldoc can be saved by calling __folio_rmap_sanity_checks in
> folio_clear_pages_anon_exclusive - that will cause duplication, but
> then it's all a VM_WARN_ON function so maybe we don't care?
>

Never mind. If you and David have already discussed this, then it is
all good to go with your current code. Everyone has a different
coding style and taste :-)

For the patch, feel free to add:

Reviewed-by: Barry Song <baohua@kernel.org>

