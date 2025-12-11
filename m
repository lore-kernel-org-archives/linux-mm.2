Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 067D6D41C34
	for <linux-mm@archiver.kernel.org>; Thu, 11 Dec 2025 12:59:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 406EB6B0007; Thu, 11 Dec 2025 07:59:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B83F6B0008; Thu, 11 Dec 2025 07:59:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CF376B000A; Thu, 11 Dec 2025 07:59:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 197AA6B0007
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 07:59:38 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3FD516014F
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:37 +0000 (UTC)
X-FDA: 84207196794.16.7A774D0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf11.hostedemail.com (Postfix) with ESMTP id E71F240002
	for <linux-mm@kvack.org>; Thu, 11 Dec 2025 12:59:35 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="saXjF0/T";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3NcA6aQgKCPAkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3NcA6aQgKCPAkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765457976; a=rsa-sha256;
	cv=none;
	b=V7CGH8OPpIS2LSwrrqQ51XiwCo/Hv1tB3XeWRz5CjKjTUFc/9GJulP/2IQEjZ91lCKoTeG
	4HQBTjy0WyvRdmu+DKuyMI4v6Ehkwc7JDzR11LVcRg5ZQCm5AtcQMtjBrKQaVc8N3tThy5
	T7o4/XqopGaZ83WzP+NqVhl7ViLHoyM=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="saXjF0/T";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf11.hostedemail.com: domain of 3NcA6aQgKCPAkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3NcA6aQgKCPAkegklSXSYggYdW.Ugedafmp-eecnSUc.gjY@flex--smostafa.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765457976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1YPd4rabCA15+W0gc58X3ldTKNVJsgSl/m8TAJcDC9k=;
	b=eSe8fDHLUnbVXpba/YUH0hQ83VIymVyzSpASO/wEkm0UlTX4B9qwUWnYAE5HRYonNDfMGn
	oPE/XMPVpyZLELL9xT7sYsJNQlJ1f79fx8hdjs29srnlO6D8Do6+4QUnESYHW7+3WYSk0w
	zDqQ0uJGOIEUuOkw4uyrckX/vW/E11E=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-477563e531cso414985e9.1
        for <linux-mm@kvack.org>; Thu, 11 Dec 2025 04:59:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765457974; x=1766062774; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1YPd4rabCA15+W0gc58X3ldTKNVJsgSl/m8TAJcDC9k=;
        b=saXjF0/TDc1malyYMJpvx694sgjcYUusOWtGjfabHNvKHTzfqgi7CLUTIp0StMlDkf
         B+vuiBhBokEqRzGeHiK+q6Z94iIXg2ATUxzEZOO3y2j0QM4w4modNwFBLG3b9s5kfjoc
         gsdaDN8YlaYNuGj/KV4iu45pf4vbS3m3/7XIUXZFRu/cKJri0tTfdUnJ52hXQdPimx53
         xFPedrPbcOALP1YfwtmDvmMUEDGl4VtlzxObigxRUuoSw4AVWPYKVXad4x+AgHB1JzDN
         KCZdERnS70/hTvsFjDfAME9lNkwulwZF0XwQHCjvTGG1pmYg32ENTyHBulPF0vdtEJcG
         JCrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765457974; x=1766062774;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1YPd4rabCA15+W0gc58X3ldTKNVJsgSl/m8TAJcDC9k=;
        b=Sx9dB1MGFlnIRmxxDXBdUSXT/wuzIGPCB1FrJYAhw+4+W5WjlKTAtd6wbAKMWxkJPz
         W/Hf67mWksn5NuWLW6cPjYNsxrI+r+1r3PnuTpPx94AvqGI8zCp5kWbgLQSuJI9j/Lzf
         +5PIknHDQvF0n+WAIXXlR4v0F4fQaZstvU74aD5ImpJzSb1D87zUCW0viBTpRgEpGAtE
         iRRofyKL08hQMiu9+uYiuQA8TwCyGzOG+od3nvtwL1dltUaiW6XuaaKyci8rf1R0L2b2
         dwAerP1KSuufXY+1ZSJA0Udl7al1Y19f3Ika1THCPA5yDyu6yvATBm+dQJvQih0HsF8e
         wYVA==
X-Gm-Message-State: AOJu0YweT63oRIh4h9H4VKdtn9PYQsD/m71EbaRldECdwavvLFhBLWEh
	lCI5Zh1F5O1YoQX5wGluOH6TQUxJfiHh9d68/V+F9jRez2GN7OHzgN1HIZ7m8LjmY37lzjNc2g6
	oWlHLynVtYVx+isWDSupvSt/i3PkzM/N6JsouoQOEVVW4om4AJ5dbuuIN5F0oMPh4RR5Axs+jH8
	eNl75Q3y/2VVniNf+7xy4owfwAj+lUOQ7JR1z70ZQnag==
X-Google-Smtp-Source: AGHT+IEutEw1d7HRrDvz7Uw5x03SFSXvQO6Sqwdti2F86uaAXoFjBNtSfbvmhvAiwBwLApQfmCLLxUs3FhConw==
X-Received: from wmbhi3.prod.google.com ([2002:a05:600c:5343:b0:477:c551:bdb9])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1389:b0:46e:4a13:e6c6 with SMTP id 5b1f17b1804b1-47a83843239mr56517695e9.19.1765457973952;
 Thu, 11 Dec 2025 04:59:33 -0800 (PST)
Date: Thu, 11 Dec 2025 12:59:24 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251211125928.3258905-1-smostafa@google.com>
Subject: [PATCH v4 0/4] iommu: Add IOMMU_DEBUG_PAGEALLOC sanitizer
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
X-Rspamd-Queue-Id: E71F240002
X-Rspamd-Server: rspam10
X-Stat-Signature: 7c3r1ma3f5ngr3msp5fzea3q7sx4owtx
X-HE-Tag: 1765457975-622189
X-HE-Meta: U2FsdGVkX1/zMNf5bEtHmF830j9wr7XzR+6GXHmEXv5PXYPYKljfhnxMp22blfThKkrMEPqFJKPwuoxKFbTamiYC2qPCJQtobSPWrNpo63arn6HrcoFaNv9auMjN4SQjrEATEe865dDTcUKf8Ppc/bqwQk4atlDiI0l6WU+kXiAO0Ysn8aQmdMl7uISEhLZ9s2BcPZDpdpsJsEX4sQP1Xmp5B5JSxHj1Ko+bD3uLxBMAPgbLJrQNzl5EbrJ8Qu7qDjS8qF65ESduZUgASw5EgEiK81s0GkKWf1E4D62XinjyjSRTZR1RXonBAVzZXpcCY6TPY77xHdAFCo04+adiKtTv9xws2UmYqE+X4Kv+RSnOjWtupFvmwuuZCoaIc7xb6hI8Jj3E3X9J8VBF2z+hr8nfuQWNGWFL6ImXgTeigd1np/P3DXd5d+jx4EMNigAUrcKeit0aR7Nsdnz41kf6bsleCezLwGTGOv72Q0UnHz40XtQUkOKCwVyl2iYH/xqQhEUUKqdP5EdQVSa8oE7c7THzKJL2sbJZV0YXJLpb7DNPZN0OSKT6q5fBauPBw4dhlfCCtQU/qAjndBteb3DIgAj3dtPFzSDSrw1JWlMTOseKQCxFmVPmevtx0ivYlNfDVLvBg6JURZuNCN5Jp/QpNOSZNKzBA47LjFounB4i3m7B3ZRHYXeKIYGJfiWuW1LsrUIS1j3TfL21QPZtYGNkOVLrKjN4wDEaoyxMnlzxn4j5G/YkvoGHwtisVECFJDFg8WhNdc7kRVw/Wzx3MwUnFQoj34WYEnWnAbjwiCk2jRPi/zzqFc73AWnTV/qxN3tKqCB4Xj2s4azBYX8vFXpjTv6b1VUJ3lQtbXxdCFTwBCclKQa9kNYof8YZR3loJTtRDnrbM57tg5FaOzJZab3fkPLF/3qjRbApuCK+3Fyr6pZUpzwilk/3TiUC3EePa/JgGEaKOaxH6KYdVjXfPDk
 xbwwbecV
 fdb6dW5ny/uNhN0ypQ3SNW+fejSl0Od+QZ2zEdz7gLbCwlf3nrwnB1RDYSH1U/oPV/CKRfMuI8l4oNhamLcGadBYQy4kul/jEm1g9XFQPl4WWFcK2ycqesFI2hvBK1QQVe9We/+ZcY8nB4ZeGU91fk+Bl3sMquhHWgny8Q06XxFA7We1Fhk8N5IStqNenwwwktNeXp528DHVeKaoEk8yA37JqDoZN8RqfzYEDK7J4lHl6a/WGGEywGfoOBFnA54bhAeBbQtAZZz9rpq6i1ecd0eQv26FNfeVXbSb6z5hJYbBqNjMuIR0erKQaQicxhFDpmaHrLYuPX/rH/J9C25eKhiNd3fsMX5N3d2Q/kVBEbvvfrG8rwud31/Oipl8r4OK415aTxyvXGRcakVCbv6Kv7FsPROfZ2H5ykJ2FlAdbZMqAEU/l71djZ1S5CZ1nyhoDipjLSC2QpiqEQP3R+5Tv0+m3gddY7FotJfmyS2Lq+7etBDxC1Oi3JsjBVq+Hp+p+NBtz2g0xi7wSEX4jIOl47Bplq1WSgUVQqS/QYIfnNcbPw0dQdUTc60DAZ8fVz92RT0pq93Bbr/OQrnFhLJcTZlxOxA9h+ag8jOy+An9TFKm+jZO2aAZIJitQItEPudRcwGg+
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
 drivers/iommu/iommu-debug-pagealloc.c         | 174 ++++++++++++++++++
 drivers/iommu/iommu-priv.h                    |  58 ++++++
 drivers/iommu/iommu.c                         |  11 +-
 include/linux/iommu-debug-pagealloc.h         |  32 ++++
 include/linux/mm.h                            |   5 +
 mm/page_ext.c                                 |   4 +
 9 files changed, 311 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/iommu-debug-pagealloc.c
 create mode 100644 include/linux/iommu-debug-pagealloc.h

--=20
2.52.0.223.gf5cc29aaa4-goog


