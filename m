Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47F5FFD9E0E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 20:28:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8291F6B0108; Thu, 26 Feb 2026 15:28:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8009D6B017C; Thu, 26 Feb 2026 15:28:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70BDB6B017E; Thu, 26 Feb 2026 15:28:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 597D06B0108
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:28:17 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ED57BC0410
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:28:16 +0000 (UTC)
X-FDA: 84487744992.03.165F3C1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB9951C0004
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 20:28:14 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D4GLp1eY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772137694; a=rsa-sha256;
	cv=none;
	b=vFSmLCf1l0dV2F0+yxO+ijNXcjTxGpRgL8UKUaEB3sGabc7TAxtpOP7iUCG3d0xPlXrhoV
	vbyATKgU9arVbJz6bLQiqXIJ9JRwPxNmGV6q1q2oAMJm2TVKLNSb2RdhTI5ubh1b8CQSvq
	5G1SYD0CjerYxhGCI/DPZl9RewTxYuA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=D4GLp1eY;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772137694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bOmoDRW+e8uJkS9U9zR8zjfDkT4HKxl6MR/DoCXPiBE=;
	b=6sfZOLakVH/mcngx1xXRcFNLvu+w2T69F4gULpWE/bpsJP020hI3DFaCk1BPX/mRrz9s6c
	edAsk/FoJqIIpD3S005xdhJRNn5l2CrUfpeRGKe8ZfJEdQGgoKIeUJOU5rWGc++yMchgse
	YYilxlWeo1l/e1MhsyczyaWpPgKz40k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772137694;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bOmoDRW+e8uJkS9U9zR8zjfDkT4HKxl6MR/DoCXPiBE=;
	b=D4GLp1eY2D5jvCA27cheUqFaY1xJx5maCj9BqrrEcNvxfQC9Lji+OYS4+qtaY2caHTaHRQ
	k5fKRZLZSyAOx2JbZKZ11FjnSMwciwJNCzketQ5EvPdvZ1IaVFro6GgPwIL8vYqcf3idCP
	5sxoqlnFmpoEGny2hJaa1Op0CwLap8k=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-338-Vn2NpYJOOZWuhzhHA6voZQ-1; Thu, 26 Feb 2026 15:28:12 -0500
X-MC-Unique: Vn2NpYJOOZWuhzhHA6voZQ-1
X-Mimecast-MFC-AGG-ID: Vn2NpYJOOZWuhzhHA6voZQ_1772137692
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-79064868702so28460767b3.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 12:28:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772137692; x=1772742492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bOmoDRW+e8uJkS9U9zR8zjfDkT4HKxl6MR/DoCXPiBE=;
        b=c2ql453vafhk38g6vYFDyIVT2QoqQOXT7xOMqFk4jdwk2ZkdwJZWweWH7eeBGXHIw0
         EYvWRqiQCmR7RyIoADfTfTFF+09E30otzkOfwUNVypL+9yeYehPhkrFeIeCGTbqmb4hW
         nHbcjpF6dswlcAjhftZOf8tL4vUEu2HTWVlLX2Cl+R5bOkg1XK4LgqFEVUL/l4SDHN9X
         Pe1BNVRPJHaj+XU3Y4C34HSE0l64voR8NlnlSIeZ0JBqF8Zky1SNn0rKut3Fjn26zjH2
         G2xZX7f9YxIctAZ5iDNhJ06s18H3sMQD11HlnRh9OAh7kuH2uHdzWHq4/+MW4Hc/P5Cs
         nZkw==
X-Forwarded-Encrypted: i=1; AJvYcCW1JO+uN3zSU8mZ5o5pYzT8XJaBPLdIvph956zyoqVYsh4wWvMnesIU6BDkQLFShJDViH/QSUe00w==@kvack.org
X-Gm-Message-State: AOJu0YwMlp38d0C3yVYlTvN5TyuAcX07kWg80lhdM+LbYSWgYzAsY6nr
	iP0OgSgV65c7S25Sr3C6LXdZMEHNaOt1MQuuGTBeVZyh0bdHFdds2GLCAyRX9WBCkqr46i6H4KG
	JJShVyQX0Ncs7bG/rTWI+qVttPtdXHWH6AEQq+MwhGcKvIyUsEkixW+BsZ0l5sRHQA0978FycFv
	aNn6JYn7UNhoX4CAEK/WVsZiyJIqE=
