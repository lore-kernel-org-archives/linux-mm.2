Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A888D38FEA
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 16:43:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 851A06B0089; Wed, 14 Jan 2026 11:43:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FBFD6B008A; Wed, 14 Jan 2026 11:43:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7292F6B008C; Wed, 14 Jan 2026 11:43:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 619656B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:43:33 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 30EF2160588
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:33 +0000 (UTC)
X-FDA: 84331140306.28.7BE9E50
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 73A721A0005
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 16:43:31 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BVCTxA7z;
	spf=pass (imf19.hostedemail.com: domain of 3scdnaQgKCDIgacghOTOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3scdnaQgKCDIgacghOTOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768409011;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ptbGfqhARAg/OJu3oyRxs8/LiGbyPAv+mElQ7v4+SEE=;
	b=XYhCRVn8T5fRI7IVR0CX7c5p1wg99+EAyiyRQoiI4BAQtlV6z1TxmNuhuSyksP7bLBJt9m
	suzyomZcSHEOmrAgcLIj7U+2suNI0cMcOM34fY5ujGVjAQ5XGPaGsoH6KuBWjWAsf11EID
	SXMFoendtsnd/YKyK5fV9NoY4XA1UM0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BVCTxA7z;
	spf=pass (imf19.hostedemail.com: domain of 3scdnaQgKCDIgacghOTOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3scdnaQgKCDIgacghOTOUccUZS.QcaZWbil-aaYjOQY.cfU@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768409011; a=rsa-sha256;
	cv=none;
	b=1H/xra4JnrieMYNdzHtbTVxK6tvz4T56Ozvh5V4w7vk2NEtgQY/jGfBtVodOzV6zAvJyLD
	+Cf97cdW4FFBmXUVn+vUAyq6wYqevWVllj2FB7e/WJtFb/JqBV1MxSni9TQwX30Eb/14vg
	Bmxv2cZQJwyyx7Z6JVJ6I/xk/t0Hxyk=
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-430fe16b481so17121f8f.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768409010; x=1769013810; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ptbGfqhARAg/OJu3oyRxs8/LiGbyPAv+mElQ7v4+SEE=;
        b=BVCTxA7zW7zHguSOB5BXoiQP2lVP0Ug4mhh0hN+WRGpIZLVnPIetLNV0jSxz/kLH/t
         3jW15//TH9+XgO8WyRr6DCPfIhspU9u1j34wSEGkv3PsAxNMIHwWQrAcj18D7Tdg4Kyl
         1FrzQzvo/Ff827XcKpDQQXCtAHPVpiZGKp1agqsCqpM0Cw2AQSU8wlbjk7Nr8FGlCPz+
         2HhVMlSQtXs1PyxDCd0L46a5fTHD8p1iRTw13VHCj/d4tLd6PjbiIXKW7ZgyWc62/QJb
         KCxJBp59oa2HWXEZ4j50UttrEwMcbY7YP3gvUsAPHudqsfNj7kOldckhIMOs1Kjlnx4R
         e8oQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768409010; x=1769013810;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ptbGfqhARAg/OJu3oyRxs8/LiGbyPAv+mElQ7v4+SEE=;
        b=EIHO1ZJG9k3h13quOIXDsUUgmBs/xMqVni02h91u06y5tMJjGl9YpoOC5WaI4aiU0P
         6yEhJ3Rb8G6ozOKeYs2gK6bjOWZY3/QS6JS5I/EmjP4XkpyqE9D+ckSsl3AET7cXrURi
         pXMWbC01+Zffw/mRehinyWw5jo7q1blnoEXNKstWiCBFWdud0iNQlLLVWYTJVjgKs1vP
         im7VTWRUqfUihkntX9fwhqMRQ18qj01pCHZa6PIH8T2PyO4J2AxnJLoCHXBvcyIhx5St
         yD+NWYyfei+bDaTKg5cY5UF/qS0q/i5JAlX/tVdnTu1ecKfSZJdRZ62v8d9xsyctbUnz
         SMsQ==
X-Gm-Message-State: AOJu0YwjxzlUpFwPsTUJbVxKtOTHYjN2j1o/nYvdc6Q0F1BxH8o/E6lP
	9NM21nrLLyCDJq4/O7rd90CjWhy+CYIz0eP+oPFSJKpeFE2r1NCzINpXgZn7uPpGxC+Sfnprluv
	6tYhnLCRbhNeIw+RNKFIwTKHpZuW8hMnwkESAZv2SOcSQcWsxpNypcH+F3l/etxq+K/U9xq0gj+
	GENzuvWzMOGRFoS1M6L/hdnHHFWcuPcQG6Tn5wua0eRA==
X-Received: from wmbem10.prod.google.com ([2002:a05:600c:820a:b0:479:3624:3472])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4e0f:b0:477:73cc:82c2 with SMTP id 5b1f17b1804b1-47ee32fcef4mr41658405e9.9.1768409009960;
 Wed, 14 Jan 2026 08:43:29 -0800 (PST)
Date: Wed, 14 Jan 2026 16:43:17 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.457.g6b5491de43-goog
Message-ID: <20260114164322.787125-1-smostafa@google.com>
Subject: [PATCH v7 0/5] iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
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
X-Rspamd-Queue-Id: 73A721A0005
X-Stat-Signature: 314ar5nfs1dztqogtnzz4g7c5hagw8cb
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768409011-780296
X-HE-Meta: U2FsdGVkX18wOQKwlVVJelW5HK6I1WVnFkkaUT+PT4rAktEDjYdZ/1ehpwe1kULOmOmva6gCd8x3NpZU3dEC6l8hMQAKPd9aBOn6SRGd9e/QqFLmI5TsEHyIst/paGtb8oW/lQeP1tpS+Bp6NiBYNiyRuB0V0USyVUdgQTfjcyuqU0hQGF/5MXrGOLQb4GHzm1KXz5spWnNniwL/9CNn6uxfAOvlwUXIqeeW1vTLUW1mrLyx9lm2ek24XpPH0ffs4DgKtK3hQmqfl6rucJJpyexNVtwSjJkU8vLST1goPW8GrPEEk9PIi96c+3hGqM+a+c4UwmQCUiOqddBMGFN+SCUnGYH9Djc5DRRq+uQsFPytChqzCoevxmRN7aGt47ymy0aBs1v1iNY/+cV0/0s6juoA7mrHc/BYCi3Y/BWugWrh6vRDSsWuRBUYk75ZiSnTv5TSLC6XTzjAg07TV0jo+RGcy2GQV2CcyGfMrtUVvRW3F9HFE0CpBURBvMFvuhbjGKuhfvR74GWsKZHYXW4zDoLhy+9jSjRbqzC8/zfBLJnXlIkfh6NLYcjZKBW0ByjQE5UZnMllRhxHxjEcsdsIUybz5gYbF0i81W36iqQkIGm4bL0v96f/YLYlwm/jFSofZyow0dDWxAOQ+vNHAamqVZiayfvc+TM2zby8u2LawApgvCwlPn6xau5i87CYsnw6wl2PbWWgrOwvet9pJIPxnHOaq9yM1T7q6kLK/3+4MpmR1GCF4yF5c4kbr3nto3CPB4SdVmI97b3cvKRznopP+vGrzw6LPUJuPbi85ygRMO8oeTAEn17+XSixjBRoKKNAwWzIlouYaReUN6djD/rxTX6+0c6vY//tPJCvR+bijZ3BvsR3InUYV7UBHtCHxjPSsWOJBbQkFASWi6NaDNWeNbP2AQTcwuL1K4udZObQg0QpAwWGhyFP5cksld0e2MKKtgevpYlJtxjleZXXAFA
 BHsoxzoz
 toC2uNVC2Xz22+eqV8PiBlDMLRuQmhNDdwn7OyYau/CSPnLirS0iX8xeZFybLDgbwXWz67LtIx0mtBdzyT5t27zWGEXoPb8udim4Offe50XVmz0arnoUMvDh5RSD2TuOMJbosralZazCbCbYpqbT+O0qCKSea67T7x4mIzKm5EXacb9lJqN4ztgPEWwWQpAUtydjkdRUrvsE2wgP+tWzkreUH5TmwIDMqewTt8y74nawMaF3CSGpjoo5/73d74G4jCYowpu6FbKFJhAq+3tBqtZLqrmtXJCONAL5YurYmmJU+f/1tUwcheSxJxm+gyzCZip75F7yDA5EJEvcXJxPycmps3KED7K0/2jeAttrK5Rqmyycq/jGsnVZlNaPMz6T2dPDEH8mA4H+nEwbvP7rBb9mvyWNitgZJSYP5iYoEjHldAGylI8W53f6oK1s56seawrauMpJPl32fVNmN12QZR417PUEZG1eJuKVM+3eSJ6FgAWCVkwgU4PnCqoB+dFuK9IkZEDaaDBcqScSB/DU5ZY217cLLlsxhC7j08jYHOt/JSZ698Rf7eGvE3YZHe2GwS7Letvu1iDyqYTnE342IlWLT22odYEkU31yQNEKXbSQdqIKT59meuvv6Xtfax64xrKVK
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
Earlier versions were tested on Morello with Arm64 + SMMUv3
This version was tested and benchmarked on Lenovo IdeaCentre X Gen 10
Snapdragon.

With dma_map_benchmark, tested on both SMMUv3 and SMMUv3, where:

CONFIG refers to "CONFIG_IOMMU_DEBUG_PAGEALLOC"
cmdline refers to "iommu.debug_pagealloc"
Numbers are (map latency)/(unmap latency), lower is better.

SMMUv3:
echo dma_map_benchmark > /sys/bus/pci/devices/0005\:01\:00.0/driver_overrid=
e
echo 0005:01:00.0 >  /sys/bus/pci/devices/0005\:01\:00.0/driver/unbind
echo 0005:01:00.0 > /sys/bus/pci/drivers/dma_map_benchmark/bind
./dma_map_benchmark -t $threads -g $nr_pages

			CONFIG=3Dn    CONFIG=3Dy    CONFIG=3Dy
			            cmdline=3D0   cmdline=3D1
4K - 1 thread		0.0/1.8     0.0/1.8     0.1/1.9
4K - 8 threads		0.2/6.2     0.2/6.1     0.3/6.8
1M - 1 thread		0.5/54.3    0.5/54.4    6.7/74.4
1M - 8 threads		1.2/339.7   1.1/340.9   10.5/331.7


SMMUv2:
echo dma_map_benchmark > /sys/bus/platform/devices/ac0000.geniqup/driver_ov=
erride
echo ac0000.geniqup >  /sys/bus/platform/devices/ac0000.geniqup/driver/unbi=
nd
echo ac0000.geniqup > /sys/bus/platform/drivers/dma_map_benchmark/bind
./dma_map_benchmark -t $threads -g $nr_pages

			CONFIG=3Dn    CONFIG=3Dy    CONFIG=3Dy
			            cmdline=3D0   cmdline=3D1
4K - 1 thread		0.6/3.9     0.6/3.9     0.7/4.0
4K - 8 threads		1.0/19.6    1.0/19.7    1.1/19.9
1M - 1 thread		61.8/372.0  61.8/374.9  68.1/396.7
1M - 8 threads		89.4/1470.5 89.9/1362.9 100.3/1373.3

Changes in v7:
v6: https://lore.kernel.org/linux-iommu/20260109171805.901995-1-smostafa@go=
ogle.com/
- Add a new function page_ext_get_phys() and use it instead of
  pfn_valid() + phys_to_page().
- Drop R-bs on patch 4.

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

Mostafa Saleh (5):
  mm/page_ext: Add page_ext_get_phys()
  iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
  iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
  iommu: debug-pagealloc: Track IOMMU pages
  iommu: debug-pagealloc: Check mapped/unmapped kernel memory

 .../admin-guide/kernel-parameters.txt         |   9 +
 drivers/iommu/Kconfig                         |  19 ++
 drivers/iommu/Makefile                        |   1 +
 drivers/iommu/iommu-debug-pagealloc.c         | 169 ++++++++++++++++++
 drivers/iommu/iommu-priv.h                    |  58 ++++++
 drivers/iommu/iommu.c                         |  11 +-
 include/linux/iommu-debug-pagealloc.h         |  32 ++++
 include/linux/mm.h                            |   5 +
 include/linux/page_ext.h                      |   6 +
 mm/page_ext.c                                 |  27 +++
 10 files changed, 335 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h

--=20
2.52.0.457.g6b5491de43-goog


