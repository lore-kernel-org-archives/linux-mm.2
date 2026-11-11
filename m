Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E4764606A32D
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 20:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=efficios.com header.i=@efficios.com header.a=rsa-sha256 header.s=smtpout1 header.b=I0IFPe37
Received: by kanga.kvack.org (Postfix)
	id B888E6B05B4; Wed, 11 Nov 2026 15:36:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5F8C6B05B6; Wed, 11 Nov 2026 15:36:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4DFE6B05B7; Wed, 11 Nov 2026 15:36:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6FB766B05B4
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 15:36:49 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DFFCAA7786
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:48 +0000 (UTC)
X-FDA: 85423996896.26.7BFB9F2
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id 59041C000C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 20:36:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=I0IFPe37;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794429407;
	b=hO2XmCLc66cNDgaasUJtpoXZNu4OP/Lh+l8T4YjJ5pDAh/hFira7ZBKrkXxJvoUdn/XHTx
	ewXjOzRLXM+Ae23xikpEWFL2fRXU8Qs7vLwmboAqv6VHo5L9jyy6ng4CeGC/oPqx0Ev0e6
	U6tLbe6k8ZVCJ/8aVm3D6UBQuAswfTI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=I0IFPe37;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794429407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2i0ZK07PlEBtX0QbaKuDG+2M0dY7t2yh0/Eybj/INg=;
	b=ujVuMlGhr1PZ7PAKKYWEJwRYRw4oicCmO2EOsUVD57VqMmEJ68tD/kKopp499YuTCl5aQi
	ZuQLGD2b9FkY8hAkqt2z5Owu7QcCBLkdN2+spgN49MIe6f1EMLOaTgMYtJtKV/K7KAXBqc
	RlX0DNBhRUBUsWD0pVEzy1Mb8VmTpiQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1794429405;
	bh=B2i0ZK07PlEBtX0QbaKuDG+2M0dY7t2yh0/Eybj/INg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=I0IFPe3793QA4p46Km21OSge2MT6m74ErLWthdauWyBFcKCgvz6DttWw/4eCIHQY/
	 mdg5izB4PvnPNf5qUtNtMGoVy/6PPyD9oHirIbFzBeDzjVHO83NNrjR05FLQ08TeSs
	 Dt1bmUhq0EzPLS93XxNw0m+uinSAg+G8jWaNDD1qRsnkG+hWwdPOsV81w/PwKvs5C8
	 rv7u1AGEx/Iw0vX7i3IYlcE+UaV50fzxYGYsTTJoywWQCt9lWL2CXhDwfcnEXNszst
	 4d07Ugb6iL1umD2lmlj4yg/YpFO1RWXFecmAWbX+dy4HcyjcjH17i/YSmU1znKVZAI
	 nKrALBXfoJfPg==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4jPwKn2bT2zN2y;
	Wed, 11 Nov 2026 15:36:45 -0500 (EST)
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
	Harry Yoo <harry@kernel.org>,
	Hao Li <hao.li@linux.dev>,
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
	Oleg Nesterov <oleg@redhat.com>,
	Alan Stern <stern@rowland.harvard.edu>,
	Andrea Parri <parri.andrea@gmail.com>,
	Will Deacon <will@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Hugh Dickins <hughd@google.com>
