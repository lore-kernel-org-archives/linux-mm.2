Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 896A0D5B15F
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 18:56:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFE166B0006; Sat, 13 Dec 2025 13:56:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC5AE6B000C; Sat, 13 Dec 2025 13:56:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B66166B000E; Sat, 13 Dec 2025 13:56:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8CA776B0008
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 13:56:18 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4E317135EAE
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 18:56:18 +0000 (UTC)
X-FDA: 84215353236.29.9083A12
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf17.hostedemail.com (Postfix) with ESMTP id A69F540008
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 18:56:16 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=pfM5tXmx;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765652176; a=rsa-sha256;
	cv=none;
	b=ifH7ywMXt4Vpwn8SKFDC0bI8LMoNVHMdKXLwZ7zJuRcsEiuci9bSqOXM6MvmMeYOmZ1IFH
	EYxT12CkAV4A2pEwPbB4mVF1mViNkf1fXJxTShmQ6wi+sjrPDhF8LYYtHlWER+Q9hl3oH3
	2LRHGvOQyKzCy+PJb0EbdA/ko88T35U=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=pfM5tXmx;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf17.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765652176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SvNKZ9aFwfw+fFYNP08/KsjB3S08HXQk+/VOcOlRasA=;
	b=DwtpnbgclmxPF2Ke5swzd5EBa72oBKHhnadaMr8nLYr5F+3bdcdHT6R6moaSB/wZg8R4p3
	DQGI/6EHkxTojilGqHS0Q5sceVBN/lRUkvtukESNH4XTGF3Vh5sMWXZphWkGtvJIzn6f77
	AE7is9cgqN36dPlQjffUGkWNsiCpI/U=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1765652176;
	bh=SvNKZ9aFwfw+fFYNP08/KsjB3S08HXQk+/VOcOlRasA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfM5tXmxhTIBKdsqblwHY06UFuxpxqvjYcn3qLIVv8pcJzxc/oLE4OC5fq9CiMUxm
	 Mkfae6mICbnp+md+7Dcpe5o2mFcvxcBG/DA1dpTAPU45Iy12aoc15veaGbyU8IEDJc
	 d8akVDytsD951J1MKy+Y+iV01BOApMk2RZ91S4AKnaW6U0xirMDTt6F0qxOqD+UkSb
	 YNdePeQgOEAIm6T7VZY7RsU/B5a9f+dB7muzzcmD1WqVckW5Dyh/zlNtc3r2KNn1F0
	 0RfYbponls3kANgLt2ZB83MoLXpPtCczfFByex0unCs+AtIgKAaqVUL6rHxhFog5bH
	 +GV5Ol+FVerHw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dTFsW5Q6SzYmx;
	Sat, 13 Dec 2025 13:56:15 -0500 (EST)
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
Subject: [PATCH v10 3/3] mm: Implement precise OOM killer task selection
Date: Sat, 13 Dec 2025 13:56:08 -0500
Message-Id: <20251213185608.3418096-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251213185608.3418096-1-mathieu.desnoyers@efficios.com>
References: <20251213185608.3418096-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A69F540008
X-Rspamd-Server: rspam03
X-Stat-Signature: bt5eemyehz88fnsnmzzxgjjxa6bfba98
X-Rspam-User: 
X-HE-Tag: 1765652176-205284
X-HE-Meta: U2FsdGVkX1/e9N+qqUnAXgE3E5j3i5L4BaGESadKyQVeZYzkbj1+Njz100xtAKL5C8Rjs+1HzBTHAc9kNo0gmxq9sCKnQPYZa1xKXc7jyGPnoUhmsBZJ/jIZVKSz8p/wv4zqVTWY/lMMUJjfjk3CIhScGIavoCcpvgkRLxIEQzkI9t/wn29TtlOHuBMSZCiF3t412EgjhqWQZzwmESHYlbvBARZQqq8kZ3mpZRaDvpKTqH/fbuXLxoP1rZeyzjV2t2SO6x6KKGWDbNXkRlWy6ODHmEKRHtw4+tl1TuBqviDDz96RCMyXZxoXpVRF1e9hfYrKROHSDZJimOEBTwi/mae9EQdZJvERasG+zi+e6FI5sawgJP3fJcq9+JIFo+6W6enVlpIGwm6zwQKrjht+sFrHDxUOLWnfCAZtCXP1CXxtouY1vYlNQQk4fCSIlQu5HSvHMPwWeEdwcEa4+2qhFzJN2Ap/c3kp323iHYw5AIQwmfKQfvjcu9I+cA08/dWXEXdbPqcLSIuuKFcBZDoqbpf4v2lmwfA8kCUJf6v9CjGBwRwnlsnk71ZOoV8grehW80e/a6BDYEZEAFYN8Qw4EfY/6t6+yo7JPlvC2gqs+5CQ5zqczbVhPs9OFt2g2UX3n1GSDc1iIaANGkD2F6Zf9nEf1vm360lFdNrX+2i05NB7jlVdqJqapaJh/bj33mXDggFhXCKk0pT8V+bB8sLl29uQpcRzcuLJq6YlEDgRRL33UhP4ssXBjP11P17xGHyRYEP9RbdjSkQyZQgsUaTNrhL9uwWd/N6QVzisG8OFyubSiCiUCqabmRPMrq8Yq6XsslFHz74Pf+tgdFnch9b5YIK8sUKI/Q5RsYplamQ6H5TFGimgXLfed9tlJbCAXKUZCv1dd/CItb+5NeLf47ZZf0M9bEqMUc7Z8D5hrfsHWQDaQiKRVCqB8UxJCDTe+4EnN5uOhZOnN9CXlFwoCn3
 DFHK6Uu3
 ekGchXY+4st9yF3aF8aEss+V+4xQPv2Va8O5qCEciko0MCmGUYk0J6FBQMpW/vtjKK606gfAZXm9R+omtpsQ416c1OBA2OOd3qUFz8FUWkeuKUdjQ6ZeLPghzY/xHI8/3UnkU66ex4KlNKjX8CKedX++hlTVm6wFfbgc6+O/CfMYT8UwjtXKm0lIawmaIDJnW0ndW8JLofc5/3t2WJR2hnrWi99kfkhTG07MS95zAk3nQ5R9vdfbnaXzFKmBTE1u3eizTcxPakhP/Om077NtaeP6yP+Jt7GKvJpcU5W76dcsXkmilrDUwfP35TCfWY2nPGYYTm51Jmx8+0kZXGlvNqqQFdVu3yQWMe97wYWVQwaeNvxaxREiVhZUmvWM45/W7n4ehuxLHZVa0yADNupMurCfbJDQ6iTc2EekBbOFU6OjvsB8sFskbojfQcXeM9mOjJJwekuAqAsd3cL6S1OasQ2qvnToKM+CCX7Oaiu+cJx8qgiC+lGfT1ZogOsDditpMMNrMB8Kfjb6SeGkDUyK+vc9j3iSl/QgFCaXILTf5rSRWb0lsP/9ayMaZJhijgtBOJH4wGIbrNBhoAgAWbEesDob14NzHjKU+yB5y3zY91g6j2Q3A7Ik5MakbjqYG8KO41Iyu9zAuAkVFLmIrasqpuYO4gywkTaouM8fSw+GpnTQTxYhGM39YpYCXCL1FPVa9X2uEOI7fq35PEnHMqmM0VChlXgH71XxxeHpjPBbPTzWMbC8xgEFF5MOoVLZO1nMt1fjYFLS7hUC1h/ssE1E5peaIi4F7Mp8z7Q3tPdktHLVY3CdQ92w29akEzkcTs6Z/zs/He0mShlPXmu/fX9kV0ssyhBmRvndRmG8kuPBPyH7XkaHoGtpujrUmEQwshrP4RQJiosNZtREFlXE+qKfFS1Q7euKHyJu6URqW6QGARot/q/tB6Q2IMNnVk0TKvBntx/Sb6rcbLhaQmvb/2RliDmcVcEau
 PnIAN/pt
 V5rCYksNZWJWu4Ssi8OxtWvLOsSPnY5WXeUtZ+RMqbc=
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
 fs/proc/base.c      |  2 +-
 include/linux/mm.h  | 34 +++++++++++++++++----
 include/linux/oom.h | 12 +++++++-
 mm/oom_kill.c       | 72 +++++++++++++++++++++++++++++++++++++--------
 4 files changed, 101 insertions(+), 19 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index 6299878e3d97..fa48411835ba 100644
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
index cd81fa8924eb..84a67036d010 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2702,14 +2702,32 @@ static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct m
 /*
  * per-process(per-mm_struct) statistics.
  */
