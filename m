Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BE0ACCA476
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 21:44:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 939AC8E0003; Tue,  7 Oct 2025 17:44:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EAE28E0002; Tue,  7 Oct 2025 17:44:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D9458E0003; Tue,  7 Oct 2025 17:44:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9098E0002
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 17:44:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CF371B8394
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:44:22 +0000 (UTC)
X-FDA: 83972647164.26.7BC2E66
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 14977C000C
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 21:44:20 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fc3JIDxK;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759873461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=vZ6FNVlq5hGhSL7hTDiUZ66uQN+FQVKqg+d4ewOqZ7w=;
	b=Bnqx9q5Y9R/BJ+9fB9Kp13gs0DsO0KiAR5DtQw0+Xlh/Qz04vCWzH2J5latKHfzF5sBc8F
	mQyGZ91uETBtmQ/2bEP5pmjzRuKtDWGBNEwnsHh+WlImttmNBpzt/Aw4I/bIJBTJZUdMdK
	HUXfGiHQ3IqgGL9OuJl/20pMsZOjR1k=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fc3JIDxK;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759873461; a=rsa-sha256;
	cv=none;
	b=D2QM1r9hh4+ItZtD0PnPXVy0UrLv43MKDzOlv0pwh9VQRW+IUuesYGwGIybJ49B14jKuZa
	T1ngZ5E5Mv3/e57ODJgrSne8/8niapYf0/RBykIrkbpSM3ZTyb7Zo9ydTZe3B9MZ2g2cnS
	L+5mQd8aGNMEiQ9F/8T3VmRHzrUpppw=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-86420079b01so713668785a.1
        for <linux-mm@kvack.org>; Tue, 07 Oct 2025 14:44:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1759873460; x=1760478260; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=vZ6FNVlq5hGhSL7hTDiUZ66uQN+FQVKqg+d4ewOqZ7w=;
        b=fc3JIDxK6TO5pbV+aZVkNzEom0Ub2IC5sNL7LCA36GQE3+y4kyDyHn1z/BytDV52uO
         rmtGo5J07iREfhBDn1fu7cvAqarOsIdqvDfWSj/RHTZPQoZWtuhfBQAMu4cM1MOINyhN
         W/8In5CMajdpUIi6uUasVskkVxYWyAaFgAhSXf46J64JdJCSb/dINyEVvSd+abEc7tJI
         RNVzrqP8kXK6w1YR3E+0Ox/D9GUf7RXQzG7NBAD8ak76vS25ESOLW7GRPWk+NfE62LhX
         EgmBkHIvpS8VcmDCSZpwHctbJ/hSGwZl80tvga6EROkP7W+znLLWgCRuxDdaXvB/9HRV
         CQyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759873460; x=1760478260;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vZ6FNVlq5hGhSL7hTDiUZ66uQN+FQVKqg+d4ewOqZ7w=;
        b=jR2NfdqENG/RXJfNYgJz0YbkEPyDprji3firqCXqe0WUIsA7mbMow5F/d1Ru+YXfnl
         sP0Qpf2/VTkXgIu57bKF1zZF0eZh5vZdh+Y2oB4MdU5N0I474P1O88F1YCyUw9XwxmGG
         MDHQJkXMPZqMuX4CJ9YgtNUKnYcaTv9qDarr9DUralHtbONJajlINjZ60SkIlINUy8Cx
         kreAuLJcLhtilQWlaaZrhFcx1Fc7mj0g6KrLm5VEejDHCtFhxWYv24hkWMexCWC1x6QS
         s42+pwcd0loQYmidl9LvtIjmj30tn+SS5JnCct8ukCc/bhch/WepK1g286oAgICSD2xZ
         4Vzw==
X-Gm-Message-State: AOJu0YyVy4gDO/tgHtB5ynzL+Hqn2CJYE27PDEMw/lohAxGUIKjtiJQ4
	RLSlmxyEfadBE5YwuXaijWElP2s4OgH0Bm1WaGTDQbFwhzzs5p+NEMlZnr+qsoL0Rq/jdaa5bo+
	Mdb4o
