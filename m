Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3153DC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:14:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C39688E0007; Thu,  7 Aug 2025 08:14:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEABD8E0001; Thu,  7 Aug 2025 08:14:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8C228E0007; Thu,  7 Aug 2025 08:14:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 97B6F8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:14:58 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 762CB1A0A31
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:58 +0000 (UTC)
X-FDA: 83749855476.16.8C88197
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf17.hostedemail.com (Postfix) with ESMTP id 5AB564000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:54 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568896;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=uCbI1KFAhRj3t7xEtswzlEutQNo+RL4qnuTNpAInd6o=;
	b=jCfK/EU3oEr9fPF0o7MKR9PSGlwwyXJIt/Em/640awMBJ0/uj7/gyS8irOYMXyLzY6Uske
	fZplF4fBOUtFUf6t4FOJiVRgmGMowhQMEYiUdEb3rpOKn5MUaIs+JrxTsU2l/+gfbmffMm
	sSFQbw9r7Un0dHMp+c0/3elkIp0BtTA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568896; a=rsa-sha256;
	cv=none;
	b=vBbqYswVBXC0wHsqJqFIgJ+NlvtEidDLZN0QUghrIN8t2cCrprJNFptizg94oUALkzysiJ
	YthUnRAO82JE00zOi+ln1M2dKvPjjc46OU0alwI4BJkZN+rDAjv0UuykWQ3G3jM53LDeDO
	jX6w23Eh9DoK0AVfMkG8t6ni4MCwFJw=
X-UUID: 1c51a676738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:1cdd2b89-b372-4194-b9aa-70d3449c1a06,IP:0,U
	RL:0,TC:0,Content:-25,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6493067,CLOUDID:d3db5b041da0d758e8aa142411b5b99e,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 1c51a676738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1097566653; Thu, 07 Aug 2025 20:14:47 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 1CB2CE01A758;
	Thu,  7 Aug 2025 20:14:47 +0800 (CST)
X-ns-mid: postfix-689498B6-91481065
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id A4A8AE0000B0;
	Thu,  7 Aug 2025 20:14:43 +0800 (CST)
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
To: "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>,
	pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>,
	xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [RFC PATCH v1 3/9] freezer: Add per-priority layered freeze logic
Date: Thu,  7 Aug 2025 20:14:12 +0800
Message-Id: <20250807121418.139765-4-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 5AB564000A
X-Rspamd-Server: rspam06
X-Stat-Signature: h6d4pts4xm93bj38541kjxpec5pphy41
X-HE-Tag: 1754568894-859213
X-HE-Meta: U2FsdGVkX18snxLqMiRwjChitshrXDxn9aOe2fjlscklYWAklIAjR7St6GxK+NCst3OUdI7KB39n2LgnnUzs3hxODDYcYV927IaGB1o4++dT0F4wyVFXHSuSrzBNPQgtLwM4QKbGmSf7jZ7UTH/aEKejRF9YSurwkJEDkFw4IOJ6B1veFecfs7kWR2oslfMehvOgb679aNn7PJuBB/nSvhxah6cgGUc48R4QbMLqdR42vX5oJC0tg5jSXdlIh5mYzjIAk0XQLwU3KsbBk1WAvBvYUCmnzBw34opPqXKnfjXQhnuNOdUBbWQFMouzZaRuRjDNImH7muy8Nwn25GlkdFJBWlIkIxe6nY7ZDUltWLHwTyrvgq2XbHGkgsXXNq2rlSrf4VKaY4pYPXqkIl3IXoBMW2BKwNVA+KjoJbqfzqbxC8OVFCMQZqA4VZHILrFpDig9adzNo52A32b3I/kOVRUhhhGamiffmAs2K+N6NqHZWgkASQdZZV0hYXPmQSyKcfGbEb35kheLQXx2khpMSYkPuAay/u6OHd39ZDGR6ObtbQNuq7mi15J96Pxwy9anvXcmvvwYcDubU++L6QymboXU5WMBmTm4zYfVOOaldcLFnG2RRIAMdLlXVwFrYbifqnPV61B/k66wB6ys+m6Uy+Ot2pVO8M43fmLR1TbUrbbvM4msXVFt/ftbE6qQ2Ipy0HXlO3OVAsivFF1r2zHRVAkJNlO21GrYbbi/9zokD51jRuv+R+vNFnLBDTVfH31aOjrjU75lm5kb+2SP+2fdtujdXCdjpXXW3GX7IOYLPzQBahQiXneTUZNR9cy0u09aa22GL87uWN+/h4/1MrPaYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The current freezer traverses all user tasks in a single pass, without
distinguishing between tasks that are easier or harder to freeze. This
uniform treatment may cause suboptimal behavior when certain newly create=
d
tasks, service daemons, or system threads block the progress of freeze du=
e
to dependency ordering issues.

This patch introduces a simple multi-pass traversal model in
try_to_freeze_tasks(), where user tasks are grouped and frozen by their
freeze_priority in descending order. Tasks marked with higher priority
are attempted earlier, which can help break dependency cycles earlier
and reduce retry iterations.

Specifically:
 - A new loop iterates over priority levels.
 - In each round, only tasks with freeze_priority < current priority are =
visited.
 - The behavior applies only to user task freezing (when user_only =3D=3D=
 true).

This approach preserves compatibility with the current logic, while enabl=
ing
fine-grained control via future enhancements (e.g., dynamic priority tuni=
ng).

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 kernel/power/process.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index dc0dfc349f22..06eafdb32abb 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -32,10 +32,12 @@ static int try_to_freeze_tasks(bool user_only)
 	struct task_struct *g, *p;
 	unsigned long end_time;
 	unsigned int todo;
+	unsigned int round =3D 0;
 	bool wq_busy =3D false;
 	ktime_t start, end, elapsed;
 	unsigned int elapsed_msecs;
 	bool wakeup =3D false;
+	bool has_freezable_task;
 	int sleep_usecs =3D USEC_PER_MSEC;
=20
 	pr_info("Freezing %s\n", what);
@@ -47,13 +49,18 @@ static int try_to_freeze_tasks(bool user_only)
 	if (!user_only)
 		freeze_workqueues_begin();
=20
-	while (true) {
+	while (round < FREEZE_PRIORITY_NEVER) {
 		todo =3D 0;
+		has_freezable_task =3D false;
 		read_lock(&tasklist_lock);
 		for_each_process_thread(g, p) {
+			if (user_only && !(p->flags & PF_KTHREAD) && round < p->freeze_priori=
ty)
+				continue;
+
 			if (p =3D=3D current || !freeze_task(p))
 				continue;
=20
+			has_freezable_task =3D true;
 			todo++;
 		}
 		read_unlock(&tasklist_lock);
@@ -63,6 +70,12 @@ static int try_to_freeze_tasks(bool user_only)
 			todo +=3D wq_busy;
 		}
=20
+		round++;
+
+		/* sleep only if need to freeze tasks */
+		if (user_only && !has_freezable_task)
+			continue;
+
 		if (!todo || time_after(jiffies, end_time))
 			break;
=20
--=20
2.25.1


