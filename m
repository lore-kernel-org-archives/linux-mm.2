Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1703FCCF9F8
	for <linux-mm@archiver.kernel.org>; Thu,  6 Nov 2025 16:40:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A6B68E0011; Thu,  6 Nov 2025 11:40:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77E188E0002; Thu,  6 Nov 2025 11:40:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1248E0011; Thu,  6 Nov 2025 11:40:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 594ED8E0002
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 11:40:12 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C69A1DF3B9
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:12 +0000 (UTC)
X-FDA: 84080744664.22.0874C5A
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6E1751C0007
	for <linux-mm@kvack.org>; Thu,  6 Nov 2025 16:40:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wWVf4JPC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3aM8MaQgKCIk5z156nsnt11tyr.p1zyv07A-zzx8npx.14t@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3aM8MaQgKCIk5z156nsnt11tyr.p1zyv07A-zzx8npx.14t@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762447210; a=rsa-sha256;
	cv=none;
	b=qBfQBfaopSddMsApsdPFidfkNiL04ps3WJ3StTmdGpXoJP8gvgEz+gsL7CpchhNOSMMes1
	lsGMqHg1DZGfp7uPZeq64Bk7wm59GTaN75wOypnm1egY0Al0E8QB228I2fzAIK1/WDM9Ce
	Az0i5jQG+MHCPSQDCG9oIuCJPjFWyGs=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=wWVf4JPC;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf20.hostedemail.com: domain of 3aM8MaQgKCIk5z156nsnt11tyr.p1zyv07A-zzx8npx.14t@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3aM8MaQgKCIk5z156nsnt11tyr.p1zyv07A-zzx8npx.14t@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762447210;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/LFdv3AJsjeDbdyHxZcbSRtknBSxAI/EO76KEsSfSxM=;
	b=HeRSD0qnrRYTlvjrM4M/F6rJBOlzD4asKD6w5xXQjGH1nVGA1DYLkGSdSa8Mo4DZSK+pvE
	x8J3cyyPMEV9J72rorPjVFs2+YsEugEvengEY+vH7ai/qzL/ZpO6hybJT77u5SHUg1/PuI
	s35YKWku4kJSCeG7IfPuFMnjWPh6VpI=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-46e47d14dceso5718565e9.2
        for <linux-mm@kvack.org>; Thu, 06 Nov 2025 08:40:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762447209; x=1763052009; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/LFdv3AJsjeDbdyHxZcbSRtknBSxAI/EO76KEsSfSxM=;
        b=wWVf4JPCtw4MQfMpahMfStitTzBD3z0KX/x2Gb1KmHX6K1CUXsOlHkQv+4/jbLQf58
         TEs9EzkO13JwMKGUgMleXI+pxtqePmD6shsxCrKxreTgeNaO9g86xnROGxVUKid3EDB4
         2HTpxAhzTXGvwFNv0DiYJyvg6c3d8MAfLfNL6yD0JCMp8dQehsJQEpJxHY8TmS/+8GtS
         I/wHkHcjwbuszDzsR3/cq25RsyuOD9UaSMguAnlyWm/JwG93LFm1tVtSz8d65EZbe7bl
         RsY5bZwmprQDpLS9bQdesqZww2Ix0nROOiwI1/RhOe+89K54DR5S3i/m25QebK2vLZon
         S5fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762447209; x=1763052009;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/LFdv3AJsjeDbdyHxZcbSRtknBSxAI/EO76KEsSfSxM=;
        b=LVPQRL5oB38yFY9f2g7Ar87Zmt1WS0X5ANGQqmO+N79RruFDfGKC07swJc5U2c6RWO
         LLPy6YYeZzvockEvjKA16+nNEtCyrNJM5xbQrBRv/nVTX6c3eUBHHU5QMs9n581t2KX7
         TMJw6ptyPJE1i9eT9vH5OdkJlgbYBmazYwX4wK+waSO6ld3+37OLjIYl3EtwC2c2nU2O
         50Rht576u3RLj0QwzOodnVekWWIWNqiqKcBrnwknB3GcjGm9LxDlb6J3+Ca2hcGVlyEN
         cYczUVQmzY6/Wm/xttboJy3pVjYgJnIVyGOvNafjLqVHChUhs83F8hpj3f3OOUSFBNV4
         d2lA==
