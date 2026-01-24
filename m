Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D9D6D715C9
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 05:32:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DB256B0589; Sat, 24 Jan 2026 00:32:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287796B058A; Sat, 24 Jan 2026 00:32:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16A446B058B; Sat, 24 Jan 2026 00:32:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3CA76B0589
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 00:32:56 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 61696C109A
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:32:56 +0000 (UTC)
X-FDA: 84365738352.07.8C8170A
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf30.hostedemail.com (Postfix) with ESMTP id 655DE8000A
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:32:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FNcyWH1I;
	spf=pass (imf30.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769232774;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nKqKd32OVkFZncedQEHasSd0/zVJgZpmaBxGC1uXPN8=;
	b=eXkDM4vWYC2nnzx9NCrTscLPW/tbl5PP4H/ZUWdVMv9cpZvxaSQ7L6Zx1VnU/npPHRGvGF
	xLCdbDInj6XhPknM/4/xeN5LRCoeqZY/taTaqg0/wawfNN1CkssWVeHDpKva2tW1/3T+DB
	5+IB6StytvocWIHQ0XLw6C7CBbTqkJo=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FNcyWH1I;
	spf=pass (imf30.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769232774; a=rsa-sha256;
	cv=pass;
	b=d+suVcBDaF6jVTOtxP74Q9UNNEDMSXHWiD1zscGp3zFOyCUgc6GVnu2rS1aQbFGWEzWDTx
	9TsDnHdQvQ2AWrzZeRTFhzEJM7vhu4be3QxYFxbhqEnfwi/yzJdDbbV2yQbQgbcRzM0cAp
	CmC9hIyj1CvUJ8EFzTinQH9gsC8Yx0I=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47ee0a62115so32615e9.0
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 21:32:54 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769232773; cv=none;
        d=google.com; s=arc-20240605;
        b=fg+S4eN9rWNSoqW6bwND9q2V0LLsfK4zwg5w9seodJT5iTJF01I7HR3yCBSL6aLwy1
         9BskuX0Rzu5J4fBVsJQDjcquheOxqUKLX70Gju4oxgwdcG5biFK5qsRgaMysHTykCvbA
         3YKWb5v72aljgd+eldu3ZnTMR55ePTJ2V8k1nmdFqaTK7QJ6hPN4TsCCgc+ba4hrKkB2
         MtYYVNNJiajG1st8vbWBq5DFYUCjybHJxH4D0SVWNhgn/txy2q5KGLy1Cok5eTcjNESK
         vHdH8NhXzsYCxhNwFcLpAH2L081MG0uha+iYAL3QKABmluF0AjtiSWG7NmJafbPwtofB
         iobA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nKqKd32OVkFZncedQEHasSd0/zVJgZpmaBxGC1uXPN8=;
        fh=TM2YrqImVr7qsyTckDzzebb9HP8Tk9rUIBfkMdS0oT8=;
        b=C3BFj8zF3T/+SQDnSYcN7KGVLpPELPmtiLGjKv2fvGE3N5Q+F7ncXlEsCYUVSmgpBA
         ZjcShClKGWUDT00XLrxgr7X6R1ExjqG9eaket/C+qsZjhHa4v36lOnhda6oq4EgfHoaV
         Qsbyv42rzcgDFyVJFKk1cNoWkOCUfkINoGHDaoQPngyLM8l6AMUlRTOIkwEPItD1w8Sk
         NpAYF6/NLVaBQVW2xH9uklA9twlQ3Apmp0onWVPs5xisAURq16U6cQYY5tlU9uiV49oV
         stjsqXNO8gkpvUj6ortGfA7mfVnhgFWPl/r1owtXwrI8eEEeLd8Vl5QAvYxIyEGClrr5
         8ldw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769232773; x=1769837573; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nKqKd32OVkFZncedQEHasSd0/zVJgZpmaBxGC1uXPN8=;
        b=FNcyWH1ITVTM1TqDjamkVA3lYVAIuzsRNkNEoaw3zUds0hSyUSRa+NSFzc8NKnvLOE
         qkHeU1zioEhMemum1vBPK5V5F2RgJr7kRvrd0d3UxkWoQLqS5oS/eOqnkxA/ssnbFKgz
         36oFv3SQbSs0xpNYpOasOmLnC0SXLDjW47SJ2BCXZ8cTFieMcncgkTyjqB4bDH4h2ckH
         pAhCwfY+3RzcfmoVSzmrTqdoTp2JVGQtbtYFXpDB6isE2U5bx49NU18i06GCI4Mi5IoZ
         9YMc/vF7oNo99pqahNa8CYWS8n5Axe+tTrPPvulCfr7CJQxGTy5xYMdVHLlquAc7lxM1
         Jy+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769232773; x=1769837573;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nKqKd32OVkFZncedQEHasSd0/zVJgZpmaBxGC1uXPN8=;
        b=C40rTCEVRhFRJCGwlh0vqu1GzKMq0v/iQjnGt0SgHJEW1eniy4jR9no0CfKLEN7GJZ
         ZcWBlIzOfYKmYSbB/C5ALk0D5a3zbCWM4slwQKTaGdFMeCb8BFkRpRaBVrpC0HKIkVuH
         eX4KI2w1DGqW+XpzDakRc8dupzalDj9saPcyZgeCCRM6zR/CZVrcBKeKbW+s3BTJrmks
         MAHjzblq7se5yT6L7j96on8YgJmlOp+5Velj1F5cA4ah0O9eWJ75SFzsC940cSUikmk0
         NqyNLAFo4fHzS91EHX3Twj+jtjRpQ5Q0GTeWIqR9j31fbrW6P51XDssYwHayFLPeXxlf
         zLSg==
X-Forwarded-Encrypted: i=1; AJvYcCXxKyceejYArU+RHc2QwlMlgQ0SNlf74KwGjVhgcz4/hvwmcBqjQf+zlJKF/7yV5pUWdr0n3TtVpA==@kvack.org
X-Gm-Message-State: AOJu0Yx9sVMKhOZcZKWe7xTV1oaaDC4iNVpbfdJNGML8vdj16i88CaeS
	7BQ951nvin1f4SZaVbezx7DkOMeABRsFCmjyJm3ntbiTcAm/fcpTBbzAOm7rAMMnDnlAQVEMG1e
	Z1vcRyuhZKWXj2oOoqOJujzKaF8Zwm/co5N/3KqPX
X-Gm-Gg: AZuq6aJiEC9h40zHYVwuOx2WkFx/exVFtJ/dsEeLYMCDnYxY1lOsDzCibtRxtyzrEc9
	9xIdllf87StqnS4MT/VXrydrwfRAMXmU7WcAyNBqs8W5vemtP09nPCYfZVOMoTX00PlL2odnHb2
	K+UflEqK/21piF6AuUKX/Q0vB2EZZw1JyXthXx5VFOmmt27hhbS76sHkSrjTfIqze71K4YIQyhz
	IVPTyOb+IPpC6th+SdSFZupAqoAwGzu7CQDGlu9udzfxCZqVVH9CLEBKUhwcRdK7cK7xHR98lWm
	HJk5aOgJHdkUsMkGOjMharNTKtXGXOeuTXs1JQ==
X-Received: by 2002:a05:600c:b41:b0:477:76ea:ba7a with SMTP id
 5b1f17b1804b1-48055bb7487mr208265e9.3.1769232772570; Fri, 23 Jan 2026
 21:32:52 -0800 (PST)
MIME-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com> <20260112004923.888429-3-jiaqiyan@google.com>
 <aWXaiWI3v_PJOKDL@hyeyoo>
In-Reply-To: <aWXaiWI3v_PJOKDL@hyeyoo>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 23 Jan 2026 21:32:41 -0800
X-Gm-Features: AZwV_QiHAb3uJDpfmPZidd6Qlp9FJ6arzQ8d4401RFGVT1u588OnPvqpGOkGolA
Message-ID: <CACw3F51--n_Zu7TWhaUU53vmK2P3eG5T=0mpEsxHqstA8uZUTQ@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Harry Yoo <harry.yoo@oracle.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com, 
	ziy@nvidia.com, willy@infradead.org, nao.horiguchi@gmail.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 655DE8000A
X-Stat-Signature: 7uyf5dgmns3ou4keex19hf9c1qwg6zbx
X-Rspam-User: 
X-HE-Tag: 1769232774-234891
X-HE-Meta: U2FsdGVkX1+FwW9K1ZwEtSjLdWnQMj3CLcjJlHlyUHWW6uvC5zsvlAugWYiVywthM2I9BkXsXbcvhoGvExk4r+Sd//yoIybfU0yaWPOOtMNWjZoi4rzhySdA3pyDy2UF31OMAeF5Ge1FgOUZZ9RQq9xecwJR2R8q3pfETSuXlA2R5r2Pk//F21aymNJ4NnCEEG68YoQv3hVl4QoR/tNWF9Tl0gt543rLfys63Czz/oZ+K47y8tdmqL2W4f9M5GxwXU0/K6fCzjPLDw+DvlDHKxoogr7N/Dvo0wqr8Hz3JQH1bswN4PZ0lqG4lqfLtSOheuSsk8aTnu5J60nk38e6hhNZsFrurkAME35QUtEm7f0HhFjmMk03ww5nGdk53rbm2laG2/t3x5ZYvcO9mPFRc4OpuaXAcYuzZ0tNj97GDwSl76m2OZHTDVs0UBaaeeZrtEUUlz9Wt2MBRm9A2c2wkZON2XFKX8wMfOl7F0E9PDiKuuF+dvG/v9wKt9MNnXY/8buY7H3P3fP9pL1x5aKvgPG021v7zftVUPyKOGEGnesz55y47NxbWp8Alutmvs+spd5TdyoW1qdRMtaXR4C+cgIADBjN0GuAZAQF0ajG6RpO4iFc0DEB9cRzghqekHWWRD+PDrlIQIOouoicsqP+Qbv/GOVt+FT231k2ZoR3IQFz+35tY0WbEWYZ6Q0/1LJS6oW+e3NMsckQMVSXeBZW15ge/Qfz3VeWuOX5mRDCKTEMlnHh1oihZT6tSbYyY/F4SUGV1296d2lfGRG1fJyfZwyu3EQQwhd4XguoGgiXKhX3ios9DblgnFCuEKMYvbC3QJlI6xTDRBndRYMc+PlaDZuBvvCuOL+cq9dfjufD/mtbrKObNyZmuHOIHuee6RzqjC/6SneZMJJd7CcH/x6QQ+UeMrHNV1BWYyWGOzcoIWiWz/+iOZBCnuBvTmuP06LQ54bMnFa2Sab+p5vUEvc
 iPe5PRcF
 linpHz3D3RD1I/jb/KAXQ+bOMLBy+lO6nc0VxEUvuDAANWJ1sndiZ13pdSxkxwMA1jBpVRWe5t+gK+2aPLSiZFJ04ZXmbQ94d7NXu7ttJL801zGMPg5YTLi9v2vlw86Eih5l86z4VH76q1AoWhaAoJblrh+O+AmCSIYAa6SOlTwyc7JpNlCSEA/M4UeQd7t1E9/vR61lAgI9ZX1vOnFxB8VNex00fuVHR/1coWPgy2a2v0h8aAeFJBdumKvz5RMXObcSJqtLKjzPm0yUOWurB6OyqN5tUk0G3/rN83YdQS20vuMAbxmQmo4S2EPrmsopGLp2Roxo3A7ILRaqOPhIgP2f0chbxDuO4IJ+use4vcuYxwU4gfHUd2QrsF5bX4f/5uwNN0IecgrLls5iyaXJ7Y4jcbhvOxjNyxjhj7y6i27lJMnWkhaCCtQncGI7l0eGp/KRwSYONCZCkQ8X1dRaUH8GirgfCSE7As7XS7ksmxpjFGiY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 9:39=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Jan 12, 2026 at 12:49:22AM +0000, Jiaqi Yan wrote:
> > At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> > becomes non-HugeTLB, and it is released to buddy allocator
> > as a high-order folio, e.g. a folio that contains 262144 pages
> > if the folio was a 1G HugeTLB hugepage.
> >
> > This is problematic if the HugeTLB hugepage contained HWPoison
> > subpages. In that case, since buddy allocator does not check
> > HWPoison for non-zero-order folio, the raw HWPoison page can
> > be given out with its buddy page and be re-used by either
> > kernel or userspace.
> >
> > Memory failure recovery (MFR) in kernel does attempt to take
> > raw HWPoison page off buddy allocator after
> > dissolve_free_hugetlb_folio(). However, there is always a time
> > window between dissolve_free_hugetlb_folio() frees a HWPoison
> > high-order folio to buddy allocator and MFR takes HWPoison
> > raw page off buddy allocator.
>
> I wonder if this is something we want to backport to -stable.
>
> > One obvious way to avoid this problem is to add page sanity
> > checks in page allocate or free path. However, it is against
> > the past efforts to reduce sanity check overhead [1,2,3].
> >
> > Introduce free_has_hwpoisoned() to only free the healthy pages
> > and to exclude the HWPoison ones in the high-order folio.
> > The idea is to iterate through the sub-pages of the folio to
> > identify contiguous ranges of healthy pages. Instead of freeing
> > pages one by one, decompose healthy ranges into the largest
> > possible blocks having different orders. Every block meets the
> > requirements to be freed via __free_one_page().
> >
> > free_has_hwpoisoned() has linear time complexity wrt the number
> > of pages in the folio. While the power-of-two decomposition
> > ensures that the number of calls to the buddy allocator is
> > logarithmic for each contiguous healthy range, the mandatory
> > linear scan of pages to identify PageHWPoison() defines the
> > overall time complexity. For a 1G hugepage having several
> > HWPoison pages, free_has_hwpoisoned() takes around 2ms on
> > average.
> >
> > Since free_has_hwpoisoned() has nontrivial overhead, it is
> > wrapped inside free_pages_prepare_has_hwpoisoned() and done
> > only PG_has_hwpoisoned indicates HWPoison page exists and
> > after free_pages_prepare() succeeded.
> >
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-=
mgorman@techsingularity.net
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-=
mgorman@techsingularity.net
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> >
> > ---
> >  mm/page_alloc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++-
> >  1 file changed, 154 insertions(+), 3 deletions(-)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 822e05f1a9646..9393589118604 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2923,6 +2928,152 @@ static bool free_frozen_page_commit(struct zone=
 *zone,
> >       return ret;
> >  }
>
> From correctness point of view I think it looks good to me.

Thanks, Harry!

> Let's see what the page allocator folks say.
>
> A few nits below.
>
> > +static bool compound_has_hwpoisoned(struct page *page, unsigned int or=
der)
> > +{
> > +     if (order =3D=3D 0 || !PageCompound(page))
> > +             return false;
>
> nit: since order-0 compound page is not a thing,
> !PageCompound(page) check should cover order =3D=3D 0 case.

ack, will simplify to something like PageCompound && folio_test_has_hwpoiso=
ned.

>
> > +     return folio_test_has_hwpoisoned(page_folio(page));
> > +}
> > +
> > +/*
> > + * Do free_has_hwpoisoned() when needed after free_pages_prepare().
> > + * Returns
> > + * - true: free_pages_prepare() is good and caller can proceed freeing=
.
> > + * - false: caller should not free pages for one of the two reasons:
> > + *   1. free_pages_prepare() failed so it is not safe to proceed freei=
ng.
> > + *   2. this is a compound page having some HWPoison pages, and health=
y
> > + *      pages are already safely freed.
> > + */
> > +static bool free_pages_prepare_has_hwpoisoned(struct page *page,
> > +                                           unsigned int order,
> > +                                           fpi_t fpi_flags)
>
> nit: Hope we'll come up with a better name than
> free_pages_prepare_has_poisoned(), but I don't have any better
> suggestion... :)
>
> And I hope somebody familiar with compaction (as compaction_free() calls
> free_pages_prepare() and ignores its return value) could confirm that
> it is safe to do a compound_has_hwpoisoned() check and, when it returns
> true, call free_has_hwpoisoned() in free_pages_prepare(),
> so that we won't need a separate function to do this.
>
> --
> Cheers,
> Harry / Hyeonggon

