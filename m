Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EF946C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 18:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF24B6B00A3; Fri, 21 Aug 2026 14:58:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA33F6B00A4; Fri, 21 Aug 2026 14:58:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CE406B00A5; Fri, 21 Aug 2026 14:58:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 702F16B00A3
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 14:58:03 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EEA0CA2BCF
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:02 +0000 (UTC)
X-FDA: 85126186404.11.3DBB4A5
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id C515A160006
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 18:58:00 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DNG7wag/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787338680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RWFFYMU2hrPabnXta24MU9itEej9rdB7ueY1dj1pl/A=;
	b=3+J1qrEe7pf3OwmTUKWQvRvFzJfaQ7wksYK3vN3+kg+2hiHb5G3Y47rvl0wHi5oecOCCG8
	3zAdrsJrdPzvzfifkzS4E9bohM5uK+eVzqZbWcTnkdzoJURbz2ROlof1s3B7s14aqiYMzx
	WhnXuY0ivn+WgQmEhEDwsMG/4P5xo/o=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="DNG7wag/";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of echanude@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=echanude@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787338680;
	b=1C3vfQx2y5VuGlnZFTLIEs1MfOa826mflSyV7B0zB/QTxRFDE5dpdZRMrxbVWMA9DHNmzJ
	Ac9txuos1tmEDLOSHZ7tvlT7smDyf0ebS88WbSgqrroDUeS3GEW/xXgFKzYSP9AKVJO8JW
	TjlzvFiofIPxlYtAZ6UQDwZs+6bnKKg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1787338680;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RWFFYMU2hrPabnXta24MU9itEej9rdB7ueY1dj1pl/A=;
	b=DNG7wag/po44KXIbox9WjvtwzhAJKpuE3DlsJsagRy8Zz7kBOMIBiqpiltaUGzyDlN3QWx
	A9U9snpknXFYE+8Tu6c+0G9mna8TBpdVYZkaGQotUZH8PjaqANbLSUFkZc3gGu3NP6yDgK
	JF7HGLOdMrscgt/1rIWQiKFmKf/XmxM=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-641-7qQRKpj3O3-0u_RuFMuKmg-1; Fri, 21 Aug 2026 14:57:58 -0400
X-MC-Unique: 7qQRKpj3O3-0u_RuFMuKmg-1
X-Mimecast-MFC-AGG-ID: 7qQRKpj3O3-0u_RuFMuKmg_1787338678
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-5174a236220so16766451cf.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:57:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787338678; x=1787943478;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RWFFYMU2hrPabnXta24MU9itEej9rdB7ueY1dj1pl/A=;
        b=pAJKs9LWHNz35lURwbfFShVTt3TavUpQf6WMO4AE1xfr+nORttOcL8lmnJgD41DcLV
         76qjSDXMGu0TnemgLsk4zbhc8MrNcvFyVKdj9Zf08kimIOb3jEKdjNImn3NuMpnDodHS
         oFTIVNadQDpjw9Xizeh+MUw39FXKwes7JM7qKx2hAITaEjJakyrjlQi1eWERITm92uWl
         8/hek+W+AWES6ejRGhcpaKYloSLst/KbLM3sr/g/kSpkkE1intSX2ANxUBgQDt0qK9h+
         6xe06rlsuL/1QPhmRyBtJT5w2IYsOEOsGRXgm5cYWpc/U1Y9SmI7mjeFofto/NKUIXYq
         JCWQ==
X-Gm-Message-State: AFuF++muGlgss4MHAVW/yToxWoJCs21q8CFV/AJLtJoYGuPlq+5umNyZ
	b2NL8gARCiiQCaL0NvA/HwqqR8pS3+dpLx3qSssDXdlcL0UIXWcHjRGRJ5H9NXx94/kGNqgPKl/
	PgRU5LoVfev/8rPM9tynH6AG+8CNwM/DV8syhu/G6l8NfuBlgBR2+
