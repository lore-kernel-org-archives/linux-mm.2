Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69268606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 17:00:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda.com header.i=@toxicpanda.com header.a=rsa-sha256 header.s=google header.b=gePbCeu3
Received: by kanga.kvack.org (Postfix)
	id 72EC16B05B6; Wed, 18 Nov 2026 12:00:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 706006B05B7; Wed, 18 Nov 2026 12:00:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F5D06B05B8; Wed, 18 Nov 2026 12:00:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 250246B05B6
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 12:00:51 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0AAFA0836
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:50 +0000 (UTC)
X-FDA: 85448854260.02.F068458
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 76C9720003
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 17:00:48 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=gePbCeu3;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795021248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NKLRKh+hm+qamC/da7jrB7+aC8eL2HQcw46yudcEhD4=;
	b=l/dFDh/SjqvJ+dCQgoIS9RmiyXTSGHxYhpG7Q6/1/5SepvjVsMuKC/0EhWHfn3AINM+XOJ
	v0ACM+O4eA5waaxBwRCx5KqoHgqtg0mVdUGL2kcHltM4YmOry2QSQJBNE8o50jzc/4XRxR
	hYukq0ZUh64WOm2YcdLqIE7L1nLhxag=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=toxicpanda.com header.s=google header.b=gePbCeu3;
	dmarc=none;
	spf=pass (imf13.hostedemail.com: domain of josef@toxicpanda.com designates 209.85.219.46 as permitted sender) smtp.mailfrom=josef@toxicpanda.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795021248;
	b=TShbziQ1dil/gumdbAO5Ru5dGHZnYu9I2eeNbfC/O6CvfGhVMV+LkZAHbDdUNTrg7ya76U
	V7hOLkxrJgYnOb9Wzx0pBvuq2lHBYXI/wA+2cmihVDOj3h34QCMGMZnrhCmJ0zH0Qffmfh
	7nkvjT4XbXQAR/SN5SJATry3bw4iXrY=
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-92123588d53so216936d6.1
        for <linux-mm@kvack.org>; Wed, 18 Nov 2026 09:00:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda.com; s=google; t=1795021247; x=1795626047; darn=kvack.org;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NKLRKh+hm+qamC/da7jrB7+aC8eL2HQcw46yudcEhD4=;
        b=gePbCeu3gtCX5x1V8pTB5mc7zqUIFycgmKDl9F/PcHVuuvDK1l02YJUE6PyjhjeHfg
         Wbz0Rqw2FDsRZzKD+xWM7oxaOL44wQCplnHkRsrYNd0FPF8N9O66M0GGbjkNv5mFJ42w
         aREmJnsdt6mT7eVe1rqW6yb7mH4e1SIFtMpFcVPlpvI1uvG/8qT7CP2Z5Z8rS8Dj1SKp
         /Q9JPtHyUGfaH4dF604SexiVgekq5sfujgkwv9det/8BVnD/cqvhfYMzwiIQxdiIsyTj
         mWddR8mD+8OgvoqGV92xWhX0RA2H6Dsqdi7YbwOxMT7igd0hdg4V6U7AzNEX5JRy6zSc
         0KTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795021247; x=1795626047;
        h=cc:to:content-transfer-encoding:content-type:mime-version
         :message-id:date:subject:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=NKLRKh+hm+qamC/da7jrB7+aC8eL2HQcw46yudcEhD4=;
        b=APGDyMQjcN+TGKOKoFQXCv5JEf9SChxeGBbI72a9fL0Xb8HMSqAMulPMrC7020SFse
         lVpCQOnbAOjin+KyTQwTkamrRZPIY8lrV4Yjs0MJDNe0GupCsxSvibwaGZCWFGM56d2c
         5yemBnxHs5DuaNJoULpud2v+WSd/dHsrAg3j3IYzuR7e7ith4pGyoXcQ4DfnP1nriC0h
         pSjb9BqAuX8fb0IHghoK0zxD6oTI36MqnR8V5QD2zqgXCIXtl9uTnAR7rmhKRx92i6YF
         es7eak6xEZGInVu6YHvyWKCYlytZhKP0bvEMDWDAR3d1zcKZF6IJO555aX8cPDL4I5k3
         CY4Q==
