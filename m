Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 559B9CAC5BD
	for <linux-mm@archiver.kernel.org>; Sun, 28 Sep 2025 02:14:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 987018E0006; Sat, 27 Sep 2025 22:14:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95DAA8E0001; Sat, 27 Sep 2025 22:14:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8728E8E0006; Sat, 27 Sep 2025 22:14:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6C7E48E0001
	for <linux-mm@kvack.org>; Sat, 27 Sep 2025 22:14:09 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DCC82140968
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:14:08 +0000 (UTC)
X-FDA: 83937038976.14.F06031B
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	by imf26.hostedemail.com (Postfix) with ESMTP id 02E9E14000B
	for <linux-mm@kvack.org>; Sun, 28 Sep 2025 02:14:06 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWqmTDgk;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759025647;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IgfyK+ERvcGdu6t0lNJixg5TdROYvSdbOndCTyoB1XA=;
	b=fsUGbhk90Tg/gwNGUqb686yLXGufN0tuvFzJpwKfWPR/dZvjf45xgSi4Y/jCcdAGa+cb13
	42j96s5LbwSB/ZA257/cmzCAtBdFuVjhqUfX35P1NvulaykoC6qYZwdfk+NMIxIzlZMV7l
	u7J6RS1I+6kDLx0Li2sgLlr8+Kl7DF4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759025647; a=rsa-sha256;
	cv=none;
	b=rYKPCpQ7W5SPSciIHXKqqhpVCMbcSXE9I1cNFKQeEPwemXONHaqz/IOumNpKwFZ+uHQCPy
	Zdl+KiHJncNEAnZRH7hpHKzIvDBbihOH0Ea14ejMnbpygSb4H5kJQQv5tKIWtmQyyHMhxQ
	S+JBlQaHqwui+IeB0RPnMmTehTPpJEw=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=ZWqmTDgk;
	spf=pass (imf26.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.44 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-81efcad9c90so20403276d6.0
        for <linux-mm@kvack.org>; Sat, 27 Sep 2025 19:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1759025646; x=1759630446; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IgfyK+ERvcGdu6t0lNJixg5TdROYvSdbOndCTyoB1XA=;
        b=ZWqmTDgkI75Af7v0NRs/ZC6GBeYOlxMDOSPEXpDuyOBeoWx1ctiP3CPF7ZtRhtg8Al
         vFwpgGCZ6IQuVVuXEsn2Gk9Agf+nHxfE+m5YHbEh512ZLhPma4s/7sCDsNTyL8I0ywW/
         DYXpxxVCOIaWiQ7dAkmdQS2S5EQKpV4LWoh1lxrYnOMRTw58ap5kzo+rlBx7ydAnjH/s
         yDCimRGnDeeEY0nalRSDjg2hGJC4jpkVY0OnKl/PHjmETs9eLatJVCsgmUuG+rLp5yAs
         y+VhCMx6nNQoAfGo4cR+H+vPHEDdB1Ovy0tPmb+gRu8xviJss1Q7JGVWcTM+rLXoOP03
         DZ7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759025646; x=1759630446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IgfyK+ERvcGdu6t0lNJixg5TdROYvSdbOndCTyoB1XA=;
        b=rnBHM72oV9tBeb9VKJpz6bG4ZGmXEUtbz4BFi/DEUXLrD9bN/2nQHBoIHDWlepS1HP
         yfUOrGVs4EV6xlbdeEv8UPjVxfW1b6aHVxEsjj41GAmijieTU87qhjpBe0QyDMD8k76h
         1BdY79URVgcE0PReHleqoAeUWK2ORAgL9Zm0nH2QSQLipIsB8FJp3QSauedGB0wpMTCY
         uN1Uz00XZvcklHPs2TeaUEZYCh+DACbCp1FLnrKOPGhDZv7xUdHxxEYm+E+LzhGwvTx6
         S4NNQ2rsHCWRK3cFgITIRjcpoRmnkmclCA/d6Yj84uPDcjAmCQoj41EAaG2c/KHI3psH
         ijYA==
X-Forwarded-Encrypted: i=1; AJvYcCWS+iaYJkqQef/+pH+FkFzfhN6wrZW08EGoNiqqWj+Jisf/YbYobCgOAHlpHT8iQUcMGAbYWerlQw==@kvack.org
X-Gm-Message-State: AOJu0Yx1q6O1hS++I5n24AlqunE42RuXdFFFFxC1oazKvC2uiO92GtOK
	p8mMeZECZVvObwvroIoOuTpr9Crt/ptqMODbt5nUc64pwNz1ElZAIt2omq4BE28dSMz9p7xo8xB
	gFSfWIg4++o66Kfw6OzsGlNpBILdoGEc=
X-Gm-Gg: ASbGncsHhFCNjWuxGtMovX2XRCh3gbiqB8H4PfA0LhrijZDOmHVtIO9Oi/y2wtM8vUa
	CAeBkNb1+GS0qpL8mlVPmaDicUJFxHs76FyS7dUe3VkWvDLC+s04w8povIeuF2+wwXwoAp08AZy
	H4DvBrtBoSHJkrvTHnMZxQUc5Y0NcgsyhKTqpnVW55x/RZvwjgpftT3z4957kyDHD9FKM8TKvb4
	GQgu6xmJ8o2cUoFd4BQaszutLooqEj5Gc5HqlacMTz1xpQ+Vdo=
X-Google-Smtp-Source: AGHT+IFBzSCWT9hh0pEexdSgkq3kl3qXsAZzuIThj+zxZ39IC7nb4rfO/kyEpmVN3tJ4CnGQisxqrYSyLve72cAkf2M=
X-Received: by 2002:a05:6214:21a3:b0:7ef:5587:5427 with SMTP id
 6a1803df08f44-7fc3ca0be80mr189169576d6.32.1759025645980; Sat, 27 Sep 2025
 19:14:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250926093343.1000-1-laoar.shao@gmail.com> <20250926093343.1000-5-laoar.shao@gmail.com>
 <073d5246-6da7-4abb-93d6-38d814daedcc@gmail.com>
In-Reply-To: <073d5246-6da7-4abb-93d6-38d814daedcc@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Sun, 28 Sep 2025 10:13:29 +0800
X-Gm-Features: AS18NWAeAit0xGzG8ueU72wy7682FqeEqNkhZer2yoKGcZbdy1zHQ6f7MpL24z0
Message-ID: <CALOAHbCS1ndOUtMizCGxFRU8Xd9oJkK2GG1OmZVN1dEZ=iZmUw@mail.gmail.com>
Subject: Re: [PATCH v8 mm-new 04/12] mm: thp: add support for BPF based THP
 order selection
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev, 
	bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: f64f5pwmryja1jdqwbq36xokm79fefjb
X-Rspamd-Queue-Id: 02E9E14000B
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759025646-392769
X-HE-Meta: U2FsdGVkX1+LuF2JSQfMPZEVFY7e+N7cy5FTiYJ0qVXUaZKFB2OwVdGXtmtd/zKe0QRZMESHHt3uNLa1jfUN3EiC+whr4nV/EXFb5U3kcillwNFrj1Kkt9vUvL56K+Iq8NY5nAEL7xOo9CDIN0zywDI/wzCXobV21Uy8Xl/6eUsRxeyYHwhTa7NRk9hx5K8Pcr2hc3EwMYdrNY6ZdnX+P9Qi9jKcEQjMFU4s7zVSFuNc6/KSmy8Wzzna4e2T58RkjHWQQQ2DJDxWbiV6YCsnec6JX7kHhoFldfohtbxEGUu1TpKOHnrVLI4kRvQ19R51gguQ17dyGBbrJZJVi0Tn+A/sHMcJg/q4Mcp+ZRFbace8HbMbfsqrSbcRvJPbAaGZUtLeBTZUPx2LuPqpG6x3GtBbbRaAbeuHtpFNmItirAYdOXGAynU7RQEB6HBaZvbO16enhzY9/wzWEph//YAb2o3odEwnjdJ+pmV1LxEXlYRa9ZxQGvQsqVTV7I76dzURYv5KR140zfB64Z+cNcyfAVuuT+tRe7lZ0a3PclCtTewbYY0/XLTjMMmNlxeFWS+iUUMVRkHPtz7ju1Hz3zka9xgtUg+1FiGrXIX5wJnkQ0dBLM7sG1vh9Gs8DUiwfXTen1FXCli5xAvybahFe4rV0XBKbH5wiiXbZ9cNaglHFSG/3Jr+AFYnKuH0bs3DHex7546uc5mTd3KWeLhJOKE45blU7/BVhV+0C1FirZbUvGMJnLtxwc/EPMJMC0BP8Qn0/TNt+bQ9JcQTiNJ2NmdWNifNP8+kv115s8jRy5korb694J3QLrM4U5mJNQyBORM8PG0RbccouI6sD7Tp24poRUVx7eiPO+n5RUVk3CsUYw7Kr53UmaMfoMJSyk+i2VF1pUX4rQ7HYujRi8G488lrOX+PY0+dKvlogx3HJsVvDII9pirgFpnIRLOKFYrFR/jRrbh6txmblUM1KU0qIjJ
 mR8Awelz
 OM1ijLvztdRrdNV4wj58eZmTFwEF9qHKU6Lnqv5dp1FW6vtY9wrI+uSoBbIFCq7ycCPE5fsu4/4N21y0SeZQdmYZ6inCoreTNvOUUaHMNLlv+1ar4SrrFVIPRvwATgAZln3CoNC8JrliFhaLNRpecXGP4q/yU8zmocxIaPdoUvv8NcagqdBwR2E42BsLknN8InAiIWhyqw0cf/zSn3Xhp+p7no2cIBvrv4IZ70ppv+vrgmbbeesDJ007KXFAvPJWG9LPiQyATKsXbqCmx+PE73BLH78seZaDqglSSd8LjKjfthWBCS7yfI1A3PELjkmGyhaszOolXBD4D5dqb0ZqshLjHq7k31Tkdqr1lHy2xCAtpjwDNSIcj6Q3toYSVV+eUhFOzltp2E5F0HIJJzEUB1mt+MK315PoT3DaN71NM/NRXq7yeaL66a4CdKzLG+cQzQrs1VXuigcTRfUlfhc8KRywMkO78Pr3zpsIu6RBG4OG7Rxd0ESabmgjVCg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 26, 2025 at 11:13=E2=80=AFPM Usama Arif <usamaarif642@gmail.com=
> wrote:
>
>
>
> On 26/09/2025 10:33, Yafang Shao wrote:
> > This patch introduces a new BPF struct_ops called bpf_thp_ops for dynam=
ic
> > THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
> > programs to influence THP order selection based on factors such as:
> > - Workload identity
> >   For example, workloads running in specific containers or cgroups.
> > - Allocation context
> >   Whether the allocation occurs during a page fault, khugepaged, swap o=
r
> >   other paths.
> > - VMA's memory advice settings
> >   MADV_HUGEPAGE or MADV_NOHUGEPAGE
> > - Memory pressure
> >   PSI system data or associated cgroup PSI metrics
> >
> > The kernel API of this new BPF hook is as follows,
> >
> > /**
> >  * thp_order_fn_t: Get the suggested THP order from a BPF program for a=
llocation
> >  * @vma: vm_area_struct associated with the THP allocation
> >  * @type: TVA type for current @vma
> >  * @orders: Bitmask of available THP orders for this allocation
> >  *
> >  * Return: The suggested THP order for allocation from the BPF program.=
 Must be
> >  *         a valid, available order.
> >  */
> > typedef int thp_order_fn_t(struct vm_area_struct *vma,
> >                          enum tva_type type,
> >                          unsigned long orders);
> >
> > Only a single BPF program can be attached at any given time, though it =
can
> > be dynamically updated to adjust the policy. The implementation support=
s
> > anonymous THP, shmem THP, and mTHP, with future extensions planned for
> > file-backed THP.
> >
> > This functionality is only active when system-wide THP is configured to
> > madvise or always mode. It remains disabled in never mode. Additionally=
,
> > if THP is explicitly disabled for a specific task via prctl(), this BPF
> > functionality will also be unavailable for that task.
> >
> > This BPF hook enables the implementation of flexible THP allocation
> > policies at the system, per-cgroup, or per-task level.
> >
> > This feature requires CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL to be
> > enabled. Note that this capability is currently unstable and may underg=
o
> > significant changes=E2=80=94including potential removal=E2=80=94in futu=
re kernel versions.
> >
> > Suggested-by: David Hildenbrand <david@redhat.com>
> > Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> > Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> > ---
> >  MAINTAINERS             |   1 +
> >  include/linux/huge_mm.h |  23 +++++
> >  mm/Kconfig              |  12 +++
> >  mm/Makefile             |   1 +
> >  mm/huge_memory_bpf.c    | 204 ++++++++++++++++++++++++++++++++++++++++
> >  5 files changed, 241 insertions(+)
> >  create mode 100644 mm/huge_memory_bpf.c
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index ca8e3d18eedd..7be34b2a64fd 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -16257,6 +16257,7 @@ F:    include/linux/huge_mm.h
> >  F:   include/linux/khugepaged.h
> >  F:   include/trace/events/huge_memory.h
> >  F:   mm/huge_memory.c
> > +F:   mm/huge_memory_bpf.c
> >  F:   mm/khugepaged.c
> >  F:   mm/mm_slot.h
> >  F:   tools/testing/selftests/mm/khugepaged.c
> > diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
> > index a635dcbb2b99..fea94c059bed 100644
> > --- a/include/linux/huge_mm.h
> > +++ b/include/linux/huge_mm.h
> > @@ -56,6 +56,7 @@ enum transparent_hugepage_flag {
> >       TRANSPARENT_HUGEPAGE_DEFRAG_REQ_MADV_FLAG,
> >       TRANSPARENT_HUGEPAGE_DEFRAG_KHUGEPAGED_FLAG,
> >       TRANSPARENT_HUGEPAGE_USE_ZERO_PAGE_FLAG,
> > +     TRANSPARENT_HUGEPAGE_BPF_ATTACHED,      /* BPF prog is attached *=
/
> >  };
> >
> >  struct kobject;
> > @@ -269,6 +270,23 @@ unsigned long __thp_vma_allowable_orders(struct vm=
_area_struct *vma,
> >                                        enum tva_type type,
> >                                        unsigned long orders);
> >
> > +#ifdef CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL
> > +
> > +unsigned long
> > +bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type=
,
> > +                     unsigned long orders);
> > +
> > +#else
> > +
> > +static inline unsigned long
> > +bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type=
,
> > +                     unsigned long orders)
> > +{
> > +     return orders;
> > +}
> > +
> > +#endif
> > +
> >  /**
> >   * thp_vma_allowable_orders - determine hugepage orders that are allow=
ed for vma
> >   * @vma:  the vm area to check
> > @@ -290,6 +308,11 @@ unsigned long thp_vma_allowable_orders(struct vm_a=
rea_struct *vma,
> >  {
> >       vm_flags_t vm_flags =3D vma->vm_flags;
> >
> > +     /* The BPF-specified order overrides which order is selected. */
> > +     orders &=3D bpf_hook_thp_get_orders(vma, type, orders);
> > +     if (!orders)
> > +             return 0;
> > +
> >       /*
> >        * Optimization to check if required orders are enabled early. On=
ly
> >        * forced collapse ignores sysfs configs.
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index bde9f842a4a8..fd7459eecb2d 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -895,6 +895,18 @@ config NO_PAGE_MAPCOUNT
> >
> >         EXPERIMENTAL because the impact of some changes is still unclea=
r.
> >
> > +config BPF_THP_GET_ORDER_EXPERIMENTAL
> > +     bool "BPF-based THP order selection (EXPERIMENTAL)"
> > +     depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
> > +
> > +     help
> > +       Enable dynamic THP order selection using BPF programs. This
> > +       experimental feature allows custom BPF logic to determine optim=
al
> > +       transparent hugepage allocation sizes at runtime.
> > +
> > +       WARNING: This feature is unstable and may change in future kern=
el
> > +       versions.
> > +
>
> I am assuming this series opens up the possibility of additional hooks be=
ing added in
> the future. Instead of naming this BPF_THP_GET_ORDER_EXPERIMENTAL, should=
 we
> name it BPF_THP? Otherwise we will end up with 1 Kconfig option per hook,=
 which
> is quite bad.

makes sense.

>
> Also It would be really nice if we dont put "EXPERIMENTAL" in the name of=
 the defconfig.
> If its decided that its not experimental anymore without any change to th=
e code needed,
> renaming the defconfig will break it for everyone.

makes sense to me.
Lorenzo, what do you think ?

>
>
> >  endif # TRANSPARENT_HUGEPAGE
> >
> >  # simple helper to make the code a bit easier to read
> > diff --git a/mm/Makefile b/mm/Makefile
> > index 21abb3353550..62ebfa23635a 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) +=3D migrate.o
> >  obj-$(CONFIG_NUMA) +=3D memory-tiers.o
> >  obj-$(CONFIG_DEVICE_MIGRATION) +=3D migrate_device.o
> >  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) +=3D huge_memory.o khugepaged.o
> > +obj-$(CONFIG_BPF_THP_GET_ORDER_EXPERIMENTAL) +=3D huge_memory_bpf.o
> >  obj-$(CONFIG_PAGE_COUNTER) +=3D page_counter.o
> >  obj-$(CONFIG_MEMCG_V1) +=3D memcontrol-v1.o
> >  obj-$(CONFIG_MEMCG) +=3D memcontrol.o vmpressure.o
> > diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> > new file mode 100644
> > index 000000000000..b59a65d70a93
> > --- /dev/null
> > +++ b/mm/huge_memory_bpf.c
> > @@ -0,0 +1,204 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * BPF-based THP policy management
> > + *
> > + * Author: Yafang Shao <laoar.shao@gmail.com>
> > + */
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/btf.h>
> > +#include <linux/huge_mm.h>
> > +#include <linux/khugepaged.h>
> > +
> > +/**
> > + * @thp_order_fn_t: Get the suggested THP order from a BPF program for=
 allocation
> > + * @vma: vm_area_struct associated with the THP allocation
> > + * @type: TVA type for current @vma
> > + * @orders: Bitmask of available THP orders for this allocation
> > + *
> > + * Return: The suggested THP order for allocation from the BPF program=
. Must be
> > + *         a valid, available order.
> > + */
> > +typedef int thp_order_fn_t(struct vm_area_struct *vma,
> > +                        enum tva_type type,
> > +                        unsigned long orders);
> > +
> > +struct bpf_thp_ops {
> > +     thp_order_fn_t __rcu *thp_get_order;
> > +};
> > +
> > +static struct bpf_thp_ops bpf_thp;
> > +static DEFINE_SPINLOCK(thp_ops_lock);
> > +
> > +unsigned long bpf_hook_thp_get_orders(struct vm_area_struct *vma,
> > +                                   enum tva_type type,
> > +                                   unsigned long orders)
> > +{
> > +     thp_order_fn_t *bpf_hook_thp_get_order;
> > +     int bpf_order;
> > +
> > +     /* No BPF program is attached */
> > +     if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> > +                   &transparent_hugepage_flags))
> > +             return orders;
> > +
> > +     rcu_read_lock();
> > +     bpf_hook_thp_get_order =3D rcu_dereference(bpf_thp.thp_get_order)=
;
> > +     if (!bpf_hook_thp_get_order)
>
> Should we warn over here if we are going to out? TRANSPARENT_HUGEPAGE_BPF=
_ATTACHED
> being set + !bpf_hook_thp_get_order shouldnt be possible, right?

will add a warning in the next version.

--=20
Regards
Yafang

