Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26D8CA1015
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:03:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 340CB8E000A; Fri,  5 Sep 2025 05:03:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EFD18E0001; Fri,  5 Sep 2025 05:03:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 205608E000A; Fri,  5 Sep 2025 05:03:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5F98E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:03:36 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD19B59E5D
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:03:35 +0000 (UTC)
X-FDA: 83854608390.09.103D534
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id DC90220005
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:03:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fFu1G5nt;
	spf=pass (imf03.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757063014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=KL3x9RSWXKSLdTGhSdSpbWqX8OUbo1gEgXbGFUG72VA=;
	b=g8tTMuVl8Y2TO0XZGAAr9OQkFiWk2hrRz0stF/bydxnw2VcYhWhk7z1VAc1RzRkQ8Z9PYL
	F6mmxzEG5a0TO339gtkT/eWe59Ic+c6SY4VfIdTLuJ7a9coMqw24IdTw8T3+bHF0H6WirT
	gtlFDsELMls0yp0y5gPtiDBzfaQQW1o=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=fFu1G5nt;
	spf=pass (imf03.hostedemail.com: domain of marco.crivellari@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=marco.crivellari@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757063014; a=rsa-sha256;
	cv=none;
	b=i08b5TawuLZ+VLKRNnZnP15YE7ycpsF94vUkBcTEtkp0R8w18jp/YYEtuSXL2p76lxP/3c
	f9Mvq5ut4wrUOW4F1TjBsCVmgUr4fovvYlTqRiYF8JFNLWl/UheVYJTxuG9460Ef4tPUdD
	Xqvk8GurO6Ew8uSR+vUU3hgNcllTyVU=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-45b89147cfbso20682465e9.3
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:03:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1757063012; x=1757667812; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=KL3x9RSWXKSLdTGhSdSpbWqX8OUbo1gEgXbGFUG72VA=;
        b=fFu1G5ntF0RB6d+e9RYZ0nxFHiHt8oJZNBYnHGZAq6qZZ9L6TFLm7J6noMmhRMTDy3
         m/5Zc0lrxCkcdPEB3YNaH1NLUt51r0r/YH8yx1x8j0kDgJ2O3m9uqfDO/N0XjFvD6Kob
         bDOP+RltpTpvL6RTkrhMeMD514prSxrJJJ3Nl/yPy5cjNJLBRn4Tlb4iRKE6nHMcRM4I
         3FSKuZLPmu+2gdKnjiXp8LT283ruwtzLJymdl18AJDXkQdFQztCjiP9pJknCRdSDjf+E
         XwVZo5CKuDYsz+Wve0khlAtQ3t9tzAd1eXCYLnDX3WgUehAvreR2o5ZsNnUAxqJB4Dju
         vX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757063012; x=1757667812;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KL3x9RSWXKSLdTGhSdSpbWqX8OUbo1gEgXbGFUG72VA=;
        b=h4K3AcfZ5T4NESRVcI1YaQmVHBsVhmRUGHLtG1XAzneBMWqg8Vmy02CnA+Dfo+/eXe
         sbYJAZSx/Ey9NsmX45T9bsVRX0x3Z3KyYgNlqvyK7fJlwiJ64zgAmLoIm6W3v1YsHbqk
         EhsJg5czmd0sb00jkGQE8ke0ZDEdCBPKjp52tdLjp0AGeB39Hc89QeOfaGqgMaaOPKq+
         rz6g9hPpkcC0Rc5FCP8gXwGy+CYTyBz7FxCAv/sOnbisO5wWcWKyvHwa4PdWtgAUzwZe
         vo+14XV5aSj1WTfBWyb8GVQChfu1ToKUEQJPEo6MjgYlqzeEmKUpuE1ddYFIzvMv2/pI
         iqpw==
X-Forwarded-Encrypted: i=1; AJvYcCVUcAlR3yQnOw5bSQHqc5Oq2TCGET3B0XBVfAPAkfipeu9VEZshpd2ToVgpqpqOPQRTowbUvSbpfA==@kvack.org
X-Gm-Message-State: AOJu0YxWNTNWhnPuqUJpJjOMOdB19eLLBKhL1pBzWpe/uyh/Je9g0GGx
	QeAKHDxnxwVcMUCk2BjrTl0sfdxwSYaZdnmJh95cdlWBHgiWzlAK8PC/Ff1bDS4xbgo=
X-Gm-Gg: ASbGncv+q0N9igsIQ6GrrBEhQhdQgRedsS9BLXEiJYgHJUq2ARG8/ROUzVEwv+XBHID
	8QOMj4NpYVasZITqJlAKIv09M8ew5EdflJbhMx2Autd/DP75z1Wd0VzSq2D6kz6tuJTKg3Mez3u
	PjlMPFNbZ74aOiRLCg1szhKqq0xv/h4l0njX0//XhDvP5WOO+IuV3pXi2zi00N3YeZ4NgwcWNlf
	/UzuqLLkzVoJqZjGhPp1pYaDAUFDbOnp67mwUrFRPAAwZo0L4dORQL5cJo1AZYHSsjiWL4ZkOXG
	4rJ024I114UlHeRwiS8NFuD1D5YXEtEHRh+gW98MCoFLqSBaV06Cn8CPPSfmvlhFmWB8gOyk1v7
	/tAiOWpJ3QSqcfGPGR1w/XjkVROWDDxT/Q/VM3rGMKyWLHRg=
X-Google-Smtp-Source: AGHT+IH7Xf7he/bZvGPKn0Yiqk81LbFmFkKkY6ULudRp2kYJgJ9E+EpwCotTTIhB0vk5XsgDBSaUrQ==
X-Received: by 2002:a05:600c:a45:b0:458:bf0a:6061 with SMTP id 5b1f17b1804b1-45b85598614mr207667235e9.24.1757063012191;
        Fri, 05 Sep 2025 02:03:32 -0700 (PDT)
Received: from localhost.localdomain ([2a00:6d43:105:c401:e307:1a37:2e76:ce91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3cf3458a67fsm3614543f8f.62.2025.09.05.02.03.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 05 Sep 2025 02:03:31 -0700 (PDT)
From: Marco Crivellari <marco.crivellari@suse.com>
To: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Cc: Tejun Heo <tj@kernel.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/3] mm: replace wq users and add WQ_PERCPU to alloc_workqueue() users
Date: Fri,  5 Sep 2025 11:03:20 +0200
Message-ID: <20250905090323.103401-1-marco.crivellari@suse.com>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: DC90220005
X-Stat-Signature: 6pqq4q5qgqw417b7ikco3kmacssf5ed9
X-Rspam-User: 
X-HE-Tag: 1757063013-327182
X-HE-Meta: U2FsdGVkX19qDIY33qpjZtsKZF4hAKHhPhk2G2NVKG9Kp3dtl62yPNyhnBItaOG4ZmBKVNBv8IQxssxhTpL9/9hgubGyo/NEWLwWZii6uToxWYlXnVi2SvKZCEcaxy4C/YMX3+Y9iVd51slaz+/jgl+uLEd/OSia0flHoAc8sJkBm8u5XAksqV1995Syq8VjgvlRZWykM8KmCiOQ45OdBwzT9mDGtAZF+rsNJSBge4YGfpwDlxqJNFjK6ElNz/8LVdZlp/6ecs4fCtHh0KIM0hlmamw8Jd19I4+ZNXyzEAR8YbsJUXLdiM+zwiqWDd8wS5JVjqnV+1uheQqQEHFeMQ1nFZ2EDVk1jmHGzaXuFEzq7DQiheRahNCJQCaYimSLYgrjD9KEeQC4fqieTeEmnmZnDfdWkKCzmCTIcgytOAXx8J/KWhmXDiVLNtP2kN/QPQ693SEQwee0syqFCnR1K7IvMg5LVwQjmmU3ulCzzV5Ca8iHnGffpYGcRWYeiuhPxzm0DKti0ypGSmMHYIdbs9BO5OeFFaC8lNKe5yrO3k688VjYlxmFJ0CGlbkoFVSd2HutvIQxRPlQSm2oWxt1crIT52pB3BZaKY1/uetkRdDqbgnQSQv0LmjZlEfsrydYtr1CxLGl/VYTUTW6UtzXgQ7lAZ86mtgVGtEH+jw10UCSa9tKdm7iTCA7z9/2x+golD5YPiD+RISZ2/kLp5WqYwbO6NvoLz2cZ/FpC1TzqwgkTy0CHELKVAU5Q82Xeyfwmxli7ZtE/nitAAJ2HCKYyv92f3kCihfRZnlN2SbM61QHyicwv83TGGSHMrffNcVadFPNk3t6DGZNVepdjRzQdqBTMytBet0hkZD/Y3+tA7iC2xIAgZBDTduODq/MkaIZsg/u4ys+b7U0C8HoAhEY5+TdyogMfqXZSyq3wHpIg1R/IV9MOjaevxrvsSih1E37n47xKp6nOmQ3kOJt2I2
 E0UmjVOR
 rU0zKlV4sO8WyC1g3+ZmmwKJyCvO1M1x20DzMyXnKeLH4arDi0/lJxjzWbv9jQ8+ZzK47YAa8DKkVjRKsu1GD0MWvrlkrhQ+Tl7sLlElj1XLvlLMmcgdz8/aQa8fqrzYO7lyMCn/u2BNbGBCphtJCc2l6DSaOhX5mUILdm5nI0hDGWVzGd1Y1/TPQ+nBdRAaoA0+qh13ohFivEYjaGgQmrSb0SJRfkFY4itAIVo2NydFOJ4Q6fSCPXf8iGP7+yyiHsb9BhUH6q/crDyH+yveR/INXq78RWdiGKh1/7hlaYcwcZdUX3TMrS3GkL7f6vf5mplxYxQDUKyLVFGS4HZAur+uynJ/zKItxytHDf7vGfo5CoxGLjyxrf/SdS8o8T6A3K6Th
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi!

Below is a summary of a discussion about the Workqueue API and cpu isolation
considerations. Details and more information are available here:

        "workqueue: Always use wq_select_unbound_cpu() for WORK_CPU_UNBOUND."
        https://lore.kernel.org/all/20250221112003.1dSuoGyc@linutronix.de/

=== Current situation: problems ===

Let's consider a nohz_full system with isolated CPUs: wq_unbound_cpumask is
set to the housekeeping CPUs, for !WQ_UNBOUND the local CPU is selected.

This leads to different scenarios if a work item is scheduled on an isolated
CPU where "delay" value is 0 or greater then 0:
        schedule_delayed_work(, 0);

This will be handled by __queue_work() that will queue the work item on the
current local (isolated) CPU, while:

        schedule_delayed_work(, 1);

Will move the timer on an housekeeping CPU, and schedule the work there.

Currently if a user enqueue a work item using schedule_delayed_work() the
used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
schedule_work() that is using system_wq and queue_work(), that makes use
again of WORK_CPU_UNBOUND.

This lack of consistentcy cannot be addressed without refactoring the API.

=== Plan and future plans ===

This patchset is the first stone on a refactoring needed in order to
address the points aforementioned; it will have a positive impact also
on the cpu isolation, in the long term, moving away percpu workqueue in
favor to an unbound model.

These are the main steps:
1)  API refactoring (that this patch is introducing)
    -   Make more clear and uniform the system wq names, both per-cpu and
        unbound. This to avoid any possible confusion on what should be
        used.

    -   Introduction of WQ_PERCPU: this flag is the complement of WQ_UNBOUND,
        introduced in this patchset and used on all the callers that are not
        currently using WQ_UNBOUND.

        WQ_UNBOUND will be removed in a future release cycle.

        Most users don't need to be per-cpu, because they don't have
        locality requirements, because of that, a next future step will be
        make "unbound" the default behavior.

2)  Check who really needs to be per-cpu
    -   Remove the WQ_PERCPU flag when is not strictly required.

3)  Add a new API (prefer local cpu)
    -   There are users that don't require a local execution, like mentioned
        above; despite that, local execution yeld to performance gain.

        This new API will prefer the local execution, without requiring it.

