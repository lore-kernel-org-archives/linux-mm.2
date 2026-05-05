Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0999DCD3439
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 18:44:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 12AA06B008A; Tue,  5 May 2026 14:44:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B46C6B0092; Tue,  5 May 2026 14:44:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E972D6B0093; Tue,  5 May 2026 14:44:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D371E6B008A
	for <linux-mm@kvack.org>; Tue,  5 May 2026 14:44:49 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 700DB8C66F
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:44:49 +0000 (UTC)
X-FDA: 84734242698.12.6EDB82E
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf11.hostedemail.com (Postfix) with ESMTP id 1AB8640006
	for <linux-mm@kvack.org>; Tue,  5 May 2026 18:44:46 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZV/wH+1J";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778006687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Yq9HGaTwKrtLDP/Zy1Q2v2j6ECCTHfEEgkag37r4qvo=;
	b=RV9Y0NNGtqY5jOWfmxIF9OCImO9tOtnv6n3Zd6kOqH145PMqUJ0gKCW3r0Ch4JX746ip/6
	EHo3cShjXxUODxx0FY1O4hgKDMXLXczqfRYXUKsDoUPe2QCQ/clixTEvEe5Zfy1J/Q2i5Q
	Md1h3u5tN9j+IxR/HM3G7F+FCOZkA+A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778006687; a=rsa-sha256;
	cv=none;
	b=cTay0el+AgsfY2QMXqcSNYm9C8q6VvoPN2nL5y0tyvrdxNOintBac88gf83dtJaxj9Z4zu
	iSL87kk7gDpIeWOjc0R8odD1CVRhLOODids3uMP8gWX/Ope+xLwqy7blXz2D/Y56xP5qiG
	1y5OAS0a4bw8/aEZR9ASUT+284SXQMg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="ZV/wH+1J";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf11.hostedemail.com: domain of mpenttil@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mpenttil@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778006686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=Yq9HGaTwKrtLDP/Zy1Q2v2j6ECCTHfEEgkag37r4qvo=;
	b=ZV/wH+1J8Dfx9yo5NAy5mAfnYsIbf44el0LU3G6xReqP7UBH1LVSEucXv6j8yAvag4bvB+
	AXOnS8F8KNOD9saqOQwH14aOBNIHZ7O14xMJqNbJUbxIxSrBVXXCZbs7hmo8iVsu8pfL51
	9hSxgTa+qEbztSinf6hEYud69i7hy8Y=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-n18qMTK0OVSyJIGnpiuiRw-1; Tue, 05 May 2026 14:44:45 -0400
X-MC-Unique: n18qMTK0OVSyJIGnpiuiRw-1
X-Mimecast-MFC-AGG-ID: n18qMTK0OVSyJIGnpiuiRw_1778006684
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-393a6ee3c75so8594511fa.3
        for <linux-mm@kvack.org>; Tue, 05 May 2026 11:44:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778006683; x=1778611483;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Yq9HGaTwKrtLDP/Zy1Q2v2j6ECCTHfEEgkag37r4qvo=;
        b=XJRzB6TlVQwtvCLpZBFSpT5JCFk4eHQh1gFPuIIEKKkiFm9lNyvkJlpcwYRjyiSkfZ
         59Idm3pVxPV83jn60IV28xnkT1gETBiwPCB7Ax0UZdjHv9Be+DlmvyOtrCiGIBzlSo+f
         nAQjk5UeDPyX4HSY89y0G5YokmPqtMiNVfHT+LKb+SDBOfagTfwHhlA/txUWqtEQNPy7
         T0W7jm33aiNENpGvCqJa/ldLySM3MnPJw1zgLXELJhaewGHbNkepOKoStU3ZzIj9GVM6
         2FU1Z8qtu3BYumuvio5t1DkNlH0LyMbRO40cJIDQpck+z+4+scpuOiR/TdXZ4+fzrvpB
         M/kQ==
X-Gm-Message-State: AOJu0YxSg5qipbcgYi2C0l8Lf1bCgdg2pV73ISVcji1ExUUe4U/6gjmX
	n6kcMefdGDIF2likJ5xHItBDsr2PuYuVIr0epBZr0f/bw+DSuw0Jbiee1C1cqzyFYC3OWmYx6KP
	384qi63KXyhqkmu9axZxYuRIPrYckoUHNZo8DjUGeS+COV3mXDgIQwIcu7+ZRLtzMbtbtym3CqA
	JXGiFIl0TYSe7OQ0BabLPfagvP6JyV1nwH45drTw==
