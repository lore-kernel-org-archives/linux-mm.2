Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A2F1C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:22:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4998A6B00E4; Mon, 21 Sep 2026 05:22:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46FCE6B00E5; Mon, 21 Sep 2026 05:22:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 386026B00E6; Mon, 21 Sep 2026 05:22:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0BA996B00E4
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:22:13 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 04A2D805D1
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:13 +0000 (UTC)
X-FDA: 85237228146.20.1ADB3EC
Received: from mta0.migadu.com (out-77.mta0.migadu.com [91.218.175.77])
	by imf07.hostedemail.com (Postfix) with ESMTP id 23AED40008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:22:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bK0t4IBs;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982531;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rc/R/uWh+bsx8BlDmaMeUtHK4G+GzbweTDiP08vcDjc=;
	b=W7Y+QufECrewvtRE/9cinQxlY3P9W0tBRJCvgxojdikZsvrJeC69zgWgFPGcOodHMCT3Ih
	BeMxK2wSolBsAmRvfvOuT4JIQMzneRK7ImcZKvA2MTBqlwnchiMNny4CDwIiu0mzMC0zv4
	qzBfwvYGvXDiGOV9ZP3FvXBv0cT/T7k=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=bK0t4IBs;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982531;
	b=nyLW8Ze4Dzj6YXAIuIAu6p+OFIJI7EYZZQH2RQkB+PlZGFSy8Tm63MdAYA3CFeELCghn04
	uCrOlrwpal3imeuNX2x2lDtnx3kMDQzAgaS70mQDEWgeOfCPZ1LoC8KcjYVLOtTbPVmimi
	ZRBsmfeKjam/xLZMy9MLg7PR0ydfRpM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gg1y5J6wvSizwC3gFVsggog4FN4dVg6+drI/OX9nv8o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982529; v=1; x=1790587329;
 b=bK0t4IBs7xrB9cTbNqFq26zvpmyO50pnhrdWAz1ip+Hc8mhoC4lz5PtSSd2ay1lHz/40lWN8
 5JjOu0ICy4a1eUbk0bjsT8zMq3vCA/cIyjAf8v63PQYPpl5isAgXTBKifa7hHKyJvEe5l1yVtN9
 WGri8FW8mTTlGlcAg2WZxv5U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id e1e273a490565660;
	Mon, 21 Sep 2026 09:22:09 +0000
X-Mizu-Trace-ID: e1e273a490565660
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
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
Subject: [PATCH v4 03/15] mm/ksm: convert process iterator to for_each_process_rculock
Date: Mon, 21 Sep 2026 17:20:49 +0800
Message-Id: <20260921092101.89285-4-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: k8z63xwieruiigazkeasgepyy994duwx
X-Rspamd-Queue-Id: 23AED40008
X-Rspamd-Server: rspam07
X-HE-Tag: 1789982530-477993
X-HE-Meta: U2FsdGVkX1/HgKvLrhAEhr37ZUsQVkRnIOEUZHkTTmgHNwCtLbKb94lurq20QVGdX2joiphqyBCpZWNgnIHMBGeiriydbuXUTURgKC8zJPpPks9zs37CS/Z8eN0CqTf31WLRIUj+qWjzeIgsGLw5qhzrx2ICVGKOW5PYUDVucF0pi8UwW4MdRBdw207PGIwtsaiJVmit3S6MtB6aHJTJ2NEX1LNuxT9WbjHrZe6VyxP877whTKz/AjkGzIxzXXZQYglftsap9a4HW2OJvAU0z+xYEaiGuGrSas93WAM6FvmyllG4dGyTsQfGRf4AtHIVjaA8DDlNTU9wrDoAsd6rQ6zqKPlkDCcm5u+x7sFVl08mLU/lJlEOsCBBPjz60nli/QnASWik2iLjc0qSAtzpqaU3FUwFzUG4n9GeWhO3IqC6RWxIhNw77AoB3GkXondDFJe2K0t5JEkqlksrXgHQCBAMMoqmMSDBpOQwOfSDBCnrw68YWJ9OhVdYLYRPv+zGdV+RNf1/zvVvhysgJH098f6SR+gMwwata0X1bDhWgSFETbzhQmVIDQw7T4/RKDon1HDcroQWd/UVZ4XP89KYu7UJl/wkpzNjtpc4UD3jORECbvNLcfJ3Kn2hbkXT+c92RYrZv4ntFXwyCKK3epKq/FfeCw0POy/+WvWRoy81uUZj9VsohjfgGHIZxnAFM/TnUGt4AWSTSAsUqf6gBxK//eJlbXEN8lCLR7AbMiJNhDF2cf5zlz9DLSWMUKBKDOCNDgJ7C3V/a9mj+W1VI8Rc8HONKz5DCVcXS95V6lzmZXVdKLi8Ejj1JV+hJVk/ZEqYHbeWZnBd2Bev8utwnnf2PSSaSIGyLMT6usJhNJBIgA/DHEJ629+a5QTRqyK90ZvkyGg7qr5wyp42t3VHhBbzF54iUUmZSGElhCMvGQsV0T3y2epJZM+OacUF19s36D7atLhjpkSRe09kI69oB2n
 i2+/c/FE
 BjLjHwpxeZB16ZGamSA3iqE0Sc39qTSrCDC/px5U/s13NpMQJmje0HUmwjTYGrdPOkciGzQydndKX2wg7RJQKfiXi9fLoW+ugZnFou0kLMFg4fpn9lLLUGVcmoeI4nmFMHwoxro4FPr2HMaIVLQEbB/O+c6r78z4eQf2UC4jOFT8Ss/q7ULydJdbt7BojAHx+eMAuUUncFrA0x6GViCFsrRVkVObY3WLXjAskFO4PspHRd0AkrFt/C0Y5Drswx/mtcAhSYgZuAfJSJOlQDYYY0CQHrK8S5yJevgHhSkzhfe44QquT/bcxfnXcAOdEVk3AtKE+JAZQC8KPrca7EX3dOSES3j5noOM6RwYzTGDdEBzk8w5jiYws+r6jnSN834ybUBjFd8G1wYXIVvoWD9Ykpav1XC26TSffjUZSW9tIi4J89vPTV3jg2aepMV0PiqddS6N8o97PHxlMsI9oNWoZnbG6rCovRw3tgOppZXoT1T7pvZc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process() loop in mm/ksm.c with for_each_process_rculock(),
which scopes the RCU read lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/ksm.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index 49d48d1e0998..69d30e80a090 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -3280,8 +3280,7 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 		struct anon_vma *av = rmap_item->anon_vma;
 
 		anon_vma_lock_read(av);
-		rcu_read_lock();
-		for_each_process(tsk) {
+		for_each_process_rculock(tsk) {
 			struct anon_vma_chain *vmac;
 			const unsigned long addr = rmap_item->address & PAGE_MASK;
 			const unsigned long index = rmap_item->linear_page_index;
@@ -3298,7 +3297,6 @@ void collect_procs_ksm(const struct folio *folio, const struct page *page,
 				}
 			}
 		}
-		rcu_read_unlock();
 		anon_vma_unlock_read(av);
 	}
 }
-- 
2.25.1


