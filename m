Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C3B2C54F51
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 21:47:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 155356B007B; Tue, 28 Jul 2026 17:47:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 105E36B008A; Tue, 28 Jul 2026 17:47:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01D3D6B008C; Tue, 28 Jul 2026 17:47:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB62F6B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 17:47:52 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0BBE16052F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:47:50 +0000 (UTC)
X-FDA: 85039523100.21.71EEA58
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id DCD6720004
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:47:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dC+obVVm;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785275269;
	b=xx7e7Six0bi3I7CkfCZZu03P6oXAZGmdtYkK7xEHOYmEFi+umTnxinLlh+4OkzUcICHYZu
	yxpJRODl1pZuHT+NCeviuqCxlKo3xrw5pc00zYpWYBJPN1nYGo0iSsjY4tYNjqlMPjqS+I
	Fpx+bJESaq1uyKIEVWPpWz+YNt/gRwg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dC+obVVm;
	spf=pass (imf03.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785275269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqib6vtzdDc0bkShWroBmi83B9sA++5bLMZGOXyfCyE=;
	b=g0cKm+73t/8/YyvcQuqj/Cpf0nKEZ9C5RW9a86j11XyIVZ7FJ0vkuZSxayM1rnYHj15FN9
	L8nFqMaJxSdwmIAeB4xCo+4YS4lyIucQdILm0y1euq/PPhhadJTwX5kcp2K6FM4/52A6aO
	KHPKwT7eJR3PBEkm9D/mHtBOUgsITV0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8BC7860A9E
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:47:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41D821F000E9
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 21:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785275267;
	bh=bqib6vtzdDc0bkShWroBmi83B9sA++5bLMZGOXyfCyE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dC+obVVms5DhP6HIz3sEF+YLSHk7l9K6iiS8chnkr+kp+magf/aGaG8FrBxY8aSzu
	 /PX/5Pdz/IPvZwqp3WasNrfIjVlIpnn0vVDakobfng614YkUgRf0ApEnTLNSjej3F7
	 i0fAsoALQHsgVwJ/sqy0B/J4cvxYrWbsvg5S2ZJ/4I9tyfPL5GKyfbkJSQyzcPEuzX
	 dNeS2hoV27BfGSq8Ot1gZaw7hjw3/G4/rbf8o7uTDbfeh9+nbpmfylqIXzyxB2XeSB
	 6V6uj0wecWs1hNsZtU28y6n82lf+AblhhkF5glC0c5HjQDyyDoeM1ycrPE05ovJ0ya
	 JQVlVGC/8gJ6Q==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e7c6ec9dbso21550585a.0
        for <linux-mm@kvack.org>; Tue, 28 Jul 2026 14:47:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpgSdrWMxowKDX3gm6zL5SqLQaEwSQmvEfsDRS5oYM2Q7dAhgBRkEMnwZn8zBhWC7duFsBnZR02Gw==@kvack.org
X-Gm-Message-State: AOJu0YzD1yaIarY0d02qhkHDo9wAqmkRZraShE4f8cVBpAQNESjf5jxN
	pwj+jel/UMyNYyqbtuWJ5+ulmqdf5ncETNmmPp9FSzYW7hJBzeUqFt6Q0UB2G/9l3V40Vg/xLm1
	qGuOnpfnL+i0JBQiKf+tY1SyyBWF+jAE=
X-Received: by 2002:a05:620a:46ab:b0:92e:cac7:96fc with SMTP id
 af79cd13be357-933026cbd7bmr433098585a.24.1785275266629; Tue, 28 Jul 2026
 14:47:46 -0700 (PDT)
MIME-Version: 1.0
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-2-jiangwen6@xiaomi.com> <amiabgyHSz3ZYY5k@willie-the-truck>
In-Reply-To: <amiabgyHSz3ZYY5k@willie-the-truck>
From: Barry Song <baohua@kernel.org>
Date: Wed, 29 Jul 2026 05:47:34 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zgFk1iaQWisYMOR4iFxonwDskRt3Gte0cEts1q9hxibA@mail.gmail.com>
X-Gm-Features: AUfX_mwbnXA4EUHoDC_1ddg6W-_if7iZPphw3fCzQ7jhe0SfShXOygA86MH76jg
Message-ID: <CAGsJ_4zgFk1iaQWisYMOR4iFxonwDskRt3Gte0cEts1q9hxibA@mail.gmail.com>
Subject: Re: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Will Deacon <will@kernel.org>
Cc: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org, 
	catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, 
	Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com, 
	david@kernel.org, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com, 
	dev.jain@arm.com, Wen Jiang <jiangwen6@xiaomi.com>, Leo Yan <leo.yan@arm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DCD6720004
X-Stat-Signature: hmra8wsipy6sptrspdt5ee7e8k5qg3j6
X-Rspam-User: 
X-HE-Tag: 1785275268-792672
X-HE-Meta: U2FsdGVkX18Kz+DVbNPQU4hb8yUP79RGSw9rcBRYsVSngFRc5zFL4zWvGZQpE6akCr9Pcx6jLXSfSwsI+c37MKmek0kNKcUUit9JLyK7sj89uQyMS4HzXSitmJufJ+X6sVnNenRb8tjcT1wu/jBt6GN0NnoROBY5zSV2agpsyePrBPrkeAqhZr8E5twmTIhVA+KD6/DffPWXuIJQA2nG1GSrnFaUFbVE1KfK5roRTUf9Wrhn4mDciO4aYKFAPgJhS2OcbrhQaWSdlr9BYh7Xy2fwLpg6yJ4lFlsCIbS+uIaLsC492Nxl4GWQuSb7w0Oh/7bSejnRekVGAd/XBX9ugCO6H/FOpVnglonzSz8jNtTl7Y8pT6dlwEo4glGAJ1xhOz4uev+wyviOi9qU4W3WbgBVX6vud2Y9aHfCd9Y7iAeqkexysIGhcLax3zyqmUo0llRbWgeWmbUdZepgFikOUO8oj8BpwWxO8XnfxODYEJh0DpSW+2IIc4KMEiYkJwBbttm/6wRURy/6YIrJapDeZAcNogvVENTkq7giSyKJCAagu00ZseFs4RkuV9MCrNUOZ7LAOgQHQnKjwK0Nm01aCUmsuMR1GTaCnJ1FnVwdBRjM3dMPlI7zC6Z6GCEppsP6kLE1FUMeaf4UWN5hywjrl1mg4GBvOkSr9Z1LbVcv4G2nD4BkQGEThOVujJI2kcQ+NjW4Fbh8yHaCcKip3N+e6JLDK5zs/O2qSAGzKiiDpd6ZDNdwNFHf2s2FHEJsMtdGsc49UbYNZnJH75jqufBKFZir/n5P+VmuXvoRZp5lR7D5QHYwNrV1UIw5uF5CD8jTAjASqKh+Qvh33er8cnVnvTYYvwVNCep6niXDREx5Z0zcmQVedtccgcLymWKkdnDUl4GZmyehQ4ERDz5kj939hccPh7XjMWDK+mlWy8Pc0yjn+aFdmavgIJeZ39LePu7SrBjyBPOug6pyyzD+v9A
 zc2jB9HT
 6RsFCPgdmj8YoOuyLseuc7lC7a18/7VyOpURyjn1525D/QXPxSvq3t8vl9nQWTD8ExbJquCFS4KbxXjCdzgV7l/LHYWeshVuqt1t4YGsws0GbnHFKj6UZKr1mfjmrQ4jdwdLadEHrbJvT4Pu7V8cg7S7xrXzPnPghZsfAmjQpnvVQmYV1bkWdGhK+HoA7nTlhBPKs7bLHNRcOaWH4mX6/yGv8OGrQHt812eEsjxSdQMASQwefbnaE2zgEEb/KZamGprFkBQ126YwhLP+Rw67IfVGwA5tE4oGZOu91X8RJJiWK7hobNofdXr2d0iIHEt+zwrd+N5YaQR687sO9e9aQltWSiwZIq0oLwBnE95hFadjckxVCtErbtJIpdBqoBAgzaL0Rjrkp5/wPnuhn9K964E/eFwM/b8ZxYTJMZfE5K3fbQmDjTLStO5i1TxZqgr7kKErtaAhurDO/tuO/oI2cmhcTMqLAeBPW0ibBdyHczefAw18qL7q822tcWg4pva3/Nm38JzF0xHi/DEgXIMlhvNqxtaVvqsuqzYSL2iQcUfqMHOFn2Icy816h5TYKTB+UPFeFcm486oni3wcHzSMwDgIFjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 8:03=E2=80=AFPM Will Deacon <will@kernel.org> wrote=
:
>
> On Wed, Jul 15, 2026 at 08:08:07PM +0800, Wen Jiang wrote:
> > From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> >
> > For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> > we can handle CONT_PTE_SIZE groups together.
> >
> > These additional sizes are mapping spans used by non-hugetlbfs(vmalloc)
> > mm code, not new HugeTLB hstate sizes.
> >
> > Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> > Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> > Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> > Tested-by: Leo Yan <leo.yan@arm.com>
> > Reviewed-by: Dev Jain <dev.jain@arm.com>
> > ---
> >  arch/arm64/mm/hugetlbpage.c | 15 +++++++++++++++
> >  1 file changed, 15 insertions(+)
> >
> > diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> > index a42c05cf56408..7ce159483a354 100644
> > --- a/arch/arm64/mm/hugetlbpage.c
> > +++ b/arch/arm64/mm/hugetlbpage.c
> > @@ -94,6 +94,11 @@ static int find_num_contig(struct mm_struct *mm, uns=
igned long addr,
> >       return CONT_PTES;
> >  }
> >
> > +/*
> > + * num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte() can b=
e
> > + * used by non-hugetlbfs(vmalloc) mm code to set multiple huge mapping=
s
> > + * at the PTE level.
> > + */
> >  static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
> >  {
> >       int contig_ptes =3D 1;
> > @@ -110,6 +115,12 @@ static inline int num_contig_ptes(unsigned long si=
ze, size_t *pgsize)
> >               contig_ptes =3D CONT_PTES;
> >               break;
> >       default:
> > +             if (size > 0 && size < PMD_SIZE &&
> > +                             IS_ALIGNED(size, CONT_PTE_SIZE)) {
> > +                     *pgsize =3D PAGE_SIZE;
> > +                     contig_ptes =3D size >> PAGE_SHIFT;
> > +                     break;
> > +             }
>
> Under which circumstances would you get a size of 0 here?
>
> Given that you're relying on arch_vmap_pte_range_map_size() to give you
> a well-formed size, why isn't if sufficient to check only the alignment?

Hi Will,

Thanks very much for your review.

Are you suggesting the change below? If so, I'm fine with it.
I guess the current code is just being overly cautious for
defensive programming.

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 8429d220660b..c1af52ba572d 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -115,8 +115,7 @@ static inline int num_contig_ptes(unsigned long
size, size_t *pgsize)
                contig_ptes =3D CONT_PTES;
                break;
        default:
-               if (size > 0 && size < PMD_SIZE &&
-                               IS_ALIGNED(size, CONT_PTE_SIZE)) {
+               if (IS_ALIGNED(size, CONT_PTE_SIZE)) {
                        *pgsize =3D PAGE_SIZE;
                        contig_ptes =3D size >> PAGE_SHIFT;
                        break;


>
> >               WARN_ON(!__hugetlb_valid_size(size));
>
> I agree with David that it's messy having hugetlb tangled up in here.
> It means this validity check is now going to miss some genuinely bogus
> cases for the hugetlb path (as opposed to the vmalloc path).

I agree that coupling hugetlb with vmalloc is not ideal. As I
explained to David, this has been an issue for a couple of
years and affects multiple architectures since 2021:

https://lore.kernel.org/all/fb3ccc73377832ac6708181ec419128a2f98ce36.162079=
5204.git.christophe.leroy@csgroup.eu/

where `#ifdef CONFIG_HUGETLB_PAGE` is required by `vmalloc`.

So I'd prefer to address it in a separate follow-up patch
series.

For the `WARN_ON(!__hugetlb_valid_size(size))` check, I don't
see anything broken here. Hugetlb only uses sizes registered
by `hugetlbpage_init()`, which are validated by
`arch_hugetlb_valid_size()` implemented in
`arch/arm64/mm/hugetlbpage.c`:

static int __init hugetlbpage_init(void)
{
        BUILD_BUG_ON(HUGE_MAX_HSTATE < 4);
        if (pud_sect_supported())
                hugetlb_add_hstate(PUD_SHIFT - PAGE_SHIFT);

        hugetlb_add_hstate(CONT_PMD_SHIFT - PAGE_SHIFT);
        hugetlb_add_hstate(PMD_SHIFT - PAGE_SHIFT);
        hugetlb_add_hstate(CONT_PTE_SHIFT - PAGE_SHIFT);

        return 0;
}
arch_initcall(hugetlbpage_init);

bool __init arch_hugetlb_valid_size(unsigned long size)
{
        return __hugetlb_valid_size(size);
}

Thanks
Barry

