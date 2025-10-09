Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA57ACCD183
	for <linux-mm@archiver.kernel.org>; Thu,  9 Oct 2025 16:15:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1955B8E009C; Thu,  9 Oct 2025 12:15:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16C758E009B; Thu,  9 Oct 2025 12:15:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 05B358E009C; Thu,  9 Oct 2025 12:15:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E85B68E009B
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 12:15:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 83F86C0A38
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:15:24 +0000 (UTC)
X-FDA: 83979075768.28.D9945E2
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf07.hostedemail.com (Postfix) with ESMTP id 8ED954001A
	for <linux-mm@kvack.org>; Thu,  9 Oct 2025 16:15:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UqdDf3l+;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760026522; a=rsa-sha256;
	cv=none;
	b=kNm9kPVwUHrD+TJFE3bUhyQG7UdXaGy0FppiIm/D1ojJ5JAljBmGN5xupmc1qYEizczZWP
	sNeVMkqCoqnp2gNz5HJ/2l9tlgfGMlu3yh/bmfKg5D/BY1uRpbLZY/xZGkOFsnWbA2fK6C
	slmKtONCdfuw+cww85ng7nnIf7u0C3A=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=UqdDf3l+;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760026522;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=1+5SvdqRqDaLVpZovzo/tjgIBi731xvYHaxEt2u52vI=;
	b=kA610zt8pVxydCuqbb2Kfg+yDXWoJSKlqfuchwt8jLTRa2nifU56HH/CqqMoa/T2sv9eIX
	gA5YAujI8zuu1pZWzZqi/kJOASH9f1fazOUYeKXjN5WKM1kofT3r+gLLaHxv00T9MztdQw
	r/zwe3UQjcqVnMY4KPZX3URvt5bPwX0=
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-856222505eeso116051785a.1
        for <linux-mm@kvack.org>; Thu, 09 Oct 2025 09:15:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760026521; x=1760631321; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=1+5SvdqRqDaLVpZovzo/tjgIBi731xvYHaxEt2u52vI=;
        b=UqdDf3l+B+gIaEYJllNNnIt5I7zVhiOYwqrgrJgLuvX0plqt/Cd12MaPGk7mE32Hnk
         AcKSAsmd4fkpHFqDLhBK39MpeOunA/OmDEUo6H3+7Bkl5U1skbxOwVgnUpqVr4yUCtj5
         qQiBkTVnEmM9RMuH5/MKDP6WzPjvVRpSvsh+rILAwivmOroZOYPcBMASNlQwQ/9iv210
         K6r3c3wXNAv8gVVGvSpnv++2IoE839Mcca9zj4PaMkGd2ePUOsEnruc9jgLEmkrG2uhd
         u4NyOIf9XhiQ8sIz4aHsXfXnw3h2TWoj9hzuWK5gRMkbuc7USYkzhdqS1CmrxWMtOIrZ
         +P6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760026521; x=1760631321;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1+5SvdqRqDaLVpZovzo/tjgIBi731xvYHaxEt2u52vI=;
        b=MftdipuWuSZFokBcqGsSzkfs7jE4T6Eb5NlrRsCGpaSVkhfk0vsmKyqpifSc11SWhP
         6K491A+QJ/xsKSVaV1mmOjnuEZz5JeWFPzp423i6SAidG4v/REw1O/5tfBB7KRqnnPnR
         BDgEW0yZ9SOFrt2F/yiYk+qkIKGXwWBHK+tAQaPz9P80P9NcwRbZP2PE9XG3X3B2brI8
         i3YdEJroY5CYuc/AZ1Z1Ul4NJ/L4bVKrzoRFNsGMvke3nxWUKQ9Ug2Vz77/NYKs6UtRV
         Q5mN6pse5WpaFN90N+kw6xU8FoMnTGYk545sq7XQ+n8dEFPxoTicA/Nw+ZmR2bAAhVf1
         QX1w==
