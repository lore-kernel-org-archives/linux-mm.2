Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68F12CCF9E0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 13:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B844480145; Tue, 28 Oct 2025 09:27:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5C6A8013F; Tue, 28 Oct 2025 09:27:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A717780145; Tue, 28 Oct 2025 09:27:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9607F8013F
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 09:27:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6B24D12A991
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:27:18 +0000 (UTC)
X-FDA: 84047599356.14.D15B375
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4C869120005
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 13:27:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vOqZ7CBl;
	spf=pass (imf29.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761658036; a=rsa-sha256;
	cv=none;
	b=k0CYY5ITYpalhURvIQVQhZqAwYzFPzmG00DD93M/8XYXwFNKacULh9kLa3BHoH7WQSlwcH
	a69ns9Ex0dDhMBHoZJEybMNGZNwkoNBlo9STeD4AjiigkKVH2LSMJenDiL+DppuhPJzfzG
	4mAPC38+M7c8bzj39pCbz3KCiAZMiEQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=vOqZ7CBl;
	spf=pass (imf29.hostedemail.com: domain of zhangqilong3@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=zhangqilong3@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761658036;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CGynThmWgqkc/pLRI/6X+ARzDe79YUlv0PioPW+llWE=;
	b=sB6h/JUTScYTfJs9g6a/YI+1OZHyXFoZQ8HR0/7X8fcbtRv/dFLjk4mCwLmSMfr7V63Yl7
	rh+ljcP/6V4UtZhW+BPzIoLTU9FIlUICE7Clso0ThVR+Am9iofjRaCe0cuSyZfnzJN+qUR
	Ih66+N6TbMPF0ivwvCz7QnxR0bi1o60=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=CGynThmWgqkc/pLRI/6X+ARzDe79YUlv0PioPW+llWE=;
	b=vOqZ7CBlO4peHO6+2xrvniiAJ6L+N9x4g+hLqNyez9wMLOZEZ+rVjym0lpE2lWLD0mVDPNur/
	NEq7lI+8CLZH4laP89Lynt3FGQih4O54neJQS9gc2VJy/f1jmMBxJJrIl8jxXrnato9nZc3FlLa
	jsVnUZTOYwLriEbBjTWM6go=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cwrkJ3lKGznTVF;
	Tue, 28 Oct 2025 21:26:32 +0800 (CST)
Received: from dggpemf200007.china.huawei.com (unknown [7.185.36.2])
	by mail.maildlp.com (Postfix) with ESMTPS id 351401402C4;
	Tue, 28 Oct 2025 21:27:10 +0800 (CST)
Received: from dggpemf500012.china.huawei.com (7.185.36.8) by
 dggpemf200007.china.huawei.com (7.185.36.2) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 28 Oct 2025 21:27:09 +0800
Received: from dggpemf500012.china.huawei.com ([7.185.36.8]) by
 dggpemf500012.china.huawei.com ([7.185.36.8]) with mapi id 15.02.1544.011;
 Tue, 28 Oct 2025 21:27:09 +0800
From: zhangqilong <zhangqilong3@huawei.com>
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
CC: "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"david@redhat.com" <david@redhat.com>, "Liam.Howlett@oracle.com"
	<Liam.Howlett@oracle.com>, "vbabka@suse.cz" <vbabka@suse.cz>,
	"rppt@kernel.org" <rppt@kernel.org>, "surenb@google.com" <surenb@google.com>,
	"mhocko@suse.com" <mhocko@suse.com>, "jannh@google.com" <jannh@google.com>,
	"pfalcato@suse.de" <pfalcato@suse.de>, "linux-mm@kvack.org"
	<linux-mm@kvack.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "Wangkefeng (OS Kernel Lab)"
	<wangkefeng.wang@huawei.com>, Sunnanyong <sunnanyong@huawei.com>
Subject: Re: [RFC PATCH 3/3] mm/mremap: Use can_pte_batch_count() instead of
 folio_pte_batch() for pte batch
Thread-Topic: [RFC PATCH 3/3] mm/mremap: Use can_pte_batch_count() instead of
 folio_pte_batch() for pte batch
Thread-Index: AdxIDDiulwIESNrFTrCD1E5/3V9Now==
Date: Tue, 28 Oct 2025 13:27:09 +0000
Message-ID: <8dc1d253056848dba950e74bed8218bd@huawei.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
x-originating-ip: [10.174.177.115]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Rspam-User: 
X-Stat-Signature: hxs8sx7rsrokwb93ramnqtir6ynk1c6r
X-Rspamd-Queue-Id: 4C869120005
X-Rspamd-Server: rspam09
X-HE-Tag: 1761658034-954046
X-HE-Meta: U2FsdGVkX185EnV7YYMNqKklurbc4YgVgbOH7Ysv0xU+bQnjzYGt58mP3MmeU82+x4TFaRvPpwlHTu3t4voyG1fddTjpPfd5Vu1nHF8uL8cmVLW+dHNPmbKdCW4IZPqaOS/MrTv37E0m8GGIJgwrx2W4G4AJbQjnv5F6ecUx4U/q6H/yfEFB5DpXg2mt84/bO2wOoV9g9awliTUsKxMJgYuDnC1i6US8OdASvWBXxzUwuHP8KSexNyvvEamb2D6DFCXpMYMjsiNYzaR5XzEX7PH6npIG1b2vhh9/Sq2LBSCqcUbQIHgClvI9poMbZaeeEkK6Rd5yw/HaJme+7PIbS2R4z1gbJHlvRu1vsKt1mkxD4qzp/DIkXsszEJOCWz/HU2nHZcN9fldEpheUxOFriAQ2uhvxSrx/6OJigXnLfTK7QeHWaVXq68HLJb/pw+XOd0EYJgfWmLtWLYNF/e8viXTD0RtpmlGOTWb9PT2hqbawq9XmYYpzTBM7Cyl/TvpAA6+1qu+HqwloeC+DgnR0/apQ9mbChxbd3VBheV9tV1XLqtUJqYRxthHcPWNF80ZQM0+6rpexG35Do+K5nrFde2CZC4sEtSYzkwrIbwwYyEzJf2MldRjpFbZrG7AxekWORSql/o7cfSFuIh2TS2O3zNUMSp9/T/SEP9TGe0ZUlfUf5IImWYDTlwenr6W2Y916P3fP3/7C74+W8OkqBpRW8naayFi80j1TnJ6hGMPXHzY+6PTGxjufj81A+2GbI2a+KubHN0wpc5BWQoiVrD/1ALrpRhgMdcLPU9nJ6Pe04VfrMfhjnxMxTxx3kN+mA8AgkgzuacYTGQJKPT1xiO/uy9PjmODzLAhwwNfF8KEdrnKib5XfbJQmQ12AmvYbA1r3mGA/zVVpQ7qDGS8hKVDqN2lVJV42I1oumDkl7jI3qB1UMxGLcti9IXIIukPGcGKwgbMQ/segjhNY2/KcO7F
 hMagEExx
 BnjKLqDVYSNOSyhShN4LA38hFor9+MvqLbxOZsM2iWSd4StnivVDg1d2DAx32xEWzL7CiaIHydIQOSf76wmL/9PU2ukKcx0ks1UJSUTkTwn6P+QudbR5bEi+qOA8PMELHTHOuud8EqKxp6cjxzU72MirC0xFe6QEas4nSgXmIaofpOSGdRWaP+pSvfAh0kaBWJL0RJraV4vfRljaOkZsR8OLIKIrHmRHSZiYNPUyaGJvNIOG4LbMc4PQye5cE4jMSz25JCAKRO2wlaRvPFtm4kfKbHAr8DGNnqrL6jXsQG5GMkhSmseiG2MBC/+9fJEZ8bje83kY9jncseZ9acH7FRsA3KUvwnv1FUTUVVrvdk+Y/uSsCH7m0lij4+Kj99I+IdkxUoXmS2n5b4tBn5kjkjaGCs1qo9cixEU7D+Gku+TFpOlZzN17OsEqEvJNx1IE+rTRrk8fqpU+LcV//vv3IJq+wSNDQ3g1CMZxnA7C7yW937hS8O0SRHBX7AA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Mon, Oct 27, 2025 at 10:03:15PM +0800, Zhang Qilong wrote:
> > In current mremap_folio_pte_batch(), 1) pte_batch_hint() always return
> > one pte in non-ARM64 machine, it is not efficient. 2) Next,
>=20
> Err... but there's basically no benefit for non-arm64 machines?

