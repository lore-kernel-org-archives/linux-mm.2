Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 781F6C8303F
	for <linux-mm@archiver.kernel.org>; Fri, 29 Aug 2025 06:56:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 169666B0026; Fri, 29 Aug 2025 02:56:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BD96B0025; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D25D36B0027; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BE14C6B0022
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 02:56:03 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6C6C4C05A2
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:56:03 +0000 (UTC)
X-FDA: 83828885406.12.7A25A89
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf24.hostedemail.com (Postfix) with ESMTP id 318AF18000D
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 06:56:00 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=efQSuI55;
	spf=pass (imf24.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756450561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XiR1glQQMxhqQ2yDLpSdiuzwavHhKmoaPSOcnK0KdY=;
	b=0mD1WePxHqAGUGqj2v9ypPRAws3PzLUDfN+pzYBLEhytMTG8YIHjjzLVrxFo60QzT58+94
	E0awJ8oWzCHtc8hQlUoRdT3twJ5A0fpAxmRUrlULo4/wA4pqCa6ng6Sx/j4susDuuw1SEB
	Xhs8wrT3aX7BSFVslaGZJ5EaVRb2SRw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=efQSuI55;
	spf=pass (imf24.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com;
	dmarc=pass (policy=none) header.from=honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756450561; a=rsa-sha256;
	cv=none;
	b=RhXaWC2KW/fn+thXaix8l03mNfaNDkJvhZaI1RCribzVnux/Y0tsO7LRur/TTxVriu2Xkd
	IuOx99FzwyZU88MOB9BQVvVY+U054AvhmmIlijIuASzqpf6da6HxoXiinJrXrq2JRtio6W
	odObOP7nIRP6Mgqpe8k9x9fWjoWCd5A=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=8XiR1glQQMxhqQ2yDLpSdiuzwavHhKmoaPSOcnK0KdY=;
	b=efQSuI55EPjgLOtZF/+TWbBl7H2uPLBno5fBnBEbi0eDgbrTmxcsUnMTthMNoOuiSBljLKS92
	OGmO1TBaHImgiEk8jygM5rUKBWLAHHOmR4ZWgRVkM8kePlPezdVw+RGN2A9jHHWcvpEe42orskY
	8ICPSxcIwqcZfnNe8ukdS9Y=
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4cCpv369CkzYlbJG;
	Fri, 29 Aug 2025 14:55:43 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 29 Aug
 2025 14:55:56 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 29 Aug
 2025 14:55:54 +0800
From: zhongjinji <zhongjinji@honor.com>
To: <mhocko@suse.com>
CC: <rientjes@google.com>, <shakeel.butt@linux.dev>,
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>,
	<liam.howlett@oracle.com>, <lorenzo.stoakes@oracle.com>, <surenb@google.com>,
	<liulu.liu@honor.com>, <feng.han@honor.com>, <tianxiaobin@honor.com>,
	<fengbaopeng@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v6 1/2] mm/oom_kill: Do not delay oom reaper when the victim is frozen
Date: Fri, 29 Aug 2025 14:55:49 +0800
Message-ID: <20250829065550.29571-2-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20250829065550.29571-1-zhongjinji@honor.com>
References: <20250829065550.29571-1-zhongjinji@honor.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w010.hihonor.com (10.68.28.113) To a018.hihonor.com
 (10.68.17.250)
X-Stat-Signature: yf4wwe51thapnxybrj8sn9st8ysp9ia9
X-Rspam-User: 
X-Rspamd-Queue-Id: 318AF18000D
X-Rspamd-Server: rspam01
X-HE-Tag: 1756450560-560004
X-HE-Meta: U2FsdGVkX18eZ040VnR/NCm7mJliYw2WJkXsj4AY8Eh/akZemYvG+2TPRD+WJjay8dP/Hup4VD2xRZrHyTguPL9EeY9quxVs4iDF+OQ7LibsnqLXEwC/zdOvpsyd984koPVBFBuEQU+/mWqdT5XX42Z52b1Z3/SW8y4yGiizVf5zlyt8N3IwbIZRDVnwwZiP3b57JckuyqtlUCidRdHymvDIPRIupOgvVBpbLXoOC4rk8QQqYluDzvQOtzYyAoi6VlmBATqa1D/edF969BLqaKhOgAuk1rPUumI7QVFCnmu1wUTmoaZquELOgKrA9Z2Ur3XvIynaUIDt1f1Utq2+pCGRs0eTsyljP2RLYczD+zmmfeNFVRxLeV2fPxWtYzdk715aZb4WUSpJPyVKslsJphkgdoMfjIM4RH3KbokxGyIe0MhbaC2389dl2E9xvCBfcNdT/oT/xsm3jHVevu1Tyt6Gn2BePkWJmKM9Ijxa67fOONJKk2ou+E0FNxzkojmeYHW0jC7SnbjiCibvDzqFLVVJuP/yzYnbff1jqxVGh42YCLenZtZ13bASJEDzlrIaG1xm39ogl5A2R4saVtMHpht6nrtngyMf0pz720M9K3zDV8LM2e/pVz3o2bpFwIlnQ6Cpr94EkUW3JIcwuBDPjlWkjtWXWCFV2BKM4FcbafjjnfHshmFhu7dkoC8wlyNCHuNqxsDKB755ENbPa8Pnmc+6w0p0Hv6R5acZsV+imvCTbMndj3Rmrbfpav+PGjL4hdvV/nw0FAcF5UusZ5qGvd7Q0VS2BqrYP6q0LklFMqPdAt9oA8KdORN4M2553ktsMgnOcM5cmhgqgiemNO4kCJbfKyN+L7txIQS99n9HaB8fWS8q92oKCV8Ak/VL9r+4yK1IEIGBBHyx2BFiKUDSJAmFWyRS3k0Jddh8Ntvmcqt3dYka96Mx7bNTL3XcKJwU3LPOAp8qc8/hhUtiL/U
 BsZ5ajiT
 t2MALn7nSQ4tyh3fxgdq8aT/2MQKX+srqG1DkTI5mAJP1DqtmzcrMLyUHeolHpRx6o8KrX9/hl/4wuD3KyFk2nDORxS/svsXVDRPTISAQIYSif0/pwyRpOpc98sBUIvYr2SoF2UtmSWd4uBt1EGF9kSbURmT9B+/2I5TmIRzOJkQe0g93ElGcztdwC1Kt/oBUuP3F6SOWHpDZ+Bw8LH5pLwQJGIkPsDoMr5nNg8JzgkFQr3XLUjVZQ+4SKMpFu8oSs4qUBGhIjfDRUyetCc25DBAJuFmC4ejIVwrBvbITKf4LJAPlFs2GTrO6v3m+ozBlktjV2Jgpg9FFyQTFpBW4a0Ct/x7WT2x2IvfNUUBQhCeV0/1DT/3aAWws8Hr3XYJAbSLxytXkGFIdQsk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The oom reaper is a mechanism to guarantee a forward process during OOM
situation when the oom victim cannot terminate on its own (e.g. being
blocked in uninterruptible state or frozen by cgroup freezer). In order
to give the victim some time to terminate properly the oom reaper is
delayed in its invocation. This is particularly beneficial when the oom
victim is holding robust futex resources as the anonymous memory tear
down can break those. [1]

On the other hand deliberately frozen tasks by the freezer cgroup will
not wake up until they are thawed in the userspace and delay is
effectively pointless. Therefore opt out from the delay for cgroup
frozen oom victims.

Reference:
[1] https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u

Signed-off-by: zhongjinji <zhongjinji@honor.com>
---
 mm/oom_kill.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 25923cfec9c6..a5e9074896a1 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -700,7 +700,14 @@ static void queue_oom_reaper(struct task_struct *tsk)
 
 	get_task_struct(tsk);
 	timer_setup(&tsk->oom_reaper_timer, wake_oom_reaper, 0);
-	tsk->oom_reaper_timer.expires = jiffies + OOM_REAPER_DELAY;
+	tsk->oom_reaper_timer.expires = jiffies;
+
+	/*
+	 * If the task is frozen by the cgroup freezer, the delay is unnecessary
+	 * because it cannot exit until thawed. Skip the delay for frozen victims.
+	 */
+	if (!frozen(tsk))
+		tsk->oom_reaper_timer.expires += OOM_REAPER_DELAY;
 	add_timer(&tsk->oom_reaper_timer);
 }
 
-- 
2.17.1


