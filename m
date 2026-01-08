Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC5BDD1D48A
	for <linux-mm@archiver.kernel.org>; Thu,  8 Jan 2026 20:39:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3DB786B0098; Thu,  8 Jan 2026 15:39:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0616B0099; Thu,  8 Jan 2026 15:39:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 253E96B009B; Thu,  8 Jan 2026 15:39:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 13BEA6B0098
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 15:39:02 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B103057F1F
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:39:01 +0000 (UTC)
X-FDA: 84309960882.24.4935256
Received: from mail-qt1-f196.google.com (mail-qt1-f196.google.com [209.85.160.196])
	by imf10.hostedemail.com (Postfix) with ESMTP id 11DC4C0008
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 20:38:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eznkfhrW;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.196 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767904740;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rRDiJ+UlJzmE9gGlU0qCIeblmwRaclHqLNtsuAzr4HM=;
	b=u/tC6Wm/PmQQaChhJywbebbPcf6qOGRXDTRZOCa8lWGzggD9u3ETHFkygU5ZO3KT2TplrF
	OvVMVbOptSaXfmQQhUz+pSCpvWsZTAQzYYZUaGH9BcV/L3FGTGXZwqOslvM3xtE+mBL8uh
	KMIz0pG9uNdXoq8wSrMh4RVPxebinNw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=eznkfhrW;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.196 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767904740; a=rsa-sha256;
	cv=none;
	b=CegA4YysvONOGPd+DWICa8YrqjN2v94cCL1HC04hxoLAffharMeY6QAl0iohK12w9L8/F1
	LhvogRZadeexnpcyFwZ8BupZ75jXrVypa4I0Pojrtvor7H5AXbt9uS4QxgFJ3+apsrPiki
	TcZpjVr1Jt6O3Fxays8XliCeyUpNYEw=
Received: by mail-qt1-f196.google.com with SMTP id d75a77b69052e-4ee1e18fb37so32808701cf.0
        for <linux-mm@kvack.org>; Thu, 08 Jan 2026 12:38:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1767904739; x=1768509539; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rRDiJ+UlJzmE9gGlU0qCIeblmwRaclHqLNtsuAzr4HM=;
        b=eznkfhrW0Am/F1BD3otnhRghi0uvyjmI2eruJuik4xru7M7tQBu6z5NmL/kEJJWfo/
         2UMMF553eDSiyCOjv/4xfDy5Xudmud+ZfHL2HW8dhYGf0SjFqd8xnIORF8VaTYO5A17U
         5WQHyLMSBSQlu7J4xIA0Hd3ktoypmAPNWH+0mIWFJznAjeRDHUBv266GDQlCmtyGMOeL
         DRR2Rh0gkh83Mr+0t/Ryn5lZ264i0tTKA5ZkSjq+uw5qfu0TD7f91r0+MuBvviy3AyxP
         V4bsx0+STi/biddJ3HkVFn3y3P+vt8UsEyghooNgDuyVb5BRkihsn9z9dAidyvykH0Ju
         nDqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767904739; x=1768509539;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rRDiJ+UlJzmE9gGlU0qCIeblmwRaclHqLNtsuAzr4HM=;
        b=ji2MmU88KL9qFLsmIZ9KF9wDsQ5FWhVA3JkSveEXAHZqvjxHgnZmtNXt6uuz3nbCDD
         ZyWBAVXIImKx4PqToqd3+bRsBzTC1GdVPy/2ECURHJGn/TKyVYLQzULxct/iTO7sXUAN
         dF0nUse0qLnmiXtJq7EVZvxisrDNi9swOXgIFnYW4RSx9D70ryCtNax3M+XjH+fzAaLB
         vC6OZ/qjIthFAniCi8GEsUvbhLA9W/6whdrC4CR56ndjQtlX5PZV69Pd+O+DSzL+82pB
         Ib+r/Aqf77aXl42EOlCFCsyqFmZDvQAmYnGzobWfahLx1lX4G6unA7fn6c9j5R9D1lmm
         d6Sg==
X-Gm-Message-State: AOJu0Ywov1DQoTiej1uTIKjcCtlnoop8ZvrI0HK4ceYDpyrYKEsElyXv
	jHFrfpixGi4Zica8/PNS523/lNMRqQGUkyCm2fGZO8rk62N8Jey4acmeeu7qMQyBHEaVF1wZ3CM
	nHBu6Ah4=
