Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 497FACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 12:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84C248E0003; Wed, 10 Sep 2025 08:43:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823828E0002; Wed, 10 Sep 2025 08:43:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739CC8E0003; Wed, 10 Sep 2025 08:43:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6167C8E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 08:43:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2A611C08B1
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:43:27 +0000 (UTC)
X-FDA: 83873306454.27.F9B5308
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf13.hostedemail.com (Postfix) with ESMTP id 18FD62000E
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:43:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WhLWgdc6;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757508205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWOnY6bsoNbRGhI6jrKdlgeXeUlIE02ttDreMjH2ThU=;
	b=0w+5hZMlSAxdh6fTyTDRowg7jOUwiQBhHBo16Tv0go3N6Rfn+N8HenuWkuFh9EHvhSc8Vk
	6ssu2odzpMXeOmWdyFVw0vrGm3TO90iEcfOQn0OymzP/oCDZ5RLIPIYB9R6s1GOcGVROLa
	JuIN98zobMvDgXJqTr0Xu6OePTej4wk=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WhLWgdc6;
	spf=pass (imf13.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757508205; a=rsa-sha256;
	cv=none;
	b=pxBByG9+3AB5r0CVVyowlz/OZR4z7gMjbowlMB/Bx7PqYEYNhKU18aq5PghAbQC+NXl/eQ
	CsS5DlqWalW3wBuxjphcCfJAYlybF9q70X6p+Lmslua0TuJhwoa8yjylHVXT5+4g7rThb3
	hxFKkaobjMxGvDLGhYp4CDLD3IWDPmU=
X-Forwarded-Encrypted: i=1; AJvYcCVkD8CBOPmLEKDnilOKd9Oh95dmgERDsuDI8fah4hYDaKjUk2u6Zto4l+KkeEFj9YlHq42gnz03Fg==@kvack.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757508203;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cWOnY6bsoNbRGhI6jrKdlgeXeUlIE02ttDreMjH2ThU=;
	b=WhLWgdc6sjruU+UNXFbtCEKgXPjwQRFvzJrnHM56K5bpmirgA3BuAhfAyPhbLJ7pjAg0W+
	3rvGTK8ZROFl7hbZBCjZ4FKwEsPsvHYteEtGoLgaRyZe7ESFLSZXxZmiKbxDco112VL57r
	s4CDRcOVtQnJFnNmarEt4snZfcBIRNQ=
X-Gm-Message-State: AOJu0Yz+zR3ZgpGZfeIIczphLyPXVfXhC07eARY7oYAyPgVitiDI4g0C
	bsRzz2LhRh7BewKWH/jz2M4n0QJ0nfif2DmweDJqQL37oW0FNx6nkxCnnjHDbw+WftN6izZuPqU
	kKwzasrAQXuzCQ6fR0X5DmUhBLy1RJss=
X-Google-Smtp-Source: AGHT+IGS4IyMyT2B5rjpMHdQ/sH6F7nZ01XypbWguYA7dCWguRiSUdDaKM5DsDcnWRSvBhMGTGMkWFlbQbHkoeCdCfo=
X-Received: by 2002:ad4:5de2:0:b0:70f:abee:f9ba with SMTP id
 6a1803df08f44-73a21485479mr148779516d6.12.1757508200059; Wed, 10 Sep 2025
 05:43:20 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-3-laoar.shao@gmail.com>
In-Reply-To: <20250910024447.64788-3-laoar.shao@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
Date: Wed, 10 Sep 2025 20:42:37 +0800
X-Gmail-Original-Message-ID: <CABzRoyZm32HT2fDpSy_PRDxeXZVJD35+9YqRpn9XWix8jG6w8g@mail.gmail.com>
X-Gm-Features: AS18NWA2-rrAiWS-c1ep0R42ZfRXwiuMPFMEj6A1tty0wp_Sw-BPEy3kdhILrOo
Message-ID: <CABzRoyZm32HT2fDpSy_PRDxeXZVJD35+9YqRpn9XWix8jG6w8g@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 02/10] mm: thp: add support for BPF based THP
 order selection
To: Yafang Shao <laoar.shao@gmail.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, hannes@cmpxchg.org, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org, 
	daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com, 
	rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com, 
	shakeel.butt@linux.dev, bpf@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 18FD62000E
