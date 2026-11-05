Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC172606D82C
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 20:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=x5AekszR
Received: by kanga.kvack.org (Postfix)
	id 5E1F46B05B6; Thu,  5 Nov 2026 15:36:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5923C6B05B8; Thu,  5 Nov 2026 15:36:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 433C76B05B9; Thu,  5 Nov 2026 15:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EC3A36B05B6
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 15:36:51 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 778DE1A0C67
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:51 +0000 (UTC)
X-FDA: 85402224222.30.04263C4
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id D93A240007
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 20:36:49 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=x5AekszR;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793911010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2i0ZK07PlEBtX0QbaKuDG+2M0dY7t2yh0/Eybj/INg=;
	b=lQeXJ6dm5scRTYEXqwpzkDqPWnL2aV6LIa8BJps6IjvjYXIkHH2rUQbbvRLFkPwXcbhXkm
	wznLSGdMKpny2RSEQcFcCj1+N5wUQFoxQPYWY+uIl5pugQr+iIFMBsUBDoDZvXamg2mWq4
	l2LWTJqYUT9TEPRJ5onL8G+tuawZ7As=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=x5AekszR;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793911010;
	b=3mQxGYO/yoSbfTLwX9/RbnnmdKk9dfahP3/5AVPngrU5mkMjO8Am/jRRJVSiMysQH9ywcK
	4EGu8ngaPuouL5a5N+6WnsqP7CAZ67dGZ+Der17ee0y3+WhOyVvGc5rIj6WGOKJz5vZMdl
	vmoZll2eAC7D0IcaKrQ34EETiuCdLi8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1793911008;
	bh=B2i0ZK07PlEBtX0QbaKuDG+2M0dY7t2yh0/Eybj/INg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x5AekszRqXdfQwKV+XhbMkYVoRhiQbfwjJnTLEDMQh7V2jor+1hO646aM2nSp2BN1
	 P9VGVFbGxo8czJ/HoUNyrOxeZTGt62/CZF3QeP6a9PYcsOMYF7X44ZwTRrYYj65KFc
	 Ud9/qEmBCCsSyYE/BPDh4AjeJ13l9gBbtthCIuuRcO1QYCxHB8oIUJwuLIGgN6zuDH
	 MqlPItIlReuqKWqCzrWRGGsh+bBDUpg7H25DnJIDqRnqmsAXV/bCMqc/AoSjV5y2Kp
	 1sNG2K6vEJ4lqf3SHbN9wpgoTK5JTe+ToKt1ojOy+hvFr3EgQRIzskf69nxUeXibOp
	 MhZFIw13rrdsA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jLDcc1LV9zM4n;
	Thu, 05 Nov 2026 15:36:48 -0500 (EST)
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
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Randy Dunlap <rdunlap@infradead.org>,
	linux-doc@vger.kernel.org,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Kees Cook <kees@kernel.org>,
	linux-trace-kernel@vger.kernel.org,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Oleg Nesterov <oleg@redhat.com>
