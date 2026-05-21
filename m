Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D5E76CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:35:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 45C406B0095; Thu, 21 May 2026 03:35:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40D5F6B009B; Thu, 21 May 2026 03:35:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3235C6B009D; Thu, 21 May 2026 03:35:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1E2FF6B0095
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:35:40 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C15421A0549
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:35:39 +0000 (UTC)
X-FDA: 84790617198.14.C048669
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf24.hostedemail.com (Postfix) with ESMTP id D68EF18000A
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:35:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=stj5iMW2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779348937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ilJ2bjdtasfHYuZJGgma9SqBM85uGWQuyCvdR0Kx+7c=;
	b=EwlokNM9FwDoRIHj20upQjkadDCrYGvltV0Z3IWqPF9zrm0UYBmFt3znBgUOk3vgbSMYgx
	rGPqrFy58KtDG4G1LnL6NCcWAd0vBQN8CsI0vWwbwmcDXWTfbrO5FhaeUw+SNyOm7jnAdA
	0gRqJFlK616WbAeADJ4AR0x5rhhI+/o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779348937; a=rsa-sha256;
	cv=none;
	b=jzicreFDJA0q0RxSCROQVy4L5cqBExK0JkyDsimlYsGg6zUsNZDbZ1DWbzTFBTNQd1CI+h
	Y/8Othf0iO3xOD6LDimGkHnvYCmZU3lKmfLx08P2h0urSc5zxXTfmnb68fbrmEEmp063Qe
	B9tisP/h5vHFsrBBTxxjxlNP9PLlErg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=stj5iMW2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2bab82d75fdso28402175ad.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779348937; x=1779953737; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ilJ2bjdtasfHYuZJGgma9SqBM85uGWQuyCvdR0Kx+7c=;
        b=stj5iMW2m+xQIMEUKWm6Tqfr2KfTMq6uFtGBcy2OIKV4/KVBjCGa4l5IkSJeRFU3da
         dj4iJxjZnLoBGJHyuWWJPhXtgaGUR2oaOdtoT6pXp3FOvjGJvmiL3ezJ6Ll9R5IGD4vm
         jkJI6H6oNfdrkB+SL/6uP3JxhK4orTtega7bk6gPpk1krW4QihzgMK2cQhqJdRoXkPXX
         KqL5mD6yc7Sf9OTiPARvxmfu2pH3eYrEhENDRhud3T1DOLjgjew03fFANKFo0HVoKKPJ
         aV/A4I5cky/ebW10idEgULDH5hflBUeWFVyONOPpyYKiCAOoNGwqUejxj928JW4NFY5l
         wPzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779348937; x=1779953737;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ilJ2bjdtasfHYuZJGgma9SqBM85uGWQuyCvdR0Kx+7c=;
        b=R8LSuanTax0fAez0/k7mI2jVr3Wj6gx+DdfK5W6HHgsBbQn5Mk91J9IQU2zaEuL0Sj
         SNbgiQTOlLUcotnCkjB9KrycKmG4o48oRPVEZXTFsjHzpoFtCQrLkJfzSTAzQNWgQtmw
         Pjelfv8lrRyHkC80+U1/jVq6sAFbGi9Mh7Ou/k7857UyZnxADafnOcFnkL0dNKCqCO9Q
         j7vTjdVzFMcEluPf0oH28Ah+7Z4gdnZAX5Yek3R9mEYmSkh1eXMKHNQTrY06/pnbBqs5
         mnGpQ/HJo51G1rHioUChyFsrZmdtzlLHMkWd55Ayo7Hf1aHYHWd8TLoqg1ajnV8peBgw
         +QGA==
X-Forwarded-Encrypted: i=1; AFNElJ+cCiSwfJoq8Js/pPoNzvnANUkV9XlBmaoKaiUOryYglWRrwSirzD8PZgHQgz6E4XYWz2MVzBz2VA==@kvack.org
X-Gm-Message-State: AOJu0Yyu6yYxd3kcJ99srQiOodNG+bRXNK9iQ7l6CpBE/GxlEkdGUODE
	UEVyrC+COplKiL8TfAU9sDqjz92RRjdCwu47nazoUVGFC9vSN6zch/pZ
