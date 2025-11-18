Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9F6CEBF97
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 06:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EABC18E0029; Tue, 18 Nov 2025 01:24:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E831F8E0005; Tue, 18 Nov 2025 01:24:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC0608E0029; Tue, 18 Nov 2025 01:24:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id CA8E78E0005
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:24:42 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6A37AB8DA5
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:24:42 +0000 (UTC)
X-FDA: 84122739204.21.3254B6C
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8058D40012
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 06:24:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e4L20TSh;
	spf=pass (imf07.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763447080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TLvAPfrkI/zYgSNVGp/8sP/HrwQJdzRKS9oKpDwAHUc=;
	b=XOaW8BrjWQx5bRCLFdbqeooNWZFA7SztqHqCqOiACVVDaLDG09odLHT6FDTvtUWn7POfWU
	/PpE9tyGBbTR0dGc7JYfhfiVkLKGaPkPWFeHQXCvCaRDFXYubndEZMdJErpoTAPvZ6zsgt
	bbM/+wpfahbAv0WVuymNr/z7CRn5Af0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=e4L20TSh;
	spf=pass (imf07.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.41 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763447080; a=rsa-sha256;
	cv=none;
	b=LKZUyN+GeXOOzkeOEJWlQOH500zLHwUdW704PLySBF+sRfgTGCFRmqL/RUFCdQVjgM7wcP
	xoKR9SapmcR79cLU2XbU4tbQt2ww5ltrO9EmhpgBrX3Mfu4M8XpcmtCfaTXvCIjedZJu00
	LiEkYcsYwPVTxZHq6BZ9m8HevHXckIY=
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4779e2ac121so33445e9.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 22:24:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763447079; x=1764051879; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TLvAPfrkI/zYgSNVGp/8sP/HrwQJdzRKS9oKpDwAHUc=;
        b=e4L20TShT9lpQ/Z6DO/4q7LTrlWnFZ104TkpGGWqb1ObYMbi5Y5zX+KEm2kMFkgTTG
         qksi16+4dCTtASQD1lylfDWqh6gCnNLCDTTcKtu9d1U5059mR5f3Dy5W6S1eHS+L+m3A
         rtzvLiNB+/yyfsm0HuO+L+QY+APstK1c84Amu0bDgmUc8+Mv7CTnGygRftCQZw/Lj+ID
         pL1n3C2VDKBJwxQFMkdSf0vOmCQuht6Vhu4pewBxrlIdHP++LXm3iKYkLjXwirN+C835
         +8cYH3gATWJkxXsOYFgdj9AO3Vql/C6hcYmN2/wh1XK3a4zR76k8S/alCdvOxGIBOg/2
         kutA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763447079; x=1764051879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TLvAPfrkI/zYgSNVGp/8sP/HrwQJdzRKS9oKpDwAHUc=;
        b=WoxXh6UE7zqut855pVFJmDyzUAPYkznuQgJsZDRNZWZsK0154F0dCXJv7KnF/Go/Er
         pPOiueI1pD/VslUkyS3S2nt1OB2dJBYTXORAcjdTRQH+gSMuhwsXDeJHKmN5ASQqEh/r
         9C1LWd1udPfptNYy174LO09cO29QDbSu1MyrRrjNK6f1WN/PzmA+JJnK6iqRtogYnkf2
         TFpytJuFLb2u+hoKAFRqzSZnRTFCcS64+H8HvtqGG8TJaXKnqhubEPeMEElUMEaIVsja
         CJCP11e3/G/gAzcO988+271JXUh6EPUcNVSWD++ro/sYP+1eVLBmi+mvFZ7tTtarcfLp
         3kIw==
X-Forwarded-Encrypted: i=1; AJvYcCXI9I3/WTg5eGuvrYKX0RDt7jTE000FsZyUPH8qmzCL/pGo4N5soDg565tImZV3CaDxW7brSwliqA==@kvack.org
X-Gm-Message-State: AOJu0YysE44seqeTBW5XYt0aBWWbW2JoavYJhFi8+M5LPa+66lnv4DOJ
	gZD5PWYuYCxK51NqZtu9Z+tFSPv1IXoYiBnogNkngEsmMYf483/Hj62om3U8X1dGl85pDG8o/+K
	5cfAx7eaj4Jv1sy7XOopop2SPwzDcf2M6ajWFTjWG
X-Gm-Gg: ASbGncud7A449g1b8Z8B4+G+C4Am2Mfk0/pDBnxNVYOnT8kowCRGWoO1OnVQXBII053
	6MlXqtjipzFDqF2VwgQ6rPPQzM0dapizcXYKm+Jg1MBwXUoBVitSjQtwKClJAiX/Dvx486z4Eif
	viKA+/HQfKZ3C96nq+2BFIKs5KCtv3GexbpsNosfn2o6/0xupbDRNt9w0URZMaBF2LONf7r/65Z
	vN55h268MjRcgOjpFrkK5juk+9kWv1pdrql+VhBA243dIBtDkwzLTgenA+QKvS9Js1VYgLpMAl8
	2Z4ST2Lk9bzXsDk+PHHHXNOHCL/Q
X-Google-Smtp-Source: AGHT+IGUrL8vb1I+w3aQwLjf+9ccRyeGCNs9+TZ7n9gxUlnGLthm8mqk5SxO7W68VRy8YDjsnkdfmM2JXkmraVH+nPU=
X-Received: by 2002:a05:600c:c0d9:b0:477:76cb:18e2 with SMTP id
 5b1f17b1804b1-477aca5a719mr89855e9.0.1763447078727; Mon, 17 Nov 2025 22:24:38
 -0800 (PST)
MIME-Version: 1.0
References: <20251116014721.1561456-1-jiaqiyan@google.com> <20251116014721.1561456-2-jiaqiyan@google.com>
 <aRm6shtKizyrq_TA@casper.infradead.org> <aRqTLmJBuvBcLYMx@hyeyoo> <aRsmaIfCAGy-DRcx@casper.infradead.org>
In-Reply-To: <aRsmaIfCAGy-DRcx@casper.infradead.org>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 17 Nov 2025 22:24:27 -0800
X-Gm-Features: AWmQ_bmQYN1uUL7Hku5AMHcByQa7MIWapAaD7bovPggfmM_Xzv2AdbuM5SMKUMk
Message-ID: <CACw3F50E=AZtgfoExCA-nwS6=NYdFFWpf6+GBUYrWiJOz4xwaw@mail.gmail.com>
Subject: Re: [PATCH v1 1/2] mm/huge_memory: introduce uniform_split_unmapped_folio_to_zero_order
To: Matthew Wilcox <willy@infradead.org>, Harry Yoo <harry.yoo@oracle.com>, ziy@nvidia.com, 
	david@redhat.com, Vlastimil Babka <vbabka@suse.cz>
Cc: nao.horiguchi@gmail.com, linmiaohe@huawei.com, lorenzo.stoakes@oracle.com, 
	william.roche@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	jane.chu@oracle.com, akpm@linux-foundation.org, osalvador@suse.de, 
	muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8058D40012
X-Stat-Signature: emn8trx6t7pahutffhmooswrsqt7rxsb
X-Rspam-User: 
X-HE-Tag: 1763447080-760122
X-HE-Meta: U2FsdGVkX19gLfdLO7E0POy9BgTqQWT6W0qaoGJFuLWS6AbzRvwPG5r1vZqlqauSDv7jIcAV+sm7EguBG/26pZullYA7ybrj4qPpOdnRfUyGSbMEZDfZK3Yn519Qrvi8vrPRsloJxhMmjkpU23F/wSIfluywxt8e9/jLsSM0U6q9sXBS+4jHP03d5eCRRBdMRwwBckEWrQwtDBixHIzGjSBrItzS2B0Y7IiuUSxmssWu11IprYsdpBvwX8Wfx2IGrlQNMwj4wBkQjcxGhjR6nWRZCR6Sysv904lFx00Ui/Zhj0S0FRuMea4tbbMPlqP3BVK41laEnNpxJ1awkheDqGrc+0rZyo8AQqd0L9QLGjVUf5llVZ/AjDxewZzVhj/kNcUzFwpHesUlHwiXzHvJ97Eyztj7Vve4lDwervvDsHKrvnnlpgmUwmTUNdB+mEuOAmJ5Guh7NqO+GTX2WZ8foQfO/4iNpUWpFSAKD9hfcN8ur13lmccD8eeAujW9oAop43z0Wi11DDNUNCqDsVf+37nRo/1jpjbSJ2yhpQ+InO+XXNyusZx+0qj1tOEoLSrSsF1t8qbJttvvsRAdiArMJDdhE+BqPYH5Ka5vElogRd2648Vkrzc8QH9MIqemAFnn8XF0Wi5ro+nHrZiCsBOrNfKVyVwVazCN+N70SYVm9UahNqbYa20NBOznWyYjU8HLDFdpWSvBHRdA8H938A80hclIuxgyAyabYcCLHeorHBhDc6I4ezITEBSatgvhXwyz2073v3KTKkkvIiLPFF4k5pjJ92/i+RuiGrIqkQtr4+dnj9Opxre/lX5mcjfL01wYMxQZjItcA8hHRVqwalyNwQNiuZJHnyegmnQrq6C4Lv47Iv3rSIfXsL3jdEt8B0Ept4FkAg6iffZjpUZ4NoWYL+9sdxfMuauXJbjwT5usfjLRS3lYEjvLuXGagiiWEhyb3/p6YY6eF76IxZu0BtJ
 C4ir8g4+
 g2XYjMmU/B4N2D9ofItKOLtYfHW/TAqgy+TlGannQrbQZosbT/Ex/vSPG8Ppk5WA8VRypd3J6krBglCKdS8JNI5j5xBcjVSvhgjtY93e7JS4xnPVlGlwxLfIboaXKRoB9b0X+VQsxRt5RX/ymPciL/HbMErxDXa1ppseRmW6m1ox65bDREs6uTSPhc6ooZc31izGb9xF2MiAu543a0u6Ac5jo7kJiTW81w9rb5N2yzxaPwWrsOPpq3x5F3X75V/1snp4sMuhlxwB779rlYZWeHqu89FfBcgTpb0HkxCSQwRu0th1tTg8m/1Fq+2c8KzSXE0Pk48hwQiXjmd68XjyOPDpFIX/p23hjlzv0gl4ZFJfsgmxCNGOoG1/Xew==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 5:43=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Mon, Nov 17, 2025 at 12:15:23PM +0900, Harry Yoo wrote:
> > On Sun, Nov 16, 2025 at 11:51:14AM +0000, Matthew Wilcox wrote:
> > > But since we're only doing this on free, we won't need to do folio
> > > allocations at all; we'll just be able to release the good pages to t=
he
> > > page allocator and sequester the hwpoison pages.
> >
> > [+Cc PAGE ALLOCATOR folks]
> >
> > So we need an interface to free only healthy portion of a hwpoison foli=
o.

+1, with some of my own thoughts below.

> >
> > I think a proper approach to this should be to "free a hwpoison folio
> > just like freeing a normal folio via folio_put() or free_frozen_pages()=
,
> > then the page allocator will add only healthy pages to the freelist and
> > isolate the hwpoison pages". Oherwise we'll end up open coding a lot,
> > which is too fragile.
>
> Yes, I think it should be handled by the page allocator.  There may be

I agree with Matthew, Harry, and David. The page allocator seems best
suited to handle HWPoison subpages without any new folio allocations.

> some complexity to this that I've missed, eg if hugetlb wants to retain
> the good 2MB chunks of a 1GB allocation.  I'm not sure that's a useful
> thing to do or not.
>
> > In fact, that can be done by teaching free_pages_prepare() how to handl=
e
> > the case where one or more subpages of a folio are hwpoison pages.
> >
> > How this should be implemented in the page allocator in memdescs world?
> > Hmm, we'll want to do some kind of non-uniform split, without actually
> > splitting the folio but allocating struct buddy?
>
> Let me sketch that out, realising that it's subject to change.
>
> A page in buddy state can't need a memdesc allocated.  Otherwise we're
> allocating memory to free memory, and that way lies madness.  We can't
> do the hack of "embed struct buddy in the page that we're freeing"
> because HIGHMEM.  So we'll never shrink struct page smaller than struct
> buddy (which is fine because I've laid out how to get to a 64 bit struct
> buddy, and we're probably two years from getting there anyway).
>
> My design for handling hwpoison is that we do allocate a struct hwpoison
> for a page.  It looks like this (for now, in my head):
>
> struct hwpoison {
>         memdesc_t original;
>         ... other things ...
> };
>
> So we can replace the memdesc in a page with a hwpoison memdesc when we
> encounter the error.  We still need a folio flag to indicate that "this
> folio contains a page with hwpoison".  I haven't put much thought yet
> into interaction with HUGETLB_PAGE_OPTIMIZE_VMEMMAP; maybe "other things"
> includes an index of where the actually poisoned page is in the folio,
> so it doesn't matter if the pages alias with each other as we can recover
> the information when it becomes useful to do so.
>
> > But... for now I think hiding this complexity inside the page allocator
> > is good enough. For now this would just mean splitting a frozen page

I want to add one more thing. For HugeTLB, kernel clears the HWPoison
flag on the folio and move it to every raw pages in raw_hwp_page list
(see folio_clear_hugetlb_hwpoison). So page allocator has no hint that
some pages passed into free_frozen_pages has HWPoison. It has to
traverse 2^order pages to tell, if I am not mistaken, which goes
against the past effort to reduce sanity checks. I believe this is one
reason I choosed to handle the problem in hugetlb / memory-failure.

For the new interface Harry requested, is it the caller's
responsibility to ensure that the folio contains HWPoison pages (to be
even better, maybe point out the exact ones?), so that page allocator
at least doesn't waste cycles to search non-exist HWPoison in the set
of pages?

Or caller and page allocator need to agree on some contract? Say
caller has to set has_hwpoisoned flag in non-zero order folio to free.
This allows the old interface free_frozen_pages an easy way using the
has_hwpoison flag from the second page. I know has_hwpoison is "#if
defined" on THP and using it for hugetlb probably is not very clean,
but are there other concerns?


> > inside the page allocator (probably non-uniform?). We can later re-impl=
ement
> > this to provide better support for memdescs.
>
> Yes, I like this approach.  But then I'm not the page allocator
> maintainer ;-)

If page allocator maintainers can weigh in here, that will be very helpful!

