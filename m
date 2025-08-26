Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C3ACA0FE7
	for <linux-mm@archiver.kernel.org>; Tue, 26 Aug 2025 13:46:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 058B56B011F; Tue, 26 Aug 2025 09:46:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0094F6B0120; Tue, 26 Aug 2025 09:46:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E39F86B0121; Tue, 26 Aug 2025 09:46:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D0E3B6B011F
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 09:46:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 80018AFCF4
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:46:47 +0000 (UTC)
X-FDA: 83819034054.14.A08455F
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf21.hostedemail.com (Postfix) with ESMTP id 084A61C0006
	for <linux-mm@kvack.org>; Tue, 26 Aug 2025 13:46:44 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eKDhKoTs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756216005; a=rsa-sha256;
	cv=none;
	b=NzH/R51uI65zCcDNu4iQMkZld55bAwuq7DB8VOa06OnKG8nAT6xjnlDnZpbQULtDprh0Hx
	9RVLid+IrKorvPK+W1DCWTh+aQW7NZeA/rakUCA6OqDypRdRDiZXdQlq+kWSzrgU3Z8xjR
	AH6dT59UsqPuM5IuFCnyVZZbkuPMFCU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eKDhKoTs;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf21.hostedemail.com: domain of npache@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=npache@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756216005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3uSnnXl39wQmO2qN0SfNv5WwjyU8sgsdnwZmwwH7nE=;
	b=wPv5tynMn55CPAYt9yTPWlfKWQDINM2GwcsKArXkggStiRxtuh1a/XzXt7LBZ+v6IVS8fp
	hgJwGqfhsaOeye/24IJKKg/kKWpYIHQb8HIdQZDb/248JxkR/CM/vX6FT+ccnjrxfSAvkx
	Q/GZgAD9zf1gI97Hfl0i800v4C8MXp4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756216004;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=d3uSnnXl39wQmO2qN0SfNv5WwjyU8sgsdnwZmwwH7nE=;
	b=eKDhKoTsthIR9V7IhXSbPghTDdugCXkVV46ldrBc66dVlpk1/uObmMGOtyv/sLZRrtNK9e
	6JKRP+7TDZ7zxV/Bi5WNLM8ScHecCOvYwoW3QzYdA1LYv12Twk6oDkyMYXDdFUDE5kRwQD
	18JmH7PfiT8twGP1duX5/YxuolrRETM=
