Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 972FACAC58E
	for <linux-mm@archiver.kernel.org>; Sun, 14 Sep 2025 02:22:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEFAB8E0002; Sat, 13 Sep 2025 22:22:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA07B8E0001; Sat, 13 Sep 2025 22:22:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8F418E0002; Sat, 13 Sep 2025 22:22:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A233F8E0001
	for <linux-mm@kvack.org>; Sat, 13 Sep 2025 22:22:40 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 38BAE57724
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:22:40 +0000 (UTC)
X-FDA: 83886257280.20.7BAF8C1
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9C68940003
	for <linux-mm@kvack.org>; Sun, 14 Sep 2025 02:22:37 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XZu0N8C1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757816557; a=rsa-sha256;
	cv=none;
	b=TlJ7uT12Gr7NnU+bjLbJkJzzUmiPW9VDQL1sb+SXpsrV+P2YxSwgBD2uEB5LFstAxAa8iM
	kA/vineYVuYrtoiBK8OWSSE/q+orgfTicdLQCtoKtAooEl7ELny8ookgUDjte/nOiKokM/
	m/4WYOx57L/2stj4YXZnuLrWpbhekF4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XZu0N8C1;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf04.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.52 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757816557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+ZSjIvJ+U0wDv91HR/wWMkH01+c2dAzW/GofNytLcEw=;
	b=Cl3JdsKwM9kOBKeFwx2bnkCjis4gwZl3eyDifHjAD6MoQx0jBdu6m5dBpZlciSnsLlCNdh
	nzRBFAr3I2k0Etg4veL3iugtSDFtB6SaS+4xInHEugOApdgUclPmuaW4C81wdT/LzoAagL
	tPuDz1ldcq4RFXVyks7ZOLhYUAM6+Yo=
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-71b9d805f2fso31154406d6.0
        for <linux-mm@kvack.org>; Sat, 13 Sep 2025 19:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757816557; x=1758421357; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ZSjIvJ+U0wDv91HR/wWMkH01+c2dAzW/GofNytLcEw=;
        b=XZu0N8C1HVGW+PPKKuEbhSUGib+N6DHllh/Rfvlg0UR8clwVwmQPfz+O4OXSa5OY0O
         WfHgYiEq49CxHfbzuhxGx2HOeCkX0pLAgW5gznNQpi0pZ24fdkTOUaSpFhnADhnMMrtw
         LABaNQKohfqscZlCUO5Z3gYWTgaTnbTJE6gNJdR8yzd6moA5cTEhESrDqG/BVyxnRPzD
         7eYYmrsI/BldrwVPNkkJrPlsBwGnFS4VqUtdY1vMibZ99yFEEhSgP6Oj/WD88jUl9YYd
         WeVxX6/Ag+E4skiZpERvx6181zd373koQnVCfjpoPwdHug6+CD2XAASZB+jYJ+2cVGQ1
         BAaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757816557; x=1758421357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+ZSjIvJ+U0wDv91HR/wWMkH01+c2dAzW/GofNytLcEw=;
        b=RP7OBhpKE9G67sLsb1V8lgkDQ9iAaLu+A/dBb5BoTpvwBp45sMXLHEMGGrcjHYMVpO
         RAmUaefk/BDljrAyF5WRRpytdMWfSm1Bct8QDKtsgC5TtAi5OqJwdiqBhhirrjL2raxw
         cuKpE7weDLR1I+NUwiSTaZ56yMfbJSsbPiaCVvSRalk2NA6GdNeKfHa35pgP1Afu/et1
         wa3kSQOeBNBRRhTOzYqa2rFa3IqFaqWjPMinoJsNnuso++HP1EtZ1ylBjOkENBAd+lb3
         AYag7t5Ou0Wwx63jb/puMMSAs8vEVX1xg7+szVWfF/1yL0DUPqiQLuQc0HhnjZwoiFkT
         fLoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXe40xd2XN3lxrtM3Mb6Zy2/oafObCiapqnj77OEZnK8G6KCeLXh7GqqJekZL/QgFXvBxAETdNC9A==@kvack.org
X-Gm-Message-State: AOJu0YyAMQRATc5r8XYZvzteceJCs3OUCOmZ6tYRVq+8fh7SrmBWpxJM
	mDsjfF8KnqahtR0pHx7Z30pQxU9OxGcuf7tW+DKV7mPMwMsHHUW/DcU3QFJyKPGl2U+3n2rGHW9
	yGrzTs0Iku82O2RcON+XLzt24ZmqfxQQ=
