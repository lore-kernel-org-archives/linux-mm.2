Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 338A2C982DE
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:24:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33D336B00DB; Mon, 21 Sep 2026 05:24:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 314F76B00F4; Mon, 21 Sep 2026 05:24:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B9F6B00F5; Mon, 21 Sep 2026 05:24:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 00C206B00DB
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:24:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5A3AF1A0611
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:24:47 +0000 (UTC)
X-FDA: 85237234614.26.775AEA4
Received: from mta0.migadu.com (out-55.mta0.migadu.com [91.218.175.55])
	by imf07.hostedemail.com (Postfix) with ESMTP id 4DFDB40006
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:24:45 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FwBQ5bUJ;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789982685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqpOJwIKUh7yqOQ8wwglrTCL4AN5/nSVD501ABr/R5c=;
	b=0wKsHe5U4PFr1iiK++iz6i5p6/Z/fUQI04djeFQSdIQfu/hQX0pRPbFTJeb3hUZEFWeQb/
	VdBPVCy5e2KgqwqvOXk2ZrPsQTeU6J1YOrgfo4sq9NcnfexYhMRHPE7DLqAhIVYA01BTwj
	sVhfpb+7ipUB9v4RrwsAhNoEjbxUPzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789982685;
	b=I/Jiz89qKpKPGqJLqu2lvFx94K/xnygu6X0QNdkn0CCZYK6+dZf5EVDIeNFx1jpK5W5/aE
	8qjQIya3pP1Gj4dA68PbHn63gx+HWhuZjmtbm0aTJlTBEUIOra6D3myDEZ/6ic9uqA2JJl
	ea3WiGMmUweskNbzXSQwEBY9BxBQ0X4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FwBQ5bUJ;
	spf=pass (imf07.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.55 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=0W3ikDRTYv+yUei/a0Mgw/XZMKUGQdz8H5UTyurLOdI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789982684; v=1; x=1790587484;
 b=FwBQ5bUJzvbXiqI9kD+wPhtVGOuCgPk1yXA85jK65Zfk/fS84cAx1DRDcN1z+BQfS6fqe8KG
 lw/9Re1fKjn+4IxvMEqA4ZemhWuaz+d8OSSmQAsLLhLR7o3XAfn8zNE2JCr3l5Y1yomBUVHs4wo
 N6g5GQ1OMsEaArKSb4YSh+Mc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c113fa249d93a37b;
	Mon, 21 Sep 2026 09:24:43 +0000
X-Mizu-Trace-ID: c113fa249d93a37b
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Tony Luck <tony.luck@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	x86@kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Jann Horn <jannh@google.com>,
	Jan Kara <jack@suse.cz>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Ye Liu <liuye@kylinos.cn>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	peterz@infradead.org,
	paulmck@kernel.org,
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
Subject: [PATCH v4 13/15] fs: convert process/thread iterators to for_each_*_rculock
Date: Mon, 21 Sep 2026 17:20:59 +0800
Message-Id: <20260921092101.89285-14-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4DFDB40006
X-Stat-Signature: 51eyb463u4akrb6is1onk16q1jxqqg4s
X-Rspam-User: 
X-HE-Tag: 1789982685-527272
X-HE-Meta: U2FsdGVkX1+aUr7KXInzF4Kc0TS4/t7R4s3opXeedQi8WE2zCDtJzJ86ueqetm2hvyXbRFfX0mTKKvq5t8brHKxOlkLZtiepSJ2S7qYbXdkfjqNpistvNQa3JmVX9tYPGGuuIWgC4QZew45OnuIYVE+ImDNEq6gv3F1rgkAZlEGelYXR3pgWTgvgM/52nYVYoxfQvTAfQo4llCYTBhgt+gujPC2/rskQWMuvCLu3kETdHgtWi4C8Ye8NxmYi6QtMzOAWeHc15A++WlmK8wl+2vIKBr0JQsBaz8XYLEN9iDkMdDNF/h6Gb0ZdTPvpfBEqFUYWHwLe436RKKTukD/T3tQg1cIufbv4Ic+tjVt7kD/gf9EcSBzFP0jtcHrc4TlaeN1qwkcLNxpD9c6cwZJj4LzT0Z/PJ9PofKmGUMx5jDrvr5+eYtTOsWkWAiVrtT9jHrwh3R+8XsvShrZ4wzd0FVOAuajdLJEDnQQ5gRPNcc0wgsSZm/3NY4+1oPAq4I46E0KshUrlKYaTiuJv5YwfKFY81y2w2cYqaCS0k6P5c6VIMezeFIN1OWAheO/7KeipkpHu66wTtyyWVzW4YApvulIqpPtljXsmpI8bOH06ojeQWlmRg73hGcCvYfzu2r5g40Pq3c8hSA8PDTS2ZCxW9shl9TRicmQ4HCizHLXgv/SqvfldCfFhjC3wmFtoc3FXjFLvqOoNi1/rcZB2j6jlN3VlewBWtWk3sATPVHssYkRJgyga9S0JNggyyCyrQjrt7WRKw4SB/w8w6f2J7xaNfYfEzItaknjG1Z/3RWgaRghUAcBW/PJEhmICzAi3xdsJm6MOqhXb5pSunQIPJ+EoH/mSJ/R/aUVsvsV+/JacNHpIjHcZA6fw3VS2nfY/d5BPb59Uw9/u70+3WkCluxq6oT81FG4UuzdXp5ybwkZ7xwiX7EcjK1O892NjUl1HxSaUVILcdTzD8u71nBodNLa
 y5XrabFn
 KhwnN0+yAxfmerYE2iPVtXGm5IrxGAKdVJB2AAQyh3BH+UEH436RXcLV8FKdxRRiaIyAZwIjwbjB2LqkC54GZIumFHld70oZClssLcgZlq5do9E4Tm0yTTQl0qmZW30DF6RuiqCf7YX+zTIk3azV9nxa6AXJJUfs/coxqZKdGiblbFiBXlG9a1oDvy0WPGVfTxQMsnhZVstJmjhxODOekcoPj6Oo7YXgw7u7ziGGfVKosHw+ccy4WUf9LVP8lzqY89BxZahKpYMrwGjno2Xmd7FKwtdVqMN0h56XakvfM9EfxvQtclcd+Ofu69n6GQy9psCVOYPdylhEN+zTf3QnV+JJHp5CU5S5eL/L2tYMeaFz620ADAujTVKrIJOZ9wAHqQByIJR9ph6RoUhD4rxWBLMyz1KHzmRccst28lHNrGJ4poqtwdmLMN7DowM9LvE7Vb7CT0oOUJjNi4i+JkdH+po9hFKTXzLeWIvtABYUQj0jbps0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pairs combined
with for_each_process() and for_each_process_thread() loops in fs/
with the for_each_*_rculock() macros, which scope the RCU read lock
to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/proc/base.c        | 4 +---
 fs/resctrl/rdtgroup.c | 8 ++------
 2 files changed, 3 insertions(+), 9 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6a39de424f62..3de4f4557e4c 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1160,8 +1160,7 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 	if (mm) {
 		struct task_struct *p;
 
-		rcu_read_lock();
-		for_each_process(p) {
+		for_each_process_rculock(p) {
 			if (same_thread_group(task, p))
 				continue;
 
@@ -1177,7 +1176,6 @@ static int __set_oom_adj(struct file *file, int oom_adj, bool legacy)
 			}
 			task_unlock(p);
 		}
-		rcu_read_unlock();
 		mmdrop(mm);
 	}
 err_unlock:
diff --git a/fs/resctrl/rdtgroup.c b/fs/resctrl/rdtgroup.c
index 5dcbb0a964e8..b14df8b23f1a 100644
--- a/fs/resctrl/rdtgroup.c
+++ b/fs/resctrl/rdtgroup.c
@@ -709,14 +709,12 @@ int rdtgroup_tasks_assigned(struct rdtgroup *r)
 
 	lockdep_assert_held(&rdtgroup_mutex);
 
-	rcu_read_lock();
-	for_each_process_thread(p, t) {
+	for_each_process_thread_rculock(p, t) {
 		if (is_closid_match(t, r) || is_rmid_match(t, r)) {
 			ret = 1;
 			break;
 		}
 	}
-	rcu_read_unlock();
 
 	return ret;
 }
@@ -826,15 +824,13 @@ static void show_rdt_tasks(struct rdtgroup *r, struct seq_file *s)
 	struct task_struct *p, *t;
 	pid_t pid;
 
-	rcu_read_lock();
-	for_each_process_thread(p, t) {
+	for_each_process_thread_rculock(p, t) {
 		if (is_closid_match(t, r) || is_rmid_match(t, r)) {
 			pid = task_pid_vnr(t);
 			if (pid)
 				seq_printf(s, "%d\n", pid);
 		}
 	}
-	rcu_read_unlock();
 }
 
 static int rdtgroup_tasks_show(struct kernfs_open_file *of,
-- 
2.25.1


