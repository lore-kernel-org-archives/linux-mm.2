Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0279F33806
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 07:30:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 363906B0088; Tue, 17 Mar 2026 03:30:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3139B6B0089; Tue, 17 Mar 2026 03:30:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2025A6B008A; Tue, 17 Mar 2026 03:30:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0A07A6B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 03:30:32 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8F95C5951B
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:30:31 +0000 (UTC)
X-FDA: 84554732262.15.AE3264C
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A4E580014
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 07:30:29 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DZA9NTTf;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773732629;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3rubzpzzB8MUH8wxty2pbLXKd6ff9MzsvIIp3K5W+Xk=;
	b=aPq10aVm1TNzhKks6b0jv2OfzBvGD1ammAoZUp6UG+ZEZBSUGOzLjSA3YRLSO/rKnQvaCE
	VnNW5Awc2DZ7GAj+7WkyINH7uI5rxdToHZdUZsvHBM3ed2Yz7GSsmapu3lxnTtkKf2OvmS
	FjrJKieObkbiG61qA8C/UpuwxaKRWkc=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DZA9NTTf;
	spf=pass (imf02.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=21cnbao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773732629; a=rsa-sha256;
	cv=pass;
	b=20P3JEGdY97fDr8jJbFOuxiOmaTtuIJ/boM31tR2qjAOAyCkwpOMwMZBWTVLkInUElT71L
	I3AykoCj9kV902hUvkbhLdHqzk7sc/SmVQzeMxQVfCkVOVaBk3+cIUMIaK03uBfijfD6B+
	l4w0+PzBIaDg8FVXq8kNo/3PN9cjiTI=
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-89c5446f3caso19313826d6.2
        for <linux-mm@kvack.org>; Tue, 17 Mar 2026 00:30:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773732629; cv=none;
        d=google.com; s=arc-20240605;
        b=Ui6M6giRAPfKuawPyO0yNumqhlftdm54oiiiqzH1GUEV0hPSWTfbP0ph7xM9hHSWAm
         rTFLXQJzV7+PllhbIH1hI/10ibWGDNH6sj3mFeaacLc95Mav4050ex217FSUdo52Vhx/
         YhoE8NpvReGI8hFGJpG1ca8OW/s1Bey9U2Mt7eofW0yUMklY3dVUKkh47nzYxWp4U12x
         lsa5ZAY4ppHwqjd+aYJOVnhQgxuzCxEvVD4RfO+YGLo24vHobjVknstF2yScAlyHK9Yt
         vyZrR5F111P97Qap5zJIliY/zVJQSXGuY+ILEL4v5+LYtLNx4Vnd//beZvuqVNKXxyN7
         9P2g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3rubzpzzB8MUH8wxty2pbLXKd6ff9MzsvIIp3K5W+Xk=;
        fh=rGpr5lAIjHA48UUB/N91sP/LmjPJ4gE+h4XIqLY8u1U=;
        b=N7oTp7sTHRGUVRzut4Z8taHgP2Qm3S4CrU8J03l6DgGSnR/B9G+OaXEHmqLAwSaQQI
         GDe/ajz4DQDD8xrEB0aqG6Eu32ZOCPPQm0PgsjlK8NM06OwyjVpx99Z3d+BeKoj4tnXe
         3lYeyVVoETd12dGvvqD4t6prjRu2loBZXOcBaxstcm4Cql9R0ynlBMMFnpzSor/a86h8
         cLYGy00i29rDMhiiYuk6tkT5KQE/cJM3xA9VBImg768jfwbn1isOmuB76W6741S94sXG
         42deSUUwkWvZvKn/Yfeq5wsaPsne58CXjVqQkC77vPRdJs56IfF3wITKRrm4+rtLOjkN
         oPuw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1773732629; x=1774337429; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3rubzpzzB8MUH8wxty2pbLXKd6ff9MzsvIIp3K5W+Xk=;
        b=DZA9NTTfCSjuv59fN1VeeMnCUzKamLioTJ+Q4wSrjGir6XcHK3C4kbzxQoboroElAB
         wjTKcSEqP/WjKs0e7Yev7xnCGMg17ftjD3WbFXFle+2MedyH7TouwwpnGc/DQm2e+TPf
         6ivfiQv+QBws4PgkJyfhM5zSLqhKEe08f6ttHkJ6KJTSTVLPWdAOXv8lIS3y8ZnH2eiR
         r75jV9CVYVJ8RkW4gMFsjK4dnDw/1txd/ZDbmGZ8qZbxRLezohCFE+2fL7SP1IGGqTFl
         ET1H3xwkDVOscx+mx1t/CpSrmrEtiX6sjFQjgker+WQ1vg+oz01tSVRxYhq21Xdvz1Du
         3wcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773732629; x=1774337429;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3rubzpzzB8MUH8wxty2pbLXKd6ff9MzsvIIp3K5W+Xk=;
        b=Yl0eb6r2xxthHpPah4D5pmSgCaZoSK3brmMFtM3vBe714/qoTXmHjuZHQqHZtkuzlU
         T/dnvtmp8r5O4Y251JMNKshrbt1wcfiMsOcTFXfC/epwSeMSLGMQJeb3EpMUGSshpL23
         i89zmA7t4371JYvmUGlUKRCWcikZyIvqjm+GZvDPDYLoqqnYK1wnw8o/HWTLYVNwWMBb
         9gDmEua8+UmUFtQYExT3LITjSOU5b0A/SPkwj39h/vFRxwuE8hpFEYA8O/zKfhNMuUiu
         4nH6+QPYm27RvxP+g8fgherRW/LaYkJ6pmVlxTEjZRwcqvaxJHuUK5kPNYr51xrxmJCC
         brEw==
X-Forwarded-Encrypted: i=1; AJvYcCUnq2j+VZ4RvJohL3Xd72aIuNaDKJOdSdFD2fS/8MJGg4TtuuOZqyd7klukgq3CGjVLYobJ/qv7kA==@kvack.org
X-Gm-Message-State: AOJu0YzEnATGFUtlU34dvPCvzSsNW1NkjID9AkYhGhm5wJWqKJq86N3Q
	7zjEhCt5xnur0EYkPaAW0v7u8lAUSJVBk9r8SdDfG8bHYUfVa75Mt5vGxhK2bohkzK1v+dUc19D
	u/glyQCEywg6lQpnM97HuJjC35MxWgB8=
X-Gm-Gg: ATEYQzzMmk4oKaIb/yny7/RS8264DchzQfqf4F6WmGUVShMhsXDhZUI5/geSZSus5Xi
	kGWHRgI6/NQ6HUbCC8lgWponYq/USvX6ATVP3dcRxbQPBiJwLLjTdV+v9sTRcVm63rZuJ9Y+rqW
	lXyZkuuOcOeaR/mYFoJL9JtUg97NWlvl+Ug26J70GXk9Aql0aF6hU1mGLSB+di9NXBrTSOI2Zzn
	AUO5bqErtcDm2pGZ7XFjYN40uoBRJ6/KhTOA7VQdDxXSscsHf45+uCeVZCsePM6W8EphQY7isCG
	N2SJHg==
X-Received: by 2002:a05:6214:d0c:b0:89c:4d0f:d7d1 with SMTP id
 6a1803df08f44-89c4d0fe7c1mr108140756d6.33.1773732628222; Tue, 17 Mar 2026
 00:30:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1770645603.git.baolin.wang@linux.alibaba.com>
 <12132694536834262062d1fb304f8f8a064b6750.1770645603.git.baolin.wang@linux.alibaba.com>
 <CAGsJ_4yEWn3kVZPQZatOJX7NLLv-OK9pAqUDuWz25XxG5hpV=w@mail.gmail.com>
 <a4d7cf56-eab4-431d-886b-a32456e44736@linux.alibaba.com> <CAGsJ_4woBVQdYcCbN1Btr2vxOL8OAujaHkNZZ41=S-TdNh-wbw@mail.gmail.com>
 <d6820b1e-52ae-4ef2-8342-11818fdd0cb1@linux.alibaba.com> <43831628-a00f-4292-9797-cb96a029bb00@kernel.org>
 <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
In-Reply-To: <e54e0ec1-b968-4e12-84a3-4e3d331b1c36@linux.alibaba.com>
From: Barry Song <21cnbao@gmail.com>
Date: Tue, 17 Mar 2026 15:30:16 +0800
X-Gm-Features: AaiRm51v7KZ6LJdp8f59n3252h3VgtjM9y-dQOSuXV4SMcvA6-267GRGnSt_9XY
Message-ID: <CAGsJ_4wZq7ZvMzMq513a89=VYs7gGkeVwSnAczxs_yYCHGFDQA@mail.gmail.com>
Subject: Re: [PATCH v6 1/5] mm: rmap: support batched checks of the references
 for large folios
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, akpm@linux-foundation.org, catalin.marinas@arm.com, 
	will@kernel.org, lorenzo.stoakes@oracle.com, ryan.roberts@arm.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, riel@surriel.com, harry.yoo@oracle.com, jannh@google.com, 
	willy@infradead.org, dev.jain@arm.com, linux-mm@kvack.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9A4E580014
X-Stat-Signature: ax5msxiphbjashtcxidtaxzz6mdg7up9
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773732629-549714
X-HE-Meta: U2FsdGVkX19wEDkClLBw74ZT+iNb1Dr6gbbD7cWCQtoCgzF+jrH1DuzVHFWQhHy3npAUinm3ID1bA9Kp4R7G8n0uy7AvyE7JBuA7W/z6OuDqHwLQaeRdVtd+tLVnTcwrEqZ4wLEfJ4DZvp4D4J5YVgZLhpcp6VU8RWT7bqWRL+8g6QmuWDp44Kom6gdQYXEzytewKUUUQoxNLOhBW+cwawALEvjsRA9n8dGa1dPTbtQmGfIFwu5tiIXSoCd74FDjb+DWq7hoeIWqeeqMI1cRV8qHls3TQYSGJqjcmzaf3AEq26Fpe17lc3aOpZx+wpbogMIFOKhHvRut2Xnat2Rb0CzHriKx3JKdstgS9QXqFGl95FA9GLaSC7Bun+hv4dB4OKFHrda9SHr+YbHAlli7Xepol2WhFTV3YbPNjetYEJ6/IcBv0R2LJKFMLKLM2BIYjrLUyxPXmcK3bOonzNemDQXxQ5oSvUquzCqFKnzajbj5MM3xsjBAiytIhucKHQ+gTWhRN7AscDzoNJ6y1I8LsrXohs9bHqjdVl3BI4jgZyM0zCd7peJlSPpOGfdWkgO4lXFGlhPoE3p1NTjIzM/J7FzHxL745u/+Tfx7AuCIs0v5irXy1UtBSaVsUcquXux5rKDRzIKzBwuvAUO63YdYZDKXBLIv1wNrwPftGBIdRbUuR1SV+5Yw28RKHmNS6SHouTyvcuyq4dd8uopt2a4+bf/mZTdCtfG1yCrA6yHlZu1tdkP2soy50Fu6AxOkYMMxtgJkKuwKu+CLmoxWa41vxoXIXPFk/1mbIyPoNv9RvSBftMLbJUSv97lZ1EXXGGhP/ppbSJ8o0jCKA/qWeifvbfjXppa3lGbVIo0RwyS6aC6Pwv1sX7xWdmtWkrREWg28ByfwujA7n4FU7p1ZqagaQdoLG56Yvfllu74qAGTcX2tvfAvhrXVNqMPSegvcItCRPF6AYalDVu+opOcXTnb
 Czf7c3WC
 7G+5dXwZAVqye84ESx/45TWh8wsRnBA8Wa+Ix2/EMAgGfp7uLsE0go1equYqzCNOy9XGrHgZa+Va9UTRJTIWvDWuqe5k9yU+tCXAdQK4/uCWLn6vCUzkrTGA87gzpDzh+qT+qsHn6g98zHL3/e2XkDR0j/Xn3uaoehHfyeNBhcbeOqQ/HNfrxRi7w/6+/5ncunw/JGjsbAGFg2w++wz7W0PXWh/SaeqYmK56Z1DbBkiXPmwPA/ROduGzxh4nikD/oM50e8pFCPuT7A6o9mTQMWKbpP48GHIfJiv4wOAoUYmvgxrhfSB/51RMk8d5aQ7HZFJG9q9gDe1zWL8k5iYQ/adOMSsAdd485LO0dSyU8TGHPHXoVYMrO21+VAGEreda1TF2mGvj1GTpEzANNAVmIBbeMFkJ4wGHvMcH7dCVasslq93k=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 16, 2026 at 2:25=E2=80=AFPM Baolin Wang
<baolin.wang@linux.alibaba.com> wrote:
>
>
>
> On 3/10/26 4:17 PM, David Hildenbrand (Arm) wrote:
> > On 3/10/26 02:37, Baolin Wang wrote:
> >>
> >>
> >> On 3/7/26 4:02 PM, Barry Song wrote:
> >>> On Sat, Mar 7, 2026 at 10:22=E2=80=AFAM Baolin Wang
> >>> <baolin.wang@linux.alibaba.com> wrote:
> >>>>
> >>>>
> >>>>
> >>>>
> >>>> Thanks.
> >>>>
> >>>>
> >>>> Yes. In addition, this will involve many architectures=E2=80=99 impl=
ementations
> >>>> and their differing TLB flush mechanisms, so it=E2=80=99s difficult =
to make a
> >>>> reasonable per-architecture measurement. If any architecture has a m=
ore
> >>>> efficient flush method, I=E2=80=99d prefer to implement an architect=
ure=E2=80=91specific
> >>>> clear_flush_young_ptes().
> >>>
> >>> Right! Since TLBI is usually quite expensive, I wonder if a generic
> >>> implementation for architectures lacking clear_flush_young_ptes()
> >>> might benefit from something like the below (just a very rough idea):
> >>>
> >>> int clear_flush_young_ptes(struct vm_area_struct *vma,
> >>>                   unsigned long addr, pte_t *ptep, unsigned int nr)
> >>> {
> >>>           unsigned long curr_addr =3D addr;
> >>>           int young =3D 0;
> >>>
> >>>           while (nr--) {
> >>>                   young |=3D ptep_test_and_clear_young(vma, curr_addr=
,
> >>> ptep);
> >>>                   ptep++;
> >>>                   curr_addr +=3D PAGE_SIZE;
> >>>           }
> >>>
> >>>           if (young)
> >>>                   flush_tlb_range(vma, addr, curr_addr);
> >>>           return young;
> >>> }
> >>
> >> I understand your point. I=E2=80=99m concerned that I can=E2=80=99t te=
st this patch on
> >> every architecture to validate the benefits. Anyway, let me try this o=
n
> >> my X86 machine first.
> >
> > In any case, please make that a follow-up patch :)
>
> Sure. However, after investigating RISC=E2=80=91V and x86, I found that
> ptep_clear_flush_young() does not flush the TLB on these architectures:
>
> int ptep_clear_flush_young(struct vm_area_struct *vma,
>                            unsigned long address, pte_t *ptep)
> {
>         /*
>          * On x86 CPUs, clearing the accessed bit without a TLB flush
>          * doesn't cause data corruption. [ It could cause incorrect
>          * page aging and the (mistaken) reclaim of hot pages, but the
>          * chance of that should be relatively low. ]
>          *
>          * So as a performance optimization don't flush the TLB when
>          * clearing the accessed bit, it will eventually be flushed by
>          * a context switch or a VM operation anyway. [ In the rare
>          * event of it not getting flushed for a long time the delay
>          * shouldn't really matter because there's no real memory
>          * pressure for swapout to react to. ]
>          */
>         return ptep_test_and_clear_young(vma, address, ptep);
> }
>
> I don't have access to other architectures, so I think we can postpone
> this optimization unless someone is interested in optimizing the TLB flus=
h.

The comment is interesting. I think it likely applies to most
architectures, including ARM64. The main reason ARM64 doesn=E2=80=99t use
this approach is probably that it can issue tlbi_nosync and then
rely on a final dsb to ensure all invalidations are completed=E2=80=94
and tlbi_nosync itself is relatively cheap.

Thanks
Barry

