Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2744AEA7943
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 21:40:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85AEA6B0005; Wed,  4 Feb 2026 16:40:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808D96B0088; Wed,  4 Feb 2026 16:40:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DDCF6B008A; Wed,  4 Feb 2026 16:40:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5A5B26B0005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 16:40:07 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19DEE8AF25
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:40:07 +0000 (UTC)
X-FDA: 84408092454.08.5DD4B43
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf19.hostedemail.com (Postfix) with ESMTP id 79C7D1A000C
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 21:40:04 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H+rq3QUq;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770241204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u/RRR9VLmVAaUDYnt9wwOlgiAGyPDV2RrmGH4fySXkM=;
	b=tU4orTsCspgF2hFUXaPKXqzNrNQ9go86a9NbluYUKEK3DbQXwSwxovA1/lukIArgXZUZ+e
	ouS+y1smCkyLRwptMRYMY8JiJX0WX+nH+FHroa6b2wGnosOT+eg9t006nkUhoE+/QMeS7+
	wZ2l+5tvkpMYZijkM6pPvKiYLYek43E=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770241204; a=rsa-sha256;
	cv=none;
	b=kpuloA9UgE73mx4mGsLwfrNuhcoa9vRyfAA65Yye57+QJ5qx9PeTODIAyREAnascUJw8y6
	joodM5BXGT7PdskkBAb8XtEHilEhzIfmYw9zgGlMiF0it+czC/ogJRrylW5RenICSYOk1r
	LW9xRvBF6W4CO4v2q3vUtxRFq2lQfYE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=H+rq3QUq;
	spf=pass (imf19.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770241203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u/RRR9VLmVAaUDYnt9wwOlgiAGyPDV2RrmGH4fySXkM=;
	b=H+rq3QUq7yFQKzoOoXgxlk1HrXIqMYFuJUol+k9c//HPvef+VsnHKa5FQC9sIdIjEtAUjW
	9nsQoYFFt3n6p6lddTSRIWE3KnUc8jGc9I8czTpkq9qJW90oJUEYQ/tjCZRP976WgoHQtJ
	1T8h0hTAalB5V7geQUsOO6sMtEAKXp4=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-564-kR__b2ryNmat2VAXwciZgQ-1; Wed, 04 Feb 2026 16:40:02 -0500
X-MC-Unique: kR__b2ryNmat2VAXwciZgQ-1
X-Mimecast-MFC-AGG-ID: kR__b2ryNmat2VAXwciZgQ_1770241202
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-794ae9fc4dfso3646097b3.0
        for <linux-mm@kvack.org>; Wed, 04 Feb 2026 13:40:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770241202; x=1770846002;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=u/RRR9VLmVAaUDYnt9wwOlgiAGyPDV2RrmGH4fySXkM=;
        b=UQpSYALSx/PXy/P5yGQi9X3OF3cY0cCRiLFvY934LwlkirxwZsqFt3oys9bfItDmhn
         tPw01u8AsiHpzkJAhZLFll3fGZ5bkujcYxhz8pZWvFnxYctMVH7rCTt9U/Bul1qrZCPS
         ZpgaLkyotD8bTGpJjoc9ca8QWWKKxNBGNagPHgRaztJEf2myJ9qB5ZK3ztTJgQZzZcU7
         i4vYenzBxa0Cn7J4clW65v703GyVbVaOhYSLiYTxJ5ST5J5Y2DBQyZ1bg+1fSnTyYadh
         Hw2YL0sa75ELFLke5NnOehtHlZRCxOVr8RpGXdsL8DotE/Xq1on3FHg3WW0uIMZV1KJy
         m7hg==
X-Gm-Message-State: AOJu0YzbCAi6U7XHM+FbheM5OZtDrMLF2hTujiwJ5Cy88wbJMmOYt9UB
	QpJjAm6TBxk1kLVhPeLCEnghRHWkFg94jmYXsktHeL7sYTdFPCRgLrJFDnTVDsHNNTLI4By4iKE
	TEBCojY7/QI5D1/wptkpdXokHwmcFOGK1PbVtit53Z2/gAR945WEseHY315M5YKkpwC2Mv0CnD7
	zGJHC88dYKFF3JUjNJ/Kn5XgCgYY4=
X-Gm-Gg: AZuq6aJ8IaYRlIFAHLvOdKtUsCeHRSuCzRhQs7n45VrsPZFF0cgI+IH9LvDQ6zc0/sj
	fYbMmf9ad6ToHOeW8/rxz91YpUoY5daOWb8Ot6XVQimfOPe8cXb3w0AKxeM1A0gSBrob3GYMZKI
	Ng6wpQnttDC/U9mZ380zrvmwpAiWmp3SNM1fn7D4dalW124Zxgk+wb4xjpjyv7Pn/e
X-Received: by 2002:a05:690c:e3cb:b0:794:eeba:55af with SMTP id 00721157ae682-794fe763e45mr43273327b3.39.1770241202033;
        Wed, 04 Feb 2026 13:40:02 -0800 (PST)
X-Received: by 2002:a05:690c:e3cb:b0:794:eeba:55af with SMTP id
 00721157ae682-794fe763e45mr43273167b3.39.1770241201601; Wed, 04 Feb 2026
 13:40:01 -0800 (PST)
MIME-Version: 1.0
References: <20260122192841.128719-1-npache@redhat.com> <20260122192841.128719-8-npache@redhat.com>
 <db10946c-9743-49e0-a845-7f53a60778a6@lucifer.local>
In-Reply-To: <db10946c-9743-49e0-a845-7f53a60778a6@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 4 Feb 2026 14:39:35 -0700
X-Gm-Features: AZwV_QiWF5a0ic6AE73ER09Zi2Q0iEGOziUo-C9Qoix8T3UNqNr91IEvUAcICs0
Message-ID: <CAA1CXcAEc4McCq5iCeF69-Kc6R-5Sxk9-+QrkW1Ht+00ACJjfg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v14 07/16] khugepaged: introduce
 collapse_max_ptes_none helper function
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	akpm@linux-foundation.org, david@kernel.org, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, corbet@lwn.net, 
	rostedt@goodmis.org, mhiramat@kernel.org, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com, 
	apopple@nvidia.com, jannh@google.com, pfalcato@suse.de, jackmanb@google.com, 
	hannes@cmpxchg.org, willy@infradead.org, peterx@redhat.com, 
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com, 
	vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com, 
	yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com, 
	raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com, 
	tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, 
	cl@gentwo.org, jglisse@google.com, zokeefe@google.com, rientjes@google.com, 
	rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9eVRGs_8tFUXXsb8qNa10g2DfLKa_eHFmyTTNDnFJz0_1770241202
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 79C7D1A000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: xxq3ztqt6qk63sdtmqbcf1y8g1rbx1c9
X-HE-Tag: 1770241204-652206
X-HE-Meta: U2FsdGVkX1+RfaKw6YqQsj+7B8uPLcPIYO/yp+ys/Pgxy2ZSPb/3jMR84BLZ6CNCGJeMN1saPZklE1M5URutR9uWCs7AweFxtMqXSPi7uQnFo72vSWS6iUeNgH/4jUQlTs9P0Yj0OZuh5+40GFk/itnibKC5sfRSjwMWladP0xzeiJSWaGm8J6VwWAaJzqCtFO0lLkeFBe84uhy0IYPb0TpiFtMFcH9j7SKaQtfcnq9acf/Ya2fIfJsFLkoz6AGRLWtn+Rypthy269NGNw6uHZeIGJFYit1hPm90JI8WQ3ml4DlwR44QXHJ8EWerDBlaLR3G1r9lJMEfPzTSJxyo4ZzkvokRJpVJ7AX9YFp7jV5Hv1EGNkxL/iWZjrnN5LLv35ZzsRnC+R2DP6lGgot6mSQUtnxfup4mOlS0jpvlA7OMdnT3nEr5YJfflTsUwnrh7IXOnnuYRkILMRgDNlIN9g4j1cCSz8LVMRtms9vab66Rb5wb7ru4H2IgYIFdgcTEj+n48pOunpi6js9DWN+qtm3TJ9isRseIEjImGivzqMhDVntFArfPX6e2Zymn9hWGIWJffjLwufctOJK+rXoT1nb0ErSoy2WfTZ5+FtUddo1aAcLGYO8pLWlXPf1dZupR/M0eUjmA+csl43/Qy9KxyBhNxOaO7FiTtaz7Xtto5x8PJP0UoD3veqhZSxHKTunYQaF69U+YWmvRgIV1/EukmuMjMGp8TUEx43/xacaabuOXnJ4rwAjDW2DyjFmH3uvQF1cPOkWWcW5CUQYN26HPWJYnO9uzK0GzLt+Drv5AFHNzJhRAhsVp7Hvj8YNZjSxtJyQs7JHXp7izZjktqdh8/WHoQFQzrKL23lHu/ZRkmmOv4kVnhmDB0RAol8kmgf3z5K7PuT+tqAuJgzPwxlz3y03cy6UiuHtNidkoVTFAsdL2r1CQwih5fcsft4VVhhAcvSronYp7zs9E0ypUlmR
 NYyfKe6w
 69Lf2r7Qq6bEZvF2Jwy++/BTFcHBMuU9crqy7NxqmrElyYMemnERbUIEtuKx60fWBHFybtBDvfmAwDao3+XeBKSo7MRR5NCX4Beo4d8ik/ehzM91vmeHxOgDKVzvIsX8wm0YsJmD0laB1YvP992v2bxkciLM1MwYiwgBSjMn2iw/jjifGV6X9NI/RsD2M69mnsn50O9xd3NpyDT961enrc3iBokHS7hLEvTcCAfgIfE5SzwiMOYQCECO1Ww8t+sHdFshVjvQkVKqbkTiEkVA718PNIctR6spPv4pFZ0w7HR4FBsxaxVtUDhFhAQFLDw3In8RT758dLbIEPTImvRS7EGfsFy7BzjrtJ6Oa5prS8hAW0PgEhqBxmFdMqrK2Y9RYbzdc/aEuVnCafZV5kIt6rxTq3UhYn6u5yj1UCosVKOPdjdzBJ+QGk/EIGzE4r1nZnosadKGS6JcH7aXspytH2jmPdITdZWFUAvZx1knmnDIXUHg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 3, 2026 at 5:09=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Thu, Jan 22, 2026 at 12:28:32PM -0700, Nico Pache wrote:
