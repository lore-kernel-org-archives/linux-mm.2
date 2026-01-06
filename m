Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4EAC6C47BDD
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 10:33:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FFCC6B008A; Tue,  6 Jan 2026 05:33:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ADA86B0093; Tue,  6 Jan 2026 05:33:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882796B0095; Tue,  6 Jan 2026 05:33:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7437A6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 05:33:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1351CB98DE
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:33:49 +0000 (UTC)
X-FDA: 84301178178.06.4892761
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2CD094000D
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 10:33:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BNvva7TF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767695627; a=rsa-sha256;
	cv=none;
	b=qvTMq7bQXvHZ2GCZgCsMpw0ARhnpq+L9b1g9oz5jLh4hbjFmCBiBzgz3hNihO7tAPP7XnM
	EOOhqoFIEkpIm/9ZzxFZl4yykzX7tCUrEuBPIhUnNlriQvkpuINLHMDPo/T9JwNoL9ZDrN
	m2FTc4TU42Q1wm9AKTPXSapvbfI1yIo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=BNvva7TF;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf01.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.180 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767695627;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E9klNFmUTzy6sNUVhJVCx5tQ++GAOUF4tNkd0Q9mWag=;
	b=NzQQzIBolz37IVGPoDHoA1CdwQbRLFMIzhXjKQ9ldwyvJZCUn5T64kuUbfZalTNVrvXNZd
	YVURBOUVlkbosF4Rr58PbeWw+nnVejY5Cz87l7L+tgnHGSDyBXyPm0vOFD2TchLCW/FB1X
	lDmIQHoHAEmLSlRnhOaQTpa3ie3uP0U=
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b2d32b9777so104074485a.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 02:33:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767695626; x=1768300426; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=E9klNFmUTzy6sNUVhJVCx5tQ++GAOUF4tNkd0Q9mWag=;
        b=BNvva7TFcY5Jue71uVRVO8jAGootUaud1LSJ4819vVJ2W7DsF6Hsy6OCHXdI+nJPCJ
         Ubm71d603H2+0bUE8sVdQLgo/aD5TSUKmQMdzKdclpdzZbFC+UZKVKf5HmeN0padJGcd
         SzBWeZKU7wde4EGNes4mRgYbyaxQlwBEmm8wqNe3/GCsU+kwCvuI3JzCHQRmEj/SZ3+W
         2rNuyzGW3EfWKkDiUbWxnbxUE3BLtHcP+AP9aZnIdHmBtqOfj+cb4xxkjjiKv13U4MH/
         k7LH4pd6xZYDvIyBZ1xh8C401sMxruNxJG2Xr4Vx4V1DlYDjZN4itS1S63olzsYQNmB7
         /52g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767695626; x=1768300426;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=E9klNFmUTzy6sNUVhJVCx5tQ++GAOUF4tNkd0Q9mWag=;
        b=K1guPqE1eWI5IX8uAMx+hoxNqlxJr06od/iYCdYU0klFaD+gkaMUm+XrtHAo/O58bB
         ljSmGG2tp0PgPulBPJ2EmGUzgKU0hahGE0GjLplTS9KbWxHz+tCiHQKNuF2SYBWRGNsI
         Y/0DOaLBiHaFitkNAnHp+5urzAIAlL9BcMTz20Oewk42wY6QOJMuDd7DgYplF4vORlwY
         xkHa1uNWeLOW12TGHF9eUjss9UbzKoyFcPmRyB4mXDHkddvPuwFlsElfFpEWxxvTEWXp
         rXKNzJ86HxNJSS33W4m14YsMmsPsfxcSegH6tRBKr2+lEBxjJnvVp3u9vbRA7UCWGX3K
         o1TA==
X-Forwarded-Encrypted: i=1; AJvYcCXDExSnGgIRfwNRAqWKdzSDFK0qUz3Z1bvM9ZUpemjRx/QOUZvh4VbvNJ9fmEQk1wuCF04A0Sy6wQ==@kvack.org
X-Gm-Message-State: AOJu0Yw+/pbX6wZj1Aurx12zVfEAseeR5FvLHTXRHgOXQEWs2ysrSN0n
	g7JGPI8GbdfEgU+ZzZpwIcqpw+4Bs1PoPUuSD0zwKd1+Hee8kMA//R/uYwLNBwBzJ4Fk1dKslty
	dIaot4gH0TccLVedxZvH0OMC2DOKLV6M=
