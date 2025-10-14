Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F445CCD18D
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 12:47:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8667B8E0109; Tue, 14 Oct 2025 08:47:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 816C08E000D; Tue, 14 Oct 2025 08:47:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6DECC8E0109; Tue, 14 Oct 2025 08:47:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 523598E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 08:47:06 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1FAB911B04B
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:47:06 +0000 (UTC)
X-FDA: 83996694852.11.D7447CC
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com [209.85.167.52])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4B7208000E
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 12:47:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hkKS/3l6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760446024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OOYDAUUrPF9BNX7d43RB9kvFca4sRiuUrwceAzjG9h0=;
	b=rBUfo+BAAsHuDPahwIWUsHxLv7kuvfIpYTBjfrbxD0mrsdufg5dKHAcQLLEyZpVVDgGdH7
	wXfB+yadAuMOa7zv5ME6Y2UZZ5hRypM7hHHQi7ECOsmKL9csLcmC/F6HhixamAUZQasZGV
	/YLfOPd5uW9WMp/DxmPgpqVDQg72YbI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760446024; a=rsa-sha256;
	cv=none;
	b=GXoO0fGHPM1t+HXou6mSfTveBY2poPkWIaePAQzTgHEnR7weZ1toHDh8MM0vpzDha8OTJn
	v19FqR2Ocw26ipXxeXuCyD7XZ0+OEDCz0bv/UXyukI+0RbFk0HuKN4guArfaUE51Z0r03q
	sahcDZESU3snRV3ZmN3XPbsTdbaPR5k=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="hkKS/3l6";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of huangzhaoyang@gmail.com designates 209.85.167.52 as permitted sender) smtp.mailfrom=huangzhaoyang@gmail.com
Received: by mail-lf1-f52.google.com with SMTP id 2adb3069b0e04-57a8b00108fso999644e87.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 05:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760446023; x=1761050823; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OOYDAUUrPF9BNX7d43RB9kvFca4sRiuUrwceAzjG9h0=;
        b=hkKS/3l6gsf65kDnI/KXhVUGJ1inJCWwJ6ULU/RY1r+XwcLWVzYWs6ydoirzKsvho/
         5euNv6Fsjg2Xywp6Yi1RYCu4OBT+H3B8BLOD5jDSb46TBYyjCaL0r7MyGv/HXCSi3QP0
         1MUAU+I94Qfx8KJ/nEUxAe7lb63AAR1QoQjEVlKn9to2LquNMZ7nB48D5hnq1X9BDbf9
         jWXxi7P1E4sijfclWj106vSp+JRu0QIlcSq8RcnZk9D/sDSPlZsDqhLcOrUks3X5EJmb
         7PuZIa3WfqQdjG+9YMZrqdQnsfIE+kJPUcPnpNs1YVg2LHd91vKcjjhi89L2xr3dszJT
         I6pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760446023; x=1761050823;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OOYDAUUrPF9BNX7d43RB9kvFca4sRiuUrwceAzjG9h0=;
        b=ayBi+gR8rUk5xB3x3zuHl6B9soiBQYufxKDGqfCa2eiYT+w6+dR/Y17PdvvZxN+mGt
         s0+A2F3y+4Q8anbMsxAJtZqFLgTHj66Ky0QB8InTZY1UttWhgSc6SnT2NUVladoMw4ns
         NuKD2/Lkhi/wfok+Diz+mZuL7/yxBpmd7mk6FuwKtRCZtr2+21iq4QD9qYJoKop58qeU
         q750cDCgpkn/bvWzmtx+pHPWDW3v9mFN0huiKrHBvfULhsfSGg3AnrnMjjLi0hUMeL7b
         PjL5XZqp+KNRhajPl/e3/9s1onyi3cK/nY2OzMOmRhSdeY/WeTIAOnXAYIpGet26sC+u
         7Vbg==
X-Forwarded-Encrypted: i=1; AJvYcCVQ0hRuWUIYmWzxGfjGZEV57VgYVaCLjJT+Wk3dBuFdvtecbSiYGpZ17rtDvE/lynGmXHCRLLk1cA==@kvack.org
X-Gm-Message-State: AOJu0YyV+efOnZnF7E06w9VexdFpyAL9HzYPZNKMiNODK6AL15yqSJdM
	AY0ni2uBBQw7/obiBaW+Rw9JjlaMONnJGzxgrM7lbzwIs4BCqA10GCqdGdw6WkIPvJRuRPDWImp
	ppbX7RHvkatzVZCrW+OEfGGSSG76aKBs=
