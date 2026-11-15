Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E117606A330
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 15:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FtUdBuuH
Received: by kanga.kvack.org (Postfix)
	id DA8466B05B7; Sun, 15 Nov 2026 10:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0A416B05B8; Sun, 15 Nov 2026 10:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C20F06B05B9; Sun, 15 Nov 2026 10:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 902F66B05B7
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 10:10:33 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21FE6A84B2
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:33 +0000 (UTC)
X-FDA: 85437689946.17.45156CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 76CA64000A
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 15:10:31 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtUdBuuH;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794755431;
	b=qwqx2f6nnMYvlnigkm6muRhDzq8mAehH3t9+EYITGI7Yx4Y25KrMbJDCnXEaP5C/kHSSF0
	BW/oDM2dih/ybW3b9nJ2mj5QgAXmZR19Jxt0zfeVuxCpv+IFumR7WyF6mB/SC+ThEsHuZP
	IRUA/dMqaz3+sd27jfIIBW+uAIGUiN4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FtUdBuuH;
	spf=pass (imf01.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794755431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1mnep0cJK8UxwJlHhyxURDjkwq1Z3ct/fIg2aInzknE=;
	b=MhhE/C1wIpFPPmAN4smaufSvCsxGG1dGZPovy94EdJqCYVomey8XfnVa2MR5cP/iSuCNel
	L76fTJtkF4MHhHREoqqWryRWXMc0+c9UXVQ1SZ92laFpxDg3RNSPObW3H20YeBwG3t/Lt6
	NdaJtkjEMVlV/Dhxps3kBmed6JMMsII=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C512140E07;
	Sun, 15 Nov 2026 15:10:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BCC01F000C5;
	Sun, 15 Nov 2026 15:10:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794755430;
	bh=1mnep0cJK8UxwJlHhyxURDjkwq1Z3ct/fIg2aInzknE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FtUdBuuHaa92Dz+pXSozP1VKcdWVFJiIYFyztiRtavfFJ2jgDLXPs+06U44Uii4Z3
	 Yoexr4DgKvxF2v++kXQcOG1ui1QT1o96vNrUKWOBLk6+AVmVZsyzm+PEJeu0yXgjkA
	 4Xno4rFqAonBHNjGCAQMVXMqEF6jUUCvK2sHhIAIn/ePzSFwNvezvCqKlI0779pF6l
	 HiWMgAxOyi5L6cyucPkN8Gvbe0WqaRO0BuTX6wsIz6zWzEcGc5cDO5UUQQ374ycfy6
	 ZdbNcief/YMoIIyTR+dtFBDa6JscZ2ip5pc46TUb9gzvT8AwhrrhR/QFQ/58QKfkmn
	 pJYmLrPO18ABQ==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Sun, 15 Nov 2026 15:09:39 +0000
Subject: [PATCH for-next v3 5/7] mm/slab: serialize deferred_work_barrier()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261115-kmalloc-nolock-fixes-v3-5-9034dd4ecaab@kernel.org>
References: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
In-Reply-To: <20261115-kmalloc-nolock-fixes-v3-0-9034dd4ecaab@kernel.org>
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
X-Stat-Signature: wb7jcf3w5d4hgwj7wnwtntyaqc8pk9i4
X-Rspamd-Queue-Id: 76CA64000A
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794755431-419488
X-HE-Meta: U2FsdGVkX1+SkPbNhAWZS4nN1HLh7ikuQaGIRcu0BrhnmOhHzw3KQ9FLOrkgZGoxI8yIgDD990DjjfRPj3GvTBhSKy3OA+JmQopjVauT10I5zXL4dUZN2Pw0Qbkp+26OwmAo9BYjqnolrusbTZEgBbv8/CilpGnmc7MQHX0601LSZhyRRhgzxd/o3+ec6x2xzOHNd3QUL9ppOpdMTqJM55IUV01h8T02i7KGFZNXAuOKmLIiT0iIkX1yabrWvViTr7ujIUC/0XO9Rs0ZuGSxVaJLyxoINGZasC1TmcPInLU+iuhCM8mh54SNaUopMp/VXVw/FmYl5EyiKcn60DQG7/d5FMldYz8tOwIIPAJmQYFwNQA2DGQwfDMDXc9Mo5FXuN5VDI2PGGFikXooESjFcBW5NF6VZKoTDjwXFrx47NBkatY8e3t7a4mjaksqXdkHH8yxzUdu9YFc+GXIAXlW4p/CuNu6klaalDfAnO9zlCFqz41fcztghY9vasPbxR8LjQcW/B8Rm+CgUNDZBX47LJRQrRtT6XLZVmfjZq3DYwA/zxBx3XrVBPC9mSZQuGS756dOt++3Y/S3wvWj0ZENSeTDylS326zMo8EXAOJsA2Kv0CEjpP5xP7ZNeYpNh7ajrp8Fm6MyEXznbRJKtFTh+gkPZGsh5H01BA0zU0PxKTcs7xc6Me25JgNgxn0MrDQbe/UkFWWzv2oaAvF447dLPp267HPg/hznsFv3QxBHMlpTaEtomC7MuSABFFV6OHBTp0oEznO3GpK/hauuABvMErUPLUTXWi1nA3wfbVSdEf3ZlT4wgii7IzsbxIcxq/tO6aOwZeS4/kXXUmXLBO1bgZ9PELwjyPnDEjiQhvC7wVO1chPNgmsEP/KSEI5sN2a+wvf+0kpxpmgOX6qXF6cS+ERjpwNfndbmEKZtGvP4hj/9TPuFSz90YEu4jk0cKtBLk9GNr6GETX/CuQUbYdl
 LlrOX7lQ
 BPVJvYLFjNCgu3ay5b53D9KEvYsDz9Edj2Efd4ahI0CZjzxS72EUXYqwDMptQAR7W0oUZAJ9r3VyuXqGEL0e53xGrXUZTk44qktaxpssc9To3jme6QiUhqv5deC+8sypArvkrUPO1jPgjwzdtXIL3F7mZaQL2nxzOmaEWe8G8wmjze/ErZ3u1eP8uSokgVDlaH2H8ftqf1wROOnd+yhea48/zRTk+ZB+w7RW970lK231fZ4flqUjOJPhhMCUMLzabTz6toYwIuMgcn7z//7FLC4LyG9cU4td/0o7YvCGHBs/VKL/EaBy+8krx1UdGYvkJv2xJMzR+WpNcdEkj6wq21XMWBLaJMoE5R5lD
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
Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/slub.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/slub.c b/mm/slub.c
index 8252c0b681cc..aec9fb6e2235 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -6617,8 +6617,12 @@ void defer_kfree_rcu(struct kvfree_rcu_head *head)
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


