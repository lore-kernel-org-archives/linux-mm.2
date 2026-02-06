Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73AC2EE20AA
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 14:40:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689CD6B0096; Fri,  6 Feb 2026 09:40:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D46E6B0099; Fri,  6 Feb 2026 09:40:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E9836B0096; Fri,  6 Feb 2026 09:40:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3955F6B0096
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 09:40:19 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F10D814021B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:40:18 +0000 (UTC)
X-FDA: 84414292116.23.2AF3718
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 04C6C18000E
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 14:40:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YvbvYQ9F;
	spf=pass (imf16.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770388817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=+1brVgWYEq0ZWfMlhAaXgacR5RpthFeG1w4z1Bx58lo=;
	b=zpYJgMJDRNsgmzeNzErXFksltLLJQmVUPJjmS65vyNYT2qhdsFYpAYDsWUzwvbo8POWvSa
	bCP8LlbLH69hb/ukcH6WVJ+ZEe88kEUtTHUVoJxuBcj4viCYyMTqBDcosH21Z0H1R7nKKL
	HYtnjSWCS30ak2hlpjg0DfDYPx+4n40=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=YvbvYQ9F;
	spf=pass (imf16.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770388817; a=rsa-sha256;
	cv=none;
	b=6xF+bZzJXZN/VKA/cpw7wtj3KEej9rmguhsuPvJlljX/YeV7wg9nS5VNJ1sp+YDtuDJdGh
	L/XxK+pklLYehde7/Xfztar+zRSrV1lkba78AM4Hd+rrl2WJnBmzDl0B8p0OSqYhAllYP0
	IclPDXB0TjimRXEGxFvqk9ZtdTB5FFM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770388816;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=+1brVgWYEq0ZWfMlhAaXgacR5RpthFeG1w4z1Bx58lo=;
	b=YvbvYQ9FdthxRTuxO9nBB4vlH3/vRxbYlty32tjyqJmshmrEpul9qHA5lUo2ZnbfyMh+K/
	Du/tII3jx/0W3HVPDtXFyIFZoDraUEJsZR885lcj/vnO7LAlWFIt2BuZRZPb7hZNq0ZyWi
	ad+SO2EEw5twZ8jF4NwHdRy6o2HB5k4=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-358-qKQQ0E6EO7K-OUnMby61xQ-1; Fri,
 06 Feb 2026 09:40:12 -0500
X-MC-Unique: qKQQ0E6EO7K-OUnMby61xQ-1
X-Mimecast-MFC-AGG-ID: qKQQ0E6EO7K-OUnMby61xQ_1770388809
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1A5E91955DCA;
	Fri,  6 Feb 2026 14:40:09 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.22.74.16])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A2978192C7CA;
	Fri,  6 Feb 2026 14:40:07 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id A8AB741DF09D7; Fri,  6 Feb 2026 11:39:20 -0300 (-03)
Message-ID: <20260206143741.557251404@redhat.com>
User-Agent: quilt/0.66
Date: Fri, 06 Feb 2026 11:34:32 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@linux.com>,
 Pekka Enberg <penberg@kernel.org>,
 David Rientjes <rientjes@google.com>,
 Joonsoo Kim <iamjoonsoo.kim@lge.com>,
 Vlastimil Babka <vbabka@suse.cz>,
 Hyeonggon Yoo <42.hyeyoo@gmail.com>,
 Leonardo Bras <leobras@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH 2/4] mm/swap: move bh draining into a separate workqueue
