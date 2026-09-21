Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 054EBC982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:23:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22ABB6B00CF; Mon, 21 Sep 2026 05:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 201586B00D1; Mon, 21 Sep 2026 05:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 117616B00EF; Mon, 21 Sep 2026 05:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC5596B00CF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:23:42 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 652BD405BD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:42 +0000 (UTC)
X-FDA: 85237231884.25.27EA98D
Received: from mta1.migadu.com (out-139.mta1.migadu.com [95.215.58.139])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6BF7A180003
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:40 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aNL80u/d";
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.139 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wvY3z05eg/r7MHiheu1WpoDfoB8+y8eGfNNBMxcbFco=;
	b=X1QOkpmsFdf0AzaKHgYOGF92CqBsmWcZOlVsam946P/fMY7PvUUGsU1xU4uqVdaWh5y1qT
	L/CZmiU6BypIt3Jt1GoBNvPvNxRBD80ajfIIsMBgo30cvmk+L6XChroGaKjwYGE/wqC2Jk
	ahUcuouuCNET6yErdliKY6bUo2NPLlE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982620;
	b=Ts1wbvsOjaaeGmhR/6g+3bGkvjOlg90nkooNrfzxUkYbuZY7A+a5dsToj9y1bld1ak7B3L
	aVmO8O9F07WNQjbQr9h5VgygtKMXEMJhe56zBnMCcfnk0QQmdBS25lw95370Fs8OVOPFaL
	/T19jjDBVxyZQed+QzuNunSgzKgPpCo=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="aNL80u/d";
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.139 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=7BvEFNtRHP1Kn+ktJB3UzR2F40Rkin63WssI085fxec=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982619; v=1; x=1790587419;
 b=aNL80u/d2xopWc0w5ukYZmXhzLYGrq0EySqesrxN6WairP9Dxruzh1fnrHZf47uyRdgaSdZ9
 45AeJg7NBDWk2IXtOdkMEvqovo1HShggNq/Vez0GuMgc+UsWRt4eQzLEfisti2zoqLkrfQUj5eG
 1XygJB7dl9Z6g7gpP5LCpjLI=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 04c788aff0412b12;
	Mon, 21 Sep 2026 09:23:38 +0000
X-Mizu-Trace-ID: 04c788aff0412b12
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
	akpm@linux-foundation.org,
	peterz@infradead.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	gourry@gourry.net,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
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
	babu.moger@amd.com
Subject: [PATCH v4 09/15] rcu: convert process/thread iterator to for_each_process_thread_rculock
Date: Mon, 21 Sep 2026 17:20:55 +0800
Message-Id: <20260921092101.89285-10-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fdh6zonwnwqkggzj6unwnfc75z6ypneu
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BF7A180003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789982620-505073
X-HE-Meta: U2FsdGVkX18nmMIxKBaocf+pLdyCqrh6Sxq7PaKJo6pY/7AFEkeZAVfP2knx8VkNHx29/3UjXZ7c6HAi9KcRFRZTi/waWJpp/vWVeEC6K0BB5SgI6vpNPJBrUbSYEMW4x+/8jW75DkRtJz3nN4IpdxmYCpBHlcXXxR4+vZULktvbTipRuuhiomBiFyoguh+SyKRF/5JCopdzdQSOMF/VwUqStRjUl36CUyuV2nWDdtAOBG1aHeC+HPUwK1ItkYbc6NLa5QS8iwtbLNyRJ+vk6r0RBfqXwyEecboY3zPwIUsgJ+KzpbSyklBV1NckBt8d2gt2UOC4vJhqYsK609Q+S9+cN5BKirYSsx235PlEs+kUGss5kPa4VyKCtr1bHVuekjrXY7K/OQo9b1GBce1KlHQLSDzYXJH05rtUC1d1gn3ZzscmnxFbWbMF+J7a8l3rYU2gQ4YVp8E8UaO+k9noxKuixiUMcQ7daz9IprcPwMWRuysFblSUJW1MPV7mlME8BiAghrJF8bzdnZPLA40/pm5rsvTyCvGaMUb1GFA92WrO4WzRzPKv7oLyZi9F9Fztt8xjB0neIHgBGAS8Ha4YxKrZtJ/hn6IvivaO1465NH07MJ43uP4uO5v6Y7Wxi5zXZUEIOtL+UZcHeFK5ygcq6OKIeQtYR+I/W0x4Y3h5aoAMmPc95czV8v9/jBBQTguvnPPjWq+tw+o3ttusIVMDtBXeXFkYjAgj0mWW+7HbkaVHwJsho/H3L1QSI/u1751VwiZLQtlrzMtYPNPIfnF7DkvcKdAFV0H1gtlEBa4xVCY845+EPfhL43KIJsCuISnNDX02BtbhS4vYRHVVLoRye8+wpBIrPb1+PPS9xUyuOqGzTAorDmcoZZbB2GQbrjKourgI/VuAsJMILzJyI5rvgQhc4wFWJljPewb+Fra+2PP/D/904Z9WP3FnZ6P7K3Tja/vDXARVOxvAtFTdkUn
 dTknC2Qw
 0U7TMyB3AvcW7jFED4gwdL9MNTMDwi7uszEIy0J2/xkM7Nvqd5vD0ZQ/7Crh996T2q8eo3h1FMD5gpdxr1O1ap1lSw8G7nJAcjUeyW/NFxiRCJx39K80dkpVjRW/za3sDb96/HWnnI6BQ0HLyIcG+oXcGiCGjfNNi4cjpKK0DmLAOLqdQ1ojdSty+ACqJ3lV7+5hqNJqx/MFTzT5CR9mcTe4Hg3pF/9O2Hkp7b+2LZtsg2E2cCY2/q6zdi4+C3hdjDv3KBj9AxhzQVlRgMv92lTPvEOGPL/Memukcuvqi4Qkat62rR3C3x1jTs9lHDQ7qnBCotKgBjH3mITygo+IrvtXdPCXqNcFKF3aqwoJ844rBpL7u4+8TMXGtEJsAq53WWzE2QGtB6DER7sXsdFYhY/8OgG1ihEXZaOp9LZq4hBUFl3oNFzCrIFJV0TkjnY+AKL/DIxdoPhwFNGw=
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


