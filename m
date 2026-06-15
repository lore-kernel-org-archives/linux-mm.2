Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62B3ACD98DA
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:06:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CAC746B0096; Mon, 15 Jun 2026 07:06:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5CA36B0098; Mon, 15 Jun 2026 07:06:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B4B846B0099; Mon, 15 Jun 2026 07:06:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A01016B0096
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:06:50 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63C581409C2
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:06:50 +0000 (UTC)
X-FDA: 84881869380.18.35EA31B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id B85AC40002
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:06:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bOT7vJvY;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521608;
	b=DEfOfxIZlkdEK6eKwLKtB5E2ASuHB0zuHIAkmrzoD1fftS+N1DEYRT/aeInCDyoQTVIFGh
	PcWDtQkhIFJ+YE1b56CGDk3yHWyr52nRvMhozzx4f6+Y3tS6YMTnAedfM4Csv68HHd7m8k
	Pe+RUucOLdJNnH6v8o/K7GV6snea7lo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bOT7vJvY;
	spf=pass (imf12.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521608;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZZ9OnjoQYtwIavekQOvzh5VlfzmJMinYHMm7ngBNx/8=;
	b=cX4w/8WvmvFQSPnmOtXEawUgc2rEDe5R51FYmQ9VEFm2ZhFg3hWFdNMOXdeM4iyKLRXuNm
	ZAxXB1iHJ34jttkUUQFDEQoT2sLWBMTF9u+qSXiMABhkEyxabnLWvhmHVeaxnFoGk3nqnJ
	sZl8ufngoVMvHxq+5JARaqdQ/0Nyigc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 524D8601E4;
	Mon, 15 Jun 2026 11:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C3541F000E9;
	Mon, 15 Jun 2026 11:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781521608;
	bh=ZZ9OnjoQYtwIavekQOvzh5VlfzmJMinYHMm7ngBNx/8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bOT7vJvYvvvQ4nZJ+Nn5/kJkUg/eOns2vWRX8geyKPAyFmNbbxyVVxqBbh4arRI6V
	 +g19CUu01CAPI/XVY7hpTKu/JAvArg/8bFj++Q7CYDdDUJ0edxgs/z1jW5T8R/eohS
	 0MZ+Q3asUJAHCZoF6Ho3qGfDEz0Ldd48u0KWRsn8Cfuwpej32CoMRsiEsYap0RDMsR
	 qRxvfPmnu3UuTRYKR7P5VWPJmk6SVd1rGMzjFDFWVbOn8bm+w3BGsIDR9+UaVoy62r
	 FgN8nK0QZdlBaeVFnHPNJwZHxaAlMeP1LHzbHYoDgOGiAmaZiDMGhmL4o3HxF+R+kx
	 AY2J7hXOS7VAQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 15 Jun 2026 20:05:58 +0900
Subject: [PATCH for-next v3 4/9] mm/slab: use call_rcu() in unknown context
 if irqs are enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-kfree_rcu_nolock-v3-4-70a54f3775bb@kernel.org>
References: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
In-Reply-To: <20260615-kfree_rcu_nolock-v3-0-70a54f3775bb@kernel.org>
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
 Pedro Falcato <pfalcato@suse.de>, Suren Baghdasaryan <surenb@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-rt-devel@lists.linux.dev, rcu@vger.kernel.org, bpf@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: B85AC40002
X-Stat-Signature: 8m3ahuyayq4dt9neyr4bg7dpteatd4jy
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781521608-193021
X-HE-Meta: U2FsdGVkX1/sxsgmPriy7pqkeVi8UZTiBwoXm7vGOnz0mJANVCBwpntD6AgBvoywHfej61ScIB85lD+RQRVBgNo+NsqQkV6noEKenq9gvIMzF+NX6EMjKBh/kIIvBu+pFbvlHeUgR3nncG5fjJqojSbYdh8GmQmkNt3MOobIPbGSN8KVp4DRWHltSeslGSWUCssOmZlf+CCi2U8vpuJEhFUB09ml6FBdLnDF7SiGYxcsxr18qGna1EYVMqphl4Hq2Ds7sAWCC2P/auiy7lashFgyq6xUnIqWs7EzSnGBVQC/yUDupRRIZe+IuZKy4y6WYpWHX8KwVhE5bscT/tBL3tOeo+nQx6bRc9RnXPvrEKKeJVFUjo3h9OEaReFfBj4V0z5U31VgZstNWh5ilM7b5DxDoe6nMk1AlWwH5ByDOt4PL9N0XxQ7yPU5G35/ogTiQvmDUluhxvG/gIcz5A58+hAUtQqUWuxydHnQYUiMwSRAXP9BH0+RFNQbjn9iEPuC4o3XxQ2he7zPeYZut1C20kJpRWq7TKHFatWlEwuccIYmH+n5eydHes+TBiq6Q7acADjKhTl7QCfDSiVzDvNIXEp3J3A7P7tOfybt440f9PmsRm8PBBpciSCWEcXq4pMSMHB3B2iMNR21a2fP46594mQ6j5I7/aZa6O5Ch+bx5G7AJ3Vx0EHa6O3zXwY2Sb5Rp2xpzW0/6pKMMAS+4LtUdIFZg94UYy80qHSSMP3zZ0AFt72LV7rFAchFJ3ilnohaSOrwfIYCPCg1vSQZL9H0/JmFOoPFok6RT25iteXtvmcNOswfJvftouJYinE/vCe9EtYcHdz7mb7uJqZKHHOimVsBXaVyEeBwtizwJyZH6rmbcAWBc6axNnD2eKZzrY1vd6oFuLw5Pr798PD8KFji+e1ghilL1JkbSAo1SOj+ShZ5ByyCm3ajXOVvN1laFSqH1njOm58q08nbRXupSqk
 BXJKGqyg
 8jou3i11jlFjOMTX09hiWdSrcqoyYtFE0Y3wCiK8xtFCTbcdCTRWmRdig0O6ocFwFPkpQ0+h1uaUgYLIpmcvKofsJgurHMVfZNGqb5yQJqBs6i5wBs50FnpEy2USkM/XqkDkA90M7SN1SpboBTSufTbleU21UyDF2fbHRZddL7LIR2qkli1YY75ZKJGLt2zd5dOZ3vs310d44yZZ0UTVDvi0ZEUDU+5wGuvRIzGZlWJ37NNgRA3V1+Eg9T/PGcX9V3cL2TsIrKYEh/jnZV1Ghvm52Fo9YIu5JpqB06bKK3+ZzM7S/Bwt7Bdv+rg==
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
 mm/slub.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b0d38d515386..6a3552b70683 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6158,8 +6158,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, bool allow_spin)
 	if (likely(rcu_sheaf->size < s->sheaf_capacity)) {
 		rcu_sheaf = NULL;
 	} else {
-		if (unlikely(!allow_spin)) {
-			/* call_rcu() cannot be called in an unknown context */
+		/* call_rcu() disables IRQs to protect percpu data structures */
+		if (unlikely(!allow_spin && irqs_disabled())) {
 			rcu_sheaf->size--;
 			local_unlock(&s->cpu_sheaves->lock);
 			goto fail;

-- 
2.53.0