References: <20260206143430.021026873@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: 0D0zX-97cP6z51R00l6VQ8BMXF1X3XzYUGh1GXWEheg_1770388809
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam12
X-Stat-Signature: qczkcysw35mgnrinxjszcd7fswfn6cde
X-Rspamd-Queue-Id: 04C6C18000E
X-Rspam-User: 
X-HE-Tag: 1770388816-65703
X-HE-Meta: U2FsdGVkX1/MzYVzEhZpqtf1EZYzcxWSM57Vm6nEJDlYAD7GF531nQ1j+ox+CHZuC38GvMc3AZG9L9eZ5Yk/fgXEgLhlUqqWdeidIYQ8QjFOBFdXTX89OL9hsP0mw143Ij3ln9YuJB+6uV6pEv3lwMwe1mtHUfQQ7MlscxxwhVhcI4gCP8w3Fy+vSZ+WQqGDtAKLdLfxoHfbxlzhSkZ0g72flMOMZw1llWKBMNLocfelL71IS4o+4vVFN5i9KceDCXf7+D54YGKtgL9ouVPHv1xGl99BV8ADwv8FFIoL0vuopfvR1iY9k6OsbGsKKKmAFoh06FUmpXIrDjaOUweimIISyjcx27G414Q/rK+gpD78kPbrYmO2f3dP3YzF0eHh7zolo0GmPycj2jfltyfPKwPT7sWeZPYNIPR4qu2VoHBIvn5L7GwyUzPA4hZbhAhZqKcKkphtNIUhs7dIWWHn8JgPTNHfrq8mwYXE6YOXgG4YWnntvIiGfuRV5bdwoGeyK94UY34CRCKJwtaGKCRethkUc08wXecG+fBrzBMbWE81P/rbF/iDn31YWOD1Z0BKMTr7KG0bPeVQjnQqMU1YiUhxAXs1eaJjAXRZeXly/Ivfojcbp3+/ydFemmaVv0+xlX44Ygh06jJgaf4fZmsGbkhNfpgJSK7SXq/tTe/9hrIj7ha5LwrTPJnj4EPqG7VzUzY40LnVvSObY81KxV9yV0AkOpI6ZByWkzmuDKUnJLrFJADMei/CVYWhTplYlzf7BXIxHXyq6BXnAfP2KUCQuWK7I3m5v7yW+DQ+qoavGdXdPw7aBM7gRxmw64BuPGm+cEC4LfaOrS2KXeamJuRIwf+fm18qTm10HfoWh/S7nTzpoETqTLBsQ/+2IAGhBOZfTgGMfI/wsSlc9BokZBTqc2chNaESunbSHlL6Myn0xtXJMFIDkpReDSP4VdkFAKJUr/sMMzxdzALn0vzNQ7n
 qgeH4NdW
 WjLfnXAjvzj/UEZS4hktCJdY1OKoAhIA9y+cfBQfRYfzlHqxMZ/d7EsKAAcdqYVJQ7OvjgFykuDd3yeASXN3f/BAVgDgteiRSLLTd04ExzjgSVOGdpaYWwCksHs3l59dYdVYq06MqOqWQPMl0WJKX0RhpJqYfL1YpC+Ncp81GV71cc/Duj4jDydNooUmDWneh/XuYJcV6rZRZOCDgqqEIjSXEfYOo+FZL2Y4hF1tq4rPntjwP/mW5Z2YEVWbyt66OoME9wm9yLfArQHrnqWTyESx1karyFrgzHJys/5zZC7QnSmW0SoFr71VIYM6mD/ykVQ9OfPd8jqHfrUpbs1f871mf6IqQFPwUZTTLbIJvha3te4Mvc3Ju23ICmoM4ZXj35d0O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Separate the bh draining into a separate workqueue
(from the mm lru draining), so that its possible to switch
the mm lru draining to QPW.

To switch bh draining to QPW, it would be necessary to add
a spinlock to addition of bhs to percpu cache, and that is a
very hot path.

Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
---
 mm/swap.c |   52 +++++++++++++++++++++++++++++++++++++---------------
 1 file changed, 37 insertions(+), 15 deletions(-)

Index: slab/mm/swap.c
===================================================================
--- slab.orig/mm/swap.c
+++ slab/mm/swap.c
@@ -745,12 +745,11 @@ void lru_add_drain(void)
  * the same cpu. It shouldn't be a problem in !SMP case since
  * the core is only one and the locks will disable preemption.
  */
-static void lru_add_and_bh_lrus_drain(void)
+static void lru_add_mm_drain(void)
 {
 	local_lock(&cpu_fbatches.lock);
 	lru_add_drain_cpu(smp_processor_id());
 	local_unlock(&cpu_fbatches.lock);
-	invalidate_bh_lrus_cpu();
 	mlock_drain_local();
 }
 
