Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A184CFD652
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 15:25:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED6B96B0088; Wed,  7 Jan 2026 10:25:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAE156B008A; Wed,  7 Jan 2026 10:25:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB0996B0093; Wed,  7 Jan 2026 10:25:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C7BCC6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 10:25:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 99EA2B8D4A
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:25:10 +0000 (UTC)
X-FDA: 84305541180.17.B6EE357
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf02.hostedemail.com (Postfix) with ESMTP id A897F80015
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 15:25:08 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2bXGC/T1";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767799508; a=rsa-sha256;
	cv=none;
	b=H2jgXcVXPDA1Hwnigph9/+OrcK3gmAO5E+/CoWjfQAUQUIGrJpuWZ8+t0MjJNY3YHy7EZY
	SS72ez4SXfKIsPmqCd5rEty+Ze5vM4mV5Q7pa58tJNC/HupVW7m9YlHXJ2/TZUHb0vZXv9
	YkWKCn5dA+d0WP/PiX6HHAiux7cpV+0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2bXGC/T1";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of praan@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767799508;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mL3jyZUpIqGDPVZblrA8h5rKljtD6YCYa6ewKnuMe84=;
	b=Q5rDQLj9xImOnuFajiCy4qVbK7gmOS7dPNFgdNaFjpPp9Kznwu6qhD/oEtPRiEzg+sukgY
	tQkCVzMxQK8GYyDNN4MeIxocq+eybFQDSHOG+jtJ+8+5NQJVUTUI68tCg5gZ+Sy8QA5WPt
	VqohofASlXTWe3cms1gGEtF0tkjXv+Q=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a1462573caso83585ad.0
        for <linux-mm@kvack.org>; Wed, 07 Jan 2026 07:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767799507; x=1768404307; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=mL3jyZUpIqGDPVZblrA8h5rKljtD6YCYa6ewKnuMe84=;
        b=2bXGC/T1Yw6/40sk1PtZa5439xW0qksE8AFZROUi0WUcyzn9fv+3knKKPzSV6sum8T
         rvw2WtDfxzgSY32P8ucv0Ej3cnTEPzp0/ETimd6ggec5IVATgGjIag3XMKwsk+HwiVHv
         LKL6kVF331arBYwgxfHQcYYK7u9ICPYE1quOHNrba1KI8bryzxe1dYrlkg+w9f7RDFpj
         OoTO59eeK6uQbCUyPqIuNM3/eJo/ito5XoSqkVbq9hV2aC/4/VEYtnGCrUWHGKtjb8SJ
         GoMv1amjHWA6lMuMEjOheoJcPXWjrkiX8oJE/HGnGkTRBQ3he0CKiiwL4oYMtqtk36IP
         Y4nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767799507; x=1768404307;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mL3jyZUpIqGDPVZblrA8h5rKljtD6YCYa6ewKnuMe84=;
        b=bRPv9reiutMb/F1hXcaHTkBp8Di9LJK4RaIjt2JWdMgXvsXb5pMe0/V4j56+6om9V7
         lmDtrf4TxFaz7iPA+xO8JwONzNpx1jT+1uXkH5Lm7buL6j2AKjk9bYFq+Tcf1fR7VRAn
         VMjG5IZiVX9Wr6QLNjmZYVr8kWAE7PXiJepg/tvJ/xwTHguT4pcw1f3IDSr73zuBMP4I
         LE82eibGrxn6G6WZflb2qgbTzt4HNsbTduaPF/YH9iR+HA4/Xpk4KMghjMECbvpAL84Z
         IeSmK90W6m1wzO1dsdjcLlHW6SUpe6nVHJHfYSLo0LEJgyjDPQ8B4mWgaGKbwD/GsWhY
         mwig==
X-Gm-Message-State: AOJu0YyqhsnzSicvVBMSL84ttlQh6lWzZ2nEslz7OSUIVsyDKCFOMaJY
	d9Cy6+Ydt1PgNqky3pCK0VxCZc32d4D37fLdosKq6zANN0NGDSyi9n4Ef27FIQw8tA==
