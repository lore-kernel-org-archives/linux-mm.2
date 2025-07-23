Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B7BAC87FC5
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 10:09:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0A436B009C; Wed, 23 Jul 2025 06:09:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBB3E6B009D; Wed, 23 Jul 2025 06:09:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF9086B009E; Wed, 23 Jul 2025 06:09:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C06B36B009C
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 06:09:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C3241602BF
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:09:51 +0000 (UTC)
X-FDA: 83695108182.28.2154005
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by imf22.hostedemail.com (Postfix) with ESMTP id 7A951C000B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 10:09:48 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=hTHKWDgo;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of liuqiye2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=liuqiye2025@163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753265389;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Nh2o4zeAg7OMbohCVL8ICOdq71b512GbZ6YsdS2hIic=;
	b=5IqsM1WeHS6SMykQWQeG/1vw+8lWyqZEJumWC+Hox48axlumTZ9rKqrF4KagKtRHmowat6
	WxIQy/y6MHY1rQ/5C63H1aJCgxTQPlgVmo0IGluReAqvAUXJ8a2h3ZYKDAW5ruXqif0BUR
	dihweMttKW8gsYBUQOibOAuem67/LAk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753265389; a=rsa-sha256;
	cv=none;
	b=pHlkRQ0en6UEitQ+SLDeN5rNMeU+aWN5xkHyiwGYTjS62JTeCaIPfqJVCrOchCyATyYjqc
	KEazvXbV09o3SokrkUJswrA6NeImoIGuWkl7CH5hWFAo4Zu0cmRPdYnX5Xiw2gamuHVI4h
	QlfFDX0X/4gNoNljqhY8N/jBKeDOOXo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=hTHKWDgo;
	dmarc=pass (policy=none) header.from=163.com;
	spf=pass (imf22.hostedemail.com: domain of liuqiye2025@163.com designates 220.197.31.4 as permitted sender) smtp.mailfrom=liuqiye2025@163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=Nh
	2o4zeAg7OMbohCVL8ICOdq71b512GbZ6YsdS2hIic=; b=hTHKWDgoW+BGrspZYE
	GXu4pdKkNEuYd437XW58tC0Ey0ajx5kKkzZa7mI7ORSJd5oTkudASXCSf6Ue8lDA
	Pvj90Rrljc7UqgFeIZwvgBoP20JIVVfQ7SSLS3SGImx91DqmaTGKS8gX32kgjbOU
	UOF+Tg2b6k3bdt9lD5ldvLzkE=
Received: from ly-pc.. (unknown [])
	by gzsmtp1 (Coremail) with SMTP id PCgvCgBXroe+tIBofN_UAA--.20396S4;
	Wed, 23 Jul 2025 18:09:12 +0800 (CST)
From: Xuanye Liu <liuqiye2025@163.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@redhat.com>,
	Kees Cook <kees@kernel.org>
Cc: Xuanye Liu <liuqiye2025@163.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm: Add process info to bad rss-counter warning
Date: Wed, 23 Jul 2025 18:09:00 +0800
Message-ID: <20250723100901.1909683-1-liuqiye2025@163.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:PCgvCgBXroe+tIBofN_UAA--.20396S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruw1fGr48Cw4UGr47Jr4fXwb_yoWDXrg_Gr
	Wvqwn8ua1jy3WDCa4ayay3Xr4Ig39YgFy093WIgFZ3ZF9rAr90gr9rGrykArn7XFsay3s3
	AF95Gw129r18AjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU1zpB3UUUUU==
