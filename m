Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D08CCD3445
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 19:30:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B68E8E0016; Wed, 12 Nov 2025 14:30:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0668D8E0002; Wed, 12 Nov 2025 14:30:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DFB3F8E0016; Wed, 12 Nov 2025 14:30:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D1F8A8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 14:30:15 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9D2C61A0278
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:15 +0000 (UTC)
X-FDA: 84102945990.18.21241CB
Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	by imf26.hostedemail.com (Postfix) with ESMTP id CA08E14000B
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 19:30:13 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tjLKerDo;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762975813; a=rsa-sha256;
	cv=none;
	b=vx8NHjzTH3g/NVjXoWaA8ojM6R72BZokPg8YtPIfGymbdTBXdUFxpv10n83bH56WsTath9
	cbCf2UMUb63bQJpGuJ5pAZBEo5z9UXA7ytuwDisdVbC63Pw5Km5Uh0Uh5qA63BXG28jraz
	y/X30DtWbkwyfh7IafBD3l8sgdvoBHE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tjLKerDo;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.179 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762975813;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nmy6EhUdgU0DNpQaVrJpBZ6lZ48+dr4nIpOCH6X0C1w=;
	b=UwRWPEQdvwnvCxnuRxUEAAZxwZIbkCZ9gkYdlAenag4GAs9egZ4/z3sC8BzfNYLbH9jdU+
	cImyIyVZU2ZK/EqZtFyzl2jhFXNfQWN1vmjh8b717xivNoRi3zLkLjiWh7pa+0gl6PIA7V
	GfthUuv2JpcxexoEkRJo3hZvftvxHYU=
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-8b25ed53fcbso7093885a.0
        for <linux-mm@kvack.org>; Wed, 12 Nov 2025 11:30:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762975812; x=1763580612; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nmy6EhUdgU0DNpQaVrJpBZ6lZ48+dr4nIpOCH6X0C1w=;
        b=tjLKerDoJTzk0rX24vR9QwA0dcwzC6E/wuXtoHqaBsA7EnZFqLU3A1F/DMwX/apMEe
         CuLUk9+MdYEjiL74aaCtHP38GPqPzD5aFSsqsa6MLCX+A13vV+EjBjzbmMUOuoS8qgcS
         fUIGQ5lUSsNuCFYlDEquglo8FmGEOetg77fA7Fu2//m+emyTjJzKe71jiq/ETFDOFCMV
         T69nppmOXpP20pWXx4T94/XgGm8Ehiv4+W6qAaOmNFFWHCK+yhWsfZbX3TvQuGZPIYH2
         +hJ6VZ/s1g4aJoLVEBwiK5Y+8+7WsxVkPbAGB1BPkGofnmj5gH4TcPzKoLzWrB3urQUe
         zsOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762975812; x=1763580612;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nmy6EhUdgU0DNpQaVrJpBZ6lZ48+dr4nIpOCH6X0C1w=;
        b=NvRkEjPMALa6vs2mHA514MsWVg8n7q0dmHau0Mv4Ngz/pWQ5T4AlQfhET+VwcmY82V
         M+8nE4H9zI//0NDxt9ENbi00wxLl6Q9z7oNxskqgszaujw+vuarTQgce2BHWex8FxDRe
         Q+RxxQJRQEX+2/1mfh0LQfLc3PYLCqwrp4Ep8i6PcqG4cYwx7DRlx3MOVOirN9upD1wD
         8L4crVzeqnGgYgd8u9qOb/LuqbDoe5IpKhEA1egEmXrylV9np0I01fqmKi53XTg14JTE
         KRaz8XFe5XCUi1sR6wiCF/F3EoUM0AAgzTGTJfU4pPk0rZC4G6QAFKtofzfSd36C5/k+
         1udg==
X-Gm-Message-State: AOJu0Yw+SEtd5DMZfxxKe1r9RJS1ke+rMSc8rOXH5p5/bK/19IB/Gw1c
	YRYrdVU0zB5M5jVkZmoCrmnqeXxOhTCY0t1B2znYwvQiuPVVdEdub2tV5CLdICVVzTcaQY480vv
	qJf7q
