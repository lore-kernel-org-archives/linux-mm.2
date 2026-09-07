Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD0C8C79F9F
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:14:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DD3896B00A3; Mon,  7 Sep 2026 04:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D83E46B00A4; Mon,  7 Sep 2026 04:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4B8E6B00A5; Mon,  7 Sep 2026 04:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97D406B00A3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:14:44 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 41E63A41F3
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:44 +0000 (UTC)
X-FDA: 85186254888.07.378EFFE
Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	by imf28.hostedemail.com (Postfix) with ESMTP id 558F8C0003
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:14:42 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QsEv9tJx;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nQ+F8GUyQvjJq6dfsDo84ZbC6xAHAPh1z0XLCDR2tgw=;
	b=lQGBWAOGcWA2yhYXDcyWoeqJNEsVlwzNCTIAALF/hJI78KoFiawnNcRviKhsDBUpWOTIZ1
	2bR2VN87F56TTqhxY8+Sr9NBBnEdrby731CYGgoEBBstEZPUa2orNSBHhEHw2R1hxcddnV
	Jh6QEi05js8Y7Qm4JCTp6PFz272Jlx0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768882;
	b=3GHT/u9QlSiu8rARdaoKB/nEPUFyEJO64OUsrTjybCo4rUvaU0h6mN/DEuKIm6RYNNRkRK
	tHFWbr/TpI+wpWqXfiCho52viZDV0xyG89MhVLPsFfLy+1GrOiudejw22Tz13Jlx5U4b0s
	NjqGLqmEljvzokZEP5qxpCpWWpZoXWk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QsEv9tJx;
	spf=pass (imf28.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.68 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=DbvxqJsFC8I1jdIyCJVYNExbjeNMqAcKd+QJ2gOnSsI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768881; v=1; x=1789373681;
 b=QsEv9tJx+htfHkVlXBVh0jqEMfIZhKIiV4pwh/o31FxltAeubh5Va9WuiRzlYNnLS4RGXW4x
 3HwvGovI4EWm2dTeyV1ldFWXVea0E0hYEE3zKgj/wnYlr9LKJjErOiTjJr0WPsIeC7AFEexLstq
 DOoFXOu/yiKrsNroNAKn+bhU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a8a672054efb182f;
	Mon, 07 Sep 2026 08:14:40 +0000
X-Mizu-Trace-ID: a8a672054efb182f
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
	ljs@kernel.org,
	sj@kernel.org,
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
Subject: [PATCH v2 4/8] mm/memory-failure: convert process iterator to for_each_process_rculock
Date: Mon,  7 Sep 2026 16:13:30 +0800
Message-Id: <20260907081334.1152889-5-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 558F8C0003
X-Stat-Signature: pgc6fyrnseqbjgu86omk6n6r7r8xbre6
X-HE-Tag: 1788768882-496080
X-HE-Meta: U2FsdGVkX19KhJlmc/pcqyXiqpyMKvXkb3jfPDbKbu+cPCbD1t3kxsT0+SWls0o0B5Q17FjHQomaNi81DePi7aYgZBeHpI3HB5YKyI5Utt573YaQhPB1heWmQrySJS/m5MVU+ZATeY4fawA/uVUhnmOjgWGGPG+7yVXhjl2Xx8l9HHRsbz4ZgBEzohtHX/2pHtKOK8wNT68EquN+LqKNbHn0sJe9uD9gPC1YdCfAxl4s6EZ+6IC6bGOR/Ana7TDYvKRhCduQ1n8s3hhf2PXTAIxSjFJ+vnJlXgjgx1bot21WoJH8cxXwkr9u7LhJaPteFrxZpzp7AZWcHvTmXTmr9x4YNuaRBpEn1Canq63JJd1mZ+K0Alju4cCKDOtLJ5wGZ5L6q5rrOvLt7Ti1guSA73GO4HdVkb0wJ54fc55d0tvkSYg4eWoUE1/sXB0Z10DDCGJFG2OJg6iIJMQWE6AIZgff5var/QsH7ydOdgds01w2my0ULCH/uMjzSoaBAfRMgAXhE6tXrk7zNCJjfCEU6pW7fEGJxydlrDhUX4MoaFkzftZmiOWf8SABFbJcA0x4pIEkbh9XZ+KQCncdTXqc9WASa+ZxwwESTagDfekd/jHiGVnZWgeHnaxIsMeGfV1Bd2Txo3TkQIvi318hDvAroPibB2YgV4E9uEj1ZctFmlXjjTNbLSp7z/aeFk4GDBONM5dFGx4QUL3ZRxiewHfiQv54e/HSlfVv1kcSb9VE3rX5YBgIVBO3+muhmDCKUR8+A7KA5QulvlH8T6KKTChJxvjdchEPlCw5Pn1dIcS0qSe5U7TimoNP8hf6REgqEJJHK/+HChzuObH5bN1ssdwWTfsYKDY6IQKKVSnzdSwSZ0ebqDVfewxpWlJE3qNqLW6r0K7/0DpvBB7aU2f1IBJYObIL/2C2EJYRLN7QnCRHJFT33ZsGV+ChSR5JJ7ZZDMymK6EkAIYCm3eM6lbcMai
 K3kVZseu
 J1KVHhv8DQUaf2weLbiS7hRptNKmirEOzsh+7wqAAawk5LGEvR6QfB9dTarkVoakgGwgpzTKHOXgVAyP++CTafskHsZsx9X+Fb4pTCijrnc52vdyCTNE8mR8fzxteIa3/6HQV6UOamYWvsapba3pdVMJis/I5PruUtY3Ow10odJs91t07F2mgMvRGIENKWQyDeuCy5e8pqtZ8vGzfnRo34HyvrWz69nFfPfDOw9ikWQWRrJ2Xly5RU87TufLRr8ikHYHErtQze9JJU6t8d/do/YWGaiSKhFIv8/92xP65P6uXLqb9vCYGlcwirK4HFzU4KmdB7USfEqUKCUYImLLJ160c3cjjDyQawXVnSqWFwHJcEMpJqosb4jJDjia7OXO3vL8mPZ/ZgS4Y/lS8hJDaz9lQ5M/tYQzAL76jGi7Wlw1m3lxzJ9gOV8TQvXushS6vqHBdVp1fwmX6h8wUUwZbSiDI3Nt1EgZfyWJa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
with for_each_process() loop in mm/memory-failure.c with
for_each_process_rculock(), which scopes the RCU read lock to the
loop body via scoped_guard(rcu).

In collect_procs_file(), the page_pgoff() call now falls outside the
RCU read-side critical section.  This is safe because page_pgoff()
only reads folio->index and does not traverse any RCU-protected
structures.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Miaohe Lin <linmiaohe@huawei.com>
---
Changes in v2:
  - Rename *_rcu to *_rculock
  - Clarify page_pgoff() safety outside RCU lock (SJ Park)
 mm/memory-failure.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index a8b03e2920ba..7d93deb1f7b3 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -555,8 +555,7 @@ static void collect_procs_anon(const struct folio *folio,
 		return;
 
 	pgoff = page_pgoff(folio, page);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rculock(tsk) {
 		struct vm_area_struct *vma;
 		struct anon_vma_chain *vmac;
 		struct task_struct *t = task_early_kill(tsk, force_early);
@@ -572,7 +571,6 @@ static void collect_procs_anon(const struct folio *folio,
 			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
-	rcu_read_unlock();
 	anon_vma_unlock_read(av);
 }
 
@@ -589,9 +587,8 @@ static void collect_procs_file(const struct folio *folio,
 	pgoff_t pgoff;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
 	pgoff = page_pgoff(folio, page);
-	for_each_process(tsk) {
+	for_each_process_rculock(tsk) {
 		struct task_struct *t = task_early_kill(tsk, force_early);
 		unsigned long addr;
 
@@ -611,7 +608,6 @@ static void collect_procs_file(const struct folio *folio,
 			add_to_kill_anon_file(t, page, vma, to_kill, addr);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 
@@ -635,8 +631,7 @@ static void collect_procs_fsdax(const struct page *page,
 	struct task_struct *tsk;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rculock(tsk) {
 		struct task_struct *t = tsk;
 
 		/*
@@ -653,7 +648,6 @@ static void collect_procs_fsdax(const struct page *page,
 				add_to_kill_fsdax(t, page, vma, to_kill, pgoff);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 #endif /* CONFIG_FS_DAX */
@@ -2288,8 +2282,7 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 	struct address_space *mapping = pfn_space->mapping;
 
 	i_mmap_lock_read(mapping);
-	rcu_read_lock();
-	for_each_process(tsk) {
+	for_each_process_rculock(tsk) {
 		struct task_struct *t = tsk;
 
 		t = task_early_kill(tsk, true);
@@ -2303,7 +2296,6 @@ static void collect_procs_pfn(struct pfn_address_space *pfn_space,
 				add_to_kill_pgoff(t, vma, to_kill, pgoff);
 		}
 	}
-	rcu_read_unlock();
 	i_mmap_unlock_read(mapping);
 }
 
-- 
2.25.1


