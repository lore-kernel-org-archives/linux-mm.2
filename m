Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A37BDCD3444
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:29:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC008E000F; Wed, 12 Nov 2025 14:29:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B50C8E0002; Wed, 12 Nov 2025 14:29:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE4AC8E000F; Wed, 12 Nov 2025 14:29:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DED1A8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:29:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 38DA6C0662
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:29:57 +0000 (UTC)
X-FDA: 84102945234.09.A44DC16
Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	by imf17.hostedemail.com (Postfix) with ESMTP id 63CB94000E
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:29:55 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fyl0OHiv;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sCG0uhUeeA1he7Dw5Q3elz2n5ZNHYlg7H15kRGg6IlY=;
	b=CTseFjmNHUMEjpqQoIhv2MYGwxCcEtPlHfHZGRgXAp70ZKW8bDCn/oGGSDj+7K/T13xvrp
	931R3rchTuMM+OXkUWjy0lXWR5MlBwVxhv1jh+IHhhFpvp22ex7Ya5kUXsW82OxMxn+rbP
	0iHeF05jcfdvjaGO8RBajogaHyRjbJk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975795; a=rsa-sha256;
	cv=none;
	b=EDodkjswSlQuaJpRUf+tRaX/Vd2LayIozERmccG8LKtOSuYeTst9qV0GA36K9xiCERcWth
	Baq7dZs227D4LgaT42Wxog/9OGtje30rNh28Gt6s0crKu8YUH0TmIvTPNrh0GkgJuEPb5d
	Lrt3Ef6ATBMWa63i+xlAcwwbHASc5fw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=fyl0OHiv;
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-4b109c6b9fcso10872761cf.3
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975794; x=1763580594; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sCG0uhUeeA1he7Dw5Q3elz2n5ZNHYlg7H15kRGg6IlY=;
        b=fyl0OHivpMU75N4qfthCl2ZbusWDop+V+g279CleAoH9b0w4dJNspW8lG/T8LPM0mC
         MQWc8P4kWgItRxdkxzkBk0BYWWjszYMt5eO4qv+x6fASMcRGs/eaDLeyv0rfAK2QcNYM
         gdPiSS/8k9OyEhRO2hWh0L7w1hHsURQINBNjxV8GP+LJNQ9FVmX3+6i4qtvIiq2VWMHq
         lpGK46vg/NL/cvmonSV+1CLubj+KVmmucUBDo5gdt3fB1fvRRmkv3YsIjF5pr9KxtjEU
         cdCb0e9m3Ovy4O86u354+5tOKtPxjuvWynMt3sS7SwoXMTUQ/1lnGDv1GUiYydzNkJ4h
         vl+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975794; x=1763580594;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sCG0uhUeeA1he7Dw5Q3elz2n5ZNHYlg7H15kRGg6IlY=;
        b=CER0BmfL8RvXtFpRqW1IJ/D53O61iMox6fQL/YZ84heRkTsI5yAfU/+GMrAD1tOMix
         IP38TfatX0k6hjO4kUYcvVUYQk0qd7TRxoYU0xW7E/aZsWdKGwblu/d3L0kusKvKLHL/
         9YVVNvW/jy0UX+xqDSLUpTup/apNPimluIcH7rgWfj2Hb9dH5khPokyP/JfVVBLztehI
         8Ryh1p3EIcDUjiUZpQQtJhg/g7/HDPx7jGmE313rcAZAnHh/PRXAfCcBX+LIbnB0K+yT
         Q4n0X0Ka4+3FIkvFEn3VhE6VwxkR71qSHrhnQlot97g7uEWuZk70o+1OEfTb01pit+DT
         1IJQ==
X-Gm-Message-State: AOJu0YyKZYQZm97hCtGzakzvhdaYPXkBm9hrDDFGHdHvSl6CDQIN8iCs
	idC61Sw6eXy2xJMf4jhTSrxynPsOSvjMpxR9FBeYV2Mgzxc2V2mk1c7YO7l0UJPrQUlgOOLpR7R
	eU1Kz
