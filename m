Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D3D8C87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:28:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DEB08E0006; Thu, 31 Jul 2025 08:28:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 067098E0001; Thu, 31 Jul 2025 08:28:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4B0C8E0006; Thu, 31 Jul 2025 08:28:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CC27F8E0001
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:28:37 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8F4D4C0719
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:37 +0000 (UTC)
X-FDA: 83724488274.18.37305F7
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id A181A40012
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:28:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kzaVHEcU;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964915;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
	b=DJzhtvULfEG6uvaiGGO70YQ/GW9/V5m0otcC+VT1RhKs/eWnc6U3/EkkhOnMkAEF+2u5Ov
	jAkevFgo5NpqKz4c7EkN0Gk2jCSu1mqVnapAzsnlm9CqVHloM6rkJhEsUlqLp2wTOCVVjT
	dJB4b+JpgsETcrwlLdwY57NS1v+c+fg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964915; a=rsa-sha256;
	cv=none;
	b=qHP3S5TJwwHkARGC1pSm5j3AYhP5ZW0MjNDhcYbLbKUX82gkZkPzGP79WgQ98il9LIjjsf
	YXoWCc+n/CpZ3AhODzaircMU1+XG6+IT6jBTwEjyc/PKETW9vf/wRSx2i4vGWI24r9u0Uy
	4c//q4lOvxWv0LwZyGcs4ncDTiDBadk=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=kzaVHEcU;
	spf=pass (imf27.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-7074bad053aso8326316d6.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:28:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964915; x=1754569715; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
        b=kzaVHEcUzNRTD+v16IQXtiIMD5RRfijCxQuecBvc7/ShB0GQWw9APLNiUenAp1AlGo
         /VA5lKfoTqBVqZcU9VRrDO4vEVVx1VvUhlVGoaEMxS2LeneHkTTjAeQMna1GW1cZcZAY
         S2dwzQ9/Bp9HBVufT4+uT0yp5lIhvYKlP+7GicxlxmtHr7VaaZ9PBnX2pitkiZWPQSgo
         Cb6pIe4GAxZjoX6SXnsAG0CnA4XOLxVcY6Y9TQt4Tf7ccRueYTN7WucXJ9320GEttxEC
         tCFgRVjFepskinKOtRFoJfAHhqd3mFScPjhw5oelpgmV/44qgbWGHHWdRFqq5I6G64NR
         gXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964915; x=1754569715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
        b=Ny6/Gw0Q+LTvPSmZ8JixYlwTDNH9NVkuklfLOhgLP2e6LXtnWMTPrIb/LWwStY+q2/
         QZ2GA1z6dLpWMkHBkvdrAK6fRvhqMDw3Xfm/7DaeGVRMFRpnFlIzCRFdBNI9yIYnCIvU
         PcuKMtUOhDh8oX/8x79OAET3FVRZhtQ+YJpoc9jLIRsbVHAWlF6IdkLF/SA7j2aQkV7K
         NQqN4BDt9UZJtWWyKf0zgQeN4dkLChX2SjJkxiMznFKCE5GVs9+E31UIGsqKNaFpSpIw
         RWQEkweznY/OYtGaTjCFFLLlcg89JKW3KPd91J52IFniufqpG10HH4jBCvsZNIzria7b
         EokA==
X-Forwarded-Encrypted: i=1; AJvYcCVkmLGmfub+PHMnxwTUK15IYOIbKVMV4C5cchzpc3IOfZXDGT6yX9Z8phCWVjtLh3PNBnZ0Zgxzbw==@kvack.org
X-Gm-Message-State: AOJu0YxuvT/h/33CBZWOGGoQD7luVXs0HkozhNEytpWVsSqSt0Sd8GXx
	Pstg0bDOVM5u0vVst+k7tK1Ie5Q5dXfUaQqL2BBfpnIM8L61TGZY8YnP
X-Gm-Gg: ASbGnct3N3YCsX1Zfkwz1K/kEgovC5pwKA+aEws6W3nPqjnz+a+O79Tt0ox8o/C5n49
	6IzneRuAtbXbm+g+k1Gm6wo4HsCeSAzc5XThRrUK+bvH22YCvMIUMdFIYRcpL4WyhmhIJG1A17J
	1RNn89Tm4janNSdAD/JqH8yxlijqRRRbojSyM8x3Mc8n9f7cqUG/P/SUQJbotCfb3AK255tA4XY
	9XwZsm19phqxVRdF4Xj0AWRlw8NC1tIbQikC1CUecDek7WzcXL71qWZYvs1+J5wphrSGhhtKQms
	BNCJArdoc9jDMK2N/rNi7FXdPKyrr4pv4wgvT6TdCntUAwPAk4ttevmx4O+EAIL/NR+ZU/3xMgE
	3GbEicsn7KVelCg7NbXkkMktaDpUkkw==
X-Google-Smtp-Source: AGHT+IHnTo622/0F8XtAvaFAhVW0Cfz3Ak4EUz5CdKszTNMI3rpFIV38QgSvVNtOqU/62lqxWSWeSQ==
X-Received: by 2002:a05:6214:cc6:b0:707:4d17:e280 with SMTP id 6a1803df08f44-707671e8f20mr109836866d6.28.1753964914446;
        Thu, 31 Jul 2025 05:28:34 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:1::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077ce24cd9sm6503666d6.76.2025.07.31.05.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:28:33 -0700 (PDT)
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
Subject: [PATCH v2 3/5] mm/huge_memory: treat MADV_COLLAPSE as an advise with PR_THP_DISABLE_EXCEPT_ADVISED
Date: Thu, 31 Jul 2025 13:27:20 +0100
Message-ID: <20250731122825.2102184-4-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122825.2102184-1-usamaarif642@gmail.com>
References: <20250731122825.2102184-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: A181A40012
X-Stat-Signature: rwuim4ct6aweeqqw3k5x87b5ad8ohmqb
X-Rspam-User: 
X-HE-Tag: 1753964915-512117
X-HE-Meta: U2FsdGVkX18I+LnKCqrmL7Pg5X+ZQvsJNY1D6+IBVUTP/l4YGccouznwLjDdF+FtmOWThrj/N15OwOzQp4GH51JlfSUcq5quksLVoVick+GlJCJ1oyv+Qyk8+6cPFUJbfJjeH/5bku6/HCJsG9RF09sFP4GU5K68FcvZGDNta0zWi5UKlAAGw7HTkjVOMndRf9MBqwOVDWRUGgr7x5IzQDlm0AqZV8faqpf8+PN1SV9IzgCUBnMSJ69u9FOlBUeUKYqYsEY1vePEmhoKm5jNzTSzzg04Si1eeqDLXIJvk15sfEXH1JNWJkiXIUcki+adCXdXeZPic7UpmMGXukUtG90Nwy7Q2sRx4GKNvwgxIewC+qwVdMOZ74u34mAfR4M500ub6DeOTuRjI8TTmOphfJi7w1bMS3ufffMtTu5qZk9LTNefFQXU/rs85NqQlt6d+tyfcGKApyif5DXzatIpMAkCxMHfGfOYj81Nu71K0JbWllO8rs37hKxyJ0FjbxLfLYsclKSF8MgRk99XAymsnXO/hU2Gm5XxmwFacSnSZGgw5EQWlMHY1NjQyb5c09hIgtYkPqsF0QO4H5GGEM85g7KcHGXCzFuSSpJOj/tyEfHPnGF+xwDFv74uANN7RSGVLnVnUAKSFHIwzGxwktm10gVdHt4E4COkNobr0FLZ/PRj+K7mVYEVH/WKZX4VBQpJyG4HwNJCbpn+a+hACyIaIrMDfM6t5bnrapflaWNc3uIm2KnrF0mPuebFqMJV36qgy0vB1pskWO34CMdr7YKTZ86QofhDesf+cW7oT+fsVkKnyDi8Hn/VTuRtwZ2ai4xFm/iL98C19vSuI+tkrj7spQa2Gda2IQtUz+s43xwKmKUo6d2FGHm4ydgoV6JaVEM6fUuivai12HIYdjCRJzf56ccoTdPlZotCvf50nt+PZyusYWcX6Nafb5uz2mDuiXHDWbd2qLYSK/+cLkqMayL
 6vvCAzd4
 1+zdM1vMnXEWV50TyMvoqZKOkfkF8KeXkLI9ZHftLrJbHbqgLooZ60RWeCeHKhv+ccW4SebwrcB1M6NKelKut/JH2Mp6BogXpNbmTWzEkpJby1QxoT59kij9RhGFWfG06ZWOwzG0G9lw6j3430I9mKyENeToecbYmaEXAGogbnwJuzBNzPNnr/Typ2IX9+MK5Hkgpjj2ukJ7El8LW4iK5LLZrSC8QUi/tB0KW/PgEUGvW6ZoooxlLNLS2QV4S/dmAdd0Nf1iSBO9R2keRwfQz7izW4Zbb40jq0wjHDlUu3NxB30VbCRD6b6aJLpNAX2xiq/1WQ6mF0Xca+KahG/l3rK7a+lDqdc/UV+1+olRziUxzbywQ0U62Gb+RcE1Yf6DXGKvqYXlBwK/712FG5BDr2H6P6tFnrgcrzBV6xV8LLL9n5OtC9nYM5pNiu8DRfI5ltJ6nJtueGk3WoKPpnqj6X94WxrOKi7lacbni0wzFwBQexrO8Dk6XuYNHeIjXCIj/4wu60r32Z85Bem9Mi4lUIDqSdY3K/MluY0ZyOQjkY2YBdVyPfF/jLH2l+EoUO5b5H2Q/ejaiT8hrQanWgNYUZQjnYRKEU+rYWadgelyDxlZPmjqCJ/g3EPXz6mE7wd8I8/loPeHE94aB7J8DDp8MBokB/IFOOwwwVJJT
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


