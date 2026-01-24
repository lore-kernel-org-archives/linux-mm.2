Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCA7DD715CA
	for <linux-mm@archiver.kernel.org>; Sat, 24 Jan 2026 05:33:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B926B058A; Sat, 24 Jan 2026 00:33:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08C5C6B058C; Sat, 24 Jan 2026 00:33:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC68F6B058D; Sat, 24 Jan 2026 00:32:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA3806B058A
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 00:32:59 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 83327B6F6B
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:32:59 +0000 (UTC)
X-FDA: 84365738478.03.B30CA40
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf09.hostedemail.com (Postfix) with ESMTP id 780E9140006
	for <linux-mm@kvack.org>; Sat, 24 Jan 2026 05:32:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yUHcG5ZM;
	spf=pass (imf09.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769232777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ba9XYCYSUrpx56vy4zEoq2oHfryDZMFn9Qek9PfaR2w=;
	b=p7GuOmImYosXFPydYLWmCOchbMZ809j3362nZyk311n92KrZxz57tXWavAvR1kTd6dXcGH
	ZnFvqqWtLKxLQl8GRfxqoFBCcp5V+Or7EDiCjGk+FrThGBtGQmL3VSOKSjEVWc69sBESKM
	TLK26HKoZI+jl73iWZIj1OZhPhoUz/8=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yUHcG5ZM;
	spf=pass (imf09.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769232777; a=rsa-sha256;
	cv=pass;
	b=QpZV4eqIlvLjM2o0dXaAtYPqSTfWnVcc9NO+ZwDSXoKPdIHIjWrTcolcU+HRAGAOfX2SQK
	gahPU9WGoSSNuouoawSumJeHj07fS59xPvcgeKFfLuE9wbbMkz40WGSzDbV/XekmqpiLmV
	VDuG7JdCqxdET39iYevdhTs7q6DA93g=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-47a95a96d42so17495e9.1
        for <linux-mm@kvack.org>; Fri, 23 Jan 2026 21:32:57 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769232776; cv=none;
        d=google.com; s=arc-20240605;
        b=Seio6sugTKqyq0bfcuQhgmltkU67FqWzq72K45W2WDEIWSw7OLeKCNgT6/e0eRHv/N
         pmYlET/pzWcW8r+gwC3oOTVe19erQIZXvJW1q0p/j/OKN9WTslDuYM+cKIO97ILWTHHF
         xFZnlmerGY7g4QwcjazQEIVx0xF94JaMqHNkVFwaH2TejTMN9wer+dN2CAMzAmHZ4nyk
         JHkZzB8sr8msjg+As1aVatYTn99nsK8I0Ka+1ZdJ8P3yz1wXMKk+FkNM/8WW8vpcZ6Eo
         uiTklvVca830bYP2VIRJmjMWKTlVWVFFKW5GQLszuU9diOKzX4M/n0nIkjNgvJcQH9uP
         YnXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ba9XYCYSUrpx56vy4zEoq2oHfryDZMFn9Qek9PfaR2w=;
        fh=aTtcflAuDkhpAHrdwxkfvmw48/CQxktKIdGOfUwU80o=;
        b=E7JUwXONzPdSXmBSZoERkSX1uHI4aJUzwVeh3eKqV0DXEJ52d61/XZw9rUXH9dqs01
         5fAtauXNy8TIS2S01qYuGkmP4H9tQ6rzg3Y+QKFNGb71h9Zn5wXJlIZH4Duno8njNWcR
         xwgU0XkHwclUCoo651/K4smh3umwEXqoVCPyW6aPxf6SrzluiFhP18C72gGtTAdwzzdL
         i8U8wq2L6MipIag8wkA8YPt/dIK/mntMmAaZsSObW+W5Kk6fJQVH1/D9C9dy0AqPvHp+
         +53WncysoJKHp57mRkp/WM/cN/y5qV/uX+bmm3os5/JicxXV8IBALxUxK45JrIDmiAmN
         D5pg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769232776; x=1769837576; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ba9XYCYSUrpx56vy4zEoq2oHfryDZMFn9Qek9PfaR2w=;
        b=yUHcG5ZMvY4f9aPl9tWyMCY9CBr59/m5Y0cXe8A5S9kE7PzRK63i+WW2tclWK7sJ1B
         G20uUB1B+kgJeQvvOylMyRYaXDi0tqqIxmRgLmfgkYGtPif8+mJqTH7VM+Lubrq2/WIJ
         bwhzvsiYhDTJDMaiYW/PSrSvE0SBJ0M3u/17v1UakWeKgbP3Cw6yJl6f0GSak2scelRQ
         Xg/OYVYENoEi01kXSUePfhJiVQYmcM5wr6qLIusf9ja/VyokyZ+uEwDEdvC5Qybb/2ge
         kNIwljHoNWih35eezr4SYOY0VQtXCOKs5m1GoNo9zFV6fNNLsU23/9am7RVGexxA8i53
         jvpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769232776; x=1769837576;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ba9XYCYSUrpx56vy4zEoq2oHfryDZMFn9Qek9PfaR2w=;
        b=WpcHgzHdDfcpJ/lY1D7z6DxkABuWrPoUwtJfwgwfaku171gos16kIKzNInQtaMWj+I
         T9+FL27U2fGPi9WsAM0985wPGyVkVT5nVp/MTa890kkdtBmy9JF+7isyNQfN2ecExCh9
         /rUtwAmvHWVNAmkXbXVw5JjT8IZu/O9gWaKTwiN0dEDFKRivUAd4Fr+WdMnP8b7ko7ld
         NlBpHLN8L6bitUPFWQe1mu2xbI8ouKsMz4xdUNjJIAqovfmcGpru7GBeiyHpw57pFRit
         j0YPD9Tkc7L0lQPB6x8FMHULR+6dka09ht5JG1EA4myqaCsdBh14k0GysO/QoByUF9se
         pPGA==
X-Forwarded-Encrypted: i=1; AJvYcCWLXzcqFZB5o0Qn9j4xzLug8i0XdR5xy+peu84sRV92QIOlKefk8aI515XwCa9M6bBxptdRm+HoNA==@kvack.org
X-Gm-Message-State: AOJu0YzPX8je8uikrjBHqyUFVIM3SJpIwnOdfSLNlTfdDtBafE6Q1Dol
	IP1KMFPEwr8/cQFBgt0PxO2FZxcBZMUQ8K9q5zhcHQQInfLFAuYaeYVd4VPFQxfBjqM5u2ts8oK
	gDqA0SSJgW14sMeY1iQo8QTlx5QtkCmrhvcBsD+Np
X-Gm-Gg: AZuq6aLM/2ewNQnN8+wkWmJYh5lyrT6KyrsN150EhfcDqHWv+vQHN/MhqKv7Oyp+N3w
	UniR9ubFyfFE5/QXhA+a8Y2K8+fs3b17q3tECB4xkDYuUywd3t2Td7Y1EWiyArrYR3KiDUADWrB
	3FJTLI2dNjXEbTKSBMlxAljcFzqJNpkfJzO8DWZbzPoYYeTz5SVFUjMpl/KXwBp7M7ELxq0fJqw
	DM1SJXKLQfFcOSna48uatBYpIR62jjphmIoX1VXhJw95Ih9rzJC2n+RRAznqAmj7OClcl7JZg0W
	CwR58cjDIJ3va87PK2ya22rmIaA=
X-Received: by 2002:a05:600c:634e:b0:477:b358:d7a9 with SMTP id
 5b1f17b1804b1-48055bcaa30mr213225e9.17.1769232775836; Fri, 23 Jan 2026
 21:32:55 -0800 (PST)
MIME-Version: 1.0
References: <20260112004923.888429-1-jiaqiyan@google.com> <20260112004923.888429-3-jiaqiyan@google.com>
 <aWXaiWI3v_PJOKDL@hyeyoo> <13276FAF-85A1-41DB-8C30-CDA856FA6BF7@nvidia.com>
In-Reply-To: <13276FAF-85A1-41DB-8C30-CDA856FA6BF7@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 23 Jan 2026 21:32:44 -0800
X-Gm-Features: AZwV_QhG-bnMEszSTPXqSZ3NTNdKeWeZJdzbR-I1a9PUJITO3H7HCiNjVDF2UA4
Message-ID: <CACw3F50HX_RUskhoZmEf7T6uAwyPgVoQ+kpg5nTmZD4qP49t0Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/3] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Zi Yan <ziy@nvidia.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, jackmanb@google.com, hannes@cmpxchg.org, 
	linmiaohe@huawei.com, willy@infradead.org, nao.horiguchi@gmail.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, william.roche@oracle.com, 
	tony.luck@intel.com, wangkefeng.wang@huawei.com, jane.chu@oracle.com, 
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Liam.Howlett@oracle.com, 
	vbabka@suse.cz, rppt@kernel.org, surenb@google.com, mhocko@suse.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: qgdbdwyurffrhcs1qdej7s49k4egf7mh
X-Rspamd-Queue-Id: 780E9140006
X-Rspam-User: 
X-HE-Tag: 1769232777-981432
X-HE-Meta: U2FsdGVkX1/Ah2rkSBZyuh0H1kxyIX2v1YmCs9ioSIT7aFsu6H3Qecjs1Tz5NJtzFK01wskmNIqsJ2NUjbzZRHA3chTJxJPI2GugwwSbcP8CKIdA9dAk4y55Sgl8ZbGwWptzqx/5voqbK63s7Hxd4HeRhDgELLDlWUO4LC1CbWQhsZnj91UUOoKm61+Yupmm2vcF7gZ2NZhGD7c87PoRTiFp2W3BlVTCOi2fmLF1VjLu4MM1dQaFOJYotrH1D/exlz7OxpexxiGRV0OEDi7FOAsugUTBugINvu9EiHAFGh0DjzsNaA7jSdnZ/BOvP8Ph42WzmHClPqDPuxyyubmAcqV6KDgdKNHdUN0mN6v6Rr1JbMVG30NN1+cs9y3iCBiNtdsmXOr3jkyzwpBC/G0T0CJUP67sFwgBwZUZ8z7dbrK0ax+oLT54ioOy4cl7KFPuObEd0Mpj66BR4Kn/InuL+j9L4jUEwDjE3q0Uitse8WjiPibGG1HK+UdoPkJC/guv7a2x99tueZseFQwu/k7k+tIcnL6vsxLuWNqP1shQhKxxSCRN6VMO8a3kn6QM6vAF1lzcvAersRPp3+0gZGBmlj4nVn0l5Lg89WvucI9VkvBMovofrjQr2cPs9bDWr5pX/w0iSesXZzGwcF3IqNeTetTFQ9vOsvT4UDg/cSBkgNxA1/mHrXsVQcNpI3SwoUoWBE1PLqyA6bbgZMBP3xj39WGnRkkJ9IIczibEWou2K1JKXuGmP8QUS1Xrm4vfnF1zi9t6X7n6S0fMCVWyfpkPUBIajPDsY79GXn66rL/i7wrotZzhj2SZ/Z6uDb0osvcpTmEB91rI7EYc7Zz5uD+tAQqzv+TWpxBCh6qGUjGg1x1AJmjay8sAQb0YPySrmsTznXztw7wQaLsXyIN/kx+N1FYQcPEp4japXZphg6FpHBaxJtJEoCVF2pYolNPgI7Hl2vISCZSjTeuLRdB0iJf
 PdWqIj6h
 ULUE/fTVg2p6/7+mzr+K8TbLQ1MgbdrM8dlge21tuP7AaRXyyI8vLI5pxuNfF84wzVzUtlMFWGdp+79H7FiJ/Mr1JHL0Z47Cjd7CptJmqjaRVxvstlghr6ysm6oWRYzweg+Ljftv638ZOpfIex41OFf1xmUf7n4w55XZOQAp7Eukhl467b4lJ+HZgp2eQahr/8wkeIEbplabXqBIx2svaCUhi1ikWS9d7sPpTxWc4/RQX8lUVY0tiKKmym/l7vzD/h/Bc9nxyQwAtp8fwCYDMPoMr22p8hzb0nVVI52O5InnpygWjI0Kiwn/d3NSlSQ63u8MG5AgE6IcX01v1MYALZ3VzOyb/YuHEVALyc9pxAU/8mSmpzOpn+jowa4EpzGyv8nzHldztZI6AFt/KVnZmKtLMEEFv+OJLiNn63bHHBQRFJvkCx3wivcLOASSJkhUjkMVmKdKZ6+vLZZTJyyUK6+R9u7EnFy5dKJeQ04Ynitqt0Fk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 2:02=E2=80=AFPM Zi Yan <ziy@nvidia.com> wrote:
>
> On 13 Jan 2026, at 0:39, Harry Yoo wrote:
>
> > On Mon, Jan 12, 2026 at 12:49:22AM +0000, Jiaqi Yan wrote:
> >> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> >> becomes non-HugeTLB, and it is released to buddy allocator
> >> as a high-order folio, e.g. a folio that contains 262144 pages
> >> if the folio was a 1G HugeTLB hugepage.
> >>
> >> This is problematic if the HugeTLB hugepage contained HWPoison
> >> subpages. In that case, since buddy allocator does not check
> >> HWPoison for non-zero-order folio, the raw HWPoison page can
> >> be given out with its buddy page and be re-used by either
> >> kernel or userspace.
> >>
> >> Memory failure recovery (MFR) in kernel does attempt to take
> >> raw HWPoison page off buddy allocator after
> >> dissolve_free_hugetlb_folio(). However, there is always a time
> >> window between dissolve_free_hugetlb_folio() frees a HWPoison
> >> high-order folio to buddy allocator and MFR takes HWPoison
> >> raw page off buddy allocator.
> >
> > I wonder if this is something we want to backport to -stable.
> >
> >> One obvious way to avoid this problem is to add page sanity
> >> checks in page allocate or free path. However, it is against
> >> the past efforts to reduce sanity check overhead [1,2,3].
> >>
> >> Introduce free_has_hwpoisoned() to only free the healthy pages
> >> and to exclude the HWPoison ones in the high-order folio.
> >> The idea is to iterate through the sub-pages of the folio to
> >> identify contiguous ranges of healthy pages. Instead of freeing
> >> pages one by one, decompose healthy ranges into the largest
> >> possible blocks having different orders. Every block meets the
> >> requirements to be freed via __free_one_page().
> >>
> >> free_has_hwpoisoned() has linear time complexity wrt the number
> >> of pages in the folio. While the power-of-two decomposition
> >> ensures that the number of calls to the buddy allocator is
> >> logarithmic for each contiguous healthy range, the mandatory
> >> linear scan of pages to identify PageHWPoison() defines the
> >> overall time complexity. For a 1G hugepage having several
> >> HWPoison pages, free_has_hwpoisoned() takes around 2ms on
> >> average.
> >>
> >> Since free_has_hwpoisoned() has nontrivial overhead, it is
> >> wrapped inside free_pages_prepare_has_hwpoisoned() and done
> >> only PG_has_hwpoisoned indicates HWPoison page exists and
> >> after free_pages_prepare() succeeded.
> >>
> >> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email=
-mgorman@techsingularity.net
> >> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email=
-mgorman@techsingularity.net
> >> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >>
> >> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> >>
> >> ---
> >>  mm/page_alloc.c | 157 +++++++++++++++++++++++++++++++++++++++++++++++=
-
> >>  1 file changed, 154 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >> index 822e05f1a9646..9393589118604 100644
> >> --- a/mm/page_alloc.c
> >> +++ b/mm/page_alloc.c
> >> @@ -2923,6 +2928,152 @@ static bool free_frozen_page_commit(struct zon=
e *zone,
> >>      return ret;
> >>  }
> >
> > From correctness point of view I think it looks good to me.
> > Let's see what the page allocator folks say.
> >
> > A few nits below.
> >
> >> +static bool compound_has_hwpoisoned(struct page *page, unsigned int o=
rder)
> >> +{
> >> +    if (order =3D=3D 0 || !PageCompound(page))
> >> +            return false;
> >
> > nit: since order-0 compound page is not a thing,
> > !PageCompound(page) check should cover order =3D=3D 0 case.
> >
> >> +    return folio_test_has_hwpoisoned(page_folio(page));
> >> +}
> >> +
> >> +/*
> >> + * Do free_has_hwpoisoned() when needed after free_pages_prepare().
> >> + * Returns
> >> + * - true: free_pages_prepare() is good and caller can proceed freein=
g.
> >> + * - false: caller should not free pages for one of the two reasons:
> >> + *   1. free_pages_prepare() failed so it is not safe to proceed free=
ing.
> >> + *   2. this is a compound page having some HWPoison pages, and healt=
hy
> >> + *      pages are already safely freed.
> >> + */
> >> +static bool free_pages_prepare_has_hwpoisoned(struct page *page,
> >> +                                          unsigned int order,
> >> +                                          fpi_t fpi_flags)
> >
> > nit: Hope we'll come up with a better name than
> > free_pages_prepare_has_poisoned(), but I don't have any better
> > suggestion... :)
> >
> > And I hope somebody familiar with compaction (as compaction_free() call=
s
> > free_pages_prepare() and ignores its return value) could confirm that
> > it is safe to do a compound_has_hwpoisoned() check and, when it returns
> > true, call free_has_hwpoisoned() in free_pages_prepare(),
> > so that we won't need a separate function to do this.
>
> I wrote the function. compact_control->freepages[] is an array of free
> pages isolated from buddy allocator as a temporary free page buffer.

Thanks for the context, Zi!

> I wonder if compaction_free() can get a HWPoisoned folio or not, since
> to get to compaction_free(), the folio needs to be copied to a new folio.
> If the memory goes bad, folio_mc_copy() will return -EHWPOISON to abort
> the migration, but I do not see any code marking the folio has_hwpoisoned=
.
> When it reaches to compact_free(), there is no way to detect the error.
> I think the corrupted page will be put back to buddy and be marked as
> has_hwpoison after it is allocated and accessed by an application.

IIRC compaction_free() is used to deal with the *target* folio (i.e.
dst) if migration fails for any reason, say the src folio is hardware
corrupted and folio_mc_copy() returns -EHWPOISON. We can know nothing
about the integrity of the target folio out of folio_mc_copy(), hence
no marking PG_has_hwpoisoned for target page. The src folio should
already be marked async by memory_failure_queue() in
copy_mc_highpage().

So I think to compaction_free(), it always deal with
non-PG_has_hwpoisoned folio, and there isn't any difference between
free_pages_prepare_has_hwpoisoned() and free_pages_prepare(). I can
merge them in v4.

>
> You might need to add has_hwpoisoned code in migration code path to
> catch folio_mc_copy() errors.
>
>
> Best Regards,
> Yan, Zi

