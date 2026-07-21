Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1B68C44515
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 00:00:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED8456B007B; Mon, 20 Jul 2026 20:00:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E61EB6B008A; Mon, 20 Jul 2026 20:00:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29FC6B008C; Mon, 20 Jul 2026 20:00:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A8DAF6B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 20:00:57 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2E9A11402E5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:00:57 +0000 (UTC)
X-FDA: 85010828154.17.EF50D68
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 8AD811C0025
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:00:55 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X04jWm/C";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784592055;
	b=6tSwI2KZ8ityzVecr+iXtEfQe6qSBbRGJN159kRFctKpnJGc8HYdLBYgHZ9lTYI1idFkW/
	gpQ6Df641t6PKe3J1sPG43NlO5PYz6SRzwk+PO1/snboB56hXMMml3MaOb/pag5bBkU2jG
	V+iluDbhd1BrPIFkNfjvJkn45OyaTAk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="X04jWm/C";
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784592055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4wdjW8c1HAVinsR//TSoBy/VK5cUlFr4en6GPrctD8o=;
	b=cBg9QwVEiSXkpOg2QCOm2tC1+XD6s57Y74yXIj69H/9ChEcfgK7n5xkaCkripICRB5V3Yk
	7O9s0bAu8bUoPisEzM7fBRXxAyiRtbNidFQ1oToZ3+j0OH6+JyDLTByM2Ddv/1dw2IT7rh
	4pKTFHUztmhHOsmGdyiL3ca6wcGG3I0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id B0ECB44E9D;
	Tue, 21 Jul 2026 00:00:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44B541F00A3A;
	Tue, 21 Jul 2026 00:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784592054;
	bh=4wdjW8c1HAVinsR//TSoBy/VK5cUlFr4en6GPrctD8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=X04jWm/CZcIpNE4VJdYMUGxH1VsaElK2FXRzzYh/OPqniy0vHlLKcT8+WjsWt9xdu
	 qMvaih8so/D0iLPKRSNaId6J6rCwJhVEmMvjuHz4b9SinZEqTH/a8XvbhA7JpMxvzL
	 +IWLJeZ7XFWIMnVSKFWFmpcykGq7sKoFG0YOh3RkvwCICPG2lt4UhXaURJamBbHfS2
	 hbfE3JJAOMj6W91Vc5CU/ctHlbTd3B0Mpl1M//CBnCTU57m9oOiIvhO+t5hSSwQIQj
	 7ng78oz6hNCxrDSsTWGwttlkw3a4XI4Uvoa3fhKZE4bkU5NNjEk1aDmTFfw/wNQ8nY
	 5pmPllPWQIwxA==
From: SJ Park <sj@kernel.org>
To: Breno Leitao <leitao@debian.org>
Cc: SJ Park <sj@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	paulmck@kernel.org,
	puranjay@kernel.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] mm/kmemleak: report RCU-tasks quiescent states during the scan
