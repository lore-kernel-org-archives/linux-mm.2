Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 037BDD1266D
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 06:38:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2C7DD6B000D; Wed,  3 Dec 2025 01:38:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 277EF6B000E; Wed,  3 Dec 2025 01:38:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1673D6B0010; Wed,  3 Dec 2025 01:38:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 051156B000D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 01:38:45 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8562313B1B7
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:38:42 +0000 (UTC)
X-FDA: 84177206484.20.9607A51
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id C220040002
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:38:40 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jlCMvWxf;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764743920;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9S8oWWqtxvxhyq40CD0IJGBT9vC2Emq6MEZGdYkjVic=;
	b=Z2daWma0cS7Uyt1wI79yFZREEYingY1zF8CLZYwjljwX/BIbljmh4ZRGFI/a1+I+8e/Wei
	XBJYjszulDpBl/jrxvhfd7KZrZrXQeXHY35c6rGd+G5QsdiejIHtsMQbKh05qwmk6A/OR8
	rH2HHLkyr5sTCL/kPLk+vMuk4HWhNfg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764743920; a=rsa-sha256;
	cv=none;
	b=epXwG1crEmpWdYsAy/nfoUcglq5HZfFjD7lRA3qZX7+hGdoq4bKGLS+4BVPd3m/xudwvTD
	6yWXO/TVipuhhmk8d/RWBeQ/GjDnE8b4lbAX/RTehS/2N1mXpLe0+64yUNeiBae/78/NfV
	KPnFkreXV+3ZovGa2vLkYw0JJ/Pm+as=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=jlCMvWxf;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4eda6c385c0so50208331cf.3
        for <linux-mm@kvack.org>; Tue, 02 Dec 2025 22:38:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1764743919; x=1765348719; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=9S8oWWqtxvxhyq40CD0IJGBT9vC2Emq6MEZGdYkjVic=;
        b=jlCMvWxfKrBhpmxh5WdhwisBern2bRELNYqhq8D0sqHjHX1QOgzOoGkKaAqWarZVKJ
         tYVVoxXh8j/gdXzwSBhY9YcCO2apOOJA1RFrBjLMKpwjnHn2fAxj4TQDdnGVU6Zglrul
         OXqm+jCOleMQtw2B1ttEXwLSEqP/CJJR4nqAU4br4WDCDKDQvWxxlQDDfOWewKH5cT/R
         /33e1Gp9OpzMbpY1c7ueQB8YJWLhSq6uYiHPs6boc/kRNOjU7dk3IIsgmQ3msQ71/Jj8
         4WXPeeBts/SO+wz3+HHblyLVQs8+tL0yKd+FdnUGAbAyaSPdBdZ1GsU0iqUCY3B0U9dE
         56zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764743919; x=1765348719;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9S8oWWqtxvxhyq40CD0IJGBT9vC2Emq6MEZGdYkjVic=;
        b=qbKcnaDRqw70qpmcZz9pvQpn5WXQRWO8DFg8cjw8ZYMyUkefOTUjgthgOaqBVgG3BL
         +g1h5B5k77PISHPHbrfOk4rd9UDWivN6JOmLdEmmSpmFuGYhtuLuKTiyx6NEx/CRu/Yu
         d0BERLroA/RzX2ejpXuFPwuz3xilnjDvkiZxoteNE7upU6BXLA8p38AqfkflUtJrbB1A
         iUoqFfi+VGftgC0DBd0dpM97oH7/G21dNlPjHfW4NVqsXYjATh9Q250zYJLV0XerE0A5
         IK82GSThC2CNDHgAXVFJSXEaDeLliNqmJdGes+/8gqIWtiGkfLlsM2Tc1Jov1NM+wS1i
         eO6g==
X-Gm-Message-State: AOJu0YxZrauHF5seQjmjdh3QGm5xWwcas54iua26XoYD2XSt1vxZic9p
	Ox9d+yNv/NwxmRiW82bXwTseQGY87hrBBQ0+QiY/XApQUCVB2GwT0Fv8LLfVWo9f/PHX5LTKzRU
	nQ91r
