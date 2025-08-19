Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 973A4CA0EEB
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 03:08:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BDD88E000A; Mon, 18 Aug 2025 23:08:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 06DEF8E0006; Mon, 18 Aug 2025 23:08:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9E818E000A; Mon, 18 Aug 2025 23:08:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D176A8E0006
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 23:08:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 19F05140201
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:08:51 +0000 (UTC)
X-FDA: 83792024862.23.390C77B
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3D966C0012
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 03:08:49 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nrwJgG+n;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755572929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bVQ3txuqhXptMPW0m70Tse+67oS8ipM+vDOvy7EJnh0=;
	b=OKelKnrMop/pCYjmAtRPQmIBbRjwYQNh1yKOQqvnlxTPN1ZHNWm77SmJs9ALtdD55kYQyg
	sv+j/fv1XJl39ESEXQRQXLtSDP+YlBk1VN5dLZcoXDkGEz2a7RJIl4NJg5X2srjo+Epvnk
	wBgUFIkZ5JKIRH5liC14yPOP4CUnFA4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=nrwJgG+n;
	spf=pass (imf28.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.219.42 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755572929; a=rsa-sha256;
	cv=none;
	b=vNLUq7XRxYKJxqQAsJh/Jpf8/rpRlGGUemRvipIrCwdf7aAH+RDl/MpMGcI4hYsPqwBmMb
	fzZEWPQwgm8eH0FLetYJQFZvVHuNoRTYTaL+YjEgnCKRrk3juQBUv8iGtcMYGN6l3hIT7Z
	jihQrzj90XIO2Kbfbg4JtVlFAp4v/sI=
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-70a88dd062eso42221296d6.0
        for <linux-mm@kvack.org>; Mon, 18 Aug 2025 20:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755572928; x=1756177728; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=bVQ3txuqhXptMPW0m70Tse+67oS8ipM+vDOvy7EJnh0=;
        b=nrwJgG+nbEGAkWqslRehs/KggapboAMLJAHCNgVVLNUea/xTCrUCUpI+dGPWyHuVvR
         Go2ox4kOCtndUAs1aWHF6CSSQgpzXuRD9qHLswNiNYLkhHR8qLzp9pDkK006cQJNhgff
         8GTBf9HznPQ24h0EG63ndAUoHGmW9zpsEJ9BH2XMHhA3S9sc62LQWEGeXtio/gCTr2Xq
         MpdVMIydMO7lJh+/VbwirCh8Hs41MJDEUOrLnP+fPVE7C8oPuFC0ZwEzKdl8h/2c6hbt
         F30LoYBhz6yI1fpT6ONqLc1aYzL53VHf+JlRCD3tn4NFy51FC7s8yjg6AsYoA2bwIpmg
         tMPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755572928; x=1756177728;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bVQ3txuqhXptMPW0m70Tse+67oS8ipM+vDOvy7EJnh0=;
        b=eeGqeVux7wAniv6qn612p8VtyNZBE6LzJLziEQJjOj1FcgEtJaIj3v8bKCe/vMKE0A
         AB4Xstv31ds/NdQNyZ7aDENy7ignZru+UpH/ay6zO3ilb6cdN470Ifk1ovrpTSt9CX06
         hJjtjgQWrU+9sPW4ebiwjB1uIVlaH1UVd4cZMjaJ9vWKnNHpm4deNEVTpnYFTmDgcLCF
         PXQiaG3Tns2gRJG8JbzQp/adYK633oldBjLQ/f2hCVXDsOO+S25dDU+2HvwXiVUbMrjB
         BGLTcrCyKhmWKEMuXY9D+B/BHCxQ8A3FBf+48q8OsdWmr2fWvcjnggT2kmCWBkE/gokE
         6zOA==
X-Forwarded-Encrypted: i=1; AJvYcCWzozdaYWUtqS1ukpQ3Gxg/tHPOmFPebdBxWHwUtKHjrIyqpP24wRcBdaBntsFCviCNm0BT1wYFbg==@kvack.org
X-Gm-Message-State: AOJu0YyMCpAVaByWEHUOWr1dNQxNqqY5/3c5/Y/mflc3ZRbs2lRIi3XY
	y7CAjLMaY5hmj9OmpoyMlCUhGOcdMLnZUo00YRJhLAbgMkFTBOAo5gWDObL3WQB7YrSXX5tVTZT
	IaM6L160i0dtSpJVA5T88pffvfVZpYug=
X-Gm-Gg: ASbGncsEQyYFmY6di9lXBhspG59Why11vG+1uuCxpX/yC6pz6IMahEb8q6DCZLGSFAt
	b78lxzwcJKQ5FpkqI+hArUn5A20y1wUDa2p/M5vsxjn5VlpbfrV6qIl8x68KyAwzHJDjFZ8H5vM
	u7bK2AcASgmygSjkYm0v1OiWufYqGR2oEanpybN7AXdt7c4Ozc2JX9zW9LQaMjsd9oFslKnY2aI
	q+bucYXvq3MYcIB7Xo/SCoUXLDZiA==
X-Google-Smtp-Source: AGHT+IG4d+j08Ahd6e0IGmLpLjVQywBiVWxr/oNbqn/B7jFk/v+8Z5OpkOO0eFgFAIrZiT4AXFJQ9Ow8ACyQoIj9cbM=
X-Received: by 2002:a05:6214:2529:b0:704:c686:3f54 with SMTP id
 6a1803df08f44-70c35b75de4mr11175206d6.15.1755572928192; Mon, 18 Aug 2025
 20:08:48 -0700 (PDT)
MIME-Version: 1.0
References: <20250818055510.968-1-laoar.shao@gmail.com> <20250818055510.968-2-laoar.shao@gmail.com>
 <0caf3e46-2b80-4e7c-91aa-9d7ed5fe4db9@gmail.com>
In-Reply-To: <0caf3e46-2b80-4e7c-91aa-9d7ed5fe4db9@gmail.com>
From: Yafang Shao <laoar.shao@gmail.com>
Date: Tue, 19 Aug 2025 11:08:11 +0800
X-Gm-Features: Ac12FXyGdjs74vIigEErSMFXUxLnN6Z-FmbRaiTyFNQo0NxSWMWlqri9y3uiYyo
Message-ID: <CALOAHbAzQmqxcJ7HU+gsdX4+iEj0U=E5mS8nXF8OYW9QxuXSLA@mail.gmail.com>
Subject: Re: [RFC PATCH v5 mm-new 1/5] mm: thp: add support for BPF based THP
 order selection
To: Usama Arif <usamaarif642@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, gutierrez.asier@huawei-partners.com, 
	willy@infradead.org, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, 
	ameryhung@gmail.com, rientjes@google.com, bpf@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 3D966C0012
X-Rspam-User: 
X-Stat-Signature: r4qmuk1nbjhhbpphpojasbokj9sggizb
X-Rspamd-Server: rspam09
X-HE-Tag: 1755572929-218813
X-HE-Meta: U2FsdGVkX18jAuy75r4JrWWBTqk0pRP1ICI66Zll7giWFyq0HR4bRSttLE7zEXiDoZyWOrL4ZFT+q9DQOvany196pUnM3ZTbzZF+Rx5FD8RUElOmDiaDsnsR0ioJGNNzz2RIsx/f1g+v/6AGrOVWA5FNZQiByGj7hvzLXD6Zz+3hvodNcawlQUcd298zjc+7+XjgExU/g1mE/Lo4vUNKDJmLz3oaU2qoNmMLcAxk1Wagt9HfKqVEGI1tJqPslJRX12t6kBS3lkWLO82XPfBWTQ/bDaimj6A2XVYh12Fb+z1VqClSKT63tGLXAlVZxpeB3zl4+QD759OrOUqtXc+spqRITujWtO2+oW/Rc11Le26hLHqTqNEDnfU2NXZoQQW70FDbMZNVUsX5Vl0dVahtip0HQ/H3e7Ofoy/ZanZ5fykLdka/IBg5s9MFfvW8DaQxEzVsmc0DV/VQdBdMyOcN0z0DndBSOZPkLpnCZgPICS67GejjCTXSWrpndVP/47nHS/Bo4PLCLhh3qS8+Onew1bJooDUKcevZsl/P0D65hVeXBxee3VyYNSCFBRCmOfm3+lqRHpT+VBIVbtQ2MHSKgXk8pZqgjcxSWQqAYIeRITSmh8rVee3amarNhN8OUEPP5E4WCLiFin2eXyXhvjd8SDeuO+yjzMoBpUkzaNL3eBnlcQyDlEfo1oep689vZWyiFOyqiFBlIFr4h4oJ2vE+qs7Db17TjTv5JG+SMgZxPXhwrA0ExKzzxDa9eJf2uwlfVaYNmXrfRtdsK2aHTo2z7/F0+NZ+OyrngvN9L7nr6zNpFNbtxx4vFoSiXie8jiRqjQC6/WOn/fiPDrf+KDkjDl48cv+fXwv/xxhsSRuEO+RqORE7tGS5X0jzDyCZXmKnmUwrk4Um9tkFnpXTSGsCuX7MWozcdOq7kQK3m4CVwTTRoGWQdOz/ZRPqbE7jumm8hrU5kRiS2Tj64QOq/Zk
 AouebvX4
 qv4EQ0fLBbnHE/uHxKsgh6eNkcvutshCJSRiWjOS/JW82ovQGXm6oU5fwgMwABchl5+hSA1OORLt/LzdEgrrQ4TATp/lZ+t5gJrodon/5q5lVxnQzjI8rWAARyrsHtIqnM0VNSnfF+A9C0y2mDmmUqLHE/y/7GszldEsUSrPgj8S6MNECYkCHfKxKzLPNx7YRP8j1LBD6XFZh64haWuqpq70w0vI78Xyig6HBGbuoHdazXDedUC5/2FN6bWu683RemCNrEYn/UCPCnfNuh0nVRO8uxmaQhygscg9UtfuZwOlZUUmfkPQEsQcfU4y3+7Gr5IJJzjv+KcHcaBSYIKYvKL7NFiTAOZC6W/jHRrEEZO7+Hi8jYtPhM92onxA7gFnjNYzqCQUQscbaF0HMHrV0/9YVgNLXyeURgYfjJ0fO7nk5+U8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi Yafang,
>
> From the coverletter, one of the potential usecases you are trying to solve for is if global policy
> is "never", but the workload want THPs (either always or on madvise basis). But over here,
> MMF_VM_HUGEPAGE will never be set so in that case mm_flags_test(MMF_VM_HUGEPAGE, oldmm) will
> always evaluate to false and the get_sugested_order call doesnt matter?

See the replyment in another thread.

>
>
>
> >               __khugepaged_enter(mm);
> >  }
> >
> > diff --git a/mm/Kconfig b/mm/Kconfig
> > index 4108bcd96784..d10089e3f181 100644
> > --- a/mm/Kconfig
> > +++ b/mm/Kconfig
> > @@ -924,6 +924,18 @@ config NO_PAGE_MAPCOUNT
> >
> >         EXPERIMENTAL because the impact of some changes is still unclear.
> >
> > +config EXPERIMENTAL_BPF_ORDER_SELECTION
> > +     bool "BPF-based THP order selection (EXPERIMENTAL)"
> > +     depends on TRANSPARENT_HUGEPAGE && BPF_SYSCALL
> > +
> > +     help
> > +       Enable dynamic THP order selection using BPF programs. This
> > +       experimental feature allows custom BPF logic to determine optimal
> > +       transparent hugepage allocation sizes at runtime.
> > +
> > +       Warning: This feature is unstable and may change in future kernel
> > +       versions.
> > +
>
>
> I know there was a discussion on this earlier, but my opinion is that putting all of this
> as experiment with warnings is not great. No one will be able to deploy this in production
> if its going to be removed, and I believe thats where the real usage is.

