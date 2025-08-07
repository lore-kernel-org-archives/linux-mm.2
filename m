Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1478BC87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:15:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A65C48E0002; Thu,  7 Aug 2025 08:15:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A16388E0001; Thu,  7 Aug 2025 08:15:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 905538E0002; Thu,  7 Aug 2025 08:15:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7F4338E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:15:19 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4A4601DDDBB
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:19 +0000 (UTC)
X-FDA: 83749856358.26.F432FEF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf16.hostedemail.com (Postfix) with ESMTP id 9DC5718000E
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QmXZrLg9psqoHGnm/Bh79/YM6CieMV+N+yEsPaTbKTE=;
	b=Brpyk8cfIBxzk+Nz5JfJEhLEaAI4JyIHfw29kAfmYbT9IWJwQHTRnJKnSXM1oBdDNKp/gJ
	2ClzaChe0/C1Qr0YyKCsUkQIuVU/sFyZm4+28Tel/2E7NF2xVlKIosXR6SkTkiQHixGCke
	572+1rYGie8K78aoVUPMyQitB7pAlL0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568917; a=rsa-sha256;
	cv=none;
	b=daLYLyetL9gOkVU+Ca5RZ9ENU/gdP7Rxp02Md8jBl6P9l/iGhkyHzAlo4qAtEOM0fc83aV
	AZExhoPBw64ySxFL9/Eu/xnirg3hNqSFyDFfFxopN8wN7kOL7E8QvWpa3OlWnRm2WqmgfU
	6uqv7dfJcqjTKtnGGK2napNqvxrzGCE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
X-UUID: 2a575130738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:8d6ed8b6-5bb8-4587-9ed8-6f90c86146e6,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:9fe1de7d8afd90c484327fd77a29b260,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 2a575130738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1577606970; Thu, 07 Aug 2025 20:15:11 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id B8029E01A758;
	Thu,  7 Aug 2025 20:15:10 +0800 (CST)
X-ns-mid: postfix-689498CD-2766471
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 88C2FE0000B0;
	Thu,  7 Aug 2025 20:15:05 +0800 (CST)
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
Subject: [RFC PATCH v1 8/9] freezer: Add retry count statistics for freeze pass iterations
Date: Thu,  7 Aug 2025 20:14:17 +0800
Message-Id: <20250807121418.139765-9-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9DC5718000E
X-Stat-Signature: z7ghkt9cuyifsztz9n745a6kemex7ox7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754568916-568312
X-HE-Meta: U2FsdGVkX1/BRjvLq2wjOjYCjjqwStEVnSFp2/Ebh4RRGq0fV5YYbv2pFCnRFGc1DiXa/9f3W7Jivn+WQWx2J9Ek+8LHHUapa/RQCQNLouiufFeIkelwMU77v9HF6BwdfRDJEKGL3IPo4GzuS5Nr3HwSR0JFPLv/7+lSadlZoFH1grC+NXd+KT4JVQyx01Uizu448txp6SWZwqaHi8ZWkr71HGHgMEoFE5gAmCClNNwyC11i3wtgbV67biX6cUryr5XYgLyklFYLVy2SNvLI25GXsoSVsU+wqnqe19plnAKJC3SEiSXfc19q3CUYuRJnboixsGJd+6Ka32U2chMF4mOtWlucgqpv2W0ms+rr2TA39aq34K1fYnqdJl+v0sRbc6ZMa1uUZvOs0WyZ0eQY0chhY2brDU/0sNfSZCrNS7ZsvvolXPzyLK1FobYWEWYoRzwIjZqnpY0Enbqt9AyuKe7IRGZgjIPpEjbVNeMT/1vyA0sPgc5RZG3yMN84bUtZGN9XogCl0vgSz0yXDoKfA+XdDnu6uOk/qb1+aVljMyqAj9nq7r2ixF8po9ASswEJbatUMqMUJQHLS84xIH5Qw4u7dypSrAvijsmoTiqPu2PAYFzhm+nRo9bNEHPIbyg8Wb9tu1pr6qXDLgJp3ovEfB2/5pYZhGYHew6n4EPX0ztmk7AzbwNAfs0NiJVAY3TTo5BCD2BIOP0KYANpscHwmH8o5MbwodWiCddeZPD11KQ6JUn2LdG4fNm063FR9s9+wrP6GrLwhlUt1tQJnh+EyYwXCHLhVXonZQYlTLbFf9LQsNfWoQ7YF9ZNoYimrqYNkBmGYCzo5zCIG9/J8HyWCGzOznYcANt/iAWeZr7PvJxeu6OObx13+8YURIMJ5iepp9bKxpNZ80ofxySeGIujNrtGLNhLQF08eGDhUMFHItI7+/JVdUb+J43ct56gccKM24yOFWfAKmmr7G0XKNr
 CPLMOb6j
 Wwk/LQgbkLv/x7n2GNBoFCnPqlChFifARb7ChylJPyXRN6XTPbAYEcBzfSOBtchRhIhER+618XW2nC1UoxbxDcJsHfw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Freezer retry loops during suspend are often triggered by tasks entering
D-state (TASK_UNINTERRUPTIBLE), which cannot be frozen.  This patch adds
a simple retry counter to freeze_processes() to help quantify how many
attempts were required before all tasks entered the frozen state. This
is useful for performance tuning and debugging unpredictable suspend
delays.

A new dmesg log is added for visibility:

freeze round: xx, tasks to freeze: xx

This message allows users to correlate freeze instability with system
state.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 kernel/power/process.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 9d3cbde905b9..442d2ebba3ed 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -76,6 +76,8 @@ static int try_to_freeze_tasks(bool user_only)
 		if (user_only && !has_freezable_task)
 			continue;
=20
+		pr_info("freeze round: %d, task to freeze: %d\n", round, todo);
+
 		if (!todo || time_after(jiffies, end_time))
 			break;
=20
--=20
2.25.1