X-Forwarded-Encrypted: i=1; AL+hErFnWi3kG+rJL7+C8igGwWxqzxmdo7U6/cN1SXNQf+awfG22XTTb+fFpxFF3l1GVtfHlvW+me2OL0Q==@kvack.org
X-Gm-Message-State: APuU4Z+ZSo/pZFYkUjtI14/E3QR2vn12QKISjNtLbOkzEsTCwFS56TK4
	LboI4OIqoDLEjkDnYj1/8G9iqL+/ZcwTULrS1NqLopXpYJwIkS7bnIcBmHYQ5ak3Ee0=
X-Gm-Gg: AZFdTZfDUPMxcHZ+5KUgGYgWONLX2LnCdlLhId/HdLH3EBhtEgKAtZ9ED7ixIs3icmT
	pzD81dl9DLSKClh8Mo8koE1NZs8OYy1LwkCjoEFCZZWUEi08py3erNnbETJvuglHB/1jxTO1Cdk
	xeHrnD/gdIvDSmAHunnUYC5QXX/DSfLhk8+lLPj6UcRpUK42qgHRNVdSER02ciiDBjMeOFrmdar
	Urk64nb+0WVVpP2b1fSrQAft+Hums8ogxbmOhZQE26kX1CuRI2cSTywp1moiO6cZ1r+azcQCpvk
	+SPa4pAFqn7kGkKVPxByHdWH40GfoYqfhX8PGuvenm9ikB5CfaRnuN8zcpKe8m4/tDsq+aK7sKn
	dWgJgUwTnXR1J+tTOfhiBXwoClVl0Y6jYkfv8ZXPs0R8+G5i1Q1f/kTEy7Busgt73S9dyQcAvng
	puvRi6YFidaSomeZwBfCzgnOhTw3SABVlOU5cw6CCkVmyhnS6A3Aqi4ePY3eteDNuEM2EkNyeWg
	RP92qNRVtgcpE0tT7DERH6PRoo/2ZeDJVnXCHN0+HctZGt3AcC5Q+aj56FKP/BdWMv8TwEGC8Jj
	rHTT1nmuQA4smMm6T6sPMzugHUJyKDJbInpwb0eExwaUCg==
X-Received: by 2002:a05:6214:400d:b0:90c:c1eb:ae42 with SMTP id 6a1803df08f44-9212428daf5mr1766786d6.13.1795021246975;
        Wed, 18 Nov 2026 09:00:46 -0800 (PST)
Received: from toxicpanda.com ([153.61.196.241])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92114d42d39sm26450416d6.21.2026.11.18.09.00.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2026 09:00:46 -0800 (PST)
From: Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH RFC 0/7] mm: let vm_ops->open() fail for hugetlb
Date: Wed, 18 Nov 2026 17:00:32 +0000
Message-Id: <20261118-b4-vma-open-fail-v1-0-c8b0209f2700@toxicpanda.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIALHZ/WoC/1WMQQrCMBBFr1Jm7WCSNgpuhR7ArbjIxKkd0bQkW
 oTSu5vUlcv3+P/NkDgKJzhUM0SeJMkQMuhNBb534cYo18xglNlprfdIDU5Ph8PIATsnD/R1ray
 xyrPVkG9j5E4+a/IMp/YIl59Mb7qzf5VYmZFLjBRd8H1R1GxX89eGZfkCNstJiaEAAAA=
X-Change-ID: 20261117-b4-vma-open-fail-c3305250ce51
To: Andrew Morton <akpm@linux-foundation.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Muchun Song <muchun.song@linux.dev>, 
 Oscar Salvador <osalvador@suse.de>, linux-mm@kvack.org, 
 Josef Bacik <josef@toxicpanda.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openssh-sha256; t=1795021242; l=5367;
 i=josef@toxicpanda.com; h=from:subject:message-id;
 bh=v1KZWLOUNoARfpYhttJapAs2Wl5ZuBYHqkv2SsdG9RA=;
 b=U1NIU0lHAAAAAQAAADMAAAALc3NoLWVkMjU1MTkAAAAgUBr36M/n0nWN0DNbnxwzIiCZez6MG
 JiruuNaSCI/zXsAAAAGcGF0YXR0AAAAAAAAAAZzaGE1MTIAAABTAAAAC3NzaC1lZDI1NTE5AAAA
 QPVlZfMduxz45exxaXcf/d0KRt31Lm03GSqyZBVI2GdDsPbWoLOcZR80REDJzz+irl7ioYtTftS
 aOBoxxWLr6Ag=