X-Gm-Gg: ATEYQzwGYG4PpPv2/HL+TMll2MbhWZXo2zfznw4NtMCiJEUgzsUu/JyDjlA1u9suSxq
	8O1+I+OYY2Twr+4Pf+O2YUFNFS58KLtnlPfWltVNEndFRVs1IqL2ihTi+X8nthPaa1YFbudfsoH
	qXpikZtws8PURv9AJtcb9L+D00coU7ePK9uqyoyHSYjlUbqIkHoUiMGio575xWZkqAbrQ52xRtC
	gS0
X-Received: by 2002:a05:690c:10c:b0:794:e008:b254 with SMTP id 00721157ae682-798854c3789mr5528287b3.16.1772137692125;
        Thu, 26 Feb 2026 12:28:12 -0800 (PST)
X-Received: by 2002:a05:690c:10c:b0:794:e008:b254 with SMTP id
 00721157ae682-798854c3789mr5527677b3.16.1772137691500; Thu, 26 Feb 2026
 12:28:11 -0800 (PST)
MIME-Version: 1.0
References: <20260226012929.169479-1-npache@redhat.com> <20260226012929.169479-6-npache@redhat.com>
 <81ff9caa-50f2-4951-8d82-2c8dcdf3db91@kernel.org>
In-Reply-To: <81ff9caa-50f2-4951-8d82-2c8dcdf3db91@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Thu, 26 Feb 2026 13:27:45 -0700
X-Gm-Features: AaiRm517bv9BZO5XIso49oxVwlVXXb5HNFUfjPGuUknh4zRshsCE4dEbPrh0bSk
Message-ID: <CAA1CXcDyt1gMWetfqrqGQOpB2B7n=+H_WYbY+pJyuGoDFf4u+A@mail.gmail.com>
Subject: Re: [PATCH mm-unstable v2 5/5] mm/khugepaged: unify khugepaged and
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
X-Mimecast-MFC-PROC-ID: qdpscKxqH-pwt4eOrLQ9R1DmMv92yVLLSt3T77Sm7_E_1772137692
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: AB9951C0004
X-Stat-Signature: 4nmaatp4fzecmjzz4mbebaujd1hf3e95
X-HE-Tag: 1772137694-878701
X-HE-Meta: U2FsdGVkX1+xkx8PRixSPz58CyLEr0S0vul7rHzRKzHiUQe4eOcB5C2GotXsDU0JGSgLUv/iESUWpSJIAmJqzlUKA9vpm9QhqKxNl84WgNVrknowe0SG/TbP/uez/IsM7f7FjdlC7TlpUnW60v0QLGoew7A4BZvYwOrXhJ1k31i8M1ZwAS2qbblA/0hR0mNWdhwiUV/vLggg0GvQJQ2mcdm6pl/a7aTng8gvZBu7DYU8940bbxsC6+eudeRH5iOcj6P3bweVLAmGlQbsSK3kryjeNGUJGOberKo9MPjeL19D0ci3KxcZqgyn0VrpMsItXTDyq3XeUIscZSXONQ5WAA6cGgvQVrQmS14wn/vYe/HUo8Nr2+neOZKQzifAXOlPOAfBCptktoc2eGSqWLHibjKLHvKKKlPYio5I2INmDw+7uCO9Yygmpr6PxEsAqZCB9SNgTOSKc6rbHS3XOJlUK6jiT6P4BmGHIdwryGmquWkbdyyDBKAY9GO87dfUTaLNgrlBt6Hld3n2dRWEboGRpuwAha+BSktXT5UEwcEbATIaOA2+WO8H0qvXVrc2ydLfbxrBKrmcZMG3AHhB2ZMkBvgxvIWC+5AcA+rYmvOw5qLZoHvGeIoBWzYYwZDRihchhMm973G8VEh0GtJeiKMtJPCsyKNaA0TqnwFKsnuUPnRHMM2dnCo/V2AGnj/s6G0aJ3K1JyHRjsG8+GAyBdysquHfxhSqoFApy63ZGgd+Dl4oYOWLxIsdIMXk/vVtVhcU3Y5KN9cl2/7Pc+4rTjrkclLqD5T1TdfNre+EfBYMkcxi07sYNC5mCf2Lpdye+uo05vX+1YBDEwES8erdTgYkuWPBymcZNtzn5xDCa1VqHr9UAPamSbo02ZCmHtayMKYeuvVfqD/nleTZtXASvArTMOHmE1DB9ktQjED0ip7MiCbXuO/rUG0PcBRjd80gM26iIAd5IgiPlJ/Xt3KCQ6K
 I3bbCh66
 4yw5FLGw/e7k5bUPQN/JzYqb2w/kDiNfA24cQs0pohx167rJvyCOlmg3Pcz+1VQruT3sOV1dRVcd/LkIsaiEDy3phI66PWnqppEZpqCBre2tAGHSNeS8pcMlAdFbn+zT+eddiqOdNGrkuGRkAW5yz/VTmd78+9AU3/2v4I4TMSpaDG7/hE8b8qr5nZdHDCRl4wYC9xGj0ndd+anuNlhGNK2dYdwiG2YOuEHdWiaFWpITtSfR5etrEUSiFTeYtiVGM5Ne9V6GAJf8DSJESwZDEGYBxT8jhcUuJxpHoG7P8UbHeFZpBGCuTRe0/HoSfSdkumvqIHlYm0sgRznd3XCclyfxuw8cKWF2/+qMla/d7F7Kt4egO9tJaqI1FWVCiusguICnV6l48LJszrK1GHg58HCpBaKQPkGZQsZU8jApO8dfoo36bMmfndZQAxMavpeCKx6vvHDuggJNriZxTR+5pglfNTI0+mrvqHL+qbvqyMf5TZfI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 26, 2026 at 2:41=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 2/26/26 02:29, Nico Pache wrote:
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
>
> Probably best to drop Lorenzo's RB after bigger changes.
>
> > Signed-off-by: Nico Pache <npache@redhat.com>
> > ---
> >  mm/khugepaged.c | 128 ++++++++++++++++++++++++++----------------------
> >  1 file changed, 69 insertions(+), 59 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 64086488ca01..0058970d4579 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -2417,6 +2417,70 @@ static enum scan_result collapse_scan_file(struc=
t mm_struct *mm, unsigned long a
> >       return result;
> >  }
> >
> > +/*
> > + * Try to collapse a single PMD starting at a PMD aligned addr, and re=
turn
> > + * the results.
> > + */
> > +static enum scan_result collapse_single_pmd(unsigned long addr,
> > +             struct vm_area_struct *vma, bool *mmap_locked,
> > +             unsigned int *cur_progress, struct collapse_control *cc)
> > +{
> > +     struct mm_struct *mm =3D vma->vm_mm;
> > +     bool triggered_wb =3D false;
> > +     enum scan_result result;
> > +     struct file *file;
> > +     pgoff_t pgoff;
> > +
> > +     if (vma_is_anonymous(vma)) {
> > +             result =3D collapse_scan_pmd(mm, vma, addr, mmap_locked, =
cur_progress, cc);
> > +             goto end;
> > +     }
> > +
> > +     file =3D get_file(vma->vm_file);
> > +     pgoff =3D linear_page_index(vma, addr);
> > +
> > +     mmap_read_unlock(mm);
> > +     *mmap_locked =3D false;
> > +retry:
> > +     result =3D collapse_scan_file(mm, addr, file, pgoff, cur_progress=
, cc);
> > +
> > +     /*
> > +      * For MADV_COLLAPSE, when encountering dirty pages, try to write=
back,
> > +      * then retry the collapse one time.
> > +      */
> > +     if (!cc->is_khugepaged && result =3D=3D SCAN_PAGE_DIRTY_OR_WRITEB=
ACK &&
> > +         triggered_wb && mapping_can_writeback(file->f_mapping)) {
>
> !triggered_wb, right?
>
>
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
> > +     if (result !=3D SCAN_PTE_MAPPED_HUGEPAGE)
> > +             goto end;
> > +
> > +     mmap_read_lock(mm);
> > +     *mmap_locked =3D true;
>
> On all paths below, you set "*mmap_locked =3D false". Why even bother abo=
ut setting the variable?

Yeah I believe someone (Lorenzo?) pointed that out during the last
review cycle. I forgot to look into it :<

As you state, I believe we can drop the repetitive mmap_locked (iirc
this was introduced in an earlier version before `lock_dropped`) and
move it into the single_pmd() function.

>
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
>
> This might all read nicer without the goto and without the early return.

I'll see what I can do!

>
> /* If we have a THP in the pagecache, try to retract the pagetable. */
> if (result =3D=3D SCAN_PTE_MAPPED_HUGEPAGE) {
>         mmap_read_lock(mm);
>         if (collapse_test_exit_or_disable(mm))
>                 result =3D SCAN_ANY_PROCESS;
>         else
>                 result =3D try_collapse_pte_mapped_thp(mm, addr, !cc->is_=
khugepaged);
>         if (result =3D=3D SCAN_PMD_MAPPED)
>                 result =3D SCAN_SUCCEED
>         }
>         mmap_read_unlock(mm);
> }

Oh thanks! I'll try this

>
> > +
> > +end:
> > +     if (cc->is_khugepaged && result =3D=3D SCAN_SUCCEED)
> > +             ++khugepaged_pages_collapsed;
> > +     return result;
> > +}
> > +
> >  static unsigned int collapse_scan_mm_slot(unsigned int pages, enum sca=
n_result *result,
> >                                           struct collapse_control *cc)
> >       __releases(&khugepaged_mm_lock)
> > @@ -2489,36 +2553,9 @@ static unsigned int collapse_scan_mm_slot(unsign=
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
off,
> > -                                     &cur_progress, cc);
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
cked,
> > -                                     &cur_progress, cc);
> > -                     }
> > -
> > -                     if (*result =3D=3D SCAN_SUCCEED)
> > -                             ++khugepaged_pages_collapsed;
> >
> > +                     *result =3D collapse_single_pmd(khugepaged_scan.a=
ddress,
> > +                                                   vma, &mmap_locked, =
&cur_progress, cc);
> >                       /* move to next address */
> >                       khugepaged_scan.address +=3D HPAGE_PMD_SIZE;
> >                       progress +=3D cur_progress;
> > @@ -2819,13 +2856,12 @@ int madvise_collapse(struct vm_area_struct *vma=
, unsigned long start,
> >
> >       for (addr =3D hstart; addr < hend; addr +=3D HPAGE_PMD_SIZE) {
> >               enum scan_result result =3D SCAN_FAIL;
> > -             bool triggered_wb =3D false;
> >
> > -retry:
> >               if (!mmap_locked) {
> >                       cond_resched();
> >                       mmap_read_lock(mm);
> >                       mmap_locked =3D true;
> > +                     *lock_dropped =3D true;
>
> Hm, is this change here required at all? Shouldn't we instead need to kno=
w from
> collapse_single_pmd() whether it dropped the lock?

I'll verify all this locking and post a fixup! This 'lock dropped'
feature was introduced mid series. And I think it makes mmap_locked
redundant. I verified this once before but forgot most of the details
ATM.

Cheers,
-- Nico

>
>
> --
> Cheers,
>
> David
>