It except have benefit in non-arm64 machines. In non-arm64 machine,
pte_batch_hint always return one although a folio are mapped by multiple
PTEs.=20

>=20
> The key benefit is the mTHP side of things and making the underlying arch=
-
> specific code more efficient right?

Yes, we except it could benefit from mTHP, and not just for arm64.

>=20
> And again you need to get numbers to demonstrate you don't regress non-
> arm64.

Yes, I will have a test on x86-64, non-contiguous folios or non-contiguous-=
folio
should not cause regression. Thanks for your kind reminder.

>=20
> > it need to acquire a folio to call the folio_pte_batch().
> >
> > Due to new added can_pte_batch_count(), we just call it instead of
> > folio_pte_batch(). And then rename mremap_folio_pte_batch() to
> > mremap_pte_batch().
> >
> > Signed-off-by: Zhang Qilong <zhangqilong3@huawei.com>
> > ---
> >  mm/mremap.c | 16 +++-------------
> >  1 file changed, 3 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/mremap.c b/mm/mremap.c index
> > bd7314898ec5..d11f93f1622f 100644
> > --- a/mm/mremap.c
> > +++ b/mm/mremap.c
> > @@ -169,27 +169,17 @@ static pte_t move_soft_dirty_pte(pte_t pte)
> >  		pte =3D pte_swp_mksoft_dirty(pte);
> >  #endif
> >  	return pte;
> >  }
> >
> > -static int mremap_folio_pte_batch(struct vm_area_struct *vma,
> > unsigned long addr,
> > +static int mremap_pte_batch(struct vm_area_struct *vma, unsigned long
> > +addr,
> >  		pte_t *ptep, pte_t pte, int max_nr)  {
> > -	struct folio *folio;
> > -
> >  	if (max_nr =3D=3D 1)
> >  		return 1;
> >
> > -	/* Avoid expensive folio lookup if we stand no chance of benefit. */
> > -	if (pte_batch_hint(ptep, pte) =3D=3D 1)
> > -		return 1;
>=20
> Why are we eliminating an easy exit here and instead always invoking the =
more
> involved function?
>=20
> Again this has to be tested against non-arm architectures.
>=20
> > -
> > -	folio =3D vm_normal_folio(vma, addr, pte);
> > -	if (!folio || !folio_test_large(folio))
> > -		return 1;
> > -
> > -	return folio_pte_batch(folio, ptep, pte, max_nr);
> > +	return can_pte_batch_count(vma, ptep, &pte, max_nr, 0);
>=20
> This is very silly to have this function now ust return another function =
+ a trivial
> check that your function should be doing...
>=20
> >  }
> >
> >  static int move_ptes(struct pagetable_move_control *pmc,
> >  		unsigned long extent, pmd_t *old_pmd, pmd_t *new_pmd)
> { @@ -278,11
> > +268,11 @@ static int move_ptes(struct pagetable_move_control *pmc,
> >  		 * make sure the physical page stays valid until
> >  		 * the TLB entry for the old mapping has been
> >  		 * flushed.
> >  		 */
> >  		if (pte_present(old_pte)) {
> > -			nr_ptes =3D mremap_folio_pte_batch(vma, old_addr,
> old_ptep,
> > +			nr_ptes =3D mremap_pte_batch(vma, old_addr, old_ptep,
> >  							 old_pte,
> max_nr_ptes);
> >  			force_flush =3D true;
> >  		}
> >  		pte =3D get_and_clear_ptes(mm, old_addr, old_ptep, nr_ptes);
> >  		pte =3D move_pte(pte, old_addr, new_addr);
> > --
> > 2.43.0
> >


