Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AEA54D7237B
	for <linux-mm@archiver.kernel.org>; Sun, 25 Jan 2026 22:47:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 237A46B00A8; Sun, 25 Jan 2026 17:47:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F5AC6B00AA; Sun, 25 Jan 2026 17:47:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 118816B00AB; Sun, 25 Jan 2026 17:47:40 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F40D26B00A8
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 17:47:39 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BCD15BA2E0
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:39 +0000 (UTC)
X-FDA: 84371974638.07.AA4B8D5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 411BD180008
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 22:47:38 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p61JT54g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769381258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7by5a2QpHbVkkGG0Gwa33bTUu1MH/K3rRGRtuel9660=;
	b=pJbyqEI8bH2JB4vtdufMvN3sdYgvF3VT/ui/i+9XIi4reVCQw/tBSgM8fKw1ZLNW+v7rBt
	fw977TdNtG0v8g7E0faTyDBxySkjqtATs8AgkfVRw2D3phUhudXzH4xZ+dIgr3sZTnhwah
	lsIhito0Jra2d6z2C4XhWLfdNFUOU80=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769381258; a=rsa-sha256;
	cv=none;
	b=l26989IHfas9rtHFzwEWlL8NHk/tKq3U/ptwczkUZZ3iAo+09DlN/NjMd5WW5PNmM3er37
	vsNVKlW7beigtfEs4Sm6+up8NxdjuQ5I0FP4CGsIr4DD9VhiOyH7UzdNuc56tmAeqT6Q7Z
	xOQqGN7+PZN9Zapv9jBGLLOZeiJ0f/k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=p61JT54g;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of frederic@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=frederic@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C20A86011E;
	Sun, 25 Jan 2026 22:47:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AA36C4CEF1;
	Sun, 25 Jan 2026 22:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769381257;
	bh=wMXJKwwq0CUGfNI5Ih4i6lhiz7gOrxOgiKsZySY9z0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p61JT54g4toxPnCarvpaFbBjsBbe7y1z48sMSn4GtBKRchfD+DJ6Ktg76jyXqw1QB
	 rOKCvVHN/cqoTXvZZNshucufY4VXA3FM2YoP7ajXUrLgGIEsRmQ8ilZpXbOJVt//Kh
	 NHd7eHilOaEKEtxmiz5uPC9PGvIKQcatLEuwA3+kF8nHRUjAJggboXdirVq/Wz122y
	 rVLgihCncKuJChsc7b2WZT87+bDFo+VCqhKkZUIYeBoDqrIrWZKlWqVn01mGIpDcCI
	 5cnFi+ABhROKFCwKxe2jKb0e2Yz56ybW7n6Q8jOpO2+5RsvgD2a81S3GiOt0HY23nc
	 s1yjuVMQYNeJw==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 13/33] sched/isolation: Convert housekeeping cpumasks to rcu pointers
