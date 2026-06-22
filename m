Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76D82CDB466
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 01:12:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 186776B0088; Sun, 21 Jun 2026 21:12:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 138A76B008A; Sun, 21 Jun 2026 21:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F40ED6B008C; Sun, 21 Jun 2026 21:12:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C53DA6B0088
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 21:12:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3A3EA1C53B7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:12:51 +0000 (UTC)
X-FDA: 84905774142.28.27AC06A
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf10.hostedemail.com (Postfix) with ESMTP id 28A1FC0002
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 01:12:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YzOLMTYb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782090769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e7kbiKMRI+jitrHRbCNiHZbHykLGyvKeS/qNMb56MY4=;
	b=xw0gX9rGyps69AOoTC1ySm+JGkAPYv18zIONN3PZcmJfMPH9ZPjnBZCCpxyx5032sRaxwB
	vYaNYvmrNJXOBlHhNUPG3NyxZKfkoBg9L3XNCBZOLtVVBrVRwdaOY0KzShjuXqTuUEodT6
	6t4HFqAttlUw3F3OLnXasgbcyDl860Q=
ARC-Authentication-Results: i=2;
	imf10.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=YzOLMTYb;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf10.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782090769;
	b=tNF+MynD4n1WpadJ60sKzTmjiiT8kq9P0J6BR+QyrqDwSw+4nExHOkJ8MRhNpYy5flfOKq
	7oAKLrV5i1QLjQHbQjnAUBjXUF8Z8v+71wvfapyIQtBywWasWmpO/tFCaxuvUhVzUCtHcE
	FqnqvKZEyK9FqtC/1YvBzaTgeR9fPBc=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4924933d072so30915e9.1
        for <linux-mm@kvack.org>; Sun, 21 Jun 2026 18:12:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782090767; cv=none;
        d=google.com; s=arc-20260327;
        b=jeBghNpv+gtqo7XDihX2BIgdlNR2R8gtbLJsjSbujH44lu90GVFq3ffQ+20SCIf0n7
         9a+9vzNSlNPIr4J2aF/6yRlVgWPayj61FW5chCURLX3GkGX5qRit1kzMZKmnjnl6Cf80
         euEWiMaXnEHQRBjd9DqUDFcu6lH3CecbMvG7LfMU156zgDAz/wqLyKWs9s4ZXNTQnjas
         doP5sAPxKCg/chGBltV0tFXdtKmexegzQVZ5s4lzTM5sGyufOsRmO/G5s40fNrPK3Evv
         5fjgS/Cwex9tJiW1K3k6phRXJE3JDeczdTb89PJ4s/vIGDo1oG7vfmtuRw6CFwLnoR/r
         5Zkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e7kbiKMRI+jitrHRbCNiHZbHykLGyvKeS/qNMb56MY4=;
        fh=MYMK7A2157rDwbFaQUQ0fJy8pLS4piNQBt1nUFInoRA=;
        b=RU2nnyRl+a3kuilCb6z9Aq7yTaI3AwS2FatD99NeZxoJvwk9aIukzzS06wQ5ReFE87
         vLWHvJcrjqqKJcaQ+rQHYpl5b46TwH+G7HmnDt9BrW0WKhpfAzcNAJE+8L7N1TDIFJ3J
         CCFKEQkKknqM+bE6a5Z9MisgkjTp6VVydF+oJUiWdXchXzsRCJVLC13W7i3skEYB3i2C
         Up0KeIMH3qld4TfgTwhQhRjB+4oXXmY8VS9psZCDgPXRY8uw3Nn8gZCPAW8sEyVHhoVH
         0Dq8a6Smb7PvDSgsCiXsswKUxGouvoi/j7tD0mORnp+vv3q7fDA+XFn17BIKCS6SjjYz
         VW8Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782090767; x=1782695567; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=e7kbiKMRI+jitrHRbCNiHZbHykLGyvKeS/qNMb56MY4=;
        b=YzOLMTYbMDV8h6aJ0n4mQGP7dqJtyJB493zY5Xaw4asm5xUl6nETU+rWCGRsqs0lQe
         f2IGXFSDDP59nyZE6nCNopwtJNFVjvSi+/QGP/p+tNkPQ4PBFTwwuKMp4gNOjxOmGtFc
         v94a61qvuFE3+uPgxGkA8G/EHBif264+2QI+QPJT68zE+c7HHxJ0FwPsS6Qv+nnsgCiu
         kgQAzQH6l8b3dUDZ3sUKjlWq+5X6CCyNgD1CmDaOsC1TfCj7wJQiM9NYuxeybAEB9aUZ
         9L05DJZ+P1HClJh/C+vMiCU3M71E2RnawzyGWPHkGcj1+qo4xO1nJE1ehk8qvDUClo+p
         mvUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782090767; x=1782695567;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e7kbiKMRI+jitrHRbCNiHZbHykLGyvKeS/qNMb56MY4=;
        b=sacVYQol1pYwZkN/B7p5H0OVNB9EQAjxKaf7xDZ9oVZUUuLwDO/j7Ap7vaQNz9/DKT
         Q48HvlSWe9CruFdxcDI/+EHkdthucxZwb5yz3cUYcxj653JvJoUlwpyC5IfRPGx2wQ34
         ayb071n2i0vMwiqfYGOt/Xo56Jm5xXctOL4GPbeZ50Koqi1hLI0KmgyhLSybc0DloTOp
         nzEEo0gql0Ke63Ck1X2GVxv0DYje4V9T+hhXOfkFJ7W5FAXewn15AJREiunsVCYtjZmg
         PpYFeyy2nkd4SQsexFW/5mFs35CiQQr0nfv4zSyPRErizJtMlpZt4NWO/eGF3hlfPY/f
         XZog==