See the replyment in another thread.

>
> >  endif # TRANSPARENT_HUGEPAGE
> >
> >  # simple helper to make the code a bit easier to read
> > diff --git a/mm/Makefile b/mm/Makefile
> > index ef54aa615d9d..cb55d1509be1 100644
> > --- a/mm/Makefile
> > +++ b/mm/Makefile
> > @@ -99,6 +99,7 @@ obj-$(CONFIG_MIGRATION) += migrate.o
> >  obj-$(CONFIG_NUMA) += memory-tiers.o
> >  obj-$(CONFIG_DEVICE_MIGRATION) += migrate_device.o
> >  obj-$(CONFIG_TRANSPARENT_HUGEPAGE) += huge_memory.o khugepaged.o
> > +obj-$(CONFIG_EXPERIMENTAL_BPF_ORDER_SELECTION) += bpf_thp.o
> >  obj-$(CONFIG_PAGE_COUNTER) += page_counter.o
> >  obj-$(CONFIG_MEMCG_V1) += memcontrol-v1.o
> >  obj-$(CONFIG_MEMCG) += memcontrol.o vmpressure.o
> > diff --git a/mm/bpf_thp.c b/mm/bpf_thp.c
> > new file mode 100644
> > index 000000000000..2b03539452d1
> > --- /dev/null
> > +++ b/mm/bpf_thp.c
> > @@ -0,0 +1,186 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +
> > +#include <linux/bpf.h>
> > +#include <linux/btf.h>
> > +#include <linux/huge_mm.h>
> > +#include <linux/khugepaged.h>
> > +
> > +struct bpf_thp_ops {
> > +     /**
> > +      * @get_suggested_order: Get the suggested THP orders for allocation
> > +      * @mm: mm_struct associated with the THP allocation
> > +      * @vma__nullable: vm_area_struct associated with the THP allocation (may be NULL)
> > +      *                 When NULL, the decision should be based on @mm (i.e., when
> > +      *                 triggered from an mm-scope hook rather than a VMA-specific
> > +      *                 context).
> > +      *                 Must belong to @mm (guaranteed by the caller).
> > +      * @vma_flags: use these vm_flags instead of @vma->vm_flags (0 if @vma is NULL)
> > +      * @tva_flags: TVA flags for current @vma (-1 if @vma is NULL)
> > +      * @orders: Bitmask of requested THP orders for this allocation
> > +      *          - PMD-mapped allocation if PMD_ORDER is set
> > +      *          - mTHP allocation otherwise
> > +      *
> > +      * Rerurn: Bitmask of suggested THP orders for allocation. The highest
> > +      *         suggested order will not exceed the highest requested order
> > +      *         in @orders.
>
> If we want to make this generic enough so that it doesnt change, should we allow suggested order to
> exceed highest requested order?

The maximum requested order is determined by the callsite. For example:
- PMD-mapped THP uses PMD_ORDER
- mTHP uses (PMD_ORDER - 1)

We must respect this upper bound to avoid undefined behavior.

>
> > +      */
> > +     int (*get_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
> > +                                u64 vma_flags, enum tva_type tva_flags, int orders) __rcu;
> > +};
> > +
> > +static struct bpf_thp_ops bpf_thp;
> > +static DEFINE_SPINLOCK(thp_ops_lock);
> > +
> > +int get_suggested_order(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
> > +                     u64 vma_flags, enum tva_type tva_flags, int orders)
> > +{
> > +     int (*bpf_suggested_order)(struct mm_struct *mm, struct vm_area_struct *vma__nullable,
> > +                                u64 vma_flags, enum tva_type tva_flags, int orders);
> > +     int suggested_orders = orders;
> > +
> > +     /* No BPF program is attached */
> > +     if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> > +                   &transparent_hugepage_flags))
> > +             return suggested_orders;
> > +
> > +     rcu_read_lock();
> > +     bpf_suggested_order = rcu_dereference(bpf_thp.get_suggested_order);
> > +     if (!bpf_suggested_order)
> > +             goto out;
>
>
> My rcu API knowledge is not the best, but maybe we could do:
>
> if (!rcu_access_pointer(bpf_thp.get_suggested_order))
>         return suggested_orders;
>