X-Gm-Gg: ASbGncurTxADFeNr8tnJv8ZpB3voKyoBlP/3VF5we7J6OIt2YHANXhpF0PcKyoJpfUp
	KD/M2g2u5BB+85pyXjFYgzpKeZfjqAVj0PH6ljE01VdgZ30jV7swuL+0FW9LwP6nMXUeGeFz+yq
	T9MdwF4CMhJ3kQhixDcK7W2IbR4F/tcUprFPyiOuPREZjgFDeVaA4vGBjbYCB2sUCRnwoI+pcgU
	j786wbumgvcWWlQGzj5uNpfBMJGwOabJWfRMI+pcswAT073DPQx6exO4pJLQn43PdJVHyNO8ifm
	Kl2/gXYYPXra2GiRhzwQQBsX3hF4VgA+R6J2n9wCpw52fVigB3c/+BZGU9qUsyjbA4KhzPyyFR7
	AU3w295aOJrVsrzkNCmeLKcEyyhKQK0FKSlJ3eWabQCUPQ0h0oIXTP7LEvr9LjWz//lSgqkvt7/
	GGYWZs/cNIFqNo/34JvU9ZEA7JzWTv0RNT2VyvTPyXhkT3JYbDPKAWG3DllO4djMfOEywCoxLqP
	PErE8l2qZmO8Q==
X-Google-Smtp-Source: AGHT+IG2GsJDu1Gr867kRn/HsSoRcJfAe6D3mpSj1vgtxayK1qOVZUhW3MX+moExAjZkAMo5bpt1Hw==
X-Received: by 2002:ac8:5fce:0:b0:4ee:222b:660a with SMTP id d75a77b69052e-4f0177152ddmr18215391cf.76.1764743919621;
        Tue, 02 Dec 2025 22:38:39 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4efd2fd00c0sm109192511cf.13.2025.12.02.22.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Dec 2025 22:38:38 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	david@kernel.org,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	muchun.song@linux.dev,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH v3] mm, hugetlb: implement movable_gigantic_pages sysctl