X-Gm-Gg: ASbGncvqRu3GgYP5wMzIyl9sef1Xy9XkXZq+veqGslAW6ayfmYINSyObkcNEnCU5lkf
	mSEcE643p0FR9JwD/ZjXTrKtIoURRRN4jJtDK5qgh7Dx0UJq362hOGNEDmxYEYJiX7DE4pD1QSF
	V8AJW9tbMVn2n4xdUajQpdAvp09IkPXacEGST6bJY70CwWQcaf5bWkkn1wYZ77wByjsXtVuiKqk
	SAzbZzUBbmVgaLw//0Ne2F4ZllVjP5nPE3QGgg6Wb0SIOMHOTc1HbWnnS2Ku1Tm951KZGQ8bZqt
	rhF+ISlvbraFKmNaEXozPH5SfeJASs1ZNwmPtsxmWzna7Dp/t35yHfE+iXti2mHz+emBxqI9z7K
	ttcr59XL6NxUiyBFJg+v2BH9jzXzHMD9lwwJQ6f37so0jIrOm7NLLpznZK2Kwi41LFpwxS3SEY3
	lUUJAMzBKrliIPxzz3A+EJMm9r8cTKwmXcexM=
X-Google-Smtp-Source: AGHT+IGN6hSDMo/jOmPaXEPkY0HVxfHCLbCnKRX69X29HAgR3RScLY8hno4OXo4smrIIuH6tZiBVUQ==
X-Received: by 2002:a05:620a:1a8a:b0:80d:6f37:ed35 with SMTP id af79cd13be357-88352d95aa5mr264472085a.73.1759873459722;
        Tue, 07 Oct 2025 14:44:19 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-87771129fcdsm1574102885a.13.2025.10.07.14.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Oct 2025 14:44:19 -0700 (PDT)
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
	brauner@kernel.org,
	mclapinski@google.com,
	joel.granados@kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	David Rientjes <rientjes@google.com>
