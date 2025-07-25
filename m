Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DBB30C87FCA
	for <linux-mm@archiver.kernel.org>; Fri, 25 Jul 2025 16:23:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC4DF6B0096; Fri, 25 Jul 2025 12:23:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4FE16B009E; Fri, 25 Jul 2025 12:23:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C18C96B009F; Fri, 25 Jul 2025 12:23:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AF2F46B0096
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 12:23:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5E7C140899
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:07 +0000 (UTC)
X-FDA: 83703306414.10.EB191B2
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf23.hostedemail.com (Postfix) with ESMTP id E35E2140007
	for <linux-mm@kvack.org>; Fri, 25 Jul 2025 16:23:05 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L3Rc9A5/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753460586; a=rsa-sha256;
	cv=none;
	b=DHD0U84G7/AHYrYFDvdLFPOnbQrVl7hAecCLB2PrcTNEia2HGlyx8SnuGIri21vRsgo6Qg
	LzgxFyqgHTCaTKPrPc4XuLU3+ZXr80ZT//AK3N+wpmQyFf1NLRkOc1a/ltilcNShgskToO
	LgOc2iLSjivGe3BxieXTcJt67e3yL4g=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="L3Rc9A5/";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753460586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
	b=UHXUb5UIbt7JVEJGFE4MwrDRIlDvGGhRbFuNblhYgqZqpT9FX8zzoj6xUgAI7y8cbzWVFW
	IK12VWMold6CdiKPH05C9A6gCOa+NVK+4DOAgldA9OU1ab7n+vwM36ojQ9j+7Tg/MBk6UJ
	gCyt21OtF1MoBJJlTAU5Mt/jJOYZ5RE=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-6fae04a3795so17583056d6.3
        for <linux-mm@kvack.org>; Fri, 25 Jul 2025 09:23:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753460585; x=1754065385; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
        b=L3Rc9A5/NQUHEBom+Yu6tneY2cHEb6VHruGyw8CQjhPJ4BQ++1p9NfOdCfWuZK1hfa
         U4HMcyfI04S8o4yHRCahlYeOmsGauHrXowc/1eT9XpU2YSESzVzGeWV5URLalY9REg1W
         m0KrWdGUDurE9L2lYq2fiswBL/auwobwfnSfEmHRQTcAKscICJhzEBdUGPs8301O7AU4
         XdKGbmwSdzt7PhwvG7mLBvgROgVb3vJ7TLteoVM8yEkc8Gks1Wbt6j8bVg+eH6F/C/gq
         DaIjOu06pUg/lbAXnGD8uQU4s8vP7jCxdmmHnqXU86t0vXojSXnTA7sBsvUyhwujlNdf
         w67Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753460585; x=1754065385;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
        b=kH4G7wCsW2h5qgXGvg6fLHbMIWkw8dnnIdVrQc5Vj7SK6TRe5R9sAQqzyAQLoAcCHT
         Gc66v6E1KVLEBqrNvXlnh45BtrUhtnSf957xmU6PtUIx8Pl9bScWHl4nq4wVqCViNwUC
         UEYmmvYeY6vwszOGF/KLtWy6btvf/tn0w62Xwa+4KzNVGHi8zur4QJhoz+xHetunWG6U
         6d+tvsNcMkyfa/i57OuAGYwa8PfdT9vq4O1Nn79/PPqE6N6ChKoObJ8HqByLXgWgsey0
         qx3gCrz7r57MUPxnIqJQV1ncaNNSgfb5YijJQvpDTTNY5P7q+P/kV+S9f4mgnvi49AR8
         tB+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXLJf0doGI5vOLmJMRDEQYeydEyeSVt6YAiDbC1tgZki75JSLrxOT+FfD70FYZdauAEABQ2wDC7Dg==@kvack.org
X-Gm-Message-State: AOJu0Yz2EkIl0NuTp4Qs9k9UUE2ETakpnXt/7823RT5Rt9PlYm5kTy+E
	AbBeb3HzpfCOsOOVJ5apAWw+hwNREGZLZ2WmQRQaS1IrNxEVXv+3/c/N
X-Gm-Gg: ASbGncu+T0+ZX7wyZqsywfzsblNWw+1X9XaH1a+zdMrBaC3EWqSDfNJcayhnNKhbfCZ
	9LqgBhb76YFo3oIpkwr6yQsV0hAJabHSeoJkFyslgZGsCd1tfvERlMEN1m5qTKLiLV1hgQI1BQ3
	ZbcLbm6BavP4lAbadnF/dR38x0Xj/6hJ8Q216nq2A+nOcMlVpq9UnZZNu4ZboBItjlG6UfAkg6O
	YHN+hI5a0aHuMjb2Tsa1RAD/bJQjUOii7pTxNgTP0zkCv0vUVLk28fHw3/9ifQFVE+EAlyW80jT
	KBL1GCKX/Kf4bu+QZE+P/FpihvptaB7sshsopRAvsDXYZm5gagULMjYkyROkqibhsUgit8yEhc2
	Rz9C39Gv1cAmuQ1fwPz8=
