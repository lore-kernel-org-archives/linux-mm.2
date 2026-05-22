Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16B54CD5BB0
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:11:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8114B6B0098; Fri, 22 May 2026 09:11:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C2676B0099; Fri, 22 May 2026 09:11:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6D8276B009B; Fri, 22 May 2026 09:11:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5BD6E6B0098
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:11:16 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 335971C0705
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:11:16 +0000 (UTC)
X-FDA: 84795091752.22.656FD0E
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 43ED7120010
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:11:14 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dXLQl0BJ;
	spf=pass (imf29.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eqaGR9QC9sk0vele50CdUpWtSWhtR0zZvI8lmeOz5HE=;
	b=LSgCjH8fxEZGdqAP/Wg+zU2PxYYtFmrKB7v15JcWfsBgNSSHJUa2HUIBBdw3hWnF58pUV7
	zmHZsum6NBKPTlpXPyzwyyWL2iBW7x371FBRLRUe4TZCtCFDID7cqtSZUL4jlqfqJXSzO5
	/BUdpL23CV1AQKjjzuXa4KZE+uDUFxU=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dXLQl0BJ;
	spf=pass (imf29.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455474; a=rsa-sha256;
	cv=none;
	b=mh5Rm2Af1e/SFTEqLoj92shGUzAI5IixpOsKftftW2qSoxvkSeiK96yr8Pa1tomEtcQxV1
	ol7Mtfe0HiRkNsokvcE1/XwJKa7oN0yNqY8s+La3K+W3WrZDCZgwSP1Nm4yy51+iFaDkSj
	VbcRWU7n3TleUfY+S1ElKVJMKz0aOI4=
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-44e1860558fso4754926f8f.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 06:11:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779455473; x=1780060273; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eqaGR9QC9sk0vele50CdUpWtSWhtR0zZvI8lmeOz5HE=;
        b=dXLQl0BJwTOFdrbvCEtFrzVZQF2KexP+2kLTObf2aQxjXtDwz+XPxD7g0XtT/q92Tl
         /+FENXsidzgB3xHJNiSLy10HPp7NXJhYpJOECVP3hxsomKMlKZzBOvmtYGIkELXTZbCh
         TigleKgpF7eJpvXaDexA3K/kC1xF8RgL3uHyp5SLooCGqDeIFaZj4InB7vtmPQHN9cd4
         mfXEuRB9BuDXQFZ6yfa9F+nKuV3NajkTE62QSCX2bTlYv8e3RwrCVPxxzzcY/CZtfwn4
         r6v9Ua3MT7mX0YzqShc0XGy+uGGH/5J50BqTSscnmYrxjmy7Beb/GTQbultE4ypUECV4
         NtAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779455473; x=1780060273;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eqaGR9QC9sk0vele50CdUpWtSWhtR0zZvI8lmeOz5HE=;
        b=FBhkAxjJrC6nwajV1nKDpj/QcGZbrpinO+CNHJCFQnXQARgNFATP9NKIyBgrvlENke
         U+0xo+CBO4PoGbQRIITV+/JzykOPDNNtSJHrQOfnHE3JY7b4zskDCpjw8ANtZb1DKTBY
         geFvlMdSJjY/IUaVudjYVRd/Qxspm/TxcmRl+tYcLetBIeI/g7OVYMRDjdIUzHbVhhzv
         03mSyfkjKiOASpf+v34G8kSM8O0Gdae+90Aj9Cb032vflbxxPk6WnlCVKCJofuasrR+V
         a/OCiS5IhRJXQKrlfGg5KDagluwtMRNLwndRGu6Xbg+RLXz4nYWN9BcYxSkULUB67izz
         Z61g==
X-Forwarded-Encrypted: i=1; AFNElJ9XGLgmDdpmzp3ABToX9MfGIPEWQunVaOGvWw4GJ8Zfv9AXULv37Ki4x4+AilX24gIyOuiTfs9c+g==@kvack.org
X-Gm-Message-State: AOJu0YyUvhflCY4DiuPA5uxdyIt0wl9dvKDnBTNOQO3TJyh2su86MdMr
	PxozxiLBO3l8P7S91W1vZ8MqOqesmlrrc29ZXO+nzvYWe7cMYfdD+tHx
X-Gm-Gg: Acq92OFUPqbk8MJbQKBhFe8ZMC4KCIF9NeiILXVRZtduMhuYMfhzmlOLhhJ7I65tKdQ
	Ab8V4vNKJiDkA9z0+4e93iqGX4K2p3mH91dI3uz4GAahxPl++KG+GXvKfWZ+KR4N7/MMwS0s61b
	JFi9HH3TjsdhU+bngfvgD7+5GRLZksFaRaq/LtYUXdJucdUOnAt7rIBQlTq46a8Qqi3dp9WbUrl
	HCZwAlgm0570HGAYAHFGFP93ef60G68AeWwiwQ1BuyUNrIBzBTYxFS85bIB76ngbxwIZ6Jd67rx
	SPiWfAImsO6KQ6byA9VvduIMOoHfnH7y4qR++NMiHhWfldQa2zhZGfQOvASNUCNpfkEjd+5buyI
	Z1H+Ue8aHkNgYnBhuPC2lfq3YFk+Lm3uAgGmofXhjSGUP6bwwUHWransSCjj1/+aMO4odJOjJdX
	WFujlwkKMheUoukDeyE50NlkNgfhz6cpHx3RX7UH4eZTQ6hJOjjw5RhwX7YGmX0iI=
X-Received: by 2002:a05:6000:1a87:b0:43f:dd91:b022 with SMTP id ffacd0b85a97d-45eb38d7d0emr5367027f8f.35.1779455472506;
        Fri, 22 May 2026 06:11:12 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm4091262f8f.30.2026.05.22.06.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:11:12 -0700 (PDT)
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
Subject: [PATCH v3 2/2] fork: fix default_timer_slack_ns inheritance from RT parent
Date: Fri, 22 May 2026 21:10:00 +0800
Message-Id: <20260522131000.1664983-3-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522131000.1664983-1-chenguanyou@xiaomi.com>
References: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
 <20260522131000.1664983-1-chenguanyou@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 43ED7120010
X-Rspam-User: 
X-Stat-Signature: iu6or1q5eagmfigryhswqzn4yzcmfkb8
X-HE-Tag: 1779455474-708981
X-HE-Meta: U2FsdGVkX18CDlxENqSXpXNwFiSqrsWvnXaW1zICHbOrkqUgiQ7UtXeseJHs5ZJ+NvDV4RlXrAscQYAxSOT734fHSKhR1pD72B5WCOzdn2BnKk3nUCAtHmdx4oleIuee4pZxzV/W3WLOjZGH0O+DS4cJmfzknHUj8lP2TWppg+M8F2GQ646CtFbd330c8b5jKeGcseqOVJQzMd+FzqI3FkGbWSYGaTCl6lVOrdpCVI/9OXpYZXn9fisdbX0zeV7CrR4zHrlk/HbX3utye84ATL8Dh8JttxRF+pGPop3MSaR6NR+v5Zoz6sbjEVW5HRCUuK3oTIPMn3W8VBEFE8g7iZp5mG6S4rWBDWfVNdDZScqiKdfowk59u4+msGGOdF7gzobqUrkPChilOW5Q2/pN3iuR1Df2Q6M634LLLYPYzdlqNdGhRHuDf0nCtmhA5Ki3C9UsfFkICFAPPaMAh+MEM8vVZSz5huVJXky25wGuAwBN9321GOhqA4OvM/abrLwARCAMPme7HS8GUWHYftr5ONpv2gHWeFd1M6v0evJpssmnpw684Ny5q3laQGgzhGSSVayvILyrq856N1kaYBshLKrDJgC5D+2paijFfa0LoGmBtqUTbLPMDqeLiTwcpzjr+eblXicO9MrYwNo5ax1Isc1sF00meL5M8KLa+c48njdaYCBFi4wZMGlt1qAl6/QYNKmudWRzaOZTNylL/KlziWVyo859u0luf2oeYXQU/jqb6B4nzJrZ2+0EcQwTxb08Qihvsodq/vFY6F18FJTup7tVRHr8sosYY06aoiUZFGRzpindqbFLtyJaN4ND5Y0q/skSwZFuvjcWWCjqD2OosXtgEZ21jZPsFuz+SUe4G24Py/ToY909Qq/t8t0f9jGZE9L93Jd2pKcamHBoXYjUtgbnMqhqhgcHmpQUEfc5PyxtmbVz76WvVo1H/lST7XFFSk5ztyOLMIoXIIz5IHo
 1DTZV/ON
 6lnUlGXkXdGxL+jC2gnvEtPueywbV/pt+xh498F24H+F9sc7z50m0A4vwWyY5RNg5ztb6byHNJhGkkhE/0+Rwi3Y0FVPqcHrS6lN7+Njf+OcEvGd4uQaOFyAm/6xWZT7yy+21MklA3nedIQbyQfkzoh26mJ6P88u4R7/hWbDQapYZyuyFnlQuVTvVSFhTvc4B3EaSztk3E5pQzxlccxzu/UnM5iPoKI7gpXRxnOGkdQGHdoYGTTXRb8j2159O6Rp0VAqMdZqla0hJROiGTDvVCYleulIT2kMkKopJA98d4laMS5vVsXQI2g8kzDAQM77Xkpk+nKOEGcvp72ICZmxfWqqVNoyzIDkGgaTMoKDSbNsuF5TsbS/dwnWq8VqAi+ciLywr5YK9bgLfVR/AKLiqHxnQQBqEfa5pAz92qTYdJ8UZ/FUzVpfuiqyHqW1z1y4s+3+MiztLtjsgK4FL51T7TnRMHJ+bsV41aiIp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Per prctl(2), "Timer slack is not applied to threads that are scheduled
under a real-time scheduling policy." This means RT tasks' timer_slack_ns
is forcibly 0 - not a user-chosen value but a "not applicable" state.

When copy_process() sets the child's default_timer_slack_ns from the
parent's timer_slack_ns, it inherits this forced 0 for RT parents. This
corrupts the child's reset target, making prctl(PR_SET_TIMERSLACK, 0)
and sched_setscheduler() back to NORMAL unable to restore a meaningful
default.

Fix this by using default_timer_slack_ns (which preserves the pre-RT
value) when the parent is RT/DL. For non-RT parents, timer_slack_ns is
a meaningful user value and the existing behavior is preserved.

Fixes: ed4fb6d7ef68 ("hrtimer: Use and report correct timerslack values for realtime tasks")
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


