Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 723F6C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:15:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13F218E000A; Thu,  7 Aug 2025 08:15:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0EE738E0001; Thu,  7 Aug 2025 08:15:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8128E000A; Thu,  7 Aug 2025 08:15:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DFD2D8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:15:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A802859700
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:10 +0000 (UTC)
X-FDA: 83749855980.08.CAE63F3
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id C25AC4000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:07 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568908; a=rsa-sha256;
	cv=none;
	b=g+CPNgNFuLaQ6e0ZPqOkYIfaQvptEPF5RhEzWF3E6yzhPaXjX8600Q5E2zzanowEVLfZMn
	60PgxcdC40MefLjh5CKANzNDEA6YPtOjM5D7RDdxsglaak4lr8/p7MCcs/y6pY3lwgdM/L
	tZUEdiKoodzkmx96wV/ugwhgK01oVnQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568908;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NSUA9qz7B7smDgugUSoGrsIVp/sOZKJBanu3WFKnJ3o=;
	b=7cXZiCDfrHF+TF4hUe1Ez6imSagbV8KKuO6ygrKS4HDVpZ5rGlAH2bbc/u82jm7XQ2waJz
	9zULG9T241Yo+MjOV4DzDLs2rqLbhzAam7F8q430GB9ySkFaGLpBp7KUVNsj9ufzGVlDR0
	QO3+JzCiAwPMurUAaPElmOl5AIL5CEQ=
X-UUID: 24704682738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:1d12fb1f-37f4-4fb7-923e-1f3c2fe62e61,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:12a84b3772c0745d9275fc58a33b6108,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 24704682738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1815612336; Thu, 07 Aug 2025 20:15:01 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id E676AE01A758;
	Thu,  7 Aug 2025 20:15:00 +0800 (CST)
X-ns-mid: postfix-689498C3-49482168
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 3D9FFE0000B0;
	Thu,  7 Aug 2025 20:14:56 +0800 (CST)
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
Subject: [RFC PATCH v1 6/9] freezer: Set default freeze priority for zombie tasks
Date: Thu,  7 Aug 2025 20:14:15 +0800
Message-Id: <20250807121418.139765-7-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: C25AC4000D
X-Stat-Signature: 8fofowzbuaggxwfa39ockh6k3kxtgn8m
X-Rspam-User: 
X-HE-Tag: 1754568907-629801
X-HE-Meta: U2FsdGVkX1/4kveK+XHe048qOYY5Wn3U7A0Rk56YTzzozWPCk2KlnO0RLb10JZwut9SUgXpsblKij54GlX3hVRnGnr1NaMsGlYghdAEvk8IDtrfNElQHC1L+pR4xcBH6jPvZViZhcGDg4HOcXdQnyj5QQJHC17tETMjmFx+0JZLxoVSo8n2BuRr8AhVQD7tmVyP/Lw4xrGULV0dR4BaRmxamjbOkhQjgD0brvJrI4rQOt0JnVyyuIoU2XIhykUlGcteJ+doxeYxGQbUUODh1yuXogdJn9JXhzlm9kRRUU3jloX4wHeMma0ePmqlAeMKsTP5JOba1nyl+/P9tDf3nPJkEm807rgWp+DKU0A6Sg0P4tbgQr1B71ZIwo5eBRi2OuHMO5WgYNkmy21wqatTrEORmx1Vqt0EW4HduMBa0LwicrA8T+AH6ZkufkHIcN5dcctiRhxaeCoc86SOmJli0trv/1P+PXK1lWiX+UeLKiUoNhY7s+XzhPdNYTha038isSv3n+dhmBzHfagYmU4quRs5vOwzAFAJ1EhnyKTDrWPr7kpeoEjJrq3mE6jucC00h51IVNQgkRr0EZupRGlVBElJYzIoWfC6TA4GYLKDDDs1g1czzhs7IYgGa7itBqTmkT7ceTNDSinsfqLK3geTbDdGEPpdNuq9mGwK181PFMtMxZpIjpNa9dAgbyyoN1ZReYLgA2aEWw+P0woASDI7bxUo+1Kt/WwExFfkGNcT2XLPUuznQWm/RxOU3Ejz6mUcJlG6kGuVVE4hl0IhXQgOTbLx0tVTkTubWlafSP8I1wIbZ1FHJfeFkYpzykbaEJ/E3k4RYki+E7v6sU8dPM0d1mmm2VAHu7JjdgLF3lJcyz6TJAptMZ+5Nnl1aaMNjAwkPGOHY4wZH2ri59Ainfaia3gz2z5PHJ+2Qcz0Vk/ToFptb/WuK/pX1JUp9hfx/ZE+YhzVQ0USp1oFM1aEjzUo
 LBkzghIM
 sXxKmbZYUmkwXItk06s4nr05n+wCyhg0d1LnpQvRWYUB45jOS2Io9D5O3Ozr6r2HaAZ7EfN5uUFol3UwRAsFo6IMB5w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Zombie processes are not subject to freezing, but they are still part of
the global task list. During freeze traversal, tasks are examined for
priority and eligibility, which may involve unnecessary locking even for
non-freezable tasks like zombies.

This patch assigns a default freeze priority to zombie tasks during exit,
so that the freezer can skip priority setup and locking for them in
subsequent iterations.

This helps reduce overhead during freeze traversal, especially when many
zombie processes exist in the system.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 kernel/sched/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index be00629f0ba4..5a26d7511047 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -42,6 +42,7 @@
 #include <linux/context_tracking.h>
 #include <linux/cpuset.h>
 #include <linux/delayacct.h>
+#include <linux/freezer.h>
 #include <linux/init_task.h>
 #include <linux/interrupt.h>
 #include <linux/ioprio.h>
@@ -6980,6 +6981,7 @@ void __noreturn do_task_dead(void)
 	current->flags |=3D PF_NOFREEZE;
=20
 	__schedule(SM_NONE);
+	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
 	BUG();
=20
 	/* Avoid "noreturn function does return" - but don't continue if BUG() =
is a NOP: */
--=20
2.25.1