X-Gm-Gg: AY/fxX6SAxjjfsSE8Lo98Vx3j8sqNBZwDOmMH7MzBionPUD+C05zR9ci6qNkku1qCpD
	FBRzuBbrqD3D4UNS0dkYbV+fQZF7mtSKpP0ma8qWQ3z5JOJYoWNHmcAwFDvw1qkM0VBdI0EC/Qu
	MtUfP6y9BpMjEFdLPoXAaAQ5chyahNR8SgnFXx2tmsCk3dJzn5Urwg5Yejvvc3sP1EIgAwREBZ2
	+AAUXOzy1aokxWs8APtin6X8Gih9xu/wgP1C+uUPN/EZwM4zCQ9y/8CEuwESK8jiHnhGA==
X-Google-Smtp-Source: AGHT+IGf13WsxPzfo2pw6wl8GnmsKvPkW2yREnBu27xbMB7GRCU7uw4M1KzR0FgEg0R59YNt4PCY80Q+984D2Ss+Y2k=
X-Received: by 2002:a05:622a:4b:b0:4ee:2420:4f7a with SMTP id
 d75a77b69052e-4ffa76d7e53mr28281851cf.2.1767695626048; Tue, 06 Jan 2026
 02:33:46 -0800 (PST)
MIME-Version: 1.0
References: <20260104054112.4541-1-yanglincheng@kylinos.cn>
 <20260104054112.4541-6-yanglincheng@kylinos.cn> <9c82ffaa-5f62-4110-80cc-00f0c46e90fb@linux.dev>
 <3lbptab7e2nhqilwnoccq6kxks2r55j3ffqtslt62o2qtgulk5@w4mwglb2kd75>
 <d3fd4546-3161-4d58-b018-31aca53b6b04@linux.dev> <CACZaFFNJO+-yZdDPdN-5rQLuJvT5cp2pbtqV13FHo9PeqtxARg@mail.gmail.com>
 <cf094519-82e1-4f11-b670-dacf89da22ef@linux.dev> <tpowqsrlxwx6hu5ljry54wpt5lverarqeincc3jufrqhfjmwwy@uzs6q6gecubd>
In-Reply-To: <tpowqsrlxwx6hu5ljry54wpt5lverarqeincc3jufrqhfjmwwy@uzs6q6gecubd>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 6 Jan 2026 23:33:35 +1300
X-Gm-Features: AQt7F2qphJhO64cajLuvqpcjj2lDx69fk6-O5XtddzzcRaGAnvj210J9o7j8rWU
Message-ID: <CAGsJ_4wXg_jZQ+RTK=zR2vohijz7A+RU9nXdp2CDmyE=Zyvu8Q@mail.gmail.com>
Subject: Re: [PATCH v3 5/6] mm: khugepaged: skip lazy-free folios at scanning
To: Vernon Yang <vernon2gm@gmail.com>
Cc: Lance Yang <lance.yang@linux.dev>, lorenzo.stoakes@oracle.com, ziy@nvidia.com, 
	dev.jain@arm.com, richard.weiyang@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>, 
	akpm@linux-foundation.org, david@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 2CD094000D
