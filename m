Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28106C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:33:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EFAE6B00E1; Mon, 21 Sep 2026 05:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19F286B00E5; Mon, 21 Sep 2026 05:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06DE36B00E7; Mon, 21 Sep 2026 05:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D96976B00E1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:33:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id EB106140540
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:33:26 +0000 (UTC)
X-FDA: 85237256412.15.7502EE2
Received: from mta0.migadu.com (out-231.mta0.migadu.com [91.218.175.231])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECDF0180004
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:33:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f9zsQ83j;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j5JVutyMjqUIMqRrjGzAkSgOG1wnS+yJm1MYDWgx7TA=;
	b=mehdEb0l7M6ae36LG6g2A8jMvDXNcLVtNz/KKZKyMP/rDDhX66d6TZWVIE8UfPz++PwJCd
	Y0HXxBqjNb/YcmpbEqeLo+FOjCGsym/91IMilDftkzyvO3dLFh8geRki1CUH7+evYbBeId
	NPoVQJT1zGte5ZTpr+Ui2SQaV2jcgSA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f9zsQ83j;
	spf=pass (imf24.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.231 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789983205;
	b=6kynheypbBkYYAGfLJTtV8d0554NpcYJcfiLHfL+RaiAnMPag1vb8i04uw81rQKhoOKGi5
	JcVUyJc42zIp6h1u7g8IM4lCBMPn3neMuc9HXhPa9J0ayrqnbisF7T85qNjrQ+8p+dGCoe
	mLLj6GtIhRi//wdO6dnWpPGaZYhRFuU=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ngtWac8X3lY5A5SaQnbYXeWkN/JG2JLNpAbPKFOiOjM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789983203; v=1; x=1790588003;
 b=f9zsQ83jctwgcHU/RmDsAzFpBmzcyeP8XJuu2OwoLEJIDVTZwJcC39vehYpLwR6qsxzsPI9Y
 1+31/aiNiv1DKkowHmxvokW9QTtZDPyV4BGyLdG4qzQ6MDM57NXkFeWBffJ0r7oaY0jB/d2Xufl
 QY//agRj3sw71upZe3+FidVc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0b8bc6083ed009dd;
	Mon, 21 Sep 2026 09:33:23 +0000
X-Mizu-Trace-ID: 0b8bc6083ed009dd
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	SJ Park <sj@kernel.org>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
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
	boqun@kernel.org,
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
Subject: [PATCH v4 14/15] lib: convert process iterator to for_each_process_rculock
Date: Mon, 21 Sep 2026 17:33:10 +0800
Message-Id: <20260921093311.104814-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 8shos6z5xdm46rq7nkj9q7anek8x6ks7
X-Rspamd-Queue-Id: ECDF0180004
X-Rspamd-Server: rspam07
X-HE-Tag: 1789983204-681794
X-HE-Meta: U2FsdGVkX19PbMUu6v7hpwGwczAKIaPMh3nIlzobHxOLr+WVKHRKC4d5rq9lnwCnzF4elrRP9V1SsXCsxYzBbTk4S6xZiQF47CbrtHCBamffsay0jWd2ETowCuw2zx51NOy7Np+Cj+Fp/SyDY/pYjhoIcI4wemmKj4ZGHSaPc+EmuXPXCVvFOfm50/CYnMfSaOVh0iphYcdE++ZnIE/9wMOb8nK2RwvxjU8HlYGU4QJ+/7H3myjNFZzCEBgB0KMUpL4OUl1meQyLXqsd2etqx7OEdg3CvQxJNz7axh/NMxu+JyQL4JurRTrKUtnm63uCpM12YzziaGopxWNI1tZp8BrEyQEge6K+dtPfyai1EEOWls+riaXGivXHt2IzNVGJRnEbdLVika5513oK6b+iZ2Mz178COUO9HMlNQFWPDV7h1byuTzJCmaezfgdHOl+vdAAOkqBpxHcbqbXh6043KJE5RQTXJ20nEigcDnzvpVuLSoFpD1jMQphyc+ZmyUnjXzzEfVgMzL9pyC2EEfZZxeyG26LWCxwyJULnggtG+DZeHdlBPQN5VIiRpqcALuMI96Ygjzz/OndwxjL/34egWvAr8KUHllqgucfFIGFC4lPoG0iMU3EdVEKT0+9nwVwGQ3oxuqXXGqPkNMG3wgIw1gutxxwUoLumvU9CPJOxLqmui9NCi+I2cKMSkLD/0CJ5pdJ7eX78XLbxZdlsDwos0DUT/ZTuW0Z8zoucQrXTn2bsoY9ZjrW1BhLxPhIIdahMEGwFBAkzpFl6w5TkM0/ryN6ChYXwWkLxySuQK029Wh73MoYVAtt8RduA+1YD/auG8mjtdJx3SC03kMoOFLFtOkanaCi7f22TX56CbXwC9B888+t3Dlx37/bBRl6dHShBgdzouNYMJ62RCSWJmYIrdoveU+vRBYogyy2QXEI9tlXopjGZ1KXNykH7ZQ+X99/RsknC75qfL94t6nTnJQD
 BjXsD4nj
 tmAWtkWhVSzD51Ow3wvGQDhPCzXK9k9ZW/Xp3/SKY60bKkoDtBcsPgfIo0hylxki2pAChHzapPTfSo2FmouprPTBmt0+3tFKnvbf59+MCbVa6Odtsp27qlTdtB9CmM4eEmKfTI21+6kRiuS57YUTO5APTAOoGljah9KIczv+PzccFZi6zq+VjulCfVgfx4TtJw7XjAkgmWb9sdZZ8HFwaaSu+ORnOMo6YZmd7FIguMsEoIcJalYU4DAVuppzwWIpv3Nv/U6VJSRO1CzbSmS1CO3UGglEWeKZNfPkzlcNd2HtsoJaq+vjZ/d9ZB6GtNDg4rnts3kgawH72kU0ltgQBnYmHLwTV84vuqERB0kfLeEBLznnKiJ+jZHE4THOaGJILDSBnwGSKyr257kpedsa7k3nBugbI6wIZ1xFLUEKLWdo0ijKNA5ALkHwL23AtT44IlyxKnNs4kGvNBywjfqPxiib8HYyceI+HzP6Lmzb/cPyZza0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process() loop in lib/ with for_each_process_rculock(),
which scopes the RCU read lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: SJ Park <sj@kernel.org>
---
 lib/is_single_threaded.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/is_single_threaded.c b/lib/is_single_threaded.c
index 8c98b20bfc41..4e7fe85454ab 100644
--- a/lib/is_single_threaded.c
+++ b/lib/is_single_threaded.c
@@ -26,8 +26,7 @@ bool current_is_single_threaded(void)
 		return true;
 
 	ret = false;
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rculock(p) {
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
 		if (unlikely(p == task->group_leader))
@@ -48,7 +47,5 @@ bool current_is_single_threaded(void)
 	}
 	ret = true;
 found:
-	rcu_read_unlock();
-
 	return ret;
 }
-- 
2.25.1


