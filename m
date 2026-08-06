Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56606C5620A
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 09:37:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74CEC6B00B3; Thu,  6 Aug 2026 05:37:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FCF46B00B5; Thu,  6 Aug 2026 05:37:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EBFC6B00B6; Thu,  6 Aug 2026 05:37:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3ECA26B00B3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:37:02 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1A0ED1406B9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:37:01 +0000 (UTC)
X-FDA: 85070340642.27.5799956
Received: from mail-pz2-f1.google.com (mail-pz2-f1.google.com [74.125.228.1])
	by imf08.hostedemail.com (Postfix) with ESMTP id 59E2C160003
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 09:36:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FHCb0Gae;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786009019;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qD4VW4BZeNXzCi3gbNaQKdLxxRurNtLyN+adWk+/0t8=;
	b=1e2C4YQFztl2KxLZ6OEvehKKaAI6d+8BkrhK+B3y9rYOzb3ldpciob8Xi0cN5o2QfT/85h
	AM1QTeG68LFdivLYug3/NflxYI6T8uFcrU0I926rvq/e5mPwChNfouMHlZnPOdM/Jl8y7g
	R5RStAplJs9I5PAwhSdwSvtzPVUPN4Q=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FHCb0Gae;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf08.hostedemail.com: domain of chenwandun1@gmail.com designates 74.125.228.1 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786009019;
	b=RzvLSp3/ramYorb5WEFzngNe2EwxEu4SJxD/4gfbJQinjqh3qisZwMvbRCJRTj8wStAmHQ
	nTKAw0LYWEwMRlxjY6KKs5D1o+PtPsLjY2tpMyqUaiMM2CZcSoARvNq2GMV7kduyqOCfYJ
	Mf9Eqmya7OXnssoRXWVZB6iE5R6XahA=
Received: by mail-pz2-f1.google.com with SMTP id 41be03b00d2f7-cbb8ebaca74so1068846a12.1
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 02:36:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786009018; x=1786613818; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qD4VW4BZeNXzCi3gbNaQKdLxxRurNtLyN+adWk+/0t8=;
        b=FHCb0GaeaKQSdBDHjyjg/kpQ6M3gzjwujyUSxOupd68lU1ekICbTgaO8MlIUxl+Jqt
         5mgoC9hGye21PQe1Z+clFKBaz16p03yWihzUtxM8wmb33xSDLhoefsqTM7vuCnHYaa9Y
         g5FIGit3X9UGajq1OfjF7e+NvR/GfBZgHuLU2Iah84mFV2bPXHQ41Zb4mgkhpTlB5OSt
         G8GBHHi8y8JZWWIyNnuc/A6bZdY/M9JO89ZatLEVVMVJasgZCL3OLxsHXbo4PIf0sfHe
         h+av+ph4G1b7lmux3xMHPY/MWqw4H07eRdSRt/hiTIDP8NTkDgZyg4pdMSYwhLYh2yNf
         6/6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786009018; x=1786613818;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qD4VW4BZeNXzCi3gbNaQKdLxxRurNtLyN+adWk+/0t8=;
        b=fVLN6drMJ57fgVMtAT47lycwBMJ+mSomj1TtJQjAKfOQ4hTUcLue/HVat5DiwK2Q5E
         mrL4AUiAk6KFR64ATieRXYc0R2aj6Viq76rUDzdHqmBRkw0ukjAegUwf3zQ5cctirxl3
         Y0SYxThyiyEW8rhtbLLtilCRXq2F+tKWBWbiwzYhAjLdv0ZeyHMILdz+tLhcpxAbEjrK
         gS0AZ5D7J5QAgke7V05XCVDVHgjYGLmOs27fT/baT2Xz7lNwISWUSI71M7HvvbnRoZnF
         lykItbykAVXQML87oWh4u2o4lcHOII69Xec9F58eQMcR0lcmQfo4nZ8K3yUVdslXwVMQ
         UW3Q==
X-Forwarded-Encrypted: i=1; AHgh+RpSP8jLGldqWUGVUiN4GsgAqUu5cjwOKQ37GyS6knwu+gIeXI1SdwY9hkjQDtF9WKKiyrh2W202rw==@kvack.org
X-Gm-Message-State: AOJu0Yz1N5MctmimHK4FVYpFUgRgVGZklYbZeRlEATIcNu2jjzTiTp7W
	anpkhwTk/iap+Q2PPY8nBc5DYg05SZtXmTTuul1Au0y8hGUg2gVUftjO
