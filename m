Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20787CEFCFC
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 19:37:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 781166B008A; Tue,  6 Jan 2026 14:37:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72F336B0092; Tue,  6 Jan 2026 14:37:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63AEA6B0093; Tue,  6 Jan 2026 14:37:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 50F126B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 14:37:00 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BA9651609AF
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:36:59 +0000 (UTC)
X-FDA: 84302546958.14.57F3C38
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1A892140004
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 19:36:57 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ag1bDF4X;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767728218;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cw2O2HwSvZcQkzhRTXcAxWt2qbyHngwH7swWewy0UI8=;
	b=LWOZS1vxO2+sdVRI22Nmxj34Cp8/mk8KbEkGxOh92nVaI0DBmO3rNbrwuzkkKHnPXDOlQh
	Q9Op3jCyWUot6OH8ufcISlzL3mxhRId4NMxof8hpkKGHj6oambu5k36k1RitA5KbZL1arw
	oV9Hw4PHDjc3RTtxv5Gi/GcD6KJbP/k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Ag1bDF4X;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767728218; a=rsa-sha256;
	cv=none;
	b=HHqwpq1mBDVlyzGmMH8RTyIniirEFY5BdLJzs1bjlKjl7PZeozLpH7U7nUTUMgxLLM4PSS
	nv0uMYtoaRLz8bv3Xt3hDzRpQ4fdbFlZNXQzC7+Iwy5ONM62CVeDTz2kyZNoZWcpCRvYfT
	2VGN2H2V7pMGoK57cOLeUYQvYVli+5o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D451941A4D;
	Tue,  6 Jan 2026 19:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164C8C116C6;
	Tue,  6 Jan 2026 19:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1767728216;
	bh=aX5ErCx74e37nAMgsGg4wnwmylSVnqj+pGJPEHPS6Vw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Ag1bDF4Xddc+QOPO1lE2eYtZg53Kw95IbRIng9dnbEd262GkFTAPEgxDrWUD9r/bq
	 FPz2e7CnWXV9/e4OiWlPTLRlsNhV8OQBVKqVj9+FQzvAngP8oQ4SeNKJL/TfRSz8Sr
	 tCvdTuIeY5KmZtKus8eRUWkM/moqtyZT40d9hUME=
Date: Tue, 6 Jan 2026 11:36:55 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, gourry@gourry.net,
 longman@redhat.com, hannes@cmpxchg.org, mhocko@kernel.org,
 roman.gushchin@linux.dev, shakeel.butt@linux.dev, muchun.song@linux.dev,
 tj@kernel.org, mkoutny@suse.com, david@kernel.org,
 zhengqi.arch@bytedance.com, lorenzo.stoakes@oracle.com,
 axelrasmussen@google.com, chenridong@huaweicloud.com, yuanchu@google.com,
 weixugc@google.com, cgroups@vger.kernel.org
Subject: Re: [PATCH v6] mm/vmscan: fix demotion targets checks in
 reclaim/demotion