Subject: [RFC PATCH v25 05/14] mm: report the approximate RSS in the rss_stat tracepoint
Date: Wed, 11 Nov 2026 15:36:17 -0500
Message-Id: <20261111203626.95838-6-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
References: <20261111203626.95838-1-mathieu.desnoyers@efficios.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d6p4tn4tn3t9ozoepcj76di6tep73qr6
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 59041C000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794429407-103622
X-HE-Meta: U2FsdGVkX1/3+CJByzh0bDt/kMFgMQrITGufbPllcvXXdhr3rAWQGtjw5dQw4BbDLydQSAZrRtTUGBDTDTMJUmOS2n/fr809DlfkYBgO+vOUWyRIMwWvmoJPPxA7Av4dmdv1g/Z6hT+tMzE5iGcrBpeyJ3RNktj4/FFcWWQY+XaGFFwFTVnKWrnzpYBdFes5BKrhE0e/WIqG6ZQKidzhquzHzPJxZRvthOy3ySOZpQ5QLc3IsMlL5wc1+/BGndkCRahGWPOebRjbA9+wmpiqTyWx8y5Fd6mGx05Cu2f+iWWk14Dvwnvh6Pq2mKo1Oii6B9bdVkWsMusQs3EtwaqPKl8277kNSTMGc3130GxN/+fqE8ntpb615/eKhDSstaLUCC4ZQeKT509bQU3AwUEWt9fN9oSKDKVSuB4B9icEN1oLDeYVuOV/AbnwAaI72MiKJIsqaVGTbA/fpEk06MD5sJCUBB3gqGAVQsHwnzbtw2dTlr84aA+WO6Tycuub1j/qYDSOtBpHqcqpl0EidKQXZ1g4LpbnIeDWRk03oOH3OHKcRq+MuF5pdPgdTjriFlpwcSxzWyYC640e7CbM+yNMzA0AsEMaqs1OihjaDFydkZ7DX6+PExPqej9XJkgb9M8K5fLh7mH3+aOCxonDYB16dv3y2IhOOAjeZ0TxXTYXqOJE5mzdKwsmysL6p7cmc3WOacN6nYlQ06KPDI5W8XmkwjDFKYyl9Zjab5kj8KYuAlo//kjF7wvAOOIwYxo5icKFvS0JVk9T4pAnD4lkuBHQjsomukvrfF+IYPQc1h5nNy9UkYy+HmOT/FYTXtwOfzxe5PWEYpkL7syss6nUP9kQVWvlnH61/tZujFFOCSl3H3Hb7ZHG9RJKKNCKvqUc324rQwKzlDlGkfHMFmQDACTximpY9yo4bw9dpKqWFgfasZ8HNAEJZTPm7rnUmvZNdxrnTbsbWj+goHc/HCOr5lI
 VWBL2wF0
 7Fc8Ta3LDvUNyhQYFTagEdXwvBVgrxWrJS7tSmTW1reqaqzRVwBlDSEUQu11KNaapFXqEzin1iK2D1HocEPtB9krhATBADJd+3omw0skyvWKOD1DVVL50bt39f2XMrnP5+qXfe2j2rlbNXq5c0jhr9XF8JLfW+I4Tjt+e5vkMMOIvBeBoRpuSTJNIi/smQBEYLmDgxmMAGtky/fZPF3vN7jj0aVVNSrmYWfaGnch3if5e/GBuOOVJFxn8SCoc+Z9CoyBmh91EJLqygSOP4tN7D+oD4NlFShpGGpyBYnGkB2MSAWLtGY8IhsiL45aksdb01rSdZWHtZ3vvPZA2Q58P2c/17uiVzigA3JSZDhKPIimZxGSle0OMNviEOej015ZBCyMjjoMIhFnOoZml2GtdQx/IcJALYv0nzIlfXiS/2OCIRormVCp5xtBKTqZYLPxUSnSdd6pR+p16AucDnBWBVKTW9auVw0fhjw7CQq1Sp2HSKVdmCRbu4nx3E/YAvhAaWUt72wF1/zHX7VOHD0Y5Clu5W+bD1ob6Q2UdytvwOesNSEXPFfWsoqg0zi5SO7f9RqTkFYKKoBrolOH8bg8H1zme0VjqVj79mN5PZo8QJzwJV+jaU5R7jXCwplovwMmQy2n8gPYwW/usRAYRACjJXOcc/BlFaEKfr3MS8zNDl8peGwm9nEkcskL+dX7rhd2vHMhswlb9mNngR2P98bVOGqSK+OAz0cm9tZzDfmIlkZhWZ8EpEhhKgzbIqDz4HSLsaOZNatom6DQrVsOiW+owj5dz6UE+7O4CYQFj67hJNSen2TQCr3YCkM8UCcfbviFwRUn18O548mXPteLYrYPAZjv1ciPu/ZutUz4H53ShUYUr80lrTUbqeiCrG6ynYuxs4ni+OPCba/LQVE6KsVtn7/oGM+6GouWrRv3mn4zvXjSGj3eKWa3lGukj6LrLnPYokZN/joxz3c2M6X6bjvvXpG6vvpRZ
 1s9o+Lsk
 7ddTlvqMMjhxKXamfqe0i9aNb1BBGumElJvlu7pi6KukwEZrc4v8gCqpOaxJHBRxlJm5Pb7hWd4dxqtu16z6Jw==
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