=== Introduced Changes by this series ===

1) [P 1-2] Replace use of system_wq and system_unbound_wq

        system_wq is a per-CPU workqueue, but his name is not clear.
        system_unbound_wq is to be used when locality is not required.

        Because of that, system_wq has been renamed in system_percpu_wq, and
        system_unbound_wq has been renamed in system_dfl_wq.

2) [P 3] add WQ_PERCPU to remaining alloc_workqueue() users

        Every alloc_workqueue() caller should use one among WQ_PERCPU or
        WQ_UNBOUND. This is actually enforced warning if both or none of them
        are present at the same time.

        WQ_UNBOUND will be removed in a next release cycle.

=== For Maintainers ===

There are prerequisites for this series, already merged in the master branch.
The commits are:

128ea9f6ccfb6960293ae4212f4f97165e42222d ("workqueue: Add system_percpu_wq and
system_dfl_wq")

930c2ea566aff59e962c50b2421d5fcc3b98b8be ("workqueue: Add new WQ_PERCPU flag")


Thanks!

Marco Crivellari (3):
  mm: replace use of system_unbound_wq with system_dfl_wq
  mm: replace use of system_wq with system_percpu_wq
  mm: WQ_PERCPU added to alloc_workqueue users

 mm/backing-dev.c | 6 +++---
 mm/kfence/core.c | 6 +++---
 mm/memcontrol.c  | 4 ++--
 mm/slub.c        | 3 ++-
 mm/vmstat.c      | 3 ++-
 5 files changed, 12 insertions(+), 10 deletions(-)

-- 
2.51.0