X-Forwarded-Encrypted: i=1; AFNElJ/1okBenrf0yhCtndUxJoqNGIdqQVb6d8ufgDYtzZdbyXtLJgA1QRonb9sdkfHqqymv/xk/rECXlg==@kvack.org
X-Gm-Message-State: AOJu0YzkHd9CUlrFJfJEWuwlH7xXRgPdfbTxiqBGhd0GQzProTVCXHI7
	fojgGu4Tw+B967Ot63qV+r67sMZBgwHuNcSZzpwk6zAcrbYhci7zXR4HR1DzsGfS5Ey5WcbRLBv
	XfviMuRepMbPt5AnpcIohiXLw+RUkLBzFMzc6pHxk
X-Gm-Gg: AfdE7cnVk3PvQasgm4WtJxWD0wNdI9pKI5aFnIV+iVbAtr9hByOhT0mzY44zvZRnWPj
	UI9cNnD7oo/XhmIgTOQ5cnS4jKzacFxUcGHWbNwzkN2A+EiF7UhmQHrHbQjwCEgjOFGaycihjCt
	X8JRXiQTn/LxzAVLnL550OE/tTj+Hi6AGh0hvHzMA9adfPDZC1mHkNscbMZaWr9SdOR1lIqSG6T
	Q/hek07drSjsnHOWpQjIIGN1mznpuhO+EcnLhrYp2kNJdELpNkpQ37B0TcqyvKy/Yi25KwEO52m
	91Jg05igo/uPCU5f8prjTdku5xfeVsw1xDcyYZQ=
X-Received: by 2002:a05:600c:4d8a:b0:48f:d634:b18d with SMTP id
 5b1f17b1804b1-492404e26d3mr2337415e9.8.1782090767048; Sun, 21 Jun 2026
 18:12:47 -0700 (PDT)
MIME-Version: 1.0
References: <20260531055829.3636554-1-jiaqiyan@google.com> <20260531055829.3636554-2-jiaqiyan@google.com>
 <84a0b176-8534-e03a-9e6e-400c74ddab0b@huawei.com> <45290F97-B8BD-4A9B-934E-0A122A5F3A80@nvidia.com>
 <CACw3F51hi1SAs264i0FKMbieOQhCpRQQ9s7gS_cHDYgHsqu0WQ@mail.gmail.com> <ce2f2cea-1451-09a4-4562-62808b1c2d93@huawei.com>
In-Reply-To: <ce2f2cea-1451-09a4-4562-62808b1c2d93@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 21 Jun 2026 18:12:35 -0700
X-Gm-Features: AVVi8Cc8RmYm1McBScptGYqWiTYOEJEdYog_0lSjQbLNL4wu9lcHOzM85DJpWQI
Message-ID: <CACw3F53rh8pNKQQGf1Wn8RbRa4dPsgTDpK8TN06QVoyR09-L8A@mail.gmail.com>
Subject: Re: [PATCH v5 1/4] mm/page_alloc: only free healthy pages in
 high-order has_hwpoisoned folio
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: osalvador@suse.de, lorenzo.stoakes@oracle.com, jackmanb@google.com, 
	hannes@cmpxchg.org, nao.horiguchi@gmail.com, david@kernel.org, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, muchun.song@linux.dev, 
	liam@infradead.org, rientjes@google.com, duenwen@google.com, 
	jthoughton@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	vbabka@suse.cz, rppt@kernel.org, shuah@kernel.org, surenb@google.com, 
	mhocko@suse.com, boudewijn@delta-utec.com, ljs@kernel.org, 
	osalvador@kernel.org, willy@infradead.org, Zi Yan <ziy@nvidia.com>, 
	harry.yoo@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: fjob1956kafqp997juqxuh6jspumw5p8