Date: Wed,  3 Dec 2025 01:38:36 -0500
Message-ID: <20251203063836.187016-1-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: C220040002
X-Stat-Signature: o853n1oa6r61kuga3j9kda4urxoxzcph
X-Rspam-User: 
X-HE-Tag: 1764743920-540972
X-HE-Meta: U2FsdGVkX1+Fn5S6c5Ks7Mfm1hG8LtM3MjRSXRwoyBWUQaFzezczeyOh0TldAGzUXXxCy3Tl7pDg2Nsq362PhzVqbsvTSlUVWDqTO33vJ5AxeYsACmIdeVymd4YEobfGkx0gvE+QRntQjFtdHnsRhVgS55C1NtiTvNXkSjAvaLLUcbDHA1OZUtXhtwpeB5SUIFQ80M6TRkILXSTn+ONpzu6wj5Qq7GW64FOin9vHQ52KoTuus+cg4nd2ODg7Yaz/YYCi1efFm/vHbePQ9dQLKwAy/gFCvzNGUMfITn5SA3yTTYhGXcEL2JvsVQZpeTffrDF97a4SoJD/OYzE23IZ3ucJQMu6wEJWHaN90b9Ibl/46ruK3FAKacXYAe7IbhPQPQSKhAWGNmqOKEqN3oRzxKJRAIure3UDmjizI0nJarj1EWtDxQddYg5aiixOaQGj5gKmqYG6czAQDy9dkguNnIJ/fIVIiXPPjt1uz4G1t86gpqeTVUH+7AHEYGQekiBys8eWpJAUk1JKMpvwdihpJmn6MvguE9ftZvfZi1o/UzX2aMa0o7z+92YiykoBg5V0cfBRgFHd4DlGhaeiXcOKLSHHovAUfRAzYDZQd8Rf7eIQRv9cE85nNzj9RlGFA/NDG/MD/e1jTXR8FtNLK2KANLomf2N+6S0SgXeiyJ3Azr5goS/7eYuCm2gtuEFT0OzMqsDxFW+S+Kr1o2/i9adihMm0QwVHRIUXIrV9UdHQWn6FAEMwU+tqooUkYMuonQCqvbMD4U0pAj77RzL7jt4Pvmk16r0ejxUzgZQF7g+VjYjnomNbpyDxJkhqimMdzrh2O3qJlHc1ZwwnjVLIHieqg3VRiik+wTvvbuCzrHbXd+EN0tFDojBX2y1XPqGI9ZA9HKo7x7w/m5n3HHHb00kr+V0y29UVuuMkAv2kJhjXkIMOyhYSjxDkfZw7wb9GzufLxeKlNv5Fp/gBmnR7OQq
 CwOQAEpG
 Q7pQasnWBlWtLISkSYeuR3qBmgdV99dJj2Br4JQav6ys0p2zgHJK2svZYER16Jp95vAXWFlRgPMz4sy+heC2Tak5RHAfN2CYhzRbWcbtZmk4Lv8ZZ610dOXZp3FNB8NBp04GAkVBXLduvG3kj0SVemaAlraHqj95i1uk8g+KnffQx1tfIYm/a5iAvE/L5ttK8wiZszWsioJeVWN327qxeKOGy4+NSp/2HLYY/0v0lxLuEXBOWLS+4icFdfFYF+jE+V6GmhKaiAX/GkcfeqaBiynfVyjfzFLuwwPWwjuoKxj77LHUDTwoYtACVi/9orQgtmyHQSXW/8abWmJGkabyqZBtXCig0QAJyjqvZa234Fw4LCaW4qjjouFKAO2TnXt4xLqFVnuYDhwGrcKZvjulFGiCu+lqIEYPfaXqxI9tWhs43XmNXyOo5ezYQ/yplcAliHQhRQ+TlDKkenMgrndcTdnLbV+QudYvwAcPlG+mMChBpC4L9UI9PrDYbR2OnwjN6ZvHQUFHOYEUogKpLci0zRmuTDIpB+yLiskGAvuH6vVOmgXubDnvEh1dpRx9c3nxc4KrqkWuBius/0zLkDp+p5AvcLQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reintroduces a concept removed by:
commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")

This sysctl provides flexibility between ZONE_MOVABLE use cases:
1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
2) onlining memory in ZONE_MOVABLE to make hugepage allocate reliable

When ZONE_MOVABLE is used to make huge page allocation more reliable,
disallowing gigantic pages memory in this region is pointless.  If
hotplug is not a requirement, we can loosen the restrictions to allow
1GB gigantic pages in ZONE_MOVABLE.

Since 1GB can be difficult to migrate / has impacts on compaction /
defragmentation, we don't enable this by default. Notably, 1GB pages
can only be migrated if another 1GB page is available - so hot-unplug
will fail if such a page cannot be found.

However, since there are scenarios where gigantic pages are migratable,
we should allow use of these on movable regions.

Note: Boot-time CMA is not possible for driver-managed hotplug memory,
as CMA requires the memory to be registered as SystemRAM at boot time.
Additionally, 1GB huge pages are not supported by THP.

Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alexandru Moise <00moses.alexander00@gmail.com>
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
---
 Documentation/admin-guide/mm/memory-hotplug.rst | 14 ++++++++++++--
 Documentation/admin-guide/sysctl/vm.rst         | 17 +++++++++++++++++
 include/linux/hugetlb.h                         |  3 ++-
 mm/hugetlb.c                                    |  1 -
 mm/hugetlb_sysctl.c                             |  9 +++++++++
 5 files changed, 40 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/memory-hotplug.rst b/Documentation/admin-guide/mm/memory-hotplug.rst
