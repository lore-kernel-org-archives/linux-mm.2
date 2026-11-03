Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 48C3F606BA0B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 14:48:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C2dwqdtU
Received: by kanga.kvack.org (Postfix)
	id 71C7D6B05B7; Tue,  3 Nov 2026 09:48:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CBCF6B05B8; Tue,  3 Nov 2026 09:48:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56EA86B05B9; Tue,  3 Nov 2026 09:48:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 211646B05B7
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 09:48:26 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 77C86120452
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:26 +0000 (UTC)
X-FDA: 85394088612.03.9411C7D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CAF6D40006
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:48:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2dwqdtU;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793717304;
	b=y4TWlAr1HI1zDOvrAgvMYkj4Sf02SmPSh6NeKU7b6NttuGxQqfZ89jREp0o6Knsa78pEMP
	F+W50UToI6f/ADosVbuFgvzlYm9tLGxt116OWirHGG7qVEk1ONKZ604cKuDDYZxqo/KcW9
	27wl7Yy2aHlAsaeV3+NjVnXWs+2Wjdk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=C2dwqdtU;
	spf=pass (imf07.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793717304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wM4ihzCKOLfh0ZD7M58/6B4bo5IJr12GDvSCHj1N144=;
	b=fauugp8nX6zvTq/FDxR20Y7DJgpyycLEkqKAeRzaixLoQIkqxoqv+1bM/pRtMxkaK6XYbv
	D/k1roiIekmGywrRjGt3giyieWSCR3QEvesrsbz32gvyUDRsoH26wvDLHXm1mvVJ0agLRz
	b+s5kgivet8gaShzXd/t+yX7fZKB328=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2838C4018B;
	Tue,  3 Nov 2026 14:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B112A1F00A25;
	Tue,  3 Nov 2026 14:48:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793717304;
	bh=wM4ihzCKOLfh0ZD7M58/6B4bo5IJr12GDvSCHj1N144=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=C2dwqdtUzJs0e/4mAoyZd9elv6kGwKzRzrkZZLnkSLPmb0EBBXF9mz5ki97+BdPpJ
	 XR3t5RyYj6b5JGCnc4iLzpR9PSDADmGNoM5Kd3Q3Z8+mjRreHGdeq4mhUv0XwtD16Z
	 SXlW5JSQnlmhaOFn59oW5j5O3l95kkxXNXhYvLsr1LZcKDf896lWNYyANEtDQKBG+a
	 tv597acbLMufhvpLiQDo3PFyTTKsytOB/N0JBHE5QTcBCta9qmQDVrOlvNxpjHSu4f
	 3PR0956zqC196DuCc1QWbJtDGLpRfklTrrMuglgZiq0FibC8MHKMBVtWmf8Qls7xfR
	 90csUx2uFzarQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 03 Nov 2026 14:47:54 +0000
Subject: [PATCH for-next-fixes v2 5/5] mm/slab: serialize
 deferred_work_barrier()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261103-kmalloc-nolock-fixes-v2-5-19167cfe4779@kernel.org>
References: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
In-Reply-To: <20261103-kmalloc-nolock-fixes-v2-0-19167cfe4779@kernel.org>
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Harry Yoo <harry@kernel.org>, 
 Alexei Starovoitov <ast@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-team@meta.com, cgroups@vger.kernel.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 Sashiko <sashiko-bot@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: twzyx9zqhhzbc1yqyq5q7o14gttxp97a
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: CAF6D40006
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793717304-723105
X-HE-Meta: U2FsdGVkX19qfRbYYVbdVYaSfh3NorVhPEfylY5Ks2Nt+AO4sIGzUxTDn3Zdmltl+TRvexqwjtfXfuDpZFaCo7Qdb8AB37ri0pmzpEGdAUcpa26abb+Wls2lgl/amzjpUq76MiclfzW5GGKMLqzufPvTc5aHlTFomGJ89PykSdL+/n2OwgKUCNCFp59/iEnp1E9s9P+BlR+2acZiQli6ygrRYU8Ng46d4FgKTb5lcnVMIpgWIoLm7W9kouCeGwSkaBOBtS1OVOl0x6Xj0Ohlw31huaIQ5xvZqqWmv1yhYwRvp+uImzOYppYgD+Gyd3o1Vw+K3FWusM1NDn5waalizrdzXjT9P+tf+5EcuHP+IXZbYO/65YM+ldOMjbq+dTQiYONmrcI6bDzxg7+i7pow66EdSpIcJkY1xwGjmbv8JFtcv7qSA0rhOPwXd9jvQy4eIABRWl11EFF0pCpdzRmvyue2qv01mv57AvryVjDmB7gsUSnBvREVBcYHucle9zdwf5bEZpGibg3R8o6DD9FIYaAaPFldIHhocjdDaeL7k28yE5dGmWmgKAvMZXP/Tcw+ZFtjeGMbozt4Tq4sbKPlkbQrGnhpMhWtsqaGPzBIP56bkwS3RmYR1tKQ/QBQoES0mwj5z50YpzylR4axt3zx/rqrqruE89PJtINiBzSL/Nfjwy/JbcPk/epSI2OPL0K23dbLXNuXlos5W1mJ7BTRKJLQYCn1emtaqD/jPU0sK3//5YcBzOIp9jExa8rSaVgIM2PEKsPZpgO/uH8wFgw2/YGyAm2Cp5VWeI4vYSUEIPxUc+tdnQuxtC3ESKsiH/Qq4cGlx91dFgPPZyZmyYxkE9TKK7oCBcDmuAHTD2G5yBnBGYgvm4920vgWXK9E/EM+6j81rfLQYxWil8sxogzKm05zOZTaSjlHGH3nyABfy+Yaqg4c1r3nYFXnnWf1r1LWF2MGwH6ryYG6tPZB7z/
 9aKCfC0g
 l94b/gvNTU1rsS0drRqTOs4Yfo8qnHiPZ5TT1w06SiD48wNmWvHXOuWz4IBQ9MdZGNwaEaOSpOkIdC61X/dyGmpcA0AZikvLb4cOYkkl9Jxrxqoho4C5V3q3WrB1xUKOAUvJFdzAnjxNPQNvxSTQw2zlO89D9QHZakBqwPwqfXEDFupPTsQgjVnec+ke2t8bMyH7X8+uRNpWuStxjkMu8EuecajWMV80D/JYZl4UXHBnioywy9xz+xqVsi/3wRa05fr2Y86atq2x3j6h9qFQxCUFLt2bb8xnMzE2q9a8U2h9/+UKkn6gOMnwo6a+b4vx7421SR1tWC5raFlVH0r198zEHUI4LXJwzsnre
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

irq_work_sync() uses rcuwait instead of busy waiting in two cases:

  1. The kernel is using PREEMPT_RT and the irq work does not run in a
     hardirq context.

  2. The architecture cannot send inter-processor interrupts to make
     busy waiting reasonably short.

However, rcuwait.h says:
> The caller is responsible for locking around rcuwait_wait_event(),
> and [prepare_to/finish]_rcuwait() such that writes to @task are
> properly serialized.

Since deferred_work_barrier() calls irq_work_sync() without any locks,
it can potentially cause a hang as writes to @task are not serialized.

Fix this by serializing deferred_work_barrier() with a dedicated mutex.
We cannot reuse slab_mutex because e.g.) some users of
kvfree_rcu_barrier() are outside mm/.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/patchset/20260615-kfree_rcu_nolock-v3-0-70a54f3775bb%40kernel.org?part=5
Fixes: af92793e52c3 ("slab: Introduce kmalloc_nolock() and kfree_nolock().")
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 6dfa8ca3c937..50e88edcef3a 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6636,8 +6636,12 @@ void defer_kfree_rcu(struct kvfree_rcu_head *head)
 /* Must be called before flush_rcu_sheaves_on_cache() */
 void deferred_work_barrier(void)
 {
+	static DEFINE_MUTEX(barrier_mutex);
 	int cpu;
 
+	/* irq_work_sync() may use rcuwait that requires serialization */
+	guard(mutex)(&barrier_mutex);
+
 	for_each_possible_cpu(cpu)
 		irq_work_sync(&per_cpu_ptr(&deferred_percpu_work, cpu)->work);
 }

-- 
2.54.0


