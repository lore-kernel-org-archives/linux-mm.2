Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D73AEA8554
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 04:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB0D6B0088; Mon,  9 Mar 2026 00:53:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 469C76B0089; Mon,  9 Mar 2026 00:53:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313C46B008A; Mon,  9 Mar 2026 00:53:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A2A16B0088
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 00:53:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id AFA5BBAA39
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:53:41 +0000 (UTC)
X-FDA: 84525306642.27.BBF1199
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf28.hostedemail.com (Postfix) with ESMTP id 90199C0002
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:53:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zkl49zXa;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773032019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YKTCl3ZZHhLgk1TZ61Z+cLelMYdC4TOsqAIQ4YfDLnE=;
	b=wdazwmzYTYUe3My7WFbrB7kJU6TOSRaIlB6BzozLYQ17nRFGRX+mtA8So6rRGwwhfhv4mv
	UXYXpSp09vkPAtV68AO1IezAHL5WXB6QF8CT3vzggAbIkFF+9i4z9v2aNfjfjicVzLadK9
	h9ngy7ZWns9b2tp79QOA7zmsE2gyqBI=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Zkl49zXa;
	spf=pass (imf28.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773032019; a=rsa-sha256;
	cv=pass;
	b=vgU2ZR8L+HOGXKPmA0FiUAHVRlVaG/u3C8gP5NcC4wnGWI4qXJlCKh/BwnpNCGu3nzKPyX
	agxjIXcWXrc2lKb6EHG6DC3cjCXen7ewWg48A3hoyiVM3McKt4s+t5mziiQWzbbqCC2s3U
	DkDJnG+vQKcD8ALpBlHXxKE4bl/GT/U=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4852af55981so88685e9.0
        for <linux-mm@kvack.org>; Sun, 08 Mar 2026 21:53:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773032018; cv=none;
        d=google.com; s=arc-20240605;
        b=amIUnoaqFKt5c8DlU+N1WtrGuartvY2IxE8oEwea07oW5lTC1nButjdGEW7Hp2dhzy
         +Ju7tRca+lwmBgTurTOM9JkhQ7IFjsg2uYAifHvsfdN7Z3tNlFGkTWmjEuhowiMfHTpe
         mvSLp/Yg+im35H2a4XreN2mqiKtYvT+kJ247wIn+7uMWnYguc750TiQCFwmjl/3JlKPl
         QTFOYbKMCKB1rwiEzzf7OUDxA9ZVPhjHj1QEZK4dlEGFYwmE/bXIwXe+XovOvQTrNpwm
         MT4Vc7WxN5UWre6kfa3DvcODkspOkfwS5Ygz9J7DroPqtl5891x3hDiUIK38GLInlkFo
         LKfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YKTCl3ZZHhLgk1TZ61Z+cLelMYdC4TOsqAIQ4YfDLnE=;
        fh=QDY98UspIu+v4Bko2kB9QR1vHQkoZrZGmAHRyd9OdfE=;
        b=MWrfUtovsrI0V4jzEybibCoXFjw2PUT7LtxkOTJm81E3aKQ/I9AzhgAnJ3hl6ABq9/
         /9iOqVAptHHtdIOp5mThqMAGOS/WQP20HI31mHtVDH7EjukAKhlvJkjFobYUfnNNKPCj
         o2Y2U3EEYjIhzVVISoPe5fF+4mhHptF4HJTuZBdVocgw8V22KE+DK8OryQ3etxob4U7C
         bAPQz+i/WZRUxB2DbffWyYY82AMmddaq3L0/FnsOPI/v7kNVWXhcjrdHVlOYkMcZXDf0
         xpitmwVzGGYqvx9QvTp9PSdP2xcj7chFC4UxPmnio05fyrG8sq0tVAhw+nb73XZt7hjN
         JF/w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773032018; x=1773636818; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKTCl3ZZHhLgk1TZ61Z+cLelMYdC4TOsqAIQ4YfDLnE=;
        b=Zkl49zXaVfgONAtTOV3FhfJizhNA01XDtZKan5vmVwf18epXKcGW+vFOymsw342w9m
         T8LAKcTgi0hp1EqMWIw+sp7KTiGqPUFQvTldGU0DWBFn6sfTysi59TqVl6bubldiNvx/
         g1joSZCWy6ihFdVTWN0pt6X4uWyG9jS/AkUyuTas5UahJ7ZbZyejtWfkTQfCcWu2MoaG
         YL87PzmmVcvGLFilLfz8lOjj5XuDUWignB3tdI/ZKhHJiCHFeng2VFASobsIjpf8dPZy
         IPKPZamJy7Mlpww2hhZWUp9lL3GigfPm/YNa1lyNGPAei/2ZvIa+0GIooF1Mu++YUZfL
         Azqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773032018; x=1773636818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YKTCl3ZZHhLgk1TZ61Z+cLelMYdC4TOsqAIQ4YfDLnE=;
        b=pYK7aglqZhkvfNnMN5oqthYvFB5PCx8Un1yDfQE93L5T0xk3KWq0tFquKPN0a7KyIx
         XzKSaBBKfbzxKv34H5fy9HW09fTsx8bxjJq0VVhJL86bSegAsAWEBA3IMSe10EeBDXzP
         axSCj/mOTrd8t38yG+oWrecRIryUKOCumFP38mnXrs9LifaGbIKeOQt6Me0IP465Nrf+
         IBdrMDlTdQNx5wwXG87aqbkyVzxZjFVu2z8pExxh4ep6lFs8wiznuge92t4882LEIuVf
         XsliOCOWm/byxzYJqV0B/hkQT2KWhs3hoKaFBFjzkdCx0EZPjnxLvpMbRO5KoWo4ii4e
         Betg==
X-Forwarded-Encrypted: i=1; AJvYcCW7Qsii2D9tbzB38XIhhByfKNTzcBl+4c4X/SWJvI1DG8kaSCZwwVZO2KRjo6p4qTsBANbeu/TlKw==@kvack.org
X-Gm-Message-State: AOJu0YypXAZ+q6sj8bDaJmkPHu5vjLpSyrIAT6QUokJje6dKqtTB+xRj
	j0zUWCRbjY0besx4R13HslvnvYM+9SuA7pyqO9QVgQNjRyeClyMgac48lPu/e/2koyzopqR5Zd/
	XNsRksA9ooIsurSM5g/gdhfIpySW6dpmBy3EbiLyJ
X-Gm-Gg: ATEYQzw8IcnKihFQeSr/yomcKT8xCOZrgBlHcQs80knJrR28SHulfSW9czjtP/lu6tI
	ev01CxW0hKorWKVpO2xSr7TiF4BNWk4g4JTKeNOt978u+KqJATjk+BIi5Gtf/7GKhoKKSdCRLvl
	QR5vSnJq7t0KzpbW40fEEJqMN6W/Yh1kOcO76Rnj4VnDsx1ZjmWeDxwx5WYr1G799TVI3YVYIhX
	r9HbTMC8zm+mKG9oOi36UNazWJXWCp4T3cfY8Snd3c7EQDQveWm9hln7Qh+2/GmrrMlINOlpRTT
	EkA+q14JBuouPLpTi0jELr+nEZjeOXfvv4b0O8Y=
X-Received: by 2002:a05:600c:3b86:b0:483:6f85:b16e with SMTP id
 5b1f17b1804b1-4852e45a28dmr1925675e9.3.1773032017478; Sun, 08 Mar 2026
 21:53:37 -0700 (PDT)
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <20260203192352.2674184-2-jiaqiyan@google.com>
 <7ad34b69-2fb4-770b-14e5-bea13cf63d2f@huawei.com> <CACw3F50PwJ+sSOX0wySQgBzrEW2XOctxuX5jM37OG0HS_kHdbQ@mail.gmail.com>
 <31cc7bed-c30f-489c-3ac3-4842aa00b869@huawei.com> <CACw3F50BwnLJW75EXgz0t5g+eUhr+wKgJ3YfRFq5208N5KfaiA@mail.gmail.com>
 <a0d25caf-a18b-e3d8-e74f-fc18fa85252e@huawei.com>
In-Reply-To: <a0d25caf-a18b-e3d8-e74f-fc18fa85252e@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Sun, 8 Mar 2026 21:53:25 -0700
X-Gm-Features: AaiRm52OugVEfS8g75Px5seZ5I3SYFZ1Jdyd2NzqUgRjpWBwmGWtg6DYu0FRfQg
Message-ID: <CACw3F51+bAm03nvucV54bkThnYc-4ewgqGzq_c5i6oMmnGdEtw@mail.gmail.com>
Subject: Re: [PATCH v3 1/3] mm: memfd/hugetlb: introduce memfd-based userspace
 MFR policy
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: nao.horiguchi@gmail.com, tony.luck@intel.com, wangkefeng.wang@huawei.com, 
	willy@infradead.org, akpm@linux-foundation.org, osalvador@suse.de, 
	rientjes@google.com, duenwen@google.com, jthoughton@google.com, 
	jgg@nvidia.com, ankita@nvidia.com, peterx@redhat.com, 
	sidhartha.kumar@oracle.com, ziy@nvidia.com, david@redhat.com, 
	dave.hansen@linux.intel.com, muchun.song@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	william.roche@oracle.com, harry.yoo@oracle.com, jane.chu@oracle.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 90199C0002
X-Rspamd-Server: rspam07
X-Stat-Signature: 3db4wfhj5q9m6b1stg8qh97s66pqtt89
X-Rspam-User: 
X-HE-Tag: 1773032019-982908
X-HE-Meta: U2FsdGVkX1/M784aT31gYUnLoj1ez6RMGd0NwKxfg8q/8RU/F3dgUCU4W14pcsSo/ii8WxKgEDZwDZ1TJDb714c9arEnfyZQqqWKorT3oUd9v55nEK0oGTF0RSdSgpB+C7kykjasBfWiKlcPdGQyXSqyWv0iOl6MefU09jJbaWkCrBKCqX13tYIXggPEI1sVWdzoLsG8Lheu3XmBTvw+cL3h+xLf2FTCjaIO8HVlF6Z8UDvZO+oECHKniMK4IU0CLGOJvSzu4gr9rKmtblEUejYQeQmw8qeprqxjZwuLLBiwyWiB9tPviQRnuCvnR5pJcgcf6h/6awoT+TLPmP/txQjiEozQmc+zTlOB2FkEPprueOtSb6lha30HfpCQZM/jeqangILdzYL/9uryedKto44smSpPcA5skZaEiHDV2yIjXdxGexmWu4hl9JK4i+KEWT2Q6A9JXQX73yZ7mxGc4EjKTKZCsKMuigdXyRXfxpai9eMDJg1ZWW6R0/ubGrlPnU+xtvlWqjFVxVKvbX6AZWzwz+zqnHCqvi+QxkkNrZ6GW/BIuYNZUusrTZgj4qQ5cwQk+P8p2qrdek0GcnmjGuFo3ft3wOeYdcjIjvo0FGtFYVegzSySS2RLXQjmSi8mqB0vY2V5OGQLgr0Z1u8BE+F++ciOqw1Q+ilIOx+90pexwvtRaXB7qq3vZUu0iFnhDdF9LEgs4hODcWziVvRGe4H0Aof78X9iCM/HWgPE6URa4HhBHg24I0mLWVKEnKy7FOejJIjUSN+IMCVd+3QTKD0WSPbgErgwsxRIlGUR1egM4r4jXEOmLXf74hMLb4fLt7FbZNokXKbcbrYc3ESxQ0fVKqG4IHOkrJHvIIjSXOwg7o5fwQRt1zY4L9CPCf8CGOT05iIogCbrO24K4Bk4zaM2exSE1A11MdK6qU6f5ggH+gu+U1Y6whsg71ncEs84GyM9xDPrZVoN4pvgcwT
 YvZuI8gz
 2Ud19RIG0/71o0Cpyv21rV7BN7NCcg3T5JhknTTnlNdevAddg+caXddp1F0A6a+OmChW87YnuP9hlxVI69lUQBzPkpyKSpqMXn3C2wWwcqm2l8+KqohEA2RxXiYroU5Zmlfvtbck72I1pHPf25uRXPcW7S/HlENRAcSfq34EAsQUffcbyGB5wbY6Ol9k9vKTDCuLf/3lAOG88hTmVrf2WZPKiZaQrxtgHc/62WecW5tWF+8fBfbd1+03tRyEbvgguTcdlurKzghpwZ4T7L9gew75I34uZae63RBAxc0yBZCxP/J54j+NrUI77MY5+OklwNz0MR1HNjHxNVrU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 11:30=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> =
wrote:
>
> On 2026/2/13 13:01, Jiaqi Yan wrote:
> > On Mon, Feb 9, 2026 at 11:31=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.co=
m> wrote:
> >>
> >> On 2026/2/10 12:47, Jiaqi Yan wrote:
> >>> On Mon, Feb 9, 2026 at 3:54=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.c=
om> wrote:
> >>>>
> >>>> On 2026/2/4 3:23, Jiaqi Yan wrote:
> >>>>> Sometimes immediately hard offlining a large chunk of contigous mem=
ory
> >>>>> having uncorrected memory errors (UE) may not be the best option.
> >>>>> Cloud providers usually serve capacity- and performance-critical gu=
est
> >>>>> memory with 1G HugeTLB hugepages, as this significantly reduces the
> >>>>> overhead associated with managing page tables and TLB misses. Howev=
er,
> >>>>> for today's HugeTLB system, once a byte of memory in a hugepage is
> >>>>> hardware corrupted, the kernel discards the whole hugepage, includi=
ng
> >>>>> the healthy portion. Customer workload running in the VM can hardly
> >>>>> recover from such a great loss of memory.
> >>>>
> >>>> Thanks for your patch. Some questions below.
> >>>>
> >>>>>
> >>>>> Therefore keeping or discarding a large chunk of contiguous memory
> >>>>> owned by userspace (particularly to serve guest memory) due to
> >>>>> recoverable UE may better be controlled by userspace process
> >>>>> that owns the memory, e.g. VMM in the Cloud environment.
> >>>>>
> >>>>> Introduce a memfd-based userspace memory failure (MFR) policy,
> >>>>> MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
> >>>>> but the current implementation only covers HugeTLB.
> >>>>>
> >>>>> For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
> >>>>> whenever it runs into a new UE,
> >>>>>
> >>>>> * MFR defers hard offline operations, i.e., unmapping and
> >>>>
> >>>> So the folio can't be unpoisoned until hugetlb folio becomes free?
> >>>
> >>> Are you asking from testing perspective, are we still able to clean u=
p
> >>> injected test errors via unpoison_memory() with MFD_MF_KEEP_UE_MAPPED=
?
> >>>
> >>> If so, unpoison_memory() can't turn the HWPoison hugetlb page to
> >>> normal hugetlb page as MFD_MF_KEEP_UE_MAPPED automatically dissolves
> >>
> >> We might loss some testability but that should be an acceptable compro=
mise.
> >
> > To clarify, looking at unpoison_memory(), it seems unpoison should
> > still work if called before truncated or memfd closed.
> >
> > What I wanted to say is, for my test hugetlb-mfr.c, since I really
> > want to test the cleanup code (dissolving free hugepage having
> > multiple errors) after truncation or memfd closed, so we can only
> > unpoison the raw pages rejected by buddy allocator.
> >
> >>
> >>> it. unpoison_memory(pfn) can probably still turn the HWPoison raw pag=
e
> >>> back to a normal one, but you already lost the hugetlb page.
> >>>
> >>>>
> >>>>>   dissolving. MFR still sets HWPoison flag, holds a refcount
> >>>>>   for every raw HWPoison page, record them in a list, sends SIGBUS
> >>>>>   to the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT=
.
> >>>>>   If userspace is able to handle the SIGBUS, the HWPoison hugepage
> >>>>>   remains accessible via the mapping created with that memfd.
> >>>>>
> >>>>> * If the memory was not faulted in yet, the fault handler also
> >>>>>   allows fault in the HWPoison folio.
> >>>>>
> >>>>> For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
> >>>>> when userspace process truncates its hugepages:
> >>>>>
> >>>>> * When the HugeTLB in-memory file system removes the filemap's
> >>>>>   folios one by one, it asks MFR to deal with HWPoison folios
> >>>>>   on the fly, implemented by filemap_offline_hwpoison_folio().
> >>>>>
> >>>>> * MFR drops the refcounts being held for the raw HWPoison
> >>>>>   pages within the folio. Now that the HWPoison folio becomes
> >>>>>   free, MFR dissolves it into a set of raw pages. The healthy pages
> >>>>>   are recycled into buddy allocator, while the HWPoison ones are
> >>>>>   prevented from re-allocation.
> >>>>>
> >>>> ...
> >>>>
> >>>>>
> >>>>> +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *f=
olio)
> >>>>> +{
> >>>>> +     int ret;
> >>>>> +     struct llist_node *head;
> >>>>> +     struct raw_hwp_page *curr, *next;
> >>>>> +
> >>>>> +     /*
> >>>>> +      * Since folio is still in the folio_batch, drop the refcount
> >>>>> +      * elevated by filemap_get_folios.
> >>>>> +      */
> >>>>> +     folio_put_refs(folio, 1);
> >>>>> +     head =3D llist_del_all(raw_hwp_list_head(folio));
> >>>>
> >>>> We might race with get_huge_page_for_hwpoison()? llist_add() might b=
e called
> >>>> by folio_set_hugetlb_hwpoison() just after llist_del_all()?
> >>>
> >>> Oh, when there is a new UE while we releasing the folio here, right?
> >>
> >> Right.
> >>
> >>> In that case, would mutex_lock(&mf_mutex) eliminate potential race?
> >>
> >> IMO spin_lock_irq(&hugetlb_lock) might be better.
> >
> > Looks like I don't need any lock given the correction below.
> >
> >>
> >>>
> >>>>
> >>>>> +
> >>>>> +     /*
> >>>>> +      * Release refcounts held by try_memory_failure_hugetlb, one =
per
> >>>>> +      * HWPoison-ed page in the raw hwp list.
> >>>>> +      *
> >>>>> +      * Set HWPoison flag on each page so that free_has_hwpoisoned=
()
> >>>>> +      * can exclude them during dissolve_free_hugetlb_folio().
> >>>>> +      */
> >>>>> +     llist_for_each_entry_safe(curr, next, head, node) {
> >>>>> +             folio_put(folio);
> >>>>
> >>>> The hugetlb folio refcnt will only be increased once even if it cont=
ains multiple UE sub-pages.
> >>>> See __get_huge_page_for_hwpoison() for details. So folio_put() might=
 be called more times than
> >>>> folio_try_get() in __get_huge_page_for_hwpoison().
> >>>
> >>> The changes in folio_set_hugetlb_hwpoison() should make
> >>> __get_huge_page_for_hwpoison() not to take the "out" path which
> >>> decrease the increased refcount for folio. IOW, every time a new UE
> >>> happens, we handle the hugetlb page as if it is an in-use hugetlb
> >>> page.
> >>
> >> See below code snippet (comment [1] and [2]):
> >>
> >> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> >>                                  bool *migratable_cleared)
> >> {
> >>         struct page *page =3D pfn_to_page(pfn);
> >>         struct folio *folio =3D page_folio(page);
> >>         int ret =3D 2;    /* fallback to normal page handling */
> >>         bool count_increased =3D false;
> >>
> >>         if (!folio_test_hugetlb(folio))
> >>                 goto out;
> >>
> >>         if (flags & MF_COUNT_INCREASED) {
> >>                 ret =3D 1;
> >>                 count_increased =3D true;
> >>         } else if (folio_test_hugetlb_freed(folio)) {
> >>                 ret =3D 0;
> >>         } else if (folio_test_hugetlb_migratable(folio)) {
> >>
> >>                    ^^^^*hugetlb_migratable is checked before trying to=
 get folio refcnt* [1]
> >>
> >>                 ret =3D folio_try_get(folio);
> >>                 if (ret)
> >>                         count_increased =3D true;
> >>         } else {
> >>                 ret =3D -EBUSY;
> >>                 if (!(flags & MF_NO_RETRY))
> >>                         goto out;
> >>         }
> >>
> >>         if (folio_set_hugetlb_hwpoison(folio, page)) {
> >>                 ret =3D -EHWPOISON;
> >>                 goto out;
> >>         }
> >>
> >>         /*
> >>          * Clearing hugetlb_migratable for hwpoisoned hugepages to pre=
vent them
> >>          * from being migrated by memory hotremove.
> >>          */
> >>         if (count_increased && folio_test_hugetlb_migratable(folio)) {
> >>                 folio_clear_hugetlb_migratable(folio);
> >>
> >>                 ^^^^^*hugetlb_migratable is cleared when first time se=
eing folio* [2]
> >>
> >>                 *migratable_cleared =3D true;
> >>         }
> >>
> >> Or am I miss something?
> >
> > Thanks for your explaination! You are absolutely right. It turns out
> > the extra refcount I saw (during running hugetlb-mfr.c) on the folio
> > at the moment of filemap_offline_hwpoison_folio_hugetlb() is actually
> > because of the MF_COUNT_INCREASED during MADV_HWPOISON. In the past I
> > used to think that is the effect of folio_try_get() in
> > __get_huge_page_for_hwpoison(), and it is wrong. Now I see two cases:
> > - MADV_HWPOISON: instead of __get_huge_page_for_hwpoison(),
> > madvise_inject_error() is the one that increments hugepage refcount
> > for every error injected. Different from other cases,
> > MFD_MF_KEEP_UE_MAPPED makes the hugepage still a in-use page after
> > memory_failure(MF_COUNT_INCREASED), so I think madvise_inject_error()
> > should decrement in MFD_MF_KEEP_UE_MAPPED case.
> > - In the real world: as you pointed out, MF always just increments
> > hugepage refcount once in __get_huge_page_for_hwpoison(), even if it
> > runs into multiple errors. When
>
> This might not always hold true. When MF occurs while hugetlb folio is un=
der isolation(hugetlb_migratable is
> cleared and extra folio refcnt is held by isolating code in that case), _=
_get_huge_page_for_hwpoison won't get
> extra folio refcnt.
>
> > filemap_offline_hwpoison_folio_hugetlb() drops the refcount elevated
> > by filemap_get_folios(), it only needs to decrement again if
> > folio_ref_dec_and_test() returns false. I tested something like below:
> >
> >     /* drop the refcount elevated by filemap_get_folios. */
> >     folio_put(folio);
> >     if (folio_ref_count(folio))
> >         folio_put(folio);
> >     /* now refcount should be zero. */
> >     ret =3D dissolve_free_hugetlb_folio(folio);
>
> So I think above code might drop the folio refcnt held by isolating code.

Hi Miaohe, thanks for raising the concern. Given two things below
- both folio_isolate_hugetlb() and get_huge_page_for_hwpoison() are
guarded by hugetlb_lock.
- hugetlb_update_hwpoison() only folio_test_set_hwpoison() for
non-isolated folio after folio_try_get() succeeds.

as long as folio_test_set_hwpoison() is true here, this refcount
should never come from folio_isolate_hugetlb(). What do you think?

For folio under isolation, MF ignores it without
folio_test_set_hwpoison(), and
filemap_offline_hwpoison_folio_hugetlb() won't happen at all.
For HWPoison folio, MF has made the folio no longer being able to
isolate/migrate.

>
> Thanks.
> .

