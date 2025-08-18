Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C148CA0EE4
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 17:01:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B3178E0025; Mon, 18 Aug 2025 13:01:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88A968E0013; Mon, 18 Aug 2025 13:01:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C7D48E0025; Mon, 18 Aug 2025 13:01:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67FC08E0013
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 13:01:52 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 224F41DE522
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:01:52 +0000 (UTC)
X-FDA: 83790495264.19.6A4F94D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf08.hostedemail.com (Postfix) with ESMTP id 23482160007
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 17:01:49 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OFXcVi3P;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755536510; a=rsa-sha256;
	cv=none;
	b=bA++0bcgzFKz1QYDTtAmtnu2leUFZKOqDicD2IooNk8SydXRcv0qj+DJ6y+LRS4Xkqaxsk
	S4vxSQQQgz5H56+GDPBxPElbMDu+MigGi+PnSjjMy4vaMrVwns9XtH+OZ3DOqo0lDQhcmj
	HbvNWfg2zXmtlnkOjDZywAjQCjDnavo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=OFXcVi3P;
	spf=pass (imf08.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755536510;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9GgSRJiKCu3BOGI+c6Rkf7dEZO8accJ0kdmdmhdiQ9o=;
	b=C+T8E/yBQDDlTxWeHQDGfK46MaY77frWzklaXUErNLR1b/9YSoSvaiRszgV+PSw652OgSK
	dJ0Kc9cFgbGXGx+d3H+wMAlSJpgkXZx4bXyilWHAHPi6so0nvf4RQ2qUNUfbmyM9fUglFz
	tpOFTRoviEvpg29XOTZbUgN3sFkE8Yk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1755536507;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=9GgSRJiKCu3BOGI+c6Rkf7dEZO8accJ0kdmdmhdiQ9o=;
	b=OFXcVi3PUjmW38+SokI8waULo25wFMZMn4kwm4Cx6LY8Pe9wvfHWPTz0sDnlzsleOficHh
	F6LoRf3O0xQ1Munzo0yjiS2Qn+Q2gwY6LHsrDy75Ofvz9U6yiK/T19wxi1SL5u32/hPdeD
	lMrzNzcO/0iws375mn0AGpWK+i8v/qk=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: linux-mm@kvack.org,
	bpf@vger.kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@suse.com>,
	David Rientjes <rientjes@google.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Song Liu <song@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: [PATCH v1 00/14] mm: BPF OOM
Date: Mon, 18 Aug 2025 10:01:22 -0700
Message-ID: <20250818170136.209169-1-roman.gushchin@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 23482160007
X-Stat-Signature: dxys3up7pun1jnm7jgy7bs8uqsbp1fxx
X-Rspam-User: 
X-HE-Tag: 1755536509-565217
X-HE-Meta: U2FsdGVkX19mKbZV2IxxheI38vRoCQ1euGZko9nvN6KGjNjTRUA721H0MgnwFr0P4w7B914zr38jh2OxvArvrxTKuoiHeBsTwQr+ILiYrX4mLNYII86cQcFRO4iN54gxyECrFSYzuHVJlf1HRQP+9MXJAJGgmIeWoh8cX3QO3EvY5cuAhsw2RKaDlsly/DuBVKDoX6I5QiM9xZLvk3UpYONwC5mdrRnNQmWLSa6gdhCn9iaD9Vs08CVmlLQ+ChzWduatgPM1i4oYeXQ9Jk0y9D9cg87Lqz1CiVrtE3439jBAQMKQtPAmf6UuARSDoKJrkrObo9wGLNz9MFBrOFCRjn6yHhYOg7Iqpq5zKdw8FCBqPaZN9EWMl4fYxxRQ+mTMEMJSrCSFK5cEkPoYfjn5vSckGwFk9sWcD+pbOIvsBd7f6wRe++LFgCGI+CzytDxkRiYkc3YPys6wMZ51nqoXW2JhQI0lm4zbqiu4goV9aYwvgRUzAxCGG+l3cduc3GyrnrLaE80TZuIMWH+bCY/MkqgxnFMxd71bCfblMQFp0Ntx/HA+htkOMTmY9wMdHNPveVMUk6xc2jWe4g9qCb6WRHsHZ/0lwcXXrN6uQOdZjQaqLPLUUDl+Tc1o8gRe6E0oo1rl+h38kGfAb1A7NITisikOnyNOe9YjQN+2unKggyNQhSeL5y5excrTtiYN2ux4tSf/+afRJsYxbF2zAMM2ukVx2QZF238TdVO+JxEvc62KL/Sw3RAbeqmFyU9tUPiriMBr2Pw3767PRPMJ10n5tGXHwndX5SVSGaHOAh1UzqLckLYHSuEWixAuyS9KDX14r6n8LfAwhep36+WpVM01rENxzRp/VVjOdBqipiVq+HHGBjqkFoU3blj8yF88Te7rZu+hnCHbkMyGv7NZtFT1pJiw/ZBZU0pv9WC9bp0PNIzsOPhX5i/gzBK7p61V17W9wzpBlf8FOt8IQZ0mlVV
 77/6qljW
 IgS9EyzCBTTRSY58U8V8H14lvM23JUGXgoiC/TY3kktWEZxD+RJo1g4pwE1Iyc7Mqq9MYLMi3jjrJYLbqKj9blHrJfnlYoJrIZYDiF/YFzvYPXJFuOvq8eFYskqfkNndiGL+4Rjb78yDnrt20qTen6/9iJZlE07q3X6Xv0+rBEhNmvh0pY+vqjAX1WE0glj7DsEKNxOqUPi7Li7ye4WOkIgvbf0GJW7j9SftgJKnwV01dAWOBdoaLyZ8KlheVMVxi8emwBg5kmXT6G2uJpQSVtKWujJiQtudhk5YtrsaTSbnqbSgU9gid3Llp6jyV4D/obs8xck9Jc4QrsqUv8M0lZosWW9tve+G3ddbCcW/tKdIcjClsUXDg3OnQR6SZz5I3RadP6QJ4aVk06Qthza9bSo05+r0shjs8voJtRKqOug9S0FmnVe/yVM1Tgh3aWSfKq8nm/Qpnqjd/PYA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This patchset adds an ability to customize the out of memory
handling using bpf.

It focuses on two parts:
1) OOM handling policy,
2) PSI-based OOM invocation.

