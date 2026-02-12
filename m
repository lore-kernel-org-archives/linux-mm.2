Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7177FEEA84C
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 20:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 749646B0088; Thu, 12 Feb 2026 15:27:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721726B0089; Thu, 12 Feb 2026 15:27:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 623AC6B008A; Thu, 12 Feb 2026 15:27:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4FBB36B0088
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 15:27:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E5460B1570
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:27:24 +0000 (UTC)
X-FDA: 84436939608.11.6F1A007
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf01.hostedemail.com (Postfix) with ESMTP id 8E59840005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 20:27:22 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fvbi7gAF;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770928042;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rc2t99+KriQrQ9nNG5NRjQv02Rxrtnjhfwc6v2DDtoI=;
	b=hB9GD/N0tMPWtCQmUbA87dBh+vMqquJgayaL0KAjeyLcB+tps9BFn7i4NAtXpXXiYXrVe9
	DJoY6yNAT/BaqsvSruT66VlN1YhQXRn5/ma9PQPdoOupZ16O6m6Ca8gjWUCbxrqmxapGFC
	YBkQGvioW1Vw7PvdvVBYmXkQvwyZisU=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Fvbi7gAF;
	spf=pass (imf01.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770928042; a=rsa-sha256;
	cv=none;
	b=t5JyjfA0bVn1G8JwaGHmtZI1XZnyBFcreaunMAS0A4Lq7TMPVV697/Ww3TTEU082KeRmLC
	eWgmmiQUqxlJkgtXe8/sqgVV+7l+0JxA7K19mR7sTQcD7rHYsK+iyhyno6ZSQQ1NGxZsUt
	upxSvFY5WbRWCZ+6HhsBgf/JJHBSXZU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770928041;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rc2t99+KriQrQ9nNG5NRjQv02Rxrtnjhfwc6v2DDtoI=;
	b=Fvbi7gAF6IygIcb/smdITWQmJvJD12aIUmq2VOfLcFVQYbqfYfi+Fj4notjmIz2APd3YhE
	MO7LBbUPgOAfJViM2A8BqzZrQ+BnRICqulC6nxy8juBFMTt0XuBkpWUl7te/2DcuWhGm0/
	gtnzfjXd8b9NpbKWwi6ZcOPI511Ym9s=
Received: from mail-yw1-f200.google.com (mail-yw1-f200.google.com
 [209.85.128.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-661-rm-ID79VNoaUbKv9z4_xCg-1; Thu, 12 Feb 2026 15:27:20 -0500
X-MC-Unique: rm-ID79VNoaUbKv9z4_xCg-1
X-Mimecast-MFC-AGG-ID: rm-ID79VNoaUbKv9z4_xCg_1770928040
Received: by mail-yw1-f200.google.com with SMTP id 00721157ae682-78fb85eddf1so4436677b3.3
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:27:20 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770928040; x=1771532840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rc2t99+KriQrQ9nNG5NRjQv02Rxrtnjhfwc6v2DDtoI=;
        b=CX+pMThlKvKRiGxjQLaU0dMjMrEpEijwjcXSpSZo3RDbB8ZNgh3FEGdFvqOe/Fw0l6
         NZgD9QneKuVlxQIXZFq2qdErGKlGUCwz4ozrYKIUmGuXxSjDWoUes/ZqypN/gtmrjvrw
         kKHclAenZcFcwBtdxXCjUAWkEelEynJSw67Hah9u0h3+pYnjJIC1xyaTNpLEzALh0Gts
         bAnupBbYsbX5OAqodh872LlaA1gCaJ46OITBw8d5qkEUSMe/FNp8tCFRhpGc8AYKHMeU
         k136Arz6SARr40fRTfrUV8p6JaWK+/GJwPVABTsIlFOo/HSDJXB1QcajQhxRUkhLSDeE
         SfCw==
X-Forwarded-Encrypted: i=1; AJvYcCWaGkUp1xiLps1vD8xphy1mzNzrPHwaGPlyQa2DBbaqNjTosnTNEJ9yMBv+YczMqB/YWPWdlvR5Dw==@kvack.org
X-Gm-Message-State: AOJu0Ywiyc2SFPgnLGybxJCISjifq7ErO7pos6AEsft7jTNI06lY7WLS
	mJqMhzXMzFF9SQd2JOn20I7PacvC3hkeJBcyg9V6RLzdpBnXYgoU9m4tmaXfiJQOnX9dqp8qH6V
	uwSFHNO/hMiYXUwjSfHghmfstFU+sgFiPL4xG8xNnwsNoVDmsEoNUu4I9w5c9xJjGNtYsE/Rdmz
	lDZjokhIZ0+cTHouD+CXzN0ps+eQM=
X-Gm-Gg: AZuq6aLvqVTPTV98fGsHFwO47LLksxJZE/oM26ayVRMv2/iHWr/xNEvYXJPGdRxdZQD
	xN+yjxY/vO+Vfl8PAiMJrx6sBlFkdyczzEzec1jwhGvl3MGg43wzq/NtIpPhgDRLSOzwhntifAc
	w6aG6KOjHEXOSA4oqTujL3D4J0fO1dG8e6wyjU/Ea2dh4N0UaimN+slt/a0IJlMNm9SK3Loebhy
	loN/3bc68X70NRgUwWz
X-Received: by 2002:a05:690c:3808:b0:794:ef94:1222 with SMTP id 00721157ae682-7979e8ddf76mr1736497b3.55.1770928039811;
        Thu, 12 Feb 2026 12:27:19 -0800 (PST)
X-Received: by 2002:a05:690c:3808:b0:794:ef94:1222 with SMTP id
 00721157ae682-7979e8ddf76mr1735787b3.55.1770928039319; Thu, 12 Feb 2026
 12:27:19 -0800 (PST)
MIME-Version: 1.0
References: <20260212021835.17755-1-npache@redhat.com> <20260212022512.19076-1-npache@redhat.com>
 <164bfaf0-5e8a-4bd2-a04c-93d61856a941@kernel.org>
In-Reply-To: <164bfaf0-5e8a-4bd2-a04c-93d61856a941@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Thu, 12 Feb 2026 13:26:52 -0700
X-Gm-Features: AZwV_QhcOWgmwTmCLhknPo8O3twS27VTNA1kxpvadI7MN3c5Wilrp-RmS0HYYyg
Message-ID: <CAA1CXcCA6HN_Y4npsH==6tbCJbtMR=+OBmRWowb5NmficZdcHw@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v1 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, dev.jain@arm.com, gourry@gourry.net, 
	hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, jack@suse.cz, 
	jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, kas@kernel.org, 
	lance.yang@linux.dev, Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
	mathieu.desnoyers@efficios.com, matthew.brost@intel.com, mhiramat@kernel.org, 
	mhocko@suse.com, peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, 
	raquini@redhat.com, rdunlap@infradead.org, richard.weiyang@gmail.com, 
	rientjes@google.com, rostedt@goodmis.org, rppt@kernel.org, 
	ryan.roberts@arm.com, shivankg@amd.com, sunnanyong@huawei.com, 
	surenb@google.com, thomas.hellstrom@linux.intel.com, tiwai@suse.de, 
	usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 9U4cY4bAcAHjhYQOmAiMq2Um7t27NtoiSUQr4rrC3fs_1770928040
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8E59840005
X-Stat-Signature: 6i4cong4d77qn34eio1mefrkh7u4m66p
X-Rspam-User: 
X-HE-Tag: 1770928042-517946
X-HE-Meta: U2FsdGVkX1/d4JnNHtBA/bYRB1cnqSwesZzuprh/l8aZBwdp/Iik1czT5ycvoPPU0uJsx0HQDsGY2/m6It6nDL7tmdtfv1mxKk2NCjvrDImXhj0CZAZsEZCzfkPJwQ4S6MvO6AbioBJ487CZX1/2dGQ7ioqtvWLP4zY1uGKq4S6fK3cmMIkUJrKNjocnreysd/8utJlxDyIFd3lr9LnslyqyBb3EkwniDsek5wWkOhKPcrAmkPH+kxv26I1C3EXIPhYfajdSOS+IdwLR+Eitk8Ced40YyCiDNEw7hEx0HKuLrMtjo7eu8lsawy+TxlqEXlO0hRJbH8CPkJhLl+dTlXao9WQGefX8R1dINQ2Vu97YlPChcny4/jPwTGUSd+Ejc0++lqNqA+UmIL/V+/Lmxb0dE04D1LKoiG85X6pOk2w/V3K5Ca1LwXsi09O/FLFQkXSm5J0pyMTldGh01AGhrZ+Tpsgb8B/POHts/VsCcTnce9tly4wJmq0Uf49eZXfzZ+jlhPgihHzk7CDRb5S077hm6N7Y7wzRpkTQOBhGtQIL1vEI7t8zLpRn+ub3ehEm1OnOFzLLGBRQwmBlwR9EwtSCfyz3lbwc9tAI5Xz0CIO/tRrkETLo7chQeouGRZBpB/VTM9rJFL6BF1X/mC7fgBW6mmLgFJLVWkFr83z+p588zaRF+nvCaT7JvHRXQlQLe2kpQiaNRjl269jYfXqcQlHuTh8FoU0tgzhWiNaKKaRtlRCvPGVw8os0Nx2HpbFR2LW52wHbps5UgQCDKXf2n3sLHZLCsIJVj4SCLqExz29EI6HIEPsC9T+zRtHvreyEzlB71/WLKtNwF1oySXBL9SI2ce4mzDjGTL8GcxgJkq772cxmERmJ7+aXgBr4CXEluY6wBf/h3Z9tSs2EIPRO3lTnAXjS/jyugstphdwnyrCvVQQ231oVzy7bNZf0xIbkSiBG8T+N7mtN/D0tMOk
 KbQWv1Zo
 s4hFxtCCdMoigy00RklRTX49TthKmWckD3OyIOwQ4zULbNckq2v3Y2m0pGbJiVow5ARx/o4LxBbCBKc1sD83Mc5W9lWvtX2lNp08/p34w4UmZqR6s+3QzmqCyYpkM9b63ktNIHRa13Dqv3VYPUEmTnuldIVsn3/+BQRCmqiDTcYOzcmYG5U5d0WxydaLmuQst4f6x4rmGR+8am1nxrtL298zyOKNpSvwlidz6egssLweDzypVpTs0jGR0PjQVe4E7ggalk7sGhAkrk3eo4qRdIPKsxawY2iaefsY3TV6SRRozouR1lV0MfxtIafOFpUX8wB21/qgtrNG54alpWJtIEA1u7Gz+OWiueWUjOOUdfqzZ5naBA2Iz8zIWaGes0yEzi4JWRQHPk/1y9h75xA4arK/r9HO3++Pq+PKUaRuZGXmVx3OTLtAuYxWYts/lZJquUAggCC5nzk8FemmTUB7ioTRoTNI3xaQF6+cLBAdKeA4KK1k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 12, 2026 at 1:04=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/12/26 03:25, Nico Pache wrote:
> > The khugepaged daemon and madvise_collapse have two different
> > implementations that do almost the same thing.
> >
> > Create collapse_single_pmd to increase code reuse and create an entry
> > point to these two users.
> >
> > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > collapse_single_pmd function. This introduces a minor behavioral change
> > that is most likely an undiscovered bug. The current implementation of
> > khugepaged tests collapse_test_exit_or_disable before calling
> > collapse_pte_mapped_thp, but we weren't doing it in the madvise_collaps=
e
> > case. By unifying these two callers madvise_collapse now also performs
> > this check. We also modify the return value to be SCAN_ANY_PROCESS whic=
h
> > properly indicates that this process is no longer valid to operate on.
> >
> > We also guard the khugepaged_pages_collapsed variable to ensure its onl=
y
> > incremented for khugepaged.
> >
> > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >   mm/khugepaged.c | 121 ++++++++++++++++++++++++++---------------------=
-
> >   1 file changed, 66 insertions(+), 55 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index fa41480f6948..0839a781bedd 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2395,6 +2395,62 @@ static enum scan_result collapse_scan_file(struc=
t mm_struct *mm, unsigned long a
> >       return result;
> >   }
> >
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and re=
turn
> > + * the results.
> > + */
> > +static enum scan_result collapse_single_pmd(unsigned long addr,
> > +             struct vm_area_struct *vma, bool *mmap_locked,
> > +             struct collapse_control *cc)
> > +{
> > +     struct mm_struct *mm =3D vma->vm_mm;
> > +     enum scan_result result;
> > +     struct file *file;
> > +     pgoff_t pgoff;
> > +
> > +     if (vma_is_anonymous(vma)) {
> > +             result =3D collapse_scan_pmd(mm, vma, addr, mmap_locked, =
cc);
> > +             goto end;
> > +     }
> > +
> > +     file =3D get_file(vma->vm_file);
> > +     pgoff =3D linear_page_index(vma, addr);
> > +
> > +     mmap_read_unlock(mm);
> > +     *mmap_locked =3D false;
> > +     result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
> > +
> > +     if (!cc->is_khugepaged && result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEB=
ACK &&
> > +         mapping_can_writeback(file->f_mapping)) {
> > +             const loff_t lstart =3D (loff_t)pgoff << PAGE_SHIFT;
> > +             const loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1;
> > +
> > +             filemap_write_and_wait_range(file->f_mapping, lstart, len=
d);
> > +     }
> > +     fput(file);
> > +
> > +     if (result !=3D SCAN_PTE_MAPPED_HUGEPAGE)
> > +             goto end;
> > +
> > +     mmap_read_lock(mm);
> > +     *mmap_locked =3D true;
> > +     if (collapse_test_exit_or_disable(mm)) {
> > +             mmap_read_unlock(mm);
> > +             *mmap_locked =3D false;
> > +             return SCAN_ANY_PROCESS;
> > +     }
> > +     result =3D try_collapse_pte_mapped_thp(mm, addr, !cc->is_khugepag=
ed);
> > +     if (result =3D=3D SCAN_PMD_MAPPED)
> > +             result =3D SCAN_SUCCEED;
> > +     mmap_read_unlock(mm);
> > +     *mmap_locked =3D false;
> > +
> > +end:
> > +     if (cc->is_khugepaged && result =3D=3D SCAN_SUCCEED)
> > +             ++khugepaged_pages_collapsed;
> > +     return result;
> > +}
> > +
> >   static unsigned int collapse_scan_mm_slot(unsigned int pages, enum sc=
an_result *result,
> >                                           struct collapse_control *cc)
> >       __releases(&khugepaged_mm_lock)
> > @@ -2466,34 +2522,9 @@ static unsigned int collapse_scan_mm_slot(unsign=
ed int pages, enum scan_result *
> >                       VM_BUG_ON(khugepaged_scan.address < hstart ||
> >                                 khugepaged_scan.address + HPAGE_PMD_SIZ=
E >
> >                                 hend);
> > -                     if (!vma_is_anonymous(vma)) {
> > -                             struct file *file =3D get_file(vma->vm_fi=
le);
> > -                             pgoff_t pgoff =3D linear_page_index(vma,
> > -                                             khugepaged_scan.address);
> > -
> > -                             mmap_read_unlock(mm);
> > -                             mmap_locked =3D false;
> > -                             *result =3D collapse_scan_file(mm,
> > -                                     khugepaged_scan.address, file, pg=
off, cc);
> > -                             fput(file);
> > -                             if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
> > -                                     mmap_read_lock(mm);
> > -                                     if (collapse_test_exit_or_disable=
(mm))
> > -                                             goto breakouterloop;
> > -                                     *result =3D try_collapse_pte_mapp=
ed_thp(mm,
> > -                                             khugepaged_scan.address, =
false);
> > -                                     if (*result =3D=3D SCAN_PMD_MAPPE=
D)
> > -                                             *result =3D SCAN_SUCCEED;
> > -                                     mmap_read_unlock(mm);
> > -                             }
> > -                     } else {
> > -                             *result =3D collapse_scan_pmd(mm, vma,
> > -                                     khugepaged_scan.address, &mmap_lo=
cked, cc);
> > -                     }
> > -
> > -                     if (*result =3D=3D SCAN_SUCCEED)
> > -                             ++khugepaged_pages_collapsed;
> >
> > +                     *result =3D collapse_single_pmd(khugepaged_scan.a=
ddress,
> > +                                                   vma, &mmap_locked, =
cc);
> >                       /* move to next address */
> >                       khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> >                       progress +=3D HPAGE_PMD_NR;
> > @@ -2799,6 +2830,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >                       cond_resched();
> >                       mmap_read_lock(mm);
> >                       mmap_locked =3D true;
> > +                     *lock_dropped =3D true;
> >                       result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
> >                                                        cc);
> >                       if (result  !=3D SCAN_SUCCEED) {
> > @@ -2809,46 +2841,25 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >                       hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
> >               }
> >               mmap_assert_locked(mm);
> > -             if (!vma_is_anonymous(vma)) {
> > -                     struct file *file =3D get_file(vma->vm_file);
> > -                     pgoff_t pgoff =3D linear_page_index(vma, addr);
> >
> > -                     mmap_read_unlock(mm);
> > -                     mmap_locked =3D false;
> > -                     *lock_dropped =3D true;
> > -                     result =3D collapse_scan_file(mm, addr, file, pgo=
ff, cc);
> > -
> > -                     if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK &&=
 !triggered_wb &&
> > -                         mapping_can_writeback(file->f_mapping)) {
> > -                             loff_t lstart =3D (loff_t)pgoff << PAGE_S=
HIFT;
> > -                             loff_t lend =3D lstart + HPAGE_PMD_SIZE -=
 1;
> > +             result =3D collapse_single_pmd(addr, vma, &mmap_locked, c=
c);
> >
> > -                             filemap_write_and_wait_range(file->f_mapp=
ing, lstart, lend);
> > -                             triggered_wb =3D true;
> > -                             fput(file);
> > -                             goto retry;
> > -                     }
> > -                     fput(file);
> > -             } else {
> > -                     result =3D collapse_scan_pmd(mm, vma, addr, &mmap=
_locked, cc);
> > -             }
> >               if (!mmap_locked)
> >                       *lock_dropped =3D true;
> >
> > -handle_result:
> > +             if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK && !trigge=
red_wb) {
> > +                     triggered_wb =3D true;
> > +                     goto retry;
> > +             }
>
> Having triggered_wb set where writeback is not actually triggered is
> suboptimal.

It took me a second to figure out what you were referring to, but I
see it now. if we return SCAN_PAGE_D_OR_WB but the can_writeback fails
it still retries.

Would be an appropriate solution if can_writeback fails to modify the
return value.
ie)

if (!cc->is_khugepaged && result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK) {
    if (mapping_can_writeback(file->f_mapping)) {
       const loff_t lstart =3D (loff_t)pgoff << PAGE_SHIFT;
       const loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1;

       filemap_write_and_wait_range(file->f_mapping, lstart, lend);
    } else {
       result =3D SCAN_(SOMETHING?)
    }
}
fput(file);

we dont have a enum that fits this description but we want one that
will continue.

Cheers!
-- Nico

>
> And you can tell that by realizing that you would now retry once even
> thought the mapping does not support writeback (
> mapping_can_writeback(file->f_mapping)) and no writeback actually happene=
d.
>
> Further, we would also try to call filemap_write_and_wait_range() now
> twice instead of only during the first round.
>
> --
> Cheers,
>
> David
>