X-Rspamd-Queue-Id: 28A1FC0002
X-Rspamd-Server: rspam11
X-HE-Tag: 1782090768-349083
X-HE-Meta: U2FsdGVkX18R3RZzb5U1X/QaSO72QmI3KjrXuHX2wmg5WbzAmQyWwMe56QkklEa/koP6JZEZhXjLAo67etPrNE3BChtSbwAjkHtCnFHlkJFYEGT62r6SkXt0Oa8rrP+QR5kXW7KbzhmXGiGaRZ9R/eCV3ld9ftFmJJ3yiXPTz4xwek9T6P566fEOcwxbza/Rcz03nfJS9VpKt9wF+ml87za1OosdJ06QNtfxmFhjHi679opO6RiX3YqKccrktt/5Hi1j3Y0zfrJmdavPu6cRerfCbEhJNxuK/sdWXjzU4EIcs+m9XU5cPlyT3XhhLYlH1r1D9jYjI83zd3rwUtfx1KDRkO1qP7JDRSIUxoA4jHFyfRg7gtnAJPqpqGsABCMRq/MTgCiDPpRpjpPFjIUdMbu1eUpR4gY0iPML+PDeHnPjI0DrJfn7vVZTGqQy6G2ROySi0ZHct6lRZbG0dD2hGuu+9XQBv/oBz94OxGkp7/hLNMmuu3eEi3cxyxly9YIfTGGnvaGRYiinZoTvaz+pL8oiaLb/3Q6ndTh0y8qJzFwOhede1R5K03fCnkRhizucPXSyEWaR5JTiWA3zn+I2GGMioh2EVDglYgSb89XqEo91qpD6i5T5XxAeEL2LVWS6WUclLxWb38djTGv5Zo00fh1NOk34LhwIKcxBYAv/gh4Vix7LGTDlsr+xBj8dGnNywl+jqGP5NvRWE6mhB88gIcDFcAR79zad1LnJ+JlWJM+R2SI5UvbxFD4lJb8hysOmtkBq28Oim+yqFKjigPREpW+8WoylrTbWyAiE1YFqTqThjoL6NxcdUqQwwRc9Zfrha7KwtErh+hh01WvSgD8WtLKZYbkLhFplwDl5TVm88Ym7Uw9CLR+KhplzVSvtfwT1eNquUEmh3o41TMbpBtUq3BkiiQItVAdkXWpv7z0N35HxMC0pduxjxko7rkiu/OyxXXuOmryEYLTqxppxXbW
 +umetDle
 khjDPzinCEIcWJriZIYF8byZoAeXG/el273EjtDm0fo9Oi51MtGsf+CmAtPlcsrxJ0Z4YpaeooWtvnJfF9ppVSTFzyeUoy1WqYHlJblcM6S9i7k1Z+jFao1K9IgvZwLNJVIP7m85zZWOkYJIPWTPXf5013kLWuBWFVZen9ckTQEDCSZpsE5Ri1nYSOdqocEHhuVPY5D5mAIf7BZu4WVAlE6GZ6nfGPJDMrv5ndGjPvSoSJoS4Xr/r8+Edmm34aGLdNGDtogr8WzQ9fTbyIN0f/javm1hg8SYTmuU4ENeO0WOVUeXVm1OaeJLJkFBHw6cKPD6+Erg+ikSigKUL3tXshk0siABI2qD782BABHyXhrnQ/ub4gemE4pjVBytydyDp4UgaUwvCES5YLnf2hBfjh9ETkx2j6pUGGVIoGFKGr6OlanjfPKDuVOhgg7nE88o6pG2nQxcJNoknemvqVg8JU06ykx9KqTyG/EMgn3tPO2kSwEblEvO3y/H3g/vqhaX+UkL5Ypg6TbsB+a7mb0pIKfHegmKVBR5TI+F5X+gqtPXgPUyMjDvLsdmq8MfyDBHdqjYVAeaHxPf2ZBnpkR5DLlCkd5kktZzOJdJuOtjimc5zQAZ/UtODVUoGxMK5KUQjoSghlc/PVKFFQAGE7gU588xGvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 11:54=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> =