X-Google-Smtp-Source: AGHT+IEN5w1m+WG8vUhOdUow2NKovnyWHknbSVQl8xiAB4hL6Q385HGbdTJbSA2QKHuAKvjV5mQMkw==
X-Received: by 2002:a05:6214:29c6:b0:704:a583:d98 with SMTP id 6a1803df08f44-707205304f3mr36859976d6.18.1753460584541;
        Fri, 25 Jul 2025 09:23:04 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:5::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-70729c6f5d9sm1807706d6.83.2025.07.25.09.23.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jul 2025 09:23:04 -0700 (PDT)
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
Subject: [PATCH 3/5] mm/huge_memory: treat MADV_COLLAPSE as an advise with PR_THP_DISABLE_EXCEPT_ADVISED
Date: Fri, 25 Jul 2025 17:22:42 +0100
Message-ID: <20250725162258.1043176-4-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250725162258.1043176-1-usamaarif642@gmail.com>
References: <20250725162258.1043176-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E35E2140007
X-Stat-Signature: yj35fnzkxm3ttio1sfshejdoqfwcj4yn
X-HE-Tag: 1753460585-824560
X-HE-Meta: U2FsdGVkX1+U1TEilZvkOZ3TfLasloNSoR8iAD2L8bi4LQ/OBUs2VDkPNm0OldRnJT4jL+Sm8VVFxCtxcgilKcA27ptnz+Xy2yqKVQbBzn+oYB8GkNo1B+NC8JO7gjTMU4aLMSG5QCnz8OxfdnoeRz2Y44tL+OSEbFQu81SaH/KvofUhY8M/VxLu4DTcl5qivtZQiG2nholMwUcxMgRRaRtx6nOee7A6Xj8VFMPkNhrvm5lqp4cZK9bU/j0M2HbniR4IuGX0gylForoDHmZN78foSYvbxp4DG7aCTWHd3hb1FtrlXfIwAEMFe1Ajnh6hrWFNSFOQv59oDYAgaczs6ZFGT9406yIlo4RC9lcSKbYpLOQax9wTcwkHenLlIf4zyaS01oxwAo6uHBh4Tef4DK1oi/epZRA/3oVTN8y6EWFVAtVid1B8QKT3GuSeicUPnFo8LoPSsiSv+t9LlCFnBdQQouFff70MjhsutngRryarUjCKIWb2SMa29RQJ+fr/t+4pczk69YDWZMwt7Lw0hp8TVu1RHeoJzDXywEjnGC8sAvdOEQWo782J9UZnMBnkU4Zmpdya2cMNjr5sDHWg7X8jWP4xytRoaymalcQRfjUat6hxH9a/mCAUS0nT+vV4IjLWZO3p5RDodN1MnJxkwyheMFC0P0mCLe5MpDgYIUAzr/vvfZVVNmkyEgy9eInPsPvkNlTBNCwy7/RK/6amQq17rW2VmH+cPOWYLMEy2+CWlDajfbdWRMJo1ewQuKE0VI2bYL6ZWmSPNm85MNGHZXxPYm6AL4vjcaVb7GUNQW4FrOqoOh/xuNV6ZiQrE5X5WNgtpiPEiyZkttDmhXa4f1f+UUE7FsKn+/SEZvpRo0mHjiNc5JtNRWJTw+bsdbZSm+lobhFgONaY9L316Ik82BHVmdshpsxVI7ArjGsJ1nIKylpu5zI3MRdccatWfMVH9/zLPC7uVzfYLZbqtxZ
 i+NszzNw
 UrIlRVeiagJ+YyHNzpy/thb4wVVpfv2JYmw7Gku3ET9GdFExkt48dE0WM4SEqc9Ql9H+QLqF6wSA9rxqHkdWZpWmyTDvrEfxoDK8EntHDH3ysdJodlFTSSc8VC/6RE525run+60+sTU+PdM3oRf0lz2GTirH9t9FqRUioncgkrEUg9J8LxukpnNqO3wrYnUn8jBdxO0EygyJ6n9KuaAQAXoxhLhpfHBIS6NorC0SuRPKAQ+04FscufxtttARkp9QVeutV08O0X9saK8zh3w+bKHD7RqNz784zwr4HXScV5KsXWFx1J6sOJiAYT4yXxKOAeGjd1lB2KvvUJPep+Hqh+FmnyqWcWtUgnB7K8+uUyQLRuorYYQh9gEZzVPwmvSkMAESeiPNxttHUPVyrN67+RqBMq1ZxINK0MdpnRe8otO6IPUZyxQ3K9EMlMBPKdSICqqN3gGzff0uZtKEq+koMn+VIreW7sbs+gCsHhIqca6b+JMOLJUdsRNmvXk88QNYYnQ7LTaT0e/0B8egpfC3P1gMs5Nd4fjWCXJnfxH22QUcJHQ6M6xdrpOZtPoBnQ65Wjh53wQ2Udtg0EMrC3NkT9Goh6SrRcUj5ROkiTTQfEAQ92KJRqZCTfgNYN3t+XbaC5+b0JezoPaaXX40M/zN1sE2Cvc/YiasPNTzr
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

MADV_COLLAPSE is a clear advise that we want to collapse.

Note that we still respect the VM_NOHUGEPAGE flag, just like
MADV_COLLAPSE always does. So consequently, MADV_COLLAPSE is now only
refused on VM_NOHUGEPAGE with PR_THP_DISABLE_EXCEPT_ADVISED.

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
index b0ff54eee81c..aeaf93f8ac2e 100644
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
+	 * Forcing a collapse (e.g., madv_collapse), is a clear advise to
+	 * use THPs.
+	 */
+	if (forced_collapse)
+		return false;
 	return test_bit(MMF_DISABLE_THP_EXCEPT_ADVISED, &vma->vm_mm->flags);
 }
 
diff --git a/include/uapi/linux/prctl.h b/include/uapi/linux/prctl.h
index 9c1d6e49b8a9..ee4165738779 100644
--- a/include/uapi/linux/prctl.h
+++ b/include/uapi/linux/prctl.h
@@ -185,7 +185,7 @@ struct prctl_mm_map {
 #define PR_SET_THP_DISABLE	41
 /*
  * Don't disable THPs when explicitly advised (e.g., MADV_HUGEPAGE /
- * VM_HUGEPAGE).
+ * VM_HUGEPAGE / MADV_COLLAPSE).
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