X-Gm-Gg: AR+sD13luSq9RAKBvkf6dH6voJW5uQRaFM+cNcgDmus/2t4Yt0QHolCLSmfYTWMkUbX
	4RVG1rZyNybnE/mRXUgwIo0lgahQEJCX8ictHVffnOSZm7u12bKtCEpce9IR+H0LFoWv/U5wrJk
	Upb4HAAUDhPvlpxl540KormRvzB8Tb/vq9JNd1ajnabYvzz4eViq3oq36RNFyTQUruusqRwyRYr
	Bfm+td5ETMLInYaankbCUbipcN4pi3ta4TpTeNApVb39CajKAz9tdR9c/QqmBDZbOky3Y0VmKST
	MwV2C8vX59tixh1mdR2nyzzEiB5sYkwBCHRigqX2jQkZqubW1I9L8m7aKw8bivV1R7buKzY1l5D
	K3gkzbUgzeJ6PABd0lsOzxJxFXQ6fJW5LDeJgdiQfI0kRm8JU3IhNyvf2g3WVGrUaoWWrXdoVyG
	urD+yAqqXQWd3NTwQVFsKJNNBGdYBI9ZOcvX3yQlvDuWTBafqbDG3xnmNPPz8Y2QRA2gA+hmtf7
	A==
X-Received: by 2002:a05:6a00:2d81:b0:848:6c9c:4074 with SMTP id d2e1a72fcca58-84f2dff6cd5mr14050456b3a.1.1786009018224;
        Thu, 06 Aug 2026 02:36:58 -0700 (PDT)
Received: from intel.company.local ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84f453b0aeasm1043878b3a.13.2026.08.06.02.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 02:36:57 -0700 (PDT)
From: Wandun Chen <chenwandun1@gmail.com>
To: catalin.marinas@arm.com,
	will@kernel.org,
	chenhuacai@kernel.org,
	pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	robh@kernel.org,
	saravanak@kernel.org,
	rppt@kernel.org,
	baoquan.he@linux.dev,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	m.szyprowski@samsung.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	loongarch@lists.linux.dev,
	linux-riscv@lists.infradead.org,
	devicetree@vger.kernel.org,
	linux-mm@kvack.org,
	kexec@lists.infradead.org,
	iommu@lists.linux.dev
Cc: kernel@xen0n.name,
	alex@ghiti.fr,
	akpm@linux-foundation.org,
	ruirui.yang@linux.dev,
	robin.murphy@arm.com
