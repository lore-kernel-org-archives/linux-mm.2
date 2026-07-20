Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD053C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 12:45:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33AC6B00A2; Mon, 20 Jul 2026 08:45:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE4576B00A3; Mon, 20 Jul 2026 08:45:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD3186B00A4; Mon, 20 Jul 2026 08:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 896366B00A2
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 08:45:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0D3201A0147
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:48 +0000 (UTC)
X-FDA: 85009126776.11.B5A0EE0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 627E9140004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:45:46 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JSe/I62a";
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784551546;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gEdEptG0SQeRDcDet0HzsJ7ij1w4V3/phd6b9zQynDM=;
	b=lPFCxydEff/tHr81lT1a70xbEksDgyWxRnSlJVhrqqEMFMDHeOxSy4v1yi3J/6PosbcLkO
	QnmspCLWRRRSAxH3IT/GBfCLZM6QO0cHFxC1tWbzM67N2ojSENGb8ugswXWc/b8qZTl/+f
	RDgUHsIYl7Duv9FzpRsMrvNg3Xl3zEc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784551546;
	b=kpydIMhmrz2Dis2jTkENsJ2P6CRq09xaLYQG4MuSFkh4n8+fwamOLYOU5SqqPms8XcFfeB
	+R6CRIIXT26ODPqmtEcjfT1t00CRTp3CqPV1AQVls83/tv40TFT1Kf1VEHVPektYtgSUtE
	/D8nDJmYqDfpAYPguPVnev5unWsXfWU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="JSe/I62a";
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DEA7360A90;
	Mon, 20 Jul 2026 12:45:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD0951F000E9;
	Mon, 20 Jul 2026 12:45:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784551545;
	bh=gEdEptG0SQeRDcDet0HzsJ7ij1w4V3/phd6b9zQynDM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JSe/I62a0Ly9w+RpYYJBwxSnl/fcB1i1i+ovbkac+K7zljbU1l40+93Xs9ETK/nQY
	 0ye6HHrTCwU0wr71HfK6CPqwYFw5hQcIAa8Hk2ae518qQl1QP8z41Q+RLWh1ObU537
	 AkAWqNhBPp5ZLV4OZqBzUvCG6IrpXb1HT8FxcEjKLsSKB1Gl3H8hKaMMhFtK7fJTIT
	 m2XTAQcrOLOAMCRT4Rtzt9qqMI23AtvrfVJFv1nbI5R9WwrA8WwX+rc1Ar2VkE2OhC
	 jCQXx9oE+gwDRDAQXiqlXkuhvihklWv0jIwGHvHR0E27/VlTC1rb7m2/ZdGQs2P9hS
	 KYY9IVpgfF00Q==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Mon, 20 Jul 2026 21:44:32 +0900
Subject: [PATCH slab/for-next v4 3/8] mm/slab: use call_rcu() in unknown
 context if irqs are enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-kfree_rcu_nolock-v4-3-964e03c41a4e@kernel.org>
References: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
In-Reply-To: <20260720-kfree_rcu_nolock-v4-0-964e03c41a4e@kernel.org>
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
X-Rspamd-Queue-Id: 627E9140004
X-Stat-Signature: tskeyqx91kmb5ijrpca6n51ign8t4ze6
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784551546-384880
X-HE-Meta: U2FsdGVkX1/+oeM8HmdiRQVko3tvdMUC3d8PU1CBPcd/R+MK5jy0unOTesfSR6BXdNUoX62uNrWY38RohJz0iT1CSRFiA9rhf86zrqvY9jIF9WbYLTf+We4naJV6K4NNd70DF61NXlIS6+Erz1hDEc0WflWJLp6/KlMIk+TJm97vvT8tfRhaPkj+zydU5lNRAelTzYZwR/LTxqTSHRQrUflx9vh7VmAGVY7Wn/tc+fU5y6tHfUT5hm5Sl1nl32jHCPLLv/kHsWliILcpnBkbCjmMQukNqbbyt9qZ6kZgUk8FhDItPuWyyePrjvQBcqDzbCoHWnVVbh3bQ+R/lmiWwDnJq7kpX+4beB5XSlBC0hnWxA8dvnvhMdQ95SBCwaA+04ITi/NkvBYZD4D2Q1tgZCvaz5mdHibc4YVlJGAIW2GeInJ1KCVA2E2+2UqQiG9GjZrtPaiBC520FW42PJLHl+2LqfMfr96Tg4h6NdSBPb+aL9ORrmHgDQxNQxDtGhCob2QjzOVKWBcYoZD1HVdv67Zyp+2+SirznBVO42l3Msib9F0eFR/R+lcZ/z8LMviRgxUmnbtabRg8kHXAgDzO1IMjEjmDRQjbLV693B3pq4/FAkcAQZgy+q/dllaYgGBDU/gR4gcfN9fGfH1i1m3bM+ovEOaWhosNVPP0xW+ZYHfWwdnGFE1Uu501khL6YDMdxRfT50TK8n8r37SrkxfJY+HNg7mfOFYKVpy56inTsCdhMF6SDvTYl5uFSW70Fmcp1xfNj1qWZfvlEAaJPioI33a3An06eZO4C5yCSUuYNeNEoKHq8Tkowqt1UiMyHOgEI/uj9WNQ76U7rU2E6y4wQtubUhJNRvoFwxDoJKTQ3KWvueSFv+YEc8Nw6pDwxV6wwBAPKTw3ClaXHxAg0xl+Ptwo0jxZJQSWzH2wSkF9NoQbXHcRCk0RvzruGRoMZPsHS1tMW/Aczkmh2xmDsMK
 UpzCXK20
 G1ZEQnqV46o2Q/B+UPKKnJ+ftAdXvdq7XoOofvLOva/B6fjlMiKhUnDv8dRaSfUKnfQpYeevlEY1sLO4BoMElGq8ZzxwlcFvbtUJQyUjlmXHUOdfSsDGB1/yuo/uv6CqY5GszJO4fNRPjTyANpn4VIGM81NFBsUp6VHZFvU8Lkl4YCmfW2s8BlxUhhu+KhLNpIPFVJn434Y/Ymhx5AF3976WAoaqJKkxGy8nXXI6eDnLwQTQfnCV1502joSDDigFPEwEZt8PsQNGmbeLy0eM19HbT3v/9fggeyVExnsAdKFf5vLHzxHluNEC7kOfZ36v2pJqU
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
index 0c350274fbff..680fe64aff72 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6136,8 +6136,12 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj, unsigned int free_flags)
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