X-Gm-Gg: AeBDiesZhsZE5ra4zLAiDT3K4+rvJA3hsNGnFhrXDblnpTKC+46S3cwwMYWMvt5/6oU
	HekN0CtTrilc4OKB1Wv0/gKTTI+41FnInCRsYGn+dQeqTl3TMJTpXqyTnVXCWlKIDYZBNzVpNNZ
	YtFUutdnJ5WWlncY7+B8MoQEA+AJ9DtoYpjy7umcCoAfgDnOSra84dXEret/ILzHKnXPvKOY/WH
	yP/qjVdaJZWN0tOyl4vfWVzSYdbxoi3m7EhTLAvRNpyWR7TCGi0EQFf4cWjmEy0U5epXluDK9/q
	ks2mXg8x7DhfGASRkd4jpMVS0rgBvpn6IJAIU/iR6Tpr+pA9IZiofs9dXv1y3HNecu0Z/upd5tG
	BptKC93Qes1wmebdZ5wnymp1E3sKfQCnqzFD2JR99IUBRhgw=
X-Received: by 2002:a05:6512:3a8f:b0:5a4:79e:9669 with SMTP id 2adb3069b0e04-5a87f1dac48mr1708350e87.21.1778006683440;
        Tue, 05 May 2026 11:44:43 -0700 (PDT)
X-Received: by 2002:a05:6512:3a8f:b0:5a4:79e:9669 with SMTP id 2adb3069b0e04-5a87f1dac48mr1708313e87.21.1778006682647;
        Tue, 05 May 2026 11:44:42 -0700 (PDT)
Received: from fedora (85-23-51-1.bb.dnainternet.fi. [85.23.51.1])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a86e65fdf6sm2504437e87.78.2026.05.05.11.44.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 May 2026 11:44:42 -0700 (PDT)
From: mpenttil@redhat.com
To: linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	=?UTF-8?q?Mika=20Penttil=C3=A4?= <mpenttil@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>,
	Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Subject: [PATCH v10 0/5] Migrate on fault for device pages