Subject: [PATCH] Revert "mm, hugetlb: remove hugepages_treat_as_movable sysctl"
Date: Tue,  7 Oct 2025 17:44:12 -0400
Message-ID: <20251007214412.3832340-1-gourry@gourry.net>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 14977C000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: te5d8diwpqjropeornx3iqfd5fpdjkw9
X-HE-Tag: 1759873460-173429
X-HE-Meta: U2FsdGVkX19kAwe+MHrOaauHqdSSYflzMrwETQotm3pl82X1WKITIatzbt+HmNDONQ+TLAt1+i9liePyFzXIgOwafD5mPDeqHcYvXNX/jKb61etrbuAKMnSt28sqfXgkWatwp2GY6g8C6OozFzsTNHUnsNROkO57pkTNGWtP9ftDyFbzlZSmfgWZcRtLMo7vHCWKAzYl6qdVS+2PCSCWm25WZoThP6SG2fNqm/Gcwy9hYEsxd03mPNru+zYR0YlO1wb8+XUzprsRxHeWSAYbhhCWcjaxQ/Vpp72r+UA4k6g2pFYJOHJLjewrd89C9qD02QElB2GJe57s8AV/areT35Y2JGrrat5KI/DvfH23CMLnKtlDv1cYcECGhBPIYkH9XjUmUYMcl8WnOt4yGCxdiyZkvh3UzqKSM8Ozy1XRvsoRabbwAsB/OpLqC8G0m/DhZVLZWEyiCxHmvGxzCeE9qpqZlMQNdY9KHBCVSbj84+fy//NZuu2Php59wqZusRAlfJWYF3KAXKXaEG7XgTTiT//ZDDqMeUFdCmlgRHoiUY1rLX2uDd8Me1t/KLKMNbxEBBPwk7HmIZhcm1MymkKXwI+k1QhdjI/oBPY+gJPVdWomgGASTqTCbOweeDb8Noq7lmyTMKVRyTB6dJhldoS+1FDhxX0GoB0g6pyXCej4KfsNzlL4ebl/y6W1OAtx3516SNxZCdvftyK91PN0uSbXNxOaPdOn/xEHnO/uY/vfcQYZQw5z7YOA9VLexHFhpgzF18Qj28YRIh0HP0uAtMB4xQ54NXlziDNbvPNt8gnoZzc1KA21daZNb8dfV2teB34mKteWrsL1LOMyRB1r5rgk3C2/zkAjkm6SeLHflTqQJbX7kEG6CMzzD7PYsdEmRJXaHPt6ZytVMhBEkG8NrdldcdnFT5j/w6qeV/nm1OveJsx3A0wekwR/Z7ABWh5ot/+yUhD2uOLrZIiCEVBXDFl
 spUO/pHE
 a+GWFuNANjks4j5RdUtonMQRN/6fmmPent97KVP9iNN8efiwZeLcABJhnixw5gEtWNIKOowdRZ548JKelDoby6EF5PHqY92hHtgEzOIwSSgBiwEqo2cqFv3zWuVlXUsP94rhQyGWgsDQISZBEZlKFGwHPjX3F8i3l4x5U1x/flqGFINd4gQuy32SxitmSqOD8BtV6lRyf87bvaomr+kBfHbP9cSae7UEI1MvXW6W6w6eAW1t8NS8JMGt3/EAYfffp6WTK3VF1p1xSTIUhh/ZH9q0I/iVH0Rf/Y0yf7hDgA2adbCi2GJc2xIanYcWkkK6gmjTWMOUEJlD5/MXxLZrSvXGE1QY5Pwk0uq577cBBRbzRjPiS5v+XYLjCWgbBqx2WZ9ToG3GNyxmNkMQmRlZOPWc+0UzYPQMFCRfjL4xVR6Rh0Z47KXoCQqXRJ8BcqqzgYsTdfbwrSBCwJzps7zYLRGyS7QzZxRKveHZvgPvPLlF40nzHAT9PEPUEIkmo2FEShOrdbHyHCIHD0iCfwwkrO5ebFO4VxfdBHhy3QefxPeZRBafymrhSSXPp94IXb99qSfD4sHC4fsFx+u/txQEDfz8YS0Xcwgq3BL3nhFXaTpW9NUBxuBvAZ+3enQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This reverts commit d6cb41cc44c63492702281b1d329955ca767d399.

This sysctl provides some flexibility between multiple requirements which
are difficult to square without adding significantly more complexity.

1) onlining memory in ZONE_MOVABLE to maintain hotplug compatibility
2) onlining memory in ZONE_MOVABLE to prevent GFP_KERNEL usage
3) passing NUMA structure through to a virtual machine (node0=vnode0,
   node1=vnode1) so a guest can make good placement decisions.
4) utilizing 1GB hugepages for VM host memory to reduce TLB pressure
5) Managing device memory after init-time to avoid incidental usage
   at boot (due to being placed in ZONE_NORMAL), or to provide users
   configuration flexibility.

When device-hotplugged memory does not require hot-unplug assurances,
there is no reason to avoid allowing otherwise non-migratable hugepages
in this zone.  This allows for allocation of 1GB gigantic pages for VMs
with existing mechanisms.

Boot-time CMA is not possible for driver-managed hotplug memory, as CMA
requires the memory to be registered as SystemRAM at boot time.

Updated the code to land in appropriate locations since it all moved.
Updated the documentation to add more context when this is useful.

Cc: David Hildenbrand <david@redhat.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Suggested-by: David Rientjes <rientjes@google.com>
Signed-off-by: Gregory Price <gourry@gourry.net>
Link: https://lore.kernel.org/all/20180201193132.Hk7vI_xaU%25akpm@linux-foundation.org/
---
 Documentation/admin-guide/sysctl/vm.rst | 31 +++++++++++++++++++++++++
 include/linux/hugetlb.h                 |  4 +++-
 mm/hugetlb.c                            |  9 +++++++
 3 files changed, 43 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
