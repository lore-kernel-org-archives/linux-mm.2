Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAFD5C87FCF
	for <linux-mm@archiver.kernel.org>; Mon,  4 Aug 2025 15:43:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A47C6B00BB; Mon,  4 Aug 2025 11:43:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 954C16B00BC; Mon,  4 Aug 2025 11:43:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81D846B00BD; Mon,  4 Aug 2025 11:43:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 64D266B00BB
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 11:43:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3DE1C1DA7BA
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:43 +0000 (UTC)
X-FDA: 83739495126.02.8EBC124
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf28.hostedemail.com (Postfix) with ESMTP id 54BB2C0011
	for <linux-mm@kvack.org>; Mon,  4 Aug 2025 15:43:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XdnSyfEu;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754322221; a=rsa-sha256;
	cv=none;
	b=DIJT4S1fiBtDawaLXyMbRkPNWD+NMGN4TbL992nl6Hw0gxXj997ImhqbS8uYubpKbGsFsT
	mCJao79xm/BQZENKmEmpUQqcjcyDw1oDffHSOlySEKfzs7maFQ2Kx54rIlb4qcPHXAyV4X
	xXFYLJD3C0dTRBh604iFAEKuZ+HzpbA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=XdnSyfEu;
	spf=pass (imf28.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754322221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pff95T0ROqWNaJZZaJoS7Iz2EIBASIhdqYvDClX4pOE=;
	b=cIiRz/Oyv3AIWxfQrKQZiE7IQhMa4DPj1zTOnry/Pl/z/qM5hqeF/XeDKyu4dI5HOsB5v+
	uVHLYmh+2KD1735eedVjxCeh9VGkHb1zvlytAwby47Iwq/Bhg3ktHOJNjqUiZZTVDYZet2
	vOBf/ZcDiEW27BQHc8JBpTUIBnlY93M=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-4b06d6cb45fso13795761cf.1
        for <linux-mm@kvack.org>; Mon, 04 Aug 2025 08:43:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754322220; x=1754927020; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pff95T0ROqWNaJZZaJoS7Iz2EIBASIhdqYvDClX4pOE=;
        b=XdnSyfEuWC8xzowlW91r5TDLU8qkkEGdH2mzuCrzO25s0WPlN14OtiZYFPmDJocUyy
         WnEMMFcxiy7oATdfrmLGzOC9w+Wbi1q5aqEon9mjkNq62NC9Ml8sN5oo8tre0f8N96OV
         KKHqpvcxyXjZBoXgZSG9/pnFv5SDPCJs2YtulutqxCyhYq2vz4J98bolPyl992a0WwVY
         j1kd3a9ZfTYAhhpjPoU2JIbR0twcKM/yfeu0B8wBgmC//plGmyXSFpAnpwAf/V8482dx
         D7V92gkNBOJBJQJXtrYSdX6NigbtJXs/LMstO4f5nhQygcs0OKl4Zb+OgMdVSyqT+5kw
         lrfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754322220; x=1754927020;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pff95T0ROqWNaJZZaJoS7Iz2EIBASIhdqYvDClX4pOE=;
        b=d1D/jxd3/+4+YJFIX8v2eYWEEub6YZC8gk8dIR8ZE7hmYE8zU1GrSlNq2fXGIhwOFT
         OJvv0lV1zf+Ounzqf8qwQ61tQHaVBFoQZ8/1sVOqVA4Hyq5Wsc7m0SsJeEse73eaSK0H
         G+8HNx5vKxJOap9N2kIR6V5Qw96jvxqqd5CgL8kPNrwxzg2TuPvxBCDdhKOHScPlWiKm
         AfmBxh10/wxpzC+QcUZLRlb/Vs9KLIr9zsEF1ybuvwTwdiLJkuNEN/BuF51rvrLjmUmf
         zAIYFtvdBwShfeh1pBaiu9pjFGen+KwKKtMKEtwD5ib+TMgPaGwVeQQpwBR54MQyTwhb
         Zu5Q==
X-Forwarded-Encrypted: i=1; AJvYcCXrexCJR2RKhzx/MH65UYUzZZ8QAwNtdoAUkewxw9ilG8B1hqvwyLuTrF5ttqkJQRSREfu/8Kq3Zg==@kvack.org
X-Gm-Message-State: AOJu0YzsO3vZ+FoLMEpFtpoTovQP6OxDHmb4UhCAArD4lSd286DU23Ld
	ag27yZUKy0SSPHWKEa07kw2Fk+HzusYBnYEIcvDHY6sA1NbWzyd/EIU6
X-Gm-Gg: ASbGncuIOb1kW/7Rg80mPLP9Ax8YpOjw28QmKrRZMzPg3wV6ZUsXiu8+1A17ZLUO8HL
	HxwZf4wK6X3hZZ//MiCAulQkoEHnFPu5NCYcvShdZnQOAgfV6BVtjw6P8MPMsY/nmtC62D6NrUr
	BEqskL23HDUccsDL8rwdlpeqiODFSAA9xXuwn9nx3wxXRa7OYD/yd5ZYGG0ML+ltPV4ipVdtT2x
	KCXGR29XJHOhUqJvZGzgdyUADp14Ac6n8DlGeoDpMCisEpaCe0KE9COv2jB4+8z3XjaEyYpqMM7
	6rYNE37YulqonGQ3azA2CwWRIh+3xBVCwz1D1m5QX5/T2Yj3uNrw5XOSeNYDfs8rVq0tSVUZGpI
	5n97U6uemNYslXcbYFTa5
X-Google-Smtp-Source: AGHT+IFFPNIK5VdY0I2gSxLRd5i4uf04sMnarqPFp/nGE7a6EQybziuhh4dTs+npkQ5k1dzF3wyK5w==
X-Received: by 2002:a05:6214:e4c:b0:6fa:d956:243b with SMTP id 6a1803df08f44-709363080damr139490616d6.37.1754322220184;
        Mon, 04 Aug 2025 08:43:40 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:72::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077cea1782sm58271266d6.93.2025.08.04.08.43.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Aug 2025 08:43:39 -0700 (PDT)
From: Usama Arif <usamaarif642@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	david@redhat.com,
	linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org,
	corbet@lwn.net,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	hannes@cmpxchg.org,
	baohua@kernel.org,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	ziy@nvidia.com,
	laoar.shao@gmail.com,
	dev.jain@arm.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	ryan.roberts@arm.com,
	vbabka@suse.cz,
	jannh@google.com,
	Arnd Bergmann <arnd@arndb.de>,
	sj@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	kernel-team@meta.com,
	Usama Arif <usamaarif642@gmail.com>
Subject: [PATCH v3 3/6] mm/huge_memory: respect MADV_COLLAPSE with PR_THP_DISABLE_EXCEPT_ADVISED
Date: Mon,  4 Aug 2025 16:40:46 +0100
Message-ID: <20250804154317.1648084-4-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250804154317.1648084-1-usamaarif642@gmail.com>
References: <20250804154317.1648084-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 54BB2C0011
X-Stat-Signature: gssx7g38ycekc9j4ofhpphae1xwpi5ef
X-HE-Tag: 1754322221-604306
X-HE-Meta: U2FsdGVkX1+nVULntTY5a9NjBLw1UvGQ6LGMcxWru1MN7izJzJPtqJDycUTwyVOFoy5bW6iRfDT/4hEPXdCmWEi8RTXkKdpACGvJ+VRZAi0LScOqBjjd8sKpocx2Zkz+BP8z0lxwp1yQ32puMOecqCnSRnVF4nD4INbky5CJJIk0pO3Da59f4ts2ZHXBqnR/hV5o9r8Fa/eko+IHuHImaDP9Zrm3AwKAwAZxwp6ptj16VSDfvw4jzBFp1w5jBCnBx8RJ+GAXILbtyZr4+9LrA9WT8TVdLlIctdmrmiWk/RgXTRb9Ar5u2S0Skt7lNl6k56AmAxreuUeYGETPGJn65nqAIna1zITa02VYu8wbKm7XfKKrFixdRg+l7PuOe1qc9wr280KN7+c1LuEBbpNzWQD57quLbdGQ5puhUX4twQwDaG/GbPjzKa4Xt5uX5MCEbPPA0vSJrHp63eqVdZ/VJH6s85Feh/S9OFs0/AR0yB+RWybjGU/wCDdJIzfRJ7+OErhZFE5vk/zmV3iDNPeYVFvFgmR48hQEKm4GEULlfUYnqlPCEUCY2nkDU/0sutmYBu0h7u2urEidHiFptiqaf4++Yt6weNNT0hXXRg5g+PSgvW581soPHzvf/0rDjkNQ16Ms+lNVjrGyoBan3FHco8TTnNvDEc4Of84AkT05aa8RCJLWjJkKFefRJh4QVlEp1j+/eui8ome/Isd7dNJ+6uYWu1Zee5Xz9U6557kZGRjA7Rg3syotv/LNTYfPpigE8lTVfJY6Zt7783zidBvyGPx4Ck++pZ2f2saLAeFT2zB+NPa9D5/U1IYeQcd43aRt5zjCNbrzjKQMzTj164uxHZUetcaSYIm7vf47FbaMjBs6BKLhNW5ONz98s326SCdHaFLyXFwvQT8P0adsj3TZIDiYzS0zeDkMeVjrcsuMxK6G/lK5lT4DlQm2EGEb5c+7vXHasKUfwS5TGa+mKTV
 9whOxutC
 hQPgwqJq780+tXQ9LBKRk3ajlMWFq4cyB2EvRlBRfmpY2yGpOe23QITrhhAWHLHBMH5KP1rO9IZZpe8jUNyzQzGZ1FinS6qzznev3FbF/IPxzwMrqfAbayIV+WcFo/DoW0J1ukwLa3nesipdPZuOXSL5iTOGqKQ/pyGCTPJ/9vVfdpYfsJ0OwY0FGm0tmYLWqaa73a5OuF47a8FX+t8lEGE8aVugnILLzBWzbGJ2JLi+FvHGl6Osf3K1DUFb7w3VQHXFhM1wH4ayeUwjlTCA0VyDUD5jiQKoki/FMlQDwPAk7uQ2FGDaJQjpN/HS2AYHMNYc5vdpLjkx+lcnUTWd9H9vSy40AAWHUBjhLgiRe93qdpbZ/GUZprW5laG9nJhuI3P3voeM5d9vCVmlCRcyScSgCdSUaazI1BJIfDLWBO+iYf70y1mfTvZs9UrW/JMU+vjmvEnP6nNXeXMDMTMIMyZZqu424Mta3XoSAFYtkUKL+CrCXHSDNhFLRMlxJV4AmvvURPcyRuxgRGVJ3Mzl0CPVtqQlc1IA0pH+Xq2tlYgn4SpzC1bEzIJTorF9n1FQ0fr+CCrgOflF45XRR+WuhJxOjQLwkCDxBnSzzInpGLKCA3Wy/itdasc3BhhSNJn6Od7YgqokS142tM8PWJiUlT2IbHehpi6bcaILN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: David Hildenbrand <david@redhat.com>

Let's allow for making MADV_COLLAPSE succeed on areas that neither have
VM_HUGEPAGE nor VM_NOHUGEPAGE when we have THP disabled
unless explicitly advised (PR_THP_DISABLE_EXCEPT_ADVISED).

MADV_COLLAPSE is a clear advice that we want to collapse.

Note that we still respect the VM_NOHUGEPAGE flag, just like
MADV_COLLAPSE always does. So consequently, MADV_COLLAPSE is now only
refused on VM_NOHUGEPAGE with PR_THP_DISABLE_EXCEPT_ADVISED,
including for shmem.

Co-developed-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: Usama Arif <usamaarif642@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 include/linux/huge_mm.h    | 8 +++++++-
 include/uapi/linux/prctl.h | 2 +-
 mm/huge_memory.c           | 5 +++--
 mm/memory.c                | 6 ++++--
 mm/shmem.c                 | 2 +-
 5 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index bd4f9e6327e0..1fd06ecbde72 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -329,7 +329,7 @@ struct thpsize {
  * through madvise or prctl.
  */
 static inline bool vma_thp_disabled(struct vm_area_struct *vma,
-		vm_flags_t vm_flags)
+		vm_flags_t vm_flags, bool forced_collapse)
 {
 	/* Are THPs disabled for this VMA? */
 	if (vm_flags & VM_NOHUGEPAGE)
@@ -343,6 +343,12 @@ static inline bool vma_thp_disabled(struct vm_area_struct *vma,
 	 */
 	if (vm_flags & VM_HUGEPAGE)
 		return false;
+	/*
+	 * Forcing a collapse (e.g., madv_collapse), is a clear advice to
+	 * use THPs.
+	 */
+	if (forced_collapse)
+		return false;
 	return test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, &vma->vm_mm->flags);
 }
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 9c1d6e49b8a9..cdda963a039a 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -185,7 +185,7 @@ struct prctl_mm_map {
 #define PR_SET_THP_DISABLE	41
 /*
  * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
- * VM_HUGEPAGE).
+ * VM_HUGEPAGE, MADV_COLLAPSE).
  */
 # define PR_THP_DISABLE_EXCEPT_ADVISED	(1 << 1)
 #define PR_GET_THP_DISABLE	42
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 85252b468f80..ef5ccb0ec5d5 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -104,7 +104,8 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 {
 	const bool smaps = type == TVA_SMAPS;
 	const bool in_pf = type == TVA_PAGEFAULT;
-	const bool enforce_sysfs = type != TVA_FORCED_COLLAPSE;
+	const bool forced_collapse = type == TVA_FORCED_COLLAPSE;
+	const bool enforce_sysfs = !forced_collapse;
 	unsigned long supported_orders;
 
 	/* Check the intersection of requested and supported orders. */
@@ -122,7 +123,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
 	if (!vma->vm_mm)		/* vdso */
 		return 0;
 
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vm_flags, forced_collapse))
 		return 0;
 
 	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
diff --git a/mm/memory.c b/mm/memory.c
index be761753f240..bd04212d6f79 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5186,9 +5186,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
 	 * It is too late to allocate a small folio, we already have a large
 	 * folio in the pagecache: especially s390 KVM cannot tolerate any
 	 * PMD mappings, but PTE-mapped THP are fine. So let's simply refuse any
-	 * PMD mappings if THPs are disabled.
+	 * PMD mappings if THPs are disabled. As we already have a THP ...
+	 * behave as if we are forcing a collapse.
 	 */
-	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags))
+	if (thp_disabled_by_hw() || vma_thp_disabled(vma, vma->vm_flags,
+						     /* forced_collapse=*/ true))
 		return ret;
 
 	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
diff --git a/mm/shmem.c b/mm/shmem.c
index e6cdfda08aed..30609197a266 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1816,7 +1816,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
 	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
 	unsigned int global_orders;
 
-	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags)))
+	if (thp_disabled_by_hw() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
 		return 0;
 
 	global_orders = shmem_huge_global_enabled(inode, index, write_end,
-- 
2.47.3


