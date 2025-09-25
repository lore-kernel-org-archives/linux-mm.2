Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 97C76CAC5AE
	for <linux-mm@archiver.kernel.org>; Thu, 25 Sep 2025 00:29:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7AF08E0018; Wed, 24 Sep 2025 20:29:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B042A8E0001; Wed, 24 Sep 2025 20:29:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CBAB8E0018; Wed, 24 Sep 2025 20:29:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8632E8E0001
	for <linux-mm@kvack.org>; Wed, 24 Sep 2025 20:29:46 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4E5A613A112
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:29:46 +0000 (UTC)
X-FDA: 83925889572.27.45F51DB
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf22.hostedemail.com (Postfix) with ESMTP id 87F5AC000D
	for <linux-mm@kvack.org>; Thu, 25 Sep 2025 00:29:44 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KmFShdGV;
	spf=pass (imf22.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758760184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=rGrJhkEhVL8fDzcbwtX0Nlx0/Ial1/o06KA95F1aKyE=;
	b=yGN755xTCzUlGLhRn2P/6/9p/BKIDBRNv4pb2sBHacG15cS7BaXEGgsH9kDEJ08UenWHMK
	eBs4aJv4GInKUsvv3VHb0/lPCdgU47tZmMyl9YiE5je6mCiL3cCCo7s6vhvAjcrPjkszmE
	uMb+2TlSTiy5PWhLGWZ+w+VZqbJgczg=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=KmFShdGV;
	spf=pass (imf22.hostedemail.com: domain of chenglongtang@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=chenglongtang@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758760184; a=rsa-sha256;
	cv=none;
	b=OPP0Tw2jcxkub+fzWBHlAIyZmCx9PnWwznRen0jmPbHbNpcaCzCeqf68L+OzxcXx/Sp58n
	2C+5TBjb/FJIt3uJtxNvGdaayoJXuqs6z/OfwCkHrB7vrJspHY6iNVA8ZC5tQtYppfA6m6
	WsY17p29wkXt4MaHH/RRPkhoLEX90ac=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-57d97bac755so12376e87.0
        for <linux-mm@kvack.org>; Wed, 24 Sep 2025 17:29:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758760183; x=1759364983; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=rGrJhkEhVL8fDzcbwtX0Nlx0/Ial1/o06KA95F1aKyE=;
        b=KmFShdGVHk+dhVFnIZhUwUbV3qnvLDZOCX7+nWbmaLS+J1lYcUNCCHXfW7qJHmwBsI
         WIcBCYo6JMo+qUWPECW0yCWDtzxOGadU6GwSQtpmRUp99+uhfmwoeRBn6Lb+llBXo8zX
         B+LIHfEVqzY+Xxob77NEY1znYTUDM7F3edTGmyb8S6GiepiMNSG550ot+6Px80mWbefm
         A9/u0tlj1TI/HwV523ZyyJ556EgqODqfF4u7DvUKa+UPsRtQw9u7jttHYEQRAlaLuqVq
         wYuhYZowWU3diAyhow4OSJYbInPVOpFx1X+sFj2UHCGGS5UABTb84bNJvt+XQyfXJ1WK
         WSvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758760183; x=1759364983;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rGrJhkEhVL8fDzcbwtX0Nlx0/Ial1/o06KA95F1aKyE=;
        b=QprphbrZi0c2h43wJOgk+yCoib3R5sQtHw/eL3zuutglIGjLSQO3ylsKpmnlLiPATM
         DLnmeROFpjGnliHYPY6kkEYDeaNGQWbUibBoMSo+EHmK/FT2b8EcGnPTzYhDWJd5t6yt
         KyfFYwIje8UwyDmKavLm57ROH47ufhz6y7+SQ7hPtXSrRyJ+1ywmoOUaZ1HvvnK7zrZu
         jqdB5E/cUgEwcmhYYeL7p+fkTzghreTzgjts+QNackIE8lx7yzzgL9rJfjWHZiRC4L4z
         aIpBsP5AMvZyytBrUE7agWotU408sWNxnT3AQk0cPGtoeWn8fQd/2xOSogurzxzHJiHh
         zSlg==
X-Forwarded-Encrypted: i=1; AJvYcCXH98AxlN8rm5ExPtgsEliUmDi2BGAdi6jskruy6UMVOdPIhHh3dNojH3RA1NWclj04eqX1vGnQOg==@kvack.org
X-Gm-Message-State: AOJu0YwywvZysi3FQV6hTaSLJCSodj+uv5NwoPCC9DDMjHtzELYKF18x
	xWQsEjZ13n/aNksUSVTQasQgg1E+Q/K/bCEKpk/WZQKEYz5CZ5heHacsQl2IRt6IxnodRVX3uIJ
	d3ClZPOt3ElPAy5o3Kql6TapILJGKwpXAEDZ4Yc4H
X-Gm-Gg: ASbGncs67wgpvopFEOKQaVLcRNoioLmrZ38kKjDf1nCWQRmiYoFjj9K6WfV2p05y6+f
	aHMUlB5YKYi2za7Pfifbp50aOpEe67yfFH+HHWwwOm8dG+UqOPHidjKjZCPc8tn3vNRnCDIRwdU
	C/OgGNI7VRTmeg9vBNFqsjjREaMrz5IRhMWAWkbRD8qqLv8nKLcGBv1CEI44+LvKacUOxMWrcIE
	Idzc+pp88Bt1joGTZwTPfx8
X-Google-Smtp-Source: AGHT+IF29hX9gih8LwttPUfoJ3ziAEqxYld5pZxsEuTKcsm+ojcC4pZPrneDxgNLw1hROYWi7BymTX+vJ5G4M6w8ZGA=
X-Received: by 2002:a05:6512:6092:b0:576:4ceb:a167 with SMTP id
 2adb3069b0e04-582b1552a7emr239612e87.5.1758760182481; Wed, 24 Sep 2025
 17:29:42 -0700 (PDT)
MIME-Version: 1.0
From: Chenglong Tang <chenglongtang@google.com>
Date: Wed, 24 Sep 2025 17:29:31 -0700
X-Gm-Features: AS18NWBhdBOTvWF0Ty1kP-ZkTeb619FZATRTEkhft-g2-Fo8clpTokAq1JhLagM
Message-ID: <CAOdxtTYQye1Rtp-sG48Re+_ihD637NDXTG_V_uLkerg=m1Nbtw@mail.gmail.com>
Subject: [REGRESSION] workqueue/writeback: Severe CPU hang due to kworker
 proliferation during I/O flush and cgroup cleanup
To: stable@vger.kernel.org
Cc: regressions@lists.linux.dev, tj@kernel.org, roman.gushchin@linux.dev, 
	linux-mm@kvack.org, lakitu-dev@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 87F5AC000D
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: gtfc6pi6wxasaohzbzprgt85yweeyr43
X-HE-Tag: 1758760184-653775
X-HE-Meta: U2FsdGVkX19jLDA5gX+bn2rKJHzhOi689NMtb22JLe6pvxWYhJpWLMTkJC2j2eIB07JlJcx8D6Its8/BThZPhOq5X8/cEp3b/9LPkI+x7v+TNn/YbNEoT3FCPbZHBw+7VSIipjvVxPuzIV10+6AjistvstNpriGC/guTou9s5OlpUq/ixRfLBbjctGC4gAbf9ELSMYkUZnyHuvXg4Jx/+AcXxIxSZv72yhgjXzMLWAjiCA5Xjl5+wDkSv1VtqyiQ9IkSuDxWuyzSy98zMgXAV5qWDB0C8/D2YRPbijlMkXmozQC0qX71cdh9Om5BbuwHegz65zLATGb60lXx+CAYowO5ZzPKrVyMr9PXQPKN5VcELegqY14CaH2vF09QzR9sYPXLmNPdCQnO9tFE1obGXxZ10P5BVn4hDD8LEqDM74yWmSIiJHpbiVGEBLXDmIlME0AtFUhs3iJqIA5yCRpu1hNKIbvOpDegCHWP+ncGtqTWZ1XqvkTJDfpINggolQmAVr7bmBY4m1jysIbAL8+9DlHzfsZ7NQFo1odnDweCF6W3jTQpn22yVQNPIDKe/q1ni1P+7jFHcRoPzuVe5dhWSIowSIaC/ewMVV6a2QmPlbiowoyhAdQJJbLSKfSL2KqFt2KdemLQVmjFSxK5WVSGhcOaIu+IRyBUa+FnLmL4vj5mYKBUC8Mt/R+PdE9NKTEXfi80ltaMBYakt27p5KH/C6vz+OranSFLDKX8/S61lxkAPTBCYRc47C/Wm+aupszYQmG9JkuiAQefd31UoRdMvbmswvfg5IfdQCybhXRJPnjZME/qOOQn8NSon/tN/VVEVk42jzuqSol0XcO0XY549ePcsHuFw1uwwO/TiJ3S2DvGBhFFTkD9wGaNaUq1VXRVyifJfIJ7nKLImkNFUaYEg68eVSjbsCNkoNvzF91P0ddTUsQmq5hAmzYxjRcFEHaD5F6dn0wSE71ol+84ZfI
 zwT84iAq
 wEhTjB2/OIG9FuAP1kX1KfM7jFg/La7Ccf1DXKYihJHCSia02Oe7FxbUAJlVxkmQGrbcWRSiDMbe2/b5F5IZ0ayQK4XUczzGLbevKl6V7Fgxqb0lwVA371A4y5/Eex2RL9d6aqTvHATVM+eP8Ih3/jstG4tVjETocFD5JHCNDaIWg7tU5wV+LOz/foaeoNzd0iijOLvwSUp2buSEnceFfS5kTQUYaxUNrn6GF
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello,

This is Chenglong from Google Container Optimized OS. I'm reporting a
severe CPU hang regression that occurs after a high volume of file
creation and subsequent cgroup cleanup.

Through bisection, the issue appears to be caused by a chain reaction
between three commits related to writeback, unbound workqueues, and
CPU-hogging detection. The issue is greatly alleviated on the latest
mainline kernel but is not fully resolved, still occurring
intermittently (~1 in 10 runs).

How to reproduce

The kernel v6.1 is good. The hang is reliably triggered(over 80%
chance) on kernels v6.6 and 6.12 and intermittently on
mainline(6.17-rc7) with the following steps:

Environment: A machine with a fast SSD and a high core count (e.g.,
Google Cloud's N2-standard-128).

Workload: Concurrently generate a large number of files (e.g., 2
million) using multiple services managed by systemd-run. This creates
significant I/O and cgroup churn.

Trigger: After the file generation completes, terminate the
systemd-run services.

Result: Shortly after the services are killed, the system's CPU load
spikes, leading to a massive number of kworker/+inode_switch_wbs
threads and a system-wide hang/livelock where the machine becomes
unresponsive (20s - 300s).

Analysis and Problematic Commits

1. The initial commit: The process begins with a worker that can get
stuck busy-waiting on a spinlock.

Commit: ("writeback, cgroup: release dying cgwbs by switching attached inodes")

Effect: This introduced the inode_switch_wbs_work_fn worker to clean
up cgroup writeback structures. Under our test load, this worker
appears to hit a highly contended wb->list_lock spinlock, causing it
to burn 100% CPU without sleeping.

2. The Kworker Explosion: A subsequent change misinterprets the
spinning worker from Stage 1, leading to a runaway feedback loop of
worker creation.

Commit: 616db8779b1e ("workqueue: Automatically mark CPU-hogging work
items CPU_INTENSIVE")

Effect: This logic sees the spinning worker, marks it as
CPU_INTENSIVE, and excludes it from concurrency management. To handle
the work backlog, it spawns a new kworker, which then also gets stuck
on the same lock, repeating the cycle. This directly causes the
kworker count to explode from <50 to 100-2000+.

3. The System-Wide Lockdown: The final piece allows this localized
worker explosion to saturate the entire system.

Commit: 8639ecebc9b1 ("workqueue: Implement non-strict affinity scope
for unbound workqueues")

Effect: This change introduced non-strict affinity as the default. It
allows the hundreds of kworkers created in Stage 2 to be spread by the
scheduler across all available CPU cores, turning the problem into a
system-wide hang.

Current Status and Mitigation

Mainline Status: On the latest mainline kernel, the hang is far less
frequent and the kworker counts are reduced back to normal (<50),
suggesting other changes have partially mitigated the issue. However,
the hang still occurs, and when it does, the kworker count still
explodes (e.g., 300+), indicating the underlying feedback loop
remains.

Workaround: A reliable mitigation is to revert to the old workqueue
behavior by setting affinity_strict to 1. This contains the kworker
proliferation to a single CPU pod, preventing the system-wide hang.

Questions

Given that the issue is not fully resolved, could you please provide
some guidance?

1. Is this a known issue, and are there patches in development that
might fully address the underlying spinlock contention or the kworker
feedback loop?

2. Is there a better long-term mitigation we can apply other than
forcing strict affinity?

Thank you for your time and help.

Best regards,

Chenglong

