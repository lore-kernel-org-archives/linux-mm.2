Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F5C0606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 16:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=SYM9uFM0
Received: by kanga.kvack.org (Postfix)
	id 996DD6B07BF; Tue, 24 Nov 2026 11:40:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96EF86B07C1; Tue, 24 Nov 2026 11:40:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 85D296B07C2; Tue, 24 Nov 2026 11:40:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4ECC86B07BF
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 11:40:24 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E23C2160BCD
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:40:23 +0000 (UTC)
X-FDA: 85470575526.07.63DF641
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id E5BAD1C000E
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:40:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SYM9uFM0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795538422;
	b=hiIMhwfbCHNZAIVYpXqJJNUnrwj2zspNA6nGG6uM7uQ+ZkV1oeHYs5nY48OXRO7kwUDKyw
	O64NGq2BWwx12vvvGEpSkblRfLNpMznRjzU051prs77OAiYNj1Zw538FHHojlTPYIti0cf
	a6GPclXh9UalKf3xacHlpcfLl6AVzWU=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795538422;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3wWnkq31yEF0IxUL8QXEbwU3zdf+25LYM4lO1Igg8kk=;
	b=qxPTQn7XzHQPbdKlYadVE47BlF0xEXTuX7m1FQiLI0S2JcKnR/mzn0zaLiXYGdXgmgepW7
	m+tHyVScOVTV4IYmwQbyMAHPZZY2l3X05affV/KHbGBvgSAWQGeAFeT+KfD6kjddey+G8g
	JPFWJdXbOo4xhG3qFe1FNCuKPBIWpHk=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=SYM9uFM0;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.48 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c516a194350so292125566b.3
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 08:40:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795538420; cv=none;
        d=google.com; s=arc-20260327;
        b=SxD04gBD5nid+IgzSQx0WEXabb+qq9owkpE5H8vjhXHeFlwNXDghnOl9ioqxM6cxik
         XdSkSMKhO+oSnMlaldY0gftvUQTQ76Y6KbX8TWfHmCMG+1f4PPTMPLkE4EP3zcP1IxiB
         0/vzggXTk82rPZFV0+JSL6RWS27Wg091J+4n5lJx1fVYeDSJD2WCjPuKPn5J1qusy4sT
         nQ/Lc4WiR+rPD0gZ29TrGuKxnbCuLis7QFGV/IatgUbdp46ix87ocmUgjwKm8MC6hEAR
         uyRD+TawMsi+3WvT2dxBy46O7zr8F0MYDRsGFtgc/EjluLqaH3tPIY7xnLtBF6XHVkJb
         CBng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3wWnkq31yEF0IxUL8QXEbwU3zdf+25LYM4lO1Igg8kk=;
        fh=S/VjDwp2RxmFf0GAZw1mLQQ9G3rKFqTI1TqomalcEvg=;
        b=W2sCgPLdf5hgO54PtkReLbZr+Fq9kFH7YKr7dDRgueqZqt27qOVVM42PO2XF+onn59
         PdRGrt5p52BiE5+7NuFlW3XiV4QPvFcD1Zqc6p8o8GnwcMnhfa0ZGwweHx8Bco+AhShb
         OLaPJrq7HqW8hbwTCsNg+qGY7X0L5P/+7PeeZfLoDWRZunFBGVACE+6spfa/UQNMLE6O
         zdLWDawCKUg9Kn6Ivw70wHX9kdBpU1rtWx26oGTlnv3Yjh5coC3j/OOd0rikhl46o/rS
         +rBmdLo+0gAK7uu/hJ0rCxNmq06pLBKeUJ21x6iOF/SqoaSBldM+1K81Ga7Kb7asr8r7
         rMdQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795538420; x=1796143220; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=3wWnkq31yEF0IxUL8QXEbwU3zdf+25LYM4lO1Igg8kk=;
        b=SYM9uFM0G3wEfUfiuhbpvgWXEZjmiyQld+NsLJ5qSLyVshU+FZ9Oqkgb8yy5XwwYzv
         dJGVnOjqXPjoL8e3Jrfx6rgg26R0CzmibY0tqtXXaH+whiZKeToxo+ktsnVpG97MBFeZ
         tB+ViehNSQEUXxJc4GEbaIzlDScNqpvOChFEItfDJpJaidHMhgBQYEh81mw1Zi9oHcFk
         qIjw4CTZxsrBdDdpJYcibn1Z/rEC0bpemUq38IzmkFodCIpF01lCER+/4bYdtWQuozTv
         7kAIg+BWl8DLi1SYRtxbSIL0vi4m2xYTsnq//Tb0emKvMIZEFtbrDyn/wQ+03l+pyF9g
         EXyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795538420; x=1796143220;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3wWnkq31yEF0IxUL8QXEbwU3zdf+25LYM4lO1Igg8kk=;
        b=B6onE3u5iAl3cAlq6BRZlwavBQO51uXsMJnfBu5DDS5e6iLyaOXW+yTAtbOxKOBhD1
         bwufk56fopHus8fLUKNK31xMWWvKcjawMoKTczJTRtwIyHnU9PyyofQTbhlAI2m37rxy
         qbGw5ERQ9Xcv6oZ4H8+8rXZ7IV0mcwwwizuRrIYx4mYluL5Vu0BXxH2DziUfuwpQbRjc
         eeCJ0lySCsJo0K+AWAB/1fYYVWr4MjUTC19JT2qhKV5fHi8VakZCcKKiPZGkX7vS0QnV
         KJimvNmLNxqwEpconInjH1h2w35NmJCFjpNqBSMsV0MLdIwJO4kwdDiN6IXFKEX5PMUj
         Iurw==
