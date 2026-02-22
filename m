Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6E7C624D2
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 08:50:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 684B26B00B2; Sun, 22 Feb 2026 03:50:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 62E366B00B4; Sun, 22 Feb 2026 03:50:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E68B6B00B5; Sun, 22 Feb 2026 03:50:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 376656B00B2
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 03:50:02 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EC45459DE0
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:50:01 +0000 (UTC)
X-FDA: 84471470202.23.6EC6B10
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf10.hostedemail.com (Postfix) with ESMTP id 247E4C000B
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 08:49:59 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QSBZKTv1;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771750200;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=degmio9cxdpzQuRYo2QvBbWquT2Pd1sYOKpzGMoeajE=;
	b=NNPdaMouzX1GXDQxjJotG/eddEkzEu6/BBtjqXQbL1Ilqb59fTPZ2bqZ5cftvSHnDU9F64
	uLQx+4rzyxxlIuLWUXFkLb0QNMmGuyVXNSzhd1KWLeUH7R6yjYq8qldDmNXVjL5C1FAzgV
	Ok2idxqUhduJgjI4D/ise1DeR+3cvLc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=QSBZKTv1;
	spf=pass (imf10.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.179 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771750200; a=rsa-sha256;
	cv=none;
	b=13veOgGtB2BFiyB0Z9Wb9VDzw4ChJnfhEQokyDIqwfVy1OC8U9lARwQ+hnqMXAu5BBfCIo
	DwB/c8avjYQS2XjY+oo2qSfy3TCAER96sfIEBjGOlAVoAIJmI1WqGjKysnjfJwWSZem6LD
	exkK2yKazuPcZY96F4TSK4pT058rrn0=
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-506a6cf8242so28981071cf.1
        for <linux-mm@kvack.org>; Sun, 22 Feb 2026 00:49:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1771750199; x=1772354999; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=degmio9cxdpzQuRYo2QvBbWquT2Pd1sYOKpzGMoeajE=;
        b=QSBZKTv16hAvITfl2oKgwFFngXC1TokbZOpSx3qKzIFifztm27qmA6+k8SpTPwhvGK
         8BS4O2FSzBZGgp/DFvAknhzR2JmznoZUWHTkJnUsI0IzGRFcUjZNTrV3KcOj4HQziUaS
         t/uUzhOV1kR2I2ZFdqoxeoNjQnXWGwwwimk/dxVRiZEXQ6sdghJuKyBcqIlWQzvFWDjJ
         yyudGOGQnzVRWvsRPLp8igc9TYTciDFC/AOkZzGvVMqr4Id6JxnKpZ4S4/QGLuHeID7p
         nqOEFGd/NTjh1bss9Ny/b/x8c/QIcp+GG7VjZiCZrcfPdq8r0RGTkhEEAH8JqU5Ri51O
         1bJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771750199; x=1772354999;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=degmio9cxdpzQuRYo2QvBbWquT2Pd1sYOKpzGMoeajE=;
        b=qCsVm8MWxQyNWXnEmfI7aI6LOS9xJOTLlepsEnRGyPiWklvuk884tPoOMFV7Wal/XH
         lng5Qj+xtwdK5/DaVvqUH5+Jmu1LzBVIKT2ebf5U0f2xrhorZlaor+E6gAtUlXaWEoqm
         y7smGyDpWGLVvznBQdmbQGQDieVqT9YQ7GSEpELK0Il88JiXwU8ZcqQ7mbjpG73oshBl
         YHOYWjIR67xAmiiEf4kqsdFHisDgYszFl5+IgB07ysXMqzVEYJ1qSTeAImoRcOj8bu6+
         BNMKoaG9otsqA2rqz7kbOTp/UXZaPKmx5/oQHo9sPbazlO1fhHQf6fhheywwwXfNjCjp
         O31w==
X-Forwarded-Encrypted: i=1; AJvYcCUwo+DNcx7Gj4RGByUEhnZcX9RaUIDT5GHzynItvuAQ0Ew2DjMFytfpLUJKLZfI5cBMu4rreFfzhg==@kvack.org
X-Gm-Message-State: AOJu0YzqxgxxQb2ctiogVdT/0nDRJGtqjAnb9yZxXguI13icRS4cK6Nm
	ZlpgvNBYKBrhAcMRXDlvY8CvpGrwCpKkeK8QJ9pGfLKLktydrCxJKWZHPYKqEijvSLE=
X-Gm-Gg: AZuq6aIoTa2QfqXUx2ky2lpe0T0QuVaBHMWNKGE9hPrmGDJy6XfkgT2Cu7cyFJskWj8
	6VR7/LOJcAw2cDfCf9LihdgX4P2UmbNVoYfce9dSperEVx4DRiGCfhQvZAVy/8ez0VFoMLddJSZ
	cbhOtFa+717fOfnC+SuR8dqW5jzhAggrh0YadKPxtMRbz/MIaPUkRM8JbPdPNsJOgN1zHFt8StX
	mZ26pBKFudf4iZvZ0bIqZL0IWBDhGys/ZXu5Ru6/Wp7oUlrOkizEc1Li9bcYw38j1ROGCqsA7K8
	lttmw8kUrBoe3t40JvgWeNeZin5hlKUmZdkovC0NBDEblHKA7vT403EfZ5xWLceWWWyCaPuYaWx
	YIeRkLEZnAjWKay+/tenaRze0EnEspyoNTqVAwPcH/NAaRmW1UxHZ+eAyi3eZkJX5jHJ6BRGtcY
	aexIuHdKYI/ePubcpxSursCg4PmstribJtsolhD02LIQozAOer/WEFKYOFuM9+NwiZtmOn861BO
	hgZU5ypY22qPR0=
X-Received: by 2002:a05:622a:1307:b0:502:9b85:a609 with SMTP id d75a77b69052e-5070bbf23bamr76760921cf.30.1771750199062;
        Sun, 22 Feb 2026 00:49:59 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F.lan (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5070d53f0fcsm38640631cf.9.2026.02.22.00.49.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 22 Feb 2026 00:49:58 -0800 (PST)
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
Subject: [RFC PATCH v4 17/27] mm/oom: NP_OPS_OOM_ELIGIBLE - private node OOM participation
Date: Sun, 22 Feb 2026 03:48:32 -0500
Message-ID: <20260222084842.1824063-18-gourry@gourry.net>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260222084842.1824063-1-gourry@gourry.net>
References: <20260222084842.1824063-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5rq8xufes9t5t1eogmb6fzjjm551rg6e
X-Rspam-User: 
X-Rspamd-Queue-Id: 247E4C000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1771750199-887863
X-HE-Meta: U2FsdGVkX19Hj7R0Yu3UuUZsVpfTK4/fSq/RwdSx4u1/et5B/T2ArliSmRaU7FLdzivdL/Pwp7gb3V0I5rJ9XeXsfexQIwlsPPeMWAY60Sx0MxOChwjqMD85q9jfFfc2AIrAkL3OrhpbdJLzWjCCqAAo00ezycM5OvgP8cVOZeM3YBYreCuFyuie/x3+YkDZs6JsXzPKHimw/ehSCLggQ0b+knHJSJzCwj4dKegEK/j+q9WpMu1dxL9Sjcg4PVxaqlFyaYh1Fie2tFA1T1w4DEc9EM40fAK/GmaX0QXsH+ZdC+jmmQCKaLdIywioSQP2D+MXPErGi4XDnSBLiucqv/HVobTX+VgaUQUOLfo/a/TBfTbMz5sg0trMQlGjeASoBCYpjx1wQZG5wTR2y5tsexTIqPJayi7IGVWLC0SgrBwA1FHinTVbOZckTKw0nBeQtx1ISGsaiDq2G1/zDuyfvsJkHWKG4qhWudh3CNDSbRnU22ZTvqKrjdIPquvv+MFQsMidQfStDHpMTscVS6uGX2nVVKhNsvfE5o4h/MAv7F4LBjRRCzZq/m5uqpP3MntakmWDLyEOiCI+fQwAQRV7Fd9dvs6s0q3d0frDlIYydGeydtBmvnVMsv73bUSSrcbOaoDNDx2Fr3dkfwomVwevaq0d2rP/+c3n/zHEpTIkNaKq971wXJOhWcMfGl4qLItKV8HVAdBN3g5LnD7aSeR8ojFdq2+vE6jH+t2aNG1mmoX2JWpMDzxGAbZri2vR1aQSVNsDxYHbiJ1gurbRAh5bKNCg7KJBSqu4aidG2dTamD38V60xqIt17Elr6/B2rXX+uIivxPVOTUx6vk0yG/jFCeX4vmIVY0Pk/9c89hkWv6SJJdjgoaJhYtIX5s2xEhtoBK0ikIiCozAaqPaWOXAXW3zG0zHtUc5a5xPdfZTG8TwD3IyqfNZJsHe/YHygrKJvscr+bofRg9rON/oEFin
 1hN0sscn
 w7bt7ROIniI3C6BKKmFD0jLt3r83MGrvRF47JRiPIi1CbWI12UR8vEdfSV6PrNBjDn6XLHkxZrreVKEy9KzMwit7mKO0fzD1+HKcrWIk35HXW4sBA73EQHjb9Q2QwW/0o8/g8n0S2QK7PAGDPAqxLWYQY8xG+8QJuk5d6EPFeFJwxsgLUUa73UfPnCHD5cDh/B1LEzWvj5wPZOb6oqglDcAwYtAzK6txKkk6IyTDlKBYzM+fjw64QqI6MhD9iumkg4ws+YCjU9I0xWmGKWI11rAwXJne3/dqftJK0C54/pZr5Dv8hVZnSScXYV4YZH03m6fR9xg7PPpFpCmQxnCbc8sdB5xVu3Uaa5gTh/EC1buuJi0S1SzLYRdzI2plzFJ7Q7ysuIHC30AuBORpUlZdJEvZWuze1oBYepMcc1rvYkZ+Hk/w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The OOM killer must know whether killing a task can actually free
memory such that pressure is reduced.

A private node only contributes to relieving pressure if it participates
in both reclaim and demotion. Without this check, the check, the OOM
killer may select an undeserving victim.

Introduce NP_OPS_OOM_ELIGIBLE and helpers node_oom_eligible() and
zone_oom_eligible().

Replace cpuset_mems_allowed_intersects() in oom_cpuset_eligible()
with oom_mems_intersect() that iterates N_MEMORY nodes and skips
ineligible private nodes.

Update constrained_alloc() to use zone_oom_eligible() for constraint
detection and node_oom_eligible() to exclude ineligible nodes from
totalpages accounting.

Remove cpuset_mems_allowed_intersects() as it has no remaining callers.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 include/linux/cpuset.h       |  9 -------
 include/linux/node_private.h |  3 +++
 kernel/cgroup/cpuset.c       | 17 ------------
 mm/oom_kill.c                | 52 ++++++++++++++++++++++++++++++++----
 4 files changed, 50 insertions(+), 31 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index 7b2f3f6b68a9..53ccfb00b277 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -97,9 +97,6 @@ static inline bool cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 	return true;
 }
 
-extern int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
-					  const struct task_struct *tsk2);
-
 #ifdef CONFIG_CPUSETS_V1
 #define cpuset_memory_pressure_bump() 				\
 	do {							\
@@ -241,12 +238,6 @@ static inline bool cpuset_zone_allowed(struct zone *z, gfp_t gfp_mask)
 	return true;
 }
 
