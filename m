Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 954E8CA0EC0
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:14:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F20EE8E0005; Thu,  7 Aug 2025 08:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ECFF28E0001; Thu,  7 Aug 2025 08:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D977C8E0005; Thu,  7 Aug 2025 08:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C82278E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:14:44 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 97B57140BDD
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:44 +0000 (UTC)
X-FDA: 83749854888.04.B92E425
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf07.hostedemail.com (Postfix) with ESMTP id 057AA40006
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=HRaJ6xCap8jb/m9mCMCeFzTwDaHyy3z5it3KOPcgh48=;
	b=YE/+OCLdtx/KR1Bv8YJ7f2jOq9nmj1ZmUiFiDYRCWnAqgON6HZtqjAw/7B8b2XVsTtgEuT
	Eju+YaImo07/8r27jTJbeRIbikSMTHV0lcy+voBSTC2mj/PE+olRdSgNP3smSLqsGGMqrV
	zkLwsi7eDC+p4H0f4IuaifDu5A/0ESk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568882; a=rsa-sha256;
	cv=none;
	b=G7kLY1rYG5D3Oh6tIGA8Tr3LLfHJKKzLEDgFPSryWLlpqINfEmRuTX8G5+zMUG3jgcT0qI
	0JClJBHmTnBLb7mGZinutPHuO+5zUSWYQ9awkvP9wJ+/rZ41sVWYo/QO+ziUEB7hhBMeQH
	BcdM3G7qYhOD57XY+8IcY4aTIWexHuA=
X-UUID: 14f1d57c738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:bddde5a2-6be7-407d-9019-230d29b98340,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:ac141f20124bc38f4d6b4969aa6a8eef,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 14f1d57c738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 351858400; Thu, 07 Aug 2025 20:14:35 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id E6B70E01A758;
	Thu,  7 Aug 2025 20:14:34 +0800 (CST)
X-ns-mid: postfix-689498AA-78502062
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 39E6CE0000B0;
	Thu,  7 Aug 2025 20:14:31 +0800 (CST)
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
Subject: [RFC PATCH v1 1/9] freezer: Introduce freeze_priority field in task_struct
Date: Thu,  7 Aug 2025 20:14:10 +0800
Message-Id: <20250807121418.139765-2-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 4h85ugm4je8h5xt9on46366tmohzsow5
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 057AA40006
X-Rspam-User: 
X-HE-Tag: 1754568881-298130
X-HE-Meta: U2FsdGVkX1+ba6sI4FPaEfJmixJZDnIR+8i1/t5OGZGy9K0r7jyijMZdlGi1DND20ItlXhAoVoie+Wp+ItvipapHvRzFtKUCMHf6W2sTtDr0aHvcf0IPcoMNHpUyk8arIsTdD+jJee0NSN6sVHLHeKOqBUBz3m7C27bOJCks4ffx2d+wv07CjwCMpw2EaSi7PhiJpBf+ZmDmYIk39cbM9jGo6p9aV/5RICPiqwx0MJ4aOUzTq5SYrePzYu2C+hk51lAQBCOeikBKDv1ZvPxrx/ReCUD1RpEamkBV/FJ/3nw2ceh0moO34CCYyITowAPTtyVPep+Q6Zp0vVrNnq0KikHCAh7x1Tk0pp31j/wS8OFv0RMN4qrQ4gWdSVuvyj1zORYKwlnIbzfJqlZWuZpxV+eQQwxWV+Ld26+kSFJ5muSuiLbNaEt6C8BRq4SW8vH8lqBBm50yGkhfDYRGwVvjFZoxY9yX6VbcV8lq3vVvNi8o8ei9ytCed3Zc+pegY+EBLcQnZBEgTKNultzW0dU54IzdEEqKPtQQlfcovcUG3p7X6YfEaoSdSCg/26KqQ9TRXqRIVInlDg5ByiYzgfZrZ8HrQeISNlYLkWKMo+dLvzVTcb/U5jNahuGrO8PW5dn4EreywGAhDz0WRYEScO3N3AZaiHqZepQtFMeC/ErDmkDkY+bgkf/yNvBXr4qRV3MD7SJmo7H9oRLNdVAaOEj8RFBegLDWIXsGxMEjoHYdEyrtW+ZhveEuWekda2R5hrjs8w6raIXnOqZcbMDkfMxtmorrJLjgydaYVOFt1CawCbWjp9ED1QPgHs92+Xq/RZCYUtJmq+aYUyJgXVlw6PUvYiLGvCM6+UzVpc9GsAJ1LLYZ7ohDicGm+Vios1ohW45u
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

To improve the flexibility and correctness of the freezer subsystem,
we introduce a new field `freeze_priority` in `task_struct`.

This field will allow us to assign different freezing priorities to
tasks, enabling prioritized traversal in future changes. This is
particularly useful when dealing with complex inter-process dependencies
in modern userspace workloads (e.g., service managers, IPC daemons).

Although this patch does not change behavior yet, it provides the
necessary infrastructure for upcoming logic to address issues like
dependency stalls and D-state hangs. It also helps avoid potential
race conditions by paving the way for deterministic freezing order.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 include/linux/freezer.h | 7 +++++++
 include/linux/sched.h   | 3 +++
 2 files changed, 10 insertions(+)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index b303472255be..6314f8b68035 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -16,6 +16,13 @@ DECLARE_STATIC_KEY_FALSE(freezer_active);
 extern bool pm_freezing;		/* PM freezing in effect */
 extern bool pm_nosig_freezing;		/* PM nosig freezing in effect */
=20
+enum freeze_priority {
+	FREEZE_PRIORITY_HIGH		=3D 0,
+	FREEZE_PRIORITY_NORMAL		=3D 1,
+	FREEZE_PRIORITY_LOW		=3D 2,
+	FREEZE_PRIORITY_NEVER		=3D 4
+};
+
 /*
  * Timeout for stopping processes
  */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index 2b272382673d..7915e6214e50 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -910,6 +910,9 @@ struct task_struct {
 	unsigned int			btrace_seq;
 #endif
=20
+#ifdef CONFIG_FREEZER
+	unsigned int			freeze_priority;
+#endif
 	unsigned int			policy;
 	unsigned long			max_allowed_capacity;
 	int				nr_cpus_allowed;
--=20
2.25.1


