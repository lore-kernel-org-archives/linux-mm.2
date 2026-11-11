Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 361E0606A324
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 09:30:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VbvGLtjy
Received: by kanga.kvack.org (Postfix)
	id 521416B05BD; Wed, 11 Nov 2026 04:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D1186B05BE; Wed, 11 Nov 2026 04:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C00F6B05BF; Wed, 11 Nov 2026 04:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 16AC26B05BD
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 04:30:11 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A0685160257
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:30:11 +0000 (UTC)
X-FDA: 85422317022.05.1A0C0B5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id ECD771C0006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 09:30:09 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VbvGLtjy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794389410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZIHd2FwuKZiOsOtH658bSsqUxwrIHe1owCktrQN4DEE=;
	b=ry9oyjM5yJgO5EFXNyt/nQv7cm1kZ9h0tpa7reOSf50dvWTPOuH3k47X5CK5QQ5TNOawDZ
	rsdZHlFBMmVVJu8W/mSHsmVomsLqeowFJYV8cxN0D8jBWQsocUrx1HXRP15HNNb+dT5grs
	iTKvVzYrAbpkmY6sJqSCUayNzfCgd6Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VbvGLtjy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794389410;
	b=UNHMnLlQtIlgZ93O3QBGGgNdYJmThjDg59fD3CbLNJZ02FBtPyBG4BA1QnFOibD7kJrY65
	h7TukmbZLyxs6YRxUU3gud7yWW+luMFTdybieAj5D6HDXOFfZmbygDPqG8Nnu1wn/3WFks
	WbSxp+HPNmVfKaHNpKpzFM16smt5mgw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D72BA4347D;
	Wed, 11 Nov 2026 09:30:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F1181F00A05;
	Wed, 11 Nov 2026 09:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794389408;
	bh=ZIHd2FwuKZiOsOtH658bSsqUxwrIHe1owCktrQN4DEE=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=VbvGLtjyletvBxjxb6C+b2ZHntXPh6wJa1tqHk8TO88HL7iY4bKi21AjZgy/mxoga
	 4jQrmZlybZLvvzhjqjjO0XyBx0//MstyoBgW+T396BS8ozGxQsyVzND1NOJqUXEdwO
	 1/g8rVUEbUAZYi5voQNgUnWjG6pZV4bzntYGTOiTmKFTsDmsb4jZ3fg5R92+eIQmq+
	 LswmVnxPi8iBtdejNuwQHf0dhY8AxLs7C84E6D1V6wTySn2h+8iT/BRn1qvHn+rXOG
	 ZU+Kx12csTyI+ceLeT2teH4Klohfa8IbVB1ClfFzHm/jey7pjfDy7QIhA8THx+CC91
	 68HtlzzRBjFaA==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Ankur Arora <ankur.a.arora@oracle.com>, 
 Pedro Falcato <pfalcato@suse.de>, Peter Zijlstra <peterz@infradead.org>, 
 Borislav Petkov <bp@alien8.de>, Bharata B Rao <bharata@amd.com>, 
 Hrushikesh Salunke <hsalunke@amd.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Shivank Garg <shivankg@amd.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
References: <20261109-clear-pages-batch-v3-1-6693efe18dff@amd.com>
Subject: Re: [PATCH v3] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
Message-Id: <179438940319.7436.18300143514855352851.b4-ty@b4>
Date: Wed, 11 Nov 2026 10:30:03 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: ECD771C0006
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: agnokr4ix8gyu9hyp9k86qeeimksp334
X-HE-Tag: 1794389409-880984
X-HE-Meta: U2FsdGVkX1+XGh9MxwZXHzK2hlmfLlmN9YTtlJ3s+ZfYSKL0rRJBtANH9OnXabc3NttTdwQwSyLBdzISmFlKGZlPfDmGE3lnTkvQmQ6f9kZ/FR+w9xjAEu6mXZgHvBUBkt68AdDdNPR82F+FqPmPkx9MzW4WJklCtp9htvnJ7Epr0hvEDl0h+92AWXJMpTcIZR7NupQrdCz/jO1ms290fbsFRU58lt2wn5LTAlqO4dTrtHAj1LSJk0y1fsbrsNaCqSqJ3Lhegx+22vZhKc7VkLFCw3UYTyd42xFUeu4GUXktGSx5x4mU+HiIBWUWX78Rz79bgffBW4oCPqsLjf5tg4szu6nUqN0PB5pTEQI05/E83A09wsU/Hvo+LZ8treLk9FWi5zDfQ2N+wrAUQArO2JunyQXRObJL5ObaN0nrP9HsqHWuWYZJNrY0W+UAdwqIbSr5suooqE0ok9ptiQjMkCpCpvdsh91UggtatVXD/hLQQ1282iPjqbH+g+cEFRSLuiex5jICYuA6UPU6NafDbX925HRSRMZxyqDeMdXNYwTxggeG4lvMp+gPhvxitzqohITA+rhabTyUcxW20SW9Ug2JSm+LDbEFvAvaLzueTZn5USAqDrRzUFh5CyAsS5v5VzS5sOkUA2SSPc7E2Q7MW9Npn5ze2HL1kiby0mRu3gsQcQ+5oW8Tc/+STC8vH88RVt5NLRFTL3Z8reVZP4BCvSDhu2FSa0tE9tqe+Ty6onU3OWqdjBgknlU/hgghI7pdT4TdgIlqs8SIp8Q7WFkIgSiAA9qJFvFJTTfh2Po2e0EcSCB1KePudAUs8Mlg4YaoNSqmIH1wR3r8sIis3AGBEXT7DEf+0sIYDbVHxNPi1anuGRR1WvPOJeXKIk6GKTKOCC89ayiJ7838Q1fYGUpBwW4wxKhwnB/TvQ+t0UExRzzaf1XkN/Bp4wjoyl/ODFfMVs4ezKaCCtuKRUE8myu
 8t73I9Hk
 Mkk82jlDvQXF2OdkAaUfqYNaCXSxzHDdo2K0awfn4QkMtUvpyNdsMGmliy6HelHeb1xu3mSNEK8VK4oZtTQgYo6BXByWVpf1rWnfVx9G4uYe9xpTWqwtKJ78ZRx+Mx83BpGXNDkhiRQ00flzm+1U8e/AceZUBKOL8jhH6tKvZmgpl3Yc8Zsc1U7RJH23iKt65g08ZPp2Fi0BODu3r3SZnguWZraszi4xc0Sk+U88+wNdtWpnVd4/ReU1qV/+w4g+HUe3AiHoFofhhbXjXow0NK2tc9wktSKKChWpC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, 09 Nov 2026 19:15:51 +0000, Shivank Garg wrote:
> clear_contig_highpages() clears the whole range at once under
> preemptible models. Otherwise it clears PROCESS_PAGES_NON_PREEMPT_BATCH
> pages at a time, with a cond_resched() in between. The batch is 32MB if
> the architecture defines clear_pages(), and one page otherwise.
> 
> Since commit 7dadeaa6e851 ("sched: Further restrict the preemption
> modes"), architectures that support lazy preemption only offer the
> full, lazy and RT preemption models, also with PREEMPT_DYNAMIC. x86 is
> one of them, and it is the only architecture that defines
> clear_pages(). So the 32MB batch is never used: whenever
> clear_contig_highpages() runs under a cooperative model, the batch is
> one page.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/memory: drop PROCESS_PAGES_NON_PREEMPT_BATCH
      https://git.kernel.org/mm/core/c/6df321a9

-- 
Cheers,

David


