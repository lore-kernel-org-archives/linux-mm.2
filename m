Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9ACCCCA5FB3
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 04:42:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D32E6B008C; Thu,  1 Oct 2026 00:42:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85CE36B0092; Thu,  1 Oct 2026 00:42:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 725536B0093; Thu,  1 Oct 2026 00:42:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9C86B008C
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 00:42:25 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 473461402BF
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:42:24 +0000 (UTC)
X-FDA: 85272811008.11.4D6CF70
Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7E2671C0006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 04:42:22 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nhhv9XHd;
	spf=pass (imf18.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790829742;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIBJllRq9Qoioyf410EUtaPM6Z2WKPJiq8KVjKLjAxE=;
	b=WXU85vHDUH8jml8/bs1Y45mLyveZg3oPG0qp8+pdrHWdsAxCLJ8bfdkMWEUZPCFeGTjaRj
	7ZZgo3AYyxdHsuM2ib0a3F2WJhAQBMRmlgbkAqCEviAph+SpMqCmmsxaylQXTaAbSo+376
	SMxHr+J3Rn6/B5ngg4OWnSSqveEAo/o=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Nhhv9XHd;
	spf=pass (imf18.hostedemail.com: domain of kmehltretter@gmail.com designates 74.125.225.141 as permitted sender) smtp.mailfrom=kmehltretter@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790829742;
	b=sUrvxfiBiVaP5fNPwoGUqztC7kObirH+1JT3rtr+AdrqbOwpH6tmjPjqwKwSJ3k+Px9eRG
	YDnyt8/pWHw50U+ks+v+67tqT8t3OO3xrW5+mUl9xTdzbbitsAvP2t8doyscXeONIPgImx
	XxBVyO2oc4PeIsSRX5+Et+lStMMcsPw=
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49ff9642c57so11796505e9.0
        for <linux-mm@kvack.org>; Wed, 30 Sep 2026 21:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790829741; x=1791434541; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XIBJllRq9Qoioyf410EUtaPM6Z2WKPJiq8KVjKLjAxE=;
        b=Nhhv9XHduFFdqyv2cQmZV49jlwwUdO21IgZ9KbDdaRE8vUHLX63CNu5pM1ipoLW/AE
         15X/plsnPCG/WFApb2OFpms4dOUgv2f8teC3dOKhNab2GNNWaGtGm1p1IMkC/ADZp9Bt
         HUoM/uUowFAh/nMuVPYzDhTTHuXCXCRMahuis1vySCnwtUKdChh15yZG11VKtgdY/RIg
         EDWBjcZEPBZIiL8X7gKd10RZ0hl4N3+0ORAU4XxBkbFfatjz+39PYbp9phoOaBwX8M+C
         e0RYNfMH2jzQ3Gk50PyvdasyAVEFEC4wm60RVDeDbPXrmxg4hKeD3aPtTUIl+ZJ0FvMq
         GaAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790829741; x=1791434541;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XIBJllRq9Qoioyf410EUtaPM6Z2WKPJiq8KVjKLjAxE=;
        b=jJSv2eBwA5wq+0TWwaDaRVUDHzot1ubGVuJT6YwHSnMaRtvuTuy28eGnMEcIT9aOrj
         qIPBSSOwfSfdaIbOqb28Z6IZiMQ3r8V0MixytLLSOb0GQ9rV02so/ts47YCwbyRi9iwa
         NAeVlyajCshKT/qj8jTr67vjfB7nYk6O1egP0kdOrcBpMZihPosWeNXPjh6E27mdmWRK
         MkeSyBQ/HcywKI3ZfprI99Hvn1LuTBgkrDRHjWM/irpDm2RhwskAvB0fxEaPUO7+BQxl
         1Q8smfWHOWK1tb9DRDfEPsuyiYK+fDABHdNQwZojQEPDo4tsdEf1jwPEL+CXe359HGia
         zwwg==
X-Forwarded-Encrypted: i=1; AKwUvBxyJ//q2XyUG+0C+BVq9PJOy2YmAuN6OIRLkyTRtaysDZovcpHYdOlJ6S3BwLqhjNdBV4LKQGNcGw==@kvack.org
X-Gm-Message-State: AFuF++lrXVA9baL+AR/txOCbyqtfcUrshUEoEk/RCiPhEKz3F/ddHGoX
	7pynxRTw/LuDsBT6MxBNslKKwGluvcxchnXABpmd5U4+IqDR63Bqffl5
X-Gm-Gg: AYBFou0mEpYHyctv7JKffdLIBahbwTpQKjKERbd1bP76j+7shPdCk8Zg8aVn0q1HhY5
	T4gCVQiZ2M817Pz2fXtTEqEoytwq/iLV5u+bo5QlEPFjxrm+WRyB67cqNkA2d6PmEkfcyXmnxcL
	gVPX8Bo9xFKtgQQ+yRAUm9XmBylpG1qcwjYY7x2UIpCKU5ewLel9T/ZQXBwpUMP1nRWoSPN220w
	gvphMHfjbOTlLI8Srz1XlgjC5MYvDMlzgO9ghXNB4RtMEHsEt/ZtsjXwhiPPJPEwGp8H3fjJNP0
	IcaMajbXF+/rhFl4wTXTDXtEwFoJQQxBMamfY0uk6kODQVlKje9h9EuCbkjY9ClWXSb6Ouiqjtq
	dpGVs7U6m0b6qyn8Tc3ZXPkcrLwHk9PQrL/CbE5wuMk9ea71ycyFgefqZFV1M03fYc5SGpGnDJA
	0d9j66esRVjf4oTggs72ezbxlcivGhpX/46gfTeMsDS11c0Byfum/FzpntgXooRD8qR2pjgcZWi
	elVmljQ1PDOyNqm0Qcuf/3CJCdtE8AvP4Kr1jLJXm7kwVwL/0CvLF/QadKkVBvr25h2MKdjqzdo
	FOMOgg/cSezsNT/Lxlp7N60AVwNPH/xCyni6CBp3V5DUnv5jdAU=
X-Received: by 2002:a05:600c:83ca:b0:49e:6581:7baf with SMTP id 5b1f17b1804b1-4a01eaf59c6mr25440045e9.2.1790829741006;
        Wed, 30 Sep 2026 21:42:21 -0700 (PDT)
Received: from MacBook-Pro-von-Karl.localdomain (dynamic-095-117-056-101.95.117.pool.telefonica.de. [95.117.56.101])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a01f6c5059sm32619515e9.0.2026.09.30.21.42.18
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 30 Sep 2026 21:42:19 -0700 (PDT)
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Muchun Song <muchun.song@linux.dev>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Alexei Starovoitov <ast@kernel.org>,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH 2/2] mm/memcontrol: defer final objcg release from no-lock frees
Date: Thu,  1 Oct 2026 06:40:56 +0200
Message-Id: <20261001044056.75079-3-kmehltretter@gmail.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20261001044056.75079-1-kmehltretter@gmail.com>
References: <20261001044056.75079-1-kmehltretter@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7E2671C0006
X-Stat-Signature: jh4mt6re1eyre5uqd1usip96pf5wo3q9
X-Rspam-User: 
X-HE-Tag: 1790829742-908448
X-HE-Meta: U2FsdGVkX18dbk6dP8EBxNC/1bDrrRtvJGjMIiKx198+iO7f5vO08kO/7kayoGNYEkfiCXFcYZF9wRoZru5gOlgUy94QGrWZtGz3RfexsGznc9lsjU+8oAq0c/Z4Pmq/XMcsgqATWFFtTjm30nji7dPxsYPfZbAWAGMiKxi2aYVwxh8dCnhdizkA0gbM8xney3vXFNm9zJRX9qmudPp/7QyoDFkt8REU5BEI1giJ7YCLtBCl2etjg0W5yGxKvwBptHlH60P9CsPzEgmhf07rWfMXgvD8drjzMOnsr7wCiS16S/qhHmbFSBvIP5YN5aPsPSRi2l1b9MOYeAibLeJh4thKkuNi7XEOvyANYsQKPsnsUYvpwvwm/4KuW+cMG2IDURPBdp3aWFnNJWcJkhzX/fagrJ4iD9VvXazaPf0HC3SszBxOoEze5DFjr1xDtkZn6xncTU9PtUm92zjX5YjoDFmkghDHa3O1Ni99wICBNt+ChHJSXBF+b1Q2IWUdFIGD25rYG1oOisb40/hM/hj7ipguDXdbjuTV3B6BBlVMVnff78qLiLBDz287RWyCdzXZT9n/m7s1eHMBTxeWsg6+ARi0o2UcV1DLOkmaOIPCt+sNJtTR25Mfg2QrkFetINNi0v9HSdg4//IRTc+KBe2zr+USDv0+/pVgHViYRvLpFvfOYYQaecehj/HMcLLmPc8hXutDKgI5RlnVHbfwwUimx/xuh4CGaJVVcW9sufOAsTIGc/n2rO6y9ExjEtsn0nb4ggzsJnegbYO/2TKcs8vH3PuwFH6dzAh6IHuIMxHXzLDhNvFlSv7kJvtEWu2M++/oJH2B7vAxpo+ReUpO/jiZbh5jMevxSwUCo0FdMRDRda61KalyIJWZc2PqI2GufRte0tAN8aaaTO4f+4srx8O4CQDaLeQLcMZ+LnkCtp/9XRxhhk36mpxABDw02vRssxDNPze5ooT4PIQL4yA09V7
 G9Ej+Hjt
 2KT17Uu7WphYaMqPwVLDBN5U7rk2e4uAmUwMvCsg/2QB8Y6OAO85jyzyfEOksmytN3QsC8AzjRoCYthH29Y4gaRhjCB51cDN7tMg9trYi5nu+4LUSAjBSY3TFCAAP6RhjrHqtB+HP9/ZVC7zRUZ2T63LOO3JoHzWJIJKGFJ2gGpudEir3rCUBQQ2/bSTHIRKtE+eqzJkXanLqPtLC29DCbJ3CqrDmxhoUun+BZCQcn42tdjWVUXI1j8zaOuSBOQimDQ6Lx+CYFdodyhz26qsie/aKtOmYUcHbd9IIVIe+KtPUuLSU1tEy9/0IVt/9hckbGzzXH3G/ytvSzmhD9Cbb2+n4e0eSercdUOASYaqV+1/NWyVAC800iVm9fht2cKXUq5w7UPsqAh2whJktE7N8lC7EX5fFmNMTq80gUYgUmaqEJDUr5Z81zUUdicrdiIc+wlEG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

