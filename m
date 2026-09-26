Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AABEBC98318
	for <linux-mm@archiver.kernel.org>; Sat, 26 Sep 2026 10:51:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B50916B0088; Sat, 26 Sep 2026 06:51:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B01496B008A; Sat, 26 Sep 2026 06:51:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A176B6B008C; Sat, 26 Sep 2026 06:51:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7FF2C6B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 06:51:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 004D8A08A9
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:51:15 +0000 (UTC)
X-FDA: 85255596510.22.E8AB17E
Received: from mail-qk2-f43.google.com (mail-qk2-f43.google.com [74.125.230.235])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3026640004
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 10:51:14 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lDOsX2hq;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790419874;
	b=IaPDgbjk8725wkkJxGD2iRAhZoOWPk+O/ftPvGdN1dPU/aG+8/1ZlWkLulnbo1YDjXfNhd
	vZ85P6aQhPQRsXYarTaZvmO2bEYlYVHJklDYZC6QDlWB4lrWOu+LjqImwDnvLn1znRHWAe
	OgojownrtVVGYVN7JFZKfp5riZ+s5Y4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=lDOsX2hq;
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of gourry@gourry.net designates 74.125.230.235 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790419874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=nhXhBLbXkdtNzOcTcim9FzBfpMg5vkoQVWLwtE5p/IQ=;
	b=hk37tsGamfYCHB0KgI2mu0ofR6n+dVoDFsdpkr6LyVSRXSNkMocXAaxkGrmSksQib15s67
	2PiMR5SzzvCBsDV/2A9bTivOV4SvTdF+TlmfEQt36D+cPZU2K+WH7/aPjW7zIVATcC3JSm
	zjolF6SoN92SmsI2ktcbEREFk8KSyzw=
Received: by mail-qk2-f43.google.com with SMTP id d75a77b69052e-52fb767cc7fso18698841cf.0
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 03:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790419873; x=1791024673; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=nhXhBLbXkdtNzOcTcim9FzBfpMg5vkoQVWLwtE5p/IQ=;
        b=lDOsX2hqJea68sAMXftlj9tVamiAggOlEGWQujpD3LSy+DKZWcYokDmHC7i179AxaY
         98OEK1+FifKEjuuK5dgexarAH5uSTf9j8UNamiIMpcyO/kwVYWjOuLR3jDygHm4joTPM
         BtQVjQn3A/hYdQ8gbsK4d1BcF0cCRWKcXaMYrGLU/ktSm4yAvfF6QKzxKHRTtOtWcbCk
         YbF0EzhG9N0bOLhdKA+4UbZC8dVZeGgpCxzBk1INzpvT07lGXlsPXOAMGx7AYQznKdy1
         EEtbz1vfCNh1ODDGS4vB9lPj0OAIRwoiUSpCi29DE+fBP4wz+UbZjBtosQt7I75Y83q7
         y90g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790419873; x=1791024673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nhXhBLbXkdtNzOcTcim9FzBfpMg5vkoQVWLwtE5p/IQ=;
        b=AWDkzt4B9897JHYUA86/mCEBRUHzl0jh6+CwU3a5K13tEFAnxNAlghzHbjQAhdgRyL
         R6gKZDUT2GK6iKN0ltfoYecf7mBVoOdSbc0F0g/cQhIQ1kGvCXdpLOBAORfedG6cn8o8
         NK+j9Ge0jsPMuLnSJuMZSNV1IJsUMlCQytK5aOKFeC8mEa9ZSkzNC5AS9hPTud0ysv5e
         isHkEcDRCIAakX/EJ4OMwmxTlRReDuV/BuQf6CzEchwDgyloVEDIW2xw26Q/RAsKortv
         mYnbRsleFUOvNXocUnPOXFgBGBSzCFCAXvthw38zrsLFiun/Y1yJGDb9rFc9HOF148wT
         h06w==
X-Gm-Message-State: AFuF++k2b6qJ3WhM8DWHFJhF1YiqSSvwKYtAMU2hF0nV0M8F9tiP3rGO
	U9v7Z4vVKr8+i7+HYbnfQ6RLsFVnCBmAv6NZ+2q7atDGLiMBjnUzPd9gTzbwkTLLWouHbKn8u0t
	7CETpUYU=
