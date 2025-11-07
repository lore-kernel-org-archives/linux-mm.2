Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B7CCCFA18
	for <linux-mm@archiver.kernel.org>; Fri,  7 Nov 2025 22:50:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F1718E0028; Fri,  7 Nov 2025 17:50:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4A2DA8E0006; Fri,  7 Nov 2025 17:50:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2F4678E0028; Fri,  7 Nov 2025 17:50:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 201288E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 17:50:25 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D8ED359770
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:24 +0000 (UTC)
X-FDA: 84085306368.11.F2BEE09
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 14B298000F
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 22:50:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IRfCRBRd;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762555823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=THbr/Y85WnAbuULOZYzy4wMGCXZ829d22z7gMjfvDN0=;
	b=F5I4yaZorZg06BFFMHvefhpJcOjgnoygF8F/xYoKKq1szRqMwdfZVgI8f6Q0WRCy2MrDf2
	BlVrqYSg6S2T18i5LcIMVEbi1mwmpm/0lv26amkyGYU+M9PN/poOba98GMT39syzAZ6N0h
	zbc49hezlgTrYbDzzfB3TezTdo8bC0A=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762555823; a=rsa-sha256;
	cv=none;
	b=ux9VosRqu82FOmiB6GCGjP3ssLhpKdl3kwPPk/MUomLAqMX7tbjDB4c6fob5a0R1YJ8UNY
	BQXwYcN/Qa15jCfy4QAHii7/FIXFhPhOCvBb+4IqzlGQw5mNgWKsZekUezfOZAX02xM3ir
	J5B7TpQkOWUYrGA+2JSAl6Ceg/6oD/8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=IRfCRBRd;
	spf=pass (imf02.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4ed612ac7a7so12441801cf.3
        for <linux-mm@kvack.org>; Fri, 07 Nov 2025 14:50:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1762555822; x=1763160622; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=THbr/Y85WnAbuULOZYzy4wMGCXZ829d22z7gMjfvDN0=;
        b=IRfCRBRdXv3GEG7K5JywUldUaYFHMfXueLki3qubt0f00x33Nf1D+d8F4z9MDEpz4c
         2OdQrh3/bpreMhPjNMFO3BgbBZj4FMf0ajGHs74DT1JSVI2EXumnvohiqSI6hdGDXUh1
         92Xkk5wNiNSxREdI/oK97lrZB8Dfgzd3yN6eAK9Vtv1GQ8NHr2iS/N9oBqeal7Fo5i36
         vrZ9USsAnawS6qv0U55DVBMzH9xT/jy95F1Y6WWqwnChbPMLAZnVZmWnXPcdvQ1W5CoL
         lrWvDH2vJHUnZcGJrMPEcDp7VvyV3+yLqc5AEAGkVqGXuDt/XFHIRRI+2e1mIK6sci8+
         ZWZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762555822; x=1763160622;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=THbr/Y85WnAbuULOZYzy4wMGCXZ829d22z7gMjfvDN0=;
        b=TIzlJB2KwIBl7ryv8tmOA20dARj/Z6oOihYqPJNAzlmvgySLRb6Chf6wHnZiILVRxX
         mSKPZas30i78cDC5YHH9yvtU//ruyh7dhz176V8F/DHUP9CDHRWi4tXt3HuPI06/8437
         OHo0yfp6vqdQ3oiUexswEIGpVVqwAqnUpGqpV7X91FvFWWP/+MjEqUaKRfIsnpPil6dx
         AkeLStI18QmdKdylW6FBkNYJ4/ZXrtaODdOAIhnkQ2Ldi4xb5NqbG/A0eqvBMVdF2SMX
         pE6P5gZJWjL4oEVO1M2bW6E8CmHYq48oe5O6qVNnwBMSQ2aminlpxWO1V9DsEVqla4X2
         MI9A==
X-Gm-Message-State: AOJu0YyrdRVjkZT8bbY7yHr9vKrIy21uDJmS8T8DZ2agDoQrz+w//Thm
	IlNL611S6kcQ8CQ9svMmMiSPjgPDxyVRUvteGRyZHWIZaviXB3KB5T0QXtwPmjUoJF5U1Wu6rvA
	ib7XW
X-Gm-Gg: ASbGncuQu7MQdyNJm1D56hKh6uVzfFa8uVTc6RBBO4qnqgIUq61llb1DBZdY7rsDdA0
	a0je3/vJwUaTvECJ/9wrchYDXNEBFyKBRBaNTkT0lATIOcJ/xmy9udXet4q3z17CyNh+33Pk/eM
	KXRKEAIo2+y/nzEMQKD3zlG1sHP4NXYwwNWjl4qKCKrDw79jJkPsWoPd/uX4LCuRqrAwMdCEYe2
	2A3DIu4mFwZZb81OG6HRiHq3L+Ti1lOq+1zhRcYJay66VnGBsjcQ8e6svUwq9xv061aGiVFexxb
	n+/mZJP0TVQ5duGmwP1XywiXMisLnHZd2rMVYbjRCgmvOCWHv201aisBtrKWaGlB8ibhPF6H/Si
	WQIPmKy1SbdlzxbBeuI7TLhEtGmfsXNelzyHKJAvMi+9Jws4aVbpLPJjx+oq9Yn0qFs4E91qOZM
	SVypDny2iDq3Ah+milCUl+UU/5pdtXhB4/hEC+j7Ww7WqQCfrgKp8KHvN4TixTwtKcKLltY1MbX
	Bz8DxR7pkMB1Q==
X-Google-Smtp-Source: AGHT+IFWQljTxYPO6CFPNauC805q+VElYGBru+/DO5QGOLDAxl11WHp9VZk3rhHcoNcRJaJ5IM73qw==
X-Received: by 2002:a05:622a:386:b0:4ec:a564:3e66 with SMTP id d75a77b69052e-4eda4ec8aa5mr11288381cf.29.1762555821864;
        Fri, 07 Nov 2025 14:50:21 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4eda57ad8e6sm3293421cf.27.2025.11.07.14.50.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Nov 2025 14:50:21 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-cxl@vger.kernel.org,
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
Subject: [RFC PATCH 6/9] mm/memory_hotplug: add MHP_PROTECTED_MEMORY flag
Date: Fri,  7 Nov 2025 17:49:51 -0500
Message-ID: <20251107224956.477056-7-gourry@gourry.net>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251107224956.477056-1-gourry@gourry.net>
References: <20251107224956.477056-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: sm8ibs4uah4k5bd5s5bnkqgmw7a6gy4r
X-Rspam-User: 
X-Rspamd-Queue-Id: 14B298000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1762555822-823809
X-HE-Meta: U2FsdGVkX19q+tNVy/Ij08ATFKs5MkvTimPjrdDPgk6RpHhYwn9eG62CrXjPjCvVVT05GyazmLB3CHciuYegw3bY2Er70kZNNvVKIQPvtmRB7b6Ge4sRCpGnbasePUgdd8wrhRY3ZqAjhI7T6/6VXuDcjIx6LlhXodOhwrLOu8Mhz3/cnl/GOfs7xrnfcVdAIM2kSaE6MuaXx/fxpbxOrzLA7frh05bOgr3gbjCAR5AMqBb0A3rTxsrxzOcaYPh05p0tQyhBK0XKe7sm5TFpQ/LT9b2cZqdliJBJPNPqLptuKCyYjXvkJWF4bWtnLI8W8jrN3GII3Cr17TCM9VzHJx4e6PZjkMVOuBBs5w1TgvrUKztZwqbElGGhIuQFiPBZkSpHMU5HcGSAxrkETYUPnZ69eB9uR0Pp1/S1/3b8OAJERxyvvqUvgXACNplpNX9NZJvXnoOAdB9mV28cjA+KPUFtMJbAi4viHE/CoFxtbbjDymUy9JJJUgoUUuY3OKhGSFWoT2mIY9GsGJtPoTJ1SmRks1pObIGaC8qFSsYlsD+Ak73Ov+kGm9Tbi5gB1q0iQpT1dlNg045ir3LFCOIM0InxqMtMd+3DeWlIviUkMQXZWsI9VG3z+pnyiIlmsVRqEcc89/eGE03NrYOJ6s7YEA4sTMPw1qxzoUxB6uIcE75IEstmbnowPFjvqD5Duuig1JB/l7h73yvysanvnaJw2tZVbarJJ1L1lYajt6+20GRTsaiyDo8lc2cU6AsNDX969IXmUcQe9oPw9eTCDsutX7giFH33bvU1REuC0uE9Ie2k4hGewinpV06+HbJXEHGCQ3/qFAa8JSB0LSbzkUVX2jPNWP2eZpJfCd6a7ZBWm0lFyO+AFJCuc/f+fTIvPL09GPluKYXMUUcEJ7oojOgBJLCSFfIvZiTani+iHIIroXgFayQWh0DkYt4R6JRmQFzzl0Jn6qfiGYd9V07JVDD
 jNBd4lC4
 2rp8TRRkMlibmPSNTwwF/m7r8DaFebBKBuaMFdLxn+PbqWBuBOCOpUit1kd36XquU/VN5i3MEx6+Yk8OLfXhmoxJulbElsRwvawOBGv43FlsbdFlbrFOMMsOYErnABNq7s5TrCVO+IvOIO7WSTP+mZ2bija3hVmq1+upT+R8DzHUUIlwc2qiIFhNfqneATO/HUO9vipJqCFOCNwABa318+OK7p3xKGwKUj6UrTOIw46epgjx1hvzfOaHuaTLZX/uOV2GPk9I15udTIISGIc2tqGNMrk8dOC6+wQxx6bmhaDzbgh3RxVmRl/jqB4BBREZS849O/F0RNETGqICCF9riwsP6yCATVT6IdiXql2wYvad87O96ewZz3+kL2IXVW+dguUH8VkaFk/W91o1wLMqRxGjkwR+U1jsMumknCbA/c71zA+lalY5EJth5mpTc99hP0ItrsUBZVcMoSw2ZaH/JnPEW3rLwovpfdIY/VLQh+g+aFxpNhoc+V9hj7Tq20v9vdePi
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support for protected memory blocks/nodes, which signal to
memory_hotplug that a given memory block is considered "protected".

A protected memory block/node is not exposed as SystemRAM by default
via default_sysram_nodes.  Protected memory cannot be added to sysram
nodes, and non-protected memory cannot be added to protected nodes.

This enables these memory blocks to be protected from allocation by
general actions (page faults, demotion, etc) without explicit
integration points which are memory-tier aware.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/memory_hotplug.h | 10 ++++++++++
 mm/memory_hotplug.c            | 23 +++++++++++++++++++++++
 2 files changed, 33 insertions(+)

diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 23f038a16231..89f4e5b7054d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -74,6 +74,16 @@ typedef int __bitwise mhp_t;
  * helpful in low-memory situations.
  */
 #define MHP_OFFLINE_INACCESSIBLE	((__force mhp_t)BIT(3))
+/*
+ * The hotplugged memory can only be added to a NUMA node which is
+ * not in default_sysram_nodes.  This prevents the node from be accessible
+ * by the page allocator (mm/page_alloc.c) by way of userland configuration.
+ *
+ * Attempting to hotplug protected memory into a node in default_sysram_nodes
+ * will result in an -EINVAL, and attempting to hotplug non-protected memory
+ * into protected memory node will also result in an -EINVAL.
+ */
+#define MHP_PROTECTED_MEMORY	((__force mhp_t)BIT(4))
 
 /*
  * Extended parameters for memory hotplug:
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 0be83039c3b5..ceab56b7231d 100644
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
@@ -1506,6 +1507,7 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	struct memory_group *group = NULL;
 	u64 start, size;
 	bool new_node = false;
+	bool node_has_blocks, protected_mem, node_is_sysram;
 	int ret;
 
 	start = res->start;
@@ -1529,6 +1531,19 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 
 	mem_hotplug_begin();
 
+	/*
+	 * If the NUMA node already has memory blocks, then we can only allow
+	 * additional memory blocks of the same protection type (protected or
+	 * un-protected).  Online/offline does not matter at this point.
+	 */
+	node_has_blocks = node_has_memory_blocks(nid);
+	protected_mem = !!(mhp_flags & MHP_PROTECTED_MEMORY);
+	node_is_sysram = node_isset(nid, *default_sysram_nodes);
+	if (node_has_blocks && (protected_mem ^ node_is_sysram)) {
+		ret = -EINVAL;
+		goto error_mem_hotplug_end;
+	}
+
 	if (IS_ENABLED(CONFIG_ARCH_KEEP_MEMBLOCK)) {
 		if (res->flags & IORESOURCE_SYSRAM_DRIVER_MANAGED)
 			memblock_flags = MEMBLOCK_DRIVER_MANAGED;
@@ -1574,6 +1589,10 @@ int add_memory_resource(int nid, struct resource *res, mhp_t mhp_flags)
 	register_memory_blocks_under_node_hotplug(nid, PFN_DOWN(start),
 					  PFN_UP(start + size - 1));
 
+	/* At this point if not protected, we can add node to sysram nodes */
+	if (!(mhp_flags & MHP_PROTECTED_MEMORY))
+		node_set(nid, *default_sysram_nodes);
+
 	/* create new memmap entry */
 	if (!strcmp(res->name, "System RAM"))
 		firmware_map_add_hotplug(start, start + size, "System RAM");
@@ -2274,6 +2293,10 @@ static int try_remove_memory(u64 start, u64 size)
 	if (nid != NUMA_NO_NODE)
 		try_offline_node(nid);
 
+	/* If no more memblocks, remove node from default sysram nodemask */
+	if (!node_has_memory_blocks(nid))
+		node_clear(nid, *default_sysram_nodes);
+
 	mem_hotplug_done();
 	return 0;
 }
-- 
2.51.1


