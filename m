Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37FE260A2635
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 16:55:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E00A6B0170; Tue, 20 Oct 2026 12:55:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 391416B0173; Tue, 20 Oct 2026 12:55:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A6D36B0174; Tue, 20 Oct 2026 12:55:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 08D526B0170
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 12:55:17 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 859281A02D6
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:55:16 +0000 (UTC)
X-FDA: 85343605032.29.1A10B27
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 23062A0008
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 16:55:14 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792515315;
	b=EyWw5/HcrthqO5cf1GxzRUa1VoIsIVdCa1MdyrE8PH9sx0By8hujNhazv6QjGp4Zj6VzDa
	bbTbBkiDzO3+C/2f1+TuR9JIgMHDGhgNtk0B0uQbjYorPeircv31shL+DpDDXpRadyUzVx
	QlOwRUqLJsL5REEBc8hh51TStCTJ8os=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of tj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792515315;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=74faLD1IaSIP2Z+00B1XcX8OSASYEQH3UHt+KZjsp+Q=;
	b=sV0Duwz1PPbSEqvdWgYDLyOq8IVAiGNWiBLcooPiYxFUa+pQHtydR3cyoRWjZ8e/iTj4xR
	s2RMJs4trRsxdJTAGt0ukVbk1oYqIb4vedwMhCchP60tKis/j9HlPJUfVqFX/Lm6JQGYpy
	946aLnlniJ4605yudlGDP9MFCsCs7HE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D4D2D6057A;
	Tue, 20 Oct 2026 16:55:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0231F000C9;
	Tue, 20 Oct 2026 16:55:13 +0000 (UTC)
Date: Tue, 20 Oct 2026 06:54:42 -1000
Message-ID: <7bcbfa61a8c69e6ffd81e97652d981b0@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, mingo@redhat.com, peterz@infradead.org, juri.lelli@redhat.com, vincent.guittot@linaro.org, akpm@linux-foundation.org, david@kernel.org, gourry@gourry.net, hannes@cmpxchg.org, mkoutny@suse.com, shakeel.butt@linux.dev, roman.gushchin@linux.dev, yu.c.chen@intel.com, zhao1.liu@intel.com, tim.c.chen@linux.intel.com, lizhe.67@bytedance.com, bpf@vger.kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 bpf-next 0/5] BPF-based per-cgroup NUMA balancing mode selection
In-Reply-To: <20261019064157.29885-1-laoar.shao@gmail.com>
References: <20261019064157.29885-1-laoar.shao@gmail.com>
X-Stat-Signature: j6ttpjn8dxedceywjxg1m3q9ifoyecdk
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 23062A0008
X-Rspam-User: 
X-HE-Tag: 1792515314-460248
X-HE-Meta: U2FsdGVkX1/zgsZMRdLyqbIiml9yAlZaQRPVVC0uD8SkqJYP9Mh11Yp3iK3tEo0Txx9ugxJfiMgRbwLv1K7kSQ/lKR2RWkPpD5LiFY5ats3CeOJVIUWJNUV6nz8Mtt1RoyncacWSV+g9jmxooHH5v4EfejC1T0cKki0FzQdMlVPzEuJhCN58bklnzhCV7CAT3iXVRPKd7Z885DjQmrby1p4L3pKqvVsHFex9ZXjcRKQCrTeVOpnQH1fThH69Q7expaZw7RoofSBbjVtViXsgI0/aTeW/jBFUyENs9PQY5nCeMuLkvExF+jtYxDMlgx71Ggri9puEs12TGTO0ikbRsm2tDq/eAIxZZWN6Sk9zLqX1sPk9+bUZJ7shvjrrVzlNghG4wSS39JGndlwRPWuCfJX0eOgIxj94l7YxUInEz/buuEG9LYixAFYxo9YWHcowceTA7InK35cKNtFntLX/bPWWRVXZdyoEP0ZwFohsSVqO+RJpGNOmwe16PflewEKP/ZwuWmxt84XxUG6nO3FF5V4+BJCkwbT3enCAuFQNmLZA6qMkyOPJnFF3uBAUbDqeu5AdiTK0i48jHEvI8R/fGgUv1JYpLM4Ufyyu9S36PE+IsSfrTCYgky3qDdi3a/6kH/RWiOuZL3OlAdrMwl2gw+mj1T0cblOkKErvHZ4+VdPo6FDQknkG9s18sOqMcwHtQZRZbQmEv4oMLkoePWo04S1k2LxOR2xQ8D+kgpnW12x9H426IG4xAfR6spokvSOSMLVR/sZ983rVOvsfct4R21hMjp/g7cMKLixnVniagpsXkzTu8j622l9jx6QirHXnRG1A/0CkW6jg//Ed5T/3vlBHr+EKaCDho2aDF0Bdua3YLbeY9hnj9zA+DN+5dfjZNehAPZ6FRgZuVSoCpr5vCAArmJtP+uQhYvHs5Mzd56cilXIjWuMODWzYDAaatOb6gpHTVQNmLEokYPPuoEo
 AaFnCx1Q
 BsZ2MNsgdqOnTDLiuO3vbUHStD3IJvN9EbKt2QHaWE4L9qFScq0UIeUGp+A15fdlAB+XQ+2NT3I3e62QlStZQQkyCGZvaJ4NluNduzmTzWRabprBYErYbLo0su+qAr3yN1mwBugBUaLIQZgnqDCZQqUr6Yk9yL7ZKVyGad+M4JIr896372cfgj7ALplrHlRua0xw9NKv0pZxLWZcO8kITgo8EeA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Hello, Yafang.

On Mon, Oct 19, 2026 at 02:41:52PM +0800, Yafang Shao wrote:
> An opt-out wins and binds the subtree: a DISABLED request anywhere in
> the chain opts the cgroup's tasks out entirely. Otherwise the requested
> bits OR together and the kernel reads them independently, the way
> kernel.numa_balancing reads them, so a combined NORMAL|TIERING engages
> both modes. A DISABLED request only speaks for the cgroup's tasks,
> never for its memory, which follows the remaining requests of its
> ancestors.

Can you explain the reasoning behind the basic design decisions?

- The folio paths resolve through folio_memcg() while the task paths use
  the task's cgroup. Why isn't the whole thing tied to memcg?

- Why do the task and folio paths combine the chain differently? DISABLED
  binds the subtree for tasks but is skipped for folios.

- Some of the folio paths already have the faulting task.
  should_numa_migrate_memory() takes @p, and the do_numa_page() and
  migrate_misplaced_folio() checks run in the faulting task's context.
  Why not use the task there?

Stepping back, the basic design decisions don't seem to have been
thought through, and the descriptions restate them at length without
explaining them. I'm not the best person to judge how useful the
feature is in practice, but getting this version into acceptable shape
is likely a lot more work than having someone who knows how to do it
just write it. I don't think it makes sense to drag this out and force
it into shape over many review rounds.

Thanks.

--
tejun

