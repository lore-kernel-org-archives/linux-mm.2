Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C299EA4E24
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 15:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 74B536B0093; Mon,  2 Mar 2026 10:53:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72CD36B0095; Mon,  2 Mar 2026 10:53:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 635AE6B0096; Mon,  2 Mar 2026 10:53:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 5280A6B0093
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 10:53:29 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1B3B21C18C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:29 +0000 (UTC)
X-FDA: 84501567738.10.407BDCF
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf26.hostedemail.com (Postfix) with ESMTP id E3D8F140009
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 15:53:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZssI50o;
	spf=pass (imf26.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772466807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:references:dkim-signature;
	bh=gEvSxtrzYGpVKgIGT9raVw+1EoupmNph88kO1XTraC4=;
	b=QdndI/ev9tJKPKtQ4fqopWFpmSjP15wRtzWB1cj1/Q7jVr/E/3qymAi0TmjOa5tERmvMy5
	Sb3cqoDV7xAXG9lJM477LM4/OcrT8RHXTFqhh6DAdV6X4gIICqBSj/nNl1yGPY5ae79lsg
	BdxDV3uhPRxJjeYWaiu1H1ZPIDB4R0c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=HZssI50o;
	spf=pass (imf26.hostedemail.com: domain of mtosatti@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=mtosatti@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772466807; a=rsa-sha256;
	cv=none;
	b=pZ07pnF/slTF0DaGKOzC4p0IAyNbSvZZM//epoCn/cSzaax+dEe6R2eh0n2KTp+dhxFNzG
	LMLCmsLXbY1Uu7SJuMYIqJh6X14HER6I3ebv4ZUPtxQSdJnvsnbDaj88AHC4aTG0ITg263
	3wjzFEsAiaRhHEz+Q4fOmd12cgvLKks=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1772466806;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 references:references; bh=gEvSxtrzYGpVKgIGT9raVw+1EoupmNph88kO1XTraC4=;
	b=HZssI50oPM5FvtufYPTseVe0l2DpwAucu4TN2DMRJSKBk85DxgDV2E3o81Zw8PvdGrZthI
	EpQ0/raqosJsIBYm3UxhiGAKs1SzJ+1Ft3MOgzDQFfteaUfyYzHnHAvPBgdoEFIJAU1Bqq
	X09INcIOL09rCMo9gMXcDvQEGK89enY=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-175-YkntcpPxPMWb90hKfgc2Ag-1; Mon,
 02 Mar 2026 10:53:25 -0500
X-MC-Unique: YkntcpPxPMWb90hKfgc2Ag-1
X-Mimecast-MFC-AGG-ID: YkntcpPxPMWb90hKfgc2Ag_1772466802
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1F3FF18005AD;
	Mon,  2 Mar 2026 15:53:22 +0000 (UTC)
Received: from tpad.localdomain (unknown [10.96.133.6])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D7AB319560A3;
	Mon,  2 Mar 2026 15:53:20 +0000 (UTC)
Received: by tpad.localdomain (Postfix, from userid 1000)
	id A071940241EA6; Mon,  2 Mar 2026 12:53:00 -0300 (-03)
Message-ID: <20260302155105.245118324@redhat.com>
User-Agent: quilt/0.69
Date: Mon, 02 Mar 2026 12:49:48 -0300
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
Subject: [PATCH v2 3/5] mm/swap: move bh draining into a separate workqueue
References: <20260302154945.143996316@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12
X-Mimecast-MFC-PROC-ID: mMFa39bfj1begbB75VLoNgnUrXkIdThapSbHRtHh4OY_1772466802
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: E3D8F140009
X-Stat-Signature: oooeectzypo4ch8cjh16ha7bzhwhnuwy
X-Rspam-User: 
X-HE-Tag: 1772466806-88026
X-HE-Meta: U2FsdGVkX1/3cV2olH3QGKwVhnAt0dWysRgi0NdKO+rLpEb+ju4TggARl3XnStXYgPsyu6VB+RNEWwQLYBA65AyaJOVSi9Ol5WomO/OCLV/CcuvsqoLar0uTzLIhsddN8Dj1xzpOfMnq31Fyrx3QsPytM2k3Q+gRa4Rx8xrG54KFOXXlmri8Ooc6jsuCkiVFYNLKwlX3mUOHUhy0Gd88yppst6ITL0/7Mh+4vh3rO6xR4uvISBuP5vPlD9CpUgOommMO+TF0yHrikNaw8A4niYmu0VB9hBrsW1qWawUyH4gyt0So2W/j0fpI2n/xAEZvRG+M6eSFfelgkEz5j6QRRYxXFL2XE5m0WOkdFWB9HKkGdoNP9Jqk+1aQfAKpY/Wiu6yovxpugHXhlafW4cS/zUFlGygmtHp59CWa22gcaguWHi/moVNdYDtSFUYgArFxjbjD6Fr0ThbmJideF4vXEAkOLk+o7GpVY0nddvBI/m9h8iUqhbk268fvYEGfVdQig2Rid5sXk3u29cpu6uUErdwpFO+b5p2yopaH8flanWKXVQ9uUUofbCsBaaq6vg2r0QsIYALYEBE2IGHL590QeMAlGyMcDWPZTW5DZX9K5aaWY6dPWv440YPHOXGShp6Y/lvtHycvS4o5nSY1LJzN192n6sWgs/+mceFyf9n/GnLDFSpPfW2HNF8dcRnt7GpW7hPK6EN29op3m26+3IJDGAhprs6WHYe9WdcCs/rEhUnrie6fWLDl14Ev3lZci1FHXp+cyW6cB+oaYMnNeiKu80H+LFq8lKyZ3lxd5Zpo+/SLhNnwYluMvxYHu5FKw6dCKvHRLN8exRS2blOGXbPy8S4GTHP6HCFvY+R8g9YWWPAnQDRDYRWUp4OALbfSB6EJsJ8ST2hDy+UStU3I4HOrz14FdnWVrkBYpT1dsFjJ6xF+mysGSRoO9dhT2H7dTQdMleg1ijHbFtiCjDWOmeZ
 TuFuogCz
 vUnW7nS/lKM9bJJUltmonpxtDDeSJBnBXuweuDyRZ4pgfbkd7vHd7FeD4/GjmudzH2Uq+dY0FWhwj+QE9gyabp1CTn+mWSwjG5LSyzSPtp/Hoc83fTcNWXhGjkIL+aNzE3l631TLjnAAnQmuPbvyfZsSjItaEINqPaDbfiz8EX/Wm+ezPF8b0vJ3kmuQotmtb8SZQ3N4P3YnT897ZQDfrcP/JmlHDYOu6WB/51Mvg5fQrUM75uTcpHqxHKNWWwp4TzVXNQzd23eoRPgza9zZ/FjeRpzcSEmTzfOuOQnVVP28vfPiU/jGNsLCB9OMuJ9h4/1LNRiLb9zqLOjUggek0xqZD6yDGVJY0273fxHO1vwTdx1NBU1ygahlRZZ4vUHKTI3zj
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
 



