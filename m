Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2641CCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 17:29:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 392388E014F; Thu, 30 Oct 2025 13:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342C68E0089; Thu, 30 Oct 2025 13:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2593D8E014F; Thu, 30 Oct 2025 13:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 14AF18E0089
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 13:29:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B7E308726E
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:29:03 +0000 (UTC)
X-FDA: 84055466166.18.C48D231
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf28.hostedemail.com (Postfix) with ESMTP id C82BDC000A
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:29:01 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RSwr2HNa;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761845341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=duKu/8Ky/t6prpCzomheaKrWsLhN82XKAnG9GJbzgTM=;
	b=3d9JpcVLhletwL9cqrsxnUz/PadPeuTOadHXQF67izjUl5YSJrEz4tF9X9pMc+9ueGK2fM
	HV9QyvA/KAA5XRUXeXddpf/rFHbvs85sDFg6KOl+fLOmK9TePR4rrSsFulOZGO5NrBdXdB
	gVnQpwuu6j/SmghdQjhHfLwUQ2zw53c=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=RSwr2HNa;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761845341; a=rsa-sha256;
	cv=none;
	b=XjGhup0LN0Ic4gJi+wjLmRatRdgPA8zqhRpubpmp+IDEVdF1Q5v6lCHXTzq1/ufunDT31r
	9fPtWhEJBktDLXRWWu8N9FaqrlaEU8UQ4wMz2Bc5SXtMURft5fFZnpK4WqwcuspFcmOvV2
	2apOeosxDgqUcuxM0PTTwCmp24Glf0g=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4770d4df4deso3435e9.1
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 10:29:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761845340; x=1762450140; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=duKu/8Ky/t6prpCzomheaKrWsLhN82XKAnG9GJbzgTM=;
        b=RSwr2HNaMEspCLgaYKuMr/sl8/MPpHD6oYmMwsEdT1h6avATWxAxhOiY5STDf/E6Q0
         +tv4WEfOG2e06SLRamsaf/V64e4NTxn9T9lthS16BTBufQ4ym08c/GWbtzn9T/NmMe46
         zgjEcfo4NIHhAVX+VKS/oTCGPG9od8FK5ABOBrpWn6UPfrknO74sTwcB+t7lWzimbCeH
         awkURe7N0DWeRPf75lNM4wdCeA59q2fV2CmWDr+eZXBtXAJa2HyLsthqYs/lHKIXa8Cg
         neRyUMad29qKwtHPtC85JIcS+yG8lRPdI+VzeW7wRqbZotk+B6vUkwFqvJ4N/pOP18AZ
         qHrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761845340; x=1762450140;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=duKu/8Ky/t6prpCzomheaKrWsLhN82XKAnG9GJbzgTM=;
        b=JwGp0zK8h9NHbHnYHXE/NvNPlCY4UtNGNLi4CxUf1+KCBR6FjuJxgYOW1SErY0F034
         5r1cjreOuK2BZLkt6ERYyJ2woMQ82eDqignw8gnC3QDltVpoAj/GbGYCueSijSeDYcmL
         JK+XAqUBt3Stw6YH3tnl268GUxklVe5fAbihZE3Ol20RkEXFSUIBWRAB2+I8j9qWF0CD
         Xd/i54Ub43irQhRUVUO7qYuyeS0hIZL87le6rPgwmrtSo43reX4EX6zKsRSiMVxuYTP1
         59o2xhmNrXt2DsLk4K5vG0D0RnBdN1o0QRuv+ve6Fc0ViJOY9/p0KWXE60X505TBLelN
         k6rQ==
X-Forwarded-Encrypted: i=1; AJvYcCXT+vA3WrqkxdyZ2YBu2MeOYUgls6tELPRkai1SEVqBGQygusiSDwOqWJrlXCfRmQY0b5XS4184MQ==@kvack.org
X-Gm-Message-State: AOJu0YxBLdk9FU16gRvC9v30z359NGs+nonzK7p6byFJdAYdG0/LwOsf
	gMDGBtKp4tF7pD2YUyZEYJ8kO7+aG61jTtNYUF178sMdiDQ6M3QxW9dHLqD9IecCXDJmIlEWpbu
	531nTFWRVYonQWZ+7RKorPOAmz3RGcqKqB+EAsEzl
