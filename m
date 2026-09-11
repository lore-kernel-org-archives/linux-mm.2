Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 87418C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:01:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CFB26B00A1; Fri, 11 Sep 2026 04:01:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A7DD6B00A2; Fri, 11 Sep 2026 04:01:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BD076B00A3; Fri, 11 Sep 2026 04:01:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 69CC06B00A1
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:01:02 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 098B2A3639
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:02 +0000 (UTC)
X-FDA: 85200735564.10.BB3E7FF
Received: from mta0.migadu.com (out-114.mta0.migadu.com [91.218.175.114])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1E64A1A0009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:00:59 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A6hbrXjd;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113660;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iFrtGJPnUv4aZXbxm9yrK7vuwO/ZFLS2YzPRTDFAIg4=;
	b=tqmz6pAxKUO4xGuBaqhnRuH+gm3Q1hLioN+UQ6sEXIGy+foeZOGDf1LH7JLR5qqa4u9iB0
	MF2tHjNbw9BBs2ETkwP+SkI7DjeJ8CQCAHhH9X14etCEHzmF6zbK5eh/JIA6Qp44KS67PD
	GVHBj7I+eY4wDJbNowuRt4/9n7LPbJI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113660;
	b=pYXuepyp2j4gxh0ULJEQ8+xnzC4mk5AiaBRsen4rrwdh8nkzm3y+xFYH25Teun3x7KthZY
	WCC9F9YQubDKtCMElftPpORuBVVaY/YNAMHal0XQTNL7AZUBprLAsMIJHWwDaIk4cIviyL
	3acXb0sI0nVdmSzT+x6ws6UlU/1b3RM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=A6hbrXjd;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.114 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=vF8dJvwfO0k4j+Rhq4+Quj7N58x+aoewGF5Ku9uTa1M=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113658; v=1; x=1789718458;
 b=A6hbrXjdaYwOiLJSDe7TOU9PsjCWf5OW+mLhRmRQxMucHYFrxyHpVebShWu9ekIdqL0jHu83
 TA8an366u9lAd/jZ67vI2+RiKBrsdTjyTFz3XvwcPjegGOcrs3Gv9NmU3ygz50zPPXMnFPI6ASa
 blmtB2Ak94TtPCXxOrLUEMWU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 92b4a417acb68777;
	Fri, 11 Sep 2026 08:00:58 +0000
