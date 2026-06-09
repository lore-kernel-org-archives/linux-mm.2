Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C0D4CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 17:04:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADD436B0005; Tue,  9 Jun 2026 13:04:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A669A6B0088; Tue,  9 Jun 2026 13:04:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92E2D6B008A; Tue,  9 Jun 2026 13:04:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7AFA86B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:04:10 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 216501C2ED7
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:04:10 +0000 (UTC)
X-FDA: 84860997060.13.A1EC72C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf29.hostedemail.com (Postfix) with ESMTP id A0C66120011
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 17:04:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xbsz5KVx;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781024647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OV4X32w2qcUPOAgJMy2RNysdOD7P/wMKsJmY5CZ0G0o=;
	b=BYFfiaR4RNxDYrsARlOzO02T+IALYnXeHhZnjAl+wUGN2APl6aBtoR7UjWYPbvwGEH3HpU
	FNriMRXV0PfxrNvucLyaVbqWj3IwLVLlEMlAGUYgWN7wj6qsWW9eFqTKmVItdccObi1JH2
	AxMK0plNxVLW/+dc+cjLNBDMrcHojmE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781024647;
	b=scZD19inaWsvAmDZri5oZBMDG+mKCxTjaUHjsjLZssPyqAuuif1Iv6dTTn1m4zjgGlbEOJ
	W7LEWsbqr+RFn4tCqJ2MUaK3pwfi52nj2PYeTuV+geDDv3D8Dw+Yt5tJRqo0yF7oCB2YdZ
	t+vHYdpQKebp8YPiR6QAbUdwp11Opcc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Xbsz5KVx;
	spf=pass (imf29.hostedemail.com: domain of npache@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=npache@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1781024647;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=OV4X32w2qcUPOAgJMy2RNysdOD7P/wMKsJmY5CZ0G0o=;
	b=Xbsz5KVxjoESx9lzQvRy0MsJUeFE1E9k0MBgFSfaT3XosiB88CeM4G8H6Hiuotpx1eyPSS
	YS1nhqqrdhltPbdW7zgtWU8Qs6SrgfrVxyd10PGGTnSpSNXqEDFbyvEldwhivhGe2eVjNQ
	JBna1EprTI9qpcJAehUVIl5YJqVB6BQ=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-YT1Dkef_O2qW99gqBexSgg-1; Tue, 09 Jun 2026 13:04:03 -0400
X-MC-Unique: YT1Dkef_O2qW99gqBexSgg-1
X-Mimecast-MFC-AGG-ID: YT1Dkef_O2qW99gqBexSgg_1781024642
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5aa6dbdee74so3649267e87.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 10:04:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781024642; x=1781629442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=OV4X32w2qcUPOAgJMy2RNysdOD7P/wMKsJmY5CZ0G0o=;
        b=H5MAIJgC/rRc2jRJRfTmQTaVp5hnaIj9CDk402I5tMS2MejLhmpY+tJ1q7GpgP3e80
         wVcvcFTn7+trOkPAWwx4AdIvu+dKwwR3fjQvHtBZSNABshByO8BMrqo/PzbiN8Z+o13c
         0Q1DAyltbFn4AyJCtD7t8X7iE8teFiSYy5L7pCV25R5HIMb0qONiRQYmmexi7r+qAQEs
         7c90Eaudqo0Nf/rwt3wfOW0xFfrY2ESHie9Cb+zicW/v+sTokbu8OIpkOHs573U1J5QV
         dI4Cud74LY06ic25SSaRv3lfuhQW5DBGyLu2sjG1ol/VkZOmEbg1LPUal5rGZBVjxmhL
         d6QQ==
X-Forwarded-Encrypted: i=1; AFNElJ8jpxmoAVCPo5Y7p+qWepDkZV3oyW+vVGZR+pmDrhC7NUTHDXsMdF89xJl75aa7un6rqrntddoP6g==@kvack.org
X-Gm-Message-State: AOJu0Yx1qu5QtQQGGuS4c43LP853XNkpaXKqQ+WJOoGqo8v+4bXVCsAc
	DRyxHGX81QKNbXADhMLcIz5WQ/37Cl6NXnX04zZiW59+SbdOZPLsEq5Hm+lTVBooeonaPrRmsLv
	x+5fDv40cMD/nL4+xmr+/Z54/ltoD1YaBmPXJl9vYje3OfI5uZwGR++CfKKlbsWogWpDBinnwkj
	vSgaudiyvi9b7kWy65j2unkiKY3ls=
X-Gm-Gg: Acq92OF5zf59KPxYUBso8f+uuUkqaQmb/hGyIwXI7Jn8FPzBXR589wLsEirSnv9rI6Q
	DDr12Legeo5WdfUQo6wIy9d11+Q0TQW/v9aMi1OsAl6dAe6rhjysNp0lDF0b++BkMk6qe+vmo1e
	lKARYUg2D0rfcEJUVQzSZBDOFDvjWrJfd7iCVX0DgqSqHMhw87xJR8pyd/V7Cgo+VFzYJ/3JY1M
	lkjH2UDKXsDpNm+
X-Received: by 2002:a05:6512:130e:b0:5aa:b6a:738d with SMTP id 2adb3069b0e04-5aa87bb76ecmr6492296e87.43.1781024642098;
        Tue, 09 Jun 2026 10:04:02 -0700 (PDT)
X-Received: by 2002:a05:6512:130e:b0:5aa:b6a:738d with SMTP id
 2adb3069b0e04-5aa87bb76ecmr6492278e87.43.1781024641516; Tue, 09 Jun 2026
 10:04:01 -0700 (PDT)
MIME-Version: 1.0
References: <20260609120443.71864-1-lance.yang@linux.dev> <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
In-Reply-To: <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
From: Nico Pache <npache@redhat.com>
Date: Tue, 9 Jun 2026 11:04:47 -0600
X-Gm-Features: AVVi8Cf9aJUAadgeVsqTUmhURWkhswJTT_uK3SAhk6cvveG4EBJ0RrOTw-P64VM
Message-ID: <CAA1CXcD83db7L0K3F1qndP1CeAaYHK8Sy2TNTi8RJXnrdvf6HA@mail.gmail.com>
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE accounting
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, ljs@kernel.org, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: l91nhmWzaaRKqVqk7WE7swPOAjiKukwooo_lDnvci1g_1781024642
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A0C66120011
X-Stat-Signature: xs9nfzszp51oa3so6nwrcukp54jui4t3
X-HE-Tag: 1781024647-639035
X-HE-Meta: U2FsdGVkX19YAF173z0KRG6rgMmkhz9Rpzpe0/e0yfVuhdQDrzQYa/X65b2oLF90CdTJhiVqJatizxEKVqxwcTIFKNgX6X4ZObKqxF8svdt1saix6sLhGs/hvoBiddgbIsWtXgn93IA3bAtiSPYvmB7ePM3Ri68qUkVBkiN4aqtYCfK1q0sHOW0FPwllHyN9JXxiVyOh69kghwV02Wt9oNIosV1gdH5+A7m/pDt2PsqFbFu+NrJLdU/ryKi0JlNQi7kgdf3jshxl+PkC8DArGxKmslYMnzwxEJOWbWJkv3v00pQNPkHd9TIvWQ/w0WVxoWDofcekUrsZc4Y9sOhCxHcDP+1HH7EcxLpGvVKIokTO8+QKd+8JmgmV+EUs6trHNnsHoZn0d/10YWgAMRGLPqrSGm+o37QJxPBKVa9uzeusc7TF8ufnG5vDx2DSPJilK499zSHlFr3fdCuteUe/S/zob0JHS8ceGiC9997KFMVjbS7fy+oDjOsx68qCIhcsCVeY8FnlHITD7Ijq/oUjXDpNVsaqhNq9mafUTwnu9HiSXOpkDO7kPjaeH9qfD4aKSilQEy6ogheY5aWCKiVkhYV/oe0iqcyiYxUpoR7bUWG0Fg7LjRLSalX5Lq2m2zPIzZQ+pZYupF2j9C1cLH0dh0Wdjm5/27GJZ3XUZvEeLuLY+mI984joEy1EQwHo90xDqpd+i444bdKkves4xwHZFKAXKsZhBifB6W+6P/5r30jWgJF+YqwgGYD7ZcWevxovh7sgmvM1uA1V3sBiPXvMBp3qLdkmUM2xxQyTvKMs3IdXhtMwI1a2HUrK9HdR4FWw/YdDouAUKgG8uYCfDh+IBSL0H7R1QdLCmgCNWqCU5TpUQ7/qfM6VNIc/Zc7T0hcVBGecTwaIIl0USRSlptE41sk1TxD0y/9u6SLuk9r9iESO0EMklHzWLGUXucSlNliSaP/T4Wz11AcD5d12yMr
 zbguPHIm
 fFaDqT/HgbN2hh2QBk+oMrs4T0F63V27qbP2KUAL4JR4XpAsrGGekaufB20nKOZnqXJr0FbADaY1/TTrxBmLnDqbZu2L5T/Vd2qo+dV0Y1R7xkzWoS+HE+aDQa2ITBbzJUqDfRmJoERZFGr9hSsUnT8T2CJNnq65TKUL9rXEX6VHTZGbOFQUKZ9ddrRlVDzscek2LCxSXgW5RQCfQGkuSRDUFEaObF16wQdn6ZRsahS8/8gjSGrsosx4FZbcyyS+dm1juyaOjerjJAfnf93j+0/YJPdhJMwtHCPfyQ2MnawlClKAUdYD1aGUP7g5u6GrK2wkBQKGehvr3aK8lhh45cA3EwWa5r8oT4ZvMvOqUxAZIGTwZtkz4EctYoQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 7:16=E2=80=AFAM David Hildenbrand (Arm) <david@kerne=
l.org> wrote:
>
> On 6/9/26 14:04, Lance Yang wrote:
> > From: Lance Yang <lance.yang@linux.dev>
> >
> > mthp_collapse() uses mthp_present_ptes to decide whether a range has
> > enough occupied PTEs to try collapse. Swap PTEs accepted by
> > collapse_scan_pmd() are counted in unmapped, but are not represented in
> > mthp_present_ptes.
> >
> > When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_non=
e
> > so the scan can cover the whole PMD and build the bitmap. mthp_collapse=
()
> > then checks the PMD-order candidate using the bitmap.
> >
> > With max_ptes_none set to 0, a range with 511 present PTEs and one swap
> > PTE no longer reaches collapse_huge_page(), even though PMD collapse ca=
n
> > handle swap PTEs up to max_ptes_swap.
> >
> > Account unmapped PTEs only for PMD order. PMD collapse supports swap PT=
Es
> > through max_ptes_swap, while lower-order mTHP collapse does not current=
ly
> > support non-present PTEs. Keep non-present PTEs out of the lower-order
> > eligibility check.
> >
> > Signed-off-by: Lance Yang <lance.yang@linux.dev>
> > ---
> > Sent separately, as discussed in [1], to spell out the PMD-order swap P=
TE
> > case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
> >
> > [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZw=
pBkqAZ=3Ds+RHsTUaow@mail.gmail.com/
> > [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@re=
dhat.com/
> >
> >  mm/khugepaged.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> >
> > diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> > index b12187709f6d..617bca76db49 100644
> > --- a/mm/khugepaged.c
> > +++ b/mm/khugepaged.c
> > @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_=
struct *mm,
> >               nr_occupied_ptes =3D bitmap_weight_from(cc->mthp_present_=
ptes, offset,
> >                                                     offset + nr_ptes);
> >
> > +             /*
> > +              * Swap PTEs accepted during the scan are counted in @unm=
apped,
> > +              * not in the present-PTE bitmap. Account them for the PM=
D-order
> > +              * candidate.
> > +              */
> > +             if (is_pmd_order(order))
> > +                     nr_occupied_ptes +=3D unmapped;
> > +
>
> LGTM, there is a bit of opportunity for cleanup in the future :)
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>
>
> For example, as we no longer have the VMA here, collapse_max_ptes_none is
> imprecise in uffd VMAs. We might try collapsing where there sure is nothi=
ng to
> collapse.
>
> We could likely handle the userfaultfd_armed() part easier: some indicati=
on that
> we must not have any pte_none() would be sufficient.
>
> Also, I don't see a good reason why uffd would not be allowed to collapse=
 with
> zeropages ... it's really just about missing faults due to pte_none().

I have some patches exactly for this :) so far 2-3 patches for better
uffd handling

>
> --
> Cheers,
>
> David
>