X-Gm-Gg: ASbGncuFLS+V0DWjLR8RLbiFuZbYDiqsVm9D6J60qQW71B+lE+B886WWVULwkzUYlA4
	CvT4InFGpw57YAOE8B2E3KpOzyLCVyHgup719EdBDiNoKib4ZCm8Z4sLd4onifsLVQZ9YxreE9W
	EWqC09muzg2rBf9R2aTqyR97Sqq7OLbjy4qa0gIdJN3emnSkvwYSRlpxxkpEtvIeqxLm1txrmAX
	ZSdYfajT+QSfzW2fUXCkuO8hoXC1SLLt/1zj4Eq
X-Google-Smtp-Source: AGHT+IEq1YvG6zbL6Ygo8UozQLCnIYEHff8lBMP5IeSQyHEJHGe/PDTCbiqIOBQGWJ+udPp+lSW5A67VTVSgMp5OR/E=
X-Received: by 2002:a05:6214:6108:b0:769:11cc:6506 with SMTP id
 6a1803df08f44-76911cc66camr81227676d6.15.1757816556561; Sat, 13 Sep 2025
 19:22:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
 <4d676324-adc6-4c4c-9d2b-a5e9725bcd6c@lucifer.local> <CALOAHbB_jrsgEMH=HNozW+rASRLwiy9+QtspmSgM7jtZJMthXg@mail.gmail.com>
 <59432a1d-9b70-4257-aafe-0adb68db4c9f@lucifer.local>
In-Reply-To: <59432a1d-9b70-4257-aafe-0adb68db4c9f@lucifer.local>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 14 Sep 2025 10:22:00 +0800
X-Gm-Features: AS18NWAAP_Q4ZYAPxNiOveX2Fqvb-mAGv7veWF4qhs1GCX2qEv_7YQSXYufBWUY
Message-ID: <CALOAHbB2Z08AZ+QFXiZB_DX2Qm2xBDf=k_pLmdxuyQqpW_6a_A@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com, 
	ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org, 
	usamaarif642@gmail.com, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9C68940003
X-Stat-Signature: tbbtymraeshixj9ihm3gjzxwtjc6mttf
X-Rspam-User: 
X-HE-Tag: 1757816557-726736
X-HE-Meta: U2FsdGVkX1+37uW2dZ9Q4oHIS3LwOOTIenXBDLhY5y3P63mB01i0YbavVB43+RazdwJN8RIOgfC01CtIoeCoxipQAoLcNLCg8hTtpbmYltNd9XoGX7Q1fIpFQxfKOPWn0wnC1+TJQk53fCR3rNH/VXRgrEWfZ/JpQDMqOmPJ9idK9o4RMWrkPiaAbajjUc1SdS3RSiB8QYuL/pfjk4++7NvZwpeG7eEFvNMliAWqU01/8JHh5vfoQsJbq/HZ2Od5Jnht3CCvg5XnVc4q79foOCiUyxEezIRhGQdrPDmXOK3TGRStBDcrSfO1gLhqk8ReFMZXvR4YrClgwcOD0eOEvxTNRBJO6btRyWFv3e2GrWTeEfmWuNUzvpezlVZoZDU8woeAEuhpTDdFoI64yVtG7+wz7NmK7T4usSqPlsYuE6PtnaJJKhecltntk5wh/QO1GI+RjuWYZNxbRIQbobRqXbpvGHoYy0GjGd60TAW45sA0eWmrKlLz+Owp7/tMBA6mBEnjciWpI1nVvSM85DwhC0bXf4ug5xwDCQSA1DkdEuQCK9TbrnO/XwBFF1Xc1rg0uYAb6yTLkaVqDF+zxqcQ6vEPdJY5OJpihHrJfmnSTJOr9fzCHA2o7m1rvmsyuIXx1rVcn5D9QyD6qt1qW5w3+Id+4pfukDDzXHHqKhOSs55OaCGwlOyJB174c9ngtszies76QJfTP6UoLN0lv/BCuyj7O9Odw9xCC95UjG0Tex+JF5HBvF/va+uEHP0SnKqpRyi5xVcuqsLT4kN4FJNdkYl8Sl2aD/ujsdDC2iOi3ndo0+g/CLgBhqrIIgxXLoDDkioP1u9621byJvTkLrhNXIMMRj0HG9YUug4mL2+ngYCWmz1FNwVQRE3DLieDBWhX0d7gm96WlGe73AMwRKsdANkDRuhtM9Nh7eqE6PL2RyMDpA5v0RtYu/r8K8Ekdv0QMcZmcz3i0rj6h/+iueM
 WDMrRog+
 EA6omLGH/QBBdRmhAZeB6PW4cioKWZFt2Ai+/19SubuTVp5oF9r8Wj/LcH8UiKKnxEi57be9xcsIXV3FevJ3hjGD2gguYpq7pwapnJv1bjqC3EBJfJABxG6UKBYvxLhenToOEyCrM9MPQHhAS2gIbwePCsqLbr/kOznNfzhCO7U9asWTOE8VAtlA+URzm7j6PprBytUJSqozMeoLsk1gLjmXIQY9Db7QRxgRnczG0knU+M2EQUsPxQlO4p86nXuBsltNQF7Y9ep7n0QAaLOlKy26zCx2pPNw7l88JWl7iQu7e4TGBoPrBn8hzHswa1hXb4xffsEHM4rcze8H4Ul1EmxfKhqANRkMAbYvIvSG7mdTxlK4+k41wEidusyGvvEYKMaTv0jxxz6C7sCbk1WtGc0NWxgn+mo8Xt0Y2ZEMOZh1/HRobiqtqthC3fsgETa4S3iMHfF4LoyRYnLQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 12, 2025 at 7:53=E2=80=AFPM Lorenzo Stoakes