X-Mizu-Trace-ID: 92b4a417acb68777
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: "Paul E. McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	peterz@infradead.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	gourry@gourry.net,
	rientjes@google.com,
	shakeel.butt@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	will@kernel.org,
	juri.lelli@redhat.com,
	vincent.guittot@linaro.org,
	tony.luck@intel.com,
	reinette.chatre@intel.com,
	x86@kernel.org,
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
	pavel@kernel.org,
	lance.yang@linux.dev,
	mhiramat@kernel.org,
	pmladek@suse.com,
	longman@redhat.com,
	mathieu.desnoyers@efficios.com,
	jiangshanlai@gmail.com,
	qiang.zhang@linux.dev,
	dietmar.eggemann@arm.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	kprateek.nayak@amd.com,
	mark.rutland@arm.com,
	Dave.Martin@arm.com,
	james.morse@arm.com,
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 09/15] rcu: convert process/thread iterator to for_each_process_thread_rculock
Date: Fri, 11 Sep 2026 15:57:54 +0800
Message-Id: <20260911075800.491472-10-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: myf3cj1ys6y5m1tzuw64o66cq5ezuiij
X-Rspamd-Queue-Id: 1E64A1A0009
X-HE-Tag: 1789113659-373935
X-HE-Meta: U2FsdGVkX1+C1CrAdhmZSVKSP8UxqJG46r12c/PHiZidc5oGXOXtL6Cgnwc424CE8fPs94nNqU6v8AEht0b5pe5JCm8RPnL9QcBlqNO8bT9sC71x3VkDyXlugGdcF7FIDa/Dp2hYUsmA40LWAMfAYtbXVkcdSQxi72th3F3KOHcA0fouybj1QiJFj+Mo23X/E3M0v48UYbXaqXGPnKUHvO3U56rvzi/vzaJlm0wbDXTBvPab5KAP3h69ApwiUO22FZHLR0vEXKYuCV1qC4obi8tiTT+XR19bUSP6bMcH5K9j3wbFQZZ7LnXVDsM8UqIMdtlbbH+YXsjLGEAStUhmj1EjqIVQe17SkpmTILDFXMlOtXGWfPG2ttfdcm7PdBDti3fsnqtg0TNGirVtbtCLah6+TAdXNwDJoo+NkTEzTE/ZCAnLE3VbklRtiu9U7K35LLWNEtJ4jwE3mzg0Z0Q2326LLEZV2plnYVawfz9NB3k2TeG4zrSgUiBqY7LDBteJrbNSBpJfkYmpXP5XkE1kdOeV/oPFJ3fNhbFXUCy41Hor62bCqvAXPmhdJX/t4REcjUrlJVKo4cxyfbP3PueKrCG9ZRueOJrW/0bu5NniGndLDc05Xa+IOgdWEOu2BRwFUf9nUunlP/s/B9yGR3YTbiWfY+YuNPboWLj12lBht4aPNP/97bSpGeM07U+nNY5Y3Cvo8wgq8sz4sqcC9xJPHhUREC6XQ8tAGtkehpN9qY8pRDdO+RSF42lyJdb2iXQSU7PIbu3ESd03QBMTnXABIQzd0kxIzE0PxayArWzzq5pBh8KT1FpJQhgBYMBtINTim0ot2A3fGO/rzDWhqFA6dS9gGGQfPj159WYgVSwwM8Z24NfGTNRHa94MMlm2F1ezMcch/yi7+OsFuuX/1N8t05dFzVBIFhZMhF3zZkF9r9kTFWQV5MxEkW9IJhd2Jt2UUoZm7quy7+S44yHzCjB
 WG6HXaFF
 XbaZ1Zex+qk/xAG7hyGUf9nE7te7bxdv8SeskTndT+1RotvzY+wl8vjSfSvFqZAxt3u1Ez0F4/ttNgotpkoIVKnRo7MgNztrOJ3APc621gb5+alFY7eQzjRg2tvrDL1lhQUcP5P3mBFkBbS3qO28cHgQ04ahuralanvPxThNY3DKTwPobpt7MNCVJGPyIavTtYzdsxSBPmT4VziTHsIOEHBbot7G8c6A4zWoR0BluBrVqiM1zTljpi9ZTVyG7JNu5SzLb6gHTvhBhDeXT9dhhwzwrqWZdwLTk82zhXc/IzTm60TCVJMvw3zpFOHQWpH2xgmjU1idnvuTYBbKwSKKQXdrORGlNCPHE4hP4qMQF5awP4h7WeBcUQYQbkOD7frLRiRn306rA/LQ6TziK/Thf/1LntL+ILQlIUDwGfzs5bcgZwiL9X4vKL53YJNV+7fOwvO/8xxfHcBmqKsQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process_thread() loop in kernel/rcu/update.c with
for_each_process_thread_rculock(), which scopes the RCU read lock
to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
Changes in v3:
  - Split from kernel/ patch in v2 (Peter Zijlstra, Steven Rostedt)

Changes in v2:
  - Rename *_rcu to *_rculock
 kernel/rcu/update.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/rcu/update.c b/kernel/rcu/update.c
index 2a778b8ab4ad..d8e0b5896db9 100644
--- a/kernel/rcu/update.c
+++ b/kernel/rcu/update.c
@@ -548,15 +548,13 @@ void synchronize_rcu_trivial_preempt(void)
 	struct task_struct *t;
 
 	smp_mb(); // Order prior accesses before grace-period start.
-	rcu_read_lock(); // Protect task list.
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		if (t == current)
 			continue;  // Don't deadlock on ourselves!
 		// Order later rcu_read_lock() on other tasks after QS.
 		while (smp_load_acquire(&t->rcu_trivial_preempt_nesting))
 			continue;
 	}
-	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(synchronize_rcu_trivial_preempt);
 #endif // #if IS_ENABLED(CONFIG_TRIVIAL_PREEMPT_RCU)
-- 
2.25.1


