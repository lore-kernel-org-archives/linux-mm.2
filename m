Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D33C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:24:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5AE146B00A4; Mon, 21 Sep 2026 05:24:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 585026B00F2; Mon, 21 Sep 2026 05:24:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49AE76B00F3; Mon, 21 Sep 2026 05:24:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EFD26B00A4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:24:12 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 745711605FF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:24:11 +0000 (UTC)
X-FDA: 85237233102.12.08CA8E9
Received: from mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf19.hostedemail.com (Postfix) with ESMTP id 89D3D1A0002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:24:09 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CsrOzaLb;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982649;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x60+xhePmu8z7+jGVLNc+c+2F6eForyDzk9vNhFTqa8=;
	b=6xuxRhaT+0oejX0a78rg+mai5Ao6uZpVzLYp5IUF1/e/oxEZ3l8cSt0VBMy5FhWOBHsgUQ
	H523UmONb8XBKZvpr/8e+LFw13p9KBtgpZ3rRY90u8JwTLp2Z30cL1ovshZG/cba85UuGl
	kZzowmpCcsSMBCxVIFx+7j1+2oW+HTg=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CsrOzaLb;
	spf=pass (imf19.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982649;
	b=0iuSI3Tpk/oU97cO8Ykd4Wsy/HL9Sp3HPWAA0lBCIHcaksj62Q1K7G9NF7zUzWiC3aC+u5
	7CqpvM6mPS8xDTAr+f3kBDxJ0pIGbh2M3Ezewd9a1ymeal09e1mqLglMNDbR4KQYgnzXKv
	8SQfn+13Tjyioqtd99rqRP681KPxB/4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=VqnVaCdhVlGtZkszWTI2vWRw1i1BnDWykkewz9dTKKk=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982648; v=1; x=1790587448;
 b=CsrOzaLbncf1jifun0BnzCbuZmSUkImkyOH6UEG7P6A+Vt+UHtkBjSpvOZsQen6Gs1BBhnKf
 JJXOgk+/vI3k3CHqWgDGCdFFhAEbadIg2OFSrD2Kh+26utEq24v1OUZK1+aPv3rnawiazblk0N+
 iblvXkKpkWKJQgTM3UnRfQM0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d6ffecb1f71c0195;
	Mon, 21 Sep 2026 09:24:08 +0000
X-Mizu-Trace-ID: d6ffecb1f71c0195
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
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
Subject: [PATCH v4 11/15] tracing/fgraph: convert process/thread iterator to for_each_process_thread_rculock
Date: Mon, 21 Sep 2026 17:20:57 +0800
Message-Id: <20260921092101.89285-12-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 9sw1chc5shqbdyi9nyxiopxxd6q5ic9j
X-Rspamd-Queue-Id: 89D3D1A0002
X-Rspamd-Server: rspam07
X-HE-Tag: 1789982649-253340
X-HE-Meta: U2FsdGVkX191yndCTrnkHWO3zUdzWnh4zgIZ+iVxfPXJXKI6GE1qmiYsbBlEj2plpPHJo8Zay7Z0hzDc7nKSQxlCu3s1nEiT7kd/JlywA2z+6qyiC/rAfT/A1fSB6oRtyVXZOENhFMrMKYSX15SaqXwR/+RYdpZyLG0VSc2Q3akj4ki+/ISlK/SeeYuvc3Gl+XV2rPHxhYqWcM1yoThwiZSqf6ULHPRLmtvlGoNyJ6x+k/VH7a5m+bFYT/UqkwWVAP/iot6fBmaGVd5zWT5WTkVxe7mDxqWzi/1m5r93q+yvG5hyiJiO3/O6jcuSOa7G0RTncYnpLbdkk1F5QTFD4Gpf50+y/JRcFLfepHhRezsySxyvNa0bpFlsgbA4K174TrhypgHCsQQAslV4Q/qq98B+g5bTvi6OhWolCmcXCDz80sUELV4m6BVWQfWY4N5a1TNDKzT2TYMkBs59KrA3WLRn+zGE6dgLz3pb2y2GES9DnrMi6eLZkla1G7k9Cz8K+FvTCL+MxWdz6KVhQeHbF3yyZoUY/w5jPUrsrZHQ9UpsEIRbjzj85L08wYRTbalfwLZgqfhBFvgCNrb+EFf1KyeW11d7YHLRgDRdmCkBpbR98e+XpMJa9VmW62l+zxsugG3gMRtZqkXVY6Bsf+4gyNLyNOArMIJbMSrGjAG+vVVX98fKnrq123BJNADtFWmU77T/Pyj1kEZAfUDRE4Pq7yRQQSsSP0W4zpk58K+8RsMm6d63unXdTmGG48vuwPSA0doD+hh3PLPzgDznyEab6MPQu+RJBbv84tPq45ddTXKuW6Y6ZLc/lWqgWk0B7jCM2rdzhePgStpcu5jOhtmPKDOYJpk8uyxK/eIHtJspg3uAzwHroFbDA48dfTywUcn4CH09ASWjz1mec+wCZMTr2lfagxJcnW9O0ekzGmHDSn+nhXlUIRt4xIvuhHODGnyufQ/tOiOPuwAN0v/LZ0W
 DwnipD84
 qKBRW+E/Q/Zy6bRUgHCO9oF0+8PVA1VjWcCob/TX3baVyXYlpBItghDCZ2Fy3R8IExnxnBuq1jmZ6JX6Px1MNRAj3HBJaKSAy1FNUq4yNQEk8eJwOahPYBy9m/h4VQt81G0saNMmZvgfhBwz4Ul5qPBMPvzCW++whbgbghSnD+wIY8SE8Je8b3oKDijmNHdnzgoG6b6sOnGxjZDmq/t43B/owzQ5Y2OCRYGSxYwEnEynhwv/gc2m8UhlEKLvb9QUpBV9KcMqDOTuZj7ioXyf6dLRCC+s+O4tuq4v2+wH2z0OyNh7BXEEXk9QVs9Yw/I1NDN1goi9Pn+QBH17kvDED66COyr3o4Sj55xaqJ5TFPMbnR2fVQgLlKljCPEaT54R35goZChxmWUee8ix1nKJk8yoBfvQ4CMT7rdnYmHyP5V2Nc2jmhJuZvppIbwzhiP20T7bya+ez4DDkkvztkR8xa7Nz+w4ng0LQOY6nUACu0eEIMmz4vMpOBqkOV/ijBv9Hc1O/
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process_thread() loop in kernel/trace/fgraph.c with
for_each_process_thread_rculock(), which scopes the RCU read lock
to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/fgraph.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/trace/fgraph.c b/kernel/trace/fgraph.c
index 40d373d65f9b..f797ce119223 100644
--- a/kernel/trace/fgraph.c
+++ b/kernel/trace/fgraph.c
@@ -1057,11 +1057,10 @@ static int alloc_retstack_tasklist(unsigned long **ret_stack_list)
 		}
 	}
 
-	rcu_read_lock();
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		if (start == end) {
 			ret = -EAGAIN;
-			goto unlock;
+			goto free;
 		}
 
 		if (t->ret_stack == NULL) {
@@ -1074,9 +1073,6 @@ static int alloc_retstack_tasklist(unsigned long **ret_stack_list)
 			t->ret_stack = ret_stack_list[start++];
 		}
 	}
-
-unlock:
-	rcu_read_unlock();
 free:
 	for (i = start; i < end; i++)
 		kmem_cache_free(fgraph_stack_cachep, ret_stack_list[i]);
-- 
2.25.1


