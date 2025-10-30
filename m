Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1E8BCCF9F0
	for <linux-mm@archiver.kernel.org>; Thu, 30 Oct 2025 21:29:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C1CE8E01E4; Thu, 30 Oct 2025 17:29:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 498D98E009F; Thu, 30 Oct 2025 17:29:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3AEDE8E01E4; Thu, 30 Oct 2025 17:29:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2B6058E009F
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 17:29:06 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7F3C12A908
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:29:05 +0000 (UTC)
X-FDA: 84056071050.09.DDA60AA
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 03945100005
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 21:29:03 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AUUwHOfo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761859744; a=rsa-sha256;
	cv=none;
	b=zr1oq3X7GP3cbCssv6NLI2i5Qr07o7uzztTiyKYP9uul07mTRo/NfyNcwf3p63tr8Qn74B
	ibn+byPwKTQtBuaXMGkK986gTWGRdsVbHZ6LXNlCF6P7KVVE2/tZE9Cyq6ohI+JPirRag4
	rC7e+eCNw97CPMkg4o0OFA5Hs5/grFs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AUUwHOfo;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf14.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761859744;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sc9LTmQ0OPF7AQNspYRAtEgFt0JZnJtSWDRnSHOv73Y=;
	b=m3nGf8YqRpindvMh3ttaoHPPPsGB39lb8J6FX+cTK6DSeIsM7aiyvpsmSCDNkZQ4sigAGP
	N6/ZYpde69MX8r8+LQ+ZlZDHq4hO+TIxx2+Cl6WwWuL4E9qiToQGSx3QbGyQn4gmOVKPcS
	UwoIOoAHHHrFbr6dtU9quPdtbYPW2BI=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-470ff2f6e56so20605e9.0
        for <linux-mm@kvack.org>; Thu, 30 Oct 2025 14:29:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761859742; x=1762464542; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sc9LTmQ0OPF7AQNspYRAtEgFt0JZnJtSWDRnSHOv73Y=;
        b=AUUwHOfoCzlOQIWuF7FVt7aqADrpv7eJB9QWsKopUFQ+RaMdWbhialYOw4T1Ub5W22
         x/HLcjGhvNe2wf2QvyEDi2sc6e8ClW3p5KnttxJtPusG+CV3VFt8A6RQjDulXZkGyfNw
         8Z/nNCbZ5xxYdsHUAJ8xVU4/b901bho0gzB5bG8TnRM8y2vqSBYtxPf30FX1hYOTqym4
         /xJ6gm5PfAr7BHk476UJSKm1H8T3O8J3bq/Z3WbEFa1cJlyKJKJ462VAhG0blmzorACF
         bS5y25QPUQIlFahH7tlFRMD2RQPc6MpWm+jyZPfAOWiUXc1irO2nPKhn4Z285NYS6tVW
         b/Vw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761859742; x=1762464542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sc9LTmQ0OPF7AQNspYRAtEgFt0JZnJtSWDRnSHOv73Y=;
        b=RzbLjcf0ED7t7VFcDg6rYOOwTMktwaEBD0rQAoxnAfgBWvkNFFW78sLv2yc+UEoaIJ
         873jSBQ81EImaEFkyCxdYOvbSmTXq6mo2ijXjCPVqVy3ebX0Igm0SF1/hhUjI/1urVNV
         SdeX22bGWFqlr6WXrya3lfeiFRjQFAgVv34EX3lyQ8l9fVtY7QhlpS/gRL+FkfUARWBS
         ooiCQlegK6ToL9kBbm2h2iAvRFoQ+PRZi+y0s5Qb5R9U/JjFNwneAC9WwbaIeOkzbPh5
         lJW2QleGZtDiCsECZ//iTbOxy8x1XltcEow2Da5nDohPSgrJ1+HEH5OilEeI2+naExIt
         IXYw==
X-Forwarded-Encrypted: i=1; AJvYcCXrdOaK7s/OUGUdvV6xE58sPB7bRGnd9Nb4mZO3bkVisghXFRofOxEDni7kdVXhbm1pUx278rilYA==@kvack.org
X-Gm-Message-State: AOJu0YwNR7cTHv4tIaLtMOAd3pmxhJAKcwH7Wg70NnE2yJwdupOV1F90
	+xvkopu5xvqZG6JPEvAcsxGL/sgRwaG6+irOdeZMxXBz/hMPzbs89gxko/x7hz7y0GH2QWJdwMs
	X4mdvql7LJlEQzGvBa/ge3VhyrC6D2HH6TL+eNcZi