X-Gm-Gg: AR+sD12q9qFmx1XpOO+8ilMtDizJfsHoSCwXnEfNnhW327lpIXV2wS2hHhlnQTgygCA
	MLq2LVTDTc9IYmT58n/tzKqkFtFI6+jIgzU97tmDnKlBg/Fp5aaYUvlG+X0cTou5fI6ouvTK22z
	bHUyNsXU0O6/a1LMDTpB2+QVtxMqGBMvY3VrwQsgU7TMIwqC/qhNatR43WCQRaRAjcLZhVfuOx2
	tQHivXloEnnO4nIMVJiygcx4eAUqeYNftr9kwl1aGRGDeTDQ1iXxflZQp0cVLjYamh52rV/jZqJ
	XuFUSX52+2sAURla3PJw/mVdDXdcRTkUnjttLogem/BAVIF8IEY8Y1rh61cymgpNKVNT5u3xnEd
	QFITRWH8fynRlA0tXIYz6gFDCcigGs2I9Q7T38p5rY635
X-Received: by 2002:a05:622a:2592:b0:51c:92a0:b2cb with SMTP id d75a77b69052e-52df59ebf4fmr86912251cf.26.1787338677394;
        Fri, 21 Aug 2026 11:57:57 -0700 (PDT)
X-Received: by 2002:a05:622a:2592:b0:51c:92a0:b2cb with SMTP id d75a77b69052e-52df59ebf4fmr86911721cf.26.1787338676950;
        Fri, 21 Aug 2026 11:57:56 -0700 (PDT)
Received: from localhost (pool-100-17-17-231.bstnma.fios.verizon.net. [100.17.17.231])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-52e09aae6f4sm985701cf.16.2026.08.21.11.57.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 11:57:55 -0700 (PDT)
From: Eric Chanudet <echanude@redhat.com>
Date: Fri, 21 Aug 2026 14:56:55 -0400
Subject: [PATCH 03/11] cgroup: add memory_cma_accounting mount option
MIME-Version: 1.0
Message-Id: <20260821-cma-memcg-regions-v1-3-d21b165b8440@redhat.com>
References: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
In-Reply-To: <20260821-cma-memcg-regions-v1-0-d21b165b8440@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Tejun Heo <tj@kernel.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kselftest@vger.kernel.org, Maxime Ripard <mripard@redhat.com>, 
 Albert Esteve <aesteve@redhat.com>, Eric Chanudet <echanude@redhat.com>
