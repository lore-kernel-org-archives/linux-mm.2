Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D8C5D2168D
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 15:10:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53FCD6B00C2; Thu,  4 Dec 2025 10:10:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 517B56B00C8; Thu,  4 Dec 2025 10:10:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42D8E6B00C9; Thu,  4 Dec 2025 10:10:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 31C686B00C2
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 10:10:12 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F34A55701F
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:11 +0000 (UTC)
X-FDA: 84182124222.20.45C5852
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7F9894000B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 15:10:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LFf2a1gD;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764861009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=bmZIhVkJ08vTPyzjfalPJI5Nem6arF0hRCp6AB1TBpU=;
	b=Je2qZ/EBCZt9z9qHzmhEVS5lN8u3OxajQ2uANUlzj7dS2kQO7ylY9Oa249jMwBTQHLYi56
	snkxQNadFw3DBi7nqoz/TVNrOCR3Dvo3xwoxE1ATgPLHp/eC2c/an3GsCbR5hGrx66BJG+
	nj7Q9i9iKdm8MsSIc8BD5miizZ2DYYk=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=LFf2a1gD;
	spf=pass (imf04.hostedemail.com: domain of peterx@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=peterx@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764861009; a=rsa-sha256;
	cv=none;
	b=e8pBwlF+PcMoYjol0m6ElW0tVndU0tl636u5b/u05q5+a+DpxhUqhvXFTZU9dUhqCe7k8I
	mtnP423GHiEkKbCs5+1ttAjN1XV5SP+I328o/xBeCK6tDLoZyDDmbNqAysuTL+Vmm+aliH
	8Ex9X8tLxH9PcRoMB8Jn86Su9u5FQ4E=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764861008;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=bmZIhVkJ08vTPyzjfalPJI5Nem6arF0hRCp6AB1TBpU=;
	b=LFf2a1gD+PgriPbOhaFH2JWhcdhOakOed9mwxUGUVeWIsE2n9ES46kS4/gfYCsIF4tzLZq
	6b6dash2giL/TUg5dNZ4sG25xXiRZFZ8sIvqCSHWfiW7doEjzpCSqY3FhdBKJ/b9qEE/Ue
	f8prR4aR7UUwjeM1RrwyOLpbMk1/tQM=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-461-A3kXUjuLOiWRVFHmM_djlw-1; Thu, 04 Dec 2025 10:10:07 -0500
X-MC-Unique: A3kXUjuLOiWRVFHmM_djlw-1
X-Mimecast-MFC-AGG-ID: A3kXUjuLOiWRVFHmM_djlw_1764861007
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8b2e19c8558so192559585a.2
        for <linux-mm@kvack.org>; Thu, 04 Dec 2025 07:10:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764861007; x=1765465807;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bmZIhVkJ08vTPyzjfalPJI5Nem6arF0hRCp6AB1TBpU=;
        b=jHQ3vZZLCbotpz41zbbBJ/ug+aMqedGiwUT9Cy2RzUyQfe6ETCXswO/oLp1cChtJJT
         UiR9YGJtjM7dRVFkdqvogcskOfg2ClCWOxPA1xj8wjJgsF0laIfDtwGRZvaX8lXCBuqo
         VbrxYmtfzi/xLLYxMC3XnEyH/qCB+RZRfiUT5XGgSMvFywb8aOzQSwqVSTn0kF0JhwD4
         nHGMeV7E6SThkH66xx6/2gjBpa0yWsEMr/ez/BFpahtgZEQCWEpQR1T4z+ViOVnhWxbS
         Pltr1QfBaANy5NEFf2lZLqYHBAxUsGSD6HLdO3qOtJHMOFVhh4a6yFw9GxUwTOPufv2+
         nhQg==
X-Forwarded-Encrypted: i=1; AJvYcCVyL3DCrTvJ3nlNmgo2knpJ1/2UzbYRYqOYUHdGLA9T5RS9lmprsxptA4fwqzFZBj9t2UOu6gCl/w==@kvack.org
X-Gm-Message-State: AOJu0Yze3BMXjS0OFQVmq+8cfMol4M7WvMGOxxG3yc5kKrHhF1dyPILA
	uvsDkhXOuxVX34kzYQAa9YJJplHTCBkx76zJr3Fe5yCWLrrKGdpmTLsqdhoxDG/eAFDKexGKuFM
	l62OndHbrubTDovKqCe6ozRtETY9H/UG0Iy/bUgACtdcJ0PMJHdAQepQ9mqFJ
X-Gm-Gg: ASbGncsmwI2FsYTAanvfTNg4Y7LtBdcDO+C6Pj/+SIRvhYAI3jdT5uWZPbTL7UUkdrR
	DZR4rtJS3mQhafcXHQgLlzQnLcw+/Zp2HcFZ/SbI2LVcqwNZz3bkg3Qs3ul/o9nUg5YsZEuisIk
	t0M8yZIfwWf8X5s+SLW2TP1rTpc111zWPINg75xch+XO0ICH8PLMHDP3L+37okp/HQD0M3gJxzk
	8Da04u5Nxm9WRiJFugQR04STlRX4VvAHj5Jxx1WAnCX1Rpg0MqtOhFS86IGXG/aZDWSTwHMjCuW
	CxsOZbsf4oehOi08PmCREfv15+2PzYbEpBgAci6E9GVOkzEW2hPwblfTG8HjrtRy/M9AP1i68bY
	9
X-Received: by 2002:a05:620a:280d:b0:8b2:f29e:3b00 with SMTP id af79cd13be357-8b5e6a905e1mr808458385a.51.1764861006779;
        Thu, 04 Dec 2025 07:10:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEyH0V7BtmZhH2ckfMcjK9avGlDSwL+lIn0HZdyHGEVc1fLrFDrwIW691WvbiU7DsS62jiCgw==
X-Received: by 2002:a05:620a:280d:b0:8b2:f29e:3b00 with SMTP id af79cd13be357-8b5e6a905e1mr808450985a.51.1764861006226;
        Thu, 04 Dec 2025 07:10:06 -0800 (PST)
Received: from x1.com ([142.188.210.156])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b627a9fd23sm154263285a.46.2025.12.04.07.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 07:10:05 -0800 (PST)
From: Peter Xu <peterx@redhat.com>
To: kvm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Jason Gunthorpe <jgg@nvidia.com>,
	Nico Pache <npache@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Alex Mastro <amastro@fb.com>,
	David Hildenbrand <david@redhat.com>,
	Alex Williamson <alex@shazbot.org>,
	Zhi Wang <zhiw@nvidia.com>,
	David Laight <david.laight.linux@gmail.com>,
	Yi Liu <yi.l.liu@intel.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	peterx@redhat.com,
	Kevin Tian <kevin.tian@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH v2 0/4] mm/vfio: huge pfnmaps with !MAP_FIXED mappings