X-Rspamd-Server: rspam03
X-Stat-Signature: a6h1fi3z8s1texxt15hs3ftrsi4z55z8
X-Rspam-User: 
X-HE-Tag: 1767695627-244159
X-HE-Meta: U2FsdGVkX19w1X9muMq/nBHSAaz7XwC5qT3uT/3SfT80uhS+2ha15glpwaRYOQjpMShgIq3KFfOFvTBaZjIFvApm/dkRa1ud6ALTTLGTI+SeQyLmDaRPkTos7cyLRoPbMGNphTLnf84bfoxS2Up0PI+rdywX21RxxULTMYn8aac8fIar/MCoXmz0VrlvcfPSDr9WDkMNInS0DmJOE552n1jpAnazOx/cxrVXbLP10JJ+cfdJBGLhj4DXxqjy1RXYqGoTa0o38WTHLk0dkdU5AoxMU+OvgUAVOI3HLT82Y1vpPenvps2EFktVqdgyhewW6kI9e4Ph8rGiYLg2SzGOBaOzsyD9q5iv4udPZ84p7XgqERYDaBq9/Gw8qHUIapJRgsql7DVjxg5bEsyb8Nc5+lF4jT/+o+wAcgYd8fjhA2Nco7Xg5OcuKMbm9w4pdskyRi3O25nenJrO/X8J3QcFiVWBi4KoVMdL7QJL2Nb3pZyCAnlvZ1MdELzXNqwanxf4WF43caj1wJVWJsnu0s9XCiovRyGEaZhTnY91cEwWPAOO5RuMKJap2CRCQAhCPrw/LGU6nQfX04Fivd9JXoInq03b2QRD0Z+H+fLZl+O0CYqLhK6pagFPR0tgkXswQ5LpYy0Wq633qjux6iQlg6Wvi8N0YPXnJGGOU16IFFo5PDaGCJEV6oZsRng7oHgIZg+TJbQD88ehlb4Ytz/ZpFAASqSOyKr8kIxGdN9ynZWW6b6L1Yz73mgwhlmH17ooOnJtgHgO0dk/+I5lrArfw02pzQaA+CPXD1SIzClycM7sqZBQNNh0+5K8rQw5sa9ObOhgGr0Fgzdj9WHQSM6I8wigUIao5O0PQKbcNbfE5AzStJ91pLwxUy0uVWFYpC/5ZoVulXLsazTVCWaqNZ4VQZkOACBbLPtVBoN6eBvpl87xhNXgSTL6oyrKOcR6tzZOd82hQjcZOntGTVdiahkDf3U
 wfp0UVxN
 IYNuLB3VLJnZce8EtYMv62ifgx3ucP00KqkIGuAzxIHcEAEB7s21j+65cTyOZzKeOtNRoRHjZJdC59TNebFUyiakSGDjuAMOZcUAl+weohmLAKlOmerUBmEz+b6Dj6NgptlH1/GuT+6yf3qbhkvC9kKY70zx3ESs4UBbJTZ8RTgjD3dtzgaW06RRQm7ZpwOJo0dUtQMzZr2ISzoo46F2o/T2Gl7PN8h2D47qcgVsmsNkBnB56ZJ4fIFxW+xHwPBUmLaW8y6pdcxHqj/l9hmSSjlEEKfeyGZ3s2JGeoiwFsIpvhXZRmrexIv4FKT0pau3xT6akhSMSHpo2i+O/IOJ2OAr1h85oe9DUSBdm2E5AkZ+baedVfbTBeVfo8opvm52AMCQzG26oF4UC+duLyBuGyS2ZGQaMpBfoa7bcAdHEoFEaTb0Dmed+2yr4kJIRpeSSDjWH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 6, 2026 at 1:31=E2=80=AFAM Vernon Yang <vernon2gm@gmail.com> wr=
ote:
>
> On Mon, Jan 05, 2026 at 11:35:58AM +0800, Lance Yang wrote:
> >
> >
> > On 2026/1/5 11:12, Vernon Yang wrote:
> > > On Mon, Jan 5, 2026 at 10:51=E2=80=AFAM Lance Yang <lance.yang@linux.=
dev> wrote:
> > > >
> > > > On 2026/1/5 09:48, Vernon Yang wrote:
> > > > > On Sun, Jan 04, 2026 at 08:10:17PM +0800, Lance Yang wrote:
> > > > > >
> > > > > >
> > > > > > On 2026/1/4 13:41, Vernon Yang wrote:
> > > > > > > For example, create three task: hot1 -> cold -> hot2. After a=
ll three
> > > > > > > task are created, each allocate memory 128MB. the hot1/hot2 t=
ask
> > > > > > > continuously access 128 MB memory, while the cold task only a=
ccesses
> > > > > > > its memory briefly andthen call madvise(MADV_FREE). However, =
khugepaged
> > > > > > > still prioritizes scanning the cold task and only scans the h=
ot2 task
> > > > > > > after completing the scan of the cold task.
> > > > > > >
> > > > > > > So if the user has explicitly informed us via MADV_FREE that =
this memory
> > > > > > > will be freed, it is appropriate for khugepaged to skip it on=
ly, thereby
> > > > > > > avoiding unnecessary scan and collapse operations to reducing=
 CPU
