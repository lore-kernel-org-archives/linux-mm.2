Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46CEBC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:01:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DA586B00AC; Fri, 11 Sep 2026 04:01:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B3076B00AD; Fri, 11 Sep 2026 04:01:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CAF86B00AE; Fri, 11 Sep 2026 04:01:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4496B00AC
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:01:58 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id BA6E28012E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:57 +0000 (UTC)
X-FDA: 85200737874.19.9D46C9A
Received: from mta0.migadu.com (out-45.mta0.migadu.com [91.218.175.45])
	by imf08.hostedemail.com (Postfix) with ESMTP id DF59A16000E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:01:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjcPcQDO;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.45 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113716;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EtGetZBFMM/JcComdy7PB5yqvUorWDrNPSYLChsto2o=;
	b=b9b+gI5jS7JNpB+meDiUoTRTDNuHkTA9ojNWcyUo/sh0cXOTmZyyWv5mEau8zb+gLnr8mD
	D/U8V/XFBrtk/v/8cVgFXi4zwTraT/kkB17mzeS32HDc35w/IJKPmr7lPVB08iUmpgTTtK
	wV4Ngqct3hGL38IvYzkYV+wBu6cvyhg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UjcPcQDO;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.45 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113716;
	b=o+XHvaadosF+vKNwN82F4qps1huOjQY90uUwc73nQ3Tt/l67020v31Z82uv1fci/lAF5GT
	80TlPXVNKYp8/Bmde7qryNO1wQSx/lvLpzc5/wuHYma6GsDPWfIWf1sSncXnHSj8GN1Vgr
	BxY63/F7nPdGiavvjSQ8tZqdPiDymCI=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Re/ZsMyjr8Kl1M8Xab8XaAEgyJ6r9rT2dZ2X4TDsND8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113714; v=1; x=1789718514;
 b=UjcPcQDOh7J6vkpFrcteNi1zUz7dIM0nAAKZgQgvTarbMJTiE3coDjU8Pj2EWY5fivxKe2dd
 LEC4NFSI9WGVGdZkhi4ERY6K2Yb8H0qpVALmaZf51lH8v27JXszGAfsroYwza3D5hPPzD0KUVFO
 U10C4ohj7jdtjyqcH6sxNZ9Q=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 67efd391483b1f6c;
	Fri, 11 Sep 2026 08:01:53 +0000
X-Mizu-Trace-ID: 67efd391483b1f6c
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
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
	babu.moger@amd.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-pm@vger.kernel.org,
	rcu@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-security-module@vger.kernel.org
Subject: [PATCH v3 12/15] unwind: convert process/thread iterator to for_each_process_thread_rculock
Date: Fri, 11 Sep 2026 15:57:57 +0800
Message-Id: <20260911075800.491472-13-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DF59A16000E
X-Stat-Signature: juu47afoyigfeeh9duny8tamh8npu8da
X-Rspam-User: 
X-HE-Tag: 1789113715-431814
X-HE-Meta: U2FsdGVkX1+Q96so5klIF95/Iz9Q7cwMmcDcSGYAldyOgMvoRMU50noA3akscr9XnlY6p2nWSXeSRo/xWO5xnIFgJKu/Yx24tik/eJgDWN9Qihau+Qt02tfGOBYMIRFnLdWeszIELk6IdGo5ixvfPtZHG8+5Qm3IqkVfDa9A4Du1XLQI0UW84UphvBci4sSfWb1AdtMM8IMPGh8x3XtGdYZ4Z7in7JzZwDr3dsHHBmFLXrP/GjhulyD/xT0mVREL/kRU8+/yHRl7k5muYWZK2JjvXKQM0mmDzvJaOBWGJPXQtWvg9hrUG5qwtINrF0t2gzjNM69P0iGnlPumzTzxyimGAN1Lwpck6Ga8ddLwq0vfTjr4w43+dsEVI+JsTh8SQfHRWsXaTZbOAWOWesFSmAyGyIIE0cM3Smjb0zUVD9FXSWXgQhraCusyiIKGa/4exiXJseICmiGTIT8kbZFIe53K8wzPt6dWRO7HAj01F6poO8eWorYvi95o5pJwoAryPOCqgUwZTesmDIP8vDcEg3/2GBE4Nrl9cSjqsgW7LRTzs/8HdqTZiYSZUf8KuK7dTE0W18hCcxYFbyRJ5lR0Z1Q0c23AOUiJN8T9IkUaMgqJ+CA6VSA1zgXAbN4t68OZ1S+Cl5ni89CSDMxdyoPR55fxaFA5Aj/KAFhxUMgiTcf0nRpuchwKumjD41riVdc/X5hbOUC3wtphKLkJl/dNaXBd8HgfHtyekh4wkZ9x4IyKoB2beST/NzjxN8iKE/TALhuxnXUO570RQQ8vuntXJYphTccuBh32JM5ifigu1atFjNbcfs/NeE0fX5zXxWwUFR300H8hptoZ8KSoqvOaa8fX0Y9qimU5lq6srx09EhwchpyRO8wLtY1JBUF1qneiJ/JhRMBSr1U0TJRCrjE9FJBaLFQBDh/X0EDgNywH4S3MoEac2Ud29o0iKJcMqi2BMqnXqk3h2gQBZM4Oh+M
 B5B0V2SV
 Bk16sgixakKHxZuDTxe9hMauJapFCzCuTzNm+gE9ZuLIyBbCMAgjTTm6ScPhftcR1KhJyeoaVBwuZax80qq+bsuDWkpK4bFaXO/Z2Yehui3A70X4SMMHSgqoBLGrJrWNzSAWYM2Sggh90boJ6jmDt2fGLHui2VLOVajl/VZieCMDvhRL0Yk8GTMfVu41URuQUhP3N9hCtQpDI9Xn+9U5YOmj0iUUtknhXGXzPYYY3H+EOMwJhn/u4haJGfALS73ppDKv3BqpZUJRx233BlW13DM/T31q7wAWgyIRFt1dC/yEmCkCE3RSWClrHFQWgLTNv3VAwnwgHDvEA5Nb5rT3uZesxmdOQ11vFkBuLFdoJqDFj32q6B03GpjgI2H9p/0qaRYLD6DSkyYdkT0jsHxx8WEhIWwGHo2hAZ9Ejb3iyM6uH+iS3ypuoorzYFF4+wXf9OELnYY9A86ImUoc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace guard(rcu)() combined with for_each_process_thread() loop in
kernel/unwind/deferred.c with for_each_process_thread_rculock(),
which scopes the RCU read lock to the loop body via scoped_guard(rcu).

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
 kernel/unwind/deferred.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/unwind/deferred.c b/kernel/unwind/deferred.c
index 5bea47314254..ecfe1336095e 100644
--- a/kernel/unwind/deferred.c
+++ b/kernel/unwind/deferred.c
@@ -319,9 +319,8 @@ void unwind_deferred_cancel(struct unwind_work *work)
 
 	synchronize_srcu(&unwind_srcu);
 
-	guard(rcu)();
 	/* Clear this bit from all threads */
-	for_each_process_thread(g, t) {
+	for_each_process_thread_rculock(g, t) {
 		atomic_long_andnot(BIT(bit),
 				   &t->unwind_info.unwind_mask);
 		if (t->unwind_info.cache)
-- 
2.25.1