X-Gm-Gg: Acq92OGattNFMoaN7NCTeaodTlw99aLeo/0VZwWUbWAjbXYfb9un5TaAbsQIz8QPGjH
	33BDl8LOXlGbqT2s0WyWozDS/WzJ7vgzVwXb7MPmSC7M2xSwbc1gZuJH+UbzkXqqaGH8fbZ1k+r
	R0Nd7RdtPYnz+Z59gmxmgoyi2m3Br/3janJb99IiwHUykOljFBe2WRB4/y4zMvkKp+gVXZn4W61
	qNXzexfT+8eve4Lj6cxm3Bt+xm5eEyADxzANmT1OQ3NVwY3BudKLM92Ya9NPnBWs1oWxWWPOpO6
	qbDkbg3aIF2gA5+QOydGpXR1bEC5AoKRHxBsvWpUVW/LfWlBF9/3bKojUKx8q3YZPs77fDLIqQp
	e3YSwIPJyW1qyJxVy6t83yu5B80A8FVRl8VIXE5bODkthodRjgfT6wKziOtRVegNytY1Ttr+lsE
	qHj8WFl7w2vRcNwGOSF1NO3V4q8MQ4zBlO643xdseksMQzXJKMmQTCXXsWFN+udkcV8EYPtbv2d
	w==
X-Received: by 2002:a17:903:2312:b0:2b2:4b4e:e4d2 with SMTP id d9443c01a7336-2bea31bdb81mr17712525ad.15.1779348936719;
        Thu, 21 May 2026 00:35:36 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bea98ed8d3sm1260405ad.38.2026.05.21.00.35.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 00:35:36 -0700 (PDT)
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
Subject: [PATCH 2/2] fork: fix default_timer_slack_ns inheritance from RT parent
Date: Thu, 21 May 2026 15:35:12 +0800
Message-Id: <20260521073512.1499230-3-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521073512.1499230-1-chenguanyou@xiaomi.com>
References: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
 <20260521073512.1499230-1-chenguanyou@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D68EF18000A
X-Stat-Signature: fou5fx5detqhy3bsdcgus35kufgmfkwj
X-Rspam-User: 
X-HE-Tag: 1779348937-657140
X-HE-Meta: U2FsdGVkX1+XI+pxaYnW3Iy4o0obmacalttZFrWJNLBBAZ6VeFS9F7hfAJUeUmlRxSXPJYHoGUL+PPOf5X0xH4TcIXxkcjLu2QehQNDW++Oc/O/pB/yZGd4Hscp7AnrW/v/nJpUCQKoCjEEDiF3PR84C0EIhWbS4NfPCt8ISV+Z0TE0e+boJO+KQ20lqCPCcDs4Ztn8r3LWfcdvVrkDYMkJbET21zGl0iXxcMW5qOnOJoTx96wAA+z6tSHf3iGlUp3mzQROdr3xaLCIeQ3XAdeLTonTeQu7vAkCHEAMKx+qkV9LVOYRHUDq9Po3ucIlBu3z5oiUh/hCItfNGTX+xqqZ4cH5L5vIYhgSLaonL3q5YX+vC6X5y16UuD8PuKEeIsce/IYJK+idyqhuew6CQT0EZUtd64qnnawXii3K86CFEJmSWvqiQuGLDuzyOSbu9PMrUKQgwK3e+qK4rc7sRpsfmkiVjmSJTzkN628ksVlXcwbOBolV0V4PuhtDeGR0m8kg+7BMTHoblnJ9QBmHpwXrDawxffYTl9UD/pvIsntFdPvWix7q8MRKbqmInMU09fJQrN72kD6sJOXykTxd6GJ25anlX6SfV+tMMj0pC1XgNdUx41bYECfcFkOTDDtwG9Ko88SBmNPbnlOnV8m4Ozbidk1V2EQ5oHkEOV2SMQ7J5bD3VFgR7jE7RZXCVIwIp8i5R33d6OIaHy+6OUeoAXsLsm8XntmebL6qXU1ir/UsL53dkYYClEPxRnlZlf8npQfcuTFBnFqaVhgWovA0A412d4z0az2cQdsCssVH4sN2Bt87duQYIvF2g1Ke5WADNNYU3gT71mybe7IJoHqwLJYtMA+ex28kjI9druwxqkca+S56AplJP3NsqD/GfFga/dp0MchjZNGyb+2zamxXtBPl72+SXTGWPScc0HPgzh+rgWhhoNYfZfLlqmvvDcTh7s6prJyEi23b+mwLTrcv
 nUfvHq4G
 tTutZnGaKChx4fyuLSNUvLjvao8ZRwFnfeafe1Ztk9paJsPYNqmce6+FIlHBF3R4IToH9/iG3e38zNmDqurbq+E3GurdOf5UY8SUuCm43Tz9WWUI47srbpAstPE91zcZv8+TRa7ALFva/SWSXAtltQQKdjjku0D42F6FUiWCsQkaHzS7NFzqSzb6dXdWn5nA2WRXlCJhYNfgJnlm0fHwU4h+4iIoH3n0BVT0qgE4KiymEptu0c6ZxUt9k+KmOhfPsX6ub5YNLiRFvVxhqNsYQfRB7zdeTQCTOIuzdk+aOOWRqHgi0ibLIlltbwnEXBa4NZDLOPpGvBPRKOE/mzxn6mi6mkUVM7Gv+SJ3/E2KVyr7fdtDKo18HOOiqQ/n7u2xIvS3VilHH1mT0FyGFANxar5fNAE0LfojPlrx+hpLCuD/Y3/4AuL7O+e2paO22bsga/wjtUe5j3ARQcUacI8jNA/9EIweap4zEKRGaBBH3Cgfi6mUdiExftnMDZk8xJcXD5ln1
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