> > > > > > > wastage.
> > > > > > >
> > > > > > > Here are the performance test results:
> > > > > > > (Throughput bigger is better, other smaller is better)
> > > > > > >
> > > > > > > Testing on x86_64 machine:
> > > > > > >
> > > > > > > | task hot2           | without patch | with patch    |  delt=
a  |
> > > > > > > |---------------------|---------------|---------------|------=
---|
> > > > > > > | total accesses time |  3.14 sec     |  2.93 sec     | -6.69=
%  |
> > > > > > > | cycles per access   |  4.96         |  2.21         | -55.4=
4% |
> > > > > > > | Throughput          |  104.38 M/sec |  111.89 M/sec | +7.19=
%  |
> > > > > > > | dTLB-load-misses    |  284814532    |  69597236     | -75.5=
6% |
> > > > > > >
> > > > > > > Testing on qemu-system-x86_64 -enable-kvm:
> > > > > > >
> > > > > > > | task hot2           | without patch | with patch    |  delt=
a  |
> > > > > > > |---------------------|---------------|---------------|------=
---|
> > > > > > > | total accesses time |  3.35 sec     |  2.96 sec     | -11.6=
4% |
> > > > > > > | cycles per access   |  7.29         |  2.07         | -71.6=
0% |
> > > > > > > | Throughput          |  97.67 M/sec  |  110.77 M/sec | +13.4=
1% |
> > > > > > > | dTLB-load-misses    |  241600871    |  3216108      | -98.6=
7% |
> > > > > > >
> > > > > > > Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> > > > > > > ---
> > > > > > >     include/trace/events/huge_memory.h | 1 +
> > > > > > >     mm/khugepaged.c                    | 6 ++++++
> > > > > > >     2 files changed, 7 insertions(+)
> > > > > > >
> > > > > > > diff --git a/include/trace/events/huge_memory.h b/include/tra=
ce/events/huge_memory.h
> > > > > > > index 01225dd27ad5..e99d5f71f2a4 100644
> > > > > > > --- a/include/trace/events/huge_memory.h
> > > > > > > +++ b/include/trace/events/huge_memory.h
> > > > > > > @@ -25,6 +25,7 @@
> > > > > > >      EM( SCAN_PAGE_LRU,              "page_not_in_lru")      =
        \
> > > > > > >      EM( SCAN_PAGE_LOCK,             "page_locked")          =
        \
> > > > > > >      EM( SCAN_PAGE_ANON,             "page_not_anon")        =
        \
> > > > > > > +   EM( SCAN_PAGE_LAZYFREE,         "page_lazyfree")         =
       \
> > > > > > >      EM( SCAN_PAGE_COMPOUND,         "page_compound")        =
        \
> > > > > > >      EM( SCAN_ANY_PROCESS,           "no_process_for_page")  =
        \
> > > > > > >      EM( SCAN_VMA_NULL,              "vma_null")             =
        \
> > > > > > > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > > > > > > index 30786c706c4a..1ca034a5f653 100644
> > > > > > > --- a/mm/khugepaged.c
> > > > > > > +++ b/mm/khugepaged.c
> > > > > > > @@ -45,6 +45,7 @@ enum scan_result {
> > > > > > >      SCAN_PAGE_LRU,
> > > > > > >      SCAN_PAGE_LOCK,
> > > > > > >      SCAN_PAGE_ANON,
> > > > > > > +   SCAN_PAGE_LAZYFREE,
> > > > > > >      SCAN_PAGE_COMPOUND,
> > > > > > >      SCAN_ANY_PROCESS,
> > > > > > >      SCAN_VMA_NULL,
> > > > > > > @@ -1337,6 +1338,11 @@ static int hpage_collapse_scan_pmd(str=
uct mm_struct *mm,
> > > > > > >              }
> > > > > > >              folio =3D page_folio(page);
> > > > > > > +           if (folio_is_lazyfree(folio)) {
> > > > > > > +                   result =3D SCAN_PAGE_LAZYFREE;
> > > > > > > +                   goto out_unmap;
> > > > > > > +           }
> > > > > >
> > > > > > That's a bit tricky ... I don't think we need to handle MADV_FR=
EE pages
> > > > > > differently :)
> > > > > >
> > > > > > MADV_FREE pages are likely cold memory, but what if there are j=
ust
> > > > > > a few MADV_FREE pages in a hot memory region? Skipping the enti=
re
> > > > > > region would be unfortunate ...
> > > > >
> > > > > If there are hot in lazyfree folios, the folio will be set as non=
-lazyfree
> > > > > in the memory reclaim path, it is not skipped in the next scan in=
 the