X-Gm-Message-State: AOJu0YwOb0RD4SR+nhowqKtOgj/iJPtl8TOdhR/HbnoOzBECZd8BH0hU
	D7pooyYU4ky1Z4bKAxdJjGJzndQvHgNir8ajShLpzmP/0RLTWr+9p4M+LIuyFuaQGbrndGMwqFZ
	eBCSX2KGhORRo85AoOXnrmG2MqKMTIK4A3GzXjgY+5kzGmgbUhwslc6yXDMRIKyKR5vvtRx6R0j
	EchisKx3gzuOwUHVyiFive65PSCtVIdEOOKWemhyaBtg==
X-Google-Smtp-Source: AGHT+IHxGvKB7RNBXPd5yjtxQlMPWEmFro0Urso+GGwuaW5qjEm9Qb3qx0pkyEB024YUCyxOSQ+DM6J5drYxMg==
X-Received: from wmcm6.prod.google.com ([2002:a7b:ce06:0:b0:477:1716:3f2e])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a12:b0:477:55ce:f3c3 with SMTP id 5b1f17b1804b1-4775cdad693mr58624485e9.5.1762447208638;
 Thu, 06 Nov 2025 08:40:08 -0800 (PST)
Date: Thu,  6 Nov 2025 16:39:49 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.2.1026.g39e6a42477-goog
Message-ID: <20251106163953.1971067-1-smostafa@google.com>
Subject: [PATCH v2 0/4] iommu: Add IOMMU_DEBUG_PAGEALLOC sanitizer
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6E1751C0007
X-Stat-Signature: jg59dkohzqz19h43xza9ddf57awnaxjq
X-HE-Tag: 1762447210-915369
X-HE-Meta: U2FsdGVkX1831Ran5Wjllf26kb4Niu5dGUFRjWZT7lleOdGxpJjH/WMAFRmMv8+49jJW3OvekFIm2/69G4ubIX2MDT7tIAtwGks7kgmiO27DGA+ARcoFmgKmRbkLu7FpoWU1b1bD+f8t4k029EcxPW+DGcKDluBagG0yx7ZuP2txRKsaXe4iDmsqdXAVOkrcyTNXUi2EEnTIH8tF6muHY/VU04rHk+qKE0Nr1F+c31pEXBUFpaOkzD+xfNYOsiR0Trky0SpyhxJvcb/ZFgjGNZB7xsNkRFcGiMT/VozMfJjQAgfCyW6Sd/gW/BEZZzXuxzq/S5dyGo+JoIX0pmWyeanLDKAr6s2ilQdZDolIJ4JK2dfn4cOT5Ql/IYrYmGeQ1ffJd/51vakhlrXIc5rclIZiGY2p9NleagyvJNJU+rYaJaKk9Lk6d+p1tT9hL1q5oN4X1uQHkPYMG+0zWEHy9TKDsCUPC8CP+RQSmzSaq2biR0siA9Fp4/v+ZoVfmkP9ab8x8TjttJlKrYIV/TArdIJTmflvUlubdaj/DhnQSFm6otqm9qQFVdQDDv27KRskSnL0wLp7zHP+uR/zOKIqMUi20GoDl6V7t9lN5oveZpfV8QClWrV89VUqlwseNXeP0EgDeW84jywBjQxXUHYji5/h10KZJc5Lv38mXQz34BqS7xvNFj8wbvQNDu9iWurfOApDfm/tb4SuWoserri7Fw63MC+um7aKga6gJPnbz95dXrUKzFpI/Y9WYLs4amitk7L1avAo2yruDfAg/qUzGOoeeu3lrFIt4Ps+swCwOyYKvV7arZ5RLLvbGFpxNE0vLPyPjx/a9OGOVApWgwEUijEo1q7bJIanNviqMMICIJdXBeyV8uDGaNPA6MlZ281oVZOW22JEn0iAB+UPjIyn5/Qz2MUhIQduIKQJWkCGypc2aNZowmTqdq9CUPiNK5M2t6SCOcP0SKcoCjHVfnj
 ZNtUp4zK
 wupKWFkK67XUv8QD/wu+zbRG3QayvZP3hTe/CVw3/CbbnPUKtodYmUSgtecHbFPa13o5dEwFVh3B3VezP11zR6vDyNCSMnm+cb/bW67uqylMdQaG7q2sQioSSfDxAyhkDn0PGBxTeC/kJbTjBnVdFWL54lfJN7beXEVt34DsRinKA4QRWa+jttwueEkAM2GYVlLCoUA6sf/8zGNWZuNu+PKb6FlaZfG1DH+O6jJBjLzx1wmWSHu82ckA5GroFzbBy6vaZJrUM3gGSbGAJNraaOOBpz8FM+yH1UlxwCBcgPcldzBebnSG/ATHtWd9jPh7CtbVkxNF3ij0JHZ4OL9e4GVhyNkIUKXZpA3M77Gf2QErGinH9PtJYlnButQHW4SOw8ilAolckiiXNkkttIGhQ/IYvQYITfSX/6pSeNxSwsUpnRnmjVu7wDlis/uMkq7e55O8Us1VT2JQFp+X2tS6zGj6JVznb9wV9AnAn7h+vZEG8VBiu61ApFvU+adOQCR3qsPZXEhmAGAc9ZmGdzGn4Zwonn/BH3BhzD63AoI3Ra1XN82c38Ajt6xM/CoaWvDxbf+mrdBupDC4C6jCXs7w4qyJR/ul8v4T4Kug9T8V5p0ulZ4BWOxD6o/nLVlyvRSuDvvt49Bg1oKnU+eFwlJVCqj6LsQ0ERAGncD4g40tPzV+/KiYnWfQz4X6X7M4jOfMjpKcdlTxOirGkqPCKmuuoYe39sGqeuzYdYXfkHDExapQmJap1Hz7SKRPJyQ==
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
count and WARN if it is not zero.

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
Also I booted RockPi-4b with Rockchip IOMMU.
Did some tests on Qemu including different SMMUv3/CPU page size (arm64).

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
4K - 4 threads		0.1/1.0     0.1/1.0     0.1/1.1
1M - 1 thread		0.8/21.2    0.8/21.2    5.6/42.4
1M - 4 threads		1.1/45.9    1.1/46.0    6.0/45.4


Main changes v2:
v1: https://lore.kernel.org/linux-iommu/20251003173229.1533640-1-smostafa@g=
oogle.com/
- Address J=C3=B6rg comments about #ifdefs and static keys
- Reword the KCONFIG help
- Drop RFC
- Collect t-b from Qinxin
- Minor cleanups

Mostafa Saleh (4):
  drivers/iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
  drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
  drivers/iommu-debug-pagealloc: Track IOMMU pages
  drivers/iommu-debug-pagealloc: Check mapped/unmapped kernel memory

 .../admin-guide/kernel-parameters.txt         |   6 +
 drivers/iommu/Kconfig                         |  15 ++
 drivers/iommu/Makefile                        |   1 +
 drivers/iommu/iommu-debug-pagealloc.c         | 148 ++++++++++++++++++
 drivers/iommu/iommu.c                         |  14 +-
 include/linux/iommu-debug-pagealloc.h         |  83 ++++++++++
 include/linux/mm.h                            |   5 +
 mm/page_ext.c                                 |   4 +
 8 files changed, 274 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h


base-commit: dc77806cf3b4788d328fddf245e86c5b529f31a2
--=20
2.51.2.1026.g39e6a42477-goog


