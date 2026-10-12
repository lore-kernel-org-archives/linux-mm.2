Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42EAFCA9EC5
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 22:46:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A39776B0088; Mon, 12 Oct 2026 18:46:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EBAC6B008A; Mon, 12 Oct 2026 18:46:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D8BD6B008C; Mon, 12 Oct 2026 18:46:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 51A986B0088
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 18:46:51 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B6AD51A0A94
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:46:50 +0000 (UTC)
X-FDA: 85315460580.15.8F9ED84
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id D17EF40007
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 22:46:48 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pnbI1v9A;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1791845208;
	b=KNWpFKBASVkfn5Cwn3WuAhKu60mYGJMHE4SrwcQAY0gSvKVb8LFaBxwtRmh1qhJUCx0v/8
	c+E39EFCYG/FhGzw8qIhUcDKPVG+97GF9yZeGTrEmaMBMAUAFHR2cl81vK8Ultrl3/SiOd
	IEkUPPx7CCsXvqTyOmYBc10p0lOsoeY=
ARC-Authentication-Results: i=2;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pnbI1v9A;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf11.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.47 as permitted sender) smtp.mailfrom=jthoughton@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791845208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KkNXmVIuYHniGi8sq0nMVJSfhNn8EId0UMsFBCBlV/c=;
	b=piiz/E/wMLHINRaKeQddyaj0auhfZnzY1aDNH9XjZV+phCRm9+VDq6hUud6KESTFbzuB1D
	7sK1XaJnQSLM6A32cjr6QqN3mXiHG0/7NtPKqZIgW3eG4h1sw1N3OBq4RGruBvSW++bUrV
	kLhsQGVum08Sy6GfboQbNkA2STj7pl4=
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-c2e36c3478aso302633866b.0
        for <linux-mm@kvack.org>; Mon, 12 Oct 2026 15:46:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791845207; cv=none;
        d=google.com; s=arc-20260327;
        b=Ush/551E3UifXeEGKFGLSD+emQG3jrBae/r2yLfsZWaS93I/jEoz0HC4t4yuAVY/se
         hdkoFzQI96ewRJy3MxscK29NGXmHHW3eOJM4qNYdNTUIYJEnRVjQ0DmDX8EZ3DHGeztQ
         P2QYQltJ3ySeLLz1NZa0Ap8yveUtdL5Mu/IsFhKAH5nxS2gHAGlRirgtWbvssuEn/QcN
         9LOAEMTDDPx1UugTo9mf3to059SzmdAGe7aRyUdPcX5W+ouBSLfzerCtdZ+YRcW8B9MW
         HdrpiytbMxPkTVtt9nGlAo526LEP9fAIgHcFOmHBnAkdjtAhj826Il2tCWO8H2//KdPM
         8Jjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KkNXmVIuYHniGi8sq0nMVJSfhNn8EId0UMsFBCBlV/c=;
        fh=XDirc1xFduGdRCwNUxPx0W+gyJX+wuO9vZFZoJPPw3Y=;
        b=TY1x47dG4X94guHqxSJpbjIQStAzJfAl0RHglHMEkysIW99Sw1U72C/Sd46aBP5VUY
         XAGaMtLT1dd62DdW1UvXz5X3Nm/JHGv7ZAaMXyhZ3i61pI0wKuFJDLNPP9TgvqPy0m7l
         2DcL9nmAixNFvvART43/k2bFrPKfK4AJMEDEHEeckZLT0kgF8Eeg8eCBuYbBle15uHLV
         CiFfjeG38PqYP4s6IvDEHoi+8vxAOSHgz0V/NypBxy5+pfxARDylASwoMwYOyfCzB7W3
         NrrIyIlBlvBQxrbc/ZvAkUb2I9BXno2qd75t9jlxMf36jhAh9ylLIm1JrPEo0FnLv2tA
         uYHw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791845207; x=1792450007; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KkNXmVIuYHniGi8sq0nMVJSfhNn8EId0UMsFBCBlV/c=;
        b=pnbI1v9AbVhiPk2qGC9qvlMRFfmjdLCl4S9C27U8vocGV2gIQh/KmZDvadXTr/tOHx
         j638Gsb4JN+gWVCFDyH3LrZD5RbURDsNbXW2JCEyZiJf9dzip/kT34e+zG9apbooadgO
         2B/YAPfoo2dNnSpOb++lmmOWytsCezy+MdVDgLnyJKxKD8R92+r3aDII+uG2ZRbMCxRo
         45KTUMMvkI7xxvx6p557xvEV0WY7T+bmkFDuRzKqWVX6GFi6Dma/g+tHxWc5eivdzORo
         alTN0Z7sWYCrjVFhOVXL99BMNl8Pgt3+ERK2xfw05LHdqtLOdWB7FRB6McP4Amtmsp7B
         xaLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791845207; x=1792450007;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KkNXmVIuYHniGi8sq0nMVJSfhNn8EId0UMsFBCBlV/c=;
        b=tP0LBYzA3Hmr3lY1qEOmKDCQNagJN2JAkkQ4hbmLhguK8F7YJigZKibnPoQgv+DpD1
         sWOgttKjUpbbAm+T5R3/pgSY7+wAC/jNTFx237dpM6sGUlW0cFWyZk4+DY1te9//3v5F
         N6t+KGEXied0SWH1KGMj7bHgR2xnYJGcnrtTnwKa2x7zOuzi0PqyJcYVPzFBSaohmi3B
         j76uX+nR5Q4cMrAGASk7D2eAR8p0BDf6V9prug1YDx/hBZ5he68omtbJgu2ZCZyTly90
         ZArLmMY9rBX2AAp8QLmogTqK35o3YS3TEsgnab3b4M7KKq5BoM/V8qBbDnLKhrzgbWYI
         k7Hw==
