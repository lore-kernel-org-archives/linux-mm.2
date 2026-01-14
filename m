Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9885ED37E39
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 14:59:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF17C6B0093; Wed, 14 Jan 2026 09:59:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 940176B0092; Wed, 14 Jan 2026 09:59:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE546B0095; Wed, 14 Jan 2026 09:59:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 501706B0092
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 09:59:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0711613A771
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:59:23 +0000 (UTC)
X-FDA: 84330877806.14.8F49578
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf02.hostedemail.com (Postfix) with ESMTP id 74AA080007
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 14:59:21 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=knAUTx8Y;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf02.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768402761; a=rsa-sha256;
	cv=none;
	b=RTCXR/UBzRfHqVTxFeDjKFgx71ZlxeOc8JVobfEfRKzMVA6l0Bxo4TP+GXsFFqTa6MUGwv
	KvQcvXF2gLMD65gqkO6Z1ivKKChEUpHBxFeBbXeqzQnRnb9+PFWiZ4rFZFTgQq0/US96Ur
	FidsbIIgeUEv19no9hC+zonVSSLaa3I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=knAUTx8Y;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf02.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768402761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bqQPyC3r+9Zm40oqAtT5UvkVoAsiZBbUzqbWxZ8HGYU=;
	b=Dj92qcKc4/RppBC7ari++iu5uUP8iIuZmOlDKd0n3y9rDFoh7KvOPqgGjV4/1ROm4UM4d6
	KjsmkgEH4vyZOgqOvfTtbdFgaLcLnv63p57ffPzEppU/McG8bk5ri1p96DqkTiZaeZBEnH
	NVFa3TSOc6bevi+j13VWPHBLVaIZ97g=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1768402760;
	bh=bqQPyC3r+9Zm40oqAtT5UvkVoAsiZBbUzqbWxZ8HGYU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=knAUTx8YjY303Ud+OLdXeXsdNuWrN5tyzU9zEb9BG6br5tHyM+/YzPkm4mxrSfAAf
	 QeJUEv2i8EfOEB0ipHW/+L1sgPejMwV13Uedpjn427hd3Ly/UfYowxOXhljvSu9E1H
	 PDA+7nZycxKr38sQkDHTo9NX4YtfCe4jBdgMk7eL7KYSi5+CFRZysoC2aIi28tnBoW
	 mFxMbtpnQZHyXwro7hx+NITEV6UsMYViWA0InQrnzHNlrApARS4zlnZapFGAmOI5by
	 YsD3BraBs8yvEDn3Z1RbDy/lx9MULtnmzOK92PROfmXDGWzR/FbffzyCrMWcR85OGt
	 wIpOdfUQ4mQgg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4drq5N5J3RzlNP;
	Wed, 14 Jan 2026 09:59:20 -0500 (EST)
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
Subject: [PATCH v16 3/3] mm: Reduce latency of OOM killer task selection with 2-pass algorithm
Date: Wed, 14 Jan 2026 09:59:15 -0500
Message-Id: <20260114145915.49926-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
References: <20260114145915.49926-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 74AA080007
X-Rspamd-Server: rspam06
X-Stat-Signature: juh1efjuwzqosd41i51d7j6zag8g467c
X-Rspam-User: 
X-HE-Tag: 1768402761-487347
X-HE-Meta: U2FsdGVkX19ac3o0cVqmIvCcSVonEMh70/NMdMWhWr5WACl6V43+MX78Hc7Lv6vcIFO7+BeWZ5muJFSsjR3gDZPh8DCA6U469+AIGyfqsReuIzy/G4r+fJKOs0oHt7FO86SzcrBoPE+A5NOix8qFMoAlgQxoh++H+NSx4eo8u2fUe3F5Unsot4+5xTw28V89zruNE6NxNvn5GwG80tDAKCgqhTUCnTZ3K3gLmbvbCfh+w9f5S3BWo4sBMBwIHsCrlNfrM9OpGwzQyoewcTKsStBYimAFZ4xcYkVh4RnziQLm+3zUt34L9Px3eWidaONMX4pmgXzRcydZcw6gYEGBSGU/o3d8dHzwdzaVzO0UBLB8iDiCcfTpDe1W8FzlNfmTlPUbWPgaZ8hSXheou/Cue4Eudc/0buGjIiZFBkm5da8hxn0X/8q1eHYJdCDw5RxBTWjHrvZy/KDfiSWN1uQlYNGOHqalMZnOeus/yW+qt1isw4u7ZwJOY5SBYViGXv9/NgUNDiniROnrbFiLPWFABejN+rJw7I6c3KoslDUdVEMVs72Ls64pnwKCx5L9jIJNCEdWOdLR16/uXm95cP5jPYKs+Jrlk1NSjLfjnaRkoKXTH4TX2x5LxLV2nQDOhBwLawvQM2Pz8dEWFibdk6LLqAahDCivvJn8y/ujWTvAA7zBtP7FXPQALSHBNNWQnbXuIR+dRgxMayVEXjNE04mOOG697U4vDuHwMHWzSlvJvYWOZvVjettdXxOnbYCzoPOnHGPnGyAt1Co+ptzYdFQTh0sI9rNo8Zg3X5bF+NS2jRU/hvEmH5OxyWPi+1kIhal+/eSaF7NjWItPq2TK0/mO3E+aAlwKof11KbT1Nabg4oUxDXFXUfHnOl8fYFWZ4qzeLb899WFAkfhDEcyeExYX6kWHa0IpanueYewjqctTckGl2kgmsy0MMOyBCeZzsRCVNj65RVxu2sxEzjQAmGW
 tm2/hS85
 mw3KJA6vWBgZBqdn116qIoD6JY7G1Z211wRlXzlCarngPIEGCQ8QwX2P/La7kd1WoGEkeuWTtI8EgtDPInda3pQLR0HUgdvOG6GNIwPFLrE9aqQmdOhhM/GIz6fhY7spxBodbnTlI3NnOZU/ODjppFAvSW3NBdBdACWvSQis7LYu8hcLjvLXQTfK6hGKYCeJdV1I8Gb5UZMdi3fdBg3sxMigR5WBj0TwSue5C/OdyM/lTa4lPHE45XpkBeYpGE/gPlqc/bMDMsjBWBVs2g2829d7iqMd5umPPwxU8xspEhs4FLpBSlFxqdPK9gHsOE1qxWDSSgs4rVEDsRjBi+sc6oNIXLX55aprn8QifR4RIrdwEfV9xLHB+LslSnn0jCXusUbZtWklV3Y+6H4RkC0zrw+xHD/lku5dYbQHzzKRkaA5secn/SG+0oxAzL7MmPT+3A/6cWSRaTuEzFiT6fkhB5aLKcSL1AipG1yd9cEaiosLNYkWMRE0hhfErg1oAmTHHWNu80RArt8CFSrQodKxSDF0MWcQm5PCw+cWSagWGM/p5FVysZP4EdoCsWZ9AcU67ofXX8ZbgdRVYkSRDzjhRdcypaSoFMIkaSy5J+26zWRq6R6d6SBrduGNGisuZdcFRaqSeqGXcra+0XAWRJff4cj9DZHCYAQClnQUvvZCEzrKrvD3yuWCP/h6wZXFMA/+iZKu6TbE3auDPEwa3Ugsvdc1FCeHpCOd4g3Hw1+zAoMZ4fgUwV77clqxBjTK95URvQbXnRjVrczPXcrhHndlF4p469IhBkW5Xoof0V4yNqXn+hDH7z/aALHG8nb2qQG4BIdj2rKN7+lS1j0lfbRi6cvmL0DrH7m0YoJfhg8QL65ECWof9NXk8PPw2aiSJF5qXkFAXeiO7C7d1OfFtb0uymjoJ9CHuz3chAb0/yEO4l/GePiej0H6uVH8eQQE47YDgQGgegW07KX7n/DVF/djBMAa+AEQ3
 srX/guHt
 vK8SuYWI6vjYAXEnsHZSonDgbpFavJFhS8SJjY/4YtwSkzcS0CilZK+umDKxhmVJ+MCT5A9yz6E4qCCv8uIa/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the hierarchical tree counter approximation (hpcc) to implement the
