Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6555EE776EA
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:46:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 407336B008C; Wed, 24 Dec 2025 12:46:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 342BA6B0092; Wed, 24 Dec 2025 12:46:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 23BF26B0093; Wed, 24 Dec 2025 12:46:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A8B16B008C
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:46:48 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C2F62138B62
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:46:47 +0000 (UTC)
X-FDA: 84255094854.08.5E6BAEE
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3018D140009
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:46:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=xL2s0QK6;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766598406; a=rsa-sha256;
	cv=none;
	b=KCCH6omY7bsDRktyevjbR/BEFkd2Aoni7Jp/QIQyzdi1rIIZ6PQOsn0XAwoCcUU5TjIAek
	0GoSB2MltoQfxu28eFr0VYKnbXj3nOQJtgKUkGhHo/iYv+7x74q6u3PaVTWiMZakLtUt32
	NkGMVVg7JBLloBeQkRe83DZrEzFxe64=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=xL2s0QK6;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf23.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766598406;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pYLpM2XRTM5l3VJzOyjtgXcqyrifc7E1JbB0hg3uv44=;
	b=OTYnsCD26LpGiICwIiL456W2kuEN+SpbVMhMOX/yhY6Ouq8wkFmMq1p3/Y0QjAAleoaYcY
	VtDlaQVldLNWFVDkrJfeIFgP8xDXFuyeuKW2xFivAIN2svW5W6Hr9TWJYCL6zdYVRkm7sB
	Bxng5YIwI6GADy7H2MCu4XLjWzpxcPw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766598405;
	bh=pYLpM2XRTM5l3VJzOyjtgXcqyrifc7E1JbB0hg3uv44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xL2s0QK61qjrQj8iOI4hIh9iQ8WPPZGtl/Lz5ZA/l8tuXr7my65eJYYv9dr/KEOon
	 Zxsbnt+hRKfbpUtqHG38OWIVjPbK0UcSTxo9ETpsvnrf97K9Kmd39miLnLEsQjKZCm
	 haO6YJ7Xs8c44qBOxk5Y0EiXGQj27hQVfT97C6oA3Oy8UBvEB8+1QE8LpEYtnz35nY
	 zi3a0bi+K0GH01obRBTLHdUrTPTUO9xgRiAWQKwbpn3eppRmYy5crba6PXMTx1X5GK
	 Sm2zmwyCp2MbeFqYxz2K3Blr0TYY5/ZMXiKH1XiNo9ZeN2LYc1TwfGvsxijjDjHGNP
	 K0PpoNUQIoO2A==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dbzpF25HmzfFG;
	Wed, 24 Dec 2025 12:46:45 -0500 (EST)
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
Subject: [PATCH v11 3/3] mm: Implement precise OOM killer task selection
Date: Wed, 24 Dec 2025 12:46:38 -0500
Message-Id: <20251224174638.650551-4-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20251224174638.650551-1-mathieu.desnoyers@efficios.com>
References: <20251224174638.650551-1-mathieu.desnoyers@efficios.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3018D140009
X-Rspamd-Server: rspam03
X-Stat-Signature: 6m9c5typsq9p7xn5wgfiwwimsinh9y5y
X-Rspam-User: 
X-HE-Tag: 1766598406-941415
X-HE-Meta: U2FsdGVkX1+A8bPOtOWTC8ybWaABaWi1ROHSRqH/2fqgrIoxywG3Dde7P1srFeuTMypwJb2n7xDHxFS4tFHxBW9GWu2rQL17RLOq+AxFDQK7Q7QoTJYsVo+YLAO578FCgL9Smk6b8QPXoek8QMKhwdZ8iB+Q7H2E8pzx77kpGWASBDHMcHHlBmyDmG8CpxLjXToHckIu9Toe+EAmLajdIjFLP3N46V0XooZQpq28JQ3CQ5DG28bw0QCr0d9xAE7mI6g7HoHNdXSa1yLQEhD0eCYXVSfq8OF5j13mtPIs72kaFLUYlJyKDKWlJJ/VP8rouNYn6joxZBPJ0FtA4Nir0hTKCX0uxseu9qR0+s4O9zn9GWDK3BeDFSmLhQDinVwP/drBc9hdxKUzn4dMKd+2z1FvbkoVJsXlU1fPx+Kp9y4Wi7dTjJSXntpPuhDcP61s3a7toE+/enC16HslEMxdM8YBl+9+dHEjlBvpfm1KrXckZmSy++591jOJX1/K/WZgd68eIE1e4LUb2qfHpK12V1Mbdc+JEojEZa3PZCjEknlQlpZopOt1Jsljo5aWzmd4zpIHJcYKFgYOWo1pEhuTATIxX7IBV5imzVsTQGzzxlyCI/Jgv4qBoz53pz3IKXEPEt4UkHk50RYVjyDfEsjexTmxX7whhqLl+QbWzeoWECk6Trs8UOuApB7/Hotbn+8ep+hWLCxAy7I7lVwLFZTMrcx7wgtN6N0dzt/EUNwKBqoY11g174gdEvAqrVHL5ZxdL95WIsa/MV3G46eNzDy8cJ3L+NZD+DuPLma9z9hAupZ6pJsP9a0W2RT9kcvgJVnCVtZ49XHTZcFYLAk+tVWM3JUjqMcS1NHK8BTNRyXzcU1zlmI3PlnWWcZkGe2iyc5KTUv5OK9xyRfDCvWFNqrj1EU2zb6R0Tny1qgsoTLCLoMjH96U6vXtJjsGbFJt5Xou0skAh98jwaXP92DhfQz
 xWjnfkrQ
 zFCMjhgY0+WMZmGTVLOHeksyXoBkRQETkhZd4+6qWmPMqM5fzzwY6LdoYrOhuFSd1rmAINz2nPTSlCPF520Xovg8/flLUYDCHv+80REH+jGpI7SQTFzzJPtZg6/DeF2fo9PIuhvsmm0OjERR5xaU7HxAkU5cdYJkrsw1JhkFA5XcDbJP1djuPDzBOlYiMLE/Xso8kJTjhsPZZzya8Ir6ZlObunKqMJnQ/Ck2du4mzftC9bIg2wjNUBn3s+HUXfJO1j/o6VNgUhUyrFedJpFjqX4P9pxGxKtCau9iSjl0FJTQjvtr0jhbzI3207pj1nphOxUtuYJWN+Xl1Ftzu8lsfXbRW1BRsRyRtUh/aBBpXdsxp0p01W3K0suULIRhA/1v7C+TzYLqPggi71JWTTXYJeo6CBg2bcJ4diqs6sOIuu3YPxLVEZgFFykPcx46Ke1IZ5QMqHmekKTWrP9+orQ3LZcG8MoHGGjy/8bwwTqS6/FqpWSA7mhV7SznWDRMYXHKlgSy+sggmC2euFcY7ssqi2EgUMJmLlC7fQND4AX8oAO37jLQODM4oqDn0PA3whF01U0IOPmklx0z8/CL7C6lv8AoeT06bSgP51cdUiZmsOx0tfQMnmUef/JxCPyBc5YKAJbtkccQ1o9yK2BiWNK0/OWbTZF2im6C/GVxLg6BS47fA9ZwqVKQhDY0Z30rl+hYeBH3eXsu4wE1GQsa2kx4MgMVOHJWMCFw8mjkBuqIFG4AewC5C3x1Au6n5uKJYLgEkVsnDeIfiN50m5KcP103Ete3hEYvnvjECYHNedFrgdzwfD99eRe0VWIUN8nwsZy6yTA+PlChMvJqYWGyNqvfmOVMjznxRlBy0NFUIqVJ8h3eEWh5JWDa0FzVa3aTtnduJ7sB5VIc4CpqyrhdFKdu1Ksoj9E1MBZX+k8l+R553sm69fH4SDJzI2uyDfjKyXFNppSgxD4zm0KGfZjOFiomZr0XB0BLi
 wJgnsECG
 dy9vXuU5kqk0csf769OPpYYlZVip81y+UCywrKuiUROLqClKv7CE9AiSEw+GcxGtVhTwpFTqZg2uuPs2MmXyfA==
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
index 79ac9895cb95..c8c0e054fb53 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2864,14 +2864,32 @@ static inline struct percpu_counter_tree_level_item *get_rss_stat_items(struct m
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
@@ -2912,11 +2930,17 @@ static inline int mm_counter(struct folio *folio)
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
index 5eb11fbba704..91ecf2b90fe0 100644
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


