Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78083606A320
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 22:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Hv+1MT9b
Received: by kanga.kvack.org (Postfix)
	id 8CC3A6B05B2; Tue, 10 Nov 2026 17:06:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87E626B05B3; Tue, 10 Nov 2026 17:06:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 76C0C6B05B6; Tue, 10 Nov 2026 17:06:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 480CC6B05B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 17:06:24 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6A1A3120179
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:06:23 +0000 (UTC)
X-FDA: 85420593846.14.B94A21D
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 68D4E1C0006
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 22:06:21 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Hv+1MT9b;
	spf=pass (imf21.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794348381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=S0D/VShkRW4WtVgs6Ji1jkMhYLatw++pmKPgAANQ3tA=;
	b=71jk8pow8buDYuH161FOX8syuP7TZzDCDzz+BG6dU2PUPhN5nED2p22HmKs48wtVLvHlnx
	rphE/X925eMIlZgKWSQgUP2bTFDy36/BxRW/fZUBPEZJUvkBsVdtViEVnvbPPQtrYRYiTl
	4ant1x2t6nO11HH84NMo2wg8v8xQW68=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794348381;
	b=56Roqs344YJ2Pk82LAmHOeE+zgb9nJ53NekBMKFzvgI/W8HTdRMcwniWzeDEPjWCuXB82e
	+3a8kfFZIsRU0zjxzzO05Z441etooeqJP0RAamVUCZHXoKNhXwl1wIc6t7SzKMkWO2No7a
	7dJf9gzyQX2nKe1tcvTjX42lGwSVrxs=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=Hv+1MT9b;
	spf=pass (imf21.hostedemail.com: domain of jthoughton@google.com designates 209.85.218.53 as permitted sender) smtp.mailfrom=jthoughton@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c5067a2411bso15568466b.2
        for <linux-mm@kvack.org>; Tue, 10 Nov 2026 14:06:21 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794348380; cv=none;
        d=google.com; s=arc-20260327;
        b=Nnp7CKQvh9qm8oHjFoVLxdv2rRrawT7o7Wc6RzedWRkWZwTqg7OwlbaA1VB8Jrik1s
         c77bn1u92aHROfwIuHPXEEZGe6JexGGgxagAa6UJ3iQf7PvrhfUMu0ULxmNxdtnJ+k0+
         edIk5M/JBdg/Jn6wLTPFT+wz2LBcWmabKKy9F9QxAHRmCQYPETMOcoyLyStKsHVR94tI
         Ni/eSxGV7obFEarEOynYdfp0u7AmJeV/jj/m0SkINvdqSqIRaJ96pkCm9XTGS7mwbdKk
         1zWpGt4AhVX2Y6g920TR8MtlB4QMFdccT58JPGK0klc78k6pdTG0N3eqbDNg6ApwZpvj
         7JMw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=S0D/VShkRW4WtVgs6Ji1jkMhYLatw++pmKPgAANQ3tA=;
        fh=Rllzpa3dJFnZgd+2EWNpuOKDfT/pLpxoX1BQqVjNxw4=;
        b=AOYNAQaBC/gkSYxoUj4tp6X1a1IyOAlTMQanmmymSxAPPgkpG/HEngiS5hUBPFIyoD
         jeouR951vvNXielhvh55GhsTAjiDgst+Pe56GOXuLuZtYbQwH8uwOEoEERxThvWkBqo1
         lvOf5aJIT0OQwyComckqejkiIIwJiBCMwRb3pJWAoAgFfcg4+8iX+5Dp6LGeW8TEjH3w
         G8i3anMPV+ZkcZySc0EHRP8mVIQRR/u/WKf041lmI76FOlRQK8unuGpD7EHcYbWdhF62
         FUagQNAuXUZ2doECR4eHoqCADDeqMtba09u4p0LheGVLH+0XoCyrS5hPcx9G84ShhPPD
         k8iQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794348380; x=1794953180; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=S0D/VShkRW4WtVgs6Ji1jkMhYLatw++pmKPgAANQ3tA=;
        b=Hv+1MT9bMy7dpnrjBvHk57BdxmgcSjTew5wxV2z8KPYYiSnHZpn1u7MDcPygXv0X3x
         E1Mezp9PEiES1Im4hRQK79d8RuJMe7RaDvQGfkcSKv3/Dqj4rayyWCRneKPMpI0ifTXW
         kA/Pu7t9e1x5L5sUiPYUA4qTmO6C+5edDDUv85wZzuBaJYH62VxVKFndFYf5naqJ4UqQ
         fw+qj4HUKODRLyyd3wZlqz+5x/dWXz3VVqLfhrLxzcf2JbsA52Kfyli93NNuwpFYd7TA
         E/+VU+NRJOZL5juIo4qO76XTnVlRRsvUi0fDW0fwr0LsrnhcNAlYjntJ5rZxundx0T4X
         mf6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794348380; x=1794953180;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=S0D/VShkRW4WtVgs6Ji1jkMhYLatw++pmKPgAANQ3tA=;
        b=pWjnIzFG2yRNdjLONAFfnTM85qHpqt/QOh+KcRn18A/8u1KsNYF2Bl/idNA1c7Z1JT
         DtKhGkHo4Y/KQNm1Er3rjXC8wsnIoXtRjFYjoTmHJSTx3PaGGxv+GylGTzGAVafKa8DR
         wiLsIj5Z/6NAn0znU9OEe3m+WeZ31Oa+P6lxcUN1bqnFc0+86dwIo/ler89H3BP6BLKF
         I/VZfmElOHOD3T+QQE8A2s6+CfkrNKIOLzlqax4dbEPS2Mq6VBN6f38pNk+CC5qc2rnz
         nq4FbiR9pbJKt6coGFOr/tu9KvygK0esbPmYwbtdYtWOabEKyvMSipnBjimMWpdspfGI
         jwUA==
X-Forwarded-Encrypted: i=1; AL+hErFSMgJN5sWqbTAjHtxYRdxYoLJrrxNmuQmpbSTssPzJJy/nK9DhSNMoexy6GkZ98PWLUUKDGt5l8Q==@kvack.org
X-Gm-Message-State: APuU4Z9vza9Qi3/rEXM05PmIgxg71RtH1gNMzW0D537bo2NdRp1mgZj+
	Z7aWaLzsF4HFwJa1q60eW6GKFZ6pwmidJaEW41k9YkFRkfujpTJ8obNXoHNxMmdHxlIrEl0V5vN
	EKYVC5QH3rvO9Y4nrhgL8YR3CFELmLIYhs8Uiy/Fv
X-Gm-Gg: AYBFou1DP1a43wZ95AEm0KHRY0N4BaYrxdGAUKts0WKUz1w9INPj+JgtUPg780BmV1q
	M28+u5w6XrhILaCHO0pVoy/gK5ePU+5Cln7mhT/okyEkz55D6wXaZKCkL0uy1fcGJIVCGPsukLW
	yoK/2SMvslGwDG8bguKrzkGhlurHuhXHoo9vKLaGfr3nPfjDz45U1paCi4L04K6iFg8iGl3+8o8
	vC3AicpvRRh5rO5PYJqgWpAS60aZq3AX48FkxtU1GqrletJJrkh+/gF32CFtt7XuxLbTwMhzWdQ
	FFjILXMF7goG1+3FsAkxh4rFN5DhLc7gn4OOSG0fhGdIum5Ftlqwki4LfbWOBe9zb0e7oZMk47V
	AtsBDJ2eyFg6rDh3dzTZr0TLlgU9ZgwyDAn546dvdtJhhwQZMkBR8QhylU6I1uULgKR0QrlkWif
	3z3dLPHGiigzlUuPaDYXF9hhYcKJv6ysDOXf1IrdqWVvd9xQ43V01zbNyf+aYp5X4TIcJFecMAz
	CNfBfi5
X-Received: by 2002:a17:906:794c:b0:c42:82ac:b6a9 with SMTP id
 a640c23a62f3a-c5066b6baa7mr35192566b.29.1794348379456; Tue, 10 Nov 2026
 14:06:19 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261003002123.505555-1-jthoughton@google.com>
 <20261003002123.505555-7-jthoughton@google.com> <8814E4B3-5A5A-4874-863A-71FC6E4F3B34@linux.dev>
In-Reply-To: <8814E4B3-5A5A-4874-863A-71FC6E4F3B34@linux.dev>
From: James Houghton <jthoughton@google.com>
Date: Tue, 10 Nov 2026 14:05:42 -0800
X-Gm-Features: AclHuK9DP4E2SNlLaTNdiTkQr6q6QZ9Qonb4QaVlevADmVOep5O3eB7CHyRgUcM
Message-ID: <CADrL8HWepp70MNhsBgAhJsLbOW=ZqEWbKSuc9CUA7oLEpPT5sA@mail.gmail.com>
Subject: Re: [PATCH v2 06/20] hugetlb_vmemmap: Allow architectures to
 dynamically disallow HVO
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
X-Stat-Signature: 8c4xpsztqy8txnhdqi4f4or7wcm4u66n
X-Rspamd-Queue-Id: 68D4E1C0006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-23.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1794348381-533526
X-HE-Meta: U2FsdGVkX18NcVa0Md0Jdmd5ib/46ypLyM46S7fxH/R9ziBaW3HyvrR69PwgjS2kEeVVsw/cAz2FqhucBt+rjA5NPb6nAKmM94cvkdsqIgGn1fFeO2YdsOIyquX5hcN3k2DrGkHoQEvKuo9zi6vthKwMBlNdHUnAK1xVMQNxbC1pvsEInIMvVMkwdvNVAV6AfXI6hYXTXsmwdfwSkrqhFOTeM2LxS0ckkI5S4Vmlqjk7rxRZEQoZ6CgeOqNJ0zxha/w+mAP1xpbxnZxNDFgTZoKr8zzlIEJI9nqECtqm8IlzVrFrSEFAXrOToFWWEoTUd0GybIr8qp4sihsI6ABfGwqdg6scpUWoPb4oeRdxa/3T+wBRVPvOfeuODOFM8Z9GaKUKxdv8X/6AC8b2phEUsGn/AcRsTiHY2TxHxv3cYzJEv1ixdqSpnZf/PXQ3fxQgWig/XnCLNrzKPzHm1WquPe9RX0rax43LUPce+Dooz54z3AwDGjXgEGAkpoWKt7qWyTAQb3xcRA6I0lANYJgZ6K2LCujG5KdlzRuL+BUNppTesAVgwtVjrKOxmy7sQgN5+QN6VUzaqOCBmD7X7656RbuyzvxBK3jUgz232dP0Yue300K1RwnWQ715ZL7QLkT1p/pAoXVcgIGy94CXliGG9nIdUuitceXNUws4hI+6vdpqxuRaL1c0i9RO9/wyjAfv4SzjviMyqAkRRBPApQDlfzoWSg6XPQD6jxSxTXuU0TGvUzmGkIayPobeDoqALzInkfDhnwNs/wmOq/WQZ7370lFfcQWefWVIGS2YGTNsKSDT0fJCX+K2nvYyGdOrZGoDqlrZ5Gyy/xigWSOqt/fYPrHBnBvrSK45Von9CXQun/4/s49vYDh38y5GJBKD8kdjooQXGXTlB4HBsH+LhCKV2dZNFfhUUmVBjsBlZYwR06VWL0N4sQutz9Mr/6c+MdraGL2Me2uhKqi3Kb3EEXk
 vx8D7hNm
 4Tz+ckdOlN3DAYaQ0kyDQC7j70qATnoWSPe66hO6qHjklQeWDxl+UIrq/jDXrb+kgTHvZqfjBtwToMkUG00Z5cCyogjFmAVM0ZO/Sa4FtQKF+b8pgE6KHsVTjWKOo+3mk+1XYMnnuL85GrvwlAUG2ccTPf1Enb3bYMX6SQ0jUcqVzlGIGIRQ2GrJYSSX5ctHQsxqv8b0g4BQKzovYwjXJloECft1fpQracp6RN/S3pmSe/qcEiYaYfRHpbj4aZ6Jn3kxHxAsbS+0YtQu6U1a4ntu1Tp6+roTx1dh/PJ8vfrT/123qsKCwneLUvwMJS8zf5jj78j8vn74T5te3kzeSzi4AodcS/0+fd2Ka
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 6, 2026 at 10:44=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Oct 3, 2026, at 08:21, James Houghton <jthoughton@google.com> wrote:
> >
> > For arm64, only some platforms support HVO. Add an arch hook to prevent
> > HVO from taking affect if the architecture lacks support.
> >
> > It may be the case that arch_supports_hugetlb_vmemmap_optimization()
> > returns false at first but eventually returns true. This is the case on
> > arm64. When this happens, bootmem hugepages won't be immediately HVOed,
> > but they will be optimized in prep_and_add_bootmem_folios().
> >
> > Signed-off-by: James Houghton <jthoughton@google.com>
> > ---
> > include/asm-generic/hugetlb.h |  7 +++++++
> > mm/hugetlb_vmemmap.c          | 12 ++++++++++++
> > 2 files changed, 19 insertions(+)
> >
> > diff --git a/include/asm-generic/hugetlb.h b/include/asm-generic/hugetl=
b.h
> > index 635c41cc3479..8d24075d53d4 100644
> > --- a/include/asm-generic/hugetlb.h
> > +++ b/include/asm-generic/hugetlb.h
> > @@ -128,4 +128,11 @@ static inline bool gigantic_page_runtime_supported=
(void)
> > }
> > #endif /* __HAVE_ARCH_GIGANTIC_PAGE_RUNTIME_SUPPORTED */
> >
> > +#ifndef __HAVE_ARCH_HVO_SUPPORTED
> > +static inline bool arch_hugetlb_vmemmap_optimization_supported(void)
>
> I suggest using arch_support_vmemmap_remap (see [1]), which can also be
> applied to FS-DAX.
>
> [1] https://lore.kernel.org/all/20260903122128.12264-2-songmuchun@bytedan=
ce.com/
>
> > +{
> > +     return IS_ENABLED(CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP);
> > +}
> > +#endif /* __HAVE_ARCH_HVO_SUPPORTED */
> > +
> > #endif /* _ASM_GENERIC_HUGETLB_H */
> > diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> > index 3fdb1e4ce1a1..8596a462fee6 100644
> > --- a/mm/hugetlb_vmemmap.c
> > +++ b/mm/hugetlb_vmemmap.c
> > @@ -16,6 +16,7 @@
> > #include <linux/pagewalk.h>
> > #include <linux/pgalloc.h>
> > #include <linux/vmemmap-optimization.h>
> > +#include <linux/hugetlb.h>
> >
> > #include <asm/tlbflush.h>
> > #include "hugetlb_vmemmap.h"
> > @@ -529,6 +530,9 @@ static bool vmemmap_should_optimize_folio(const str=
uct hstate *h, struct folio *
> >       if (!READ_ONCE(vmemmap_optimize_enabled))
> >               return false;
> >
> > +     if (!arch_hugetlb_vmemmap_optimization_supported())
> > +             return false;
> > +
> >       if (!hugetlb_vmemmap_optimizable(h))
> >               return false;
> >
> > @@ -731,6 +735,14 @@ void __init hugetlb_vmemmap_optimize_bootmem_page(=
unsigned long pfn, unsigned in
> >       if (!READ_ONCE(vmemmap_optimize_enabled))
> >               return;
> >
> > +     /*
> > +      * Architectures may return false here but true by the time
> > +      * hugetlb_init() is called. In this case, although the folios wi=
ll
> > +      * not be pre-HVOed, they will be optimized in hugetlb_init().
> > +      */
> > +     if (!arch_hugetlb_vmemmap_optimization_supported())
> > +             return;
>
> I plan to add a new helper, section_vmemmap_optimization_disable() [2],
> intended to disable vmemmap optimization in the architectural vmemmap
> population path. Since arm64 does not support section-based vmemmap
> optimization, section_vmemmap_optimization_disable() should be used there=
.
>
> [2] https://lore.kernel.org/all/20261107043122.25650-3-songmuchun@bytedan=
ce.com/

Thanks! I'll integrate both of these into v3.