X-Gm-Gg: ASbGncv7SfkWdUU+YGKbkSs4SLxPKEpwGkNFQJmSYrTvSczoW69o09SZhR/7w/nQE//
	jkxJUBlREqa74boR9P7O250C7isWdkTjglxunNXlcU5DC+ZMYAIxWHAG8C2SdEFNr6pAQHfKyKP
	A93EYBwOxaag/hXa1PZRgmzJtp6+Jq4ljGwFozcAfUDXUaiylsVCCOkATZqnzmBRojJ0W4PMWKP
	JPQQG1BpDCfLR8sYFYGvJM9vijkpl64/f03NHeF5gSr3/3Jg7XrwsKePTSCnFqlen1F8BJD/dST
	ZK6vGxf9x+pT6fhKb7mBNXhiZhcjydXhHj3KEaCvz/gMjOecDdiBbOtaOKSL+HycWGvzkInsxNZ
	yaHpQiDHAbQC3ix6lysJ4Azx8eCe6YomO6bzslvAPiPW8sM+LgicU3TCkwQ4CS4vWv3CR1DsYpU
	nTp2ri42/wxT02/yjpsFF4z/z8D/HhMlGwLgOkn6W1TGgO8rOrRpmAOwFWW1L8fa+ahGnAFnQ2c
	AQ=
X-Google-Smtp-Source: AGHT+IHnM9b4iMhaMM3Umfgp794GytPagXJHdOPIuSBhJp6PMVhTsTQsQQE9eWpDhS66Z0o2IvV+zA==
X-Received: by 2002:a05:622a:2d6:b0:4db:db96:15d3 with SMTP id d75a77b69052e-4eddbd61fe9mr49171401cf.31.1762975793923;
        Wed, 12 Nov 2025 11:29:53 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:29:53 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: kernel-team@meta.com,
	linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	cgroups@vger.kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	osalvador@suse.de,
	ziy@nvidia.com,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	mingo@redhat.com,
	peterz@infradead.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	dietmar.eggemann@arm.com,
	rostedt@goodmis.org,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	kees@kernel.org,
	muchun.song@linux.dev,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	rientjes@google.com,
	jackmanb@google.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	zhengqi.arch@bytedance.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	fabio.m.de.francesco@linux.intel.com,
	rrichter@amd.com,
	ming.li@zohomail.com,
	usamaarif642@gmail.com,
	brauner@kernel.org,
	oleg@redhat.com,
	namcao@linutronix.de,
	escape@linux.alibaba.com,
	dongjoo.seo1@samsung.com
Subject: [RFC PATCH v2 02/11] mm: change callers of __cpuset_zone_allowed to cpuset_zone_allowed
Date: Wed, 12 Nov 2025 14:29:18 -0500
Message-ID: <20251112192936.2574429-3-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 63CB94000E
X-Stat-Signature: r8gscp8mmksdxiebkjmo1pjkerjzb6z7
X-Rspam-User: 
X-HE-Tag: 1762975795-701254
X-HE-Meta: U2FsdGVkX19i65GiN0026iH/SmccBeFDZt/TrIHa7RfD/GOeTNOS4K0f3uBoYqljrGOzh67py8It9IryS+Py9a0nSkPE87Rd32XJ6KSoeKAjj9aOb75Kez+v5APd9UtjBGcqhJ15aZjz5Uhzl4vRQmpcjMMjRWvWNpXPo5I+yUiIh5n8EvdEhAeRXJJX5RjnHgHhpw5mLF0Cik9vqeXfPO8I6oBpg5G2T5zg3yDDs7VThj6GaG/KEYSqdH+qTLq4JBtdzAGbZQ9tbvFVsNcBPJZCDiQoOL4W1NiaILBVRMBletxVLSABIZ559Uo+4qaOSHU4lZ0MlxZqNXz299GiuXanpeiGqxMJZpAJnp7YnWbXB/KuMSaYsEoFe/+aqgJsstBtBYJ4ZwTD9N7GYhbvHXK+hPDvx2ZacFICDzHsLuGCA1a/uxPg19ETnHRBt2/sA9XS+ePMK/HLDGIVDt9z9Jd11HEr4WsvyN0AkvxJbOdbpXJZ1CdtgI1gHNMkkr0Gx2bh/K4fjU+M5Ar/6OsKAo+91m+YoqsaUSaAIm3z0gS0KNQqRgL1UiZHp9kJAvjYcqh7F3BmL3Sw3VWHjlkLX507Oep/XXxXBZLGjMI26X+Mc4ggNj3ul4PJHQko5dEhrKM2Rc0pQs1fAJ8QYcbahCvPQ69FmnK8lSOcAqVfIWN+PlNiTVOIrVNs8KgjL5b9+Ns9Ar3fDrk65AVgDv9QgcPXVJ11waS2r/dIukAxHMNvgDWuyeu0M37oVZwsX3hgfESex2W6n/8zvrtnh1SFLj2d1yfxKx0cG4Kl116W+XIWYkNeVWY0ZPuPpxqtUoFw9HaRZBliCeeZj2HimbXfRGbf15cYLnEkihEurP30s58Ju/2qK6aeunPzrd+oI9mzQ7IxPKu7sxKO76e+N4xIidZ3EDyJ5q1/J4QA4+9CIikVmhFkqbeogv681GFltZ2M28jpUpDGGJi7gVuWZCz
 tkU+Kf3B
 7hj2CDvdVPXPdS19Yw5aPCgH+WuZmwW3P0g7dQvucrSyp4VYvyj/hxJDCtv1TUymS8fu5OA8DSkUwd7sJtzMFiwRQ2pfMaEVaYfEh7VUX34bx51uUyx/2tO1knGcxhZAO3t85UV88Zxmc2Nk/fzt5E9x8ZrQ4Kqpf+pz4+/N9UJxjXiaFb1J12R/mAS8nuQMKBjdHZTgwpMcQJUDFQRVpY9ACZL8d+MlEphykUkncgUnACEILthumEK+/7i8l0YwWIp5a5xiord/5WJkS5ZobGojh6xF48yLWGr6/XRl2RnQYDVBH2qFBV6U2/teSJzOqW4bIGacA+zGp1IrL+/llKIntFaiOPvW3iNEtlM1F/PHS0AN/c5yrOi4I6i9y/cp3w6VTdwNm/tDFdbNcTvZtTQDcC9XXmU5j/5BRFh17P78M1mf0A57yTHtmE1YHVRwwGxsVZzKO33edO44=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All current callers of __cpuset_zone_allowed() presently check if