Message-Id: <20260106113655.52d71d43595aca9296cb02a1@linux-foundation.org>
In-Reply-To: <20260106075703.1420072-1-bingjiao@google.com>
References: <20260105050203.328095-1-bingjiao@google.com>
	<20260106075703.1420072-1-bingjiao@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Stat-Signature: e84qfkpdf4ukdq6p73e8fioyruiiy1xp
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A892140004
X-HE-Tag: 1767728217-780701
X-HE-Meta: U2FsdGVkX1+mOdExj2SfvWNxGdj7B6SaMQ3eJapoRO8gJeO2aEd7CNiWbw7E7ekie41U856x4rU6pCk4upD55LW6JRbXNPdEP9uVBIBc/X+2OIJoQWDkEbcuPZXVEdWZA/3qtLss6yWl6zWz+Kow1zXC23AjzsIYreIb1Nq3ZxTZ2BdtunyG53b0Y5WGZbjHf7ePkSOkKf9dUPDdnZA0rBCnU02xcwK/awCJacY4HoGFy6i2wJ690lJ75dhjxHRY55An4BK/Lzc3VBrjFuRp6uvgHLPovYGHUj30qjkNb+Qu+vlbBFgTxfUtIUtSkKj0+aySaTGzrynmSS10MdcULdVVHcZYeKs3CPX+yGb2DGKbK8hSccs06frrfjTPeP/ZEan9p4lIU0Hb3euHx84R6hRDekYFXeyX4D+EEnwaf+qazUze99vdf5HVJc5Z+ruFGK5aBvXdlk4/6Gl8xwKwI8QaQywELOttPQ/RzVNDVzRQRqvaocHxjJ6IE5qLkXXHLXsK/ZjQBknUtMCrbCF5TJ14PV3nZyzunFZl3E+d6CL6WKnXKFyBzsVjeIULZ0fVtYhpagxe8YWlsZQr+/grOsMCtMrEGhnGfjoshUdM2WsWOti1VJxpiIg3JWHZeUyQs4OLU0ez0N/Z278Lqg2qseC7BhXNi0L9NAxJRfmxkKfnl1jFNBXwTBy34+IgzdJVz/jtoMzvuil0Gdk0p43r598hZYDAd5YPPB4t1jP6+VFXNM8OZjAbB/zMOUtxhcyljdt/xdNrFB55VEZqggNaH2gZ7XwV9Wkhl97PTP3/jr+L5ENHlUrfS+2i4xSkIsoVylVK4lzKALcbDXOJ+NT0T7nEYrE6/yn6+Xr3AsO5XFR/TTlK5KLC8sftUuQRLcpE+1N5B0HZENe4Y7s5beDK9d2k/XREem55Mj1qu4iafzw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue,  6 Jan 2026 07:56:54 +0000 Bing Jiao <bingjiao@google.com> wrote:

> Fix two bugs in demote_folio_list() and can_demote() due to incorrect
> demotion target checks in reclaim/demotion.
> 
> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to
> can_demote(). However:
> 
>   1. It does not apply this check in demote_folio_list(), which leads
>      to situations where pages are demoted to nodes that are
>      explicitly excluded from the task's cpuset.mems.
> 
>   2. It checks only the nodes in the immediate next demotion hierarchy
>      and does not check all allowed demotion targets in can_demote().
>      This can cause pages to never be demoted if the nodes in the next
>      demotion hierarchy are not set in mems_effective.
> 
> These bugs break resource isolation provided by cpuset.mems.
> This is visible from userspace because pages can either fail to be
> demoted entirely or are demoted to nodes that are not allowed
> in multi-tier memory systems.
> 
> To address these bugs, update cpuset_node_allowed() and
> mem_cgroup_node_allowed() to return effective_mems, allowing directly
> logic-and operation against demotion targets. Also update can_demote()
> and demote_folio_list() accordingly.
> 
> Bug 1 reproduction:
>   Assume a system with 4 nodes, where nodes 0-1 are top-tier and
>   nodes 2-3 are far-tier memory. All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Should respect node 0-2 limit.
>     # Observation: Node 3 shows significant allocation (MemFree drops)
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1
> 
> Bug 2 reproduction:
>   Assume a system with 6 nodes, where nodes 0-2 are top-tier,
>   node 3 is a far-tier node, and nodes 4-5 are the farthest-tier nodes.
>   All nodes have equal capacity.
> 
>   Test script:
>     echo 1 > /sys/kernel/mm/numa/demotion_enabled
>     mkdir /sys/fs/cgroup/test
>     echo +cpuset > /sys/fs/cgroup/cgroup.subtree_control
>     echo "0-2,4-5" > /sys/fs/cgroup/test/cpuset.mems
>     echo $$ > /sys/fs/cgroup/test/cgroup.procs
>     swapoff -a
>     # Expectation: Pages are demoted to Nodes 4-5
>     # Observation: No pages are demoted before oom.
>     stress-ng --oomable --vm 1 --vm-bytes 150% --mbind 0,1,2

Thanks.

I'm not confident in my attempts to resolve Akinobu Mita's "mm/vmscan:
don't demote if there is not enough free memory in the lower memory
tier" against this.  In can_demote().  So I'll drop Akinobu's series,
sorry.

Akinobu, can you please redo that series against tomorrow's linux-next?
it looks like it needs a resend anyway to try to create some reviewer
input.

