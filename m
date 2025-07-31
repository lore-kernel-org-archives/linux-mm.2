Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEAFC87FCC
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 12:22:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 53F526B0095; Thu, 31 Jul 2025 08:22:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EEC16B0096; Thu, 31 Jul 2025 08:22:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B6AA6B0098; Thu, 31 Jul 2025 08:22:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 26CE16B0095
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 08:22:01 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EA4AA114628
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:22:00 +0000 (UTC)
X-FDA: 83724471600.02.E6B4974
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0DF9040005
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 12:21:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bOuwgGq5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753964519; a=rsa-sha256;
	cv=none;
	b=rlhuqTbDF0ZG47hIjMfSZR9tT7hpiM31Kf+KHsWpb9t0so5qHIXDDnmfbHiV3s5/NbB7KO
	MMmABnrhzcVHKP8Q7J2MfVdeXx4KSVj49qlrEN6tkdJk89mx9Wg98qk98px0VGV6iBsT4+
	FdSTAAwiLSt4IeqhStGGRl5CR+Y7MJE=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=bOuwgGq5;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf07.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.219.54 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753964519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
	b=eE0N9QZ2nCz0v+ZHB3nB2arag0ri0UpzujaVkUN8YN1jF7ZgeHliMP08JE+8d0vvtJWW/5
	Tttp5oJLqFZsofOadA1GMHcKW5oEFtXboPsshFMC2H6oDyAd6OEKYqYgFiikPlqkZuMJXk
	9+/rkrMcnoV9hSkKg2KfHuuaT5yahlQ=
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-7076b55460eso8214856d6.0
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 05:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1753964518; x=1754569318; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
        b=bOuwgGq5fscGzBiGD4zE7rJ4OYSU6oKIyHsjwoIlcQWIHUF3riAxSSLNkIH/HcX9UO
         UA7Eh6qg8dtuM7vfH2MYt7KgYDR8qqbKr56OIuLgnJvYyr9LduvuQZoS85bKNMdhnO6G
         CqAx8IiuC1328LlVHWVqfRz1MwGJ8Gi+L/w9n3TTuPdUiAKkseKnLxqMIrHG/4qJddyo
         ZEVD7RpgFUZJSRHMmp4nrCyEwhnYnWQyp9bfyXG1pMSSP7+Q+IOS75qkcYDJc2N2RZVR
         IHtofBf3VLOmpH8n8tl6+isIH8O8C3l3GR9RZBvUL3f+B8VxQoc3DYYZLYwW+xoFoKqD
         c6vQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753964518; x=1754569318;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JREE5x0ARz2QqEVTan/K1w654MwTZ7Hc0OH3aFNqbBE=;
        b=EZ8t89x3zRGcMAK8mZhLsKJGQR8SnBnUXpLN5I60CrPsni6qgU2+RbKj6EIeaaxGNj
         Jmzgq51Mq/q8kfiVQdtspmcwvckTy0s3zUMJ+vNkRMxJDSath5+IhaCYWL8q+0GZ9siL
         tYX8NmVr0gbzSIqJQts7lMPOazDguLJlTVxJ2O3HvtGTn1N4OjFKMEDonrfLHstGvJO8
         JDlGSejQa/Iox5mGiHojP6MkseTT+DP0Fk0DoMSkqwOSFHudARFyujoOfckwAl3IuC05
         AnOxpc2lNPLy5Z5HfqX6Ct/2Kko/TZQJfPlHalA56gVLJNP/CfDUXaOP+lt4j37VsWnV
         as4Q==
X-Forwarded-Encrypted: i=1; AJvYcCVPvVFQdNr10WwnyEcewF5QWcDWTO9pJylbmJUfvN/N2cmZr/lkSzkFo4klvZrYZTokpNte7ynEGg==@kvack.org
X-Gm-Message-State: AOJu0Yyu0E035SK6byzPb2zIuxMS2cNqpY1l39/s94jjIWhMheVnbhg6
	986393ezURzhEwtpJLQZHTZeWgH/r1yxD/SRo8L07bRwvVPnahWCPbPZ
X-Gm-Gg: ASbGnctXh7a8Ctu6bswWWQLb3Drn0VgSscZrQDRZjtJn2VnNyj1gU57boe40qUAjieR
	H2ExLUz3uaL6ZmqT6XDNJPZmrJVRYbcu3cgX/DyfBfLXBAV7QAXsoXbYk+ptHbvscV43hRrdbkr
	AOL5tHeJbs/aevWmXGd29WEgSjMupnCHJ4DCnXB6vPxUwNNbYSA5MbPNXEXU+KVp/py2GWz0z0Z
	419yvU78kwsKVvAk+hcclYCC0uihWWO6o4thimNeAZVz+H+O4f1chbPu2KgKzJeGog8Q+FA1vh4
	hT9tySJ4/wFmZrBNvtlxG5l/aYciHQhGEBtsKbje541XZzffaaCNaxgjvEzQ7tm6xCDgd7SfrxV
	ywfRXRzXBI/43/K05yt10
