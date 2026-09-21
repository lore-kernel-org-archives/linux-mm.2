Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B915C982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:24:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D74F6B00F3; Mon, 21 Sep 2026 05:24:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AEC26B00F4; Mon, 21 Sep 2026 05:24:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49B9A6B00F5; Mon, 21 Sep 2026 05:24:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2D6876B00F3
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:24:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 274944059D
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:24:28 +0000 (UTC)
X-FDA: 85237233816.27.3E0C159
Received: from mta0.migadu.com (out-28.mta0.migadu.com [91.218.175.28])
	by imf28.hostedemail.com (Postfix) with ESMTP id 494BDC000B
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:24:26 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WHMTgbRv;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.28 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982666;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IS0fpYD8a+660S+BjlxZa0ObXjpNXzsRAN2yCMLEPSs=;
	b=qFe43nAqd+oAJ+RwuBvZoNm0klDaST5vZh9gu61qXE0AnF8RZv6vMcAoPLZ89bjTofwr6R
	4hpWOZtJ5/lmNL8hvoDiBmtRT0SRBdNJa1l7YMfsbyH6/KFGnrOW5JnoGoTS2yxxXIeKbQ
	B48aus7JiJS68WIYw1PQxkfTdiVo9YI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982666;
	b=QX0a71OHOnJqCK9dUhzEzpzNma3rt7RfwZrUHWEm7CKsKa7Tx46MGuIg/qg//Oj6NbdxYx
	mMkcAdrOKpZ5wbh4yh4k3b4Ch3ktK4OYKDXTZlWb8dgnfjkycfsGnMm44InvFgiWPDI6du
	qRUX5LnZLx7QtD7NhJtgFkcpqLeWsa0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WHMTgbRv;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.28 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=2f1S6gRWH7DPHgoPeU6kEsDfvjq6VTeSt0plIQ0isA4=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982665; v=1; x=1790587465;
 b=WHMTgbRvPSSXnOlneVAcev5VyOtGncaE0y3Jpse/ogTNR7KWreK5/5ybkWnl6Trv6v8EoRnN
 NKPfhVOT/BK3vrvilsbYl6fSjbqd4E+Z3BBQPcX5PvekNmQO6byuEByeva6zdZylPafhW45DTFU
 N9nBdyWHMhw8BBIBmq7T+keA=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fe7b1edeab76f221;
	Mon, 21 Sep 2026 09:24:24 +0000
X-Mizu-Trace-ID: fe7b1edeab76f221
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Josh Poimboeuf <jpoimboe@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	akpm@linux-foundation.org,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
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
Subject: [PATCH v4 12/15] unwind: convert process/thread iterator to for_each_process_thread_rculock
Date: Mon, 21 Sep 2026 17:20:58 +0800
Message-Id: <20260921092101.89285-13-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: z1xps1n8efmyhk9o3mgzuggab131s9u6
X-Rspam-User: 
X-Rspamd-Queue-Id: 494BDC000B
X-Rspamd-Server: rspam03
X-HE-Tag: 1789982666-373055
X-HE-Meta: U2FsdGVkX19F/K6frAolGizJDQkuAfwNXoAdWhzcDsrA7FKd5JGlXDf7ieMjeOJYgbWg6obGsW2dwWo1l98rNeUNDYHxbuGb5a5BE20N3pSgbppF4Pc6Fnms0vW2OdVJvwZqV4H5X5nsPW68g0/SMB3w53vQSAWktPAKkwC6aWeOseEmpVrr2zRhb6ax9uapRjr952RLHd978/7QbsOt2pEnmLVi3EhQJM80r6LInAasgkrOSQuVD5+5gvJ2hfq0tsFjIHrSqRndnhEPQfASQ7lPorfnoWDgR7+tQDcNFq+bLBlGa976++AfJG2JvrQrIEmz95gsOuzrn6+fvHjsydVV2gmty+2fJgmy9CMvmINWTvtK7BrzJqUiGz070Wx93nTFiUJvbqOtd5o6kfjfrEmD8DHXyrMKvI5AOtJGJGtNO8ZbIeX7lzSTFTE/tFUl1lJDvERmfnA80AWe7E/Y1r9CnqoO071YCBnKvM8Immv0jPhulnz3sKb4nXybCXTjYcrovcewnnaDLPNTna3WPznR9qLfGoHthzmQWS3xLDeKk/YFYmL1Qo4eZALelSdMKgIiqbRx27Nq5GDH154sW2rAZvvTKx3dQEASc4zY4E7tcUSUHQPe+5tQ+CQr8y9B2nIBAZHfxMYnKGoB6bZKKFY+JP4vLJDQpwaNyAps+cHEYtPVNFqK76hJBO7SorFy4Xl0xixwUIK0Ric8Po+lu7Z26he+9jAEAKnUYzKiqr8zF77TcEiHYlXTepicSCv7tT3C3BOvtNh8dxwWHraEHJ0Aco3HPM5E3kGe+oVHWXc9nkyi/PIXPtqWSTBXO6NpT1Z0WMHmdCrvix5BZgXc2bCtEwfFgejgIKEMSZm7dTk5kSiMcl7N31fIMR7cMHQwObh90yKv7O4UAYhtu7gYW/RzsFqJ8tIGUaKU9Y8WuMGwcOyyfyNOgOf/JmJJwZ2lJoPlUhPPaWn6QTPXeTO
 Mk0jlC6F
 X8Jho5QzYEZnyMUeqsY2x6g10JiLIIcCH3jw5R3c5CcQCYyhdVNgQY8qfn7Dy4OJ62yDqNWaW2jsUdEsefO/xiBVLLXY5LvLBbb6S0n4V1CDJYOUGd2oPrhecJBxK7V8VmbhmD6kV0g3M62gNw6K3hppq9x9vlR6K0+5raHN7KX2ucGhpkzr6YMUUoJEmHLPrqG6ISY2o3BHffSo+aJ+o9HuAYhvBX8D8IEp9NfqLHuMtmWxYJX1U5GjlZoxFKWZ+XEprigvdQKNKeducgWrlYKV94ToicbNMLWoj+FhzEoKhBU/mL1fxS1sVlCdwWCaseIkYj4z99CySfg92MwFg3c9BhelgyBIMZsnpBtOPdsp4z6E2N9epI+36BeXf6CLU1BrYVXPlBUj6UOyK+pDmBcunbDD2Td2Nnf6WCNidCeFqKDFVtqfgHAYbiAnzuAyMiU5fbn2vE6QE31QVXycmePQDcy4lg0360unazfIs2JjStzyTPDAO5JnYJjbEAWMJDbB9tQEjTnBdcuA=
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
Acked-by: Steven Rostedt <rostedt@goodmis.org>
---
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