Date: Thu,  4 Dec 2025 10:09:59 -0500
Message-ID: <20251204151003.171039-1-peterx@redhat.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: uKCzSfrzCQQhlgSA2n9jMwb03WN88tdXo-1Pv7dYP9s_1764861007
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7F9894000B
X-Stat-Signature: p7o7b5n3xs9zb19wz4qd7wcasegq97wn
X-Rspam-User: 
X-HE-Tag: 1764861009-229273
X-HE-Meta: U2FsdGVkX1+eCe1K3p1b5VPcDnklt1VDfdMOiFTKdcVPPLSkg3C2Jj+wh8gOgwqK1Ug228deJRgZka21AX5fcjSz6yCxyPtHjO3qkn1+mClQG+LFrXpuQ6p2uZptwYk4rnYM8dD/0+BqhfK5tCr5l5CJpc8kOFw80faIuisEn1DDiBsq1WZ32Y/joclIJPTY9apzMEH20reVnpYVbzri8Aw728QiXXdZ6QCe6hpHVSR0z1nbVfkazHYKHEcZlLa/1tx1GvkoKrAD7ZosyipWZAugAGp0INxNqVAvsRIB9sb6Pl8rltIpbeUhtQnJNZ9Wp6Ar1bLlwjphNf5M23qozBgGVzI3NQvlCJSqhoNt7q15acfBWVsPZs+5IDwz/O8YU/HitG+hcNoyjBRaRfwIq9m3Wtf+RkkbIj5Q1HTLSBBaEjqmhDDVG+4krZ1rdB/5i0FrBH/ldkXN/tRIkJ08OUrgZ8Tj1aiFAX/yOuAEiSPuvO+Lk6+Zd9//CsGDgk0NwRpoCqHPvHqO05jJ+4RdyCWp8tig2Pw5bYN2P1HQE87rx6h3zqaV5iMZO6Cxgp8gOi/RJV+KWPf3/cC7fem6M8DcpuhlTcRMdB8rRhyr5jvVRDEhGfKfjege/a/aV+GBvfs3grsGhSsIhcXmDZJlPcLY0X4jCbbnJMxjReI+yfA88Ki5OlRx9wfl2KuKnze7Sn7sFo5yO+LF7O6v5zu9EbewbpjDeKngTsCuGbSBa+oI8J/CbOsA15GPVfThRNDEDd93Wx4m3AlghyZvzXIO644abZg5JNk6CkkeNY+aV1mQsj0lbR5JislrX7/8FjuifKzY4yZ0am18HHIY2sLLK8hdKrH0NaBQzZJUjn16uT+bihxDudECvd7+/czjZ+Ny9Tqeua5IipRNBUElwvsWCxERCs/XXY7PvneG7coAWIJ09h9V1ANDDTzte6klCYRD4BeHt4kJiNxO9yxQ4t3
 Ul50YQeC
 RO5grq4S8hXCoMam+81GPLQ4vqIMjUq1UiY4TDpkgtNdO2KwMXiVi0zj0nUQajkYtb+j0KwmGSw2LK7lBxHvrRnM19R7X4GtyA8LSCv73Gr3RvvZ2UzAenjEIL+mN97KSu74JBE/qG8ACZnK06RHZrj2tJeogTb3Xkw5X0wPPv6cQ6OuFoyo6gZ4O5p3h8zzZKzXDPis1UQkPyUvdr+uekr3mmRdpeX2D3CRv4sXo1mzNNFa1364Zc7n8CSOOj+EgkSpMbUAS/7IphIHhQEJMydrjwuJXHipxJqtz++SRCXri2SNdeEn7HNI0ptju47gjMZuakq+x8U+1BlcjFB47ivQ0Uwq0oXt4Gv72J1UsNBpS5AcwEH+XRyYH+dwtC2ob0d6gOZWiPAJpSb3mJ6t5eh50vy0QZ5f5noweANoyJz5N4tzsd5iSGorQ6kWxsVxpQ/qhiwmasTpNoLgd+seB/LFJBj5y0jOW80RWkZDGSARmUM6TW5O/fnSbfN5lTULJX+trRCACT60qE8x3GBmFXyu94C9ZaomPODSFW+MTQa3+n5TtRg3ZwpA37k2NuCwN6BnLDxiNKsgmnP1BXeqgxggO52+bKuPTQwPXi1ByiofOUiIXIaIDSG6iHFMOD9xOGjeX5SM4eLVB2t99c3g//QQhaAqKa28oIarGr6K3RO5s8pdJHx0p6BdyQIF4Xqt0Uk8A71IP7gJpEU5HGFGeW8IRnrOLPg2WoHg/uXIllnjT4Y8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series is based on v6.18.  It allows mmap(!MAP_FIXED) to work with
