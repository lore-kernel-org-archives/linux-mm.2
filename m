Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2377C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:23:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9B0E6B00DD; Mon, 21 Sep 2026 05:23:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D73106B00EF; Mon, 21 Sep 2026 05:23:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C61D76B00F0; Mon, 21 Sep 2026 05:23:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AB2CB6B00DD
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:23:27 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 211B01605A3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:27 +0000 (UTC)
X-FDA: 85237231254.10.B7B3F79
Received: from mta1.migadu.com (out-114.mta1.migadu.com [95.215.58.114])
	by imf10.hostedemail.com (Postfix) with ESMTP id A996EC0005
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:23:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjCgDvee;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.114 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982605;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qfMnqvPEgg6vARjkAxBMfeHUxvFT8RhWacH5GQwwOhA=;
	b=ubNpHN0si6sJfcLGyq7osZhz63/aNoCi6P6wC1Ks4rWLHOuUbJvRpNf9fg80NrqwO3wrKS
	yc8WPtCGSnxS4QK1iKF9moAK/gR67NcsihtQqiqQYz9xuc8oPAOf7AuZGEj153hBCXAfHf
	M9/49LjN7/1YlvzUwZ+NGTNKEFQ7950=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982605;
	b=KvvK3oADY4+8WhMs5AUmAcTcFzIC13s+13mFdmgyc0lEiSgTr4uHMsfRxnXTuirPaSqhvt
	AKBHZShK6sZhqr8tmvbPMB4i1OU9zu/cnOgTvNhLl6DXRJcYltMkfYNaSExAcJhRMjguSn
	P3UTQ6x7SE8xjQtvUfc+2NXL/9XZ7Hc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjCgDvee;
	spf=pass (imf10.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.114 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hvpqBrTuGQdelxQxV7LAEzeK1Pu58637uGt8AyWJtr4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982603; v=1; x=1790587403;
 b=UjCgDveeFLOD/PHHgF+rQI+KUm3sTeCxnsAh9q2sAKndYMz+0n0u945lFRj5bicxwpJegF17
 ySIWsumrwbLdNOhqTadT1MXLnuu4oumQdcM5K2T77wC1hukw2NYTrwsh/CcdMRbZ6CYl5UgdLXt
 34E0TJ7sFIi7QlcyBJF4kzSY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c4a69cd911b0a5e9;
	Mon, 21 Sep 2026 09:23:23 +0000
X-Mizu-Trace-ID: c4a69cd911b0a5e9
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	akpm@linux-foundation.org,
	paulmck@kernel.org,
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
	frederic@kernel.org,
	neeraj.upadhyay@kernel.org,
	joelagnelf@nvidia.com,
	josh@joshtriplett.org,
	urezki@gmail.com,
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
Subject: [PATCH v4 08/15] locking/lockdep: convert process/thread iterators to for_each_*_rculock
Date: Mon, 21 Sep 2026 17:20:54 +0800
Message-Id: <20260921092101.89285-9-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: m8un9pyn5su5yn7uhoojpon11umhdfpe
X-Rspamd-Queue-Id: A996EC0005
X-HE-Tag: 1789982604-386477
X-HE-Meta: U2FsdGVkX1+P6V2dwjWVn2iIugf/9q1TCNxVznS0em31X0kV0RFkR3Ue8vxpjrSzMuCy03ZZlziiGdwlyCSXWpo8OUf9v1TZ4HkKfnIyfa44MkKpIopJzbiwcvgDx0IcgbsI2dQilj+8VeRESJrd5/ll4yUHFmnd5I8EEsyX8KfjwCbqJb18i+QeyHGVTSnx5Wt1XaO7Kdwu8XiJbr0StuosxP3isHolJoDRzj19h+I9e89AkhJlrUvz1N1noUGpjpUXMrBSnwsPnbf1uGj0BI8y4TXHZmmvy9jXJ/N+8RPcHPDl/Cx8Tom4rcLMq3DoUtNXAsy84vcXCOKrJ7kIMvUUICSlf7MtJilxUdgT78mDAgBivvF5QLtWGU98XACHGutIixTW60kW9g4wlvPi013yycuHaLOoUFW6wRfDwljlqM5jRtTrN+cH6KoKeRgJPxGXbfC9bI9g4DOObX/MEw98HBWikENbV93FnHibMMbdgl0uuvOXE08XTOGzV2NAsnBmHaEyBnhgjWA02TYANSQJxMHmBR0FvTlzjJswSjWj+cwrCC03DdoI4uPamXViBXGXYL/c66dUipjIS9lZuXIabbb97QYHBJFGHRf8VRRETlGya+lvSqxreKAs1YELzuuJI7QTmFr7P7GWRZTztFQ+toFbXEKBOf0OAELCeJidf654UmVSCQrh/qkPtuCVsurRjqq1PyqWnXxHSd8upUeQQG0/LcSKbKI7Kw8SqtthI/Ar01+sZDWEj4oBOls+A8LsXQ9kXOl/jgMd8+qsb8ggiqz45Z8bcjgZ9C0u83uTvR3nyd6/DuGI6en1kwMqBd93GcD2ERdqeE8ghigkiCEi5KMt/nmNCNzo7tAyo4XGxt+O9pcpLbFaDWjrXc/io6dIF+xBLg3j4hzwkaD2MaFmxmdR37m5rDqFWvCqQqlCm0hKJyT2GqUKi0AgIylTFGnLgy+c6G6fp7YSxEN
 dzKl1US3
 FogwmiVPzc1x84vGBfGjyKdISvLQK1PJZ6cVXUBr4bKk1KCgZ+VA9mmn6Ex5f0lmYYN0neIlhdZpwrs+d3CsHMAvIUl2uqtx/mJpfmFAS9iIP7PaRD/SkWkSEHHkWtm1labiKKLtbPZs+MVuJV/BZ/SY3SdYq7FYC/2/S3E3tD8uxCnko+YttR+VIDx6a2sT76SSbaexycplyAaTyzoEHMlMaH654AfW1bq8QScDrsPuDgT39Neag/TboYo67vGMrx0RiSSQNvO1zsxuCcBEfq2vBQRX+4ASvRioYs5qL9dyp17aWnSLdKP/nuAjc96hCX5XDpTI1xFucDt80DspKTXGLyB4P9QE6xEYq3eEghw/9KmqhDOqWoo5Uz1QDspNa5scv5eKjpD+yDv0N1PBZbIZrWYYQG6klc4tMQ3Z15Z+CW9KnkF0ZDzcuZ4NR011ZSfH39pU11MK3lJM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process_thread() loop in kernel/locking/lockdep.c with
for_each_process_thread_rculock(), which scopes the RCU read lock
to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
---
 kernel/locking/lockdep.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c56a7f91d72e..ea218dc75ad5 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6834,15 +6834,13 @@ void debug_show_all_locks(void)
 	}
 	pr_warn("\nShowing all locks held in the system:\n");
 
-	rcu_read_lock();
-	for_each_process_thread(g, p) {
+	for_each_process_thread_rculock(g, p) {
 		if (!p->lockdep_depth)
 			continue;
 		lockdep_print_held_locks(p);
 		touch_nmi_watchdog();
 		touch_all_softlockup_watchdogs();
 	}
-	rcu_read_unlock();
 
 	pr_warn("\n");
 	pr_warn("=============================================\n\n");
-- 
2.25.1