X-Gm-Gg: AYBFou0IxdzwmZwJ2jCoEY/rnDttKhAnEVq9u4wbElEJLex/5z1z/VwG2k+rhJgpoQ0
	DtV7ks7Ua5HA7xS0AN3VHSN5EbGGigjg/wuRcESZiRUQ7QRoGKEgGKDPtdfQsdJcsutzwILs0RO
	xb2fvYgi69wtuLW/nWtm7K1l0U5nd99qfkhq1JU4RhDLsyyudV45PX7+IYq1Sx2CMYsOmY+5CQw
	+0x8FpPPv9SM4ISpA2NNE+5uGX4PxQfHE7oarWhAP8A04EvBHYvb47vTvP3tJIqnDPzE3BJp44Q
	5sVDaplMGUGu4FpCF9JxaFFl0Bs/eBH5Q8gjBxtccudni01OiMIoZiuSHBLkA7jJLfYNsgVbovH
	2vvTzAFxe0szGrbO3tAKQvrgBcbYbwUyFfIZw8Qce/vdqKY7Jgp3eAz236hB/VM5zlALhoN+lqI
	Z0I8fi2b+5/D6mW9NClt0+sP5eLUqtZXlBsnfLOSUFKuYc5GSyoj/6222BUrqkOgEl/6SfSLwma
	pgFfR1XBM+Rk8SehqBSXqMXiAdOLn/8ljBRoAbNklEcOm27z1VbmCHRx/2t
X-Received: by 2002:a05:622a:e150:10b0:532:9bac:55ed with SMTP id d75a77b69052e-5330b583945mr70779921cf.7.1790419873168;
        Sat, 26 Sep 2026 03:51:13 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53322422063sm15060361cf.28.2026.09.26.03.51.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Sep 2026 03:51:12 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	akpm@linux-foundation.org,
	liam@infradead.org,
	ljs@kernel.org,
	david@kernel.org,
	vbabka@kernel.org,
	jannh@google.com,
	gourry@gourry.net,
	ziy@nvidia.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v3 0/2] mm: stop calling pmd_folio() on special PMDs
Date: Sat, 26 Sep 2026 06:51:08 -0400
Message-ID: <20260926105110.2156652-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: 6udeabtb3f5waf5nxn3gzs1f6xpqzub1
X-Rspam-User: 
X-Rspamd-Queue-Id: 3026640004
X-HE-Tag: 1790419874-576138
X-HE-Meta: U2FsdGVkX1+QbjOi5HsY9rd5wFgkjWQRaX5rzh6LUxC8INoMEwGRQ0IhZHAsMf8WH5g16nNN2NcHoD058TfFMI84ILkZ73KipsO45LmojnPwIkqmygazMYcA02kLfOUkWMzAUnIYHzTK8rOTGwN7ERAIGmwTjUAqTv9QX/YWBRJ89qF692OyUIzCzZ8wk9zq5OvfjkeVOI8xuAGjJNb7+LWeEPug6mCqALPSFsJYpan5i922Rikl2hnBUhG9SYIm75jODQjDy2AAnwcGSJ5ypdfn7mSlirmZiABnDDsRgYHRaGSrUvtemIrio/oc82omNXFCAEJZK6zxrx2AK31A4X93/zhkHZcYdySdtzbK5jVCM7aA9yF+Rgi29Si3ZsHBPHP+4NOG3WOUTatuM80vdFSoULeXa+DIkzgaCVLfViTfxFP7tcWWPMr9ys2xoz1RY+odBkUreK/DCSTvrKwL6jhhedvhFpMS96ML3r+Bt20WZGTNKB9emoKGpao4lifY2MfMVzKxCwDKXpynghvNBQLNeWELrTHVnzeTsuY2VyauFos6q2Rx+iHWc7Kc4+IuAt2lOM7xa+gNISS8jM2v+jJKMge+njKGxwE9k6S5PQ1ezLmBQn+wBN5aUh5LWxwyTHnBLoHWSlNybigcv2lA0OjGXBogfOG0v4Cbkvb/DR1yGqapWDEBq9LquWZ9dmH45Rtb1JHk5UyAAypagCjQ1cxeN5Yzt0e3Ry3jEMdqqmmQ9eTcWMqPAqYlrlODwfHcaVTn1eWByEQ7+uox9BtMKHJj85u7nGFcJr5zk9tUEQ4zv+iQawuYFbWc4i+mKCwxbxSLkcjRXr2eSdd65DDkE13LyJAzvdD+tg58AuHFEulrCss/Znx33e6YmK1AaSipDPKn8Vqf3yuyW8AfE6A4K9T8pPE/D0mKacvsz9ZSwQsiyoz5fj72u/UvCb0Wt/d1S9pbqZBCRvwNej0iJOM
 8fAGHqo9
 BHaDrupQcJbvv4glKXoPUDRf18k5I0DXN2EJrfMgywnpBND7TnyUaTyaZ6ajJrVtoWa8NKtJgzixJ5doMW2zWYsnxsFybSxwvyww14ZM3MJyWKEevbI2VrhJb/7j52qRUzVURARDoGwLz/qp4FI+LsAmM2Ihd+qxQIw9RX8PvQ1taQEwc4jfvISPHCVD7bqMJPmQkcnGr8fjlMQM44PwF5yfNJAVDMlSm9Fi7p1lpJuPr8p8VTbYY/n8xyxlE8qdGBV5mLQlnfBJSPmbW1xB/EYOEwy1kYqnm3kQAhXST5YgdQhyL72DHrZXlybFos3nvP08VvshZ6K/+qAECDd8pPbHy8W3bzHPgYOvf2Z3uXxXLWvD8Dc3Uly7FP+yMTd3zlCVdoFGnCUSsnlJlLK32uoH8mqyPu23tJdK4IW7W7FQRUNxtCW/f8Bx+jaOzbDVHOKeHtFH03MVHVGQ19ZCXYMThsRV27X2nhl14ec64I4er4l12a8M1dpEgh2Sw82RgEB8g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Two page table walkers resolve the folio behind a PMD with pmd_folio(),
