Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81B71C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:59:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735C16B009E; Fri, 11 Sep 2026 03:59:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 70D3C6B00A0; Fri, 11 Sep 2026 03:59:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DC8D6B009E; Fri, 11 Sep 2026 03:59:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2FB386B009E
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:59:51 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E38E012012C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:59:49 +0000 (UTC)
X-FDA: 85200732498.04.1D5B46E
Received: from mta0.migadu.com (out-212.mta0.migadu.com [91.218.175.212])
	by imf12.hostedemail.com (Postfix) with ESMTP id E5EFF40009
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:59:47 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g8UHpIuH;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.212 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113588;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F+I8IHFKQ8YV62p3G/j5s1fPtcXJPMojYZlTSPytzhI=;
	b=MGHFPCPdQ+nk4pGKVnB5QxtLr2a2HcUFRTFB8yWRcJiinyCx3gtIAb3MB+VT9Xl8cGM9WJ
	dTFqB+KdFlhB4FxHf3Zr0VpC8eRTcg/Bv5RgKRnPlt29ZaZphYYaQpUpEukSKNRaBGDkkl
	5c21EyK2pTb8DZrMVkLK4/3LCFF9ep4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=g8UHpIuH;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.212 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113588;
	b=fcMQfHHJhPCHg589oRs7qt2QC7UOq8+flZVWoM+AammSzfWgGzO9BLZbiZmBi44wzz9CDQ
	kpypscWb5Tx7hiZ1MdsGlrF+BaZ8sgaNjCFTlOxYGdslJr7Nf9daGL6hM57LZI7l4I0WIF
	Rak8ZiuMzCOTJzcUQOpFqonGr27a91s=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=TDuvYwzdbuaBULIJ2jxj18W/NBHRAQZRTlKBQBMgQMs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113586; v=1; x=1789718386;
 b=g8UHpIuH1iiMFg9exMCp0oGDRdZkKwS0rKp01RPJ2FqZf1pbHq60jt/hle7Q83ez+zGV5PPW
 VXcKnnCODgMP8LJqBecns78Yasza6y60EBziaaCU7K6zZPjiRXJAcnEHFjc5oEhBw2Jmx/Av+F5
 IZidRLrA5pukiKpMJDN8STQ4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f84c3708b464234d;
	Fri, 11 Sep 2026 07:59:46 +0000
X-Mizu-Trace-ID: f84c3708b464234d
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	tglx@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
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
Subject: [PATCH v3 06/15] freezer: convert thread iterator to for_each_thread_rculock
Date: Fri, 11 Sep 2026 15:57:51 +0800
Message-Id: <20260911075800.491472-7-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5EFF40009
X-Stat-Signature: gtox3p3ibxd3wgphwaga3wn1pwm7567k
X-Rspam-User: 
X-HE-Tag: 1789113587-840850
X-HE-Meta: U2FsdGVkX1+xYJh445kQ7VhDYjgZy3iETsdcaZbrxL5lP7ivU+xyrOkTRa5+N4Ipnc54eqU6bwXoqrrn73FLHuDYp6q4rYUVCnU19ZhIBsOMS/JRGk+15aknjqUK9dXApYrQIA1eVgGzuxDm3dkwk3FhbOGRhzTG/qynbVSnW8I0K64iXZgtGOPeSVdqEIXEN+ddEPWjaF9iJaz7QAMFYHQR2sH6eqmvfj7Cghv7PYAY3S6/WQcZSTwSxt3f+7HUVxO7OdJK1Z9ySUC+H1JUXuXmz7C+FydPBRu44PlHH4cm+gDKwHbatcavsLtPZPEdtMPArntErkxWuEz+uo1S/ssii4O8Xu01NihvtaL6k1R5cBh4l8sOPD/K9FjIchD6UMqep5yqYW1yw427u/taM7LSIFU7hGNiENzD6GQAMfUSQJ1IrIT2r/577k/XCFvKeM605c+928ICUg7YZQxPjGWDwuuGqzZXlyaaWjjpzgCjVjUBijF/d3t+ePYvqBZGk0oyI6LAxiZh/2s63pWOUbqGcVmeCbtlP8cv9OoGwhVfn8EaGL8/ZM0ZJvsF1Seo6s9xZXIj9MLrcdoZVAVw99z4KAnlgqhHQpoD1EjpQ7pWurCboFI7MYwtHHAsO0+2Jwn/FpBH8jBUHHMu9nfFSJbJ3+r3uoBkkWdHvze3p1TLIi3jLWj+7RanI+C+LH5BZNOVuH8pvm7FI+8ZLIPeX6QeFgdS9JMTfNdJKUoO/xxjXc3UOFRfJNIExsMDVds+k+R2oRr+O3lyxF6JI3124EYEdimacZ9YBLhKoiCiXVnz6TLMXGYpKUaqX5hkLFmh81/k3/K27qm63EMXPebYao/t49hUrvMIgosjT4iirWUval0r75atzyLTy7j5p1kzKVN0mI07rh5IwzfWdTG4jTybho+QngV6PJDGW1uqhCcCZGQzEXFtQ0pxy7RWStQHpFmKFRVQ28doBt6pi9m
 O/6YYiUP
 ktWV4AMwZmDR4/UCoqQgnwlQYJrtEQ4QHvjsbR6xEYkv22XZ5xsk1rZMqezQtCHRzPUk4z5b86t+gzQN/HkpjYjX34Bq5LtYhe3fLglNHxNfFc4fZUSAkyMjuFzfrhIb4eYiyylynBz/X3BOiD2TWFUedSYDZd4cvZiupy7vOeuEgJT+pvzC8fBZh5WHUL3fZ8cKVUmp0zc4RjNSpqic7r7T6hQIA0WbIFyykvwgT4yJfH3+WF9q6KldWB5UTZls2vkOZyj/XJ90kuWGsdtSTFg+vnweURb00qSPDbALNUTYlbPXg00hrZ3WT4gwu3g6h1drQT3LrZHPAHtgCX6Nq0oD/FEtUyxZdFlaDFh83mcIAJ9ecSy9aPQHO+JipxTcIyo/1x2ZbnvGOXu5N9mt629wkq0jcK2Q5GgfHgfz7tU+eAHrEJUFLH8oJPrWLNuBGbjsQCwZhnlBJ+Sg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_thread() loop in kernel/freezer.c with
for_each_thread_rculock(), which scopes the RCU read lock to the
loop body via scoped_guard(rcu).

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
 kernel/freezer.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index a76bf957fb32..7a870f71dcf6 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -217,11 +217,9 @@ void thaw_process(struct task_struct *p)
 {
 	struct task_struct *t;
 
-	rcu_read_lock();
-	for_each_thread(p, t) {
+	for_each_thread_rculock(p, t) {
 		__thaw_task(t);
 	}
-	rcu_read_unlock();
 }
 
 /**
-- 
2.25.1


