Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9DC8CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:11:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E13C6B0096; Fri, 22 May 2026 09:11:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B8A26B0098; Fri, 22 May 2026 09:11:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CFA46B0099; Fri, 22 May 2026 09:11:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7636B0096
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:11:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B3F6F12095F
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:11:07 +0000 (UTC)
X-FDA: 84795091374.15.BFB0CD5
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf29.hostedemail.com (Postfix) with ESMTP id CB17912000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:11:05 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zdr+44Qm;
	spf=pass (imf29.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KmabjaMDg5u07f9PVlpPJqjtwnGDgN0UGdthr0aasrM=;
	b=vhyWr9937ZQ55pnIgzIOhdBbYN1ZlUTsNPJzKds9qRmEvfZ4rcVOIsn5C4xqnVUr6ZyiTp
	mKpWKJHZhGfzwlqTmt87gOPuRZCfL+O6bH65ex/UAlG+Mi27tcwZ4G13uYp43WkQU0286Z
	62SAbj+AsWk8rDug5pYXe0B6tbHLC2k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Zdr+44Qm;
	spf=pass (imf29.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455465; a=rsa-sha256;
	cv=none;
	b=i0aFalrhZ9pd9tzBe+CSj6EnWUFXGTobGI2gsRoMUpKy5AkSoZQo++0TKJVizdWkddk7Z3
	aFmJe8IlCMV1X/TwfGiFZk5zFFwtp5qC+tBKRjPlv1BpDS1/tjKJPIyak7R0wOjGDPRwg+
	vo8IdTVRCZpHPZb+NXtHpd3F6fCf7/w=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-43d75312379so6159482f8f.1
        for <linux-mm@kvack.org>; Fri, 22 May 2026 06:11:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779455464; x=1780060264; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KmabjaMDg5u07f9PVlpPJqjtwnGDgN0UGdthr0aasrM=;
        b=Zdr+44QmKLmvqe+fQmASKBEyoIS8T60kvAjdOJxtnOIC+2Ty5/34VbwodAIkTRJDGK
         C0lKUDW5cyLE3x4hlWPu5bOn++TWZZcLuxgQ4srGFqAA3JqIWYOJoMXNm+9RoE4cSC+B
         EXERouXoo0jmQLTik2Yd5gFL3KRHJj1D/44tdJoRg+eKDdGcI5hmhnvkJOEdHnFjV9DH
         AL/933HXFM3O2VpShbjlzhOcDZ/aki5N0nPQOyTOnyV7ESZIaD5M4LcIdmRSNExAmeAA
         pIRq5dyt9fiKA1CHaXTIgFb+P9UA8MDjeAhtb+PFi8yh9JLt35ZeUTNgR4Km4uZvUBYD
         dODw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779455464; x=1780060264;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KmabjaMDg5u07f9PVlpPJqjtwnGDgN0UGdthr0aasrM=;
        b=XUq0OoX0Sy5XO7hNzw+X5OYgwdog0Q2QKc2Oi2xDa3PuhyIw7ltzCUEaxFMhHxSxhG
         CzabwnPLKJarrbFo+SvF1SCQlKrOrJYLX5pvLeVFe3I/GS3yF8d3KEHF6H30dx9eYulq
         rzglg0B+W0SfHgENEpPmCe7SIuolU8W2plaz64pC4V+c2wIm4+5EKGU6Y3NsBRyb30iL
         Zvz+WH4n/yBpmyB+3QAeHFv/r/2Ya+cWP2OCcIqlMmjoA95d5MNtfGfpeCLvZAVpIire
         VHRrgVrlOmV3jYts6ybHWPXWGNcSbEbIP61+C1gVMVJBPoqMpcvaMarsFaAATIWQexM5
         L/hQ==
X-Forwarded-Encrypted: i=1; AFNElJ8M1fsJvztuFLXlJRLLr24ti0wylyE4W6xvpzmW1gIRbZQqHNafVEgObxDQDgNmnO03nHT00le2SQ==@kvack.org
X-Gm-Message-State: AOJu0Yw2ahn1Lmktd85w50nUM87pM9DykDNntfxQjw7azq7ZHfqXSWFf
	C/X2QgEtTaZOADixk79+SR5FcA+f1P0iHt/Wof61eIQqJa1mNo1iZKkV
X-Gm-Gg: Acq92OH/b0yBQlndU5ymAFtwZ1cwqlAdeXN2FkpXxGXhCmulwSkfnoNXTRaSpbVZ8TL
	lpZQmBlqpbRmMvTthwFcHrTAQ2N1c28b0D5dXoxgnteM952VjpUoO4Po15RWMhnWnmG18cPoFTF
	t71ynFXRAO0wllagkG45wXgHEmtTUNE7kL69MmHamTTpxhC39YGNsh4H8A6ukmHf2Q6MRgqmqNU
	g9lNHohxsBNXtxPXyAzYOG3k7jYD3bnu9aaB+ylAclSMREOFJU0CigDFzpJUtkYygKMQ62W5UhJ
	Vd0tJST3vVjDREfHZ9M4umRTOaojaT3A2XMy8FpWzqElmjyTXUqt10xAKdk6KeTMEjjDWk8zckf
	LwQWDPws2wAG8IDeFJOK9Y4d+z7s+i3NP9uees/Ip1hzSuQ4OriT/wTWXdBtagx+9s+EDrrN+rn
	PzFt2BYTJ8h5NpN5KU3k4XSi3BCA8k/nRhTBXip3NF1ZppY50g9bvfll5Vs32Eibk=
X-Received: by 2002:a05:6000:26c4:b0:45e:739b:2750 with SMTP id ffacd0b85a97d-45eb30ec2e2mr5180404f8f.9.1779455464361;
        Fri, 22 May 2026 06:11:04 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm4091262f8f.30.2026.05.22.06.10.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:11:03 -0700 (PDT)
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
Subject: [PATCH v3 1/2] sched: restore timer_slack_ns when resetting RT policy on fork
Date: Fri, 22 May 2026 21:09:59 +0800
Message-Id: <20260522131000.1664983-2-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260522131000.1664983-1-chenguanyou@xiaomi.com>
References: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
 <20260522131000.1664983-1-chenguanyou@xiaomi.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: m71utj1f3btxctao3yt43b8godbs357z
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: CB17912000D
X-HE-Tag: 1779455465-214363
X-HE-Meta: U2FsdGVkX18vI2znjXCkhF9a0wNyqWOdKijV4k9+kgx6aII59kcL6CCSoyZiuBKNySYO95sEHbcTXaoo+s+hi2nhg1sWcMHxhCV7ImjzxLmU36XL5+cHssSdPgPbmYQWKDkNiJ8sS8bR/8ztmGJ7ZM1bmTnbT5EzBP6ldGEnsMhEQHB32aWARumXFao/wgdEPqBBPeE2XYA0VXPBYo9giyh7jtxjkERG9e12n4jlgmCZkTaefbIixB/mYxelptP9ppkSesrCo99UjoFXGxFA9qypI4Ve+Dyn83rdXe14P2/MCcbknh/QS6nE/VitACwNYb08Ho+nTITHGaRL4/+yIvhyg50qAn21vmh47HdaGpNG0OyImYPFPSCefKkA1GEAICYE5D4MsI6V12JKas4Bns8+NUWS4GT5XUsNQzfuwqOsizXknjJtzwzKHNr1mYE6fczWfEEzXix7KjQ3PDcgJC8W1YPEYUK+e69F7LT3YGjMjKXKyVZFXfLpAF2UTEwe+m3cSAf6M/X7tuKWfr/On8vxf/TYk7My3ccl4Ey/CbE6s/HuVy6iZ8FmNoDhwVNqDo9l+ywfeByJcn7K4uj9mCYb2gXyZixf1421xLp48sdAekGDv8nwH34/AA+e0wAglkJgdHlOEr8Im+08iNTMP2ZyMCbyg5Hlr0NQQZmvoiGq+edFMwjtr3VR8XXXLgY1hIL+TP86odc+Yv+9zLLI7kOgdWGTw6YWzfpqdNu06DLa+HKVeN0ZsU/mzONhAR0qsDaWEpKMBVn2sJrTSBByz0ZIChq71h9RTfA/EyrWjNpWmZRNSncfDYln5xf/pV2J7gJ10hAqKoSLk/c6Anh5AC6EE9V/ZzAmHRVfRF3nX5noJbtDQ0wTNyqizxcF4MBphVULJrq4Y4rHFVDKH0Q0ATIxBsRhj2VhTeQtpNTaLdee2V+U4D+kCYPwxoJ5mDrsgKWuLu6e6Wki+aXGIbj
 /3UQ08ZI
 eR0y/NB/OSKU474LXkyUTdGlMrija72uXFxJZW9nCoYXKWocCcyPGTyMqnh7fyuHJMtR+NLNeXA0HI5yEaWjC1OOKSUj5aRDUQpKpnPe8bPiDqR2CtGWawKtaeuNepfl0k1ydUBb5Q0Lz04fFYYobnumxRV0iKFCuykJSFpQS6BmAOEWxm3YDndYfwUGKOGlrZFgye3lYRcCRi7Gb7LISD7b7BNTwQY3z77HZ8Do5VTbTAlmKfnacKuJhiJDS4QgiYJKKtR2LuOeNTCJRksDXsVU39anXVIGC0CS9uctvmuMj7XxeGl1NWM0xfrRfJAYutcASsSn2CS/CvthIeIi/A3vmRfIMK4d3VjuFq15LpZN+jgkzArlu0SXXSVm5LSTKzE3JIWtoWAuKS8+SSl1RdsoT6wNEKRwdwy+2LEUxbSGguWzlFVKBevGeD3M0IG/MRvsI
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