@@ -769,10 +768,17 @@ static DEFINE_PER_CPU(struct work_struct
 
 static void lru_add_drain_per_cpu(struct work_struct *dummy)
 {
-	lru_add_and_bh_lrus_drain();
+	lru_add_mm_drain();
 }
 
-static bool cpu_needs_drain(unsigned int cpu)
+static DEFINE_PER_CPU(struct work_struct, bh_add_drain_work);
+
+static void bh_add_drain_per_cpu(struct work_struct *dummy)
+{
+	invalidate_bh_lrus_cpu();
+}
+
+static bool cpu_needs_mm_drain(unsigned int cpu)
 {
 	struct cpu_fbatches *fbatches = &per_cpu(cpu_fbatches, cpu);
 
@@ -783,8 +789,12 @@ static bool cpu_needs_drain(unsigned int
 		folio_batch_count(&fbatches->lru_deactivate) ||
 		folio_batch_count(&fbatches->lru_lazyfree) ||
 		folio_batch_count(&fbatches->lru_activate) ||
-		need_mlock_drain(cpu) ||
-		has_bh_in_lru(cpu, NULL);
+		need_mlock_drain(cpu);
+}
+
+static bool cpu_needs_bh_drain(unsigned int cpu)
+{
+	return has_bh_in_lru(cpu, NULL);
 }
 
 /*
@@ -807,7 +817,7 @@ static inline void __lru_add_drain_all(b
 	 * each CPU.
 	 */
 	static unsigned int lru_drain_gen;
-	static struct cpumask has_work;
+	static struct cpumask has_mm_work, has_bh_work;
 	static DEFINE_MUTEX(lock);
 	unsigned cpu, this_gen;
 
@@ -870,20 +880,31 @@ static inline void __lru_add_drain_all(b
 	WRITE_ONCE(lru_drain_gen, lru_drain_gen + 1);
 	smp_mb();
 
-	cpumask_clear(&has_work);
+	cpumask_clear(&has_mm_work);
+	cpumask_clear(&has_bh_work);
 	for_each_online_cpu(cpu) {
-		struct work_struct *work = &per_cpu(lru_add_drain_work, cpu);
+		struct work_struct *mm_work = &per_cpu(lru_add_drain_work, cpu);
+		struct work_struct *bh_work = &per_cpu(bh_add_drain_work, cpu);
+
+		if (cpu_needs_mm_drain(cpu)) {
+			INIT_WORK(mm_work, lru_add_drain_per_cpu);
+			queue_work_on(cpu, mm_percpu_wq, mm_work);
+			__cpumask_set_cpu(cpu, &has_mm_work);
+		}
 
-		if (cpu_needs_drain(cpu)) {
-			INIT_WORK(work, lru_add_drain_per_cpu);
-			queue_work_on(cpu, mm_percpu_wq, work);
-			__cpumask_set_cpu(cpu, &has_work);
+		if (cpu_needs_bh_drain(cpu)) {
+			INIT_WORK(bh_work, bh_add_drain_per_cpu);
+			queue_work_on(cpu, mm_percpu_wq, bh_work);
+			__cpumask_set_cpu(cpu, &has_bh_work);
 		}
 	}
 
-	for_each_cpu(cpu, &has_work)
+	for_each_cpu(cpu, &has_mm_work)
 		flush_work(&per_cpu(lru_add_drain_work, cpu));
 
+	for_each_cpu(cpu, &has_bh_work)
+		flush_work(&per_cpu(bh_add_drain_work, cpu));
+
 done:
 	mutex_unlock(&lock);
 }
@@ -929,7 +950,8 @@ void lru_cache_disable(void)
 #ifdef CONFIG_SMP
 	__lru_add_drain_all(true);
 #else
-	lru_add_and_bh_lrus_drain();
+	lru_add_mm_drain();
+	invalidate_bh_lrus_cpu();
 #endif
 }
 