copy_process() sets the child's default_timer_slack_ns from the parent's
timer_slack_ns. Since commit ed4fb6d7ef68 ("hrtimer: Use and report
correct timerslack values for realtime tasks"), RT tasks have
timer_slack_ns forced to 0. This corrupts the child's
default_timer_slack_ns to 0, making prctl(PR_SET_TIMERSLACK, 0) unable
to restore a meaningful default.

Additionally, init_task never initialized default_timer_slack_ns (it was
implicitly 0). The original fork code masked this by always overwriting
the child's default from timer_slack_ns. With this fix, init_task must
explicitly initialize it.

Fix this by:
1. Initializing default_timer_slack_ns=50000 in init_task.
2. Removing the default_timer_slack_ns override in copy_process()
   (dup_task_struct already copies both fields correctly from the
   parent).

The semantic of default_timer_slack_ns is a "reset target" for
prctl(PR_SET_TIMERSLACK, 0). No userspace API modifies it, so it should
propagate unchanged through the process tree via struct copy.

Fixes: 6976675d9404 ("hrtimer: create a "timer_slack" field in the task struct")
Signed-off-by: Guanyou.Chen <chenguanyou@xiaomi.com>
---
 init/init_task.c | 1 +
 kernel/fork.c    | 2 --
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/init/init_task.c b/init/init_task.c
index 5c838757fc10..57ff8dae9bfb 100644
--- a/init/init_task.c
+++ b/init/init_task.c
@@ -170,6 +170,7 @@ struct task_struct init_task __aligned(L1_CACHE_BYTES) = {
 	INIT_CPU_TIMERS(init_task)
 	.pi_lock	= __RAW_SPIN_LOCK_UNLOCKED(init_task.pi_lock),
 	.timer_slack_ns = 50000, /* 50 usec default slack */
+	.default_timer_slack_ns = 50000, /* 50 usec default slack */
 	.thread_pid	= &init_struct_pid,
 	.thread_node	= LIST_HEAD_INIT(init_signals.thread_head),
 #ifdef CONFIG_AUDIT
diff --git a/kernel/fork.c b/kernel/fork.c
index 65113a304518..8358df80e11d 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -2133,8 +2133,6 @@ __latent_entropy struct task_struct *copy_process(
 	retval = -EAGAIN;
 #endif
 
-	p->default_timer_slack_ns = current->timer_slack_ns;
-
 #ifdef CONFIG_PSI
 	p->psi_flags = 0;
 #endif
-- 
2.34.1


