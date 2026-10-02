Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 342ACCA5FD4
	for <linux-mm@archiver.kernel.org>; Fri,  2 Oct 2026 14:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E33E6B0088; Fri,  2 Oct 2026 10:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BA756B009D; Fri,  2 Oct 2026 10:21:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3D0CD6B009E; Fri,  2 Oct 2026 10:21:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1E9006B0088
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 10:21:46 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B2A8F1C39D0
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:21:45 +0000 (UTC)
X-FDA: 85277899770.08.6A975F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 110112000C
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 14:21:43 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dSj9PA/L";
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790950904;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+f7gBbOphql33Q3z9qijzYQyChgApQkTFAi8r/69YSE=;
	b=7dSGAKg6ADviicdynS2mdfOAvLBJVHPE0bgzI3Sv6cB9+LS49RKdl/i38FGztW4xwlbcGf
	aEbM6KtHXhrOs0zoDyToLEfvXJ/GQA2Hg5kpVbMKqwF4j2LNUTvti0LicD1G3wEsN25bD5
	SFmAbB7XKUMVM9JksUH4oDL7Gkkr0HE=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="dSj9PA/L";
	spf=pass (imf31.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790950904;
	b=4qsnQlTgJ6yp4BYUXShHKvx2a+7VQFaIRmgPc/zSfgfvBUYCKCv6AVgT7X2JsbwygbmJT0
	xQxmjHp1XkCqo3vapPzkvWF/VeqmNCm0myrNpoT+uOZzBqvd4FDva0Ksw8Dr7hM1LYEiCt
	CZZpO+gpKAxHecH3OZL+JNSY0Cz0zXM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45ACE40C38;
	Fri,  2 Oct 2026 14:21:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DF661F000FF;
	Fri,  2 Oct 2026 14:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790950903;
	bh=+f7gBbOphql33Q3z9qijzYQyChgApQkTFAi8r/69YSE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dSj9PA/L2u6jo9z1u1+xXGOd0b46RN4+ABOIYgfMTbCTH5TUJxFeD+he758vhlLJ6
	 7eA8pJKsjgArpERYc1uj+EZ/l8FefKlH395TpTTvHFhm4qCoMF5KId3X//R9z1p/7j
	 70wZAfczigNeHRxm6TlJupLHi5VI9V3X+NvJ8ZLZFOBOnfySKta/PRQcYQerx5OeWT
	 uSRm+TJCaVwDL7g6Hu1zfM0afLXPL+ggJrbwWzqeM0gwze/v9npXMbBVva6stebNfw
	 HAK3t6gLfwT9Qfm6E/2EwwMAGDbnVjqjpyaWs1rrcRcpaKSw7J/enU1qHozKIG5k1t
	 UhXhJ/fCBg77w==
Date: Fri, 2 Oct 2026 15:21:34 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Qiliang Yuan <odys.yuan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	David Hildenbrand <david@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, 
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mm/compaction: stop repeating failed async
 compaction on every THP fault
Message-ID: <ar-8Vkchzn4QobA6@gremlin>
References: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261001-bug-mm-thp-async-compact-defer-v1-0-0174c7923430@gmail.com>
X-Stat-Signature: hzkbypoyt6jwq1ksmxwiypi9q6crwaq6
X-Rspamd-Queue-Id: 110112000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790950903-850731
X-HE-Meta: U2FsdGVkX18J42IEkRmQw/ZfnmZeROGYSmxSQQhJ+1pkInaYE7sKByV/Tuw4eImVyr+rNUSTd0wO8KdfI4daunjZpwddVXZXw3EhNjr8ll4CVVhVfka8d0vUJ6Fwyws9yAf+WaGKpTOn+czaTYIDZP9oQ4MEE+t5mvHiv0FUWJQ/4Hr9zJyQmteqfpwmsy5A7Avk2hecMbwncK70XsIG7zxTpEShwbaJo1ESkS6tWuDxLRdBzwmFXN7T4U1+K0A85SL1AGr2yeQWtxWTfxOuWcz1qwIw9eguVt9wro47TPt1M/effB4hddlNiiv+itBoqxOxpU3wqyRIr+YlkMOnGeB8OAPuAn0De3BjnLRDUwrU0mDUFKJkJ9/BA4bjaX3hZMrcqGRwocuqkSLbbZLxh6NvuF5FB0ICf6SdYw8RgZSDVAtoog6c8RgHgbSMM8daE26bySjpNqs5TohUUPztaciCr4AfIK0b3il0Dt4RfjS/v4QWkaQArD3c/fV6lTlCScUJBAS1KZjUy1HhwaPWJkE9ZTu8zCAc3a3zAaDpZd/v9muobReufTOt4YZlVXF26JxIHTJNnsYCZBIY/HlgDIGL1l2QA3JdQwjSjd3Fc97ugH5XfPkqDaZoR7IjF1Hz1XO2epHahIr7KlHoxz9cmTlZtJH2o1xJnOHnYM1pAtlbl+vazbA7nvfLZaJIGqNIHW6h6ImI4yrjj1yt/yB4UkKzETbGRPfFTLxYWGDwCod1ij82zJdbtLi9UCT74YrzMsTW05fuFo5c1FLwWqKmQM8xn9llwaD0q/W+pRgI2qGnEwLusd/qwAOjhCfF0Wo6/5IJREXXgbfy3HwRdWe5qQtI4ficluNHjzZ2fjF38GG0j25wwbLDSjB8n52wT1a2Acg7KBPlRn1iOi0LEKLOg9HLQuFTcri3MpBx0rZkk1QwShsBXc7lgI/UBXrPz40l6+8dOYToEMkTl1JGw27
 pJbRfGmf
 JosqfWjc8xJc/9+0RLSyWnjhtm9jOMJTBvPMt0CPVtpqEU3w6/u0F52m27HM89PwRdZSa7mJy5igqEFZBQaD01LlFRLoxHRVyZAzomwLHSTCPxc1HeKzqwuTixNlETfCrxsuq40S8a4IRH894jFMCcs8ibRFUNAvgPkLpx7oae/nL5HRDaw8HWXpjHzeUtmymuUOoGb/MadlParArEN2mNxZAyG56K8r3SMeFg1PbLtLI9wJQkxBz2/aLffbhfYI/7t3AecOJhi7T2+wel0WiHrRIv6EUKm3tB5TS5z6bf9giIMz7hQVDqNWe6EGY0Un06Iy3bReaG/kWgiMn6tWTRq01nIqrQPzIrWcZ4oKtE3kd8QIy3/TU2c3A1t9GPaaP/HZeUGHfO83pVUHvva0s6C9PdH20ROUfX+PHxONFLiUFfCA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

NAK.

This series is buggy, and has triggered my AI detection script.

It is kernel policy that you must disclose this with an
Assisted-by tag like:

Assisted-by: LLM

See https://docs.kernel.org/process/coding-assistants.html

It is also kernel policy that you must fully understand and take
responsibility for every patch that you send.

See https://docs.kernel.org/process/generated-content.html most
notably:

        If tools permit you to generate a contribution automatically, expect
        additional scrutiny in proportion to how much of it was generated.

        As with the output of any tooling, the result may be incorrect or
        inappropriate. You are expected to understand and to be able to
        defend everything you submit. If you are unable to do so, then do
        not submit the resulting changes.

        If you do so anyway, maintainers are entitled to reject your series
        without detailed review.

In general, if you are a newcomer to mm, we expect you to do smaller work
before moving on to larger changes, so you build understanding of both the
technical aspects of mm and how we do things.

Given you sent your first mail on 21st September and have since been
spamming complicated series across multiple different domains, I'm
absolutely not confident that you have any understanding of this.

https://lore.kernel.org/all/?q=f%3Aodys.yuan%40gmail.com

It also noted that you had a previous email, realwujing@gmail.com, which
you have silent switched from, which also bore the hallmarks of AI slop.

The script noted:

- Output rate: since 09-28 he has sent KVM SMM CR3/Hyper-V, ext4+jbd2+quota
  "shrinker scan budget accounting" (the same fix applied to three shrinkers;
  jbd2 went v1->v5 in 3 days and v1->v3 in 3 hours), blk-mq SRCU tag sets, a
  blk-mq sync-run, ublk x2, a 4-patch bpf-next verifier rework, mm/migrate
  move_pages (v2 sent 10h after v1) and this series. That is ~9 unrelated deep
  areas in 4 days from someone with 4 commits.

Among many other indicators.

It also found several glaring flaws with your series, so it's clearly not
upstreamable.

I am going to have to ask you to focus on smaller changes as a newcomer,
and to acknowledge any LLM tools you have used, please.

Thanks.

--
Cheers, Lorenzo

