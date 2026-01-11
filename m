Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3D86D25032
	for <linux-mm@archiver.kernel.org>; Sun, 11 Jan 2026 15:03:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D71366B0088; Sun, 11 Jan 2026 10:02:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D48DF6B008A; Sun, 11 Jan 2026 10:02:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B28F16B0089; Sun, 11 Jan 2026 10:02:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 960506B0088
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 10:02:59 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 57B058C919
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:02:59 +0000 (UTC)
X-FDA: 84320000478.15.BA908F3
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD98140007
	for <linux-mm@kvack.org>; Sun, 11 Jan 2026 15:02:57 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=UXNGsBbr;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768143777; a=rsa-sha256;
	cv=none;
	b=oe0SI2l4S1BQpWhMdorP+ODzUATdEebwfT3CKdXrRlq/XBse2HTUuq7Y+wvQemhs0EuLK9
	yKmHfGbce5xTTjgcXndc7H28m7P2nFpKrjsw4jWCRDrpe8TzKSai07xhcywHd5WFq4BIPL
	Ga/ip9edoD2zbEqiESBoIEUUd2aBLCg=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=UXNGsBbr;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf12.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768143777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vkmsfle22pVmKXtvq8PcDUm92li+Ms783mF1Ynp+MPQ=;
	b=YH0EYMAl6QQ1Wmsl3LZJrDnet0jH4jh0ry6XQwkernpBTZlYPuMQBehJpzZosM6QWdrMKQ
	SSqqvr94pnkDRe6TyF/LaFtU76tAMtZQOGMk7bMU5XerepFFpRF8ozJ/X/bbfxChybzv/b
	SYWrNSJeWIqo+YxilslGTvhCFxl8fx0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768143777;
	bh=vkmsfle22pVmKXtvq8PcDUm92li+Ms783mF1Ynp+MPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UXNGsBbrX2cSUKU+2uzq8b1fxuY4uIDgPd9dHDlXDbcxU2udzyjqAwBSc8bR9+YVB
	 cGyBqVGlwLUiTNpw9zKJkgyBpzusEUonfnARwlirjEw4oz/KZGwKbdhFfh+qWX0gYm
	 R42zlBeQ/SDsv7VCjDiWTal+IXdgGAyZToRC061hDiWRS6DOVWfPVMozDEQ9egLA7G
	 NZWqW4u5GM2bTHstHCpnjRsfsvWFA3WBQGrr8nPEKOQ8mdbJQyU3Jvtjzhg2NxM27y
	 BbqOXDuwu9JC9+VJ5CgMgFlIGCHlAFayuvFf3k+Pit4Uc+ARztdVyT65kcBp9I203o
	 +ZdzGTBN0sbAA==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:a253:d09e:90e7:323f])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dpzJw6S6WzlX4;
	Sun, 11 Jan 2026 10:02:56 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R . Howlett" <liam.howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>