X-Gm-Message-State: AOJu0YzqvUNAyidW+Ko7NThxKUBvFLe4j3N0rL3aJUwH/Mg0ia2dcNDQ
	K9MnIi48iJtkILyUmnJ8wgkVFrJAmuOf3EaMAp1s3mrZWlTQxdpajDanFuvFUTmBgWzQ8gXfgQV
	Ilhof
X-Gm-Gg: ASbGncu0Nxlaj7Z/UW0OVLm6RZE3yj3BHZLmRsQC+Gl8gextXshgjtdSI1/YylmSfAY
	7mFiPQ59i+xyCvJGxaNWHf9JsYPCrFG2yA9rYnEIE6Q5E6wN0c1Bfw+P5F+Gd8RV7gfPgXg2rJa
	+CtNnVR2TYh6OZTH5wFde9Arnvu/MraZFj4Eaq+y3m2bmN1ZCWgXpPd0Vv7SWxarZoZR3qF7f5s
	bevqCZZy1xwehKPpwvoU/p9na4LE19kQ6yaw9cajmxSP/rN7RxUgs0ztC3K1AcyH/OozuhVrhFf
	vCxRcKx/YvKfNsoiWhUvPvWLrAk1BRbdv6aVzPrkLqS7qsdKYjdy3fnXVZP/cepxsKPWetA1ZAd
	MceLXkvXHo0Sthe0ws2cRHTDZ3QLNRkGOrzddsIGXIKgPwAfAWNIG6IwsPse2Ff1QW3e4sV7blO
	J8PWYbQa6xGmqBXgwJl4EU0hf2XfC9wzZPAnNCyhXqkIk84Q==
X-Google-Smtp-Source: AGHT+IEj2zy9apxWY9vObYs3hv/JmdQttOhxDDHvUjAsMStwiARm4lbIvINlMgC2GhXAwwntSoBprQ==
X-Received: by 2002:a05:620a:bd5:b0:870:90ff:90d with SMTP id af79cd13be357-883533693admr1130340185a.8.1760026520890;
        Thu, 09 Oct 2025 09:15:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8849f2e2098sm224285685a.13.2025.10.09.09.15.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Oct 2025 09:15:20 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: corbet@lwn.net,
	muchun.song@linux.dev,
	osalvador@suse.de,
	david@redhat.com,
	akpm@linux-foundation.org,
	hannes@cmpxchg.org,
	laoar.shao@gmail.com,
	gourry@gourry.net,
	mclapinski@google.com,
	joel.granados@kernel.org,
	jack@suse.cz,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: [RFC PATCH] mm, hugetlb: implement movable_gigantic_pages sysctl
