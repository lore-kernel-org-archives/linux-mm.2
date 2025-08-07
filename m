Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3480C87FCF
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 12:14:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5D19E8E0002; Thu,  7 Aug 2025 08:14:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 581788E0001; Thu,  7 Aug 2025 08:14:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 497DA8E0002; Thu,  7 Aug 2025 08:14:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 367FE8E0001
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 08:14:44 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0C6D5CAD3
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:43 +0000 (UTC)
X-FDA: 83749854846.26.544C7DE
Received: from mailgw.kylinos.cn (mailgw.kylinos.cn [124.126.103.232])
	by imf11.hostedemail.com (Postfix) with ESMTP id BCB9A40015
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 12:14:39 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	spf=pass (imf11.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754568881; a=rsa-sha256;
	cv=none;
	b=YJllXHm+3ER60EiOPwqlN7HNyl+g73y4MTzlAD1xErgvcstQ3YwCAjQmijJnL7gfadXQOP
	zciWlNcRTe2BoNr92eNsrAZPxZJA7hBatykZb2c1rSpFbetbe6GEaUOf7hLTkAsmzaNp+t
	N3JJePNU02E/117oZPLQJysKuIJoFf8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of zhangzihuan@kylinos.cn designates 124.126.103.232 as permitted sender) smtp.mailfrom=zhangzihuan@kylinos.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754568881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references; bh=daPAtCpSsE4qwcnQOuv30uqqQDaTnvJ09MtEGpnkGWg=;
	b=43uz+kWQqsSUBBRTvcVh8Epi0AvdXELxVloz8LIc7g7UwxmZSpY4Y1Pd+3i3kuVTvOhOwS
	PnKQbSbIGiWtlDdqu8pRUvKTUQwU0auAaMCH2svWQpK/vSx7jR8MNlgZI+bzUlAYja3CDM
	tJFHwjLEiQip6jo0j7XqAtra+UmhWJg=
X-UUID: 124489dc738811f0b29709d653e92f7d-20250807
X-CID-P-RULE: Release_Ham
X-CID-O-INFO: VERSION:1.1.45,REQID:e53fbca3-e7ef-4682-8117-6db1420a6d82,IP:0,U
	RL:0,TC:0,Content:0,EDM:0,RT:0,SF:0,FILE:0,BULK:0,RULE:Release_Ham,ACTION:
	release,TS:0
X-CID-META: VersionHash:6493067,CLOUDID:b9d67b271981c8db314e5ca89b64c629,BulkI
	D:nil,BulkQuantity:0,Recheck:0,SF:102,TC:nil,Content:0|50,EDM:-3,IP:nil,UR
	L:99|1,File:nil,RT:nil,Bulk:nil,QS:nil,BEC:nil,COL:0,OSI:0,OSA:0,AV:0,LES:
	1,SPR:NO,DKR:0,DKP:0,BRR:0,BRE:0,ARC:0
X-CID-BVR: 0
X-CID-BAS: 0,_,0,_
X-CID-FACTOR: TF_CID_SPAM_ULS,TF_CID_SPAM_SNR
X-UUID: 124489dc738811f0b29709d653e92f7d-20250807
Received: from mail.kylinos.cn [(10.44.16.175)] by mailgw.kylinos.cn
	(envelope-from <zhangzihuan@kylinos.cn>)
	(Generic MTA)
	with ESMTP id 1858613604; Thu, 07 Aug 2025 20:14:30 +0800
Received: from mail.kylinos.cn (localhost [127.0.0.1])
	by mail.kylinos.cn (NSMail) with SMTP id 5F62AE01A758;
	Thu,  7 Aug 2025 20:14:30 +0800 (CST)
X-ns-mid: postfix-689498A5-59082161
Received: from localhost.localdomain (unknown [172.25.120.24])
	by mail.kylinos.cn (NSMail) with ESMTPA id DCC5EE0000B0;
	Thu,  7 Aug 2025 20:14:20 +0800 (CST)
From: Zihuan Zhang <zhangzihuan@kylinos.cn>
To: "Rafael J . Wysocki" <rafael@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Oleg Nesterov <oleg@redhat.com>,
	David Hildenbrand <david@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>
Cc: Ingo Molnar <mingo@redhat.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	len brown <len.brown@intel.com>,
	pavel machek <pavel@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Nico Pache <npache@redhat.com>,
	xu xin <xu.xin16@zte.com.cn>,
	wangfushuai <wangfushuai@baidu.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jeff Layton <jlayton@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Adrian Ratiu <adrian.ratiu@collabora.com>,
	linux-pm@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zihuan Zhang <zhangzihuan@kylinos.cn>
