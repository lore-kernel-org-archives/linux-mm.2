Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 584C9CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:47:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA5796B008A; Wed, 20 May 2026 16:47:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7CD86B008C; Wed, 20 May 2026 16:47:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 992F26B0092; Wed, 20 May 2026 16:47:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85BF26B008A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:47:16 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 03EED1C031A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:47:15 +0000 (UTC)
X-FDA: 84788983272.04.88191E0
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27F2F16000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:47:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E2e4B+ZF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTpJbO1tKVQThyPyDe/QSLkSILpJicCJeIdh7DNrAic=;
	b=TcZF7LuwJcOO61UcggnOBltuRbx7tvAFlxvvRgPXZoDAYkCKbSff7Km4PK+NhmDR2F8+X2
	nIo3kSHthJ+/eInIOrav+blQx93YLi6NTiHGHR0Lw5r9fTyeL1uKs5ow8QqK0B4M8gcNJ8
	dE+ev/8ThKQPOdiFNa+qhxhaO33o2Dc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310034; a=rsa-sha256;
	cv=none;
	b=dzdeTWknDyP305aUHyfrmWA0NP82jd7bSsK7ypKKBU7hA1gSHdCX0bwbNwa/BQW0Rd6enZ
	//9TNkvoU6A05psk133KOgoKWmyJBn3ZQ75JFOF2T5abZPRahJtxWyeBYnw7wXQoHVzpJB
	yV7RZYTop/1trZag1eHa57twN3J4hSs=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=E2e4B+ZF;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf08.hostedemail.com: domain of longman@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=longman@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779310033;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=DTpJbO1tKVQThyPyDe/QSLkSILpJicCJeIdh7DNrAic=;
	b=E2e4B+ZFizsBD/mX6tzaHuQOz3Mjk5TrLRar3EaRKmObw+x/RBGnMyTzTM9+6NaIHYDS5G
	T3xCWA2esR4w3Vqgfj1aTgdQTPLaJekY0P/Cx/2P344gyP5GeMnpy4iY9T0QUqTYe/QBFz
	VqujkT2brETC/zJB6Umok8wIYP1Id0Q=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-626-ndFzGo3FNNeHTd3-W_5B3A-1; Wed,
 20 May 2026 16:47:08 -0400
X-MC-Unique: ndFzGo3FNNeHTd3-W_5B3A-1
X-Mimecast-MFC-AGG-ID: ndFzGo3FNNeHTd3-W_5B3A_1779310026
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E09FE1956089;
	Wed, 20 May 2026 20:47:05 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.64.248])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A464430002DD;
	Wed, 20 May 2026 20:47:02 +0000 (UTC)
From: Waiman Long <longman@redhat.com>
To: Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Clark Williams <clrkwllms@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rt-devel@lists.linux.dev,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 2/2] irqchip/gic-v3-its: Use GFP_ATOMIC_RT gfp flag in allocate_vpe_l1_table()
Date: Wed, 20 May 2026 16:46:28 -0400
Message-ID: <20260520204628.933654-2-longman@redhat.com>
In-Reply-To: <20260520204628.933654-1-longman@redhat.com>
References: <20260520204628.933654-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: jCYl5go2n3MpX_rZG_0x0QQ-BICJbP6yQpDmAI4Nnmc_1779310026
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspam-User: 
X-Rspamd-Queue-Id: 27F2F16000A
X-Rspamd-Server: rspam04
X-Stat-Signature: e787n37hdjh3ckt6apa9d45yoba8hraf
X-HE-Tag: 1779310034-73228
X-HE-Meta: U2FsdGVkX19gR1hEcxu6sTVd6fOdODss3RfMaoxn+ErkcveJC4s4Eag/W28cvQbPC/xP9MjaXoyhkHMdCpV7zLxe+fqUWEZUA+kR5b/cYzRlpc60W+V8c3dZ28SDRKzBy99eJngv6iqiPPnuvR3WXiRglkI8Xp8vIca/BuxFKFS8IT4/ggZNIHtwOjeisc4HOFaGOR16Eak3fx8h/T7WHokvnynObv9B0ylEQRDPHGEw8qgfmBOV3d5N7/PPxAvnWNrwjhETD4ko/CHJjlcuuUTJ/jQ1lGGCsYWONAQXr1REVvhXAf6UvhAoGX3u1kqSBhetpPRWMnZkDrG9+I5EFpyi4bAFzNHQWhMROtSn6p1Z2WZWQZ5c/bLOIMmn7jzCE2KCBbbmR8ociBPzpSSWM1fbILncl1UeTuph16NJu7LGu+pHxEViBhqtjJAIvvIczuRLeRRsaSN2JceM8207N2K0WfcpwKBPHQlvJsb38dLAVh1xVe0AhVRbQ9Z0QW376HKY1+tfgZjtk5aAfhSoe1o6BUlx1+gtn6EGWkdl3zoqXm2zETB6Lz87lA6QgU2omYHJz5I7t4yDZt4RFaPSgowXVgUsAWe8/mjBGoQvAapp2HVplRq5hPsJJLD/CxdLN+LgeZXnVHzg2NCJiRKxR1KQybYWMAMkgzaWgD81dwftQPL6gQQhlNZ0+VEr+LM/baAhGFZzEw9xzjUKLPYanII+gAp+ZGoJLwPGoS+BnvuA5TGcSBMfZIp8iMhg+/fw4BObYCFzBp4V3S6Ny9LSrqoFwlRPsQqDfspWpxrE5fH3KYrz9UjPEMQwL63mTKwcCV43opGX4j5WpBuMfqWGKPc/z9k0thFVz9TcsTVfrheFxG04UH4vem2G4y9krU0Zaz6fjothazxYj+t7417ieDLOc+DrqYfd6/QB88hdrOaVNOcamNr5YTZe2ZdIr8bDzJByEaRhYl2MLMrPTdE
 dbKFWvYA
 QatrdpMHSBBxjWVsw7nFy+A/dEs7Lqmwm8iHO2GzVF65Tu0DATuMyQS7sCW+MWWVy1G78Na7yF5iXmZKyjcOwIilDGWE2DMZY2klQHA1fo4RYyeJESQYoM1eEwaztbgdU7Y5Zz+Y8RwyYox1TGnfmTniDsxHPNsy4BZ8va75Ri6D56SiaKrMhiuXzdGNx0rM5US0MndrldE101rx2meYeaHA2TUT1Ne1JoURhaAoL2mUCNljQGqLNrKnaWktg6Nf8TJwOn/vRukN2jYqXE9piHwU8CLhIHKNfPaqtir12AxzR0V6YEV3dbVJLrcM2z2QZ9FV1gOTwNnDpmDRwu72e8Pat0Tj+P52yf7JoCA0iI2dTLEmnDlYgwZ9+c9snqdMjKQWOkEM1FgtqUPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When running a PREEMPT_RT debug kernel on a 2-socket Grace arm64 system,
