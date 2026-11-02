Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BA6E608361B
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 19:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=x8ZWFWyv
Received: by kanga.kvack.org (Postfix)
	id 0C4356B05B7; Mon,  2 Nov 2026 14:07:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3F776B05B6; Mon,  2 Nov 2026 14:07:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB9BE6B05B9; Mon,  2 Nov 2026 14:07:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 95E596B05B6
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 14:07:36 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0E57340133
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:36 +0000 (UTC)
X-FDA: 85391112912.03.5946922
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id 804BC1A0007
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 19:07:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=x8ZWFWyv;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793646454;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gl+xnaBMZeBPaNesQCW4DnR4Om/hR26Eit0GPVIe2gw=;
	b=KLj6NdC6fY7Kbo8/ZMrQTUvCw/vwiy/APBG0fKfSipCsSABzS/DJKeAhHTcthcG9Fbac8B
	VWvFxFPBKVQqo7vYHaJUGhNbHs/sqWtGM6JES7BBE+pL8qRFjMOt9ZTWQmLRA/7ezebatp
	lCwJeKQZhay0V/G9RJnxyZxyik4uJ3k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=x8ZWFWyv;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793646454;
	b=q/oR+DOedtQqlnIOOXuA90djWB2lq8BI8QoEATotlwRLmBuqlieMDMA0z620MVyoVnRWre
	l5+VmnlWLI/nrswjAL1+et3hPYbjtwP2osSlAPXjM5IY5qhSPX6US7OkqgRtD2PdVYR40B
	XAA+Tt2rb1eQN5lOHoaZ0u+yNNj86UQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793646452;
	bh=gl+xnaBMZeBPaNesQCW4DnR4Om/hR26Eit0GPVIe2gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8ZWFWyvg7IxuyzujBtZkN7PotpTzTokkgemFKIggco3u1iiD8caRy/Xfxm3z4fnD
	 iH1OHsV49U36dFW1xA2uSlGICrJgY9A6D7nkaBo9o2eIJTQj/UfIO4phT+cQUJeL2z
	 YndnDs/YF3O/sca7+kdR62qmhflEiFdo4mSd3fuBcQrQy5o0nyAmIDcp2kclY97jv+
	 XLbtVqoXpHIYF0K1cPyZrCeHWepAYE4Y2wOlOIu/e8UTGSoV5ohmr86nMtFCgyjD0c
	 Xv9e/1cBmi2zRjXXQBqYHElRiAx/4rvUGT1O1OCedNx8HIzSw9xgz/gbS4TXJ7NmaY
	 /ZDLfxJLkRwqw==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jJLn04x95zF1X;
	Mon, 02 Nov 2026 14:07:32 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: David Hildenbrand <david@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Martin Liu <liumartin@google.com>,
	David Rientjes <rientjes@google.com>,
	christian.koenig@amd.com,
	Shakeel Butt <shakeel.butt@linux.dev>,
	SeongJae Park <sj@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Yu Zhao <yuzhao@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Mateusz Guzik <mjguzik@gmail.com>,
	Matthew Wilcox <willy@infradead.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Aboorva Devarajan <aboorvad@linux.ibm.com>,
	David Carlier <devnexen@gmail.com>,
	Josh Law <objecting@objecting.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	Kees Cook <kees@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v23 05/10] mm: report the approximate RSS in the rss_stat tracepoint