There might be a race here.  The current rcu_access_pointer() check
occurs outside the RCU read-side critical section, meaning the
protected pointer could be freed between the check and use.
Therefore, we must perform the NULL check within the RCU read critical
section when dereferencing the pointer:

> rcu_read_lock();
> bpf_suggested_order = rcu_dereference(bpf_thp.get_suggested_order);

 if (!bpf_suggested_order)
     goto out;

>
> I believe this might be better as you dont acquire the rcu_read_lock and avoid
> the lockdep checks when you do rcu_access_pointer, but I might be wrong
> and hope you or someone on the mailing list corrects me if thats the case :)
>
> > +
> > +     suggested_orders = bpf_suggested_order(mm, vma__nullable, vma_flags, tva_flags, orders);
> > +     if (highest_order(suggested_orders) > highest_order(orders))
> > +             suggested_orders = orders;
> > +
>
> Maybe we should allow suggested_order to be greater than order if we want this to be truly generic?
> Not a suggestion to change, just to have a discussion.

As replied above, the upper bound is a limitation.

>
> > +out:
> > +     rcu_read_unlock();
> > +     return suggested_orders;
> > +}
> > +
> > +static bool bpf_thp_ops_is_valid_access(int off, int size,
> > +                                     enum bpf_access_type type,
> > +                                     const struct bpf_prog *prog,
> > +                                     struct bpf_insn_access_aux *info)
> > +{
> > +     return bpf_tracing_btf_ctx_access(off, size, type, prog, info);
> > +}
> > +
> > +static const struct bpf_func_proto *
> > +bpf_thp_get_func_proto(enum bpf_func_id func_id, const struct bpf_prog *prog)
> > +{
> > +     return bpf_base_func_proto(func_id, prog);
> > +}
> > +
> > +static const struct bpf_verifier_ops thp_bpf_verifier_ops = {
> > +     .get_func_proto = bpf_thp_get_func_proto,
> > +     .is_valid_access = bpf_thp_ops_is_valid_access,
> > +};
> > +
> > +static int bpf_thp_init(struct btf *btf)
> > +{
> > +     return 0;
> > +}
> > +
> > +static int bpf_thp_init_member(const struct btf_type *t,
> > +                            const struct btf_member *member,
> > +                            void *kdata, const void *udata)
> > +{
> > +     return 0;
> > +}
> > +
> > +static int bpf_thp_reg(void *kdata, struct bpf_link *link)
> > +{
> > +     struct bpf_thp_ops *ops = kdata;
> > +
> > +     spin_lock(&thp_ops_lock);
> > +     if (test_and_set_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED,
> > +             &transparent_hugepage_flags)) {
> > +             spin_unlock(&thp_ops_lock);
> > +             return -EBUSY;
> > +     }
> > +     WARN_ON_ONCE(bpf_thp.get_suggested_order);
>
> Should it be WARN_ON_ONCE(rcu_access_pointer(bpf_thp.get_suggested_order)) ?

