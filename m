Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AED3EC79FB6
	for <linux-mm@archiver.kernel.org>; Sat, 12 Sep 2026 03:48:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6FA6B0092; Fri, 11 Sep 2026 23:48:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E206B0096; Fri, 11 Sep 2026 23:48:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89D956B0092; Fri, 11 Sep 2026 23:48:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B00A6B0092
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 23:48:41 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1F43CC03EB
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:48:39 +0000 (UTC)
X-FDA: 85203728358.02.9520C89
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf16.hostedemail.com (Postfix) with ESMTP id 68673180002
	for <linux-mm@kvack.org>; Sat, 12 Sep 2026 03:48:37 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WtJe8JeJ;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789184917;
	b=xhpRgYOMfXSMZHpwnbVZEFiOSZLkx4zgXXzgwB59zF2FqAanHj6SexvNFEMJZEfQGsezDk
	ko/JaHYw5Bi/D4PazHI/qP9FBmWu0ovCGQyqPSKGppMVfe1wFvximvnH6moDlSZ9/ELGos
	LhnixAD0U4aIJYeUJxBfLgxWMd+CFhE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=WtJe8JeJ;
	spf=pass (imf16.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789184917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=plkBLD16av4xLeK164/lGunO4Zlly9VfMGr5BH//1kE=;
	b=wPM0ikX1H78FSIUD5B68enXDs5aNohZ+PKGOEZmkzheqtl9KEZvABxPIiPSEvVVrcDExCn
	OKGyGiIo4sXHwEIdF78WUhueGWh0WQVUFHaxGQaWoIY1IasTSevdQwdkJYIKuXhcSkUvWq
	DY1PS6KW3MJCNYL+WvyfQBmBNCbNrcY=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-9103228ef53so17106226d6.0
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 20:48:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1789184916; x=1789789716; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=plkBLD16av4xLeK164/lGunO4Zlly9VfMGr5BH//1kE=;
        b=WtJe8JeJbJpkDDAS+yTfQE8HIiORENS+fLAALXG95QZ2hItzyZrQS5M3tqUUEVxmDu
         tl7Ex6F/FaHIHRLQS+xlblIP/gZ032ov23z5aRtNj3r8tbE8QKrLTNAe3qm5X2XrLZwv
         D7TqoOWUhTux3JhCPXu4pGvemiRgCHjRUPW2JKRyekZOrbSk1VOVShfeIitkM+kR+5Ai
         /ElJqWKWOcWl4zZnXda5F2g5ayzuTLktoClGfxsmEHb1juPVDE+DXiQ+TAK+r08Vndzb
         qak0NNHYXt8cjozFxXPrrUOthbeGggMeLDIl5esL6B4ykvzc/CMvgZOi74xCAT/5aE7V
         LjiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789184916; x=1789789716;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=plkBLD16av4xLeK164/lGunO4Zlly9VfMGr5BH//1kE=;
        b=kNKOwXB+j/Vi/aEGKaHQFWBz4uhGOfvBbBYZaWZFM4JbTGnfwJTiWNP8Q4S/0b4Tb6
         y4ueL/6i41fKG+d34OKZkFnfT8kO2PwKYvZ8Jmh961QoM7ddoEPLJfoQtSOODk5zYbGK
         /tu9pZSLjjfIfcq9bdGP4JvhwCD+C9YDhGP6cerAnPOcYopzwTuxRMvw+5/NXX+M/XR9
         dj4r3M0OC+SBcjh6T4LYdUBi2/NGRkR+cAgOcK5XEqTOT3Qs1U3xJK8uM2TIt9wd0UvZ
         wP/rel3mKqeEh/Y1OX7kTjvE8tAmG200CGxoMqeYRspoQzZfYGdzG1Eb6KJT3kuKNLBj
         urAA==
X-Gm-Message-State: AFuF++mdrfbnOTGD6JCeUVk69DtIg4PU/zaOyPoA0XEnZsshQJ1nU3Sn
	dsgmMfiYo2gdRMs34T+3zQevXp1p2329Vjj0nKEgibg6WngEQhQDzT92Xd873L8waF0ad9YLn3M
	dDjo0
X-Gm-Gg: AYBFou2UFn9OgiBnXrco9Gj7QasWPS7J9i74YMkJ7lsaGQGP4fCbpiQNFXlpCxI3495
	mnbVFGn6IAI7U1VvxNOrCz5qanNutQ71SIJ+9etawVaCCwqBrD9aq6MFoc1+9zet4cQrDv3fUie
	giqB0ozCRxfMQdLpdONxFTDWWoRpkIfzqUhYEWIcudPn6fdhMH1KElAIhthwcCDMKpylcgphlee
	P91u3cpG7NJtcsdJYNoUPGNkkVT0Bzcu2xlkjdHljtuBYHRs8nQe+8owh5pruy9CIwjmI8OYMLn
	JQap90hmXXe0KCcr0qAQqLq/jID/H0i9DPyeUkSghA8LV6pdrmN29AHPxLF4IpmU/jXvW4v6zGi
	/b23o0mjyhKxhax7YC8F6ekpVprARlWLdYrE9Uf0w0EBukXcktyIJMBpGfmNgitG4DEIUayPR0w
	N8vx66vVlTRvJG4yf930SCZHc1hmxDuOW38wDYojkVsgizCq4luONSUgonYe6EzRT/CLz3BfVBE
	FVFypeXxlJ3Mr1JiQUtZZtiLG2e3xUKq8Kt+cwZXMcl0VL4gIVugkEMhdqc
X-Received: by 2002:a05:6214:529c:b0:910:6a88:1a28 with SMTP id 6a1803df08f44-912120e24abmr96843286d6.18.1789184916546;
        Fri, 11 Sep 2026 20:48:36 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f494620sm36252476d6.28.2026.09.11.20.48.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 20:48:35 -0700 (PDT)
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
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	peterx@redhat.com,
	jgg@ziepe.ca,
	sashiko-bot <sashiko-bot@kernel.org>
Subject: [PATCH v2 0/2] mm: stop calling pmd_folio() on special PMDs
Date: Fri, 11 Sep 2026 23:48:31 -0400
Message-ID: <20260912034833.2952750-1-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 68673180002
X-Stat-Signature: 7t9yj7ha5jirh7pt5da9qiqfmsbuhn6o
X-HE-Tag: 1789184917-173550
X-HE-Meta: U2FsdGVkX1/GEZ1R7EOI5/VmFtNboSc+L68uayHUtNgxFGCZfzimY0N2u12yk6yMX0FuzgRZ8hirQY6FMz7aTJruGOzILY9M4i3Z1tkrPU6vMmjwHDEcShZQJ38IBB84BXQcES5mWE2bCGFxI17NH/f5eBDCRPFmGqnLZ9zW5tVu/nX/WPoeYtRyUIXzt+cQ9NWIR71O7Lk3ZkuvaHKvzL6vyYSmvNiW62qL1fKbhoSnE+eHtB82cucYWd9/q4UoGsvfeR7XVglika4lzh9ZnYxAhkaJcn3yeL5/BGrBATcyiyvmHvXkGrT9k/1A7DAJ66Dev+uusXv44lGzFidnot70p3LT3LZ6OOxv6DznUPf0t/uafGI3ZqE5BtqZSdk73g15z75+9B9ymgNAiMju87nRycceXaVNLvIDY3EQ5LV2x0YcAbfVKYgVfjRt0gVBlAKjo7adzs29KQsy9ByrmVLa7qV88GmNiB82A5fc4jAaeHpwL35ZyWIM5WemtmbqRIl8MtXBvguNdgFCuGhqd8I5LVtlOIOYlGiF6ZUD9QPj7E1XpV/BfM+08By8oV/B27MN9cO4JmVUFVUaH5e3EbdYMinrRgonLLS/VNsADU5cFTd9juP6NU7V80OT+PgOBEJYUk4/r4S9TQuLa9Ah/4yplRJoLKb7p/fV1A9F4R4QKl50BicP1I59RY4iwytUDgB2Fy1CIupvdhE2P9FH36e2VftsJlDr/YMwgk3DDBmaAoECnpBJeAj2TBM9og9hw1iLqHLA0+zNR00/7aIJveIiTFkqUAkpDK9BLkWmrWHWZpXc4TWKUz9RoZSwinenMCHbIi6tmRi8pe1yPuui00clfzzv6H1cqsisJ/SMVEi33zxz0/rwYzvJ2N7ez1IOSUeealYyl956wi0ndDWnIjvygTndd7UgL6hwwYTsA+QHqiCy54VX3Yg2Trnov/LENy1zJstJ8zc2iI+V+bJ
 tgo+kEPi
 hOu7OjFH/Lv8pxY6z+YkaixkTBkKj9gAp3DdxFasOe88r8X1Edutwug4T74qPCUh3qT/8fNQOzIf+cvFjpIwSRPpaCqG/J7a8VhWYCHwyT73qWAO6ooAE22ci1d6BGvUKnhcrwNRP6wUKFh5Bx2nsXwXpxgTBYDvTpECDeDVrNThvrNNda/LG301/DzUKtXzjulH7/sMEHTnuhErrIMF/9y4aQg94kvrjF5HbhlsP3BRb+XPLc85FZAmfr6BQD9gon5Wy86b2UStJw730jzVkUACiBIexbuuPoWhD8yyi2rpL4x8pGYMfE1Er/WlMknAT3HeWyVybG1XdxwxxfhpALolr0tQ+pd6goBDGk3unUl//q6BgXKvSbUwJT5y0BlrZbCsWeGLRfqb+U4AZ9kNT89uMfPmjxzsk10wHOZGxjR8oIZudRaGQhSBViOvI3TTTM8lKvgNayMQK517O76IOlw37N6rnYXqQYN5B1IEsj9WqAD2R5SjCO47NnJv9KCv1Bf4R
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
v2: improvements from David

Gregory Price (2):
  mm/mempolicy: use vm_normal_folio_pmd() in queue_folios_pmd()
  mm/madvise: use vm_normal_folio_pmd() in cold/pageout PMD range

 mm/madvise.c   |  7 +++----
 mm/mempolicy.c | 16 +++++++++-------
 2 files changed, 12 insertions(+), 11 deletions(-)

-- 
2.55.0