Subject: [RFC PATCH v24 05/10] mm: report the approximate RSS in the rss_stat tracepoint
Date: Thu,  5 Nov 2026 15:36:34 -0500
Message-Id: <20261105203639.1459524-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
References: <20261105203639.1459524-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D93A240007
X-Stat-Signature: oytu9c6xmj9xzy78igtgfixtbhqxp8th
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793911009-592215
X-HE-Meta: U2FsdGVkX19MDHmtXuh8PafswTmxYZR0R6nKC+Ite4VjOOcEng87YSD8C9oGQUcuFEhBkWKKqPWWQJIXqPxpsMw6ZMHk/mRX+QZbMUPFSnUKNEv2oAvfOYg1qm8WDYAVrmTXdzAUzv0SqFLwZmntt7QLvpafORCHnodTePQkBmu6D6eQebOLWBYHws7gEN+YO3k3MvDHk1ZMIPHdE9sjxFS0CUn/mrcNkwICoFRwomo++Oe544YCBT0NwHoEH/kRcnNlKhfIUM3LSh6Ek0hXObiiuc/1nVkPDtBY/NCFh+rtkFye73Y/78uW7rrzodSmkELqgsmhKYaTYD3VrwCeIovxSWjxeko81cytKyM3WWw/tiJSGoYvoVSWTJqBTuHnhRWeDhuFiTL3wjRu5CRlfT7oodB+i5HyPP94FwdDI+9bPxuThN3FWaLUckrFilWHVUpsAXmZoNM0xqPt1KNe+qnd/B/5yfRQdLJmYaVSscCMaYlO+yeMUBzKWco4rAf7L0hFz3eUHw2l2XmW/2zuvL7Wj6NXBwURBy82VAYCjQ1VNOS+eDE/hq11QbwIw1ms3AVlpHNKv4ss0fBhDAlPRqy5p0jrI9mg5RR4LKbEQrzIO+SCn3XbYoK9+14o9nGmpsKRxa0zs9uVXNCfjYCUubbHN4XGQ8SxH978NIP5U8Io4BnSrC8vM5bxHpd7TcdlLKM6QBJhdKiELeRI8B4jE4vBb9eLvFT4eefpf96eEGwx/+PyYNaaEZoSiBssZFUc5rHxOJRJW5UyAcitaK7EemW3vnkOAHiwdxtNmd0RNXJoX/mrkENUxTFYbEJ73OeiswgPLuXTU7ZE+bwocwB8I1pXIJ+xwZaE2tOeSABLRoKAY+CvvCxzNTPi6d8Jfb7I7OS9j8+YdMuMDHMQZjr0/w44zAQo9chUGITMlXT9RPjrDlfRi0lE27RNt0ZlNVd09hvLM30F0L5Y9niPLDU
 jr5Z+I9b
 0BiPCR8PEEr5D7CbA3HUrUgaomFeZHFhpW+w20sRalfmObM8pp9cNgnuT5U/Eoczfouf61ltmi/ZQ4pEIfnY+F7iM2+QR/vuXZoR+Ye4YT9KC+64/HKJQxrhcR4DqMAtpB1uCG0GDrOERR6J3H0KTfXSqc4Og9M2PDBKx0CstgEtggfzRI+7JIDQEp6//1SliS2JBiw/qQva4b+Fb7o5VL/JBtP+8CEjG6RYaIL2YHR17A3Rl9wJ6K4G+vabk3rwSlYTbmHqloeCk0qwbEIo7Ub2ulVLyzmLtTbtBHg3uu33GI9Kdr4lBZ0LGzFcX99unaft1u+b+Ch/o+mR0qo43Ho0JXBKdt6Na7Mr/rjyPUkgRaqfk6qYJV9o2qSaOlccRaT07LfDMwTuAwsQC8QDr7AjN2U297uTqWAMJChwXOWpYfGBCmpdu7hk2ktkdvZDpoQVW0DCR30pbWyXfRtHJdp8tJA1CBf+4wIGhU/jICWzFzMpI68sU6JMyPkIRZ1iCykUMM/vytX+SGIhmrWKp34GC/Ac8TEr1cRJNMnHmTx3ZTYPmI0e3swUX05ptikjMb1WC/MftRLwnJqE97gC1WT5VU5Ry7CiNu2gzXg0fizXexQU0b6++31m6l98louJmK3GCzj1qle6A2grmJJC3GiCOmVqsC/mJsOmE8xp7Y45GEh6hthL6mi6EARjnD5JG9tbskcSVmIFZxDscSa5Bww1WlHUn9w/lkZdPyUTlSQvJeUdi9/Yt1JqxgNWOpiZxFR6wMPWIMWmwoEpH3poaDJXdz9Nr2ANKoSGVxj++Tg6XnXFDqjpoThq9rb6LBdRrhLnxAETYuRYZIfBQUsBt4+M47V5Rxl9kCqOvG0E6hU4qlw1kpzGEvw0gy9SG7TzeA7ITOR0CpSwuJVqhd2836LoUqrKlzIQDagDhPO8Hy1t/NRhyHAI6r7oFYOw2AG4ogjNLRsS+JkB5uTfZAdDDFA3UKLVy
 K4hIyuYJ
 4CcWEI0J5FMFYeHVjwhRTPtNTyJccWyEQfZO5fJBRnJ/AT1ZKLtspdS5xp3tVFvFpTcscBlAkAl3IsDbb/O2YQ==
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


