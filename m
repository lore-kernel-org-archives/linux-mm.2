Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F05A9D26D6F
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 17:18:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 271F26B0005; Fri,  9 Jan 2026 12:18:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21F736B0089; Fri,  9 Jan 2026 12:18:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F73D6B008A; Fri,  9 Jan 2026 12:18:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F18926B0005
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 12:18:15 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 92147B9C2D
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:18:15 +0000 (UTC)
X-FDA: 84313083750.21.BA3834C
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf04.hostedemail.com (Postfix) with ESMTP id A78C340009
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 17:18:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jYZE2i5g;
	spf=pass (imf04.hostedemail.com: domain of 3VDhhaQgKCJsNHJNO5A5BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VDhhaQgKCJsNHJNO5A5BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767979093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=EFPXi9jlv9rMnyA0grBQkKfopvHJmF7zvIc7VHv8N58=;
	b=8WCKLTjm8ev+gmKhXydcjy+AwmAWmkiYAM5frq3wOyOPIcc1UXjUiRxvX5uGPJ03FdhY1Q
	53BBlU33hVBfjZQkKEUVLk6rss+dCEc2Ku5qX0WgGeg60GCvQcJ0O3DQv37FJMHpU2zSgK
	FTIoB7hgSZPc2aA1FrSwRh7RnJVvcCU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jYZE2i5g;
	spf=pass (imf04.hostedemail.com: domain of 3VDhhaQgKCJsNHJNO5A5BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3VDhhaQgKCJsNHJNO5A5BJJBG9.7JHGDIPS-HHFQ57F.JMB@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767979093; a=rsa-sha256;
	cv=none;
	b=WtUJVvvvTCUmVAVTXyfMxydosFMpeXhJjuQCshJx/FbWvLWTYAYqy8CuTfezg24y83M/SI
	+CzZs7/Q+0w+byz3ou0jjrZD1hIMsRoO4h4hxpCrx8Y9HUqb6P/e+23kxMbdtHybTlswxs
	yhlbcTUpwIrKXd0hax6JgGmZci8pkF4=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47d17fff653so20608445e9.0
        for <linux-mm@kvack.org>; Fri, 09 Jan 2026 09:18:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767979092; x=1768583892; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EFPXi9jlv9rMnyA0grBQkKfopvHJmF7zvIc7VHv8N58=;
        b=jYZE2i5gOKNQmrozFaikLn1mcn+M4bs8Y7+33H7I1+IHibS1asrozmMDHnTPNZzq3/
         StkWw+05ZNcqOstDnSfJ/9GMT2h3ehrwjiqemFxg5Hswml1bDF9x4JIIXMorKBk1L1ma
         EbDT8+Iedt74NEu+Rb9DyAFUEHG5BiXg44sd5UAOEtiHwaN88CGgx5++n83earGnYHY6
         CG5xtupRoKj7bS4pqQKGSFX3LERvB26ojyBJLj343JHA4rO32SO9prlx/T7c0dDdM7UW
         duPhmgwcebIKpFKL94SwOE+b79vS6mtt+CgPm/ek7X0TI7WwLt1pGhfHJ/hsZ82bbvGG
         hIBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767979092; x=1768583892;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EFPXi9jlv9rMnyA0grBQkKfopvHJmF7zvIc7VHv8N58=;
        b=HTOMrVMYj/ZyihB4G9CIY8nlPm2X+rG0I7Sz4kgJFyg+PR/GPsBcDDaR10BvPsyaw8
         ljwbPUc33mX9zNSzImxx9S7hp3svJJ5LjSOnpI9Cp0JIm9jq3z55OzE9aSV6oxizHjfS
         Bxc7nqLPjNvDnAgRcof70+XYrSV1n4qJr0bavGXmrILP7HKHOdEUikgdDkGPCQvNbBnu
         Ue8Ctkmfu/K82dRrrpXvJiSSzzT7sr923mR4pTAzTlbx9VG24FmaSGRdJf5UqUyeh5Hd
         EKs9pwSKXX0kbnpqazBZGSmmymX8HWWHI16QBtvXqlMEH9Upxz/xPYmObVnD71lItGsZ
         RwWQ==
X-Gm-Message-State: AOJu0Yw6Rqi373SR6k/PdAW4q0etafNJlFvyGR9mLjNjxFPjy7s+nW/X
	kv43R2BpSrN0xBlaZLmkcFe1N1hGwrEtJhgjoVjaBuNZMP1pZbZCV/7ksDOPjZgcvzExzJXQroB
	1zUum0rxy3qarohC2o3F70erKAPI7AZv7WiVDlGM4kq6nQwFnYZzbYGz0VsSc+7ruC/kSy0yuE4
	wERESdc43qGMm1La2o/kadK3hG61F5HijCbfKp1chlBA==
X-Google-Smtp-Source: AGHT+IFocuqh4xf3N3PNsIA9bVyZchbl85zeIdFnVspAH2mPKuFwxxYp6oh+Bwc2UYAh9iIB3e8vzhQ1q9OD3A==
X-Received: from wmba20.prod.google.com ([2002:a05:600c:6dd4:b0:47b:d5ad:dd7f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1d14:b0:477:97c7:9be7 with SMTP id 5b1f17b1804b1-47d84b0a7bdmr116367135e9.1.1767979092009;
 Fri, 09 Jan 2026 09:18:12 -0800 (PST)
Date: Fri,  9 Jan 2026 17:18:01 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260109171805.901995-1-smostafa@google.com>
Subject: [PATCH v6 0/4] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, baolu.lu@linux.intel.com, rdunlap@infradead.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: u5bcesxo5tkwxsc1y777kxnswaaoar8m
X-Rspamd-Queue-Id: A78C340009
X-Rspamd-Server: rspam04
X-HE-Tag: 1767979093-147388
X-HE-Meta: U2FsdGVkX19snWoT5Ybk8KNMxR2K2om4RIkDTW++lwzteyEFkVlNeUiOE0IyvovwBZBfztS/YvmBd6+NJmOzRjHxRWH7SAbqgIuoJNsjgRHXMQpuA0jtG4rEn8Dr2/82nUuZvO9g/lnhXRJr8bIJ/Zv3KqwwBwa2bQbUqA8ElkrAc8Jxk/t/yCOkZtxAe9t/fRPS9RubcoQiaF2NlND+H6wHAMIRYkV9hwid7lU1gdLDCHIyX9D4M+DBuQCEfB7ZU3rd5IXzEo218wdNw5EYc7oojdL91kHqiNDMx8kfEdi9OcMMrOEdhC3KbcAhcquXXNgkeIgysIrKnizBKar5I5gl3gWoLb2Lv/z4rJ05XwW6/eud/+M0VsiUetojbpOzBsICVmHTr+bUuMuXIdSbxYLmGWH7JHXFRoRAmZQBE3BHv3xiCzTUlv3xZRrKpUxnD/JNBC26wjXidKjCiWevNxCRHDYtYiLJxs/HQzHc4NwWLByJaU5mfQNL6SosxA99dKgzYJRF7uwzdyUt1v0AWEHaBqVg59f4h5qEBC4+s56l9/Om5wxJV1SOV1+Eh8yHi6aP2Fa6jTGtjyd2h0xWGx/obCwWYBtX/ou2PCI013Yza8Geam5m5CvJFh4bfDcYEVhDPhiat6LjBytAKLKPb3tx03gY46Hk2ugPfiIR+CrfYC1jjdyfYnHIllOsfIO2OSuvrnffjXsfK9RPdmLOx8UxvJ8qWY6hSLVMqAeteNYHk6Nja3vyJEwrk2lGbGVjDkcUZMtGa4YXf95DqjJERFlVCv0GmW/bNWXFo1mK0shwG2ozWgL4adStH6Xs4rUdQaeeLGZhgCyDar60T86U6r6QjC+Nkqu/8Fx6lLGAttJqK5MvyaO01iZBmLdhTLuzHtb/7chyFBi64BuUQqRgW8TB93Drn0QFKZTfKiYuR2ebIFlCcDYPvpJeOKhMKuUPhQ2jsuOddaRUCRoZRtS
 ye1A0WGv
 6i7lSzAxLYyh2N37Nj5NJ09p7BfKnOnr9nKqP8JOpzQK6zHtE/MwiNP7X+X4g/c0CH5UMXr3UaRzAsCQ01UfB4l868QwDOaMAEpQadISyvTYXCfQCNK8s6PqvftrQteEDpAgc+9+LQ8DBjR7NFAo4IwHvD9vbz3vrLOnxpCMxVtBe9QIamF+tClQlCIppXYLO3quzlUXwjByMRVAfZnXmcikenlB65Gf+eaUZqy7FJu/iF+1SEhf/rYTP58XzsYfdh14ErISyHGuOCdCUynNWP63tQHMzMBE0CysOh4bkv4mu+ItccLJ/Rh1YlDvdUUBADXqsLGF9vXSxqgWDweTx+YpcjDC0JYyHBH98YlIPnOSE38kduFFSqknK1890VEZmfLqIKsq0Li2T5zVv4Arl5kX3m5gEQ/dXd+z1dowY1AHpzpuA+jsZ3XTZ/E/KphiCI2bZD0k4UXlSya4quepGV/EX/H1gGewKOja9A+4Hpb8hcAZVQ8Qspy8ddKOPWEzQF6wjgJC9+spF3xtiSvbMqrlJC3TT7nc50FukyXZooPqWpJa8iZXkdV3AtZpil3Z2MWEIOz1NcHkM3GTzLL6aDPcIFwUXoeQbciMFEaJKZ304kARYxRy4f1t5+Vko/aIoyKZB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Overview
--------
This patch series introduces a new debugging feature,
IOMMU_DEBUG_PAGEALLOC, designed to catch DMA use-after-free bugs
and IOMMU mapping leaks from buggy drivers.

The kernel has powerful sanitizers like KASAN and DEBUG_PAGEALLOC
for catching CPU-side memory corruption. However, there is limited
runtime sanitization for DMA mappings managed by the IOMMU. A buggy
driver can free a page while it is still mapped for DMA, leading to
memory corruption or use-after-free vulnerabilities when that page is
reallocated and used for a different purpose.

Inspired by DEBUG_PAGEALLOC, this sanitizer tracks IOMMU mappings on a
per-page basis, as it=E2=80=99s not possible to unmap the pages, because it
requires to lock and walk all domains on every kernel free, instead we
rely on page_ext to add an IOMMU-specific mapping reference count for
each page.
And on each page allocated/freed from the kernel we simply check the
count and WARN if it is not zero, and dumping page owner information
if enabled.

Concurrency
-----------
By design this check is racy where one caller can map pages just after
the check, which can lead to false negatives.
In my opinion this is acceptable for sanitizers (for ex KCSAN have
that property).
Otherwise we have to implement locks in iommu_map/unmap for all domains
which is not favourable even for a debug feature.
The sanitizer only guarantees that the refcount itself doesn=E2=80=99t get
corrupted using atomics. And there are no false positives.

CPU vs IOMMU Page Size
----------------------
IOMMUs can use different page sizes and which can be non-homogeneous;
not even all of them have the same page size.

To solve this, the refcount is always incremented and decremented in
units of the smallest page size supported by the IOMMU domain. This
ensures the accounting remains consistent regardless of the size of
the map or unmap operation, otherwise double counting can happen.

Testing & Performance
---------------------
This was tested on Morello with Arm64 + SMMUv3
Did some testing Lenovo IdeaCentre X Gen 10 Snapdragon
Did some testing on Qemu including different SMMUv3/CPU page size (arm64).

I also ran dma_map_benchmark on Morello:

echo dma_map_benchmark > /sys/bus/pci/devices/0000\:06\:00.0/driver_overrid=
e
echo 0000:06:00.0 >  /sys/bus/pci/devices/0000\:06\:00.0/driver/unbind
echo 0000:06:00.0 > /sys/bus/pci/drivers/dma_map_benchmark/bind
./dma_map_benchmark -t $threads -g $nr_pages

CONFIG refers to "CONFIG_IOMMU_DEBUG_PAGEALLOC"
cmdline refers to "iommu.debug_pagealloc"
Numbers are (map latency)/(unmap latency), lower is better.

			CONFIG=3Dn    CONFIG=3Dy    CONFIG=3Dy
			            cmdline=3D0   cmdline=3D1
4K - 1 thread		0.1/0.6     0.1/0.6     0.1/0.7
4K - 4 threads		0.1/1.1     0.1/1.0     0.2/1.1
1M - 1 thread		0.8/21.2    0.7/21.2    5.4/42.3
1M - 4 threads		1.1/45.9    1.1/46.0    5.9/45.1

Changes in v6:
v5: https://lore.kernel.org/linux-iommu/20260106162200.2223655-1-smostafa@g=
oogle.com/
- Remove wrong logic for handling unmap with bigger size than requested
  and warn instead.
- Collect R-bs and Acked-by

Changes in v5:
v4: https://lore.kernel.org/all/20251211125928.3258905-1-smostafa@google.co=
m/
- Fix typo in comment
- Collect Baolu R-bs

Main changes in v4:
v3: https://lore.kernel.org/all/20251124200811.2942432-1-smostafa@google.co=
m/
- Update the kernel parameter format in docs based on Randy feedback
- Update commit subjects
- Add IOMMU only functions in iommu-priv.h based on Baolu feedback

Main changes in v3: (Most of them addressing Will comments)
v2: https://lore.kernel.org/linux-iommu/20251106163953.1971067-1-smostafa@g=
oogle.com/
- Reword the Kconfig help
- Use unmap_begin/end instead of unmap/remap
- Use relaxed accessors when refcounting
- Fix a bug with checking the returned address from iova_to_phys
- Add more hardening checks (overflow)
- Add more debug info on assertions (dump_page_owner())
- Handle cases where unmap returns larger size as the core code seems
  to tolerate that.
- Drop Tested-by tags from Qinxin as the code logic changed

Main changes in v2:
v1: https://lore.kernel.org/linux-iommu/20251003173229.1533640-1-smostafa@g=
oogle.com/
- Address J=C3=B6rg comments about #ifdefs and static keys
- Reword the Kconfig help
- Drop RFC
- Collect t-b from Qinxin
- Minor cleanups

Mostafa Saleh (4):
  iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
  iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
  iommu: debug-pagealloc: Track IOMMU pages
  iommu: debug-pagealloc: Check mapped/unmapped kernel memory

 .../admin-guide/kernel-parameters.txt         |   9 +
 drivers/iommu/Kconfig                         |  19 ++
 drivers/iommu/Makefile                        |   1 +
 drivers/iommu/iommu-debug-pagealloc.c         | 167 ++++++++++++++++++
 drivers/iommu/iommu-priv.h                    |  58 ++++++
 drivers/iommu/iommu.c                         |  11 +-
 include/linux/iommu-debug-pagealloc.h         |  32 ++++
 include/linux/mm.h                            |   5 +
 mm/page_ext.c                                 |   4 +
 9 files changed, 304 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h

--=20
2.52.0.457.g6b5491de43-goog