X-Gm-Gg: AY/fxX4bd0jhk/MfOXPDmjvqfrU06tUUMXI3Gb9SNfWGIj48TmmoM2iY17UYvkR+bAW
	b/T2W73wAPOj43YTbU3FI5RPWAV9THGVp42KID3cym+cx2PQbrKrzk38xlWbyINu+xmvfF3TX9e
	IFbXxFEN5r036R8JHWf3wvxhnn2fujJ590aXPFyjuvvhMR5hvOM7oKdYvJS9MkG0Tu+oDMAvNf5
	uzoLUog9iDTFcBkfvMF8KWVUdEaQQNCrm2EocJfuRG0rOKw5BBlgW2sqbm9pE+qjhV6B1YqFTgx
	YS7Rh61ni0IZMCzblZ1riRaAQvyr/+sBOWyNqW12ryTZf1o1dhWUyXW/Pk96FDjCVz6TBYumiTy
	jQfij4y7hGlD7hI6bDHB2QDI2Ld5NlEs8c5feCLDa6AlgPMYaA9pIT7nHvB9qI57T/bv9wNKTun
	XGmbLhLwmXw+eqX+eftrwmZ2zfE5IlaO3d6VoIuCvGPooOr9QKgYsZL9XACh7c6g78lWDMUeQVp
	Fo=
X-Google-Smtp-Source: AGHT+IFQyuUju0Z/aUbfqpVDbDingg5jj0Y3CKeme4WYcUfzCc6+dQALyvDYUzyj67d/yfod1gGU5A==
X-Received: by 2002:a05:622a:1101:b0:4ed:df09:a6a6 with SMTP id d75a77b69052e-4ffb48a8a54mr84063441cf.25.1767904738761;
        Thu, 08 Jan 2026 12:38:58 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-890770e472csm60483886d6.23.2026.01.08.12.38.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Jan 2026 12:38:58 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-cxl@vger.kernel.org
Cc: linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kernel-team@meta.com,
	longman@redhat.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	corbet@lwn.net,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	dave@stgolabs.net,
	jonathan.cameron@huawei.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	vishal.l.verma@intel.com,
	ira.weiny@intel.com,
	dan.j.williams@intel.com,
	akpm@linux-foundation.org,
	vbabka@suse.cz,
	surenb@google.com,
	mhocko@suse.com,
	jackmanb@google.com,
	ziy@nvidia.com,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	rppt@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org,
	yosry.ahmed@linux.dev,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	osalvador@suse.de,
	matthew.brost@intel.com,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	apopple@nvidia.com,
	cl@gentwo.org,
	harry.yoo@oracle.com,
	zhengqi.arch@bytedance.com
