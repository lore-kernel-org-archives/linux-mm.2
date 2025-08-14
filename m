Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75F30CA0EE4
	for <linux-mm@archiver.kernel.org>; Thu, 14 Aug 2025 13:56:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17B4E900023; Thu, 14 Aug 2025 09:56:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 125C3900176; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D365B900172; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A7B1B900023
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 09:56:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 47F65C069C
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:56:10 +0000 (UTC)
X-FDA: 83775512100.23.0E76F5B
Received: from mta22.hihonor.com (mta22.hihonor.com [81.70.192.198])
	by imf07.hostedemail.com (Postfix) with ESMTP id 082A540007
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 13:56:06 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=ZR9RNxbe;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf07.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755179768; a=rsa-sha256;
	cv=none;
	b=rg67a+Wr9SAQq4btI+uIqLRB89v2aVkWqVHx3zWyO8RCqTDWQusqHCZIpydpAUeXfdb8PN
	A+JMCNt7hN2fYiBTyedQhzKCylIR9Do/TUTjPZfx1NeLLqvVDrExy2J0wH3svlldf7yVtG
	7Is2ogXqNIe4Y1xvMVI3NqGUwVSXUi8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=honor.com header.s=dkim header.b=ZR9RNxbe;
	dmarc=pass (policy=none) header.from=honor.com;
	spf=pass (imf07.hostedemail.com: domain of zhongjinji@honor.com designates 81.70.192.198 as permitted sender) smtp.mailfrom=zhongjinji@honor.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755179768;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=BBLjP4xvKDuUFhARlS1Ydysza6+nSWdlIM3BlOBCokY=;
	b=KcKiPr+wKBQyWe3eUpDc4KkEF5BCZk3SPSWTSgcZjI4jFmZ4gxQm2EYaYp7iDjJc9/MY0j
	JABmpIThsKTrHlr4pCYmL1+0g+LVjiOFRAZ5gHbqtO3me9otJpTWdlxQf5bp7cE/L5CUYe
	PiNGXS7OeraUsZEZ7cvWRkLf1zPUSXU=
dkim-signature: v=1; a=rsa-sha256; d=honor.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=To:From;
	bh=BBLjP4xvKDuUFhARlS1Ydysza6+nSWdlIM3BlOBCokY=;
	b=ZR9RNxbeiqfWaz2YieZy484lT4aLrYRkBa5eVtHwAqoPKkWgCviGZXx0vOXHsCpdj7MYN2Gec
	InkLNagzTTNNaNc9F3YunmB677AjilGx6mLexq8iT454fQi9NACXsrLPHx0zDCz7D8eTr28ASYA
	m7Vu/RyqCaZkSVciXfLv8Fs=
Received: from w013.hihonor.com (unknown [10.68.26.19])
	by mta22.hihonor.com (SkyGuard) with ESMTPS id 4c2mwn2tTvzYlnhn;
	Thu, 14 Aug 2025 21:55:53 +0800 (CST)
Received: from a018.hihonor.com (10.68.17.250) by w013.hihonor.com
 (10.68.26.19) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 14 Aug
 2025 21:55:59 +0800
Received: from localhost.localdomain (10.144.20.219) by a018.hihonor.com
 (10.68.17.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 14 Aug
 2025 21:55:59 +0800
From: <zhongjinji@honor.com>
To: <linux-mm@kvack.org>
CC: <akpm@linux-foundation.org>, <mhocko@suse.com>, <rientjes@google.com>,
	<shakeel.butt@linux.dev>, <npache@redhat.com>,
	<linux-kernel@vger.kernel.org>, <tglx@linutronix.de>, <mingo@redhat.com>,
	<peterz@infradead.org>, <dvhart@infradead.org>, <dave@stgolabs.net>,
	<andrealmeid@igalia.com>, <liam.howlett@oracle.com>, <liulu.liu@honor.com>,
	<feng.han@honor.com>, <zhongjinji@honor.com>
Subject: [PATCH v4 0/3] mm/oom_kill: Only delay OOM reaper for processes using robust futexes
Date: Thu, 14 Aug 2025 21:55:52 +0800
Message-ID: <20250814135555.17493-1-zhongjinji@honor.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.144.20.219]
X-ClientProxiedBy: w003.hihonor.com (10.68.17.88) To a018.hihonor.com
 (10.68.17.250)
