Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42961CCA490
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 01:15:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2399E6B00CC; Sun, 18 Oct 2026 21:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1EA1E6B00CE; Sun, 18 Oct 2026 21:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0DA216B00CF; Sun, 18 Oct 2026 21:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BD6576B00CC
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 21:15:12 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1384C16065F
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:12 +0000 (UTC)
X-FDA: 85337607264.28.DA18663
Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 64803160005
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:15:10 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Idfio+iE;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792372510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k1COhzPK8MoPAOVKkuVJ9yCDV5Zgubw3w5lCCc8/uFo=;
	b=4PCQ0cB6M1FZ03Qjmzosan1HxJiaasdbXm4F7Y4iNxcsFXMMinZ/uz19+MEqeSREvJf6i/
	nr8XnHDFZwlGeMGVnRxKxSz3z/hQBXMJfi2Ts1LtRZWHW2XvKcuH1ZV3IQWmAIERRnNpIJ
	zdHZUuJimI+gK1EI463OLIWa3tJ8k6Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792372510;
	b=rXax8r/zEeeCD0MSnb35f94moeefSD93TpJFCHfBgSJ2XqGNyCkoj1QeYOPazZOJcEFlPZ
	taSpjadU0bg/UvBJlpqQlulZFGx4qxouO0zCMav4ug7lUMSEZtIsJVI4r3/srwkK+Fj4f9
	x0GL7xY4v6P7czOSwyfDKRLYtLfO/OI=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=Idfio+iE;
	spf=pass (imf08.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.221.180 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-5eac3b6b2ceso163659e0c.2
        for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:15:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1792372509; x=1792977309; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=k1COhzPK8MoPAOVKkuVJ9yCDV5Zgubw3w5lCCc8/uFo=;
        b=Idfio+iETpj6iCXzpDfyh5fEDxDxSbCqC1hTtMVBvU9nY42zQyuEwQw70l0qmFw7D4
         wqmgwThb8CRGHeAREGFWt2fpD5PVDHps0e2y0Vc1JcAyKUM44O6NyWBmvdH5EQhrVZk9
         cgaSIgpm10kxC1vv+63GEUCWciS/SxORsFTDVzr7V4xg7hIHUfvLoeYmDOg9IA0rdkPq
         nCba5elQmQ39mBAoCknhk6b68sGAXLVdA6Ooy8h+B0cp9vLExiXc+d3Mj1YS3lBXkhSb
         wi1cRvI183qVaK+AEVz2fFRfsHbgW88hBzNIZqMdtoD2jDcQGuSYZKYR1rTN8K+/Bnen
         v5cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792372509; x=1792977309;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=k1COhzPK8MoPAOVKkuVJ9yCDV5Zgubw3w5lCCc8/uFo=;
        b=pZ22wez7SegJwjqwUdyiFRYU5wZ0u6V0RS7rlSEL46X5rJ92iVYCmN5vKb2b+inoGx
         EsqdaoTyPri9YhS22JeLLzC2EN/M+Mdeb2CE3r6kMQmHUbvhJhKV2J0WBo75kajS2gkh
         RmOfREHdC2Li3ulbiWiByd4Cty58dwtb+lEUO2A3kAmSUbPsd8oejYq6ma17b9oILTPs
         BsEOobl+Ku8CLGotLInzyHtgzNGNPtqhk8RgS1rqpYDCk8yDyyvNfegzb5IXTIE2CBZ8
         CcCBlyGA3b2QKfzkVTUapabXCSYyLpmbp1MS/LJJcFB8CvmhHIpog0kca05uz3h9Cc7p
         VCgA==
X-Forwarded-Encrypted: i=1; AKwUvBxUALxiWr7frzCPlTE9QaDZ9frf16LxYSL9Z3LRdbMlbyJiEp9lGqJ1J+TDlXyYlGgtV0j1tf45ow==@kvack.org
X-Gm-Message-State: AFq9FYInnmz3qwqRyt5LFw1aD6X6eXJNKIKJIkm/ryV4XcH+Kc9Tvq6J
	6eieAjcJq02xn1cQEPTu+vMevxEeQLP/yP5FidqB0eV1S2nwVCyHkJ213w/t0IQHF+w=
X-Gm-Gg: AYBFou3v1gzC+Hv4EeTU0s+0bOBYD1pqGRz2E2E04RiOHx90jRVZU+TiX39ERc2Ll0g
	z1jK69PAA4RmzUTowPqYNyzL2uytMO5FqNavHEjZJxbxL0plaKM53K1k7SGcTVHTTsvxPvqbDAC
	XHh/9RPz5oovxrkvEhA4XrCNYWmXxFGM1QQ30eASZf2IrACR6Y3q+Duuo74nnzr3Be+UrXt3Tz4
	KHYx/dJ/jqPR32394foO0SxkTM1oI56JBHH94xkIdXm2WUwoJ8oO0fq8NIGAa4bp9bakz1Le7Kj
	Hbv0Hx2U93JhOmuh6O9XWLWL4GkkbWb1de2/JQoq7ajx4HGuNQErUkWzoJJCAxFI4HqAXz24RpU
	lRiO4XzR5lM9rGehG7lQb/lEvQyT5D61vnF1XEgFBkygiq+nMSpFXBR91JwU8PbwDwOhDAIoI3S
	EovRGeoAcDDaRGtBMq/J7OYeopL7FkOGejah8GAN1VgFXzVZO+nu3Odf3VlDzRrOhhtNBzGJQPC
	u/OeZkrXntNYZ2hsPmyI/WaSJR+dl068diAy/eTzbQ6wRRK0qA4EADQJAdoVN1UFPoELnOOGi/1
	CjoD6JdorYTHzHkUbr2H8va0iYfYZZA=
X-Received: by 2002:a05:6122:e14e:b0:5c8:46e3:ec57 with SMTP id 71dfb90a1353d-5eaaa0ba603mr2227545e0c.1.1792372508911;
        Sun, 18 Oct 2026 18:15:08 -0700 (PDT)
Received: from soleen.c.googlers.com.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5ea9b474b2asm8039142e0c.4.2026.10.18.18.15.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Oct 2026 18:15:07 -0700 (PDT)
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
	jpoimboe@kernel.org,
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
	blum@kernel.org,
	longman@redhat.com,
	bsegall@google.com
Subject: [PATCH v2 8/8] mm/vmstat: Avoid redundant per-CPU stat_threshold writes in refresh_zone_stat_thresholds()
Date: Sun, 18 Oct 2026 21:14:46 -0400
Message-ID: <20261019011446.834487-9-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.56.0.176.g3575e65682-goog
In-Reply-To: <20261019011446.834487-1-pasha.tatashin@soleen.com>
References: <20261019011446.834487-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 64803160005
X-Rspamd-Server: rspam08
X-Stat-Signature: yzfarcwjt6d85wit4eea11g4qaebjhdw
X-HE-Tag: 1792372510-53299
X-HE-Meta: U2FsdGVkX19Xpny0RYCDAtow5QV2T1nmyvz/Kh0Yn7yQe8jUmjxXQ6NnF8FI75v0VZED25hTNuPJ6OuegMwpDSikYibqoaNjUJb0fOpat2G1R5JwFrCZrLrWibdoiM6DPZAgq/yW87wb4rqemcPdSV1LohXpwiS3UUNQoKoyjRLRVRiFSHsc+PsfjafmQVCOSNbE6j0AWLrp3ixD7+T+bCG1mdx/j9toqy5tvaDg7DjbqSUlC38HEG0LjhLOjgw9EWASY+iDgLwea8FhtqU7xPS6mgh2e0RfMFQba/KfhOt+nMOhTYa4MRjW9St5iSy0Jd1azE6dJYyIaxSIW4DKAmTo4tSv/XQDDTOVVaXFZ85dLTPxb89GFTP3i0dIRu5zjKXtOgLtF7DX/0fMznX8R+e9u1yrx1PbFn5YMz+uHcEGRrKZXu2ppGicdu/d0iyH5ALMGll+XhtwEfrkHkkSz74IDMV60EVnsn31EL1RtAxMXcxxJTjP8NZeM0xSxXc2csnZ/Xlu8LOxFZ7XNrAUFILRNMFHQCh7u8eA53LOgvx3S+LzXuIqxQ7J4cjt9ROaBs1m7szdybmJ+ylAXj9sXUOgoYW3v1/ARoKTuudDA/h3D+PQM9abI6fyf7vbspRqXFo4eUVxQYedjpGHJ9uyp2OS9OF2gbAdSXhq0h6nFAVsMn4Pxz/aOC5e0R8Zms1vjjWOdSM2Z0Kv7HxL26gG3atnZ8rDsXfmmr7iqAvFvte2h43sf82hH+e4Ra3Gjh8jlRqm4+CJOGeRrXY1Ti1SxZYTouHEO4ilPb4UrG/iI/1T85tuSlKQIez4DLZFYdEv1VKatHpNvUxHZPUVvzTLgpd/ARmh3hPsSoSFLkAb6tn7SPlVSv4M9J7uZd5amE33TLM+H5OV66RikzH5dZfC43tBWD9qm7LVjgDR9g1KlK6goy4llF9rIEykVhsVWinhxIFRbXcLjrkM0/YIAdp
 UtfDX/Dd
 c3VXYApUBbtrYzPnQNkPxn74K2dCSDR503Kxq2OlwUFqF+hfrKJc4Ae+yVswo6i10oR6KDSL1tdxeuBRrpLrKr7hbKG577gDdbslKw6TSJPTC6+YcvRkIdBOEKLn6J4pvc6nlu8UFlwudDubOwCKyNczAw0E1DpUuZwQjtnNLF7Nj3PVqjRZqVaezF1q/ZH/BQ0h/FsYGz7KJ/1GzKY9v8KtDYgqQipDY0SyqiaFHhMYatyk9K716wSEdjWNB7fEV2Ijne8jVKT0uRgpKMVTkXez2L3ETeksEfr30I740EqTiuHI7uZOQEqDjZODUwPUobNWx/mf5uU1MKhV+QpYDUQf/S74Eevr0NKiCX5yRn+dSNe84T8gbEsaOmxYRdcbN2W05NNxxOmkR1yLMyRJ+k0FZAhxVn7oGfXfy
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
index cb57714539fb..c671e9669b43 100644
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
2.56.0.176.g3575e65682-goog