-static inline int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
-						 const struct task_struct *tsk2)
-{
-	return 1;
-}
-
 static inline void cpuset_memory_pressure_bump(void) {}
 
 static inline void cpuset_task_status_allowed(struct seq_file *m,
diff --git a/include/linux/node_private.h b/include/linux/node_private.h
index 34be52383255..34d862f09e24 100644
--- a/include/linux/node_private.h
+++ b/include/linux/node_private.h
@@ -141,6 +141,9 @@ struct node_private_ops {
 /* Kernel reclaim (kswapd, direct reclaim, OOM) operates on this node */
 #define NP_OPS_RECLAIM			BIT(4)
 
+/* Private node is OOM-eligible: reclaim can run and pages can be demoted here */
+#define NP_OPS_OOM_ELIGIBLE		(NP_OPS_RECLAIM | NP_OPS_DEMOTION)
+
 /**
  * struct node_private - Per-node container for N_MEMORY_PRIVATE nodes
  *
diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 1a597f0c7c6c..29789d544fd5 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -4530,23 +4530,6 @@ int cpuset_mem_spread_node(void)
 	return cpuset_spread_node(&current->cpuset_mem_spread_rotor);
 }
 
-/**
- * cpuset_mems_allowed_intersects - Does @tsk1's mems_allowed intersect @tsk2's?
- * @tsk1: pointer to task_struct of some task.
- * @tsk2: pointer to task_struct of some other task.
- *
- * Description: Return true if @tsk1's mems_allowed intersects the
- * mems_allowed of @tsk2.  Used by the OOM killer to determine if
- * one of the task's memory usage might impact the memory available
- * to the other.
- **/
-
-int cpuset_mems_allowed_intersects(const struct task_struct *tsk1,
-				   const struct task_struct *tsk2)
-{
-	return nodes_intersects(tsk1->mems_allowed, tsk2->mems_allowed);
-}
-
 /**
  * cpuset_print_current_mems_allowed - prints current's cpuset and mems_allowed
  *
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5eb11fbba704..cd0d65ccd1e8 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -74,7 +74,45 @@ static inline bool is_memcg_oom(struct oom_control *oc)
 	return oc->memcg != NULL;
 }
 
+/* Private nodes are only eligible if they support both reclaim and demotion */
+static inline bool node_oom_eligible(int nid)
+{
+	if (!node_state(nid, N_MEMORY_PRIVATE))
+		return true;
+	return (node_private_flags(nid) & NP_OPS_OOM_ELIGIBLE) ==
+		NP_OPS_OOM_ELIGIBLE;
+}
+
+static inline bool zone_oom_eligible(struct zone *zone, gfp_t gfp_mask)
+{
+	if (!node_oom_eligible(zone_to_nid(zone)))
+		return false;
+	return cpuset_zone_allowed(zone, gfp_mask);
+}
+
 #ifdef CONFIG_NUMA
+/*
+ * Killing a task can only relieve system pressure if freed memory can be
+ * demoted there and reclaim can operate on the node's pages, so we
+ * omit private nodes that aren't eligible.
+ */
+static bool oom_mems_intersect(const struct task_struct *tsk1,
+			       const struct task_struct *tsk2)
+{
+	int nid;
+
+	for_each_node_state(nid, N_MEMORY) {
+		if (!node_isset(nid, tsk1->mems_allowed))
+			continue;
+		if (!node_isset(nid, tsk2->mems_allowed))
+			continue;
+		if (!node_oom_eligible(nid))
+			continue;
+		return true;
+	}
+	return false;
+}
+
 /**
  * oom_cpuset_eligible() - check task eligibility for kill
  * @start: task struct of which task to consider
@@ -107,9 +145,10 @@ static bool oom_cpuset_eligible(struct task_struct *start,
 		} else {
 			/*
 			 * This is not a mempolicy constrained oom, so only
-			 * check the mems of tsk's cpuset.
+			 * check the mems of tsk's cpuset, excluding private
+			 * nodes that do not participate in kernel reclaim.
 			 */
-			ret = cpuset_mems_allowed_intersects(current, tsk);
+			ret = oom_mems_intersect(current, tsk);
 		}
 		if (ret)
 			break;
@@ -291,16 +330,19 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 		return CONSTRAINT_MEMORY_POLICY;
 	}
 
-	/* Check this allocation failure is caused by cpuset's wall function */
+	/* Check this allocation failure is caused by cpuset or private node constraints */
 	for_each_zone_zonelist_nodemask(zone, z, oc->zonelist,
 			highest_zoneidx, oc->nodemask)
-		if (!cpuset_zone_allowed(zone, oc->gfp_mask))
+		if (!zone_oom_eligible(zone, oc->gfp_mask))
 			cpuset_limited = true;
 
 	if (cpuset_limited) {
 		oc->totalpages = total_swap_pages;
-		for_each_node_mask(nid, cpuset_current_mems_allowed)
+		for_each_node_mask(nid, cpuset_current_mems_allowed) {
+			if (!node_oom_eligible(nid))
+				continue;
 			oc->totalpages += node_present_pages(nid);
+		}
 		return CONSTRAINT_CPUSET;
 	}
 	return CONSTRAINT_NONE;
-- 
2.53.0


