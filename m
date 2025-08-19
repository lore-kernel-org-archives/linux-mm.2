Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67038CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 11:43:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0596B0108; Tue, 19 Aug 2025 07:43:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0617A6B011F; Tue, 19 Aug 2025 07:43:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EB8F46B0120; Tue, 19 Aug 2025 07:43:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D96BD6B0108
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 07:43:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 683F6BA913
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:43:46 +0000 (UTC)
X-FDA: 83793322452.08.AC5B2EC
Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	by imf11.hostedemail.com (Postfix) with ESMTP id 7E4EA4000F
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 11:43:44 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R7NLieVF;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755603824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XDRl7pKGEPhnsDQ32deXqvH+LFVXgPlPNsW5Pg/4+Lw=;
	b=aWrQdigFhSdJuBVEmEHyLqPkHjr208xF9XSuT3N0ErLDXuzXp9P7SxuUiCQByuXqLw6s+3
	dN2dxjRlsrYJWVLc5GHb1Id3sJT53VSiPDnlIjFg/BV/Rc7Z2IuDoquvJb0N/FpNU7Ergy
	pfDz747p505AKeMq7isrtQlhLWgnkV4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=R7NLieVF;
	spf=pass (imf11.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.41 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755603824; a=rsa-sha256;
	cv=none;
	b=wBreu77gUrucg5Uo0wlJW9JgcmZP6ejWWnsoRD6xiWBHfCE/WSGIg/JyCFN3lBoNv36RQG
	MO64Aq8YtpCezP4T0aN+u7SSw+r4fBpt7y9JTty/ahh7esliqnbpiD+zK6hYmQ9M+5ndaB
	yBGPzoiHvekOr0PEsxDxyFM8oCgfCpw=
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-70ba7aa1300so28000676d6.1
        for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755603823; x=1756208623; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XDRl7pKGEPhnsDQ32deXqvH+LFVXgPlPNsW5Pg/4+Lw=;
        b=R7NLieVFfMP+RiKkmvN4NVJXxZ7TQvjNTYzsvkeFLDV4yCXZRIlLW79v6iOwD+rbYc
         lqV4KeZCb45OSswjpHYDeSWzrsOSWcQpEneJ7MxdhN0Cc798YfhrT6r4FXmGhhHiHsx6
         ePDjhSWk4ECstOxj3IRElVly+gY18BfvqQ2sCQLXptiUes1AougXSNXT9H2uv2GDgN3f
         81JjhDHi2dEil7ovHigCx+WJshfc8UoxwBZpwRrzuzismptsyyLQ9qdtzsA0lLedEbnl
         pzvmBBIAmfjY4RbLXdSOSaKF8DUEq49fuH+BEGHh7Zw5CXE7DDhR0VFyIEWh/u0wawOl
         w/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755603823; x=1756208623;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XDRl7pKGEPhnsDQ32deXqvH+LFVXgPlPNsW5Pg/4+Lw=;
        b=HBKRxjgskwA+XuW1vraczV2IrHPk8BTtpSHZJT2vKvjrZPIIotx07qSX1o0sCABpCA
         2e17YsrQc923+qzJoMF9Q/1yyESm92BMWQSX6kjINREOnTmCQBRMUvnTkzaXeRaDjexB
         RPFgifj6BHVtxvrsDGcmTGkLSgjwxQXFL8Qu+8EYi8J9bivRy92zORAdesZaddxxUu5g
         BvY60qminz+yCCahaUzGXdEM8EFJKGT9olrH13CvLsMYU3MFl9o4e2a0wEXJhp4LVf28
         3T5leRq4Dak9OSC/qkMp6/ijtus7bji8I4U6BA7wdAvjoeb06vDQeYPtbJqzIV2MHg9g
         LqnA==
X-Forwarded-Encrypted: i=1; AJvYcCUHgp1QMO+1ZbOVp/77MrERbmXrZ4WeNUI+N6fB//uzI+tHpnWBMs8zuHaLTMTTlpqcyguok6hU7A==@kvack.org
X-Gm-Message-State: AOJu0YxGFV3dpk4vVUndGrZIkZTpQXPMIBPf7SB1MDGkV87d0QagGZKz
	V7XzI6cEJM8T9kVofsorCnpjv18fJ7K3dx/ssKOA4cm7jN6CpJdPYwxEGvKv+hpyV+L8Q5lQ1w6
	YS/3S99q+vFHC5zF/IXSk5S4/uvBWCmI=
X-Gm-Gg: ASbGncvzvHbLrHGWuiGgJOAV/Z09tCqXEr4elFpTNTsmAgIu7ls32xlbCePIcv3BdaA
	hSHn8ST7+AHvL7VyF0kqbo3xtjaOPZEwM1rkIF1DqWVCFGv0crK2ykeNSpCwzhjqT7Q/prPz1PU
	5zb06T1Y1sKl29khT2mAi6/BrTwOKkHawp1Z/RiVvSV4tnFcM190qht3MvTnjXn6+OkmuHp6uma
	IxpJVjX
X-Google-Smtp-Source: AGHT+IEQRWZETfw6TaV/Y1cUt7is0ycsbkU7AHy2XqNr3gdTaWPTaHfu5jkl9lEXDNCudr183a6YgCdHfI6RtNDb1ok=
X-Received: by 2002:ad4:5dc6:0:b0:709:ded9:5b1a with SMTP id
 6a1803df08f44-70c35c4334dmr22879126d6.46.1755603823087; Tue, 19 Aug 2025
 04:43:43 -0700 (PDT)
MIME-Version: 1.0
References: <20250818055510.968-1-laoar.shao@gmail.com> <20250818055510.968-2-laoar.shao@gmail.com>
 <0caf3e46-2b80-4e7c-91aa-9d7ed5fe4db9@gmail.com> <7d458b5a-6920-472a-a83c-764c0f00c156@huawei-partners.com>
In-Reply-To: <7d458b5a-6920-472a-a83c-764c0f00c156@huawei-partners.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 19 Aug 2025 19:43:06 +0800
X-Gm-Features: Ac12FXzk9DmQtD2Uz1DTnkhYCjCO22SJ0c7s_qBMz0mjC82X5cx-i_o2T2iAogU
Message-ID: <CALOAHbA9nWKE1QWxxMyXyAPqMr=43MmNw9=K37PXF9tJMS1rpA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 mm-new 1/5] mm: thp: add support for BPF based THP
 order selection
