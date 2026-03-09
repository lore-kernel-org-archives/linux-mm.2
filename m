Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BFD4FCC9A2
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 23:43:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C53FB6B0005; Mon,  9 Mar 2026 19:43:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C01696B0089; Mon,  9 Mar 2026 19:43:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12A06B008A; Mon,  9 Mar 2026 19:43:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 9E6436B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 19:43:39 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4F7351B7728
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:43:39 +0000 (UTC)
X-FDA: 84528154158.07.90D98F7
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf24.hostedemail.com (Postfix) with ESMTP id 91193180005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:43:37 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nlLDsKr2;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773099817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/iFELzGhWdH/eNtU4E6wcj10oGbw7AuRjfLOotw9uPs=;
	b=MwYJqQaq9dDdLc4gELEs9cuPIyYuHpb/7tDhlsXWcswq+6FgC77CyEPoUvDBYF0QFKgp9v
	UBaN3ca8MxQLI1kNxyF7LEgvMQ7fpvbgIpr3VxWg7Sf926oImtxgtbPvkkWp8FXGc8iy/q
	55zKZfIx+P08c0k0wI2DeGaPEy/qH9g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773099817; a=rsa-sha256;
	cv=none;
	b=SSLewG2yHC6K3eydc5GMp9iA3qPq2//HLCxBrUlHcnKfaF2gHwKzJsgioZZdScHdkK2ShM
	w/ugOtUH8TTFsXuyPbMFlHsgVAenhF7yVxyilIehMRrs4jBJUfZ4Rz/mH4mR+CBaRjKSA9
	ugP+SsUNwU8j4f/saqVhx/qb+t91INQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=nlLDsKr2;
	spf=pass (imf24.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 9 Mar 2026 16:43:26 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773099815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/iFELzGhWdH/eNtU4E6wcj10oGbw7AuRjfLOotw9uPs=;
	b=nlLDsKr23aZgU6oEj+eh7RNxKM/IBMFZieSL0bHjkbDfQ1ibcGB5RsexzpkRRgx0zyPbH3
	TjvFim1kvYAq+v1OB8H3VD7aPn1YRCwHyIo8HbS1X/Ua8oML4fUNu61irhyDVhfkurqZey
	fYpzyx+nDJrHQsJPCkWxBlj95E2LwCE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, mhocko@suse.com, 
	vbabka@suse.cz, apopple@nvidia.com, axelrasmussen@google.com, byungchul@sk.com, 
	cgroups@vger.kernel.org, david@kernel.org, eperezma@redhat.com, gourry@gourry.net, 
	jasowang@redhat.com, hannes@cmpxchg.org, joshua.hahnjy@gmail.com, 
	Liam.Howlett@oracle.com, linux-kernel@vger.kernel.org, lorenzo.stoakes@oracle.com, 
	matthew.brost@intel.com, mst@redhat.com, rppt@kernel.org, muchun.song@linux.dev, 
	zhengqi.arch@bytedance.com, rakie.kim@sk.com, roman.gushchin@linux.dev, surenb@google.com, 
	virtualization@lists.linux.dev, weixugc@google.com, xuanzhuo@linux.alibaba.com, 
	ying.huang@linux.alibaba.com, yuanchu@google.com, ziy@nvidia.com, kernel-team@meta.com
Subject: Re: [PATCH v2] mm/mempolicy: track page allocations per mempolicy
Message-ID: <aa9aDGwk8YteaEob@linux.dev>
References: <20260307045520.247998-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307045520.247998-1-jp.kobryn@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 91193180005
X-Stat-Signature: 7kidbwzifhhieo75t43duwsta6qshh1j
X-Rspam-User: 
X-HE-Tag: 1773099817-133784
X-HE-Meta: U2FsdGVkX1+cozLaouwYevlyNghzYNzVPIUKU8dE0McLNlFA1qiB7vQLpJnBnQf9DruC6ZTznVUyECHew3onccIRKFUeSH1GZTuzFHqpxgcL0Xj7FAtYHVg/IndR18CDfz2O3U9DEX0peYTNt8qAmszq4OnI3gn3r4zGSai/Ior8C1R0FbUKdY8FzIrvSt6gOoLfUe/SJ4ApUtb3N54vbpxjGIhLdqPQ00LH1WSrbppQf1VwSkFiVymmT79AZGILMNYBMdu03YElX/Yud+EKANCaPGtpM7iSgIsCsts/crYDJFUqyON0iJleTM2yTCn0enYbK8+rYHqelGesxKA8ChaWS/Sgd+WdGYB7RKVByqlLqo7Hp42Uwf6q+3zdFyQtDHTPTrzWa6oPWKB129K7scT3gTB863fFHhh6aT6hwWTSLYw0IugBFoZ6TY9bKJlt341FX61u22wL71Jd5tw7Ez8Lbd7CLxKyj/6qgylAtHiNO/be9UiaK1VuRrDT2nqYkL3X3BTKEwattJYYOVP9dQ6PN2WgtZ9r1Zx33Q+0ZYO/e11d0MUFX2Y9JEUobr/gphU+NikUyERRAafBAV+ENiFuAHhYQQj6qVCPgJZaCdB4vZhVtEiSZTtqDitXrcFRv7HFVBawFUItx5YCEKay3Fmc9wRmYaJyzybD6W5v9Tr+EBSJzGEj2xhR04aoiW2F6X6y00dWY/STfO2dGv8F7V2aAHQnkd87TXg+2BFUirVrn9DJq8vcURPDlDl6/wN3RvknyER3ZnSnCcSxZ9zHdcqvPyNoU2Yv0tyHAghooP5ABsYRzhoDxQBlBrqomePe28tB2DTU7PtlM+SUlBJb/VgQKITAxKw/84/QLtdoYcftK/E/eQvxJLXLyN3QJzr4FC2+N85MAC5kxwgTAuDTBarvrizTAol0QwQSLZA7SmaFIQzfx9oy/HFRfD3M9AtHKLdiEV3+Y+gc63ErMfG
 EaClXcqw
 k9sYDFynKRZlMbY3fUobz/MxHMxuftfKz7TqctbugfhA9lxkisEHfBxzhY3mdC35mZ0vwLZiONt3xE89KtSBRhBEktfiOx1Wl3L0JYiYPzhYJKFsDs1ARzQQDpjDoMs5wZUhjghv+3GJdH9nOfoSF/dpTMHI8iKXhISK95Iqjl1r+wWskv/n90xe31fv8vPY6EC/tdOYiRNhFpayfeo40Nqzg++SA7P22mOaQ8GTIHdiUYRRLk/VpYuEVXTYNk0vcSkdIAtfnZk9l7bKiyewoowFfula9y90df9jz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 06, 2026 at 08:55:20PM -0800, JP Kobryn (Meta) wrote:
> When investigating pressure on a NUMA node, there is no straightforward way
> to determine which policies are driving allocations to it.
> 
> Add per-policy page allocation counters as new node stat items. These
> counters track allocations to nodes and also whether the allocations were
> intentional or fallbacks.
> 
> The new stats follow the existing numa hit/miss/foreign style and have the
> following meanings:
> 
>   hit
>     - for BIND and PREFERRED_MANY, allocation succeeded on node in nodemask
>     - for other policies, allocation succeeded on intended node
>     - counted on the node of the allocation
>   miss
>     - allocation intended for other node, but happened on this one
>     - counted on other node
>   foreign
>     - allocation intended on this node, but happened on other node
>     - counted on this node
> 
> Counters are exposed per-memcg, per-node in memory.numa_stat and globally
> in /proc/vmstat.
> 
> Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>

[...]

> +
> +	rcu_read_lock();
> +	memcg = mem_cgroup_from_task(current);
> +
> +	if (is_hit) {
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
> +		mod_lruvec_state(lruvec, hit_idx, nr_pages);
> +	} else {
> +		/* account for miss on the fallback node */
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(actual_nid));
> +		mod_lruvec_state(lruvec, hit_idx + 1, nr_pages);
> +
> +		/* account for foreign on the intended node */
> +		lruvec = mem_cgroup_lruvec(memcg, NODE_DATA(intended_nid));
> +		mod_lruvec_state(lruvec, hit_idx + 2, nr_pages);
> +	}

This seems like monotonic increasing metrics and I think you don't care about
their absolute value but rather rate of change. Any reason this can not be
achieved through tracepoints and BPF combination?

