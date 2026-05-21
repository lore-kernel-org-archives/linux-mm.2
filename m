Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A25AACD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 017206B0092; Thu, 21 May 2026 03:35:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F096B6B0095; Thu, 21 May 2026 03:35:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1F576B0099; Thu, 21 May 2026 03:35:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CEB7A6B0092
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:35:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 860CE1C0E36
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:35:35 +0000 (UTC)
X-FDA: 84790617030.07.FE0D665
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf21.hostedemail.com (Postfix) with ESMTP id 88E2A1C0007
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:35:33 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dUagQGfz;
	spf=pass (imf21.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779348933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmabjaMDg5u07f9PVlpPJqjtwnGDgN0UGdthr0aasrM=;
	b=k2HRquZvZeW5BVmJR71YoVy/7bz9lhAK472CJjfO18aLHDvd6E1D/zESmog7eg0LkrzFrn
	Gu7W7FIZ7/6zongk2CpEhB1O+vY3tfymLuu4Sh/YAAfNPVldFG66LtsAH4UZMXy+pcHBOi
	GP5Jwm2lhpMQOJHwE5qQWsTP+R9xsbU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dUagQGfz;
	spf=pass (imf21.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779348933; a=rsa-sha256;
	cv=none;
	b=scqp7ep5SM4XA47T5ogbqEHezty4Zo1P99B1cK7YFhGCZNwfrQd3T2IqdAPGT8+PoTOR0r
	Q9tcKPxh5v5XtcOV+PaU/yllQUUNa5KSOLDCOjs2nzkqU/kiiFuxI4Pr/Yxrc2wG/fSQyH
	J66CvPaQJyuFGaGD+T2PZkSkCz5fYNs=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2ba856db1c0so42098975ad.3
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:35:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779348932; x=1779953732; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmabjaMDg5u07f9PVlpPJqjtwnGDgN0UGdthr0aasrM=;
        b=dUagQGfz+N/SmmjneF+QDC/qCmpVEDe+ENJpCZUaA92tpIAF71F92ZNPRGyxbzl2pG
         wGPd1V4YptGECCkFLF1wuXh1jMTJPnG6uBufsm0Dk8tXZFOhbUMXrxvrhXCuaqNvIO2r
         yNLxMPOGEDUBeKdePAdnVee36XjjBpnH4v0w1rhrEaIGc0mpklyZUqugJ6b7ZZWoWz5j
         5KqSiatyetr2DWtDSN67flb/0SLx0cTQgEBw3Q+9oCmXkRf1O3pt73PUx/szH9kgjPAg
         Pm5sO3s4d9M+UPbHQdtrlCy6klIWl6Z2d2r12x5QRecN6Murw9aagXfmxgWJBkbwveSM
         gF2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779348932; x=1779953732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KmabjaMDg5u07f9PVlpPJqjtwnGDgN0UGdthr0aasrM=;
        b=o4i/PanV4IzigdpRuCHJkLLUXM7beZuLrcmcBC/1iUnQrBW0JZ0nvUysSfJ6vjaT9D
         hjVPYlMYh3apiaMOW3PJs6m2L4t97GFCzO5EQwiNNi9aufb2ral7t46pJPHiDF7xOdYi
         MVD8eGrfNe9NDBOgIC3jLjvVjHqeeUUREx0ylJyIdNR1bCY/pOS4rrI9ZNo52SFJ0qJJ
         sg1Aycat2WnKEEPicr2bJmj/g7Jfi3fyuEce7YXXZUXauzuoRmXW+r089mjWA7D6mpNP
         hyebCQBq84VOHhKdeDCHlf1vdhLq0KMiEaAViRB6k6NwOIZb0yhmeZ4gkKmFgUyrZ+kJ
         ofAQ==
X-Forwarded-Encrypted: i=1; AFNElJ+AxWMWzKQoD0tZ96NiuyIix70A3nTSjOMdpva1rlxGACLcBFiFXwL/TF2Ze1IW9AoyL406JKt5Dg==@kvack.org
X-Gm-Message-State: AOJu0Yw/U6/Vh6GL5rVu7royLEeZSm5kqusKUaIv4NxJImcoWb+aFDD2
	5S9hP7yVN+k9pnZ3ASi//3vFsG7wOfUdSLW9owIrGe+StYkT0zm/Mb8B
X-Gm-Gg: Acq92OH8NbYL57hONAwuiTdQ3Zj7j96v5u46tuyq+OMVQESiV2100XteyPt7RHB4rx9
	bphUHAUMF5svXmOvro1DOtBuCJbF3/yVFHfA7xVqnzuPj1qvrJRUuHzL5Rv5HN0kxjeiUj61L8e
	BvGTEU6L3ohT3geEY5Hriyx7KPaPxjEeFBKBzrr70Bd748TUObPeDOYUA13iJw+oP5Ir/3JXZAl
	i0bGRESC2QDzB0yAbcH7sabAiw8bES9yc8ZyjrKWB0cNRuOvSwss9UKFKxi07gF9H1oWppr6HAe
	Ovt+cYn521YTits8GN+T/vbfj6jNcVfK7jIRPzpctNJVI4UGATnQDrKZjX+SM7XTl6Dy5ZNAIOL
	5h0bPHmhu+fVrohCJVIdkwNJ8VxqeeA7kJl8T4xqiIpxlvK28Y004D/WdiQUQGJeFILcYahkox6
	u0bIyQmugqSZXyGpWaRvNr1Eq/xrMUuxgnwEgKrkMsY5bG+qKTzV8LgqKaMIQGugA=
X-Received: by 2002:a17:902:e54b:b0:2b0:c59f:3b58 with SMTP id d9443c01a7336-2bea32d41a0mr19148595ad.9.1779348932487;
        Thu, 21 May 2026 00:35:32 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bea98ed8d3sm1260405ad.38.2026.05.21.00.35.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 00:35:32 -0700 (PDT)
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
	chenguanyou@xiaomi.com,
	linqiaoting@xiaomi.com,
	chunhui.li@mediatek.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] sched: restore timer_slack_ns when resetting RT policy on fork
Date: Thu, 21 May 2026 15:35:11 +0800
Message-Id: <20260521073512.1499230-2-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521073512.1499230-1-chenguanyou@xiaomi.com>
References: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
 <20260521073512.1499230-1-chenguanyou@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pd48guodro1naooppr5uh46fwft49y34
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 88E2A1C0007
X-HE-Tag: 1779348933-366440
X-HE-Meta: U2FsdGVkX1/zoqXng5tsu06WEjvBIVbX1TOfDxm66UnRZ8pBvCiwwqs6ckbDFp1oF9k1FSbDG796h123vm1fJKUNXmuu8ssdFgn7CmtN0na+wlJw8HmGku07ahA01JjeXSP415PtmnzZmJs+XGw1jjaRa9jPriAilB1tf2JhgngPEXA/xhwD9e1R/Isb0H4PJ9lgEU6AMgNPVmDaCDOPN75lBPVkvZH028OYmiAYaVuF5QstRJjqT+wlbgxLl/KfuFE4tGLGZV7M9PpLj9tOmf40tHVEq/4qd/Y70yDWk5gjtMxGzvvNXJv8wrSXcv2W/FH8+4FPQ1PB86RlqK6NEUjM08MhqoA432YZAPi/RAoAXAyBkkS+oPFVF5x2j8aFLJ0ssxottcbeYHOnvNvOzOvMfSdNs69h3ti8gE3jdznFx4SyO0+zFs4eQff7F5kfU/1Jj85c7viRqIi420tO65NLbxkHNiIgTDkzlK/zThlgKfENlomfEUrIVDNMXEIuQlqeASJzg1sEq6EMDwz3lmjMubj+W7rYchHnaWcKFTqa5TihIySLilda+vSHYrdIk2beI9CyBwt5kusrU2mEtyQMnjVlpZDrdGjPwVQbB5eIcBYq2KmcaOgoDxp/5FUUF1oSqxObdA7+fQKiFG9rRCdDC3vuZRsrgr1uRjaUCl8ORJ27C0nzel/ZeGDfGzid0zEHxGp6mtY2ZuOCO1cxp6+0OaPxTjTFI4yjJ9LEQQE+xWGD2xhsrF2/7FtjHY8uMKL05HPe69hPd7OmrqF/9CRE6K0eSwo8dkfIwfp1uF8oOU7r2CVd4KdXRs5GwaKq1BvPvhtdoDpjsOE+w3QXg6KVwBWsUzT7wIY/TRe1ZTMp/MDnMgX9+L9uNnrwCPFhEYoEcZyldKYj0WoaXgs4m7lg/iX7qUhwM0lGVymTQeIflSbXWXdNfcy8KBhTiQ6CMMl3McgClLjyymzO6By
 ZAZlH1O1
 Jg4+Jic5+eKIOXCMRjbdLXTIHx/08rLdBYNaj+Ylap3sFzlOhrGUtjLiVNRf80kauvKzbJ3icRh9Im7ZgzPy71HQzJDpdsbAvCUGVm6xiD4LUzBrSvzYOoliw3r8coeGR2KMMAz97KhnU2b/UbCqcBKUONzTzc7eeh6cZ1TKHF712Ni1jLetezbfJbkDLzXbpHrOjwNDKDlLKeK4BSF1qijI4HrZTHzM1FXkXBodwNmSLn7x4xzE2n1qs27NrjdnrRu5q0svM7So1hSUIbXKnHJiEaJYSNdli5jY+KcZEfbWpUUNrpLMxqgSnn50lLILFlQ5eiqh/7v9bsSBkk0x8aeMhokZvLCrHJMvWvYEn/9xU2aJU3oxrHrKUIEIh9XB3RT8mnmGgfWpitfN4EcOD7lNXerCGLfh5AxYSnViLhC6xqkXFnjpm0EW2yP6awiYGDP2o
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Commit ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values
for realtime tasks") sets timer_slack_ns to 0 for RT tasks in
__setscheduler_params(). However, when an RT task with SCHED_RESET_ON_FORK
creates child threads, the children inherit timer_slack_ns=0 from the
parent. sched_fork() resets the child's policy to SCHED_NORMAL but does
not restore timer_slack_ns, leaving the child permanently running with
zero slack.

Fix this by restoring timer_slack_ns from default_timer_slack_ns in
sched_fork() when resetting from RT/DL to NORMAL policy, matching the
existing behavior in __setscheduler_params().

Note: this fix alone requires a correct default_timer_slack_ns to be
effective. See the following patch for that fix.

Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
Reported-by: Qiaoting.Lin <linqiaoting@xiaomi.com>
Signed-off-by: Guanyou.Chen <chenguanyou@xiaomi.com>
Signed-off-by: Chunhui.Li <chunhui.li@mediatek.com>
---
 kernel/sched/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index b7f77c165a6e..b1a241810ce0 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -4649,6 +4649,7 @@ int sched_fork(u64 clone_flags, struct task_struct *p)
 			p->policy = SCHED_NORMAL;
 			p->static_prio = NICE_TO_PRIO(0);
 			p->rt_priority = 0;
+			p->timer_slack_ns = p->default_timer_slack_ns;
 		} else if (PRIO_TO_NICE(p->static_prio) < 0)
 			p->static_prio = NICE_TO_PRIO(0);
 
-- 
2.34.1