OOM killer task selection with a 2-pass algorithm. The first pass
selects the process that has the highest badness points approximation,
and the second pass compares each process using the current max badness
points approximation.

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

Testing the execution time of select_bad_process() with a single
tail -f /dev/zero:

    AMD EPYC 9654 96-Core (2 sockets)
    Within a KVM, configured with 256 logical cpus.

                                      | precise sum |   hpcc   |
    ----------------------------------|-------------|----------|
    nr_processes=40                   |    0.5 ms   |   0.3 ms |
    nr_processes=10000                |   80.0 ms   |   7.9 ms |

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
Changes since v14:
- This change becomes an OOM killer latency reduction (performance
  improvement).

Changes since v12:
- The oom_task_origin case needs to set points_min rather than points
  variable now, otherwise points_min is used without being initialized.

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
 include/linux/mm.h  | 34 +++++++++++++-----
 include/linux/oom.h | 11 +++++-
 mm/oom_kill.c       | 84 +++++++++++++++++++++++++++++++++++++--------
 4 files changed, 106 insertions(+), 25 deletions(-)

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
index 10d62e8f35e7..298b8223fbfb 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2855,14 +2855,28 @@ static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct m
 /*
  * per-process(per-mm_struct) statistics.
  */
+static inline unsigned long __get_mm_counter(struct mm_struct *mm, int member, bool approximate,
+					     unsigned long *accuracy_under, unsigned long *accuracy_over)
+{
+	if (approximate) {
+		if (accuracy_under && accuracy_over) {
+			percpu_counter_tree_approximate_accuracy_range(&mm->rss_stat[member],
+								       accuracy_under, accuracy_over);
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
 
 static inline unsigned long get_mm_counter_sum(struct mm_struct *mm, int member)
 {
-	return percpu_counter_tree_precise_sum_positive(&mm->rss_stat[member]);
+	return __get_mm_counter(mm, member, false, NULL, NULL);
 }
 
 void mm_trace_rss_stat(struct mm_struct *mm, int member);
@@ -2903,18 +2917,22 @@ static inline int mm_counter(struct folio *folio)
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
 
 static inline unsigned long get_mm_rss_sum(struct mm_struct *mm)
 {
-	return get_mm_counter_sum(mm, MM_FILEPAGES) +
-		get_mm_counter_sum(mm, MM_ANONPAGES) +
-		get_mm_counter_sum(mm, MM_SHMEMPAGES);
+	return __get_mm_rss(mm, false, NULL, NULL);
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
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 214cb8cb939b..93ae14c278e9 100644
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
-	points = get_mm_rss_sum(p->mm) + get_mm_counter_sum(p->mm, MM_SWAPENTS) +
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
@@ -335,20 +349,47 @@ static int oom_evaluate_task(struct task_struct *task, void *arg)
 	 * killed first if it triggers an oom, then select it.
 	 */
 	if (oom_task_origin(task)) {
-		points = LONG_MAX;
+		points_min = LONG_MAX;
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


