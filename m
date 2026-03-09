Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B70E4F41808
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:09:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2604B6B0005; Mon,  9 Mar 2026 11:09:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235036B0088; Mon,  9 Mar 2026 11:09:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1178F6B0089; Mon,  9 Mar 2026 11:09:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F3B026B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:09:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BACD7160206
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:09:58 +0000 (UTC)
X-FDA: 84526859676.30.A7C3FBE
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf27.hostedemail.com (Postfix) with ESMTP id 60FFD40017
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:09:56 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FJwabNsA;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773068996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=woFLTl4MQININgn1l26aXv8v4wFqzDNApNaqLAUyjBk=;
	b=BVdU6iy2umBk5QCz3XtSbh45bp58wAwXU1mWSkGupQq2S4epKjVChLrYROAqsctTmUeXRq
	fBxQ7dX8WC7JaHSXbfa0aoVLouYyUw4O98xQhFvIKMT8XBaT5+U0bbJrKdhMC6UiIhaAfM
	Kd5aoocCJM9Ca4VaGsmN9Kx4imQCoT4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773068996; a=rsa-sha256;
	cv=none;
	b=4aiwSW9zkwNrYF0gRYHYqThBIASkGIltsOu/31NAsfIPIR1IVZ+DHx3kUTx+ysIp2T1ltH
	uWwN2Cp2eKH0pRfE3C8k96Cyk7lH4POBc33RRY4QzDCGv5syeeqRHEVd0yxEujOW0x4gd4
	qFXINUYJpKpFAiTkWaJuBSsMWvSdpqc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=FJwabNsA;
	spf=pass (imf27.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773068995;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=woFLTl4MQININgn1l26aXv8v4wFqzDNApNaqLAUyjBk=;
	b=FJwabNsA/zZi5bd/zdcjzjkaftW5QWldXPxAcv5Tm68j7X9YmAmlVKC0w42eg6IlgV7PCi
	fq/wKaRdu8m9FPv4vJZvydAdJ8bonsTEWZvToAc7pw4R51kwZwuNrxJj2KBTFHPcynuUI4
	SIIs5Ct498lIlhG/IWvUurg4tE2hkLk=
Received: from mail-yx1-f69.google.com (mail-yx1-f69.google.com
 [74.125.224.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-433-KBZLCfl2NTG-wjfLD7BJ_Q-1; Mon, 09 Mar 2026 11:09:54 -0400
X-MC-Unique: KBZLCfl2NTG-wjfLD7BJ_Q-1
X-Mimecast-MFC-AGG-ID: KBZLCfl2NTG-wjfLD7BJ_Q_1773068994
Received: by mail-yx1-f69.google.com with SMTP id 956f58d0204a3-64956932a51so15006603d50.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:09:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773068994; x=1773673794;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=woFLTl4MQININgn1l26aXv8v4wFqzDNApNaqLAUyjBk=;
        b=E72SYDcnIcw1EO4RLeV9+4sKctHGBODC+CODHo5+BEQkOjmb8krrTTGl1kBSXPAx2L
         wN7WMB1nHnlCioeuMsRMcKrdmukI5YkJOg/RrWY7XZ+1DpxoBq25khUiilkWKY28ZoaE
         WUt7EakXus39J6WyVjdgDTriHjOHMb1M97DXml8lEnBQ+d2yAfLb3OZUqmE+JsV2FH2c
         nOzyJo7aehufBMZEdTJYhIoGjqTstbEpmOklC/mSG0mJfnX8+hSXTMP/JmshOqcpby2c
         8/PCd+pV8Gu8sUeZaQNemL57j6b5tbBA1EAzyUpUa8jSYYrvo5wv9lWTavSR2astSFkD
         0Ceg==
X-Forwarded-Encrypted: i=1; AJvYcCV2J4WVD6bMoxAPCzlgG9TdxbD0yPU0/XzfVRShPoEdzSgH1JS6bU43PZt9swPi+KsMyEac5ZGXUQ==@kvack.org
X-Gm-Message-State: AOJu0Yz3bQgve8TEkQnSNVv3vBTnTCXQvUrorp7VEa6naL8W+oguL/wc
	T+IhtBqtdOeQqmjGVEekngI+dE6u1VeByL7LoIW7J3ShdolqZTgwksDURIaZICoom6Pug14soc8
	GZCVh0eBOjpRR+LGiGva+KR3ZIfe+gXKSsCQMkDk9kLIXSNOBTagvoY/RCuKiE2qOVrxYkTexkz
	03AXDYEx5qOAG2uS8caJ1A5wRcQTI=
X-Gm-Gg: ATEYQzzVwwVJP7Gu9NA2aw8S1Zwr9tWyJq1gG6n7Az110HpT17fZRuCj66EVbF9dR0s
	AJ7/5PEIB1NWPgXThxmXuXNB1TtpegkdJ0znPNH3Z5iOBb5dfywxHnlEy95aAuohWpSMYhx0Xw2
	ke8Wp1i/b+5x1j4dHKcaKNw2HDA4byo2HZRAweEMRAyTiUcyc3yZoCk7RCNC4iQwzzgkR/rM7kp
	I5s
X-Received: by 2002:a53:858a:0:b0:646:7062:22ad with SMTP id 956f58d0204a3-64d1427cc45mr8678482d50.46.1773068993923;
        Mon, 09 Mar 2026 08:09:53 -0700 (PDT)
X-Received: by 2002:a53:858a:0:b0:646:7062:22ad with SMTP id
 956f58d0204a3-64d1427cc45mr8678430d50.46.1773068993292; Mon, 09 Mar 2026
 08:09:53 -0700 (PDT)
MIME-Version: 1.0
References: <20260226113233.3987674-1-usama.arif@linux.dev>
 <20260226113233.3987674-13-usama.arif@linux.dev> <CAA1CXcDyqPPwf_-W7B+PFQtL8HdoJGCEqVsVxq7DhOUB=L4PQA@mail.gmail.com>
 <6982e9fc-cc17-4d4f-b26e-83997c4bf070@linux.dev>
In-Reply-To: <6982e9fc-cc17-4d4f-b26e-83997c4bf070@linux.dev>
From: Nico Pache <npache@redhat.com>
Date: Mon, 9 Mar 2026 09:09:26 -0600
X-Gm-Features: AaiRm50M7EsyVTjUp3ZumpjEiav95f1tL1iFQKYgAgTcPXxEsX1_R8rjMYvu9Fs
Message-ID: <CAA1CXcCb6aZnjgtunEuwL380S-2re9N-AEjZUB+XO9G6gkrHQw@mail.gmail.com>
Subject: Re: [RFC v2 12/21] mm: thp: handle split failure in device migration
To: Usama Arif <usama.arif@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, david@kernel.org, lorenzo.stoakes@oracle.com, 
	willy@infradead.org, linux-mm@kvack.org, fvdl@google.com, hannes@cmpxchg.org, 
	riel@surriel.com, shakeel.butt@linux.dev, kas@kernel.org, baohua@kernel.org, 
	dev.jain@arm.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, 
	ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>, lance.yang@linux.dev, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com, maddy@linux.ibm.com, 
	mpe@ellerman.id.au, linuxppc-dev@lists.ozlabs.org, hca@linux.ibm.com, 
	gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com, 
	svens@linux.ibm.com, linux-s390@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Y8QpZv6G-_jDfyuOYN0Fk_SfwaCc-35mJua8rBPpQUk_1773068994
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: e7hhb9iuya9c1jxa11nx8tcruza8npdn
X-Rspam-User: 
X-Rspamd-Queue-Id: 60FFD40017
X-Rspamd-Server: rspam12
X-HE-Tag: 1773068996-517623
X-HE-Meta: U2FsdGVkX1/NF7sy86NM4K4vOCRD9paRYqqfjFJbaLeQc7kwYZBvVOvyaxdr6ja+StaY2KPIDhKaweWnhC4GMlAKiVRu8aqrvfziQGbcU0rOGUAjxYMTS/VVD+ovE5D3kCnP4rAPogBo3RY2/u4IFdRVdUjIDopX+7kZAUQnfcUgGSxuEcCXaFaTeGYXaE0f8Vc7e9SNkjizOoAts6Id/3GD0hkw3Fag+5b9mAGsNsxaZJP3vgEQZiSkXJ7VXXPNypQ2SVKiP0RKQJ7Ysx6lCGIOyRMVvCQx15ts1IA5WwCQlOdnT0HVxwvdY0X/eo+vb5ENFi4c+wjesyUXMKMtzAFBx1Z2VkwW8VjPjJl7IbktlNjoyZlgL9n1Qf8s7E5cVX564ssucubYqG4vq1pyVHZQ8WOdsWoC/WluP2qsdcZwBO1ZP1ttC3dDuviMaVqkQHfrJEhI/4AVL3/ZCd66dJvjQ6cnVrHn6RrSD52PvjQFJXxBwprw0hB9sMSTec8fAS0O97OuD0yRTIdj2q+CnSIA1Jv/yeBQp+Q1SzChiPv1ZknFWJRXWOMNx2sjRwYjSkSndxuy3ULBFXs2H8wqxVd7z0MZM2T8oG6Tzrc2MHh6NDS60GjhRZJvhbNI0vKz351weg3BZn8tw7Mr9hJyFFbgY/OZX02AFt/Svro4Af2AU/pYMVO/7eL4ybMYrrkoSs/cPiCAvfgdEsYcKRMqn0GytWve8vdR/yenYh59Eqe/4WcprwxORHnmZcn81OKmmy1U/D4Y/j6H6RV0JTjTl6UzzgSpKY6LDsHCFuBVHjhoqWbqSpGaNO5D4asb4fz4CS1SWvr5dbwNQ3/W6m2zfqdFu5ZKVPbV4vkk8MCie2v+W6YRtvs6bWYfSqLeuAQVmFnnmeNA5Yb7fN3iLk8aPTmjnB0zxck8nIWmf8ZmyLQ7kGxBhBJyK/pZeuszFbjHotspYZseF38dI1sI8He
 c/WC0a0I
 9q94L5K4QCo3k9PUcC6lEPuGaqiUsPEY9HthekqI+1ZhKs53l98zHnt1N9ck3loPnw61gYZLImp/Vw4CSYjbMccqhcJDh3aRVDy4JLBD/XkM24ChYy6GW9xZ30WiLVwXxy1+2aN89+pGExrxt7Bo3dj1BCUk1fguoY2kds14z9bsQzhFWdxV82j9XW8IZS9xPzcZqmhEe8kijv8am3ds/YoRu1AMBVZKbDHCXEMFy+5FJys846dnerNRMKTMK2JxrguFyUIr0lHJjYCIWzn9HlKObv//XVf4AyalBQGfEUoWXVjoS1PUuX4xYxE1JOG/Qnc37pPsbHar1ddWymzk4x9p+rRRokwVA2pvF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 5, 2026 at 9:55=E2=80=AFAM Usama Arif <usama.arif@linux.dev> wr=
ote:
>
>
>
> On 02/03/2026 21:20, Nico Pache wrote:
> > On Thu, Feb 26, 2026 at 4:34=E2=80=AFAM Usama Arif <usama.arif@linux.de=
v> wrote:
> >>
> >> Device memory migration has two call sites that split huge PMDs:
> >>
> >> migrate_vma_split_unmapped_folio():
> >>   Called from migrate_vma_pages() when migrating a PMD-mapped THP to a
> >>   destination that doesn't support compound pages.  It splits the PMD
> >>   then splits the folio via folio_split_unmapped().
> >>
> >>   If the PMD split fails, folio_split_unmapped() would operate on an
> >>   unsplit folio with inconsistent page table state.  Propagate -ENOMEM
> >>   to skip this page's migration. This is safe as folio_split_unmapped
> >>   failure would be propagated in a similar way.
> >>
> >> migrate_vma_insert_page():
> >>   Called from migrate_vma_pages() when inserting a page into a VMA
> >>   during migration back from device memory.  If a huge zero PMD exists
> >>   at the target address, it must be split before PTE insertion.
> >>
> >>   If the split fails, the subsequent pte_alloc() and set_pte_at() woul=
d
> >>   operate on a PMD slot still occupied by the huge zero entry.  Use
> >>   goto abort, consistent with other allocation failures in this functi=
on.
> >>
> >> Signed-off-by: Usama Arif <usama.arif@linux.dev>
> >> ---
> >>  mm/migrate_device.c | 16 ++++++++++++++--
> >>  1 file changed, 14 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> >> index 78c7acf024615..bc53e06fd9735 100644
> >> --- a/mm/migrate_device.c
> >> +++ b/mm/migrate_device.c
> >> @@ -909,7 +909,13 @@ static int migrate_vma_split_unmapped_folio(struc=
t migrate_vma *migrate,
> >>         int ret =3D 0;
> >>
> >>         folio_get(folio);
> >
> > Should we be concerned about this folio_get? Are we incrementing a
> > reference that was already held if we back out of the split?
> >
> > -- Nico
>
>
>
> Hi Nico,
>
> Thanks for pointing this out. It spun out to an entire investigation for =
me [1].

Hey Usama,

I'm sorry my question lead you down a rabbit hole but I'm glad you did
the proper investigation and found the correct answer :) Thanks for
looking into it and for clearing that up via a comment!

Cheers,
-- Nico

>
> Similar to [1], I inserted trace prints [2] and created a new __split_hug=
e_pmd2
> that always returns -ENOMEM. Without folio_put on error [3], we get a ref=
count of 2.
>
>        hmm-tests-129     [000] .l...     1.485514: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffb48827440e8000 dst=3Dffb48827440e8000 src=3D=3Dds=
t=3D1 refcount_src=3D2 mapcount_src=3D0 order_src=3D9 migrate=3D0 BEFORE re=
move_migration_ptes
>        hmm-tests-129     [000] .l...     1.485517: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffb48827440e8000 refcount=3D3 mapcount=3D1 AFTER re=
move_migration_ptes
>        hmm-tests-129     [000] .l...     1.485518: __migrate_device_final=
ize: FINALIZE[0]: src=3Dffb48827440e8000 refcount=3D2 AFTER folio_put(src)
>
>
> With folio_put on error [4], we get a refcount of 1.
>
>        hmm-tests-129     [001] .....     1.492216: __migrate_device_final=
ize: FINALIZE[0]: src=3Dfff7b8be840f0000 dst=3Dfff7b8be840f0000 src=3D=3Dds=
t=3D1 refcount_src=3D1 mapcount_src=3D0 order_src=3D9 migrate=3D0 BEFORE re=
move_migration_ptes
>        hmm-tests-129     [001] .....     1.492219: __migrate_device_final=
ize: FINALIZE[0]: src=3Dfff7b8be840f0000 refcount=3D2 mapcount=3D1 AFTER re=
move_migration_ptes
>        hmm-tests-129     [001] .....     1.492220: __migrate_device_final=
ize: FINALIZE[0]: src=3Dfff7b8be840f0000 refcount=3D1 AFTER folio_put(src)
>
>
> So we need folio_put for split_huge_pmd_address failure, but NOT for
> folio_split_unmapped.
>
>
> [1] https://lore.kernel.org/all/332c9e16-46c3-4e1c-898e-2cb0a87ba1fc@linu=
x.dev/
> [2] https://gist.github.com/uarif1/6abe4bedb85814e9be8d48a4fe742b41
> [3] https://gist.github.com/uarif1/f718af2113bc1a33484674b61b9dafcc
> [4] https://gist.github.com/uarif1/03c42f2549eaf2bc555e8b03e07a63c8
>


