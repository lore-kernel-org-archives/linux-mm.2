Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50680C79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:59:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 476956B0099; Fri, 11 Sep 2026 03:59:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4261B6B009B; Fri, 11 Sep 2026 03:59:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C7756B009D; Fri, 11 Sep 2026 03:59:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 082BF6B0099
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:59:23 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5FD044012B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:59:23 +0000 (UTC)
X-FDA: 85200731406.12.D491BFB
Received: from mta0.migadu.com (out-129.mta0.migadu.com [91.218.175.129])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5D5C140002
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:59:21 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KnEcOPqB;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.129 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113561;
	b=MsB9SExgotxA4JxI8uDDO5MwE7hyqHaHR4WwyHgUAg3ISRmOK9Ud6AWCuDDv4UJTad3zr/
	Ds7sgMayBQfYrql4/Sx2bmzym7KaKBWksZIAQ5n+AUXgleIKfnwGa9AFE8R/Y9bJvch2tP
	htdxYqPO+crPYvBkkB8U/3uvyhWoBc8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KnEcOPqB;
	spf=pass (imf17.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.129 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HbpOvj9FZS4TvPtxHclMgiHWQf/DHzeTn8th7zIAETE=;
	b=2snEZVVnnyezC4RpfzKMsOBA2ZuG+s6EHZnu9NwOl12MBkKLsB55Gv7n/UsC3K0Y1c866/
	spqgWsOVF9QFzoVqhs98qAI0Ur7dAf+KohR+RHtJAVqx6ekEFzH7LFtStkpm5j4soqhltZ
	wGo8n9EKJMnv/0Flsvi8CaNDXqgo518=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0l6apGFhEMmIZSU/2v9JnhqbwzgAnZO6eQl/TQrNqjs=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113560; v=1; x=1789718360;
 b=KnEcOPqB29IjWgp5jthU8JbZQa2v3D0SIW/x4p91ktzgWaHzFTJXCLupscoIm3krB/uo/qf4
 CveAx/UMZEtGXjGCoz4L5CzclBGBbpVM2DWgluhxFSSKospT58neG0dvynVp+8ueLx2smALKNmk
 GCEaHPmLpyqorFWiG7XG9oog=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 45b1a7c312529d85;
	Fri, 11 Sep 2026 07:59:19 +0000
X-Mizu-Trace-ID: 45b1a7c312529d85
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
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
Subject: [PATCH v3 04/15] mm/memory-failure: convert process iterator to for_each_process_rculock
Date: Fri, 11 Sep 2026 15:57:49 +0800
Message-Id: <20260911075800.491472-5-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5D5C140002
X-Stat-Signature: j6r7cfpkyd7y99dzxgqjfsy6q4oai3uo
X-Rspam-User: 
X-HE-Tag: 1789113561-388478
X-HE-Meta: U2FsdGVkX18CxmZb8vKLQWWdXRM5ffGFef45AluYj9IJi3CBEDKb1AuHbcjwpbMERUvY+QsCOLnFIn9tI8DJ0TlDkN3DH8LBR+uvHHWPabk6yorSMcsuFtdSVripJ/wNVmS+cLrtMcDRTPHy3P2t7wzHk427x5vT9NkMnwPns2TBAAoABM4lxHiEm3KOyPPNiwZ9lmkjgv+2vv2ZK0zACPoaqKSzq1vSXQb0o6lgFdWwjN2wCsX10u7TJZdBWk5N0kbPKLLoWiRr88uqnkhvOzorsx7gIaf4UG2zQLJ0nMVW1BvQ4xcOQueQoO+7fWz+WUjW5HoOd4rBQJT7XGfrjp90vmR1PqX42Ltxf90vaIDh1ZBUz1GzBh5W8Y40fRjif6b+eGfjE5zW4+N777xxUt0N1exSpsSwwMy12+rJ22hjg+hVJUDHPTOyqoHX/WRD1CD0+WI0J84kfjLlyyFDnd3Ba6bCAY4owEthlRzC6UCxdZMewrk/9YSqeJ4Bmm1XT4PEGlhrGEl+F11JjejXQlRvF5Dnidr1OBvGeAr60Re5UtuRaq/UXnU0YCjMhksCH2YBgyP7/cM8+PxhDqGOIPYB8IAW52offaz3zwV3NwuxDz7jeWzX6U3iSMo84WKs3ol2UVaFRUsoiI/0EFfiWGGJLGRUv2vlgKDP9bJ3NzW8xy0OrCy+DsU/XYkqfT3N8Q2V6xtYZl+qGUT+12XP8QtNAcZA1jPxRK73a956FTa9x3c/KISnd79JLBkPm1AYx/hIdR0ZkjTOsL0/R0WDbGdptrdUw/cRar4G/PzK+U3y+/Y+A61YVEG/UmgciFEmpselcrCVP8lVS/kDcdo331d3Ik7qQQ9cuH0ZIBROI/oqjzo8X+Wy0LBVuJPUt9kwm3G60pTJyrp5JQJWd8pwQ7gD2ksKdoTR1RgAahCGQQkP5JtJw8o6Lff3K4hZCSEYpxu5Yt3nizM2m8Ns2nG
 GRjOtKmH
 Kz6RcZmxzZr01ztIH9Fw/iTjAefFOql/7Ie5pGQ7x3Ho3qTOCXgOWqV8Q2cCHAQhQ82RtdwAg4OZ/aX3KzjBdoV2bfHxYcQ2ylXdrmwYjKn84AwrUGi9VWJRanqQaZeasYGOzit/q6RU6G/wR3wSDtIdPtA0s9sQe3u0INmS2nXcatTJUFVygpMzdAR5oV5V2gJ1+pun3nAsdF74WjZBlivP3co2ZLCUf5YmzoFLHRrzwyh7IAwefTaQKVJZVbo5c64CkccfMNw4b6AB+if2KEr8uy4Ys2w2hu+A4E6rGKmbzjF/E6DxnLex0FsV86cnvqXajf+0x3TPT6oy3O8yFmO0ogojVwsOdXrCxLrEzBs0iGDrLU1a/8h5Lui8DFBiz1Y8jDaRLxPHDg5lau4T+Cpg2zrvxXLbg1lKR9O/ALC4Jl3jeq6G82XJdS3vhGv3oIb65QLeb4NoBLt3/w/szuV1B9BgT3jaA9R26EEbBi3vxDu5JdIGwLuekKGiuVWAW6q8Lly5hGefywRFWGS4JMkHGREyWMgVeTQHcnKsvFbOeg7ywm4N9TEUlXw==
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
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
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


