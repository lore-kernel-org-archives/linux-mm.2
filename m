Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3B66DE909CF
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 16:10:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4254E6B0093; Tue, 17 Feb 2026 11:10:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BAC96B008C; Tue, 17 Feb 2026 11:10:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 292F86B0093; Tue, 17 Feb 2026 11:10:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 0E9706B008C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 11:10:19 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A4F4016014C
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:10:18 +0000 (UTC)
X-FDA: 84454435716.08.133A3D8
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf22.hostedemail.com (Postfix) with ESMTP id F2D34C0013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 16:10:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=uiYw6nyk;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771344617; a=rsa-sha256;
	cv=none;
	b=2KKjDgIzsukKXC9w59Dr4izjcYQMGfc0tTOokrmZZTLEOH01S6/lKuLPX4nfwftbJO9Wc4
	gT9BRHSfnUDrKq8feZRY9j3zAfN4tTZgWOvOWEu32FLug3YyX5V4EW0ix3KAFxZXS8RhaS
	TTfeY95QssrjoNr5TziEad1/iAIPA+U=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b=uiYw6nyk;
	dmarc=pass (policy=none) header.from=efficios.com;
	spf=pass (imf22.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771344617;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7oSA143xwhlpR+YOhY78eAKWPWQQBvPwfH3/iKdQHP0=;
	b=3IGnO+3UN3ZFvkafNkt5VuHtUbMwZlMN9yqEsl0d9zcm689yfXoqcscdpzOALN8kn4OviZ
	4p9izWY+f5Qhp/pLjtTbNNQv9EfRtF80q6ss8v6l9NrX2LpondMAjFNqdrE1xHdEmCS6W8
	GdCLpkG6kXsxzsOLJy26uDBQCkVaHK8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1771344616;
	bh=7oSA143xwhlpR+YOhY78eAKWPWQQBvPwfH3/iKdQHP0=;
	h=From:To:Cc:Subject:Date:From;
	b=uiYw6nykBEOTbBd3NOKpiB9QphOhW+vwiQiTPXqz4H8uGpnsbjc+Fq0w8CK2gpp+w
	 GZvzUdguuC4ODm1aNGDOjtOes6HF7kk+Pbus/xn2lJHwHXjCibwYJaXU9w/7/BmXed
	 5KxiI0Z6Pu/eByLlsFeEaOZZAHGAnKGyI0ZAs4VxDPKzydNJyb9aiOR6pftCCZD8tY
	 qv6l7x0uo70/Eh+AB0p8AOjxIxZyBFDhm8NdZ+mclPMp40JETVmaUF5HI8ZnkbP3of
	 3ZacZfK1ILpW8adMk6795otJmIk5CmdSSEPF0MOAjAnNydDAE25J+dKkIxwwj5eouP
	 5NgWTC5HqaQ4w==
Received: from thinkos.internal.efficios.com (unknown [IPv6:2606:6d00:100:4000:1cd8:5cbf:5001:d5b1])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4fFl3X13D5zFT9;
	Tue, 17 Feb 2026 11:10:16 -0500 (EST)
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
Subject: [PATCH v17 0/3] Improve proc RSS accuracy
Date: Tue, 17 Feb 2026 11:10:03 -0500
Message-Id: <20260217161006.1105611-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: F2D34C0013
X-Stat-Signature: 9yojzytqondazy8hk14dchxsipk9iccy
X-HE-Tag: 1771344616-213444
X-HE-Meta: U2FsdGVkX1/GO9e5g4BZ8uuI8J+F07RrQFjnc7FKoQAmj2oEov8Oa3EhB56DpyHgTzXm5M1DDhKsacBVfzLDRzU37pyHaVcCpf4bW+LBxtYTNageQUKnVRCf+Sjjm184zZTzIu17+Wbz2BPGhRZNHhnzuDXdzvSBBv9lajZ4VruQwqakhegJcHSYOxpPpXSRcnDAOwViwcYrH/k5xZ2YSW8sypzVsmoueAQQkVfzDhvrZnLSx1Ed2hWpqUU/Nhf1jFGDZ/8nyTfQF8+w7YWSThGBna+g45qNmbfZGBM94nZzjucqADMExoMNQ6CwdaAlvsHKr4dJJf4Uj8Y5gHQ7Nkfm1b5wyIrFk9RIp2kbPsV+BruzdqOMqmDNkb6+AjEOP82qiD241xK+pc3IrGBjbX24VpyR4AQBNIdFj9KMIL0ofuzSalIiv+NWWImETx+/dy3HnbiBQY/JDAkYfAeAFyiYXbpXWo/Ztgl9HW0LwJquWiwOrgQO+NbiJvfeAD8VfaHHGaYQCJZrc0jHRgaGRh6fLu++D/48BzsHTXv2Hg7Nbf0LOwZ6HbrNisl1bqPNAJuJpR5g3e57iznKjWRnoaP/bn0hMeRyn9mPHiBtoEhIPJ9jGHTwnyoE4/Lbw7McZJeCEMZs79kO3L0idpJscAtrXMXLkGyF+bd+0OY20N4xP+KzSrJlqfAdtS4JQsYxng4i7Y8zSYJZ6FDXWtlPdcsRVn0V6xNRRLSvfL9jIeegNENNYLIf7EMYmw25SeIeM9kPql7PjiwovG5xtu3AQuw2KgrlKVHSTG69B1+ElloWyD6qaN16isYlbCAIa0ZogkwHoyTl2+O1HxV0znKmDpN3f0sAC+T/aM2fV/ScQf9W0wpy03kc1PxzsJ89VjzA2jkM/MTv8UN7ruoRfnkLWhbtCZJHCUTZ1Abx9mzopuWfygCkytgjvVwbVg7Y6hSSU6h64hYWR8b1ruYaCy+
 xYEZa2Fd
 MxeBbqxw4ybtZUo6nGXi06kecXo6qrXLiDLmTetf72p08EuuMkA2iap0ZT85xYbMpC5ko5iRquoGlvbwuFp1HLZ612bsE3me6hZPt5xQeXt/JwvW8xFeX4vr3H7kPQWD8wit9rTz5l9oGZXjV1bggfOP2wxASbSDJqdEPayd9fvJW7g5ZYKtXKyeGCpJ0o58fg6r+vXsN6kStgysx2PCfd7xXktm/82DMsDqW+XZjR686U8nQ0hoCXLTgrrlzYNXy3iaO5NU4I9Cdiq7+cOKVEi/IS718a6eIGcKdY+2dce3u7nN7pVkWZlg1lxMx71I3cMk+onS/JZrOUWu9h6xEsgm5+2oLnxB5bySTaKyaAJe3rkKXAxtjVdoPEWF6/cFDeYj2H1dZTJa1txc66lIY9ub5yZ7qoxp+ftGUIWzlgQRsIz4kBMaDGzZi7nIQiKXvhJKGdGXlCmwfhz51LDHQ8L56vv/SEXg1ue4LNzKe7QcPAAdiIjUspeZ4L5HsJNHX8+b+tClUp5zwjMtbd5pjXPElmNn362qU4mM40/iUYIRMvNeO8mVuJqA4dtwsPiOR0RVCV6EYnBkiFO4/VQVcYqegbBkJXUKwEYhY1wA1d9LTreUSQs9DRbSbdJGEXPRBFvuCcDXwa2IIAnLCNa7Q52fJa3ZQ2aT/fPqbKshRmvL3b6zcsPt97ARwHsnXwV6yD5fT+pJDiDSbDov0ZyFX4uFGbhHskP0PFyTdKGmrnQdwjhANETNATic/5GSFh2gYMi7c1sUDxjMLoUbNVgqYH4HF/Xx/kVA2yQWXf8FsGuBHOwIoQ+oEXrneeG5qlhePV/tvy3pqGYqWN6lvR5u8e7vBoADjB7A0G/OSkSXLeLGDd+6VDok0qx8B5FU6BcvusziM4I8gzlvMJGpC+h0UX3HbnDIORz1zAp/DPa6mWx2sy8f4FiFaT+Rgo9gX4PNtiJ35osFcyxjcX9cxoNcPArE626im
 tPk0ZNpf
 x59I+UxOgD6vIN7WPkCBKaW7pKz2xjAyCsYnAgdfALL5HUvSZRyaFYbP6JFyb13UI+mUQHoHkFydlgLHf2Lnz97X+cCcErXiihvXndTRGwc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series introduces the hierarchical tree counter (hpcc) to increase
accuracy of approximated RSS counters exposed through proc interfaces.

With a test program hopping across CPUs doing frequent mmap/munmap
operations, the upstream implementation approximation reaches a 1GB
delta from the precise value after a few minutes, compared to a 80MB
delta with the hierarchical counter. The hierarchical counter provides a
guaranteed maximum approximation inaccuracy of 192MB on that hardware
topology.

This series is based on
commit 0f2acd3148e0 Merge tag 'm68knommu-for-v7.0' of git://git.kernel.org/pub/scm/linux/kernel/git/gerg/m68knommu

The main changes since v16:
- Dropped OOM killer 2-pass task selection algorithm.
- Introduce Kunit tests.
- Only perform atomic increments of intermediate tree nodes when
  bits which are significant for carry propagation are being changed.

Andrew, this is meant to target 7.1 after the 7.0 merge window closes.

Thanks,

Mathieu

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

Mathieu Desnoyers (3):
  lib: Introduce hierarchical per-cpu counters
  lib: Test hierarchical per-cpu counters
  mm: Improve RSS counter approximation accuracy for proc interfaces

 .../core-api/percpu-counter-tree.rst          |  75 ++
 include/linux/mm.h                            |  19 +-
 include/linux/mm_types.h                      |  54 +-
 include/linux/percpu_counter_tree.h           | 367 ++++++++++
 include/trace/events/kmem.h                   |   2 +-
 init/main.c                                   |   2 +
 kernel/fork.c                                 |  22 +-
 lib/Kconfig                                   |  12 +
 lib/Makefile                                  |   1 +
 lib/percpu_counter_tree.c                     | 690 ++++++++++++++++++
 lib/tests/Makefile                            |   2 +
 lib/tests/percpu_counter_tree_kunit.c         | 351 +++++++++
 12 files changed, 1567 insertions(+), 30 deletions(-)
 create mode 100644 Documentation/core-api/percpu-counter-tree.rst
 create mode 100644 include/linux/percpu_counter_tree.h
 create mode 100644 lib/percpu_counter_tree.c
 create mode 100644 lib/tests/percpu_counter_tree_kunit.c

-- 
2.39.5