cpusets_enabled() is true first - which is the first check of the
cpuset_zone_allowed() function.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/compaction.c |  7 +++----
 mm/page_alloc.c | 19 ++++++++-----------
 2 files changed, 11 insertions(+), 15 deletions(-)

diff --git a/mm/compaction.c b/mm/compaction.c
index 1e8f8eca318c..d2176935d3dd 100644
--- a/mm/compaction.c
+++ b/mm/compaction.c
@@ -2829,10 +2829,9 @@ enum compact_result try_to_compact_pages(gfp_t gfp_mask, unsigned int order,
 					ac->highest_zoneidx, ac->nodemask) {
 		enum compact_result status;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if ((alloc_flags & ALLOC_CPUSET) &&
+		    !cpuset_zone_allowed(zone, gfp_mask))
+			continue;
 
 		if (prio > MIN_COMPACT_PRIORITY
 					&& compaction_deferred(zone, order)) {
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index fd5401fb5e00..bcaf1125d109 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3750,10 +3750,9 @@ get_page_from_freelist(gfp_t gfp_mask, unsigned int order, int alloc_flags,
 		struct page *page;
 		unsigned long mark;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if ((alloc_flags & ALLOC_CPUSET) &&
+		    !cpuset_zone_allowed(zone, gfp_mask))
+			continue;
 		/*
 		 * When allocating a page cache page for writing, we
 		 * want to get it from a node that is within its dirty
@@ -4553,10 +4552,9 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned order,
 		unsigned long min_wmark = min_wmark_pages(zone);
 		bool wmark;
 
-		if (cpusets_enabled() &&
-			(alloc_flags & ALLOC_CPUSET) &&
-			!__cpuset_zone_allowed(zone, gfp_mask))
-				continue;
+		if ((alloc_flags & ALLOC_CPUSET) &&
+		    !cpuset_zone_allowed(zone, gfp_mask))
+			continue;
 
 		available = reclaimable = zone_reclaimable_pages(zone);
 		available += zone_page_state_snapshot(zone, NR_FREE_PAGES);
@@ -5052,10 +5050,9 @@ unsigned long alloc_pages_bulk_noprof(gfp_t gfp, int preferred_nid,
 	for_next_zone_zonelist_nodemask(zone, z, ac.highest_zoneidx, ac.nodemask) {
 		unsigned long mark;
 
-		if (cpusets_enabled() && (alloc_flags & ALLOC_CPUSET) &&
-		    !__cpuset_zone_allowed(zone, gfp)) {
+		if ((alloc_flags & ALLOC_CPUSET) &&
+		    !cpuset_zone_allowed(zone, gfp))
 			continue;
-		}
 
 		if (nr_online_nodes > 1 && zone != zonelist_zone(ac.preferred_zoneref) &&
 		    zone_to_nid(zone) != zonelist_node_idx(ac.preferred_zoneref)) {
-- 
2.51.1