Date: Mon, 20 Jul 2026 17:00:46 -0700
Message-ID: <20260721000047.93528-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260720-kmemleak_rcu_task-v1-1-5b460ade777d@debian.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: ru558ddon841mejyupwtcbmpyp6s9tgc
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8AD811C0025
X-Rspam-User: 
X-HE-Tag: 1784592055-173442
X-HE-Meta: U2FsdGVkX18EzrqTjOVXIkEnV9hJCmKdUeOPpKnTHFzfnVGw2KnfeLsDsIGrkHD79v09jmA6Uh1F7uGIL0eoQBqaRcXG0c3CJu2Gvc3JP9madIIkA/1oQsGfBSu5qCKIb6z+MxwyaTX+mVmyxO7Lq95XPkJ7Nf9j6Wnke01+PLAezxM66xk69SopuGZfeEKXyh/O72UAzNvHu+tQmKwqe+p5cRwRQjTzzDpjIN/uvFtK+2pKn4ryS5xp2icM4om/6icClrdUVQHfaVIqokzDfzLx7gkhKVzkQNppwz7Hu12BdgZM3KSjzUT0xFmIWgUNsUnvM9v1P/aLe0c+5UWN7Sb6R8hdADF+xF/srHFGmPKDVRXNZ7foFC7UQQUhNWg4y0KAp7reyQE85AQug3BfptUKXi5IThtW1CMpf9z0AnR8nCzsKyziNF9HZ5erBHa7DGz6OE6KpEsXuFmJIYbXMqyqX4Jf9tgJJNF6mhg8OTNscWm2jFD8g0uV4UFFEyNArM5k7CbwyGCFYJ83jrc3iakl9MDb/MzRSFiRY43RWV4QF9cSLGV883gV32p9TZsc8VYlwrFqYgOHmTLR3VMb9lgZXbA/qg3EIIWJvsKIOHuZHFlP+B3FGvb0Z3MNGeGqRtEy5hqSAtEXRXIrGM8AhafO9uwpG3Hq29zSItNc0dHAM0WOQWM2Z2jgSp4WumJXo8ujqY+QX8iqzNdfVGdRA45ldDUS2zCnLIp0DZRDbE26EOrKidJEjDFQ9R+FWgP3i7Wkk/NBBFpMyKngWU/gF6l87wuPUX8xW7q0ojLmVo8oxI9z8U4g+xIWSeU5XrS3KvhL3/7GYvKz0jR98ROcp1j2XMgadKuzYxU/8IXjx+AmJ3nnqK6d6XnTpFF+ckKrjHgDt5HvSFZB0bUdSLQ/Tr7g0lHIuHpJLGPEWfjTLewsdIOfpi/Ts/2i5IE5Bu2SnM024BMcWjSyTnaWqEL
 X7MrX+ev
 ftIqCo2c0M4nKSZv60zakm62UeiF2Ncm22wq5HBWkw5i4F+VA1qrkZzBY9AGBxuSOqltc0D2DD/yYFcQ42ZcpJk2+m2DAGyFrUGAwlMOwXHibI5NqijuWgneYf6SLQ9p1Qnxt6mi+K1XEL3vA+NOGNt8mlN7Nk5eocUBjX0irxI1gM894hhCWnFYQ3YyeW1dyIQP8/NyE9PWC4on5DlrtDovYkizEFOj9cwhFZe+/TdR/C0Z5Cs640GH8WEDvbZFk5WuM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Jul 2026 06:23:45 -0700 Breno Leitao <leitao@debian.org> wrote:

> kmemleak_scan() can run for ages on large debug kernels. It was
> causing some soft-lockups which I got fixed with commit
> 3175fcfec8b16baeb ("mm/kmemleak: avoid soft lockup when scanning task
> stacks") with our beloved cond_resched().
> 
> I've got the fix above deployed in the Meta fleet, and now I am seeing:
> 
>   INFO: rcu_tasks detected stalls on tasks:
>     task:kmemleak state:R ... nvcsw: 274/274 holdout: 1 idle_cpu: -1/3
>      scan_block
>      scan_gray_list
>      kmemleak_scan
> 
> and, worse, blocks the callers waiting on that grace period. Here a BPF
> struct_ops map free, which waits via synchronize_rcu_mult(call_rcu,
> call_rcu_tasks), is stuck long enough to also trip the hung task check:
> 
>   INFO: task kworker/...:bpf_map_free_deferred blocked for 122 seconds
>      __wait_rcu_gp
>      bpf_struct_ops_map_free
> 
> Then I've learned that cond_resched() is not an RCU-tasks quiescent
> state, so, we need to use stronger primitives.
> 
> Use cond_resched_tasks_rcu_qs() at the scan reschedule points so the scan
> reports an RCU-tasks quiescent state as it proceeds.
> 
> Inspired by commit b96285e10aad ("tracing: Have osnoise_main() add a
> quiescent state for task rcu").

Makes sense to me.

> 
> Signed-off-by: Breno Leitao <leitao@debian.org>

Reviewed-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