X-Gm-Gg: ASbGnctwPhGIhqjlNIAVtO7m8vJloqQkbjMsvW8eevZeN3gbd5MSjr+feQJ5hRKeBq1
	QZbrzHneJYG78gtAG5GG8j1b/KLPrmXbya6rVmQoMusz1wijjoKpVDHnEG16hVY0qryyycRgjAP
	jHRHVwtqGMO457z5WtPX/MKLYAv4Iit1VTQ+NmW4fdC+L9yfm3c5vjTiF0KS3CL8oD3w7Uv3jv2
	lWpW9nUeZICE5f0auA7jI1vDqW1jYD3/cLcG+MdP3VElc45/obENoU/AXFDhx8cVXKdAv1hH1yI
	zENTi2GH2yEplss=
X-Google-Smtp-Source: AGHT+IHHa+mxe2nHccFbFaghuaSDYkwuMWhzYSMqf2OY1KgkmzZBGYlY/xWgIovTrxMUjwhSNsP4FKGpKcuCVCJhuNE=
X-Received: by 2002:a05:600c:a49:b0:472:ce95:eb44 with SMTP id
 5b1f17b1804b1-477324a6ed3mr247635e9.3.1761859742031; Thu, 30 Oct 2025
 14:29:02 -0700 (PDT)
MIME-Version: 1.0
References: <20250118231549.1652825-1-jiaqiyan@google.com> <20250919155832.1084091-1-william.roche@oracle.com>
 <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com>
 <aPjXdP63T1yYtvkq@hyeyoo> <CACw3F50As2jPzy1rRjzpm3uKOALjX_9WmKxMPGnQcok96OfQkA@mail.gmail.com>
 <aQBqGupCN_v8ysMX@hyeyoo> <d3d35586-c63f-c1be-c95e-fbd7aafd43f3@huawei.com> <CACw3F51qaug5aWFNcjB54dVEc8yH+_A7zrkGcQyKXKJs6uVvgA@mail.gmail.com>
In-Reply-To: <CACw3F51qaug5aWFNcjB54dVEc8yH+_A7zrkGcQyKXKJs6uVvgA@mail.gmail.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 30 Oct 2025 14:28:50 -0700
X-Gm-Features: AWmQ_bnzs5sTXcmQM7upX8IRDlkxcYWM8GOFkUz1vs-zu-EDjQkmvbs_aong1qA
Message-ID: <CACw3F50K7w2WuCoRZxDFiosBr_GSb62z1sVGEHQKC2QHGBAP9A@mail.gmail.com>
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
X-Stat-Signature: upebgzbibujpo98mxo6cf6u1iff5pixa
X-Rspamd-Queue-Id: 03945100005
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1761859743-300436
X-HE-Meta: U2FsdGVkX1/dtgG7QtTTPnkuQ/ZaCKrlkLUbXUIhs4fPt48Gm+QN9MC9b4HOk42YPV+ZrjBqDuuGX0UwUPXvHmP67QwIDnAqeh7XGUbx5Uikl3zdwf13KvcTyIQSvYPbOwdhcGIssji4N+hKdnS4YqP6gf8mHVmZ1pY3h7jMvm/F5HEG7F4NsqcW6doYJws0WnbkZLhNQYVvzUXvfFa2e0sagngGT3Lad33T5sO0nojdSVtuNhpt2k1c6akdsyyam5DdLfpOCv2eBcAfAL8Mj3y9Rk4lAoGdqoq/ai3MOh3BFjV2cl7dh/dqpemJx2M2S7UDqbpxEjjdY9tGpfcpDJ+TYbrvL/fZKshSuOJJrAjvNf/JBIm5g1gkiU6sCippiWORoLmvmr4Qh8EQapCSKI4qiK9xMgxEGeQmqQKz0PB0+cugz63hCW3xbB0fwM9ysSpChCqwo2Nr534pyIgSKQ7GKIwKRrALkQGK5jGabSW1DJEAZGvoQAAgg3agCTnMGskkuy7QbycimopyuN5W9hF6auWbVnOm9Fu7HGbMunr9M1tbg/0N+YBqG5I5r8fFyizG2z54ag2HorKSeiydjETS8fRV3TlPoamT6IwJD919EqAHHF2JyN6i8frXIly7WwVfUTQdhl9JpSXX4wTV8w7K8PjLyvMGyKXzAm2zHDQYq0T65Hbfw3blK1rc23I0zjyhZ5YjjQT0q6iRcs6QQ8hsGXGz23o3SSA40MRLIbSe+Xpn2E/LMz402Lkj2v+xmoMQdk1JZt1mdaoR7FOHYYoI3T+VZS/2d10eFACcF5RYL1vmPOQqOcc0efApmXQg8vvyfVLXfFuEnSSqCrvRL+TKalA/0sXgru7OxEmb8JYVjuofPDEsZmBJfURAUzeY2oTNRC/h7d4a2FWwWD6SCRaTHe/0nUCx34KYhAOdi8dI+DRjb2j7re2uxEUXC8Klal1G/h+7MmX/3qRGXwz
 xhdCnqRs
 9byYsM8Fs1YrG2PIJFapEANjTNLFV1t0Ouzwg4ppxUTZ2U0yjIz6hr1Loi9bPh1kpY3dsF3mmFN4vhgsbGHcqFDDwBFWqfbxKlETtDhS6JH223nCP8DYmJ03TGcc8j/m+t6glfuv2c3XQWPPDETm+Nc49gCqy0d1o3oYY52nQRbf0uFE7MfY9RWBA2bWzQ77RNutMvoDuTmW6nHT8nT19pQCVvB0td2oF9XTfXTs6eB4T/acwVV5l1CApeGd10zQuLXOjSPpUPQhoc57QrWO5Nq1HlAvW7hT3MaqqXZ5GbQk/ovMEyZbK8ps1eC6wb0kw07vQpccwErB/E77lDWVFcW10RcHmeb7H2F/x1q/D2b2WHLI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 30, 2025 at 10:28=E2=80=AFAM Jiaqi Yan <jiaqiyan@google.com> wr=
