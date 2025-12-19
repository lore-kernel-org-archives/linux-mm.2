Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA9D5D74951
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 05:42:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1752E6B0088; Fri, 19 Dec 2025 00:42:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1234B6B0089; Fri, 19 Dec 2025 00:42:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 004C66B008A; Fri, 19 Dec 2025 00:42:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E0CB26B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 00:42:38 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 62CCF13251
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:42:38 +0000 (UTC)
X-FDA: 84235125996.17.4172D2D
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9F53F14000A
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 05:42:36 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="G9N/720a";
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766122956;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=3YZTuXKJS0jJ/FjWVkX1S0/dpihzlaBm67evQ8OxNp4=;
	b=0Lje7ilC1TQdcEeSYqPFmDmrc5n5VIWliSyVNwMMuvzZofyvxOa5nSs12hh4NNjET6zKjc
	4wdp/gQi8UL9KO9w6Qwqs4U5QaBZkRwlNER2fJfjJd876R0U09KBVIHNUm+X8ofVDL4bsl
	d4kzl+Jr8pnWlAaqhV+61sDJ3x3z/18=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="G9N/720a";
	spf=pass (imf09.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.179 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766122956; a=rsa-sha256;
	cv=none;
	b=ua1auq/JEcpC9Wiqzjxp3IXzWU7sQAkIHnPBg4+/FwFVHWpuQEhZIYMXs27kk6p6wVWPjN
	uojMBOYuzaKw4xjoFujQgbgrDdR7baBPWm4IkGFHYD0FAe/fFcQSiCUowgGb3/BhcJ+GRu
	ydkrRHSj7THXRo4LYdtvsyPka8il0fA=
Received: by mail-pf1-f179.google.com with SMTP id d2e1a72fcca58-7aae5f2633dso1413562b3a.3
        for <linux-mm@kvack.org>; Thu, 18 Dec 2025 21:42:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766122955; x=1766727755; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=3YZTuXKJS0jJ/FjWVkX1S0/dpihzlaBm67evQ8OxNp4=;
        b=G9N/720aKcKprvcJ3gKn+hZp4fVMzezv96K4rvrMyMPva/fI+Xe6OITTGpEAffXRDl
         V0swAnUZx8dn7OHJMCdBDMVIC63yWrmfem1e+XSCcUa8PowQPgFzPpFaKMplxiJ5u4Wo
         a4h7CW8qJ/Su4LkcuRwvBYUzg2Dp9cwHTp2RwB4U3HkNSY54YNCcMyZGsD/yxreGDJN8
         D92/n/rdA8Y05zO9oExFirOvDH3FBqgMKiXhuMoS3H5WaJAlm9gzELIQUvN91ZE09enL
         Fkjo6xelT+WrhFJt2PRDBDFNNRQFEXwxYuRNw1H+s7KyPHyeO6WBjsLOnZGVjJPVXziV
         XCrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766122955; x=1766727755;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3YZTuXKJS0jJ/FjWVkX1S0/dpihzlaBm67evQ8OxNp4=;
        b=Z7nPLqEJ8c7li6uXaP0srO4C3EABPfWe/3WYilwzHn5DG3rQhBPerb59AwMhkIwRHR
         SdZtK5ODlh73mQ/hcmrXGQLx8I/Sc9vb2rxNR5Pk3+nR24sJDiYswl/wP72lItqskZxb
         fEor9x1rDJw+i1y2U1D6VL6JbV5lBxkxsJFcpASkOl9fYwSeEn8XytVlpPf3brZOObvf
         CgUCUi6tm2Tt7qO/AilYveCSF35RzUJI9cBBC9aWYsNJoLZORhjdBsm2FqnI8dLAD44h
         iPGjrEDr8ah0qpYm7rUG9/QIYW4e5BFDAWec3ijMetcuKqiGyH7SXbBsN550Mjn82pph
         +tSg==
X-Forwarded-Encrypted: i=1; AJvYcCWKkS/PTakI0X7xK9EKQQNP1wetmZdHGP86JPv93WbSa5oCE022MYtjQPTk2/NmHDRjqDsdS4lTUw==@kvack.org
X-Gm-Message-State: AOJu0Yxj2Sk0qqd0M+26WWWp/paQ8P4qb4Zheb0+pej+nkb9Mx827nAA
	RBm9Fsmi7U4ho6vK3DGVxGqJogchynssj5CgR9jD2zNXjuYp+wh++zvv
X-Gm-Gg: AY/fxX6Exm8Q43BTtlepf1o2jqsHnWpXeUNCIL/20z8sbCawKapjmSM/jT7vD9V/f2x
	i5SQx6mT215XZTwheXs/fW7001QyuS8EAzKzc4n13+Y5F7JNF+mfT/yLp/HaXe00wXT75AqZ3bc
	97z6YsBlYkCmV4N/mmj9C18ANvl9wTfsu6LcVlo8sUZwNiyduLCnBp6yEPMhCdsB9nPuo+EH9S7
	JUDv5yz7Lg3r4RUFrXE50QrEI2x0OBTU97SEdE6UJMjMRov9TVJhrndGLsQfStAFr1l4Dig1CRr
	WgQQfITozKvzvVq9IU15UPeqLSzsHIxKKE6Gf6VXlSkK9UZF8YayCnIV3MY9jrizhRsdd9MugZP
	3sr+aiI6M5BmvkwRRJWa6bi0nIWeQxY5N5WT2guyBauPhvHR+CklYeIvR1GCaRwZUxFnPGWnXSp
	lFcHoGxQ==
X-Google-Smtp-Source: AGHT+IGI8fuFuucCjImuX4l87nELJyNl9OPjlv6P1lULzof6E2V8PchTbygl/w/ZX4miaVw5gIXTMA==
X-Received: by 2002:a05:6a00:414b:b0:7e8:450c:61b6 with SMTP id d2e1a72fcca58-7ff6607cf9emr1880110b3a.38.1766122955457;
        Thu, 18 Dec 2025 21:42:35 -0800 (PST)
Received: from dw-tp ([203.81.243.211])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7ff7e0a19besm1067558b3a.40.2025.12.18.21.42.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 21:42:34 -0800 (PST)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Sourabh Jain <sourabhjain@linux.ibm.com>, linux-kernel@vger.kernel.org
Cc: Sourabh Jain <sourabhjain@linux.ibm.com>, Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@alien8.de>, Christophe Leroy <christophe.leroy@csgroup.eu>, David Hildenbrand <david@kernel.org>, Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>, Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org, linux-arm64@lists.infradead.org, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v5] mm/hugetlb: ignore hugepage kernel args if hugepages are unsupported
In-Reply-To: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
Date: Fri, 19 Dec 2025 09:45:06 +0530
Message-ID: <875xa3ksz9.ritesh.list@gmail.com>
References: <20251218114154.228484-1-sourabhjain@linux.ibm.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9F53F14000A
X-Stat-Signature: r4mz8i1tpzy1zhncex87a4mh13a8bqdx
X-Rspam-User: 
X-HE-Tag: 1766122956-44525
X-HE-Meta: U2FsdGVkX1+rshljcbX1BJv+BrN7h9qACWxqpjD0/jG5jxOVPcY8LCNCFvAEl+KZ+WD6AFHhMf+a29WLXgqozlJpo0p4k265RnsOYW/L3Tcmod1CAI9H6Qap2jxO7FwkrhPkeTW7U+aUlUQMLl8Pmnkm/5j2vhQjRMIVbn1H9yy8/16FiqXeUItSky3gfMXPlzMfLyzWgBh6Q16wR2wqiyvv4JJ6pR39YnaPbasdMX98dqoC+RpEPZ2USmfVeOOUPvqvrF2LO5dn26N7Ml0bpVevnUT+zVed8wUN3NZK8YjjZD9Gj3JKH5ca4qwsNNQotqLbKCK3W02EDew7S3aLsfykASDCcm83Q+ZqeerqLsbtw/0PVJ+5nHy7WNPvwY4ZCf/zAmOjUscQagXVZeBLSPaNVjR9MjZKGdiwvIseqVoOlzM8GkxTiMOlw1c/wT8d375F2bjYrqNeUWjLq55Fvk0Ti+KzGiWp9+Pds+TB61Tx+JNVOVPgtkSKKb8nUmKL8BKVVF0I/auXRZM/kie/wg8Kkv4DnadOlqeYhgNFnGcg5pkhVGSHypJ/JNgnAz0P8Q6RXRyS+mUte/4trWMSxIJrBoZRShDnbYEwAa6PRuDQGrm4GWwbbXdi4scr4RFu+WwezlPCiGVmUzAXFtGHJn62jQp1aDu56JbRcX5pjZZojjqWiM68r4znLOimMEH/1nkX/eCtsozOLGAkGhsC1pwdIhSLXQJEB1IT5NeG+N++3r9ld1p6D5MXVZeqtiCprv8YCZwn4oxajALPeyCK1qlfJr3X31qC2Oo2sUOxl0VqSKUtvVa59xw3ff7r65lSiwxOnl3BOVocoS5l8ERmIgfez+QnkcluzRLx2IQs0pacHW/eKX4wCL7n5tXuqWmflwVcCbun+hU33E9hdZoh7WHI+kdtXLAvTESmJQ688Rk3WH0bI38fKW6U2YdcbHsYi0j7kylV0jwC4/P38pj
 WrRNCDEb
 yezt61nvfnHeF6JeFCqU83SZmmxBK9nu21pCpYBVcNer29zW4elVwrUyPDCb/FaqoWzFuKVU/Z8GJkEp7AZuLMztxK4N82Oi8WubV4pS5ZLznPTunbarJ9o0/qDI2UVrLMCwPdKNEXB5BOZ01xXA4dUwqRMGEI91NSvQM0fJ4nbmApjHrf/XXQGPhJ5rneKVvhdtys8b+lM7QuNZy0RaEJIync6dXniy5an8h+OJC0o7NkrX337IW2D9tKMv/RkonGDm37mDuGv0m5dBZTinNCDas2Vvi+8ZsSfFdRaFfyOARcgmSmi5Ug/jJz0HTn07oIM8r6jecYCBOalPhuMYiPkVI3fgtftqnHIGVdBSiBBi+N4stb/AHva9dQG5Xzam2xXHMcwgglCsbNoPPHx8rs5WZXeaNE+iaOpp6ujnFx8u/i6DOAinW/Uhj3h7p7jNsyJQx4P6XsMOgfs1hetoXXRvrfRdtfSIH+KbzDV29Q2zDzOI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Sourabh Jain <sourabhjain@linux.ibm.com> writes:

> Skip processing hugepage kernel arguments (hugepagesz, hugepages, and
> default_hugepagesz) when hugepages are not supported by the
> architecture.
>
> Some architectures may need to disable hugepages based on conditions
> discovered during kernel boot. The hugepages_supported() helper allows
> architecture code to advertise whether hugepages are supported.
>
> Currently, normal hugepage allocation is guarded by
> hugepages_supported(), but gigantic hugepages are allocated regardless
> of this check. This causes problems on powerpc for fadump (firmware-
> assisted dump).
>
> In the fadump (firmware-assisted dump) scenario, a production kernel
> crash causes the system to boot into a special kernel whose sole
> purpose is to collect the memory dump and reboot. Features such as
> hugepages are not required in this environment and should be
> disabled.
>
> For example, fadump kernel booting with the kernel arguments
> default_hugepagesz=1GB hugepagesz=1GB hugepages=200 prints the
> following logs:
>
> HugeTLB: allocating 200 of page size 1.00 GiB failed.  Only allocated 58 hugepages.
> HugeTLB support is disabled!
> HugeTLB: huge pages not supported, ignoring associated command-line parameters
> hugetlbfs: disabling because there are no supported hugepage sizes
>
> Even though the logs say that hugetlb support is disabled, gigantic
> hugepages are still getting allocated, which causes the fadump kernel
> to run out of memory during boot.
>
> To fix this, the gigantic hugepage allocation should come under
> hugepages_supported().
>
> To bring gigantic hugepage allocation under hugepages_supported(), two
> approaches were previously proposed:
> [1] Check hugepages_supported() in the generic code before allocating
> gigantic hugepages.
> [2] Make arch_hugetlb_valid_size() return false for all hugetlb sizes.
>
> Approach [2] has two minor issues:
> 1. It prints misleading logs about invalid hugepage sizes
> 2. The kernel still processes hugepage kernel arguments unnecessarily
>

And that every other architecture will have to duplicate this in their
arch_hugetlb_valid_size() whenever they face the same problem.

Instead like at other places, hugepages_supported() should also be
checked in the following cmdlines setup functions.

> To control gigantic hugepage allocation, it is proposed to skip
> processing the hugepage kernel arguments (hugepagesz, hugepages, and
> default_hugepagesz) when hugepages_support() returns false.
>

Right. Thanks for taking care of it. I guess after this patch [1] moves
hugetlbpage_init_defaultsize() to mmu_early_init_devtree(), it's good to
bring back these checks in the respective cmdline setup functions which
was removed as part of commit [2]

[1]:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2354ad252b66695be02f4acd18e37bf6264f0464

[2]: https://web.git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c2833a5bf75b3657c4dd20b3709c8c702754cb1f

LGTM. Please feel free to add:
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