The idea to use bpf for customizing the OOM handling is not new, but
unlike the previous proposal [1], which augmented the existing task
ranking policy, this one tries to be as generic as possible and
leverage the full power of the modern bpf.

It provides a generic interface which is called before the existing OOM
killer code and allows implementing any policy, e.g. picking a victim
task or memory cgroup or potentially even releasing memory in other
ways, e.g. deleting tmpfs files (the last one might require some
additional but relatively simple changes).

The past attempt to implement memory-cgroup aware policy [2] showed
that there are multiple opinions on what the best policy is.  As it's
highly workload-dependent and specific to a concrete way of organizing
workloads, the structure of the cgroup tree etc, a customizable
bpf-based implementation is preferable over a in-kernel implementation
with a dozen on sysctls.

The second part is related to the fundamental question on when to
declare the OOM event. It's a trade-off between the risk of
unnecessary OOM kills and associated work losses and the risk of
infinite trashing and effective soft lockups.  In the last few years
several PSI-based userspace solutions were developed (e.g. OOMd [3] or
systemd-OOMd [4]). The common idea was to use userspace daemons to
implement custom OOM logic as well as rely on PSI monitoring to avoid
stalls. In this scenario the userspace daemon was supposed to handle
the majority of OOMs, while the in-kernel OOM killer worked as the
last resort measure to guarantee that the system would never deadlock
on the memory. But this approach creates additional infrastructure
churn: userspace OOM daemon is a separate entity which needs to be
deployed, updated, monitored. A completely different pipeline needs to
be built to monitor both types of OOM events and collect associated
logs. A userspace daemon is more restricted in terms on what data is
available to it. Implementing a daemon which can work reliably under a
heavy memory pressure in the system is also tricky.