Subject: [PATCH v5 7/8] crash_core: replace for_each_mem_range() with for_each_mem_region()
Date: Thu,  6 Aug 2026 17:35:18 +0800
Message-ID: <20260806093519.2907771-8-chenwandun1@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260806093519.2907771-1-chenwandun1@gmail.com>
References: <20260806093519.2907771-1-chenwandun1@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Stat-Signature: gmupz93ybpdqey9t5j8fn5r4wuz7xf57
X-Rspamd-Queue-Id: 59E2C160003
X-HE-Tag: 1786009019-895598
X-HE-Meta: U2FsdGVkX1/UhMM9Hmh9GGYxBnZsVROzKy9WE75baFEGXgNJMEzFwcX9NbIPaj2zS3pYpAqBpI+eugQ7L5WLmnX7gD/pqX42QWcdws9Re8oD1L1rgDuhN3EJzmybk+Bd6se23MaqLd7d8z9BixT5+OkWKHY1QiVlzoHIc3XUVRx77JMFUGchOFG1hF5GotK+grazHPPu9PUhGP1G2NZtwDT3UIHzuyfWYVti9dkwgFGsKqNu10fG4b+/8oriSozVZcxu78/DsKCKjS/8VqJvjTY5gC8jMUFnBkAtk44RxRe+gJ4Z5qSVtfqCQU/+zu9LEkgOLAPoEiDKIPGogOdLWuO7q2vT/0TVANcbKeZ3B4jB+W8TGlJcpmI2BRVJlDZJGberboaiwTR72UhegoJN28g6ji7//7f3wUC43KKx3ejWi/iEHzXe83Zj/iKPXJM55LXUn8Gpz0QcRF8UYSMp2m1jGCE2cHWvEM/MLeAMIWmLR0S2nRTyQ4kyb79hfEBlaQNis1O8XUhYFyltQ3jHBydT2KrI53Yub7TVjypvYDLsRZ1rMe79rVJ0LQiakox48f/LJ5S9D0+BiXXXnySCpV0uTap9l3PG3AeVg1h0saQ+akhI39TrdzNEP2hZlic6RHdngWSSzNOPK3s5ElkI38NCepSd9mjQ8loE6isALBoVCaFjnlCI/uWhUr7+JoPrsTnATa24E/eWcDD4XYHBW80Bce02/L1tqa19WWNBhe8Hzbqdzal366feP/GKlmpT1KAOSSyoIaZo/cSj5jMZemm/pvjvBFcvRcq7UBLkIFk2rhK9Yg7YQXamZs++6+psVoNrZjizPDS6ZT2mUR161USg9sSm0P7XuXtJlTws2Oyq+Owl6tQi1oRAsT87r5uS5SpyzxyhINPqZb30QCKfy2F70pLujMiNu1gxXXuVkbYLwajZYI59ukXZyXf4mGpLIZVhN0f/FdiKewM/tyz
 L0ri3ODx
 uR8XyQFJ5+F0Uu9Yu1fAPQM6vQ4erfKZT4yEvQ5ohfigGvGDmlG0YyZscjHukhxR42hi73Sg2Qkvaft1eyx2449t1u4opjz7yU8Er1VzQvuHWA4v2w0+vXmbq+72PqquuVNB3EBu09oRsw6xCqC8vZ/kNpN+fq0hawggPPLrI9JEnJa2lJ2KaS2wA7ZVGPlBMY0V8tkIIX9Nv/08OpJ3PhukWR2FJjn854fh0mi1Ta2delzfFxFryyCD3ONF/3u+whsxXtRXfqBToptvoSMM0RsRd0Y+QD0yzgoK7Q9Od87MDIUbrdfz25dXCTVRmlBvmm2UwgPb4TcsUz/GqjzCgyvjkG9+CbH+VNjmcvib8PyJ5g391UraMtRnyBDV5Teb5HM7gdGk/1HW/CgSx/Tp6nEXuQRIcybK+r6bOUlCCKApRAafAQ4Mj0Muc7B7iyfi2zALWYVXGqU+kANYaxmjqZ2LOMDLlELkVTvz/CgkaUlUmFQCcIcK4VAQSC7QU76ZzqqqMZFEOT+LIm+Jiwk1bgnKGuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Wandun Chen <chenwandun@lixiang.com>

for_each_mem_range() skips MEMBLOCK_NOMAP regions implicitly. Switch the
weak defaults to for_each_mem_region(), which exposes struct
memblock_region and per-region flags, and filter NOMAP regions explicitly
via the new crash_should_skip_region() helper. This prepares for a
subsequent patch to extend the skip filter.

No functional change.

Signed-off-by: Wandun Chen <chenwandun@lixiang.com>
Tested-by: Meijing Zhao <zhaomeijing@lixiang.com>
---
 kernel/crash_core.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/kernel/crash_core.c b/kernel/crash_core.c
index 77285ae3ce60..fb78b7814f18 100644
--- a/kernel/crash_core.c
+++ b/kernel/crash_core.c
@@ -269,6 +269,12 @@ int crash_prepare_elf64_headers(struct crash_mem *mem, int need_kernel_map,
 	return 0;
 }
 
+/* Exclude NOMAP regions from the vmcore. */
+static bool crash_should_skip_region(struct memblock_region *reg)
+{
+	return memblock_is_nomap(reg);
+}
+
 static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 {
 	struct crash_mem *cmem;
@@ -284,22 +290,25 @@ static struct crash_mem *alloc_cmem(unsigned int nr_ranges)
 unsigned int __weak arch_get_system_nr_ranges(void)
 {
 	unsigned int nr_ranges = 2 + crashk_cma_cnt; /* crashk_res + crashk_low_res, +CMA splits */
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end)
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
 		nr_ranges++;
+	}
 	return nr_ranges;
 }
 
 int __weak arch_crash_populate_cmem(struct crash_mem *cmem)
 {
-	phys_addr_t start, end;
-	u64 i;
+	struct memblock_region *reg;
 
-	for_each_mem_range(i, &start, &end) {
-		cmem->ranges[cmem->nr_ranges].start = start;
-		cmem->ranges[cmem->nr_ranges].end = end - 1;
+	for_each_mem_region(reg) {
+		if (crash_should_skip_region(reg))
+			continue;
+		cmem->ranges[cmem->nr_ranges].start = reg->base;
+		cmem->ranges[cmem->nr_ranges].end = reg->base + reg->size - 1;
 		cmem->nr_ranges++;
 	}
 	return 0;
-- 
2.43.0


