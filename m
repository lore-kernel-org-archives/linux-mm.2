Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5191C624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:49:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24FAD6B008A; Sun, 22 Feb 2026 03:49:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 224A06B008C; Sun, 22 Feb 2026 03:49:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0F94C6B0092; Sun, 22 Feb 2026 03:49:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EF1E66B008A
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:49:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B3E70B9DD2
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:03 +0000 (UTC)
X-FDA: 84471467766.03.5767770
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id D9355180006
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tcR20grZ;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750141;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=itvSMpOqGG7PqHHjVhXbDUHp+0Ke3fJUKOX/SDJBBVY=;
	b=2roqBSU7dSehinXOmdiVldqMka+q1PIgRb5RAJ0LCVmb23V6aoCDSRcAyopLfWBDu0znlj
	EujcjTqH+C9zTnULmirJFBD8H23/ETquPOSMffclgqwSmFb3ODsYORVSDbOdbYEZ8hGe6g
	qwpgTq4IvjSa2dEPmDgkuNdDdXwCgj0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750141; a=rsa-sha256;
	cv=none;
	b=sBknY1ZVT+yfPS8JENlZAIiBdzONjUyxpkCkBh/cz/ToBZ+/NAKkjfQVCNSNwV3i52QWvH
	Z3Q4N3I56Iv10C0/G0aITL0DMh/geGpJA1zAUnBLwmQ5g82KuyrVI/3WD8CFV9O2U918TW
	MGSCxBpwmVNcWoAPqzeh75X34Cp94P0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tcR20grZ;
	spf=pass (imf06.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.176 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-505a1789a27so20699381cf.3
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750141; x=1772354941; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=itvSMpOqGG7PqHHjVhXbDUHp+0Ke3fJUKOX/SDJBBVY=;
        b=tcR20grZmhEQVkxL3DWKWEoATCCCKcV7c5gb+Fn94kdhCNuoK1PLTEplOkEcD0knvw
         ncctUaxh322DukBGicruLeWCSerz/vG13xBv3MULOdsXy6+l5uxxav4LPfDipP4vJfYS
         4yiGpOO1RI+Q4jBmpNcTxnCvWtOGDqZd9CKkosA+qklWWJtI2jaB005GAQMhQljvISU/
         bYmKsq8M6ncArJpec199fCk51T09p7bsKTyPh2k+EXU3pxtB3Gqf48uLsaj6nOnnLvZq
         69/S8gPxVJW4lfRebsLOVQdZfDjai1QLUC8rFb7ykGEn1h7FGG3WYXd/o2d8MUrDPt1Z
         8Pcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750141; x=1772354941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=itvSMpOqGG7PqHHjVhXbDUHp+0Ke3fJUKOX/SDJBBVY=;
        b=JbV3KDzWLrB4mcwx80i0bGnmm6oS3OqLpzfsueEREg8Q4bNCC6Tx4jFkMDHm+VE9Ct
         mWFtVSW2tOPb/qHveIMeyb7z+0pRFt+HSZw58dsgo1CzUKr73XlnydPeC5jlDqmlCCya
         UEY/o8l1/hA82JP0t9dq8MgNsu/RklyEIkfrnLJ/qUlgzQ/agbj2oV5yBD1WPqUX0H2k
         bDYfmrnNrdL1KNehRKJ8wiT48kK1keh5XmafaPcPtGRHv6r9D+IPhfy5z+DmLibpHsPl
         XAuJ6PPDXnSQriuvoEvENM88t5c61sRUb4fpSIbEQMztofIMOdTQ+LzgdgUIXiWUrKlQ
         P6Vw==
X-Forwarded-Encrypted: i=1; AJvYcCVlg/y8djMrMFWhXrRk0Zl0w+glCEgNvhvKI7T583dWKYorl4a50/BOjx9txK3Z2zoVJ2lCOgrA7w==@kvack.org
X-Gm-Message-State: AOJu0YyCPnJNL2TGuK1rvh9YFnuueavo1rx28+iI3HZRbJNSNH/ReRCy
	8HsX9+3B8zw7Who1Dh8mnG5HRh8fnH+fbxs2T8eY7GJHiWrkzQWrQcijuqSUvgtg0AI=
X-Gm-Gg: AZuq6aKGAWknID14wf60H83cYn7AvFUXKnpp7W1RBKV7HT/WQZSbryZNTZPXnzT6Kye
	BrZpgc0RV31SGSMjRm+rs4tIiCZh9ifjwITi9Dy88cIj+s3S+tEiPX/mEMeXXaH7pAzKmsnU7C1
	psaRZXpBC72KRdZ8Ujx/GB0a+qfDf4EPlZ9bQJHKLTt+Ql9c/jvbjlmpAdgv02elqZUJgQKLOEp
	HqQ8SAtlYim6IITeOjEIrkoX8hwqcsu3ddrKe17D7AdTNBeD3Z/wKaqv6iAwbSwol7Xvu/zX2Jz
	KgQ6L41og5GGc2uJ0SRSXYkkoCNtUxDRn0CKoxUVELh77QduhKMACpIiiRxJrGOaXsaJK39kmmj
	41a9jBgSz/J6BPvdaDaLW6Lu/uwY1ogQMEueOOKcwYSAoXlZJu62O+5LWIRsaL0IhTUEoUI7k7R
	h+LOIybWe0AcTij66rggIypSw+9XAHK+IESSrj+X8617cZqRsaC0PR6InCnvofXYSHrq9TSOezm
	tUEM7agrvGqWnQ=
X-Received: by 2002:a05:622a:1355:b0:4ec:f26f:5aea with SMTP id d75a77b69052e-5070bce327dmr60794421cf.68.1771750140761;
        Sun, 22 Feb 2026 00:49:00 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.48.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:48:59 -0800 (PST)
From: Gregory Price <gourry@gourry.net>
To: lsf-pc@lists.linux-foundation.org
Cc: linux-kernel@vger.kernel.org,
	linux-cxl@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	damon@lists.linux.dev,
	kernel-team@meta.com,
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
	longman@redhat.com,
	akpm@linux-foundation.org,
	david@kernel.org,
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
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com,
	tj@kernel.org,
	hannes@cmpxchg.org,
	mkoutny@suse.com,
	jackmanb@google.com,
	sj@kernel.org,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	muchun.song@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	jannh@google.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	pfalcato@suse.de,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	riel@surriel.com,
	harry.yoo@oracle.com,
	cl@gentwo.org,
	roman.gushchin@linux.dev,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	zhengqi.arch@bytedance.com,
	terry.bowman@amd.com
Subject: [RFC PATCH v4 02/27] mm,cpuset: gate allocations from N_MEMORY_PRIVATE behind __GFP_PRIVATE
Date: Sun, 22 Feb 2026 03:48:17 -0500
Message-ID: <20260222084842.1824063-3-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: knhzppqu6jr6xpn8yied15qoyb45t4sx
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D9355180006
X-HE-Tag: 1771750141-684310
X-HE-Meta: U2FsdGVkX1/zazfZtGsGQgk5fstjW0ILJtJIf1d9/9wKQ83ysp0Fbx9C+aOxmGVSparJMzcKoFennmqWS5cFAbKJSmiyaEB/ODKuKIcF+dOMQtUbt9vOJtbA0D7F/9BPDy/2Zxn56EInv+EUfukSeQwk4PXXHoUC8R68OyfZSWRPl7w2oAChV7Uj5uOFYgYGCnFJrcHE05pwOmeYe9doUjFwVnr39dXgYMyyGuawxzV1BX5ChC1VUvAmi2MxLbD26y4ZvzUzMcTdTh3DzhA5YkZOS86e8HHIfCjCuZEV4BSPBbG0c8RSpZkQxMERIvJlCL4ORoilCdljRyyrEnYUI0wQMbabH3aIrDB/E5lg6jfiAiof1fQwUz/NQlSR9h2Mc+DD2JOI6wr4CNgXXb098YbwV4nncleej8lFTDPjKG3bKkxSEMgPXo/YnImMKA5WODp/GXDZB1zKip3Y60kS0knxtv+4xN6xF8p9eaSZuZm8g+U1hwbNK0ryqeK3J3gtg1SNAiOQKDuCSTnne+M5u9ve7KJMAZhojlvAGj+Zlhunll8KlwaDksBaLE/H1gojiAZJswsy70jV+nHt8Ae8inGzc9aKITh50UkcY8RFv1RQy3si5KXoSv20U6j7GM6gCkCpKeCotD0jTdG8D0I3gM5o1ULWBzvWbL4USBjue6xpG2ElLtd/fmLNfBkd8fQ7g56zX9w5OOdouZA8+zCPHqjPxVwCdx9arbhS4Ulw/pQvibNYOvVKJnvGgZKCTqh7tVhZN9Mod1P1DIAgGxEKyqABV52o59vrGW962S9eMlXPssZGt8UN84poGe/MjfjGLxvi67robUXtfD+qhcw/yLUdD2WHrf3D6KbwJjk2coZv+VAnTm2H7uh0HH1lXCIDr/IJlBjT3apjCsuqPyAswJoSOpZvVemakHSThtwrzn53gPqPM5DzvOEUljzo/3XwHFuuJ/SfJWIKjMg0ZhA
 aHQ1qdDz
 FnUKd9GF4hh2KwjG6SPSxUoIlce7mH8p0K2m9HPa870jex5hNYZX4Q8pqXFtQACcxRllbMwx5PowEYecsmHEmNsEdnLFgsUhxtyw8JaI4/SkihG9qzFMGQdD5yRPvOHFSGN/mfoLNIsyrvRCtaKQ76HSyIbKR6tbr36frt7fm30TMlRkiuokQW6DJDhHqCD6gUcyipf5QcyzUHE4ChxaSnxdf8w0ojydYv+siB3Q+LnA/5vC/ApTIIc10VCv/WUy2b9CxgfRXBQNYT6w18PeKKUXUFX+t9IYklO5Ex9zLZNRFQUewowb6TpAQREQDR4vYh8BkKdIs5Hy3EV71g266dIitNhkprBzrf4BIsj6y6NW+lDMtB+cj5AEM2G4SoZtyRQKtsJk/Ws7E0xjObC7ctU9dsrU1AxdmyTJsCgU3fDjD+nWm5RjxWkib8n3fnyGkoj4d4JleTXmWvEE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

N_MEMORY_PRIVATE nodes hold device-managed memory that should not be
used for general allocations. Without a gating mechanism, any allocation
could land on a private node if it appears in the task's mems_allowed.

Introduce __GFP_PRIVATE that explicitly opts in to allocation from
N_MEMORY_PRIVATE nodes.

Add the GFP_PRIVATE compound mask (__GFP_PRIVATE | __GFP_THISNODE)
for callers that explicitly target private nodes to help prevent
fallback allocations from DRAM.

Update cpuset_current_node_allowed() to filter out N_MEMORY_PRIVATE
nodes unless __GFP_PRIVATE is set.

In interrupt context, only N_MEMORY nodes are valid.

Update cpuset_handle_hotplug() to include N_MEMORY_PRIVATE nodes in
the effective mems set, allowing cgroup-level control over private
node access.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/gfp_types.h      | 15 +++++++++++++--
 include/trace/events/mmflags.h |  4 ++--
 kernel/cgroup/cpuset.c         | 32 ++++++++++++++++++++++++++++----
 3 files changed, 43 insertions(+), 8 deletions(-)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index 3de43b12209e..ac375f9a0fc2 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -33,7 +33,7 @@ enum {
 	___GFP_IO_BIT,
 	___GFP_FS_BIT,
 	___GFP_ZERO_BIT,
-	___GFP_UNUSED_BIT,	/* 0x200u unused */
+	___GFP_PRIVATE_BIT,
 	___GFP_DIRECT_RECLAIM_BIT,
 	___GFP_KSWAPD_RECLAIM_BIT,
 	___GFP_WRITE_BIT,
@@ -69,7 +69,7 @@ enum {
 #define ___GFP_IO		BIT(___GFP_IO_BIT)
 #define ___GFP_FS		BIT(___GFP_FS_BIT)
 #define ___GFP_ZERO		BIT(___GFP_ZERO_BIT)
-/* 0x200u unused */
+#define ___GFP_PRIVATE		BIT(___GFP_PRIVATE_BIT)
 #define ___GFP_DIRECT_RECLAIM	BIT(___GFP_DIRECT_RECLAIM_BIT)
 #define ___GFP_KSWAPD_RECLAIM	BIT(___GFP_KSWAPD_RECLAIM_BIT)
 #define ___GFP_WRITE		BIT(___GFP_WRITE_BIT)
@@ -139,6 +139,11 @@ enum {
  * %__GFP_ACCOUNT causes the allocation to be accounted to kmemcg.
  *
  * %__GFP_NO_OBJ_EXT causes slab allocation to have no object extension.
+ *
+ * %__GFP_PRIVATE allows allocation from N_MEMORY_PRIVATE nodes (e.g., compressed
+ * memory, accelerator memory). Without this flag, allocations are restricted
+ * to N_MEMORY nodes only. Used by migration/demotion paths when explicitly
+ * targeting private nodes.
  */
 #define __GFP_RECLAIMABLE ((__force gfp_t)___GFP_RECLAIMABLE)
 #define __GFP_WRITE	((__force gfp_t)___GFP_WRITE)
@@ -146,6 +151,7 @@ enum {
 #define __GFP_THISNODE	((__force gfp_t)___GFP_THISNODE)
 #define __GFP_ACCOUNT	((__force gfp_t)___GFP_ACCOUNT)
 #define __GFP_NO_OBJ_EXT   ((__force gfp_t)___GFP_NO_OBJ_EXT)
+#define __GFP_PRIVATE	((__force gfp_t)___GFP_PRIVATE)
 
 /**
  * DOC: Watermark modifiers
@@ -367,6 +373,10 @@ enum {
  * available and will not wake kswapd/kcompactd on failure. The _LIGHT
  * version does not attempt reclaim/compaction at all and is by default used
  * in page fault path, while the non-light is used by khugepaged.
+ *
+ * %GFP_PRIVATE adds %__GFP_THISNODE by default to prevent any fallback
+ * allocations to other nodes, given that the caller was already attempting
+ * to access driver-managed memory explicitly.
  */
 #define GFP_ATOMIC	(__GFP_HIGH|__GFP_KSWAPD_RECLAIM)
 #define GFP_KERNEL	(__GFP_RECLAIM | __GFP_IO | __GFP_FS)
@@ -382,5 +392,6 @@ enum {
 #define GFP_TRANSHUGE_LIGHT	((GFP_HIGHUSER_MOVABLE | __GFP_COMP | \
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
+#define GFP_PRIVATE	(__GFP_PRIVATE | __GFP_THISNODE)
 
 #endif /* __LINUX_GFP_TYPES_H */
diff --git a/include/trace/events/mmflags.h b/include/trace/events/mmflags.h
index a6e5a44c9b42..f042cd848451 100644
--- a/include/trace/events/mmflags.h
+++ b/include/trace/events/mmflags.h
@@ -37,7 +37,8 @@
 	TRACE_GFP_EM(HARDWALL)			\
 	TRACE_GFP_EM(THISNODE)			\
 	TRACE_GFP_EM(ACCOUNT)			\
-	TRACE_GFP_EM(ZEROTAGS)
+	TRACE_GFP_EM(ZEROTAGS)			\
+	TRACE_GFP_EM(PRIVATE)
 
 #ifdef CONFIG_KASAN_HW_TAGS
 # define TRACE_GFP_FLAGS_KASAN			\
@@ -73,7 +74,6 @@
 TRACE_GFP_FLAGS
 
 /* Just in case these are ever used */
-TRACE_DEFINE_ENUM(___GFP_UNUSED_BIT);
 TRACE_DEFINE_ENUM(___GFP_LAST_BIT);
 
 #define gfpflag_string(flag) {(__force unsigned long)flag, #flag}
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 473aa9261e16..1a597f0c7c6c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -444,21 +444,32 @@ static void guarantee_active_cpus(struct task_struct *tsk,
 }
 
 /*
- * Return in *pmask the portion of a cpusets's mems_allowed that
+ * Return in *pmask the portion of a cpuset's mems_allowed that
  * are online, with memory.  If none are online with memory, walk
  * up the cpuset hierarchy until we find one that does have some
  * online mems.  The top cpuset always has some mems online.
  *
  * One way or another, we guarantee to return some non-empty subset
- * of node_states[N_MEMORY].
+ * of node_states[N_MEMORY].  N_MEMORY_PRIVATE nodes from the
+ * original cpuset are preserved, but only N_MEMORY nodes are
+ * pulled from ancestors.
  *
  * Call with callback_lock or cpuset_mutex held.
  */
 static void guarantee_online_mems(struct cpuset *cs, nodemask_t *pmask)
 {
+	struct cpuset *orig_cs = cs;
+	int nid;
+
 	while (!nodes_intersects(cs->effective_mems, node_states[N_MEMORY]))
 		cs = parent_cs(cs);
+
 	nodes_and(*pmask, cs->effective_mems, node_states[N_MEMORY]);
+
+	for_each_node_state(nid, N_MEMORY_PRIVATE) {
+		if (node_isset(nid, orig_cs->effective_mems))
+			node_set(nid, *pmask);
+	}
 }
 
 /**
@@ -4075,7 +4086,9 @@ static void cpuset_handle_hotplug(void)
 
 	/* fetch the available cpus/mems and find out which changed how */
 	cpumask_copy(&new_cpus, cpu_active_mask);
-	new_mems = node_states[N_MEMORY];
+
+	/* Include N_MEMORY_PRIVATE so cpuset controls access the same way */
+	nodes_or(new_mems, node_states[N_MEMORY], node_states[N_MEMORY_PRIVATE]);
 
 	/*
 	 * If subpartitions_cpus is populated, it is likely that the check
@@ -4488,10 +4501,21 @@ bool cpuset_node_allowed(struct cgroup *cgroup, int nid)
  * __alloc_pages() will include all nodes.  If the slab allocator
  * is passed an offline node, it will fall back to the local node.
  * See kmem_cache_alloc_node().
+ *
+ *
+ * Private nodes aren't eligible for these allocations, so skip them.
+ * guarantee_online_mems guaranttes at least one N_MEMORY node is set.
  */
 static int cpuset_spread_node(int *rotor)
 {
-	return *rotor = next_node_in(*rotor, current->mems_allowed);
+	int node;
+
+	do {
+		node = next_node_in(*rotor, current->mems_allowed);
+		*rotor = node;
+	} while (node_state(node, N_MEMORY_PRIVATE));
+
+	return node;
 }
 
 /**
-- 
2.53.0


