Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9669CCD193
	for <linux-mm@archiver.kernel.org>; Sun, 26 Oct 2025 10:02:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEB958E0160; Sun, 26 Oct 2025 06:02:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9BE38E0150; Sun, 26 Oct 2025 06:02:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93D998E0160; Sun, 26 Oct 2025 06:02:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 72F3B8E0150
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 06:02:19 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1EF4C1A0369
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:19 +0000 (UTC)
X-FDA: 84039825198.17.9EE3EE0
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf20.hostedemail.com (Postfix) with ESMTP id 40E761C0002
	for <linux-mm@kvack.org>; Sun, 26 Oct 2025 10:02:17 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GQAs25iL;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761472937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=71oyM3iP4xpqh1DSC2mSfcPoW9iB//67VkyjOnGFurQ=;
	b=Oryi9Gj/9fWWuv0bnRnEAu14KKebW0+Ah6xA+JbEnzK4nGxuuYaAhbZy0Lk2t66WGD3de0
	hOBDdyagYt45wJjZZhJDx03tKpbG1wi4cvlSmKPh7VKjkq6wwsUlzqXhkxrCtgwtsnKokE
	q/mdtS4WRGe1RoaX8zaBIdiJ8gG7LyU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=GQAs25iL;
	spf=pass (imf20.hostedemail.com: domain of laoar.shao@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=laoar.shao@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761472937; a=rsa-sha256;
	cv=none;
	b=MiakMaOLLySSQ0wwnCAwfGSKiiolVYlAk9rZOQVyEHxWEfP8c3r6pJBaR5/lzAUzLD6bLW
	3PFP/wxqZh95Qo8sJz3CFZiLeGiu7Pc2kkbXo1ynsVSlT+Ir80y4xfXyka5UlpaoYAVkhh
	79VfPNExV5ONEOw+WHIxF/CkKp9osd0=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-33ba2f134f1so3418145a91.2
        for <linux-mm@kvack.org>; Sun, 26 Oct 2025 03:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761472936; x=1762077736; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=71oyM3iP4xpqh1DSC2mSfcPoW9iB//67VkyjOnGFurQ=;
        b=GQAs25iLSWpSey5t5WIXDryTKMEHqj23SEr9dyNmINAHiXHfkSorHKMLSqYLjsRhXF
         4z4aRoSX9Z9yPJndDofw+1pRKAG8OpSiS13TivnR90yejAZgZjrnQdZGVJpESolpi0MP
         vZ1SImQZef+QTeirtZ9Np6rDFNnyspE3pMbavOBZYxdSiqzEeZVBf840RAiFmdWkTLKk
         AZ+4zeA9WFkeixLiylFVa3+Z/PHFWPX8UEDLPxC+CcU+jwoT9F1C5P6hRyz2cnadg5OV
         9OdUePx830gPX/JHj4aK+XkXyaunfSfe0V1Vegv1i5RDpsfgLcjyQk1Yc0fGRm91OJ5U
         pPhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761472936; x=1762077736;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=71oyM3iP4xpqh1DSC2mSfcPoW9iB//67VkyjOnGFurQ=;
        b=efjQAYM5mlZYciEAu/oNlyoyNXFDHzWhK4b+UrPc1sCJg5FWqCJHXx4WONe1/kqYV6
         Nl1LHfulGGW+z1IcyFlVT01/+49Y0UxMiPr4+ziXUObxWQ8eOy2olee2JDzdna6Desq1
         fX4+SHybM35OTyQHdAg3SF4zMthkyfQWaPYSo02HMm9+dmhXGWfq835dybSPN9F6sWxX
         GG9/SXkrnUV3U7q9CnpQWA97ttGYi+ggI4/ic+yOAAFfAWfqh/uc+RH1RW2N3Tv2mQ/+
         MbArMwkBzbAFA6MvSnETxg0NTly+vFHcX2EVDmaol30DLSLKIm0DBJJO41O5MT8ixHpY
         Zecw==
X-Forwarded-Encrypted: i=1; AJvYcCXQxUtoTsPPzGirfvKxQG3CAJiKHEYWfNdpyi+XyX3lWdlf/+65fppQ9ncfW3Sl3KeM4CPDg6eT+w==@kvack.org
X-Gm-Message-State: AOJu0YyiYY40pmAs/OPLeAVv9Vyzov68kgU6yeVwdQWsiB/9DKJvNSqD
	XK2Zsecou7IJvpbBCbzJG+5wMF9sUXpjYk4O6Sj4j75rGLDnzL8Fl6ys
X-Gm-Gg: ASbGncsTOIozns3qm81l6Tmer48kqNdspi/c364kU2JwJ0xhrbtTxDW8tkhS9pp7hw9
	gJiN/0p/HRJ+D7bCr3/RwqBwd0vBAVvPt6sO5Z+kUlNKFTQdhxHiMsgiQBYbJjc0JZ9RIDv8xEl
	ppM+67kfp6UsJZe9muA3/r0k1wu7a5ZW07gmEhQsBi48HS+dsnP0Q+ioJyH0o3TFAstUhriYgLE
	+d4GermC0X0V19m2PPKK4gwIDS98rn/CpeZuk0Wemxz15D6iDrUq3gFD01lnYENAQOqNqT2nN+e
	WrY744t9XCqvSgiNvvQyUX5H3djynKlAgXgb/MZr/f9xiw7DmzH6aEPTIuUBXvYCo6fgntJdVZe
	Uw7GoE0+tLEgr4VWsVmQCDsc5ME7a8r2WX12QbXkPm4kx1wEk+nzDxVHEXdKL+zdO49nSO9La6z
	UWiBdIZGZuVcUxIF5cKz3iKP23aW1JjKwBuP90DbCrpjDHJw==
X-Google-Smtp-Source: AGHT+IF3W0fD8mmF2/UGWyg+0FB39FKVjvrwsLKyUVcP5vVu2JK3UT/8NMbm25jqTH9tVOGWi/W2sQ==
X-Received: by 2002:a17:90b:250e:b0:33f:ebdd:9961 with SMTP id 98e67ed59e1d1-33febdd9ccdmr3656581a91.28.1761472935796;
        Sun, 26 Oct 2025 03:02:15 -0700 (PDT)
Received: from localhost.localdomain ([2409:891f:1a84:d:452e:d344:ffb:662b])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33fed7d1fdesm4824966a91.5.2025.10.26.03.02.07
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 26 Oct 2025 03:02:15 -0700 (PDT)
From: Yafang Shao <laoar.shao@gmail.com>
To: akpm@linux-foundation.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com
Cc: martin.lau@linux.dev,
	eddyz87@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	john.fastabend@gmail.com,
	kpsingh@kernel.org,
	sdf@fomichev.me,
	haoluo@google.com,
	jolsa@kernel.org,
	ziy@nvidia.com,
	Liam.Howlett@oracle.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	hannes@cmpxchg.org,
	usamaarif642@gmail.com,
	gutierrez.asier@huawei-partners.com,
	willy@infradead.org,
	ameryhung@gmail.com,
	rientjes@google.com,
	corbet@lwn.net,
	21cnbao@gmail.com,
	shakeel.butt@linux.dev,
	tj@kernel.org,
	lance.yang@linux.dev,
	rdunlap@infradead.org,
	clm@meta.com,
	bpf@vger.kernel.org,
	linux-mm@kvack.org,
	Yafang Shao <laoar.shao@gmail.com>
Subject: [PATCH v12 mm-new 00/10] mm, bpf: BPF-MM, BPF-THP
Date: Sun, 26 Oct 2025 18:01:49 +0800
Message-Id: <20251026100159.6103-1-laoar.shao@gmail.com>
X-Mailer: git-send-email 2.37.1 (Apple Git-137.1)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 40E761C0002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 3iyh8qb61pwcs3exayrkayaszfkr8uhi
X-HE-Tag: 1761472937-244721
X-HE-Meta: U2FsdGVkX1/zYJVT4xIpu54DlzRS2uQxGadOXqTm1zy0VFWqiNiL45mH7hoWwF8vvCJtEyf7DX9fO6FgOYO1phSAwqaapQDXQoQMGPg0DGanjX2cbXa5MnlBFUI9+tMwQN7d4fhFgb4yruub2Ga/4n3wbr1qRNhW6gHNMHufqWZ3E2BAvSZ2iCpv7y5a/1d1AKD/DdqiahhrtT1z+vkhnkrwmugP2g4yenpiRr+/S9WJ8LonAu5AJqMtR/Vz+Sq6Q35llrMjil0Gz1YWlgQgq250RHwwYcumFE2LO8VxCJFHV9rciYZXK0N0jTGCuBlZdarnzW0ZwsM+sKr9PxMNV/8+nslMJ7WePU1AdqhJfxFt8DLXDLUo1lyfcaYDsJAnXX7tkpLLQjgEWp7gRlK1EVWiUGyeRhOaqIeyfw1gyT2Uh5hV9qrvf1HQ+L4zvntlKx5N43z7KabldfZdrtNsiJSmZCQIh68j4yrwF0PBQazw2iALky4OuxadRxnABVoGABmzbB/LKHKlba2YIUBSon4gB4Ac3n5XS2OdBPxTIto0B0GfeJ/2rTwmmLXu9LsjtLpGDCQeMawcWlKlpYZCvIorzvxeYb2X3J7fFynWEcZQpf8skSYk4S21xLCkCNUEbFM+8gAWSqbZUCkLNl+qmfWBGwUfDywfNWNdwXcL6F/+Z2VSLM+cg2dGt/0EXmTK6RB+02uDiu7sT7xC9PZ8mJXm6gp2amR311gSJW2bwJiXMIzCcGDFqW4qePrDTrVpFvBtzAqbO/RQMUInD/6vWefhLvUpePGGeC6kZQInOwWKImh7sZ7Q7UzQLf8r1cYYUWOgpaNfbPkrfo7Z5O8wenFE8v9S4cjX7wikO5+IQl4/rqGx0QrOGe4UWuoE7zH2HGxu/z7gLIhScYE8a5CnHLUvBIdn44FOAETI2da7KsURJw1GXNGgTAdyeYcD0QJ1pTz2Rj1yIG+0cwKQEU5
 czGYdB+A
 ld7xOWmziif7HUYzWP+3qKdOUNuUzJiFGDpoDXXiINGkkWs8VgIEzCzNnzH0tZzktZludqrJKkeaVIptlPryrwlH5Kq7O0GuwAo+4HLdKyhnSN1C9VTnQONWMO83QBTXEh8OB4zDIjFsRTtJnXjZaj1cm5/cOYQ1bzyyyfOfWgK7FduwiWXRbXct/OCCGc1xWvzDbt/OVxSFRCE3yOUsDbwEMmaYfVUKQGs4w3AcvT1INsTjhj6MyHSdNisf2L1wrPxR4mq7IO0j+VOlzA5oZjR9UTARFEu4Z1H0+ysSkSKI0OWHxmb4TfmgncbqlQlGN3PjtDWs4acBHZgVtSzHEsvcvxuDIJd5v0jL2SOerTU2gyKSZ8rbwCzdlA4M9OZWTLUHsH3cENs9KDU/uMvhV//ejnZf/xWwPRl+IF+maSelNdl/Qrl+S/rmYWEya9B1M3s0tv4w7DIfok5nDJwPWJJPHHIZY+l6m2FW62CR0opgV8zApJ6CfdEX37wOnlMAAfkhHlfDQ0LqoeRRvqFxmRAyh0+F3Nwy8WziqNPBGddVKJ0Ap1JwL4uWGrFFXwl1ydtkQiKnyUS6VuMo1X3HkMKk8guAsODHrCb6jRJ4LiMCgP6rVOCWKSPRtVmC3lLtTP2KpNQPBIn3Z+7PdP94Y5WDms3Vd0VmT5vKl+BoI1VS2TXVl9+R/3/uYjiUUhK4KG6GWK5HNae6DUtdwgRQ+DCZ84sse+FSt4Mz5/k0sawIOQvQQfmIX2QrwEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

History
=======

RFC v1: fmod_ret based BPF-THP hook
        https://lore.kernel.org/linux-mm/20250429024139.34365-1-laoar.shao@gmail.com/

RFC v2: struct_ops based BPF-THP hook
        https://lore.kernel.org/linux-mm/20250520060504.20251-1-laoar.shao@gmail.com/

RFC v4: Get THP order with interface get_suggested_order()
        https://lore.kernel.org/linux-mm/20250729091807.84310-1-laoar.shao@gmail.com/

v4->v9: Simplify the interface to:

        unsigned long
        bpf_hook_thp_get_orders(struct vm_area_struct *vma, enum tva_type type,
                                unsigned long orders);

        https://lore.kernel.org/linux-mm/20250930055826.9810-1-laoar.shao@gmail.com/

v9->RFC v10: Scope BPF-THP to individual processes
v10->v11:    Remove the RFC tag
v11->v12:    Fix issues reported by AI

The Design
==========

Scoping BPF-THP to cgroup is rejected
-------------------------------------

As explained by Gutierrez:

1. It breaks the cgroup hierarchy when 2 siblings have different THP policies
2. Cgroup was designed for resource management not for grouping processes and
   tune those processes
3. We set a precedent for other people adding new flags to cgroup and 
   potentially polluting cgroups. We may end up with cgroups having tens of
   different flags, making sysadmin's job more complex

The related links are: 

  https://lore.kernel.org/linux-mm/1940d681-94a6-48fb-b889-cd8f0b91b330@huawei-partners.com/
  https://lore.kernel.org/linux-mm/20241030150851.GB706616@cmpxchg.org/    

So we has to scope it to process.

Scoping BPF-THP to process
--------------------------

To eliminate potential conflicts among competing BPF-THP instances, we
enforce that each process is exclusively managed by a single BPF-THP. This
approach has received agreement from David. For context, see:

  https://lore.kernel.org/linux-mm/3577f7fd-429a-49c5-973b-38174a67be15@redhat.com/

When registering a BPF-THP, we specify the PID of a target task. The
BPF-THP is then installed in the task's `mm_struct`

  struct mm_struct {
      struct bpf_thp_ops __rcu *thp_thp;
  };

Inheritance Behavior:

- Existing child processes are unaffected
- Newly forked children inherit the BPF-THP from their parent
- The BPF-THP persists across exec

A new linked list tracks all tasks managed by each BPF-THP instance:

- Newly managed tasks are added to the list
- Exiting tasks are automatically removed from the list
- During BPF-THP unregistration (e.g., when the BPF link is removed), all
  managed tasks have their bpf_thp pointer set to NULL
- BPF-THP instances can be dynamically updated, with all tracked tasks
  automatically migrating to the new version.

This design simplifies BPF-THP management in production environments by
providing clear lifecycle management and preventing conflicts between
multiple BPF-THP instances.

Global Mode
-----------

The per-process BPF-THP mode is unsuitable for managing shared resources
such as shmem THP and file-backed THP. This aligns with known cgroup
limitations for similar scenarios:

  https://lore.kernel.org/linux-mm/YwNold0GMOappUxc@slm.duckdns.org/ 

Introduce a global BPF-THP mode to address this gap. When registered:
- All existing per-process instances are disabled
- New per-process registrations are blocked
- Existing per-process instances remain registered (no forced unregistration)

The global mode takes precedence over per-process instances. Updates are
type-isolated: global instances can only be updated by new global
instances, and per-process instances by new per-process instances.

BPF CI
------

Several dependency patches are currently in mm-new but haven't been merged
into bpf-next. To enable BPF CI testing, I had to make minor changes to
patches #1 and #2 and trigger the BPF CI manually. For details, see:

  https://github.com/kernel-patches/bpf/pull/10097

An error occurred during the test, but it was unrelated to this series.

Yafang Shao (10):
  mm: thp: remove vm_flags parameter from khugepaged_enter_vma()
  mm: thp: remove vm_flags parameter from thp_vma_allowable_order()
  mm: thp: add support for BPF based THP order selection
  mm: thp: decouple THP allocation between swap and page fault paths
  mm: thp: enable THP allocation exclusively through khugepaged
  mm: bpf-thp: add support for global mode
  Documentation: add BPF THP
  selftests/bpf: add a simple BPF based THP policy
  selftests/bpf: add test case to update THP policy
  selftests/bpf: add test case for BPF-THP inheritance across fork

 Documentation/admin-guide/mm/transhuge.rst    | 113 +++++
 MAINTAINERS                                   |   3 +
 fs/exec.c                                     |   1 +
 fs/proc/task_mmu.c                            |   3 +-
 include/linux/huge_mm.h                       |  58 ++-
 include/linux/khugepaged.h                    |  10 +-
 include/linux/mm_types.h                      |  17 +
 kernel/fork.c                                 |   1 +
 mm/Kconfig                                    |  24 +
 mm/Makefile                                   |   1 +
 mm/huge_memory.c                              |   7 +-
 mm/huge_memory_bpf.c                          | 423 ++++++++++++++++++
 mm/khugepaged.c                               |  43 +-
 mm/madvise.c                                  |   7 +
 mm/memory.c                                   |  22 +-
 mm/mmap.c                                     |   1 +
 mm/shmem.c                                    |   2 +-
 mm/vma.c                                      |   6 +-
 tools/testing/selftests/bpf/config            |   3 +
 .../selftests/bpf/prog_tests/thp_adjust.c     | 357 +++++++++++++++
 .../selftests/bpf/progs/test_thp_adjust.c     |  53 +++
 21 files changed, 1101 insertions(+), 54 deletions(-)
 create mode 100644 mm/huge_memory_bpf.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/thp_adjust.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_thp_adjust.c

-- 
2.47.3


