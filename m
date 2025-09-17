Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0F764CA0EE8
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 03:53:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D9378E0006; Tue, 16 Sep 2025 23:53:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B08F8E0001; Tue, 16 Sep 2025 23:53:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C61B8E0006; Tue, 16 Sep 2025 23:53:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0A23F8E0001
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 23:53:09 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A96AA1DE30D
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:53:08 +0000 (UTC)
X-FDA: 83897371656.09.284D00D
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf17.hostedemail.com (Postfix) with ESMTP id D63B240004
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 03:53:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OxxU9rSk;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758081186;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=br8Hpn4kqiDUWzOrzTfPA0W71LUsxF/Q6MRy1/vyP8s=;
	b=LZSikeqiZ+Agm9xFMsW+y1puv00Wjul1IYxTbMMJOZgiTlL5m7xWozyTFRk8U8tMwjMMA/
	o6lrcJ6CdTxocLnll48H1DCagpY34c+rcTdBI5/S5UTwbY4UDD2X1KKtvkopeqXVaoQXd0
	S/f1WuNuplLxdOLta1NlfNrJlbusplk=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=OxxU9rSk;
	spf=pass (imf17.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758081187; a=rsa-sha256;
	cv=none;
	b=Q7Zci2iLpirrPYMm2IH5caD6ONprnsEGTq1euK6WXKgjK6EhQP19yn+2581G+zHz3ooS/z
	UZ5NCowV7N2Pc4qXqzWlfTYp2SQt/IAY5qXbEKdyqvINtib5AtJdXxIChW1/k/qny8qiQM
	OymruOjcCREjsU35L2xexRu8Hmto/2Q=
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b07e081d852so677329566b.2
        for <linux-mm@kvack.org>; Tue, 16 Sep 2025 20:53:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758081185; x=1758685985; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=br8Hpn4kqiDUWzOrzTfPA0W71LUsxF/Q6MRy1/vyP8s=;
        b=OxxU9rSkmEWFag/EO1TCXAnKXN0m9/WimfjJ+MIVck+COY791xBlEVGj2G0gsi7wNV
         cxeODpbqLkFwzjMdvITwXrqxSisf1T9xuiFe1WoG7L54gjYge4HDMtIuITrNb21Lsk0U
         jyPSDrL7Y/Y3PMg3pnlZZYj/R1Pa/jd5UTWex7itC4TggMhacpjl/ybgp3h7/iYFtesd
         1lRE0bGaLje/sf4RPMCxNoqcF32t8NK/R9z4FPWQDbKYa/SfWQ8Q31J7B02B1c8Xz94C
         I1jykABoh0DTzSsjtGW3uLlHJ9kLZWOi+gwrPmWmcFPBqAXHsUMaJd/Pklsn1Olaap+p
         iZTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758081185; x=1758685985;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=br8Hpn4kqiDUWzOrzTfPA0W71LUsxF/Q6MRy1/vyP8s=;
        b=OZPXMmyEzodPcdAvrYU16AWkf01Yv9OvLngBKLy6/0jkgGRIjRN9fyf9d8D1FI1vWb
         wzZc0N7NSwJZh5njREBLx5kpKBHYVIp16sJ7Z8BMUAo3i04OZqM0oJgoDAMF0qIrXov3
         ty1j+FGqNKc8+noslo3Fsebwk3sq1p9xL+NlaePD6nY9OS4gtHiChce2veoMm88NSMcV
         ZOjM9o8GwhW4GehZYbSb9xfMLQLS1UGjByqyjtIKYdc27jpkWYR6QeMvxUx11CjVm3nW
         f1kuJ5uWBLv9iiqRmo7BKB3oOQJCs5K3sMa0lNxsP6Y5RXshfoGPBSZY38RUjcFQfUdT
         cfRg==
X-Gm-Message-State: AOJu0Yx0ZUhDGKQlnLuEOu/VidARfi8Z0HhzxRatL2/78iBBluOwGcKx
	nWEgg1sbaGcz3fuZl3WYKqJeA7csZGCLPiD3IMh+7JaGzc846Ewdn+2HWek1PSt8tGLIx3ZoFzj
	Sv6ql4mOROknm/KEVEBcNMU7YUiEufxI=
X-Gm-Gg: ASbGnctgOqpCs4K9X3qX0Ejw3EJMJoyK2NG5vJaLGP1zlUIU42xpZNbKPoHWIgd1XbZ
	C883rsV9cCb4f2ApSZUhjqH0ePxxSTeVQV/WfeVpLXJBe509ggxBaW8vWoiawE+EwXZoRdTHfH4
	TuYO5g4SLvgQwBqBYLi5yAyXAefTbhkIZ7KRDVvpWfw2ab+xXFthTGs/FhGijjcyycwczRC94oI
	PY5SvgdWAk=
X-Google-Smtp-Source: AGHT+IFQbp1h2CTc9fOnSy7mCP+U4w9I3xAO5gikNl3D24j7X3s4e8n70fnOQLRYpTtZJci4soxx7luTGcJEEFKaECc=
X-Received: by 2002:a17:907:3e1f:b0:b04:830f:822d with SMTP id
 a640c23a62f3a-b1bb9b212c7mr83299166b.63.1758081185015; Tue, 16 Sep 2025
 20:53:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250916160100.31545-1-ryncsn@gmail.com> <20250916160100.31545-16-ryncsn@gmail.com>
 <CAGsJ_4yrDFAe-3sMj1K2JeWrqNXCBvYvULY06b6B3ogSYjqasg@mail.gmail.com>
In-Reply-To: <CAGsJ_4yrDFAe-3sMj1K2JeWrqNXCBvYvULY06b6B3ogSYjqasg@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 17 Sep 2025 11:52:28 +0800
X-Gm-Features: AS18NWCU5i3HJlEO-iFWg0kNjEVA2stpm803avLHZ3n6QtGZVqQEufTNOeFsfmg
Message-ID: <CAMgjq7AJ1=ji4iw03JmdN07MpY8V0CFdtUHpF58mTnSjGf=rGA@mail.gmail.com>
Subject: Re: [PATCH v4 15/15] mm, swap: use a single page for swap table when
 the size fits
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: D63B240004
X-Rspamd-Server: rspam05
X-Stat-Signature: xwx44mdk45kj7npr6rfmz3ch4mfqehdp
X-Rspam-User: 
X-HE-Tag: 1758081186-54288
X-HE-Meta: U2FsdGVkX1/IYRZO3xSkOrWgMKXX7WhwrwgtAsu6JPp51GBpp9E1Bioso+zfpvVnffvAblpoIiVr1HCo2yCIQP+DgcvPNI++H2jVc7FocoHc7leYwY9F+A1vZtxh6kcR2uRu2QG3RhD4jMgqkl7ezg6C4mw/yMJYX1c4vr9uhsLLWc8Hayam0u8es5wt9632449uq0If0I6OFCB1jfYPKI81VJvZLgXknaOuAt+gxk4oSkqFApE7cp1zeoWbscTqEpZoy9ZBcj6XowxrVeXX7FxNJLBxckNP2dOy7cQvIIZB/gNBwUqWa4UOOwkFjPjEasYIkas/D5wD6NCIifLMU5J3zrNvSh7qPqQRYU0GfOtfrraq1l/w8pIsxSfoiMhB0wWDkGGkH4xjyD+tpHfSnDXMuYjPivwvtcreeregUG6MOAdi9j1AdtVKl0kCqY9kgSiIdjp42d92G1bk58CDDZoIC0L+aHz4MU0prDTudsoffNUQgQOycHFCI9ESieE7cord24k3+9/XBHBAa71hhbIfC7zhziajlYMwm74ARxjfb6bSh98qs4VAXB2L/rdD+E3InD0/WDtnKMbym/eDWWvsdensyQfe/LN9cGVQC1Fca5l2FP7AwNDVnO48/OjzzA1GcXHIIg9bbOC/4CbpiSazCSlcvNkbFbYAwyo2UvjTXdppN3cjMHUhlzRVboGCnjC6SsybkdJgyRXFJhBSsWHnTBCZuH3MDqUb0ft8t27rjibqWg0U7Be/613GTjS000l4CvPEOUWxbJkQaYvEe459fbPLw5uMCnL8GLXTi50mhxSSIpxvwMPDm5UOSV1vvshZRm3Y2Kz9BwfB6VOce5v3oRCbdiFMc4LU9MPJH5mVzSQpTuqc2K2YgKF2hey7QvajxQbWy1uqpbY0SJM/p3J2sZ2tx6srvoS6O/cirgvEJDLcwuif7A+r6+zXvzyXgCGmNIXeStahMmSLFBs
 pp1kHw0k
 NbBznEHUUHUJapHwEpadi1OKHzoa8mBkjsqYEY55KvFfx4lSsnryqTYy8etJ/eN8vYB5Hjg97/YbXun379McIhNuxlb970/zSQYhs4kstNJkk/LPx9eGnNzDOR0EdXl5dbPjK7DzDpN92bVcTz3ChCL03ch3OYoKs8yIScTq9zv9W0I4Yked8kai13TgEqO3W0AfHdqzohT/g5dxSJE83ntrFLXJtCVHA0zBK3f6TFKzNdwZW+tFDZeyP5ox1D+wLTN0nDyhzPtjf99YljBJ/ezihZBwG2GJUnPLrQT0gGEdh4kQkWNxXdnq1P4JvQ7EPWOT8IIvJEiuwWS7Y1/Uxdk7Rsxyn1Udr8kV5NSwgoC/DxxId0nlM0LhKEDXNFfhy7R0lPRnTeOnP04R98UYY0EBEHco39zndmKMMLqqkIiuYCgFxfJEOcPNe+ISz+RzlmOCkZ90o2dwoADU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 6:31=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Wed, Sep 17, 2025 at 12:02=E2=80=AFAM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > We have a cluster size of 512 slots. Each slot consumes 8 bytes in swap
> > table so the swap table size of each cluster is exactly one page (4K).
> >
> > If that condition is true, allocate one page direct and disable the sla=
b
> > cache to reduce the memory usage of swap table and avoid fragmentation.
> >
> > Co-developed-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Chris Li <chrisl@kernel.org>
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > Acked-by: Chris Li <chrisl@kernel.org>
>
> looks good to me, with just a minor nit noted below.
>
> Reviewed-by: Barry Song <baohua@kernel.org>

Thanks

>
> > ---
> > +static void swap_table_free(struct swap_table *table)
> > +{
> > +       if (!SWP_TABLE_USE_PAGE) {
> > +               kmem_cache_free(swap_table_cachep, table);
> > +               return;
> > +       }
> > +
> > +       call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
> > +                swap_table_free_folio_rcu_cb);
> > +}
>
> Can=E2=80=99t it simply be:
> virt_to_page(table)->rcu_head ?

I'm not sure if we prefer folios when possible?

Either way is fine, they are identical for this use case.

> Thanks
> Barry