ote:
>
> On Thu, Oct 30, 2025 at 4:51=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com>=
 wrote:
> >
> > On 2025/10/28 15:00, Harry Yoo wrote:
> > > On Mon, Oct 27, 2025 at 09:17:31PM -0700, Jiaqi Yan wrote:
> > >> On Wed, Oct 22, 2025 at 6:09=E2=80=AFAM Harry Yoo <harry.yoo@oracle.=
com> wrote:
> > >>>
> > >>> On Mon, Oct 13, 2025 at 03:14:32PM -0700, Jiaqi Yan wrote:
> > >>>> On Fri, Sep 19, 2025 at 8:58=E2=80=AFAM =E2=80=9CWilliam Roche <wi=
lliam.roche@oracle.com> wrote:
> > >>>>>
> > >>>>> From: William Roche <william.roche@oracle.com>
> > >>>>>
> > >>>>> Hello,
> > >>>>>
> > >>>>> The possibility to keep a VM using large hugetlbfs pages running =
after a memory
> > >>>>> error is very important, and the possibility described here could=
 be a good
> > >>>>> candidate to address this issue.
> > >>>>
> > >>>> Thanks for expressing interest, William, and sorry for getting bac=
k to
> > >>>> you so late.
> > >>>>
> > >>>>>
> > >>>>> So I would like to provide my feedback after testing this code wi=
th the
> > >>>>> introduction of persistent errors in the address space: My tests =
used a VM
> > >>>>> running a kernel able to provide MFD_MF_KEEP_UE_MAPPED memfd segm=
ents to the
> > >>>>> test program provided with this project. But instead of injecting=
 the errors
> > >>>>> with madvise calls from this program, I get the guest physical ad=
dress of a
> > >>>>> location and inject the error from the hypervisor into the VM, so=
 that any
> > >>>>> subsequent access to the location is prevented directly from the =
hypervisor
> > >>>>> level.
> > >>>>
> > >>>> This is exactly what VMM should do: when it owns or manages the VM
> > >>>> memory with MFD_MF_KEEP_UE_MAPPED, it is then VMM's responsibility=
 to
> > >>>> isolate guest/VCPUs from poisoned memory pages, e.g. by intercepti=
ng
> > >>>> such memory accesses.
> > >>>>
> > >>>>>
> > >>>>> Using this framework, I realized that the code provided here has =
a problem:
> > >>>>> When the error impacts a large folio, the release of this folio d=
oesn't isolate
> > >>>>> the sub-page(s) actually impacted by the poison. __rmqueue_pcplis=
t() can return
> > >>>>> a known poisoned page to get_page_from_freelist().
> > >>>>
> > >>>> Just curious, how exactly you can repro this leaking of a known po=
ison
> > >>>> page? It may help me debug my patch.
> > >>>>
> > >>>>>
> > >>>>> This revealed some mm limitations, as I would have expected that =
the
> > >>>>> check_new_pages() mechanism used by the __rmqueue functions would=
 filter these
