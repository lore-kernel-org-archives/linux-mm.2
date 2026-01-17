Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3E38D4A5F5
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 04:27:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5F69B6B0005; Fri, 16 Jan 2026 23:27:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A4386B0088; Fri, 16 Jan 2026 23:27:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485626B0089; Fri, 16 Jan 2026 23:27:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 362E96B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 23:27:48 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AA1191A030D
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:27:47 +0000 (UTC)
X-FDA: 84340172574.02.52A345D
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 97582A000B
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 04:27:45 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PTV0QSip;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768624065;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fU+HEJ2yFiduc9HntpiFz72CvGQz3C3hryoeWDq7fzA=;
	b=Z2ml4J00eXnZIMqTn+5enqMo+TXKyoee0tG0WHHjI20XrblGnZU/9fp/R2OYHcstbEfQeD
	bUjQ2i0If5dKNBxkTqMe+wyyS/fa/rpjJlU7w4MIsQtpBvH25HGSjhV6MeBEE//YSA+MLv
	b9MRjcjE+2syozjiY11A7wNMnr+T3rE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PTV0QSip;
	spf=pass (imf15.hostedemail.com: domain of vernon2gm@gmail.com designates 209.85.208.181 as permitted sender) smtp.mailfrom=vernon2gm@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768624065; a=rsa-sha256;
	cv=pass;
	b=DBFNfh7+Z23kb54ZUBzCv5ETwr+K8/W6Ct2ttMhPWkcD3DSLQOliyn4zu7xpdfSQJS2Zpm
	/oEd4if6mUel5hpkmI83YiNavndW2RL+/XuVSQXSmdciOuAOV0biRiTFNiLY+EretKWe/q
	s9H1A45D0bmnmI97jWxBkjeFJBCryU4=
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-3831c18b23bso21214821fa.2
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:27:45 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768624064; cv=none;
        d=google.com; s=arc-20240605;
        b=BFPMJ98ktoXoRG9a83ImvnNVpvx3ZVpqUiLwJ0ccneoW8kwx6mPG9WPps9+0nvXYNN
         lVHD+LExGlJXKB+z3cdDjajLvaA7H8f4dpoNuo1K0cKj0GjbrZ26SRJailxT4qLWBZDk
         8Rj02BzNyhpxaE/c4V9NSDsGQoSaSkFxfGIPz7rgZGtwWXmHam2lE0iwhRLKqgQZNkmY
         e4Xdmorveo8Mfp444UP9bCKzdAA7ZMXSEBuh09CK8Ih8jhQMTsiro32sLaJptHVC4Cyw
         f5Tnow4MMP5mj94GxhegS+qGLNiIMDU4yeZRMV3FAtRJFrodeM2wbCgZkTpstTLxIwD/
         xvxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fU+HEJ2yFiduc9HntpiFz72CvGQz3C3hryoeWDq7fzA=;
        fh=6X6RowrjNqC542LFBYpj32KbgHJqwCxQWfCAV2D4Wr4=;
        b=HOkKLI2y9qg3dQcVC/9JYEwt1RF/EkL+rj5zscVnSMhiySH/A+Tzcr9y5kazBnW9w+
         OxiSiiF/7Et/pWL1m+uVlZ/yh6jWaGAem8kcl/nR/DZRToqM7iTMteYa3/zwnRR39pmr
         m00rc0BfFLgpoDQhw47ILRCbacNzk9CtvTC542gRq11sfpA7UeIld8Kfoy/XRY4K1TOp
         bi7X5FajQLN3PW0lXlOnem0R2OpZrBJ/CXcbBB2fq52hz+xAUPtn/D04x7vlnc7FbhAL
         dG/LzrzaCqHW2BIccJ8vZvmDbGqwHNxTwWoJdMGsusXDumwY8HSHWMMVf4731Qi8os7g
         SsEA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768624064; x=1769228864; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fU+HEJ2yFiduc9HntpiFz72CvGQz3C3hryoeWDq7fzA=;
        b=PTV0QSipY4cINYrFXFxVkHXtwvrZ1i66m9Dwb9aUeFxlfNUPWjME8+qvwAlMFaDIDL
         wiqLip8mD6aimOFJOOZGOhp5qahsU6410aAn9V7bzeXfqI3o7BEfum0ib9OfTu+qAgMR
         uxUTqOwQEm6mhAosTDxqc8l/jvqP5t3L1lWhZZnJM7fHqzURdylggPmQyTcM5vzTQHQt
         yZDmFLkWXfNZNo4AqpR7/z20eybyttjm40f5KFppIpj3cHMZ+BJ2fwYvjBD4gQyVDbWc
         98mFo7cD8WpbYsxj/Y2DpTfjWczYRMT0Y6adaMW1+7vgVZESifI4L/DqcB6I+AL5kI0X
         te6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768624064; x=1769228864;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fU+HEJ2yFiduc9HntpiFz72CvGQz3C3hryoeWDq7fzA=;
        b=qwr4ft5NB4G3TM91cdJ81XUQxeVNOCQN04ZCxRWrm+fdSf8pihBMzBEWFzq/7UgQLG
         u2Aqin+x7aWl+DSLcFFVb2LcP2RkXJO0PWHPozdAbHy8e9Q74SrHWL+2bWOk0qfQuLBb
         knwF5YXAu7FQGzWSEOwo8i/y4VnafVmUbVyifTJMgrrx++VObJxuqH7m7IZ7YSS502te
         SYAwiOOPFjm7dFLyjD2Unr4r3vOrN0G6yDiCfAnNDJjY3zBBH/Y3o0yYKHdHUsmQ2z5P
         xOO6chK54kwd77LUKXVn66AeFeJpyEWGN/CP9GKhFICf6B7Uojn/4H8bDuVdL2NcBXXl
         +n6Q==