X-Forwarded-Encrypted: i=1; AKwUvBy+Axf6cTDLmhL0EZ39E8BguTK+OZbE2LxgIPy8EDvRdb4VQ+fvHakr7M5w7gYNRxhL0MKvn/qc5w==@kvack.org
X-Gm-Message-State: AFq9FYLrMAMtLuM9ellw5OOJo6Og2dq8RVtBmZ6bhZXLzj3XqN3i7YE1
	AIJDNOvfourDoklJuIhfmKosvEYvKXR1/bpSn6LC24RJL8kXsnW5wcoldGPgDes6wIj35Zy0lOW
	el79Az/rDvEIxGLUwSwBwdFiQWvTb525N1ZGztMjZ
X-Gm-Gg: AYBFou2d2tqoh1YQmBsDNLCvIRnzHdhwHqb8PmmwoShFd/b+ZJIHWWnQXjZR2P3h7mH
	YDTezEQbVMiMBHvFuUCMZYuncooiW8I9noixV9ehYfOC+O2JAarsrgMa75Cwjc7qnszAsfSbaJf
	zRNiNESREB8JqI5r1i2CNNOQGPLo6h2vwDxRfHjO0fHxAeO+57uXfxGbVi3JqsoAbzXSvJLJ2E3
	YC3HgX2W1UmGD08AUE/3JifNyBI0H7wl2pk3QVqC7Niz1+nSw1K1OAPe7Jq1OYlDF1lE+vTkstE
	naF78vmSrbv+Cq8uQ95HRhjyVPOC3Gg2cMq2J4ozMiDsdstIk58dF5z9YZXJeqFmSH/uJgIOHHb
	GeNiV7dZ8ipb2Gh4hfv8c9hM3jo8nrapWCNnh+kZtDSXAtdmOa7ps88j5Rw+Vw+h4d7e+8FI5NP
	MMzshOuUUSt244EuWz0dvIMwgtiw==
