Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3E483CFD356
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 20:08:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492406B00A2; Mon, 24 Nov 2025 15:08:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A076B00A3; Mon, 24 Nov 2025 15:08:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A7786B00A4; Mon, 24 Nov 2025 15:08:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 26AE26B00A2
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 15:08:21 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C553F1307D1
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:20 +0000 (UTC)
X-FDA: 84146587560.17.183A199
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf26.hostedemail.com (Postfix) with ESMTP id F310014000F
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 20:08:18 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OGsO7L3u;
	spf=pass (imf26.hostedemail.com: domain of 3MbskaQgKCIo60267otou22uzs.q20zw18B-00y9oqy.25u@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3MbskaQgKCIo60267otou22uzs.q20zw18B-00y9oqy.25u@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764014899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=y6cF97FuMaXldX4nVRk2ef3Y1LkWTsSlt/45nS3G5EU=;
	b=CCGO+FtbFtyKAhr1s4kOBHExhN4mNfg7i8Tbj9eZDEwuxNZsLjOXtAHV0DxCoefgWf5qRy
	aAOw/6+hzRDAsGb6J03DCDowhaKDxIo6/HAoXM1SaXqxdrwa2UnDZa/PUF/J+M6JBEZ+30
	SFY55ArKSY73/R6Qry0QeLxTYcywl7w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764014899; a=rsa-sha256;
	cv=none;
	b=LL2yk+Z3LIQO/oXys3IThjebhKEp9X73cMEREs3Rq3U5IRU82NJBkP7jKQjEECa9kjjVn/
	GyDIUyFYH4QSO7xfd4e9lpxUpBxZanJkIuoOKmzRejKRxBebdXri3O6xwEdChHT1JMzGaq
	c8bxmizSUr580PoGNm80jER9cGAn+gs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OGsO7L3u;
	spf=pass (imf26.hostedemail.com: domain of 3MbskaQgKCIo60267otou22uzs.q20zw18B-00y9oqy.25u@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3MbskaQgKCIo60267otou22uzs.q20zw18B-00y9oqy.25u@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477cf2230c8so12303115e9.0
        for <linux-mm@kvack.org>; Mon, 24 Nov 2025 12:08:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764014897; x=1764619697; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=y6cF97FuMaXldX4nVRk2ef3Y1LkWTsSlt/45nS3G5EU=;
        b=OGsO7L3uMrvZ2ijGUR+Csu31TtW8C+WOWfkIp0/IuAWuI0KUWRHDlytkVD9MJwl/Ev
         4NFtE3sSeYo6lrb3zE8ttMZoJK8OeLf80s8PdqEtXOqbDWi+6f7hFrCQKmSpdkKSjozn
         RUAsWNGZc0NERXIPlerDejCbOFTgn4TDYugYDbTRjD4wUGZfigpoqJusEfiVjzYbv430
         drKF3y6LytHal11h/O/hqVDIZYopcE8LsTzU+jYrIG/+HDPHQ46VNBbYkr1+0e2uYMbL
         PULRY4DZf4LTjsukz8f996WVw4iut0wl1VBClKk0GX0NtlKnux25vHRxNgg6hw0yxyBt
         O9CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764014897; x=1764619697;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y6cF97FuMaXldX4nVRk2ef3Y1LkWTsSlt/45nS3G5EU=;
        b=OXQ2cIZbADVRUX0+vD9Lb4xUCgcvNCIzPpaANsT7j435/Rbe5rCafck+bEgB48jJKA
         u48fCE4+aKoGXgDINQmEbDfa0WgUjaKpUneQLe2Kv6I3ongfF8K0+Yewi+enF+vg6xOW
         Yz6mehN3U+fzF8n9FDhPyOaiNa6k/W8z9A4NiO+Tgfx3hh9IDlWd51lCyDWs4IPTIXqg
         cVYG2iwd7OffJKEK3WAAsxSy2EX39TlXI/mNe7Zp2dSPrEJEyFWL+554fR3UvvwKC4Ui
         QJ0sFEXpuNXwcXOYQqS6ADYYcRAIF53b8bT5MYrg/ZYzlKGJ7QbySF5ed1zKMNkj9C9m
         c9UA==
X-Gm-Message-State: AOJu0Ywst+bGbogmDlrYi4hs86UxIyi/PPpAk4qodzZv5CR1+i/HcJE/
	6+RZJmM/VywckNKWg+OI9OOukND0Ts56LnEWfDbzg5xmHOx9CKmnN4WQUhVSHdX4KXrvA7GHf2b
	wukzpHt64UN6a3guMM5oNV1vAVrvPaZEtKMSTFl43Q9RuW4WhVzHBTkdSP5vcdQ68MpV7OiBtdv
	maIammf/EXJXg8n9O0h8LLJ8fb00npzf7PNL4C8/QnYg==
X-Google-Smtp-Source: AGHT+IG4vi0WfkeqorYIMjrVx6w0lretQ4YoAiBDlLabyKHqm8PtvfTjZqcpq685F8sErkOoMo/2vMj7xrLQbg==
X-Received: from wmcq20.prod.google.com ([2002:a05:600c:c114:b0:477:a656:6762])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:8b37:b0:477:76bf:e1fb with SMTP id 5b1f17b1804b1-47904b1ab30mr1341855e9.16.1764014897434;
 Mon, 24 Nov 2025 12:08:17 -0800 (PST)
Date: Mon, 24 Nov 2025 20:08:07 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.460.gd25c4c69ec-goog
Message-ID: <20251124200811.2942432-1-smostafa@google.com>
Subject: [PATCH v3 0/4] iommu: Add IOMMU_DEBUG_PAGEALLOC sanitizer
From: Mostafa Saleh <smostafa@google.com>
To: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org
Cc: corbet@lwn.net, joro@8bytes.org, will@kernel.org, robin.murphy@arm.com, 
	akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, mhocko@suse.com, 
	jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, david@redhat.com, 
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, rppt@kernel.org, 
	xiaqinxin@huawei.com, Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: F310014000F
X-Stat-Signature: x71oc47dnpmzk8t388uym4bxo3aydijm
X-HE-Tag: 1764014898-373602
X-HE-Meta: U2FsdGVkX1+8wS901ag5MlykUhjDJaiB8KEw650dgTvKXMdTHzsx6koZu5jtBuot+riVGJi+KINgsmmOziOZCtajMuaMyEOcs+97BYn1q8XilY2PBfcpHNGT7Sy6YprdvxA5HaVkyitVnGzS+nZ8zdynte4mTQkElWKTzw3eIDvqse/spgvagrwC0LV9Pmw+ClLUvWXmotUIpgNWI6O/EVDw8xYPuNlF4MPUY/ylpgJ15rvG8c3nFiHkqoQmLq12VlaKhH/2n2ip7c76s8cFAUry7EOHSs/kTQ8KUN2MyhFIjWFewUTG/XEhC8YTy9BVRMce0pHRJkAxTUrLq1mlpJUcE2+DDn0cFIdkL5iHy2gdylmvO8KPjbag94gTy8ck5YcJvILYLUhUCIQxTzf7LgzY6BbHJUyINY7X8iFxBjSmOCGV1/fQyUmGNSS+GMrlKUt0zVkg720kwE2ZXu5XgOte7i8SHPKuXniC9WdqSmEEpiMxpFSVzaGAHngHKkQqS+1Hma6gbeFmjB5OFrNiTJ/S/0sP43eg/XSx4GS5vEorLRHnyiE80yoRKwNdKgYX2Ub/RRvjIHwhN+KWDgh+UewnfYfMKRq6cuf1UdSiojiu55JUG5FEhqbUxNO7PVU+OTgtXoXHH8nW0PCuKpIL5NMv9QcIlmED4Qnx+8eiYEyqzVZe/P3wmnsSxhcwRXIjJlADTVmNl59+dXsLlbNUNoxWY+0nHZrYsR1FRo9fRZXYQ+UlN3hJP1tg6Gqi7sbVcGFC3XYDTx6dJR2YBgkWoswQx3CVAkqo7judSh1JEqFzu2T6HL0vzZnFTsgZHKeIafuYzpc/AsJEsRDMhasnsTtD9J0FPMyIRrVzAkF9tyOgBRDVVsLATWvCTY0jTLWlYAAKzIBtNKbX1+uWQbfn089Ew6BSbDEhwZkmn+Pt/Gq3bG01kKuJ5NZ4Yf/ds9tSNdadfGrZqwvkLQTlK+X
 QwrcrK6a
 uUYE7Hl4B9Qrx0mORR8KRMsJZzmS0G9YTHNDaRcb7nH8f/MHSnbPL0apbQOmMlJWUWr6ihdI2Rfb3CSLdi+dXoTaIORNPsGETZrsKXqi/uVQN8qc98Xz7ZjRvavVZrenfj+aHS6mw7lHl33R2lkzTOCsFFfnlLOrdv6vlHFI0fK6+qD4xTOeoJvdtTHxHdG1BiqXfpN4MBmLSlNA9BqN/Jc/gjutcSZcBbDTyI0HyOt4gYwOa5Tx4GMYfTM8VopaQs30ZQRB52vITYrOvgXnQPTDKitLxBMEbX0/C3V33rNvwAQ2zLxvWV6fH8Ro2IqugR1B/2cDXRwGS9RXQ0RET7X3bAScoUVWXJ9zC8fTJTLwMILnmkobjSM4bRr1KEr9eJGBEFK/R8z2STmiNaeZH+vuDgyQKr4ybQeXa6x0Ff3IifZpRHcv5PJGx46i+TTlDbglAjIOVz0ckGj4iWHF4klQKLZN13nuLR4r/01Uh9dSlMyIkkPXJz65TVYpzosZuWdyy+iJvtSWNrzG3GjXTjzLX7IlMjWXYq43VX4HILu/+iOmeCC8Qjn7ijypf9fNo/5iipBScD09q/F+ijqvQfSI8zPyIPvjtv72PkJLxeaQTsuxrlL3VAl8iLV5DkPGKEykt
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
4K - 4 threads		0.1/1.1     0.1/1.0     0.2/1.1
1M - 1 thread		0.8/21.2    0.7/21.2    5.4/42.3
1M - 4 threads		1.1/45.9    1.1/46.0    5.9/45.1

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
  drivers/iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
  drivers/iommu: Add calls for IOMMU_DEBUG_PAGEALLOC
  drivers/iommu-debug-pagealloc: Track IOMMU pages
  drivers/iommu-debug-pagealloc: Check mapped/unmapped kernel memory

 .../admin-guide/kernel-parameters.txt         |   6 +
 drivers/iommu/Kconfig                         |  19 ++
 drivers/iommu/Makefile                        |   1 +
 drivers/iommu/iommu-debug-pagealloc.c         | 172 ++++++++++++++++++
 drivers/iommu/iommu.c                         |  12 +-
 include/linux/iommu-debug-pagealloc.h         |  85 +++++++++
 include/linux/mm.h                            |   5 +
 mm/page_ext.c                                 |   4 +
 8 files changed, 302 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h


base-commit: ac3fd01e4c1efce8f2c054cdeb2ddd2fc0fb150d
--=20
2.52.0.460.gd25c4c69ec-goog