X-Gm-Gg: ASbGncvSfhRnXcRzCQMGitcMJgng/qEfe+s/7bo1fcxwrzLlpGxAvlrrC1yKPJ83+85
	n5w467ngB/tasv6nuBJrB3yhbI+bYr1Wg8XNj+m5q0Bh1bJBJQjE4jMw8CgKsFjPR8y9Gq8OmwP
	aMHgiiwQy6lhwLbB5cASYsLx5cBuBivDjfUekQ28KOk8rCuLAEoSg7rzf2jDemjlpVPV+0Ngk7j
	RbPU/z2pf2MI6RNzUFYRGqhxWK6R5UVlKxrj4zWlVdkwFLOUSo9zF0JAQD06N8d2wu2eVuBeXrc
	nLpJxljQ+MRLwFk=
X-Google-Smtp-Source: AGHT+IFCRKDiV45j8nfSSPazMv37IGqBBffmdRw3pH4dGClMUS1sq6qT4CcfZSHTWT3SkuCeES6cEwuqbx88QSTv3rE=
X-Received: by 2002:a05:600c:6207:b0:46f:a42d:41f0 with SMTP id
 5b1f17b1804b1-477310e383cmr86755e9.0.1761845339767; Thu, 30 Oct 2025 10:28:59
 -0700 (PDT)
MIME-Version: 1.0
References: <20250118231549.1652825-1-jiaqiyan@google.com> <20250919155832.1084091-1-william.roche@oracle.com>
 <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com>
 <aPjXdP63T1yYtvkq@hyeyoo> <CACw3F50As2jPzy1rRjzpm3uKOALjX_9WmKxMPGnQcok96OfQkA@mail.gmail.com>
 <aQBqGupCN_v8ysMX@hyeyoo> <d3d35586-c63f-c1be-c95e-fbd7aafd43f3@huawei.com>
In-Reply-To: <d3d35586-c63f-c1be-c95e-fbd7aafd43f3@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 30 Oct 2025 10:28:48 -0700
X-Gm-Features: AWmQ_bmYKY6ggj7beaUai29I-PXUvJIYK1duVN36KusJtjmgIEZDYv_nIrP-5Lg
Message-ID: <CACw3F51qaug5aWFNcjB54dVEc8yH+_A7zrkGcQyKXKJs6uVvgA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] Userspace MFR Policy via memfd
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Harry Yoo <harry.yoo@oracle.com>, =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>, 
	Ackerley Tng <ackerleytng@google.com>, jgg@nvidia.com, akpm@linux-foundation.org, 
	ankita@nvidia.com, dave.hansen@linux.intel.com, david@redhat.com, 
	duenwen@google.com, jane.chu@oracle.com, jthoughton@google.com, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, muchun.song@linux.dev, nao.horiguchi@gmail.com, 
	osalvador@suse.de, peterx@redhat.com, rientjes@google.com, 
	sidhartha.kumar@oracle.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C82BDC000A
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 7bfcpqo1khu677yr8cc6ihg1uf5ysmk9
X-HE-Tag: 1761845341-3307
X-HE-Meta: U2FsdGVkX1+fWOhtq7U5ULplU/6IYmCVXgk9rIy6Wu3lu7R20/0nL7yuhAhFz7rUIdLa/qmKQ/SQWF1RhOQuG5RnI3omRmgxSdNFLhkeiEeUoBKegjsZvZNvp6HmA4dZNmJUntWVJSZclc5GalT1loF0O5hz9CokYI4TnkN54OX5MVk+0W2FmJRLn38goHvew5MU3o6dk8HKpoVFx0gM6HAzk/XBFJpX4v93avf3/vqxyYUghHXRs9cZn7adDeW1V0nZdinOz/qEwoq/w9FPk8WG3Elz/+3dVbCb0LKlFcTKfXsTGfP+Sw4gUsm9yT2+v1DOAGgqERs/qwflFAjCjDb1KM1qQ4rwxAXdwFTRogZW+fEZSGqhM3oFj5WxdpaK24hHzmPXSCuEYimaFXYGQg5h/pkHYMwToL+ssfOfR+anhNnyOCp7sKNDctLyLs2ZebSP1diaC9XuyEO8BlNHvNLTEEav+ekUKwJam+XgPraLq9eQdniWRA51Dx8aIjCuU2lXiPs4kB0SpND+Aqt9ijcTd+/iwX2Z+YjUlcVfUOss2fExtJDli6925ys8sZ0/ADoWs7IQuGgq/JHsTMP/oWNmCsngbGDV34acMVx3vP20xlO+WegjZBRxlP7re84n09MuC50AONQr79lohQmwg2kRnk9Hkhtz+TxMHBiMGBJeZFpPwbtHoexW3vYUqeG7qVbBAOqMj9txsdC1Z1ajwRbsBia2U87yBN7HCEry77ZWGzPa4J5j2D6jUp/86/AWdeuhUYcZBfVTaARFk9hfDn2KMkhYvH3nlnfZpx1hKzZElP7KvWMuRMoWpjqUyczzcdmfC0iLCke9YUolHsu9G3GuBmHXT6Bp2JbGydsTNoB5xlBAVEGpUsKughfHvRt5/Y1eoeC4pyMu3obQXn2TxLj2toeG+Jvs7JvSZugAWNpJnFsTlkDLUM90RHNWn0yGBpks/gEnhXFTX8g+dTC
 1CSjQkKr
 FzUvDmY1OA2IOX4uFtOjFZtjF+1Px8YD/UtAc5BwVyUhIABy6IqDGLENDhuKk9n+xsJ25bXYYbvq0dhDTZ/YMafjIVlXtmNUTELY6cPSrPYdHuwp0yg6FFequ0rBuSRnCFokI52Ct1ROkDsPggl/dG9t96tep0gqxhmDAXxICt+u3Oy5vF2HTOe4e14cUdMuQHVMkWi53LH+ypztOza+xnvggR5YgLpVqQAsDfcxlN6RcVObkYIl/AzlLL+sdWnGqVBy+TS6Tqn3kFpZpPCHZDAVgpxTlQ6zS2oSBi1HCgnXWxZ+Q/V9HjKFRyHr8rvkYpF7JFqg+AAYk1YVs9n/LxiQ6hQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 4:51=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> w=