> > >>>>> pages out, but I noticed that this has been disabled by default i=
n 2023 with:
> > >>>>> [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> > >>>>> https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> > >>>>
> > >>>> Thanks for the reference. I did turned on CONFIG_DEBUG_VM=3Dy duri=
ng dev
> > >>>> and testing but didn't notice any WARNING on "bad page"; It is ver=
y
> > >>>> likely I was just lucky.
> > >>>>
> > >>>>>
> > >>>>>
> > >>>>> This problem seems to be avoided if we call take_page_off_buddy(p=
age) in the
> > >>>>> filemap_offline_hwpoison_folio_hugetlb() function without testing=
 if
> > >>>>> PageBuddy(page) is true first.
> > >>>>
> > >>>> Oh, I think you are right, filemap_offline_hwpoison_folio_hugetlb
> > >>>> shouldn't call take_page_off_buddy(page) depend on PageBuddy(page)=
 or
> > >>>> not. take_page_off_buddy will check PageBuddy or not, on the page_=
head
> > >>>> of different page orders. So maybe somehow a known poisoned page i=
s
> > >>>> not taken off from buddy allocator due to this?
> > >>>
> > >>> Maybe it's the case where the poisoned page is merged to a larger p=
age,
> > >>> and the PGTY_buddy flag is set on its buddy of the poisoned page, s=
o
> > >>> PageBuddy() returns false?:
> > >>>
> > >>>   [ free page A ][ free page B (poisoned) ]
> > >>>
> > >>> When these two are merged, then we set PGTY_buddy on page A but not=
 on B.
> > >>
> > >> Thanks Harry!
> > >>
> > >> It is indeed this case. I validate by adding some debug prints in
> > >> take_page_off_buddy:
> > >>
> > >> [ 193.029423] Memory failure: 0x2800200: [yjq] PageBuddy=3D0 after d=
rain_all_pages
> > >> [ 193.029426] 0x2800200: [yjq] order=3D0, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029428] 0x2800200: [yjq] order=3D1, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029429] 0x2800200: [yjq] order=3D2, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029430] 0x2800200: [yjq] order=3D3, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029431] 0x2800200: [yjq] order=3D4, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029432] 0x2800200: [yjq] order=3D5, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029434] 0x2800200: [yjq] order=3D6, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029435] 0x2800200: [yjq] order=3D7, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029436] 0x2800200: [yjq] order=3D8, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029437] 0x2800200: [yjq] order=3D9, page_order=3D0, PageBuddy(=
page_head)=3D0
> > >> [ 193.029438] 0x2800200: [yjq] order=3D10, page_order=3D10, PageBudd=
y(page_head)=3D1
> > >>
> > >> In this case, page for 0x2800200 is hwpoisoned, and its buddy page i=
s
> > >> 0x2800000 with order 10.
> > >
> > > Woohoo, I got it right!
> > >
> > >>> But even after fixing that we need to fix the race condition.
> > >>
> > >> What exactly is the race condition you are referring to?
> > >
> > > When you free a high-order page, the buddy allocator doesn't not chec=
k
> > > PageHWPoison() on the page and its subpages. It checks PageHWPoison()
> > > only when you free a base (order-0) page, see free_pages_prepare().
> >
> > I think we might could check PageHWPoison() for subpages as what free_p=
age_is_bad()
> > does. If any subpage has HWPoisoned flag set, simply drop the folio. Ev=
en we could
>
> Agree, I think as a starter I could try to, for example, let
> free_pages_prepare scan HWPoison-ed subpages if the base page is high
> order. In the optimal case, HugeTLB does move PageHWPoison flag from
> head page to the raw error pages.

Another idea I came up with today and is trying out is:
1. let buddy allocator reject the high order folio first based on the
HWPoison-ed flag
2. memory_failure takes the advantage of break_down_buddy_pages to add
free pages to freelist, but keep target/hwpoison-ed page off the
freelist

>
> > do it better -- Split the folio and let healthy subpages join the buddy=
 while reject
> > the hwpoisoned one.
> >
> > >
> > > AFAICT there is nothing that prevents the poisoned page to be
> > > allocated back to users because the buddy doesn't check PageHWPoison(=
)
> > > on allocation as well (by default).
> > >
> > > So rather than freeing the high-order page as-is in
> > > dissolve_free_hugetlb_folio(), I think we have to split it to base pa=
ges
> > > and then free them one by one.
> >
> > It might not be worth to do that as this would significantly increase t=
he overhead
> > of the function while memory failure event is really rare.
>
> IIUC, Harry's idea is to do the split in dissolve_free_hugetlb_folio
> only if folio is HWPoison-ed, similar to what Miaohe suggested
> earlier.
>
> BTW, I believe this race condition already exists today when
> memory_failure handles HWPoison-ed free hugetlb page; it is not
> something introduced via this patchset. I will fix or improve this in
> a separate patchset.
>
> >
> > Thanks both.
>
> Thanks Harry and Miaohe!
>
>
> > .
> >
> > >
> > > That way, free_pages_prepare() will catch that it's poisoned and won'=
t
> > > add it back to the freelist. Otherwise there will always be a window
> > > where the poisoned page can be allocated to users - before it's taken
> > > off from the buddy.
> > >
> >

