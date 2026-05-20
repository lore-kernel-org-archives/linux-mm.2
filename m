Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 274E3CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:47:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BCC26B0005; Wed, 20 May 2026 16:47:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 092516B0088; Wed, 20 May 2026 16:47:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE9C76B008A; Wed, 20 May 2026 16:47:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DD5426B0005
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:47:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 89F501C0596
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:47:11 +0000 (UTC)
X-FDA: 84788983062.21.8F9C096
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id AC6FD18000A
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:47:09 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OUUs7Pww;
	spf=pass (imf16.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1EyYbR+jhGOTsmqCZIrtN6+oCATdrHEFLzp24eY2naY=;
	b=Lz0AwrhtICz/h7mHKWxcojPUIBJD/ZZIxWDQQtGOHZDkCw9/tMu14iIeQHfyjXwr9O/B7f
	Wd+nEYvH1CGCVVplmTf7Remnolm7ch63iNeWyJ8c0FkRL0JjHJyzmuh8v8gcmp9APW87zP
	49RG4pUx1CyR9CjzTERzXXtpcWuH44I=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=OUUs7Pww;
	spf=pass (imf16.hostedemail.com: domain of longman@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=longman@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310029; a=rsa-sha256;
	cv=none;
	b=e7P9YVbttjf9oApgJph2Ose1xIgKtvpvaFEV0izBOoXfZ1F7lV89ZDX22WOnzO21p31m75
	4cn2vJesZvbx8mf3IeBI1oZ6YW+UirTThkTt2iwmiJzavhCMhkHJfPYzE3V8PQVzMuyoB9
	P5b4dm0YW6sl5enVDltFLMQIDdkp6gg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1779310029;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=1EyYbR+jhGOTsmqCZIrtN6+oCATdrHEFLzp24eY2naY=;
	b=OUUs7PwwTrOn17eT57htXnkubqqrfoOT7w2h4P6UoPnKZOgkzjGD3zEQvNMoNElpeMKAL6
	A2zaz9SYd24IoHQRJd5a1JheNO4hotoXHgQQcocicA22xd2O2w7a8+nCMJL8b1VFEeHPMs
	JyXvcExPTPMQdS8J6GipxlWEQCtPfCg=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-581-V_6Urf5lOjC4rh9_O4x6YQ-1; Wed,
 20 May 2026 16:47:06 -0400
X-MC-Unique: V_6Urf5lOjC4rh9_O4x6YQ-1
X-Mimecast-MFC-AGG-ID: V_6Urf5lOjC4rh9_O4x6YQ_1779310024
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6E2F8195605B;
	Wed, 20 May 2026 20:47:02 +0000 (UTC)
Received: from llong-thinkpadp16vgen1.westford.csb (unknown [10.22.64.248])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id EB07730001A2;
	Wed, 20 May 2026 20:46:58 +0000 (UTC)
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
Subject: [PATCH 1/2] gfp_types: Introduce a new GFP_ATOMIC_RT gfp flag
Date: Wed, 20 May 2026 16:46:27 -0400
Message-ID: <20260520204628.933654-1-longman@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4
X-Mimecast-MFC-PROC-ID: 4P-PrTkNJ9zLF67W4IbYSdp2HyNM4Yncj01YeyhXMiQ_1779310024
X-Mimecast-Originator: redhat.com
Content-Transfer-Encoding: 8bit
content-type: text/plain; charset="US-ASCII"; x-default=true
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC6FD18000A
X-Rspam-User: 
X-Stat-Signature: dm5qghr47s9ro1ziowzkzutktprjgtb9
X-HE-Tag: 1779310029-224373
X-HE-Meta: U2FsdGVkX19dKtPTcFdZ9xIxF+dI+ZXbzueqeq8yco1OzCsMaQLSY9f1+zgEFqCkDHrh/OdwlTuHmv/h0cc9gyfnKj+B9F35pP+P2FcMJIYEaCvXoWF0GulhBbJmuJHaAHBgFo1Yav3/Jf2Ep55cXezLGocKLWjTjaPeLl65Fz1jXRIS23uO4qAo8HhtvhzhZyNjqRlXyHcVbYBsX+3dBOXKwK7FN0ykz/1Pr0uAbP64mQwykaeXlanxZpSP053iBC2oNLEujiYPZM7ZvMtrlVzuzQSooeSrTaadfR9BYLQSwcI4UGKp1FMds3ledz4PM/YhDpjKwlYAFcD79B44OnXRNHppbXu40Y6yODkjX2DzH2dQxIz0SmjKRSg9qPFsY62GV/Cwinl0SrqVwNfVldaaMgnl3GNTcG6yF7zaLz9DskaXb+DkUn+SkO662AzHViZ/ZQO6innRM2uKIDQufdyH5kBsocvoRjrEbQOdTD3mt2K8D1Ews7EY4OTykdoDjVvb7oNwvFmX4pX77hUWHZiipgLAkwwjIeWe85Pdkh5B42tT9Q90FvzEYmvzT+ynzkQMWu1UxxnIq9Dg9GWeLn5ouUB4EMZq/ZJ4nxjZAWroYRRJKh3VST9FpinnNcvoN39LJOQM+tYLpdOBCGTBR+aPmVhwwSOUJUSc7bYX4R85SB/2qJ0kzVHmLJrlghjNbdD6e4zF0zPGIcmPtn4lnsZAV4Ezkueho0ZrPEyNg0oHqRdlGz3AwB5UBXwQzBrpOiKtKEXn+avJki1XpLqOx0Y3c/YXnsBunZruGXtTsAx/9E5u+K0b9JydPsloeVXIrZdrNwDDVEpD1hFHy7d5DSNyNBiJ+HVf21vYBJg3++PxhB3Z9HlRUK7hGfytqAKV7yqd62xLUTcGUludgayHHPYLptD3LrKq05HChTsJCqSHefH0AMRAqROgeyFnZU/B1thdn2xVQAL5TUnI+u0
 kO3ejeLg
 z41+7auYXNG1NhthluFFbG3kdHqKTFCDWDf/+v1GXJvLkaQfe5Ut7lLmBfCQ2wSyFIjVHf8+2Vua5ulTomjjero1T5iljb2HQlADnZ2kHeQg4P0P+sTBfk1Eqj/VGgYWVEym5z0g+ZFwECZYhfbiNFjhzHuoUuAX6f511p63c+mOLRj26VZahFks0EAg3sW0ojLC4sobVFUj0jETXxHy4ccYp9EfSxy57JxB2dLDXhekfOr9LcQC1PqenO6PpRmF85e6lYj5KlANB1I/GRmk79WZjMl2m9J45COtNyWpgMREED8cuu1q0Bp9Y+J42kmy8pr+YBmker5IrlCiguFE2/YMFtK7k0GENoTx+LDI686efp8JKdJyZn3u9kxXtH3Ptc+vFMTNd8mv5h4I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The GFP_ATOMIC flag is to be used in atomic context where user cannot
sleep and need the allocation to succeed. However, it does not support
contexts where preemption or interrupt is disabled under PREEMPT_RT
like raw_spin_lock_irqsave() or plain preempt_disable().

With the advance of the ALLOC_TRYLOCK allocation flag in the v7.1
kernel, it is possible to allocate memory under such contexts by using
spin_trylock to acquire the spinlock in the memory allocation path. This
does increase the chance that the allocation can fail due to the presence
of concurrent memory allocation requests. So its users must be able to
handle such memory allocation failure gracefully.

The ALLOC_TRYLOCK flag will only be enabled if none of the
___GFP_DIRECT_RECLAIM and ___GFP_KSWAPD_RECLAIM flags are set.

Introduce a new GFP_ATOMIC_RT gfp flag for those PREEMPT_RT
atomic contexts.  This new flag will fall back to GFP_ATOMIC in
non-PREEMPT_RT kernel. GFP_ATOMIC can continue to be used in contexts
where preemption and interrupt are not disabled in PREEMPT_RT kernel
like spin_lock_irqsave().

Signed-off-by: Waiman Long <longman@redhat.com>
---
 include/linux/gfp_types.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
index cd4972a7c97c..ac30882b6cd4 100644
--- a/include/linux/gfp_types.h
+++ b/include/linux/gfp_types.h
@@ -316,6 +316,13 @@ enum {
  * preempt_disable() - see "Memory allocation" in
  * Documentation/core-api/real-time/differences.rst for more info.
  *
+ * %GFP_ATOMIC_RT is similar to %GFP_ATOMIC with the addition that it can also
+ * be used in context where preemption and/or interrupt is disabled under
+ * PREEMPT_RT, but not in NMI or hardirq contexts. The allocation is more
+ * likely to fail under PREEMPT_RT due to the spin_trylock() nature of lock
+ * acquisition. So the caller must be ready to handle memory allocation failure
+ * gracefully.
+ *
  * %GFP_KERNEL is typical for kernel-internal allocations. The caller requires
  * %ZONE_NORMAL or a lower zone for direct access but can direct reclaim.
  *
@@ -388,4 +395,10 @@ enum {
 			 __GFP_NOMEMALLOC | __GFP_NOWARN) & ~__GFP_RECLAIM)
 #define GFP_TRANSHUGE	(GFP_TRANSHUGE_LIGHT | __GFP_DIRECT_RECLAIM)
 
+#ifdef CONFIG_PREEMPT_RT
+# define GFP_ATOMIC_RT	__GFP_HIGH
+#else
+# define GFP_ATOMIC_RT	GFP_ATOMIC
+#endif
+
 #endif /* __LINUX_GFP_TYPES_H */
-- 
2.54.0