kfree_nolock() and free_pages_nolock() can drop the last reference to a
killed object cgroup.  percpu_ref then invokes obj_cgroup_release() in
the caller's context.  The callback can uncharge pages.  It then takes
objcg_lock, exits the percpu reference, and schedules an RCU free.  A
no-lock free can therefore enter regular locking.  On PREEMPT_RT this
can take a sleeping lock while the caller holds a raw scheduler lock.

Make the release callback add the object cgroup to an NMI-safe lockless
list and queue normal irq_work.  Drain the list outside the no-lock
caller's context.  On PREEMPT_RT normal irq work runs in irq_workd task
context.  On non-RT the work remains safe to run from hard interrupt
context, as required by the existing release path.

Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
---
 include/linux/memcontrol.h |  1 +
 mm/memcontrol.c            | 29 ++++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
index 7d1c0ce189a88..c755d946430b6 100644
--- a/include/linux/memcontrol.h
+++ b/include/linux/memcontrol.h
@@ -186,6 +186,7 @@ struct obj_cgroup {
 	struct percpu_ref refcnt;
 	struct mem_cgroup *memcg;
 	atomic_t nr_charged_bytes;
+	struct llist_node release_node;
 	union {
 		struct list_head list; /* protected by objcg_lock */
 		struct rcu_head rcu;
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 856a7d07586cc..63b18c7f1965f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -33,6 +33,8 @@
 #include <linux/sched/mm.h>
 #include <linux/shmem_fs.h>
 #include <linux/hugetlb.h>
+#include <linux/irq_work.h>
+#include <linux/llist.h>
 #include <linux/pagemap.h>
 #include <linux/folio_batch.h>
 #include <linux/vm_event_item.h>
@@ -146,9 +148,12 @@ static void memcg_uncharge_kmem(struct mem_cgroup *memcg, unsigned int nr_pages)
 		memcg_uncharge(memcg, nr_pages);
 }
 
-static void obj_cgroup_release(struct percpu_ref *ref)
+static LLIST_HEAD(objcg_release_list);
+static void obj_cgroup_release_workfn(struct irq_work *work);
+static DEFINE_IRQ_WORK(objcg_release_work, obj_cgroup_release_workfn);
+
+static void obj_cgroup_release_one(struct obj_cgroup *objcg)
 {
-	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
 	unsigned int nr_bytes;
 	unsigned int nr_pages;
 	unsigned long flags;
@@ -189,10 +194,28 @@ static void obj_cgroup_release(struct percpu_ref *ref)
 	list_del(&objcg->list);
 	spin_unlock_irqrestore(&objcg_lock, flags);
 
-	percpu_ref_exit(ref);
+	percpu_ref_exit(&objcg->refcnt);
 	kfree_rcu(objcg, rcu);
 }
 
+static void obj_cgroup_release_workfn(struct irq_work *work)
+{
+	struct llist_node *node;
+	struct obj_cgroup *objcg, *next;
+
+	node = llist_del_all(&objcg_release_list);
+	llist_for_each_entry_safe(objcg, next, node, release_node)
+		obj_cgroup_release_one(objcg);
+}
+
+static void obj_cgroup_release(struct percpu_ref *ref)
+{
+	struct obj_cgroup *objcg = container_of(ref, struct obj_cgroup, refcnt);
+
+	llist_add(&objcg->release_node, &objcg_release_list);
+	irq_work_queue(&objcg_release_work);
+}
+
 static struct obj_cgroup *obj_cgroup_alloc(void)
 {
 	struct obj_cgroup *objcg;
-- 
2.53.0

