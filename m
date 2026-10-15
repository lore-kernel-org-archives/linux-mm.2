Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02A24CC6B33
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 15:34:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA1A56B009D; Thu, 15 Oct 2026 11:33:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A79106B009E; Thu, 15 Oct 2026 11:33:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98F786B009F; Thu, 15 Oct 2026 11:33:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5DFD96B009D
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 11:33:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E6CB6A0AC0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:49 +0000 (UTC)
X-FDA: 85325255778.12.E55DA47
Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2A537180004
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:33:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QU39tp1O;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792078428;
	b=AHc68P+jnP3m4QmqI8kxqFJojxEBcMaViOzfxsGNHl3nGR3L4JSdPluQcRO2lKqt0WOnHf
	vW7gdIN1XJR7X0KC17ZEZfn9Fx00eBoglz+Omb/PhVCWsxLpKDh7MBIlqmN1hsaObXJniH
	SIfZa8+rZxx5BP8oA53oCDqab00OTTg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QU39tp1O;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf16.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.50 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792078428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XxAI2LBfmW3xr29v/N2DJy+DieVEUynw79jHC0KaBOY=;
	b=biHoDxwkI5wMfaGRoauWgT/+sk26ZcwtVFH7SyvHJdxz7JAim6byJXAcUGaFu1E9fWB3E1
	WLrYYA2XKJzOgkDjigPwbVcRnEwutwfcnYjqwuFrrWJwQ2WooG1HCCakyyeXyzsaCyZGOl
	e6yqemc3qY2vI8bdzgp//322FNxud9w=
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-7cb3388613fso1009857137.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 08:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792078427; x=1792683227; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XxAI2LBfmW3xr29v/N2DJy+DieVEUynw79jHC0KaBOY=;
        b=QU39tp1OecLYx/02g87ogYKA4PlCmRmJ1YpKiGzhN6zLuWR8bROR2QxZTq2wUWqs0p
         /svDzoAv2ful9OfwiiMoKNLRf1LZN6jyTpUzVFhSd5aMlqYGBj8FHz6DGvVqcYyKBmJR
         3FVapEZEkL1ZJI3np8R7SJC8SwX0YJIqdZaJDA3s2jqIdPzIfDSk+yTVk3hmD4sU1mXJ
         RFnEe0nmdda7/n/re0wK1y6HC2AwcZTbD2WJOZPQebEQnrx02nwB+Gz9lxt+TNqoYzIC
         BsAfsSltj6snLY8qLyDOQ/1649lxcXJJ6bFsc+czBPgr+xR4DKfrIWgj3R1qsPyeMnnB
         nJSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792078427; x=1792683227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=XxAI2LBfmW3xr29v/N2DJy+DieVEUynw79jHC0KaBOY=;
        b=C6bMZ7679t08J02y0cSwEncabDOdql3gHDf9R6Pr/DJjDOC2PqzbTlxZazvmCcRKiM
         19w2Hk1DWI0/mnGLBJW7BOHuirKLWFNx+X5fMM21WpqikeQ3OYqfpokS9lUeey3jktOL
         oID+LWWz4MEKMnZJ1THN0BVlBGyGYk6FcBMHW/VOFJAyVNO1ctXZiLNyHAGdizO5PwHG
         ouj6Wc09v7wmJgoItc4aYsuAagZhymTy9cD0FWHE6EvJGFuIaALC6isMpMn/HlugGxdC
         SCdlEbDU31rJFvoJoe7hC1cBIV/s+gI6i9XQPDck2wnG0YNuYcQ9L7xteNbAtiGL5RFb
         M4vg==
X-Forwarded-Encrypted: i=1; AKwUvBws9+YaIzxfYHP3d2V/GNPJRyOmcly8+0nVFhKmPabS3zSg3NaeYWM/oheRF8o/5bGjrSgMuGi9HQ==@kvack.org
X-Gm-Message-State: AFq9FYLCNdToxAeEpBDUpYwQhg3U0d5QL0P3r/qa9/fVTcy+oD7goTUr
	oSGcbmDVlcDI7rRwJUus92q8S0CBGRXJ4AJwofARdb35xl/zEN7VkUywTo8z2fCV2Rc=