X-Gm-Gg: AY/fxX7BM7W6M5vFtKZQ/jJv8NIGXgzh2HfRckDxKHk2m/QzpjN3jcfbqqa9/efMzBN
	JsiYQSmkBe3UeihU7T8OZawV+eUZYdt81c1Z6U48mwZ60+Xih2NboZsohjeYorQH19KB2vf7L+r
	s80T5mx4bPVCurgXgzpmnnmSU/F/dG5nT6IMLO0RPzpagoL6eHS4Blj2/SAifMxRyZXlFXtcpX/
	FQnQMMRu+zt/Ar0v9f8lyq5OgqIXQ2ceI5RDiEhx4HfzwYVK0/zwpn70QWwopp31/KVVd4pkn25
	1lHM7nTe4SgCqRCyf3VGw/d9J6C+BgeROy1bqgfNK/n4pUnoYxmQa2geNulWtd7ZakYnKeWjasb
	Q1wvmT+U2vuCfBu5Z3CMsm5VKlxNv8/CIMcjrPp0IAsRjnEsQuEqjpikOVRKpz8OPjUE7XklzKi
	IZL4wcfllL3iJcwMcAwDQUF/k/DlKToIoV4J7udEthhO6ma04z
X-Received: by 2002:a17:902:c950:b0:292:b6a0:80df with SMTP id d9443c01a7336-2a3edbc4a49mr2836835ad.10.1767799507191;
        Wed, 07 Jan 2026 07:25:07 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c4cc96ca7a9sm5548384a12.25.2026.01.07.07.25.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jan 2026 07:25:06 -0800 (PST)
