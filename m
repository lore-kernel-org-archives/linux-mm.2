Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29D08C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:15:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B03718E0009; Thu,  7 Aug 2025 08:15:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB2398E0001; Thu,  7 Aug 2025 08:15:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A7368E0009; Thu,  7 Aug 2025 08:15:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 85EED8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:15:03 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6000B1A093E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:03 +0000 (UTC)
X-FDA: 83749855686.02.ED63499
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9A5A380013
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	spf=pass (imf02.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568901; a=rsa-sha256;
	cv=none;
	b=ogw+3W9mzdXtfdIyXinp750AkY6hHXx7g6oar5u6A6tsp8ZZVXK0+ajwFWWF4MTSClgIUU
	hSKINNzg2j1hFBzItt2sp6EukwLuUMhwk4sEgtYmBs3CX9/sNB1167T3gfQkHIcuglAe2m
	Dyt+3CqvM22geYY0uqUAOKeKhmHNFBo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pNBf5+noT3duV8LgMBwMKR0b1gRUooUMFW8CcwobliU=;
	b=HL3KXz+CcewXukxTeSLMfum8FCQ4GemLsXYYoKSAMZd3BCPCzvCel781DUMYPOfUT7OdVU
	NCaPeN2fjzrG+7ne8xmnQpu/2inENAIN+Ywqszs8sYXa9QEPTVGiuGSyeZfW+I+7VZQkKL
	3rQ0A2qixa7OuYXQtsRsXZ6Mcik8bfI=
X-UUID: 21419812738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:bb2b8d20-fc11-4a08-a86e-c3ccd7360bda,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:051d5319b82a10187433fbc93a60ff3c,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 21419812738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 2002267490; Thu, 07 Aug 2025 20:14:55 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 8F097E01A758;
	Thu,  7 Aug 2025 20:14:55 +0800 (CST)
X-ns-mid: postfix-689498BF-34637367
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 1DCC0E0000B0;
	Thu,  7 Aug 2025 20:14:52 +0800 (CST)
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
Subject: [RFC PATCH v1 5/9] freezer: set default freeze priority for PF_SUSPEND_TASK processes
Date: Thu,  7 Aug 2025 20:14:14 +0800
Message-Id: <20250807121418.139765-6-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9A5A380013
X-Stat-Signature: kpw3bkxg4ko85qa49o8aq86wcejtd8ia
X-HE-Tag: 1754568900-275326
X-HE-Meta: U2FsdGVkX1+nQEVK6es801HZEl6M7YS2ml75QlszHzWrdpxKnrdzM8EjiQDPjsU8/zZk84CeuxiwgqRyxGlhc2YmBjOpX+4w9e402ZGh0I9Apzm1WVqLILBrETpqpCzCaA+v3nMfSXBiD8NZayFURqgJRakb5YpJ0umgqdrsWxs9rjP4SQyuwlQratWUmgkfuCemfig+defYu4qVKbaXT9RdP9WhHnaJb3zkPiI+ijiv2qJ92NBAf9mj7wZ/p4o6SwERaRLtW8LsXGUhbwxw2TC4mSSSmfcHqIgDG0eD7eY7ZEAXXXpMlHxt3szL0gTAdCBOC6RKDNYxtLWRu22ZSoRbLcwZtwWQ3IRAZs9kec9y56u59++UEQJxacfdSTxbsBlky5m3UUi6Bx6B/Ak23AUbX5s7FUHfeh2Qh/vKwu3s8BNqB76yCQszZukWhM/bxePxxb9gxb4zibUjcaV8+oOyTRO/o0aUpYxHJRd/Q+oySzbW/71tdQwVvrjfExFO/nkE8dsRqIVJeuYYDbCs2scUKcAcVqbhtRERnwVQeugvvl+uT8hN5dXFLDmnB9UfRpzDKKIsyBY1oMNsmRI8EkJyBhbo9eR/KA2wiPeWwsQC9SP0IdiiSZWsp23Ud5hZsjfEEkUvO2Et8mPzyHdMeDaKWl3vJGSJL5SP4e2ZTYVkr/vTlPyDnpwH1mRI4sFRBiDZmBBaG5btel/NNUz3S+L32YxvpHESQWLCE9/AysPaN4ewdsGVRMc4TSYJSWpzfK8yjW/UfDWywML+AgdHqkGuqQOIEuIYPQ7aoUVwUYAnSuVLTOHNE7duf0AwX5sxBxxglR8+1/tASFMLtVpX7xuqHnrGysMb3an7FWPORdFuijXZEIn9jwsS6ki66I2uf5HTl2zik6Tba+o02mXtFapMOchGI4NIqCWlbSYj9aryb1doQIXVbvsKyzRjgh4gzrdPkH5bfmeUT5BQD4T
 1qIq2Tk+
 HN0Dff4uIe4Fqu2TZm+CKnaY466yiJoGxqUCb6XlPlh0BFPr8SZUC19/YVIjXpUSvDGK89VDg814r9bdtKUjcNntznHVGh+jf+GUA3pRUSqMu2ePkrZsqUdztEc5fai1d7GLZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Tasks marked with PF_SUSPEND_TASK are involved in system suspend or
hibernate operations. These tasks must not be frozen, as they are
responsible for coordinating or executing parts of the suspend/resume
sequence.

This patch explicitly sets their freeze_priority to FREEZE_PRIORITY_NEVER
during initialization. This makes their exemption from the freezer logic
clear in the new freeze-priority model and avoids redundant evaluations
during process traversal.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 kernel/power/process.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 06eafdb32abb..21bbca7040cf 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -147,6 +147,7 @@ int freeze_processes(void)
=20
 	pm_wakeup_clear(0);
 	pm_freezing =3D true;
+	freeze_set_default_priority(current, FREEZE_PRIORITY_NEVER);
 	error =3D try_to_freeze_tasks(true);
 	if (!error)
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
@@ -218,6 +219,7 @@ void thaw_processes(void)
 	WARN_ON(!(curr->flags & PF_SUSPEND_TASK));
 	curr->flags &=3D ~PF_SUSPEND_TASK;
=20
+	freeze_set_default_priority(current, FREEZE_PRIORITY_NORMAL);
 	usermodehelper_enable();
=20
 	schedule();
--=20
2.25.1