X-Rspamd-Queue-Id: 082A540007
X-Stat-Signature: aoxsdrifxgcrgofdngriscomnsa5a5zz
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755179766-297061
X-HE-Meta: U2FsdGVkX186GlljDuqqWm8q0y8TdrcsB0zvQ16w065IGDZyOhQBOphsN9zd3RMqZs0R4VYNepRIK5f3YPKIX9POC0lTtJV16rW1z98lXaC7vcnoYIrviGSTQ56wetNmgasMaXTAfNbRqqrfUt5ku4Grs7p+plLpEDxo223woSgAgshH5NaESRl2/213ovvtV2k5Ke/cUR292EVxB9+CBS3poqVCLViR2aaM9dW0jaK7NIbV4Fw//p6tQ1ST5/3SbrHXcofF7wQ+H0kzdOaVwRiKgJDlG4Y+DJ2wxDRuZ8JOx0sdfAQ4iD/5PzAtR3LeEySxV/yDi3QQVZ6pXTOO7sdJ5uoPHc4IhHKS+lTaAxgZpol6298tz753JRBpZ9OZVs9d+7bdz4AfVNs57o+NNjpd102cPwvWNCyVpDrQ1vdeSpL5rAofz3FR7E0ilWl6otjO/NY9OVnQ16DzTHbwDOXi2MJehi4uXRU8W+QCvemoA0hYaGNy1YO1Uyo8ofXxOU3ALlPEHjKj9aXvp7eP3l3W/93sbZn4FWUMa+62jU2oHN3jkUtjC9eZiP8feXtWzInjs1qPXDOP/efH8up40A5iFoG33CcLFe3N/aYEd0FYJzjNVOQ1ocR8+YH8sK4xOFo2ADh1R/fzQsy+fYo9/X6vmAM1yy+dXvpNyyuw+eLPl3uuMA/5ZsW+Ljp5IsfEAeCMJ8z3OdlXtwFgKI/FBkTfciL3Yb65AWBHaOcCCNOYh57dEHRdnJuDnCJgNTt+YUlX082UjDeWPOii+lyYwKI+lj3rG8yPTUekFVowvpG9bYbqTf8+Q5nR88U77Cn+ge6SHSOeM4RpIF+VZ+mqNFhncMU7WD4C8zYRf6lt2cYI+m/PozqwlnL43f4dl2sUUjsiJTR7r5JO4523rstACFUTUEMm5dwR4lOLtD0swWsZ4qj8pcM29GNDrSxuzq0dBGNjH2MpysFckcMnIEM
 eidD1WtS
 LPJFmm22S3DV1j2WvVTVekHNtQVrow0MbmDMCOePHY1sBj0Bd23OVGnO518gYViA90+frNpC99PkR/lV1MkIamBTgRFqk3RSVqKmSK4zSy914TYNnzsNaQt4mb/5ZXL7+B6xhMLnwPAtcLmjRUg8q3hOTj5mqIWMsTEhKpbfNYX8NV5QmP4zi6Q0kmzxcqlBBFawMFmHPxlyVDENxy2y4+NRb8OsU14+/r7huKGFES8tH2ItjxK9ODTire46diHIuffztxOah3CtNhRsrdEq2o/NgNaz3Tz/XyExYS05xBUfIUaTOocufc/JjqZ0kPvLj3bOQf8fCBKNGaIf4bDeclrUxCfHNRSVFU2PEaSYZPMiQnNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: zhongjinji <zhongjinji@honor.com>

The OOM reaper quickly reclaims a process's memory when the system hits OOM,
helping the system recover. Without the OOM reaper, if a process frozen by
cgroup v1 is OOM killed, the victim's memory cannot be freed, leaving the
system in a poor state. Even if the process is not frozen by cgroup v1,
reclaiming victims' memory remains important, as having one more process
working speeds up memory release.

When processes holding robust futexes are OOM killed but waiters on those
futexes remain alive, the robust futexes might be reaped before
futex_cleanup() runs. This can cause the waiters to block indefinitely [1].

To prevent this issue, the OOM reaper's work is delayed by 2 seconds [1]. Since
many killed processes exit within 2 seconds, the OOM reaper rarely runs after
this delay. However, robust futex users are few, so delaying OOM reap for all
victims is unnecessary.

If each thread's robust_list in a process is NULL, the process holds no robust
futexes. For such processes, the OOM reaper should not be delayed. For
processes holding robust futexes, to avoid issue [1], the OOM reaper must
still be delayed.

Patch 1 introduces process_has_robust_futex() to detect whether a process uses
robust futexes. Patch 2 delays the OOM reaper only for processes holding robust
futexes, improving OOM reaper performance. Patch 3 makes the OOM reaper and
exit_mmap() traverse the maple tree in opposite orders to reduce PTE lock
contention caused by unmapping the same vma.

Link: https://lore.kernel.org/all/20220414144042.677008-1-npache@redhat.com/T/#u [1]

---

v3 -> v4:

1. Rename check_robust_futex() to process_has_robust_futex() for clearer
   intent.
2. Because the delay_reap parameter was added to task_will_free_mem(),
   the function is renamed to should_reap_task() to better clarify
   its purpose.
3. Add should_delay_oom_reap() to decide whether to delay OOM reap.
4. Modify the OOM reaper to traverse the maple tree in reverse order; see patch
   3 for details.
These changes improve code readability and enhance OOM reaper behavior.

zhongjinji (3):
  futex: Introduce function process_has_robust_futex()
  mm/oom_kill: Only delay OOM reaper for processes using robust futexes
  mm/oom_kill: Have the OOM reaper and exit_mmap() traverse the maple
    tree in opposite orders

 include/linux/futex.h |  5 ++++
 include/linux/mm.h    |  3 +++
 kernel/futex/core.c   | 30 +++++++++++++++++++++++
 mm/oom_kill.c         | 55 +++++++++++++++++++++++++++++++------------
 4 files changed, 78 insertions(+), 15 deletions(-)

-- 
2.17.1


