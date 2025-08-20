Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D8B4CA0EE4
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 16:36:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5C7B8E0003; Wed, 20 Aug 2025 12:36:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0D006B011F; Wed, 20 Aug 2025 12:36:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D48E8E0003; Wed, 20 Aug 2025 12:36:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 864636B011D
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 12:36:33 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 337181DD9A4
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:36:33 +0000 (UTC)
X-FDA: 83797689066.13.296B549
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf14.hostedemail.com (Postfix) with ESMTP id F25AF100007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 16:36:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hBlKRJvS;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755707791;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RvtlwWUqesIYENKIJjSR0UkLBe3hTSdGUFezNYbbvkY=;
	b=sqFb27Kzkf+h298IQLY+EasmrYeyyvvlrRGUBfuSWeUcI4aHUOLHtGSs7yZ4F/RO0gWao/
	r86UfsGXPPKlOGIwV8IAIr3sh42fgm+RAWN06Lr9E0T2TQ+7leRITL5VLcMcQwLOfK5Ai1
	QTXO8sgg+HmJTEcDKBlmMX9No4507WE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=hBlKRJvS;
	spf=pass (imf14.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755707791; a=rsa-sha256;
	cv=none;
	b=s+9XYX9BjxxzlzC7gYBhkmWIH5nRyCgqaOqiKTqD6EGeArVV+J3WpFRKageq61KfMksKVK
	BaWDuVwyjakB9lgjb45GDZiEvd1WLs+HYDnOR2eTHXUmknHLHZspMfBXM782tR2zOuvZ60
	IB1LJZoCsfrBY8R0glaqgjP6dknnWvs=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755707790;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RvtlwWUqesIYENKIJjSR0UkLBe3hTSdGUFezNYbbvkY=;
	b=hBlKRJvSPkJYzyggan/mj8184VofEA7StHs1O1Dd0qSMqH2FkaO7JpQ64xROGoMa5S2ODk
	2lWV2u9U6TPdbKLDxOAagnFoswJIYQk1ZAtQRNXDbrVBrayva5qfpoIxzI168jJOAtlw65
	zwjStre1Zg8+MoCzWrdCV9XA7PH+7JE=
Received: from mail-yw1-f199.google.com (mail-yw1-f199.google.com
 [209.85.128.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-240-QWgMKz3cMxmKM7f39BGbqg-1; Wed, 20 Aug 2025 12:36:27 -0400
X-MC-Unique: QWgMKz3cMxmKM7f39BGbqg-1
X-Mimecast-MFC-AGG-ID: QWgMKz3cMxmKM7f39BGbqg_1755707786
Received: by mail-yw1-f199.google.com with SMTP id 00721157ae682-71d603b2fa1so288077b3.1
        for <linux-mm@kvack.org>; Wed, 20 Aug 2025 09:36:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755707786; x=1756312586;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RvtlwWUqesIYENKIJjSR0UkLBe3hTSdGUFezNYbbvkY=;
        b=aXo+5s38+sW1L4a0K4iJu29whY0uBTiXps1/Do6RgcuLqKJEX4fl5LF6SXMbV1Z8LF
         cAuEdqmBvMK5zIE3DLj0qUHCoAZUKNhdnH4HFNZdofe3T9Ovz3fUUaZhTdnpRDvaz8bL
         R9MWce8HizOiewTApsl7TM95g3kDy9yvq7UoCDfohDoyxHcCT4Jv2adbBBBA1Ww3i78T
         6+q7HHIv1PLFvmjG/kYRYe6k7AJyoLXI0IpRvC0SVxNUYU5hcag3mNcm6hTiA4CAxGac
         x1DzGecwZTHNOT3HqZEFjTjlbEgJf+yFiyVHzAcyrI90uRW0Q3WlNyXPCwKLYvo1fNBi
         s/9A==
X-Gm-Message-State: AOJu0Yy9STjuKJxbTupocWQKQJBSL6RFLhym77/qNnxYp91cBRkl2+Yu
	6UuYMjETeDU9Tu9gddM75N50+yaSADkzhqWeGxzhdb7fhT3AuQthGkja4b6pdY/dziWkHXCBxKS
	XehH582Q3opD7uwEFn06+xWE+7xV+5EpsUNkhrSFEdpbBGoFjLOmHbWvEyXlPjRVJmoHW0NPsBb
	eNSmfp/QltkEUsnPjZ4twMDhNYBLI=
X-Gm-Gg: ASbGnctEqexpzzl2eXn+XPS/HYE4+yi6HsTfsoL9SfHIz57muoABjLCCSR+dVbPp3MW
	bOZQip4QlJ0vCC6JVoYLB4Obd6ltxIFAERiQiA8EdjKRjsEfwQ5FfHW7nmhY4u3N4h/CK9t60MR
	Ahcfs1FvAOiUy/kdkD2ZU+Qy8=
X-Received: by 2002:a05:6902:124c:b0:e94:ffef:f759 with SMTP id 3f1490d57ef6-e94ffeffb71mr1803803276.0.1755707786348;
        Wed, 20 Aug 2025 09:36:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG4HcRCJqL9vTQ/7ox3BvjpkrAei2D0oMgx2P0qN9HBDbCGUlv1atq6zFqXMh5NOKuFN79QdAgvfzzh1V38bA8=
X-Received: by 2002:a05:6902:124c:b0:e94:ffef:f759 with SMTP id
 3f1490d57ef6-e94ffeffb71mr1803742276.0.1755707785709; Wed, 20 Aug 2025
 09:36:25 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <20250819134205.622806-3-npache@redhat.com>
 <248d57e5-8cd5-408b-a6c8-970df6876b6c@lucifer.local>
In-Reply-To: <248d57e5-8cd5-408b-a6c8-970df6876b6c@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Wed, 20 Aug 2025 10:35:57 -0600
X-Gm-Features: Ac12FXzjf4Igr1tHl9lliKUKtFV236tYdnecnsgkQbabWzhsGT93TnmDGE_Rezk
Message-ID: <CAA1CXcC-7MudjF06JaJQUvKkNh4vPHTTeoMDBE-devotyFXjkA@mail.gmail.com>
Subject: Re: [PATCH v10 02/13] introduce collapse_single_pmd to unify
 khugepaged and madvise_collapse
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com, 
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org, baohua@kernel.org, 
	willy@infradead.org, peterx@redhat.com, wangkefeng.wang@huawei.com, 
	usamaarif642@gmail.com, sunnanyong@huawei.com, vishal.moola@gmail.com, 
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com, 
	kirill.shutemov@linux.intel.com, aarcange@redhat.com, raquini@redhat.com, 
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de, 
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz, cl@gentwo.org, 
	jglisse@google.com, surenb@google.com, zokeefe@google.com, hannes@cmpxchg.org, 
	rientjes@google.com, mhocko@suse.com, rdunlap@infradead.org, hughd@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: MxDFEInDJW7bE0kaab2prtB0tpbI-ZANtTiZNXUyiKQ_1755707786
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 8tfrr1gj97jej7jpcjzzd9hx3jfjeoso
X-Rspam-User: 
X-Rspamd-Queue-Id: F25AF100007
X-Rspamd-Server: rspam01
X-HE-Tag: 1755707790-351193
X-HE-Meta: U2FsdGVkX18Ax03yR8C0AqzuxjkeI+YydxFr8OBXJH44SUItrRe++9YiIp/Eq4SPJcsFgoizFfjD3PzRvnzwtcBBO7UQ0OtxQ5mOhvcE+Ahr5tF0p8zPyUdygTGOlrioN3Ll3+a1fGzmPcduJoZYRYz4E7G3bn2VeQBDi2D74erQ3v528l/ZI7GTKgF1FWQSghLIHjJKJPt/u7UfIQhKo9CSgYVrCG8YSH3PE8SD3nIFfnuS+wpgw0TG5Y5nLdsVBO4SLdgLIPRCsHnch62oINDfvzZG6MhNiXRhgP7atYntxMAkfs2tQxshhQ6sfdR/Y2feQMuY+AkO24FgbHoqIlVMk8BESBZULUGAxJYTFVuks3Lh2+OX2gIqN9hqSTFgIHnz5z9QPaHkAdV518n5rvGLvLGvspr5qwqb3qXiFHP3zDAwf4XtWnWuR/sOwuRDlOMhjCH+6K/3qEj7aaT2pQ5a68AAgdIIiUetk4Q8DGU1kS4OEVgV8Caj8Cus0Z5VHTXy1l+y/2/QUPgLgLgyUBOHgtMERa450oZMUG/QBwVOZJyvEoOKT1P88WSRogxjcW30dq04vPKstbw3UI9OTRUCuEi8Er4u0hqQO8O9CJek1KnPLw9qx9tkt5vZlYyBEVrG8c9X9kMpqs9bivwh1T1v48W0IVyR0Aj+BBa4yQKti2cTOM/hVziITV0Y7L/b+emcSjnS9Vuz3C1uqPQ1AGtOSS6+qmuADayhDEG8fRv/9ZFV+bnxsg9Z3jG6lMV3+WAGDPYfQAHLFdGnQugogiXLLyJTBPy6l81cQ5VRXTtffN2TU+wiZxzOvZZUwRdVOCkUJMisd1TN6w5h38Vp1QJ2oFxp6ygskZ5FxPaqF0dr4Cn1oGEc0V62b1j7dNBNFkpkI8hwJbdywa8wuqrdv1fmUxXg66xFxN1IVeiMqRF3rPSuHyINp99cMO9K8XVEnCY7BIIP59bUc/PA8tE
 hk7AiBGy
 GChVyDVg4y0tafgSt3rLI+BJB/gEoP2H0Hene86eGA2i44lU47ipwbp6BXKVfptP7UNytZVaHs98teqgObuydb2MbaonfskoGwcI9DsC0Q+/34Ht2y1IG64QQEERj/vuHEdh7UKmuffp3lF0VXSyYQInRSTcQGGoSAB/b4nn0vBOt5eJ9V/kqjTyDHKloLyHUkY+IXmg7/QGEOBuQHzFrpklVgSzLcIxCQ6LOD1UyoZSbqE3fJcmuJ/6YSo74DolqIWOYhvVidHZ5Xw8BKXsn9AKI584Kk1mZc8e6JSyG+SgLM5Q/vai53R94ADbmKYbKL+UXKhrAF8rMZHqvQ+0PqoUXX+4hfoLWXRNhYBtY4Do0yqatuFvePHReLHuN5qXTpb7rEeKShDPscTtQS3uvyQv09UGEsK0qeMiJvzx9Wi2Yfo9VqSSjCqEV56v0lzCfRyQot2yicebGm6EVe/KtafBGyQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 20, 2025 at 5:22=E2=80=AFAM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Tue, Aug 19, 2025 at 07:41:54AM -0600, Nico Pache wrote:
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
> > this check.
> >
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Acked-by: David Hildenbrand <david@redhat.com>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 94 ++++++++++++++++++++++++++-----------------------
> >  1 file changed, 49 insertions(+), 45 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 0e7bbadf03ee..b7b98aebb670 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2382,6 +2382,50 @@ static int collapse_scan_file(struct mm_struct *=
mm, unsigned long addr,
> >       return result;
> >  }
> >
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and re=
turn
> > + * the results.
> > + */
> > +static int collapse_single_pmd(unsigned long addr,
> > +                             struct vm_area_struct *vma, bool *mmap_lo=
cked,
> > +                             struct collapse_control *cc)
> > +{
> > +     int result =3D SCAN_FAIL;
>
> You assign result in all branches, so this can be uninitialised.
ack, thanks.
>
> > +     struct mm_struct *mm =3D vma->vm_mm;
> > +
> > +     if (!vma_is_anonymous(vma)) {
> > +             struct file *file =3D get_file(vma->vm_file);
> > +             pgoff_t pgoff =3D linear_page_index(vma, addr);
> > +
> > +             mmap_read_unlock(mm);
> > +             *mmap_locked =3D false;
> > +             result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
> > +             fput(file);
> > +             if (result =3D=3D SCAN_PTE_MAPPED_HUGEPAGE) {
> > +                     mmap_read_lock(mm);
> > +                     *mmap_locked =3D true;
> > +                     if (collapse_test_exit_or_disable(mm)) {
> > +                             mmap_read_unlock(mm);
> > +                             *mmap_locked =3D false;
> > +                             result =3D SCAN_ANY_PROCESS;
> > +                             goto end;
>
> Don't love that in e.g. collapse_scan_mm_slot() we are using the mmap loc=
k being
> disabled as in effect an error code.
>
> Is SCAN_ANY_PROCESS correct here? Because in collapse_scan_mm_slot() you'=
d
> previously:
https://lore.kernel.org/lkml/a881ed65-351a-469f-b625-a3066d0f1d5c@linux.ali=
baba.com/
Baolin brought up a good point a while back that if
collapse_test_exit_or_disable returns true we will be breaking out of
the loop and should change the return value to indicate this. So to
combine the madvise breakout and the scan_slot breakout we drop the
lock and return SCAN_ANY_PROCESS.
>
>         if (*result =3D=3D SCAN_PTE_MAPPED_HUGEPAGE) {
>                 mmap_read_lock(mm);
>                 if (collapse_test_exit_or_disable(mm))
>                         goto breakouterloop;
>                 ...
>         }
>
> But now you're setting result =3D SCAN_ANY_PROCESS rather than
> SCAN_PTE_MAPPED_HUGEPAGE in this instance?
>
> You don't mention that you're changing this, or at least explicitly enoug=
h,
> the commit message should state that you're changing this and explain why
> it's ok.
I do state it but perhaps I need to be more verbose! I will update the
message to state we are also changing the result value too.
>
> This whole file is horrid, and it's kinda an aside, but I really wish we
> had some comment going through each of the scan_result cases and explaini=
ng
> what each one meant.
Yeah its been a huge pain to have to investigate what everything is
supposed to mean, and I often have to go searching to confirm things.
include/trace/events/huge_memory.h has a "good" summary of them
>
> Also I think:
>
>         return SCAN_ANY_PROCESS;
>
> Is better than:
>
>         result =3D SCAN_ANY_PROCESS;
>         goto end;
I agree! I will change that :)
>         ...
> end:
>         return result;
>
> > +                     }
> > +                     result =3D collapse_pte_mapped_thp(mm, addr,
> > +                                                      !cc->is_khugepag=
ed);
>
> Hm another change here, in the original code in collapse_scan_mm_slot()
> this is:
>
>         *result =3D collapse_pte_mapped_thp(mm,
>                 khugepaged_scan.address, false);
>
> Presumably collapse_scan_mm_slot() is only ever invoked with
> cc->is_khugepaged?
Correct, but the madvise_collapse calls this with true, hence why it
now depends on the is_khugepaged variable. No functional change here.
>
> Maybe worth adding a VM_WARN_ON_ONCE(!cc->is_khugepaged) at the top of
> collapse_scan_mm_slot() to assert this (and other places where your chang=
e
> assumes this to be the case).
Ok I will investigate doing that but it would take a huge mistake to
hit that assertion.
>
>
> > +                     if (result =3D=3D SCAN_PMD_MAPPED)
> > +                             result =3D SCAN_SUCCEED;
> > +                     mmap_read_unlock(mm);
> > +                     *mmap_locked =3D false;
> > +             }
> > +     } else {
> > +             result =3D collapse_scan_pmd(mm, vma, addr, mmap_locked, =
cc);
> > +     }
> > +     if (cc->is_khugepaged && result =3D=3D SCAN_SUCCEED)
> > +             ++khugepaged_pages_collapsed;
>
> Similarly, presumably because collapse_scan_mm_slot() only ever invoked
> khugepaged case this didn't have the cc->is_khugepaged check?
Correct, we only increment this when its khugepaged, so we need to
guard it so madvise collapse wont increment this.
>
> > +end:
> > +     return result;
> > +}
>
> There's a LOT of nesting going on here, I think we can simplify this a
> lot. If we make the change I noted above re: returning SCAN_ANY_PROCESS< =
we
> can move the end label up a bit and avoid a ton of nesting, e.g.:
Ah I like this much more, I will try to implement/test it.
>
> static int collapse_single_pmd(unsigned long addr,
>                                 struct vm_area_struct *vma, bool *mmap_lo=
cked,
>                                 struct collapse_control *cc)
> {
>         struct mm_struct *mm =3D vma->vm_mm;
>         struct file *file;
>         pgoff_t pgoff;
>         int result;
>
>         if (vma_is_anonymous(vma)) {
>                 result =3D collapse_scan_pmd(mm, vma, addr, mmap_locked, =
cc);
>                 goto end:
>         }
>
>         file =3D get_file(vma->vm_file);
>         pgoff =3D linear_page_index(vma, addr);
>
>         mmap_read_unlock(mm);
>         *mmap_locked =3D false;
>         result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
>         fput(file);
>         if (result !=3D SCAN_PTE_MAPPED_HUGEPAGE)
>                 goto end;
>
>         mmap_read_lock(mm);
>         *mmap_locked =3D true;
>         if (collapse_test_exit_or_disable(mm)) {
>                 mmap_read_unlock(mm);
>                 *mmap_locked =3D false;
>                 return SCAN_ANY_PROCESS;
>         }
>         result =3D collapse_pte_mapped_thp(mm, addr, !cc->is_khugepaged);
>         if (result =3D=3D SCAN_PMD_MAPPED)
>                 result =3D SCAN_SUCCEED;
>         mmap_read_unlock(mm);
>         *mmap_locked =3D false;
>
> end:
>         if (cc->is_khugepaged && result =3D=3D SCAN_SUCCEED)
>                 ++khugepaged_pages_collapsed;
>
>         return result;
> }
>
> (untested, thrown together so do double check!)
>
> > +
> >  static unsigned int collapse_scan_mm_slot(unsigned int pages, int *res=
ult,
> >                                           struct collapse_control *cc)
> >       __releases(&khugepaged_mm_lock)
> > @@ -2455,34 +2499,9 @@ static unsigned int collapse_scan_mm_slot(unsign=
ed int pages, int *result,
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
> > -                                     *result =3D collapse_pte_mapped_t=
hp(mm,
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
> > +                                                     vma, &mmap_locked=
, cc);
> >                       /* move to next address */
> >                       khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> >                       progress +=3D HPAGE_PMD_NR;
> > @@ -2799,34 +2818,19 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >               mmap_assert_locked(mm);
> >               memset(cc->node_load, 0, sizeof(cc->node_load));
> >               nodes_clear(cc->alloc_nmask);
> > -             if (!vma_is_anonymous(vma)) {
> > -                     struct file *file =3D get_file(vma->vm_file);
> > -                     pgoff_t pgoff =3D linear_page_index(vma, addr);
> >
> > -                     mmap_read_unlock(mm);
> > -                     mmap_locked =3D false;
> > -                     result =3D collapse_scan_file(mm, addr, file, pgo=
ff, cc);
> > -                     fput(file);
> > -             } else {
> > -                     result =3D collapse_scan_pmd(mm, vma, addr,
> > -                                                &mmap_locked, cc);
> > -             }
> > +             result =3D collapse_single_pmd(addr, vma, &mmap_locked, c=
c);
> > +
>
> Ack the fact you noted the behaviour change re:
> collapse_test_exit_or_disable() that seems fine.
>
> >               if (!mmap_locked)
> >                       *lock_dropped =3D true;
> >
> > -handle_result:
> >               switch (result) {
> >               case SCAN_SUCCEED:
> >               case SCAN_PMD_MAPPED:
> >                       ++thps;
> >                       break;
> > -             case SCAN_PTE_MAPPED_HUGEPAGE:
> > -                     BUG_ON(mmap_locked);
> > -                     mmap_read_lock(mm);
> > -                     result =3D collapse_pte_mapped_thp(mm, addr, true=
);
> > -                     mmap_read_unlock(mm);
> > -                     goto handle_result;
>
> One thing that differs with new code her is we filter SCAN_PMD_MAPPED to
> SCAN_SUCCEED.
>
> I was about to say 'but ++thps - is this correct' but now I realise this
> was looping back on itself with a goto to do just that... ugh ye gads.
>
> Anwyay that's fine because it doesn't change anything.
>
> Re: switch statement in general, again would be good to always have each
> scan possibility in switch statements, but perhaps given so many not
> practical :)

Yeah it may be worth investigating for future changes I have for
khugepaged (including the new switch statement I implement later and
you commented on)
>
> (that way the compiler warns on missing a newly added enum val)
>
> >               /* Whitelisted set of results where continuing OK */
> > +             case SCAN_PTE_MAPPED_HUGEPAGE:
> >               case SCAN_PMD_NULL:
> >               case SCAN_PTE_NON_PRESENT:
> >               case SCAN_PTE_UFFD_WP:
> > --

Thanks for the review :)

-- Nico
> > 2.50.1
> >
>


