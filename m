Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A3E1C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:15:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD6E28E0008; Thu,  7 Aug 2025 08:15:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C86BA8E0001; Thu,  7 Aug 2025 08:15:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76208E0008; Thu,  7 Aug 2025 08:15:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A33388E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:15:01 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 2DA19C0C1F
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:01 +0000 (UTC)
X-FDA: 83749855602.14.B65350F
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8406E40007
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	spf=pass (imf12.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568898; a=rsa-sha256;
	cv=none;
	b=R+wDJ4tDm6TgQ4TdJ/mtBQc+XMLgnFmTW4JiYKmUAEneXhFyt7quhApZ1Cn7ThNQyAptp6
	b77qxKawRUPI7w4GC919e+DQ6wkDMu4BfKy8D8I1vGh+bFTlVytltA1M04RzqOYWPvt74K
	rTkzI8asMTIO0tk3zVk3opDVElal870=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=65gl0PnsOar+g2nNuB2M6Cv0mSB1ub18pfPelnksQUQ=;
	b=8Qfm2E0VeL8FzfhPzb8QOeXkbq6gbhJ9G9xz1Irz49t/aqDkJL4A3LIfpZn8Fgai5OjhQl
	4aM4N29Nl1T/U2iEANe4NEi7S4/vZujHDsNHV7geMDodhTxi/oFo9XFA7NP1FE00RGcbJd
	ObqaQ2sLpz50gm+X4J2BdsZErEFeeFM=
X-UUID: 1eaed2cc738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:c0d1405b-f86a-4b76-964c-fd303404ddc2,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:bd05ea79dd1398b27cc4daca19b4d0dc,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 1eaed2cc738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1109964960; Thu, 07 Aug 2025 20:14:51 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 4513CE01A758;
	Thu,  7 Aug 2025 20:14:51 +0800 (CST)
X-ns-mid: postfix-689498BB-10757666
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id B9D61E0000B0;
	Thu,  7 Aug 2025 20:14:47 +0800 (CST)
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
Subject: [RFC PATCH v1 4/9] freezer: Set default freeze priority for userspace tasks
Date: Thu,  7 Aug 2025 20:14:13 +0800
Message-Id: <20250807121418.139765-5-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 8406E40007
X-Stat-Signature: uxae76qm9ynaimsdw3fgoj9ccp64zeoy
X-Rspam-User: 
X-HE-Tag: 1754568897-235651
X-HE-Meta: U2FsdGVkX1/gXFSK8Tab+lnXdm94yiFcu+Cx4TMe38D0MDW7pRMGpcuZaJ72oupHlR/O7zGNjvee7UJ76D2M3l2mKpoUQr+xADMPCgItU9jWQQNvKLq/FP0uRsVICNFMWQuuNs9QyH+Yfyl0lWXHvZ8mnygZGZr32vfwcQ9adsOfZeRvID2icTQr+84WOX7uAltVZ41cOCcad5AbXkRkO33GR1MxU+AlUbPjRn5o4ER2Yl+lcfyD/0LTPc/py1vmXtsLPRA3l0SbFrG+5xlU3EosVc05whaXu9VzcenIVkLQ7WQqES3Oq+HrV0pWdogfcIUr8FBKnW2FdU+qd8xwVxoEW6OdjfV0RWIv2h70Zd/jyEyO2Q8dRguqv5FR8MGO9izXbFwbtdMZxmh+rAW+ScecdUNCNNG1j1pHMavO/zoGAeWv6NR7X9Y9bQrCAdQ1DY2EU3EXvvv5zJWEVshShHY9cvYyz3EUBPEpODTe7bx9VOiOBYuB0dJ2hgZA3EEZgfW+JtnIIeELdQoeojmTVteSGq8GowwgT3I1c3paSDy2AL2DvsAdgPNnfrXNTMm7C3SGTSK+ReFc0T8i1GJLgIOIFAsEpQ8yMVAtwd/bbzxEsw4Dj0TlC1Ip9lra1GuwoLa8KzJMsFOG8pbrNxAS+p6LEicq53D0RlPyQ6J6Ftfmd8EkQ0B7NG0HJuaNnnpam9mmEOcungQn2r4ea6MF1/wKYawZ4NQ4DmynWFtYiBsnQ5TDMSd2pcHPxx6IMI0L2+t6dfX8KkH1v0x0I10n0bEST31j6tZN43AM6LQNQSHPkR+1x0YAjnNht/qr5J3ZeohILoIDdi/z6fT0FKBYvXW/SwLH7RAUiLWckjXBWEaRX8e3PetSzDpmALa40hEeYPBhGUEZIST0NgOLqbrHsNZo+5DSgYn96o9K97jz0+ch9TaPJrArmM2mBe4nQyFIIaA7pOX08pqGZD/tXwz
 cdJuhFAe
 ahS0xXlOpgNHtw4vuSrlw8Omarys2dALMU/S62jyXdme5XSG6+GxPzBW9JCsJVHFaaunsSX1vDv7fVDlmWdjOmw70Bg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The freezer framework now supports per-task freeze priorities. To
ensure consistent behavior, this patch assigns a default freeze
priority (FREEZE_PRIORITY_NORMAL) to all newly created userspace tasks.

This helps maintain deterministic freezing order and prepares the
ground for future enhancements based on priority-aware freezing logic.

Kernel threads are not affected by this change, since they are excluded.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 kernel/fork.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/fork.c b/kernel/fork.c
index 9ce93fd20f82..04af5390af25 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2422,6 +2422,7 @@ __latent_entropy struct task_struct *copy_process(
=20
 	copy_oom_score_adj(clone_flags, p);
=20
+	freeze_set_default_priority(p, FREEZE_PRIORITY_NORMAL);
 	return p;
=20
 bad_fork_core_free:
--=20
2.25.1