rote:
>
> On 2025/10/28 15:00, Harry Yoo wrote:
> > On Mon, Oct 27, 2025 at 09:17:31PM -0700, Jiaqi Yan wrote:
> >> On Wed, Oct 22, 2025 at 6:09=E2=80=AFAM Harry Yoo <harry.yoo@oracle.co=
m> wrote:
> >>>
> >>> On Mon, Oct 13, 2025 at 03:14:32PM -0700, Jiaqi Yan wrote:
> >>>> On Fri, Sep 19, 2025 at 8:58=E2=80=AFAM =E2=80=9CWilliam Roche <will=
iam.roche@oracle.com> wrote:
> >>>>>
> >>>>> From: William Roche <william.roche@oracle.com>
> >>>>>
> >>>>> Hello,
> >>>>>
> >>>>> The possibility to keep a VM using large hugetlbfs pages running af=
ter a memory
> >>>>> error is very important, and the possibility described here could b=
e a good
> >>>>> candidate to address this issue.
> >>>>
> >>>> Thanks for expressing interest, William, and sorry for getting back =
to
> >>>> you so late.
> >>>>
> >>>>>
> >>>>> So I would like to provide my feedback after testing this code with=
 the
> >>>>> introduction of persistent errors in the address space: My tests us=
ed a VM
> >>>>> running a kernel able to provide MFD_MF_KEEP_UE_MAPPED memfd segmen=
ts to the
> >>>>> test program provided with this project. But instead of injecting t=
he errors
> >>>>> with madvise calls from this program, I get the guest physical addr=
ess of a
> >>>>> location and inject the error from the hypervisor into the VM, so t=
hat any
> >>>>> subsequent access to the location is prevented directly from the hy=
pervisor
> >>>>> level.
> >>>>
> >>>> This is exactly what VMM should do: when it owns or manages the VM
> >>>> memory with MFD_MF_KEEP_UE_MAPPED, it is then VMM's responsibility t=
o
> >>>> isolate guest/VCPUs from poisoned memory pages, e.g. by intercepting
> >>>> such memory accesses.
> >>>>
> >>>>>
> >>>>> Using this framework, I realized that the code provided here has a =
problem:
> >>>>> When the error impacts a large folio, the release of this folio doe=
sn't isolate
> >>>>> the sub-page(s) actually impacted by the poison. __rmqueue_pcplist(=
) can return
> >>>>> a known poisoned page to get_page_from_freelist().
> >>>>
> >>>> Just curious, how exactly you can repro this leaking of a known pois=
on
> >>>> page? It may help me debug my patch.
> >>>>
> >>>>>
> >>>>> This revealed some mm limitations, as I would have expected that th=
e
> >>>>> check_new_pages() mechanism used by the __rmqueue functions would f=
ilter these
> >>>>> pages out, but I noticed that this has been disabled by default in =
2023 with:
> >>>>> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> >>>>> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >>>>
> >>>> Thanks for the reference. I did turned on CONFIG_DEBUG_VM=3Dy during=
 dev