huge pfnmaps with best effort.  Meanwhile, it enables it for vfio-pci as
the first user.

v1: https://lore.kernel.org/r/20250613134111.469884-1-peterx@redhat.com

A changelog may not apply because all the patches were rewrote based on a
new interface this v2 introduced.  Hence omitted.

In this version, a new file operation, get_mapping_order(), is introduced
(based on discussion with Jason on v1) to minimize the code needed for
drivers to implement this.  It also helps avoid exporting any mm functions.
One can refer to the discussion in v1 for more information.

Currently, get_mapping_order() API is define as:

  int (*get_mapping_order)(struct file *file, unsigned long pgoff, size_t len);

The first argument is the file pointer, the 2nd+3rd are the pgoff+len
specified from a mmap() request.  The driver can use this interface to
opt-in providing mapping order hints to core mm on VA allocations for the
range of the file specified.  I kept the interface as simple for now, so
that core mm will always do the alignment with pgoff assuming that would
always work.  The driver can only report the order from pgoff+len, which
will be used to do the alignment.

Before this series, an userapp in most cases need to be modified to benefit
from huge mappings to provide huge size aligned VA using MAP_FIXED.  After
this series, the userapp can benefit from huge pfnmap automatically after
the kernel upgrades, with no userspace modifications.

It's still best-effort, because the auto-alignment will require a larger VA
range to be allocated via the per-arch allocator, hence if the huge-mapping
aligned VA cannot be allocated then it'll still fallback to small mappings
like before.  However that's from theory POV: in reality I don't yet know
when it'll fail especially when on a 64bits system.

So far, only vfio-pci is supported.  But the logic should be applicable to
all the drivers that support or will support huge pfnmaps.  I've copied
some more people in this version too from hardware perspective.

For testings:

- checkpatch.pl
- cross build harness
- unit test that I got from Alex [1], checking mmap() alignments on a QEMU
  instance with an 128MB bar.

Checking the alignments look all sane with mmap(!MAP_FIXED), and huge
mappings properly installed.  I didn't observe anything wrong.

I currently lack larger bars to test PUD sizes.  Please kindly report if
one can run this with 1G+ bars and hit issues.

Alex Mastro: thanks for the testing offered in v1, but since this series
was rewritten, a re-test will be needed.  I hence didn't collect the T-b.

Comments welcomed, thanks.

[1] https://github.com/awilliam/tests/blob/vfio-pci-device-map-alignment/vfio-pci-device-map-alignment.c

Peter Xu (4):
  mm/thp: Allow thp_get_unmapped_area_vmflags() to take alignment
  mm: Add file_operations.get_mapping_order()
  vfio: Introduce vfio_device_ops.get_mapping_order hook
  vfio-pci: Best-effort huge pfnmaps with !MAP_FIXED mappings

 Documentation/filesystems/vfs.rst |  4 +++
 drivers/vfio/pci/vfio_pci.c       |  1 +
 drivers/vfio/pci/vfio_pci_core.c  | 49 ++++++++++++++++++++++++++
 drivers/vfio/vfio_main.c          | 14 ++++++++
 include/linux/fs.h                |  1 +
 include/linux/huge_mm.h           |  5 +--
 include/linux/vfio.h              |  5 +++
 include/linux/vfio_pci_core.h     |  2 ++
 mm/huge_memory.c                  |  7 ++--
 mm/mmap.c                         | 58 +++++++++++++++++++++++++++----
 10 files changed, 135 insertions(+), 11 deletions(-)

-- 
2.50.1


