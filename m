Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C820606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=sVxs5SaD
Received: by kanga.kvack.org (Postfix)
	id 1FFE96B05BA; Sat, 31 Oct 2026 05:28:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B7256B05BB; Sat, 31 Oct 2026 05:28:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09FF66B05BC; Sat, 31 Oct 2026 05:28:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E11296B05BA
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:28:11 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 72E9780873
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:28:11 +0000 (UTC)
X-FDA: 85382395182.15.DF3F058
Received: from mta0.migadu.com (out-77.mta0.migadu.com [91.218.175.77])
	by imf11.hostedemail.com (Postfix) with ESMTP id 59F8840006
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:28:09 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sVxs5SaD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793438889;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/He75rqZEHTrbQuKFrcjCckncTUr+jB2aL3GERrJXuo=;
	b=gyeU3zCX5yK94W+dX7xFkQ0MYpGicLXSrFwPLUIpGp4712rKLmKJOuLn/ZCouFMOpMbVj7
	VxEJVDcTwKmxqJVwmfTpiZgwp+QZbAN8hkJT6Yfy59l2h1GCmA4xKMOdHmHo13yjUmGvs2
	pCdQiqBBxspNRIIjNGhp3htpMcacMxQ=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=sVxs5SaD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.77 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793438889;
	b=IpgKMnl/VRL0iff4ZU6FzTIwVeKp3k67/ThrpcmTQ2xNMpMaAPs7NYWlTgXt1xe/9xFt9s
	SlH2ffglVTpjr8O6vgf8WDpJayir8uiQhUMQ3INQ1uomLQAa6KeEs6TbpUtKa7hNg7nL+P
	lis1IagmKyEN3Yt7jYl3dyoCTtzekk4=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=08Ba43Ng1QTJoClFmEOcfURkhCB+iyftKxXyUWNmLKg=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793438888; v=1; x=1794043688;
 b=sVxs5SaDkDBa09uTFu4hFJOaqrtNtfEPrN2fBpSuwy9ko181eiquYUD8AOWi9trGcmunnpcx
 sLJzJIJ+JB9/1wP5f764vUWk8rhW4KYWW1Qfb0Kx6k3KcUZKmeE4KbhbIDn+wtMKR2i8l7yWZgt
 o5KYGeBJItZdvSCZKs9EPhTo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 034d958c6540cbee;
	Sat, 31 Oct 2026 09:28:07 +0000
X-Mizu-Trace-ID: 034d958c6540cbee
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.12\))
Subject: Re: [PATCH v5 2/6] mm/vmscan: move vmscan tracepoints to a local
 header
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261031090041.58574-3-ridong.chen@linux.dev>
Date: Sat, 31 Oct 2026 17:27:45 +0800
Cc: Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Dave Chinner <david@fromorbit.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Qi Zheng <qi.zheng@linux.dev>, Kairui Song <kasong@tencent.com>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>,
	bpf@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>,
	"open list:BPF [MISC]:Keyword:(?:b|_)bpf(?:b|_) <bpf"@vger.kernel.org (ope>)
Content-Transfer-Encoding: 7bit
Message-Id: <9F0BED6B-4992-4F67-A8C6-D9550FBCEF22@linux.dev>
References: <20261031090041.58574-1-ridong.chen@linux.dev>
 <20261031090041.58574-3-ridong.chen@linux.dev>
To: Ridong Chen <ridong.chen@linux.dev>
X-Mailer: Apple Mail (2.3901.100.1.1.12)
X-Rspamd-Queue-Id: 59F8840006
X-Stat-Signature: dqm3h9kq3sozdqzzydpwiedbtzrpukw3
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793438889-578942
X-HE-Meta: U2FsdGVkX1+TWKqVa7rA38IhERGWNh6/0SMf5OW6IY9k8ox54abqEovzW4ovNyrsXWowhHqyjaVz4HSdscAEOTYcQ6H4qomaabpGs8yRRy3DVjwjL5CjYAbg3yP9qWBlCXaJ08Vq/HkQWzVY+V+5l9dtF2F433xYLLK4v+lEv8aoXHTOYVLOUmurFztCrS65KEckdj04F0h6TGQiya9rRTSeV4Qz88/uXv6wG0kaltVrc68kqb7HwqzLTxZJ657vuGUIOhi2rnS0ICyYQY1Fg5oZX8aHhiiyjoLU3Noot+kkjPY5k1FRhum1YdVtDLNVPK2wL1Q59EURtaccacQbKOi6VUa9BE++53At8Ty/zcBfPfL17WS1sNvWrNxlKqdyYfkqotpIewDLD2dGa9cwEw9cYGINe3D7Y7zetU3F/7FyyJv1piZDkH0TshYEbO5YFneh0Uf2nCzcuFUBz5vBxPxLWDKwY63LEzdauSO5Hk0T2sZYpy7q96i3AOXfvqVzln73keQ9NOuiAD/ijeFY+zyPR8pRlqa4WUFIEQLdYeO4oB3FIQTCSVrcV4cVL69ZV38RakivW9/RbfKe50WeYEdjvFcdfGSEl1gDuIFf8XW5A25eA1eIja/5v3XxTEcJ48WpqrMWDwEsce3+H/+EhUrVsSyy1PwZxajWdZ05F5Bhp85cll+SUUeZt/Gaz81X0F/IU0+/yuyq7MMp2QcX9iEtBTTBD7g6wfegwplWPClLstHIjh7gEI9nIOoE/MMFvWle5kEgPnuz5S7c+BtKj5JGvQx+EB3BtHpXpDj7i0VVoxrQ0/ff1KIU8YLC8tCF8UfULHjzr59YWo32oxL++v1bbiNGvKed8l0FGjNBwXCo0cF7VweWkIYgpMjmTtsxojqPM9k6Mb/P6KJfxTn01LVp7M5MxHbYAgBZzo0XHImD9Nc8OMyLJXJr/REyCyC1Alr5B9JVNdx83BaxmEt
 s1WuFbHu
 /OGzljXSdQAXDh+KLVPTtHYppXxbrN+BV/25BfK+9O1CiBv3PvKF7hfr0kPs/qi8jEv+cEVU42+BSborPPqpSMVJV/aexIqM5Tjke3Ag0RAzRNLjalchJS7CnK2HQCaTJd513BPoICm6mAuuTjNIZL+Ug5RhpJPwQ8cB/R128nAqiJf/6CGXMAfTCFuqs3L4OS/bSLHSruJcqAKd34EuT3driFP8xPJ2NsI+y+sneMaHeAc2wzgpl7agFsJdtxBp/HJPhYxiZsjmT1VewxNvVyHkEDhaLYaWIzrHf1nGx3lug4mJQlpEmU/fg2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Oct 31, 2026, at 17:00, Ridong Chen <ridong.chen@linux.dev> wrote:
> 
> From: Ridong Chen <chenridong@xiaomi.com>
> 
> Move include/trace/events/vmscan.h to mm/trace_vmscan.h so that the
> tracepoints can be extended to reference vmscan-internal structures such
> as struct scan_control, which is not visible outside mm/.  This mirrors
> what several other subsystems already do with their trace headers (e.g.
> fs/fuse/fuse_trace.h, fs/gfs2/trace_gfs2.h, fs/lockd/trace.h).  As they
> do, set TRACE_INCLUDE_PATH to "." and add mm/ to the include path of
> vmscan.o, the only user that defines CREATE_TRACE_POINTS.
> 
> No functional change.
> 
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> Reviewed-by: Barry Song <baohua@kernel.org>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks


