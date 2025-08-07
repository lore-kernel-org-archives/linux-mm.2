Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6EA2C87FDA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:15:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F0A18E000B; Thu,  7 Aug 2025 08:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0AE8E0001; Thu,  7 Aug 2025 08:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED1938E000B; Thu,  7 Aug 2025 08:15:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D6D878E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:15:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8D7AC824FC
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:12 +0000 (UTC)
X-FDA: 83749856064.21.EFCD1EF
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf04.hostedemail.com (Postfix) with ESMTP id E98AE40005
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:15:09 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	spf=pass (imf04.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568910; a=rsa-sha256;
	cv=none;
	b=GCDrN8yDpY32sBeU57+6gSs2UYomjCRO+fiCUWe5Ti265PAqwqaOePTgWUlEeiLnkHGLc7
	HxsmQc8LiH98liUs3X1HFIPQrLMAyxT9u2Z7na8mi6itmTlUEvwF3BnellGADftOu/oDXD
	aPCjV4vF//EcWeW6q9dLidXmZZf5tJM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bul+c3KI3rjj9TORE7yYbe/e0+0kHGaf6w3OfsN/ISs=;
	b=VWe1JWS2uTAO83aCudPhYgtWN4MI80EIOHahcaK+5KVjuL1Pi3DzKrTdEZkpEo4M0nyV1r
	eAjjv+Am146+ka7fpB/hSM4Aw3yjLQDg6RU42b9Fp2L6e/4PikLNP5sYf48YD44PfWeBV1
	lGm8+FdYviGna7uFajk0DaW7W56hzd8=
X-UUID: 26cd0758738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:646277c4-9eba-4eb9-97cc-c44329b1bfc5,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:9863bd1b1b17eaa9329cc40525016c7a,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:81|82|102,TC:nil,Content:0|50,EDM:-3,IP:
	nil,URL:0,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,L
	ES:1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_SNR
X-UUID: 26cd0758738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1728304931; Thu, 07 Aug 2025 20:15:05 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id DDDB5E01A758;
	Thu,  7 Aug 2025 20:15:04 +0800 (CST)
X-ns-mid: postfix-689498C8-67532670
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id 76606E0000B0;
	Thu,  7 Aug 2025 20:15:01 +0800 (CST)
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
Subject: [RFC PATCH v1 7/9] freezer: raise freeze priority of tasks failed to freeze last time
Date: Thu,  7 Aug 2025 20:14:16 +0800
Message-Id: <20250807121418.139765-8-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
References: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: E98AE40005
X-Stat-Signature: camtk6swjqokynz4sjra6i4m3d19m96j
X-Rspam-User: 
X-HE-Tag: 1754568909-932436
X-HE-Meta: U2FsdGVkX182aYtQGgeQgIHvhEO2ZM0kvjXPQcnreU+c0fd4XzgXO48dp0kB1XvAjAuiSiYI8+TIuFzRZLhnhZB4jny2EZ1UsOROPbq5RaNt6nCCQTvSaDQJUxEgqg9mcFgq1GQ7vCTVLpBlBl6LpjKjmHxUQh0S2+sNHKGTRdxOvpOrVjBsK9XlBecoKDwRx8iXxrkEKPRMm/DobqVq/YcKIQxSf3PwgHmZiQGMNOS2GF9HQbS8cRljCDSBiPCBxT3wVo8fcpx6Z1JAI/NEIoBVGrIDuNP2x9RLNoS0nT0w9otcIWNHltqBHxiZP+xTbC7VbfPtkKcSMWmzasBU3DyekbpBo4NKA8doA1nq0Xnw1OaIq3Hqa6DnBIBDdLPWtgv6EW0wTKxtA7MR5yhF0nMHn48zB1ZNkDFeQskDc6oasJrLE+e3p635TfGvWVdunCjYRH16EQhByocgQy33OhMuOGEAjeUbTgz1FAobm1dHFjgvY48T8Be2XvNlaCO0hn4/81fwrA8Tm7XDIH3mJMkaS9IziCuMAIOZrOUrnOp4gKIymX/ipS/2U9WLSxPsLwgPjEvW3+jh/lBoqCgSBdRaYJIhv8EDIwAxXH3j1Hlee7YCL2ZYBbhvd4e+mmOrj0UzwkhNlQ2ZNbC+QlV2SaNPn/HsBF18vvwM6quMrYwO6qmFieqwqWst+UehFf+PI1z17IhRO08M0IDcH4Qx/e4otzZ9MOidbGB3dPxAfMXktuK3z4+4y6K8WV3RL6NWHBNanPYtOcQrrGSbV/SrKJHVAtJ3Dzdivp1Mgo5A5y0msB5W1N9vbjYC7YwLlMLDNlO1HuolbDyL1I1n58Aj97xq92rHJSGsZ8AHD8SwTpTp2anHg9ucJg8sGWipbIgYLmY1S2jJJP5dZ/4HSdeVq9A1/PRe4OnqehCdXWG5fqNsPjsilv+TOc+mRDr96Utxlph30TfSG04WZPoAN8H
 YzPTJegh
 SBV/yDAR5en5Mpy1iBF6DiTX2QuZH9Dh2pmkhQKOZYqewihM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If there are tasks that fail to freeze in the current suspend attempt,
we raise their freeze priority for the next attempt.

This change ensures that such tasks are frozen earlier in the next
round, helping to reduce retry counts and avoid persistent D-state
tasks due to dependency misordering.

Signed-off-by: Zihuan Zhang <zhangzihuan@kylinos.cn>
---
 kernel/power/process.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/kernel/power/process.c b/kernel/power/process.c
index 21bbca7040cf..9d3cbde905b9 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -111,8 +111,10 @@ static int try_to_freeze_tasks(bool user_only)
 		if (!wakeup || pm_debug_messages_on) {
 			read_lock(&tasklist_lock);
 			for_each_process_thread(g, p) {
-				if (p !=3D current && freezing(p) && !frozen(p))
+				if (p !=3D current && freezing(p) && !frozen(p)) {
+					freeze_set_default_priority(p, FREEZE_PRIORITY_HIGH);
 					sched_show_task(p);
+				}
 			}
 			read_unlock(&tasklist_lock);
 		}
--=20
2.25.1