X-Forwarded-Encrypted: i=1; AJvYcCUxiYWy+GV6AczpUAc2Qpwce2EJxhYCcI/jMP/VMZNFQF0ZtMM+y8nOJLiIcw4PXNYA9nuQtdtkDw==@kvack.org
X-Gm-Message-State: AOJu0YyZ8hv4I0DYosbeFUEv+Cva0LOzjHmgyJatvhj7Pmg/rF/Q2SnE
	n5/ycgo5dNQPRYRyYZuLjT3WaBTGTpFu6QQisn5yq+uyQdewYbTgTjGeS620ysclsX+NzeyUb1M
	sBAXUQV0T1v8lsAl2/e3aq5Ygtg/weTM=
X-Gm-Gg: AY/fxX66c7obWmnpogCrSyiGdWSrTNSVFwTpzR1DKPQXtBKIQM5t3wGBBsbmeG476H9
	cxA2QkSX7uZcvLZgnGAYCLhUCTYT7DTy9slhJx6l3iX9Z/8xlL6riu90XjF1/NUiiQ7xgoS0STu
	QqyoKU/fYseudiey/ceF6a2sS7Qn50TNUG7OtmqKEyKgWBdh745HXziF4imxIgHv5wmAXwxzbAk
	ip6jpNThqQhw4JqXv/ZtERcojfTwJCmCD2Th0tkVsMdOg7knCskQM/8/jF7SZrXZ6dUlf4=
X-Received: by 2002:a2e:bc24:0:b0:383:250a:850e with SMTP id
 38308e7fff4ca-3838417cc48mr18248261fa.10.1768624063588; Fri, 16 Jan 2026
 20:27:43 -0800 (PST)
