Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71562CFC29A
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 19:28:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFB146B00A6; Fri, 21 Nov 2025 14:28:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD3B26B00A8; Fri, 21 Nov 2025 14:28:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BEA526B00A9; Fri, 21 Nov 2025 14:28:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A88B66B00A6
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 14:28:14 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7467AC06F5
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:28:14 +0000 (UTC)
X-FDA: 84135600108.15.41FC94A
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf06.hostedemail.com (Postfix) with ESMTP id B0771180002
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 19:28:12 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bZbSYwZv;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763753292;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RmkDvjDU7TRVcLAaWRGk7ehFgQyf069RSfjz3jOooEk=;
	b=7BfMIp9b5OBOsy6eMD2GVUWNw4zX4KqIukv+fc9/vPj5g+jt/udmTo4hvW+7SXJLWaUlBp
	dW+ivpxjwac6Dduvb+sLpwH4bfPn2XgztV7Kkc3ThviPu4fEBQZQMtOqqU1DaRQQ4+hJGc
	3ykpBIVrV2tZMd406Q2jhlLTTVu16VM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=bZbSYwZv;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763753292; a=rsa-sha256;
	cv=none;
	b=Yep9Sx0jzFv3Wk2cjTRoDAI42raZbtYMdorJdJ/egkHOKSOYHkoMdfe1L5GEsvS6pkSE+a
	WsAStnlODO4dwwCz43QeYx67ymO9hKAgLNspsZAdP1oy3/CELLUtgc5zRX7JFA66JEqFQy
	RjsCXUrzCmykGzD1kuuZRbiI/6sWorY=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b144ec3aa8so225477285a.2
        for <linux-mm@kvack.org>; Fri, 21 Nov 2025 11:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1763753291; x=1764358091; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RmkDvjDU7TRVcLAaWRGk7ehFgQyf069RSfjz3jOooEk=;
        b=bZbSYwZveq7xe/dcwvo6gEgziuczuDJsBPAXNjQ3+MC3b3rdOd4p1USxpMJDUaoDly
         W5ntzoOWj95W/ovs9TtMehecBPph5aKNCq1NW3ENOljfxlrZS6JfbSFE7LBMUdWS3bK4
         yH3fFccpCHMA8/0CGAJyd0sZtGKglRKE4YxfDMoAHDiLyHlKw7V7mFuHOg9PciUjvItK
         Vt6dA8uQD0QBj7vySE9GNNVSJJXOFJEQTsv6QkRdnjox1TC2Ep2Oqo1slqT5ycKQlAZQ
         kcryzmrOwP+NiiV8bNYlLz3cdd2PlaDKHL8ox7qCiHnkLZ4IrvSt/49U0htGVp/3raFh
         Mfkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763753291; x=1764358091;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RmkDvjDU7TRVcLAaWRGk7ehFgQyf069RSfjz3jOooEk=;
        b=O7MuJm5SNERvl2h+pDAr2WGOLocyNBD2tuhDOuBf54J2bMX9IRAmrEA+l6YEX+jmsy
         mSVob3YpnxhN2a9K8v7qYPFN0U6ZInRDYQykfoRLb2zsFcV8TRDKpiw63RUVoJsaSS+7
         WKJp9Ozi/pBpEtYbeXCnNDuftCfoIoGgVXTlUWdDyRBzkuh5suIWt2ov8LgkMoLhl/se
         h/zSUnxhm/N1q3zenCHrYH1XZkQExSwZ6v9eD93RP0X47UdHaQN53sFUZeA7NoSsTO6n
         Bmx7MCO7rGP3C/ufbM40mxIRHAsTdgKcQInRXzMx2YIHLALfpJu79AQjvZp+arNL1QcW
         6W3Q==
X-Gm-Message-State: AOJu0YwHOFbwV94MPEpWOYjGxix6XDW5xajb7W5DQp8fY3oF0kgvyMtl
	/hSjMSgv0omjmfdSfRSbiHqOKvXNlMpfhAYAi6c6Ruxs6j38MEuNMgm7Vx2vuYmP+BCHgnfXeaN
	1Vfj+