X-Gm-Gg: AYBFou0GW9JvA6yA5M28jXPMifG7Z8dqdKsW4ftPqrRW91TtkCDS8NjTG5hvkhruvHJ
	2hYhaWgZkadvMV/Mb4eIfFTIAE9PYSJl5UgVBJQ06naDjayhaL4CmuPTJLcPC3LYnfzdaEWPdPQ
	WkPUdPjmQvpGBsZDsJZZADyKkbU6IewQPRpZbSGfqGwF51hL5usPWmEQkLGO7XNnNMNl81p7m9a
	94lkbIBGDrG09Nk9XTOZyZBySiqBZM6jMmUFLyQTv2+aPfrMvuF0vuULs58EQB2jX2SDRIaFdqY
	59qjAMWX3uEbC8tEwvNbv4qTpkCMtvmwCB/b0swKljbgdUi2Eu63Wd0h4rf46mTPH6xmf5gPGqe
	CmCUXu0I04JTW5K2TYPplnb56zY5O71/9GOR2UdUmCu2GNgCjsS87GCyDdTlBtcqnsG8bY/JQQ0
	TxIMyWfU2/Ykl6MuPjI7aAfxAHsPEFo+1n7hAhBDzlD8dqQm9VN7f97phAWMZw0+vN5dISofow3
	iYHSzuPovUrtSThtj3OqBsZoCo+sm/T8cXHcz3ospiJp1heoX7Y3WUBbBgNEz/J4V3RzSOz0JtM
	DMmdtj7DiCL/TuTEoEs=
X-Received: by 2002:a05:6102:3f12:b0:7c3:b15:a981 with SMTP id ada2fe7eead31-7cc17cf0534mr339488137.15.1792078427302;
        Thu, 15 Oct 2026 08:33:47 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-99003f66ad9sm12986347241.10.2026.10.15.08.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Oct 2026 08:33:46 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: kees@kernel.org,
	rppt@kernel.org,
	juri.lelli@redhat.com,
	nik.borisov@suse.com,
	tglx@kernel.org,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	vincent.guittot@linaro.org,
	bp@alien8.de,
	thorsten.blum@linux.dev,
	cgroups@vger.kernel.org,
	tony.luck@intel.com,
	david@kernel.org,
	mingo@redhat.com,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	seanjc@google.com,
	ljs@kernel.org,
	zhangguopeng@kylinos.cn,
	dietmar.eggemann@arm.com,
	mhocko@suse.com,
	vinicius.gomes@intel.com,
	tj@kernel.org,
	vbabka@kernel.org,
	linux-kernel@vger.kernel.org,
	peterz@infradead.org,
	surenb@google.com,
	hpa@zytor.com,
	x86@kernel.org,
	pasha.tatashin@soleen.com,
	dmatlack@google.com,
	tim.c.chen@linux.intel.com,
	kexec@lists.infradead.org,
	pratyush@kernel.org,
	dave.hansen@linux.intel.com,
	rostedt@goodmis.org,
	gmonaco@redhat.com,
	jgross@suse.com,
	mgorman@suse.de,
	graf@amazon.com,
	linux-edac@vger.kernel.org,
	liam@infradead.org,
	ridong.chen@linux.dev,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v1 8/8] mm/vmstat: Avoid redundant per-CPU stat_threshold writes in refresh_zone_stat_thresholds()
