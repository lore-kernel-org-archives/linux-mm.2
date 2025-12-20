Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32050E668BC
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 19:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DD226B0088; Sat, 20 Dec 2025 14:20:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 561B96B0089; Sat, 20 Dec 2025 14:20:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 463096B008A; Sat, 20 Dec 2025 14:20:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 370966B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 14:20:49 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DE1FA1A0615
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 19:20:48 +0000 (UTC)
X-FDA: 84240816576.12.E2B89B6
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 4149B40005
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 19:20:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HG8uF931;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766258447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uoVI/xpGf5JHRjd3/J3F0l2xqOiQIGhnWiT4QFOt1uc=;
	b=cA3GrxgP4/oG+iclTr4CPHBL7e2ISTTO692EDJDmgKY38+qxsr0dAfqKd4U4cVqJc02+nu
	CZWUsiVQKPjeYNxkJlTPHYVahqr6EJUeEcbR+c/fyTb7+JZXIziSH1KXR4mTJSzDJwofG5
	gOVsZXfIdQwym16x3RK04I2JOOsZDno=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=HG8uF931;
	spf=pass (imf01.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766258447; a=rsa-sha256;
	cv=none;
	b=XZFeUW6f+Bvg5BfvMzsUogNGGmF3lksZg3//8rFDq45/LcVtlLMOaKwU3c1Oymnn3/Ho94
	dhTioCjGlf2ALfTkM9DiJcdRNo8EFJfsZKVpssMvj83WWCZQO5YXBgc7qSPjIRyRT/+yi9
	eUGrNrGM6CUrUbtsVqoFrArB8Z1sCH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F61C60053;
	Sat, 20 Dec 2025 19:20:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E5CEC4CEF5;
	Sat, 20 Dec 2025 19:20:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1766258445;
	bh=kKhMT8Mje8TVBJP8X15PI4OV/2bCI5xsEnfBkKi5YAk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=HG8uF931r6uX5DDIN5X1v3f5o18hAWfxLQDvcpUMMZ+9KnJTkWSPkupSB7XXufZK8
	 /PwUEV8huMAKinw0AmteSO9d6pqfecvHhqDRDNrWCBl2atbs9KQZ3WCFhubs159V1F
	 jpYqJXAZ5IvRodv++3xFsYZWZQOvNSwReWNB/Xtc=
Date: Sat, 20 Dec 2025 11:20:44 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Bing Jiao <bingjiao@google.com>
Cc: linux-mm@kvack.org, gourry@gourry.net, Waiman Long <longman@redhat.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt
 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, David
 Hildenbrand <david@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
 =?ISO-8859-1?Q?"Michal_Koutn=FD"?= <mkoutny@suse.com>, Qi Zheng
 <zhengqi.arch@bytedance.com>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: respect mems_effective in
 demote_folio_list()
Message-Id: <20251220112044.ee858d2160f819e181598ce1@linux-foundation.org>
In-Reply-To: <20251220061022.2726028-1-bingjiao@google.com>
References: <20251220061022.2726028-1-bingjiao@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4149B40005
X-Stat-Signature: 9e4cxsme5kwyc6prachmo91ywybugxn7
X-Rspam-User: 
X-HE-Tag: 1766258447-869554
X-HE-Meta: U2FsdGVkX1/EBTiGZQ0Qa2b4Cd622c6DSuSwiMT+5U3CK1HTl2RO6R1BV82CyKjP7IfxrJL9BB8ubOkvcVN82H8mujOxrmq029yISl8HBTLgvCh/L14GFOajC6CRmQTVgZw95daKUSs6CVH5+9BZXOVogtcheCe0TgJDZccdPu2lUjRWsUeJK7vz4L9R3qnrKRpKe0S21s/+LiHHVod+DtNlZ8QhsDBzRKg0D+6AMejor/XJfTghZn4LPoLk5GVkUrexHHusqRnH26rKnM+q5QiNceqJRTIax8QZe2XVgcxvgLwsiA6Vp3SCsGOX79tq+6EB+08lSkjxkv0xW+FgRzS7qYV/3Ml3hJQs01z1ufw1vhdq4IsPxB0iocX1+IC/CbfRDawOFD5y9pefOE56zXjaLcXaKOIm45XDkaMH5re1PI8mv1R5q3P0lkDBbZFq9Aq3FTudpN+eKcBcEkunsh8aD6z6LP7pXWMu+hoVjsTLNR00jiiugP6COJa+Ik8gU2wLIYymTr/C/9FMneaKZfalv+Z/kvV7oXAds83RagIwoHCxjqzRsp6RIfJ16kQJI3a75kVU6LX1i5b79huJZk3cfL3lrqAj0f3nbVRubSA0oGSbRIE0cYfhk/iDrTIOEl+3OP6/1NEb6S3kW0L4a5jtk98HKhP+6tBN6dhmfuDkOMGCy/WctUpLuzj1RWsZPFgG38AqVjz/ul0QHmPH9HlFY6gyInbnV3Tj3/8Go3bqSdEgqjIrdUHnvx2TccsyliRNc7y8QluuMvdujJubIab8x44DCwFGHIAmNuVAoFKyoEuLGncS/gGCgk9iP6rRSy9qJKPmsLzzF6CUBgSi9Z+hmdRwlNqTkobx3o4JvYyvswgqi0Jg70GNR0KuRNHhFE0WWQek1DphkKXWqncz7ZTDvGmIL8FuYaJ+WpGMzCJzLc5ufXR0U/sYFnrIeIWKa3ZirHhkinv/xDXRdqh
 E0op2Z3w
 HOsQ58UjYO5xoBG1K9npa6J/u8CKP8fRUGExxoVn5aw8kjWENArZijAHb3KAiC3Rc8aNsMPnysM/AKHzW3hGJiLjtrJUtYvqlyqV89hPqOJ2JHhFkMvPGm2O1HFN8py5tkauG1s7oEjf/TzaXT/1M100fvk5UwdDzLCUgZhSs2DDgQD6W0KLfrAG52/CtZ2u+kojp2azqstHPNCFwzbW8ZsUNowfcusPzSuHMg+fYd9FrP0Lxms1/0ita3ZqTlNQXPvz+jQ2z0gZmZIiyuKWCqaUgUzugvrdSu8qHDrt1D9XOJ4ilwDG7wO/JJ2O+J11l43UpNij+bUo1zCpfCoE87a0LpA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 20 Dec 2025 06:10:21 +0000 Bing Jiao <bingjiao@google.com> wrote:

> Commit 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")
> introduces the cpuset.mems_effective check and applies it to
> can_demote().

So we'll want

	Fixes: 7d709f49babc ("vmscan,cgroup: apply mems_effective to reclaim")

in the changelog.

> However, it does not apply this check in
> demote_folio_list(), which leads to situations where pages are demoted
> to nodes that are explicitly excluded from the task's cpuset.mems.
> 
> To address the issue that demotion targets do not respect
> cpuset.mem_effective in demote_folio_list(), implement a new function
> get_demotion_targets(), which returns a preferred demotion target
> and all allowed (fallback) nodes against mems_effective,
> and update demote_folio_list() and can_demote() accordingly to
> use get_demotion_targets().

7d709f49babc fist appeared in 6.16, so we must decide whether to
backport this fix into -stable kernels, via a Cc:
<stable@vger.kernel.org>.

To make this decision it's best to have a clear understanding of the
userspace visible impact of the bug.  Putting pages into improper nodes
is undesirable, but how much does it affect real-world workloads? 
Please include in the changelog some words about this to help others
understand why we should backport the fix.

> Furthermore, update some supporting functions:
>   - Add a parameter for next_demotion_node() to return a copy of
>     node_demotion[]->preferred, allowing get_demotion_targets()
>     to select the next-best node for demotion.
>   - Change the parameters for cpuset_node_allowed() and
>     mem_cgroup_node_allowed() from nid to nodemask * to allow
>     for direct logic-and operations with mems_effective.

If we do decide to backport the fix into earlier kernels then it's best
to keep the patch as small and as simple as possible.  So non-bugfix
changes such as these are best made via a second followup patch which
can be merged via the normal -rc staging process.