Subject: [PATCH v12 3/3] mm: Implement precise OOM killer task selection
Date: Sun, 11 Jan 2026 10:02:49 -0500
Message-Id: <20260111150249.1222944-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
References: <20260111150249.1222944-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD98140007
X-Rspamd-Server: rspam06
X-Stat-Signature: zjxapng7zcdrzm8grcs9gwn5j8wszhxu
X-Rspam-User: 
X-HE-Tag: 1768143777-533512
X-HE-Meta: U2FsdGVkX1/Tb5V6u1qay0HMWYNpGGavaD1aRCgDqF6TBIKpXfoZQyLTHbM/q8ipTELK7sK3tW6l1rfj8t7tdAgk3sN2edYBO7GQRn0Srgzz/sNBK8JoQiQvDOTUh+0LTWFnryFNvrvzcHwbTBSt/fV8tnMWdJIttgjxPlx7yPl5uzyiACuf5idwYBP1AWO8ciN000yf1EHQyX5BrYxwx32AJgiRo+DDYikdPoer+896ve/hLmIH0hj36WSnEjU0jLoGNZeAcVrrs05o3MmdE5By12VpA8xqYWiXnNQ9Pweq8uwZivCQISdcLfcEFlkW8DZTRrsOz/PFJ766sOtSG/Cb/D8Y30uURBCYigGQgNbK4Ju3qS3fWQ+HZ/iVQxoFEK11aROCHLJMM6oX9Gp5oZGeUar+yFGpS/Csfhxgj/IBd1m9EGr3sz1YcXVuAG0R7HHKnMx9VYyWqSc7udqOVZ/bOSMmD7A10HDm8/aAYBxVVBzm5Pu5PhG6x5cBGaSEyI0cfnyz+LZkY571nIhFD0VRLUHPgIRs1zMJiMTbNV5huhgLR5bYiUP7LvjtVDeUt2A3n61tK+nzS2kurBrp5rJJgU/pa94ZEtvRTQAOMENoZ1tAt87Wvx0HHH6HZhZGb7GGZJmxdqBl5bt7Cpz9d+mkxdzQpYbtGaVqDPtbtoZb1LmglAha3AOulY8iK83lVY08XJmjjEwHtLf7CuUhG1z7oo6Miu9r6aaEPX0fprm/JhqCuBUtO9aILGVMb6m0xsD+KHmVoZpxMlcCPuI7be+ST/u276dh+sc67bLAw+cAffg4d3dLnUvp8CWoAA4nxgcU0jVrNlMUFZzwCVfp+0AKXyZ9ITzBqMmcjJ5sjLXEATQpm5U/0XCah8ltobR9v7lIF+VHobsEl2P9ojLg5zH8nqmfdxzwCmFXRCvO/1WNIcOWkPAHuundZHWjKs3+fW1rgPMDxiiV+0vBYuN
 eK7aKaFN
 JUKLlFynq13hIUgsMf+Hh4KGTLx2HkteM16SfqjOu0drouyBMz9DOevMCxps0oXlIuhS+z2yWRiCsebtVPzjW8I+JpSaE6O965aMUNX1xi6lEWF13ozgEF4i2LigNWC/Tgay9+F4+eLE0wr1I+s14H7h1z/4FBVT1U2ZlhB6+X+rfpXgKA9+WDy7GMuwsfuyDgLxznjwiwdCZXsYTBmcUc2+JRf4GcmbF7KipwaHBiNYV1NbFJEVkdMFNTJ6KTB8oM+0h1G4cZrxk7JHSIHJHgkE50NA2McYEPA9DO06GK/SNKcWEzPeWQcwQvB7TrKkYRp1X3ctRsPmGQg8o7PVPFyxrIQHXMPZ+b63BytkhrQqdA8fDQeGJVJaoQDiPYusKJCeR6cG99ZntuCIlx7Zq3T54X1n7bt5pDtPIJKPogyOZ5PP1bCY5yIoVjtI6sE5mvYttW64Nrz6LiAK7SLgpJmK+LcfpiabtJkWGnOGVHJEPEb7s5x/fdDBj+V0pPPn1Kflda42JIIRj1OMZWKytFYx3gUyinxJa2L9V6r3bKc7T0cndJ/RA9AQdFY7FI7ght3emSC3uQwuyrxifUCx3SobYJG3ujc2vmVQjLwvpIc3TiVUrWuMQ/kjmLiAwKCOAcFhpVegnZZ7YoQXG+gavrpW27PveQSffxJxq4f6YRJG6Pxx9OxLkSX8JyQicR4AjiCsPDJidsX40aFt+i0JJ/bA8T3SDTqvUZQZIeAbYJkMXdQIn2WDC3vH4Z3x8LsTHeA/0Vmdu/eWB1Zw0uxoQPhZ0i3GZgE3XE1qzRF0n7SoJdkgspljUgrzNA58iXknrclMIgEAbTd3xF0l5/bWe1k4CU/K3+mlORMc4m0lP1DXasPSLeWYNJ8XJr3V5HTKq7QB100z7SsvRf/KiePCqm9ztdlLZFFnij3kJ1YFQSgklvATFn7KkTV2IFABuMRYALOAF0TGdwI9ug0iWZ9QYxqf4n91f
 SW7BF6R2
 QENGA9mJaBOFTtKPwvcPypRCPz/k13tivka/1UoZGutDIhtuhIPe8VV1mtfRT0lbYJUB7BuqcExLaLaNUg4Vse5KfjKv+QOWG0+hBEcL2qI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the hierarchical tree counter approximation to implement the OOM