Date: Thu, 15 Oct 2026 11:33:31 -0400
Message-ID: <20261015153331.1872641-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.385.gd3acb90ef8-goog
In-Reply-To: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
References: <20261015153331.1872641-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wa6zxzmzofda9ibda93sfrrktfzy5zpa
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2A537180004
X-HE-Tag: 1792078428-877392
X-HE-Meta: U2FsdGVkX19IGvm5FnmGp2rU+svbGR7u4V4Y5Vq2ozzC9kb8IgHfxHQon49K+0EXALbnfdbINTnYK8t4LOtw0soIf5G+amv8JIZs9llsu/FKQG0cFcTvyzeJN02oGU+v7PdVF3qopsUQ6d/gy1tfa0sAXvbzwLeBzg1zBPUKAoil4gsBxfV0c2jpUoeSjITOOtZICaOt/LHYSRVqlLL6UWy5CqMBUF6U2UL4/c+gAQ5a5WyqIsPPE5n+pS6d7fMBU6uZDvyA03jvjWzWZQwCcJtD6EYvGffJqlOujULNLxFFBaizgfXmm9kNP0D/CxNOFW256hqoqkmsa43crxpl77A47A4KFsS3/gXbAr4cfb8s92XeO8S5Ph9rSHg+i7+Ysy5Gqmv6MjAjkCbHH9pfQFNDrEQxwIFFAAH2QUk55HOkmmzEW6byYGovE0he2iXLz/AAx5cJK4APliS/kJKgmDPbmvpUy2zYZN6qBnggXaKDP/Y6guu20mB8HucjRpCIDpMnHUMcVBwJCewTaScVqEwIJFRHfFlG8CaD8CxjupOdMVDl67bIoyhJyvcY1Q+R4EwiHvc54GpKlUs2ckf+f24gjuDBCIdnmpcQmQQkawymlouJLT9Vmf6XMwh9AmEqK3OwTWjSYbUMhvG88tfdFiXBzeMYcGXB5jCS//5mL95sj848RKQad6hew+u4cJCc2hHCVmuhbFCoQCLVNKOAYZ9I1H+eHwIBNp48oavQt4tHpPG+juFueKpYEufzOa2Rptqpqt1JT0zy9bwxHtULkSr1zW2qv9hUlTDIyPXDdG4+YufcBUhK2nGMi3HsDv4l9QODbfO0/3LGA0aeyKzdwIxCCLjbJEuVCXvuOjIVd96BpmUOyvNsrtHPSfwNzqDiVz82QWpKL/STmESRH47vCKLF/5EHguU3zsOyjhdLNYPvSOvHRAz3tyIUZPvW1dny+fKsbT+Rk5lBttGU96S
 8YWgW5m8
 Ok+tIea40YYjjYE0P3B5QbxbU4M1q47dXF/8EbhdVLE/hqR4Xh3Dv9j63osjtR4fkaZ33skLdaHOWxbMKO+vkI4aFqvBfuBvcogSPiihy+wbCionrfnbEk5AtXjGIC2XAvJVdssAqQBCtkFPfLAqFxkC6w3zTE7Ab/ljrtYHN+ePjsat+IfOOwRnuQaoYiQLK2tGtuvMrLtcX+P3ozdUzzKFEwls7mtvximsW6ilFYNPZoahiZfAlmpHsWBG6E0ranQDlDouNZ2Fw6WOeCWb4WypXlouCebJ4LrrIGUsGz0G/SwvMSg8G1ipAE2+6xdLtQF7dne96ydkbLYaUjWm+J5naQkoQh/LZ3PFIGCO/LWJRzIPR4lvNEIzLnYAbyAdWL+21JuiUKkPDDu9d7xh/A420oauh2C55Evjg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

During CPU hotplug, vmstat_cpu_online() and vmstat_cpu_dead() invoke
refresh_zone_stat_thresholds() on every CPU transition. Currently,
refresh_zone_stat_thresholds() first zeroes
per_cpu_nodestats->stat_threshold across all online CPUs and all online
nodes, and then unconditionally writes per_cpu_zonestats->stat_threshold
and per_cpu_nodestats->stat_threshold inside the zone loop for every
populated zone and every online CPU.

However, calculate_normal_threshold(zone) only changes when
fls(num_online_cpus()) changes (at powers of 2) and is clamped at 125
for large normal zones (>= 16 GB) once num_online_cpus() >= 64.
Unconditionally zeroing and rewriting every CPU's per-CPU stat_threshold
on every hotplug step repeatedly dirties remote per-CPU cachelines with
identical values (and briefly exposes stat_threshold == 0 on live CPUs).

Compute pgdat_threshold across each node's populated zones first, hoist
the per_cpu_nodestats->stat_threshold update out of the zone loop, and
only write stat_threshold when the value actually changes.

2-socket, 480-CPU Intel Xeon 6985P-C (N=479, mean of 10 runs):
  Offline:   3.37 s ->  3.09 s (-8.3%)
  Online:    2.06 s ->  1.98 s (-3.9%)
  Total:     5.43 s ->  5.07 s (-6.6%)
  refresh_zone_stat_thresholds() (cpu479 offline / online):
    1,158.9 us -> 135.3 us (-88.3%) / 1,468.2 us -> 128.6 us (-91.2%)

2-socket, 512-CPU AMD EPYC 9B45 (N=511, mean of 10 runs):
  Offline:   2.34 s ->  2.30 s (-1.7%)
  Online:    1.12 s ->  1.08 s (-3.6%)
  Total:     3.46 s ->  3.38 s (-2.3%)
  refresh_zone_stat_thresholds() (cpu511 offline / online):
    104.6 us -> 50.7 us (-51.6%) / 109.3 us -> 53.5 us (-51.1%)

Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
---
 mm/vmstat.c | 58 ++++++++++++++++++++++++++++-------------------------
 1 file changed, 31 insertions(+), 27 deletions(-)

diff --git a/mm/vmstat.c b/mm/vmstat.c
index cb57714539fb5..c671e9669b43b 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -280,41 +280,45 @@ void refresh_zone_stat_thresholds(void)
 	int cpu;
 	int threshold;
 
-	/* Zero current pgdat thresholds */
 	for_each_online_pgdat(pgdat) {
-		for_each_online_cpu(cpu) {
-			per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold = 0;
-		}
-	}
+		int pgdat_threshold = 0;
 
-	for_each_populated_zone(zone) {
-		struct pglist_data *pgdat = zone->zone_pgdat;
-		unsigned long max_drift, tolerate_drift;
+		for (int z = 0; z < MAX_NR_ZONES; z++) {
+			unsigned long max_drift, tolerate_drift;
 
-		threshold = calculate_normal_threshold(zone);
+			zone = &pgdat->node_zones[z];
+			if (!populated_zone(zone))
+				continue;
 
-		for_each_online_cpu(cpu) {
-			int pgdat_threshold;
+			threshold = calculate_normal_threshold(zone);
+			/* Base nodestat threshold on the largest populated zone. */
+			pgdat_threshold = max(threshold, pgdat_threshold);
 
-			per_cpu_ptr(zone->per_cpu_zonestats, cpu)->stat_threshold
-							= threshold;
+			for_each_online_cpu(cpu) {
+				s8 *pz = &per_cpu_ptr(zone->per_cpu_zonestats, cpu)->stat_threshold;
 
-			/* Base nodestat threshold on the largest populated zone. */
-			pgdat_threshold = per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold;
-			per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold
-				= max(threshold, pgdat_threshold);
+				if (*pz != threshold)
+					*pz = threshold;
+			}
+
+			/*
+			 * Only set percpu_drift_mark if there is a danger that
+			 * NR_FREE_PAGES reports the low watermark is ok when in fact
+			 * the min watermark could be breached by an allocation
+			 */
+			tolerate_drift = low_wmark_pages(zone) - min_wmark_pages(zone);
+			max_drift = num_online_cpus() * threshold;
+			if (max_drift > tolerate_drift)
+				zone->percpu_drift_mark = high_wmark_pages(zone) +
+						max_drift;
 		}
 
-		/*
-		 * Only set percpu_drift_mark if there is a danger that
-		 * NR_FREE_PAGES reports the low watermark is ok when in fact
-		 * the min watermark could be breached by an allocation
-		 */
-		tolerate_drift = low_wmark_pages(zone) - min_wmark_pages(zone);
-		max_drift = num_online_cpus() * threshold;
-		if (max_drift > tolerate_drift)
-			zone->percpu_drift_mark = high_wmark_pages(zone) +
-					max_drift;
+		for_each_online_cpu(cpu) {
+			s8 *pn = &per_cpu_ptr(pgdat->per_cpu_nodestats, cpu)->stat_threshold;
+
+			if (*pn != pgdat_threshold)
+				*pn = pgdat_threshold;
+		}
 	}
 }
 
-- 
2.56.0.385.gd3acb90ef8-goog