X-Rspamd-Server: rspam05
X-Stat-Signature: uo1g8x4poixcz5uqitb8zuahsyhh9saz
X-Rspam-User: 
X-HE-Tag: 1757508204-77581
X-HE-Meta: U2FsdGVkX1/fNYK0Jk+vVBNjDUFSYSAQUN/Ah0rtdBxgmqObxYlBHWhm0JA6QpTW00z4WFHPEpzWmUxeA9d870vcqzvm8F+fRapmYnkiQFL6+IngwbOACF7UbfC9Uyf6u2rZpPm9/9p4GIdoHy02hsE+YPu6IkkNKLba6ychf9b5d3iRXYz0fOetQE/WkYfcul871J8SMwN4yRR6yciMOfBPSx34ReEW7K61K+LghyeAus62c/41Qoqh7K+tJoxVlYc5N0nzoYn9xZgmpcJ4o/bxA2/qOAR/YMDQMO+HD640oq3tWNN0/0vI7rxGCzq2fN8Rt6PGue2r8HaeWDv0SZuHG4jSt3cfbyk6uINo9RdkPHaF14XfOmDXzKBhF0MfjeioQqfZPWb8AhiscMGl8nYWdHMz/r3Hhcgk31ew47ScV6xR/iJr2LdFsxHbe75Ts8OLGI5BT4Pvywk1/YPGp/qgfgUo1VtglIZQ9nfqv5iK5tyEnqk+9G5Phs2VCL91URtpWHTNglrPveanjhj4DW38TAekY4voojdLgql2wJFW7wRbFYJklw9u2wNPB9S5rGupwnB1P/F7+SvtjXpyTP8pv8r5aXc153hLU2ZMm/p4Fm0862VQ+JlAXaIs+3xRb1JjZjY733ewoPL4MWRRAO52pquq22LwTFhjdUNgDxIfisJm3kVEGR939i+BXM+Sgtsb4HqUHXt18WppONqlqf2OrZOCYizGDj3gLGeh1vC6KXHYOVKBPbgGjd491H9Cge1LoH+h1ufu9THmgd8wihGYGeVfsSFiFFPXKeR9in/3tdkgZnv3wMRHYl6zFOdb4ERuKrZLa3y38XItXsw8gGy90ojvACgJiTxyhsx66y88vfRnyRg9ZoQoc7tqapA1mdndFJSDXNzOorbajDr1sz4KQjnM24Gae65exEpCZUqKDIk6eWJ6sdHKFetOKOfaE3rIS4ha3tsUn8/8rY8
 sZHngS2p
 VarWK2Je/OkC2WRpjfya5Uqnre11ffcLYlhJc44ft43DD63GMy/+gINphfw379iTJHaMlp1A/qPOkImw/fu171lmuR3A4mtpGpLBAZfcSlVfUfxuTVrC+60aezBLzAc0Akpxu3cbv2ln5pWAZHCe3NJe1n+vqBOYTsmnDKCR1DekhRWQzBW4wRVsh9keJqRixUY8OLY9pg8pmZFLogBxQ8Y46atVms428o1w4Cm4HMGj3lsnQOcViMrgIiKA9GinMwnfD9a+EDhpoItW7oioziWzAGpAeJ+f/MOOX7Q8S4en+MaZTtVHnR0qStAJKN+5/2KDikz8YpK2Tdf00qPDe7hc21g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Yafang,

On Wed, Sep 10, 2025 at 10:53=E2=80=AFAM Yafang Shao <laoar.shao@gmail.com>=
 wrote:
>
> This patch introduces a new BPF struct_ops called bpf_thp_ops for dynamic
> THP tuning. It includes a hook bpf_hook_thp_get_order(), allowing BPF
> programs to influence THP order selection based on factors such as:
> - Workload identity
>   For example, workloads running in specific containers or cgroups.
> - Allocation context
>   Whether the allocation occurs during a page fault, khugepaged, swap or
>   other paths.
> - VMA's memory advice settings
>   MADV_HUGEPAGE or MADV_NOHUGEPAGE
> - Memory pressure
>   PSI system data or associated cgroup PSI metrics
>
> The kernel API of this new BPF hook is as follows,
>
> /**
>  * @thp_order_fn_t: Get the suggested THP orders from a BPF program for a=
llocation
>  * @vma: vm_area_struct associated with the THP allocation
>  * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE is=
 set
>  *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_V=
M_NONE if
>  *            neither is set.
>  * @tva_type: TVA type for current @vma
>  * @orders: Bitmask of requested THP orders for this allocation
>  *          - PMD-mapped allocation if PMD_ORDER is set
>  *          - mTHP allocation otherwise
>  *
>  * Return: The suggested THP order from the BPF program for allocation. I=
t will
>  *         not exceed the highest requested order in @orders. Return -1 t=
o
>  *         indicate that the original requested @orders should remain unc=
hanged.
>  */
> typedef int thp_order_fn_t(struct vm_area_struct *vma,
>                            enum bpf_thp_vma_type vma_type,
>                            enum tva_type tva_type,
>                            unsigned long orders);
>
> Only a single BPF program can be attached at any given time, though it ca=
n
> be dynamically updated to adjust the policy. The implementation supports
> anonymous THP, shmem THP, and mTHP, with future extensions planned for
> file-backed THP.
>
> This functionality is only active when system-wide THP is configured to
> madvise or always mode. It remains disabled in never mode. Additionally,
> if THP is explicitly disabled for a specific task via prctl(), this BPF
> functionality will also be unavailable for that task.
>
> This feature requires CONFIG_BPF_GET_THP_ORDER (marked EXPERIMENTAL) to b=
e
> enabled. Note that this capability is currently unstable and may undergo
> significant changes=E2=80=94including potential removal=E2=80=94in future=
 kernel versions.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> ---
[...]
> diff --git a/mm/huge_memory_bpf.c b/mm/huge_memory_bpf.c
> new file mode 100644
> index 000000000000..525ee22ab598
> --- /dev/null
> +++ b/mm/huge_memory_bpf.c
> @@ -0,0 +1,243 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * BPF-based THP policy management
> + *
> + * Author: Yafang Shao <laoar.shao@gmail.com>
> + */
> +
> +#include <linux/bpf.h>
> +#include <linux/btf.h>
> +#include <linux/huge_mm.h>
> +#include <linux/khugepaged.h>
> +
> +enum bpf_thp_vma_type {
> +       BPF_THP_VM_NONE =3D 0,
> +       BPF_THP_VM_HUGEPAGE,    /* VM_HUGEPAGE */
> +       BPF_THP_VM_NOHUGEPAGE,  /* VM_NOHUGEPAGE */
> +};
> +
> +/**
> + * @thp_order_fn_t: Get the suggested THP orders from a BPF program for =
allocation
> + * @vma: vm_area_struct associated with the THP allocation
> + * @vma_type: The VMA type, such as BPF_THP_VM_HUGEPAGE if VM_HUGEPAGE i=
s set
> + *            BPF_THP_VM_NOHUGEPAGE if VM_NOHUGEPAGE is set, or BPF_THP_=
VM_NONE if
> + *            neither is set.
> + * @tva_type: TVA type for current @vma
> + * @orders: Bitmask of requested THP orders for this allocation
> + *          - PMD-mapped allocation if PMD_ORDER is set
> + *          - mTHP allocation otherwise
> + *
> + * Return: The suggested THP order from the BPF program for allocation. =
It will
> + *         not exceed the highest requested order in @orders. Return -1 =
to
> + *         indicate that the original requested @orders should remain un=
changed.

A minor documentation nit: the comment says "Return -1 to indicate that the
original requested @orders should remain unchanged". It might be slightly
clearer to say "Return a negative value to fall back to the original
behavior". This would cover all error codes as well ;)

> + */
> +typedef int thp_order_fn_t(struct vm_area_struct *vma,
> +                          enum bpf_thp_vma_type vma_type,
> +                          enum tva_type tva_type,
> +                          unsigned long orders);

Sorry if I'm missing some context here since I haven't tracked the whole
series closely.

Regarding the return value for thp_order_fn_t: right now it returns a
single int order. I was thinking, what if we let it return an unsigned
long bitmask of orders instead? This seems like it would be more flexible
down the road, especially if we get more mTHP sizes to choose from. It
would also make the API more consistent, as bpf_hook_thp_get_orders()
itself returns an unsigned long ;)

Also, for future extensions, it might be a good idea to add a reserved
flags argument to the thp_order_fn_t signature.

For example thp_order_fn_t(..., unsigned long flags).

This would give us aforward-compatible way to add new semantics later
without breaking the ABI and needing a v2. We could just require it to be
0 for now.

Thanks for the great work!
Lance

