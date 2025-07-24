Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E56BAC83F26
	for <linux-mm@archiver.kernel.org>; Thu, 24 Jul 2025 12:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64E4C8E0078; Thu, 24 Jul 2025 08:36:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626228E0074; Thu, 24 Jul 2025 08:36:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 562B58E0078; Thu, 24 Jul 2025 08:36:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4648B8E0074
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 08:36:37 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03B7558BA4
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:36 +0000 (UTC)
X-FDA: 83699106834.06.2C57052
Received: from fanzine2.igalia.com (fanzine2.igalia.com [213.97.179.56])
	by imf25.hostedemail.com (Postfix) with ESMTP id 2EEFCA0006
	for <linux-mm@kvack.org>; Thu, 24 Jul 2025 12:36:34 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oKKf19rc;
	spf=pass (imf25.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753360595;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=kTMLqhd8ACCARh9s+Oizrnftx6KSLEeKOV2ICyEnYoY=;
	b=kqNsZBjqiBibZvX1wwhUQZJTZNSzSzyVxwaHVLSEV5mQIL2QxtROVqY3wB6XGjPvwoR6u9
	VJfVuswvs7ZCvQoNdtEs15MgZTO3DB3LCaB4MT4S/bI82Ygh8zEKBZskFk+OlhgkWl6PKa
	P/0rpib5vTcnsQWMGnSVXa+fq3iQQNk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=igalia.com header.s=20170329 header.b=oKKf19rc;
	spf=pass (imf25.hostedemail.com: domain of bhupesh@igalia.com designates 213.97.179.56 as permitted sender) smtp.mailfrom=bhupesh@igalia.com;
	dmarc=pass (policy=none) header.from=igalia.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753360595; a=rsa-sha256;
	cv=none;
	b=VXcRtw5BsMdzAkeBLVMLVsrKbcUjozW6p2SG0WiEjepIkFDQnhXPboM3EzxFCT/B6gtJcz
	oirj22gOryVX1del2p4GLDtPUCp+CUP1YXWbwUKW6Ih8OGbO9FVTLCiEG2fZvCxBD3OTAQ
	pNMLttHgQqvJ7rhgows9reGuo37DaOc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
	Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:Content-Description:
	Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=kTMLqhd8ACCARh9s+Oizrnftx6KSLEeKOV2ICyEnYoY=; b=oKKf19rcSSkXTmh1MA4PBQ476N
	Dv3eNo+L1JatFoA7T5mrN2+0OjQpe9OOPJeq+sLXSTrhk1TnBydE5RZQfkN722JNdB79sqWpM/S/k
	SIBrZlAONRmg1WSKBvqyRC/RxwEYhSxCQF6b6z7TwiE8egFWj/r02JlskgE0vh6BWhOCzakc61IKE
	e80rAKtvATtYf6XkZ3nbtIbfiRbic7M/JoxsKYtuMxugNwJTADNPT6JCwx44KstSCLVdWH5aqjQcO
	lHDHjmRULKVLzCGI5kDyND0+Uz8TE5nsLCM1RnktS+EKRpEzC3OIkBNRIAXv+r0HQd3g47yrH9Mv3
	mn74TWMg==;
Received: from [223.233.78.24] (helo=localhost.localdomain)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1uevBR-003BPU-D2; Thu, 24 Jul 2025 14:36:25 +0200
From: Bhupesh <bhupesh@igalia.com>
To: akpm@linux-foundation.org
Cc: bhupesh@igalia.com,
	kernel-dev@igalia.com,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	linux-perf-users@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	oliver.sang@intel.com,
	lkp@intel.com,
	laoar.shao@gmail.com,
	pmladek@suse.com,
	rostedt@goodmis.org,
	mathieu.desnoyers@efficios.com,
	arnaldo.melo@gmail.com,
	alexei.starovoitov@gmail.com,
	andrii.nakryiko@gmail.com,
	mirq-linux@rere.qmqm.pl,
	peterz@infradead.org,
	willy@infradead.org,
	david@redhat.com,
	viro@zeniv.linux.org.uk,
	keescook@chromium.org,
	ebiederm@xmission.com,
	brauner@kernel.org,
	jack@suse.cz,
	mingo@redhat.com,
	juri.lelli@redhat.com,
	bsegall@google.com,
	mgorman@suse.de,
	vschneid@redhat.com,
	linux-trace-kernel@vger.kernel.org,
	kees@kernel.org,
	torvalds@linux-foundation.org
Subject: [PATCH v6 0/3] Add support for long task name
Date: Thu, 24 Jul 2025 18:06:09 +0530
Message-Id: <20250724123612.206110-1-bhupesh@igalia.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 2EEFCA0006
X-Rspamd-Server: rspam06
X-Stat-Signature: dj377a41pp7en5qjbddc5gnx8sdq8ozs
X-HE-Tag: 1753360594-484557
X-HE-Meta: U2FsdGVkX1/5plnFCQU2FCbD8QDOAeIZRZPfsoV8OrxAsWzvVps2v+3Y+sEOdwW2XcUxYQskLwX/VR2yguUOlhpCzYEpnP70dH/rkR4FQl8d4QZtsUl0/Nr+uZXjsIrDbyfU6b3vy059gC7kae6FN5iIgGeprLjDvdNquynILT19O9lVuJTSqucgY8QaqEaJ8FqG4El1uz84/qMMU3UQcfkhgB/QArJHhVmGM+409V+4peXH/Cv/Bvy7QCEJmmiewnVeZ6IHT12R/xUsxgCSG/Zd8MCoIgHr5gCGBnIWR+gi+FnOHRS+6CQp3j8BKGaZ3TH/g333RAGQVEkEfskMLsfAUGRCF7PXbmLhPMYl8GTY5mesID6zinl/ue7p6kkf/yadLn8wjHtdlrasdRvr1R4PdlFwrTmoQWSvpTYTPaSsM2cfydPWmjMFl1oSzmbhSXqaZIhGbrwO31K+3aQSU/sJhi+H8BE4WkNgRlu1J/99I0ghD+TUUZ5LrriKL8/8KS7EDOgLDVo4ryuFglQd1r4gOW25oW0jCpoHXWtvO/bmrUCk7nIT0w8dCDisU0PstK785a5ADT92kV6dHKN0m+JpmzNIVEX8li4FUFd66Jhj4FGkm+kvfuOD7vwPKlR+GuRozIRHRwhjfhFWMLeFNX1RztyUiroaM5bVL+Effh1ERGMsdSb++g9jzQsUfLqQEWKVW3zmbWUiq0L41VKTWX1/XO5iVGSNZzl6ScPyVcP/vCG+f13OV8ks22uCtom2qmwp63REaa+QiNASKYSywTJSgxXAec4zMY8+hwzHzceyjLQWFeHQeU4ehc73NZk3yV7LdwFI59xR2aoZ54/MFqRGxnemAGXZvf5QMMrftfEXEJLnW2u7SLfBsnxQZ866tI97tKdzv5yGB2DqI744DVI4lfs4E0rQ94nx5le+ZK+VqLZZgvq7bOZoa8ie2XZfx4JekduSVeTuWPwfSi7
 xXBkMlI8
 nMxE862zX0IExNKg73dva50tPeUEgQYQKMUeS653aLhlXuye6OJr3tFVwlRdYnAjnmTM8LDm0cGAjZcyeWY6on/wKpiW3x8chEYOFqJZKEv/NktDw8NzT1uXi2EENRpzolzLeNTKs0xbm9R9yQdAGwo9DNb9nvn2P/xGZunAQIUNfBSYxAlDqa5YNyqpwJX1Wecp21NSQ4+iNANxlZkfVjpF7emRUyUIORNa4s+INmbLcmOrVRLlT928ukvFPvF++chpb2VGSiOjdJYZf+qEpgdfn25sMn9/0cvy5NzezOtjVJHMneWfzzHpwYduVvQndZo59/CR/7LQ7SgkZQbj9UaCHmZi08LPp1rfXZBnDlPRPtxqmQffnC1B5Gexa9NlPGI3tqjQHW0u36+BTjYHfWxq5K1LAtGXbKb4O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes since v5:
================
- v5 can be seen here: https://lore.kernel.org/lkml/20250716123916.511889-1-bhupesh@igalia.com/ 
- As suggested by Linus, replaced 'tsk->comm' with 'tsk->comm_str' locally, and verified basic
  thread names and then changed 'tsk->comm_str' back to 'tsk->comm'. So essentially now 'tsk->comm'
  is TASK_COMM_EXT_LEN i.e. 64-bytes long.

Changes since v4:
================
- v4 can be seen here: https://lore.kernel.org/lkml/20250521062337.53262-1-bhupesh@igalia.com/ 
- As suggested by Kees, replaced tsk->comm with tsk->comm_str, inside 'task_struct'
  where TASK_COMM_EXT_LEN is 64-bytes.

Changes since v3:
================
- v3 can be seen here: https://lore.kernel.org/lkml/20250507110444.963779-1-bhupesh@igalia.com/
- As suggested by Petr and Steven, used 'comm_ext' name instead of
  'real_comm'. Correspondingly the macro name is changed to 'TASK_COMM_EXT_LEN'
  for the 64-byte extended comm.
- Rebased this patchset on linux-next/master, which contain the following patch from
  Steven now:
       155fd6c3e2f0 ("tracing/sched: Use __string() instead of fixed lengths for task->comm")
- Accordingly, v4 drops the changes done for 'trace/sched' events in v3,
  but retains the 'safe' memcpy' changes for other kernel trace users.

Changes since v2:
================
- v2 can be seen here: https://lore.kernel.org/lkml/20250331121820.455916-1-bhupesh@igalia.com/
- As suggested by Yafang and Kees, picked Linus' suggested approach for
  this version (see: <https://lore.kernel.org/all/CAHk-=wjAmmHUg6vho1KjzQi2=psR30+CogFd4aXrThr2gsiS4g@mail.gmail.com/>).
- Dropped kthreads patch from this version. It would be sent out
  separately, if we have a consensus on this approach.

Changes since v1:
================
- v1 can be seen here: https://lore.kernel.org/lkml/20250314052715.610377-1-bhupesh@igalia.com/
- As suggested by Kees, added [PATCH 3/3] to have a consistent
  'full_name' entry inside 'task_struct' which both tasks and
  kthreads can use.
- Fixed the commit message to indicate that the existing ABI
  '/proc/$pid/task/$tid/comm' remains untouched and a parallel
  '/proc/$pid/task/$tid/full_name' ABI for new (interested) users.

While working with user-space debugging tools which work especially
on linux gaming platforms, I found that the task name is truncated due
to the limitation of TASK_COMM_LEN.

Now, during debug tracing, seeing truncated names is not very useful,
especially on gaming platforms where the number of tasks running can
be very high.

This patchset does not touch 'TASK_COMM_LEN' at all, i.e.
'TASK_COMM_LEN' and the 16-byte design remains untouched.

Via this patchset, Linus suggested 'tsk->comm' is made 64-byte long
and equal to TASK_COMM_EXT_LEN.

To avoid any surprises / bug,s I replaced 'tsk->comm' with
'tsk->comm_str' locally inside 'task_struct' and checked compilation
of code and basic working of thread names:

       struct task_struct {
	       ..............
               char    comm_str[TASK_COMM_EXT_LEN];
	       ..............
       };

       where TASK_COMM_EXT_LEN is 64-bytes.

Once done, I changed the name back to 'tsk->comm'.

To ensure that the existing ABI and userspace continues to work
as intended, we ensure that:

- Existing users of 'get_task_comm'/ 'set_task_comm' will get 'tsk->comm'
  truncated to a maximum of 'TASK_COMM_LEN' (16-bytes) to maintain ABI,
- New / Modified users of 'get_task_comm'/ 'set_task_comm' will get
 'tsk->comm' supported up to a maximum of 'TASK_COMM_EXT_LEN' (64-bytes).

Note, that the existing users have not been modified to migrate to
'TASK_COMM_EXT_LEN', in case they have hard-coded expectations of
dealing with only a 'TASK_COMM_LEN' long 'tsk->comm_str'.

After this change, gdb is able to show full name of the task, using a
simple app which generates threads with long names [see 1]:
  # gdb ./threadnames -ex "run info thread" -ex "detach" -ex "quit" > log
  # cat log

  NameThatIsTooLongForComm[4662]

[1]. https://github.com/lostgoat/tasknames

Bhupesh (3):
  exec: Remove obsolete comments
  treewide: Switch memcpy() users of 'task->comm' to a more safer
    implementation
  include: Set tsk->comm length to 64 bytes

 include/linux/coredump.h       |  3 ++-
 include/linux/sched.h          | 15 +++++++++------
 include/trace/events/block.h   |  5 +++++
 include/trace/events/oom.h     |  1 +
 include/trace/events/osnoise.h |  1 +
 include/trace/events/signal.h  |  1 +
 include/trace/events/task.h    |  2 ++
 7 files changed, 21 insertions(+), 7 deletions(-)

-- 
2.38.1