> > The current mechanism for determining mTHP collapse scales the
> > khugepaged_max_ptes_none value based on the target order. This
> > introduces an undesirable feedback loop, or "creep", when max_ptes_none
> > is set to a value greater than HPAGE_PMD_NR / 2.
> >
> > With this configuration, a successful collapse to order N will populate
> > enough pages to satisfy the collapse condition on order N+1 on the next
> > scan. This leads to unnecessary work and memory churn.
> >
> > To fix this issue introduce a helper function that will limit mTHP
> > collapse support to two max_ptes_none values, 0 and HPAGE_PMD_NR - 1.
> > This effectively supports two modes:
> >
> > - max_ptes_none=3D0: never introduce new none-pages for mTHP collapse.
> > - max_ptes_none=3D511 (on 4k pagesz): Always collapse to the highest
> >   available mTHP order.
> >
> > This removes the possiblilty of "creep", while not modifying any uAPI
> > expectations. A warning will be emitted if any non-supported
> > max_ptes_none value is configured with mTHP enabled.
> >
> > The limits can be ignored by passing full_scan=3Dtrue, this is useful f=
or
> > madvise_collapse (which ignores limits), or in the case of
> > collapse_scan_pmd(), allows the full PMD to be scanned when mTHP
> > collapse is available.
>
> Thanks, great commit msg!
>
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
>
> This LGTM in terms of logic, some nits below, with those addressed feel
> free to add:
>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>