index 33c886f3d198..6581558fd0d7 100644
--- a/Documentation/admin-guide/mm/memory-hotplug.rst
+++ b/Documentation/admin-guide/mm/memory-hotplug.rst
@@ -612,8 +612,9 @@ ZONE_MOVABLE, especially when fine-tuning zone ratios:
   allocations and silently create a zone imbalance, usually triggered by
   inflation requests from the hypervisor.
 
-- Gigantic pages are unmovable, resulting in user space consuming a
-  lot of unmovable memory.
+- Gigantic pages are unmovable when an architecture does not support
+  huge page migration and/or the ``movable_gigantic_pages`` sysctl is false.
+  See Documentation/admin-guide/sysctl/vm.rst for more info on this sysctl.
 
 - Huge pages are unmovable when an architectures does not support huge
   page migration, resulting in a similar issue as with gigantic pages.
@@ -672,6 +673,15 @@ block might fail:
 - Concurrent activity that operates on the same physical memory area, such as
   allocating gigantic pages, can result in temporary offlining failures.
 
+- When an admin sets the ``movable_gigantic_pages`` sysctl to true, gigantic
+  pages are allowed in ZONE_MOVABLE.  This only allows migratable gigantic
+  pages to be allocated; however, if there are no eligible destination gigantic
+  pages at offline, the offlining operation will fail.
+
+  Users leveraging ``movable_gigantic_pages`` should weigh the value of
+  ZONE_MOVABLE for increasing the reliability of gigantic page allocation
+  against the potential loss of hot-unplug reliability.
+
 - Out of memory when dissolving huge pages, especially when HugeTLB Vmemmap
   Optimization (HVO) is enabled.
 
diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 4d71211fdad8..36a390c0561e 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -54,6 +54,7 @@ Currently, these files are in /proc/sys/vm:
 - mmap_min_addr
 - mmap_rnd_bits
 - mmap_rnd_compat_bits
+- movable_gigantic_pages
 - nr_hugepages
 - nr_hugepages_mempolicy
 - nr_overcommit_hugepages
@@ -624,6 +625,22 @@ This value can be changed after boot using the
 /proc/sys/vm/mmap_rnd_compat_bits tunable
 
 
+movable_gigantic_pages
+======================
+
+This parameter controls whether gigantic pages may be allocated from
+ZONE_MOVABLE. If set to non-zero, gigantic pages can be allocated
+from ZONE_MOVABLE. ZONE_MOVABLE memory may be created via the kernel
+boot parameter `kernelcore` or via memory hotplug as discussed in
+Documentation/admin-guide/mm/memory-hotplug.rst.
+
+Support may depend on specific architecture.
+
+Note that using ZONE_MOVABLE gigantic pages may make features like
+memory hotremove more unreliable, as migrating gigantic pages is more
+difficult due to needing larger amounts of physically contiguous memory.
+
+
 nr_hugepages
 ============
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 019a1c5281e4..5c190b22108e 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -171,6 +171,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
+extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group __read_mostly;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
@@ -924,7 +925,7 @@ static inline bool hugepage_movable_supported(struct hstate *h)
 	if (!hugepage_migration_supported(h))
 		return false;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !movable_gigantic_pages)
 		return false;
 	return true;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 9e7815b4f058..084d45d5311d 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -49,7 +49,6 @@
 #include "internal.h"
 #include "hugetlb_vmemmap.h"
 #include "hugetlb_cma.h"
-#include "hugetlb_internal.h"
 #include <linux/page-isolation.h>
 
 int hugetlb_max_hstate __read_mostly;
diff --git a/mm/hugetlb_sysctl.c b/mm/hugetlb_sysctl.c
index bd3077150542..22a9e15e534f 100644
--- a/mm/hugetlb_sysctl.c
+++ b/mm/hugetlb_sysctl.c
@@ -125,6 +125,15 @@ static const struct ctl_table hugetlb_table[] = {
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
 	},
+#ifdef CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
+	{
+		.procname	= "movable_gigantic_pages",
+		.data		= &movable_gigantic_pages,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
+#endif
 };
 
 void __init hugetlb_sysctl_init(void)
-- 
2.52.0


