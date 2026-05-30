Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C93F5CD6E52
	for <linux-mm@archiver.kernel.org>; Sat, 30 May 2026 01:24:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160386B0088; Fri, 29 May 2026 21:24:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 111B86B0092; Fri, 29 May 2026 21:24:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 027256B0093; Fri, 29 May 2026 21:24:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E731C6B0088
	for <linux-mm@kvack.org>; Fri, 29 May 2026 21:24:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 915E21A015A
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:24:34 +0000 (UTC)
X-FDA: 84822341268.08.BE045A9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id E167D20011
	for <linux-mm@kvack.org>; Sat, 30 May 2026 01:24:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7MNhqe+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780104273;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//Pa32naUxmjScgI2Kd3HsHRQJ9KXrVWN/zHAstPObM=;
	b=QCvSATvHqQMywrm97AsQdMh2I2/ClYQjifed2UNqjlkvGAkSWrH4JOgX168Fwr2rL+l/VK
	6wYuqm9jOEWZUX5hpQU3j02f6t7vIu2Q7AWJMRfWZsPNPUMQWnU40LKgVxjerGUTteYGZQ
	i6kkfj4piEJRrSK4YxYKmSbNcDUlylk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F7MNhqe+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780104273; a=rsa-sha256;
	cv=none;
	b=FBPaC01tuj3U4FSuuGY+2l1YwgLcaJkfBXPwKTuzZEFyanCUcnzG+SEMJi06uRyKrtY6Mc
	8BrRIjshP4YmkEP4toqUTBxzIZWqSXEKTXL+o4HhCNIxFXLoiuwS+JKizPmaSXiXjtXQZL
	igBfsy2+GjaszBt913TAzkFayHSYcwU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AF57C4093F;
	Sat, 30 May 2026 01:24:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0359A1F00893;
	Sat, 30 May 2026 01:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780104271;
	bh=//Pa32naUxmjScgI2Kd3HsHRQJ9KXrVWN/zHAstPObM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=F7MNhqe+0Chu3B+AvEvjUu6v/Z/wPCHxWkFcmVFSzR7y0KprtUrixtAgwSjqlSncP
	 17wExybPZwPr+UICr9SQHV7lGdEbwdK8Gb25DsoMIXKZvNe/13nsb2jIo9HOpJjCA+
	 8FB+plkEkrQmZsZhpWPm24iqknsf0vGKdYid2c0QO81NFgA1DqBUzA5AYHzog2ZrZV
	 wmMtRvsayeFLK2F1VjvdguIfgME68J2Vm8Y9DTZaIJ/1ve3JzRhFv5/e1vpjgh7NAs
	 nHU0vjrFgtS2A30v9gZTqKDIweQRlw84bSGM5V7y1HBKCk5qOqAT5vlJotvK/djUfI
	 G3sqdHBY/s2Mg==
Date: Sat, 30 May 2026 01:24:29 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, nphamcs@gmail.com, 
	chengming.zhou@linux.dev, muchun.song@linux.dev, roman.gushchin@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v3 1/4] mm/zswap: Make shrink_worker writeback cursor
 per-memcg
Message-ID: <aho7nepN5jZtKmef@google.com>
References: <20260526114601.67041-1-jiahao.kernel@gmail.com>
 <20260526114601.67041-2-jiahao.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526114601.67041-2-jiahao.kernel@gmail.com>