MIME-Version: 1.0
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-6-yanglincheng@kylinos.cn> <06c2e619-0e60-4e57-b2ea-37333b2f6f5d@kernel.org>
In-Reply-To: <06c2e619-0e60-4e57-b2ea-37333b2f6f5d@kernel.org>
From: Vernon Yang <vernon2gm@gmail.com>
Date: Sat, 17 Jan 2026 12:27:32 +0800
X-Gm-Features: AZwV_QiomDeC4-oNSzRAArhwAFSFuXp3_mCTWMryI4rt1KPckNiD2frwiW3zbIk
Message-ID: <CACZaFFNxUiw_S-O-KUUrXonSsa62jwbvDwrRekx++A6xoZ3SAQ@mail.gmail.com>
Subject: Re: [PATCH mm-new v4 5/6] mm: khugepaged: skip lazy-free folios at scanning
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 41cqcjuhq5haqdtxncju6eyzcq1pzgtd
X-Rspam-User: 
X-Rspamd-Queue-Id: 97582A000B
X-Rspamd-Server: rspam08
X-HE-Tag: 1768624065-804961
X-HE-Meta: U2FsdGVkX1/kPyeu3hpRJI820LUHq7ezLRCHHjs6YEHvoeU7WpgLQ2ETvC5ktyliCBzCUOrZtzsNfc7VEotwkbkaTEWXNdHXWm882NCGlPzTXzQ0kgxJPdJ+R+HqunRei8tmjDbE+7x0fHjHpRBTfxMBjgrChc2506McwdHOTtH+n4632YlRR6LfDdOy5dLPQpBvAbjcLpsmhdOqVdyjho7wi5OT26/WWJlQmaGdFZNFW7h1x+Z4dAh0OgzYjf7XgixP/nOQlVA0aIkptdNpzPsoWCIvs569t0Q4o/PncEYbtuaqMb5HOyBoYxHQ224KwZ6Xtq/AQqT2bYbMNB38X2p6Gr8VQ9giu1i24Ej2x6pzq2dkh9K2FYFkbHD2vIJoIVdYPR4/6VPg82Vo60EgEoXfNWb9dItwsUkOf6FJ7+qnswEFSnYt/QZuEgkrPfZataoE39x1JnPPbHwQax3n/dQYzeBQRr7R/oElvDK0B/QP6DgSwgabbZ9RB1hfXa/Kfnn3sucdrKN6psyBLKy9A65hVlcpa+zCpwF83iN+mz+1y7lzHiLY1X8T33OTUeKZcemaICyFeH8/twVdPWm4VLEvtcfSKi9zoB2jQ0VEAMvuiSKskvIRFeP0sGt7M974sDZoFWmziB5Hx96Us4pXW7hOmeaT2DsGdilrkc3/rJXQHVAciSWxoOJnkykXWpqWJdUoLMiJ+fDRKYlsCPtSBfkG5Tf3yiAqlfowN4uDE+e+aqi+CZCRJaCUr2W9D2e3X+DFOWcp7tnhhh3Szwf3lRphAVEvGZavZisWWAGryokQLAgETto8rvLLCbRj6sepnzaS7TcBkIEPKgeBe6+mJkspwVNs5MkxHRXHaPDyfShtAhbWMama04k4yxuY0i9GDNucIbGNGq7ZUWoJD2jevRnvyJYmxMvZKoYtkzW6GNM3ARs9T0KF8+s3tx9KVBwL3iSgAhlnwZWiDlJmwcA
 7t13kxsk
 qcWPGMSzTqs3D6tX/160ytn9vn0jG9zOxt14ILeCkutpB1p9+lo0/jtzGy5MrehN4Juf+CVfQ1I0OReJ1nLJsbQXkHpApYSRBr+XjMcb1Z/wzm8LGpM6q9Mx67YcTZLA5x6sz0i+yJK12ZkCnL8VulR8Ovy/nBXGbiwokZmEQZeli0IW/BkRm11tLXZhggkLo4yJ/QRnmiv1AYqUlrv5wPSrTUBO0Zsvh3/tYWM57tK8WcyDYN0zA9BtOfeADXM7cQqaJfvGZ2TXp82xUUuqlw80sm2eX7dISWPlbtoesne7g1PhpsTNsnTQzJ9J4+cfkETPrxUDB1k4HSsYeP9U2rDjxVYx5UNehy8L8S8qjzV6Fi7eIYqbg5TyDfsJcFfzsIaF1Qdp6l/BZKSZWbOM2AY1b4uP6bzGGMg0SWetgT+akcTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 7:50=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