X-Developer-Key: i=josef@toxicpanda.com; a=openssh;
 fpr=SHA256:C8kOX2QUJCMqnCX+KEeoqRAjLo9L+ELOSH2NSAJHqGA
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 76C9720003
X-Stat-Signature: xadgjn4w7w6zzhcqjkejhmaeb161czxn
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,TRACKER_ID,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795021248-466984
X-HE-Meta: U2FsdGVkX1/HF+WPHBx6Kk5Ns9z/h+tr+Mp6FvpvkrRA2R6fTPRBF+EolXXzcAJr4CZ2wUijZtCJufl2zf4V0cV+D3nBz0TFMmJaX4ZbJnfp/aEC0qPrK+4B9+GBpZwf/Nm+sTmnOLxjVqUDvP8P9ISuSAiPwuFPeOEEaqQIbcbWt5NeTQ+tCycmdOJveBoagAMc3XeEtVMWoQCWptd+9sa7eMTL5NKztpnJvSJHP4V+vhkSHAMIqaup0jCePjaHf6rw58v0plNm/fIFgYbokbHZenh8VZDjjRLPv9WsKBFCYAzOHhlKzl+ieUSvRs0BkuoLMkcO315FflWiI8sBtI30M3wVCHDP/DzRlCTT4+qE4ZvN6sJvisqDc/tQL0IB9+gwTNbn1vEFhnxsVQON7iNAA1QjL7opSCQFBhJ9m7paOFwMouKP3+iQCc8nT/iC2RYZs+eR4E8vvH5z9A5GbRskm3EqLbidj+C5aSSZq/sqxUSf+6pS/skOwF+UwxAzSquxhi/+lHkpjOtDXtL5cXF5fb2WILgh+ZzSFOYuaOJXu5b1OKrxOHZ8SlH1hPebht8p2+ny1MyjjeRdZYGVQfUWI8NkxWqAKkb/QiEWNUmch6C3Uyj81EY1DCOxmtbrepXG2belJjq/uYF0Ej/SPNRT5xUbp7t4+BOq9mUIt38sbrl6WgVMKAVcyJN0eFhjIGWs/H+aG4vdwBHf2MTEB2eNifSJjvg9x0/duK8Cs+ZBzPFaDWaxy+fVKyCuqoWUcv48LItByDh95Sh87RwrRDdLdmSiwO82gqg1sDJxv13tCr447a4/dSnkf7JyPnzCKAmFTlRlKj/6RD/e8W/tiZGJAnS7igFTGwWXsbv5Em1goT7m8DE2mOkLf6fXggRh+WbAg5+3DrHqySVSpG1r8pPwghFQTFXVwWchE7UnrvBlAfsVYkgSpypnyNx2m/jzhzgoT5IcVA98OuTl0l+
 3DTfOzgf
 RolndPf+OcGOMrSYeQUt7KbG4ZXQbGjaBfltYPG2zVQ8aRWdpNKzcFzhSu/sdNzEIftozKS+v720tWy9ErY+W5xwng5Mw4Ah1Mus0ATI2PXWcJvNrNFgw/Ia3fKWmcp06MreXSO3CjXqsYZwR3Y5U9ejTUqeZ6AooksBR//1woZ5mIbsAsNRgqFB5JaNo1q5UPXqdcl+sZQ3VhFnXoWFcHIrLJzxMRDTQwYj4sw6IZXoOZxN50/G08/+bj6aOcsjyut/8Ac+j46pDKNZH8OQ8XYdfxU9DqbLIlU/l4hhEPMN+tf7QplI5VrF2PzNF1zdFp7OA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hello,

vm_ops->open() can't fail, so anything that allocates in it has to hide the
failure.  hugetlb is the one I care about: if it can't allocate the VMA lock
for a shared mapping it carries on without one, and faults can then race
with truncation.

The callers already have failure paths right around the call, so this series
lets it return an error, and hugetlb then uses that.  The first patch is the
mechanical conversion, which touches a lot of files but only makes every
callback return 0.  Fork needed the call moved ahead of the VMA going into
the tree, the rest is just using the failure paths that are there.

A failed split can be the last step of something that can't be undone, so
I've documented that a callback should only fail if the VMA can't work
otherwise.  For hugetlb this is a small allocation, so in practice it's a task
that is already being killed, and hugetlb splits ahead of a move now so it
doesn't have that problem anyway.

I changed the signature rather than adding a second hook because it seemed
less confusing, even though only hugetlb uses it so far, but I'm happy to go
the other way if you'd prefer the smaller diff.