> > > > > khugepaged.
> > > > >
> > > > > shrink_folio_list()
> > > > >     try_to_unmap()
> > > > >       folio_set_swapbacked()
> > > > >
> > > > > If there are no hot in lazyfree folios, continuing the collapse w=
ould
> > > > > waste CPU and require a long wait (khugepaged_scan_sleep_millisec=
s).
> > > > > Additionally, due to collapse hugepage become non-lazyfree, preve=
nting
> > > > > the rapid release of lazyfree folios in the memory reclaim path.
> > > > >
> > > > > So skipping lazy-free folios make sense here for us.
> > > > >
> > > > > If I missed something, please let me know, thank!
> > > >
> > > > I'm not saying lazyfree pages become hot :)
> > > >
> > > > If a PMD region has mostly hot pages but just a few lazyfree
> > > > pages, we would skip the entire region. Those hot pages won't
> > > > be collapsed.
> > >
> > > Same above, the lazyfree folios will be set as non-lazyfree
> >
> > Nop ...
> >
> > > in the memory reclaim path, it is not skipped in the next scan,
> > > the PMD region will collapse :)
> >
> > Let me be more specific:
> >
> > Assume we have a PMD region (512 pages):
> > - Pages 0-499: hot pages (frequently accessed, NOT lazyfree)
> > - Pages 500-511: lazyfree pages (MADV_FREE'd and clean)
> >
> > This patch skips the entire region when it hits page 500. So pages
> > 0-499 can't be collapsed, even though they are hot.
> >
> > I'm NOT saying lazyfree pages themselves become hot ;)
> >
> > As I mentioned earlier, even if we skip these pages now, after they
> > are reclaimed they become pte_none. Then khugepaged will try to
> > collapse them anyway (based on khugepaged_max_ptes_none). So
> > skipping them just delays things, it does not really change the
> > final result ...
>
> I got it. Thank you for explain.
> I refine the code, it can resolve this issue, as follows:
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 30786c706c4a..afea2e12394e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -45,6 +45,7 @@ enum scan_result {
>         SCAN_PAGE_LRU,
>         SCAN_PAGE_LOCK,
>         SCAN_PAGE_ANON,
> +       SCAN_PAGE_LAZYFREE,
>         SCAN_PAGE_COMPOUND,
>         SCAN_ANY_PROCESS,
>         SCAN_VMA_NULL,
> @@ -1256,6 +1257,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct=
 *mm,
>         pte_t *pte, *_pte;
>         int result =3D SCAN_FAIL, referenced =3D 0;
>         int none_or_zero =3D 0, shared =3D 0;
> +       int lazyfree =3D 0;
>         struct page *page =3D NULL;
>         struct folio *folio =3D NULL;
>         unsigned long addr;
> @@ -1337,6 +1339,21 @@ static int hpage_collapse_scan_pmd(struct mm_struc=
t *mm,
>                 }
>                 folio =3D page_folio(page);
>
> +               if (cc->is_khugepaged && !pte_dirty(pteval) &&
> +                   folio_is_lazyfree(folio)) {
> +                       ++lazyfree;
> +
> +                       /*
> +                        * Due to the lazyfree-folios is reclaimed become
> +                        * pte_none, make sure it doesn't continue to be
> +                        * collapsed when skip ahead.
> +                        */
> +                       if ((lazyfree + none_or_zero) > khugepaged_max_pt=
es_none) {
> +                               result =3D SCAN_PAGE_LAZYFREE;
> +                               goto out_unmap;
> +                       }
> +               }
> +

I am still not fully convinced that this is the correct approach. You may
want to look at jemalloc or scudo to see how userspace heaps use
MADV_FREE for small size classes. In practice, it can be quite
difficult to form a large range of PTEs that are all marked lazyfree.
From my perspective, it would make more sense not to collapse the
entire range if only part of it is lazyfree.
I mean:
for ptes as below,
    lazyfree, lazyfree, non-lazyfree, non-lazyfree

Collapsing the range is unnecessary, as the first two entries are likely
to be freed soon.

>                 if (!folio_test_anon(folio)) {
>                         result =3D SCAN_PAGE_ANON;
>                         goto out_unmap;
>
>
> If it has anything bug or better idea, please let me know, thanks!
> If no, I will send it in the next version.
>
> --
> Thanks,
> Vernon