X-Gm-Gg: ASbGncvuuF7kME/sUxZFw8lG7YjmFuMdoX7Lwqg/sMfvp32w8gvRIeJNZ1+G+zUbXHS
	/JsVWiyoe4JwIgfqPYwz3eo8VvvlOcvTQi+7O48+pZKd2WTPQnUh0rG+45d1hmELo0Hecq8WBN5
	/W0lrPDZTcqGt8wIfGDksKK4UddxL31nnXY0eM8RmYCjJ3wHVslBhrAwG2tX0R97pFmQdyREHxq
	lKJWkYUyVYgatoFXGgheChWtmg=
X-Google-Smtp-Source: AGHT+IFlO5uSigu5dtEPUFsiPorGQT8JHKN9gDGfcyR2bXSQJaHthPRim/dru6Buj5TcNFP99XIzDYgEUyJNtMVBif8=
X-Received: by 2002:a2e:beab:0:b0:36b:d9d2:7352 with SMTP id
 38308e7fff4ca-37609cebacdmr36943081fa.1.1760446022264; Tue, 14 Oct 2025
 05:47:02 -0700 (PDT)
MIME-Version: 1.0
References: <20251014083230.1181072-1-zhaoyang.huang@unisoc.com>
 <20251014083230.1181072-2-zhaoyang.huang@unisoc.com> <20251014114124.145165bc@mordecai.tesarici.cz>
In-Reply-To: <20251014114124.145165bc@mordecai.tesarici.cz>
From: Zhaoyang Huang <huangzhaoyang@gmail.com>
Date: Tue, 14 Oct 2025 20:46:48 +0800
X-Gm-Features: AS18NWCZqvwBFj414D2SlPbku69nYjWV6cLatwbTi_BHqfCcVjP0WhD8gi8qGCk
Message-ID: <CAGWkznEPqsORQCiGqpjSp6XTvtHov76EGw830hxXmrUxd2U_4w@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm: call back alloc_pages_bulk_list since it is useful
To: Petr Tesarik <ptesarik@suse.com>
Cc: "zhaoyang.huang" <zhaoyang.huang@unisoc.com>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@redhat.com>, Matthew Wilcox <willy@infradead.org>, 
	Mel Gorman <mgorman@techsingularity.net>, Vlastimil Babka <vbabka@suse.cz>, 
	Sumit Semwal <sumit.semwal@linaro.org>, 
	Benjamin Gaignard <benjamin.gaignard@collabora.com>, Brian Starkey <Brian.Starkey@arm.com>, 
	John Stultz <jstultz@google.com>, "T . J . Mercier" <tjmercier@google.com>, 
	=?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>, 
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linaro-mm-sig@lists.linaro.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, steve.kang@unisoc.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4B7208000E
X-Rspamd-Server: rspam02
X-Stat-Signature: q1f5w6z31xsdwxz96dchfc35pruy18k9
X-HE-Tag: 1760446024-806987
X-HE-Meta: U2FsdGVkX1/Y/aymWf2HqYbTLZgm9SddbcaDlJUzjF0TyzGzMXlzy3UvrCGGmVB+pOc3RCZovs/PCSqlmHYX04s/klzpayyO7GWCPomOVyUWKOU4KS4O7CXt1rkOHrzrb1k+yyWQF1E6U+4tOgXAhIDemhWs4kZt35EstFmAHJxOzwb6qoQdDXK8OIyRDw/d6NPIrotykLrMCphB4hAEc9Hg9+c+oz1ygTEOA50bYmuGzt2gPZW7mb6tcQ6oBBdNyC1O5QzY/UcrNsmaZU4LhUbSLSxg3yWLXATxtXaYnlcahZOX26BEtQOndYVYORhgsWQ+Pn5v9zw5Q9QJ5W3I4TRC/B22MywxyH/WQjSRhBrKNxahxGIB8ViIN7dWL4lvi2wSs+guU/gw/4ai1e8cEV3q5Aktw7bxb3Ui4Tj8PN2QZ+u16aBWk4cTM8g6M76W8Bpn0H5EMGlfWXz/ATQD0tZ/MbsQ3PNYuOxuZArNVA7xJ9BkGgLXFYwxpC6atWbZwA/wftYQ4T9O7lAoXTsAFAngdBoVZ9x7pmxASHmq4zfmH8RmlEiCbTThZH0iBF0dRYs4pwR3OUNRQmFKf2ue5Bqjadq2481s5pUyEzuF67EXMOxrTZB1xaRSOr9sliW+BUAXCMtGwFZkXy6fQrdG/TKLSd2djfHkb3xufFySpP/YUEbacRZcDruB+6te5lFm8ujCAZ9Rf0bP1Ex2Dm3cBVovzo+yErkYnbSD/88/YN+0l+Y2q9grsY2M7a59rml2w6qYOKPN3JmmCpKb7TW/VTGrIH8A/+JeuMUiuBOBxSMc3fKyqhfVLssY8XZ4/3D9iWHGvqBK16Hus2pioA926i6rla+idoph++KdFZu2aYCIYDZ+a8LrzJHTnwlOsiruS9IFnqOhvO16aDrCMSqp0lMh6Nrs+iFl/prsmWeRuz/sSulNQL1QIj9JFykFUrGPIKwu/fEjReoLP1HEmED
 CbR+AXmg
 1mdupxYp1ba70+4elm5CY2GBZzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 5:41=E2=80=AFPM Petr Tesarik <ptesarik@suse.com> wr=