killer task selection with a 2-pass algorithm. The first pass selects
the process that has the highest badness points approximation, and the
second pass compares each process using the current max badness points
approximation.

The second pass uses an approximate comparison to eliminate all processes
which are below the current max badness points approximation accuracy
range.

Summing the per-CPU counters to calculate the precise badness of tasks
is only required for tasks with an approximate badness within the
accuracy range of the current max points value.

Limit to 16 the maximum number of badness sums allowed for an OOM killer
task selection before falling back to the approximated comparison. This
ensures bounded execution time for scenarios where many tasks have
badness within the accuracy of the maximum badness approximation.

Tested with the following script:

  #!/bin/sh

  for a in $(seq 1 10); do (tail /dev/zero &); done
  sleep 5
  for a in $(seq 1 10); do (tail /dev/zero &); done
  sleep 2
  for a in $(seq 1 10); do (tail /dev/zero &); done
  echo "Waiting for tasks to finish"
  wait

Results: OOM kill order on a 128GB memory system
================================================

* systemd and sd-pam are chosen first due to their oom_score_ajd:100:

Out of memory: Killed process 3502 (systemd) total-vm:20096kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:72kB oom_score_adj:100
Out of memory: Killed process 3503 ((sd-pam)) total-vm:21432kB, anon-rss:0kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:76kB oom_score_adj:100

* The first batch of 10 processes are gradually killed, consecutively
  picking the one that uses the most memory. The fact that we are
  freeing memory from the previous processes increases the threshold
  at which the remaining processes of that group are killed. Processes
  from the second and third batches of 10 processes have time to start
  before we complete killing the first 10 processes:

Out of memory: Killed process 3703 (tail) total-vm:6591280kB, anon-rss:6578176kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:12936kB oom_score_adj:0
Out of memory: Killed process 3705 (tail) total-vm:6731716kB, anon-rss:6709248kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:13212kB oom_score_adj:0
Out of memory: Killed process 3707 (tail) total-vm:6977216kB, anon-rss:6946816kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:13692kB oom_score_adj:0
Out of memory: Killed process 3699 (tail) total-vm:7205640kB, anon-rss:7184384kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:14136kB oom_score_adj:0
Out of memory: Killed process 3713 (tail) total-vm:7463204kB, anon-rss:7438336kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:14644kB oom_score_adj:0
Out of memory: Killed process 3701 (tail) total-vm:7739204kB, anon-rss:7716864kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:15180kB oom_score_adj:0
Out of memory: Killed process 3709 (tail) total-vm:8050176kB, anon-rss:8028160kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:15792kB oom_score_adj:0
Out of memory: Killed process 3711 (tail) total-vm:8362236kB, anon-rss:8339456kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:16404kB oom_score_adj:0
Out of memory: Killed process 3715 (tail) total-vm:8649360kB, anon-rss:8634368kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:16972kB oom_score_adj:0
Out of memory: Killed process 3697 (tail) total-vm:8951788kB, anon-rss:8929280kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:17560kB oom_score_adj:0

* Even though there is a 2 seconds delay between the 2nd and 3rd batches
  those appear to execute in mixed order. Therefore, let's consider them
  as a single batch of 20 processes. We are hitting oom at a lower
  memory threshold because at this point the 20 remaining proceses are
  running rather than the previous 10. The process with highest memory
  usage is selected for oom, thus making room for the remaining
  processes so they can use more memory before they fill the available
  memory, thus explaining why the memory use for selected processes
  gradually increases, until all system memory is used by the last one:

Out of memory: Killed process 3731 (tail) total-vm:7089868kB, anon-rss:7077888kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:13912kB oom_score_adj:0
Out of memory: Killed process 3721 (tail) total-vm:7417248kB, anon-rss:7405568kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:14556kB oom_score_adj:0
Out of memory: Killed process 3729 (tail) total-vm:7795864kB, anon-rss:7766016kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:15300kB oom_score_adj:0
Out of memory: Killed process 3723 (tail) total-vm:8259620kB, anon-rss:8224768kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:16208kB oom_score_adj:0
Out of memory: Killed process 3737 (tail) total-vm:8695984kB, anon-rss:8667136kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:17060kB oom_score_adj:0
Out of memory: Killed process 3735 (tail) total-vm:9295980kB, anon-rss:9265152kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:18240kB oom_score_adj:0
Out of memory: Killed process 3727 (tail) total-vm:9907900kB, anon-rss:9895936kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:19428kB oom_score_adj:0
Out of memory: Killed process 3719 (tail) total-vm:10631248kB, anon-rss:10600448kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:20844kB oom_score_adj:0
Out of memory: Killed process 3733 (tail) total-vm:11341720kB, anon-rss:11321344kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:22232kB oom_score_adj:0
Out of memory: Killed process 3725 (tail) total-vm:12348124kB, anon-rss:12320768kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:24204kB oom_score_adj:0
Out of memory: Killed process 3759 (tail) total-vm:12978888kB, anon-rss:12967936kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:25440kB oom_score_adj:0
Out of memory: Killed process 3751 (tail) total-vm:14386412kB, anon-rss:14352384kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:28196kB oom_score_adj:0
Out of memory: Killed process 3741 (tail) total-vm:16153168kB, anon-rss:16130048kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:31652kB oom_score_adj:0
Out of memory: Killed process 3753 (tail) total-vm:18414856kB, anon-rss:18391040kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:36076kB oom_score_adj:0
Out of memory: Killed process 3745 (tail) total-vm:21389456kB, anon-rss:21356544kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:41904kB oom_score_adj:0
Out of memory: Killed process 3747 (tail) total-vm:25659348kB, anon-rss:25632768kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:50260kB oom_score_adj:0
Out of memory: Killed process 3755 (tail) total-vm:32030820kB, anon-rss:32006144kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:62720kB oom_score_adj:0
Out of memory: Killed process 3743 (tail) total-vm:42648456kB, anon-rss:42614784kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:83504kB oom_score_adj:0
Out of memory: Killed process 3757 (tail) total-vm:63971028kB, anon-rss:63938560kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:125228kB oom_score_adj:0
Out of memory: Killed process 3749 (tail) total-vm:127799660kB, anon-rss:127778816kB, file-rss:0kB, shmem-rss:0kB, UID:1000 pgtables:250140kB oom_score_adj:0

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux.com>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: "Liam R . Howlett" <liam.howlett@oracle.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-mm@kvack.org
Cc: linux-trace-kernel@vger.kernel.org
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
---
Changes since v11:
- get_mm_counter_sum() returns a precise sum.
- Use unsigned long type rather than unsigned int for accuracy.
- Use precise sum min/max calculation to compare the chosen vs
  current points.
- The first pass finds the maximum task's min points. The
  second pass eliminates all tasks for which the max points
  are below the currently chosen min points, and uses a precise
  sum to validate the candidates which are possibly in range.
---
 fs/proc/base.c      |  2 +-
 include/linux/mm.h  | 34 ++++++++++++++++---
 include/linux/oom.h | 11 +++++-
 kernel/fork.c       |  2 +-
 mm/oom_kill.c       | 82 +++++++++++++++++++++++++++++++++++++--------
 5 files changed, 109 insertions(+), 22 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 4eec684baca9..d75d0ce97032 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -589,7 +589,7 @@ static int proc_oom_score(struct seq_file *m, struct pid_namespace *ns,
 	unsigned long points = 0;
 	long badness;
 
-	badness = oom_badness(task, totalpages);
+	badness = oom_badness(task, totalpages, false, NULL, NULL);
 	/*
 	 * Special case OOM_SCORE_ADJ_MIN for all others scale the
 	 * badness value into [0, 2000] range which we have been
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6d938b3e3709..680f2811702e 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2855,14 +2855,32 @@ static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct m
 /*
  * per-process(per-mm_struct) statistics.
  */
+static inline unsigned long __get_mm_counter(struct mm_struct *mm, int member, bool approximate,
+					     unsigned long *accuracy_under, unsigned long *accuracy_over)
+{
+	if (approximate) {
+		if (accuracy_under && accuracy_over) {
+			unsigned long under, over;
+
+			percpu_counter_tree_approximate_accuracy_range(&mm->rss_stat[member], &under, &over);
+			*accuracy_under += under;
+			*accuracy_over += over;
+		}
+		return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
+	} else {
+		return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
+	}
+}
+
 static inline unsigned long get_mm_counter(struct mm_struct *mm, int member)
 {
-	return percpu_counter_tree_approximate_sum_positive(&mm->rss_stat[member]);
+	return __get_mm_counter(mm, member, true, NULL, NULL);
 }
 
+
 static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 {
-	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
+	return __get_mm_counter(mm, member, false, NULL, NULL);
 }
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
@@ -2903,11 +2921,17 @@ static inline int mm_counter(struct folio *folio)
 	return mm_counter_file(folio);
 }
 