X-Gm-Gg: ASbGncvUOOS6I2pDjUZmggG63BAIkvU2J8Q68mIl8XgoVFEqvcJo97sEO0HxJXTm6bs
	YNSe9IxToc2MtxSvRsKN3FIG/esajlk6CWYzNVfiBKH0ssOllJcRMd9XQwTmfHxm+pfua3rScSL
	aippTqpbsELUGVpwnNIja4U9GGFIo3dMugDQOEF9XChhxIg6FHJeiDzEHEiCnZ0JYlVQ8dqK9sC
	RCahInvrhfQLL9yoYvTLa8cQaKLQeTeYYZzFKw5LRx5T6xDO3k2qk/apBYN3Z6v992Y8K0SdXwy
	TI1sfat6XXjcmT0sIQiJ+mU5LbSVw+q3rcINDFQpEbPbMOzcPiw2r+MakHZXVojIrfgosNuLPjr
	K7KSbYEZxCW7Ia1im48P71u59H/2WQl7/TcSQX/g0nC0CRn13WElnwW5hRWC82I2ZkkW0twZbbG
	fCyPnrHYMFFpO7hvYdbv64uohoH1N4nZ7dP8gcme/LznQHuFGhhZjL1gaFWazTIIZD
X-Google-Smtp-Source: AGHT+IHrguqekTBYRBdFA9dxH70A9CcZsL7BjLOY758kp78A0w22ToZorWvEFBPVQ4lklZwp+U9JIA==
X-Received: by 2002:a05:620a:29ca:b0:8a3:d644:6944 with SMTP id af79cd13be357-8b29b74d7c0mr602392885a.5.1762975812194;
        Wed, 12 Nov 2025 11:30:12 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8b29aa0082esm243922885a.50.2025.11.12.11.30.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 11:30:11 -0800 (PST)
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
Subject: [RFC PATCH v2 08/11] mm/memory_hotplug: add MHP_SPM_NODE flag
Date: Wed, 12 Nov 2025 14:29:24 -0500
Message-ID: <20251112192936.2574429-9-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251112192936.2574429-1-gourry@gourry.net>
References: <20251112192936.2574429-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: CA08E14000B
X-Rspamd-Server: rspam07
X-Stat-Signature: kj66dcjoj9mbxs3syq3cgrb9z4yaej89
X-Rspam-User: 
X-HE-Tag: 1762975813-454018
X-HE-Meta: U2FsdGVkX18CC+ssmKZGrUpfD51OrGBZaOh6Vh+MkI4W77jA5kvJEjUsps6Xw1Vurn16C9pszlTBgRm+cEx678h45EbDvMRB201NIU1Q9VW1wJT7gVKwH61J6/YwNslMI++z1YGa5LIMGbt7GSzXNiDFanCsbsb4AOoSVQRljqSW49S+LGpM14VvfW2erDa5tiBZ1AQB/NuI/awRqPaSB7x/33Wuz3a1j8j7NYvXy4/zVXFA4YnefNL2JHG1Yz+tO9c/D6H1a9bZ21JBEPzttHdPxuT+27oPmdOaJVwcYT0Rb0+MMHwVinA24ihAp3vr0zHvnPiQrMiLo6Oowa3oCob3LGM8gCvzNQJEQYNgvtmPxp0/acZihutrrpK8AjlNgTiZgdG+FMWwW/Kebrw20R0fMF+rm+t1uEM3LMhrQrH8YX1VwSttUXxgfB3QLz3JKkp4jholAFn6Dn0DPNgwWI0IpPVRvjwH72KhS5Hh1jN3QN5y9wMY15tEeMe7rXL1OpI3KM2tzyeXAEsZ8d/5imsZ67GsVzmSxqncZD/IKqMHbtQPFKxZA9CS6we/6zz5mHVR5aKodU1xk7lUzhCdojyOsXpbzflwJOrBYF/UrzTpe8RTem7NAdapbJ4DhsmqmtS6p0XVKqpzqeksPLnf/36H0rVeXb8wmCvwFhC+HvvDykxbZ4+w6T1vmCoaScMGHabi0jZG+l/5qbaAkPyS7JT4ak7daPvRzadZ0D+TTnngneeRT/db3bqCImpJOYEgyLSva8vvqNBdJXawNZYuPQAl9k0gD7IWxWa80Ztcd/kXOEf9DdB2wQv35fvZc8EljkDbamzHfLEjVgHRIM512+maBRvwG8B63sMAH+f8dC0JK6//c1eulW4xaAzpjHmiTi3SPnMSqyuJoAM9LyURYrlBVC56/swoMMYx+z8QTiQuhBQSpQOHbmbkS8CeyamYWFUwHpnjF7oVOXmAXeu
 LJwKNc8v
 qdfPO00v42TGpYbrS+UPHZ04HQZzBVaejApJKNiQVHlVHiOgmQDvoqfOioqlTFHsBiM+ycAVpcMpxgVSrs2Ful4tVYldNPIuyDDhqKVFARRsSEuiGFnsuG9s13HIFJ0dsGqcQ5XiCvCRuSTMVNBHgHG2ZUShwe2BCUbozMYdn/fFdtyK/cvHzgKGDazGUqSI5rM8h4M+y4h09zFTqh7M9fLhemvzXNIxZd6P+lBYNlrPt6G35u0c1v/qh+T5m/OGEo9yg9eFfx5e43Jv1CugCVF2KdDVHiDYeD+A5XsB8E9wgu/A04YhnsL6jQjrL2Wiu/Og3RTslYg4G+QFNi9frA2i+Eg2Lv8MIkSpt1pI+qzEWePNjLYFmPi4bs175CLxj7I+VhlqVHybWGOvVMqCy3lBnHU2kAf+CR6pf0v1X3dZyGlqx8CkEHDuTZaZj9VYHwvYDdW8qbHPePEA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for Specific Purpose Memory (SPM) NUMA nodes.