ote:
>
> On Tue, 14 Oct 2025 16:32:29 +0800
> "zhaoyang.huang" <zhaoyang.huang@unisoc.com> wrote:
>
> > From: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> >
> > commit c8b979530f27 ("mm: alloc_pages_bulk_noprof: drop page_list
> > argument") drops alloc_pages_bulk_list. This commit would like to call =
back
> > it since it is proved to be helpful to the drivers which allocate a bul=
k of
> > pages(see patch of 2 in this series ).
> > I do notice that Matthew's comment of the time cost of iterating a list=
.
> > However, I also observed in our test that the extra page_array's alloca=
tion
> > could be more expensive than cpu iteration when direct reclaiming happe=
ns
> > when ram is low[1]. IMHO, could we leave the API here to have the users
> > choose between the array or list according to their scenarios.
>
> OK, so this is more or less a revert of commit c8b979530f27 ("mm:
> alloc_pages_bulk_noprof: drop page_list argument")...
>
> I cannot comment on the performance gains, but I dislike the fact that
> the patch re-introduces alloc_pages_bulk_noprof() as a function with two
> signatures (either page_list is used, or page_array is used).
>
> If we can agree that allocations onto a linked list are useful, then I
> suggest to split the existing function so that the common bits end up
> in helper functions, called by both variants (one function using a
> list, one using an array).
Yes. That is also what I wanted to do in the beginning. I will
implement if dma-buf would like to take the change
>
> Petr T
>
> > [1]
> > android.hardwar-728     [002] .....   334.573875: system_heap_do_alloca=
te: Execution time: order 0 1 us
> > android.hardwar-728     [002] .....   334.573879: system_heap_do_alloca=
te: Execution time: order 0 2 us
> > android.hardwar-728     [002] .....   334.574239: system_heap_do_alloca=
te: Execution time: order 0 354 us
> > android.hardwar-728     [002] .....   334.574247: system_heap_do_alloca=
te: Execution time: order 0 4 us
> > android.hardwar-728     [002] .....   334.574250: system_heap_do_alloca=
te: Execution time: order 0 2 us
> >
> > Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
> > ---
> >  include/linux/gfp.h |  9 +++++++--
> >  mm/mempolicy.c      | 14 +++++++-------
> >  mm/page_alloc.c     | 39 +++++++++++++++++++++++++++------------
> >  3 files changed, 41 insertions(+), 21 deletions(-)
> >
> > diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> > index 5ebf26fcdcfa..f1540c9fcd87 100644
> > --- a/include/linux/gfp.h
> > +++ b/include/linux/gfp.h
> > @@ -231,6 +231,7 @@ struct folio *__folio_alloc_noprof(gfp_t gfp, unsig=
ned int order, int preferred_
> >
> >  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> >                               nodemask_t *nodemask, int nr_pages,
> > +                             struct list_head *page_list,
> >                               struct page **page_array);
> >  #define __alloc_pages_bulk(...)                      alloc_hooks(alloc=
_pages_bulk_noprof(__VA_ARGS__))
> >
> > @@ -242,7 +243,11 @@ unsigned long alloc_pages_bulk_mempolicy_noprof(gf=
p_t gfp,
> >
> >  /* Bulk allocate order-0 pages */
> >  #define alloc_pages_bulk(_gfp, _nr_pages, _page_array)               \
> > -     __alloc_pages_bulk(_gfp, numa_mem_id(), NULL, _nr_pages, _page_ar=
ray)
> > +     __alloc_pages_bulk(_gfp, numa_mem_id(), NULL, _nr_pages, NULL, _p=
age_array)
> > +
> > +#define alloc_pages_bulk_list(_gfp, _nr_pages, _list)                 =
       \
> > +     __alloc_pages_bulk(_gfp, numa_mem_id(), NULL, _nr_pages, _list, N=
ULL)
> > +
> >
> >  static inline unsigned long
> >  alloc_pages_bulk_node_noprof(gfp_t gfp, int nid, unsigned long nr_page=
s,
> > @@ -251,7 +256,7 @@ alloc_pages_bulk_node_noprof(gfp_t gfp, int nid, un=
signed long nr_pages,
> >       if (nid =3D=3D NUMA_NO_NODE)
> >               nid =3D numa_mem_id();
> >
> > -     return alloc_pages_bulk_noprof(gfp, nid, NULL, nr_pages, page_arr=
ay);
> > +     return alloc_pages_bulk_noprof(gfp, nid, NULL, nr_pages, NULL, pa=
ge_array);
> >  }
> >
> >  #define alloc_pages_bulk_node(...)                           \
> > diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> > index eb83cff7db8c..26274302ee01 100644
> > --- a/mm/mempolicy.c
> > +++ b/mm/mempolicy.c
> > @@ -2537,13 +2537,13 @@ static unsigned long alloc_pages_bulk_interleav=
e(gfp_t gfp,
> >               if (delta) {
> >                       nr_allocated =3D alloc_pages_bulk_noprof(gfp,
> >                                       interleave_nodes(pol), NULL,
> > -                                     nr_pages_per_node + 1,
> > +                                     nr_pages_per_node + 1, NULL,
> >                                       page_array);
> >                       delta--;
> >               } else {
> >                       nr_allocated =3D alloc_pages_bulk_noprof(gfp,
> >                                       interleave_nodes(pol), NULL,
> > -                                     nr_pages_per_node, page_array);
> > +                                     nr_pages_per_node, NULL, page_arr=
ay);
> >               }
> >
> >               page_array +=3D nr_allocated;
> > @@ -2593,7 +2593,7 @@ static unsigned long alloc_pages_bulk_weighted_in=
terleave(gfp_t gfp,
> >       if (weight && node_isset(node, nodes)) {
> >               node_pages =3D min(rem_pages, weight);
> >               nr_allocated =3D __alloc_pages_bulk(gfp, node, NULL, node=
_pages,
> > -                                               page_array);
> > +                                               NULL, page_array);
> >               page_array +=3D nr_allocated;
> >               total_allocated +=3D nr_allocated;
> >               /* if that's all the pages, no need to interleave */
> > @@ -2658,7 +2658,7 @@ static unsigned long alloc_pages_bulk_weighted_in=
terleave(gfp_t gfp,
> >               if (!node_pages)
> >                       break;
> >               nr_allocated =3D __alloc_pages_bulk(gfp, node, NULL, node=
_pages,
> > -                                               page_array);
> > +                                               NULL, page_array);
> >               page_array +=3D nr_allocated;
> >               total_allocated +=3D nr_allocated;
> >               if (total_allocated =3D=3D nr_pages)
> > @@ -2682,11 +2682,11 @@ static unsigned long alloc_pages_bulk_preferred=
_many(gfp_t gfp, int nid,
> >       preferred_gfp &=3D ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
> >
> >       nr_allocated  =3D alloc_pages_bulk_noprof(preferred_gfp, nid, &po=
l->nodes,
> > -                                        nr_pages, page_array);
> > +                                        nr_pages, NULL, page_array);
> >
> >       if (nr_allocated < nr_pages)
> >               nr_allocated +=3D alloc_pages_bulk_noprof(gfp, numa_node_=
id(), NULL,
> > -                             nr_pages - nr_allocated,
> > +                             nr_pages - nr_allocated, NULL,
> >                               page_array + nr_allocated);
> >       return nr_allocated;
> >  }
> > @@ -2722,7 +2722,7 @@ unsigned long alloc_pages_bulk_mempolicy_noprof(g=
fp_t gfp,
> >       nid =3D numa_node_id();
> >       nodemask =3D policy_nodemask(gfp, pol, NO_INTERLEAVE_INDEX, &nid)=
;
> >       return alloc_pages_bulk_noprof(gfp, nid, nodemask,
> > -                                    nr_pages, page_array);
> > +                                    nr_pages, NULL, page_array);
> >  }
> >
> >  int vma_dup_policy(struct vm_area_struct *src, struct vm_area_struct *=
dst)
> > diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> > index d1d037f97c5f..a95bdd8cbf5b 100644
> > --- a/mm/page_alloc.c
> > +++ b/mm/page_alloc.c
> > @@ -4940,23 +4940,28 @@ static inline bool prepare_alloc_pages(gfp_t gf=
p_mask, unsigned int order,
> >  }
> >
> >  /*
> > - * __alloc_pages_bulk - Allocate a number of order-0 pages to an array
> > + * __alloc_pages_bulk - Allocate a number of order-0 pages to a list o=
r array
> >   * @gfp: GFP flags for the allocation
> >   * @preferred_nid: The preferred NUMA node ID to allocate from
> >   * @nodemask: Set of nodes to allocate from, may be NULL
> > - * @nr_pages: The number of pages desired in the array
> > - * @page_array: Array to store the pages
> > + * @nr_pages: The number of pages desired on the list or array
> > + * @page_list: Optional list to store the allocated pages
> > + * @page_array: Optional array to store the pages
> >   *
> >   * This is a batched version of the page allocator that attempts to
> > - * allocate nr_pages quickly. Pages are added to the page_array.
> > + * allocate nr_pages quickly. Pages are added to page_list if page_lis=
t
> > + * is not NULL, otherwise it is assumed that the page_array is valid.
> >   *
> > - * Note that only NULL elements are populated with pages and nr_pages
> > + * For lists, nr_pages is the number of pages that should be allocated=
.
> > + *
> > + * For arrays, only NULL elements are populated with pages and nr_page=
s
> >   * is the maximum number of pages that will be stored in the array.
> >   *
> > - * Returns the number of pages in the array.
> > + * Returns the number of pages on the list or array.
> >   */
> >  unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
> >                       nodemask_t *nodemask, int nr_pages,
> > +                     struct list_head *page_list,
> >                       struct page **page_array)
> >  {
> >       struct page *page;
> > @@ -4974,7 +4979,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, =
int preferred_nid,
> >        * Skip populated array elements to determine if any pages need
> >        * to be allocated before disabling IRQs.
> >        */
> > -     while (nr_populated < nr_pages && page_array[nr_populated])
> > +     while (page_array && nr_populated < nr_pages && page_array[nr_pop=
ulated])
> >               nr_populated++;
> >
> >       /* No pages requested? */
> > @@ -4982,7 +4987,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, =
int preferred_nid,
> >               goto out;
> >
> >       /* Already populated array? */
> > -     if (unlikely(nr_pages - nr_populated =3D=3D 0))
> > +     if (unlikely(page_array && nr_pages - nr_populated =3D=3D 0))
> >               goto out;
> >
> >       /* Bulk allocator does not support memcg accounting. */
> > @@ -5064,7 +5069,7 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, =
int preferred_nid,
> >       while (nr_populated < nr_pages) {
> >
> >               /* Skip existing pages */
> > -             if (page_array[nr_populated]) {
> > +             if (page_array && page_array[nr_populated]) {
> >                       nr_populated++;
> >                       continue;
> >               }
> > @@ -5083,7 +5088,11 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp,=
 int preferred_nid,
> >
> >               prep_new_page(page, 0, gfp, 0);
> >               set_page_refcounted(page);
> > -             page_array[nr_populated++] =3D page;
> > +             if (page_list)
> > +                     list_add(&page->lru, page_list);
> > +             else
> > +                     page_array[nr_populated] =3D page;
> > +             nr_populated++;
> >       }
> >
> >       pcp_spin_unlock(pcp);
> > @@ -5100,8 +5109,14 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp,=
 int preferred_nid,
> >
> >  failed:
> >       page =3D __alloc_pages_noprof(gfp, 0, preferred_nid, nodemask);
> > -     if (page)
> > -             page_array[nr_populated++] =3D page;
> > +     if (page) {
> > +             if (page_list)
> > +                     list_add(&page->lru, page_list);
> > +             else
> > +                     page_array[nr_populated] =3D page;
> > +             nr_populated++;
> > +     }
> > +
> >       goto out;
> >  }
> >  EXPORT_SYMBOL_GPL(alloc_pages_bulk_noprof);
>