+static inline unsigned long __get_mm_counter(struct mm_struct *mm, int member, bool approximate,
+					     unsigned int *accuracy_under, unsigned int *accuracy_over)
+{
+	if (approximate) {
+		if (accuracy_under && accuracy_over) {
+			unsigned int under, over;
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
+	return get_mm_counter(mm, member);
 }
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
@@ -2750,11 +2768,17 @@ static inline int mm_counter(struct folio *folio)
 	return mm_counter_file(folio);
 }
 
+static inline unsigned long __get_mm_rss(struct mm_struct *mm, bool approximate,
+					 unsigned int *accuracy_under, unsigned int *accuracy_over)
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
index 7b02bc1d0a7e..ef3919e4c7f2 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -48,6 +48,13 @@ struct oom_control {
 	unsigned long totalpages;
 	struct task_struct *chosen;
 	long chosen_points;
+	bool approximate;
+	/*
+	 * Number of precise badness points sums performed by this task
+	 * selection.
+	 */
+	int nr_precise;
+	unsigned long accuracy_under;
 
 	/* Used to print the constraint info. */
 	enum oom_constraint constraint;
@@ -97,7 +104,10 @@ static inline vm_fault_t check_stable_address_space(struct mm_struct *mm)
 }
 
 long oom_badness(struct task_struct *p,
-		unsigned long totalpages);
+		unsigned long totalpages,
+		bool approximate,
+		unsigned int *accuracy_under,
+		unsigned int *accuracy_over);
 
 extern bool out_of_memory(struct oom_control *oc);
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index c145b0feecc1..e3f6ca500701 100644
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
+		 unsigned int *accuracy_under, unsigned int *accuracy_over)
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
 