To: Gutierrez Asier <gutierrez.asier@huawei-partners.com>
Cc: Usama Arif <usamaarif642@gmail.com>, akpm@linux-foundation.org, david@redhat.com, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, bpf@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: p3cdhdcidgct78ati8sgebup5ptzkjt9
X-Rspam-User: 
X-Rspamd-Queue-Id: 7E4EA4000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1755603824-660624
X-HE-Meta: U2FsdGVkX1814+HnO8pgXw7PlTjbe4ODr52WxkjRsD2vPAm755779DiUAslBMx1z9zBrEgqTGgHBIQHTKpLlvVTTt2LL/E0KdZesoczEHME8bFY09IEbHv3Mgr5eXWswUDPPlC7lMkjUmcE1P6Rgp34+7wBaWl4tEqpzkWUF5kUmrDpNzO6RzhbSh5pPTMGCnE9dpC++pq6cPsARJLRE+0XJVj+78X1FhRr1ys2V5vB4Zezg9Z/rQI+KjF4pWICcoM1kkHeGhdHK2MEeUpTgz8NNIFdFafKkqzMvQ98Rdg1P/OxC2ocXrRfZ4nSgT3n16Lifs3OCg1iTdwQgfvxSXz3wZPVhpauyBYxof5owVtZfVNd64iwO0H8KeQDdTBZgiCLgfQQjgPkNKd5rv7p5J3xRxbD1GdSMFfNmcPWX/umpIuvpmRA9syarHi+1MAeIsBQKzWsBR7TJvPVDqTk2AYzEmI2jQOjL4fS95ORbyQM9XakcoAoyE7+gyDqpDmsZBa76JnBBA2f5A+YtDF/WT3P6SyISaDXbYN/Tnf0jKFhijSEcZWwFQTTMSMdCqzliZycHHjf7oQ9yjYMAW156RYQYgNrmFif7hJRmm5WbC5byH/1/AU2Cbv4uMiAsgm+fQQxwL7qd+raTOtwOzORDzZ12xQu6Q4RoR3JjyE4WijSzhG3rNKP4sTT+NmiQMwn6eWN/+yKctDXB/6Lq/RQsaCF81/OSwdY/CNRxJgli1zOAxy41Dz+6jBkf6vLe/gkvpmd4i6znKH9iKlxPfhvxRJ5dIRqk+aZNHHESRRFnR8WbiVNT43MBlUUNICiPZ6PEtpOOKLKglf41oX7i13m78J1m9Nrv+T1tEF37HMpXxzWRi1TFgKxTmwuuvySMd3isiVXxksExsynOyZRwgp/8Jtid9qOR8zfwQnmpgIIHH6AhPa/AG75LWMCIX9d9k3dBlsBXcIocHp3p/7It54u
 3n0xdDkC
 mQp6Cfb6BIHY6s/Np98oLVApTM1LugrPxWmJLfj55qj0TtpA+3YWgjP+v38VgWZUSj8raGja0g2yah8990CS/fiY+R2KT/tXpGnycl3sN16eLA4YqeJtLFnoJwhJFLz8Xv5lvuKmoAjyw8tu44m5Imp9mvkx/HgucuTSb1NbVI2+Iaz8mSd/DsQPkpkf16xbMlvP4uLqcdrg8Or9wi7gZGd2eVk6uH+4uYj23uLHwipXj7oMP3Nsd21jlFcb4CEiNEhbL6Lc8pA6oGoxt3M7CYkQDFMcrRYJlFnzEZXypHqGA+BC6kJO21Ux8rF5F2Qk4IRD5fPZg95xCU9YedJDxf+Acbob4rIKffM8/nsYlRflKj3assVXilo6qMsOqoptnewgms4Q5endw5f0wbhd3Udusu5/xFT1hsK2IDtX43dSOuCxTIfBqo01DH37ZpyvidrEw8QM3o70CBY9inpu4J1JNbpBuHljO04akUa727+OeigeytntSX2veEc6DaSJl5XDKolbPgSAwLtF5OdqooaKHI4Y1nSlX6jJQ6Th6jtPTjblZdCJLAQDRB9gUMl8z6H+BbObzkceHYvOy403chuDHYtJ/TxAS7NZb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 19, 2025 at 7:11=E2=80=AFPM Gutierrez Asier
<gutierrez.asier@huawei-partners.com> wrote:
>
> Hi,
>
> On 8/18/2025 4:17 PM, Usama Arif wrote:
> >
> >
> > On 18/08/2025 06:55, Yafang Shao wrote:
> >> This patch introduces a new BPF struct_ops called bpf_thp_ops for dyna=
mic
> >> THP tuning. It includes a hook get_suggested_order() [0], allowing BPF
> >> programs to influence THP order selection based on factors such as:
> >> - Workload identity
> >>   For example, workloads running in specific containers or cgroups.
> >> - Allocation context
> >>   Whether the allocation occurs during a page fault, khugepaged, or ot=
her
> >>   paths.
> >> - System memory pressure
> >>   (May require new BPF helpers to accurately assess memory pressure.)
> >>
> >> Key Details:
> >> - Only one BPF program can be attached at a time, but it can be update=
d
> >>   dynamically to adjust the policy.
> >> - Supports automatic mTHP order selection and per-workload THP policie=
s.
> >> - Only functional when THP is set to madise or always.
> >>
> >> It requires CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION to enable. [1]
> >> This feature is unstable and may evolve in future kernel versions.
> >>
> >> Link: https://lwn.net/ml/all/9bc57721-5287-416c-aa30-46932d605f63@redh=
at.com/ [0]
> >> Link: https://lwn.net/ml/all/dda67ea5-2943-497c-a8e5-d81f0733047d@luci=
fer.local/ [1]
> >>
> >> Suggested-by: David Hildenbrand <david@redhat.com>
> >> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> >> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> >> ---
> >>  include/linux/huge_mm.h    |  15 +++
> >>  include/linux/khugepaged.h |  12 ++-
> >>  mm/Kconfig                 |  12 +++
> >>  mm/Makefile                |   1 +
> >>  mm/bpf_thp.c               | 186 ++++++++++++++++++++++++++++++++++++=
+
> >>  mm/huge_memory.c           |  10 ++
> >>  mm/khugepaged.c            |  26 +++++-
> >>  mm/memory.c                |  18 +++-
> >>  8 files changed, 273 insertions(+), 7 deletions(-)
> >>  create mode 100644 mm/bpf_thp.c
> >>
> >> diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> >> index 1ac0d06fb3c1..f0c91d7bd267 100644
> >> --- a/include/linux/huge_mm.h
> >> +++ b/include/linux/huge_mm.h
> >> @@ -6,6 +6,8 @@
> >>
> >>  #include <linux/fs.h> /* only for vma_is_dax() */
> >>  #include <linux/kobject.h>
> >> +#include <linux/pgtable.h>
> >> +#include <linux/mm.h>
> >>
> >>  vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf);
> >>  int copy_huge_pmd(struct mm_struct *dst_mm, struct mm_struct *src_mm,
> >> @@ -56,6 +58,7 @@ enum transparent_hugepage_flag {
> >>      TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
> >>      TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
> >>      TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
> >> +    TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached *=
/
> >>  };
> >>
> >>  struct kobject;
> >> @@ -195,6 +198,18 @@ static inline bool hugepage_global_always(void)
> >>                      (1<<TRANSPARENT_HUGEPAGE_FLAG);
> >>  }
> >>
> >> +#ifdef CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION
> >> +int get_suggested_order(struct mm_struct *mm, struct vm_area_struct *=
vma__nullable,
> >> +                    u64 vma_flags, enum tva_type tva_flags, int order=
s);
> >> +#else
> >> +static inline int
> >> +get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma_=
_nullable,
> >> +                u64 vma_flags, enum tva_type tva_flags, int orders)
> >> +{
> >> +    return orders;
> >> +}
> >> +#endif
> >> +
> >>  static inline int highest_order(unsigned long orders)
> >>  {
> >>      return fls_long(orders) - 1;
> >> diff --git a/include/linux/khugepaged.h b/include/linux/khugepaged.h
> >> index eb1946a70cff..d81c1228a21f 100644
> >> --- a/include/linux/khugepaged.h
> >> +++ b/include/linux/khugepaged.h
> >> @@ -4,6 +4,8 @@
> >>
> >>  #include <linux/mm.h>
> >>
> >> +#include <linux/huge_mm.h>
> >> +
> >>  extern unsigned int khugepaged_max_ptes_none __read_mostly;
> >>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> >>  extern struct attribute_group khugepaged_attr_group;
> >> @@ -22,7 +24,15 @@ extern int collapse_pte_mapped_thp(struct mm_struct=
 *mm, unsigned long addr,
> >>
> >>  static inline void khugepaged_fork(struct mm_struct *mm, struct mm_st=
ruct *oldmm)
> >>  {
> >> -    if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm))
> >> +    /*
> >> +     * THP allocation policy can be dynamically modified via BPF. Eve=
n if a
> >> +     * task was allowed to allocate THPs, BPF can decide whether its =
forked
> >> +     * child can allocate THPs.
> >> +     *
> >> +     * The MMF_VM_HUGEPAGE flag will be cleared by khugepaged.
> >> +     */
> >> +    if (mm_flags_test(MMF_VM_HUGEPAGE, oldmm) &&
> >> +            get_suggested_order(mm, NULL, 0, -1, BIT(PMD_ORDER)))
> >
> > Hi Yafang,
> >
> > From the coverletter, one of the potential usecases you are trying to s=
olve for is if global policy
> > is "never", but the workload want THPs (either always or on madvise bas=
is). But over here,
> > MMF_VM_HUGEPAGE will never be set so in that case mm_flags_test(MMF_VM_=
HUGEPAGE, oldmm) will
> > always evaluate to false and the get_sugested_order call doesnt matter?
> >
> >
> >
> >>              __khugepaged_enter(mm);
> >>  }
> >>
> >> diff --git a/mm/Kconfig b/mm/Kconfig
> >> index 4108bcd96784..d10089e3f181 100644
> >> --- a/mm/Kconfig
> >> +++ b/mm/Kconfig
> >> @@ -924,6 +924,18 @@ config NO_PAGE_MAPCOUNT
> >>
> >>        EXPERIMENTAL because the impact of some changes is still unclea=
r.
> >>
> >> +config EXPERIMENTAL_BPF_ORDER_SELECTION
> >> +    bool "BPF-based THP order selection (EXPERIMENTAL)"
> >> +    depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
> >> +
> >> +    help
> >> +      Enable dynamic THP order selection using BPF programs. This
> >> +      experimental feature allows custom BPF logic to determine optim=
al
> >> +      transparent hugepage allocation sizes at runtime.
> >> +
> >> +      Warning: This feature is unstable and may change in future kern=
el
> >> +      versions.
> >> +
> >
> >
> > I know there was a discussion on this earlier, but my opinion is that p=
utting all of this
> > as experiment with warnings is not great. No one will be able to deploy=
 this in production
