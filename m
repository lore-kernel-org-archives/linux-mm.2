Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E587606FFF7
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=lMyb0W1H
Received: by kanga.kvack.org (Postfix)
	id 7256C6B05B0; Tue, 10 Nov 2026 17:10:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCF76B05B1; Tue, 10 Nov 2026 17:10:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 612A26B05B3; Tue, 10 Nov 2026 17:10:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 290616B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:10:06 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9F4E514013C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:10:05 +0000 (UTC)
X-FDA: 85420603170.10.AC1649C
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9D8FC140007
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:10:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lMyb0W1H;
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794348603;
	b=zOAV+DOAaDo0zQ0JrbKJRSW6gLURlVNJbQvecno9XCWWWq017sg2FqX8DtFcM1IWHifMVA
	xPqGdon+sjNo29FCQXwnSk0nI01BjusGYcbnTE1LsUrq/5R0XGv7mbbV2mMlkLcMIvZhsD
	bJL9ufWWPqhrI8JDPmDD0HBanF7DV1c=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=lMyb0W1H;
	spf=pass (imf09.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794348603;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZEddz8haj4iGepLSSw+CHqlgTqudRs35VC14E4G7pVs=;
	b=UIFSH8RcvLcXzXIKGPxAVD/QXrHSf40G2BGI4KccpkAkocq62RvAvakpGFOoEkVzMBNExa
	frBIZx5YoOxAa3ie+qTdfPecdhS4jKxBEpeYe/vVv51tgpir9b1NXwykgbpk1Wh5oP4coE
	PDrEIupZlrvUrHb7kNyRBNnsXsl8nlY=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-c504bfd7393so198175566b.0
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:10:03 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794348602; cv=none;
        d=google.com; s=arc-20260327;
        b=AHo36Ns8raeSaObHLj3YmZp9gN2nwRUkuuBZkhzglQiT4MATdNbVrczbVl1xh8sH9p
         TbOPGSEu3IwC/DfDbim0vWcuKJCL5vyGD1tWl4VxJ25N9lElfnMZPAZCVYQhXEoVqVIn
         uiCh3UFEx9tTVp764at3rXRrhDp1NmDxE1KeJcZhyXKxSX6pKyzDokOy6V2/24yBGl29
         cSgUXmMxkKMwTHsvukF694Cb5FZaqtjEc/2K9g4Wn2xQrpwriN45/imE/2yZ6SVlXXnI
         T4Qi4HZP/Bq3OoFwjq+ao6ukRnoWEs+FDF782nrTrqMwWMRf+unyzPIOU/qrIV5IhAvF
         k8Jw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZEddz8haj4iGepLSSw+CHqlgTqudRs35VC14E4G7pVs=;
        fh=8TVCnKOubo3535f7chAHAnEmsd2b6hJd8dHhp/LeczQ=;
        b=XD0rcv5MeNKfn0YCkY4e2OTfKZa98sAx+LKRWRo/Xl0mAFsTMxS6gEGr5UvhUbMa6Y
         IXBJZ/G9PPuTERGWuQCGM7dX8M66pR7CTCdnu4aW1tUg/QgcCkztQrZHqKgpM5Ku8YV7
         nS9PGy+cif8exDss9wxH81OJk/G9DtMZCOj/Gfoqt4or+50lY2zzbMDzOxqyvAuoaD6K
         IVB8KweMKjSERX92WNJxQNnZpfJE28Ag2Gs0oAiQmiIthpF1tiV/xy5GHLtHuCLZxqX0
         zzPzqFRjoHJ4SeIj+FPxQfIihY+pwOrftc/hZa8aY6JmzrT+QJ1Xw3A869Vy5TNJdbF3
         Vc8A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794348602; x=1794953402; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZEddz8haj4iGepLSSw+CHqlgTqudRs35VC14E4G7pVs=;
        b=lMyb0W1HMdre78dFHptPFraRAxCXHsVvDrmJN0yvQ+5iqY54XDTG7/BgGCKqySz+mV
         ERzfduxXy5idsMXWqQ718JtK6hK6rNDTTnFEzlM/kHSpzDyiJ5J0C3iZV1EWPz3QrVXn
         EsNdNsEOS7CyqcpxXEzYBSUvW+D6NueNZ5kXWygq1ho+3tbeA1vfDTgyNJrbIeycMLVQ
         m9J4DOKfiW6qjSMer12um3gfLrSNryV1vVb+I5I6c1RnCTnk0Sj0SNGdebDTCNL6P9xm
         oZYYVLgUz7QVQ8FHolZVEMD3i3jgWHmjW+v9HcxijmalAQCKOE/zCd4qYnPNwK7N8RbO
         +sHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794348602; x=1794953402;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZEddz8haj4iGepLSSw+CHqlgTqudRs35VC14E4G7pVs=;
        b=x/wAtWmYcDq6nXD1omZNO8wlu398JwpT4FPX+fDTNFbdva5Zo6qP48Eq0q5LwJc4za
         kvWe5eLVyIoa42jh7LhRfKqRHCUB70E+N43l4zaBLzt5UZsapAkVZcapb1F/KJWXDGTL
         5W3EAYyTUyUilojnXgj8bMh9W63LMksBPq+cfbgfG4d33ZDDJFK10+kx6B+YOl4vZQdW
         WAXUMpaksMfWuKfgxRyOTNLRRBl5firgRs4BrHYOJ5EwxaWk1FNvlId9TXkBZYvAaUM/
         Qg8hbvQiMWlFuDuODtj6nmDiPoMHTQ6QmBs4LuoJRiyixsgHusyqRVixSb1RKqOraQQg
         Wifw==
X-Forwarded-Encrypted: i=1; AL+hErGnhcAjEtlgvoQpxWtfKNTARNrQioIMQ/O1teI2Rwtwh1j/FxVmYgx/zbiCOV1nupgtSEceyDiDMQ==@kvack.org
X-Gm-Message-State: APuU4Z+GZjQ0EhhgrrMjxWVB5iDRg7TUlC4XDwf/fTlwBVwszyDJk8Wm
	OIUzOLoC3H/SGlClvotvHrS/8eBl+28lxZhPaL2L+YkpwqVy1UiOJEizVPo2GjSKoAAqjg/e2vY
	NRSArveOduDmK4oQRydlJ5V1ir565XDocDno59kKH
X-Gm-Gg: AYBFou07mR/Inv3FjY5pioBUDtnV9dBbK5wKHkRkIIqGFn2eWpqoZDHX0cR6BR/zUDI
	3NOWfia+Y70hGwAukyHBNts6QS+0vOB8eZXpcWcwQWcoZW7sMk4y306p/8vC+EgtCnJnGXspf4E
	ErHF8M/STYvAthfCPbyfU3iAbYeLiA9n6YrrTBoqZj6hZpoAWINtV+fqNQN0rTeY56SrUss9y0G
	ISG4ybIF2zq/0a6ibAnSWnpfhYmmw9YaIAN9wSojO5QMxIBeHRxPc7VenCx2y8t2VcOVBQo9osH
	MIrJ8zIVhQORqtb1q3knS4gX/F4FMVBzfz3gGJApAch5T5VWJSxTeXLQEqMP+MD5mwLe7q9Nj0C
	Y8Z4S468Ah8PPodToQDLaaJVBWdtCLoZx5BsRxeHV1m3pxvoXLgA8SKb9SMUL+1mu5SiW8QDFoj
	wnkQPerAPnUN5pEgmv1ED7SMFK4LSr9tcl4eZR2ooiTegBRw7G1lZdGsEmgSbEgAnDhF0rePNVn
	vesVs0+
X-Received: by 2002:a17:907:980b:b0:c26:2a2:b91d with SMTP id
 a640c23a62f3a-c506694f0b9mr36476966b.6.1794348601603; Tue, 10 Nov 2026
 14:10:01 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-9-jthoughton@google.com> <30822F0C-88B8-4ACD-A0CD-F889F438EDB4@linux.dev>
In-Reply-To: <30822F0C-88B8-4ACD-A0CD-F889F438EDB4@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 10 Nov 2026 14:09:25 -0800
X-Gm-Features: AclHuK_-DHdY3lumgPO6Qy00BxbcnPvhIHC2Bs1SRzgw1uz1jqZUi8ATzat9T6U
Message-ID: <CADrL8HXU1jfoCcZNbRwjy6wg8jpLQPgsHu7=U28qN2Yc01nMzg@mail.gmail.com>
Subject: Re: [PATCH v2 08/20] hugetlb: Fully initialize tail struct pages of
 non-pre-HVOed bootmem folios
To: Muchun Song <muchun.song@linux.dev>
Cc: Will Deacon <will@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Oscar Salvador <osalvador@suse.de>, Andrew Morton <akpm@linux-foundation.org>, 
	Nikos Nikoleris <nikos.nikoleris@arm.com>, Linu Cherian <linu.cherian@arm.com>, 
	Mark Rutland <mark.rutland@arm.com>, David Hildenbrand <david@kernel.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Nanyong Sun <sunnanyong@huawei.com>, 
	Yu Zhao <yuzhao@google.com>, Frank van der Linden <fvdl@google.com>, 
	David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 39997dg1rucz9dfau7p4mxx3q69hbnc4
X-Rspamd-Queue-Id: 9D8FC140007
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794348603-975606
X-HE-Meta: U2FsdGVkX19UF9r3EDFaKKQCweieKbrWIjdzdR3GOe/uD3ac1W2v7ukKSw3Qdk6+SJ/hGs7ggSMqMS0RWijQT3pWVVwibcSjoCfw529WeRTJK5vGNLtGiTr3ea+rvzRjsZdvNUja3nu4MDTMfzuAP+loEKzTEmOTO9sTYrrCQ+Dhf42p5G1kdPkJZBmpFWlTJahGJkf27f76n21qKhd/Ac1CZ3+UcG1G7soXQBTadpBFHPOznIFXMPXv9mS5VkCSppR4XHkVs1oqvmnLEnAtrKhxoe/lbhRSJviQtd8y9lNGe3I5m8KfbeEpX/tJNSYzZXBH+jbN6JR/N2w7LY45KCRZJDprP0pSgI+Yte0phZ2bu0V2d1TAnLFilHby+qOJzYwDiz5XH21fIQX4iGZEvMGOiebEJ3sKpVqVlmvmCoLiHu3guUAoDN8grX08Y12d3GMTKHtQ8GuaXr5SZmgBobtlAJpqvy5sfuh9rtYMCldbzCXzvwa9yp6UxA4EJP0EC3pp+83s8nrsI6EuCgq7yTD64NncdG8jct9FqOU3rLu56S31OQ48o1wsPxT4TmCMOVi5L968ceRQaZ4Pw2qHOAATyFjuMlvrVuTZitwxhneQHp+ACc9sn0kNGBKL55y0kLOuWpANAsM/rvisIgsu1A0g1FrU2WrLlj9oWDuAbFZJynVzbsaMKmkKyELodykbWrOMbdaXBQ5jQV2/n9+x8DPdoPJqQKIZCyV6bMtNrY7X14Y6FF2QJZL+oQvOBeDKpiafpJF/wAcD8kYGIzIxwmK/3BRvQyFlE77kjh4Gd2jdvOvMXtvK2R3tV/dW6Bh49cJWeknaDcQgukM6tDC/hVZItL9tE8DkS/ALz0vjqzIPP//G1OAIXY5249H44ieNRqWWPYdcFV9WOlsm3aGs8/Uaas16d7sp/a6ieJUGJneK/vDp6tX/npj0mp6UFUEXPmzN3XQNqXN6BsjC7S3
 w32al2kp
 yBN5c/THZqAmxrbC8ZrJ9ij89xhULI7Bv8TVRj/cHz3glqlxWo6skmLc8gC0lQahkXX1O2BPwQpvE/5yu0ISuhbhgDbfakh7dOKS12BRrIuMacn8ZqBxe1CBOCYxQdZhOb8gvylXH39sdvn77mWJFgZPuIxt3Pp/MuT7umbg3JVRfcfUUwYbzCMpca+fLjAdacULVFJMj/nvu44ruMbZ+0GS4bu5lC6F6GJiNJLc5/Ejngb+CQlQHrm1vOrQUVUrbDeIdazN8j2ZeWNyV7t99RZowwG6YibUspOEJyEbi1ok1Y8X75uBGLMusPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 11:06=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> wrote:
> >
> > alloc_bootmem() marks all but the head struct page of a bootmem giganti=
c
> > folio as noinit, and gather_bootmem_prealloc_node() then only
> > initializes the first HUGETLB_VMEMMAP_RESERVE_PAGES struct pages. The
> > remaining tail struct pages are initialized only if the folio ends up
> > not being HVOed.
> >
> > This assumes that a bootmem folio is either pre-HVOed, or will not be
> > HVOed at all. However, hugetlb_vmemmap_optimize_bootmem_page() may skip
> > pre-HVO because arch_hugetlb_vmemmap_optimization_supported() does not
> > yet return true that early in boot (e.g. on arm64, where support depend=
s
> > on a system-wide CPU capability), while it does return true by the time
> > hugetlb_vmemmap_optimize_bootmem_folios() runs. Such folios are then
> > HVOed through the regular remap path with uninitialized tail struct
> > pages, which trips the PageTail() WARN in vmemmap_remap_pte().
> >
> > Avoid this by initializing all tail struct pages up front in
> > gather_bootmem_prealloc_node() for folios that were not pre-HVOed. This
> > makes the HVO-failure fallback in prep_and_add_bootmem_folios()
> > unnecessary, as pre-HVOed folios are never passed through the regular
> > remap path, and all other folios now already have initialized tail
> > struct pages. A failed optimization either leaves the original vmemmap
> > in place or restores the tail struct pages from the shared tail page.
> > Remove the fallback.
> >
> > For folios that are not HVOed at all, this does not change the amount
> > of initialization work, only where it is done.
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > mm/hugetlb.c | 28 +++++++++++++++-------------
> > 1 file changed, 15 insertions(+), 13 deletions(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 4dac7ed1df57..e971e2362412 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -3303,17 +3303,6 @@ static void __init prep_and_add_bootmem_folios(s=
truct hstate *h,
> >       hugetlb_vmemmap_optimize_bootmem_folios(h, folio_list);
> >
> >       list_for_each_entry_safe(folio, tmp_f, folio_list, lru) {
> > -             if (!folio_test_hugetlb_vmemmap_optimized(folio)) {
> > -                     /*
> > -                      * If HVO fails, initialize all tail struct pages
> > -                      * We do not worry about potential long lock hold
> > -                      * time as this is early in boot and there should
> > -                      * be no contention.
> > -                      */
> > -                     hugetlb_folio_init_tail_vmemmap(folio, h,
> > -                                     HUGETLB_VMEMMAP_RESERVE_PAGES,
> > -                                     pages_per_huge_page(h));
> > -             }
>
> Just for your information, I also plan to remove those code, see here [1]=
.
> I need to push this patch along quickly. I'm confident it won't take long=
.

I see that [1] is included in the series you uploaded recently at [2].
So I'll go ahead and rebase on top of [2], thanks!

> [1] https://lore.kernel.org/all/20260513132044.41690-15-songmuchun@byteda=
nce.com/

[2] https://lore.kernel.org/all/20261109095807.41547-1-songmuchun@bytedance=
.com/