+static inline unsigned long __get_mm_rss(struct mm_struct *mm, bool approximate,
+					 unsigned long *accuracy_under, unsigned long *accuracy_over)
+{
+	return __get_mm_counter(mm, MM_FILEPAGES, approximate, accuracy_under, accuracy_over) +
+		__get_mm_counter(mm, MM_ANONPAGES, approximate, accuracy_under, accuracy_over) +
+		__get_mm_counter(mm, MM_SHMEMPAGES, approximate, accuracy_under, accuracy_over);
+}
+
 static inline unsigned long get_mm_rss(struct mm_struct *mm)
 {
-	return get_mm_counter(mm, MM_FILEPAGES) +
-		get_mm_counter(mm, MM_ANONPAGES) +
-		get_mm_counter(mm, MM_SHMEMPAGES);
+	return __get_mm_rss(mm, true, NULL, NULL);
 }
 
 static inline unsigned long get_mm_hiwater_rss(struct mm_struct *mm)
diff --git a/include/linux/oom.h b/include/linux/oom.h
index 7b02bc1d0a7e..f8e5bfaf7b39 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -48,6 +48,12 @@ struct oom_control {
 	unsigned long totalpages;
 	struct task_struct *chosen;
 	long chosen_points;
+	bool approximate;
+	/*
+	 * Number of precise badness points sums performed by this task
+	 * selection.
+	 */
+	int nr_precise;
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
@@ -97,7 +103,10 @@ static inline vm_fault_t check_stable_address_space(struct mm_struct *mm)
 }
 
 long oom_badness(struct task_struct *p,
-		unsigned long totalpages);
+		unsigned long totalpages,
+		bool approximate,
+		unsigned long *accuracy_under,
+		unsigned long *accuracy_over);
 
 extern bool out_of_memory(struct oom_control *oc);
 
