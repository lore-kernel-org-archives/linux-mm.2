Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 252CDEF48CC
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 05:01:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FAA76B0005; Fri, 13 Feb 2026 00:01:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A81F6B0089; Fri, 13 Feb 2026 00:01:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 280106B008A; Fri, 13 Feb 2026 00:01:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 16FE56B0005
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:01:30 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE5435895A
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:01:28 +0000 (UTC)
X-FDA: 84438235056.29.6333291
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id CD541180009
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 05:01:26 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l6cUV4xO;
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770958887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+gdGRO5WQmxL11L59saL1WXLHxYBJRsrTDD771Wy4o=;
	b=0q0xb/7C6FCw2kHk8QMLab4GwUNDFFj5jo3C+XKxXSogyH8B+OBJUr0DlE7qDhf1g1aqNc
	3+rQw0r/rRCqK2ybL21HH6Lq7i/oz22Wk72PcCjncP4FcGlv7CwHjUxYfpjCaA3ap7e7kt
	OfCMh6Vh5MLRtXVh7sqRsbLt06WqLSM=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=l6cUV4xO;
	spf=pass (imf16.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.51 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1770958887; a=rsa-sha256;
	cv=pass;
	b=m5poxOaKf+NdiBkSqzlDiF1wrpRQKjpf3rGwwRTwGG6WHfKS6IAqMp+QW8GTKCdr0oDjo/
	AieC2k/+c5Q6iPOjoESSPyZWtER4VCz7RGfNojJWaVydTsP1rTuHuIX+52+e/GQr9170Tg
	CscEWjhHFqfL10cZCxwYJWYZEJgOXw8=
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-48318d08ec2so25445e9.1
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 21:01:26 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770958885; cv=none;
        d=google.com; s=arc-20240605;
        b=NKxx9jnKjOIIuSi7G/t3IeMyzF4D/xrLLuxKO2xZBTtPcB7qrt6WW/cfG61YUrTplx
         VvTiMkrIdRt3RkI6+7DOZv8wIarqdnbpjJ0U2qw5D2lL+RDny6M58odtrzRUbmHLr6sx
         ElSVaVa5KA1fXGJy79j9Q3fFCYL1hKoVU9pOwV6BpRvUM/A/VZCFj93t1tiUXZctQ//W
         qG/ht5uf33q2grRSmRVLFh2Q1rldCKN9kjhpLRrCGU7hhYt45ND1YmKGs7cRyz6RcV8h
         HHZ+SPdNxgrgj01oykYMpYhEYiUgQS6bttTkQBbEB1CuBn2cTloL8f6v15CEXJPhETna
         p4lg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=F+gdGRO5WQmxL11L59saL1WXLHxYBJRsrTDD771Wy4o=;
        fh=kWs0+ZRXLloVeDku5oEortdwPx3SXwidVYTEJ193ZJ8=;
        b=dq3b4tl/n9Hgns+1I9S/ko0W5wkgQTRPKsko35nb9xO6k7+tEiQj20/i8Dovls0dPv
         sdgLNKFJJU7oWXK/AhaY3kUFnstocqfVrSDK/PNkJ9WRnMt3QnO0exvnF7CKoSq8ww5m
         XguzUTMdV1JggIIQNy87JZiUvGG9k2vxURbOOwptAMb+cQaL59xOEH7+6XnKcwJhd4H1
         m0vzr262amGqqQlA323OgfBq4vTAe4jFVdbkMWKK4yAwcLxCeX3pQdyF57ZjfxQDhB3B
         XiiwG+UZ2h+UI+1jgOUbiZLwb/9VBYxTymNS0GzFYhp4g1UZrCQ632fMITjZg6ZUF3cB
         R4JA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770958885; x=1771563685; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F+gdGRO5WQmxL11L59saL1WXLHxYBJRsrTDD771Wy4o=;
        b=l6cUV4xOr1NcwQum/W9wYDJR5iDclEbhZ9yy9lWVYYCOwbeJhWzdRkvhNe9p3gUt8h
         rZf8bpJizuQUM3hDlCPCL1rMmdPGDv9y+SY1T7YaovNMdYrb4Q7v4GLWil9+A/YqVeBC
         WCV95crI8qWbwopZF2rKhqhnGYLkGDmbdHCbg2aLLG/tbtnqncbRX/VnHFljSPJ6XnKS
         uUP/MpAywNAQzcrWljYscpoCm6fQvHS7ttZIDF1kjNxlJJFsRzW0AOXXfRm778krkcU/
         bO2/ArZe/KBdGVvJZQ0CDhLvTCfUqX5bz1wk+10grwzap1vUjq08vSD4s9Noc69jsvj4
         DCjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770958885; x=1771563685;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=F+gdGRO5WQmxL11L59saL1WXLHxYBJRsrTDD771Wy4o=;
        b=XAVaIdwhzHFGNClvoxNNFN1W4fv8lkU7gGiiFO/IPq1OX/I0GPVN5B/TGNwtq8VNj/
         O4vflE/hKYxa77FuZCORqu0nbjSqqxdQYDLmNvorgwN5gmUxVA5xAr8mqit2XJMklZJU
         O8IwHiPsjXkIncmQT2qyynG/47GOGjf1lwrmjEvk9nwP0XwSA7+fTim24UbisZLqYOpR
         DVXFvrzfuCFazJMAC5F5ByO3XKcINO/YStbSFlLSsvSHUfFOhjUP7YBy4RdDwubAmhq8
         O+igKml8y0dGfUxhw6YCC3i0VM+QX0XeJOYcH0MDQ7TQZVFELhvleK94zU/W4qzyIQDN
         x7dw==
X-Forwarded-Encrypted: i=1; AJvYcCVeIxwfYAdQAQU2W94gWFCM3Iyzfd+q5WArBraE5R6WEM9emdrW8zybMbhgtxqO+ZuS/1LtvzULDw==@kvack.org
X-Gm-Message-State: AOJu0Yz7RVLDoaQhLsP7DDI6QP9hDSC46l4w2iAPcm6fDzTalLDx+SgI
	lTMSVB2+RoXsAM3ZCR2+7cGD+L6fAgaWNOx8Z+JtQ4Osd+i4VfSttHVP0dlUtE1iszQWvkfKA3v
	PQvpeCYuTHnlzMX8bIYqQQLIZsuNfxug+CP/rZ7Bz
X-Gm-Gg: AZuq6aKfz5C3G9APRpAVghmsutYjmsBrtSVCW4c26s0mfUq0y2XrvoW1sxJnqhQ5yKr
	xbPvIh2fyHRFNcvlOsXBzchZX3xvnKgOq+bokXBo5xv3gCzES1i/lCcYid7gCvQ/ZkAVJf+3qi+
	ZYlTolKqnK3DEbgxPuD9hDbQH4aCaZ/oYwNhQlMBHYS5Xyy38BI9LPvOvwblpfJG7HGIMBlMUgw
	QjOsu5RnSETRq6oWmGrHZjbDstRcuiBAVKtIozpGqosHVchbqrmKJtRNmPiaRzCDXQDfHhGOdB/
	YwalkP1j+BYjAQl85gWZsfied+LrW4YMvuyGCTmA
X-Received: by 2002:a7b:c5ca:0:b0:477:95a8:3805 with SMTP id
 5b1f17b1804b1-48372ef5367mr158855e9.15.1770958884545; Thu, 12 Feb 2026
 21:01:24 -0800 (PST)
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <20260203192352.2674184-2-jiaqiyan@google.com>
 <7ad34b69-2fb4-770b-14e5-bea13cf63d2f@huawei.com> <CACw3F50PwJ+sSOX0wySQgBzrEW2XOctxuX5jM37OG0HS_kHdbQ@mail.gmail.com>
 <31cc7bed-c30f-489c-3ac3-4842aa00b869@huawei.com>
In-Reply-To: <31cc7bed-c30f-489c-3ac3-4842aa00b869@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Thu, 12 Feb 2026 21:01:12 -0800
X-Gm-Features: AZwV_QhlllUi0eHTdCejlItd_Ytr-GAEoFEDHxBi4v3ZMGnCptGiz5Tmjy4xcP0
Message-ID: <CACw3F50BwnLJW75EXgz0t5g+eUhr+wKgJ3YfRFq5208N5KfaiA@mail.gmail.com>
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
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CD541180009
X-Stat-Signature: jijw1rz85bsuocwmqwgtsp718hwq9yx7
X-Rspam-User: 
X-HE-Tag: 1770958886-364421
X-HE-Meta: U2FsdGVkX18IPdBvkJllTR2iWsaUEikkUz5iBgYRrLpsOB0pxX3xNd5TxPtETxYsmZAEz2KT5ekT3V4XynbG4A9J24EW81QlA19smPzXz9zfUtcjBpRwUht2uuIYh0r+jUK+WNOHu5dp6Rvo93TUWWE5BBji+C9NpZ7wl2LYR8ck1OxM3qWOu3BrRYQeOwDAlTAFloG2mdwq5N2Sd3rMx6/4JEfKO1HJjiV6xqc5940iaf0NrU62CpFDt6NsXxaEwaHu0uohHuRHhZ4nfTnemf2gIjO/QmLh8QC7NoptUnkT2xwfkiNME7ooGZ3TXzblGCtdVXlhK+6kI7ZYb6ZtAwAQTgygk48UaerbBDZkefFithann55yv+LMTZzozUWPF4g3rkpzwaUQFA9G8IE5C6864JGoNthX5yhOlP1Vdtn+SA+8e6TpuTi8nbDvP9cNkx2hDf3k08wgswVZtb/s94fct7QCtHkcuZki9Hhcrpw4PUpHC0vqSVPUK8FmczeacWGil4jC9QYW+wSET/V0YQt8G1NfpIjc8vJOJEiYpRCaJhdwnrfkTgfo/yjd9pPNktNxdd4WR0qkEIZQduZPmP5sY3/XyCe68QOy/S5+H8ayVUNCvi4LgUnsS6HFtBIgzT4AHE5TFFFlWDRgpc9XUllkycI4e0qzyB7jp27alCd3SxNkQjmXoifTDBPUgQBZSQbPDbHMibED4B6GRJdNkVu9WSd/3F/gsgOlmo28BGYMvX/NnQLKmI2ebAVWFB3AxGRbIiW+sJVBrNTnTIv51Xmj8rhJPaoxE9C9mBlvbqsRYH3gLmqC+enyh1R+VMwOaEkQSOHaECbl2D7q2tcAWELZZBIVwwqVLRdbFpTn8HrCPhiNJDpmtbqtEdo0VaEJG3Zq8e//V7wG15fhpH/Ogu0hMtf5rMppbteYGZFl8xrSSa3bojqlVk5UZsJcNvcPodAzIJ4KeoBKStWOP9P
 XzIRsRne
 buxAlNbCYPODUr6Tmz7BrDp4Li0cs/Vr+yzS44TvLQ2GCMQmHs4IJPfKM/xQQMS9gbbnDCIAh4KapaM0e6SUEJ5dDEnU4UV1oeqS+Xdlm3YvDINvJIU2TWVjxkurA/bUyp0MzftRo50FtE6V2lnOBOhagpd7owWWmCWqBTFS+4ASrKhdHgRJESMtFnRFlCl0XHkCiIfEkbF7PXS1RgOqJ9mndivAgjUHWxHFxpMhizSE2YU1QPkGhEH32T05ZJZcmKsh1MkeXMVMW0QtcBGDuuTlWw3VYTZyQjPQ8fz4PKfq7ZaQIdDBZw8ZWtpuEkWxYa1k69z2/Pp0BbNo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 9, 2026 at 11:31=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.com> w=
rote:
>
> On 2026/2/10 12:47, Jiaqi Yan wrote:
> > On Mon, Feb 9, 2026 at 3:54=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com=
> wrote:
> >>
> >> On 2026/2/4 3:23, Jiaqi Yan wrote:
> >>> Sometimes immediately hard offlining a large chunk of contigous memor=
y
> >>> having uncorrected memory errors (UE) may not be the best option.
> >>> Cloud providers usually serve capacity- and performance-critical gues=
t
> >>> memory with 1G HugeTLB hugepages, as this significantly reduces the
> >>> overhead associated with managing page tables and TLB misses. However=
,
> >>> for today's HugeTLB system, once a byte of memory in a hugepage is
> >>> hardware corrupted, the kernel discards the whole hugepage, including
> >>> the healthy portion. Customer workload running in the VM can hardly
> >>> recover from such a great loss of memory.
> >>
> >> Thanks for your patch. Some questions below.
> >>
> >>>
> >>> Therefore keeping or discarding a large chunk of contiguous memory
> >>> owned by userspace (particularly to serve guest memory) due to
> >>> recoverable UE may better be controlled by userspace process
> >>> that owns the memory, e.g. VMM in the Cloud environment.
> >>>
> >>> Introduce a memfd-based userspace memory failure (MFR) policy,
> >>> MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
> >>> but the current implementation only covers HugeTLB.
> >>>
> >>> For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memfd,
> >>> whenever it runs into a new UE,
> >>>
> >>> * MFR defers hard offline operations, i.e., unmapping and
> >>
> >> So the folio can't be unpoisoned until hugetlb folio becomes free?
> >
> > Are you asking from testing perspective, are we still able to clean up
> > injected test errors via unpoison_memory() with MFD_MF_KEEP_UE_MAPPED?
> >
> > If so, unpoison_memory() can't turn the HWPoison hugetlb page to
> > normal hugetlb page as MFD_MF_KEEP_UE_MAPPED automatically dissolves
>
> We might loss some testability but that should be an acceptable compromis=
e.

To clarify, looking at unpoison_memory(), it seems unpoison should
still work if called before truncated or memfd closed.

What I wanted to say is, for my test hugetlb-mfr.c, since I really
want to test the cleanup code (dissolving free hugepage having
multiple errors) after truncation or memfd closed, so we can only
unpoison the raw pages rejected by buddy allocator.

>
> > it. unpoison_memory(pfn) can probably still turn the HWPoison raw page
> > back to a normal one, but you already lost the hugetlb page.
> >
> >>
> >>>   dissolving. MFR still sets HWPoison flag, holds a refcount
> >>>   for every raw HWPoison page, record them in a list, sends SIGBUS
> >>>   to the consuming thread, but si_addr_lsb is reduced to PAGE_SHIFT.
> >>>   If userspace is able to handle the SIGBUS, the HWPoison hugepage
> >>>   remains accessible via the mapping created with that memfd.
> >>>
> >>> * If the memory was not faulted in yet, the fault handler also
> >>>   allows fault in the HWPoison folio.
> >>>
> >>> For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
> >>> when userspace process truncates its hugepages:
> >>>
> >>> * When the HugeTLB in-memory file system removes the filemap's
> >>>   folios one by one, it asks MFR to deal with HWPoison folios
> >>>   on the fly, implemented by filemap_offline_hwpoison_folio().
> >>>
> >>> * MFR drops the refcounts being held for the raw HWPoison
> >>>   pages within the folio. Now that the HWPoison folio becomes
> >>>   free, MFR dissolves it into a set of raw pages. The healthy pages
> >>>   are recycled into buddy allocator, while the HWPoison ones are
> >>>   prevented from re-allocation.
> >>>
> >> ...
> >>
> >>>
> >>> +static void filemap_offline_hwpoison_folio_hugetlb(struct folio *fol=
io)
> >>> +{
> >>> +     int ret;
> >>> +     struct llist_node *head;
> >>> +     struct raw_hwp_page *curr, *next;
> >>> +
> >>> +     /*
> >>> +      * Since folio is still in the folio_batch, drop the refcount
> >>> +      * elevated by filemap_get_folios.
> >>> +      */
> >>> +     folio_put_refs(folio, 1);
> >>> +     head =3D llist_del_all(raw_hwp_list_head(folio));
> >>
> >> We might race with get_huge_page_for_hwpoison()? llist_add() might be =
called
> >> by folio_set_hugetlb_hwpoison() just after llist_del_all()?
> >
> > Oh, when there is a new UE while we releasing the folio here, right?
>
> Right.
>
> > In that case, would mutex_lock(&mf_mutex) eliminate potential race?
>
> IMO spin_lock_irq(&hugetlb_lock) might be better.

Looks like I don't need any lock given the correction below.

>
> >
> >>
> >>> +
> >>> +     /*
> >>> +      * Release refcounts held by try_memory_failure_hugetlb, one pe=
r
> >>> +      * HWPoison-ed page in the raw hwp list.
> >>> +      *
> >>> +      * Set HWPoison flag on each page so that free_has_hwpoisoned()
> >>> +      * can exclude them during dissolve_free_hugetlb_folio().
> >>> +      */
> >>> +     llist_for_each_entry_safe(curr, next, head, node) {
> >>> +             folio_put(folio);
> >>
> >> The hugetlb folio refcnt will only be increased once even if it contai=
ns multiple UE sub-pages.
> >> See __get_huge_page_for_hwpoison() for details. So folio_put() might b=
e called more times than
> >> folio_try_get() in __get_huge_page_for_hwpoison().
> >
> > The changes in folio_set_hugetlb_hwpoison() should make
> > __get_huge_page_for_hwpoison() not to take the "out" path which
> > decrease the increased refcount for folio. IOW, every time a new UE
> > happens, we handle the hugetlb page as if it is an in-use hugetlb
> > page.
>
> See below code snippet (comment [1] and [2]):
>
> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>                                  bool *migratable_cleared)
> {
>         struct page *page =3D pfn_to_page(pfn);
>         struct folio *folio =3D page_folio(page);
>         int ret =3D 2;    /* fallback to normal page handling */
>         bool count_increased =3D false;
>
>         if (!folio_test_hugetlb(folio))
>                 goto out;
>
>         if (flags & MF_COUNT_INCREASED) {
>                 ret =3D 1;
>                 count_increased =3D true;
>         } else if (folio_test_hugetlb_freed(folio)) {
>                 ret =3D 0;
>         } else if (folio_test_hugetlb_migratable(folio)) {
>
>                    ^^^^*hugetlb_migratable is checked before trying to ge=
t folio refcnt* [1]
>
>                 ret =3D folio_try_get(folio);
>                 if (ret)
>                         count_increased =3D true;
>         } else {
>                 ret =3D -EBUSY;
>                 if (!(flags & MF_NO_RETRY))
>                         goto out;
>         }
>
>         if (folio_set_hugetlb_hwpoison(folio, page)) {
>                 ret =3D -EHWPOISON;
>                 goto out;
>         }
>
>         /*
>          * Clearing hugetlb_migratable for hwpoisoned hugepages to preven=
t them
>          * from being migrated by memory hotremove.
>          */
>         if (count_increased && folio_test_hugetlb_migratable(folio)) {
>                 folio_clear_hugetlb_migratable(folio);
>
>                 ^^^^^*hugetlb_migratable is cleared when first time seein=
g folio* [2]
>
>                 *migratable_cleared =3D true;
>         }
>
> Or am I miss something?

Thanks for your explaination! You are absolutely right. It turns out
the extra refcount I saw (during running hugetlb-mfr.c) on the folio
at the moment of filemap_offline_hwpoison_folio_hugetlb() is actually
because of the MF_COUNT_INCREASED during MADV_HWPOISON. In the past I
used to think that is the effect of folio_try_get() in
__get_huge_page_for_hwpoison(), and it is wrong. Now I see two cases:
- MADV_HWPOISON: instead of __get_huge_page_for_hwpoison(),
madvise_inject_error() is the one that increments hugepage refcount
for every error injected. Different from other cases,
MFD_MF_KEEP_UE_MAPPED makes the hugepage still a in-use page after
memory_failure(MF_COUNT_INCREASED), so I think madvise_inject_error()
should decrement in MFD_MF_KEEP_UE_MAPPED case.
- In the real world: as you pointed out, MF always just increments
hugepage refcount once in __get_huge_page_for_hwpoison(), even if it
runs into multiple errors. When
filemap_offline_hwpoison_folio_hugetlb() drops the refcount elevated
by filemap_get_folios(), it only needs to decrement again if
folio_ref_dec_and_test() returns false. I tested something like below:

    /* drop the refcount elevated by filemap_get_folios. */
    folio_put(folio);
    if (folio_ref_count(folio))
        folio_put(folio);
    /* now refcount should be zero. */
    ret =3D dissolve_free_hugetlb_folio(folio);

Besides, the good news is that
filemap_offline_hwpoison_folio_hugetlb() no longer needs to touch
raw_hwp_list.

>
> >
> >>
> >>> +             SetPageHWPoison(curr->page);
> >>
> >> If hugetlb folio vmemmap is optimized, I think SetPageHWPoison might t=
rigger BUG.
> >
> > Ah, I see, vmemmap optimization doesn't allow us to move flags from
> > raw_hwp_list to tail pages. I guess the best I can do is to bail out
> > if vmemmap is enabled like folio_clear_hugetlb_hwpoison().
>
> I think you can do this after hugetlb_vmemmap_restore_folio() is called.

Since I can get rid of the wrong folio_put() per raw HWPoison page, I
can just rely on dissolve_free_hugetlb_folio() to do the
hugetlb_vmemmap_restore_folio() and reuse the
folio_clear_hugetlb_hwpoison() code to move HWPoison flags to raw
pages.

I will do some more testing while preparing v4. Will also try if I can
avoid adding a speical cased folio_put() in madvise_inject_error().

>
> Thanks.
> .