Subject: [RFC PATCH v3 5/8] Documentation/admin-guide/cgroups: update docs for mems_allowed
Date: Thu,  8 Jan 2026 15:37:52 -0500
Message-ID: <20260108203755.1163107-6-gourry@gourry.net>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260108203755.1163107-1-gourry@gourry.net>
References: <20260108203755.1163107-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 11DC4C0008
X-Stat-Signature: si9agn1t7p6yxm8p5cxr7tkgtwbyieuh
X-HE-Tag: 1767904739-2442
X-HE-Meta: U2FsdGVkX1/ZQt9QY1ordeBEPvSwq9AqFf/zgazmpLFx/3X2aAlaA2TuwKBkV7mWl5gqrEHmJkoWr3vJr4wcmCZgdLH9gGQGJFl7fh1vS+ERKKddtPEEWyiTs70y+CRgsDQpEO+xBOyOCXHHxyf0ZkULseNtlZXi77hKtqZc3z/eQy4qyEGw0+Mdqf4jOmxOVosy1xo93dCSoLzOy4VIvqXFXdx1C/+tsetNloYDanzf2vxHMF3ua3T3V9pnOErGJcGb5T6lcqmdvrv3kOgCRiMYv2kBxWJZKPbmus2eIdEpB9voB5TUp4H4TCTRgn8haPME4nDAlYQnnVTwzN6b7OIs1AieutG38IKjbwOIGlWwjl4otG5hnhkvgCH1u12Jg7w3Rd0/0D378YyjjgARfTLXF/n2vVf6wKXSS3WtOBKb+soywpBlYfDrEBQaXTxDl7wkSLRyyGe26RIF0cW2NDjrefxc6h/sEUo38RWvUGTsTZ+yRlM5vQJ0SBCSB5dZmfrCyVRj7lWWzNIhACqaRwIiNTpNPqnfcbkuMeJ+BCERgN6biwhUTess42PeEzBZcDwBIeRIZLbA12ZHW7bxAAwE4K6nF9oMBRNFyh4Jz/8eoAaoWseVHYI3xXIr/yFUSqTimK92d+v9Ygc3jjeC2sbbmligAr9dcCblQYcReYLKEuOopCeOmUKx608pGITEEr3geZCcZFD76NB+RsWOJE7kCM9XxNf+9oiYwm1uFKMkrOUPZiwLPy0HQ31ONFGFISPzSuFYePLimJbrWGy0kNBqEX6pzFD6PFSoNghMRfe8HyBihDcP1ue8F4oxo8MJn1fIOdTL2LAzXHJJLcrAGwsnHnH/CxYkoy4pTJZw/reev04hqCbRrPxc63QluWnpOcJ52I7u+W0iOtVPgrsTe/tn5DxXJfOOFv/gY33pxbmpsWQkQoMXs8gLIKIBXlRu8aJ5SUnXwuQPTk/Cyer
 nLxj8oHs
 5jroTsJ8mP6/yc2Ra3R6M6e0XD6bUaiqOslJmMNp0vi/7jqCXug9C0LtxysJy4nM39Smh+s2sAqK82HE560vMoZU7zKh7ttpxCxY18Ax/+AdIlV3su2UOWPugBfH/A4Kjemgya9E9AtE45aR7CyynJ6R9GYlXwRgYDp/lBZEty/MUtsoy/H0fj0YtyQeuupVUFz0MF3UOxNH7k40=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add new information about mems_allowed and sysram_nodes, which says
mems_allowed may contain union(N_MEMORY, N_PRIVATE) nodes, while
sysram_nodes may only contain a subset of N_MEMORY nodes.

cpuset.mems.sysram is a new RO ABI which reports the list of
N_MEMORY nodes the cpuset is allowed to use, while
cpusets.mems and mems.effective may also contain N_PRIVATE.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 .../admin-guide/cgroup-v1/cpusets.rst         | 19 +++++++++++---
 Documentation/admin-guide/cgroup-v2.rst       | 26 +++++++++++++++++--
 Documentation/filesystems/proc.rst            |  2 +-
 3 files changed, 40 insertions(+), 7 deletions(-)

diff --git a/Documentation/admin-guide/cgroup-v1/cpusets.rst b/Documentation/admin-guide/cgroup-v1/cpusets.rst
index c7909e5ac136..6d326056f7b4 100644
--- a/Documentation/admin-guide/cgroup-v1/cpusets.rst
+++ b/Documentation/admin-guide/cgroup-v1/cpusets.rst
@@ -158,21 +158,26 @@ new system calls are added for cpusets - all support for querying and
 modifying cpusets is via this cpuset file system.
 
 The /proc/<pid>/status file for each task has four added lines,
-displaying the task's cpus_allowed (on which CPUs it may be scheduled)
-and mems_allowed (on which Memory Nodes it may obtain memory),
-in the two formats seen in the following example::
+displaying the task's cpus_allowed (on which CPUs it may be scheduled),
+and mems_allowed (on which SystemRAM nodes it may obtain memory),
+in the formats seen in the following example::
 
   Cpus_allowed:   ffffffff,ffffffff,ffffffff,ffffffff
   Cpus_allowed_list:      0-127
   Mems_allowed:   ffffffff,ffffffff
   Mems_allowed_list:      0-63
 
+Note that Mems_allowed only shows SystemRAM nodes (N_MEMORY), not
+Private Nodes.  Private Nodes may be accessible via __GFP_THISNODE
+allocations if they appear in the task's cpuset.effective_mems.
+
 Each cpuset is represented by a directory in the cgroup file system
 containing (on top of the standard cgroup files) the following
 files describing that cpuset:
 
  - cpuset.cpus: list of CPUs in that cpuset
  - cpuset.mems: list of Memory Nodes in that cpuset