index 4d71211fdad8..c9f26cd447d7 100644
--- a/Documentation/admin-guide/sysctl/vm.rst
+++ b/Documentation/admin-guide/sysctl/vm.rst
@@ -40,6 +40,7 @@ Currently, these files are in /proc/sys/vm:
 - enable_soft_offline
 - extfrag_threshold
 - highmem_is_dirtyable
+- hugepages_treat_as_movable
 - hugetlb_shm_group
 - laptop_mode
 - legacy_va_layout
@@ -356,6 +357,36 @@ only use the low memory and they can fill it up with dirty data without
 any throttling.
 
 
+hugepages_treat_as_movable
+==========================
+
+This parameter controls whether otherwise immovable hugepages (e.g. 1GB
+gigantic pages) may be allocated from from ZONE_MOVABLE. If set to non-zero,
+gigantic hugepages can be allocated from ZONE_MOVABLE. ZONE_MOVABLE memory
+may be created via the kernel boot parameter `kernelcore` or via memory
+hotplug as discussed in Documentation/admin-guide/mm/memory-hotplug.rst.
+
+Support may depend on specific architecture and/or the hugepage size. If
+a hugepage supports migration, allocation from ZONE_MOVABLE is always
+enabled (for example 2MB on x86) for the hugepage regardless of the value
+of this parameter. IOW, this parameter affects only non-migratable hugepages.
+
+Assuming that hugepages are not migratable in your system, one usecase of
+this parameter is that users can make hugepage pool more extensible by
+enabling the allocation from ZONE_MOVABLE. This is because on ZONE_MOVABLE
+page reclaim/migration/compaction work more and you can get contiguous
+memory more likely. Note that using ZONE_MOVABLE for non-migratable
+hugepages can do harm to other features like memory hotremove (because
+memory hotremove expects that memory blocks on ZONE_MOVABLE are always
+removable,) so it's a trade-off responsible for the users.
+
+One common use-case of this feature is allocate 1GB gigantic pages for
+virtual machines from otherwise not-hotplugged memory which has been
+isolated from kernel allocations by being onlined into ZONE_MOVABLE.
+These pages tend to be allocated and released more explicitly, and so
+hotplug can still be achieved with appropriate orchestration.
+
+
 hugetlb_shm_group
 =================
 
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 526d27e88b3b..bbaa1b4908b6 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -172,6 +172,7 @@ bool hugetlbfs_pagecache_present(struct hstate *h,
 
 struct address_space *hugetlb_folio_mapping_lock_write(struct folio *folio);
 
+extern int hugepages_treat_as_movable;
 extern int sysctl_hugetlb_shm_group;
 extern struct list_head huge_boot_pages[MAX_NUMNODES];
 
@@ -926,7 +927,8 @@ static inline gfp_t htlb_alloc_mask(struct hstate *h)
 {
 	gfp_t gfp = __GFP_COMP | __GFP_NOWARN;
 
-	gfp |= hugepage_movable_supported(h) ? GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
+	gfp |= (hugepage_movable_supported(h) || hugepages_treat_as_movable) ?
+	       GFP_HIGHUSER_MOVABLE : GFP_HIGHUSER;
 
 	return gfp;
 }
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 753f99b4c718..4b2213ccbb29 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -55,6 +55,8 @@
 #include "hugetlb_cma.h"
 #include <linux/page-isolation.h>
 
+int hugepages_treat_as_movable;
+
 int hugetlb_max_hstate __read_mostly;
 unsigned int default_hstate_idx;
 struct hstate hstates[HUGE_MAX_HSTATE];
@@ -5195,6 +5197,13 @@ static const struct ctl_table hugetlb_table[] = {
 		.mode		= 0644,
 		.proc_handler	= hugetlb_overcommit_handler,
 	},
+	{
+		.procname	= "hugepages_treat_as_movable",
+		.data		= &hugepages_treat_as_movable,
+		.maxlen		= sizeof(int),
+		.mode		= 0644,
+		.proc_handler	= proc_dointvec,
+	},
 };
 
 static void __init hugetlb_sysctl_init(void)
-- 
2.51.0


