Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6BD1C9830C
	for <linux-mm@archiver.kernel.org>; Sat, 17 Jan 2026 01:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12EEB6B0005; Fri, 16 Jan 2026 20:46:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DCE06B0088; Fri, 16 Jan 2026 20:46:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF43D6B0089; Fri, 16 Jan 2026 20:46:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D9C6C6B0005
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 20:46:42 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66AF4C17A5
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:46:42 +0000 (UTC)
X-FDA: 84339766644.27.4FE7A8D
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5C37D120006
	for <linux-mm@kvack.org>; Sat, 17 Jan 2026 01:46:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BD3XIi4v;
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768614400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QawnIC/rKqzEiT5sLO4diiV4bNp94xP9Rmr2Cmn3G2E=;
	b=T+e4ZPG/3GwDyRJgi4US2OwJRYjUE+AeHC1ODfb144SgRUcWOrkU32iVmHBVy9R2t/iU4O
	WEbcdcfm7rugvvdOUEFV346nVcGHtw1Bb1mM3l2Xb/hVDEm2Gy6oMevo2RmqmeycKiL9P1
	cxdiXSG9/1QFkKRAkd/lghcUU+64bfk=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BD3XIi4v;
	spf=pass (imf29.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=jiaqiyan@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768614400; a=rsa-sha256;
	cv=pass;
	b=GXdrDEJOyu1ZKcmoNwk+lULh2RL53POv8nUWeTKLk/TVwD8I9e6y1dhWbNQ3NekD9i+WaU
	aiF0RamLxrLaezLdJ+04MY96caeNQipN91Q8Di2i2obuk+7w9WiSLuIbIFLQtzIuv5kF2e
	0X26OwTKhDql4UY5WJpTS+eDO2dM3lg=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4801cf7c2c7so10935e9.1
        for <linux-mm@kvack.org>; Fri, 16 Jan 2026 17:46:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768614399; cv=none;
        d=google.com; s=arc-20240605;
        b=BUp1M3WkX+syhu5sgaUnPzlXqwa5DlTaovguDmIyXjag34WN0YY0mnWz1SxFAJtQ+K
         3IOw0pDkEZpkT9rswYFvy8ZqmB6eaKXhHHmr/wPteGYA8E0M5zjwpq5HApBQULut9DkS
         vywIUyS8f2LRVzTHdyWXhR5OaxlExju9hUxMKPprQSdjv3CmG1SSqi9GDfjjL1QxVgxw
         V+t8MgypniPuaZukZbGxg3OkTFL/rLySEC6HJhDnWCtcb2sxCVhS+VzcihZ+dfahRtgM
         xQQ3dbVKt1lKhmNm/E9OQCToLGy/FranNa9h4Z/0/v6CKF5aAdVk7TIu9bFSdUYMn7rZ
         3dkg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QawnIC/rKqzEiT5sLO4diiV4bNp94xP9Rmr2Cmn3G2E=;
        fh=Z2HVBDPTkdz/lfP16IS9dnol4sMD+FEdPiu7qSmxO6Y=;
        b=g8X1ORSX0AQ7TnQiePMPoO4xIpuUw7bbdt3afvhio56uxs66Aw8s9mK6gZL+0DhSLw
         DQiSWm0YBEGqjxB4hsoWT4ESWUJKGL0H+mXPbco4V1U8X6WySPhpzfIPHUkgBUEHpG7k
         9RQ3irCT7rG28eQmQlzDOR9ioCyPCrAKcXjDW2KQhtDLmxV1w6t4YfLWvNGIgbKr80KY
         0s5lFwuHhw8BwLelZdVjd1S4WmWAxvoD9PcE4XWB/tCzm55K78VbtLF6V7o/iC908ke1
         Aqe7CNhV2dPn+3ds7/baUv02r/C1FBaNaNBmbD7TtmSjDCIdg2+HezcTrJg8v8OYltHS
         Qxfg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768614399; x=1769219199; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QawnIC/rKqzEiT5sLO4diiV4bNp94xP9Rmr2Cmn3G2E=;
        b=BD3XIi4vr9lN/8sW2P4VmmLW4B2mkdToIszv3QQQY3LkGy8x7T+tX0AmKOZx7GiSN5
         IIzjF4T6xuf5o+LGyewZ/SI6YQ0VH//vxmbhi1bL1evxoUy8htBrVB31iiUOTz3b70Re
         Nr9qMuBT3NTR34UTBgR2rHgR/XumzTlxmGlSjL2z40ZpaRyUzxbw61ysHLtLOXVf0Pgm
         TAAqpxj6qqtfmF+RYEjTjnscop9je0QQcFtBKwf/brPltmMW7sGFLUZcFvgsfj8Lqir+
         zaJTU2yShugbE0z1CeNCC/85/vsNlMNZaRSttuAz2QlaxS+wA3hOlUn3GT3y6I64lY7o
         4KRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768614399; x=1769219199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QawnIC/rKqzEiT5sLO4diiV4bNp94xP9Rmr2Cmn3G2E=;
        b=vbc0hi8qLujZtIqtzByxESSND+W1aagB5kUl+UhRWx/cb1EaKrP4/ppSPgJYLs4s8f
         A9csbFAg4KDDVhhqSfgXsYzHz2YgiPUYy1XYbaFkz7yAHyRaCeU+pAaiJUnFiK31gOjt
         tBUVwG0n2xNdEWbArmSkJp8JLRULeLhy5pVfTypo87MYkx6mNH3KaGAPsfkYa1+CQFZC
         jfZ33VzFkT2X139xZwf/JynCZ3bymGWhA46izo9vP6bhPhuzQKJ2cGqUQMOA3ajDYXGs
         GSymBxoLVDl/nwcJ2JyJ7gIKp3fwdQ7YYwY6ZxczvQq8fpm/nY/VVHbXqIlHH3Nbb1eX
         EnPg==
X-Forwarded-Encrypted: i=1; AJvYcCWUGP3fPyMFZGnR274G7Ip+x3RjSUmC2twKRL31JyMASe1ssQW1aAahc+84IU14skvNY+8XhXS7UA==@kvack.org
X-Gm-Message-State: AOJu0YyQaBpWUeHyYe2e6U2PFrSu1LU+r39dH7tp9SdM0cj6jsZegG15
	KdPY6PYQIpv+3N+we9xqmL648C77LBerF8nZGcIJN5JlJM24xJVQkja/D8AKrlkhd7c63HRpuer
	sfDF5q7cj/NC67QLyLGQy/qYJdA3YnWEJX2EFhHEH
X-Gm-Gg: AY/fxX5pNXslfPUfklviPFnh6mBWVJwRc95q1tWyaGiZYQrLCLHEFY/K8B4SbGz27dk
	gWAOqFcxUgkv5VEAHQ2sPXVVZkoYos2vccBQAgvKI0zpivkbDMr0yl9uoSZyq3yL+xYmJMOj3SK
	o9lybQoSH11C8OGO046FUClZlMMk3PdJu9FezaAskI82yXixa57atK8O5QBPRz6D7AtN9tbDETh
	hhdNG0xgC7rofu2NuQH+xV/wdgAwJ9/XYPj2ONYWd9M7MOboAptKUmJISMIgzDNcMAq+iY/rrt5
	RblXpnKr8P7KFydaPOOQb7xEeg==
X-Received: by 2002:a05:600c:2159:b0:47d:7428:d00c with SMTP id
 5b1f17b1804b1-4802831ff1bmr125265e9.17.1768614398594; Fri, 16 Jan 2026
 17:46:38 -0800 (PST)
MIME-Version: 1.0
References: <20251102184434.2406-1-ankita@nvidia.com>
In-Reply-To: <20251102184434.2406-1-ankita@nvidia.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 16 Jan 2026 17:46:27 -0800
X-Gm-Features: AZwV_QgWqDDKvf2998qT7WGKusfsVNwwlVxtPgQtBBUSk5Pxl571jMObyaPcU9E
Message-ID: <CACw3F51k=sFtXB1JE3HCcXP6EA0Tt4Yf44VUi3JLz0bgW-aArQ@mail.gmail.com>
Subject: Re: [PATCH v5 0/3] mm: Implement ECC handling for pfn with no struct page
To: ankita@nvidia.com
Cc: aniketa@nvidia.com, vsethi@nvidia.com, jgg@nvidia.com, mochs@nvidia.com, 
	skolothumtho@nvidia.com, linmiaohe@huawei.com, nao.horiguchi@gmail.com, 
	akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, tony.luck@intel.com, bp@alien8.de, rafael@kernel.org, 
	guohanjun@huawei.com, mchehab@kernel.org, lenb@kernel.org, 
	kevin.tian@intel.com, alex@shazbot.org, cjia@nvidia.com, kwankhede@nvidia.com, 
	targupta@nvidia.com, zhiw@nvidia.com, dnigam@nvidia.com, kjaju@nvidia.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-edac@vger.kernel.org, 
	Jonathan.Cameron@huawei.com, ira.weiny@intel.com, 
	Smita.KoralahalliChannabasappa@amd.com, u.kleine-koenig@baylibre.com, 
	peterz@infradead.org, linux-acpi@vger.kernel.org, kvm@vger.kernel.org, 
	Axel Rasmussen <axelrasmussen@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: eewsgcfky9yxwjx5zypygeipmp5mqp93
X-Rspam-User: 
X-Rspamd-Queue-Id: 5C37D120006
X-Rspamd-Server: rspam08
X-HE-Tag: 1768614400-145367
X-HE-Meta: U2FsdGVkX1+okzlp0Pe1SIjQOJj01bp8slTcPFelkBDW7pMZ/PXOpeppr0M3wJ4/zmhgu5Q8/8pyXCeLeC6/rMm8dLN3TAIK49kAQWNeGBUStvbqV9NlEkVk+SLMKgKpJyzDJfODu83v9+XEuEr8UbbstArwlCEXgG31EjLRfD0/d3duF9MMM8q9Z/fOGkt9owddtvTSYvEzUbFY8I9DCxPerATXNqgpoSU9/Jj4/E+LdGGlpSJu3tk9BmTBeHMzv4B140lTYX3988+xYDNKmaZLlL7Tb80cKzantTafTPKHjKSbB8FKFJk1gV94ZHEAuiSW5JBuwOdA6Yj13BDSZLwZCWT/2WL8MY4xfzqHQMjhwfWRi77LWSscc73OBQic/Vjjge3vf0P/Foa3v25vLyhxp4S0oZuYksCWWBA3UA5FMvU16emSIcJf1i1yMr/Au5YptyJi7hnTF1geem8ivkXy3YzTVNABml1H82M8CaA5UGmRVKv9ILjILxEGKH+7X1/9N32Q/MXAw6GfJrLa0dLcTR0XilTnmx9s1v7ymeh+2OejRwgTQRTqDwgeC26KY4dPgbcabld1vpm/mQEFHSAkb/ZsDHLTZ7VFozGXlXTdM774MslFPfwwGeTWUdT3LCvclGy4xKc8REsglnu3ZV56nsZbk3hyMTdeMnwV30DDjrZvn0mFSrsRMDUSbtH2E7l1+fjg3MzGGXRUqasygNpwFpBNn+QAe2levu6FLEydVEBHkt/e+al3zPEwoqyQrNO4/aKngi0bPc5REpLmosZYSiCsspm5LYFgZPS/kWjQmHRt8HGOTJmcQRqQwxQvsXSgxk+1D2PWaqRwhq566i0ttPqooFDl2KU88TmvrLvOWEcKweDsfQteZFb3mHl4eBSqi92utGsQaKsJsniqGX02iwLfDouTADF0SogKXTQ+cZ58pjacEoGnkPKv+W5fkbTwKgRavqA0s/NOxy1
 lsvw78pv
 wCMrxx7/njmHB+AbbVmjrge01ENoAoXFNcj8hzbF6vTyn+pKBIYk3exic7sOURClYqap+0+kfcPX4CiEbzsEuWqtGYd9e6Gecjp/ak3Iv7IlsWcyTJDEDuVdI10yIFNhBSdcrl83M2kdUp0VZ+GJ28Gjgjb7z3r5ps4GsE3QxqbjpxD8T9J80h0BQjyzlOxtvAordbEhtp/MLO3j3UPloNmxtNiqmyVryZ+W9V5wmUf8m2guuG3HRGielsC6rR07FUrHBkDzYOCDNWCerEjGB9wlSQBlIit/7v1yMv1VAy5nMGSQguGIGoF7NjR0FrTE0bTXBUAjhl71XyNhQQIv6seYCLv8L+LQwdTDKOKck1Ziw/sCssoclBEI70w7OefsEWOes
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Nov 2, 2025 at 10:45=E2=80=AFAM <ankita@nvidia.com> wrote:
>
> From: Ankit Agrawal <ankita@nvidia.com>
>
> Poison (or ECC) errors can be very common on a large size cluster.
> The kernel MM currently handles ECC errors / poison only on memory page
> backed by struct page. The handling is currently missing for the PFNMAP
> memory that does not have struct pages. The series adds such support.
>
> Implement a new ECC handling for memory without struct pages. Kernel MM
> expose registration APIs to allow modules that are managing the device
> to register its device memory region. MM then tracks such regions using
> interval tree.
>
> The mechanism is largely similar to that of ECC on pfn with struct pages.
> If there is an ECC error on a pfn, all the mapping to it are identified
> and a SIGBUS is sent to the user space processes owning those mappings.
> Note that there is one primary difference versus the handling of the
> poison on struct pages, which is to skip unmapping to the faulty PFN.
> This is done to handle the huge PFNMAP support added recently [1] that
> enables VM_PFNMAP vmas to map at PMD or PUD level. A poison to a PFN
> mapped in such as way would need breaking the PMD/PUD mapping into PTEs
> that will get mirrored into the S2. This can greatly increase the cost
> of table walks and have a major performance impact.
>
> nvgrace-gpu-vfio-pci module maps the device memory to user VA (Qemu) usin=
g
> remap_pfn_range without being added to the kernel [2]. These device memor=
y
> PFNs are not backed by struct page. So make nvgrace-gpu-vfio-pci module
> make use of the mechanism to get poison handling support on the device
> memory.
>
> Patch rebased to v6.17-rc7.
>
> Signed-off-by: Ankit Agrawal <ankita@nvidia.com>
> ---
>
> Link: https://lore.kernel.org/all/20251026141919.2261-1-ankita@nvidia.com=
/ [v4]
>
> v4 -> v5
> - Removed pfn_space NULL checks. Instead a wrong parameter would cause
> a panic. (Thanks Andrew Morton for suggestion)
> - Log message to mention kmalloc allocation error and the failure to
> kill a process. (Thanks Andrew Morton)
> - Comments with 80 chars.
>
> v3 -> v4
> - Added guards in memory_failure_pfn, register, unregister function to
> simplify code. (Thanks Ira Weiny for suggestion).
> - Collected reviewed-by from Shuai Xue (Thanks!) on the mm GHES patch. Al=
so
> moved it to the front of the series.
> - Added check for interval_tree_iter_first before removing the device
> memory region. (Thanks Jiaqi Yan for suggestion)
> - If pfn doesn't belong to any address space mapping, returning
> MF_IGNORED (Thanks Miaohe Lin for suggestion).
> - Updated patch commit to add more details on the perf impact on
> HUGE PFNMAP (Thanks Jason Gunthorpe, Tony Luck for suggestion).
>
> v2 -> v3
> - Rebased to v6.17-rc7.
> - Skipped the unmapping of PFNMAP during reception of poison. Suggested b=
y
> Jason Gunthorpe, Jiaqi Yan, Vikram Sethi (Thanks!)
> - Updated the check to prevent multiple registration to the same PFN
> range using interval_tree_iter_first. Thanks Shameer Kolothum for the
> suggestion.
> - Removed the callback function in the nvgrace-gpu requiring tracking of
> poisoned PFN as it isn't required anymore.

Hi Ankit,

I get that for nvgrace-gpu driver, you removed pfn_address_space_ops
because there is no need to unmap poisoned HBM page.

What about the nvgrace-egm driver? Now that you removed the
pfn_address_space_ops callback from pfn_address_space in [1], how can
nvgrace-egm driver know the poisoned EGM pages at runtime?

I expect the functionality to return retired pages should also include
runtime poisoned pages, which are not in the list queried from
egm-retired-pages-data-base during initialization. Or maybe my
expection is wrong/obsolete?

[1] https://lore.kernel.org/linux-mm/20230920140210.12663-2-ankita@nvidia.c=
om
[2] https://lore.kernel.org/kvm/20250904040828.319452-12-ankita@nvidia.com

> - Introduced seperate collect_procs_pfn function to collect the list of
> processes mapping to the poisoned PFN.
>
> v1 -> v2
> - Change poisoned page tracking from bitmap to hashtable.
> - Addressed miscellaneous comments in v1.
>
> Link: https://lore.kernel.org/all/20240826204353.2228736-1-peterx@redhat.=
com/ [1]
> Link: https://lore.kernel.org/all/20240220115055.23546-1-ankita@nvidia.co=
m/ [2]
>
> Ankit Agrawal (3):
>   mm: Change ghes code to allow poison of non-struct pfn
>   mm: handle poisoning of pfn without struct pages
>   vfio/nvgrace-gpu: register device memory for poison handling
>
>  MAINTAINERS                         |   1 +
>  drivers/acpi/apei/ghes.c            |   6 --
>  drivers/vfio/pci/nvgrace-gpu/main.c |  45 ++++++++-
>  include/linux/memory-failure.h      |  17 ++++
>  include/linux/mm.h                  |   1 +
>  include/ras/ras_event.h             |   1 +
>  mm/Kconfig                          |   1 +
>  mm/memory-failure.c                 | 145 +++++++++++++++++++++++++++-
>  8 files changed, 209 insertions(+), 8 deletions(-)
>  create mode 100644 include/linux/memory-failure.h
>
> --
> 2.34.1
>
>