+ - cpuset.mems.sysram: read-only list of SystemRAM nodes (excludes Private Nodes)
  - cpuset.memory_migrate flag: if set, move pages to cpusets nodes
  - cpuset.cpu_exclusive flag: is cpu placement exclusive?
  - cpuset.mem_exclusive flag: is memory placement exclusive?
@@ -227,7 +232,9 @@ nodes with memory--using the cpuset_track_online_nodes() hook.
 
 The cpuset.effective_cpus and cpuset.effective_mems files are
 normally read-only copies of cpuset.cpus and cpuset.mems files
-respectively.  If the cpuset cgroup filesystem is mounted with the
+respectively.  The cpuset.effective_mems file may include both
+regular SystemRAM nodes (N_MEMORY) and Private Nodes (N_PRIVATE).
+If the cpuset cgroup filesystem is mounted with the
 special "cpuset_v2_mode" option, the behavior of these files will become
 similar to the corresponding files in cpuset v2.  In other words, hotplug
 events will not change cpuset.cpus and cpuset.mems.  Those events will
@@ -236,6 +243,10 @@ the actual cpus and memory nodes that are currently used by this cpuset.
 See Documentation/admin-guide/cgroup-v2.rst for more information about
 cpuset v2 behavior.
 
+The cpuset.mems.sysram file shows only the SystemRAM nodes (N_MEMORY)
+from cpuset.effective_mems, excluding any Private Nodes. This
+represents the nodes available for general memory allocation.
+
 
 1.4 What are exclusive cpusets ?
 --------------------------------
diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admin-guide/cgroup-v2.rst
index 7f5b59d95fce..6af54efb84a2 100644
--- a/Documentation/admin-guide/cgroup-v2.rst
+++ b/Documentation/admin-guide/cgroup-v2.rst
@@ -2530,8 +2530,11 @@ Cpuset Interface Files
 	cpuset-enabled cgroups.
 
 	It lists the onlined memory nodes that are actually granted to
-	this cgroup by its parent. These memory nodes are allowed to
-	be used by tasks within the current cgroup.
+	this cgroup by its parent.  This includes both regular SystemRAM
+	nodes (N_MEMORY) and Private Nodes (N_PRIVATE) that provide
+	device-specific memory not intended for general consumption.
+	Tasks within this cgroup may access Private Nodes using explicit
+	__GFP_THISNODE allocations if the node is in this mask.
 
 	If "cpuset.mems" is empty, it shows all the memory nodes from the
 	parent cgroup that will be available to be used by this cgroup.
@@ -2541,6 +2544,25 @@ Cpuset Interface Files
 
 	Its value will be affected by memory nodes hotplug events.
 
+  cpuset.mems.sysram
+	A read-only multiple values file which exists on all
+	cpuset-enabled cgroups.
+
+	It lists the SystemRAM nodes (N_MEMORY) that are available for
+	general memory allocation by tasks within this cgroup.  This is
+	a subset of "cpuset.mems.effective" that excludes Private Nodes.
+
+	Normal page allocations are restricted to nodes in this mask.
+	The kernel page allocator, slab allocator, and compaction only
+	consider SystemRAM nodes when allocating memory for tasks.
+
+	Private Nodes are excluded from this mask because their memory
+	is managed by device drivers for specific purposes (e.g., CXL
+	compressed memory, accelerator memory) and should not be used
+	for general allocations.
+
+	Its value will be affected by memory nodes hotplug events.
+
   cpuset.cpus.exclusive
 	A read-write multiple values file which exists on non-root
 	cpuset-enabled cgroups.
diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index c92e95e28047..68f3d8ffc03b 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -294,7 +294,7 @@ It's slow but very precise.
  Cpus_active_mm              mask of CPUs on which this process has an active
                              memory context
  Cpus_active_mm_list         Same as previous, but in "list format"
- Mems_allowed                mask of memory nodes allowed to this process
+ Mems_allowed                mask of SystemRAM nodes for general allocations
  Mems_allowed_list           Same as previous, but in "list format"
  voluntary_ctxt_switches     number of voluntary context switches
  nonvoluntary_ctxt_switches  number of non voluntary context switches
-- 
2.52.0