X-Stat-Signature: zrfy8ysenaphxyyzq1zga1jqn11eiep9
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E167D20011
X-Rspam-User: 
X-HE-Tag: 1780104272-418916
X-HE-Meta: U2FsdGVkX198AcXQN+MF94OkT+bz79rbe517VgIF+YMJTj1cV11BPGw4zgIKeDQJOhPaqA4jdMZ2BghpRUz0mKgYy+PpuRB7yg3ERkqZgobKxEzcGfuoP/vmGU+D0Kz9XrjrTu04fclxCXq9o8m/yFX1EBFsM2/NGvXNtWCVGexpP0CoTlNJPtsNHkHHQ2Czuk6i6bn7G5ShFmRAR3qvG9Hw/bW8WZKQ9WnsxUFMFu3PPzyzRvgmHfZqT2Xu8LUdLB80AJ8uGe92SXU6oojF4k+F2h1mJPxHuxNjfJ+drGCwuA5nFqQ9fTNFh4s87PZ5B4QxgcjnyjbtyTsDY9mAeJrMrqpgCKQC6NhUNQkybqsAOOQhYjFR6+t8C96Yi08f3LylWqgYsgHkA7w2IY5RZkWDxNqpJu01Mlm4Qq+MaDn3O7s05kZNSswOzN5FpiOOD1hbtoLNnMhJeSKN7URupbIgzH+S19NZK0GxszDuwSWMm3KL0ZKyHdl8QtSbWrWwgir7Cvrc/aNuWW3kNmVVJaP4hl7T77zHgWAdRvOSEvl93H75O1UjhRGLwQGXvA7dX2soa6DbChhJB92TLwsA1Q5d3eRehW8aKlLciFl8xL/86C6ym+37k89mU9BNSH08QQqb41Njhw+iGYOYk4qkyQ681nH0iGTylVrCSxljEq3mVZw1yyF+XCdhzNbb0BgwtL/F2hyb7vLoJehz9gNcdwXDLqCF4i+wsVDBAPoLZvcWsxAc1aqLuAWG0GiZuaAQP5x1K6qDLu11H9rPZfa6azsWmb9G73hiZ9MSUcMwUEYkIIMEnKfcf2A8WoN2njfK/3C7EuS1oCNHmmKsDDa6NSEXEfoVxny55uHtRp2rUpcp4kQlhHYE/gMb32m464Fn9Y2nOjSVJ2S19fDniYVcPZ6hW27VyJd1yf6xJvIrwUfzJ060sQGAw136/OycnD+AsjavdxrLBjT24lZ/9RT
 HKtT/Kda
 vl4OssA1Ba/SsR0eil0yqN/atFbflsrNoOWU3itkzSh9SDoBduY3YhMnE1G9sPbsfQDdo+GPdYZfzuYO3bdycsDmY/Q6hK8/A92OVrBuMPSWJCpTZlylB0vlTfP0NxmkzC40TXcKzZUz0a977Y6VMLgL9PqAQLlysaKhlLqjsAZLj9sUk6XCFIZIcmkG274pTSJGl4kopphX9wWQ7MKwaGoid8eieslkDDLv+66n54oIU8RzD/Vjg+trzgpIyqggizXq2Z6YMMfHx6R/H/tKOgVAb9JebkanDup7EYRdsMsPQ4DG6K7AyegJFTZtHx4EYlEdqnqTsf1Tmg83z3H8E5NpFwsLmzDoWQHzdG6c1pjexqR84bMIPgiglD0PPH8hpiDTaG00hbl5WPPFO6u03Q8si30v3HQiAG67Y798YGX/SINw1aw5Y30OfBBmDz9MFSVsNpIkBwUOtGmdbVvzUVB+wCw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 07:45:58PM +0800, Hao Jia wrote:
> From: Hao Jia <jiahao1@lixiang.com>
> 
> The zswap background writeback worker shrink_worker() uses a global
> cursor zswap_next_shrink, protected by zswap_shrink_lock, to round-robin
> across the online memcgs under root_mem_cgroup.
> 
> Proactive writeback also wants a similar per-memcg cursor that is
> scoped to the specified memcg, so that repeated invocations against
> the same memcg make forward progress across its descendant memcgs
> instead of restarting from the first child memcg each time.

Is this a problem in practice?

Is the concern the overhead of scanning memcgs repeatedly, or lack of
fairness? I wonder if we should just do writeback in batches from all
memcgs, similar to how reclaim does it, then evaluate at the end if we
need to start over?

> 
> Naturally, group the cursor and its protecting spinlock into a
> zswap_wb_iter struct, and make it a member of struct mem_cgroup to
> realize per-memcg cursor management. Accordingly, shrink_worker() now
> uses the lock and cursor in root_mem_cgroup->zswap_wb_iter.

If we really need to have per-memcg cursors (I am not a big fan), I
think we can minimize the overhead by making the cursor updates use
atomic cmpxchg instead of having a per-memcg lock.

> 
> Because the cursor is now per-memcg, the offline cleanup must visit
> every ancestor that could be holding a reference to the dying memcg.
> Factor out __zswap_memcg_offline_cleanup() and walk from dead_memcg up
> to the root.

Another reason why I don't like per-memcg cursors. There is too much
complexity and I wonder if it's warranted. If we stick with per-memcg
cursors please do the refactoring in separate patches to make the
patches easier to review.

Thanks!