<lorenzo.stoakes@oracle.com> wrote:
>
> On Fri, Sep 12, 2025 at 04:28:46PM +0800, Yafang Shao wrote:
> > On Thu, Sep 11, 2025 at 10:34=E2=80=AFPM Lorenzo Stoakes
> > <lorenzo.stoakes@oracle.com> wrote:
> > >
> > > On Wed, Sep 10, 2025 at 10:44:39AM +0800, Yafang Shao wrote:
> > > > This patch introduces a new BPF struct_ops called bpf_thp_ops for d=
ynamic
> > > > THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing B=
PF
> > > > programs to influence THP order selection based on factors such as:
> > > > - Workload identity
> > > >   For example, workloads running in specific containers or cgroups.
> > > > - Allocation context
> > > >   Whether the allocation occurs during a page fault, khugepaged, sw=
ap or
> > > >   other paths.
> > > > - VMA's memory advice settings
> > > >   MADV_HUGEPAGE or MADV_NOHUGEPAGE
> > > > - Memory pressure
> > > >   PSI system data or associated cgroup PSI metrics
> > > >
> > > > The kernel API of this new BPF hook is as follows,
> > > >
> > > > /**
> > > >  * @thp_order_fn_t: Get the suggested THP orders from a BPF program=
 for allocation
> > > >  * @vma: vm_area_struct associated with the THP allocation
> > > >  * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEP=
AGE is set
> > > >  *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF=
_THP_VM_NONE if
> > > >  *            neither is set.
> > > >  * @tva_type: TVA type for current @vma
> > > >  * @orders: Bitmask of requested THP orders for this allocation
> > > >  *          - PMD-mapped allocation if PMD_ORDER is set
> > > >  *          - mTHP allocation otherwise
> > > >  *
> > > >  * Return: The suggested THP order from the BPF program for allocat=
ion. It will
> > > >  *         not exceed the highest requested order in @orders. Retur=
n -1 to
> > > >  *         indicate that the original requested @orders should rema=
in unchanged.
> > > >  */
> > > > typedef int thp_order_fn_t(struct vm_area_struct *vma,
> > > >                          enum bpf_thp_vma_type vma_type,
> > > >                          enum tva_type tva_type,
> > > >                          unsigned long orders);
> > > >
> > > > Only a single BPF program can be attached at any given time, though=
 it can
> > > > be dynamically updated to adjust the policy. The implementation sup=
ports
> > > > anonymous THP, shmem THP, and mTHP, with future extensions planned =
for
> > > > file-backed THP.
> > > >
> > > > This functionality is only active when system-wide THP is configure=
d to
> > > > madvise or always mode. It remains disabled in never mode. Addition=
ally,
> > > > if THP is explicitly disabled for a specific task via prctl(), this=
 BPF