Date: Wed, 7 Jan 2026 15:24:59 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, corbet@lwn.net, joro@8bytes.org,
	will@kernel.org, robin.murphy@arm.com, akpm@linux-foundation.org,
	vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com,
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Subject: Re: [PATCH v5 0/4] iommu: Add IOMMU_DEBUG_PAGEALLOC sanitizer
Message-ID: <aV56y9KcAS8mC7Uk@google.com>
References: <20260106162200.2223655-1-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260106162200.2223655-1-smostafa@google.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A897F80015
X-Stat-Signature: rrb51a61jzseiqh7ptmerap8dya4jm8y
X-Rspam-User: 
X-HE-Tag: 1767799508-576652
X-HE-Meta: U2FsdGVkX18qmVr12SEzpNfpvPpEXUYPU4s9CG65maLCYdZeyhgelVAtFlhHqMumig1ZSDZo8uikOmzCeptemV8scfkewi4PeJFFmE4kqLvpsvX77vi/V6z79xAML5rKzcmZk/OqCZK9OOASsshP7PIRYQj6h1rOpraZdDE/ND/UPvAWW5YaFG7erbXPJT65xb/kPMKbFuwCHIOKF0NRjvz+r1OAIfINDS2agmZboWiEPHBiDKK2b2i0na478DWbJgOOqvOu7lJDLnvujXK4Q/meRu8DfB27aXQJ7tu5HNyMoC6WAGLqH8/fQCAkqc0rEhndm22XokDKDqp5SYNag7w9FVJpj0b2CQonn3RACZfgYpKRi6X/bC+pivGCpUWeLJgN4kYXwSnpcsyW28H1I3PZnfAy5DxbpudsLbmKpuPk1D8HkC1gym9w5ZYYoO4KELzCbK3GfuJYFsb0uyuoDLEpO7eqZjpWmCwTj06/TUMVHqMowuQy0I8jS8teAko/1MKCuVtDUzjsxY5f7Q9oB2o4FWpMaehZsKpKzu3nhW8r66sTCeudPyGi/KpYtw3C4PuuIwdCH812Q5co0c5PMOtFI8sHfIupizYD9KGNuCmVwEAXljOfEQ+hdpjABvfe0+Z3Toi3A5d6Zluc2WBfvLK+mqYxdU0gJRYUQ0kYj/FqMBfJ8eWZHpKWFfoZ+q0aLdmC0++JFvdW4deI9/WbLSba8qUJuSKzmyq+J1SBpzFQWJXcIC+Ml4C3May15qSylEt5FkphlIeIsB3lkuHY06uTLiKZRb+KTQzaTbDPIkQLl+qTvjQkj/XXRIF3UtXgyJJ4v43+FVC+mWoefL/oJlkVfP7s78fxOWzY0K1m4KrGjiSjLCmhm9YVymcm/i7kUrSZl8apYCb2ZHcTk4zickqOWbUHfViPe1EjOXmEI+q5nkWjR3AzocgvvRonCjEeievYbdNqlCFkUllBHqn
 oGP9nPGa
 orQoANw9vHbJwIWmx14HmJ+Qw44+lM0RUNZ4njTauyDa/+j6H1hVNIr5uR7nkrZ0dzK9JN2mwFv6sf6j0/TyoL3/qb+y2rObgcQuwQpLe/5m3/FkqFdEfF1nPQAsxR1Uy054eUPDObToR+9wQZdBlcc0HTdCyJvGuakdfBg0zogo8bUEURxJRxkI5pps3HcJuICTfxx8USLZ22B+O7qqPf7p8+75a32/qvwbjvRAxZe8UhVbifSnBXrzIhUXpjMO0CQlg+wLDo/bvOt2qIF7Hck4T22D0aWJpKd6OUaX/9i/p46i5xdBAh1fB8g/Ixa1Hzs8w8FAOZLm8WjVYT0bI+T6hduGX4o5kb7talanuSKXoM+j7wjgFFo81yQpqZ4vwp1LeGYCXCNLC1sLP7NNc2mxVucCPfeiOXhTb55xr1NtekhyPoe5k3zKbfo1RyaaeLXb2
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 04:21:56PM +0000, Mostafa Saleh wrote:
> Overview
> --------
> This patch series introduces a new debugging feature,
> IOMMU_DEBUG_PAGEALLOC, designed to catch DMA use-after-free bugs
> and IOMMU mapping leaks from buggy drivers.
> 
> The kernel has powerful sanitizers like KASAN and DEBUG_PAGEALLOC
> for catching CPU-side memory corruption. However, there is limited
> runtime sanitization for DMA mappings managed by the IOMMU. A buggy
> driver can free a page while it is still mapped for DMA, leading to
> memory corruption or use-after-free vulnerabilities when that page is
> reallocated and used for a different purpose.
> 

Thanks for this series! This is really helpful!

