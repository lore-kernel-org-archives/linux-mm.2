Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3AD0F483DD
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 18:06:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253866B0005; Mon, 23 Mar 2026 14:06:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A906B0088; Mon, 23 Mar 2026 14:06:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 140E26B008C; Mon, 23 Mar 2026 14:06:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F39E26B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 14:06:21 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A168B5CA95
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:21 +0000 (UTC)
X-FDA: 84578107362.17.76B2E4C
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id C8AC84000E
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 18:06:19 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JY2rqyfs;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774289179;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=gEvSxtrzYGpVKgIGT9raVw+1EoupmNph88kO1XTraC4=;
	b=8UyXxQNarhY5D9hDqZFDxRnMpJz5OTTs0Ap0+ky9/jipLlMFCIQ/iubwAQqFQnMbiTDgTk
	/UjRHVyunLjbdL0ZeFkeusAds5EtusJ2V1FRjvhqXX+TdWxdWkZsGllmYnWcnfWXZvsmow
	wZDUk0//jDcerzo4oupMdWIAWrp+3ss=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=JY2rqyfs;
	spf=pass (imf07.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774289179; a=rsa-sha256;
	cv=none;
	b=VrT7X6sA5e9gyqy0gWZLQmIMfHYHY6GcIfHx8GmM6ydvwrn7sqgn0ze/nDsSFNXWodob8V
	88cc4W072DWCqw+Q6q9LesfIBjVJabDR3zQ8cIwv1mY4fJC1DKDcXwO4NAA8GhYtDf8YX2
	lEMkPYNpOTEl1vpY1rmZnHhR/OAL7RM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774289179;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=gEvSxtrzYGpVKgIGT9raVw+1EoupmNph88kO1XTraC4=;
	b=JY2rqyfsylP6HO4NNRuffi2aRWZqorZXiUfQ7qFbDBHf/gOPkxMDHCwXWms+Z3z3kxtmPs
	mOOxnb0D0ry50LxSAaNiCUEx4xpvEtIAwO/s+h/cNYRxl4N2YSrgK4Ym3L01hzgLFNxSJB
	Zni8/HVgZf2193p+qF5Ebg2tRh6DTjE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-86-6jn68d9RPsKCjhzeCFipNQ-1; Mon,
 23 Mar 2026 14:06:15 -0400
X-MC-Unique: 6jn68d9RPsKCjhzeCFipNQ-1
X-Mimecast-MFC-AGG-ID: 6jn68d9RPsKCjhzeCFipNQ_1774289173
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A0FF41956056;
	Mon, 23 Mar 2026 18:06:12 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.4])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 71B4319560B1;
	Mon, 23 Mar 2026 18:06:11 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id B050A401F594C; Mon, 23 Mar 2026 15:05:44 -0300 (-03)
Message-ID: <20260323180150.273664528@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 23 Mar 2026 14:55:46 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: linux-kernel@vger.kernel.org,
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
 Leonardo Bras <leobras.c@gmail.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 Waiman Long <longman@redhat.com>,
 Boqun Feun <boqun.feng@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Marcelo Tosatti <mtosatti@redhat.com>
Subject: [PATCH v3 2/4] mm/swap: move bh draining into a separate workqueue
References: <20260323175544.807534301@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: g6vVQs81aBvT47WboUogGrNoBF6lziT-pHQQqlNvz68_1774289173
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspam-User: 
X-Stat-Signature: cm5g1j1eg7ohts9rh5rwxycutubbmrdr
X-Rspamd-Queue-Id: C8AC84000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1774289179-560103
X-HE-Meta: U2FsdGVkX1+i76ABEmHkhDjIlIwGYZ1zGiuGOgBHHqgKwK9d3lwQ4/v6ekrtOa6DS9YgE/Pycck2L5Hs1+eGgvi00JMjFb7yrtWvN6/dO/jee6t8irlqtpFYjguVHukdePOeC0URT8n+ho0mPa5Vx6wBe6yvnbQihkjgG5pP0JCiH/Fza6YzgpEw/cGav78M3IJBNxor/ThLyF0WlJdLuIWmH18aaFKqWjH2B7uSyE60ITHoKAmjDvkulBer+ljUZ+QYRxwCLVAFkmC8weFLe2/1UHBBBjIcJ6qwYouCLMmGcI9woGFR6Z+uDHI+bxtoo5spDjK0TWZwfhP4BvCzK6ybCEU60WqXcd5Megj7/GG/kWlNdiYDKE6fZSRPtjHi8eyglHKvo2suSP4aLaBESrxJoEVBZAUdZDqsqxaBx2xzQGpBN+c4VLlhKMzAeUjNxxwRhRw3Vc6CKZYKzCAdDWw1766gVc1V9aJTCi2ZVGxWvl5b+nJtXd9d67UC7BpBF26QgsEbH57tFZtzlQOBl6vBSuR14cIwU4Lrf2jhJRePUFWjkIcO9wfN+QQCNGUHTcGaagdjkEF7m7GVKXolNJ8ciT4+0JLtMCCC1riUULEmO9patSl1BJOTxCsFerrxDYKP+I3fdl62jDqw8Q3VFpj122q1NxosWaFXwnmKZx+oS5sZiWDwCyY3ypqIKO6XaffscS3m/w7K5am4I37OOnMKo+Ahg8iHkjV8U58UqWSVnLNR1qgeJZA92Yt6noz+qXSVlIzNWxjM3pJahhhoavbpxVfvR2M7gGcVVL9jVLu5gFXTrEQ3z+/J+g41/qYgtmidZdEobnooDpj/JtqrkZlqm6I52MbCSmX2GYoAejx45e6Be5FcF8A2baHxC3LE8fcb12HcZaqXnW+vj67/XELk8kD1sOvf0mpc5A81jx+yVUTad8ZjnJ20/1OwhjSDXAORaIAkKiXL+pC894E
 jd2iYaHW
 gDdC83fJTbkESfYZLQMIPzCqU+HZEym/xQMbHQthE/0UmdXikooiOb1Ri0/DQpDB7+dAlaQ0hcFRZXyclqanJpFtQtRsL802bBq2TH0Hqnyzvp0zJkeAGfdGCShgUjhk5DboDPjIUFfER0VZLSA73Sdbc0MeNX12sbsZAFCHPAoB+rw0kzCpL7WfX5qRTm9uhkxRLHZBry9JgZbVGIGw49gPPWa+6PK41Ggib+yj0HCz5dEVuih6NsRDi+u5bwButkEBAonZzAudD5zmc9+q4tD7jCRpG81IEv4NPQ4RVuM9guAa8klLzlibXc2HceeWjJ2dNME1OxwZQF+AIPM9bqfcd4SUbxud1S8vH/YfunM1YoAVv5Zp/25VwZum9Dn6joCQ0
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

Index: linux/mm/swap.c
===================================================================
--- linux.orig/mm/swap.c
+++ linux/mm/swap.c
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
 