[1]: https://lwn.net/ml/linux-kernel/20230810081319.65668-1-zhouchuyi@bytedance.com/
[2]: https://lore.kernel.org/lkml/20171130152824.1591-1-guro@fb.com/
[3]: https://github.com/facebookincubator/oomd
[4]: https://www.freedesktop.org/software/systemd/man/latest/systemd-oomd.service.html

----

v1:
  1) Both OOM and PSI parts are now implemented using bpf struct ops,
     providing a path the future extensions (suggested by Kumar Kartikeya Dwivedi,
     Song Liu and Matt Bobrowski)
  2) It's possible to create PSI triggers from BPF, no need for an additional
     userspace agent. (suggested by Suren Baghdasaryan)
     Also there is now a callback for the cgroup release event.
  3) Added an ability to block on oom_lock instead of bailing out (suggested by Michal Hocko)
  4) Added bpf_task_is_oom_victim (suggested by Michal Hocko)
  5) PSI callbacks are scheduled using a separate workqueue (suggested by Suren Baghdasaryan)

RFC:
  https://lwn.net/ml/all/20250428033617.3797686-1-roman.gushchin@linux.dev/


Roman Gushchin (14):
  mm: introduce bpf struct ops for OOM handling
  bpf: mark struct oom_control's memcg field as TRUSTED_OR_NULL
  mm: introduce bpf_oom_kill_process() bpf kfunc
  mm: introduce bpf kfuncs to deal with memcg pointers
  mm: introduce bpf_get_root_mem_cgroup() bpf kfunc
  mm: introduce bpf_out_of_memory() bpf kfunc
  mm: allow specifying custom oom constraint for bpf triggers
  mm: introduce bpf_task_is_oom_victim() kfunc
  bpf: selftests: introduce read_cgroup_file() helper
  bpf: selftests: bpf OOM handler test
  sched: psi: refactor psi_trigger_create()
  sched: psi: implement psi trigger handling using bpf
  sched: psi: implement bpf_psi_create_trigger() kfunc
  bpf: selftests: psi struct ops test

 include/linux/bpf_oom.h                       |  49 +++
 include/linux/bpf_psi.h                       |  71 ++++
 include/linux/memcontrol.h                    |   2 +
 include/linux/oom.h                           |  12 +
 include/linux/psi.h                           |  15 +-
 include/linux/psi_types.h                     |  72 +++-
 kernel/bpf/verifier.c                         |   5 +
 kernel/cgroup/cgroup.c                        |  14 +-
 kernel/sched/bpf_psi.c                        | 337 ++++++++++++++++++
 kernel/sched/build_utility.c                  |   4 +
 kernel/sched/psi.c                            | 130 +++++--
 mm/Makefile                                   |   4 +
 mm/bpf_memcontrol.c                           | 166 +++++++++
 mm/bpf_oom.c                                  | 157 ++++++++
 mm/oom_kill.c                                 | 182 +++++++++-
 tools/testing/selftests/bpf/cgroup_helpers.c  |  39 ++
 tools/testing/selftests/bpf/cgroup_helpers.h  |   2 +
 .../selftests/bpf/prog_tests/test_oom.c       | 229 ++++++++++++
 .../selftests/bpf/prog_tests/test_psi.c       | 224 ++++++++++++
 tools/testing/selftests/bpf/progs/test_oom.c  | 108 ++++++
 tools/testing/selftests/bpf/progs/test_psi.c  |  76 ++++
 21 files changed, 1845 insertions(+), 53 deletions(-)
 create mode 100644 include/linux/bpf_oom.h
 create mode 100644 include/linux/bpf_psi.h
 create mode 100644 kernel/sched/bpf_psi.c
 create mode 100644 mm/bpf_memcontrol.c
 create mode 100644 mm/bpf_oom.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_oom.c
 create mode 100644 tools/testing/selftests/bpf/prog_tests/test_psi.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_oom.c
 create mode 100644 tools/testing/selftests/bpf/progs/test_psi.c

-- 
2.50.1