X-Received: by 2002:a17:907:c10:b0:c26:19e3:e97f with SMTP id
 a640c23a62f3a-c31aa079ebdmr1002297466b.31.1791845206750; Mon, 12 Oct 2026
 15:46:46 -0700 (PDT)
MIME-Version: 1.0
References: <20261003001859.502725-1-jthoughton@google.com> <asy9PMMWm6waSXEz@thinkstation>
In-Reply-To: <asy9PMMWm6waSXEz@thinkstation>
From: James Houghton <jthoughton@google.com>
Date: Mon, 12 Oct 2026 23:46:09 +0100
X-Gm-Features: AclHuK9ZhJOKDqq-fhgubNpXnJrAc9LsNZuqrRbSIvL1R7j6cSw08Wb635cc-DY
Message-ID: <CADrL8HUmqqH0+Ept3LDFpczbJv11qyWcQ8_3cSCaecjAr-oCMQ@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] mm/khugepaged: Never install PMDs in
 uffd-minor-registered VMAs
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, liam@infradead.org, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Yang Shi <shy828301@gmail.com>, zokeefe@google.com, 
	hughd@google.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f8deqa8rw857zx5t87eqyuie7mcz6xbt
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D17EF40007
X-HE-Tag: 1791845208-245762
X-HE-Meta: U2FsdGVkX18uhkDDZJumwL54pFU4ZTtBWEr2oDn2UnkNIg5LiPEoqALta++ffHRHXOM8eCar6Zm6rCOPLs2tqR9/mmjm1QzMK1QrBvTw34ztFEoAK992NpRQ0b98CxhqDsmY8DJFjNbGRc+WndSWfusHen91ZKRE0uvwvWQS1jA27SHJu05oyIraWGsASdezjKGamVVtrtk/zZpJOx6l58RkfJBK0sDg6HCanz/JYq/H8GfF11BTAKh7IdwQJ3+s/4ggAEeXEXxyROfujNU83DKFaBNTz2yEanA4DLRPtrkXelMcJwsprUlhSf4Qxvsgvx+rRJAPf8hLFxX/PvjvWgpI71JSFoQSVBuPraYAGQ0lUAzN81yuGgTyCEzT8b7hAaEeCUztx83ni812ylmVXzc6CVVxUi90Ny5lAyqCK2t9O4YjUjoLkuOLf3adMtMgM5GHdRy4RVkVINv6Dhe/h6oTU07717C47j4wmFB95dCBCCYk4wDWo1C2GnX7AGie1ic2TVtYWcJc4S7aApCK+fyTPP30l6YZvYkLEi8KkdajqIn6NMr9YP+6GxgeSz3Fvk+RZnewpi3lzpswhYeYZI0Bs4PaAemNPYTeXF4uUPIpTkYkjF8fbBkGf8JWYeY4QMqMrBpNh5ptyJkIPu+dmGHzPbX47W6CDPxtMy8BgG3I1H3D59HLbJTpB7C5nTJPwGzqU8sDW/up1Yz9IlPHQ7MHe+iVJirswMOsjyFtmLef+GLgJ5wf75OhapB/Qb9tWl536z4B+WQA2Yai8OtFFtL5UCC3+NDD8AOvdk37fhy9UoPfwzhpVZcTdya2c/IJtsSxMAltlLZhvlhytfNRt1+2EZQEcBc6ifvJ0uftk+BChMcSN+7nzIHzHoHnchyrYgNQSfxLBdSJURGfvuaMN2YeNxqL1hZ9kElCwo9EVDPOB9IRQrlFczSD/wdXNBk1An802Oj3sVMqS+ICro8
 6W5IyG6n
 gLZvP4/AWAI7QUCz9Mx9VPVJFJGT7IdkXR4RIh/9JWzoGZ62r1LmQhzEeFpxOowy9EEQjo77sd5DK2JTD/z84u3weXwa1MMqV4IU4RwQ+AZeBVliYT1hu8Zdmpe5lSX2Ds9cgbH3x6QPgdSUnQh6lknhlvheDOv3htjsHcTIA67pvKh+IrDo60vq1VclRkbm6/2fhvkLOZ3Cra5WWGB2ZOfJlGYDI5KjUOlrC7xkRjvHi4BGqxLLwhw59BQj/j28jRwaEM0wRDSpYizabSDfkD+YT/F2q673cAY3m
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 12, 2026 at 12:00=E2=80=AFPM Kiryl Shutsemau <kas@kernel.org> w=
rote:
>
> On Sat, Oct 03, 2026 at 12:18:58AM +0000, James Houghton wrote:
> > Userfaultfd minor faults provides userspace with the ability to manuall=
y
> > install PTEs with UFFDIO_CONTINUE. Right now, MADV_COLLAPSE can map
> > holes in the VMA when a naturally-aligned THP is present. This is not
> > true for khugepaged collapse: the PTEs will be retracted, but a PMD wil=
l
> > not be installed.
> >
> > When MADV_COLLAPSE installs a PMD that mapped holes in the VMA,
> > userspace is likely to expect UFFDIO_CONTINUE to succeed on the
> > should-be holes. UFFDIO_CONTINUE will fail and return EEXIST.
> >
> > This is not inherently a problem, as MADV_COLLAPSE is an explicit
> > userspace action. But, especially because MADV_COLLAPSE can be invoked
> > by an external process via process_madvise(), a rogue caller could brea=
k
> > a userfaultfd-minor resolver thread.
> >
> > Userspace cannot generally use MADV_COLLAPSE to resolve userfault minor
> > faults, as MADV_COLLAPSE will only resolve such faults if a
> > naturally-aligned THP is present, so this is not a functional
> > regression for userspace.
> >
> > The naturally-aligned THP case is the only case where this quirk exists=
.
> > Collapsing otherwise requires all PTEs to be present for
> > userfaultfd-registered VMAs (i.e., max none PTEs is 0), which is
> > correct. This check is essentially bypassed for naturally-aligned THPs.
> >
> > Suggested-by: Lance Yang <lance.yang@linux.dev>
> > Tested-by: Lance Yang <lance.yang@linux.dev>
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > Changes since v3:
> >   - Prevent page table retraction in patch 1. Please see the comment
> >     next to it. So this patch now has two hunks instead of one.
> >   - Reworded the comment and combined the userfaultfd checks in patch 1=
.
> >     (Thanks David)
> >   - Simplified the selftest a bit given the behavior change in patch 1.
> >   - Undid a change in v3's selftest that incorrectly handled the case
> >     where MADV_COLLAPSE was not supported entirely.
> >   - Rebased on top of mm-unstable, which includes Kiryl's changes.
> > v3: https://lore.kernel.org/linux-mm/20260910023411.514987-1-jthoughton=
@google.com/
> > v2: https://lore.kernel.org/linux-mm/20260828222640.1638457-1-jthoughto=
n@google.com/
> > v1: https://lore.kernel.org/linux-mm/20260828005004.2870750-1-jthoughto=
n@google.com/
> > ---
> >  mm/khugepaged.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index 913086eaf17b..438c4af1c058 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1868,10 +1868,11 @@ static enum scan_result try_collapse_pte_mapped=
_thp(struct mm_struct *mm, unsign
> >               return SCAN_VMA_CHECK;
> >
> >       /*
> > -      * Keep pmd pgtable while the uffd bit is in use; see comment in
> > -      * retract_page_tables().
> > +      * Don't collapse if there might be PTE markers for userfaultfd-b=
ased
> > +      * access protection or if collapsing might bypass userfaultfd mi=
nor
> > +      * faults.
> >        */
> > -     if (userfaultfd_protected(vma))
> > +     if (userfaultfd_protected(vma) || userfaultfd_minor(vma))
> >               return SCAN_PTE_UFFD;
> >
> >       folio =3D filemap_lock_folio(vma->vm_file->f_mapping,
> > @@ -2093,8 +2094,13 @@ static bool file_backed_vma_is_retractable(struc=
t vm_area_struct *vma)
> >        * and cannot be recycled to a shared PMD. Other vmas can still
> >        * have the same file mapped hugely, but skip this one: it will
> >        * always be mapped in small page size for these registrations.
> > +      *
> > +      * Userfaultfd-minor-registered VMAs should also not be retracted=
.
> > +      * PMDs will not be installed, as doing so can suppress minor fau=
lts.
> > +      * If retraction were allowed, khugepaged might continually cause
> > +      * unnecessary userfaultfd minor faults for already-CONTINUE'd pa=
ges.
> >        */
> > -     if (userfaultfd_protected(vma))
> > +     if (userfaultfd_protected(vma) || userfaultfd_minor(vma))
> >               return false;
> >
> >       /*
>
>
> Did you run 2/2 on current mm-unstable?
>
> Here, on e8d0f6a1b2a4 plus this series, minor-collapse fails every run:
>
>   # failed reason: [unexpected memory contents after collapse]
>   not ok 1 minor-collapse on shmem

Oh, I must have missed this when testing the unit test
"simplification" for this v4. :( Thanks for testing it.

It looks like uffd-wp can tolerate the try_to_unmap() because
cond_install_uffd_wp_ptes() will get called in the process.

> This patch refuses the collapse too late.
>
> collapse_scan_file() has no VMA, so the uffd check in
> collapse_max_ptes_none() never applies, and collapse_file() goes ahead:
> it try_to_unmap()s the PTEs userspace already CONTINUE'd and replaces
> the page cache.
>
> Only then does try_collapse_pte_mapped_thp() return SCAN_PTE_UFFD.
>
> MADV_COLLAPSE fails with -EINVAL, but the page the test read beforehand
> is already unmapped, takes a second minor fault, and gets flipped twice.

Thanks for explaining that, I didn't notice the try_to_unmap(). The v3
version of the selftest didn't have this problem because it only
attempted to access each page once.

The purpose of this patch is just to avoid installing PMDs; unmapping
PTEs is acceptable. I think the logic to truly prevent unmapping in
this case probably isn't worth it. Let me know if you disagree.

So I'll just go ahead with fixing the self-test, applying a diff like
this (sorry for the formatting), undoing the "simplification" from
v3->v4:

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c
b/tools/testing/selftests/mm/uffd-unit-tests.c
index 74ce43769e58..48435faa8bc8 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -553,6 +553,7 @@ static void
uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
  char c =3D '\0';
  struct uffd_args args =3D { .gopts =3D gopts };
  bool bad_contents;
+ int checked =3D 0;

  /*
  * NOTE: MADV_COLLAPSE is not yet compatible with WP, so testing
@@ -596,6 +597,7 @@ static void
uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
  * The page we already touched should not be unmapped, so a
  * second userfault on it should not be generated.
  */
+     checked =3D 1;
  }

  /*
@@ -604,7 +606,8 @@ static void
uffd_minor_test_common(uffd_global_test_opts_t *gopts, bool test_col
  * fault. uffd_poll_thread will resolve the fault by bit-flipping the
  * page's contents, and then issuing a CONTINUE ioctl.
  */
- bad_contents =3D !!check_memory_contents(gopts, gopts->area_dst_alias);
+ bad_contents =3D !!__check_memory_contents(checked,
+         opts->nr_pages - checked, gopts, gopts->area_dst_alias);

> Also, your 2/2 missing Signed-off-by.

Thanks, I'll fix that.

I'm actually away right now, so I'll be slow responding to feedback
and can't send a new version until next week.

Thanks for your patience, Kiryl.

