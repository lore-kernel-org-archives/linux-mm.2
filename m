Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC2F9C54F51
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 14:17:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD8C56B00DC; Wed, 29 Jul 2026 10:17:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8BB86B00DD; Wed, 29 Jul 2026 10:17:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA28E6B00DE; Wed, 29 Jul 2026 10:17:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 92E8B6B00DC
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 10:17:51 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 00D99120609
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:17 +0000 (UTC)
X-FDA: 85041119436.19.B8F3C93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4816AC000D
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 08:21:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SuuMECmZ;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785313276;
	b=3+TqvVaBz58X4qjJYdZ74/u8iOGPDsdJZu7JrtwFGPlk3/ziBUN70YS9Dy3IPoopJ5Dbia
	fkDSOWQk5YOELnzpt/BMlPkvJ/f1sWGd9rfWcEasPS9T7PPfvMSsissHwCN8AKf6mPpl09
	uu/Rukx84TDYMrxN7CVdX9TJ+r6ODCI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SuuMECmZ;
	spf=pass (imf28.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785313276;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ePeO/xV71/tQ7SCmp4Ak6LnQ1NWK+HHBAZv1O4FNQqs=;
	b=P1wZ9wX6I7pAJQusXQKXE0RDcu1KNN6x6v+hHRHIQUiavEmnIuCTaD7ZAbpQrYnB/38wXZ
	CpLlLxI/FaY7Okwa+gRfwMHoPMgKMGt2UVkPuRNZUWq4+mU1sDWBeOD+INMmZKyW/aFEtb
	5eimHXbqYAcSftMh+GBShTvrx/5gaWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9A6A2400E6;
	Wed, 29 Jul 2026 08:21:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 694DA1F000E9;
	Wed, 29 Jul 2026 08:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785313275;
	bh=ePeO/xV71/tQ7SCmp4Ak6LnQ1NWK+HHBAZv1O4FNQqs=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SuuMECmZ5xpzrc3KetrA48u8o+/4Vz8wZ0RNzb5JNCGJx9YIoNwybXjC1ztkYZpT8
	 58P1ug9lPsrbsZcRVa2JNWIldKHQM9IGHW6zgXJK6GUc2OXx/h3mNhboSaa0TWfX5K
	 O02ePjEI4Emm47SQ+OcpROXnTIawTzf2hiMmjQ0TjCQK6uDVunemV8J8o9a1/nGsia
	 poHCRzuX0LXE3O65gpRS3u4SJyceijqgc3EDHU09ItS2tjhqBdNHRwaJ0JJ+8vAjtg
	 Ns1M9AK9++p4cUiZ2joRBWYfYbNADuEO+J73B+4gif2Lr/jeEH4sEtJLN6HU4Gg0Ge
	 XvQEEin9+l3wg==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Wed, 29 Jul 2026 17:20:11 +0900
Subject: [PATCH v5 3/8] mm/slab: use call_rcu() in unknown context if irqs
 are enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260729-kfree_rcu_nolock-v5-3-a28cdcda9673@kernel.org>
References: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
In-Reply-To: <20260729-kfree_rcu_nolock-v5-0-a28cdcda9673@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Alexei Starovoitov <ast@kernel.org>, Andrii Nakryiko <andrii@kernel.org>, 
 Puranjay Mohan <puranjay@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
 "Paul E. McKenney" <paulmck@kernel.org>, 
 Frederic Weisbecker <frederic@kernel.org>, 
 Neeraj Upadhyay <neeraj.upadhyay@kernel.org>, 
 Joel Fernandes <joelagnelf@nvidia.com>, 
 Josh Triplett <josh@joshtriplett.org>, Boqun Feng <boqun@kernel.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
 Lai Jiangshan <jiangshanlai@gmail.com>, Zqiang <qiang.zhang@linux.dev>, 
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>, 
 Shengming Hu <hu.shengming@zte.com.cn>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Stat-Signature: z3fjracoys4tdfd1kqw6sru7ufatmfqy
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 4816AC000D
X-Rspam-User: 
X-HE-Tag: 1785313276-470553
X-HE-Meta: U2FsdGVkX1+/K2tY9xMsoxJtcqxTQvFa3E1OdsFlUnKS3vJxyXvZQZJZqedQOTk6K4VnybrnSEPCqVwp1BPLJsTqSWE95izkU3wjciI+hKAvnkaJyUcp4GXnvp5PRcE8wJdQopLpt8MO79MbdxSaQbS2uhrflm9zbBKxB/GV8d02SFkm4RZjfiDUnXCdwnHRklu7ci14O50r9b0961gBhQlzjJNdah9JNlEPWyek1ZEmoJaLB0+YBVOYE9rlICp9pR1/Iq9YJiJlf80xIFw4rVzkSZV6i4IN61T9i9xhiMOC2NV6pKBI00XOYPO0hsLWCcB8MQ0KEqwyMHYRgkpL2qjlJXAWn/HF8h6bskDGqktcc6dtmwh8wkrCp8cl+piAjokGbAjsNE+Ykn/3XaNKJT30/LWURvTHJB7CpeU0lhV4ENyF9oJXXTc+N14b6mss1b/VpSZ6iqVE462JHH9Dl1BRLFMK1qmsrZLOLsBo16lgVOwkQ9dpO2+Sr2hOdQBKy/HlaZnEIxRl/VDnkaate4VuTEBYIzX7nzFYbKYrLf2EceXL+bP034xDxe1S6EVVMlLHS2C4+cDukKGT7zYHBr84vqWA8wvrqbvNGZGapE7OA+ztnmcIDa3Ao2LhNowMbhl34wzch0Z94X8n/uYfW2HEv0o9wi2JaWZ1qvrwfVJ8Sh+h0ZbkuZ9UasdzglKQcnnu7fHRMF6XJdtc3mezt+4/Hs5nC80dhyVEX8hm5S450M7ejeQ6rKfQ4hawJea+94Jus0OlE5c6Mue4pO2ShDfTItNRTa1BqgJO/xOew7BWzspWLOq835vQDryCBSasPTPxotmpxa39EVFUNnLGP/8tokcoHqTnl7Esw8MNcAwnvyW3bhgQ0iHc2XobsMd9lOZkDmKkz8DWlCWKWKsvQpzV8bGdyQgQEC1kFRtA2BVSL0prbF5z62ud1OHV1wFYhc2kfGgC7wYQR5j+OrY
 x/r1XCfe
 9UKeC7sqYGVsBeSQ7Uvhi29uD6SuPGvVQTbX8zIXXf8ycewbRC9YfPIoQT3+AwO9oh1DGdLM31JgZMQ9jNYHWUvriDFEo5X9mWY7SkHsV75ZaHm94GS5ueBOMpxNwKKLSw9M8CPEltZrb2DObVt6gpMdtAWY8lj/yqaMw+6xlQgjpfmN392cvXfMZo+xSWGcm/FYEwR2xf//Jb8keDlQS6kzPTg9xElhw/k4rWve9qMfi6vz3DW7r18l5rjk8dACukdfdzd6irfI5fDq+swy+pjCw+6csOx1czFJZcMO3DFZZqsVKu3ZZXFj+fchi3DHNOjJ9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

call_rcu() disables IRQs with local_irq_save() to protect its per-cpu
data structures. Therefore, if IRQs are not disabled, they cannot be
corrupted by reentrance into call_rcu(). So fall back to the deferred
path only when !allow_spin && irqs_disabled().

The RCU subsystem does not guarantee this contractually, and this
optimization relies on RCU's implementation details. Ideally, it should
be removed once call_rcu_nolock() is supported by the RCU subsystem.

Link: https://lore.kernel.org/linux-mm/CAADnVQKRVD5ZSnEKbZZU7w86gHbGHUug2pvzpgZTngNS+fg4rw@mail.gmail.com
Suggested-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slub.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 2c5ba8c326e7..bb0f2975c95b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6157,8 +6157,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
-		if (unlikely(!allow_spin)) {
-			/* call_rcu() cannot be called in an unknown context */
+		/*
+		 * With !allow_spin, we might have interrupted call_rcu()'s
+		 * IRQ-disabled critical section. If IRQs are not disabled,
+		 * we know that's not the case.
+		 */
+		if (unlikely(!allow_spin && irqs_disabled())) {
 			rcu_sheaf->size--;
 			local_unlock(&s->cpu_sheaves->lock);
 			goto fail;

-- 
2.53.0


