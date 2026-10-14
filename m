Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0ACCCC6B2A
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 09:45:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03896B00C2; Wed, 14 Oct 2026 05:45:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB3AA6B00C3; Wed, 14 Oct 2026 05:45:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BF0C76B00C4; Wed, 14 Oct 2026 05:45:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9E31D6B00C2
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 05:45:06 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 344B41A02F0
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:45:06 +0000 (UTC)
X-FDA: 85320748212.25.D630AEF
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf08.hostedemail.com (Postfix) with ESMTP id 01583160009
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 09:45:03 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NZK+II6k;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791971104;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YgtaUAMzxFpM6Hd/lNCKgresHIYixggmJPuHuVJA3OQ=;
	b=vVDnnEqBKLPrlMmgMSWBzFaef0EpHuLGjh16QpsLm0yYIFuTE53ufH4k7OkxdqWpcZAnW/
	clYZEikfxAa8W8Osxt6c+Dti1szxIqdmSFE970v1NM+HZCuFamiwRRaO+9ffXUeY9JKnG1
	SQqyqz9XvoQ/7YNYHCrLhQ96kqwKgfU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791971104;
	b=IZh94nkjMJkw6/+89iGl51esGDmYejZ4zl+yRLvoApXu9P4IkaYmijbp8XNIypAfDJm1un
	euQzMc7jFU5ufcnp6KjsDoRxFPYhpVj7u+dQrY4SWaaDKZjnY3BqvDfdL1ia4bRlNB7kSA
	ODIMaEdZ12nWBasUmBt5dYRkpGVWCUY=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=NZK+II6k;
	spf=pass (imf08.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1791971097; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=YgtaUAMzxFpM6Hd/lNCKgresHIYixggmJPuHuVJA3OQ=;
 b=NZK+II6kDDzdH4npJZaHpnJ7DHn0xxEhP6k9OCN/sLqq9i9Mx9zyg6YECvSTIzPIJgiYZY
 s8ug0d9GiykabhQw/a2EI1mml4X/OuwURVRAre55y0sG0wnIZBY+pNZmAd4AYFMBOO/fWX
 Md60JxSifmpN1n8dRfLq3uN4wTRAnHfkjtWak+KCu/6CwIBzSrGaqFXazxGvvuYyEeymif
 7vLlrzKEv7vCvDOHdXMJJfNMW1EcwrGEEhRMDPKaKmfbAdPwA7gk8s1tLkAaDERKah2hA1
 krmloMsqiSUiHo+gMsolQzmHOFvN54uhMGBpd3vCzZldE5FO3nsWhjAq+T/WOw==
Content-Type: text/plain; charset=UTF-8
To: <akpm@linux-foundation.org>, <david@kernel.org>, <ljs@kernel.org>, 
	<gourry@gourry.net>, <joshua.hahnjy@gmail.com>, <ziy@nvidia.com>, 
	<mingo@redhat.com>, <peterz@infradead.org>, <mgorman@suse.de>, 
	<riel@redhat.com>, <juri.lelli@redhat.com>, <vincent.guittot@linaro.org>, 
	<dietmar.eggemann@arm.com>, <rostedt@goodmis.org>, <bsegall@google.com>, 
	<vschneid@redhat.com>, <kprateek.nayak@amd.com>
Subject: [PATCH 1/6] sched/numa: clear fault locality state on execve
References: <20261014094347.99157-1-lizhe.67@bytedance.com>
In-Reply-To: <20261014094347.99157-1-lizhe.67@bytedance.com>
X-Lms-Return-Path: <lba+26acf4f17+357c3d+kvack.org+lizhe.67@bytedance.com>
From: "Li Zhe" <lizhe.67@bytedance.com>
Message-Id: <20261014094347.99157-2-lizhe.67@bytedance.com>
Mime-Version: 1.0
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-mm@kvack.org>, "Li Zhe" <lizhe.67@bytedance.com>
Date: Wed, 14 Oct 2026 17:43:42 +0800
Content-Transfer-Encoding: 7bit
X-Mailer: git-send-email 2.45.2
X-Rspamd-Queue-Id: 01583160009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: m8cmdu7yxxdcx655dkfq3z7pf3wzred9
X-HE-Tag: 1791971103-46382
X-HE-Meta: U2FsdGVkX18Gw2VCbuJrpPOx06RmFh7vv3rMEhS7/nHEvt8CJkbsgBm+V9yRNAsxeECqgB2m4rAmRedjKmiw3FjtPs751YjE3aKPVi0UVwDp+fk+oqxngeQ4qYhNvPwEjop/PxoSAQ3+TdIG2oLvYH0tHe1tM6j2HklShV8aSSnOt1w/z+rfmqERnP731DRRuhRvFgRHjHWn4Y8GAGtXHBh0l7tfjqL7er7/mJDjKS4tx+d//iYvTojxxbTAPiFqFVm16V2y+mxDk6oLp4G+SNc+CWJ+LIW2NT6AdizljAtEyhfxknFbCMU/msqF7dsenmtd6dAPtC+ibTP7SG4P5jxm/86LODAumHDc0F7XUA3a0+WZZOpUKZ5Rsft/9ABg1lVxHfUnY0Vme9+gPZUZv4uTUpWA/g6QOGrl5cJx93iMMsU3tkDKHHbUBHwgrh2OnaH3ZYtLy1dZgMPvaw/JzM1G+kOqFkax4+APvpgI5XQWWZzEQy6gmqZNK4ktIVzqG/jiCRCVqUAv86pMfIu3FrjuwynDUqUia0mFDaSKOnt7zTh3du0TQPQk5p3DR2YhcfOdoIAz/0Oeg+Bj37YEs+XJO/59ZQ1rSdXcIRC8oUWgyYWQJnzeTRwHJJWyeXeiiOUnbpYVjCt0wn9L7avznj4xu1hGKp/P6Xz/4HDNq0MapUlJoawodt+nA9qEmBVhT51w7Q1POMB78HFzOINwTf23x/rPsJRCLA7WMsBAT5BB3IwHd2H7pWmLgHMFgPgzWjVUw+Ss6GBgpKrf4V87qrqW6UtqDdqv4zvB2L9rFh6ezfMbXp2PetE/ymKS3u7FQ1vVr/fpFaVpsbjT9WAu8QLC1F55j0n/I5rOLbr0R5sNAFR0Pxw/z7k7vUQl2+lhmhPxwhpA86FI8YSHtd2QqGcuCZDO9Q1kVGSFaYe0KGEQPHHYVN8ruEoK6U+6yVSi9M/EBNkD0ezXB+ZA1Lb
 8XeD2Srs
 WiYnHE6c1D3gFE8XCKWYyBbM9uUX6QbWQ8GjaFmP849pfu+MxqbvYzFSHkljXMnaCq7jnF4YT1N2NMKzSGusv6XqyTCBKW0WCtNElN6Gj7igLCLulHfqW07xB6jlBtTRa2XrNzcuaTH5mpZAJxqD/PkH3yHVO1+St5iGQjRVsWSYk0OzszuhJ2R/rIPh4VrwxOvIc+zFu5mmDfDtEG+vR+Ac13q+EhOelpsOQ3TZLqw43f3t5oLKWaiSmV3PgWFBmqHB7tupxHHfRKB7famybODfiq+iXsmqqnIJtXqp16aQC0yTF5YjkE41ja3MkYg4VH1xRQMQTqrybMN1LRDhx3Kh2DkceEnM7i4NCbH1JnAZ1H6T7MZRUIJ7t1A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

task_numa_free(p, false) is used by execve() to reset NUMA balancing
state without freeing p->numa_faults, because concurrent readers may
still observe the task.

The non-final path clears p->total_numa_faults and the averaged half of
the retained p->numa_faults array, but leaves the current-window buffer
half and p->numa_faults_locality unchanged. Those are also NUMA fault
feedback consumed by task_numa_placement() and update_task_scan_period(),
so a newly executed image can inherit stale fault feedback from the old
image.

Clear the whole retained p->numa_faults array and p->numa_faults_locality
together in the non-final reset path.

Fixes: 04bb2f947505 ("sched/numa: Adjust scan rate in task_numa_placement")
Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
---
 kernel/sched/fair.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 57360f5cdde4..1053437933ee 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4177,8 +4177,9 @@ void task_numa_free(struct task_struct *p, bool final)
 		kfree(numa_faults);
 	} else {
 		p->total_numa_faults = 0;
-		for (i = 0; i < NR_NUMA_HINT_FAULT_STATS * nr_node_ids; i++)
-			numa_faults[i] = 0;
+		memset(p->numa_faults_locality, 0, sizeof(p->numa_faults_locality));
+		memset(numa_faults, 0, sizeof(*numa_faults) *
+		       NR_NUMA_HINT_FAULT_BUCKETS * nr_node_ids);
 	}
 }
 
-- 
2.20.1