A SPM node is managed by the page allocator, but can only allocated
by using the __GFP_SP_NODE flag with an appropriate nodemask.

Check/Set the node type (SysRAM vs SPM) at hotplug time.
Disallow SPM from being added to SysRAM nodes and vice-versa.

This prevents normal allocation paths (page faults, kmalloc, etc)
from being directly exposed to these memories, and provides a clear
integration point for buddy-allocation of SPM memory.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h | 10 ++++++++++
 mm/memory_hotplug.c            |  7 +++++++
 2 files changed, 17 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 23f038a16231..a50c467951ba 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -74,6 +74,16 @@ typedef int __bitwise mhp_t;
  * helpful in low-memory situations.
  */
 #define MHP_OFFLINE_INACCESSIBLE	((__force mhp_t)BIT(3))
+/*
+ * The hotplugged memory can only be added to a "Specific Purpose Memory"
+ * NUMA node.  SPM Nodes are not generally accessible by the page allocator
+ * by way of userland configuration - as most nodemask interfaces
+ * (mempolicy, cpusets) restrict nodes to SysRAM nodes.
+ *
+ * Hotplugging SPM into a SysRAM Node results in -EINVAL.
+ * Hotplugging SysRAM into a SPM Node results in -EINVAL.
+ */
+#define MHP_SPM_NODE	((__force mhp_t)BIT(4))
 
 /*
  * Extended parameters for memory hotplug:
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..488cdd8e5f6f 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -20,6 +20,7 @@
 #include <linux/memory.h>
 #include <linux/memremap.h>
 #include <linux/memory_hotplug.h>
+#include <linux/memory-tiers.h>
 #include <linux/vmalloc.h>
 #include <linux/ioport.h>
 #include <linux/delay.h>
@@ -1529,6 +1530,12 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	mem_hotplug_begin();
 
+	/* Set the NUMA node type and bail out if the type is wrong */
+	ret = mt_set_node_type(nid, (mhp_flags & MHP_SPM_NODE) ?
+				    MT_NODE_TYPE_SPM : MT_NODE_TYPE_SYSRAM);
+	if (ret)
+		goto error_mem_hotplug_end;
+
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
 		if (res->flags & IORESOURCE_SYSRAM_DRIVER_MANAGED)
 			memblock_flags = MEMBLOCK_DRIVER_MANAGED;
-- 
2.51.1


