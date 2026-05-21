Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5F44CD4F3C
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 07:35:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B87E36B008C; Thu, 21 May 2026 03:35:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5FED6B0092; Thu, 21 May 2026 03:35:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4F4B6B0093; Thu, 21 May 2026 03:35:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 909B46B008C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:35:31 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 381428B2A0
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:35:31 +0000 (UTC)
X-FDA: 84790616862.14.4DE3CBF
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 56A7CC0008
	for <linux-mm@kvack.org>; Thu, 21 May 2026 07:35:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FRtvr7Hd;
	spf=pass (imf28.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779348929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2khKgawiyzbcVuXG59I/3ZBJt4O7A+yaGFjk6lfEETo=;
	b=8UWzmik2bb+NuZ/vm0oJr8LtJ1Lrl8X9XNh6CA6HSrznNtbgb9o8ZdhtY3yc0cQnUBU2V/
	UdBjE+plEuv6eAQHwp0mej3HXlTP2VVZcHi0JihGom1jCDb74slzcyNoO7u/Z7O4C0IXuO
	OeR5BOzxm5h+sUYK4+65AMDFPyUwdNw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=FRtvr7Hd;
	spf=pass (imf28.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779348929; a=rsa-sha256;
	cv=none;
	b=2ftH1YDwIC7ypm+wQaufHUNrC6NV1smFGUXRXpY0JAeTifxGHKCrWIqJhNSuZnGPYSWu67
	3wJihHN36LkVM0ZS/tfvSAGPRw7I1IIW0zDKz9pgjdiQTL0dMD8s6GeOGKoun/xND8MMwZ
	prX1LsDdJHVRRE+DO0evJUKK3By/RoQ=
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2baca4df358so34013595ad.2
        for <linux-mm@kvack.org>; Thu, 21 May 2026 00:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779348928; x=1779953728; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2khKgawiyzbcVuXG59I/3ZBJt4O7A+yaGFjk6lfEETo=;
        b=FRtvr7Hdx2uubmM1vIXSg2A2HL6+9ynZOPEEwC1CaezP8M+ksnxOsqEJi7fUd5ttjH
         pYi5w1hTu3eaRNtRioQcf5Jq2m/VR2Y+0O5Yj5yqA3DPLntKkD3Tz5VbVMjcwm69v/L4
         sQpDXwOHb1mrCpVI5fu/25G0XzQ5m69qxP9zFwx1L1do+lel01tyCqLHYScoz8aIU3Jf
         E8zeipDKmV5iaCSNfVHZgLca/dtzVE2ggff3H21f9OTE/AaKL66Bh5rOFK3h71jpGE90
         pXXFOB1EJgiXo0HD9YJ+vhd+KPDBMP2AKnCa4dUnzHCXcWzXcRk9K5esrkT8PzMAW93M
         a76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779348928; x=1779953728;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2khKgawiyzbcVuXG59I/3ZBJt4O7A+yaGFjk6lfEETo=;
        b=JX0CsaLcXeIrD1Gm1+n2HKjo7dgvoM9liA6DtySh16RqfK2EJBHVcOGznpvekMIDr+
         axd2VeriKdL8k3FF7dcXy+1T+IWj/9u3aZJxGpcORxsCiLTgcDXuNObI46SbWwmr2RWp
         dSEZUXcrhN2XBE5YeqvJvCM5JexqYeNRHpR88Ty2H64SNM25lpHPpsNYroBf/rKL9+bw
         /2Pg3XdnXPqUASHX6gP0HM3G9v5rPkehgacJnF3d73wQxvyh7vJKjPM+euEzNrLfQnqc
         H14CF77+xlArP3iUROfJsmS3u+NCTv7bAqWy5Z3sPm3+vhrFoEr+FC1JvfpgK49PiqSk
         MEXw==
X-Forwarded-Encrypted: i=1; AFNElJ9ToRlp2pYxycEsMBk5K5M7/6+jzQT/YNRjkKPKwgbuyCDaWFL8mneoyYOxhrjdOTCXo3q9hNmkUQ==@kvack.org
X-Gm-Message-State: AOJu0YzDzrCR5PcJQsqkL0DIIQdgxtEC2fRDjT8IMC9uNB0bl9ucIb88
	w11+WeV7IAEPmjYOwjkpJGYdwcklElSaZ/KKcbu5FmN1fIgOxMIJM34q
X-Gm-Gg: Acq92OGZxckNkupk3QqBUsKi7FMigbgVh8aI7OwP+nagCEvSrg3RlwWVBpKiKedjKYe
	rmC61zWAAMzf6Ux9Lgcm71XinG0nWz7SJ1fIgmDuHuaOYioW+GTLDwwAjYCJr1F+CIfLTHmgaW0
	QKkIO7hJMQNxIea686pYCV/qWEg+kMUlpV8dz5DyqR1pMG3obLyUJFz8AG7vY3UCvxzHrO2oChS
	uVZsA/QXRAh/+J2WWuDjjue1xW0Pq/wsn2MRAX5GwjtWGaan+Q+O9tbQzgQq91QeCnv32LJqjD6
	BPzwE7pBQ5uY6wKSZegrUHpxlHR6XxlzBQLnT5wejatkEiQHIpyvVU6BS3kZdUUrWoJDqjpadt4
	XRrAHHZmYSA0uT2TSpTB6ZaONhA5ZiRl+KbdNORvESP+6OJMdGM9GdlVaAdHKaxLkhxmS+h7IWS
	QNM29klAQRe2cRre/yPZc8gUj0ecZ9IKNI79jtQEzOGNM5wppWv/mC/1K2fHNqSdA=
X-Received: by 2002:a17:902:d504:b0:2b2:58c7:2ce1 with SMTP id d9443c01a7336-2bea337df8emr18843855ad.36.1779348928139;
        Thu, 21 May 2026 00:35:28 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2bea98ed8d3sm1260405ad.38.2026.05.21.00.35.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 May 2026 00:35:27 -0700 (PDT)
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
Subject: [PATCH v2 0/2] sched: fix timer_slack_ns for children of RT tasks
Date: Thu, 21 May 2026 15:35:10 +0800
Message-Id: <20260521073512.1499230-1-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
References: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: fcksoimsrksf45phsh1a1e45bdop1btp
X-Rspamd-Queue-Id: 56A7CC0008
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1779348929-751308
X-HE-Meta: U2FsdGVkX1/f11ogtDAVB3ku8MpaOezF/Em8DaN+onYPGCc5LRP0jw1uvLfV7/bnIWYKlKHxn+u7bWAJO9m4zQ10tx7prTQ4qP9tLqvXnI3c8iY0F39+0iBVluGkMiDWb4mmOcb/xMXFRDpYOLlWZHvOuOlsUPAOzA9q0x5/c9KJYMGXmDyB1Qo8JvzQfAryVz9t4lxMuXDPob/p305ITiOonDEyu8GXAM0awPQSZMgqlhojU0LWHZM6yY7nNCrXos9rnqiT1hJiiZ4nWB6bTQRLpPheBwW5Wt5JRdB+HoEAm27YPSzKVMQZdb2k/zMC6Sfv0bqBBS0/QdsYNbvYfeATN2bHDkY0JYKmixtxfsUOOU8PLsCY2oz75LgaTbhlECZnCzAwkKxomOo1ouL1euN1xHa2BDsQILLlwgmbCtdJTfDbSJQhCZSh/30Lwg0SF6ciulkO0NQMbSlc/VHLt46ttwoyOoGdsE47fqr7bJNW2AEEUn/IvMvk/PUdff7lSalCfPm8rp6glwcA6CDsQ8egvPKnA+h1ves3gS/yzu4SA/eFfnrJFtBtLiRe875tN173vLBE5z5sGqyO3sPOPLa9jq/gjjgXApbWqrxlWEeqJQBvzXXaLfdUvyEr3MGEnqsANIum5CjbEoBDBZMv4nfDC8k0IHyNic9JU0iy4U1DyrbY9mQy4L+Df0FT9oxFfV55o2tYLDGBwMIhpMJR/5dCOsE+batEfhAKaYu6K19aKISa8l/UtcsciLeLymiYLNBHxGAJBUGrObI/CxuLtmvVc3iKaRAw+O42vnF1ya/ITmK3ZlrekJf12xckbS8cjdKz68M3AoIWG+9TQTWIKXn7bZ03a82hsWPDjipTqLfAp8dofcFJJJpDakmGV2i7MSfrFvgx2upwwkcOzRBW1F5O6agctt9+90/QHEx+PxJvnrWCkVt9/oljZa0RyaZUhA8Tkl3k+ex84gOJe/p
 YnSBNJAB
 L8KuEIgsab6Fg/xP4UQJP5e/kcnswTfos2eDvIKsReLKCH0LjHj7ra9Q9FMC7hGCNrAxkVJrI5jzEYwWgGYMBSSsN9ksjoWBsip6MBLiiposVcFdtn5NvtGYmSNtim6fM4HiBzc0AbMGbN+K00ntxAGchNTUxVzTIHdEKfthUjxs4zmt09A8L1NoA+kbGXU0W2203ezLa9BgcHjNrZojgImQmgCxmORDruWt6dvO8JHmEWd/3XIhkPphn/gsl+U2Ougq2FbAi3jGFFnzeQ4B4YKL/xoVsgkObyAVGOHLeOYaKhntOpw7zlVc2KQglR7PhV/o5zAxNg0l5okbHIBh2a1uN0ieE26cScl1axpzxWzUzTGzGrzYqevMs1n7cpE4dzV6Zv8xIWQ4aMSA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v2:
- Split into two patches per Peter's suggestion
- Patch 1: pure bug fix in sched_fork (restore timer_slack on reset)
- Patch 2: fix default_timer_slack_ns inheritance + init_task init

When an RT task with SCHED_RESET_ON_FORK creates child threads, the
children inherit timer_slack_ns=0 and can never recover a proper slack
value. This results in ~2x more timer interrupts than necessary.

Patch 1 fixes the immediate issue by restoring timer_slack_ns in
sched_fork() when resetting from RT to NORMAL policy.

Patch 2 fixes the root cause: copy_process() was overwriting the
child's default_timer_slack_ns with the parent's timer_slack_ns (0 for
RT), and init_task never initialized default_timer_slack_ns.

With both patches applied (RT parent, RESET_ON_FORK, 32 child threads
usleep(1)):
  Before: child slack=0, avg_sleep=38us, ~832K interrupts/s
  After:  child slack=50000, avg_sleep=88us, ~363K interrupts/s

Guanyou.Chen (2):
  sched: restore timer_slack_ns when resetting RT policy on fork
  fork: fix default_timer_slack_ns inheritance from RT parent

 init/init_task.c    | 1 +
 kernel/fork.c       | 2 --
 kernel/sched/core.c | 1 +
 3 files changed, 2 insertions(+), 2 deletions(-)

-- 
2.34.1


