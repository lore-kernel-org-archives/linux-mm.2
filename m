Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E72BFC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 09:33:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC0DA6B00E2; Mon, 21 Sep 2026 05:33:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E714C6B00E5; Mon, 21 Sep 2026 05:33:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5FA06B00E7; Mon, 21 Sep 2026 05:33:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B64996B00E2
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 05:33:54 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 156C5A05CA
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:33:54 +0000 (UTC)
X-FDA: 85237257588.15.B166E0B
Received: from mta1.migadu.com (out-184.mta1.migadu.com [95.215.58.184])
	by imf05.hostedemail.com (Postfix) with ESMTP id E225B100002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 09:33:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FEhrKxGt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=FEhrKxGt;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf05.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.184 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789983232;
	b=qqyAQzxyabzKMoCYsBCIlFmOmpAcOic+vK6hs2PaxfGSKdv6KzudRs7lfbQDi00hCNo/DH
	D9FI+Eu8ew2RDDFG4P3L+zN1rn40HvABP+pRWE6BND2NARThSoBZEKjJW9ZgBfs4D6QllQ
	cFJ+gdsgbEn2UUaolxezC5aStj0XPmE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789983232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AHpcnqc/vjgH3JF/0gzT9EFKxkNLdxrOdoHrqjbxIJw=;
	b=fJ2RiPbKV5PndZ2VrvL2IaGbt3oxut6jG+ch9iJX2CvLEMmOwws7p2vGbt4BvKP6Gko3H3
	MXVABYljvseo/sfVW0pkEsc7nIvJMus4gSKZ3dSscdb/cohDFKHx65Whe1LFvBoIIxnc+i
	1Ane1g0jazRfWthc37wBrIGI8TLae6Y=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=EYCPbF4GXVvVmlhwTlUPGyo1CDrWSEx3JYzEGtOW8IA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789983230; v=1; x=1790588030;
 b=FEhrKxGt9s7lgZ8WqPH7VDOpF9udhJxQW05bDn7s2BKy9QTjk71eT9cayi63uddxNYwj6pZi
 5K7kE42mv1lqv4JNC/vhgbvMckfm+eqadNwsvuctYY/1cp0g3ALobxhSCCSOuCV6dsZP5DUu63i
 1S/f/93BjKz+hEZFsUypIk+I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5246bf0a6504571f;
	Mon, 21 Sep 2026 09:33:50 +0000
X-Mizu-Trace-ID: 5246bf0a6504571f
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
	akpm@linux-foundation.org,
	mhocko@suse.com,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
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
Subject: [PATCH v4 15/15] security/landlock: convert thread iterator to for_each_thread_rculock
Date: Mon, 21 Sep 2026 17:33:33 +0800
Message-Id: <20260921093334.105291-1-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260921092101.89285-1-ye.liu@linux.dev>
References: <20260921092101.89285-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: E225B100002
X-Stat-Signature: tw4aanjmowyfefjapicehryfc7px9ztr
X-Rspamd-Server: rspam01
X-HE-Tag: 1789983231-280708
X-HE-Meta: U2FsdGVkX1+WprOFuL0+k7/9PwCVgj20x24SBb03FK2eT43h8W5fLbK9EKaTgTHCVK28CvVrzIUtRZgiU5WikPNft/MC5m460sFGFX9Lcy2ARz0an17quvHG2sq5r//b5Q5s9LHXSi987+10f8GIbtm8+Z524uxD9K5fMhMrOOSjTUfyDJHlcy1/LjCEXwx90ZAvsBXeDz8KrmBXT6iyn7ggu3Gslyr8LqpaUi1fdQE/4nlhB9oqirP0RUWr7chZYResL7NdqryAgWreq0VmDWQVqOu9GnP4oZA5FxDYclTNxoBb/uMLdZqn28MQN1FP6BfvQp76n/0ZgvYVdTAgNnxB7T32+J17df3L1jBDs5Q0jk4d326sdjc/4KeiRG+lsS9f4CAAEGU5+FyFbPRM+ZufaY7oD+yYmork1F1M1SQxkXQt0/P7mXazpRPLDwHPUqHVbxc9LgiuoTDkTIDG5Halox2hsoLZIYf2thwK0ktOLsYm0IHKVzY8NJjfVQ9xc/2v3vNzTU1mQedUP62WWPvqK7Ile70dB+OZUZTkFt4Kj7vAbZPWfbgGa5Hg1mElAUAN1LxnrIXZGsoKNmDlgxCcvbyJatA04cN0vYuP5hgI92lpKmDGGhqsqPRz1u1/YMdtsZV7FPFfQrOt38Mrk2UjNQjN/b5AZUgAIOBSZwqllU0jMq77AKw+Z5boX+PsoRKQvl93roApULvjFvKYV4Y0PZnxnxxdJdD6XMbYOoUSH2PTTeckmMOxRY73vT8jfKKPXgKd8/F8xkrojMrSGQWPXoogNpRjkVA562syK32iEAD+m/uEom4/omAqlNVi0VU49MD5TVeIR8bJ7cMhPCJN8iDISp1ioTZrU+ZpOAPi9SvFDSpxCZy8xpfVj9Ah/ZHRO7wmNQwteLAl3T7G0ZL7V96DfPcoql9pCh1lUsmcHnsBi4Cm1A/cpy504j4vFnOItZPP+egxNtjFdrq
 mELf33Ux
 0wLlLF1JnQZf7TDsupdq59S02nO0xTWOD9YwN8iuyF36RwW6N6N9Y5ezPaqyFYJu16OzZU7Ouf8hFiV9ynmV3bBOajd2P3I3mMxlfiRLZ7Ac0Egzs8jZ0xooo1GYxCfxZHnK/30zklMqqiEfGgVLCS+iirsT1qqzf/P/ZA9dJqihu/Gl6MC+rUZQGvV1pFTL3eyasy3zaN7ZjjlUzEXhd72I1yfn+aqOwnFjPAMmnWQfI1+qhaUe/t931+1pCBLQR3++O4J0YwvS8W4kgVsZR9Gmj55fY/HTQeVOVauRA1qGL7xveQvF8IXX3NZcH/uf63l3R/CsDimC7gq0f0kjBRHmPlnED7rL8I2rbCz890g++ZuijYvxWBOcF66oG+BeoMx6P/G3FAj4fEHXW1gPyB055uSlb2e3zOxp7hgdCn7tcfwL9pBdKA+5MN6qYsYTKDeOFHer4NTltUYbkefbHbiFDdl8RDs5UHzriKCns5590Lf4=
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


