Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2853D10398B2
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 21:27:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6799F6B00D1; Fri, 27 Feb 2026 16:27:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626E46B00D2; Fri, 27 Feb 2026 16:27:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55DAA6B00D4; Fri, 27 Feb 2026 16:27:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 498596B00D1
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:27:22 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 010941A06B9
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:27:21 +0000 (UTC)
X-FDA: 84491522724.29.FE6CBEC
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2ACEC140009
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 21:27:19 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h13cm9u2;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772227640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8nr8QjvS3mLZizbI7j3rfqhpd6Mz9hXA6KgKYNW+FqM=;
	b=CZRR+6lch8OeFI2Zq/lb/58vlA3ynMDJ1O8CgrXGO4gSjyxTkaVyW5ddV/hopSbxeMIe1V
	kw1n5mbkq3tFjMIQ8UXOLbUfQ9LHcmMY//tbUwKRpPbRm3Kqk+RbHfRgACVskIU+xtaDXx
	CDLX9lFJv6cvU3lonP5O1ubV7hHDo+M=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=h13cm9u2;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772227640; a=rsa-sha256;
	cv=none;
	b=BSO9KnwoVBY7cGg8OfRed1b7jbNWOzGYruE1Y2CNSGPdD0cXa9CVnlr0YjUzEgGhL6GwcB
	QrIhXML70MMfaKununifbsV/RfiXno0OxKzGtE+5jMkx58kGa4tm2+96g4qKwWdGUKDYuh
	G0VXnQn1eHrMwPTmKfKMXHxh61sLFOc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1BDDF43E97;
	Fri, 27 Feb 2026 21:27:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4FAAC116C6;
	Fri, 27 Feb 2026 21:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1772227638;
	bh=WDjPZKs4MqgqqUaiQyuXBaE6TTaaT0C+D7IxDQoFPjE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=h13cm9u2Haz3r+0D/dv7uzmEiEhrbak0bfbOKms+/VF9CK1wFmohzV7Oc2f4ltVpX
	 VkDYOqGRahVOKkttbyX/W2TGuCe698IMvn/RjFUtJJFvyy9pwrEKCg3RkvJ4XXZUy/
	 8iSqa17sXW/GLsZzyuVqRAoCPzeW0Obx7rikUoW0=
Date: Fri, 27 Feb 2026 13:27:17 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Martin Liu
 <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>, SeongJae
 Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, Yu Zhao
 <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Mateusz
 Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Aboorva Devarajan
 <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v18 0/3] Improve proc RSS accuracy
Message-Id: <20260227132717.c811f04b63a332f88e354e08@linux-foundation.org>
In-Reply-To: <20260227153730.1556542-1-mathieu.desnoyers@efficios.com>
References: <20260227153730.1556542-1-mathieu.desnoyers@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 2ACEC140009
X-Stat-Signature: hsh7itnf9rctceor4rzp51ntfajcox4p
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772227639-704763
X-HE-Meta: U2FsdGVkX1/2ACDNDnK8zQtxSDBU4ynZywQWR/OPrmU9cdpcOAcrzcBfPR/jzIwy8CyHdghp0HAgasezXiObR00ms9F2FJ1EoQ5/fz/NEtTQ27XJXgNWRQqAPQ+Q38bNdVlKSlVUiYuKgFj1DvzzrsJCJa8oy+8d3mgAihtqcLO8UyzMxSieJmQ9nm3QfIohyb9vOLTUByFRyMo7+pycP5wNaLZJS0g8HYhuUcB3e8QNHsCbjOc1Swy7rYYX9OywPWelVHBddxJ4+6W9qVFM1mD/VcU2HZf6LQ+I5xT4VfBYIpF2pSkLhH38BCQYKW4QrWqKiPDGJ/qaJOqXe30Lf2njwpCfj6aQMJNUx8goK5+nlpD7egeNspfRVWJgrkbhehLnl/wOKP2quSrdr5ZZSy7cTtLvHIkqLWYPqBOEJz6cx0kD6YjoOdTpwG4w2vg1dIo0cAvDgEe6CI2YDpYrp/kwiCoOkvXY3yDrWa1y3RnubkFwSBuVpc1iVd+84fafPspG5vruLy1zWkbpMIy5VDCmiskYcFkDB9e0sqzAJ57eKL6KA8K8II1SaKYwyJlpu+tf71k+t5MHhdOGc3yUXFFNxkRPf+AnCLlJhserIKHESjrpulrlI+yF7W1YHnGO+vAlHdMmQnl+Z9Cjhinje321JeNwNTALP0Hmc1TeTY4R/IU5pYzr0KZ5xjvmw6uD/0JEqa3cPtJRbH6bgnH6YdhEnewIGKT6srPukX84XQkW85KDPjxhpknTyfZ+5OaTbK5spQ7Fnh1GqmtXqE6QUQtdL0c/dHTNBW/pobKohTaiiQiOJLJaL8Czb/eaV2unNaH/UI8B0uAoM9IKQ4And9qLSl+KNzTAIT6B8BR9A/YHTXyOPs6pL5KvbF9jQpi92rweojtGNHPKF4OZuOCjINldJdMSx4BDLTmw3FCuNGzV89GK6MmXBuxEj7vHeBZmxUlpaAIc5IFhILCtqBd
 18bf3Sxm
 V6ja6AbKVuYbKaGrGYk26Bm6g8HK9s2XRVLxGfUNgsNSQ5piCJ9+herQMpZIs6B0pFTXNm9m616D7Q2QP9AyDRQW9AZSh61z7FOwGoNksGSiAilEzP4wwcKsgeBjKF5KmLvfi+Lt63V5/c8+0qogiDbHLydI2x0u2PMkKyRXMzT2l0El+BpuNpHNVxU99H3gbVkU+23eyirv6F97H/vudrWeUB7gABylWfTI8iCmUvkYOPtPAoS0V3LEs2vXwN/cbdPz7fE4ohK54GqqPpUs9Xba94nGkD0o0n3Lmz5MrsvXFHb2b6hy8+V/M/PAHWei3jKmwydOI85P0RDaxll+Sl84wUgTOS/BAMl1EzEMZAzB8uzwFiOp6pV3HlOA3uswm44NI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 27 Feb 2026 10:37:27 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> This series introduces the hierarchical tree counter (hpcc) to increase
> accuracy of approximated RSS counters exposed through proc interfaces.
> 
> With a test program hopping across CPUs doing frequent mmap/munmap
> operations, the upstream implementation approximation reaches a 1GB
> delta from the precise value after a few minutes, compared to a 80MB
> delta with the hierarchical counter. The hierarchical counter provides a
> guaranteed maximum approximation inaccuracy of 192MB on that hardware
> topology.
> 
> This series is based on tag v7.0-rc1.
> 
> The main changes since v17:
> - Fix patch series bissectability.
> - Export GPL symbols for kunit tests.
> - Improve kunit tests coverage.
> - Fix kunit tests wait queue head reinit bug.
> - Fix an out-of-bound on bootup on configurations where nr_cpu_ids is
>   close to NR_CPUS.

Updated, thanks.

> Andrew, this series targets 7.1.

Some review would be useful.  Can you think of someone we could ask to
undertake this?


