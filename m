Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7FA110F9302
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 21:09:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E77C66B0092; Tue, 31 Mar 2026 17:09:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4FBF6B0095; Tue, 31 Mar 2026 17:09:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D66076B0096; Tue, 31 Mar 2026 17:09:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C311B6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 17:09:35 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 627D51B7AD5
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:09:35 +0000 (UTC)
X-FDA: 84607599510.03.1230F47
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf22.hostedemail.com (Postfix) with ESMTP id 26D40C0003
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 21:09:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="SU0aoT/h";
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774991373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Kz2WaReBH1y3geG5w/4JcvNm9surAWQhYNmvDWDXFRk=;
	b=PHRuK7ajaULr6mbMtgV+RRJfHlZLAbxtrpksSipFefwR+rMBoFYk0rF/NxcCaShfqjgpiE
	6UM1P7zngst1AEjfO/X48idniaoDXr5gN1cvtc5dzKssh5muMooOPfo6JKbOuDct4Yo7+w
	A3vsS1fQVEXVJiUfTngn738RTibk12Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774991373; a=rsa-sha256;
	cv=none;
	b=b7xpyjeMh9pg5s8zrhTbeRvaQ0V22yRiLIzQxdfjLmrBTgST7LaW1BENh4DahtyUq7tQ0H
	GqpK8OdfG4a0Xe30wkPEo7In+YIl4/b7+BS743sXz95pQu968TmJ4MnaQMBe1jz2OHI5u1
	vgN1sEY6mCvZNroOfPrzA81nwLgBk+U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="SU0aoT/h";
	spf=pass (imf22.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774991372;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kz2WaReBH1y3geG5w/4JcvNm9surAWQhYNmvDWDXFRk=;
	b=SU0aoT/hOeSjevh9pXvj0dEvtF47ZurYIkETMzvr1/F5A5keijaNZt39x6rArxp8t4+bsh
	lWtm/auljJ2YHICnqpdkb4J34IRMuXy6RFeSVxLLnYggCWW1auWNnws7LXC6bpB+Um63Rf
	bySZxzNVlx0Cw3akWWPh9rZ9m9vJRbI=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-151-ZNc1aYHFNIGc3CrLpkXYFg-1; Tue, 31 Mar 2026 17:09:31 -0400
X-MC-Unique: ZNc1aYHFNIGc3CrLpkXYFg-1
X-Mimecast-MFC-AGG-ID: ZNc1aYHFNIGc3CrLpkXYFg_1774991370
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64ffe451e14so9614159d50.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 14:09:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774991370; x=1775596170;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Kz2WaReBH1y3geG5w/4JcvNm9surAWQhYNmvDWDXFRk=;
        b=HtpRoOPaVBQW9kHH0uUeOKFNmunedM4uLut+LTLbjNhH5sN6L26xpQAYH3/dJVXNfc
         ekirn1+YzucPSrn/UHUU8Qh1Y3/dshMZcx7zzuJuDWWUBOTn7TTKYcyzVhO9gtxROwBw
         B8vNK+CY92bCJpzuYsgkcnAKUdpn9WxmVYnoGjkrEqZ7DoyXyQv4eLKKw6PuSPvPklMg
         Zwf1bPXlFgOLvQkTEEF683opJQWaxCCEBDJOnU9lV+q/TXb2IyQGfWl9g99v6OIKAPYk
         im/Uhz6MixEKpiO3imPK1c1+1T9W6CYU0gl9pvXUnRgLuVfm+d3wJs5n9dLSmh6szmpb
         hLyw==
X-Forwarded-Encrypted: i=1; AJvYcCV1V8R0J5OiHoUYvCfLu4XDn+9MWPfOEj+fdETUVm7Tys2GwFHIrkUnRJQj3bxjsj6Kvk4M57zCNg==@kvack.org
X-Gm-Message-State: AOJu0YxhpJYLaIo9/Cr0XKM88Nxv/qVKobmbM30plrqLZN+NZKTrQWwV
	UjVdX0M6jbLYnrayrADIkgpCZAHzAi/YQ/rocEp88hnyahnyhnYpYCsYz0Rzj0oipvrGvNiK3bz
	L2Vz1fJFVis4OR4gViy8m72urMqS1/HmhV4i3rq2AHjQyMig9dkIto+S6fKmqyOf60OKhsdEKvW
	n+kiZ9uqbB0mlTBNXX3Mc7Y7LoIcE=
X-Gm-Gg: ATEYQzwxYWFVSvRkxYG9hTVkQbErlzt1UH/1bNolQztgF585WtQp8NMWCD61pCek0pA
	ZsEod+IJBK3dZnBfZihGsmwaJHfq81AOr3m4feQQq7GbSFulkp8WI5tG7wl0us1+q1oZJk3pqc3
	zGAT0pwgzuHZ2+WJmcTsIQOm2CjpG8o9gjnUlNp3L7TyvOBhDI6F3MMcvzkP93zUk9GWCNdy0tp
	G71kjR8
X-Received: by 2002:a53:ea4d:0:b0:64e:e90c:5682 with SMTP id 956f58d0204a3-6502feb45a1mr755020d50.66.1774991370417;
        Tue, 31 Mar 2026 14:09:30 -0700 (PDT)
X-Received: by 2002:a53:ea4d:0:b0:64e:e90c:5682 with SMTP id
 956f58d0204a3-6502feb45a1mr754973d50.66.1774991369882; Tue, 31 Mar 2026
 14:09:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260325114022.444081-1-npache@redhat.com> <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local> <0223d45b-e8b4-49a7-882b-477250d0c14d@kernel.org>
 <fef63b28-a364-4e7c-bdbd-6d0403632920@lucifer.local> <26fcec86-ee78-4f5c-8ca5-0e6230699cfd@kernel.org>
 <440d6b8a-d299-43eb-83b5-6625f9468e5e@lucifer.local> <37132e09-9c03-4afc-bc73-4bca416c5343@kernel.org>
 <9d5a4703-a15e-4be6-926b-af2d98db40c0@kernel.org>
In-Reply-To: <9d5a4703-a15e-4be6-926b-af2d98db40c0@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 31 Mar 2026 15:09:08 -0600
X-Gm-Features: AQROBzCrJ0dOKq7MHwKLsq9qklkbNmoSJ-7ELrRDpcJn1e5iBPnmBJmPC1e3vBk
Message-ID: <CAA1CXcCYLGQBy9nT-MSTPVK=XgWWtD6Af-QiA_6pXtM_2pybPg@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	aarcange@redhat.com, akpm@linux-foundation.org, anshuman.khandual@arm.com, 
	apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
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
X-Mimecast-MFC-PROC-ID: zZjtjMIRbIPNfQ-ib-J7GWhJbBpx4-ty7ghlDXsKwZM_1774991370
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 26D40C0003
X-Stat-Signature: fg6pk1km3tnrhy965hae9s1taisqrn8y
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774991373-402157
X-HE-Meta: U2FsdGVkX1+U84YURPT+lkPxLRq+9qvqPrbLmq1yBGKrB6el0A4djbJ7YCBT3WDgDqBZajmSQcPxnDACssN5ffb3r/+utu1rWtb4wLhwA3Alllw4EH/3xzpx0PBDFHYiL54uhceOhH9r+3ImWlqPhak6yqFVFXwJWXfMR6+pn+BiHAb0Lzi3QfQ68xed4thUSu9JkgYFUHHcTVPn5RMwFg6o19M3POJwPbkuwgSxvLAWDsJCtw530qz0AtjkNtA4VF7bJ0pNJstGWKoKT5T80LYqmsHWx9hSa20tNdC9NMZeILGmSpBAfvrR0eaMnAQV5UoOiSW3gTNWfqmpgIiytdEM4h295XVqceYkPFZlogU2NGpkea23/2M3y9QrLOSKqu1D//Yx7LeaZQVCty1eGNwW4Ja0mmcJN9P0fXm3uHtp6BEviK161GdQunj2Vxs24FEgNrGUfxnRLt/NpYYh4CR7BRVe4Rmcln69vLkT+R1vlbmvH6saWphlas3k+EHxJCa0HDDyORqzVuanWLw5XdiWLhAlgLlS/4YCYEbxsL1YLL5mZSqWgBjZfHIchKbrmgfTkkmWpVZPCPfmct+UUADznm1XwJBmxn7bYgDxwDmn6S2lvqIS6Fqc6+J9hpcOK7Ptzx/GTqp191ZeBivt/WXimMzb40WnAvWKv40jVg4mKYrBdchIBOXS8ZQDeSRdYd+sLBTsgG/+ddAkngCkydwme3X+wFZAt/4TSHLZTP+JoKXzC71qon78qFl30nARt1+Fum/I6RCz9khD/2EBf7srSmXu4Fzgi829iQDSqUvejtMepBzGzlhx6xTxi0XCuJ6OB1FYKKxYyLbiIB45g8FMNshtCu34U9j2R8USMkT8Po8a3+KI5gzbvgZRlHrH3mUbDPA91K2/5dqIScuN37sBeC0YukhrspD26VSQhAGBfKYMPsIBxlKZdMqoS4zlq4uVMavEebFM4vPdT19
 IgvIUWkO
 VIf/m95ZbOLOrqmdKf8dRjexkKKYeEbe8R/uLDDZbk81K/y0bMgkhYc0XNU+B/J+/EhLrsK7FryWE+WCprZVKBPapiujXrfMvFpXaas5QpJwWhqLQyKXA5WHcI9DKDDjJMQSo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 3:04=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 3/31/26 22:50, David Hildenbrand (Arm) wrote:
> > On 3/31/26 22:06, Lorenzo Stoakes (Oracle) wrote:
> >> On Tue, Mar 31, 2026 at 10:00:58PM +0200, David Hildenbrand (Arm) wrot=
e:
> >>>
> >>> Right.
> >>>
> >>> The original code used
> >>>
> >>>     bool mmap_locked =3D true;
> >>>
> >>> If the fix get squashed, maybe we should revert to that handling to
> >>> minimize the churn?
> >>
> >> Well collapse_single_pmd() and all descendents would need to be update=
d to
> >> invert the boolean, not sure it's worth it.
> >
> > The code is confusing me.
> >
> > In the old code, collapse_single_pmd() was called with "mmap_locked =3D=
=3D
> > true" and set "mmap_locked=3Dfalse".
> >
> > Now we call it with "mmap_unlocked=3Dfalse" and it sets "mmap_unlocked=
=3Dtrue".
> >
> > So far so good.
> >
> > However, collapse_scan_pmd() consumed "mmap_locked", now it effectively
> > consumes "mmap_unlocked".
>
> Okay, I'm too confused for today and give up :)
>
> FWIW, this is the effective change, and the effective changes to
> mmap_unlocked and lock_dropped ... confuse me:

basically all the logic was inverted.

>
>
>  mm/khugepaged.c | 146 +++++++++++++++++++++++++-----------------------
>  1 file changed, 76 insertions(+), 70 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 26c38934e829..3ffff9f98b2f 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1253,7 +1253,7 @@ static enum scan_result collapse_huge_page(struct m=
m_struct *mm, unsigned long a
>
>  static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
>                 struct vm_area_struct *vma, unsigned long start_addr,
> -               bool *mmap_locked, struct collapse_control *cc)
> +               bool *lock_dropped, struct collapse_control *cc)
>  {
>         pmd_t *pmd;
>         pte_t *pte, *_pte;
> @@ -1428,7 +1428,7 @@ static enum scan_result collapse_scan_pmd(struct mm=
_struct *mm,
>                 result =3D collapse_huge_page(mm, start_addr, referenced,
>                                             unmapped, cc);
>                 /* collapse_huge_page will return with the mmap_lock rele=
ased */
> -               *mmap_locked =3D false;
> +               *lock_dropped =3D true;
>         }
>  out:
>         trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> @@ -2420,6 +2420,67 @@ static enum scan_result collapse_scan_file(struct =
mm_struct *mm,
>         return result;
>  }
>
> +/*
> + * Try to collapse a single PMD starting at a PMD aligned addr, and retu=
rn
> + * the results.
> + */
> +static enum scan_result collapse_single_pmd(unsigned long addr,
> +               struct vm_area_struct *vma, bool *lock_dropped,
> +               struct collapse_control *cc)
> +{
> +       struct mm_struct *mm =3D vma->vm_mm;
> +       bool triggered_wb =3D false;
> +       enum scan_result result;
> +       struct file *file;
> +       pgoff_t pgoff;
> +
> +       mmap_assert_locked(mm);
> +
> +       if (vma_is_anonymous(vma)) {
> +               result =3D collapse_scan_pmd(mm, vma, addr, lock_dropped,=
 cc);
> +               goto end;
> +       }
> +
> +       file =3D get_file(vma->vm_file);
> +       pgoff =3D linear_page_index(vma, addr);
> +
> +       mmap_read_unlock(mm);
> +       *lock_dropped =3D true;
> +retry:
> +       result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
> +
> +       /*
> +        * For MADV_COLLAPSE, when encountering dirty pages, try to write=
back,
> +        * then retry the collapse one time.
> +        */
> +       if (!cc->is_khugepaged && result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEB=
ACK &&
> +           !triggered_wb && mapping_can_writeback(file->f_mapping)) {
> +               const loff_t lstart =3D (loff_t)pgoff << PAGE_SHIFT;
> +               const loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1;
> +
> +               filemap_write_and_wait_range(file->f_mapping, lstart, len=
d);
> +               triggered_wb =3D true;
> +               goto retry;
> +       }
> +       fput(file);
> +
> +       if (result =3D=3D SCAN_PTE_MAPPED_HUGEPAGE) {
> +               mmap_read_lock(mm);
> +               if (collapse_test_exit_or_disable(mm))
> +                       result =3D SCAN_ANY_PROCESS;
> +               else
> +                       result =3D try_collapse_pte_mapped_thp(mm, addr,
> +                                                            !cc->is_khug=
epaged);
> +               if (result =3D=3D SCAN_PMD_MAPPED)
> +                       result =3D SCAN_SUCCEED;
> +               mmap_read_unlock(mm);
> +       }
> +end:
> +       if (cc->is_khugepaged && result =3D=3D SCAN_SUCCEED)
> +               ++khugepaged_pages_collapsed;
> +       return result;
> +}
> +
>  static void collapse_scan_mm_slot(unsigned int progress_max,
>                 enum scan_result *result, struct collapse_control *cc)
>         __releases(&khugepaged_mm_lock)
> @@ -2481,46 +2542,21 @@ static void collapse_scan_mm_slot(unsigned int pr=
ogress_max,
>                 VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
>
>                 while (khugepaged_scan.address < hend) {
> -                       bool mmap_locked =3D true;
> +                       bool lock_dropped =3D false;
>
>                         cond_resched();
>                         if (unlikely(collapse_test_exit_or_disable(mm)))
>                                 goto breakouterloop;
>
> -                       VM_BUG_ON(khugepaged_scan.address < hstart ||
> +                       VM_WARN_ON_ONCE(khugepaged_scan.address < hstart =
||
>                                   khugepaged_scan.address + HPAGE_PMD_SIZ=
E >
>                                   hend);
> -                       if (!vma_is_anonymous(vma)) {
> -                               struct file *file =3D get_file(vma->vm_fi=
le);
> -                               pgoff_t pgoff =3D linear_page_index(vma,
> -                                               khugepaged_scan.address);
> -
> -                               mmap_read_unlock(mm);
> -                               mmap_locked =3D false;
> -                               *result =3D collapse_scan_file(mm,
> -                                       khugepaged_scan.address, file, pg=
off, cc);
> -                               fput(file);
> -                               if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPA=
GE) {
> -                                       mmap_read_lock(mm);
> -                                       if (collapse_test_exit_or_disable=
(mm))
> -                                               goto breakouterloop;
> -                                       *result =3D try_collapse_pte_mapp=
ed_thp(mm,
> -                                               khugepaged_scan.address, =
false);
> -                                       if (*result =3D=3D SCAN_PMD_MAPPE=
D)
> -                                               *result =3D SCAN_SUCCEED;
> -                                       mmap_read_unlock(mm);
> -                               }
> -                       } else {
> -                               *result =3D collapse_scan_pmd(mm, vma,
> -                                       khugepaged_scan.address, &mmap_lo=
cked, cc);
> -                       }
> -
> -                       if (*result =3D=3D SCAN_SUCCEED)
> -                               ++khugepaged_pages_collapsed;
>
> +                       *result =3D collapse_single_pmd(khugepaged_scan.a=
ddress,
> +                                                     vma, &lock_dropped,=
 cc);
>                         /* move to next address */
>                         khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> -                       if (!mmap_locked)
> +                       if (lock_dropped)
>                                 /*
>                                  * We released mmap_lock so break loop.  =
Note
>                                  * that we drop mmap_lock before all huge=
page
> @@ -2795,7 +2831,7 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>         unsigned long hstart, hend, addr;
>         enum scan_result last_fail =3D SCAN_FAIL;
>         int thps =3D 0;
> -       bool mmap_locked =3D true;
> +       bool mmap_unlocked =3D false;
>
>         BUG_ON(vma->vm_start > start);
>         BUG_ON(vma->vm_end < end);
> @@ -2817,13 +2853,12 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
>
>         for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
>                 enum scan_result result =3D SCAN_FAIL;
> -               bool triggered_wb =3D false;
>
> -retry:
> -               if (!mmap_locked) {
> +               if (mmap_unlocked) {
>                         cond_resched();
>                         mmap_read_lock(mm);
> -                       mmap_locked =3D true;
> +                       mmap_unlocked =3D false;
> +                       *lock_dropped =3D true;
>                         result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
>                                                          cc);
>                         if (result  !=3D SCAN_SUCCEED) {
> @@ -2833,45 +2868,14 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
>
>                         hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
>                 }
> -               mmap_assert_locked(mm);
> -               if (!vma_is_anonymous(vma)) {
> -                       struct file *file =3D get_file(vma->vm_file);
> -                       pgoff_t pgoff =3D linear_page_index(vma, addr);
>
> -                       mmap_read_unlock(mm);
> -                       mmap_locked =3D false;
> -                       *lock_dropped =3D true;
> -                       result =3D collapse_scan_file(mm, addr, file, pgo=
ff, cc);
> -
> -                       if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK &&=
 !triggered_wb &&
> -                           mapping_can_writeback(file->f_mapping)) {
> -                               loff_t lstart =3D (loff_t)pgoff << PAGE_S=
HIFT;
> -                               loff_t lend =3D lstart + HPAGE_PMD_SIZE -=
 1;
> +               result =3D collapse_single_pmd(addr, vma, &mmap_unlocked,=
 cc);
>
> -                               filemap_write_and_wait_range(file->f_mapp=
ing, lstart, lend);
> -                               triggered_wb =3D true;
> -                               fput(file);
> -                               goto retry;
> -                       }
> -                       fput(file);
> -               } else {
> -                       result =3D collapse_scan_pmd(mm, vma, addr, &mmap=
_locked, cc);
> -               }
> -               if (!mmap_locked)
> -                       *lock_dropped =3D true;
> -
> -handle_result:
>                 switch (result) {
>                 case SCAN_SUCCEED:
>                 case SCAN_PMD_MAPPED:
>                         ++thps;
>                         break;
> -               case SCAN_PTE_MAPPED_HUGEPAGE:
> -                       BUG_ON(mmap_locked);
> -                       mmap_read_lock(mm);
> -                       result =3D try_collapse_pte_mapped_thp(mm, addr, =
true);
> -                       mmap_read_unlock(mm);
> -                       goto handle_result;
>                 /* Whitelisted set of results where continuing OK */
>                 case SCAN_NO_PTE_TABLE:
>                 case SCAN_PTE_NON_PRESENT:
> @@ -2894,8 +2898,10 @@ int madvise_collapse(struct vm_area_struct *vma, u=
nsigned long start,
>
>  out_maybelock:
>         /* Caller expects us to hold mmap_lock on return */
> -       if (!mmap_locked)
> +       if (mmap_unlocked) {
> +               *lock_dropped =3D false;

Lorenzo, is this correct? At first glance, shouldn't this be
`locked_dropped =3D true`?

-- Nico

>                 mmap_read_lock(mm);
> +       }
>  out_nolock:
>         mmap_assert_locked(mm);
>         mmdrop(mm);
> --
> 2.43.0
>
>
> --
> Cheers,
>
> David
>