X-Forwarded-Encrypted: i=1; AL+hErFGQ31seiVOgIyM/JP4iD7qz85XEPyddtQIN0iAAuZIQOAkJx0Wi45Nqg9nVxquw88hjhUTVljZCQ==@kvack.org
X-Gm-Message-State: APuU4Z+Xr/qCB8+aUjGyBpmK3YOyMlOVnGfs01ubARgHmBBnJg+ZZDWC
	WxsQqiNMdVaa76lnhJbbsQw9ctZAYj3eillIPrCsX8mLmN7zmGBXwnaN0TnbYJb5xqJ3BYWsn9c
	bjGTpVJjIvMtwKfIPPJC9/iOYptW4mFqEqlDeplyw
X-Gm-Gg: AZFdTZcKE8gfzJCK1cRJhQ+4yEDraGepnmKHxh2JV/dPFhST07ERChnnauiMjwOu/4u
	PJt47pTpjzhL7/m5n92/4eUX38xMTsLBRkPM+KXbQ9yfOORKwc09ds0zHkMEEX6BcttiKWu2SD/
	dEQJSBdFESA4F6QJqnQGs2lwmsrx0Acb28nGLaaYp1kqYHhs3nZuxnBkC1cKwN0bmEp0nil8O4/
	m8oz6R/vF4Dm1CK1AMNFltjsJuVOcCSL3LIFS+O+48CzpvHDFRaBKU7uKtVFDbR57OD1TPHKoRU
	CYGVro1iOFgm9cvU1VppEayzMjk01ZpAJN6gdrrs1l1gl0DeJ0faT9pMKwpI/keAMkOJisEvWqG
	kM+4Feuchvt9JxTgwNmv5/AbEzjX94WzU31rckmqK1L+K83smdBlp/riJoZgwx5JFjHmsHg+R92
	pqfHm7VOaDSReR7nShN2UeH2b7yMEfQCO6u5TgWchY6iSFmK3G2ks=