> > > > functionality will also be unavailable for that task.
> > > >
> > > > This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL=
) to be
> > > > enabled. Note that this capability is currently unstable and may un=
dergo
> > > > significant changes=E2=80=94including potential removal=E2=80=94in =
future kernel versions.
> > >
> > > Thanks for highlighting.
> > >
> > > >
> > > > Suggested-by: David Hildenbrand <david@redhat.com>
> > > > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > > > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > > > ---
> > > >  MAINTAINERS             |   1 +
> > > >  include/linux/huge_mm.h |  26 ++++-
> > > >  mm/Kconfig              |  12 ++
> > > >  mm/Makefile             |   1 +
> > > >  mm/huge_memory_bpf.c    | 243 ++++++++++++++++++++++++++++++++++++=
++++
> > > >  5 files changed, 280 insertions(+), 3 deletions(-)
> > > >  create mode 100644 mm/huge_memory_bpf.c
> > > >
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index 8fef05bc2224..d055a3c95300 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -16252,6 +16252,7 @@ F:    include/linux/huge_mm.h
> > > >  F:   include/linux/khugepaged.h
> > > >  F:   include/trace/events/huge_memory.h
> > > >  F:   mm/huge_memory.c
> > > > +F:   mm/huge_memory_bpf.c
> > >
> > > THanks!
> > >
> > > >  F:   mm/khugepaged.c
> > > >  F:   mm/mm_slot.h
> > > >  F:   tools/testing/selftests/mm/khugepaged.c
> > > > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > > > index 23f124493c47..f72a5fd04e4f 100644
> > > > --- a/include/linux/huge_mm.h
> > > > +++ b/include/linux/huge_mm.h
> > > > @@ -56,6 +56,7 @@ enum transparent_hugepage_flag {
> > > >       TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
> > > >       TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
> > > >       TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
> > > > +     TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attach=
ed */
> > > >  };
> > > >
> > > >  struct kobject;
> > > > @@ -270,6 +271,19 @@ unsigned long __thp_vma_allowable_orders(struc=
t vm_area_struct *vma,
> > > >                                        enum tva_type type,
> > > >                                        unsigned long orders);
> > > >
> > > > +#ifdef CONFIG_BPF_GET_THP_ORDER
> > > > +unsigned long
> > > > +bpf_hook_thp_get_orders(struct vm_area_struct *vma, vm_flags_t vma=
_flags,
> > > > +                     enum tva_type type, unsigned long orders);
> > >
> > > Thanks for renaming!
> > >
> > > > +#else
> > > > +static inline unsigned long
> > > > +bpf_hook_thp_get_orders(struct vm_area_struct *vma, vm_flags_t vma=
_flags,
> > > > +                     enum tva_type tva_flags, unsigned long orders=
)
> > > > +{
> > > > +     return orders;
> > > > +}
> > > > +#endif
> > > > +
> > > >  /**
> > > >   * thp_vma_allowable_orders - determine hugepage orders that are a=
llowed for vma
> > > >   * @vma:  the vm area to check
> > > > @@ -291,6 +305,12 @@ unsigned long thp_vma_allowable_orders(struct =
vm_area_struct *vma,
> > > >                                      enum tva_type type,
> > > >                                      unsigned long orders)
> > > >  {
> > > > +     unsigned long bpf_orders;
> > > > +
> > > > +     bpf_orders =3D bpf_hook_thp_get_orders(vma, vm_flags, type, o=
rders);
> > > > +     if (!bpf_orders)
> > > > +             return 0;
> > >
> > > I think it'd be easier to just do:
> > >
> > >         /* The BPF-specified order overrides which order is selected.=
 */
