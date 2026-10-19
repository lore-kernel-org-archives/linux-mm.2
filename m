Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47BE7CCF2DA
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 08:53:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 339756B017A; Mon, 19 Oct 2026 04:53:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3107A6B017C; Mon, 19 Oct 2026 04:53:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2272E6B017D; Mon, 19 Oct 2026 04:53:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EE3866B017A
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:53:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 75938120642
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:53:36 +0000 (UTC)
X-FDA: 85338762432.23.A6C9DD9
Received: from mail-dy1-f180.google.com (mail-dy1-f180.google.com [74.125.82.180])
	by imf03.hostedemail.com (Postfix) with ESMTP id AD5F820006
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 08:53:34 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bj+Ypgmk;
	spf=pass (imf03.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792400014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUQKxK3gJveo0GbdIu8MHrrQ2HSW0SFpxRsXuUxNszA=;
	b=W+6aNZ3Rlx65paFRrFJVt5GkSUO9jqFqW3KR25Bw6AWh6afudl+U6+o7W6Ik3E9nNwag5p
	wIL1tE9a8utKGzcavTfo4HB6qGSFD0rdmKZDV/HRGvAupTOcNYZ+oRSokZFKMjwA2qsik6
	7JSW+MCY44Lbdh9gJbYuxbhQipuJQkU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792400014;
	b=n+PZPTF4CMbEE/S+iRi6Q8icfeSU9+BYkxTp4iIL+wEu1YFRKubVtFVjv6rskvBPw6ZtP8
	AG7u+UyxN48MB1CJ7f6j3HOrASSGipZ9vYuPUtA7SZ9MJseOb66TerBDwBQD96xT+0AIj2
	Loz4vqrWNnnlgSaQfhBqAT0o0py9aTQ=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Bj+Ypgmk;
	spf=pass (imf03.hostedemail.com: domain of odys.yuan@gmail.com designates 74.125.82.180 as permitted sender) smtp.mailfrom=odys.yuan@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-dy1-f180.google.com with SMTP id 5a478bee46e88-3550c917fd3so2170201eec.0
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 01:53:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792400013; x=1793004813; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=IUQKxK3gJveo0GbdIu8MHrrQ2HSW0SFpxRsXuUxNszA=;
        b=Bj+YpgmkA3A2Qak9oH0GDZp3t3btPjUOU/8+VllJ4/l6Vp2qe38/UbaeBZ8Op5T4bT
         2OVUv1pp37BhSCNNyuS4j/Lk50IGbHs3/5bLYttIfTCgZje7XwyivKdt3qodxUoiDke8
         3qnr53OiSA0NNKesqp/Tec89ya43dTQFNO1Jbyjp+gL2RQdMIwbAo4aZbXmNJ/YyBHuS
         S5e92KzueQ66emukBjo1+J6z1lc1BkQdY5xkSH8QC1Hye+uay5rhvwcyKxGjz6+geWNO
         zpYvM477wN3bdHcxaPkQ1GTcpvWwvkZQD5BNnFF4iUs8YqFpJhDo4wbX1zjM5/aLd4x+
         p8PQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792400013; x=1793004813;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=IUQKxK3gJveo0GbdIu8MHrrQ2HSW0SFpxRsXuUxNszA=;
        b=Ix7RlYNAGUFs3wUWYuz3brz8Twl7pFrD6PlnL4dQfRDjrVmTwfVQd1apcgHRbgNtbk
         c+XxAV5Zl/IT/KF0+GV6LpbacKIgmK9FOAQFZZ3P/NqDjWYHWTp/GUy78PHiye9nRQiI
         M6lsebxaHk0yMHtbB1F4eyL2MeYiX4VoFw5laPC8CI78GTxGrYs5tflKARp03Y53KIr7
         w/sMrPWSFxVfa4lZPlj5GwsrDIPiva5eqg0Og6Q1Idj5YQ7hiOnnkJgpDUgEJpJq/+2g
         8pe1uvQrsH+6thN6Flg1gnrp5768cY/NFhXcHSh1tgx1XdE7CU/qxqRj1IA9I4hhEkk8
         RM4w==
X-Forwarded-Encrypted: i=1; AKwUvBzRKLfjAlIrRhN2kI+0SJgByL8tDpjvkiSUPo9uNm7ViooEbcOgH2e9mp6RR8jplovnMj+Z4cS6WQ==@kvack.org
X-Gm-Message-State: AFq9FYIXkyVLj0FScESnn9dxADZ0CRb8+L2RBQuj0bKmg0qOcWUUcj/J
	DXLMHiVfDmREtBTQ9xziAqgSmegzgKiydZmwYXeSRq2knd9uLBJxE4Up
X-Gm-Gg: AYBFou3oAiVIuNHD4C7YpSeqDZpQd/hbWZjj3zHmN86TCX/Fn5xYeMmoK0m49dxb9HM
	SunnVsk2Og5IQombA/c9dHMLhX4V0gOFEf1RXAZHTveCrA7oeOVHX3PyqJXWuFdtvEVefoDzugY
	j8c2ZFa8kB5EothimrbwALYrh5H2MJYOmgoHbkpqwiL6EeMpC4wAXcMQk5IH5irPa9QvwEeoBF1
	YbgshTpt+1DEgv4fwEegurOAU2uqw/RslfKsnblZf56ZK+ESp26YIBPNqUGNTuc4HCOlmUaKzgS
	vfZiC+rrWUwL3Odhpct/8jlbbEwR1iuylv/jAkghL1kSDiIKbsZKhnpFuXKFu3zN/J8wRsuzvLX
	9avO/AVUoxveog10d9qdUdukLHk2Ykc93R+84cKv7oM1bSu5nDuEorc0yRs5GZCUXQfN5iS7EQt
	HEgPoDpoGLTmllDwmTxHuLtW/l5AqOIh07sIrBbOiLG9YjUmiA1fASiK9SNTgBRVBzpSbrQewe
X-Received: by 2002:a05:7301:717:b0:351:1bdb:e3b7 with SMTP id 5a478bee46e88-361a186348fmr9105771eec.15.1792400013280;
        Mon, 19 Oct 2026 01:53:33 -0700 (PDT)
Received: from ubuntu.. ([23.254.208.9])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36081bafa7asm30069333eec.14.2026.10.19.01.53.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 01:53:32 -0700 (PDT)
From: Qiliang Yuan <odys.yuan@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/compaction: stop repeating failed async compaction on every THP fault
Date: Mon, 19 Oct 2026 16:53:24 +0800
Message-ID: <20261019085324.2562579-1-odys.yuan@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
References: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AD5F820006
X-Stat-Signature: df5bhzp8r6so19j99rbqs6p7dbgk9pwt
X-Rspamd-Server: rspam05
X-HE-Tag: 1792400014-807970
X-HE-Meta: U2FsdGVkX1/99GfvehN3OUnKh/Fww8O7dkl5kIC82wZoyT/Ea6eondGXe09jfm0vtzbH0+jt9tldvTD4jL48hFGhOHEC3B65B44uUt6ivLRW3xDzBXMHjN1G4g2Rvp/hgjileBVItCxIgSz1DsFXgbDrOHY6kOmBgSkvpyAzRdNKEaTicJYVf+4P0HcHhZJzm51+apjgLMJ/12uTsRhJr0SQISJytPO/P35udDr9KdL73fIu1r8Xo8lF4WxYc5U4IOfVNRJYnJjC8p7ZyKKKTfq2j0ErKK8Pmq7+Js7zsSVOqhQs6EhXXs/XLTEFvUDmOXueu892mqf3HFegVtKgPCEnH7RIKN+1g16P+nbWXFBhrINHPNXbtqAMomDYYSWzv/ktITURaZond47H+RcMk2rBe0h90zBSvQW4R5VCkGbpgt6biv3vQ2ALJTdQGKK4Up9CUoiDav+Ato4PL87aYIsEKJDPYumxCjtvmQkpK2JtxrNMTZdZbBJBzIQZiG6Tif0kr1KZXDKstJtPS5Twj/qH2Z+l+sk8bBhel4wB48mdfDWYBqIXe+D/aNn3ZiLVwMR2r2VPR2N6QQGN7pbyZySlMex/lQ82P4QtzSyJmz6698gLcwLBqwaGe0PbbNkO1PdyRnJ4+xSToA2uScHq6pqeK6rDVmt1Slz0POHTAtjwf1OvE9Dykd7MvUYrszcJotysg3EylA1/x7nS3W1FZQr/7Q7dpUZeOPMPKpqjB8TWP580KfEI4R8RgHLjUS4d3USbTuERrIVGPprMg6G0egE5SeCoEgNfC7E9EE2y1lXAZiUdXgtMxWG5A+D3IeP+C7mpYJ/EwGGSs2QoH0MTPIW1rQdzCqhZAY8LWTBNlrg+jFnAzTjMlA2jSI9fKV5p8zKuLS0p05NHPP1w/LmmZ8C2tAsjvj7oJM6A9j4oLnbiGeTzRhzsTLsx2QHuY8LlwPa0kVHXh3OVXXxW8Ii
 2KEkcr2J
 h1B5nQtmrPbkPXnWh0Wfcs2tZhbIt/98dwlKeHIRHqd8fT5UeYUuBXtAQ3++s1Lq3DoatkqECmGONf8v1GLDSrmGv9QBRBVBvk4KvR3/8OX2p9Ic4UuxjD5y7jcuOep4fsSUp/Bvby5pvtcD7S0C1pWIP/FwPMy67DIczGMp7XkOCRbdq0jHKxVX1CIPiQyD/HfYFaplDa+kCLbhMUHwfUFX/DQmGeuDh//drVR1+FfOC7C9UjFM2b3qg23nt2eGZO8aJFCsOnIISrCWbzNvwfxKTRePta4h32jzCIg7h8SSPIRxUNcEEuLP9D1QZFBoZqlXQSzBipbiYTCrH0wc8WAtx/257Mb8bBICOW4K9kTi6pwjsqZgyRvwdBHGrbsv27NQ06lx1xYM7spFLB8Im9L25GO2ZkHFxpTtZ5yLMEhDVKco/4sSQbrCtUiej0CmPRItq
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

A real workload has since run into the stall this series is about.

Mooncake, the KV cache store used with vLLM and SGLang, backs each
rank's host segment with MADV_HUGEPAGE memory and registers it with
the EFA NIC, which pins it long-term. Its commit message [1] says:

  "under the default local NUMA policy every THP fault on a full node
   runs direct compaction before falling back. With 8 ranks x 190GB
   this made registration take ~38 minutes."

They worked around it by binding the segment MPOL_INTERLEAVE across
all allowed nodes, so no node fills before the others. That gives up
node-local placement, and a task that sets its own policy still gets
the stall.

[1] https://github.com/kvcache-ai/Mooncake/commit/c3fa13ecaf1038df933dcb784ff8ffe026381100

Thanks,
Qiliang