> > if its going to be removed, and I believe thats where the real usage is=
.
> >
> If the goal is to deploy it in Kubernetes, I believe eBPF is the wrong wa=
y to do it. Right
> now eBPF is used mainly for networking (CNI).

As I recall, I've already shared the Kubernetes deployment procedure
with you. [0]
If you=E2=80=99re using k8s, you should definitely check this out.
JFYI, we have already deployed this in our Kubernetes production environmen=
t.

[0] https://lore.kernel.org/linux-mm/CALOAHbDJPP499ZDitUYqThAJ_BmpeWN_NVR-w=
m=3D8XBe3X7Wxkw@mail.gmail.com/

>
> Kubernetes currently has something called Dynamic Resource Allocation (DR=
A), which is already
> in alpha version. It's main use is to share GPU and TPU among many pods. =
Still, we should
> take into account how likely the user space is going to use eBPF for cont=
rolling resources and
> how it integrates with the mechanisms currently available for resource co=
ntrol by the user
> space.

This is unrelated to the current feature.

>
> There is another scenario, when you you have a number of pods and a limit=
 of huge pages you
> want to use among them. Something similar to HugeTLBfs. Could this be ach=
ieved with your
> ebpf implementation?

This feature focuses on policy adjustment rather than resource control.

--=20
Regards
Yafang