Date: Thu,  9 Oct 2025 12:15:15 -0400
Message-ID: <20251009161515.422292-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: in4ujy1rg4hpsa5xxa9uti3uypyohx1q
X-Rspamd-Queue-Id: 8ED954001A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760026522-443529
X-HE-Meta: U2FsdGVkX1+wBL2PEJQYmx7OuV5DEdeLS/hfhze8bihNEH/ivEblue2Xkkmd8r2H34OAFkkobhYqQrpodtYy5v7D2QZgWTggGnBnrrylvtUc2zZrZaGl3CoQ6pSut8P4KDFpQtm2HD6tgnjddzcH73aUBY9MlZeZQApmi9YzehiE/LPD1/GdWtnNolp9ZKRzWopNmIzsuiajywlVzWhwZGl4XAsgukQKq9aFGulECPGbhuSKop7NNl5+hp57cGbkakYD68+WLKCwUvZYHBNp9X+kS2OaamQ06vQSOOdAswYPECp4OqIIwWO9Ir8AmcDt6ZU3gn7gEMW4+8wDShb5Lg31MdsQitw41+D/CDFLKEkGEFaChGeqdQCDX91C/PwrA1fBd19gW6PIdpxUG0W887sXHoLhHt1oX3L4Wu7DIaYz0flsOTfZ7CSdzzLq46eerzQYt93heAA29SfVdwRnt9PFFe1qQ8aqdkJkEQV3WCgGEPsA9JOxzV16Vw4EozpFHIM/0Z3B+hU/xtl4EA7izGxpSVslD8hbHWukt1DzVI+CrGj9K0HNgRSL9gBOATJmd+HHAcexX56jpd5KG2ezYdK2Hpj01zZc3Fbt62swogfMvCDQnEE+/QcJ6Caz62h5pMAv1df2Rl8DGLs6wsS47TAaMYACvXZyO2k22c2iCmX6LDYN2w6QkDXSplWbsRqy4hOwFffqDPczDdRj79D9kmIDkfRo/lKmVNf2tqINMfbKBNl15Oo2Ndsbnk3udEpqTuTWd60P08pVnlOMe1kM/pOISGl9cQL1p09oXOTzbqZNDkZ08UUXsFGOy6S5n5b/FjkflcexhPKGQRorTiJiYL5C0NkSnfgGtU3whfbekL6y2MY2M8kkCZ4i+zDdz7gbtmZGWuBfiJl8XGgsZKW2SksncgJn3aVh1oUmJCMKRFvPp7uj5ibxeEaUr+s9DIHmZm90YlZ4rx4s+4uUug0
 M7sQb4xQ
 coqdeZbwOO6Ah/bCxBd6Y2EGjdl5S4yRM9eWlPbNWVrgUy/KG6KybRbKk/nb/qH9zQAAiu8NX+9WQYGOkmEXhvpNPZG42Jv2BdbpUbekWxpf4GEkr/rhhLmX11npm4gFLzMFlmFQDUL6keeSgnJEMeSSr+MCT3XSvcMNld11kpn7ybSn3k/9hP1LU1VBIp4ehh6ro37Xc8U3mCo/qKqU/3G+1I4v7yMgzaKy5YlwCL21NcAgT056H0Q67uHkcVE/p+5E/LkWWD1CMDcVRyRO3UIwcARCvcOQ3ceztBlepdkK5sobu0QZqNc5tdT8NcsWgv+JGfCH0nIOTuobDM+IcNQis6rp61a6A1432FmKY+hgSCuFPEkJ81aKWmEqKorWuHi+lP1RJpRNRHlWAT/VRJis2J5uG08c3Wg5qFnMwdHCNvWlWRFa23PlgVfL1b4ys7LGOsUAW8Sjo3BVyOYNusgWsNwC9VYaPT6lLB5Eoy+V9Zl1nMBTGT1ZzlLf4bDe8D59J1tUWz8CghnZQ7awdUAnWVObqWFlHm4RAasUihfZ6x1+HaaIwHVLuwL9j16GKZCnsIDir3/XQCArOcpvC0k+ULezKLTixREspeY1kTfQFn08eVJNa6Yj/VmcVX+HBTNHB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reintroduces a concept removed by
commit d6cb41cc44c6 ("mm, hugetlb: remove hugepages_treat_as_movable sysctl")

This sysctl provides some flexibility between multiple requirements which
are difficult to square without adding significantly more complexity.

1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
2) onlining memory in ZONE_MOVABLE to increase reliability of hugepage
   allocation.

When the user's intent for ZONE_MOVABLE is to allow more reliable huge
page allocation (as opposed to enabling hotplugability), disallowing 1GB
hugepages in this region this region is pointless.  So if hotplug is not
a requirement, we can loosen the restrictions to allow 1GB gigantic pages
in ZONE_MOVABLE.

Since 1GB can be difficult to migrate / has impacts on compaction /
defragmentation, we don't enable this by default.  However, since there
are scenarios where gigantic pages are migratable (hugetlb available in
multiple places), we should allow use of these on zone movable regions.

Note: Boot-time CMA is not possible for driver-managed hotplug memory,
as CMA requires the memory to be registered as SystemRAM at boot time.

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

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 4d71211fdad8..89dcee3c3239 100644
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
index 526d27e88b3b..38870d21724a 100644
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
index 753f99b4c718..24dbd30d1b69 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "hugetlb_cma.h"
 #include <linux/page-isolation.h>
 
+int movable_gigantic_pages;
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -5195,6 +5197,15 @@ static const struct ctl_table hugetlb_table[] = {
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
2.51.0


