Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE071C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:14:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81B108E0006; Thu,  7 Aug 2025 08:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F3098E0001; Thu,  7 Aug 2025 08:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E0E08E0006; Thu,  7 Aug 2025 08:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC0B8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:14:51 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1861C1A06CA
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:51 +0000 (UTC)
X-FDA: 83749855182.16.BD85B0C
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf10.hostedemail.com (Postfix) with ESMTP id 6F60EC000A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	spf=pass (imf10.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568889; a=rsa-sha256;
	cv=none;
	b=2B1qwffF9imRmYgCz26AzJoCI+AMmLrl1myoEKY2vZjpcD+D9/+hJdnwt01XFLvg9qr8l0
	sLiTv3AA17l4VHCxnthjDoi4yXdxoI2RbI3C4Bl8qJlrRQ8eGCa8UBeLcXBcCnSFwGA5Qe
	hjcmXSeUcKMFpfeTLz3zDyi9AHWddYs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf10.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xcSdCNL8HUeATEjrLDnecjs3v+Yq/RnclvsJhjKo9Xk=;
	b=hDaqL59aWpQXW9Ir8RDiaGpREDqSU+UikTYD7Vg7KLn4MrYCMQp7ohM4LgaeGNE2P8iukf
	KaBH1Mzj0jceNbtu1RTQeFdYivFoJINrpU1X21yqCCsINyP/KLh2N2JHNV22hv56/Nnzpe
	Qb/F6IggoqMRCD6/GJxttqcYOWuGaGM=
X-UUID: 19c82fb0738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:322cbd87-c348-47e9-af03-2fa2b18264f3,IP:0,U
	RL:0,TC:0,Content:0,EDM:-25,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTIO
	N:release,TS:-25
X-CID-META: VersionHash:6493067,CLOUDID:0af04b9c10a64e090692712e5936fd26,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:1,IP:n
	il,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LE
	S:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 19c82fb0738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1586284648; Thu, 07 Aug 2025 20:14:43 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 0D4FAE01A759;
	Thu,  7 Aug 2025 20:14:43 +0800 (CST)
X-ns-mid: postfix-689498AF-52865563
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id D10C1E0000B0;
	Thu,  7 Aug 2025 20:14:35 +0800 (CST)
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
Subject: [RFC PATCH v1 2/9] freezer: Introduce API to set per-task freeze priority
Date: Thu,  7 Aug 2025 20:14:11 +0800
Message-Id: <20250807121418.139765-3-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6F60EC000A
X-Stat-Signature: k6x3r48dba8psnfjztbiy56dsc411usq
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754568888-126575
X-HE-Meta: U2FsdGVkX1/QuYWBnnBX2MXHdHoMsXi17KGgL/PzCZHX5mE118NrINlRdRNaJsPU06haVgXAgD0rnIDKkdZ3J8GyRZbqK/5hzXH969FZsWoPpQt0IWBLEelkwQKfPbRa2ddZe1prC+Nq7u89UaM4ORMRATlmTB8LKIZV5JxMIMht58+vbFcsFKGbTXTXAOMecuLhHrMcGbMD381H701FQy5d2sCCf9pf9F9Ef4St51n/9FRaJCkx+2Mz6dzBn0aZcfZTX2eUlLQOpttLQ3D5GIzprYbuKHyX2Bv7xmK2YNZ8WhkqLX9F0b/p1o3BkiaHzKiLN4864Db/KnXDYLsgRJua/K4zPzuMoI/VaJXWJ+LaWWDN9SiC7YuEiYvQxZ+xUe0CgqSRGHdzDFfTS5ZbpgpaxuMM1oUuKKDnpPG0NcePOM9cMpSwtuWHMSIIdaHuAXSZGKqUAk9M2YkaMFDyLsnKnQfqTUziAh0BNGpFJC0izBCObXB4SAGP0s+/DeqQ2qy5CoF33R/djdQWVUrD/QRCH93fU95iC5rFRTrANlAHUl6mKtNwAjw1we6oHj08z1tpQaW6t99CNWcuMnclcUvCm2pxOE1iyz0sPvlwwbQP00W2TqJpVQa23/w5gPlcU51jXykV5fRVhb9d2wihGDnYJHJiYDVkeIAPiCGfRXYtkkHs/Zyqb1aCSUFWxmLtqQGaCj9jdYLfRlBbveCczVBn9iovlZsb5Pp2MaHby0JBo10cKBEbICa5YHykdOv1geTulDQextwVmAXK2hBXylmrBpqW0h4sCu5ZplFz5dpOntP4EhKfFWvNhkI4Z88VoOxUMCYsY00Gt7c0Rbp8HV9qLpVwAy3Lgj6GywOwP+4cP1aRiRTiE0t3RV5MM7pRgxH2XvRtz+sFCWzQlORhbXOfv9Nip7JzflSiqRu6DY41QY9OqnPiVjdYMX/N924vJygdUDlu7Q5VxTagbNU
 UBoiD4ut
 2EPMQtAW8bApwb0ZcPo5ekEFTXSPXIPggNPhCIac9C+pg96VSb2hzoJgt1oLsDBKf1+7MzTQozTRDLjvpNEVNaW0GYQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patch introduces the basic API for setting freeze priority on a per-=
task basis.
The actual usage and policy for assigning specific priorities will be add=
ed in
subsequent patches.

This change lays the groundwork for implementing a more flexible and
dependency-aware freezer model.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 include/linux/freezer.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/freezer.h b/include/linux/freezer.h
index 6314f8b68035..f231a60c3120 100644
--- a/include/linux/freezer.h
+++ b/include/linux/freezer.h
@@ -46,6 +46,18 @@ static inline bool freezing(struct task_struct *p)
 	return false;
 }
=20
+static inline bool freeze_set_default_priority(struct task_struct *p, un=
signed int prio)
+{
+	if ((p->flags & PF_KTHREAD) || prio > FREEZE_PRIORITY_NEVER)
+		return false;
+
+	p->freeze_priority =3D prio;
+
+	pr_debug("set default freeze priority for comm:%s pid:%d prio:%d\n",
+		 p->comm, p->pid, p->freeze_priority);
+	return true;
+}
+
 /* Takes and releases task alloc lock using task_lock() */
 extern void __thaw_task(struct task_struct *t);
=20
@@ -80,6 +92,7 @@ static inline bool cgroup_freezing(struct task_struct *=
task)
 #else /* !CONFIG_FREEZER */
 static inline bool frozen(struct task_struct *p) { return false; }
 static inline bool freezing(struct task_struct *p) { return false; }
+static inline bool freeze_set_default_priority(struct task_struct *p, un=
signed int prio) {}
 static inline void __thaw_task(struct task_struct *t) {}
=20
 static inline bool __refrigerator(bool check_kthr_stop) { return false; =
}
--=20
2.25.1