diff --git a/kernel/fork.c b/kernel/fork.c
index 949ac019a7b1..8b56d81af734 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -632,7 +632,7 @@ static void check_mm(struct mm_struct *mm)
 
 	for (i = 0; i < NR_MM_COUNTERS; i++) {
 		if (unlikely(percpu_counter_tree_precise_compare_value(&mm->rss_stat[i], 0) != 0))
-			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%d Comm:%s Pid:%d\n",
+			pr_alert("BUG: Bad rss-counter state mm:%p type:%s val:%ld Comm:%s Pid:%d\n",
 				 mm, resident_page_types[i],
 				 percpu_counter_tree_precise_sum(&mm->rss_stat[i]),
 				 current->comm,
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5eb11fbba704..740891be3267 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -53,6 +53,14 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/oom.h>
 
+/*
+ * Maximum number of badness sums allowed before using an approximated
+ * comparison. This ensures bounded execution time for scenarios where
+ * many tasks have badness within the accuracy of the maximum badness
+ * approximation.
+ */
+static int max_precise_badness_sums = 16;
+
 static int sysctl_panic_on_oom;
 static int sysctl_oom_kill_allocating_task;
 static int sysctl_oom_dump_tasks = 1;
@@ -194,12 +202,16 @@ static bool should_dump_unreclaim_slab(void)
  * oom_badness - heuristic function to determine which candidate task to kill
  * @p: task struct of which task we should calculate
  * @totalpages: total present RAM allowed for page allocation
+ * @approximate: whether the value can be approximated
+ * @accuracy_under: accuracy of the badness value approximation (under value)
+ * @accuracy_over: accuracy of the badness value approximation (over value)
  *
  * The heuristic for determining which task to kill is made to be as simple and
  * predictable as possible.  The goal is to return the highest value for the
  * task consuming the most memory to avoid subsequent oom failures.
  */
-long oom_badness(struct task_struct *p, unsigned long totalpages)
+long oom_badness(struct task_struct *p, unsigned long totalpages, bool approximate,
+		 unsigned long *accuracy_under, unsigned long *accuracy_over)
 {
 	long points;
 	long adj;
@@ -228,7 +240,8 @@ long oom_badness(struct task_struct *p, unsigned long totalpages)
 	 * The baseline for the badness score is the proportion of RAM that each
 	 * task's rss, pagetable and swap space use.
 	 */
-	points = get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS) +
+	points = __get_mm_rss(p->mm, approximate, accuracy_under, accuracy_over) +
+		__get_mm_counter(p->mm, MM_SWAPENTS, approximate, accuracy_under, accuracy_over) +
 		mm_pgtables_bytes(p->mm) / PAGE_SIZE;
 	task_unlock(p);
 
@@ -309,7 +322,8 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
-	long points;
+	unsigned long accuracy_under = 0, accuracy_over = 0;
+	long points, points_min, points_max;
 
 	if (oom_unkillable_task(task))
 		goto next;
@@ -339,16 +353,43 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 		goto select;
 	}
 
-	points = oom_badness(task, oc->totalpages);
-	if (points == LONG_MIN || points < oc->chosen_points)
-		goto next;
+	points = oom_badness(task, oc->totalpages, true, &accuracy_under, &accuracy_over);
+	if (points != LONG_MIN) {
+		percpu_counter_tree_approximate_min_max_range(points,
+				accuracy_under, accuracy_over,
+				&points_min, &points_max);
+	}
+	if (oc->approximate) {
+		/*
+		 * Keep the process which has the highest minimum
+		 * possible points value based on approximation.
+		 */
+		if (points == LONG_MIN || points_min < oc->chosen_points)
+			goto next;
+	} else {
+		/*
+		 * Eliminate processes which are certainly below the
+		 * chosen points minimum possible value with an
+		 * approximation.
+		 */
+		if (points == LONG_MIN || (long)(points_max - oc->chosen_points) < 0)
+			goto next;
+
+		if (oc->nr_precise < max_precise_badness_sums) {
+			oc->nr_precise++;
+			/* Precise evaluation. */
+			points_min = points_max = points = oom_badness(task, oc->totalpages, false, NULL, NULL);
+			if (points == LONG_MIN || (long)(points - oc->chosen_points) < 0)
+				goto next;
+		}
+	}
 
 select:
 	if (oc->chosen)
 		put_task_struct(oc->chosen);
 	get_task_struct(task);
 	oc->chosen = task;
-	oc->chosen_points = points;
+	oc->chosen_points = points_min;
 next:
 	return 0;
 abort:
@@ -358,14 +399,8 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 	return 1;
 }
 
-/*
- * Simple selection loop. We choose the process with the highest number of
- * 'points'. In case scan was aborted, oc->chosen is set to -1.
- */
-static void select_bad_process(struct oom_control *oc)
+static void select_bad_process_iter(struct oom_control *oc)
 {
-	oc->chosen_points = LONG_MIN;
-
 	if (is_memcg_oom(oc))
 		mem_cgroup_scan_tasks(oc->memcg, oom_evaluate_task, oc);
 	else {
@@ -379,6 +414,25 @@ static void select_bad_process(struct oom_control *oc)
 	}
 }
 
+/*
+ * Simple selection loop. We choose the process with the highest number of
+ * 'points'. In case scan was aborted, oc->chosen is set to -1.
+ */
+static void select_bad_process(struct oom_control *oc)
+{
+	oc->chosen_points = LONG_MIN;
+	oc->nr_precise = 0;
+
+	/* Approximate scan. */
+	oc->approximate = true;
+	select_bad_process_iter(oc);
+	if (oc->chosen == (void *)-1UL)
+		return;
+	/* Precise scan. */
+	oc->approximate = false;
+	select_bad_process_iter(oc);
+}
+
 static int dump_task(struct task_struct *p, void *arg)
 {
 	struct oom_control *oc = arg;
-- 
2.39.5


