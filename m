Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56EA1CE9D6F
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 16:22:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C6C66B0005; Tue,  6 Jan 2026 11:22:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79DD66B008A; Tue,  6 Jan 2026 11:22:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6AA496B0093; Tue,  6 Jan 2026 11:22:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 55D396B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 11:22:12 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DDD1F160463
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:11 +0000 (UTC)
X-FDA: 84302056062.23.1742EDA
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id 487971C0007
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 16:22:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PXL3FcI4;
	spf=pass (imf20.hostedemail.com: domain of 3sDZdaQgKCOMXRTXYFKFLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3sDZdaQgKCOMXRTXYFKFLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767716530;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=zKAqbwUbcchTwKTjD1t6ChHOkXjBfpnVs5Rhwmy3fpU=;
	b=t3cpL/dzNTT8NGODs+5EptrIyV8m1cLKI4fn6NlHHVZei2RDavIbY+mwltAm4j8MBs46Xa
	VkYGJbTJq/5YTHXTs1aXzr4IUTRxr0addidbdowo7aZifb2PjlS1mAS1rH0wrsJKz5+d4o
	+8zIKlM226dsFEVe9vFHuqOtkFMmll8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767716530; a=rsa-sha256;
	cv=none;
	b=WxvGrcXdY4CnJSt3B+gPdXOsNiigco9Mkavpxx/PjgIaUPJn8jpnEs84LlzWfehvhRhcBS
	7+LOsqpTeq49WZ5EHximcqMnHsj2a6BQXJFfzvrqxj0jXVKD8YHY/YClTeV5ojkABM/C6O
	UpmS9XI0hesUzRXOLaz0RspmWM1qzM0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PXL3FcI4;
	spf=pass (imf20.hostedemail.com: domain of 3sDZdaQgKCOMXRTXYFKFLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--smostafa.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3sDZdaQgKCOMXRTXYFKFLTTLQJ.HTRQNSZc-RRPaFHP.TWL@flex--smostafa.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43102ac1da8so772920f8f.2
        for <linux-mm@kvack.org>; Tue, 06 Jan 2026 08:22:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767716528; x=1768321328; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zKAqbwUbcchTwKTjD1t6ChHOkXjBfpnVs5Rhwmy3fpU=;
        b=PXL3FcI4lUmdeE5hb7qrRTpJvNvRtsfjeGsfMirYs+Zjxrn4rZsMRE4pyddjAZJo/i
         VGXoM7h7p5IcaIA4KIJeSo9BLVehrTubwGuDQqb6nXucdxTFElAO2Md+zINW+yskfZzS
         XGOWz8VWxcQBAUyeOUteumPIj5rUSFEKNXUHONIUojVcor0CotxwxKgz9cgfhEu6aasX
         41OarpEMIAz+lTHwBfsjgjY5PGljkK2QPVZO+cbkTMEFB8ViTIaOXVrE1E7nnjCZN+7T
         O2wmeFwhKVed97a25wQM2CABq/49jQJX0lty2eZRQvThsX+pO+hU+dW9DtaQItwyfeS3
         OLDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767716528; x=1768321328;
        h=content-transfer-encoding:cc:to:from:subject:message-id
         :mime-version:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zKAqbwUbcchTwKTjD1t6ChHOkXjBfpnVs5Rhwmy3fpU=;
        b=ntsZpCsxE3M9i1pXOplsc7vUGkKJtHNTdMrd2Ay2f45owWZ/NOjhxQRSTrjLaY6uX5
         /2LdAo6Khy07KgbEUD3uuU0mDSkyJ3xVdYEmWX894eXuPNiRsYEtjOyi/Cr0lrgseN7k
         ktUi/MEqv9UxUOaPVoRls/wceJFmT+8ShpB4nXz2j8jL/Rqc3Lyfp15BEXeV0wHCGnLO
         vB3v5ZXaoSZ8SajaqOT4amJ97FEwh3Uql4LCnNtqIOMsgcEpefKpDSJeFjnibePuGGgc
         atyTedTlXit120aJqLXM+XwOYo3HlklwOyMmRt6/1Eazc1yICqnMdn6tlHFttlrUFQEu
         wuOw==
X-Gm-Message-State: AOJu0YxfkcQLf/26LPe0MqcKEObsE216ofq81+OQPd5bfyhEbcCDLXwl
	XBKDeoxjMNKYqpUVgRY8mXG09+yD4UyxJvKFeXiGNpFcEg4oBZ/7Ey9a5reyG1Ikr+1my87NznF
	UKdUls1u4S99U754j03sagPPxkhNSppaZCzN9u3LKKOfAaaBnm+Fckc/vvRxpu/uhr8YPQnHoUO
	pjOVAGybd2oMjJ/l9FVClNCJO10ESPZp8EhxolwYsuhg==
X-Google-Smtp-Source: AGHT+IE/qy1LfP4KHNR4hLsIgyEGcvqJy/Wln0GOFpcBQE2xmH7wf/+hwlojpH5iVq4CKKX4O8sUT1CS1VuLog==
X-Received: from wrbck18.prod.google.com ([2002:a5d:5e92:0:b0:431:334:a1ce])
 (user=smostafa job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6000:2504:b0:432:5bf9:cf26 with SMTP id ffacd0b85a97d-432bc9cbe81mr4724605f8f.13.1767716528301;
 Tue, 06 Jan 2026 08:22:08 -0800 (PST)
Date: Tue,  6 Jan 2026 16:21:56 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.351.gbe84eed79e-goog
Message-ID: <20260106162200.2223655-1-smostafa@google.com>
Subject: [PATCH v5 0/4] iommu: Add IOMMU_DEBUG_PAGEALLOC sanitizer
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
X-Stat-Signature: wjsi5imkdxisyq85oijsm7c45dgfs6ce
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 487971C0007
X-Rspam-User: 
X-HE-Tag: 1767716530-816357
X-HE-Meta: U2FsdGVkX192929M3HHK0o2lF7QalLTh+qd0WPLHlZA6M1n+ox9Lp7w0cHo04etUE1kVNgznN7ZZHRyeNazt78Vm+IXVz6DnjccYX+wWJHVk19c2L/36kW9eLyV3997sojo2JsCZsfKgNprsA+M1B4E9RlWQTitflVBvIXliwat46GYALJ1TJ42kMVIbZ89h33H8UM5pc6cT7ZidHS97xS/BAFFbdzUQZ37JbUYUpXjXMyYB11klI8uMN0EpKpl0IvF6VjeOoCvuwr7gvDq4fNyy5Yg2VWraSSmgtVg9Clik8wLtpRXBWGhs4DTxM2aaYta13LhsvxCwA4fXiw9OE+oPg1AJw5sLhsfRuQOiw+oyj/gPi5PB8g69WMxf6Yb5TOE9a4Eqr0ilc4teWw/WNPDtI1TXDq22j26RnrdyA9vIU7TVjnlXEVCKOyPiUx6fy1EeLoFRSX8t/9sR9Mfxn4t4H/d8NDnE6gnURIcaO71toqZK5sjmIVnb5b4sspZQbSPHXj638nqsyf2Z2eSSAi/f05cPSfNgMJaVngMbmO3YHnlEykLrCm/QcpsR3/kIfO1Tk+RAEw37/088t2g5T840D3OOZZUmBBCTcmh3+D3w6vFlSMJodB5oHrqNXMEXs3X5rh/vksIaWygtvIYtGbbQVtJl8lL7f7pmVFnK2MVm51yhRmGV2EsqGJGGQ2USGb9i+vnByt+19pHGEFpvT3rTLFas4LTZgxamTeHdz8zVd0RJ0P44mFxnAEtNyASq9OagFxw3hDK88pCc+64M9zf5YFPvir6FoA9WeN051jWwPtuLDk4CWAHAqg3kz2jvea6P9s02k+h1Y5dtPRablCRDRw7+p8OgEFwavzI+WUz0JofFcmfx6JnEosiR3w3UADu3vaqd4H7MJGEP+a/4aiWqmZ8/U39vJPywxMG5c42fswmjCgpvBbljnGP3bvvym5N2E+O/q17z0Hd77Ft
 DOTLOnYj
 1vNP6bdDeRaYHOpS51n6m/63Fc+lX0PYsNHaboYYBW4rsqqud4XFekqNcqkA6CCb/E1slhZfKzjX7T0veoDZMK42av2g7+Ys0EOHMkYSiSEJDPQbCl8SHzWoGMCOQb0sz56Vb9wmozCNnoER2ViEOBz9VWC4N7Nq+IGerenSN7YAo4yLtoMUiL4DA3AMRoV4PfLy4b1FILC9/86qsLiHAYAGauI1U+Z59dtNmqoVdxgET+NuTqbqBiVhGogv7FsipdmCA/8gAkrf6LoIIUA6BDWOntosvw2rMReQVDhbmmrU8sE+U5olS3xwcQbuTMJ3eXw2Q
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
2.52.0.351.gbe84eed79e-goog


