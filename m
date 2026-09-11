Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 572FEC79FA1
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 08:02:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 58C546B00B5; Fri, 11 Sep 2026 04:02:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 564966B00B6; Fri, 11 Sep 2026 04:02:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47BB56B00B7; Fri, 11 Sep 2026 04:02:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 25D116B00B5
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 04:02:47 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4A8AA3627
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:02:46 +0000 (UTC)
X-FDA: 85200739932.26.6491487
Received: from mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf08.hostedemail.com (Postfix) with ESMTP id 96A4E160003
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 08:02:44 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IrxlTkHG;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789113764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOC6bX6/ATtZVMmZ2wiVhIaR0AABJBldd9UGQyDn+gU=;
	b=VKNb60bhjF5qqAOx/DcMW3s2G55ONVKvJsTF9PPL7/l/TDX7Yprnm5XtiyFxcaTc0t+bq/
	S/mcPi26NBL7VfQxa9UsOnD5PwOKxXbKIHh3dITmo6yyz0juTiRVB1XQKhGRRqRWdCtaiN
	3liQpbx4lUFesMFzZeqzUpQFyT6yIdM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789113764;
	b=2r1ptNfWpFVZ3kb51Vd8jk+gBq8pCa8jRCjUMsmhAjhJxYYF6z4IwJOeYit2MRxes8Nugr
	Sf6aa8VT+lRfqzVV8YLqaLsQ7NialF605atHPp7zqBgJplg+w/0OS0CJo7a/DBhBF8agTe
	ugpE4sLy/cYjYqT1AOZ8QTknoyZHt/I=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=IrxlTkHG;
	spf=pass (imf08.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=gyEXa0FlQB4fnI8+b4wbMTxt20ejFsCIXyGvnAfz3fw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789113763; v=1; x=1789718563;
 b=IrxlTkHGp3cBFICxJ74x8FHozgFM9E1bm69zaff8sloIkZpR2vWsfVUpIM26W7FvO9CzmmP6
 7bBPeobXxt/R4zkdHt0oBw22fzO7d5vJreo/2QYwar1FhOQ0GppcCZ+WZ+879JKaHVK3SQ/f6cD
 s0sH5Okj4GHAVuaqATj1rfIQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id fec14dc499d20683;
	Fri, 11 Sep 2026 08:02:42 +0000
X-Mizu-Trace-ID: fec14dc499d20683
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Justin Suess <utilityemal77@gmail.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
	Gregory Price <gourry@gourry.net>,
	SJ Park <sj@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	mhocko@suse.com,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	oleg@redhat.com,
	tglx@kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
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
Subject: [PATCH v3 15/15] security/landlock: convert thread iterator to for_each_thread_rculock
Date: Fri, 11 Sep 2026 15:58:00 +0800
Message-Id: <20260911075800.491472-16-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260911075800.491472-1-ye.liu@linux.dev>
References: <20260911075800.491472-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 96A4E160003
X-Stat-Signature: ms1qsgwzds81kpoc3dejktjc381p5n8j
X-Rspam-User: 
X-HE-Tag: 1789113764-775469
X-HE-Meta: U2FsdGVkX18Fhp+4jeA7VOEYBEsDq3WQxyQ+dQyxkRy7XZTijk+u21Qxa+ysCysjcv1MBMhh/7/hvskHvEPzmx8d5VxNBIa053KXxGKhU2xAIW2jwBehAywMzzmRAR7n4ZwcY0tWX4BRgmqz90FUzhRiO5ReadxCgJ7dJOfDYbydS8FRkPEWRoyrSvbYBFQcHmx6mQefUhsuKGheixhCOLJg09VZWsIWpxlb9+MeoadLpvXA8Cd/pYwaqy0GAPXyInL/fFZZ3pDItiE1PED86pxVB3xg3RYmn1fHpCM3e5SWQzAtLaHkxbGQTyDGOTSiT/1PEgbdgtIKxSu9Kq95rzX28aKVtg1nIlvotlLhg4Fb2xyk2oIyNjtULiBRfEfuEeQ/DANerLgFRBwq652mL2hsHpITezxRmmjFiaCjfycXNEv4B3kLc5PmFFgwHK8S+lLFIhU8+svU8Hz/Jv542H6k0D7zLlHKRAKfMD8k+1Pky07aYl730zHG0z7tIQBq2gpX+mwU1BZOPYn7LyVB7LUQGCV0Y4xGghYfk5bTPTsnwONAuMlvBXqvzauBlkWrQmkEfpNuRy6FDNPdzCgyiLeIoi5foOwyW/ZL8IYJbp0STR9Y3mj/A5CVfb5m253XTI2/8XAKRbJHf3JrWc8weVQcEgdu1HXEgAKy2nK7q9hryF5RdMiRzKOBSO+38oZPvmoVBWX8dvoVeSIsQRZS5sYQDIra8FFsNJUTjME2E2udS/tDe2KpGjBbp6YkokwZJmKTkXhFa8PE0riPsuZegNKgThaYeT+bJa4nYa0bQ7VB3fNXSDduPsuFhZvwv0zFPO2CbYAfFjgvzEpqzeXo/YZq9Lvl40Oe/bAJb9ntEa1F/bAC9IKs4EgtzwltCsiJyHlFGl2OGRL+gH8qcFZ2ruaMm1G4OKabyjifxu1jPERnwDNj0vfq1iDR8h6IYDAmcKKAbI7NeaLyJUAtsr9
 5o+qwhmv
 66xlLvwniMCL4EcpBmryHgv0sJuzAp56IKRDeqj0UAAY9CQ5v1aWTARm75Mtiq8JpwU7OvqYwp/hQXRZ2LM5dWj/WWMH28BVtbhthqwU2WQ5hTUreOTST/+3vJR0CaTe9oCIPh8rI2WzH7WlO5R/U6WVlzDp+Ipl5DjzmIqPl45IfWGHvG1GV+tnG2QbsWf/6d1ZC6xuHbbLQl2moiDNeWq/eozywvbMXOn1L8fjGJ3/SfrZz4pqNkReT/ob6COqRfjFy0AF+9UvJgmpCK9OmITMZURbB2oPBgxbNN/gUMkmxVulJ3yxgEE8pFtCGszN4xrrlh2aKDp39RN2e0GULj1O0MGeaenyC0/gHD7u4epfNOQoWlGiubtPenPneS8gjyf0b5rcPiDmdWqruE8DZvl+Q+9pd6PABV6J1n6ujPahSIStS/j8Z8pnogtk9RPE3NfVx9PR/98B5PCsKYM+Ggt4CNrETll8LwjKxDEbWh77q5s4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace guard(rcu)() + for_each_thread() with for_each_thread_rculock(),
which scopes the RCU read lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Reviewed-by: Justin Suess <utilityemal77@gmail.com>
Reviewed-by: Günther Noack <gnoack3000@gmail.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: SJ Park <sj@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Changes in v2:
  - Rename *_rcu to *_rculock
 security/landlock/tsync.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/security/landlock/tsync.c b/security/landlock/tsync.c
index 0b71e158c3f5..a578af640aad 100644
--- a/security/landlock/tsync.c
+++ b/security/landlock/tsync.c
@@ -335,9 +335,7 @@ static size_t count_additional_threads(const struct tsync_works *works)
 
 	caller = current;
 
-	guard(rcu)();
-
-	for_each_thread(caller, thread) {
+	for_each_thread_rculock(caller, thread) {
 		/* Skip current, since it is initiating the sync. */
 		if (thread == caller)
 			continue;
@@ -376,9 +374,7 @@ static bool schedule_task_work(struct tsync_works *works,
 
 	caller = current;
 
-	guard(rcu)();
-
-	for_each_thread(caller, thread) {
+	for_each_thread_rculock(caller, thread) {
 		/* Skip current, since it is initiating the sync. */
 		if (thread == caller)
 			continue;
-- 
2.25.1


