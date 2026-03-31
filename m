Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6964310F92FC
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 20:00:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4CB36B0092; Tue, 31 Mar 2026 16:00:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D24FB6B0095; Tue, 31 Mar 2026 16:00:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C39DC6B0096; Tue, 31 Mar 2026 16:00:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B047F6B0092
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 16:00:13 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DBC1E075B
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:00:13 +0000 (UTC)
X-FDA: 84607424706.24.DDFA857
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6E0ED180017
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 20:00:10 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bqbQaBI3;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774987210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q8QYyqEC00JKs/o+wJ7bbwMH2gN6NJIdu1OBfyDNwLs=;
	b=2StqV0vXeRhlBIhFPy17djusYpuSe4yeAc7ZUfEidViCf/yC57VMi9fR/koOVYaKsqG/AO
	aYgQps/PeB3FFU5zW02OLn6jzJcw3RSW7iGdHmrStyGbfvwjyrxO206fGxFVCEKs7rN0Jv
	DVwtZtLT7EXbtUZ9Z1sF41/RInlrbAk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=bqbQaBI3;
	spf=pass (imf06.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774987210; a=rsa-sha256;
	cv=none;
	b=B77Qlc89BLJPMxDZhN7Hv7sLml2to+mK/nexQQH3DMSOO/tEysur8Q4qsOLhNIkrY+rF/V
	VYtsTBYZ5Q9E7WFXh89o1PKgVOuTp01Dvq40OfnuF2MIwNg0JLSUp0QYgyG/lSj8V1uLSw
	pZqUNJGUf8OwzaLDT8G5Ei1xONINAtw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774987209;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q8QYyqEC00JKs/o+wJ7bbwMH2gN6NJIdu1OBfyDNwLs=;
	b=bqbQaBI3WCx01nbauuxVI4W4Kb8F86zMD/Z9WCK9JgiY8xYOxoFWZ8DjNAsIIZ+THublKx
	k94Jv6jvkg3LX1jedeaB8vXlR2ohk9AZCz4HsbgliJuNK/UtikkE9N3ZJIYteGCcfeKvFs
	DPPgstKk11/ccmyC45kDOJO6WWs3Gfo=
Received: from mail-yx1-f71.google.com (mail-yx1-f71.google.com
 [74.125.224.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-364-9an3bZkWMCyZ6gPYboxj_g-1; Tue, 31 Mar 2026 16:00:07 -0400
X-MC-Unique: 9an3bZkWMCyZ6gPYboxj_g-1
X-Mimecast-MFC-AGG-ID: 9an3bZkWMCyZ6gPYboxj_g_1774987207
Received: by mail-yx1-f71.google.com with SMTP id 956f58d0204a3-64eb0bff77cso4352832d50.0
        for <linux-mm@kvack.org>; Tue, 31 Mar 2026 13:00:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774987207; x=1775592007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=q8QYyqEC00JKs/o+wJ7bbwMH2gN6NJIdu1OBfyDNwLs=;
        b=sLfGWDjmGYV0FhDFSbsQv6k4qpkSGCIvYbadjGFvAtzmhjFTY+GQDvbAMDALmp32dS
         zOm1m0UWMHDog0xEqaCCxVE84KVxavhD7HdhbobjA4g1bABWKO73PQ8cazU4uyiwqWSR
         HhAhOj4feMJ2w2aTnr/dLyk4xGvB30dhlLUjW8XCW04MYsNg+eJ0Kb7CTbSpwsQDU0R+
         JOg8UqnDqfy12SOBOgr5o2HYtctdGagOBc8/aAY/qeOm6hm2N6hsOC6T4svaezU19NKH
         M6aXI0/8i6FHwg5lYB+WeJ9T4hjZQ2Hl+Epv0pih3+RGzBoLAcA4jlesyJ8RETNe3jgy
         kmaA==
X-Forwarded-Encrypted: i=1; AJvYcCWjyxmg2F54Uxwumt/yp/uCstJzyTlHe8flEFyyO5tQhVdqFwPd0khMAq2Kg2i4H/wSuWgcXLWaTQ==@kvack.org
X-Gm-Message-State: AOJu0YyUjUkC/9mVMeMtLfzAkHfCgZRjVTM5YbyJqBQmvbRpAdurtdC8
	huGZOpdbaE/ziXws1i0RO5TfaXKvgS14rnn6PAU+PzJAzIlmTjNnV3GcS90X/fxrKkdO0Ex+MVQ
	DGf/A53cofArsPXGQxccZsIWIX1MVzl5HvNtiykhbCzaMR4bB/6PNCYGjR1U2CdQPJZK8McCxiF
	r6Lcx3l/EzaO/XuMRBfr18d29g3w0=
X-Gm-Gg: ATEYQzzunhbnRGcGvU9TD9KuknUqsaEDnyCeFKk8D7s9G8XnqGVBXkb7NFJbZn+uage
	r/gSYldO3MBLCT0VkpnG7/3RW2ews20f3AzWJNDXqImIL7T5F4HlnKgQhxNO0xjZHK4NyhH+28S
	Nr/tyZsl+U+MNlwoFFx5qSaEmjnYdbBobppg/eNtu5y2SXDLYtoRMf8dLygHZvFsFat15vCjZlv
	ZKERalw
X-Received: by 2002:a05:690e:144f:b0:650:11b3:3f44 with SMTP id 956f58d0204a3-6502fdc943dmr777936d50.19.1774987206659;
        Tue, 31 Mar 2026 13:00:06 -0700 (PDT)
X-Received: by 2002:a05:690e:144f:b0:650:11b3:3f44 with SMTP id
 956f58d0204a3-6502fdc943dmr777843d50.19.1774987205916; Tue, 31 Mar 2026
 13:00:05 -0700 (PDT)
MIME-Version: 1.0
References: <20260325114022.444081-1-npache@redhat.com> <20260325114022.444081-6-npache@redhat.com>
 <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
In-Reply-To: <7760c811-e100-4d40-9217-0813c28314be@lucifer.local>
From: Nico Pache <npache@redhat.com>
Date: Tue, 31 Mar 2026 13:59:44 -0600
X-Gm-Features: AQROBzCzPKEDJ3AHBLtEApFW795zbX0zXddgHqeWRRzkaU3JCO1T-QD_7NCkRq4
Message-ID: <CAA1CXcC93LYFRD3052Ca8BKG6HqnmfhmB5O3ffQzjsXX3ZsFjQ@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v4 5/5] mm/khugepaged: unify khugepaged and
 madv_collapse with collapse_single_pmd()
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, aarcange@redhat.com, 
	akpm@linux-foundation.org, anshuman.khandual@arm.com, apopple@nvidia.com, 
	baohua@kernel.org, baolin.wang@linux.alibaba.com, byungchul@sk.com, 
	catalin.marinas@arm.com, cl@gentwo.org, corbet@lwn.net, 
	dave.hansen@linux.intel.com, david@kernel.org, dev.jain@arm.com, 
	gourry@gourry.net, hannes@cmpxchg.org, hughd@google.com, jackmanb@google.com, 
	jack@suse.cz, jannh@google.com, jglisse@google.com, joshua.hahnjy@gmail.com, 
	kas@kernel.org, lance.yang@linux.dev, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, mathieu.desnoyers@efficios.com, 
	matthew.brost@intel.com, mhiramat@kernel.org, mhocko@suse.com, 
	peterx@redhat.com, pfalcato@suse.de, rakie.kim@sk.com, raquini@redhat.com, 
	rdunlap@infradead.org, richard.weiyang@gmail.com, rientjes@google.com, 
	rostedt@goodmis.org, rppt@kernel.org, ryan.roberts@arm.com, shivankg@amd.com, 
	sunnanyong@huawei.com, surenb@google.com, thomas.hellstrom@linux.intel.com, 
	tiwai@suse.de, usamaarif642@gmail.com, vbabka@suse.cz, vishal.moola@gmail.com, 
	wangkefeng.wang@huawei.com, will@kernel.org, willy@infradead.org, 
	yang@os.amperecomputing.com, ying.huang@linux.alibaba.com, ziy@nvidia.com, 
	zokeefe@google.com
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: QPamYZg1aCRv9Y34y8VCkCuLBMoNbcXNTU1waN39W0Q_1774987207
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6E0ED180017
X-Stat-Signature: j6zrc63en63qub9sdkc1mw39ggjk99x3
X-Rspam-User: 
X-HE-Tag: 1774987210-184499
X-HE-Meta: U2FsdGVkX1+1FL8mMnH0C1vGXt0cmFiP/UNlfmMda2XrCvhcZUkJArJ062P9a8RZZCcQOrC4oXmjD4iH86VceUz3OuktdSm76qbWlgpaMuWx6UivQMmrGstMAuRIEEkjh5NWWxOZP1A9KBXUfNEoInQO6SQ2oFHmqkFWHBgYDSw9YtjQOBzLNVSoJnmt6Q0MZvoWLXk5nexjbNXSU2Y9AddyYRlHS06HyX8hXh8rCtJ7U0d0Rnv5/htgNXZHjOQElRnp5tvgrNMl0o0yQVuLtNmGlfwuC1vM/zolE/mITg2P1hw4aOpw5qBzyd2vdRnIYN3mmCJcxhGliSENOVqMSD4HhkF4B9ODwLVSaZF38VJBGw13YkSeB4yNNHqJGfn4kiBm+XeNqG1fv1Xaz/vPkbHRVT++0H4JUI07fEo+CCO2sgmAssBPVyHRGdC1DI0otb//EXTK1aVLjGQQ/dQv6/jQHVVv7v3obGTtYnFXlgcR8b71XC/CNkezM3H2QV/Qq2I4d4qCNuC/vpt//34tohcp9mQko8P2SgRK+fwjLmxdjFQXgz3H0JyMQgBKAWjD1S9tOiBEVzPE9iBLDMJ7PurzbXwNOiB0xlUZw5bNzmmViIbbVtN82ameNRb69e/SpYdp9NsXsWYV+G4ZuFI2eThYTYRYstRij5aydxRL5YXkwzTvnzUotaQIE4pw7K46RoDNj/XA9gfGPfcmnEISWV7z/BfgscT+M//RpIf59/TMS8EVxSGep55vOvHBQ1Cv5u/TWQBtJUiS30HLofQMl8PcQUi0MU+FO/jv2fWxMros0ufUZitmxaTMfY0YIBnTY8hwh3KmKJZjkbaF+wyIPB+FghzKMCKx0dcv4Yw1OyjjdKB8EGWryx/KsAQpDZ740NE7LkIgwweqjrVo3Tm+Ee0Gc0nxWb//WJbMZcmFrYyKK4PZXwEWkMBZaJV8Lc+stONLENkoyuRkt39+g+8
 h1wRLUeq
 E8GyuxY/fB6y7F76zn+jZbt/YPfyZlgOC/huUfG3z/4iU+BoJLggjOnMptFYwfbSmGR0e4NVMZ+6oHwMRCr6bVgup+qkTgoj44pBlEWhJ8F8Y3PWIYAcsgkBiPEuLBdpCTNetmWsaQ5E8iSo58giVMhWwB5U6vUFgeORtLyAvsjIWevxmUtAmwmHXckzqE8a28nbWWMUFCocQVCIJWV85Pyf1wEA4ATowiUt/EXnR8RGGF2f9JXcYyns79353zKGWMJ/4cnBMryvFk1wgoWUEostZgr4laYzuF63iHqxzFXgp5J27hHMXlEL1mR1++SQv6ZBhZGKQth7BZvfFitLRpqYcech3DVu3fny5yW76JYATniXHRa0j/kRRKCFD5gSEHUD/6zaqaauX+WkwIeZNXGR7ty5b4SQSCa5zqhs52hwS3kKlBgzzK105MUqHP1XlxZczyTZDBJyFwAO0uvH/LAMYfiSK5m/L1ok9v9ZknrrayIc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 31, 2026 at 8:01=E2=80=AFAM Lorenzo Stoakes (Oracle) <ljs@kerne=
l.org> wrote:
>
> OK we need a fairly urgent fix for this as this has triggered a syzbot. S=
ee [0]
> for an analysis.
>
> I show inline where the issue is, and attach a fix-patch for the bug.
>
> [0]: https://lore.kernel.org/all/e1cb33b8-c1f7-4972-8628-3a2169077d6e@luc=
ifer.local/
>
> See below for details.
>
> Cheers, Lorenzo
>
> On Wed, Mar 25, 2026 at 05:40:22AM -0600, Nico Pache wrote:
> > The khugepaged daemon and madvise_collapse have two different
> > implementations that do almost the same thing. Create collapse_single_p=
md
> > to increase code reuse and create an entry point to these two users.
> >
> > Refactor madvise_collapse and collapse_scan_mm_slot to use the new
> > collapse_single_pmd function. To help reduce confusion around the
> > mmap_locked variable, we rename mmap_locked to lock_dropped in the
> > collapse_scan_mm_slot() function, and remove the redundant mmap_locked
> > in madvise_collapse(); this further unifies the code readiblity. the
> > SCAN_PTE_MAPPED_HUGEPAGE enum is no longer reachable in the
> > madvise_collapse() function, so we drop it from the list of "continuing=
"
> > enums.
> >
> > This introduces a minor behavioral change that is most likely an
> > undiscovered bug. The current implementation of khugepaged tests
> > collapse_test_exit_or_disable() before calling collapse_pte_mapped_thp,
> > but we weren't doing it in the madvise_collapse case. By unifying these
> > two callers madvise_collapse now also performs this check. We also modi=
fy
> > the return value to be SCAN_ANY_PROCESS which properly indicates that t=
his
> > process is no longer valid to operate on.
> >
> > By moving the madvise_collapse writeback-retry logic into the helper
> > function we can also avoid having to revalidate the VMA.
> >
> > We guard the khugepaged_pages_collapsed variable to ensure its only
> > incremented for khugepaged.
> >
> > As requested we also convert a VM_BUG_ON to a VM_WARN_ON.
> >
> > Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > Reviewed-by: Lance Yang <lance.yang@linux.dev>
> > Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> > Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 142 ++++++++++++++++++++++++------------------------
> >  1 file changed, 72 insertions(+), 70 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 3728a2cf133c..d06d84219e1b 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1257,7 +1257,7 @@ static enum scan_result collapse_huge_page(struct=
 mm_struct *mm, unsigned long a
> >
> >  static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
> >               struct vm_area_struct *vma, unsigned long start_addr,
> > -             bool *mmap_locked, struct collapse_control *cc)
> > +             bool *lock_dropped, struct collapse_control *cc)
> >  {
> >       pmd_t *pmd;
> >       pte_t *pte, *_pte;
> > @@ -1432,7 +1432,7 @@ static enum scan_result collapse_scan_pmd(struct =
mm_struct *mm,
> >               result =3D collapse_huge_page(mm, start_addr, referenced,
> >                                           unmapped, cc);
> >               /* collapse_huge_page will return with the mmap_lock rele=
ased */
> > -             *mmap_locked =3D false;
> > +             *lock_dropped =3D true;
> >       }
> >  out:
> >       trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
> > @@ -2424,6 +2424,67 @@ static enum scan_result collapse_scan_file(struc=
t mm_struct *mm,
> >       return result;
> >  }
> >
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and re=
turn
> > + * the results.
> > + */
> > +static enum scan_result collapse_single_pmd(unsigned long addr,
> > +             struct vm_area_struct *vma, bool *lock_dropped,
> > +             struct collapse_control *cc)
> > +{
> > +     struct mm_struct *mm =3D vma->vm_mm;
> > +     bool triggered_wb =3D false;
> > +     enum scan_result result;
> > +     struct file *file;
> > +     pgoff_t pgoff;
> > +
> > +     mmap_assert_locked(mm);
> > +
> > +     if (vma_is_anonymous(vma)) {
> > +             result =3D collapse_scan_pmd(mm, vma, addr, lock_dropped,=
 cc);
> > +             goto end;
> > +     }
> > +
> > +     file =3D get_file(vma->vm_file);
> > +     pgoff =3D linear_page_index(vma, addr);
> > +
> > +     mmap_read_unlock(mm);
> > +     *lock_dropped =3D true;
> > +retry:
> > +     result =3D collapse_scan_file(mm, addr, file, pgoff, cc);
> > +
> > +     /*
> > +      * For MADV_COLLAPSE, when encountering dirty pages, try to write=
back,
> > +      * then retry the collapse one time.
> > +      */
> > +     if (!cc->is_khugepaged && result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEB=
ACK &&
> > +         !triggered_wb && mapping_can_writeback(file->f_mapping)) {
> > +             const loff_t lstart =3D (loff_t)pgoff << PAGE_SHIFT;
> > +             const loff_t lend =3D lstart + HPAGE_PMD_SIZE - 1;
> > +
> > +             filemap_write_and_wait_range(file->f_mapping, lstart, len=
d);
> > +             triggered_wb =3D true;
> > +             goto retry;
> > +     }
> > +     fput(file);
> > +
> > +     if (result =3D=3D SCAN_PTE_MAPPED_HUGEPAGE) {
> > +             mmap_read_lock(mm);
> > +             if (collapse_test_exit_or_disable(mm))
> > +                     result =3D SCAN_ANY_PROCESS;
> > +             else
> > +                     result =3D try_collapse_pte_mapped_thp(mm, addr,
> > +                                                          !cc->is_khug=
epaged);
> > +             if (result =3D=3D SCAN_PMD_MAPPED)
> > +                     result =3D SCAN_SUCCEED;
> > +             mmap_read_unlock(mm);
> > +     }
> > +end:
> > +     if (cc->is_khugepaged && result =3D=3D SCAN_SUCCEED)
> > +             ++khugepaged_pages_collapsed;
> > +     return result;
> > +}
> > +
> >  static void collapse_scan_mm_slot(unsigned int progress_max,
> >               enum scan_result *result, struct collapse_control *cc)
> >       __releases(&khugepaged_mm_lock)
> > @@ -2485,46 +2546,21 @@ static void collapse_scan_mm_slot(unsigned int =
progress_max,
> >               VM_BUG_ON(khugepaged_scan.address & ~HPAGE_PMD_MASK);
> >
> >               while (khugepaged_scan.address < hend) {
> > -                     bool mmap_locked =3D true;
> > +                     bool lock_dropped =3D false;
> >
> >                       cond_resched();
> >                       if (unlikely(collapse_test_exit_or_disable(mm)))
> >                               goto breakouterloop;
> >
> > -                     VM_BUG_ON(khugepaged_scan.address < hstart ||
> > +                     VM_WARN_ON_ONCE(khugepaged_scan.address < hstart =
||
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
> > +                                                   vma, &lock_dropped,=
 cc);
> >                       /* move to next address */
> >                       khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> > -                     if (!mmap_locked)
> > +                     if (lock_dropped)
> >                               /*
> >                                * We released mmap_lock so break loop.  =
Note
> >                                * that we drop mmap_lock before all huge=
page
> > @@ -2799,7 +2835,6 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >       unsigned long hstart, hend, addr;
> >       enum scan_result last_fail =3D SCAN_FAIL;
> >       int thps =3D 0;
> > -     bool mmap_locked =3D true;
> >
> >       BUG_ON(vma->vm_start > start);
> >       BUG_ON(vma->vm_end < end);
> > @@ -2821,13 +2856,11 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >
> >       for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
> >               enum scan_result result =3D SCAN_FAIL;
> > -             bool triggered_wb =3D false;
> >
> > -retry:
> > -             if (!mmap_locked) {
> > +             if (*lock_dropped) {
> >                       cond_resched();
> >                       mmap_read_lock(mm);
> > -                     mmap_locked =3D true;
> > +                     *lock_dropped =3D false;
>
> So this is the bug. 'lock_dropped' needs to record if the lock was _ever_
> dropped, not if it is _currently_ dropped.
>
> This is probably a mea culpa on my part on review, so apologies.

All good! That code is rather confusing.

>
> See below for a fix-patch.
>
> >                       result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
> >                                                        cc);
> >                       if (result  !=3D SCAN_SUCCEED) {
> > @@ -2837,45 +2870,14 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >
> >                       hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
> >               }
> > -             mmap_assert_locked(mm);
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
> > -
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
> > -             if (!mmap_locked)
> > -                     *lock_dropped =3D true;
> > +             result =3D collapse_single_pmd(addr, vma, lock_dropped, c=
c);
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
> > -                     result =3D try_collapse_pte_mapped_thp(mm, addr, =
true);
> > -                     mmap_read_unlock(mm);
> > -                     goto handle_result;
> >               /* Whitelisted set of results where continuing OK */
> >               case SCAN_NO_PTE_TABLE:
> >               case SCAN_PTE_NON_PRESENT:
> > @@ -2898,7 +2900,7 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
> >
> >  out_maybelock:
> >       /* Caller expects us to hold mmap_lock on return */
> > -     if (!mmap_locked)
> > +     if (*lock_dropped)
> >               mmap_read_lock(mm);
> >  out_nolock:
> >       mmap_assert_locked(mm);
> > --
> > 2.53.0
> >
>
> Fix patch follows:
>
> ----8<----
> From a4dfc7718a15035449f344a0bc7f58e449366405 Mon Sep 17 00:00:00 2001
> From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
> Date: Tue, 31 Mar 2026 13:11:18 +0100
> Subject: [PATCH] mm/khugepaged: fix issue with tracking lock
>
> We are incorrectly treating lock_dropped to track both whether the lock i=
s
> currently held and whether or not the lock was ever dropped.
>
> Update this change to account for this.
>
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Thanks for fixing this so quickly :) Sysbot didn't send this to me.
Sadly it looked like we indeed needed that doubled "locked" semantics.
Thank you for the very good explanation in-reply-to the sysbot; that
really cleared up some confusion for me.

Reviewed-by: Nico Pache <npache@redhat.com>

>  mm/khugepaged.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d21348b85a59..b8452dbdb043 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2828,6 +2828,7 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>         unsigned long hstart, hend, addr;
>         enum scan_result last_fail =3D SCAN_FAIL;
>         int thps =3D 0;
> +       bool mmap_unlocked =3D false;
>
>         BUG_ON(vma->vm_start > start);
>         BUG_ON(vma->vm_end < end);
> @@ -2850,10 +2851,11 @@ int madvise_collapse(struct vm_area_struct *vma, =
unsigned long start,
>         for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
>                 enum scan_result result =3D SCAN_FAIL;
>
> -               if (*lock_dropped) {
> +               if (mmap_unlocked) {
>                         cond_resched();
>                         mmap_read_lock(mm);
> -                       *lock_dropped =3D false;
> +                       mmap_unlocked =3D false;
> +                       *lock_dropped =3D true;
>                         result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
>                                                         cc);
>                         if (result  !=3D SCAN_SUCCEED) {
> @@ -2864,7 +2866,7 @@ int madvise_collapse(struct vm_area_struct *vma, un=
signed long start,
>                         hend =3D min(hend, vma->vm_end & HPAGE_PMD_MASK);
>                 }
>
> -               result =3D collapse_single_pmd(addr, vma, lock_dropped, c=
c);
> +               result =3D collapse_single_pmd(addr, vma, &mmap_unlocked,=
 cc);
>
>                 switch (result) {
>                 case SCAN_SUCCEED:
> @@ -2893,8 +2895,10 @@ int madvise_collapse(struct vm_area_struct *vma, u=
nsigned long start,
>
>  out_maybelock:
>         /* Caller expects us to hold mmap_lock on return */
> -       if (*lock_dropped)
> +       if (mmap_unlocked) {
> +               *lock_dropped =3D true;
>                 mmap_read_lock(mm);
> +       }
>  out_nolock:
>         mmap_assert_locked(mm);
>         mmdrop(mm);
> --
> 2.53.0
>


