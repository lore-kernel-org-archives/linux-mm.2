Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7F2AC88E4C
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:00:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0598C6B00A0; Fri, 11 Sep 2026 04:00:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 031536B00A1; Fri, 11 Sep 2026 04:00:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E61E26B00A2; Fri, 11 Sep 2026 04:00:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C76086B00A0
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:00:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 183D140123
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:00:44 +0000 (UTC)
X-FDA: 85200734808.24.CD2CB38
Received: from mta0.migadu.com (out-71.mta0.migadu.com [91.218.175.71])
	by imf20.hostedemail.com (Postfix) with ESMTP id 325401C0006
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:00:41 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h+UYEGLu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=h+UYEGLu;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.71 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113642;
	b=ro4c4IEJ9xSGyMZr5S/Nny95rchdJ+5gi1BcNnoS0Ons86XwFT/ezo44zgRllWMToCIkcQ
	4DZsj5wHcXnpSD28QFofOWjtSl2swIHq//ndzCxyZ41lpFD4W8izKXgEwy2QCdz4SXr7bp
	SVpfNE08gR8slUFrtwGOajHZlGIS4vk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l58v/uQETMqDnq6+aHssXuzvcY2G0WLDBGmF5YRDo7Y=;
	b=hHfUXX8bv4+PaVvQ8JPC8NaPezXYmhRCu6smOzv//VopY9mz8YC52NarqyRTGNnkfXZHp5
	HCaG0abv7e/87xTWLERXbxBD9aob5JZsLEgzdgF7yq8TPPj+FUvO4tphCc0naDyffS6J3w
	2aGRwW1MXIscH22CSvTOG2lDaOB4R4g=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=MtMBUy3cqPkSQ7l9jm2rwShEJTacHCBGS65FBTs1ICA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113640; v=1; x=1789718440;
 b=h+UYEGLu+JS6dSQAwygoKqN/w8blqIv7PNIoSYGhCFG+DyDpdRJmlZ6n/Pn6/3piqWH0gLJO
 tch7S15FW7DY/CF1ayzqIWxfIRwjpg6QP6XW5ce00zQBsg3PqGXqGUTIr+3NXK/kd0Lz7lxX5N9
 l5EUO+smI4QrwoNDexUqD9h4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8a1a8142b4b29e09;
	Fri, 11 Sep 2026 08:00:40 +0000
X-Mizu-Trace-ID: 8a1a8142b4b29e09
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	paulmck@kernel.org,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
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
Subject: [PATCH v3 08/15] locking/lockdep: convert process/thread iterators to for_each_*_rculock
Date: Fri, 11 Sep 2026 15:57:53 +0800
Message-Id: <20260911075800.491472-9-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 325401C0006
X-Stat-Signature: f83nyswoypia5tjmirk6z35737uq9cto
X-Rspamd-Server: rspam01
X-HE-Tag: 1789113641-81666
X-HE-Meta: U2FsdGVkX1+/nAEd2kqdMGq+EsQT67aQPusMcAUef/53SVvueSl2Zs3Pn3syan3OhHJdlbq8GkNqzgTzYGiiUTtP/kCgiu7VBqtXSU+0LttBP9gw7UkVYdrzSm4LdkRUn0/DtsID4/EPHiyqAwKI53Pmr06TLS1hyp9TdlayYxAPur7C12q0QSzATtTdDtFG337PRV9hX7G8Vd+zhP8BSvUP4MoRCSjkVKPR0/Z4tmjySy5jTc+q1eWDOvzLeA16sn+CNtOR+4HCMsDPUGYFwaxIjEgBVBb5chv6QwOYhS1LBKQbXYE+yw/Yo1elDYyqLCIJrQLUkD9AxH6X2upc7t3+Vzr8GvPjJDD1/JvbYddZIDHlWPmdA3vfkpZzaN63egdFFomYwl4mEwg1VD6Er9Y0ps+tBxTNXD26lythFkEjpPAvbmeygtAMa8xFk+cXYbSpEkvAIzvZA34++s6YLsqHTtq5t6mbwNxhsDeSrON/2d17fHbgNUyikYnB07xHPLexgM5fFiYqlmi8a7axnnlWT8SJ9ZEHE0RJaXX1aUadTNT/cabZaMJ1REyaqVgsdzWD7dwpjqLJVh39YhizbypMnDroHAHH5R+CGx1BYPgYwRwUsgZ3sdPBxCEKk+Fl9cgq0V8oHOZGqbrHtwE6/IvJe5jfkveEclpMoHpnkV4pO+hYgzi/BzNIGpMraAMoR4igOasHB0xRXGE1t5sZSxHyQra+PPnRZ9SFW/NGSMPE27AWPGX4roLbe4PQAshd9w4F7YcxTsmidI8ZhWrXC0tQh5yjbWnuhsO9bERhVJWES55t5YNatDLrJ4ryr0ScKZlolSROMWbOwBGwbEu+RgfoBuMOyxTMjPeJivnOq9Ltxbokas5juWPgkQ1J1QJHyjpkEVNN131sw0uoQJzGZeTGmij/o4sfEf9AbbF2YClv6AHnjvHmYVFMnTxD8C77u+Gb/QJNoWi5YspBs9O
 e2jOQRdI
 LBroxKuy2LpBMpV7NrZeHygNN8I9G4p8Vu/3fIhVehAHKh/1u91iwCwqb8RmUBdlMpftR447R5wXAi3gVYDaS0y4Lzdth6DwTigNVbOPq+fnIJWVMLV8IqPS5wNhKUXYPvXxe03+c9NYqyJZJAXfYzzEMuCP3z+Qj858udA5N74W/rS9soWMJ5xSDIr1pS+tdsKWfrB3TYTSx9BNToDh1Ej3HVy/k5NSRTIUo+zM4nAmXQsqizhOqIctHtg/Iwc3EOAfXHW4KljPzYbqDRE/o1ROTPpboplZJoMDMee5Wzkh/2XOUX5ZzGXWd+sD4a0+htHuSdhxGjqJhgVoNjblEHylgjlCBiJIncTDYOewTCjHAd6xllGQ77o3wxdKH+e9d7WDZPhaNVQERViW8zIFSb39kwGANZkzc+NOVi75RpdEafGHLVXsIRUXmUiYRAoGDEyJ4/xK06Ux6wtI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process_thread() loop in kernel/locking/lockdep.c with
for_each_process_thread_rculock(), which scopes the RCU read lock
to the loop body via scoped_guard(rcu).

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
 kernel/locking/lockdep.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index c56a7f91d72e..ea218dc75ad5 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6834,15 +6834,13 @@ void debug_show_all_locks(void)
 	}
 	pr_warn("\nShowing all locks held in the system:\n");
 
-	rcu_read_lock();
-	for_each_process_thread(g, p) {
+	for_each_process_thread_rculock(g, p) {
 		if (!p->lockdep_depth)
 			continue;
 		lockdep_print_held_locks(p);
 		touch_nmi_watchdog();
 		touch_all_softlockup_watchdogs();
 	}
-	rcu_read_unlock();
 
 	pr_warn("\n");
 	pr_warn("=============================================\n\n");
-- 
2.25.1