X-Google-Smtp-Source: AGHT+IHsIKxLwFEluODV0vbsvFrMCl5SsgfWsi5T715aWZqjhTTayiRwPtiQzpPMq3PXVQ+C8nEB/g==
X-Received: by 2002:a05:6214:5283:b0:707:4fef:468c with SMTP id 6a1803df08f44-70766d85cbfmr109037656d6.5.1753964517952;
        Thu, 31 Jul 2025 05:21:57 -0700 (PDT)
Received: from localhost ([2a03:2880:20ff:73::])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-7077c9d8affsm6650646d6.5.2025.07.31.05.21.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 05:21:57 -0700 (PDT)
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
Date: Thu, 31 Jul 2025 13:18:14 +0100
Message-ID: <20250731122150.2039342-4-usamaarif642@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20250731122150.2039342-1-usamaarif642@gmail.com>
References: <20250731122150.2039342-1-usamaarif642@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 0DF9040005
X-Stat-Signature: w8d8moznzfqf7ih61wh1ey853k5kugg9
X-Rspam-User: 
X-HE-Tag: 1753964518-602524
X-HE-Meta: U2FsdGVkX18XHkcl59PzBlxlmF9g0s6GcLFbEryJFmQZhxXj6h4dXFnsV3wACHEJKBiK1dj+r+/MS5OIVx7ILPUU6wWM/Cb4vYQw07ZtGfG843GiJ0bHrc7jWQCoPkgP30IZkmUx0E4357lbfPeUurMVqz0+5stTaWILkt5X6aQDI6R7nAqYHgG0THc+N6Un/7wwaEFh/af0aR0adXs+H0AQItV/iYpuDH5BLtL0tCJeI+tRcqd81w01f3g2StdsWIDWdcqkO9fm47xi1RrLqxP4SHZZaBTBfTWcWAJRl1LEPdTDkzNWd1+pD7BKp45UJBEkEfytp02L20NOuc7tNTOk6HgXnxcHlTZ90amqLLBU4qtRLUkQYrPfMoT0lYjvKyTNBjhBPcv2WOBQc8dSVP5jVamYMFyx0TfS0O6Lnk+kXTSzKQ35ajg35Qgyrai/NxStYL6b00Xqu3FG9QinROpDBxs9WeKtND8k1S8fI3Exxp7YM1QY7nDYxm2bNmQ9K2fSGBpLK+ypN8L3QK7dxVWST/wPb3cPzSGejGmO6MRCgWGC1uItFxxh2Se/iMytcieTTwv4bKbiIJ5IQth++p9rPqrdHJb9M+RXghi6cLT0XAHCfFCz6QCQSTZyoAZO3QB8Py6PtC65mm/KNdnbpO+IKVQWovSN7xxKZgHQBH+kXTfAoqbHOOwrGLEiwCBR5+WxcR43A3RIi8qu4/4DWYHN1fLwa3Nde+/L9gaGaGSAUczq70m+9g+wcmZHmqIEzD4AzYm+sgteG+ZFqT+OAXvIJrIqXd22OsSRNPAN8XN3hrhWyCx8147UjHNsGUDPbzKXVasG0fyxAbBTAaCrX0+Kq17EVi9ZAe1gG9MVmJsxsmCNNGQJKDN/hBGcJ8FFEzso8aPtaax4s9PAKty48kYsu56rUZVt4ho3jQio4eGPyAecW8s99n8k7t+2bu0V7p0GF21VN1xMDar5374
 j2chjcNn
 zWFnMtdvrWV5X6jx2E2mKKhzhq9DrwOMr1/OzpzSvwpuUnFByBAZ8g495t5MkmRHvWcZ0M3gMlj90D9TFZVZb2MLLqFsIazY392x/R4htNI0buUfChNnV4wr4G/D1gbUMGLKeQBRET7mVFl946JB2L7pffS9FKBSFfC4WYlosco7pw1305u9EM6wj3DT9VcuMBgXbpmym3LRHH5YLiBi9c6ZjM7Vcbg3ksvARO7TdFIyAVK63tV9g4ra/zUP4wzifgkrPnv6kIBLQRYYclQtMXpF1zHpUE8OZdn7gka+5RhIGdxHPiZNMZAIvl7qnC2ij8vtfapeuB2CkaOOyoPWeYZDH6F2rwA4aWrY9Pp+9+gxqtXRDmBNmC8yle1qT+tpxGhdgguZes0+2VT6xyTWilveyx+2FG/DKSlte4RpDT+IA8Wf0bOOgUFPWKc2vszVn5KPMGkpf/q3x0KZ51OpYu9V+hCTyvklxhOFSEcXu42hDm5Sm/KBU3A8GSmAPf06hpFWSOji5BBzGzQ6kXjA6zd5HVHpsTaENxV47h78bNS3fcltVj0QFBo47pekm24aq+6nLgEjg8As3gAl8ErYV7fg/whhrAZrpC6HIopNsINiExP9uz35Qcgzn7cJi1mJWM2es7ymAf+9pUpspzXhzhMChGcS5ECVuOahO
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