Thanks :)

>
> Cheers, Lorenzo
>
> > ---
> >  mm/khugepaged.c | 43 ++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 42 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 0f68902edd9a..9b7e05827749 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -460,6 +460,44 @@ void __khugepaged_enter(struct mm_struct *mm)
> >               wake_up_interruptible(&khugepaged_wait);
> >  }
> >
> > +/**
> > + * collapse_max_ptes_none - Calculate maximum allowed empty PTEs for c=
ollapse
> > + * @order: The folio order being collapsed to
> > + * @full_scan: Whether this is a full scan (ignore limits)
> > + *
> > + * For madvise-triggered collapses (full_scan=3Dtrue), all limits are =
bypassed
> > + * and allow up to HPAGE_PMD_NR - 1 empty PTEs.
> > + *
> > + * For PMD-sized collapses (order =3D=3D HPAGE_PMD_ORDER), use the con=
figured
> > + * khugepaged_max_ptes_none value.
> > + *
> > + * For mTHP collapses, we currently only support khugepaged_max_pte_no=
ne values
> > + * of 0 or (HPAGE_PMD_NR - 1). Any other value will emit a warning and=
 no mTHP
> > + * collapse will be attempted
> > + *
> > + * Return: Maximum number of empty PTEs allowed for the collapse opera=
tion
> > + */
> > +static unsigned int collapse_max_ptes_none(unsigned int order, bool fu=
ll_scan)
> > +{
> > +     /* ignore max_ptes_none limits */
> > +     if (full_scan)
> > +             return HPAGE_PMD_NR - 1;
>
> I wonder if, given we are effectively doing:
>
>         const unsigned int nr_pages =3D collapse_max_ptes_none(order, /*f=
ull_scan=3D*/true);
>
>         ...
>
>         foo(nr_pages);
>
> In places where we ignore limits, whether we would be better off putting
> HPAGE_PMD_NR - 1 into a define and just using that in these cases, like:
>
> #define COLLAPSE_MAX_PTES_LIM (HPAGE_PMD_NR - 1)
>
> Then instead doing:
>
>         foo(COLLAPSE_MAX_PTES_LIM);
>
> ?
>
> Seems somewhat silly to pass in a boolean that makes it return a set valu=
e in
> cases where you know that should be the case at the outset.
>
> > +
> > +     if (is_pmd_order(order))
> > +             return khugepaged_max_ptes_none;
> > +
> > +     /* Zero/non-present collapse disabled. */
> > +     if (!khugepaged_max_ptes_none)
> > +             return 0;
> > +
> > +     if (khugepaged_max_ptes_none =3D=3D HPAGE_PMD_NR - 1)
>
> Having a define for HPAGE_PMD_NR - 1 would also be handy here...
>
> > +             return (1 << order) - 1;
> > +
> > +     pr_warn_once("mTHP collapse only supports max_ptes_none values of=
 0 or %d\n",
> > +                   HPAGE_PMD_NR - 1);
>
> ...and here.
>
> Also a MICRO nit here - the function returns unsigned int and thus we
> express PTEs in this unit, so maybe use %u rather than %d?
>
> > +     return -EINVAL;
> > +}
>
> Logic of this function looks correct though!
>
> > +
> >  void khugepaged_enter_vma(struct vm_area_struct *vma,
> >                         vm_flags_t vm_flags)
> >  {
> > @@ -548,7 +586,10 @@ static enum scan_result __collapse_huge_page_isola=
te(struct vm_area_struct *vma,
> >       int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> >       enum scan_result result =3D SCAN_FAIL;
> >       const unsigned long nr_pages =3D 1UL << order;
> > -     int max_ptes_none =3D khugepaged_max_ptes_none >> (HPAGE_PMD_ORDE=
R - order);
> > +     int max_ptes_none =3D collapse_max_ptes_none(order, !cc->is_khuge=
paged);
>
> Yeah, the !cc->is_khugepaged is a bit gross here, so as per the above, ma=
ybe do:

Ok sounds good! I'll make the recommended changes.

Thanks!

-- Nico

>
>         int max_ptes_none;
>
>         if (cc->is_khugepaged)
>                 max_ptes_none =3D collapse_max_ptes_none(order);
>         else    /* MADV_COLLAPSE is not limited. */
>                 max_ptes_none =3D COLLAPSE_MAX_PTES_LIM;
>
> > +
> > +     if (max_ptes_none =3D=3D -EINVAL)
> > +             return result;
> >
> >       for (_pte =3D pte; _pte < pte + nr_pages;
> >            _pte++, addr +=3D PAGE_SIZE) {
> > --
> > 2.52.0
> >
>


