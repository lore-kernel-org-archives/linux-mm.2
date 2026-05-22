Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC8B6CD5BB1
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 13:11:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552286B0095; Fri, 22 May 2026 09:11:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 529B56B0096; Fri, 22 May 2026 09:11:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43FFA6B0098; Fri, 22 May 2026 09:11:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 34AF06B0095
	for <linux-mm@kvack.org>; Fri, 22 May 2026 09:11:00 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DD1DCC3198
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:10:59 +0000 (UTC)
X-FDA: 84795091038.22.D523D4B
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf18.hostedemail.com (Postfix) with ESMTP id D84531C0008
	for <linux-mm@kvack.org>; Fri, 22 May 2026 13:10:57 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dsca74MX;
	spf=pass (imf18.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779455458; a=rsa-sha256;
	cv=none;
	b=7Si0zUV8pq2oaOwNM8hI3tkuwQOIsi+ite7zzSEbFw+IInKluaGwb8egCDrLzA53nLQGBi
	UdsPhPkUQFL7aeIeD6GwodbcUAZq9tbE3c7vPMtvlI4bKjDiDTvZSkHzUgSXOfSVne0kLx
	YKMMFlryy7KNi/phwNgiOhaPZaptud8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dsca74MX;
	spf=pass (imf18.hostedemail.com: domain of chenguanyou9338@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=chenguanyou9338@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779455457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Scc6liPjpRoapHz5oNjrV6FTlFWphUlH44wCy8SxGnQ=;
	b=Pqgv+ZRw6qJPUOzfQveMUR/ayulKrK8jZsUtAlm7Y4+ZlmQFNwSPYPUNJSmnGuXCcNhBQp
	VaKVpnjh8+vagz6n+JTaRau2mDujCa8PXXzipG7AP/tuGrjcSGqi+ITBLqw2gUJjKqf/w1
	Cuk6nJAaSD8KRzPW9YGoxHczQrruT58=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-43d734223e4so4853769f8f.0
        for <linux-mm@kvack.org>; Fri, 22 May 2026 06:10:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779455456; x=1780060256; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Scc6liPjpRoapHz5oNjrV6FTlFWphUlH44wCy8SxGnQ=;
        b=dsca74MXti4vKRQM5khiMV/z8jNZXdtbD5ngJuh9HfI3KVfxiRIsht4RmiIoX9HNbe
         ijomCpigrt59aQZG0qpvZMt79nXyQJF3uSasZK3+hsvUVOpH0fh7R0nCECTnouqFEa8d
         DjM1x9vdzV+Fw4XUPjoFijm1O2vUHscM2lhERVOFHMLst8XLiSxUEDOYpr5tzswLs8jp
         SZ5c9kXhE5lE/nTpFmgIx5lk9GLvt3yclbqks3D9bkhQQUBaQYYNtAkvhyZkAuF/4DGM
         KJcha/JUDGDAe4yVahosnt5WF7lfL9x41DXFKr4yTYo8SdAiXdICfYdKZefURDTWpmDA
         9Jsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779455456; x=1780060256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Scc6liPjpRoapHz5oNjrV6FTlFWphUlH44wCy8SxGnQ=;
        b=KqAUGFlB+8yvTNZySgEnY7URl+Klz6wc71NWl4ImEimuYBz5+erpE0CEC4Xmu6jxPz
         21dLn5/qxB2U/2NWqGA240ENYwFX1NuH/fUWViBQ/hU8cE/o20BOrtsLjMakEqQviFPh
         psY5pIQl+1LkvR4w0abNVwxuj/sNx1DpOLOKOsP3O7Q+ZoYoV1D2YACE88XfoqdV+335
         poaD8q7B0SpAEHCRFzKBZxBq7+SOYoxbivy/rWdAIPQP/0ycsmep1wFwuoSO13x10TnG
         SUzM0BMi37JqvXNupq666D+5cZusS9VrFMWrcR2cTqwdcPJau5g4U2Dxe2ydt+FEm+HU
         u87A==
X-Forwarded-Encrypted: i=1; AFNElJ8LckJOXNiaj+Q1tqVKgPugEhhW4WuNl0mo5VNk5Sc8nZBoZK7/JHvuBUlTB2Tqo7KH7DLtuAsQPg==@kvack.org
X-Gm-Message-State: AOJu0Yw1sXMo7isnoeBkOE15s2b6BF6LuouffEKT4FVKfYKSQPK9W7hw
	SGI6+fBJ2H4eogHL7NPteWIT5cqICfUKWkW5S5H1rOqYjen2UyyekZ/3
X-Gm-Gg: Acq92OFtFHsfF3v86HkX0xsCtFFSwi7Zo4geaHYD7aXU2E6rYpWzlkqocIXFhzbDlxG
	IErqWdHxdlD9W2qPws4k0yedRb2p31bHoW9E2MWvrIc92dVcgv2QVGyxjKKkxBmvfAFWQ+Ryzg+
	OkEXJqzY0Sr+hBZIiJR9SsIQILEo5zMa8V1TutsmBbSqBsmbTXGSoZEd5LzTlRm3/eQ2B5crf/P
	Xk89oPsNZ5KlagpxUTRsOivFfonX6VtTttmsPlJAOVGOyqjGK8Z85OsYgLvXSsyHW2i8nJvq9Us
	WMeLnaaywrsav297YFyZuesAV/J1KYFu5ihaCK5x3HuMliWmvFXzCdE51ynxH2BpBstURYQ3QxS
	eZPAHWeMjP3S3KxyqPC+Re6V6klmXeFjJcp/ZCjRzavb9iYuAWiLuirQIB+olQwtg6UzAVawKFn
	HSWjytc1Vy+DMMw2cyIfhUh1WaOhFuHi/4Kk5nz0WmjlqYGxiz/V+soibKa4pQ8fc=
X-Received: by 2002:a05:6000:4819:b0:43e:aa88:f1a8 with SMTP id ffacd0b85a97d-45eb30de808mr4947948f8f.6.1779455455991;
        Fri, 22 May 2026 06:10:55 -0700 (PDT)
Received: from mi-HP-ProDesk-600-G5-PCI-MT.mioffice.cn ([43.224.245.239])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb6d5e484sm4091262f8f.30.2026.05.22.06.10.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 May 2026 06:10:54 -0700 (PDT)
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
Subject: [PATCH v3 0/2] sched/fork: fix timer_slack_ns for children of RT tasks
Date: Fri, 22 May 2026 21:09:58 +0800
Message-Id: <20260522131000.1664983-1-chenguanyou@xiaomi.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
References: <20260521070440.GD3126523@noisy.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D84531C0008
X-Rspamd-Server: rspam03
X-Stat-Signature: uyp8zarhfa4zmt15a31aqdg47tssjek8
X-HE-Tag: 1779455457-906913
X-HE-Meta: U2FsdGVkX19QgSSxq/wjZ6+x1KqnI2pGCFBJ34QF4rFJrriBD+Grzhi6BPLPeDdl7A20TYPXPLP7ziK1Iq+vekGcpD/XieOM8yymKeiVDdVdq78uW8m4QGZ7ZD4E/CjxwwLGpnPfLbLBN8t9ePnURx0p5M5JCgeoq6HGlxJAK5d1qAXsoIpU/S5MZReZgOQR85W2Yvo7HyCcBR7nl9PJ6EteYCcONKXSp87ZNlvnh+uh+aKtZn2A8/67abadk3fLLARJtErkP6qxpvqeVloTMvVdgX+6HEE107pe2iLm7MtnSLGHdZ6wU55G3K3xOEhXKcxtVVq2zO+HjjZRrkrIszlwJJP8++oIiXhhH/Kz3ABtYfWsklZZV5Y/bfPcTNdXgTR5nHqbSTrLqeQN11ojPzgbA90NIWcDJaO5qMq/5kyJ/97pIQcES8coNYw4MHLOzj/AN+v4rI7zrE51Zmie2gKgoQsHeWPGozhOcicifl9MjwyeGImonwMPP3n9Pw5UGffkZoHZ3W9VKkdOQm9AFBHJ9drWc/9XXDWJjwLJSWBGrw9qJLIn2r3a598A6kRa+jLMLmIsxkuNhxoTNJLWdxAwTz0scfsKHq/FeqFSGS0Dnocrj90D1+iRB65OoKMIxNq6DeAMccHWVUZfeAg/JifBKOyfYm5KaPTZ4FgT2IMMuRJWuEjrNlwyzwKskF5pQKyCHf5t0Vh0HoMvDbRPr8jPeJuPnpE6vVE+257Un9iOwRbo0IpCJGJFVLhxCYnlBPEusu935ENSGKNeB5/RqiIS1LIz7gMxfMbIyLQmExvMnBF/rrejU+cYhck+iWGpcxsIRz1VG90XJ951cCphyfviqsR3uTM1tvslzM2wcZdVSFGF/5Ef6xfZGfrJFrv5hJAS+ZU8IO0/4D7CcMVqwkmUUwcCpTpE917kjMbU8bUkwGBU6u0VBuRzPUhb26tW2T4UjYGV9YEE3nKSnmq
 AoxU8EZ2
 5qjbwBPTDo8QeH/wdVRyTREm7cfaKoY0NjdgbqPL3tS3aQMOiibx9EMERFcajmbEBh2riZMDS5cM04PSTZpWFgqOn13LfDDN9Xm22Wt+mIaLb725Xu0TWGGsRE7CqApMcVzr1Vy4FNMWzdyXGPIvHuBcXZC4ydlMqYU7Y7GBw9oFIgjn3lOOm4B1eXGP+yHzgePnYMaxpLqWp4LnkrLciR38faSwOULKdhOFIt3Q476LPreJpzI77ESRruTof2YTkC2F/e95KrT3L2JVoDAuOT0sU6AF/ze94sMZP6i5OuUeDF73a4RwvS/uDpU36Pnmb6g+/MPboIpNqrHsMoSOCv1RQzt/PuJe8r3j2T2yuRst+q74TZd2ZwhK469laMR8IkApfTrWcdw4dE2E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v3:
- Patch 2: only fix RT/DL parent case, non-RT unchanged. Addresses
  concerns from Cunlong Li and K Prateek Nayak.
v2:
- Split into two patches per Peter's suggestion.

When an RT task with SCHED_RESET_ON_FORK creates child threads, the
children inherit timer_slack_ns=0 and can never recover a proper slack
value.

Per prctl(2), "Timer slack is not applied to threads that are scheduled
under a real-time scheduling policy." The RT parent's timer_slack_ns=0
is not a user-chosen value but a forced "not applicable" state.
Inheriting this as the child's default is a bug introduced by
ed4fb6d7ef68.

Patch 1 restores timer_slack_ns in sched_fork() when resetting from RT
to NORMAL policy.

Patch 2 fixes copy_process() to use default_timer_slack_ns (preserves
pre-RT value) instead of timer_slack_ns (forced 0) for RT/DL parents.

With both patches applied (RT parent, RESET_ON_FORK, 32 child threads
usleep(1)):
  Before: child slack=0, avg_sleep=38us, ~832K interrupts/s
  After:  child slack=50000, avg_sleep=88us, ~363K interrupts/s

Guanyou.Chen (2):
  sched: restore timer_slack_ns when resetting RT policy on fork
  fork: fix default_timer_slack_ns inheritance from RT parent

 kernel/fork.c       | 6 +++++-
 kernel/sched/core.c | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

-- 
2.34.1