which is only valid for a PMD mapping a refcounted struct page:

  madvise_cold_or_pageout_pte_range()   mm/madvise.c
  queue_folios_pmd()                    mm/mempolicy.c

vmf_insert_pfn_pmd() installs special PMDs holding a raw pfn that need not
have a memmap entry at all.  Both walkers can reach one and fault on the
first folio field read.  The PTE halves of both already use
vm_normal_folio(); these two patches make the PMD halves match.

The four callers of vmf_insert_pfn_pmd(), and which walker each reaches:

  drivers/vfio/pci/vfio_pci_core.c        VM_PFNMAP     mempolicy
  drivers/gpu/drm/drm_gem_shmem_helper.c  VM_PFNMAP     mempolicy
  drivers/gpu/drm/panthor/panthor_gem.c   VM_PFNMAP     mempolicy
  drivers/hv/mshv_vtl_main.c              VM_MIXEDMAP   both

can_madv_lru_vma() rejects VM_PFNMAP, so only mshv_vtl_low reaches the
madvise walker, and that needs CAP_SYS_ADMIN.  queue_pages_walk_ops
supplies its own ->test_walk, so walk_page_test()'s generic VM_PFNMAP skip
never runs and vfio-pci is reachable by any process holding the device fd.
Hence the different stable tags.

One behaviour change: mbind(MPOL_MF_STRICT) over a PMD mapped VM_PFNMAP
region now returns 0 rather than -EIO.  The PTE loop already returned 0
there.  drm_gem_shmem and panthor are where this is observable, since they
PMD map pages that do have a memmap entry and so never faulted.

Reproducer
==========

No hardware needed.  An out of tree module stands in for the drivers above:
three misc devices, each with a ->huge_fault calling vmf_insert_pfn_pmd(),
plus VM_HUGEPAGE so the fault path takes the PMD branch.

  /dev/pmdspec_mixed    VM_MIXEDMAP, pfn at the 1 TiB mark, no memmap
  /dev/pmdspec_pfnmap   VM_PFNMAP,   pfn at the 1 TiB mark, no memmap
  /dev/pmdspec_real     VM_PFNMAP,   real alloc_pages(PMD_ORDER) on node 0

Userspace maps the device into a PMD aligned window, reads one byte to
fault the PMD in, checks a module parameter to confirm it went in, then
issues the operation.

  vng --run <bzImage> --user root --memory 4G --verbose \
      --append "numa=fake=2" \
      --exec "insmod pmdspec.ko && ./pmdspec_test <subtest>"

numa=fake=2 gives a node 1 to bind to; the module allocates its real page
on node 0, which is what makes queue_folio_required() true.

  subtest        operation                              parent   series
  --------------------------------------------------------------------
  madv_cold      madvise(MADV_COLD)                     oops     ret=0
  madv_pageout   madvise(MADV_PAGEOUT)                  oops     ret=0
  mbind_mixed    mbind(MPOL_BIND, n1, MPOL_MF_MOVE)     oops     ret=0
  mbind_pfnmap   mbind(MPOL_BIND, n1, MPOL_MF_STRICT)   oops     ret=0
  mbind_real     mbind(MPOL_BIND, n1, MPOL_MF_STRICT)   -EIO     ret=0

Two things the table shows that are easy to miss in the code:

  - mbind_mixed passes only MPOL_MF_MOVE.  MPOL_MF_STRICT is not needed for
    a VM_MIXEDMAP vma: walk_page_test() only skips VM_PFNMAP, and
    vma_migratable() is true for VM_MIXEDMAP.

  - mbind_real demonstrates the user visible change (-EIO -> 0)

Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260817220810.1175596-1-gourry%40gourry.net
Assisted-by: LLM

---
v3: improvements from Lorenzo
v2: improvements from David

Gregory Price (2):
  mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()
  mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range

 mm/madvise.c   |  7 +++----
 mm/mempolicy.c | 13 +++++--------
 2 files changed, 8 insertions(+), 12 deletions(-)

-- 
2.55.0