wrote:
>
> On 2026/6/16 11:23, Jiaqi Yan wrote:
> > On Fri, Jun 12, 2026 at 11:34=E2=80=AFAM Zi Yan <ziy@nvidia.com> wrote:
> >>
> >> On 8 Jun 2026, at 23:44, Miaohe Lin wrote:
> >>
> >>> On 2026/5/31 13:58, Jiaqi Yan wrote:
> >>>> At the end of dissolve_free_hugetlb_folio(), a free HugeTLB folio
> >>>> becomes non-HugeTLB, and it is released to buddy allocator
> >>>> as a high-order folio, e.g. a folio that contains 262144 pages
> >>>> if the folio was a 1G HugeTLB hugepage.
> >>>>
> >>>> This is problematic if the HugeTLB hugepage contained HWPoison
> >>>> subpages. In that case, since buddy allocator does not check
> >>>> HWPoison for non-zero-order folio, the raw HWPoison page can
> >>>> be given out with its buddy page and be re-used by either
> >>>> kernel or userspace.
> >>>>
> >>>> Memory failure recovery (MFR) in kernel does attempt to take
> >>>> raw HWPoison page off buddy allocator after
> >>>> dissolve_free_hugetlb_folio(). However, there is always a time
> >>>> window between dissolve_free_hugetlb_folio() frees a HWPoison
> >>>> high-order folio to buddy allocator and MFR takes HWPoison
> >>>> raw page off buddy allocator.
> >>>>
> >>>> Another similar situation is when a transparent huge page (THP)
> >>>> runs into memory failure but splitting failed. Such THP will
> >>>> eventually be released to buddy allocator when owning userspace
> >>>> processes are gone, but with certain subpages having HWPoison.
> >>>>
> >>>> One obvious way to avoid both problems is to add page sanity
> >>>> checks in page allocate or free path. However, it is against
> >>>> the past efforts to reduce sanity check overhead [1,2,3].
> >>>>
> >>>> Introduce free_has_hwpoisoned() to only free the healthy pages
> >>>> and to exclude the HWPoison ones in the high-order folio.
> >>>> The idea is to iterate through the sub-pages of the folio to
> >>>> identify contiguous ranges of healthy pages.
> >>>>
> >>>> free_has_hwpoisoned() is added in free_pages_prepare() as
> >>>> a shortcut and is only invoked if PG_has_hwpoisoned indicates
> >>>> HWPoison page exists and after checks and preparations in
> >>>> free_pages_prepare() all succeeded. free_has_hwpoisoned() then
> >>>> can re-use free_prepared_contig_range() [4] to decompose healthy
> >>>> ranges into the largest possible chunks of different orders.
> >>>> Every chunk meets the requirements to be freed via free_one_page().
> >>>>
> >>>> free_has_hwpoisoned() has linear time complexity wrt the number
> >>>> of pages in the folio. While the power-of-two decomposition
> >>>> ensures that the number of calls to the buddy allocator is
> >>>> logarithmic for each contiguous healthy range, the mandatory
> >>>> linear scan of pages to identify PageHWPoison() defines the
> >>>> overall time complexity. For a 1G hugepage having 8 HWPoison
> >>>> pages, free_has_hwpoisoned() takes around 1ms on average on
> >>>> a system having 56 Intel Skylake physical cores. This is
> >>>> 15x to the case of freeing no HWPoison page. The cost is far
> >>>> from triggering soft lockup, and fair for handling exceptional
> >>>> hardware memory errors.
> >>>>
> >>>> [1] https://lore.kernel.org/linux-mm/1460711275-1130-15-git-send-ema=
il-mgorman@techsingularity.net
> >>>> [2] https://lore.kernel.org/linux-mm/1460711275-1130-16-git-send-ema=
il-mgorman@techsingularity.net
> >>>> [3] https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.c=
z
> >>>> [4] https://lore.kernel.org/all/20260401101634.2868165-2-usama.anjum=
@arm.com
> >>>>
> >>>> Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
> >>>
> >>> Thanks for your update. This patch looks good to me while some commen=
ts below.
> >>>
> >>>> ---
> >>>>  mm/page_alloc.c | 85 ++++++++++++++++++++++++++++++++++++++++++++++=
+++
> >>>>  1 file changed, 85 insertions(+)
> >>>>
> >>>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> >>>> index e47679e7a9db..03df929abca6 100644
> >>>> --- a/mm/page_alloc.c
> >>>> +++ b/mm/page_alloc.c
> >>>> @@ -208,6 +208,7 @@ gfp_t gfp_allowed_mask __read_mostly =3D GFP_BOO=
T_MASK;
> >>>>  unsigned int pageblock_order __read_mostly;
> >>>>  #endif
> >>>>
> >>>> +static void free_has_hwpoisoned(struct page *page, unsigned int ord=
er);
> >>>>  static void __free_pages_ok(struct page *page, unsigned int order,
> >>>>                          fpi_t fpi_flags);
> >>>>  static void reserve_highatomic_pageblock(struct page *page, int ord=
er,
> >>>> @@ -1309,6 +1310,14 @@ static inline void pgalloc_tag_sub_pages(stru=
ct alloc_tag *tag, unsigned int nr)
> >>>>
> >>>>  #endif /* CONFIG_MEM_ALLOC_PROFILING */
> >>>>
> >>>> +/*
> >>>> + * Returns
> >>>> + * - true: checks and preparations all good, caller can proceed fre=
eing.
> >>>> + * - false: do not proceed freeing for one of the following reasons=
:
> >>>> + *   1. Some check failed so it is not safe to proceed freeing.
> >>>> + *   2. A compound page has some HWPoison pages. The healthy pages
> >>>> + *      are already safely freed, and the HWPoison ones isolated.
> >>>> + */
> >>>>  static __always_inline bool __free_pages_prepare(struct page *page,
> >>>>              unsigned int order, fpi_t fpi_flags)
> >>>>  {
> >>>> @@ -1317,6 +1326,15 @@ static __always_inline bool __free_pages_prep=
are(struct page *page,
> >>>>      bool init =3D want_init_on_free();
> >>>>      bool compound =3D PageCompound(page);
> >>>>      struct folio *folio =3D page_folio(page);
> >>>> +    /*
> >>>> +     * When dealing with compound page, PG_has_hwpoisoned is cleare=
d
> >>>> +     * with PAGE_FLAGS_SECOND. So the check must be done first.
> >>>> +     *
> >>>> +     * Note we can't exclude PG_has_hwpoisoned from PAGE_FLAGS_SECO=
ND.
> >>>> +     * Because PG_has_hwpoisoned =3D=3D PG_active, free_page_is_bad=
() will
> >>>> +     * confuse and complaint that the first tail page is still acti=
ve.
> >>>> +     */
> >>>> +    bool should_fhh =3D compound && folio_test_has_hwpoisoned(folio=
);
> >>>>
> >>>>      if (fpi_flags & FPI_PREPARED)
> >>>>              return true;
> >>>> @@ -1443,6 +1461,16 @@ static __always_inline bool __free_pages_prep=
are(struct page *page,
> >>>>
> >>>>      debug_pagealloc_unmap_pages(page, 1 << order);
> >>>>
> >>>> +    /*
> >>>> +     * After breaking down compound page and dealing with page meta=
data
> >>>> +     * (e.g. page owner and page alloc tags), take a shortcut if th=
is
> >>>> +     * was a compound page containing certain HWPoison subpages.
> >>>> +     */
> >>>> +    if (should_fhh) {
> >>>> +            free_has_hwpoisoned(page, order);
> >>>> +            return false;
> >>>> +    }
> >>>
> >>> When the code reaches here, the hwpoisoned pages have passed through =
kernel_poison_pages,
> >>> kasan_poison_pages, kernel_init_pages, arch_free_page... These functi=
ons might write to
> >>> the hwpoisoned pages. Is it safe to do so?
> >>
> >> At least, kernel_poison_pages() writes to the page. It probably should=
 be
> >> moved up, somewhere like above kernel_poison_pages().
> >
> > Writing to HWPoison pages (location having memory error) is usually
> > safe, as in it doesn't cause a machine check exception. Memory
>
> In x86, set_mce_nospec is called for hwpoisoned pages. So writing to
> HWPoison pages would cause unexpected page fault in kernel?

Ah, yes, thanks for pointing out, Miaohe!

>
> Thanks.
> .