> > >         orders &=3D bpf_hook_thp_get_orders(vma, vm_flags, type, orde=
rs);
> > >         if (!orders)
> > >                 return 0;
> >
> > good suggestion!
>
> Thanks, though this does come back to 'are we masking on orders' or not.
>
> Obviously this is predicated on that being the case.
>
> > > >  struct thpsize {
> > > > diff --git a/mm/Kconfig b/mm/Kconfig
> > > > index d1ed839ca710..4d89d2158f10 100644
> > > > --- a/mm/Kconfig
> > > > +++ b/mm/Kconfig
> > > > @@ -896,6 +896,18 @@ config NO_PAGE_MAPCOUNT
> > > >
> > > >         EXPERIMENTAL because the impact of some changes is still un=
clear.
> > > >
> > > > +config BPF_GET_THP_ORDER
> > >
> > > Yeah, I think we maybe need to sledgehammer this as already Lance was=
 confused
> > > as to the permenancy of this, and I feel that users might be too, eve=
n with the
> > > '(EXPERIMENTAL)' bit.
> > >
> > > So maybe
> > >
> > > config BPF_GET_THP_ORDER_EXPERIMENTAL
> > >
> > > Just to hammer it home?
> >
> > ack
>
> Thanks!
>
> >
> > >
> > > > +     bool "BPF-based THP order selection (EXPERIMENTAL)"
> > > > +     depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
> > > > +
> > > > +     help
> > > > +       Enable dynamic THP order selection using BPF programs. This
> > > > +       experimental feature allows custom BPF logic to determine o=
ptimal
> > > > +       transparent hugepage allocation sizes at runtime.
> > > > +
> > > > +       WARNING: This feature is unstable and may change in future =
kernel
> > > > +       versions.
> > > > +
> > > >  endif # TRANSPARENT_HUGEPAGE
> > > >
> > > >  # simple helper to make the code a bit easier to read
> > > > diff --git a/mm/Makefile b/mm/Makefile
> > > > index 21abb3353550..f180332f2ad0 100644
> > > > --- a/mm/Makefile
> > > > +++ b/mm/Makefile
> > > > @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) +=3D migrate.o
> > > >  obj-$(CONFIG_NUMA) +=3D memory-tiers.o
> > > >  obj-$(CONFIG_DEVICE_MIGRATION) +=3D migrate_device.o
> > > >  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) +=3D huge_memory.o khugepaged.o
> > > > +obj-$(CONFIG_BPF_GET_THP_ORDER) +=3D huge_memory_bpf.o
> > > >  obj-$(CONFIG_PAGE_COUNTER) +=3D page_counter.o
> > > >  obj-$(CONFIG_MEMCG_V1) +=3D memcontrol-v1.o
> > > >  obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
> > > > diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> > > > new file mode 100644
> > > > index 000000000000..525ee22ab598
> > > > --- /dev/null
> > > > +++ b/mm/huge_memory_bpf.c
> > > > @@ -0,0 +1,243 @@
> > > > +// SPDX-License-Identifier: GPL-2.0
> > > > +/*
> > > > + * BPF-based THP policy management
> > > > + *
> > > > + * Author: Yafang Shao <laoar.shao@gmail.com>
> > > > + */
> > > > +
> > > > +#include <linux/bpf.h>
> > > > +#include <linux/btf.h>
> > > > +#include <linux/huge_mm.h>
> > > > +#include <linux/khugepaged.h>
> > > > +
> > > > +enum bpf_thp_vma_type {
> > > > +     BPF_THP_VM_NONE =3D 0,
> > > > +     BPF_THP_VM_HUGEPAGE,    /* VM_HUGEPAGE */
> > > > +     BPF_THP_VM_NOHUGEPAGE,  /* VM_NOHUGEPAGE */
> > > > +};
> > >
> > > I'm really not so sure how useful this is - can't a user just ascerta=
in this
> > > from the VMA flags themselves?
> >
> > I assume you are referring to checking flags from vma->vm_flags.
> > There is an exception where we cannot use vma->vm_flags: in
> > hugepage_madvise(), which calls khugepaged_enter_vma(vma, *vm_flags).
> >
> > At this point, the VM_HUGEPAGE flag has not been set in vma->vm_flags
> > yet. Therefore, we must pass the separate *vm_flags variable.
> > Perhaps we can simplify the logic with the following change?
>
> Ugh god.
>
> I guess this is the workaround for the vm_flags thing right.
>
> >
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 35ed4ab0d7c5..5755de80a4d7 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -1425,6 +1425,8 @@ static int madvise_vma_behavior(struct
> > madvise_behavior *madv_behavior)
> >         VM_WARN_ON_ONCE(madv_behavior->lock_mode !=3D MADVISE_MMAP_WRIT=
E_LOCK);
> >
> >         error =3D madvise_update_vma(new_flags, madv_behavior);
> > +       if (new_flags & VM_HUGEPAGE)
> > +               khugepaged_enter_vma(vma);
>
> Hm ok, that's not such a bad idea, though ofc this should be something li=
ke:
>
>         if (!error && (new_flags & VM_HUGEPAGE))
>                 khugepaged_enter_vma(vma);

ack

>
> And obviously dropping this khugepaged_enter_vma() from hugepage_madvise(=
).

Thanks for the reminder.

--=20
Regards
Yafang