Date: Sun, 25 Jan 2026 23:45:20 +0100
Message-ID: <20260125224541.50226-14-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20260125224541.50226-1-frederic@kernel.org>
References: <20260125224541.50226-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 411BD180008
X-Stat-Signature: gwmz79fio8eycr9st5n1jr31rt7exw76
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769381258-937317
X-HE-Meta: U2FsdGVkX18nspL99SjTp+zTXzpkIbEy6Pc25JSorAj3vV6BDAVd9ABsUrOGDvhQZGnAlQCGE9d1vIdNRUXmrQ6DK9YtU37i+D5P5DRjQb862pMsmqp5/BCFTppafLBDwycW0iusGVY6MdP+1V2oK6sLvMXh9v2rjdjpHpVDrF/ihjhxDnx/iANbqYcQjV6TQqdavh9KAddpELyldP0bfggkbGRwkTSk7f0LIWD4Iu1B+Job1LwEpKLou+wlzWw20YH9jdBq70IEflnW0+dy+2vk1QyuaioKJUvPfUCRfSHpiBZxlUgRYn4XgnPg7PEB7lG5XjybRtx/exD2Tbnvz1nKScieATa80MH5mCDdrEZh0pl44TAP6OQmIjlq37zhit4vG4wt4IGKAUhUsj9Xh+SVKWxNZNinfXhI5qEW/mwTMd4tXNOePqwDL4KjVW+/KRBlWeh+bSYZlvysCe8w70Pp4JzSi2PLCfJbI7Ooc61ezQBt47QOg/SmcBCSNYRs9eDOt8e+CHfGn8XVv7aoXazdwF9FwRn3OU5NFAw0FqL3kXryaubehpZOdkG93YwJtsn4oUHYuk2ajro7UUbJ0j4xQrm5XzlUOK6DKQsxrtiI/7P3Yv7mBaNlhCcTd51spXyDFk4T1GVGROJQEsuLYl63uxQPclKcV5VLomohKkugbpPJY58U2OG466JI5Ji17IAroHNpV3NTKPDRqox6OUc7sTrvrRg/adY0cBZKC56ZFIs05wp1UHwMwd0tjgG/ZzdomFLS8R/QN5G3OWBA6tn86SAs9cks31He8sej1AweShptAwS1Nlj4kF5YgB29bPhPDK5GErJiRDmY/A8KjwXwpGLBzFP/ttu3uB25rfbj+26Ybpme6CyED+amtV+fbGEylXZREbnPgshmoZkwtOWiJWPCcdSc1Bgko/jN5v+CWNxUY30WJOU3ubwEXKnF488QIW/2zOxZ7itk5xl
 lcoM9bEe
 EM+C4zphs0hA7v5WCmaG6+/xKFCGgm5O8ajAfYvPkv/rwDDfxd+h3ssQzeIsrfxUOFO/QHlFPAjPPfAAeRwSSbu8Pj5LSuVYm2Mpo3B/MOZ2XckKUdqFEyYGDg5h8gRwpU+fc8AdsofIPYcM3pNa6Hk5hl5/qC+h9lrt+lEyjJEtvFx2RL4dLNuNZ6ohB7dzRefYvo3p5n6rbw9m3nilQYetFT7KVua0BAM1XZB3+oY478YTLHyaJbCz+cD+eZ18jZCaujV+/0V4NDAU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

HK_TYPE_DOMAIN's cpumask will soon be made modifiable by cpuset.
A synchronization mechanism is then needed to synchronize the updates
with the housekeeping cpumask readers.

Turn the housekeeping cpumasks into RCU pointers. Once a housekeeping
cpumask will be modified, the update side will wait for an RCU grace
period and propagate the change to interested subsystem when deemed
necessary.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/sched/isolation.c | 60 +++++++++++++++++++++++++---------------
 kernel/sched/sched.h     |  1 +
 2 files changed, 38 insertions(+), 23 deletions(-)

diff --git a/kernel/sched/isolation.c b/kernel/sched/isolation.c
index 11a623fa6320..6f77289c14c3 100644
--- a/kernel/sched/isolation.c
+++ b/kernel/sched/isolation.c
@@ -21,7 +21,7 @@ DEFINE_STATIC_KEY_FALSE(housekeeping_overridden);
 EXPORT_SYMBOL_GPL(housekeeping_overridden);
 
 struct housekeeping {
-	cpumask_var_t cpumasks[HK_TYPE_MAX];
+	struct cpumask __rcu *cpumasks[HK_TYPE_MAX];
 	unsigned long flags;
 };
 
@@ -33,17 +33,28 @@ bool housekeeping_enabled(enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_enabled);
 