X-Mailer: b4 0.14.3
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: VPp5TvDkxrJXWOPwYlQoQJuqWTRlPFGfYE-caKdmik8_1787338678
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C515A160006
X-Rspamd-Server: rspam07
X-Stat-Signature: ac3ca4zkkhmi6sa549eqasw49pfdhrc5
X-HE-Tag: 1787338680-762940
X-HE-Meta: U2FsdGVkX1+Ol+fyCca1WzdxODvAew6NvO87lWv5bIosb/VyziY8RCD+kxhbwMdCmLNCgQY8TfikAKjKH1okJX8gCO31jspAAXR74PP4cHd8NJu+fdHBMM437t/+tduMxAz1kWIFWyXoiJHt8xTJ2J/sz9nWqQiBoOTxMgyicwiAseA05GJUILN81ms9YoX2YTZhbn0hZbpSsUu42bKR5fFp0y0HaOQG3EFF76jFqKmij9Qo/Hhl3wKaf6hdEAWRMeIk1WolFfpLxL4UxLOkD9Waozi1SHHJykZ5fk82VxZxLdWOx/g80Ht9mAkls+dpxw/iiHOLA3SHM6/V8qexXLrmWRS+/QBC11CaC3uyWpoKF5YUBG1O+mTwzihqcEkmBLzf898kZwKPd57z8kQ66FXivmd9Sh1PXJmOqMfThsUcR8VY95iZseLpOsjXa2cI45m4j0SDVSTBLk1+JNg3oPNvFxXVoB0DdueIcTpfaqTE4GyBoPFKBPnPUa/bRloO+G/XlNwVatP8Njnzq6UMzxDpn1HvD6mRNhQ+XF2xfPuiDvY6xcol0CCHBCwg0fmvA4iJWv11hZ40oqgmfzbt6P/ZRuu/lVqb90L1bivD5jWZMUJMfzQnSnnZ8NLYhRe7It3Ynk5qO+pSLwW830I0tRN3dj+g7tnL2UhCufizIU0E+lJoWri5poTlw5rJXwfebRfem8GjpXc9c8nIoi9U78t/QxmAseWROsy1BQbRNL/11sh6y1Ok2z512NAean3GaTO4J8dX5TT2yN0qGDmohCihqkvxXhTYXc8jJHISrsZXIWpg3hX+xverYgs1PYL3IkkY+kqoIpnmA2fmjKhPa7+0Q9+GUQbpD1v3VDQWkvP973zJ+P1l05RHGTnQ/I6E3oO9ttS0mfN+ifQfZej+i8OKWtSMgDYrbVXHG36ATUC6+Cx1jzT3k+YZPV2P7rLLKRy6cFszodvSh+iiud3
 xdDytxml
 dtMVf50/uAWC8UOxpXqkH2EuDSKhz+ulmDyVSgCFylph2QN2QH3L2uvmhXZ6aAiDgHcynwsh93UwARpyqquj+QrBf9CpMJxpIEA77i5S1N1/o+lHT1loDZh+p1QxPx9rhnHo1pKJZ66B1eM/xbCR8rA3eQEKsrvFMIBRkLAY70Bm8aNskKaSmzkGVyhiqr+e9/8sNwbsRt9EVWkvbyABFZpfy6+E0GC0r7lkDHNnHYtTYFOUMSzf90kgbzrOjjHu0vimABdWALBZp9VxLNdQMHuSbhhqXDP27I6KuDHV8HPGwYEQIFS5AEk1p5PFK3rPnBv9jYQxcfQR1UuxK+cwGr27uD3U3UYXIg1CUwvqGzBeIi9xEpaaABm5m8JTjOAp1RZwjyArapcsBqsnj6UAoEr+SFwPkZTrcxHw0AXo08cgbbXo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a cgroup v2 mount option that will be used later in this series to
enable CMA memory accounting under memcg.

The option is made opt-in as it will charge allocations to the cgroup's
overall memory usage, which changes existing expectations.

Signed-off-by: Eric Chanudet <echanude@redhat.com>
---
 Documentation/admin-guide/cgroup-v2.rst | 20 ++++++++++++++++++++
 include/linux/cgroup-defs.h             |  5 +++++
 kernel/cgroup/cgroup.c                  | 15 ++++++++++++++-
 3 files changed, 39 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index aed195a71cbf..3dfc13f31a0c 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -246,6 +246,26 @@ cgroup v2 currently supports the following mount options.
           will not be tracked by the memory controller (even if cgroup
           v2 is remounted later on).
 
+  memory_cma_accounting
+        Count CMA memory usage towards the cgroup's overall memory usage for
+        the memory controller, and expose per-CMA-area usage counters. This
+        behavior is opt-in, so as to not cause regression on existing setups.
+
+        A few caveats to keep in mind:
+
+        * CMA areas are reserved at boot time, memory is only charged to a
+          cgroup when a CMA allocation is performed on its behalf.
+        * CMA pages allocated while this option is not enabled will not be
+          tracked by the memory controller, even if cgroup v2 is remounted
+          later on with this option. Charges happen at allocation.
+        * CMA allocations are charged both to the cgroup's memory counter
+          (limited by memory.max) and the per-area CMA counter (limited by
+          memory.cma.<area>.max). Hitting either limit can cause an allocation
+          to fail. If CMA usage pushes the cgroup over memory.high or
+          memory.max, the memory controller will attempt to reclaim other
+          memory only. CMA memory charged to the cgroup is not reclaimable.
+          Limits should be sized to accommodate the expected CMA pressure.
+
   pids_localevents
         The option restores v1-like behavior of pids.events:max, that is only
         local (inside cgroup proper) fork failures are counted. Without this
diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index de2cd6238c2a..15f3f7110c5b 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -129,6 +129,11 @@ enum {
 	 * Enable legacy local pids.events.
 	 */
 	CGRP_ROOT_PIDS_LOCAL_EVENTS = (1 << 20),
+
+	/*
+	 * Enable cma accounting for the memory controller.
+	 */
+	CGRP_ROOT_MEMORY_CMA_ACCOUNTING = (1 << 21),
 };
 
 /* cftype->flags */
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index b5b461d4418b..12184f85ad10 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1985,6 +1985,7 @@ enum cgroup2_param {
 	Opt_memory_recursiveprot,
 	Opt_memory_hugetlb_accounting,
 	Opt_pids_localevents,
+	Opt_memory_cma_accounting,
 	nr__cgroup2_params
 };
 
@@ -1995,6 +1996,7 @@ static const struct fs_parameter_spec cgroup2_fs_parameters[] = {
 	fsparam_flag("memory_recursiveprot",	Opt_memory_recursiveprot),
 	fsparam_flag("memory_hugetlb_accounting", Opt_memory_hugetlb_accounting),
 	fsparam_flag("pids_localevents",	Opt_pids_localevents),
+	fsparam_flag("memory_cma_accounting",	Opt_memory_cma_accounting),
 	{}
 };
 
@@ -2027,6 +2029,9 @@ static int cgroup2_parse_param(struct fs_context *fc, struct fs_parameter *param
 	case Opt_pids_localevents:
 		ctx->flags |= CGRP_ROOT_PIDS_LOCAL_EVENTS;
 		return 0;
+	case Opt_memory_cma_accounting:
+		ctx->flags |= CGRP_ROOT_MEMORY_CMA_ACCOUNTING;
+		return 0;
 	}
 	return -EINVAL;
 }
@@ -2068,6 +2073,11 @@ static void apply_cgroup_root_flags(unsigned int root_flags)
 			cgrp_dfl_root.flags |= CGRP_ROOT_PIDS_LOCAL_EVENTS;
 		else
 			cgrp_dfl_root.flags &= ~CGRP_ROOT_PIDS_LOCAL_EVENTS;
+
+		if (root_flags & CGRP_ROOT_MEMORY_CMA_ACCOUNTING)
+			cgrp_dfl_root.flags |= CGRP_ROOT_MEMORY_CMA_ACCOUNTING;
+		else
+			cgrp_dfl_root.flags &= ~CGRP_ROOT_MEMORY_CMA_ACCOUNTING;
 	}
 }
 
@@ -2085,6 +2095,8 @@ static int cgroup_show_options(struct seq_file *seq, struct kernfs_root *kf_root
 		seq_puts(seq, ",memory_hugetlb_accounting");
 	if (cgrp_dfl_root.flags & CGRP_ROOT_PIDS_LOCAL_EVENTS)
 		seq_puts(seq, ",pids_localevents");
+	if (cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_CMA_ACCOUNTING)
+		seq_puts(seq, ",memory_cma_accounting");
 	return 0;
 }
 
@@ -7520,7 +7532,8 @@ static ssize_t features_show(struct kobject *kobj, struct kobj_attribute *attr,
 			"memory_localevents\n"
 			"memory_recursiveprot\n"
 			"memory_hugetlb_accounting\n"
-			"pids_localevents\n");
+			"pids_localevents\n"
+			"memory_cma_accounting\n");
 }
 static struct kobj_attribute cgroup_features_attr = __ATTR_RO(features);
 

-- 
2.53.0


