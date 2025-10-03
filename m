Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 172A6CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 17:32:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53C188E0006; Fri,  3 Oct 2025 13:32:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBC18E0005; Fri,  3 Oct 2025 13:32:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3DB198E0006; Fri,  3 Oct 2025 13:32:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 264BC8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:32:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AF23C1A08CA
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:48 +0000 (UTC)
X-FDA: 83957498016.11.29D8EB6
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 151568001A
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 17:32:46 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="VHkl/Mxy";
	spf=pass (imf02.hostedemail.com: domain of 3vQjgaAgKCJwOIKOP6B6CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--smostafa.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3vQjgaAgKCJwOIKOP6B6CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759512767;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=9rtqteAJeUmRGsxg/Z0dCTAtvo7UMTgyQH1Vgz2I+fM=;
	b=hSiaqV1fXm09Gr18RsA7qaoJFe0kwf2FWo9Bc6LN2S8vDe6EE7XfaFkyLJTjiXzwk3ityK
	Y5YNuHWWIQRCSpwopai3Hyju0+XXmjkEb9Hpy5Vu7NI9tAE/94BsO/mxMGRkz8lGyWVYey
	5pdfLJ4/ImLCXUfgjHY8fzvXAcd6IVg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="VHkl/Mxy";
	spf=pass (imf02.hostedemail.com: domain of 3vQjgaAgKCJwOIKOP6B6CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--smostafa.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3vQjgaAgKCJwOIKOP6B6CKKCHA.8KIHEJQT-IIGR68G.KNC@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759512767; a=rsa-sha256;
	cv=none;
	b=UBT1tLniIuxkQprlGZyK+7UyzEXKufW5uRB3lzvhv7HGXQIy5wf83N1DzwyIRMP71xAemb
	sRwDGjmnbcc2upqhEvWX9UNkuLwd2kkkL3DtmyvwEuz2yAldpeHzfAaM8LrUavBSc49Hu/
	vjwYn+xY379/EBaa0OgB7CN+/mks9Js=
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-634cdb5d528so3753671a12.1
        for <linux-mm@kvack.org>; Fri, 03 Oct 2025 10:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759512765; x=1760117565; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9rtqteAJeUmRGsxg/Z0dCTAtvo7UMTgyQH1Vgz2I+fM=;
        b=VHkl/MxyhdBMtDjPCUHT/h5rysJ22gws2dwNpfpWliSwhF2MRE8YipLGuMjW0M9oNb
         fsCBB9Wa91JUf+V6suLBlt/TGFck9awSitSD8FhkIFsn/m5YbaUP9sK6eHdGHvz0s26a
         WY0/sjYe2gJqd+8OzK41/0o5pa+XQ5zjnBdvfJaLy3q/pjycGA/e664SEqRu8AfloRqJ
         dC7BbRTjhWNuazA9m01aSLkET6uc+STQj8YwVN/UNh2uXP5lsleT/FywYVvomHxEK6ZS
         e2JmAsNhc/VejAgsWryWPTUGfcQ8cYTox1XCAUSpbTOgdtWQTpXpjzT9hsvBQFRmuZqt
         nQWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759512765; x=1760117565;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9rtqteAJeUmRGsxg/Z0dCTAtvo7UMTgyQH1Vgz2I+fM=;
        b=bn4j8x41nB8GKhJnqPZogBUpE2+8m7/HpgkwHohnoAl/lufNyvf9+V+9mVP4rIrbZ8
         7lg2ixESbdWPGaW+hmBPNm9SWP/Zf/Oydzoy6S3sD/Rs6A5hkM6+tHoYIcUR+JlgZcMy
         we5bVewMdY+OPqErXXl0z9I7aF8P48mr9IgzW8bqmZN+enfIR8mbpDnT/iU0mytxZ68D
         amVJz19hIyLeiy0hb2laFOJjlqc1xnHfmez8OqQpL/x9A0BRzHoia65JKE7xVMulzyr5
         FgYPqJHENQNJlc0C0ZH8LQLXGlwR6jwubj3e7M40kUoz42q5LOFu0ZM/MbueFTBRA3us
         JYyw==
X-Gm-Message-State: AOJu0YyT9OXrzu0if6wQWqHXEWoDwPDVDRbSY/WiD/TYw0DIJuHPaSY1
	YiCMRYBgy3E7GgikdMHvXkTFnPJgfTYEk+5rQJHDGeElbG4dscySysraWzTGZ5Hc3W16P0Q2Vn2
	i5B9UkYCWDrNFnc0z95xtdr9OB/EhVC9oueDbOMAwk1HuabwOtnhC4iiF7FF+Ti3iM13VelxXtg
	dB8yfXosETsrVy+39vd3Dbk2IjqfLxnQnFyY2m9LSxnw==
X-Google-Smtp-Source: AGHT+IGlpvvYRqRysNX3SlhoP9uszCyEAfse5Ll61mfhygdHXMca2IgjMh5S/svFSAScgQFHPBRqwfLja/G1hQ==
X-Received: from edwr10.prod.google.com ([2002:a05:6402:34a:b0:62f:9fc4:ce8f])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:184b:b0:634:a23e:df26 with SMTP id 4fb4d7f45d1cf-638fcb7c9d0mr3359707a12.6.1759512765118;
 Fri, 03 Oct 2025 10:32:45 -0700 (PDT)
Date: Fri,  3 Oct 2025 17:32:25 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.51.0.618.g983fd99d29-goog
Message-ID: <20251003173229.1533640-1-smostafa@google.com>
Subject: [RFC PATCH 0/4] iommu: Add IOMMU_DEBUG_PAGEALLOC sanitizer
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
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 151568001A
X-Stat-Signature: xbpytsdw6aaufpqgsdoxdwuzoa4d34jt
X-HE-Tag: 1759512766-749909
X-HE-Meta: U2FsdGVkX1/AKUqPVYGpzkFWpha6TXwWMGiEnHeCkUAHRxV0g4WaJpM3SrniAGoPr5k0NjfaO7QgbDXWxDgbI/7799Av73fLLws30g0yv35lRx7E2tbk+99cBG8eiF6qzkLIzfPKMwrSxgtuXWt5YYaDDp0NXc2tKOFSBfaaHoTaF6zwji8DtmpnmjD21e4ZWVMnZ9uC7fYtTb/Lm6c0xvM51E4LhspfDRRysByf0dEriqvexPBfsig6gfXiUMpJsmEeeA6hX1WQvIGurvjjGUwGyTyV+0nG/Abijv23+PY0n50VQVM2R4BMbTCzwJmtYbgt3w+/jaYtk3UdofivDAhDh0bLesa6CQnATlwd6AjPppz8UY1bebDpwkfmhrX4ZwqSc0gAmqax59Th1RZqup9FJ9M0dupIhG3PQo1b/7HAzH80x8dBUjbR0fFV8i3Mg2INnuSY6/waXkNiBnLnTtOg6wwj0lQ2tnpzAbYyFb798HRT/sH+gS/gd88MjJwCsZ4RsqdceDlHO7ueXBr+Xx0chYz03G6nqi18MWdui/VbmJQfmgQY1mVQ4OWa0KOVIzg5uwNQh4iLB+c9zkgTTyWWo/pa/+KoXfY+WFUqO/8922gxdYavC9KsVVzLhJ0r6+8aP/aFdK+mBpo1u47AgUxDqk1Vlu+4vFTO6AHLLBXYAUhA22CRH98OjfA8dZytlIHpyuRjE+zaq0swGjsFZsyG1qoUJXt4ILokvdhHkRUY1o7cwpFsr/pmJHddixutWdbDNdhEImUn9j7uKF95n9FvLytW+JQJPQrxr4uJ3ySapo426xbWl1uaFQ2t2xHISVHRkz2C622VIUhVsh5WJwKIixY+4MriZjZo/9k1dENEaZbHyKPcM/lIfy8jQKoOqYUmNbCb0o87r++hFSPCEJT0XiUKsUdm9oG28kiMV/u0hz+a2X+BsaJnwj28tfee9LkoKVq8ExCcTgjEhAA
 j7Lvfbyy
 ZzYbbrM9HX8D9orVEy5zjA3OGZL0SsqGfSgnpnRW3CFJWR46s1SQEIrsiY1d4DVy70pEWEKiFbrRkZzFztcx5PnPfo/BqnTAM4nMlJyb3OPXADLmPpxT9163s4LXSktUSg5V5E3iQGbbPEYvej27otMK9pQNke8UxmzT/wQEjSjfHvN/UCOQA40KAoCN/Q9fDSpsVXsbQUNK2GZGOtYh250U16GJA3PHGZlS0NsqPHXmsBXUncQHEAque9iSNQT1vbWWMNk4u1Cgv+anrS3x8Fe4W05vJMd+7b7OQK/e6sQtLJLepR47k85t8yaQ8Orwgg0pPJITOeuF+UtKW1wkGSF/TIl0wuRuZGi31gqRducexcuwA/s5lfq9Z97Q8VsMGAeiMi660CM5xwuJEvI1TpKfMwG8DEevXO9mt7ajT5I5IHOq3fw7PHLEYvQ==
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
./dma_map_bechmark -t $threads -g $nr_pages

CONFIG refers to "CONFIG_IOMMU_DEBUG_PAGEALLOC"
cmdline refer to "iommu.debug_pagealloc"
Numbers are (map latency)/(unmap latency), lower is better.

			CONFIG=3Dn    CONFIG=3Dy    CONFIG=3Dy
			            cmdline=3D0   cmdline=3D1
4K - 1 thread		0.1/0.6     0.1/0.6     0.1/0.7
4K - 4 threads		0.1/1.0     0.1/1.1     0.1/1.1
1M - 1 thread		0.8/21.2    0.8/21.2    5.6/42.5
1M - 4 threads		1.1/46.3    1.1/46.1    5.9/45.5

Thanks,
Mostafa

Mostafa Saleh (4):
  drivers/iommu: Add page_ext for IOMMU_DEBUG_PAGEALLOC
  drivers/iommu: Add calls for iommu debug
  drivers/iommu-debug: Track IOMMU pages
  drivers/iommu-debug: Check state of mapped/unmapped kernel memory

 .../admin-guide/kernel-parameters.txt         |   6 +
 drivers/iommu/Kconfig                         |  14 ++
 drivers/iommu/Makefile                        |   1 +
 drivers/iommu/iommu-debug.c                   | 160 ++++++++++++++++++
 drivers/iommu/iommu.c                         |  21 ++-
 include/linux/iommu-debug.h                   |  24 +++
 include/linux/mm.h                            |   7 +
 mm/page_ext.c                                 |   4 +
 8 files changed, 235 insertions(+), 2 deletions(-)
 create mode 100644 drivers/iommu/iommu-debug.c
 create mode 100644 include/linux/iommu-debug.h

--=20
2.51.0.618.g983fd99d29-goog