+const struct cpumask *housekeeping_cpumask(enum hk_type type)
+{
+	if (static_branch_unlikely(&housekeeping_overridden)) {
+		if (housekeeping.flags & BIT(type)) {
+			return rcu_dereference_check(housekeeping.cpumasks[type], 1);
+		}
+	}
+	return cpu_possible_mask;
+}
+EXPORT_SYMBOL_GPL(housekeeping_cpumask);
+
 int housekeeping_any_cpu(enum hk_type type)
 {
 	int cpu;
 
 	if (static_branch_unlikely(&housekeeping_overridden)) {
 		if (housekeeping.flags & BIT(type)) {
-			cpu = sched_numa_find_closest(housekeeping.cpumasks[type], smp_processor_id());
+			cpu = sched_numa_find_closest(housekeeping_cpumask(type), smp_processor_id());
 			if (cpu < nr_cpu_ids)
 				return cpu;
 
-			cpu = cpumask_any_and_distribute(housekeeping.cpumasks[type], cpu_online_mask);
+			cpu = cpumask_any_and_distribute(housekeeping_cpumask(type), cpu_online_mask);
 			if (likely(cpu < nr_cpu_ids))
 				return cpu;
 			/*
@@ -59,28 +70,18 @@ int housekeeping_any_cpu(enum hk_type type)
 }
 EXPORT_SYMBOL_GPL(housekeeping_any_cpu);
 
-const struct cpumask *housekeeping_cpumask(enum hk_type type)
-{
-	if (static_branch_unlikely(&housekeeping_overridden))
-		if (housekeeping.flags & BIT(type))
-			return housekeeping.cpumasks[type];
-	return cpu_possible_mask;
-}
-EXPORT_SYMBOL_GPL(housekeeping_cpumask);
-
 void housekeeping_affine(struct task_struct *t, enum hk_type type)
 {
 	if (static_branch_unlikely(&housekeeping_overridden))
 		if (housekeeping.flags & BIT(type))
-			set_cpus_allowed_ptr(t, housekeeping.cpumasks[type]);
+			set_cpus_allowed_ptr(t, housekeeping_cpumask(type));
 }
 EXPORT_SYMBOL_GPL(housekeeping_affine);
 
 bool housekeeping_test_cpu(int cpu, enum hk_type type)
 {
-	if (static_branch_unlikely(&housekeeping_overridden))
-		if (housekeeping.flags & BIT(type))
-			return cpumask_test_cpu(cpu, housekeeping.cpumasks[type]);
+	if (static_branch_unlikely(&housekeeping_overridden) && housekeeping.flags & BIT(type))
+		return cpumask_test_cpu(cpu, housekeeping_cpumask(type));
 	return true;
 }
 EXPORT_SYMBOL_GPL(housekeeping_test_cpu);
@@ -96,20 +97,33 @@ void __init housekeeping_init(void)
 
 	if (housekeeping.flags & HK_FLAG_KERNEL_NOISE)
 		sched_tick_offload_init();
-
+	/*
+	 * Realloc with a proper allocator so that any cpumask update
+	 * can indifferently free the old version with kfree().
+	 */
 	for_each_set_bit(type, &housekeeping.flags, HK_TYPE_MAX) {
+		struct cpumask *omask, *nmask = kmalloc(cpumask_size(), GFP_KERNEL);
+
+		if (WARN_ON_ONCE(!nmask))
+			return;
+
+		omask = rcu_dereference(housekeeping.cpumasks[type]);
+
 		/* We need at least one CPU to handle housekeeping work */
-		WARN_ON_ONCE(cpumask_empty(housekeeping.cpumasks[type]));
+		WARN_ON_ONCE(cpumask_empty(omask));
+		cpumask_copy(nmask, omask);
+		RCU_INIT_POINTER(housekeeping.cpumasks[type], nmask);
+		memblock_free(omask, cpumask_size());
 	}
 }
 
 static void __init housekeeping_setup_type(enum hk_type type,
 					   cpumask_var_t housekeeping_staging)
 {
+	struct cpumask *mask = memblock_alloc_or_panic(cpumask_size(), SMP_CACHE_BYTES);
 
-	alloc_bootmem_cpumask_var(&housekeeping.cpumasks[type]);
-	cpumask_copy(housekeeping.cpumasks[type],
-		     housekeeping_staging);
+	cpumask_copy(mask, housekeeping_staging);
+	RCU_INIT_POINTER(housekeeping.cpumasks[type], mask);
 }
 
 static int __init housekeeping_setup(char *str, unsigned long flags)
@@ -162,7 +176,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 
 		for_each_set_bit(type, &iter_flags, HK_TYPE_MAX) {
 			if (!cpumask_equal(housekeeping_staging,
-					   housekeeping.cpumasks[type])) {
+					   housekeeping_cpumask(type))) {
 				pr_warn("Housekeeping: nohz_full= must match isolcpus=\n");
 				goto free_housekeeping_staging;
 			}
@@ -183,7 +197,7 @@ static int __init housekeeping_setup(char *str, unsigned long flags)
 		iter_flags = flags & (HK_FLAG_KERNEL_NOISE | HK_FLAG_DOMAIN);
 		first_cpu = (type == HK_TYPE_MAX || !iter_flags) ? 0 :
 			    cpumask_first_and_and(cpu_present_mask,
-				    housekeeping_staging, housekeeping.cpumasks[type]);
+						  housekeeping_staging, housekeeping_cpumask(type));
 		if (first_cpu >= min(nr_cpu_ids, setup_max_cpus)) {
 			pr_warn("Housekeeping: must include one present CPU "
 				"neither in nohz_full= nor in isolcpus=domain, "
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index d30cca6870f5..475bdab3b8db 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -42,6 +42,7 @@
 #include <linux/ktime_api.h>
 #include <linux/lockdep_api.h>
 #include <linux/lockdep.h>
+#include <linux/memblock.h>
 #include <linux/minmax.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-- 
2.51.1