Nice catch.  I'll make that change

>
> > +     WRITE_ONCE(bpf_thp.get_suggested_order, ops->get_suggested_order);
>
> Should it be rcu_assign_pointer instead of WRITE_ONCE?

will change it.

>
> > +     spin_unlock(&thp_ops_lock);
> > +     return 0;
> > +}
> > +
> > +static void bpf_thp_unreg(void *kdata, struct bpf_link *link)
> > +{
> > +     spin_lock(&thp_ops_lock);
> > +     clear_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags);
> > +     WARN_ON_ONCE(!bpf_thp.get_suggested_order);
>
> Maybe need to use use rcu_access_pointer here in the warning?

Agreed, will change it.

>
> > +     rcu_replace_pointer(bpf_thp.get_suggested_order, NULL, lockdep_is_held(&thp_ops_lock));
> > +     spin_unlock(&thp_ops_lock);
> > +
> > +     synchronize_rcu();
> > +}
> > +
> > +static int bpf_thp_update(void *kdata, void *old_kdata, struct bpf_link *link)
> > +{
> > +     struct bpf_thp_ops *ops = kdata;
> > +     struct bpf_thp_ops *old = old_kdata;
> > +     int ret = 0;
> > +
> > +     if (!ops || !old)
> > +             return -EINVAL;
> > +
> > +     spin_lock(&thp_ops_lock);
> > +     /* The prog has aleady been removed. */
> > +     if (!test_bit(TRANSPARENT_HUGEPAGE_BPF_ATTACHED, &transparent_hugepage_flags)) {
> > +             ret = -ENOENT;
> > +             goto out;
> > +     }
> > +     WARN_ON_ONCE(!bpf_thp.get_suggested_order);
>
> As above about using rcu_access_pointer.

will change it.

Thanks for your review!

-- 
Regards
Yafang