>
> On 1/11/26 13:19, Vernon Yang wrote:
> > For example, create three task: hot1 -> cold -> hot2. After all three
> > task are created, each allocate memory 128MB. the hot1/hot2 task
> > continuously access 128 MB memory, while the cold task only accesses
> > its memory briefly andthen call madvise(MADV_FREE). However, khugepaged
> > still prioritizes scanning the cold task and only scans the hot2 task
> > after completing the scan of the cold task.
> >
> > So if the user has explicitly informed us via MADV_FREE that this memor=
y
> > will be freed, it is appropriate for khugepaged to skip it only, thereb=
y
> > avoiding unnecessary scan and collapse operations to reducing CPU
> > wastage.
> >
> > Here are the performance test results:
> > (Throughput bigger is better, other smaller is better)
> >
> > Testing on x86_64 machine:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69%  |
> > | cycles per access   |  4.96         |  2.21         | -55.44% |
> > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19%  |
> > | dTLB-load-misses    |  284814532    |  69597236     | -75.56% |
> >
> > Testing on qemu-system-x86_64 -enable-kvm:
> >
> > | task hot2           | without patch | with patch    |  delta  |
> > |---------------------|---------------|---------------|---------|
> > | total accesses time |  3.35 sec     |  2.96 sec     | -11.64% |
> > | cycles per access   |  7.29         |  2.07         | -71.60% |
> > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.41% |
> > | dTLB-load-misses    |  241600871    |  3216108      | -98.67% |
> >
> > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > ---
> >   include/trace/events/huge_memory.h |  1 +
> >   mm/khugepaged.c                    | 17 +++++++++++++++++
> >   2 files changed, 18 insertions(+)
> >
> > diff --git a/include/trace/events/huge_memory.h b/include/trace/events/=
huge_memory.h
> > index 3d1069c3f0c5..e3856f8ab9eb 100644
> > --- a/include/trace/events/huge_memory.h
> > +++ b/include/trace/events/huge_memory.h
> > @@ -25,6 +25,7 @@
> >       EM( SCAN_PAGE_LRU,              "page_not_in_lru")              \
> >       EM( SCAN_PAGE_LOCK,             "page_locked")                  \
> >       EM( SCAN_PAGE_ANON,             "page_not_anon")                \
> > +     EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")                \
> >       EM( SCAN_PAGE_COMPOUND,         "page_compound")                \
> >       EM( SCAN_ANY_PROCESS,           "no_process_for_page")          \
> >       EM( SCAN_VMA_NULL,              "vma_null")                     \
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 6df2857d94c6..8a7008760566 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -46,6 +46,7 @@ enum scan_result {
> >       SCAN_PAGE_LRU,
> >       SCAN_PAGE_LOCK,
> >       SCAN_PAGE_ANON,
> > +     SCAN_PAGE_LAZYFREE,
> >       SCAN_PAGE_COMPOUND,
> >       SCAN_ANY_PROCESS,
> >       SCAN_VMA_NULL,
> > @@ -1258,6 +1259,7 @@ static enum scan_result hpage_collapse_scan_pmd(s=
truct mm_struct *mm,
> >       pmd_t *pmd;
> >       pte_t *pte, *_pte;
> >       int none_or_zero =3D 0, shared =3D 0, referenced =3D 0;
> > +     int lazyfree =3D 0;
> >       enum scan_result result =3D SCAN_FAIL;
> >       struct page *page =3D NULL;
> >       struct folio *folio =3D NULL;
> > @@ -1343,6 +1345,21 @@ static enum scan_result hpage_collapse_scan_pmd(=
struct mm_struct *mm,
> >               }
> >               folio =3D page_folio(page);
> >
> > +             if (cc->is_khugepaged && !pte_dirty(pteval) &&
> > +                 folio_is_lazyfree(folio)) {
> > +                     ++lazyfree;
> > +
> > +                     /*
> > +                      * The lazyfree folios are reclaimed and become p=
te_none.
> > +                      * Ensure they do not continue to be collapsed wh=
en
> > +                      * skipped ahead.
> > +                      */
> > +                     if ((lazyfree + none_or_zero) > khugepaged_max_pt=
es_none) {
> > +                             result =3D SCAN_PAGE_LAZYFREE;
> > +                             goto out_unmap;
>
> I dislike adding another khugepaged_max_ptes_none check. Gah.
>
>
> Can't we should just keep it simple and do
>
> if (!pte_dirty(pteval) && folio_is_lazyfree(folio)) {
>         result =3D SCAN_PAGE_LAZYFREE;
>         goto out_unmap;
> }

LGTM, I will apply it in the next version. Thank you for review and
suggestions.

> Reasoning: once they are none, we have a zero-filled page that e.g., the
> deferred shrinker can reclaim.
>
> If you collapse with a lazyfree page, that content will never be none
> and the deferred shrinker cannot reclaim them.

Nice! Thank you for explanation.

> So there is a real difference between them being none and them still
> being around.
>
>
> We could also try turning them into none entries here, that is, test of
> we can discard them, to then just threat them like none entries.
>
>
> Why don't we want to similarly handle this in
> __collapse_huge_page_isolate() ?

The same needs to be handled. Sorry, I missed it. I will fix it in
the next version.

--
Thanks,
Vernon