Date: Tue,  5 May 2026 21:44:16 +0300
Message-ID: <20260505184421.2324798-1-mpenttil@redhat.com>
X-Mailer: git-send-email 2.50.0
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: vauSFnkXZBQpjWZ8BsyeXZrhKgmCGwFrEkpaJvSXZAY_1778006684
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1AB8640006
X-Stat-Signature: j3u6sw86km5nuorwnhgwn1f4ecbdy6jh
X-Rspam-User: 
X-HE-Tag: 1778006686-425521
X-HE-Meta: U2FsdGVkX1817IGj1IuX1s87gtj0HZVrjx+Ilk1ztuvlmczrw3nZT+81nmwFll1acLgi6myzbrANtVgBlB6bRHySezUgMD1D5Iksqvl7pvxHgFbM0YhAuKfdQkZZcEKA4ByYUNHx1wo2lg+7E3rke/QW90/iuAV1jRqkJhnNER9mDabprfgO01zQuoSuHNXVuqwPEj5ioF7VAyHDA1Ms8zco12ClsdBX0Clx6aWF1oji6Ks10A637pj7BNzj6mLr0A6CkVxdCBRz+ym1k2KlwatLNQa+Y7MNlUYUqbb1KwGEvzW+4P44tKAg56RDxyzKV7azqyspsjbqGuK2ZTq/FXncooBMHilFN1SZ9AyAYdbfX27buZBXmIF7XWRkW1F7Vk1hh0kqM32sMBl4cJFLkHGwEUoCPkxHPevk0TTg41+PWbVF2/7NMKsi/cLcv6vA4k46EvifnMQyWiEas/WsPvnhWN8x+gCsHz86CL9bJq2bDaoJDBFi+jhA+v1usAvW+cjr75YuA94qAwUyrhI97FRFp6prvzZZ6eQyZZGVUQ3mqNsL9tIon4dRtxmPgwQe24UEiTUG6apAszwjnKqKs7scsrYU6gPTtcz3qApfHOUlb79oZJ9Mdb5mbu6QnYN9qywVG7Gf5ORBliLD1lCAUetLvaKoOb3zJDOuSR60BmkIPV15gtwoGP9/T3QQRhBrx9HP8/6YKDBLUyyJVoPo6bT+g9Z/EL4SD2aW4CqkKNm2BKJV3ApGcaA/ed0dHwIbexC87SO9gKUzJnkX0H3+yYgVuZFhCRMj1YRebW/aIOimXXhUeb1iTmDbsKz2q7+Vh15GIVK0uBhcv1ub2Uv0E+KkwqAZVI+mC4BgLhM4t7Bg6CxRGmxCLktKrEoXBumNzUKVNW9Sr0R4JiJV7WfyKJvfryMUskdrruCKEw12S3VScoWKWuLAmVgHpXMh0Kz7PnAk9GBCEnTCL3PcgyP
 vT8MhJu3
 2BDMiElMxgx1/K5FCVWC6IyEwo9pYXf/N9iydS40dulxYnf9/xYRiTnFlFHkX9tyQo2VFfBcdXZ/kdnNzZVk/3Q0X0TGFCL5vqXRcLHMZWAKEZJKT6SoaUCdVzfSkg1hNwb6UuwxxBKEQRrBNHEAJCgZNLF8Ui4pgM3jW1K47EkZErWjnB1S/8Qyb9m89Co/qs210iBG9V7VPYHnNGI8NMO7RTMcHa/ub2JAinT3q6b8FEmHrEimHRgDa7psvsjzDhfHoKscdKRIozAIydC82wN2rBmrQPcs6j9rcNYP9yrMrExpeTcdWx1GriKjsqNDVuT6cnLMSdmTPdvetGOJ897yuZN6g+9Y4ezKLXBDUFTkipR8cXOO+CYyVkpEVHejHIl3rAEhTO+w5tmAPujSXVypcPM03BJnOu2EID6dJPnVa6ljYM5syseMDLouHmeXJYxpql27MYn3uQlLRz3+1u19xMme4q6jtbVAbrkcjOOgY0i6qRHz5u22HVZeLJqahfo/OtFR5MML5BZx6oCqH79AsvrrqOWRVp6mRwI5hUYNEfhkPTqjkbQHgibRbHU67ml1RD5RBXwvlx7ljNfkcGsgk3q8GSpj2vm9nbZlrlSjRCie9a7BoV0muM/bbal7H/g52ZJAgM0d9knk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Mika Penttilä <mpenttil@redhat.com>

Currently, the way device page faulting and migration works
is not optimal, if you want to do both fault handling and
migration at once.

Being able to migrate not present pages (or pages mapped with incorrect
permissions, eg. COW) to the GPU requires doing either of the
following sequences:

1. hmm_range_fault() - fault in non-present pages with correct permissions, etc.
2. migrate_vma_*() - migrate the pages

Or:

1. migrate_vma_*() - migrate present pages
2. If non-present pages detected by migrate_vma_*():
   a) call hmm_range_fault() to fault pages in
   b) call migrate_vma_*() again to migrate now present pages

The problem with the first sequence is that you always have to do two
page walks even when most of the time the pages are present or zero page
mappings so the common case takes a performance hit.

The second sequence is better for the common case, but far worse if
pages aren't present because now you have to walk the page tables three
times (once to find the page is not present, once so hmm_range_fault()
can find a non-present page to fault in and once again to setup the
migration). It is also tricky to code correctly. One page table walk
could costs over 1000 cpu cycles on X86-64, which is a significant hit.

We should be able to walk the page table once, faulting
pages in as required and replacing them with migration entries if
requested.

Add a new flag to HMM APIs, HMM_PFN_REQ_MIGRATE,
which tells to prepare for migration also during fault handling.
Also, for the migrate_vma_setup() call paths, a flag, MIGRATE_VMA_FAULT,
is added to tell to add fault handling to migrate.

One extra benefit of migrating with hmm_range_fault() path
is the migrate_vma.vma gets populated, so no need to
retrieve that separataly.

Tested in X86-64 VM with HMM test device, passing the selftests.
For performance, the migrate throughput tests from the selftests
show similar numbers (within error margin) as unmodified kernel.
Tested also rebased on the
"Remove device private pages from physical address space" series:
https://lore.kernel.org/linux-mm/20260130111050.53670-1-jniethe@nvidia.com/
plus a small patch to adjust with no problems.

Changes v9-v10
  - Fix for issue Intel CI found, forgotten pte_unmap() before
    migration_entry_wait()