> >>>> and testing but didn't notice any WARNING on "bad page"; It is very
> >>>> likely I was just lucky.
> >>>>
> >>>>>
> >>>>>
> >>>>> This problem seems to be avoided if we call take_page_off_buddy(pag=
e) in the
> >>>>> filemap_offline_hwpoison_folio_hugetlb() function without testing i=
f
> >>>>> PageBuddy(page) is true first.
> >>>>
> >>>> Oh, I think you are right, filemap_offline_hwpoison_folio_hugetlb
> >>>> shouldn't call take_page_off_buddy(page) depend on PageBuddy(page) o=
r
> >>>> not. take_page_off_buddy will check PageBuddy or not, on the page_he=
ad
> >>>> of different page orders. So maybe somehow a known poisoned page is
> >>>> not taken off from buddy allocator due to this?
> >>>
> >>> Maybe it's the case where the poisoned page is merged to a larger pag=
e,
> >>> and the PGTY_buddy flag is set on its buddy of the poisoned page, so
> >>> PageBuddy() returns false?:
> >>>
> >>>   [ free page A ][ free page B (poisoned) ]
> >>>
> >>> When these two are merged, then we set PGTY_buddy on page A but not o=
n B.
> >>
> >> Thanks Harry!
> >>
> >> It is indeed this case. I validate by adding some debug prints in
> >> take_page_off_buddy:
> >>
> >> [ 193.029423] Memory failure: 0x2800200: [yjq] PageBuddy=3D0 after dra=
in_all_pages
> >> [ 193.029426] 0x2800200: [yjq] order=3D0, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029428] 0x2800200: [yjq] order=3D1, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029429] 0x2800200: [yjq] order=3D2, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029430] 0x2800200: [yjq] order=3D3, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029431] 0x2800200: [yjq] order=3D4, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029432] 0x2800200: [yjq] order=3D5, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029434] 0x2800200: [yjq] order=3D6, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029435] 0x2800200: [yjq] order=3D7, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029436] 0x2800200: [yjq] order=3D8, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029437] 0x2800200: [yjq] order=3D9, page_order=3D0, PageBuddy(pa=
ge_head)=3D0
> >> [ 193.029438] 0x2800200: [yjq] order=3D10, page_order=3D10, PageBuddy(=
page_head)=3D1
> >>
> >> In this case, page for 0x2800200 is hwpoisoned, and its buddy page is
> >> 0x2800000 with order 10.
> >
> > Woohoo, I got it right!
> >
> >>> But even after fixing that we need to fix the race condition.
> >>
> >> What exactly is the race condition you are referring to?
> >
> > When you free a high-order page, the buddy allocator doesn't not check
> > PageHWPoison() on the page and its subpages. It checks PageHWPoison()
> > only when you free a base (order-0) page, see free_pages_prepare().
>
> I think we might could check PageHWPoison() for subpages as what free_pag=
e_is_bad()
> does. If any subpage has HWPoisoned flag set, simply drop the folio. Even=
 we could

Agree, I think as a starter I could try to, for example, let
free_pages_prepare scan HWPoison-ed subpages if the base page is high
order. In the optimal case, HugeTLB does move PageHWPoison flag from
head page to the raw error pages.

> do it better -- Split the folio and let healthy subpages join the buddy w=
hile reject
> the hwpoisoned one.
>
> >
> > AFAICT there is nothing that prevents the poisoned page to be
> > allocated back to users because the buddy doesn't check PageHWPoison()
> > on allocation as well (by default).
> >
> > So rather than freeing the high-order page as-is in
> > dissolve_free_hugetlb_folio(), I think we have to split it to base page=
s
> > and then free them one by one.
>
> It might not be worth to do that as this would significantly increase the=
 overhead
> of the function while memory failure event is really rare.

IIUC, Harry's idea is to do the split in dissolve_free_hugetlb_folio
only if folio is HWPoison-ed, similar to what Miaohe suggested
earlier.

BTW, I believe this race condition already exists today when
memory_failure handles HWPoison-ed free hugetlb page; it is not
something introduced via this patchset. I will fix or improve this in
a separate patchset.

>
> Thanks both.

Thanks Harry and Miaohe!


> .
>
> >
> > That way, free_pages_prepare() will catch that it's poisoned and won't
> > add it back to the freelist. Otherwise there will always be a window
> > where the poisoned page can be allocated to users - before it's taken
> > off from the buddy.
> >
>

