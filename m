Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 23241C79F89
	for <linux-mm@archiver.kernel.org>; Mon,  7 Sep 2026 08:15:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34D716B00AA; Mon,  7 Sep 2026 04:15:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2FDF76B00AB; Mon,  7 Sep 2026 04:15:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1ECF16B00AC; Mon,  7 Sep 2026 04:15:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EE0AF6B00AA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 04:15:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 73BDD1C25CA
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:15:33 +0000 (UTC)
X-FDA: 85186256946.23.225B91B
Received: from mta1.migadu.com (out-33.mta1.migadu.com [95.215.58.33])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8E25C80009
	for <linux-mm@kvack.org>; Mon,  7 Sep 2026 08:15:31 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WpbZB8vM;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.33 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788768931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V0hxyRneii9t3SeqCmePWzQPmajNY0VrGmIWpHOOQxU=;
	b=KZxwTxqBch9/o5o//LZqpYMiUN1AkRLu4G8rdAZ2TiXFUC6p4X/paNq5NU9t/ZHL4Hj7Wt
	2X7PGsEIy+Fbi9QadP0/9wemlpz3qCUlmWLIrHT6TG+DJm0d9R3CiCe/VBpwi8FGmBmGLd
	PSBHP2dIDbCpyh7qynTwg5+jQKbCLXo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788768931;
	b=Jbpttt2ejBA1z+PsW6CFP20OxMyzJcr8vlDEiCuBOcTVuBPz+raxRaV6yncgTKg5kjbTtS
	W7pRGhwv2sxwP42fHNMsV7yMrp39yuI4ZFnEPHQFvwQeNfRgBqGiN06yNDw45AwRIZF1j9
	a1HBmDZRaLPBKUTmsPNkDFMET/dE9J8=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=WpbZB8vM;
	spf=pass (imf02.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.33 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=4aeyyo7NniAcYqllECrNMdgEOmExFee2/DggJvrhUqI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788768930; v=1; x=1789373730;
 b=WpbZB8vMV1atTAj+eChqlE5a8sbZp8ATsL8FJlR45iT1eCqql9Z7vil52XF+a6WIzfcKn4gf
 R66TMNwf5wR7Ca9JpMJXHwOg5FmkuAqRSpAm1ZfBi61Xs31woef6EOwGW7XUH1M0pBBZKnneL8C
 654rUfJqyBaPq+fNHnFytbHg=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a35385b3d24bba3f;
	Mon, 07 Sep 2026 08:15:28 +0000
X-Mizu-Trace-ID: a35385b3d24bba3f
X-Migadu-Flow: FLOW_OUT
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Michal Hocko <mhocko@suse.com>,
	peterz@infradead.org,
	paulmck@kernel.org,
	mingo@redhat.com,
	rostedt@goodmis.org,
	jpoimboe@kernel.org,
	mic@digikod.net,
	oleg@redhat.com,
	tglx@kernel.org,
	david@kernel.org,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	rafael@kernel.org,
	gnoack3000@gmail.com,
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
	paul@paul-moore.com,
	jmorris@namei.org,
	serge@hallyn.com,
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
Subject: [PATCH v2 7/8] lib: convert process iterator to for_each_process_rculock
Date: Mon,  7 Sep 2026 16:13:33 +0800
Message-Id: <20260907081334.1152889-8-ye.liu@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260907081334.1152889-1-ye.liu@linux.dev>
References: <20260907081334.1152889-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8E25C80009
X-Stat-Signature: dhi6hm71aht4tyzdwkwhjauhtw6fox5e
X-HE-Tag: 1788768931-747036
X-HE-Meta: U2FsdGVkX1/+ZuvJlGyN8jo7sPUDFBt4VsOS7X7CPk5oHkNgnYVg08W12PHPXwaszDi5N6gxSvU2L0BaOpZjJdtiGp/gC7gR6rhBkA94YtzsaPRX5s1xkUik+SYwREYk3N0BfJtecRZgoNO2N8+cc/dwJsnA7ItAfMVJ1KVB7io0EpILVM4xfyK06CbTU1OiU/0Q2Mm8iPY004UaYXRyYRcI3ip9p+VRfPsfsnH/ZPwbAakrj3DwKNW3x4NCqW4VVXNFIHN3akLai13lZlZzj/nhscaGlTfBaVlnMkGvOzALhm07xd95VaPmPrPOTNNirRlejodbdVVY5BEwEm7aQOrlhWtqJn0VyAUgpNIG+2IsHGRH5+WrCGApFAsCDfNyo89q0pkv+yXL9bzCqtm4b+CTriHzfXWIn6ddRnfY9XnqQApL++ZAtBfDa+d07Zab+I5oyvF9gV3v1Gr1NzDhSL4frDWiWswobvUrtVDWBPU1T2Ot7V8CRwMaVJgbcHNx58WEcsGtu+W40cTp1VYHxuFBueY6SRK9rusYp5ORfLowPbgVY+jb5fhPJWjCGBnup7n7FLG0cIa0wSvUQ4J9x8ikLLCW3eCXSeAGSrv0IPW3tkAgbJt2QefGU+YuDW/jpsZ1xzOxss8gp3QfZiXzy19WIpRZ/uEoarHYaAk+4kkH+AWwZjTZOjKUB86su7hqaqQ1ePcUvyJa/n7nEpPwbxp/C8jbTF2M0kVh9sL0rj8w7pGXUvS9VNB//7BizbDl4HoD8SAbm8VqPprOhGqfU33tfrc+fPyFmTRzVLLABmhwSNHX4ntXwdcznYsOYrh5qBVD6nogObwYxjXDM1XLyNG0dzNz7Zpr+b9Vwp2MKwMa40hXW1R8tAIASZCGjbnDMMOnWXv8PhE9TilRZCEo+XI8h6lKEtkUmp6slFrx/+SgOdVVcOJVYVv2Nn3aQbKMphClSzKcgACPdUSdsnq
 aQauvOH0
 g2yyAZiwDE8vh+caqrw23MzXazwLMeU9lQ4fnfEGY19rmRMMo4EkSvGzwPNevPCZsydkBR5KZRoMVABDjEtqt9is3C+UiUh0GY+AvduGjRgKcF9/yA3xuwWsWf74DtcMnvZcxu8PkzmnX2b51wqyHRFHb6LViapY7RpZO7F+JL23y4HAQSb4ev2+ihVZ7XkWrf7/cxrPLISRL+7wqoXQxnOH6Nvj/y7nnPk7bCC1v3YyWam/1pZKDTxwNAEszybDpRtaoe89CgOk9tyGHHRoAi+CBcby3Jqtqpaj7SfilrPLN3ssoUFUr+PZteQeN/Q0YpqSUK77LpcAjiG/8xDr6xyrtnpQ9wdg2yBwjFmbVbtZggRIZkpv2aO4I3GUIVZ6GpAahoaLSRgDMRS/pEOvmdIlSJ1WKAP+K72O6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Replace the manual rcu_read_lock()/rcu_read_unlock() pair combined
with for_each_process() loop in lib/ with for_each_process_rculock(),
which scopes the RCU read lock to the loop body via scoped_guard(rcu).

No functional change.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
Acked-by: Michal Hocko <mhocko@suse.com>
---
Changes in v2:
  - Rename *_rcu to *_rculock
 lib/is_single_threaded.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/lib/is_single_threaded.c b/lib/is_single_threaded.c
index 8c98b20bfc41..4e7fe85454ab 100644
--- a/lib/is_single_threaded.c
+++ b/lib/is_single_threaded.c
@@ -26,8 +26,7 @@ bool current_is_single_threaded(void)
 		return true;
 
 	ret = false;
-	rcu_read_lock();
-	for_each_process(p) {
+	for_each_process_rculock(p) {
 		if (unlikely(p->flags & PF_KTHREAD))
 			continue;
 		if (unlikely(p == task->group_leader))
@@ -48,7 +47,5 @@ bool current_is_single_threaded(void)
 	}
 	ret = true;
 found:
-	rcu_read_unlock();
-
 	return ret;
 }
-- 
2.25.1