Subject: [RFC PATCH v1 0/9] freezer: Introduce freeze priority model to address process dependency issues
Date: Thu,  7 Aug 2025 20:14:09 +0800
Message-Id: <20250807121418.139765-1-zhangzihuan@kylinos.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BCB9A40015
X-Stat-Signature: zyyk938tfu1yhhtjt9zs1dqgqtmxtxy9
X-Rspam-User: 
X-HE-Tag: 1754568879-862995
X-HE-Meta: U2FsdGVkX18M9VzXKRUOUDuTNeijJGbwXCoM2SFbs3kPU1ontriH3iSLrG2PCiSnArWD6FmKwbRjg7kkLzZGzdJd3UxdCGc2NeFqjYhOzrCCee6Gjbggz5HeoYgkK3CJxZSuQCtDqCsDxcy5FrN3fOaULt3eqnuEWrfsgV6nBsVMRPlitkNptHB5mxZR8bvRcHX5p7wadTxgwqfot6dxgpOmGRi8ovRzTOtVAvMZLsu4ErG4unnN0mCsZvn5rZDBBKH30CpWOP3kGtqjTRwtdIj1nEKxldoo1A3XkSKKAFb+USYyStNhxIpS2NECHGpztPxiugFaZFYndX1dKED4GWYuZE09X/7oKjuqENHFnwZoJaUbNPwC4PKSSAZysGWXQ612K/v0CfexkrHJ8DgeLF5KKoRomHwO/xPoYxcZQO08HL0awrbuYgySOaXxleFOo+x7cQi0oI73oCnHenBrWWg3AMBfz5b+bwo1Iz//3uvg2N+HipcwTvwpZta9FC/sTgXPT84h92192UQl7CSphoLD5uG+raoGMIOubAxOOUHmjizteoYdYYmm2cZPP8t8VEtXDw3By92iNpomMRWvueKACStJxsT1b+RoYqiq+x43UO/+/yAmQ5YbdRWpHULDs2kv2FhJqw60PB+3SUQ2dENPvlzYOv8XH8xaUeSHEsP+Ezjs+ND3+M9YWTpiyfC18LldiNMZp5cx36ZlgP+oi/dsiGaDBG/Hp0jwikVAhvOkJY3TOKZUKh/ti+9gI1O1TOwBEJ6pDhq7DCDlLGEvNch4nriL8mHRXfkIadht25/ObhZGd4/e1JanFNgMOK7wrlgkEGEQqRqpqWBVgNxRavJjLyCfa2xIv7dyVMsJ7wahGfFuHyT0lGkThvbHv9/NMgl5fqUWgxWyNgqaRDW6CSOAj8G/MHDxrBkep5b7z/XAqEdsAo7yXxyvKqzkyGdYRhvG4ILD7oqqFCDUhNi
 jfdB9Jj4
 OIoEUFO+hgFXIMvdufyz9MjZZ+2Ncfk4h2FVKVSs4c+LqdEWfGNCRUA8ssSOq3t1Vtd/0ha/1xFQM7tQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The Linux task freezer was designed in a much earlier era, when userspace=
 was relatively simple and flat.
Over the years, as modern desktop and mobile systems have become increasi=
ngly complex=E2=80=94with intricate IPC,
asynchronous I/O, and deep event loops=E2=80=94the original freezer model=
 has shown its age.

## Background

Currently, the freezer traverses the task list linearly and attempts to f=
reeze all tasks equally.
It sends a signal and waits for `freezing()` to become true. While this m=
odel works well in many cases, it has several inherent limitations:

- Signal-based logic cannot freeze uninterruptible (D-state) tasks
- Dependencies between processes can cause freeze retries=20
- Retry-based recovery introduces unpredictable suspend latency

## Real-world problem illustration

Consider the following scenario during suspend:

Freeze Window Begins

    [process A] - epoll_wait()
        =E2=94=82
        =E2=96=BC
    [process B] - event source (already frozen)

=E2=86=92 A enters D-state because of waiting for B
=E2=86=92 Cannot respond to freezing signal
=E2=86=92 Freezer retries in a loop
=E2=86=92 Suspend latency spikes

In such cases, we observed that a normal 1=E2=80=932ms freezer cycle coul=
d balloon to **tens of milliseconds**.=20
Worse, the kernel has no insight into the root cause and simply retries b=
lindly.

## Proposed solution: Freeze priority model

To address this, we propose a **layered freeze model** based on per-task =
freeze priorities.

### Design

We introduce 4 levels of freeze priority:


| Priority | Level             | Description                       |
|----------|-------------------|-----------------------------------|
| 0        | HIGH              | D-state TASKs                     |
| 1        | NORMAL            | regular  use space TASKS          |
| 2        | LOW               | not yet used                      |
| 4        | NEVER_FREEZE      | zombie TASKs , PF_SUSPNED_TASK    |


The kernel will freeze processes **in priority order**, ensuring that hig=
her-priority tasks are frozen first.
This avoids dependency inversion scenarios and provides a deterministic p=
ath forward for tricky cases.
By freezing control or event-source threads first, we prevent dependent t=
asks from entering D-state prematurely =E2=80=94 effectively avoiding dep=
endency inversion.

Although introducing more fine-grained freeze_priority levels improves ex=
tensibility and allows better modeling of task dependencies,=20
it may also introduce additional overhead during task traversal, potentia=
lly affecting freezer performance.

In our test environment, increasing the maximum freeze retries to 16 only=
 added ~4ms of overhead to the total suspend latency,
suggesting the added robustness comes at a relatively low cost. However, =
for latency-critical systems, this trade-off should be carefully evaluate=
d.

## Benefits

- Solves D-state process freeze stalls caused by premature freezing of de=
pendencies
- Enables more robust and reliable suspend/resume on complex userspace sy=
stems
- Introduces extensibility: tasks can be categorized by role, urgency, or=
 dependency
- Reduces race conditions by introducing deterministic freezing order

## Previous Discussion
Link: https://lore.kernel.org/all/20250606062502.19607-1-zhangzihuan@kyli=
nos.cn/
Link: https://lore.kernel.org/all/1ca889fd-6ead-4d4f-a3c7-361ea05bb659@ky=
linos.cn/

## Future directions

This framework opens up several promising areas for further development:

1. Adaptive behavior based on runtime statistics or retry feedback
The freezer adapts dynamically during suspend/hibernate based on the numb=
er of retries and which tasks failed to freeze.=20
Tasks that failed in previous rounds will be assigned a higher freeze pri=
ority, improving convergence speed and reducing unnecessary retries.

2. cgroup-aware hierarchical freezing for containerized systems
The design supports cgroup-aware task traversal and freezing.=20
This ensures compatibility with containerized environments, allowing for =
better control and visibility when freezing processes in different cgroup=
s.

3. Unified freezing of userspace processes and kernel threads
Based on extensive testing, we found that freezing userspace tasks and ke=
rnel threads together works reliably in practice.=20
Separating them does not resolve dependency issues between user and kerne=
l context. Moreover, most kernel threads are marked as non-freezable,
so including them in the same freeze pass does not impact correctness and=
 simplifies the logic.

Although the current implementation is relatively simple, it already help=
s alleviate some suspend failures caused by tasks stuck in D state.
In our testing, we observed that certain D-state tasks are triggered by f=
ilesystem sync operations during the freezing phase.
At this stage, we don't yet have a comprehensive solution for that class =
of problems.
This patchset represents a testable version of our design. We plan to fur=
ther investigate and address such filesystem-related D-state issues in fu=
ture revisions.

Patch summary:
 - Patch 1-3: Core infrastructure: field, API, layered freeze logic
 - Patch 4-7: Default priorities and dynamic adjustments
 - Patch 8: Statistics: freeze pass retry count
 - Patch 9: Procfs interface for userspace access

Zihuan Zhang (9):
  freezer: Introduce freeze_priority field in task_struct
  freezer: Introduce API to set per-task freeze priority
  freezer: Add per-priority layered freeze logic
  freezer: Set default freeze priority for userspace tasks
  freezer: set default freeze priority for PF_SUSPEND_TASK processes
  freezer: Set default freeze priority for zombie tasks
  freezer: raise freeze priority of tasks failed to freeze last time
  freezer: Add retry count statistics for freeze pass iterations
  proc: Add /proc/<pid>/freeze_priority interface

 Documentation/filesystems/proc.rst | 14 ++++++-
 fs/proc/base.c                     | 64 ++++++++++++++++++++++++++++++
 include/linux/freezer.h            | 20 ++++++++++
 include/linux/sched.h              |  3 ++
 kernel/fork.c                      |  1 +
 kernel/power/process.c             | 23 ++++++++++-
 kernel/sched/core.c                |  2 +
 7 files changed, 124 insertions(+), 3 deletions(-)

--=20
2.25.1