X-Received: by 2002:a17:906:7d91:b0:c49:a539:aa45 with SMTP id
 a640c23a62f3a-c513aad1ab4mr1075079466b.42.1795538420109; Tue, 24 Nov 2026
 08:40:20 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-5-jthoughton@google.com> <sashiko-outbox-228633@kernel.org>
In-Reply-To: <sashiko-outbox-228633@kernel.org>
From: James Houghton <jthoughton@google.com>
Date: Tue, 24 Nov 2026 11:39:41 -0500
X-Gm-Features: Aa3M54oepgUn4X8OBlBmCHpzq7qyxHfiRu28mAUeA1WpcH_3XcJmtKTuvSjLHXI
Message-ID: <CADrL8HVxnyNniotcEG+CMBAs4EVLihuU4bcqr5rLZWT9dUxNCw@mail.gmail.com>
Subject: Re: [PATCH v3 04/19] hugetlb_vmemmap: Use try_update_vmemmap_pte to
 update in-use PTEs
To: sashiko-reviews@lists.linux.dev
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, Kefeng Wang <wangkefeng.wang@huawei.com>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E5BAD1C000E
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: q1f8k55uhgi4izwcfxfxyur81obqyoyo
X-HE-Tag: 1795538421-212925
X-HE-Meta: U2FsdGVkX19cwLRBk/ZYLSC8w82I1UUk8TqRLrQWDRPHUqYKn3n4/BVKWfqpLfW8PQuoDqH89WeAqgFPP+Jrlh3vngWMQ+SJjb2p4ecohmPtlwwP0Bw0XLG5UayklBFrI2/uZdLqNKNGURokIUY3eJ4FKlwMRbjdgDzR5RU61EudESivGHTNMhxFu7n+2UVHEf3dgTRXl70nEgxRunoRA8eNyiQoJGc2IIjXoUL8WoB8GLVPxa7K3C/1ZHe3PPmSS1migwubs0oj0TreXEOs+tFzQoYS7Ngl/q+QbsjmN8FCqHLZ/jliTLGCkqBnJQFc06aTIPq0GFZQJjmCS/SewI3uq8Hz2HR+BCbC4ReetTx+9wGsLBo829Zj3QWTBpTsNjW2JcW7xiPiHtfYsfYmsKsl3sp67NPNrH8lFrJP55v0xk1d5L9K/aULJRttL252+F9QpCN+ngGnPtjuJW2n+XVn5o71WxNalRqEOdGWlnlF9n38L8LHHpGnWdJn40aoi9/KLvICQpgYYqx44+dy5fBjNLfJIaKzauT80TM1JA9xaEmUqUxkgHyGDNObYa5bVpQx9CSMdgJngHfsljS4oqCIgsfQLxzawS99q+8U6gVDpSoAwD8E/vGkfEbGRknUV+CT5KoUzEnS/3SGab1lMvxL/xINr4ZKVIk+ZOI5qiWOhrbL2HfVPQPQNbsJ104oal/cFjbHgkq34psaNg7aMJwK7SXIIiZ2fmCCWvFmhg8WCQarnN1/fQUHYr3DvrWNvnv6Wq7Vohf3GXDRvt7PWAyEluQ/8CMnfHy8fXu6RNNyOO/yZlIIGm9r0EiNgsnCIcRgfZPEbkgFiuEWa2l5/LqKdyCKszH7G96vTkuZuGYX7yv3eLqhX66UlWBi53NZoujZKZq2ZoG+HX5Qxmr84W1ppQeqkpaAJEeH4g1yVF8JcbwP7LI6BGfBC4kbwv3Vx9J2BTC0iWMIW9FPItd
 7h5oyK+9
 tr6M8mUEXF3pKzNSQOaJZoAvDUD0+uHaHQkkfaTSzZQtCbjYqfPKi8sOmMTp1THx2hJG0KNa12RpmnzLZQXVz1dMl8dN49mclGJAMu4C/gg3bgpxKAtP+nXU/YP3vRaiweodSHpFttlUBSMLwKjY+KK8EfRdW/d2UJ7Bl51DbiXVEe8ZF7kdbFbUJXRXToTHJ+052UQjVNqQjtnn4qW+8rFVFd1c2sVpFwIo7blm8o6ZLbNreI4uBxI05BlHshKFyo6vTfBkxfMWhQrDTHtUlJPXn2hBsc5THUHq8u+B/sxyb+VT8yR6uPxnrtt/oE9e56h5qxumdNkT0vp/YD3PnciNUk389LLgxSBeywHfYEpGCkLw2j4nxkx0IG1K7XyC7IkV+or6gt78HBKUvJe8y97ySgzWY0PqCHKki1ks9tu0FkacbdR58SkzfoLGAzEnJucGFGQcBg55iQ4mqiRyJIBwJssDskg5bt9PFBXfRMY/S2FjjD4e8XMJBdcpZekRwfgciJPRQ9ZIx050WTxglib+WVRqHM4GFHzTkKNBTQrSZwPlFNFtZHktNkA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> wrote:
>
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/hugetlb_vmemmap: missing TLB flush on partial
>   vmemmap_restore_pte() failure
> --
>
> commit 8b77f3aefb06415df030fdd341c5e065dabec71c
> Author: James Houghton <jthoughton@google.com>
>
> hugetlb_vmemmap: Use try_update_vmemmap_pte to update in-use PTEs
>
> This commit introduces try_update_vmemmap_pte() and uses it in place of
> set_pte_at() when remapping in-use vmemmap PTEs during hugetlb vmemmap
> optimization and restoration.
>
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index 2e9cf8d39c892..b4d0311bcc4a2 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> [ ... ]
> > @@ -291,7 +309,11 @@ static int vmemmap_restore_pte(pte_t *pte, unsigne=
d long addr,
> >               return 0;
> >
> >       dst =3D vmemmap_dup_page_from_list(src, walk->vmemmap_pages);
> > -     set_pte_at(&init_mm, addr, pte, mk_pte(dst, PAGE_KERNEL));
> > +     ret =3D try_update_vmemmap_pte(addr, pte, mk_pte(dst, PAGE_KERNEL=
));
> > +     if (ret)
> > +             return ret;
> > +
> > +     list_del(&dst->lru);
> >
> >       return 0;
> >  }
>
> [Severity: Medium]
> Can a partial failure in vmemmap_restore_pte() skip the TLB flush for
> PTEs that were already remapped?
>
> Previously, __hugetlb_vmemmap_restore_folio() could only fail in
> alloc_vmemmap_page_list() before modifying any PTEs.  Now,
> try_update_vmemmap_pte() can fail after earlier vmemmap PTEs of the same
> folio have been remapped to new writable pages.
>
> When called from hugetlb_vmemmap_restore_folios(), VMEMMAP_DEFER_TLB_FLUS=
H
> causes vmemmap_remap_range() to defer the flush to its caller, which only
> flushes when at least one folio was fully restored:
>
> mm/hugetlb_vmemmap.c:hugetlb_vmemmap_restore_folios() {
>         ...
>                 if (folio_test_hugetlb_vmemmap_optimized(folio)) {
>                         ret =3D __hugetlb_vmemmap_restore_folio(h, folio,=
 flags);
>                         if (ret)
>                                 break;
>                         restored++;
>                 }
>         ...
>         if (restored)
>                 flush_tlb_all();
> }
>
> If the first optimized folio fails midway through vmemmap_restore_pte(),
> the loop breaks with restored =3D=3D 0 and skips flush_tlb_all(), leaving
> stale TLB entries pointing to the old shared tail page for the already
> remapped vmemmap PTEs when the partially restored folio is returned to
> the hugetlb pool.

Yes, this is accurate, thank you! For v4,
hugetlb_vmemmap_restore_folios() will flush when
__hugetlb_vmemmap_restore_folio() fails.

