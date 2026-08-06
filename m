Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90643C561E6
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:20:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635586B0092; Thu,  6 Aug 2026 04:20:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60CC76B0096; Thu,  6 Aug 2026 04:20:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 522AE6B0098; Thu,  6 Aug 2026 04:20:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2A81D6B0092
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:20:38 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A384B14065F
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:20:37 +0000 (UTC)
X-FDA: 85070148114.08.8000BE9
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf02.hostedemail.com (Postfix) with ESMTP id DC2BF8000A
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:20:35 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FAG+h92u;
	spf=pass (imf02.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786004435;
	b=SDpAtRXtZvlwyYan6Z9mNDLB7Lygg6xgFSn5jlPIqcBCW3rYLBTchezzj4v0bMru/MI3+z
	NMehbFeqD3AsfGO8fAu2k5CD7gTbHOHBScptwpOhmx9VkOKMH3hEhuRJhoxhKb+ysMVI2o
	vBXDUcKE0e6P4E7iVjyQjj7hUudOQSI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FAG+h92u;
	spf=pass (imf02.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786004435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=6O14WmRpvf4dR45EQdvDWTWI2XmnvuZPqONMvf0lhh0=;
	b=tkyLG9ccDU0/I19hmiTTTiDEkzlPhUlBvrkjh4SSymiqvREOvcsoAM0uWB2Q6XalOLGQiU
	Isfu36chT32OuaSEJGoF2/iVv1q0kz2No1RdOT+P5ubDRfYxQ2iU4zRbUMJbfUy+T1yKp2
	aHetmIPgVWRVKWDFcqo3bY8AdXudbj8=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38e58034d05so1739301a91.2
        for <linux-mm@kvack.org>; Thu, 06 Aug 2026 01:20:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786004435; x=1786609235; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6O14WmRpvf4dR45EQdvDWTWI2XmnvuZPqONMvf0lhh0=;
        b=FAG+h92uM4KvRg6gAvV6m+1JA8V7EyQnaRx/zoScjN7hD2hNzvmYgwaXkR2U0heVMX
         aDi2GEEvfg90GavBThMtd4ZyB/DsdDXLQym0qyfROB/ChsAWC7MrEmtz4Jn45qvY5/ZA
         wt3NoJ06sfpAQMdk6Ww8odNtDz8XZsLTqREK6Zr5eHFD1oFROcPLbGiYUQSDfSx3xSmn
         ZvfcKRjgNnpIFFsqFcntlmATswoBT+3pTiBZyhMC+6nWzhPvniTZXa8bAmfewIEObbOY
         gStR+m1Su51oY1Y+4g+96B0N0vNh89kKds184AnVark6XAK5GAy4QU/o4m0HzAUNAgRF
         nzqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786004435; x=1786609235;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6O14WmRpvf4dR45EQdvDWTWI2XmnvuZPqONMvf0lhh0=;
        b=XFJ2+xwsztGNKHHe8BO9JMSuGSnYYbQnBI/RY/jCZsHSOdWmdBsgXBO76BVsNQMCjc
         WNvopaFfU9AiZghg2Zk7PF+fjZvIrtkw1VAWwEcukFeocJivm9yg7kTa2hZ/fiSXoHe6
         X5w8T2B0ymNIr8UPjoEV2KAD5oiip4TgYv3K1o+0aaVGPfe5IH3X8LhqmaFgItpmPiAB
         +r6otIdvUr9yveqTsZoIEYes0o84VluMFN/fFe8/wdeoYxQTgAYXB/WI0ws0SL4/X9Ak
         o+BqDwjq7xDpgRHZZaUB36M2XMpberA8s7xjzw4FIb3O1KhXWg9AaFzMnves/d/jqVsV
         p4Iw==
X-Forwarded-Encrypted: i=1; AHgh+Ro5ljwMUhBdQ+9UQafNJC7KSCFVo6rXXT+CqbWqlMe1SDSScvUJ4efqUtv8otQ9h7UFZCH4498w0A==@kvack.org
X-Gm-Message-State: AOJu0Yyqjy75h0Cj0iUoCIc1r6sxPKL3gQ/+ref7L8J3QYvWng1YTqNN
	osNo/MEaSj0E2Ck1m3j0V1Bz5IxYtrpHNRfALjBlb3fXoEv7dsnGhJtk
X-Gm-Gg: AR+sD12XqqVfLaKfTycp8kdTLRQD2Rj/VGp7yTgS9nhj+1PVZkNthdSOB7sLB6QD3f4
	hFbmtpmtTbBWfzfhgoB257mj/Xmk8Y+IOBvcGVfO/YtaG4scaCiwajV1AUzCDuBo2EZ2Mg/eDa1
	2h+8tUKrZzvnGmw1MY7y5339jaF+xk+Szd4XWdzt5+snvL0ysSgNZjEbJCJDiS5JsYMG79GEpYu
	cPn0vyd57vhjKt2CXuZKKLXQtdyevx1CyVnGw0TGme1TwHwx4YsZa6BC/CK9ttGJSDJez5ydvDz
	FpeykkCa7EwHUcpOJYVUprLo5V5f0ZJI5gIvL1hh8e+tjLsdRigY3RD+JIePZwIUW91JHoWqTOR
	EBwpm3vJvQhZ95Btw/447N0KN8xQto2rX+Xt/keDe4UkDR1rD3d7HGJKe0rbqlBHgFBo5Z9wskQ
	vZXQjv6/Ft4kwcLUeH3AmNLCEYyme5oD5JhAG9uEPnjQi2aR7Doy7LIgyBM6QIDqVs4CpEtvXMN
	7njC8yZ2R++SHM3gAc7hhMoU1nb
X-Received: by 2002:a17:90b:5203:b0:37d:f206:a2ac with SMTP id 98e67ed59e1d1-3903c598ce5mr14366837a91.7.1786004434667;
        Thu, 06 Aug 2026 01:20:34 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d0a9ff6b34sm27660145ad.26.2026.08.06.01.20.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2026 01:20:34 -0700 (PDT)
From: "Guanyou.Chen" <chenguanyou9338@gmail.com>
X-Google-Original-From: "Guanyou.Chen" <chenguanyou@xiaomi.com>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@kernel.org>,
	Felix Moessbauer <felix.moessbauer@siemens.com>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Kees Cook <kees@kernel.org>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	chenguanyou@xiaomi.com,
	linqiaoting@xiaomi.com,
	chunhui.li@mediatek.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] fork: fix default_timer_slack_ns inheritance from RT parent
Date: Thu,  6 Aug 2026 16:20:09 +0800
Message-Id: <20260806082009.144846-1-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DC2BF8000A
X-Stat-Signature: 1j8xahshmi5npo7tq3ta8osomn9oiq6p
X-Rspam-User: 
X-HE-Tag: 1786004435-342866
X-HE-Meta: U2FsdGVkX1/ugzcQjrBZB86nOq1K7F3AtAXMqSjInUFHGnLrs+K3SZPhNhya1zoaYEoVe1gq4ret8wJxEvVzGnzn7JbzdjcyqNU3aw3aoEuF0IJIG5G3RW3Ws2qTfPG/zSCGNu63idbAWaMGM6ZsWyiUuSmRDg+HCJxkv5dptKkeKU4r3uRAAVPdhXvJwPZhJFsvSLjZsU7dcq/mrtdOUqm1qpvxcS9vyOwhyJKUbdheVmikDeixsk25G0qew7ezDsW51AMoukW9A/S1fD2svzaib4SRjHLqH17qOC6+QxmAIjYmIj0VWxKzEBvd7NIYuUbpgANeGUy9pfxlKC97j9hZqp8sSSecJRj4yjf6c6st4K3ZF93fVEF56AKVgwd58J/Q/KXGeUEe+xHlo4FTMpJI71R1FveBb4KunGIgvjEWdZsqg7z+Yb8qoJOZBZaRLR6bd0cG8bqPS8PuPdZDDnqqHQz1XhF+t4+X+4o7Kvl449ctfXsbihKIxB69wi+yybOT43YreZLR6BJyZ4gbDHJudX/A+ancpXZsyHCjFjiWF8NKqtnPuytNSmJdo0dGTo4jPpppVfkZmiJZR9HAn+6Gr3PQY4eXDon0Sg7/kiioolV+XZeWY+POxrB7HoJOVU3b0BrQG7F+Cy8+ntoNOfkCIXl7gXd5VrJm4vqmI4IiiI5fsmcqq9zCRQYamryfi72c9a7hhbqFfuXab3MAWdTi2FKD2DTJQdrvDy4gI7h5hiYUJ6W+e4kgMIai3bTNrm930jcYqa2AGob9SjLZHPeqUA5ktoY+ws4hEJIZjb2f0YXYuhivSwBccvYk1ScCoVhW8vCHGIcCdiOcf+N15ZU+LKquX8aix8ONNDPHUBGaVkUEBbfuXyvb/gyz7tchYvMNlvZOxrE6RKx00ff8XRLInlZKncoCxxzmOSBU/+E+U4f63IxwVwLqXruyfvB+Zf6da/tSRqQRHYdwaQu
 KsLDYFtz
 Z+JQtVDhgeZrGJErcfDK2oxXlIwf8AQVSciWplRrxow+GfYBhex2hUEix1AArbEP7U4+XlTXPgSxPtml+W66aOpYkXTqEt45ThTMtLrsLLGwm1xbZe4WUgpDSFFvawr951hB/Ka0T3m3H0QMqQbfFFuaBTf1Ii71XwXwFSdYCBjsL5LwuNelSovymtVSvuGoGmA18+CGJV6MVoLi/ape3Y8Wb8jEQVbq/dY84QGYepsIs6zFpiFBKOruRNJPSYTeECpltgsgiPbHW7dhHBOuRf4Wd9CcNmnAAFwjeIqTLRB466Chgu3+lRk5/OQadrW+KgVSlqlpEGqneJyQuIeavnPF2H+HW+X49bbFAJ6JSLNNjlLbQpMHfX6jhncqiAGuDEt03GRDe4a8pxGdNZwtjxxfk+k2gn0pkYr5W2i6yLjBl+ZJIbaPvOX1r0VhSPJ8sfrV0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Per prctl(2), "Timer slack is not applied to threads that are scheduled
under a real-time scheduling policy." RT tasks' timer_slack_ns is
forcibly 0 - not a user-chosen value but a "not applicable" state.

When copy_process() sets the child's default_timer_slack_ns from the
parent's timer_slack_ns, it inherits this forced 0 for RT parents. This
corrupts the child's reset target, making prctl(PR_SET_TIMERSLACK, 0)
and sched_setscheduler() back to NORMAL unable to restore a meaningful
default.

Fix this by using default_timer_slack_ns (which preserves the pre-RT
value) when the parent is RT/DL. For non-RT parents, timer_slack_ns is
a meaningful user value and the existing behavior is preserved.

Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
Depends-on: 63c1a12bc0e0 ("sched: restore timer_slack_ns when resetting RT policy on fork")
Reported-by: Qiaoting.Lin <linqiaoting@xiaomi.com>
Signed-off-by: Guanyou.Chen <chenguanyou@xiaomi.com>
Signed-off-by: Chunhui.Li <chunhui.li@mediatek.com>
---
 kernel/fork.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 65113a304518..bc4df18bfd90 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -23,6 +23,7 @@
 #include <linux/sched/task_stack.h>
 #include <linux/sched/cputime.h>
 #include <linux/sched/ext.h>
+#include <linux/sched/rt.h>
 #include <linux/seq_file.h>
 #include <linux/rtmutex.h>
 #include <linux/init.h>
@@ -2133,7 +2134,10 @@ __latent_entropy struct task_struct *copy_process(
 	retval = -EAGAIN;
 #endif
 
-	p->default_timer_slack_ns = current->timer_slack_ns;
+	if (rt_or_dl_task_policy(current))
+		p->default_timer_slack_ns = current->default_timer_slack_ns;
+	else
+		p->default_timer_slack_ns = current->timer_slack_ns;
 
 #ifdef CONFIG_PSI
 	p->psi_flags = 0;
-- 
2.34.1