X-Gm-Gg: ASbGncuZwaJLuchpwKCI22sWBuiolV2APbdAgNCwi5uRQlAja4qavv/1fS7y2rqpk61
	CIoK9AX4hl1cKvf6pUetfl4My6L75+AOM1QsvLI6NxdQLDxk3POKnIZlAdbCRKbZAvaZGdCm+Pm
	+SHsTkey+EeRqarHYuUEqmcSVESGcPQ6Z30WN/gWdoe2MzhYQ9crnEgyrLBfkhrAqa/ELhOeIa2
	dryxW3gTrG9oWBRMxsXkygFH+h68Os6y74fGPJLq3/cpZkoxacBwAMJphHJ+1EuP9+26b58KcIB
	Sx6v+QFppA2wtRn2LBiD+MUAJNX2X9MO/FdZOTBW4Th1AfL0wxCD+XDMyNi3F84xkWNy04l3rC6
	VBEOmTccdsFF5bjFJgqCv/ksLo4iCthRCLH0EdBzlWY1yUJrMQBMGyISa0rc0JXA/cHn5+Kesaa
	yiASaSuQGDnQnHYQKx9JQqFfTmyBIeESdMObJNCw5AXpSwKVIabFISCZWCn0oz9lLpJAdbip6Fy
	Bs=
X-Google-Smtp-Source: AGHT+IGOwz+Ob3Ojd8jzT+Htqg0f5uBZ2/mLq7SGDY02ShxixMShiy5UBT0QeyT32i05L1pHTAu4Ew==
X-Received: by 2002:a05:620a:46a0:b0:8b2:6a4f:ba70 with SMTP id af79cd13be357-8b33d46a386mr406791385a.76.1763753291490;
        Fri, 21 Nov 2025 11:28:11 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b3295ef333sm423134485a.49.2025.11.21.11.28.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Nov 2025 11:28:10 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	akpm@linux-foundation.org
Cc: kernel-team@meta.com,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	linux-kernel@vger.kernel.org,
	David Hildenbrand <david@redhat.com>,
	Mel Gorman <mgorman@suse.de>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH v2] mm, hugetlb: implement movable_gigantic_pages sysctl
Date: Fri, 21 Nov 2025 14:27:46 -0500
Message-ID: <20251121192746.256051-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B0771180002
X-Stat-Signature: edzmq3t7njunz9z6xapa89buxarekpbw
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763753292-114053
X-HE-Meta: U2FsdGVkX18HYnkgDGehVJre250sQ4qt4kjGCphHP2M4UHdhS6h56T1fdHZl80Vqi9HqE0q6WUwupTwVArEgHBsOPIEoKXgg4JfLqly34T9K27TWJBGz9/ti/4h5OG+2Dup2b65nbojRzsWaIn60m3N3sxvohKj+FFb4r2ESiSsVwnYxbY1medAJDv7uPfJMWT05ov5BM54Jfx9+26kbnl7OehiGJVIUTeNeXEyu1Wzq8OX+l9RyGaSNwv/ehxZ7W9rtMBn6eTJwaOw/QAMy2usRFCPaTmb1TPFKxtk/FT3w7HacFexnZ9VPCjX/ZamYbiU0f80qRkh20tPGLUpEckdG0OdVN4TtS3BkFq1C7dhuWaur0S2tXaGIf0QyPYnQWFE+S+JYKHPMltFKf0azePV6ZQ/ezBZxIsWL8shMersgM8a+ebDTH6GU0rwjIgZrTzdvhDEE3ZT7XVcFvECXMPGixMfgjWjIk1zExobnnnZLoVzzh5wpxWaIBll9J2k9Q5VmVzsoAN75sBgki+bm9aMCvAoGoN7bdPIkJpf3bWRRk4Qpb1n6uRYJLtr6JdAAp1xXHvakNFZG1WwT01TSGuKwr88ZOF51AWvPpZdE5Pa3UeSUmySQlE/G7zolXJzq+y9pX2wLzjG1A9A0QXBMVYrCUilm9QVO9Ty/YlvjaQkhsxLzoZFlePXcE80Fv1DCBEXu5VPClmMzZ7MXcXO31Kwu1qjocpiWEQdszrOh0crZM9zC65ngFFr6XRKCHsQ2r/8WNmNf+FHySAAApZqngJZ9DQ4TRWrf4db3/7YKGayWVNVjATI2i9R3Z3KDiK7aUWi7HypWLFS9juYxssdwz0YHmTZMzPuas+BdiGFARHTNfeoGq49WGm5yWPWCWavrjRz+5d7FJX81duJ9KZyu61z3tseuHVfhkW1OSdWDBYSUGjxWK97dYgtC+7n7Tui65qhtfFnd55NM4rWln6c
 9igtfAEK
 HfXjnKzQhtU3dTT/4EQT+k4Ks1jjfcYAtZdc1N+Q/fLMT0G7/6WiTvrTuSqB2eqrKuPYmaLByvV1D8KE5uRCCG55XDRtheLSdN6lrLu7my7nuk39hy+aJfm5jsZW7SPNsdf/WoYNZjhFHN2tlFcMR65MYCd5LEHuILz8G8xCALNm2lquX4lZMjk0lSTaAIsmV9uoV8UwIOdR0JX/w5TT5LwjN3fCg+gzj4NM1BzrR+VIBGQ4ZaNT/cg8yBAbNBa/Rpk9UJjbJxDurLWlMYVEVUMDR8+6JjdU1ak0A6A6jecUAGco4ba94hIyMT4E1KJzLeovWrnIhx0iZTD9fu6ax9hJ1zKrB+0+XgI609nU5ThmbzVNkQzFeQHyafjubDXj+syT0uh3/WwXCA/qBj/HPkkFyjXW+Hvs4EXB5fBRjjhd3HMANmpiGhrrSzph0FuMuZJcejodbZKx/Y0DrZpda5WtpoSbXSv5Asnn5XTewiIfJDmLZQVVTXtPuU602Ph1uzEOtZKQ4j7jgu3M3W1KgLuGT839Mi3Z5HnzPjQepo8jNBJzZI3gzJrRjpiHJM/86xT6WDcXfO2K629XIb/Hy3ziTVw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reintroduces a concept removed by 
commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")

This sysctl provides some flexibility between multiple ZONE_MOVABLE
use cases

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
 Documentation/admin-guide/sysctl/vm.rst | 17 +++++++++++++++++
 include/linux/hugetlb.h                 |  3 ++-
 mm/hugetlb.c                            | 11 +++++++++++
 3 files changed, 30 insertions(+), 1 deletion(-)

---
v2: changelog updates


diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index b325bfbc2611..fe3982604b1f 100644
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
@@ -623,6 +624,22 @@ This value can be changed after boot using the
 /proc/sys/vm/mmap_rnd_compat_bits tunable
 
 
+movable_gigantic_pages
+======================
+
+This parameter controls whether gigantic pages may be allocated from
+ZONE_MOVABLE. If set to non-zero, gigantic hugepages can be allocated
+from ZONE_MOVABLE. ZONE_MOVABLE memory may be created via the kernel
+boot parameter `kernelcore` or via memory hotplug as discussed in
+Documentation/admin-guide/mm/memory-hotplug.rst.
+
+Support may depend on specific architecture.
+
+Note that using ZONE_MOVABLE gigantic pages may make features like
+memory hotremove more unreliable, as migrating gigantic pages is more
+difficult due to needing larger amounts of phyiscally contiguous memory.
+
+
 nr_hugepages
 ============
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index eb21619206af..451ede7b97dd 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -172,6 +172,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
+extern int movable_gigantic_pages __read_mostly;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
@@ -916,7 +917,7 @@ static inline bool hugepage_movable_supported(struct hstate *h)
 	if (!hugepage_migration_supported(h))
 		return false;
 
-	if (hstate_is_gigantic(h))
+	if (hstate_is_gigantic(h) && !movable_gigantic_pages)
 		return false;
 	return true;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 5b77fef5c4fd..c6363dad1e92 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -54,6 +54,8 @@
 #include "hugetlb_cma.h"
 #include <linux/page-isolation.h>
 
+int movable_gigantic_pages;
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -5208,6 +5210,15 @@ static const struct ctl_table hugetlb_table[] = {
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
 
 static void __init hugetlb_sysctl_init(void)
-- 
2.51.1


