Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7147C88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 07:59:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C996B009B; Fri, 11 Sep 2026 03:59:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE4806B009D; Fri, 11 Sep 2026 03:59:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A57B6B009E; Fri, 11 Sep 2026 03:59:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73BF86B009B
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 03:59:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id C143E140131
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:59:34 +0000 (UTC)
X-FDA: 85200731868.27.30FC67B
Received: from mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf01.hostedemail.com (Postfix) with ESMTP id D9DC540004
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 07:59:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D65qpbOS;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113573;
	b=Z+fI8+k3y5xglYBS5gbVvAMxG7zNOmc3tiZmH6AOCk/MslCL2sDtUOgKNovAp/jKLRoXFr
	zWFT/8ASLOZRNfGZRYSFXS2ATaBmYyeGqJMFA5/yJV4+GvGWhSnkFe6Niv622Qf+RSB4xt
	agqJ9DZFmF1CHVBk4OQuWMuPNfKRoeI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=D65qpbOS;
	spf=pass (imf01.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113573;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0MRWVYLmayFs4zHW2bCBVRRj82VzBA8VgLL+8mfrItQ=;
	b=6DwTVTfCPAbPY6SZeu6SEcV+QxG+TFCVHTG5SuE5lAzr35YHnU8Nwp1SeLFjdSuEKNtCts
	TjmnnFa4zEVzBr7MwWZGi6FapF8bjhRdM6LqpRT69fKEYjm70qsJiTN73lYWlrq/pRmNhc
	nuh5iAwiErzPTaMOs8mPk++Bft8djx8=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=hw2TjBAqEOVWc+zu96DY/c0ZeYo5WpD38F+07ZSfH/w=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113571; v=1; x=1789718371;
 b=D65qpbOSyBxEKN3XOVZrQzcIrNiHdrCIiKIFKQ5w9q6yoj6XymHoRvuxPsguJWTKmV1OwcYo
 3eIfb9i8n2UKi1KwJ/Cd7hNNEHwD83Rzm37VXBKrskmn8DtRRwcfwHYJ0bu+tou4jg4sTTOX4f5
 8yEp4uVIzM4G8Fo7s/ZTfots=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 31e1e1833329852b;
	Fri, 11 Sep 2026 07:59:30 +0000
X-Mizu-Trace-ID: 31e1e1833329852b
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Thomas Gleixner <tglx@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
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
Subject: [PATCH v3 05/15] cpu/hotplug: convert thread iterator to for_each_thread_rculock
Date: Fri, 11 Sep 2026 15:57:50 +0800
Message-Id: <20260911075800.491472-6-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D9DC540004
X-Rspam-User: 
X-Stat-Signature: bepugipprhmzh7jsuc4pseejqnmurbig
X-HE-Tag: 1789113572-260998
X-HE-Meta: U2FsdGVkX19W9i6QLhB+eL+W2pu26mS4EQTru7IpkR617rl7VQa5P4DYjHXpyZQ+gfswqPj9cC5/BcJD2dm1/on3FhaRuEDfSlDrVE1SxFDWIJhCsdohHAPVkzy6HeUa40Dg9pYVtkG5Ibsw5MhdKDK9FwvRcpQBnqPlC5enxygDaX8Fcg7hyHkpKyQ+jray3XutcdsAhDdD/cpzahElCbuS9yj4mv+BS+/wgt6cGqzXn0oubRye2bQZiwB0VW5kBBACn8VN5CVFtZqRUIW+z6g/rZyZEbnPS6bt2KsnoEhDzxoicCBhOlRg7neGhOhZjPYKXjoHoSlkcEsSeOxDMeCD8JJrd1CE2EjXxr2XihKORNto6BmcMV7qI9/ThhWX3HkX6bXjCFASOTMwIDRFpnlW3aMohI2TiOZ4VBtFfNdRzK++jA5C1EnVLpfMrbsYcXFZLOoro6HhvM/YhPRY1QAZNdhhIHUCRhBwm7/C/IE5ax1F/fum0FgRlgUiXH1V5Vs76+FJw5LOPF/KMgeqguLLliudFjkcDzVE1PFzhxvOzkWpOqC0qcpXjjojzcRQHqk+WZksq5+dBAHjEgHRci52GdQt8zoFRcj7nqLcskYMkjyMoJIMeSM0bHWWx2q+NTS67MTQuRjZzk4D9BUNHsv6x40ZdzKgNl+U4bpOaXSksCczKjUNmskREGoPS/0E94Di7oyeuONgLPlviJHkurP5nf8g3z2asaq8QngRD7SbYq77Vsz4rUsZ0yWjnLltJI+idtxMcfz6XimQX/Msruq89YDGbJKfhWZFJhwxa3gV2l5H1JNU58hzu7yHj2kVW/ciJmd8cJ98zkDfElWiDKO+GEVO8PpEJrT5L3pFjSOlaA+tP5MolUA2sTivN+kxbhWac4hXH1MLalJaVE7l7nk5eyCyj1Go6+sri1POXwIkSxVsrbsItYOwL3/6Yb5ElVIhrwL+nnO9A5qG25I
 nvR+YO/Y
 GotMd8MeacM9mj7A90Xb40v/Q46CUfuZD62Vqw/pFlZOo2LylbhdxIzjGTAYC7iQgvebtZvawH5ehbtbzzb4j8WKKCSiT2prG9MDz08PS+CEfbKa/wK67uCBXl0g0hxqGQ+jNh5Lk4uunsdiQJ9FZASfwInFg04tggmsq60ShwU7srrf8xXmEbXlcSjdeeF5fCGz20Ra5Ipjoqaiwk9wDdtP/liMLsWf6XajDYMmdR4fn6oiJ/N7+PaJw8c+VmxFRqsZx4N3ZB9ICcdXtJLduIpAaHfNGABM13AX3DE1ou1vlAktLZCku9pjgykwRlO078SO6Zn1h4OoQF7hPOj72ew3HMKukMtA0A/T+XZ4R0t3HC9M5FiqeEUNy1HVSx1kv5yj9zwZhGjmo3RjHQpyuVllOtZ8sJh497+Ipej4mp97r9L3qFtI+g0NZNLD9zBg1NTI94Lcd67XoiJo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_thread() loop in kernel/cpu.c with for_each_thread_rculock(),
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
 kernel/cpu.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index b3c8553d7bd6..00638d2abc0f 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1254,8 +1254,7 @@ void clear_tasks_mm_cpumask(int cpu)
 	 * full-fledged tasklist_lock.
 	 */
 	WARN_ON(cpu_online(cpu));
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rculock(p) {
 		struct task_struct *t;
 
 		/*
@@ -1268,7 +1267,6 @@ void clear_tasks_mm_cpumask(int cpu)
 		arch_clear_mm_cpumask_cpu(cpu, t->mm);
 		task_unlock(t);
 	}
-	rcu_read_unlock();
 }
 
 /* Take this CPU down. */
-- 
2.25.1