X-Originating-IP: [223.70.160.239]
X-CM-SenderInfo: 5olx1xd1hsijqv6rljoofrz/1tbiMAqTUGiAskRAAQAAsm
X-Stat-Signature: rdddrfcesu6oqohim96dfyykk9uwi4s4
X-Rspamd-Queue-Id: 7A951C000B
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753265388-609802
X-HE-Meta: U2FsdGVkX1/E9daS7sugt83RRIST2YR7uW54HrIu4Smk8RoyWhxF7lpC32O2sQv7cEF3ziBWHI4WhGY+PxRRP3I66ac7WmqMjtoyja6iTaJMBLpvDR/rbOh7Anc53VP3lB1NwKxi+mdA6ejcN0W9uowf8jYSQcpJ2egsUrbx+dOZCTubAadRZFXeykSkZ9yaZxQoKX5DnukdBVQYPVmLcJbvNCi61O8+AxNKTVkFyEyFdnnqxtmGhux/oN7QDRhMOaQKqW2/qVXPOmdY8IzIdk04uK2ZRUm8iGeOu3qIy3FBHKxx77oQ0/jeTkzYnnokSD/TErv49NN1wWgHgDYTIwS8qFIhzlyHBb77IqOf4ho+bxoIb+8qBJWbkJ7il/iXInXWfzrFkGOWjeTdsL4Cp5j0I1vnV8QaYQ5IyTALgGI3DXJRYlRySNCwGReMMku0WzO0iXEXxbqcGRpwE9EwfdjnoUQqzs0E4GOQkAitN0zoZNYVEVjJwOpGxdNr0/xpcofXcjVM39ZLhYSEgO2xgexW/BuRtxuyiW7t4ql7OYVIUW2zuGU1J3VJ1wWpdBclGqS0/khkxx/hZrzok6pV4uHuyucANZHjWideJD7PaD/j3bceNIHRbbpSCVuLtXHiwhQIsLRXWdsIaLUNR3I+dZSx/M+IrGinfj4aVX45SwbKdUltbKF8br9AwAzq7B/PSrBBTI6YGZfqFZgKZrg8p8q+MS3SwYjXHRkqFndfOBOCFrtvINgUNwpqyfE/4IiJHZqTir3mGJ09H159BfNT9/1wP6uZ0AgE+MVUHFBKcuPaP8aXSpTXfGXbaj0ZDtwS2TBmMt85aGoPp61d/O8Ap4u/ESoVs9i3Vl/pYUNOdxDtP5pf/8fS8FpW1QUYJiGSHFBppuMoakqamoIsUQ92wlY2BOBpc3A1q/NYpasMW3j8G5CHAGxUdg7E2cZB+ooNrJFyUTqEncJaYl2TDZC
 u9dDbGy4
 xZ2YlCwVyA2LN6L87IXC6PKH7r8cVpzTiNW5F3uwPC041bf/FtH9/HWiXaeomoyMGh4y9rdojWWN+XSK9mPBfTXnGrcNjtfj+hSQgK8ibBTYR4ZdVI/ijRmI43FPs7ORLhQ4/hxHoIdLOslIhYsCc+QgIxgSqtzrZVvAcBmWnu7FAsPx59/HLYeasy6SJXLoAxr3SwN5l+TCtALyEhnBgtHudftb77tmCuF56r5d1X8HaA0fZ4+eQWonhxf0K+mK+jywOVB0ZZnIuGk3iCX5WPl8cPGgijvliaOgmL1H/Jlfi9j5ZlUbl4x856NjJEM5/QaMfjR7YbRXuwxtwR/IH0eFy+S6ll32GXCLstgiE70zJS4zAjW+9SPM5bPcHHykv8KH+epRHxIt2bn7fsxIlJ89x/FWHepQlnrIhiCc6OkMyCAy6WyYBIoVJls2UiZVnZVRFmbxOlveC/ktimQJTnhWj3A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Enhance the debugging information in check_mm() by including the
process name and PID when reporting bad rss-counter states. This
helps identify which process is associated with the memory accounting
issue.

Signed-off-by: Xuanye Liu <liuqiye2025@163.com>
---
 kernel/fork.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index cfe2f1df5f27..e02fa515b77c 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -584,9 +584,12 @@ static void check_mm(struct mm_struct *mm)
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		long x = percpu_counter_sum(&mm->rss_stat[i]);
 
-		if (unlikely(x))
-			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld\n",
-				 mm, resident_page_types[i], x);
+		if (unlikely(x)) {
+			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
+				 mm, resident_page_types[i], x,
+				 current->comm,
+				 task_pid_nr(current));
+		}
 	}
 
 	if (mm_pgtables_bytes(mm))
-- 
2.43.0