Date: Mon,  2 Nov 2026 14:07:03 -0500
Message-Id: <20261102190708.1287100-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
References: <20261102190708.1287100-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 804BC1A0007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: urmk5jakah3t9doybrrbfjsnmgbytban
X-HE-Tag: 1793646454-629267
X-HE-Meta: U2FsdGVkX19ubTkj2KWex90mk40fVV3mnGrJtgp9GcgBHsIdKBGGuuWm/XokwQqjfVxjDeLOO3OkJVnRNZ9XPknbZe379oeF8aP+y06rd3k4ElANeonotyeWBG4YIcRPQaSCUYdq8Rn9pc+C1y7qfKFUSCxbxfkEjvw7CfxqWhPEQL57ODZ0gqoD7fvZF4B9P9oIY7RFGT375g0ChzQBpCval36PTRwo1mgbe+SEU71inNsC5f85h/L2tBfcXv3sPMDHqHqW8oGoYBrzJSRTH4TWNdiQUEbhjs5ciAM1iMRlR6sg/QQhQ2kwxpKSWajjZGg2xhSepNGGH+d1Khz7t7gWT7fc2R2UCETv83G4OsoihDvjGyUdU5CAxloLRI3OCUsnAIixr6s3UDAzWIsqjuYxnr7p4sFKskeGX7zZAf/H0mne7OsjYi/YB0PDUF+3B91Z9neJzIQmimnuAVjkP36eZz48BFpk2rxYGWrC5Cl6qTJ0WyyHLV2CJDLGGzN2IFoyqGDMoNLhy+E1H4Ck3RHYhUfPA3Ts6vJEYMbwxkSGz8ThinrhDMEurnafNWQbUnoyqmQtzbJC/x6nYfhYe4kcYIMAw4zEMse8u5Rb1fClb9J7MuPrZQ4wqALGJf9JW9o1brZrp1R9TeVXLjxo1ru4VaeHStvRP2XKypULiTyZlIB7qBhI5x+leahpONo0JTfqBjOiq8qgPWukw/swiRmnThVdqoSXutxjrNgQtOthn5ky1nRg8Glv7SR0ExfmF+p5+7dSCWrsBxhfHf1v7GzNSakVc/LFq5Bi5O90jJjxujD9rIXuQR8e0zbX5gB8jgagmBO276+N+1V07YXaDm+HrCezeCxSgl4hK4VuYqPpYEcI5hMMswJ19qNMdP7n4mbpbKT2vvrjUR9zINftVoOPE62zbJi2x2dxKj6M21u77pup4rL44a+WvPa6Tjsj+94G0YQ0g4MqEISVw9P
 hk+aF6HP
 xibaux9Uh+7rEeeizK6yggnkswzH20XWmB+IXI5ok3A/+FRZpaUD06MzmOaQtt6zo+3aH2aW0IGUsybX80PrzDUcckWsXWfKD+Oij68+k59aAEwPlREnzFCL5aXfixPO8UNRzgfI2AY1PRy10oDq8B93nRBV+ntB8+x12F1Vn2H+D/Sid5AS0F+i+6275qeCHFsmt++M5IAZ/j7p/5Zb3owiPKYKu7kTSlmp5+/2jLpyy54UXcYGed8DukgPrgYkxsrSwBfB5gMsiHfT78hyXJONchng6xDea3uPHQ9quMwO8jHgs5jBCBM+5eTbXa7lld+XbIdRR21b93UQVnimTqE5p8IoODm3l3NXuFMr7aOcL5na0iz0UPD3CyLuVtcDnf4b0XHlhaxRLN/d9kl0ZlVfSNpVeMo/2RV3Uc73l8uzhCcnLsgM/THOJZTxgkDMpvsWT2HbCM3JjJ8/6ogoosQ3OCe4qwSMRPZCN6LWjjTr0pGD2VcKBS6fn+/cdxBLhn/EB05eNIWGddkAFwvtbtQrMFcTVE38xY9gsKDyrnVFef8GIMjeM6cOpuV99txQQhEjz/VapCBEiEp/kd17HD4g9QP/hTKm77RdcJOFyzmFT/fTrO0ClLRF+HU7h6qoEcNig2UJSyQ/aSIDu3cWradaFszG6XEIJsNmkkMGwnSQUaNYop8vxracq2ryHhSA6FroRAYx1TL9RT7QSFUq/JRfquscVm7nTLILAnrFGF4Be8INCB3tB0j4UeaZZGWJ3K8+iFP3V1AHGyOTsgAV1as5H7sDg2pc8VrV2vsQQa5Z6y3lCh13aiKNOEdFCR1jLEUY/PP4Fw5d2eXoXSHshNFfMKDx5KR8dP/c/ae1peS3PTL8NeqCyTjDb8QX9Hz4N2b2HKslmVMVoPSs2+IowUdkKT2RwGdGPmRP1ZHqWpf0vdRL8M1LyIhF6W4uq7bc3Sbd8R7Jcq/uE3zsBgyIYHX8efEcb
 CaISbCAI
 n/qxPFleUoU40P/AWHl6SiiTtgv0TULOuyP5y/iglJmNoxY+gd5idO6CtnaQkbbAlvRR13lBTZfVwyyI76xbof8ycF1cY1r5SfEFpYOtYPwqLseVVSpWPVrk2E7PXb5nSd0pMMCGJeqEm9NFtofDUw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The rss_stat tracepoint is emitted on every RSS update, including each
page fault.  When it is enabled, it reports the precise sum of the RSS
counter, which iterates over all possible CPUs for each event: 384 per
page fault on a machine with 384 logical CPUs.

Report the approximate sum of the hierarchical per-cpu counter instead,
through get_mm_counter(), which reads the root of the counter tree.  The
size field of the event, the RSS counter after the update, is therefore
within the accuracy bound of the counter from the precise value: within
158.5MB on a machine with 384 logical CPUs and 4kB pages.

The tracepoint reports the precise sum since commit f1a7941243c1 ("mm:
convert mm's rss stats into percpu_counter").  Before that, it reported
an atomic counter which only received the per-task cached updates in
batches.

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@gentwo.org>
Cc: Martin Liu <liumartin@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: christian.koenig@amd.com
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Wei Yang <richard.weiyang@gmail.com>
Cc: David Hildenbrand <david@kernel.org>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Yu Zhao <yuzhao@google.com>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Mateusz Guzik <mjguzik@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Aboorva Devarajan <aboorvad@linux.ibm.com>
Cc: David Carlier <devnexen@gmail.com>
Cc: Josh Law <objecting@objecting.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
Changes since v22:
- Split from "mm: improve RSS counter approximation accuracy for proc
  interfaces", which now keeps reporting the precise sum.
---
 include/trace/events/kmem.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index ac4c96db7638..8ee6d5df5961 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -448,7 +448,7 @@ TRACE_EVENT(rss_stat,
 		 */
 		__entry->curr = current->mm == mm && !(current->flags & PF_KTHREAD);
 		__entry->member = member;
-		__entry->size = get_mm_counter_sum(mm, member) << PAGE_SHIFT;
+		__entry->size = get_mm_counter(mm, member) << PAGE_SHIFT;
 	),
 
 	TP_printk("mm_id=%u curr=%d type=%s size=%ldB",
-- 
2.47.3