@@ -309,6 +322,7 @@ static enum oom_constraint constrained_alloc(struct oom_control *oc)
 static int oom_evaluate_task(struct task_struct *task, void *arg)
 {
 	struct oom_control *oc = arg;
+	unsigned int accuracy_under = 0, accuracy_over = 0;
 	long points;
 
 	if (oom_unkillable_task(task))
@@ -339,9 +353,28 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 		goto select;
 	}
 
-	points = oom_badness(task, oc->totalpages);
-	if (points == LONG_MIN || points < oc->chosen_points)
-		goto next;
+	points = oom_badness(task, oc->totalpages, true, &accuracy_under, &accuracy_over);
+	if (oc->approximate) {
+		if (points == LONG_MIN || points < oc->chosen_points)
+			goto next;
+	} else {
+		/*
+		 * Eliminate processes which are below the chosen
+		 * points accuracy range with an approximation.
+		 */
+		if (points == LONG_MIN || (long)(points + accuracy_over + oc->accuracy_under - oc->chosen_points) < 0)
+			goto next;
+
+		if (oc->nr_precise < max_precise_badness_sums) {
+			accuracy_under = 0;
+			accuracy_over = 0;
+			oc->nr_precise++;
+			/* Precise evaluation. */
+			points = oom_badness(task, oc->totalpages, false, NULL, NULL);
+			if (points == LONG_MIN || (long)(points + oc->accuracy_under - oc->chosen_points) < 0)
+				goto next;
+		}
+	}
 
 select:
 	if (oc->chosen)
@@ -349,6 +382,7 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 	get_task_struct(task);
 	oc->chosen = task;
 	oc->chosen_points = points;
+	oc->accuracy_under = accuracy_under;
 next:
 	return 0;
 abort:
@@ -358,14 +392,8 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
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
@@ -379,6 +407,26 @@ static void select_bad_process(struct oom_control *oc)
 	}
 }
 
+/*
+ * Simple selection loop. We choose the process with the highest number of
+ * 'points'. In case scan was aborted, oc->chosen is set to -1.
+ */
+static void select_bad_process(struct oom_control *oc)
+{
+	oc->chosen_points = LONG_MIN;
+	oc->accuracy_under = 0;
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