Received: from mail-yb1-f197.google.com (mail-yb1-f197.google.com
 [209.85.219.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-582--ioc1VgLPzqtIECfyz03og-1; Tue, 26 Aug 2025 09:46:43 -0400
X-MC-Unique: -ioc1VgLPzqtIECfyz03og-1
X-Mimecast-MFC-AGG-ID: -ioc1VgLPzqtIECfyz03og_1756216003
Received: by mail-yb1-f197.google.com with SMTP id 3f1490d57ef6-e95371b5e5cso4346570276.2
        for <linux-mm@kvack.org>; Tue, 26 Aug 2025 06:46:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756216002; x=1756820802;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d3uSnnXl39wQmO2qN0SfNv5WwjyU8sgsdnwZmwwH7nE=;
        b=v0xDFWM10cB398H4tFkVT1P7+8FcLfD9pXz91TfX2kUVuzYrw/Y4civG0sGqttOU5C
         JMRuW4308VHiHBAfkIQBpNL0a32DHueZVRdJ7GjMr8Trdl1VVtGJ/a68OMQO0OJvF+OE
         D6QD7OIqr1UUaajfIzF+IldVjvNFBazztrHq/tHhsk+jLrhN9+yCf9gvEt3rkI2Z8JJn
         rJU5jYT2n06tGgs4Q6YnLs3v+GyZvoq+SIG4jhQcWvVZYr0P7AyZyiqmiQ4mCM1kJikP
         C68TZn+G9orQjEiSl83iBB6Kom4StEynMPAPlgfvVf4dzZ42SbLI7UZiKiFqAANUCHIM
         riAg==
X-Gm-Message-State: AOJu0YxEv02bmuCqkyJ3cmC/wej/dFLIJblgXqMktgdxze3nCG3K2PIA
	h2DiSaK+z3+KGNDlUeOk1AD4Oi+6Nu5BNwrjMC+jC+lipn6g+IQTW/be/HB20ZeiCv0dP2AI0jX
	lYMV0SGQfE2MXBF7GlHoZnu2Wgy+gl6g9APzJxSVT66Etn6xX2V9CmypeWjKr16L2zSYKB5tcB8
	p4JbotZ8ZNP/usiyhs8BOmmT+hayc=
X-Gm-Gg: ASbGncs7EFG1hb+jRmM0meT6PkM8+oTs6g3xFq0E3QeGMFiGUyPs+kPwmURv+bR5QcQ
	hiXCawOua1MGk7aRNtBDKmhhWPsIq4w+VLpDtDdUTmW6cCBTCs37JhflS9MvFzAcLJ0R1S/DCgZ
	wc+0ku/4uHCj7VJo7nkG9RwHc=
X-Received: by 2002:a05:6902:1505:b0:e90:11bb:397c with SMTP id 3f1490d57ef6-e951c2e6476mr17866645276.10.1756216002416;
        Tue, 26 Aug 2025 06:46:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEuxDJCtt4uGtkkNwYc+l5uBaWSrMn5+Sn6RTFNkIfr9/PHfQUvWNUMSRZXgQlOWs52bnkehKXLBXOH5bnIPQs=
X-Received: by 2002:a05:6902:1505:b0:e90:11bb:397c with SMTP id
 3f1490d57ef6-e951c2e6476mr17866565276.10.1756216001425; Tue, 26 Aug 2025
 06:46:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250819134205.622806-1-npache@redhat.com> <20250819134205.622806-4-npache@redhat.com>
 <20250824013746.bvsz3vajjj2kphrl@master>
In-Reply-To: <20250824013746.bvsz3vajjj2kphrl@master>
From: Nico Pache <npache@redhat.com>
Date: Tue, 26 Aug 2025 07:46:14 -0600
X-Gm-Features: Ac12FXyLvLHJcV0w6rar3RVrCz2fxN5NrCxMe4grcCkIazMUynhHT0ZTM7eshuk
Message-ID: <CAA1CXcBskENLPGB3zCNu0UpPqMMRtSiQuAdLPDPsEZt6ne6JnA@mail.gmail.com>
Subject: Re: [PATCH v10 03/13] khugepaged: generalize hugepage_vma_revalidate
 for mTHP support
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org, 
	david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org, 
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
X-Mimecast-MFC-PROC-ID: FWlB7-fKsPMjwYmkUr16PRFq3J9O8SPBc5jxtF0u3nY_1756216003
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 084A61C0006
X-Stat-Signature: qtfxrpksrooezo4zrsfi7ip7m57guzaw
X-HE-Tag: 1756216004-48358
X-HE-Meta: U2FsdGVkX1+mjywCrSWo2dShpCztclUB+ND9v7OGpOYrGNlZRImuyhm/1ohiuvsB927s8eHj6msYswssuEb07KqL4myczdc9wJ6JQ53I4aEmUak4T9eU04qzI5ASygADlvm6Tc12Ewk59v0TEIPLcu8fuAt/9mzEd9lbQNVR7wTNN89wuxn99h9bBuYW30puuuPMOzNTFWiI6CRIdjybNDCS2UUjgBGDP1udrUZASYmG2QTh66uxXzaMAk6XQiz9S9qpWQNfkzqq+UHAUXliHv+3Ys9sgHUv6TYUyDePyf/nxpjYNUHaK2ctv+HXaB1XuJEUp28apqqh7Q1oAo2YBdyfdWSO4Ikwcct0uV7ajBU+OYwDMXamdopcIcyhVfC1axo7XHNWoup7gBrUEQfg6WxBDuYNpYg0iD31qpVWJf1zuyevhOxZdLWmnsFyq8FTgHE0FTkopCMtPqZz3GH7nD49T9O+QjT63WclQOYFW7pjeJFQgTBcKmExuECbiGK03Nh97sOG20nrbDZZgyv2Nx+hBvyouuDPCBEd+mRZ5wR9p8eJrDVPUHDgirUTCTgGqezEBJP/gh526DwQqoOq1uhiztBwrSCXvF9e7AL1NUWVQOKjzbxMYUISnf9PAMH7qSoQzcKU9IXKFZA1D2DX0uscgq6Gw5T05FUm0CHRHCOzcAGD/Wg68g1AxzGT1Yuqst9OMkFpmwMSJG7G40HWRW8Xzeb76Eri3h2flME46T3yUYdIi4EBsGWWp/TgtWM4X38BEQZSTzUnS6YD8n/IUMOrdEpx7KfEPuOKQXFozWdg8H0Vg8qbhh79ix4fTb2y/aiETbO7x0D6LlUiUW9QGvtZM8bgXC9bMskI735yEpIfOVQ4b7XinPlgS0xS+/1p9S4WJh9DIvhpn+GscR0wRynRBAh/Gd4qrveGGYEaRqobCyOKgUS1fF/to0FL1yZchFhWYMs1/z3yxjHu+cT
 HfwA7Xiq
 Ok9VRfBdkzI9CtqXt2YINVTrzAR16qqzLUXjwIr1cORKzUXxxEHd/j6m1D2RVd3/DNvBzVC9049+y/LMHWygD50W/9WXuy3kWIv3tSmgOvKuKF9c8f6c1T1cwAiA20q0vrKXYLD6xhEus+5yLIyZupt94Bh0fwZadv6sMTSccvnhIh9o4akSs4sE/UXaoMqp1EN4flWz9aiOp53t47DBpSGFqbTtH5JIvFLK9t4u1/hVmCGv3Y4yuYwAeEGp+rs6X6YVu/IjcfLHuHgnNRZkXU50aR4bLMIyAKut56+07qTnj4yRvpEcqxCLlM9yj14TcMoAemP3LK+Qkg/eegZa5hPrm81cUt59KuB+z66DTagzqcvxy9kGlCvISBKkS1FbHMzq3qfgn6s3s0OHO33btikdRFGoKPQXJcqnS5tPp7qNBo4SCLcfy/PK0EXoYU4HcIUii3ILzwALFjlc2SAA9tUPuPA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 23, 2025 at 7:37=E2=80=AFPM Wei Yang <richard.weiyang@gmail.com=
> wrote:
>
> Hi, Nico
>
> Some nit below.
>
> On Tue, Aug 19, 2025 at 07:41:55AM -0600, Nico Pache wrote:
> >For khugepaged to support different mTHP orders, we must generalize this
> >to check if the PMD is not shared by another VMA and the order is enable=
d.
> >
> >To ensure madvise_collapse can support working on mTHP orders without th=
e
> >PMD order enabled, we need to convert hugepage_vma_revalidate to take a
> >bitmap of orders.
> >
> >No functional change in this patch.
> >
> >Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> >Acked-by: David Hildenbrand <david@redhat.com>
> >Co-developed-by: Dev Jain <dev.jain@arm.com>
> >Signed-off-by: Dev Jain <dev.jain@arm.com>
> >Signed-off-by: Nico Pache <npache@redhat.com>
> >---
> > mm/khugepaged.c | 13 ++++++++-----
> > 1 file changed, 8 insertions(+), 5 deletions(-)
> >
> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> >index b7b98aebb670..2d192ec961d2 100644
> >--- a/mm/khugepaged.c
> >+++ b/mm/khugepaged.c
>
> There is a comment above this function, which says "revalidate vma before
> taking mmap_lock".
>
> I am afraid it is "after taking mmap_lock"? or "after taking mmap_lock ag=
ain"?
Good catch, never noticed that. I updated the comment!
>
> >@@ -917,7 +917,7 @@ static int collapse_find_target_node(struct collapse=
_control *cc)
> > static int hugepage_vma_revalidate(struct mm_struct *mm, unsigned long =
address,
> >                                  bool expect_anon,
> >                                  struct vm_area_struct **vmap,
> >-                                 struct collapse_control *cc)
> >+                                 struct collapse_control *cc, unsigned =
long orders)
> > {
> >       struct vm_area_struct *vma;
> >       enum tva_type type =3D cc->is_khugepaged ? TVA_KHUGEPAGED :
> >@@ -930,9 +930,10 @@ static int hugepage_vma_revalidate(struct mm_struct=
 *mm, unsigned long address,
> >       if (!vma)
> >               return SCAN_VMA_NULL;
> >
> >+      /* Always check the PMD order to insure its not shared by another=
 VMA */
> >       if (!thp_vma_suitable_order(vma, address, PMD_ORDER))
> >               return SCAN_ADDRESS_RANGE;
> >-      if (!thp_vma_allowable_order(vma, vma->vm_flags, type, PMD_ORDER)=
)
> >+      if (!thp_vma_allowable_orders(vma, vma->vm_flags, type, orders))
> >               return SCAN_VMA_CHECK;
> >       /*
> >        * Anon VMA expected, the address may be unmapped then
>
> Below is a comment, "thp_vma_allowable_order may return".
>
> Since you use thp_vma_allowable_orders, maybe we need to change the comme=
nt
> too.
Ack! Thanks for the review!
>
> >@@ -1134,7 +1135,8 @@ static int collapse_huge_page(struct mm_struct *mm=
, unsigned long address,
> >               goto out_nolock;
> >
> >       mmap_read_lock(mm);
> >-      result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc);
> >+      result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> >+                                       BIT(HPAGE_PMD_ORDER));
> >       if (result !=3D SCAN_SUCCEED) {
> >               mmap_read_unlock(mm);
> >               goto out_nolock;
> >@@ -1168,7 +1170,8 @@ static int collapse_huge_page(struct mm_struct *mm=
, unsigned long address,
> >        * mmap_lock.
> >        */
> >       mmap_write_lock(mm);
> >-      result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc);
> >+      result =3D hugepage_vma_revalidate(mm, address, true, &vma, cc,
> >+                                       BIT(HPAGE_PMD_ORDER));
> >       if (result !=3D SCAN_SUCCEED)
> >               goto out_up_write;
> >       /* check if the pmd is still valid */
> >@@ -2807,7 +2810,7 @@ int madvise_collapse(struct vm_area_struct *vma, u=
nsigned long start,
> >                       mmap_read_lock(mm);
> >                       mmap_locked =3D true;
> >                       result =3D hugepage_vma_revalidate(mm, addr, fals=
e, &vma,
> >-                                                       cc);
> >+                                                       cc, BIT(HPAGE_PM=
D_ORDER));
> >                       if (result  !=3D SCAN_SUCCEED) {
> >                               last_fail =3D result;
> >                               goto out_nolock;
> >--
> >2.50.1
> >
>
> --
> Wei Yang
> Help you, Help me
>


