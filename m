Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1D8BF41807
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 15:47:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 307CE6B0089; Mon,  9 Mar 2026 11:47:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0006B008A; Mon,  9 Mar 2026 11:47:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C25B6B008C; Mon,  9 Mar 2026 11:47:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 05C1A6B0089
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 11:47:29 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A26DE57A78
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:47:28 +0000 (UTC)
X-FDA: 84526954176.29.303C383
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf27.hostedemail.com (Postfix) with ESMTP id 8852340015
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 15:47:26 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SUQ6n3+v;
	spf=pass (imf27.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773071246;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lG/w5nH34EyLvyhitTi/enqIK8fRsce1UJOwmSqWnO8=;
	b=Jo6vQHOt3RA6b85PNFz6LanAZpURy8oi2nbC+Xj1j0ksrD6U5Q5DaXGCLmEj+n7UUuag/b
	m5gem/V1CBB6CI/Nh2wVafLWFfzR07VrqI8Dj9a0UqK5ngBSTIsvs7tPuIVpD6w/4KgJv0
	OAfb6CxfHPQRyggeNvEqh8jCDHQ1V3I=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773071246; a=rsa-sha256;
	cv=pass;
	b=kNa/bpKLi9AW0/mJnTlvfoDedDJ/x7/XEEHQAqWLWAandhT3dV+lOyhjxEXIINJXtlld9Y
	qZwjX4eZgNmoEz1Uyc70sUOFA+5gTIWdKokR9Se4NIBPq16p3bVLs6WWXFEBilzSeZqQjM
	R0zPTEPRB93pcfg/f65sx7ZNJt2WvPM=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=SUQ6n3+v;
	spf=pass (imf27.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4852af55981so121965e9.0
        for <linux-mm@kvack.org>; Mon, 09 Mar 2026 08:47:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773071245; cv=none;
        d=google.com; s=arc-20240605;
        b=OaS6MSJ9a9GBRJxnZus0OkDwgha5F05YeJE2jzsLIi+F324t/xO/IQt60ptc4jXXep
         cmeaFDRo/ID+JSzVHYsoxoORdg6rIwWNKbVsXmKO6Ol9kaeQrCLbgHUNLdUi/m32ISCN
         dW2wNTJlVq1hpkqFV84DGRTp/CX6T7HvYzjGZrARxws+I2MI9yMulyoAdK59QhKOUD13
         tvS1B5j5Kgotw9KhCftXtxacnJsa1vlTkt84H/f1K/VyJO1fgH+ti906dlTWRYx0I4Jp
         P5BKxi3MoXKeZ+5i7YAXvw9euHAZ7dtWkBsQXL1Kg4MjDc8Utc3jv5KDs8sODjHP/5ho
         C/QA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lG/w5nH34EyLvyhitTi/enqIK8fRsce1UJOwmSqWnO8=;
        fh=TVfjr4OzncHwDU3M3DBg779Mj0EeJaKcHt58KqJvS2U=;
        b=ZuDHq5epUmSrLNHq8/nHGaiTDSnBTdL4+vp7HRU1vovSmT4uoa4VhDsvXt/fx+lprA
         Owupl0lDd92sQ5mMnaENdt7ty0sR4umQZkMZlOCZ0LRJg2RJzLNz8CZ1TyQbm7h0IDNh
         oCUXHDJ7knWY4B45+xqd1n6MWitVQdgagxfWIG78v9hnmE2z5sjKlf5SU5gnj2GDmEF1
         SqukrIDZkvMbICcQscNc9n76z2tej55eDIyOerKstaf+xpbkCKSO/MDlq1VmB1VcJklJ
         DrPJq9uPmHeb3PDQBQMvAVztUesuMkVGZZaAeSYGEPN2ici/ebcNR5FGUVlaEqW+smRf
         F5aw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773071245; x=1773676045; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lG/w5nH34EyLvyhitTi/enqIK8fRsce1UJOwmSqWnO8=;
        b=SUQ6n3+v23jpQLRblVWgvcvWUJ3Y0TEyr1ao2UJCjWVHel0ghKPcrerpObG836o0VC
         qDWa8XM9Nc1GgV7dIM+Qzyu2t76z2qLIcjvoj7/Xw9138Q0ltqYkNLJxesO6JeJu4YXX
         QVCgC4v5ItMo6Jm1bT7gvcXR32/TelIrHRD/a0N3OWss90mX79gDA7nxOlZnL326yXBb
         WH+QAaBnveqLOcpotYWMbCFVPXSmOMqwKQlApa2Y4ZzANbNA0tYnBOKN8bXiNmsSmEH0
         s7k5V2pXArLeMopHpc7YNWw1IDENy1lMhOOgPbXwhJB+Dy2SYXETssVbr2oKYfNJKNRC
         YjIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773071245; x=1773676045;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=lG/w5nH34EyLvyhitTi/enqIK8fRsce1UJOwmSqWnO8=;
        b=uSw+lTD9W4fusu2cYn9gc5biUxbxa9RuPihA1nOWGgxknpO74d1XAYIoHOsZU6uXd8
         fudF+q8H+ev5QMNif5KaQzNe3lweEYP9OPXVV3xDtc++ye1Jh5LBqitEiLgqxOy+1zJt
         tiEzaXNNOjHCagi9lMQ9b0iQmBB12YGufMBWTipxWe4sTFx1uGt3nNrZGNvbO8MwnmK5
         /sP97WO2G9YHKsVi9YdyC6RL8e9CriQFMOcOfaYmp75VVTPagCl2djT9o/A3eL3ZwUrr
         xSLmEH96LAv7TyKiKb8hN4Qa6cBt6E9sbtoA97h2W3CU0jzDvyUE23vHZZsqcHTo5MFb
         F5FQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTHc62DtbqraQ7gqP5O8eDTMS62lhuNKGeZSJXVVFfDIvFWxcdb84AAcjf+UCgJQANaBh120jwjg==@kvack.org
X-Gm-Message-State: AOJu0YzO999h/ggCJeI9tFJrevXO39r+nSh1xgbv/bMZrE703YM1FW9z
	d2juhmr2BP7DT3vxZD/gD9rtmzMntZAjAZdlbUTGc5EgdCrFly0MCr8ftr8Epek2baWcsdJ92uB
	T/8SKivkMoKjlm0nhlgq+0E5QQBPrfupS3VC9YCBV
X-Gm-Gg: ATEYQzysuBVZ5baw6xmqplqaqA7lDO6lsdp9rxpm9v+isLIab0jX0EPjbZLAaawqUpP
	7Efgd9agBU1WwJoS1ghob+yYD6F3RH3/H5DrfMYPmQPaJIiDENBsXR7FbeNdBH6kpobENXu4074
	gpA6gDGGZpRIa0KF7wBnrSO3EZoBx5JQRUmgbWqn535GPas+1/Vdh13ftnfzvjcI4y+LJ5JWAyW
	xH795aMseOffCBklpK2VoCG+flBqfSz8JOnYS016lyB0aDjHl6ErJHpRCkWL8GJICkV1QpG1WiA
	WmrTTxNXioOAVKnmXQW/GOuj1k01VdiSC+VsWbc=
X-Received: by 2002:a05:600c:c171:b0:485:302f:f27f with SMTP id
 5b1f17b1804b1-485303007b7mr1934615e9.17.1773071244439; Mon, 09 Mar 2026
 08:47:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260203192352.2674184-1-jiaqiyan@google.com> <20260203192352.2674184-2-jiaqiyan@google.com>
 <7ad34b69-2fb4-770b-14e5-bea13cf63d2f@huawei.com> <CACw3F50PwJ+sSOX0wySQgBzrEW2XOctxuX5jM37OG0HS_kHdbQ@mail.gmail.com>
 <31cc7bed-c30f-489c-3ac3-4842aa00b869@huawei.com> <CACw3F50BwnLJW75EXgz0t5g+eUhr+wKgJ3YfRFq5208N5KfaiA@mail.gmail.com>
 <a0d25caf-a18b-e3d8-e74f-fc18fa85252e@huawei.com> <CACw3F51+bAm03nvucV54bkThnYc-4ewgqGzq_c5i6oMmnGdEtw@mail.gmail.com>
 <a3ff8c7b-69c1-fecc-3564-ecaa3e8a7e67@huawei.com>
In-Reply-To: <a3ff8c7b-69c1-fecc-3564-ecaa3e8a7e67@huawei.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 9 Mar 2026 08:47:12 -0700
X-Gm-Features: AaiRm50LMW6sKrWbVlgM7Z4RSdPgjZRf5FHF4xv3HNCCFfBrg3jrKW38LOlQCIY
Message-ID: <CACw3F53qr1Af=r__SNxU1ohr69s8apHqHz9tcEHg1hDSLsk5TQ@mail.gmail.com>
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
X-Stat-Signature: cre16jo6ss7km3a6a6ij54kyndmwiw6h
X-Rspam-User: 
X-Rspamd-Queue-Id: 8852340015
X-Rspamd-Server: rspam12
X-HE-Tag: 1773071246-365536
X-HE-Meta: U2FsdGVkX18J62U2XqUpecY70/P2kph09RVu7E+ifEuY4yX4NxEeYAnYsp/mp9UopvGpSTBgz5iUOAPEuI6bsC/1kWG95evAekEwJKTYo4VyC6rr5+6ByK0XtzdOTeF4dQfqYIo1lh86i7YaIrdZezJ2QBEMggCfRR+MjnIUpSXyAJEyCVGiqwzXMQX+495Oc34pF4vtrPoTIIkNu0wCv31Vqo455dLMdB0DubqK2m/5StINE5BjhlvCBd0oWYM+0ePAa15ZCjQ7z4Wt3bOOShM2GWIr1nNMZykVPhXLqHYscIS6ujB9osaauZyw5Btc/ApP9oUpisMvVnyy1h5PdKtnT0EPLDtJTJD7vhtcHdRAs7k1MwB4ci9hZaF0X+yfPvBuJkXlrj1HVVm6TSa+EVcnkDth2pnRruh7oRC9PyoUBHSbY3CPFgixIma4PIFcCYht4ULYwmDHaew/ZGBYtB76hgvNm8C76ZZisNZltSw1TndWi4++o4gg3KGjgKGrEAa+bKPoKAKUN3PTCqCROgCLZgrYjfW4O6fjlrtJer8OH/cXVO9WYCsdsrAQl3VKuF9claMRE2NcCjMC2x0Os4+B/Xyp5yQwXCJ45moKRu5uzPGKDGAh01vszt8dZmfy2J7CopU+wdmfUw85M8XpsmAQe6abNhg9L7peS9nrj/Eog4YYtGIWFJH03fFCnFwA+NkYQmco0Q4MWtp1c7OqEC4e89HLslRH6rMS1dNAfvyrbf0JR7LY3K/AYU7+jYHxlLxKbIBbCxbKJpVhCjb9iMbUaGkn3RyOkEP60zU5rbMd/++ShNPXgummLhlbDeSWssfEiyoC2HnAiVvi7pYAQ7HCwI+xgzGKaXBTLEaZTQyR9XpuvLyAGpXtSglE9Qjd+gpkFwQY1zt6nobBmAyb97e0wa4KRPP/JjwW+DEBC9zdCXLyX/ORV26dKsqX3MRqOEcY2kFjgL4zN8psLZk
 Jz2BxVz7
 BqxVfY1OatjUmU2ap4tzpTrYm4yyu9QT5tXizXU9Dd8ab/3OKphm5cJJLqnJ9TOzYKmoep3ZrDfBgI1wt1o000KQKnp5GtdS2MMy57JogEGfj7buzNmX4PRHyf7TTJDmGltukUwWxFnnIWZYcdL2E0oF9a/xUbtcjX3HKlTkYSFAEOglNvXOUPazKvUSjSgiDjuDbERCBX2XA3PjDOBXhOjMt8JxhSl4YXviI+LDWE68X0tm8h/sBkrDFYo1sETMXyovgiiV1/VUU5ORdmG9fzvqS6l6MAp+WCLpEI3EjsJrR1XFEQyy3/cUsDskp6LqssSFqIav0UNDDnwwu6ci9zImw4pJ4HZAD2AebUbuZnYN1uAj9jTqx7TJk02G+pM9q2hCJWH3vxVAg0b+v0gMDbwhesulW5B0Sc4mb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 9, 2026 at 12:41=E2=80=AFAM Miaohe Lin <linmiaohe@huawei.com> w=
rote:
>
> On 2026/3/9 12:53, Jiaqi Yan wrote:
> > On Mon, Feb 23, 2026 at 11:30=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.c=
om> wrote:
> >>
> >> On 2026/2/13 13:01, Jiaqi Yan wrote:
> >>> On Mon, Feb 9, 2026 at 11:31=E2=80=AFPM Miaohe Lin <linmiaohe@huawei.=
com> wrote:
> >>>>
> >>>> On 2026/2/10 12:47, Jiaqi Yan wrote:
> >>>>> On Mon, Feb 9, 2026 at 3:54=E2=80=AFAM Miaohe Lin <linmiaohe@huawei=
.com> wrote:
> >>>>>>
> >>>>>> On 2026/2/4 3:23, Jiaqi Yan wrote:
> >>>>>>> Sometimes immediately hard offlining a large chunk of contigous m=
emory
> >>>>>>> having uncorrected memory errors (UE) may not be the best option.
> >>>>>>> Cloud providers usually serve capacity- and performance-critical =
guest
> >>>>>>> memory with 1G HugeTLB hugepages, as this significantly reduces t=
he
> >>>>>>> overhead associated with managing page tables and TLB misses. How=
ever,
> >>>>>>> for today's HugeTLB system, once a byte of memory in a hugepage i=
s
> >>>>>>> hardware corrupted, the kernel discards the whole hugepage, inclu=
ding
> >>>>>>> the healthy portion. Customer workload running in the VM can hard=
ly
> >>>>>>> recover from such a great loss of memory.
> >>>>>>
> >>>>>> Thanks for your patch. Some questions below.
> >>>>>>
> >>>>>>>
> >>>>>>> Therefore keeping or discarding a large chunk of contiguous memor=
y
> >>>>>>> owned by userspace (particularly to serve guest memory) due to
> >>>>>>> recoverable UE may better be controlled by userspace process
> >>>>>>> that owns the memory, e.g. VMM in the Cloud environment.
> >>>>>>>
> >>>>>>> Introduce a memfd-based userspace memory failure (MFR) policy,
> >>>>>>> MFD_MF_KEEP_UE_MAPPED. It is possible to support for other memfd,
> >>>>>>> but the current implementation only covers HugeTLB.
> >>>>>>>
> >>>>>>> For a hugepage associated with MFD_MF_KEEP_UE_MAPPED enabled memf=
d,
> >>>>>>> whenever it runs into a new UE,
> >>>>>>>
> >>>>>>> * MFR defers hard offline operations, i.e., unmapping and
> >>>>>>
> >>>>>> So the folio can't be unpoisoned until hugetlb folio becomes free?
> >>>>>
> >>>>> Are you asking from testing perspective, are we still able to clean=
 up
> >>>>> injected test errors via unpoison_memory() with MFD_MF_KEEP_UE_MAPP=
ED?
> >>>>>
> >>>>> If so, unpoison_memory() can't turn the HWPoison hugetlb page to
> >>>>> normal hugetlb page as MFD_MF_KEEP_UE_MAPPED automatically dissolve=
s
> >>>>
> >>>> We might loss some testability but that should be an acceptable comp=
romise.
> >>>
> >>> To clarify, looking at unpoison_memory(), it seems unpoison should
> >>> still work if called before truncated or memfd closed.
> >>>
> >>> What I wanted to say is, for my test hugetlb-mfr.c, since I really
> >>> want to test the cleanup code (dissolving free hugepage having
> >>> multiple errors) after truncation or memfd closed, so we can only
> >>> unpoison the raw pages rejected by buddy allocator.
> >>>
> >>>>
> >>>>> it. unpoison_memory(pfn) can probably still turn the HWPoison raw p=
age
> >>>>> back to a normal one, but you already lost the hugetlb page.
> >>>>>
> >>>>>>
> >>>>>>>   dissolving. MFR still sets HWPoison flag, holds a refcount
> >>>>>>>   for every raw HWPoison page, record them in a list, sends SIGBU=
S
> >>>>>>>   to the consuming thread, but si_addr_lsb is reduced to PAGE_SHI=
FT.
> >>>>>>>   If userspace is able to handle the SIGBUS, the HWPoison hugepag=
e
> >>>>>>>   remains accessible via the mapping created with that memfd.
> >>>>>>>
> >>>>>>> * If the memory was not faulted in yet, the fault handler also
> >>>>>>>   allows fault in the HWPoison folio.
> >>>>>>>
> >>>>>>> For a MFD_MF_KEEP_UE_MAPPED enabled memfd, when it is closed, or
> >>>>>>> when userspace process truncates its hugepages:
> >>>>>>>
> >>>>>>> * When the HugeTLB in-memory file system removes the filemap's
> >>>>>>>   folios one by one, it asks MFR to deal with HWPoison folios
> >>>>>>>   on the fly, implemented by filemap_offline_hwpoison_folio().
> >>>>>>>
> >>>>>>> * MFR drops the refcounts being held for the raw HWPoison
> >>>>>>>   pages within the folio. Now that the HWPoison folio becomes
> >>>>>>>   free, MFR dissolves it into a set of raw pages. The healthy pag=
es
> >>>>>>>   are recycled into buddy allocator, while the HWPoison ones are
> >>>>>>>   prevented from re-allocation.
> >>>>>>>
> >>>>>> ...
> >>>>>>
> >>>>>>>
> >>>>>>> +static void filemap_offline_hwpoison_folio_hugetlb(struct folio =
*folio)
> >>>>>>> +{
> >>>>>>> +     int ret;
> >>>>>>> +     struct llist_node *head;
> >>>>>>> +     struct raw_hwp_page *curr, *next;
> >>>>>>> +
> >>>>>>> +     /*
> >>>>>>> +      * Since folio is still in the folio_batch, drop the refcou=
nt
> >>>>>>> +      * elevated by filemap_get_folios.
> >>>>>>> +      */
> >>>>>>> +     folio_put_refs(folio, 1);
> >>>>>>> +     head =3D llist_del_all(raw_hwp_list_head(folio));
> >>>>>>
> >>>>>> We might race with get_huge_page_for_hwpoison()? llist_add() might=
 be called
> >>>>>> by folio_set_hugetlb_hwpoison() just after llist_del_all()?
> >>>>>
> >>>>> Oh, when there is a new UE while we releasing the folio here, right=
?
> >>>>
> >>>> Right.
> >>>>
> >>>>> In that case, would mutex_lock(&mf_mutex) eliminate potential race?
> >>>>
> >>>> IMO spin_lock_irq(&hugetlb_lock) might be better.
> >>>
> >>> Looks like I don't need any lock given the correction below.
> >>>
> >>>>
> >>>>>
> >>>>>>
> >>>>>>> +
> >>>>>>> +     /*
> >>>>>>> +      * Release refcounts held by try_memory_failure_hugetlb, on=
e per
> >>>>>>> +      * HWPoison-ed page in the raw hwp list.
> >>>>>>> +      *
> >>>>>>> +      * Set HWPoison flag on each page so that free_has_hwpoison=
ed()
> >>>>>>> +      * can exclude them during dissolve_free_hugetlb_folio().
> >>>>>>> +      */
> >>>>>>> +     llist_for_each_entry_safe(curr, next, head, node) {
> >>>>>>> +             folio_put(folio);
> >>>>>>
> >>>>>> The hugetlb folio refcnt will only be increased once even if it co=
ntains multiple UE sub-pages.
> >>>>>> See __get_huge_page_for_hwpoison() for details. So folio_put() mig=
ht be called more times than
> >>>>>> folio_try_get() in __get_huge_page_for_hwpoison().
> >>>>>
> >>>>> The changes in folio_set_hugetlb_hwpoison() should make
> >>>>> __get_huge_page_for_hwpoison() not to take the "out" path which
> >>>>> decrease the increased refcount for folio. IOW, every time a new UE
> >>>>> happens, we handle the hugetlb page as if it is an in-use hugetlb
> >>>>> page.
> >>>>
> >>>> See below code snippet (comment [1] and [2]):
> >>>>
> >>>> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
> >>>>                                  bool *migratable_cleared)
> >>>> {
> >>>>         struct page *page =3D pfn_to_page(pfn);
> >>>>         struct folio *folio =3D page_folio(page);
> >>>>         int ret =3D 2;    /* fallback to normal page handling */
> >>>>         bool count_increased =3D false;
> >>>>
> >>>>         if (!folio_test_hugetlb(folio))
> >>>>                 goto out;
> >>>>
> >>>>         if (flags & MF_COUNT_INCREASED) {
> >>>>                 ret =3D 1;
> >>>>                 count_increased =3D true;
> >>>>         } else if (folio_test_hugetlb_freed(folio)) {
> >>>>                 ret =3D 0;
> >>>>         } else if (folio_test_hugetlb_migratable(folio)) {
> >>>>
> >>>>                    ^^^^*hugetlb_migratable is checked before trying =
to get folio refcnt* [1]
> >>>>
> >>>>                 ret =3D folio_try_get(folio);
> >>>>                 if (ret)
> >>>>                         count_increased =3D true;
> >>>>         } else {
> >>>>                 ret =3D -EBUSY;
> >>>>                 if (!(flags & MF_NO_RETRY))
> >>>>                         goto out;
> >>>>         }
> >>>>
> >>>>         if (folio_set_hugetlb_hwpoison(folio, page)) {
> >>>>                 ret =3D -EHWPOISON;
> >>>>                 goto out;
> >>>>         }
> >>>>
> >>>>         /*
> >>>>          * Clearing hugetlb_migratable for hwpoisoned hugepages to p=
revent them
> >>>>          * from being migrated by memory hotremove.
> >>>>          */
> >>>>         if (count_increased && folio_test_hugetlb_migratable(folio))=
 {
> >>>>                 folio_clear_hugetlb_migratable(folio);
> >>>>
> >>>>                 ^^^^^*hugetlb_migratable is cleared when first time =
seeing folio* [2]
> >>>>
> >>>>                 *migratable_cleared =3D true;
> >>>>         }
> >>>>
> >>>> Or am I miss something?
> >>>
> >>> Thanks for your explaination! You are absolutely right. It turns out
> >>> the extra refcount I saw (during running hugetlb-mfr.c) on the folio
> >>> at the moment of filemap_offline_hwpoison_folio_hugetlb() is actually
> >>> because of the MF_COUNT_INCREASED during MADV_HWPOISON. In the past I
> >>> used to think that is the effect of folio_try_get() in
> >>> __get_huge_page_for_hwpoison(), and it is wrong. Now I see two cases:
> >>> - MADV_HWPOISON: instead of __get_huge_page_for_hwpoison(),
> >>> madvise_inject_error() is the one that increments hugepage refcount
> >>> for every error injected. Different from other cases,
> >>> MFD_MF_KEEP_UE_MAPPED makes the hugepage still a in-use page after
> >>> memory_failure(MF_COUNT_INCREASED), so I think madvise_inject_error()
> >>> should decrement in MFD_MF_KEEP_UE_MAPPED case.
> >>> - In the real world: as you pointed out, MF always just increments
> >>> hugepage refcount once in __get_huge_page_for_hwpoison(), even if it
> >>> runs into multiple errors. When
> >>
> >> This might not always hold true. When MF occurs while hugetlb folio is=
 under isolation(hugetlb_migratable is
> >> cleared and extra folio refcnt is held by isolating code in that case)=
, __get_huge_page_for_hwpoison won't get
> >> extra folio refcnt.
> >>
> >>> filemap_offline_hwpoison_folio_hugetlb() drops the refcount elevated
> >>> by filemap_get_folios(), it only needs to decrement again if
> >>> folio_ref_dec_and_test() returns false. I tested something like below=
:
> >>>
> >>>     /* drop the refcount elevated by filemap_get_folios. */
> >>>     folio_put(folio);
> >>>     if (folio_ref_count(folio))
> >>>         folio_put(folio);
> >>>     /* now refcount should be zero. */
> >>>     ret =3D dissolve_free_hugetlb_folio(folio);
> >>
> >> So I think above code might drop the folio refcnt held by isolating co=
de.
> >
> > Hi Miaohe, thanks for raising the concern. Given two things below
> > - both folio_isolate_hugetlb() and get_huge_page_for_hwpoison() are
> > guarded by hugetlb_lock.
> > - hugetlb_update_hwpoison() only folio_test_set_hwpoison() for
> > non-isolated folio after folio_try_get() succeeds.
> >
> > as long as folio_test_set_hwpoison() is true here, this refcount
> > should never come from folio_isolate_hugetlb(). What do you think?
> >
>
> Let's think about below scenario. When __get_huge_page_for_hwpoison() enc=
ounters an
> isolated hugetlb folio:
>
> int __get_huge_page_for_hwpoison(unsigned long pfn, int flags,
>                                  bool *migratable_cleared)
> {
>         struct page *page =3D pfn_to_page(pfn);
>         struct folio *folio =3D page_folio(page);
>         bool count_increased =3D false;
>         int ret, rc;
>
>         if (!folio_test_hugetlb(folio)) {
>                 ret =3D MF_HUGETLB_NON_HUGEPAGE;
>                 goto out;
>         } else if (flags & MF_COUNT_INCREASED) {
>                 ret =3D MF_HUGETLB_IN_USED;
>                 count_increased =3D true;
>         } else if (folio_test_hugetlb_freed(folio)) {
>                 ret =3D MF_HUGETLB_FREED;
>         } else if (folio_test_hugetlb_migratable(folio)) {
>
>                    ^^^^*Since hugetlb_migratable is cleared for the isola=
ted hugetlb folio*
>
>                 if (folio_try_get(folio)) {
>                         ret =3D MF_HUGETLB_IN_USED;
>                         count_increased =3D true;
>                 } else {
>                         ret =3D MF_HUGETLB_FREED;
>                 }
>         } else {
>
>                   ^^^^*Code will reach here without extra refcnt increase=
d*
>
>                 ret =3D MF_HUGETLB_RETRY;
>                 if (!(flags & MF_NO_RETRY))
>                         goto out;
>         }
>
>         *Code will reach here after retry*

You are right, thanks for pointing that out. Let me think about more
how to handle this.

>         rc =3D hugetlb_update_hwpoison(folio, page);
>         if (rc >=3D MF_HUGETLB_FOLIO_PRE_POISONED) {
>                 ret =3D rc;
>                 goto out;
>         }
>
> So hugetlb_update_hwpoison() will be called even for folio under isolatio=
n
> without folio_try_get(). Or am I miss something?

Just a random question: if MF never increments a hugepage's refcount,
what does the folio_put() in me_huge_page() (when mapping =3D null) do?
Is it dropping for something other than MF?

>
> Thanks.
> .