> Inspired by DEBUG_PAGEALLOC, this sanitizer tracks IOMMU mappings on a
> per-page basis, as it’s not possible to unmap the pages, because it
> requires to lock and walk all domains on every kernel free, instead we
> rely on page_ext to add an IOMMU-specific mapping reference count for
> each page.
> And on each page allocated/freed from the kernel we simply check the
> count and WARN if it is not zero, and dumping page owner information
> if enabled.
> 
> Concurrency
> -----------
> By design this check is racy where one caller can map pages just after
> the check, which can lead to false negatives.
> In my opinion this is acceptable for sanitizers (for ex KCSAN have
> that property).
> Otherwise we have to implement locks in iommu_map/unmap for all domains
> which is not favourable even for a debug feature.
> The sanitizer only guarantees that the refcount itself doesn’t get
> corrupted using atomics. And there are no false positives.
> 
> CPU vs IOMMU Page Size
> ----------------------
> IOMMUs can use different page sizes and which can be non-homogeneous;
> not even all of them have the same page size.
> 
> To solve this, the refcount is always incremented and decremented in
> units of the smallest page size supported by the IOMMU domain. This
> ensures the accounting remains consistent regardless of the size of
> the map or unmap operation, otherwise double counting can happen.
> 
> Testing & Performance
> ---------------------
> This was tested on Morello with Arm64 + SMMUv3
> Did some testing Lenovo IdeaCentre X Gen 10 Snapdragon
> Did some testing on Qemu including different SMMUv3/CPU page size (arm64).
> 
> I also ran dma_map_benchmark on Morello:
> 
> echo dma_map_benchmark > /sys/bus/pci/devices/0000\:06\:00.0/driver_override
> echo 0000:06:00.0 >  /sys/bus/pci/devices/0000\:06\:00.0/driver/unbind
> echo 0000:06:00.0 > /sys/bus/pci/drivers/dma_map_benchmark/bind
> ./dma_map_benchmark -t $threads -g $nr_pages
> 
> CONFIG refers to "CONFIG_IOMMU_DEBUG_PAGEALLOC"
> cmdline refers to "iommu.debug_pagealloc"
> Numbers are (map latency)/(unmap latency), lower is better.
> 
> 			CONFIG=n    CONFIG=y    CONFIG=y
> 			            cmdline=0   cmdline=1
> 4K - 1 thread		0.1/0.6     0.1/0.6     0.1/0.7
> 4K - 4 threads		0.1/1.1     0.1/1.0     0.2/1.1
> 1M - 1 thread		0.8/21.2    0.7/21.2    5.4/42.3
> 1M - 4 threads		1.1/45.9    1.1/46.0    5.9/45.1
> 

Just curious to know if we've also measured the latency for larger
mappings? e.g. 1G mapping backed by `n` 4K mappings?

> Changes in v5:
> v4: https://lore.kernel.org/all/20251211125928.3258905-1-smostafa@google.com/
> - Fix typo in comment
> - Collect Baolu R-bs
> 
> Main changes in v4:
> v3: https://lore.kernel.org/all/20251124200811.2942432-1-smostafa@google.com/
> - Update the kernel parameter format in docs based on Randy feedback
> - Update commit subjects
> - Add IOMMU only functions in iommu-priv.h based on Baolu feedback
> 
> Main changes in v3: (Most of them addressing Will comments)
> v2: https://lore.kernel.org/linux-iommu/20251106163953.1971067-1-smostafa@google.com/
> - Reword the Kconfig help
> - Use unmap_begin/end instead of unmap/remap
> - Use relaxed accessors when refcounting
> - Fix a bug with checking the returned address from iova_to_phys
> - Add more hardening checks (overflow)
> - Add more debug info on assertions (dump_page_owner())
> - Handle cases where unmap returns larger size as the core code seems
>   to tolerate that.
> - Drop Tested-by tags from Qinxin as the code logic changed
> 
> Main changes in v2:
> v1: https://lore.kernel.org/linux-iommu/20251003173229.1533640-1-smostafa@google.com/
> - Address Jörg comments about #ifdefs and static keys
> - Reword the Kconfig help
> - Drop RFC
> - Collect t-b from Qinxin
> - Minor cleanups
> 
> Mostafa Saleh (4):
>   iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
>   iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
>   iommu: debug-pagealloc: Track IOMMU pages
>   iommu: debug-pagealloc: Check mapped/unmapped kernel memory
> 
>  .../admin-guide/kernel-parameters.txt         |   9 +
>  drivers/iommu/Kconfig                         |  19 ++
>  drivers/iommu/Makefile                        |   1 +
>  drivers/iommu/iommu-debug-pagealloc.c         | 174 ++++++++++++++++++
>  drivers/iommu/iommu-priv.h                    |  58 ++++++
>  drivers/iommu/iommu.c                         |  11 +-
>  include/linux/iommu-debug-pagealloc.h         |  32 ++++
>  include/linux/mm.h                            |   5 +
>  mm/page_ext.c                                 |   4 +
>  9 files changed, 311 insertions(+), 2 deletions(-)
>  create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
>  create mode 100644 include/linux/iommu-debug-pagealloc.h
> 
> -- 
> 2.52.0.351.gbe84eed79e-goog
> 
> 

