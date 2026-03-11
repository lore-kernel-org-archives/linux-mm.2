Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A969F1125811
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 18:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E45076B0005; Wed, 11 Mar 2026 14:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF3046B0089; Wed, 11 Mar 2026 14:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CD4AA6B008A; Wed, 11 Mar 2026 14:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBBA96B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 14:26:45 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5B5D51A02FA
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:26:45 +0000 (UTC)
X-FDA: 84534613170.24.5422B6B
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0967FA0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 18:26:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L7aK8dvz;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773253603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cA/5NiyxGANTp+jCdyTXRXJVu1z/OE+VsjDyHk/d50U=;
	b=olqQ+yWfKvOOhMpySsNr1cx7D95R/CYH0fAcFXhjveqABCCztuO0uX9fXCB7d1Rh5nBRIY
	NUOBoViua7be3AsOxeRpR+jiN2CguCqm5kHDZXNYFTdwPpn0s19ZLLX4OT7ovfVVySRL1U
	R4b+GDNxgV4SRHxDQ5dAJNoqiolNb2Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773253603; a=rsa-sha256;
	cv=none;
	b=UiSGkiLhoTIZDJlvrl8cJsyRFghGKFInnRtIrkn+AYEOSWkgwC28ZHXbg8Yahhy8K0BP/y
	RNOdvSc/k9ZSIri+C16NpNKmatQ6uCHzZ+l88YXh1w30LYsw3rVmC+MCWPkjFwqZYYV/7X
	8ysTMw3pDkICwF12Lnnx50qQHUUMs5g=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=L7aK8dvz;
	spf=pass (imf15.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773253602;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cA/5NiyxGANTp+jCdyTXRXJVu1z/OE+VsjDyHk/d50U=;
	b=L7aK8dvzwWp65v04YMcrk3XssuVeyEn/+ttDzbc4ChqtWv0sh8OkvwytGdiDrjJeogfykF
	gwzSzRRwescpcjJ6wKDYabU9cJv7c7Z+IxvbuN0gOGblfZGTDW/TnHb8+vMfLTqAQCOOnF
	Z5fzUkfhpOO/0k7WWrfqhfgis6CAes0=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-614-zkYerqBpMG24zEaY9XQ2_g-1; Wed, 11 Mar 2026 14:26:41 -0400
X-MC-Unique: zkYerqBpMG24zEaY9XQ2_g-1
X-Mimecast-MFC-AGG-ID: zkYerqBpMG24zEaY9XQ2_g_1773253601
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64ad0c50067so606360d50.1
        for <linux-mm@kvack.org>; Wed, 11 Mar 2026 11:26:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773253600; x=1773858400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cA/5NiyxGANTp+jCdyTXRXJVu1z/OE+VsjDyHk/d50U=;
        b=QJG2UjBF26MhLkNSvmMLKmsozJfqV049Zl3piTovlh5cdBXKwzRY3s+rWIF5DYnbtx
         8VxPcg6fUdwegKOyqemETZwbkhaKbuX5SvOpGAZV7byyBLoXHd0Fa7Riu1s5HePLN/NM
         xQlGfIPwb5rrJraS5l9/nejkifxDJvqJsr9KJCZq5+xQQQoxaTvzkAgPUaRkLO1Pj30i
         L/52LhGaTi91Wyj/k/BB8vhBqhvPCoMMdE2gAaDDes0kkYSUVcy+9mVBLk0wPnMd+ZTc
         3vugT+i/7oUCgDerUjh+aroPwAl7V4Lzn8+NMDA4xJszLWOOO/l07EKooZ1N2Tw5hqlj
         RUiQ==
X-Forwarded-Encrypted: i=1; AJvYcCU5ZMzYINTb2FGk+In0zUxmP50AylzJZ6hpyljPWu9aQ7qKnQEf6uMkQzPvguxDjZwP6EHDBrSoFg==@kvack.org
X-Gm-Message-State: AOJu0YwZWsqQcbB7+in7B2FcKULEwKUJVmshrMNyXGeOGT4QRnHfbMWT
	uI6ozrnt2jBpA8KVTxW4ToNsM+yBG/SAvqWHQBcllPeBkCfpo9D1i7AkPLxd+p1H5TSVsmX8bm/
	e8bnjXZbCmtHNfvXhRW8GbITUvk+7VdFrfk2N1KFjJpbY13bNR11InjxGo14oY+oAdMPTXFjmtl
	AAU3yNYbBHm5OxloUMlnolbb5ABcs=
X-Gm-Gg: ATEYQzyEx81FIQQx0hUtNYa2BBobG7iBuKejyVRm56MfL4i3cJR27txyfvMMrYlDOtm
	GEANSm6eLAAvam/236qzbLNVIbLgzNyDK4GLzSok1lXLYTNm6u1TRbxTAH1D30M0isnuLgPCUwB
	d6phWlRUOSiQ3OSKEfUgR1NHp6iHZDYQESbcQS8BDcHoPBLIL7pg9BIUKdnnSFqtY7iETNzTIQQ
	CbK
X-Received: by 2002:a53:be04:0:b0:649:c880:1bd5 with SMTP id 956f58d0204a3-64d657fc246mr2459298d50.62.1773253600591;
        Wed, 11 Mar 2026 11:26:40 -0700 (PDT)
X-Received: by 2002:a53:be04:0:b0:649:c880:1bd5 with SMTP id
 956f58d0204a3-64d657fc246mr2459233d50.62.1773253600052; Wed, 11 Mar 2026
 11:26:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260226012929.169479-1-npache@redhat.com> <20260226012929.169479-6-npache@redhat.com>
 <60e44957-b816-4f7e-b004-4e957a67fe12@linux.alibaba.com> <CAA1CXcBD6paPH30_Tcsa5mvFxRQetZhAAh+3kX99zbN8KYXrSw@mail.gmail.com>
In-Reply-To: <CAA1CXcBD6paPH30_Tcsa5mvFxRQetZhAAh+3kX99zbN8KYXrSw@mail.gmail.com>
From: Nico Pache <npache@redhat.com>
Date: Wed, 11 Mar 2026 12:26:12 -0600
X-Gm-Features: AaiRm51HWjNv0Grje3nluuJvExKxB-S9sIBoHalLhTXufY-kLDWOiYDk1QmWjt0
Message-ID: <CAA1CXcCzOQmH1-L=TJKEG6Aiuj9kHBTu-V02s2rtUnyrAeE+kQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, byungchul@sk.com, catalin.marinas@arm.com, cl@gentwo.org, 
	corbet@lwn.net, dave.hansen@linux.intel.com, david@kernel.org, 
	dev.jain@arm.com, gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, 
	jackmanb@google.com, jack@suse.cz, jannh@google.com, jglisse@google.com, 
	joshua.hahnjy@gmail.com, kas@kernel.org, lance.yang@linux.dev, 
	Liam.Howlett@oracle.com, lorenzo.stoakes@oracle.com, 
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
X-Mimecast-MFC-PROC-ID: uC1_gQcf48AqpyV-vOpM-WFlr7hwjPQdqNGgiFHxqVQ_1773253601
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 87dzcpx6k79tpjdx1ni9ijxx7bwo6pr5
X-Rspamd-Queue-Id: 0967FA0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1773253602-870711
X-HE-Meta: U2FsdGVkX1+106KZrld/AaBjW4Gfi8yk2Vf4qwQpnMIx4S1XzVmwLQWgrZK+0MK3Sb0CZKIX+KH1xxUV92qW08mepKkA5lLmFVt2k3Q90yHlmHKUf3u904yzQ7u2nrGcd9Veny6XPlteqw1SfC7taFYX9ljliaHW7Tug1OVo5zX74ikiGSVNrskMGbkzWdFb8JA2ahpYqZ1QvgiqP5SfDXkYjJOOqkfnsd4aUVg61NEVjpLZ/8FqcQvVLS4Z4pOwxjb6/JQ+dxo8FPc8evUqhWsD03E9mL+NRXO1mCE8E3KDBrVWZDoNHC2+zkkwttaFB4RxnjIexpCsmKG4T1iWL65FLnGCROeCKIWKBm2vTBwvkaWtvPbX3AglTcXQsFcZsAdq5I88fwPHckxlF3uPMX/s//PMaqcPWLcA6AhniL1zaXJ7+QJHv+Qd5GXMycY2ptNvfd0W/83G55tYLwxyYZtiF7w72+UmtweGwF7lsaS2u9jibZMUntHnJuLEAMHeFXwA+msY3Ji34LfJMfhh0PsH6XVK3cCpsQXg/JCICbCFhfzO7/GbTrPFGCxourxhDvprcjdaCkBr++SRvBSLlaxRpz/wRO8jJmTzX1V1xzFqSWoWeZoTI7u641tZ2SeLWnrYWvdGu0muYziSuCRBdMhg+tM5LccuA7S1BCV3kiwo2ZaNHt5Q9Ocy1db3wu0ndpo2UTQFQ8LfrCP7snvFC8QYNYbZR7KoGwGyDmQvoHKxR/5OBMUojgYuyXHeySu5UdIvbzJGX0iZAWz4pGioMBr6N1Equu8Bd8TedvfFlCMkd8OJjT/cVe8hFE2G30rz6VWAv02fZCK12J6k/Mt5POIo0q8jqW/zKimCiIC6k+lvmcg2atd9OFbXn/DEpq4IvLbdEPVfsKFKzbEG5hBaP+iPnLQWmkoOHBuLCQsOcR/h9s0wWYDvJOfkyONZA4n2OHtNTwbu6+jYhkSabnl
 +OqKFTWN
 IBb9Ze6yyMhR4BCB3TfmitPxOOdLVYQ81hp1AAHsNlOVCF9TD0F8FXxObN0cGlufOoHBDPAvm2rbj3EXveV7G+VEGVVvuRab1cWiCTPe2/isLzSkTpeWSXFjiC1EZdYASlDRzEjQ2M9w8mvG8wDTxJHLXUEO6Fow/MtM/mIR06VZYnV2sj9x+JFyVg5HsaeX0kIwZKUB+O+gHyikngHb2pnbImLv5FXHq4hIBgt+31gpWkD+qzztnGE7CmbO8hqfqQCt9Q/tFzC1VUyhd9d+Z8l7rfS0dP4+nll5SrJVdA/3NLshAYgnEvNWHrFTf+NbRofudgvqtZhNfy6NVwPSpfpgJy2LkDFsoM5P+De6/6pQxxDDvxj0WKd0iBi9NzpBlfVPL1msYC7anufQ6RlNEkKqrjyR8s3/79DiIrC1BiB4nFf/bveCuFy2Ey3YHvq56shurlDeL6uVTkrUniv4uUKh0iY8iwKFJagHe/CgUqhAjmOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 1:20=E2=80=AFPM Nico Pache <npache@redhat.com> wrot=
e:
>
> On Thu, Feb 26, 2026 at 2:24=E2=80=AFAM Baolin Wang
> <baolin.wang@linux.alibaba.com> wrote:
> >
> >
> >
> > On 2/26/26 9:29 AM, Nico Pache wrote:
> > > The khugepaged daemon and madvise_collapse have two different
> > > implementations that do almost the same thing.
> > >
> > > Create collapse_single_pmd to increase code reuse and create an entry
> > > point to these two users.
> > >
> > > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > > collapse_single_pmd function. This introduces a minor behavioral chan=
ge
> > > that is most likely an undiscovered bug. The current implementation o=
f
> > > khugepaged tests collapse_test_exit_or_disable before calling
> > > collapse_pte_mapped_thp, but we weren't doing it in the madvise_colla=
pse
> > > case. By unifying these two callers madvise_collapse now also perform=
s
> > > this check. We also modify the return value to be SCAN_ANY_PROCESS wh=
ich
> > > properly indicates that this process is no longer valid to operate on=
.
> > >
> > > We also guard the khugepaged_pages_collapsed variable to ensure its o=
nly
> > > incremented for khugepaged.
> > >
> > > Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > Signed-off-by: Nico Pache <npache@redhat.com>
> > > ---
> >
> > [snip]
> >
> > >       for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
> > >               enum scan_result result =3D SCAN_FAIL;
> > > -             bool triggered_wb =3D false;
> > >
> > > -retry:
> > >               if (!mmap_locked) {
> > >                       cond_resched();
> > >                       mmap_read_lock(mm);
> > >                       mmap_locked =3D true;
> > > +                     *lock_dropped =3D true;
> > IIUC, this should be '*lock_dropped =3D false', right?
>
> Yes! Thanks for catching that :) As David and others have pointed out,
> this lock handling here might be unnecessary and better placed in
> collapse_single_pmd(). I meant to look into that before posting this
> but it slipped my mind.

On second pass, no, I think we should drop this line altogether. If
(!mmap_locked) -> we have either just completed a collapse, or we
tried file collapse on a 2MB region. Collapse_single_pmd would report
this, and we would have already set lock_dropped.

>
> >
> > >                       result =3D hugepage_vma_revalidate(mm, addr, fa=
lse, &vma,
> > >                                                        cc);
> > >                       if (result  !=3D SCAN_SUCCEED) {
> > > @@ -2836,46 +2872,20 @@ int madvise_collapse(struct vm_area_struct *v=
ma, unsigned long start,
> > >                       hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK=
);
> > >               }
> > >               mmap_assert_locked(mm);
> > > -             if (!vma_is_anonymous(vma)) {
> > > -                     struct file *file =3D get_file(vma->vm_file);
> > > -                     pgoff_t pgoff =3D linear_page_index(vma, addr);
> > > -
> > > -                     mmap_read_unlock(mm);
> > > -                     mmap_locked =3D false;
> > > -                     *lock_dropped =3D true;
> > > -                     result =3D collapse_scan_file(mm, addr, file, p=
goff, NULL, cc);
> > >
> > > -                     if (result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEBACK =
&& !triggered_wb &&
> > > -                         mapping_can_writeback(file->f_mapping)) {
> > > -                             loff_t lstart =3D (loff_t)pgoff << PAGE=
_SHIFT;
> > > -                             loff_t lend =3D lstart + HPAGE_PMD_SIZE=
 - 1;
> > > +             result =3D collapse_single_pmd(addr, vma, &mmap_locked,=
 NULL, cc);
> > >
> > > -                             filemap_write_and_wait_range(file->f_ma=
pping, lstart, lend);
> > > -                             triggered_wb =3D true;
> > > -                             fput(file);
> > > -                             goto retry;
> > > -                     }
> > > -                     fput(file);
> > > -             } else {
> > > -                     result =3D collapse_scan_pmd(mm, vma, addr, &mm=
ap_locked, NULL, cc);
> > > -             }
> > >               if (!mmap_locked)
> > >                       *lock_dropped =3D true;
> > >
> > > -handle_result:
> > >               switch (result) {
> > >               case SCAN_SUCCEED:
> > >               case SCAN_PMD_MAPPED:
> > >                       ++thps;
> > >                       break;
> > > -             case SCAN_PTE_MAPPED_HUGEPAGE:
> > > -                     BUG_ON(mmap_locked);
> > > -                     mmap_read_lock(mm);
> > > -                     result =3D try_collapse_pte_mapped_thp(mm, addr=
, true);
> > > -                     mmap_read_unlock(mm);
> > > -                     goto handle_result;
> > >               /* Whitelisted set of results where continuing OK */
> > >               case SCAN_NO_PTE_TABLE:
> > > +             case SCAN_PTE_MAPPED_HUGEPAGE:
> > >               case SCAN_PTE_NON_PRESENT:
> > >               case SCAN_PTE_UFFD_WP:
> > >               case SCAN_LACK_REFERENCED_PAGE:
> >


