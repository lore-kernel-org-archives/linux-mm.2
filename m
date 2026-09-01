Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ABD3C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 18:29:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB3A6B008C; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 44BA86B0099; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD586B0092; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 07E366B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 14:29:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 943B8A0454
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:12 +0000 (UTC)
X-FDA: 85166030544.16.2EDEB10
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf11.hostedemail.com (Postfix) with ESMTP id F17AE4000A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 18:29:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=QajWR+kJ;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788287351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=FOcNzTawBpX5g45f7ywapH98j8rGtWxKx3lq/TqFmkY=;
	b=Yy8p75vDtfnKYfkeI05uIUWnk8aqgTqh1YuODX+OwsOl51c4KHOzAVNJbk4uV1RheKW9i9
	aHnBmnVUiQxmT4HWwB1/B9zeOo26oOXAmiMsmMKUgVtyg/IEAaFSpcIg9tn6dqKFjTx4bO
	HI4tOM8wrUa170lIp0gh8neWEiNCcag=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788287351;
	b=r1CLcIsejgwp0GQ7Wq1iC+yMwm9Qh6lhFMicqzg6HEY909MNeGro2lBUVznedMWar2t43D
	0M5+zrlaJlwCCMa0kAi+rBs6Xjs5ts4en0CQV9aQPNQwYNvB2483DuoUxMkidtn40i6W99
	qBte04RkLTzrhrIuuuUiodwEDNH+kTg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=QajWR+kJ;
	spf=pass (imf11.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1788287350;
	bh=FOcNzTawBpX5g45f7ywapH98j8rGtWxKx3lq/TqFmkY=;
	h=From:To:Cc:Subject:Date:From;
	b=QajWR+kJdHwkjna4g3bEa6+p6wAOZ4Ed8kxzCLylLQOnUsbr/HSrzL2jEK8qcHmvu
	 jag9LUbVt5w+5foekmrQRUJ6kfOcAOQ6FIYStpSQDAv/mg6B5XYj48vKpRVIC0qZmT
	 Ba//F3JqNoQlsKvj64FvObhl6E5a5gvmTAYZETRqY5RvYFhqURhvWXbCSQ0yCw5t7I
	 b+C1GqKGOfYp9JpGwrGAMYw6e9OzSYDEm63yH9u5ofB71csJyO48xdW/eAdYEgLKvM
	 z4BLi+LydGEiueTObZrIU9yOsAJW9WlimU6BbOPHTxI0r8phOdnZCpx5xcpyPIKxSk
	 rp61voO3nkqdw==
Received: from compudjdev.. (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4hZDsL0JtGzWHJ;
	Tue, 01 Sep 2026 14:29:10 -0400 (EDT)
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
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Wei Yang <richard.weiyang@gmail.com>,
	David Hildenbrand <david@kernel.org>,
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
	linux-mm@kvack.org
Subject: [PATCH v21 0/6] Hierarchical Percpu Counters for RSS
Date: Tue,  1 Sep 2026 14:28:45 -0400
Message-ID: <20260901182857.26690-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 81eqomnaf9s8fwnhh3kbgcwtqpqngu7e
X-Rspamd-Queue-Id: F17AE4000A
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788287350-766115
X-HE-Meta: U2FsdGVkX1/ZbIn32CQRSjFdkL0E7aBWlzLBdjWGwS3CSo8udA9s4J8SQflMNE7IDIHSeYek+8xLeoCES1MzvbpPuXDOZPjD3jjhKR9Cf674UHAc1nn24d04H3zS/SNUWBE1eOezrzbwQB2HcQ9Ho95sWhZiaavw9t+zqkURmk/H0GL73eTvhzMsOahktjPBlVjbJPW+b2pQNcY5U47yc5pTltI9av4BMhMwheTG84tRRhZlyfO/IsfRbpK31JjnaQq35ZgTxBLTvwGeeRFe90rHQGGjUlcD6qby1G5xfp/MYPD1FU1lObHYK0RoQlJyD9S5x/h1c3t5tzZnpVOzCJUpzdCFgpKW7cdCacOg4SaE8PoS3oZXmdGL2ixetM833pY/FZfdt3ghduJCn9g6k9wGnFMAj1Q0ByvNH3Mdw1sGrjCePvUphs3P5Hm9STbdyFn0BQ+998GPTxx1VyDFVFa4IuGVI2Mq4SNE+73jKU16MXkfyDkusw2rjB8LZibE9wKv0Hkj1q9RQmDwbNvLEKD15EjlSXXYOOE1Y8iKzSpn0UkLdNn7pm/7AKEa7kLWuk5ef7jkRE+orCdfmX1EIzV1u/yr/g+lPdEGrxhYeLvdJNiKeyjHwFpZ2Q3tzDVRO1ZFfzbwQAK4zauIKQGcxO+8LoeVbXPTrMbmDCgpFMo1n3n9yrWsp+X0EKpls90AkmXsMUmHC7j7Y4YZ1D3TtysB+tsj6MYrwU6Duuzosqjdsb74UIEjqBG+n8OVQLB0HnK6ZnYXFixgfdiekBxzu4YRuMtA1sapAg3XJAudUBwx01UQBmWfqqU9cghGzPOv4nDJnwJ0T1nQjd1r/q7KD8EAKvsZ60mUXIvO0Xi18k0In4FBqQ6GVo8CytPC8a8cowfuDd30DUq7Oo6PTUMAIsbois3+Vw6HrSM+1XS4yWKjid/q4EyafUgWCRnVisfRWimMhZtNB1YNS1d+g+c
 mQp/18hZ
 LpoJLtsKYfCSUCQWkx0AMuqEewJuTn29m0olYvEqMJXNIQdpzcsYdT18r1CrMJZQNJss6pFYVKLDNe7opxd8OelMmWfw8Mm69gVLhXgxrRi81eQvpgKhdNps3FYbgz34lSqDRnJaP27iF/+COWmsD32cy04s+kLQQtCzm7ahI0RIdrt0bV0usYcdmZtalmERvdTnvnQTCHvmAQQ3srrbtj4dMHB6yXMir8gVrmrf+FvVI6r6PTBrFHNUJNzfEcH0OUJOPxamA4FQ0IZBBWYnGs/zQKa5CHRdSXd8DY5MHHzZE/fde+KS3fRNMeSUj1HkR3TMNDL0jWmxCmy53aJ9iQ3OX5ou+QZL/U28TL4vg3Tbyuh/btN1C3eLFNIxlirrOuRnByx02PY35BNlMu8kQUWwxZzBiXQiJcbAkfSlViiVYQeHQDTtnEuadSc5U2PBpSCujAB8jmAR8hE1nOvAW7nBYMJZOxC2Zi+e9kp3wYcx0jZY2buFDe4tKwJk8LP8S3G0DgJB0v3Rgr40jg4uYJIgL4kFWVh9/C9r1dUcusU/P8VVQCOZ8kYK+7M+N/fYymb8VfjpbmhlzaMUDYDF+QY6Ol58OOWrmmijfoVNAjhCN0Pu/gHC0sJa40HLtL5erjboO+/msGlddj3ALfoFgCgpqcREJCTzkQU0hXRUdUjKHRHzFph4BN249hutBQfday3qYJ/7rTgTh7AJPUDAMvWRDtid6NkIhFyadL++XZz7nj0rDMOGwANC1Ab64/3DcEiaGtNkiQ6o6fzFArYHnWGvQWMpqj/sEiP66fn7ZX22F+z+O46ZPBuiGrOnKjI68aEdENZeYdzsjr6IQqXbx8vbNMPb9OuH+wqNmgVWCcjAbhVQPgtbLJBZ9g2mMsABFl3nvzp/TUlsIEqEv/WszjcNgbz1IjkYpRPpyrF8mMnuzhCc7URZ+QdY++fDOCP5U6JP/ULVBmcQzap2ZBmlvf6aeJavi
 xsokItF2
 y+eBm1X6fLng0yCmZLGAOiU0fP1/jJEp0fLO+XHp1hk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Here is the hierarchical percpu counters for RSS accounting series
rebased on top of v7.3-rc1. It includes small bootup fixes which were
needed to fix bootup sequence on specific architectures, and a rename of
the test config option to include "KUNIT_".

This aims at replacing the prior version of the series you had
in mm.

As a reminder, the goal here is to provide more precise RSS counters
through /proc. A future step would be to also use these counters to
speed up the OOM killer task selection when OOM is triggered by
memcg. In whole-machine OOM situations, latency introduced by the
OOM killer task selection may not be too much of an issue, but for
memcg, where cgroups may routinely depend on the OOM killer, the
acceptable latency tradeoff is quite different.

Thanks,

Mathieu

Mathieu Desnoyers (6):
  lib: introduce hierarchical per-cpu counters
  lib: test hierarchical per-cpu counters
  mm: improve RSS counter approximation accuracy for proc interfaces
  mm: reorder mm_struct flexible array to place mm_cpumask first
  init: move percpu_counter_tree_subsystem_init() earlier in boot
  lib: inline percpu_counter_tree_items_size with boot-safety sentinel

Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
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

 .../core-api/percpu-counter-tree.rst          |  75 ++
 include/linux/mm.h                            |  20 +-
 include/linux/mm_types.h                      |  65 +-
 include/linux/percpu_counter_tree.h           | 387 ++++++++++
 include/trace/events/kmem.h                   |   2 +-
 init/main.c                                   |   2 +
 kernel/fork.c                                 |  24 +-
 lib/Kconfig                                   |  12 +
 lib/Makefile                                  |   1 +
 lib/percpu_counter_tree.c                     | 694 ++++++++++++++++++
 lib/tests/Makefile                            |   2 +
 lib/tests/percpu_counter_tree_kunit.c         | 399 ++++++++++
 12 files changed, 1651 insertions(+), 32 deletions(-)
 create mode 100644 Documentation/core-api/percpu-counter-tree.rst
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c
 create mode 100644 lib/tests/percpu_counter_tree_kunit.c

-- 
2.43.0