the following bug report was produced at bootup time.

  BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
  in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 0, name: swapper/72
  preempt_count: 1, expected: 0
  RCU nest depth: 1, expected: 1
   :
  CPU: 72 UID: 0 PID: 0 Comm: swapper/72 Tainted: G        W           6.19.0-rc4-test+ #4 PREEMPT_{RT,(full)}
  Tainted: [W]=WARN
  Call trace:
    :
   rt_spin_lock+0xe4/0x408
   rmqueue_bulk+0x48/0x1de8
   __rmqueue_pcplist+0x410/0x650
   rmqueue.constprop.0+0x6a8/0x2b50
   get_page_from_freelist+0x3c0/0xe68
   __alloc_frozen_pages_noprof+0x1dc/0x348
   alloc_pages_mpol+0xe4/0x2f8
   alloc_frozen_pages_noprof+0x124/0x190
   allocate_slab+0x2f0/0x438
   new_slab+0x4c/0x80
   ___slab_alloc+0x410/0x798
   __slab_alloc.constprop.0+0x88/0x1e0
   __kmalloc_cache_noprof+0x2dc/0x4b0
   allocate_vpe_l1_table+0x114/0x788
   its_cpu_init_lpis+0x344/0x790
   its_cpu_init+0x60/0x220
   gic_starting_cpu+0x64/0xe8
   cpuhp_invoke_callback+0x438/0x6d8
   __cpuhp_invoke_callback_range+0xd8/0x1f8
   notify_cpu_starting+0x11c/0x178
   secondary_start_kernel+0xc8/0x188
   __secondary_switched+0xc0/0xc8

This is due to the fact that allocate_vpe_l1_table() will call kzalloc()
to allocate a cpumask_t when the first CPU of the second node of the
72-cpu Grace system is being called from the CPUHP_AP_IRQ_GIC_STARTING
state inside the starting section of the CPU hotplug bringup pipeline
where interrupt is disabled. This is an atomic context where sleeping
is not allowed and acquiring a sleeping rt_spin_lock within kzalloc()
may lead to system hang in case there is a lock contention.

A possible workaround is to use the new GFP_ATOMIC_RT gfp flag where only
spin_trylock() will be used to attempt to acquire spinlocks in the memory
allocation path to disallow sleeping. As this memory allocation is only
needed for the first core of a new socket in early boot, the chance of
memory allocation request collision is low. In case it happens, direct
injection of virtual interrupts from the physical Interrupt Translation
Service (ITS) into a guest Virtual Machine (VM) will be disabled.

A longer term solution is to defer the allocation to a later stage of the
hotplug pipeline where interrupt isn't disabled.

With that change applied, booting up a debug kernel on the same 2-socket
Grace system does not produce such a bug report anymore with no direct
injection disable warning.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 drivers/irqchip/irq-gic-v3-its.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 291d7668cc8d..d78057fb40df 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -2927,7 +2927,7 @@ static int allocate_vpe_l1_table(void)
 	if (val & GICR_VPROPBASER_4_1_VALID)
 		goto out;
 
-	gic_data_rdist()->vpe_table_mask = kzalloc_obj(cpumask_t, GFP_ATOMIC);
+	gic_data_rdist()->vpe_table_mask = kzalloc_obj(cpumask_t, GFP_ATOMIC_RT);
 	if (!gic_data_rdist()->vpe_table_mask)
 		return -ENOMEM;
 
@@ -3271,6 +3271,8 @@ static void its_cpu_init_lpis(void)
 		 */
 		gic_rdists->has_rvpeid = false;
 		gic_rdists->has_vlpis = false;
+		pr_warn("GICv3: CPU%d: direct injection of virtual interrupt disabled\n",
+			smp_processor_id());
 	}
 
 	/* Make sure the GIC has seen the above */
-- 
2.54.0


