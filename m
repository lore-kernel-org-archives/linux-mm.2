Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6CB5C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 12:56:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBBA56B00D7; Fri,  3 Jul 2026 08:56:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D45856B00D9; Fri,  3 Jul 2026 08:56:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0CA46B00DA; Fri,  3 Jul 2026 08:56:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91BFA6B00D7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 08:56:33 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 178E2400BD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:56:33 +0000 (UTC)
X-FDA: 84947464266.25.1C06043
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf10.hostedemail.com (Postfix) with ESMTP id AE56BC0007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 12:56:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RdePjsOQ;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783083391;
	b=BHxhB9ARUdN2aT75KVccqzndemqk+Y3GAiT7mF0BCauD8ARP3wnvqf9ZG9KuIO8vsOpiCh
	QWeUIcA9SYBKlqovNXvMcd/g3v8ygGp/tf68GhyEQJiDAxyEgl2+3U1A2GUkTq338XNpjE
	mBX7fzlyqwbjIb5uHjNroU0e1+heLac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783083391;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HED6HRnydnqiSVH4UAUTFWH58XzQx39lyeEfirFqz7M=;
	b=AC9ON22gaQRiCWwxqtoViZ8BVFeaVh5Fg/mZ/ktxrRI+ALHIVeEql9YUbjhtZipS0STQhu
	2iLoTINq4ozSL23D6OUW48J13ZQoEbLxDW6+5tx8SoG71T0ve6p7rOIEhtL8cQaqmxAaeJ
	8SWgXvk+qauYJ/oewQx0wxjLEUANgZQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RdePjsOQ;
	spf=pass (imf10.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1783083390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HED6HRnydnqiSVH4UAUTFWH58XzQx39lyeEfirFqz7M=;
	b=RdePjsOQhMu7qxfrFkRIpa7KvkDAyBpZ3nnLZjLIKe3lieU8DmbgxIW8Im2bCiCb5IUdzj
	atYTmdPzkVzFDcb5qXFWgMmmaYP28v6PRbygssuW9w9+mf85J8UVQejH8FAJfowqPRQmZa
	g2nPaYHrYMWv2VaMSrUrHgO43SjumEY=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-670-yup0SE71PoaIR31wynVt8A-1; Fri, 03 Jul 2026 08:56:26 -0400
X-MC-Unique: yup0SE71PoaIR31wynVt8A-1
X-Mimecast-MFC-AGG-ID: yup0SE71PoaIR31wynVt8A_1783083385
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-39accc98fffso3827131fa.0
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 05:56:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783083385; x=1783688185;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HED6HRnydnqiSVH4UAUTFWH58XzQx39lyeEfirFqz7M=;
        b=ml7xQ5UBqP086z6lQcWm0F4jKMOI/FQ94JNMSRdDLBvtu/sT3Al/Y5xci8x2VEUgDh
         CD6jhyCYRvOIvaY9C5LO28ZtWvOb7jg1kC69luhNBmaKZfQsx0SdJ34LYMwC6IzR/809
         i1OH3O8jekscpKgea9AXEVJBg6OaLZ4Rxe6fvuuibZ3DqRZIiSaJKMP4w9zSyDdUoczG
         IQ0ssMDenrFSpY53nnLkZFw2ejfCwbnUBo2CgQjNUyOKhpiHrvxb2owjV3GNZ7Uvb6kI
         w6FswzQtTAicvynPAqLrfWsNRXM6RHszMvn96deyikA4XuGdzaPN/9GJTlkX3PuDTlMx
         +v5w==
X-Forwarded-Encrypted: i=1; AHgh+Rr2J3bzLJz4EToEQUU6+VoH8jIzZI4rF8wn3hEI5lOeeKr/MZeTcKlKCn2RYumpOqzimpGJC41Mfg==@kvack.org
X-Gm-Message-State: AOJu0YyXT/47yL8XLL5czKxCJdZUgHa2oY1jLy8cQLGtKkGQWAI9qk7F
	z9OwqKbhuxELIC83z/8+uI9wAaYgp97xWwcNosC3/o9rBwNqatrQjUshW7XQqClZ8luDnVa9Es7
	xhyA9SfRukUXLfLdDZKazYIe1ORJH8q3WGiqCfpkLLsio2t1wAdbAymyvm9G7Qgt/RU3DoOkVG2
	Gqhhv4ljfQiYBfh5ZZz8NYFVQjWlc=
X-Gm-Gg: AfdE7cmrHyLVZqF4jus7ILgO0J0oW6BHnxpohUt8p19uPHyUjvxNj5Q6OPlAFss1iwO
	vXwQ3RJVU+ebth6ht00gBLNUseq6eoCtTI1ceQDey2U65Cy0z1Z5uewo0K8qbRRGuiGmTj02xVz
	7Dg502Ekq0Z+L4IB0H0Klz+GJc77OWqwxHEpP3OqEj4u2MLTWkOQWGuxbhd7CwF3LG
X-Received: by 2002:a2e:bd16:0:b0:39a:e7f6:49aa with SMTP id 38308e7fff4ca-39b36f0dc25mr21175001fa.2.1783083385227;
        Fri, 03 Jul 2026 05:56:25 -0700 (PDT)
X-Received: by 2002:a2e:bd16:0:b0:39a:e7f6:49aa with SMTP id
 38308e7fff4ca-39b36f0dc25mr21174701fa.2.1783083384715; Fri, 03 Jul 2026
 05:56:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260702172548.37075-1-npache@redhat.com> <20260702172548.37075-3-npache@redhat.com>
 <4c67ac7b-e021-4e4c-ae5c-07bfc0fba9c6@linux.alibaba.com>
In-Reply-To: <4c67ac7b-e021-4e4c-ae5c-07bfc0fba9c6@linux.alibaba.com>
From: Nico Pache <npache@redhat.com>
Date: Fri, 3 Jul 2026 06:57:34 -0600
X-Gm-Features: AVVi8CfzTBD7feuDGQNv3STuJ_PVTWfd_G02diIzr1_4eSFOGvY8Pww9hOYi6es
Message-ID: <CAA1CXcC561g+nmAjB9Muvi4rsOYPgbud5USmJnxivV0RDYU=Vg@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm/migrate: exclude hugetlb folios from
 MTHP_STAT_NR_ANON accounting
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Barry Song <baohua@kernel.org>, David Hildenbrand <david@kernel.org>, linux-cxl@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, ljs@kernel.org, 
	willy@infradead.org, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eMv1B5NNBHhe10U29mIKAZ8WXIV5PjbViUIRba2eA_c_1783083385
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: AE56BC0007
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: 4bjrcrcgifq7psntdsrxwyqqw4ayhd7e
X-HE-Tag: 1783083390-309979
X-HE-Meta: U2FsdGVkX1+XKSwn656/Y1NgnwDKCDXkYSZ5CAL1RngO9ORKgsjOv9bJ65UKjM0LbzHEQYse6P63GxVhhRRyAMEPGLvP8Y2RKuDaekOUvB9jENb4gINpTR7hvVE1bkr4Y51Vl76d/Vm25TBVTiYT7Xxitf8aMLDvjhkH9+CqW0A+GGJv+ytYuq9ps6d4Yrx6Klx5l0oMrkeOeR/UdV91oSkKRtyMQreq+YTzqUpNSeF4wd5ysPC1kkAJG1V33HMOhKW+ayL1Zs3pSBswyxehsh4Ia9BprpQQab9Ygls9DSb8cXPIffjfAIGWkvXdnm5yFWIT/0CQNMoOAY7dO33pIg0D5o92mMU3ytc0n8A3lIaxfIFuMkegYjE8mey0nZoyL5GPQbeuENSlwt6/EEfz7EUWQ74FpT3PXDwLoIdqbuh2Cu5sTjPawr80My/IfsB7jsD/6xs98No+khF1bMUzFvwIEWtYymLwKOp0AFD/RBuPECEldeFpKG2F8mGo7g8BkWyWXvvwC3uCDMwqPDNZTm52blS7dKL+PCVQjSb6SikYxU8yxCcz225uisV1y9OmAMT0zyTKhuy5Kq6Fz8vDUxdOzr5CzYN3UTAqIWZU9sXlseSi6eCXaFXX1748O0yAF4JYtOzBPmH+nUVJbyyy01HGonmL6G/aaWeLDjDDzeWYwQimG3XfJlZl/Rlav10L+udSh/UcBhA6u5gLLAqx3PfomCCAI8DY7kG5hTlebIGYUuBWFVi76Lovj87vwtDIxpJXVuQBu2ZsoLChk0J9uqt7jcEJw6fPBOjPbghNhHQo9opMB0ZMPBnXlmoNlOMAu6FIxoOXhjCwmzKWZkBqrZDjF7RM9maw6Hb1fCKXsBD3c1SwcCgsl8vHF7K3tEpPQBvsht3bKFiGmkAsoCgIQHhJGl3ktRDPDRWX7lwLiXgm+puMFGEXptkkS8DQZdObzUikytcN88olNC3UXFQ
 HLE3dKJS
 mFr7Yq8WVctqi57q0STe1qDQEqfNr38nDOTwbtD6Fv60PVlfWHiVHmVtQjzfzU/NujKEvSUY3inDRlc4nh6SVFIrAttKM9slpCke0Fabymm0gaZmQFJjqHlyYLloE/kajwH8EOb0skIXZQUDhCB7iyCpOTaDag75P5I/ktCP+nBWE8TXOiw6JQgdQqA1nSWXlfsalv6vY7TtGqJJZoPm12+8CEY4kuJRPV5WabTQabNv6BaDJogY2h6O8so1b5qRRRl0H5nfBKJRO3kiysKrOhQa6vDwCbxa0UHfqJYGTAStdshLqMss5L10w93u0xu0UIubP0myUIGp0rkLqBeg0zkZKwRkB9ilJXE8BJ6goKKLgEBvlwH8DxLGD6GlM+2DXeHa/UOYaiSYxmQO6XWmLvu6x4A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 2, 2026 at 9:10=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 7/3/26 1:25 AM, Nico Pache wrote:
> > __folio_migrate_mapping() increments MTHP_STAT_NR_ANON for the
> > destination folio when `folio_test_anon(folio) && folio_test_large(foli=
o)`
> > is true. However, hugetlb folios satisfy both conditions despite having=
 a
> > completely separate accounting system; they use hugetlb_add_anon_rmap()
> > which does not touch mTHP stats, and their free path also bypasses the
> > mTHP decrement in __free_pages_prepare().
> >
> > This causes MTHP_STAT_NR_ANON to be incremented on each hugetlb
> > migration without a corresponding decrement, permanently inflating the
> > nr_anon counter.
> >
> > Add a !folio_test_hugetlb() check to both places in
> > __folio_migrate_mapping() so that only actual mTHP folios are counted.
> >
> > Fixes: 5d65c8d758f2 ("mm: count the number of anonymous THPs per size")
> > Co-developed-by: David Hildenbrand <david@kernel.org>
> > Signed-off-by: David Hildenbrand <david@kernel.org>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >   mm/migrate.c | 6 ++++--
> >   1 file changed, 4 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/migrate.c b/mm/migrate.c
> > index d9b23909d716..9fd50ea25d2d 100644
> > --- a/mm/migrate.c
> > +++ b/mm/migrate.c
> > @@ -590,7 +590,8 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
> >               /* No turning back from here */
> >               newfolio->index =3D folio->index;
> >               newfolio->mapping =3D folio->mapping;
> > -             if (folio_test_anon(folio) && folio_test_large(folio))
> > +             if (folio_test_anon(folio) && folio_test_large(folio) &&
> > +                 !folio_test_hugetlb(folio))
> >                       mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_AN=
ON, 1);
>
> Yes, anonymous hugetlb mappings can reach here, so this check looks
> reasonable to me.
>
> >               if (folio_test_swapbacked(folio))
> >                       __folio_set_swapbacked(newfolio);
> > @@ -623,7 +624,8 @@ static int __folio_migrate_mapping(struct address_s=
pace *mapping,
> >        */
> >       newfolio->index =3D folio->index;
> >       newfolio->mapping =3D folio->mapping;
> > -     if (folio_test_anon(folio) && folio_test_large(folio))
> > +     if (folio_test_anon(folio) && folio_test_large(folio) &&
> > +         !folio_test_hugetlb(folio))
>
> If the hugetlb folio has a non-NULL mapping (i.e., it's a shared
> mapping), we should migrate it via
> hugetlbfs_migrate_folio()->migrate_huge_page_move_mapping(). In other
> words, shared hugetlb mappings should not reach this path, so this
> hugetlb check can be dropped. Or am I missing something?

I double checked (and others seem to have confirmed), you are correct;
these hugetlb pages shouldn't be reachable here.

Ill drop this hunk and retest :)

Thank you,
-- Nico

>
> >               mod_mthp_stat(folio_order(folio), MTHP_STAT_NR_ANON, 1);
> >       folio_ref_add(newfolio, nr); /* add cache reference */
> >       if (folio_test_swapbacked(folio))
>


