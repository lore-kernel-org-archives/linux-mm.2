Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B8EBEC79F9E
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:15:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91A196B00AB; Mon,  7 Sep 2026 04:15:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8CA646B00AC; Mon,  7 Sep 2026 04:15:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7926D6B00AD; Mon,  7 Sep 2026 04:15:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5A11A6B00AB
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:15:46 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E2B6C160707
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:15:45 +0000 (UTC)
X-FDA: 85186257450.12.A878382
Received: from mta0.migadu.com (out-168.mta0.migadu.com [91.218.175.168])
	by imf23.hostedemail.com (Postfix) with ESMTP id E50D5140008
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:15:43 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Mr/dbA1s";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.168 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768944;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=coueAuHk1PZX4Mhu0iIY5Vl92296KF6DF8+4CmI1te8=;
	b=y7+2MqCfxTaUZf0AbvXJpfQEoOWKUeO421v606U7x/wRTTCYD6JY4r62XNa8+o4piGeX9X
	aphZ4VS9lIU+Tija8GTNSLzTMqRsUU1qxCXMZXxqnc5ov1L5NRxa1oQiGY7SMcUJXRIuQn
	Yv/5mOsG1UV2ckenayFXWx2CGpExgdo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768944;
	b=DMZCmolufSscbO3+Z8FIH9rYt0nkBlMyZmfuCNKgBch1rNsuvOU/Y/8GJkwAM/2XOebG/d
	yd8wFyBrkXnMdI7eMyQZPpTxMKr9Kz+FaJBdFYOnhLTOMUC1JnwpNMZ7+jTBhtVxJm7fQ5
	KvsPSwo861FLFKiJHzkTBG5p/C2qsmU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Mr/dbA1s";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf23.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.168 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=QPbA87RHE+w44sKh8YFv32hrfoolvz7WuKZeL9giD2c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768942; v=1; x=1789373742;
 b=Mr/dbA1ssVgGNGSkx9NfcW/TeNr3X7ajPN5WChcRkivApREW2EP1xWiVFInVPhm1sPWsjB3w
 SxfFgpedO4Vr5GcEhpleqAbVMPYg4DPql6i5nm/5ONajnHrM7ZQZwILXWB5BliGboSUnHA1OFdC
 Jb0/0QoO2QZhUW+sgHTDxF68=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6d517d0bf0f3bdbe;
	Mon, 07 Sep 2026 08:15:41 +0000
X-Mizu-Trace-ID: 6d517d0bf0f3bdbe
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: =?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?= <mic@digikod.net>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>
Cc: Ye Liu <liuye@kylinos.cn>,
	Justin Suess <utilityemal77@gmail.com>,
	=?UTF-8?q?G=C3=BCnther=20Noack?= <gnoack3000@gmail.com>,
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
Subject: [PATCH v2 8/8] security/landlock: convert thread iterator to for_each_thread_rculock
Date: Mon,  7 Sep 2026 16:13:34 +0800
Message-Id: <20260907081334.1152889-9-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E50D5140008
X-Stat-Signature: sxwbep78zogg3iuoiegrosi6wq86oosb
X-Rspam-User: 
X-HE-Tag: 1788768943-332070
X-HE-Meta: U2FsdGVkX18xGXey06zjSSaTUHet0/Bc7EP0MNIxMoe/wmfjfuHHV82WQiqPb9mbFe1wBwaPTfp7GyR53UT1SgoPPT2Mi1p5BuQY3QIkX4fqlhAT9HYlV7NLPBuQGDTb/CvRmbhxN5RiILD8cRr8dPB5iDvqCYyLn9SWc+0WjxzfW8o/L+N9BeDcYfwlWbOSLqvlzaIKyEO2ytqmTG+nzgzGr52a1zUTibmOuOPyxBQkKT8Xx9DMekXMVcgXFwe0q4bkgWB4Zwfn5abAL+ip3xSEZIRQK7imTh8IjBFaBwPb6pQ8tz4gZWJSmYAubxj3XUUdzx0mWMQr/viofd1kwkn+8Rtlz4bYilU2kbQIe5H9BfjYgl0D/wMn138c/PshoPRzcPvyr5NixVOcD9rroPWZp/OMmAzBkLoNVRucHQcOhwTv7uNnzep5vR3JHIlngOaEoEVpsA/UvDCw16e7Xv9nsnEhZJ64Vv1L5lWhgSjLYPbkRjlPAqCmmY8C82NVbvQwSudYMdDDj2KKVZIIKv0dJPznJ5Tnq/lnJm1PnLO28jKB3Kh8hUu0KMYGvWxFv/M4tG565SBdBH4Ks23n7Si5LOmkLRffDztHuyrM484oUIgfYm/F5mXRn3SrsoHs0bwYLo8V6EEd+yOm63VHikXVOEQnegFmM0KYs8iuq8/hZgUQPiZvXx7C6dJ7RyjCyXvorYtyeXpS0ePT8AtIH5dlb3P2oEy75NUVPasj+UzFM+eXggnFh/P0eIQDEIsdDrpRKbB22GOMDg9FQIFjqOI2TIsX7SN6JSX0++Jv7d9aeUBBB/Q7Ww4Oi373d1xwfaT698MscW8bdEqf0NzQk51MCBrOkMP32jqHymxkrVdz/Dxfe/HRMQLv44l8kQ4A5pXWXUsmbiwjZBPdYOlMEZrpqhSf2+5q4z1wMvCtP0RRvUlMKSjKGhFmCc1lLxLi9+tszmRVO2JmWPXUUb+
 DoBjDXOd
 +QFRok8Y8v7khrwjF0xEhptxvl5C5dTMwIUpUwKBgYku5Jdjf0miPpLpoNca4xeGodPRinZrAHyG1eeSDH03P6+dE4RJ32ZnZ9WMsRhspx3duCzWxwEi6o844EMDA8nyTCFeVHD2V6NKukwLFfd+DBRJUDRIZm9q6+y/2jEwjYoEb5I0EkbnHyPBl355Q3bde9yuzy/SNH6BstFxFS1TIj26/qWx6w5anq9virBRlyHjRz9gVyPJj1ciB2eiQhFD2D/bZ87r0Kwp5Lf/siFOSFNpbRCH4QWeMF5ZKEN0bfY/86jbuHrUKt6h3lFjilS8smdALtbNwwUAAutkbseSMUryfF34bv2KjqvtLG2XIJYwNzzUaBYBQvwGC25xFvop+sDpK7wcALgD29mDznOYNm1dtB5LYHXUt6pMQj2wTASMqwvkQpFtJpN6ro1mhY9SAanZK
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