Changes v8-v9
  - rebase on drm-tip
  - fixed uaf around  migrate_vma_split_folio() usage
  - added missing pmd unlock

Changes v7-v8
  - rebase on 7.0
  - fixed subject in two patches
  - enhanced commit messages
  - squashed patch 6 into patch 4 to fix kernel test robot warning
  - readded dropped Cc block from cover letter
  - fixed white space

Changes v6-v7
  - rebase on 7.0.0-rc6
  - added documentation and comments
  - denote to be migrated zero page as HMM_PFN_MIGRATE alone
  - got rid of HMM_PFN_INOUT_FLAGS movement in patch 2
  - picked up Acked-By from David for patch 1
  
Changes v5-v6
  - rebase on 7.0.0-rc4
  - use range based TLB flushing while unmapping ptes
  - gate migration behind HMM_PFN_REQ_MIGRATE for fault and
    migrate paths
  - always infer migration flags from migrate->flags only

Changes v4-v5
  - rebase on 6.19
  - fixed David's email address
  - fixed link issue without CONFIG_TRANSPARENT_HUGEPAGE
  - refactored into smaller commits
  - added more comments to code

Changes v3-v4:
  - rebase on 6.19-rc8
  - fixed issues found by kernel test robot with random configs
  - fixed typos

Changes v2-v3:
  - rebase on 6.19-rc7
  - fixed issues found by kernel test robot
  - fixed smatch issues reported by Dan Carpenter <dan.carpenter@linaro.org>
  - fixes to lock handling (pmd/pte) on errors
  - added assertions for pmd/pte lock states
  - other issues discovered by Matthew, thanks!

Changes v1-v2:
  - rebase on 6.19-rc6
  - fixed issues found by kernel test robot
  - fixed locking (pmd/ptl) to cover handle_ and prepare_ regions
    parts if migrating
  - other issues discovered by Matthew, thanks!

Changes RFC-v1:
  - rebase on 6.19-rc5
  - adjust for the device THP
  - changes from feedback

Revisions:
  - RFC https://lore.kernel.org/linux-mm/20250814072045.3637192-1-mpenttil@redhat.com/
  - v1: https://lore.kernel.org/all/20260114091923.3950465-1-mpenttil@redhat.com/
  - v2: https://lore.kernel.org/all/20260119112502.645059-1-mpenttil@redhat.com/
  - v3: https://lore.kernel.org/all/20260126111939.1332983-2-mpenttil@redhat.com/
  - v4: https://lore.kernel.org/all/20260202112622.2104213-1-mpenttil@redhat.com/
  - v5: https://lore.kernel.org/linux-mm/20260211081301.2940672-1-mpenttil@redhat.com/
  - v6: https://lore.kernel.org/linux-mm/20260316062407.3354636-1-mpenttil@redhat.com/
  - v7: https://lore.kernel.org/linux-mm/20260330115611.347988-1-mpenttil@redhat.com/
  - v8: https://lore.kernel.org/linux-mm/20260414041226.1539439-1-mpenttil@redhat.com/
  - v9: https://lore.kernel.org/linux-mm/20260505051658.2219537-1-mpenttil@redhat.com/

Cc: David Hildenbrand <david@kernel.org>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: Leon Romanovsky <leonro@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Balbir Singh <balbirs@nvidia.com>
Cc: Zi Yan <ziy@nvidia.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Michal Hocko <mhocko@suse.com>

Mika Penttilä (5):
  mm/Kconfig: changes for migrate on fault for device pages
  mm: Add helper to convert HMM pfn to migrate pfn
  mm/hmm: do the plumbing for HMM to participate in migration
  mm: setup device page migration in HMM pagewalk
  lib/test_hmm:: add a new testcase for the migrate on fault

 include/linux/hmm.h                    |  19 +-
 include/linux/migrate.h                |  26 +-
 lib/test_hmm.c                         | 101 ++-
 lib/test_hmm_uapi.h                    |  19 +-
 mm/Kconfig                             |   2 +
 mm/hmm.c                               | 836 +++++++++++++++++++++++--
 mm/migrate_device.c                    | 583 +++--------------
 tools/testing/selftests/mm/hmm-tests.c |  54 ++
 8 files changed, 1067 insertions(+), 573 deletions(-)

drm-tip
base-commit: 94d56a898a2db27f841b17f6966a81ba502fe63c
-- 
2.50.0