I tested this with the mm selftests, the VMA tests and a loop that fails each
allocation in turn inside munmap, mprotect, mremap, fork and mmap of hugetlb,
shmem and anon mappings, under KASAN and lockdep.  Everything either worked
or failed with the data intact, and the huge page pool came back to where it
started.  The nommu change is only compile tested.  Thanks,

Josef

---
Josef Bacik (7):
      treewide: make vm_ops->open() return an int
      mm/vma: fail the split if vm_ops->open() fails
      mm/vma: fail copy_vma() if vm_ops->open() fails
      mm/nommu: fail the split if vm_ops->open() fails
      mm/mmap: fail the fork if vm_ops->open() fails
      mm/hugetlb: fail if the VMA lock can't be allocated
      tools/testing/vma: test a failing vm_ops->open()

 Documentation/filesystems/locking.rst             |  2 +-
 Documentation/gpu/drm-mm.rst                      |  2 +-
 arch/x86/kernel/cpu/sgx/encl.c                    |  6 +-
 drivers/accel/amdxdna/amdxdna_gem.c               |  4 +-
 drivers/comedi/comedi_fops.c                      |  4 +-
 drivers/gpu/drm/drm_gem.c                         |  6 +-
 drivers/gpu/drm/drm_gem_shmem_helper.c            |  4 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c          |  4 +-
 drivers/gpu/drm/i915/gem/i915_gem_ttm.c           |  4 +-
 drivers/gpu/drm/panthor/panthor_gem.c             |  4 +-
 drivers/gpu/drm/ttm/ttm_bo_vm.c                   |  4 +-
 drivers/hwtracing/intel_th/msu.c                  |  4 +-
 drivers/hwtracing/stm/core.c                      |  4 +-
 drivers/infiniband/core/uverbs_main.c             |  8 ++-
 drivers/infiniband/sw/rdmavt/mmap.c               |  4 +-
 drivers/iommu/iommufd/main.c                      |  4 +-
 drivers/media/common/videobuf2/videobuf2-memops.c |  6 +-
 drivers/misc/genwqe/card_dev.c                    |  4 +-
 drivers/rapidio/devices/rio_mport_cdev.c          |  4 +-
 drivers/scsi/leapraid/leapraid_app.c              |  6 +-
 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c    |  6 +-
 drivers/staging/vme_user/vme_user.c               |  4 +-
 drivers/target/target_core_user.c                 |  4 +-
 drivers/usb/core/devio.c                          |  4 +-
 drivers/usb/mon/mon_bin.c                         |  4 +-
 drivers/video/fbdev/core/fb_defio.c               |  4 +-
 drivers/video/fbdev/omap2/omapfb/omapfb-main.c    |  4 +-
 drivers/video/fbdev/udlfb.c                       |  4 +-
 drivers/xen/gntalloc.c                            |  6 +-
 drivers/xen/gntdev.c                              |  4 +-
 drivers/xen/privcmd-buf.c                         |  6 +-
 fs/afs/file.c                                     |  6 +-
 fs/coda/file.c                                    |  9 ++-
 fs/kernfs/file.c                                  | 11 +--
 include/drm/drm_gem.h                             |  2 +-
 include/drm/ttm/ttm_bo.h                          |  2 +-
 include/linux/mm.h                                |  9 ++-
 ipc/shm.c                                         | 13 ++--
 kernel/bpf/arena.c                                |  4 +-
 kernel/bpf/syscall.c                              |  4 +-
 kernel/events/core.c                              |  4 +-
 kernel/trace/trace.c                              |  4 +-
 mm/hugetlb.c                                      | 40 +++++------
 mm/internal.h                                     | 15 +++++
 mm/mmap.c                                         |  8 ++-
 mm/nommu.c                                        |  6 +-
 mm/vma.c                                          | 15 +++--
 net/packet/af_packet.c                            |  4 +-
 sound/core/pcm_native.c                           |  4 +-
 sound/usb/usx2y/usx2yhwdeppcm.c                   |  3 +-
 tools/testing/vma/include/custom.h                |  3 +-
 tools/testing/vma/include/dup.h                   | 16 ++++-
 tools/testing/vma/tests/merge.c                   | 81 +++++++++++++++++++++++
 53 files changed, 304 insertions(+), 97 deletions(-)
---
base-commit: d0b3eb0ef4ff466d8bc2b8ee77a0ac4386abe75b
change-id: 20261117-b4-vma-open-fail-c3305250ce51


