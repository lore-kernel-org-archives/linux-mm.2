Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67F04E8FDBE
	for <linux-mm@archiver.kernel.org>; Sat, 27 Dec 2025 01:51:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8733C6B0089; Fri, 26 Dec 2025 20:51:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8479C6B008A; Fri, 26 Dec 2025 20:51:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6FECA6B008C; Fri, 26 Dec 2025 20:51:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B4486B0089
	for <linux-mm@kvack.org>; Fri, 26 Dec 2025 20:51:15 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EB2D3C205D
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 01:51:14 +0000 (UTC)
X-FDA: 84263573268.16.4F778ED
Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	by imf18.hostedemail.com (Postfix) with ESMTP id DDB611C0005
	for <linux-mm@kvack.org>; Sat, 27 Dec 2025 01:51:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UArl4y7t;
	spf=pass (imf18.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1766800273; a=rsa-sha256;
	cv=pass;
	b=UAKWiDXHlih2opweci80y6NVwcdgubiUj8EKqcMxqIhf8VOg8CfRT6WBaV164fLf+hT/id
	K92mkNaZ7vgiGBkRimLoVgL3cM4eway0U56BeHyCvGhH/Oes3inRsOHfc00hrayHFcUfGe
	yKc4/t7W9ZY5h/RmwBImYQnq2lEILWg=
ARC-Authentication-Results: i=2;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UArl4y7t;
	spf=pass (imf18.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.52 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766800273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8iamH/vjyzPyEOAx2RSqABJFGddTlOdGbhl6gQNLhtk=;
	b=H0rjbmshhc8/u/wtLpdUeoYjYRZB7QinYyKOIPCbxuUCBMqkbXMo/Y+Jumkf82QPwdk2Qr
	CEnv14MfYq16SLtGLUoXNblVd0uMjBqiToowcVih9mTgiQ14g89tZ8GAWvCT0/3OtlYMqg
	xj2W/epIXeqdAtpQHH5KuXhuWOvhRhs=
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so492385e9.1
        for <linux-mm@kvack.org>; Fri, 26 Dec 2025 17:51:12 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1766800271; cv=none;
        d=google.com; s=arc-20240605;
        b=G146DdLl9sJQy5yu4J8srzNEsXDXH0SCYkx3NcgUecaFdkToZkURc/b5g0KL9hCAhV
         CCQkgFDJE9Y0VlD+kBOwIC7goHDXozqEgHBNKehSihLDMJBbaCystItXybpxDqM269tR
         SePIqMS3eYamwDPA6hInykPb1ugPmRfqE8Jyy9AVDlp2iQoWJzXQbIFacnlTEswHDZxM
         hhVmxS8wUogJTpSPMRSedQGfIDbX4UlksaO8wDHncTzLzSwhn7BXTQkkgDwf3T+xN3Xq
         7f1kJmmVN//WMEUKL8DP5s+GOsx11oTURyLQo+Q0gWBszhNaZbaCo8x9i7cnJkjbZhkX
         XaNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=8iamH/vjyzPyEOAx2RSqABJFGddTlOdGbhl6gQNLhtk=;
        fh=MLWhzcxS+oldaN+DVjo0EfwOzypoo4GdduRDuagnsmg=;
        b=E4BiCrp/ff3ToW1q04L9PyiUxRDXifCkVBQYCD+sqZu2XthDeRjMftcv5J25CpxJIo
         DMQQ8W6/PCRgySFPoeV4Ox8jYL2i/CHs7h2MZcyJGylJEekQ+tUQ+nV767+6JXny+6wJ
         jpdW/8S614aUnkSfspbIwokGMkDbsQuSXOaJN6aN5UzjNigiJcbwnm6nmWC/fBYFD/4A
         A6eQirJc2NNamL0EAko5VHQOcQcVQMVAy3aMonABnNaQ81o/D6vWtWfwiGVKaqTRebIk
         lnBWSmDg6LwQpSlnDXHIw3bsi9MT9w6mgJ6NMObnAlNK34CSM0On+P3JQBtR6LnvtDWH
         fEEQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766800271; x=1767405071; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8iamH/vjyzPyEOAx2RSqABJFGddTlOdGbhl6gQNLhtk=;
        b=UArl4y7t8f9rSpwYDBmB4/790KktL4xYAehtzO34lH9oMrXPSkk70eHzuGm+lgJVGp
         HqdFWPgQeFhUXdF1TlAfNASKwmk+IMXBmK/HoF1jJlVY7NtkwQ6Uup8lzGnDT1J3RX48
         0WF1bV7xDqzNuE/nNvFocBSxTd59sE7k5DVOyqSuR21KN+4yObm46cNwaEVWes6s2sgn
         Xdj6Y2/anOwSQNfNXE6JVIAjv1wkm0193tgDdUTwUC3k3I06oTuAH+jY/wBimIpXs1s1
         mFj133S5ZR9BCBsvIAcXLCwz4CghVXwUtUJtukyo2VTB5xG6fx2ClcVfYeXIKbq6fvKx
         ggJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766800271; x=1767405071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8iamH/vjyzPyEOAx2RSqABJFGddTlOdGbhl6gQNLhtk=;
        b=M9YaO1UKtLe6j1q8q//+U6VB2LzDhuiiWMYHx+t72JrK9zY6+lh6IC0FKG3l33vW1C
         iZbcEKdIAvjIou0XND376ra/IWoY7A6HnS/0GxmVdThM5ezjy82pHmRyFPaEkICAmQU1
         1Bh9tj305xgdaiYsTtrl9xWLB56RoKJOQshcNAovADof3QqA5J+BMfCwJKdstNGftU7V
         ueUHRnLpyespckrWjnQfZ/NVEDnLg3A0sDOOpu/9yRP9umQCojpijiin1TZECIlB7CJX
         i8hY6LLKe+2Ji7T8rgyLn3k1pRKiDGnxcb3lby3nkLukbq6m+JI7Vdj4z9QMM2zggdCY
         lapg==
X-Forwarded-Encrypted: i=1; AJvYcCV1B7HI9/55nVYlTdaRZL7OiwDjfWFk0iTiXWuRLUH9ZDbNryEP+5rEaQs8OppnkbnOxJKFUiEVxg==@kvack.org
X-Gm-Message-State: AOJu0YydMG53auJsFBK+hz9a7qgXusqSbnQHFY739734eD2dsp0TYoPG
	DH+Ju+iXWKhnQp6CdpE6FgYFumg6HioCAS7RpJ7Kaw+smI1gobXAIjmHf8nQmvN2j7XJ1LHYG/K
	BAT0I2rE9zA5L2AZs/jOSGkXnoj+R3leto/EQ1xUN
X-Gm-Gg: AY/fxX55FFm4Kj0pdDoMomVs6abKh+R2dv73X25yNZxu65vncmJWcsLIycpjhYugrBU
	y1KTGKnqV3hRFF/14pcP4klkp7CxkVtClrERyMGnrnwYZaVFUX9cKd1CFEjk4vCaeyvZS7bc6pr
	pt4fdLzJxdezbkuDxLWGbXmHhqzWY7B9U8HOkbCRwGhUpiVaW9tKvPcZN8cf7mznjixd7nE1gEN
	4ZPIQ7TQ1/sZvzVQ1t3uJAXKlWpMpS8CMawNU1AXX/ipqx4XMB4iofV16e+dG5RmOIvNwBuFWoq
	A0vTdW17ocDKG/rjoE6hKtQp6EoTlaoY4OsL66s=
X-Google-Smtp-Source: AGHT+IHKGgJDrmc+jrDk0q2odeqPet3rvhWe0gVL/uXQIfWrbbDEVi3ydKyHK7rkdDzUEqdvf/zOdv30yVhYGoKbHxQ=
X-Received: by 2002:a05:600c:a29e:b0:477:95a8:2565 with SMTP id
 5b1f17b1804b1-47d3c6f2391mr1113185e9.16.1766800271231; Fri, 26 Dec 2025
 17:51:11 -0800 (PST)
MIME-Version: 1.0
References: <20251219183346.3627510-1-jiaqiyan@google.com> <20251219183346.3627510-3-jiaqiyan@google.com>
 <aUolGHkJQwKi0A8A@hyeyoo>
In-Reply-To: <aUolGHkJQwKi0A8A@hyeyoo>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 26 Dec 2025 17:50:59 -0800
X-Gm-Features: AQt7F2qh8OpTjhRYWoaytZZ9Fck7OuAMJtNyXmKtkw4i6PPcuvp3RS3OFVprmOA
Message-ID: <CACw3F52hZp+xC51bK=UfrfdAWdFEEqhsiJY2+0fzCLzB_3=XYg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] mm/page_alloc: only free healthy pages in
 high-order HWPoison folio
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
X-Rspam-User: 
X-Rspamd-Queue-Id: DDB611C0005
X-Rspamd-Server: rspam04
X-Stat-Signature: 8zsrrs7y75fi9soie446zhhbut79uqoa
X-HE-Tag: 1766800272-283653
X-HE-Meta: U2FsdGVkX19JJftoocpIeFGKmVihAhH5M709PYaVZcsEyJhfybxM6vcQHAUc0ejf9oUrMXOPgCEVlBV9EYHA0MTnoYGN0qP4b4g3avqbxgGXRnGYzB46Z1v11uSXnMyXuF9ZJ8yIYPOUiy0D4hbqDY7AfMzCfFYYvkXe9ubfAudtbMpfESUagTLEC1+s4a4Dk4ozpv4NmWZZbA7KzshXGkZxo/3Neu7DLnPxCxx0LrB1B5FrXhyEoQy2fUkUCYl3tzJbCryh5N/67Z1UYH4OPlJVFO3p5AK8dIMunSrUSL+4U3FW3oNZ74EUEdIaQ75GK1M/dUKcsFT9LOMnOielsE7V8RxC7/mefDiaxLob62IWnFral8wGLYOHx1q9vseHtMfl07a9TOzboF3u1n/foRATHzbCEZurbcEIH14JYEaPcvsCQ8qkb1gvSPtUozPjdv5ytubkYI1ikYUs17r7sL1fGkInbIp5l+zrMRY4eZFVYOSE+lUO3L06mX7ZQe1KKfsYHZ/e3yYkoEm5KO/GPujpobyFC72Z2PZL16Z04Y+QH5x0oLOlev+J6ssp1eWbyAhOmO0NtCQwpcI6bVPruHxRod4Ba/u4S0wwBnGXzneL1FR8G9dlYKPrx4jlwYn8voPjD0/z3HDwFvxhmluIBRBXjsHNP0wYWw+Jy5tG5SVhDU4XXIenC8toekVks6Z8pHZVg7kW/Az/sNaOsbIwjE6ArtWo2+buhRyNAe4tIhJ9najSCKcnPk0gj0c7U5m5PoVESQGmGWoDcMtd9QBkY5ZU4dJduGgOnakEI0aDTauDUk9NPhmDWe8/26Dvys4Jt1BA3WuUB/v5k1iV66hbDokgMQiqk9Q//uMU1uQLGexiTZo4tyQb4tHN+whZnDfDAwMOv/3cU1KkxR9fRewwGtaRHogA489roGo9JB/pZGtVA8ecrqmj12IZnrpta0nZaHjH+WY11APzhzlyCIZ
 MRLoDAoi
 tL+zb+DxolPiS6qkJijRz4nf/uS7ny8fEDPTmWOHftHEEWQfAk8YCTreBjITDRqWWp6wqjPz4WauSXQa2kvvSOW3ZRPkpfaTaQe4b9coSONU3LsM8zFhMJqEeoMw/mhpVdJ+W9HWHs9SmuuANgkwotrBstWGqj1QC/LT1r4P5wC5M+lMxdG0Y3yfqpvTfqw1Jf3ZUjwyOAhYllyT0lKCf7KATZ0ApynLVN0fS/NLjnOTB2Tum7cBmFZGMdF0H1YVgBUvAAvwkB8im3mq0lhPegRAgqYErNuvx3XVOZg/Yg8XnlFuHAt3VmXWIjgVw3wXkhDvHYkytKarPncdiSaeZTR+fBFVlVXQtwq8ztvLHgHJdBvFnEalGzwIw0erdUzJASLvUrT8mt+LU8rO2R1T+Z2bHXyDyuY76tdA+sfnn+UxRe+U4vTQ6LYhHjVsNXq1UU9nsxLAUNpDFXB3fEAWFk4WMBSAzkCCv0lAYhlNCcADR5Xg=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 22, 2025 at 9:14=E2=80=AFPM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Fri, Dec 19, 2025 at 06:33:45PM +0000, Jiaqi Yan wrote:
> > At the end of dissolve_free_hugetlb_folio that a free HugeTLB
> > folio becomes non-HugeTLB, it is released to buddy allocator
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
> > dissolve_free_hugetlb_folio. However, there is always a time
> > window between dissolve_free_hugetlb_folio frees a HWPoison
> > high-order folio to buddy allocator and MFR takes HWPoison
> > raw page off buddy allocator.
> >
> > One obvious way to avoid this problem is to add page sanity
> > checks in page allocate or free path. However, it is against
> > the past efforts to reduce sanity check overhead [1,2,3].
> >
> > Introduce free_has_hwpoison_pages to only free the healthy
> > pages and excludes the HWPoison ones in the high-order folio.
> > The idea is to iterate through the sub-pages of the folio to
> > identify contiguous ranges of healthy pages. Instead of freeing
> > pages one by one, decompose healthy ranges into the largest
> > possible blocks. Each block meets the requirements to be freed
> > to buddy allocator (__free_frozen_pages).
> >
> > free_has_hwpoison_pages has linear time complexity O(N) wrt the
> > number of pages in the folio. While the power-of-two decomposition
> > ensures that the number of calls to the buddy allocator is
> > logarithmic for each contiguous healthy range, the mandatory
> > linear scan of pages to identify PageHWPoison defines the
> > overall time complexity.
>
> Hi Jiaqi, thanks for the patch!

Thanks for your review/comments!

>
> Have you tried measuring the latency of free_has_hwpoison_pages() when
> a few pages in a 1GB folio are hwpoisoned?
>
> Just wanted to make sure we don't introduce a possible soft lockup...
> Or am I worrying too much?

In my local tests, freeing a 1GB folio with 1 / 3 / 8 HWPoison pages,
I never run into a soft lockup. The 8-HWPoison-page case takes more
time than other cases, meaning that handling the additional HWPoison
page adds to the time cost.

After adding some instrument code, 10 sample runs of
free_has_hwpoison_pages with 8 HWPoison pages:
- observed mean is 7.03 ms (5.97 ms when 3 HWPoison pages)
- observed standard deviation is 0.76 ms (0.18 ms when 3 HWPoison pages)

In comparison, freeing a 1G folio without any HWPoison pages 10 times
(with same kernel config):
- observed mean is 3.39 ms
- observed standard deviation is 0.16ms

So it's around twice the baseline. It should be far from triggering a
soft lockup, and the cost seems fair for handling exceptional hardware
memory errors.

I can add these measurements in future revisions.

>
> > [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-email-=
mgorman@techsingularity.net/
> > [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-email-=
mgorman@techsingularity.net/
> > [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> > ---
> >  mm/page_alloc.c | 101 ++++++++++++++++++++++++++++++++++++++++++++++++
> >  1 file changed, 101 insertions(+)
> >
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index 822e05f1a9646..20c8862ce594e 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -2976,8 +2976,109 @@ static void __free_frozen_pages(struct page *pa=
ge, unsigned int order,
> >       }
> >  }
> >
> > +static void prepare_compound_page_to_free(struct page *new_head,
> > +                                       unsigned int order,
> > +                                       unsigned long flags)
> > +{
> > +     new_head->flags.f =3D flags & (~PAGE_FLAGS_CHECK_AT_FREE);
> > +     new_head->mapping =3D NULL;
> > +     new_head->private =3D 0;
> > +
> > +     clear_compound_head(new_head);
> > +     if (order)
> > +             prep_compound_page(new_head, order);
> > +}
>
> Not sure why it's building compound pages, just to decompose them
> when freeing via __free_frozen_pages()?

prepare_compound_page_to_free() borrowed the idea from
__split_folio_to_order(). Conceptually the original folio is split
into new compound pages with different orders; here this is done on
the fly in free_contiguous_pages() when order is decided.
__free_frozen_pages() is also happy with a compound page when order >
0, as I tested with free_pages_prepare before calling
__free_frozen_pages().

>
> If you intended to reset compound head & tails, I think it's more
> readable to decompose the whole compound page at once and not build
> compound pages when freeing it?

I don't think prepare_compound_page_to_free() is that hard to read,
but I'm open to more opinions.

>
> > +/*
> > + * Given a range of pages physically contiguous physical, efficiently
> > + * free them in blocks that meet __free_frozen_pages's requirements.
> > + */
> > +static void free_contiguous_pages(struct page *curr, struct page *next=
,
> > +                               unsigned long flags)
> > +{
> > +     unsigned int order;
> > +     unsigned int align_order;
> > +     unsigned int size_order;
> > +     unsigned long pfn;
> > +     unsigned long end_pfn =3D page_to_pfn(next);
> > +     unsigned long remaining;
> > +
> > +     /*
> > +      * This decomposition algorithm at every iteration chooses the
> > +      * order to be the minimum of two constraints:
> > +      * - Alignment: the largest power-of-two that divides current pfn=
.
> > +      * - Size: the largest power-of-two that fits in the
> > +      *   current remaining number of pages.
> > +      */
> > +     while (curr < next) {
> > +             pfn =3D page_to_pfn(curr);
> > +             remaining =3D end_pfn - pfn;
> > +
> > +             align_order =3D ffs(pfn) - 1;
> > +             size_order =3D fls_long(remaining) - 1;
> > +             order =3D min(align_order, size_order);
> > +
> > +             prepare_compound_page_to_free(curr, order, flags);
> > +             __free_frozen_pages(curr, order, FPI_NONE);
> > +             curr +=3D (1UL << order);
> > +     }
> > +
> > +     VM_WARN_ON(curr !=3D next);
> > +}
> > +
> > +/*
> > + * Given a high-order compound page containing certain number of HWPoi=
son
> > + * pages, free only the healthy ones to buddy allocator.
> > + *
> > + * It calls __free_frozen_pages O(2^order) times and cause nontrivial
> > + * overhead. So only use this when compound page really contains HWPoi=
son.
> > + *
> > + * This implementation doesn't work in memdesc world.
> > + */
> > +static void free_has_hwpoison_pages(struct page *page, unsigned int or=
der)
> > +{
> > +     struct page *curr =3D page;
> > +     struct page *end =3D page + (1 << order);
> > +     struct page *next;
> > +     unsigned long flags =3D page->flags.f;
> > +     unsigned long nr_pages;
> > +     unsigned long total_freed =3D 0;
> > +     unsigned long total_hwp =3D 0;
> > +
> > +     VM_WARN_ON(flags & PAGE_FLAGS_CHECK_AT_FREE);
> > +
> > +     while (curr < end) {
> > +             next =3D curr;
> > +             nr_pages =3D 0;
> > +
> > +             while (next < end && !PageHWPoison(next)) {
> > +                     ++next;
> > +                     ++nr_pages;
> > +             }
> > +
> > +             if (PageHWPoison(next))
> > +                     ++total_hwp;
> > +
> > +             free_contiguous_pages(curr, next, flags);
>
> page_owner, memory profiling (anything else?) will be confused
> because it was allocated as a larger size, but we're freeing only
> some portion of it.

I am not sure, but looking at __split_unmapped_folio, it calls
pgalloc_tag_split(folio, old_order, split_order) when splitting an
old_order-order folio into a new split_order.

Maybe prepare_compound_page_to_free really should
update_page_tag_ref(), I need to take a closer look at this with
CONFIG_MEM_ALLOC_PROFILING (not something I usually enable).

>
> Perhaps we need to run some portion of this code snippet
> (from free_pages_prepare()), before freeing portions of it:
>
>         page_cpupid_reset_last(page);
>         page->flags.f &=3D ~PAGE_FLAGS_CHECK_AT_PREP;
>         reset_page_owner(page, order);
>         page_table_check_free(page, order);
>         pgalloc_tag_sub(page, 1 << order);

Since they come from free_pages_prepare, I believe these lines are
already executed via free_contiguous_pages()=3D> __free_frozen_pages()=3D>
free_pages_prepare(), right? Or am I missing something?

>
> > +             total_freed +=3D nr_pages;
> > +             curr =3D PageHWPoison(next) ? next + 1 : next;
> > +     }
> > +
> > +     pr_info("Excluded %lu hwpoison pages from folio\n", total_hwp);
> > +     pr_info("Freed %#lx pages from folio\n", total_freed);
> > +}
> > +
> >  void free_frozen_pages(struct page *page, unsigned int order)
> >  {
> > +     struct folio *folio =3D page_folio(page);
> > +
> > +     if (order > 0 && unlikely(folio_test_has_hwpoisoned(folio))) {
> > +             folio_clear_has_hwpoisoned(folio);
> > +             free_has_hwpoison_pages(page, order);
> > +             return;
> > +     }
> > +
>
> It feels like it's a bit random place to do has_hwpoisoned check.
> Can we move this to free_pages_prepare() where we have some
> sanity checks (and also order-0 hwpoison page handling)?

While free_pages_prepare() seems to be a better place to do the
has_hwpoisoned check, it is not a good place to do
free_has_hwpoison_pages().


>
> >       __free_frozen_pages(page, order, FPI_NONE);
> >  }
> >
> > --
> > 2.52.0.322.g1dd061c0dc-goog
>
> --
> Cheers,
> Harry / Hyeonggon

